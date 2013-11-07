Studio = require('./studio')

Enumerable =
  any: (predicate) ->
    result = false
    @each (item) =>
      result = predicate(item)
      return if result
    result

  includes: (other_item) ->
    result = false
    @each (item) =>
      result ||= (item == other_item || item.equals(other_item))
    result

  find_all: (predicate) ->
    results = []
    @each (item) =>
      results.push(item) if predicate(item)
    results

moduleKeywords = ['extended', 'included']

class Module
  @include: (object) ->
    for key, value of object when key not in moduleKeywords
      @::[key] = value

    object.included?.apply(@)
    this

module.exports = class MovieLibrary extends Module
  @include Enumerable

  constructor: ->
    @movies = []

  add: (movie) ->
    @movies.push(movie) unless @includes(movie)

  count: ->
    @movies.length

  each: (visitor) ->
    for movie in @movies
      visitor(movie)

  find_all_movies_by_pixar: ->
    @find_all (movie) =>
      movie.studio == Studio.Pixar

  find_movies_by_pixar_or_disney: ->
    @find_all (movie) =>
      movie.studio == Studio.Pixar || movie.studio == Studio.Disney

  find_movies_not_published_by_pixar: ->
    @find_all (movie) =>
      movie.studio != Studio.Pixar

  find_movies_released_after_2004: ->
    @find_all (movie) =>
      movie.year_published > 2004

  find_movies_released_between_1982_and_2003: ->
    @find_all (movie) =>
      movie.year_published > 1982 && movie.year_published < 2003

