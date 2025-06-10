Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F11AC15E90;
	Tue, 10 Jun 2025 09:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749546914; cv=fail; b=DKAnBmADuHWi5/jdtPRfKt6xL7MH/kEnA+v7m6tUoC/gkYIo4ckabeL/gsiy/E3bSztpPA1l4MQ6Kz3cOEnUqsluY1Xgmr7rrLOqqMgU2CG5DD6zTaPZe8UBeuyJfW8QCaW1tH8+52ZzAJfoL6JsdfkUQlIEvoxsl8HA/H6tY0g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749546914; c=relaxed/simple;
	bh=HTwuzTEPnEuz7B++1uDoqzo1V+mujo1j6IDa0HCCyag=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=H49mFV+cJn//YaZAxQLMZp7AvrB4r4bobJVJfbH5UAqDkkw/D06dIlCSYn2O9t5Aa2YP6L6x+QZG7JXGdkH2sSpT0AQsGIBikErCHppLFttRf9nJUduXkcekXOc8Mom7V1I9iijhS4Uhqa/BnP+7Mq8JZvnqBik3lVXzO+7IuFk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=G8RR0R+H; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G8RR0R+H"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749546914; x=1781082914;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HTwuzTEPnEuz7B++1uDoqzo1V+mujo1j6IDa0HCCyag=;
  b=G8RR0R+HZ2K3XOscjedopUGbIv/ypojIFlVZhbOXDTRHgfv9vnnrbAZz
   9nQN9eXjx9h2ymPrdyE+D31fLbKEUT26VZIv7dPZDXB+ILEHSayykrjKa
   kwTQFCKVzkL8CscwHv+1JZ+UIFvEjnQhdkW+XJbjz6vlvnP+LcxPvBqy3
   XoGo3GyWMnnfYqHViE8JAokV7k45EQM9cruczsL4eWxdf3b73PjwR+LRX
   mrvp3ALAHLKiRDb/qMLiC5EhJouFrbZ84TmfogRU5txVLmumJhf0yIqYN
   lvs5cH6wYYhCuBSdD5fQBgw5z9Czz6gTlFnkjVT1cT0wmsoqq8HRMfUju
   g==;
X-CSE-ConnectionGUID: sT2JIpOYQZeZuJgy90biaw==
X-CSE-MsgGUID: UjCk9yaSTeyp3Amw9iIAnw==
X-IronPort-AV: E=McAfee;i="6800,10657,11459"; a="61918096"
X-IronPort-AV: E=Sophos;i="6.16,224,1744095600"; 
   d="scan'208";a="61918096"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2025 02:15:13 -0700
X-CSE-ConnectionGUID: /a5Y3E9cQKyuhaWEncSEkQ==
X-CSE-MsgGUID: +E1WIUpBTuWh71c3JPINrw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,224,1744095600"; 
   d="scan'208";a="169953355"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2025 02:15:12 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 10 Jun 2025 02:15:11 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 10 Jun 2025 02:15:11 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.51) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 10 Jun 2025 02:15:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XlfDHxoaO5NUKWPFjgOEhwoGZblFz3Vc3Ex6C58n2agQqy3ABLs7+BUYI7M2Vf6ZkwqjtCJIU5Qk9G2PARE6akCOUa89yLxGGbhdMY3qo5rm6nAzADgm93O5sD+5pMC+vL04bJ1q6VjKKJ8t4kQFilCpn5Rgu2OVSsVikICDbPmMkQYmncGIpyR8w6TSe7/QF3OA8LwGw8vERgsQJjE7g4dUVzgOHa5D2v39SWcXJUyyzgLpXblsZEJUueO/sxuzJK8PbC2hYpIuhovPQ6GZUOiXe53DrgfOmI8yJx2ItvKgIDqi9gcqT77HU2Klxm84RSC5iZ3QcXoEdXES4nBOuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5fg9R77iRq5QH2oql0/IxRgg0tzBZkQIyaoBKbNa+4E=;
 b=L2FoMucnAyId3RC4YpK404l4K33hPGP8kgw+Yc22msV0/iQ6y1FhLXlLkMgt/t/MUK/klpnedzAZRXy6J07sVsWZtA5n69FzB8YIorILAgU0Dm2gnu+6tz8198Fj7NtPX8YTxMIJVP5uMaNapvN44Drhv0pFxNEypPMpJuRzqXSmFa0LJoXq+PqKMUTDQaVJfPjCKJhS8QDVcWVf25L5mGfGEuxCIzYZuBXhUGWqE0qTlcIKt6DAC4TI4NGRA+MXH5TFH/2n3TafDERvZDk/WTzN0Do0uBFvz5O/gv8xfH62I5HIPzQNp4IcIwhHDidyBjBDDsOtQhv5v/EieXZAhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 PH0PR11MB5158.namprd11.prod.outlook.com (2603:10b6:510:3b::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8813.30; Tue, 10 Jun 2025 09:14:55 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::2dd5:1312:cd85:e1e]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::2dd5:1312:cd85:e1e%6]) with mapi id 15.20.8813.024; Tue, 10 Jun 2025
 09:14:55 +0000
From: "Wang, Wei W" <wei.w.wang@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>, Robin Murphy
	<robin.murphy@arm.com>, Will Deacon <will@kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [PATCH 5/7] iommu/vtd: Create unique domain ops for each stage
Thread-Topic: [PATCH 5/7] iommu/vtd: Create unique domain ops for each stage
Thread-Index: AQHb2XjsWnyVnyv5iUGlzszoRNekKbP8Ca2w
Date: Tue, 10 Jun 2025 09:14:55 +0000
Message-ID: <DS0PR11MB637351CDD705AEDCC1189B9FDC6AA@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <0-v1-20c73f153f4c+1895-vtd_prep_jgg@nvidia.com>
 <5-v1-20c73f153f4c+1895-vtd_prep_jgg@nvidia.com>
In-Reply-To: <5-v1-20c73f153f4c+1895-vtd_prep_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|PH0PR11MB5158:EE_
x-ms-office365-filtering-correlation-id: bc3a9518-17fa-4d23-6a0d-08dda7ff43d3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?335tImC2aA0uqcowvxso7w/7zYMHMjtYv5SYLQoUg1SD7qcQACl/DsuJhI+J?=
 =?us-ascii?Q?qXilvLHDkvSqz1wf84BQtlwq9B2fkBI0QpYn+BJAr03hOZA9m/HMpVsiR/G1?=
 =?us-ascii?Q?kVpNgIkR9eILuSjJouEX6xaKuL260rS/MQZi/0RUYQeXrzhi8omM2kXk4YGh?=
 =?us-ascii?Q?SWG3fBG1Y+5rWu9gxU4dYo67ES+m5DnRM+ougAEgViSHtW8uZ5jamzSirpyk?=
 =?us-ascii?Q?lgsnPT4UcyZ6eCzWVCGPPu9IszA9KvF4Qi9DcgO4N3l7OJA6/Uo/BSjYic/2?=
 =?us-ascii?Q?DeY6J5adTfn0ekYwEZt6YgwLMxYpMMFEGJdwsw2k2MIYiXACOUnK5/KIqFw1?=
 =?us-ascii?Q?UKkhNBaKNv9fD+y/6C61c0BjxL0htPFBfQytdydtpzJquOFIPcBmxsb6n2eD?=
 =?us-ascii?Q?hiVquRQMrfIh/ZV1wz1+4vnnuk0Y3Xx/5zWL6VQkf0N4KSl7aaKpmOiCLYs/?=
 =?us-ascii?Q?sEapvwuplwP96bagio1MNsoVFTiby2xhRjX1cfewfHvK4hejJpV6oWYZoHYG?=
 =?us-ascii?Q?CJA19h+pqsUGn3bO0Dt36zg2xGZj+j9gT+ImmWO5dH1E9hYHi6D54QPPul98?=
 =?us-ascii?Q?6HC/cglbxw5dTnXmBgGh6V6vv+WRT22JEmSnuxV2dLuXXyX3dMTNlajpeZT8?=
 =?us-ascii?Q?2oyrSGTNXmsFplvOtzFz5lPAf34r4oPkwiN27iuMPZvIxC5r+sLMVXFHtdCq?=
 =?us-ascii?Q?ROqIhdG29XI20W/ZLT5hDQmaY5nmXspKtNkiWGFZhl+XMoj36XVR9paMi//a?=
 =?us-ascii?Q?pAdpZiuMsrfMAkMuKF8+1/MHej9YHvx2DVVY0QIKMuie2MkHSP5Dlxcy+Nsm?=
 =?us-ascii?Q?U/ue6xLA0rTDv/7SwV0jGoy7PSajWP0fvfPD0hjzykOau9GpdrPlYxocfIYQ?=
 =?us-ascii?Q?S+7/7BFAYdWZU2HP9d0SBHyhGFPfMYAyB1W3jjhAtHzLaSx3nPxiyFzWTLSV?=
 =?us-ascii?Q?UPicmWoZz3iXD1W8NO8gLsgf6Dr2VsBdV3NZliNLkLAoNOl9asw3auB19yTk?=
 =?us-ascii?Q?VpldDMRRJHhN+dwbUH1Z34O8GPK1FmyEjb9QBEaPyxwHHaDWZeA1+1mRx3VU?=
 =?us-ascii?Q?Lqvh/PUt2ZqnVv7IKQJcC+HjSz8/27ET+Rn7vqwiXR6Ysi/P0G+JYOTx1bNC?=
 =?us-ascii?Q?V/Hzewnz3r1G7/BJ6s37EQhtLOcVGJ7u3sITN1j8exKQna2QH5VkY6n7p3XW?=
 =?us-ascii?Q?eY4iVCTfBWwerFhMHRJpx85uYcxOUwUz6e8HrcJQyb8FSo2Nhfcyyv2Y14bB?=
 =?us-ascii?Q?H96OgJHpS+oMqtJb9WpLmIXGAQwcF48VFRhQc7uGH/h0aSf7lPMST9uOLwB+?=
 =?us-ascii?Q?ICcdPX0fbB32eipvYMB9o4AfN2/oDHezMbuonlgIISH4DvK/5D0mJYf/28co?=
 =?us-ascii?Q?iX9BaNVJcqcCIx91tubNWUYFfXxDZ81p03iF2OlLYozndMjK7QggosQnodrA?=
 =?us-ascii?Q?8ndw7WGsruLUpmABYU6qddGiH9j4ytrswBGZz2Fa4oNn+7OvibsLOnJmvbXK?=
 =?us-ascii?Q?Wk6anaM4F3590ow=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?zMLUGURAfVlXkM91pjN0DfMbGE3o5NPdUuGAyZaa1LuwTjloUFNX4UzkVf5N?=
 =?us-ascii?Q?w8PGAVzYdjB3p6KaBNuaAPT3PMI2FEv/jE1yWp2ad0Ng24nN7y7qJGIwobgY?=
 =?us-ascii?Q?x13lQlMCakwA5iUBPrFOXs21gUa0KuBwIAKAIvzKrgvaBOfA5tD8vo3CxOYd?=
 =?us-ascii?Q?bn+F9PAXZKw5MHaVMrHIVJoktCd2fVOQL6dRukQRdUOwlFxJRAQewJa+BGMc?=
 =?us-ascii?Q?sAyirdLZsMpvJZ0oypdvgWNC1CMkinqAK9IN89WsZ2CXR2CkMRHoxDy9d04t?=
 =?us-ascii?Q?DZCer3rtSCfpEmi3V/k+QzgG2cz3V7iSG0b8KuEOXZfrK1peTpTYBTieWe99?=
 =?us-ascii?Q?z7wcW2aabO9FQneQb3BiFufZlh/LMxQ1c05PziW56nFbqfuwJW/uNjAgsWZC?=
 =?us-ascii?Q?vKMi2V8N+/hK9F4H/tYg3aflQIy083TiBNbxhmpaS8vNSqB+xJ8500ZHhs2z?=
 =?us-ascii?Q?9Gu+TEwiN4ODx5pRwg4oGVcD1cBUe78yO0cETCU21eJ6R7ZDcEqc9HN5yG2W?=
 =?us-ascii?Q?E6hbZUJ1ypoJreS2n7gp9kkmC51YH8zcoqN3S5Epn4sxOJ7d6JwxPtGv9Aew?=
 =?us-ascii?Q?kyE9Lp/ex2/3qytdcxnBfb+gsUwa6UNpZEb6LpHEZQJeEhThZ/XQ+GQ5CS+Y?=
 =?us-ascii?Q?G35P0pwiLyHcrULSCoQm8Dn1iKRL4CMDJUtxqSMgxeCjYLzKgIey7GNaTKfM?=
 =?us-ascii?Q?UqIJrSatFNhNeXPC/s/YkvWh14nuB0eAnSnFYhqX9TDKRNk/3GSyC75FInUZ?=
 =?us-ascii?Q?aas6arB6OBr0Huj10DyfGU+/F/AY0Wn9LOVt8WOX6fnA1PCml3uZuU4yJ0bV?=
 =?us-ascii?Q?UAfUIiaynZbWeHLoYqXvkCL2CSMiMPY1gRPCgxjv11WJpM0847AGThMJYZ9Z?=
 =?us-ascii?Q?ZY2psOv5f0MO3d+Kw8rZkl6QcjY0OTzqw+8X5Xg0/F5V76jwYsm7PvKIzSdD?=
 =?us-ascii?Q?y+MCVfyzJuAK+3eYbznlxtnz6vmkCVaLYMUaIj3yS1O5cjTJDFM9Tww7hLrk?=
 =?us-ascii?Q?Y0mWCtiB0PArX3WvUiZsX9ak682YVBN0Jo9JddKngVuEKjKwVu/60JaXKa6m?=
 =?us-ascii?Q?UKWW7dOwUSICgy+QSn5v6Rclhv0fg3n/kJ8qWYhNCKvh0egJLLgPGA0Jvuob?=
 =?us-ascii?Q?u8VKcPa4Ks0pZZizkAjzZk+RpXOTzgkfICE7yjXXc+z+yPMHnMm4oq69/+o7?=
 =?us-ascii?Q?ccDHuLhp+K71tRb8lInNOSneC+3t/7tRGRgba0TSOi7SoAxF0vmDwL61qjPf?=
 =?us-ascii?Q?2UX7Lxc2Do/1ianEVibLHSv5i5xZADQR2w06v6FDdagohg01jDf9PxHjdgnC?=
 =?us-ascii?Q?ApbfkupEHcgytJ8DS2iKxnXjN3dwtcOKC7CQpWrVopJ8/tDJCm1xVA3jE6y2?=
 =?us-ascii?Q?5sZqu7Exhm3B1QKHuRg7Vu+URWWY0P5eILQbNMQHP8+u5t2sw9t7DOniefC4?=
 =?us-ascii?Q?nRtT1UA8BcM/vOk/Jhibr+oWuLUgqVXZEQ47i+9htvHO0ITHjeOkplYe6ANP?=
 =?us-ascii?Q?Z5vOsXmGLbOXoCCWPcTour3t6KHeqVqTdIdEgMji2fi4Xo3jQX5TrIYVHx+k?=
 =?us-ascii?Q?HN0TLjq6fZh3Rv2zKLavPzR4ngDLfKbv/zC8rtsC?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc3a9518-17fa-4d23-6a0d-08dda7ff43d3
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2025 09:14:55.2817
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YLdftYnt2LtLGGM3GypW8U4rPvEHxLh+p82JHU6d+w45hVw/cOZsKVUrCrR5e1Iq9AG+kOrryMO0nZpcyr5zNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5158
X-OriginatorOrg: intel.com

On Tuesday, June 10, 2025 3:58 AM, Jason Gunthorpe wrote:
> Use the domain ops pointer to tell what kind of domain it is instead of t=
he
> internal use_first_level indication. This also protects against wrongly u=
sing a
> SVA/nested/IDENTITY/BLOCKED domain type in places they should not be.
>=20
> The only remaining uses of use_first_level outside the paging domain are =
in
> paging_domain_compatible() and intel_iommu_enforce_cache_coherency().
>=20
> Thus, remove the useless sets of use_first_level in
> intel_svm_domain_alloc() and intel_iommu_domain_alloc_nested(). None of
> the unique ops for these domain types ever reference it on their call cha=
ins.
>=20
> Add a WARN_ON() check in domain_context_mapping_one() as it only works
> with second stage.
>=20
> This is preparation for iommupt which will have different ops for each of=
 the
> stages.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/intel/cache.c  |  5 ++--
>  drivers/iommu/intel/iommu.c  | 58 +++++++++++++++++++++++++-----------
>  drivers/iommu/intel/iommu.h  |  2 ++
>  drivers/iommu/intel/nested.c |  3 +-
>  drivers/iommu/intel/svm.c    |  1 -
>  5 files changed, 47 insertions(+), 22 deletions(-)
>=20
> diff --git a/drivers/iommu/intel/cache.c b/drivers/iommu/intel/cache.c in=
dex
> fc35cba5914532..29b8af6487512c 100644
> --- a/drivers/iommu/intel/cache.c
> +++ b/drivers/iommu/intel/cache.c
> @@ -371,7 +371,7 @@ static void cache_tag_flush_iotlb(struct
> dmar_domain *domain, struct cache_tag *
>  	struct intel_iommu *iommu =3D tag->iommu;
>  	u64 type =3D DMA_TLB_PSI_FLUSH;
>=20
> -	if (domain->use_first_level) {
> +	if (domain->domain.ops =3D=3D &intel_fs_paging_domain_ops) {
>  		qi_batch_add_piotlb(iommu, tag->domain_id, tag->pasid,
> addr,
>  				    pages, ih, domain->qi_batch);
>  		return;
> @@ -546,7 +546,8 @@ void cache_tag_flush_range_np(struct dmar_domain
> *domain, unsigned long start,
>  			qi_batch_flush_descs(iommu, domain->qi_batch);
>  		iommu =3D tag->iommu;
>=20
> -		if (!cap_caching_mode(iommu->cap) || domain-
> >use_first_level) {
> +		if (!cap_caching_mode(iommu->cap) ||
> +		    domain->domain.ops =3D=3D &intel_fs_paging_domain_ops) {
>  			iommu_flush_write_buffer(iommu);
>  			continue;
>  		}
> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
> index 6987a46c2e8421..820a4ef9396d68 100644
> --- a/drivers/iommu/intel/iommu.c
> +++ b/drivers/iommu/intel/iommu.c
> @@ -1462,6 +1462,9 @@ static int domain_context_mapping_one(struct
> dmar_domain *domain,
>  	struct context_entry *context;
>  	int ret;
>=20
> +	if (WARN_ON(domain->domain.ops !=3D
> &intel_ss_paging_domain_ops))
> +		return -EINVAL;
> +
>  	pr_debug("Set context mapping for %02x:%02x.%d\n",
>  		bus, PCI_SLOT(devfn), PCI_FUNC(devfn));
>=20
> @@ -1800,12 +1803,14 @@ static int dmar_domain_attach_device(struct
> dmar_domain *domain,
>=20
>  	if (!sm_supported(iommu))
>  		ret =3D domain_context_mapping(domain, dev);
> -	else if (domain->use_first_level)
> +	else if (domain->domain.ops =3D=3D &intel_fs_paging_domain_ops)
>  		ret =3D domain_setup_first_level(iommu, domain, dev,
>  					       IOMMU_NO_PASID, NULL);
> -	else
> +	else if (domain->domain.ops =3D=3D &intel_ss_paging_domain_ops)
>  		ret =3D domain_setup_second_level(iommu, domain, dev,
>  						IOMMU_NO_PASID, NULL);
> +	else if (WARN_ON(true))
> +		ret =3D -EINVAL;
>=20
>  	if (ret)
>  		goto out_block_translation;
> @@ -3274,7 +3279,6 @@ static struct dmar_domain
> *paging_domain_alloc(struct device *dev, bool first_st
>  	domain->use_first_level =3D first_stage;
>=20
>  	domain->domain.type =3D IOMMU_DOMAIN_UNMANAGED;
> -	domain->domain.ops =3D intel_iommu_ops.default_domain_ops;
>=20
>  	/* calculate the address width */
>  	addr_width =3D agaw_to_width(iommu->agaw); @@ -3332,6 +3336,8
> @@ intel_iommu_domain_alloc_first_stage(struct device *dev,
>  	dmar_domain =3D paging_domain_alloc(dev, true);
>  	if (IS_ERR(dmar_domain))
>  		return ERR_CAST(dmar_domain);
> +
> +	dmar_domain->domain.ops =3D &intel_fs_paging_domain_ops;
>  	return &dmar_domain->domain;
>  }
>=20
> @@ -3360,6 +3366,7 @@ intel_iommu_domain_alloc_second_stage(struct
> device *dev,
>  	if (IS_ERR(dmar_domain))
>  		return ERR_CAST(dmar_domain);
>=20
> +	dmar_domain->domain.ops =3D &intel_ss_paging_domain_ops;
>  	dmar_domain->nested_parent =3D flags &
> IOMMU_HWPT_ALLOC_NEST_PARENT;
>=20
>  	if (flags & IOMMU_HWPT_ALLOC_DIRTY_TRACKING) @@ -4080,12
> +4087,15 @@ static int intel_iommu_set_dev_pasid(struct iommu_domain
> *domain,
>  	if (ret)
>  		goto out_remove_dev_pasid;
>=20
> -	if (dmar_domain->use_first_level)
> +	if (domain->ops =3D=3D &intel_fs_paging_domain_ops)
>  		ret =3D domain_setup_first_level(iommu, dmar_domain,
>  					       dev, pasid, old);
> -	else
> +	else if (domain->ops =3D=3D &intel_ss_paging_domain_ops)
>  		ret =3D domain_setup_second_level(iommu, dmar_domain,
>  						dev, pasid, old);
> +	else if (WARN_ON(true))
> +		ret =3D -EINVAL;
> +
>  	if (ret)
>  		goto out_unwind_iopf;
>=20
> @@ -4360,6 +4370,32 @@ static struct iommu_domain identity_domain =3D {
>  	},
>  };
>=20
> +const struct iommu_domain_ops intel_fs_paging_domain_ops =3D {
> +	.attach_dev =3D intel_iommu_attach_device,
> +	.set_dev_pasid =3D intel_iommu_set_dev_pasid,
> +	.map_pages =3D intel_iommu_map_pages,
> +	.unmap_pages =3D intel_iommu_unmap_pages,
> +	.iotlb_sync_map =3D intel_iommu_iotlb_sync_map,
> +	.flush_iotlb_all =3D intel_flush_iotlb_all,
> +	.iotlb_sync =3D intel_iommu_tlb_sync,
> +	.iova_to_phys =3D intel_iommu_iova_to_phys,
> +	.free =3D intel_iommu_domain_free,
> +	.enforce_cache_coherency =3D intel_iommu_enforce_cache_coherency,
> +};
> +
> +const struct iommu_domain_ops intel_ss_paging_domain_ops =3D {
> +	.attach_dev =3D intel_iommu_attach_device,
> +	.set_dev_pasid =3D intel_iommu_set_dev_pasid,
> +	.map_pages =3D intel_iommu_map_pages,
> +	.unmap_pages =3D intel_iommu_unmap_pages,
> +	.iotlb_sync_map =3D intel_iommu_iotlb_sync_map,
> +	.flush_iotlb_all =3D intel_flush_iotlb_all,
> +	.iotlb_sync =3D intel_iommu_tlb_sync,
> +	.iova_to_phys =3D intel_iommu_iova_to_phys,
> +	.free =3D intel_iommu_domain_free,
> +	.enforce_cache_coherency =3D intel_iommu_enforce_cache_coherency,
> +};
> +

IIUC, the only different callback for fs and ss is .enforce_cache_coherency=
 (from patch 6).
Have you considered splitting them by handling the distinction within
intel_iommu_enforce_cache_coherency() itself:

static bool intel_iommu_enforce_cache_coherency(struct iommu_domain *domain=
)
{
    if (dmar_domain->use_first_level)
	intel_iommu_enforce_cache_coherency_fs(...);
   else
	intel_iommu_enforce_cache_coherency_ss(...)
}

This could avoid above code duplications.
