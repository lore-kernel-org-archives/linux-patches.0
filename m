Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=198.175.65.20
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793354417;
	b=SbvSPoww1lpYwjwKt6OoAi8hkkI0Mi9yioia5HkJaPDL80M090FVB6z/wY9SsDlP6FOx
	 D7Uz6JU9WWhl8YHzcz8+4d6f024dnl0XQrcAjfzAQefiPOJZABzuGyOSmQuozf5MQPmxC
	 taYxsuH7AZ1xHjEB6ZqanUNOnhvEHtmi7/iWSIsNSkAqGgu/EqnQekD2ZGmwlG6Bjn9gP
	 QlounMyENAmEfa+QZRlm7l+FnmCXXPc4J6iXMAjAO3lr8U4gGbceDVYFTjFn/Efy2UCmV
	 nx+tMc0Cpk/dT2rKtXw4a5R/NT1tY58xMUFhtrEzdF2CyYXm+ifnUF0TgZowp+/JKwg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793354417;
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
	bh=lQWLSeI0Db9gQN2wSo89mTYs0VCkaPBzBXSeD/8Qgx0=;
	b=p2hQGC2aSXOdAJgp5nPbaKm94yA4pBcByxToak8QeGSjvj1vI0DlwfDOHvtrClqRhXDk
	 R5YHoLFHFO1UlsCf2FZJbZ+QXV3E2d/QXPrW5vtBOrk7/HHgMjkgmSUlwwYC2dzsCtuMI
	 lYCHqbJoMkrQ9YpygonXLtuIXfLwSEnNpaFQ76nBqORqiJxUaF86/yZIa5t5roBaBiSEg
	 inviqKwxd/kZ6g/M5cH+R6AisaXKcQRr0JTNoa98993uwquTsClMNFDtEZ0ztpDimvKpO
	 nxEqpfFxhMO8owzrwuwpAg02mmKTPQLJx1v9BvotdpbV7zXpDjgVlJtAq/6aXRd2/yw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=XNaTimoC;
	arc=pass header.oldest-pass=0 smtp.remote-ip=198.175.65.20
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB321606A31C;
	Fri, 30 Oct 2026 10:00:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DB321606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=XNaTimoC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793354417; x=1824890417;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=lQWLSeI0Db9gQN2wSo89mTYs0VCkaPBzBXSeD/8Qgx0=;
  b=XNaTimoC9pFC4t5hAIN44PHSeY/gAJkdjOmMaTaFSDySrcxvnr60/mdS
   Rfz5T8Gd83rz4Yfqi4fCKeC+bZZKEDvObpmxeX1xreBH5cWkVWAwfhV0V
   JoAQ0+x/FuwYbWpDiozamykFuPWanYmDr8oyuTa/Y1sGepye7Ar3SLcAT
   5IlTJCAq2ZBxHsuZVGXehLbEVmvnhedC6tTBy795ZsW4hV7lhvprud1i+
   rdjAhoI29V7UHrI5tXBoiUV4d/jSellv3rf5rvrtmSL937cMg0QX6gC+B
   ek/fx91Jps7WSGpY41XJx1fZjVQMg89tnWS4OngEcVEkxMKlAfu1nrDXz
   w==;
X-CSE-ConnectionGUID: 3Zy45zNfRkOhJwedj6Iw7Q==
X-CSE-MsgGUID: slNZW2QWTPSMAXAiKMQNNQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11950"; a="2139641"
X-IronPort-AV: E=Sophos;i="6.27,186,1787036400"; 
   d="scan'208";a="2139641"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2026 03:00:09 -0700
X-CSE-ConnectionGUID: 6olJu28MS66zYnshzM3C0A==
X-CSE-MsgGUID: ztjhq93EQoiw5YMqP5RqwQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,186,1787036400"; 
   d="scan'208";a="5763054"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2026 03:00:08 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Fri, 30 Oct 2026 03:00:08 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56 via Frontend Transport; Fri, 30 Oct 2026 03:00:08 -0700
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.32) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Fri, 30 Oct 2026 03:00:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jVulkaroZqflPtp2kUIutm4obBefUU499MSJHZaeIPwv5SU1bU4LPXaRSHEptz/s68m/HUIPalTuPRz9xmeYQxXPlNteoU9dMLbRUFX4mMqRf8y/cEXsSFZ1KGBUZqlxrRgWmh6VSJYAXiKRUFfs1a34PQIVCSr0GALSlJigAbM96y2Sj88AGZmuLGURsAM73dYsOUUe3y7p9FL7lC+rt44vKbeEVq5NGVYz4vGV18rp2P2ch6iZDY/gzGN086A+mDpK2j0HNNZPKaxqduh5egFrqb3Gj6Rd6OomKF57vfpykl3qhAFnfpqCC1eNKhd9UUUt5Hc4wlfMmKiG8SGzUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lQWLSeI0Db9gQN2wSo89mTYs0VCkaPBzBXSeD/8Qgx0=;
 b=UQLJhd2vzcVIBsVjUV1tXoO+gtnYi84w/yNbamnJpCPM4T1+E1SYPNqRrxvmCMy8roz0HHRhlRovzSLttirIRyzefaMFNLcOKVj59NUnrdyoAz7i+iMceuGJhyNKQIdCEbWg5mkfFYlremmZQLIT8Q1PCYK4w0fGtFspkJKfg6Shh0pH52eb3ovpQc7Jleu9QQNl9Cd0yW+0ziInkElXLtKS6412OWuMJEQLWRy8P3xfhTxkV5N5yze6T9n8+VlTmNlGsQ1OuaY/qdHYUnKIOKj+hLF1iKPhwjPu8G01ca+688EGJLOOD1bcMeDZYFmjm94Mz7AeRGyZ9yWdBB7CJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS4PPFA84FA90FC.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::43) by DS4PR11MB9529.namprd11.prod.outlook.com
 (2603:10b6:8:34b::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.10; Fri, 30 Oct
 2026 09:58:03 +0000
Received: from DS4PPFA84FA90FC.namprd11.prod.outlook.com
 ([fe80::6aa4:1f69:47d6:56c7]) by DS4PPFA84FA90FC.namprd11.prod.outlook.com
 ([fe80::6aa4:1f69:47d6:56c7%7]) with mapi id 15.21.0569.007; Fri, 30 Oct 2026
 09:58:03 +0000
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, "Jiang, Dave" <dave.jiang@intel.com>
CC: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, Jiri Pirko
	<jiri@resnulli.us>, "Tian, Kevin" <kevin.tian@intel.com>, "Alexey
 Kardashevskiy" <aik@amd.com>, Xu Yilun <yilun.xu@linux.intel.com>, "Catalin
 Marinas" <catalin.marinas@arm.com>, Suzuki K Poulose
	<suzuki.poulose@arm.com>, Steven Price <steven.price@arm.com>, "Kiryl
 Shutsemau" <kas@kernel.org>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>,
	Jonathan Cameron <jic23@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
	Ashish Kalra <ashish.kalra@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>, Will Deacon <will@kernel.org>, Mark Rutland
	<mark.rutland@arm.com>, "patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [RFC PATCH v1 10/11] virt: coco: arm-cca-host: Publish slot zero
 and establish streams after acceptance
Thread-Topic: [RFC PATCH v1 10/11] virt: coco: arm-cca-host: Publish slot zero
 and establish streams after acceptance
Thread-Index: AQHdZvIx/4WLyAKeS0CHM51th/PLq7cUvvoAgAAECYCAARZEYA==
Date: Fri, 30 Oct 2026 09:58:03 +0000
Message-ID: <DS4PPFA84FA90FC768B30DCFEBDE71F31CFE76D2@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
References: <20261028152618.1356860-1-aneesh.kumar@kernel.org>
 <20261028152618.1356860-11-aneesh.kumar@kernel.org>
 <26c24a66-be3d-40ac-8cb4-294deb0108db@intel.com>
 <20261029171053.GD3734323@nvidia.com>
In-Reply-To: <20261029171053.GD3734323@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS4PPFA84FA90FC:EE_|DS4PR11MB9529:EE_
x-ms-office365-filtering-correlation-id: eafe5f39-2af8-4430-9d13-08df366c49f5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|10070799003|376014|7416014|366016|23010399003|1800799024|18002099003|22082099003|38070700021|10067099003|11063799006|4143699003|56012099006|261021121427099003|261022105027099003|261022075727099003|261026121527099003|261026140227099003|261028144727099003|6133799003;
x-microsoft-antispam-message-info: kR79CZbmrlxYeBAZDeohEqzgcNtqgHPZkesw6SyrHzx/iaEc4dxnq59QGJs/P/5aXFkB2NTtma8c1QzQ+OYgzhlWHP50ldPWIQbYGxVkqbjniJNecQnMwNIx8mkGL8vEW2jE+QwmrEONgKdfvhbBL19FppkkPee2pSeRUXfCABbYuo0NkL4IP5Y+OiZBfNx/SE4y/hYmxaU1wZHS3eZINZdi2ypg3Gdcnwnw+o3vY9MbyJENq1047MJT+JuQHSQnkmdw7fQJ1OHVgtkFCa7F9gTNaW8MRv551Y8m1KNq0SqNauMrcp5OAhesLlN93ye4XKYcNOilNYBot3dc6GKBSjXcA3Y5QxXUl/P0NyvOIfxOPq/lxW2eKDhPmmxSNL2jp8IrvufDxv3EhEL3MFNpo6p2JpRsLrZIkMIWcp/3k6fk7mDkRXeQXdzvax9LBfz9fhvNWAgLdkhFcPEXnV56QnYkTH1E8Z/4Ee4LlBeGzf2iR7AvoTZ3M40O/6UE1OWPT0fYMLJiA5RICDBBjD8R05ZSGkTLjE/I3tQdL1RGP/f5E208XNkvdJh2jMd9kAflYEl/a75mFExSf+w3S73GdkLuv2DizGvyXrOYWQmiuiuwQniju5sSie85zZqAuLSHvIIJeyFF2cyAc+4rt/h+wCpcK6F1D4671+KNkENSiCD+TrU04ZN6on6OvIP80hRF2Vpcr/4lTyy6enj85bCcJaYD9v/xVO2OtpFp/MdUfdE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFA84FA90FC.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(376014)(7416014)(366016)(23010399003)(1800799024)(18002099003)(22082099003)(38070700021)(10067099003)(11063799006)(4143699003)(56012099006)(261021121427099003)(261022105027099003)(261022075727099003)(261026121527099003)(261026140227099003)(261028144727099003)(6133799003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VWNWd25PS1ZZZzQvV0gxLzU3NHNBcndsSktLcWtBU2pacW5Mam1qL05GeHdN?=
 =?utf-8?B?Rm1UUUk5blNhVGxlL3JRSFQ3Y2Jwc3VmOXIzR0tSbEk0aU5KSW42YWp1ZEx0?=
 =?utf-8?B?a3VSc2w5MEVGcDNVK2pQem4vb3ppQnNkR2ZHS0kvMW0yWk5tZzdZVGQ1TzZj?=
 =?utf-8?B?OU00djA4TjhNRkY3M0VGV0JhdXozZU1HcS9DeXVsbWl6TGJST1k2ZHFDTVBj?=
 =?utf-8?B?cnFFK2tJMGdiMWI0aHFGT2trd0ZTUlVGcS94MVNoSmNpV0NYbWJtUjJmT3Zi?=
 =?utf-8?B?VG5YUnpKNVJxV2phSmhHTXdpRE9FM05CeVZBTm9tQm9BVVJ3Yis2NXZ1YnNT?=
 =?utf-8?B?YWdzOFZmb3ZDMFBkcmFPcUE5cjhKR2RqV0xxVVkyZjk3SWtYM25hemJqWWRS?=
 =?utf-8?B?QTlGeVVINzVRUmFrU01kSU1LVURiWWsxUDQ0bTBoMitwWWwxZEZVdzJLK2VT?=
 =?utf-8?B?Uy9UNUlMd3pmVFVVcHh0NlJ1a1A1bEoydzRiaTl1VWRHUVFlNVJ0M3h4NWhs?=
 =?utf-8?B?MS9Qb2dSV2VldWMxOVlHYTRoQW94Q2FwVUFQZHdsSlpSR1dmMFVSalRna3No?=
 =?utf-8?B?TmZwYXR1SFNuNWF0bG15UzUydXpoKzQwSElPZkRtUlhjUDdqYy9nVDFxSEkx?=
 =?utf-8?B?NVBiNnp5T1N5d0ljNEdsb1FzUmVmRDBXL2VXMWhPQ0poUlZoa1pCay9yVi9R?=
 =?utf-8?B?RUQzOEtITGhFOWJDSXdyYlAzMFR2TVg1UmN1aW9oZlNEcnQyRFpnUTJhMWIv?=
 =?utf-8?B?b0tjMXhDcE1qbEo1UCt2Z3RSdVdoZjEwdTBBL2hoYkNPcW5jL3krc0d1TFBC?=
 =?utf-8?B?UWdzN3lPd1ZaaUppOHo0aTRxSEw1d1I3djhmd2JYbDR2eVl5ZW5ad0lmdzBP?=
 =?utf-8?B?TjNKMDFGVnpEVGVXNFJRUzJjNGVzdWxxQWZqVHVod3dpenV1Sm5iWmJoOFlz?=
 =?utf-8?B?dUVuZnUzQ1BSQWowdkx0NFMzVkpTWWlZRHQzOUNyMzAyNm1xTllKT0VuYlFC?=
 =?utf-8?B?Y1F1alg2czUwZENRd0R1SDl2ZUlhcm83WXM3MXpGNFVTT3V6YUh0WWtETTVK?=
 =?utf-8?B?MzhtUDJ5Z2QyQjJwNkRnbkVhNzlPNGtGMVFFeUc1VXB0aXYxc0JCQjNkencz?=
 =?utf-8?B?QWtQbU4wUGQweWdNcmRqTnpsUTl1Y2tkdW5TM1c3aENGSVlRVU9JUDJITDNC?=
 =?utf-8?B?eWZ0ck1peTJmRmZIVWZuVjRReUdjcHBOVjRpOHZqaHBNR2xTRWtPU1VZZlVJ?=
 =?utf-8?B?b0pnSjRIbWdlWkt0NWVpZ2J1eWN3Qmt5YWdUMnN6UzErNEFqZkdCNVNlYVpV?=
 =?utf-8?B?SWJWZ2d2RE5mQUpyM1JxWGVhbkJNZ3k5Ukd1NkNiU1dZTXhnS0dHMFBOazBr?=
 =?utf-8?B?cklqdXNKNkwvclZML3B5RmJaUHhuem45S2hFUlc1K204TUx3aWR3VnBmUG1o?=
 =?utf-8?B?ZWpPbUVPMkVtQWlGRmZRcjJvWkZOUHJvMUxRd3llSmFZYlhEQ3k1bXY3eTcz?=
 =?utf-8?B?WDVCZGJRVWYrSDhyK2dVa2RKQkc1bHZaQWxHZlNJNzcxZGZ2Q3lacGtkUTFk?=
 =?utf-8?B?Z01hZ2hXNHhZYzlDWElQbFZrZnNyRzRlRGZtOThrRktVSFY3dC9zbW5TNERN?=
 =?utf-8?B?QUZYS2VBdHhmWFZNZU5zZUxIeTFqR2F2SW1JNklSQVpXZ3hsaXRKR3dEMjlO?=
 =?utf-8?B?YlVWUUlpWFJkUzhRYWdGQnFBck9wNy9KaE56emlGdGJwSGxhZ1UwekJEcHZz?=
 =?utf-8?B?L01pTTFQSzQwUFZSdkEwNTNQM3JyY201UlNHK1dOYnlqQWxaNGdnbEtsWUxz?=
 =?utf-8?B?OEJLUW90dzNNbElEYzJURitydzhJVytyQzBwQXI3dzV3YTZUcEoyR1VUS0JD?=
 =?utf-8?B?bTVZNHR0ZHZUem5GZ2hpbTVFSWEvYllGU29Zd01GNTkzY2RJQ2JvaXJlbGNY?=
 =?utf-8?B?MndQMWVpcWR5RTd2NzY4Zm1DQm9CSmNKTVoxWENQZzFFYkJ2MVR1Ly9DMytV?=
 =?utf-8?B?RTd1cGRCS2lKbSs3V0hWNjZOcGJFb2NZTWFwWmhkeXg3d1lYMWxXMHpINzZ2?=
 =?utf-8?B?ellyRHc3Tmk3UDJUaXJuZ3lDMnVINnZsaHlVcWhOTlRPM1czcGxBRWpMNmcz?=
 =?utf-8?B?aWtMdjM0RGlsWk12T2R6bGkyNExPbmFraGVIMVphMy9pWk9zVVpOc2RySmNK?=
 =?utf-8?B?RElSS1JQWjhGVjNuMHFJZDhwSk93WUdOeStGc0JBSmNscXZEeU9Rbnptdmt6?=
 =?utf-8?B?Zm5NV0hmS0ZTcDBuYnJIMnZ1aFE4OFhVRFlCT2h3OGMydWEyaEhNb2laTnNp?=
 =?utf-8?B?eHh5d29FSW12NG9wR2ZzVzYyOGdmYThRaHdINXBBK3I4K0tKUThZUzU5YUVQ?=
 =?utf-8?Q?UB0WOEa/cWYCX7HOYCvTxD1iGIJDC9pTHLf+U2KYk9ImI?=
x-ms-exchange-antispam-messagedata-1: 55htdB6zgtp5+g==
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
X-Exchange-RoutingPolicyChecked: g5cmi+EQ71d1FbU/OV2jJuuY/kvv3CHWJPOiKp7hSLRhj1IR8E0C5sJBuWha+QdVNzBNGgESDvHiLmXJoKNSYPaURbr1JTSeuhKSLFda1m1dvKun1bkF8Hwx4zPe02Adgdrkqt2b+G5NQAdCaiZcz9mBwrNrH8u2U9fdDlnf3TDO8GbblQRclZB4jnUS29zez8lYuYIBGIT7XLqWDH26sz14a/6XAc8N+agizupz7TcVoiFTLi64ovFVdcP/wT+n3DKFRuNkfrxeWJnQjdAwXRz+jI/NmFBkmofrKtCQHZSiNDpuM0kgpIkx51o1KGYe+yAI30LLQnPBOf6RqrFB/g==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFA84FA90FC.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eafe5f39-2af8-4430-9d13-08df366c49f5
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2026 09:58:03.4634
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JjJUS8VD8WuyaYMKW7o4aSyWxnpOIF4DCq55oDJ0/pWydOjBD9AyqxGQ80fIBFOI1rfLmuNVFhp1gVcfMllkEAPDGwTNI1JrbCeQjYaL1aI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR11MB9529
X-OriginatorOrg: intel.com

PiA+IEl0IGNhbid0IGRlZmVyIHRoZSBzZXNzaW9uLiBUaGUgVERYIE1vZHVsZSBydW5zIHRoZSB3
aG9sZSBTUERNDQo+ID4gc2Vzc2lvbiBzZXR1cCBpbnNpZGUgVERILlNQRE0uQ09OTkVDVCwgYW5k
IHRoZSBob3N0IHJlbGF5cyBpdHMgRE9FDQo+ID4gbWVzc2FnZXMgd2l0aG91dCBpbnRlcnByZXRp
bmcgdGhlbSwgc28gdGhlcmUgaXMgbm8gZGVmaW5lZCBwb2ludCB0bw0KPiA+IHN0b3AgYWZ0ZXIg
dGhlIGNlcnRpZmljYXRlcy4gVGhlIGNoYWlucyBjb21lIGJhY2sgaW4gdGhlIGRldmljZSBpbmZv
DQo+ID4gb25seSBvbmNlIFRESC5TUERNLkNPTk5FQ1QgY29tcGxldGVzIChURFggQ29ubmVjdCBB
QkkgUmVmZXJlbmNlIFNwZWMNCj4gPiAyLjEgdjAuNjYsIDQuMi4yMC4xKS4NCj4gDQo+IFllYWgs
IGl0cyBmaW5lLiBURFggd2lsbCBoYXZlIHRvIGRvIHdoYXQgQW5lZXNoIHByb3Bvc2VkIGZvciBB
Uk0sIGFuZA0KPiB1c2UgdXNlIHRoZSBSdXN0IFNQRE0gRHJpdmVyIHRvIG9wZXJhdGUgRE9FIHBy
aW9yIHRvIGNhbGxpbmcNCj4gVERILlNQRE0uQ09OTkVDVC4gVGhpcyB3aWxsIGFsbG93IGRpc2Nv
dmVyaW5nIHdoYXQgaXMgaW4gdGhlIHNsb3RzIGFuZA0KPiBwYXNzaW5nIHRoYXQgaW5mb3JtYXRp
b24gdG8gdXNlcnNwYWNlLg0KDQpJIGFtIHNvbWV3aGF0IGNvbmZ1c2VkIGJ5IHRoaXMuIA0KDQox
LiBZb3UgYXJlIHNheWluZyB0aGF0IHByaW9yIHRvIGVzdGFibGlzaGluZyBhDQpzZWN1cmUgU1BE
TSBzZXNzaW9uLCB5b3Ugd2lsbCB1c2UgdW5zZWN1cmUgRE9FIG1lY2hhbmlzbSB0byBkaXNjb3Zl
cg0KYXZhaWxhYmxlIGNlcnQgY2hhaW5zLiBIZXJlIHlvdSBoYXZlIHRvIHRha2UgaW50byBhY2Nv
dW50IHRoYXQgYW55dGhpbmcgeW91DQpnZXQgYXQgdGhpcyBzdGVwIGlzIG5vdCB0cnVzdGVkLiBB
IG1hbGljaW91cyBkZXZpY2UgY291bGQgc2VuZCB5b3UgYW55IGNlcnQNCmNoYWlucyBmcm9tIGFu
b3RoZXIgbGVnaXRpbWF0ZSBkZXZpY2UuIA0KDQoyLiBOZXh0LCB5b3Ugd2lsbCBjaG9vc2UgYSBj
ZXJ0IHNsb3QgdG8gYmUgdXNlZCBmb3IgU1BETSBhdXRoZW50aWNhdGlvbiBhbmQNCnNlY3VyZSBz
ZXNzaW9uIGVzdGFibGlzaG1lbnQgKHNsb3QgMCBpbml0aWFsbHkgaW4gdGhpcyBwYXRjaCkgYW5k
IGFsbG93DQpldmVyeXRoaW5nIHRvIGhhcHBlbi4NCg0KTm93LCB3aG8gZ3VhcmFudGVlcyB0aGF0
IGEgY2VydCBjaGFpbiB0aGF0IHlvdSBzYXcNCmF0IHN0ZXAgMSBmb3IgdGhlIHNlbGVjdGVkIHNs
b3QgaXMgdGhlIHNhbWUgdGhhdCBpcyBnb2luZyB0byBiZSB1c2VkDQppbiBhY3R1YWwgU1BETSBj
b25uZWN0aW9uPyBXaG8gaXMgdmVyaWZ5aW5nL2Vuc3VyaW5nIHRoaXM/DQpLZXJuZWw/IFVzZXJz
cGFjZT8gDQoNCkJlc3QgUmVnYXJkcywNCkVsZW5hLg0KDQo=
