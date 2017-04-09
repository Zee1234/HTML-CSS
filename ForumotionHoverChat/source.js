$(document).ready(function() {
  if (_userdata.session_logged_in){
    if (window.matchMedia("only scren and (max-width: 760px)")) {
      var narutobeginningshoverchatboxcss = document.createElement('style');
      var narutobeginningshoverchatbox = document.createElement('div');
      narutobeginningshoverchatboxcss.innerHTML = "#nbhcb_toggle{display:none}#nbhcb_toggle:checked+#nbhcb_container{-webkit-border-radius:2px 2px 2px 2px;-moz-border-radius:2px 2px 2px 2px;border-radius:2px 2px 2px 2px;width:600px;height:800px}#nbhcb_toggle:checked+#nbhcb_container #nbhcb_switch{height:20px;font-size:10px}#nbhcb_toggle:checked+#nbhcb_container #nbhcb_frame{height:-webkit-calc(100% - 20px);height:-moz-calc(100% - 20px);height:-ms-calc(100% - 20px);height:-o-calc(100% - 20px);height:calc(100% - 20px);top:20px}#nbhcb_container{-webkit-transition:all 1s ease-in-out;-moz-transition:all 1s ease-in-out;-ms-transition:all 1s ease-in-out;-o-transition:all 1s ease-in-out;transition:all 1s ease-in-out;-webkit-border-radius:12px 12px 12px 12px;-moz-border-radius:12px 12px 12px 12px;border-radius:12px 12px 12px 12px;position:fixed;bottom:10px;right:10px;width:100px;height:30px;max-width:90%;max-height:90%;background-color:#505050;color:#cebe2d;overflow:hidden;z-index:97}#nbhcb_switch{-webkit-transition:all 1s ease-in-out;-moz-transition:all 1s ease-in-out;-ms-transition:all 1s ease-in-out;-o-transition:all 1s ease-in-out;transition:all 1s ease-in-out;width:100%;height:30px;font-size:13px;text-align:center;padding:5px 0px 0px 0px;z-index:99}#nbhcb_frame{-webkit-transition:all 1s ease-in-out;-moz-transition:all 1s ease-in-out;-ms-transition:all 1s ease-in-out;-o-transition:all 1s ease-in-out;transition:all 1s ease-in-out;height:-webkit-calc(100% - 30px);height:-moz-calc(100% - 30px);height:-ms-calc(100% - 30px);height:-o-calc(100% - 30px);height:calc(100% - 30px);width:100%;position:absolute;top:30px;border-width:0px;z-index:98}";
      narutobeginningshoverchatbox.innerHTML = "<input id='nbhcb_toggle' type='checkbox'>\
      <div id='nbhcb_container'>\
      <label for='nbhcb_toggle'>\
      <div id='nbhcb_switch'>\
      Toggle Chat\
      </div>\
      </label>\
      <iframe id='nbhcb_frame' src='/chatbox/index.forum'></iframe>\
      </div>";
      document.body.insertBefore(narutobeginningshoverchatboxcss,document.body.childNodes[0]);
      document.body.insertBefore(narutobeginningshoverchatbox,document.body.childNodes[1])
    }
  }
})
