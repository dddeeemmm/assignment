Nginx
=========

    Install and configure Nginx on Centos7

Role Variables
--------------

    nginx_packages - packages will be installed
    nginx_user     - running proces from

Example Playbook
----------------

    - hosts: nginx
      become: true
      roles:
        - { name: nginx, tags: nginx }

License
-------

    MIT

Author Information
------------------

    Dmitrij Petrov
