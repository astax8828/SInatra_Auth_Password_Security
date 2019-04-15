#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'
require 'email_validator'

configure do
  enable :sessions
end

# Подключение к базе
configure :development do
  set :database, {adapter: 'postgresql', encoding: 'UTF-8', database: 'Users_DB', pool: 2, username: 'astax8828', password: '4993849'}
end

configure :production do
  set :database, {adapter: 'postgresql', encoding: 'UTF-8', database: 'Users_DB', pool: 2, username: 'astax8828', password: '4993849'}
end

# Создаем пользовательскую модель user

class User < ActiveRecord::Base
  # включаем has_secure_password для шифрования
  has_secure_password
  # Валидация формы регистрации
  validates :login, presence: true, length: {minimum: 3}
  validates :email, email: true
  validates :password, presence: true, length: {minimum: 8}
  validates :password_confirmation, presence: true, length: {minimum: 8}
  validates_uniqueness_of :email
end


# Маршрут home
get '/' do

  erb :home
end

# Маршрут signup регистрации пользователей
get '/signup' do
# Если выполнен вход происходит переадресация на страницу пользователя
  if session[:user_id] != nil
    redirect '/user/' + User.find(session[:user_id]).login
  end

  @user = User.new
  # Записываем сообщение ошибки валдации и передаем в шаблон signup
  @error = @user.errors.messages
  erb :signup
end

#Маршрут post signup, получаем и записываем данные формы регистрации
post '/signup' do

  # Записываем данные из формы регистрации в таблицу бд
  @user = User.new(params[:user_reg])

  if @user.save
    #сохраняем id пользователя в куки
    session[:user_id] = @user.id
    redirect '/'
  else
    # записываем сообщение об ошибке и передаем в шаблон "signup"
    @error = @user.errors.messages
    erb :signup
  end
end


# Маршрут login для входа пользователей
get '/login' do
# Если выполнен вход происходит переадресация на страницу пользователя
  if session[:user_id] != nil
    redirect '/user/' + User.find(session[:user_id]).login
  end
  erb :login
end

#Маршрут post login, получаем и записываем данные формы входа
post '/login' do

  user = User.find_by(email: params["email"])

  if user && user.authenticate(params[:password])
    session[:user_id] = user.id
    redirect '/user/' + User.find(session[:user_id]).login
  else
    redirect "/failure"
  end
  redirect '/login'
end

get '/user/:name'  do
  
  erb :user
end

# Выход пользователя
get '/logout' do
  session.clear
  redirect '/'
end