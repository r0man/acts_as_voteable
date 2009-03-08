Acts As Voteable
================

This plugin allows voting on models. It's a fork from the original
plugin developed by Juixe Software to work with newer versions of
Rails. The API has changed slightly. See the credits section for a
link to the original code.

Installation
------------

Install the plugin:

        ./script/plugin install git://github.com/r0man/acts_as_voteable.git

Usage
-----

Create a migration:

       ./script/generate acts_as_voteable

Make your model voteable:

      class Article < ActiveRecord::Base
        acts_as_voteable
      end

      article = Article.create(:text => "Lorem ipsum dolor sit amet.")
      alice, bob = User.create(:name => "alice"), User.create(:name => "bob")

      article.vote(true, alice)
      article.number_of_votes_for # => 1

      article.vote(false, bob)
      article.number_of_votes_against # => 1

Look at the tests to see more examples...

Credits
-------

Originally written by Juixe Software.

- <http://www.juixe.com/techknow/index.php/2006/06/24/acts-as-voteable-rails-plugin>

---

Copyright (c) 2009 Roman Scherer, released under the MIT license
