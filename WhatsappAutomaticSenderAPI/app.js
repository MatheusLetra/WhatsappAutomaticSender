const express = require('express')
const cors = require('cors')
const bodyParser = require('body-parser')

const { Sender } = require('./src/models/sender')

const sender = new Sender()

const app = express()

app.use(bodyParser.json())
app.use(cors())

app.get('/status', (req, res) => {
  return res.send({
    qr_code: sender.qrCode(),
    connected: sender.isConnected()
  })

})

app.post('/send', async (req, res) => {
  const { number, message } = req.body

  try {
    await sender.sendText(number, message)
    return res.status(200).json()
  } catch (error) {
    console.log(error)
    res.status(500).json({
      status: 'error',
      message: error
    })
  }
})

app.listen(8000, () => {
  //console.clear()
  console.log(`Server is running on port ${8000}`)
})
