#
# Author:: Marc Paradise (<marc@chef.io>)
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
#
require_relative "../secret_fetcher"

class Chef
  module DSL
    module Secret

      # Helper method which looks up a secret using the given service and configuration,
      # and returns the retrieved secret value.
      # This DSL providers a wrapper around [Chef::SecretFetcher]
      #
      # Use of the secret helper in the context of a resource block will automatically mark
      # that resource as 'sensitive', preventing resource data from being logged.  See [Chef::Resource#sensitive].
      #
      # @option name [Object] The identifier or name for this secret
      # @option version [Object] The secret version. If a service supports versions
      #                          and no version is provided, the latest version will be fetched.
      # @option service [Symbol] The service identifier for the service that will
      #                         perform the secret lookup. See
      #                         [Chef::SecretFetcher::SECRET_FETCHERS]
      # @option config [Hash] The configuration that the named service expects
      #
      # @return result [Object] The response object type is determined by the fetcher but will usually be a string or a hash.
      # See individual fetcher documentation to know what to expect for a given service.
      #
      # @example
      #
      # This example uses the built-in :example secret manager service, which
      # accepts a hash of secrets.
      #
      #   value = secret(name: "test1", service: :example, config: { "test1" => "value1" })
      #   log "My secret is #{value}"
      #
      #   value = secret(name: "test1", service: :aws_secrets_manager, version: "v1", config: { region: "us-west-1" })
      #   log "My secret is #{value}"
      def secret(name: nil, version: nil, service: nil, config: {})
        Chef::Log.warn <<~EOM.gsub("\n", " ")
          The secrets Chef Infra language helper is currently in beta.
          This helper will most likely change over time in potentially breaking ways.
          If you have feedback or you'd like to be part of the future design of this
          helper e-mail us at secrets_management_beta@progress.com"
        EOM
        sensitive(true) if is_a?(Chef::Resource)
        Chef::SecretFetcher.for_service(service, config, run_context).fetch(name, version)
      end
    end
  end
end
