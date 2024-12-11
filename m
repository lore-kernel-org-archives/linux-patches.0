Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1059D1DA0FC;
	Wed, 11 Dec 2024 08:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733905555; cv=fail; b=RDobFESjhIQuuSl+fvDTHpK3SsK0b5bqn2L+/8dSmiSx85VNaAhFDoOJYfEAZ+8JvEdBeX42iu//AteyHm7w+wmbOfKM2gs0XevqFqG9ceq4cqRUl+o9ve3mafX8xuIeL6bNr7rdTn+loUXcuGsGNRhbGXegLloyGd8aGsguDHs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733905555; c=relaxed/simple;
	bh=TmqqkmkZ6VcWNDX5Zr3nbpW1Urer9tktcwEVR5waQKw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Ul1OuwXjq5nvVYv+VxBMEbntSNTxHeAzqQ8zGPn4wPYAsT84icTBmybTbW3OD+HUhJl3ISmRJZMQLF2K+uuiLJ8qrFgaHUJIO8BZDSxlSJcaTVPwOnpGhJfiE3MrEnfbwRMJE+DCUNHTL0aC3H2rgdLoOEsDb40FqS9/HKGx4Gc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I88yX34Z; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I88yX34Z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733905554; x=1765441554;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TmqqkmkZ6VcWNDX5Zr3nbpW1Urer9tktcwEVR5waQKw=;
  b=I88yX34ZuQeUisbX5gOFyJ6kM152xw9YsnyIIBq4DWpD+3F6JMmv+6sW
   xKmV9XYXsUuLzEMQrzF7Dw7X6tGrqn2HpZBWUplPjFXiEt3oQS9Bl6qZF
   I12E0houtsbF6hrH1Eg5f883a5jq6SCk53sbBS3Ve8lJlCWKg4pa60fnD
   zbSX98AA95dM6iBlmIDvAFbGtlroqgVIwrOh23CXgpswd+spJru+qhaT9
   hjS0arSo+xj7jFM80JDCx0ixuX2Dtv8ovoVCHw+7eZ/zWf721o0RyFq8K
   k1DzUf7tWq+5ot/gzbY7izxIhBlYolOBUhK9ImWM1Msju3kP/DvwLBq5g
   g==;
X-CSE-ConnectionGUID: I+f3l/0JRmeMua/3oaBTIg==
X-CSE-MsgGUID: KFKgKptFRzGADAspGT4Krw==
X-IronPort-AV: E=McAfee;i="6700,10204,11282"; a="33594835"
X-IronPort-AV: E=Sophos;i="6.12,225,1728975600"; 
   d="scan'208";a="33594835"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2024 00:25:52 -0800
X-CSE-ConnectionGUID: /kglL3xLSviD4mOTLk7dRA==
X-CSE-MsgGUID: HthiDdFPQ1iMearey4YErA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,225,1728975600"; 
   d="scan'208";a="95548021"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Dec 2024 00:25:51 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 11 Dec 2024 00:25:50 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 11 Dec 2024 00:25:50 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.173)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 11 Dec 2024 00:25:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Mv8tRQ76mx5BQUqgiBaydyrssE5xLeYfBr/SrncVyoVfuJVsuCMnXeQGTbi9lnGpFK69WfXoTNnyQQlpU6GFO31IcP69KOyax9GTZL7ULyiILYbnyB8sbxkdx1gOkkJ/mozMdgMHfcGL5rJM1gX3rRVfNYVmZfZidLdP9nQ+DqBt9eleusCjRsP/iNKFWGRTQ3F8RDLG18RM0xIjoKrGqBXKaKOpFSxbt1J4suPxub9KcHrgif4v1Ry55bT6LLg8KlqXWL7Ef941Yn99mcnyIqfrvPt1lILj+GLyasaMY8D0yB0pnIEs3QhG1xX/CxMbTQN6UtOel/6qRvvuXVqc6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TmqqkmkZ6VcWNDX5Zr3nbpW1Urer9tktcwEVR5waQKw=;
 b=ja28J9Y68tgSs5LBZML19M7SPP+E9XhWWG97tME0vQe5YRxXhYaAjLFgOAdf8HsKnHqnKr4dl+aUD+Tur658bkOpwmJpfDWUY9j7wGwxxgH/fc9bLJVxkmbAEVrocn/keXk1q6XLefi+Pm7T6I5Z6dq3vboNl7OQ9sd5fA2b8jqiKMP9dQbYetd0v+OkRxJ65nGQjXrcIJ69dJ5SG6eJMyNj2m4jm7IsoiKXRazhPCgGnrEM0J4Wktq1C9t5Lg2kNZUhNRS6AIvZqKpC+x7e2aa9aKuPdlXbxpBgiWibXNo9xiwbP5tQDxN41shvb0t/US5rjaweecw8U1Wd3bM0+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BL3PR11MB6436.namprd11.prod.outlook.com (2603:10b6:208:3bc::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.18; Wed, 11 Dec
 2024 08:25:33 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.8251.008; Wed, 11 Dec 2024
 08:25:33 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>, Robin Murphy
	<robin.murphy@arm.com>, Will Deacon <will@kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [PATCH] iommufd/selftest: Remove domain_alloc_paging()
Thread-Topic: [PATCH] iommufd/selftest: Remove domain_alloc_paging()
Thread-Index: AQHbRokLnZAvE8lph0WcJV5PLy7MIrLgv1Wg
Date: Wed, 11 Dec 2024 08:25:33 +0000
Message-ID: <BN9PR11MB527695FDCB6156036B89D03E8C3E2@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-8a3e7e21ff6a+1745d-iommufd_paging_flags_jgg@nvidia.com>
In-Reply-To: <0-v1-8a3e7e21ff6a+1745d-iommufd_paging_flags_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|BL3PR11MB6436:EE_
x-ms-office365-filtering-correlation-id: 26b51767-15ca-4aa6-e535-08dd19bd61dc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?LPVlYCVTMeVfkI1VP2wmsm0x3MAaBwwPUH7tIN5ruLU+0KyCY2NyYEDOgMZ4?=
 =?us-ascii?Q?XMI3d7Tyhw6NuBetCY8iizclnvRls9k0Pb9gzl9LVPbegg/sme9H3UdSdwj0?=
 =?us-ascii?Q?vY1cBYsjtONMXNvpq4aYh4WID1o3rRYY4qYMY4ikyl9xjt6iFKvid3oMd6Fe?=
 =?us-ascii?Q?Lv1Va9hUdKK5rjGI4bRQsnbceiKLab8jfqQglZvISzWRaMCLtUsmEz8ILegS?=
 =?us-ascii?Q?tt4jHiiPBak8C/lzMk8ZsjCMtoXDzh3eMACUwxeL2feh/FFQjeNajhHAVg8e?=
 =?us-ascii?Q?ewXqTw9K67pEwsJfk+T47N+rgAqwOMMp/UU2yYjQAGGMUtNxxCW6FyAIqjWr?=
 =?us-ascii?Q?gmOQSGeuuQPTCaLKbZKAoW0HdZdq015j6R6iuY0U7pQ1Ewozmn4VwamNidgc?=
 =?us-ascii?Q?T8M0EeDlRgFdUbf0+FvHfXGAgenguowJwWxq8scX+sOS4L2wBo0drSk7fTFP?=
 =?us-ascii?Q?p1n0Y2S14lJksMmjWpszDtmmfYz9HaVE6mOPKtoea4gnRu1dmNsmtO4kmkpf?=
 =?us-ascii?Q?wfvKxxcvXqIFTCECLEjgarAd9nI8z0lSNKaXvpDtSv/QVGATDkMbMSa1Hfbc?=
 =?us-ascii?Q?cdW+vC7X8SUgUSYMSnCt0om3lJgvqHYLaB4/rt6n01m/g46L1tNyU9j2CfSo?=
 =?us-ascii?Q?bcqKB3+zfiRKr90o8OV7FhO7YxPnKlzGTJTJMEDFMTSnUqwM6GhpCINqJDy8?=
 =?us-ascii?Q?xaTA+mpatTarwEFiBb4G2cU1NWgPPZkHP768qwwhd3dQiFkFf+BCOSXn8jBv?=
 =?us-ascii?Q?1VihXbeHft2n8hkFYz4wWsUPdp2CYOGy/7ZDD7aSOaKMphvtq4k7RzS9dyZW?=
 =?us-ascii?Q?XcDca1WwVaTOxG31wXDntQXLMcTGjnZ3jxs8wJd2hi/AUWvtGQf7KVOm+xOW?=
 =?us-ascii?Q?8jNSf8Cfx0gNkqmz37HTfxHW67Fje8RbbZtXk6wvqQs7wPbDkERJCO7+IEHC?=
 =?us-ascii?Q?g7eiYLV/eXjC30CD4JsDVIWNIHNvVxbxI6B8woWc01zvbGU7DxBwAzyuopXS?=
 =?us-ascii?Q?hcZV/P1fk9xfPW7WRl0urOfAMm/jqwUUclKS24dFgDlGuc30eyNCV1o8lE/d?=
 =?us-ascii?Q?dpBAjJXiHgnZzR0lhwLx2DdyrzhvxGgw2e90Rs+AwgPT/vHJjw8upNF19NZA?=
 =?us-ascii?Q?HAA5QvzKsGabpsz0l6mKnIflSvwpzA8SEw/993z/iTBrKkTJppVKPFXzyXLx?=
 =?us-ascii?Q?deYtYE2vv2gMHRhYLxvFUSMLvbsZK+yna3Cs2rWujBmtfRSkWiB0d3oqcW7W?=
 =?us-ascii?Q?aLijVTimhEVvwv70egEKHDJUeNQqbJAC0e5n7DMHWhCIeJSwi7vDTjbhEwJ4?=
 =?us-ascii?Q?ztcHGEqfjnppGo3caYrV4OsCPdJoWWvotJJjePo8ovjyLnHLYDEUGkW73nJt?=
 =?us-ascii?Q?v2xsfJ7M/kRrXCgoac7zZahgGDRQEHRJ+0ErdDTcdmzS/taElg=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?GNzHpjgQ7w3vKqBr6YRzFdLNqgYB/bHrLCuiTcHCEUxW7TZ25g9BJYFix0t/?=
 =?us-ascii?Q?LNY/kI3Q0sxQmoyvHmLeu8o3d4MxqfB1zrGfo66Ejgvp2v7SXcZRPQ0MNktH?=
 =?us-ascii?Q?VPAuJcPy79hnxRkbTxQlnLWJgw01SOiBLtEaF5qUgxVZNQWp0jVUAdtOxke8?=
 =?us-ascii?Q?wnDQ7AbhoVO6rwP3qx4Uw2knQUGiK7GGyn2Fpxc1TTO8OYwkOmTOWtU+9dFA?=
 =?us-ascii?Q?BXcQ+wAMg8d2tFR60h8por5KoGk8c586IsS2p/AF/CZl0/mFo8+0syNNp1Qp?=
 =?us-ascii?Q?LkwHcM9eijASs1udV8zMET1/kbyZGVHRXYhZ4Ygcg6+bDMpsKIhJvrUu9mYy?=
 =?us-ascii?Q?av67GcIW7w8h80SmcGT97KgdYOs4QiyR19TMhpbP1up+YA+gSYUt8EB9KY1d?=
 =?us-ascii?Q?oLqCJOEnYQPfSKvs7MLVmzH/BIvNpHvTM8G9t9kNsQaT997IllBxF1GyLtRC?=
 =?us-ascii?Q?mo5DZnPRjP4W/6WI5jg3ucXFZMFUQg+Pk2nEFR5oBQWD5xWXiFVbevLtr3Lq?=
 =?us-ascii?Q?Hp4ABn88qrPUmEB62B3gX7M0DtJY++SRQ90F7O4d+VCsOLRvFsV2FBJSopBg?=
 =?us-ascii?Q?hAQGZqNVXs+T0iNE8xU0zWrV2od38ZGz8xn4prD1YtQ/B5Dc6PJrl5JQ0mu3?=
 =?us-ascii?Q?Kb3h+7sgcvhuhGQ6hERisy2Jv32p6X5OjlLSInMSMI6ziVjZ0aHPcuqpNapE?=
 =?us-ascii?Q?hnps83mwaw1AmrXiCjPmqXiB3oC9cXlxSR+H1Y6c8mWPN+VC8UPpaAHqcLy3?=
 =?us-ascii?Q?ehtfESsuL6mF/fRQE6fzEbMne2TGcrqqQv1aVYOtGJ4vSiyQsMPs2GHkH2qw?=
 =?us-ascii?Q?OIvxd+MMtLniTjneQ4QHnA3KuAajUe4i0eYs3bg6lqL3LV5yGRY8MulPwxCf?=
 =?us-ascii?Q?KxuXJjheuM2gNnwa7feiDW+8bqZWR7lmJfGXdkrqEvgPoHT5PUt5rYcC9rGV?=
 =?us-ascii?Q?tog3BtGiM6jQt9xxjGwd1nHah90LjEDxxJ/dlkqsgS6LOu4rwPPzWHyj4tD5?=
 =?us-ascii?Q?OCMmWIKoQcKQSN/lwTAXqoSQfQMyMv5gONegLmA6sCEjZpK96OOur4uz16Q2?=
 =?us-ascii?Q?wjPx6N7VcZwyweaGoAcgm6NsG3Z0deF0/2OQ0ZkKY25Wz+sCEzTWhgAPY2i4?=
 =?us-ascii?Q?d7EEhASea5Yt7s1v/MhdUFFBgIstRj8juJlq2DYyBGmruDU2Iure8ahYUFu0?=
 =?us-ascii?Q?FvJbvFO/Dasx2hyzGddw/E/DKMs7Dw2eqrcNR0KRHP2gDqUiQmi/iDfCxpj2?=
 =?us-ascii?Q?Qoezo/ZcPjECOhegQiammqhvHnzeICEh4RFTUXotRDVNl7KysAc0x8wQfimd?=
 =?us-ascii?Q?LPOrzgtTu3iisZoCQTu+DlvynDNi/CsF9zvGSSG/YrvNTXQ59rJVH72QTLk8?=
 =?us-ascii?Q?R2KGrOqt/UQANJFV5I23Wow+oSj8+7dA3yXAO9JuyWxQTvCX1xZl8l8BDzcs?=
 =?us-ascii?Q?hSqoG2NBlHPby5Pg5R/eqMpCG4A7NDf7z5xp0HxDDNWUdYmAWnuY36hUcKLQ?=
 =?us-ascii?Q?3rrFOItboWImnS3mL8jEzbl1FQJjyogHbrbofU6Zofio2WYuDhfPimpAGyo4?=
 =?us-ascii?Q?xj9SFNeuayahJQYsjGnVwNqmpKl1/EwnRgB86ASg?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 26b51767-15ca-4aa6-e535-08dd19bd61dc
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Dec 2024 08:25:33.7490
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: b3Y39FoK25D+19NvkXVUFBvGuC8EVM69B4Z0hPARevP4IlMyPI/hQFvJaMVQVCB0DFdzo5qPiVnRpgzMxFJ4zA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6436
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, December 5, 2024 4:14 AM
>=20
> Since this implements domain_alloc_paging_flags() it only needs one
> op. Fold mock_domain_alloc_paging() into
> mock_domain_alloc_paging_flags().
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
