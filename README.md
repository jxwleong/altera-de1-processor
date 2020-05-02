# Altera DE1 SimpleProcessor (Overview)
Use Verilog HDL code to synthesize the General Purpose Microprocessor (GPM). The GPM is broken down into two parts: Datapath (DP) and Control Unit (CU). Write the DP and CU code seperately then combined into a top module (DP + CU). The purpose of the GPM is to determine the Greatest Common Divisor (GCD) between two integers.  


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
4.  [Components of the Processor](#comp)    


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

1. **LOAD A**   
This instruction will load the content of memory location aaaaa (encoded with the instruction) into the accumulator.

2. **STORE A**  
This instruction will store the data in A (an 8-bit data register) into the memory location aaaaa, whereby aaaaa is encoded within the instruction in the RAM.

3. **ADD A**  
This instruction will add the data in A (an 8-bit data register) with the data in the memory location aaaaa. Then, the result of the addition is stored back into A.

4. **SUB A**  
This instruction will subtract the data in A (an 8-bit data register) with the data in the memory location aaaaa. Then, the result of the subtraction is stored back into A.

5. **IN A**  
This instruction will load A (an 8-bit data register) with the data from INPUT line (external I/Os such as switch in Altera DE1).

6. **JZ**  
This instruction will configure the Program Counter (PC) to the memory address, aaaaa when the value of A is zero so that the PC will executed the instruction at specific memory address instead to sequentially.

7. **JPOS**  
This instruction will configure the Program Counter (PC) to the memory address, aaaaa when the value of A is postive so that the PC will executed the instruction at specific memory address instead to sequentially.

8. **HALT**  
This instruction will halt the execution. This instruction will be executed when the GCD is found.

<br/>



#### Schematic View of the Processor
![Complete Circuit for Processor](https://github.com/jason9829/AlteraDE1_SimpleProcessor/blob/master/resources/images/Lab%20Manual%20Images/CompleteCircuitProcessor.png)  
Figure x. The Complete Circuit for the GCD Processor
  
<br/>  

The structure of the processor can be broken-down into two sections, Control Unit (CU) and Datapath (DP).

The ***Control Unit (CU)*** is the component that direct the oprations of the processor based on the status signals such as instruction received from datapath. Based on the instruction received, it will send the corresponding control signals to perform the task. It normally control the memory and register (enable read/ write operation or when to load the register).

The ***Datapath (DP)*** consists of a combinations of functional units such as adder, subtractor and memory. It is used to perform data processing based on the control signals received from CU. Besides, it also send the instruction bits and neccesary status signals to help CU to send the correct control signals.  
<br/>  

#### I/O Signals  
1. **Clock**  
The processor executes instructions based on the clock. For this processor, the instructions is executed on the rising edge of the clock signals. The clock speed will determine how fast the processor can executes the instuctions. The clock speed for this processor is 4 Hz by using a clock divider.

2. **Reset**  
For Control Unit (CU), the Reset signal will cause the state to become the first state which is `start`.  
For Datapath (DP), the Reset signal will cause the data in 8-bit instruction register, 5-bit Program Counter (PC) and 8-bit data register/ accumulator to be cleared.

3. **Enter**  
This input signal is used when the current state is in `input` state. It is control by an external trigger (such as switch) to tell the CU that the correct input data is selected. When this signal is high, it will tell DP to process the data so that it can proceed to next state.

4. **Halt**  
This output signal is used to indicate that the program is completed. It is assigned with the LED pin on Altera DE1.

5. **Input**  
This 8-bit input signals will be loaded into A (8-bit data register) when the current state is `input`. This signals will be used for the adding or subrating operations based on the instruction.

6. **Output**  
This 8-bit output signals will sent out from A (8-bit data register) when the current state is `load`. This output signals is only used for display or send to another component. This output signal is crucial for sending `Aeq0` and `Apos` status signals to CU.  

<br/>

#### Control Signals
1. **IRload**  
This signal will sent to the Data Path (DP) so that the 8-bit instruction stored in the RAM can be loaded into the 8-bit instruction register.

2. **JMPmux**  
This signal will allow the 2-to-1 multiplexer to choose the memory address to be loaded into the 5-bit Program Counter (PC) instead of the increment value after each instruction is executed. Basically, the signal is important when there are jump instructions to be executed. When the signal is `HIGH`, it will choose the memory address from the instruction. Otherwise, it will select the increment value.

3. **PCload**  
PCload signal is used to load the 5-bit PC. The data to be loaded could be the specific memory address for jump instructions or increment value.

4. **Meminst**  
This signal will determine which memory address to be used for Read/ Write the data in RAM. If the signal is `HIGH`, it will choose the address from that is encoded with the instruction. Else, it will choose the memory address from PC.

5. **MemWr**  
MemWr signal is used to determine the operations of the RAM. When the signal is `HIGH`, the input signals of the RAM will be written in the specific memory address encoded in the instruction. If the signal is `LOW`, the RAM is available for read only.

6. **Asel**  
These signals is used for the 4-to-1 decoder so that it will select the correct input signals to be loaded into A (8-bit data register/ Accumulator).

7. **Aload**  
This signals function are similar to **PCload**, it is used to load data register A.

8. **Sub**  
Sub signal is send to the adder-subtractor. When the signal is `HIGH`, the adder-subtractor will act as a subtractor. Otherwise, it operates like an adder.
  
<br/>

#### Status Signals  
1. **IR**  
These signals contain the actual 3-bit instruction from the RAM. It is received from Datapath (DP) to update current state and send correct control signals back to DP.

2. **Aeq0**  
This signal is sent to Control Unit (CU) when the data in A (8-bit data register/ Accumulator) so that the CU will sent the control signals to executed the right instructions. OR gate is used to check the output signals from A, if the data is zero it will sent `HIGH` to CU.

3. **Apos**  
Apos signal function similar to Aeq0. It is used to tell the CU that the data in A is positive. The MSB of the 8-bit output signals will used to determine whether the number is postivie or negative because MSB is the sign indicator. A NOT gate is used to validate the data in A, if the MSB is 0 which means that the number is positive, `HIGH` will be sent to CU.

<br/>

#### State Table
![State Table of GPM](https://github.com/jason9829/AlteraDE1_SimpleProcessor/blob/master/resources/images/Lab%20Manual%20Images/StateTable.png)   
Figure 2. State Table for the GPM from [1]. 

<br/>

Figure above shows the state table of the processor. The state table will tells what are the next state based on different input signals and produce the relevant output signals. There are 11 different states for this processor. The transition of different states is determined by the Control Unit (CU). The CU will send the correct control signals after receiving the status signals from the Datapath (DP). The relationship between the control signals from CU and the states are stated in the table shown in Figure above.

<br/>


#### State Diagram
![State Diagram of GPM](https://github.com/jason9829/AlteraDE1_SimpleProcessor/blob/master/resources/images/Lab%20Manual%20Images/StateDiagram.png)   
Figure 3. State Diagram for the GPM from [1]. 

<br/>
  
#### The State Machine in this Processor

1. **START**  
The start state of the processor, it will jump to next state (FETCH) after start up.  

2. **FETCH**  
The instruction register (IR) will fetch the instruction from memory (RAM). At the same time, the value of program
counter is incremented by 1.  

3. **DECODE**  
At this stage, the memory address (encoded in the instruction) was sent in the 32x8 RAM. So that the writing/ reading process are executed at the correct memory location. Depend on the instruction, there are multiple possible next states.  

4. **LOAD**  
At this state, it will load the data from RAM with memory location set by the instruction to the 8-bit data register (A). After the instruction is executed, the CPU will go back to start state to wait for new instruction to process.  

5. **STORE**  
At STORE state, it will load the current data in the 8-bit data register (A) to the memory address encoded with the instruction. 

6. **ADD**  
At this state, the adder-subtractor will add the current value at the 8-bit data register with the output data of RAM with memory address set by the instruction code.  

7. **SUB**  
At this state, the adder-subtractor will minus the current value at the 8-bit data register (A) with the output data of RAM with memory address set by the instruction code using 2's complement (A + B'').  

8. **INPUT**  
The 8-bit INPUT (from input pin) will be loaded into the 8-bit data register (A). An external pin (ENTER) was used to determine when the assign data is ready.  

9. **JZ**  
If the data in the 8-bit data register is 0, the address is jump to the specified memory location encoded within the instruction. In otherwords, the program counter will jump to the specified memory location instead of increment.  

10. **JPOS**   
If the data in the 8-bit data register is positive, the address is jump to the specified memory location encoded within the instruction.
In otherwords, the program counter will jump to the specified memory location instead of increment.  

11. **HALT**    
The processor will be halt when the GCD is find.  
  
<br/>

## <a name="whatIsGCD"></a> What is Greatest Common Divisor (GCD)?
Greatest Common Divider (GCD) is the largest positive integer that divides two or more integers [2].
  
<br/>
  
### <a name="GCDExp"></a> GCD Example
Example of GCD, the GCD of 8 and 12 is 4. This is because 4 is the largest positive integer that can
divide 8 and 12.

The example above is simple to understand and calculated. However, it may find the GCD between two large number ineffective. To solve this problem, **Euclidian Algorithm** is used in this processor to determine the GCD between two large number more efficiently. The algorithm is explained below.

**Simple example**
```
Find the GCD between 8 and 12.

Answer:
12 = 8.q + r   ; q = quantity in integer that can be multiply to have number close to the number on the left.
               : r = remainder of the multiplication with q
12 = 8.1 + 4   ; Move the operand eight (8 to left) and move 4 to the left

8 = 4.2 + 0 ; When the remainder (r) is zero, the remainder on the previous equation is the GCD.

# The GCD between 8 and 12 is 4.

```

**Complex example**
```
Find the GCD between 12238 and 3768.

Answer:  Repeat the process from Simple example.
12238 = 3768.3 + 934
3768 = 934.3 + 32
934 = 32.29 + 6
32 = 6.5 + 2
6 = 2.3 + 0

# The GCD between 12238 and 3768 is 2.

```

<br/>


### <a name="GCDApp"></a> GCD Application
#### <a name="redFrac"></a> 1. Reducing Fractions
GCD is useful for reducing fractions. It can be used to simplify the fraction to the lowest terms. For Example, the GCD of <sup>12</sup>&frasl;<sub>24</sub> is **12**. Therefore, 
  
<sup>12</sup>&frasl;<sub>24</sub> = <sup>(1 * 12)</sup>&frasl;<sub>(2 * 12)</sub> = <sup>1</sup>&frasl;<sub>2</sub>  
   
The simplest term for <sup>12</sup>&frasl;<sub>24</sub> is <sup>1</sup>&frasl;<sub>2</sub> 
 
#### <a name="findLCM"></a> 2. Find Least Common Multiple (LCM)
As the name implies, LCM means the least common multiple of two or more integers. For example,  

Multiple of 2:	2, **4**, 6, 8, 10, 12  
Multiple of 4:  **4**, 8, 12, 16, 20, 24

The LCM of 2 and 4 is 4.

A of the real life applications of LCM are distribute item evenly. For example, there are two slice of pizza and it must be shared among three people [8]. By determine the LCM,

Multiple of 2: 2, 4, **6**, 8, 10, 12  
Multiple of 3: 3, **6**, 9, 12, 15, 18

The LCM between 2 and 3 are 6. So, the pizza is sliced into six pieces so that everyone share the even amount of pizza.

#### <a name="crypto"></a> 3. Cryptography
GCD is also used in cryptography (requires further exploration).

<br/>

## <a name="instCyc"></a> Instruction Cycle
The instruction cycle of a processor can be broken down into three stages, fetch, decode and execute.

![Instruction Cycle w/ PC](https://github.com/jason9829/AlteraDE1_SimpleProcessor/blob/master/resources/images/Misc/ProgramCounterExplanation.gif)  
Gif 1. Animation of the instruction cycle and program counter.  

1. **Fetch**  
This is the first step for instruction cycle. THe CPU fetch some data and instructions from the main memory and store them it in a temporary memoty areas (register) [4]. After the instructions is fetched, the value in Program Counter (PC) is incremented or replaced to other specific memory location if branch or jump conditions is met. At the same time, the Control Unit (CU) receives the instructions for Datapath (DP).

2. **Decode**  
The next step of the instruction cycle is decode. CPU is designed to understand a specific set of instructions. The CPU decodes the fetched instruction and proceed to next step [4]. At this stage, the CU decode the instruction from DP. Based on the instruction, the respond is sent to DP in the form of control signals.

3. **Execute**  
The last stage of the instruction cycle. In this stage, the CPU will process the data based on the instruction. Once the execute stage is complete, the CPU will begin another instruction cycle [4]. After receiving the control signals from CU, the DP will process the data according to the signals sent from CU. 

<br/>  

## <a  name="comp"></a> Components of the Processor 
![Top RTL view of processor](https://github.com/jason9829/AlteraDE1_SimpleProcessor/blob/master/resources/images/Quartus%20II%20Images/Quartus_RTL_Top.png)  
Figure x. RLT view of processor. 

<br/>  
Figure above shows the entire circuitry of the processor. The processor contains two main compartment which are the Control Unit (CU) and Datapath (DP). The CU behaves like an instructor where it instruct the DP to process the data. CU receives the instruction from DP and send the control signals to DP so that DP can process the data as expected. After processing the data, DP will sent out status signals to CU to act as a feedback so that CU can transition in to the right state to give correct control signals. 

![Datapath of GPM](https://github.com/jason9829/AlteraDE1_SimpleProcessor/blob/master/resources/images/Lab%20Manual%20Images/Datapath.png)   
Figure 4. Datapath for the GPM from [1.]. 
  
![RTL view of data path](https://github.com/jason9829/AlteraDE1_SimpleProcessor/blob/master/resources/images/Quartus%20II%20Images/Quartus_RTL_DataPath.png)  
Figure x. RLT view of data path (open image in new tab). 

![RTL view of control unit](https://github.com/jason9829/AlteraDE1_SimpleProcessor/blob/master/resources/images/Quartus%20II%20Images/Quartus_RTL_ControlUnit.png)  
Figure x. RTL view of control unit. 

<br/> 

Figures above shows the schematic and RTL view of the Datapath (DP) and Control Unit (CU), the DP contains a collection of different functional components such as adder-subtractor, accumulator, RAM and register to process the data. Moreover, the CU consists of decoder, selector and some logic gate to determine the states and control signals. The description for each components can be found below.  

1. **Register**  
In electronics, register is made out of flip-flop to store larger size data. This is because flip-flop can only stored one bit of data.
However, the data stored in the flip-flop will be erased as soon as the power goes off. For this processor, D flip-flop is used because of the simplicity of the design.  

![RTL view of D register](https://github.com/jason9829/AlteraDE1_SimpleProcessor/blob/master/resources/images/Quartus%20II%20Images/Quartus_RTL_DReg.png)  
Figure x. RLT view of D register. 

<br/>   

Figure above shows the RTL view of the 8-bit register made of eight D flip-flop. This register is then used for instruction register, data register (accumulator) and program counter (5-bit). The verilog code for this module can be found [here](https://github.com/jason9829/AlteraDE1_SimpleProcessor/blob/master/DFF_reg.v).


2. **Program Counter (PC)**  
Program Counter (PC) is a register in a processor that indicates the next instruction memory address after fetching a instruction [5]. The program counter are affected by the instruction cycle. The value in the PC will be changed when the instructions already fetched or a branch or jump condition is met so the PC value will changed to that specific memory location. If there are no branch or jump conditions, the value of the PC will be incremented as the instruction executes. 

3. **Instruction Register (IR)**  
Instruction register (IR) is a register that store the actual instruction to be executed or decoded. First, the instruction is fetched to the IR, then it holds the instruction while decoding. After decoding, the instruction is executed and current register is replaced with next instruction. For this processor, `bit 4 to 0` will be loaded to the PC when the instructions requires branch or jump to specific memory address or it's the first instruction.  

4. **Multiplexer**  
![RTL view of 2-to-1 mux](https://github.com/jason9829/AlteraDE1_SimpleProcessor/blob/master/resources/images/Quartus%20II%20Images/Quartus_RTL_2to1MUX.png)  
Figure x. RLT view of two to one multiplexer. 

![RTL view of 4-to-1 mux](https://github.com/jason9829/AlteraDE1_SimpleProcessor/blob/master/resources/images/Quartus%20II%20Images/Quartus_RTL_4to1MUX.png)  
Figure x. RLT view of four to one multiplexer. 

Figures above shows RTL view of 2-to-1 and 4-to-1 multiplexer. Multiplexer is a device that selects one of the analog or digital input signals and forwards it into a single output line. Multiplexer selects the input signals based on the signals given at selector pin. 

| Select (S0) |   Out   |
|-------------|---------|
| 0           |    D0   |
| 1           |    D1   |  
 
Table above shows the truth table of 2-to-1 multiplexer. When the select signals is `LOW`, the multiplexer will select LSB as output. Otherwise, it will select MSB as output.

| Select1(S1) | Select0 (S0) | Out |
|-------------|--------------|-----|
| 0           | 0            | D0  |
| 0           | 1            | D1  |
| 1           | 0            | D2  |
| 1           | 1            | D3  |

4-to-1 multiplexer functions like 2-to-1 multiplexer but with extra select signals as shown as table above. When the select signals (S1S0) is `00` it will select LSB as the output and so on.


5. **Adder-subtractor**  

![RTL view of adder-subtractor](https://github.com/jason9829/AlteraDE1_SimpleProcessor/blob/master/resources/images/Quartus%20II%20Images/Quartus_RTL_AddSub.png)
Figure x. RTL view of adder-subtractor. 

<br/>  


6. **RAM**  
![RTL internal view of 32x8 RAM](https://github.com/jason9829/AlteraDE1_SimpleProcessor/blob/master/resources/images/Quartus%20II%20Images/Quartus_RTL_RAM_InternalView.png)
Figure x. RTL internal view of 32x8 RAM.   

![RTL external view of 32x8 RAM](https://github.com/jason9829/AlteraDE1_SimpleProcessor/blob/master/resources/images/Quartus%20II%20Images/Quartus_RTL_RAM_ExternalView.png)
Figure x. RTL external view of 32x8 RAM.  

<br/>


## References
[1] [Lab manual](https://github.com/jason9829/AlteraDE1_SimpleProcessor/blob/master/resources/pdf/BAME2044%20%40%20LAB%202018.pdf)  
[2] Greatest common divisor, Wikipedia, 2020. Available at: https://en.wikipedia.org/wiki/Greatest_common_divisor (viewed on 30 Apr 2020)    
[3] Least common multiple, Wikipedia, 2020. Available at: https://en.wikipedia.org/wiki/Least_common_multiple (viewed on 30 Apr 2020)  
[4] The fetch-decode-execute cycle, Teach-ICT. Available at:http://teach-ict.com/gcse_computing/ocr/212_computing_hardware/cpu/miniweb/pg3.php (viewed on 1 May 2020)   
[5] Program counter, Wikiepedia, 2020. Available at: https://en.wikipedia.org/wiki/Program_counter (viewed on 1 May 2020)  
[6] Instruction register, Wikipedia, 2020. Availabe at: https://en.wikipedia.org/wiki/Instruction_register (viewed on 1 May 2020)  
[7] How to Find the Greatest Common Divisor by Using the Euclidian Algorithm, Learn Math Tutorials, 2020. Available at: https://www.youtube.com/watch?v=JUzYl1TYMcU (viewed on 2 May 2020)  
[8] What are the applications of HCF and LCM in daily life? Adhikari, 2017. Available at: https://www.quora.com/What-are-the-applications-of-HCF-and-LCM-in-daily-life (viewed on 2 May 2020)  
[9] Multiplexer, Wikipedia, 2020. Available at: https://en.wikipedia.org/wiki/Multiplexer (viewed on 2 May 2020)
