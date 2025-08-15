Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F8A0225A4F;
	Fri, 15 Aug 2025 11:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755257292; cv=fail; b=KDab5iynLj9basmyRcsgkMP2zdxP6ODbDjSQ3rCh6P75r77OzBSFbeZwaUEcrjHfFu98Ap19iV2GDiUIH0X71QFuVYcrrGVT81uSXXqUWpHzWIb2S2j8wFCtroDgkDaKgrW248M1f5zHRxJPHFFCys2eKVPjaoJgJYEHIhweSDg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755257292; c=relaxed/simple;
	bh=RqLPbYLFeTF92ADj2NRJF7iASCqE3o+L28wp7J06sVM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qwqvElvd0FadBveJ19GzEdHiHKjmRnE9AJDG+jKUvO+7ZkO4osAKZ2O0mPlNAjyGvtQMjfDCD6VFkY02HzYjwAXmtbtKHP4RFAefM1v7+8imVSTqCJHpRX7wKRZAxMrrIbwI2SIqUMGDfM64blqFSyurFK4j8+pEiFL9CLnc54Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EwTIfnH/; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EwTIfnH/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755257290; x=1786793290;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RqLPbYLFeTF92ADj2NRJF7iASCqE3o+L28wp7J06sVM=;
  b=EwTIfnH/VL54sIh0t4F+FARZLJTGuFLyDy7vo9gyFyrELzhn/pJ9ZBqA
   G/qekmqqy23e/3DPpAxiCuc8lW+env6suD8z3eGuH7JztLj2CPID9GTIj
   vDuN7Oh+Erfysn3V2kYLs6yVLc2VOe2agG9ZSf9KoRXsbwroAOmhrH2lu
   6en8+fFK41a0PBNtkA2dpyr/KmbdvCGpPDgekvzFsUmwWnbbrDdbTfzEj
   WxAEjXboSLgG/zrwHMaMY/N/RsExPWkCCXhlsOg5K3/pS6FAbP2xgLNlc
   X8neaguFMFvEGEYhxLtqphK7zQ1DdTmpL0GenHrkod3QYhirkYFIQZYVi
   g==;
X-CSE-ConnectionGUID: ZfXuXxcZQzWBLkmj0b/2oA==
X-CSE-MsgGUID: VMD/yJmRQp+aPYVP3hS+og==
X-IronPort-AV: E=McAfee;i="6800,10657,11522"; a="75147290"
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="75147290"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2025 04:28:10 -0700
X-CSE-ConnectionGUID: 5rmw6pmVSG6aluXonMAbJA==
X-CSE-MsgGUID: HBiKia+1RSW2gMy2ec9YLA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="166489224"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2025 04:28:10 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 15 Aug 2025 04:28:09 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Fri, 15 Aug 2025 04:28:09 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.60)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 15 Aug 2025 04:28:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PEK/liZOqVa4THWNJ7f+ZJvi9YNHBajB5cfcFlcElTuoyF2iesc4pS2adrIa3FIWGrJjjvjwfdT6JfPRhTXgld9FoWQlB56OnptGcYIM8mZWxQw7OekRvaC2iVywIZ8Qynsa279NZCSEfpWy5BROqR3AFFpIWkXqayYKeB6EzxoWjNZE4N6oPLGYl4Hju4sTJBVMmXk+EM6V+nBPmG/iArw9ybDg+23G0dyWsV/SIRVoKs+DTXBe74HQ8H44dYz1btryRXdfzxxltFm83/E6+tNlBDmI3i9zN0EeLu1JdjCfd+niD6xEg7srXSoDpbuThrdCurzjFgL4Pfgb+F2Z7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kIkMxE2Ouz7Xc4xGO+st0SLbH3o8zSzuGCP8+6B1w0g=;
 b=BMn/EtEDSU6L/Hcu9lpw56SFPDa1FPJQU//aMYN4L3E3kmyG8k0ZceR3fL0BBB6l1Y+Jhtn3rQJUDaPEP9/0XIBIEAYXG29TG/+sMjnhdeR0yrAwp0FUFVRu75nLMYSAmBaQ0miqHpd/VDn5M/V+YjY5+Ga56FhFv+R3VkQo/X9pCO/nHioQDre/p8HlnE9+bO71WCVaOoSf/6oekiJExgZSGrXBNuE92qne5hIKyyw3OiJQRG8yPy1ROAGVU0o34Y7U6D+A8Iouuf39/j7vCWk96WCACYW129RtRek+kRDEBa9xbUOGyzp16xVxSjSQM/uZI/VxlQQZE7/f3nxDrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH7PR11MB7549.namprd11.prod.outlook.com (2603:10b6:510:27b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.14; Fri, 15 Aug
 2025 11:28:06 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%4]) with mapi id 15.20.9031.014; Fri, 15 Aug 2025
 11:28:06 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>, Robin Murphy
	<robin.murphy@arm.com>, Will Deacon <will@kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>, Tina Zhang
	<tina.zhang@intel.com>, "Wang, Wei W" <wei.w.wang@intel.com>
Subject: RE: [PATCH 1/9] iommu/pages: Add support for a incoherent IOMMU page
 walker
Thread-Topic: [PATCH 1/9] iommu/pages: Add support for a incoherent IOMMU page
 walker
Thread-Index: AQHb9ovyoMPi8J+MJkyGazqJz38ZEbRjq30A
Date: Fri, 15 Aug 2025 11:28:06 +0000
Message-ID: <BN9PR11MB5276865229DD850CFA873B448C34A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-bdb01ffac49c+be-iommu_pt_vtd_jgg@nvidia.com>
 <1-v1-bdb01ffac49c+be-iommu_pt_vtd_jgg@nvidia.com>
In-Reply-To: <1-v1-bdb01ffac49c+be-iommu_pt_vtd_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH7PR11MB7549:EE_
x-ms-office365-filtering-correlation-id: 751d0b0b-892a-4ccf-2a58-08dddbeece2c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?+1YmT4ASK1iN4QpWcBDuJwz8VuEM1lJ709MPqNcjG4hs148r9Ak7G9Pv5iWw?=
 =?us-ascii?Q?w4Z2wxVW0xSiYVZ1NM5AXcU//lDqnO9gLZEmYNL9bMDwJWVZj1QiX75N1psh?=
 =?us-ascii?Q?oqL5UzfCWkITnyTgnvsVwzYPv5a564o2zakzpWQhaE9DebPrQGBke3UKDN8g?=
 =?us-ascii?Q?XcFQGUE7sJBdZg4My8QhAIWGL2qj1JjV4HG+4N67DXsn6WTCs0RST8qwglwV?=
 =?us-ascii?Q?KTi3BwATMTSPelu0RnR1ef8mdmaMw4i67gWY9FFAPxEEdxiZM3NWTV/qSVFL?=
 =?us-ascii?Q?hTKSHT8U1CkTpNRQ7bdrqMpSoo/kB59FUKUHvyGrNX8cncGFaVk+Vs1n699B?=
 =?us-ascii?Q?GXKXq93a94uNIXi2XoJAobaMmjrgpZBDaAcpYmPfirhMqjfTH9hnmACK1BHW?=
 =?us-ascii?Q?CMzM2Ga23+2PYXiksIPbYHMcuC8+t3ZBMhMiVgR2h0aSXYciLfu7LZFGt8ob?=
 =?us-ascii?Q?vzO+PSalQkSJoWLgoRQ8qOGIB6bRBCPgDeLAaEmCzEYueHoVhCBYnaGEMaa9?=
 =?us-ascii?Q?0sR6lZQBfVB64aSrmv05UHPfOj8uuLTyr4VTtJwd6OoEwRAdhYAkQ5GioVS9?=
 =?us-ascii?Q?v0cUrFTsPNuxAFYyQQ+nTLlY20QlA3saH/fiIcwZAwsS8fn9+D0EA6fwCiIf?=
 =?us-ascii?Q?vQd5J8r2SRjhgr4g3b6ptZIbVC/cXJcL0u0KYcAmOluYRXvrY9NKhKDrhWhY?=
 =?us-ascii?Q?T4ILXai/tJsb4e5fH+T2tz/9SVKVEKdQ4r/KkP9Xr6USGk4JZiH7sGQaq38t?=
 =?us-ascii?Q?Tr1S5FWbOs11SRsy267p64F4FcgUvfnmOZ8n3vjmFnIHoxCs16XEukwijk0O?=
 =?us-ascii?Q?HcJ9aCFeKlCoQZVtA4pcW8m8lMSHS8zaeZTl0CmexMc4XWzNtvbeT0soqVp/?=
 =?us-ascii?Q?cwVlFPcGmQR8LdlRR6EHnfiS0JfokCMrUERVlnPbwBUSdv6WdtFKoZwoNXP0?=
 =?us-ascii?Q?CuPhULa5v7Q26GR0YJJKUmpcZdbUu+IpC5m6RAGC6DhUpzzK4fXIp9GiK4NH?=
 =?us-ascii?Q?9Gzl/mJlPAPg7+YiFQHLz+SHdW4QMe8rK2CFlZfMjLR1pl74cWHn7VM6sfSD?=
 =?us-ascii?Q?l5g7DfaXe9ojZNITVXF36yU6G9Z4GZHgDlonhyALvVl5l9PbX7WJ2cbdZi+X?=
 =?us-ascii?Q?bSiu3sUidZ1uLwo3BwfUIqk+S95vDXcDT3DjBI+wuA0kg6JN5ViymPiul/El?=
 =?us-ascii?Q?8+kQgdhgE36jLPEEc9OktgQF66TOGi8i6YcKvIbtTeyswTNfQn1WXyeFGmBf?=
 =?us-ascii?Q?kRG3a6EuF4JtBu41Z2FdkTLVJ/3FC9vjYFZj+/8t8WY7VpcqqrmD+wWZZoTN?=
 =?us-ascii?Q?LiyxWxGQlQcmJ+zximqFwmmz8t1nhZGXr4GHfolB9y8WhwNH2kBvVqZSYncF?=
 =?us-ascii?Q?xByQQpjsRCRk6Qv+tgWeG+Dn+EHj5QtcEB7pyav7FORdZdywMHMfAivkSDUj?=
 =?us-ascii?Q?TqkvGVyU2E+CkUruBY5YxNDBMeX1KUPRvM3OhbZYI587bllELq5CQw=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?vyQetAnlnt9d3i0fiEI14SdOYm2032UbHmqyXKh8CD40CLe/m2it2Ty6r3sx?=
 =?us-ascii?Q?mOKOutQZE4Eulgu2c9b8GfY06DMVPUMurwE05l5KWq/L4api7/cLZSP8I6D7?=
 =?us-ascii?Q?k9MIfK8WxhZXwyPBmTngqO/O6EHudHkf/+budPw7g3jkMVoYa/YjLv094PVS?=
 =?us-ascii?Q?dpB8FPiqdsMJjaW7/7EvPipScTcr/Oh5u7X8wlLLFSJ5GR6CbW0fKei93qn2?=
 =?us-ascii?Q?iLzoBiQQSl+EachN3XIXAkt7PKmB2u1i6eFOOWeDa+cd36GTBLifXHK2ySag?=
 =?us-ascii?Q?2PFVKn41K9ITtpEvDrHFqBS2UF9LwqlDP3OkNQTJwX/xJNHE6ZtiMnu3LSHF?=
 =?us-ascii?Q?fzNtBXGkOfiFA+L7iOtCjRNmuIMGrw+uRE63zPN4pPHql4FrzkJVtMEu+dLn?=
 =?us-ascii?Q?WFUOVQlmSJxFwRHS3itst9THRlUnulSw2k1UD9J4tve9nUqGsRzYFFPkMpwN?=
 =?us-ascii?Q?gESkGfphw6Y6+WyBeZvr8+YlBpcoy/FsJ+RG8HTuACDveaMVwBert4AVc/LW?=
 =?us-ascii?Q?sSeDrDSqCSKLr5H9BRgpYjeWe7Kj8ONSTDFs9xwIamEhktHrpCF6CUeGha9M?=
 =?us-ascii?Q?UTFUJqp1NMHEL9xj3TMqNckhPpnGiwa9qiUqSJi12looRyE8lRP1z+nVKVy1?=
 =?us-ascii?Q?Zu9ZpwZspjd81iQnlNNEHgT+q6xw5RnIHdcJpQdwqzbpYugHRcCfVCpLIvW1?=
 =?us-ascii?Q?RaRX5s4g9Trhevt1NjOTmKUSL3SIEgro/Tae0jHlelEni+lPjQtK/QGdpNvq?=
 =?us-ascii?Q?DegdeBn369jTSGiecbXyXngFwBNE8J0MV+fnzyy4c57J0PBmC92+TKwwAzfc?=
 =?us-ascii?Q?KFo4bPhvJSgjQLELrR6Rn8JoSMdwfFV7kphWtj1Sg7goMsrDqUooEul/EHhl?=
 =?us-ascii?Q?mlWUhg+4Bccbr+EYu7GzIqQwS18bYgCge+iLTZh2xmxe7QZABKdAOnkMwLtN?=
 =?us-ascii?Q?sYDfS5Ew3mXIQEzG3CMHUBqbOQ7TaY6xDCjreSmrGpE6SYa8MNJpg/9qKhy7?=
 =?us-ascii?Q?dZu9hB4D70IR5dn7epgEPLL2fN+WZpVL7g12uzZLMeTTXetdzmznRStijoZy?=
 =?us-ascii?Q?5GfmogKYT1fy76ccA7rXwDQwKtAY3N5GyxJnxy+4JyQ5MrYWVjnBIssC5gDc?=
 =?us-ascii?Q?GyW9wbAjE9q8XILJMZY0SYHwb4n5cqDv2WNCjN+hm3u6kOFwoA0rLhXB5xOt?=
 =?us-ascii?Q?km1Xn98j9JfKF/wpzj1QxsKLdqrI+KryFcg1hV2xkfy0EGXJM/jnkCVMUf8H?=
 =?us-ascii?Q?HBL5/AgHWXcCGYw51z6WCFb81P7Rm64AGrUvS7GjR4NBbQy70sn497YVgOJx?=
 =?us-ascii?Q?tcmTt/onAxTHVGefHxdnwVIXzPyZwyxGDnT3Cd8vo8BN5zOPio4SrfJklgvC?=
 =?us-ascii?Q?0unYhdQtvwL6YT9oYkpQNVAPgmsGeH6UgFoM7l+w7Hpt2qL/HSs1G/JQeZgl?=
 =?us-ascii?Q?887e8Pa3L2sp+N2hJVecXLxGWNMjnvBu1HEo5mEipi5Q+WDhOU3cy8jlsRxz?=
 =?us-ascii?Q?IOvRs0f02Ob0K5bebDlNdVMs1Dnl8vhZO8TRdAyqL+VoWP2BWgO38gCzY2bu?=
 =?us-ascii?Q?D4Q51mHpeZ8u7TPUS/9PD0q95YbtaPaX8mpP7Ebe?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 751d0b0b-892a-4ccf-2a58-08dddbeece2c
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2025 11:28:06.4115
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qaEOCiQTJRJejGJ7SU/vkgV6c2udNET/u/2ZnqqbynDVUwsw0UCQt/U6KSpigw3Rd7JUAeO+9uFqQt7oByMtIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7549
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, July 17, 2025 3:58 AM
>=20
> @@ -82,6 +92,9 @@ static void __iommu_free_desc(struct ioptdesc *iopt)
>  	struct folio *folio =3D ioptdesc_folio(iopt);
>  	const unsigned long pgcnt =3D 1UL << folio_order(folio);
>=20
> +	if (!IS_ENABLED(CONFIG_X86))
> +		WARN_ON_ONCE(iopt->incoherent);
> +

a comment is welcomed here.

> +/**
> + * iommu_pages_start_incoherent - Setup the page for cache incoherent
> operation
> + * @virt: The page to setup
> + * @dma_dev: The iommu device
> + *
> + * For incoherent memory we use the DMA API to manage the cache
> flushing. This
> + * is a lot of complexity compared to just calling
> arch_sync_dma_for_device(),
> + * but it is what the existing ARM iommu drivers have been doing. This
> keeps
> + * track of the dma map inside the ioptdesc so that error paths are simp=
le
> for
> + * the caller.
> + */

also talk about the x86 specific case.

> +int iommu_pages_start_incoherent_list(struct iommu_pages_list *list,
> +				      struct device *dma_dev)
> +{
> +	struct ioptdesc *cur;
> +	int ret;
> +
> +	list_for_each_entry(cur, &list->pages, iopt_freelist_elm) {
> +		if (cur->incoherent)
> +			continue;

Is it a valid case to have the caller pass in a page which is already
made incoherent?

If yes the current definition of start/stop is not strictly no par, as
there is no record whether item->incoherent is set in this start
call or left over from previous call in a failure path. Then the caller
just passes in the same list to stop to cleanup which reverts all
items with incoherent in the list i.e. more that what a failed start
may change.

