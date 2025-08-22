Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4648D2FA0FD;
	Fri, 22 Aug 2025 09:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755855341; cv=fail; b=iJO54m4UBjkduUzZyaZOEZwOIDpRSkJoW/1tQ4yh2FLjbc6f2bKFI0rDg5uG+3Qv2UP14NDBtTOgIoI1hJ3N+nkKjnTa/8tDc1YrsmJYsdKD5574J4JG08I+I5vEH7R2uY+Msid//2Rj8wGYvHagykcRej7VgE2wOffevFx8rc0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755855341; c=relaxed/simple;
	bh=ruSSzYS9gt4kbIlfGvVUc8nm2atPqbxViJAqegXzVZ4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tZ5Dik5ex7sBqC+Ul6SOEmTc2oAcb1viTAPkpkDf4ThcbFnJxtXghSItNEqsXuAKv73Nc0cWBrBlTkICfUmlmWQhPwB03WZopxZk9NrDC+UOnMKwKZ6PhGJu903ruMAwsmfNAxhRWP7wkpX2jmo06f/PirhDIMdVDncbGnOY7W8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TTmzPnjf; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TTmzPnjf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755855336; x=1787391336;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ruSSzYS9gt4kbIlfGvVUc8nm2atPqbxViJAqegXzVZ4=;
  b=TTmzPnjfxz1ocPRwP2c90f52K9NErjtOL+WRc/JJUyqi4in1XYgDoL71
   SaKLcAjqdfunEOwdgVhGzbDiRKjM70B6Rjwo3zJWKasImIMKHra1OZkz2
   4D7TuNOUPJ1EZrRfZ1IA7UQWPB8eQyqzZadCRFPMuPEWjVqLZ+PKkR6A0
   25+rB5cLgJc/864G7f0yop5Zrj/rQhmgK10OZnO1aQXnlbhR4E8dSQGP3
   HQSGQkmk7ITiXF6JNYDpMAZsEp9TQ7FsYHCdBOwmcXvIL9sgVaK3kS9FL
   fu7fIZd/nTXrnJmmJCTu7flEKjoIO5CVTxzo0nkCC6Mlt+/q/sPDxW++K
   A==;
X-CSE-ConnectionGUID: oVqnw9VFQNSR6cDZ88gMVg==
X-CSE-MsgGUID: dfvQPugESXO7ik4QrQDbjQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11529"; a="69599278"
X-IronPort-AV: E=Sophos;i="6.17,309,1747724400"; 
   d="scan'208";a="69599278"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2025 02:35:35 -0700
X-CSE-ConnectionGUID: pJ75PhO+T6208uBwZiYLrQ==
X-CSE-MsgGUID: mtJD7ak+T1aYJDpGdcV6wg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,309,1747724400"; 
   d="scan'208";a="167898291"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2025 02:35:36 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 22 Aug 2025 02:35:35 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Fri, 22 Aug 2025 02:35:35 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (40.107.101.62)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 22 Aug 2025 02:35:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NvSQN9WFJDCvlxDDUV7E3VMZstJXtP598b9ZTJlVuTzkF808xklkqYD8IpQuVltSPjp3QP46eSeavLV+lZEj+grdQSgr8Lxkl+51JdczE1VSQSOkibUQqoc0C/qywqOiTFnUA0DDdfzFMx+8oH2sbgTxU9Ol6dmadjej1NCKi3QqQ6QMv5rpEnD6v5ADheZboU1dPrS8vF+upB3rfKawBOWUQH96v/C9oKniWydnY/83GzCukFB1CdjnCa3lOOsuhwZteZU0r9Qxo890gebB499EwffIubA956eW5OQ1bq/UyvlH/YWTVyl4Kx5r1jVOUAA26x4Baevt+hOwf1WSfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D649FJbqQ3ChwRYOoZBg6n9mPVuXm+Rdm8XA51V3ASQ=;
 b=mI1zH7Bl8704IWoEsqzv+M5/WjEnkWv3XJwkefQ3I6+ux4o9zjxInomlURFqhiuK8CPbXROnRR6a/cAtWGRtA3vKBKyo3vnZpIYioq17MsQxqPNw/dwUWSdcfrOkh+P/Hmr8vN5pjd2XkFfh5Xk18ckFs22wCAy0GJzMJYOHXFvFmYFxBzZE+qneYeG2Fl/ruEwbVcgC4tGWXHU2SjLcIVAfyfyzKlxZS+ooPMpXAvERDWQ7f2JWpp87fHItWgZeVS4iAv9ufJ1FFe7ydnqcBhXNK29M+RTYyQmxiaqjgK7KSdIouFgvCZf0cr1YOrsLQ4oSm/j8faXSgVp3IHmxQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DS0PR11MB8232.namprd11.prod.outlook.com (2603:10b6:8:15d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.17; Fri, 22 Aug
 2025 09:35:28 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%4]) with mapi id 15.20.9031.023; Fri, 22 Aug 2025
 09:35:27 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>, Robin Murphy
	<robin.murphy@arm.com>, Will Deacon <will@kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>, Tina Zhang
	<tina.zhang@intel.com>, "Wang, Wei W" <wei.w.wang@intel.com>
Subject: RE: [PATCH 8/9] iommu/vt-d: Use the generic iommu page table
Thread-Topic: [PATCH 8/9] iommu/vt-d: Use the generic iommu page table
Thread-Index: AQHb9ov51JCA0gvIIEGyKL+XUb3/h7Runk8Q
Date: Fri, 22 Aug 2025 09:35:27 +0000
Message-ID: <BN9PR11MB527649224AE0E30ECD18DF318C3DA@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-bdb01ffac49c+be-iommu_pt_vtd_jgg@nvidia.com>
 <8-v1-bdb01ffac49c+be-iommu_pt_vtd_jgg@nvidia.com>
In-Reply-To: <8-v1-bdb01ffac49c+be-iommu_pt_vtd_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DS0PR11MB8232:EE_
x-ms-office365-filtering-correlation-id: fcf51a3a-c2b0-4201-ca69-08dde15f3aac
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?+pDLQKCG3qjBEMtYOwOLo1H3DSBeZWof8JuD4OcJ3OdCRaL4/34lIcc+egiT?=
 =?us-ascii?Q?eL5qY7ursYbrbzEuUR+gezhkgJSkqS2GKO2z4Iy44KX2Aj/WdtSoB2sUTbrR?=
 =?us-ascii?Q?7L42WietqX1062VKU/qnzPgUs8WndmbYZCjvIXXfzne3ZHFnhlGBy4VFXogz?=
 =?us-ascii?Q?3ox3O0Zi3xErSvJjSE/WcAQTSgi+tDpGJ/QHgKP8FNKjVTKRVSNgay4qmveZ?=
 =?us-ascii?Q?kpiqhQSznJo+qU665jcIb22CvqUFfk7Hw6M81//igGuIXUOea9vG8l22AM9W?=
 =?us-ascii?Q?rNIrJIJ9tp3Ak90Vs607YfTgP05nwoZxp7F/xw+7JWzuJs/RH0faXjthDAjw?=
 =?us-ascii?Q?xmzqbV1X/yg0VPtpWZpgIs1qaiaLgfw9MqOFKhVL+pgZojYnbLnJthp/RUFZ?=
 =?us-ascii?Q?zKPMbUpClQczrjJEGUzSNp8kD0aB7T6sDNKa5C2aHoik7xzn8Dq/pj6JmBBw?=
 =?us-ascii?Q?qDUQ6IaV+RHuT6fhDvAm3QdFOgXz33b6fToMxgG4VQA3oM2A8gyYS/I5FsZY?=
 =?us-ascii?Q?NXCvi2W9lbhqf7EwQnjzV9fYvCtXj7cQAhThyjbMmN+RkEiZdapoWZzAis4c?=
 =?us-ascii?Q?8N9CSDEQ2eZuLFngs3hiGdLBB22SldO7S86qySepxSRPbQr8XvUvwtFZliY3?=
 =?us-ascii?Q?RJ9IB+hedPypRiNvLrbAesDtnq7+BCMymTWq9lLyg2TdVMPtRfKb8EL+iwG2?=
 =?us-ascii?Q?0x2zF97xhcIuZYL9VeHFKrfN9C1zlLuniqfHp9VsL2hbKbyrDJl52GJTkFeW?=
 =?us-ascii?Q?7HPGU4o3dTgjHeXtICtYlBIgfG+1Pxt2sFTRmEM2A2YvOiNxCzAajJoPMtjj?=
 =?us-ascii?Q?FKjsY8tWM3UUBuy/87t5Encqb1ooDW90XaKf2BGj7u6HUOHDuxyhvSW289xZ?=
 =?us-ascii?Q?B6KXWq5khN5HF+Yrsx90+4HL4a6KT431bDqUJ4vL85eXeEjIEQQu5grvDF1T?=
 =?us-ascii?Q?DhQXmJhw7sa+VKop18jUUdSTPvHkobaFFrx27t3y0lNTrOsw2ms8FKv/RBfL?=
 =?us-ascii?Q?6PHnT+K2Nzm7fvb5jHja0FLmVWKyWuAtAgfkEFH+Gis/oOtv6nqpLMlPlB+r?=
 =?us-ascii?Q?3AhMv6RVliC9nk3U7HgOvFXqx7y5074Vzlf5SAlccq4Hr4c3vHxJdW/x9Fl4?=
 =?us-ascii?Q?xAcr9L/kUkgiNAqIrBzT2fP7pWBQRq+cpQfwjjmasr1qZdXVq41uQQYPpUDY?=
 =?us-ascii?Q?K7f+9CZMTG9NKZ2iiozDbNS2zBPNlan0SKEHuydu0lwrVQHoIwnTdK9aHIG+?=
 =?us-ascii?Q?hEQBaWI/FXt//uGueOKxB/s8B76mNhwq0eOeZNzXeC1UkSqmD75dnK3Qu72e?=
 =?us-ascii?Q?d1/Nu1NF7eZSKpG2chwW2xxRUEPEFN61SE84mhno4AoqmEcU8goeHuBYW74M?=
 =?us-ascii?Q?Dz/lQHMA9sEBC5pRVFO+XUogNehZffDKwjHksMiYJDP71qaOOozgd+aGkHG3?=
 =?us-ascii?Q?6LScTWiTJ7o8DZtWLW7+NO9/8yKF8hDqUuxRW5WEweRCVR2YaTBUabCOp4yG?=
 =?us-ascii?Q?sX/KNSO0+b+Euhw=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?yPwXdwJ8t6TURvng7RWK8jCIxlceG5X1CmHpKBWY7fe0GnuZ6Xx4b1QQs7su?=
 =?us-ascii?Q?FzGnAM3i9hlhk44+uM2fG4z7nMCp1erZxIP9vUMPiZTzjL9HCi+ut3rs0hXl?=
 =?us-ascii?Q?RJxK1W5Vqp2bqiFILA/kz+Egj6Am30oR3H+jK8DPGde/XwzI4K0yConNNIJ3?=
 =?us-ascii?Q?OANyWOmapfvVpWI+t+ThYBG105MFWdwXboWgsIEqQtnMujnIgUpLYQNGW6qa?=
 =?us-ascii?Q?ch3fbIt/+m8mF5erRYMvDKg55rbhrzcSgKFcnjOQEQk+yZI0qU/7Lev4oVmu?=
 =?us-ascii?Q?4UdEUnGSfOEKFHn805Kh9F16wZlxYqi4ncN0n9gYyybnzlloTk/9odUpuUtk?=
 =?us-ascii?Q?+KMz6XCSSGTpPBMaCj6A9IpWQzY2AdrJvbcSEMRzM4lvcQz7CtNWn/0qcV8n?=
 =?us-ascii?Q?WFOd+ERI/z6PUNB9E4G5le6CSDwwcinT7Jj2jUQ725Vm/G/bQEqwtj6n29ZH?=
 =?us-ascii?Q?UEOiikoKsbSBFnqJD2LDZ0ImYwmZ1Z8iAgH0wLSuTyAdqOuAAzeyGap3IVWE?=
 =?us-ascii?Q?YL3qqhCUcVdBtBk5AV9d4xuqXpJnhVYLnNIXmXW6yCJclVfUGHvDIW9Q9dev?=
 =?us-ascii?Q?CX7LpEO5SoDO6fnozvMNCVk99luSBfhsUI6QwJNPRlMXYRzKXtqJpOKfXngJ?=
 =?us-ascii?Q?e+/Hw5yeZIWhWeigu8/FG70LRd9xPbAzraoPZhE2aPqAI0Cr/Fnfy0MC+iGS?=
 =?us-ascii?Q?Zn6HEdG/WWdAuUVFyE8hS9W85mJQMIoU0oMpyOzVd4ZAfKmPjUuZO2XI4RdZ?=
 =?us-ascii?Q?gibaDb/fRSjxkHkuV14L1nAfUS63p7aLF0oiLdG4xZE/A896BKqJW07aBTku?=
 =?us-ascii?Q?78tMU9VKPjjcRlr6QxIjR2oCCDli6gB9FDI76BnS1CW2jrp02URg99uT/JzY?=
 =?us-ascii?Q?X8Nx3nzkuTflJYhnvKbsD8p5hkxxl5kmH1317kwTz571MSVwSYAIEju+TTtZ?=
 =?us-ascii?Q?wFCvX6+oLrb8Dyxj5FRUCKNv92yqrP4nbNI5TjET5bupEmxbfdTPenhgV1RH?=
 =?us-ascii?Q?YF5pkS8zmhW0EU08AtFoQbTsdHADWj0WKg+J0W4YfZW4WbOgRrx9xY3E8c0z?=
 =?us-ascii?Q?l75H5hhT7ry8zYFmr4ZJslhQ/xNqfq/EjTm0xsZ8951yFL119ArPky+mRAxn?=
 =?us-ascii?Q?UbBaOASYW/55GVeHUs044x4TQuFDRGsZjGBGpuZykKfpKzqz2rtKFF5ee7Sy?=
 =?us-ascii?Q?oV+iid+D1Obr0QakOQjsvNxc39uOP85JMn9mNiMmU21Nn+ID2pCM7GEVOwlb?=
 =?us-ascii?Q?b5D3hjdIsHMjBAyOFNnGhNDmexK8swYdmu2N8WArvlysQQxFDsVZL78LRK16?=
 =?us-ascii?Q?p+T7DgaZjVzx0caY6yewfvwPtSSE6KS67afIPCcOL6l8cUF2C8qocX6l6Or3?=
 =?us-ascii?Q?NJUDzZub22N+KoyUIAcK1SVDQ56JGbgbkdkQ7Rj6jBG26AyQbuSrBvo75sTx?=
 =?us-ascii?Q?iTcrLCZ6LEoXZrlCt5fzuGJXLVmzluIGYJQ9OYOaCpmTsbees8cCw9ZWaX3O?=
 =?us-ascii?Q?61rUTdh31mnSZhW3flzTN8qwMaf3a4yOhVp8Mwk75W8GojuNiGd7Ou1YyqSX?=
 =?us-ascii?Q?+2hGz54h+ta0YIgzyXBActySlQaLZ074+8VLYcPC?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: fcf51a3a-c2b0-4201-ca69-08dde15f3aac
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2025 09:35:27.8522
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: plS4LNs1tX2eEBT9XoPPGMWrtoFkK3mY2cKgRTNL1t3RILljgfPKjDl59M0BGhZFRJkkFJAaAU9WmOGBSYf9QQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8232
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, July 17, 2025 3:58 AM
>=20
> Replace the VT-D iommu_domain implementation of the VTD second stage
> and
> first stage page tables with the iommupt VTDSS and x86_64
> pagetables. x86_64 is shared with the AMD driver.
>=20
> There are a couple notable things in VT-D:
> - Like AMD the second stage format is not sign extended, unlike AMD it
>   cannot decode a full 64 bits. The first stage format is a normal sign
>   extended x86 page table
> - The HW caps can indicate how many levels, how many address bits and
> what
>   leaf page sizes are supported in HW. As before the highest number of
>   levels that can translate the entire supported address width is used.
>   The supported page sizes are adjusted directly from the dedicated
>   first/second stage cap bits.
> - VTD requires flushing 'write buffers'. This logic is left unchanged,
>   the write buffer flushes on any gather flush or through iotlb_sync_map.
> - Like ARM, VTD has an optional non-coherent page table walker that

'optional' sounds like a software choice. but here is actually a hardware
limitation on certain platforms.

>   requires cache flushing. This is supported through
> PT_FEAT_DMA_INCOHERENT
>   the same as ARM, however x86 can't use the DMA API for flush, it must
>   call the arch function clflush_cache_range()
> - The PT_FEAT_DYNAMIC_TOP can probably be supported on VTD someday
> for the
>   second stage when it uses 128 bit atomic stores for the HW context
>   structures.
> - PT_FEAT_VTDSS_FORCE_WRITEABLE is used to work around
> ERRATA_772415_SPR17
> - A kernel command line parameter "sp_off" disables all page sizes except=
 4k

No related code in this patch. Is it from the common logic in the AMD
series?

>=20
> Remove all the unused iommu_domain page table code. The debufs paths

s/debufs/debugfs/

> @@ -3442,6 +2990,16 @@ static int
> paging_domain_compatible_first_stage(struct dmar_domain *dmar_domain,
>  	if (!sm_supported(iommu) || !ecap_flts(iommu->ecap))
>  		return -EINVAL;
>=20
> +	if (!ecap_smpwc(iommu->ecap) &&
> +	    !(dmar_domain->fspt.x86_64_pt.common.features &
> +	      BIT(PT_FEAT_DMA_INCOHERENT)))
> +		return -EINVAL;

this change leads to a slightly different behavior from the old one.

the old logic is that iommu/domain must have the same attribute:

-	if (dmar_domain->iommu_coherency !=3D
-			iommu_paging_structure_coherency(iommu))
-		return -EINVAL;

but with this change a coherent walker can be attached to a
incoherent domain. Conceptually it's correct, as the only side effect
is unnecessary cost of cache flush. But it does lead to user-visible
impact i.e. a previously failed attach may succeed now.

In reality it might be fine as I'm not aware of a platform with IOMMUs
having mixed coherent/incoherent walkers. But since this series is=20
more for refactoring, better leave the uAPI semantics change to future.
