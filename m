Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B8922E2EF0;
	Fri, 13 Jun 2025 07:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749800081; cv=fail; b=Qo65MktLVMxqGKwrJj+Nf0SyIwFh4NnyazvLjvbPHBDVLW1WGqDeFKwE1k4PIlN/12ziGZUimvGNOZdUqxtrtowqrGV2UCalhjWA1vQTEko02iyXqjDXZYl4+Zxbj2YS3TC8ibZXZ92sxAxIZc7N6+qA696vx6DfYzcGLZZgUdM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749800081; c=relaxed/simple;
	bh=TSPh/ojMJ43hCnrLsc15LC2xzNOi3ecRe5kfnI9z3rA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hf1r1nILx+r6JTxgRLAD/NoiJWZrHFr3v1IdfCE1ZSzVcqDsSQnFWhZRpx4QUrb2/gSZmBDoKMdbI98RXjOxK+OS7/NgmWWG0bK34+54eFoIlMz15+L+hzcO/2Jspd8qQzM19uJDAHZedyonQ0yl6/VC24veXQwMhTvtD0xFYns=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QlfdzACv; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QlfdzACv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749800079; x=1781336079;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TSPh/ojMJ43hCnrLsc15LC2xzNOi3ecRe5kfnI9z3rA=;
  b=QlfdzACv5zfwdi6UKVu0COWmTSWpRe9BpiKW/85c1nKoWQI1cDAi1wjY
   fZhx99GuNcs7pV55OhoB+SsEZGgfWBFjMPHUqAlWIclqq8QC8kDYfGUAT
   uz6zJ/GnMdIT0sCBb/lrQeD1LO8jT/MswMZ7JnrWn6lVJo0Z3H5KfWost
   Wnl1xy0VR9EE5aqT79yDSPqT3BqaP1PzqCukFU2+pt6z/uYctZSI623Bp
   4N1Gw68FdDhp6qdA5kqzSDVExw4toOCuplFhchpTgS7o9f6h1WUCLq20a
   5rqacRcSKEEU321Z9wzHSwTsancqW5HROw84appvz1nmAtC7K/jXSYjEU
   Q==;
X-CSE-ConnectionGUID: jWjv5OF8Si63UZzE0Zgmqw==
X-CSE-MsgGUID: oXE/oYEuRvudckHQ/OwH6A==
X-IronPort-AV: E=McAfee;i="6800,10657,11462"; a="52154063"
X-IronPort-AV: E=Sophos;i="6.16,233,1744095600"; 
   d="scan'208";a="52154063"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2025 00:34:38 -0700
X-CSE-ConnectionGUID: gUKJE1dsTAWP3mHFIz75zg==
X-CSE-MsgGUID: XUU80np5S+iYtMrw3NX2OQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,233,1744095600"; 
   d="scan'208";a="151581167"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2025 00:34:37 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 13 Jun 2025 00:34:36 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Fri, 13 Jun 2025 00:34:36 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.77)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 13 Jun 2025 00:34:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IE10N0/FnXofNe5P2TzC0GJ7tshTPuB6/8i8ByHcOkK5X3MnOLwPz+PVHnASyqa/DmfoT6q3MXnVcCqSEzuFArxt4Shbg86G+xTnEg1jcRHIW9NayGMNER45een6Ts7YbCPWuRXrEskHRVIBdddNy/rquvKSixMu7QTsuBVYgYEYCN+37dXzwHcKeZHEu4nHh4VRArTNjKntpnwKLMgiG1cMrHMtwP6raYyq8WFVcPHzKX5kaSJ/iMaIVS2NA49rKZ04/cqfa4pAZwRfSUK2fQuaGs/awswuNPR0qFSub1txcYwvtQgDoSLJO6D2Yo//xnHgUJZinreWolh7fKwgHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TSPh/ojMJ43hCnrLsc15LC2xzNOi3ecRe5kfnI9z3rA=;
 b=Rj2g9I6+J5mAIByMabZdaXSabkbLFmfI0FjDr9Z6uO54YfUqBO1yREzeqL29VaaHUAl2d2Bn4Fl2N0XTW7+vtbDexnPEq+MsDQrX4RCZX4AtjbiaSoMwHB5Y+aKS9xVcC0Uu5G2Jna2Qr8Y3fyYwGbd2k5zdaxMRg+HED2s4tysZldedMskORQyb3eOXxkBhylw56I3Dzb8CXbof57hr5C0+0V6FBIHGh2fIwNOgEkF+7Ir0kOAztUi9o9BGvxCA40tRBE+0Ywv5lIG2zCRAptIjzMWGeDx9hLGa6JuurD877tBlje+x3oC6MPy++HVNHgW2OTgBGlwET1yxZNg/KQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ1PR11MB6202.namprd11.prod.outlook.com (2603:10b6:a03:45b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.29; Fri, 13 Jun
 2025 07:34:34 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%4]) with mapi id 15.20.8835.025; Fri, 13 Jun 2025
 07:34:34 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Nicolin Chen <nicolinc@nvidia.com>
CC: "jgg@nvidia.com" <jgg@nvidia.com>, "will@kernel.org" <will@kernel.org>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>, "joro@8bytes.org"
	<joro@8bytes.org>, "ddutile@redhat.com" <ddutile@redhat.com>, "Liu, Yi L"
	<yi.l.liu@intel.com>, "peterz@infradead.org" <peterz@infradead.org>,
	"jsnitsel@redhat.com" <jsnitsel@redhat.com>, "praan@google.com"
	<praan@google.com>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>
Subject: RE: [PATCH v1 06/12] iommufd/selftest: Implement mock_get_viommu_size
 and mock_viommu_init
Thread-Topic: [PATCH v1 06/12] iommufd/selftest: Implement
 mock_get_viommu_size and mock_viommu_init
Thread-Index: AQHb2WHztBj7S2Bb1UaLrnu3BFfNbbP/MVJggACWJgCAAPCpYA==
Date: Fri, 13 Jun 2025 07:34:33 +0000
Message-ID: <BN9PR11MB5276130A632EABC6C771C32E8C77A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <cover.1749488870.git.nicolinc@nvidia.com>
 <5880f4d754b2b7a7c4bc8664a5b954821c73aab7.1749488870.git.nicolinc@nvidia.com>
 <BN9PR11MB52760F8C5A8B6331CE5588778C74A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <aEsKZNh4ow53d7hW@nvidia.com>
In-Reply-To: <aEsKZNh4ow53d7hW@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ1PR11MB6202:EE_
x-ms-office365-filtering-correlation-id: 7621d23b-1c82-4fc4-13be-08ddaa4cbe14
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?qiznDxmw1F4e+FbjMLj8H+wj79U+ESths/HxyiOLdr2F8yoCwIE3efYPG72t?=
 =?us-ascii?Q?NEUnf3h068UQ62G0qYV8JcemCeEkgqqppTLqkqWjRAX8HgbzVgaI4M7wLNQl?=
 =?us-ascii?Q?tIL3SABaljA7Ifq2u/K2GjN+zpYSLeSpiKxFGDrXK2U63or3IwydVtG/zE1b?=
 =?us-ascii?Q?RVCCRNJukUXzvOznmicrREkbHZsVyBzDWG4I7s+Q+CmZnRWJmwmVLL6zVZKG?=
 =?us-ascii?Q?VO4uM1e0Jus25J0+JlUgmrUwyotPqd+HAgNc+Dn+v2u3mg1TcrABj2zTHdtF?=
 =?us-ascii?Q?+/cwLIdlkmpIdNSXoKPQWObas6wD2DFyPcW2KVY4SwRqbUxlrSkqwApzdZ3P?=
 =?us-ascii?Q?3Pngj67O0OtkGzyHdqMyZFjwFYmvq3eC6mppXHHKoXxpZv1Ox9G6bq9zOspl?=
 =?us-ascii?Q?IuKoNQS1l0TVrE5+wT7WPN5DxPOZ051+bm+eaG5w1Xuk84E65auljXeo1/Wz?=
 =?us-ascii?Q?XC42iOCf5BK7nAKEaJOz2hLSEqoTj6/bxLiRdCrBjS3TRaXa2HCOOrZ0fg+x?=
 =?us-ascii?Q?8YO58IRPub3x3dHMraT1IXCJ/Sx7yhZnkjXUOguxM3Aw3U3mXlMGdbKZWOAH?=
 =?us-ascii?Q?k4TEkGYqffvPqepXMEipvYiX0cBZlaYYB4bY0HAa93FBD0uXE6jDGyYL9euf?=
 =?us-ascii?Q?qKdepKvprUBLJKZnhKNpn9vfWj3YMovCo/724VZuH/QkdK70yIZ9jv01/kxO?=
 =?us-ascii?Q?VfQEHjiw9yv5Om42vpxopH8f1QW8Sg7LvgsLHrDhdgojyQIDMCOTPwl1EICk?=
 =?us-ascii?Q?p3Z9nRcgWZm6DWV5efQBjqDVdZmq/m2UOtAVrYqvCRVu3yXEOHgZv6hf2PeB?=
 =?us-ascii?Q?T/g6mrhSjNql0ppPkyFBasuJ/m1Cjg9JTpL2GGILrIJnHSehViX6W1U1RKqI?=
 =?us-ascii?Q?o79pjdLfdo0GfozZGD4MfHoOfENATf6ga8wJStkNgY/MobXeTIP+5z8kVkG9?=
 =?us-ascii?Q?Eunt3mmxBwBf62/NCcmUsbvH4GurogkwYCvuvoqAGqLlXYXprHcTtMShdLVj?=
 =?us-ascii?Q?WrxTejwQl7/UhOhYflxotLiGOld33SY5JBY9sr3WOwfRKiiwEKqkM87/EZsD?=
 =?us-ascii?Q?qQEv5JLP7UUt26RKhKLFYW/rzaSKba6MYIsIjTZtZHlvJ9KCYeExtGKx7cVA?=
 =?us-ascii?Q?vQ/C1xe8TUeNibrGzR0RH3tdiBKkcXGB8Fbj0icXfWRfM2OSJXIiRWd1ugXO?=
 =?us-ascii?Q?Dz/RG1g6PRTsq4j32HmYbi9uwHW1ikOF1j4wSLbed9SxZfQDa/fxgAt8EoO8?=
 =?us-ascii?Q?+MzQ+VBmeiQkRzhoYu8u5Fgs5VG2EtA8MUaTOat5kyqeXm9J0EPNzhFkHQS+?=
 =?us-ascii?Q?7m3XltIVbNecfU98hbYrd/dZLXCxz84fsla09Ap7Y1HXegkJuKTrpKqnED/9?=
 =?us-ascii?Q?MW+wOLH9gkrLiIhFU7NH2dHOsD6gCDiNgN/tlsY55bjMpajZTqqc2sjDXbvn?=
 =?us-ascii?Q?3vGc1Ka2abPOdnlMgTUs1B4sI88SvC9LJW4OtT6MJYaVJ8AUSDnBBA=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?0xLx63QiIcIllX22u+ogkBzrftmYmaighaCEZWa4BCKaQNF//RfRqRj6R8Z3?=
 =?us-ascii?Q?4/c5SyrhHCqiG0DSudLX5r6H2wrUkZCy5ojG038pOnxYhVOvIhFJLm/93AiD?=
 =?us-ascii?Q?tc4Z166TY5+HB+rX0BwuLheYUh0pAWKHOjYhELU/AViN7kkfANtAIcWO9XFM?=
 =?us-ascii?Q?hDHu4juIUyB/LDwO3+U/jIyHgqz2iLiaDooiL0HtvN8HjDnobbptGZuLKKux?=
 =?us-ascii?Q?NrC0Oz4Ce39/QA4khsUUD+zm0IsBlOF+E3eVSaLlHlauvmM76CKnGzOCktnT?=
 =?us-ascii?Q?UpsptonKUf3WjPh+133HVwfSzuEX6p8OdWlhDx9MRiGwnGO55dLB7ZTR/CcS?=
 =?us-ascii?Q?08jJgKtXnbtmthHJl3f9A0wmb2ga7G89kUxsPuWLBFlVwuMKZWBOSNxUTbYz?=
 =?us-ascii?Q?2VEaHWZg/IY7jqwD0JHXY7e/owc9E501C6iu0SdCyQvrLAFEJSpzhuBUfxGm?=
 =?us-ascii?Q?zigo5PgWrHHjF+Xkb+QhcYYGLacDCZdaSPN8XEWRiIF6ZDjTKeVI/H5FUkwB?=
 =?us-ascii?Q?cC+CSNAE5AaCimyxvxF5WUzBHlC9Bu9oqGtLy91QgdjWHsyMPd42mXGhu2W5?=
 =?us-ascii?Q?cukVw6e/4mj2c9PWjbX+NB8DuOi4oLC5x9UK8RzdERNCMvFpE4Ud12dZMQFh?=
 =?us-ascii?Q?QeUliYBevUR+hsj0q0nQZPwp3mZMO9GwUIOyyE7FUVeDChsts04dd3kaNfxk?=
 =?us-ascii?Q?gO1ijyPhaMTP5FO9Ubv4Hh5fUxvAl3riQ2aaxoG4IsnMbBK72kDGVY2s/f0e?=
 =?us-ascii?Q?mFhG71UsjU6x8M5AwDy7wTG81+blVSYdbYOXFbSejD1jA0Fkg9CbfYuGCVvN?=
 =?us-ascii?Q?Flk+zZsUWkWUJ875p5gavuyBrkSsP/1x170axGzCI/1sXJwT/n39sDvMoXPP?=
 =?us-ascii?Q?0ZiNkUiFaUJJe2+NJblNxMP8VIP4Qdb+bxKZ/h0q9b0cYgeDi/JatOdLt1fZ?=
 =?us-ascii?Q?quVTSBWjF06oERqUNYuGoQAuiKoPIIVzBjdu2VTRu5uJWVtCWMQGPuMPIo/t?=
 =?us-ascii?Q?AVkF3b0FVDqKSsk2WkB9zkHZgpEvsVC3VTxGgjAKFpop052vRfLNBnEMLpmR?=
 =?us-ascii?Q?LDJyh6bZCk3QBm1pYzC+7vndeaNY81w4eOEUQJFtDmfJoY3nYg/BKecNrv3U?=
 =?us-ascii?Q?ccpkuKVSjszzg+sUaEmyGZBcdO+/T9e7NSAkMv3fBjijsD783uYgcA+m4T81?=
 =?us-ascii?Q?OsJCRG1g0mqaih0+WCn0e3XtBlVUxJJ+0i0nhWE61gd5G6ddIGWQiJZErOU/?=
 =?us-ascii?Q?cEs7MGrNtocVK7VM4hLNliyrqapFWKWIKmIwAGW65RDEJdRwMOL/2M2vZ9py?=
 =?us-ascii?Q?5pHLxFABchKW7HNS+Ozrn6x212QMGF0rEUaV4CXCxtujBnqeztpdqVMoDuwO?=
 =?us-ascii?Q?Zf0ZBoXlYV5VwG0RfxyHG0ZNd+KPeXaTbBmVn5Jb0jNaUEiGC7TXFOIh06a6?=
 =?us-ascii?Q?+i7GJDPpA+rIZq+T4ltRvp1Kfopz++22tBb+hfg3oRfE7MlxcXqyv7/mFsJ0?=
 =?us-ascii?Q?/0YC5VSdsz5Y5JPtraL6SoLvJOv3RhaLyNpm42OrOJXgNoQlX1XLuNuoZmJ0?=
 =?us-ascii?Q?AdO4u9mPBQHiC3k8g5RyaPKhUE4FgWKfmJrDwGcz?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 7621d23b-1c82-4fc4-13be-08ddaa4cbe14
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2025 07:34:33.9272
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nn+fvZAxQboQioFCuKf23QjNBUHRlqZUeXlOLO8Dz3THxFwQosLW/oMQRFSr5d4eAp+ZLJCWQkA+l7Mt5dXaYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6202
X-OriginatorOrg: intel.com

> From: Nicolin Chen <nicolinc@nvidia.com>
> Sent: Friday, June 13, 2025 1:12 AM
>=20
> On Thu, Jun 12, 2025 at 08:17:19AM +0000, Tian, Kevin wrote:
> > > From: Nicolin Chen <nicolinc@nvidia.com>
> > > Sent: Tuesday, June 10, 2025 1:13 AM
> > >
> > > Sanitize the inputs and report the size of struct mock_viommu on succ=
ess,
> > > in mock_get_viommu_size().
> > >
> > > The core will ensure the viommu_type is set to the core vIOMMU object=
,
> so
> > > simply init the driver part in mock_viommu_init().
> > >
> > > The mock_viommu_alloc() will be cleaned up once the transition is don=
e.
> > >
> > > Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> >
> > Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> >
> > btw I didn't see where mock_viommu->s2_parent is set in the original
> > code. Is it a bug or oversight?
>=20
> Looks like that was missing.. But it shouldn't trigger any bug
> since mock_nested->parent doesn't have any meaningful value in
> the code..
>=20
> Perhaps we should think of adding some use case out of it. Or,
> we'd need to clean it away..
>=20

Then it's kind of dead code. If we cannot find meaningful use then
better to remove it.
