# About
WELCOM, an easy-to-use Stata-based package to estimate direct distributional effects of changes in market concentration using minimum data requirements. It was conceived as part of larger World Bank efforts to better understand how competition policy can improve market efficiency and reduce poverty. 

Why is fully grasping the distributional effects of competition central for policymaking?

1) Links between declining competition and rising inequality are more worrying for developing countries, which tend to have more concentrated markets.
Poor households are typically more exposed to the potential negative effects of lack of competition.

2) The Creation of markets or prompting competition in concentrated markets could serve as a mechanism for poverty reduction, beyond the established effects on growth and productivity. 

Lower prices resulting from higher competition in the production of any good benefits both current and potential new consumers previously “priced out” of a market.  The WELCOM tool also enables users to identify the likely entry effects of new consumers due to lower prices of goods and services through the MCWEL module, as well as the likely welfare effects for those new entrants, through the “Market Competition and the Extensive Margin Analysis” (MCEMA) module.


# Install

1) Download the welcom.rar file, unzip the folder in a local directory. For instance, "c:/temp". 

2) Please execute the following commands, but modify the "net from" portion to where you saved the welcom.rar files:

```
set more off
net from c:/temp/welcom/Installer
net install welcom_p1,   force
net install welcom_p2,   force
net install welcom_p3,   force
net install welcom_p4,   force
net get     welcom_data, force
```

3) In new *.do file., please execute the following

```
* To make WB Open Data work
set checksum off, permanently

* To add WELCOM tool to menu
_welcom_menu

exit

```

4) Close Stata and reopen. 

# Documentation
Two user manuals are currently available for the tool. These can be found in the manuals folder. Furthermore, one background paper to introduce the tool was produced as well as a WB Poverty and Equity GP Note.

1) WELCOM (MCWEL) user manual: standard tool.
2) MCEMA user manual: extends the standard tool to simulate the effects of new consumers in the market (extensive margin of consumption) due to lower prices.

[Working Paper—Distributional Effects of Competition A simulation approach](https://openknowledge.worldbank.org/handle/10986/31603) 

[Note—Welfare and Competition (WELCOM): a simulation approach](https://documents1.worldbank.org/curated/en/711951596003624866/pdf/Welfare-and-Competition-WELCOM-A-Simulation-Approach.pdf) 
