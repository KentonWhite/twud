require 'spec_helper'

describe PlayersController, 'register' do
  fixtures :incoming_mails

  before(:each) do
    Player.delete_all
  end
  
  it 'should register new player' do
    mail = incoming_mails(:new_twitter)
    proc {
      post :register, :text => mail[:text]
    }.should change(Player, :count).by(1)
  end
  
  it 'should not register new player' do
    mail = incoming_mails(:new_non_twitter)
    proc {
      post :register, :text => mail[:text]
    }.should_not change(Player, :count)    
  end 
  
  it 'should return success' do
    Player.any_instance.stubs(:save).returns(true)
    post :register
    response.should be_success 
  end 
end
