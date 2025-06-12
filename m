Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 613E2221543;
	Thu, 12 Jun 2025 08:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749715654; cv=fail; b=ST6Jl7ao+hnwDbmenuArVC3iwRJrCA7dSSlnKPIKvsqaauviWBIy2tq9Qj04gEVCFYxYVQQeH3fFpjQ0BHjSTXKG5vfiGy7G9tummkaGWVlebZvd0VJnsBJzYcJTJH3PlkrOmoXhOYFmXXKQOoKCdJ4KGy+poXFqrAvj8cQSKDc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749715654; c=relaxed/simple;
	bh=F91UOxbPc7mPS1oSJxcWRwqfMZsrPIo0lqtyh9uOdr0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jMod5ggOhze4H+Gck7+eaQ3IHJ+o//CcaBvzBXmjNPjkCWMc8ULsh3zgsAnzQ7PPhkjpVAmQba68MwC/gYFPeJbsDI9aHIha8gbEZjMqzDTegTJmVXEhoISe6L2nk0ERBOYSGQSwvDrZGTtl/qZKVcgVG8zp23j1Gej4FghCLv8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E2o7sEPH; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E2o7sEPH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749715654; x=1781251654;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=F91UOxbPc7mPS1oSJxcWRwqfMZsrPIo0lqtyh9uOdr0=;
  b=E2o7sEPHkyE60TJMYeKixQccPrCAgkSze2zWNvIBSclPxPSnlA2FqySb
   t0GJRewoOjHWGShNIczBrsJt94opcEnnKSj9ejnkzsYEBK6tTxN25gOCB
   m9Z+6SYQUKLWZB59wMEGEzJlpK6+yd7F8MpTT8GAEnZIFslYjr7jgWliS
   72olUnvc1SFIiv2u12ikxokpPlZCVVN61ACU2gV8XdlkhUxM6HvZ7m6nl
   KbczaYz8pfs9Dl3vSyqomaBcJhJQKW/C5VGSMjjnbevviJH7LIuNFS6RW
   leqghAEcaAkl60KcnO2dbRfiP8r2LWN75KxSVgwO1upGpYqdKU5zLktE8
   A==;
X-CSE-ConnectionGUID: 8rkPXvmzTsqSq7JkQpjqUw==
X-CSE-MsgGUID: jyNzf895QEGMJxgGpadg4g==
X-IronPort-AV: E=McAfee;i="6800,10657,11461"; a="55683681"
X-IronPort-AV: E=Sophos;i="6.16,230,1744095600"; 
   d="scan'208";a="55683681"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 01:07:33 -0700
X-CSE-ConnectionGUID: HJ2p/dl9RrCsbYsRiQyCZA==
X-CSE-MsgGUID: hhRCBrjNThWPOlEUWDgHUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,230,1744095600"; 
   d="scan'208";a="147991639"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 01:07:33 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 12 Jun 2025 01:07:32 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 12 Jun 2025 01:07:32 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.59) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 12 Jun 2025 01:07:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zFUuNfYsVHiKMSajquqrVaxAA0+0CdIP7JFms9uosIrVx9+U9lawkLcPy0FyhEa8X7Ew9hPy8bNMhpKpUE74RvzpR/NzDU7hmwiLJ2cG1aMVWlAeOaCz47kKWa5mWXLoDEn5MJxa0Nv5UBVMbvOdv0fM3DpiVcwXnyd9c+H9prFZvPmtUMwg5MpKg+uw/7D1YFe5iDTR7bvZozQQlnkfZwBFoauLz3vvrbcA0Fz6lDjNAF+gdv8wKRmn0V9dd19GvJtvy1EKsZ3pST0RN0zDw6JvsAFyDLQ+72vCLcMVftC7lTy0VHHp39xu0HuL2tFtRFl+5BOXadg/1FMuPug8xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F91UOxbPc7mPS1oSJxcWRwqfMZsrPIo0lqtyh9uOdr0=;
 b=XviqiBV7MxzCMYSvcqWymLMdX6QNviPaSK7P2/rhR9FCzFuMn+3njZYFUVaqAc+aLJEPPiGCJaMI6n6goZ3e9hpV85ClbJLqrB0hWdnW3L3a6gfDT5QDxeUWEOYm7pTLZLA4xWecA6re7hs/wVqnw+7DAeCZCvEWGgberhgNuQToDPV75kYS1v5PMTv3+lzv+9jX03CeAKrg8rZJfsVExU1oRFlhj8skdVWxumxGxHFa+RjU/v+iUbhK8jcgRlhbXW+VRI4wKCojJD64pLhIKJIvuu9dZObxnhqas3mWqlCcVYLWTVMjo4ZMN+fONebrmNGztgNyLUmcvPH5ep4tZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SA1PR11MB7038.namprd11.prod.outlook.com (2603:10b6:806:2b3::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.22; Thu, 12 Jun
 2025 08:07:29 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%4]) with mapi id 15.20.8835.018; Thu, 12 Jun 2025
 08:07:29 +0000
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
Subject: RE: [PATCH v1 04/12] iommufd: Use enum iommu_veventq_type for type in
 struct iommufd_veventq
Thread-Topic: [PATCH v1 04/12] iommufd: Use enum iommu_veventq_type for type
 in struct iommufd_veventq
Thread-Index: AQHb2WHwhwDcre51fEC6SvfcNhUzrLP/Ly6w
Date: Thu, 12 Jun 2025 08:07:29 +0000
Message-ID: <BN9PR11MB527665287893E6EB41F632348C74A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <cover.1749488870.git.nicolinc@nvidia.com>
 <d60d21de0ea6bcb6e0bb1afe624a9045b38c8ee8.1749488870.git.nicolinc@nvidia.com>
In-Reply-To: <d60d21de0ea6bcb6e0bb1afe624a9045b38c8ee8.1749488870.git.nicolinc@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SA1PR11MB7038:EE_
x-ms-office365-filtering-correlation-id: 66bc9034-3272-4ed9-6f64-08dda9882cf5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?Of1QpwdvJr8qcdE4MU8lFuuu5MN+0wOYq2Kp/xYhyFiLqJxzFWTMvACeOyo4?=
 =?us-ascii?Q?mg375Qz7IWZZnHPVYDxGRw06Uoe9+8RfI5nuHi2cmgMhujJZ3zQNhSjX98Aj?=
 =?us-ascii?Q?ho2p5gBNR1jLpF5enCo10YccKtfmK1FjSja4m+VTcMi+MFpBNwJw4LXDs94K?=
 =?us-ascii?Q?0zjftZtaEp3W263FclJ9OYnIioJukMg423J/a8iloH14e4JiN33V1Mu0kv8z?=
 =?us-ascii?Q?Vz5Y2BLSnx2U3T5pmvZHhMaV5hcbTFeDB2ELrsSAFLxDIL6ZooBb/SaZ0u78?=
 =?us-ascii?Q?x6mBr8vr+IuQ9kAN2dGWtXCdTHZbDrWw/+47dGk3CYKgJH5nofHBxArhZB3Z?=
 =?us-ascii?Q?AJe0DM5oM++UBUBzGp5VSwDiw0ILtpioPoxAqLTiIBiFKE3Gg9ODuMJ1n7ex?=
 =?us-ascii?Q?Vkf0ObWJckVeuKVkGWdjYHKTdAfILc2IjoNZfvR/6H+OqYmzbfeQrwa5rCzV?=
 =?us-ascii?Q?BcB4gqi7YFtm5a6oD7nl8gGl42PbZAliQkSkpDB1ycaQeA/KaldzBZqU/LFD?=
 =?us-ascii?Q?XxxCwqPklXVYENjfMvEnPbHG0WpvY7B310KWM/Hjj30FdBsCaCSThfhsRGEw?=
 =?us-ascii?Q?wtgCn39KpocdpNPig9DI4lDSTPGGESesRvS/4411a4AHA9rCoT2fLZmxYrB2?=
 =?us-ascii?Q?qTN810bcKSjvFU9Cxf6QHrIkoAfVEnMQtU/lrTGElTk0Ya+XvNUfojq7X/4J?=
 =?us-ascii?Q?+Vgq5lYQ+5wlBMI9zbuXw1LS1xZMq4JApdJoL0CDu9NA0EI4YQ4qJgv5+la9?=
 =?us-ascii?Q?Hm6LXkTIC7f3w2ufUPgzHoeO6Uia5MjYDx4IxIxeacevWzjYv+NKNr+9fhAM?=
 =?us-ascii?Q?3NR8M9DuGPhhTGtIuIe1eU7I5783l1W3gl5FkKb4G/W5yC3vD+GI7X6o7++5?=
 =?us-ascii?Q?w0pmdHCs3ITsVfJ9geAhoPnkNoROS4tAgCmVLQ2FpuBMD0Z33LMfvYjIp2Lx?=
 =?us-ascii?Q?0BZVv05xB1l+jk/kw4Thoa+mTS8Re49AOrK6MRVRmmkjVhrF8q8LLk6j4ymB?=
 =?us-ascii?Q?+ls8cpNC0z0+an0Le0bbZtWpZgkXfAFE761n5S0d+OdfExtgdD0Ffqs+wvsI?=
 =?us-ascii?Q?YL9A/uXJFPwZN1skqgwEWJEj/UB9r4cOkZ3NsfeVv82KZY/co/GMc4XMPsbv?=
 =?us-ascii?Q?OdwqkJQj+5oh1b0MCwBHT01QiMdG6zZYCWf3A5rgMiggJGHLxhcc54SSWYqk?=
 =?us-ascii?Q?uPE/OJk9Qq1WG4H8vGYjJ5J2TJLBt6vgLdH7USz6d2ts3o615O9YjVX39apx?=
 =?us-ascii?Q?CBUCI1UFQy0AaNwk3AuiOT1dSaVMHXZCq7PqU3TtHGD/9udeNJZtbWIOaTz8?=
 =?us-ascii?Q?FJe+lUarXwHVNjzrYJZ976v1GoaJh5rwggv+VJ7RiW9vdbXqGLXMUI2Q7Fws?=
 =?us-ascii?Q?CeUn5yHGBDIIwKnviKnLEtKGT+cITsSVbKACwCDsX9hQEJ8xGLsTq9k839hR?=
 =?us-ascii?Q?3ofjSccwULOTS109sszELgWTyzSo3dKnyOHk+LsSjbHtS+fabDYXNA=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?mtxBgtPXqzbjaGO4wU1e3288xUUCD7TkpUg75EOAAEXEsnWUGBeHDZok1RMn?=
 =?us-ascii?Q?s9qkxDy4ISXOlICiJqiLW0cz0ksKUkUF7vC3riptpr8erlEBVNV2epXNLdw+?=
 =?us-ascii?Q?kAkffP0vRA5iwzrH1CT2iLNUyLzHLsQ4egbltA9eQJe2XElAN6DoG2TEGwCu?=
 =?us-ascii?Q?e2BGNyUIZdVpX5kJqzuppKbAPXLrqFp4wgrUf5OlFu84RjwzjTy8J/Bo0E5b?=
 =?us-ascii?Q?3B+Jh2+Jj+HEORBgJvptacBtg6GAeGkf9N2VqULb1Qdd3orgDuqx0OX9a3+b?=
 =?us-ascii?Q?khYkFCClnknc7o43wH9TVs33leCRWukbFD/eZIwow9D16dSxdsVDwPI0irTs?=
 =?us-ascii?Q?HCSPHTfdaNuN5saZbMJg+fr9Zw2rktGdb+FfpOt5JL+HpnZxrT9hexC210Be?=
 =?us-ascii?Q?jW/4gXYjns2JUXpUjNpPM9P1Xpmfn/8Kqvnw3vALZIN2lBelyEQd4pMiNz1/?=
 =?us-ascii?Q?oxokidBE2bSH0yNwENVUAqKmvw9h79zS/8U2Xxh4Unxk/CHbL55ysLJqxQMM?=
 =?us-ascii?Q?kxZNYa1/sVF703MVF3ZkzvAn6cvIvEUaVaQIu4bVip2ZlVEGyap/vnTV3DuK?=
 =?us-ascii?Q?9s4szD/XCKFCzTMMcBGe+Aq7MLOMkbYqpudUmNQdlJgXFD7EDbVw9yz+7wts?=
 =?us-ascii?Q?zZWZ6rn0gJpD//Ubu8WgyxqmY8EcJQDznUo6xR4k5gJCd0FIpjjFbE05VRXf?=
 =?us-ascii?Q?3MztPhYTlQ9ozQdQwXoEC0Gqo+Tts5hNRA9ubA7ZxXFBykXfmfO6pl1rfbFg?=
 =?us-ascii?Q?ED5rPL2f49dKkzLNPombzpOnclg7i8y3YA44KTCuYPdtEXEr8h0MGkbkZCtR?=
 =?us-ascii?Q?kbXi4tWth1tuAK2nsHOyfHQKqUSv2iFLD4QkG7T18gSQT9m3el1APaJEvD3x?=
 =?us-ascii?Q?qETzx025Zjfuui7jwLWDz0RDfiR4IviqrQ3OMxtS2477Y5hKNjueQq7KcXDq?=
 =?us-ascii?Q?G7+LVL5YsdiqOq+v8w5dcj+AtIF+srcvnLX1G0ViLMKhksjUXjP3XEaSW2Vc?=
 =?us-ascii?Q?8OgKBmSWT4X5wtOj4QC0tofZHThhU10ZPnUXhIhEfWmTRDfiWsXelaN/Ij4a?=
 =?us-ascii?Q?XuZWgXBtsuYX5HrvbLSBqHZNZKq/2eDUJ2aKP8CHZYA7FyZIzL8eprfeo+Yo?=
 =?us-ascii?Q?4ml5Kx48jKnygkd/HXR2O62xnxm81zWatrIq0KAyu2GF77ItvMtsUXawkdaL?=
 =?us-ascii?Q?9ikmwC2qq+9P4o0orVDZz3UeX820J0uj3I2usgohU+13rCbcI8ys6ocRZVuf?=
 =?us-ascii?Q?n/rnDfVb6Za0+vivNd9sTkm59kTgMRltDFUeBvdId9MWm9Pd+M9fnA35DuxZ?=
 =?us-ascii?Q?8dUR7uySYmdzloWAB5Gj3+7dwSoo5HAeYtTMkzDY1Tc2O7PdVipFRc10DJ+j?=
 =?us-ascii?Q?DUMioVhe8fixuugI1KjWLs9ry2ISC3HAgVXxikEBK9FnmgX1LGHlR8qpQIew?=
 =?us-ascii?Q?eC+tVWk4AFxOlisjF8CrQ/NsXShv8GkMbghx6/+WRzMZgrIAaw0GKMB00KGU?=
 =?us-ascii?Q?9PvxlBdGbJpGdmnbTjp0RwtfkB6EyYPUNupDsdsb6HWHpBl3TmuEGkIcmKH+?=
 =?us-ascii?Q?i0wiQinB+n1VeA+rLKkIHsGetkaN6oZIWF3y4hoN?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 66bc9034-3272-4ed9-6f64-08dda9882cf5
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2025 08:07:29.1189
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PlRVaJDmPRkVDdXaw0GjxAmj1WuwIt8qVUix+ptG17E6DOrnkuyLiWdpE+o75/ElsxMguKeMbcnadj3ppORMzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB7038
X-OriginatorOrg: intel.com

> From: Nicolin Chen <nicolinc@nvidia.com>
> Sent: Tuesday, June 10, 2025 1:13 AM
>=20
> Replace unsigned init, to make it clear. No functional changes.
>=20
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
