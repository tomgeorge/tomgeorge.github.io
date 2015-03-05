---
layout: post
title: Testing Clojurescript web apps with clj-webdriver
---

I've been working on a side project for work to learn about Clojure and Clojurescript.  

`lein ring server-headless`

`lein repl`

{% highlight clojure %}
(use 'clj-webdriver.taxi)
=> nil
(set-driver! {:browser :firefox})
(value "#db-dropdown")
=> "\n"
{% endhighlight %}
```
attribute 
```
takes a query for a particular attribute, like "select" or "ul"and an attribute and returns the first HTML element that meets the query.  For example
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

##Changing stuff's value

```
(select-option "db-dropdown" {:value "database1"}
=>
```
##Refresh the page
```
(refresh)
=> #clj_webdriver.driver.Driver{:webdriver #<Title: , URL: http://localhost:3000/,
Browser: firefox, Version: 35.0, JS Enabled: true, Native Events Enabled: false,
 Object: FirefoxDriver: firefox on WINDOWS (dbb875ca-3f66-4208-920b-054c1fd360cb
)>, :capabilities nil, :cache-spec {:cache nil}, :actions #<Actions org.openqa.s
elenium.interactions.Actions@47b259ab>}
```

##Putting it into a file

```
(def url "http://localhost:3000")

  
(defn change-database
  [database]
  (select-option "#db-dropdown" database))
```
{% highlight clojure %}
(defn start-browser
  (set-driver! {:browser :firefox}) url))
{% endhighlight %}



I couldn't test with figwheel because it was broken at the time.  I also noticed figwheel making me specify a profile at times.

I couldn't get it to work on Firefox 36, I had to download Firefox 35.  I also had to clone clj-webdriver and do `lein install` which adds it to my local maven repository.  
