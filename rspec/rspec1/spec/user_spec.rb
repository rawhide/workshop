require 'spec_helper'

RSpec.describe User do
  let(:user) { User.new(name: 'bob', birthday: Date.new(1986, 5, 2), nationality: nationality) }
  let(:nationality) { :ja }

  describe '#age' do
    subject { user.age }

    it { expect(subject).to eq(28) }
  end

  describe '#greet' do
    subject { user.greet }

    context 'nationality が ja の場合' do
      it { expect(subject).to eq('こんにちは') }
    end

    context 'nationality が en の場合' do
      let(:nationality) { :en }

      it { expect(subject).to eq('Hello!') }
    end

    context 'nationality が ja, en 以外の場合' do
      let(:nationality) { :hoge }

      it { expect(subject).to eq('...') }
    end
  end

  describe '#describe' do
    subject { user.describe }

    before do
      expect(user).to receive(:age).and_return(99)
      expect(user).to receive(:likes).and_return(['サッカー観戦', '盆栽'])
    end

    it { expect(subject).to eq("私の名前は bob です。年齢は 99 歳で、趣味は サッカー観戦, 盆栽 です。") }
  end
end
