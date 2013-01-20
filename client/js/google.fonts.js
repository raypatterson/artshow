WebFontConfig = {
  google: { 
    families: [
      // , 'Great+Vibes::latin'
      // , 'Yanone+Kaffeesatz::latin'
      'Open+Sans+Condensed:300,300italic,700:latin'
      , 'Voltaire::latin' 
    ] 
  }
};
(function() {
  var wf = document.createElement('script');
  wf.src = ('https:' == document.location.protocol ? 'https' : 'http') +
    '://ajax.googleapis.com/ajax/libs/webfont/1/webfont.js';
  wf.type = 'text/javascript';
  wf.async = 'true';
  var s = document.getElementsByTagName('script')[0];
  s.parentNode.insertBefore(wf, s);
})();