# frozen_string_literal: true

class AllowDomainService < BaseService
  def call(domain)
    if DomainWhitelist.enabled?
      domain = DomainWhitelist.where(domain: domain).first
      if domain.nil?
        return :suspend
      end
      return domain.severity
    else
      domain = DomainBlock.where(domain: domain).first
      if domain.nil?
        return :enable
      end
      return domain.severity
    end
  end

  def blocked?(domain)
    return self.call(domain) == :suspend
  end

  def reject_media?(domain)
    if DomainWhitelist.enabled?
      domain_found = DomainWhitelist.find_by(domain: domain)
      return domain_found&.reject_media? || domain_found.nil?
    else
      return DomainBlock.find_by(domain: domain)&.reject_media?
    end
  end
end
