declare namespace cm ="http://commonmark.org/xml/1.0";
declare variable $arg1 external;
declare variable $arg2 external;
declare variable $dbIO := QName("http://markup.nz/#err", 'dbIO');
(:~
 : transform a commonmark xml do into a html content block 
:)

declare
function local:head( $map as map(*) ) as element() {
  element head {
    element meta {
      attribute http-equiv { "Content-Type"},
      attribute content { "text/html; charset=UTF-8"}
      },
    element title { $map?title}
  }
};

declare
function local:article( $map as map(*) ) as element() {
  element html {
    attribute lang {'en'},
    $map => local:head(),
    element body {
      element main {
        element article  {
          $map?content/node()
        }
      }
    }
  }
};

try {
let $doc :=  $arg1 => doc()
let $content := map { 'content': $doc/* }
let $obj := $arg2 => parse-json()
let $map := map:merge(( $obj, $content))
let $article :=  $map => local:article() => serialize()
return $article } catch * {
``[
  ERROR!
  module: `{$err:module}`
  line number: `{$err:line-number}`
 `{$err:code}`: `{$err:description}`
]``
}

