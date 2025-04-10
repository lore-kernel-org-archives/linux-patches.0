Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 362991C3BEB;
	Thu, 10 Apr 2025 05:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744264698; cv=fail; b=QtpEWS9/zWZAV4tSWdGN+XR4IfQFMByNTpWglOuPffGQvpRbtRr1FZkSlezYNCgDclvUV8x6YSZDISS6a2V4CzjJC6kl5l+Yu26G3dq078RDEW0UBNmQzaxgcZhM2wuo3aewpWnf0UYKdqoycSEjIhYSMzvotpxAN8H8GC0CE4o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744264698; c=relaxed/simple;
	bh=+oxPIYqToeLLCeRhsxlIKd7svYwT9asV5wFxLUu99T4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nYd0jss9P1RIIZYeXqin6Jp8MNkKC+vi/s9VPtYE0dfVcSymtK4X80BdpkPxOcdqec6zrCE8wE9KIJZmPGx/zNDXMEaj89QnReGv5i0m8Xsm0porWJt0SImQhvA2qoZ/Qe5lZ/zOxKybTmMwX1ajSGY8+RWg+kh3aZk9SY9InKE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cao1hYzP; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cao1hYzP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744264698; x=1775800698;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+oxPIYqToeLLCeRhsxlIKd7svYwT9asV5wFxLUu99T4=;
  b=cao1hYzPDy64jLqxvQd1lA65k0CFmbwTyoc8I3Wm59XVC+VjprGxfYrx
   rtd7UHjW6J7xor87Ae+FZPXyy1+d1k16+/8HRGQG8bqUy5XV5nu1g4O7q
   El4BtBdcdH3rqqw4j3TJTIiDsST5pA6OuD9G/33mhY9CtmzBsSFOj2yQr
   QAdOkg9Qg2juZ3iqcBo7sHoLHXaKz9dINrNE09+AkFRpspoWr8x6pmw9V
   9ZfKKS4YaU0D4MROkvlLxlljl+/B3qBKTEFfHRx0mz/DV0oyNjM2/9p2J
   U/oaO6cTNQ17gSH05sgdeF7UC/uDpAgKk5LvuqpwTo3kJ0Z1FvLjrYx2w
   w==;
X-CSE-ConnectionGUID: 1HihzkpCS76kuwCZpFcl+A==
X-CSE-MsgGUID: yDEYCPNZQJqS4kbgWZnATg==
X-IronPort-AV: E=McAfee;i="6700,10204,11399"; a="45932571"
X-IronPort-AV: E=Sophos;i="6.15,202,1739865600"; 
   d="scan'208";a="45932571"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2025 22:58:17 -0700
X-CSE-ConnectionGUID: ZqmDfGM7SN6VoTwAqXyV+w==
X-CSE-MsgGUID: XqhimFEyS6qAajCt6HRkTQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,202,1739865600"; 
   d="scan'208";a="132933266"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2025 22:58:16 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 9 Apr 2025 22:58:15 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 9 Apr 2025 22:58:15 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.172)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 9 Apr 2025 22:58:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X7LzHPzZ2z64VadW+TnEmHMIjxzazcSqvd4NXzbYHqdqDXR6/5cbAUIrpeOtF0nFiOGZ0BR53xUddf4rx7DFJabt+7wUJRPLFjA6H43JTg1OXYtlV85ilh6USyuHCkVSgFsRxx/Q+xNhGp1dKlkIqZm/UE9cieyCE9dkwjLzeN/+9DeBMKCwt6iJ6oI4RmpWLMs6oAzU/p4JvBR5tcRqgOz/92persrG5OdZ1PTfdVT8fTBjqiBB2hMgf+VGg3Jo0Zli1CH3eAAckmxbU+2jU8FvW7SMmNqTuDCFGZ1/WBjm1jtqUSwKFhkJQgVzSIvnCqRHW3Ej72dGMzLhAnyjgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fw6uDAodsMheNHQ4o3ZwVFlZ67fNEF0rqEok7STqIfE=;
 b=Mta2v8NDHAMEEhcc8lK0NQ0tBWoTWEX+n5nYZy51XVKQzSSJJi/hDV9KjkTlLRH4Xx0RAbyRM4/IwbY6LDdaioShejHKuNMfsSL4mpgXkIFo5AEmEu+G+XY8BmFkPi1yUCV4Lu1jlnXwvZyZkZ2+FcUX1d8qxPUr+gvTK81Tn8AG7dKN7wSGqpXTQ84zEJym8bmDMCNzDdkWwl5TsTMcZfcd7+THaczavpCQTIJaeFRzsrHvVZd7xXfzqJQHRnEbYMejqv7T+tF/4su30hR/EDL3skeh+k2la1udVPASCeK0NsCpQPhPI3LcCkRdb3vV5bWjE3Yl+GlIgcXGaxRtLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MW4PR11MB6690.namprd11.prod.outlook.com (2603:10b6:303:1e8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.34; Thu, 10 Apr
 2025 05:57:44 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.8606.033; Thu, 10 Apr 2025
 05:57:44 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>, Robin Murphy
	<robin.murphy@arm.com>, "virtualization@lists.linux.dev"
	<virtualization@lists.linux.dev>, Will Deacon <will@kernel.org>
CC: Lu Baolu <baolu.lu@linux.intel.com>, Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
Subject: RE: [PATCH v4 5/5] iommu: Hide ops.domain_alloc behind
 CONFIG_FSL_PAMU
Thread-Topic: [PATCH v4 5/5] iommu: Hide ops.domain_alloc behind
 CONFIG_FSL_PAMU
Thread-Index: AQHbqKReZMZjQ9FQo0qycmMpY4Nqf7OcaVkA
Date: Thu, 10 Apr 2025 05:57:44 +0000
Message-ID: <BN9PR11MB5276B54CE7C5BC8E4CDE986D8CB72@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v4-ff5fb6b03bd1+288-iommu_virtio_domains_jgg@nvidia.com>
 <5-v4-ff5fb6b03bd1+288-iommu_virtio_domains_jgg@nvidia.com>
In-Reply-To: <5-v4-ff5fb6b03bd1+288-iommu_virtio_domains_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|MW4PR11MB6690:EE_
x-ms-office365-filtering-correlation-id: 6733a919-3074-4ad7-5145-08dd77f49d19
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?LmLnX+FrzRwq7R0gDfMusD3h6zKHl+0oeMd1+xbEtcc98hULMLXa0gY+3g0V?=
 =?us-ascii?Q?MaDR7S+45eEGoKqxSuCCszQh5fgCQmipMSesI7BwfRicjh22qDb9N1h7idQ+?=
 =?us-ascii?Q?Ti94Twb7tFHftgtEnW/KAzAC/xPSDWc1K1cEb8nNsjiCYRkS9kaoWIzF2Cgi?=
 =?us-ascii?Q?oaJfwbd5p54nIIs2v68n7sYHX8jgATuTqB5RBmIDT4uqRg8/JtI5LKKEMy0O?=
 =?us-ascii?Q?lLslgJMGVDZxD9HO+g41QCtU1or6nukzqUyoAJ5z5byMR12v5K71VTW1GDiH?=
 =?us-ascii?Q?NE/kEfINZAedXM3uNdI/qPmg8cmAobO6bGqJGhXRn9o4n0zAcuN9OpXsKgtP?=
 =?us-ascii?Q?HR20RvdkxUd1wXG5VWvVtDW7g3/X4LHRBxRW7lgcRGkr1BiAVF+oxPRvGGav?=
 =?us-ascii?Q?bttuCD/QWdazdZBUDZLx587Hj4Ii1UHCGGBb2r9Bj+2ZJIWh6UUe3p1zi8zU?=
 =?us-ascii?Q?F+9rFcK9VylVFplg6CzxS9X0g3Jvlbn/CL/seQEsRJ6DodCa4SBPmBQf0yV5?=
 =?us-ascii?Q?k4aVYy/jM7wNp5vA3PPGazrs0uP7PW4OZoTj7mUqbCpsz3bMWX9HB7EcTTxk?=
 =?us-ascii?Q?AcoUOxUvWlThPvWBWAGT+RXmE5hg7/0lEvSJFeABVDbnOYCgHmVEblb2w0tN?=
 =?us-ascii?Q?3PV3pmmJqCF695qCm4khNQ+QUcFUFlcC44Cem6WZ3OEappmk2Cm4KyEZsvmx?=
 =?us-ascii?Q?oTxgZtt8Lh4ND1300u3Jhsk6cwlYJsQUdQkmUuFg1GY4+ciZP2eJsTcrbGY6?=
 =?us-ascii?Q?LFKgrihLOZX4f+319PvshOqChn+4Plr/AUdlXm8E/aAsbE12SAc8+o523RN7?=
 =?us-ascii?Q?tF1/zOO56FKPz1aG61+LCEFvrm5INBEVxnAFxmmFBxgzV6HtiS87zBFrSEgr?=
 =?us-ascii?Q?2lMEAo/2TuhXBRp7bYjUx8cZvg1Rcml5nRsGAZEvOTK0Zi03QUcr/dZDYPl+?=
 =?us-ascii?Q?Vu4QJKcq7KJlL3iT2GEh7loU5ZMFAR6MBsHG3y++yWxDhgp/WHzaHBIfFGqt?=
 =?us-ascii?Q?hiXOg3Ufu2ML8lArrdXCFaEd4SffkmC0KfCbz6XCWpH+sOVh2n2UccMKrW6Y?=
 =?us-ascii?Q?k0PAXXEkK9WqbJXuEHbbIzSMn1SR6kRY6DEs1MgkGWn+FuXQOi2/1qy8WJvc?=
 =?us-ascii?Q?LtaUEyOJWd/ic9FWUyLBTBCP55VsagPWsSMf6E0jwIuABQC0OugqqU+CB/gh?=
 =?us-ascii?Q?X60qWDyF7psSYRv5AcVl0GkhZNVZz/jdKzIMmdMtHe0FKlz0aNw49MLfADXQ?=
 =?us-ascii?Q?w8wp2OhFmsym4g5eHmvsQyUU40kwCh1wlycoWmguFDAbqhTEj3QWk4DiGCke?=
 =?us-ascii?Q?7GbtPHJzLLZi4s0SbqNgYNMYEQhAuFpI80CQ6Wf9xdG+liCLYBbzEhndUvvf?=
 =?us-ascii?Q?z+JKiTjGjaYng4bxlwYZPSRju8qG1sw0NCJ5XPQzzT6ZUtrqokzNBCrhpm3U?=
 =?us-ascii?Q?/TvxMZe0dFTJMsYWv19/WCfQ4HPTvgKW?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?5oqOThDOoREmgbOZ501/vEjjuH7HG0YIs+3dj/gwdBzIoOpG7703+mmEpGs8?=
 =?us-ascii?Q?2RzH1EsPoKu78kXYpaTWyIHuI7cwDNT5Q11730i3a8euYicvIJHu9Ts7dPGB?=
 =?us-ascii?Q?kilDzeTEYBq/I6IEe4LVG6IlZGJVFBzRk63Qbjs/jJzHYuDwml8cZ9sKU8g1?=
 =?us-ascii?Q?HjB15b7QtUwgIKdOzb9DWZoWzdlcQ6ETS+ZmlsnMN7WMDLjHh7j+/RuI00pV?=
 =?us-ascii?Q?7OYPEfRnat+it1KGCoX05ivWrw0nQ7fVWJnLxf4kncKCnSm3e+wz19F5e1yb?=
 =?us-ascii?Q?sjI5AZ2069pL8WmIq/y/gdw07BXt4dnZavsOSUJOPLFtCaVvQzBnzguRsTgy?=
 =?us-ascii?Q?EvoUn8v/bkQ4UEdssiJcnA8G7L9vv0btrg4W0N8f+TYW6f1Ua/42o0Aj7JR2?=
 =?us-ascii?Q?7hFhMbJ5GPlie5LStbN0yaPc704lnYsdlLHbgqYmnPy7jL4pmF15+Vpp2k+u?=
 =?us-ascii?Q?vg6VTyx7rCVEb2CuAIT+SF0j9hAZI827a2aQZ6KscccDFXHB8byPCn3SYBPv?=
 =?us-ascii?Q?ZGz0Rab7SK/0PFZaR3IcYe/41VPNk+J3t2sSmgy1pqNalN2WM+zFV9gJIse1?=
 =?us-ascii?Q?xLd/sTTuwU+XM/VGvcyOb9WgD52T+NsT4V+5ezrtoGpnRP0bEeUqZgxnLZnq?=
 =?us-ascii?Q?yT1QjglGJuUatQSqr6mOdvUf3JhmMpIPJc1WIyQlHSD31OAJF4vam5zkVGsb?=
 =?us-ascii?Q?IXX23TiKufkicyIXG1TO6TYUQ/wjwsjD9dWw8IeWIwkTtKaIeaZJHvQn0+oa?=
 =?us-ascii?Q?tH+JeZx08Pu6XREI0GdYkIqAWij0tPS38a1iQareJnmJMuTs4XTtRHF6yjeE?=
 =?us-ascii?Q?JJJ5khyxSRMht4nyGljl/Lluj+g8o0Sipmrrx7sD+5pEXwfAeH8xC5e0l18Y?=
 =?us-ascii?Q?D4zjmDOz09cEs1UusRZZFtG4avzfiTFCzbk9pkMEqlv8F8TrLcUuLo5i0Q+U?=
 =?us-ascii?Q?s3WE6jed5OOycogkZgE45eSHPVvehtDbpxUID7yyZScn3GKlJ1QGJbPbwpO8?=
 =?us-ascii?Q?kmTtoYNo358lNh+aAlraWStNMXmzkDl70SvF+GqnHUHLIalxTVP/bgqqqOyU?=
 =?us-ascii?Q?lmZE8bd4bQWNiBYdUguMBqJSOlfsY4CdKVTkfb5y9DgHooUItI+ODWNJIw2+?=
 =?us-ascii?Q?+qmtRs2DJGF/kp3ManA/M6A8azsYNm+SSUtVAkYYXONTIrNe39ozmI9+BO6Y?=
 =?us-ascii?Q?zDMvrWebRxaClp2RzjR4deqotooIG4AGj6sl+rPzsRQqr3Ymffws6aXRL/kM?=
 =?us-ascii?Q?/sDLTehIVaVdzq9/SAm6LpwNTWuYSOTiwsdQxj6WzSD42MeLINAkKALzc7cr?=
 =?us-ascii?Q?HxsBFRMhoMQqh96ZrvHYGGEOSlG/X22vCgU/Zd0vVRv+YFmSvBbDnjZCINy/?=
 =?us-ascii?Q?t6zGysV7EGll3+Mx9VIm8Fq8LCA2g5/BWoQOoLibfVO6YTfvKaqnhIH1QXRf?=
 =?us-ascii?Q?B3XFe2FxCn/W5sE6pKFf0YjE8PZX6ALRiM04m/BeyePty2BLVF1ZYwRlkioI?=
 =?us-ascii?Q?8qeHI+bCR7DsQmGU7htXnpuU+X3sQ+BGUJbuZKWLHQ+L+rtuuhuTXRMpVMY5?=
 =?us-ascii?Q?c3lPrW8I45ndfjsZFDugDG9OP5Z43H+QH2KUFTcV?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 6733a919-3074-4ad7-5145-08dd77f49d19
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Apr 2025 05:57:44.7606
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: d3ulonK4SizuRkiDXxQAWs15WuMkHo2DZscI+frpxHTLh5kODSa6JjTFL8BuFI5n7Z6me3zNnme6rObCg8VG8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6690
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, April 9, 2025 12:36 AM
>=20
> +#if IS_ENABLED(CONFIG_FSL_PAMU)
>  	struct iommu_domain *(*domain_alloc)(unsigned
> iommu_domain_type);
> +#endif

what about directly calling it as domain_alloc_fsl(), given no
more drivers can support it?

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
