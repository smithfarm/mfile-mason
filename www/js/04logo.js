// 04free.js

<%init>
 use mfile_init;

 my $Global = $mfile_init::Global;
</%init>

"use strict";   // ES5/strict

MFILE.logout = function () {
   console.log("Entering MFILE.logout");
   MFILE.uid = undefined;
   MFILE.sessionid = undefined;
   MFILE.cookie.erase('mfileuid');
   MFILE.cookie.erase('mfilesessionid');
   MFILE.state = 'NOT_LOGGED_IN';
   // Clear username and password stored on server
   $.ajax({
         url: "/ajax/logout.plx",
         type: "POST",
         dataType: "json",
         success: function(r) { 
            console.log("AJAX POST success, result is: '"+r.result+"'");
	    $("#mainarea").load('/html/login-dialog.mas');
         },
         error: function(xhr, status, error) {
            $("#result").html("AJAX ERROR in MFILE.logout: "+xhr.status);
         }
      });
}

