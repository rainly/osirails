class Machine < Tool
  has_documents :legal_paper, :invoice, :manual, :other
end