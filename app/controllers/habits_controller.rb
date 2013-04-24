class HabitsController < ApplicationController
  
  before_filter :confirm_logged_in
  
  def entry
    show_menu 
    habit_ids = UsersHabit.where("user_id=?", current_user_id).collect {|i| i.habit_id}
    @habits = Habit.order("name ASC").where(:id => habit_ids)
    @user = User.find(current_user_id)
  end
  
  def daily_chart
    @current_user_id = current_user_id
    if cookies[:trend] == '0'
      @single_date = Time.now.to_date
      cookies[:trend] = { :value => '0' }
      if params[:daily_chart]
				@single_date = DateTime.strptime(params[:daily_chart][:date_select], "%m/%d/%Y")
      end
      daily_habits = HabitsUser.where("user_id=?", current_user_id).collect {|i| i.habit_id}
      @habits = Habit.order("name ASC").where(:id => daily_habits)
    end
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def totals
    show_menu  
  end
  
  def new
    @habit = Habit.new
  end
  
  def create
    @habit = Habit.new(params[:habit])
    if @habit.save
      redirect_to root_url, notice: "#{@habit.name} has been added!"
    else
      flash[:notice] = '#{@habit.name} not created.'
      render("create")
    end
  end
  
  def add
    @habit = Habit.find(params[:add][:habit])
    @habit.users << User.find(current_user_id)
    flash[:notice] = "#{@habit.name} recorded!"
    redirect_to(:action => 'entry')
  end
  
  def delete
    @habit = Habit.find(params[:id])
  end

  def destroy
    Habit.find(params[:id]).destroy
    flash[:notice] = "Habit removed."
    redirect_to(:action => 'list')
  end
  
end
