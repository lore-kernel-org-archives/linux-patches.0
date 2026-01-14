Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4231937BE82;
	Wed, 14 Jan 2026 08:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768378514; cv=fail; b=aLeFEJVakZndKa4R/qfO6TWxbYne0dS7Mo3ZSV1Rq39ywNHPG3A70TB6eb4s5CGdlS/zHGhi7MOUsRxseu1MqvwvzfyXGoI4WrMmgkmexyAajfYbxe0D4E6V8upg2u+jBb/fIbw4lw6GIwxzkNot8zr+5GykGUeQ6lUD95o95fU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768378514; c=relaxed/simple;
	bh=ZiMT3RwZGN4L/S1G2TjprAmFNFYvhzIeBZHSswgcaUI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OBFRIHu6qALD2xYMZ21N8HXvSyaytVbHv0oaot/Tgtx1JfY0ZxE+bQOJWaq+elYKUUEkLKk1JmmBcTjVWG49VL9V4cuMcrKdLVX1QUMGCMBuJmTxY0KsYHkA3yptVhm+06c+bESjcOodJqHm0OX6bIqAc5JEUmverVN9jxZG9hY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=F12knB3G; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="F12knB3G"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768378511; x=1799914511;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZiMT3RwZGN4L/S1G2TjprAmFNFYvhzIeBZHSswgcaUI=;
  b=F12knB3G1FdOd1nUF0C9AuMUwQw9qcnrurzi+YIIyLSjhfM3m0qZrOp9
   tiHgP22FAxRdgsVaNj4jCad/DOsSd/zhggmjC9m2Ap7NC8OoMaOWw+8k0
   hs8eO7Qz4uS16XKUW6QJc695FxFKswfN3qAO1VGoeruYtFWEMHxFZMZxB
   FFmEXhqx0VbTwv+cWVD3bQ2uCpCp+Qe48r1NEF1ztlGQwejVKsoL+43Ld
   dnGrDx4toMVoueEJLvI4EzdW+SHWDGttCZmEpS4uBOcrqBVZRCXY6NSn0
   4BxKOcjtdt1Uq/mZmOHSi87OBcFQI81633w5u98ODbrQbq4Lh4Xvygqgk
   g==;
X-CSE-ConnectionGUID: kptAZzh9Qva1FTyvthk67g==
X-CSE-MsgGUID: ZCVjAHveSRuRsjMNfXtRHw==
X-IronPort-AV: E=McAfee;i="6800,10657,11670"; a="73512162"
X-IronPort-AV: E=Sophos;i="6.21,225,1763452800"; 
   d="scan'208";a="73512162"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 00:15:09 -0800
X-CSE-ConnectionGUID: i5T2jmFJR86uLikyxvlfbg==
X-CSE-MsgGUID: 7Y/jFovERwyte8x3OO5Qjg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,225,1763452800"; 
   d="scan'208";a="204625871"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 00:15:10 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 14 Jan 2026 00:15:08 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Wed, 14 Jan 2026 00:15:08 -0800
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.49) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 14 Jan 2026 00:15:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I0oeTTD8V8SMfkFmXXInwJxAmgPmoQTuJbiHzDvfoKFFm/9sAF/OG5sv4jTem7I5WxGf446PeWXfp5FZNeyY7pGIZsNmWSgLQv/3l0tVC0VtHuT4P/imSqPPcDfrSBrarZZckG7ep7Yak4nrjt9JDZiAHgiXFqpTgnd+EQTT0Blrz0VEfnbTjYdqf8KHtC3rWczihALrVFSJwB8PQux5F+Qffasig89OjPVRjA3eZK0PJR5wVL5CZmTTZZff7rjC1x9FGK4aWLVklgUxQQDLMUeP1kQ6S+2icup8GxVRC9h9uH/KLStBmC15UDgvdhfVjfca9M7aaylUL2RdLfsGjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nrpo95zw8ZXiExiNlWCHbS8jH1vPoe0JgvvBR8X0yCA=;
 b=qH4KEIQTCAvs775OvKILhBbPiUokxuWqdEu8XcEFS2C9tLrkLA3R4ylS36KNu67TTWaB8KZgMTbvCVpZ7WGup5Qt+5mUdZSTWVgtnuc658g6kDR2oNedlic7BufZGZrrz0PTrow6x+Z2JOo2+nPXYx8IruOHRtvLQfdAylEoqw+9Z7m9I3E6FAkE76tJl7qKesZ7tlgsDvmYjk5MfXiOYo2fd1DTWMBCj7/a44RuRPkmxZI/27VddBig8hbeXSPyhciaw7sMApzKAr+vHPuC4zUuvnHEFFi2RsRM67O8b4Dtdfk6BfeZHHpkEJG2snKswvi5BzAPPT10jk3Dfly4Pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DS0PR11MB6518.namprd11.prod.outlook.com (2603:10b6:8:d2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Wed, 14 Jan
 2026 08:15:06 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::f997:762f:f079:134f]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::f997:762f:f079:134f%5]) with mapi id 15.20.9520.003; Wed, 14 Jan 2026
 08:15:06 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>, Robin Murphy
	<robin.murphy@arm.com>, Will Deacon <will@kernel.org>
CC: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, Joerg Roedel
	<joerg.roedel@amd.com>, lkp <lkp@intel.com>, Pasha Tatashin
	<pasha.tatashin@soleen.com>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>, Samiullah Khawaja <skhawaja@google.com>
Subject: RE: [PATCH 1/3] iommupt: Make pt_feature() always_inline
Thread-Topic: [PATCH 1/3] iommupt: Make pt_feature() always_inline
Thread-Index: AQHcg9KmlSpK7PTMgUCAQVcRN7tZxLVRU9HQ
Date: Wed, 14 Jan 2026 08:15:06 +0000
Message-ID: <BN9PR11MB527676773B6BAC34527409518C8FA@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-d7be57da596d+3f8c0-iommpt_map_direct_jgg@nvidia.com>
 <1-v1-d7be57da596d+3f8c0-iommpt_map_direct_jgg@nvidia.com>
In-Reply-To: <1-v1-d7be57da596d+3f8c0-iommpt_map_direct_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DS0PR11MB6518:EE_
x-ms-office365-filtering-correlation-id: f7d3aaa4-0d32-4d8e-7e58-08de534506fe
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?lW7VSLWw+eeewpOPq60MKa5Psxsq9NSsCsGnXLBleTr3IB2QQrRLBiRUUuBs?=
 =?us-ascii?Q?kPQI9WhMS4U5H1WEjsoEYoHtX842MAnlBEW3rk0lpeCYMdtDJf32d2zMaUAr?=
 =?us-ascii?Q?LtVXa9zgXngJLubnk/Hhh7GITeSFS4k6JvfR8VsPjiBInnXtU0odNCp+N3Sf?=
 =?us-ascii?Q?gG+cnHLm/euyd55xeRcsMeXab6kTT93Ojr/kjd46nfN0zVgY4V0vv6vh3Cbr?=
 =?us-ascii?Q?R2ZQl8PXEsVhKLZpauJW8ac80ULesZNftmEkfbypVEH6FZOllOhDZ3V3xWnl?=
 =?us-ascii?Q?49aXKMqFJdm5zfWEF1OUJX7aTMpKUvv+laZjXVoAQgi9YC+VLwhXYMPV3rkN?=
 =?us-ascii?Q?UZ6QhZG3/fvA5Zc7ccxePL2S9KpkxSyhPUKbHS7bMokqTS10R9nuuB8G5Fr4?=
 =?us-ascii?Q?vx9higS+2xrRPM57L3ZZ6nNfLbp0bbj9BFGPjKdaUJCMHoKKczorGkErONn6?=
 =?us-ascii?Q?48xCCiUNQG36w4Aviw9TpcjCUrVgNWU3I8DxlpRvCf8MvoxlGK3odiQ6OhzR?=
 =?us-ascii?Q?8tUJ2hyXSyLm2162rLeouznNoZHr37bDV2ZOk9YSeDn35rN0upAwxleEJJOY?=
 =?us-ascii?Q?1QELUoRgHBU2glTcziILMAIddhMToqTP+2NuLTVTgTo6T4gJ2urP4FY3i8TS?=
 =?us-ascii?Q?mVHD0FCNhmZifazgZ01Y7S8B+rrj4vYmjXP8FnafasLYVoc1IrrMIzvj+CfA?=
 =?us-ascii?Q?8/sQzTKpdMGYmSDcmhawhuUevEpaSgAIDwnvlz1amfsU7on7aJDwrpiEiMSO?=
 =?us-ascii?Q?5eFRKjQxCVpBpOyR99tKSh24So5zxsKVEx6oKLdsWXzE7jMDigsuFFy42jv6?=
 =?us-ascii?Q?ij450Z/rmmKg3v/KDTLBh77Ej+W6k85WefTInwEVnV/9tikNMYBUTdeRJTBQ?=
 =?us-ascii?Q?k/x2eK/tQ1EG9YU0GHZqvFFnpjyGwniM5tta8FgNqOkfvnjFGYWobpYpLP8G?=
 =?us-ascii?Q?lHjtZN3MTD8oQibc8hZguLKZ3ghSOjyVdHecaUDZPYxFRySQg5SG2p1I50ph?=
 =?us-ascii?Q?PD9c0CjLxqzgE1SXZugCsa8Z/EO03vAGn2nwc2cEQzLME4K7gsSfoW0yqdNf?=
 =?us-ascii?Q?iViiopwUmXp9NRSf+tNwDjn7844DR++XgEmiqj5pFDlGa4RjeCCEBd7ZhpoV?=
 =?us-ascii?Q?qC8KEIKnd8+SBhp0tZ1X9xg2qdH1FVXH71VfWi1aV//2O95im4CWSeQMgT3z?=
 =?us-ascii?Q?EfVeuagjk5Ju1O0cNPCz8YxDhnqPVDeYk34BLMjocow10onl+dP8+iQyOqet?=
 =?us-ascii?Q?xRYv3NNIQoC2qPwXk6qyJ1/Pn2Uqrqi7zoNDazfwiaE9074M4W83ec/qDkx4?=
 =?us-ascii?Q?qAF7ipUmPrBx7V5LKM0EIr8XzNMRlOVEG3y5rHcToeP9C2sLCV3bDk9/tkIz?=
 =?us-ascii?Q?sI/hujSHuUmR3BC43D7VUN7lQOLmQTa+AFARTW/md0C5Zw77TsJykEteg4Kv?=
 =?us-ascii?Q?BBEeWWLcdfIKHsRxAKyjNj5jhViCtauHT1wGa/uqMUNnUL4bGlvYqLOYuu4r?=
 =?us-ascii?Q?xcID+83WWMkAojR11SXDO3yOfUdElRfJWvNP?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?yxDvhDALprzdOhiUMuuDF/t69kuSVgv6wWadViUsVQcVsnqUQ6tmnr9FirHE?=
 =?us-ascii?Q?ayGUYEbyu1P9GbhwFQwTgSVbbC4wVcq2OaZrlgb1UW+QBuGEIDE5ZMbK63T9?=
 =?us-ascii?Q?+MyzEHwglnKOeG0y7GLr8FIhYhunLXPTvaF9DvehvQd1S7uZ8rNZYCeOh1LE?=
 =?us-ascii?Q?1p3YhfrgASOA85fikh4U5l8RpMzDsgDYIgh3ny/UksDMmtAnKpLdfem9MfYx?=
 =?us-ascii?Q?wOchyEI2lvXWuiJ6xocx37CTTgng11nE5Fe09XEZ5l3RA7A6z1cHi2/+nTFw?=
 =?us-ascii?Q?RCQoqNbtezQ3n2nwnVlJUzlYSPbBxvVzlJhRKdNrG8swnnDBlAzzx/kUpyfJ?=
 =?us-ascii?Q?xI9MfR6C/tLSv46nDJVj9z820MRxwSFGeZWr2IScepEITULf3C86NOxz/x4m?=
 =?us-ascii?Q?grHJKhVNagGt3s0iVPcye7Cg7mHb9n2yPnqQ909oH487lCMbF/7mDbAZ+gLv?=
 =?us-ascii?Q?TfTyWCmkuiWt2Hx8j//TRdsHurmrBSeSnKvGukJIXP96nR0qLTvjZnZNZCLD?=
 =?us-ascii?Q?Xx2Q585wBjAxOknhA6ZZlF8gkPEGT4PlsS1wZc07ov2FNwuVk0ikt5npKSFy?=
 =?us-ascii?Q?WIO8OxyLYUiuqHAjbePcN9Fc0lqNc3grkaWWrLvq79f3klEOi+OtTgu4OCeI?=
 =?us-ascii?Q?oTl1ISz4pMT/USNLw98OoXN9tiHrMhpw0l6lOMevWFlydXkZ4kYXfW7NCS5h?=
 =?us-ascii?Q?BFFneqj1u0XQI287SnB2stEa1xTVvg0fIf9F/VwTv3uJt5dtH8xTgBc3LwnD?=
 =?us-ascii?Q?lSjTNi77BPoyf/1HeaNLDxmg4iyaPMZ0rT55lNSl8I8Q7U/arN/RbPklrxTT?=
 =?us-ascii?Q?npy8JV1qXTgLhmDxOZWJe3F7l9/FjULAUOklaauaZZbpq9yjYkLWf2odA0DA?=
 =?us-ascii?Q?OQjmigg1/vUKuhenQgDtSoJ5igJRXbOV/8KLybJkqw0SKPRh3yOXFPmrHJ8j?=
 =?us-ascii?Q?1fwCcPk+jz1VwP+ILljX1EDXn/Nq27ZK2cx3OD3ESn6U6blUfDKrI4Dkgnsm?=
 =?us-ascii?Q?dMmtJBsvZdSFLG6XSrK1jMW5RZsbjMdAgeDMHxv5yfK0ezogK/VKrjKgW7cT?=
 =?us-ascii?Q?ISlUdRrQ8JJI50f9+JWb3i/C6FXOlhw4omJENWFd0bLJAqR6oW5ZKYftWmxa?=
 =?us-ascii?Q?ljxkdcf23vTZyGoZOrzS7fgI6PqN4UKhWWhYd0nDOM081ISwNs8SIdXGC0Rt?=
 =?us-ascii?Q?9opbCoqeL/MhykqxtuEX8aab9hW+19LmBJI2UHVHjorYaelDprTS5YqWLc+u?=
 =?us-ascii?Q?xeogclYkW6yE9yt4TxQrrV8g+Ff1rufDN9A8D78Ln1/y9FJW1bLp6NMC3QyU?=
 =?us-ascii?Q?/rjWtleJl19GpvogSpkK8LdGmFP/tQJHiUn9eHc4/cRns3Tk8BD/iIi4oED3?=
 =?us-ascii?Q?SM9p5k392aSVjSBR9g2+mCTVNJU5gPOzRpZF52abQu36ttScM2A77xr3m3Ho?=
 =?us-ascii?Q?NYdFkCHdfHbl4i7j3mIcTn1O41YbiPmS9c1uBJD7mLWIch5RmEy2ML3T1BEu?=
 =?us-ascii?Q?6jOgRkwyv+TihmODjT3lDjkrni4TGkBL3nSzPOsvjGwgT58C71uDhoZR50ap?=
 =?us-ascii?Q?koPGK+9zoh/EehbS4I1zwj2jUr2++AOINjuZqxT6V/h3JZzT5io6FBy0NlCW?=
 =?us-ascii?Q?xwOIHBqxcazzZ/CIZDxjEkTTtvGxneO0JawYoxAzEKbtjtAhGY7BmTi/gOjc?=
 =?us-ascii?Q?qfZ/szsNkiNCQwvO5YziD4PZ4pJ36Li1zHQ7cdZjfHrjwBF0J4QDNPiuOQrR?=
 =?us-ascii?Q?lVyVJAB89Q=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: f7d3aaa4-0d32-4d8e-7e58-08de534506fe
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2026 08:15:06.7298
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: e7G74fHYV8z13NljQGPDLR/MK+jyIxLI7JwPf+PAcDxn15KGIqBk4v4DFf6mgELB0Ay7nozfDz2n3ca9Ntgp2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6518
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Monday, January 12, 2026 10:49 PM
>=20
> gcc 8.5 on powerpc does not automatically inline these functions even
> though they evaluate to constants in key cases. Since the constant
> propagation is essential for some code elimination and built-time checks
> this causes a build failure:
>=20
>  ERROR: modpost: "__pt_no_sw_bit"
> [drivers/iommu/generic_pt/fmt/iommu_amdv1.ko] undefined!
>=20
> Caused by this:
>=20
> 	if (pts_feature(&pts, PT_FEAT_DMA_INCOHERENT) &&
> 	    !pt_test_sw_bit_acquire(&pts,
> 				    SW_BIT_CACHE_FLUSH_DONE))
> 		flush_writes_item(&pts);
>=20
> Where pts_feature() evaluates to a constant false. Mark them as
> __always_inline to force it to evaluate to a constant and trigger the cod=
e
> elimination.
>=20
> Fixes: 7c5b184db714 ("genpt: Generic Page Table base API")
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202512230720.9y9DtWIo-
> lkp@intel.com/
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

this was already sent separately and queued by Joerg.
