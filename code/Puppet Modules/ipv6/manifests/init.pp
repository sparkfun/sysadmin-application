class ipv6 {

    # Turn off IPv6 support in Postfix
    augeas { "postfix_main.cf":
        context => "/files/etc/postfix/main.cf",
        changes => [
            "set inet_protocols ipv4"
        ],
        #notify => Service["postfix"],
    }

    # Restart Postfix if config file changed
    service { "postfix":
        subscribe => Augeas["postfix_main.cf"],
    }

}
