Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9626A30EF70;
	Tue, 14 Oct 2025 07:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760428511; cv=fail; b=WYrDl2KSD30PtNZ7qxr3A9Ma+yZvXG/KeSWE9MLmrG1JbaQg6J5kKQd+DSVDwl8IOf8QX6gAUHE9gyyKSgFBLveVd2680KrGBRO0+k9aaygTC1FDt9wddIfpIzBOvFuaBQ6h10mWZtKCoZZiu5tC/tuf4UmXwx6oWRTrvTiEoOQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760428511; c=relaxed/simple;
	bh=En6GjsR31nI5cu3xzkORFg2wIocGEW07oD46A7FZZDE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kpnwku5w0U4HqQm6Ae/5rsu7kvFz5LGT5UynqO8hJkf45mtq/ZqVBtrFpXMyHhKAYi4iC2KpYAKeru3qYQaxodNIxiClq2ka6C1qhdrvK9qtql6iMPzSv/tVzF4meI4I3x/CSA/ZG+CabMVH584bOS5HBvEbVhvbX0VsOyQ6/4c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QWLwr0F7; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QWLwr0F7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760428510; x=1791964510;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=En6GjsR31nI5cu3xzkORFg2wIocGEW07oD46A7FZZDE=;
  b=QWLwr0F7TkUW0dPkMfGPGsVVDzaHcAlvXEUV6bTl/Oh2lDRu50YuEGrz
   HsOuxpsZhkGWApKN2/H7br6gFLxkEwiCkOPs3ZMi52abginmy3IKz1V0i
   1zGuB/UN3cjWKtDeYGEiR3/3BGTsKXxRGgiW2pRwB/sNsLGW8qQex3TyI
   Mb6PiI28BTVxHqlkR2FeptUDaHdc1c9pD9W86e7cgRa6MZTYKlrQIBhfe
   xPVsvskXRngsxy3u1qJHAZ6gcfhJA6IphtEabHmG5r9ySydiXpTAi5Vxf
   q+4EXwixpldH8EdNdjCdQkaMFqeZOuqn0V7mIWePfPlFW+jMEyvRrMMFc
   Q==;
X-CSE-ConnectionGUID: y+HyYDLcSbKb6IxvTyktPw==
X-CSE-MsgGUID: WNZoq1IaRFWirKWqa18rXw==
X-IronPort-AV: E=McAfee;i="6800,10657,11581"; a="62620380"
X-IronPort-AV: E=Sophos;i="6.19,227,1754982000"; 
   d="scan'208";a="62620380"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 00:55:07 -0700
X-CSE-ConnectionGUID: b92mBsnKTXC57KVg52TETw==
X-CSE-MsgGUID: oUXWErhbQWm9uOHYh8B0jQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,227,1754982000"; 
   d="scan'208";a="186068480"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 00:55:07 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 14 Oct 2025 00:55:06 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 14 Oct 2025 00:55:06 -0700
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.20)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 14 Oct 2025 00:55:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GUn3LrYHJbmpy3D3/b6NtGsysHAPeFzSmZaQ0eqMs8d9060u5y98mbFseoPkrQ9xO48fj6z/hoXw7JadAyWD6FvnEn0YdZZil0TXY6HSRxUxIas4iUay9cuIekhS/JHfKfuyZTdkdwD1/tlVSzBnyVYqEC0gP8axTlp05HAFKE0wOHXMPN0JpJdM/h0xncvWI/kZ6nWDyl2xM4Is1dE7z2BJBjJ8Y9ur+5EPR2p6Bz9nawi0j/L9evBQRMv9IhPMWXBpI8i5BeFcyvvJlqf9MIt5JbzRr8tXxv8nUsAlMztW/IeiDDF6ZhY5uveFq7u/wU5lN6iIQnYwys5yJL2pMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=En6GjsR31nI5cu3xzkORFg2wIocGEW07oD46A7FZZDE=;
 b=E6bx8A3eJDPPE+AoKKUXty7Z+LKMecHtKGEnf62T968tgFSjjHxZ5xx3/idZgHvCt97Yv2ECnBr2T+IAxAw3+orrHfv7nN563orRb8M+Pscw8YPzbFkuNplMJcPhL219AEbxpQizd/RMWNTbHBwVIL4JnrtCNwZZq0mM8PJjLkdQZtrDkHeWLdMMd7uVSo4HgSPMFm9HpETHmww68ErjMRP7Vx5hwOAefUilyTLPU/MNwK740rA+CZmGPLz523/NCjWxPBDuAMm46Lv9Thl7gdFE8kd8dFu+Ejk7O9sYPglEWvDjKtGijG8hp+s8niG0Q+ugO+fieIwrz41hUK4wXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5271.namprd11.prod.outlook.com (2603:10b6:208:31a::21)
 by DS4PPF8ECAFAD61.namprd11.prod.outlook.com (2603:10b6:f:fc02::3a) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Tue, 14 Oct
 2025 07:55:04 +0000
Received: from BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::5616:a124:479a:5f2a]) by BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::5616:a124:479a:5f2a%6]) with mapi id 15.20.9228.009; Tue, 14 Oct 2025
 07:55:04 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>, Robin Murphy
	<robin.murphy@arm.com>, Will Deacon <will@kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>, Tina Zhang
	<tina.zhang@intel.com>, Wei Wang <wei.w.wang@intel.com>
Subject: RE: [PATCH v2 06/10] iommupt/x86: Set the dirty bit only for writable
 PTEs
Thread-Topic: [PATCH v2 06/10] iommupt/x86: Set the dirty bit only for
 writable PTEs
Thread-Index: AQHcFq6djU2AVuU7oEeRHppd3X9UYLTBkkng
Date: Tue, 14 Oct 2025 07:55:04 +0000
Message-ID: <BL1PR11MB5271781EE9D291316B498CC78CEBA@BL1PR11MB5271.namprd11.prod.outlook.com>
References: <0-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
 <6-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
In-Reply-To: <6-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5271:EE_|DS4PPF8ECAFAD61:EE_
x-ms-office365-filtering-correlation-id: 6d02508a-1926-4571-ab31-08de0af6fc42
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?hPYEHHJNMovNwRSdT7jv/0AcRwVIxJOhW61zmxca/ccckbnVnYj9bA9bs+pF?=
 =?us-ascii?Q?DFzopbb7U/DSsRXVxp1FUxNRrLwU9d5opXwnwwbXRZ/y09no+vOjpVzhSIjv?=
 =?us-ascii?Q?Dpw7vDNxlgC08pNCPoAMB/BE5ftipfwpdnYZgJP82I2TgZVsW16DSIcUK+fC?=
 =?us-ascii?Q?TOXjuM+KuxuQlnAie5isrxw+CjhzBLQaBDWDGwxyt3/Bq1e05prInfbCWFZ4?=
 =?us-ascii?Q?X8IJeitJhzoyuDA71cO9S7au8zuAt76fx+7kmWCKqNLF57ZXrBChFVbMIsA+?=
 =?us-ascii?Q?V8QQ3UejeoZuBHDjMQlYoQYWOfIAyE3NPjUmgCBEx6aSEwiobGpaIjXWBm2z?=
 =?us-ascii?Q?knGOOsOsetzy0V5jJkpicrUzfHAwoEwYXHOr7Q5DBesSO0JrBq8Q7gPEtHFK?=
 =?us-ascii?Q?0+4ah/zyYEaIzKabrI6bmEiEso59n4CKqAML/+ocV/ydACbVkH52cIsPEA/w?=
 =?us-ascii?Q?8laS2wjti5jb/a3Nn2odiqXNrN+uTaWicr4fKk9baqBJ6uRpDI6vJk8fUkxN?=
 =?us-ascii?Q?ApuhwnUbly+R/y0j5wiY0fTkY8CVV7M6pW+pQi/NaBlFFL3fkV1FoPWswQM3?=
 =?us-ascii?Q?9chKrhXAQ2g/x9MNI9wkOk02+ISHmgthD4SsqunvaVhI7g6t5015e7nBkIZ+?=
 =?us-ascii?Q?w+POlRpYRuuYtz6ltb/eTmDxH2WVvEy3qjm0K3qw8LBGjVwjwAgP2wcipxWa?=
 =?us-ascii?Q?YTTVpyVZPBpQi8BsMrgCFmifSe3LX7oZ3TK2/mQEw9k7d39OpRBqQUgv6uVl?=
 =?us-ascii?Q?3L7fZY6jy0IXjGCCoVloQ997lmrHerlP0IesyztjpENG9azyU2Ez031aP9W/?=
 =?us-ascii?Q?V9YHs+f17A8oqW8Ok2CUE5DOyK2IiEHO8QLYJdqVob1/4mW/ymjL6s8GNhGa?=
 =?us-ascii?Q?t9fLwKJ1/zzq3LXTiGD7pKJFbAXzp6wBgMY649QbAydxCsFefkQ5fbi4nh03?=
 =?us-ascii?Q?Lt1pv3tc6BjpbNic/cvjzHbU4T/RFgkMDXFm63eWYeIVlgOgEp6NGGHtFWy0?=
 =?us-ascii?Q?T5/ORdl0vuJY05ajIgP3oieIMcPsis8k+S/lcKVwGq7/d3HX2YkpJAyfeUE7?=
 =?us-ascii?Q?aW9TuJgdaxFsOJqWnBOvZ53PPVEoBmJzm1RP6capp/B1Pj5LF83IS1VLCL9r?=
 =?us-ascii?Q?1LUHL6NpDNyiU9vy1MZ7GpN5ZKZSHq9xEICBqllYg5jHGiAEl+tYuMWdxOcY?=
 =?us-ascii?Q?Bg0r+DYX6+ve6548dDThKelToeD2z0IVeQT4oJn8GQBblNEHeKd3NxTq9lMt?=
 =?us-ascii?Q?ip5oKvf2yNRBn3DHnbTFGssRYHy2ea03vCd2oxLuWJA/NU4GFCmQjHM+RqSA?=
 =?us-ascii?Q?QyzfzKVXm8cMrlIRyy1xMsGTTOPK4ha50JoUzFxBM6aVjF6Wfg25i/szkW3s?=
 =?us-ascii?Q?v8Rgi1Z0Mq9V5uf1Eo2Fu3Vq65/TWmUXyi0ABFrJkH/uTbyZ6y9aqUkAn+xr?=
 =?us-ascii?Q?SAVkXzVYsbdy9hD3pzQr+qonP0gMNunLVIehZW11RWtZsml/RPsCLPsES/bD?=
 =?us-ascii?Q?2onur62yUZamN3mopbiRxSGMpJ1zhFqcNsba?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5271.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?2juNgteai/q7LbPkX9/tNVP61QebZJM6thZzA7XK6Y750cDZxY/AY2AFL+l2?=
 =?us-ascii?Q?Uj4RYsgvpBGovEl58upEoNzQuBd1twZ0vNSUEExl3b3bQB4Nb9EjlQP3NEGl?=
 =?us-ascii?Q?fipvYRhK2rPtBOsg264gY2wuamTyvUM/6NjXgN5XwUI+XXDO5WtU3tAcWpSQ?=
 =?us-ascii?Q?07Ntv/VmI2De59heyvBl/5Isy5nIEVGRa6xQbd1O+Fk4O1P/G3xIbwnrz1ka?=
 =?us-ascii?Q?0gNe+bXOSl3oZx57rW8rQU+xBN+AVp/zCrt6uHgw96OZI09Ri8HoWuVT42oV?=
 =?us-ascii?Q?Nc/v2s+9+o9iSn/GeXthvvOuTeyfOyP0K1YlYNCtgINm+PKex8/vTp+4aPK8?=
 =?us-ascii?Q?tzoUKfHIrJeGW52BlZMC9EZ3o1leqS2V7RnRdzS+SPoCHk+TjdnY6Uz3aZX+?=
 =?us-ascii?Q?eSym4Nl5Ta4yelvmlUTrMasAe6sHKQPPNv+4eiPk6jKDydLTkFaKyBWX3QJg?=
 =?us-ascii?Q?f4JTOdQe/MltvCTZH7bysHnqclG4jNWPSWkcckFXkS9y9meEjhTWieNqAAVl?=
 =?us-ascii?Q?2HV1Dyj7SE2gY6njSG/U4+fwO1BLl+Kx/3fys064ZpTypVpNW/XNcMc5t3f2?=
 =?us-ascii?Q?Nf987blmG99TorRgP77JGo96m3QfTsXoblnlxzF0iB8++RLN5hFoDtDdrZXb?=
 =?us-ascii?Q?B0G5602Tgv0Qx4idi7WvfVxGuzUXhwU5pbACp7OLFlFwZfk2eX6cTpEvDlW7?=
 =?us-ascii?Q?D6QmsD9X+mkC9bGSfk09TnhWJB3QZnX0C2ZY4ZA80du7n0ECbas25Fh2mlmI?=
 =?us-ascii?Q?lH7+5SwgPxJbpwirjbH2eplmzntEJlQSu9pJUn6Q3NthO8Bl4cAfUtiQvrDS?=
 =?us-ascii?Q?sk979nqDjPC2vUXwtKda2XjS9EQu6PowZOWxxxXsrzC5ZqgNP3TTMS8HJIxf?=
 =?us-ascii?Q?JVLcezbaMY4nq6p5G44CKl5bXmkO2KQF+TOK7mMADA9PYBCI/jJnTiZzy1cc?=
 =?us-ascii?Q?uZQbtuArhQAb0Le8MdRbjvDw+AYUouM4AVDTUZWQrVBNr1hTIm7IrXkym1Gj?=
 =?us-ascii?Q?JbR5UlU2eClOyd9JkxSM2zAqxFXQyRA0Tu5B4XhcJzpbDXqn2AWOyX2u9EB1?=
 =?us-ascii?Q?D8DTOTF7Hq7Bsc77GlaAlwIeEWxqi+gDGmZnNeLzhc3uwJY8z9iLKrsjDap4?=
 =?us-ascii?Q?XVp9Q22Oy1kb+i+S//uRTB0OTTbstfVowSSbjTo3Bj37E3p9hEZBPHkSEwIj?=
 =?us-ascii?Q?sD8GcT/tH/XxkUz+P0CB4EA37Gs2ndGD2ry3aE1wj+dFjKfzxnv1C0bTerc4?=
 =?us-ascii?Q?H6MuW276Ic+bgTHKAe15u8deCLGx6L060hQTGY/2iT9z2iV1THYJySAdrFWV?=
 =?us-ascii?Q?mtdP0mSRTdHstIW/OPfJws+X53NXpINCEo/yt7XoymPJmNrU6Kkvw8yLyGlV?=
 =?us-ascii?Q?30GmWA6lUC2CKiynGVQyX8QHmya6wgPEBvKEXk8241q8WIG5ysTTt4yhc5+n?=
 =?us-ascii?Q?EcmtmTbJAPZYPC8OrnoqWYyokoPpq/L8xD3qvBxoDq0OR3gU/cHof5Jli4D3?=
 =?us-ascii?Q?Gg9aEFmucrxabXrrto14W/GofrshkE2A84VFQsK4hOun9HaSfGji+zRdnYx0?=
 =?us-ascii?Q?/yQyQnqGc6MIaXyUQi+l9YlzlBbh2+vhOh+hskL0?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5271.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d02508a-1926-4571-ab31-08de0af6fc42
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2025 07:55:04.3504
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /2aW71xlvYtg+5tmuTxZUzOaIZbezfCZEQWVPvkEmDnrkUAeA+fdeG712PDrLSwH8NQmf8pXHuLIMzYHQWUkrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF8ECAFAD61
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, August 27, 2025 1:26 AM
>=20
> AMD and VTD are historically different here, adopt the VTD version of
> setting the D bit only on writable PTEs as it makes more sense.
>=20
> Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
