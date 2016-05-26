# HTML Style Guide

## Table of Contents

1. [General](#general)
1. [Module's Structure](#modules-structure)
1. [Pod structure](#pod-structure)
1. [Controllers](#controllers)
1. [Templates](#templates)
1. [Models](#models)

## General

* For Ember Data, we should import `ember-data` modules. For Ember, use destructuring to create local versions

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
import Model from 'ember-data/model';
import attr from 'ember-data/attr';
import { belongsTo, hasMany } from 'ember-data/relationships';

const {
  computed,
  computed: { alias }
} = Ember;

export default Model.extend({
  firstName: attr('string'),
  lastName:  attr('string'),

  mother:    belongsTo('person'),
  pets:      hasMany('animal'),

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

## Override init

Rather than using the object's `init` hook via `on`, override `init` and call `_super` with `...arguments`. This allows you to control execution order.

```javascript
export default Component.extend({
  init() {
    this._super(...arguments);

    this.doA();
    this.doB();
  }
});
```

## Module's Structure

* Define the dependency injections first

* Define you object's default values after the dependencies.

* Define single line computed properties (`surname: alias('lastName')`) after the default values

* Define multiline computed properties after the single line ones.

* Define the actions hash

* Define private methods last and use `_` infront of the names

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
    return this._concat(this.get('user.firstname'), this.get('user.lastName'));
  }),

  // Actions hash
  actions: {
    update() {
      // Code
    }
  },

  // Private methods
  _concat(...segments) {
    return Ember.A(segements).compact().join(' ');
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

* Alias your model whenever you can as it is more maintainable, and will fall in line with future routable components.

```javascript
export default Controller.extend({
  user: alias('model')
});
```

## Templates

* Do not use partials. Always use components as they provide a consistent scope and improve reusability.

* The content in a `{{#each}}` block should be a component if the content is more than one line. This will allow you to test the contents in isolation via unit tests, as your loop will likely contain more complex logic in this case.

```htmlbars
{{!-- bad --}}
{{#each posts as |post|}}
  <article>
    <img src="{{ post.image }}">
    <h1>{{ post.title }}</h2>
    <p>{{ post.summar }}</p>
  </article>
{{/each}}

{{!-- good --}}
{{#each posts as |post|}}
  {{ post-summary post=post }}
{{/each}}
```

* Don't yield `this`. Yield only what is needed and use the hash helper where appropriate.

```htmlbars
{{!-- bad --}}
{{ yield this }}

{{!-- good --}}
{{ yield (hash attribute=name action=(action "save")) }}
```

* Always use the action keyword to pass actions. Although it's not strictly needed to use the action keyword to pass on actions that have already been passed with the action keyword once, it's recommended to always use the action keyword when passing an action to another component. This will prevent some potential bugs that can happen and also make it more clear that you are passing an action.

```htmlbars
{{!-- bad --}}
{{ edit-post post=post ondelete=handlePostDelete }}

{{!-- good --}}
{{ edit-post post=post ondelete=(action handlePostDelete) }}
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

* Group model like:
  - Attributes
  - Relations
  - Computed properties

```javascript
// bad
import Ember from 'ember';
import Model from 'ember-data/model';
import attr from 'ember-data/attr';
import { hasMany } from 'ember-data/relationships';

const { computed } = Ember;

export default Model.extend({
  children: hasMany('child'),
  firstName: attr('string'),
  lastName: attr('string'),

  fullName: computed('firstName', 'lastName', function() {
    // Code
  })
});

// good
import Ember from 'ember';
import Model from 'ember-data/model';
import attr from 'ember-data/attr';
import { hasMany } from 'ember-data/relationships';

const { computed } = Ember;

export default Model.extend({
  // Attributes
  firstName: attr('string'),
  lastName:  attr('string'),

  // Associations
  children:  hasMany('child'),

  // Computed Properties
  fullName: computed('firstName', 'lastName', function() {
    // Code
  })
});
```

## Testing

* Don't break the describe blocks into multiple lines

```javascript
// bad
import { expect } from 'chai';
import {
  describeComponent,
  it
} from 'ember-mocha';
import hbs from 'htmlbars-inline-precompile';

describeComponent(
  'dummy-select',
  'Integration: DummySelectComponent',
  {
    integration: true
  },
  function() {
    // The tests
  }
);

// good
import { expect } from 'chai';
import { describeComponent, it } from 'ember-mocha';
import hbs from 'htmlbars-inline-precompile';

describeComponent('dummy-select', 'Integration: dummy-select', { integration: true }, function () {
  // The tests
});
```

* Name your tests using the following pattern - `Test type`: `module-name`, while keeping the component names as the are and capitalizing the model names.

```javascript
// bad
describeComponent('dummy-select', 'Integration: DummySelectComponent');
describe('Home page');
describeModel('person', 'Unit | Model | dummy two');

// good
describeComponent('dummy-select', 'Integration: dummy-select');
describe('Acceptance: Home page');
describeModel('person', 'Model: Person');
```
