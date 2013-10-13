<%flags>
inherit => undef
</%flags>

<%init>
our %Global;
</%init>

// 01init.js
//
// MFILE JavaScript init script
// 20130503 smithfarm
//
// Defines objects and helper functions

"use strict";  // ES5/strict

// ------------------
// Object Definitions
// ------------------
var MFILE = Object.create(null);

MFILE.state = "NOT_LOGGED_IN";

MFILE.html = {
   press_any_key: "<br><br>Press any key to continue: <input id='continue' size='1' maxlength='0' /><br><br><br>",
   generate_mac_address: "<h2>Generate MAC address</h2><br><div class='macaddr'></div><br>Do you want this address? (y)/n/ESC: <input id='generate' size='1' maxlength='0' />",
   view_cookie1: "<h2>View cookies</h2>",
}

MFILE.activeCode = {
  result: "",
  id: "",
  dstr: "",
  cstr: "",
  desc: ""
};

MFILE.ldap = {
   enable: '<% $Global{'LdapEnable'} %>',
   server: '<% $Global{'LdapServer'} %>',
   base  : '<% $Global{'LdapBase'} %>',
   filter: '<% $Global{'LdapFilter'} %>'
}

// ----------------
// Helper Functions
// ---------------- 
// function to log keypresses
function logKeyPress(evt) {
   console.log("WHICH: "+evt.which+", KEYCODE: "+evt.keyCode);
}
