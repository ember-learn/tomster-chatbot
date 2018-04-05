/*
 * decaffeinate suggestions:
 * DS101: Remove unnecessary use of Array.from
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
// Description:
//   Use hubots redis brain to store useful information
//
// Author:
//   locks
//
// Commands:
//   hubot learn "<key name>" means <value> - Get Hubot to memorize something new
//   hubot relearn "<key name>" means <value> - Overwrite something that Hubot learned before
//   hubot learned - Check all the things Hubot as learned so far
//   hubot remember "<key name>" - Retrieves a specific fact
//   hubot <key name>? - Retrieves a specific fact

module.exports = function(robot) {
  const actuallyLearnMethod = function(res, key, value) {
    robot.brain.set(key, value);
    robot.brain.save();
    return res.reply(`gotcha :+1:, *'${key}'* means '${value}'`);
  };

  const learnMethod = function(res) {
    const [_, key, value] = Array.from(res.match);
    const thought = robot.brain.get(key);
    if (thought) {
      return res.reply(
        `I've already learnt that :sunglasses: \" ${key} \" means ${thought}`
      );
    } else {
      return actuallyLearnMethod(res, key, value);
    }
  };

  const relearnMethod = function(res) {
    const [_, key, value] = Array.from(res.match);
    return actuallyLearnMethod(res, key, value);
  };

  robot.respond(/learn "([^"]+)" (.+)$/i, res => learnMethod(res));

  robot.respond(/relearn "([^"]+)" (.+)$/i, res => relearnMethod(res));

  const rememberMethod = function(res) {
    console.log(res.match);
    const [_, match] = Array.from(res.match);
    const thought = robot.brain.get(match);
    if (thought) {
      return res.send(thought);
    } else {
      return res.send("sorry, I don't know this :(");
    }
  };

  robot.respond(/.*remember "([^"]+)".*/, rememberMethod);
  robot.respond(/([^?]+)\?/, rememberMethod);

  robot.respond(/learned/, res =>
    res.reply(
      "My friends have taught me about,\n" +
        Object.keys(robot.brain.data._private)
          .map(x => `• ${x}`)
          .join("\n")
    )
  );

  return robot.respond(/forget "([^"]+)"/i, function(res) {
    const [_, match] = Array.from(res.match);
    // const username = message.envelope.user.name;

    // if (!(username in admins)) {
    //   res.reply(
    //     "sorry, you don't have permissions :stuck_out_tongue_winking_eye:"
    //   );
    //   return;
    // }

    const thought = robot.brain.get(match);
    if (match) {
      robot.brain.remove(match);
      robot.brain.save();
      return res.reply(`${match}? never heard about it. :wink:`);
    } else {
      return res.reply(`I never learned about ${match}`);
    }
  });
};

// DM: robot.send {room: message.envelope.user.name}, message
