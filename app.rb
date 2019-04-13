#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'

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

# Создаем сущность

class User < ActiveRecord::Base
end


# Маршрут home
get '/' do

  erb :home
end

# Маршрут signup регистрации пользоваателей
get '/signup' do

  erb :signup
end

#Маршрут post signup, получаем данные формы регистрации
post '/signup' do

end


# Маршрут login для входа пользоваателей
get '/login' do

  erb :signup
end

#Маршрут post login, получаем данные формы входа
post '/login' do

end



