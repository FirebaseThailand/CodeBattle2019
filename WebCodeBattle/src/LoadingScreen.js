import React from "react";
import { css } from "emotion";
import RingLoader from "react-spinners/RingLoader";

const LoadingScreen = props => (
  <div
    className={css`
      width: 100%;
      display: flex;
      justify-items: center;
      flex-direction: column;
      justify-content: center;
      align-items: center;
      height: 60vh;
    `}
  >
    <RingLoader size={150} color="#ffcc36" />
  </div>
);

export default LoadingScreen;
