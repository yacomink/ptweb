require 'sinatra'
require 'pathname'

lib = (Pathname.new(__FILE__).realpath.dirname.to_s + '/lib')
$LOAD_PATH.unshift(lib) if File.directory?(lib) && !$LOAD_PATH.include?(lib)

require 'simple_client.rb'

post '/:project_id' do

    @simple = SimpleClient.new( ENV['PIVOTAL_API_KEY'] )
	story = @simple.story( {:project_id => params[:project_id], :story_id => params[:text] }  )

	"#{story['name']} -\n#{story['description']}\n\n#{story['url']}"
end
