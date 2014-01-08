"use strict"

window.addEventListener 'load', ->
  FastClick.attach document.body
,false

main = angular.module('TodoGPS',[])

main.service 'sharedData', ->
  this.view = 'partials/about.html'

main.controller 'Partials', ($scope, sharedData) ->
  $scope.data = sharedData

main.controller 'about', ($scope, sharedData) ->
  $scope.login = ->
    sharedData.view = 'partials/todo.html'
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