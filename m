Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B3131DF270;
	Thu, 12 Jun 2025 08:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749715957; cv=fail; b=GQRI3HER/5F/bIl+gKqpuB3g8bneWY42crmFvsKJS6yeCBYMozYRk3vUmg9RSA5g3WiLD1rQoLU0+5pcDOAWya/YEliyeu/SmpqQAlHHiA5qHbcss2MLO+BkPsD3EQLEbkKrE//OPAn77Mef6PoE7q18UFJG44shQhfh+K4KeZo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749715957; c=relaxed/simple;
	bh=Fjg5+jW0Nx/Hvij+nyJ9LPd93aUMiA9ELJyzr6kTvLY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=X8GW0RxGYxyCv+2MUCUP4093y1RAcju8Lzu0UNCHwUAtoj64u4A4DoCBKetquLbiq7gMPBiMEFLmKk/vplHthEKZyz9YsVE8b5TNjMK943+KivLLQQxUidcYHESE2QC1LfQVQyI9rri5q3GravFNJSN2Kr1Gw9Nq4g0yyLgA5CQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OXfzIzkM; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OXfzIzkM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749715957; x=1781251957;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Fjg5+jW0Nx/Hvij+nyJ9LPd93aUMiA9ELJyzr6kTvLY=;
  b=OXfzIzkM4w45vx05jCU+0KR8ioZu7Q5VDMhgmEcaZvVoW1Ip7VoUymxw
   gAsUv/jx84jCEnZHPljzEBJ1Od/q12b5ylresmbNGMQgidhNAfZCfLWxE
   OQNDoYKW8k7tDxNJQMh+K/9YsybiUqjQ+xv+IIukuxpVFcHVq1lH+2av4
   EmVXvka3DUnpfN0iO31VhI5BVe2w++jSz1WwSxSw2Swjg07CqEaizP0nk
   D0mJMzegcpC6lnmmC0ZgTVIRqypyUu6tNOKgZWTUCPpG28D/m39SgLST2
   oH1uZMCBKrDDHJeDEvWbm0Kkm9giCCoc99HlJFe9UoyATnGVBKi58x5mI
   w==;
X-CSE-ConnectionGUID: CvrRyGk2Q8u4ElQuyQDM3A==
X-CSE-MsgGUID: Y+bCMoX0QUWs5dtbFGTsUg==
X-IronPort-AV: E=McAfee;i="6800,10657,11461"; a="62922099"
X-IronPort-AV: E=Sophos;i="6.16,230,1744095600"; 
   d="scan'208";a="62922099"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 01:12:34 -0700
X-CSE-ConnectionGUID: Go+FevC3RQS7J+9IVDj1iw==
X-CSE-MsgGUID: IyS6LgLzTPa1rl13QG3BZw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,230,1744095600"; 
   d="scan'208";a="178414599"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 01:12:32 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 12 Jun 2025 01:12:32 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 12 Jun 2025 01:12:32 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (40.107.100.59)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 12 Jun 2025 01:12:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YWTarqLLLAxzo1FFJKjZYpL3EwVUG08Uu8dgo/lYCHNPeRsIRFHKgq1xyuCcOs56P06Nx74VKUoMbqj/ssg31vXIka+gkVh9mbuoViwhDRMxInSbcoDDUoawQWOKRz/YRma8Y+TzJEE7cP+tLzVHt/xjcnuJpvaqv1Q05yA9VZ/tPet1NEdTKUKZyty0GecAlSaLEnnWX1/hHGUsI9V+fq5ugf5gx4yLdaz8vuOrWxhd1XCQJHBo7Beyx8Y0x2GKX8RzAE80QIG8dRxO+tWwKI4BBWaCxdMV14VE8lSWqM/jedldIVXI4FFwauJkvsW/M5vsTqFT9O+Yjbeo5+CbXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=crKxpoz7CHRm84nDsAjhbTUxP4cSRwwQ1J9qaJ9f0rM=;
 b=rNFFq69YTI3Kxf/qo+ZOxAh4PNEs8loelI+x8WZPivgWlullH/zsdevdJ0K/RwY8PtexpjPr78U/wjoU3nY5dJ2hTOek2mO6Whv0QpPGnMQhH86BKD5fA+TpJanr3IAw9GqtssDLQsgRbUpm5XEwIiOT/JK7684O6AEDvzyXxEHuVHmkuDAqRj+xrH91qFtsth++/o3p4LrTD0Nff8wfN3Vy5N46kFvd58kYbkv73CY2ef01MneVWpJOmVavMR8L03qbsov4W8nnHjVoU8qVoVNbxXaaofmg0sq0mWBB1mEzqb1Lb63fl2H5NFulsPq52bcS+R5FK6QbseQBfnCupg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MW4PR11MB5936.namprd11.prod.outlook.com (2603:10b6:303:16b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.19; Thu, 12 Jun
 2025 08:12:29 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%4]) with mapi id 15.20.8835.018; Thu, 12 Jun 2025
 08:12:29 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Nicolin Chen <nicolinc@nvidia.com>, "jgg@nvidia.com" <jgg@nvidia.com>
CC: "will@kernel.org" <will@kernel.org>, "robin.murphy@arm.com"
	<robin.murphy@arm.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"ddutile@redhat.com" <ddutile@redhat.com>, "Liu, Yi L" <yi.l.liu@intel.com>,
	"peterz@infradead.org" <peterz@infradead.org>, "jsnitsel@redhat.com"
	<jsnitsel@redhat.com>, "praan@google.com" <praan@google.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>
Subject: RE: [PATCH v1 05/12] iommu: Introduce get_viommu_size and viommu_init
 ops
Thread-Topic: [PATCH v1 05/12] iommu: Introduce get_viommu_size and
 viommu_init ops
Thread-Index: AQHb2WH5pFGoF+3KtUmvezY7edKsjLP/MHUw
Date: Thu, 12 Jun 2025 08:12:29 +0000
Message-ID: <BN9PR11MB5276F17940D4B219D5B4F4BC8C74A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <cover.1749488870.git.nicolinc@nvidia.com>
 <bc2c57254c40028e4dc74f32ac350826a26b3d8c.1749488870.git.nicolinc@nvidia.com>
In-Reply-To: <bc2c57254c40028e4dc74f32ac350826a26b3d8c.1749488870.git.nicolinc@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|MW4PR11MB5936:EE_
x-ms-office365-filtering-correlation-id: 096ab60a-e097-4cfb-a689-08dda988e034
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?SsRAZ9/bHkVPMz2kayTgMlTThp5GP4sIVlzSQZ62yerSia/85CZuQim4bROI?=
 =?us-ascii?Q?gjgP0SN3DriC27SWbkJs4uUn2oT4mnztoZQJabQcMwKVIkTZBHbaNNHW+d/B?=
 =?us-ascii?Q?Rm64Hq6HSaS+n2ttEwN9xm1TMTqYYM/EHv1drXXSY7ZRBcCMvG0bRL/7m3/y?=
 =?us-ascii?Q?XXxS8MGdTICrGDkOS9KAhZZ4HVARmssuliGrVvz8rRiyieKGdEk7C3qUKcM4?=
 =?us-ascii?Q?xYpDFkA0KAOME3Y7LhrkGZygJ+ovEyBA8tYmU5UWsuDOYt8+qUyuHP9Ptt9O?=
 =?us-ascii?Q?+O0RWNNOVN6BF2e614jO0Fxz3mTebyErBXVyW96kU1dwJNxPTeibZ3Re++Rs?=
 =?us-ascii?Q?FDrRLnm7/plh2NkpBkcttmB5BjidvEcn5qpOpfDD5f12PFKrRfl/ZRoQwXeC?=
 =?us-ascii?Q?tKP7fvRvwqC38H2jaBEYxGMltGWz4Yy8R6j6Xz+mQ3iMuT66UEResJQNnjPg?=
 =?us-ascii?Q?FS/jvmT5UVvo15S1V+X4AnZDhMfFuZ7kNOGWAWiEyd5jqs6CCt/yRAMO2xns?=
 =?us-ascii?Q?ix+HQdVV+PZzWo5rd9HgUIRrHrm+UQpMz2t868EnmG6EOerD2odPub4/EAos?=
 =?us-ascii?Q?G2y5zyR0/LWwEe8/0HG13IFFlr1mRnJEWxOaMXiWeW+GDq4sUnmovF+hMbdA?=
 =?us-ascii?Q?5wlBtxZAoXV42FuNblrJuZhGQvFm2fwXt5xGS5w64qXQ67tu0pjnAqR/ZVHs?=
 =?us-ascii?Q?Ed1YFVq5WauUWvQCZ5MRZzZrReSJiTNsyouYexsTU52jQ8GI5WQwiMVups6j?=
 =?us-ascii?Q?H32dPj9P2Gb98jnEyrB9EL+hcYR3xG34SpYYU944KUfnemvfclkhcipKwZn1?=
 =?us-ascii?Q?lAGxXviT8oNhyge1fKUDslf5G0qeeX9DjZFfJ9/GVTKHAOk7uLLq4Yt+RRdI?=
 =?us-ascii?Q?1upo/e784oBJbLGKAtncD4PzTS24A59QrGIT1HpCwt/dCLjFa7pc9JH7yPL9?=
 =?us-ascii?Q?smtt3/XCTdEOiD3Fv2reN0j1/twOhbfOVDUfLkUEWyFN3+ZPB8vrfcXZzAAN?=
 =?us-ascii?Q?D/gJixXY4dHHYs/B1Z2uodsYhINSptrivF5GfhkwDIzC0Z93ifX3peXndj5Y?=
 =?us-ascii?Q?izMnKDSsGYjtgRZgrRqOFNlSjN5Bkj2E6opUeSgRy2vPczoV7rEjnRw+STpU?=
 =?us-ascii?Q?owfHMgwsQEoEpHLRvIeiuXXCBrjZj3ex83pUnT0R8HlwI5sil6gz7GNmNQwN?=
 =?us-ascii?Q?Ns2Mn9iDDoiaa1lmr38GeZHIatuYQsL+1vWd24K0puc1m/dF4SnKDA3+kFRC?=
 =?us-ascii?Q?wNLI9C0qUdp3HG3w7oOn99GBgJgEFrGaFP4R1dVDwk7ZN/+fESzXaYcPhBUI?=
 =?us-ascii?Q?smWw7eh4b4jsdZBbQ2dgyLQUmz6htW3WTgYvdEjHxh3Bv/7WSkMNT/18ZQyH?=
 =?us-ascii?Q?iEWLME9azzKT05rfSq0p3MZkmA92QPo4gKSr/m7EXxypOOYGjbAZOWqUfuBY?=
 =?us-ascii?Q?hlbEoNPHRdbzqPy3vxJ01sXSG+f6Two0N3QQ/dfD3G2IGBl6v6ByNg=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?oficLaKVF1+3hnlHirt5fm6QtZi3hfnvMhVrnVd04IEx95Z+p9DCPREpxhb9?=
 =?us-ascii?Q?XvI0jf/sl/gYcegyXEYf13BnOOmxNr6KaYOImebKgSdGCndL59YSVX5YxuiH?=
 =?us-ascii?Q?U++rqGOiqhO5oHP0mZSfObM5EIjN7BiA/cNFvqEDwCIsbSlEJMH1H3ORwzub?=
 =?us-ascii?Q?7nb21sVdefCHp4sycIPOjoOG/qnbs7unX3e6dlXBn9T2IEwKalqWUOvyMfce?=
 =?us-ascii?Q?utN2DXGf0QCy7VubggbSw29KW7EKUAXZ41CNSpooQ4H/oBWzglCRxVm5bNAi?=
 =?us-ascii?Q?LqdtoGbD8Dih/rGSjM2iRBavRGlKA0OQOO8hYOTnUb21+zDoMrudBE3DE+VO?=
 =?us-ascii?Q?1ith9rmPfRsOvo6GH21hf0Uby0+dH+/RRYlZaaeCYLQim/Desrf3rZu1IumZ?=
 =?us-ascii?Q?aCgjcQUpRPNpb46IK5ytD6Qr9XgYkd0BC3YdFv6Id4WcOAZ761TYfpVdRCZH?=
 =?us-ascii?Q?6XZZImjR/XdiwiBc3n8cyP9ymaM1Xyh+pysZx3zJ4xOXk2TVLUiBHgkOKD4o?=
 =?us-ascii?Q?v8w6mzPwGGu7S1TyhAtWcrs/0nnot392qOXb5zP1sYt+giXmzY9NswuFm13w?=
 =?us-ascii?Q?LIqMVj2S9WLFirNCR72gwSWTrCjhaaYO3aDcesRs7CK5MlgkEBF6/6YWn/hB?=
 =?us-ascii?Q?B7oGBY0qZBnPMYsQDBIXFq83kWNrIrS76BjIgTEEwicTJHGgLRjfjFc3WG0N?=
 =?us-ascii?Q?tc+wW4pc+uAoN2Sx4MoRyc0H+uo0ZoK8lJtubPqaIrHYIejEOulwrRQkGu/n?=
 =?us-ascii?Q?bOw0xz71wUBftJIvXzoO3OnFWq02PRaUXa0kDUYhBv3AiwXtnPnP9kSIEFX9?=
 =?us-ascii?Q?ZMx0DZvWguPw9NGGNi27Mg3zIcLrz0wLXz3TcIcoarlaZzssLxIZ3u7bh1i2?=
 =?us-ascii?Q?2i+HFglZWckkennUCWmdfds0ef1dIIHT2lXnWKFkEOdrsPc8jhjXKUaa+dmI?=
 =?us-ascii?Q?/vIur8jiZMOlfe8Za/orIp6kSODmtDQWHSOHanUyhZkrkp28hiVUMTKgWFP8?=
 =?us-ascii?Q?7f1iVHIhsTZeVZQYSowyf6MdWXYgt6ED1XsWBRN6QD9vlzOaoovVdBfnYxit?=
 =?us-ascii?Q?Jpiv1Dd+Z+9YsEuTYOZMU//lOT7N3uJCYJEfBLMw7zBJSXmtIU36NjL6p2YJ?=
 =?us-ascii?Q?ziFqrhtye8zBggn2Cb+tcygejV3V09axm+mKw1RQkmxRFlfHm+MTFyKBgU6q?=
 =?us-ascii?Q?VMIrLD/dAXgMJYvQX5OoCHDrsoI9bTBNhPbV+onHsaofGU6j7rqnVXHMC4t5?=
 =?us-ascii?Q?ajciVxjBSjYWqCW3QVdg96KqKTtaRQGwNaCMuesBg9yuaIwdWEDesEK6LC8N?=
 =?us-ascii?Q?sZQgreRbZC+RykWocBMP7mIncI8RzKSn2Eu8Megoa1DGj+QWS9u4ccu2IUec?=
 =?us-ascii?Q?U7NgKmsH5fJTIvhSBsE4sCJNMVZ66GZOARPFuoX2ipEI4gZpKRKgB+MbdPsy?=
 =?us-ascii?Q?MqWY61oHhhdOzbrJXY7ue4sD99tYIvFE+60kLbOXii6+UGx/p7a9ps0XnG9S?=
 =?us-ascii?Q?gH/x/lAX1LNMs/GigcHiZRlam7OZSFacuAOxpDS4JcLVfRp267cKN/g/g1/i?=
 =?us-ascii?Q?gUozWe0PpPk8vfSzjxrRLiT8lTl7U2KIDPh0hAsS?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 096ab60a-e097-4cfb-a689-08dda988e034
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2025 08:12:29.8644
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /uZBAQXaapbHzdFBEPubi45vHwBxT4h0L7cgggNL8HmpzQyvQq2kNDS8QDkOICvMMTukEey2nv5o5axpfISQGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5936
X-OriginatorOrg: intel.com

> From: Nicolin Chen <nicolinc@nvidia.com>
> Sent: Tuesday, June 10, 2025 1:13 AM
> + * @get_viommu_size: Get the size of a driver-level vIOMMU structure for=
 a
> given
> + *                   @dev corresponding to @viommu_type. Driver should r=
eturn
> an
> + *                   errno if vIOMMU isn't supported accordingly. It is =
required
> + *                   for driver to use the VIOMMU_STRUCT_SIZE macro to s=
anitize
> + *                   a driver-level vIOMMU structure related to the core=
 one

What about returning size with '0' indicating NOSUPPORT?=20
