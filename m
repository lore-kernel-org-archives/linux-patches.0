Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F009625F7B9;
	Tue, 14 Oct 2025 07:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760428414; cv=fail; b=DARHP/aeKRvk6+15i0+6RYT4OTaBDiA4zyrqmfEbV71tL3u0y6bgd4aIVEaG1UvIuBTonM/R4zMgAXGCttmDlSRmZ5AlTRORpS2vJvOIDPWA9ANH2TU0KsxbXFLoBKYqjAsoblswGS8luQvtWujpMxZwVkQ/M+WbVIn4GISrXHs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760428414; c=relaxed/simple;
	bh=LnYUyYMftg3F+0tjM69xqNwz0y3sQE7prXtOJolwU2s=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=a5kIcbnKgtAj+d6sjtYh0gKRn2iS3bmLHZo3MFQCBb+n9agCXHUiTBZjOXbWnMoaxamDs4Ze1bi9i86pyhSp+gOZ7bQ3P+TB6eo9/5XubRJat6NP3ZlKrE4V8vueQxK6wPJzBYOTNmex7qZ20j2kdYzAmxzUU2YJrS3DzNs7ljI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=f9pSd70e; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="f9pSd70e"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760428413; x=1791964413;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=LnYUyYMftg3F+0tjM69xqNwz0y3sQE7prXtOJolwU2s=;
  b=f9pSd70elyBeiXe9txlA6abObmTdjA4N1Kjjn9wzHfQ3keA5mbL8o01W
   ciCWlOrjNWzpFU12IUiiQS3aL7AIdvIHjpZD4qnOvinA8U47QUC8QflfR
   aazgFb0M7LW07u9ynkAq1wRfCiM8I57paci+JxJvafFV3M++JH+4vmp+M
   I4KLV7S5qtvdx9tosUu6+jz9Nx5G4EY59mxxJHpAA0R0iI9PZiA7dOapa
   vLERfCHofWKTi5hM4WWgTwqRqQshiTdbXCiSITKknkR8V9S4mJPvPTro2
   c/7xNusId6hbXq9jALIeBM1aLtyzNfTG9B7nDPs+SDw/cBLBCv9yqyDrK
   g==;
X-CSE-ConnectionGUID: rZ+p6pLwTAOfBRScCFdP0A==
X-CSE-MsgGUID: Gj9MY0fkR5GEDAp2yjr9zg==
X-IronPort-AV: E=McAfee;i="6800,10657,11581"; a="62620159"
X-IronPort-AV: E=Sophos;i="6.19,227,1754982000"; 
   d="scan'208";a="62620159"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 00:53:32 -0700
X-CSE-ConnectionGUID: 0uNAIOnNRlemkYC29tInmw==
X-CSE-MsgGUID: LsBfdIJ6TR+F9Nt2m6/4jw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,227,1754982000"; 
   d="scan'208";a="186068206"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 00:53:31 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 14 Oct 2025 00:53:30 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 14 Oct 2025 00:53:30 -0700
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.70)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 14 Oct 2025 00:53:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cUmMg+ivYthkF8+huzo+f35qMRHET39xnHJyX7uPjSDG2R5+52tAUoA2llM0zDDFnQifBH6jz1Wr7AsWj+a5JZS47vZnCwd4cGWeuQs2OrF452iJflmAYNhXZy09dzmwSFmNqtfkEK+5UEnbxV8yD70DFvBgY5oRAOxbIDq/1oQcH8LPtGl0enhBzhDn2qhEWMRKEOWuG9vI86kFtR4SmJtZEpaBVIZzsl7b+RfzQbqzumj62q56hDXCEhf2f7CdLB8pOslxpx7Bif8pcL/xTdqJ0KRySUA5P4yGYDIk542qkSE70+L8F7hrP9WwgYARnMV6+2XUCmXkqai01PDHjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ju9FFg8jRqX5+eOf5vUY41a0gAuJ5X4WDWdLBcekZs8=;
 b=dX2XwkFDDbx/5ADwKeZpo+5HzQIaLdnp1g7ZMFdAiqOZEnLVIbxoRG32HXmpcXR6Z/OHWk6H7T5Ri7P2qY8LjBBfBNRnxqsiO3h9Tqtcsp8m5+sEPF/84FIIcz2r7+xGun4PPNxUhFULvILRaF6GL8sRG1yfTcVQCsnt62sZk9iLBLRJjwlI9yunvF5o7lrETjSt5itSTm1qSNlCMik4NBa4f9xWRhZ0s9axxklQLOG6Run0aPa5UebqvymXAFCs79CXP3JAeq64eqGykBx9w4ZCCLrdCCIgkTNzQwzb+Z9r52rjkKE+GensySL+yIjLpABWymSDq9NIvodUnZ709Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5271.namprd11.prod.outlook.com (2603:10b6:208:31a::21)
 by DS4PPF8ECAFAD61.namprd11.prod.outlook.com (2603:10b6:f:fc02::3a) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Tue, 14 Oct
 2025 07:53:23 +0000
Received: from BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::5616:a124:479a:5f2a]) by BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::5616:a124:479a:5f2a%6]) with mapi id 15.20.9228.009; Tue, 14 Oct 2025
 07:53:23 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>, Robin Murphy
	<robin.murphy@arm.com>, Will Deacon <will@kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>, Tina Zhang
	<tina.zhang@intel.com>, Wei Wang <wei.w.wang@intel.com>
Subject: RE: [PATCH v2 04/10] iommupt: Flush the CPU cache after any writes to
 the page table
Thread-Topic: [PATCH v2 04/10] iommupt: Flush the CPU cache after any writes
 to the page table
Thread-Index: AQHcFq6lNvjz1PSg1kaeBNin5JCIy7TBkaTg
Date: Tue, 14 Oct 2025 07:53:23 +0000
Message-ID: <BL1PR11MB527176E811B4B5C8DCACCAD18CEBA@BL1PR11MB5271.namprd11.prod.outlook.com>
References: <0-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
 <4-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
In-Reply-To: <4-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5271:EE_|DS4PPF8ECAFAD61:EE_
x-ms-office365-filtering-correlation-id: 00aa0093-a7fe-4ea3-b7bf-08de0af6c001
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?glYTcN1v9DD0eQT6razy/StQuOTkMebwfp2/MbjEV3YvABOFAkjGuo/ywuEn?=
 =?us-ascii?Q?0U6t+PmFYTkvBfszNYp/aIudyLDO7SFjJYLbak64csImmPfdc0Gqkze2LnRR?=
 =?us-ascii?Q?ksC+VoI07gkxPmgIu8xs2Uw95qt1Y0MvQ6pDsArv++8HrICm6WS022TPwfjt?=
 =?us-ascii?Q?BYba/nBvsR8+DhDB427hTeM58zwVkEK5BelyUnxNSVGDcflFObHcI4SYyc8Z?=
 =?us-ascii?Q?DMYlq1bVkFCD8KMJgOWYpc1Y9orODJkLklx04klsuG2DFRYEzgftHLEx3Mol?=
 =?us-ascii?Q?8uzJh5atnC+AKUbZGPqJ5D0F0fm/r7RoqpDJ8TuH/6w7uOJQ6+Ca3Gc5oNAJ?=
 =?us-ascii?Q?30LsAUNIXuwZiK0QUQAVdjftWa7abjiOQH95prH3EmZR9R8NwgoZXmmRVnTb?=
 =?us-ascii?Q?X6Lz8+hx+fEcetV+uBbHW9lw0k+LGW5qxQgj3HN8/w956pM1QUgSRY0nrmUU?=
 =?us-ascii?Q?uJGww37CcuSGWFpzA0I0ntVhUa9Z9Fgdf/he92OA4Q2g0mlIrlNmowL7ulgH?=
 =?us-ascii?Q?i95V6oEmp3UD8L9BXqInmh/+1hq2EDTLkHOFq2XA7quCjlwXKPfu78O/qMGH?=
 =?us-ascii?Q?RRRlXlpUVtnq8trVDwPD5KQxDa3q43v2op1ibrifPhcyuOBEFfrUMJ3HMXTK?=
 =?us-ascii?Q?PqT5I/guy7ZFMHPVc4T4jsK8R3DzDtTa8btT4yhtk3F4h5AjyVtXcnQZD/RI?=
 =?us-ascii?Q?QWFWu1GnjV71BTK+0x6IZK6yowYP3lYhZYnGBgGRzFRe9nn4+W6UsXVzCKdu?=
 =?us-ascii?Q?qjmk/kMB1U8MeVyeuSQbEL5Jhc4zdKN48r7qn0YgqJlsqOa5fOJ35Qqv38EO?=
 =?us-ascii?Q?itEOuRLO8NwmrYbtHf+J2tJVgyYOql0F73WMT7UNVutrHgpqChRXoaDVUutw?=
 =?us-ascii?Q?8PHMcBTOp0VKeJ1pZVqVsg29KlDhrSUpJT93LCrslS8x7SOdyMprjaHvr+wA?=
 =?us-ascii?Q?zWO4skJNRGQNyz9XdqZOk65yRlLwTerAe18lA7zmg6ltNY8oFwEJzJc9DGZd?=
 =?us-ascii?Q?89Hh35bkA9xJL4miwjs/igsqVS0yJbac7UDzRDXVpUsIrW74ga8PfktPyxLs?=
 =?us-ascii?Q?hk8cRudH6yRCioPr3S3SzrrVCFBhOSbSTqwYtlR6L1vqwLfY+oBH1s1iUIy0?=
 =?us-ascii?Q?rrH0LLrTryNCkAtl3lzaLFfYPXs8ORO2Sa48zuhtAHBC9wFOJUUc3svYxCvJ?=
 =?us-ascii?Q?YDL0+r4MsL2FkkJh+08YEfec7Zo3My1rO8qG9u11v0UYd03/RJjcG7lS0SbS?=
 =?us-ascii?Q?bcjmUv2TZ9wH+FErz3Z06DOYt1Oedj8+glgIikk5DyIndbIyrEJqGFfwIHWz?=
 =?us-ascii?Q?Sa2+Zhci4OmbEYGVMWB52WGcmepSqH1xuNnLfetxV+QY4PL0sAszTo2B3cLh?=
 =?us-ascii?Q?sdhg7k7Hr/lP0HN7jvM619B8LcgU3E2IVg3N1ubXR1OMjdslquPyXquQ+CH/?=
 =?us-ascii?Q?iCePCKB75MtP79yrBFZ169x0k91FRBESunUllCxtrPQhOp7ZqmaL1uNvqTh7?=
 =?us-ascii?Q?saAq6GpBfRJk8NodqUXmiwhiMfQ2J32dusus?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5271.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?rX1hFrQfJFjnR4fLZnwJW0PzHIAVBArxf/gSiXUxvuF3G7RAVL4HGALRhZaQ?=
 =?us-ascii?Q?oyEHYARp3xmWb1V2T5GzL8OqCcqLyO9k3Yg8Te+NJDSBsEpNLNHwP/CIpv+j?=
 =?us-ascii?Q?EpDfKj0oC5Pa2uzukolV/wwbWVxuYD5BjQiP0XRUtRKxn5EnP9ALna1gh1eR?=
 =?us-ascii?Q?7owSRRwHMdIzLAVP43K2ZMnlgzP5lJK24P6qQIAPfEkl1H+MXilLabCd7Qdy?=
 =?us-ascii?Q?X8xa4RNYJ6e71hu+4DgqxeURET5CyoXS/kI7Ki+esPQivec8AbVYPMKgpiWt?=
 =?us-ascii?Q?skkCJ3mApAXUGKTdNtmaI+a12Hi5QEEX/xwLz8RHU/JaBrad9cjUCvTNqRoy?=
 =?us-ascii?Q?MUE8/D6YQiLEJyQAJyGrtZcAjLigblCjKIUkHzpzjSOofXt+u+DWclpTQm9v?=
 =?us-ascii?Q?Pj3PyyMa90qx1LL5Q53JSctNtqzpr2GhufyZgP2yxqA68tzJcgPA2C5UnGjl?=
 =?us-ascii?Q?d4gENXlI16pazjmgvWk5Y1/ISjcRyerUhNuhMgXV1dZ9qVtlMt+uKj0evUB0?=
 =?us-ascii?Q?bdNW8R0C7egsIYVNiy9vTZ0fsXa0sttBBBc7+MxNnzvKrBNwqWA83c+6VLzN?=
 =?us-ascii?Q?o8EMVrftoXQEP1YJldmfFdcpsbpXdXmpMVEwDUxC8RnKrt1XsfZz2QVhlizZ?=
 =?us-ascii?Q?zEvQk8S9ugweMs1yVsUiRLRNjflr19YBkd4CaRWNFWI+ycWItPHPYXzOkrY7?=
 =?us-ascii?Q?ME3WJp61luhCLjUhQpA8MdbYPV9WWDhQXrmjNruGmiPtpW+zF3S/gL/PMSVt?=
 =?us-ascii?Q?bh07fRlm3KCgRDLcDPJtHhTVlsKfhDrW2hpY+4HqlieOZYCPYzhJfY/uQgnO?=
 =?us-ascii?Q?GBmJVuFpQQO+kPFq1vc4hxGgDwqJ+EdN6xu5Ej9j4qf65gLJiWl8iijWn6QW?=
 =?us-ascii?Q?9GVAEVeem7wG3KCRQ1xTc8WAMy/L6O95ezvlO3ZKYm5BN5F3C5QuQx7vMdkM?=
 =?us-ascii?Q?nosollj7wdxtfwGBZqoZfZPoeZQAWdyxKaAl4HyjiajpXTHGn06XLcHP1FFX?=
 =?us-ascii?Q?SAp3ZuUhFG6MTkB2OILy11MTKRIKR7AnxrB+xb3+g0+hF0xtgGCzygnqggp7?=
 =?us-ascii?Q?6Z+H2mkfTuPhxmkbWPVbrhS9Oh+JMJWkd5lYdlMepmi6Tux4wvTEew7z3uUz?=
 =?us-ascii?Q?ik7HqZSnn7kYm584D6Cawk02yiarzf3t6ibwLoOMeBb2oVGw8xVjVHaOg/mW?=
 =?us-ascii?Q?j7SV4mXgCFgZnvPZIylXT8C3jBDCZVEiYuIobmq3bF0H99N3nDUeXY7sq+XQ?=
 =?us-ascii?Q?4b2+5n7buVpHx94Zlnl4YtB2I89XvqCeDZj6LqjNg4iIDElm4gy4huMzsUfT?=
 =?us-ascii?Q?CqrzMHRtfA4+wYPWLavUwjMFsPqzGGgGEpzoPpp8oDRV+sRLGLFY1YvmLPuT?=
 =?us-ascii?Q?6SRM20xecliqK+QgAnPZi+1wL/ZrEjraQlj+qiX5vNxAgfspe0kbUQ2jaB2X?=
 =?us-ascii?Q?p778tuTbE+4Yu4KjXS/iEVAXkIJuhmk6L3Tj4NV2tjTe8VULs1Wch4yF/ZDz?=
 =?us-ascii?Q?tFXuJLgJMU+U7PXNbQF1wAD8TV00iuRDNJYD3WZtC1b2mJiI7ikX5+KBWJ1S?=
 =?us-ascii?Q?f4Iq/X34y/Zv43/kJ2pThvrDeD0SEcvNxAo5mWor?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 00aa0093-a7fe-4ea3-b7bf-08de0af6c001
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2025 07:53:23.2582
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YdKh7iVGLNJ+FoMx588JhlYIJbeYiCC6iRoIy+i9YqZMohTjF1EJ36YJXCZ2JKBNq3oJgGGdeeakoM8M3fRFnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF8ECAFAD61
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, August 27, 2025 1:26 AM
>=20
>  	do {
> -		if (single_page) {
> +		if (single_page &&
> +		    !pt_feature(common, PT_FEAT_DMA_INCOHERENT)) {
>  			ret =3D pt_walk_range(&range, __map_single_page,
> &map);

let's add a comment here for disabling this fastpath.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
