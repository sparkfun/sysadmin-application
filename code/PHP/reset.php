<?php
// -->>BUILD= ???<<--
// -->>VERSION= 1.3.0<<--

        session_start();

        //if they are logged in continue, otherwise go back to login page
        if(!isset($_SESSION['USERGID'])){
            header("location:login.php");
        }
        include 'vars.php';
        ?>
<!DOCTYPE html>
<html>
    <head>
        <title>
                <?php
                    echo $HEADER;
                    ?>
        </title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link id="myStyleSheet" href="styles/lco-light.css" rel="stylesheet" type="text/css" media="screen">
        <link href="images/favicon.ico" rel="shortcut icon">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
        <script src="scripts/theme.js"></script>
        <script src="scripts/helpers.js"></script>
    </head>
    <body>
        <div id="header-container">
            <div id="header">
                <img id="header-logo" alt="example" src="images/logo-black.png">
                <div id="header-logout">
                    Welcome   <?php
                                echo $_SESSION['USERGID'];
                                ?>
                    | <a href="logout.php"> Logout</a>
                </div>
                <div id="header-title">
                    <?php
                        echo $HEADER;
                        ?>
                </div>
            </div>
        </div>
        <div id="body-container">
            <div id="content">
                <div id="content-wrap">
                    <div id="content">
                        <div id="columnA">
                            <div id="email" class="box">
                                <h2 class="header">Change My Password</h2>
                                <div>
                                    <div class="content">
                                        <h3>Welcome to  <?php
                                        echo $HEADER;
                                        ?></h3>
                                        <p>By requesting a password reset email, an email will be sent to you which will allow you to change your password.</p>
                                        <br><br>

                                        <h3>
                                        <?php
                                         echo "You are logged in as: " . "<b>" . $_SESSION['USERGID'] . "</b>" . "<br> <br>";
                                         ?>
                                        </h3>

                                        <?php

                                            $output = exec("/var/www/blackbox.pl " . $_SESSION['USERGID']);
                                            $output = substr("$output", 0, -1);
                                            $databases =  split(";", $output);

                                            if( $output == ""){
                                                echo "Sorry you currently do not have access to any of our databases. Please contact your local database administrator if you believe this is in error. <br>";
                                            }
                                            else{
                                                foreach ($databases as $item){
                                                    list($db, $username) = split(", ", $item);
                                                    $combined = $db . $username;
                                                    echo "Database: <b>$db</b>&nbsp;    Username: <b>$username</b> <br />\n";

                                                    if (!empty($_GET['reset']) AND $db . $username == htmlspecialchars($_GET["reset"]) ){
                                                        echo exec("/var/www/passwordResetScript.pl " . $_SESSION['USERGID'] .  " " . $db . " " . $username ) . "<br><br>";
                                                    }
                                                    else {
                                                        echo " <form action=\"reset.php\" method=\"get\">
                                                                 <input type=\"hidden\" name=\"reset\" value=$combined>
                                                                 <input type=\"submit\" value=\"Request Password Reset Email\">
                                                               </form><br>
                                                             ";
                                                    }

                                                }
                                            }

                                            ?>

                                        <br>

                                    </div>
                                </div>
                            </div>
                        </div>
                        <div id="columnB">
                            <div class="box">
                                <h2 class="header" id="first">Contact Us</h2>
                                <div class="content">
                                    <?php
                                        //include 'vars.php';
                                        echo $CONTACT;
                                        ?>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div style="clear: both;"></div>
                </div>
            </div>
            <p id='version'>
                    <?php
                        echo "Version: ". $_SESSION['VERSION'] . "&nbsp;&nbsp;&nbsp;";
                        ?>
                </p>
        </div>
        <div id="bottom-nav-container">
            <div id="bottom-nav">
            </div>
        </div>
        <div id="footer-container">
            <div id="footer">
                <div id="footer-text">
                    &copy; <script>
                        var d = new Date();
                        yr = d.getFullYear();
                        document.write(yr);
                    </script> Example
                </div>
            </div>
        </div>
    </body>
</html>
