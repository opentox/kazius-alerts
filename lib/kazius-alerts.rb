require 'openbabel'

class KaziusAlerts

  SMARTS = [ # name, smarts, excluded smarts
    ["specific arom nitro", 'O=N(~O)a', 'O=N(O)c[$(aS(=O)=O),$(aaS(=O)=O),$(aaaS(=O)=O),$(aC((F)F)F),$(aaC((F)F)F),$(aaaC((F)F)F)]'],
    ["specific arom amine", 'a[NH2]', '[NH2]a[$(a[$(C((F)F)F),$(S(=O)=O),$(C(=O)O)]),$(aa[$(C((F)F)F),$(S(=O)=O),$(C(=O)O)]),$(aaa[$(C((F)F)F),$(S(=O)=O),$(C(=O)O)])]'],
    ["aromatic nitroso", 'a[N;X2]=O'],
    ["alkyl nitrite", 'CO[N;X2]=O'],
    ["nitrosamine", 'N[N;X2]=O'],
    ["epoxide", 'O1[c,C]-[c,C]1'],
    ["aziridine", 'C1NC1'],
    ["azide", 'N=[N+]=[N-]'],
    ["diazo", 'C=[N+]=[N-]'],
    ["triazene", 'N=N-N'],
    ["aromatic azo", 'c[N;X2]!@;=[N,X2]c', '[$([N;X2]([$(acS((=O)=O)),$(aacS((=O)=O)),$(aaacS((=O)=O)),$(aaaacS((=O)=O))])=[N;X2][$(acS((=O)=O)),$(aacS((=O)=O)),$(aaacS((=O)=O)),$(aaaacS((=O)=O))])]'],
    ["unsubstituted heteroatom-bonded heteroatom", '[OH,NH2][N,O]', 'O=N(O)[O-]'],
    ["aromatic", '[OH]Na'],
    ["aliphatic halide", '[Cl,Br,I]C'],
    ["carboxylic acid halide", '[Cl,Br,I]C=O'],
    ["nitrogen or sulphur mustard", '[N,S]!@[C;X4]!@[CH2][Cl,Br,I]'],
    ["bay region in PAHs", '[cH]1[cH]ccc2c1c3c(cc2)cc[cH][cH]3'],
    ["k-region in PAHs", '[cH]1cccc2c1[cH][cH]c3c2ccc[cH]3'],
    ["polycyclic aromatic system", '[$(a13~a~a~a~a2~a1~a(~a~a~a3)~a~a~a2),$(a1~a~a~a2~a1~a~a3~a(~a2)~a~a~a3),$(a1~a~a~a2~a1~a~a~a3~a2~a~a~a3),$(a1~a~a~a~a2~a1~a3~a(~a2)~a~a~a~a3),$(a1~a~a~a~a2~a1~a~a3~a(~a2)~a~a~a3),$(a1~a~a~a~a2~a1~a~a3~a(~a2)~a~a~a~a3),$(a1~a~a~a~a2~a1~a~a~a3~a2~a~a~a3),$(a1~a~a~a~a2~a1~a~a~a3~a2~a~a~a~a3),$(a13~a~a~a~a2~a1~a(~a~a~a3)~a~a2)]'], # smarts error of original smarts fixed
    ["sulphonate bonded carbon", '[$([C,c]OS((=O)=O)O!@[c,C]),$([c,C]S((=O)=O)O!@[c,C])]'],
    ["aliphatic N-nitro", 'O=N(~O)N'],
    ["alpha,beta unsaturated aldehyde", '[$(O=[CH]C=C),$(O=[CH]C=O)]', '[$(O=[CH]C([N,O,S])=C),$(O=[CH]C=C[N,O,S]),$(O=[CH]C=Ca)]'],
    ["diazonium", '[N;v4]#N'],
    ["beta-propriolactone", 'O=C1CCO1'],
    ["alpha,beta unsaturated alkoxy group", '[CH]=[CH]O'],
    ["1-aryl-2-monoalkyl hydrazine", '[NH;!R][NH;!R]a'],
    ["aromatic methylamine", '[CH3][NH]a', '[CH3][NH]a[$(a[$(C((F)F)F),$(S=O),$(C(=O)O)]),$(aa[$(C((F)F)F),$(S=O),$(C(=O)O)]),$(aaa[$(C((F)F)F),$(S=O),$(C(=O)O)])]'],
    ["ester derivative of aromatic hydroxylamine", 'aN([$([OH]),$(O*=O)])[$([#1]),$(C(=O)[CH3]),$([CH3]),$([OH]),$(O*=O)]'],
    ["polycyclic planar system", '[$([X2,X3]13~[X2,X3]~[X2,X3]~[X2,X3]~[X2,X3]2~[X2,X3]1~[X2,X3](~[X2,X3]~[X2,X3]~[X2,X3]3)~[X2,X3]~[X2,X3]~[X2,X3]2),$([X2,X3]1~[X2,X3]~[X2,X3]~[X2,X3]2~[X2,X3]1~[X2,X3]~[X2,X3]3~[X2,X3](~[X2,X3]2)~[X2,X3]~[X2,X3]~[X2,X3]3),$([X2,X3]1~[X2,X3]~[X2,X3]~[X2,X3]2~[X2,X3]1~[X2,X3]~[X2,X3]~[X2,X3]3~[X2,X3]2~[X2,X3]~[X2,X3]~[X2,X3]3),$([X2,X3]1~[X2,X3]~[X2,X3]~[X2,X3]~[X2,X3]2~[X2,X3]1~[X2,X3]3~[X2,X3](~[X2,X3]2)~[X2,X3]~[X2,X3]~[X2,X3]~[X2,X3]3),$([X2,X3]1~[X2,X3]~[X2,X3]~[X2,X3]~[X2,X3]2~[X2,X3]1~[X2,X3]~[X2,X3]3~[X2,X3](~[X2,X3]2)~[X2,X3]~[X2,X3]~[X2,X3]3),$([X2,X3]1~[X2,X3]~[X2,X3]~[X2,X3]~[X2,X3]2~[X2,X3]1~[X2,X3]~[X2,X3]3~[X2,X3](~[X2,X3]2)~[X2,X3]~[X2,X3]~[X2,X3]~[X2,X3]3),$([X2,X3]1~[X2,X3]~[X2,X3]~[X2,X3]~[X2,X3]2~[X2,X3]1~[X2,X3]~[X2,X3]~[X2,X3]3~[X2,X3]2~[X2,X3]~[X2,X3]~[X2,X3]3),$([X2,X3]1~[X2,X3]~[X2,X3]~[X2,X3]~[X2,X3]2~[X2,X3]1~[X2,X3]~[X2,X3]~[X2,X3]3~[X2,X3]2~[X2,X3]~[X2,X3]~[X2,X3]~[X2,X3]3),$([X2,X3]13~[X2,X3]~[X2,X3]~[X2,X3]~[X2,X3]2~[X2,X3]1~[X2,X3](~[X2,X3]~[X2,X3]~[X2,X3]3)~[X2,X3]~[X2,X3]2)]', '[S]1-*~*-[N,O,S]-*~*-1'] # smarts error of original smarts fixed
  ]

  CONFIDENCES = {
    "specific arom nitro" => 0.81,
    "specific arom amine" => 0.79,
    "nitrosamine" => 0.90,
    "epoxide" => 0.85,
    "aliphatic halide" => 0.79,
    "polycyclic aromatic system" => 0.90,
    "other SAs" => 0.81
  }

  def self.predict smiles
    smi2mol = OpenBabel::OBConversion.new
    smi2mol.set_in_format("smi")
    mol = OpenBabel::OBMol.new
    smi2mol.read_string(mol, smiles)

    matches = []
    prediction = false
    error_product = 1

    smarts_pattern = OpenBabel::OBSmartsPattern.new
    SMARTS.each do |sma|
      if sma[2]
        smarts_pattern.init sma[1]
        if smarts_pattern.match(mol)
          smarts_pattern.init sma[2]
          matches << sma if !smarts_pattern.match(mol)
        end
      else
        smarts_pattern.init sma[1]
        matches << sma if smarts_pattern.match(mol)
      end
    end

    matches.each { |m| error_product *= error(m) }

    prediction = true if matches.size > 0
    {:prediction => prediction, :error_product => error_product, :matches => matches}
  end

  def self.error(alert)
    if CONFIDENCES[alert[0]]
      return 1 - CONFIDENCES[alert[0]]
    else
      return 1 - CONFIDENCES["other SAs"]
    end
  end

end
