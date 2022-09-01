// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./PresetAutoId.sol";
import "./Metadata.sol";
import "./InternalContractsHandler.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract DTRegistry is AccessControlEnumerable, CRC1155Enumerable, Metadata, InternalContractsHandler {
    using Counters for Counters.Counter;
    using Strings for uint256;

    enum Lifecyclstate{EarlyPhase,MediumPhase,LaterPhase}
    Lifecyclstate public attribute;

    // Counter to auto generate token ID.
    Counters.Counter private _tokenIdTracker;
    
    bytes32 public constant OWNER = keccak256("OWNER");
    bytes32 public constant DESIGNER = keccak256("DESIGNER");
    bytes32 public constant S_DESIGNER = keccak256("S_DESIGNER");//Senior designer
    bytes32 public constant J_DESIGNER = keccak256("J_DESIGNER");//Junior designer
    bytes32 public constant MANUFACTURER = keccak256("MANUFACTURER");
    bytes32 public constant AC_MANUFACTURER = keccak256("AC_MANUFACTURER");//Accessories factory
    bytes32 public constant AS_MANUFACTURER = keccak256("AS_MANUFACTURER");//ASsembly workshop
    bytes32 public constant SERVICER = keccak256("SERVICER");
    bytes32 public constant O_SERVICER = keccak256("O_SERVICER");//operations
    bytes32 public constant T_SERVICER = keccak256("T_SERVICER");//Tester
    bytes32 public constant MAINTAINER = keccak256("MAINTAINER");
    bytes32 public constant RECYCLER = keccak256("RECYCLER");



    constructor(
        string memory name_,
        string memory symbol_,
        string memory ipfsuri_
    ) Metadata(name_, symbol_) ERC1155(ipfsuri_) {
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _setupRole(OWNER, _msgSender());//OWNER
        

        // _setupRole(DESIGNER, _msgSender());
        // _setupRole(MANUFACTURER, _msgSender());
        // _setupRole(SERVICER, _msgSender());
        // _setupRole(MAINTAINER, _msgSender());
        // _setupRole(RECYCLER, _msgSender());
    }

    event UpdateLife();
    event UpdateRole();
    event UpdateDesignDrawings();
    event UpdateManufacturingProgress();
    event UpdateServiceLogs();
    event UpdateMaintenanceLogs();
    event MintNFT();

    string public designDrawings;
    string public manufacturingProgress;
    string public serviceLogs;
    string public maintenanceLogs;


    /**
     * @dev Update the life cycle phase of the digital twin.
     *
     * Requirements:
     *
     * - the caller must have the `OWNER`.
     */
    function updatelife (uint256 state) public virtual {
        require(hasRole(OWNER, _msgSender()), "Updatelife: must have the correct role permissions");
        require(state ==1 || state ==2 || state ==3, "Updatelife: must have the correct state sequence number"); 
        _updatelife(state);
        emit UpdateLife();
    }

    function _updatelife (uint256 state) internal virtual {
        if (state == 1){
            attribute = Lifecyclstate.EarlyPhase;
        }else if (state == 2){
            attribute = Lifecyclstate.MediumPhase;
        }else {
            attribute = Lifecyclstate.LaterPhase;
        }
    }


    /**
     * @dev add/remove a account as the role of `DESIGNER`.
     *
     * Requirements:
     *
     * - the caller must have the `OWNER`.
     */

    function addDesigner(address designer_) external {
        require(hasRole(OWNER, _msgSender()), "addDesigner: must have the correct role permissions");
        grantRole(DESIGNER, designer_);
        emit UpdateRole();
    }

    function removeDesigner(address designer_) external {
        require(hasRole(OWNER, _msgSender()), "addDesigner: must have the correct role permissions");
        revokeRole(DESIGNER, designer_);
        emit UpdateRole();
    }

    /**
     * @dev add/remove a account as the role of `J_DESIGNER` and `S_DESIGNER`.
     *
     * Requirements:
     *
     * - the caller must have the `DESIGNER`.
     */

    function addJDesigner(address jdesigner_) external {
        require(hasRole(DESIGNER, _msgSender()), "addDesigner: must have the correct role permissions");
        grantRole(J_DESIGNER, jdesigner_);
        emit UpdateRole();
    }

    function removeJDesigner(address jdesigner_) external {
        require(hasRole(DESIGNER, _msgSender()), "addDesigner: must have the correct role permissions");
        revokeRole(J_DESIGNER, jdesigner_);
        emit UpdateRole();
    }
    function addSDesigner(address sdesigner_) external {
        require(hasRole(DESIGNER, _msgSender()), "addDesigner: must have the correct role permissions");
        grantRole(S_DESIGNER, sdesigner_);
        emit UpdateRole();
    }

    function removeSDesigner(address sdesigner_) external {
        require(hasRole(DESIGNER, _msgSender()), "addDesigner: must have the correct role permissions");
        revokeRole(S_DESIGNER, sdesigner_);
        emit UpdateRole();
    }

    /**
     * @dev add/remove a account as the role of `MANUFACTURER`.
     *
     * Requirements:
     *
     * - the caller must have the `OWNER`.
     */

    function addManufacturer(address manufacturer_) external {
        require(hasRole(OWNER, _msgSender()), "addDesigner: must have the correct role permissions");
        grantRole(MANUFACTURER, manufacturer_);
        emit UpdateRole();
    }

    function removeManufacturer(address manufacturer_) external {
        require(hasRole(OWNER, _msgSender()), "addDesigner: must have the correct role permissions");
        revokeRole(MANUFACTURER, manufacturer_);
        emit UpdateRole();
    }

    /**
     * @dev add/remove a account as the role of `AC_MANUFACTURER` and `AS_MANUFACTURER`.
     *
     * Requirements:
     *
     * - the caller must have the `MANUFACTURER`.
     */

    function addACManufacturer(address acmanufacturer_) external {
        require(hasRole(MANUFACTURER, _msgSender()), "addDesigner: must have the correct role permissions");
        grantRole(AC_MANUFACTURER, acmanufacturer_);
        emit UpdateRole();
    }

    function removeACManufacturer(address acmanufacturer_) external {
        require(hasRole(MANUFACTURER, _msgSender()), "addDesigner: must have the correct role permissions");
        revokeRole(AC_MANUFACTURER, acmanufacturer_);
        emit UpdateRole();
    }
    function addASManufacturer(address asmanufacturer_) external {
        require(hasRole(MANUFACTURER, _msgSender()), "addDesigner: must have the correct role permissions");
        grantRole(AS_MANUFACTURER, asmanufacturer_);
        emit UpdateRole();
    }

    function removeASManufacturer(address asmanufacturer_) external {
        require(hasRole(MANUFACTURER, _msgSender()), "addDesigner: must have the correct role permissions");
        revokeRole(AS_MANUFACTURER, asmanufacturer_);
        emit UpdateRole();
    }

    /**
     * @dev add/remove a account as the role of SERVICER`.
     *
     * Requirements:
     *
     * - the caller must have the `OWNER`.
     */

    function addServicer(address servicer_) external {
        require(hasRole(OWNER, _msgSender()), "addDesigner: must have the correct role permissions");
        grantRole(SERVICER, servicer_);
        emit UpdateRole();
    }

    function removeServicer(address servicer_) external {
        require(hasRole(OWNER, _msgSender()), "addDesigner: must have the correct role permissions");
        revokeRole(SERVICER, servicer_);
        emit UpdateRole();
    }

    /**
     * @dev add/remove a account as the role of `O_SERVICER` and `T_SERVICER`.
     *
     * Requirements:
     *
     * - the caller must have the `SERVICER`.
     */

    function addOServicer(address oservicer_) external {
        require(hasRole(SERVICER, _msgSender()), "addDesigner: must have the correct role permissions");
        grantRole(O_SERVICER, oservicer_);
        emit UpdateRole();
    }

    function removeOServicer(address oservicer_) external {
        require(hasRole(SERVICER, _msgSender()), "addDesigner: must have the correct role permissions");
        revokeRole(O_SERVICER, oservicer_);
        emit UpdateRole();
    }
    function addTServicer(address tservicer_) external {
        require(hasRole(SERVICER, _msgSender()), "addDesigner: must have the correct role permissions");
        grantRole(T_SERVICER, tservicer_);
        emit UpdateRole();
    }

    function removeTServicer(address tservicer_) external {
        require(hasRole(SERVICER, _msgSender()), "addDesigner: must have the correct role permissions");
        revokeRole(T_SERVICER, tservicer_);
        emit UpdateRole();
    }

    /**
     * @dev add/remove a account as the role of `MAINTAINER`.
     *
     * Requirements:
     *
     * - the caller must have the `OWNER`.
     */

    function addMaintainer(address maintainer_) external {
        require(hasRole(OWNER, _msgSender()), "addDesigner: must have the correct role permissions");
        grantRole(MAINTAINER, maintainer_);
        emit UpdateRole();
    }

    function removeMaintainer(address maintainer_) external {
        require(hasRole(OWNER, _msgSender()), "addDesigner: must have the correct role permissions");
        revokeRole(MAINTAINER, maintainer_);
        emit UpdateRole();
    }

    /**
     * @dev add/remove a account as the role of `RECYCLER`.
     *
     * Requirements:
     *
     * - the caller must have the `OWNER`.
     */
    function addRecycler(address recycler_) external {
        require(hasRole(OWNER, _msgSender()), "addDesigner: must have the correct role permissions");
        grantRole(RECYCLER, recycler_);
        emit UpdateRole();
    }

    function removeRecycler(address recycler_) external {
        require(hasRole(OWNER, _msgSender()), "addDesigner: must have the correct role permissions");
        revokeRole(RECYCLER, recycler_);
        emit UpdateRole();
    }



    /**
     * @dev Update design drawing .
     *
     * Requirements:
     *
     * - the caller must have the `DESIGNER`.
     */
    function addDesignDrawings(string memory drawings) public virtual {
        require(hasRole(DESIGNER, _msgSender()), "addDesignDrawings: must have the correct role permissions");
        designDrawings = drawings;
        emit UpdateDesignDrawings();
    }

    /**
     * @dev Update manufacturing progress .
     *
     * Requirements:
     *
     * - the caller must have the `MANUFACTURER`.
     */
    function addManufacturingProgress(string memory progress) public virtual {
        require(hasRole(MANUFACTURER, _msgSender()), "addManufacturingProgress: must have the correct role permissions");
        manufacturingProgress = progress;
        emit UpdateManufacturingProgress();
    }

    /**
     * @dev Update service logs .
     *
     * Requirements:
     *
     * - the caller must have the `SERVICER`.
     */
    function addServiceLogs(string memory slogs) public virtual {
        require(hasRole(SERVICER, _msgSender()), "addServiceLogs: must have the correct role permissions");
        serviceLogs = slogs;
        emit UpdateServiceLogs();
    }

    /**
     * @dev Update maintenance logs .
     *
     * Requirements:
     *
     * - the caller must have the `MAINTAINER`.
     */
    function addMaintenanceLogs(string memory mlogs) public virtual {
        require(hasRole(MAINTAINER, _msgSender()), "addMaintenanceLogs: must have the correct role permissions");
        maintenanceLogs = mlogs;
        emit UpdateMaintenanceLogs();
    }

    /**
     * @dev Creates `amount` new NFT for `to`, of token type `id`.
     *
     * See {ERC1155-_mint}.
     *
     * Requirements:
     *
     * - the caller must have the `RECYCLER`.
     */
    function mint(
        address to,
        uint256 amount,
        bytes memory data
    ) public virtual {
        require(hasRole(RECYCLER, _msgSender()), "DTNFTmint: must have the correct role permissions");
        _mint(to, _tokenIdTracker.current()+1, amount, data);
        _tokenIdTracker.increment();
        emit MintNFT();
    }


    /**
     * @dev Update the URI for all tokens.
     *
     * Requirements:
     *
     * - the caller must have the `OWNER`.
     */
    function setURI(string memory newuri) public virtual {
        require(hasRole(OWNER, _msgSender()), "DTNFTsetURI: must have the correct role permissions");
        _setURI(newuri);
    }

    /**
     * @dev See {IERC1155MetadataURI-uri}.
     *
     * This implementation returns the same URI for *all* token types. It relies
     * on the token type ID substitution mechanism
     * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
     *
     * Clients calling this function must replace the `\{id\}` substring with the
     * actual token type ID.
     */
    function uri(uint256 tokenId) public view virtual override(ERC1155, IERC1155MetadataURI) returns (string memory) {
        return string(abi.encodePacked(ERC1155.uri(tokenId), tokenId.toString(), ".json"));
    }


    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override(AccessControlEnumerable, CRC1155Enumerable, IERC165) returns (bool) {
        return AccessControlEnumerable.supportsInterface(interfaceId) || CRC1155Enumerable.supportsInterface(interfaceId);
    }

}
