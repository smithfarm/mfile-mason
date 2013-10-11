// 04auth.js
// 20130510 smithfarm
//
// MFILE.authenticateUser() function

<%init>
 use mfile_init;

 my $Global = $mfile_init::Global;
 info("Entering js/04auth.js");
</%init>

"use strict";   // ES5/strict


var processPassword = function () {
   var creds = Object.create(null);

   creds.nam = $("#username").val();
   creds.pwd = $("#password").val();
   MFILE.uid = undefined;

   // YIKES YIKES YIKES YIKES YIKES YIKES !!!!
   // remove this before going into production
   // ****************************************
   if (creds.nam === '' && creds.pwd === '') {
            MFILE.uid = 'smithfarm';
   }
   // ****************************************
   // YIKES YIKES YIKES YIKES YIKES YIKES !!!!

   $('#result').html("*** PLEASE WAIT ***");
   $.ajax({
      url: "/mfile-mason/ajax/login.plx",
      type: "POST",
      dataType: "json",
      data: creds,
      success: function(r) { 
         console.log("AJAX POST success, result is: '"+r.result+"'");
         if (r.result === "success") {
            $('#result').html("");
            MFILE.uid = creds.nam;
            MFILE.authSuccess();
         } else {
            console.log("Authentication attempt failed");
            $('#result').html("FAILED: '"+r.result+"'");
            MFILE.state = 'LOGIN_FAIL';
            MFILE.actOnState();
         }
      },
      error: function(xhr, status, error) {
         $("#result").html("AJAX ERROR: "+xhr.status);
      }
   });
}

MFILE.authSuccess = function () {
   console.log("User authenticated, right?");
   MFILE.cookie.create('mfileuid', MFILE.uid);
   MFILE.sessionid = MFILE.cookie.read('_boss_session');
   MFILE.state = 'MAIN_MENU';
   MFILE.actOnState();   
}

MFILE.logout = function () {
   // Clear username and password stored on server
   $.ajax({
         url: "/mfile-mason/ajax/logout.plx",
         type: "POST",
         dataType: "json",
         success: function(r) { 
            console.log("AJAX POST success, result is: '"+r.result+"'");
         },
         error: function(xhr, status, error) {
            $("#result").html("AJAX ERROR in MFILE.logout: "+xhr.status);
         }
      });
}

MFILE.authenticateUser = function () {
   
   // Throw up the authentication dialog
   $('#mainarea').html(MFILE.html.auth_dialog);

   // If previous login attempt failed, let the user know
   if (MFILE.state === 'LOGIN_FAIL') {
      console.log("Previous login failed");
   }

   // Clear the input fields and put cursor in "username" field 
   $("#username").val('');
   $("#password").val('');
   $("#username").focus();

   // Set up a callback function to listen for the <ENTER> key to be pressed in "username" field
   $("#username").keydown(function(event) {
      logKeyPress(event);
      if (event.keyCode === 13) {
         event.preventDefault();
         $("#password").focus();
      }
   });

   // Set up a callback function to listen for the <ENTER> key to be pressed in "password" field
   $("#password").keydown(function(event) {
      logKeyPress(event);
      if (event.keyCode === 13) {
         event.preventDefault();
         processPassword();
      }
   });
}
