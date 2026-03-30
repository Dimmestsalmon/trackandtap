CREATE TABLE "games" (
	"id" integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY (sequence name "games_id_seq" INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START WITH 1 CACHE 1),
	"player_one_id" varchar(256),
	"player_one_life" varchar(256),
	"player_two_id" varchar(256),
	"player_two_life" varchar(256),
	"player_three_id" varchar(256),
	"player_three_life" varchar(256),
	"player_four_id" varchar(256),
	"player_four_life" varchar(256),
	"player_five_id" varchar(256),
	"player_Five_life" varchar(256),
	"player_six_id" varchar(256),
	"player_Six_life" varchar(256)
);
