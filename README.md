# xqerl-cli

`xq` is a terminal cli for a dockerized [xqerl](https://zadean.github.io/xqerl))

 [xqerl](https://zadean.github.io/xqerl)
 maintained by 
 [Zachary Dean](https://github.com/zadean),
 is an Erlang XQuery 3.1 Processor and XML Database.

The small size of the dockerized xqerl make it ideal for
building microservices and modern data driven websites.

This repo also a provides a simple directory structure,
you can use as a template when creating xQuery projects.

## WIP xq commands 

xq Create Read Update Delete (CRUD) commands for working with xqerl database
 - [x] `xq put {srcFile}` given *srcFile*, **create** a db XDM item then return 
db location URI 
 - [x] `xq link {srcFile}` given *domain* and *srcFile*, **create** a db link 
to a binary or unparsed text file then return db location URI 
 - [x] `xq get {db-uri}` given *db-uri*, return serialized db XDM item
 - [x] `xq list {db-uri}` given *db-uri*, return uri list of db resources
 - [x] `xq available {db-uri}` given *db-uri*, return true or false
 - [ ] `xq type {db-uri}` given *db-uri*, return the db XDM type
 - [x] `xq update {db-uri} {update-expression}` given *db-uri* and 
*update-expression*, **update** XML resource, then return true or false
 - [x] `xq delete {db-uri}` given *db-uri*, **delete** item, then return true 
or false
 - [ ] `xq destroy {db-uri}` given *db-uri*, **destroy** everything in db 
collection, then return true or false

## WIP make commands
 - [x] `make up` run a dockerized xqerl instance 
 - [x] `make down` stop dockerized xqerl instance 
 - [ ] `make boot` on os boot run a dockerized xqerl instance using systemd
 - [x] `make escripts` copy any changed escripts into running xqerl instance 
 - [x] `make main-modules` copy and check compile status of any changed xQuery main-modules
 - [ ] `make library-modules` copy and compile an ordered list of  xQuery library-modules
 - [ ] `make watch` watch for changes to escripts, main-modules and library-modules 
 - [ ] `make backup` tar xqerl docker volumes 
 - [ ] `make retstore` restore xqerl docker volumes with backup tars   


# Getting Started

```
git clone git@github.com:grantmacken/.git
cd xqerl-cli
make init
xq
```

`make init` will make sure xq is on your exec path,
so you can type in `xq` instead of `bin/xq`
`make init` also pulls down in some images.
The main image is the dockerized xqerl application.

`xq` makes calls to a running dockerized xqerl so 
you need to start the container before running some commands

**Note!** When using `make` or `xq` stay in a xQuery project root.

```
make up
```

When up, the running containers name is *xq*.
The terminal `xq` cli app is a simple executable written in bash,
that communicates with the running *xq* container.

## The xqerl database intro

The xqerl database engine can handle multiple base-URI databases.
A base-URI is schema plus domain `{schema}://{domain}`).
example `http://example.com`.
Each each base-URI constitutes a separate database.

```
http://example.com` # database 1
http://markup.nz`   # database 2
```

Each database contains collections of items referenced as URIs.

- db **base** uri: http://example.com 
- db **collection**  http://example/examples  
- db **item** http://example/examples/employees.xml 

## db items

The xqerl database can store 

1. [ XQuery and XPath Data Model](https://www.w3.org/TR/xpath-datamodel-31/) (**XDM**) items. These include document-nodes, arrays, maps and functions

2. links A db *link* is a reference to binary or unparsed text file on the containers file system

## xqerl database CRUD operations with `xq`

Create Read Update Delete

### `xq put {path}`

Given a path argument, 
the put command stores a file as a XDM item into the database, 
then returns the location of the stored file

By convention all the data source are in the src/data directory
so the path can either start with a 'domain' name 
e.g. example.com/examples/employees.xml or use the full path src/data/example.com/examples/employees.xml.
What ever the case the path must include the domain name, as the domain name becomes the base-uri 
part of the db stored location uri

```
.
└── src
    ├── data
    │   └── example.com           -> *base uri*: http://example 
    │       └── examples          -> *collection uri*: http://example/examples    
    │           ├── employees.xml -> *item uri*: http://example/examples/employees.xml
```


```
> xq put example.com/examples/employees.xml
 - ok: stored into db
 - XDM item: document-node
 - location: http://example.com/examples/employees.xml
 ```

The xqerl database can store other XDM items beside XML documents as a document-nodes.
Lets store some JSON documents.

```
> xq put src/data/example.com/examples/mildred.json
 - ok: stored into db
 - XDM item: map
 - location: http://example.com/examples/mildred.map
> xq put src/data/example.com/examples/colors.json
 - ok: stored into db
 - XDM item: array
 - location: http://example.com/examples/colors.array
 ```

As you can see from the output the 'mildred.json' doc a now a xqerl db stored 'map' item
and the 'colors.json' doc a now a xqerl db stored 'map' item.

Other data sources can be converted into XDM items

**CSV** stored as an array item via the csv module
```
> xq put src/data/example.com/examples/entry_exit.csv
 - ok: stored into db
 - XDM item: array
 - location: http://example.com/examples/entry_exit.array
```

 **markdown** stored as an document-node item. The document-node item is the result of markdown src ran thru a dockerized cmark with the -to xml flag set. 

```
> xq put src/data/example.com/content/index.md
 - ok: stored into db
 - XDM item: document-node
 - location: http://example.com/content/index.cmark
```
 The cmark extension is a arbitrary construct, so I know is a XML doc produced
 by cmark. 

 **html** stored as an document-node item. The document-node item is the result of a html src ran thru a dockerized tidyhtml5 with flags set to produce XML.

```
> xq put src/data/example.com/examples/hello-world.html
 - ok: stored into db
 - XDM item: document-node
 - location: http://example.com/examples/hello-world.xhtml




