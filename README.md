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

## xqerl database 
 [CRUD](https://en.wikipedia.org/wiki/Create,_read,_update_and_delete) 
 ops with xq

Create Read Update Delete

### Create

 - `xq put {file-path}`
 - `xq link {file-path}`
 - `xq plonk {file-path}` TODO! put unparsed text into db

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

#### Link

Command: `xq link {domain} {asset-path}`

Given a 'domain' and 'path' argument,
 the `xq link` command creates a link in the xqerl database
 to a preprocessed asset located on the containers file system.

TODO: link to why this  is a good thing.

All asset sources are located in the 
 `./src/static_assets/` directory 
 so the {asset-path} will be resolved as 
 `./src/static_assets/icons/article.svg`

Before the asset is stored the file can be 
 pipelined thru docker container instances 
 to get a preferred outcome. 
 For static assets this outcome usually means some form file size reduction.

By convention all the data sources are in the `src/data` directory,
 and it is no surprise that  *static asset* sources are 
 located in the `./src/static-assets/` directory

Preprocessing pipeline example which produces a gzipped svg file with a svgz extension
 1. article.svg => 
 2. scour => 
 3. zopfli => 
 4. article.svgz

The `xq link` command will produce two outcomes.

1. a binary asset on the static-assets container volume. The static-assets 
container volume is mounted on the xqerl `priv/static` container directory.
 `priv/static/icons/article.svgz`
2. A db `link` to the file asset.
 *example*: the db link 
  'http://example.com/icons/article' points to the file
  'file:///usr/local/xqerl/priv/static/icons/article.svgz'

note: links are searchable db items

*example*: create db link to compressed svgz file
 ```
> xq link example.com icons/article.svg
1. file: /usr/local/xqerl/priv/static/assets/icons/article.svgz
2. db link: http://example.com/icons/article.svgz
 ```

*example*: create db link to gzipped js file
 ```
> xq link example.com scripts/prism.js
1. file: /usr/local/xqerl/priv/static/assets/scripts/prism.js.gz
2. db link: http://example.com/scripts/prism.js.gz
 ```

*example*: create db link to gzipped css file
 ```
> xq link example.com src/static_assets/styles/index.css
1. file: /usr/local/xqerl/priv/static/assets/styles/index.css.gz
2. db link: http://example.com/styles/index.css.gz
 ```

*example*: create db link to font woff file
 ```
> xq link example.com fonts/ibm-plex-mono-v5-latin-regular.woff2
1. file: /usr/local/xqerl/priv/static/assets/fonts/ibm-plex-mono-v5-latin-regular.woff2
2. db link: http://example.com/fonts/ibm-plex-mono-v5-latin-regular.woff2
 ```
#### Plonk

TODO!

### Read or Retrieve 

 - `xq list {db-uri}`
 - `xq available {db-uri}`
 - `xq get {db-uri}`
 - `xq get {db-uri} {xpath-or-lookup}`
 - `xq get {db-uri} {xpath-or-lookup} {bang-or-arrow}`
 - WIP: `xq collect {db-uri}`

Database retrieval patterns
 1. **Find** `xq list {db-uri}` - items in db collections
  1.  retrieve *list* of uri 
  2.  with list apply *filter* TODO!
    - by item type ( document node,   )
    - document nodes - by root element ? 
    - map - by object key in item
    - by whatever
  3.  with list  *sort* TODO!
  4. display list
 2.  **Pick** `xq get {db-uri}` - retrieve and display a single sequence item 
   1. retrieve document-node then display serialized item as XML string
   2. retrieve array then display serialized item as JSON string
   3. retrieve array then display display serialized item as JSON string
 3. **Drill-down** `xq get {db-uri} {xpath-or-lookup}` - extract sequence item from parent
   1. extract node sequence with *xpath* expression then serialize each single item as XML string
   2. extract array object sequence with *lookup* expression then serialize each single item as JSON string
   2. extract map object sequence with *lookup* expression then item then serialize each single item as JSON string
 4. **Apply xQuery expression** `xq get {db-uri} {xpath-or-lookup} {bang-or-arrow}`
  with 'drill-down' result (a sequence item) apply **bang** or **arrow** expression

 

Document retrieval drill-down patten
{lhs} {op} {rhs}
 where {lhs} is either a 
  1. document node
  2. array or map item
{lhs} {op} {rhs}
 where {op} is either a
  1. path operator '/' if {lhs} is a document node
  2. lookup operator '?' if {lhs} is a map or array
{lhs} {op} {rhs} where {rhs} is ether 
 where {rhs} is either a
  1. step expression if {lhs} is a document node
  2. object lookup expression if {lhs} is a map or array

 Applying xQuery expression to drill-down result.

{lhs} {op} {rhs}
 where {lhs} a drill-down sequence item
{lhs} {op} {rhs}
 where {op} is either a 
  1. bang operator '!'
  1. arrow operator '=>'
{lhs} {op} {rhs}
 where {rhs} is a xQuery expression applicable bang or array expressions

```
( {drill-down result seq} ) => sum()
( {drill-down result seq} ) !  ./name/string()
```

#### List

Command: `xq list {db-uri}`

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

Command `xq available {db-uri}`

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

#### Get Item Then 
 
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
> xq get example.com/examples/employees.xml \
> '//employee[1]/name/string()'
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

*example*: format mildreds' name 
```
> xq get example.com/examples/mildred.map '! ``[ `{.?firstname}` `{.?lastname}`]``'
 Mildred Moore
```

<!--
#### Collect Sequence of Items

Command: `xq collect {db-uri} {bang-expr}`
-->

###  Update

' xq update {db-uri} [insert, replace, delete, rename ]'

xqerl implements the 
 [xQuery update facility](https://www.w3.org/TR/xquery-update-30/)

 - insert
 - replace
 - delete
 - rename

#### Update Insert

*example*:  add more hours for employee[3] 
```
xq get example.com/examples/works.xml '//employee[3]/hours => sum()'
xq update example.com/examples/works.xml insert node '<hours>40</hours>' into '//employee[3]'
xq get example.com/examples/works.xml '//employee[3]/hours => sum()'
```

#### Update Delete

Update db document, with delete expression

`xq update {db-uri} delete ...`


*example* delete first lot of hours for employee[2]
```
xq get example.com/examples/works.xml '//employee[2]/hours => sum()'
xq update example.com/examples/works.xml delete node '//employee[2]/hours[1]'
xq get example.com/examples/works.xml '//employee[2]/hours => sum()'
```

#### Update Replace

Update db document, with replace expression

`xq update {db-uri} replace   ...`


*example*  correct the hours for employee[1]
```
xq get example.com/examples/works.xml '//employee[1]/hours => sum()'
 xq update example.com/examples/works.xml replace node '//employee[1]/hours[1]' with '<hours>25</hours>'
xq get example.com/examples/works.xml '//employee[1]/hours => sum()'
```

