require_relative '../../lib/harvest/client.rb'
require 'spec_helper'
require 'time'

describe Harvest::Client do
  subject { Harvest::Client.new('1wzL04XtJWcz9zeyvaiTb+f1qRYBayXG9kHUYKI01K0phuL6Z2TxGYowg1U1pT01QqZkbcC4U9zfuIqh4s3cFg==') }

  describe '#new' do
    it 'delegates to the rest-core client' do
      client=Harvest::Client.new('some_key')
      client.access_token.should == 'some_key'
    end
  end

  describe '#who_am_i?' do
    it 'retrieves the current user' do
      me = subject.who_am_i?
      me.email.should == 'accountingpackages@fundinggates.com'
    end

    it 'raises an exception if Harvest returns an error' do
      client = Harvest::Client.new("bad-token")
      expect { client.who_am_i? }.to raise_error(Harvest::AuthorizationFailure, /token provided is expired/)
    end
  end

  describe '#people' do
    it 'retrieves the users organization' do
      people = subject.people
      people[0].email.should == 'accountingpackages@fundinggates.com'
    end
  end

  describe '#company' do
    it 'retrieves information about the company' do
      company = subject.company
      company.name.should == 'Funding Gates'
    end
  end

  describe '#invoices' do
    it 'returns an array of invoices' do
      invoices = subject.invoices
      invoices[0].should be_a Harvest::Invoice
    end

    it 'accepts query params' do
      cutoff = Time.utc(2012, 10, 1)
      invoices = subject.invoices(updated_since: cutoff)
      expect { invoices.delete_if { |inv| inv.updated_at < cutoff } }.to_not change(invoices, :length)
    end
  end

  describe '#invoice' do
    it 'returns an invoice from id' do
      invoice = subject.invoice('1882548')
      invoice.amount.should == 435.5
      invoice.updated_at.should be_a_kind_of Time
    end

    it 'raises an exception if an invoice id is not valid' do
      expect { subject.invoice('abc123') }.to raise_error Harvest::InvoiceNotFound
    end
  end

  describe '#customers' do
    it 'list customers' do
      customers = subject.customers
      customers[0].name.should == "A Cavallo Violins, LLC"
    end

    it 'accepts query params' do
      cutoff = Time.utc(2012, 10, 1)
      customers = subject.customers(updated_since: cutoff)
      expect { customers.delete_if { |inv| inv.updated_at < cutoff } }.to_not change(customers, :length)
    end
  end

  describe '#customer' do
    it 'retrieves a customer' do
      customer = subject.customer('1268610')
      customer.name.should == "Whitworth Construction"
    end
  end

  describe '#contacts_for_customer' do
    it 'retrieves a contact for a customer' do
      contacts = subject.contacts_for_customer('1268614')
      contacts.first.first_name.should == "Jordon"
    end

    it 'without contacts' do
      contacts = subject.contacts_for_customer('1268610')
      contacts.should == []
    end

    it 'without contacts... again' do
      contacts = subject.contacts_for_customer('1268554')
      contacts.should == []
    end
  end

  describe '#contacts' do
    it 'retrieves an array of contacts' do
      contacts = subject.contacts
      contacts.first.should be_a_kind_of Harvest::Person
    end
  end
end
