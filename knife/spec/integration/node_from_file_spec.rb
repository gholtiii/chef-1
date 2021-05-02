#
# Copyright:: Copyright (c) Chef Software Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require "knife_spec_helper"
require "support/shared/integration/integration_helper"
require "support/shared/context/config"

describe "knife node from file", :workstation do
  include IntegrationSupport
  include KnifeSupport

  # include_context "default config options"

  let(:node_dir) { "#{@repository_dir}/nodes" }

  when_the_chef_server "is empty" do
    when_the_repository "has some nodes" do
      before do

        file "nodes/cons.json", <<~EOM
          {
            "name": "cons",
            "chef_environment": "_default",
            "run_list": [
            "recipe[cons]"
          ]
          ,
            "normal": {
              "tags": [

              ]
            }
          }
        EOM

      end

      it "uploads a single file" do
        knife("node from file #{node_dir}/cons.json").should_succeed stderr: <<~EOM
          Updated Node cons
        EOM
      end

    end
  end
end