Note about master branch
=======================
I’ve decided to restructure Hallon, but I’ll do it as a way of rebuilding it. This is the first major rewrite since release, and a much needed one. It’ll be easier for both me and external contributors to improve on Hallon, and that will hopefully pave the way for a 1.0.0 release.

This branch will be the main development branch from now and on. It is to be considered *unstable* and *experimental*. I will do shit in this branch that will make your bones shiver.

The previous `master` branch can be found in the [obsolete](https://github.com/Burgestrand/Hallon/tree/obsolete); it is *old and obsolete* and should not be used unless you absolutely need the API **NOW**.

---

What is Hallon?
===============
Hallon provides [Ruby][] bindings for [libspotify][], the official Spotify C API. This allows you to use an awesome language to interact with an awesome service.

Hallon would not have been possible if not for these people:

- Per Reimers, cracking synchronization bugs with me in the deep night (4 AM) and correcting me when I didn’t know better
- [Spotify](http://www.spotify.com/), providing a service worth attention (and my money!)
- [Linus Oleander](https://github.com/oleander), giving me a reason to look for ways of doing what Hallon does
- [Jesper Särnesjö][], creator of [Greenstripes][] which spawned the idea of Hallon

This is what the API looks like (fully working example, I aim to remove the mutex & condition variable ASAP):

    $: << File.expand_path('../../lib', __FILE__)
    require 'hallon'
    require 'thread'
    require_relative 'support/config'

    mutex  = Mutex.new
    signal = ConditionVariable.new

    session = Hallon::Session.instance IO.read(ENV['APPKEY']) do
      on(:logged_in) do |error|
        mutex.synchronize { signal.signal }
      end
    end

    mutex.synchronize do
      session.login ENV['USERNAME'], ENV['PASSWORD']
      signal.wait(mutex)
    end

    puts "Logged in: #{session.logged_in?}" # => Logged in: true


This is awesome! I want to help!
--------------------------------
Sweet! You contribute in more than one way!

### Write code!
[Fork](http://help.github.com/forking/) Hallon, [write tests for everything](http://relishapp.com/rspec) you do (so I don’t break your stuff during my own development) and send a pull request. If you modify existing files, please adhere to the coding standard surrounding your code!

### [Send me feedback and requests](http://github.com/Burgestrand/Hallon/issues)
Really, I ❤ feedback! Suggestions on how to improve the API, tell me what is delicious about Hallon, tell me what is yucky about Hallon… anything! All feedback is useful in one way or another.

You have any questions?
-----------------------
If you need to discuss issues or feature requests you can use [Hallons issue tracker](http://github.com/Burgestrand/Hallon/issues). For *anything* else you have to say or ask I can also be reached via [email (found on GitHub profile)](http://github.com/Burgestrand) or [@burgestrand on twitter](http://twitter.com/Burgestrand).

In fact, you can contact me via email or twitter even if it’s about features or issues. I’ll probably put them in the issue tracker myself after the discussion ;)

What’s the catch?
-----------------
There are several!

### Hallon is unstable
This is *the only* project I’ve ever used C for. With that said, Hallon should be considered extremely experimental.

### Hallon only supports one session per process
You can only keep one session with Spotify alive at a time in the same process, due to a limitation of `libspotify`.

### Hallon only supports Ruby 1.9 on YARV
If it happens to work on any other platform or version, consider it black magic.

### Hallon is licensed under GNU AGPL
Hallon is licensed under the [GNU AGPL](http://www.gnu.org/licenses/agpl-3.0.html), which is a very special license:
> If you are releasing your program under the GNU AGPL, and it can interact with users over a network, the program should offer its source to those users in some way. For example, if your program is a web application, its interface could display a “Source” link that leads users to an archive of the code. The GNU AGPL is flexible enough that you can choose a method that's suitable for your specific program—see section 13 for details.

The license is likely to change to the X11 license sometime under 2011. If the AGPL license makes trouble for you, contact me and I’ll most likely give you an exception. :)

[Ruby]: http://www.ruby-lang.org/en/
[libspotify]: http://developer.spotify.com/en/libspotify/overview/
[Greenstripes]: http://github.com/sarnesjo/greenstripes
[Jesper Särnesjö]: http://jesper.sarnesjo.org/