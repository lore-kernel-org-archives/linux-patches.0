Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F6B024B57;
	Wed, 21 Feb 2024 07:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708499514; cv=fail; b=I+Jt0U/TElh8OH5dJxvqKRkYVV0UmhzGNii2XvIHhVyVCKga5Dp2vjzzSaGoCsN3KyXwdELK2LSPH7glU+cPdwNCcVZMZ+eXLqXvaSiO3HxXJ/2ZxGdGHfUIwQtmkiMjiGKTvitvIqerdoo4Wn6S0E+0fyXBSm1Tbe4B8kuEMwE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708499514; c=relaxed/simple;
	bh=qp7l63FR0hXtWNGUZWI658aDL5jCqxA2RmLh2NtLw9k=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YBWIrPyej6C+Dx5rflKK+m4PUyNJqVoWVuzHrWzAprsvu+D/X7rk8IQgV8sd8hgH+rk/tG23afiv5FkiNHeKO6xRneJhAw7IOUNEv+IYYMgHMH2kGongPvBiHI0uLV6McYxufAH8dBQ7pq2mzM3WTiJWNamtYB1dMORxTFiMcsA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=B7YKCHTz; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="B7YKCHTz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708499512; x=1740035512;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qp7l63FR0hXtWNGUZWI658aDL5jCqxA2RmLh2NtLw9k=;
  b=B7YKCHTz6WPz5zgRvPJTNQ+bNmMclME42mvcqN3HmlQyJzSn+vsTXiLx
   /AYsuot5+TYJi68xD8MHOFfFGeY4V8xuNM2qYNIoxOV0m5mdMxepp90up
   Q5EpOuj8W0oiCK8CqNrLGK28PiR/PdCWp1mTFm66WvmGtYrsh45BvFhDH
   KBIg2YX48yqK36V9lLCsfT71agnLz/Gczs/6sOEBITL2JopF/nZQSmvjn
   tyMB7tJE4xjiXJSBE9uxlOldVuotCzDx7nWY8k08xxne78Fzytl23rLgB
   BskmCWbzjSEC/RToc/NfkOqi1g0cAC4XCxLM1N7ttV6jI546ZFDgARzpm
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10990"; a="13344944"
X-IronPort-AV: E=Sophos;i="6.06,175,1705392000"; 
   d="scan'208";a="13344944"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2024 23:11:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,175,1705392000"; 
   d="scan'208";a="35807646"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Feb 2024 23:11:48 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 20 Feb 2024 23:11:47 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 20 Feb 2024 23:11:47 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 20 Feb 2024 23:11:47 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 20 Feb 2024 23:11:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j1Uind/ViZMB0TeLLL0mRv6ijfAK78+cgB1kKEN0rViw3kvKF0lZ7mIg0S3gS0xFNI3+54zbRXA3Rw/QYkCk6HVMHsFSYnipD1FOZhm2ALsFasiDOEnh5dMdif7MftAhNYL+duCal34T7F8eUzbmyl/uLwVj+VWxcgMoo1UHdrwMobIgW2TKvYFXMK1JCugfc2kFxBR+NR1WvsZ1+toKxNug4dJ7sM6MnRnFXxabVOO00i4WeJrzj8xoq0OOLFiQmv/UQ3ndP2I4l1/tDgh0bndeAdSSlF7H3bcbclQM7gYu7IErOlmKI9JWZOFDVi18oNS7KMW6iHOFREY1dzDR0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qp7l63FR0hXtWNGUZWI658aDL5jCqxA2RmLh2NtLw9k=;
 b=X7VumdWp3J2Orbp+54gAgUF8uN7PLyIMGLBzbCj2JLvppZ4bDIPA6sc7chRdJgCnzvzyJhtTrDDaFYczmV5MoeUDtg7UydqOpvcfBziQqqoNRecsfSraoz2SBhvoZY1FcGO8Sb5wgpjdZ4ofq8/FTWpKhALHrmUa7a+Aeq7RCuHfANIeFPRXbX80/asgTo/y+vONUo2o9xAXQXQsr7PYCNWvXuFegNTzULhTBRWXIPNHDcQqQd+VpxLlpEJQ44zR3rUTdijLzMQ0KG1BqwmD/uwYkkFleuexe7bA80EH8q6kZUAJsx47GEuyIFYfkFY4U+abyNJwp4uAKNs03bL89g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DS0PR11MB7650.namprd11.prod.outlook.com (2603:10b6:8:151::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.38; Wed, 21 Feb
 2024 07:11:45 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b0e3:e5b2:ab34:ff80]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b0e3:e5b2:ab34:ff80%6]) with mapi id 15.20.7316.018; Wed, 21 Feb 2024
 07:11:45 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>
CC: Nicolin Chen <nicolinc@nvidia.com>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>, "Liu, Yi L" <yi.l.liu@intel.com>
Subject: RE: [PATCH] iommufd: Reject non-zero data_type if no data_len is
 provided
Thread-Topic: [PATCH] iommufd: Reject non-zero data_type if no data_len is
 provided
Thread-Index: AQHaZCzODnfZ7PsRL0+F1QDPm/g0LrEUYgWA
Date: Wed, 21 Feb 2024 07:11:45 +0000
Message-ID: <BN9PR11MB5276C5091996B828101A78AF8C572@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-9b1ea6869554+110c60-iommufd_ck_data_type_jgg@nvidia.com>
In-Reply-To: <0-v1-9b1ea6869554+110c60-iommufd_ck_data_type_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DS0PR11MB7650:EE_
x-ms-office365-filtering-correlation-id: 2e1dbb90-2070-42a9-f602-08dc32ac5cc7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kxe6gLemwGcl1uq5ah/0DlygMuLKUcEFLo4KxFB1hSPj9qdwOPfAvscNz0XmGN90Ulfn7nHwrP/Kz8HMsaKEWtVbfmO99FTV0jNHqhw0Ye19hJRrZvVKEYLT54Yawx6w7lKSLD8L7Rt9bBJyelOhCQuDW0b9OlC32uvl1xy2JSX1XQ4DLbAqyjoH0dRXKbfDK5kCwv5XDaLSmKyM/pxpk6r/uKUxyCwWZH/vr4Q4ujoMI6F+BENVaoxZ3gItCXP778SpDw+cAvXFaGJ9lVSKY63Uqlfe5zz0YG7o2et7Y/HZ2N1yxLxAyXGNRoy7fA1HfwpYffxFQKB7e2BjHODqhaR7eRZtGw44AE9OpyH2DeQs+T6xLu1PfuONi/jbJGLToxefi3jNIkbBGK02KL4LvLK/WbUl9vVkM4uUGIGugd0DkxB7Zj/GWdK5Fw0R1GjA3GcrOp9mSS1PVhyUjVSqAdzypBsrKnXjAP1QaF0Tvj1uSOyZG2IOr6wcgyRhBa+WVsk7e7Q/UyMpnK0403S9eTRgorVzzkRmGQP+Yemt9qBo7NL/S9rePynHkBTu6497FAlbxgcq3pzm0vybPQBaGsgZ86wyktEqXKre4IUXuN66On3pLF2ItQE5MbElhlAt
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?X43AE5TWpHS6KMD+G9AXRGTvtVsTwlFSj8mlVDrMMm8MYarJE93CV5dzPNY2?=
 =?us-ascii?Q?XZ4sEtepN8eGHBOvGjzPYU8PlZAvGHa0hBoFL2T33nijecQeZ+XQQhyhN5Oc?=
 =?us-ascii?Q?ME15qP1MtLeoBkr17cSPrdEe6BqhJug9Y+f+HhW0Cyl5TnsYYmkSqETY7mMu?=
 =?us-ascii?Q?ZabBlekhZS7itmvv+9Az2qnXfHGir2T0BrNcGpMvankrpwUpd/zCOV+Ini0m?=
 =?us-ascii?Q?nKI21XssxvVTCr/ESVFwlKV1R0fVX2yXQmMGJLpNtVVbgkCSoFiPY8iK515z?=
 =?us-ascii?Q?+2yD2H4kt3rlg30dYvi7bP1iDVVET1mr/uGhW9/H1NTcu+gOyP2AautZWz+z?=
 =?us-ascii?Q?B28nP7vBXN1PN/IzrKw1LX7NQxTIr+sJ4iSa+JLOrjveRJ7x0/wfS5UzLp/g?=
 =?us-ascii?Q?OAMJ2P5V/vF2KyMCDqNV+tDEGPFu3rd0+a9KyyPbPCsMDiPvPDXTRUMI9RfF?=
 =?us-ascii?Q?yQNuPF14stH0xn5F6eVKCIh7NZjv0jyfNcFRstjCZGZszeUzblxhZSGHpW5c?=
 =?us-ascii?Q?laeOeQdn/yyFN7bRNryNigdz14CfltS9+PNCeMLlsUruK1tOrIR8h8F0ZBIH?=
 =?us-ascii?Q?/xxE2Y9yDRPQbJ1xM6D9vTsTNXzQLgoYkKuAP/jE/kMkWb+Z2IjM0Dw1a/3l?=
 =?us-ascii?Q?hpMiXgylaXk3ijqSTIazhlJoz9V8EvhWuMfnqlqCGD9yJU92mFIwp/lG0E4f?=
 =?us-ascii?Q?GsTWyOioSBuwozOeW9JL/Ks61p/MLE7JUaGZpFfnydMLQRyclhyz1vdheUYq?=
 =?us-ascii?Q?+LJpfi6QD1ak1GSrYjnYSXPtePZfoFcTqka/Q/XeV6T/AqF0CIncLw50I1hT?=
 =?us-ascii?Q?4vPZtGS04bDqVSuoOsst2RdT7T/g9HeMeSXmJja7KX9sFvrS7EBXfUCqDWYI?=
 =?us-ascii?Q?L4n1xzISGsK1QZMcQS+Gt/Po3siyEtfHgn2YO9tXyfDolpavSNcQYb24Hh3P?=
 =?us-ascii?Q?KWlsHmqD6RHb1Omxf2CeO4DhIO8mqNQ77FVA1DEk82Hs9r3U/N87fB8agPXf?=
 =?us-ascii?Q?azUxv9g4w86GzU5GmXR4uQl3X3b5gvad4xJe/eztlLsAc/wjFZ5CRDmPlGiu?=
 =?us-ascii?Q?3SDEcvc57HD0IhTuKgAK4ZGkAx1XrcGsjmrcwcoHwaC5Z+cr0PzaIvQSTHMC?=
 =?us-ascii?Q?7bjEnE1NQXB1Yn+WXzimJ98pR9pkUKa0B4D1Gm1IrheBSiCnPtM85vt+qIds?=
 =?us-ascii?Q?G3F6vix7PvWGDKYS3rquddZgl/gORH29xVyCsYymp5dbDflv1LqH3d+W53RJ?=
 =?us-ascii?Q?zhbMA3ZK121JtdktwjYNsFqTkOq+aGFncYncdLGHBD0rCvWVu6PaiwSMg10g?=
 =?us-ascii?Q?0MS3yIc+52XKwQVjodYI9ck1wDSgdTT9uAttCOHe/q9ik7W1qLXXKhz57BiJ?=
 =?us-ascii?Q?m5rti/EtoZGj9JyvA3XIoBSy9KXcsQikHzsqZyWzMrhDA4AzcbNI/3htVX/Q?=
 =?us-ascii?Q?sDPWUJEH1O5mlReHeKipP5bgHq64TPFmQwuOQrDKnXhxwVP7ikCucSs6kpvH?=
 =?us-ascii?Q?YCen94FEhGd7/igi1JpNpM2dSRu+6oAjCPoaMtZCWQJlJai7brmFAcfExCQE?=
 =?us-ascii?Q?SBJrinKPMkokJJlasuKo4NUsXlxS4wvsKfUQbnxw?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e1dbb90-2070-42a9-f602-08dc32ac5cc7
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Feb 2024 07:11:45.1780
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IKm1250OBy6e5VsjVlUeWQ1fFllmnIt172A2+TFMxY5bgpG7ko4c+G+St76Y6E/TvP/oVB8/2uMlBycC8x45Gw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7650
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, February 21, 2024 2:44 AM
>=20
> Since the current design doesn't forward the data_type to the driver to
> check unless there is a data_len/uptr for a driver specific struct we
> should check and ensure that data_type is 0 if data_len is 0. Otherwise
> any value is permitted.
>=20
> Fixes: bd529dbb661d ("iommufd: Add a nested HW pagetable object")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
