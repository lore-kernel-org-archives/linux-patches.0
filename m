Received: from TY3P286CU002.outbound.protection.outlook.com (mail-japaneastazon11010007.outbound.protection.outlook.com [52.101.229.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 841B63DDB07
	for <patches@lists.linux.dev>; Mon,  6 Jul 2026 14:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.229.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783347355; cv=fail; b=p5JSS9MNkuLQ8VL6reJBiVM99hAKQgEGac1m8EqKQZ9ftF1jaG0FSGXVawHcXBRYNcoP8Gb5mNU8Dn1Fus7k57LCCzz7zl/k5NXWrZ4ma0YDpO2gB23nI1VSF2VxY/JUCg1LJ017GrSSc+aKwMUGYn8N+PbNgc+EdFCZ5+J2GeU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783347355; c=relaxed/simple;
	bh=ULzDlA5baC/WbW3IqAJ6HeemTxXnY2U624B9fUThIY8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=MAJVCEvnbjxAL2UOF0TjV7Zz6tbeWebK0jYB/02/TTRSjYBo8yUQwMZT03H/qAT8UFqMbh2tGu6yWEtMixvw+sFMySamg/1nVZ/OFz4qSSFpOIyjrdYdq0X47feBZsgGkPsptOVLz1EviucPXCeGhqf0Ln1AFJtCnhk1Hz/Ac1k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bp.renesas.com; spf=pass smtp.mailfrom=bp.renesas.com; dkim=pass (1024-bit key) header.d=bp.renesas.com header.i=@bp.renesas.com header.b=By4Gj9vT; arc=fail smtp.client-ip=52.101.229.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bp.renesas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bp.renesas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=bp.renesas.com header.i=@bp.renesas.com header.b="By4Gj9vT"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ipfn7sWnZKU2iOkRiirs3tn7Q9ZQuzQskAPNXrQ0ia3rRuSDlbwpJcN2JIa4TtzR+KG3vMj698XzXScS4mNW4xvwyG9JdCnvgHP6+rRw+kTausNWG2F8oLjleu6gs8kAN5lsrQJ2hCqs1N82egIZZejzqpjldXIBXXBvCM/Lf9O7ilGkU6WZDWT/iMxLKfXKF7KG7rquybf8apR4xx0bMPf3isXIrzY32XJsLAhNXfTzKayDq2UGCiraJU+AoSEDT1D5Ja25gn1XhqPfBK+FuT3UPiWDdG2ionuUwKNrEFTrxdANLG+1dvWICEblS7Vu8zEVthyev1J1/jJ1Y7FzHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ULzDlA5baC/WbW3IqAJ6HeemTxXnY2U624B9fUThIY8=;
 b=Kpj2rBajmRHbgJcNzia0x/cpqHXa0HYhJAZZsklXudWxLLyQF3Q9G9qtroFzRHlTC3kTiFGNanWCvDRaCEQPcYdfAzTjIESKIOEA0v0nl2oYv7wTpnQuKENEziSbV+57kvmlT5Bp1NEkovetdvNfdUayjPUP/2CYcWm3NG6aGDLOWRc2FdX/5tH/6umOCbpi59JI7ZTywYiLSXQP0yYaLwDl89pGifwYhu6d3/lGhuVcVWaKCMuB++yvjVkwlVOck70S5+Kt4Csw+UHNqjPvRgrAwBViIZQeAIBLTi6/Jd4LK1qM3HjSraUDzv6lfHg5+9PUmMf0Tr46ezBC0CNrIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bp.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ULzDlA5baC/WbW3IqAJ6HeemTxXnY2U624B9fUThIY8=;
 b=By4Gj9vTjRODT9Sw1M2bzsqTPs55iGwp5Rj/mpygvn4P1PH/gvrGuCW+K2GW3/TvDrWYOBZmFTgp589foCGQsne8BawXuuU5pRCmirvxFA4sYnQGbSJz1vx6HIcnB8x3gSROaa+R3i+32IgIE67I8EK/OZRHOWiBPfryXtlQcK4=
Received: from OSCPR01MB14315.jpnprd01.prod.outlook.com (2603:1096:604:39f::5)
 by OS3PR01MB10297.jpnprd01.prod.outlook.com (2603:1096:604:1df::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Mon, 6 Jul
 2026 14:15:48 +0000
Received: from OSCPR01MB14315.jpnprd01.prod.outlook.com
 ([fe80::66f:fac9:2ef6:9796]) by OSCPR01MB14315.jpnprd01.prod.outlook.com
 ([fe80::66f:fac9:2ef6:9796%6]) with mapi id 15.21.0181.008; Mon, 6 Jul 2026
 14:15:48 +0000
From: Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
To: Sasha Levin <sashal@kernel.org>, geert <geert@linux-m68k.org>, Ben
 Hutchings <ben@decadent.org.uk>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>, wsa+renesas <wsa+renesas@sang-engineering.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>, Ulf Hansson <ulfh@kernel.org>
Subject: RE: [PATCH 5.10 94/96] mmc: renesas_sdhi: Add OF entry for RZ/G2H SoC
Thread-Topic: [PATCH 5.10 94/96] mmc: renesas_sdhi: Add OF entry for RZ/G2H
 SoC
Thread-Index: AQHdCj+FKf8oM+BZj0GrJ6s5iCm/JrZfgvoAgAChXwCAADznsIAALA6AgAAByRA=
Date: Mon, 6 Jul 2026 14:15:48 +0000
Message-ID:
 <OSCPR01MB14315F1985B25A9D1BA98ECF9AAF12@OSCPR01MB14315.jpnprd01.prod.outlook.com>
References:
 <OSCPR01MB14315350989F1BD556CA5B1E9AAF12@OSCPR01MB14315.jpnprd01.prod.outlook.com>
 <20260706135124.draft-0005@kernel.org>
In-Reply-To: <20260706135124.draft-0005@kernel.org>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OSCPR01MB14315:EE_|OS3PR01MB10297:EE_
x-ms-office365-filtering-correlation-id: 49396870-c031-4403-f47e-08dedb6913c1
x-ld-processed: 53d82571-da19-47e4-9cb4-625a166a4a2a,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|23010399003|366016|11063799006|4143699003|38070700021|22082099003|18002099003|56012099006;
x-microsoft-antispam-message-info:
 gZt5go+B4OrIyimKda0EdwP/qLRKmdrT0YHlHXjwM0asfTmOaYL+fMYZjbOPpPOFHW+Hlt9M87NO0kdziW1ps8ZAPlafbssStm6GhS9X6BNhQDTn98TLNi6wLF9Xs9bHUkKJ985MbcSPAnIiyJXYxHVqLdpJW7Psx9SSf5AT3AxftrCFZeQngPcGy7V8FNccaSU95ZKBXPhcAxbj1eFLyfe6CiVQrVD+y+qvsrED2I/jGLTjSxoWLP6tCc6Ji9s2PHy07txKxiF0itwAsndr12UbSLjhDO6faA7GoX+MwmqZNCU1zCVyC+DK0lZ28hgfh4fIJ/Ztz+StOmugx1a/EkBs2tVQPOIzbKATLzmELnRkn+x5ItekCg+DG5oC/T3COlGNZuKvxy1siCqNx9JlW1iDWFo6c9GB0KGgpEaX63oQi3myDKogO4zpNnvSjg8ZcuhpU2NXjLxvCQ8xAR2bNbsoexdMwfI+hJcbQnOHB3ZZP1wwcNaq837qjqM2ORefLnufPJM7Z4I9pmp4JoAysNTh84vA9+s3khb3Uq2GTL6LCaSgPRsxZeGcnud4MHiRCix4GkxpE7DPsUOvWAyjpJkovAwOrR0492whOPrsav1RJ8zEW6KHINcjquU1+DoPN9k3rQZG1+3hFP+BqkL2QniXevPTn+3UoJMFdFfazpH9dMP8NcE1HrdhqFsxUHvAFVVHgfEHtnw7zwKMN8DuFa06UnmhjHeiLHPyl4szGR0=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSCPR01MB14315.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(366016)(11063799006)(4143699003)(38070700021)(22082099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?ZxQicTCQVrMKEGb6GSOv/QeTHOhUHLcLp8H/lPO9GJUcoJ0I7wBBRcJ8BRki?=
 =?us-ascii?Q?Mt44R3+grbURXHUewbU1RSesj0n9jxWNXVJ9CSOuIsyUVzqGP7DbFp1bnjnG?=
 =?us-ascii?Q?VpbWM8fKv9FU5VrFnDP+BVnnxqlXShqjqKY+ZHRHahoV1MxuJnPVkdsKyRZo?=
 =?us-ascii?Q?FlPkKakZjeFPfDmKOCyTHJRCZzdkLWD+Bj4517R4IhuynoC8kX8Ag9nb1CRM?=
 =?us-ascii?Q?TVryGHfM2xcLk6aGTXB39XIMFm4toc3STrn4SM+bxvFfGq2CW2VaeKuLC2AV?=
 =?us-ascii?Q?ox828G8yHaRruenEwxw0cfJ1a9dT2v7ve/+N8fNM32YWmP9fZFZVqjrim9jP?=
 =?us-ascii?Q?tMKPnCFZQdt3qovuUVXUndyPh3+i7r89wlEPgcZQBQwIl0tFGLicNxl4tyh0?=
 =?us-ascii?Q?2ydNhk8MCfRZN4O1Yu+2LGE6EQmQfHOWh588/K+6PWqlGtQdApKbGStqKSuS?=
 =?us-ascii?Q?y0HPkJPVpSeUndUouMYHcNtoHxGJyw61+/btxV3JURBxfWJYmDXhs7GFE+6z?=
 =?us-ascii?Q?n5ycX2KvnGXZR0Fk1DM64p4PbLGT/tAe82Xjs0gFKn31/w/PVw9EvuYArjCc?=
 =?us-ascii?Q?x6ntZMQEWkV66L/yGxGWQZFUlxX6XYqgjVkdOkZZdsGyj717+wlRYcJY74NQ?=
 =?us-ascii?Q?C+DUheHyDJNqHI1BYt7y1tvVcar+h3CM+6lQHhd2YRaP5SEMg0S0QnJsbkGj?=
 =?us-ascii?Q?/Uqtpj0FkaZHNVyiIx+Yx/l15dnIehJ2HVvF08vdG3rVtcOdjv+7IZtmB/Uh?=
 =?us-ascii?Q?bCWvYIDt8WPIrgkRaN6689gftOBxSIQwhWVDcZG/S3DbjUCqvYUUZyEAXNYu?=
 =?us-ascii?Q?OS+EHKSVeSRAZm7KzavwCAdeq9N8UkHCHDYaXvPsuPZZ+CMi2b+YQ2DKUl6f?=
 =?us-ascii?Q?B1flire7ZTM+QuhZ5u4VaKJNdlwEfqUO/eTLmo6IT6kHuq6l08n8Nv1//Bm1?=
 =?us-ascii?Q?Zboiz2jLk0LZTfJyHddtCQafOlnM0lIJNeKyBTkXxLt31wadmBIIqpqSk//p?=
 =?us-ascii?Q?uY0x1XpSIqV1O89Dl7R2R8xuC7GysguMpko40ycKaG7y0luUzPi646irrOX8?=
 =?us-ascii?Q?GXneiGwqOeXBUCOU3EaVc0XG806NLEjSR7cuj0iMRy0NsED/omKi6ys8vvOi?=
 =?us-ascii?Q?SgyL00lHgZFsrvBWjAzSDme+imcPKR3O4U4qELliHKhRSERGYGFb/YvNmk1h?=
 =?us-ascii?Q?NO1W65ROfZTBUFykyHF3Zi9NXmJzo+T0BT8+dzg8GGSK53rY2JNd7gYorEfw?=
 =?us-ascii?Q?MXQXZhk0zE7vgZsXiHYwBYDrmDQn/zCs9rVXvsCnlcd8u3/FQxOgS2pkjpmy?=
 =?us-ascii?Q?iXMmIqBdca3jFRRc5kwt0i6bvq01elPLlUCnFVimmzVSUwC7Oa/gj0YqQPgW?=
 =?us-ascii?Q?4aRKWlpyJvLIDJT+orhvJb+3h76c0pugGxGZ/ZokFfnEtzS5R0MG2nc3KbDX?=
 =?us-ascii?Q?E71x2Td4hFMkICFD3++e19rOA+jCjBX244P4j67GfKxIY5shylSzgQcZSH1o?=
 =?us-ascii?Q?F48Y3PuP9usVfutaixQXnl/zyNXGp3sjSU4oOpFE6PAsvuTX4K+KNQlDvIDG?=
 =?us-ascii?Q?HzgmBkkDxaUqhIQuFEdgzfHz44ks8vmepkNVUtDyR10TVkFOvlZ60oWTJ9tS?=
 =?us-ascii?Q?uvaq7DRwyuTQs1QD3/8OGib05iQMP3jjcfHWbEHc7ggCPc+n+aDPInkybSC+?=
 =?us-ascii?Q?LyXmHYuJmiMTsCBCw47A3tLJlsUESFd6pQL8zyT0brKIInwG7iU90RSGOvNI?=
 =?us-ascii?Q?SQ8ZikklTu9lFzqJB2Oc/LTy3ESWCMO0ZYIU0t/OI0WMrmjzfInO?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OSCPR01MB14315.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49396870-c031-4403-f47e-08dedb6913c1
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jul 2026 14:15:48.2236
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eDZKPSY9V4OSjFcN5iYrvDiCh1U3M7B/cE3XjyGOJWYGFpAW1fpIFKLtQeg5z2lQN0jI/1LaR43nDr1MA8AxCGQ3CQhhy/dolgU037FsOBe3eB/X2eSTsrhhJiP5F16x
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB10297

Hi Sasha,

> From: Sasha Levin <sashal@kernel.org>
> Sent: 06 July 2026 15:08
> To: geert <geert@linux-m68k.org>; Ben Hutchings <ben@decadent.org.uk>
> Cc: Sasha Levin <sashal@kernel.org>; Greg Kroah-Hartman
> <gregkh@linuxfoundation.org>; stable@vger.kernel.org;
> patches@lists.linux.dev; wsa+renesas <wsa+renesas@sang-engineering.com>;
> Geert Uytterhoeven <geert+renesas@glider.be>; Ulf Hansson
> <ulfh@kernel.org>; Prabhakar Mahadev Lad <prabhakar.mahadev-
> lad.rj@bp.renesas.com>
> Subject: Re: [PATCH 5.10 94/96] mmc: renesas_sdhi: Add OF entry for RZ/G2=
H
> SoC
>=20
> > Thanks for pointing that out. We could drop this patch from stable
> > 5.10 and I can backport this patch and commit 71b7597c63d2ddf6 to CIP
> > kernels <=3D 5.10.
>=20
> The patch already shipped in v5.10.260. Since it's behaviorally a no-op
> there, I don't plan to queue a bare revert.
>=20
> Prabhakar, could you send a proper 5.10.y patch adding the
> sdhi_quirks_match[] entry Geert sketched (.soc_id =3D "r8a774e1" - note t=
he
> missing '4' in his line), so RZ/G2H actually gets the ES3.* tap quirks on
> 5.10? I'd be glad to queue that.
>
Sure, I will do that.

Cheers,
Prabhakar
