Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC5C02E92B3;
	Fri, 12 Dec 2025 04:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765512568; cv=fail; b=kzffH+a2fEPsSejUxoBWeHE+lCCTLGVzcRFHsgTQ6TabKYOJssoyngWjv8AgitSrK+bLGkCURvD/oV+yGxOgVDZQVHYLfU4H7jPnxEwYzKYyKCVebxE+Bgv9j9+Lwk2wLr6xiJQYOOzUZnBrQF4Eg9TlhQDJeUyhisKte+xT4nM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765512568; c=relaxed/simple;
	bh=5ASsc0OG0DiAqGa/5GfvRRwMW5czEWAQxWkfkV3UHTs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PSGMZTD9BRD9dKhRqDRV4reYj9Sk8hzogcUzq4KUT1rJKM193zHWJBuJw9lxuIY720M9kGJKgA6Rhsa2TyHjiQqEz3R6PZoOc/MOGV2mORTvghq+qbeTq2ltNMayYKNcQTknrC7MtumII85EVu1F0mSjC+h86+Dt7nVrI+OWTFw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FqqNBMmL; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FqqNBMmL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765512566; x=1797048566;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5ASsc0OG0DiAqGa/5GfvRRwMW5czEWAQxWkfkV3UHTs=;
  b=FqqNBMmLRuFomdpOUKSsUheM5W4zChpwZ5MVxn12J9AKrFHkhJs5CmQE
   ptwtZkdxd57rvfWlZbPdNFL01S9Q0z1FxHD3Esmw06k/xPsULsFSZ1FVZ
   9Ea1ixangYc9LpGCqK939CT5lDo7DIvVEDctcxuCwVHQWFKAcQXEUo4Ha
   t+DfaYgwXadrkWlNg7OJSNf3Y6Z5cHuqY2oY6lrnKlVHO+JRpl1qKNoXL
   ERdcl8NHR17M/3MOxTBRWgrjV/V/CtgOPq76Lpi6VzBCee8eojyZ7gngs
   m34YZAcmYWAe0cQ2APjTfIXWZi0o4D4lVHHNQkol4X91WSym8YCzsf9MR
   w==;
X-CSE-ConnectionGUID: 6Vk6ChGPTqmIPxr9OmnFcQ==
X-CSE-MsgGUID: 7VzMwVX5T5e5nk4hpMCxVg==
X-IronPort-AV: E=McAfee;i="6800,10657,11639"; a="67387807"
X-IronPort-AV: E=Sophos;i="6.21,141,1763452800"; 
   d="scan'208";a="67387807"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2025 20:09:26 -0800
X-CSE-ConnectionGUID: dJjQmU2NTN6Xm1dXEqfgPw==
X-CSE-MsgGUID: hc2UKrkqQru9pEGb3Luctg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,141,1763452800"; 
   d="scan'208";a="197030834"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2025 20:09:26 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 11 Dec 2025 20:09:25 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Thu, 11 Dec 2025 20:09:25 -0800
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.32) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 11 Dec 2025 20:09:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VBvkE78cimL4JhoJ3d/LPTZ0EqjeXo9By0/RKcLvq0t6oUQ18vS9Dcx6s2UGGiIotopN4YKX8uogs2BGAlQSCvi7QSga14iajfA/Bd/4iwFS0NGq4MmPdh3R9H96cE+OXK4zD+TrlMLsc2oqKrN6A2RaiCye9OTQKGp99z5PnvjSXTH1+cBSoQwFKhiTACggD4Ie/lBPY9rg59A+dipS04TyZSzt9mg6B6O1UpuhsqEJSQGF40F+N064K97DuKSe4TDkvQV8E9ZhehKHrBOvNh9t5vaxcBC1lesLpha+WjwC3Zgv3BgtC+dH1LNah/bt97EUngAo72zrE24Yi9R89w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qRsxysydRHZa46SzeUQSc5Oi81aYxnm+WC2BhJp4ou0=;
 b=QTEZVBTGBuTnUi0LFtTd9gJKtv+eWRB6w+i5ecRf6WBwLQc8gUMkI9+kHgJe2ESZ8Wlcw3v49TBPYLNjCoeAPlBpwvG+EbTeDpVRQNFVLli6vBJX7o9DmEIyUpVZGgcIc92NpL06hlH/kIvysasqQCF9iSCG0DZZ7fbUEzzlH2evzRL199am4qtwoq2IsPCchXx4SWg3dlNqqpRCZ3WMiee3ideC9hLrZtY/TneegVVdJMqmOvOLpdKbM4EaeLQ9cmTrGTny7x63zZ9ZLEOcq7I+8NYEw8vmVyf7XQo8guEJMoT0LxJ6kD74TymEOZr7ylHkQBjnxPE3/f0+iMc48g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CY5PR11MB6533.namprd11.prod.outlook.com (2603:10b6:930:43::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.10; Fri, 12 Dec
 2025 04:09:23 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.9412.005; Fri, 12 Dec 2025
 04:09:23 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>, Robin Murphy
	<robin.murphy@arm.com>, Will Deacon <will@kernel.org>
CC: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, Joerg Roedel
	<joerg.roedel@amd.com>, Pasha Tatashin <pasha.tatashin@soleen.com>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>, Samiullah Khawaja
	<skhawaja@google.com>, "Lai, Yi" <yi1.lai@linux.intel.com>
Subject: RE: [PATCH] iommufd/selftest: Do not leak the hwpt if
 IOMMU_TEST_OP_MD_CHECK_MAP fails
Thread-Topic: [PATCH] iommufd/selftest: Do not leak the hwpt if
 IOMMU_TEST_OP_MD_CHECK_MAP fails
Thread-Index: AQHcZkj8WXNmyrD5MU6fOl1f4IoavrUdbYnw
Date: Fri, 12 Dec 2025 04:09:23 +0000
Message-ID: <BN9PR11MB5276728CB8DBD04566B58D598CAEA@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-c8ed57e24380+44ae-iommufd_selftest_hwpt_leak_jgg@nvidia.com>
In-Reply-To: <0-v1-c8ed57e24380+44ae-iommufd_selftest_hwpt_leak_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CY5PR11MB6533:EE_
x-ms-office365-filtering-correlation-id: bdbca9eb-1563-40ca-027a-08de39343bc7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?cB/75+dwiLrdbSWk62XRfS41l66vAJG9+3lwOrWl6nI9X0jBn1jUMKWb+wpA?=
 =?us-ascii?Q?gswr8BVO6AEeQN12sE9FbBl5xGI/vtwF63ZXe8GDoPUOW3nFqKEwFbozdKi1?=
 =?us-ascii?Q?Ww+mWfzrA9GSmy00GBl+hWtiAMykAC6QGmZrgGr5JhzEh2ou3yD4Xdm4dDaW?=
 =?us-ascii?Q?7DCRbL8+SrzSpBxgT8wEdP7ed4F1uxB4/7wrpQokF+vFLA6FF5CjqpXSEXro?=
 =?us-ascii?Q?ZKivoVm2H93kdRZMF2xoNZlZO+3ynWAGf+RlpQz3KkW6MHR9wSlZG0GKAXTd?=
 =?us-ascii?Q?dAAuWtbk8ed8SC+GBgPUHCrVbivIqazzfKuyC+P0PmOo3jLk3brrbUeBT5Li?=
 =?us-ascii?Q?Tq5ZopgUr8mDcAJTGbdOXvSbw2ck72D/sCbGr9b4W2jGnEQzZpYVGybMWzpT?=
 =?us-ascii?Q?qRuD9/WWamx48wXvozV2y5CliV0qs5AfEzjclGAMZwhqfQwwI8GJ3UgrRXic?=
 =?us-ascii?Q?iIYJiopkIxa0kQXhYpa9q/OA6idBZmyR+eZSZ6F6vuOcCEgeVPJQJ4mX0X5h?=
 =?us-ascii?Q?rMc5j0jeY5W3moNKGkUtI7c747P6X6+Pe+PS70VLUA4a6rvP4O1P5G1HhTLQ?=
 =?us-ascii?Q?HSdGKuoqtkkWjBIP4Ywe90SZKKtMx9GbGR7eELpnxBFMblA7u/9ZzyQAb5xA?=
 =?us-ascii?Q?fuWFI5ZFc2nu4p6m14Ijy3EPxwSPD/iCNbVYGE57R3GJxezJ5f3mWBFOAQpw?=
 =?us-ascii?Q?GbkhYK2lSqbWXacz3udhzCr4mvTkMugD9w46RUH7+novUquvP60NtNKW1WYq?=
 =?us-ascii?Q?HILWP+vjdikdTJKCAmVZp2C/D0gjlo/eLeuoakTQk4zrLlNAvX5r2Xw0hMwM?=
 =?us-ascii?Q?mssS2NAhfcfp8SSv8JFodI72nMrBDEx723m+WwwZ1UlW7AHL8Y1eRxLe18sx?=
 =?us-ascii?Q?NOaEn6p1tl20LChTFUAdZHwSD+Gsnht4Ftvq1H8fp0A5mJFQ8RYbPjOvLQjq?=
 =?us-ascii?Q?BFV1n5QeOzHZjlSpcs/LY+tZXtn84Up+ExlJyxuXNmZDCsXjT8ihYD6cGl47?=
 =?us-ascii?Q?cY8bdn3KXUBbqnVismlF4NB9tSc7CMb4iD61JafmOlEXq7kE1lxzI5lU8C3V?=
 =?us-ascii?Q?EO1XI+eIbfJ7cGm5tYSDw1HMIQWKOT/oK3Y6DWX62mpWuAT/ECMQvMwSRIl3?=
 =?us-ascii?Q?I0MxZZhx/fgjdSJFe1TNIx8xhlJoTDtwNFKpqWhXSiMqsJUThnuaMZZ5nQLv?=
 =?us-ascii?Q?GAXuvmPV9FIm9uly61sGtaGPdB8Iege5nVvICcIlZmrF53NtB2Fn/UOTZKLG?=
 =?us-ascii?Q?xnyAOF9TDYxrxjoR/wc4+gvyewltGbqVe/pinS9rVJravSwfW8FUKwWHKLnX?=
 =?us-ascii?Q?JOtSooUJYxEYXZvst3V0+unOTgGqGPj7+cn/eYSZOJxriO+8oS//ik8tsj19?=
 =?us-ascii?Q?soNb83vE5vf0MukpmNH1Do734E05sV1kjPtGA8XVwpb/cx6rLSP0QE8XTGg8?=
 =?us-ascii?Q?97NxKXqFB666HrxnErb9YKychKqM+ha7r9ehD0rE8RAIR8vYcOqslWQvvXCx?=
 =?us-ascii?Q?3F9YeWDEHkOjHvmvwNVVvaxNbArQs/4Ro9Yq?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?FNvr8Xe5NtsViF0OX7lW0/+8h/z2W6f6F95MReWpsLWrjcKBDslEzRtob0Kl?=
 =?us-ascii?Q?7tcQ1vLfGXMHFuWPTSXw3bQldMkZ37UUSfKaaIEhxxbGvSx6tK2/jM6yo6F9?=
 =?us-ascii?Q?zy6ORPsoKwKZMfYyVQbU/TIMGWmwzClJ9I2p3g9v4SnQvY9BnSyBSQHbRlPw?=
 =?us-ascii?Q?q5vGQ2CbHEAywmIW577IKKP5fHaHVyxxvlqIhJUrtlB2RZ6IhBUVtWWoX3H+?=
 =?us-ascii?Q?fXYwdn8+oMZDs4xol4HxCQpSnqFPeRJIKHhvFN2Rp4aP0AhSwSlx6g4CagKM?=
 =?us-ascii?Q?FBAj1hpj81xR2A4Z9Dq1pqdES30c9GFI8bea63UOfE1rIW3Zmmswa3ZMdklL?=
 =?us-ascii?Q?HEygAzil2eHCbs8jQqwfnKltwDUeHdqwjBQTjcwSk2riW6soTXsx1leizgFU?=
 =?us-ascii?Q?AAwuy5Y4qUSBMJPAA0+36VZN7mRuaD3uDAoDPswLdpDPHu05ISGSy/RMqfij?=
 =?us-ascii?Q?g9+rdkdDKeNBv4f8Bx2yGZU8OpNi3IC8MKJ3yk4O+pLifgVce8N+2//XfmMT?=
 =?us-ascii?Q?0CCQOC+eRCfM/Lli8oDQD3u8lM+t9YvaEBO4Rem8TehfpQGjQeiL1QaDHAn6?=
 =?us-ascii?Q?6AHuBYeJ2fJcTTtaQlEQ/FhF5i6TfiISOby4h3H/NYWQGTieflzB7R5E2Grm?=
 =?us-ascii?Q?QdRBJYyUJ5lOXUU9p+YgkL3M506ZJQXRgXRgua8k/jzuk3wc7eKkvIgizjhP?=
 =?us-ascii?Q?jTvh1LC0wUilIFcMq6FAPrO0fthMAWh4XeFSd1Rkshfwo77+8VhHJwhZpP24?=
 =?us-ascii?Q?7ErxdKivZCLrfY+gJkDtKdh9bAh+tFkO7oI+HEIvuNy1KRhMgB/Ic2eB2sm3?=
 =?us-ascii?Q?/OS9aEEfdOV/J92lULn4l8OPW9Em9FkYpKiz+MPGYX8l+MYLceB/iG0NvSBv?=
 =?us-ascii?Q?6zXEgNrO4AupekMdNqrx+gA/nmOrBM02U3WLZ9jiaBQJ4fEodHAi3h3dZJuf?=
 =?us-ascii?Q?kL16aILQB/dpEHZplfW6r2pShZXG8NeaUj61rS1yvsp5rCuiBQyf1La/1Hq9?=
 =?us-ascii?Q?RhXR+dKHpRhOFVwKC3NA8cjCaDN71k5afPs003bQX6pk1JtTwDDOfFrYbtop?=
 =?us-ascii?Q?Pq/FAzbPGsD9RuYVMvH1iFb/a7Y25/kClE6wtGYQVamWi0vJ1GfMelaW7aiX?=
 =?us-ascii?Q?OttD4QxaBce3mZx361DqOm/j58U5VcPNyYhHCmX4vWa1qhhbT7MSdd9DoK4+?=
 =?us-ascii?Q?GqE8vSiCyOVDRrYikRlcIgLQY8kyEDX4O/fG7CAUP82KSZUxTaTufvmSSn2W?=
 =?us-ascii?Q?+QtTSbkM7XEyq7JkI/m3nyZNbupucvjfBaOZDBxfuIohCHpxk8xzDJlKc+AJ?=
 =?us-ascii?Q?yR3gaUzdPeN+6rkwWOYSpbWkqeDenLZ3kdL4WE/VbdcpRVH4JpfabOWT8pux?=
 =?us-ascii?Q?U6XhfRUCaUX5cFVovethi6J+u2gr52eANOJ3bedtoefs8KVNkcX3U/XRNZ3b?=
 =?us-ascii?Q?r/ERxjZl8WvrdBEW8zBzpPdOceis2BvZx24mOOlohHkZK6gt176KcJ6xipb8?=
 =?us-ascii?Q?F59Na7guInNipXUZ5YvZ4dP+Mxy9ox7MC2AnyHGitkKPcsIFNbhQaeSakR9v?=
 =?us-ascii?Q?o2lzXY51inmz3QWbVOGfYQv3RN7UNCe7xPmSga2Y?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: bdbca9eb-1563-40ca-027a-08de39343bc7
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Dec 2025 04:09:23.6673
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EPh56b2A6KmSvRaUfsKEezm7dhZyOIj2rDVF/y/ytLY87h18rPQytHeDvF73Tx9ExO4MgXDQVThQ1pd1nOQDHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6533
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Saturday, December 6, 2025 8:41 AM
>=20
> If the input validation fails it returned without freeing the hwpt
> refcount causing a leak. This triggers a WARN_ON when closing the fd:
>=20
>   WARNING: drivers/iommu/iommufd/main.c:369 at
> iommufd_fops_release+0x385/0x430, CPU#1: repro/724
>=20
> Found by szykaller.
>=20
> Fixes: e93d5945ed5b ("iommufd: Change the selftest to use iommupt instead
> of xarray")
> Reported-by: "Lai, Yi" <yi1.lai@linux.intel.com>
> Closes: https://lore.kernel.org/r/aTJGMaqwQK0ASj0G@ly-workstation
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
