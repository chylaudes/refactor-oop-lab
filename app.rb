require 'pry'
require 'sinatra'
require 'better_errors'
require 'sinatra/reloader'
require 'pg'

require './models/squad'
require './models/student'

set :conn, PG.connect( dbname: 'weekendlab' )

before do
  @conn = settings.conn
  Squad.conn = @conn
  Student.conn = @conn
end

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = __dir__
end

# SQUAD ROUTES

get '/' do
  redirect '/squads'
end
#shows all the squads
get '/squads' do
  @squads = Squad.all
  erb :'squads/index'
end
#shows a form that creates a new squad
get '/squads/new' do
  erb :'squads/add'
end
#shows the individual squad by its params[:id]
get '/squads/:id' do
  @squad = Squad.find params[:id].to_i
  erb :'squads/show'
end
#shows a form that executes an edit on an existing squad
get '/squads/:id/edit' do
  @squad = Squad.find params[:id].to_i
  erb :'squads/edit'
end
#POST creates the squad
post '/squads' do
  Squad.create params
  redirect '/squads'
end
#UPDATE puts and updates an existing squad
put '/squads/:id' do
  s = Squad.find(params[:id].to_i)
  s.name = params[:name]
  s.mascot = params[:mascot]
  s.save
  redirect '/squads'
end
#DELETE, deletes a squad
delete '/squads/:id' do
  Squad.find(params[:id].to_i).destroy
  redirect '/squads'
end

# STUDENT ROUTES

#shows a all the students by each squad id
get '/squads/:squad_id/students' do
  @students = Squad.find(params[:squad_id].to_i).students
  erb :'students/index'
end
#shows a form that creates a new student under each squad
get '/squads/:squad_id/students/new' do
  @squad_id = params[:squad_id].to_i
  erb :'students/add'
end


#shows an individual student by its squad id
get '/squads/:squad_id/students/:student_id' do

  @student = Student.find params[:student_id].to_i
  erb :'students/show'
end
#shows a form that updates an existing student
get '/squads/:squad_id/students/:student_id/edit' do
  @student = Student.find params[:student_id].to_i
  erb :'students/edit'
end
#POST creates a new student under an existing squad
post '/squads/:squad_id/students' do
  Student.create params
  # @conn.exec('INSERT INTO students (name, age, spirit_animal, squad_id) values ($1,$2,$3,$4)', [ params[:name]  ,params[:age],params[:spirit], params[:squad_id]])
  redirect "/squads/#{params[:squad_id].to_i}"
end
#UPDATE an individual student's info under each squad
put '/squads/:squad_id/students/:student_id' do
  student = Student.find(params[:student_id].to_i)
  student.name = params[:name]
  student.age = params[:age].to_i
  student.spirit_animal = params[:spirit_animal]
  student.save
  redirect "/squads/#{params[:squad_id].to_i}"
end
#DELETE deletes a student
delete '/squads/:squad_id/students/:student_id' do
  Student.find(params[:student_id].to_i).destroy
  redirect "/squads/#{params[:squad_id].to_i}"
end
