require './lib/racker'

use Rack::Static, :urls => ['/stylesheets'], :root => 'public'
use Rack::Reloader
use Rack::Session::Cookie

run Racker