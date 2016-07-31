webix.ui({
    type:"space", responsive:true,
    cols:[
        {
            rows:[
                {
                    view:"tabbar",
                    type:"top",
                    options:[
                        { value:'Watch', id:"watch"},
                        { value:'Create', id:"create"},
                        { value:'Open in window', id:"popup" }
                    ]
                },
                {
                    view:"datatable",
                    id:"shows",
                    width:200,
                    header:false,
                    scroll:true,
                    select:true,
                    tooltip:true,
                    onContext: {},
                    columns:[
                        { id:"id", fillspace:1 },
                        {
                            id:"watch", width:30,
                            template:function (obj) {
                                var episodesWatchedAndCount = episodeWatchedAndCount(obj.id)
                                return episodesWatchedAndCount.count - episodesWatchedAndCount.watched
                            }
                        }
                    ]
                },
                {
                    view:"datatable",
                    id:"episodes",
                    width:200,
                    select:"cell",
                    tooltip:true,
                    onContext:{},
                    columns:[
                        {
                            id:"name", header:"Episode name", fillspace:1,
                            template:function (obj) {
                                return obj.link ? "<a href='" + obj.id + "' target='_blank'>" + obj.name + "</a>" : obj.name
                            }
                        },
                        {
                            id:"watched", header:"<span title='Cupcaked'>c</span>", width:30,
                            cssFormat: function(value, config) {
                                if(!isEpisodeWatched(config.id)) {
                                    return { "background-image": "url('/favicon.ico')", "background-size": "100%" }
                                }
                            }
                        }
                    ]
                },
                {
                    view:"list",
                    id:"try_templates",
                    hidden:true,
                    width:200,
                    scroll:false,
                    select:true,
                    template:"#name#",
                    data:[
                        {
                            id:"youtubeChannel", name:"Youtube Channel videos"
                        },
                        {
                            id:"youtubePlaylist", name:"Youtube Playlist"
                        },
                        {
                            id:"caramba", name:"CarambaTV.ru"
                        },
                        {
                            id:"seasonvar", name:"seasonvar.ru"
                        }
                    ]
                },
                {
                    view:"form",
                    id:"try_form",
                    hidden:true,
                    elements:[
                        {
                            view:"text", id:"showName", label:"Show name(unique)", labelPosition: "top"
                        },
                        {
                            view:"text", id:"showUrl", label:"URL", labelPosition: "top"
                        },
                        {
                            cols: [
                                {
                                    view:"text", id:"episodeMatch", value:"(.*)", label:"Name(match)", labelPosition: "top", width: 105, align: "left"
                                },
                                {
                                    view: "text", id: "episodeMatchGroup", value: "1", label: "Group", labelPosition: "top", width: 45, align: "left"
                                },
                                {
                                    view: "checkbox", id: "episodeReverse", value: "false", label: "Reverse", labelPosition: "top", width: 45
                                }
                            ]
                        },
                        {
                            view:"textarea", id:"showIcon", label:"Icon(data:base64)", labelPosition: "top", height: 40
                        },
                        {
                            cols: [
                                {
                                    view: "button", value: "Create", type: "form",
                                    click: function () {
                                        var showConfig = tryShowConfig(), jShowsConfig = showsConfigJStorage()
                                        localforage.setItem(showConfig.id, showConfig.iconData)
                                        jShowsConfig.push(_.omit(showConfig, 'iconData'))
                                        queryEpisodesImport(showDataFromConfig(showConfig)).then(updateEpisodes)
                                        $.jStorage.set("showsConfig", jShowsConfig)
                                    }
                                },
                                {
                                    view: "button", value: "Try",
                                    click: function () {
                                        var showConfig = tryShowConfig(), show = showDataFromConfig(showConfig)
                                        tryCollection.clearAll()
                                        $.when(queryEpisodesImport(show)).then(function (show, webixData) {
                                            notify(show, 'Use custom icon instead of cupcake!\r\nNavigate to http://www.askapache.com/online-tools/base64-image-converter/, Convert icon to Base64 and paste it into IconData', "Congratulations, your custom icon works!", showConfig.iconData)
                                            tryCollection.data_setter(webixData)
                                        }, function() {
                                            notify(show, 'Call failed', 'Call failed', showConfig.iconData)
                                        })
                                    }
                                }
                            ]
                        }
                    ]
                }
            ]
        },
        {
            rows:[
                {
                    view:"htmlform",
                    id:"iframe_form",
                    content:'iframe_form',
                    minWidth:300
                },
                {
                    view:"datatable",
                    id:"try_datatable",
                    hidden:true,
                    minWidth:300,
                    columns:[
                        {
                            id:"name", header:"Episode name", fillspace:1,
                            template:function (obj) {
                                return obj.link ? "<a href='" + obj.id + "' target='_blank'>" + obj.name + "</a>" : obj.name
                            }
                        }
                    ]
                }
            ]
        }
    ]
});


webix.ui({
        view: "contextmenu",
        id: "shows_contextmenu",
        width: 250,
        data: [
            { id: "window", value: "Open show in new window" },
            { $template: "Separator" },
            { id: "delete_all", value: "Delete show, bake all cupcakes" },
            { id: "delete", value: "Delete show(may leave trash)" }
        ],
        on: {
            onItemClick: function (id) {
                var showId = this.getContext().id.row
                var show = _.findWhere(showsDataJStorage(), { id: showId })

                function deleteShow(id, deleteEpisodes) {
                    var removedShowConfig = _.reject(showsConfigJStorage(), _.matches({ id: showId }))
                    $.jStorage.set("showsConfig", removedShowConfig)
                    if (deleteEpisodes) {
                        var episodes = $.jStorage.get(id)
                        episodes.forEach(function (episode) {
                            setWatched(episode.id, false)
                        })
                    }
                    $.jStorage.deleteKey(id)
                    localforage.removeItem(id)
                    updateWatchedEpisodesCount()
                }

                if (id == "window") {
                    chrome.tabs.create({ url: show.url })
                } else if (id == "delete_all") {
                    deleteShow(showId, true);
                } else if (id == "delete") {
                    deleteShow(showId)
                }
            }
        }
    })
webix.ui({
        view: "contextmenu",
        id: "episodes_contextmenu",
        width: 250,
        data: [
            { id: "window", value: "Open episode in new window" },
            { $template: "Separator" },
            { id: "watched", value: "Eat all cupcakes" },
            { id: "unwatched", value: "Bake all cupcakes" }
        ],
        on: {
            onItemClick: function (id) {
                var episodeId = this.getContext().id.row
                var showId = $$('shows').getSelectedId().row
                function watchedAll(id, flag) {
                    var episodes = $.jStorage.get(id)
                    episodes.forEach(function (episode) {
                        setWatched(episode.id, flag)
                    })
                    $$('shows').refresh()
                    $$('episodes').refresh()
                    updateWatchedEpisodesCount()
                }

                if (id == "window") {
                    chrome.tabs.create({ url: episodeId })
                } else if (id == "watched") {
                    watchedAll(showId, true);
                } else if (id == "unwatched") {
                    watchedAll(showId, false);
                }
            }
        }
    }
)

var showsCollection = new webix.DataCollection({
    data: showsDataJStorage()
}), episodesCollection = new webix.DataCollection({}), tryCollection = new webix.DataCollection({})
$$('episodes').data.sync(episodesCollection);
$$('shows').data.sync(showsCollection);
$$('try_datatable').data.sync(tryCollection);

$.jStorage.listenKeyChange("showsConfig", function(id) {
    showsCollection.clearAll()
    var showsData = showsDataJStorage();
    showsCollection.data_setter(showsData)
})

var lastUpdateEpisodeCollectionId
$$('shows').attachEvent("onAfterSelect", function (row) {
    episodesCollection.clearAll()
    $$('episodes').clearAll() //fix multiple selection glitch
    var selectedShow = _.findWhere(showsDataJStorage(), { id: row.row });
    episodesCollection.data_setter($.jStorage.get(selectedShow.id))
    lastUpdateEpisodeCollectionId && $.jStorage.stopListening(lastUpdateEpisodeCollectionId)
    lastUpdateEpisodeCollectionId = selectedShow.id
    $.jStorage.listenKeyChange(selectedShow.id, updateEpisodesCollection)
    var firstId = $$('episodes').getFirstId()
    firstId && $$('episodes').select(firstId, "name") //in case episodes are not yet populated
});
$$('episodes').attachEvent("onBeforeSelect", function (row) {
    if (row.column == "watched") {
        setWatched(row.row, !isEpisodeWatched(row.row)) //not using row.id because it has postfix _watched
        showsCollection.refresh()
        episodesCollection.refresh()
        updateWatchedEpisodesCount()
        return false
    }
});
$$('episodes').attachEvent("onAfterSelect", function (row) {
    var iframe = $('#iframe_form').find('iframe');
    var episode = $$('episodes').getItem(row.row)
    episode.topNavigation == false ? iframe.attr('sandbox', "allow-scripts allow-same-origin allow-forms allow-popups") : iframe.attr('sandbox', null)
    iframe.attr('src', row.row)
});

function tryShowConfig() {
    return {
        template: $$('try_templates').getSelectedId(),
        id: $$('showName').getValue(),
        url: $$('showUrl').getValue(),
        episodeMatch: $$('episodeMatch').getValue(),
        episodeMatchGroup: $$('episodeMatchGroup').getValue(),
        episodeReverse: $$('episodeReverse').getValue(),
        iconData: $$('showIcon').getValue()
    }
}

function updateEpisodesCollection(id) {
    var episodesData = episodesCollection.data, episodes = $.jStorage.get(id)
    var newEpisodes = _.difference(_.pluck(episodes, 'id'), episodesData.order)
    episodesData.order = newEpisodes.concat(episodesData.order)
    _.extend(episodesData.pull, _.object(newEpisodes, episodes))
    showsCollection.refresh()
    episodesData.refresh() //because refreshing collection will only refresh currently selected show watched(w) count
    updateWatchedEpisodesCount()
}

updateShows()

$$('shows_contextmenu').attachTo($$('shows'))
$$('episodes_contextmenu').attachTo($$('episodes'))
$$('shows').count() && $$('shows').select($$('shows').getFirstId())

$(document).on('click', 'div[button_id="watch"]', function () {
    $$('shows').show()
    $$('episodes').show()
    $$('iframe_form').show()
    $$('try_templates').hide()
    $$('try_form').hide()
    $$('try_datatable').hide()
})
$(document).on('click', 'div[button_id="create"]', function () {
    $$('try_templates').show()
    $$('try_form').show()
    $$('try_datatable').show()
    $$('shows').hide()
    $$('episodes').hide()
    $$('iframe_form').hide()
})
$(document).on('click', 'div[webix_l_id="popup"], div[button_id="popup"]', function () {
    chrome.tabs.create({ url: window.location.href })
})
$$('try_templates').select($$('try_templates').getFirstId())