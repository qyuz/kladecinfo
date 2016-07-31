updateWatchedEpisodesCount()

chrome.alarms.onAlarm.addListener(function (alarm) {
    console.log('will run in 60 seconds')
    _.delay(function() {
        console.log('last ran ' + new Date())
        updateShows()
    }, 60000)
})

chrome.alarms.create("it's time for show!", { delayInMinutes: 0, periodInMinutes: 60 })