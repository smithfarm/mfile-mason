//-------------------------------
// MAC address generator function
//-------------------------------

"use strict";

MFILE.generateMAC = function () {
   console.log("Entering generate MAC address");
   $('#mainarea').html(MFILE.html.generate_mac_address);
   $('#generate').focus();
   $("#generate").keydown(function(event) {
      console.log("KEYDOWN. WHICH "+event.which+", KEYCODE "+event.keyCode);
      if (event.which === 27)  { // ESC
         event.preventDefault();
         $('#result').empty();
         MFILE.state = 'MAIN_MENU';
         MFILE.actOnState();
      } else {
         $.ajax({
            url: "ajax/gen_mac.plx",
            type: "POST",
            dataType: "json",
            success: function(r) { 
               console.log("AJAX POST success, result is: '"+r.result+"'");
               $('#result').html(r.result);
            },
            error: function(xhr, status, error) {
               $("#result").html("AJAX ERROR: "+xhr.status);
            }
         });
      }
      return false;
   });
}
