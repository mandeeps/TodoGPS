# server.coffee
express = require 'express'
app = express()
mongoose = require 'mongoose'
mongoose.connect 'mongodb://127.0.0.1:27017/todogps' #process.env.MONG
port = process.env.PORT || 8080

app.configure ->
	app.use express.static __dirname + '/public'
	app.use express.logger 'dev'
	app.use express.bodyParser()
	app.use express.methodOverride()

db = mongoose.connection
db.on 'error', console.error.bind console, 'connection error:'
db.once 'open', () ->

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