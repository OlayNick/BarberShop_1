
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'
#require 'pony'

def get_db
	SQLite3::Database.new 'barbershop.db'
end

def get_barbers_db
	SQLite3::Database.new 'barbers.db'
end

configure do
	get_db.execute 'CREATE TABLE IF NOT EXISTS "Users"
		(
			"id" INTEGER PRIMARY KEY AUTOINCREMENT,
			"username" TEXT,
			"phone" TEXT,
			"datestamp" TEXT,
			"barber" TEXT,
			"color" TEXT
		)'

	get_barbers_db.execute 'CREATE TABLE IF NOT EXISTS "Barbers"
		(
			"id" INTEGER PRIMARY KEY AUTOINCREMENT,
			"barber" TEXT UNIQUE
		)'

	 	
end

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/about' do
	erb :about
end

get '/visit' do
	@bb = get_barbers_db.execute 'select barber from Barbers'
	erb :visit
end

get '/contacts' do
	erb :contacts
end

get '/showusers' do
	results = get_db.execute 'select * from Users order by id desc'
	visitline = ''
	results.each do |row|
	row = row.join(",  ") 
	visitline += "#{row}<br/>"
	end
	erb visitline
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

