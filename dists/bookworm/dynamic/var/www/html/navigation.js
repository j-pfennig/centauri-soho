function navispan(text, link) {
  return (link.length > 0)
    ? "<span><a href='" + link + "'>" + text + "</a></span>"
    : "<span style='color:gray'>" + text + "</span>";
}

function navigation(edat, home, prev, next) {
  var obj = document.getElementById("pagehdr");
  if(obj != null) obj.innerHTML =
    "<h1 class='function' align='center'>" + document.title + "</h1>" +
    "<p align='center'><i>Geschrieben " + edat + " von Dr. J&uuml;rgen Pfennig &copy; 2004-2007 " +
    "<a href='http://www.gnu.org/licenses/fdl.html'>(GNU Free Documentation License)</a></i></p>"

  var nav =  "<p class='navi' align='center'>"
    + navispan("home", home) + " "
    + navispan("previous", prev) + " "
    + navispan("next", next) + "</p>";
  obj = document.getElementById("navitop");  if(obj != null) obj.innerHTML = nav;
  obj = document.getElementById("navibot");  if(obj != null) obj.innerHTML = nav;
}
