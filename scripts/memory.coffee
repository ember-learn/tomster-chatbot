# Description:
#   Use hubots redis brain to store useful information
#
# Author:
#   locks
#
# Commands:
#   hubot learn "<key name>" means <value> - Get Hubot to memorize something new
#   hubot relearn "<key name>" means <value> - Overwrite something that Hubot learned before
#   hubot learned - Check all the things Hubot as learned so far
#   hubot remember "<key name>" - Retrieves a specific fact
#   hubot <key name>? - Retrieves a specific fact

admins = { 'lala': 'lala' }

module.exports = (robot) ->
  redisUrl = process.env.REDISCLOUD_URL
  thoughts = null

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

  robot.respond /learn "([^"]+)" (.+)$/i, (res)-> learnMethod(res)

  robot.respond /relearn "([^"]+)" (.+)$/i, (res)-> relearnMethod(res)

  rememberMethod = (res) ->
    console.log(res.match)
    [_, match] = res.match
    if match of thoughts
      res.send thoughts[match]
    else
      res.send "sorry, I don't know this :("

  robot.respond /.*remember "([^"]+)".*/, rememberMethod
  robot.respond /([^?]+)?/, rememberMethod

  robot.respond /learned/, (res) ->
    res.reply "check out my brain at http://rampant-stove.surge.sh/"

  robot.respond /forget "([^"]+)"/i, (res) ->
    [_, match] = res.match
    username = message.envelope.user.name

    unless username of admins
      res.reply "sorry, you don't have permissions"
      return

    if match of thoughts
      delete robot.brain.data.thoughts[match]
      robot.brain.emit 'save'
      res.reply "#{match}? never heard about it. :wink:"
    else
      res.reply "I never learned about #{match}"

  robot.brain.on 'loaded', ->
    thoughts = robot.brain.data.thoughts
    thoughts ?= {}

# DM: robot.send {room: message.envelope.user.name}, message
