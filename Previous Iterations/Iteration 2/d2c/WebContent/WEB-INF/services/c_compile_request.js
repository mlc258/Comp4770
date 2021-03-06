/**
 * 
 */
app.factory('c_compile_request',[ '$q', '$http', function($q, $http){
	return function(code, user, path){
		var deferred = $q.defer();
		var path_arg = path
		if(path === ""){
			path_arg = "default";
		}
		console.log('/d2c/code/'+user+'/'+path_arg.split("/").join("_")+'/c');
		$http({
			method: 'POST',
			url: '/d2c/code/'+user+'/'+path_arg.split("/").join("_")+'/c',
			headers: {
				'Content-Type': 'application/json;charset=utf-8;',
				'accept': 'text/plain',
				'access-control-allow-origin': '*'
			},
			data: code
		}).then(function success(response){
			console.log("success up to http");
			deferred.resolve(response);
		}, function error(errors){
			console.log("failure at http");
			deferred.reject(errors);
		});
		console.log("finished sending request");
		return deferred.promise;
	};
}]);