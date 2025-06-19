Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C447080D;
	Thu, 19 Jun 2025 05:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750311956; cv=fail; b=J+g187QeezYkxXJeLttF5GCf3vz8EWt9UYSGfJrrbVHg+WXes4drTRoooSfMYQLCXcWL7nYjOEhP9nlM8Dh8OmGc07qW341BhfvP7GvXsB2vN4/kKyMxx2mSZIcqkvpuy0sO+ZF7NkpGpglzIbFWjDDcvcCi4O6X37d0/z9mevw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750311956; c=relaxed/simple;
	bh=5Cfb+GEG0eF/tBPtKAnCM0lMCAUii7UcpJEXcdWwJBs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IEUQv5PglMjUPLHd+SztKPUbAwpfO6f1evgD1Ps4aLarkCniUVG8q1/0z1tdPazp0dSfRYOcZcbSYkguehQSaDXrqQdbeaU8X9e2EvUHPwRU95rhT4Bs6hAdcPqhE4btbHl0OWfTEairIGIW04Gzp0BF0trOWdwiZBgqVt3Pp8k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kxo5Q0UX; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kxo5Q0UX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750311955; x=1781847955;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5Cfb+GEG0eF/tBPtKAnCM0lMCAUii7UcpJEXcdWwJBs=;
  b=kxo5Q0UX4p5cHENFIHzgsB7BvQsYZukl1n9TRD22R73PLwd4ErghHMVg
   sYov+7+RVK7NdhOphWG09hOaLwJiYTspaHyez19KtpP70yt9z1n2ksLWz
   bsFcOLv0ZvgJkTvFIy/MLGMH/nOW+QOsC+c3XJ0YTE7mrkm8Bxy4VpZ7N
   3p76seB1PYsFS1EbXsQJQFl7zecPc8/lZA+YCu/PL/Q033ym2tKHgXRqd
   /cRdNs1WHRbXHcQZjhqal6eGwAR87mjQAet++86miqcUWAruMjCduRv7n
   EyYLE5u1pfqs1tPghZl6ui6PDfn8D1L/XrtPRAb5sbU40ZdTIOCogHXaw
   Q==;
X-CSE-ConnectionGUID: 7G/4jLcYQ+2r91yzBPfTGQ==
X-CSE-MsgGUID: DdpS/cf1TMeYZ8k+dI2uxg==
X-IronPort-AV: E=McAfee;i="6800,10657,11468"; a="51662601"
X-IronPort-AV: E=Sophos;i="6.16,247,1744095600"; 
   d="scan'208";a="51662601"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 22:45:55 -0700
X-CSE-ConnectionGUID: y7+jzbm5SgSNkxUbZddyQA==
X-CSE-MsgGUID: OS1ITsHIQr2zA4rNcfkNiQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,247,1744095600"; 
   d="scan'208";a="149969899"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 22:45:55 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 18 Jun 2025 22:45:54 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 18 Jun 2025 22:45:54 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.44) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 18 Jun 2025 22:45:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Cpn4f4g60nZpLRCVa/Fy13TcFYnfOboSqHtx7K6E1inopjbQSZ3xigFP4GZTx0LdXsn9I8eoOGRDEuWUO3NzO9/wohszzpraK7WOmJ0kot6aiI9sWZLObABbo5BSCnSRhVBz+LeaZRI1JOLyM5JcVdNrI9hPYH05chMqOWtPgB3Inu5qdfrX9DzTbUymBFmZ5KNN997EcrNNpHho7xsNxOqqneQTRYtur1G88/kq7p23y0/A9gTsPNyWfAcKrPnb/aUNi0BDrcChYc449pFeC/0SF6W+5e5siQ7xT+mzxd42iA6tHvygCsV1yJKLpx6ke4FDdDBU5eBWZF8AuDzGUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5Cfb+GEG0eF/tBPtKAnCM0lMCAUii7UcpJEXcdWwJBs=;
 b=V3cPMhxAIjRzWY3NXrzKfvSnP2K/ZXdcgWNwEBYaTj8eEbaNV+/3Ql7rGNbrgNl/FHeiBR12cCFMBbOaOw1pp1yUj6u7zLbj8xsiVUDHH8x5mEGsnCTkvgI/s7q7hL9FsSlJEwb9Wpv7oC/BH3gif/Lkot7x2dPtIzh50/44/X/Ti4SOBXyVj+5KBfNZA/xBIIirEpIo1GaUWVTDm9lRZTfUaFBAAAV4PjmPbszPoSonqn6lfBy7XeJg6mGfwsSzZnrXoZazQritHOU3BmvtirEYM08cx+0cnBfPYxWOIA74Mj/ZdoFK062hEf+BU6RI4w1H5WVLjciOIPPp7b+m5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SA1PR11MB5777.namprd11.prod.outlook.com (2603:10b6:806:23d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.21; Thu, 19 Jun
 2025 05:45:46 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%4]) with mapi id 15.20.8857.016; Thu, 19 Jun 2025
 05:45:45 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Nicolin Chen <nicolinc@nvidia.com>, "jgg@nvidia.com" <jgg@nvidia.com>
CC: "will@kernel.org" <will@kernel.org>, "robin.murphy@arm.com"
	<robin.murphy@arm.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"praan@google.com" <praan@google.com>, "Liu, Yi L" <yi.l.liu@intel.com>,
	"peterz@infradead.org" <peterz@infradead.org>, "jsnitsel@redhat.com"
	<jsnitsel@redhat.com>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>
Subject: RE: [PATCH v2 07/14] iommufd/viommu: Support get_viommu_size and
 viommu_init ops
Thread-Topic: [PATCH v2 07/14] iommufd/viommu: Support get_viommu_size and
 viommu_init ops
Thread-Index: AQHb3PaukO/OnVX420mEy9aqiVOMprQKAMjw
Date: Thu, 19 Jun 2025 05:45:45 +0000
Message-ID: <BN9PR11MB52764B2D273A9ECAA8E5968F8C7DA@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <cover.1749882255.git.nicolinc@nvidia.com>
 <35c5fa5926be45bda82f5fc87545cd3180ad4c9c.1749882255.git.nicolinc@nvidia.com>
In-Reply-To: <35c5fa5926be45bda82f5fc87545cd3180ad4c9c.1749882255.git.nicolinc@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SA1PR11MB5777:EE_
x-ms-office365-filtering-correlation-id: 0ecffbeb-cd7c-4ad4-32ee-08ddaef48984
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?B93Qjng0IP0BUTzQI5juoQxTCMdi1DLJltC1VBsMUrfZVO0FaQfUwWiVJZrf?=
 =?us-ascii?Q?U0DRNhA1G1TREsAFxRI6VhMjuCxSyi7OZjqxiQSo5Xoj0v1MDHfjFQCl0hfV?=
 =?us-ascii?Q?4GbRPvqT59fZVQUo58zXF1j+8S+Jqrb3dOulb8EYYG6cH+GCjHiXAic9eK/5?=
 =?us-ascii?Q?dSximeoeaMgVVGZBJFrfbWXQ7fkQn/BcJEDyrptski/uf9buZPpuoFeSy8EL?=
 =?us-ascii?Q?n5eYqL42y10wYz+cDevPiOpN9ENPXz2sMKu9em3AiB043nCVQ+D4fYFmL/gc?=
 =?us-ascii?Q?IfCRvbQDssjf9wq7xL8QeHY2ovJ/BLlRNp79oSgt3SmjkiAyDuW2iaeaCFEa?=
 =?us-ascii?Q?CR4g+ql8ezFURa6qdazNjRBO4Wj1t1VNu0q+57u/+7M2Z+shPHHYPzgQhXvo?=
 =?us-ascii?Q?VziColjebwNTih6UC7A+U04GSJBrWUzqTvbWwQRZtUF4ZjXTMTJVsv2FGZ9H?=
 =?us-ascii?Q?/pLC8pJhQIIlojwtOz8juzqEcOUtSeQXe253T6u4yDQWEladCcprb1vDT43h?=
 =?us-ascii?Q?U5+H/e+0LpUorScKD6DjFvMY015qHlFiuIymE/hIUnzzL0iOjl0sNwqVoEnh?=
 =?us-ascii?Q?Rhw3xxuVYB8Iz0sTe0KhCjnJy09/fh0+i5VTpCOVqTak+64m0ME1jl1S5ymH?=
 =?us-ascii?Q?5473IKXkZ9iGVEsIOnUfYH3uWGUlXiRDAKE1/223aFGvnSU0Li8EwFsnYe21?=
 =?us-ascii?Q?50Dn9zNvhfr4/qY0gsuk5wrngJs0PQAHT6kwnH5rcr8SHEE08gcSfGw1ABCN?=
 =?us-ascii?Q?s8mVXPVHttexfKAhs6/ulRzSTfPWkoqCWLhOZd+I5MCGV+4pfhQjX5OsOKRy?=
 =?us-ascii?Q?RJZzvkpFwiKZeiIvhoGVcvh/ifZwJvZKw4pSEadH5Lp8euNE+BBQjZrezm6c?=
 =?us-ascii?Q?o3aGZPVcJG91uaKGDTDDJnzCGJju9PcfeSMlQfLRvggVQ5DiZOJKCbaoWter?=
 =?us-ascii?Q?sRU22xyo0xBgvQPjEdGsa1YYN/XE4dohUYjhxWeDJpcIV9EsczaXcUZsVRDa?=
 =?us-ascii?Q?QUzLe0eX1JoH8U3tDFwLrFFxypXFs4yvXlsfxyF+rECC/MbelSA/WZlCrGHq?=
 =?us-ascii?Q?CRVz+NHK6Hmc2Aol6nIxLVmGJAbxMNnXLYgMgUpYr6T2XwiDsUQH7ssT03uR?=
 =?us-ascii?Q?TXGVrAjqu3WcwCrqWk8kNiw5HD5713D4pnMaPXq/my/C3rDKHiX6HjIXKEfk?=
 =?us-ascii?Q?jQMjte+qmqsFp/xzCx2orsw8yPpIyZUUaA2riwTNtfTTXToBNF7hXgCm7/IP?=
 =?us-ascii?Q?V1tHN02SaVVUqq98VKRDoExTVsug9sA4an+svoOmjGbdq2MdXI5o0UXx+3AS?=
 =?us-ascii?Q?+ryisMfLZ9cZdoPWQkK5X8g59JMuH62hUtvO54FZo/1Yk7nmdW8wPZJKld56?=
 =?us-ascii?Q?OcMNNyhWiCzWm8nfnwRaLUY6zmZ/Ry/ZWUlj1D+oZUolub+jwUfElXIil8S/?=
 =?us-ascii?Q?Ku/FAaYrrYSb/BI6FmJrw1u9nr2hXbTifyFvNGGbuaCtXQhtn05t/nakZeuN?=
 =?us-ascii?Q?bdqyr82DdbNLlL4=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ktVe7Fj3547BThRsgNBnXgUxPf3TsUxVvMizjXVG4XBdo/V9KpcyOtGJ9rHM?=
 =?us-ascii?Q?5mv/Iy9VvGpBCsAWgRFxCGN8tOwfbvRjZOjoxpC5HTHAzC92CT1SqwgrRQ37?=
 =?us-ascii?Q?6oDd0eWHQkOf9+GO5yEq2tRMj9AsSMa+mPzsOMEGTi9u/sUPoV747Aqq4bQB?=
 =?us-ascii?Q?Mg9ShRpqov6BH6HpYmBUGIHJgGdqSTTa131EqC0fNzDig86XPDbixcxWgAJH?=
 =?us-ascii?Q?2ajPgULTkTeh81rmD25EzU7Z+ZN1Byw0IW9A+Cd02J+XnlvKV5pZmo75lGO5?=
 =?us-ascii?Q?WKllIaiiZ+1nPsKrvR1pMGlkh54buIMmTNhxxpWnyb7bBaCINd5qhNBmgwdN?=
 =?us-ascii?Q?U2ZEpMdtKP9mCU5N7lSzxxDOe0DMa4eKEduO/55w1sSsFm/OYASMHOk3IafL?=
 =?us-ascii?Q?3nnv2zFrbgbHBjyZS1D6rorf48qzH+I57IR5L+YVlNcl17bG09hT1V75fIfN?=
 =?us-ascii?Q?GMDBGYtCT7xRPMVCpleUG6vqdbLAMqp+LnHB2G0iDF+L4vbF/IJhscS7U6Qq?=
 =?us-ascii?Q?zcMWDLQ1GqBwCbs2D9d7WlQD8B3phztOUOFlVBLrARVoE5imdZklKehi0qN7?=
 =?us-ascii?Q?Yqus+tlJ4xc4mSQZsY3cSN1BSOdC5gmLtOggsxKrGi1A3xKh6WG6JA0kDNXi?=
 =?us-ascii?Q?HQ54dQzT7L1YX6M0792ugDQtG0oS5HGATkdAVI6qbVmX9YC3cJa0MTR/PBFq?=
 =?us-ascii?Q?3DIcbc1ggUyOs2z6EjeBHiiOS2lvQ7ki+9hH0hrBZ4+1LNBkDHPo2n98hdoc?=
 =?us-ascii?Q?3KD+6NPM8gJyolsnWC6MDc9kCH3HwzgrW5/OqgeIdzXiL47/fs6n3vmILReI?=
 =?us-ascii?Q?9Hbcc5SQrcqHTmigoIsCA9GtGIwbeo0NyswooIenppWawvpNRxq3CN4SDal3?=
 =?us-ascii?Q?/zgleRDHu8exN8DM8h3TS3TyN2DzPpwWgqAkEugiXCZ7MLptNk4hJje1UqZL?=
 =?us-ascii?Q?Jov9VdmMFZ45tLF1Fjj1/9I6+TgDtxsxqqDjvGqZk2hWfKicmk4lCi6lhMY9?=
 =?us-ascii?Q?jAJ9e7+xNPBBydsPEglrgS5KycWAEHcr7LWbM29PYDNUHf036rKt3SBFgWvV?=
 =?us-ascii?Q?eDnO5ITma+gfMWPOR2cFAlxABgRYAFoXvd3Od4qOiuNrMpsrPzAYI/c/9QDE?=
 =?us-ascii?Q?t/ROTrjuQviJW23lDUOhmasfgoXAu3BquxPOD9mkhjZ+LgIzSDL8VmrYbuhw?=
 =?us-ascii?Q?yrWz1gYRdrCj8WyUkQ6YDa2dpHUx6urA2CRV2C/z/0L7SiABC60YkR+TBFEe?=
 =?us-ascii?Q?z1wDBePVT/e4bvck+4aLRyiDSJFMrTRRc0Nuznyh1uSfXcbJF6TU8AgU0zjZ?=
 =?us-ascii?Q?RhosfbuQIave1r1JN/txwR6EKclKNNAacA0GOO4/HT8pud50BrHM73tmJSiI?=
 =?us-ascii?Q?CBGbBhmx82QoPMFN80ka0kGTZlTqTdKe29ylzjom670tJELi+083ppsSSebt?=
 =?us-ascii?Q?VIcaKlh+bLYviBQ3eLmryp9yKCyv3oU7ymaJvb5Z1+8apWtAEBCcBhF54hbT?=
 =?us-ascii?Q?Xj0vXxJ5wjYDziy547xP7eCxOP0PII+JZzvSFlh3ktu9Lf31nZVN/XirXPM2?=
 =?us-ascii?Q?NVFJDlG3JXPJjFsTcCODZf6lgS757hwVGVA8GNGT?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ecffbeb-cd7c-4ad4-32ee-08ddaef48984
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2025 05:45:45.8524
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kEVYx+gRoFaZ7UwG90ZgFDOEgZ+KLvMO/6U5Uq1w94k1TND18qK1YflX7+QNKQnmDSImeibRMFIRjm+6sWzRzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB5777
X-OriginatorOrg: intel.com

> From: Nicolin Chen <nicolinc@nvidia.com>
> Sent: Saturday, June 14, 2025 2:35 PM
>=20
> To ease the for-driver iommufd APIs, get_viommu_size and viommu_init ops
> are introduced to replace the viommu_init op.
>=20
> Let the new viommu_init pathway coexist with the old viommu_alloc one.
>=20
> Since the viommu_alloc op and its pathway will be soon deprecated, try to
> minimize the code difference between them by adding a tentative jump tag.
>=20
> Note that this fails a !viommu->ops case from now on with a
> WARN_ON_ONCE
> since a vIOMMU is expected to support an alloc_domain_nested op for now,
> or some sort of a viommu op in the foreseeable future. This
> WARN_ON_ONCE
> can be lifted, if some day there is a use case wanting !viommu->ops.
>=20
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
