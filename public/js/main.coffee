"use strict"

window.addEventListener 'load', ->
  FastClick.attach document.body
,false

main = angular.module('TodoGPS',[])

main.service 'sharedData', ->
  this.view = 'partials/about.html'

main.controller 'Partials', ($scope, sharedData) ->
  $scope.data = sharedData

main.controller 'about', ($scope, $http, sharedData) ->
  $scope.login = ->
    if $scope.email?
      $http.post('/api/users/' + $scope.email)
      .success (data) ->
        console.log 'Succcess: ' + data
        sharedData.view = 'partials/todo.html'
      .error (err) ->
        console.log 'Error getting this users data: ' + err

  $scope.newUser = ->
    sharedData.view = 'partials/todo.html'

main.controller 'Todo', ($scope, $http) ->
  navigator.geolocation.watchPosition (position) ->
    $scope.loc = position.coords
    console.log position.coords

  $scope.formData = {}

  $http.get('/api/todos')
  .success (data) ->
    $scope.todos = data
  .error (data) ->
    console.log data

  $scope.createTodo = ->
    $http.post('/api/todos', $scope.formData)
    .success (data) ->
      $scope.formData = {}
      $scope.todos = data

    .error (data) ->
      console.log data

  $scope.deleteTodo = (id) ->
    $http.delete('/api/todos/' + id)
    .success (data) ->
      $scope.todos = data