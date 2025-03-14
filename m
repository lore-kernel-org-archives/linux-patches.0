Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA7141547E2
	for <patches@lists.linux.dev>; Fri, 14 Mar 2025 20:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741985175; cv=fail; b=FsGW4d93nELomSQK3K3KvL6dbTSfz6THkuwwv6qEoPr+h54K6JqtdxNsCkp2/b6ZtcT2R9tsflEimtYE0oVJRsNFY3MYnegGeO8D2r+gpp722IxEuRI6XoeghQzLPMzpGL8cqvlI61R1Ye3K+mUoe0U8bnVIu36oCoAYQLwpiTo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741985175; c=relaxed/simple;
	bh=L90cNBddtkbtaRvZg2DrA+LZYm381qmjc/IowPfeCPk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=FKOB3zDJwxExmicqAeNISngCuU9GIYBlJ1YgT5AZVc2W+cT1DDEourOCPuX7cPOfYMAoXMPIRGzWLnF9C1WuK+KrBoBx3pwWykDgLwuOdXKh4F/gzIg4A8PFxM7F8AZKRdX8GbaQqiCk39sXnjyMgZgJjGB674X98wHdw/yGlzA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Dl+UU/nR; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Dl+UU/nR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741985174; x=1773521174;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=L90cNBddtkbtaRvZg2DrA+LZYm381qmjc/IowPfeCPk=;
  b=Dl+UU/nRNvVKJ9p6BCkum3hNiH++Hvyo4yZxe2e+4vVejsOrZNqIyLXG
   dJCWxun2FtkJhnvD0MsOqpbMZV2pkXkHrmaJfQ+PNHNSfBV140dIZC4Q7
   5CRixRb1WfpJYrYPf7xW8GokxQSUJu4lBAXttqzrh+uhlQpZ4S0EvEj3N
   dLkPe2KSJED1Mzq4z7HofM5id+SGHGP1Z4hKxnSxm+BB4omIDaqnuLhsx
   nFH4M/VRkYFcLztpTI7s5aZP63EfSdu7ckCF2Y8fHM3Dgn7SM3vlBYLv9
   vBB5bqQERcDuj1v6krt6ohbiriGwpI5jm1Pu83TSR3YvxQzCsx3dEPkRN
   A==;
X-CSE-ConnectionGUID: Lpx0yJzuTGaI5WGRjQMFQA==
X-CSE-MsgGUID: neDEsmd6TZudjAJyMc4+Ww==
X-IronPort-AV: E=McAfee;i="6700,10204,11373"; a="43058335"
X-IronPort-AV: E=Sophos;i="6.14,246,1736841600"; 
   d="scan'208";a="43058335"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2025 13:46:13 -0700
X-CSE-ConnectionGUID: KDLljRHBQECDw5Lzu+9LJw==
X-CSE-MsgGUID: Z30QU6sZSqapd1uQ1PIG9Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,246,1736841600"; 
   d="scan'208";a="121336520"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2025 13:46:13 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 14 Mar 2025 13:46:12 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 14 Mar 2025 13:46:12 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 14 Mar 2025 13:46:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AVthsXAwu/m4jXxOrC0vvqV4qWKFQSM5ACW6pvPrDJreKGqA8syKEcBxl3J6I5TH5IUNTmUfKmGK1ljhfZeIPe4BIiQvKAO5PRufyLoeuZWz/pTJ5fGJisqYVVQ7N1nR+yl/lAE9VqialCujFumsDifp21q2zeS7Bs4dJxls7GhcSND9QC6XnyLdwxvPZPlV7dHvOjPXOAi6faSTetGsMNF9bnuaBnorAL/3E1G3NtaFs1X6X62mE3oVtoyD1h93GpOMjtlr3Fgk4ydOxqVhLhFvqYS2f/xMdPZz7M1Ml/OwXI74yW540heWylN5KikZa8ZIgLzQzEMQt8m+gjVnbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L90cNBddtkbtaRvZg2DrA+LZYm381qmjc/IowPfeCPk=;
 b=o1GX3XyDd/7bmxEbyIQN1ZpjMutGpnWoDN6g36ffuwVyi1eZKb0DiV+MEjvBQ7GgisS0gHtfdCjwpm7Z/v8WxPuueauCRkfh+nun3ZjiSpdPBhGHDt43RSRtNQA18Culd4ydCEq7tkQwaXFL2plmpKrZ8r85dTdjkb7sZH0e+FCUk+iXsSARt3eKj2anvNvU3d4MNbs2KYKWaK8BeqNqyzXt2oMANGS2GWWkRfXglzy+lBrBYPGsGbH6UWeH5pTO/E9sCqsaRyDeg5/eHfEK2PPAQ19HlEV1rhiliNLc4YCLga4auXnjZCSAh3IkjDGgOZi1sz8KJaHzGJpMzzRrrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by BL4PR11MB8870.namprd11.prod.outlook.com (2603:10b6:208:5a8::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.28; Fri, 14 Mar
 2025 20:45:55 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%7]) with mapi id 15.20.8511.026; Fri, 14 Mar 2025
 20:45:55 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [PATCH] x86/resctrl: Refactor to make adding extra MBM events
 easy
Thread-Topic: [PATCH] x86/resctrl: Refactor to make adding extra MBM events
 easy
Thread-Index: AQHblR9YzkduEHome0Ccmy05PyfvTLNzGUDA
Date: Fri, 14 Mar 2025 20:45:55 +0000
Message-ID: <SJ1PR11MB60835DB5419267BCD736E183FCD22@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20250314202609.5753-1-tony.luck@intel.com>
In-Reply-To: <20250314202609.5753-1-tony.luck@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|BL4PR11MB8870:EE_
x-ms-office365-filtering-correlation-id: 2a629e54-7a71-446b-c15d-08dd63393799
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018|921020;
x-microsoft-antispam-message-info: =?us-ascii?Q?Nxpdwb2kApW/Krckwir7J3DFmsPjGTK0AoL2OfyTqEZvVpA6ox+yS3A9fQyW?=
 =?us-ascii?Q?gm0mbfejzqgo/0u0YoZSnRJTHZ46c/VJIBoyvjhieMLCVscNjbemwRg+FAd+?=
 =?us-ascii?Q?INbnZ8vFuiY+YpGX2dHpfxFpYl0W+6zZAd+UaZWf9FzygIoY/WmX6rGpWuoM?=
 =?us-ascii?Q?FqoRSM7c0wDU25KG59RMIsnGRIKTRGFBSr4jWwNLoTxnWmP0No1kigwprr3Q?=
 =?us-ascii?Q?JgRbFwEij6R5KMYDcdfCRDr5XdxASwUb36NyHsgnm5oZk7sSGbZ3oR+0fy8J?=
 =?us-ascii?Q?joiM1enYMwFVVnkhgWIVSSN6I28mSsHN8/JSnPC3fJxapBi/Ju2dqpcJeW+Q?=
 =?us-ascii?Q?jrfyAxGj5/yQVjuZnhwsJseEBJRgC3aLzIkmfJnoJhMMZRQVK3mIb4C3+84i?=
 =?us-ascii?Q?64J/NMJ5xUHiiS8r9JA5wv/DyGYG/hKz8uuhI9tGf5+71AMQ4KJgJeh/NqzI?=
 =?us-ascii?Q?xZ6cnjp5sQ+aRCKCM/Dx1t7wlNyElKYfFVVqdw9ZZEVhUZcOeHg5hwHKwP0F?=
 =?us-ascii?Q?SSElT0WsvHrBQAZrF9+E+W77E5LCA4oDKmiqb5eg5sI2NBSHQvfHYXiN30MQ?=
 =?us-ascii?Q?Jw3WSKSj2mQwufpBUD/igkJandbyHh4xRBh9Xy3Gv639mvoA18riVORENIBW?=
 =?us-ascii?Q?BLikAVza7bbpy5cpsfQjH2FASr7WUwhFDGF1YcCjgK4w2kJCFB9Yu84t6E7m?=
 =?us-ascii?Q?sH5Ih+9mJ19EtMSvcS3/MRecpcNinXZ0N07peX6+T4Kj1GgXcMU87tjFgP1Y?=
 =?us-ascii?Q?kr1DsFguVU2zDE30NpX7HA9W4DaL0jR8+as3tX3QmoA/GVK0fxx/eB3pnRFY?=
 =?us-ascii?Q?6xPLCuzyAZxYDWBEnhAyTq7AWIo3hKdzlSiif7GTIElSpFn8yyxNxskKJZnC?=
 =?us-ascii?Q?dXK0pSNajmg/lsoTuChH4g4dJy1FDJBLBJzRaiTqd2DxpRAEgGTLZfHLz9y8?=
 =?us-ascii?Q?7xpNXH+eB9fi1fQ4nYPTSZ1qtLJOj2EO3ydk9frwgvAL9VPtduCDFa2aJgzu?=
 =?us-ascii?Q?9jjowDyRrgypWewXUu1atdBS/GytaKC+COTGGZIecWQ0CFdZfMl1I8VOjX76?=
 =?us-ascii?Q?vwYMc/8lpaPYDWQ3p6Q5KUEVObZvB4XXY0CHOekYC7OR82/S8aDlVaGocFPS?=
 =?us-ascii?Q?M9k6wVq0yJr2pNbaVAXEGZ0YNW/S5J4SKWfmlG+5njjMamIGhNuXdKgMlyBi?=
 =?us-ascii?Q?wm2erUYfW2kH96Ed1sghzeM+tHRNu6K782Kat27Rv02Tuv3JLX7Dbsd9bt4S?=
 =?us-ascii?Q?JzVBZyKzT1M5BKtphSZbV4HW4/6QnYOSsSvzTvN58n3Sp4j6xLXpGvAZVj6C?=
 =?us-ascii?Q?TDFa/Ss7ra1PTDmoaw4LZTwQHu6EFKCGjy00XrfKZGJFp/cjdNL48lbj0svx?=
 =?us-ascii?Q?XOobiRqa+yuQ25/UiyfCxDIss9nvs9W02Dv0FSW0Md2G34LrkNUFMqiCreS7?=
 =?us-ascii?Q?d5ZqNfioEifdnReg6HhlBXhaRIFO6eBg9a6x20i8R1J/vDFiySfiPA=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?SeNIr5jM4HNygfIIA9SlBcfJrHzn0uf7K87eBhdfKFe+0cK3rLJozI3k53b1?=
 =?us-ascii?Q?N2ImTqkMmwFdWtuB7d5Ba1fmyzx5xD3rTnw/1sbPZyZcDLBMdh4FaucDnVAm?=
 =?us-ascii?Q?MAVeKBCUAacBE8NsSmeSpyKez/1JyiLX3wdc/VyQgtiKBXtInlU9J/iAIL1I?=
 =?us-ascii?Q?KyK4KgBYAm9HahTRh4wmY2GiDdFdMYc/RNgVHxvL3KdZk+vyZesEIEJO7Zhb?=
 =?us-ascii?Q?kIeith0j/73QByzuis7TiaQpXSSk9nws0IoKgAPmxiGeORdOqTCTxbn6z1LM?=
 =?us-ascii?Q?X8GgXCQfvfnHk6fP+HuU6MXqFf/NQ3qce5zVoERsI+ES65v/8zUPvGIudKvO?=
 =?us-ascii?Q?4H51jzvzobhHgvE0tKJkeI1eIrh8t0t3bOU4G6iv5LSKzDCftoIE9lKhWl3u?=
 =?us-ascii?Q?kGjuQQ2HuEjyUa+yX67eIacYMTgyPFFPNxQ46KH1iWvPzi7tnQZbIubjO27i?=
 =?us-ascii?Q?qNuUgEWT0AUn6c2UddlwPC+axOG7cBqaKaWyqckWWCjvJ7AmO4YNuDv7apkJ?=
 =?us-ascii?Q?8ZV0Hn4TLjskf/D8TqT2nFX6sF71hyA/0maaVhFiri94d4XSUE3T2+gJN7iZ?=
 =?us-ascii?Q?ZZui0WsVJ+i4j60OCaKbpJHDShTn97MLIs1C3MO9sQx5GfVFj0FzwFEMVasV?=
 =?us-ascii?Q?kRyK3DXlLN6mDvlUm1VQZWjzTEti2EcjDWrEo8WeGUgjCU8J7irifXBfrXfs?=
 =?us-ascii?Q?i0xTOs2gEr2Cc2RGrI93rMkwMTTn54IxIKb9+i+pGgOPP/VrIF4a66Mm6qVy?=
 =?us-ascii?Q?UXfmX+wrKau9rC+LOLHFjk2GKlIMboizei0790pOL5y0Cb0yGb/XMLlEI9d9?=
 =?us-ascii?Q?UegZ5fFBsUPEnZGWrSt8ZNKAvtLJ+izDhmCSXXyDbWqUJ9ZGVBWCRNAG5sPs?=
 =?us-ascii?Q?ZezBj74ikGK7f452Mrrr4hCDJmLfdTjtrZ7zpzutpfGM4tTiVOxf8YeF4Lqx?=
 =?us-ascii?Q?TWIOjz9F53+086ij3bwV8EDbO2kqjvPeFGNat8UC6+WbpoWhndlgZ7hPyXyN?=
 =?us-ascii?Q?pziraNXbQbv5ioStdP6j31KsqGtpDAgsVmv2j6kkoGsTFgUaiSv1Uq8IKIt2?=
 =?us-ascii?Q?PT+UtDSPsV+HKMu4Mjf6AwQNxKdSzfm+SA17SCAgs52ElrXwRjeDs2ysBQYs?=
 =?us-ascii?Q?xMXGxHjpWjQxJTj80ZxPtW+KgUFsdA7VDXFJB38JMTax/8ly+cMImtIMnEa9?=
 =?us-ascii?Q?w30aZqfwsuoej6DMpCNGJHFuVrVPSasVncYcfsLwTwpzyXYAUgmckyBf8HPj?=
 =?us-ascii?Q?oJGglkEyxMea13+Vcn2TgXh1sFHaevObjuK5nxQHp6Oobz/cYOhauWqukN0f?=
 =?us-ascii?Q?U+//UUYKH8Pij5uBgf6Rn2PtqMJoVXEouTcooIsci/LNqMwXu+tTpu1E5LU6?=
 =?us-ascii?Q?efcB8STSSX8s8m0DsuxpFBmOUCaNu5NJlfI4QmL3j56UI+gRCzradlKU1ej/?=
 =?us-ascii?Q?we/1hFlA28H35gH/vw8dpIVPAGGzCa/N/c13cawBmLKY1cCQBN5C2/hd2UXa?=
 =?us-ascii?Q?jBs/oIWw+xGDqDFs/ruxQS8N5c3GBjW9l2YEFxRQ4IJBn2dEzsBqg86ipBog?=
 =?us-ascii?Q?pbRHXs3KMW8Nb26+bF3UfF4y1QFQvt7H4TJ6h2qa?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a629e54-7a71-446b-c15d-08dd63393799
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Mar 2025 20:45:55.3435
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BvFCSRxm2KhRjiBis0f2Vl2ubnJXkIOM6EgIiV+H3Z+NoRIjVkpFA35BP4i+C77+PEadyVaT5DrYQGzU4DCLdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR11MB8870
X-OriginatorOrg: intel.com

> I wrote this to play with some experimental MBM-like events
> that may or may not ever see the light of day. I'm amused that
> this refactor reduced the number of lines of code by enough
> that the patch to support the new events basically just got
> back to parity with current code size.
>
> While the resulting code looks cleaner that the original, I'm
> not sure there is much motivation to apply this change at the
> moment. Just posting for casual reading and to archive it in
> case I do need it someday.
>
> Based on TIP x86/cache.

N.B. I must have messed up while porting from v6.14-rc6
to TIP x86/cache because my system just hung while
running resctrl tests :-(

-Tony
