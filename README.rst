

::

    ________       ______ __________             _____              
    ___  __ \___  ____  /____  /__(_)___________ __  /______________
    __  /_/ /  / / /_  __ \_  /__  /_  ___/  __ `/  __/  __ \_  ___/
    _  ____// /_/ /_  /_/ /  / _  / / /__ / /_/ // /_ / /_/ /  /    
    /_/     \__,_/ /_.___//_/  /_/  \___/ \__,_/ \__/ \____//_/     


----
   
|build|_

in-memory pub-sub server that works on http-rest interface.

How to build a release
======================
To use publicator in a production system, you should package it. Your package will include all dependencies including erlang runtime itself. So you won't need erlang installed on your production system in order to run it. To generate a package first download source code from github.

::

   $ git clone git://github.com/huseyinyilmaz/publicator.git

Now you can generate a package for your system.

::

   $ make configure
   $ make

publicator.tar.gz will be generated in project root directory (current directory). You can untar it anywhere in your target system and run it with 

::

   $ bin/publicator start


How to configure for development
================================

If you want to checkout the code you can configure the system for development.

::

   $ make configure-dev

This will download development dependencies. After this you can start server in development mode with

::

   $ make start   

You can also run eunit tests with the following.

::

   $ make test

If you do not want to full compile before starting to test use following

::

   $ make eunit
   

Usage
=====

Websocket Interface
-------------------

In order to connect publicator server through websocket, publicater-client.js library can be used.


**publicator.get_session_id(callback)**

Before using the library, a session should be started on the server. This session will be used to track subscribed channels, received messages etc. In other words, session represents current consumer. Here is a sample code that requests a session from server. When a session_id is returned it will show it to user.

::

   publicator.get_session_id(
      function(session_id){
          alert(session_id);
   });

**publicator.get_client(session_id):**

After getting a session id a client object can be created with get_client method

::

  client = publicator.get_client(session_id);

Returned client object has various methods to work through given session.

Here is some methods on client that can be used to interact with your session.

* *client.subscribe(channel_code):* subscribes to given channel;
* *client.unsubscribe(channel_code):* unsubscribes from given channel;
* *client.get_subscribtions():* returns the list of subscribtions;
* *client.publish(channel_code, message):* publishes given message on given channel.

Client also provides some events that you can register so you can get avare of changes on the system. Here are some events that you can register handlers for.

* *client.onopen(function(){alert("opened")}):* This event is fired when a new connection is started between server and client.
* *client.ondisconnect(function(){alert("disconnected")}):* This if fired when connection is lost for various reasons like network problems.
* *onmessage(function(message){alert(message)}):* If a message received to any channel that current consumer is subscribed, this event will be fired with that message. message will have following format {type: "message", data: "msg_text", channel_code: "chn_code"}
* *client.onhearthbeat(function(){alert("hearth beat received")}):* Heartbeats are created in specific intervals. They are usefull if client does not support websockets and server had to connect an alternative way. They are probably be not really use full for clients.
  
  
Rest Interface
--------------

First thing you should do to use publictor is to get a session id from the system. You can get your session id from session/

::

   $ curl http://localhost:8766/session/
   {"session":"session123"}

Here You get a session id "session123" from the system. With this session id You can use publicator. System will recognize You with this session id and associates your subscribed channels to You.

To subscribe a channel:

::

   $ curl --request POST http://localhost:8766/$SESSION_ID/subscribtions/$CHANNEL_CODE/ \
   --include \
   --header "Content-Type: application/json"

   HTTP/1.1 204 No Content
   connection: keep-alive
   server: Cowboy
   date: Sun, 29 Sep 2013 10:29:07 GMT
   content-length: 0
   content-type: text/html


To unscribe a channel:

::

   $ curl --request DELETE http://localhost:8766/$SESSION_ID/subscribtions/$CHANNEL_CODE/ \
   --include \
   --header "Content-Type: application/json"

   HTTP/1.1 204 No Content
   connection: keep-alive
   server: Cowboy
   date: Sun, 29 Sep 2013 10:43:00 GMT
   content-length: 0
   content-type: text/html

To send a message to a channel:

::

   $ curl --request POST http://localhost:8766/$SESSION_ID/messages/$CHANNEL_CODE/ \
   --include \
   --header "Content-Type: application/json" \
   --data "message=Message1"

   HTTP/1.1 204 No Content
   connection: keep-alive
   server: Cowboy
   date: Sun, 29 Sep 2013 10:47:38 GMT
   content-length: 0
   content-type: text/html

To check for incoming messages that is coming from your subscribed channels:

::

   $ curl --request GET http://localhost:8766/$SESSION_ID2/messages/ \
   --include \
   --header "Content-Type: application/json"

   HTTP/1.1 200 OK
   connection: keep-alive
   server: Cowboy
   date: Sun, 29 Sep 2013 10:48:46 GMT
   content-length: 25
   content-type: text/plain
   vary: accept

   {"channel1":["Message1"]}

Please beware that message publishers do not receive messages they sent. Thats why in this example we are receiving messages from different session id. Format of message url is channel_code to message list mapping. for instance

::

   {"channel_name1": ["msg1", "msg2",......],
    "channel_name2": ["msg3", "msg4",......],
    .....
   }

.. |build| image:: https://travis-ci.org/huseyinyilmaz/publicator.png
.. _build: https://travis-ci.org/huseyinyilmaz/publicator
