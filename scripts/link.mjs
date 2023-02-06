import fs from 'fs/promises'
import path from 'path'
import url from 'url'
import ScriptLinker from 'script-linker'
import includeStatic from 'include-static'

const __filename = url.fileURLToPath(import.meta.url)
const __dirname = path.dirname(__filename)

const root = path.join(__dirname, '..')

const s = new ScriptLinker({
  bare: true,
  map (path) {
    return `<app>${path}`
  },
  mapResolve (req) {
    if (req === 'events') return '@pearjs/events'
    if (req === 'fs') return '@pearjs/fs'
    if (req === 'path') return '@pearjs/path'
    return req
  },
  readFile (filename) {
    return fs.readFile(path.join(root, filename))
  },
  builtins: {
    has () {
      return false
    },
    async get () {},
    keys () {
      return []
    }
  }
})

const bundle = await s.bundle('/src/app.js')

await fs.writeFile(path.join(root, 'bin/app.js'), bundle)

await fs.writeFile(path.join(root, 'bin/app.js.h'), includeStatic('app_js', Buffer.from(bundle)))
