//-------------------------------
// MAC address generator function
//-------------------------------

"use strict";

MFILE.generateMAC = function () {
   console.log("Entering generate MAC address");
   MFILE.gen_mac = {};
   $('#mainarea').html(MFILE.html.generate_mac_address);
   $.ajax({
      url: "/mfile-mason/ajax/gen_mac_start.plx",
         type: "POST",
         dataType: "json",
         success: function(r) { 
            console.log("AJAX POST success, result is: '"+r.result+"'");
	    MFILE.gen_mac.mac = r.result;
            $('#result').html("Auto-generated MAC: " + MFILE.gen_mac.mac);
         },
         error: function(xhr, status, error) {
            $("#result").html("AJAX ERROR: "+xhr.status);
         }
      });
   $('#generate').focus();
   $("#generate").keydown(function(event) {
      console.log("KEYDOWN. WHICH "+event.which+", KEYCODE "+event.keyCode);
      if (event.which === 27)  { // ESC
         event.preventDefault();
         $('#result').empty();
         MFILE.state = 'MAIN_MENU';
         MFILE.actOnState();
      } else if (even.which === 89) { // 'y'
         event.preventDefault();
	 MFILE.gen_mac.accept = 1;
         $.ajax({
            url: "/mfile-mason/ajax/gen_mac.plx",
            type: "POST",
            dataType: "json",
	    data: MFILE.gen_mac,
            success: function(r) { 
               console.log("AJAX POST success, result is: '"+r.result+"'");
               $('#result').html(r.result);
            },
            error: function(xhr, status, error) {
               $("#result").html("AJAX ERROR: "+xhr.status);
            }
         });
      } return false;
   });
}
