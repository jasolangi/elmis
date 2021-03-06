/**
 * Created with IntelliJ IDEA.
 * User: issa
 * Date: 3/16/14
 * Time: 9:08 PM
 * To change this template use File | Settings | File Templates.
 */

function StockedOutController($scope, $location,  dashboardMenuService,programsList,FlatGeographicZoneList,UserGeographicZoneTree, formInputValue,GetPeriod,dashboardFiltersHistoryService,userPreferredFilterValues,ReportSchedules, ReportPeriods, ReportProductsByProgram, OperationYears, ReportPeriodsByScheduleAndYear,StockedOutFacilities, ngTableParams) {
    $scope.filterObject = {};

    $scope.formFilter = {};

    $scope.formPanel = {openPanel:true};

    $scope.alertsPanel = {openAlertPanel:true, openStockPanel:true};

    initialize();

    function initialize() {

        $scope.showProductsFilter = true;
        $scope.$parent.currentTab = 'STOCK-OUT';

        $scope.productSelectOption = {maximumSelectionSize : 1};

    }
    FlatGeographicZoneList.get(function (data) {
        $scope.geographicZones = data.zones;
    });

    $scope.programs = programsList;
    $scope.programs.unshift({'name': formInputValue.programOptionSelect});

    $scope.loadGeoZones = function(){
        UserGeographicZoneTree.get({programId:$scope.formFilter.programId}, function(data){
            $scope.zones = data.zone;
        });
    };

    OperationYears.get(function (data) {
        $scope.startYears = data.years;
        $scope.startYears.unshift(formInputValue.yearOptionAll);
    });


    ReportSchedules.get(function(data){
        $scope.schedules = data.schedules;
        $scope.schedules.unshift({'name': formInputValue.scheduleOptionSelect}) ;

    });

    $scope.filterProductsByProgram = function (){
        $scope.loadGeoZones();
        $scope.filterObject.programId = $scope.formFilter.programId;

        $scope.formFilter.programName = getSelectedItemName($scope.formFilter.programId, $scope.programs);

        if(!isUndefined($scope.formFilter.programId)){
            ReportProductsByProgram.get({programId:  $scope.filterObject.programId}, function(data){
                $scope.products = data.productList;
            });
        }else{
            $scope.products = undefined;
            $scope.formFilter.productIdList = undefined;
            $scope.processProductsFilter();
        }

        $scope.loadStockedOutData();

    };

    $scope.processZoneFilter = function(){
        $scope.filterObject.zoneId = $scope.formFilter.zoneId;
        $scope.formFilter.zoneName = getSelectedZoneName($scope.formFilter.zoneId, $scope.zones, $scope.geographicZones);

        $scope.loadStockedOutData();
    };

    $scope.processProductsFilter = function (){

        $scope.filterObject.productIdList = $scope.formFilter.productIdList;
        $scope.loadStockedOutData();

    };

    $scope.changeSchedule = function(){

        if (!isUndefined($scope.formFilter.scheduleId)) {
            $scope.filterObject.scheduleId = $scope.formFilter.scheduleId;
        }

        if(!isUndefined($scope.filterObject.scheduleId) ){
            if(!isUndefined($scope.filterObject.year) ){
                ReportPeriodsByScheduleAndYear.get({scheduleId: $scope.filterObject.scheduleId, year: $scope.filterObject.year}, function(data){
                    $scope.periods = data.periods;
                    $scope.periods.unshift({'name':formInputValue.periodOptionSelect});
                });
            }else{
                ReportPeriods.get({ scheduleId : $scope.filterObject.scheduleId },function(data) {
                    $scope.periods = data.periods;
                    $scope.periods.unshift({'name': formInputValue.periodOptionSelect});

                });
            }

        }

        $scope.loadStockedOutData();
    };


    $scope.processPeriodFilter = function (){
        if (!isUndefined($scope.formFilter.periodId)) {
            $scope.filterObject.periodId = $scope.formFilter.periodId;
        }
        $scope.formFilter.periodName = getSelectedItemName($scope.formFilter.periodId, $scope.periods);

        $scope.loadStockedOutData();

    };

    $scope.changeScheduleByYear = function (){

        if (!isUndefined($scope.formFilter.year)) {
            $scope.filterObject.year = $scope.formFilter.year;

        }
        $scope.changeSchedule();

    };

    $scope.stockedOutPieChartOption = {
        series: {
            pie: {
                show: true,
                radius: 1,
                label: {
                    show: true,
                    radius: 2 / 3,
                    formatter: function (label, series) {
                        return '<div style="font-size:8pt;text-align:center;padding:2px;color:black;">' + Math.round(series.percent) + '%</div>';
                    },
                    threshold: 0.1
                }
            }
        },
        legend: {
            container:$("#stockedOutReportLegend"),
            noColumns: 1,
            labelBoxBorderColor: "none"
        },
        grid:{
            hoverable: true,
            clickable: true,
            borderWidth: 1,
            borderColor: "#d6d6d6",
            backgroundColor: {
                colors: ["#FFF", "#CCC"]
            }
        },
        tooltip: true,
        tooltipOpts: {
            content: "%p.0%, %s",
            shifts: {
                x: 20,
                y: 0
            },
            defaultTheme: false
        }
    };

    $scope.loadStockedOutData = function(){
        getFilterValues();
        if(!isUndefined($scope.filterObject.programId) &&
            !isUndefined($scope.filterObject.periodId) &&
            !isUndefined($scope.filterObject.productIdList) && $scope.filterObject.productIdList.length > 0){
            StockedOutFacilities.get({
                periodId: $scope.filterObject.periodId,
                programId: $scope.filterObject.programId,
                productId: $scope.filterObject.productIdList[0],
                zoneId: $scope.filterObject.zoneId
            },function(stockData){
                $scope.totalStockOuts = 0;
                if(!isUndefined(stockData.stockOut)){
                    $scope.datarows = stockData.stockOut;

                    $scope.districts = _.pairs(_.object(_.range(stockData.stockOut.length), _.pluck(stockData.stockOut,'geographicZoneId')));
                    $scope.stockedOutPieChartData = [];
                    for (var i = 0; i < stockData.stockOut.length; i++) {
                        $scope.totalStockOuts += stockData.stockOut[i].totalStockOut;
                        $scope.stockedOutPieChartData[i] = {
                            label: stockData.stockOut[i].location,
                            data: stockData.stockOut[i].totalStockOut
                        };
                    }

                    bindChartEvent("#stocked-out-reporting","plotclick",$scope.stockedOutChartClickHandler);
                    bindChartEvent("#stocked-out-reporting","plothover",flotChartHoverCursorHandler);

                }else{
                    $scope.resetStockedOutData();
                }

            });
        } else{
            $scope.resetStockedOutData();

        }
    };

    $scope.getFacilityStockOutPercent = function(value){
        return Math.round((value/$scope.totalStockOuts)*100) +'%';
    };

    $scope.resetStockedOutData = function(){
        $scope.stockedOutPieChartData = null;
        $scope.datarows = null;
    };

    $scope.stockedOutChartClickHandler = function (event, pos, item){
        if(item){
            var rgroupId = $scope.districts[item.seriesIndex][1];
            var districtStockOutPath = '/district-stock-out/'+$scope.filterObject.programId+'/'+$scope.filterObject.periodId+'/'+rgroupId+'/'+$scope.filterObject.productIdList[0];
            dashboardMenuService.addTab('menu.header.dashboard.stocked.out.district','/public/pages/dashboard/index.html#'+districtStockOutPath,'DISTRICT-STOCK-OUT',true, 4);

            $location.path(districtStockOutPath);
            $scope.formFilter.isNavigatedBack = true;
            $scope.setFilterData();
            $scope.$apply();
        }

    };

    $scope.setFilterData = function(){

        var data = {};
        $scope.filterObject = $scope.formFilter;
        angular.extend(data,$scope.filterObject);

        dashboardFiltersHistoryService.add($scope.$parent.currentTab,data);
    };

    function flotChartHoverCursorHandler(event,pos,item){

        if (item && !isUndefined(item.dataIndex)) {
            $(event.target).css('cursor','pointer');
        } else {
            $(event.target).css('cursor','auto');
        }
    }

    function bindChartEvent(elementSelector, eventType, callback){
        $(elementSelector).bind(eventType, callback);
    }

    $scope.$on('$viewContentLoaded', function () {
        var filterHistory = dashboardFiltersHistoryService.get($scope.$parent.currentTab);

        if(isUndefined(filterHistory)){
            if(!_.isEmpty(userPreferredFilterValues)){
                var date = new Date();

                $scope.filterObject.programId = isItemWithIdExists(userPreferredFilterValues[localStorageKeys.PREFERENCE.DEFAULT_PROGRAM], $scope.programs) ?
                    userPreferredFilterValues[localStorageKeys.PREFERENCE.DEFAULT_PROGRAM] : $scope.filterObject.programId;

                $scope.filterObject.periodId = userPreferredFilterValues[localStorageKeys.PREFERENCE.DEFAULT_PERIOD];

                if(!isUndefined($scope.filterObject.periodId)){

                    GetPeriod.get({id:$scope.filterObject.periodId}, function(period){
                        if(!isUndefined(period.year)){
                            $scope.filterObject.year = period.year;
                        }else{
                            $scope.filterObject.year = date.getFullYear() - 1;
                        }

                        $scope.changeSchedule();
                    });
                }
                $scope.filterObject.scheduleId = userPreferredFilterValues[localStorageKeys.PREFERENCE.DEFAULT_SCHEDULE];

                $scope.filterObject.zoneId = userPreferredFilterValues[localStorageKeys.PREFERENCE.DEFAULT_GEOGRAPHIC_ZONE];
                $scope.filterObject.productIdList = [userPreferredFilterValues[localStorageKeys.PREFERENCE.DEFAULT_PRODUCT]];

                $scope.registerWatches();

                $scope.formFilter = $scope.filterObject;

            }
        }else{

            $scope.registerWatches();
            $scope.formFilter = $scope.filterObject = filterHistory;

        }

    });
    $scope.registerWatches = function(){

        $scope.$watch('formFilter.programId',function(){
            $scope.filterProductsByProgram();

        });
        $scope.$watch('formFilter.scheduleId', function(){
            $scope.changeSchedule();

        });

    };

    var getFilterValues = function(){

        $scope.formFilter.periodName = getSelectedItemName($scope.formFilter.periodId,$scope.periods);
        $scope.formFilter.programName = getSelectedItemName($scope.formFilter.programId,$scope.programs);

        $scope.formFilter.zoneName = getSelectedZoneName($scope.formFilter.zoneId, $scope.zones, $scope.geographicZones);

        $scope.filterObject = $scope.formFilter;

    };

    $scope.$on('$routeChangeStart', function(){
       $scope.setFilterData();
    });


    $scope.tableParams = new ngTableParams({
        page: 1,            // show first page
        total: 0,           // length of data
        count: 25           // count per page
    });


}