/**
 * Every service you use will need to be injected.
 * To do so, add the name as a string to the start of the array,
 * and add the name as a variable to the function.
 */
app.controller('main_controller',['$scope', 'example_service', function($scope, example_service){
	$scope.course = example_service()[0];
	$scope.submission = example_service()[1];
	console.log($scope.example)
}]);