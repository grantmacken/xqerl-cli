declare namespace cm ="http://commonmark.org/xml/1.0";
declare variable $arg external;
declare variable $dbIO := QName("http://markup.nz/#err", 'dbIO');
(:~
 : transform a commonmark xml do into a html article block 
:)

declare 
%updating 
function local:store($item, $uri){
  db:put( $item, $uri )
};

declare
function local:dispatch( $nodes as node()* ) as item()* {
 for $node in $nodes
  return
    typeswitch ($node)
    case document-node() return (
        for $child in $node/node()
        return ( local:dispatch( $child) )
        )
     case element( cm:document ) return local:document( $node )
    (: BLOCK :)
    case element( cm:block_quote ) return 'blockquote' => local:block( $node )
    case element( cm:list ) return $node => local:list( )
    case element( cm:item ) return 
      if ( $node/parent::node()/@tight/string() = 'true' )
      then $node => local:tightListItem( )
      else  'li' => local:block( $node )
 (:=> local:block( $node ):)
    case element( cm:code_block ) return  $node => local:codeBlock( )
    case element( cm:paragraph ) return  'p' => local:block( $node )
    case element( cm:heading ) return local:heading( $node )
    case element( cm:thematic_break )  return 'hr' => local:block( $node )
    case element( cm:html_block ) return local:htmlBlock( $node )
    (: INLINE:)
    case element( cm:text ) return $node/text()
    (: TODO! softbreaks :)
    case element( cm:softbreak ) return ( )
    case element( cm:linebreak ) return 'br' => local:inline( $node ) 
    case element( cm:code ) return 'code' => local:inline( $node )
    case element( cm:emph ) return 'em' => local:inline( $node )
    case element( cm:strong ) return 'strong' => local:inline( $node )
    case element( cm:link ) return local:link( $node )
    case element( cm:image ) return $node => local:image( )
    (: case element( cm:html_inline ) return local:passthru( $node ) :)
    (: case element( cm:custom_inline ) return local:passthru( $node ) :)
    case element() return local:passthru( $node )
    default return $node
};

declare
function local:passthru( $node as node()* ) as item()* {
       element { local-name($node) } {
          for $child in $node
          return local:dispatch($child/node())
          }
};

(: common attr :)
declare
function local:attrTitle( $node as node()* ) as item()* {
  if ( normalize-space($node/@title/string()) = '') then ()
  else( attribute title { $node/@title }) 
};


declare
function local:inline( $tag as xs:string, $node as node()* ) as item()* {
element {$tag}{ 
 for $child in $node
 return local:dispatch($child/node())
 }
};

declare
function local:block( $tag as xs:string, $node as node()* ) as item()* {
element {$tag}{ 
 for $child in $node
 return local:dispatch($child/node())
 }
};

declare
function local:image( $node as node()* ) as item()* {
element img {
    attribute src { $node/@destination/string() },
    $node => local:attrTitle(),
    attribute alt { $node/cm:text/string() }
 }
};

declare
function local:document( $node as node()* ) as item()* {
element article {
 for $child in $node
 return local:dispatch($child/node())
 }
};

declare
function local:list( $node as node()* ) as item()* {
(: bullet markers (-, +, or *) or (b))   :)
(: list markers (either . or )   :)
if ($node/@type = 'bullet'  ) 
then 
  element ul {
  for $child in $node
  return local:dispatch($child/node())
  }
else
  element ol {
  for $child in $node
  return local:dispatch($child/node())
  }
};

declare
function local:tightListItem( $node as node()* ) as item()* {
  element li {
  for $child in $node/node()
  return local:dispatch($child/node())
  }
};

declare
function local:htmlBlock( $node as node()* ) as item()* {
try {
  $node/data() => string() => parse-xml-fragment()
  (: serialize(map{"method": "text"}) :)
 } catch * {``[ could not parse ]``}
};


(: TODO! @info code :)
declare
function local:codeBlock( $node as node()* ) as item()* {
element pre {
    element code {
        if ( $node/@info  )  
        then ( attribute class { 'language-' || $node/@info/string() })
        else (),
        for $child in $node
        return local:dispatch($child/node())
    }
 }
};

declare
function local:heading( $node as node()* ) as item()* {
element { concat('h', $node/@level/string() )  } {
 for $child in $node
 return local:dispatch($child/node())
 }
};

declare
function local:link( $node as node()* ) as item()* {
element a { 
  attribute href { $node/@destination },
    $node => local:attrTitle(),
    for $child in $node
    return local:dispatch($child/node())
    }
};

try {
let $name := $arg => file:name()
let $ext := $name => substring-after('.')
let $base := $arg => substring-before( $name )
let $uri := $base || substring-before( $name, '.') || '.' || 'article'
return  (
  $arg => 
  doc() => 
  local:dispatch()  =>
  local:store($uri)
,
``[ - ok: stored into db
 - XDM item: `document-node` 
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

