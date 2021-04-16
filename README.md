# xqerl-cli

`xq` is a terminal cli for a dockerized xqerl

 [xqerl](https://zadean.github.io/xqerl)
 maintained by 
 [Zachary Dean](https://github.com/zadean),
 is an Erlang XQuery 3.1 Processor and XML Database.

The small size of the dockerized xqerl make it ideal for
building microservices and modern data driven websites.

This repo also a provides a simple directory structure,
you can use as a template when creating xQuery projects.

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

Although xqerl database promotes itself a XML database is much more.
It is in reality a database for any
[ XQuery and XPath Data items](https://www.w3.org/TR/xpath-datamodel-31/) (**XDM**).

As well as XDM items the database can store **link** items.
A db *link* is a reference to binary or unparsed text file on the containers file system

## xqerl database CRUD operations with `xq`

Create Read Update Delete

## `xq put {path}` 

This command stores a file as a XDM item in the database.

By convention we use the following directory structure to hold `src/data` files.

```
.
└── src
    ├── data
    │   └── example.com
    │       ├── content
    │       │   ├── index.md
    │       │   └── why-xqerl.md
    │       └── usecase
    │           ├── colors.json
    │           ├── employees.xml
    │           └── mildred.json

```

 ## TODO!






