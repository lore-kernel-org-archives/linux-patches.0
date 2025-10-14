Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D1D62BD597;
	Tue, 14 Oct 2025 07:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760428726; cv=fail; b=ZiomPpxTbj4WMDZYTsf+TwUUN9aB3XAoMSYUQqJYYbp7JjYRK7GyhHr6w1zLxVsDaY5oOwLTPW3UTxyrhWg1hG89gB1ul51o13a7cURG4wzb3Ha215yzmp417l2xhFLrZhikVFOi90X2cNoziFRMSjCuzmOaWSe0MuNodjdvKzU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760428726; c=relaxed/simple;
	bh=8+gLNQObsl3/AU+0Z29Pp74VZDvFEy6/DkUUh9/5K+A=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=W6xZTffVt9G1Giu+SSUo0BQg4xYJcs8G7rfEn+Wf7uBt1U8k+pDfXHyFROLVhsEVks89V+QsKtEFAckjdHBRpjPo93aP4qI7Y4tUhvLfyEihisna9WNgYUxDhKqlth8oDVoUVBwPJMltvaMaUgriKZbLsQrBSDLGMUx9ST0A/LQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TsmtPMB4; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TsmtPMB4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760428726; x=1791964726;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8+gLNQObsl3/AU+0Z29Pp74VZDvFEy6/DkUUh9/5K+A=;
  b=TsmtPMB4s++lZDxRBlhqdMgL+/LJl7QuKEFleX71D8DlnBFc0y8eg6hu
   3aJiXNHTU1IoAsyF2GfTsPzs/gDEiAw0ZW4fraVaq3D4PqqwvA5oWheoq
   90XoooHsO8+Ku85TpTeGDHacNOfw+kVHCaM8w3CNlGOEKe9vsJR78kwrB
   C1jMlXSTtnhcGTByiQVMT7UKAMdZdmTloR5sGE9LNDRP79lVGl/SaRCBM
   wwHR4tdGqmEkxQ86v6U4+XwMtxF0gDhEtaTWlxNxdDLTNY3A5hp2txpsF
   xbjjKspEnixiI2mF+TahHPw5fHOtfTJeEhyqYk0WtztWwfVmOrZgtgtNP
   g==;
X-CSE-ConnectionGUID: xpQ7b+HDSz+kXi48Ri+1zA==
X-CSE-MsgGUID: yRLNHio7T/mHSjtZmm0yhw==
X-IronPort-AV: E=McAfee;i="6800,10657,11581"; a="62477068"
X-IronPort-AV: E=Sophos;i="6.19,227,1754982000"; 
   d="scan'208";a="62477068"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 00:58:45 -0700
X-CSE-ConnectionGUID: DlFzhlcKQjipUlMdavszCQ==
X-CSE-MsgGUID: TeR4O9tDTCCpNOXkeYNzIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,227,1754982000"; 
   d="scan'208";a="180968416"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 00:58:45 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 14 Oct 2025 00:58:43 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 14 Oct 2025 00:58:43 -0700
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.43) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 14 Oct 2025 00:58:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BdWAcwhZiFqGFLmJLsGa4589UHap+FmO/pyyX3xlSVthtZ2JhEojqfQDQSQB9Jejk9BXxSLYqEjSPEV0LzrXvYN4t26F0eSM9uEtTG+s3KEuNsmM8xytlr9B9wdeAuIBawHd9Clr8TJKmXxPmxUY5LEiFzLWXEKQJNljhotVf7+61zqeuLOwfOT8bVp5lzV4ix1o2a2nAenLB/p4pHgjGIWgaBT/V/zdxZg5B1Xp6gaeY5nj3saDiQQ1poHRnfo0/9fTMJBnxFpgb+fiBkmEDvMwuYM3o/heDS9n7VBwc/ervcE7u0XgbrHrK1BzI6MXrH/Mqa3REAvtbQ08sXSYvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8+gLNQObsl3/AU+0Z29Pp74VZDvFEy6/DkUUh9/5K+A=;
 b=YEHjOPjMMwknIP8mP5L4hhb0EkZO0ZXN5v0cFDljDpkiPNvHxGd/cjp0SaUUcOWDsqvUdoAfMlEOokoOmcQQDAgZkK7Pput47xBwQvodRwS/34x06wcJFnKE3nrsO3AVK7jbK2DvHuhEWBlgZDM3E38sxesRR3oSGIBnsQHH1qVjXsI0CEXOSiy9bzctMBgmDNRL4AyuDJbbXFkt/H8R987tR0vw/TkeziGESwYqIgPbBUSwvQmX9ALus4IsrrO/B6p5jy0A9+8dFbgzTM2/3lgwkC24y8WlRLn6Gn7iNfq4eXhWX3HPmaT+DUY/Uo7ZbeJcFn7V4E5i9p1SBP4pLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5271.namprd11.prod.outlook.com (2603:10b6:208:31a::21)
 by BN9PR11MB5307.namprd11.prod.outlook.com (2603:10b6:408:118::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.10; Tue, 14 Oct
 2025 07:58:41 +0000
Received: from BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::5616:a124:479a:5f2a]) by BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::5616:a124:479a:5f2a%6]) with mapi id 15.20.9228.009; Tue, 14 Oct 2025
 07:58:41 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>, Robin Murphy
	<robin.murphy@arm.com>, Will Deacon <will@kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>, Tina Zhang
	<tina.zhang@intel.com>, Wei Wang <wei.w.wang@intel.com>
Subject: RE: [PATCH v2 10/10] iommupt: Add a kunit test for the SW bits
Thread-Topic: [PATCH v2 10/10] iommupt: Add a kunit test for the SW bits
Thread-Index: AQHcFq6gOM/rp+MYgEOIJ5IU+TaxR7TBk02w
Date: Tue, 14 Oct 2025 07:58:41 +0000
Message-ID: <BL1PR11MB52717A2E9A1604A5D100577E8CEBA@BL1PR11MB5271.namprd11.prod.outlook.com>
References: <0-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
 <10-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
In-Reply-To: <10-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5271:EE_|BN9PR11MB5307:EE_
x-ms-office365-filtering-correlation-id: dfc11b67-780b-4a35-38df-08de0af77dd0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?jjfjp8ojPfIWSuoOWgbNZ6FcZ4Z6qjCVosrHoQ6rvPzz5V5RCm4yON/XXMSt?=
 =?us-ascii?Q?2qOQuaA7x9vnBGocYdpbly4syyuSPf06ohbnP9OT7Zc833ueBL+o0uMVN2+1?=
 =?us-ascii?Q?e+0tU+5oI1MhaGCpK/bgE15VBIxDUvmcwJUuKyX+TX8T3y/N1mUEp7I1ZGkt?=
 =?us-ascii?Q?6EC8VqYGb79uue31OfPnBWwBCTfLWuYF15+QP6MLWKWie7Go91bII9a4x9t4?=
 =?us-ascii?Q?CCv8eePS5hPEDUlQDOVBvDdH/POKoNH85KGKhdkHbYexubLa+n9FRBfkhazN?=
 =?us-ascii?Q?UlDcMv9vIib1O2fPJgWTPq/Cxp7Y78qH7yxrQpuL8jbOTl00mpuP6yaSIIuB?=
 =?us-ascii?Q?Y3bQKp8gdgsY+A1lp5Vo5zvcyCo+86cNWFFL0WrMkVMTKgUeVmORYxECeImV?=
 =?us-ascii?Q?feNfiw5EiLwaeG/Cz7pNZyvqSmW8vp9sPwZDse6rYR9mzYP4iM35zDYGXxwq?=
 =?us-ascii?Q?IEd6cbKJmBToDUHSilv9TcIGMETT7tEJGPmiyWzkHsR7GsQPnC8Qu6d+Da1e?=
 =?us-ascii?Q?e4nV3P8iBBWXoGAy4H+e1et+UvmpTHFmutXpT0d991Nkxu4WEZtknbNwojvu?=
 =?us-ascii?Q?EMTAyPgfQMW+x6Q0+zLYzHKmpSjo3hsPI8E5nJ0nf6FuIpT5qT+dcNLYmNkM?=
 =?us-ascii?Q?laJXaqf5i2Cbx1V2tLIAPHCoy7WRCB0F9LUStSVMHSfNwF+1uHXswXBJUSJE?=
 =?us-ascii?Q?OSeknT00Zf5jDXb8p5in9tuzkN835ZyoaIg4OK4Os8jKP6cKJffWtJeByI/5?=
 =?us-ascii?Q?hznzIvn1k33/ZuR+mZty68u7wkv8eNYYcD5xOJFx/7Q/jQes11UGvQvqpogi?=
 =?us-ascii?Q?gTKcpG5fvT11hyCBYOdjd11qed0+W8tvFnn40jZsCiDkvQhm52z+hHP2rj1m?=
 =?us-ascii?Q?4pnlxKm0VSqYter+dqR4uKGN31PMahvkh+C34NwE6YREJX6AFBOHcB4Zy6+C?=
 =?us-ascii?Q?yd4ssHDvN5J8pgQgbphE/QzN+cq1vj/OT7ivNb1wz2N+BKyO/WdQnvap6IFu?=
 =?us-ascii?Q?km9r5Sg4HQIvu/aydqZnsClkxMersNJMs5mAQ90eAFmgffuy58gUyOsbZq/F?=
 =?us-ascii?Q?jA80JgJbfp9k4xTicmM/NAFKsL9vu2Zv9fXaOtNtiWrBAKNrKjWhJm0y51so?=
 =?us-ascii?Q?3l9H1tk+U5gueaRTwMzPgT88mh49+yQIh3IKo81Et06i9cjbCHLyZKb/8kcx?=
 =?us-ascii?Q?OS3fTj53tmNKic0yX/pl4JNPNXMHn5hTp2Kl+PolHGhDxcM9+fz6/AGJs8Ij?=
 =?us-ascii?Q?Y5aqoTObWTVj5wzvq4b9YpoZhZgHQKznGwf49O+2mtjD6LuOfzya257F10DE?=
 =?us-ascii?Q?MaK9OQm6gEn9peqKMyG8nWMYX+x24tK4ozqv5SXBmOtgnyGX3Bq2daQmwVvm?=
 =?us-ascii?Q?GF0+IjzVdxT1JZ4iS0Gps8361qzug7Z0xUN4eQQ5gXc88EEzhY3ZltQEZmys?=
 =?us-ascii?Q?Ujsk9hYWM+otWO7tZIrpNhNP7yAMpkeqv7tTP5eWymhYozvzvDBpVO0zbEqg?=
 =?us-ascii?Q?zXVvzzrRnLTHte45izrp01b2D5lo+EgvNsT+?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5271.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?7d/Ymz3xe+LX+EFb18jJi6wY/LCsjBsy5/CM+mLdBl8DbQ7zze1I1LvVO6Sj?=
 =?us-ascii?Q?OzJfrS3KR9EkhRQ1OlT9dTx9zrM7nwA/tI8AmdL1YR8dW5ZKyhC1rl1U00CI?=
 =?us-ascii?Q?hiuPJ3gGPdazgH9TJVim+/ADGgqiFPIuMrI3VFFoHVviEsyJdke5GfDY0YyD?=
 =?us-ascii?Q?Cq4ctJikTaKXKVXjT93v8eAWpLQsHmFTtFsnL9UBVQs5acNV47vV/Cy3SF5Q?=
 =?us-ascii?Q?ylNQUIw1gQwRW6xAnIZ69AJm8DnDe0rHMpsvUXoV7QdzEhKOWsDldnDSMxua?=
 =?us-ascii?Q?emFVNN+IVJ8kpFiRpywQ5ORJtukg7qKkW/soT0ZDunWz3lJl1c3eb9/5ubrm?=
 =?us-ascii?Q?mrZzFHIRNwvmg5QT2ZGbHS1OUC/6p28de43OcOU6P2iAsRV/rwZRZEWlZIsk?=
 =?us-ascii?Q?inGPvV1ad19fmRI3cEo4CP408VyJqc5r71CRavlrZqh6I/Hp2sS8TNLLtn1a?=
 =?us-ascii?Q?ih18MC95KJdslryHqI+9IS7cYJtjKxbZoaA/jD6pTlxBG4zxdZNp6qBs1d3v?=
 =?us-ascii?Q?jvLgajB202Lr2d1vTNvI41FeOpBjbxykQcTJwXVxTKbL6VCfXR1sPYoAYqCF?=
 =?us-ascii?Q?vgeu7Z6/Lkp1a2maUk83AeSHIqYoj3euwQcxZVIcncIe5Koc1nrmyCFT8VlM?=
 =?us-ascii?Q?lAIbySvDmxxn+Dvl5BIg7Hc3+9KIFqepTNC2l2iECpDo8kpT6ccb9HIhB0ku?=
 =?us-ascii?Q?x0GjeettewdNh4zGX1GNEnu8bDy3t36z9V1nk87X4alrJShYPoHfyEK2LfII?=
 =?us-ascii?Q?gyXrt1CknymKSlCeege3ufDWLyQ7bwb9sQA/Iy7mjMZUxLbIJNKvlgOOMoVf?=
 =?us-ascii?Q?0xF31LfbdM3waxBOt7KLCS8d0ZHSSVckzlL1qel07n1+xXhmwrPl/xmChrvH?=
 =?us-ascii?Q?EC2GqtqFWh7BazbAY1Qy3VFvOM49MYOa8P1WxjJGljHqzrY5iZ/V5TctSRsd?=
 =?us-ascii?Q?JwcMBBEyzZwVbhc2ZjipxrMxo0vXlXITcehnH0kSSPBpkVI92d0bhXX73+Dp?=
 =?us-ascii?Q?1HJ4KLIIgb3ukHOH8wMHGLej16dGMLgvfMo7lMOuKryE33kXuZCSxjJyAuhY?=
 =?us-ascii?Q?GNhg2jVZF6C3eGrI0w+rwiBygfA/BfFh3LP0EkKTPzDk6ho9yDEnFEaVHxnK?=
 =?us-ascii?Q?h7ey2GJvcplNZx7IsRGPcUtvKYI0lz4IGCc+KRy0abMGTsxF7p8xelI9R6jZ?=
 =?us-ascii?Q?m5+nNP9lEu/JX6p/XKWmNacpG6RmZ6v5MMmMqD+igNV+NmPzQIifn2oWwELa?=
 =?us-ascii?Q?zQVnsCE5mjyr2yFQEqhpKgJjaC78QhtIJCPnAC8noAXtNNDCjVak5vci5dgl?=
 =?us-ascii?Q?+4SAkT5syA5nW5kDoMOPsfl5GKQV0yhW6eNYstFQuIms2H6FkTMWNjK8PadF?=
 =?us-ascii?Q?WMT3AL5Q5VqVA9uQS/V+YYqYjmdamdboq2H7/CzsutcUxQfYcHc0jz/WEupO?=
 =?us-ascii?Q?963t3QXpzValMCeNKs6hmVmME7ti2qxcyzM2GrYNxcdDF/sgReBwguX1T2cN?=
 =?us-ascii?Q?P3NDWI/ziTUduoZw585nX1GG6G6UjwgUo8s8oqb8sc/rKGPNvnqP9T8E5ik1?=
 =?us-ascii?Q?MVhxwkKgrTMYmapAU64yZFHIcgjmPyS9B/IwWIDu?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5271.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dfc11b67-780b-4a35-38df-08de0af77dd0
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2025 07:58:41.7064
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oEvmC6AXQq5KlDDVrcHCr5Nu9cJjBH83IH8dBOKBzZDlMi3jh0Bu2FGL0vnJopAccMcqfx8xgkgbek28XfRgNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5307
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, August 27, 2025 1:27 AM
>=20
> Add some basic checks that the sw_bit APIs work as expected.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
