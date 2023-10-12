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

familiar ChooseFamiliar()
{
    foreach f in $familiars[Li'l Xenomorph, Pair of Stomping Boots]
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
    retrieve_item(1, $item[absentee voter ballot  ]);
    retrieve_item(2, $item[Divine champagne popper]); //16 000
    retrieve_item(2, $item[tennis ball]); //16 000
    retrieve_item(2, $item[Spooky music box mechanism]); //400
    retrieve_item(1, $item[crystal skull]); //6 500
    buy(1, $item[human musk]); //100
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

if(have_effect($effect[The Ode to Booze]) == 0)
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

while(get_property('_brickoFights').to_int() < 3)
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
use_familiar($familiar[rogue program]);

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
        use_familiar(ChooseFamiliar());
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
    while(my_adventures() > 122)
    {
        if(get_counters("Romantic Monster window end", -50, 0) == "Romantic Monster window end" && get_property('_romanticFightsLeft').to_int() > 0)
            adventure(1 , $location[The Electric Lemonade Acid Parade]);
    
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


while(get_property('_monkeyPawWishesUsed').to_int() < 5)
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
    
    use(1, $item[ice stein]);
}

print("Probably done for the day!");
