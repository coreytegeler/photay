(function() {
  var circle, circlePoint, root;

  circlePoint = new Point(view.center.x, view.center.y);

  circle = new Path.Circle(circlePoint, 100);

  circle.name = 'circle';

  circle.center = circlePoint;

  circle.fillColor = 'white';

  root = $('body').data('root');

  project.importSVG(root + '/assets/img/logo.svg', function(logo) {
    var logoPoint;
    logoPoint = new Point(view.center.x, view.center.y / 2);
    logo.name = 'logo';
    logo.position = logoPoint;
    logo.fillColor = 'white';
    $('#wrapper').addClass('loa');
    return $('body').scroll(function(e) {
      var scrollTop, winHeight;
      scrollTop = $('body').scrollTop();
      return winHeight = $('body').innerHeight();
    }).scroll();
  });

  view.onMouseMove = function(event) {
    return circlePoint = event.point;
  };

  view.onFrame = function(event) {
    var circleDelta, logo, logoDelta;
    circleDelta = (circlePoint - circle.position) / 5;
    if (circleDelta.length > 0.1 && (logo = project.getItem({
      name: 'logo'
    }))) {
      circle.position += circleDelta;
      logoDelta = {
        x: (Math.abs(circle.position.x) - $(window).innerWidth()) * -1,
        y: (Math.abs(circle.position.y) - $(window).innerHeight()) * -1
      };
      logo.rotate((circleDelta.x + circleDelta.y) / 2);
      return logo.position = logoDelta;
    }
  };

}).call(this);

//# sourceMappingURL=spotlight.js.map
