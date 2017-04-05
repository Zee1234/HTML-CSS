$(document).ready(function() {
  if (_userdata.session_logged_in){
    if (window.matchMedia("only scren and (max-width: 760px)")) {
      var narutobeginningshoverchatboxcss = document.createElement('style');
      var narutobeginningshoverchatbox = document.createElement('div');
      narutobeginningshoverchatboxcss.innerHTML = "";
      narutobeginningshoverchatbox.innerHTML = "";
      document.body.insertBefore(narutobeginningshoverchatboxcss,document.body.childNodes[0]);
      document.body.insertBefore(narutobeginningshoverchatbox,document.body.childNodes[1])
    }
  }
})
