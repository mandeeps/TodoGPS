(function() {
  var app, db, express, mongoose, port;

  express = require('express');

  app = express();

  mongoose = require('mongoose');

  mongoose.connect('mongodb://127.0.0.1:27017/todogps');

  port = process.env.PORT || 8080;

  app.configure(function() {
    app.use(express.static(__dirname + '/public'));
    app.use(express.logger('dev'));
    app.use(express.bodyParser());
    return app.use(express.methodOverride());
  });

  db = mongoose.connection;

  db.on('error', console.error.bind(console, 'connection error:'));

  db.once('open', function() {
    var Todo;
    Todo = mongoose.model('Todo', {
      text: String
    });
    app.get('/api/todos', function(req, res) {
      return Todo.find(function(err, todos) {
        if (err) {
          res.send(err);
          console.log(res);
        }
        return res.json(todos);
      });
    });
    app.post('/api/todos', function(req, res) {
      return Todo.create({
        text: req.body.text,
        done: false
      }, function(err, todo) {
        if (err) {
          res.send(err);
          console.log(res);
        }
        return Todo.find(function(err, todos) {
          if (err) {
            res.send(err);
            console.log(res);
          }
          return res.json(todos);
        });
      });
    });
    app["delete"]('/api/todos/:todo_id', function(req, res) {
      return Todo.remove({
        _id: req.params.todo_id
      }, function(err, todo) {
        if (err) {
          res.send(err);
          console.log(res);
        }
        return Todo.find(function(err, todos) {
          if (err) {
            res.send(err);
            console.log(res);
          }
          return res.json(todos);
        });
      });
    });
    app.get('*', function(req, res) {
      return res.sendfile('./public/index.html');
    });
    app.listen(port);
    return console.log('running on ' + port);
  });

}).call(this);
