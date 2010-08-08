class AccountsController < ApplicationController
  def index
    @accounts = Account.all
  end
  
  def show
    @account = Account.find(params[:id])
  end
  
  def new
    @account = Account.create
    redirect_to @account.authorize(url_for(:action => :create))
  end
  
  def create
    @account = Account.find_by_request_token(params[:oauth_token])
    if @account.exchange_token(params[:oauth_verifier])
      flash[:notice] = "Successfully created account."
      redirect_to accounts_url
    else
      redirect_to new_account_url
    end
  end
  
  def edit
    @account = Account.find(params[:id])
  end
  
  def update
    @account = Account.find(params[:id])
    if @account.update_attributes(params[:account])
      flash[:notice] = "Successfully updated account."
      redirect_to @account
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @account = Account.find(params[:id])
    @account.destroy
    flash[:notice] = "Successfully destroyed account."
    redirect_to accounts_url
  end
end
