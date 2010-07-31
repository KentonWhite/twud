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
  end
end
