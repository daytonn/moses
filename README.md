Moses
=====

Moses is a simple option/command parser for building command line applications in Ruby.

Getting Started
---------------

Installation with ruby-gems:

    gem install moses

Installation with bundler:

    gem 'moses', '0.1.0'

Creating a Moses application
----------------------------

Moses is a module that you can include into any Ruby class to provide all the plumbing you need to write command line applications. Create the following directory structure for your application

- bin
  - myapp
- lib
  - myapp.rb
- VERSION
- HELP.md (or just HELP)

Create a class for your applications functionality:

```rb
  class MyApp
    include Moses
    commands :foo, :bar

    def foo
      # do stuff
    end

    def bar
      # do stuff
    end
  end
```

Then all you need in your executable file is the following:

```rb
  #!/usr/bin/env ruby
  $: << File.expand_path(File.join(File.dirname(__FILE__), "../lib"))
  require 'myapp'
  MyApp.new.run
```

That's all you need to create a CLI app. You can now call your application like so:

    myapp foo
    myapp bar

By default, Moses will read the contents of the HELP.md (or HELP) file in the root of your project. This will be used to display your application instructions when passed the flags `-h` and `--help`

    myapp -h
    myapp --help
 
 Similarly, Moses will use the VERSION file with the `-v` and `--version` flags.
 
     myapp -v
     myapp --version