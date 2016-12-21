require './lib/racker'
require './lib/my_middleware'

use Rack::Static, :urls => ['/stylesheets'], :root => 'public'
use Rack::Reloader
use Rack::Session::Cookie

use MyMiddleware
run Racker