// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@confluxfans/contracts/utils/ERC1820Context.sol";
import "@confluxfans/contracts/InternalContracts/SponsorWhitelistControl.sol";
import "@confluxfans/contracts/InternalContracts/AdminControl.sol";
import "@confluxfans/contracts/InternalContracts/InternalContractsLib.sol";

/**
 * @dev Provides default configurations for Conflux internal contracts.
 */
abstract contract InternalContractsHandler is ERC1820Context {
    constructor() {
        if (!_isCfxChain()) {
            return;
        }

        // Support to sponsor all users by default.
        address[] memory users = new address[](1);
        users[0] = address(0);
        InternalContracts.SPONSOR_CONTROL.addPrivilege(users);

        // remove contract admin
        InternalContracts.ADMIN_CONTROL.setAdmin(address(this), address(0));
        require(InternalContracts.ADMIN_CONTROL.getAdmin(address(this)) == address(0), "require admin == null");
    }
}
