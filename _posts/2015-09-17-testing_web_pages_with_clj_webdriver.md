---
layout: post
title: Testing Clojurescript web apps with clj-webdriver
---

This post describes how to get up and running with Selenium and automating browser testing in Clojure with [clj-webdriver](https://github.com/semperos/clj-webdriver).  I'm assuming leiningen, but if you use Boot or Gradle or something I think idea is pretty much the same.

I've been working on a side project for work because I think the way we do some of our data setup and testing could be better, and I really want to do something substantial with Clojure and Clojurescript.  This project is a set of tools that will insert random data into an Oracle database based on the values in the Oracle data dictionary.  You can also specify your own values, which you probably will want to do at some point (just using randomly generated data is pointless as far as I can tell).  The cool part (I think) is that you can specify what kind of random data you want using a set of [edn](http://github.com/edn-format/edn) tagged values that I made handlers for, but that's probably a post for another day.

I had wanted to try out  [Selenium](http://www.seleniumhq.org) ever since my last project at work, but due to time constraints I wasn't able to get past adding it to my NuGet dependency list.  I wrote a front end for my side-project in [Reagent](http://reagent-project.github.io), so I figured I'd play with it on this, instead.


## Setup

[Daniel Gregoire](https://github.com/semperos?tab=repositories) wrote an API for Selenium-Webdriver aptly named [clj-webdriver](https://github.com/semperos/clj-webdriver).  I enjoy using it, particularly the nice queries you can do to retrieve elements.  I haven't used Selenium in any other language so I can't speak to this capability in other languages.  To install the library, add it to your dependency list in project.clj:

```
[clj-webdriver "0.6.1"]
```

Personally, I had to downgrade firefox from 36 to 35 to get it to play nice with the version of `selenium-server.jar` that `clj-webdriver requires`.  I also had to clone clj-webdriver master and do a `lein install` because I encountered something similar to [this issue](https://github.com/semperos/clj-webdriver/issues/137) on my first couple of tries.



We start our app:
{% highlight shell %}
lein ring server-headless
{% endhighlight %}

And then start up a repl to play around with webdriver commands:
{% highlight shell %}
lein repl
{% endhighlight %}

{% highlight clojure %}
(use 'clj-webdriver.taxi)
=> nil
(set-driver! {:browser :firefox})
(value "#db-dropdown") ;; some element on your page
=> "\n"
{% endhighlight %}

Taxi is the high level API for clj-webdriver.  You can find the docs [here](https://github.com/semperos/clj-webdriver/wiki/Taxi-API-Documentation)

{% highlight clojure %}
attribute
{% endhighlight %}

takes a query for a particular element, like "select" or "ul"and an attribute and returns the first HTML element that meets the query.  For example

```
(attribute "select" :id)
=>"db-dropdown"
```

```
(attribute "select" :style
=> "width: 200px"
```

```
(attribute "div" :class)
=> container
```

## Changing stuff's value

{% highlight clojure %}
(select-option "db-dropdown" {:value "database1"}
=>
{% endhighlight %}

## Refresh the page

{% highlight clojure %}
(refresh)
=> #clj_webdriver.driver.Driver{:webdriver #<Title: , URL: http://localhost:3000/,
Browser: firefox, Version: 35.0, JS Enabled: true, Native Events Enabled: false,
 Object: FirefoxDriver: firefox on WINDOWS (dbb875ca-3f66-4208-920b-054c1fd360cb
)>, :capabilities nil, :cache-spec {:cache nil}, :actions #<Actions org.openqa.s
elenium.interactions.Actions@47b259ab>}
{% endhighlight %}

## Putting it into a file


{% highlight clojure %}
(def url "http://localhost:3000")


(defn change-database
  [database]
  (select-option "#db-dropdown" database))


(defn start-browser
  (set-driver! {:browser :firefox}) url))
{% endhighlight %}



I couldn't test with figwheel because it was broken at the time.  I also noticed figwheel making me specify a runtime profile at times.

I couldn't get it to work on Firefox 36, I had to download Firefox 35.  I also had to clone clj-webdriver and do `lein install` which adds it to my local maven repository.
