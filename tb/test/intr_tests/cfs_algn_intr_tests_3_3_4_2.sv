
///////////////////////////////////////////////////////////////////////////////
// File:        cfs_algn_intr_tests_3_3_4.sv
// Author:      Dhanwanth
// Date:        2025-06-23
// Description: TX_FIFO_FULL is asserted when the FIFO fills up completely
// ///////////////////////////////////////////////////////////////////////////////
`ifndef CFS_ALGN_INTR_TESTS_3_3_4_2_SV
`define CFS_ALGN_INTR_TESTS_3_3_4_2_SV

class cfs_algn_intr_tests_3_3_4_2 extends cfs_algn_test_base;

  `uvm_component_utils(cfs_algn_intr_tests_3_3_4_2)

  function new(string name = "", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual task run_phase(uvm_phase phase);
    cfs_md_sequence_slave_response_forever resp_seq;
    cfs_algn_virtual_sequence_3_1_3 cfg_seq;
    cfs_algn_virtual_sequence_rx_crt rx_seq;
    // cfs_algn_virtual_sequence_rx_err rx_err_seq2;
    cfs_algn_vif vif;

    uvm_reg_data_t reg_val;
    uvm_status_e status;
    uvm_reg_field irq_fields[$];

    phase.raise_objection(this, "TEST_START");

    #(100ns);

    // Fork forever slave responder
    fork
      begin
        cfs_md_sequence_tx_ready_block tx_block_seq = cfs_md_sequence_tx_ready_block::type_id::create(
            "tx_block_seq"
        );
        tx_block_seq.start(env.md_tx_agent.sequencer);
      end
    join_none

    // SIZE 0, OFFSET 0–3 → All invalid
    env.model.reg_block.CTRL.write(status, 32'h00000000, UVM_FRONTDOOR);
    env.model.reg_block.CTRL.write(status, 32'h00000100, UVM_FRONTDOOR);
    env.model.reg_block.CTRL.write(status, 32'h00000200, UVM_FRONTDOOR);
    env.model.reg_block.CTRL.write(status, 32'h00000300, UVM_FRONTDOOR);

    // SIZE 1, OFFSET 0–3 → Valid, skip

    // SIZE 2, OFFSET 1 and 3 are invalid
    env.model.reg_block.CTRL.write(status, 32'h00000201, UVM_FRONTDOOR);  // SIZE=2, OFFSET=1
    env.model.reg_block.CTRL.write(status, 32'h00000302, UVM_FRONTDOOR);  // SIZE=2, OFFSET=3

    // SIZE 3, OFFSET 0–3 → All invalid
    env.model.reg_block.CTRL.write(status, 32'h00000003, UVM_FRONTDOOR);
    env.model.reg_block.CTRL.write(status, 32'h00000103, UVM_FRONTDOOR);
    env.model.reg_block.CTRL.write(status, 32'h00000203, UVM_FRONTDOOR);
    env.model.reg_block.CTRL.write(status, 32'h00000303, UVM_FRONTDOOR);

    // SIZE 4, OFFSET 1–3 → invalid
    env.model.reg_block.CTRL.write(status, 32'h00000104, UVM_FRONTDOOR);
    env.model.reg_block.CTRL.write(status, 32'h00000204, UVM_FRONTDOOR);
    env.model.reg_block.CTRL.write(status, 32'h00000304, UVM_FRONTDOOR);

    // SIZE 5, OFFSET 0–3 → invalid
    env.model.reg_block.CTRL.write(status, 32'h00000005, UVM_FRONTDOOR);
    env.model.reg_block.CTRL.write(status, 32'h00000105, UVM_FRONTDOOR);
    env.model.reg_block.CTRL.write(status, 32'h00000205, UVM_FRONTDOOR);
    env.model.reg_block.CTRL.write(status, 32'h00000305, UVM_FRONTDOOR);

    // SIZE 6, OFFSET 0–3 → invalid
    env.model.reg_block.CTRL.write(status, 32'h00000006, UVM_FRONTDOOR);
    env.model.reg_block.CTRL.write(status, 32'h00000106, UVM_FRONTDOOR);
    env.model.reg_block.CTRL.write(status, 32'h00000206, UVM_FRONTDOOR);
    env.model.reg_block.CTRL.write(status, 32'h00000306, UVM_FRONTDOOR);

    // SIZE 7, OFFSET 0–3 → invalid
    env.model.reg_block.CTRL.write(status, 32'h00000007, UVM_FRONTDOOR);
    env.model.reg_block.CTRL.write(status, 32'h00000107, UVM_FRONTDOOR);
    env.model.reg_block.CTRL.write(status, 32'h00000207, UVM_FRONTDOOR);
    env.model.reg_block.CTRL.write(status, 32'h00000307, UVM_FRONTDOOR);
    #(200ns);

    cfg_seq = cfs_algn_virtual_sequence_3_1_3::type_id::create("cfg_seq");
    cfg_seq.set_sequencer(env.virtual_sequencer);
    cfg_seq.start(env.virtual_sequencer);

    // Step 2: Wait a bit before sending traffic
    vif = env.env_config.get_vif();
    repeat (50) @(posedge vif.clk);

    env.model.reg_block.IRQEN.write(status, 32'h00000000, UVM_FRONTDOOR);
    // //env.model.reg_block.IRQEN.read(status, reg_val, UVM_FRONTDOOR);
    //
    env.model.reg_block.CTRL.write(status, 32'h00000001, UVM_FRONTDOOR);
    //env.model.reg_block.CTRL.read(status, reg_val, UVM_FRONTDOOR);
    //
    #(50ns);


    for (int i = 0; i < 9; i++) begin
      rx_seq = cfs_algn_virtual_sequence_rx_crt::type_id::create($sformatf("rx_seq_%0d", i));
      rx_seq.set_sequencer(env.virtual_sequencer);
      void'(rx_seq.randomize());
      rx_seq.start(env.virtual_sequencer);

      env.model.reg_block.STATUS.read(status, reg_val, UVM_FRONTDOOR);
    end

    env.model.reg_block.STATUS.read(status, reg_val, UVM_FRONTDOOR);

    env.model.reg_block.IRQ.read(status, reg_val, UVM_FRONTDOOR);

    env.model.reg_block.STATUS.read(status, reg_val, UVM_FRONTDOOR);
    //
    // fork
    //   begin : temp_ready_assert
    //     resp_seq = cfs_md_sequence_slave_response_forever::type_id::create("resp_seq");
    //     resp_seq.start(env.md_tx_agent.sequencer);
    //   end
    // join_none
    //
    // repeat (5) @(posedge vif.clk);
    //
    // disable temp_ready_assert;
    //
    // fork
    //   begin : ready_deassert
    //     cfs_md_sequence_tx_ready_block tx_block_seq = cfs_md_sequence_tx_ready_block::type_id::create(
    //         "tx_block_seq"
    //     );
    //     tx_block_seq.start(env.md_tx_agent.sequencer);
    //   end
    // join_none
    //
    // #(500ns);
    //
    // for (int i = 0; i < 4; i++) begin
    //   rx_seq = cfs_algn_virtual_sequence_rx_crt1::type_id::create($sformatf("rx_seq_%0d", i));
    //   rx_seq.set_sequencer(env.virtual_sequencer);
    //   void'(rx_seq.randomize());
    //   rx_seq.start(env.virtual_sequencer);
    // end


    env.model.reg_block.IRQ.write(status, 32'h00000000, UVM_FRONTDOOR);
    env.model.reg_block.IRQ.write(status, 32'h0000001f, UVM_FRONTDOOR);
    phase.drop_objection(this, "TEST_DONE");
  endtask

endclass

`endif
