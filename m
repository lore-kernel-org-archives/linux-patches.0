Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CAA01A01B9;
	Fri, 13 Jun 2025 07:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749800039; cv=fail; b=cJawnaP7uGx4PHxLZXv81KGGTfDx3Os4qgLkDCoIN8SqQhzYxV+8Eg4kE35syJyzt6H/3gb8Xk0hHrKduTniY/RQygVHOTRPJuAzyOhfkgo+Ct7+qnePtxqTg9pJHXmoYTb7inJhQUa0e22dpK1t8zFiEiC2JF6VYUagT+acqe8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749800039; c=relaxed/simple;
	bh=zDyW2YzdNIcgTXgb9UDuwf6OQnBlAw3y8AqdSgAIfvs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KBK79rrrnyBu1WDFWCiHYlnhmtPO/TkzoiotZvdeW8H76wYEgoM+coTYdXkcw+fa5pdmUzBGTrN8sD2mW/xFYhiU8/cK/Mnz6NmP32oAnTxDoTHAOdzqpJEuA/crxpLZHvN6mSmI3V9wuyikXd0DzFxiFvIBeJYAr8gdc4KlNDs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E6rPm0TQ; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E6rPm0TQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749800039; x=1781336039;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zDyW2YzdNIcgTXgb9UDuwf6OQnBlAw3y8AqdSgAIfvs=;
  b=E6rPm0TQrv1X4jTKAWIDjHbSn3cTHl8ArHVVOKs7kWt2qGuzjYUTJYKp
   Ezq5T+pyzgEFltP94xt5a4zG9/Y+jrcC12Dhvy1U6OQSe9iVPV7Qv5X4u
   Af8BsXnmcoXZB5K1/d752EoGDPJEIUBkCv4tUmrzOSr4zVBzA2CJe27nU
   ZErUiA+Wwg3oDunMm9zq1ZbfvgO9QPbPQjQ7BPyznBpA2DEq1VVFPqvnG
   dZbaaVZbCQhCK1pFv6oH418uhndb4UefWBIFib2CCRm55eJT+bS6px5x1
   NDydWV4ztJniUUZClydckMgpBrrD3diNuhMOCAyKHFTNgGb8tqQ6UHmC2
   g==;
X-CSE-ConnectionGUID: IwkyP7YmTvyTlbKPod8qFQ==
X-CSE-MsgGUID: rzfXdd5KS1yQVdadRU52tw==
X-IronPort-AV: E=McAfee;i="6800,10657,11462"; a="51927016"
X-IronPort-AV: E=Sophos;i="6.16,233,1744095600"; 
   d="scan'208";a="51927016"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2025 00:33:57 -0700
X-CSE-ConnectionGUID: 622XRQTvRliCsL2uzHZr4g==
X-CSE-MsgGUID: tRJKQX7rQh6HtcBJwtFkZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,233,1744095600"; 
   d="scan'208";a="147633125"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2025 00:33:56 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 13 Jun 2025 00:33:53 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Fri, 13 Jun 2025 00:33:53 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.68)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 13 Jun 2025 00:33:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ym1sc7d9LnDqMFxb1YFKJSTEozLF18pjaCMsIa5oZ5CUYc5hf4K57XYAi39RXJLJLtFrZNgupWUtYMvsy0PsSSb/gIjpJABrQN9h90XJwZv3K9C5vo5HQboSJM8YsP6oCeBdptHp0mcOwep6XgeWzbWsnveZv6271J/zn9m++DKHpGX2mB+bB4KjIDAg9ZgUJxcuo9Nmjdu+eeNiLJV4fS5m7zJytAcNIUKdvcFUxfFnQVBzM/kVi8Y6r1ROCUhD9qlwiTjILXTU8m4qm5HWITciG2Wpcs6jI2J5e6Cn/6wVROVCMnK9O2wk2YOnAa+tRNmcCDOVqvrvVg+RfzgpJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GRZ18CzDwYVkPfbc/vicytDcPd0i4VNwBl+a1hEsk5Q=;
 b=ZYkqBI8OteB1t9UfwQqxxUbUumhuvYgmlDpWhfJHDnF19fyZw6OOzSprmhIJgrnlsPw13HF87KRdWwnOAOt2knMWTMGtVko7slHPClVFwQnOgtQL/zRXifTwRMLhMs4CUURw3cmsZqLZo95y7rIClw+61ee4rALfx7FWF0zW5ABrYHVX9AbEuCYhArZLuz96r1tVmg586Udu/IM1m9XSyQSHzrXnn2ZKD/S0J0ZyVzhzcYGA8E2NZPXy6cqtpfb+EZAdjCdP7n/4h1EA6ym/aPHjYou+pfnD0BEw1QFSgin1LqsRnE4RR8LtkcRh9wHQBg2iU82VjJJxke3CmSq0Qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ1PR11MB6202.namprd11.prod.outlook.com (2603:10b6:a03:45b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.29; Fri, 13 Jun
 2025 07:33:24 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%4]) with mapi id 15.20.8835.025; Fri, 13 Jun 2025
 07:33:24 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Nicolin Chen <nicolinc@nvidia.com>
CC: "jgg@nvidia.com" <jgg@nvidia.com>, "will@kernel.org" <will@kernel.org>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>, "joro@8bytes.org"
	<joro@8bytes.org>, "ddutile@redhat.com" <ddutile@redhat.com>, "Liu, Yi L"
	<yi.l.liu@intel.com>, "peterz@infradead.org" <peterz@infradead.org>,
	"jsnitsel@redhat.com" <jsnitsel@redhat.com>, "praan@google.com"
	<praan@google.com>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>
Subject: RE: [PATCH v1 05/12] iommu: Introduce get_viommu_size and viommu_init
 ops
Thread-Topic: [PATCH v1 05/12] iommu: Introduce get_viommu_size and
 viommu_init ops
Thread-Index: AQHb2WH5pFGoF+3KtUmvezY7edKsjLP/MHUwgACVjICAAPHe0A==
Date: Fri, 13 Jun 2025 07:33:24 +0000
Message-ID: <BN9PR11MB52768FBE36CED363F26CD07D8C77A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <cover.1749488870.git.nicolinc@nvidia.com>
 <bc2c57254c40028e4dc74f32ac350826a26b3d8c.1749488870.git.nicolinc@nvidia.com>
 <BN9PR11MB5276F17940D4B219D5B4F4BC8C74A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <aEsJKZLRTf36Dh3Q@nvidia.com>
In-Reply-To: <aEsJKZLRTf36Dh3Q@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ1PR11MB6202:EE_
x-ms-office365-filtering-correlation-id: 11701882-4656-411a-1a55-08ddaa4c94a4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?kWbaK7dzo7iAuBDuHzIFVsyRb9HbXsA1FkqqJErzioBt+DiTrJ0DjO1YFQ7Z?=
 =?us-ascii?Q?S6REpUi/6ekbcwfNaogMcM3tCEwRCjZ4dZliKBoThHKcGAcoI/xAmGHLEDgm?=
 =?us-ascii?Q?MxVscGJgZhXMuEF74mwKMnSwomN8LEdTQHWjyST7ilB4pW7TpIqrSSok48aR?=
 =?us-ascii?Q?1cjL3KV5zleYRCqi+Lhm655Wpq/dZdi5R/Wif0osVRdZoXdGvRDQTyFI6wgE?=
 =?us-ascii?Q?LDyEfcWEE6EVXDth28FNDq2DFfD7qb/fNAlTLVJL+Otzhbj2kmdMK8J2dT3A?=
 =?us-ascii?Q?aZoox+oZCH809Mn7QpTWhSMLHMYaFEujjnuB0klflzA3dOETees+G9b6lbLZ?=
 =?us-ascii?Q?PV9YA1zviMJuHgD2KX64vOPwZv872/6bz1xtFCdUgeLcfLJVmRb2T1Qx0nwN?=
 =?us-ascii?Q?RHB32nReh6YQxI4i92f2wV7mjQv1AdgcAWwucH8KQoQa2LRu+D/nUF+0SuBw?=
 =?us-ascii?Q?GIBhnERHOEPmGmIjL86zTQKgjtbAMrC10NIStyGTw66w4wtxlUF/WGwf3RT5?=
 =?us-ascii?Q?5dRxHR/tMDKsdskxjhAPY5B8c745gcuB96dwNDpG0QJl2SyNLmQXQmSJzwdo?=
 =?us-ascii?Q?aBEcVpHlbjBpgz+XcKaoLO7AO+MhoCx7klJFfjScCnYPPWtmlZzIkiASsp2F?=
 =?us-ascii?Q?jQx0Nul7XttjXsZrjqg4DLXFhsiarqF9YVFzua8JZSQNwPM4hhRHMJcIthOL?=
 =?us-ascii?Q?lo33fvYX/o8qrsgNrnMcoUKey1vA9gGmRVAJ/eRgjX4WH63lGfG629qYRUVk?=
 =?us-ascii?Q?eD+H+wjivxrRBNkC6A1ynYqwKupODxWfZxSdtIJFzg7H7M6HIk7esd+JGNET?=
 =?us-ascii?Q?bSZ0SJGXEQ7+Aaf4rzooHzEqKHGbk0gnPFX8SfirfL2ZN/Qg2ud3LjyQBHQ9?=
 =?us-ascii?Q?C5C3f1ceAeyXI9a4ZctZcmo8vlREFYHlKJ9PfkWclL3TqnJ2+wT+NsgoaWTd?=
 =?us-ascii?Q?9Ogcxxpd+CkT10Cw35fdG+LpzQlHval25GD/vzLQ/pY+LAUlc0PnpUO0HmqY?=
 =?us-ascii?Q?XzvIJKGHs831I0J3IMvdk9oPOXhlNpEhuaWxVK/aHWmIkb2jT1xwz6SevTnO?=
 =?us-ascii?Q?78OAbhmPWo0GtscjPGI58SzgS9Aju2Y6xtscN1fuduTlOGibYMGAB8WiV8x6?=
 =?us-ascii?Q?1gsTfl3NMiJ4AGeAcXWeiU0v2FipsPl4QviM/Mq5cSZ27oktWdAUO2lk/mjq?=
 =?us-ascii?Q?y6J3VvyMplcILHRcou/Euh052Yr8Ur6tX0PITTwvGkjYsHM9dIHZcqGpRnHw?=
 =?us-ascii?Q?Bn37btnSkEXbWUcxm121fwOrT7zkxI9ZnnTjXon+PW9RtUzDUJM/Qz2S9aRU?=
 =?us-ascii?Q?6s+1bsdze4Yar+deVyC2SfJp7figfv9ztHkMGwFNo53Q+NqvjKGr0m1nx3gH?=
 =?us-ascii?Q?pKymkaq5i7438d8nFX3ybWB+CsdrU7pLX84QjeBIgxk5vKcdPNlnQU9AyTHH?=
 =?us-ascii?Q?4t/mxCviZDbbui0msIFc4yrERvbj7GBWsKHiU9svYjqVeq3AOPnVSA=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?x0jYrszavrgJSMRJoPIh43tF6qe7LzJyphuWXcleOG92/m52WaDC3PqdBGVV?=
 =?us-ascii?Q?N3yB+JB3Wa2uvY5E4GX6jKojUCMxov7r5mXiEsKcT/Zlz1YmWMqEGI7VZ4Av?=
 =?us-ascii?Q?c8fIXGKGhzdsnwUMuGvdwac2G4SZHVtA5joU8cCJwcRcNDw+tc2lVNJIrgUZ?=
 =?us-ascii?Q?Lpodo5Fokzb7Oo1jxumOckI1sSn0T/DyiA3p04wyouxGDWesSCrevTNCp9C3?=
 =?us-ascii?Q?Iw7EMK60p9YCUXL0BATil7tIxLp53z+o7ILAIWEW1q0V9us+SD3bKZuoRh5D?=
 =?us-ascii?Q?DQNAi0cQxbKKuOw40W5MIBUWFTHIa6M4vLWM6hFtHeB0Njjd/am+jGnLcbR8?=
 =?us-ascii?Q?a1SYKC2DvPiHmRxXcgnI/59Lp6TWRA5Pgq5gBchBtsFKaQNgAaZIqeCc9qwX?=
 =?us-ascii?Q?LZD8aBVRJkJQwO/f8B0nbk7ovVZjMIeriARB7ayYziA1wdXCeJG3aStaqw5t?=
 =?us-ascii?Q?qZgbxyynpM8t6ttyebjc9Ru27lzbuV8FNUSX2FOTbZi6RFyEada7KiAbAivl?=
 =?us-ascii?Q?sTlshNUCmx1+htjUXVdFd7rX6nF5OtKViStrLWd2Nh+PsMxpMSvZT5fNiyPm?=
 =?us-ascii?Q?2vn9wldeaMfbnHpXRlQYO6mLtExyv1KQ0hNoEfigiCaJ9W4qosT7W/BCR4/V?=
 =?us-ascii?Q?mWHI70lYNX3TRZ7qjgdHhlOzpaG3hpwVbmE9fP21rR+7xuPcl48WQkPuMjSd?=
 =?us-ascii?Q?yVEOA2VkM4gzqLaIstCuT11VzhJnhd5oq3bSIHCeBPgLW2iWqnT6vx2nk18c?=
 =?us-ascii?Q?S+4iT56XQEeI6VPEyQSCMsEexcMo5d4s2kNyc4Gn+pAJ7dKfwkiePepV5bjR?=
 =?us-ascii?Q?NqEdpuTEjioPCBWuWo9OuqH+862dC6E04Pvjw+a95eBGoiRdg8exswHuzdMY?=
 =?us-ascii?Q?ar4RjfwuQnO0SFl019ndcpXvvomUZ+sly9IFI3BKtEMYn/MGK6mLxpbRobgm?=
 =?us-ascii?Q?t41I2d0hrpFpIKAukg9X8DE8UH36whNgo2/6DLRODWKvVIdOJ9lxsBjANx9X?=
 =?us-ascii?Q?D0/zK0Awubm/rFK8PlaKms0Opy9sdZrrhG/6KnlzBbWxqqmqXZZmc/UmZ53v?=
 =?us-ascii?Q?trDl/hUcw1hJ/lrM7Nh0NOCPvThiSmzwhkZC784NrHeimLAwZ9PJEhi68nNu?=
 =?us-ascii?Q?GCw7kkamSCujlmmtgWrcvDOfsipnhf3RdxmU2A7vnao1KhKSKHHa6wjGgkbQ?=
 =?us-ascii?Q?smCSpBeyiRxQvlWRPvFuO9twhsvZvlgrsUkph3mxPIMvEelifEF5XRGORue3?=
 =?us-ascii?Q?EQnrkG3FZnaQXctDIgNep2ymK4jvO4SvCJGQKwpKE2xl4avuFZjpv3wxEAki?=
 =?us-ascii?Q?hh+NIWwRESL9ySEF5tFmFo+/PfovwuqdJpI/XzrToTLzCKcI3acbk8F444DJ?=
 =?us-ascii?Q?hzszLOdzs7BLXIFQt7vIveA5YNPDOg9Cpqff/SMsjYDNCzuwj+0Wraa8ZZRv?=
 =?us-ascii?Q?y8FSTpOIJvPFiRpIjdBigjcTFvMOVUpg/9NkN7Dhx4X9c/e58HyDIj5qnWXg?=
 =?us-ascii?Q?0V4anZISUo8QA7rDsUfu5UJvhu+FISr3N3cB33fYrhDqBiQZC96FX0X5mpAT?=
 =?us-ascii?Q?33VtyX8Y95gpGhocf3mtqrcjOY90gGWKhgW9UVqn?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11701882-4656-411a-1a55-08ddaa4c94a4
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2025 07:33:24.4353
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jZHbSrEPz9HM++GFAf7yJqZbsGlJ9ngplUk+qw3i3EOsuGZjdSR4fVRIpm0Op+11XmEmyJpz1jero1/pUzDe7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6202
X-OriginatorOrg: intel.com

> From: Nicolin Chen <nicolinc@nvidia.com>
> Sent: Friday, June 13, 2025 1:07 AM
>=20
> On Thu, Jun 12, 2025 at 08:12:29AM +0000, Tian, Kevin wrote:
> > > From: Nicolin Chen <nicolinc@nvidia.com>
> > > Sent: Tuesday, June 10, 2025 1:13 AM
> > > + * @get_viommu_size: Get the size of a driver-level vIOMMU structure
> for a
> > > given
> > > + *                   @dev corresponding to @viommu_type. Driver shou=
ld
> return
> > > an
> > > + *                   errno if vIOMMU isn't supported accordingly. It=
 is required
> > > + *                   for driver to use the VIOMMU_STRUCT_SIZE macro =
to
> sanitize
> > > + *                   a driver-level vIOMMU structure related to the =
core one
> >
> > What about returning size with '0' indicating NOSUPPORT?
>=20
> I tend to support other errnos here. Basically this moves all the
> driver-level sanity checks from viommu_alloc to get_viommu_size,
> to reject an incompatible case immediately before allocating any
> structure. And there can be another errno than EOPNOTSUPP.
>=20

Okay. Make sense.
