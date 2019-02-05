// Copyright (c) 2016-2018 Clearmatics Technologies Ltd
// SPDX-License-Identifier: LGPL-3.0+
pragma solidity ^0.4.23;

import "../libraries/RLP.sol";
import "../libraries/SolidityUtils.sol";
import "../EventVerifier.sol";

/*
    TriggerEventVerifier

    Inherits from `EventVerifier` and verifies `Triggered` events.

    From the provided logs, we separate the data and define checks to assert certain information in the event and
    returns `true` if successful.

    Contracts similar to this that verify specific events should be designed only to verify the data inside the
    supplied events with similarly supplied expected outcomes. It is only meant to serve as a utility to perform defined
    checks against specific events.
*/
contract CordaTriggerEventVerifier is EventVerifier {


    function verify(bytes20 _contractEmittedAddress, bytes _rlpReceipt, bytes20 _expectedAddress) public returns (bool) {

        return true;
    }

}
