require_relative '../../lib/harvest/client.rb'
require 'spec_helper'
require 'time'

describe Harvest::Client do
  subject { Harvest::Client.new('D4mPzRt4jQDmnC1ayYzFeF/WuhpnoAlD/U8frWIAeksB2ke8Qu/cUvd9LtusJcKpe4seKruQ31tdY1iSA7uxGw==') }

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
      expect { client.who_am_i? }.to raise_error(Harvest::Unauthorized)
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
      expect { subject.invoice('abc123') }.to raise_error Harvest::NotFound
    end
  end

  describe '#payments_for_invoice' do
    let(:invoice_id) { '1990900' }

    it 'returns an array of payments' do
      payments = subject.payments_for_invoice(invoice_id)
      payments[0].should be_a Harvest::Payment
    end

    it 'accepts query params' do
      cutoff = Time.utc(2012, 10, 1)
      payments = subject.payments_for_invoice(invoice_id, updated_since: cutoff)
      expect { payments.delete_if { |payment| payment.updated_at < cutoff } }.to_not change(payments, :length)
    end
  end

  describe '#payment' do
    let(:invoice_id) { '1990900' }
    it 'returns an payment from invoice_id and id' do
      payment = subject.payment(invoice_id, '1625417')
      payment.paid_at.should == DateTime.parse('2012-11-29 02:40:30 UTC')
      payment.updated_at.should be_a_kind_of Time
    end

    it 'raises an exception if an payment id is not valid' do
      expect { subject.payment(invoice_id, 'abc123') }.to raise_error Harvest::NotFound
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
      contacts[0].first_name.should == 'Allison'
      contacts.first.should be_a_kind_of Harvest::Person
    end
  end
end
