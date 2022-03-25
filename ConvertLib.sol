//SPDX-License-Identifier: UNLICENSED
pragma solidity >0.4.18 < 0.9.0;

library ConvertLib{
	function convert(uint amount,uint conversionRate) public pure returns (uint convertedAmount)
	{
		return amount * conversionRate;
	}
}
