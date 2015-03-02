// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

$(document).ready(function () {
    SupplyRatings();
    ClearRatings();
    ValidateRatings();
});

function SupplyRatings()
{
    $('.star-rating :radio').change(
        function(){
            if(this.value.substr(0,1) <= 9 && this.value.length == 2) {
                $("#cat" + this.value.substr(0, 1)).val(this.value.substr(1, 2));
            }
            else if(this.value.substr(0,2) == 10) {
                $("#cat" + this.value.substr(0, 2)).val(this.value.substr(2, 3));
            }
            else
            {
                $("#overall").val(this.value.substr(2, 3));
            }
        }
    )
}

function ClearRatings()
{
    $('#lnkClearRatings').click(
        function() {
            $('.star-rating :radio').prop('checked', false);
            for(var i=1; i<=10; i++)
            {
                $("#cat" + i).val('');
            }
        }
    )
}

function ValidateRatings()
{
    $('#frmRatings').submit(function()
    {
        var chkRatings = false;
        $('.star-rating :radio').each(function()
            {
                if($(this).is(":checked"))
                {
                    chkRatings = true;
                }
            }
        )
        if (!chkRatings)
        {
            alert("Please provide ratings.");
            return false;
        }
    });
    return true;
}
