require_relative '../../lib/harvest/client.rb'
require 'spec_helper'

describe Harvest::Client do
  subject { Harvest::Client.new('/TMzjL4ZB2MNuxwe9F3DbsuETe4iIx0B8KpW39q6tDy86EXHWhvH1/N44ZHOXNmOzA22sOcxGq87x/2CZJEoRA==') }

  describe '#new' do
    it 'delegates to the rest-core client' do
      client=Harvest::Client.new('some_key')
      client.access_token.should == 'some_key'
    end
  end

  describe '#get' do
    it 'raises an exception if Harvest returns an error' do
      VCR.use_cassette('bad_token') do
        client = Harvest::Client.new("bad-token")
        expect { client.get('account/who_am_i') }.to raise_error(Harvest::HarvestError, /token provided is expired/)
      end
    end
  end

  describe '#who_am_i?' do
    it 'retrieves the current user' do
      VCR.use_cassette('who_am_i') do
        me = subject.who_am_i?
        me.email.should == 'accountingpackages@fundinggates.com'
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
  end

  describe '#invoice' do
    it 'returns an invoice from id' do
      VCR.use_cassette('invoice') do
        invoice = subject.invoice('1882548')
        invoice.amount.should == '435.5'
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
