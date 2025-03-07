console.log('In push.js')

BareKit.on('push', function(buffer, reply) {
  const json = JSON.parse(buffer.toString())
  const notification = json?.aps?.alert
  console.log('Received push:', notification)

  const title = notification.title || 'BareKit'
  const body = notification.body || 'This is the deault body'
  reply(null, JSON.stringify({ title, body }))
})
