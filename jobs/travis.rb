require 'travis'
require 'travis/pro'

def update_public_builds(repository)
  Travis.access_token = ENV["TRAVIS_PUBLIC_TOKEN"]
  repo = Travis::Repository.find(repository)
  format_builds(repo, "https://travis-ci.org")
end

def update_pro_builds(repository)
  Travis::Pro.access_token = ENV["TRAVIS_PRO_TOKEN"]
  repo = Travis::Pro::Repository.find(repository)
  format_builds(repo, "https://magnum.travis-ci.com")
end

def format_builds(repo, root_url)
  builds = []
  build = repo.last_build
  build_info = {
    label: "Build #{build.number}",
    value: "[#{build.branch_info}], #{build.state} in #{build.duration}s",
    state: build.state,
    url: "#{root_url}/#{repo.slug}/builds/#{build.id}"
  }
  builds << build_info
  builds
end

pro_repositories = ENV["TRAVIS_PRO_REPOSITORIES"].split(",")
public_repositories = ENV["TRAVIS_PUBLIC_REPOSITORIES"].split(",")

SCHEDULER.every('2m', first_in: '1s') {
  public_repositories.each do |public_repository|
    send_event(public_repository.split("/").last, { items: update_public_builds(public_repository) })
  end
  pro_repositories.each do |pro_repository|
    send_event(pro_repository.split("/").last, { items: update_pro_builds(pro_repository) })
  end
}
