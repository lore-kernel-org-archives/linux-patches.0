Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 826E68F6E
	for <patches@lists.linux.dev>; Wed, 14 May 2025 01:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.178.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747187962; cv=fail; b=DDCJ3cGwLe3CmElcQixs+ujiWwkVV6z60V7w688pxb3F0GbEJmkN6UOdnxeP+JTVTyBVAQhnNgLcN9NA8lC+2/7n6WMfPw7ZiRSDauYCMyTyFAdXKmOmWuLtMkawByvQ+FiUIHd0e5eNSoyOxHfzzGLiHk1XmyS3Yai8H7Woa+Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747187962; c=relaxed/simple;
	bh=EYSa56g0rgNBiKWm+I3QBNpmPTjZA41rtP6DPvEImYw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=V6zqP3Skx4fzPAlro+aBxrDAsiMUp/Fc7Kjm1J4skvQVnSyMoOxfqY8rjMMDkAYwp4CEvk49nQVwRBdK6nR7DMXH5C9p0p733Th6unepHPserc6yAbsr7KY2sO6HjLHQtTNot2mLrg+5nbzzTUdN6T6I9IqbVkPZTUoTRMNg3jE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=fail smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54E0qF41020364;
	Wed, 14 May 2025 01:59:06 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 46mbc8rds6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 14 May 2025 01:59:05 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Bx/w8l8yIip8KoEmHb/LqHEFpYbwaiIfOV/JMUWSZQrgjtTe+ISufuxPpPrEwU6+X4RjJadeDFF+OHn8f798Xhk6WYO9FmZCjofIsQ6ZVeyfNBg0Y3GLBTKq70ZlX6NgMvVCU+CHs79XhI4bBYJ+ol+B5vzlNz1SC4wB4QWSkmnerMqw3kKf90+0ACpBVdyw4WF+mO2qHxtalv0bjoAzouNssp/h4uuwersptpQxOltoSOljEErTmAlC53HoyTplD9Ka5Dgc8v0DR6CuwE9aKJDf6M0dkn75Hv8yu6KOTDmK90s/zGW3hNYMOyzvWk691o9HKTDujXM4yeeYqg4zVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eP/CEHDxx3mJ4QyqO0Rp3PUNbOESPjsZhqJu8MzuAKU=;
 b=jp98YODG1SW6/lzSB9v90jHxs/53pBvwxnxvOM6+3Fo+O1jJk+DkeyMd7liQQOIxmHCu8hCEDUk6Lmil+HBJsJxIwXIZuih4Aec5oQ5rC46wetQmmHXKPTp8N8tVjuOglfTof4ge5xfpHY7yXRkbkfpMQ2hRMqMxts+jGTx01nwJ427U/Vq3X8/ffekbE9xViuw7xxFOEUvA4ASFlUyOjsdHhzm8SnAQ12AM1M4cd9Qfm5CgyHJK4VSC7hdhhwmchdLQcdcLvyyJR0brVSRI6vCydH7e/tu5al8gUdH0dYymjMw5cmI139tp44NbsayzBAeysS1ISEDf182d8r2Bow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from IA1PR11MB6170.namprd11.prod.outlook.com (2603:10b6:208:3ea::11)
 by DM6PR11MB4593.namprd11.prod.outlook.com (2603:10b6:5:2a3::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.29; Wed, 14 May
 2025 01:59:01 +0000
Received: from IA1PR11MB6170.namprd11.prod.outlook.com
 ([fe80::f850:53da:e11b:1653]) by IA1PR11MB6170.namprd11.prod.outlook.com
 ([fe80::f850:53da:e11b:1653%4]) with mapi id 15.20.8722.027; Wed, 14 May 2025
 01:59:01 +0000
From: "Ren, Jianqi (Jacky) (CN)" <Jianqi.Ren.CN@windriver.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "patches@lists.linux.dev" <patches@lists.linux.dev>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "penguin-kernel@i-love.sakura.ne.jp" <penguin-kernel@i-love.sakura.ne.jp>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "daniel.starke@siemens.com" <daniel.starke@siemens.com>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>
Subject: RE: [PATCH 5.15.y] tty: add the option to have a tty reject a new
 ldisc
Thread-Topic: [PATCH 5.15.y] tty: add the option to have a tty reject a new
 ldisc
Thread-Index: AQHbwMLZ/1a9ca3tp0C3sbGllH9xqbPPDXeAgAJYW5A=
Date: Wed, 14 May 2025 01:59:01 +0000
Message-ID:
 <IA1PR11MB61702B6E5E5031139DA5967BBB91A@IA1PR11MB6170.namprd11.prod.outlook.com>
References: <20250509091454.3241846-1-jianqi.ren.cn@windriver.com>
 <2025051221-creature-refund-8fe0@gregkh>
In-Reply-To: <2025051221-creature-refund-8fe0@gregkh>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA1PR11MB6170:EE_|DM6PR11MB4593:EE_
x-ms-office365-filtering-correlation-id: b404bd84-8bf9-48e6-cbbc-08dd928ae5b7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?GANdOtqD3FWsbOy805jxWmQusupL67oHQIGcBxOA3nUkzTOiAKOvfSiZ74ql?=
 =?us-ascii?Q?M7hdHynA29wVMR3VF93eP3W3yBAT34FoOSsz6IJFr9d0J5cT06RQXUu5CNMP?=
 =?us-ascii?Q?7B5AfCQu1a6m8/GrKyTlEGdU/HWAZGKUa/EsdOpMc/myFBSFCSbMpTdRETQr?=
 =?us-ascii?Q?vXmck8yqdfqVoEvC2Jqwqn1T/eYbhK/CKlFTQafacZ9mdc2p85jUPls/fg/O?=
 =?us-ascii?Q?ch+/dT9Ur65XMzPFgKPPi3IlN3lbAQneMiS89CQzI28CbMonCI7OVlY/MqQl?=
 =?us-ascii?Q?zvl4YKF2syh1Hfvs7aGpGpF3C6i+B6B41+AxYbgtsBZ9uP3oES6whBQqsv2S?=
 =?us-ascii?Q?0D64QYc9U+Hvnzp6q2QIjV0nTdlA/NmPULSwIO/GMI/V8hk4cCPhSUP7YgUn?=
 =?us-ascii?Q?xGqUXvkE/11Q05WY5SZ0M+XoRYhHFM3Lv7ZI133eEhg2sFUTJxwJmkaVtNvJ?=
 =?us-ascii?Q?ItjraHv9nC4B78t1bQ9vIFU7STGBaChil34A0y4MZ4IUk9Diux2DoJPou2US?=
 =?us-ascii?Q?kg52WtBBOD9E0r7RU3bTjv5S2sGA2s5/MNM34y7c56Ch0wCK+76Y1/6Yiqns?=
 =?us-ascii?Q?hmcpwCrDUzuQReCDJrzBoSYCevicVPTKDGRriXo6NxjLbAHqAmpNGk987axI?=
 =?us-ascii?Q?Vl5qUsVD9VgFSxFwwSx3KMOoLj842sFqMu3tEDNQy3nUNC2ttNkbLdNbSljx?=
 =?us-ascii?Q?VRyxnzJa/u/Vwh0W9IuS8kG1DFUW8yqm4ZOX+fiEBSvowvEDjDsSNnh2IDRD?=
 =?us-ascii?Q?2mk4iDzWhbtZBtguKy0wv6pbk89pu/QwygOGBg/N/B8ILqYIJtFRw7nwqx4H?=
 =?us-ascii?Q?iRsjKgFxwRNpnNyf7wkd8c5XIByrrta3d1Tzh2pmDbV87loDnh1DuxNiFfMe?=
 =?us-ascii?Q?Q/ETclFMlw/bkZdk3TpCz8b6lP6ku5AKO0JoPTc0bYMOLvpCIROH2Pw8RpzX?=
 =?us-ascii?Q?Jketobze8ibWFHWqirkJQZCQKHarLvpDcF/Nyk1GLJuUJsJSD/Fb4RHwh6Ah?=
 =?us-ascii?Q?9ApeFXCNfYmVGd4UB0izsCoLlj/JXqFBE82b/dw1axU1U/eIq9VsN0DzuBmN?=
 =?us-ascii?Q?nS4vLLmUF3zgAh+MpCOXwxtWkAgkjA1kcYo2nhjQR53+aBhwXuJK1PoxvegE?=
 =?us-ascii?Q?k4pVKtg2neO6DhmpUb6CtBXS4KzzoiydFwtWQcDPVC5WNzjgspRUuOHAC38S?=
 =?us-ascii?Q?YHFLMKwkI84My6uwLHtazSYFEe9GKj7ZEHCcbBZnq5MUeFcu5hSmKxYMl4cI?=
 =?us-ascii?Q?UdjjQdXToNUIXIZPIQbwMOuEA93Tj4T/LX/avkk5otmC0HP538NB/U7fZCDC?=
 =?us-ascii?Q?dcnoFSqny5Me4cfBdIQK75RBef8uXqOM/CXHKQpO5efZ4HIQ6qV6WFe2bOYW?=
 =?us-ascii?Q?WfMwOMmT4gtnz94cWA+IfAGtk/HY4cDO86z3WD0+Hciy689kvd4fWPRDzeT8?=
 =?us-ascii?Q?KcMPzq02Iw9Ep8rYfJNf6h8e6H7B4maMed69qNMZ2m8Wwcf9DVecBA=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB6170.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?1MJvBqDyy1ZI8bs3OIDaOl1XFeq2ccdfNlGutWq5RgdSHgCqHM9qRLtK3MPE?=
 =?us-ascii?Q?KLiTFZ/Jao6U2eRVLfArdzwEt0IwTf+JkK2LGSHI1Mjavvnuc76Kla2BAEaK?=
 =?us-ascii?Q?0KY7kVEC6ghjfBF3qZybzCn9GXxaZ5EyQGYSI0Tp1+Q8ffrUwhEvme9Az4vL?=
 =?us-ascii?Q?oCwAd79tHJn8DBi3YTa2rLMCnoLRMjsWCEZkhjytrTkEyFybouDW6pRB7sdU?=
 =?us-ascii?Q?WROlFhaPsdpfBOPPjyq5/3BOR4xf632RY9w9w453NOfNYN9EJH8hF0Dl6AdB?=
 =?us-ascii?Q?LY1Kvx1cZiGadwbxifwYOXqcBMNpMJm2ZmKK9/e0SRU5+7XAnRK9SD2WSQFS?=
 =?us-ascii?Q?YPuhkGxiOR58l+aMiGp/PYrmdlvVIBRL7JTh9tJVRhG0Eq9fv8kn2p34SdZM?=
 =?us-ascii?Q?6p1Q0zrIi1Z9Gd4z/BvGfOsmfDIgz7oZ38AVMd2zW60Idi1G+QJ0IOzvPHvD?=
 =?us-ascii?Q?51CLwVP8Do1UV7lFbfaA/Pc87vhl0zLw4aigHmsSwKDopx21Rn7TluKd22jp?=
 =?us-ascii?Q?iLJezlQiamkYNjUteDdyVnqcfKUtz575T701laJbFZJ8JT5zewIZ+28dT7ZH?=
 =?us-ascii?Q?kp/zgLwZPc7KPFINPRZmG9SwCkdL5Q5Nzsyo9/uYOfZf1DQFWxsnILdqnaOq?=
 =?us-ascii?Q?gPsUQFUAKCeBL4K1arDjRRguQDR4q6OSzEWAi5DjO0kvgy70WDq5uD1H5mno?=
 =?us-ascii?Q?1ZoYdGwj6N3WIj+2dwC/gE+WjczHW3EbOwaDWrXo406T6+nhfBXXSd+YJwmz?=
 =?us-ascii?Q?/rhLK6mIb/4hr8C5kI52qXXUzDPC9Yl9BiJVYA7Hpxs+sw7opc5WQgO8lWyv?=
 =?us-ascii?Q?l3VBfceRMyR0f+jOiMM/frLsnnrXB0/EGdoF1pXTiB3F1z5uDE8uvhcoHpAq?=
 =?us-ascii?Q?U5GvgCeVPdtm56ocnLSjgOxYgv7XAz7gTUO0gmDIE2CMcdX+fZYoCp2rpY6G?=
 =?us-ascii?Q?Ul55nMPzC50wvFvJH93SGm+l9E/VlE9AkmlkVR3KkqGHe+1Y31Wr65xP2UZp?=
 =?us-ascii?Q?wWxHdMPrLjk/ugnMgm9g+sqpfzFxfTgIZxEIm0CivamfiIgLuO5xuC6Aev2q?=
 =?us-ascii?Q?Sils9caR4L/c/VM1APQVo3vnfCdsjypolAVUw1n0pmLeUJpMsC+QLcWX3YVJ?=
 =?us-ascii?Q?C2zceoi8OgcFJNAoGgW3zjhplvcfEG1ENv74/p64hUIhC6vokr3dUaP9cdf+?=
 =?us-ascii?Q?R74cQpEh3eGiLpAQtYJXpOVBulufYMGRd3fV1jVfMTy0vcquqtVxj8UJCu0Z?=
 =?us-ascii?Q?OKNS0pfnwnRyPL1T8v9smJG5x2Vh2cPfIcd0pXAjLPVIOz1K7TO83L727hOy?=
 =?us-ascii?Q?j35k0vhHLKjyJwlrIVrZonpiG4HvkEWypw2ynM/Z3xLSk/0eFlZ437hp2OW+?=
 =?us-ascii?Q?YaBcUurAC4CT6D5BTm4j/J7sBylYKzQOJ7J9fqetXc8cKzfjnxDqyuvL6jlE?=
 =?us-ascii?Q?GmD4sYfSq6FeZ0lpZneoYqOYLT9sorHOu3m7ydYTxMp3jMkXetBjudrnvpVZ?=
 =?us-ascii?Q?AxpIGPAzWofw3i/7kl2+LdMVogtrb8UbORG6RjQ6YI0Kz39r1FcuRO9bTVZN?=
 =?us-ascii?Q?fE8kEfdFeougo5eDnjMXSDiKxAA5h8+2oCO7vqj6?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA1PR11MB6170.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b404bd84-8bf9-48e6-cbbc-08dd928ae5b7
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 May 2025 01:59:01.3263
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 48nbtmSmBGt0LeUh8pxL1n7m/xWT0XWs20jbw4gssDe2zvgd7gvGjiJlrYw3ORCotR4xen9fONsOv5izn149rXE8emSCQEk0/UqkWK/M2Fs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4593
X-Proofpoint-GUID: 0o3dMn99QUPm4mF0ImQWXitWCRH7lyyq
X-Proofpoint-ORIG-GUID: 0o3dMn99QUPm4mF0ImQWXitWCRH7lyyq
X-Authority-Analysis: v=2.4 cv=IIACChvG c=1 sm=1 tr=0 ts=6823f8e9 cx=c_pps a=hHPfuxNGWHHq0fQgDGst2w==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=py2lGXHgnwZgnTii:21 a=xqWC_Br6kY4A:10
 a=kj9zAlcOel0A:10 a=dt9VzEwgFbYA:10 a=ag1SF4gXAAAA:8 a=t7CeM3EgAAAA:8 a=VwQbUJbxAAAA:8 a=Z4Rwk6OoAAAA:8 a=a_U1oVfrAAAA:8 a=wvPkM9v7g1_ikmSEda4A:9 a=CjuIK1q_8ugA:10 a=Yupwre4RP9_Eg_Bd0iYG:22 a=FdTzh2GWekK77mhwV6Dw:22 a=HkZW87K1Qel5hWWM3VKY:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE0MDAxNSBTYWx0ZWRfX+f4rN/vETJ/h V+R7dcriVYGeYbn3AzwAlk48IUEqP0Uyd3dDeOz9SjBx9GAGsXVTS7LXve0PPqcqeTDItg7WFik qKPNnijuQoU3oQkuhx/4wc+QTdnlyyIKn80ifFb7SySQDpAbyG5d0BUwfd4HYdPB4ZgfJN+T1i5
 upEjdl24tyV87El2NE6e0SPaZE41suTK4SItFWjA+540HFIM1IIZBysmUkuwU0HYT4R9az7X/qk hY52BEH0MDI/SjOkrEFeB18pavOLsBFhA4XR1fChG+y/NkEXS05b74X3lrNrfHf+722ES8jAybn 2ZcMvm8JD6rZZHVj3lAZ2PFDoyh4djUANT3t5qNwDaa/9cikp3tfUCVSkIRVfdSQGtVDZr3mhDw
 HfHpw8k25x8SEqGsCpnijiBgj4xHmt/hCREMQvyiGFO1SDpM6H5MzYtSyG+BPuVTingZXrDg
X-Sensitive_Customer_Information: Yes
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-14_01,2025-05-09_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 mlxscore=0 suspectscore=0 malwarescore=0 phishscore=0
 bulkscore=0 impostorscore=0 mlxlogscore=999 priorityscore=1501
 clxscore=1015 adultscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.21.0-2505070000
 definitions=main-2505140015

Hello,

We don't have such device, but we saw in the commit log that "use it to lim=
it the virtual terminals to just N_TTY.  They are kind of special" and thou=
ght that it may help prevent other unexpected ldisc. So, we submitted this =
patch for review. If it's improper we will stop here for both 5.15 and 5.10=
.

-----Original Message-----
From: Greg KH <gregkh@linuxfoundation.org>=20
Sent: Monday, May 12, 2025 22:10
To: Ren, Jianqi (Jacky) (CN) <Jianqi.Ren.CN@windriver.com>
Cc: stable@vger.kernel.org; patches@lists.linux.dev; linux-kernel@vger.kern=
el.org; penguin-kernel@i-love.sakura.ne.jp; akpm@linux-foundation.org; dani=
el.starke@siemens.com; torvalds@linux-foundation.org
Subject: Re: [PATCH 5.15.y] tty: add the option to have a tty reject a new =
ldisc

CAUTION: This email comes from a non Wind River email account!
Do not click links or open attachments unless you recognize the sender and =
know the content is safe.

On Fri, May 09, 2025 at 05:14:54PM +0800, jianqi.ren.cn@windriver.com wrote=
:
> From: Linus Torvalds <torvalds@linux-foundation.org>
>
> [ Upstream commit 6bd23e0c2bb6c65d4f5754d1456bc9a4427fc59b ]
>
> ... and use it to limit the virtual terminals to just N_TTY.  They are=20
> kind of special, and in particular, the "con_write()" routine violates=20
> the "writes cannot sleep" rule that some ldiscs rely on.
>
> This avoids the
>
>    BUG: sleeping function called from invalid context at=20
> kernel/printk/printk.c:2659
>
> when N_GSM has been attached to a virtual console, and gsmld_write()=20
> calls con_write() while holding a spinlock, and con_write() then tries=20
> to get the console lock.

WHy do you want this in 5.15 and older kernels?  You have already disabledf=
 n_gsm from your kernels already so this isn't an issue, right?
Unless you have this hardware, and explicitly know what is talking to it, t=
hat is the recommendation for this code.

And how was this and the 5.10.y backport tested?  Did you see the above "BU=
G:" line without it?

thanks,

greg k-h
