Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE9351ACEAF;
	Fri, 13 Jun 2025 09:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749807177; cv=fail; b=rGXNjMr0yyRbJi3L0LD+lwc4zr27cwvdMkhOX9jyzYgfbk8wZVA+58r3jUItk6v/0NQmBYJWL8PiEQUHTmv+Vxcu4KIuFXpm7QQhXbaDUrvCIg63DHvEGbRdBXmMqlVOKGILFRw9N1Nzks5FiS+yQQlDslbv0KzZ9SBGbgSsWQQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749807177; c=relaxed/simple;
	bh=S/YUyWp+h2pzbqwcIuzeTlVtvojTFFtyv/m4ht6f8Xs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Upz4Sote1wAzuFF3pqoE3rrivAQJHqIUAGX8oobfxOY/ttVRuQdWVXRScvhCU2l1DJF5trwABvIlEqdv9ZCimDq7cwA0SFmySHjETo+6qwpsWddADoGOk8klCjmd/xnp1gE/+Br9q8Rwlg1yF5hiCQ/akruHWf7VZWeHHiko7vQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CBYUvCzL; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CBYUvCzL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749807176; x=1781343176;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=S/YUyWp+h2pzbqwcIuzeTlVtvojTFFtyv/m4ht6f8Xs=;
  b=CBYUvCzLuAA44AZhmijJVAMg/7tuQqLNKVW2Z04lXz9EbCk+zE/xi7oP
   tpEk7WoJ5/1dkiqwHCNMA9Mu4cbbjqvK16cqkVtMdgZHiOXBzROaXCisZ
   P7yFtBKSgUgIgGzvSUVdeohCqnYQuvnwMMpcs16E6DtjQjYdYlRKM1itX
   PFokEtuMAhXwNGkijj2A68cXmIDD0ViDOuF0ZrfN06iO6oOD10QSxe0PE
   JjT+0oglnhcpjFyGwRC/943NsFztksgwumIuSWOyczr/Fo2/0cBIvXClF
   aqn/nJMSTfci7SWVe1nU8GHGd/TXosfd2HJuw1smp6F+2BYS8RqzSX7iP
   g==;
X-CSE-ConnectionGUID: VY6One63SvWqaSPJIeL+2g==
X-CSE-MsgGUID: vri4RBbGSKunxlziwMWSSg==
X-IronPort-AV: E=McAfee;i="6800,10657,11462"; a="51244247"
X-IronPort-AV: E=Sophos;i="6.16,233,1744095600"; 
   d="scan'208";a="51244247"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2025 02:32:55 -0700
X-CSE-ConnectionGUID: X95lQKhES0q601pfVQgIAg==
X-CSE-MsgGUID: liTMxnniSNK90mUs9G3p+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,233,1744095600"; 
   d="scan'208";a="152545529"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2025 02:32:55 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 13 Jun 2025 02:32:52 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Fri, 13 Jun 2025 02:32:52 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.59)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 13 Jun 2025 02:32:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MA7yosVcntBstgtxJbDA0hNGCdFpYRswm/CZ06wpMpXq/6eZ7OgLhwMzRbB3/U4e/immM4kOo/UX2AFa9LQbylhSBzD26jWYpZ/8yEeOl51vQoBOh6DoUPw6TUFYXSLtDX8W6P1CTEIjDNVkXj3GOb9zImd0hGLL9XzT2CJWZb6yvT/zz7/ruFmffPOTujTg8bO9L1DpydPyazvtKKDZ4r5lMEN5meVTGU0KCzwwADVpVm1tgTDkVkVAx9K72HSjdSgGj8nnpLsWpdclTEXNgKDR/6kub4F4Uj6OiqwfcQMjV0q7SQECOUBnwbuKxL9TXI0rWzR8o+NiyFl1U3V+3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S/YUyWp+h2pzbqwcIuzeTlVtvojTFFtyv/m4ht6f8Xs=;
 b=w07eY79tM0uhvTYVWzdUUoTGVCIqFeIbgSSnpSulQYW82ReHlZkxgy+V7Lkgo4GLlqLxH3TVzvwdl9v/qUrr7+FtGntpCLP5JI+riOWZoNx7P3g6//VkuquQvCaJRp3VRxCHeWYWo7erwMkQkN+OxtP9i4hPTsBilbyv4NWIONo3sdklhaBoC0/H1t1OgROtqv6Q1kPOEDwj7Ncj2jFe8xYuZApGD+rfuvAstofi+ZZ1M/G6z2FV3SqhBz9FdO6w1zgKL2Jc6/m29D/N7YVYDJ+0WSP8vSid48b9BHM7JroDFCB0CRLDPPW4+Vsxlvih7ySps7OnsPFsz26VwEa+FQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by LV3PR11MB8674.namprd11.prod.outlook.com (2603:10b6:408:217::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.23; Fri, 13 Jun
 2025 09:32:44 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%4]) with mapi id 15.20.8835.025; Fri, 13 Jun 2025
 09:32:44 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>, Robin Murphy
	<robin.murphy@arm.com>, Will Deacon <will@kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>, "Wang, Wei W"
	<wei.w.wang@intel.com>
Subject: RE: [PATCH v2 2/7] iommu/vt-d: Fold domain_exit() into
 intel_iommu_domain_free()
Thread-Topic: [PATCH v2 2/7] iommu/vt-d: Fold domain_exit() into
 intel_iommu_domain_free()
Thread-Index: AQHb26bdrxRqid3oXkG38wqt1ZDbm7QA1NDw
Date: Fri, 13 Jun 2025 09:32:43 +0000
Message-ID: <BN9PR11MB5276A57A7DA9F291B316520E8C77A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v2-e5c01fc5ce82+26216-vtd_prep_jgg@nvidia.com>
 <2-v2-e5c01fc5ce82+26216-vtd_prep_jgg@nvidia.com>
In-Reply-To: <2-v2-e5c01fc5ce82+26216-vtd_prep_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|LV3PR11MB8674:EE_
x-ms-office365-filtering-correlation-id: eac12f14-4f3b-4e8a-9a2b-08ddaa5d400d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?CcIxOeHj8rb9u+gkkfXRhmWYqUHfu4+8UEQPncfIHu1yS+g6FwNtDHtm+GxY?=
 =?us-ascii?Q?uLpQhMVcmq6wmqBit26JpQ701B1ndbB53xEelJzFJTR4VeQe5H6uShQCEKMO?=
 =?us-ascii?Q?MAoD85r3wU2yEm+e69TTBRPpD4PAvyvD2IBUBhlcJQN5LBjeCM89Xj1OMPwx?=
 =?us-ascii?Q?IgQiY03df8At3eiyyuXM42yDyLIGOk6YTv2ly3cD4ox4cnqHR5ynzZXq3dOZ?=
 =?us-ascii?Q?bvV9dQ6uBPYEifNflOjUH8OaEFZ7rlpPAHrFbmD6uxbm+IETU4n6+T/tnK/0?=
 =?us-ascii?Q?yQX2F4LHEixNN6440BmMGBx0a8RKJbtfZINrI5Tz0weFM7VZWvUPUqUl0TBA?=
 =?us-ascii?Q?2HYGnRiO55f4gkzC4JaUwdHsBePgGGKhjC4areonsGCjkwL3Y0BIgiKf57O/?=
 =?us-ascii?Q?V7vV5fNGPXwX3mUlkFTYpJXZM/B7Mw6/6LYENxzJE7D+FpGofM91qG+3PG8e?=
 =?us-ascii?Q?lgKZPNTa56Yf3raTgjWS8T/hCcc+wn32CQqPUyU9E82inOI4p2lHFBJRovpX?=
 =?us-ascii?Q?dehKljEXs8WOJUfwbXjbnC8Yt/gIvXM1bXZteuZQWtjnEjhuFEAiyjO+oejC?=
 =?us-ascii?Q?BpOSvUTdua0gwq/xy1LBgPphxcESNE/XhuDB/0QFoHQf0QVfYh9t/DUiCSFd?=
 =?us-ascii?Q?OfpvD+QXF50ZUE4DXRX3vp4y7dL3P2srU30DcY9uKYGFNTIstYuPb3uWVM+s?=
 =?us-ascii?Q?GWrcUeG5qhO9nJYpBL4FJwKKpkhuHjgL3FePq4ZM+K91zPm66cUDPUADa0qd?=
 =?us-ascii?Q?yvPfX0XlUKabzYQt47u+byh7ZZVMEUgUY4uXYWT86k2peCkPFhgS8bpqRZG4?=
 =?us-ascii?Q?+W9JHL3lVmbT4qgJjGLljm0E/uYsN6ejiOCKp4vhmAulQbii50t28/x8QT1U?=
 =?us-ascii?Q?ud5eb/0LwT8nAGG5zJhjHpuF3v8EF+oTXOqZHcoN6fRB3pO2RMxddLIw1ApU?=
 =?us-ascii?Q?Y24qKGNLkix3zh6kcY8XfGS/MMIYzx2C+lBWx2op3Ws+ytnRf4QDenkiAI/J?=
 =?us-ascii?Q?osNYW4yHZa/mInmvKt+bfqeYcY/Z/U5hrWA5ivVZ/sKNPBn3EZ53Me6CN/8P?=
 =?us-ascii?Q?K/Iu28PpSMQDOdce2Aq0Jur3r1LJFfkKFWnLEpBI0DWQNB4w81lKfwhkVoXy?=
 =?us-ascii?Q?w7ntnjgsMlenjzZ6+rh1sQYiA+CXwluLVHyl6NpvPPhBWz63BomdAvCRqVqs?=
 =?us-ascii?Q?5CAQUv5ArumIHgfbkaoROEKNA37Y2RkkxbcL1tcNsYJDPy5vaRigcmzUiNBq?=
 =?us-ascii?Q?1rWKAb8B7YQj8AWqXlSwjFWJyX2ncENyHC85LSCI0CT2OkYR8Wbuntr2Bqqb?=
 =?us-ascii?Q?Ah2+MWl7WCjSebAJbOz6QCt6nJxd0l7cNj3mc8XzC3/Z3UZIObm0+hfDIh3b?=
 =?us-ascii?Q?4NSvAuzLLDSLKCvOHiAFQwScf9tDHmiOVRkMHkJgb1G8TB/g5QP7/R8pdOW1?=
 =?us-ascii?Q?GokoXTwtiI+Hi8mBJzxspOh+YnL/2RjcUT4liAqfKN3cKEl0yAEYaQ=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Z/cjdYujTi6J3XGjPVcY/6Co6LaStGmsdSu4dQGqpKtHgL4MFFw6WKS1VbFZ?=
 =?us-ascii?Q?hrZwEW6gl2f72Lsi86nxFsRV38zMjVZ5RD8nqN2OKkOjSvLWtkowbm2BNEk3?=
 =?us-ascii?Q?xnUUOEtR8a3yixDf8LYzMdViI5j/96kC0kx0nssx52MYHewS+eGrsQcuiQa7?=
 =?us-ascii?Q?VggOfxukkU3LCIvrRt0nuEjlUKvKNHrfWze5CUOJm4p3ccGp9q11VNuz6XiF?=
 =?us-ascii?Q?ZNFLaJMlJuxBiG0E0KKlV/UqCIiL+L3FL7Xb/CkLh82g3WmXQ7KZy2/ImEER?=
 =?us-ascii?Q?q/kZv240GMbPjxNe9TwQ95NQ8k66NoyEzKlLXdST6I0KIPDmQs16uKKkTJT7?=
 =?us-ascii?Q?ujbH29qN7kNCR/qnDWDM8fFNRL+9RLxRxvLPTjDw86i/JWWHZyIdfZ42Jgzw?=
 =?us-ascii?Q?mv43Nxx3XGzdVMSrMYgQUUzB/NTGJVf2R7sTB3H4qlVKC8fAh7l8inrB3vTo?=
 =?us-ascii?Q?NmnkNJpt637TEY0zgXzMIR+T6FuHWwrtCbygCvHCT7rsI1ZH9ai2wN6wKr44?=
 =?us-ascii?Q?QjdrwF37mZ6BEixoCAqxQkocL1fSZecojBcd32oaAZO2m69NlkDENx92ahwY?=
 =?us-ascii?Q?vu7Md5sZumd+48ApCWE/pFi5g5y6gMTalLQPXTT8+sUZpBSzTLktFtZC1MIq?=
 =?us-ascii?Q?boo7WuLCJHyg7V27x6iY1VzEvQAghu/4MEQcJ4s5Sp4FptI72aBCBq2qgzkH?=
 =?us-ascii?Q?jEaoyR1q/VNbchna6Us7R6zqCvAcdWrqF+9NpyhtTfbhqYufNWLiw2TWGokc?=
 =?us-ascii?Q?eTJPHzdcq0A0ZmN0+qDedy0qTvj1Z0xRiL/IG50Rgskv5kJzEhJGfKT9hIyc?=
 =?us-ascii?Q?lbP+4iJq38hTQ2pdpFUyOr98kxtz7+rCMeNJ2tryT4n9NI77i2hEVYdqQqrC?=
 =?us-ascii?Q?0/JYetjh18f/8CJpXsGwKKNxmZiXSTWvDCsBhJZ5KmAi+v250Dnzv+YPoTVm?=
 =?us-ascii?Q?qjw4LohQBV1c6zJvV1qQRXuwz/eiQ0X1xJRO2Y1TrkChmiPb+UjJQUKD4CIO?=
 =?us-ascii?Q?GUUCijE3EVKZY5IWMgtxhBlg6pjCn/9LC+MPMRwGljjUODpBp+1v+v5KS2l8?=
 =?us-ascii?Q?8khMTkFSgerLFECwsqcTwg7UGPT4sGiCUPgUfxIqh/lcwjDHz9xxJvUkSLQs?=
 =?us-ascii?Q?Dcrx3tIsQ/As5d36YXb1jlsnuEaHXilElPqiAMeyogE3Ijsz7hv/SiLjZF+A?=
 =?us-ascii?Q?BC3bjNeU9vTkOiiAV/JXFezyH8gTgLI5AtyBEY9J7gsMDm0Zs/+u9ouwu/67?=
 =?us-ascii?Q?u65u38l5eI7lTFZPDXrvOqnXR7q89yOnIiHDVWtCa4OaJS399RxbMngW8sdY?=
 =?us-ascii?Q?qoLeHqmNd0qOlczh5kypiNgXhUn1srV+2QGUXkKOCkMvtidgrXzI4njZPIqo?=
 =?us-ascii?Q?cVFotp9bES4MFwBqHlWWWL5upcawEnPpncEPf38UafSNY6XPniXef5X+014p?=
 =?us-ascii?Q?eydxQAzd+LrpAjcz5pLDrbU2HeeykZSkYsxCLLdbvq7mEhz93bajTlrJFREy?=
 =?us-ascii?Q?exXiPL8sU2bz+bS1vFPdAig/rD0a7YMNhkawF6DtJbVRVxMoVBBt1myNzhHN?=
 =?us-ascii?Q?gfklgqE4YNXd3WT+9p/qbMRU7bvV/LFqj2Z4TURo?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: eac12f14-4f3b-4e8a-9a2b-08ddaa5d400d
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2025 09:32:43.9509
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uiMp/CWWdE57F7C18qui6gUJLiHNcGM1JljdIu5mctZUBRTQIhsjdjTGpe0GePiWil20Xh4bJC3tETnaWCjfNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8674
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, June 12, 2025 10:32 PM
>=20
> It has only one caller, no need for two functions.
>=20
> Correct the WARN_ON() error handling to leak the entire page table if the
> HW is still referencing it so we don't UAF during WARN_ON recovery.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
