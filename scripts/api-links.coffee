# Description:
#   Respond to requests for different Ember classes with links from the Ember API
#
# Commands:
#   !api <Class Name>(#methodName optional) - Prints out a link to the Class, or method name mentioned
#   hubot api <Class Name>(#methodName optional) - Prints out a link to the Class, or method name mentioned
#
# Author:
#   brandonjmckay

# module.exports = (robot) ->
#   docsUrl = 'http://emberjs.com/api/classes/'
#   htmlSuffix = '.html'
#   methodPrefix = '#method_'

#   printApiLink = (res)->
#     className = res.match[1]
#     subClassName = res.match[2]
#     methodValue = res.match[3]?.replace('#', '')

#     response = "Check out " + docsUrl + className
#     response += subClassName if subClassName?
#     response += htmlSuffix
#     response += methodPrefix + methodValue if methodValue?
#     res.send response

#   robot.hear /^!api (\w*)(\.\w*)?(\#\w*)?/, (res) -> printApiLink(res)
#   robot.respond /^api (\w*)(\.\w*)?(\#\w*)?/, (res) -> printApiLink(res)
