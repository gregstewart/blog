---
layout: post
title: "clojure-data-structures"
date: 2015-05-17 12:15:14 +0100
comments: true
categories: clojure, data, structures
---

Always easier to remember things when you write them down `:)`.

**Equality**

```
(= 1 1)
=> true
(= "test" "test")
=> true
(= [1 2 3] [1 2 3])
=> true
```

**Strings**

Use double quotes to delineate strings, e.g. : `"This is a string"`

For concatenation use `str` function:

```
(def name "string")
(str "This is a " name)
=> "This is a string"
```

**Maps**

Map values can be of any type and can be nested.

```
{:first 1
 :second {:name "Greg" :surname "Stewart"}
 :third "My name"}
```

Use `get` to look up values and `get-in` to look up values in nested maps. Instead of `get` you can treat it as a function with the key as a parameter.

```
(def my_map {:first 1
#_=>  :second {:name "Greg" :surname "Stewart"}
#_=>  :third "My name"})

(get my_map :first)
=> 1
(get-in my_map [:second :name])
=> "Greg"
(my_map :first)
=> 1
```

**Keywords**

In these examples `:first` is a keyword. Key words can be used as functions: 

```
(:first my map)
=> 1
```

**Vectors**

Think array in other languages. Elements of a Vector can be of any type and you can retrieve values using get as well.

```
(def my_vector [1 "a" {:name "Greg"}])
(get my_vector 0)
=> 1
```

Can also be created using `vector` function:

```
(vector "hello" "world" "!")
=> ["hello" "world" "!"]
```

Using `conj` you add elements to a vector. Elements get added to the _end_ of a vector.

**Lists**

Like vectors, however you can't use `get` to retrieve values. Use `nth` instead

```
(def my_list '("foo" "bar" "baz"))
(nth my_list 1)
=> "bar"
```

Lists can be created using the `list` function. Use `conj` to add items to a list. Unlike vectors they get added to the _beginning_ of the list.

**Sets**

Collection of unique values. Created either using `#{}` or `set`.

```
(def my_set set [3 3 3 4 4])
#{4 3}
```

Use `get` to retrieve values. You can create using `hash-set` or `sorted-set` as well:

```
(hash-set 3 1 3 3 2 4 4)
=> #{1 4 3 2}
(sorted-set 3 1 3 3 2 4 4)
=> #{1 2 3 4}
``` 

**Symbols**

Another assignment method, however apparently we can manipulate them as if they were data. Not sure that means yet.

**Quoting**

`'` is referred to as quoting. 