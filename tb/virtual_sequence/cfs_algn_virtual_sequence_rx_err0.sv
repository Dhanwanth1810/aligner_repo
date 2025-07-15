///////////////////////////////////////////////////////////////////////////////
// File:        cfs_algn_virtual_sequence_rx_err0.sv
// Author:      Cristian Florin Slav
// Date:        2025-02-12
// Description: Virtual sequence which sends only one MD RX transaction and 
//              constraints the MD transaction to always be illegal.
///////////////////////////////////////////////////////////////////////////////

`ifndef CFS_ALGN_VIRTUAL_SEQUENCE_RX_ERR0_SV
`define CFS_ALGN_VIRTUAL_SEQUENCE_RX_ERR0_SV

class cfs_algn_virtual_sequence_rx_err0 extends cfs_algn_virtual_sequence_rx;

  //Aligner data width
  local int unsigned algn_data_width;

  constraint legal_rx_hard {seq.item.data.size() == 0;}

  `uvm_object_utils(cfs_algn_virtual_sequence_rx_err0)

  function new(string name = "");
    super.new(name);
  endfunction

  function void pre_randomize();
    super.pre_randomize();

    algn_data_width = p_sequencer.model.env_config.get_algn_data_width();
  endfunction

endclass

`endif
