
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
	response.success("Hello world!");
});


Parse.Cloud.define("sendMessageToTwillio", function(request, response) {
	// Require and initialize the Twilio module with your credentials
	var client1 = require('twilio')('AC840912e124927b5100895bc5b9a67f64', 'f83f5ef557fe90f1b1b4c6cc4d569d5c');
 
	// Send an SMS message
	client1.sendSms({
		to:'+19178039796', 
	    from: '+13177080548', 
	    body: request.params.order
	  }, function(err, responseData) { 
	    if (err) {
	      console.log(err);
	    } else { 
	      console.log(responseData.from); 
	      console.log(responseData.body);
	    }
	  }
	);

	var client2 = require('twilio')('AC840912e124927b5100895bc5b9a67f64', 'f83f5ef557fe90f1b1b4c6cc4d569d5c');
	// Send an SMS message
	client2.sendSms({
		to:'+17654041448', 
	    from: '+13177080548', 
	    body: request.params.order
	  }, function(err, responseData) { 
	    if (err) {
	      console.log(err);
	    } else { 
	      console.log(responseData.from); 
	      console.log(responseData.body);
	    }
	  }
	);

	response.success(request.params.order);
});
