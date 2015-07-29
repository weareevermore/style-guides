# HTML Style Guide

## Table of Contents

1. [General Formating](#general-formating)
    1. [Indentation](#indentation)
    1. [Line Breaks](#line-breaks)
1. [Lean Markup](#lean-code)
1. [Forms](#forms)
    1. [Boolean Attributes](#boolean-attributes)
1. [Tables](#tables)
1. [Comments](#comments)

## General Formating

* Paragraphs of text should always be placed in a `<p>` tag.
  Never use multiple `<br>` tags.
* Items in list form should always be in `<ul>`, `<ol>`, or `<dl>`.
  Never use a set of `<div>` or `<p>`.

```html
<!-- bad -->
<div class="friends">
    <p class="friend">John Snow</p>
    <p class="friend">Eddark Stark</p>
</div>

<!-- good -->
<ul class="friends reset-list">
    <li class="friend">John Snow</li>
    <li class="friend">Eddark Stark</li>
</ul>
```

* Every form input that has text attached should utilize a <label> tag.
  Especially radio or checkbox elements.
* Even though quotes around attributes is optional, always put quotes
  around attributes for readability.

```html
<!-- bad -->
<input type=text class=form-control>

<!-- good -->
<input type="text" class="form-control">
```

* Avoid writing closing tag comments, like `<!-- /.element -->`. This just
  adds to page load time. Plus, most editors have indentation guides and
  open-close tag highlighting.
* Avoid trailing slashes in self-closing elements. For example,
  `<br>`, `<hr>`, `<img>`, and `<input>`.
* Don’t set tabindex manually—rely on the browser to set the order.

### Indentation

* Use soft-tabs set to 4 spaces.

```html
<div class="post">
    <h1 class="post-title">Awesome post</h1>
    <div class="post-body">
        Lorem ipsum dolor sit amet....
    </div>
</div>
```

### Line Breaks

* Break to a new line if the tag contains another element

```html
<!-- bad -->
<p>For more info click <a href="#">here</a></p>

<!-- good -->
<p>
    For more info click
    <a href="#">here</a>
</p>
```

* Break to a new line if the content of the tag is longer

```html
<div class="about">
    Lorem ipsum dolor sit amet, consectetur adipisicing elit.
    Deleniti delectus eum molestias fugit a recusandae eius iusto
    quisquam aut pariatur, neque, excepturi ipsum distinctio libero,
    maxime odit illo similique qui.
</div>
```

## Lean Markup

* Whenever possible, avoid superfluous parent elements when writing HTML.
  Many times this requires iteration and refactoring, but produces less HTML.
  For example:

```html
<!-- not so great -->
<span class="avatar">
    <img src="...">
</span>

<!-- better -->
<img class="avatar" src="...">
```

```html
<!-- bad -->
<nav class="nav">
    <ul>
        <li><a class="nav-link" href="/about">About</a></li>
        <li><a class="nav-link" href="/team">Team</a></li>
        <li><a class="nav-link" href="/contact">Contact</a></li>
    </ul>
</nav>

<!-- good -->
<nav class="nav">
    <a class="nav-link" href="/about">About</a>
    <a class="nav-link" href="/team">Team</a>
    <a class="nav-link" href="/contact">Contact</a>
</nav>
```

* Always use semantically correct elements

```html
<!-- bad -->
<div class="photo">
    <img src="..." alt="...">
    <p class="photo-caption"></p>
</div>

<!-- good -->
<figure class="photo">
    <img src="..." alt="...">
    <figcaption class="photo-caption"></figcaption>
</figure>
```

## Forms

* Wrap radio and checkbox inputs and their text in `<label>`s. No need for
  for attributes here—the wrapping automatically associates the two.
* Form buttons should always include an explicit type. Use primary buttons
  for the `type="submit"` button and regular buttons for `type="button"`.
* Favor `<button>` over `<input type="submit">` tag.

```html
<!-- not good -->
<input type="submit" class="btn" value="Submit">

<!-- good -->
<button type="submit" class="btn">Submit</button>
```

* The primary form button must come first in the DOM, especially for forms
  with multiple submit buttons.

### Boolean Attributes

* Many attributes don’t require a value to be set, like `disabled`
  or `checked`, so don’t set them.

```html
<input type="text" disabled>

<input type="checkbox" value="1" checked>

<select>
    <option value="1" selected>1</option>
</select>
```

## Tables

* Make use of `<thead>`, `<tfoot>`, `<tbody>`, and `<th>` tags when appropriate.
  (Note: `<tfoot>` goes above `<tbody>` for speed reasons. You want the browser
  to load the footer before a table full of data.)

```html
<table summary="Most awesome data">
    <thead>
        <tr>
            <th scope="col">Table header 1</th>
            <th scope="col">Table header 2</th>
        </tr>
    </thead>
    <tfoot>
        <tr>
            <td>Table footer 1</td>
            <td>Table footer 2</td>
        </tr>
    </tfoot>
    <tbody>
        <tr>
            <td>Table data 1</td>
            <td>Table data 2</td>
        </tr>
    </tbody>
</table>
```

## Comments

* Add TODO’s for placeholder links, images and copy that needs to be updated.

```html
<!-- TODO update link -->
<a href="#">This is a link</a>
```

* Explain anything that may be confusing.
