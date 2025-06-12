Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3034672617;
	Thu, 12 Jun 2025 08:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749715579; cv=fail; b=GM8Uj8t4yX1nt6lUm+7RskIJwvC7XGHeCXVJRIgWO7o46oBOyz31HC4OuIoTfP6N4LwuH1AypyZhgImJiyP9vg/OCePEXBT++CqN4sT2UNzEEDF6fwT3y5aQ32ntj7NZ46bPx1rAP31xiid8n1TWsinrr8ju9NR/Ml/E7an7xto=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749715579; c=relaxed/simple;
	bh=2OnWFLZ8A/IWmKLiJzAzZQIad75DPRdfLz40a4mPssc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=exc5lyEpnn95+Arm5AICFk1D4FXWWHLKdSN3qxfJ+h/vFebahDF8AlYL6kAhq+Gv7he3W3mDUGp82ujlnwRm0dytToz2UtkJUTtatEOwvof23XmUJCo24TISHWdCz55kL/CogIv9TBlRWuW2XutjghpjaKpMatLYSPSd2qhxsaU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LkbLlVij; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LkbLlVij"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749715578; x=1781251578;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2OnWFLZ8A/IWmKLiJzAzZQIad75DPRdfLz40a4mPssc=;
  b=LkbLlVijzHATwqNQ6NsWmeC4Qfjs+npf2DlBhTkd/hakqdW1LUmnMisW
   gkFkGNpP/PyQFdJhLyd1uenj+Co3ejpHPbjh0Ye94CwZgYHiNZlGjepMh
   s8stTsyIU2J1FCIuAUBM2p+yKnl3I/0e639kkbsTwjGdBfTQeoh7ed7B7
   NOSXnowzBSkPsPAgUNR3YX4GNbvfBbUoMI9YnvmC7FqLSMl7Te5HHE2LD
   5xyC9a1z6tGhHm/uEIpHdgYEgWZ8nSkHkWb/ppPIwhlGNq5vNjKaGtEI1
   a8wLWqP4vePlfI9faLb18wGkg1OXsWbALuNOvv0vBhAxS/zF/9rUpesj9
   Q==;
X-CSE-ConnectionGUID: YTIMTkmTSkSmeKwcrqbhXQ==
X-CSE-MsgGUID: TPORl1siSrq7jPSixYuzVw==
X-IronPort-AV: E=McAfee;i="6800,10657,11461"; a="51595987"
X-IronPort-AV: E=Sophos;i="6.16,230,1744095600"; 
   d="scan'208";a="51595987"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 01:06:18 -0700
X-CSE-ConnectionGUID: qOIipnnKRM2vQEaPVt2Ffg==
X-CSE-MsgGUID: Et1JxZcaScKoijIbk5Fncw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,230,1744095600"; 
   d="scan'208";a="152345504"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 01:06:17 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 12 Jun 2025 01:06:15 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 12 Jun 2025 01:06:15 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (40.107.212.81)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 12 Jun 2025 01:06:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OyD4f3DgjynAWeJMoKt5Ria+CQYB/I0YUhg9WKmp3o4QUk/VTdgwxqzkTA6J1ekVhpzEWlLJXSrfqZmmoGfCC7STR5zIc8Ivug7pzNgABhUCpTWhduzzHm3gJHtzi+xwSFfTMYXeLicfnGJR+CuXERS1oBViJ8wNTqh6NBehSbrWO/knikqai9/rSBBHiADdPkNiMUPmHGVHN5W6FD0rEcAAoc3ZgBHfOZKyl7rJ8vbvH2dadih4J8grUin1jZ26hS3rXVrHliLhOoL+vFdcaMiEx94z4op2wuHbwhPerSDEXoGE3XD4Bhhh9XGIvb2nkaYUEepTESimkIWmpCrbkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2OnWFLZ8A/IWmKLiJzAzZQIad75DPRdfLz40a4mPssc=;
 b=edu6gJdCCWlPGIXYh9hA9PFqTGV3TWtQ0IeF7i/Ji+vwbSMI2gQEW2oBiByuN/5lllB1MrRVaaGeP6NlO2Jjhkb+cK7IEOU+6iMXzr0d31oxNgPVam6Itdh7RZco+DlhkfkU56JZDyG5HdjRy2oQ82bL6ZSdgKxwlyh5M4/NmVZNcVI5MTDZ3NIObI9m0zWBN+zLwA6EFNI8eImAlQK0cAZQMfCQcoEe0u1tP25LCWrJsaVZYtt8C+S275Dvn5hKtN74niEpAYMNZ+3geCnKWFyW9hqawtm+LKcBQrVX/wEcHTR2Hjx+KMu7wHJ2vHFrOWMrSZ0sw/OQvIZCl5HBKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM3PPF17031675B.namprd11.prod.outlook.com (2603:10b6:f:fc00::f09) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.32; Thu, 12 Jun
 2025 08:06:13 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%4]) with mapi id 15.20.8835.018; Thu, 12 Jun 2025
 08:06:12 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Nicolin Chen <nicolinc@nvidia.com>, "jgg@nvidia.com" <jgg@nvidia.com>
CC: "will@kernel.org" <will@kernel.org>, "robin.murphy@arm.com"
	<robin.murphy@arm.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"ddutile@redhat.com" <ddutile@redhat.com>, "Liu, Yi L" <yi.l.liu@intel.com>,
	"peterz@infradead.org" <peterz@infradead.org>, "jsnitsel@redhat.com"
	<jsnitsel@redhat.com>, "praan@google.com" <praan@google.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>
Subject: RE: [PATCH v1 02/12] iommufd: Drop unused ictx in struct
 iommufd_vdevice
Thread-Topic: [PATCH v1 02/12] iommufd: Drop unused ictx in struct
 iommufd_vdevice
Thread-Index: AQHb2WH3Lg0yPLLXdkKoIwIPr6eT37P/LtcQ
Date: Thu, 12 Jun 2025 08:06:12 +0000
Message-ID: <BN9PR11MB52761076A6A4B37CB1DFB4A58C74A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <cover.1749488870.git.nicolinc@nvidia.com>
 <4c85d75d630d37df6e7140b7d396678046324975.1749488870.git.nicolinc@nvidia.com>
In-Reply-To: <4c85d75d630d37df6e7140b7d396678046324975.1749488870.git.nicolinc@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DM3PPF17031675B:EE_
x-ms-office365-filtering-correlation-id: 1d0fe2f2-6cdd-46d5-5c1c-08dda987ff84
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?O/x1YPv5UDrjZ5HfEIUIRR4XVDldS6W2tI4RQq2ravDRr/yL8wk0QSnI3TSa?=
 =?us-ascii?Q?vbkX4Q1LesZOTosZoUsVyhwPFafv01VekMnHZxjL9PDy1QI2eJf3cbKAGcli?=
 =?us-ascii?Q?5KhA4OXPrQISSj1CQyp1hl5jLwcmvEmBDfR3t8dl9C/SdhW3w/vDkKQul1rF?=
 =?us-ascii?Q?TMZRQyOQyfJfE6p5eI9PaAPxCgFYWHtGsX2sO44Omf9kBgeSpPk0K8RwEOwU?=
 =?us-ascii?Q?XPjnUZIsagCUHd3KWpIa0xh3FAW6QCX0uCbbituK1oHU5uT5ci2J3GhyrENj?=
 =?us-ascii?Q?9yFMH8N5atfU9q8wcaZueNFen+s/MntxnHSPMAnyX/0pPS2pCdnGCJfwPp1h?=
 =?us-ascii?Q?owE7HVi3wah8vS+bjJkgoeUXm1KzKIhIdzvLpB984Z1DLhlFYDT/0rO/qY4R?=
 =?us-ascii?Q?TvZyQgitWLPvkxMDgV7JtF8+ErizNUcUuS4D/clJb5VDOqMDoTItp141n/2e?=
 =?us-ascii?Q?h8v+1BvZTDO4cLRp2nkGKZZAIkCKYoO/T9GFYOiVTNCAwQwQShhaPjcLTYkY?=
 =?us-ascii?Q?Z78DIRaybo5DTH618qdirfZoWglg+Kp8qeDr8iK8SKHPaESAf8VkQVlZaofU?=
 =?us-ascii?Q?RpARymdHqUjRYWEcC4uU9xabca9y8n8KfvAxFGpMgL/QAXJFHkot4ddNU/Eo?=
 =?us-ascii?Q?occFzNvETHl0MqhdPi8vkg2SG+GWH6dzvJncyjm901UA1A5Ay+VIuSMX3ZjC?=
 =?us-ascii?Q?hXVvnEEIXHYqz0JyL7WcqA44Cqi6kYCNhe+mOd6oCdgLomYgGTqJPbFkLrLC?=
 =?us-ascii?Q?vev5MSo9XIpz5lPfdKRVG7mZ5Od0fHtbkkHclON0x2ECQcki3DBvb1x4R55V?=
 =?us-ascii?Q?Wl/aUWAj7uS6IYjW998eRW0O4P4vxv2+73mN+N6OBIn1zeTZ0lZTw25b1iN4?=
 =?us-ascii?Q?IK/Fq+A4LWFAcf8c99z8XhWZLnyhUH3llWKlEmYb4QHqqINM6YTphfOCtY+s?=
 =?us-ascii?Q?1tp3SNuy7qUshQwrNtX7d1Q4vieRblZUJCLY3SBMhOJX4mUFCbmWxOYxgm9B?=
 =?us-ascii?Q?XakielIYaJVdCbj4kke7B85Fe0NTxE0Adpzh0VQu8wiPGoqFGWqSgkIDu6/k?=
 =?us-ascii?Q?OIk2jUNIhcm7cGdXMJHUhP5o7n9t/ti7kZwkRpxA8ZrIDFHwFtshT9BGCdA2?=
 =?us-ascii?Q?mj63cp8TZvuRZDnEYhFuNmwTuwwAjOBuqRjrnOMP8SGdO9oiazK0DKYFCOqg?=
 =?us-ascii?Q?CM86ECx4w8mgjbF34aDuB7F6ewqGWesGauAa7ut2wdaoCDi54AsObY9D96w8?=
 =?us-ascii?Q?OZ209/cLwb3q7tDUrc3PhZ6eE4ccb4Y2Mzb2jOgzfzAzG/qvgYz0W2myvVPS?=
 =?us-ascii?Q?dY9rWEUQJ+UBO/W0UOpZA5jLtPKGYXhq7US442r2i3o0RmgRTs5P2U1suLRU?=
 =?us-ascii?Q?eeCOXLVdNu1+mkoHkSRnBGYhwMyQ9bUmYRrwHFIFDOuPaJE1HIQI7VV0T6YU?=
 =?us-ascii?Q?BbeHhFY3EBUoN+QaevoTjpMRwtvbf5nST0RTEukxiaN9adyk3O76Lw=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?I3AGKHAhgjtjXsFDX5RXDdPFEd3N43WwXIXy/cJSumgtH6qQ4fP0q7kFStDr?=
 =?us-ascii?Q?ESxldM7VGqhXx22qZo0ZCoaa6kgNkel12J9w6sTq9g4Hq3XG28vqGBbhpqGk?=
 =?us-ascii?Q?Budvs3lGWeKlO7pVPgaftA3MpYCcnpq1ad+uco/nqKo6FGaq50mnfRS+sgz0?=
 =?us-ascii?Q?OpViclGQAzYDIkbZ4HZaGfBOxFBCA069M2Ku1xkvUegkBuZJBpq28sHsUFG5?=
 =?us-ascii?Q?TSBSpRASriQUSJpMLjwNiTuMT9hIELyBLdZB8fHSovqjRXnXnLlNLTgOd/+q?=
 =?us-ascii?Q?JtZnMNaeyUXwQgSgjAG645CHLzKLBLY45S/ntxDiO6/5PSBS26fKvH7qrhxo?=
 =?us-ascii?Q?+acqXjije53Sl7UmHWzEHgM31XKQnyNkktJ+VZyM7sFGBDLKENb2ge9tZAvg?=
 =?us-ascii?Q?ROvOVkGdST/5FrS+OQtKB66rwf3/FIYvWKX4tmfStVPYt0/ri8AKyCXv0uTb?=
 =?us-ascii?Q?xo5miVlb95kxgI+iHsRxmFjBVZNmZSUrQCwmfJiXvmeK1iHJMhj6V/GDjF60?=
 =?us-ascii?Q?8tPAG1dugRkjB/GsliAtmhm+5uldN9zpFNtXV7LCwvmyISgbYwiRejiSg6Cz?=
 =?us-ascii?Q?3zn2+4qzL2XgbebUiw5oix/wHb/R9Dn53AUHohYgk6BCYiRw2rk7V+WhTMql?=
 =?us-ascii?Q?rfP4QQx+USNjQ1u/hF4CBTL3Z51Sa1BW7iD0+wg4NIcUz6VCQ6YveqQGt9lU?=
 =?us-ascii?Q?ABbG7rU3LHJ7CiGp1cH5QjBaFOmzGwMMNmi+/YFgv9kpiMkF2Mb7sAoUaalf?=
 =?us-ascii?Q?CUUNye5KCL35l+cJaYDxguHCcgy3O7oNTlKHccYKkjYPv/QpWcKKQvfapgI5?=
 =?us-ascii?Q?Mc9KXNGYHQ7Uy+STqJVvvzNI28h3u5UA1IoZi8tptVWHsOzjdReBaO/E+Bka?=
 =?us-ascii?Q?C9JUPyUpxOovv/AtBF3ryROJiXwu/uIeLaNUgGaYRFypvkHX0jx4efy8Zr//?=
 =?us-ascii?Q?xGsIPGfvDD1LYQL2EMVF5V8hQ6AgC14Xk9q0Xh7L5m7B1X5gx0ol6r3vBXmr?=
 =?us-ascii?Q?Tqn+4UmI6HKWce+glzjMlzMaF3O58iWmEnWYnCls/J4iKJ+XXoQx2uFU4umc?=
 =?us-ascii?Q?YoRn6myb5B+beUlfHpwonoX304uxiUY+wI6ixDt5tv0hv3nbdnS+lXzMJtNo?=
 =?us-ascii?Q?EXhJWxsFqqwtWQ/pXzRtJSY0gkDsqYQ/1T59ZmM069BVcUSL+znp7nLqdnNl?=
 =?us-ascii?Q?iV2WIqRyf0ZyRJsZ5J9UZkplU0DK4fxBf4Tsc/4nvMukSvgsi6M9paPVKjY1?=
 =?us-ascii?Q?Cn8PBcaFdNgs/Doe0ra7K0FlVy4rrgLIMNRNvAnlMJiI/j5rnk7OVs8XMkMv?=
 =?us-ascii?Q?0LSIPniTPSV9+dixvwURKXb2T6sRMBqhz2+/AzhGRfO+KnZLS6LZjDQsdG95?=
 =?us-ascii?Q?TpZwDVxxTSQgmZN+F5fQg0yvuitM1PG/ux13WwEx4F+zpEROv8jgb401rlj3?=
 =?us-ascii?Q?7eKKBYNxo0w7lMgZ3182U2n7CtI5BiS99FG4JHkKqKB9YsQ5j2/qwJpK+YvM?=
 =?us-ascii?Q?Gj5oustZMgs+ldwVpmrSVVO2dZk8KXXKMJKm4WZ9hpxPz386Pqxhmm+SYCyV?=
 =?us-ascii?Q?Y8Zj1466ZFmrGAM4BmqHHdyE8aFENhG4x15Qb8XN?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d0fe2f2-6cdd-46d5-5c1c-08dda987ff84
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2025 08:06:12.8840
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Kaat71gN0y6hlhSZvBIQGwacNQjnJ5Tz7U9usf1LOniTX8yCMpvrIhVSdiV/bZOn9GNz/FAqm3YUg5J71Gx7Vg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF17031675B
X-OriginatorOrg: intel.com

> From: Nicolin Chen <nicolinc@nvidia.com>
> Sent: Tuesday, June 10, 2025 1:13 AM
>=20
> The core code can always get the ictx pointer via vdev->viommu->ictx, thu=
s
> drop this unused one.
>=20
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
