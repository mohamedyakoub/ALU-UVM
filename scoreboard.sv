class scoreboard extends uvm_scoreboard;
    `uvm_component_utils(scoreboard)

    int no_trans,correct,incorrect;
    bit corr_tran;
    bit [5:0] C_delay_0,C_golden;
    uvm_analysis_imp#(seq_item,scoreboard) sb_mb;
    seq_item item;
    seq_item item_q [$];
    

    function new(string name="scoreboard", uvm_component parent=null);
        super.new(name, parent);
        sb_mb=new("sb_mb",this);
    endfunction

    function  void build_phase(uvm_phase phase);
    super.build_phase(phase);
    endfunction

    virtual function  write(seq_item item);
        `uvm_info("Scoreboard", "Packet recieved", UVM_HIGH)
        item_q.push_back(item);
        //item.print();
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            wait(item_q.size()>0);
            item=item_q.pop_front();
            m_check(item);
        end
    endtask


    task m_check(seq_item tr);
            if(!tr.rst_n) begin   

                if(tr.C==0) begin
                    // $display("Scoreboard:: Reset is successful");
                    corr_tran=1;
                end
                else begin
                    $display("Scoreboard:: Reset is not successful");
                    corr_tran=0;
                end

            end
            else begin

                golden(tr.A,tr.B,tr.a_en,tr.b_en,tr.a_op,tr.b_op,C_golden,C_delay_0);
                if(tr.C==C_golden)     corr_tran=1;
                else                    corr_tran=0;

            end   

            if(corr_tran) begin
            //   $display("Scoreboard:: %0t: Transaction no.%0d is correct",$time(),no_trans);
                correct++;
            end
            else begin
                $display("Scoreboard:: %0t: Transaction no.%0d is incorrect",$time(),no_trans);
                $display("Output Expected is %0b , Actual Output is %0b  , opa is %0b , opb is %0b , a_en is %0b    b_en is %0b , c_delay is %b ",C_golden,tr.C,tr.a_op,tr.b_op ,tr.a_en,tr.b_en,C_delay_0);
                incorrect++;
            end

            C_delay_0=tr.C;
            no_trans++;
    endtask

    function display();
        $display("/////////////////////////////  Summary of run  \\\\\\\\\\\\\\\\\\\\\\\\\\\\");
        $display("Scoreboard:: Total number of Enabled transaction is %0d ",no_trans);
        $display("Scoreboard:: Correct transactions : %0d  , Incorrect transactions : %0d  .",correct,incorrect);
        $display("///////////////////////////////////////////////////////////////////////////");
    endfunction


    /////////////////////////////////////////////////////////////////////////////
    task golden;
        input bit signed [4:0] A,B;
        input bit a_en,b_en;
        input bit [2:0] a_op,b_op;
        output bit [5:0] C;
        input bit [5:0] C_delay_0;
        
        if(a_en && !b_en)
            case (a_op)
                3'd0: C= A+B;
                3'd1: C= A-B;
                3'd2: C= A^B;
                3'd3: C= A&B;
                3'd4: C= A&B;
                3'd5: C= A|B;
                3'd6: C= A~^B;
                default: C='hFF; 
            endcase
        else if(!a_en && b_en)
            case (b_op)
                2'd0: C= ~(A & B);
                2'd1: C= A+B;
                2'd2: C= A+B;
                default: C='hFF; 
            endcase
        else if(a_en && b_en)
            case (b_op)
                2'd0: C= A^B;
                2'd1: C= A~^B;
                2'd2: C= A-1;
                2'd3: C= B+2;
            endcase
        else
            C=C_delay_0;

    endtask 
    /////////////////////////////////////////////////////////////////////////////////
endclass


