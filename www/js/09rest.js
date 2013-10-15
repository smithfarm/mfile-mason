"use strict";  // ES5/Strict

// MFILE.determineState()
//    
MFILE.determineState = function () {

   // URL is OK; look at cookie
   MFILE.username = MFILE.cookie.read('username');
   MFILE.userid = MFILE.cookie.read('userid');

   console.log("Username appears to be "+MFILE.username);
   console.log("Userid appears to be "+MFILE.userid);
   if (MFILE.username !== null) {
      MFILE.state = 'MAIN_MENU';
   } else {
      MFILE.state = 'NOT_LOGGED_IN';
   }
}

// ------------------
// MFILE.actOnState()
// ------------------
MFILE.actOnState = function () {

   var retval;

   console.log("Acting on state "+MFILE.state);
   if (MFILE.state === "LOST") {
      $("#mainarea").html("<br><br><h1>Invalid URL</h1>");
   } else if (MFILE.state === "NOT_LOGGED_IN") {
         $('#userid').html('');
         $('#mainarea').load('/html/login-dialog.mas');
   } else if (MFILE.state === "LOGIN_FAILED") {
         retval = MFILE.login();
         console.log("MFILE.login() returned "+retval);
   } else if (MFILE.state === "MAIN_MENU") {
         console.log("mfile thinks the user's name is "+MFILE.username);
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
         $("#mainarea").load("/html/cookie-view.mas");
   } else if (MFILE.state === "GENERATE_MAC_ADDRESSES") {
	 $("#mainarea").load("/html/gen-mac.mas");
   } else if (MFILE.state === "REST_IN_THE_SELF") {
         $("#mainarea").load("/html/rest-Self.mas");
   } else {
      console.log("MFILE INTERNAL ERROR: Inconsistent state!");
   }
}

// ------------
// Main Program
// ------------
$(document).ready(function() {

  MFILE.determineState();
  MFILE.actOnState();

});
