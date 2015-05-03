<?php

	$post = $_POST
	if($post == null || $post == array()) {
		return header('HTTP/1.1 500 Internal Server Error');
	}
	else{
		var_dump($post);
	}