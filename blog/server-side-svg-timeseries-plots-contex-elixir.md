---
title: Server Side Time Series Plots With Elixir Using Contex
subtitle: Fast, realtime SVG plots for the Phoenix Framework
excerpt: >-
  Contex makes creating server side plots easy with Elixir but the documentation could be better.
date: '2021-01-28'
thumb_image: images/contex_elixir_timeseries.png
image: images/contex_elixir_timeseries.png
layout: post
---

## Background

At IoTReady, we are building a virtual IoT platform to help manufacturers track all of their products - whether these are born smart or not. For instance, a typical workflow we track in the Smart Grid industry looks something like this -

- A manufacturer produces a batch of, say, an insulation product
- The manufacturer ships certain units of this batch to a distributor
- An operator buys some units of this batch
- The operator installs the insulation product and captures notes and media (photos & videos)


At each stage of the flow, our mobile app scans QR codes and captures additional metadata like location and timestamps. Post installation we capture regular weather data for the installation location for analysis and preventive maintenance. 


## Tech Stack

Operational dashboards are a lot more fun (_and useful_) realtime, so we are building ours with [Elixir](https://elixir-lang.org/) and the [Phoenix Framework](https://phoenixframework.org/). These choices deserve their own, longer, blog post. For now, we will focus on our charting library of choice. 

We are big fans of [Plotly](https://plot.ly/) and have used it extensively in the past. However, in this case we wanted to minimise JS code and do things server side as much as we could. 

Step up [Contex](https://github.com/mindok/contex)!

We discovered Contex via a [blog post](https://www.elixirschool.com/blog/server-side-svg-charts-with-contex-and-liveview/) on the excellent Elixir School site. However, that post covers bar charts and the Contex documentation is a _work-in-progress_. Figuring out legends and version-to-documentation mismatches was particularly painful. Hence this post.

> Our dashboard is complementary to, rather than a replacement for, BI tools like Redash or [Kibana](/blog/metal-to-alerts-with-aws-iot-elasticsearch-kibana). We needed something easy to use and customise that includes _some_ visualisation. 


## Quick References

- The [Contex documentation](https://hexdocs.pm/contex/Contex.html) can be a little difficult to wrap your head around
- The [unit tests](https://github.com/mindok/contex/tree/master/test) and [samples](https://github.com/mindok/contex-samples), on the other hand, are excellent resources


## Data Source

We use the [OpenWeatherMap API](https://openweathermap.org/api) to grab basic weather data. Our `Ecto` schema looks a bit like this:

```elixir
schema "weather" do
  field :latitude, :float
  field :longitude, :float
  field :temp, :float
  field :humidity, :float
  field :pressure, :float

  timestamps()
end
```

And the query for getting recent data looks like this:

```elixir
@doc """
Gets weather data points for a given latitude and longitude tuple.

## Examples
    iex> get_weather({latitude, longitude}, limit)
    {:ok, [%Weather{}]}
"""
def get_weather({latitude, longitude}, limit \\ 100) do
  q = from w in Weather,
      where: [latitude: ^latitude, longitude: ^longitude],
      order_by: [desc: :inserted_at],
      limit: ^limit,
      select: %{temp: w.temp, humidity: w.humidity, pressure: w.pressure, inserted_at: w.inserted_at}
  Repo.all(q)
end
```

This query returns a `list` of `maps` that look like this:

```elixir
[
  %{
    humidity: 73.0,
    inserted_at: ~N[2021-01-27 17:00:01],
    pressure: 1016.0,
    temp: 297.27
  },
  %{
    humidity: 73.0,
    inserted_at: ~N[2021-01-27 17:00:01],
    pressure: 1016.0,
    temp: 297.27
  }
]
```

## Setting up Contex

Now that we have our data, time to set up `Contex`. Since it's still early days for Contex, it's best to work with the `master` branch off the Github repo rather than the `0.3.0` release on Hex. For instance, the `0.3.0` release does not include `LinePlot`, which we need. 

```elixir
# mix.exs
defp deps do
  [
    ...,
    {:contex, git: "https://github.com/mindok/contex"},
  ]
end
```

## Plotting the data

It's easiest to illustrate the plotting flow with code:

```elixir
# Get the last 100 data points for {latitude, longitude}
weather_data = get_weather({latitude, longitude}) 


plot_options = %{
  top_margin: 5,
  right_margin: 5,
  bottom_margin: 5,
  left_margin: 5,
  show_x_axis: true,
  show_y_axis: true,
}

# Generate the SVG chart
weather_chart =
  weather_data
  # Flatten the map into a list of lists
  |> Enum.map(fn %{inserted_at: timestamp, temp: temp, humidity: humidity, pressure: pressure} ->
    [timestamp, temp, humidity, pressure]
  end)
  # Assign legend titles using list indices
  |> Dataset.new(["Time", "Temperature", "Humidity", "Pressure"])
  # Specify plot type (LinePlot), SVG dimensions, column mapping, title, label and legend
  |> Plot.new(
    LinePlot,
    600,
    300,
    mapping: %{x_col: "Time", y_cols: ["Temperature", "Humidity", "Pressure"]},
    plot_options: plot_options,
    title: "Weather",
    x_label: "Time",
    legend_setting: :legend_right
  )
  # Generate SVG
  |> Plot.to_svg()

# We are using Phoenix LiveView, so assign the chart to the socket
socket
  |> assign(:weather_chart, weather_chart)
```

After this, all that's left to do is to embed the SVG in the HTML view and this is all it takes:

```elixir
<%= @weather_chart %>
```

We faced some clipping of the legend text but that was easy to fix with this CSS:

```css
.exc-legend {
    font-size: small;
}
```

Here's the SVG in all its glory :-)

<style>
.exc-legend {
    font-size: small;
}
</style>

<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" class="chart" viewBox="0 0 600 300" role="img"><style type="text/css">
  text {fill: black}
  line {stroke: black}
</style>
<text x="280.0" y="20" text-anchor="middle" class="exc-title">Weather</text><text x="280.0" y="280" text-anchor="middle" class="exc-subtitle">Time</text><g transform="translate(70,40)"><g transform="translate(0, 170)" fill="none" font-size="10" text-anchor="middle"><path class="exc-domain" stroke="#000" d="M0.5, 6V0.5H420.5V6"></path><g class="exc-tick" opacity="1" transform="translate(0.5,0)"><line y2="6"></line><text y="9" dy="0.71em" dx="0" text-anchor="middle">27 Jan 09:00</text></g><g class="exc-tick" opacity="1" transform="translate(60.5,0)"><line y2="6"></line><text y="9" dy="0.71em" dx="0" text-anchor="middle">27 Jan 12:00</text></g><g class="exc-tick" opacity="1" transform="translate(120.5,0)"><line y2="6"></line><text y="9" dy="0.71em" dx="0" text-anchor="middle">27 Jan 15:00</text></g><g class="exc-tick" opacity="1" transform="translate(180.5,0)"><line y2="6"></line><text y="9" dy="0.71em" dx="0" text-anchor="middle">27 Jan 18:00</text></g><g class="exc-tick" opacity="1" transform="translate(240.5,0)"><line y2="6"></line><text y="9" dy="0.71em" dx="0" text-anchor="middle">27 Jan 21:00</text></g><g class="exc-tick" opacity="1" transform="translate(300.5,0)"><line y2="6"></line><text y="9" dy="0.71em" dx="0" text-anchor="middle">28 Jan 00:00</text></g><g class="exc-tick" opacity="1" transform="translate(360.5,0)"><line y2="6"></line><text y="9" dy="0.71em" dx="0" text-anchor="middle">28 Jan 03:00</text></g><g class="exc-tick" opacity="1" transform="translate(420.5,0)"><line y2="6"></line><text y="9" dy="0.71em" dx="0" text-anchor="middle">28 Jan 06:00</text></g></g><g fill="none" font-size="10" text-anchor="end"><path class="exc-domain" stroke="#000" d="M-6,170.5H0.5V0.5H-6"></path><g class="exc-tick" opacity="1" transform="translate(0, 170.5)"><line x2="-6"></line><text x="-9" dy="0.32em">0</text></g><g class="exc-tick" opacity="1" transform="translate(0, 155.04545454545453)"><line x2="-6"></line><text x="-9" dy="0.32em">100</text></g><g class="exc-tick" opacity="1" transform="translate(0, 139.5909090909091)"><line x2="-6"></line><text x="-9" dy="0.32em">200</text></g><g class="exc-tick" opacity="1" transform="translate(0, 124.13636363636364)"><line x2="-6"></line><text x="-9" dy="0.32em">300</text></g><g class="exc-tick" opacity="1" transform="translate(0, 108.68181818181819)"><line x2="-6"></line><text x="-9" dy="0.32em">400</text></g><g class="exc-tick" opacity="1" transform="translate(0, 93.22727272727273)"><line x2="-6"></line><text x="-9" dy="0.32em">500</text></g><g class="exc-tick" opacity="1" transform="translate(0, 77.77272727272728)"><line x2="-6"></line><text x="-9" dy="0.32em">600</text></g><g class="exc-tick" opacity="1" transform="translate(0, 62.31818181818181)"><line x2="-6"></line><text x="-9" dy="0.32em">700</text></g><g class="exc-tick" opacity="1" transform="translate(0, 46.86363636363636)"><line x2="-6"></line><text x="-9" dy="0.32em">800</text></g><g class="exc-tick" opacity="1" transform="translate(0, 31.409090909090907)"><line x2="-6"></line><text x="-9" dy="0.32em">900</text></g><g class="exc-tick" opacity="1" transform="translate(0, 15.954545454545467)"><line x2="-6"></line><text x="-9" dy="0.32em">1000</text></g><g class="exc-tick" opacity="1" transform="translate(0, 0.5)"><line x2="-6"></line><text x="-9" dy="0.32em">1100</text></g></g><g><path d="M  0.0 126.64227272727273 C  0.0 126.64227272727273 -2.333333333333333 126.65020606060605 0.0 126.64227272727273 C  2.333333333333333 126.6343393939394 15.333333333333334 126.58959848484848 20.0 126.57427272727273 C  24.666666666666664 126.55894696969698 35.333333333333336 126.53038181818182 40.0 126.5109090909091 C  44.666666666666664 126.49143636363637 55.333333333333336 126.41944393939394 60.0 126.40736363636364 C  64.66666666666667 126.39528333333334 75.33333333333333 126.41926363636364 80.0 126.40736363636364 C  84.66666666666667 126.39546363636364 95.33333333333333 126.31726363636363 100.0 126.30536363636364 C  104.66666666666667 126.29346363636364 115.33268518518518 126.30536363636364 120.0 126.30536363636364 C  124.66731481481482 126.30536363636364 137.67157407407407 126.30536363636364 140.00555555555556 126.30536363636364 C  142.33953703703705 126.30536363636364 137.67222222222222 126.30211818181819 140.00555555555556 126.30536363636364 C  142.3388888888889 126.30860909090909 157.67222222222222 126.32993636363638 160.00555555555556 126.33318181818183 C  162.3388888888889 126.33642727272728 136.67222222222222 126.32741212121213 160.00555555555556 126.33318181818183 C  183.3388888888889 126.33895151515152 336.6722222222222 126.37686666666666 360.00555555555553 126.38263636363635 C  383.33888888888885 126.38840606060604 360.00555555555553 126.38263636363635 360.00555555555553 126.38263636363635" stroke-linejoin="round" stroke-width="2" stroke="#1f77b4" fill="transparent"></path><path d="M  0.0 154.54545454545453 C  0.0 154.54545454545453 -2.333333333333333 154.54545454545453 0.0 154.54545454545453 C  2.333333333333333 154.54545454545453 15.333333333333334 154.54545454545453 20.0 154.54545454545453 C  24.666666666666664 154.54545454545453 35.333333333333336 154.4192424242424 40.0 154.54545454545453 C  44.666666666666664 154.67166666666665 55.333333333333336 155.5010606060606 60.0 155.62727272727273 C  64.66666666666667 155.75348484848485 75.33333333333333 155.51909090909092 80.0 155.62727272727273 C  84.66666666666667 155.73545454545453 95.33333333333333 156.44636363636366 100.0 156.55454545454546 C  104.66666666666667 156.66272727272727 115.33268518518518 156.66272727272727 120.0 156.55454545454546 C  124.66731481481482 156.44636363636366 137.67157407407407 155.73545454545453 140.00555555555556 155.62727272727273 C  142.33953703703705 155.51909090909092 137.67222222222222 155.62727272727273 140.00555555555556 155.62727272727273 C  142.3388888888889 155.62727272727273 157.67222222222222 155.62727272727273 160.00555555555556 155.62727272727273 C  162.3388888888889 155.62727272727273 136.67222222222222 155.75348484848485 160.00555555555556 155.62727272727273 C  183.3388888888889 155.5010606060606 336.6722222222222 154.67166666666665 360.00555555555553 154.54545454545453 C  383.33888888888885 154.4192424242424 360.00555555555553 154.54545454545453 360.00555555555553 154.54545454545453" stroke-linejoin="round" stroke-width="2" stroke="#ff7f0e" fill="transparent"></path><path d="M  0.0 13.75454545454545 C  0.0 13.75454545454545 -2.333333333333333 13.75454545454545 0.0 13.75454545454545 C  2.333333333333333 13.75454545454545 15.333333333333334 13.772575757575753 20.0 13.75454545454545 C  24.666666666666664 13.736515151515148 35.333333333333336 13.618030303030297 40.0 13.599999999999994 C  44.666666666666664 13.581969696969692 55.333333333333336 13.581969696969692 60.0 13.599999999999994 C  64.66666666666667 13.618030303030297 75.33333333333333 13.736515151515148 80.0 13.75454545454545 C  84.66666666666667 13.772575757575753 95.33333333333333 13.75454545454545 100.0 13.75454545454545 C  104.66666666666667 13.75454545454545 115.33268518518518 13.75454545454545 120.0 13.75454545454545 C  124.66731481481482 13.75454545454545 137.67157407407407 13.75454545454545 140.00555555555556 13.75454545454545 C  142.33953703703705 13.75454545454545 137.67222222222222 13.736515151515148 140.00555555555556 13.75454545454545 C  142.3388888888889 13.772575757575753 157.67222222222222 13.891060606060604 160.00555555555556 13.909090909090907 C  162.3388888888889 13.92712121212121 136.67222222222222 13.76484848484848 160.00555555555556 13.909090909090907 C  183.3388888888889 14.053333333333333 336.6722222222222 15.001212121212129 360.00555555555553 15.145454545454555 C  383.33888888888885 15.289696969696982 360.00555555555553 15.145454545454555 360.00555555555553 15.145454545454555" stroke-linejoin="round" stroke-width="2" stroke="#2ca02c" fill="transparent"></path></g></g><g transform="translate(500, 50)"><g class="exc-legend"><rect x="0" y="0" width="18" height="18" style="fill:#1f77b4;"></rect><text x="23" y="9" dominant-baseline="central" text-anchor="start">Temperature</text><rect x="0" y="21" width="18" height="18" style="fill:#ff7f0e;"></rect><text x="23" y="30" dominant-baseline="central" text-anchor="start">Humidity</text><rect x="0" y="42" width="18" height="18" style="fill:#2ca02c;"></rect><text x="23" y="51" dominant-baseline="central" text-anchor="start">Pressure</text></g></g></svg>


### Where do we go from here

We think Contex is a pretty good fit for our needs. It's _definitely_ rough around the edges and there are plenty of use cases we are yet to explore like:

- interactivity (not a huge deal for us) and 
- realtime updates (big deal). 
 
Realtime updates are easy to implement but we want verify impact on server performance but then again, this is not an immediate concern.

## Ideas, questions or corrections?

Write to us at [hello@iotready.co](mailto:hello@iotready.co)
