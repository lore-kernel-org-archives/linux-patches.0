Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 770FA20010C;
	Thu, 10 Apr 2025 05:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744264128; cv=fail; b=pVDy8aCPDL0oX+0kJog4cQWkZkZEal3euYUX7oIw6ct4wkZiVV6DSI/JkjHNUR2HjWJBABhTUJ5RQtUAqhqr74TF2D018+uD0fNvo5+Vbkz294++1LC17WOP2avBOQiTtMFr28zp+0wxDk49eNxzlp3b3f683o+5qeDL4fWuf7o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744264128; c=relaxed/simple;
	bh=fV/kr+tVTqzqY/rFHOsc1wYiFjbq7QJtNRB9Oqgss98=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hNj54q9wNzm3YsFhJIt8fMocWoFUeDY1I7TwUJKAJ3iop8jirKJ9A7Y4HDP4kEb0EQTH+tTPgdCYj7q5exooC+inSIws2XNnICayhJE9/LAYsAsdN9qmSFQhk7jVR8FC7VYcSsK/KRT3yoprLqiCuCZ3nhDLW+gN5lZWoRSts1s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=N6Z/9/uY; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N6Z/9/uY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744264126; x=1775800126;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fV/kr+tVTqzqY/rFHOsc1wYiFjbq7QJtNRB9Oqgss98=;
  b=N6Z/9/uYMFkPHIPExvYb2bQrUiBZxA3RB8dyS6BMo+jZ9Dg3U6HSbqNA
   sNoGv+TrgnFyDnWGns0pmY++GANF4pLwEaCGwB9FmUkfv9gHxZ9EgQT8E
   MdCKATbYtBdC3iQRyjiEq/WGo454NhKr8wBfY4BGPLvLkVDwpwdnKSVjS
   HN9W1gL6j1JMf5UZmAmhPp77abMfSMKuWCLW1ENvfHv0iNm9TQAANGE2J
   hVclagyMNzG7yroOB+smnBGwQfsduWPNxZSR9ZLEG0fndla99eq85Sims
   PuTRu1EKN6ilKj8WmFGBnm+HgVyonETtVKEbKnwzk8l08iVhb5/w7pRTN
   g==;
X-CSE-ConnectionGUID: sjAx9ARzTT2Jv+1VLHnztg==
X-CSE-MsgGUID: ltuq4fSZQwuV0Ya8TdZDjg==
X-IronPort-AV: E=McAfee;i="6700,10204,11399"; a="45659890"
X-IronPort-AV: E=Sophos;i="6.15,202,1739865600"; 
   d="scan'208";a="45659890"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2025 22:48:44 -0700
X-CSE-ConnectionGUID: rbaedFjlQdG5BmFdDnf0wg==
X-CSE-MsgGUID: yqPG4kFsTg+mF73TdkNNRQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,202,1739865600"; 
   d="scan'208";a="166012049"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2025 22:48:44 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 9 Apr 2025 22:48:43 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 9 Apr 2025 22:48:43 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.48) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 9 Apr 2025 22:48:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p1l85ifRnzAjruaP5AuzcK2Kh0hm9If8C5NI3CxG0RAr/Ins/s3uav0TVNAzn/Jt7oe31sUAvdDnWoZVAgse/9kD1XyN/0RCIl4ngFa7/L/QRCAZwcMDPF2aYex2IY2Y95Ui53XRdw3betSY4R/X5f3ir5GI4k0p/xso7cNzHmBe1E09HGDirpY0LcyPhBjNr3x3g5wNteAFL27meSqbR6CXlK/cxr/LDWg88O83kLu6S7zECaFNUMuY9+rWvIUNy2vJYnPmy4ptS9DOuoBhjVSVIM8UqVOVvuAwcGinBKlm2duo577zT2uwUrJvQA8irqj356Qz1N4SuPpg3s18cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c0mOkaKrsQzkpa150r7EgUVMUC72nj0mp5clK2eVggc=;
 b=I04ni4r65Y5T5aBUw/Qypb6uE34PqprlaWJrvTkyx82vfyoeyOYMGQ/6y9pleFSrDuCga+XdL8r/6JC1ryHdqWtc1r+uPUPkSxBYsdU3Co01kWf8w9sSFW7IT3+/FRh1O/DNoiBtZ44nLPhB5gqMWoMo/S+5DANK0umOFgDWOVWhZGSP1wW7LuvYzxdbQYel5ba9S4mezq8y1fVT8FkM5+xcrAZgdfVmhUvVyHlY58D182vcl4UmHeD8057EU1ez1X84jXatTriOqj5apjPnKQawaFFHFMfTs2MT3oDdSYk9OMofKj+hgBIojdBbeJY3OfmpH2xCO8MB2zN4nqEDPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN9PR11MB5291.namprd11.prod.outlook.com (2603:10b6:408:118::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.23; Thu, 10 Apr
 2025 05:48:28 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.8606.033; Thu, 10 Apr 2025
 05:48:28 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>, Robin Murphy
	<robin.murphy@arm.com>, "virtualization@lists.linux.dev"
	<virtualization@lists.linux.dev>, Will Deacon <will@kernel.org>
CC: Lu Baolu <baolu.lu@linux.intel.com>, Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
Subject: RE: [PATCH v4 2/5] iommu: Add domain_alloc_identity()
Thread-Topic: [PATCH v4 2/5] iommu: Add domain_alloc_identity()
Thread-Index: AQHbqKRbtnAVs25jYU6Ab5iH4zpAHbOcZsyw
Date: Thu, 10 Apr 2025 05:48:28 +0000
Message-ID: <BN9PR11MB52760730D50D91E0746A6D158CB72@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v4-ff5fb6b03bd1+288-iommu_virtio_domains_jgg@nvidia.com>
 <2-v4-ff5fb6b03bd1+288-iommu_virtio_domains_jgg@nvidia.com>
In-Reply-To: <2-v4-ff5fb6b03bd1+288-iommu_virtio_domains_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|BN9PR11MB5291:EE_
x-ms-office365-filtering-correlation-id: 034b5d31-f7d7-43a4-5fcf-08dd77f3517f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?H9SvVMpQxl2mspiT0O2TJ1IN3bzXiZchqcZOkw2SLtWIwt2H0w3cu2bCjQTk?=
 =?us-ascii?Q?7uOhkKxNVWCR1SaoMEkwmMTNwr8iILYjF/nJdPoxU6M9k6Q8u/Jlmey721WU?=
 =?us-ascii?Q?506it3P/O5wqUsJScHePxifbaY3Xjawh7cV1hWQ2j2Zh+KCTsRqS2zNYdDgA?=
 =?us-ascii?Q?Q9oiPyJMU5nJ8Lf63UDIVaB3ZnJB7LKmjHCzoMhDkyoUln1dv5zxNhzWRb5L?=
 =?us-ascii?Q?8Ng/dKpqQKRhIibTAhrzzQadwwZpNRaCFIe5B2DqyrFgdE3FysWZo7WVQa5l?=
 =?us-ascii?Q?ZIIDkUZ+DO2yvdtdpS0cgpDEAqWFqhbtuheyr9D/8ZboaK6P+oRu8rojUXSQ?=
 =?us-ascii?Q?3BZwWKRukMKyPoVpbPV1vuZSeZYceSdFpblwHVsi3tWhjWZBds/jPtURPpmt?=
 =?us-ascii?Q?Wdu88vHAwl05wEcQjpHWTYztpIaCGdaajnDcpB7XycpS3HTfpP8VZatZ7XzY?=
 =?us-ascii?Q?wph11XyVurlmz+V9wT8ClPqqCEOHkLtNyR9rvbpoOUQ7wbjJmQ5mf0niJx0j?=
 =?us-ascii?Q?3OoZxINzhs/g+tqiTh6qNYyzgQyzrD4wklkYzHlu+5Qe4xdAGMdb6YyQsEiO?=
 =?us-ascii?Q?1pBXP3inLB3PT7Cj7CWKGnAadNbSHoI65nfTBtew+fVk8fmnzRafb2TVV7Bl?=
 =?us-ascii?Q?MfGtJRPJZuZQ6hdLd6qwGpM8Pf1x4Hm1WjTcGgbUO8NpcOFphsq8XUbNBUkZ?=
 =?us-ascii?Q?5oTxbLJXEorpKFBNxz0I+Q6tUqtVXU2gdk/07edX0FVDBtN2PhrPIfKot6P9?=
 =?us-ascii?Q?RLysAlYf/FDUm54CwnNgGWacjCdWjCn0f27G1nCVZs/tRH60vwmxaTFALORy?=
 =?us-ascii?Q?RKIKrt8umD7oudNsOBkUMVGdi86wlbcYjnbbKxGVaXUxXoG0NYtf+KrU6ozR?=
 =?us-ascii?Q?3JFniHL9wXp9AI0QDo7l8BX0JKvawJrv58QFor70KVj+A3iuJBX3YUd4BqpC?=
 =?us-ascii?Q?O82/8ZhctqoPLi6RnDhV33KLF+7GGPif1TmunWO7soty8J+ZAwWva8xkuCyx?=
 =?us-ascii?Q?KGRHqyQFIp003OSlKmc16wHJaoEWuRVLU9/KqjuXdEa7qMa1quAa11LnE/QV?=
 =?us-ascii?Q?F5Q3NdlpfJSN94Yly+aIfputYGWdgK8Ty8vgdZ5ole0z6GFDxrcJFpbgXHH0?=
 =?us-ascii?Q?W+bwDZD8qVYoHpY3owCc81H2tWeKhAGMt4I2YLapVoAJWFBDMNQ3IQNULVNT?=
 =?us-ascii?Q?t7aV2dC+FJ3L/je+Qg2E0UjXOXOM64gr2OUtxlPEKdlIOmaPs0lTQ8MuJ8wY?=
 =?us-ascii?Q?OIKgCQhXHIXBlVnTjKBGTS9KI8rAS/yOlBc5sD2t4lCWBvPFQp1uhKBIZxjO?=
 =?us-ascii?Q?wET2K4g+RuiTTNVEAN71suWPRUbMejriw6osEr5G8W0FQdRYg1LT0qj8QQId?=
 =?us-ascii?Q?VZxaLNg5ziCuLjsiTm94CN0G5x9CEm+Ghpf5LMhWoRsyxhowkT2Ro/N03xsO?=
 =?us-ascii?Q?PpFBCoVKkJhslwdvKI35fIUgY62v+mCF?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Qhqrsw93jQTtUrn1N7gUt4Hyzl0sGH4BiK9A1SVmyh5aaV4qxCX3DxZ+3P0n?=
 =?us-ascii?Q?t7aOO2fYN1x8l0sFAr+uTGBqD/7169nIJe+ewD3FpRxX+SQP8O3ChQbCIZcf?=
 =?us-ascii?Q?biZZOBwAxQqSk9K98ty+kRHB/k3WExJamajX0CpMhJQ5RuQU6ByN0TJ2acyo?=
 =?us-ascii?Q?ptTHSiZDTC0G9YlWxCccZY6f1MMCmuie5AV9ZjHlHAwdw2Vf7kFoHiFDlRbM?=
 =?us-ascii?Q?1kcwpUDb30RTef5aNoPNlbGcLt843ioqAtUZJYNeaiR18u7QxD8lDgY0jSOK?=
 =?us-ascii?Q?C6T6jDTI5ItLYur0tZ0aT4up//BXjRmsYUhuDuysQeULH9GeELJHlxX6mqr8?=
 =?us-ascii?Q?sSydrqCI+P7LtuWaqfhBFZHueKw7ZKD8VfAct7s88XHiq/xxrAHPK07yD2CO?=
 =?us-ascii?Q?8JJf9u7aJpGTQjdNjaI4rUWO6wEd1kD+kuLgbMqhSFJriwEGrCYYRNnzBx8s?=
 =?us-ascii?Q?Cedp7f5BujmZnAbP91Vs5F7nuda2hBzjtbtPodR0XK7eDgyfBb2QCqpRZzcX?=
 =?us-ascii?Q?wHy5XrowcLxJlMT/5zXVvHgkQOnN3qjmmX65xow0/GMitEoWnrjSpah9mY4d?=
 =?us-ascii?Q?e0atzL1MXe63Ur4WX6WTNhhr+bGtWyCwKftmx0YMY5GgbAz6/lKEo92cSQ6Q?=
 =?us-ascii?Q?0J0ucAP1kf8IYdGf4GaUgeEzYZWgQE4pYtn1ROzXDTo+iCFBsjpmn+pcNRbe?=
 =?us-ascii?Q?akVCx5tM6gya72e8IHifPPizheBis4znYTZLaDpIhjVDDbdKht9BBkLaeOfV?=
 =?us-ascii?Q?Xpc4E0Redi+d1vyPgOhXB64rsXyVPsoQhLVI7Pn632YMM09SC6i8GY8IbK/f?=
 =?us-ascii?Q?EpqUGeGLsle2mJGKsJzQJSKOn9HmE6hczXtsUvMdPeff2OuDSlvDMQiNKDPE?=
 =?us-ascii?Q?5+z2nvM0HgLIO4rAmVpoDHwXZqkxyMk/DjYz+9AZmA/gUD4KOdSSfxurZKRm?=
 =?us-ascii?Q?HSY25APX2NMxV5Fg5ZZhLBO2xKOfDwnnnqB2eXxYedQ9u/QjRxfhbJxXIb1P?=
 =?us-ascii?Q?wDBFarYTzXgKrLtQZBZJ9tpRnKXceVKBDqR6jpdOlzkZTBzS/iWC+8oogN1E?=
 =?us-ascii?Q?+dX+kvA4CRyWThuHjI+BFYgaYU/gpXCmBEr4JDUswipjPQ+nhjT0Gn5HZ0y7?=
 =?us-ascii?Q?yekv/BFB6TuKP92XruC1NzlMplaDUN1IzOhayO/hfkCDL8qCjVziZqgIA5tF?=
 =?us-ascii?Q?rvKOHOp+C3cf9bXWEuBBudSSPHqZ+f/hx5xrbeg6lJgeZZT6gorTtWhUA3D1?=
 =?us-ascii?Q?X6A7ZadgRkJPz2f83fxmhlW7LwfmC+vwX2GVJ7S17NSh8UWTZ5U3cMQeXYzg?=
 =?us-ascii?Q?5DXa18MYyb5djfWY3eOGnrhcc1t/9kK9qJN3lGvvDT+5W6fMrekESftlOzyk?=
 =?us-ascii?Q?TtRBKn4MCZy11Cq5dp2ND0aZxc+6Op+Ftq42BiSua3UjphMqIs7ld7HWHGsj?=
 =?us-ascii?Q?eW02na0cvqAxkGotxQ8tXI6o7dhhWfJ2MovtMnyadUAUaxO9ZmD8rglqg30/?=
 =?us-ascii?Q?k56s1q+Fm/gzAlkb5qj7e6u1CPHMBTsewDpzSbIN+ZmkRell903l4HZoZhr5?=
 =?us-ascii?Q?RB0SqlhyGkypWZhpPLSG0TvfcRQy3Vz46DTNopRW?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 034b5d31-f7d7-43a4-5fcf-08dd77f3517f
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Apr 2025 05:48:28.3954
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0LzYy8/ILhf9IuxaCfrv6foMhvN3WPARUppsWDutyOI02zTDw9/rzfBwYqLiui3/TH+8Ikpn5m0KNIMm8Mmjqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5291
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, April 9, 2025 12:36 AM
>=20
> + * @domain_alloc_identity: allocate an IDENTITY domain. Drivers should
> prefer to
> + *                         use identity_domain instead. This should only=
 be used
> + *                         if dynamic logic is necessary.

it's probably clearer to expand what dynamic logic means based on
the commit msg.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
