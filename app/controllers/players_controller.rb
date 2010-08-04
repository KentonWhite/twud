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
    match, name = '', ''
    match = @incoming_mail.text.match(/http:\/\/twitter.com\/(.*)/) unless @incoming_mail.text.blank?
    name = match[1] unless match.blank?
    player = Player.new(:name => name)
    player.save
    render(:xml => @incoming_mail.to_xml, :status => :ok)
  end
end
