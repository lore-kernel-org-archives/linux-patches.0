Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A6F7330676;
	Thu, 18 Dec 2025 06:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766040533; cv=fail; b=A8u2yyuYYZrGmrh18wUkCyjutFUGJ2pHfBMG2ISNryuFKnoVbAOx8cNuSNMwuJlsOQnKUAvmdimzpPsJ42pc53Mfu6Po0/cOTkoTHobhZaI9dATHZEzQZqMWbKBIdGkkiqZWjrB7OCvgJtCU3BzV2ZDDmSZFstx8WVv/I4jBgek=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766040533; c=relaxed/simple;
	bh=FcN40QJhjZY0LMdMx9k1RMbkxJFx9jcA07uXs0sRmLw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=MV0FdQeIBjiq7b6aA3uzgT11GDTyghGRnIGlC9Jh5vRWxdUZRmW8gY/LZM5yLurXrhYypNSQNXn3KK3dg1S5rQ1lfZ79kukzp/Piij/q/SE8RtxexbYBXZ2zafApJIlgUKsDQPlkL5PUeEGmaNUT/lABBxjiIXnZZK56djbpukM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=G5bXU2Qx; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G5bXU2Qx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766040532; x=1797576532;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FcN40QJhjZY0LMdMx9k1RMbkxJFx9jcA07uXs0sRmLw=;
  b=G5bXU2QxiCCqDxL1gqZZ3TZbTwtB7Ed/ThjGHYZ/SQNAMe4WTcN1tBlX
   oyJhgClZNnG9GV5IR7Ot0pc9fkTmBBAi3ZvQX5XNQNwk4OaTpKWm+rEdZ
   39nvMTwk6Z25oG5oU2jzxoRf6/geP00YAYtdg8pgkjlnp5pj+1kCveLVg
   SaCRGaC4b82TSc/9BWiGEZZICNeh6l5tUsX0SC+nCjQyjYgIQKWXh5jNT
   0x6yifmTSshv8h3osYpVF8c2M1/Hsz0am/Ki3OlJm8GUJGoR0pIn/26iy
   L9cQKf9gwQ29swyodA4TJ+WQj871qGancRsumziwSx4eIkElvY0qkDMkA
   A==;
X-CSE-ConnectionGUID: BY5pd4g1RlOAUfIrNDSWgg==
X-CSE-MsgGUID: 4ddBsvUfRHehxlsAqJH0kA==
X-IronPort-AV: E=McAfee;i="6800,10657,11645"; a="68059780"
X-IronPort-AV: E=Sophos;i="6.21,156,1763452800"; 
   d="scan'208";a="68059780"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2025 22:48:47 -0800
X-CSE-ConnectionGUID: CUk0Xz/iSCm63gDU+dmm+Q==
X-CSE-MsgGUID: BTBfPyQYR56ANWJpIanGgw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,156,1763452800"; 
   d="scan'208";a="198984547"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2025 22:48:44 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 17 Dec 2025 22:48:44 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Wed, 17 Dec 2025 22:48:44 -0800
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.34) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 17 Dec 2025 22:48:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K3urFERPbfznsXjhMyC3Yp6ItmG4erNBLEnN2xDiQKmW8b9kxKRb5V27qaBvQDx1hM8F3ansi9Zw2ao12mwDYqfDtsqj71KU+/mkXMqH2De+yvBHEKbJ3QKmTgUqXDXoZ+9kp1If8JJIo37vIC9rYqtIM8YJYhYYqF0zhY999SGeuBgOrVFPYz3chJM0MXSDnqjCcmIPW2YQAq2EXtVLNnqhUGsICbfdLbUiwXsl6Eqj//6W6bZOhWzX/I8e/6ZxKNQunGmK6QneOlyA4Y1kXc7YHZH3z+7MFkt3GNjIPmZ5Ct4EgXSU7zNynfU3EANwFA4I5JGxzXC49AuGW9nMvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FcN40QJhjZY0LMdMx9k1RMbkxJFx9jcA07uXs0sRmLw=;
 b=qbNMXs59x1JXHRnO27IuLJ82A5x3+Gx6YB8v6VqSrkC7ZNWA25lpSkv9FVxZNXt0yiHENHAWGmyoRO4AwkP7cm5pp31r1IDvxAoR9aT2aVJ8SZlOvAWuMaaQyA6c8+JdWS7vqwvhAEmFN7KQO2fvdzi9WF8op6MAG++wgkpefNgithEsHKlln3ZBo636dttsWEBL5OpkRDXcmx/tR+5U0Wq5DQRNTRXHnofu50aM3/bZEPlRUlNqlZ4XVy7izn6bfLEskFu8r7BLwekkhopQBqxrJzzJKJdYh+ooYeXRoX69IJWJx7FwScc8LAySt+DBRQcY6Ab6nlFYJj6dqCxaGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ2PR11MB8322.namprd11.prod.outlook.com (2603:10b6:a03:549::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Thu, 18 Dec
 2025 06:48:41 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.9434.001; Thu, 18 Dec 2025
 06:48:40 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>, Robin Murphy
	<robin.murphy@arm.com>, Will Deacon <will@kernel.org>
CC: Eric Auger <eric.auger@redhat.com>, Matthew Rosato
	<mjrosato@linux.ibm.com>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>,
	"syzbot+57fdb0cf6a0c5d1f15a2@syzkaller.appspotmail.com"
	<syzbot+57fdb0cf6a0c5d1f15a2@syzkaller.appspotmail.com>
Subject: RE: [PATCH] iommufd: Check for overflow in IOMMU_TEST_OP_ADD_RESERVED
Thread-Topic: [PATCH] iommufd: Check for overflow in
 IOMMU_TEST_OP_ADD_RESERVED
Thread-Index: AQHcbq9YVdolIAZS4EqqeAUoY4nFnLUm90SA
Date: Thu, 18 Dec 2025 06:48:40 +0000
Message-ID: <BN9PR11MB527690F4FA9224D0EBD7B0498CA8A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-cd99f6049ba5+51-iommufd_syz_add_resv_jgg@nvidia.com>
In-Reply-To: <0-v1-cd99f6049ba5+51-iommufd_syz_add_resv_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ2PR11MB8322:EE_
x-ms-office365-filtering-correlation-id: d493a384-75e4-4883-1f5c-08de3e017ad0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?eRgXuW0h3CTwjee/dWLL8FYFIN6JAbeLRni34OKsS2qY5n6FIH8o/AzDZYPb?=
 =?us-ascii?Q?dLhCkBCYMx7sa3PtQPc0Aavlzo+wRhsStLCIhB4DUr9MSY4dhtR+P5uaNMSp?=
 =?us-ascii?Q?DFPYnGexj01gijP0xCH8eE8/l9klemQ3p+Fn8LYYf3mRp2mX2Ike9skjvoq0?=
 =?us-ascii?Q?zEd+2HBPsVJ97cIvZ5vr0jAXa7sxIpguUM7mgA570WHJ/G24zyfDU1mbXhu8?=
 =?us-ascii?Q?y2Q9NDPuX2Xo+MTPSYXMJTTr9LF8YT1c9gLV7c5wfk6EtQ7+iVGOM4sOyXUT?=
 =?us-ascii?Q?mlb5TQ0RVSYbzPbhGE6crfuRJEqFee2+gvAUn8u18MlgOKivlqQB0XBK/9M1?=
 =?us-ascii?Q?SPSH7C+Ndtv/JY3RSVLGMPrddsdIV0z0GICTyFMv7NKXRwO6xqrBdvF/YjGW?=
 =?us-ascii?Q?yz5POrbpg/bkmttec6C4JT3oL7Ctr3NtRCPRgByNwpes7F1R662SmIze6K3X?=
 =?us-ascii?Q?lWCGOKj/JhpegPQX1wjvHlAPkYCA13WONyHKPF5y8+cjt+s61cSsuU+Qv/WT?=
 =?us-ascii?Q?LHD8OFDn3qGF6xUHR9mKLK+40eeEMsHTFz1pQgKSP8feHS7/ybHLOXUI5tdl?=
 =?us-ascii?Q?etGFPAOz/z2bvTB/ihy9iecZBtiJU0EkuF2wZTP2E2x+hkYbKAUuN7VHHjvu?=
 =?us-ascii?Q?Rezjr3twgMa3crNVqCCN54pvmxUEwmZXCO6U+XKskkMCPd53mTjqgRXxoEfk?=
 =?us-ascii?Q?FLV0WWGRi0GNxmycHERC5KaUC0S9T3PPMjYUDiRLZ7Mu2gLVOslJAh8XT80K?=
 =?us-ascii?Q?rq9xv3MtjnPWChqBpJRT1F5R3C33s7OoafDGP5pAjHB+qmzKLg+Gy0d4wocx?=
 =?us-ascii?Q?jKCM+uO0+Xewu8fI2mzvRyIQrvfFkkvu5U6DH3Fj0nD4aUIdXB549M8aVfhj?=
 =?us-ascii?Q?1hYirOwxoVaqv5UAi7Jb8zyXhmW9Cm0fJrUy6z+jsYvqfPu/Vwa7IOt/WCqk?=
 =?us-ascii?Q?2aorVgbq78xbnvvnq0avifPS8h+jjobNx1VW3RNnYblwZxKHrQyS7FZkIv9E?=
 =?us-ascii?Q?3WaIKfVRDrTBmpLNa7mtkzhjTv6p3Hz1VRv+i70PvAaQHh/z3tAf9DA/0r/O?=
 =?us-ascii?Q?C42qPrmCSkwRv2yfqgyXvKLd6x/Svqi7jMxdI+o1GyJJJecnrBOmXvJ3YSEb?=
 =?us-ascii?Q?XQJwlRP8F6ah3L+yn5y+QOo05AfzdGFybpJoMh2PxG6nuz4pMwyZ3Q1WceFW?=
 =?us-ascii?Q?MBb86blw/7wdPBtj4bcILeNGvsJaq5Q9dxHnB0kpgklHpbGtq6CU7EF2A9vF?=
 =?us-ascii?Q?XlZAAviHrVs5fds/UYr/J/yvqw7gAxad2wNhMZ13pk5UEIkRakNDYGnDe01o?=
 =?us-ascii?Q?KYitC6NA9lajPEOypdPB164H+Lj08YLhow09RnPHsxyHSmHf1CPxV8eHyDd3?=
 =?us-ascii?Q?aoUntehNCbQG0KRgbDXsdt2LIctjJRc2J12ZIfphU0PtRCyVXI6odtZ4HzK/?=
 =?us-ascii?Q?bLagC2rT6QBF4KRZwLhqLDv0duc9w+4IxzhvJEsStYPhI24rX06sGdsi8hUD?=
 =?us-ascii?Q?HORBeW99a/dz94/KmAK4ohAhpNZIHAnzeX3t?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?XVNvIjeuSu1zuWAOatwgWkHQFmp2DvM/E979+tci1lSP/iNdKo++a5DE1O1T?=
 =?us-ascii?Q?qCYmePg0HT7rV42NlQrIxbuT29wJeRBCOJNQKJRs+8cZjlwGWhRSkhHfboIA?=
 =?us-ascii?Q?V2OB9ACYNd58TD4ujjOpAWRDR+h4abXiSBgImWFtbxG4HbSp0bo9fJRgmhn+?=
 =?us-ascii?Q?qvWiwuLrGAdta747StBBa/JiFL8jT5EyvJPj8OBJqRTwDqXMY6oTyeyKR9Wp?=
 =?us-ascii?Q?aZpiY/OqOo3rC7IkbfBSTMZJebbPIxo2KGF2VKen35oHw8MgoKCuevAItluO?=
 =?us-ascii?Q?iJMQedms2E6/grhyqhWxDUbgtXyJeT3853nywzf4Bom1GhXnGL2GmNOhXb0T?=
 =?us-ascii?Q?C+gow95RNEPG709sVulc78Kwz5Ed8WkrtCqsSGjMXu4cFEWqEX5A9TUFI98T?=
 =?us-ascii?Q?ItTrV+gPvskT6PUUmHWuc1bkn+XhbHimIN6xSDPTxNvzqASEYdPDK8XeIy9U?=
 =?us-ascii?Q?G8v/A2IKSXbZ5ENhaRIfLjX63qlFEkPqAOa9LljWm/yDjoicldTkMzM20x1T?=
 =?us-ascii?Q?uFFYvinBl7yHk2OQP41sPHAmAdNXih6DpgcVWYCnKsl27od2mebvJA1zC9ME?=
 =?us-ascii?Q?wah8RRzXLOG/rr0zfvFHxWOFF7QXwhneAMu5Cv2giwjLw5hkx69ZTPuv+7fF?=
 =?us-ascii?Q?ZRtUijzZetkwu6rPgffhvTLg2TAsxrfKPcZEDZIk/lsMoWVi1eRnoK+MHNPH?=
 =?us-ascii?Q?DBCJLghKVURbc3bHtkBpl67YCfvWxYRL9cdTwLSWziV5U/FtKxniy0NQO2B1?=
 =?us-ascii?Q?beRD1PyjyQn9p2gWnLFnAPvAaNJG/GmbEVBcCVe2yfgqDZ6cCYm5+kWmY633?=
 =?us-ascii?Q?1BHErFnk1pgrutfIcXOx6mNVtj24xyAjYug+6t7ymx2Icml77M5/9JoXIOtQ?=
 =?us-ascii?Q?z+FJrrNzX1lgXXnMNbVZXcXC+fFDJOXWRMSTd74gOFI3XEzpNlbFk21rD/Le?=
 =?us-ascii?Q?320T8rDm0z6dQulQQ6RVHnaTbNlPjDTEIRDtRCLi/ZAsVjobGbY1N7TrRxuS?=
 =?us-ascii?Q?qGG+irU575W35wqgTn3rkKVPbGs3RhRW54L6A5ypLWjLdoIn/RJEWQIoMr9T?=
 =?us-ascii?Q?VO/QSd1EjalSTariG+jkp4e0yMvkQQXfconfan9uGwd+WjtfqBCd0bCjFb4S?=
 =?us-ascii?Q?a60sSm++sxEIFWXti06iz2odxiP2x2yMGhMwxOt50FvBT21GxgXiG0ghJR0m?=
 =?us-ascii?Q?QE2RxWpzgCwfYEWR56PWKhHN5zTccaa4I9t081wT3NLm0C/0PHCsB2fk7OgM?=
 =?us-ascii?Q?nB/n9YXdiVWS1WQYWVK661bIEQFFOAUiKx2VQA3Ii0GWUcRA4VmsX/tOspNK?=
 =?us-ascii?Q?XfBivembjERKl3fx9vwDy7rAezglpH7UJsWes94YhGXdTsbFTaCqlmT9AUYp?=
 =?us-ascii?Q?nZo96HWh5XAAiShe19D9CWezwMuy5SQO/Ah/2xHJ/W4zWhgDrMvCrAAk/8oc?=
 =?us-ascii?Q?MRhgU/K5h+9cPhn2Om9n9GksLsDTAegljltK0Yx2JCvNoAoo5bmwFKvVeAbY?=
 =?us-ascii?Q?k0ORJPDXCAknGC9Z4tyRmDvTL9xhYPzSiU7mCvFDvF7XyB/wJDNGJBX0i1pS?=
 =?us-ascii?Q?nKZ3SKcqfrr4+DeokHOVi9nHxcsmSFp9ojPylfO9?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: d493a384-75e4-4883-1f5c-08de3e017ad0
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Dec 2025 06:48:40.8920
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Eo2hKve5MRPOIWWXCMLxEZQLC8zjeXIgC2sCcJ/R/qEnV60T6c5/vXZi1Gx9Pk4qVCEoH9TXGlBppAbklVnXjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8322
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, December 17, 2025 1:14 AM
>=20
> syzkaller found it could overflow math in the test infrastructure and
> cause a WARN_ON by corrupting the reserved interval tree. This only
> effects test kernels with CONFIG_IOMMUFD_TEST.
>=20
> Validate the user input length in the test ioctl.
>=20
> Fixes: f4b20bb34c83 ("iommufd: Add kernel support for testing iommufd")
> Reported-by: syzbot+57fdb0cf6a0c5d1f15a2@syzkaller.appspotmail.com
> Closes:
> https://lore.kernel.org/all/69368129.a70a0220.38f243.008f.GAE@google.co
> m
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
