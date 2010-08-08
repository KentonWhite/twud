class AccountsController < ApplicationController
  def index
    @accounts = Account.all
  end
  
  def show
    @account = Account.find(params[:id])
  end
  
  def new
    @account = Account.new
    redirect_to @account.authorize_url(accounts_url(:method => :post))
  end
  
  def create
    @account = Account.new(params[:account])
    if @account.save
      flash[:notice] = "Successfully created account."
      redirect_to @account
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
