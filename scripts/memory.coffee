# Description:
#   Use hubots redis brain to store useful information
#
# Author:
#   locks
#
# Commands:
#   hubot learn "<key name>" means <value> - Get Hubot to memorize something new
#   !learn "<key name>" means <value> - Get Hubot to memorize something new
#   hubot relearn "<key name>" means <value> - Overwrite something that Hubot learned before
#   hubot ? - Lists all the things that Hubot has learned

module.exports = (robot) ->
  redisUrl = process.env.REDISCLOUD_URL
  thoughts = null

  robot.respond /\?$/, (res) ->
    res.reply "Here are the commands I know: `learn`, `remember`, `learned`, `relearn`"
    res.reply "To learn more about the command ask me `? <command>`"

  actuallyLearnMethod = (res, key, value) ->
    thoughts[key] = value
    robot.brain.emit 'save'
    res.reply "gotcha, *'#{key}'* means '#{value}'"

  learnMethod = (res) ->
    [_, key, value] = res.match
    if thoughts[key]
      res.reply "I've already learnt that \" #{key} \" means #{thoughts[key]}"
    else
      actuallyLearnMethod(res, key, value)

  relearnMethod = (res) ->
    [_, key, value] = res.match
    actuallyLearnMethod(res, key, value)

  robot.hear /^!learn "([^"]+)" (.+)$/i, (res)-> learnMethod(res)
  robot.respond /learn "([^"]+)" (.+)$/i, (res)-> learnMethod(res)

  robot.respond /relearn "([^"]+)" (.+)$/i, (res)-> relearnMethod(res)

  robot.respond /\? learn$/, (res) ->
    res.send "> @tombot learn \"quotes-delimited key\" the thing you want me to remember"
    res.send "> !learn \"quotes-delimited key\" the things you want me to remember"
    res.reply "I will learn something new for you."

  robot.respond /\? relearn$/, (res) ->
    res.send "* @tombot relearn \"quotes-delimited key\" the thing you want me to remember"
    res.reply "I will replace what I have learned with the new information."

  rememberMethod = (res) ->
    [_, match] = res.match
    if `match in thoughts`
      res.send thoughts[match]
    else
      res.send "sorry, I don't know this :("

  robot.hear /^!remember "([^"]+)"/, rememberMethod
  robot.respond /.*remember "([^"]+)".*/, rememberMethod

  robot.respond /\? remember/, (res) ->
    res.send "> `@tombot remember \"quotes-delimited key`\""
    res.send "> `!remember \"quotes-delimited key`\""
    res.respond "I will try to remember something for you."

  robot.respond /learned/, (res) ->
    res.reply "check out my brain at http://rampant-stove.surge.sh/"

  robot.respond /\? learned$/, (res) ->
    res.send " * learned // in a Direct Message"
    res.reply "I will tell you every single thing I've learned."
    res.reply "Since it might be a lot please only ask me this in a Direct Message"

  robot.brain.on 'loaded', ->
    thoughts = robot.brain.data.thoughts
    thoughts ?= {}
