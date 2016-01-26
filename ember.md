# HTML Style Guide

## Table of Contents

1. [General](#general)
1. [Module's Structure](#modules-structure)
1. [Pod structure](#pod-structure)
1. [Controllers](#controllers)
1. [Templates](#templates)
1. [Models](#models)

## General

* Create local version of Ember.* and DS.*

Future versions of Ember will be released as ES2015 modules, so we'll be able to import `Ember.computed` directly as computed. This includes `computed.alias` or `computed.bool`, should be set to `alias` and `bool`, respectively. Do not use extend prototype syntax

```javascript
// bad
export default DS.Model.extend({
  firstName: DS.attr('string'),
  lastName: DS.attr('string'),

  fullName: Ember.computed('firstName', 'lastName', function () {
    // code
  }),

  fullNameBad: function() {
    // Code
  }.property('firstName', 'lastName')
});

// good
import Ember from 'ember';
import DS from 'ember-data';

const {
  Model,
  attr
} = DS;
const {
  computed,
  computed: { alias }
} = Ember;

export default Model.extend({
  firstName: attr('string'),
  lastName:  attr('string'),

  surname:   alias('lastName')

  fullName:  computed('firstName', 'lastName', function () {
    // code
  })
});
```

* Add a single space before and after the handlebars expression

```htmlbars
{{!-- bad --}}
{{user.name}}
{{format-date-helper date}}
{{component-without-block user=user}}

{{!-- good --}}
{{ user.name }}
{{ format-date-helper date }}
{{ component-without-block user=user }}
```

* Do not add spaces for components that take block

```htmlbars
{{!-- good --}}
{{#component-with-block}}
  {{!-- content --}}
{{/component-with-block}}

{{#if isVisible}}
  {{!-- is visible --}}
{{else}}
  {{!-- is invisible --}}
{{/if}}
```

* Use double quotes for attributes even if they are bind to a property, as this way
  the code will look more consistent.

```htmlbars
{{!-- bad --}}
<img src={{ user.image }} alt="User image">

{{!-- good --}}
<img src="{{ user.image }}" alt="User image">
```

* Avoid overwriting init Unless you want to change an object's `init` function,
  perform actions by hooking into the object's `init` hook via `on`.
  This prevents you from forgetting to call `_super`.
  [Here is why you shouldn't override init](http://reefpoints.dockyard.com/2014/04/28/dont-override-init.html).

## Module's Structure

* Define the dependency injections first

* Define you object's default values after the dependencies.

* Define single line computed properties (`surname: alias('lastName')`) after the default values

* Define multiline computed properties after the single line ones.

* Define the actions hash last

```javascript
export default Component.extend({
  // Dependencies
  session: service('session')

  // Defaults
  tagName: 'section',

  // Single line CP
  surname: alias('user.lastName')

  // Multiline CP
  fullName: computed('user.firstName', 'user.lastName', function () {
    return `${this.get('user.firstname')} ${this.get('user.lastName')}`;
  }),

  // Actions hash
  actions: {
    update() {
      // Code
    }
  }
});
```

## Pod Structure

* Use pods structure.

* Store local components within their pod, global components in the `components` structure.

```
app
  application/
    template.hbs
    route.js

  blog/
    index/
      blog-listing/ - component only used on the index template
        template.hbs
      route.js
      template.hbs
    comment-details/ - used within blog templates
      component.js
      template.hbs
    route.js

  components/
    tag-listing/ - used throughout the app
      template.hbs

  post/
    adapter.js
    model.js
    serializer.js
```

## Controllers

* Define query params first for consistency and ease of discover. These should be listed
  before the default values, but after the dependency injections.

* Do not use `ObjectController` and `ArrayControllers` as they are deprecated and are
  removed from Ember 2.0

## Templates

* Do not use partials. Always use components as they provide a consistent scope and improve
  reusability.

* The content in a `{{#each}}` block should be a component if the content is more than one line. This will allow you to test the contents in isolation via unit tests, as your loop will likely contain more complex logic in this case.

```htmlbars
{{!-- bad --}}
{{#each posts as |post|}}
  <article>
    <img src="{{post.image}}">
    <h1>{{post.title}}</h2>
    <p>{{post.summar}}</p>
  </article>
{{/each}}

{{!-- good --}}
{{#each posts as |post|}}
  {{post-summary post=post}}
{{/each}}
```

## Models

* Be explicit the attribute types to ensure the right data transform is used.

```javascript
// bad
export default Model.extend({
  firstName: attr(),
  age: attr(),
  isAdmin: attr()
});

// good
export default Model.extend({
  firstName: attr('string'),
  age:       attr('number'),
  isAdmin:   attr('boolean'),
})
```

* Do not flood the models with presentational logic. If a computed property is used
  in a particular place, consider using a component.

* Group model's attributes, relations, then computed properties.
