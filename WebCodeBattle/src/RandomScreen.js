import React, { useCallback, useState } from "react";
import StackGrid from "react-stack-grid";
import Card from "./Card";
import { css } from "emotion";

const RandomScreen = props => {
  const [pickedItems, setPickedItems] = useState([]);
  const handleRandom = useCallback(
    e => {
      const picked = props.items
        .sort(() => 0.5 - Math.random())
        .slice(0, props.number);
      let index = 0;
      let currentPicked = [];
      const interval = setInterval(() => {
        currentPicked = currentPicked.concat([picked[index]]);
        setPickedItems(currentPicked);
        index++;
        if (index === picked.length) clearInterval(interval);
      }, 3000);
    },
    [props.items, props.number]
  );
  return (
    <>
      <button
        className={css`
          border: 0;
          outline: none;
          padding: 20px;
          font-size: 20px;
          background: #039be5;
          color: #fff;
          border-radius: 10px;
          margin-bottom: 20px;
          cursor: pointer;
          &:hover {
            background: #0d8dcc;
          }
        `}
        onClick={handleRandom}
      >
        Pick {props.number}
      </button>
      {pickedItems.length > 0 && (
        <StackGrid
          columnWidth={300}
          gutterWidth={10}
          gutterHeight={10}
          monitorImagesLoaded={true}
          className={css`
            margin-bottom: 20px;
          `}
        >
          {pickedItems.map(doc => (
            <Card data={doc} key={doc.id} />
          ))}
        </StackGrid>
      )}
    </>
  );
};

export default RandomScreen;
