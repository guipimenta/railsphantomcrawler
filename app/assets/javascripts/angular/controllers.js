(function(){
  'use strict';
  angular
    .module('StockWatcherApp')
    .controller('WatchController', WatchController)
    .controller('PortifolioController', PortifolioController)
    .controller('StockDetailController', StockDetailController)
    .controller('StockCreateController', StockCreateController);

    WatchController.$inject = ['$interval', 'StockModel', 'StatusModel'];

    function WatchController($interval, StockModel, StatusModel) {
      var vm = this;
      vm.loading = true;
      vm.stocks = [];

      StatusModel.query({}, function(data) {
        vm.status = data;
        updateProgressBar();
      });

      $interval(function () {
        updateProgressBar();
      }, 60000);

      function updateProgressBar() {
        var today = new Date();
        vm.timeToUpdate = (24 - today.getHours());
        vm.percentageToUpdate = (1 - (vm.timeToUpdate / 24)) * 100;
        $('#progress_update').css('width', vm.percentageToUpdate + "%");
      }

      StockModel.query({}, function(data) {
        vm.stocks = data.stocks;
        vm.loading = false;
      });
    }
    PortifolioController.$inject = ['StockModel'];

    function PortifolioController(StockModel){
      var vm = this;

      StockModel.query({}, function(data){
        vm.stock_list = data.stocks;
      });

      vm.deleteStock = function (id) {

        $("#confirmDelete").modal();
        vm.confirmedId = id;
      }

      vm.confirmedDelete = function () {
        var model = new StockModel();
        model.id = vm.confirmedId;
        model.$delete({sname: vm.confirmedId}, function(){
          StockModel.query({}, function(data){
            vm.stock_list = data.stocks;
          });
        });
        $("#confirmDelete").modal("hide");
      }
    }

    StockCreateController.$inject = ['$location', 'StockModel'];

    function StockCreateController ($location, StockModel) {
      var vm = this;
      vm.stockModel = new StockModel();
      vm.createStock = function(name) {
        vm.stockModel.$save(function(data) {
          if(data.status == 200) {
            $location.path('/portifolio');
            console.log("Saved!");
          } else {
            alert("Error!");
          }
        });
        console.log("Name: " + vm.stockName);
      }
    }

    StockDetailController.$inject = ['$routeParams', 'StockModel'];

    function StockDetailController ($routeParams, StockModel) {
      var vm = this;

      StockModel.details({id: $routeParams.id}, function (data){
        vm.stock = data.stock;
        vm.stock_values = data.stock_values;
      });
    }

})();
