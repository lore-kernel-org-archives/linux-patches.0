Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1510230648C;
	Tue, 14 Jul 2026 01:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783991673; cv=fail; b=O8X7+flzO8FmT1BAJkIvWmK5N4Szoagf9OK4jGzsqfg+FA5lxgfZcPvcHpPDzxvvDiUFIiRj2dsGh3CWBQdH4d1JBV7Amvkig7pRURI3q+Z2xwq3z7bWKxcULzQn7pV90txCf7wQF+Age8hsLeDV4KmFTkEwbgXEwqTaeImnArs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783991673; c=relaxed/simple;
	bh=hYGoj90DOLnH1+k8gm8LEt0U56jFBdGBmWeofNexI2I=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=FQUO6gJ77aT1VFirRqBgM01C3PYEEuwF7KbIEs14ag5l54X4pRjT3DlfU9XoAbM970dugn1E5Vn0VDSWjmKz0bzchPNq1Tt/w7ntzCGOLXBp7e/NNEVUPkPGZMs5fNzIGLhvGJ8u2vUGgavcP9xErZ9wOvRydqfcEQl83AnXewg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kNmpYp70; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kNmpYp70"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783991671; x=1815527671;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=hYGoj90DOLnH1+k8gm8LEt0U56jFBdGBmWeofNexI2I=;
  b=kNmpYp70AwgLl06is7bnXxGnfcKmVvAAiGAKskGTrCmQQV2zoceUra/6
   Qg/p71AxqJT+IeWDazl9B0Kp5tDLyLDx13zrokdX+3YCWldGcN4fWg6u0
   zI97O/GFF7BhUl/weT/d3w00ZoiK0IizMwaNIY7CHuX3C6X9O46Bc1mSn
   P4SFuNmTO6sajswRv9YknNe/1Bhz3eozPMMNFia1z0KMxCjNO5LMLN1M4
   A3Lj3Sw7AQmbmKkdtd/DjZey6zN78QbDiUHKhvuxZ/s3zOgFm9JCjqX7W
   SydSEkr4ACpg72euKOK1HsefCUoHjFq6r9wqRUyaoPze6UmRz8KwMsPht
   A==;
X-CSE-ConnectionGUID: YxPMkibzR0qGpm14nsJrCQ==
X-CSE-MsgGUID: 29MhoJ/zQ0Cy23Qnwty7iw==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="84702366"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="84702366"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2026 18:14:30 -0700
X-CSE-ConnectionGUID: FCI3Xp/fTD+8dVY3Y0qGBg==
X-CSE-MsgGUID: i8zupZddQYSSTLvmZOj3iQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="252319063"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2026 18:14:30 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 13 Jul 2026 18:14:30 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Mon, 13 Jul 2026 18:14:30 -0700
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.29) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 13 Jul 2026 18:14:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n9QgdR3Z0sQQh3LIqPWjkYxgfqdXHllRILjP8bxl/SZvWtpco5vtRz6iaLxf6krNzAvEOEwsxvnvOrqgp237Nd+GC5LOQhDdbOERCHLvWbzCOS1xBJK4Q7bKIQkpo6fBxVrBigVWCAmGBRiLTXuTd3t7EXiryL/FD+D98BBrRAT5H9B5TUg5zMuZkYYTmdYj+brehUYvhG/fyAbS7tQtmJ8qbzfqUexciIInPJllrKldQRVavbT0B9e35ILhWRcNxyl3c8Uvx+yghT3H7mmXBs4q+yR9zVcDP2lesBuNjsW3zn5IwsIVMH1MgsqF94X6VHQiBXIHIWiFwxFhk3F86A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L08klSZjfp9TCEe4EtiH1+pZT4durQfvcpCTgZ1dB3M=;
 b=ugqx+N62h/+WZBSaLZ8WjY3ixoQ9vM64ep4lEtNAZxHFqBUeXhRPjcyRm6Ee5gspfTKCjo/acMZgwPKlCOaj0ZOs8mq5omA9itGnnp/5Kso60bnlX4WFKdbXPaiJ74BEOyBOtN8VhZbw9BtJpCccyMXnjmKUtQhSkCW5pjdKMzbSVecQOVbyTt5ClSuR9aKh+924iFMM91ledkO1L2zOvr83UXG30gqSck/JoqkJL4MHiqeY04DD+soyzzAhxwBZlFPOiGWzDi1jbtQJIRBqWDo82sZlOpTR4qIt9vCioYh4oFGZIZSyKCqe8Ggq3Ucd3TasnNYMaDhafabUHGBnLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB4835.namprd11.prod.outlook.com (2603:10b6:303:9e::22)
 by MN2PR11MB4759.namprd11.prod.outlook.com (2603:10b6:208:26a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.202.19; Tue, 14 Jul
 2026 01:14:23 +0000
Received: from CO1PR11MB4835.namprd11.prod.outlook.com
 ([fe80::d051:d948:c209:9225]) by CO1PR11MB4835.namprd11.prod.outlook.com
 ([fe80::d051:d948:c209:9225%5]) with mapi id 15.21.0202.018; Tue, 14 Jul 2026
 01:14:22 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "Joerg Roedel (AMD)" <joro@8bytes.org>, Robin Murphy
	<robin.murphy@arm.com>, Will Deacon <will@kernel.org>
CC: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>, Nicolin Chen
	<nicolinc@nvidia.com>, "patches@lists.linux.dev" <patches@lists.linux.dev>,
	Peiyang He <peiyang_he@smail.nju.edu.cn>, Xu Yilun <yilun.xu@linux.intel.com>
Subject: RE: [PATCH] iommufd/selftest: Simplify iommufd_device_remove_vdev()
Thread-Topic: [PATCH] iommufd/selftest: Simplify iommufd_device_remove_vdev()
Thread-Index: AQHdEuyicOWalwUmL0Wyp5x7DAbEBbZsNakw
Date: Tue, 14 Jul 2026 01:14:22 +0000
Message-ID: <CO1PR11MB48359F7C2D14D105751111708CF92@CO1PR11MB4835.namprd11.prod.outlook.com>
References: <0-v1-719003d53a5b+38b-iommufd_fault_inj_vdev_jgg@nvidia.com>
In-Reply-To: <0-v1-719003d53a5b+38b-iommufd_fault_inj_vdev_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB4835:EE_|MN2PR11MB4759:EE_
x-ms-office365-filtering-correlation-id: a3a9e025-535b-4541-a6f8-08dee1453d3c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|23010399003|366016|1800799024|38070700021|56012099006|11063799006|18002099003|22082099003;
x-microsoft-antispam-message-info: LWS+eg0cS85Q/R4ND6rlLoy8fN/7XgUWU2EQgfhCWTdpuvL5KOy5AdQdp0qP1FxmW5RIxAJfOubkAb+6deupLym4Wm/lN089WARA2UceOe4gh7/uz8s6jyuiTPDkPkDnkrhK9colX1+x3HtKNiK31iIMNYS84xdyTJDRtKgyy0q22IulUtO8cghlf0+lqUE8PEAoPnLqQ/jxuWFDeQtgptC204Rg4a3QB/yIIHrCxnCLgCh/rhrzW6jDkEZAdufczqDjoMVPJAeItISxJUhYt0PvcOrGiaeGAY4hk6wVHFUZIlkEugYKE7G4Z0JyITQxYF5Vc519O1fbtGMDzxsDRkQGF6OuZXtfNFpZ8bXt1X6Mj90FMS74oTq6Vin5EPHfpRBOZkbJWy1S03MH0xSOHqgAfNpSixiedsi/ga4rFamNJFFGdMB8gG2eQptnhf+R+o40U7BnRCKZfaFWNPJd2cxBg4IVn8FmH985C5oJ51KnRNkPXKWZ1LcBGX5eF4Rn5w/hmiJJh5rLtNmdgIRxUDpix/qFsPqVN5wjtYMRlCP0rnaSN4ZDvMbB0UF0HWelPPrMRe1Npa2yK8HoJA66ZK0Y+VqlkkUbCV1v+8oTVu28AxtuYr2/V3DDfWeSu2x4gAXIQuPqY9Sj54cwMOtHsk81fz3qDJ76X+nWhR2KSmkNofFLiUoNHNZzigytqZgnM9N0oAzDFXGb1qKlOBXxAaU1O7qcxnlTpRJ2ahI55CQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4835.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(366016)(1800799024)(38070700021)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/ZiTRhO7bO9+1flpvh6+WmkMcxk5EfpuWMcdBQNk7H8aBIIBPlvpqyFMbryW?=
 =?us-ascii?Q?hhKIPD8gmH5N+4YYkrFMNOg7K7NMlRYQJGS8l+5HD1dnnuJ7/uVXssQT0qnI?=
 =?us-ascii?Q?90hzL15qH1Yovhmm5i/kYW9ohXp0CPdWAreOxKMgJYCqoISrAYq5CCW7e10R?=
 =?us-ascii?Q?UAq2qFSBVuyybcaxxWz7bsPArjXqlZHh4DkWZpmp+d3crrQu9CVp6AnjPG47?=
 =?us-ascii?Q?RrfxyJ926FM1ABMC+nBRskX2NG/C45nk0qIofSFcwepxTilQo0tKvFfmk5nH?=
 =?us-ascii?Q?L5YYiTci7TRKcAQAFWS8M5pB+mM/iBN8SpfUMSeyDOk7S6kBcgUZ2aEG75De?=
 =?us-ascii?Q?UFu5EjmWbMvujPzEXKJx4fjw1/9S6khEUKJcmtO62dRRVML1EWIObbea0T3t?=
 =?us-ascii?Q?BE0Hotd28VDAa16thKgscHmIJvCFUdlSFzzYSEj9O5lOKfH88h9ZFWh/BUTg?=
 =?us-ascii?Q?SuUUf6gZ5qcSueJzfuItbauqMOSZoOGS1Nd92RqbpiEGrge0BfLc/6MevsHr?=
 =?us-ascii?Q?QLBh4Z176lHkPI6yYTm9GXkQ105Oe38Zy6K/zkA/zebHsjGnQ20Y1ZuTEXTN?=
 =?us-ascii?Q?jlFCKcCzsdSr/FV1Mtheahq03QOEV8JRD7vS4L+NFdTz/8VWwllcwEFGtlvC?=
 =?us-ascii?Q?NhSVLS/Z1g6Q9ae9jvNC5nbOQ/rxoqdINGn5GcXaDSw6XdxMW6eSwNEeV3I2?=
 =?us-ascii?Q?TyW7fgzdZIPUvh7fTfYLkr6hlW33ygwEFJGilEeTW5rdP1eDYbaItMYL7jzx?=
 =?us-ascii?Q?7YW61S9q+cz0PAoMDszou4LMXD/vDwSlEhwV6QUZWUW93/0Kw2ZF5D26c9lK?=
 =?us-ascii?Q?1NN+hPZeAW28oyPzg5PzY1XjTwtPxImsL03BpngXoxglEpx2SGaprEk9GBBe?=
 =?us-ascii?Q?wdgRE+5j16kbx80z+mXG7ipTXDbBB/yFQNEpGRWxM25K3EalJvf5k9UNacj8?=
 =?us-ascii?Q?/b/YKp7CRztBIzsuGR183tG8RfqCTHII4BDi4a3p8nDe3lWwmj3KvA2olJgo?=
 =?us-ascii?Q?yOx7+2etNKHyzHVNzWqKOhcDIXdcLKaEFEuWNdDTyKjdJevY+Eboq/hZuCUS?=
 =?us-ascii?Q?O80G8vhvXVgu3mhB7eB++AHN/wjHjdqV8y5CL7l0RCxGzF4b2zkkcSn/dUIm?=
 =?us-ascii?Q?Pg6glKRm/rT7+moslDHc+HVIt/sf06oYvGVw+Nz5NxCJwor7nOR+KX4mGRCK?=
 =?us-ascii?Q?fMIDlx6OiWltpvt1oonzVwAaTVLYsCb962GBVyCa1UlPR4aXVFqcGhltSNXp?=
 =?us-ascii?Q?9AUaPvZXh2BTX1CI6OsurmDm2nVC5IUCl4lf0C3GRk4sCS6srvDZ5V9DsHE7?=
 =?us-ascii?Q?VopwlzYaUmaEaSPyMmBSghHGHt31bwOKCTmFFZH0sdwvGO1tAWMADOZ7Ybu1?=
 =?us-ascii?Q?X1Prh0B9TXQK/X2kkGdsjllXP+4/loX0IRJC36oZ/Q+NZrLz3zcRAnqCBZad?=
 =?us-ascii?Q?fDQdghqzoWmJFAt0TrlGkMRuvXjncjL1+qOqeccMTAdyRUvgWMAK9L85Lsnr?=
 =?us-ascii?Q?M97w/Z24AixCh7F9eNIFqVJyOqHhJZ/CmwFu9xMs39KkTsK+oJfuQ0F33StJ?=
 =?us-ascii?Q?/rHEQaUVuNd+mExl3kZoVlSplUoJCc6gVDkqs7CusGrg06CageajeoPhw5Hf?=
 =?us-ascii?Q?rS58uIJJABx6+njHzT+SAqsrX+aKIEMBf7m4wtExkSJNRv93DdRWEW1Bkqkj?=
 =?us-ascii?Q?4sJnUdySYbnXqPsCxo/DuDabOe6BSR57VagthhODResdJ1ZF?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: XOcLKh3c+OVmsBogBFBdHwarOZFUF79OLySTCr0jL9pQtjq4O049ogOBkZCgkENCT1YHL4ERjjdGrQ2PUUZbg+MsK9TZbKcThI0gMKHMFpqV06W14gx0MAXt69VguACM429CQyqeNfhC1iGEWfyY1TEbomHralvOJSXF6vE1NpEDu/jSazGWxgwRoDowCK4ga6Dcz55r73nwKE/99PziiNCQNqAJC99SjES+PMkjTNcmx/C4yNT/x90a8yNPwqFhIdvwhvQDGgI2A0MnyxM+0/+u/LYFG6rPd8e2MXyHfNSd14ypTsu0p8f1mqXI1ODaUux5SG1MJGfwK8/+Mn2GRA==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4835.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3a9e025-535b-4541-a6f8-08dee1453d3c
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jul 2026 01:14:22.9467
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mlORYAY27NX+JOScpvLGUDVFfweL/HcW7/NKJuWt5Mo0x3ZpzO3LMF0YT5mw7gzSe3TGgQq5LVVsWxmPVLOHFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4759
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, July 14, 2026 1:25 AM
>
[...]=20
>  drivers/iommu/iommufd/device.c          | 13 +++----------
>  drivers/iommu/iommufd/iommufd_private.h |  9 +--------
>  drivers/iommu/iommufd/main.c            | 20 ++++++++++++++++++++
>  3 files changed, 24 insertions(+), 18 deletions(-)
>=20

btw for the subject line, it's clearer to remove 'selftest' as the touched =
code
has no direct link to selftest (though it's where the issue was reported).

