<?php
// -->>BUILD= ???<<--
// -->>VERSION= 1.3.0<<--


	//kill session (logout)
	ldap_close($ldapConnect);
	$_SESSION = array();
	if (ini_get("session.use_cookies")) {
    $params = session_get_cookie_params();
    setcookie(session_name(), '', time() - 42000,
        $params["path"], $params["domain"],
        $params["secure"], $params["httponly"]);
	}

	session_destroy();


	//unset($_SESSION['USERGID']);
	//echo "Successfully logged out";
	//session_destroy();

?>
<!DOCTYPE html>
<html><head>
		<meta charset="utf-8">
		<title>Password Reset Logout</title>
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<meta name="description" content="">
		<meta name="author" content="">

		<link href="styles/bootstrap.css" rel="stylesheet">
		<link href="styles/bootstrap-responsive.css" rel="stylesheet">

	    <!--[if lte IE 7]>
	    	<style>

	    	.wrapper.gray-fade {
	    		background-color: #fff;
	    	}

	    	</style>
	    <![endif]-->

	    <!-- Le HTML5 shim, for IE6-8 support of HTML5 elements -->
	    <!--[if lt IE 9]>
	    	<script src="js/html5.js"></script>
	    <![endif]-->
	</head>
	<body>
		<div class="wrapper">
			<div class="container">
				<div class="row-fluid">
					<div class="span12">
						<div class="nav-header">
							<div class="row-fluid">
								<a href="http://example.com" class="span4 nav-header-logo"><img src="images/logo.png" alt="example"></a>
							</div>
						</div>
					</div> <!-- /span12 -->
				</div> <!-- /row-fluid -->
			</div> <!-- /container -->
		</div> <!-- /wrapper -->
		<div class="wrapper gray-fade">
			<div class="container">
				<div class="row-fluid">
					<div class="span12">
						<div class="page-header">
							<h1>Thank You</h1>
						</div>
						<p>You have successfully logged out of Password Reset.</p>
						<p>If you have logged out in error, or wish to return, please <a href="./login.php">login now</a>.</p>
						<p><a class="btn btn-primary" href="http://example.com">Return to example.com</a></p>
						<p>Otherwise, <a href="javascript:window.close();">please close your web browser now!</a></p>
						<p class="alert alert-info">The information you have just seen remains in your web browser's memory until you close the browser, presenting a potential security risk. Protect your confidential information by closing your browser as soon as you have completed the logout process!</p>
						<br>
					</div> <!-- /span12 -->
				</div> <!-- /row-fluid -->
			</div> <!-- /container -->
		</div> <!-- /wrapper -->
		<div class="wrapper">
			<div class="container">
				<div class="row-fluid">
					<div class="span12">
						<div class="nav-footer">
							<div class="nav-footer-bottom">
								<div class="row-fluid">
									<div class="span12">
										<ul class="nav-footer-links right">
											<li>© <script language="JavaScript">
												var d = new Date();
												yr = d.getFullYear();
												document.write(yr);
												</script> Example
											</li>
										</ul>
									</div>
								</div>
							</div>
						</div>
					</div> <!-- /span12 -->
				</div> <!-- /row-fluid -->
			</div> <!-- /container -->
		</div> <!-- /wrapper -->

</body></html>
