Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 979751EA7CE;
	Thu, 15 Jan 2026 06:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768457871; cv=fail; b=kP7aHL3QR9A7GWs8EoEvDweiTBiNh/ABXbqgiYy6xpqal9L1U1GTr9ExQYxJFjlgOiQXkkSzy458FT4B4Q+fpWjTLmVZB+gXEAQoYz61iVPZB0weRIKOzljKvedMA2rnl1VzzJ4MAFzTLjhC08XPlT2EoC+GK+vdq3vK1TsLWE0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768457871; c=relaxed/simple;
	bh=/yUW3jhrx63AJ8l/Pfmr9oHxUZHO3xClAlnJh7vfHR8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RSHjRnDpaDkktV1Wn7H0Yk7Lwq3u154C+QExBE5LXI5piipOGkYInAIAMjl1aArrTdJyjOXMaFzNtm8zP4/LzIqFUd4KQyNwu0lah/3PWfPQSrL0W18AOqIDN5RPB/UUJ+0zlhG7ijOEkSUXbbQKo4FrM3K4fL6m1l4Oqzk+D3o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EYNAU46n; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EYNAU46n"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768457870; x=1799993870;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/yUW3jhrx63AJ8l/Pfmr9oHxUZHO3xClAlnJh7vfHR8=;
  b=EYNAU46nci2HGVIuCW4MBwCDrm3TWY5+7O+yzA91IRAUn1BV7SukNmug
   1jG+RVAYXHXLQZGddP+PG3Fv4AJvlfWEUS75aXBuSaSg0LSqrRwUsg5SE
   ZUgWILZao+ARUD6PNVwZtiFhufw1nqSPEBPcBQ/ZAleGlbzFCg4Yij7/V
   +VuFNQGusBUeXu/ntB/3O6Zutb6uFKLEZQfBz63dEMMCrFSzEmes+dLw5
   KJjh0KUtfnywh9UpNFwEGgQIIMLiXrXaoNXTiwv9JrJtSRDvJNh6c+ccW
   5RWPN/3ezL0i0juJkjTwdpCvuRI39HLvo1bzwh9trPJZNel/THK1Q6TMU
   w==;
X-CSE-ConnectionGUID: bOMQoexETUyL9ZznafZPyw==
X-CSE-MsgGUID: mwwTF/o1QnuTQTVmRwY9QA==
X-IronPort-AV: E=McAfee;i="6800,10657,11671"; a="73602606"
X-IronPort-AV: E=Sophos;i="6.21,226,1763452800"; 
   d="scan'208";a="73602606"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 22:17:50 -0800
X-CSE-ConnectionGUID: Fd51JTjjRcGw5bMIcCdyYQ==
X-CSE-MsgGUID: xPQt/E9pSZ+4RHqhxMcHNQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,226,1763452800"; 
   d="scan'208";a="205288553"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 22:17:49 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 14 Jan 2026 22:17:48 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Wed, 14 Jan 2026 22:17:48 -0800
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.37) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 14 Jan 2026 22:17:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uFJfKnRsDmlfiFOSxKywK42tDa/LLsAQaxMMtTaPpPn89c2s7V7nsdy6AarG+SNpvvDgk72aU9+/DSUmVqsfrm6j2JH0rJN93tub6L1eypfldn774NnRy16Hbkx/2wrRLDbfggnE3xrzWQAjbw/6Q6i4y7Y8By99c3aJicGPpSTCcI8gncBjVx0WzTm4m83P+w72euGMzRVgSHQGcJ52m5yGAW9bWTMnN/x9RdE5Tt0AhtNEGUtaay5s3kkHVLOwG88uCsMnGGuP3Muirv3GkfJdHn0E9HnhRhhQPFCVonQsRRzp+/HOg7bl/ET+GA7Xg9yriEbLyxMfqLbW507epA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/yUW3jhrx63AJ8l/Pfmr9oHxUZHO3xClAlnJh7vfHR8=;
 b=ugB8sZtjceKClNDEa6AhE8/M+wbVc8o8IT3TtNM52nBBmpCbd5lkakxOuklBqADMmPoIIUY447+4DlVQ8tsto35CZx+Z61jxYQml3zFNBTaLZ82L8czRP6HnRs8bp3D7mok4sS8KIMoMzuuu+NO0xrq+xLpiffHXVTnRBtG+PNTq/Hna4RFsAM865TCVWC7qT0EM9ao4vJBos+4JE924FT4gOwtmIFO0WQmI91uzyTcDKB6itj1lL3JXud/hLwisAlkeFGvqgKoXZsoO14meBfL3p/Rv2swElry0updoJ6ZViC7TkfP8opKMaX4e7ivaX6WIpL1ZV+HiAL0wROEJBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by IA4PR11MB9229.namprd11.prod.outlook.com (2603:10b6:208:563::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Thu, 15 Jan
 2026 06:17:46 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::f997:762f:f079:134f]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::f997:762f:f079:134f%5]) with mapi id 15.20.9520.003; Thu, 15 Jan 2026
 06:17:46 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>, Robin Murphy
	<robin.murphy@arm.com>, Will Deacon <will@kernel.org>
CC: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, Joerg Roedel
	<joerg.roedel@amd.com>, lkp <lkp@intel.com>, Pasha Tatashin
	<pasha.tatashin@soleen.com>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>, Samiullah Khawaja <skhawaja@google.com>
Subject: RE: [PATCH 2/3] iommupt: Directly call iommupt's unmap_range()
Thread-Topic: [PATCH 2/3] iommupt: Directly call iommupt's unmap_range()
Thread-Index: AQHcg9KmJ6jB22rmmkKlMwcqOUjQ8LVSxZpw
Date: Thu, 15 Jan 2026 06:17:46 +0000
Message-ID: <BN9PR11MB52765ECB49FEC34D3FCDCF658C8CA@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-d7be57da596d+3f8c0-iommpt_map_direct_jgg@nvidia.com>
 <2-v1-d7be57da596d+3f8c0-iommpt_map_direct_jgg@nvidia.com>
In-Reply-To: <2-v1-d7be57da596d+3f8c0-iommpt_map_direct_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|IA4PR11MB9229:EE_
x-ms-office365-filtering-correlation-id: a3485e6d-9934-40eb-561a-08de53fdcd12
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|7416014|1800799024|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?87VDZblxSTtszafsrxtNSbetbN3s9UyQnjRw5CfuWFE+IADEYWHywTWxLtsh?=
 =?us-ascii?Q?8KczgXauCTbwKKpA4KW9pgQXkVWZ8ooQ0ugTIpECU5JoUAN3EaQkP5egKZC1?=
 =?us-ascii?Q?MZquIrIs9e4YZtKdnqeqOVMdyxEneWli72BzwUwdNKDfwCXvMT8eO2brst45?=
 =?us-ascii?Q?kblkE/cvmLYFxA92IAg6cWvrZ+5erll0fQ85TNC1J+b+PLHB3JCHrKQn4Nd9?=
 =?us-ascii?Q?mMAdB7K3QLQSrYiRHnDiB14Av/v6kXKC5aXFaIzOGk30ocRO3eWTIRrwOKmx?=
 =?us-ascii?Q?1VOZowd+PW9uQ6fg8CUO/ACARDDfayEaOsrXXUEhRQtQDblHsbhhpoKHAjWk?=
 =?us-ascii?Q?1deuDZ+etbr5EP18e88AguaswUZ8Dccyl7fkPXsvxoDlI1cZSx66JlEOcbG/?=
 =?us-ascii?Q?wgn21pM3wNLiPdoRusphE5avKgdO3UOA8hR8ZVUbv25JlbMOPSvQMf6ufP7V?=
 =?us-ascii?Q?s8hDoYS5UbykaZEivdbma0Ni7eXYBtsO7aMYp+YeotrO5lvDcRSBvIvIEJrp?=
 =?us-ascii?Q?itrz4Y1LAeaXdgzXFRjF+vP9FMdObTkAcu2TRMEUutjJs42XjeE0I84USaVK?=
 =?us-ascii?Q?knrXbXuV+7hfTcmxUvDSxAby2MrkwYuG1IeYgPBmW0lAblrTS/8VqjGq0vBk?=
 =?us-ascii?Q?2XJhQyW6/Op1NkVT5oJK4GDAAX3X5NKsxN2UHKORBhZkt9AwWAnrqunon45K?=
 =?us-ascii?Q?5FrowOmUp6aVIGTcNv+whxvq0UNs/Fl22t5leoNMtZ6sClzktZrlNm3koD9o?=
 =?us-ascii?Q?SeEBKQvdw53aIeI/DS5ag88MDZAsnaZ/n0DMITI+nFOgJDS9u2d82wFBRTRT?=
 =?us-ascii?Q?lCqt7MdDl33N8A0nTUJv2ZB5dbrrIg6fW4FizMiMfoTrra2hInf/4xy105Sk?=
 =?us-ascii?Q?lnM1NzPXKPgv6l+psVYfWWm5GUq5KdzBajH+l4/ZyqCEC84liuYZZctO1T2j?=
 =?us-ascii?Q?e5U7BAOmALOaibHW9LqlU7m8596Yyhouk1RxThIG6ZA4ZFiCn26C99TdFKlT?=
 =?us-ascii?Q?Zex9e1+4pGOA/FuCxTfROAAvBm0XGksYxjIi/2X5Cvaing9dq3S1hAl5u5tt?=
 =?us-ascii?Q?1UosZC8uJSYC6FvpntGYdxDJmPi4K8VEyVtdVADj/Q51CIbh4Al+/lCthchU?=
 =?us-ascii?Q?tHwrK4gZj677Mv7AkSt1OhIf+EprejVLvY3O5v2xjq7NyVz6oN3pFWgQ9j6L?=
 =?us-ascii?Q?NiK7410WJ0XF6Bd3VTtr0t0cjyd4wcqdK74ZHKnbIPjDHBKEGNRsf/dQr5KW?=
 =?us-ascii?Q?9kIoXYUor8kmsSh5s64d+YIaPqfnVteSh6PRNBz4y+dhRBVRmU+2ssLy17hR?=
 =?us-ascii?Q?ncYIvHTLpQRtD9Oqyz7fptpeVcIFrlrKrzLn7LUE2Yo1nn5F0A74K40AMmgK?=
 =?us-ascii?Q?Sh5d9u2UpUJgIMWyawaArDcZxVktGm18JvYJGy+RYYto32N9jmqi7COkou67?=
 =?us-ascii?Q?9RzTVjrp/c6AU0wWEZo2qHOWaD9Q7DY3fVYJt1iwOO2Qvf+3eY9nyElscxnx?=
 =?us-ascii?Q?XOOVcxAwcFkAp3XTJmDXVS4CIh2IBHXETpCn/Pvnqd4AQJPA/jvtVyxQjhPa?=
 =?us-ascii?Q?iMbNjW+zDcOmW5RWUTu2ZzExgndhgZRn6ZHRR3cRzb2hgMXYcerh/9OGSVgN?=
 =?us-ascii?Q?2syDTeUsyZRWyiIUMylNGhA=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?VZ1Zvf/D8ezaiE4ANzgtE4B5u5LQakUuhSpu+p8hgBd/0XZLw/f+LNnJ+e+B?=
 =?us-ascii?Q?Pak/0ANa1tLyKPQ+9ClB2I1QUMOJoeSxHrE+sv7TrP8N8eFaK3oPWVIVm/Z/?=
 =?us-ascii?Q?D1kNUOnUjwr5chXdZF8wfOC7SQpzOhhInl25cir2VSOPBCxdWmpTi5TMC7jM?=
 =?us-ascii?Q?xMUYlvmONicpE/+kFQYUOdfyJiuoyas+HDh3BEoM9alQ0zySEa0rdV5fIVgD?=
 =?us-ascii?Q?yvDIVh4JrXLtd0+N7XUEojhXl0QiUK3PF2C5R+mA97SY32J0qaWVpGdOkV32?=
 =?us-ascii?Q?aXQPzkYf7JTvNpV7waGvGD7AJ7wAA/00aqCk6j32Nn/5sZB5XCF6FWA8akOP?=
 =?us-ascii?Q?mDugf6oGnN/W61y+INDo9+cUF/5D1jKcOG2sShKWuCBBf/cnLBmdZUnrDymM?=
 =?us-ascii?Q?zkN6a5mOQ5C1zhFyfeJao+B88hGvXdCAy1TGNT4lAxGiOw/i9dafOCTTlWmD?=
 =?us-ascii?Q?qwWbQqsGyKdVPImf/r4U8/Sw4CbDFy+dasg7CyTrE1r1Laq6yXNWzAdDy633?=
 =?us-ascii?Q?OtZvjcI8vPCESxAhzoE/YIRAC2OEMN8mzHgdJ30HYZ5ncRtNECbp8HLjNbEW?=
 =?us-ascii?Q?exY6qangnPg3IXlTzkjKtVjr0z2c+x3KBPSknKTTfVacb/xttXHA6ICA/5gz?=
 =?us-ascii?Q?dGsBkA6/pVdi6kMYhWl3a8IrOnwJJksUp/KT9F8FpHHBINbilS07snZ9MEB3?=
 =?us-ascii?Q?e+3ZBZvDtvHeWc2jr3O5SWuW1ptUHfK3iish/fd46J8ZNQbOVZzvudUdIhYa?=
 =?us-ascii?Q?ND++qRag1vBhixKUb7AA3F5lcSGLsnLbnGNWqdLSR4UTBXu0V7ersMd61BXX?=
 =?us-ascii?Q?Llb2lkxT4bkYLiN1XkXnSdcaZQps7M7D9lU3nZuD47mC6ZFVbyCeJr4HlPcu?=
 =?us-ascii?Q?WoiRoTn4dR9TcQfnlr+yBSL2H+3t0q8P5X4pZW7lPAZ/+vhh4qMQgh6VMGxD?=
 =?us-ascii?Q?870/h7MGm5Cs2gyCAfnV3pO2YeGvZNA2ptVt0RkSlMwMTX9cM7AkNTJado0Y?=
 =?us-ascii?Q?OM4kuUMVcenNyfJorHeOG/lNMfD1jEF5CD8TGzLyckAcyRfkyQEPTIMUHnIg?=
 =?us-ascii?Q?rq59Xmi9GRfyGQdDdyCXxHloIDCClOBu0qvZYjaSnDVVSNJrGNKPN4BGpiv4?=
 =?us-ascii?Q?00jquS/A9MEzPwKxCbwgiPFgOCNY5riSCuUthVg3mWqIZZLvZbjMXa9Sje8z?=
 =?us-ascii?Q?ZGlDl/MH7G0AQqtEe0xU97BKBQgIGdpALs+4WoL3HiQDZ6BgLcxUN41iDhsL?=
 =?us-ascii?Q?L4PRNEIFj6AiCQzhizxJFQa0O3N8ZIHFV4DYZmpOS7YuyV9CiJTz7TwjlSy1?=
 =?us-ascii?Q?QuVECiKJK4o4RzZMnZWXjIpDQT4ekfpWRG/8rm3S6YwHbPuTLDEe5cY4CACo?=
 =?us-ascii?Q?Fsgzs3dge6qJaDD1pz55wtTf/PtOQrv0rkGWJ2osdoH0rZPrEjD3f3J8cpA5?=
 =?us-ascii?Q?VJRWzbsTSCSSGzoCjoxREA0qk4m9eyrOlhnA9p0RjHWJvugzIL7JPunuWIzq?=
 =?us-ascii?Q?EQrB06Dp92ztZHIDfC9PBm6J6iU1ONBs94lV473KQNkf7FWzbTfBiGmIYOrB?=
 =?us-ascii?Q?1tT5lo5QAhAKm9pj4zAFs0kPs6moZGceUFeoZ8Xf8o0jqxoclPBjxrI9ObL+?=
 =?us-ascii?Q?6Ukvec7MmE84D2gI/BlSIse3hYeLJSW6A43Q959r7lNelhOG2m7wefOyZyrZ?=
 =?us-ascii?Q?mfAUXZbO4azV1tKHsXmGcV6uTIpqT2HcdLxmKPZRwgn1h5sjzzHKZkwat/wB?=
 =?us-ascii?Q?AfgP0my62g=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: a3485e6d-9934-40eb-561a-08de53fdcd12
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2026 06:17:46.4937
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rfsJesDOe3RUd1mV0nA16qTfQL4pxSl5QDOp30Mh90zsKFbBu4RB0oLceOllUCmlpYK4fjsrPNA8FQ1ekc1CnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB9229
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Monday, January 12, 2026 10:49 PM
>=20
> The common algorithm in iommupt does not require the iommu_pgsize()
> calculations, it can directly unmap any arbitrary range. Add a new functi=
on
> pointer to directly call an iommupt unmap_range op and make
> __iommu_unmap() call it directly.
>=20
> Gives about a 5% gain on single page unmappings.
>=20
> The function pointer is run through pt_iommu_ops instead of
> iommu_domain_ops to discourage using it outside iommupt. All drivers with
> their own page tables should continue to use the simplified
> map/unmap_pages() style interfaces.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
