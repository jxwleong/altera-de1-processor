# Altera DE1 Processor [![Cocotb Test](https://github.com/jxwleong/altera-de1-processor/actions/workflows/cocotb_test.yml/badge.svg)](https://github.com/jxwleong/altera-de1-processor/actions/workflows/cocotb_test.yml)
Use Verilog HDL code to synthesize the General Purpose Microprocessor (GPM). The GPM is broken down into two parts: Datapath (DP) and Control Unit (CU). Write the DP and CU code seperately then combined into a top module (DP + CU). The purpose of the GPM is to determine the Greatest Common Divisor (GCD) between two integers.  

<br/>  


## Table of Contents
- [Altera DE1 Processor](#altera-de1-processor)
  - [Table of Contents](#table-of-contents)
  - [ Requirements for this project](#-requirements-for-this-project)
    - [ Software Requirements](#-software-requirements)
    - [Hardware Requirement](#hardware-requirement)
    - [Processor Specifications](#processor-specifications)
      - [Instruction Sets](#instruction-sets)
      - [Schematic View of the Processor](#schematic-view-of-the-processor)
      - [I/O Signals](#io-signals)
      - [Control Signals](#control-signals)
      - [Status Signals](#status-signals)
      - [State Table](#state-table)
      - [State Diagram](#state-diagram)
      - [The State Machine in this Processor](#the-state-machine-in-this-processor)
  - [ What is Greatest Common Divisor (GCD)?](#-what-is-greatest-common-divisor-gcd)
    - [ GCD Method and Example](#-gcd-method-and-example)
      - [ Euclidian Algorithm](#-euclidian-algorithm)
      - [ subtraction](#-subtraction)
    - [ GCD Application](#-gcd-application)
      - [ 1. Reducing Fractions](#-1-reducing-fractions)
      - [ 2. Find Least Common Multiple (LCM)](#-2-find-least-common-multiple-lcm)
      - [ 3. Cryptography](#-3-cryptography)
  - [ Instruction Cycle](#-instruction-cycle)
  - [ Components of the Processor](#-components-of-the-processor)
    - [ Register](#-register)
    - [ Program Counter (PC)](#-program-counter-pc)
    - [ Instruction Register (IR)](#-instruction-register-ir)
    - [ Multiplexer](#-multiplexer)
    - [ Adder-subtractor](#-adder-subtractor)
    - [ RAM](#-ram)
  - [ Program to Determine GCD](#-program-to-determine-gcd)
    - [Pseudocode of the Program](#pseudocode-of-the-program)
    - [ Program Example](#-program-example)
      - [Example 1](#example-1)
      - [Example 2: Let's trace through the execution with num1=10 and num2=9](#example-2-lets-trace-through-the-execution-with-num110-and-num29)
  - [ Future Enhancement](#-future-enhancement)
  - [ References](#-references)

<br/>  <br/>  

## <a name="project_requirement"></a> Requirements for this project  

### <a name="software_requirement"></a> Software Requirements
1. Quartus II
2. Model SIM  

<br/>  

### <a name="hardware_requirement"></a>Hardware Requirement
1. Altera DE1 Board  

<br/>  

### <a name="processor_specification"></a>Processor Specifications  
#### <a name="instruction_set"></a>Instruction Sets
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

4. **subtraction A**  
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



#### <a name="schematic"></a>Schematic View of the Processor
![Complete Circuit for Processor](https://github.com/jason9829/AlteraDE1_SimpleProcessor/blob/master/resources/images/Lab%20Manual%20Images/CompleteCircuitProcessor.png)  
Figure 2. The Complete Circuit for the GCD Processor
  
<br/>  

The structure of the processor can be broken-down into two sections, Control Unit (CU) and Datapath (DP).

The ***Control Unit (CU)*** is the component that direct the oprations of the processor based on the status signals such as instruction received from datapath. Based on the instruction received, it will send the corresponding control signals to perform the task. It normally control the memory and register (enable read/write operation or when to load the register).

The ***Datapath (DP)*** consists of a combinations of functional units such as adder, subtractor and memory. It is used to perform data processing based on the control signals received from CU. Besides, it also send the instruction bits and neccesary status signals to help CU to send the correct control signals.  
<br/>  

#### <a name="io_signal"></a>I/O Signals  
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
This 8-bit input signals will be loaded into A (8-bit data register) when the current state is `input`. This signals will be used for the adding or subtractionrating operations based on the instruction.

6. **Output**  
This 8-bit output signals will sent out from A (8-bit data register) when the current state is `load`. This output signals is only used for display or send to another component. This output signal is crucial for sending `Aeq0` and `Apos` status signals to CU.  

<br/>

#### <a name="control_signal"></a>Control Signals
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

8. **subtraction**  
subtraction signal is send to the adder-subtractor. When the signal is `HIGH`, the adder-subtractor will act as a subtractor. Otherwise, it operates like an adder.
  
<br/>

#### <a name="status_signal"></a>Status Signals  
1. **IR**  
These signals contain the actual 3-bit instruction from the RAM. It is received from Datapath (DP) to update current state and send correct control signals back to DP.

2. **Aeq0**  
This signal is sent to Control Unit (CU) when the data in A (8-bit data register/ Accumulator) so that the CU will sent the control signals to executed the right instructions. OR gate is used to check the output signals from A, if the data is zero it will sent `HIGH` to CU.

3. **Apos**  
Apos signal function similar to Aeq0. It is used to tell the CU that the data in A is positive. The MSB of the 8-bit output signals will used to determine whether the number is postivie or negative because MSB is the sign indicator. A NOT gate is used to validate the data in A, if the MSB is 0 which means that the number is positive, `HIGH` will be sent to CU.

<br/>

#### <a name="state_table"></a>State Table
![State Table of GPM](https://github.com/jason9829/AlteraDE1_SimpleProcessor/blob/master/resources/images/Lab%20Manual%20Images/StateTable.png)   
Figure 3. State Table for the GPM from [1]. 

<br/>

Figure above shows the state table of the processor. The state table will tells what are the next state based on different input signals and produce the relevant output signals. There are 11 different states for this processor. The transition of different states is determined by the Control Unit (CU). The CU will send the correct control signals after receiving the status signals from the Datapath (DP). The relationship between the control signals from CU and the states are stated in the table shown in Figure above.

<br/>


#### <a name="state_diagram"></a>State Diagram
![State Diagram of GPM](https://github.com/jason9829/AlteraDE1_SimpleProcessor/blob/master/resources/images/Lab%20Manual%20Images/StateDiagram.png)   
Figure 4. State Diagram for the GPM from [1]. 

<br/><br/>  
  
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

7. **subtraction**  
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
  
<br/><br/>  

## <a name="what_is_gcd"></a> What is Greatest Common Divisor (GCD)?
Greatest Common Divider (GCD) is the largest positive integer that divides two or more integers [2].  

  
### <a name="gcd_method_and_experiment"></a> GCD Method and Example
Example of GCD, the GCD of 8 and 12 is 4. This is because 4 is the largest positive integer that can
divide 8 and 12.

#### <a name="euclidian_algorithm"></a> Euclidian Algorithm     
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


#### <a name="subtraction"></a> subtraction   
The last method is to used the repeated subtractionraction method. The working princple is subtract the smaller number from the greater. Repeat the process until the remainders are equal, which is the GCD of the given numbers [10]. For example,  
  
```
Find the GCD for 20 and 5.

0. GCD (20, 5) ; subtract the larger number with smaller number
1. GCD (15, 5) ; Repeat
2. GCD (10, 5) ; Repeat
3. GCD (5, 5)  ; The remainders are equal so that GCD is 5.

```
This processor use this method to find the GCD between two integer numbers. However, this processor will continue to subtract (the same remainders) to zero so that it knows it's the end of the calculation.

<br/>


### <a name="gcd_application"></a> GCD Application
#### <a name="reducing_fraction"></a> 1. Reducing Fractions
GCD is useful for reducing fractions. It can be used to simplify the fraction to the lowest terms. For Example, the GCD of <sup>12</sup>&frasl;<subtraction>24</subtraction> is **12**. Therefore, 
  
<sup>12</sup>&frasl;<subtraction>24</subtraction> = <sup>(1 * 12)</sup>&frasl;<subtraction>(2 * 12)</subtraction> = <sup>1</sup>&frasl;<subtraction>2</subtraction>  
   
The simplest term for <sup>12</sup>&frasl;<subtraction>24</subtraction> is <sup>1</sup>&frasl;<subtraction>2</subtraction> 
   
<br/>  

#### <a name="find_lcm"></a> 2. Find Least Common Multiple (LCM)
As the name implies, LCM means the least common multiple of two or more integers. For example,  

Multiple of 2:	2, **4**, 6, 8, 10, 12  
Multiple of 4:  **4**, 8, 12, 16, 20, 24

The LCM of 2 and 4 is 4.

A of the real life applications of LCM are distribute item evenly. For example, there are two slice of pizza and it must be shared among three people [8]. By determine the LCM,

Multiple of 2: 2, 4, **6**, 8, 10, 12  
Multiple of 3: 3, **6**, 9, 12, 15, 18

The LCM between 2 and 3 are 6. So, the pizza is sliced into six pieces so that everyone share the even amount of pizza.

<br/>  

#### <a name="crypto"></a> 3. Cryptography
GCD is also used in cryptography (requires further exploration).

<br/><br/>  

## <a name="instruction_cycle"></a> Instruction Cycle
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
Figure 5. RTL view of processor. 

<br/>  
Figure above shows the entire circuitry of the processor. The processor contains two main compartment which are the Control Unit (CU) and Datapath (DP). The CU behaves like an instructor where it instruct the DP to process the data. CU receives the instruction from DP and send the control signals to DP so that DP can process the data as expected. After processing the data, DP will sent out status signals to CU to act as a feedback so that CU can transition in to the right state to give correct control signals. 

![Datapath of GPM](https://github.com/jason9829/AlteraDE1_SimpleProcessor/blob/master/resources/images/Lab%20Manual%20Images/Datapath.png)   
Figure 6. Datapath for the GPM from [1]. 
  
![RTL view of data path](https://github.com/jason9829/AlteraDE1_SimpleProcessor/blob/master/resources/images/Quartus%20II%20Images/Quartus_RTL_DataPath.png)  
Figure 7. RTL view of data path (open image in new tab). 

![RTL view of control unit](https://github.com/jason9829/AlteraDE1_SimpleProcessor/blob/master/resources/images/Quartus%20II%20Images/Quartus_RTL_ControlUnit.png)  
Figure 8. RTL view of control unit. 

<br/> 

Figures above shows the schematic and RTL view of the Datapath (DP) and Control Unit (CU), the DP contains a collection of different functional components such as adder-subtractor, accumulator, RAM and register to process the data. Moreover, the CU consists of decoder, selector and some logic gate to determine the states and control signals. The description for each components can be found below.  


### <a  name="reg"></a> Register  
In electronics, register is made out of flip-flop to store larger size data. This is because flip-flop can only stored one bit of data.
However, the data stored in the flip-flop will be erased as soon as the power goes off. For this processor, D flip-flop is used because of the simplicity of the design. Figure below shows the RTL view of the 8-bit register made of eight D flip-flop. This register is then used for instruction register, data register (accumulator) and program counter (5-bit). The verilog code for this module can be found [here](https://github.com/jason9829/AlteraDE1_SimpleProcessor/blob/master/DFF_reg.v).    
![RTL view of D register](https://github.com/jason9829/AlteraDE1_SimpleProcessor/blob/master/resources/images/Quartus%20II%20Images/Quartus_RTL_DReg.png)  
Figure 9. RTL view of D register. 

<br/>   

### <a  name="pC"></a> Program Counter (PC)     
Program Counter (PC) is a register in a processor that indicates the next instruction memory address after fetching a instruction [5]. The program counter are affected by the instruction cycle. The value in the PC will be changed when the instructions already fetched or a branch or jump condition is met so the PC value will changed to that specific memory location. If there are no branch or jump conditions, the value of the PC will be incremented as the instruction executes. 
<br/>  

### <a  name="ir"></a> Instruction Register (IR)   
Instruction register (IR) is a register that store the actual instruction to be executed or decoded. First, the instruction is fetched to the IR, then it holds the instruction while decoding. After decoding, the instruction is executed and current register is replaced with next instruction. For this processor, `bit 4 to 0` will be loaded to the PC when the instructions requires branch or jump to specific memory address or it's the first instruction.  
<br/>  

### <a  name="mux"></a> Multiplexer   
![RTL view of 2-to-1 mux](https://github.com/jason9829/AlteraDE1_SimpleProcessor/blob/master/resources/images/Quartus%20II%20Images/Quartus_RTL_2to1MUX.png)  
Figure 10. RTL view of two to one multiplexer. 
![RTL view of 4-to-1 mux](https://github.com/jason9829/AlteraDE1_SimpleProcessor/blob/master/resources/images/Quartus%20II%20Images/Quartus_RTL_4to1MUX.png)  
Figure 11. RTL view of four to one multiplexer.  <br/>  
Figures above shows RTL view of 2-to-1 and 4-to-1 multiplexer. Multiplexer is a device that selects one of the analog or digital input signals and forwards it to a single output line. Multiplexer selects the input signals based on the signals given at selector pin. 

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

The verilog code for 2-to-1 multiplexer can be found [here](https://github.com/jason9829/AlteraDE1_SimpleProcessor/blob/master/mux2to1.v) and the code for 4-to1 multiplexer is located [here](https://github.com/jason9829/AlteraDE1_SimpleProcessor/blob/master/mux4to1.v).  

<br/><br/>  

### <a  name="addsubtraction"></a> Adder-subtractor   
![RTL view of adder-subtractor](https://github.com/jason9829/AlteraDE1_SimpleProcessor/blob/master/resources/images/Quartus%20II%20Images/Quartus_RTL_AddSub.png)
Figure 12. RTL view of adder-subtractor.     <br/> 


The adder-subtractor is used to perform calculations to find the GCD. This device can be configured to used act as an adder or subtractor depend on the control signal received `subtraction`. When `subtraction` is 1, then it will act as a subtractor else it will operator as an adder. However, the figure above shows that the adder-subtractor is made of two seperate adder. This is because adder can transform into subtractor by utilising 2's complement. For example,
    
```
Normal subtraction,
    
A = 10, B = 5
    
Ans = A - B
    = 10 - 5
    = 5
        
or in binary

    A     1 0 1 0   [10]
(-) B     0 1 0 1   [5]
    ==================
Ans  =    0 1 0 1   [5]
    
    
Using 2's complement to convert adder to subtractor,
    
A = 10, B = 5
Ans = A + 2's(B)
    
B = 0 1 0 1
1's (B) = 1 0 1 0   - Invert
2's (B) = 1 0 1 1   - Plus one
    
     A     1 0 1 0   [10]
 (+) B     1 0 1 1   [5]
     ==================
  Ans  =  1 0 1 0 1   [5] - The MSB is sign bit, this bit need to be inverted.
                            If sign bit is 1 means the number is negative.
                            Ans = 0 0 1 0 1 = 5
    
```  
  
Basically, this adder-subtractor will calculated become addition and subtraction. The control signal `subtraction` will prompt the 2-to-1 multiplexer to choose the correct answer.  
    
The code of the adder-subtractor can be found [here](https://github.com/jason9829/AlteraDE1_SimpleProcessor/blob/master/addsubtractionstractor.v).   
     
<br/>
   
### <a  name="ram"></a> RAM  
![RTL internal view of 32x8 RAM](https://github.com/jason9829/AlteraDE1_SimpleProcessor/blob/master/resources/images/Quartus%20II%20Images/Quartus_RTL_RAM_InternalView.png)
Figure 13. RTL internal view of 32x8 RAM.   
![RTL external view of 32x8 RAM](https://github.com/jason9829/AlteraDE1_SimpleProcessor/blob/master/resources/images/Quartus%20II%20Images/Quartus_RTL_RAM_ExternalView.png)
Figure 14. RTL external view of 32x8 RAM.  <br/>  

The size of the RAM used in this processor is 32 x 8. In other words, it contains 32 memory locations that can fit 8-bit data which is suitable for this processor because the instructions are in 8-bit.  This RAM is used to store the program (combination of different instructions) to find the GCD between two integers.  
    
Figures above shows in RTL view of the 32x8 RAM synthesized in this project. The RAM is made out of registers and extra I/O signals such as read/write address `ADDR[4:0]`, write enable `WRITE` and input data `DATA_IN[7:0]`. When `WRITE` is high, the input data from `DATA_IN[7:0]` will be stored into memory location specified at `ADDR[4:0]`. If `WRITE` is low, the content at address `ADDR[4:0]` will be outputed to `DATA_OUT[7:0]`.  

The code for the RAM can be found [here](https://github.com/jason9829/AlteraDE1_SimpleProcessor/blob/master/RAM.v).  
    

<br/>  <br/>  

## <a  name="program"></a> Program to Determine GCD  
Programs that are preloaded into the RAM.
| PC Count (RAM location) | Instruction code  | Description                   |
|-------------------------|-------------------|-------------------------------|
| 00000 (0)               | 100 00000         | INPUT A                       |
| 00001 (1)               | 001 11110         | STORE A -> 11110              |
| 00010 (2)               | 100 00000         | INPUT A                       |
| 00011 (3)               | 001 11111         | STORE A -> 11111              |
| 00100 (4)               | 000 11110         | LOAD (11110) -> A             |
| 00101 (5)               | 011 11111         | A = A - (11111)               |
| 00110 (6)               | 101 10000         | JUMP to PC (10000) if A = 0   |
| 00111 (7)               | 110 01100         | JUMP to PC (01100) if A = +ve |
| 01000 (8)               | 000 11111         | STORE A -> 11111              |
| 01001 (9)               | 011 11110         | A = A - (11110)               |
| 01010 (10)              | 001 11111         | STORE A -> 11111              |
| 01011 (11)              | 110 00100         | JUMP to PC (01100) if A = +ve |
| 01100 (12)              | 000 11110         | STORE A -> 11110              |
| 01101 (13)              | 011 11111         | A = A - 11111                 |
| 01110 (14)              | 001 11110         | STORE A -> 11110              |
| 01111 (15)              | 110 00100         | JUMP to PC (00100) if A = +ve |
| 10000 (16)              | 000 11110         | LOAD (11110) -> A             |
| 10001 (17)              | 111 11111         | HALT                          |

&nbsp;

### Pseudocode of the Program
```vbnet
1. Prompt the user for two inputs: num1 and num2
2. Store these inputs in two memory locations, let's say at 11110 and 11111
3. Start a loop:
    1. Load the value from memory location 11110 into register A
    2. Subtract the value at memory location 11111 from A
    3. If the result in A is zero:
        1. Jump to a location in the program that loads the value at 11110 into A and halts, outputting the result
    4. If the result in A is positive:
        1. Store the result back into memory location 11110
        2. Load the value from memory location 11111 into register A
        3. Subtract the value at memory location 11110 from A
        4. If the result is positive, store it back in 11110 and repeat the loop from step 3
    5. If the result in A is negative, swap the values at memory locations 11110 and 11111 and repeat the loop from step 3

```

&nbsp;&nbsp;  
### <a  name="program_example"></a> Program Example 
#### Example 1
Find the GCD where A  = 10, B = 5 by following the program preloaded into the RAM.

| No | Instructions             | Description                        |
|----|--------------------------|------------------------------------|
| 1  | IN A (10)                | INPUT integer 10 (A)               |
| 2  | STORE A (10) -> 11110    | Store 10 at location 11110         |
| 3  | IN A (5)                 | INPUT integer 5 (B)                |
| 4  | STORE A (5) -> 11111     | Store 5 at location 11111          |
| 5  | LOAD content 11110 to A  | Load 10 into A                     |
| 6  | A = A - 5 = 10 - 5 = 5   | subtract A from content at 11111   |
| 7  | Skip because A is not 0. | Skip because A is not 0.           |
| 8  | JPOS                     | JUMP Program Counter (PC) to 01100 |
| 9  | STORE A (5) -> 11110     | STORE A (5) at location 11110      |
| 10 | A = A - 5 = 5 - 5 = 0    | subtract A from content at 11111   |
| 11 | Skip because A is 0.     | Skip because A is 0.               |
| 12 | LOAD 11110 -> A          | LOAD content from 11110 (5) to A   |
| 13 | HALT                     | HALT                               |  

> The GCD between 10 and 5 is 5 (Step 12).

<br/>  
  
#### Example 2: Let's trace through the execution with num1=10 and num2=9  
| Step | PC   | Instructions             | Description                         |
|------|------|--------------------------|-------------------------------------|
| 1    |00000 | INPUT A (10)             | User inputs integer 10 (A)          |
| 2    |00001 | STORE A -> 11110         | Stores 10 at memory location 11110  |
| 3    |00010 | INPUT A (9)              | User inputs integer 9 (B)           |
| 4    |00011 | STORE A -> 11111         | Stores 9 at memory location 11111   |
| 5    |00100 | LOAD (11110) -> A        | Loads value 10 from 11110 into A    |
| 6    |00101 | A = A - (11111)          | Subtracts value at 11111 from A, now A=1 |
| 7    |00110 | JUMP to PC (10000) if A = 0 | Skips because A is not 0.         |
| 8    |00111 | JUMP to PC (01100) if A = +ve | Jumps to 01100 as A is positive |
| 9    |01100 | STORE A -> 11111         | Stores 1 at memory location 11111   |
| 10   |01101 | LOAD (11110) -> A        | Loads value 10 from 11110 into A    |
| 11   |01110 | A = A - (11111)          | Subtracts value at 11111 from A, now A=9 |
| 12   |01111 | STORE A -> 11110         | Stores 9 at memory location 11110   |
| 13   |01111 | JUMP to PC (00100) if A = +ve | Jumps back to PC=00100 as A is positive |
|      |      |                          | -- Repeats steps 5-13 until A becomes 0 -- |
| 14   |10000 | LOAD (11111) -> A        | Loads the final value 1 from 11111 into A |
| 15   |10001 | HALT                     | The program halts                   |
   |  

When A finally equals 0, we jump to PC=10000:


> The output is 1, which is the GCD of the original num1 and num2 (10 and 9).  
> The GCD between 10 and 9 is 1.

<br/><br/>    


## <a  name="future-enhancement"></a> Future Enhancement
1. **Adding a Pipeline**: The current processor operates in a non-pipelined fashion, where each instruction is completely processed before the next instruction begins execution. This might result in inefficient use of resources as the processor elements could be idle at times. Introducing pipelining would allow multiple instructions to be in different stages of execution at the same time, effectively increasing the processor's throughput. With pipelining, the instruction cycle is divided into different stages, such as Fetch, Decode, and Execute. Each of these stages operates in parallel for different instructions. This parallel operation leads to more efficient use of processor resources and a significant increase in instruction throughput. However, keep in mind that pipelining introduces some complexities, such as handling data and control hazards that need to be addressed with appropriate design techniques.

2. **Flexible Program Loading**: The current design includes a hardcoded program in the RAM module. This approach limits the flexibility of the processor, making it tedious and expensive to synthesize and test different programs. A more efficient and versatile approach would be to remove the hardcoded program and instead design the system to load the program instructions from an external source, such as a file or memory-mapped I/O device. This would allow the processor to execute different programs without requiring modifications or re-synthesis of the RAM module. It would also facilitate testing and debugging, as different test programs could be quickly loaded and executed.

3. **Optimized FSM traversal**: In the current design, the FSM (Finite State Machine) returns to the start state after completing the execution of an instruction. While this approach is simple and easy to implement, it may not be the most efficient in terms of execution cycles. Instead, an optimized approach could be to make the FSM directly transition from the Execute state to the Fetch state after an instruction is completed, bypassing the need to go back to the Start state. This modification could potentially reduce the instruction execution time by reducing unnecessary state transitions, thereby improving the processor's performance. Care should be taken to handle any dependencies or conditions that might affect this direct transition.

4. **Support for Negative Numbers**: The existing design only supports positive numbers, which significantly restricts the scope of its applicability. To widen the range of use-cases that the processor can handle, future enhancements could include adding support for negative numbers. This could be achieved by implementing the Two's Complement representation for negative numbers. In this system, the most significant bit of the number is used as a sign bit (0 for positive, 1 for negative), and the remaining bits represent the magnitude of the number. If the number is negative, the magnitude is represented as the two's complement of the absolute value of the number. This allows for a straightforward arithmetic operation and simplifies the hardware design. Also, this enhancement would require modifying the ALU to correctly handle arithmetic operations with negative numbers and potentially modifying the instruction set to add operations for handling negative numbers.


<br/><br/>   

## <a  name="reference"></a> References  
[1] [Lab manual](https://github.com/jason9829/AlteraDE1_SimpleProcessor/blob/master/resources/pdf/BAME2044%20%40%20LAB%202018.pdf)  
[2] Greatest common divisor, Wikipedia, 2020. Available at: https://en.wikipedia.org/wiki/Greatest_common_divisor (viewed on 30 Apr 2020)    
[3] Least common multiple, Wikipedia, 2020. Available at: https://en.wikipedia.org/wiki/Least_common_multiple (viewed on 30 Apr 2020)  
[4] The fetch-decode-execute cycle, Teach-ICT. Available at:http://teach-ict.com/gcse_computing/ocr/212_computing_hardware/cpu/miniweb/pg3.php (viewed on 1 May 2020)   
[5] Program counter, Wikiepedia, 2020. Available at: https://en.wikipedia.org/wiki/Program_counter (viewed on 1 May 2020)  
[6] Instruction register, Wikipedia, 2020. Availabe at: https://en.wikipedia.org/wiki/Instruction_register (viewed on 1 May 2020)  
[7] How to Find the Greatest Common Divisor by Using the Euclidian Algorithm, Learn Math Tutorials, 2020. Available at: https://www.youtube.com/watch?v=JUzYl1TYMcU (viewed on 2 May 2020)  
[8] What are the applications of HCF and LCM in daily life? Adhikari, 2017. Available at: https://www.quora.com/What-are-the-applications-of-HCF-and-LCM-in-daily-life (viewed on 2 May 2020)  
[9] Multiplexer, Wikipedia, 2020. Available at: https://en.wikipedia.org/wiki/Multiplexer (viewed on 2 May 2020)   
[10] Finding the Greatest Common Divisor by Repeated subtractions, Yiu, 2016. Available at: http://www.amesa.org.za/amesal_n21_a7.pdf (viewed on 3 May 2020) 
