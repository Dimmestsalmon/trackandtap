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
    <div className='flex flex-row flex-1 grow items-center justify-center bg-black border border-white'>
      <button className='flex flex-1 grow items-center justify-center text-white text-6xl' onClick={loseLife}>-</button>
      <div className='flex flex-1 grow items-center justify-center text-white text-6xl'>{life}</div>
      <button className='flex flex-1 grow items-center justify-center text-white text-6xl' onClick={gainLife}>+</button>
    </div>
  )
};  