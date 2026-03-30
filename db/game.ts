import { AnyPgColumn } from 'drizzle-orm/pg-core';
import { pgEnum, pgTable as table } from 'drizzle-orm/pg-core';
import * as t from 'drizzle-orm/pg-core';

export const games = table(
	'games',
	{
		id: t.integer().primaryKey().generatedAlwaysAsIdentity(),
		playerOneId: t.varchar('player_one_id', { length: 256 }),	
		playerOneLife: t.varchar('player_one_life', { length: 256 }),
		playerTwoId: t.varchar('player_two_id', { length: 256 }),
		playerTwoLife: t.varchar('player_two_life', { length: 256 }),
		playerThreeId: t.varchar('player_three_id', { length: 256 }),
		playerThreeLife: t.varchar('player_three_life', { length: 256 }),
		playerFourId: t.varchar('player_four_id', { length: 256 }),
		playerFourLife: t.varchar('player_four_life', { length: 256 }),
		playerFiveId: t.varchar('player_five_id', { length: 256 }),
		playerFiveLife: t.varchar('player_Five_life', { length: 256 }),
		playerSixId: t.varchar('player_six_id', { length: 256 }),
		playerSixLife: t.varchar('player_Six_life', { length: 256 }),
}
)
