Ansible is another configuration management tool I used. I really liked Ansible due to the fact I could quickly push to a few specific servers. It was harder to do this in Puppet because you could not define a server more than once in a group. For instance, we had the servers grouped by functionality. ie: oracle server, postgres server, application server.


In Puppet I would have had to make a custom fact to push a new yum repo to all the HP servers. In Ansible I just made a group called HP servers, and pushed the yum repo to each of the servers. It was easy solution using Ansible.
