#!/bin/bash

. config

chmod +x *.sh

# suffixes of masked clusters
sufa="${OPERNAME}a"
sufb="${OPERNAME}b"
sufc="${OPERNAME}c"

# created topology is like
#	hub1-211.sda [6667]------.------hub1-ratbox.sdb [6607]
#	|			/ \	|
#	hub2-ratbox.sda [6668]-'   `----hub2-211.sdb [6608]-------hub1-211.sdc[6617]---hub2-211.sdc[6618]----leaf1-ratbox.sdc[6619]
#	|		       		|                              \__leaf2-ratbox.sdc[6620]
#	leaf-211.sda [6669]	 	leaf-ratbox.sdb [6609]       
#				                                     
#### left part
./mk211.sh "hub1-211.$sufa" 6667 "
*.$sufb:6607:1
*.$sufb:6608:1
hub2-ratbox.$sufa:6668
leaf-211.$sufa:
"

./mkrb.sh "hub2-ratbox.$sufa" 6668 "
*.$sufb:6607:*.$sufa
*.$sufb:6608:*.$sufa
hub1-211.$sufa:6667
leaf-211.$sufa:
"

./mk211.sh "leaf-211.$sufa" 6669 "
hub1-211.$sufa:6667
hub2-ratbox.$sufa:6668
"


#### right part
./mkrb.sh "hub1-ratbox.$sufb" 6607 "
*.$sufa:6667:*.$sufb
*.$sufa:6668:*.$sufb
hub2-211.$sufb:6608
leaf-ratbox.$sufb:
"

./mk211.sh "hub2-211.$sufb" 6608 "\
*.$sufa:6667:1
*.$sufa:6668:1
hub1-ratbox.$sufb:6607
leaf-ratbox.$sufb:
*.$sufc:6617:1
"

./mkrb.sh "leaf-ratbox.$sufb" 6609 "
hub1-ratbox.$sufb:6607
hub2-211.$sufb:6608
"

#### sdc part
./mk211.sh "hub1-211.$sufc" 6617 "
*.$sufb:6608:1
hub2-211.$sufc:6618
leaf1-ratbox.$sufc:
leaf2-ratbox.$sufc:
"

./mk211.sh "hub2-211.$sufc" 6618 "
hub1-211.$sufc:6617
leaf1-ratbox.$sufc:
leaf2-ratbox.$sufc:
"

./mkrb.sh "leaf1-ratbox.$sufc" 6619 "
hub2-211.$sufc:6618
"

./mkrb.sh "leaf2-ratbox.$sufc" 6620 "
hub1-211.$sufc:6617
"

