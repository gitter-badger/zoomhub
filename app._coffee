express = require 'express'
app = require('streamline-express') express()
config = require './config'


## MIDDLEWARE:
# (see http://www.senchalabs.org/connect/ for reference)

# favicon reqs are very common; respond to those immediately:
app.use express.favicon()   # will use default favicon since we don't specify

# otherwise, log all requests:
app.use express.logger config.EXPRESS_LOGGER_FORMAT

# parse request bodies, e.g. JSON:
# (we don't need this yet, but it's easy to add and does no harm)
# (note also that this incorporates middleware to limit reqs to 1 MB. nice.)
app.use express.bodyParser()

# gzip response bodies (only kicks in after a size threshold):
# (we don't need this yet either, but it's also easy and harmless)
app.use express.compress()

# TODO we'll want middleware to implement CORS eventually.

# then run our routes, before the error handler in case there are errors:
app.use app.router

# TODO we need error handling middleware, but we want to return well-defined
# error JSON objects since we're an API, not a user-facing error HTML page.
# we need to define what those error objects look like and how we throw them.
# XXX using Express's dev error handler for now.
app.use express.errorHandler()


## ROUTES:

app.get '/', (req, res, _) ->
    setTimeout _, 500   # mimic async operation
    res.json 'Hello world.'


## MAIN:

if module is require.main
    app.listen config.PORT
    console.log """
        Zooming service listening at http://localhost:#{config.PORT}/ ...
    """
else
    module.exports = app