require 'minitest/autorun'
#require 'kazius-alerts'
require_relative '../lib/kazius-alerts.rb'

class KaziusAlertsTest < MiniTest::Test

  def test_alerts_size
    assert_equal 29, KaziusAlerts::SMARTS.size
  end

  def test_kazius_alerts_prediction
    prediction = KaziusAlerts.predict("c1ccccc1NN")
    assert prediction[:prediction]
    assert_equal [["unsubstituted heteroatom-bonded heteroatom", "[OH,NH2][N,O]", "O=N(O)[O-]"]], prediction[:matches]
  end

end
