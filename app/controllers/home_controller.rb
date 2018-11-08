class HomeController < ApplicationController
  
  def index
    @money = nil
    if params[:money]
      @name = params[:money][:name]
      h = StartScrap.new(@name)
      h.perform
      h.save
      @money = Money.find_by name: @name
      unless @money
        redirect_to root_path, :flash => { :error => "Erreur de monnaie" }
      end
    end
  end
end
