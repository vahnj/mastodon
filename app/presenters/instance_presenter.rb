# frozen_string_literal: true

class InstancePresenter
  delegate(
    :closed_registrations_message,
    :site_contact_email,
    :open_registrations,
    :site_description,
    :site_extended_description,
    to: Setting
  )

  def contact_account
    Account.find_local(Setting.site_contact_username)
  end

  def user_count
    Rails.cache.fetch('user_count') { User.count }
  end

  def status_count
    Rails.cache.fetch('local_status_count') { Status.local.count }
  end

  def whitelist
    Rails.cache.fetch('whitelist') { DomainWhitelist.all }
  end

  def domain_count
    if DomainWhitelist.enabled? 
      whitelist.length
    else
      Rails.cache.fetch('distinct_domain_count') { Account.distinct.count(:domain) }
    end
  end
end
