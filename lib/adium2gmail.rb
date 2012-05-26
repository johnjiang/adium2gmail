require "adium2gmail/version"
require 'date'
require 'find'

require 'mail'
require 'nokogiri'

module Adium2Gmail
  def self.create_email(from_email, to_email, f, chat_date)
    email_body = get_email_body f

    mail = Mail.new do
      from from_email
      to to_email
      subject "Chat with #{to_email}"

      content_type 'text/html; charset=UTF-8'
      body email_body
    end
    header = "From - " + chat_date.strftime("%a %b %d %H:%M:%S %Y")
    header += "Date: " + chat_date.strftime("%a, %d %b %Y %H:%M:%S %z")
    header + "\n" + mail.to_s.split("\n")[1..-1].join("\n") + "\n\n\n"
  end

  def self.get_email_body(f)
    messages = ''
    
    doc = Nokogiri::XML(File.open(f, "r"))
    
    doc.remove_namespaces! #stupid namespaces

    doc.xpath("//message").each do | message |
      datetime = DateTime.parse(message.xpath("@time").text)
      nickname = message.xpath("@alias").text
      nickname = message.xpath("@sender").text if nickname.blank?

      messages << create_message(datetime, nickname, message)
    end

    return messages
  end

  def self.create_message(date, nickname, message_tag)
    time = date.strftime("%I:%M %p")

    message_tag = message_tag.xpath("div/span")
    
    #Not sure why I do the gsub here. I did it in python but didn't comment :(
    #But I'm sure I did it for a good reason
    message = message_tag.text.gsub("&apos;", "&#39;")

    message_style = message_tag.xpath("@style").text

    div = %Q{
      <div><span style="display:block;float:left;color:#888">#{time}</span>
        <span style="display:block;padding-left:6em">
          <span style="#{message_style}">
            <span style="font-weight:bold">#{nickname}:</span>
            #{message}
          </span>
        </span>
      </div>}
  end

  def self.process_adium_chatlogs(input, output_path)
    File.open output_path, "w" do |output_file|
      Find.find(input) do |f|
        if f.match(/\.chatlog.*?\.xml\Z/) && ! f.include?("msn chat") #skipping multiple conversations for now
          from_email = File.basename(File.dirname(File.dirname(File.dirname(f)))).sub(/.*?\./, "") #this is somewhat hacky...
          to_email, chat_date = File.basename(f, ".xml").split()
          chat_date = DateTime.parse(chat_date.gsub!(".", ":"))

          output_file.puts create_email(from_email, to_email, f, chat_date)
        end
      end 
    end
  end  
end
