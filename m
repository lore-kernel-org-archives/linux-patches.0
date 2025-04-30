Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCCAC1EEA46;
	Wed, 30 Apr 2025 09:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746003650; cv=fail; b=NVIhoXQSijODF4iRjNIYpmU/PTcOtMF+LaDjbyiW+PjEK0YX62ZotBhOG9RpTtzbUHexbL4SD3A48AHG3LY/7tAwhJb8aMCWm2B0tNlBkXMfg8eyUQbMC2YuuQYJY/cW0MLgOx9u2lYcyBcNlFGOf9MNty5SzBb9AdQdJBWGOZg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746003650; c=relaxed/simple;
	bh=mE8AFZQBX1br/HM/PrsGivuK/jUrElCdvXxBCyx4jVI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=P6jPXovu9WkMxQuKcPZHnwKf+Dq2LYFwSQsgOAFV+srWwIRlpIbA4zUcq0m5DWaFaWaFQMRTL84FFZzdvt7UDjevcAOVJrzXvycfq1YXHAzv2wkU8wox9PZsJUkvgg42seOHktUv4yf8JxLV7gPTioJaYXnJDQlB5QuPEVt2IxU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=i4P2B7Ap; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i4P2B7Ap"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746003648; x=1777539648;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=mE8AFZQBX1br/HM/PrsGivuK/jUrElCdvXxBCyx4jVI=;
  b=i4P2B7Ap36TfZ3W36BxUBD3wZ8/jJsMkTosnnXx9L2qDfbEDv/wZeGaM
   8pdSeAN1RFWydVorZPBD0yPsOEDPzQFlFZMXtww8eMzxax6h0L1Gn+N4X
   UBD3Rh+HOxCTxcMEZ3P/beNilg3bibJWUeS5Bv6CWvAldqxtEBlRlq3rl
   Bf+pBh+yHEzBfWn68CSeiDsUYUqN6kZVenmNlpO7glRISQ4m3fYSbCwxZ
   Nr5MNi8YaV14O9ZFDO6g9fQYn+5y/FGSqOxQGvHhGRO2XKGmhsUIc/90A
   i51zB7cLnq2PL3PCkY/SMidDV1WgdFUM72lfCne2CJj+XFIuKgSxrcfgt
   Q==;
X-CSE-ConnectionGUID: CMVic+ouS9yf716GC90T6Q==
X-CSE-MsgGUID: yQ0TTHDtSCaKD3d1vSsMdA==
X-IronPort-AV: E=McAfee;i="6700,10204,11418"; a="35267769"
X-IronPort-AV: E=Sophos;i="6.15,251,1739865600"; 
   d="scan'208";a="35267769"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2025 02:00:47 -0700
X-CSE-ConnectionGUID: hHaq6L3TQRuLst1p2j4Y6Q==
X-CSE-MsgGUID: 03mJ9cFVR+K9+wHxh2DcZw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,251,1739865600"; 
   d="scan'208";a="165008503"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2025 02:00:42 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 30 Apr 2025 02:00:41 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 30 Apr 2025 02:00:41 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 30 Apr 2025 02:00:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eKCU2/2wIZa7jc137Kj2tCuwj6UJ/M6ztbrXZlYhyzPnr8DLDFdH5A93xILsjx8P9jbEVRKrEZ3/RwLzRzk5q75lIZousg6hajE/t78sMYxjfbLrT4eUwh0rtsWEGOlZMBIdSdPKPtZPpZsU7Ho204SAQ/yd4GYnWnHilHwEEfNZ6OEzQP5znQ+PsXUAgu/er8VBMnP3KUOFggtBKhmvkqYfc1O9h+tHxk+a7l90IeL4CH5HkQtq7sa27wdPRpi0+vplr3GEs6PMxSFJAULFnK5z1wnWHYOjNDJpnLtJxFhHuJNMS7dj5/NCq7MwkkZ2dz3/cVmCaJlEAvnsKHfMTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mE8AFZQBX1br/HM/PrsGivuK/jUrElCdvXxBCyx4jVI=;
 b=rR9uuF+NU9cYbyKNT4wBy2BTOmJs5uuR5eVNCcZBG8Kr/qiG4l6gjC425NzXCKzon2+lbP/TZqFLkj4mRRe04Lf1tG1B4VlZfD6nkO/Xv92YtQG+59QgGLleZuTWjl+P82FyQFj8PE6/4zrkCmuwh6i2ZxP2c6akJVTFhG7coOTQNgT+wu6J0y5H/NI4t8YXtaw7h1NvspK0sjpfjVnlXB/cgF959iVhWaBkyuIWpOFhljMyJ2Z4X9qh7Rixxw7LnMxAjBfBzturjWOsmR5o8UjTVU/G9XwWSLvxsWuBkHSG491u70EkvNtdlHF9TIw2Z/lu5sIlWzb5MdbdmKCrig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MW4PR11MB6911.namprd11.prod.outlook.com (2603:10b6:303:22d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.31; Wed, 30 Apr
 2025 09:00:24 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%6]) with mapi id 15.20.8699.012; Wed, 30 Apr 2025
 09:00:24 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>, Robin Murphy
	<robin.murphy@arm.com>, Will Deacon <will@kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [PATCH] iommu/vt-d: Restore WO permissions on second-level paging
 entries
Thread-Topic: [PATCH] iommu/vt-d: Restore WO permissions on second-level
 paging entries
Thread-Index: AQHbuSGwjCkCq1Tvkk+j4UaPR+HwNbO76cMg
Date: Wed, 30 Apr 2025 09:00:24 +0000
Message-ID: <BN9PR11MB5276862FA18022CE00DCFFD08C832@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-c26553717e90+65f-iommu_vtd_ss_wo_jgg@nvidia.com>
In-Reply-To: <0-v1-c26553717e90+65f-iommu_vtd_ss_wo_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|MW4PR11MB6911:EE_
x-ms-office365-filtering-correlation-id: 598d58e1-6108-464b-2303-08dd87c571b0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?N3JK5/nh4fCfudnrCDs6xaZKlTIxS7xRwv0JZ4OuzwuvorIJT4uu0d476pbr?=
 =?us-ascii?Q?QDIaX+pRun8RT8gpN3eeAEdvDZzL7GWbR204+gu124nluxsIFwnYoUVDztuA?=
 =?us-ascii?Q?hyjOJk/z1ZS+Wu+ObChUVRH2M+lfehQ2stWDDOVMIumSW5m8JmP0vUGAdcD0?=
 =?us-ascii?Q?IloLogkjc7z5qQp2c+3d9bvzbTqSQDm60tFdz50XgTAFuq9PFLThqSkZZzBa?=
 =?us-ascii?Q?pPAX7rpOHpVrdTh8u2pz71rH8QtlnVRzJPsITDNfTpZYQolzhIrKfI7Ts0+N?=
 =?us-ascii?Q?ylRMXuX8RQXd6Rl0s4dhlosQkjwetmNzteQRQMnnIcjGWO/GtM02kQ9VI6g9?=
 =?us-ascii?Q?Vgx8TXTFRQMEHtcY8KcpGDooQhdVjmK/jB9GlEDwwSv+OoOOiGHSXoUS8UGj?=
 =?us-ascii?Q?hi9rSFTFkb0uuFhJXEAdku1a3xBbxPyeaFx6FEsRf8wI17mfY8CSODQ8L4kM?=
 =?us-ascii?Q?KKiTRnHN/6C0oCYMTBg9vZciXYrm6DLNCyKdkvjhPyD6cV7gDZnrSz/kBdsC?=
 =?us-ascii?Q?GMbDOEYDyr6pW9b+mpwjdanafbypIzsJpxlpZio3Lkb8t4gj/8PyY60AQp6l?=
 =?us-ascii?Q?Zxem892QTOUUubvez6Ett2Z62DpEg0DE/Yi6PplD6mURqaiVWXTLlDbg8ORa?=
 =?us-ascii?Q?S2TrPgK3P/Hy8u/JzsnQdxANIYQcm18ssDgEEjfOZ/ZiqTxqByktmSFBnfBN?=
 =?us-ascii?Q?wRG22P5i8RaDzZZKk/q33hNhD5W28+YYLvoXc8vdiLnvwpeGArjLwm8s/efQ?=
 =?us-ascii?Q?IDnZcu1Yqr8OWqQ6OIHE9C5qhWhxpu8hek5lCoC/rHfJUozhtD4HdY0P8f0w?=
 =?us-ascii?Q?OLCInJRPevZK5lFb1OyVc76OtXdsRFgxB68kZGDow2RLemAYGXqeTBGoVgqO?=
 =?us-ascii?Q?J/dtb6yYZgK/1KZE+PvgGLk1uSTgldjmIDj201h6G1D9l6v7yfBp/+L9Hz9m?=
 =?us-ascii?Q?kay/BCyu4VXhmy1bvd1uTGJElBelmQ9IphUiOizPpauYDDObUvuKfx4oi5Qn?=
 =?us-ascii?Q?n6ByLJKD/gniuYWU6Y6HUeqfCuhi7B44odN2Jesf8ZF1opS4KsToM05GWM28?=
 =?us-ascii?Q?214k5NygGiWP7mq2HhxSicjMIvBpeXFyiJ4zgMYm3TY2qNE+JdpEbk5HxDrD?=
 =?us-ascii?Q?83A1ocNHDFQmE6isUI43jn64qL2yFeyYDgxX96J0sKsIjkuhpwH3mOE1uU9I?=
 =?us-ascii?Q?euX7tRQMbogZQzhB4o2AWJltDdp22dAu8FLncXhyGu5269NDgv08pNzF3DTy?=
 =?us-ascii?Q?TEuCO10dpG5NtGsJRDf35mvl+Oz9sHR+bgBgfnaH60C9lLgvTGXVlfJaiDUE?=
 =?us-ascii?Q?euA32icBTgSDSYU0WHYSQxwGvpm5jP2pcWy8Hs1ulpcOiPIuBsPCbXP2x2R9?=
 =?us-ascii?Q?4oGVTgap7MmFdx1eLJfeNgfoJNGMm7RPVmB1/hoze1MrabI0PL4IxxcSkp0l?=
 =?us-ascii?Q?hZWkvuK9ykwxP4W7BM/z1NCr+9QkvfpT+AZm1SeqCyIQWWmhG66I7A=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jiQCVVDkUtxjrVHm74mI6vYrxqzBsHfSjjLbUfEF9V4e8RJIE+3ojDzcHNGC?=
 =?us-ascii?Q?r9ADx2yA5cBYnYlmw3+G6B0v4mvEcMdRiwy0dwbWMvF56rz0LACZXTc6051h?=
 =?us-ascii?Q?ziXtN1iU6jq3gjRziSlhl1DPr0iIl+7kwipcKR4UXdse56BkX1uMaRWuduKu?=
 =?us-ascii?Q?A5cmVmLt43vP2naTCA/MBnIphAi+LMbpOErwkjl+HrGtphKkOhbZmy6V4LI+?=
 =?us-ascii?Q?Ke0SFDdDfeAZ8P11WqgpfI0ybc1Xw/g4gEzo9SUEqRI7aPFCwFHeUqCn6KDT?=
 =?us-ascii?Q?B8hZ5A6KDiiXTa+YaVDCjjs9j5Ox93MpvfNKdTQ8tHy3SYkLuCwhTycXldx9?=
 =?us-ascii?Q?CNRz4vak1gmj2uwc4QUZmTWLHyIgTfUGyHXiJxvyys7O3PHfPjyeHC6IUwE3?=
 =?us-ascii?Q?PUzrd0gNbmixXoqBk8QZGfRwUfXiboXu5sbiSKTYQSBIQuIXxs/89PcD1stO?=
 =?us-ascii?Q?GVMgq/4lu+wvdb6HJSug0Er879ZWh8GQTm3YuuxeL82p1MihhgtrbHbdboCL?=
 =?us-ascii?Q?A52zzzpSsw6ghoJvTIYgV3K0fWqR+NLC83yak/5BPjcxTW7DzS5QzRqRXSAL?=
 =?us-ascii?Q?3Mjk9eqvtdMv1tYWai0kt893IqvlxsuVACpIolO6WewOHtTOYwA9KGSfeKcr?=
 =?us-ascii?Q?by4U0jXoyFye/B8U7G94BQNCif7Yyfy4/qY5jq9NE2elB2OB7szDfOVWxpaW?=
 =?us-ascii?Q?CFLdcrt1tvzmCmO3vmtdBXp1jNPDzY5NC1z5+YWXvH36h97WbWG+XJc4WpeH?=
 =?us-ascii?Q?tl6tFjH9iQkp11DEtct0xk+eGywfNgIf6duotbNw7Y+TmLDCe75oMejxpHZv?=
 =?us-ascii?Q?6gTYec9+ui4raWw7g8vyp3+JJD/+6xiNU2X1ygiFAlCq+wc6WDSP8Mb/MI8z?=
 =?us-ascii?Q?JgPnyNgcWWdGN9WAUus8qjbmdJvFUP+7h/m9h9BriT/2F4YRTdc7SCe44bLv?=
 =?us-ascii?Q?YxT/M48nnWCsuHjgyKwhh54daMdDcyMNNc+jIsBlP+VpW6L2sesEi5QaIv9A?=
 =?us-ascii?Q?E8qTpScPXutbVzXDzxmv/xwxmZOqNsrU/ROpzUNMLv4UMFa/9usnhb92TZMh?=
 =?us-ascii?Q?ZIG61kMeRN06+9gOwCzdokhwlUw+VmPqVaEAiyStGpZkD5D9RoU1WoJd8RBs?=
 =?us-ascii?Q?quT58jeacxPHUsF3xxiB9gdJFQd7zEySxsdQJpIwrKWkQc+kXQTkdYo2l/yW?=
 =?us-ascii?Q?0CMxuXuEO//iNb3L3lJoMiGKpwSVj+bRmKru6bkSHzdCg7B4VLNjYXogExEZ?=
 =?us-ascii?Q?8pOpAZ0g/uqlagwJzg93Qpkoir4Iwe9ISSzRqB2khBnf8Jb2eW4IkC08wOhh?=
 =?us-ascii?Q?R5YwzZH38sbaw6tr1CF8+c8nb5YIg3UuApBZD5ubQ2TwOI9Fy0F3gJd3E37H?=
 =?us-ascii?Q?EH3e7OwTKpBf8gKATVlijh6sLCTR3rCSbefoyFi4murUFnEjqmfwKAiktjWW?=
 =?us-ascii?Q?XkOb5lMZPKRqf07DY1j2E+lYbaR2hAJF7s7KUpDyKy2LrSqivA8EkwULAmfQ?=
 =?us-ascii?Q?03IvL37vfes9WGm8xQiumzS/u/BpUgcVGKXc9pDqSWqvNV93dXRsLwh96BH1?=
 =?us-ascii?Q?XbOMBP5ut1TSl9qoes+nLYCARE7mH9jrWrpQF6c4?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 598d58e1-6108-464b-2303-08dd87c571b0
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2025 09:00:24.1737
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EIsloSK+NMm5tKRqRH9NoSfpoDxo0zZH2KfREMC+4YpH2oYeoLp7nnVU1w1wHSDOFwuFwM+raqFwYsv61DZ2Jg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6911
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, April 30, 2025 12:12 AM
>=20
> VT-D HW can do WO permissions on the second-stage but not the first-stage
> page table formats. The commit eea53c581688 ("iommu/vt-d: Remove WO
> permissions on second-level paging entries") wanted to make this uniform
> for VT-D by disabling the support for WO permissions in the second-stage.
>=20
> This isn't consistent with how other drivers are working. Instead if the
> underlying HW can support WO, it should. For instance AMD already
> supports
> WO on its second stage (v1) format and not its first (v2).
>=20
> If WO support needs to be discoverable it should be done through an
> iommu_domain capability flag.

DMA_FROM_DEVICE ideally implies a WO mapping but it is more
a hint instead of an enforcement. so yes a new flag might be
required when a strict WO support is required.

>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
