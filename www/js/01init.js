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
