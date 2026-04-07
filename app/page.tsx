import {LifeTotal} from './components/playerLife';

export default function Home() {
  return (
    <div className='grid grid-cols-2 h-full'>
      <LifeTotal/>
      <LifeTotal/>
      <LifeTotal/>
      <LifeTotal/>
    </div>
  );
};
