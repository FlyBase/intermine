FlyBase InterMine (FlyBaseMine)
===================================

Dockerized FlyBase implementation of the [InterMine](http://intermine.org) software.

Getting Started With FlyBaseMine
-------------------------------

**Initial setup**

Pull and run the FlyBase InterMine Database image, changing the username and password
to values of your choosing.

```
docker run --name intermine-db -e POSTGRES_USER=intermine -e POSTGRES_PASSWORD=intermine -d flybase/intermine-db
```

Pull and run the FlyBase Tomcat image, be sure to change the user and password values for the manager user.

```
docker run --name intermine-tomcat -d --link intermine-db:db -p 8080:8080 -e TOMCAT_MANAGER_USER=intermine -e TOMCAT_MANAGER_PASSWORD=intermine flybase/intermine-tomcat
```

The ```--link``` flag tells docker to link the intermine-db container from the first line above to the tomcat conatiner and 
make the alias **db** on the tomcat instance.  In other words, **db** is how you will reference the database hostname
on the tomcat instance.  If you change the db alias you will need to update $HOME/.intermine/flybasemine.properties
on the build container.

If your host machine already has something binding port 8080, change the -p to <newport>:8080.

e.g.
```
docker run --name intermine-tomcat -d --link intermine-db:db -p 8888:8080 -e TOMCAT_MANAGER_USER=intermine -e TOMCAT_MANAGER_PASSWORD=intermine flybase/intermine-tomcat
```

Pull and run the FlyBase InterMine build image.

```
docker run -it -v /localhost/path/to/flybasemine_data:/data --name intermine-build --link intermine-db:db --link intermine-tomcat:tomcat flybase/intermine bash
```

The ```-v``` flag maps the host machine directory ```/localhost/path/to/flybasemine_data``` to the ```/data```` directory in the container.
If you omit the ```-v``` flag it will create an empty data directory on your container that you will have to populate with data files.  See
the /intermine/flybasemine/project.xml file for their expected names and locations.

Starting / Stopping
------------------------

Once you have done the intial setup, you can start and stop the containers with the 
```docker start <container_name>```
or
```docker stop <container_name>```

**Note**: Container links are specific to each container.  If you remove the database container you will need to create new tomcat and build containers as detailed in **Initial Setup** relink them.

TODO
-------------
