"use strict";

MFILE.testLDAP = function () {
   $('#mainarea').html(MFILE.html.test_ldap1);
   console.log("About to test LDAP");
   $("#mainarea").append( "<% 'LdapServer' %>" );
   $("#mainarea").append(MFILE.html.press_any_key);
   $("#continue").focus();
   $("#continue").keydown(function(event) {
      event.preventDefault();
      MFILE.state = "MAIN_MENU";
      MFILE.actOnState();
   });
}
