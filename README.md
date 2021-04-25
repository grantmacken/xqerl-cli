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
 - [x] `xq list {db-uri}` given *db-uri*, return uri list of db resources
 - [x] `xq available {db-uri}` given *db-uri*, return true or false
 - [ ] `xq type {db-uri}` given *db-uri*, return the db XDM type
 - [x] `xq get {db-uri}` given *db-uri*, return serialized db XDM item
 - [x] `xq get {db-uri}` `{xpath}` given *db-uri* and *xpath* expression, return serialized XML string
 - [ ] `xq get {db-uri}` `{lookup}` given *db-uri* and *lookup* expression, return serialized JSON item
 - [ ] `xq collect {db-collection-uri}` given *db-collection-uri*,  collect sequence, return serialized items
 - [ ] `xq collect {db-collection-uri}` `{simple map expression}`  
  given *db-collection-uri*, collect sequence, apply bang expression then return  return serialized items
 - [ ] `xq collect {db-collection-uri}` `{arrow expression}`  given *db-collection-uri*,  return serialized db XDM items
  given *db-collection-uri*, collect sequence, apply arrow expression then return serialized item or items 
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
 - [ ] `make restore` restore xqerl docker volumes with backup tars   

## Getting Started

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
Each base-URI constitutes a separate database.

```
http://example.com` # database 1
http://markup.nz`   # database 2
```

Each database contains collections of items referenced as URIs.

- db **base** uri: http://example.com 
- db **collection**  http://example/examples  
- db **item** http://example/examples/employees.xml 

## xqerl database items

The xqerl database can store 

1. [ XQuery and XPath Data Model](https://www.w3.org/TR/xpath-datamodel-31/) (**XDM**) items. These include document-nodes, arrays, maps and functions

2. links A db *link* is a reference to binary or unparsed text file on the containers file system

# xqerl database CRUD operations

Create Read Update Delete

## Create

 - `xq put {file-path}`
 - `xq plonk {file-path}` TODO! put unparsed text into db
 - `xq link {file-path}`


#### Put

`xq put {file-path}`

Given a path argument, 
the put command stores a file as a XDM item into the database, 
then returns the location of the stored file.

By convention all the data sources are in the `src/data` directory
so a path can either start with a 'domain' name 
e.g. `example.com/examples/employees.xml` or use the full path `src/data/example.com/examples/employees.xml`.
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

*example*: store employees data into xqerl database

```
> xq put example.com/examples/employees.xml
 - ok: stored into db
 - XDM item: document-node
 - location: http://example.com/examples/employees.xml
```

The xqerl database can store other XDM items beside XML documents as a document-nodes.
Lets store some JSON documents.

*example*: 
 1. with 'mildred' JSON file store this contact data into db
 2. with 'colors' JSON file store this list of colors data into db

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

As you can see from the output the 'mildred.json' doc is now a xqerl db stored 
'map' item and the 'colors.json' doc is now a xqerl db stored 'map' item. 
Other data sources can be converted into XDM items.

**CSV* **example*: 
 with entry_exit.csv store this data into db as array.

```
> xq put src/data/example.com/examples/entry_exit.csv
 - ok: stored into db
 - XDM item: array
 - location: http://example.com/examples/entry_exit.array
```

##### Using dockerized helpers

With some dockerized helpers, we can store other data as XDM items.
 Remember if we can turn our data source into db stored XDM items,
 then the full drill down, filter, extract and manipulate power of 
 xPath and XQuery is available. 

 ##### [CommonMark](https://commonmark.org/) to XML

 *note*: cmark is the tool github uses to convert this README
  into HTML

A [dockerized](https://github.com/grantmacken/alpine-cmark)
 [cmark](https://github.com/commonmark/cmark) can produce the
 intermediate cmark AST which is represented as a XML document.
 cmark uses the AST an intermediate stage to generate the HTML representation.
 We can stay with the produced AST XML representaion,
 and from this directly generate our HTML using xQuery.

**** *example*: 
 with index.md convert into
 [cmark XML](https://github.com/commonmark/commonmark-spec/blob/master/CommonMark.dtd) 
 then store into db as a **document-node**.

```
> xq put src/data/example.com/content/index.md
 - ok: stored into db
 - XDM item: document-node
 - location: http://example.com/content/index.cmark
```

Note: the cmark extension is an arbitrary construct. 
Note: TODO! - another section on cmark XML to HTML conversion using xQuery
modules

##### [html-tidy](https://www.html-tidy.org/) HTML to XML

A [dockerized htmltidy](https://github.com/grantmacken/alpine-htmltidy)
 can produce from a HTML source, a well formed XML document. 

**** *example*: 
 with hello-world.html convert into well-formed XML, 
 then store into db as a **document-node**.

```
> xq put src/data/example.com/examples/hello-world.html
 - ok: stored into db
 - XDM item: document-node
 - location: http://example.com/examples/hello-world.xhtml
```

Note: the xhtml extension is an arbitrary construct


#### Plonk

TODO!

#### Link

TODO!




### Read 

 - `xq list {db-uri}`
 - `xq available {db-uri}`
 - `xq get {db-uri}`
 - `xq get {db-uri} {xpath}`
 - `xq get {db-uri} {lookup}`
 

#### List

`xq list {db-path}`

*example*: lists items available in 'examples' collection

```
> xq list example.com/examples
http://example.com/examples/employees.xml
http://example.com/examples/hello-world.xhtml
http://example.com/examples/works.xml
http://example.com/examples/colors.array
http://example.com/examples/entry_exit.array
http://example.com/examples/mildred.map
```

#### Available

`xq list {db-path}`

*example*: is colors.array available in db

```
> xq available example.com/examples/colors.array
true
``` 

#### Get Item

- `xq get {db-uri}` 
 where the arg {db-uri} is an item in the database
 The command returns a serialized representation of a item.
 For document-nodes this will be a XML string.
 For arrays or maps this will be a JSON string.

 *example*: get a document-node 

```
> xq get example.com/examples/employees.xml
<employees>
    <employee>
        <employeeId>4</employeeId>
        <reportsTo>1</reportsTo>
        <name>Charles Madigen</name>
        <job>Chief Operating Officer</job>
        <Phone>x10962</Phone>
        <email>cmadigan@example.com</email>
        <department>Management</department>
        <salary>26200.00</salary>
        <gender>male</gender>
        <maritalStatus>married</maritalStatus>
        <employeeType>full time</employeeType>
    </employee>
</employees>
```

*example*: get an array item
```
> xq get example.com/examples/colors.array | jq '.'
[
  {
    "color": "Green"
  },
  {
    "color": "Pink"
  },
  {
    "color": "Lilac"
  },
  {
    "color": "Turquoise"
  },
  {
    "color": "Peach"
  },
  {
    "color": "Opal"
  },
  {
    "color": "Champagne"
  }
]
```

#### Get Then 
 
With db uri, 
 get **XDM** item
 then depending on item
 use **xPath** or **lookup** expression to drill down or filter,
 then optionally use 'arrow' or 'bang' to modify,
 to return serialized item or items

##### document node commands 

`xq get {db-uri} {xpath}`

Get document node,
 then apply xpath expression,
 to return a serialized XML string.

*example*: extract first employees name
```
> xq get example.com/examples/employees.xml '//employee[1]/name/string()'
Charles Madigen
```

Command: `xq get {db-uri} {xpath} {bang}`

 Get document node,
 then apply xpath expression,
 then use bang (simple map expression)
 to return result.

*example*: list active employees
```
> xq get example.com/examples/works.xml \
> '//employee[./status ="active"]' \
> '! concat(./@name/string(), " - " , ./status/string())'
Jane Doe 13 - active
```

Command: `xq get {db-uri} {xpath} {arrow}`

 Get document node,
 then get nodes with xpath expression,
 then use arrow expression
 to return result.

*example*: total hours worked
```
> xq get example.com/examples/works.xml '//employee/hours' '=> sum() => string()'
592
```

##### array and map commands

Command: `xq get {db-uri} {lookup}`

Get **map** or **array**,
 then use lookup expression
 to return object as a serialized JSON string.

*examples* with the Mildred map drill down to get address and town
```
> xq get example.com/examples/mildred.map '?address'
{"county":"Oxfordshire","postcode":"OX6 3PD","street":"91 High Street","town":"Biscester"}
> xq get example.com/examples/mildred.map '?address?town'
"Biscester"
```

Command: `xq get {db-uri} {lookup_expr} {bang_expr}` 

 Get **map** or **array**,
 then get object with lookup,
 then use bang expression
 to return a serialized JSON string.

*example*: list colors without Lilac
```
> xq get example.com/examples/colors.array '?*' '! ( .?color[not(. = "Lilac")] )'
["Champagne",
 "Green",
 "Opal",
 "Peach",
 "Pink",
 "Turquoise"]
```

Command: `xq get {db-uri} {bang-expr}`

Get **map** or **array**,
 then use bang expression
 to return a serialized JSON string.

*example*: format Mildreds' name 
```
> xq get example.com/examples/mildred.map '! ``[ `{.?firstname}` `{.?lastname}`]``'
 Mildred Moore
```

