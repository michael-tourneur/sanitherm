<?php
	
	$path = '/gallery';
	$files = array();
	if ($handle = opendir(dirname(__FILE__) . $path)) {

	    while (false !== ($entry = readdir($handle))) {

	        if ($entry != "." && $entry != "..") {

	            $files[] = $path . '/' . $entry;
	        }
	    }

	    closedir($handle);
	}

	echo json_encode($files);