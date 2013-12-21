"use strict"

window.addEventListener 'load', ->
  FastClick.attach document.body
,false

main = angular.module('TodoGPS',[])

main.controller 'mainController', ($scope, $http) ->
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