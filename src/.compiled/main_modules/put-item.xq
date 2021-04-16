declare variable $arg external;
declare variable $dbIO := QName("http://markup.nz/#err", 'dbIO');
(:~
 : xqerl db can store any XDM item type
 : @see https://github.com/zadean/xqerl/blob/main/src/xqerl_mod_db.erl
:)

declare 
%updating 
function local:store($item, $uri){
  db:put( $item, $uri )
}; 

try {
let $argPath := ('/tmp', $arg ) => string-join('/')
let $path := 
  if ( $argPath  => file:is-file() ) 
  then $argPath => file:path-to-uri() => string()
  else ( error( $dbIO, ``[ file [ `{$argPath}` ] not found  ]``))
let $name := $path => file:name()
let $ext := $name => substring-after('.')
let $base := $arg => substring-before( $name )
let $item :=
  switch ( $ext )
  case "svg" return $path => file:read-text()  => parse-xml()
  case "csv" return $path => file:read-text()  => csv:parse()
  case "json" return $path => fn:json-doc()
  case "xml" return $path =>  file:read-text()  => parse-xml()
  (: cmark documents are the ones created via the cmark app 
   : using the -to XML flag The xml doc is a AST of markdown 
   : the doc can be converted to an article via a typeswitch in markup.xq
   : and wrapped to produce HTML via wrap.xq :)
  case "cmark" return $path =>  file:read-text()  => parse-xml()
  default return error( $dbIO, ``[ [ `{$ext}` ] handle can not be parsed ]``)

let $getFuncType := function( $item as item()) as xs:string {
      if ($item instance of map(*)) then 'map'
 else if ($item instance of array(*)) then 'array'
 else 'function'
}

let $getItemType := function( $item as item() ) as xs:string {
 if ( $item instance of document-node() ) then 'document-node'
 else if ( $item instance of function(*) ) then $item => $getFuncType()
 else ('atomic' )
}

let $uriBase := 'http://' || $base || substring-before( $name, '.') || '.'
let $uri := 
  switch ( $ext )
    case "svg" return $uriBase => concat( $ext )
    case "xml" return $uriBase => concat( $ext )
    case "cmark" return $uriBase => concat( $ext )
    case "csv" return $uriBase => concat( $item => $getItemType())
    case "json" return $uriBase => concat( $item => $getItemType())
    default return   error( $dbIO, ``[ [ `{$ext}` ] can not handle extension ]``) 

return (
local:store($item, $uri)
,
``[ - ok: stored into db
 - XDM item: `{$item => $getItemType()}` 
 - location: `{$uri}`]``
  )
} catch * {
``[
  ERROR!
  module: `{$err:module}`
  line number: `{$err:line-number}`
 `{$err:code}`: `{$err:description}`
]``
}

