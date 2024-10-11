Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2041.outbound.protection.outlook.com [40.107.247.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FE7A28689
	for <patches@lists.linux.dev>; Fri, 11 Oct 2024 03:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.247.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728617702; cv=fail; b=IFBFwXvF5nJIpHkypfJjpnU+elQYXZDxlh6watFB7lYb78oDvgSInG12sL1U9JbzhNBQ8hUrIQdMo97NUXDmu+kjP9dD/QoVYrr9u8zuJ4Evx0WWTY6+Yx67IdCA14/zgTBd+MkqKCEFfvjxzflyGIeZu+zMd9b1f0rfaAikz8Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728617702; c=relaxed/simple;
	bh=n9aLSJ1qI1azh5ccD2s51VE3TfdVA1UyPdhcy+mDBk0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=X1UlEoaTO4F2NtSBREQOp9s0B7B+t3lWt23SasbJSy0BDEF+bTyJZLfUOdFYUF81SVsg75Gv+fE/eo/CC+UziBka0GF+uzbjmjnj592f/p7cpDnsT4c+4paBmf6J/0duaI8Ks6NBIGv4CT0IKW1Xo8C+cKi7zHThKl7mbFZEP3w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com; spf=pass smtp.mailfrom=nxp.com; dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b=Ww5CNhGl; arc=fail smtp.client-ip=40.107.247.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b="Ww5CNhGl"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Jt4gwVGvT7+3wMqSRkLDDCaA26N26+TMpFII1+B6PNRfMQIYtnxowLX36RGQj4F1o8onkCQSLke3kn7kNyit23CnofT2qeq+tAFcGVQxkxfdSgnCU6Av7kJecU4s6FUXTBYS3jua3PbtSOLSGN/yeXURCsxa+REt2xmrvq1cbNaE5U6f5Y0fQwrPtpAYUUyiT8bzJfbkDHhsNR2NmAkzitP5oelfzZUyzuZgnuIelx/YhyyJvV25Ys5WIOCdac73hSpD+853FP8usrgMcQVgoJITEaGf8TTDoufhEx89aMIOuaZ1WEM2UYMadqtq2ndhF5HxSjB+hn925mclyGGIIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n9aLSJ1qI1azh5ccD2s51VE3TfdVA1UyPdhcy+mDBk0=;
 b=YiU5rlIoM2yI1pGBwGjrVET5G5g/MLJa86nHtk7ztQuQtDXDNHJxbgs6bItyUX0/UMDXkhUXrkdm1XfygrGSi7f04hQZnbMMI8TRUqMXWd6mXYTwDlft/MzHBgWIPqHSlCcfqJsaXAJvMeGpeX2uvZQ8tgl02Ywy7bDYMwyhfo5RXPPwck0HMiG9YZYw0FC6LwIWUwXPPlYWn98hPtP6zc94gOLv2Kms3gRS+9o7+1kCoTdW0c+kQColtYYywbDkM5wM8PodqNmXQw3JWeSBcc7A5CQ5QVy4tefDUaRy5yrPYsXWPNfTPymQt5EYo8cXnKWi0z/w9z58torexiBukg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n9aLSJ1qI1azh5ccD2s51VE3TfdVA1UyPdhcy+mDBk0=;
 b=Ww5CNhGlk8p5CX4Rm6O4I35NFV4zcu9v3cQ6ykgzcKVZ91pgwDwSk5gNDDy2k1Hdk+L0FoO4GAzwvWTo6zCBTmS02NER2mgbspLNJaBo+pWRnArTPQcMOI5Eb+hh1cjhbT82qRceQwOkyzzNCls/h+GSC/woRp4TS8FU+chEJZqB5jfvhjDR35QSzIboKxjGnT7RYnbUIq3jZptgQ+EaGF+w0+eCbLTZu+X4tefM7T3pmWEEddeHwhhRJ6vHglAV7vEqZPxRzwBZcPkgxgw4ePIXi1WTjTEXqRC/7bJwyFDr6yvfW9AKAmGcGAy9TdS1n8AFvRcAGLGm/8fOlTpZ1Q==
Received: from PAXPR04MB8510.eurprd04.prod.outlook.com (2603:10a6:102:211::7)
 by DU0PR04MB9276.eurprd04.prod.outlook.com (2603:10a6:10:357::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.22; Fri, 11 Oct
 2024 03:34:57 +0000
Received: from PAXPR04MB8510.eurprd04.prod.outlook.com
 ([fe80::a7c2:e2fa:8e04:40db]) by PAXPR04MB8510.eurprd04.prod.outlook.com
 ([fe80::a7c2:e2fa:8e04:40db%7]) with mapi id 15.20.8026.019; Fri, 11 Oct 2024
 03:34:57 +0000
From: Wei Fang <wei.fang@nxp.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: =?iso-8859-1?Q?Cs=F3k=E1s_Bence?= <csokas.bence@prolan.hu>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>, Paolo Abeni <pabeni@redhat.com>, Sasha Levin
	<sashal@kernel.org>
Subject: RE: [PATCH 6.6 028/386] net: fec: Restart PPS after link state change
Thread-Topic: [PATCH 6.6 028/386] net: fec: Restart PPS after link state
 change
Thread-Index: AQHbGYZRPYhz9HNu7k20NdANBO/rHbJ/wqwAgAEJMwCAABoFgIAAAv9A
Date: Fri, 11 Oct 2024 03:34:57 +0000
Message-ID:
 <PAXPR04MB8510550283CD0BBF5BD351E488792@PAXPR04MB8510.eurprd04.prod.outlook.com>
References: <20241008115629.309157387@linuxfoundation.org>
 <20241008115630.584472371@linuxfoundation.org>
 <1af647ce-69e4-4f86-b0a5-6ac76ec25d12@prolan.hu>
 <2024101033-primate-hacking-6d3c@gregkh>
 <PAXPR04MB8510F6DD068CE335D6D7202188792@PAXPR04MB8510.eurprd04.prod.outlook.com>
 <2024101158-amid-unselfish-8bd7@gregkh>
In-Reply-To: <2024101158-amid-unselfish-8bd7@gregkh>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PAXPR04MB8510:EE_|DU0PR04MB9276:EE_
x-ms-office365-filtering-correlation-id: 02112da7-f213-4739-0638-08dce9a5ad90
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?/bF1Iw1+BbZGZ1Z/R6eyPntUUYk3Fw7mZQ2+TmKVg472bIxgZzAi15/tpD?=
 =?iso-8859-1?Q?GtdnMyNzUgFPO0WZZuDxRijuGUXmRj6smEgjRu7zH+npHL4aM3qlPOtdT3?=
 =?iso-8859-1?Q?cgFofRbUcHs9/ydkoAHi/U5x6diOz8dUp40nxPdelLt9vxlOj+/d5IpDcN?=
 =?iso-8859-1?Q?Uwj0FSPtPB4J7yJRZosb2O8hwRlCAyY3nYwL04SN89I3Z5vf1xV2lmfN4d?=
 =?iso-8859-1?Q?JrjKVr7wRm3UCuaAVi13iLf2cUPwGhS3OorLEkONqQmLSR40NSuLbCoXvH?=
 =?iso-8859-1?Q?Sw0iXznpYAHVtruCk1evTttIkCrcItnFVQOM7puPXrmM4CPBQke+oqrXYV?=
 =?iso-8859-1?Q?vNNg7lIpyrA9kBe3FFmIcYP3tb4P4HjF5EEBkmLO9x2w1wgioimRrBFm1B?=
 =?iso-8859-1?Q?+PjkLIjZ1an47ZPxF2iLbtb2y6asbBKQ8Vs6dz28yN61/3wxNzzJjUuvEU?=
 =?iso-8859-1?Q?q8OGO+sfR/9aSpiqjJKM70AovGUSxgm+ar8Q51GZ/kUZTSi3/iErexblg5?=
 =?iso-8859-1?Q?cy6hWNZlf+jH9cjCsDxgXwod6o08/jQ4DDPo2llZmbOkiYkzxHH9wo51M3?=
 =?iso-8859-1?Q?s0N656VbA0eEdDMZcVBYbiYJZe2TgXqajgejDTsVSxpGY/mqSBF5XLrfWw?=
 =?iso-8859-1?Q?MqOszBDa1d1cQdA1XDZBewmz5B6OPn4pXJTwTMUk4YPK9W4Jr6BcUP7JOu?=
 =?iso-8859-1?Q?GqGotbZyhPNaaZADVL3rsW+eb0y8bc4LuTgOGeZ719SZtn2Ga8+AKY/mf+?=
 =?iso-8859-1?Q?uIpPzIK8rK6yz1jJRv6bZm7jAkmHYH2ghEFB/N9egY4BoSW0Zv2thzQ9ID?=
 =?iso-8859-1?Q?mnZ5qnyXV0Adk+nORqzqF9TwBALgf0PWedMmzLP6inzqSTi5zJXOl2Dgg6?=
 =?iso-8859-1?Q?LyauQCYz/oH1FsIENevCRSRwM9Erd/yRPEWE7JMNmYcTM3tll3HGPyFjnX?=
 =?iso-8859-1?Q?pKmKswMcEsPJOnCaddsz0JomKAXOQY8Tz5KuttVnl8w/bgbIuuRZvZ+8Mj?=
 =?iso-8859-1?Q?AQabXiLmHpJ6AO3ea5pVHest9UAZq0axoz/zVYdyWmJEM7WmgsGhDlvdLF?=
 =?iso-8859-1?Q?5Mru5pl6f3PktFO9yQFxNSekNSHR0PzNgtiO8Oi6/YTVHkSH6N5u81cxtE?=
 =?iso-8859-1?Q?JrCvW2Pwo8UnvN5veysejcyNt8NdSllmkx9/8kPfC4LOmsJChbUv+UVvyo?=
 =?iso-8859-1?Q?IQpdKurFGdbs7LyJ22rR14hAOr1NsunuzMhtAVcSvV3zNq2+mXyFNFzlKj?=
 =?iso-8859-1?Q?NPiLczvUHMwhNYnaljVbeiqFrxxzEl0vW8mReW2Qz9SFV8ITZBa5eWrZ5f?=
 =?iso-8859-1?Q?l/AYer+2M2W3sRuEy5TxMCh9aSQ1cUAApmlyrpZSkFoTiH6LvZtuK/p5sz?=
 =?iso-8859-1?Q?LtzXiWiX0pWMTsBAxqHShS30R9XEiREQ=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB8510.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?CjbxEb8a4hX82xNBAFdCQPfjoQte8Bqvr5gdschKCeG2JXpAwk7dcO0qxb?=
 =?iso-8859-1?Q?4NKG8NLT8JjM++1jDRaBCOfTsOAxieBVYJ0BE83TvAkBo5uJdMH7LLvLB9?=
 =?iso-8859-1?Q?KsXH32g4Yf++kkP60D94TfiBvt0GpdB8LdDc9iejrwfYkwM0Cz9arYf6h5?=
 =?iso-8859-1?Q?SweMxtIp0QTxQgE8penyCociWXBocC00BZ3nKxGSk2CMwuszlrfeZwXzjv?=
 =?iso-8859-1?Q?QjoIDav6SvPnjfVdxnWLnVFFeoRB4o3u7WLzbX2X2IT7bv4mYEs/b3uxXm?=
 =?iso-8859-1?Q?Cd1dtqt3CyF4UDn4JJqSomieF1VVL38KpJoBSC5eftgTIMqrJG2ctj7RW3?=
 =?iso-8859-1?Q?Xa+rYTXUTNefD/Iu4xGp/L7ligGLpudSCLontFl/FQ/APIvsCDoCwonVyG?=
 =?iso-8859-1?Q?Z/zF9OlSCq/GlHGHAcCBPqtsYFQCm77hIM1J6101GM87Ts4l8mWSRMad7u?=
 =?iso-8859-1?Q?b8aakTLInvDeRlH1k9JzbkXvOh8E9YHmQyy73rv4f+qpyLvMYu+7DtWRRY?=
 =?iso-8859-1?Q?ddLCcrjdDFpSCesw9IADgUXVU4ZZwoX67ISxucUZEpxVMMuw2SdlsmadOK?=
 =?iso-8859-1?Q?mfRDAyP4H5n2Kfeql7/ZmJhLbmjggRdcFbnXbBUG6z3UJ2uGT/TouGbRLp?=
 =?iso-8859-1?Q?gtpC+Hh8Cud6mHsdq9Ljn2ax/q+DujS3UcQ9EGTHLwScQXZe6v6tVY9ogB?=
 =?iso-8859-1?Q?oyEFgtS4s1LkM0yl0rRC9VyS/z57mY+7j4JCwkzjmgSv7DdqZiAlBu9fl3?=
 =?iso-8859-1?Q?YDssyi5J2wJJWilw2oU6I9RxjWWVSvmkWfveb+75fgvSm/dwsNMXSRLxRf?=
 =?iso-8859-1?Q?D+wrB4v2VRnh0RKIF1AqZ3G7Qq7I8mbr/84GGIAQgqFtVartcyG1368uE8?=
 =?iso-8859-1?Q?Glm60W9pV5wM9uu3JL9kxck+kld6inwqysTxrfWWSYxHbdsi9KIugOivKp?=
 =?iso-8859-1?Q?uUgJyz84UvyTVfGGrkw2eqoU/fG3VAyGT0zT8Z9UvQ6rqTHal9FBgMRgF1?=
 =?iso-8859-1?Q?4AfwPfkuD801YTGVMMHx7qpe0RCK2QdxqeKHjhvSM6PnjtuwNG6sGh7J7e?=
 =?iso-8859-1?Q?gInQyw7OieXalwmIGC1s0MK+Z3Z+rvhSu+ScTifPm3X6s9R1wD+9srt3/L?=
 =?iso-8859-1?Q?jjNJT9Bl/hKsR+N3EvqcgZnzwHROf3jPWNxpwX6ycGT2MXNd/XVOcwEVSQ?=
 =?iso-8859-1?Q?l9pRJbutX2aaqNpey7dqQb9i2j+nfVx4JMP0OS5d7QugI5cm5UsPQ8MjK8?=
 =?iso-8859-1?Q?7/vMtfJ73w5PkZtKLwoKdtpWJIBHCYHLwl9zGYyGpr/hBSgSr7Wl227FND?=
 =?iso-8859-1?Q?trY7SxmbdYNAwK45vpCgOm4+ds0Oo41hfbMl9z5ia9B6WGP8R5M69xoyUc?=
 =?iso-8859-1?Q?/PZlbfo7qXm4j06d1RAJzx8bf2EczS9pZm2XiUXq58stA0tVNuR/4I/Hwd?=
 =?iso-8859-1?Q?ZGfg555bG0rWopH3/Ln7B8cs9QqHg5pfW5uMBlFxapVowQ5JfEWOxhcru5?=
 =?iso-8859-1?Q?OhjtQUndCxU7A/lu/VLOPO70pMwSfvtlg+wEbWDINTEVfbE0eZXCRs4cKj?=
 =?iso-8859-1?Q?tVMCWi/D71tJsNNpYt4LHqGYJxVOKWOitx+jKC0WwO4nIm02QzKyeDlk28?=
 =?iso-8859-1?Q?xsXNibwIGly/E=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB8510.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02112da7-f213-4739-0638-08dce9a5ad90
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Oct 2024 03:34:57.0410
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lPGQXIZYSPqRSltoOWOsZvIOEt1YBVTx+tZEIk+v6rMXlnHoLkvn8EBBX2Lhb4IRgUcmUIBXQsAzEgJY3YrZPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR04MB9276

> > >
> > > Great, we can pick it up once it hits Linus's tree, please let us
> > > know when that happens.
> > >
> >
> > Hi Greg,
> >
> > The patch has been applied to Linus's tree, thanks.
>=20
> What is the git id of the commit?

The commit is 6be063071a45 ("net: fec: don't save PTP state if PTP is unsup=
ported")
