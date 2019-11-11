import React from "react";
import { css } from "emotion";

const Layout = props => (
  <div
    className={css`
      max-width: 1240px;
      margin: 0 auto;
      width: 100%;
      padding-bottom: 20px;
    `}
  >
    <nav
      className={css`
        display: grid;
        grid-template-columns: auto min-content;
        align-items: center;
      `}
    >
      <h1
        className={css`
          align-self: center;
          font-size: 40px;
          font-weight: 300;
        `}
      >
        Code Battle{" "}
        <span
          className={css`
            font-size: 25px;
            color: #777;
          `}
        >
          Firebase Dev Day 2019
        </span>
      </h1>
      <img
        alt="Firebase Logo"
        className={css`
          width: 200px;
        `}
        src="/images/firebase.svg"
      />
    </nav>
    {props.children}
  </div>
);

export default Layout;
