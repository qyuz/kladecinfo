javascript: (function() {
    function unique(array, isSorted, iteratee, context) {
        if (array == null) return [];
        if (typeof isSorted !== "boolean") {
            context = iteratee;
            iteratee = isSorted;
            isSorted = false;
        }
        var result = [];
        var seen = [];
        for (var i = 0, length = array.length; i < length; i++) {
            var value = array[i];
            if (isSorted) {
                if (!i || seen !== value) result.push(value);
                seen = value;
            } else if (iteratee) {
                var computed = iteratee(value, i, array);
                if (seen.indexOf(computed) < 0) {
                    seen.push(computed);
                    result.push(value);
                }
            } else if (result.indexOf(value) < 0) {
                result.push(value);
            }
        }
        return result;
    };


    function time(el) {
        var time = $(el).find('.published').text().match(/(.+) . (\d+):(\d+)/);
        return {
            day: time[1] == 'сегодня' ? 1 : 0,
            hour: parseInt(time[2]),
            minute: parseInt(time[3])
        }
    }

    function sortByTime(a, b) {
        var timeA = time(a),
            timeB = time(b);
        if (timeA.day == timeB.day) {
            if (timeA.hour == timeB.hour) {
                if (timeA.minute == timeB.minute) {
                    return 0;
                } else {
                    return timeA.minute > timeB.minute ? -1 : 1;
                }
            } else {
                return timeA.hour > timeB.hour ? -1 : 1;
            }
        } else {
            return timeA.day > timeB.day ? -1 : 1;
        }
    }

    function sortByFields(fields, order, convert) {
        return function(a, b) {
			if(convert) {
				a = convert(a);
				b = convert(b);
			}
            var fs = fields.slice(0),
                field;
            while (field = fs.shift()) {
                if (a[field] != b[field]) {
                    return a[field] > b[field] ? 1 * order : -1 * order;
                }
            }
			return 0;
        }
    }

    var pages = ['/'],
        postsQuery = '.shortcuts_item',
        pageCount = parseInt($('#nav-pages>li').last().text());
    console.log('found %d pages', pageCount);
    if (pageCount) {
        for (var i = 2; i <= pageCount; i++) {
            pages.push('/page' + i);
        }
    }

    $(postsQuery).remove();
    $('.page-nav').css('display', 'none');
    var pageElements = [],
        sortByTime = sortByFields(['day', 'hour', 'minute'], -1, time);
    $.when.apply(this, pages.map(function(page) {
            return $.get(page)
        }))
        .then(function() {
            var args = Array.prototype.slice.call(arguments, 0);
            pageElements = args.reduce(function(curr, response) {
                var elements = $(response[0]).find(postsQuery).get();
                console.log('found %d posts', elements.length);
                return curr.concat(elements)
            }, pageElements);
            console.log('%d posts in total', pageElements.length);
            pageElements = unique(pageElements, function(e) {
                return $(e).attr('id')
            });
            console.log('%d of them are unique', pageElements.length);
            pageElements.sort(sortByTime);
            $('.shortcuts_items').append(pageElements);
        })
}())