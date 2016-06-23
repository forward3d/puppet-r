# for rspec-puppet documentation - see http://rspec-puppet.com/tutorial/
require_relative '../spec_helper'

describe 'r::package' do

  describe 'In ubuntu/redhat' do

    let(:facts) { {
      :operatingsystem => 'Debian',
      :architecture => 'amd64',
      :osfamily => 'Debian',
     } }

     let(:title) {'test'}

     it 'sets up the correct binary' do
       should contain_exec('install_r_package_test')
        .with_unless(/\/usr\/bin\/R/)
     end
   end
end
