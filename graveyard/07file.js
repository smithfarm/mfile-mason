//-------------------------------
// ADMINISTER FILES FUNCTIONALITY
//-------------------------------

MFILE.administerFiles = function () {

   // first, check if the Code String is valid
   
   MFILE.administerFiles.handleDisplay();
   MFILE.administerFiles.handleKeyboard();
}


MFILE.administerFiles.handleDisplay = function () {
  $('#result').empty();
  $('#code').val(MFILE.activeCode.cstr);
  $('#mainarea').html(MFILE.html.administer_files);

  // Display/erase help message for Serial Number (Sern) field
  $("#sern").focus(function(event) {
    $('#helpmesg').html('ESC=Clear, F3=Fetch File, Del=Delete File');
  }); 
  $("#sern").blur(function(event) {
    $('#helpmesg').html('');
  }); 

  // Display/erase help message for Key Words field
  $("#keywords").focus(function(event) {
    $('#helpmesg').html('ESC=Clear, Ins=Insert File, F3=Search, F5=Update');
  });
  $("#keywords").blur(function(event) {
    $('#helpmesg').html('');
  });

}
