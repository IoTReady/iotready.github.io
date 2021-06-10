---
title: Progressive Web Apps & Elixir Phoenix
excerpt: >-
  Elixir Phoenix is one of the best choices out there for building server side web applications. So, how does one build progresive web apps on it?
date: '2021-06-10'
thumb_image: images/pwa.png
image: images/pwa.png
layout: post
---

Progress Web Apps are great for the right use cases. They can replace mobile apps and provide great offline user experience at a fraction of the development and maintenance cost.

So, how do they fit into the IoT world? We will explore this theme in a series of blogs. First up in the series, a tutorial on how to use Phoenix to host one for you.

### MVPWA, aka Minimum Viable Progress Web App

If you, like me, thought that it takes one of those nifty frontend frameworks to build a PWA, here's a quick tour of the sausage factory. 

The absolute barebones PWA only needs 3 files:

- `serviceworker.js` - tells the browser to cache the app offline
- `manifest.json` - gives the browser metadata on the app
- `index.html` - HTML, CSS and any custom JS you need. Pulls in `manifest.json` and `serviceworker.js`.

This [great tutorial](https://www.geeksforgeeks.org/making-a-simple-pwa-under-5-minutes/) will help you get started with exploring these files and bulding your first PWA.

### Hosting a PWA with Phoenix

You wouldn't be completely wrong in believing that Elixir Phoenix and PWAs occupy opposite ends of the web development spectrum. They sort of do, especially with LiveView making JS code largely redundant.

However, it's very easy to convert some routes in your Phoenix app to a PWA. We did this recently for our [Websockets client](https://bodh.iotready.co/websockets) and what follows is a quick summary.

#### App & Routing

Our app consists of a simple `HTML` page rendered by Phoenix - note that this is not a `LiveView`. You can check out the code for the app above by viewing source. Because, we are rendering with Phoenix, the source is quite readable and not a mess of `div`s. 

To make serving such static pages easier, we use a single `StaticPagesController` module. For every new page, we add in a new method with an accompanying new route in `router.ex`. 

Here's the method serving `/websockets`:

```elixir
def websockets(conn, _) do
    meta_attrs = [
      %{name: "og:title", content: "Websockets PWA"},
      %{name: "og:image", content: "/images/websockets_512.png"},
      %{name: "og:description", content: "Bodh Websockets Client PWA"},
      %{name: "description", content: "Bodh Websockets Client PWA"}
    ]

    conn =
      conn
      |> assign(:meta_attrs, meta_attrs)
      |> assign(:page_title, "Bodh Websockets Client")
      |> assign(:manifest, "manifests/websockets.json")

    render(conn, "websockets.html")
end
```

#### Adding the Manifest and SEO Tags

You may have noticed `assign(:manifest, "manifests/websockets.json")` above. This is the line which makes adding the manifest possible. And the `meta_attrs` improve SEO while allows social media sites render a nice card view of your app when shared.

The `manifest` needs to be added to the head of the served HTML. Phoenix does not have built-ins to be able to do this. Instead, we add a new plug in `router.ex` and call in the `browser` pipeline.

```elixir
def default_assigns(conn, _opts) do
    conn
    |> assign(:meta_attrs, [])
    |> assign(:manifest, nil)
end

pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    ...
    plug :default_assigns
end
```

Then, inside the `root.html.ex` layout, we use these assigns in the HTML `head`.

```elixir
<head>
...
<%= if @meta_attrs, do: meta_tags(@meta_attrs) %>
<%= if @manifest do %>
  <link rel="manifest" href="<%= @manifest %>">
<% end %>
</head>
```

`meta_tags/1` is defined in `views/layout_view.ex`:

```elixir
defmodule BodhWeb.LayoutView do
  use BodhWeb, :view

  def meta_tags(attrs_list) do
    Enum.map(attrs_list, &meta_tag/1)
  end

  def meta_tag(attrs) do
    tag(:meta, Enum.into(attrs, []))
  end
end
```

The manifest file itself can be called whatever you want. We call it `websockets.json` and store it in `assets/static/manifests/`. In order to ensure this is copied over to the generated assets inside `priv`, we need to modify the static `plug` inside `endpoint.ex`:

```elixir
plug Plug.Static,
    at: "/",
    from: :bodh,
    gzip: false,
    only: ~w(css fonts images js favicon.ico manifests websockets.js robots.txt)
```

Notice `manifests` in the assets list. We also add some icons to `assets/static/images` for use in the manifest. Our final manifest file looks like this:

```json
{
	"name": "Bodh Websockets Client",
	"short_name": "Bodh Websockets",
	"start_url": "/websockets",
	"display": "standalone",
	"background_color": "#5900b3",
	"theme_color": "black",
	"scope": "/websockets",
	"description": "Bodh Websockets Client PWA",
	"icons": [{
			"src": "/images/websockets_192.png",
			"sizes": "192x192",
			"type": "image/png"
		},
		{
			"src": "/images/websockets_512.png",
			"sizes": "512x512",
			"type": "image/png"
		}
	]
}
```

#### Integrating the Service Worker

This was possibly the trickiest of the entire flow to figure out. Turns out that the app route (`/websockets`), `manifest.json` and the service worker, `websockets.js` are linked together by a `scope` parameter. It took me multiple readings of this [MDN article](https://developer.mozilla.org/en-US/docs/Web/Manifest/scope), this [Dev.to article](https://dev.to/njromano/how-to-scope-your-pwa-service-workers-1n6m) to figure this out. 

To summarise, the `manifest` and the `serviceworker` should use `route` as the `scope` and `start_url`. Our `serviceworker` (stored in `websockets.js`) looks like this:


```js
var staticCacheName = "pwa";

self.addEventListener("install", function (e) {
e.waitUntil(
	caches.open(staticCacheName).then(function (cache) {
	return cache.addAll(["/websockets"]);
	})
);
});

self.addEventListener("fetch", function (event) {
console.log(event.request.url);

event.respondWith(
	caches.match(event.request).then(function (response) {
	return response || fetch(event.request);
	})
);
});
```

Finally, it's important that the path to the `serviceworker.js` file is a parent of the route being served. Since we will be serving multiple PWAs on this server, we decided to store all our service workers (including `websockets.js`) inside `assets/static/`.

There's apparently a header you can set a `Service-Worker-Allowed: "/"` as described in this [StackOverflow response](https://stackoverflow.com/a/48068714/6415409). However, I couldn't figure out a way to set it on the serviceworker. 


### Summary

That may look like a lot but it's really not.

- Write your app the way you normally would any other HTML page. You could even use VueJS or ReactJS etc - as long as you point the controller method to the generated `index.html`. 
- Add a plug to include the `manifest.json` and, optionally, some SEO meta tags. Assign these in the controller method and modify the root layout so they are added to the HTML.
- Add `manifest.json` and `serviceworker.js` to `assets/static`. 
- Include the `serviceworker.js` via a script tag in the html file. 
- Profit!


Feel free to use and copy the source code from our [Websockets PWA](https://bodh.iotready.co/websockets). This series will next look at how PWAs and Websockets can change how we think about IoT apps.

Stay safe and have a good day!

---

For further queries, please write to us at hello@iotready.co. For more of our open-source projects, visit [https://iotready.co/open-source/](https://iotready.co/open-source/)
