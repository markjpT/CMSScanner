module CMSScanner
  # References related to the issue
  module References
    extend ActiveSupport::Concern

    # See ActiveSupport::Concern
    module ClassMethods
      # @return [ Array<Symbol> ]
      def references_keys
        @references_keys ||= [:cve, :secunia, :osvdb, :exploitdb, :url, :metasploit, :packetstorm, :securityfocus]
      end
    end

    # @param [ Hash ] refs
    def references=(refs)
      @references = {}

      self.class.references_keys.each do |key|
        @references[key] = [*refs[key]].map(&:to_s) if refs.key?(key)
      end
    end

    # @return [ Hash ]
    def references
      @references ||= {}
    end

    # @return [ Array<String> ] All the references URLs
    def references_urls
      cve_urls + secunia_urls + osvdb_urls + exploitdb_urls + urls + msf_urls +
        packetstorm_urls + securityfocus_urls
    end

    # @return [ Array<String> ] The CVEs
    def cves
      references[:cve] || []
    end

    # @return [ Array<String> ]
    def cve_urls
      cves.reduce([]) { |a, e| a << cve_url(e) }
    end

    # @return [ String ] The URL to the CVE
    def cve_url(cve)
      "https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-#{cve}"
    end

    # @return [ Array<String> ] The Secunia IDs
    def secunia_ids
      references[:secunia] || []
    end

    # @return [ Array<String> ]
    def secunia_urls
      secunia_ids.reduce([]) { |a, e| a << secunia_url(e) }
    end

    # @return [ String ] The URL to the Secunia advisory
    def secunia_url(id)
      "https://secunia.com/advisories/#{id}/"
    end

    # @return [ Array<String> ] The OSVDB IDs
    def osvdb_ids
      references[:osvdb] || []
    end

    # @return [ Array<String> ]
    def osvdb_urls
      osvdb_ids.reduce([]) { |a, e| a << osvdb_url(e) }
    end

    # @return [ String ] The URL to the ExploitDB advisory
    def osvdb_url(id)
      "http://osvdb.org/show/osvdb/#{id}"
    end

    # @return [ Array<String> ] The ExploitDB ID
    def exploitdb_ids
      references[:exploitdb] || []
    end

    # @return [ Array<String> ]
    def exploitdb_urls
      exploitdb_ids.reduce([]) { |a, e| a << exploitdb_url(e) }
    end

    # @return [ String ]
    def exploitdb_url(id)
      "https://www.exploit-db.com/exploits/#{id}/"
    end

    # @return [ String<Array> ]
    def urls
      references[:url] || []
    end

    # @return [ Array<String> ] The metasploit modules
    def msf_modules
      references[:metasploit] || []
    end

    # @return [ Array<String> ]
    def msf_urls
      msf_modules.reduce([]) { |a, e| a << msf_url(e) }
    end

    # @return [ String ] The URL to the metasploit module page
    def msf_url(mod)
      "https://www.rapid7.com/db/modules/#{mod.sub(%r{^/}, '')}"
    end

    # @return [ Array<String> ] The Packetstormsecurity IDs
    def packetstorm_ids
      @packetstorm_ids ||= references[:packetstorm] || []
    end

    # @return [ Array<String> ]
    def packetstorm_urls
      packetstorm_ids.reduce([]) { |a, e| a << packetstorm_url(e) }
    end

    # @return [ String ]
    def packetstorm_url(id)
      "http://packetstormsecurity.com/files/#{id}/"
    end

    # @return [ Array<String> ] The Security Focus IDs
    def securityfocus_ids
      references[:securityfocus] || []
    end

    # @return [ Array<String> ]
    def securityfocus_urls
      securityfocus_ids.reduce([]) { |a, e| a << securityfocus_url(e) }
    end

    # @return [ String ]
    def securityfocus_url(id)
      "http://www.securityfocus.com/bid/#{id}/"
    end
  end
end
