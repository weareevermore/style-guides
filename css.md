# CSS/SCSS Style Guide

## Table of Contents

1. [Indentation](#indentation)
1. [Spacing](#spacing)
1. [Selectors](#selectors)
1. [Formating](#formating)
1. [Tips](#tips)

## Indentation

* Use soft-tabs set to 2 spaces.

```scss
.post-title {
∙∙property: value;
}
```

* Indent SCSS nested rules with one level, relevant to their parent.

```scss
.post-title {
  // ....

  .post-title-date {
    // ....
  }
}
```

## Spacing

* Selectors should be on a single line.
* There should be a space after the last selector, followed by an opening brace.
* A selector block should end with a closing curly brace that is unindented and on a separate line.

```scss
// bad
.title{}

// good
.title {}
```

* A blank line should be placed between each selector block. Selectors should never be indented.

```scss
// bad
.page-title {
}
.page-body {
}

// good
.page-title {
}

.page-body {

}
```

* Multiple selectors should each be on a single line, with no space after each comma.

```scss
// bad
.title, .sub-title {}

// good
.title,
.sub-title {
}
```

* Property-value pairs should be on its own line, indented one level, have a space after `:`
  and end in a semicolon

```scss
// bad
.title {
  font-size:16px; font-weight:bold
}

// good
.title {
  font-size: 16px;
  font-weight: bold;
}
```

* In instances where a rule set includes only one declaration, consider
  removing line breaks for readability and faster editing.

```scss
.icon     { background-position: 0 0; }
.icon-home  { background-position: 0 -20px; }
.icon-account { background-position: 0 -40px; }
```

## Selectors

* Use lower cased letters with words separated by `-`.

```scss
// bad
.posttitle {}

// good
.post-title {}
```

* Don't use IDs for style purposes because of their heightened specificity.
  For more, refer to [CSS Wizardry’s “Pain in the class” blog post](http://csswizardry.com/2011/09/when-using-ids-can-be-a-pain-in-the-class/).

```scss
// bad
#authorName {}

// good
.author-name {}
```

* Don't use too specific selectors. It's a better idea to introduce a new class instead.
  Refer to [Writing efficient CSS](https://developer.mozilla.org/en-US/docs/Web/Guide/CSS/Writing_efficient_CSS)
  for more info.

```scss
// bad
.post h1 small {}

// good
.post-sub-title {}
```

* Use namespace for the building blocks and stick to the name. For example, here the
  block is a comment and all the class names start with the name of the block, which
  is `comment`.

```html
<div class="comment">
  <div class="comment-body">
    <!-- ..... -->
    <span class="comment-author"></span>
  </div>
  <time class="comment-date"></time>
</div>
```

## Formating

* Group your properties by type.

```scss
.selector {
  // Positioning
  position: absolute;
  z-index: 10;
  top: 0;
  right: 0;

  // Display
  display: inline-block;
  overflow: hidden;
  box-sizing: border-box;
  width: 100px;
  height: 100px;
  padding: 10px;
  border: 10px solid #333;
  margin: 10px;

  // Color
  background: #000;
  color: #fff

  // Text
  font-family: sans-serif;
  font-size: 16px;
  line-height: 1.4;
  text-align: right;

  // Other
  cursor: pointer;
}
```

* Don't add units for property values of zero

```scss
// bad
margin-top: 0px;

// good
margin-top: 0;
```

* Do not nest the SCSS rules under the parent element as it will limit the searching
  (or the Go to symbol)

```scss
// bad
.post {

  &-title {}
  &-sub-title {}
}

// good
.post {}
.post-title {}
.post-sub-title {}
```

* Always put `@extend` and `@include` right after the opening bracket and
  add a blank line after them.

```scss
.title {
  @extend %large-title;
  @include hover-effect();

  // the rest of the rules
}
```

## Tips

Try and write composable CSS to improve reusability and readability in your markup.
For example, here is a usage of composable css rules

```html
<form class="search search-full pull-right">
</form>
```

instead of

```html
<form class="search-full-pulled-right">
</form>
```
