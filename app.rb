
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'
#require 'pony'

def is_barber_exists? db, name
	db.execute('select * from Barbers where name=?', [name]).length > 0
end

def seed_db db, barbers

	barbers.each do |barber|
		if !is_barber_exists? db, barber
			db.execute 'insert into Barbers (name) values (?)', [barber]
		end 
	end

end

def get_db
	db = SQLite3::Database.new 'Users.db'
	db.results_as_hash = true
	return db
end

before do
	db = get_db
	@barbers = db.execute 'select * from Barbers'
end

configure do
	db = get_db
	db.execute 'CREATE TABLE IF NOT EXISTS "Users"
		(
			"id" INTEGER PRIMARY KEY AUTOINCREMENT,
			"username" TEXT,
			"phone" TEXT,
			"datestamp" TEXT,
			"barber" TEXT,
			"color" TEXT
		)'

	db.execute 'CREATE TABLE IF NOT EXISTS "Barbers"
		(
			"id" INTEGER PRIMARY KEY AUTOINCREMENT,
			"name" TEXT 
		)'

	seed_db db, ['Jessie Pinkman', 'Walter White', 'Gus Fring', 'Mike Ehrmantraut']
	 	
end

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/about' do
	erb :about
end

get '/visit' do
	erb :visit
end

get '/contacts' do
	erb :contacts
end

get '/showusers' do
	db = get_db
	@results = db.execute 'select * from Users order by id desc'
	erb :showusers
end

post '/visit' do
	@username = params[:username]
	@phone = params[:phone]
	@datetime = params[:datetime]
	@barber = params[:barber]
	@color = params[:color]
	@title = "Yoooppy!"
	@message = "Dear #{@username}, thank you very much for choosing us!"

	# хеш
	hh = { 	:username => 'Enter name',
			:phone => 'Enter phone',
			:datetime => 'Enter date and time' }

	hh.each do |k, v|
		if params[k] == ''
			@error = v
			return erb :visit

	#@error = hh.select {|key,_| params[key] == ""}.values.join(", ")

	#if @error != ''
		#return erb :visit
		end
	end
	
	get_db.execute 'insert into
		Users
		(
			username,
			phone,
			datestamp,
			barber,
			color
		)
		values (?, ?, ?, ?, ?)', [@username, @phone, @datetime, @barber, @color]

		get_barbers_db.execute 'insert or ignore into Barbers (barber) values (?)', [@barber]

	erb :message
end

post '/contacts' do
		@email = params[:email]
		@body = params[:body]
	
		f = File.open 'public/contacts.txt', 'a'
		f.write "#{@email}<br/>\n"
		f.close
		@title = "Thanks!"
		@message = "We will try to respond as soon as!"

		hh = { 	:email => 'Enter your E-mail', :body => 'Enter text' }

		hh.each do |k, v|
			if params[k] == ''
				@error = v
				return erb :contacts

		#@error = hh.select {|key,_| params[key] == ""}.values.join(", ")

		#if @error != ''
			#return erb :visit
			end
		end
		erb :message
	
		require 'pony'
		Pony.mail(
	   		:to => 'kolololya@gmail.com',
	  		:subject => "Message from #{@email}",
	  		:body => params[:body],
	  		:via => :smtp,
	  		:via_options => { 
	  			:address              => 'smtp.gmail.com', 
	   			:port                 => '587', 
	    		:enable_starttls_auto => true, 
	    		:user_name            => 'kolololya', 
	    		:password             => 'rj16kz11', 
	    		:authentication       => :plain, 
	    		:domain               => 'localhost.localdomain'
	  			})
		erb :message
end

