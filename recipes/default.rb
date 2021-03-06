ruby_version = node['ruby']['version']
gem_version = node['ruby']['gem_version']
bundler_version = node['ruby']['bundler_version']

package 'readline-devel'
package 'openssl-devel'

include_recipe 'build-essential'
include_recipe 'ruby_build'

ruby_build_ruby ruby_version do
  prefix_path '/usr/local'
  environment ({
    'CFLAGS' => '-g -O2',
    'TMPDIR' => '/opt/ruby-build'
  })
  action node['ruby']['install_action']
end

bash "gem update --system #{gem_version}" do
  code "/usr/local/bin/gem update --system #{gem_version}"
  not_if "/usr/local/bin/gem -v | grep ^#{gem_version}"
end

gem_package 'bundler' do
  gem_binary '/usr/local/bin/gem'
  version bundler_version
end
