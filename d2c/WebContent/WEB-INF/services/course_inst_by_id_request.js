app.factory('course_inst_by_id_request', ['$q', '$http', function($q,$http){
	return function(refId){
		var deferred= $q.defer();
		$http({
			method: 'GET',
			url:'/d2c/course_inst/refid/'+refId,
			headers: {
				'access-control-allow-origin': '*'
			}
		}).then(function(response){
			deferred.resolve(response);
		},function(response){
			deferred.reject(response);
		});
		return deferred.promise;
	}
}]);