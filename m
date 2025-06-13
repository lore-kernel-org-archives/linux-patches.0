Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76A162C15B2;
	Fri, 13 Jun 2025 09:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749808610; cv=fail; b=c/fPPVJPKhRAG9TuUsHQxUGEar56gSzFOnxyxPRty8FVHorgrQO1RoczQXlv3/vx1m6sDW4xsctnzAeLEq8cs1QMjRIwPAmNfOWcQ8wQXAGh9tqZu7pNQMrtqKaMwk9FPaBiD+rr7m7zPt/4/e9BCiRYLZMfLv64oM1xSBa1QjI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749808610; c=relaxed/simple;
	bh=Jn0xWU9ud8wrAQMaSBbezy2GS89jlqFL3QGw3PerCHs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=l1BVaIu5WTPYF7Sm4kkbWJQKQAqFBZIzCyP494fLUJ5B6EYtPPAbRpB4HawimvNVv45rZ4k5RzG1Bx8UkybeV+QinNk9rPeLMcfIIktiKG8wAtxLerTneY11K0klvI8qOD2xpd+KTZKH8hhN/O2P1U8R5B43g16ukGU84dChiJo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZRjygsl4; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZRjygsl4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749808609; x=1781344609;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Jn0xWU9ud8wrAQMaSBbezy2GS89jlqFL3QGw3PerCHs=;
  b=ZRjygsl4DbDg9U4sq/FtR8sfFrVb+zR3wm0mkHHgv+jvBN3N4K3Rmkk3
   VZY2Nr4kjtyObXmY8YnphpsqTngLIMscKAGsrVSz++N9WF/dsqkNeEsIy
   vuQM4wNlYe8Ciiq7IB/+0kK4X5L5TluaIoep1o2+yHGYzPzu2oZ8gqZHW
   hHmXedMaXBkb9Xr0p5dEElVEbSl39KGMXWQ3Ytt/jIc6D8oJPgQf9eg3t
   6IpbvLw8PTE/GMhbvN4ojVub3Goo/JfBwgXfupdH9atKlvihL2clKbkBk
   hw828gAodt7T1zKZNE5zgTx6ZQfSajHfjiDoqQq74mrTnPpQBo9NRjdMU
   g==;
X-CSE-ConnectionGUID: meKh38JVTruGeB0pAot8wA==
X-CSE-MsgGUID: gNFiSPXuQtW5MRcDLpmpuQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11462"; a="55817027"
X-IronPort-AV: E=Sophos;i="6.16,233,1744095600"; 
   d="scan'208";a="55817027"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2025 02:56:48 -0700
X-CSE-ConnectionGUID: oiqFgVPgTleEovBfmfOeQw==
X-CSE-MsgGUID: GmG5nqUBSMu07rMYLILNCQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,233,1744095600"; 
   d="scan'208";a="147639295"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2025 02:56:47 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 13 Jun 2025 02:56:46 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Fri, 13 Jun 2025 02:56:46 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.67)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 13 Jun 2025 02:56:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VdDc5e1GsvF3lJhZ+YaNZKMIMncbdg7lM/j4gUqdku+LXuBglwZjN8g8x7JIP1xifKmrw/Z1UHZif0sKZe7Xh/lH+Y84dDZO+IbeFH9O2XGAItt6VIvVKLuwJ5eDKFm4OaeuMUYeQEQpyH1JD2rHVj1t8W8FakG1sB1vzxQhCNflrzcLkasVifku1wScB5o9QoFemPN4weqa6VTBy2VIjzp6GOfYD4YblK0pxOT0JOkXVeIcUJ7b2Tx4RhCRuh2XFsPGVHVje89eFuUTN1AUBzd6Z+XeETCziB6AEsB36hMysi5yWXpjAocKynPN9dc/1uMN0JJbF2aEtA8+CH3kgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w+BatWzw/wwXuZH2sDXdJZqOvJlBMbUpwurBQW6Lg3M=;
 b=D0Bvscg1cJ7Mg3P72T14b4MgHt0u5BRLNoI+KTVLkzBplWz3v36nBBiYHltrpxn3iQf1bT0BvF3h+45J4jAJM0t80mJahphOc7ctAXEuYF+mPzs1aB9iJYoTE35wX7QrWf5rqORkTWkGwLT8AqnsPDApzJb+VyLKBzk3vHVDOllRbL8/+zJAKRweqnD34I5Ihk9+vUfVOTIN8wEd7XZIFvWwlVs6KKg3r7c/3Rp6k0Hqg/atyCgeTOWPs78uudgfaCkYmuFsi5Gyxy8neT34v2a0T9v8auq8pm0eaRxNnjGIlhnDzKxxe8Q4c/IQS1HkuyisQW91MlA/CS3NNuvKmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH0PR11MB5032.namprd11.prod.outlook.com (2603:10b6:510:3a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.21; Fri, 13 Jun
 2025 09:56:44 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%4]) with mapi id 15.20.8835.025; Fri, 13 Jun 2025
 09:56:44 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>, Robin Murphy
	<robin.murphy@arm.com>, Will Deacon <will@kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>, "Wang, Wei W"
	<wei.w.wang@intel.com>
Subject: RE: [PATCH v2 6/7] iommu/vt-d: Split
 intel_iommu_enforce_cache_coherency()
Thread-Topic: [PATCH v2 6/7] iommu/vt-d: Split
 intel_iommu_enforce_cache_coherency()
Thread-Index: AQHb26drchwrDFbHmUmu0jrVBe+5pLQA2jZA
Date: Fri, 13 Jun 2025 09:56:44 +0000
Message-ID: <BN9PR11MB52763C1B4AED06073FAF79EE8C77A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v2-e5c01fc5ce82+26216-vtd_prep_jgg@nvidia.com>
 <6-v2-e5c01fc5ce82+26216-vtd_prep_jgg@nvidia.com>
In-Reply-To: <6-v2-e5c01fc5ce82+26216-vtd_prep_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH0PR11MB5032:EE_
x-ms-office365-filtering-correlation-id: 73b40ff7-9843-47e5-b17a-08ddaa609a90
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?SECasvcaycMLrFYs5idV1nqLy+z/ntFGonOshLoXujrIOOwdNsW4qrMtB62b?=
 =?us-ascii?Q?rtOAMTno2YF43qqTPb/d5nYWgEb2bHKQaTvPYvudFj5Z8AwHvBLTCDsW9/te?=
 =?us-ascii?Q?w059rhu+pWgkFnWRJDcd2cLGlg9t7aMqN/HOYN6TjHETOu0mB3GBzhn71jAt?=
 =?us-ascii?Q?O0FMSOSYS2ZwU4z7lYhppVlQdMkGp17KTX8xRWlZDsL6Xz0Ubkn91zU55DJK?=
 =?us-ascii?Q?heRDDoS26RcWAJmPbkELo9e0GLbTKa+aqbytrLpO2DvVSv9/UNV3pCVvQZCZ?=
 =?us-ascii?Q?NEDEsMwHSymGN3zGtwWVvtFQncfVrtYMD54mGzQdNAXZtW0wlVVEnpc6KtJ5?=
 =?us-ascii?Q?kViEnSzruMqTDQ0Et5NcxWWrZ1BWdR5u3Wy52UhVPY/z8xlXGGhDJCq2KdFs?=
 =?us-ascii?Q?IYVLQRCDZ4orK9GC8BN3DI9j/SWwx5eAeGGlhYpQCvWj8nwrByzwVLYDIyif?=
 =?us-ascii?Q?acK8xZt4IfgnZy9N9m/3GgE9FkN4b0W2JbdJXByxVh/DZ87h4lKWqUnHyvQw?=
 =?us-ascii?Q?hyAFgBv9QLTjXS0YU+KhOjZYvNmeSkq7OpML05x5i5B04KL8BXVUEoE7iIz+?=
 =?us-ascii?Q?DcMdnF6xkwjbI6OvGf+WeTQsaLnSMWot+VaL415yfZ/E69OZ3fMLVoE3kxoh?=
 =?us-ascii?Q?MOWJDo4bVfkvOvH0qgvsiNcZEmLKc/nW4hhusfE1fk1lf1jprvxkYPpBzqmC?=
 =?us-ascii?Q?afQwXcS8lfs//OT/aT6GFOocaFlXXBuzHkEk9oeieKVYf91XqaXPSjIh3nOt?=
 =?us-ascii?Q?9C2gn8JwByEXqltBCa201snh/IQzaZe2ZG+Lb1X69V0FEF5cTS7Wjk0ZmeOC?=
 =?us-ascii?Q?qLVq1Z/9+/ZsVPrUBdrM1YPPfj1iZAtSjd003XnK8xJjSRN0UrfrqkwtHKpn?=
 =?us-ascii?Q?oB835fs3MFIt/ZyJ9KHSsYan/HhnThk4Km+EFl6U/rhPC9LHWmvoRZSw58os?=
 =?us-ascii?Q?xs2TDPDEvBUnYCSDofyzO64ARaJA7jt+A/FTVezr62lx2iY6XfcRMx7sFcYO?=
 =?us-ascii?Q?4trlMWlqb/ROIgoSo/DcEedy+hw9geSdMO9rzWr3LrWd1sshz45nN++zfQV3?=
 =?us-ascii?Q?SY4pYEZtTQy+mOF1jAlxEAeGRkrBN01vmuJFxIWjQqRK+fiNQQfo9YCwHfeq?=
 =?us-ascii?Q?m/esryDy6TqEDq2RrnrLfoz6lOqB4VaNMtPlzyu6+GTlDvUDYuLJp7Iv/JJE?=
 =?us-ascii?Q?OXTSpzbOZqKqbRgsYkHq/qwTxPVPFDGMlSIlSq7lGnpcCD3mGVX/S+Za7JB4?=
 =?us-ascii?Q?SRBRK1e99jgKItw9BngoyLTIFq2czZoDvkwmgoB6ljzpmTSYKpjp5ZJEi/u4?=
 =?us-ascii?Q?KyUMYCfV/MCRtCcu8KOK8hlyuXNtQPEW68nwG56/LkFvcC1YSO55cKqFUvep?=
 =?us-ascii?Q?tnfDgu4cvozKTt2AB+6FPYuNJlXFhZiclTIgmwLqXu1R7fL4WonBePl0fUf9?=
 =?us-ascii?Q?5Sxd/EfSq/JDklRNtDir+173KLR6rtjFiXhBPO+OasGqq1KuvveWfw=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Co/hN/jxKlhjP/VXR4gjaBbmKwZ3ma6nr7yoKkfU95sGW9omC7dhLCKawIek?=
 =?us-ascii?Q?2ZyKIYw63jYR4oCQ+1OfqAwzwMPvk5mfE6qd1o57g1xGsW5MAM/Ck7cB0iiq?=
 =?us-ascii?Q?jO2lYTvIGkKfuTo5o6mIKCakVKGhrmrMNPLEvMx3Y1/YbhG3H1u48fAUO0Ga?=
 =?us-ascii?Q?gOd2zyKk0i/UhixZYi2/VvF/HeKK4O4gKqHhnUAjedqIjsBTDdmPhOj2nyY8?=
 =?us-ascii?Q?XEuW9LluzLbcd0a4dpyq2kAqszDi0JKQVQhiN2N5CC4DyEJp+nJLY/MjnR9k?=
 =?us-ascii?Q?uCRyQ+uDGVXFUndhl/KuGWPprulJmlrlaw7WWdNymqggm8PIGC1CZVbKWqGD?=
 =?us-ascii?Q?omYpRLhzjBcfpptYcHv2IQXsxPs4rACX2J6lGXWBVtpdK78tRML4+7KPTGxI?=
 =?us-ascii?Q?6WXGfqtIqz2TBWKMhxfyfSyeag1CkfvmnONEQpEPa3iEfLVTAx1+Im4SL6/E?=
 =?us-ascii?Q?HmkIx+5KzhoUFvGpC41vArgbWdT9NP5DoykWpB/vOdYgc7VymNe7CxiFHXnT?=
 =?us-ascii?Q?AJrFX0IIOhmKsg46i8OtSpJD0doLsNZqoCJ3pT//anMO2xEM88IkrsGT0YIh?=
 =?us-ascii?Q?DNPe8b5PG6zrGVylxtGaDkXF76S/+OhKJ4ECEKjxo+fVdQ5dCtJ+21TzzLxE?=
 =?us-ascii?Q?ewO5YmdMzjss9CQ7amamUh83PrNNTeFHhY2Rpl3xhrt15JTwf22EJKGXRnZ8?=
 =?us-ascii?Q?KYJ1n6KP3JtCemwd39KFFY8IHutJvoljHF9UaI1aBkMzqp4WVY6hWe+c/aOA?=
 =?us-ascii?Q?ZtFw9+nOlLRCl6Dsp3ARuFU7MHfuVRGDKZF1zeuw1lldw2g25tpwyyYNPIiG?=
 =?us-ascii?Q?AVHVFeAcZqMbiwC7etMWRX0Jgsmej9jzR4+IiH5x6iEzeDGP2Yh+l8RHhq1s?=
 =?us-ascii?Q?v7ibK1GkIDhlrvjZG4u0rRbmgpF6Po4IaDMoezHlNqEZ/O4ikOg15FzNkkf0?=
 =?us-ascii?Q?01oSXGRl+405s14ks+QME1I7woX2FYT3bf8H/3SM2EAYAF06Vf/VcksdJ4DZ?=
 =?us-ascii?Q?c4lV81vWJSYFu7mYbJUflR2pnGNOPLVOV/nOMsL0Qulhx0bgmq91CHHWZEhn?=
 =?us-ascii?Q?27ej7tPB2dWdSKYEL+1LmJaQYb+8+nbsYi9dxMe+kDqGZW+WUEIo56ocyebY?=
 =?us-ascii?Q?cgnY9TVTqklPUBh6zc23pYbgig9rDp1wJIA6uSjk/47aWh3dzs4mNKT/e1so?=
 =?us-ascii?Q?5j8mlFt7p0BgcjHVxke4wK1y7vEmTkymdC0czJAekBmgw7z+Zhe6dmeAhX8l?=
 =?us-ascii?Q?YrJ1VfsCFWFK2IMRQ//R7e5JA/0otXg0WocF41VZhFLHDUDDNit4rJMjLvhh?=
 =?us-ascii?Q?V/oCDpvIFw4IF5XfBIqVhXyWF7Amwy4uKK8LjYeIBtQdpEhCv2uFjZfyERax?=
 =?us-ascii?Q?3dTqHARYlpo4VZxeUNPrg4eLHeNlVqFXkIuqsWBQi39BdZC4b/oQhrZOkeM5?=
 =?us-ascii?Q?NKnSdXPZqwW/WJjeiv0m38t6G1bHffeOeAmxFhM5PMVyCwSKi2af9rOVvXI3?=
 =?us-ascii?Q?ftFV12wmI+q1gM9Ijk52M8p/k3XZqJQH8GqEzIb5vft/SpI2wUl0gJy9OhoL?=
 =?us-ascii?Q?iQuY5KEvJgNxMbKBwOyRRzxC5ydkY3CFC3YAgCFm?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 73b40ff7-9843-47e5-b17a-08ddaa609a90
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2025 09:56:44.2851
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r3R3wajn5iSdbdxmdHzVY09tpqBq+I3YaIufmyzkg5WeUgADAdbSLOx/98allnerJKcjlN9GY/7Nzm6/EgyAAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5032
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, June 12, 2025 10:32 PM
>
> -static bool intel_iommu_enforce_cache_coherency(struct iommu_domain
> *domain)
> +static bool intel_iommu_enforce_cache_coherency_fs(struct
> iommu_domain *domain)
>  {
>  	struct dmar_domain *dmar_domain =3D to_dmar_domain(domain);
> -	unsigned long flags;
> +	struct device_domain_info *info;
> +
> +	guard(spinlock_irqsave)(&dmar_domain->lock);
>=20
>  	if (dmar_domain->force_snooping)
>  		return true;
>=20
> -	spin_lock_irqsave(&dmar_domain->lock, flags);
> -	if (!domain_support_force_snooping(dmar_domain) ||
> -	    (!dmar_domain->use_first_level && dmar_domain-
> >has_mappings)) {
> -		spin_unlock_irqrestore(&dmar_domain->lock, flags);
> +	if (!domain_support_force_snooping(dmar_domain))
>  		return false;
> -	}
>=20
> -	domain_set_force_snooping(dmar_domain);
>  	dmar_domain->force_snooping =3D true;

with this change force_snooping is relevant only to first level.

but nested domain checks this flag of the parent domain to set
PGSNP:

pasid_pte_config_nestd():
	if (s2_domain->force_snooping)
		pasid_set_pgsnp(pte);=09

we either need set it for second level or also check set_pte_snp
here.
