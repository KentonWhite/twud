class PlayersController < ApplicationController
  
  skip_before_filter :verify_authenticity_token, :login_required 
  
  def register
    @incoming_mail = IncomingMail.new(
      :text => params['text'],
      :html => params['html'],
      :to => params['to'],
      :from => params['from'],
      :subject => params['subject']
    )                              
    
    @incoming_mail.save
    render :xml => @incoming_mail.to_xml, :status => :created 
     
    name = incoming_mail.text.match(/http:\/\/twitter.com\/(.*)/)[1]
    player = Player.new(:name => name)
    player.save if player
  end
end
