Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDBDF38238B;
	Tue, 31 Mar 2026 07:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774943284; cv=fail; b=kJqdt0RHJd+epWC5xdMu1czLYaTboZreuHMpVkx0IYnbwP3EnMp3pJxReznhVqkyht+M4/AsBSDTOxfxD3Gjew2pVYMxohJORq+fSdPFEffrMUPXJRZRJlstf4++hpYshlCj28JX5O0we6evKgYHWHzvBUoSBwiF7grvyftk/9M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774943284; c=relaxed/simple;
	bh=+V11dXg9XM4n91X7xtp3R9uRCYm/Ex8Hkh9nsc/af80=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CgyS4NN1CW8zyEP6MU5JShNU54xqZr86PVM6YjmUcE6JBB8H9EN/Barl4fFlP7VYzFqYp0oQWlyh1OkuZPMNOCLoAZ4hIQ3oR4c4/CzSu2akGQ4ipW47ra8zUEd3gKfpZsnQDQ8LFtzdOxfJZdO0vMmn/pCss80KJ2rkPPpOJHc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=k7sFkP7l; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="k7sFkP7l"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774943282; x=1806479282;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+V11dXg9XM4n91X7xtp3R9uRCYm/Ex8Hkh9nsc/af80=;
  b=k7sFkP7lfnw+TYXTF2qO6ew/B1BDL8WTWBIacpTuU+9GZbLB9LyzepFN
   OfZ03JYY/tT4b+2mZqOWhfo4UMBKjExWiRd6oKdEjMvtAWw7Za4ZJHbvv
   ZRELv5Hvxdx381MpMSDndvvW4XPLU4/NNlgEhHHGYrEQOQu69WachIU0d
   zz7qcMBE3MteWQ5NTvcuKqgdn5kW5tL462K56XW+oDn1Cb/dTfeAlc3bN
   mar79sEheeT7/fVngHdvLwAlGKXdySVVCtkg+YBNWV+akEwNNiYRvZWEx
   CbLlWipp9TuJyDX9vxxiGRlyDOypvlu/IWg3ybOWuu1iKwb5lnuKiN6jH
   A==;
X-CSE-ConnectionGUID: RAU8QVqbQPekhFBSCehksQ==
X-CSE-MsgGUID: K/m9yFwmRTSy4eAHjwmHSw==
X-IronPort-AV: E=McAfee;i="6800,10657,11744"; a="75833222"
X-IronPort-AV: E=Sophos;i="6.23,151,1770624000"; 
   d="scan'208";a="75833222"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2026 00:48:02 -0700
X-CSE-ConnectionGUID: saE521VzTPGhTSWsNrUaLg==
X-CSE-MsgGUID: WreIWhJqSiK3DSyHFATGdw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,151,1770624000"; 
   d="scan'208";a="221420880"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2026 00:48:01 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 31 Mar 2026 00:48:00 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 31 Mar 2026 00:48:00 -0700
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.69) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 31 Mar 2026 00:47:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JJDQVsbJ3M6U/aIuOxNhcH7K9/ySPk26sgPD0SQxcWqcfsxTbEj4Gj2OtueiGK4zYUATH7hev4vXNweEYe0w+27StWCL5RkcUaX+2PSeoC8VEVEEHqx4TqscL7uCcJ+fYAq2cyXo8796gzy57Gl709+PGhcbZP3H6/xP8jfG8cDz/1AA4v2BgHANA3qQe8zCA+E255dayJDv2nAACyrL8FaC4WUNzfxgDE4NKLc39uhiFcJH4wvXyZJGo0HP1OQTMSDguVax77sNO3yo71VP4YQ6VJWEnrLqh4k3HDujmEhGhYACpi25gK2Kxhoc8bNHLD9z+0ukq344+i/IWQxOxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+V11dXg9XM4n91X7xtp3R9uRCYm/Ex8Hkh9nsc/af80=;
 b=d7n6Xng1AqN6w1wvddQu+X7vzayhSPXp+dQUQuT7fXUAdLAgjU3z/CftgK3/JdCxLJ8TEkhCgniVCn79A19mkc1V9IbYcvzEwJQoDfK30vQDZ99jaKakLihS8Zn7SGrB+qNjsN1yQTaCe8uL72OPtH7SzU/5oTEgdCfDFCSchNg9FA1PvfB3NFUWcxc+zoxS7Fs8ImMs3gKTqF0akidN6d1rBaZxPRjMn5PFd1Q0jjhaphq2+7V8VcSQR4lQB4kSRCduZqG2Sb09MkAOb0A9G1qOeg79pLCE3eX3xwYbpzZDxaPDJMYtZlX0h+zeYhKC2/XApMNMKpQTUWS074XRsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MW4PR11MB7150.namprd11.prod.outlook.com (2603:10b6:303:213::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.15; Tue, 31 Mar
 2026 07:47:52 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::f997:762f:f079:134f]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::f997:762f:f079:134f%5]) with mapi id 15.20.9769.014; Tue, 31 Mar 2026
 07:47:52 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>, Robin Murphy
	<robin.murphy@arm.com>, Suravee Suthikulpanit
	<suravee.suthikulpanit@amd.com>, Tomasz Jeznach <tjeznach@rivosinc.com>, Will
 Deacon <will@kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [PATCH] iommu/dma: Always allow DMA-FQ when iommupt provides the
 iommu_domain
Thread-Topic: [PATCH] iommu/dma: Always allow DMA-FQ when iommupt provides the
 iommu_domain
Thread-Index: AQHcvVfaHA86b+nQ9kiyjH114XX3JLXISpYQ
Date: Tue, 31 Mar 2026 07:47:51 +0000
Message-ID: <BN9PR11MB5276B23B08DF829EC9CFAFA88C53A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-9901ec033f96+3cc9-iommupt_fq_jgg@nvidia.com>
In-Reply-To: <0-v1-9901ec033f96+3cc9-iommupt_fq_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|MW4PR11MB7150:EE_
x-ms-office365-filtering-correlation-id: a55e5453-9549-4bd7-7b07-08de8ef9cff8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700021|22082099003|18002099003|56012099003;
x-microsoft-antispam-message-info: HKzVr4+/pSsPQedvgcHf42yn1uztyzt7WHCVr15kMCGK/9cuDILFjuW0cY9WemlTUTVaOElT+U9U9644ZlLnhPeLOUonmU5fExHiJbwIQbA7KvDpS2pPyrzQmqtb1AEUt2s7p8qLohegjed8rClNNH0+Cid031ySQJG+QkYIt9/MYgH3kjF0rJuWZIBCbhe99zm3gospeHqJ4W6l8arjqBNcsGePSzp97iaPqcf7nnOui2U9+vMsAdfUDiB+mxej8l69z1Ma1eqQNvl+WdEnUzgwendk7GT8k/RkcVFSj7C/zVbup+f5x1TYKifIxjJKcdPoBGkyWtRHyG9MhfeoqLbrVYJh+MpcYcC+0IH/oJsMRoDWMjAU9GNCO5HSWbc5HVGw+dG7nxrV00iVNn7trQdLGlzWstMj9a9AGbZsNfvcMkI6ZlFLsEewqgj4eJGjqkj05rB3/iLglcwww7hvIJ/2tfrB7yPT5HBvcK9JbJCEpZiNjuIFaE6rIVMW24o6udHNyHqGlxX1sha0e21YDfJYnjh8LrcVoEAJAZ/011YYn7WXrhzoHbzCx6ts7pS3rc6Bu5jD3RzbpEG9xMNR9D7xG5issW93ON7VFnB3FIQHYn5+GAQ9T/yWxHjV9w7zzsEpfwNo+9x3iWBfOVNTE89pChkG7/1+E3vZ0mJqUZLx3TMUeEMOjYXlM39WdZNDfxiCW+o9lecii5RVksg9q+29QrkOqEwEeeebSKPom3SFkHMPOoJikHAtmoJ80N4p+5jzxxLhycfe/fr6G05epGgUGaR2qW2bPoGEnWSa6Xo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700021)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?2T4KKl0iAwUlgJ3bdLjwC5XXzP5HNkcYtnuru+zQVk9tt35GTccQ0MqRGakB?=
 =?us-ascii?Q?WabDAVE1WCHvDO2oKvcvkCN8vqrtNZF7K7RwHNL9lNuPRTo7+R+B443s/zN8?=
 =?us-ascii?Q?SFiGSQap7lJba5erdnHv7kK2lNkDfYhNyC4UWsB8MdY9nb7uF732zUBpU5U+?=
 =?us-ascii?Q?h8IRJ6kdjHwMnTKovXuRYmbCDyzeIpzeY24D1OyUM1yOs+jMyq+cW2zGYGy3?=
 =?us-ascii?Q?kiHwBPgMsdYAPZNHl7Y3uSWkKj5IJAzS/XG8qFB3XXG/bON0K47VUHVo9wHq?=
 =?us-ascii?Q?6f3W+2vtBj6erfmDLh/QeQTfaRzr9RrgdAd543ORNhTiJjcA7fQtzOIyu0SO?=
 =?us-ascii?Q?KS4coeWm2brwMfEezBM30oAhxivXI3o1I1DIKdm6tW2s1IoJQfQgyuweaSkP?=
 =?us-ascii?Q?qsqv9a4dhsuBJ+DKFdQZgN7Ee2pcqDpCgBnqESWW285a9NiGFw8vtRoc1/Dv?=
 =?us-ascii?Q?jMIsOBUmJm205xOS4mcF1uCUVaktv+PAajKJZYeNGgMdOZ+UCGnD/AifyZJy?=
 =?us-ascii?Q?Mwsx3KtKzPmA0+MBZdfnunOCCz95YrJA8NHfH1bmyBXk9+GRiueyH5fpadX1?=
 =?us-ascii?Q?w1SiHLgB09uCR6mvmMfWS3viZZEzd7WejKtN7ozO3Jz0ZeeLFwPSyeqHJbIK?=
 =?us-ascii?Q?w3bMBsKERdiTnegd4u8IuCZJ+uE7t5qq6yjyZCqSxmA5ZkkS0WigafoxaU8f?=
 =?us-ascii?Q?7YoPIb9Rm0ztj8AJXY3gtgNW4M2F/KWJx5qWd5WePHx3tlt4Vy6LH3kLcm3V?=
 =?us-ascii?Q?jggdr81SL6jq/5ExIE9u4Bx4/2/LtyJgh1U84+Cc2n90P7O8tFy7iDKIMgiV?=
 =?us-ascii?Q?hooPtQR3u3tJA/sOpW6E9BuV44H7sTlgndqtgeCTCxr+q5JCum8Mt81tjW3d?=
 =?us-ascii?Q?9l7qNFG3f0zCoakdh66dJkXt0VJM0Gh31t9l9zJ2PqBE4WPQjLN0yZ5StOeC?=
 =?us-ascii?Q?npB/kiPuRIbVevKWxeAkZZLdBDtHlhe6uhoTucvMdj/2OK/Wi3oYnwJhVsW0?=
 =?us-ascii?Q?fKEjRb1/MZkgDoy7FwPrGtitkXS3r2a4vrFov++AG+nwb5TmzN1aZjKITovO?=
 =?us-ascii?Q?86xEdbr0IW6CXXfrCV2TN74HqGipBuGWwaUTHDVr4Uxus4il09v6LU06/oxI?=
 =?us-ascii?Q?lgX5eXoAfXUJDtv9fuZAKPotytZ9gouwfV9csGF2Ci8zH22PvebmeYR4pYBj?=
 =?us-ascii?Q?UcD8yaOBCMdLCZzJwP84NXQH4NHyMK/PUc5+NOXO+i+u/K+TE4UsstDAYQ8t?=
 =?us-ascii?Q?SLuBGtVvmG8qAQUAvfVY9Ykknx2aL4yEBVcd+XSuPFS3AC4Wsi8u8uZc1O9q?=
 =?us-ascii?Q?/u5P8JscUM98xeVkBDTA7ZiXp8UUxHLrdQK+lO2PGIiaLmeCl43mB5brCUs4?=
 =?us-ascii?Q?aqVv1bWc1N/RL8+ZuO9heoXXobmJHsg2/b/a587ShgDOou2LSXS+r6Y6i7BR?=
 =?us-ascii?Q?+y1cYCvxWRybUhpspJcpbw0XNidsT8m+1gCWVKr1caqGihUR1MMmoG8YOzCx?=
 =?us-ascii?Q?7BnISVCP+V9gKCer6g95wU0cjmTLvCamth7qFj2jTWlq4qJXW4g/HKoXL3QI?=
 =?us-ascii?Q?mCPU6gLGMp1DZ47Ks3O6f2Rp/Q47gz+hGMDdX0zBGffc2umCE0OGiJ0iT8Jh?=
 =?us-ascii?Q?fLFE3sL2ax+ar1SNNu+9xaOwUcKWs5vtoiDQf6ZzYgWD76DCPT0xk8HyhWAg?=
 =?us-ascii?Q?PAg9hfZ4tWEsv+4BJKsHJHqpojjV7DkhAeBGcmA7aCGCDGisWt7RSiEKuuag?=
 =?us-ascii?Q?/DjRYMgc+A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: Kz2ybDsgP9WXhzNJYVCyKVwGGgqDraNbKyASd+Z3nSu6StVIajHGyTMGb5AZXwYBWkw+71pc0pMCQDH3dc2a/utkdQbVyeT7kKEfygRTCMx3omhLi70h3qIPySdHQFuBsecXb1MN5wNLmhKtqqLlUrHA8rXgpjhy8SluYzYe/cS9PZcKsLgm6qeKuO54zkUrWpmMK13O6T0YRRiVOk5WP5bwRM9YkIPyzrYRv/LQaGosBXxBFKy3qPLmveSxliGQ+uFlQbyYGmvVEhXOV0w0r9pqSGiX1L/MwMFdT/gZp0t+ee9gzp8UzWxv0O3sFBazkl9Rw7bT12bY3Z9wb2MD8g==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a55e5453-9549-4bd7-7b07-08de8ef9cff8
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2026 07:47:51.9816
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xYtEZ/AfQ1LTax3JZJqiNxgjSzbA9caEy0ksvjenD2yH2dtwG21KLSxo8+s9Kw2meUMBocccTQAblslFY593qw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7150
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Friday, March 27, 2026 3:31 AM
>=20
> iommupt always supports the semantics required for DMA-FQ, when drivers
> are converted to use it they automatically get support.
>=20
> Detect iommpt directly instead of using IOMMU_CAP_DEFERRED_FLUSH and
> remove IOMMU_CAP_DEFERRED_FLUSH from converted drivers.
>=20
> This will also enable DMA-FQ on RISC-V.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
