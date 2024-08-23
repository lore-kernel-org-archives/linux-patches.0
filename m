Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2069.outbound.protection.outlook.com [40.107.22.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A452F14A633;
	Fri, 23 Aug 2024 09:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.22.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724404825; cv=fail; b=iMxKiMJMix82CVzvVOjze0fE0CxBtm60Xv1R2/Si+G9CXLkdnUnxHpoli6EfU19TVrh8a1VJKlXdcOHYCEDBR9D0annXi0B2aKttCww+N6Jk3ArhOtkaC0nmQjKfaK9f6Rl9xI1oZzbFUXs0gkw7I5RpHjNKR2RYvPBZ7fwUE3Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724404825; c=relaxed/simple;
	bh=D1b3xxc87qis1B7URV85VmkUkvdn3Afj7ZBJ5cs9MdQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=uafvMB5WSsz6pZfFFezbi46DCgauzdg+gXKRk/8SvpZuG23XUR6BYAFypPiSsa3hCDXC2XMU60mqI1CnFUqyvRopkM6jJbA0goskwd0JGF+NupUyt622fc0NhyXWUsDD2RxJzaJoZE0vpc/mHYb+OFfscS0CH+G85USRPSrV+AI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com; spf=pass smtp.mailfrom=nxp.com; dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b=oHFGZVUW; arc=fail smtp.client-ip=40.107.22.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b="oHFGZVUW"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A2VqPjP7DGTUt5UP+u66wXCS8DU7wNKllYUpHvVo60vn4+lhl84bxXgzvxyAvX8jMab5MOMKisCJr9l9pcqwKW12/a23H5h2RJQx745BSXA217dl6L1/GTwf2YimiOW4ZwtxyQp5slQIOiCA1+fi4LOUfoT0eRDvuFLUwnygnDBSp1nLNnJY6HWS9vtlp56FhN0bmEwQBY+InU/3xgO6JlGV36vd7LnFSkyt3U85KiDkEXEbDStC7zzfyD8pmb2VXK6XVPGUUSRJKOIDNotNuAgv7f/ifGlQNMIME21hq512egI8W7mwSn1XZnNnL+ijLd4NAkQkRszcsubS/oGw6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hpwU/B+r5St6MDFoaUUmGeTAKI1CV/TbuVw7HQ8Ge7w=;
 b=W8fffPG9Zn4v8c1H/FNEWEriFGGN6ZLohmwmOqapAepYisFpSKnBrVyRLRtD32oHrHBim/W9fkz9NgCNSFC4qwHJYsH7asakB+LF3+orS9WNLUf6vvM96HLU9GbyYiRZo0CgmtJNF0CMoYqKd0EZR4z9WfVk+lE1JVp20ksprjBe+IlpKDER2GAOAFbfvQI0pszD6bhAb5h5yOqvIptz26ZJGY9Gdynj/ZXT9qqqz5ciotCKP7/gnMy5+Xf++/HMUnoEQAe0gEJc+373P/e2cyeRfHQxb78JHVjDS1LFCZUGyzMIaXQ7eRapaKiidg41cLDEBYd7qBhCDjcqaWXxLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hpwU/B+r5St6MDFoaUUmGeTAKI1CV/TbuVw7HQ8Ge7w=;
 b=oHFGZVUWWL1lrG/sW/lMFNJjasxZQ9hPcubsq6dLz+7DsDXc3GyUYdjvb3yolbMNSU7MTW5RXMDAQcmpb1h+pDPVP31qpR8UCqlLg31xZDZxFeCk7JIxG5MzWNAxdYGvFWQwEkeAkfSSznWinpNoAUxKQ7VNSCplYaaEHrYsLGbpbgpRGar0DbC+ewfGGO1+LgfujeR4/VhVOZnXcg+XuTTqfuJiukuOmMKTVme1NUkwO7QsEeYiCcV+yevX6HHB1fxZGXKkeP1BDC6vaZPs7O+FR6Mo3f93faxiYkaDU4TDXfjBJAZcafpJVrR8Uv3wG/7xpfzI+bSCdtBD1IpRdw==
Received: from PAXPR04MB8459.eurprd04.prod.outlook.com (2603:10a6:102:1da::15)
 by AM8PR04MB7236.eurprd04.prod.outlook.com (2603:10a6:20b:1d9::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.25; Fri, 23 Aug
 2024 09:20:20 +0000
Received: from PAXPR04MB8459.eurprd04.prod.outlook.com
 ([fe80::165a:30a2:5835:9630]) by PAXPR04MB8459.eurprd04.prod.outlook.com
 ([fe80::165a:30a2:5835:9630%6]) with mapi id 15.20.7897.014; Fri, 23 Aug 2024
 09:20:20 +0000
From: Peng Fan <peng.fan@nxp.com>
To: Nathan Chancellor <nathan@kernel.org>, Shawn Guo <shawnguo@kernel.org>,
	Sascha Hauer <s.hauer@pengutronix.de>, Pengutronix Kernel Team
	<kernel@pengutronix.de>, Fabio Estevam <festevam@gmail.com>
CC: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "imx@lists.linux.dev"
	<imx@lists.linux.dev>, "llvm@lists.linux.dev" <llvm@lists.linux.dev>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [PATCH] ARM: imx: Annotate imx7d_enet_init() as __init
Thread-Topic: [PATCH] ARM: imx: Annotate imx7d_enet_init() as __init
Thread-Index: AQHa9PAugeWKrV3GckuJFTSuOaC2w7I0kVxw
Date: Fri, 23 Aug 2024 09:20:20 +0000
Message-ID:
 <PAXPR04MB8459A04A2B155BD2633D6A3A88882@PAXPR04MB8459.eurprd04.prod.outlook.com>
References:
 <20240822-imx7d-mark-imx7d_enet_init-as-init-v1-1-8dfadee3bed4@kernel.org>
In-Reply-To:
 <20240822-imx7d-mark-imx7d_enet_init-as-init-v1-1-8dfadee3bed4@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PAXPR04MB8459:EE_|AM8PR04MB7236:EE_
x-ms-office365-filtering-correlation-id: 82adbb53-0ec5-44a5-5f73-08dcc354cf67
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?B8tFkcn5DWN1ckvKkyvQcHAWDC6ed+rwx/Qc3vQdqs1aH3dA7jWu2FLi50JF?=
 =?us-ascii?Q?jl+kvK6DcMkHu0vt+NtqG4KNp6djzZhOxS1riFxTK/fy/o7kEPSUH1PQ4SXT?=
 =?us-ascii?Q?nkfeBVNNlbtvXvBxj36hdFXN9I5+SWdUIirwETcFCwObTNC2v5Y1Bz3/qS0n?=
 =?us-ascii?Q?lEbeXssFr+B9ZLeW2f/wKUQOwEGNX5Sx8KGsYDjOb1JT3wEWxT4Ov0BuCYYQ?=
 =?us-ascii?Q?IaXx6j83CZmQE302nAeNNVgU/BZDbw1mvxECEv4Axq/18k6W/7dwGeKbs4je?=
 =?us-ascii?Q?mVhB/W1kwZVjqBwuAgJyInmKqkngZQtA2yaKTvEcayG0LmV0WudIQzjS+Ylp?=
 =?us-ascii?Q?nv6A/jALqeQya9C17NR1pkbdXNAFH+FG4nWS/f33kDDB+QkqMH1HHxTYizrd?=
 =?us-ascii?Q?WGtK9FrSLZXXzORl9XuVY8qhcJPs5oE99nvXw0p/q2Va3EaGXy0M+6fTdF+r?=
 =?us-ascii?Q?NbnWN76WNdN/cWBTDacJ2rL1BYuEVFiZkfbJOfgZMtSDk6HxkMR8zQ9mPZxZ?=
 =?us-ascii?Q?/yb0lVwcZseMjs+fGfq/p9O360TUc2owque2F4dD70vUx/5UB07DRCP48cco?=
 =?us-ascii?Q?6h/WEdhKQyvBvuXzOkt+DoFCQkwyAbPMKEKkgEbm6LrBdE8ZiCSTqj6+3bDE?=
 =?us-ascii?Q?0qakf/XRp7MKfg11/C7goZoSEMdCUKYCt/eVdSCLY9UhQTdbkWZd4ud2Ixs5?=
 =?us-ascii?Q?+9QzhILsAN0QKdi3iPvIA9m4HlHEbCA8ognBxKF9bB0uwG2btfTdU1MrMTvY?=
 =?us-ascii?Q?637on7A0znfI0PwGTwhwfrFQ5SuSjKbVM9wO9jrabJqZO1zwFc5tGFi+c26d?=
 =?us-ascii?Q?pW4PNLLzIexxcmSoEMmsIK3RJ+H3GOb0T8V0Ji67FaRi3XNrP2E6lwOwLy6E?=
 =?us-ascii?Q?P8a/cu4hTU3aw2alFx6Do1zJBQXVjJ3Vnki0GN/FCoOT1TVEUzHuqJaIxTuz?=
 =?us-ascii?Q?Z76AglE4LDpBNFHADb4i7AI03hmMGFmqCdy0KuOBaBTpXJwG4eJn4qofbD5f?=
 =?us-ascii?Q?1yvKDW/BOy+he81B7OoPP29z3cjbCYXnYvkhyVSKl8cHOoOghtG8NfnakYlK?=
 =?us-ascii?Q?FCToiZGE/A/jjfND7ZZfBI4Uk2zzrx/qOVDcgdXreLPgXVd7Nguyh2YxUiOB?=
 =?us-ascii?Q?GOx8bgRtbVJwS+i/fIoetGCbk6PfyXCW2a4cjxeoLfPsFbejdpaXwnSTU6LW?=
 =?us-ascii?Q?lahLQSl7Clcd4t+8W7kYwSso+5cjAqQzxvyDPKcZB569yJxcdmKiV7Goebh/?=
 =?us-ascii?Q?wne8Zv8D46zFe9eu7223eYTfZFU0QT7oQg/2VUAxkN6M240x58p6pGATBplp?=
 =?us-ascii?Q?VaiQRWTymZM/F8yiKiMQvf464I4l5tFDtlU9mLt1jxr7PZU4HiUIhCnk2Tpv?=
 =?us-ascii?Q?cuVIgddXfuDvKg40GH9q2eLYdDyN8lpanYfHIW8nmTByvVrqlw=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB8459.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?Fc4Z7ID7/P3zctKe9cqR40FU7bq0PUpbkKnQy/IpdThiILLZJxVZLTdliHjM?=
 =?us-ascii?Q?8Yr6+U5txzmCP9k3BUQ7aPL3fp+RWtM6LoJisCBze7a8ljQTN7c39p/eMAit?=
 =?us-ascii?Q?vjMRyMvlgAaZwJc2hDda7JWjMiHgTbiEHwioPNW39xv0ynJeJLGFuQax7tpX?=
 =?us-ascii?Q?3iOcitEvwUyL+YrFS6EHBEFqGHDxLjMfy1PkXadzUbe2u+iMEnrWhQJFw99w?=
 =?us-ascii?Q?hgPic3N5UijYPNijOuuPaC/MgPcqcMiqHLAZEGYUABcmg//A/3NYm65jcoKX?=
 =?us-ascii?Q?xZXbeV2Zz3DolsOTNyg0oVrKn9xpX28JkFhkkPb3UrkTRhmloIUJOVVA+kzS?=
 =?us-ascii?Q?8cVBuT4A/G+WjllwxcFm+pNZlVv/zITiJOjcqcawqvdV3ong6oqi+IfdtaUS?=
 =?us-ascii?Q?cMViDO27aEQjKaBIbmBWLZDA9n7baQMgvDQc7dieI4Xsuqka/eGCDdyWCGd2?=
 =?us-ascii?Q?KWIwKVFtI9sKlPnpsk7ma9cjp+FyTaB3tT8Tc2oTPMxTn2mWB7NGqHH3WbNi?=
 =?us-ascii?Q?yvJ05taV7+ckVUJmd8/vjEeRBQHatEuxySUy7wsPqu4VOU0Pcff1FOmhZgCz?=
 =?us-ascii?Q?BLh9fqkYLR/3JGBsg06gPytO0nNdhHWQbpf4SQFk71apqzE1qyPUdOwDENC9?=
 =?us-ascii?Q?dro9O6ebmSbNkfX/pO4Fxjw/o1+0dDMKgffBXgTAK7jYoBpoTxYGmZGC9F1+?=
 =?us-ascii?Q?F0Gseu89Yx3EvBWaQzMgVYq/3FTbl7kmZTX2u7PiUrlOk6AdYVSqZtWqXSMO?=
 =?us-ascii?Q?+iS/xWBvDKRKxuiw+4T8ZCmCh8xlQZYaJD2EljA7s/NbcxjmnDcfQ6cCfG1m?=
 =?us-ascii?Q?0bad9SZOuCkV4vKJHq5/W9wz3suv0C0Iz/L7XiaF2/0l8VjQqYsJDYJF9NvZ?=
 =?us-ascii?Q?H3qGGddT028ZrFcF+XfJxukgzf9O7K12e8iC/GpFYM8+E1QOX6DCwN3qooxd?=
 =?us-ascii?Q?15txMKOk1Adu/ECPrHQBCiUfVbJAj73tyR1ha6Uixn4vmsV8jiLQfig5l77i?=
 =?us-ascii?Q?U1MHp90nakLjqMFrQOvzHNzUxIic2h8Il5J0AXF+VL9JpoOCEZTPehPUIe/G?=
 =?us-ascii?Q?xS+6bzx8JruCWEpah0h7V3TyrImfPFzJGjrNGZ7dWj5FVoPPWOWl78RTP0CH?=
 =?us-ascii?Q?se95KqREmSgM2MEQBhVuCQkdgaJSJ1rdGLPQfP/DyninArirp219v0jM2Qgj?=
 =?us-ascii?Q?GRIVe72DJxRP81JitYLBM05Wex8PcJJcmWqTZ3KmUV8KuRfpju4L1WLhPLuE?=
 =?us-ascii?Q?BQVEzzb+Cx5xxrnZjGfFKxuNBxjCHwKFsMHJGXlw+1dAKrSsylHSFGGj/28c?=
 =?us-ascii?Q?x0/Z02tNlptya958tNu1il9mltk6AucDn2uzCvgbZjWPrvfo4zeCY8cGoqcH?=
 =?us-ascii?Q?cmtlEnzR+bmlvDLkhWuduPsFDrihbCSHPuEU59YXQu0Lgrsf58U189Js9T8r?=
 =?us-ascii?Q?xcmvYbzazvYY80kZ/q0Q/r9ZglwazSNdJEGo+t6U/ew5EsN55qhnYV4JnC5v?=
 =?us-ascii?Q?vklzltkiG/PWnRlNSlOSg0So5qA3ag7RkSDRNLCqFbcMeebHSJ7Z822yBqmh?=
 =?us-ascii?Q?VkWHqIH5EEK+IdxMKUI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB8459.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82adbb53-0ec5-44a5-5f73-08dcc354cf67
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Aug 2024 09:20:20.3923
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7ilLM2Cenz7g0RU1XeTVTiNt3c6m8xQEp+/Bz6fLHd4EpZ3dMgUsDMPonG8P0bRA0f5IFMjISn83vyv2j/4cRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7236

> Subject: [PATCH] ARM: imx: Annotate imx7d_enet_init() as __init
>=20
> After a recent LLVM change [1] that deduces __cold on functions that
> only call cold code (such as __init functions), there is a section
> mismatch warning from imx7d_enet_init(), which got moved
> to .text.unlikely. as a result of that optimization:
>=20
>   WARNING: modpost: vmlinux: section mismatch in reference:
> imx7d_enet_init+0x20 (section: .text.unlikely.) -> imx7d_enet_clk_sel
> (section: .init.text)
>=20
> Drop the inline keyword (which does not guarantee inlining) and
> replace it with __init, as imx7d_enet_init() is only called from __init
> code, which clears up the warning.
>=20
> Link:
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Reviewed-by: Peng Fan <peng.fan@nxp.com>
