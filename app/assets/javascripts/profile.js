$(function() {
    $("#profile_form").bind("ajax:success", function(e) {
        var info = e.detail[0]['message'];
        $("#result").html('<div class="alert alert-success"><button type="button" class="close">×</button>'+info+'</div>');
        $('#password').val('');
        $('#password_confirmation').val('');
    });
    $("#profile_form").bind("ajax:error", function(e) {
        var info = e.detail[0]['message']['base'][0];
        $("#result").html('<div class="alert alert-danger"><button type="button" class="close">×</button>'+info+'</div>');

    });
    window.setTimeout(function () {
        $(".alert").fadeTo(500, 0).slideUp(500, function () {
            $(this).remove();
        });
    }, 5000);

    //Adding a click event to the 'x' button to close immediately
    $('.alert .close').on("click", function (e) {
        $(this).parent().fadeTo(500, 0).slideUp(500);
    });
});
