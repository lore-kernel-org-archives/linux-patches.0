Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A21054A35;
	Mon, 15 Jul 2024 02:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721010357; cv=fail; b=uOKCdGpsk0rsHRgcGZ5uT6AwWvqkU/9pedhWuq9DggyREfqjU8kik2Nv60H5+CEyYYFPZdlnrQorF5AiTi75bx5WIQtLC7aqWkfsBg+t7NuzYGjWuXKHAO+CQCF3ewdnXg1ufvyGRB70jOKa6rnQVfn4MYpBdv9aYYatX0BXDro=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721010357; c=relaxed/simple;
	bh=TiQfOs6wj4LC65J+A8ME0BZCulOwkGjarHOVb92xK5w=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=b0HCztDj+PbB4fpxFwh3AEC6FskTKp30mZRNLRZxYcokx1EijfCQgFeBR3wAWvL4gM/aMXXVV1zYcudjLq4aT0QRvDbPvHkF/k5HIEkhBOqOKi355F5WAuLNLBIXAB8z5SMcb+R3n/x9I2xk3sZA6l5H6ijWCquw09SxsWOp90A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HhOJobee; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HhOJobee"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721010355; x=1752546355;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TiQfOs6wj4LC65J+A8ME0BZCulOwkGjarHOVb92xK5w=;
  b=HhOJobee9dv1pdb4U1fJaYsgvEejrUKH0x9ar2EshuOL449cOvIe4Bbl
   mNoBFG5X7tyo1a533zp/0/TRNV1e4lmmF7m2hHBi1jlGeNkpthWBbK++c
   yZs4Xh8pksUBND/JzUiI6bnxL8fmWLGKZ2RJrCQgqRmchkN4GqQCsZ7ot
   +yBpyqiD7dNzdAoFH4hih/zVFqdt/fYGujqPPB0orxC+IScifC2VKhwc2
   XD672MRQ/6KBTRIzxt96E37DLWa06iIwVWqz7LFu5IdDjMt2mGwHXETPf
   Os4VC7OPWAult3+KCLB4O5XXrBDvK/akmpzL0KIfmmdc0sWv6KdZ59Gvm
   A==;
X-CSE-ConnectionGUID: uVtVk6xNR9GXRtn5jsoe3Q==
X-CSE-MsgGUID: cqJ5HJ/oSGClEZz+aFD/jg==
X-IronPort-AV: E=McAfee;i="6700,10204,11133"; a="40903024"
X-IronPort-AV: E=Sophos;i="6.09,209,1716274800"; 
   d="scan'208";a="40903024"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2024 19:25:55 -0700
X-CSE-ConnectionGUID: CnK/81jIQYCswtytscCKKg==
X-CSE-MsgGUID: 3CPVUKqQTf+uuFaUT0DURw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,209,1716274800"; 
   d="scan'208";a="54298499"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Jul 2024 19:25:55 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 14 Jul 2024 19:25:53 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 14 Jul 2024 19:25:53 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Sun, 14 Jul 2024 19:25:53 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sun, 14 Jul 2024 19:25:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WtKoEa9OpY/ImEGpCAA7LvMWy+YI4nNeoM7Ctw0rPZgwushGjPQK7IttiNM4WzmubHYjgJKaNr9YG82EtQHlxiaJo2TQVTCj7u1vuUWVQEUYpAGAgTUiurOdV4CyQRrS11YIIR8PAskcZ73ruPIXhorwtFDezKhQqSJ+Al+I+4YD+JU7nLp+k+lPf7+Q1n7ca2X+ZRj1+HjbSOycNZj9ZEXszNzRvvrZNsfgVyqpbpWyW2jmWLLiNKJaCrh4NEuONO9F50vmHAYq7EuKl0eQJXDJS3ctrP6d5qRc9usqhDDq8hxlFYUvVbGoYzFc4/KQJqje72KjEyngqmyC13onAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TiQfOs6wj4LC65J+A8ME0BZCulOwkGjarHOVb92xK5w=;
 b=rcXxb+yl9vDzS05/fylimcenmLIhFzmt7zope70XpICE9sUCZa1/zo2BDD9sw+dvf2gbNjkJ1sXycY34smHVEnz/np+nwogiGnSAzMIzr04FylGwK1C6e9W3gD0vEXGbQc4ml+5bRIZTJb62kV8g9Y6xfuvRzscF5vEKlw1qL89Qt8TjDaiYgP2xvmbV35NEHAZmxroZRIA7kA8tst0X3n/yRVGGRgwquWSAQasNsFa1AHZZhwdWTb7bP0ZA+Q+aMpAV2iuo7Nxp9BQgxrcAtIO65pfX6j6+g/6eodZ4geKA24R54oeTwVdnigS01QhnAPNQ8th4R2VvmO7PYWZ0mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DS0PR11MB6543.namprd11.prod.outlook.com (2603:10b6:8:d1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.28; Mon, 15 Jul
 2024 02:25:51 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%3]) with mapi id 15.20.7762.027; Mon, 15 Jul 2024
 02:25:51 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [PATCH] iommufd: Put constants for all the uAPI enums
Thread-Topic: [PATCH] iommufd: Put constants for all the uAPI enums
Thread-Index: AQHa0/AFpCJa8D5AEk6fJEoRx7c167H3FDIg
Date: Mon, 15 Jul 2024 02:25:51 +0000
Message-ID: <BN9PR11MB5276C08C036032EBBC19B20F8CA12@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-2c06ec044924+133-iommufd_uapi_const_jgg@nvidia.com>
In-Reply-To: <0-v1-2c06ec044924+133-iommufd_uapi_const_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DS0PR11MB6543:EE_
x-ms-office365-filtering-correlation-id: 9f50c25e-3b88-4886-b8b7-08dca475724d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?PKnPvBeRCyYVjgQp3v+Fdy384QVmjS6317MIecsDXkI/8wfdcDDz7ElVL8Y7?=
 =?us-ascii?Q?9U9GE9QFxoGbhd5LSN2yFdnt+2fuO4BNze8hrG0JD1DYBy4Tj6n3VNOsWT2A?=
 =?us-ascii?Q?IRX0KMkJvJHWjd7zJvt/I1MD4lFLgq+x1Ph7Hl6feyh1vRClFVQSzRQywNkl?=
 =?us-ascii?Q?h/M/wOfJNR7UqSsRbSEQG+EhlOQKqEW+DMfa1Y16UfPhAwzRIKFNu50rAuFe?=
 =?us-ascii?Q?pkUVjQxCBGwPlVfRsdjxAeYpxFGoTuZ2/BuOC02szOWjZiXUmlAmVj4Av88W?=
 =?us-ascii?Q?6rxM8DzTUy0ub5XRyuAV/U6UZRh9VpzjYl2B2cewtw55jBfgEHoKM82HOWTu?=
 =?us-ascii?Q?XyuaFa7pPY1jtu3PsG7mULAOyZRGqeY1WStZhbWpWThkIYWwr8WVm3JjfeSI?=
 =?us-ascii?Q?5dTrzcnh2RCtf3IBbriGkM8vIBJ7UyCwLnBzJ0gVmbp2X/GWoJGrKxMHrLfN?=
 =?us-ascii?Q?lBKVKrctLebU7e3vQvAqEnylfqSXTXNOTpLj1+onacMUsQ8ZuyEsbw7o6tMj?=
 =?us-ascii?Q?vnUAjPQpiFmHdtPcc+bscBs4Qobfsdajh7GiDIGsoMJZw/K09ugD8u8ntCSo?=
 =?us-ascii?Q?Ovg7VQRSchKe7tLvqFCzGhkevfLMfnc2uiHVyqvT7TEDTFCOaqqY1nodh5Gv?=
 =?us-ascii?Q?I5H+KdXcCc70eIpXulhlaxpAdnN2iooqCYliTo7FqW3Xp1SEr6VAoj4iF6LT?=
 =?us-ascii?Q?m+KTsWHhHYgIBtvtqmoYhmcJkw9fAGZG2dZhicpCbx6A67VrILvnu2YkW0Nx?=
 =?us-ascii?Q?v03u/WEWL5Ish9H7qfHKr/n4OoEX2ZA/k3QQl97oHC69/ZCGVDJLbpRL+7jC?=
 =?us-ascii?Q?g8svKSoorlNGTpttDtka1b5lbKgaj2eWEbnYF7hyGUPzDieaxHzxiKeuVPKt?=
 =?us-ascii?Q?1OIkh5J1XfG4DLJMdJhOZKOpeBLEs9zz1Uo5gmAV2yZtvgcRr9UJE2no9gw0?=
 =?us-ascii?Q?RcIHK5mWfHuVnM48JGILwkC/zJYXfgyybdUGfGKhsvfqTb85SNWGR/ykpioj?=
 =?us-ascii?Q?z6Fgo1VDvYYyknWnDeJsBlDzrsdUr0Y97eUe3pBlowGHTKHnplTk+oiZ0Ggi?=
 =?us-ascii?Q?xwNOy+4U3K9UdlkLLA+CsrhByblRUSF/B8m8Qbq5Eywyw7rk7FPckjWsnBNm?=
 =?us-ascii?Q?XyI3noxsMaTagffyqc2AUSIVIwki+sIygCAk+jIFvC2t7iIQkSgaafKIvqIZ?=
 =?us-ascii?Q?A/qP4GnuzY+GFP2lQkWY7kX3X/5FBY4CHbLKwagvN7oJmla6Bk9t3xtkUuVU?=
 =?us-ascii?Q?f32ATh+ylOxrkIadyrN7Tdd0Ijb2P94B7fIMoM03dlqTukp8zGxLlDU+uuhP?=
 =?us-ascii?Q?wak+KFja3VG7c8O6Z/lr31TK8SrvskC0diXLCW3/vFW2PweXgFQoqfFgRfLV?=
 =?us-ascii?Q?M//hm9iZAjByrzruTWWCBEJXT4/sUX8ywl1pntZrvtotH4stdA=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?s5AE4fUfSZlz0WG7UzvGBbHQldYNp2SmBQZ02QjHGRdqwnl8PR0ZuaVMc9lT?=
 =?us-ascii?Q?TWe4bsoQwYmHdYBZI9ZK9zDvCTAft4hOghKGp6vz7Xa1dWWjMTSMAaAQEA+L?=
 =?us-ascii?Q?HNyNxO3gOmZSn+G4vkcAtzgpmrTGU/z2AlblL9DDHnbpUg70Zjf+ICHRES/q?=
 =?us-ascii?Q?4VwMpwtOzbz381EK88hTKbV28G+yOcM+zt1ECNsFF7ZMUKKfM3QscZf9qcVU?=
 =?us-ascii?Q?lJjYBsvwdneMlprUA4Hd/dk48uFJ85AzH8IpUP4M8bT4TjwOQKTS37meZcU4?=
 =?us-ascii?Q?lmP5SPh0sUtPe+pvV1oFk+zTLo/umXdotRAx1CeIxdVymHZRvSrpt5mA/1UW?=
 =?us-ascii?Q?KVuVGdgTkG2FqUHet/SFbcQEOSOsxI2lL5gLcbJ20uwuX4/Mm8jgQ+FQcaP1?=
 =?us-ascii?Q?KLfk2hsRxiXrJQbQ17J+CoEPdV/yXBTzi7lgKmgTB8DtZQ8aeqDOJzPxviwU?=
 =?us-ascii?Q?clLoPRdrms6hL2QOp79t70Mi9+6hCpK2zoSEXZRLKKEYD4nz9+9V0Djjwb3e?=
 =?us-ascii?Q?lPKxhhKuhgG895ztLflr8+jwaQynhehLlPBJfRm1zs8/nodBgqcjQP5uOdRR?=
 =?us-ascii?Q?tmWrd69T00BqNvg4WYRUwYo+CuytxdRQTkn3wkolUpcOtNPZ0tDPMMX1EfMm?=
 =?us-ascii?Q?hPXKf82YdPR82YBisTTMS4X8pYB6QrwKyWdSQYx7LfXRhgtpTdWZFc77PJnC?=
 =?us-ascii?Q?MWEkPbJrY9BSFTdbiki/+OMWIJhMfXz0ZFDzsuoZ7zC6lyKJuEK9qfSPRdvE?=
 =?us-ascii?Q?08RtvYGhGdRa5Tz6H9Vyrv9kLZ1kDxYxMWj6uf2/KMgc0h+ADOrh8LmVg9rB?=
 =?us-ascii?Q?42JVA0vFFpQwCn0HpHCYYn/OWbcVDWKuCSRCNhVkcIJOzQbgxih7n8HyZwuP?=
 =?us-ascii?Q?MxwCMpgjajsOrKa65zr2ZqNxyiwcuC5FrGZ702oiva456Ypsy7wXHWDLDfaY?=
 =?us-ascii?Q?hZKQdxNtV+Vlb1hzBN32eqWnJumb7HUxBtaUi+FeC+RAZXi4NecIbG4QA8Sk?=
 =?us-ascii?Q?XyL1wdHWs9DBNK5KnXvQIYA1LGLFF9T2o9SG3Ui5ARJQpdQ+In7qh/OXOYA0?=
 =?us-ascii?Q?M3t6JLTG2/6hkgkNx5h412S0p92jugFxMYCd1K4UVAWyM9at5RVMNMqELvGz?=
 =?us-ascii?Q?+qBnfjbw5DBa7J1TZ7Yf+1WTNVM2cwSHUIneijlcJFfqlEQXi0gHioCskzBb?=
 =?us-ascii?Q?cxnnmZmwEvEN6wlLZlSkPSRalyG6k2xUttc/tUZvyYFjxcWsoWPCUKA5Q2PN?=
 =?us-ascii?Q?KVOa8v/a6bfIhp20JkOYKfOMiWn6Is9UfHyywFJDFd9OSN67oZ/6obM8anB1?=
 =?us-ascii?Q?wwP20e9Lq3y7dzMPDWh1Kohenx4D1bAGl2cPq6pBN4b8wagtzsDELUYyKHll?=
 =?us-ascii?Q?e6RYALsYwBrfFLDYSoUEdl0o3ukGuZCNwXf2VXK5SnIoTP6O82ttm2BgH28z?=
 =?us-ascii?Q?eOWZAM9FXMO3peB1QqrZXN3VxkvEJyrLiaXOjRsChLLp09wRrBWhiPjSeKfL?=
 =?us-ascii?Q?j5mVT9PXi85LQ/VJp3eDmNqnPwRX9f2E/Z41Ka2VCTC6bJ905QeHKHF9UjSa?=
 =?us-ascii?Q?TzcJREKOStv77rbfzYzLG0AoRzFUaYKbdl+ThUkX?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f50c25e-3b88-4886-b8b7-08dca475724d
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2024 02:25:51.5024
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: smx0jySMXdh+ZjdEk6y6Pfj7W93w1BmvrWwsB7csoiyI9JTM7QBY9u+cMv155+tDaudyT+cXJ/5wmEO1xFaVxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6543
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Friday, July 12, 2024 8:11 AM
>=20
> Relying on position in the enum makes it subtly harder when doing merge
> resolutions or backporting as it is easy to grab a patch and not notice i=
t
> is a uAPI change with a differently ordered enum. This may become a bigge=
r
> problem in next cycles when iommu_hwpt_invalidate_data_type and other
> per-driver enums have patches flowing through different trees.
>=20
> So lets start including constants for all the uAPI enums to make this
> safer.
>=20
> No functional change.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
