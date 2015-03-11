---
layout: post
title: "raml and osprey - a better way to build mock apis"
date: 2015-03-07 21:06:54 +0000
comments: true
categories: raml, osprey, javascript, node.js, express
---

It is generally considered a good idea to develop and test your application against Mock services rather than the real thing. As we have been embarking on a new project, the team discussed the need for Mock services and how we would manage these. On prior projects, the effort in maintaining these was somewhat painful and I was a little weary.  One of the tools to help deal with the maintenance was [RAML](http://raml.org/). RAML stands for: `RESTful API Modeling Language`, it 

> ... is a simple and succinct way of describing practically-RESTful APIs. It encourages reuse, enables discovery and pattern-sharing, and aims for merit-based emergence of best practices. The goal is to help our current API ecosystem by solving immediate problems and then encourage ever-better API patterns. RAML is built on broadly-used standards such as YAML and JSON and is a non-proprietary, vendor-neutral open spec.

Our intention is to use this to define the APIs we want to build and interface with. Also to use the specification we create to validate both development and integration, and use that specification as the foundation for our Mocks. 

After further research I discovered [osprey](https://github.com/mulesoft/osprey), which is a

> ... JavaScript framework, based on Node and Express, for rapidly building applications that expose APIs described via RAML, the RESTful API Modeling Language.

While it's still in development and doesn't yet support documentation and the validation, you are able to very quickly standup a mock service with an api described with RAML. There's also [a CLI](https://github.com/mulesoft/osprey-cli) that allows you to scaffold an api based on a specification defined using RAML. 

I decided to spike things a little using the CLI tool. Once the CLI has been installed globally using NPM, you can simply run the following:

	osprey new --name hello-world
	
By default you should have a `api.raml` file created and stored under `src/assets/raml`. I then used that file to define my spike API using RAML:

```
#%RAML 0.8
---
title: Hello World API
baseUri: http://localhost:3000/api/{version}
version: v1
/users:
    get:
        description: Return all users
        responses:
            200:
                body:
                    application/json:
                        example: |
                            {
                               "data": [
                                   { "name": "foo" },
                                   { "name": "fee"}
                               ],
                               "success": true,
                               "status": 200
                             }
    /{usermame}:
        get:
            description: Say hello to the given username
            responses:
                200:
                   body:
                     application/json:
                      example: |
                         {
                           "data": {
                             "message": "Hello foo",
                           },
                           "success": true,
                           "status": 200
                         }
```

If you are familiar with [YAML](http://yaml.org/) and [JSON](http://json.org/) you will find the output very readable, even if you aren't I think you can still agree that this is quite accessible.

To validate the specification I had created, without having to start the server, I could run:

```
$ osprey list src/assets/raml/api.raml
GET             /users                                                                                          
GET             /users/{usermame}
```

Before being able to run the service I had to make a couple changes to the server javascript file `app.js`. 

```
var express = require('express');
var path = require('path');
var osprey = require('osprey');

var app = module.exports = express();

app.use(express.bodyParser());
app.use(express.methodOverride());
app.use(express.compress());
app.use(express.logger('dev'));

app.set('port', process.env.PORT || 3000);

api = osprey.create('/api/v1', app, {
    ramlFile: path.join(__dirname, '/assets/raml/api.raml'),
    logLevel: 'debug'  //  logLevel: off->No logs | info->Show Osprey modules initializations | debug->Show all
});

if (!module.parent) {
    var port = app.get('port');
    app.listen(port);
    console.log('listening on port ' + port);
}
```

To start the mock api service simply run:

	node /app/server.js
	
And you can now start exploring the API using your browser or any other tool you like to use to interact with an API. Being able to provide example data, quickly allows you to scaffold your mock service with data for your app.

It's only been a couple of hours of playing with these two tools, but it already feels so much easier to work with and maintain, than having to write a bunch of code to handle requests and responses.
	

