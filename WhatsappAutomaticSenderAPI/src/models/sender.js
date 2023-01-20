const VenomBot = require('venom-bot')
const {
  parsePhoneNumber,
  isValidPhoneNumber
} = require('libphonenumber-js')

class Sender {
  constructor() {
    this.initialize()
  }

  isConnected() {
    return this.connected
  }

  qrCode() {
    return this.qr
  }

  async sendText(to, body) {

    if (!isValidPhoneNumber(to, 'BR')) {
      throw new Error('This number is not valid')
    }

    let phoneNumber = parsePhoneNumber(to, 'BR')
      .format('E.164')
      .replace('+', '')

    phoneNumber = phoneNumber.includes('@c.us')
      ? phoneNumber
      : `${phoneNumber}@c.us`

    console.log(String.fromCharCode(body))
    await this.client.sendText(phoneNumber, body)
  }

  initialize() {
    this.connected = false

    const qr = (base64Qrimg) => {
      this.qr = {
        base64Qrimg
      }
    }

    const status = (statusSession) => {
      //return isLogged || notLogged || browserClose || qrReadSuccess || qrReadFail || autocloseCalled || desconnectedMobile || deleteToken || chatsAvailable || deviceNotConnected || serverWssNotConnected || noOpenBrowser || initBrowser || openBrowser || connectBrowserWs || initWhatsapp || erroPageWhatsapp || successPageWhatsapp || waitForLogin || waitChat || successChat
      //Create session wss return "serverClose" case server for close
      // 3rd param is chatsAvailable

      this.connected = ['isLogged', 'qrReadSuccess']
        .includes(statusSession)
    }

    const start = (client) => {
      console.log('caiu no start')

      client.onStateChange((state) => {
        console.log('Mudança de Estado', state)
        this.connected = state ===
          VenomBot.SocketState.CONNECTED
      })

      this.client = client
      this.connected = true
      
    }

    VenomBot.create('ws-automatic-sender', qr, status)
      .then((client) => {
        
        start(client)
      })
      .catch((error) => console.error(error))
  }

}

module.exports = { Sender }