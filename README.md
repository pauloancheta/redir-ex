[![Build Status](https://travis-ci.org/pauloancheta/redir-ex.svg?branch=master)](https://travis-ci.org/pauloancheta/redir-ex)

# Redir.ex

Get the real body of a website by following all the redirects and output the sexy body

### Install the dependencies

```
$ mix deps.get
```

### Usage

```elixir
> Redir.start
> Redir.final_url("http://google.com")
```
