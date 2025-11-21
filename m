Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E623B337105;
	Fri, 21 Nov 2025 07:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763709748; cv=fail; b=fT6N0Ysa9h9QbP52alLdnjt9+2gBfqp1g9krkbe6KembUOq9df3bxY3OOAL8h+TuHM8QJmMjnMsJfgAlmXITxXTgsTCL+rnAKmvHkes/H/Gkg7lSbXhPUr7hQf65Z6jmOci+StkaGnAIOhgpa1MJn5ipX7q0mDJX/uys9iJmtm4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763709748; c=relaxed/simple;
	bh=7GeWaM6cvHXiW6AX+ZlWv/OVVi/6c5PPaaeNOMU+iJE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=diNuKiZTu+OcioVzRsLJa3OQO8jIJGmuTNWe57otRozPjwl7JY6B9xVa4xgkdx9qzRF/pJqqsaCgnl7qXp9qoDHvUK/u3SjYaEE6llFj39qbdOu4BoarGx+EVeGSTYarzFgU8WvZhXI22uMDJrOropLC20QGKAUZgFpwc2RGp5E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cgD7syr7; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cgD7syr7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763709747; x=1795245747;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7GeWaM6cvHXiW6AX+ZlWv/OVVi/6c5PPaaeNOMU+iJE=;
  b=cgD7syr7HyeexwM+u1OC5x0UJl0lLsBEQ/vrZHXh6i8HmPmdvMWj/3jE
   1jvlScGd9UrPy51TsTJm2Eap9R/3WAuBsKP1+nYFDfiEgCXM21lD1xPG7
   ni0fVdUdcF0jlLBB3C0egzcuCfVZETomn3bqKrhmvRN6mVx0H8f7eouka
   DXpY7/C+FU0lT7cd2tTiswQDEtUWEBMq7z4YVRQUNoynv2HDnizuh0ADk
   3/Q8UHitoTyfbzxtnqYg+X39R42jzogo7f18Slx+MZWM0l+dlG2t6m7bl
   AlD+9eYX7ypynr0vX0l8hdlQOkVlPlDCTBkaHUwPPUAPPgUAmC03JFXaU
   A==;
X-CSE-ConnectionGUID: hb9Hk8CYRquJ+dvdK3yVyA==
X-CSE-MsgGUID: ivJjjcFrQJWF/4f5VvpU/w==
X-IronPort-AV: E=McAfee;i="6800,10657,11619"; a="77159198"
X-IronPort-AV: E=Sophos;i="6.20,215,1758610800"; 
   d="scan'208";a="77159198"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 23:22:25 -0800
X-CSE-ConnectionGUID: bKiz4/b7TP+EAVtWUM4ioA==
X-CSE-MsgGUID: Ikq8e/2uRFOL0wZu9CJZ/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,215,1758610800"; 
   d="scan'208";a="191649452"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 23:22:25 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 20 Nov 2025 23:22:24 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 20 Nov 2025 23:22:24 -0800
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.61) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 20 Nov 2025 23:22:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M2s6X/pFat4PmqvxfAPaWwinNooN/EHx4K7jw3XoGzjSRjh13TjOthtD4K20ijrrGkNSnvevsf2xFNU31ZI/Bo03jWarPnozhqmlgyjyn5FIQzNS93rNnqOjSXPRU/UrBG/lI2a42jX9QvfFEQU/y2pLhQM7jwM/WD+INrrn7LK/knrxGrMTdkKTDLFgsCziAv+Tx4ve4R9FFGVRrrn9noSxm7lhJX+DMCpQHsgIF64JFwwhEbkdgc81prrGxRT605d34fMf4VLEFjDG2TNZTerkspWAF8JzbJ1yjocP6y96SeyqwUw0M6H+9bv6FJJzOrSP9ppsAjVL+oG0t8bzAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7GeWaM6cvHXiW6AX+ZlWv/OVVi/6c5PPaaeNOMU+iJE=;
 b=ZLdW3KKvpYP6RCZUkGlGmqiR/cdaz4XL8ipmwe9KKeJJKw/4aqshJ16g/UzNu2S38kR3x8oG0W0TOU5/9xVB/lNurhwhBceI/FglxbRpoycQx7eqQV3UCiF1bqqyVoMVUHwWTz1SA4GhQMUWg5sbxfDYXtivYXiPa20FnykEIQkQNFxq3jWm4AdE+YowxesHKlh+RfA3l6gytc08G43rWXij8uadxIi1Agk8vXeG0q7lIL4Ph9B82c6+/7W1flUes1CmedQS31fWKOy4Z2oELyONwfWCq7dvRJlVqqWWDGiqW393u0X1GpTZTM5J5aJcA9jEtxSpLsPs3xk2YQ2ASg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SA1PR11MB6822.namprd11.prod.outlook.com (2603:10b6:806:29f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Fri, 21 Nov
 2025 07:22:22 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.9343.011; Fri, 21 Nov 2025
 07:22:22 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>, Robin Murphy
	<robin.murphy@arm.com>, Will Deacon <will@kernel.org>
CC: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, Dan Carpenter
	<dan.carpenter@linaro.org>, Joerg Roedel <joerg.roedel@amd.com>, "Pasha
 Tatashin" <pasha.tatashin@soleen.com>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>, Samiullah Khawaja <skhawaja@google.com>
Subject: RE: [PATCH] iommupt: Fix unlikely flows in increase_top()
Thread-Topic: [PATCH] iommupt: Fix unlikely flows in increase_top()
Thread-Index: AQHcWlSiaO0KLLtRrEWvLuFmeThN07T8um3A
Date: Fri, 21 Nov 2025 07:22:22 +0000
Message-ID: <BN9PR11MB52767CD126BF8F90DA11BDEE8CD5A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-93d0836a0e54+aee-iommupt_increase_fix_jgg@nvidia.com>
In-Reply-To: <0-v1-93d0836a0e54+aee-iommupt_increase_fix_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SA1PR11MB6822:EE_
x-ms-office365-filtering-correlation-id: 4f7fe0bc-ebf6-4053-c2e3-08de28ceb653
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?J6mwpOURjMS5vXCaC1IDnqhugxcsWIDyChgIhyLihSubRhvsXF1uek0w6dY2?=
 =?us-ascii?Q?zGiINo2KrerjxYjCUkxdvsHI+wjow4qDbRqQuBNDea9RZ9oRRGsMB0wWXRt7?=
 =?us-ascii?Q?ACT4EZfjZ2UCi6geBeDHzrIW/xUPFawkZVCzMZajLb8YFX33Jx2ROUFzvTAG?=
 =?us-ascii?Q?g1bMqCajvAomQN/Su4tx1hAJixgnHctE2hgyb/LVuSw/EoWhqjapMsfHpCKc?=
 =?us-ascii?Q?t/XEvqttE1xxryJHQlDettUYvwVsdm/kO1HYnUttkR0t8yL5uCUrxl61GhVS?=
 =?us-ascii?Q?iAzm95G0M9Qr2+RkEjIpr2nWFxdQseub/mqct8YN8fAdZ7GXNfkeUaYgz1E2?=
 =?us-ascii?Q?mBaQ9N7yM7Eq+kCV8jIuJV/DZF5Wbw+78A6mSZPDxZNsg3ejc6pkkTIJ1BVb?=
 =?us-ascii?Q?LSXHSyGM8JP2FpnXFmynuzYlfNG4HxkHb7JWoespMHihb3XCmqibFPI9kmOu?=
 =?us-ascii?Q?u/VrnPeD0QSvK3oLeNr09nok6iCK5SW3asQtO7q1rl5U+igQX3gtFrqxYdiR?=
 =?us-ascii?Q?OTPdnjcj7qAQrTP88ysASUdxsGTVCidu4eJYQn6guvAoIwEKsabHwHrlrbsq?=
 =?us-ascii?Q?SLDxhj02k7pZO6KygRIcXMgEChyl4oD+EjgMjhJ9suwv3xsgkfBQUW91KrLJ?=
 =?us-ascii?Q?lQDR/gzsPfsuA77OV2hKsMhMHEnP6jNZTxI11VYeXIB8CbNI5+eHolBfVVs3?=
 =?us-ascii?Q?Ew6pP8e2lM6TABiAhgHWO+Op11Q76MYioIYPvABofCh6DkD/uK73e29KHXmy?=
 =?us-ascii?Q?dE7kHWmLQF1qBXUHTzZGKSqxv8eOU0/rkS9veNGkv3jXiD7q5+79MggY9JB1?=
 =?us-ascii?Q?ejPYaULOVnci8uId7ciqiV+/rk5RUV0rBqYP0SLIt59m1gddjsYNXYjq+UhG?=
 =?us-ascii?Q?f0g4aajp5oXic1rCb0fNe0SOGXn47GnKIbBf+4KrQfHRV4fh0LW/vGVD3ra9?=
 =?us-ascii?Q?rCQnoVmiVuVR5u0IgbAupZKJaupLBV8d9fmWMNqM4tzR5WSX2ROSV727fZt/?=
 =?us-ascii?Q?KRcmzGcPOld0FAWsHCO5NepiXnPgjToEdMLLzHA1CIs5zDKOXOv5WJRHd+nH?=
 =?us-ascii?Q?fzvGbU0rX5sShHLGI0MEY+oFnosp2GzOEjhK6FF3Dmof62P5R8UdeKcqA5GW?=
 =?us-ascii?Q?23xaPW09djHfr1vxW0F2HppKe7B41w5P0XCbrbpWBh+MXPviPwsRniC8mY+x?=
 =?us-ascii?Q?KPWGdvj4zJCd50gvJylMQovRn0z98GteuBvPmc8rFbtO6SJHoP0u+zYM7aj7?=
 =?us-ascii?Q?bxEa0/szAhujE1hue2OhxrGlEWWaEjF/rH+CBvbyggKy6BwlNqcPHviLtmpQ?=
 =?us-ascii?Q?ayoEFYt3HldmJcaQwBrh1flTKpkcyTwaJjG5ngslOOMrovzLresztdyn3X5+?=
 =?us-ascii?Q?si/KKbrKPkh/x4sghP17KXsg3wLd2jQagdEO6zMY55+SjbG2ESoxiDf4pitT?=
 =?us-ascii?Q?oD+rAg6GAluoD7A9piNIAU8hGed8g3tWD5Vlvun2UKX77lrDR73CWCiYFznD?=
 =?us-ascii?Q?1eTGSivLECWLL5V1OTjKe3n852F33nfZMv4I?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?pSHX8TDPWT+7w4x/92h7L+2F8cGPO0GmCR2VgbuUzFXbj9as4DBvA0Jl2Vfe?=
 =?us-ascii?Q?rLlbnaHUufjJv49x3xLcTIRy9AEHYremagM9tqhcZ19XrQuW1LYv4qSzUtIs?=
 =?us-ascii?Q?a+RIl0edb9fhZcm/fqzT0pkieCo6cJATAENe7Cbakc2iNgnqwHUD2bYKNS8X?=
 =?us-ascii?Q?6p2OHbsv4ulxbMgMXxAvVPziKMGerJRqcx51j3/3IJPltyvu1vRuQWCR1WjA?=
 =?us-ascii?Q?Se++atE0uHxbpQZoWeVjLngJk6RTEVt8vNHuaZFkyxqwRiKaj/Ke4/IaoDat?=
 =?us-ascii?Q?RUjWmkCR7m6hih/3XI5pejrlo9MFIafo9ucyL0u0a5/8AHH5DKcsc9CRE/xk?=
 =?us-ascii?Q?5i7mLjVOlvvPwAgnpny4yMYZNOzOdriNabxpxW057qIHqVC7ZvHCeQPqx/2K?=
 =?us-ascii?Q?PiybYmNnRWQG8T1tCf+OPMIe15KcxiDEhvRMrgu3KxErX7m2+yagRAx96UuZ?=
 =?us-ascii?Q?jCGg0dB6em3BTJ+7ZIPWSWLxyG3DJKfFpbzjXejnFzI4IcMCameSQyReIAXg?=
 =?us-ascii?Q?YNWLVCZPrNUlXV93W51JFStXShK7NKdpMYN+kdByzCt2u1xSKVZEwiDAJcQK?=
 =?us-ascii?Q?2BkrYe6+aV9voSdxlECyA5SU2qv3wHMMrc+qHPdtw28AAuqaGxgCwqmdAQRE?=
 =?us-ascii?Q?IVVVSYG0trdWS5Q2Px7/W9vrrbFw0CNCejUqlSDvI4cBPVw4KW6gwCoqnjZ5?=
 =?us-ascii?Q?GvXSOoCKs8RoqvLrv6X1FvqdN8Vfwu2Pm4RpHD4wCwMBsmPuFf9OL89mE/uL?=
 =?us-ascii?Q?/6QPtaHcUVIleqiWCV+gVKRDVorqtX+EwtAiND/fr24SvSCTsBxkjrlTaVUR?=
 =?us-ascii?Q?lA8XkqBw7bwc9IqJzpJbpPJr6VJgoM+xfTYq7s3rLXVRSmidN0oJ00Dq6IoY?=
 =?us-ascii?Q?zWjlC5ueXtfdnzqiM9wPY6B3R5uqOPAhvhxHcg/q7OXQDlQgnOc6Ce6Cgq4d?=
 =?us-ascii?Q?d+3nnO8tzq/NLsxFgE78ltrAQ21/XAeHUgGYaZq+uVTAqbFl5dc2LHlJ6XLs?=
 =?us-ascii?Q?B6BmhD23HU0cGqook0o0EUVQXooeLEPaPwVaFBSDXjVDZUg+qEgfAGy5wgiy?=
 =?us-ascii?Q?gup5j2HL8IUkqlPamPQz5ORHyeFOvNLpKWQBRnwIzH/PHN7aDmBnCsg/VhPD?=
 =?us-ascii?Q?o4k4gt86n9GEY5buVfm08K79aKoVWkEMGifxcJXjRmhsmiR7+N8ly+t4Efwv?=
 =?us-ascii?Q?yu5HayJICGyhdYyjyWWspiaszIYhK7C6cpO8XHJxgNW/o1DrV9i1MrGGmNtT?=
 =?us-ascii?Q?jarSW44EoVjqvs9KuKUcakPGDy2+Pkx4ccFtH0LVjg9KLP1RsifmQK+Dymew?=
 =?us-ascii?Q?nWSe4woZfz8cjqM24+518+9uEpgfckyh05pHQRyIclgy+GQrInlwdgEgjdaI?=
 =?us-ascii?Q?V3xTY6GXtm3cVOmVqemdEWef91fimzvlNVRrfoa9EDhZrAPWWJEd77R1b3b8?=
 =?us-ascii?Q?R8DOepOvCibuM1AWINtfx0WptE0g2vxlU8k4c1JfIyf5tMU4qU9wF4IcL4nZ?=
 =?us-ascii?Q?lP36plcZRaxTomw1a9J/clChM9onD/uwKPiLiCp1YtV8mBsJjbYE6cTE3xND?=
 =?us-ascii?Q?hzxGtdfCLVoKGYk1DJ4OtGT663xlnrxDVA8ZvR5b?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f7fe0bc-ebf6-4053-c2e3-08de28ceb653
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2025 07:22:22.0383
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1GSG/2eVIIkUoyzdiltv9SsqQ+k/o5aBIIeaNOzBNBmWFcJM90QHMGZ0kYWsqQQpPszMWCaQiipoqGqT74ug6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6822
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Friday, November 21, 2025 2:48 AM
>=20
> Since increase_top() does it's own READ_ONCE() on top_of_table, the
> caller's prior READ_ONCE() could be inconsistent and the first time
> through the loop we may actually already have the right level if two
> threads are racing map.
>=20
> In this case new_level will be left uninitialized.
>=20
> Further all the exits from the loop have to either commit to the new top
> or free any memory allocated so the early return must be a goto err_free.
>=20
> Make it so the only break from the loop always sets new_level to the righ=
t
> value and all other exits go to err_free. Use pts.level (the pts
> represents the top we are stacking) within the loop instead of new_level.
>=20
> Fixes: dcd6a011a8d5 ("iommupt: Add map_pages op")
> Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> Closes: https://lore.kernel.org/r/aRwgNW9PiW2j-Qwo@stanley.mountain
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
