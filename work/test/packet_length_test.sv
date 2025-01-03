class packet_length_test extends base_test;

	`uvm_component_utils(packet_length_test)

	function new (string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		uvm_config_wrapper::set(this,"tb.vsequencer.run_phase", "default_sequence", packet_length_vsequence::type_id::get());
		super.build_phase(phase);
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		`uvm_info(get_type_name(),"Starting multiport random test",UVM_NONE)
	endtask : run_phase

endclass : packet_length_test



///////////////////////////// VIRTUAL SEQUENCE ///////////////////////////

class packet_length_vsequence extends htax_base_vseq;

  `uvm_object_utils(packet_length_vsequence)

    htax_packet_c pkt0;
    htax_packet_c pkt1;
    htax_packet_c pkt2;
    htax_packet_c pkt3;

  function new (string name = "packet_length_vsequence");
    super.new(name);
    pkt0 = htax_packet_c::type_id::create("pkt0");
    pkt1 = htax_packet_c::type_id::create("pkt1");
    pkt2 = htax_packet_c::type_id::create("pkt2");
    pkt3 = htax_packet_c::type_id::create("pkt3");
  endfunction : new

  task body();
    repeat(500) begin
        // int i = $urandom_range(0,3);
        fork
            
            `uvm_do_on_with(pkt0, p_sequencer.htax_seqr[0],{
            length inside {[3:63]};
            })

            `uvm_do_on_with(pkt1, p_sequencer.htax_seqr[1],{
            length inside {[3:63]};
            })

            `uvm_do_on_with(pkt2, p_sequencer.htax_seqr[2],{
            length inside {[3:63]};
            })

            `uvm_do_on_with(pkt3, p_sequencer.htax_seqr[3],{
            length inside {[3:63]};
            })

        join
        
    end
  endtask : body

endclass : packet_length_vsequence


