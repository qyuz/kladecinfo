//remove episodes from list
var id = $.jStorage.index()[0]
var episodes = $.jStorage.get(id)
episodes.splice(0,5)
$.jStorage.set(id, episodes)
updateWatchedEpisodesCount()