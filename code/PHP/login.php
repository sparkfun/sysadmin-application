<?php
// -->>BUILD= ???<<--
// -->>VERSION= 1.3.0<<--
?>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8" />
		<META HTTP-EQUIV="Pragma" CONTENT="no-cache" />
		<META HTTP-EQUIV="Expires" CONTENT="-1" />
		<title>Password Reset Login</title>
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
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
								<a href="http://example.com" class="span4 nav-header-logo"><img src="images/logo.png" alt="Logo" /></a>
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
							<h1>Login</h1>
						</div>

						<?php
						session_start();
						if($_SESSION['INVALID'] == "TRUE") : ?>
						<div class="alert alert-block alert-error">
							<h3 class="alert-heading">Login Unsuccessful</h3>
							<p>The username and password combination does not match our records.</p>
						</div>
						<?php else : ?>
							<div class="alert alert-block alert-error hide">
							<h3 class="alert-heading">Login Unsuccessful</h3>
							<p>The username and password combination does not match our records.</p>
						</div>
						<?php endif;
						session_destroy(); ?>


						<form id="login" class="form-inline" method="post" action="checklogin.php">
							<div class="control-group">
								<label class="control-label" for="username"><strong>Username</strong></label>
								<div class="controls">
									<input class="input-text input-large" id="user" name="user" type="text" autocorrect="off" autocapitalize="off" />
									</div>
							</div>
							<div class="control-group">
								<label class="control-label" for="password"><strong>Password</strong></label>
								<div class="controls">
									<input class="input-text input-large" id="password" name="password" type="password" />
								</div>
							</div>
							<input class="btn btn-primary" value="Login" name="submit" type="submit" />
							<input type="hidden" name="target" value="url">
							<input type="hidden" name="smauthreason" value="0">
							<input type=hidden name=smagentname value="qnw9JVw5l4eZO3qYAh8aFovT1x92MaA8B16fN/84XRSuarNZwuxcGVP9WlrC2KDs">
							<input type=hidden name=postpreservationdata value="">
						</form>
						<ul class="small-text">
							<li><a href="link">Forgot your password?</a></li>
							<li><a href="link">Change your password.</a></li>
							<li><a href="link">Create your account.</a></li>
						</ul>
						<br/>
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
											<li>&copy; <script language="JavaScript">
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
		<script type="text/javascript" src="js/jquery-1.7.2.min.js"></script>
		<script type="text/javascript" src="js/common.js"></script>
		<script type="text/javascript">
			$(document).ready(function(){
				clearinput();
				checkCookie();
				$("#user").focus(); // put cursor in username field on page load
				$("#submit").click(function(event) {
					event.preventDefault();
  					$('#login').submit();
				});
			});
		</script>
	</body>
</html>
