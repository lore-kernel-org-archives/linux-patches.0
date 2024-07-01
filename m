Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0ACD5C614;
	Mon,  1 Jul 2024 09:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719825154; cv=fail; b=n1ikQclbtMEGCSomJ0aBsLddrNlyLh9ZStyDqYsp4yjI9mEuWZY9wPa80+iFCVdJyfp2v/z+VNP6PYHjxFZkFo5gXqKq1xsUV6wZuPTSrWddt4w8Ejql1lIub5tzG0W2vg6E6Gt59YTAFAUMjWhBeIY+8KRhjU95UByqGe03KqY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719825154; c=relaxed/simple;
	bh=HsPw0tMBlp8dmL1eF86QthR6P01iY8efVuXj4W9+Erk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lWWSo1WxJeRfdA4hj+T9eY3vlhOSWDCYIENgtGGDujJF2WMO4LpWGXL/K4q/GeLxPJ2Yx6PIZVEF6nRXdO8oYjhM0tYxQYrHajTO2UidD970Wy8ZXd3oe950Pl4Yf3bgiwRRjNGsApvkpyNUjoP12Q7t0ateZh6RXLxobMuSrPg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fm108M94; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fm108M94"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719825153; x=1751361153;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HsPw0tMBlp8dmL1eF86QthR6P01iY8efVuXj4W9+Erk=;
  b=fm108M94gN5NPjWk+Po0cXL5sxT/d4Zq1Yjpn7MxEgUe+OhuDepjHm3k
   f+G+G8AQNUWr30gRh9RQ4bruMSSqt5vYUCTo4MRYzVfy6JWqCadWAE3XH
   qXcEM+IQLsoJtLCCtZ8QPQegQQ3TARsy9Bia9kea85JA5LuA1JQ3w+MOy
   HR/9O60TpFF33ZrO6pBxl5CDsK2Psml/B0Y1pBU4P1PAWGcRzDTcyYn0P
   wIcNncZGmS8+OPnXmV4ynp0goxneIE1+7EydSAXlKsy1rUUVjxIsyLedl
   Z88TBCzsxkt9wKXlD0qy/+yYSBQwuq9zJiND+engQlHPKq8yZB4+MCcAx
   w==;
X-CSE-ConnectionGUID: k690TnMnTqi3OmNMzrEslQ==
X-CSE-MsgGUID: cNLOg/eJRXukRrskWvP8Bg==
X-IronPort-AV: E=McAfee;i="6700,10204,11119"; a="12333626"
X-IronPort-AV: E=Sophos;i="6.09,175,1716274800"; 
   d="scan'208";a="12333626"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2024 02:12:32 -0700
X-CSE-ConnectionGUID: NcKEOMj4Q6u1bDJh/YdsUg==
X-CSE-MsgGUID: xfAdFVkjTn+RyUjUmca/HQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,175,1716274800"; 
   d="scan'208";a="45456475"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 01 Jul 2024 02:12:31 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 1 Jul 2024 02:12:31 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 1 Jul 2024 02:12:31 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 1 Jul 2024 02:12:31 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 1 Jul 2024 02:12:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lzDbCejEWU69pPL5Tmn2DWTUwXer+mJ1E9Gk9N89IDNI9EncpD3BDhqUxIvFh2Q6k3KFMGAGlf/1Dro98Y9+QVqazLM7wpLb/okolYMjAwL8az3x4wNIVappDjPASKvCL3MUuPf3PNSVpIs2zYB81e7Run0c474Gkd/FLj4vsNgH1zDt6lvo3SbCEOCAZzHZz3hUfi/tq06bif8aIkIWABfBggHflQW2XEj0zp3x+hrkpcm/med7KvSJ/x9x/HiuKc7mhBTdbc+9JRY2x9qYTavPHgRZqU3NztNp4spU4IsaUeLoOdjLXROZm2tvcAdPBhRRrt7qqXPjKaFgC6oJ0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=szcCD5f0/naZ73hhv0yMfWsbKBjHOdhpjWau21S1NAY=;
 b=eg6IRxtgOeUs5tLwjVnceH5LLmAjgJWD+kWogDZhPFZBLf7uLsvXAXsLn0ILTyII+xrg2INH6OCFxboKD2BUv0cqsw8Ywo29bRl3+v/jyv4Rne/DhSyrTsr5jDue4zHPcMOV3D5Xouycy+RF/BX2/IoTZ1KtyV+MWK2ttMgMn1AF7S8sRvI8UDCoXf36K9Zv3wabw7eaYuTKmNmO4MziZ0h0SGOxb5u/9L6iy8C6AGgZo1X950tSUusdK87YLQaBBOz4vK2xPSv5ru8RhgTKiQc/nDfkjdUpeNH0Q/7daNrcRV+EkrZM8nXxJXXvJ+TS94ZmoimEesFHOwi0zYIDWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MN0PR11MB6160.namprd11.prod.outlook.com (2603:10b6:208:3c8::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7719.29; Mon, 1 Jul
 2024 09:12:28 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.7719.029; Mon, 1 Jul 2024
 09:12:28 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>
CC: Nicolin Chen <nicolinc@nvidia.com>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>, "Liu, Yi L" <yi.l.liu@intel.com>
Subject: RE: [PATCH] iommufd: Require drivers to supply the
 cache_invalidate_user ops
Thread-Topic: [PATCH] iommufd: Require drivers to supply the
 cache_invalidate_user ops
Thread-Index: AQHayXXbOknOHXXcpEi5AVEMto9Jc7HhmpOA
Date: Mon, 1 Jul 2024 09:12:28 +0000
Message-ID: <BN9PR11MB5276C6685A2DD373109A0A078CD32@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-e153859bd707+61-iommufd_check_ops_jgg@nvidia.com>
In-Reply-To: <0-v1-e153859bd707+61-iommufd_check_ops_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|MN0PR11MB6160:EE_
x-ms-office365-filtering-correlation-id: c6d30e49-a087-4c43-f26b-08dc99adee36
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?+ePndzsqi0EhtrIlyBz6bzKvEBzGgx11xskhNaUPME3OarJMeX/xIz+7wVyK?=
 =?us-ascii?Q?yziqEsL41ZehPvtYbZQXiNdC9qONxvaqlPGPrKo6RI8+jjHHb2wWhUNdPtqr?=
 =?us-ascii?Q?xjSDBNWwSnzDS89YgLoXM7ZAhMfzOsIluC/hIyZ2JWFeRIMJzZK//IYtewCy?=
 =?us-ascii?Q?K5BNwRIoYezAQC+zaZ4WVm/yM36v9XGv1YWc+FSbEbkWLk6/27xJBtgIkmvW?=
 =?us-ascii?Q?mSrY+uKu9PxE0KJrZFzEomvOHiu9RbBVX7md1neDs1juST5/ukBq2yE9ADFu?=
 =?us-ascii?Q?7qlUQNwXnFm6MBW/H/lBwHVTJK4eLIqXNsiLz44Jui81/mn72szgjIQtdX8/?=
 =?us-ascii?Q?/D5NYkm6m0KuaPWr8gf4eqlLDPhdUcFgXk/EoPotxT/yyyAReU/mNsdJk6C1?=
 =?us-ascii?Q?eHknjT8eTab0DZIgnV5HCnkQZ7lL28Wvaoi52b500iGy5gEmPgrJn5NAPCG/?=
 =?us-ascii?Q?opEvNtIdS1EW3CXwalbhq/ioBg3wcFOonsgiZLCAYvQWKqKoaZxihoQU5aI3?=
 =?us-ascii?Q?jkYtdD9H03765SaYg8wxxn1ail45t7DRfddbnQJul+D+DiUxfgHPk5H/V/hp?=
 =?us-ascii?Q?0qGay7mD07PYPm6ePU8K0HYr51ZGe/1Rw4v1VftRVkngJscJHvJTVs3Avfw1?=
 =?us-ascii?Q?YMs6xL4/sAQ642sDJFM4zz8MfAGX9vwyMhqgwPU0bb/fp5EEY54ueCLEWjFA?=
 =?us-ascii?Q?RbbqMIZ4Sp6JugYw29U5SVnVg9KIb7NA1tY8JmmJrgfjzh9XWj4Hg9jJEXwy?=
 =?us-ascii?Q?taceADrgeDV2kZXQ0Qa26Rzo0w1a8zEetFB4gDVdWg3DFDmkOW9t0IdyySOP?=
 =?us-ascii?Q?tvX96ZaSfeRJ4WzvRdyIb0kkaNoe1RYD2Ed+yd5ueO47k2Fg167wJxn1ltQ2?=
 =?us-ascii?Q?7azlVYKGFovrhUDZLfrYl8IHqPrk7fZlSEyHe+YQX+W5KHi0obNRonA2gTxr?=
 =?us-ascii?Q?Gb2/Yr3BVns8RpM4rUFl8SP6aswgKo36smalxmja/FRhdQlfVusZdR9xLJTJ?=
 =?us-ascii?Q?jyWDIc1PV5b1zx5WqG1C3FewEDRzWeaUb0uHFwoQgv7BiCJjI8wHxvhUxW/9?=
 =?us-ascii?Q?uy+Hu/tJTBmAKhHa3TsQNjE27FF57eRlu8TRo0P5Qt3Z4g7lPLWhaaLTdPfj?=
 =?us-ascii?Q?OMJrHGRKegr5CQaqw/zO9g9FMECGeA3EPwZanlTjxM4ZerDXxzxgoTjT0ksH?=
 =?us-ascii?Q?c/YVU19cNmJZgGZc7s787z88uCQtj2l1EWpKIFIrDzkUEhM2+Coi/30GzCqN?=
 =?us-ascii?Q?OVyf2X1GTc+4z6pQW6/q7tDo6znZQ0n8kON2aVk8Npcc658YjuWSWxNHBzqe?=
 =?us-ascii?Q?WDAa0s+J5OUZ051OYYrxs8MwAzjBWyMUT6wZ37g5OIgabeQlncc6Rp/v9B+D?=
 =?us-ascii?Q?CGZgAQGT6VZjcQClPS5gDB01TpJRfL+/OaBs5YSuFoc0UgwSDw=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Qc14QJ1tRV1tGtVCvX+NZ1vgiaPVbIRN26ku4149TepqNGc/mGBPDaoFsqy/?=
 =?us-ascii?Q?rgdtWtlV7wHFSRy/5ylk8yu+p8KRS9Tcv0LWI3y2IxllF8HCRd/0WTBPFRzr?=
 =?us-ascii?Q?ITRNbvHyS/OMOsfXWK+gzQbC531wBx085+YhiX+AhDBtzviYLoyP2b8mx0Ga?=
 =?us-ascii?Q?uv6gbiBEac5J+RusokBhj8Yl3WWqYt+zYUheOulS8Fx0msOzH+1zpfxbbj/U?=
 =?us-ascii?Q?4dFKCTad42eohptAeiX7KUytaPw+zMFVbNzePFfIjAvsqcbooNXEoGU2WUMv?=
 =?us-ascii?Q?YOFZRihYd8WFyD3xKD/8yUEirxbO7IOkwXmaXdQ0uFOzYf6Ju/pZBFgOpDGs?=
 =?us-ascii?Q?shGw4HZjIRIE9NnE3jRhWqu46Jcco511pXc0fthMIRnMzhuKCXV0OMmjWRV0?=
 =?us-ascii?Q?8zO6Xct8PXFhisB2QS4QdQieplkvn1jJEi79wIqbc5HL0R9DXs1EWNBW1dej?=
 =?us-ascii?Q?oCcarGwOZT4UdaJRMyErX6QnjHgHWhWNVOYnmgnglQWmCEZjqWZjcuc0mlQ1?=
 =?us-ascii?Q?Vx0Hk9/VhtGWSp4uOkxnUjfqUmBLPitJqTLvtUQzJyKYKTxC8HSXmTZr8+iZ?=
 =?us-ascii?Q?rYDZNZ6Aq/9HziRDdvX+6A1YcO3yX59Rf+dFCKQMIqhe5YScUrMRpCX6gBso?=
 =?us-ascii?Q?yg5V+cozqjlcjv7RfHsRI3wvbXLbCK24yeqOXUXUwbPtV+3t5IHeXA0ENz0K?=
 =?us-ascii?Q?wD1++U5rLUEtDoGTM3/UEa7a2C4o0S4w6bKs9Xr/9WBk18Wxjm2ymVYVJT39?=
 =?us-ascii?Q?3dv0pCIP5pKj6/GVm5Acw4qroA3VFsCzRbzoMCl3KyVBzbxJr0Am46N61Zzr?=
 =?us-ascii?Q?I61OpnP3G8K0PP9wgSAYxcCVMGcD+2vGA3zqhmC/n0uixq62GSaU08GWmkJL?=
 =?us-ascii?Q?wxySpmEVGq3uvyu3ikX/HcdKRIH/HyTwZeux13coiUlgtz+cgMKnQ2lzVJtr?=
 =?us-ascii?Q?8M7Dra68dKr8LUjtNYD/o5OxRY2ka7CoET02HDLY+LjK0Oxl5RsRlmoqGMS9?=
 =?us-ascii?Q?hTsSHTVKXfM8R7j0RmacWCx6GrDY94hqnIarBb7SKvYGkjHqzBV4uB3VvO3E?=
 =?us-ascii?Q?Y6+k6ptMqx7N9ce017hBKuUu/Ugt3K6LykeW1i2NzYtbHM3Jf4Jxzga1YQuh?=
 =?us-ascii?Q?TqHDwwl/jSWOx1fdXZr5k2vqNi1fN+ScQ4miVsAUw4LOesIKL8PNyMVEE+YO?=
 =?us-ascii?Q?4Z4JC6/lKWOVRW9r1drj2JJPSOGdkuDA1Wbqs+Nn9uiHQejrvK6qnP99dt/Q?=
 =?us-ascii?Q?YefibfiDbQKk2ZYLrvV1C983F+lI4yemcAxX7wFPP2HACzpuT6KottPw1Cyw?=
 =?us-ascii?Q?uixWe1BEos11RRLvCfL+zeeC3HIzL7wjnAkiWrIQLGVCKc9GKjaiaDogFni1?=
 =?us-ascii?Q?kqmxCb5qXYrB1aUVs2+sRI3Elk8B2eH5ejaDfsaYY1viZITNaaic6UCwMbpx?=
 =?us-ascii?Q?aQ+R23L75tnZ59S0DvOzYDo7h0TrTgsUpaOW+jb/ZpJpJ/fM8x5kmlqeLpb8?=
 =?us-ascii?Q?NUi5Q/3o/sOpsZeCQNqtwhQJZenf3mjKh0ngY+G6dgjmjmz7dMNR9bXrXbFC?=
 =?us-ascii?Q?LyHNfZ+hBOS33sjZSup8+brJ/zoKlmnZDyVkpqWL?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: c6d30e49-a087-4c43-f26b-08dc99adee36
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jul 2024 09:12:28.4334
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ihcjKEf+FHGEnoz13OXIyTT8wO4ZwYN4xy2XAlNM3fwlbCmpb6nwbSW/vZv0vs46oAQaGXg6BF2ayN1hLbG4MA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6160
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Saturday, June 29, 2024 12:11 AM
>=20
> If drivers don't do this then iommufd will oops invalidation ioctls with
> something like:
>=20
>   Unable to handle kernel NULL pointer dereference at virtual address
> 0000000000000000
>   Mem abort info:
>     ESR =3D 0x0000000086000004
>     EC =3D 0x21: IABT (current EL), IL =3D 32 bits
>     SET =3D 0, FnV =3D 0
>     EA =3D 0, S1PTW =3D 0
>     FSC =3D 0x04: level 0 translation fault
>   user pgtable: 4k pages, 48-bit VAs, pgdp=3D0000000101059000
>   [0000000000000000] pgd=3D0000000000000000, p4d=3D0000000000000000
>   Internal error: Oops: 0000000086000004 [#1] PREEMPT SMP
>   Modules linked in:
>   CPU: 2 PID: 371 Comm: qemu-system-aar Not tainted 6.8.0-rc7-
> gde77230ac23a #9
>   Hardware name: linux,dummy-virt (DT)
>   pstate: 81400809 (Nzcv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=3D-c)
>   pc : 0x0
>   lr : iommufd_hwpt_invalidate+0xa4/0x204
>   sp : ffff800080f3bcc0
>   x29: ffff800080f3bcf0 x28: ffff0000c369b300 x27: 0000000000000000
>   x26: 0000000000000000 x25: 0000000000000000 x24: 0000000000000000
>   x23: 0000000000000000 x22: 00000000c1e334a0 x21: ffff0000c1e334a0
>   x20: ffff800080f3bd38 x19: ffff800080f3bd58 x18: 0000000000000000
>   x17: 0000000000000000 x16: 0000000000000000 x15: 0000ffff8240d6d8
>   x14: 0000000000000000 x13: 0000000000000000 x12: 0000000000000000
>   x11: 0000000000000000 x10: 0000000000000000 x9 : 0000000000000000
>   x8 : 0000001000000002 x7 : 0000fffeac1ec950 x6 : 0000000000000000
>   x5 : ffff800080f3bd78 x4 : 0000000000000003 x3 : 0000000000000002
>   x2 : 0000000000000000 x1 : ffff800080f3bcc8 x0 : ffff0000c6034d80
>   Call trace:
>    0x0
>    iommufd_fops_ioctl+0x154/0x274
>    __arm64_sys_ioctl+0xac/0xf0
>    invoke_syscall+0x48/0x110
>    el0_svc_common.constprop.0+0x40/0xe0
>    do_el0_svc+0x1c/0x28
>    el0_svc+0x34/0xb4
>    el0t_64_sync_handler+0x120/0x12c
>    el0t_64_sync+0x190/0x194
>=20
> All existing drivers implement this op for nesting, this is mostly a
> bisection aid.
>=20
> Fixes: 8c6eabae3807 ("iommufd: Add IOMMU_HWPT_INVALIDATE")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
