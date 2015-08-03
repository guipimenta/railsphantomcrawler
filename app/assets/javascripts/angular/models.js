(function(){
  'use strict';
  angular
    .module('StockWatcherApp')
    .factory('StockModel', StockModel)
    .factory('StatusModel', StatusModel);

    StockModel.$inject = ['$resource'];

    function StockModel ($resource) {
       return $resource('stock/:sname', {}, {
         query: {method:'GET', params:{sname: ''}},
         details: {url: "/stock/info/:id", method: 'GET', params:{id: ''}}
       });
    }

    StatusModel.$inject = ['$resource'];

    function StatusModel ($resource) {
      return $resource('stock/status', {}, {
        query: {url: 'stock/status', method:'GET'}
      });
    }


})();
