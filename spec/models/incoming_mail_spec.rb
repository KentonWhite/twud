require 'spec_helper'

describe IncomingMail do
  def new_mail(attributes = {})
    attributes[:to] ||= 'bar@example.com'
    attributes[:from] ||= 'foo@example.com'
    attributes[:subject] ||= 'Sample Subject'
    attributes[:text] ||= 'Sample Text'  
    attributes[:html] ||= '<p>Sample Text</p>'
    IncomingMail.new(attributes)
  end
  
  before(:each) do
    IncomingMail.delete_all
  end
  
  it "should be valid" do
    new_mail.should be_valid
  end
end

