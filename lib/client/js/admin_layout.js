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
        sEmptyTable: TAPi18n.__('dataTbl.emptyTable'),
        sInfo: TAPi18n.__('dataTbl.info'),
        sInfoEmpty: TAPi18n.__('dataTbl.infoEmpty'),
        sInfoFiltered: TAPi18n.__('dataTbl.infoFiltered'),
        sInfoPostFix: TAPi18n.__('dataTbl.infoPostFix'),
        sInfoThousands: TAPi18n.__('dataTbl.infoThousands'),
        sLengthMenu: TAPi18n.__('dataTbl.lengthMenu'),
        sLoadingRecords: TAPi18n.__('dataTbl.loadingRecords'),
        sProcessing: TAPi18n.__('dataTbl.processing'),
        sSearch: TAPi18n.__('dataTbl.search'),
        sZeroRecords: TAPi18n.__('dataTbl.zeroRecords'),
        oPaginate: {
          sFirst: TAPi18n.__('dataTbl.paginate.first'),
          sPrevious: TAPi18n.__('dataTbl.paginate.previous'),
          sNext: TAPi18n.__('dataTbl.paginate.next'),
          sLast: TAPi18n.__('dataTbl.paginate.last')
        },
        oAria: {
          sSortAscending: TAPi18n.__('dataTbl.aria.sortAscending'),
          sSortDescending: TAPi18n.__('dataTbl.aria.sortDescending')
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
