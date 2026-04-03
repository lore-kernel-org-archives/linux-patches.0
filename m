Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 389913537CE;
	Fri,  3 Apr 2026 05:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775194550; cv=fail; b=OHL8pW4yhrGas9IhHysSOf1HNBI1EaLtuK8y5GJT2pAcnj55ftdD0voymKgxgPbMkisOzj+w2ngE57x3ITZHV7PKVC/qY9Q8JiTeaZy0w+3IOfxXRKQ+wmF56fBR504WzFrF1FCjQ/a1DyrNkvpI/+5cjmDLQhRY1edkijteOp8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775194550; c=relaxed/simple;
	bh=BKAkrgIj4VmaYkmNl/RLHgWLjb5R0IuBgAXoQJcJhJ0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=D2spmBJZe4IK6mFbeKfBzVg9hFwAEZlDgDsC+SEl+3EpeWYGLWJwF8GhmMA/1IBohvB9EQvkEHjttvssK2sy9MFuD3tQ0N5cvBeHsaQDvyeCwCYP2PWSA7bA32mpqQodc+Msmk0xpeMSjg+YBp+pGWKLj85x3G6LY2oN4r9DGEE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GRTpuF04; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GRTpuF04"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775194548; x=1806730548;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=BKAkrgIj4VmaYkmNl/RLHgWLjb5R0IuBgAXoQJcJhJ0=;
  b=GRTpuF04jh6E4NHqXNwTBNQIROxny00FxpZICAfsp148rtOls095Gkzk
   qFn2tl+az3Li3NLmFVZlPiclG6PRcZAFTSuwSvENS2wxjn2dHN1ndXaNc
   sEYBQkNRtNFYcpoGvqDclyFTgt1vx+IALPmuGHwb9QVfUcYFkEbN7AWa9
   II6VJo6z6DL2p3Ba0kHuXIwM+V3fnePjCEdPuBA4DJdWu4CoADWtoEQZo
   U0VBmLWOB1+u18JgtA86vvpB/NrMojeQ0bdFUvdUrDFkmUKySFRxl9hVf
   1NSDkagHvz4z/dwW1RwarXovXAzWe56R/kF2MiIrXs+yxhbVrV0C1CfPR
   Q==;
X-CSE-ConnectionGUID: poX25Z5jRuWmAi5vZ6ojig==
X-CSE-MsgGUID: f+TQNVd5TqS55TK5RgAfyg==
X-IronPort-AV: E=McAfee;i="6800,10657,11747"; a="76143113"
X-IronPort-AV: E=Sophos;i="6.23,157,1770624000"; 
   d="scan'208";a="76143113"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2026 22:35:47 -0700
X-CSE-ConnectionGUID: ojuw9HRQSCyyvUI2eAgTMQ==
X-CSE-MsgGUID: CS0W2ovRTvOOPpJoeXVBAA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,157,1770624000"; 
   d="scan'208";a="227045722"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2026 22:35:45 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 2 Apr 2026 22:35:45 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 2 Apr 2026 22:35:45 -0700
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.70) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 2 Apr 2026 22:35:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=edYWCq8yL4diRgnK2c2Xi5JoB3OnNKTYKakiFWEZWeSenAIB+MlE68xNzieDKuy4YSrcFGQmNArfsiImckwVwtLqxDGfsjzJXGYwfKRXgm3N8N6l/ghkvZNGxKEK7VtjXg68EyqnR7O1aPDB7O9yJGL/aq1bhvts5SWOra79J0ZKfC5w+Ls/MJcmhqddppFTas8YUQ1qtnD1TxCy7FZNY+Qgv9FK7s7/izBtkW4IWq6Fd/Ea+xEy0sw53Qt5re1ZWQnusDT/h1K+5+wTdurY0YDNMbs+UFbeUExKTUvR+SnhjCIc4/KeOpYQdOFGIvraI8wWrZ1GRmpBue/QbdtICQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BKAkrgIj4VmaYkmNl/RLHgWLjb5R0IuBgAXoQJcJhJ0=;
 b=MtLNRCPVBRms8WTlde3pE8SOIy0LMgrc11rxdBNP2LMtnDrsjeQKuaSc7s8JOF0t9G1+Mx4JIDBBPaNYJ/ZENLxWpqYIKK9lJ/6lkftAOU5AOp7nKSkDNQrBIEowCgilKkP1Vru/OZ/cTc2G9wkIKthd95PNXHO/o0UwSV5ukQ31umLvYHcdBjU2Jf0MQt/EMQIXTzoDFgTFqLOjN7zzdsr5sTz/U6Rnd8npkaKf9/OW8KuGQ1k6G8WtiTXDb1zZZRto1egf5pXH7bjonVt69JJ2+1XHlebf9CnVvGlxZJeGEXkGt0l9556HHGr6OVZxoQBB8E4aJxudpM77Fzb5Cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH7PR11MB5885.namprd11.prod.outlook.com (2603:10b6:510:134::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.20; Fri, 3 Apr
 2026 05:35:01 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::f997:762f:f079:134f]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::f997:762f:f079:134f%5]) with mapi id 15.20.9769.020; Fri, 3 Apr 2026
 05:35:00 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>, Robin Murphy
	<robin.murphy@arm.com>, Will Deacon <will@kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [PATCH v2] iommu/vt: Simplify calculate_psi_aligned_address()
Thread-Topic: [PATCH v2] iommu/vt: Simplify calculate_psi_aligned_address()
Thread-Index: AQHcwvRRJOKY5kvLU0iR1JwZOsHXxLXM0T3A
Date: Fri, 3 Apr 2026 05:35:00 +0000
Message-ID: <BN9PR11MB52769E83C3ED8DABF2BBE0D38C5EA@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v2-895748900b39+5303-iommupt_inv_vtd_jgg@nvidia.com>
In-Reply-To: <0-v2-895748900b39+5303-iommupt_inv_vtd_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH7PR11MB5885:EE_
x-ms-office365-filtering-correlation-id: fcdf6a1a-f253-4d87-f008-08de9142bffc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700021|22082099003|18002099003|56012099003;
x-microsoft-antispam-message-info: ST9JhZc2tV8wb3TDzn9XNL+LogziTCBz/jhSfYOcj6F2PdAxWars8HzDG6+5dYiMot2aVVWu90k9OSlMsUl9BxEgZA/cpKtV1WUCrfSvJJISl6wtB5bfAtRtB8aed6pQn5VWUDMpsve95iUiEeJO6exLqNGRliaI52FQS+DjS3T29BJrxAqP/sUTb3zYUG3FI3Yzgm7fxHEsHjphIpe2f46hUvyBrk0BLLyLLNBIAY5LQOx3I5IaNeV9soW87nN61Ag4q/iD0Z/7FWGiqXiQfTopCen/N8auDEKmmyww2QwZJlwE+gVj4NAz0yU5w6ZMohpfb9QHmld3sziir5Q7gZVg/vth3JjxzILhJmA8qUgFZMqHmEXrBpML2oqRNnm4h1I7UxQDB0gfGwNOvQPZBAw4zl6yJ57zrUmlQByLwo8LjRVS9icG5ppKzP2it9js9n2bv4CUpYMY5imwK+G07LzzYhjylLVKKJsXQotmqikafcfi7n8S7Zr8nH0qzoXQVF5wA0QWrebLyHLDLDBtfCSLeKbpWaNVSBp8VqYC1m/QcCyYvxsvHJClOe67OfLeNs7H9a3M23nY7qbjhqhT3vYepQ7KY9lWPTjda29CuKK6yJAmjJ9MVSqjmd3g8IuUu6vTU/uC9kCAVrDJ9sQ3lmg/FWuiyqj0LrqrQPNVSfdzSNC5RPO/B6QTA4QkykvZEmlQBqpLFNa/v0NrktNt/O3txQKQtzY1S3SR6GNhCBTvSwAcbJQAcECEvRel0VlKMoOHzkN37QwVhS5wmBVqwbMzEcJBRzLb36yuNRmK12c=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700021)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?FPQAJ0NJI7pWW8Qrsrm/HQidazV/EHK7SeiL/wP8LzTPPAIWWQx6g9qFvL4y?=
 =?us-ascii?Q?q0dF5mNgY9QmCWS43wjN35OCq5/V8frDS0UAFhn79fjKQWqNn48aK3ako4KW?=
 =?us-ascii?Q?+fEhhdUNrbzqQUFUuS98GDZ9ceNYkkMj9MR75Z60V8TRUs88aOqClVkx4EhA?=
 =?us-ascii?Q?4Nkoc2hE/sfoUA8LCVx+zpOfa1h12jeTG9Coc7J8pmJDzOSAuU+Ed1m2eBbb?=
 =?us-ascii?Q?o/XFbLVZZECzf0+2ZGnXg0NMNeZWHHvGv1l1o+i/+f/+R+GvAVLAFHtgyvHf?=
 =?us-ascii?Q?856vtqytJ6E2UOUpnDVbNZYsCLqKl/zl3aL9UtNP6wkZFbPSMFxT5YRLAsHh?=
 =?us-ascii?Q?qnga+hVbTRiRBOx1pQ0q/5ZWHHQ31Cmhml8ns5YYA/N6ktaWx3dha+BGeh00?=
 =?us-ascii?Q?bL2O0chmIPGM9ijIeXjKyCytYf1z/rlUhMRUxv1mV5o48x+VTMmorAc7FlSG?=
 =?us-ascii?Q?1Unzj84dYRt55MRbe2aoLXZAsEtOsp4cVyz8LDmbAhgWpVSAzgkDabq5TSmH?=
 =?us-ascii?Q?rksz5QjLbDq60FzQs7lCLC6Y72AaTjjQAUWWax1rmZwhSVj9gxGrJ5qTKVTq?=
 =?us-ascii?Q?b2sqzocLSPGEuAYpTLzaZXl9ysP7vL6olcTOCmCtoE6ra5ILa56+iYI7AwR+?=
 =?us-ascii?Q?Irsv7oAy+QJBiCfKRR5BHWKJgUxJW0OxGjbMLhaFcgEzglmplPt1HmI7/74u?=
 =?us-ascii?Q?+UAvMoST5IgzmCWieXN0/mGm/H4XPlofYPqfvqWDxWoE0modnhZ3OVY5ybWv?=
 =?us-ascii?Q?UdW4ek0czi+OWfVIzeSwqN7U5J9gaUzVOqwIBM5UTVTkIgIi/EqL2XPzhsp8?=
 =?us-ascii?Q?b2v8etJ3DLac0OmErzPqT9ex2MjTZCQsjlEQvYAmRA6EJtWsl7V8BdBdnB8S?=
 =?us-ascii?Q?+5VrCh11PrbpN93mzwfAZrUxqcgeRQmmapX68osMG0UcRjG7y42gPHwP95de?=
 =?us-ascii?Q?wslinSYYtFRA6eWbPREPtivRdDYSEa48mKTotj3c/xBDawcLsK2UhyCA99N2?=
 =?us-ascii?Q?k5/pyWpAr4dtTQJR8tCOWWew7nju5HYmQtJYJnrtsRbJnu9D5VF0iWf/alCQ?=
 =?us-ascii?Q?B5pOgwK+i20IIVMVIK84k2AFU5wOuUQ07ev32R9x8oT1MpjxnJYYYDrrF9ux?=
 =?us-ascii?Q?US14AYZwNBnsKtL/HYw54a7N6eCMdjI+e3h4qaQ4QLWS5/6eYxR0inOP/FOr?=
 =?us-ascii?Q?xNWIugoknlVfgdDPYJUoiPBN5PSvxaS9ZxvbpwO+8SXtte0S9cPNIk4W8cpX?=
 =?us-ascii?Q?tGrsT8NqUiYpHoPpSoCsAdsus8zRAK822ooF4L9wApIOxTkz861YBm/EZqL+?=
 =?us-ascii?Q?dpFXdMrXAsB/yULHLdyt0pgQuwzjL1e3wyDyVBrTJbdYjtlfY4wvtg7bd02W?=
 =?us-ascii?Q?Fog+hXZNkXGlo9+G63r2XuuXFbRrFvYRA2u+JNhEIDszKJTfM0L6yb9enref?=
 =?us-ascii?Q?MfvnMQr/Wk9ufn1RIJgwh1FyI8R8GIvr3lTQVVSW0Zt1VIMWh1qfpTmOx0Nz?=
 =?us-ascii?Q?Tf3OUKoF3+CG/LMMIw/p9xXTTwMklrwwgMgEPEcabMVyIUGDnKUHXEu9+b8P?=
 =?us-ascii?Q?31n05gqsZyOZ6vx6KhXgUQ/+370WQB8kQNzS1JicB1S9ZXoGODlgcK+1p0qH?=
 =?us-ascii?Q?KmGrhtjgwGOFmk9s7XE4GI2QyHUn3FMljC/20T3ER5AnJsy5HIG3poxtLwOS?=
 =?us-ascii?Q?ry/GY/xBoW5wI8C3LWh568//2MPcWovlxAXPhXv2xsLOg92o?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: eruxridl+j9vH1bPZGZ8O8NlLQ94G/RPmMhBpkBc1pX4dFKsjQyI9m4X60RWeioFDZ/uKmEpgzl1e3P3kpgRXOrctPo7IZ9oTkC+RxGoP2Q0UOgjh4FoOujOVyJ7Mtd3uROkf5+vGEVc9i2BWGh96edxueQ/0oFSwTPyHp14kbVagT2BvxZdLCr3Z2xw5uO2qnaiFDd/bnmnLIiIcFdzeaeX0rCz6glh87dDQ1Q6XpQldEHS19CYI5N6E5Ma3NUa16FkEn8+2mgmV8kqjjX+28Ngu39D2ie7ECChpN2rkq4UavydKdUbf0UxC22NHslABanKcZCo0AJ17cDSxqXWBw==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fcdf6a1a-f253-4d87-f008-08de9142bffc
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Apr 2026 05:35:00.7811
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +vsu92sbtmp1AB3iOzc/oGjyL0hRlPODz0/mImBTuIkTbEgpuL3SIbldMxXTeFzYUvLhyXhNExj2Rb460hTnOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5885
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Friday, April 3, 2026 6:56 AM
>=20
> This is doing far too much math for the simple task of finding a
> power of 2 that fully spans the given range. Use fls directly on
> the xor which computes the common binary prefix.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
