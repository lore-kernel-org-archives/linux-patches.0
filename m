Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A40352236F8;
	Thu, 12 Jun 2025 08:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749716450; cv=fail; b=CCAoBMuWThRCP5caoY1a2m6ctm1rbZ4jmV5V9r3qsydbyjruUBqsMdzNdKM6CjUdKJU0hl8Wmwh4Lp6m6lGEKnp4QQqCspbSlhpN4z+X3bh4nfiuC/zeTiiRZEd+TEquoBEk1LHbQUps8Zenz8iRicSIh90+YGlNsAH2V99x/bk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749716450; c=relaxed/simple;
	bh=MHNZBV5ZljtBxtovlqlh4CYCtJOiookE94bsA0MFbPw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=b1j5zwue//GKole97suAwZTT8I3WyeaoC0yg4WPi1gWo/zfmjZvspWw5mCXhHgyi0NwoS4F5t7Sw9Lz5JPeYmC+SN25XviyYbDLViQYszuCfg0Bh7f9cQaKdS7dZkW6RBg5zTc58WulyU1FF3VGcI2da5ObkB+FMjUszzmtELb0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=U3ZMTP6B; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U3ZMTP6B"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749716449; x=1781252449;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=MHNZBV5ZljtBxtovlqlh4CYCtJOiookE94bsA0MFbPw=;
  b=U3ZMTP6B3QkG3kVGw6BcN/CzZxt5diQzwOFO/4p4y10zj7FLFWl0rram
   L+Kv0HthDrOLggdF1KuhYnol9n1OYTEF7d0snNFh/oFI25/1TFu2OGBTd
   OkjjduPCo/be/F6Ndh35FOwB1r/TMCVJHTpijT7cnhu+bxem7NC3qRJ5c
   E3UI9pOCZ4rMqaEWZqeYstRmrs6ik7cpBMCC6Q1I3QRui8B/X3cpz11aw
   oWJ+gm5U1JGXfLIJ+9DxE7D6aFrUzFL5AyvXuTaVZD6RliXFMSRkL5v0i
   XMjb4KNg7Lq070xo5e87sgCr+6GL5Ccfzmks/CSXgrNOxrH5UmoMklJq9
   g==;
X-CSE-ConnectionGUID: sKmZy2GvTiqf47pz9SpqSQ==
X-CSE-MsgGUID: RdQ7tdV2SWK8vNN5WiDrIQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11461"; a="55557194"
X-IronPort-AV: E=Sophos;i="6.16,230,1744095600"; 
   d="scan'208";a="55557194"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 01:20:48 -0700
X-CSE-ConnectionGUID: dmAZOz35SL63Gz8AXIUZNQ==
X-CSE-MsgGUID: iaiC68MASB+f0/3LtkVKmA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,230,1744095600"; 
   d="scan'208";a="147290019"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 01:20:47 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 12 Jun 2025 01:20:46 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 12 Jun 2025 01:20:46 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.71) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 12 Jun 2025 01:20:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m44G66EiZ5il4q9e0shj5Sy85J6VIvYVj+ktpVLycm3EHtyQPnv7kJDSHg0UmleNHlu/+Y5B2VWcNmVEmmejdRxPTOKDXeHXLP5qLQKZobZ+TNUsHmEVokabxjgSweDNSgkFoNp3pqULQowuw+ck3vUEjnQkYFwHw3HGS3Ysfj9Q5BPaV905YaGe4zjOl5206Z2giFI6MxfE8QBNHeWQA3GNi0dxALJLKiKOZB04y5n84DtshrFn/8mkjtYFblSqtZOJq2Wl6LoaOswwMYtlOQrYHr8E8NMhf+EMmhdXxxt15aVICRfOzHKAm5VSf/vRgd3bhJV4X3W64JTXtfrUGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3w3rsSwLezJQMN/psHfB49ImCPmX+DCsWcQlYOxeKb0=;
 b=U4VgHlD51bEOHmFteN+FCX8Km7miCIrtt1e/RfG4W73lnZG7NiFjLYfYsaQs7ZlhFQOHD1GICpfp2SqPvec1Sn44+85CLIdBRxBPSmbKbiRidWF9gchCLx1MZin8Hu1whg1rN9cqoariMBL1jKEiWqITLZPdk3L0fWOyEyGSxzwf/XwExn+FaX0jwm+YxSbxQZcFP0bo2UhLcAtc6P22908g8YRiU3BzY2OtGCl4SKGQUIO2QlkyPVKYCkD+RzNot08nMEQLckS0b43xIggA/jCwDudWLcMskADzFqeg9K3VFxckZI5QS8ebMAg1fodUrYFZ3UdC596gq0oJULhMsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MW3PR11MB4572.namprd11.prod.outlook.com (2603:10b6:303:5e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.18; Thu, 12 Jun
 2025 08:20:30 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%4]) with mapi id 15.20.8835.018; Thu, 12 Jun 2025
 08:20:30 +0000
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
Subject: RE: [PATCH v1 07/12] iommu/arm-smmu-v3: Implement
 arm_smmu_get_viommu_size and arm_vsmmu_init
Thread-Topic: [PATCH v1 07/12] iommu/arm-smmu-v3: Implement
 arm_smmu_get_viommu_size and arm_vsmmu_init
Thread-Index: AQHb2WHzLJ2ABt636UCLQu+hzyE9l7P/MiKA
Date: Thu, 12 Jun 2025 08:20:30 +0000
Message-ID: <BN9PR11MB52764E40612C1293699E43F98C74A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <cover.1749488870.git.nicolinc@nvidia.com>
 <55b1d69b2cceb685d4eb728a7a53572a9147993a.1749488870.git.nicolinc@nvidia.com>
In-Reply-To: <55b1d69b2cceb685d4eb728a7a53572a9147993a.1749488870.git.nicolinc@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|MW3PR11MB4572:EE_
x-ms-office365-filtering-correlation-id: 36de765d-60f3-4d6b-ff12-08dda989fe95
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?NdwKj1Cgw9Lc/Hk8MRvckZ+zZb5JhLStbv6hGP3aBs8NiC9O0iwEJRTd80jr?=
 =?us-ascii?Q?pgupkYwDkPd3mk3eHmJdc5ahj3snG2alSXHTEBQtuZxVqoX6qwE+be48iZGy?=
 =?us-ascii?Q?GQbJnPZ5mOOQxceIPIQWzBSdkEKl0jp3ER4o85s5BCGsNp86MFExrm7V42b/?=
 =?us-ascii?Q?qwiNmGNCxcPOevB3yk3nlAcYH6BeJKRKw+h+qjsfPLlUtX1SvnlmhZfaAsZo?=
 =?us-ascii?Q?+kGQP27IKBhCaVShPlxf9fu2WTESgaIaulUh2dOYOafMGbGDZOZqRXi4JiIX?=
 =?us-ascii?Q?Sw8bpxheZhNhZ81prgLtRS5QyBWDZZnAQkTiKToimyUBeoA5ll837UiY3eIc?=
 =?us-ascii?Q?MLXEgIi6a5/6MOZVLT4gOwgLT+1tK4XRyHtDZerHV3W3zKIhP0b8hYBnaPaq?=
 =?us-ascii?Q?A1fTcK+60FLQjQiZi4ERvLsn4/53wlZ8Yo8SctoTDTKLgkqDTMxuO4mLviJr?=
 =?us-ascii?Q?z/2hLGp138K+cXlRYbnv3jXSq9C0BftsKXWLkj0mCofj2vGBKEIIOEYiXbnF?=
 =?us-ascii?Q?4V1MyOxade43F2ZQ6QIUxOxusLY7NJUUSJnMvJCpRbGTfcL0l6mCyXVI1zbn?=
 =?us-ascii?Q?AVlHdYvVkZeR7pluE29vo8YL9QI+qMz1byrYX10vWFx/ayzb9OujebDXnehS?=
 =?us-ascii?Q?3sK0Uw3/jcWjLfZlAAvELYPUMApsZPexPqqDREp4unZ8wn0e00Eq6tIywPqv?=
 =?us-ascii?Q?0hTANQZpfMcQUxpp5xLh5lEsDyrPFN19QvRC993aV1ntxYIA3sXm2P35MZyT?=
 =?us-ascii?Q?ZZIQViLVQsWGkhlwEb6975L9snEmQ8qzDEOMpNpEcTQKtOFMsR49KbOS7vXt?=
 =?us-ascii?Q?RSQAHXZ8lcyWjtHgonzbWdKCEhJo3NJkcrccsbKajAB+r76TCs8YmE09CR0s?=
 =?us-ascii?Q?U1e8opGbO5bvUbKXPqDnphIllDmG24rtnEviuFoQy2WgTuLl0icQ1hCoWJuB?=
 =?us-ascii?Q?39sm0lgu9xVKaTRjt7miBOsL8iiR3OrYGx1IOQcbkOG2QJ0x2GQ5tVtoP8Gl?=
 =?us-ascii?Q?gl02Ul7MnZoxWZ3YOG2D7agqQgNiwThPVkGH4HaNjv5KeeFUfOryJqRDeuJq?=
 =?us-ascii?Q?9j300fUF9rpE5+SMQEgdtOHuMLbQnmFjNvWTKOmKEEe+I+7MBXeUo35A7Q5x?=
 =?us-ascii?Q?TguLTEsw8My1r2/WKtLPPK/jOhHfCxltfmHEhTKxfwSBZs6QFb7uWa2PtdwR?=
 =?us-ascii?Q?HQ1wQ+a29Bede12qeCSSndcc1OId+hogupT9GC7sTC90wlXuclFEw70K6oH0?=
 =?us-ascii?Q?gtqFK0KO4gf8bpAwTyMYM+QZYfcHMxg2OOrMmqxJBt5euBcRv08Xjc70V/tt?=
 =?us-ascii?Q?k3Bx4HDI/M33uZBfEDWZD7Ahuh33Yd7IRFYZws1VFEmoq3Z0/d7hzHt9FI7N?=
 =?us-ascii?Q?jRByQ+55XVMoQi8MmboINvxnfF6qKyj1tD+Aoob/b0/gBGSKkF2lFeBKclAn?=
 =?us-ascii?Q?NeykINr4aV46fAygDUwX6SxseUUmycQjCUHoUJxUZGGizWucW2HU6g=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?lrvNsmx16OoscHMs95xkInYS9TbyAidwEA8kk6Xwh+hOoCV9TULyPWhh4Lt5?=
 =?us-ascii?Q?LwKU3vljO6qu6Adg7owCVAoh1apQ2pSBU0kZBdTq6qnDFv6skxm0QBIhTAZa?=
 =?us-ascii?Q?Y+mojrI1bugngTtBm9rd8NurU30R8PSXxcVER+gFfCsWRfka1yVTQ9T4Rt/o?=
 =?us-ascii?Q?c/mDIUKGpxn/4pGr70c9mikRxaErK5louHArGdcek/5AH4pNqIfnYQm9JIYF?=
 =?us-ascii?Q?5Qt1t6oB0DP0wCAF7O84jB00yUw3W8xPZtdGphdhF89KAcMM2jzlnTfvKo+a?=
 =?us-ascii?Q?6+tR+ncuh2ib/USSk6PMsx4QLBYN6ldrglJyRvbVB2rJ4X4oXOe6DOdD4OgP?=
 =?us-ascii?Q?P7E6I/OOaMc+FlMipCi/x+C9cH+KeeXcOvxUUWoR1ho6FlQxD8B9WsY+K7oV?=
 =?us-ascii?Q?1cfvDF30pfMrcCEqDsid+PRyuVy5pciH0BKlsPeC+13xrMMVjUaTMUXkId6p?=
 =?us-ascii?Q?/dueihsb2sgLm74kZ9y3gEFOeryK1qq52OffrVMQIW6gtlIPxR6Mzra+bLmm?=
 =?us-ascii?Q?tcb5W1ooBZitNeyv10WrFw3PqlajvY3IndbSCbQIWdEIUXChoeFieQcK7rmA?=
 =?us-ascii?Q?u/t5n0xto6eT6u58XvQhTwx+wJUQq5r/7LSLqeW4JGHGwcpM2HJfZ1GAm6KQ?=
 =?us-ascii?Q?RWqUj2XUYW3ddEKclC8br+3pnC5dB+PLxcwKaV5/dX85GRowqv0Z2eXq2sGl?=
 =?us-ascii?Q?hVxG7YGWGyT8KGEcUQ1ER6N3cSbBKZxpLhLBlY+LapH1twZlni7iRsPkEFxK?=
 =?us-ascii?Q?RhSorQBVjIZZ8/hcRJgR4DCNaxLxs75f6gGCqEkiabZM/WpsxU/XvtKxZzXI?=
 =?us-ascii?Q?FYo7UCTPKavOx7DWFlJT/EPxigRrqCWAdquh0yxpbQNvqecVSeth3/3qhPhT?=
 =?us-ascii?Q?hwEN+t9bSBRb4o2Uc2vfScYWCVjMwTJCeR1WDBka1Zi+YY6zANHAisL7XF53?=
 =?us-ascii?Q?gJT9fiYjNN0xIZSt+OJoWTRLcc8bLN5mdadkhmP9vo5e62FR6DT+M124sXxP?=
 =?us-ascii?Q?qh8FQf3prK1BjK7Q9fdnJwbrAScWRXiQPafAcc5BzbsAgBPeppXb7nk2nJVg?=
 =?us-ascii?Q?ny88/OLLSnpIHSyVT465Hjf0hIAV3Y7H99iZ9O92pdzfEH0+aHYVwkFSKA7x?=
 =?us-ascii?Q?OBtNlkoef1LtQA5nEMh/ga0q8yrHUxmdHseH2C/FwYG+53HAEi/3fboShK7W?=
 =?us-ascii?Q?pKk+Dw9wxGCbixW97iuYpY3q1gj1QaL4mQPSJNOBmNEYcnLBQk+JQ4+w1ByB?=
 =?us-ascii?Q?VNdgOmmR4Al1xkco87sZITdcVFXGNttjGmhH1iES337N/X7ihMdNowFBDEhi?=
 =?us-ascii?Q?SaGF3TnRBsw6SwlCUg69p7l2QRSSh23OpMr8rbIth4BUy5xpSMpstyj55lD9?=
 =?us-ascii?Q?7aU3/V548hbzaGSRuSAu1eHxjWN/JlKsboQJg59wfI60+yuldicbcliaYOLz?=
 =?us-ascii?Q?Glr8RMySLtkxOxILgLngBHbJtWb2OBEyV7HEwemiUgCKucSSsanXVShK9eeh?=
 =?us-ascii?Q?FcGNYJCrpicL5pRd6WNMNqItRoOU1Z3iBPxQMGduVQPenvkyAqbdc3GFxfxc?=
 =?us-ascii?Q?JdbFAkalyFDSCVzqgWPRELJ/wJjgymujKH55Rwcv?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 36de765d-60f3-4d6b-ff12-08dda989fe95
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2025 08:20:30.2911
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U3kfUaAfJ0NvUvXVuMh29oqw2H0K4pHxMsM3+fv7JjSHchhPA/8RYl0EKBMf4kICKhqvdzq8h1+heeSN7I6TYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4572
X-OriginatorOrg: intel.com

> From: Nicolin Chen <nicolinc@nvidia.com>
> Sent: Tuesday, June 10, 2025 1:14 AM
>=20
> +int arm_smmu_get_viommu_size(enum iommu_viommu_type
> viommu_type,
> +			     struct device *dev, size_t *viommu_size)
> +{
> +	struct arm_smmu_master *master =3D dev_iommu_priv_get(dev);
> +	struct arm_smmu_device *smmu =3D master->smmu;
> +
> +	if (!(smmu->features & ARM_SMMU_FEAT_NESTING))
> +		return -EOPNOTSUPP;
> +
> +	/*
> +	 * FORCE_SYNC is not set with FEAT_NESTING. Some study of the
> exact HW
> +	 * defect is needed to determine if arm_vsmmu_cache_invalidate()
> needs
> +	 * any change to remove this.
> +	 */
> +	if (WARN_ON(smmu->options &
> ARM_SMMU_OPT_CMDQ_FORCE_SYNC))
> +		return -EOPNOTSUPP;
> +
> +	/*
> +	 * Must support some way to prevent the VM from bypassing the
> cache
> +	 * because VFIO currently does not do any cache maintenance.
> canwbs
> +	 * indicates the device is fully coherent and no cache maintenance is
> +	 * ever required, even for PCI No-Snoop. S2FWB means the S1 can't
> make
> +	 * things non-coherent using the memattr, but No-Snoop behavior is
> not
> +	 * effected.
> +	 */
> +	if (!arm_smmu_master_canwbs(master) &&
> +	    !(smmu->features & ARM_SMMU_FEAT_S2FWB))
> +		return -EOPNOTSUPP;
> +
> +	if (viommu_type !=3D IOMMU_VIOMMU_TYPE_ARM_SMMUV3)
> +		return -EOPNOTSUPP;

it's more intuitive to check it first.

btw does it make sense to also add below here?
	if (s2_parent->smmu !=3D master->smmu)
		return ERR_PTR(-EINVAL);
