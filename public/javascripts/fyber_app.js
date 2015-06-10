'use strict';

angular.module('fyberApp', []).controller('offersCtrl', function ($scope, $location, $http) {
    $scope.offersQuery = {};

    $scope.getOffers = function(){
        $http.get('/offers.json').
            success(function(data, status, headers, config) {
                $scope.offers = data;
            }).
            error(function(data, status, headers, config) {
                // log error
            });
    }
});