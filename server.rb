require 'sinatra'
require 'json'

teams = [{id: 1, team_name: "Giants", league: "National League", division: "West"}]

get '/' do
  "Home Page"
end

## Custom Method for Getting Request body
def get_body(req)
  req.body.rewind
  body_content = req.body.read
  return {} if body_content.empty?
  JSON.parse(body_content)
rescue JSON::ParserError
  halt 400, { error: "Invalid JSON" }.to_json
end

## Index method
get '/teams' do
  content_type :json
  return teams.to_json
end

## Show method
get '/teams/:id' do
  id = params["id"].to_i
  team = teams.find { |t| t[:id] == id }
  return team.to_json if team
  status 404
  return { error: "Team not found" }.to_json
end

## Create method
post '/teams' do
  content_type :json
  new_id = teams.length + 1
  new_team = {id: new_id, team_name: params["team_name"], league: params["league"], division: params["division"]}
  teams.push(new_team)
  new_team.to_json
end

## Update method
patch '/teams/:id' do
  content_type :json
  id = params["id"].to_i
  team = teams.find { |t| t[:id] == id }
  
  unless team
    status 404
    return { error: "Team not found" }.to_json
  end
  
  team[:team_name] = params["team_name"] if params["team_name"]
  team[:league] = params["league"] if params["league"]
  team[:division] = params["division"] if params["division"]
  team.to_json
end

## Destroy method
delete '/teams/:id' do
  content_type :json
  id = params["id"].to_i
  team_index = teams.find_index { |t| t[:id] == id }
  
  unless team_index
    status 404
    return { error: "Team not found" }.to_json
  end
  
  deleted_team = teams.delete_at(team_index)
  deleted_team.to_json
end
