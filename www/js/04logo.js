// 04free.js

"use strict";   // ES5/strict

MFILE.logout = function () {
   console.log("Entering MFILE.logout");
   MFILE.username = undefined;
   MFILE.userid = undefined;
   MFILE.cookie.erase('username');
   MFILE.cookie.erase('userid');
   MFILE.state = 'NOT_LOGGED_IN';
   $("#result").empty();
   // Clear username and password stored on server
   $.ajax({
         url: "/ajax/logout.plx",
         type: "POST",
         dataType: "json",
         success: function(r) { 
            console.log("AJAX POST success, result is: '"+r.result+"'");
	    MFILE.state = 'NOT_LOGGED_IN';
            MFILE.actOnState();
         },
         error: function(xhr, status, error) {
            $("#result").html("AJAX ERROR in MFILE.logout: "+xhr.status);
         }
      });
}

