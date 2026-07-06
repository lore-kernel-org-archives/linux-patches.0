Received: from TYVP286CU001.outbound.protection.outlook.com (mail-japaneastazon11011046.outbound.protection.outlook.com [52.101.125.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A27E03F44E3
	for <patches@lists.linux.dev>; Mon,  6 Jul 2026 11:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.125.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783337635; cv=fail; b=YDVXk3x/XL/nMcfcA3ljEGQ3anCiQ04hoJn2/KCiiJGUQuJksQwU3+LQ72MgRAzlzqksVaYBsxpXRXxzCQYZB6pK08bxvjfApiF23q12pSqJ94+LdY0YetYxWKBmpO/LT5oXODErbNUQ6AGNhyPQnQOzH1BL/mLP8yGh/ckC4cs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783337635; c=relaxed/simple;
	bh=yhn9u+EMtAXG3cZLk9gQZ1HbRt5FSUty+wQ5De0VyBk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=o1JaRbJbRRGFKMw80PqhA9LtjyvHHmLGrYirSUU4lVhspyntGYrgqqvvb1mbuGL3pKjPzbMpiv7VY3LgaQV6pAU+LEeapFTVzQs5dl4yt0m6dQGCCw0bdj7c3A9JoE+i8KZyWLpTIqfYjpx5NWDRQ0l9OoRZE+ne28MoCICiJYk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bp.renesas.com; spf=pass smtp.mailfrom=bp.renesas.com; dkim=pass (1024-bit key) header.d=bp.renesas.com header.i=@bp.renesas.com header.b=QV3C0bIA; arc=fail smtp.client-ip=52.101.125.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bp.renesas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bp.renesas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=bp.renesas.com header.i=@bp.renesas.com header.b="QV3C0bIA"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Djxldn3zSCo0UHogMTwnw12GjqHI0Lf76eEo5RFuykVoba6kfwP0KKAkwRKaqyCXg5lANuVRQwO2KVfm/cbpC14Hm4enT+pZawUVC3h6VWzBO7+EO1/kG6DHxI30VSiKZ4D2yCviy5v7oBMPfeXIXbWLPydpC+xMZn/NxP24LKqpa7+Q52g+YScpgN4b0JGYKpKsMeY23cbEaiffmJJyxy7tNW4/2bqIyled9dTr8KYm2I1xIHLzo/TQLXS8xD8B9Q5zAj2Sj5rOuRef+1Apczhd5dR6P8iXyABTkUyVZqcmeLxGWS0EhJBfO53iXqafHPqK9/yLbtbjn0pVBslj/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yhn9u+EMtAXG3cZLk9gQZ1HbRt5FSUty+wQ5De0VyBk=;
 b=TZYDhCPvK7BIlxV4PeU06mdDUxILsBlzRVhd9GFN12ni8Mw6geIWWzkgaTFJ0os8Jipx/5byrDZUS1JgkNrL2SRTkHNyJ5iHHem45mDZi0MLssuY9h1WJgRBevoMm3WpL9I8tg6wQ8apZSaLpAUf5DRTdICSi/cWCAU8XTNaArib5T/DHA//NQVXf7kPXzt1Bt+OmnjlNubCW9SuvZsTIViSWu5rFh4VkofrkfkmW4h9Lyq9keavzi96GzoEXcwArTRb8cfSZWpPsK9TJ35zvSlPq2w8nTUubhvUdjpatUbNjh9GlgjneGqeInWJPf2jX1IfnR6e94SC2KOIRv4RdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bp.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yhn9u+EMtAXG3cZLk9gQZ1HbRt5FSUty+wQ5De0VyBk=;
 b=QV3C0bIASgRosB+cGczEDM0yp1DEcFzp6TiNBpgQmmgwz1fW/ox2yrfuZsFiHrrtn70v9reM2NSTOmXQMejQCDyxQPidKvYrzpRfoH0jssC4sHPx6+HtB0bh1RylgzRuT5rV86aRK6y+7ZxS9XJ95E/adfjcM0/Yw5NNuFmZo2s=
Received: from OSCPR01MB14315.jpnprd01.prod.outlook.com (2603:1096:604:39f::5)
 by TYRPR01MB16392.jpnprd01.prod.outlook.com (2603:1096:405:13e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Mon, 6 Jul 2026
 11:33:50 +0000
Received: from OSCPR01MB14315.jpnprd01.prod.outlook.com
 ([fe80::66f:fac9:2ef6:9796]) by OSCPR01MB14315.jpnprd01.prod.outlook.com
 ([fe80::66f:fac9:2ef6:9796%6]) with mapi id 15.21.0181.008; Mon, 6 Jul 2026
 11:33:49 +0000
From: Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
To: geert <geert@linux-m68k.org>, Ben Hutchings <ben@decadent.org.uk>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>, wsa+renesas <wsa+renesas@sang-engineering.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>, Ulf Hansson <ulfh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: RE: [PATCH 5.10 94/96] mmc: renesas_sdhi: Add OF entry for RZ/G2H SoC
Thread-Topic: [PATCH 5.10 94/96] mmc: renesas_sdhi: Add OF entry for RZ/G2H
 SoC
Thread-Index: AQHdCj+FKf8oM+BZj0GrJ6s5iCm/JrZfgvoAgAChXwCAADznsA==
Date: Mon, 6 Jul 2026 11:33:49 +0000
Message-ID:
 <OSCPR01MB14315350989F1BD556CA5B1E9AAF12@OSCPR01MB14315.jpnprd01.prod.outlook.com>
References: <20260702155108.949633242@linuxfoundation.org>
 <20260702155110.958322610@linuxfoundation.org>
 <ed0c9af450494df5f7bfd72670754c8e48e1f36d.camel@decadent.org.uk>
 <CAMuHMdWEVCxK3gPCrD5cTAsGguE6WOJ8sAHMrX_Ba992gkKubg@mail.gmail.com>
In-Reply-To:
 <CAMuHMdWEVCxK3gPCrD5cTAsGguE6WOJ8sAHMrX_Ba992gkKubg@mail.gmail.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OSCPR01MB14315:EE_|TYRPR01MB16392:EE_
x-ms-office365-filtering-correlation-id: 19904155-d49b-46ae-f9aa-08dedb5272c0
x-ld-processed: 53d82571-da19-47e4-9cb4-625a166a4a2a,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|22082099003|18002099003|38070700021|6133799003|4143699003|11063799006|56012099006;
x-microsoft-antispam-message-info:
 E4X+KCtu38/VQ3W2L/+2xaBg9WOPiBKTGjFLOmyLMA+jRYZkOQ3G3RvdoNraN69s6l9/h88cFcvn8F7suGJzcbwM+g1LcJ5RCr7BprNFIJ6KQY26xGiZ4TxMhWF8iJVcDattXDeCCikaEddL4KboCztQssfOjWCis3zjZTpHWgYQJqz5aw1MnIhZNnJWwff0kB995FQpXmJys8/q9hkj6AAVBlAzwPeA3oK5M9Bohv+MXVYHNhFIWQat72zHkaUn7CdzO7QsLPX1Q5Ey6S8+qUROjBnkHXMbDQFuAyznvnT4Mnk4QYDTBqFRkTfZEiSWQ4PZxgXgydfpJJMob47gFFe8T1CrZaNbTA4meEGrunkwQpLaFU/RqFZdREdYwgF7SYAgL8eN0pZ/v64bRCaFkibgZJORM1hIfTdvXg20kaJZys9gZVggkt47hu1quO/gXFiJU0ctOgnoVGughWDN02JcwQ5rDt/1dAo1iD59nwf+h/fK60OO9VJe6GfoEMB31/918ftLOvG6/gksg3ish8o3taB11zekM8LuOJu5NFSqmKOnQz/xkk0RVOQWYIorvK6A7M4JfjJu0nFfxlmtEn6s+SlVVTH7Xu2bh70RgxQwnod3uvJVP9kcgrNwV/zaF6ErX4c/NOdB4MMwDalQuyM8d9qJk9d/xYx7A627nvjEedHFjxMVM3Tu9FV1CPq5QHMNWX/CK4n5utbayD/mZM5WVeML89ZQglNRUh/u/gM=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSCPR01MB14315.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(22082099003)(18002099003)(38070700021)(6133799003)(4143699003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?T05mbWFwZ3FTdFo4MGE4TjFRQTY2VnB6T3l2Z0FkckhLV0VOcjlmcmZIMThp?=
 =?utf-8?B?SGlXcUpCREM1UHlRaG5valV5Z3R6a1hhb05BbEkrRXR1eHQ1Zm1VVmJqbklj?=
 =?utf-8?B?YzI2SUVRSW1xL3FpcnBvMDRITG4xRU5tODFSM0VBMFp0SDVzak9mWTNsYml6?=
 =?utf-8?B?SkNaeUp5Qkd1NHJLdk5qMSs1bCtLcmVnYm5KWWppMnlSbkQxVVM5cGNKcFk1?=
 =?utf-8?B?amZiMzl0UmdPVW5IOWZoY3FobitZMmx4Z0ZPSkFmSEVOQThGaDJuS0wxOVVj?=
 =?utf-8?B?YUJHQnV2MXo4d0lQc0plWC9kb2VwKzVqUmQ1eWRPa3FITnp1ME9YOGlsSnNr?=
 =?utf-8?B?MmhjaGZxWnpRUFlaR0ZndXllY293VzJlYllVenQ0VzJGRVNIQlo5c3ZkZjlM?=
 =?utf-8?B?T2JSMDlmV0IrN0wxakQ0MWVqYmlBa3ZXVEdPVmtBbGZRUC94UDBhNzRmcVVi?=
 =?utf-8?B?ZDBEUWFFb2g3Z3FmaDhYNVZOdjhIV3VGekpOR1VjRmtwdnJPQWtsMC9IUUdu?=
 =?utf-8?B?WmNkL2xIOWV2R1Q0eVFrengzVkxSSDJueHExWFBZYmpFUzhlVlRaTnVjYTk5?=
 =?utf-8?B?Z3JZd05kR1Y5aC90U3VyOHpZcVFLbzJxa3NOZWJQZkRSMjgxQzIyRHRjeE1h?=
 =?utf-8?B?VURiWE9tdlVXMEdLNXRUOFRVTmVoNjhJaTcrYXZmWmZ1UkpibEFxNjNTME5r?=
 =?utf-8?B?b0d1cDF0WUN4eStGQjJITmovbFowbU1jbUw1L0NtaFc0QllsL0Zhamw5cEpG?=
 =?utf-8?B?RkpiRmdsQ0Vhd3RieTBCSzBKWjZVZTI1MHJMSTZJUzRUNS85NDk3ajZXOHo1?=
 =?utf-8?B?NWhaU3ZUY3BVTlB0QkVwWGZPOWVkNVp0T1JWWFg5LzIyK2JtTkVtZXhxZXpi?=
 =?utf-8?B?U3JjNnRRc0RJeDZiOVZ5ZEZIMnk5YWY3emdmSzEzZXFxSzFVeUZUQkZOV21Z?=
 =?utf-8?B?cmtIekg3dGJTSmp6QUora0ptUUlIQURCQnJTeUcrT1licGhQUGRma3ZnNlVh?=
 =?utf-8?B?SEhZcmlYaHZIMWcrSmkyM2xpSXBCT2dYRDZqWWk5UzdNajZiS1dibS9ad0Rm?=
 =?utf-8?B?ejBEUkhzOTJFQzlVcG9KSytSYkJyM1U5WjVOVWxNUjJjV3kxV3NTS1BzOGcr?=
 =?utf-8?B?WjB6YzdyaWVNMCtnY3hRbjBnWVV6dGV2RFNrcVlURzNaSGNVZmJTRzFveHRO?=
 =?utf-8?B?V0t0RmVxalFMUXI2TEVBMXZqZE1rSnRPSDUxYWZheW1Tak9IdEg1ODJuYmVt?=
 =?utf-8?B?MEJ1Mm40WTZnVHYyZGg2UW9lR054cjVoNS84cXYyZWxoRHlOSFdpek9VUXpO?=
 =?utf-8?B?VFpEWTliZXEvZlVQd2dMalpLVHl0MzF0NTlDMGhzbkF6dkszU2lCS3FXTzBw?=
 =?utf-8?B?YmRjQWJUQjVwRklTR3k2cUN3WWk5aFhKdmppb0FORkNIdUJqeGRBQzhXUWF2?=
 =?utf-8?B?KzlKOWR6Y3pBckIxSVRkUmdBbVFpTE1uZ29DTnVEbWpyVGtRaHhtSGhJM2tK?=
 =?utf-8?B?VnFaeXViZExUc2dCQVhBcW9xVXVjaFVtaHRLdDhPU0l2REFsZ2ozb1lJQ3Rr?=
 =?utf-8?B?WlFXbVBWZ3dWcHJCVkhkWm9vOGkxNFFxeEVjQlQvWFhQY3ZKZkRid3gvaDA3?=
 =?utf-8?B?TStlNk9MbkNkV0VZdE5nbE1KRW1TbkFWc25YZ2NNMUFOSG10bkM1Z1B2L2ps?=
 =?utf-8?B?N09yMGN6di9UdnUzQWZpRmIxcHZ1cUpxZDdPeVZBVVFCdzZpWG1reW80TUJD?=
 =?utf-8?B?eUp6MUd2b1BQSHJkYXk0bHBBZGtMYUhSZE05RFBDUUhFeDZJNWZydTdrdnZW?=
 =?utf-8?B?NlhGT3NreFh0dmQvRjFqdVJiZVRZZ2xOVEJ5RGdhRTB5MmFGRnM0L3pPQnFx?=
 =?utf-8?B?ZjNHYUxsLzlDbmNYVEZ4V202dW5paDFxWlVraE1pQmM2L00vVXZqYmtjdUFy?=
 =?utf-8?B?QXBENXlxYU9GenB5dW1DTnUyMXAxY1ZFZ2Zvdk1BbzBjKytwVTg1NzMrZWQv?=
 =?utf-8?B?cDFxMzlUMTVLVkJRZ2Rra2plYkluOTlacHBBUllDeU1MMzdremtULzNyVjNH?=
 =?utf-8?B?MURNeXNGdDUrOGhtNnZxQWI0MHIvaDE4WWErR0VZS0VTTnA4cUNFV3pxc2RK?=
 =?utf-8?B?VnIyZFFpU3R3cWZCSDlqOWZ1dFFYKzhnYkJnTmZBQ1BpVWhqREVoYnVmV202?=
 =?utf-8?B?c1dodFIwVXYydWhFMUtWTTdsMXMwcUtHdDJtTkYremNabVVLdDA1cjdyck03?=
 =?utf-8?B?VmtIemtsdlZ4K2pqWVdrWWtreVJsVklGNXd4WlNmYWYrdE1vcHdRUlp1TDVE?=
 =?utf-8?B?dGtTa3A4VThFY2k5bUE0eCsvUzl6bEpja0c4c1VQREFKbmtmdzBiZ0k3Yytu?=
 =?utf-8?Q?UMh0AU4SCtJvs26AB4Ig1L/hgoHTdeU+fnrhY?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OSCPR01MB14315.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19904155-d49b-46ae-f9aa-08dedb5272c0
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jul 2026 11:33:49.1527
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5VsPySTAM29kUIEhC1YY7pG78li46za/avuSIljoR6qFW2FI4dujDKH6SyQ5T9bReB+lOZ0HxrcF/NSlFRb1jAmp9S5Y6UG+0Zw8/P5ZpB8A/2YLdt6wL76TvTXaBiF2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYRPR01MB16392

SGkgR2VlcnQsDQoNCj4gRnJvbTogR2VlcnQgVXl0dGVyaG9ldmVuIDxnZWVydEBsaW51eC1tNjhr
Lm9yZz4NCj4gU2VudDogMDYgSnVseSAyMDI2IDA4OjUzDQo+IFRvOiBCZW4gSHV0Y2hpbmdzIDxi
ZW5AZGVjYWRlbnQub3JnLnVrPg0KPiBDYzogR3JlZyBLcm9haC1IYXJ0bWFuIDxncmVna2hAbGlu
dXhmb3VuZGF0aW9uLm9yZz47DQo+IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmc7IHBhdGNoZXNAbGlz
dHMubGludXguZGV2OyBQcmFiaGFrYXIgTWFoYWRldiBMYWQNCj4gPHByYWJoYWthci5tYWhhZGV2
LWxhZC5yakBicC5yZW5lc2FzLmNvbT47IHdzYStyZW5lc2FzIDx3c2ErcmVuZXNhc0BzYW5nLQ0K
PiBlbmdpbmVlcmluZy5jb20+OyBHZWVydCBVeXR0ZXJob2V2ZW4gPGdlZXJ0K3JlbmVzYXNAZ2xp
ZGVyLmJlPjsgVWxmDQo+IEhhbnNzb24gPHVsZmhAa2VybmVsLm9yZz47IFNhc2hhIExldmluIDxz
YXNoYWxAa2VybmVsLm9yZz4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCA1LjEwIDk0Lzk2XSBtbWM6
IHJlbmVzYXNfc2RoaTogQWRkIE9GIGVudHJ5IGZvciBSWi9HMkgNCj4gU29DDQo+IA0KPiBIaSBC
ZW4sDQo+IA0KPiBPbiBNb24sIDYgSnVsIDIwMjYgYXQgMDA6MTUsIEJlbiBIdXRjaGluZ3MgPGJl
bkBkZWNhZGVudC5vcmcudWs+IHdyb3RlOg0KPiA+IE9uIFRodSwgMjAyNi0wNy0wMiBhdCAxODoy
MCArMDIwMCwgR3JlZyBLcm9haC1IYXJ0bWFuIHdyb3RlOg0KPiA+ID4gNS4xMC1zdGFibGUgcmV2
aWV3IHBhdGNoLiAgSWYgYW55b25lIGhhcyBhbnkgb2JqZWN0aW9ucywgcGxlYXNlIGxldCBtZQ0K
PiBrbm93Lg0KPiA+ID4NCj4gPiA+IC0tLS0tLS0tLS0tLS0tLS0tLQ0KPiA+ID4NCj4gPiA+IEZy
b206IExhZCBQcmFiaGFrYXIgPHByYWJoYWthci5tYWhhZGV2LWxhZC5yakBicC5yZW5lc2FzLmNv
bT4NCj4gPiA+DQo+ID4gPiBbIFVwc3RyZWFtIGNvbW1pdCBmNDhlZTQ5NzI2ZWU0YWI1NDVmZDJk
YzY0NGYxNjljMDgwOWIxOWIzIF0NCj4gPiA+DQo+ID4gPiBUaGUgUlovRzJIIChSOEE3NzRFMSkg
U29DIHdhcyBwcmV2aW91c2x5IGhhbmRsZWQgdmlhIHRoZSBnZW5lcmljDQo+ID4gPiAicmVuZXNh
cyxyY2FyLWdlbjMtc2RoaSIgZmFsbGJhY2sgY29tcGF0aWJsZSBzdHJpbmcuIEhvd2V2ZXIsDQo+
ID4gPiBiZWNhdXNlIHRoZSBTREhJIElQIG9uIFJaL0cySCBpcyBpZGVudGljYWwgd2l0aCB0aGUg
Ui1DYXIgSDMtTg0KPiA+ID4gKFI4QTc3OTUxKSwgaXQgcmVxdWlyZXMgdGhlIHNwZWNpZmljIHF1
aXJrcyBhbmQgY29uZmlndXJhdGlvbg0KPiA+ID4gZGVmaW5lZCBpbiBgb2ZfcjhhNzc5NV9jb21w
YXRpYmxlYCByYXRoZXIgdGhhbiB0aGUgZ2VuZXJpYyBHZW4zIGRhdGEuDQo+ID4NCj4gPiBCdXQg
dGhpcyBiYWNrcG9ydCBtYXBzIGl0IHRvIHRoZSBnZW5lcmljIEdlbjMgZGF0YSwgc28gSSdtIHdv
bmRlcmluZw0KPiA+IHdoYXQgdGhlIHBvaW50IG9mIGl0IGlzPw0KPiANCj4gTmljZSBjYXRjaCEN
Cj4gDQo+IEluZGVlZCwgdGhlIHVwc3RyZWFtIGNvbW1pdCBkZXBlbmRzIG9uIGNvbW1pdCA3MWI3
NTk3YzYzZDJkZGY2ICgibW1jOg0KPiByZW5lc2FzX3NkaGk6IFJlZmFjdG9yIHJlbmVzYXNfc2Ro
aV9wcm9iZSgpIikgaW4gdjUuMTUuDQo+IA0KPiBGb3IgdjUuMTAsIEkgdGhpbmsgeW91IG5lZWQg
dG8gYWRkIGEgbGluZQ0KPiANCj4gICAgIHsgLnNvY19pZCA9ICJyOGE3N2UxIiwgLnJldmlzaW9u
ID0gIkVTMy4qIiwgLmRhdGEgPQ0KPiAmc2RoaV9xdWlya3NfYmFkX3RhcHMyMzY3IH0sDQo+IA0K
PiB0byBzZGhpX3F1aXJrc19tYXRjaFtdIGluIGRyaXZlcnMvbW1jL2hvc3QvcmVuZXNhc19zZGhp
X2NvcmUuYyBpbnN0ZWFkLg0KPiANClRoYW5rcyBmb3IgcG9pbnRpbmcgdGhhdCBvdXQuIFdlIGNv
dWxkIGRyb3AgdGhpcyBwYXRjaCBmcm9tIHN0YWJsZSA1LjEwIGFuZCBJIGNhbiBiYWNrcG9ydCB0
aGlzIHBhdGNoIGFuZCBjb21taXQgNzFiNzU5N2M2M2QyZGRmNiB0byBDSVAga2VybmVscyA8PSA1
LjEwLg0KDQpDaGVlcnMsDQpQcmFiaGFrYXINCg==
