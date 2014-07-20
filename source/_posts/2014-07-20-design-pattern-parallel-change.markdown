---
layout: post
title: "Design Pattern: Parallel Change"
date: 2014-07-20 11:35:49 +0100
comments: true
categories: [design patterns, parallel change, coding]
tags: [design patterns, parallel change, coding]
---
I recently read about [this pattern](http://martinfowler.com/bliki/ParallelChange.html) and was curious to
see who one would implement this in JavaScript. Below is the base class that will be refactored:


    function Grid() {
        this.cells = [[]];
    }

    Grid.prototype.addCell = function (x, y, cell) {
        this.cells[x][y] = cell;
    };

    Grid.prototype.fetchCell = function (x, y) {
        return this.cells[x][y];
    };

    Grid.prototype.isEmpty = function (x, y) {
        return this.cells[x][y] == null;
    };

In the example on the blog post, the x and y parameters were moved into a Coordinate object and the methods
in question simply overloaded. However we don't have this luxury in JavaScript. The simplest thing to do
would be to check the arguments being passed into the individual methods, so here's what that might look like:


    function Grid() {
        this.cells = [[]];
        this.newCells = [];

        this.findCell = function (coordinate) {
            var foundCell;
            this.newCells.forEach(function (cell) {
                if (cell.coordinate.x === coordinate.x && cell.coordinate.y === coordinate.y) {
                    foundCell = cell.cell;
                }
            });
            return foundCell;
        };
    }

    Grid.prototype.addCell = function (x, y, cell) {
        if(arguments.length > 2 && !isNaN(x)) {
            this.cells[x][y] = cell;
        } else {
            this.newCells.push({coordinate: x, cell: y});
        }
    };

    Grid.prototype.fetchCell = function (x, y) {
        if(arguments.length > 1 && !isNaN(x)) {
            return this.cells[x][y];
        } else {
            return this.findCell(x);
        }
    };

    Grid.prototype.isEmpty = function (x, y) {
        if(arguments.length > 1 && !isNaN(x)) {
            return this.cells[x][y] == null;
        } else {
            return this.findCell(x) == null;
        }
    };

Not exactly elegant, but it works. While looking into options for method overloading I found
[this post by John Resig](http://ejohn.org/blog/javascript-method-overloading/). Using his approach here's
what the original Grid class would look like:

    // addMethod - By John Resig (MIT Licensed)
    function addMethod(object, name, fn){
        var old = object[ name ];
        object[ name ] = function(){
            if ( fn.length == arguments.length )
                return fn.apply( this, arguments );
            else if ( typeof old == 'function' )
                return old.apply( this, arguments );
        };
    }

    function Grid() {
        this.cells = [[]];
    }

    addMethod(Grid.prototype, "addCell", function(x, y, cell){
        this.cells[x][y] = cell;
    });

    addMethod(Grid.prototype, "fetchCell", function(x, y){
        return this.cells[x][y];
    });

    addMethod(Grid.prototype, "isEmpty", function(x, y){
        return this.cells[x][y] == null;
    });

So let's go ahead and refactor the object to expand the interface and also take an object:


    // addMethod - By John Resig (MIT Licensed)
    function addMethod(object, name, fn){
        var old = object[ name ];
        object[ name ] = function(){
            if ( fn.length == arguments.length )
                return fn.apply( this, arguments );
            else if ( typeof old == 'function' )
                return old.apply( this, arguments );
        };
    }

    function Grid() {
        this.cells = [[]];
        this.newCells = [];

        this.findCell = function (coordinate) {
            var foundCell;
            this.newCells.forEach(function (cell) {
                if (cell.coordinate.x === coordinate.x && cell.coordinate.y === coordinate.y) {
                    foundCell = cell.cell;
                }
            });
            return foundCell;
        };
    }

    addMethod(Grid.prototype, "addCell", function(x, y, cell){
        this.cells[x][y] = cell;
    });

    addMethod(Grid.prototype, "addCell", function(coordinates, cell){
        this.newCells.push({coordinate: coordinates, cell: cell});

    });

    addMethod(Grid.prototype, "fetchCell", function(x, y){
        return this.cells[x][y];
    });

    addMethod(Grid.prototype, "fetchCell", function(coordinates){
        return this.findCell(coordinates);
    });

    addMethod(Grid.prototype, "isEmpty", function(x, y){
        return this.cells[x][y] == null;
    });

    addMethod(Grid.prototype, "isEmpty", function(coordinates){
        return this.findCell(coordinates) == null;
    });

For what's it's worth you can find the code and tests on
[my Github Design Pattern project](https://github.com/gregstewart/design-patterns)