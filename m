Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D59828D850;
	Tue, 10 Jun 2025 09:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749546864; cv=fail; b=c7cvd3yuZYya+c2vzFktoAqWPYu6ISenY5xwW66dPNjXLEm6fH4NqCOxKLNWAmUyij28mD0643ygRtzO2t7EpbQURj+FU3h9J8Gx2vG1Nqq1Aorgosg1aGT6N41Xizr0tdvefLGWCzfWUvoaPC7b7TYPt446nMpsUDhtgv8sBVU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749546864; c=relaxed/simple;
	bh=laVYYLg3p1Xx+3CZtWUeykSYfDmsJpXuJReEB35/cwM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YFkfh8FAyOXrv8A5WR/e9cdqFqwYM33MpjFfYCdOVeyZs/SNVgqqMkCyetGakxTwKUQucBMEMwsKkXSyncZBeBOHqCE667ImLkE8kGwWEhdkzSs1FLwN9WVdf7AFW6y/ByfUkqsjPN4BmJiwO8t/H+EeGC1hfAHhVzSs5OA+NvA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nXmO0qDY; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nXmO0qDY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749546864; x=1781082864;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=laVYYLg3p1Xx+3CZtWUeykSYfDmsJpXuJReEB35/cwM=;
  b=nXmO0qDYGQsQ/t0Vo9d/ehXACVCwkNDTgk/gnlAam302FL/pwFHrNPoH
   cje4ynHhC6aH02+mdcV/DCCtP8TEt09YfsgIfXpl4wENdi93cUKm1MnUC
   8baZdVhyGnewJ0XObPQC5tNzg6n6l5fClsa1kHRb8jpaW67VzlJOhCY4L
   +rMXm9CoiHZuX2ES/K8Z4g+aZ5cOLzClEHAPGb/28GbgQWaBr2mMOX7tL
   hAx6HEvsaas1yo4ntgQuV/jRZ4TYRGL5mfwhDDUyfgSvg4E/kw4w9Vp6S
   G6rctWFlLVokw+/XECAjLQqI++uWOrSCgCko7C2vZtdrhNncyJWegV0bz
   w==;
X-CSE-ConnectionGUID: nbYLf2eSTx6pzZWDPoCTsA==
X-CSE-MsgGUID: 4byXfnwPQ82z3JRxqig6vg==
X-IronPort-AV: E=McAfee;i="6800,10657,11459"; a="61917986"
X-IronPort-AV: E=Sophos;i="6.16,224,1744095600"; 
   d="scan'208";a="61917986"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2025 02:14:23 -0700
X-CSE-ConnectionGUID: GN9BEvH2QT2JFj5up8GSng==
X-CSE-MsgGUID: jVyTlIYCRzmo4uyvO/lYGA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,224,1744095600"; 
   d="scan'208";a="169952969"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2025 02:14:22 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 10 Jun 2025 02:14:21 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 10 Jun 2025 02:14:21 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.70) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 10 Jun 2025 02:14:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TeDr8YNnecQa1yz6KlPCM0ut/L/Q2Bz4DJfzpuZp+/CGuiEtxrUYRUqOk1LSy56bFygt3ORFtma2ATT3/gQYhLiClTocOFYnQHra5jNBGummGdsSjsdZRIQ2OebdHO+xmL1zEkXNnTdRYeoM/8zuY2RNPbylKb1XBmjkdJFl/Fxs31vWWR88QHEtEkcAbdqgo6h2/bWZzz96YqFHhAGIkNwi/kKhGH+NtSjMUbt+PjE0daje2/wMN1/il72sLjXWLsLyb4zx2nIErxAA2R1jaHGk4WvYr96ehVI9WOSQ2S+8yenpQUSpxffa96E03samuKsgt2NeCbNhTKBKfHXywg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yGFXogbWqSMvkqJdOzhmz0gCB0UWKA6ayjVuK9izbDo=;
 b=D9lVXGrWZdV64yXi/Mul+AXCSEPISdYuLTy9iBpDBKrVkCYDmIYZ+pQLB7h8QTa1Xzm7cvj50RIxqKWM+QF87hlLac/RaqcUvug2m0Te6OL1e/xUmF2wU7XdfzuUe8mMSBb7p1aRiiLCm2fZ0dFgoOuNzos0JgYahYxpBz6l5+1l2OnVynhHTyT1xoLn+BBt+d8xsVrE6W7BPQstS3/d+g9KX8Ee2Jfoq2f+2ygX2Ezwqp3REZT0YhwXvzCXz6kjLCGASxY7eI6HD5Z087lM1iS6HuruMsz9Sq9uguNE2qjmjlTuNALc8Cubm3ibI0V6QDkEIq4NeBLt+crD6gIikA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 IA3PR11MB9253.namprd11.prod.outlook.com (2603:10b6:208:571::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.31; Tue, 10 Jun
 2025 09:14:05 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::2dd5:1312:cd85:e1e]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::2dd5:1312:cd85:e1e%6]) with mapi id 15.20.8813.024; Tue, 10 Jun 2025
 09:14:05 +0000
From: "Wang, Wei W" <wei.w.wang@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>, Robin Murphy
	<robin.murphy@arm.com>, Will Deacon <will@kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [PATCH 4/7] iommu/vtd: Split
 intel_iommu_domain_alloc_paging_flags()
Thread-Topic: [PATCH 4/7] iommu/vtd: Split
 intel_iommu_domain_alloc_paging_flags()
Thread-Index: AQHb2Xjr4eVgiCIiukCgfRgVbtdQfLP74qTA
Date: Tue, 10 Jun 2025 09:14:05 +0000
Message-ID: <DS0PR11MB63735BADC131F8AF05B98B89DC6AA@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <0-v1-20c73f153f4c+1895-vtd_prep_jgg@nvidia.com>
 <4-v1-20c73f153f4c+1895-vtd_prep_jgg@nvidia.com>
In-Reply-To: <4-v1-20c73f153f4c+1895-vtd_prep_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|IA3PR11MB9253:EE_
x-ms-office365-filtering-correlation-id: 63d9976b-1268-4681-eb0e-08dda7ff25f2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?sLfYyGfF4COX1m9GeH67dWefsPJp0EyAoZpvOTrRyT5kzQdh6GcFej6TuU/M?=
 =?us-ascii?Q?UvUqyYnMXOV/BCbhYXjphyOoH5maS7l82XBt46vkkaZ83ucRvVdO1ez7r0dg?=
 =?us-ascii?Q?inwkN2+Zr6trHcPENOCHW374qY0JMel7r2IEEUbhIxKuvvMgtjrn76EcaRjy?=
 =?us-ascii?Q?7+Mvjbsu3aaxRrkuaVtjF2BV1KfeDlnSQcRinBpAa8L0ctwJp5h+S/HDs3vi?=
 =?us-ascii?Q?QsSlx7Gah/5ppKhcNPweeHPJP0OeMuHWFI3gDh8E7jTNg/ON3zu6dQS3mtqg?=
 =?us-ascii?Q?Vgtc/kMK7O+UdMPqHaYBmEn4ncFIXaQWu1ZFmw30+1uMzBAppg7M/kLusFzN?=
 =?us-ascii?Q?JvzHxic6iiH77N2JBICVkYhwnf9NmBVgc01ob2Fx19EVi0vK7rrPTXnPMvQ9?=
 =?us-ascii?Q?4m4VzgVxtnanv+7hraIlUT6N/GOZQmz+ltGrHqDIQ7yo199eZLJoe3ssXRo8?=
 =?us-ascii?Q?m3i32c7giSh1gtm5JZubUFlPsb8eyL6OmFQ6jEjfpHSICenuUyAXbHg7qPzQ?=
 =?us-ascii?Q?hC8E6ZSD1Ch/fWWtUhhBpoqfONvRsoj1SlZwMP/aJJJJRtpqXK8TB1xyix46?=
 =?us-ascii?Q?JilyYi294rqhpMvgMONNF25Qinr7ZpAoNddL4+VEC/Bui4JgWxzy3gERK/RD?=
 =?us-ascii?Q?OABP+N/eAtMmWt+BTJyp2Cs4oYjj9LzYEy40X/mztMzj8o2xq/fWRIsxXz2t?=
 =?us-ascii?Q?doxduFoYxQYboJret26wfuTyunhIuqj+8e2Rlile8+X/sXnvxS4aJyOOU2pL?=
 =?us-ascii?Q?TuHlLsF9r1NVG8FFkGd1IUhC9ErtLxB7nz8p6N53t81OVv5f0T1TWKG9Ch/E?=
 =?us-ascii?Q?r9OCsygzl10+r281QBI9Ag4m53++AUjQXWzgqdnVupVX4xqFpcoXTnymngbm?=
 =?us-ascii?Q?S2ITU4/C+GLRI8SUPN0BtxTt0SxAx+m8qH1ivzw0fOEdFQJN/E7jNMqvqa3K?=
 =?us-ascii?Q?zvU4Tqt1afGcrBy8/cl1hf9xPFxWo/sQA/N4Yh7GtmVZwSX22kRZI5fNyHYw?=
 =?us-ascii?Q?yNwg3BOMCZpP1xkHDSXQsQwyzE2O8iNk2cx6JKRj+TXHcSncDA92gMonlbMi?=
 =?us-ascii?Q?IMJ+oYGuzY4hoqPD85kpmaFRA+9w/lgT70hW+I4HJiMhWXjSTBuesvg4OAmv?=
 =?us-ascii?Q?FIDng+a+niSFf4ogO8HZpUYum9MsP8SlmWq1B5uGVGWll43cBszNckmTgfvq?=
 =?us-ascii?Q?D2cVJXKfwpeMB3jfyNJiUBuo+mKtcQY3KzqkjehDDzf4desIRSWraicJmNp3?=
 =?us-ascii?Q?JjaR9xsBa2m0R0szo87vkepYfJQycZPwyvr4Bfh940jizXz0Gn2T9zIVNBDN?=
 =?us-ascii?Q?+NVJMpJkpAVojg5+v5moHZNBEOKPsSDKR7Zv9NpSFHLSi1oQB7YWzJet0ht4?=
 =?us-ascii?Q?tBtTdwn0RNlKAIghcYkpEikR+e2AsTYNK4LO554j7i/6JTmeDGh8VveXO3Oa?=
 =?us-ascii?Q?Yol18Os6aV1+fTeM3uDX1uthoNPFn9RdK+o3Kbt/1y7/9uiFAyX/khMq60vA?=
 =?us-ascii?Q?orV1sr9XLKvuftY=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?c56XVGJFpmIoJvrICIPAMqOFlNLXscy7G0o6U90U8aFUpTVwdtBHaKzF1WI4?=
 =?us-ascii?Q?PHiXHz5b9SlGlhJxPxQEJdaHxfljBNffV8JG0q/LlrZbAlPGeoGJLHk9U37B?=
 =?us-ascii?Q?m4Z31wrNyZXlHY0IGWVbm2HvdyzymAwAnygaGb1vfwQJS9EET9LU7dE1Ows3?=
 =?us-ascii?Q?DEuyRQBhV/MJg/mZRQu7FqdhAj3JA3xsVm/Vxydm5RoXybBdHk6Md1waheiP?=
 =?us-ascii?Q?jT5xRhdxKYg4w7Cpyx4Nrqvzumka3hnBOYrwEBd7OLjtnKjMidVcQIwgMf4Z?=
 =?us-ascii?Q?zMBe6lwoF7En5lC3JP8iMJO/xfJIpe9QhoAwotLkaZKlCIBw+EZZEa2Gwj/7?=
 =?us-ascii?Q?EJNCH3vY/dISSJUadteu+fSDaie1oDS6K8MxW7KuqhzBlrvvQSmG4Yj4yNRQ?=
 =?us-ascii?Q?7otS370tHCIe0GTRco6lj2XxVRTQo3mUaB8YmOZUhczyG2CuAe/V/QDImddW?=
 =?us-ascii?Q?faGCWaTUndUXKIsvzn+8JvU3HjyYqE8vwavLREjysWhzEQWDztNH2Npc4veG?=
 =?us-ascii?Q?ZYDfZ5Sovu1jaWYWzDRvuK2momx9lsy0Q24uJTQm5o9CbEG6aW9hLy9z1o5s?=
 =?us-ascii?Q?LI/lqxUEVAKA4npefo3S+P61pHdkDJnWW6F1ucADFGNOHpretoxfe6mgG/U1?=
 =?us-ascii?Q?R3GuFFrQlPAzrFvNj7HwjHT9jdzAW5n6/0YhEJepkZPxZlh6yVImqJB3FKaf?=
 =?us-ascii?Q?G42T1WE45L+tstDQWYVOo2Ids/bGq7Xjq2ivAUd6vziKAk1HhM0wBoUqKycI?=
 =?us-ascii?Q?VTCRa0W88FVLkjxbzoM5CL8XNgBc6owaMTBZ0iF2hagZMKx8F5lN5xGav2DZ?=
 =?us-ascii?Q?JBw4Pyil8NYoOT5LSc8UPefjG20svzU0vojIwVwIMjm/DsI8t4gl9RAdoV6Q?=
 =?us-ascii?Q?YSYq65PSiKlyWnDzeN11BjkfJ8VQrLuwwWAF/fddpkpmyt5WsfBXcwk3kQnY?=
 =?us-ascii?Q?RcPwGJYw6JnOUCjEmAiVXX5JEw8Mozx1yc+Hxkkv0x0O62DlO5QOnkC+ihaE?=
 =?us-ascii?Q?j5Dt2IXwOopzkLO0KCqCdUduZ+ns0r+WsRD1Pw3gxNuC32UmuuNNuaYSBzgT?=
 =?us-ascii?Q?Wz3Erh0FG/RUh4trf3QJvEOZ9hVN5FIVy9BjQMUBLavFxbPFspl0J/Nd1sJ9?=
 =?us-ascii?Q?7l96A4gR5iRNKyCqpREa6rGfsi4a8B5ImHb8YA+kQlh1ubhuKsH061SFvoKM?=
 =?us-ascii?Q?DIY/Z5vyiT3LzjcrFhUyCAh5MQusuBCUfAgVZd9+a80QvmQqarQQY8iI9GOD?=
 =?us-ascii?Q?LEaqcOjCbfUmGE5viu1iDtsLqQT9qlNmQ/8ZlDg+JeEBZBDgS9O3oK7BIslr?=
 =?us-ascii?Q?wxUru3Cq2MCVCjK49cr8OwJIaNKKktPs8b4UMVgsjOmuzBo8Fct7a1R6rdBn?=
 =?us-ascii?Q?vRg1zH1nguS1xLexVbqhfJA6J12XAAPec1aRHgw+kXCV5FBQAP6O9O5TW2NJ?=
 =?us-ascii?Q?XkZFFdJsjMsN4Jh55gFrCfBIJKyLh2UI0/Y3J4MrnE/BV86npJOvQDnn3Ybf?=
 =?us-ascii?Q?eKATZ+yCKp2jEMenPo1z9cJORlL+zCbZWfVckC2VRDeNj4O2WvgrGqB7u7c7?=
 =?us-ascii?Q?xjzx7aa5SQRJ0d7yljHwJS3+Z4uWhHvlo4jauDzy?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 63d9976b-1268-4681-eb0e-08dda7ff25f2
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2025 09:14:05.1430
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Rr2GDtwTC9e0ro81FJu6y+CYxFaNNbMLPElkFKje3Rk6a5n4Xa3cucBuJlymUW9Pse/q/H6rGGg0BLIx69kdxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB9253
X-OriginatorOrg: intel.com

On Tuesday, June 10, 2025 3:58 AM, Jason Gunthorpe wrote:
> Create stage specific functions that check the stage specific conditions =
if each
> stage can be supported.
>=20
> Have intel_iommu_domain_alloc_paging_flags() call both stages in sequence
> until one does not return EOPNOTSUPP and prefer to use the first stage if
> available and suitable for the requested flags.
>=20
> Move second stage only operations like nested_parent and dirty_tracking
> into the second stage function for clarity.
>=20
> Move initialization of the iommu_domain members into
> paging_domain_alloc().
>=20
> Drop initialization of domain->owner as the callers all do it.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/intel/iommu.c | 98 +++++++++++++++++++++----------------
>  1 file changed, 57 insertions(+), 41 deletions(-)
>=20
> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
> index 72b0769c391008..6987a46c2e8421 100644
> --- a/drivers/iommu/intel/iommu.c
> +++ b/drivers/iommu/intel/iommu.c
> @@ -3267,10 +3267,15 @@ static struct dmar_domain
> *paging_domain_alloc(struct device *dev, bool first_st
>  	spin_lock_init(&domain->lock);
>  	spin_lock_init(&domain->cache_lock);
>  	xa_init(&domain->iommu_array);
> +	INIT_LIST_HEAD(&domain->s1_domains);
> +	spin_lock_init(&domain->s1_lock);
>=20
>  	domain->nid =3D dev_to_node(dev);
>  	domain->use_first_level =3D first_stage;
>=20
> +	domain->domain.type =3D IOMMU_DOMAIN_UNMANAGED;
> +	domain->domain.ops =3D intel_iommu_ops.default_domain_ops;
> +
>  	/* calculate the address width */
>  	addr_width =3D agaw_to_width(iommu->agaw);
>  	if (addr_width > cap_mgaw(iommu->cap)) @@ -3312,62 +3317,73
> @@ static struct dmar_domain *paging_domain_alloc(struct device *dev,
> bool first_st  }
>=20
>  static struct iommu_domain *
> -intel_iommu_domain_alloc_paging_flags(struct device *dev, u32 flags,
> -				      const struct iommu_user_data *user_data)
> +intel_iommu_domain_alloc_first_stage(struct device *dev,
> +				     struct intel_iommu *iommu, u32 flags) {
> +	struct dmar_domain *dmar_domain;
> +
> +	if (flags & (~IOMMU_HWPT_ALLOC_PASID))
> +		return ERR_PTR(-EOPNOTSUPP);
> +
> +	/* Only SL is available in legacy mode */
> +	if (!sm_supported(iommu) || !ecap_flts(iommu->ecap))
> +		return ERR_PTR(-EOPNOTSUPP);
> +
> +	dmar_domain =3D paging_domain_alloc(dev, true);
> +	if (IS_ERR(dmar_domain))
> +		return ERR_CAST(dmar_domain);
> +	return &dmar_domain->domain;
> +}
> +
> +static struct iommu_domain *
> +intel_iommu_domain_alloc_second_stage(struct device *dev,
> +				      struct intel_iommu *iommu, u32 flags)
>  {
> -	struct device_domain_info *info =3D dev_iommu_priv_get(dev);
> -	bool dirty_tracking =3D flags &
> IOMMU_HWPT_ALLOC_DIRTY_TRACKING;
> -	bool nested_parent =3D flags & IOMMU_HWPT_ALLOC_NEST_PARENT;
> -	struct intel_iommu *iommu =3D info->iommu;
>  	struct dmar_domain *dmar_domain;
> -	struct iommu_domain *domain;
> -	bool first_stage;
>=20
>  	if (flags &
>  	    (~(IOMMU_HWPT_ALLOC_NEST_PARENT |
> IOMMU_HWPT_ALLOC_DIRTY_TRACKING |
>  	       IOMMU_HWPT_ALLOC_PASID)))
>  		return ERR_PTR(-EOPNOTSUPP);
> -	if (nested_parent && !nested_supported(iommu))
> -		return ERR_PTR(-EOPNOTSUPP);
> -	if (user_data || (dirty_tracking && !ssads_supported(iommu)))
> +
> +	if (((flags & IOMMU_HWPT_ALLOC_NEST_PARENT) &&
> +	     !nested_supported(iommu)) ||
> +	    ((flags & IOMMU_HWPT_ALLOC_DIRTY_TRACKING) &&
> +	     !ssads_supported(iommu)))
>  		return ERR_PTR(-EOPNOTSUPP);
>=20
> -	/*
> -	 * Always allocate the guest compatible page table unless
> -	 * IOMMU_HWPT_ALLOC_NEST_PARENT or
> IOMMU_HWPT_ALLOC_DIRTY_TRACKING
> -	 * is specified.
> -	 */
> -	if (nested_parent || dirty_tracking) {
> -		if (!sm_supported(iommu) || !ecap_slts(iommu->ecap))
> -			return ERR_PTR(-EOPNOTSUPP);
> -		first_stage =3D false;
> -	} else {
> -		first_stage =3D first_level_by_default(iommu);
> -	}
> +	/* Legacy mode always supports second stage */
> +	if (sm_supported(iommu) && !ecap_slts(iommu->ecap))
> +		return ERR_PTR(-EOPNOTSUPP);
>=20
> -	dmar_domain =3D paging_domain_alloc(dev, first_stage);
> +	dmar_domain =3D paging_domain_alloc(dev, false);
>  	if (IS_ERR(dmar_domain))
>  		return ERR_CAST(dmar_domain);
> -	domain =3D &dmar_domain->domain;
> -	domain->type =3D IOMMU_DOMAIN_UNMANAGED;
> -	domain->owner =3D &intel_iommu_ops;
> -	domain->ops =3D intel_iommu_ops.default_domain_ops;
>=20
> -	if (nested_parent) {
> -		dmar_domain->nested_parent =3D true;
> -		INIT_LIST_HEAD(&dmar_domain->s1_domains);
> -		spin_lock_init(&dmar_domain->s1_lock);
> -	}
> +	dmar_domain->nested_parent =3D flags &
> IOMMU_HWPT_ALLOC_NEST_PARENT;
>=20
> -	if (dirty_tracking) {
> -		if (dmar_domain->use_first_level) {
> -			iommu_domain_free(domain);
> -			return ERR_PTR(-EOPNOTSUPP);
> -		}
> -		domain->dirty_ops =3D &intel_dirty_ops;
> -	}
> +	if (flags & IOMMU_HWPT_ALLOC_DIRTY_TRACKING)
> +		dmar_domain->domain.dirty_ops =3D &intel_dirty_ops;
>=20
> -	return domain;
> +	return &dmar_domain->domain;
> +}
> +
> +static struct iommu_domain *
> +intel_iommu_domain_alloc_paging_flags(struct device *dev, u32 flags,
> +				      const struct iommu_user_data *user_data)
> {
> +	struct device_domain_info *info =3D dev_iommu_priv_get(dev);
> +	struct intel_iommu *iommu =3D info->iommu;
> +	struct iommu_domain *domain;
> +
> +	if (user_data)

Curious how is this user_data used. I check all the drivers (intel/amd/arm/=
selftest),
seems nobody supports it. It seems a bit confusing to have it everywhere wi=
thout
real usages. I had a plan to remove it from all the interfaces (not sure if=
 any
misunderstanding)


> +		return ERR_PTR(-EOPNOTSUPP);
> +
> +	/* Prefer fist stage if possible by default. */

fist --> first

> +	domain =3D intel_iommu_domain_alloc_first_stage(dev, iommu, flags);
> +	if (domain !=3D ERR_PTR(-EOPNOTSUPP))

Should be "if (!IS_ERR(domain))" here?
paging_domain_alloc() could also return ERR_PTR(-ENOMEM)


> +		return domain;
> +	return intel_iommu_domain_alloc_second_stage(dev, iommu, flags);
>  }
>=20
>  static void intel_iommu_domain_free(struct iommu_domain *domain)
> --
> 2.43.0

