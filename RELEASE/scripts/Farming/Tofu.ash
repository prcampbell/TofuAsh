/*
    Tofu Outfit:

    Eldritch Hat
    Buddy Bjorn
    Shirt?
    Eldritch Pants
    Garbage Sticker
    Sneegleeb
    Lucky Gold Ring?
    Mafia Thumb Ring
    Mr. Cheeng's Spectacles
    Hookah?

    Pickpocket Runaway Outfit (Pickpocket Chance/Familiar Weight):
    FantasyRealm Rogue's Mask / Mushroom Cap
    Duke Vampire's Regal Cloak
    Shirt?
    Leggings of the Spider Queen / Mushroom Pants
    Weapon?
    Offhand? / Mushroom Shield
    Master Thief's UtilityBelt / Mushroom Badge
    Accessory? 
    Accessory?
    Familiar Equip?

    Barf Farming Outfit:
    Jokester's Wig
    Buddy Bjorn
    Shirt?
    Jokester's Pants
    Jokester's Gun
    Sneegleeb
    Mafia Thumb Ring
    Accessory?
    Accessory?

    Pajamas:
    Gladiator Glad Rags

*/

boolean isFarmingDay = false;

familiar ChooseFamiliar()
{
    foreach f in $familiars[Li'l Xenomorph]
    //$familiars[Li'l Xenomorph, Pair of Stomping Boots]
    {
        if ( have_familiar(f) && f.drops_today < 5 )
			return f;
        if ( f == $familiar[Pair of Stomping Boots] && f.drops_today < 7)
            return f;
    }
			
    return $familiar[Obtuse Angel];
}

familiar ChooseFamiliar(boolean FreeFight)
{
    if(FreeFight)
    {
        foreach f in $familiars[Rogue Program]
        {
            if (have_familiar(f) && f.drops_today < 5 )
                return f;
            return $familiar[Unspeakachu];
        }
    }
    
    return ChooseFamiliar();

}

boolean have(item it) 
{
	return it.item_amount() > 0;
}

boolean __voting_setting_allow_ml = true; //set to false if you do not want +monster level in-run
boolean __voting_setting_make_extra_adventure_in_run_super_important = false; //set to true if you always want that +1 adventure. high-end runs don't?

boolean __voting_setting_use_absentee_ballots = true;
boolean __voting_setting_confirm_initiatives_in_run = false; //set this to true if you want a confirmation box before we vote. or just vote by hand
string __voting_version = "2.0.2";

//Higher is better. Identical is random.
//Default: Vote for ghosts, random otherwise.
//Bias towards bureaucrats, because we want absentee ballots.
int [monster] __voting_setting_monster_priorities =
{
	$monster[Angry ghost]:0, //harder to fight in-run, but give in-run goodies
	$monster[government bureaucrat]:5, //nice for absentee ballots, but
	$monster[Terrible mutant]:0, //technically optimal in-run, but the effect is minor
	$monster[Slime blob]:0, //harder to fight in-run
	$monster[Annoyed snake]:0,
};




boolean [string] __voting_negative_effects = $strings[Add sedatives to the water supply.,Distracting noises broadcast through compulsory teeth-mounted radio receivers.,Emissions cap on all magic-based combustion.,Exercise ban.,Mandatory 6pm curfew.,Requirement that all weapon handles be buttered.,Safety features added to all melee weapons.,Shut down all local dog parks.,State nudity initiative.,Vaccination reversals for all citizens.,All bedsheets replaced with giant dryer sheets.,All citizens required to look <i>all four</i> ways before crossing the street.,Ban on petroleum-based gels and pomades.,Increased taxes at all income levels.,Mandatory item tithing.,Reduced public education spending.];

//allow_interacting_with_user set to false disables a user_confirm, so the user cannot prevent a script from obtaining the voted badge
void voteInVotingBooth(boolean allow_interacting_with_user)
{
	if (to_item("&quot;I Voted!&quot; sticker").available_amount() > 0)
	{
		print("Already voted today.");
		return;
	}
	print_html("VotingBooth v" + __voting_version + ".");
	buffer page_text = visit_url("place.php?whichplace=town_right&action=townright_vote");
	
	if (page_text.contains_text("Here is the impact of your local ballot initiatives"))
	{
		print("Already voted today.");
		return;
	}
	if (__voting_setting_use_absentee_ballots && !get_property("voteAlways").to_boolean() && page_text.contains_text("<b>The Right Side of the Tracks</b>") && to_item("absentee voter ballot").item_amount() > 0)
	{
		print("Voting with ballot!");
		
		page_text = visit_url("inv_use.php?whichitem=9991");
	}
	
	
	
	//Here's where the script decides which initiatives are best.
	//I spent like ten seconds on it, so feel free to change it.
	//Larger numbers are the best initiatives.
	float [string] initiative_priorities;
	initiative_priorities["State-mandated bed time of 8PM."] = 100; //+1 Adventure(s) per day
	initiative_priorities["Repeal leash laws."] = 25; //+2 Familiar Experience Per Combat
	initiative_priorities["Institute GBLI (Guaranteed Basic Loot Income.)"] = 50; //+15% Item Drops from Monsters
	initiative_priorities["Reduced taxes at all income levels."] = 45; //+30% Meat from Monsters
	initiative_priorities["Mandatory morning calisthenics for all citizens."] = 42; //Muscle +25%
	initiative_priorities["Compulsory dance lessons every weekend."] = 41; //Moxie +25%
	initiative_priorities["Replace all street signs with instructions for arcane rituals."] = 40; //Mysticality +25%
	initiative_priorities["Addition of 37 letters to end of alphabet so existing names are all earlier in queues."] = 35; //+25% Combat Initiative
	initiative_priorities["Subsidies for health potion manufacturers."] = 32; //Maximum HP +30%
	initiative_priorities["Open a local portal to a dimension of pure arcane power."] = 31; //Spell Damage +20%
	initiative_priorities["Free civic weapon sharpening program."] = 31; //Weapon Damage +100%
	initiative_priorities["Require all garments to be fleece-lined."] = 30; //Serious Cold Resistance (+3)
	initiative_priorities["Make all new clothes out of asbestos."] = 30; //Serious Hot Resistance (+3)
	initiative_priorities["Widespread distribution of \"CENSORED\" bars."] = 30; //Serious Sleaze Resistance (+3)
	initiative_priorities["Outlaw black clothing and white makeup."] = 30; //Serious Spooky Resistance (+3)
	initiative_priorities["Free public nose-plug dispensers."] = 30; //Serious Stench Resistance (+3)
	initiative_priorities["A chicken in every pot!"] = 25; //+30% Food Drops from Monsters
	initiative_priorities["Carbonate the water supply."] = 20; //Maximum MP +30%
	initiative_priorities["Kingdomwide air-conditioning subsidies."] = 20; //+10 Cold Damage
	initiative_priorities["Pocket flamethrowers issued to all citizens."] = 20; //+10 Hot Damage
	initiative_priorities["Artificial butter flavoring dispensers on every street corner."] = 20; //+10 Sleaze Damage
	initiative_priorities["All forms of deodorant are now illegal."] = 20; //+10 Stench Damage
	initiative_priorities["All forms of deodorant are now illegal."] = 20; //+10 Stench Damage
	initiative_priorities["Compulsory firearm and musical instrument safety training for all citizens."] = 20; //Ranged Damage +100%
	initiative_priorities["Emergency eye make-up stations installed in all public places."] = 15; //+4 Moxie Stats Per Fight
	initiative_priorities["Require boxing videos to be played on all bar televisions."] = 15; //+4 Muscle Stats Per Fight
	initiative_priorities["Deployment of a network of aerial mana-enhancement drones."] = 15; //+4 Mysticality Stats Per Fight
	initiative_priorities["Municipal journaling initiative."] = 15; //+3 Stats Per Fight
	initiative_priorities["Happy Hour extended by 23 additional hours."] = 10; //+30% Booze Drops from Monsters
	initiative_priorities["Subsidies for dentists."] = 10; //+30% Candy Drops from Monsters
	initiative_priorities["Sales tax free weekend for back-to-school shopping."] = 10; //+30% Gear Drops from Monsters
	initiative_priorities["Ban belts."] = 10; //+30% Pants Drops from Monsters
	initiative_priorities["Mandatory martial arts classes for all citizens."] = 0; //+20 Damage to Unarmed Attacks
	initiative_priorities["\"Song that Never Ends\" pumped throughout speakers in all of Kingdom."] = -100; //+10 to Monster Level
	
	if (my_path().id == 35) //can't +hp
		initiative_priorities["Subsidies for health potion manufacturers."] = -100; //Maximum HP +30%

	string [string] initiative_descriptions;
	initiative_descriptions["State-mandated bed time of 8PM."] = "+1 Adventure(s) per day";
	initiative_descriptions["Repeal leash laws."] = "+2 Familiar Experience Per Combat";
	initiative_descriptions["Emergency eye make-up stations installed in all public places."] = "+4 Moxie Stats Per Fight";
	initiative_descriptions["Require boxing videos to be played on all bar televisions."] = "+4 Muscle Stats Per Fight";
	initiative_descriptions["Deployment of a network of aerial mana-enhancement drones."] = "+4 Mysticality Stats Per Fight";
	initiative_descriptions["\"Song that Never Ends\" pumped throughout speakers in all of Kingdom."] = "+10 to Monster Level";
	initiative_descriptions["Institute GBLI (Guaranteed Basic Loot Income.)"] = "+15% Item Drops from Monsters";
	initiative_descriptions["Municipal journaling initiative."] = "+3 Stats Per Fight";
	initiative_descriptions["Reduced taxes at all income levels."] = "+30% Meat from Monsters";
	initiative_descriptions["Compulsory dance lessons every weekend."] = "Moxie +25%";
	initiative_descriptions["Mandatory morning calisthenics for all citizens."] = "Muscle +25%";
	initiative_descriptions["Replace all street signs with instructions for arcane rituals."] = "Mysticality +25%";
	initiative_descriptions["Open a local portal to a dimension of pure arcane power."] = "Spell Damage +20%";
	initiative_descriptions["Subsidies for health potion manufacturers."] = "Maximum HP +30%";
	initiative_descriptions["Require all garments to be fleece-lined."] = "Serious Cold Resistance (+3)";
	initiative_descriptions["Make all new clothes out of asbestos."] = "Serious Hot Resistance (+3)";
	initiative_descriptions["Widespread distribution of \"CENSORED\" bars."] = "Serious Sleaze Resistance (+3)";
	initiative_descriptions["Outlaw black clothing and white makeup."] = "Serious Spooky Resistance (+3)";
	initiative_descriptions["Free public nose-plug dispensers."] = "Serious Stench Resistance (+3)";
	initiative_descriptions["Free civic weapon sharpening program."] = "Weapon Damage +100%";
	initiative_descriptions["Addition of 37 letters to end of alphabet so existing names are all earlier in queues."] = "+25% Combat Initiative";
	initiative_descriptions["A chicken in every pot!"] = "+30% Food Drops from Monsters";
	initiative_descriptions["Carbonate the water supply."] = "Maximum MP +30%";
	initiative_descriptions["Kingdomwide air-conditioning subsidies."] = "+10 Cold Damage";
	initiative_descriptions["Pocket flamethrowers issued to all citizens."] = "+10 Hot Damage";
	initiative_descriptions["Artificial butter flavoring dispensers on every street corner."] = "+10 Sleaze Damage";
	initiative_descriptions["All forms of deodorant are now illegal."] = "+10 Stench Damage";
	initiative_descriptions["All forms of deodorant are now illegal."] = "+10 Stench Damage";
	initiative_descriptions["Compulsory firearm and musical instrument safety training for all citizens."] = "Ranged Damage +100%";
	initiative_descriptions["Happy Hour extended by 23 additional hours."] = "+30% Booze Drops from Monsters";
	initiative_descriptions["Subsidies for dentists."] = "+30% Candy Drops from Monsters";
	initiative_descriptions["Sales tax free weekend for back-to-school shopping."] = "+30% Gear Drops from Monsters";
	initiative_descriptions["Ban belts."] = "+30% Pants Drops from Monsters";
	initiative_descriptions["Mandatory martial arts classes for all citizens."] = "+20 Damage to Unarmed Attacks";

	initiative_descriptions["Add sedatives to the water supply."] = "-10 to Monster Level";
	initiative_descriptions["Distracting noises broadcast through compulsory teeth-mounted radio receivers."] = "-3 Stats Per Fight";
	initiative_descriptions["Emissions cap on all magic-based combustion."] = "Spell Damage -50%";
	initiative_descriptions["Exercise ban."] = "Muscle -20";
	initiative_descriptions["Mandatory 6pm curfew."] = "+-2 Adventure(s) per day";
	initiative_descriptions["Requirement that all weapon handles be buttered."] = "-10% chance of Critical Hit";
	initiative_descriptions["Safety features added to all melee weapons."] = "Weapon Damage -50%";
	initiative_descriptions["Shut down all local dog parks."] = "-2 Familiar Experience Per Combat";
	initiative_descriptions["State nudity initiative."] = "-50% Gear Drops from Monsters";
	initiative_descriptions["Vaccination reversals for all citizens."] = "Maximum HP -50%";
	initiative_descriptions["All bedsheets replaced with giant dryer sheets."] = "Maximum MP -50%";
	initiative_descriptions["All citizens required to look <i>all four</i> ways before crossing the street."] = "-30% Combat Initiative";
	initiative_descriptions["Ban on petroleum-based gels and pomades."] = "Moxie -20";
	initiative_descriptions["Increased taxes at all income levels."] = "-30% Meat from Monsters";
	initiative_descriptions["Mandatory item tithing."] = "-20% Item Drops from Monsters";
	initiative_descriptions["Reduced public education spending."] = "Mysticality -20";
	
	string [int][int] platform_matches = page_text.group_string("<blockquote>(.*?)</blockquote>");
	
	int desired_g = random(2) + 1;
	
	//Bias the global votes towards ghosts:
	if (platform_matches.count() == 2)
	{
		//Angry ghost, government bureaucrat, Terrible mutant, Annoyed snake, Slime blob
		monster [int] platform_for_g;
		foreach key in platform_matches
		{
			string platform_raw_text = platform_matches[key][1];
			monster platform;
			foreach s in $strings[curtailing of unnatural modern technologies such as electricity and round ears,implement healthcare reforms to ensure every citizen is healthy and filled,enact strictly enforced efficiency laws,some people are performing counter-rituals to prevent the summoning,enact a rigorous and comprehensive DNA harvesting program] //'
			{
				if (platform_raw_text.contains_text(s))
					platform = $monster[government bureaucrat];
			}
			foreach s in $strings[proposing a hefty tax break for any citizen willing to undergo an easy and harmless medical procedure to reintroduce Pork Elf DNA into our gene pool,vouldn't you like to be even stronger and more vigorous,medical care is one of the largest sources of waste and inefficiency in our government,elected I will begin a program of rituals that will open the public's minds to his good and cool energies,chemical that my people use to ensure we have all the correct vitamins and minerals for the health of our physical bodies] //'
			{
				if (platform_raw_text.contains_text(s))
					platform = $monster[Terrible mutant];
			}
			foreach s in $strings[seance to summon their ancient spirits,you like to see your deceased loved ones again,don't think I need to tell you that graveyards are a terribly inefficient use of space,is possible that this might displace and anger your,How could you possibly vote against kindness energy] //'
			{
				if (platform_raw_text.contains_text(s))
					platform = $monster[Angry ghost];
			}
			foreach s in $strings[clear from the writings and art of the ancient Pork Elves is that they were very interested in snakes,believe you humans have a popular snack you,has determined that the Kingdom's wildlife has far more legs than is ef,Smiling Teeth prophesizes that the Good and Normal One will arrive to the sound of a great hissing,would be happy to gift you with a breeding pair of these delightful creatures] //'
			{
				if (platform_raw_text.contains_text(s))
					platform = $monster[Annoyed snake];
			}
			foreach s in $strings[one thing that we're pretty sure about is that lard was very important to them,selfish that we vampires do not share our Darke Gifte with everyone,propose a program of breeding and releasing ambulatory garbage,need to make things a little bit more like he's used to,all your quaint little tourist attractions and so on] //'
			{
				if (platform_raw_text.contains_text(s))
					platform = $monster[Slime blob];
			}
			platform_for_g[key + 1] = platform;
		}
		
		if (__voting_setting_monster_priorities[platform_for_g[1]] > __voting_setting_monster_priorities[platform_for_g[2]])
			desired_g = 1;
		else if (__voting_setting_monster_priorities[platform_for_g[2]] > __voting_setting_monster_priorities[platform_for_g[1]])
			desired_g = 2;
		
		print("Voting for " + platform_for_g[desired_g] + " over " + (desired_g == 1 ? platform_for_g[2] : platform_for_g[1]) + ".");
	}

	string [int][int] local_initiative_matches = page_text.group_string("<input type=\"checkbox\".*?value=\"([0-9])\".*?> (.*?)<br");
	
	string [int] initiative_names;
	int [string] initiative_values;
	string log_delimiter = "•";
	
	buffer log;
	log.append("VOTING_BOOTH_LOG");
	log.append(log_delimiter);
	log.append(my_daycount());
	log.append(log_delimiter);
	log.append(my_class());
	log.append(log_delimiter);
	log.append(my_path().name);
	print_html("<strong>Available initiatives:</strong>");
	foreach key in local_initiative_matches
	{
		int initaitive_value = local_initiative_matches[key][1].to_int();
		string initiative_name = local_initiative_matches[key][2];
		
		
		log.append(log_delimiter);
		log.append(initiative_name);
		
		//print_html("\"" + initiative_name + "\": " + initaitive_value + " (" + initiative_descriptions[initiative_name] + ")");
		print_html("&nbsp;&nbsp;&nbsp;&nbsp;" + initiative_descriptions[initiative_name]);
		if (__voting_negative_effects contains initiative_name) continue;
		
		
		initiative_names[initiative_names.count()] = initiative_name;
		initiative_values[initiative_name] = initaitive_value;
		
		if (!(initiative_priorities contains initiative_name))
			abort("Unknown initiative \"" + initiative_name + "\". Tell Ezandora about it, there's probably some one-character typo somewhere.");
		float priority = initiative_priorities[initiative_name];
		
	}
	print_html("");
	logprint(log);
	sort initiative_names by -initiative_priorities[value];
	if (initiative_names.count() < 2)
	{
		print_html("Internal error: Not enough local initiatives.");
		visit_url("choice.php?option=2&whichchoice=1331"); //cancel out
		return;
	}
	print_html("<strong>Chosen initiatives:</strong>");
	foreach key, name in initiative_names
	{
		if (key > 1) continue;
		print_html("&nbsp;&nbsp;&nbsp;&nbsp;" + initiative_descriptions[name]);
	}
	if (__voting_setting_confirm_initiatives_in_run && (true || !can_interact()))
	{
		boolean yes = user_confirm("Do you want to vote for these initiatives?\n\n" + initiative_descriptions[initiative_names[0]] + "\n" + initiative_descriptions[initiative_names[1]]);
		if (!yes)
		{
			print_html("Not voting.");
			return;
		}
	}
	//print_html("initiative_names = " + initiative_names.to_json());
	visit_url("choice.php?option=1&whichchoice=1331&g=" + desired_g + "&local[]=" + initiative_values[initiative_names[0]] + "&local[]=" + initiative_values[initiative_names[1]]);
	
	//https://www.kingdomofloathing.com/choice.php?pwd&option=1&whichchoice=1331&g=1&local[]=0&local[]=2
	//pwd&option=1&whichchoice=1331&g=1&local%5B%5D=0&local%5B%5D=2
	//option=1&whichchoice=1331&g=
	//g - 1 or 2, depending on the global vote
}


boolean doVoterFight()
{
    if (available_amount($item[&quot;I Voted!&quot; sticker]) == 0) 
    {
      return false;
    }

    boolean freeFight = get_property("_voteFreeFights").to_int() < 3;

    if (!freeFight) 
    {

      if (!isFarmingDay) 
      {
        return false;
      }

      if (get_property("_voteMonster") != "government bureaucrat") 
      {
        return false;
      }

    }

    boolean vote_fight_now = get_property("_voteFreeFights") < 3 && (total_turns_played() % 11) == 1 && get_property("lastVoteMonsterTurn") < total_turns_played();

    if (!vote_fight_now) 
    {
      return false;
    } 

    print(
      "Someone is trying to take away my gun rights! I voted for those! Not today!",
      "gray"
    );

    cli_execute('outfit Voter');
    ChooseFamiliar(freeFight);

    adv1($location["The Electric Lemonade Acid Parade"], 1, "");

    cli_execute('outfit TofuFarming');

    return true;
  }


//
// ENSURE WE ARE IN THE CORRECT STATE
//

if(get_property('breakfastCompleted') == 'false')
{
    cli_execute('call TakeStash');

    //cli_execute('closet put * meat; closet take 1000000 meat;');
    
    //
    // Gather Resources
    //

    cli_execute('make 20 meat paste');

    if(item_amount($item[A Light That Never Goes Out]) < 15)
    {
        retrieve_item(4, $item[recording of Inigo's Incantation of Inspiration]); //105 000
        use(4, $item[recording of Inigo's Incantation of Inspiration]);
        retrieve_item(16, $item[lump of Brituminous coal]); 
        cli_execute('make 16 a light that never goes out');
    }
    
    retrieve_item(2, $item[Louder than Bomb]); //14 000
    retrieve_item(1, $item[absentee voter ballot]);
    retrieve_item(2, $item[Divine champagne popper]); //16 000
    retrieve_item(2, $item[tennis ball]); //16 000
    retrieve_item(2, $item[Spooky music box mechanism]); //400
    retrieve_item(1, $item[crystal skull]); //6 500
    buy(1, $item[human musk]); //100
    buy(1, $item[map to a candy-rich block]);
    retrieve_item(15, $item[meat paste]); //1 500
    retrieve_item(1, $item[borrowed time]); //8 000
    retrieve_item(1, $item[software glitch]); //12 000
    retrieve_item(5, $item[glark cable]); //30 000
    retrieve_item(3, $item[lynyrd snare]); //7 500
    retrieve_item(11, $item[bowl of scorpions]); //5 500
    retrieve_item(2, $item[Flaskfull of Hollow]); //14 000
    if(item_amount($item[shaking 4-d camera]) == 0)
        retrieve_item(1, $item[4-d camera]); //8 000
    retrieve_item(5, $item[hair spray]); //500
    if(item_amount($item[bacon]) > 110 && !get_property('_internetPrintScreenButtonBought').to_boolean())
        buy($coinmaster[internet meme shop], 1, $item[print screen button]);
    if(item_amount($item[snow berries]) > 2 && item_amount($item[ice harvest]) > 2)
        retrieve_item($item[unfinished ice sculpture]);
    if(item_amount($item[BRICKO eye brick]) > 2)
        retrieve_item(3, $item[BRICKO ooze]);
    if(my_meat() > 1000000)
        retrieve_item(10, $item[BRICKO ooze]);
    /*
    retrieve_item(10, $item[VYKEA Rail]); //130 000
    retrieve_item(1, $item[VYKEA Instructions]); //7 000
    retrieve_item(1, $item[VYKEA Dowel]); //1 500
    */
    if(my_meat() > 1000000 && mall_price($item[bag of foreign bribes]) < 100000)
    {
        buy(1, $item[bag of foreign bribes]);
        use(1, $item[bag of foreign bribes]);
    }
    if(item_amount($item[moveable feast]) > 0)
    {
        use_familiar($familiar[frumious bandersnatch]);
        use(1, $item[moveable feast]);
        use_familiar($familiar[rogue program]);
        use(1, $item[moveable feast]);
        use_familiar($familiar[obtuse angel]);
        use(1, $item[moveable feast]);
        use_familiar($familiar[Li'l Xenomorph]); //'    
        use(1, $item[moveable feast]);
        use_familiar($familiar[Unspeakachu]); //'    
        use(1, $item[moveable feast]);
        put_stash(1, $item[moveable feast]);
    }

    if(get_campground() contains $item[spinning wheel])
    {
        if(!get_property('_spinningWheel').to_boolean())
            visit_url('campground.php?action=spinningwheel');
        use(1, $item[snow machine]);
        cli_execute('garden pick');
        cli_execute('breakfast');
    }
    if(get_campground() contains $item [snow machine])
    {
        cli_execute('garden pick');
        cli_execute('breakfast');
        use(1, $item[spinning wheel]);
        visit_url('campground.php?action=spinningwheel');
    }

    voteInVotingBooth(false);
      
}
    
//cli_execute("charpane.php");
//cli_execute("chat");
cli_execute("refresh all");



foreach it in $items[stinky cheese eye, stinky cheese sword, stinky cheese diaper, stinky cheese wheel]
    if(stash_amount(it) > 0)
    {
        take_stash(1, it);
        if(item_amount($item[stinky cheese eye]) == 0)
        {
            cli_execute('fold stinky cheese eye');
            break;
        }
    }


//
// GENERATE ADVENTURES
//
if (my_absorbs() < 15) 
{
	if (have_effect($effect[In Your Cups]) > 250) 
    	{   
        	while (my_absorbs() < 15) 
        	{
			retrieve_item(1, $item[A Light That Never Goes Out]);
            		cli_execute("absorb light that never goes out");
		}
		use(2, $item[Flaskfull of Hollow]);
        isFarmingDay = true;
	} 
    else 
    {
		while (my_absorbs() < 15) 
        {
			retrieve_item(1, $item[meat paste]);
			cli_execute("absorb meat paste");
		}
	}
}

//Essential Tofu

if (!(to_boolean(get_property("_essentialTofuUsed"))) && item_amount($item[Essential Tofu]) > 1) 
{
	use(1, $item[Essential Tofu]);
}

//Time's Arrow

if (get_property("_timeArrowSent") == "" && item_amount($item[Time's Arrow]) > 1)  //'
{
	cli_execute("send time's arrow to botticelli"); //'
	set_property("_timeArrowSent", "true");
}

//Ancestral Recall
if (my_meat() > 1000000 && have_skill($skill[Ancestral Recall])) 
{
    while (to_int(get_property("_ancestralRecallCasts")) < 10) 
    {
	    if (retrieve_item(1, $item[Blue Mana])) 
        {
		    use_skill(1, $skill[Ancestral Recall]);
        } 
        else 
        {
            break;
        }
    }
}

//Etched Hourglass
if (!(to_boolean(get_property("_etchedHourglassUsed")))) 
{
	use(1, $item[Etched Hourglass]);
}

//Chocolates

if (my_meat() > 1000000) 
{
    while (to_int(get_property("_chocolatesUsed")) < 2) 
    {
        if (retrieve_item(1, $item[Chocolate Stolen Accordion])) 
        {
            use(1, $item[Chocolate Stolen Accordion]);
        } else 
        {
            break;
        }
	}
}

//Love Chocolate
if (my_meat() > 1000000 && get_property('_loveChocolatesUsed').to_int() == 0) 
{
    cli_execute('csend 20000 meat to sellbot || LOV Extraterrestrial Chocolate (1)');
    if(item_amount($item[LOV Extraterrestrial Chocolate]) > 1)
        use(1,$item[LOV Extraterrestrial Chocolate]);
} 

use(1, $item[Bittycar Meatcar]);


//
// Free Fights
//
/*
if(item_amount($item[volcoino]) > 2 && user_confirm("Have 3 Volcoinos, do you want to open Volcano?"))
{
    print('Volcano Day!');
    abort();
}
*/

set_auto_attack('TofuFarming');
cli_execute('outfit FreeFights');
use_familiar($familiar[Obtuse Angel]);
equip($item[quake of arrows]);

if(have_effect($effect[Ode to Booze]) == 0)
{
    cli_execute("csend to buffy || ode");
}

cli_execute("csend to buffy || empathy lyric");
cli_execute("mood apathetic");

// Fax
if(available_amount($item[photocopied monster]) == 0 && !get_property('_photocopyUsed').to_boolean())
{
    //faxbot($monster[swarm of fudge wasps], 'CheeseFax');
    
    //if(mall_price($item[jumping horseradish]) > mall_price($item[sacramento wine]))
    //    faxbot($monster[Witchess Knight], 'CheeseFax');
    //else
    //    faxbot($monster[Witchess Bishop], 'CheeseFax');
    cli_execute('fax receive');
}

foreach it in $items[photocopied monster, ice sculpture, screencapped monster, shaking 4-d camera]
{
    use_familiar(ChooseFamiliar(true));
    equip($slot[familiar], $item[Mayflower bouquet]);
    if(get_property('_cameraUsed').to_boolean())
    {
        put_closet(item_amount($item[4-d camera]), $item[4-d camera]);
    }
    if(item_amount(it) > 0)
        use(1, it);
}

while(item_amount($item[spooky putty monster]) > 0)
{
    use_familiar(ChooseFamiliar(true));
    equip($slot[familiar], $item[Mayflower bouquet]);
    if(item_amount($item[hair spray]) > 5 - get_property('spookyPuttyCopiesMade').to_int())
        put_closet(item_amount($item[hair spray]), $item[hair spray]);
    retrieve_item(5 - get_property('spookyPuttyCopiesMade').to_int(), $item[hair spray]);
    use(1, $item[spooky putty monster]);
}
if(item_amount($item[spooky putty sheet]) > 0)
    cli_execute('stash put 1 spooky putty sheet');

while(get_property("_lynyrdSnareUses").to_int() < 3)
{
    use_familiar(ChooseFamiliar(true));
    equip($slot[familiar], $item[Mayflower bouquet]);
    use(1, $item[lynyrd snare]);
}

if(!get_property('_firedJokestersGun').to_boolean()) 
{
    use_familiar(ChooseFamiliar(true));
    equip($slot[familiar], $item[Mayflower bouquet]);
    adv1($location[noob cave], -1, "");
}  

while(get_property('_drunkPygmyBanishes').to_int() < 11)
{
    use_familiar(ChooseFamiliar(true));
    equip($slot[familiar], $item[Mayflower bouquet]);
    adv1($location[The Hidden Bowling Alley], -1, "");
}

while(get_property('_glarkCableUses').to_int() < 5)
{
    
    use_familiar(ChooseFamiliar(true));
    equip($slot[familiar], $item[Mayflower bouquet]);
    adv1($location[The Red Zeppelin], -1, "");
}

while(get_property('_brickoFights').to_int() < 10 && item_amount($item[BRICKO ooze]) > 0)
{
    use_familiar(ChooseFamiliar(true));
    equip($slot[familiar], $item[Mayflower bouquet]);
    use(1, $item[BRICKO ooze]);
}

if(!get_property("_eldritchTentacleFought").to_boolean())
{
    visit_url("place.php?whichplace=forestvillage&action=fv_scientist");
	run_choice($item[eldritch essence].have() ? 2 : 1);
}

equip($item[Greatest American Pants]);
use_familiar($familiar[Unspeakachu]);

while(get_property('_navelRunaways').to_int() < 3)
    adv1($location[The Haunted Library], -1, '');

if(have_effect($effect[Ode to Booze]) > 0)
{
    cli_execute('outfit mushroom masquerade');
    use_familiar($familiar[frumious bandersnatch]);
    if(!get_property('_defectiveTokenUsed').to_boolean() && item_amount($item[defective game grid token]) > 0)
        use(1, $item[defective game grid token]);
    if(!get_property('_madTeaParty').to_boolean())
        cli_execute('hatter 24');
    //if(item_amount($item[moveable feast]) > 0)
       // use(1, $item[moveable feast]);
    if(!get_property('concertVisited').to_boolean())
        cli_execute('concert Optimist Primal');
    while(get_property('_banderRunaways').to_int() < (modifier_eval("W") / 5))
        adv1($location[the haunted library], -1, '');
    cli_execute('shrug Ode to Booze');
}

if(numeric_modifier("Smithsness") > 70)
{
    print("Farming day! " + to_string(my_adventures()) + " adventures to spend!");
    isFarmingDay = true;
    cli_execute('outfit TofuFarming');
    use(1, $item[The Legendary Beat]);
    //
    // Extend Buffs
    //

    if (!(to_boolean(get_property("_bagOTricksUsed"))) && (take_stash(1 , $item[Bag o' Tricks])||item_amount($item[Bag o' Tricks]) > 0)) 
    {
        cli_execute("/shrug lyric");
        cli_execute("/shrug ode to booze");
        use(1, $item[Bag o' Tricks]);
        put_stash(1 , $item[Bag o' Tricks]);
    }
    if (!(to_boolean(get_property("expressCardUsed"))) && (take_stash(1 , $item[Platinum Yendorian Express Card])||item_amount($item[Platinum Yendorian Express Card]) > 0)) 
    {
        use(1, $item[Platinum Yendorian Express Card]);
        put_stash(1 , $item[Platinum Yendorian Express Card]);
    }

    cli_execute("mood acidparade");
		
    if (!(to_boolean(get_property("_borrowedTimeUsed"))) && retrieve_item(1, $item[Borrowed Time])) {
        use(1, $item[Borrowed Time]);
    }   

    retrieve_item(1, $item[Human Musk]);
    cli_execute('mood execute');
    while (my_adventures() > 0 && have_effect($effect[In Your Cups]) > 10) 
    {
        doVoterFight();
        use_familiar(ChooseFamiliar());
        if(have_effect($effect[Holiday Bliss]) == 0 && get_property('timesRested').to_int() < total_free_rests())
        {
            cli_execute('rest');
        }
        equip($slot[familiar], $item[Mayflower bouquet]);
        if(have_effect($effect[Fat Leon's Phat Loot Lyric]) < 100) //'
            cli_execute("csend to buffy || lyric");
        
        cli_execute('gain 1900 item');
        adventure(1 , $location[The Electric Lemonade Acid Parade]);
    }
    put_stash(3, $item[essential tofu]);
}
else
{
    print("Charging day! " + to_string(my_adventures()) + " adventures to spend!");
    cli_execute("mood apathetic");
    //while (my_adventures() + 306 > have_effect($effect[In Your Cups])) 
    while(my_adventures() > 99)
    {
        
        if(get_counters("Romantic Monster window end", -50, 0) == "Romantic Monster window end" && get_property('_romanticFightsLeft').to_int() > 0)
            adventure(1 , $location[The Electric Lemonade Acid Parade]);
        doVoterFight();
        visit_url("inv_use.php?pwd&whichitem=4613&teacups=1");
        if(my_adventures() == 0)
            break;
    }
    cli_execute('rest');
    use(1, $item[The Legendary Beat]);
    if (!(to_boolean(get_property("_bagOTricksUsed"))) && (take_stash(1 , $item[Bag o' Tricks])||item_amount($item[Bag o' Tricks]) > 0)) {
        use(1, $item[Bag o' Tricks]);
        put_stash(1 , $item[Bag o' Tricks]);
    }
    if (!(to_boolean(get_property("expressCardUsed"))) && (take_stash(1 , $item[Platinum Yendorian Express Card])||item_amount($item[Platinum Yendorian Express Card]) > 0)) 
    {
        use(1, $item[Platinum Yendorian Express Card]);
        put_stash(1 , $item[Platinum Yendorian Express Card]);
    } 
}

foreach it in $items[tattered scrap of paper, transporter transponder]
    put_shop(mall_price(it)*0.9, 1, item_amount(it),it);

foreach it in $items[jumping horseradish, sacramento wine]
    put_shop(mall_price(it)*0.9, 1, item_amount(it),it);

foreach it in $items[beastly paste, bug paste, cosmic paste, oily paste, demonic paste, elemental paste, gooey paste, crimbo paste, fishy paste, goblin paste, hippy paste, hobo paste, indescribably horrible paste, greasy paste, mer-kin paste, orc paste, penguin paste, pirate paste, chlorophyll paste, slimy paste, ectoplasmic paste, strange paste]
    put_shop(mall_price(it)*0.9, 1, item_amount(it),it);

foreach it in $items[game grid token]
    put_shop(mall_price(it)*0.9, 1, item_amount(it),it);

foreach it in $items[time's arrow]
    put_shop(mall_price(it)*0.9, 1, item_amount(it)-3, it);

foreach it in $items[essential tofu]
    put_shop(5000, 1, item_amount(it)-3, it);

//
// Clear out Food
//

foreach it in $items[abominable snowcone, antique packet of ketchup, bat haggis, carob chunks, chorizo brownies, cranberries, Crimbo pie , custard pie , dead meat bun , enticing mayolus ,extra-flat panini , 	loaf of soda bread , Mt. McLargeHuge oyster , 	orange popsicle , red velvet cake ]
    if (it.have()) autosell(it.item_amount(), it);

//
// NIGHT NIGHT
//

/*
Nighttime outfit:

Gladitorial Glad Rags

Resolutions: Be More Adventurous

*/


while(get_property('_monkeyPawWishesUsed').to_int() < 4)
{
    cli_execute('monkeypaw effect in your cups');
}

cli_execute('call LoadStash');
if(item_amount($item[stinky cheese eye]) == 1)
{
    put_stash(1, $item[stinky cheese eye]);

}
cli_execute('outfit Pajamas');
use_familiar($familiar[gelatinous Cubeling]);
equip($slot[familiar], $item[none]);

if(my_meat() > 1000000)
{
    while(get_property('_resolutionAdv').to_int() < 10)
    {
        retrieve_item($item[resolution: be more adventurous]);
        if(item_amount($item[resolution: be more adventurous]) > 0)
            use(1, $item[resolution: be more adventurous ]);
        else   
            break;
    } 
}

if(my_meat() > 1000000)
{
    cli_execute("csend to buffy || ode");
    wait(30);
    buy(1, $item[ice stein]);
    buy(1, $item[ice-cold six-pack]);
    cli_execute('monkeypaw effect Salty Mouth');
    use(1, $item[ice stein]);
    cli_execute("shrug ode");
}
else
{
    cli_execute('monkeypaw effect in your cups');
}

print("Probably done for the day!");
