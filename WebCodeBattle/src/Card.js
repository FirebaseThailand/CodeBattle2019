import React from "react";
import { css } from "emotion";

const Card = ({ data }) => (
  <div
    className={css`
      box-shadow: 3px 3px 10px 2px rgba(0, 0, 0, 0.27);
      border-radius: 10px;
    `}
  >
    <img
      className={css`
        width: 100%;
        border-radius: 10px 10px 0 0;
        display: block;
      `}
      alt={data.caption}
      src={data.thumbUrl}
    />
    <div className={css``}>
      <p
        className={css`
          margin: 0;
          padding: 10px 15px;
        `}
      >
        {data.caption}
      </p>
    </div>
  </div>
);

export default Card;
