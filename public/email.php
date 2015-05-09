<?php

$post = $_POST;
if($post == null || $post == array()) {
	return header('HTTP/1.1 500 Internal Server Error');
}
else{
	foreach ($post as $key => $value) {
		$post[$key] = strip_tags($value);
	}
	$top = file_get_contents(dirname(__FILE__).'/assets/email/top.html');
	$bottom = file_get_contents(dirname(__FILE__).'/assets/email/bottom.html');
	
	$dadEmail = 'contact@sanitherm-plomberie.fr';
	// $dadEmail = $post['email'];
	//To Client
	$to = $post['email'];
	$subject = 'Demande de devis';

	$headers = "From: " . $dadEmail . "\r\n";
	$headers .= "Reply-To: ". $dadEmail . "\r\n";
	$headers .= "MIME-Version: 1.0\r\n";
	$headers .= "Content-Type: text/html; charset=ISO-8859-1\r\n";

	$message = $top;
	$message .= h1($subject);
	$message .= p('Bonjour,');
	$message .= p('Nous avons bien re&ccedil;u votre demande, merci ! Nous vous recontacterons dans les meilleurs d&eacute;lais.');
	$message .= p('Cordialement,');
	$message .= p('Sanitherm');
	$message .= $bottom;
	// echo $message; return;
	echo mail($to, $subject, $message, $headers);

	//To Dad
	$to = $dadEmail;
	$subject = 'Demande de devis de '.$post['civilite'].' '.$post['nom'];

	$headers = "From: " . $post['email'] . "\r\n";
	$headers .= "Reply-To: ". $post['email'] . "\r\n";
	$headers .= "MIME-Version: 1.0\r\n";
	$headers .= "Content-Type: text/html; charset=ISO-8859-1\r\n";

	$message = $top;
	$message .= h1($subject);
	foreach ($post as $key => $value) {
		$message .= p($key .' : '. $value);
	}
	$message .= $bottom;
	// echo $message; return;
	echo mail($to, $subject, $message, $headers);
}
return;

function h1($text){
	return '<h1 style="Margin-top: 0;color: #072436;font-weight: 700;font-size: 36px;Margin-bottom: 18px;font-family: sans-serif;line-height: 42px">'.$text.'</h1>';
}

function p($text){
	return '<p style="Margin-top: 0;color: #072436;font-family: Georgia,serif;font-size: 16px;line-height: 25px;Margin-bottom: 24px">'.$text.'</p>';
}


