declare variable $arg1 external;
declare variable $arg2 external;
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
let $name := $arg1 => file:name()
let $ext := $name => substring-after('.')
let $base := $arg1 => substring-before( $name )
let $str := $arg2
let $item :=
  switch ( $ext )
  case "svg" return $str   => parse-xml()
  (: commonmark markdown converted by cmark to commonmark XML
   : using the -to XML flag The xml doc is a AST of markdown 
   : the doc can be converted to an article via a typeswitch in markup.xq
   : and wrapped to produce HTML via wrap.xq :)
  case "md" return $str   => parse-xml()
  case "csv" return $str  => csv:parse()
  case "json" return $str =>  parse-json()
  case "xml" return $str =>   parse-xml()
  (: html converted by tidyhtml5 to XML :)
  case "html" return $str  => parse-xml()
  default return error( $dbIO, ``[ [ `{$name}` ]  can not be parsed ]``)

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
    case "html" return $uriBase => concat( 'xhtml' )
    case "md" return $uriBase => concat( 'cmark' )
    (: the cmark extension is arbitary, it just tells me this is a cmark converted XML doc:)
    case "csv" return $uriBase => concat( $item => $getItemType())
    case "json" return $uriBase => concat( $item => $getItemType())
    default return   error( $dbIO, ``[ [ `{$ext}` ] can not handle extension ]``) 

return (
local:store($item, $uri) ,
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

