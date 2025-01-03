class variable_delay_test extends base_test;

	`uvm_component_utils(variable_delay_test)

	function new (string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		uvm_config_wrapper::set(this,"tb.vsequencer.run_phase", "default_sequence", variable_delay_vsequence::type_id::get());
		super.build_phase(phase);
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		`uvm_info(get_type_name(),"Starting multiport random test",UVM_NONE)
	endtask : run_phase

endclass : variable_delay_test



///////////////////////////// VIRTUAL SEQUENCE ///////////////////////////

class variable_delay_vsequence extends htax_base_vseq;

  `uvm_object_utils(variable_delay_vsequence)

//   htax_packet_c pkt0;
//   htax_packet_c pkt1;
//   htax_packet_c pkt2;
//   htax_packet_c pkt3;

  function new (string name = "variable_delay_vsequence");
    super.new(name);
  endfunction : new

  task body();
    repeat(500) begin
        int i = $urandom_range(0,3);
        `uvm_do_on_with(req, p_sequencer.htax_seqr[i],{
            delay inside {[1:20]};
        })
    end
  endtask : body

endclass : variable_delay_vsequence


