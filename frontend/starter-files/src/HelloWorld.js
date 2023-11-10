import React from "react";
import { useEffect, useState } from "react";
import {
  helloWorldContract,
  connectWallet,
  updateMessage,
  loadCurrentMessage,
  getCurrentWalletConnected,
} from "./util/interact.js";
import CarImage from './assets/volkswagen.png';
import { LiaAngleRightSolid } from "react-icons/lia";
import {SiCarthrottle} from "react-icons/si";
import { PiEngineFill } from "react-icons/pi";
import {GiPathDistance} from "react-icons/gi";

const HelloWorld = () => {
  //state variables
  const [walletAddress, setWallet] = useState("");
  const [status, setStatus] = useState("");
  const [message, setMessage] = useState("No connection to the network.");
  const [carConnection, setCarConnection ] = useState(false);
  const [newMessage, setNewMessage] = useState("");
  const [carData, setCarData] = useState([]);

  //called only once
  useEffect(() => {
    
    addCarDataListener();

  }, []);

  async function addCarDataListener() {
    const response = await fetch("http://127.0.0.1:8000", {
      method: "GET",
      headers: {
        "Bypass-Tunnel-Reminder": "your-custom-value",
      },
    });
    const data = await response.json();
    console.log(data, "data");
    setCarData(data);
    setCarConnection(true);
  }

  // useEffect(async () => {}, []);

  function addSmartContractListener() { //TODO: implement
    
  }

  function addWalletListener() { //TODO: implement
    
  }

  const connectWalletPressed = async () => { //TODO: implement
    
  };

  const onUpdatePressed = async () => { //TODO: implement
    
  };

  //the UI of our component
  return (
    <div id="container">
      {/* <img id="logo" src={alchemylogo}></img> */}
      <button id="walletButton" onClick={connectWalletPressed}>
        {walletAddress.length > 0 ? (
          "Connected: " +
          String(walletAddress).substring(0, 6) +
          "..." +
          String(walletAddress).substring(38)
        ) : (
          <span>Connect Wallet</span>
        )}
      </button>

      <h2 style={{ paddingTop: "50px" }}>Connection status:</h2>
      <p>{carConnection ? "Car connected" : "Car not connected"}</p>

      <h2 style={{ paddingTop: "18px" }}>Here is the data from your car:</h2>

      <div>
        <div className="flex">
          <img src={CarImage} alt="car data" width="300px" />
        </div>
        <div className="flex">
          <button className="green_btn btn round_btn">Run Diagnostics</button>
        </div>

        <div>
          {
    Object.keys(carData).map(key => (
      // console.log(carData[key], "key");
      <>
    <div className="grid">
            <div className="icon-wrapper">
              <PiEngineFill size={20} />
            </div>
            <div className="">
              <div className="field about">
                <p>{carData[key].command.name}</p>
                <span className="mt-1">
                  <LiaAngleRightSolid size={20} />
                </span>{" "}
              </div>
              <div className="field about text">
                <p className="mr-1">some text</p>{" "}
                <span className="round-ball red mr-1">3</span>
                <p className="mr-1">some text</p>{" "}
                <span className="round-ball yellow mr-1">3</span>
                <p className="mr-1">some text</p>{" "}
                <span className="round-ball green">3</span>
              </div>
            </div>

          
          </div>
          <hr />
  </>
    ))
  }
        </div>
      </div>

      {/* <div>
        <input
          type="text"
          placeholder="Update the message in your smart contract."
          onChange={(e) => setNewMessage(e.target.value)}
          value={newMessage}
        />
        <p id="status">{status}</p>

        <button id="publish" onClick={onUpdatePressed}>
          Update
        </button>
      </div> */}
    </div>
  );
};

export default HelloWorld;
