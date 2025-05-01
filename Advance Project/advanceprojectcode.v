//part 1: alu
module alu (opcode, a, b, result );
input  [5:0] opcode; 
input signed [31:0] a, b; 
output reg [31:0] result; 
always@(*)
	begin
		case(opcode)
			6'b001000 : result = a+b; //ADD
			6'b001001 : result = a-b;//SUB
			6'b000010 :begin
                       case (a < 0)
                          1: result =-a;
                          0: result = a;//ABS
                       endcase
					   end
			6'b001010 : result = -a;//NEGTIVE
			6'b001100 :begin
			             if (a > b)
				            result=a ;//MAX	
			             else 
				            result= b;
			            end 
			6'b000001 :begin
			             if (a < b)
				            result =a ;	//MIN
			             else 
				            result= b;
			             end 
			6'b001101 :begin
			           result =(a+b)/(2) ; //AVG
					 end 
			6'b000101 : result = ~(a); //NOT
			6'b000100 : result = a | b ; //OR
			6'b001011 : result = a & b;	 //AND
			6'b001111 : result = a ^ b; //XOR 
			default: result = 0; 
		endcase
	end 
endmodule	


// part 1 : register file 
module regfile (clk, valid_opcode, addr1, addr2, addr3, in , out1, out2);
input clk;
input valid_opcode;
input [4:0] addr1, addr2, addr3; 
input [31:0] in; 
output reg [31:0] out1, out2;
reg [31:0] MyMeMory [0:31]= '{32'h0 ,32'h3162,32'h2960,32'h1856,32'h22EC,32'h2248,32'h24DC,32'hBF0,32'h12F2,32'hD4E,32'h305C,32'h224,32'h32FE,32'hAF0,
                         32'h32BC,32'h3BC,32'h892,32'h2E8A,32'h3DF8,32'h3E38,32'h303A,32'h890,32'h730,32'h36AC,32'h2F16,32'h1152,32'h2F78,32'h2694,
                         32'h221E,32'h2074,32'hD5E,32'h0};

  always @ (posedge clk)
	  begin
	
      if ( valid_opcode) 
		begin
          out1 <= MyMeMory[addr1];//read 
          out2 <= MyMeMory[addr2];//read
          MyMeMory[addr3] <= in; //write 
    end
	end
	

endmodule




//module for dff 
module DFF (clk,D1,Q1);
  input  clk;
  input [5:0] D1;
  output reg [5:0] Q1;
  always @(posedge clk ) begin
    
      Q1 = D1;    
  end
endmodule 

//part 2: module for Microprocessor 
module mp_top(clk, instruction, result);
  input clk;
  input [31:0] instruction;
  output reg [31:0] result;
  // division fields for the instruction starting from LSB
  wire [5:0] opcode = instruction[5:0];
  wire [4:0] readfirstvalue = instruction[10:6];
  wire [4:0] readsecondvalue = instruction[15:11];
  wire [4:0] writetheresult = instruction[20:16];
  wire [10:0] unused = instruction[31:21];

  wire valid_opcode = (opcode != 6'b000000); // valid opcode 
  //here i add a delay for the opcode by using dff 
  reg [5:0]opcode2;
  DFF mydff(.clk(clk),.D1(opcode),.Q1(opcode2));
  	   
  // get instance from regfile and alu and connect them 
  regfile Myregfile(.clk(clk), .valid_opcode(valid_opcode), .addr1(readfirstvalue), .addr2(readsecondvalue), .addr3(writetheresult), .in(0), .out1(), .out2());
  alu Myalu(.opcode(opcode2), .a(Myregfile.out1), .b(Myregfile.out2), .result(result)); 
  // unused bits
  assign unused = 11'b0;
endmodule  


 
 // test bench 1 
module MyTestBench1;
  reg clk;
  reg [31:0] instruction;
  wire [31:0] result;
  // get instance of  mp_top module and connect it 
  mp_top  MyMpTop(.clk(clk),.instruction(instruction),.result(result));
  
  // creat an array of instructions
  reg [31:0] instructions [0:12];
  integer i;//varible uses in for loop to excut the instructions
  integer count=0;//varible uses to count the number of tests fails 
  initial begin
    clk = 0;//clock generation
    // here the instructions for each opcode to test  
    instructions[1] = 32'b00000000000000010001000011001000; // ADD (R1=R3+R2)
    instructions[2] = 32'b00000000000000010001000011001001; // SUB (R1=R3-R2)					 
    instructions[3] = 32'b00000000000000010001000011000010; // ABS (R1=|R3|) 
	instructions[4] = 32'b00000000000000010001000011001010; // NEG (R1= -R3)
    instructions[5] = 32'b00000000000000010001000011001100; // MAX (R1=max(R3,R2))
    instructions[6]= 32'b00000000000000010001000011000001; // MIN (R1= min(R3,R2))
    instructions[7]= 32'b00000000000000010001000011001101; // AVG (R1= avg(R3,R2))
    instructions[8]= 32'b00000000000000010001000011000101; // NOT (R1= ~R3)
    instructions[9]= 32'b00000000000000010001000011000100; // OR  (R1=R3 or R2)
    instructions[10]= 32'b00000000000000010001000011001011; // AND (R1=R3 and R2)
    instructions[11]= 32'b00000000000000010001000011001111; // XOR (R1=R3 xor R2)
	
    // loop starts to excut the instructions 
    for (i = 0; i < 12; i = i + 1) begin 
      instruction = instructions[i];
      #10ns; // Wait for a few clock cycles
	  #5 clk = ~clk;
	  //case stetment to compare the result with the expected value
	case(instruction)
		32'h000110c8: if(result!=32'h000041b6)begin //if statment to compare  opcode (a+b)
			count= count+1;//add 1 to count 
			end
		32'h000110c9 : if(result!=32'hffffeef6) begin//if statment to compare  opcode(a-b)
			count= count+1;
			end
		 32'h000110c2: if(result!=32'h00001856)begin//if statment to compare  opcode(|a|)
			count= count+1;	
			end
		 32'h000110ca: if(result!=32'hffffe7aa)begin//if statment to compare opcode(-a)
			count= count+1;
			end
		 32'h000110cc: if(result!=32'h00002960)begin//if statment to compare opcode(max)
			count= count+1;	
		 end
		32'h000110c1: if(result!=32'h00001856)begin	//if statment to compare  opcode(min)
			count= count+1;
		end
		32'h000110cd: if(result!=32'h000020db)begin	//if statment to compare  opcode(avg)
			
			count= count+1;
		end
		32'h000110c5: if(result!=32'hffffe7a9)begin//if statment to compare  opcode(not)
			count= count+1;
		 end
		 32'h000110c4: if(result!=32'h00003976)begin//if statment to compare  opcode(or)
			count= count+1;
		 end
		 32'h000110cb: if(result!=32'h00000840)begin//if statment to compare  opcode(and)
			count= count+1;	
		 end
		 32'h000110cf: if(result!=32'h00003136)begin //if statment to compare  opcode(xor)  
			count= count+1;
		 end	 
		 
	endcase	
	 // display results
      $display("Test Number %0d - Instruction Format: %h,  Result: %h", i, instruction, result);
	  end
	  
	// if statment to check if the count > 0
	if(count > 0) begin	
    $display("Test fail in %0d tests ",count);// if count >0 then print test faild 		   
	     end
  else	  
	  begin
		  
	  $display("All Tests passed");//if count still 0 then print all the tasts passed 
	  end	
	  
	  
  end
endmodule


// tests bench 2 to test and display all the cases 
module MyTestBench2;
  reg clk;
  reg [31:0] instruction;
  wire [31:0] result;
  // get instance of  mp_top module and connect it 
  mp_top  MyMpTop(.clk(clk),.instruction(instruction),.result(result));
  
  // creat an array of instructions
  reg [31:0] instructions [0:23];
  integer i;//varible uses in for loop to excut the instructions
  integer count=0;//varible uses to count the number of tests fails 
  initial begin
    clk = 0;//clock generation
    // here the instructions for each opcode to test  
    instructions[1] = 32'b00000000000000010001000011001000; // ADD (R1=R3+R2)
	instructions[2] = 32'b00000000000000010001000011001000; // instruction add to test all cases
    instructions[3] = 32'b00000000000000010001000011001001; // SUB (R1=R3-R2)
	instructions[4] = 32'b00000000000000010001000011001001; // instruction add to test all cases
    instructions[5] = 32'b00000000000000010001000011000010; // ABS (R1=|R3|)
	instructions[6] = 32'b00000000000000010001000011000010; // instruction add to test all cases 
	instructions[7] = 32'b00000000000000010001000011001010; // NEG (R1= -R3)
	instructions[8] = 32'b00000000000000010001000011001010; // instruction add to test all cases
    instructions[9] = 32'b00000000000000010001000011001100; // MAX (R1=max(R3,R2))
	instructions[10]= 32'b00000000000000010001000011001100; // instruction add to test all cases 
    instructions[11]= 32'b00000000000000010001000011000001; // MIN (R1= min(R3,R2))
	instructions[12]= 32'b00000000000000010001000011000001; // instruction add to test all cases
    instructions[13]= 32'b00000000000000010001000011001101; // AVG (R1= avg(R3,R2))
	instructions[14]= 32'b00000000000000010001000011001101; // instruction add to test all cases
    instructions[15]= 32'b00000000000000010001000011000101; // NOT (R1= ~R3)
	instructions[16]= 32'b00000000000000010001000011000101; // instruction add to test all cases
    instructions[17]= 32'b00000000000000010001000011000100; // OR  (R1=R3 or R2)
	instructions[18]= 32'b00000000000000010001000011000100; // instruction add to test all cases
    instructions[19]= 32'b00000000000000010001000011001011; // AND (R1=R3 and R2)
	instructions[20]= 32'b00000000000000010001000011001011; // instruction add to test all cases
    instructions[21]= 32'b00000000000000010001000011001111; // XOR (R1=R3 xor R2)
	instructions[22]= 32'b00000000000000010001000011001111; // instruction add to test all cases
    // loop starts to excut the instructions 
    for (i = 0; i < 23; i = i + 1) begin 
      instruction = instructions[i];
      #10ns; // Wait for a few clock cycles
	  #5 clk = ~clk;
	  //case stetment to compare the result with the expected value
	case(instruction)
		32'h000110c8: if(result!=32'h000041b6)begin //if statment to compare  opcode (a+b)
			count= count+1;//add 1 to count 
			end
		32'h000110c9 : if(result!=32'hffffeef6) begin//if statment to compare  opcode(a-b)
			count= count+1;
			end
		 32'h000110c2: if(result!=32'h00001856)begin//if statment to compare  opcode(|a|)
			count= count+1;	
			end
		 32'h000110ca: if(result!=32'hffffe7aa)begin//if statment to compare opcode(-a)
			count= count+1;
			end
		 32'h000110cc: if(result!=32'h00002960)begin//if statment to compare opcode(max)
			count= count+1;	
		 end
		32'h000110c1: if(result!=32'h00001856)begin	//if statment to compare  opcode(min)
			count= count+1;
		end
		32'h000110cd: if(result!=32'h000020db)begin	//if statment to compare  opcode(avg)
			
			count= count+1;
		end
		32'h000110c5: if(result!=32'hffffe7a9)begin//if statment to compare  opcode(not)
			count= count+1;
		 end
		 32'h000110c4: if(result!=32'h00003976)begin//if statment to compare  opcode(or)
			count= count+1;
		 end
		 32'h000110cb: if(result!=32'h00000840)begin//if statment to compare  opcode(and)
			count= count+1;	
		 end
		 32'h000110cf: if(result!=32'h00003136)begin //if statment to compare  opcode(xor)  
			count= count+1;
		 end	 
		 
	endcase	
	 // display results
      $display("Test Number %0d - Instruction Format: %h,  Result: %h", i, instruction, result);
	  end
	  
	// if statment to check if the count > 0
	if(count > 0) begin	
    $display("Test fail in %0d tests ",count);// if count >0 then print test faild 		   
	     end
  else	  
	  begin
		  
	  $display("All Tests passed");//if count still 0 then print all the tasts passed 
	  end	
	  
	  
  end
endmodule  



































			
					