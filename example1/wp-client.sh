#!/bin/sh

docker run --name wp-client --network example1_front-tier -e URL='http://lb{/,/readme.html,/wp-login.php,/error1,/error2,/wp-includes/js/utils.js,/wp-content/themes/twentyfifteen/screenshot.png,/wp-content/themes/twentyfifteen/style.css,/wp-content/themes/twentysixteen/js/functions.js,/wp-includes/images/down_arrow.gif,/wp-includes/js/jcrop/Jcrop.gif}' ltagliamonte/recurling
