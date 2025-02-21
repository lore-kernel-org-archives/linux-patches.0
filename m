Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8698F204599
	for <patches@lists.linux.dev>; Fri, 21 Feb 2025 09:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740131744; cv=fail; b=OYhXjqGG1Bfmi9/uZ8YdjXT7TfC9oP4rsTxcCfv4PagnAlLNKR/Tnua8/3yQl9OjEZS7tA+YT/FaeKXLsRFZ+kRrC2nvp+C2MlsEuusEFWBEV31R8PGOIugFJTTAFbcXwf/++WJNNaHY9svlZ4Fwhcc5soN1FS/c6J5r7cMJSoM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740131744; c=relaxed/simple;
	bh=Fhp2aAikMfrcrd30GRdxnKwbDfk63pXbld9VyMc9bxI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CNmqHEfayDcfGkImgp2DjPQHpETW4nnnj/wSGay0GRa0/DfvCWK04tHdPboj5opbptzAWcJwBVqwx0kPeSl6XI2Z00Ek6xHboW+CasZhoeEfd809vvKVMKL/EjI+FH9Ty0jcpaFF/pFfm3JW5lnP9yW7C3Rm90ZtD/3xQ0jay3w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=gZ2xDOps; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=ETNeytYY; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="gZ2xDOps";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="ETNeytYY"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1740131741; x=1771667741;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Fhp2aAikMfrcrd30GRdxnKwbDfk63pXbld9VyMc9bxI=;
  b=gZ2xDOpslYNmM6z2/Eev2rpBZZFSbgyO6QVT/o6MNmscRbNkTdb/aADf
   wDL+DpzOVQkVgkr8cKiauGN+K/ZtrqiZaBeVnaKTQpDBfOC+asi0c29re
   SNRPrG3B5CqTbxdCOieY7V6/MmO38OCuKZkCqZFAMhtoqmY/0FhzBRcyi
   fIbmr+UvGxjhQmJtUXiG9PeqWtCjfWwHKGY+fFssdUMBQMY7nzKw40qR8
   2FPsbnlHRymo/5IOC/5F7VC/tTOwCDPIqrZk/QW7G8TLqtHpCNPF09IXu
   LhcwRnFDZpmx2+FKbeM5YeDaowIlbKUtjkMgBd2fX53OVxBd9sGwRAc6L
   Q==;
X-CSE-ConnectionGUID: lEz6oRpSRViSAn/ImY1ejw==
X-CSE-MsgGUID: 6F+yI7mDRXSboNp853DbVg==
X-IronPort-AV: E=Sophos;i="6.13,304,1732550400"; 
   d="scan'208";a="40357048"
Received: from mail-dm6nam12lp2170.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.170])
  by ob1.hgst.iphmx.com with ESMTP; 21 Feb 2025 17:55:34 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ge+dt1xv6leVxhu0cgLf/hpPQG/uEHR1PQ4lDyffJWFrar9g6D1lGa+GED2g5rPqGE2y+7WHwtCAmRKZYFD44uRGIY53TBT3FdtGzpx7frrg6WbxBKoJIv1eGgH/kmpjZ4IZXvvba5XDyoI0mNmjsIbPQATka6b4Fw5Jrx2q0U14KOzHJn7GWGiSzwrhn/c+v9t6heGVA6XV33MNZpzaUWwvqKsEuNTIFh3bAEolPJNzP4hTo6/7ijDJ3aE6ytn1c+pNs9iHnJjGQ6lJYHNvQka4O6ABdHuWzJfz3kS0FN3rFE6IFfQoFpUGB4IcrwhKjWvxGTXhgCbR3gXpKr/JuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6XV7HH8DSN7+jngi7QI/b4V8f3gfxvVuBt1A45sIqCs=;
 b=RSPH8RCMPGA2wSnA4Xg8QVmJ/5tZOiCr0yl/ZzhZSL9Sl7ya53OzVudesGsnusMZEs68cIqq43xyjO42LAFGJf+OXp48EhCvUxc7QM0gV0yY652+k25qKoPrq8auCYuNoPfmRbgY+z3+NM/F1XydMSl5vsSW3WwwS+SkmupEaG1svmEeTnnC+pY4apPQ/g1KJCfGIff/6f9ACNrODkwXmmuuelOMcLkjAzSMY8Z0k/MldWe7etVSR8ZzVRdNIrV300JfDBVZequ9632EwaLWdbjXxTGi0Hqr5v2E3ssipGE4yRvg+fXqSSaQJt4BZpE1xbeivtoDrSex/Jdn/EfoRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6XV7HH8DSN7+jngi7QI/b4V8f3gfxvVuBt1A45sIqCs=;
 b=ETNeytYYI6pHbb6WGaA3faNSDy4n7B0tmCV/azIZcqXVlVAUcgnu8OSKlvNJqByTPxE48oPol8FvcTB83JTv3vtz+Y9BxQ7hZK1Mu9f7DjLGIwMTk2OpDlL1uXKojfLy4eDvfXZLc5RkVqVpVEKhNc1+sSMqlrL7g9f4LGWwS/o=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 CO1PR04MB8236.namprd04.prod.outlook.com (2603:10b6:303:163::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.17; Fri, 21 Feb
 2025 09:55:31 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a%7]) with mapi id 15.20.8466.016; Fri, 21 Feb 2025
 09:55:31 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Luis Chamberlain <mcgrof@kernel.org>
CC: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"hare@suse.de" <hare@suse.de>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>, "gost.dev@samsung.com" <gost.dev@samsung.com>
Subject: Re: [PATCH blktests v3 0/6] enable bs > ps device testing
Thread-Topic: [PATCH blktests v3 0/6] enable bs > ps device testing
Thread-Index: AQHbfZBg9oNACjqY9keVnQxp0RlPu7NGrZQAgAB68YCACmnVAA==
Date: Fri, 21 Feb 2025 09:55:31 +0000
Message-ID: <6evkl6y5emuyjrpq75lwksbp2qliwodbpc6xx4bnuwj4kiij4c@roqxx5q2y357>
References: <20250212205448.2107005-1-mcgrof@kernel.org>
 <shkzvixvm26ojvvergul7orla45jsmgw5fcozm7en55sh7zen5@63udt7eqtvf5>
 <Z6-RTxfPGWrAsNvC@bombadil.infradead.org>
In-Reply-To: <Z6-RTxfPGWrAsNvC@bombadil.infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|CO1PR04MB8236:EE_
x-ms-office365-filtering-correlation-id: 75d30326-e8f0-45c8-2c26-08dd525de0a8
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|366016|7053199007|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?vwllNVFGZpg7eL9FXlWkS2xlL3RjDO8NogjenxFJ49zL4Bh3+lqmAy4tTgc1?=
 =?us-ascii?Q?hkimXqHnLddTAeiLc5U8PyCy171TV1gRDVH5ED95I1z1ZfwiCwfXUAwZFF0v?=
 =?us-ascii?Q?04rLQBsNv6EvhkCFvX8JSDNIc6sWp9L9Q2fiEXlJ/S/CRLU0oNBDycfeO4LG?=
 =?us-ascii?Q?QPEOQ9QHvDW0bTpOqzQvba3VjA8n9PV7H8OYqhz2eYHBce1UJ3tGNksGz9sJ?=
 =?us-ascii?Q?tMdWZp6KrWi0dpGZcWGbuodyczKcfc6Nu5XiC3422VNFqopppwdEaSOXjnZP?=
 =?us-ascii?Q?1j1NJauPVJVwYt1RlYwUzq5XosOoRElpda2RMvKCFqehRROqkVQ+2myMKaZz?=
 =?us-ascii?Q?6ZCoGIDwamS6KbstNkVTyt/uccHsJfXNkdDbCrgjVnWYgJ0XcfblRNRtNHsI?=
 =?us-ascii?Q?oaVBZzuej2XL0TGLM4SXMKWYM70e2Uk1WyVTENpKxmz9I2jys3gJV1jbr1oa?=
 =?us-ascii?Q?YFgkI1ecds3f2u9oRWWyYUm8MgBn1dvW+ajvq8DcFCiOZ9fz9jGGf1E+8lRf?=
 =?us-ascii?Q?XoBcXL6MoBJqC25a3d/44FpUIl1vus0BSzC9lRqXFp5qphjL7aXJmYdsO24F?=
 =?us-ascii?Q?32iHA1yIcRiaE4QyQIfUHSep3cOVlRZtEiXXkL8hIZwfs7s+tkdkM3SlfpfO?=
 =?us-ascii?Q?Vz56ajC1ksHd9piYgaukyif9dIHwovlKrbj3Y3kK65bc3th/RnU1AYZ+iIg9?=
 =?us-ascii?Q?S/wDbb4BQHBa1N5OEZENCTaqEc8oN2jiUMu7ABJxuslNvI61moQJoCST11/x?=
 =?us-ascii?Q?QJIneRPGheJ9O4mdkJ6TvyfoLUDG2oPKFyV9KPUzzqAgXLZW2B7HtDc3Dg1z?=
 =?us-ascii?Q?KJ/RNUEbPFVCCG98l/BlZDKoeW6u57vOWNEJpDN1nssKzHdbGUwQTlEc9GiE?=
 =?us-ascii?Q?S109M79x/fvHcUyPLrWRXAnFI3uMJf+msKY3u5sLmq17apvQB4UC0myteBFa?=
 =?us-ascii?Q?pO33ZJyg2jdqEYAM18uNj0aUkPJr0R9PyYH9It/ynz/2Hj6WV0AALy5ZUY6T?=
 =?us-ascii?Q?yzjXCWOcpsOICFNqYMPwbljRq+lT8nD7H9hCQeQF1C9XNBRHASk4hD0lSOWJ?=
 =?us-ascii?Q?L06VRSsEqjrvxn4W2snkSMfj00j9iF0XfQifewTsXE/Y4TD2Vad3tCZd9jNl?=
 =?us-ascii?Q?r0+GHlL4yl6nu2vBrJrRKs2TxXQdzPxKYkdzS+chph/a9B8Tg9SuYnMq6FkM?=
 =?us-ascii?Q?bwxC40IJxP5BZUxLtPInZuTP19ZvhLCip9jpklCD7URYlDYO1P2sA0IcctlA?=
 =?us-ascii?Q?w1DH3wV45oY2O6CqZtTIcgdFA3nUr27hCjxwDArnNhR45S/MRxqOMjONM4et?=
 =?us-ascii?Q?5hpQ+50WtGsvbBFmRK50/JY8L5mB37uSG70jGDnUFsdYBeCdSYHhMA2+ae8m?=
 =?us-ascii?Q?kMaZ9h6Jh7MbG7HXkGMFFbPfNKDYYju2vKyks9pTd1mxfMbzOmEQYhDyn3Ie?=
 =?us-ascii?Q?pLOxXdTX+zlfI6jTV94kBILxMLpzL8uh?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?AXAD5D+xx+98pcb4NrnDU+GsIfkdJYeSPavY5X3xCygVKJ5q6xwuYrGLwzKJ?=
 =?us-ascii?Q?oOse0v+bvv99zrvCvKtGsdflJsJnIVjuq4PjXkwaMy5WLRmQOoJnFq2Xhrjv?=
 =?us-ascii?Q?ht3o6V6x4gq/Ae0T/pe4DhI1T1a6f9JHDLWHE8hrV+twm7t4IUROfyuGhIgb?=
 =?us-ascii?Q?h7c5uqw7lPtF+60txmB+7Z9W0BlPDxO4bA2DPGyOV4rQdP3GSo8bnaZYwJp9?=
 =?us-ascii?Q?KIu3c8G6fVb620r071L3AA0PQkBKPUp3QU9CPDL82U2kE8f4wTcOXhyDdpZG?=
 =?us-ascii?Q?SC6e6OicWcKLlIG/jZlR8357kSxsIx7hlDUYS9sauBcszlwxZyLYnWOuQn1L?=
 =?us-ascii?Q?wR9soOj5bCwFGb8EQaSSnzU+idGc5pl/m5kHVjpK7/UGFP1+7TpoOjJ0Pw/x?=
 =?us-ascii?Q?pJcOnvHyOoyPkXSlkDNhftK+ZE9Zj0I0zJ3cv5L+5ETgI5dYdxlZJsQ1EBPq?=
 =?us-ascii?Q?jI0ATHCuA/B80szRFgyr519t5UP/AI3LTJKABhgVCpj2cSurvqnfUQ43Te1c?=
 =?us-ascii?Q?fTGcJ4FMjN3kwJYu0vg/GYoEWg8FV3GDpRlIQPIQOwPbCknKGCQqI7f1MzAm?=
 =?us-ascii?Q?wxUUNGGsyG89xF/t26mSsziZEDyi37uPeBzmyUIeRj0wp7H1/AzWbYSBJUMz?=
 =?us-ascii?Q?MRRUdlhMTaRXfvEhfs5hXgp134YRrYKmnY10vAeoE1UPKN9FI3J+bdh5wR7N?=
 =?us-ascii?Q?BidpB5AqKuk3CgyTjZAWXhAyUGmz1AFGTaLxf9A/mTJboKYy8x6SysJfH7zn?=
 =?us-ascii?Q?TDNoBVnwLKZJeSJARdbfXfmKvWIVP05PvvgS/Ej1s4EUFvaGk24HjFK2E49l?=
 =?us-ascii?Q?IdgKxZFAOwgTBb7a6VimI5OTex8zkALaXqRiImnbBQ3oojN2MsSD32/ARbwV?=
 =?us-ascii?Q?aMBY9gHr3ANfKJBOmhQgx9yTPbPXK/ipVchSFP6UfRBtPrlcPpviedP5A5Q1?=
 =?us-ascii?Q?shKmNwYcUtc4zRp0zHVFLuOwmNtYK3EYBKoudB5SZb7XyZp+2vR3UXpqjmOC?=
 =?us-ascii?Q?azNoTq15/StpEpFgVam/HKzFOIJW7gU/NICOy+z++vKOLbHDNbAzhOp8lZ2h?=
 =?us-ascii?Q?Fiux6gmInbo6DozSKNHH5OlLdN01T5FSPryUXF5K9n2xtsNol4ndV0tzPfJR?=
 =?us-ascii?Q?jUlwty6D4OHVuJskR0UiWjM+Spt96CigpyzjyVn+eRWMriQGa3UlpLxm7qqi?=
 =?us-ascii?Q?Pfg6XS3+lpG7pN6s26d+YH2HW68WJnVzjTqE5clJt/O08nErCgsscN7z410T?=
 =?us-ascii?Q?pQkBVy/EcLCRYpS/8xWiBKvEAlHSixkvW7yvRoBDeB8nolsZvIM3lHhG9N/5?=
 =?us-ascii?Q?ARR4aCrKHraM/7zObhB271XU3SoYgZVX1Fec2ooI0usIr41Hz1Y7L8bmSSPO?=
 =?us-ascii?Q?LQ/JGphPnM4qgAfZwNpLk5KcaDlswrkvocUY2s0GpqOLZJqbcYDfZqlz/rOA?=
 =?us-ascii?Q?dY/LnyA3nhw2fhJ2jSzQRn0ViI9QKRAiOjvx5R9Vi4MbmgF/IA3W98a/yPBv?=
 =?us-ascii?Q?bSZGOkt1G8559OaNJGheW2excek9qT8nFzBls7lHNjF1UnTebqPyK2TyPFoZ?=
 =?us-ascii?Q?P8nZYRXWqr+WZCK97E1WZAhqJ9wF+a1errIDk08eW0NVzrKEZhBJCYw7cILH?=
 =?us-ascii?Q?aSARfjWonNA1bQ57JB5MIjk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <39E9402C449DF046BA0F4FE0F6D6ED8E@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6/owB0xWXokEBT6SAn6DfUHwOj7zTfX9PltwJRms9UXVy3FU9lN5CX2U2N4hf22lA19wvPXQ7JFeAH56ncd7d2OsXTLPzNjLvJspkxgn9ukWsrdZs5qULsDs5tpBQr46dwgjnx65HytzE3j47vM2N4x4eVYCVX8S0y0rNnbMbyEhh6Ln6xPNoAMwZmIQZITO8cPQYVLm8gnizjzWgip0v9nxSlEvVWJczeMmyXqhi8WNAzAv27aRukTdqWgTNikmbVFq4PvdHhpVVgqqVbmsKc0NmWN2UXlluY7kkZcPZpG1xJV0pZky/gkh1YOeq0MBd2C/hzsU/gJEQ9jUifMwfPF+foDPuTLZiEvggQuosNEV0IHPHmBawy4Gl364D6KhrcqdXh0tfjy6hqXdKhwxGDQHGv8irAf4umtuhR5rciyNlx4FDbmt2rHs8jW+ilVYnkQEyw6AYjtoqQZEsLEyM7BcDaV8qx93pDuODPlcnOp5gcBkrXxq4Mj8UcLgOg6aXqFj0hPLPHoiVfSWo0fLsxr+viLvuN32R8vDhaKatvawpOykzUFEcOZKJGhb07srmDizCtTWzyXFih9mbQ9Oh7MOTL7+1VBsn64zLlomoOIdGeWpg4w48B9QnLq89USY
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75d30326-e8f0-45c8-2c26-08dd525de0a8
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Feb 2025 09:55:31.0865
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nYeYYkJhv34CArPUJynb8vAeNfj9oXYPXbeUQKTyw26HPMjJnEggyHEtI9CHD+pi5d/zMkw8qCi/mGRtBHTPR/QRW+aaZuK9NNVBc3YHL1w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR04MB8236

On Feb 14, 2025 / 10:54, Luis Chamberlain wrote:
> On Fri, Feb 14, 2025 at 11:34:07AM +0000, Shinichiro Kawasaki wrote:
> > On Feb 12, 2025 / 12:54, Luis Chamberlain wrote:
> > > This v3 series addresses the feedback from the v2 series [0] and
> > > makes some minor new changes, the change are:
> > >=20
> > >   - Fixes all shellcheck complaints
> > >   - Addresses spacing / tabs fixes
> > >   - Adds _test_dev_suits_xfs() as suggested by Shinichiro and makes
> > >     tests which require this depend on it
> > >   - Clamps _min_io() to 4k as well for backward compatibility
> > >   - Few minor enhancements to help capture up error messages from
> > >     mkfs from block/032
> > >=20
> > > This goes tested against a 64k sector size NVMe drive, and also
> > > using ./check so regular loopback devices are used. This helps
> > > test 64k sector devices, patches for which have been posted [1].
> > >                                                                      =
                                                                           =
                                             =20
> > > [0] https://lkml.kernel.org/r/20250204225729.422949-1-mcgrof@kernel.o=
rg
> > > [1] https://lkml.kernel.org/r/20250204231209.429356-1-mcgrof@kernel.o=
rg
> >=20
> > Luis, thank you very much for the improvements. I made comments on some=
 of
> > the patches. FYI, I reflected my comments on your patches, and pushed t=
hem to a
> > github repo branch [2]. Please take a look in them and see if my commen=
ts make
> > sense or not.
> >=20
> > [2] https://github.com/kawasaki/blktests/commits/bs_ps/
>=20
> Looks good, thanks for doing this, passes all my tests too, please feel
> free to merge :)

Thanks for the confirmation.
FYI, I applied the series with the modifications.=
