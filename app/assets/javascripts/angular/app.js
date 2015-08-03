(function(){
  'use strict';
  angular
    .module('StockWatcherApp', [
      'ngResource',
      'ngRoute',
      'mgcrea.ngStrap'
    ])
    .config(config);

    function config($routeProvider) {
    $routeProvider
        .when('/portifolio', {
            templateUrl: 'assets/partials/stocks/portifolio.html',
            controller: 'PortifolioController',
            controllerAs: 'vm'
        })
        .when('/new', {
          templateUrl: 'assets/partials/stocks/new.html',
          controller: 'StockCreateController',
          controllerAs: 'vm'
        })
        .when('/detalhes/:id', {
          templateUrl: 'assets/partials/stocks/details.html',
          controller: 'StockDetailController',
          controllerAs: 'vm'
        })
        .when('/', {
          templateUrl: 'assets/partials/stocks/index.html'
        })
        .otherwise({
          redirectTo: '/'
        });
    }

})();
