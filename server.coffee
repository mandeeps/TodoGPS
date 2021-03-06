# server.coffee
express = require 'express'
app = express()
passport = require 'passport'
flash = require 'connect-flash'
bcrypt = require 'bcrypt-nodejs'
mongoose = require 'mongoose'
mongoose.connect process.env.MONG
port = process.env.PORT || 8080

allowCORS = (req, res, next) ->
	res.header('Access-Control-Allow-Origin', '*')
	res.header('Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE,OPTIONS')
	res.header('Access-Control-Allow-Headers', 'Content-Type, Authorization, Content-Length, X-Requested-With')

	if ('OPTIONS' == req.method) 
    	res.send 200
    else
    	next()

app.configure ->
	app.use express.static __dirname + '/public'
	app.use express.logger 'dev'
	app.use express.bodyParser()
	app.use express.methodOverride()
	app.use allowCORS
	app.use express.cookieParser()
#	app.set 'view engine', 'ejs'
	app.use express.session secret: 'notsecret'
	app.use passport.initialize()
	app.use passport.session()
	app.use flash()

db = mongoose.connection
db.on 'error', console.error.bind console, 'connection error:'
db.once 'open', () ->

#	userSchema  = mongoose.Scheme 
#		local :
#			email : String,
#			password : String
#
#	userSchema.methods.generateHash = (password) ->
#		bcrypt.hashSync password, bcrypt.genSaltSync(8), null
#
#	userSchema.methods.validPassword = (password) ->
#		bcrypt.compareSync password, this.local.password

	Todo = mongoose.model 'Todo', 
		text: String

	app.get '/api/todos', (req, res) ->
		Todo.find (err, todos) ->
			if err
				res.send err
				console.log res
			res.json todos

	app.post '/api/todos', (req, res) ->
		Todo.create {
			text: req.body.text,
			done: false
		}, (err, todo) ->
			if err
				res.send err
				console.log res

			Todo.find (err, todos) ->
				if err
					res.send err
					console.log res
				res.json todos

	app.delete '/api/todos/:todo_id', (req, res) ->
		Todo.remove {
			_id: req.params.todo_id
		}, (err, todo) ->
			if err
				res.send err
				console.log res

			Todo.find (err, todos) ->
				if err
					res.send err
					console.log res
				res.json todos

	app.get '*', (req, res) ->
		res.sendfile './public/index.html'

	app.listen port
	console.log 'running on ' + port