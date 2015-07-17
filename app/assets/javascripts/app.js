var app = angular.module('StockWatcherApp', ['ngResource']);

app.factory('Stock', ['$resource',
  function($resource){
    return $resource('stock/:sname', {}, {
      query: {method:'GET', params:{sname: ''}, isArray:true},
    });
  }]);

app.controller('WatchController', ['$scope', 'Stock', function($scope, Stock){

	$scope.wellcome = "Wellcome to angular!";
	$scope.loading = false;
	$scope.search = function(){
		$scope.loading = true;
		Stock.get({sname: $scope.stockname},function(data){
			$scope.quotes = data.quotes;
			$scope.name = data.name;
			$scope.loading = false;
		},function(err){
			console.log(err);
		});
	}
	
	
}])