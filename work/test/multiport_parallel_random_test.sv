///////////////////////////////////////////////////////////////////////////
// Texas A&M University
// CSCE 616 Hardware Design Verification
// Created by  : Prof. Quinn and Saumil Gogri
///////////////////////////////////////////////////////////////////////////


class multiport_parallel_random_test extends base_test;

	`uvm_component_utils(multiport_parallel_random_test)

	function new (string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		uvm_config_wrapper::set(this,"tb.vsequencer.run_phase", "default_sequence", parallel_random_vsequence::type_id::get());
		super.build_phase(phase);
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		`uvm_info(get_type_name(),"Starting multiport random test",UVM_NONE)
	endtask : run_phase

endclass : multiport_parallel_random_test


class parallel_random_vsequence extends htax_base_vseq;

  `uvm_object_utils(parallel_random_vsequence)

  htax_packet_c pkt0;
  htax_packet_c pkt1;
  htax_packet_c pkt2;
  htax_packet_c pkt3;

  function new (string name = "parallel_random_vsequence");
    super.new(name);
    pkt0 = htax_packet_c::type_id::create("pkt0");
    pkt1 = htax_packet_c::type_id::create("pkt1");
    pkt2 = htax_packet_c::type_id::create("pkt2");
    pkt3 = htax_packet_c::type_id::create("pkt3");
  endfunction : new

  // Helper function to generate a random permutation
  function void get_random_permutation(ref int ports[$]);
    int temp, rand_idx;
    for (int i = ports.size()-1; i > 0; i--) begin
      rand_idx = $urandom_range(0, i);
      temp = ports[i];
      ports[i] = ports[rand_idx];
      ports[rand_idx] = temp;
    end
  endfunction : get_random_permutation

  task body();
    int ports[$] = '{0, 1, 2, 3}; // Array of port indices

    repeat(200) begin
      get_random_permutation(ports); // Generate a random permutation of ports

      fork
        `uvm_do_on_with(pkt0, p_sequencer.htax_seqr[0], {
          pkt0.dest_port == ports[0];
          pkt0.length inside {[3:10]};
          pkt0.delay < 10;
        })

        `uvm_do_on_with(pkt1, p_sequencer.htax_seqr[1], {
          pkt1.dest_port == ports[1];
          pkt1.length inside {[3:10]};
          pkt1.delay < 10;
        })

        `uvm_do_on_with(pkt2, p_sequencer.htax_seqr[2], {
          pkt2.dest_port == ports[2];
          pkt2.length inside {[3:10]};
          pkt2.delay < 10;
        })

        `uvm_do_on_with(pkt3, p_sequencer.htax_seqr[3], {
          pkt3.dest_port == ports[3];
          pkt3.length inside {[3:10]};
          pkt3.delay < 10;
        })
      join
    end
  endtask : body

endclass : parallel_random_vsequence


