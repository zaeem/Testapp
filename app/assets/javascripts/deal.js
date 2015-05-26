$(document).ready(function() {
  var loader = $('#activities-loader');
  if (loader.length > 0){
    var url = loader.parents('*[data-scrollinity-path]').attr('data-scrollinity-path');
    if (url) {
      loader.show();
      $.get(url, {}, function(response) {
        $('#activities-area').html(response);
        $('#activities-loader').hide();
      });
    }
    
  }
  
  if (typeof(aaDealPath) != 'undefined'){
    $.periodic({period: 2000, decay: 1.2, max_period: 60000}, function() {
      $.getJSON(aaDealPath, function(data) {
      	jQuery('.inventory').html(data['inventory']);
      });
    });
  }

}); // end of document .ready 
