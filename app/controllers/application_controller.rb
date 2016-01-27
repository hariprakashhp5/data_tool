class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


def update_database
    puts "updating local database"
      @pack=Pack.new(:region_id=>params[:region_id], :operator_id=>params[:operator_id], :connection_type=>params[:connection_type], 
      	:pack_type=>params[:pack_type], :price=>@price, :offer=>@offer, :validity=>@validity, :description=>nil, :tag=>@name, :caty=>@caty)
      @pack.save
 end




end
