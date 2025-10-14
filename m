Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE3EA30E852;
	Tue, 14 Oct 2025 07:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760428572; cv=fail; b=T6GE841uDZUs9Kp6AEdKEm0Ah9IURlFLnQ3rvExOmxBaNJOPLF505dcL4/TyvgQc8z/JdyRT1kbHvnMLWBqcB0yASVOX3koCXaukf17m7+QKqq+h7hVi7uYS5PMsizJ709w17KyqlWkpcPS58w/zSpjRrpnLWF5Jwao8bv9TBrM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760428572; c=relaxed/simple;
	bh=LIxvJdENVWFJ/OGvbiysSCG9sXq+UKqTNX5cXhAawcQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cvz1rf6r3flbs5ze5FxyS6r3MmGETfVwSkgjbMwz91rNcNSaYZIUWqpA8biUuP/eUnfYz0l26AMix9i8F8uk/t8WESXKAH8ifiz11wtEPPtSDTRCW4iQlgp9H3YmgXubGgqd8QPOms/Db+OUIKuGiQl0b+6qJJ0+XNHgzzr0X1o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Du0u3gGK; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Du0u3gGK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760428570; x=1791964570;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=LIxvJdENVWFJ/OGvbiysSCG9sXq+UKqTNX5cXhAawcQ=;
  b=Du0u3gGKHTDwCaSYmyUH1RYXdsqxyeia+HqD/AjuaO3OegSzW+uZQUKV
   TTtoG1CnvC6dIPrFHZuuGvI6pGIpkc1jtqCdYyjcbk9rMADcO8Asq2RLN
   SYqWj9it2LazgxJ4gv1O8RjuKH/EaxSniBEz6mP/7K/J/sLYw+I8sKliq
   lHrqcBYOr9DLoRPSKSCVzcJoyzZvq9Ghv5k67rtQD94NpV8xQAATUDcf9
   ELI6rURX+VyJP3Ws52IWqBflRA1uh7M32pLI035vz+y79kJMGIMzgtPS9
   MA4J14pW/NpNrxKJEqU3tOuJAR03rK9iGCGrmJqt5KuSYwweKphWf2nPW
   A==;
X-CSE-ConnectionGUID: eso4/bD5TxCu+gGvWzCQGA==
X-CSE-MsgGUID: 6uHRblg6TKaalMQvv/0Ekg==
X-IronPort-AV: E=McAfee;i="6800,10657,11581"; a="61790996"
X-IronPort-AV: E=Sophos;i="6.19,227,1754982000"; 
   d="scan'208";a="61790996"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 00:56:07 -0700
X-CSE-ConnectionGUID: 3wSc4MUNTvWKO+BjODHnVg==
X-CSE-MsgGUID: jAqeiLqSQxWMZM+/mkPsXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,227,1754982000"; 
   d="scan'208";a="212787813"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 00:56:07 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 14 Oct 2025 00:56:05 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 14 Oct 2025 00:56:05 -0700
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.41)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 14 Oct 2025 00:56:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OZ4+nsFsbY6l26a3zVYhTScpu3bRR/3MTC2mugQR7gAIHakRvG8tupso1NXlAEv9GVbCuROLUWTcEp+sl2yV5w5A3wR90onICNUnw2W38/78MSIPKdZJ1OVAhOHa2hXVUxeRPzH7efJfG7dBjLJuAoYT5gLU/c8PJbMMZrJefwzevP+66SP02udjbUlMcRR5w7AF15A6kgwiOWcP+n0muiC2+EawWO029L1MGFMW5CQONYu2L/D7Mh8UuUb0YTxyFFyMYQF2KucoX0zJ6iSH2v6y0zWCIO8kL8zx6Bt+NkAicwtyS51xQg+m4Sk5lVhf9wS6vfo8i8Exzzk1zQnFLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=55uwg1JENOrn5ZwGcwkRldtFtorA/aicCrsYR0bqZ2Q=;
 b=FWIZLYkftfKeZum44rBASkIlh2S2CI6x/e4o/tfY8oICOu69SieN3jodf7UjxK8y1j2dAECX8w7u6ahedDiknvwzyrIg5P10hgN7xoQgfH6uOJV1qyQnW3N84N9RvVx+xzRw4i9FeRfxcSlPwYU4BtRfvUaY7dbjMnLtchllqK3nG/T7/0JhB5/X61FghahmXBfNZeUNBjafueQuvcbMDbs/sBKh27m+HTsbfw2SEkbM811isq2ozERKtm3sQys9Ztphm3F/yvoQdZ+NplxVqpEI3IQ707zDqI3C+sD04C3RoNSv1FJlOL6xqFF2N1F6IDQijS0a2gJACVOFawAB7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5271.namprd11.prod.outlook.com (2603:10b6:208:31a::21)
 by DS4PPF8ECAFAD61.namprd11.prod.outlook.com (2603:10b6:f:fc02::3a) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Tue, 14 Oct
 2025 07:55:58 +0000
Received: from BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::5616:a124:479a:5f2a]) by BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::5616:a124:479a:5f2a%6]) with mapi id 15.20.9228.009; Tue, 14 Oct 2025
 07:55:58 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>, Robin Murphy
	<robin.murphy@arm.com>, Will Deacon <will@kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>, Tina Zhang
	<tina.zhang@intel.com>, Wei Wang <wei.w.wang@intel.com>
Subject: RE: [PATCH v2 08/10] iommu/vt-d: Use the generic iommu page table
Thread-Topic: [PATCH v2 08/10] iommu/vt-d: Use the generic iommu page table
Thread-Index: AQHcFq6qAOOhTNuaG0WHwTe8bKiGvbTBkn/g
Date: Tue, 14 Oct 2025 07:55:58 +0000
Message-ID: <BL1PR11MB52713F20514F8C9F3AE9D1E58CEBA@BL1PR11MB5271.namprd11.prod.outlook.com>
References: <0-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
 <8-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
In-Reply-To: <8-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5271:EE_|DS4PPF8ECAFAD61:EE_
x-ms-office365-filtering-correlation-id: 73216117-3294-4e72-9312-08de0af71c9f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?RFw7u16C/RGEZ1BHwQyWolb/8wt6gBzD9IKBNcFNQ/wCMg84Kf623yRB6uTo?=
 =?us-ascii?Q?MHzwcwVxZmUXscVdG9qu5PXEeV1vmo/Pl5l4eBBh+KBC8WZvSvc7ScV0xoZz?=
 =?us-ascii?Q?7talVGML/XjE/cZ6+k2wSgm9lnU+ZiKmwA55q0UONB3BEShipoGdSE/ZC92w?=
 =?us-ascii?Q?yJ4pvYppV7wY+UV5AMerPvtdRQlANny3A8+z61PcFJFTb+e5fJSsmLdu8kKm?=
 =?us-ascii?Q?aTMC5iSaZel/jm9A/Xl5EKbFXeGkU5qcnklgi2PGgKHcwwTk/EPQpPonUn3p?=
 =?us-ascii?Q?wiGuhYS3NzUmSBvGlHeGfPE4C7ZvMDKya2G/d29v9W+6rEcbI1b249+5KQ9g?=
 =?us-ascii?Q?uQ5Yh/k+WeoRPrYZvT8CIvHgUH1DPo58Av/dfZlxwCx16Mvp39jVIQWq0PTL?=
 =?us-ascii?Q?u1XgnABzV6+wJF5XVCFHWT1lKWg3WCKHT760823Hff2V9qbR3vyP81AbYx64?=
 =?us-ascii?Q?Qj3SB7Lls05xy3OxV6ZZmDJgVfIVWt1JnY1sPQdpKaGk0fciO2KXiNtYCNYY?=
 =?us-ascii?Q?pivDN32ZncUoXPObUR5wEwxiFsQBhH0B0rU0w5hkUmNF1whaJVmk6+3ut5r1?=
 =?us-ascii?Q?NNLQa3CAj8knheZfx85VqsovquXP0Xx801lHhmuyCivlomHxYfUE149V0cbI?=
 =?us-ascii?Q?HZLgoTgbijUcz+Z3K6X+1K5eGZ6mBl+8B0bW4BC4CRAsDRq8pW4NP7GCBLVr?=
 =?us-ascii?Q?OrvUVreEI0G01Ikr0qGm5k/PWQLxGCCbUeSToeK8RvhmISM7605YT1gqo8HY?=
 =?us-ascii?Q?80TBAJtvFvMiSfNll/JHLDaH3Ezd0foRUzXq+YDegUiSg7AvFmWXh+LtquKc?=
 =?us-ascii?Q?BAIKBn8Y+Sfgx1OKIbqGv57rrmZ1nQVKzPOUYkJ+5mMvTjBoSi3POFXDAkTI?=
 =?us-ascii?Q?jVlmGmsZJX8/ZZGtAmH5cc/LN+1BpXuWXD8R9cF5nG0AowVcVisTmU8PDFlQ?=
 =?us-ascii?Q?2vqMGPlzt1IuBuWv9JDPwNirYVEQQPEBA8EUTEcPdgoeqkIvy93Xv/nSSv8u?=
 =?us-ascii?Q?AzfiZ0VpOU3DCN5JkfXel8gsF6goskclBjbmW163Y0a75+eutBmvJvvmDfzR?=
 =?us-ascii?Q?wLej3UN0MFquIGgAQw94BoSflcVKmErD7jhCRp/1+IXk43Vxy+9h/WrJKIfy?=
 =?us-ascii?Q?eF0CckocZAJhm0Y8IVCv2eCC7k8BooMjr06fM07aUyAYgtbom5SSDddLJlON?=
 =?us-ascii?Q?Ya/4k1/rG0GRnyJK4VrFqPlF3Hi2jC3+WWNrtUeFWhZjgPWPqX+Aitl3Oh4c?=
 =?us-ascii?Q?x+IBgwqOXp0NPIBqE8IFRGq1Te0efzAAEU4zTMkQDFb9YWvNkJlDG5dp/uh2?=
 =?us-ascii?Q?L4TF6ZKjtJ+R7b4pxSxd27+y4k76Bj/imY1ZV7xRY48Hq3nDuo6rDyC4a/+p?=
 =?us-ascii?Q?1F6VNSLUOdn6vzB+KvzFo31wmdEhaI8kFk+ZOPz84Bt0U5Gp8L0GUaImaUTT?=
 =?us-ascii?Q?+f+GZ0xsWFLVC2uCTwZ4k70Ygk/XiIROEVHKjcWfOR9Ay9UClmAe1wMuL+9z?=
 =?us-ascii?Q?QWjtFVTOaR2gac9ymKYoFvzmGnQvP2EtCRFC?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5271.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?vTBll1TUOBDd6DZYNXc636ELS0PjnvjEdwZpNzwua1RGZZRUmztsOgpo2Y0g?=
 =?us-ascii?Q?80XM4Guszw1JJ2xXfD8ip8SFJWYsLz5ClQq9JWwHlUDZDPB/yaisRWYSQxcZ?=
 =?us-ascii?Q?l2707ZFwc31i30Ce2ZkJ5eutSxRe844GDw3zu7CN2zQzuj+Di9yQ1e6FL1At?=
 =?us-ascii?Q?ub3eHrcHFvXO549YtyswDvu7WEshB4MAdXHutYjpTNIxLkdXGNjmJRrqaDHc?=
 =?us-ascii?Q?fVZdSwSFphQxL5PDhy7QrySojFn3nyGkRxj8De9VRvSHxjGX28maW+905PPS?=
 =?us-ascii?Q?DCifgaTmxy6IWqSc1Qq2i7cm6J59mwkDuzHwG2o/gSwT2uubBpSLj+9NJb4i?=
 =?us-ascii?Q?XZXqa0msuqAvZXPfWZqYoBIqnMKE/ori1FDbHP9FiBEn+b16te70cbHaQcSB?=
 =?us-ascii?Q?3QRFzMdi90hSB77ZW/AR9AgsorbKWyeVKbjNrqr772ZuZ3RmT+goYsKyTbOR?=
 =?us-ascii?Q?T+eXSHRVyNxBMy6Nipj3tsComqBKutghc8cssS5SPTrdlVW+7Uou5/XNjRnW?=
 =?us-ascii?Q?5gCGCtaNmVqLWJCNp8pqbD7CCpDMc/lC23fpCJJPIYrA+GzmZ31KYBBaLbiW?=
 =?us-ascii?Q?kAVJO/bcJK+Y4tRaYyNxyalL/nuo0zvQ0i8/phmmFVtHhf7NTzo9cPPpXAmR?=
 =?us-ascii?Q?VzVaThBclBGSs2GVEYSLF4opEJxsitQsrn2LD+vmxZV1fEPqWvo4UWedHhL1?=
 =?us-ascii?Q?Yd54xxrLv6ECoVTmi0A5fSF5HOP94Z7JZnEHwoY9ALB8UZif7gJe1TWhhOY1?=
 =?us-ascii?Q?KmBaKqHVkA41MoUeFgFkSJTnV8tiNxzBsFFhSSDZyb3CH+EjNuevl8r8b/nF?=
 =?us-ascii?Q?FlNY5leARYZ7OUlZn46mHfxIjYXiXaknj5QgextVzTpyTa3epYbdGtSMbM9P?=
 =?us-ascii?Q?QwcSTU0AZRUwjPvy5jrC9YbXBOmLElFdy17FfYvYdu9wk0EzFhD7S0rSFcDV?=
 =?us-ascii?Q?f6i7t04TmAUAcFI2SnQzSjy1Hq57QPYng5U/xI8rkrlSnmxIXL0hPM913F3a?=
 =?us-ascii?Q?ULBpN8IMFwor3woXGsufgJuO8bFkNdNAexp8OPLm9hkmLqzOaJWXiRKj9YGz?=
 =?us-ascii?Q?eMgFXcHrSlr5N5sSHBZexdMt/PqwEV9HIRQfL9SsDJ0F2+38DwjrXHrDjYQx?=
 =?us-ascii?Q?yxRv/AvpeeNvEI3VV7kudiMRQTTPmy/mtonkUIUdWc4WrpgqvVNZNzmf71Hh?=
 =?us-ascii?Q?d/h+HnXXzbJgg9P5NDhdqXhqAHIJdMnE8z6uvCmbcKJiGNszTd4BgcwRrNvz?=
 =?us-ascii?Q?ykL+r/RV2YwZRkwF7bYBMWQlogIlxpXQlV6hkVPRQbjLk7B8+ZD9PecjlKWK?=
 =?us-ascii?Q?/nCDS+VKGlYMXwTaYIRkA04cCe54VianOhB2fTkKxwrgKZMfskiAodS9tJwH?=
 =?us-ascii?Q?SaoG8C7O2Ib5hVHGhW/U+akh8FTp46WzQSR1WPYooZay6/PN8EY1TR6ACkNi?=
 =?us-ascii?Q?E6s5eB1ATUZtbO2GtVnsUU5ic9qdI1nE4WiEzjJHUnepuYT15i1dVB8kF9/i?=
 =?us-ascii?Q?4MLxI4yPogu33zFjaBhPxGL5vlSa1i0H8ZkekXNHwSSf106ImWhTN6aKp2MF?=
 =?us-ascii?Q?rLQ8KFZ0cD2I+1oejiI6PeXHy9lOK8PKWCNngA+k?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 73216117-3294-4e72-9312-08de0af71c9f
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2025 07:55:58.6503
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: l6qVHI+HS4tuSAorX7h8j4obTfa0SGa0pwrZPGq8mYpFDqYY1fyKyXOKP1ryhDW96K3oc6csdV8rg/c6ZVPdJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF8ECAFAD61
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, August 27, 2025 1:27 AM
>=20
> Replace the VT-D iommu_domain implementation of the VTD second stage
> and
> first stage page tables with the iommupt VTDSS and x86_64
> pagetables. x86_64 is shared with the AMD driver.
>=20
> There are a couple notable things in VT-D:
> - Like AMD the second stage format is not sign extended, unlike AMD it
>   cannot decode a full 64 bits. The first stage format is a normal sign
>   extended x86 page table
> - The HW caps can indicate how many levels, how many address bits and
> what
>   leaf page sizes are supported in HW. As before the highest number of
>   levels that can translate the entire supported address width is used.
>   The supported page sizes are adjusted directly from the dedicated
>   first/second stage cap bits.
> - VTD requires flushing 'write buffers'. This logic is left unchanged,
>   the write buffer flushes on any gather flush or through iotlb_sync_map.
> - Like ARM, VTD has an optional non-coherent page table walker that
>   requires cache flushing. This is supported through
> PT_FEAT_DMA_INCOHERENT
>   the same as ARM, however x86 can't use the DMA API for flush, it must
>   call the arch function clflush_cache_range()
> - The PT_FEAT_DYNAMIC_TOP can probably be supported on VTD someday
> for the
>   second stage when it uses 128 bit atomic stores for the HW context
>   structures.
> - PT_FEAT_VTDSS_FORCE_WRITEABLE is used to work around
> ERRATA_772415_SPR17
> - A kernel command line parameter "sp_off" disables all page sizes except
>   4k
>=20
> Remove all the unused iommu_domain page table code. The debugfs paths
> have
> their own independent page table walker that is left alone for now.
>=20
> This corrects a race with the non-coherent walker that the ARM
> implementations have fixed:
>=20
>      CPU 0                               CPU 1
>   pfn_to_dma_pte()                    pfn_to_dma_pte()
>    pte =3D &parent[offset];
>    if (!dma_pte_present(pte)) {
>      try_cmpxchg64(&pte->val)
> 					pte =3D &parent[offset];
> 					.. dma_pte_present(pte) ..
> 				        [...]
> 					// iommu_map() completes
> 					// Device does DMA
>      domain_flush_cache(pte)
>=20
> The CPU 1 mapping operation shares a page table level with the CPU 0
> mapping operation. CPU 0 installed a new page table level but has not
> flushed it yet. CPU1 returns from iommu_map() and the device does DMA.
> The
> non coherent walker fails to see the new table level installed by CPU 0
> and fails the DMA with non-present.
>=20
> The iommupt PT_FEAT_DMA_INCOHERENT implementation uses the ARM
> design of
> storing a flag when CPU 0 completes the flush. If the flag is not set CPU
> 1 will also flush to ensure the HW can fully walk to the PTE being
> installed.
>=20
> Cc: Tina Zhang <tina.zhang@intel.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
