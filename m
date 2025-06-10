Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87374288C03;
	Tue, 10 Jun 2025 09:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749546921; cv=fail; b=B2w4K/0qhDJ8Q25HnakuothROOvvNLeOeFUWmJDsfz/u3FPs5MnQTgI2+JjUhDe5aapx11Xw8AO0Ms/wFjrEYf7kspHKa/LGZFmTcgjLiAP+0jdNGQmuAZ1Ia9rhXxJI1NNIhtxd29jsf/i+LCiYPSaeElA/JUIc+B1zojK8owo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749546921; c=relaxed/simple;
	bh=5yvwCirIaFCnBYEqh/w1MMFUw8saqUCYOwZI26q6tCo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QYqVaB7NqY+u2/M6jlEyo7Ka/15IRejPLDEVcpzZKQyZ/old/ly8gB4KhAi+tT4upqw6uTM3Xt6nswNVY7VrCSLQNwoBsjNLv/FSwkDkgNZpPtVUZ2YwoCtNH2fqyfU/olk8Z5B+3U6NBw+aHsSi+fNdNAIv9OFTQC31UwZBacg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CzmfmU6D; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CzmfmU6D"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749546919; x=1781082919;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5yvwCirIaFCnBYEqh/w1MMFUw8saqUCYOwZI26q6tCo=;
  b=CzmfmU6DRXE7PX/ldeWLDOCZOoMGllfv6Ml5nPYXZVfo1hw9DSc3WBvo
   Gk6dJDmXnvXTYYOdM5Zq2Qcnu80nl1lLMQTMk1jOvnutHpiBXoRzAKWZi
   kEkvFXt2wpS/PyajHJi5wjUxJj0eg8gmqv8GH/uyZy+bi6O08kYiaL6eC
   qjRC9WmRpYPohT+07CeBEmrvzgsWFPlNGnoJMHkbbCox8/Ji8m/lDvKnw
   hrFVl/zB8nrq2o0YmOnRDIrST2cjSNrTtbwexTdnPtOD8M3x9GK8c1UZq
   nMp87Bz7sssoG66xniPr2WzV+pIXij4nTAn9JCIfTcxnO1Vdd2HqtUMfv
   w==;
X-CSE-ConnectionGUID: +6fL/SEqTjikdzn0+NaS0Q==
X-CSE-MsgGUID: +RO911kkR4OZI0Dnpt7aJw==
X-IronPort-AV: E=McAfee;i="6800,10657,11459"; a="69088878"
X-IronPort-AV: E=Sophos;i="6.16,224,1744095600"; 
   d="scan'208";a="69088878"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2025 02:15:18 -0700
X-CSE-ConnectionGUID: yRt0FA02RzeiSvVR3CMQKw==
X-CSE-MsgGUID: d+iP3YQ2TJqUSeNQAuSyYw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,224,1744095600"; 
   d="scan'208";a="147714938"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2025 02:15:17 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 10 Jun 2025 02:15:16 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 10 Jun 2025 02:15:16 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.71) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 10 Jun 2025 02:15:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HiFuY5B4Z7KRW8xCBtPT+JRG3qs5Mdx1hfbfV8IqpJAcl+KPPQ+9HYv9jk2pc2g40Ck+bxvVz5AsEK9p0s4qwiWwrHsSQGncnhi/6UMoFr9vf7Yofw5RAGhfLGRvmRKax1W6BjwoCfPdIXL365gauh3vOqnMOayXg09QIFB8fxgF3VLPLMA3kHjTDmeBl/85EpGGHBgTqTkYupu6HMrqEQoub3p9AOEX4xA2a+/ChghxY9K0YunzaZCO5G1fs1Rn+2Bg96gyIpWPNoLMNqop9gYRzRr27iPbLKEgUseeXNU60h6dscTPWxMLRBYf7sqyhHBED5Esy+cyabCpLWJyzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8wx+Ak8wbzRJcu1Jw8y49tK43/YnLjbD+cNcKBB24VI=;
 b=mfcNg2aPnCG+wtbOKh2GbvTWasFr2PxowjdwXJdg2LAqB1dH4xm9Oyy4Om6w7atmjeHfjYyCkUSmUuZDgh6NI7wR88W/miBENXWllgEqvCvHosqVZN2G3Q4Q+58bxgxwgJwVRSOdntMp7kNzwuEqB7Idu5IowqSxB867bcVnUvgLTNRygOeYr214eWw89Y0pwc5WukYYMxlJOhncJOFeR0s//YUSW67mU6oXK3X1GKC+JMt63S3XTBO5nluWCIHGJeL+Xyza9ct5MHcj1Q7srZr1/4UVILs4TatKvPkTRTvp8etKyiWcUHqXXtQApzSF7dCNXT/qOK3jmw7S0g01lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 PH0PR11MB5158.namprd11.prod.outlook.com (2603:10b6:510:3b::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8813.30; Tue, 10 Jun 2025 09:15:14 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::2dd5:1312:cd85:e1e]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::2dd5:1312:cd85:e1e%6]) with mapi id 15.20.8813.024; Tue, 10 Jun 2025
 09:15:14 +0000
From: "Wang, Wei W" <wei.w.wang@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>, Robin Murphy
	<robin.murphy@arm.com>, Will Deacon <will@kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [PATCH 2/7] iommu/vtd: Fold domain_exit() into
 intel_iommu_domain_free()
Thread-Topic: [PATCH 2/7] iommu/vtd: Fold domain_exit() into
 intel_iommu_domain_free()
Thread-Index: AQHb2XjlabS3XE7Ep0Cww2FhMMF7hLP71Q4Q
Date: Tue, 10 Jun 2025 09:15:14 +0000
Message-ID: <DS0PR11MB6373213CD5DC96455DA5AD5DDC6AA@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <0-v1-20c73f153f4c+1895-vtd_prep_jgg@nvidia.com>
 <2-v1-20c73f153f4c+1895-vtd_prep_jgg@nvidia.com>
In-Reply-To: <2-v1-20c73f153f4c+1895-vtd_prep_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|PH0PR11MB5158:EE_
x-ms-office365-filtering-correlation-id: 844068b0-bece-4c9c-e185-08dda7ff4f40
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?uDNyyuuE9q03pbLsHfNigRMd87AYRdCXhn54RWt8nLF5Tl1TeMacGdC63eDF?=
 =?us-ascii?Q?7wfAhxF3DLOaDSoHslDGcURNnsqWVfIs9bPDv4Q3A/Wh5TD+EkkNadLqZoyd?=
 =?us-ascii?Q?/e4kpHG++YxqokGInf7L0YHAaWYd9BA4khpNTEOGFJLiSxxH4gl9/VBwX0ry?=
 =?us-ascii?Q?Z4oUFUR0bb9yB3/pzAPmxVlpS7RyfE4w2+CymmBe46kfQZ1m/3a5Ka+NvIA9?=
 =?us-ascii?Q?FlFUtFUZKEGRzJ62MTcCp8XXb3ppy76AFJdJPXgryDXnvmo7QGYhi4HTBxQM?=
 =?us-ascii?Q?uZzMiY/iJ+vgrr0grVTe8sZ5/O6YABFW7GWj7onDLdFNDK5OfbcOAvMcjR75?=
 =?us-ascii?Q?taCj1FRAgPo+PJFoTY+uNYnPL2/DZebAwwIrMMyL2toZ/gxGtxkxNm+O8cOE?=
 =?us-ascii?Q?lDubnEpi6VWMBe5dO55bOJ3TRc0FYDeQrf0P0Jfg0oh9l8NUBgn5jVH3Ck7Y?=
 =?us-ascii?Q?upVRmMQkRgrSB6FVt1pse4VfMBcg1oQqk7oVOG7kZJISGUymcrBlCKIGQ8GD?=
 =?us-ascii?Q?04qc3l1sfbiucoJ5Kb/eALl2HZK+k08cCi24Bm4PC6eAbLLQojrnkNzVAaaB?=
 =?us-ascii?Q?fVWILXGgK+W6EhZzCEj9ZjELJruKdk0cqRyW/rTVClePDsEVM3erTbbf5UR4?=
 =?us-ascii?Q?LP/lDAYgdiy85+spKb9BL7ko6vDWEwkvtrgmpgVtimfnfPkLaxhMkxrRHl6w?=
 =?us-ascii?Q?FvtYaidjGLKyJKRk2X5QGQsbCk2AV4XRhfoP4S/AvdMP7IpKY9Q084ShV6MS?=
 =?us-ascii?Q?Jw78Y0ZelF3+/RLGHLPhGHolxB+aW/WZs/M91JznGhiuoIwhVhyBXS+uC3KJ?=
 =?us-ascii?Q?1VaShsFiEH2U9MZDdthgi51+GyCum9I3HXMOxK/B02W9bm6HimlRrVSQ/jdd?=
 =?us-ascii?Q?QweyHzkfAYyiykBYc5RcAqXYfMMnzsT01Pb6buqLl+PBuOkH91owtGbweQok?=
 =?us-ascii?Q?55sgaq4uT5ReeDUlVpWQ6W/C9Re36OU434FyaWkCTznvVwq/mIJjgQUihoTo?=
 =?us-ascii?Q?UI4lw8VeHpFQrIVcTFpd6moHhKjLEsn4ic5B+MUFTqe6uW40OSLm1FED5hf6?=
 =?us-ascii?Q?3/8GxniKGbBfsGCaipirQFlK/eRw3q+oLwtKK+1KVr0c9cq2oZg7g7GNFhOE?=
 =?us-ascii?Q?57s2wMqLSBapr24jOutXaLFUmSklKSYui7hginXHES9lf2CmED9dIDNEVKQ0?=
 =?us-ascii?Q?Z9lWLRCQvw0HjoPY37zoJY7FV1js2emZTfw9iZXvNS2SpW9eNea9lImQgbSW?=
 =?us-ascii?Q?lhYq+3nj+bupS3CLOiyqADdKGTKdn0VsRDrP84iKi1nMCfQsAGzbefEpgzLe?=
 =?us-ascii?Q?nOhxoCFrke1IXBeAIakXcHZiUPohWjbp2kOgRMwjEj1n8xBG6YdovV+DWs6v?=
 =?us-ascii?Q?aTw6b7mC0bDRnSXBMae6FjN19L9vaWavenV1QjOmg3pKji+bD9B9NZEi55as?=
 =?us-ascii?Q?ouDorZ+jkT9C7IJKyGRI3B+2NbAk5woGcGlzq1ZEhL6CrKD3PPZUBQ=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?H0mpO1pkvaOwMfOf7uPf4ZmNHAUVSCx7hOA5gAJetCh3lF4aAHMvEfQNl2Z9?=
 =?us-ascii?Q?soejNrzFeLNcraE9mLu+oQ/TeZ3ZywDK+lAYnZIxlNRm2hRq8/k6YM1IQFAl?=
 =?us-ascii?Q?gvbrHwdfpwHhv2F0OGw6jC11Rt/83HBkmp8/WhbTNHvmo7+qnNnq03vGUWQk?=
 =?us-ascii?Q?6NA8tAUDSv7QV9Ihu6+To2eleDSHQaEj7GBSTAKxRYZxMz1lJ9tYO6T/2mOW?=
 =?us-ascii?Q?hZj0oRDQQlofLuakbXiFQaAldUqmjKSzSM9mrAJZ/88uKN+CLoIM5GNFNz/p?=
 =?us-ascii?Q?K/IuMpN2xEfRCFkmH56V781FccjGGwtz1XjT2BugTUKn/ntKiXvlwCVWRRyX?=
 =?us-ascii?Q?Hms/4/YYX5jRrgypyWcllLxBEErKgiU+l20DgYahlEjmn0Pg8NKfGCncDyHV?=
 =?us-ascii?Q?Or5hotyCUdZ8awnwhBiSaT7yogauQTd/KjvTwDxlB9vl+7ERcKUlqgEzTrCE?=
 =?us-ascii?Q?xDG8YXMt9HZY7eo6pnDKJdtgX1sGWdw1gd1w61SD47B9v8VOKA9Bqy6POnZu?=
 =?us-ascii?Q?5w3Om6/2TaQEgLQUQpk+wGu6tJ8EVdNmhPT67P/hk4GWipKWHrC9Mylw6eem?=
 =?us-ascii?Q?b/S/loY2pzxqEipQKPYw0vDOpLkyb9ao4naGwfCyHQ0KGgf2ovE0VFJ39HS/?=
 =?us-ascii?Q?yx1LaFTO7ULWhGKjc2IU1VN0Yt28mqRtbwNr4QXDHXJdqvzxtQPG55SnuTrw?=
 =?us-ascii?Q?2FOLk11N+WDd7JYfBeM0s3N1OrjKG8rc9wNkYHSufCe28Y8SKK2Hc8NiJ7Y4?=
 =?us-ascii?Q?izm1xN4JIhdlCduQR06OWjBqcpVaHLf7fTRFlwrqeCk3TIsUp4Q5Vl/SozOZ?=
 =?us-ascii?Q?Kzya8nDX35O0Zomd+J8AaPTjTNxayo9Slcd/6wyxiqLKUadpgjnezXcEEqHZ?=
 =?us-ascii?Q?2a4drVdPdG4T6LwUjp/JgERA9foWIpLtOFRbsk6D/oC2ADwmvdZqTZ4NuKld?=
 =?us-ascii?Q?tm6iPUHeq/BCNXg6EmESsrYCB7cRfPgzAp5I+HbRXdSkdR2ZTdC12Nmeo1M1?=
 =?us-ascii?Q?EbSgVeExR/t/t7FwbiSvSu10VDgq25WfZV4R8bD4ALcSTpbAR5un/CMtgh9l?=
 =?us-ascii?Q?RCHCyx5Vq+sg2GQo7226gh87qZOFsJCQI1b7H09E2fYZHmBve9Q2eybO6npe?=
 =?us-ascii?Q?dJWlZXlGtQ7JYiJKeaaeOcfFaLlgJcN5AX/dSS+A6E6unQLhNLkBv8JBIrUk?=
 =?us-ascii?Q?T697jlSzq7W89tJ9iw6b1dX+AWX7c9JGJSz+rk5EirpHzk3u0tyO+H3iF25J?=
 =?us-ascii?Q?jtQ1Kd6HAPIX853zdf8Env8tOn9XbvgNHkJymoex0u1FPvSPFNhWOvtqBeyV?=
 =?us-ascii?Q?5Jqa/1X+45t84TQ6y7keeRqtROM/Fw3VyuIXsvefGMMF1T2xPB2RR7OtmJx0?=
 =?us-ascii?Q?RbuArpXIrk6AoSn15bh25eHjW5jiVaQqqjN6O10KzwaCGeBzLDih9j32cD3h?=
 =?us-ascii?Q?MfdczSfnoqU0exIx8L6nm9eEjE3dySXad92Ztj5Rx1M95tZ3cSgJYkG8Ytr6?=
 =?us-ascii?Q?tEP1rlNHoXvUhgVK7DTHTev5WuTkRr7fSKvRQSef6a7PFI12xVb5X7mcadq8?=
 =?us-ascii?Q?rlvrOSbEr/ySKhe6BMnwChEpbbyLvD4WR9p2h5xA?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 844068b0-bece-4c9c-e185-08dda7ff4f40
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2025 09:15:14.4316
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1//x8oFe7sTFua2XZzRzfbOnLgtpOXInZjFpyKOl1+KHrbAEsXzasehOhoCP76uwwz42K6UW9fiGLgwJEgc0bA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5158
X-OriginatorOrg: intel.com

On Tuesday, June 10, 2025 3:58 AM, Jason Gunthorpe wrote:
> intel_iommu_domain_free()
>=20
> It has only one caller, no need for two functions.
>=20
> Correct the WARN_ON() error handling to leak the entire page table if the
> HW is still referencing it so we don't UAF during WARN_ON recovery.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/intel/iommu.c | 33 +++++++++++++++------------------
>  1 file changed, 15 insertions(+), 18 deletions(-)
>=20
> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
> index b42bb091088ff5..ceb960a796e2ba 100644
> --- a/drivers/iommu/intel/iommu.c
> +++ b/drivers/iommu/intel/iommu.c
> @@ -1396,23 +1396,6 @@ void domain_detach_iommu(struct
> dmar_domain *domain, struct intel_iommu *iommu)
>  	}
>  }
>=20
> -static void domain_exit(struct dmar_domain *domain) -{
> -	if (domain->pgd) {
> -		struct iommu_pages_list freelist =3D
> -			IOMMU_PAGES_LIST_INIT(freelist);
> -
> -		domain_unmap(domain, 0, DOMAIN_MAX_PFN(domain-
> >gaw), &freelist);
> -		iommu_put_pages_list(&freelist);
> -	}
> -
> -	if (WARN_ON(!list_empty(&domain->devices)))
> -		return;
> -
> -	kfree(domain->qi_batch);
> -	kfree(domain);
> -}
> -
>  /*
>   * For kdump cases, old valid entries may be cached due to the
>   * in-flight DMA and copied pgtable, but there is no unmapping @@ -3394,=
7
> +3377,21 @@ static void intel_iommu_domain_free(struct iommu_domain
> *domain)
>=20
>  	WARN_ON(dmar_domain->nested_parent &&
>  		!list_empty(&dmar_domain->s1_domains));

Not sure if UFA could also occur here in the nested case, as there
are active s1_domains nested on this domain, but this domain's
paging is going to be freed. If so, we may need to merge the two
warnings and return:

+       bool is_nested_s1_active =3D dmar_domain->nested_parent &&
+                               !list_empty(&dmar_domain->s1_domains);

-       WARN_ON(dmar_domain->nested_parent &&
-               !list_empty(&dmar_domain->s1_domains));
-
-       if (WARN_ON(!list_empty(&dmar_domain->devices)))
+       if (WARN_ON(is_nested_s1_active ||
+                   !list_empty(&dmar_domain->devices)))


> -	domain_exit(dmar_domain);
> +
> +	if (WARN_ON(!list_empty(&dmar_domain->devices)))
> +		return;
> +
> +	if (dmar_domain->pgd) {
> +		struct iommu_pages_list freelist =3D
> +			IOMMU_PAGES_LIST_INIT(freelist);
> +
> +		domain_unmap(dmar_domain, 0,
> DOMAIN_MAX_PFN(dmar_domain->gaw),
> +			     &freelist);
> +		iommu_put_pages_list(&freelist);
> +	}
> +
> +	kfree(dmar_domain->qi_batch);
> +	kfree(dmar_domain);
>  }
>=20
>  int paging_domain_compatible(struct iommu_domain *domain, struct
> device *dev)
> --
> 2.43.0

