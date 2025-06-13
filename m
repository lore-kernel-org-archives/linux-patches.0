Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F9EF2C1596;
	Fri, 13 Jun 2025 09:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749807244; cv=fail; b=NgnZGInJpAUeQGfcN+Xnhs9ZPDjC2SOPNYLMMLA8vlznvNWPauaRewRSEWLc7Yr0J3SwKN9K32Dx/1FVXUlPBehARqM/+hT2P3aTnWgMf9zA6Uuu3l/FooM/IeMuG7X70iIPBCOq/PniutkCAHHdjTzXl51fBC0cFKdmZZe/ugM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749807244; c=relaxed/simple;
	bh=G+bx961Z/aaA174tGpg3mllML8L3a1KOxL+9Lz4GOUU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=UA6FdWymGs2IDNlY8WhoNzTPlMfeXTop8/El5+D437pz79ckFy17R3t5vIK48iwv023rY2akdB1zD7Bc6TsYxEuULL5/L3rbN3aJbSF4KdLw6wdatGlK/qcWfgXOOwFalvIm272WDp9gseEpHjkGPfn3JOWjmLRoV60ERz3Nom8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KvmbBE8c; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KvmbBE8c"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749807243; x=1781343243;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=G+bx961Z/aaA174tGpg3mllML8L3a1KOxL+9Lz4GOUU=;
  b=KvmbBE8csa1e7oKlhZVmIon3L8WFpSXVcUdxY6uUnEZz8CFkKHj2RA6S
   hGLSbAzw8dvcSGh3IvPWZF/TrIAzBMVDoEtzIHqqKcSIbsXMxa1ufSpYf
   AqSHrgdOZnwNgESaSCjbyxhvuUXUELpsS9tjPOn/hqeEP5xMPJT03Ibcm
   TuBhmK4vuzgXA7jFwmqdtM/I1wTU84Lw7xKHHpjvzxMXymO2ZJtVRvuL1
   5SInlbXVnANEALqolwQqjCKTYimVQLL0KM1cLglcjsVZARdcouaeh7eVU
   b7HVMTJpFabWvqb5ouHThvHuNu5LZz0ydYBnWXWLRhfTiXGjAwPfBAUSb
   w==;
X-CSE-ConnectionGUID: 5HZkeDw2SqKA+NzBV7tcCQ==
X-CSE-MsgGUID: zI4P+fWMSbS9u3ZorHciKQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11462"; a="52114076"
X-IronPort-AV: E=Sophos;i="6.16,233,1744095600"; 
   d="scan'208";a="52114076"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2025 02:34:02 -0700
X-CSE-ConnectionGUID: LqOXYrF7RSGC54hQ5oVppw==
X-CSE-MsgGUID: FyNxfBLjTjaOMMNq906Zxg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,233,1744095600"; 
   d="scan'208";a="153071760"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2025 02:34:02 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 13 Jun 2025 02:34:01 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Fri, 13 Jun 2025 02:34:01 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (40.107.96.59) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 13 Jun 2025 02:34:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dBAg30rAvHvZnOqXIm9p0lth8CkOSEtzYBtylw+30f+M6+OEfy+pdb9eDRy2ynmIhDhTbJ4p+hmU6iVooN2+zpp99+8i6Y5r755VszzwrJovlv1y3fzCu0oJTkuBYFwbGmhzuCTgmw4rIGtiroNh23v5Fa8H9AKw+x6Th3ArSi3LheV0Y0fzpKnq7VmXZ0gfdxBmbG2KSYjvg0GtGYBtvGSsu87zM+LR/wgEAz+8jmwGqlz+BMRiLrfo0UMv8Jo/SYQ3uh5EdnRetrm5VmioheceLBRlpzy0Z3CPAZs6jElTHtEI1LWb2IGf3J4ucZ72yeVlJJmSvaX1beQvOrSsBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G+bx961Z/aaA174tGpg3mllML8L3a1KOxL+9Lz4GOUU=;
 b=olH0yWt/5SgevYmLvMyHwVqAz4PbFIq2TDzK5VrLbsFpkQlDI6MJIEfucSCnGbtLIGpf7DDwMboj47hLeKEV77Asd75aHeTeTybfgTi+wJSSSZSeMeZeE9sVILUQjRjPXOHmFNCNR/BMPWCRmWnshu2JzRBuv5gWCvQrK9oL4XBTMC0tOcXWBCwJ3DrWU4Jg0fOJh7rxVIwnWx78j3m4ABlYcdMTZ3WUn8XR6XMmAimsUZh4c5U0R7CGY3HSCkQdGs57uAVq7E5umHNxdiPa11mXUYGD2cSyipqx5EdKYq0jhwhPvf7Itawat6loFM7bzGGSDQp1xJ8RqBvgnTLudw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by LV3PR11MB8674.namprd11.prod.outlook.com (2603:10b6:408:217::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.23; Fri, 13 Jun
 2025 09:33:55 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%4]) with mapi id 15.20.8835.025; Fri, 13 Jun 2025
 09:33:55 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>, Robin Murphy
	<robin.murphy@arm.com>, Will Deacon <will@kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>, "Wang, Wei W"
	<wei.w.wang@intel.com>
Subject: RE: [PATCH v2 3/7] iommu/vt-d: Do not wipe out the page table NID
 when devices detach
Thread-Topic: [PATCH v2 3/7] iommu/vt-d: Do not wipe out the page table NID
 when devices detach
Thread-Index: AQHb26bNgdfYXcyhHUeGVJ/dx66edLQA1RjA
Date: Fri, 13 Jun 2025 09:33:55 +0000
Message-ID: <BN9PR11MB52764AAB6F26C6896F7D02908C77A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v2-e5c01fc5ce82+26216-vtd_prep_jgg@nvidia.com>
 <3-v2-e5c01fc5ce82+26216-vtd_prep_jgg@nvidia.com>
In-Reply-To: <3-v2-e5c01fc5ce82+26216-vtd_prep_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|LV3PR11MB8674:EE_
x-ms-office365-filtering-correlation-id: 3410e54d-946d-40b3-6ac6-08ddaa5d6ade
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?GKjnc7GWpiQapUw5TMdJwMp+sgKdfGBBsJ70rmz2NSM9oKE701KMqz5Qh/+G?=
 =?us-ascii?Q?jBUpztW8khzLjWzxjUn5NCJy5/0SouolNcoCoI3sT+IVaHmyiJ/moj5u8wQh?=
 =?us-ascii?Q?sF0ih3b3waDVHHvf5f7u2fM8jy6/HZ3NoOhh/RduWGme1PI6qSMyzEsROAcz?=
 =?us-ascii?Q?YR2nTPfh1Y5chrHpOKeMBEWneYl3+2NFeykGddx7Q3PKYfz12UOvY6emysB9?=
 =?us-ascii?Q?XmDP7JF2UkRLTqYK2jgOC6ZG7hjD/gPj0LyIicxqGocGzVMrbdY9BirjdtiG?=
 =?us-ascii?Q?U1JhnaduXO5r3IEqYFMuwsZqCa1eQn+kXlhHq/CqC8UTapqW03yympvSAy7J?=
 =?us-ascii?Q?yoy0vcdKdZtbiAxdpfJYoBentbx5AqJNHhwxOuwl1J3o5vQ2hdVvbcd7t5Dr?=
 =?us-ascii?Q?h6Lw7yAJq6Bf/JeHfxLQOuEtvLYkM9Cd6PEBWkw9FKfGVE9KBew5B3CU2rBt?=
 =?us-ascii?Q?sWWcDqOJty2sEANFeS/gKEi4205TxsFfkcOJGQ5BootXbs5LzjuzfgSRwuzo?=
 =?us-ascii?Q?6g4DRh3lQH6OkhindmAfy8vQzR4SzTYPgEJu4VGc0t3GKJHraoAOjiTCWuXD?=
 =?us-ascii?Q?y/96NoGs4T+6wnAkryLzwHh1+lmsGOwB23bz7fd99r8Y/hSKiL1rcMZ28Ed5?=
 =?us-ascii?Q?VU7Qa9k651oXmCAxM3ycHBixt8rXPMEgL2u+Oz/1FeLFKIS3kiQ7sZhDJygH?=
 =?us-ascii?Q?EjSrRIP0KStqbljViVJBxqosstmrYwhknyMQdv6QhgYF/xrypN4b9aIFA/Rm?=
 =?us-ascii?Q?0dNFBagoLRV8hTPRNBtYBnLzd6E7Ui9Ns4qLlz0wB0rUbTfPwmWjg6GX0UeL?=
 =?us-ascii?Q?Dd9uqBdhmTkEZCxYSKGSirrRa8O0tPNkXIgcq6dCblQ2a2kKzBoaKHLgkwLI?=
 =?us-ascii?Q?F2GBRPlBfALXJRBThTio5YDXH2xKDUyw4Doxv63yPcdlCpIa62B9airh+gV9?=
 =?us-ascii?Q?xocOK/1WI1kzpJOH14oTwKkjP+qF439xy0s24jOKIfyMHaBr78yKKuNeXOYc?=
 =?us-ascii?Q?8pKBd5WOw6uezihix4OK9gm7StHhiJZ5McIPj9oNDaSczWQKi1w2wYOXwhwM?=
 =?us-ascii?Q?oRluFcJDeTx86t5bc1+r+G3xpDJQt+/qO1jxOeqKz5ZkGB+EbDSiXiAIjg2s?=
 =?us-ascii?Q?+tMnjeCe4bPjlZGTCEyuyYGEpJTMPiaNtNTI96kKxuEhIzzTibmYam0pNodV?=
 =?us-ascii?Q?LtxCY/yRC9xn2BbxkfzD2+Uxamw9n61hw1D4oAHkiS5RKgv7ummY3fVEydLi?=
 =?us-ascii?Q?CKP33kfx1wanWXQY7WIp6gwyU5DnBETlJQznmoVpY0LyIEWSIfzJe7zEf6ij?=
 =?us-ascii?Q?mZZEPIFmXgyO2GB+Zhpu3oE+LSAG0rvkLZrDtciZBq92V77U32jUvOKWVSHS?=
 =?us-ascii?Q?Vr4lwr/ZG+eHPtzW3LDl8OGrnu6URFUFDTDsYJSsbJkHIWaNEY3+fgh50Og5?=
 =?us-ascii?Q?lKshSRysyNvZgsqm1vrFE+Dmk9VwoCtmqt8brpo60SRDaVyKV1kc9Q=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?fuKsKziIIKo1bICySp9yAnrzgn5gasAYitEbqubp/fSGlyCqP6JCQwuw5gC5?=
 =?us-ascii?Q?1y3HAe9adzA8fP2RzktEgxVYJI54EVXMIYB/y60NJfCfWlj7Al7fspO9+LaI?=
 =?us-ascii?Q?PyrZuekU7Ar+4ttdS9NASvABc1aEjx9l7LqgPBhYoiIK1gMQ2aYjuGUUxVrm?=
 =?us-ascii?Q?L9YJl7gVQvapT5rdx4Q032zYASddwoI57OJyknNu6QC3iGDAXpWmsA7g+2eO?=
 =?us-ascii?Q?D0Hh4398gxfWggOlSuE9XrP2PTtI2NnYEdTnYe3Q4QQduMsuyJGK1innfKy1?=
 =?us-ascii?Q?XIYiuBk+C+0WhE/PmTCnainodLBI7WuM2IWoQzrTRDoLxp5rO+Ou+iKy1+vD?=
 =?us-ascii?Q?19YRPPSesYC58JjvNcOhvMxysbW5OGIpKWHoggAMqxVp6VGzgu6c2XTN2rBV?=
 =?us-ascii?Q?/LrlBXF36TZzSokA6hvOy8q9LPnMqlXMMzDH5DZHyXwiSzeye2nUEcqRECj8?=
 =?us-ascii?Q?enxHueOxrtHkg6Mk7SFWh/lcQYyXu2fuzRODaywdR8iBViJ8MfSa2YDDvlkg?=
 =?us-ascii?Q?PWlz5n573oI3OwqZWVHk8GgCvY0uz/RW+ZJedUtyY8N2FrZBloI51PrL7tYf?=
 =?us-ascii?Q?l6sNEGoVVareOq3SPfhBwopXkc4/zmcLLugPqMqrAwmOnIw5G1bTWoBsgGYY?=
 =?us-ascii?Q?uirhT5bhRgBfjRJ1R/YQHzINqdR3kEGOt8VYxYBdwvnQ3KNhrIQRzohh803n?=
 =?us-ascii?Q?oFRqBS5N4a8SicYQufk6NXyNIMQkFwgrBIphWIewePX4x4QrqE8MX9c7msnN?=
 =?us-ascii?Q?9PSDCcQXLKw5IHq+6MdHHsgUgbu424+gAJit9NsoddPEifou/jrn4VvF7GqC?=
 =?us-ascii?Q?YkTs2djVwdEeUdPW0RCtjqB8LMd0U2PMaHzVkT3LtSnAGZIOJu63q2nZeUtE?=
 =?us-ascii?Q?Ipfn5xTe5fi8kdW9xIOER51+PLW5fvfx0hY25H+lnzHnlTO5omS0uSb1U72j?=
 =?us-ascii?Q?oAN3LLyB4ksxAw/T9j13C9mYp2K6yYgf3zSllakkVo+M28aO77UZYTdqndAF?=
 =?us-ascii?Q?wZJ7CortIwd8VfXGLxvFW0U8ppQvoXOMgF9ZiOocrGSANJlc8lruyM3FB5MC?=
 =?us-ascii?Q?U/xJKNPkokjYZrfbX9tbPL/lxnsd5CEkHC2O9jbZSGnGJ7eV9OFQPDitNsAj?=
 =?us-ascii?Q?mlXa9AJfOfmU9gGrLqOTUwgmlrghj34vCfL4zpm1dAMhKKlSGGJxEmaRvIdN?=
 =?us-ascii?Q?/RRwdBaqNkzAoiK1guTOfHnonUGkvemAojD94TRXXo1/XA1N1AL1hHUktnwk?=
 =?us-ascii?Q?Xg/azMXmseBvxxgRAB42j1Qfh+TiOqTtuY4aRXvQozGIOxbjKOCug/sKd4ct?=
 =?us-ascii?Q?DV5xGu/dsDZ9PohllwPYLh7qHzUxjZkHYJOy/A23pjEA5c6oogRMNor/RdpH?=
 =?us-ascii?Q?ePdLec4uHLepvgun2YG4U3M7Yrc2x6aQH/vSGqMKqlKfN5taUb1eoBjMa13B?=
 =?us-ascii?Q?aTvXUiI2gE5ZJIWoW/bRrxcgncQ2IeQqdo1zheQSWj8kVgkKzKfMjpKQSOMH?=
 =?us-ascii?Q?2ArTYeXbSncw/gQAnW8Y3leRocd8nj6isKkWD3tv4kTvzpnRbX8KeUyBig7g?=
 =?us-ascii?Q?7U+jTYsU9LphTAQtvsVES3/sHVn5qRobjtEURnWa?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 3410e54d-946d-40b3-6ac6-08ddaa5d6ade
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2025 09:33:55.7909
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4UUb4Nhx2rpxkCobv4uqyIITiwS60O7SSBp4T0eVaJ3IYtBYE9Uj6QWQ5ivUlisbhSgYIvge5YXDnSyvNvGb1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8674
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, June 12, 2025 10:32 PM
>=20
> The NID is used to control which NUMA node memory for the page table is
> allocated it from. It should be a permanent property of the page table
> when it was allocated and not change during attach/detach of devices.
>=20
> Reviewed-by: Wei Wang <wei.w.wang@intel.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
