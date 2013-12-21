(function() {
  "use strict";
  var main;

  window.addEventListener('load', function() {
    return FastClick.attach(document.body);
  }, false);

  main = angular.module('TodoGPS', []);

  main.controller('mainController', function($scope, $http) {
    $scope.formData = {};
    $http.get('/api/todos').success(function(data) {
      return $scope.todos = data;
    }).error(function(data) {
      return console.log(data);
    });
    $scope.createTodo = function() {
      return $http.post('/api/todos', $scope.formData).success(function(data) {
        $scope.formData = {};
        return $scope.todos = data;
      }).error(function(data) {
        return console.log(data);
      });
    };
    return $scope.deleteTodo = function(id) {
      return $http["delete"]('/api/todos/' + id).success(function(data) {
        return $scope.todos = data;
      });
    };
  });

}).call(this);
