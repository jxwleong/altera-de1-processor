# Altera DE1 SimpleProcessor (Overview)
Use HDL code to synthesize the General Purpose Microprocessor (GPM). The GPM is broken down into two parts: 
Datapath (DP) and Control Unit (CU). Write the DP and CU code seperately then combined into a top module 
(DP + CU).

## Table of Contents
1.  [Requirements for this repo](#repoReq)
    * [Software Requirement](#softReq)
    * [Hardware Requirement](#hardReq)
    * [Processor Specifications](#proSpec)  
2.  [What is Greatest Common Divisor (GCD)](#whatIsGCD)
    * [GCD Example](#GCDExp)
    * [GCD Application](#GCDApp)
        * [Reducing Fractions](#redFrac)
        * [Find Least Common Multiple (LCM)](#findLCM)
        * [Cryptography](#crypto)
3.  [Instruction Cycle](#instCyc)     
4.  [Important components of the Simple Processor](#importComp)    
5.  [Quartus II Results](#quar2Res)

## <a name="repoReq"></a> Requirements for this repo  

### <a name="softReq"></a> Software Requirements
1. Quartus II
2. Model SIM

### <a name="hardReq"></a>Hardware Requirement
1. Altera DE1 Board

### <a name="proSpec"></a>Processor Specifications  
#### Instruction Sets
![Instruction Sets of GPM](https://github.com/jason9829/AlteraDE1_SimpleProcessor/blob/master/resources/images/Lab%20Manual%20Images/InstructionSet.png)  
Figure 1. Instruction Set for the GPM from [1]. 

<br/>  

Based on Figure 1, there are a total of eight instructions for this GCD processor. The 8-bit instruction is encoded into two parts, `bit 7 to 5 (3-bit)` indicates the actual instruction that will determine the state and `bit 4 to 0 (5-bit)` indicates the memory location of the RAM. The desription of each instructions are shown below. <br/>

**1. LOAD A**   
This instruction will load the content of memory location aaaaa (encoded with the instruction) into the accumulator.

**2. STORE A**  
This instruction will store the data in A (an 8-bit data register) into the memory location aaaaa, whereby aaaaa is encoded within the instruction in the RAM.

**3. ADD A**  
This instruction will add the data in A (an 8-bit data register) with the data in the memory location aaaaa. Then, the result of the addition is stored back into A.

**4. SUB A**  
This instruction will subtract the data in A (an 8-bit data register) with the data in the memory location aaaaa. Then, the result of the subtraction is stored back into A.

**5. IN A**  
This instruction will load A (an 8-bit data register) with the data from INPUT line (external I/Os such as switch in Altera DE1).

**6. JZ**  
This instruction will configure the Program Counter (PC) to the memory address, aaaaa when the value of A is zero so that the PC will executed the instruction at specific memory address instead to sequentially.

**7. JPOS**  
This instruction will configure the Program Counter (PC) to the memory address, aaaaa when the value of A is postive so that the PC will executed the instruction at specific memory address instead to sequentially.

**8. HALT**  
This instruction will halt the execution. This instruction will be executed when the GCD is found.

<br/>


#### Schematic View of the Processor
![Complete Circuit for Processor](https://github.com/jason9829/AlteraDE1_SimpleProcessor/blob/master/resources/images/Lab%20Manual%20Images/CompleteCircuitProcessor.png)  
Figure x. The Complete Circuit for the GCD Processor

<br/>  

The structure of the processor can be broken-down into two sections, Control Unit (CU) and Data Path (DP).

The ***Control Unit (CU)*** is the component that direct the oprations of the processor based on the status signals such as instruction received from datapath. Based on the instruction received, it will send the corresponding control signals to perform the task. It normally control the memory and register (enable read/ write operation or when to load the register).

The ***Data Path (DP)*** consists of a combinations of functional units such as adder, subtractor and memory. It is used to perform data processing based on the control signals received from CU. Besides, it also send the instruction bits and neccesary status signals to help CU to send the correct control signals.


<br/>

#### State Table
![State Table of GPM](https://github.com/jason9829/AlteraDE1_SimpleProcessor/blob/master/resources/images/Lab%20Manual%20Images/StateTable.png)   
Figure 2. State Table for the GPM from [1]. 

<br/>

Figure above shows the state table of the processor. The state table will tells what are the next state based on different input signals and produce the relevant output signals. There are 11 different states for this processor.

<br/>


#### State Diagram
![State Diagram of GPM](https://github.com/jason9829/AlteraDE1_SimpleProcessor/blob/master/resources/images/Lab%20Manual%20Images/StateDiagram.png)   
Figure 3. State Diagram for the GPM from [1]. 

<br/>
  
#### The State Machine in this Processor

**1. START**  
The start state of the processor, it will jump to next state (FETCH) after start up.  

**2. FETCH**  
The instruction register (IR) will fetch the instruction from memory (RAM). At the same time, the value of program
counter is incremented by 1.  

**3. DECODE**  
At this stage, the memory address (encoded in the instruction) was sent in the 32x8 RAM. So that the writing/ reading
process are executed at the correct memory location. Depend on the instruction, there are multiple possible next states.  

**4. LOAD**  
At this state, it will load the data from RAM with memory location set by the instruction to the 8-bit data register (A). After
the instruction is executed, the CPU will go back to start state to wait for new instruction to process.  

**5. STORE**  
At STORE state, it will load the current data in the 8-bit data register (A) to the memory address encoded with the instruction. 

**6. ADD**  
At this state, the adder-subtractor will add the current value at the 8-bit data register with the output data of RAM with
memory address set by the instruction code.  

**7. SUB**  
At this state, the adder-subtractor will minus the current value at the 8-bit data register (A) with the output data of RAM with
memory address set by the instruction code using 2's complement (A + B'').  

**8. INPUT**  
The 8-bit INPUT (from input pin) will be loaded into the 8-bit data register (A). An external pin (ENTER) was used to determine
when the assign data is ready.  

**9. JZ**  
If the data in the 8-bit data register is 0, the address is jump to the specified memory location encoded within the instruction.
In otherwords, the program counter will jump to the specified memory location instead of increment.  

**10. JPOS**   
If the data in the 8-bit data register is positive, the address is jump to the specified memory location encoded within the instruction.
In otherwords, the program counter will jump to the specified memory location instead of increment.  

**11. HALT**    
The processor will be halt when the GCD is find.  

![Datapath of GPM](https://github.com/jason9829/AlteraDE1_SimpleProcessor/blob/master/resources/images/Lab%20Manual%20Images/Datapath.png)   
Figure 4. Datapath for the GPM from [1.]. 

<br/>

## <a name="whatIsGCD"></a> What is Greatest Common Divisor (GCD)?
Greatest Common Divider (GCD) is the largest positive integer that divides two or more integers [2].

## <a name="GCDExp"></a> GCD Example
Example of GCD, the GCD of 8 and 12 is 4. This is because 4 is the largest positive integer that can
divide 8 and 12.


## <a name="GCDApp"></a> GCD Application
#### <a name="redFrac"></a> 1. Reducing Fractions
GCD is useful for reducing fractions. For Example, the GCD of 12 / 24 is **12**. Therefore,  
12 / 24 = (1 * **12**)/(2 * **12**) = 1/2 

#### <a name="findLCM"></a> 2. Find Least Common Multiple (LCM)
As the name implies, LCD means the least common multiple of two or more integers. For example,  

Multiple of 2:	2, **4**, 6, 8, 10, 12  
Multiple of 4:  **4**, 8, 12, 16, 20, 24

The LCM of 2 and 4 is 4.

#### <a name="crypto"></a> 3. Cryptography
GCD is also used in cryptography (requires further exploration).


## <a name="instCyc"></a> Instruction Cycle
The instruction cycle of a processor can be broken down into three stages, fetch, decode and execute.

**1. Fetch**  
This is the first step for instruction cycle. THe CPU fetch some data and instructions from the main
memory and store them it in a temporary memoty areas (register) [4]. 

**2. Decode**  
The next step of the instruction cycle is decode. CPU is designed to understand a specific set of instructions.
The CPU decodes the fetched instruction and proceed to next step [4].

**3. Execute**  
The last stage of the instruction cycle. In this stage, the CPU will process the data based on the instruction.
Once the execute stage is complete, the CPU will begin another instruction cycle [4].  

## <a  name="quar2Res"></a> Quartus II Results  

![Top RTL view of processor](https://github.com/jason9829/AlteraDE1_SimpleProcessor/blob/master/resources/images/Quartus%20II%20Images/Quartus_RTL_Top.png)  
Figure x. RLT view of processor. 

<br/>

![RTL view of control unit](https://github.com/jason9829/AlteraDE1_SimpleProcessor/blob/master/resources/images/Quartus%20II%20Images/Quartus_RTL_ControlUnit.png)  
Figure x. RLT view of control unit. 

<br/>

![RTL view of data path](https://github.com/jason9829/AlteraDE1_SimpleProcessor/blob/master/resources/images/Quartus%20II%20Images/Quartus_RTL_DataPath.png)  
Figure x. RLT view of data path. 

<br/> 

![RTL view of 2-to-1 mux](https://github.com/jason9829/AlteraDE1_SimpleProcessor/blob/master/resources/images/Quartus%20II%20Images/Quartus_RTL_2to1MUX.png)
Figure x. RLT view of two to one multiplexer. 

<br/>

![RTL view of 4-to-1 mux](https://github.com/jason9829/AlteraDE1_SimpleProcessor/blob/master/resources/images/Quartus%20II%20Images/Quartus_RTL_4to1MUX.png)  
Figure x. RLT view of four to one multiplexer. 

<br/>

![RTL view of adder-subtractor](https://github.com/jason9829/AlteraDE1_SimpleProcessor/blob/master/resources/images/Quartus%20II%20Images/Quartus_RTL_AddSub.png)
Figure x. RLT view of adder-subtractor. 

<br/> 

![RTL internal view of 32x8 RAM](https://github.com/jason9829/AlteraDE1_SimpleProcessor/blob/master/resources/images/Quartus%20II%20Images/Quartus_RTL_RAM_InternalView.png)
Figure x. RLT internal view of 32x8 RAM. 

<br/>

![RTL external view of 32x8 RAM](https://github.com/jason9829/AlteraDE1_SimpleProcessor/blob/master/resources/images/Quartus%20II%20Images/Quartus_RTL_RAM_ExternalView.png)
Figure x. RLT external view of 32x8 RAM. 

<br/>

![RTL view of D register](https://github.com/jason9829/AlteraDE1_SimpleProcessor/blob/master/resources/images/Quartus%20II%20Images/Quartus_RTL_DReg.png)  
Figure x. RLT view of D register. 

<br/>  


## References
[1] [Lab manual](https://github.com/jason9829/AlteraDE1_SimpleProcessor/blob/master/resources/pdf/BAME2044%20%40%20LAB%202018.pdf)  
[2] Greatest common divisor, Wikipedia, 2020. Available at: https://en.wikipedia.org/wiki/Greatest_common_divisor (viewed on 30 Apr 2020)    
[3] Least common multiple, Wikipedia, 2020. Available at: https://en.wikipedia.org/wiki/Least_common_multiple (viewed on 30 Apr 2020)  
[4] The fetch-decode-execute cycle, Teach-ICT. Available at:http://teach-ict.com/gcse_computing/ocr/212_computing_hardware/cpu/miniweb/pg3.php (viewed on 1 May 2020)   
[5] Program counter, Wikiepedia, 2020. Available at: https://en.wikipedia.org/wiki/Program_counter (viewed on 1 May 2020)  
[6] Instruction register, Wikipedia, 2020. Availabe at: https://en.wikipedia.org/wiki/Instruction_register (viewed on 1 May 2020)  
[7]
