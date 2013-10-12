"use strict";  // ES5/Strict

// MFILE.determineState()
//    
MFILE.determineState = function () {

   var cookie_in_hand;
   
   // first, see if the user entered a proper URL
   console.log("Lost field says: "+$('#urlcorrectness').val());
   if ($('#urlcorrectness').val() === "lost") {
      MFILE.state = 'LOST';
      return true;
   }

   // URL is OK; look at cookie
   cookie_in_hand = MFILE.cookie.read('mfileuid');

   console.log("UID appears to be "+cookie_in_hand);
   if (cookie_in_hand !== null) {
      MFILE.state = 'MAIN_MENU';
      return true;
   }
   return false;
}

// ------------------
// MFILE.actOnState()
// ------------------
MFILE.actOnState = function () {

   var retval;

   console.log("Acting on state "+MFILE.state);
   if (MFILE.state === "LOST") {
      $("#mainarea").html("<br><br><h1>Invalid URL</h1>");
//   } else if (MFILE.state === "NOT_LOGGED_IN") {
//         $('#userid').html('');
//         $('#topmesg').html('');
//         retval = MFILE.login();
//         console.log("MFILE.login() returned "+retval);
//	 MFILE.state = "LOGGING_IN";
   } else if (MFILE.state === "LOGIN_FAIL") {
         retval = MFILE.login();
         console.log("MFILE.login() returned "+retval);
   } else if (MFILE.state === "MAIN_MENU") {
         MFILE.uid = MFILE.cookie.read('mfileuid');
         MFILE.sessionid = MFILE.cookie.read('mfilesessionid');
         $("#userid").html("Username: "+MFILE.uid);
         console.log("Logged in! Session cookie: "+MFILE.sessionid);
         $("#mainarea").load("/html/main-menu.mas");
   } else if (MFILE.state === "ADMINISTER_CODES") {
         console.log("Calling MFILE.administerCodes()");
         MFILE.administerCodes();
   } else if (MFILE.state === "ADMINISTER_FILES") {
         console.log("Calling MFILE.administerFiles()");
         MFILE.administerFiles();
   } else if (MFILE.state === "TEST_LDAP") {
         $("#mainarea").load("/html/ldap-test.mas");
   } else if (MFILE.state === "VIEW_COOKIE") {
         console.log("Calling MFILE.cookie.view()");
         MFILE.cookie.view();
   } else if (MFILE.state === "GENERATE_MAC_ADDRESSES") {
	 $("#mainarea").load("/html/gen_mac.mas");
   } else {
      console.log("MFILE INTERNAL ERROR: Inconsistent state!");
   }
}

// ------------
// Main Program
// ------------
//$(document).ready(function() {
//
//  MFILE.determineState();
//  MFILE.actOnState();
//
//});
