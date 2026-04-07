import Image from "next/image";
import {LifeTotal} from './components/playerLife.tsx';

export default function Home() {
  return (
    <div className='flex flex-1 flex-col'>
      <LifeTotal/>
    </div>
  );
};
