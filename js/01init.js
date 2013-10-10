// 01init.js
//
// MFILE JavaScript init script
// 20130503 smithfarm
//
// Defines objects and helper functions

<%init>
 use mfile_init;
 my $Global = $mfile_init::Global;
</%init>

"use strict";  // ES5/strict

// ------------------
// Object Definitions
// ------------------
var MFILE = Object.create(null);

MFILE.state = "NOT_LOGGED_IN";

MFILE.html = {
   auth_dialog: "<br><br>Innerweb credentials<br><br>Username <input id='username' size='15' maxlength='9' /><br>Password <input id='password' type='password' size='20' maxlength='20' /><br><br><br>&nbsp;",
   main_menu: "<H2>Main menu</H2>1. Generate MAC addresses<br>2.  Administer codes<br>3. Test LDAP<br>4. View cookies<br>5. Rest in the Self<br>6.  Logout<br><br>Your selection: <input id='getchar' size=2 maxlength=1 style='width: 10px;'>&nbsp;</input><br><br><br>",
   code_box: "Code: <textarea id='code' name='code' rows=1 cols=8 maxlength=8 style='height: 22px'></textarea>",
   change_code: "<h2>Administer codes</h2>Cursor now in the 'Code:' field. Use function keys shown above.<br><br><br><br>",
   code_search_results1: "<h2>Multiple matches</h2>The following codes match your search term:<br>",
   press_any_key: "<br><br>Press any key to continue: <input id='continue' size='1' maxlength='0' /><br><br><br>",
   code_delete_conf1: "<h2>Confirmation needed</h2>You are asking to delete the code: ",
   code_delete_conf2: "<br>Press 'y' to delete, any other key to cancel: <input id='yesno' size='1' maxlength='2' /><br><br><br>",
   test_ldap1: "<h2>Test LDAP</h2>",
   generate_mac_address: "<h2>Generate MAC addresses</h2><br><br>Press any key to generate, or &lt;ESC&gt; to exit: <input id='generate' size='1' maxlength='0' />",
   view_cookie1: "<h2>View cookies</h2>",
   administer_files: 'Serial number: <textarea id="sern" name="sern" rows=1 cols=8 maxlength=8 style="height: 22px" /><div class="mfilekeyw"><br> Key words (max. 120 characters; words wrap) <textarea id="keywords" name="keywords" rows=3 cols="62" maxlength=120 style="height: 68px; width: 812px; overflow: hidden;" /> </div> <div class="mfiledesc"> Description/other notes (max. 320 characters) <textarea id="description" name="description" rows=6 cols="62" maxlength=320 style="height: 138px; width: 812px; overflow: hidden;" /></div>'
}

MFILE.activeCode = {
  result: "",
  id: "",
  dstr: "",
  cstr: "",
  desc: ""
};

MFILE.ldap = {
   enable: '<% $Global->{'LdapEnable'} %>',
   server: '<% $Global->{'LdapServer'} %>',
   base  : '<% $Global->{'LdapBase'} %>',
   filter: '<% $Global->{'LdapFilter'} %>'
}

// ----------------
// Helper Functions
// ---------------- 
// function to log keypresses
function logKeyPress(evt) {
   console.log("WHICH: "+evt.which+", KEYCODE: "+evt.keyCode);
}
