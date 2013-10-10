"use strict";

MFILE.testLDAP = function () {
   $('#mainarea').html(MFILE.html.test_ldap1);
   console.log("About to test LDAP");
   $("#mainarea").append("Pinging "+MFILE.ldap.server+" ... see below for result");
   $('#result').html("*** PLEASE WAIT ***");
   $.ajax({
         url: "/mfile-mason/ajax/ldap_test.plx",
         type: "POST",
         dataType: "json",
         data: MFILE.ldap,
         success: function(r) { 
            console.log("AJAX POST success, result is: '"+r.result+"'");
            $('#result').html(MFILE.ldap.server+" is "+r.result);
         },
         error: function(xhr, status, error) {
            $("#result").html("AJAX ERROR: "+xhr.status);
         }
      });
   $("#mainarea").append(MFILE.html.press_any_key);
   $("#continue").focus();
   $("#continue").keydown(function(event) {
      event.preventDefault();
      $('#result').html("");
      MFILE.state = "MAIN_MENU";
      MFILE.actOnState();
   });
}
