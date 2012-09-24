require_relative '../../lib/harvest/client.rb'
require 'spec_helper'

describe Harvest::Client do
  subject { Harvest::Client.new('64sNJl36mmKp6Wp6hmPwA67fD500G+6LVQjwNY6IGTl+SMNfFsC+Xv4Mc4/EMUSvzbAafRqpcUS2p7prjXBImA==') }

  describe '#new' do
    it 'delegates to the rest-core client' do
      client=Harvest::Client.new('some_key')
      client.access_token.should == 'some_key'
    end
  end

  describe '#invoices' do
    it 'returns an array of invoices' do
      VCR.use_cassette('invoices') do
        invoices = subject.invoices
        invoices[0].amount.should == '200.0'
        invoices[1].amount.should == '1000.0'
      end
    end
  end

  describe '#invoice' do
    it 'returns an invoice from id' do
      VCR.use_cassette('invoice') do
        invoice = subject.invoice('1860925')
        invoice.amount.should == '200.0'
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
        customers[0].name.should == "Highgroove"
      end
    end
  end

  describe '#customer' do
    it 'retrieves a customer' do
      VCR.use_cassette('customer') do
        customer = subject.customer('1199777')
        customer.name.should == "Highgroove"
      end
    end
  end
end
