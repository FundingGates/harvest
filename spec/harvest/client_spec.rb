require_relative '../../lib/harvest/client.rb'
require 'spec_helper'

describe Harvest::Client do
  subject { Harvest::Client.new('7L1pttbIrQSKC8sZpFcNhvrhlVVAQUQqB8ZPRms8GrMrnlS9hEzTVQIAv8rny/b0MFDWyZRieBdcyNEYdt2WSQ==') }

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
  end

  describe '#customers' do
    it 'list customers' do
      VCR.use_cassette('customers') do
        customers = subject.customers
        customers[0].name.should == "Highgroove"
      end
    end
  end
end
