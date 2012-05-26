require 'date'
require 'test/unit'

require 'nokogiri'

require 'adium2gmail'

class TestAdium2Gmail < Test::Unit::TestCase

  def test_create_message
    current_time = DateTime.parse("2012/04/12 09:30")
    nickname = "Test"
    message_tag = Nokogiri::XML("<div><span style='bold'>test message</span></div>")

    message = Adium2Gmail.create_message current_time, nickname, message_tag

    target_result = %q{
      <div><span style="display:block;float:left;color:#888">09:30 AM</span>
        <span style="display:block;padding-left:6em">
          <span style="bold">
            <span style="font-weight:bold">Test:</span>
            test message
          </span>
        </span>
      </div>}

    assert_equal message.gsub(/\s+/, ""), target_result.gsub(/\s+/, "")
  end

  def test_create_email
    
  end

end