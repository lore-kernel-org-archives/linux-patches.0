Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0CBA1CD3E;
	Tue, 27 Feb 2024 03:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709005031; cv=fail; b=JhB6ZpcbQ+qIG8UrYDpHvYJ09L9xshiLH5QkHHRayLf0HxHRGX7vXw0ZKp5aI64Bw6m+JVGYpdWhbNfWL7cwYfNqSjUzbk+22QRRlPmNaA+3hsbS4i1FI3xTCrqZlM6l48+SRP1ug5tVWOYEW1yiVslhag7KcOs7r3dt/KCXHbs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709005031; c=relaxed/simple;
	bh=kcTR0GXnLYiGP3p2lNlmaDVE34gCpDj0Z9VhWnIUtFI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZoLE5nyH+NzI/J+byDfVOISrJxy0Ahq2FTdZIp0M8GsnX71WXAmes5zg7WDVwYZo2wxatzT2crKaWvZU0EAr5YMozRjmC+/7g7k+UjLpkTZi2SA6pWOM927V3TwhTXOnu2LQoTBFcvUW80GdSxX2TP0w4JvHIwMoePvMDzT7Xio=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NqoKJibh; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NqoKJibh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709005030; x=1740541030;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=kcTR0GXnLYiGP3p2lNlmaDVE34gCpDj0Z9VhWnIUtFI=;
  b=NqoKJibh7mTTQNTqT7brnW1bVE+sJ/eCveZXuFbrcy6LbFELaA3ckSxj
   ks/Ho9f8S6QRZvLb2133TjdnHerOaS/0HhKaf9PRF8TITzps2V8NNee68
   nHJ/HHJQDDEgZsmtlVGu5ipAeUQiqiwG9WUZwtR6RDA0pJEMT6BkHGK+b
   27yptwNVQIIpKgfSKP3xaIupPVKlxfP3dLzd7o7qvdqKzLHr+HKHq+Bw9
   bQRSUtjuSEve+3/JdtEizUTz5pwmjudsqSOgLH/yb2DIxeo1SSfY/z5ok
   7aLGm0z0nfGkSc7h9kGT6ufhCVAhLCew5db/lSTjzzad4xdczK2ewuq5F
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10996"; a="20773970"
X-IronPort-AV: E=Sophos;i="6.06,187,1705392000"; 
   d="scan'208";a="20773970"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 19:37:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,187,1705392000"; 
   d="scan'208";a="6865048"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 26 Feb 2024 19:37:09 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 26 Feb 2024 19:37:08 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 26 Feb 2024 19:37:07 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 26 Feb 2024 19:37:07 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 26 Feb 2024 19:37:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gCqHBnN5dhJNn+PGddOnBf+bJ6shulXjqWKsVdym81wbEjIKwTGhRRuQoO17ZOQve1kRyUybv9gP3Hv8cfeOewQ1jIlagCc+mvgge28V14iG41AAeZjqEQyx7Ma7+tBexAjB6jGRPPDjtYLBAg9jXJvXptmdD6KIxFwXcQqtdRmarZzTjwcU+KptsrdoMt2KrWfTHKaLd2c21EaN7PIlqu4l77p6liSxbyFKQWaQWlcEqw42zVPkTqdA4Pld8NXbpxTNrE5YvujnxKn9KbUsgXwE7fyQACpavng/ngwuD9B9JPO9CXO1mZwuv3naMiTqY/f6286Vfar/zzeI4gi1WQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IldeuqsQiWt4K/wA6PJa0duzlllkpufg1z3I4+Wbs+s=;
 b=jx6/2HBj0bdBROI6f1A764cP2rhodZ3trSNyhj/iMPZLnw40qqBgiFoUh+ir5ElqUuX5jcJ9GAZiEEiEVuRnnK+ye+wwP1iXfWCfVXcJU2VF4b9zQAjnvpfdvmdrKRzVquA8Rta/PhuczoljXpQuhSyMkBzGv6Uh6jcbZ4hac54WZuVYulPJxthPj+N5zAbYnpD0rrmoEUx7ZBHJ7LgsSm0UlXMI+fquQemueZdqRq4HL0fpAdWs5Q3IJNIwFKk/93KQE4fslUBGgrvz4WJEOZ/KuhSrfLjbp+r3LZaLtgxIAJ73ATAGXojgp5rQ21NAJZYHvZyvgGgXJ5QT73rYjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by LV2PR11MB6069.namprd11.prod.outlook.com (2603:10b6:408:17a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.23; Tue, 27 Feb
 2024 03:37:05 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b0e3:e5b2:ab34:ff80]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b0e3:e5b2:ab34:ff80%7]) with mapi id 15.20.7339.024; Tue, 27 Feb 2024
 03:37:05 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>
CC: Joao Martins <joao.m.martins@oracle.com>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
Subject: RE: [PATCH] iommufd/selftest: Don't check map/unmap pairing with
 HUGE_PAGES
Thread-Topic: [PATCH] iommufd/selftest: Don't check map/unmap pairing with
 HUGE_PAGES
Thread-Index: AQHaZohZXnDm7nORFkq7giwPuqaBmLEdjz+A
Date: Tue, 27 Feb 2024 03:37:05 +0000
Message-ID: <BN9PR11MB527669B377240D2A26A758E08C592@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-1e17e60a5c8a+103fb-iommufd_mock_hugepg_jgg@nvidia.com>
In-Reply-To: <0-v1-1e17e60a5c8a+103fb-iommufd_mock_hugepg_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|LV2PR11MB6069:EE_
x-ms-office365-filtering-correlation-id: 38170b66-a3fe-4a90-69db-08dc37455e4b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4A1vhZYI9korVILMLZgPmMwmPHNXuiOLryh19mLVQ1TsPJ3rdILUKhwgc3FxRB/VUwj8OpIPytGA9ebscRdHhCWrrcGrCP5C2wVaGbcdUw5U1KoeqScS8zSxL55yOw9n51DGLUJZt11IDGoFCXMxc9bUTpdECRnVQC2CkWnxtiy5Z5vcBBgb49HUL+aGV7cmPm2gOvZWy/tRSWURh0fFiANPwqG+QhNdxxpUisqc5oQ2n3I6P7MAvsTGgNvofctd5727zujVkMe5IMS1u4MOGTWg0MwwgB3+9ER1z3dWvzVMpwVHLHaBsjiYKvLGkDJlwHrXFYYb9/Sc3LAyzSq0LkpDEA330LRnCA7SC0Bfdb4HYdB7oZymAcNTQnfh1PcunGa0KUwwJQiDzntn9QF15HrsfDk34JEXNoBuWKtv50EaeAoDxlbclXA/UGBEBm7XM5A9RLktl5dmnQeDO8A3Z17iMzZ+1fGwZI/yWtozltOHHOPwLdrsqtNkQU8fyMeY+Rrj70BZRoa4yRmk3aNl5DpK93fYLjFrmoxheK2BYDyRJN42yIFEfK7WEby2z5pi7UMUHpj/fuMlyDPs9zF71VJFUEAseYAPVsmf7ym7TPjPSC3okJB7VYSf9Q/DJLDkhtXHnXHyVW56n6ipAxmCR05puN0H0njV4AYryX0sUx0korlcYnj0T2NoUHJlA30HhCJSkUEpsm+GGSBhHidudLBau5Z5Zorj32v6UwuWbBg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(230273577357003)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?+mkw38hT38aL6gIJVGwSOrKYaO0TuK0xyte/qpEEQpri5+l3WnE7vgShyRV+?=
 =?us-ascii?Q?01xZKNn5oCjvv9UYv6nayL2q45WlAjJ40g7ukooFoUtTqFpRF3eA3XgzdZJH?=
 =?us-ascii?Q?0vjLoHsVbU23HO8S2B6X2b45Z9V4Q29f/zgIEsc7nFmsjk4oeYM6E6V1MWpQ?=
 =?us-ascii?Q?vkHj3qM9djv9SfYBXFnuzNkkkicyZ8MsnwyGMheBDoq0k/Elefs12g4UTZ+U?=
 =?us-ascii?Q?aelL42hEMlKZemb5SXruLfZHYW5jDy+D7xcvGlcK0a1g7/IrB6j1iOp4DveT?=
 =?us-ascii?Q?/Cej52tzhLTsP2kQZBpCfCJlNSxHE7Eag+WQRdW/hTKEScMNH3ZcQHtg+Z/W?=
 =?us-ascii?Q?2zOLELWMe6z5N3AlvtQJdM2ib5HcvlsxQUJ44GJuqovVGr/qsRIkjcVrJ84f?=
 =?us-ascii?Q?CsUYm2fy3JSWR7W6z6IC/rs7OMsYCO1Y6Pk0I6hEKhz1fVn3gyZDU8ABhUB6?=
 =?us-ascii?Q?0eV7HB26LqOPzltzyVNs4UwnYCydtvPAO6CUNauF8/0tOBREudlZ/diKf9ut?=
 =?us-ascii?Q?YAX49tozf6IDtR1RW835TrJCxqfk7KQmK3JbWbl3R6vv5wMmNYFOdO/43zTi?=
 =?us-ascii?Q?wZhzm/m4DjUrbnAxIgUpwPkhLAZ97N92+7hjf/b2gx3SrCI9aTjtBgFarHlr?=
 =?us-ascii?Q?Ci//9NHutdmacqYxSpZ2+ge3JGTBCe3GJcJvf7Zimr34KhX/U6c6wd53OXf8?=
 =?us-ascii?Q?a5x58q57bLxEl4sEHkub8sZzATmPdkXqu07Vdg+a7gR97hDHT7hgpKHT5JQ9?=
 =?us-ascii?Q?fLm7wFNVWFiWzORgWiNhgxe9geh0MJibJved9n5xldyZG+cj77ipU1PAXpyv?=
 =?us-ascii?Q?YqztYugsucedik4QL0DOeGDNpLBMrJtJmIQ5SHRVo8d5BwLzeXZ+XW2wdQsY?=
 =?us-ascii?Q?UyvX6GDVLiuZuRaWNjn2PD7VeOVDxo75MMMqiVk8vYTZVldtor/JTLlvbs3N?=
 =?us-ascii?Q?HYRE/aTMV2i7Xa2zyR+USZ685PB31bAkQNedsZPqLL2SbOBOHQS1D4pbrEld?=
 =?us-ascii?Q?i1B3RoTnXjnRol37DNXr1xiZl5i/YLYlcHire8yeO6VmFvLNJDLB4tDgjL1g?=
 =?us-ascii?Q?WcL2E/2vWQLEP/EkfRe7TE+misIuv4CjZYDTevaoJRzj3lbb2bi7VX9t9tUe?=
 =?us-ascii?Q?gXfGW/1KKHzJh9hj3GEL0pRMlwo9Dj/1k1/3th8opTqMxEvBL/UwSWaxVKeG?=
 =?us-ascii?Q?duwWlwm+Dw2vtdRPs4vR4DEjesC+2+lQr86RukPdBoxEpozCByDFC2WcVDrp?=
 =?us-ascii?Q?cAzzfFtGIGnKXzW7NAFfYoDN9UUgurABNieBZH16ixH4vyaefE2WVzup18TF?=
 =?us-ascii?Q?OjkYZRVRE440itv7BW1hbXOYmme7pFuY/aorZiHr9bYLUipmSEboJdsAOLIW?=
 =?us-ascii?Q?txYvbUegJxk+3eupNnIqqMou2utEz+pC8eKjnJAJ3erW76GahdMJnvYbmcW3?=
 =?us-ascii?Q?SE90om27WVqNyzbTRkZ6ArBmEYem4wKIpMTycjUrsKROwMA0tYOV/osvJvYG?=
 =?us-ascii?Q?53elrEPwl81aIh/w4pSd/7gDB9YR9OoTA/j3gaEsLdatOc8YzZvqEf7zHPQy?=
 =?us-ascii?Q?/Cie3cGdSo6rm4ysJbIQZ3mS2FiCToDXxvMzgwjA?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 38170b66-a3fe-4a90-69db-08dc37455e4b
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Feb 2024 03:37:05.3961
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: N3Hz4Kpob64u8nejIncfUYMs0ho+wNAlILC8tvNGAtCccaLj9UdOvhd/ibAKB7DCXT/JzQC/h62NjWi9Z9v4cw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR11MB6069
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Saturday, February 24, 2024 2:44 AM
>=20
> Since MOCK_HUGE_PAGE_SIZE was introduced it allows the core code to
> invoke
> mock with large page sizes. This confuses the validation logic that check=
s
> that map/unmap are paired.
>=20
> This is because the page size computed for map is based on the physical
> address and in many cases will always be the base page size, however the
> entire range generated by iommufd will be be passed to map.
>=20
> Randomly iommufd can see small groups of physically contiguous pages,
> (say 8k aligned and grouped together), but that group crosses a huge page
> boundary. The map side will observe this as a contiguous run and mark it
> accordingly, but there is a chance the unmap side will end up terminating
> interior huge pages in the middle of that group and trigger a validation
> failure. Meaning the validation only works if the core code passes the
> iova/length directly from iommufd to mock.
>=20
> syzkaller randomly hits this with failures like:
>=20
>   WARNING: CPU: 0 PID: 11568 at drivers/iommu/iommufd/selftest.c:461
> mock_domain_unmap_pages+0x1c0/0x250
>   Modules linked in:
>   CPU: 0 PID: 11568 Comm: syz-executor.0 Not tainted 6.8.0-rc3+ #4
>   Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1
> 04/01/2014
>   RIP: 0010:mock_domain_unmap_pages+0x1c0/0x250
>   Code: 2b e8 94 37 0f ff 48 d1 eb 31 ff 48 b8 00 00 00 00 00 00 20 00 48=
 21 c3
> 48 89 de e8 aa 32 0f ff 48 85 db 75 07 e8 70 37 0f ff <0f> 0b e8 69 37 0f=
 ff 31
> f6 31 ff e8 90 32 0f ff e8 5b 37 0f ff 4c
>   RSP: 0018:ffff88800e707490 EFLAGS: 00010293
>   RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffff822dfae6
>   RDX: ffff88800cf86400 RSI: ffffffff822dfaf0 RDI: 0000000000000007
>   RBP: ffff88800e7074d8 R08: 0000000000000000 R09: ffffed1001167c90
>   R10: 0000000000000000 R11: 0000000000000000 R12: 0000000001500000
>   R13: 0000000000083000 R14: 0000000000000001 R15: 0000000000000800
>   FS:  0000555556048480(0000) GS:ffff88806d400000(0000)
> knlGS:0000000000000000
>   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>   CR2: 0000001b2dc23000 CR3: 0000000008cbb000 CR4: 0000000000350eb0
>   Call Trace:
>    <TASK>
>    __iommu_unmap+0x281/0x520
>    iommu_unmap+0xc9/0x180
>    iopt_area_unmap_domain_range+0x1b1/0x290
>    iopt_area_unpin_domain+0x590/0x800
>    __iopt_area_unfill_domain+0x22e/0x650
>    iopt_area_unfill_domain+0x47/0x60
>    iopt_unfill_domain+0x187/0x590
>    iopt_table_remove_domain+0x267/0x2d0
>    iommufd_hwpt_paging_destroy+0x1f1/0x370
>    iommufd_object_remove+0x2a3/0x490
>    iommufd_device_detach+0x23a/0x2c0
>    iommufd_selftest_destroy+0x7a/0xf0
>    iommufd_fops_release+0x1d3/0x340
>    __fput+0x272/0xb50
>    __fput_sync+0x4b/0x60
>    __x64_sys_close+0x8b/0x110
>    do_syscall_64+0x71/0x140
>    entry_SYSCALL_64_after_hwframe+0x46/0x4e
>=20
> Do the simple thing and just disable the validation when the huge page
> tests are being run.
>=20
> Fixes: 7db521e23fe9 ("iommufd/selftest: Hugepage mock domain support")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
