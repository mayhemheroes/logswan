/*
 * Logswan 2.1.15
 * Copyright (c) 2015-2025, Frederic Cambus
 * https://www.logswan.org
 *
 * Created:      2015-05-31
 * Last Updated: 2021-02-15
 *
 * Logswan is released under the BSD 2-Clause license.
 * See LICENSE file for details.
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

const char *countries_id[] = {
	"AD",
	"AE",
	"AF",
	"AG",
	"AI",
	"AL",
	"AM",
	"AO",
	"AQ",
	"AR",
	"AS",
	"AT",
	"AU",
	"AW",
	"AX",
	"AZ",
	"BA",
	"BB",
	"BD",
	"BE",
	"BF",
	"BG",
	"BH",
	"BI",
	"BJ",
	"BL",
	"BM",
	"BN",
	"BO",
	"BQ",
	"BR",
	"BS",
	"BT",
	"BV",
	"BW",
	"BY",
	"BZ",
	"CA",
	"CC",
	"CD",
	"CF",
	"CG",
	"CH",
	"CI",
	"CK",
	"CL",
	"CM",
	"CN",
	"CO",
	"CR",
	"CU",
	"CV",
	"CW",
	"CX",
	"CY",
	"CZ",
	"DE",
	"DJ",
	"DK",
	"DM",
	"DO",
	"DZ",
	"EC",
	"EE",
	"EG",
	"EH",
	"ER",
	"ES",
	"ET",
	"FI",
	"FJ",
	"FK",
	"FM",
	"FO",
	"FR",
	"GA",
	"GB",
	"GD",
	"GE",
	"GF",
	"GG",
	"GH",
	"GI",
	"GL",
	"GM",
	"GN",
	"GP",
	"GQ",
	"GR",
	"GS",
	"GT",
	"GU",
	"GW",
	"GY",
	"HK",
	"HM",
	"HN",
	"HR",
	"HT",
	"HU",
	"ID",
	"IE",
	"IL",
	"IM",
	"IN",
	"IO",
	"IQ",
	"IR",
	"IS",
	"IT",
	"JE",
	"JM",
	"JO",
	"JP",
	"KE",
	"KG",
	"KH",
	"KI",
	"KM",
	"KN",
	"KP",
	"KR",
	"KW",
	"KY",
	"KZ",
	"LA",
	"LB",
	"LC",
	"LI",
	"LK",
	"LR",
	"LS",
	"LT",
	"LU",
	"LV",
	"LY",
	"MA",
	"MC",
	"MD",
	"ME",
	"MF",
	"MG",
	"MH",
	"MK",
	"ML",
	"MM",
	"MN",
	"MO",
	"MP",
	"MQ",
	"MR",
	"MS",
	"MT",
	"MU",
	"MV",
	"MW",
	"MX",
	"MY",
	"MZ",
	"NA",
	"NC",
	"NE",
	"NF",
	"NG",
	"NI",
	"NL",
	"NO",
	"NP",
	"NR",
	"NU",
	"NZ",
	"OM",
	"PA",
	"PE",
	"PF",
	"PG",
	"PH",
	"PK",
	"PL",
	"PM",
	"PN",
	"PR",
	"PS",
	"PT",
	"PW",
	"PY",
	"QA",
	"RE",
	"RO",
	"RS",
	"RU",
	"RW",
	"SA",
	"SB",
	"SC",
	"SD",
	"SE",
	"SG",
	"SH",
	"SI",
	"SJ",
	"SK",
	"SL",
	"SM",
	"SN",
	"SO",
	"SR",
	"SS",
	"ST",
	"SV",
	"SX",
	"SY",
	"SZ",
	"TC",
	"TD",
	"TF",
	"TG",
	"TH",
	"TJ",
	"TK",
	"TL",
	"TM",
	"TN",
	"TO",
	"TR",
	"TT",
	"TV",
	"TW",
	"TZ",
	"UA",
	"UG",
	"UM",
	"US",
	"UY",
	"UZ",
	"VA",
	"VC",
	"VE",
	"VG",
	"VI",
	"VN",
	"VU",
	"WF",
	"WS",
	"XK",
	"YE",
	"YT",
	"ZA",
	"ZM",
	"ZW"
};

const char *countries_names[] = {
	"Andorra",
	"United Arab Emirates",
	"Afghanistan",
	"Antigua and Barbuda",
	"Anguilla",
	"Albania",
	"Armenia",
	"Angola",
	"Antarctica",
	"Argentina",
	"American Samoa",
	"Austria",
	"Australia",
	"Aruba",
	"Aland Islands",
	"Azerbaijan",
	"Bosnia and Herzegovina",
	"Barbados",
	"Bangladesh",
	"Belgium",
	"Burkina Faso",
	"Bulgaria",
	"Bahrain",
	"Burundi",
	"Benin",
	"Saint Barthelemy",
	"Bermuda",
	"Brunei",
	"Bolivia",
	"Bonaire",
	"Brazil",
	"Bahamas",
	"Bhutan",
	"Bouvet Island",
	"Botswana",
	"Belarus",
	"Belize",
	"Canada",
	"Cocos (Keeling) Islands",
	"Democratic Republic of the Congo",
	"Central African Republic",
	"Republic of the Congo",
	"Switzerland",
	"Ivory Coast",
	"Cook Islands",
	"Chile",
	"Cameroon",
	"China",
	"Colombia",
	"Costa Rica",
	"Cuba",
	"Cape Verde",
	"Curacao",
	"Christmas Island",
	"Cyprus",
	"Czech Republic",
	"Germany",
	"Djibouti",
	"Denmark",
	"Dominica",
	"Dominican Republic",
	"Algeria",
	"Ecuador",
	"Estonia",
	"Egypt",
	"Western Sahara",
	"Eritrea",
	"Spain",
	"Ethiopia",
	"Finland",
	"Fiji",
	"Falkland Islands",
	"Micronesia",
	"Faroe Islands",
	"France",
	"Gabon",
	"United Kingdom",
	"Grenada",
	"Georgia",
	"French Guiana",
	"Guernsey",
	"Ghana",
	"Gibraltar",
	"Greenland",
	"Gambia",
	"Guinea",
	"Guadeloupe",
	"Equatorial Guinea",
	"Greece",
	"South Georgia and the South Sandwich Islands",
	"Guatemala",
	"Guam",
	"Guinea-Bissau",
	"Guyana",
	"Hong Kong",
	"Heard Island and McDonald Islands",
	"Honduras",
	"Croatia",
	"Haiti",
	"Hungary",
	"Indonesia",
	"Ireland",
	"Israel",
	"Isle of Man",
	"India",
	"British Indian Ocean Territory",
	"Iraq",
	"Iran",
	"Iceland",
	"Italy",
	"Jersey",
	"Jamaica",
	"Jordan",
	"Japan",
	"Kenya",
	"Kyrgyzstan",
	"Cambodia",
	"Kiribati",
	"Comoros",
	"Saint Kitts and Nevis",
	"North Korea",
	"South Korea",
	"Kuwait",
	"Cayman Islands",
	"Kazakhstan",
	"Laos",
	"Lebanon",
	"Saint Lucia",
	"Liechtenstein",
	"Sri Lanka",
	"Liberia",
	"Lesotho",
	"Lithuania",
	"Luxembourg",
	"Latvia",
	"Libya",
	"Morocco",
	"Monaco",
	"Moldova",
	"Montenegro",
	"Saint Martin",
	"Madagascar",
	"Marshall Islands",
	"North Macedonia",
	"Mali",
	"Myanmar",
	"Mongolia",
	"Macao",
	"Northern Mariana Islands",
	"Martinique",
	"Mauritania",
	"Montserrat",
	"Malta",
	"Mauritius",
	"Maldives",
	"Malawi",
	"Mexico",
	"Malaysia",
	"Mozambique",
	"Namibia",
	"New Caledonia",
	"Niger",
	"Norfolk Island",
	"Nigeria",
	"Nicaragua",
	"Netherlands",
	"Norway",
	"Nepal",
	"Nauru",
	"Niue",
	"New Zealand",
	"Oman",
	"Panama",
	"Peru",
	"French Polynesia",
	"Papua New Guinea",
	"Philippines",
	"Pakistan",
	"Poland",
	"Saint Pierre and Miquelon",
	"Pitcairn Islands",
	"Puerto Rico",
	"Palestine",
	"Portugal",
	"Palau",
	"Paraguay",
	"Qatar",
	"Reunion",
	"Romania",
	"Serbia",
	"Russia",
	"Rwanda",
	"Saudi Arabia",
	"Solomon Islands",
	"Seychelles",
	"Sudan",
	"Sweden",
	"Singapore",
	"Saint Helena",
	"Slovenia",
	"Svalbard and Jan Mayen",
	"Slovakia",
	"Sierra Leone",
	"San Marino",
	"Senegal",
	"Somalia",
	"Suriname",
	"South Sudan",
	"Sao Tome and Principe",
	"El Salvador",
	"Sint Maarten",
	"Syria",
	"Eswatini",
	"Turks and Caicos Islands",
	"Chad",
	"French Southern Territories",
	"Togo",
	"Thailand",
	"Tajikistan",
	"Tokelau",
	"East Timor",
	"Turkmenistan",
	"Tunisia",
	"Tonga",
	"Turkey",
	"Trinidad and Tobago",
	"Tuvalu",
	"Taiwan",
	"Tanzania",
	"Ukraine",
	"Uganda",
	"U.S. Minor Outlying Islands",
	"United States",
	"Uruguay",
	"Uzbekistan",
	"Vatican",
	"Saint Vincent and the Grenadines",
	"Venezuela",
	"British Virgin Islands",
	"U.S. Virgin Islands",
	"Vietnam",
	"Vanuatu",
	"Wallis and Futuna",
	"Samoa",
	"Kosovo",
	"Yemen",
	"Mayotte",
	"South Africa",
	"Zambia",
	"Zimbabwe"
};
