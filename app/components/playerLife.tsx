"use client"

import { useState } from "react";

export const LifeTotal = () => {

  const [life, setLife] = useState(40)

  const gainLife = () => {
    setLife(life => life+1);
  }

  const loseLife = () => {
    setLife(life => life-1);
  }

  
 
  
  return (
    <div className='flex flex-row flex-1 grow items-center justify-center bg-yellow-300 border border-black'>
      <button className='flex flex-1 grow items-center justify-center' onClick={loseLife}>-</button>
      <div className='flex flex-1 grow items-center justify-center'>{life}</div>
      <button className='flex flex-1 grow items-center justify-center' onClick={gainLife}>+</button>
    </div>
  )
};