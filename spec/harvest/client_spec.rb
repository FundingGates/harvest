require_relative '../../lib/harvest/client.rb'
require 'spec_helper'
require 'time'

describe Harvest::Client do
  subject { Harvest::Client.new('Zcgmf3RAu5HyTQBdewmSUR4cM3wAZKHmg+LukhgmnE1IOVsf+SuK+pVDkmj8hqlHdfm49I/T2gqP5xlJqBw4wg==') }

  describe '#new' do
    it 'delegates to the rest-core client' do
      client=Harvest::Client.new('some_key')
      client.access_token.should == 'some_key'
    end
  end

  describe '#who_am_i?' do
    it 'retrieves the current user' do
      VCR.use_cassette('who_am_i') do
        me = subject.who_am_i?
        me.email.should == 'accountingpackages@fundinggates.com'
      end
    end

    it 'raises an exception if Harvest returns an error' do
      VCR.use_cassette('bad_token') do
        client = Harvest::Client.new("bad-token")
        expect { client.who_am_i? }.to raise_error(Harvest::AuthorizationFailure, /token provided is expired/)
      end
    end
  end

  describe '#people' do
    it 'retrieves the users organization' do
      VCR.use_cassette('people') do
        people = subject.people
        people[0].email.should == 'accountingpackages@fundinggates.com'
      end
    end
  end

  describe '#company' do
    it 'retrieves information about the company' do
      VCR.use_cassette('company') do
        company = subject.company
        company.name.should == 'Funding Gates'
      end
    end
  end

  describe '#invoices' do
    it 'returns an array of invoices' do
      VCR.use_cassette('invoices') do
        invoices = subject.invoices
        invoices[0].should be_a Harvest::Invoice
      end
    end

    it 'accepts query params' do
      VCR.use_cassette('invoice_query_params') do
        cutoff = Time.utc(2012, 10, 1)
        invoices = subject.invoices(updated_since: cutoff)
        expect { invoices.delete_if { |inv| inv.updated_at < cutoff } }.to_not change(invoices, :length)
      end
    end
  end

  describe '#invoice' do
    it 'returns an invoice from id' do
      VCR.use_cassette('invoice') do
        invoice = subject.invoice('1882548')
        invoice.amount.should == 435.5
        invoice.updated_at.should be_a_kind_of Time
      end
    end

    it 'raises an exception if an invoice id is not valid' do
      VCR.use_cassette('invoice_invalid') do
        expect { subject.invoice('abc123') }.to raise_error Harvest::InvoiceNotFound
      end
    end
  end

  describe '#customers' do
    it 'list customers' do
      VCR.use_cassette('customers') do
        customers = subject.customers
        customers[0].name.should == "A Cavallo Violins, LLC"
      end
    end

    it 'accepts query params' do
      VCR.use_cassette('customer_query_params') do
        cutoff = Time.utc(2012, 10, 1)
        customers = subject.customers(updated_since: cutoff)
        expect { customers.delete_if { |inv| inv.updated_at < cutoff } }.to_not change(customers, :length)
      end
    end
  end

  describe '#customer' do
    it 'retrieves a customer' do
      VCR.use_cassette('customer') do
        customer = subject.customer('1268610')
        customer.name.should == "Whitworth Construction"
      end
    end
  end
end
