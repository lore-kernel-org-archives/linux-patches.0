Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E259F21D3F2;
	Thu, 18 Dec 2025 06:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766040476; cv=fail; b=aZF67pTFH5+FKfudcZt71imzq8WKRmH8FdtCXNQO577eiNYlTJUF/SGlfwAbslKqplXOpUhqdHHZBkdL9xo2esFYKBj9G0Zq/XTi8TJhOxQt2c4NECQ/v5iRE7oOl1miIP2shorJQPVnsfBfWl+w0JVTJXtUtdy770XsrfvkfTk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766040476; c=relaxed/simple;
	bh=IiHhm7MjJw3qaj6ZbVj2f9jKWdS8Zgj7iW8/WbyHLME=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JkAe77mhSsa05JAEySysb8oClQNgXGZ3WVXJNt2/af3JMT+HMm4VKFdZxEXewqLiErDp6ZkD/vy+J2s3YFUrYIzEU3oTtx2DaIZHTmwLgn9o72ZAhr5M5Hz9xgagFh6kp2yeVAhzHloTBWfF0RVHRU9G3lfPVYYhoG270ALWw+M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BRw1Ckeq; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BRw1Ckeq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766040475; x=1797576475;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=IiHhm7MjJw3qaj6ZbVj2f9jKWdS8Zgj7iW8/WbyHLME=;
  b=BRw1CkeqADDszuyth5ub86WOm1mjyuyn4O5vZrn5jUCKVGYSo0NgZVt2
   VMaCcFI8gRRnQEv5Yqh4hwFjLxA9i4iTxLthxP36E27L0uAAvoDNkkkOm
   2kLIvT/gmwRuq4FfWKLgIdRjxQsRo2uJnDahlPWY6PIiLjB1Hy6EiM0eh
   KAa5maPJ4TdQZXC96lES98PQfSx0CD/L5cF9GC9ASZrP4m3DP3cFRhPky
   ndwnwOYlX7/3ErfGatzyogPwHuI7nmSvYpEm3hBbnl56iT0ug7O5yDvgx
   UnQabGL+51272uu0K2uH478VNk9Cmb0HsPPk7mnxdhXzv5eY6CcKAicpF
   A==;
X-CSE-ConnectionGUID: 93F0OR+hR3SkMrsM8NjuAg==
X-CSE-MsgGUID: 1aa6TWikTPaNnDu31n+v1w==
X-IronPort-AV: E=McAfee;i="6800,10657,11645"; a="68059680"
X-IronPort-AV: E=Sophos;i="6.21,156,1763452800"; 
   d="scan'208";a="68059680"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2025 22:47:54 -0800
X-CSE-ConnectionGUID: YMeeZ2K3Q7Wt765rQWM16A==
X-CSE-MsgGUID: AmVqxBB2SGeBt7EyhoAlPw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,156,1763452800"; 
   d="scan'208";a="198984399"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2025 22:47:54 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 17 Dec 2025 22:47:53 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Wed, 17 Dec 2025 22:47:53 -0800
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.7) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 17 Dec 2025 22:47:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gyA5EQKghLBZDGXgTARM7tvwfeu6gPKarXD7RYNqdWKHGwp6aAJY8tmR0wa+tyabCyutDorKFSm2ZTtVR7UPcM6Fmv46fzhcI7VYTpTkBU7Z4O6ZBM2WoBNO5Z3sUs6F7E+IaJ6+uqd4ZawAQwYK3/e3Ekp141k1ZGpMHruubWu1NOHtXExXJC4hK9hN5b2cOWqtUQOWmD8gYWZQPUxtde/COu22RZ+q1hmhT2eB2WJI0v5aQB86DM2U/rB3A/wFdDa5zHZX1yb9sjGAwZC5tkc1KnBacsIAih0ZvwbV81CrBMJ7Z5ke0IRgOlVZilBM+t9hpmSyIvp7Bh6RS9Gibw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IiHhm7MjJw3qaj6ZbVj2f9jKWdS8Zgj7iW8/WbyHLME=;
 b=sXZnxMzw+fbdy98GIkRiLXre5ycnyilB0JIobWfh31YYUnBBxRrYRsvQAvM+5/o4mmyXyDxZDt5xIIR1sPNtQpJ17KSHluVdRmPdtTZGQvF710Yzzt0gUxbH/1p3RUDwcIGVg1n4h32F0D4GB0ZSZzkwJ3tlGL4XnFRMdjhHABnPFx8mxltiG1S6eg0niKW+15Ij0x4s72McTu+J5ll59Z2oZ1R2IryYVOesu8pg1oTOwPllLEUZkc8uvwC4uo5g0cATzS6/tDfds2C3HOT9dQas+pgfbgL5GxPcQ6fgsu6CHF7cA7RBF+DG6mPmQS4NaioRh/wv/qjVL811+KYjDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH3PPF76AA2D882.namprd11.prod.outlook.com (2603:10b6:518:1::d30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.8; Thu, 18 Dec
 2025 06:47:50 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.9434.001; Thu, 18 Dec 2025
 06:47:50 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>, Robin Murphy
	<robin.murphy@arm.com>, Will Deacon <will@kernel.org>
CC: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, Lu Baolu
	<baolu.lu@linux.intel.com>, Joerg Roedel <joerg.roedel@amd.com>, "Pasha
 Tatashin" <pasha.tatashin@soleen.com>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>, Samiullah Khawaja <skhawaja@google.com>,
	"syzbot+e06bb7478e687f235ad7@syzkaller.appspotmail.com"
	<syzbot+e06bb7478e687f235ad7@syzkaller.appspotmail.com>
Subject: RE: [PATCH rc] iommupt: Return ERR_PTR from _table_alloc()
Thread-Topic: [PATCH rc] iommupt: Return ERR_PTR from _table_alloc()
Thread-Index: AQHcb3ymXtktM6yvpESNknNOjLSjKLUm9S0g
Date: Thu, 18 Dec 2025 06:47:50 +0000
Message-ID: <BN9PR11MB5276B7037AE17E028022CE698CA8A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-5e883e102420+59d-iommupt_alloc_err_jgg@nvidia.com>
In-Reply-To: <0-v1-5e883e102420+59d-iommupt_alloc_err_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH3PPF76AA2D882:EE_
x-ms-office365-filtering-correlation-id: ef763a62-03d8-4242-8016-08de3e015ce8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?v/dKaJj2K1ISOsSQQkRyB+2gUlWQPwKGQenFhUK70djojz/1t6NUy0CUaYuH?=
 =?us-ascii?Q?GqBmdyJKtPr32bUAtBJMjPQXZJ6MEPlFfaGsTBBY7o7Q0N9FX/0cGLBhWLiS?=
 =?us-ascii?Q?D8ima2d7dmC0LY/w+l9mUIvt7QFKnZJTg5eRIgFdMah5HhZs2uH2GnKQtdA9?=
 =?us-ascii?Q?j3r1SMH6XzJhAeYHojDK+0aDInFEYl98V8HuBJ4TdKj2Qji7dcGh6+izcg2x?=
 =?us-ascii?Q?rEat89XuhzOSWm3uLROk0s+wc3FeU+OTkTeD0mv3Ow6zvyQzJsePaTz92t/V?=
 =?us-ascii?Q?2VJUEuDGb1wVjfbSFDB2tGz8dbiiKeZZVWkfJzJRPZoi+jvup99HPbyneDsv?=
 =?us-ascii?Q?1TJ6fYLevA0aSTqwq5tXo6+pYilRUivdfNB2YEl3+F/MF0wN0LQ2IyfHA3fC?=
 =?us-ascii?Q?ypz9RrjUxiW7Wp3VQ0ii4AeADhZ+MDjmEySna9Sndv9Za2rHGyUc0kR4wubL?=
 =?us-ascii?Q?0XZbY2/8r7FSBkEkT562reCVaPNakYeBdrH0hpYx8fGGY9XJIvDPq0rBJHm7?=
 =?us-ascii?Q?BMKhPKGkzRVV9jHg80Spau2M9vbjMoF/Pz10l9sCHJSX5eddFtf2+5kAameK?=
 =?us-ascii?Q?KqpaCIXbxzOUZVwKQxuvqWSU0M6DDqTeGsY63Xcg4IWFaeZ0wNFO4s0sl8VX?=
 =?us-ascii?Q?mCRg1Z5TP0jY86AHpLrxiiM2VGwD7BuIwJHNSHAoX7CqpZbTIvZP4jWmKPjZ?=
 =?us-ascii?Q?A3MTs4q9DmaIfg5XZfG8BuIiG0uqoU2BL0r/j9Ms3C9quP/4X8/zRqnz6xdb?=
 =?us-ascii?Q?aAX0tEX600cDTZVmtdd+iXXTachpEvEkFdM4f4ATXoMg+m+5HiUtOFr5c4i7?=
 =?us-ascii?Q?08JZ92xncXEn/a+QqimbdMR+b2i7OCpJtrv8XLvbaHg6q8DpoTDTgx/IvpXM?=
 =?us-ascii?Q?2f4LYtlzWdaosmQPQMT3Mc26WIVwTJHgW4Qx4xIf4edsuiM8+wlXnI16iWdB?=
 =?us-ascii?Q?PtTBFgQ1g3+60iwMRH0Q5YWMy3OphBEU0fXGMk5llId5SblJKG6dhSmYu+Kb?=
 =?us-ascii?Q?AzAG6CqmdZvDt5yzJn6TduNPA61/Pea2YevSof4IpuAttFYqrUtFq+ScaZ8M?=
 =?us-ascii?Q?IMxtSkl1GIk+ShIPTMl6iAs7fDQ1vYFbWsTMfv4AQK+HvXnRxOKyW7f5vrQU?=
 =?us-ascii?Q?hoDurKvReIXFCVV8Ay4GHR6dn/7VkKqupM8sChoya6OBaYIjMvNWiGM+Nxcb?=
 =?us-ascii?Q?kzMAHfdk1scXeJNm+WOQ0KUQIl2xRfV6vctVgu+TI8bPr2GDWEtyI8gNZRl/?=
 =?us-ascii?Q?TsK5iAXaojGU4cMwnYZtax7y814/aw/KJmcXq0LhMEX/zOYhzcFAxXFBaFeK?=
 =?us-ascii?Q?8EP9EseAzxEOLUArHMTA0O7NoIVRAT6Us4bsnJW3aEVvlFNCgIkWNB9q/EZU?=
 =?us-ascii?Q?VJNbw8Vw1sRFMhMHAzFBQBtDI4yhNIvt2b8tlMEqTgTCfrmXhcjqWfIKH/a1?=
 =?us-ascii?Q?flBCeiGvTpIs9OzVVFrgGJVwQZ8/++KdjExHbXFM47PXXLXViSUu65eCdzcp?=
 =?us-ascii?Q?geXbzV4xe9tjBeZiTcMUMH1uWvC1zvoJtRxB?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?4OMv9NtsNTFT+vSDZeKXlIPqk8nEZTzsL896R+ahz48Db81DbTvx8E7LDcDz?=
 =?us-ascii?Q?K86qnC6iFuuSahtnwX1I0fpCNc2JQqbOjF5oBlIWXtXhyTCbmu9xmk++rEs3?=
 =?us-ascii?Q?oBjwvYZPCQWHBA4z1QAe1466/pP029udXlz31OaNcAIfD+SOi31GMgtt3FAc?=
 =?us-ascii?Q?TfC80GN2AlO0++5Za+C/6JQFsMZto5jmM5s3PRUZ37b0wTdKYXi2v6OuH/Mg?=
 =?us-ascii?Q?wBfZTBRCTXae6Znai5iXV4qoYMaMtSQQxfDm/X3ale6OJ7hOOuuuQ29KCQcM?=
 =?us-ascii?Q?6gmfFv0YiiX2kF1Gw/BSGlOlS/KwlGwMwumpOMpR7beb8DgpiIJ83gpd2Yli?=
 =?us-ascii?Q?tG+8l1NkNggXqgtuyZcgFQ2T4kJVaWndxBeyCpCfIQepiIh16C1kjswY0Puh?=
 =?us-ascii?Q?uITHDU8rzAUMWRBMBt5NAkJ3gdIj9MK38Vtg/gk+qM2XYO9HvKqlOgSLlj9V?=
 =?us-ascii?Q?+RKoK8rG/RTMzvXV/0pWxnM/0BnjybncHNZTj2BCu6CDAd5CeH5jAsGv9aJS?=
 =?us-ascii?Q?ckY/AEHeH0eir9f/WkI913hz8lPjWsb22WreRu7sHUp6M4nZCGfHrVU/3cbr?=
 =?us-ascii?Q?mxcAwzijepC/b9ZYxrJTOTo4jPENobBT5y+njI6R6f2DFFIfxYCmGmyHmxxg?=
 =?us-ascii?Q?8na47E9OtHrqobjy4fh2FjuKzhLO5zhOSvJPlEihF3MQHRyOau0LyRc+Dq8N?=
 =?us-ascii?Q?jUkZEMwPkqCrfxWCD945LYgD2Ddcmuup+k7FjIoaDNPo+NxrpjfdPFRd3Z6w?=
 =?us-ascii?Q?Ea+c5DBCU3bF+goKL4YeaRTDt84woQ2HzllQRUtqQF6rh0+IUX/KAnQX63jW?=
 =?us-ascii?Q?gTx1wVr2rxaUNbIIZw4o5sYFQibYp6oIj8Rx7sHVSxLD/6KqFRjHoESUH695?=
 =?us-ascii?Q?2uc/FjpVl77Z3zmkmpFs5NjmkTLyLiBaKTzXTVq7p+PAG7xykxgxzR3LtqcY?=
 =?us-ascii?Q?ldYnep2DgQmLTaLPkalKTfjiQZuobTsDu7q/IckVQigiAAytnztaq0NuIVUy?=
 =?us-ascii?Q?eNFWIdq6+LBOrO5/BM+C0eejhphnXbPzfnoMk7RCq/PVQ6CHGbz/U0gktxEx?=
 =?us-ascii?Q?SCM+xDwW80OLzioSQCiyvNW7YMoK44+jCbWQCpQztRpM/NGv5xMOhLFTJ4xo?=
 =?us-ascii?Q?6camDsXV+wo9vjyUkFfrrd6H+2yAnO0EQmvZelE/geCi2LmzZ8iIlrxJaVad?=
 =?us-ascii?Q?vXdKaOtrIAD7pmKnGbvVt3ABGalE12s0Dg4ZrBegJiHue2M3ercef+DfdU/k?=
 =?us-ascii?Q?nMwSBAazobgyu1+i+/qw3wR0TbGSmGn/T5zehjA5LTiUSg2PXDDe9MYtFYrI?=
 =?us-ascii?Q?qLsyvxOk7iSGY/0VraP/KKYoohqNcR8ITcQ8WrtkAZbxXGNEBxeWiTCZ5eOV?=
 =?us-ascii?Q?ojUCtOdT+/kuPbcD+rERNEu4SY/CbVvI4b1x1yS6iTU9bwEBbf6aX5+Y+uAu?=
 =?us-ascii?Q?EX19hWLqGimkoYIQku0AC/aezFPsVD7sYsDdPh0YUJw0zLV7V7Qy/J/zp2GA?=
 =?us-ascii?Q?pesbkqWTsHcL0SyVauKQOSqkA4zGos2MwR2KYpfr8+cxjnyDsY4G2bjKrs84?=
 =?us-ascii?Q?s5E2HaeeNhwif6KhPMiWH49u7512fSHgmNkobh0I?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: ef763a62-03d8-4242-8016-08de3e015ce8
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Dec 2025 06:47:50.7235
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OlxL3fXgfmIm3uPGDfILjV8NwanFjMBTEqVz/lrdJvQXvSi7P/oDHCLKn3884c6WN4trZnPCUH20MPrbtfwTKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF76AA2D882
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, December 18, 2025 1:43 AM
>=20
> syzkaller noticed that with fault injection a failure inside
> iommu_alloc_pages_node_sz() oops's in PT_FEAT_DMA_INCOHERENT
> because it goes
> on to make NULL incoherent. Closer inspection shows the return value has
> become confused, the alloc routines on the iommupt side expect ERR_PTR
> while
> iommu_alloc_pages_node_sz() returns NULL.
>=20
> Error out early to fix both issues.
>=20
> Fixes: aefd967dab64 ("iommupt: Use the incoherent start/stop functions fo=
r
> PT_FEAT_DMA_INCOHERENT")
> Fixes: dcd6a011a8d5 ("iommupt: Add map_pages op")
> Fixes: cdb39d918579 ("iommupt: Add the basic structure of the iommu
> implementation")
> Reported-by: syzbot+e06bb7478e687f235ad7@syzkaller.appspotmail.com
> Closes:
> https://lore.kernel.org/all/693a39de.050a0220.4004e.02ce.GAE@google.co
> m/
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
