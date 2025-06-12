Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E6F822154A;
	Thu, 12 Jun 2025 08:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749716598; cv=fail; b=bJ4DUhywgzdJ7yHYSUDbz+lRT7Wcbo8F9OIfia2GJAnLQMJvIIn9lWwa4jvAasqSwmjf7VV+/6lu2MdxgBPK629Oj8bqWRyoIa/PPAOqK9npLXvgQh+CkD4uop2INK/ZFUr9rFuceSxUuktx+QkwgCjN3HyGiuOvrH+VeTomKDU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749716598; c=relaxed/simple;
	bh=rIawwNUAEQwedeogY0neyD40FVtrq/DGgteJUiYeAe0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Da//yuQQfwKdC5uUt0bB9OVIJMeRPoEqKN1DqMG3w9PT9v5ssf5gziiYY1pfJSG8sGkSm+gRDwxUGhHVM0fTAXZTGCpdAMZeYeeDULBmVTy5fi449uEAJWKOMMSDYXDRg2TCHwV2nhfRHkryOeERTHIAOlSUktu85TNHeCKDhZY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=c0TLu9Rw; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="c0TLu9Rw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749716597; x=1781252597;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rIawwNUAEQwedeogY0neyD40FVtrq/DGgteJUiYeAe0=;
  b=c0TLu9RwoB3Yhofjwz6MeRsjCPfhU8rt2OOmokQVJZ7RqFktculFeVg9
   n+dmBmHWReNuaPZPAbv5aBEJskpTWRzsMdXzY4Usbn1Jw9TsQizTE8wY+
   U452zNdtQve6t8Iy1pDsCn+566YkrP8+mkgFKTcOA3h/JAf4fIxrr1/Fk
   zEwTuYQSZsqGJskJkW0cyIXkIOfuLX/Wg67Rif05KksiMTTakXQ15BUn0
   xNduHT4vlHl+H4YRGeORQ9w5Tz+k7R01zhEr4hFvKh4pU/o7X2uDXM/1t
   aBCfZ1yE4AD01cPYC23pttDKhLjuEohR/krT8wWaOpNmlZWgg+0j5Lr4y
   w==;
X-CSE-ConnectionGUID: NiGu2N1+Q+GyBfo7wScJcg==
X-CSE-MsgGUID: nowZOxzRQU+m+U2xN3KaeQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11461"; a="51754657"
X-IronPort-AV: E=Sophos;i="6.16,230,1744095600"; 
   d="scan'208";a="51754657"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 01:23:17 -0700
X-CSE-ConnectionGUID: EYz4KTgmSz2Tr+Mnr9W/TA==
X-CSE-MsgGUID: r+hswQHmTuuM5F9EDSDkzw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,230,1744095600"; 
   d="scan'208";a="147337347"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 01:23:15 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 12 Jun 2025 01:23:15 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 12 Jun 2025 01:23:15 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.55) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 12 Jun 2025 01:23:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VKdZPhN9g6rcckERbJNyVimdLIUO3EJt3fwc2tqeAt6XnLUsrjBhXjAPgbgvBTK/joPmhYBbh00rdCppqx8GY/rDMfYPKloUgHIlCFW/tK15FV2sYmowE48qFWhUQJpXjo/QIJ6tyxHOTmbkZAzgqx26kecADaNNZ2+Mtkuef7uH9wlvzKL6UfYKoUfehlPWnE1QJ811xsF6oDz+cK81SJDg9BLQ5TcQaFKAh31wDD4uccZHvFx1/HmaxLsA9xcdMH7sym1+BV2KW3UEh3ZLhWG3Wm9cA/Wi8PFeR5X3NI9waqAreSys4TTm/RQd9o2sQNG1Az7X4iWjvJuAs4e0ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rIawwNUAEQwedeogY0neyD40FVtrq/DGgteJUiYeAe0=;
 b=yAswVIL1beVe7t0AzPJ7/o3tmnt1cbBh+sdQLQlohizrih3wMjY7aOZVbphXjGy1kSm72+gFjQaaaDWuQ/+RWtjQJ678Z294AfwSOnk80Xoc89jzT/MvmmI9CK6hR9aEU64FuWbfDL3NxMn4106+Ze+8TKeR/ObwnW3+6uXFK3rOmUavk1NgbaWjLFAWxVcwBoYIaAv+v6io+X+1pv4uiLNK5laV4QoGkTljNOm/eS0pGDKBa3Y9kCUtNrUXAB5xf+QFE4E7QeVU4wJhjKkNxvKZqNC1jHiHbuNfLhiWtiOQEZ1ZY40btAxpT6yhhDm07dFJA1DxBasIfZaj/D6cHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MW3PR11MB4572.namprd11.prod.outlook.com (2603:10b6:303:5e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.18; Thu, 12 Jun
 2025 08:23:12 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%4]) with mapi id 15.20.8835.018; Thu, 12 Jun 2025
 08:23:12 +0000
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
Subject: RE: [PATCH v1 09/12] iommu: Deprecate viommu_alloc op
Thread-Topic: [PATCH v1 09/12] iommu: Deprecate viommu_alloc op
Thread-Index: AQHb2WIC6kBhYschC02A3o0IFdkJhbP/M6Aw
Date: Thu, 12 Jun 2025 08:23:11 +0000
Message-ID: <BN9PR11MB5276140A5031535B3CA4A5838C74A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <cover.1749488870.git.nicolinc@nvidia.com>
 <7f5ee636500d42895915334f7215c06170db81d4.1749488870.git.nicolinc@nvidia.com>
In-Reply-To: <7f5ee636500d42895915334f7215c06170db81d4.1749488870.git.nicolinc@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|MW3PR11MB4572:EE_
x-ms-office365-filtering-correlation-id: f2baa0e3-98e1-48bb-b438-08dda98a5efb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?QJRREYTO027KRysQvhBPobKX1Hem4rUecKDwZpz9IlvcS5luAbHPjMq8p1hl?=
 =?us-ascii?Q?lKCFrmFU8vwxu8gtvEgx473ezXWanhmcQKvUtsw6Dp4cnfkLsadQriNVgJ3p?=
 =?us-ascii?Q?QKSMnp1hZtzdeIW0jOP1kh0nOkvUDSATci51/L2trGhwyAucJM1IdECLa4sC?=
 =?us-ascii?Q?yKbjZlf+Pj6d7v0bNb+bOM+BQ/Xqn6VIFM4mQhCnDvzmoV7Rbfy+pyAtHlaJ?=
 =?us-ascii?Q?dZY51QojhQJ1ebD8+IXxsBL8ixJli7lGHGk4gUdD81WPR8keQ3v4W57yEBUo?=
 =?us-ascii?Q?RG8+HzRJxFyXqFTCHJiLa0UDJSZqoFxAeedDcj3QKfHtMEysjP7dee+g5zt5?=
 =?us-ascii?Q?ql/XzbfKAU89T9oMRHrEFfH3i+y9GrDFt8NnQyGikBHr+gtM5AggwpN44xlH?=
 =?us-ascii?Q?d8nFIMl28W98/7rMTNsHa/IknbVwS76ItHzNXKdJPTa3N3YHxTyQdJWLrjP3?=
 =?us-ascii?Q?G+eIkpGqvzwXYm4MjYywVAEEGQ4TMUGDyzmcWA6OrX2pGBW/8WEUQGkemZYx?=
 =?us-ascii?Q?+YGQ9nC/oOGZctupMbx1veVdvix/YDc1Krfcl/FxPddune70hO9UOVfD4Jly?=
 =?us-ascii?Q?FCuZMjKLL5cN4IjnKBzSbOx6pU54FU25JFyIScq80Vy2xT56hYs7xqRMFMqM?=
 =?us-ascii?Q?EEr30dDUlNwHeWcEoEGhw9yLsoOSV+VhS4eG8c9vOw0K4B0oVZ00vWwslhPl?=
 =?us-ascii?Q?zQdLQnOfGKsLdHJJpxnMyfNDvWHA0yv4fvE4fNC6aYov8G7xp77e8MvRghnv?=
 =?us-ascii?Q?7mnUI5SHRiQ9kxiINmvYoKV89OmN9QeBItd8W7XLKd02SDIcXqunJm2+DsLq?=
 =?us-ascii?Q?nlqEPkSgNfro3HmPmLbpl6V9qkQWJ6ykltH/31VUFsbBfvvNOTncxnqi68YF?=
 =?us-ascii?Q?APvPIwJULmVHEpsA2HPKVsAXB4LrAW7oXPYjBd/+WOtYw33E6ac85jh6qv5T?=
 =?us-ascii?Q?0pie6Fs6rR81ljp0YuOXtkPpUy5Tgae18PoiHzy0k26X6gkMcK1dn3A+6V+b?=
 =?us-ascii?Q?GUG699482gTtPX049Tcn77z1kI2kkduXGcBaeyFhePoNXRrWBn6sgsXNx9fk?=
 =?us-ascii?Q?0dKWAXoRdTlIdi2I9biWNFuFejREP/I0ujWXxDTzgvsJYg6og5yKq2VxHIda?=
 =?us-ascii?Q?GcdtJb5VURXUe5ulq/2lOKC2d3if5nWuslf7dyeiqlexkuvR3W5fW+Q6+t2f?=
 =?us-ascii?Q?FxSvDJMISCGpHIRIe8uP7lriceMZlQL9a8PZw0PyzpkxuOiFMhg2+XcLCF58?=
 =?us-ascii?Q?vN5eZ9zhZGRq7+O9RcDHIJQFrB1nrK8rCuBdQy0B0goI2qliw1aGzYb29kpo?=
 =?us-ascii?Q?kYoEhWze1BEWrroiS7IOYqq6i4WjFvsAf/VAe8JS5iJ1JrfI3/YFrVLsw4i9?=
 =?us-ascii?Q?yf0c2E1OnWxBsBAOb6aSrmh1CGqZfl8Q9HVjJdnLsFRPto/1ax1Jsd9ONalk?=
 =?us-ascii?Q?YgbEgyGWsCvlIa0LrAwNumdu/pQweahH0usEwdE2nQwgtKA7FxXO1Q=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?AMf4Vcj8s5l0F62r81AJFD5FVTHKNtBDKrQCk/lZmKd8MUxARjXp2eg0wrfZ?=
 =?us-ascii?Q?HIzc+o+XQB0/oXtwPriS12a8CQBJmIgFXZPuiXQsJRrR51eRiSlpN4kI9FV6?=
 =?us-ascii?Q?BvmW2mehlcBi1Ak7mfsrb3UsAydZxZ9NJlsRTIIyYMiDdBaM9P1VgTyWqazQ?=
 =?us-ascii?Q?A1sv4n8PEIY/M+aBE19llc8GgOhPJW9lSUxwG8NJBu3DwUQ1hB1tHk2RxQm5?=
 =?us-ascii?Q?qYQQH7PuYq+DTA6GWinveZR8Rsb9qQVp+Eq78GN1P1Za84F+G8+ASs3pawm5?=
 =?us-ascii?Q?ERAqr/SEGeKpiM29PDChY52FeHd4x+S9G7BJz6HaPVCCGCN/gBuB/coT9sBv?=
 =?us-ascii?Q?h5UBnS7dmRdXf3Twc8VnGwh0S0yrYZ1VCh2Mwv1ZsPqgwlCj5a8zBN99x1jJ?=
 =?us-ascii?Q?s0LFhgaV8+eBPqHbeoN8Vc6tzgCyfdCZ83vVRwSCAqI2tpsgvclAco113At0?=
 =?us-ascii?Q?GzD0jeeqELSKjj1V2SCqyT112wGfMwdaPTW+tb4qcmGQfbQWWoT9HzbJBPzl?=
 =?us-ascii?Q?VSHIhb7q0wclwUMrR+/N6SNQT8VAE1c2CXBa2AhuuGs6vJw3ivXebpMZ+ASV?=
 =?us-ascii?Q?r2MEKRMASfo/agve1QRwN67RVUXnAQ6/aOs6JREmUeJ/Rg8cU66sfgDkjNmt?=
 =?us-ascii?Q?IPOXm3g1BvwvMR3PDFJfQzw0zCdznbWnLeM96tqLyiHQgahbl+yTPPu4AZ6o?=
 =?us-ascii?Q?SC5pFNqDEaRROu55lGnQyAe8S/eTugsR+GEnAzsLAvh4vEEkhyuBOnfXPdHg?=
 =?us-ascii?Q?0sdNJTlzM0NnlqywkUFevRazF0seEcFDlrbcfUjaoS2mQ5LaB3ULhYWoRhTC?=
 =?us-ascii?Q?hegRdcqL/yZuP75JBw1OqBQ11DrdmvVkpHy1WgH2NHqzjidCwpMCSciPAcP9?=
 =?us-ascii?Q?p0TCBAU0Zepk/g863e1+o3adCOgDmiXjY+O7/aCJUk59gk4G5K9XpY28AkDa?=
 =?us-ascii?Q?MQzn0331mMB+pNki6NM2mBawnwhWKs/5p92CXzXx6gG0z22cLYRe4+FLs5us?=
 =?us-ascii?Q?ldWOPpMbkPVX6gOKNInTN38QVdIHKwKtm8dSmGJ95BYIXeXHuCmib0FmjwYI?=
 =?us-ascii?Q?5YDrq95SFGrk4XjggpCAtm52DBynMv/Jf4LfnsVPQdochxkmf3hcxY5iWd5I?=
 =?us-ascii?Q?6R4QyRxWIH6Ht4vVnms3do8nMEpHvajSU3ocljm93jkNTfy0drOoPkMP+1cm?=
 =?us-ascii?Q?/BjmMk4ZMwZ6jIjpjc8qxUAiW9hUwu9ccfNuuuciHU1FFnK0CilAByzOU6yW?=
 =?us-ascii?Q?5d9c4yGn9m+wTEDrBFuMzDQVwLSk5KUgRhoj3Md3Qsdi0Q+zxWj3zjbwr7oE?=
 =?us-ascii?Q?MDBdLWtDwPSuAROfKzvxYcYScM/V8xkVWb18qGJOREHC5ozm/dYMPQMuaA+/?=
 =?us-ascii?Q?B0KmMoFHGhM7tgsDsVNX6218jhgHPZTaukxynjnLdzsaB1KN4S66iS3D47Hy?=
 =?us-ascii?Q?s+wXIE4/FTaYJMLJqgavFctOAXzD2+8769pM39KjrMlnL7TrRohJHiQNsKru?=
 =?us-ascii?Q?ZxMJpyBwjIhLYUs7a352MW0kzpoOXwjE96DJBleRFxTkwLllJr2C5wmQZ3sH?=
 =?us-ascii?Q?qL/r1rHlJ2XNZV3siXw/NJwNmcDWcjNA/CPt4NUF?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: f2baa0e3-98e1-48bb-b438-08dda98a5efb
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2025 08:23:12.0477
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yyvAlckSqMTOWQzR1d3h7A1ru4RnrJWwKVqe9N2AZlvYp1h2MAv/7XH54s7abz7L8c6xXwPljNrVM4UjH6flaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4572
X-OriginatorOrg: intel.com

> From: Nicolin Chen <nicolinc@nvidia.com>
> Sent: Tuesday, June 10, 2025 1:14 AM
>=20
> Now, iommufd uses the get_viommu_size and viommu_init ops instead.
>=20
> Remove the iommu_alloc op and all the drivers implementaitons.
>=20
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
