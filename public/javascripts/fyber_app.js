'use strict';

angular.module('fyberApp', ['ui.bootstrap']).controller('offersCtrl', function ($scope, $location, $http) {
    $scope.offersQuery = {};

    $scope.submitButton = { title: 'Get Offers!' };
    $scope.inProgress = false;

    $scope.getOffers = function(){
        $scope.inProgress = true;
        $scope.submitButton.title = 'Loading...';

        $http({ url: '/offers.json', method: 'GET', params: $scope.offersQuery}).
            success(function(data, status, headers, config) {
                $scope.submitButton.title = 'Get Offers!';
                $scope.inProgress = false;
                $scope.offers = data.offers;
            }).
            error(function(data, status, headers, config) {
                $scope.submitButton.title = 'Get Offers!';
                $scope.inProgress = false;
                $scope.offers = [];

                // log error
            });
    }
});