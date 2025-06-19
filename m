Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53C03239E8D;
	Thu, 19 Jun 2025 05:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750312187; cv=fail; b=Bn5iUJou8ie+TTCetesJanhmPWlbfP88GeAbpuSaX8aZWRlYFjgAlGegfbWtpcvzm+OIFdvsv19OZs2M71tvlEMfxrxfTYHeGWeACy8nO4Z2SrtCLGBaqXDR/7A+YMW6Wz2GuTH2EKtw4BMGoIyTgcLHFwVBfarfv0Wtrdhnx8Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750312187; c=relaxed/simple;
	bh=lSmnNjTiQ0e34lMvLVVkvT2cXZRq8h0mw9v0w5LFZOQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Wq13j56TjnADyXjpXqZjOcfDUMF3uQKQgSAzY2SeEIfiyhUHoovIRcYziKjNkx9x705dwoCGJLAIHMnDpTVf9blp7ryLAhWJ2dNj/Fl6dGpFE162wstEd8OGh0zf8VDN1+9uhyBhQ4gNLIN2eY2WI7xLU+FekrKgwsLsketKnrI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E5u0sgxv; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E5u0sgxv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750312185; x=1781848185;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=lSmnNjTiQ0e34lMvLVVkvT2cXZRq8h0mw9v0w5LFZOQ=;
  b=E5u0sgxv4LGEwlr7ldeKf0U9WL8Yjv5nCdz6VaFnutwI0nV1+/Ya47PX
   b6SRhKnD3g1y4uWGTGvHQjym2q7cJHSLwkLNF6FJnYzkpAjVrjs7izmaY
   i1fDSKCWxy9FSniTtusCWNoZUwGM3Jg0RvOCFHk54VL4bvwrg92/5vaUZ
   r51ROmvj8qRGD6HCgsJDkw6J7BZgWq0E1y+xEn+49pLSKeH6t+kY23Tnj
   QJ+ANH+r2EbnsRGsCMyWGg5OpMOsm9HU/8GLlpckN9lKqYmuZbbMWKHPu
   dQTbSRJ26drMZb9qZ2Wz0/eNkbWIf79IRFZp5NTShE5FWYNpUsQ7R7e/r
   g==;
X-CSE-ConnectionGUID: KDPJEXFmR42Z9VT4VI6lmQ==
X-CSE-MsgGUID: 7tiCvmTiTge/I3vqvCd4fg==
X-IronPort-AV: E=McAfee;i="6800,10657,11468"; a="56239327"
X-IronPort-AV: E=Sophos;i="6.16,247,1744095600"; 
   d="scan'208";a="56239327"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 22:49:44 -0700
X-CSE-ConnectionGUID: ShnkDNMzTSWKI3P8MEqixA==
X-CSE-MsgGUID: IfMLNPsIRuSdPTItSeEdwA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,247,1744095600"; 
   d="scan'208";a="156004863"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 22:49:41 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 18 Jun 2025 22:49:40 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 18 Jun 2025 22:49:40 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.83) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 18 Jun 2025 22:49:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UUMxyOznPd2Vt3xUS2ctzM9Z8Oo7rykadTqykAbR3sn6wl3kyNOYoBP7Ts9UsNjFi/vRQxmwBEOqf/Xpp8RjShH4QEeQa9hAvqPchf7WRnMHNIXHOVcLjV51xxLYZ06G/vjvKm4uHhwxpFyF9Xp6w6ulAV7Ow8wPeWNWT4+eKlhEqnLnYmKPTGFYLL0xHgwkqd3i/ENcf1qLNW4hE9orDUpKjWpdmB77rj4DN5azOQPJkvBblgoN1zh1cEWr3I2XazIh2Yl/HwAXO6Ufq1kDXhDLdtNdNpTS5C6yJtLuTEBigC22r4KwUynZEK78/ICehoJfb5xKIUnlLFtMs7JslA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lSmnNjTiQ0e34lMvLVVkvT2cXZRq8h0mw9v0w5LFZOQ=;
 b=KaXM0+tOT//u4ZGyADV0X6Wv1WtHPHZAw8QG/1o26uuEzfYECfcxEiLntD0EyC2RrS13u92CY774ZVazTMzaHnipFsdloaEyYba1yqN/wyyOa55uwqFdckYza+cXO3OKPwEfJVbx5NywT+R4YM2A8ItCo28c4jgCUq6OlLyqhcSm1ol21lEKVYi7Q5lPYZFlN2+68KKgrG4yI0BCaj/h7PZ4UnaHDD9mwq97Wc3IqPP2ikn1v59VrioDdhvLnW9IaKoBZcTDCDsEoR5FuBT8CZMQyo5jt1fZCaj6iIxZuvWOvSmLesxZbVJifY53w9qk8eTVitisP+uOMohQnphTgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH0PR11MB4854.namprd11.prod.outlook.com (2603:10b6:510:35::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.28; Thu, 19 Jun
 2025 05:49:24 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%4]) with mapi id 15.20.8857.016; Thu, 19 Jun 2025
 05:49:24 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Nicolin Chen <nicolinc@nvidia.com>, "jgg@nvidia.com" <jgg@nvidia.com>
CC: "will@kernel.org" <will@kernel.org>, "robin.murphy@arm.com"
	<robin.murphy@arm.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"praan@google.com" <praan@google.com>, "Liu, Yi L" <yi.l.liu@intel.com>,
	"peterz@infradead.org" <peterz@infradead.org>, "jsnitsel@redhat.com"
	<jsnitsel@redhat.com>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>
Subject: RE: [PATCH v2 14/14] iommufd: Apply the new iommufd_object_alloc_ucmd
 helper
Thread-Topic: [PATCH v2 14/14] iommufd: Apply the new
 iommufd_object_alloc_ucmd helper
Thread-Index: AQHb3Pasg39ou8os50Sac2dAvdlD9rQKAcwg
Date: Thu, 19 Jun 2025 05:49:24 +0000
Message-ID: <BN9PR11MB527653F4EE17B65F1571904F8C7DA@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <cover.1749882255.git.nicolinc@nvidia.com>
 <107b24a3b791091bb09c92ffb0081c56c413b26d.1749882255.git.nicolinc@nvidia.com>
In-Reply-To: <107b24a3b791091bb09c92ffb0081c56c413b26d.1749882255.git.nicolinc@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH0PR11MB4854:EE_
x-ms-office365-filtering-correlation-id: 78b6d42f-01e1-4534-078d-08ddaef50bbe
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?BQIL+Fmix09FhfILNc1HSyDCc76yAwTc3VnWrzOdglmhjJlRV9P/RFp5WScX?=
 =?us-ascii?Q?eRrOF0itQnQl+zG+V8KDdpt+IQ47WujBt1AcCEAmmptNPn2n9CwexzcYyoPP?=
 =?us-ascii?Q?aRkXA5aZ/B92qUD01Yl8Y9nEaMOAb1wv7xMLKPedgySrPtFBwAq0uSZOIOu3?=
 =?us-ascii?Q?0obH52TEkpooJykTRgDwchI3vHzysmFQ3vQe5IZzXcI0wVjaUhRj0L3/MjK9?=
 =?us-ascii?Q?UKjK1OTU+JtUy4J1RuRRA6M6n9kRw+KsXk8Gk6LTGRTI1ISBfQela4QVfOMN?=
 =?us-ascii?Q?gTEACEtPurZdfRTHwDgGqFNFQjrDZSbt7gWT1xLeFHpk7HnBeQYDEE80Z16C?=
 =?us-ascii?Q?IoaErwtY2lDXTSPnPyXHadFJuvjdCsOOuosuPYwRSyia0eb4eEQy4n532A32?=
 =?us-ascii?Q?jMQM7X2xBU8ZtRzYVbyMM3isq0DZGUUPV2Qz9WnW/G1C3qTqTteSdIwCESPT?=
 =?us-ascii?Q?tjix37XJ33OGB6v/tfDGKZwhlw6LyII2/x46hyGK32B6+qR/pVcQdM3idNAb?=
 =?us-ascii?Q?Rc+cEac+YnmqxDU6TXzokRZmivBwS4AKJPQlYdgzkcVd5CTDKcIILd6J9hZP?=
 =?us-ascii?Q?B6oWt9oY7vE18HZtjQc3n19jCt0oLHFC+E56vUSchtKMzm2s73zp9RWIIfQ7?=
 =?us-ascii?Q?nyxSXd3SYrnyuvvQ5O7rAmHIC5YxKJRucLeAiZJBLkJAfa309yuqcIBmg0xy?=
 =?us-ascii?Q?LE2D5zC7WSkqtocVmOIohLcd272dUQtF/XDaQgmIKOzweVon3wSupNez50xO?=
 =?us-ascii?Q?8HTKRswxO3qBLTsS5XVYqkE3Mrhu4BnymVrVi3Z63/uZt0jRK79I1t/FLIqi?=
 =?us-ascii?Q?lrGQ4xKe2CPEV3AYlOvn2I8s/Er+8UaoW4oXPyzQXy3zRoUH0KcyHLfTcq/h?=
 =?us-ascii?Q?Ua0aSBDUkMUBIpcyVXCheCHOOUWwxNrg3lThK8dPDTdt2O3POO+dJ+8nVzXx?=
 =?us-ascii?Q?pFO/VwwZk6eoJe+Cw0e4fxYA3bTjnUcx208tjhLVYXM4yhuKdQUocXmZEMfF?=
 =?us-ascii?Q?Vzi7Kz2faWz1QA2sbgS0cWI0N455qdDi3YMY8F4G40+9fJmdfTQ1+fkfJ6is?=
 =?us-ascii?Q?dRaNGftYCAo5VA2RrBGu6IM4rcNeIjfWk16XXOZPqlT7RhkI9heGTG1p95Pe?=
 =?us-ascii?Q?cmFkgomtuLF+lvbQjz1BKk57nsXV0ntK/5cyqjD91XZdC8R46q59Tpq2IisY?=
 =?us-ascii?Q?zIk3h0FXns/Zaga3cdfogI4GX6BCFahOB7o9H5vIcX0REjEcWtcfy4AskxJr?=
 =?us-ascii?Q?BlGH3pVQSpGoonyIpp300xn86z34Aa56Js6JT4ev7eIvlgS5JX2sF6i0e2IP?=
 =?us-ascii?Q?gT11WnnH6iPKEsr6ybsKq29qterF42bC23XG0SVRmIWD+WAhSakDGwdsmTbj?=
 =?us-ascii?Q?ctx3llY6sfwgbSQZ1F0qOkOIk6qA43J+3GaqcaI/2loZcV6pw9Eikd/rzdzp?=
 =?us-ascii?Q?5nUDvmE6Foj69GV39AjIH2aaR0gMKBCL2wYt8SMsDb9lM5fK/ePM3oPF6t3P?=
 =?us-ascii?Q?3ZJXRa1kvZi3WXc=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?6JtpbH73pgN+YGv3HvIweKEq0Y1tDgMFgqkLmKJSmU+2dLZ3RX5vgvumiN9d?=
 =?us-ascii?Q?e+K5v4jtiDqnAaGF3XvVy0Bh79TrbOj0GejFIxCxgpli2RuqMtpxavOHAIBP?=
 =?us-ascii?Q?qmvBhBe/u/HoxYc+Q8qnaM/ilxK3ldF17fGQTnTmBKuQkPoiSVJQy2dEbDhv?=
 =?us-ascii?Q?tcA7fUzlSpRTK9T1IRw0lTeg2SKSKm1TAPCM7knDjU4aP84mAa7nJ5hTLS7Y?=
 =?us-ascii?Q?/a2xCKpySTF85JielpeoS3t1xXTcFDfLQ70LBPwWzaSsdsSuQx+EASOaSOSV?=
 =?us-ascii?Q?BjIgGfb+SqmWAFKU6mvAtf7Bhf/NklV+dk96Ipe9mKNPcqHnGsALmXXtZdzg?=
 =?us-ascii?Q?UA1pHOaUJecdNZxPi62c0395Lx436cYlANlB/uIzjNGKRvJC4mSEOOZ4PdbP?=
 =?us-ascii?Q?nUUkX4gggz4kUabG8MgWWzb+uiNHiDQ8hZ8UZc96nQ7tumRRdbHCEk1roXjL?=
 =?us-ascii?Q?kcFTSUB3uHSYeADPQC2zt9UbOW05p6hY6/ka2WHqYf3xdTkuMB/5rSAOuOJc?=
 =?us-ascii?Q?nn8RhAHR2RNMD3MlTEDFMrn/yaCguZW2NV+yiHTA6fMjfX5qN8DYyjyFjj76?=
 =?us-ascii?Q?MEBoVeFqG9AwqajsodoOaAY7ArmCvYxrmyeEQEHdOl0ss4SHbcyHWO5ydWVS?=
 =?us-ascii?Q?APv9Ia9qs2qryJbYvA0khfW2PY2rkmOzeq+/aIjdAGKB1+p/77lwyzVFi+b1?=
 =?us-ascii?Q?Kv0xDpkEaUQ7fNocHJ7lFn8GhrpTWOUCwlI6VJ9BiD3pUbfINCN7LaOvtAOp?=
 =?us-ascii?Q?cDiY2z9AgMvtroogERVaXkAhF2NM17tbqEzX+64VG0hPIprAgYrqc7sy1wzq?=
 =?us-ascii?Q?bf865JA1B0m+fBVBunxbpu/EmN8HvoLDqKx3TvNRcsMTrpQEereKnS80O4LJ?=
 =?us-ascii?Q?ccpo48EVb0+kP7VxxsHCH8ZfaAKwIUxusZvasIVTu3YvynRctgrfjVUNOEJK?=
 =?us-ascii?Q?B0QQyPkHx+vZ3BGMpTRJhIrTQFBiqfmzUofFUP4H3dJ5jrSvcB6jAtGXOwS0?=
 =?us-ascii?Q?pLCbacWjfw5b9K5m/8qQHiuYEG4t9LTGc/BkqdwpskjaXxP+V87ZY4mmg72z?=
 =?us-ascii?Q?iEzN9uuQ6DmzZI2Nqgi5W2tgb3YSh4d3ot9bpddFGY3epcT92taAJG9l42+w?=
 =?us-ascii?Q?HoR5fE/d9fjrJS+/L7mABQri96SHbqw0/qi3gwV0rKtSXpw4igEwXbh18Ls3?=
 =?us-ascii?Q?7CnwpdxaRuoPzpfvvUyAvpPa+TrYnVm9KrVSFfcm3pbPj/fh0V6U3QnKvpdG?=
 =?us-ascii?Q?8LvWul+/aMhX0r+TcjTvNEajJjue4UnJGfVEwVUb9XbuhkL87AhTKD8gn7Q4?=
 =?us-ascii?Q?tpknOfnSdj5xLCfWiiUM5GAhvzHwQIOIQupcEn0fuZpSoSUpOCn3PZzcnIrq?=
 =?us-ascii?Q?QJlUfJ7XFKJSG5zGst33fc5BisLapio3lvZHOmdMgo45oberfxkXrPLEPSX9?=
 =?us-ascii?Q?9XSmwC5YvKl9aBh3LMcZdCiAQOU361upTzrNh1HTRnFavHsWH2nzOB+H2Iui?=
 =?us-ascii?Q?v+TsD6R5ihBQl7X+nwkD+aZFMhFvDFHLRDvkfiZcOfgv1/3L9tzVL2deG4sm?=
 =?us-ascii?Q?pMgmEsyeJ6e6gdnA+XSsNzr6GQbG2BP+Z8eBKavk?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 78b6d42f-01e1-4534-078d-08ddaef50bbe
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2025 05:49:24.3575
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1bAfXMZfie368kUhVIDZfWESeoZARU1bsgNNgUt7KZK90EGmGoceiVfaswDAItzJOUa/GRlhJ15fGlMMP5GBMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4854
X-OriginatorOrg: intel.com

> From: Nicolin Chen <nicolinc@nvidia.com>
> Sent: Saturday, June 14, 2025 2:35 PM
>=20
> Now the new ucmd-based object allocator eases the finalize/abort routine,
> apply this to all existing allocators that aren't protected by any lock.
>=20
> Upgrade the for-driver vIOMMU alloctor too, and pass down to all existing
> viommu_alloc op accordingly.
>=20
> Note that __iommufd_object_alloc_ucmd() builds in some static tests that
> cover both static_asserts in the iommufd_viommu_alloc(). Thus drop them.
>=20
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
