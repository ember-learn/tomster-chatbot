# Description:
#   Example scripts for you to examine and try out.
#
# Notes:
#   They are commented out by default, because most of them are pretty silly and
#   wouldn't be useful and amusing enough for day to day huboting.
#   Uncomment the ones you want to try and experiment with.
#
#   These are from the scripting documentation: https://github.com/github/hubot/blob/master/docs/scripting.md
# commands: !api, !learn !relearn !forget !get


module.exports = (robot) ->
  redisUrl = process.env.REDISCLOUD_URL
  docsUrl = 'http://emberjs.com/api/classes/'
  htmlSuffix = '.html'
  methodPrefix = '#method_'
  robot.brain.thoughts ?= {}

  robot.hear /^!api (\w*)(\.\w*)?(\#\w*)?/, (res) ->
    className = res.match[1]
    subClassName = res.match[2]
    methodValue = res.match[3]?.replace('#', '')

    response = "Check out " + docsUrl + className
    response += subClassName if subClassName?
    response += htmlSuffix
    response += methodPrefix + methodValue if methodValue?
    res.send response

  robot.respond /\?$/, (res) ->
    res.reply "Here are the commands I know: `learn`, `remember`, `learned`"
    res.reply "To learn more about the command ask me `? <command>`"

  learnMethod = (res) ->
    key = res.match[1]
    value = res.match[2]
    robot.brain.thoughts[key] = value
    res.reply "gotcha, '#{key}' means '#{value}'"

  robot.hear /^!learn "(.*)" (.*)$/i, (res)-> learnMethod(res)
  robot.respond /learn "(.*)" (.*)$/i, (res)-> learnMethod(res)

  robot.respond /\? learn$/, (res) ->
    res.send "* @tombot learn \"quotes-delimited key\" the thing you want me to remember"
    res.send "* !learn \"quotes-delimited key\" the things you want me to remember"
    res.reply "I will learn something new for you."

  rememberMethod = (res) ->
    match = res.match[1]
    if `match in robot.brain.thoughts`
      res.send robot.brain.thoughts[match]
    else
      res.send "sorry, I don't know this :("

  robot.hear /^!remember "(.*)"/, rememberMethod
  robot.respond /.*remember "(.*)".*/, rememberMethod

  robot.respond /\? remember/, (res) ->
    res.reply "* @tombot remember \"quotes-delimited key\"
      * !remember \"quotes-delimited key\"
      I will try to remember something for you."

  robot.respond /learned/, (res) ->
    res.send "Here's what I learned:"
    res.send '"' + thought + '" ' + robot.brain.thoughts[thought] for thought of robot.brain.thoughts
    res.emote "Fin"

  robot.respond /\? learned$/, (res) ->
    res.send " * learned // in a Direct Message"
    res.reply "I will tell you every single thing I've learned."
    res.reply "Since it might be a lot please only ask me this in a Direct Message"
