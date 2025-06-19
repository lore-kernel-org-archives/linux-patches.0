Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60436242935;
	Thu, 19 Jun 2025 05:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750311705; cv=fail; b=RHn5HzFrOHAqDPEn80pd8i/R71Nzciq0jIczzOAutojHVq5Zk9CpwNhceKeZ0N1EYj/9KInUKqRTQnk+jBnYtG3htUpgWgR8jsUXDAVtslKNmqjC9hBlO4L1NTFVPMH5wrCBtKPJWzHd8nDGwclQfiqEz9sKo58eEXsGPSQkZ34=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750311705; c=relaxed/simple;
	bh=BHlr7LRRN9DYrjyDb3TU6J/seWACblsMO/aGao9db3E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=H2rRBFC4sKLq9cMVjRlp+zXSBuf1sGbeVCvijM45lKT37zc8I0JveZpxQ1pCuJFbUA7XF6WuJPb5br9BeOdN5WiDevf9BvxJ8HHhd+VwP0PnZ5XN6OkKpug1cKFtTrjiXLn4T+Ac0+ImhNPHHsL4p0kBZIuR3r0glpzLp3peQCE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HBq5J3Rd; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HBq5J3Rd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750311703; x=1781847703;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=BHlr7LRRN9DYrjyDb3TU6J/seWACblsMO/aGao9db3E=;
  b=HBq5J3RduTSvsUGERgWANE2Xg90cBdweF53TdV0OB9WkxUiamG7moGfx
   M3XCjJH0RfEHlYX9E5HUETbU8nzhyWnUXhe01qCPk9of7XbUYuqnGFxHO
   GScVkkuLfcWnTu1v6S2Z8182i8DNmdJLMp9x3yvytvAZoD5H8QJJH/4F5
   Nz8H4MfYnSwvxLtOTEVNbM4jMWi/+vaBZS6o4W49LbMlFGg5o4qsqjBo1
   EstdVvE1AVcZAOrFB2E4mKZaDpmZFds7S3NFac8h12FNZKHWK8BDgnpes
   cP/tQnb73WVZGjBWUhC1ouf1R8nZaWnTwmw+2NMX3U/I3zF8XvVuXZXUm
   Q==;
X-CSE-ConnectionGUID: PuZ6SlAkS++kYOISHFyYIg==
X-CSE-MsgGUID: 9IBVSNU/Rpa8Pz95ChdmvA==
X-IronPort-AV: E=McAfee;i="6800,10657,11468"; a="63983431"
X-IronPort-AV: E=Sophos;i="6.16,247,1744095600"; 
   d="scan'208";a="63983431"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 22:41:31 -0700
X-CSE-ConnectionGUID: evHKHUSTSQuqUX6M62h1UQ==
X-CSE-MsgGUID: bssRBDvhRdirWUbkfLKn0Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,247,1744095600"; 
   d="scan'208";a="149991641"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 22:41:29 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 18 Jun 2025 22:41:22 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 18 Jun 2025 22:41:22 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.75) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 18 Jun 2025 22:41:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VdUy0+gL5F+SRDGq57zjkfI89sxyKKkLBg9aL/GH0BQVnnwrzGSnY26yLIOUGVH2MI2hBUAavaoM98kVX/AtCMO7Ut6TWOxW13ZZZhL1SuxY+8ezyX35cafjCidz9QDkS3VhZIunBO42c6cbDdcYGh/brY//vrJFztwgQs64xogUAkI3yPywXx2DI1TlqBpXmq/dax9D4rXPI+cm96WkaF6o7VgQ0g4zBHOyu5QkpAZAiJPhtGD8AafoEG6JSaW7JqnJsXCykYEf8q9ZGkYI4v4rlNBktxEzgy4aSm0oY4y5dmniN5ZKZ1abUH0IwqXzqkCfpXDT/6ijsTM2DAewLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BHlr7LRRN9DYrjyDb3TU6J/seWACblsMO/aGao9db3E=;
 b=mssTaKjsGJqM7XBZ4C1IyvM0pCwmDJzMxFqyz3ofmI28+LVUcg855lp+7hETnk0F+6dnnQgnyhdVnoDJqIqSxy9D1XygoVUMCcOg2MwTB9T6R6v0HyvjXuyBXiig0ZMRcAXZfKkZAoqTL/xh+I5hIwlP44MeR/MHTgsZZ2Kjm6Kh8cuzHIBLBG0I+tEJGs75ptUECC7msNU82ND6nqYTvxRtCgTIioTDtTmy+qFpaJNfF00+1QQhyCslk++ixgQwuXjrOuuewT5kApGpDOJqEBFEjiH7LqSHHJE4YMuTz7wl3yLcUmqb6mhKHJDBTJJ+FZETMipubirVwoCASUu/oQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SA1PR11MB5777.namprd11.prod.outlook.com (2603:10b6:806:23d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.21; Thu, 19 Jun
 2025 05:40:46 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%4]) with mapi id 15.20.8857.016; Thu, 19 Jun 2025
 05:40:46 +0000
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
Subject: RE: [PATCH v2 05/14] iommufd: Return EOPNOTSUPP for failures due to
 driver bugs
Thread-Topic: [PATCH v2 05/14] iommufd: Return EOPNOTSUPP for failures due to
 driver bugs
Thread-Index: AQHb3ParbwFhi/sThE2rdztwlzynaLQJ/2jg
Date: Thu, 19 Jun 2025 05:40:46 +0000
Message-ID: <BN9PR11MB52760A799339ED74D09DD54D8C7DA@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <cover.1749882255.git.nicolinc@nvidia.com>
 <623bb6f0e8fdd7b9c5745a2f99f280163f9f1f5a.1749882255.git.nicolinc@nvidia.com>
In-Reply-To: <623bb6f0e8fdd7b9c5745a2f99f280163f9f1f5a.1749882255.git.nicolinc@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SA1PR11MB5777:EE_
x-ms-office365-filtering-correlation-id: 70b17aab-12cc-438b-1c83-08ddaef3d6d9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?WiLf67U/2d6+fkm8V8LlITkohiE20JPN2jyI5zCZWXyFYhyueBvcIS/Bivsz?=
 =?us-ascii?Q?pMrIKNs9SoknFhku4Oz2jseTNCVCfILvieqVNikAQFPNIAhHaFNIR0asJC7k?=
 =?us-ascii?Q?419AiX5cxmEIkQFZ93eDmVEM2Bt4x5pUYM9q588YRsqYZYYpocaaxKS2B3T+?=
 =?us-ascii?Q?SOSqT9ja8hXGHL/bT8XF4Xpi8QcEJvALdv6LwjjLgxjs44C2VA58/WlRDoc1?=
 =?us-ascii?Q?+iC7NV5mQFpDjs9E0D1Z3nFweVXRyHllU0ZdlEMoKBNQqeEbvU6gDY7QnILj?=
 =?us-ascii?Q?+ee7wIZiwMkWtyAkzrWZDiP9gYRftK+ZBhEgqPhRX5T+oM67QTqa1i7sjq63?=
 =?us-ascii?Q?8PfVcDOggbk60diLRd/SYNB3grpNzeuy3IZatF3CeMg1/PiVHLJy68lXdQ2N?=
 =?us-ascii?Q?6ipijlsZ/f4E9pw/R1JhJhlZhVVf9ZKo5sNs5rfxu0/n0zYVyo+YdjW8Q9Id?=
 =?us-ascii?Q?CSr7mI/8CNdYBzzF4ULQXOB3UYvLWYR3A0htJMn7sqIMcQWTreYZNQEfOEi+?=
 =?us-ascii?Q?C1ZhZX1K0Xlpd73D0zgKC5CJpeZNq1B9LpOg70pW+TFYzie0Z/3pJ7kjjCx1?=
 =?us-ascii?Q?kSCc36SWlXo7URJ8NRmfSeXg3ZnfrgSSfMMh0u5MyjhZ1/1RoCIcv4+zUBHv?=
 =?us-ascii?Q?04PrWACRi2Yb1xwqy28GKopTvjP/XYTKsT1GaMpz1hJaI4wUmpn4J3K5Lrcz?=
 =?us-ascii?Q?1x2u1r8xIuzfJAKWh7d6BFf8BQuQQ22CyT3C+igFMpVs6U7RwDzkvoNNCDOl?=
 =?us-ascii?Q?+6hDVoLFboNNkaGn+xKf10zsMOJHDr0F0NCe0xj1sKMIWoVsqDakT8Tsj0/P?=
 =?us-ascii?Q?XuwhUB3LorNVAWXxAnQHqoOL2/tel0qi68u/lLLeXDUEkQMWIhkdHrqVfY9W?=
 =?us-ascii?Q?4qGwEkgKJGn+j6rrHUrmmEn4IiKfsv0b+IFhI1Pl1Isu4u58hlbkq7VRTiz8?=
 =?us-ascii?Q?tSxG7sRgJCUvK1cb+z48NiIEUpvJ9ljtOdqhIButEZyIcRcFR0GjCI8FZA5u?=
 =?us-ascii?Q?dy866W3DkIbDJoyMFX1MuKbBSmaH7DYqhEwOTadndKHWrLU6Ow9KbG1lMC7Z?=
 =?us-ascii?Q?cfey4qWEaTUIoXfHyOL/fPjuSHkCsVodrQCludK9Trs8mrN+G9NDliI6oycI?=
 =?us-ascii?Q?efdky2UWA9a2BuOGFhfHcCtUNbavTPRbXcqnrpj0D4M5mxB6dZoCSzZjzYgS?=
 =?us-ascii?Q?ZFxtz7K2YQT+/Hwcq8FwuS+OOuV8caEi7k2G2zLHoJuJSjFtrVGKbo2yrsCu?=
 =?us-ascii?Q?vcI398O992+401PwfL3xNMN6GcH4ur9Sz4Mwe7jtKH8OXWpYBCbLIUatHVVU?=
 =?us-ascii?Q?lalaMOYsSvFzf+HLNmFmHFw84cLRa3UH3ShDbKT1aNrbVzpK76zno/6B/8ok?=
 =?us-ascii?Q?b3H+4kkZxr9zPOjSbMDOVVQ+GsJI7VVqemQOT8D+FjXoYtclpGkYoewHWaMa?=
 =?us-ascii?Q?VuQOrAlfaPFKpd3FV9DZmgIcfdwoMNqnjVYwyzZIr7saXWeLHL0hfzhErjxH?=
 =?us-ascii?Q?WLxG77TBF7DcnxY=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?YX3BnGas/TZSJs6CLOj9KRA1rO0+pGeimAbwaSFIxwrDgP0+gCsjZ5az7TTi?=
 =?us-ascii?Q?p50wxcXyGZ/S18sZ/SDvNcHX9eKTcqV8MvLc16rwVe3TLXwNyiMzt19+DaQu?=
 =?us-ascii?Q?Yxs7oyLeHhrjWisZFyFxYyDOWPF4LtJMzUggIf18C1otcKGuUscFiMJyKFZL?=
 =?us-ascii?Q?L6D9Gp147fN1EKni3bw6IxU5B+4EMdn3gaGzqdzrLhcntnyAVe0TMAbgr65H?=
 =?us-ascii?Q?UYoPwHzOcaboNM7PdKK+zbF4tBaIElNIub8TZuvQcEklvuQaH8i5BIlUBG5P?=
 =?us-ascii?Q?ZMnvMu7Wa5DbXRKd4QPigdnbhhrh2TAD8dECUifOcH3x6pqP8/GgTHIOnbTa?=
 =?us-ascii?Q?u/DvwEfWc+lb3Ef7cWT9ml9umpjS1iMZcCT3RBvPISjOnl0Qe2Cb6HyPA37R?=
 =?us-ascii?Q?hmZNyG5d5UZ2r7f1FFZ/crpgpgoySqMDYsC15YcMy0PfbN0FeOJAMhxz4ePC?=
 =?us-ascii?Q?wvsLikZNAJlTC9Ew7NwFdKlbueFA3W1QkyIiYQXFyEYIi//i1UCnrtY+AcUH?=
 =?us-ascii?Q?DAkuZOfgRL5ZyyePetj1sCAxA4fNiTEeCuO3DW0zNAJVid23gQaSlU8Z0Vcj?=
 =?us-ascii?Q?7QC/O8+YJ2QNUTCtu0gF5pcvign8+bSjyfVQTDOl4GLRrsX3QiP69kAs+5pf?=
 =?us-ascii?Q?FKwbYXQgm7aYbMkHM1Xk4yFo1iqs9yHnVm4DeX7GzQMz6C4QL/6K3DILfGY7?=
 =?us-ascii?Q?F+dyT/G4YTjAYbPWIPj/o2hWlCdzrlImVD2oQRKJ7tTT42IfLYJKTCimcj24?=
 =?us-ascii?Q?mWryyY++/EgBqS1pAcCUE4/hE9UM5ZGsnIYD+2KeiV8HOEerd2ieqxZGyOSc?=
 =?us-ascii?Q?+mtZbOoyw6PCaDdfL9lJE/8ksacD88uE1Y+dzAFsIcHOGC3bN/b5ebz+Sjh8?=
 =?us-ascii?Q?tg5nR0hx1oDx4AOC8Fs4IAuobvS3MKNoiquNtLcc3Y5VQFOrN3m8XcHyO25u?=
 =?us-ascii?Q?0CZ1jgWEHOOMw5SsoSPJYjsfW5FtiOPjxWZPERsp2+hzZtK4wUZRyRbV5LVe?=
 =?us-ascii?Q?s6tZQnw1NmBUFg3g6vwNeFJA9DFhMSLbfaaYsynKW2Ji+9nYbQNXHha4aXYF?=
 =?us-ascii?Q?xZyCUQBuY8rqGc1XR/Y1vt2fsCTiWLjImG1slQv6Wua8O0q3HRsr4pLR149N?=
 =?us-ascii?Q?G5bykI51+x/CjJVZ+d7thHI1ACc/qpTWAYSYOwaAfbN7JE1bnG13U8mfDsdo?=
 =?us-ascii?Q?yTu2i9QPmAHZqiM/PrYqsWj2JyqjmO3E5HIfWmz/F1ywltbN4u5/ocY7SH5k?=
 =?us-ascii?Q?3NXuHDlfCfjK/Mq96qzLDy2xyzBBzfy8B0ZqloWMfTibowaurR2pvFldM5xz?=
 =?us-ascii?Q?cucU9/jXMF3cuHQG/svzV9g4QNZrL3ft5t85si1ifd9jpakepfZ3FrvQX0FP?=
 =?us-ascii?Q?udqt2pbeDmLUcE8j+LA4K8v7e5txhs6Ag6KdJYrEU8pHbxNlyZYpXhykc4Yw?=
 =?us-ascii?Q?qjoEt+G6MnShK6s8ouJq6MHbFtSShiiaHX5xk1F9rP5zBASt2QUduAiWk4cI?=
 =?us-ascii?Q?YXh+Yd6B5JO/OWCP8XeXE6T73SmfWk/rAcY/j37Eyb9oTH+I+g3ju8L3CFoN?=
 =?us-ascii?Q?GVscGd9WMb0EWZa4URF4dEbFCK29K+2j/mDO9vGy?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 70b17aab-12cc-438b-1c83-08ddaef3d6d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2025 05:40:46.1197
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XYZFEWTDLIaNgKSrZtMSED+Nv3unUol9ASLHUTW/S9lPZ+8KqpSMAsmweOaNHZdtbP8/dN0eqnmVWil9IpCyaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB5777
X-OriginatorOrg: intel.com

> From: Nicolin Chen <nicolinc@nvidia.com>
> Sent: Saturday, June 14, 2025 2:35 PM
>=20
> It's more accurate to report EOPNOTSUPP when an ioctl failed due to drive=
r
> bug, since there is nothing wrong with the user space side.
>=20
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
