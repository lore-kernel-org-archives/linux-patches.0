Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDAE082890
	for <patches@lists.linux.dev>; Tue,  7 Jan 2025 05:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736227155; cv=fail; b=F13BiaTlQG6fZrDDHerbjaSlFg1xJSzZ9qmSbMdypIiOeri7HZCep1wwRqONiODN/ji//sCZjWMkM/5BYSneXn+cY/ATisJintua+uDR+7vyX7fv23yp4J3jxmz55ZTU6tAIqSq05IfY2Lch1nubDnc0w/H59HGtHWCrFnV0a1k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736227155; c=relaxed/simple;
	bh=o8/aMYRfWTQQxA6nMoS0vpH6J6WVp57qDaXpScTEyt8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=DpOIVZ1Ps36ARjfbEjyR78TPeTp09pwv3E+j9JHr55t+/tBMpd8AtWHwUGahFJqQWqM+14wN2DSaC8QP8meW1dZU2wWMEFJVJolZl7KeTM+2vG0QTWoWQ+sNIwqhILwSxM2+gQPphlbJImen+bAXdlNs86kmP6Kq0MOgR3JMNIw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=o26+Y1tw; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=d+KlGpOO; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="o26+Y1tw";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="d+KlGpOO"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1736227154; x=1767763154;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=o8/aMYRfWTQQxA6nMoS0vpH6J6WVp57qDaXpScTEyt8=;
  b=o26+Y1twJ5COK0XleKolxo3dNPpPjsAZcsPd32cw0I6cE0NTZv6we4XB
   tOEz9I8+M4Z0Aejt8HoYvVDFdT0yN5CvlXFciaREEw//dHDMbuVOJP7mm
   1Ba9dBwQo0hvQrJrYkWDsGDsafZ3N55KyJZOPWd1zUFuh9H1SkAkj4lDU
   wu0uqLPVboDvM6smOSXTXLB0J3UFq0eJLnvWmq97GocYF6slvSvafx/y+
   nre0rZtC0gUTeORPFEMkzwKiMMfAp5FE5opjtfYFldt11bRSmuhfaHPNh
   fEqPjlnuWRGpfDWQrocltx/Aed1X682MRa4K2S8xipRJikyFIsnM6BdSI
   g==;
X-CSE-ConnectionGUID: jLtAJwyqRcWW4Io0vlNBog==
X-CSE-MsgGUID: n3efB6xrSHW/q+2E+xfmVg==
X-IronPort-AV: E=Sophos;i="6.12,294,1728921600"; 
   d="scan'208";a="35361558"
Received: from mail-westusazlp17012037.outbound.protection.outlook.com (HELO SJ2PR03CU001.outbound.protection.outlook.com) ([40.93.1.37])
  by ob1.hgst.iphmx.com with ESMTP; 07 Jan 2025 13:19:07 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=daGPqVhpjYOq2yyTAcN7DGz814NQ357E0CvcWwMM69aOHKoqUB4j12+3w3H9AO8okt5FVeSjTUGwAI3l4gbX8FDWAkUsIaBYgEEnwa5dgfHN/JOQBras0CjDRxiaEXVEQeqHHYIj7a9kdSxdLQr+7XSJvf5IPSUvLkbBjmB84XJxtCJnGkv/54ItwsytQeLjHvL97Hiu1Y2/UxwHE1K/1NrClIArdwls9/HJaD3Y1kqL+8aLBKgP30o1Megfnp05FlfFHb5eOaz/fWKyeQ1yFj8yco4cajt5gNXy+o0NWLW1acEOcsovc7rsBTll17YZ8RGlOfW+4EBF66xEhRDCkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7zLjBWXZLCO2X8cZmMRnrxo+ShM9q++sHVwJeyxTeIQ=;
 b=E7HQufqKB6eOSlqzIeYdSPf4UIJ1wUutps13krhuZ4i3oF2uNU1k4bu4WD3tE8uY/uvhb1X85pWo89HRgrq7ccormnQ3pQzBG0pftO44YMvaS/CtfOxBb5atiYtnqNDV4LiPu83iOxze3lkOcZMG2eay1+B1uNWwZIrpIMrtGnVIIwt8I+W2zkstOc2kZoeAQtvAM16KGw2CGrwNXB1FHdJ570kX6JfUPZQhfNvY9PjGZfY88hJB3mYUPgNuUQ3rXSZ5XbZVSEbB7fk8fzYPFFQD3VzjMLDc/+3xGxpG2rV4ehY/oYW+pSYk4hkuaPkA2LKKMBZnSnBlOxQc2UEMBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7zLjBWXZLCO2X8cZmMRnrxo+ShM9q++sHVwJeyxTeIQ=;
 b=d+KlGpOO5XRFrtxNqTYgwtY2TeHIHCMk1MLV7hOdjetYL3F3y2dGzGYuQIt0kFuTVEZdQah8pdkW2yYs+DkBzCu+0VVTV6riRQu4XSPhowJV3FPliGzQ/p1AfEVulkeQcsxs/Gw68wOFbB6K/T34819JuWu7GmaNFss6sMBLX7k=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 DS1PR04MB9128.namprd04.prod.outlook.com (2603:10b6:8:1e1::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8314.17; Tue, 7 Jan 2025 05:19:01 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a%5]) with mapi id 15.20.8335.010; Tue, 7 Jan 2025
 05:19:01 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Luis Chamberlain <mcgrof@kernel.org>
CC: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"hare@suse.de" <hare@suse.de>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>, "gost.dev@samsung.com" <gost.dev@samsung.com>
Subject: Re: [PATCH blktests 1/4] common: add and use min io for fio
Thread-Topic: [PATCH blktests 1/4] common: add and use min io for fio
Thread-Index: AQHbUT8Rg8K3Z8UZvEifQs20WYF9JLLzmiiAgBKAaICABMpBgA==
Date: Tue, 7 Jan 2025 05:19:01 +0000
Message-ID: <cjfenlexiawyze5trlgbpb4agu4olkosrgbfpyiuiefo4siott@smbcjylq2zwe>
References: <20241218112153.3917518-1-mcgrof@kernel.org>
 <20241218112153.3917518-2-mcgrof@kernel.org>
 <dn545vjkmyinrejvdfb45ve6xa3cebbcwvhdajkxzbhtl2yww4@oktw5u5q6jki>
 <Z3i0mwKXBUiut3DN@bombadil.infradead.org>
In-Reply-To: <Z3i0mwKXBUiut3DN@bombadil.infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|DS1PR04MB9128:EE_
x-ms-office365-filtering-correlation-id: 080d620c-db39-4dd3-2a40-08dd2edacbd2
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?GXTgNCRU1sykpPPxnoQkkYd0ZZHLsK667NmtTHhmtyuhjytQWBz9QU1KFHZ4?=
 =?us-ascii?Q?o5phkRDZWhxya/EGqIEVOEPMa4h79XZKKaEdBBck3FSrqkHjoyE1IuVSxQHQ?=
 =?us-ascii?Q?wXYvDcYJrt2TjSWXIONK8x2oXJSzXzu1wMZhIVPzwsoiMTqnLs3/WnXn5Z8G?=
 =?us-ascii?Q?bTSGSoIRoxixz+IsOG9rljIRTgU9PLpqsh7Eh3EGDuW1i7UY2uFtVjnYmA2M?=
 =?us-ascii?Q?AiQ/OSGiNWyAaqptp3tWSZZN7LOBLdjc3l3EIf45oMrvE7dGltUz2eej2pja?=
 =?us-ascii?Q?d6n7Pff9RMQaOji75bfnQLjHcoPdLfFo6rmDEBWQMWdfJZmFS3MIOEfAldYh?=
 =?us-ascii?Q?f8Y6KoV9OSNgp5Zpdahkqs5yZnqr8DKAohUIxSiAam6aiLys/XtrNQbz9N7n?=
 =?us-ascii?Q?V2i6JEYg7JgIJ4nvGS2LAJYe9kkrSDrv7yGQyr9aBWxp4/MwkfOmXuESirop?=
 =?us-ascii?Q?hWo8yhTmkxdgaL1YqNvbaeQ2zFP0lm4zJ3qxhqFdrumFrvGJjhh22gpOmUDV?=
 =?us-ascii?Q?bbd6NeXHrMmuxsejc+pi7MGSgEQE05eA5rTaeOnRFSzREj7R86o4eyhAsRJV?=
 =?us-ascii?Q?6exwsOIoyLdyS6fS+2+4F0Hxf7UakBIr1NN+sIGBd4Bl2t3bwikrkygfwF3Z?=
 =?us-ascii?Q?z8YlJ6OM5xm3F+YRVYoLPsjmYp3+jBd11aCnzugFRFD5QytuOpTVnYUq8BsD?=
 =?us-ascii?Q?57VTv6xvhaZUKYv1GGYUBADLgK8EiOFNYXstw1pOOOgdb4Q1K3+cXfOdEqV3?=
 =?us-ascii?Q?vb3bMi6X1zoDWI8Ymi9MJGKGuOoegpAQtEIbGMq0CHay/uYMpqyHz1R+C8yn?=
 =?us-ascii?Q?I+wrMkWzTGeaRtl4wO3AMWq4A1lrVUMXbuvV16baMZXNLmWoaDZjAiDVhel9?=
 =?us-ascii?Q?JDpFo09R0UdC0wmZdbJCIlWI+UT618DK2YEJ1aLs9l+JGHGXjaeIao6Qhc8Y?=
 =?us-ascii?Q?G5nmIP/JSmws6QEsuQu5wMbc8Ow9pl39TqQg3Z+ay8wg3ZrigO4cm3oT404K?=
 =?us-ascii?Q?FW880KMoHld7XorB1MAkaUD5/XKBaCw/Sq2yxmyEd9Xup3IwBgodhMli74f1?=
 =?us-ascii?Q?5bExpfJV7fWWgxXwpXpqgBhWd3br7h8X9yrHwnledFqSMVF2DcyEp9qTf1T/?=
 =?us-ascii?Q?br0DYKOfwccfUzS1yUeOJriJVDJC2eKMjdR6arKOtZnHq79syO+erJIZg4Vr?=
 =?us-ascii?Q?cn2w+s4K4atDn5OsCtTeHCrhlS31s/ZkoMfiXRKYdeHmmEqIjbJO5HM/3Nba?=
 =?us-ascii?Q?XtTVBYP2f/3w+WYXE++QvO+ptWC3UG5obFvK2Jytk+rxgCujwqYetGsdQ2VX?=
 =?us-ascii?Q?P8UXoRukk88g6ULk0CP8PhR44PohfVPjscGu/mBWm/+CyEF2TVwlldqISb0Q?=
 =?us-ascii?Q?sb8NV4CulC7os+XwHcyPe5efTnoeDKy3lA+ksmPESIbw6frAasOe85ll/VeW?=
 =?us-ascii?Q?jvhG8uoCsgknlH6XXnLw4Ay2WB39tKf6?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?ApekJH80qy57mmSKS6rKlBuAGxUKLFxEomWFNKoc8WdOsNCzlV1tcEvc3cN4?=
 =?us-ascii?Q?q7szZ9c1d179O8ATJV5R6RpxDFvhfKtmbWFhXaia2TVMLObOJ0wU34uf2tN8?=
 =?us-ascii?Q?rzh6eSZuy+R5buGvVg/DpNpcIgES+39yP/A1Q5cL1qESqz+oj5pWe+gdu69q?=
 =?us-ascii?Q?UHKFHasgX05OUohuECOwn3iQYdiBHN0qxfolFlWVP059+oCxhvq+3xIp+9V/?=
 =?us-ascii?Q?Rj9I0wYwjYXnikusdw4lRpVkac9Gh5dRZhbbvXdzx1zpY8Qze1bvYIn4il6y?=
 =?us-ascii?Q?CHXojPvD8IhyzDIQbzKf6WNBAft0P/yi8I/O6yxz+PFY2SRX3j8mVrFoor4R?=
 =?us-ascii?Q?9sC39GxmhI0zLFVQ+J8i4H0S3jJZ55sczH84kfFqazMBgYd2h6cprpyU/YUm?=
 =?us-ascii?Q?oxlJaCu83oGQwprXt5KtPlYh6ignfL/NDIw4egXyeQMcxPxtTcVJw48Ed/Z7?=
 =?us-ascii?Q?vq3Y2CJlXfacLiNuVxyLr32kMtzvpkxQ1yA/CWOvnYNPylETLQ2rbggvjxGe?=
 =?us-ascii?Q?s8TKvbOd4XRWjA0zXu4145jXRd6vuGRbwmkMc6KH1DyI0noKgnMcc2CFIkNQ?=
 =?us-ascii?Q?/5Jxzj+HcaeUMIkozW6bioUXWbTJEuhZlNX7amWjyqLq5Tl4xYstFeya/4Z3?=
 =?us-ascii?Q?ZFrohPNeDhwqEcdcuOFVH8NOa6/rIoetY0wH31BMkC8DnLG0MH76eHKoYe24?=
 =?us-ascii?Q?/WMQ6xZo7kS59XDdHlFe951EQPDxU6/kTqwkdE530OxGwe4BekZH3wLFsdf2?=
 =?us-ascii?Q?qjkfdujwtMs4HldlMQAAXuL2yASU37ObWZ0yno9Iqsqd9fz2jIgA07DHXB14?=
 =?us-ascii?Q?e+XwaxU3oTJ5VbshAu1lwxus2lgz1vQfrOBQviPH9dx1w5jrH2s86TL2R8HR?=
 =?us-ascii?Q?DfoLhXA4IzyGIJvjO7JpevhHWxTcH5rr3TZqsAJcEE4q+R9KzcRvx9ExA07n?=
 =?us-ascii?Q?f9jUROZL5+TjWu2x5UrAWm+YEilDI+Ql3PoEP3TXIOzUG/7rRH52TwIDfxYw?=
 =?us-ascii?Q?s8cBZWNmzMk0ZUDxemUdHhZOhWNqxUhpA4m/0k4c9YUn0u5yavL7viyTXcqf?=
 =?us-ascii?Q?Efo0jH3pTSw6TQTEeydORzqcH5Wm0cUi1F0QL4HW12dx6aV1ZbI9OHF7d8IT?=
 =?us-ascii?Q?PlCN4GqLkeAXCYICqwtmZa8GGr/piEcYL3rUM8eQ9ziYX3WCd4iX8085xIap?=
 =?us-ascii?Q?sdU8uD9pTO0KD9XwF1C3DGrLUOH7LI70n97tQkilfw3K+5MlUz8ALZPb4qJh?=
 =?us-ascii?Q?AUVoMqdOhe50cPqpgh5oPXBO4wwiNwg0mUaFRmuhTdbTmMmxtSuAlEZzb6+H?=
 =?us-ascii?Q?7oOvADyLgOuI/w4eCKZPklahQHAFcrRaVyUCzr/HCZfm2ec/qFSv1ADxdysX?=
 =?us-ascii?Q?eFvUZN95gP++ukaRBPHrQEAAXXrCTw17wgzhn9yH6Pbdktudd3Ms1i83Mofw?=
 =?us-ascii?Q?RrqNaMAdnF0fSuEMp/u35cTFZk0lDsBUvEuDWchNHZHz0AoSMijAQlWFMco1?=
 =?us-ascii?Q?myCuAP2yFpTItDF2Ya/q+T4Fwp2p2UbXbw4P+vqC0+I+3RaOFy7I49LYjKKb?=
 =?us-ascii?Q?Keh1fxyno0HyfTnYxy8BFN5v0LWPSjrrhq6gg425/oaR1jJ8/doP6/EdgQ0h?=
 =?us-ascii?Q?sbYTYRz6yOphlJ9S3CPN2Wk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B1EA3CB81335D343A6E04BE508E834E3@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	zBZADoNmmMTXQv14lliWYaawJy8RolyNAWsD/mCwfvGwreF0WeHo387cUIBZya4UUrwK5PsvJfu+8sumwodjwGqcJpVorKuMRj9C5QcClaRSHxPTw/1YxQZiT4DgXHs8jJFQEUq9Wz5NUm3N6LjUJwc5YE9N1HnhOdGexcMevbUWXcHvWsAzSAujvijDH/bpGnzGrvtYUMcPRdU7Wl5FgXoLbP+OEr1G0ufSW5Vwj4gHoy66oA0DxsMgJoBzKIa5Yfl9dPP+aIz8+87cbYZ+MrD6bKS34dpDXnxNY+zFyXIJA/IaXnad1it5N319niEJP2iI9GnV3YD1LqKJm6EsEaKOZBeDSK1VQw01x0nbvzkVv+287P1+gmxHMQu3TU+fv+Czq5uTZaYy3WgzVuNONzuJrtDg/DFlOIW4RtOz0GWyM6HWDQNTuB3h3c/urWN1A8SCsjKQEITUDQVhCkxZRaYZX+hu5FvkySiP043/pG7UqZom2Ho/L1QQvmtTDcMg+lcPGTKKbro/wGKmc6XDSiHZLlDeBilZWXNcke1HB3cazKVWnz7bU0lKSP8n6Cv5uRhF3ix1V8eh/klNCm3nzr1U42Qa6q1IY4Qnu67i4ExPmbZ/zTl5vuJC5v/BJUF3
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 080d620c-db39-4dd3-2a40-08dd2edacbd2
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jan 2025 05:19:01.3523
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FBU0Vy7YOxFLqINep5Duz5bLw2EukgGZpi0J10/yAb8YGY6bGA5YhQpRTFZKp0IFqTSHLdbqbIVOdAov68d4ke0jclpvioykBiAOU+cy+Fc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS1PR04MB9128

On Jan 03, 2025 / 20:10, Luis Chamberlain wrote:
> On Mon, Dec 23, 2024 at 09:37:48AM +0000, Shinichiro Kawasaki wrote:
> > Hi Luis, thanks for this patch. Please find my comments in line.
> >=20
> > On Dec 18, 2024 / 03:21, Luis Chamberlain wrote:
> > > When using fio we should not issue IOs smaller than the device suppor=
ts.
> > > Today a lot of places have in place 4k, but soon we will have devices
> > > which support bs > ps. For those devices we should check the minimum
> > > supported IO.
> > >=20
> > > However, since we also have a min optimal IO, we might as well use th=
at
> > > as well. By using this we can also leverage the same lookup with stat
> > > whether or not the target file is a block device or a file.
> > >=20
> > > Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> > > ---
> > >  common/fio |  6 ++++--
> > >  common/rc  | 10 ++++++++++
> > >  2 files changed, 14 insertions(+), 2 deletions(-)
> > >=20
> > > diff --git a/common/fio b/common/fio
> > > index b9ea087fc6c5..5676338d3c97 100644
> > > --- a/common/fio
> > > +++ b/common/fio
> > > @@ -192,12 +192,14 @@ _run_fio() {
> > >  # Wrapper around _run_fio used if you need some I/O but don't really=
 care much
> > >  # about the details
> > >  _run_fio_rand_io() {
> > > -	_run_fio --bs=3D4k --rw=3Drandread --norandommap --numjobs=3D"$(npr=
oc)" \
> > > +	local test_dev_bs=3D$(_test_dev_min_io $TEST_DEV)
> >=20
> > Some of the test cases that calls _run_fio_rand_io  can not refer to $T=
EST_DEV
> > e.g., nvme/040. Instead of $TEST_DEV, the device should be extracted fr=
om the
> > --filename=3DX option in the arguments.
>=20
> Sure, I will fix all that, it will make it clearer its not always
> TEST_DEV.
>=20
> > I suggest to introduce a helper function
> > as follows (_min_io is the function I suggest to rename from _test_dev_=
min_io).
> >=20
> > # If --filename=3Dfile option exists in the given options and if the
> > # specified file is a block device or a character device, try to get it=
s
> > # minimum IO size. Otherwise return 4096 as the default minimum IO size=
.
> > _fio_opts_to_min_io() {
> >         local arg dev
> >         local -i min_io=3D4096
> >=20
> >         for arg in "$@"; do
> >                 [[ "$arg" =3D~ ^--filename=3D ]] || continue
> >                 dev=3D"${arg##*=3D}"
> >                 if [[ -b "$dev" || -c "$dev" ]] &&
> >                            ! min_io=3D$(_min_io "$dev"); then
> >                         echo "Failed to get min_io from fio opts" >> "$=
FULL"
> >                         return 1
> >                 fi
> >                 # Keep 4K minimum IO size for historical consistency
> >                 ((min_io < 4096)) && min_io=3D4096
>=20
> But here the file may be a regular file, and if you use 4k as the
> default on a 16k XFS filesystem it won't work.

I guessed that the 16k XFS filesystem will allow 4k writes to regular files
(In case this is wrong, correct me). Do you mean that 16k writes will be mo=
re
appropriate blktests condition on 16k XFS filesystem? If this is the case, =
I
agree with it.

> This can be simplified
> because using statx block size would be then be the correct thing to do
> for a file. Then, it so turns out the the min-io can be obtained by
> the same statx call to a block device as well.

Ah, now I see why you used the "stat --printf=3D%o" command.

I find that _xfs_run_fio_verify_io() and zbd/009,010 call _run_fio_verify_i=
o()
with the --directory fio option. To cover this case, _fio_opts_to_min_io() =
above
will need change to cover both --filename and --directory options. When the
--directory option is specified, we need to get the min_io size from the
directory. Assuming that the "stat --printf=3D%o" command works for directo=
ries, I
agree that this statx call approach will be simpler.=
