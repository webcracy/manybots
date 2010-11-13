$(document).ready(function() {
    
  $('#calendar').addClass('hidden').hide();
  
  $('.show.calendar').click(function(){
    $('ul#activities').toggle();
    $('#calendar').toggle();
    if ($('.pagination')) { 
      $('.pagination').toggle();
    }
    if($('#calendar').hasClass('hidden')) {
      var calendar = $('#calendar').fullCalendar({
        header: {
          left: 'prev,next today',
          center: 'title',
          right: 'month,basicWeek,agendaDay'
        },
        slotMinutes: 60,
        events: window.location.pathname + ".js" + window.location.search,
        eventRender: function(event, element) {
          element.qtip({
            content:event.description,
            hide: {
              fixed: true // Make it fixed so it can be hovered over
            },
            position: {
              corner: {
                 target: 'topLeft',
                 tooltip: 'bottomLeft'
              }
            },
          });
        }
      });
      $('#calendar').removeClass('hidden');
    }
    return false;
  });
  
  $('a.activity.add.verb').click(function(){
    var verb = prompt("What verb would you like to create?", "");
    if (verb != null){
      $.ajax({
        type: 'POST',
        url: '/verbs.json',
        data: { 
          verb: {
            name: verb
          }
        },
        success: function(data) {
          var $new_option = $('<option/>').attr('value', data.verb.url_id).attr('selected', 'selected').text(data.verb.name);
          $('#activity_verb').append($new_option);
        },
        error: function(data){
          alert('Sorry, there was an error');
        }        
      });
    }
    return false;
  });
  
  $('a.activity.add.object_type').click(function(){
    var ot = prompt("What Object Type would you like to create?", "");
    if (ot != null){
      var $objectSelect = $('#activity_object_attributes_object_type');
      var $targetSelect = $('#activity_target_attributes_object_type');
      var $link = $(this);
      $.ajax({
        type: 'POST',
        url: '/object_types.json',
        data: { 
          object_type: {
            name: ot
          }
        },
        success: function(data) {
          var $new_option = $('<option/>').attr('value', data.object_type.url_id).attr('selected', 'selected').text(data.object_type.name);
          if ($link.attr('rel') == 'target') {
            $targetSelect.append($new_option.clone().attr('selected', 'selected'));
            $objectSelect.append($new_option.clone());
          } else {
            $objectSelect.append($new_option.clone().attr('selected', 'selected'));
            $targetSelect.append($new_option.clone());
          }
        },
        error: function(data){
          alert('Sorry, there was an error');
        }        
      });
    }
    return false;
  });
  
  $('#preview_new_activity').live('click', function() {
    var $form = $('#new_activity');
    var data = $form.serialize();
    $.ajax({
      type: 'POST',
      url: "/activities/preview",
      data: data,
      success: function(data) {
        var title = $(data).find('div.activity.title').html();
        $('#preview').html(data);
        $('input#activity_title').attr('value', title);
        $('p.save').show();
        $('div#errorExplanation').remove();
      },
      error: function(data) {
        $('#simple_form').html(data.responseText);
        $error = $('<p />').html('There were errors in your activity, please scroll up to check and correct them.');
        $error.attr('style', 'color: red;');
        $('#preview').append($error);
      }
    });
    return false;
  });
  
});

var addVerb = function() {
};