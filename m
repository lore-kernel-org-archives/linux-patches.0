Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BB672EA168
	for <patches@lists.linux.dev>; Fri, 21 Nov 2025 17:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763746844; cv=fail; b=ir/kdgcP/KJVLbQdovnKWuQrslFNOdvp1Wnfpj1b4PPdDiNZBE5bkavGc4EW9CpP/+oi8rGek18hdhFQMItzxlSAjW/fVHUf8/jkbeFqOQlezpzrjHcEP0E/TGcKR7lGuAnrPJm0X1dTO2FNVzT+9VANLg7+tTbs9U0/pdmdw1w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763746844; c=relaxed/simple;
	bh=rBqAzQmFHsoVMIvOCQPkOO9GHr20cTwzT5xt6Drxa1A=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ktxC1cyht6dmXYmEhKU/IKhsDzpglOqIyScBBri6eMK9mk2K0ML37WvVNzv2vrdx/c1e38VqjdLECqyK0EEi/BhzHeHCRcfMyR+kXabSDilyscz8UiP3lBzGUmW12qyIL1vSDIzjsfBtTNdZMiRdSPlS8s1ne6sAOjiFhH4BrW0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=i5SG5+l0; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i5SG5+l0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763746843; x=1795282843;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rBqAzQmFHsoVMIvOCQPkOO9GHr20cTwzT5xt6Drxa1A=;
  b=i5SG5+l0SNqmjsvaGDjli1igkZr3iNOk3VKcfmArg+1gaH0P6QH1XgZN
   TGfSLOJ2m0ll2uKR+Vf1aBu8XnmmlH0LsoSRtYySPERhq4SIHSQ8zvRZt
   XdW4ItXV4N7+FvssPMDMSZISTAr3GkaBtiFQCct61PIArffPIVNuqZtbj
   x14S3B2Eq1CG9ncbE/Ay8lyz3iTavfSkuA+dhCj0dulQHz/7IdycYeYgo
   ZNAJ7PgcR1Lzw0MK8kzuFIVhxpCa22wJOR2F+QxzPKMTPO1JzLaWj1UPr
   Ynkl3R7Ff9Ca+ZWF2wKBRqLcd+l3h/XQKFOHZ/mmWYQDSxxqBOTUr6W0g
   w==;
X-CSE-ConnectionGUID: bi2TyANRSISfYcYgigtBBA==
X-CSE-MsgGUID: 1HVRPY2dTbmJR3x+j8MjoQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11620"; a="64850193"
X-IronPort-AV: E=Sophos;i="6.20,216,1758610800"; 
   d="scan'208";a="64850193"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2025 09:40:42 -0800
X-CSE-ConnectionGUID: Yv2zqlbjRWmU40++Z9TeBw==
X-CSE-MsgGUID: FglmC3bZSpmrT7Bjyp35Dw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,216,1758610800"; 
   d="scan'208";a="222701169"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2025 09:40:42 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 21 Nov 2025 09:40:41 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 21 Nov 2025 09:40:41 -0800
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.31) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 21 Nov 2025 09:40:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NNymcta32hnmsbUEwWFfCXMAq9XqS/ZTe7VEgmuHzMHfeXz02xfE72JpWOo9psRZMeT0cbi7h+aciHQMuMglFYm6HCzGzX3d9fS/OfdZM/Xl/kqHdwEheC+u0afOdjZPo6zjh2PrU2is/kNtrTfVHA9MT+gtstwHkZGIV9FXeFvC9xO/TSH353idQ1WJK0O65LDBViTKACuw5XoOJtfq0vO09XrPvgBSg0hrO99XuGBLLU6LtsSflaH29/+LlmWaz3f049eXMRQxt9UbaqNLBP7NJ37PEqJD+JqlGuoOmMskaENgqtnbl9nmoe9IliPJJxBaCFm11WgbuybCNem9Fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SG1KOz+c/hu7KRRMUeaxPlzeAfkQ+dK//VuPiSHuQJg=;
 b=jycv/lQpGjxerETwcveNGFhBgZeIwpwHuJTtdoX//U2CUlx9kBrzlWxTZB+wHxJqHTBFh8/WQR+3vJO15K734EJ+h0E5vIz8h1taOQsH7yrs19S7/bGSz+pm+AuHEDuw5pO72qu8HmlvMKCAU54RnZ15tHEBRn4iOU3mBMMVBHsmYXKW9Qado2pxMd6SN1FedeetVqm1NEbJau9am7EJlBt3Wk+rpJ9U9z7//NyJgy1p9PdItdj4lKtAEgFHYHAdvvRiXfU2PTOSoLHoCFfYYPH/Ic4CUsNsGYI0NR/vpQ0NeKD2HkwK+S8lduzVh0Nj/JfQas4sM8fwvCxs+douhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from IA1PR11MB7727.namprd11.prod.outlook.com (2603:10b6:208:3f1::17)
 by SN7PR11MB7465.namprd11.prod.outlook.com (2603:10b6:806:34e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Fri, 21 Nov
 2025 17:40:39 +0000
Received: from IA1PR11MB7727.namprd11.prod.outlook.com
 ([fe80::a99c:3219:bf01:5875]) by IA1PR11MB7727.namprd11.prod.outlook.com
 ([fe80::a99c:3219:bf01:5875%6]) with mapi id 15.20.9343.011; Fri, 21 Nov 2025
 17:40:39 +0000
From: "Nikolova, Tatyana E" <tatyana.e.nikolova@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>, Jacob Moroni
	<jmoroni@google.com>, Leon Romanovsky <leon@kernel.org>, Sasha Levin
	<sashal@kernel.org>
Subject: RE: [PATCH 6.6 251/529] RDMA/irdma: Update Kconfig
Thread-Topic: [PATCH 6.6 251/529] RDMA/irdma: Update Kconfig
Thread-Index: AQHcWu1OHCNEw1NUNEi7Y43Bjkm0yLT9ZULw
Date: Fri, 21 Nov 2025 17:40:39 +0000
Message-ID: <IA1PR11MB772718B36A3B27D2F07B0109CBD5A@IA1PR11MB7727.namprd11.prod.outlook.com>
References: <20251121130230.985163914@linuxfoundation.org>
 <20251121130239.948035019@linuxfoundation.org>
In-Reply-To: <20251121130239.948035019@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA1PR11MB7727:EE_|SN7PR11MB7465:EE_
x-ms-office365-filtering-correlation-id: f2c4a469-d525-4c1f-af26-08de29251606
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?gmwqEtMtHD0VG02Lj7tgSMMOso8nxdPsmWRNNN2XfGqq1M4htpOSWXuTvm3c?=
 =?us-ascii?Q?AI8ghGXum4bxmmBntxWXAr8zpnR/y9lvLLxMP+0G5apDlSYvWCux56sXdYf7?=
 =?us-ascii?Q?wCnchbeKikIVF91DDXVxcwh0yBJXzn9luYcUzQmZyaiYzcOYTDas106liX+7?=
 =?us-ascii?Q?mvXUyST/jbZ6qmSB6P3L1WgAOc1596pTk1NIqwgLOdeJ2nCOXjwAaUb2jxVY?=
 =?us-ascii?Q?mc50ucppXLDAv981Bs0XKC7LF+bk2JbzeeeY18VobhFuh6uEX0/neDDGQnQx?=
 =?us-ascii?Q?CrNoMSDRENlSN0SWLkfTpEfGvBgzj3dV90U7nhojsMrw18wUgrkCP2UDvtI+?=
 =?us-ascii?Q?46Mu1SWEtnKBYh2bYs4Lg6EpP0QncZWVi0hu6/AfOC0a17w6LtxJ7pXvSg6t?=
 =?us-ascii?Q?7h5rReDg7JHUDv5AkfYRSiy0y/GI1gpXETqBCDydbJUHbOFUshSl627C2Fh3?=
 =?us-ascii?Q?G63laRP9AMC1WoPoiN5DXzGzYVZbErtcfp8xF8iAs60V6lzPvw9hmNePFuL8?=
 =?us-ascii?Q?epCVDjvI4EoRbF5psAbLaYjH8dl464ZyuVEKMQHrnP+YH53AzHyfSblK+UVD?=
 =?us-ascii?Q?9Uhoadi0/wGZg6a8keb3hMaA+ln5d6fFa4+4Fq0Oha4p8E+AhO5MvJQ5EP3t?=
 =?us-ascii?Q?rdo/bgZd+AqnSngYOXLxIOhTM9leXMBLxD9sM6mQxAidTLhjYBN3jn57eOZh?=
 =?us-ascii?Q?Ra4j7/xc+mrK/ru0EaEUXT9Q9z6c3VRIMJ72t8ZgOk4PnJQdctC3JFH5as6O?=
 =?us-ascii?Q?RMr2yjJku27GKtr1PVeQ4fPrtF+LLZtXkSdEAM1Hk6EK13my5gjOR227djMZ?=
 =?us-ascii?Q?1UXbf6wM8Hm6F6491NrslScKorUDb1yuqzEZ2+F1uBD5XI6+oJtQ9wST2M1c?=
 =?us-ascii?Q?v3EdiH3xtRgK7WqYI7lK02J/Gs5KsAn7k5Ph62zu6+IupE0J5n6+fKIA3RWZ?=
 =?us-ascii?Q?uXfn0gCOBOC+f+W1WhP1u5DrxCto4qQihR8MZtwvA0j4rAgdVOVbUMDfSw0o?=
 =?us-ascii?Q?6o4xHNc7G18ccw9TGtTRLGwBi6zgQ2qmPwsnW695FxrVHh2ZdgUAvV1w9+5y?=
 =?us-ascii?Q?RpW43zHTNDtuIW/GyiyLShQjjGu153pdGO8t4B2O2R26XT59eZM73HEB9Tf7?=
 =?us-ascii?Q?v/RR3DAY6vZkEMIPrT3YAns9gDfMhlSmXSF92NzYTEdUxrTncKCabB1GTt5P?=
 =?us-ascii?Q?N6YMmGF1t/it1EYHT0jkdofQqlvIThMNfVB+hIucuk7isNCUQ2Jo/q2Mg0aA?=
 =?us-ascii?Q?QHQ7kl1OAq9rBJljwyk/mLMeKiKNlMBQbjZRQUdJdsejstW4EqkQ87d+HeLK?=
 =?us-ascii?Q?f179gIWY9n7EoSbxe1mttKk3xo6vWuGhSDlKW8Z9U1f1gQHAdszpBkgojPCn?=
 =?us-ascii?Q?/3V4uxdYyYw84B/Pe2KrP1IpEt43ghqxZAHvOIwFW0LI46OhmOV7+vHJLXDF?=
 =?us-ascii?Q?KhBC2kvBCusJR9u1kkLWHyYO47mBIaaJorw4DQ+6rcxu9MK/oLo32g=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB7727.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?5QptO3Sl0jQXjohrClZO/LubDLHqdY5ciFi7TRqp0SCS9aX2Ufhov/WVfxKv?=
 =?us-ascii?Q?Df0RBxhfzDKJF1xL7vW+ouSz0Q8Xg1vNC9XyB08sHCpO47/zXDNtW5qjD0Yj?=
 =?us-ascii?Q?EcN0AhhUbUptgW9mVFJGiM8L2sqYN+SybGikm89vUxfVG3hjLe/xQ3JnkDLw?=
 =?us-ascii?Q?qCoK9moAwjWRH5ZZau2InPmboMp9/5az7pC9KePUJDWzW253xCASuXsz8/Hz?=
 =?us-ascii?Q?7S24DwTGv8G92mdFzrbT5XRyvhhkQKx+7hot1n4GSJFl2nUzLcbU4gTOItVd?=
 =?us-ascii?Q?AKMQa0b0TmxwdTFzk3nlNjNw+auMwvWji0LJI3hlvgc7DxIbLwPsuGYguD+c?=
 =?us-ascii?Q?aBcFrIVWt7/CdozAFRUNUP7aOv/Yoh3sBcx5SHv9yLegMy8jls4DuJC2DXF1?=
 =?us-ascii?Q?/vC1kJdj4rTzFCne+ddsD4hlHrwLhnV+iO9hBgcE9FoLSKKXKVACK95R83Pi?=
 =?us-ascii?Q?8WkYHRu4UxaJ6YSigQXM+fLoMEQ8Vxh/YKJDDokCwatwZT8EPKY0KjRSXI70?=
 =?us-ascii?Q?iPVdrN7IWQd+6G6NxTYYoVurviAXRLFCM55GNc8lI7IkFxAWKURn7E7uea6G?=
 =?us-ascii?Q?kBJm/4THiYNcAu7iqkwsL3OlrE4kN6h2j5Fa8Ui0diKlgIA+BEL1CoSoIeXB?=
 =?us-ascii?Q?t7ckPsBUlXIZkN++NN4n3QV91tvEKDDY2dtllL9oK2VYyFIzh0UWKwDtQbwo?=
 =?us-ascii?Q?36/OV5wN5O9WDHztcONgXy73lYYH8deExOkXp7pil4ksRGA6tIrvRbQkHqFJ?=
 =?us-ascii?Q?/qG9jDb7bWPiAyljFwDRdtGgqgN1erLbdRI+L3YLLwe/eD1ereqtHxJN+xwS?=
 =?us-ascii?Q?ecinqekeHI/rYNzZ+L14PimIOIz2fmojx0XsRacJan2d1IP4sZ8ll1XlTnKX?=
 =?us-ascii?Q?FDrp/xJzfhglT40GdtUfTR/JY4Yj5ynHZYW5vpn8ASnxw/EVI4kej/argT4J?=
 =?us-ascii?Q?ncbvAxwRHxxRuWivAiAAzmqY7s4SNN3V0wACSUapL7nffNRzqtPOCzxYyPjh?=
 =?us-ascii?Q?WL3mr/wbuJaC3Jy+A8T7rhiWnFpT/1W4GNX93amCHI/hmvZ8YosP78k9l5+9?=
 =?us-ascii?Q?D5tUTlNxQRUv0M2t2nvK5e5dZQK86GOG9O5D6Q3r1EOyuHImS/yzPB22TiJG?=
 =?us-ascii?Q?AWVK4EMp2ZOiUDFwlUBC0PXDUhLJ6zdhNU+bT8JmYA7eEsnofxYtZjwHbBeo?=
 =?us-ascii?Q?AbeRIhMs6p2K28NKQb0TQlxCy0tY6wZY2aAzwByoQAdOitZKzJTQ49ULfEUA?=
 =?us-ascii?Q?Qe862g8w1WVQ0ZCIwrF4CVMo4EHoPOOxqUZLZ4WwkEQ0YpobAy9t+5Cyo+P7?=
 =?us-ascii?Q?dNejlNdVD4sbfJw8ZNuIx/d2X1pN8xzSrIq9vpL8gM/E5mw6eSusDvXvKa/+?=
 =?us-ascii?Q?RgEjtggXX9J6LZmJu3TRQJU9YV6VZQSFbpc+ToKG4rme39oDx250hibnBhaL?=
 =?us-ascii?Q?Kn1OlZFD8I3kTZxN7zNeM6OR8U9N88XQLKY/8kmnnhiD0u5sNmL/mIIFaEHf?=
 =?us-ascii?Q?whh4AzK62+9wJbkQiMMlqeZ0zXA5GOktIRZGedmiZF6oWlIowVumJ48db/eT?=
 =?us-ascii?Q?2d7vkHsY22XyZlOCuYX/FxTDmUkIy9PZaiMXvrNCKDPAp/uJWzWdkESYQP1s?=
 =?us-ascii?Q?og=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA1PR11MB7727.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2c4a469-d525-4c1f-af26-08de29251606
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2025 17:40:39.2752
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZpeeqsMJjBiH1HN2ceyjJxh3xbt8EHmvavgvagar7AeVbo6WCFfMvjQk7fSD9JsLhRQ2OpGhja1L2e52IZg+IHUesYAveW1VavnC5uOrPbs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7465
X-OriginatorOrg: intel.com



> -----Original Message-----
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Sent: Friday, November 21, 2025 7:09 AM
> To: stable@vger.kernel.org
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>;
> patches@lists.linux.dev; Nikolova, Tatyana E <tatyana.e.nikolova@intel.co=
m>;
> Jacob Moroni <jmoroni@google.com>; Leon Romanovsky <leon@kernel.org>;
> Sasha Levin <sashal@kernel.org>
> Subject: [PATCH 6.6 251/529] RDMA/irdma: Update Kconfig
>=20
> 6.6-stable review patch.  If anyone has any objections, please let me kno=
w.

Hi Greg,

Even though IDPF driver exists in older kernels, it doesn't provide RDMA su=
pport so there is no need for IRDMA to depend on IDPF in kernels <=3D 6.17.

060842fed53f ("RDMA/irdma: Update Kconfig") patch shouldn't be backported i=
n kernels <=3D 6.17

Thank you,
Tatyana

>=20
> ------------------
>=20
> From: Tatyana Nikolova <tatyana.e.nikolova@intel.com>
>=20
> [ Upstream commit 060842fed53f77a73824c9147f51dc6746c1267a ]
>=20
> Update Kconfig to add dependency on idpf module and add IPU E2000 to the
> list of supported devices.
>=20
> Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova@intel.com>
> Link: https://patch.msgid.link/20250827152545.2056-17-
> tatyana.e.nikolova@intel.com
> Tested-by: Jacob Moroni <jmoroni@google.com>
> Signed-off-by: Leon Romanovsky <leon@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/infiniband/hw/irdma/Kconfig | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/irdma/Kconfig
> b/drivers/infiniband/hw/irdma/Kconfig
> index b6f9c41bca51d..41660203e0049 100644
> --- a/drivers/infiniband/hw/irdma/Kconfig
> +++ b/drivers/infiniband/hw/irdma/Kconfig
> @@ -4,9 +4,10 @@ config INFINIBAND_IRDMA
>  	depends on INET
>  	depends on IPV6 || !IPV6
>  	depends on PCI
> -	depends on ICE && I40E
> +	depends on IDPF && ICE && I40E
>  	select GENERIC_ALLOCATOR
>  	select AUXILIARY_BUS
>  	help
> -	  This is an Intel(R) Ethernet Protocol Driver for RDMA driver
> -	  that support E810 (iWARP/RoCE) and X722 (iWARP) network
> devices.
> +	  This is an Intel(R) Ethernet Protocol Driver for RDMA that
> +	  supports IPU E2000 (RoCEv2), E810 (iWARP/RoCEv2) and X722
> (iWARP)
> +	  network devices.
> --
> 2.51.0
>=20
>=20

