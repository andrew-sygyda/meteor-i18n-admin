Template.AdminSidebar.rendered = function () {
    $(".treeview").tree();
};

Template.AdminHeader.rendered = function () {
    $("[data-toggle='offcanvas']").click(function(e) {
        e.preventDefault();

        //If window is small enough, enable sidebar push menu
        if ($(window).width() <= 992) {
            $('.row-offcanvas').toggleClass('active');
            $('.left-side').removeClass("collapse-left");
            $(".right-side").removeClass("strech");
            $('.row-offcanvas').toggleClass("relative");
        } else {
            //Else, enable content streching
            $('.left-side').toggleClass("collapse-left");
            $(".right-side").toggleClass("strech");
        }
    });
};

Template.NotAdmin.events({
  'submit .form-signin': function (ev, template) {
    ev.preventDefault();
    Meteor.loginWithPassword(
      template.$('#email').val(),
      template.$('#password').val()
    );
  }
});

dataTableOptions = {
    "aaSorting": [],
    "bPaginate": true,
    "bLengthChange": false,
    "bFilter": true,
    "bSort": true,
    "bInfo": true,
    "bAutoWidth": false
};

setDataTableLang = function() {
  if (TAPi18n.getLanguage() !== 'en') {
    return $.extend($.fn.dataTable.defaults, {
      language: {
        sEmptyTable: __('dataTbl.emptyTable'),
        sInfo: __('dataTbl.info'),
        sInfoEmpty: __('dataTbl.infoEmpty'),
        sInfoFiltered: __('dataTbl.infoFiltered'),
        sInfoPostFix: __('dataTbl.infoPostFix'),
        sInfoThousands: __('dataTbl.infoThousands'),
        sLengthMenu: __('dataTbl.lengthMenu'),
        sLoadingRecords: __('dataTbl.loadingRecords'),
        sProcessing: __('dataTbl.processing'),
        sSearch: __('dataTbl.search'),
        sZeroRecords: __('dataTbl.zeroRecords'),
        oPaginate: {
          sFirst: __('dataTbl.paginate.first'),
          sPrevious: __('dataTbl.paginate.previous'),
          sNext: __('dataTbl.paginate.next'),
          sLast: __('dataTbl.paginate.last')
        },
        oAria: {
          sSortAscending: __('dataTbl.aria.sortAscending'),
          sSortDescending: __('dataTbl.aria.sortDescending')
        }
      }
    });
  }
};

(function($) {
    "use strict";

    $.fn.tree = function() {

        return this.each(function() {
            var btn = $(this).children("a").first();
            var menu = $(this).children(".treeview-menu").first();
            var isActive = $(this).hasClass('active');

            //initialize already active menus
            if (isActive) {
                menu.show();
                btn.children(".fa-angle-left").first().removeClass("fa-angle-left").addClass("fa-angle-down");
            }
            //Slide open or close the menu on link click
            btn.click(function(e) {
                e.preventDefault();
                if (isActive) {
                    //Slide up to close menu
                    menu.slideUp();
                    isActive = false;
                    btn.children(".fa-angle-down").first().removeClass("fa-angle-down").addClass("fa-angle-left");
                    btn.parent("li").removeClass("active");
                } else {
                    //Slide down to open menu
                    menu.slideDown();
                    isActive = true;
                    btn.children(".fa-angle-left").first().removeClass("fa-angle-left").addClass("fa-angle-down");
                    btn.parent("li").addClass("active");
                }
            });

            /* Add margins to submenu elements to give it a tree look */
            menu.find("li > a").each(function() {
                var pad = parseInt($(this).css("margin-left")) + 10;

                $(this).css({"margin-left": pad + "px"});
            });

        });

};


}(jQuery));
