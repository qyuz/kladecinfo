var USER = "0ead326f-2a60-4072-8c3e-3f3bbb0197ba"
var API_KEY = "rete8fUcPwwXrC%2BMJyfbWugxpwtQL3wfxBk6H4%2BE4f5LH6wpbPSDhEvA8LVFJemsSHbc3wJipF3akDstLykygQ%3D%3D"

function YOUTUBE_EMBED(url) {
    return "https://www.youtube.com/embed/" + url.match(/.*v=(.{11}).*/)[1]
}
function BEFORE_HASH(url) {
    return SAFE_MATCH(url, /([^#]+).*/, 1)
}
function SAFE_MATCH(text, match, group) {
    var matched = text.match(match);
    return matched && matched.length > group ? matched[group] : text
}

var showTemplates = {
    youtubeChannel: function (id, url, match, group, reverse) {
        return {
            id: id, guid: "99267a7a-7887-4df9-870f-4e6cd255f249",
            url: SAFE_MATCH(url, /((.*)\/(user|channel)\/[^\/]+).*/, 1) + '/videos?flow=list',
            reverse: reverse,
            format: function (importObj) {
                return {
                    url: YOUTUBE_EMBED(importObj.url),
                    name: SAFE_MATCH(importObj.name, match, group)
                }
            }
        }
    },
    youtubePlaylist: function(id, url, match, group, reverse) {
        return {
            id: id, guid: "a69618cb-cd6d-48c0-8159-a12fe1543791",
            url: "https://www.youtube.com/playlist?list=" + SAFE_MATCH(url, /.*list=([\w-]+)/, 1),
            reverse: reverse,
            format: function (importObj) {
                return {
                    url: YOUTUBE_EMBED(importObj.url),
                    name: SAFE_MATCH(importObj.name, match, group)
                }
            }
        }
    },
    caramba: function (id, url) {
        return { id: id, guid: "672508f5-b15f-4398-9759-081fa2612503", url: url }
    },
    seasonvar: function (id, url) {
        return {
            id: id, guid: "2449c4fe-01f3-423d-ab39-9c5dc3092796", url: url, reverse: true,
            format: function (importObj) {
                var count = importObj.all.match(/\d{2}.\d{2}.\d{4} (\d+-)?([\d]+) серия/)[2]
                var range = _.range(count)
                var episodes = range.map(function (episodeNumber) {
                    return {
                        url: BEFORE_HASH(url) + "#rewind=" + episodeNumber + "_seriya",
                        name: (episodeNumber + 1) + " серия",
                        link: true,
                        topNavigation: false
                    }
                })
                return episodes
            }
        }
    }
}

//delete when done start
//var showsConfig = [
//    {
//        template: "youtubeChannel", id: "thisishorosho", episodeMatch: "This is Хорошо - (.*)",
//        episodeMatchGroup: 1,
//        url: "http://www.youtube.com/user/ThisIsHorosho/videos?sort=dd&view=0&flow=list&live_view=500"
//    },
//    {
//        template: "caramba", id: "100500", url: "http://carambatv.ru/humor/100500/", episodeMatchGroup: 1
//    },
//    {
//        template: "seasonvar", id: "urgant", url: "http://seasonvar.ru/serial-8648-Vechernij_Urgant-5-season.html"
//    },
//    {
//        template: "youtubePlaylist", id: "watchdogs", episodeMatch: "Let's Play: Watch_Dogs - Part (.*)",
//        episodeMatchGroup: 1,
//        url: "https://www.youtube.com/playlist?list=PLoGChTicfehx5U727MLQn2uBwEuya7ytV"
//   }
//]
//var jShowsConfig = $.jStorage.get("showsConfig")
//jShowsConfig || $.jStorage.set("showsConfig", showsConfig)
//delete when done end

function episodeWatchedAndCount(id) {
    var episodes = $.jStorage.get(id)
    var watched = episodes ? episodes.reduce(function (count, episode) {
        return isEpisodeWatched(episode.id) ? ++count : count
    }, 0) : 0
    return { watched: watched, count: episodes ? episodes.length : 0 }
}

function isEpisodeWatched(url) {
    return localStorage.getItem(url) == "true" ? true : false;
}

function queryEpisodesImport(show) {
    var defer = new $.Deferred();
    var url = 'https://api.import.io/store/data/' + show.guid + '/_query?_user=' + USER + '&_apikey=' + API_KEY
    var data =  JSON.stringify({
        "input": {
            "webpage/url": show.url
        }
    })
    $.post(url, data, function (importResponse) {
        var importData = importResponse.results;
        importData.length || notify(show, "Couldn't find any videos. Looks like URL or importio Extractor is broken.", "Couldn't find any videos. Looks like URL or importio Extractor is broken.")
        show.format && (importData = importData.map(show.format))
        importData = _.flatten(importData)
        var webixData = importData.map(function (importObj) {
            return _.extend({ id:importObj.url, name:importObj.name }, _.omit(importObj, 'url', 'name'))
        })
        show.reverse && webixData.reverse()
        defer.resolve(show, webixData)
    }).always(function () {
            console.log("DONE")
            defer.reject()
    })
    return defer
}

function notify(show, messageCupcake, messageCustom, iconData) {
    function _notify(showId, message, iconUrl) {
        chrome.notifications.create('', {
            type: "basic",
            title: showId,
            message: message,
            iconUrl: iconUrl
        }, function () {
        })
    }

    if(iconData) {
        _notify(show.id, messageCustom, iconData)
    } else {
        localforage.getItem(show.id).then(function(iconData) {
            if(iconData) {
                _notify(show.id, messageCustom, iconData)
            } else {
                _notify(show.id, messageCupcake, "/favicon.ico")
            }
        })
    }
}

function setWatched(url, watched) {
    watched ? localStorage.setItem(url, true) : localStorage.removeItem(url)
}

function showDataFromConfig(config) {
    return showTemplates[config.template](config.id, config.url, config.episodeMatch, parseInt(config.episodeMatchGroup), Boolean(config.episodeReverse))
}

function showsConfigJStorage() {
    var jShowsConfig = $.jStorage.get("showsConfig")
    return jShowsConfig ? jShowsConfig : []
}

function showsDataJStorage() {
    var jShowsConfig = showsConfigJStorage()
    var showsData = jShowsConfig.map(showDataFromConfig)
    return showsData;
}

function updateEpisodes(show, webixData) {
    var oldEpisodes = $.jStorage.get(show.id)
    oldEpisodes = oldEpisodes ? oldEpisodes : []
    var newEpisodes = _.partition(webixData, function (episode) {
        return _.findWhere(oldEpisodes, { id: episode.id })
    })[1] //[0] - will return union, [1] - will return difference
    var mergedEpisodes = newEpisodes.concat(oldEpisodes)
    $.jStorage.set(show.id, mergedEpisodes)
    if (newEpisodes.length) {
        updateWatchedEpisodesCount()
        notify(show, (newEpisodes.length + " new cupcake") + (newEpisodes.length > 1 ? "s!" : "!"), (newEpisodes.length + " new episode") + (newEpisodes.length > 1 ? "s!" : "!"));
    }
}

function updateShows() {
    showsDataJStorage().forEach(function (show) {
        $.when(queryEpisodesImport(show)).then(updateEpisodes, function () {
            notify(show, 'Call failed', 'Call failed')
        })
    })
}

function updateWatchedEpisodesCount() {
    var count = showsDataJStorage().reduce(function (count, show) {
        var watchedAndCount = episodeWatchedAndCount(show.id)
        return count + watchedAndCount.count - watchedAndCount.watched
    }, 0)
    chrome.browserAction.setBadgeText({ text: String(count) })
    chrome.browserAction.setTitle({ title: String(count) })
}