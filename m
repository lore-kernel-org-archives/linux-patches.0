Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=198.175.65.17
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793785771;
	b=NibYpQqxyBuNtXMPpXXjFpsC1xODOOTq5zWJBWplt8+fkxIBETlmK4OWukVQ4wbmdEMq
	 yIy207Hgb4w0+g7JDqjxiP3oPtjHCTNWhj2eQjPjhZD5vNmdhaeVTbJPUJxgBQsaqh/yj
	 SCZnpxiPm4r4JK+hW+i7hJjh9QgvG4W/EfdZXtZ/IeWZyQeoJS9Xjl2lX5kEydJ4cwuPV
	 y4W2KcmyqPAefwz6/rZZ2kpgxYaN8ov31ZbhyiENfaGPhspQfu7swmbBqdrOZrA8YZbmM
	 zjwUXIxWMJnmqPH1sZ/FkbxeFy/S0WHnXyyL+Ece50yxeCsi5HlNgS7WkFAV7arsx0A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793785771;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:Received:Received:From:To:CC:Subject:Thread-Topic:
	 Thread-Index:Date:Message-ID:References:In-Reply-To:Accept-Language:
	 Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:x-ms-exchange-senderadcheck:
	 x-ms-exchange-antispam-relay:x-microsoft-antispam:
	 x-microsoft-antispam-message-info:x-forefront-antispam-report:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:
	 x-ms-exchange-antispam-messagedata-1:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:
	 X-Exchange-RoutingPolicyChecked:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
	 X-MS-Exchange-CrossTenant-userprincipalname:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	bh=sfqMZeQo+zV2O97kSzoi3DiNMNUzKw4wpKfMUvyJrCc=;
	b=0MFJHDTdaqWwi6Pe+b5xgV7h5xnebYvvQEEqiWYbUdND2daEw0FriA09ABNi/PA+7Z5L
	 7xrEa/i+gPUcxM9mclD45TH2plWfgMfh8bY6fhSqGcYjDVnFFusx/gp/R2LlWPeszwING
	 euPt93y6IGDFe4EmXh4Bp7QURIEjnzYF6ZpkZ6M2IpHvb7/HbZwaSdEH78+MJocXZcrkp
	 VsizNBd37zu/rXlpqGJhYj8Hk+nnLqGSZ6xqjHCpGKTDPM3Bp2xR3KUDxT33LWqG3dA2N
	 X4ZKUdH3gOQSqzo7mVnhcqOE6fc2sapwEZr2++B05zNGd9vclEUmzmhZs2cQD0uKWBg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=MFMjB9Ra;
	arc=pass header.oldest-pass=0 smtp.remote-ip=198.175.65.17
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DE15606A329;
	Wed,  4 Nov 2026 09:49:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0DE15606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=MFMjB9Ra
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793785770; x=1825321770;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=sfqMZeQo+zV2O97kSzoi3DiNMNUzKw4wpKfMUvyJrCc=;
  b=MFMjB9RavPSDxMquPRGPHytDm9g7oaVhYKCvcyd9e97ZCwIv3mT3SV7k
   NtFRHzoW6mVVqPq1WM1ASPkv0W2RU4uugH8RPNRGu5BKZSyT8JUqMYkam
   RjHLELO4TCwzyC9RSDZvqerdTdjIm3a/PjMsknLvKDzjbpRARv4vTWueM
   36vKBqG3UCzr3Gqnyj20xbzmYyDm0xRUp9MdvUF0jA+matkqsEZPAJpuy
   zY3mOp20UFmSpra0YafP/GoMuT6is16aGAFxYaJRArZj9Ye/7MLRk7XZz
   Sin0lKTcEWFIirgXrE636BwxVEU1HAxdTBcmD6WlOQpJr7k8Rxst37fPv
   Q==;
X-CSE-ConnectionGUID: aEqBJDWERJ22mT1+MYkt4w==
X-CSE-MsgGUID: magiDtllTs6+Lczh+NUMLA==
X-IronPort-AV: E=McAfee;i="6800,10657,11955"; a="2551684"
X-IronPort-AV: E=Sophos;i="6.27,195,1787036400"; 
   d="scan'208";a="2551684"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2026 01:49:29 -0800
X-CSE-ConnectionGUID: hNh7j3F4SASCLyIq/k+APw==
X-CSE-MsgGUID: O4bgZwRWS2GXFHoEcZvsCQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,195,1787036400"; 
   d="scan'208";a="6992008"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2026 01:49:29 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Wed, 4 Nov 2026 01:49:28 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56 via Frontend Transport; Wed, 4 Nov 2026 01:49:28 -0800
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.35) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Wed, 4 Nov 2026 01:49:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D7jcqip8g38xf1x5XpIC5t+sauSAr382C/mj2n7aDUtoOjxCp7oa6Cp1ordb+/Fs3Uvk0ea4mHC50+lZvOAfdZsi3JhnCRZgXYcLDkREwSE8c2Lvo5JaaHaDACbZwkYm8YRv6tb6fxdfvbBiOJcSzdcnkHreLNF1sa3LZJpU/kLCn0CnzxnOaHLIpFd6gOIv56bHoB1/6Nq6gZ/UFR34bk8XMuuvhyyCo/HNaG3iZaSxf+XR9XmBLloIZWrmLPX1iUiilzllYC5wDhzYIJunicWHRNmDTTyZ0VrdvOJrtrip4paVW9FCJur+XHtxwwQcm41kWJq/0FuIRZQ2cQRZZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sfqMZeQo+zV2O97kSzoi3DiNMNUzKw4wpKfMUvyJrCc=;
 b=E1zZMamLTnJ2ptL2dROsRGu4NJztS71rPEfa44/9PRzkBUyQhuYJ0QoGEIRRUd4iyeESQUOfVX2Mb2wh+wiFU3ypCmFCnkg6400twnXsell9vphaaUOPQJJMYmIWCgHSombs2R7QM6uJ4HvB7w6r+iDUqRpKOcO3uaIfGYHeIlGHL+fG3SgOv0aCohYtt/2jqSyNkoX0rGKbzoAL51vdYXdvZKU8EyNxZusC9/5iXryVyop6TjhNPX1QtPEPynr+xLU2/mqU8W889HZIkdN47cYxFLGCUPoNZLdkK+LmJZfi9UMWKhf3JCE+rQZSyZ8EccU7gz+cNBGMSL1zoMR/Mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS4PPFA84FA90FC.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::43) by DS0PR11MB7971.namprd11.prod.outlook.com
 (2603:10b6:8:122::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.9; Wed, 4 Nov 2026
 09:49:25 +0000
Received: from DS4PPFA84FA90FC.namprd11.prod.outlook.com
 ([fe80::6aa4:1f69:47d6:56c7]) by DS4PPFA84FA90FC.namprd11.prod.outlook.com
 ([fe80::6aa4:1f69:47d6:56c7%7]) with mapi id 15.21.0569.011; Wed, 4 Nov 2026
 09:49:25 +0000
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: Xu Yilun <yilun.xu@linux.intel.com>, Jason Gunthorpe <jgg@nvidia.com>
CC: "Jiang, Dave" <dave.jiang@intel.com>, Aneesh Kumar K.V
	<aneesh.kumar@kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, Jiri Pirko <jiri@resnulli.us>, "Tian, Kevin"
	<kevin.tian@intel.com>, Alexey Kardashevskiy <aik@amd.com>, Catalin Marinas
	<catalin.marinas@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, "Steven
 Price" <steven.price@arm.com>, Kiryl Shutsemau <kas@kernel.org>, "Edgecombe,
 Rick P" <rick.p.edgecombe@intel.com>, Dave Hansen
	<dave.hansen@linux.intel.com>, Jonathan Cameron <jic23@kernel.org>, "Bjorn
 Helgaas" <bhelgaas@google.com>, Ashish Kalra <ashish.kalra@amd.com>, "Tom
 Lendacky" <thomas.lendacky@amd.com>, John Allen <john.allen@amd.com>, "Will
 Deacon" <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [RFC PATCH v1 10/11] virt: coco: arm-cca-host: Publish slot zero
 and establish streams after acceptance
Thread-Topic: [RFC PATCH v1 10/11] virt: coco: arm-cca-host: Publish slot zero
 and establish streams after acceptance
Thread-Index: AQHdZvIx/4WLyAKeS0CHM51th/PLq7cUvvoAgAAECYCAARZEYIAAOl2AgADzg4CAA46ocIAAevEAgAEloGCAAEhmgIABGSiAgAAXIXA=
Date: Wed, 4 Nov 2026 09:49:25 +0000
Message-ID: <DS4PPFA84FA90FCDC94900C2FC6CEF4D428E7682@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
References: <20261028152618.1356860-11-aneesh.kumar@kernel.org>
 <26c24a66-be3d-40ac-8cb4-294deb0108db@intel.com>
 <20261029171053.GD3734323@nvidia.com>
 <DS4PPFA84FA90FC768B30DCFEBDE71F31CFE76D2@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261030131543.GH3734323@nvidia.com> <yq5apkwqa5ve.fsf@kernel.org>
 <DS4PPFA84FA90FCEFB18E5620217FDCA728E76A2@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261102172640.GB274202@nvidia.com>
 <DS4PPFA84FA90FC31B41ECA1F6ACF6D0600E7692@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261103151643.GI274202@nvidia.com> <aurmtTe4ObBQhC4S@yilunxu-OptiPlex-7050>
In-Reply-To: <aurmtTe4ObBQhC4S@yilunxu-OptiPlex-7050>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS4PPFA84FA90FC:EE_|DS0PR11MB7971:EE_
x-ms-office365-filtering-correlation-id: 2a981ac6-c314-4aff-2483-08df3a58e95a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|23010399003|7416014|10070799003|376014|1800799024|38070700021|56012099006|11063799006|4143699003|261021121427099003|261102123227099003|261022105027099003|261022075727099003|261028144727099003|261026121527099003|261026140227099003|10067099003|18002099003|22082099003|6133799003|3023799007;
x-microsoft-antispam-message-info: 4Q4mm6N2V75bSEbF7GBroOVf12bWxHDegawXvw03PC/cAcibLqOvzL9PCfiMsyFSul5EzYLz761u3K2KfFs4nB3J/nauV/0nEMeIm5YmubpoIYaSTx8+mxOz2LW+G0jFscvTF5pzSalqH+VdLMwmQnqo1DpzYBTrmw8CeeNjt+gfji7DBxL5Tga+j8tVLg0/WvJFzvBHUPBxl4sM9M90QoykOO6JuPP5Go/mPyVKo6pNy0aCwgVhAlhyFp/2uOgGQiymKahYljMc80NNyaqVgKpwb0PF4cQAUYOW9m2mMR0jur1f35DhCePBP7khCrQIfmREAZ0VDppTeA9YmWRQ25ZmwIhelnOJL2W2z9Nso+c8MgQOyIrU2Iipc4C7s2F3HpECSUIT8RiaoKGz0sAuZqUfEAZ022KgMA46KbROVCQLTo43x0u4dhEw/VqDs413j82V8eMu8bZ3o4s9uSbJwiY4Ro9mk9s6u/ZCRoHirvzOTKF/O1d6uJsk3g3DTXpnBByHDiJu+oeYpF+j7oXIGoqsGv/FvkZknEZk4GXE+7VmjemfhxxV69csUZn3V/i+pjj//pJ5fnKOHXcas71Dpu1rgV4rLDimUP/71rJpG0T4z+hqdzvU56qMuTrBEc8nzI38hjsjWCqmpziXGmT1O/6CrD9BIu3IJuYhFJ/PzKWpyk+a00gmqfHoFulAnnRt7FWPbtJ6Eu2aP/JjYRrzbOWvsl7aCGbo0SUY2jyJr9I=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFA84FA90FC.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(7416014)(10070799003)(376014)(1800799024)(38070700021)(56012099006)(11063799006)(4143699003)(261021121427099003)(261102123227099003)(261022105027099003)(261022075727099003)(261028144727099003)(261026121527099003)(261026140227099003)(10067099003)(18002099003)(22082099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RFhERmlOUm94dGNJOEY3OU5TNUZjemlJaURXdTE4enZId2JLZCtTK0dCalBC?=
 =?utf-8?B?TWV5VCtaN1NLOS80cU9HWTRlUllzdTg2T0R0eGNqTkVMcEx6ejV1KzBWYjUz?=
 =?utf-8?B?eHh1SW4rYkxzMHM1OHlHd2xHVzdvdEpZZFMySWpITVpkOWx1dlVCVi8zakhj?=
 =?utf-8?B?OU9uVU9EaEhSYktkTFMvY0lrR2xtUzQ2N0kxWTNiUklHaWk4bjZIZ2IvSlRs?=
 =?utf-8?B?d3ZyM0IrcFBlZGs0OXJCMDFwamZVME44aVlQMWtRMWlISlM5L3preTB2TmV1?=
 =?utf-8?B?MHJOYXpMODc0N1EvVkxLMVVoSE5sZ0N0QWRkUnA2VmdncnJYTnBYS2hXVkFi?=
 =?utf-8?B?UXIxa0ZIV0pUSGg0Rk02cFByYldHNTdmdzlFNGNMRGZSa0FWYkNqM3hPRFhv?=
 =?utf-8?B?ckFmK1lCWlpHMVZjNDJkMUxkVFRNTnpkTVAxRUVVWHpOREJEalQrazRVNnEz?=
 =?utf-8?B?bUg1UzJWcjFjeEpjQ2xXczZSSXREL2U2WUdWaWgyVzJZcmpJbEtiUk9IUlRN?=
 =?utf-8?B?d0N0UXlBWXV4Uk1MSHZGdTdObHRiY3FwSGRkSjRGQmttM3FDZVJod0t4bVI0?=
 =?utf-8?B?ak9YdE9lWU00K2kwVTIreHRoSW4zN3d3WmlDQTZSY2dKTzJ0N0dUSEJScEQx?=
 =?utf-8?B?NUM5VkI2SWpUM01iM1g1ZEFuaU03WVZWcWF0UHRvSHNkRXk5WTVsY2Y3YnhU?=
 =?utf-8?B?UFBCQ1RWV0NEQlZQcXVaa052UndRVzlQZ2dwUThaTFA1OUxLRnhWd09iWlRX?=
 =?utf-8?B?eG11TUZnS3FORW56WkEwVTc5REtRbWpiNkFtZlA4cHhHNnMrM2ZjT0FtY2Jv?=
 =?utf-8?B?U0dkd2JCQUZwRkl0UHE4ald1ZGZOWHpTZm9VRDBLbUMvZWlheWVrOXNQSytT?=
 =?utf-8?B?b0daY0Y2K2V1Q2w0TlpnanNyQ09kaEFZaERTeHVodi9CTnFpdStEd0Z6Nytt?=
 =?utf-8?B?WUhrTUFyU0FnTWZpaDBNQnArUEoxbnIvRk9KRFlNQ1ZiVWN0dFovS1VSYlVj?=
 =?utf-8?B?eGd4Q082a01TbDRTYVoxa2ZFaHMrcEZsMjEvaG56emhnZEtLbnRtWTFsOXBj?=
 =?utf-8?B?QXloVDRoVXhNUVhaUXhaUVo1bWlzWER6bXRXQlkwNTZ5NzlCUVBQMTVWdjRn?=
 =?utf-8?B?Y1dKQ3IxelNqSGxTMUkzamR2ZFdlZ1lyWEtIbWttL09kWTNTbWhnQ1N3S2pk?=
 =?utf-8?B?aFVXZ2xwU3cxVTdRTmFUOXc2MG02SmxrTlNvZDZycGUrQXpiQlY0VUlHZWtV?=
 =?utf-8?B?eUd4bm55b3RqSnRRN2QxWnJpckFUSVFHdFpTdHhEZ2cwYUFqWUYvL3FEazU5?=
 =?utf-8?B?Mm5OcE9oazNMdC9mejdsdm9lMCtxdDNYc1FTQklvWWdpYTVycitKMlhkcW5w?=
 =?utf-8?B?U0RPMHJmdTRCSFBIUHFaZnhaVFdHcERGcElmV2h2b3lzL3dWZTdMZjNzUDJi?=
 =?utf-8?B?UDRCa1FLMEtKRzdaZjNyUytMdEpNRXl2TGk5M0J2T1dpajRmdUI1RjQzS0w0?=
 =?utf-8?B?UGVYamJybDh2YmNkNU1zSWhweGQyUk1PckVoVnEwTmFxZ3cvYXZRdnFJdnp5?=
 =?utf-8?B?QlUxL0FZWjIxbm9ac1FVcER1UVl3K0V1ZXViRDdYYkNUK1RFaXJRY0JXZFZr?=
 =?utf-8?B?K1pDZXlvSXBMeTY3R1hYcGZzSW50NzdRclBQcXp3eC9CcWQxOG9kM2NVMkU2?=
 =?utf-8?B?Q0J1QjBKSWhiTFNtVENDc2R1cTM0Nmo4aVFKLzlCeFVWb3lMYXgrQTREOThy?=
 =?utf-8?B?QjdLdjVVYnloQ3ppSlhlcXByd3h0V2JwUDVIMm5ERTFLcFpJMk1ta3ZRUG5s?=
 =?utf-8?B?M3ZDN0FrUFd5cUJXL2lFSU9jOGF4TDJhQmgvdzZISjFHZ0VhNC9xM0t3Tk1E?=
 =?utf-8?B?SW9aNnErTllqMnRqTm5FU3pPSjY3ZFhUSTFRdC8xOVVJdTNyTnhvdkdqRms5?=
 =?utf-8?B?bXBRZ2Mzd0tGRTgrK3dFUUh1WHlnMVpyaThPLzRxY2taamFSTmo0T3lyR1V6?=
 =?utf-8?B?UGZTb0lDaEcrR3FPWWNoWnVad29RcDh1NVFKUEdZSFpRa1Y4VWt2WXlFVlR3?=
 =?utf-8?B?SERCUDNaWCtMcnM2MTk3MWV3SXNKM25hcTNoQnlZMVJMMEp1ZEx0NmRmanhn?=
 =?utf-8?B?Qld5eFZIWW5wTHZ1OERiSzVKMjRkcEJuTE5GaXVSNi9YZ0ZCV0NzMmNuSFpO?=
 =?utf-8?B?dzdXWlZ4UlFJblE1eER0S2VNbnZuVUR4OGx1NmoxbEhyU3NxQVRHRmhOblFz?=
 =?utf-8?B?cDFlWTlpQkxhcXVlUVRwdURvcllnUDEvVThHZ2lGbmZROE04aSswZmZuNnNa?=
 =?utf-8?B?UGNEOG1XZGhXNzhDTXZGcUFZQlB0Y1hXUjVOM2VSc1l5bllYb2UveXhyVHJV?=
 =?utf-8?Q?khQaz9bI/Wvas+7hv/4FQ+BKg8A4/4YX4u92KZwQG2ORU?=
x-ms-exchange-antispam-messagedata-1: wKXS+C17nMG0qQ==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: kbiGQ8KAUTK4AiQimrfFaGL8hth7uTDi8OTAPkcktmjn9YJraJdIQVD0DF1oOuSzl0w5J+VyUj4IbHUtzjMGyX4j8kXPZbuPtUqeOl6Qzn+yGbHPaeTuInIwOjxX9HgCLMUr3MzezDYaGh+xXWyr2hTAXAP876jUHfS0KrKCYfVaDQpkcb6a8OUGsSL/wSlVe3Uz4FpmC1KakjRn+7PL3yr/nVOsLBcyhGPy4I6jt8Rmr9Ux/Q++P8AzXLxo+o9iXs6CxPVsUUE+bqNynFwCk1aj46/EP5rhiMojanW2+gBxYj44kL257yTSGaGGuITu2WJVD8Kr6lwZ6CynRbshBg==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFA84FA90FC.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a981ac6-c314-4aff-2483-08df3a58e95a
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2026 09:49:25.6185
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: J2oryD6utd0GlmGtU9vz3kqt5UYJRYOwoXd//RVWQrMZn8opDlR7YzuG0jniHJs0n+dwcU0l+dK6WPD8k0USuiun6OVqr5VOkGai4Fqv1Cg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7971
X-OriginatorOrg: intel.com

DQo+ID4gV2Ugd2lsbCBuZWVkIHNvbWUgbXVsdGktc3RlcCBzZXF1ZW5jZSBmcm9tIHRoZSB1QUJJ
IHBlcnNwZWN0aXZlOg0KPiA+DQo+ID4gMSkgQ1RMViBjb21tYW5kIFNUQVJUIENPTk5FQ1Q6DQo+
ID4gICAgIFRTTSBkb2VzOg0KPiA+ICAgICAgR0VUX1ZFUlNJT04gLyBWRVJTSU9OICAgICAgICAg
ICAgICAgICAgICAgICAgICAoVkNBOiBWZXJzaW9uKQ0KPiA+ICAgICAgR0VUX0NBUEFCSUxJVElF
UyAvIENBUEFCSUxJVElFUyAgICAgICAgICAgICAgICAoVkNBOiBDYXBhYmlsaXRpZXMpDQo+ID4g
ICAgICBORUdPVElBVEVfQUxHT1JJVEhNUyAvIEFMR09SSVRITVMgICAgICAgICAgICAgIChWQ0E6
IEFsZ29yaXRobXMpDQo+ID4gICAgICBHRVRfRElHRVNUUyAvIERJR0VTVFMNCj4gPg0KDQpXaHkg
ZG8geW91IG5lZWQgYSBicmVhayBoZXJlPyBXaHkgbm90IG1lcmdlIDEgYW5kIDI/IA0KDQo+ID4g
MikgQ1RMViBjb21tYW5kczoNCj4gPiAgICAgcXVlcnkgY2VydGlmaWNhdGVzLiBUU00gd2lsbCBp
c3N1ZSBvbiBkZW1hbmQ6DQo+ID4gICAgICBHRVRfQ0VSVElGSUNBVEUgLyBDRVJUSUZJQ0FURSAg
ICAgICAgICAgICAgICAgIChldmVyeSBzbG90IGluIHRoZSBzbG90IG1hc2ssIGFsbA0KPiBjaHVu
a3MpDQo+ID4gICAgIHF1ZXJ5IFZDQSBpdGVtcw0KPiA+DQo+ID4gMykgQ1RMViBjb21tYW5kczoN
Cj4gPiAgICBGSU5JU0ggQ09OTkVDVCB3aXRoIHNsb3Q6DQo+ID4gICAgIFRTTSBmb3IgMS4yIGRv
ZXM6DQo+ID4gICAgICBDSEFMTEVOR0Uoc2xvdCAwLCBmcmVzaCBub25jZSkgLyBDSEFMTEVOR0Vf
QVVUSA0KPiA+ICAgICAgS0VZX0VYQ0hBTkdFKHNsb3QgUykgLyBLRVlfRVhDSEFOR0VfUlNQICAg
ICAgIChjbGVhciB0ZXh0KQ0KPiA+ICAgICAgRklOSVNIIC8gRklOSVNIX1JTUCAgICAgICAgICAg
ICAgICAgICAgICAgICAgIChpbiBzZXNzaW9uLCBvcGFxdWUgdG8gaG9zdCkNCj4gPiAgICAgT3Ig
Zm9yIDEuMyBtdWx0aS1rZXkgZG9lczoNCj4gPiAgICAgIEtFWV9FWENIQU5HRShzbG90IFMpIC8g
S0VZX0VYQ0hBTkdFX1JTUCAgICAgICAobm93IGluY2x1ZGVzIERJR0VTVFMNCj4gYW5kIENFUlRJ
RklDQVRFKQ0KPiA+ICAgICAgRklOSVNIIC8gRklOSVNIX1JTUCAgICAgICAgICAgICAgICAgICAg
ICAgICAgIChpbiBzZXNzaW9uLCBvcGFxdWUgdG8gaG9zdCkNCj4gPg0KPiA+IDQpIENUTFYgY29t
bWFuZHM6DQo+ID4gICAgICBxdWVyeSBjZXJ0aWZpY2F0ZXMNCj4gPiAgICAgICAgKiBPbmx5IGNl
cnRpZmljYXRlcyBrZXJuZWwgb3IgVFNNIGhhcyBiZWVuIGFibGUgdG8gdmFsaWRhdGUNCj4gPiAg
ICAgICAgICB3aXRoIGEgc2lnbmF0dXJlLg0KPiA+ICAgICAgcXVlcnkgZmluYWwgdHJhbnNjcmlw
dCBpdGVtcw0KPiA+DQo+ID4gVGhlbiB0aGVyZSBhcmUgZml2ZSBpbXBsZW1lbnRhdGlvbnMgb2Yg
dGhpczoNCj4gPiAgYSkgVG9kYXkgdy8gMS4yIGFuZCBjdXJyZW50IFREWC9STU0vU0VWIHNwZWNz
Og0KPiA+ICAgICAgICMxIGlzIGEgTk9QDQo+ID4gICAgICAgIzIgaXMgRU9QTk9UU1VQUA0KPiA+
ICAgICAgICMzIGRvZXMgdGhlIGZ1bGwgZmxvdyBmcm9tIEdFVF9WRVJTSU9OIC0+IEZJTklTSA0K
PiA+ICAgICAgICAgIG5vIEdFVF9ESUdFU1RTDQo+ID4gICAgICAgIzQgcmV0dXJucyBvbmx5IHRo
ZSBzbG90IFMgY2VydGlmaWNhdGUgdGhhdCB3YXMgc2lnbmVkDQo+ID4gICAgICAgICAgZHVyaW5n
IHRoZSB0cmFuc2NyaXB0DQoNCkFnYWluLCBhZ3JlZSBnaXZlbiB0aGUgY3VycmVudCBsaW1pdGF0
aW9ucy4gDQoNCj4gDQo+IEkgc2VlIEVsZW5hJ3MgcHJvcG9zYWwgWypdIGZvciBjdXJyZW50IFRE
WDoNCj4gDQo+ICAgIzEgRG9lcyB0aGUgZnVsbCBmbG93IGZyb20gR0VUX1ZFUlNJT04gLT4gRklO
SVNIDQo+ICAgICAgbm8gR0VUX0RJR0VTVFMNCj4gICAjMiBSZXR1cm5zIG9ubHkgdGhlIHNsb3Qg
UyBjZXJ0aWZpY2F0ZSB0aGF0IHdhcyBzaWduZWQgZHVyaW5nIHRoZQ0KPiAgICAgIHRyYW5zY3Jp
cHQsIHRoaXMgaXMgbXkgdW5kZXJzdGFuZGluZywgbm90IHNwZWNpZmllZCBieSBFbGVuYS4NCj4g
ICAjMyBJZiB1c2VyIHNlbGVjdHMgc2xvdDAsIHBhc3M7IG90aGVyIHNsb3RzLCBmYWlsLiBBY3R1
YWxseSB1c2VyIGNhbg0KPiAgICAgIHNlZSBvbmx5IHNsb3QwLg0KPiAgICM0IFNhbWUgYXMgIzIN
Cj4gDQo+IFNlZW1zIHNhbWUgdG8gbWUsIGFueSBwcmVmZXJlbmNlPyBvciBkbyBJIHVuZGVyc3Rh
bmQgY29ycmVjdGx5Pw0KDQpUaGUgbWFpbiBjb25jZXB0dWFsIGRpZmZlcmVuY2Ugd2FzIHRoYXQg
SSBtZXJnZWQgMSBhbmQgMiBpbnRvIA0Kb25lIHN0ZXAuIEkgYXNrZWQgSmFzb24gYWJvdmUgd2h5
IGhlIHNwbGl0cyBpdC4gDQoNCg0KPiA+DQo+ID4gICBiKSBJbXByb3ZlZCAxLjIgVFNNOg0KPiA+
ICAgICAgICMxIFRTTSBjYW4gZXhlY3V0ZSBHRVRfRElHRVNUUyBhbmQgcGF1c2UgYWZ0ZXINCj4g
PiAgICAgICAjMiBJZGVhbCBUU00gYWxsb3dzIHRoZSBPUyB0byByZXF1ZXN0IGVhY2ggR0VUX0NF
UlRJRklDQVRFUyBjb21tYW5kLg0KPiA+ICAgICAgICAgIExlc3MgaWRlYWwgaXMgVFNNIHB1c2hl
cyBhbGwgR0VUX0NFUlRJRklDQVRFUyB0aGVuIHBhdXNlcy4NCg0KV2h5IGlzIGl0IGxlc3MgaWRl
YWwgPyANCg0KDQo+ID4gICAgICAgIzMgVFNNIGlzc3VlcyBDSEFMTEVOR0UgYW5kIHZlcmlmaWVy
cyB0aGUgc2lnbmF0dXJlLg0KPiA+DQo+ID4gICBjKSAxLjMgTXVsdGkta2V5IGZsb3c6DQo+ID4g
ICAgICAgIzEvIzIgaXMgdGhlIHNhbWUgYXMgYg0KPiA+DQo+ID4gICAgICAgIzMgVGhlIGZ1bmN0
aW9uIG9mIENIQUxMRU5HRSBpcyBhYnNvcmJlZCBpbiB0aGUgdXBkYXRlZA0KPiA+ICAgICAgICAg
IEtFWV9FWENIQU5HRSB3aGljaCBjb3ZlcnMgR0VUX0RJR0VTVFMgd2hlbiBpbiBtdWx0aWtleSBt
b2RlDQo+ID4gCSBObyBDSEFMTEVOR0UgaXNzdWVkDQo+ID4NCj4gPiAgIGQpIFJ1c3RTUERNIGZs
b3c6DQo+ID4gICAgICAgIzEgYmVjb21lcyBhIFJ1c3RTUERNIHNlc3Npb24gYW5kIGluY2x1ZGVz
IENIQUxMRU5HRQ0KPiA+ICAgICAgICMzIHN0YXJ0cyBhIG5ldyBzZXNzaW9uDQo+ID4gICAgICAg
V2UgaGF2ZSB0byBzb2x2ZSB0aGUgaXNzdWUgd2l0aCBBTEdPUklUSE1TIG1pc21hdGNoIHNvbWVo
b3cuDQo+ID4gICAgICAgVGhlcmUgaXMgbm8gdmVyaWZpYWJsZSBiaW5kaW5nIG9mIGNlcnRpZmlj
YXRlcyB2aXNpYmxlIHRvIHRoZQ0KPiA+ICAgICAgIHZlcmlmaWVyDQoNCg0KQnV0IHdoeSB3ZSBu
ZWVkIHRoZSBSdXN0U1BETSBmbG93IG5vdyBnaXZlbiB0aGF0IHdlIGFncmVlIHdlIA0Kc2hvdWxk
IGhhbmRsZSBldmVyeXRoaW5nIGluIHNpbmdsZSBTUERNIFRTTSBzZXNzaW9uPyANCg0KQmVzdCBS
ZWdhcmRzLA0KRWxlbmEuDQo=
