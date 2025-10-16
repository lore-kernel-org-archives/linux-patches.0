Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1276B1FBEA2;
	Thu, 16 Oct 2025 07:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760600186; cv=fail; b=JrXzhl+qBhxJ9+mTi2ItYpKy2CmBlQrU1vVX0lqnZDQrSpcxJxSBVELLmsZcrPRnemiKHU+34IsNTd4uClwirP2BDTo58sS1BI4507nas1UyEJ/rlUSZ9JkyWZlsHUe8yNTl+XTkz5bWLcG0Dk0/mXSxdk5/74PXaU9toVqPq40=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760600186; c=relaxed/simple;
	bh=DcfGqiFIutp950BJ/HUu5yhJ3rJTexD0eomqzdCn5p8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OHpcZWisUaq68qJBYArTJlwznQX8Fp8Zmr3FZuFmn7WXC8Yx+8f08JO2Tjr8tVz/BYvWTC3DcqxJPgmiTTO3stm4EigZo8dV3LVxsdjSmN+Bjyi9uZu0GBGvK43IEcny7nn59sjhj4K6rX2LzEQxfHD7QOPHpl5IrGv93S0P3bs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=J/luJgFr; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J/luJgFr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760600185; x=1792136185;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DcfGqiFIutp950BJ/HUu5yhJ3rJTexD0eomqzdCn5p8=;
  b=J/luJgFrbdbAkuExUpQ5rlUNQ/pDcn/geuyZdZ1KnkDISZvi6S1baiO1
   tqc4lP5wqZI34A8si6R5ZKRooq+bE+7+NkJsC5ncBwS55HW95PYftNs46
   KLmq98qYkhXGUv7sGQTYLVP/tcmKsGWWS+zQNcE8NiJ28LOmQFbtKCzF+
   MW9phD8aKDnDzuqIS1SKCZBxSlnV3vGAJult+PuW9iPUxl/cGqnTa7XTJ
   NQjMhg0nD1d7m+jrgoxyAUB+fLlOm00705dY8CVEie3Zq5MAX/c9LUrqe
   Fie32qVmrrc2LHVR7t2rv/NZFK0Tf/htuAOJWIRGIWWCjVLzqWtP8CGka
   Q==;
X-CSE-ConnectionGUID: vwJQagpgQyKas9H0Nmo6iA==
X-CSE-MsgGUID: XLpt4u+FQym6KUzy8pTGrw==
X-IronPort-AV: E=McAfee;i="6800,10657,11583"; a="73386510"
X-IronPort-AV: E=Sophos;i="6.19,233,1754982000"; 
   d="scan'208";a="73386510"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2025 00:36:24 -0700
X-CSE-ConnectionGUID: GEpTL8hmTDyPBHzBp72ITg==
X-CSE-MsgGUID: H00cKYR1Txao/yG8gL1SpQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,233,1754982000"; 
   d="scan'208";a="219545970"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2025 00:36:24 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 16 Oct 2025 00:36:23 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 16 Oct 2025 00:36:23 -0700
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.42) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 16 Oct 2025 00:36:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FKTIGlFeF+WiUrNeDG1rlNfDySz06VX/JZOCJHsH+Aj8uFPAQF9Y0KQiVOrf1uQI47EFSuX17dyMtznbVLYQfCWF/2dm1pSI3vwWserlZtIlGqDvEnSNNGq72ArWxDgpqwQJ75WgO/PY76YoL3fl4EfHA9gtZ1KxvawcDCze0dxltkTVKPDmRn11xCQ+Lt1WZpNwFzPQsMKyCXZFUAg4E/E9AYpfqcIbgSoXxohqYGpkaFN8Exqlq/PHqRCMkR5Oqki7Yy5Q3D9og/YEHZr8DQbc4qvLOSM4log2ugeAuX6k0yd30SpSsp9U773odJKIMfoV8GwRKldiph/CTDKUPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DcfGqiFIutp950BJ/HUu5yhJ3rJTexD0eomqzdCn5p8=;
 b=Lj8t4Imw39HUTtsFCCT5qQioMJsgp0yE8wb0FfcCjrZOV6ra7158BmXVKtv/CF3vzm5htsNabWRYVgKFowNDEVUpjq7cIoMaB7fpZBnhosw4mIRpl/dgIIIb0vHHrA4BTWsskTzTCXqxU7DL35V4IF5ugNwN3/ghjPPBqB1612BiAUxj3YIAnVrBCip8IR2MqjciIpqtAUHe9K+0NHnVzodP8R2vXtDzkaPMQHCdTGgNqdPvMi6rMncJ1pKC7i1AJc952j/CH+xYUhO8JWGvOiLLKLKZKpXYW+LNm2FxKSQF0GejZEXB/fSShlpK18KYyhvjLCS9IhxPxX1wvt78Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CY8PR11MB7828.namprd11.prod.outlook.com (2603:10b6:930:78::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.11; Thu, 16 Oct
 2025 07:36:21 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.9228.012; Thu, 16 Oct 2025
 07:36:21 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>, Robin Murphy
	<robin.murphy@arm.com>, Will Deacon <will@kernel.org>
CC: Alex Williamson <alex.williamson@redhat.com>, Joao Martins
	<joao.m.martins@oracle.com>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>, "stable@vger.kernel.org" <stable@vger.kernel.org>,
	"syzbot+093a8a8b859472e6c257@syzkaller.appspotmail.com"
	<syzbot+093a8a8b859472e6c257@syzkaller.appspotmail.com>, Yishai Hadas
	<yishaih@nvidia.com>
Subject: RE: [PATCH rc] iommufd: Don't overflow during division for dirty
 tracking
Thread-Topic: [PATCH rc] iommufd: Don't overflow during division for dirty
 tracking
Thread-Index: AQHcOH/YMJQ3khRUeEGcntLUBpFKcLTEbf5A
Date: Thu, 16 Oct 2025 07:36:21 +0000
Message-ID: <BN9PR11MB52764CCBFFEC2C88A863C2C08CE9A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-663679b57226+172-iommufd_dirty_div0_jgg@nvidia.com>
In-Reply-To: <0-v1-663679b57226+172-iommufd_dirty_div0_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CY8PR11MB7828:EE_
x-ms-office365-filtering-correlation-id: 530a5dc7-dd06-44c0-f428-08de0c86b3bf
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?rfUZnvVYSrn3q/cYZiXImmtRjAvDZjxZD4OIQEelUM7VWQsP2WB3M3agpfEJ?=
 =?us-ascii?Q?lK5Kt4TG0S1S6ga7u6wR5e8rKOH1C9coDoco/lAiism9Sxrp/Pdoncy/gzLv?=
 =?us-ascii?Q?c6gT5wZ7IOxRf9gyarQuSbbdjGIUgS6F+Ms6zefesHFxoaAkkspT+NPei6/8?=
 =?us-ascii?Q?nZF8szCGkDBMIgZz24m6vefOvSUbOo65Nk0Fyp04qbK3slw758vnHp6zL/u9?=
 =?us-ascii?Q?IoD6PAT9Sz9az/AHO9tmI+ISVpHGQzfkqwLOEHSF/ozc/6hMPVb7e6FJg9wZ?=
 =?us-ascii?Q?pc8zzfaLtbYj1gCRSj447EXyTUDkPZ+lyPiM5F1RFvwyyoMtk+z+XbFObgYt?=
 =?us-ascii?Q?Y5lPIlS5lo0WN9KtivwndglDvaImKGiDFGESYgYwkO2ogEQsTqoI47a8ZNNj?=
 =?us-ascii?Q?gwijXPA+GnJWoZd9veljQ20qA9roXSjneN15pqDCSUDS8F5jj8hvAKd5ozFj?=
 =?us-ascii?Q?TPPfjurfo78lWTD4GduYQVn898n//gnH8csWQYqEgkvQ5xnxY+sc9I39YQoN?=
 =?us-ascii?Q?3aiHZgPrqnYIVDAKkAj/AePqyoSvEnlMDYmquT0QJeVEe8JM+68tAeiMsztM?=
 =?us-ascii?Q?8FRJN0WZOsTAdpsrPSMbBlQiuhcH6Rf2a8duLQHGCN4sebNIw7ZhQ5Ts7TAO?=
 =?us-ascii?Q?3AWSO9P0HkmI+pIeDHK9T8jkaswkrVADzP8ChNBSgOYhx7T6CsiL5Ccjnfmz?=
 =?us-ascii?Q?mEG44ZXlvLgObJr+bMHfu1shSbTyHnLvve+co5LoNkstD9uKIcXQlicgF84P?=
 =?us-ascii?Q?ayvNiJTSeLCpZZR4hgqB11koUrIniMmDRyX+/1VGDlRE1d3n2ESqC91ZlaKw?=
 =?us-ascii?Q?ch0SR12izq8ET5M+AUW/RU0ceFjHBlPCol05XzhXp6SDdoDv3DEUxZjP8yMW?=
 =?us-ascii?Q?UBZW2kBiaxE6Od7182NOUIltpTgxXq994+fIAaQ7Mwi7N00QglZfnESmGHHX?=
 =?us-ascii?Q?CIJxBUQg21Np8qnzn9bBOlHNjlCJBPdeMUUazXEzRF6de5JTcibZK4sXO2UX?=
 =?us-ascii?Q?2z1SroSi0UChL4mucoN1/hVK1SGPIfsTAEFuYvECGTV9CpV5u9JmtjG/Rh39?=
 =?us-ascii?Q?tDbV+nMd40kNK6R/MfMJxIuYXOOVHjdE5SC5rkU3nZSshekhyiB+qXs5G7p+?=
 =?us-ascii?Q?O2PUxXVrf2sJMsG7bsiACz90D+uV4VN3r+QlywiUShKyKcNy9TVmtqptpV90?=
 =?us-ascii?Q?tFcPI7gRcBgIgnkYQUDvnfBHgT6p/rA30Atnx5jyT6FWcBJ8ZPYkVpROjZTV?=
 =?us-ascii?Q?iUiYLO0Ww/cm6j6ThdwuNvuY1AOVTs4BDhko2BNinHGZxtLUNSK/q/u6ulKG?=
 =?us-ascii?Q?/Wfv5dOn56u6vLxBtEI72z4o3HUsmzIZukXUAyOvnCZk3juTMGeGEMp72Ry/?=
 =?us-ascii?Q?n9ZpPxiVCwR+nIeIYTV/XU9j2B42SxEWwralzU5fUt7V2rpz8n1epKbSaEsl?=
 =?us-ascii?Q?WnwSI+Dh3oSfSlUwCjaroxNj05aM9VxBkf/57+4XsJH3FmgQbypqdQ=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?aIpDCS4zfW/UhU4SNQ3p8nOmdR6VHOQqa0GQkGxB8wZovqbKlUE1nruHdfE0?=
 =?us-ascii?Q?4NhcMnZ5aMnmHt66+d6G0gVGwkiVKEEePUBQQUwgBUANwhGwfOliNU6LK+V0?=
 =?us-ascii?Q?drgtDgyLg/L8zYIGCXhY5gD7LK0TeSaA8iud5DEn4mkpC4OxaWs2C9en+Cv1?=
 =?us-ascii?Q?EKL6HZP4rbMp649Y+awzBh0MzjEo3ctjBCPKA3jZZTpwSHJ/ECCSTS0jtQ4U?=
 =?us-ascii?Q?KzkcFXxve2mfYNiX/hSnnSj1WdEjfhyPD2ijsCY1e/P9HzP8dzciS/x4zF2D?=
 =?us-ascii?Q?dSdwXlDZURtuFu2fImH1izjpi4c5kz5eSsZb2fJkkuYnALSZmP5emyHZsvJ1?=
 =?us-ascii?Q?NbC9wVlseaRZHipbU+epAvfU8GwTcT6Mc++12XUAYY7ljM+hd8kR0QG7MQqQ?=
 =?us-ascii?Q?urM9Z647Z35klyqzU0wgekR5X/JgQSL86WG8eZ/e7ilBXKgI/h8hApZOm3xL?=
 =?us-ascii?Q?ljK1NmkNE7odgU+3LJkTl7RnmT3yQJNwTakeQOJaaea/py2XGThbicW3Kysy?=
 =?us-ascii?Q?rcC2FCVAizHcqpfgq3LPeOnNC2q4SXiKzGQYQs9bwE3Y9ejt7n5+Ql7AScBf?=
 =?us-ascii?Q?t5YfWNvnDGhE4udbhw1xqeG0s36EEO9lhriBh5Mnik1PzpWyu4NyxEZG76iJ?=
 =?us-ascii?Q?8UVIa1Q9xX0RqfZDOUMV1zhmPVfuKWc2WGZGYHW6Apny77Acyxw/zZ/6Ei3y?=
 =?us-ascii?Q?hIL4NErPpVBiybFFMWDdyVV8Y3hov9T2KVZfrk2gTWfBkcd2HNR2X2REw0Br?=
 =?us-ascii?Q?JJePtR6KedCAO4iOGEdT7EqEoHPFxMizXeuJPxkvwYjL2V3mYyjVBwJjIvx7?=
 =?us-ascii?Q?Ho51thx/Diq0l8cnsEpqO75katxbjygw93S1nPpn3vputtpj3yEkKhRqCh/6?=
 =?us-ascii?Q?eMyQduo9tqmf8t7WFMuANsgNh/0C0jhiXsioTf0wGz42HbrkIP7xAZUwtdi+?=
 =?us-ascii?Q?bh0KwRaleiP6qXFFDzU1MoAgTALpIPZB9Ii3LzXJFRquJ45WivEkFtJBsuto?=
 =?us-ascii?Q?XEs1dMUIaGowJ/Dwnf5TKzKtjHI0fLullft9w7SqZOjeHq49eokWP7HjEbC4?=
 =?us-ascii?Q?n4hZ+D3BRgbs+r903g/omV7oklWZG8LS4dCq1osyGgan8rlYL2Qt2NqGELPo?=
 =?us-ascii?Q?VHyZj4D9/lyhYCAbv1yqbaGYeEoP+GF9Fogiv8SamSY6enil7i79EPLUMXtm?=
 =?us-ascii?Q?7ZncSPDmPrkE4WaNHxAqFH8czl9GQz4igfJx70ex1JhlJgH+yGhBrh+xLuJZ?=
 =?us-ascii?Q?0HlRDsI7yjMqLFyVRAmXro7wrMxImhIWVaqerJV24c94V3cRRMog0JNkdosT?=
 =?us-ascii?Q?k/47hftVbh4o1dFBENQiy3ovvmcAVtbv4QFfzqUghxfOriZJbuRPPE5ybZ23?=
 =?us-ascii?Q?0XXNybCtwkdnDBouHJkyjhvH6014eZYFSijuP9lKU+tsPmBGT3Z+1VOkdf4X?=
 =?us-ascii?Q?5kBkfbN6bUiaFNvkF1VjhjH/rpauK2rw1CKmopbeEQZr1ddD07EIrZgrfcxA?=
 =?us-ascii?Q?Wa7ChoiLEW5hC9SPGYGSz4o6VWcxq8jlqhHLq4GbJSmNFJJqnzbWtaIT1HLD?=
 =?us-ascii?Q?0DzXlXROYEx7yBwkEqWBLyvxq2L8/+OZ/Q0unt7+?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 530a5dc7-dd06-44c0-f428-08de0c86b3bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2025 07:36:21.3776
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FBNZHfd2Zo0PFNiT4XfKudAQQOyExIZtaFIghAFZTEoEAhvvL+6CrupVziaATMaQ/tyW2NV47ozcoPereVHXHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7828
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, October 9, 2025 2:17 AM
>=20
> If pgshift is 63 then BITS_PER_TYPE(*bitmap->bitmap) * pgsize will overfl=
ow
> to 0 and this triggers divide by 0.
>=20
> In this case the index should just be 0, so reorganize things to divide
> by shift and avoid hitting any overflows.
>=20
> Cc: stable@vger.kernel.org
> Fixes: 58ccf0190d19 ("vfio: Add an IOVA bitmap support")
> Reported-by: syzbot+093a8a8b859472e6c257@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D093a8a8b859472e6c257
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
