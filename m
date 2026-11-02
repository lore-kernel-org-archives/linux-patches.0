Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=192.198.163.8
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793614310;
	b=RDCOj44SlnR6k/mIWpFqYBYFhkI1dvGhBRmmvRo15YD18vMjboHMTe83jLQGHF4x7F/X
	 5yjTwDAiEQNYwsPKpZRAtgkvARlWUe64qvBBBMIlaAypBlkF4ZQuaZh7svKjbKxEC+euW
	 7SLuJniCGdz+om84qIu6M60cibdG7LeC3/o6m04+jO6PzDHD/eYQ1dyVIbKziwtXyTDdY
	 Gr1U5pdss7QkZkg9wIB/q/aVuGynIykKPLvA9tJkH6U97Avsm5GJHqg5TR6XZltirHO3E
	 r/U2JqmN19ENdnir/tc3Ac2xIIGvIAtaxjDLnNncxGBEmL4NaxPwgqcADsx+AHlhbew==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793614310;
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
	 x-ms-exchange-antispam-messagedata-0:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:
	 X-Exchange-RoutingPolicyChecked:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
	 X-MS-Exchange-CrossTenant-userprincipalname:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	bh=EGXo37mtQU/SgCAgRS/kr1k1UE9Kpzl2YLwqh3jhE54=;
	b=cxDnZzD+bQcDoO8OpDiZw4INezDBQIPoHH0jzkZVTUC8JzbozAM4Plw527HWNBJA+Qxu
	 CVj55iMEwFJL+7n9kldSaNsW8PzwlyCYH8I+PQKl/60lOQ3J8YaNajrPdvmRdwuL3mCPo
	 V8CCTSeqhU0p6qHge3tBMT/xytuCaNQwN9teqalCGz7M36c++IZoUmXOg0OaUdY/MUt6J
	 NM0sN8tmZtwNODjGkoFk8yjuhzBsRvMaWZc9nbjnHimCqb5y9pb/gME8PwUDzE2Xrnqo/
	 AN11Lgmm4onfJAbfziijL28h1rzONZV9Iw5ORzrHCy0+PWDfD/S+v/vWgNFL9pHmDWg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=oIv+LGFR;
	arc=pass header.oldest-pass=0 smtp.remote-ip=192.198.163.8
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC259606A327;
	Mon,  2 Nov 2026 10:11:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CC259606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=oIv+LGFR
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793614309; x=1825150309;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=EGXo37mtQU/SgCAgRS/kr1k1UE9Kpzl2YLwqh3jhE54=;
  b=oIv+LGFRVwuO/rK6io84OWu78r5O3SSg361s8BNwQPlBEGEKzuBBJFZB
   JSywlf4eLBNoIX0q8ozJbd3Il2WzCYYIRv2NfU71EjN2JqodfeT5wBsfb
   +ap/qLu9Wnj4ful/j8pu3MWWDgVaCqWhiAtbgLdrwRz4EhecJTjDTo0e0
   Uwf3MZ0+fdQLiQZT6uisU3HkD46g4y8oxzyXc74ORWOicP0V2UKCimYnY
   NxNNI88dgK2xItqcGhA9KDmPNLN11T12AwGH+yDrvbaveKxXYD7zuovXD
   /qGog7sWoDVmSBDzxBEYVIVMYecfbFI5HLx90+umIdRuLMPAF4zCaMiMY
   A==;
X-CSE-ConnectionGUID: 7tNQv885RPCYFptB9TokbA==
X-CSE-MsgGUID: sxDDEHRLR7SHZwO0MvJH3Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11953"; a="2194616"
X-IronPort-AV: E=Sophos;i="6.27,191,1787036400"; 
   d="scan'208";a="2194616"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2026 02:11:48 -0800
X-CSE-ConnectionGUID: JR7L18IrS+yoeGCV87jQ2g==
X-CSE-MsgGUID: BXxZSSgQRiW67sglaKK6IA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,191,1787036400"; 
   d="scan'208";a="6094294"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2026 02:11:48 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Mon, 2 Nov 2026 02:11:47 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56 via Frontend Transport; Mon, 2 Nov 2026 02:11:47 -0800
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.19) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Mon, 2 Nov 2026 02:11:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cQ9A5jzaKfzN16lf2Fadl1LPgzrne48r4SuHlspUw4hQWl0OTdjD0HdiPybZtlKUycZ7chOnGcX+ohIIHuzoTGSIsnXluZ95mvcq6UqmQVwHbvGp/T8QyDon6leDzBiL7ROQCcYCywQyG5yFplx9x71wn0LOyk5BcqRTRdFdl76RnZfg5GORfSO5ptzy7GVTyrDZC3LWa2Jzo/KNfPOy5rMiywbUiwsqAgcsGsr5nOEAf173H6XrHHhieGnehmEtb4DyWsnswImBIiRa1VZgZCUPYJbxoK+WRX5G8xAFgtPCQbqL3t9XQXe6PzADujCpBnP30+Lw5i6WyHWcs3VeFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EGXo37mtQU/SgCAgRS/kr1k1UE9Kpzl2YLwqh3jhE54=;
 b=ezEwPDd3dJYjAXLFp6aIt+fPCmF0gsj/wRGiS9Ty/RRSjJS1mgP4SMULZEwixcSYPU4y7752jpnJsyDctALcamZ9tz2nYNjohtB8rKbT45NS19borq/KYRSwh1flJuY+fxdTcyqk66ilK13FyoHKfYM+ll1zUuOkeRK/nK1ZANQuRjP53VKEM/B2AZKQDYb7IykpGIn4Hni0Q1V+lX0yhxvXXHpoLsvcX7RFZ1j9QHzSh57chXvvfpedK20fDD4tLXD1fyPXXxhHA3JvCryi0G8nqLFxE0ohKDiop7SL3RwmhGsYcVmoEK20/y/4byKvL1Krc3RxjFaF3jO4qoP6RA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS4PPFA84FA90FC.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::43) by BL1PR11MB6028.namprd11.prod.outlook.com
 (2603:10b6:208:393::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Mon, 2 Nov
 2026 10:11:45 +0000
Received: from DS4PPFA84FA90FC.namprd11.prod.outlook.com
 ([fe80::6aa4:1f69:47d6:56c7]) by DS4PPFA84FA90FC.namprd11.prod.outlook.com
 ([fe80::6aa4:1f69:47d6:56c7%7]) with mapi id 15.21.0569.011; Mon, 2 Nov 2026
 10:11:44 +0000
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: Aneesh Kumar K.V <aneesh.kumar@kernel.org>, Jason Gunthorpe
	<jgg@nvidia.com>
CC: "Jiang, Dave" <dave.jiang@intel.com>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, Jiri Pirko <jiri@resnulli.us>, "Tian, Kevin"
	<kevin.tian@intel.com>, Alexey Kardashevskiy <aik@amd.com>, Xu Yilun
	<yilun.xu@linux.intel.com>, Catalin Marinas <catalin.marinas@arm.com>, Suzuki
 K Poulose <suzuki.poulose@arm.com>, Steven Price <steven.price@arm.com>,
	Kiryl Shutsemau <kas@kernel.org>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>,
	Jonathan Cameron <jic23@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
	Ashish Kalra <ashish.kalra@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>, Will Deacon <will@kernel.org>, Mark Rutland
	<mark.rutland@arm.com>, "patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [RFC PATCH v1 10/11] virt: coco: arm-cca-host: Publish slot zero
 and establish streams after acceptance
Thread-Topic: [RFC PATCH v1 10/11] virt: coco: arm-cca-host: Publish slot zero
 and establish streams after acceptance
Thread-Index: AQHdZvIx/4WLyAKeS0CHM51th/PLq7cUvvoAgAAECYCAARZEYIAAOl2AgADzg4CAA46ocA==
Date: Mon, 2 Nov 2026 10:11:44 +0000
Message-ID: <DS4PPFA84FA90FCEFB18E5620217FDCA728E76A2@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
References: <20261028152618.1356860-1-aneesh.kumar@kernel.org>
 <20261028152618.1356860-11-aneesh.kumar@kernel.org>
 <26c24a66-be3d-40ac-8cb4-294deb0108db@intel.com>
 <20261029171053.GD3734323@nvidia.com>
 <DS4PPFA84FA90FC768B30DCFEBDE71F31CFE76D2@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261030131543.GH3734323@nvidia.com> <yq5apkwqa5ve.fsf@kernel.org>
In-Reply-To: <yq5apkwqa5ve.fsf@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS4PPFA84FA90FC:EE_|BL1PR11MB6028:EE_
x-ms-office365-filtering-correlation-id: e7fa7e98-fb8a-4683-1253-08df38c9b2b7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|7416014|261021121427099003|261022105027099003|261022075727099003|261009223027099003|5023799004|38070700021|261026121527099003|261026140227099003|261028144727099003|4143699003|11063799006|10067099003|56012099006|22082099003|18002099003|6133799003;
x-microsoft-antispam-message-info: lJ2hRI/pTdXqyLaBn7MuHgr2YtTTkrNzIVKJOaq7wSPgOvgxiuziAW++OKr2NkjLJ4vW+WVQXBWeiN2+baJctcm0TtiNMmAniCR5y9UdNR8WnWR1Pl7OHasZSDsv91/QrMjfMd74AoKagMYm5aJ0JY8OCcNgo2p19YB0s7ofV9ehuqSrlA5NgE1UR/4lObZ1mYq7CnkydMlpeOenee9z/Cl7nx42TxEDS2iudwswwBWLO+e6OJZmK5PBnGm80bx+8oQ+C5TziOGPGRg7oK/xXBUycxeH1agZstT1ZuXpcYOjmJ0gWazVURifFNnaVixfVQMPjKJSPz/c1v4YuBiax27UIwPGsnF6Xv75M2xw4Y0moW1KIr9uYulhDzH9EiqjLLnXuOXHA2kjVAbppP8ypMz40JyqYlEJqYahxcp23CW181Rqq9ZhT1+ZrJHIBcyBRvimbzIRr7sCr9wV31JQVL08zV68BJ+0nW0ubmTCqE0yHq8tlhOg5itEdaHcO3/5+5v/ZMFMKlGS1SU/C/epqJtGYRVGa0dteSpG5B9vfW9ccdCm6Zb48aaHPRGRkyUkQiL3BxoHhmDFJytYNtogo8gZY8bJ4mjlHYO49IOeaUNxvZEnEREpYzwMZ7Zmt7L1+i3J3OJ2o0/DZWWS7oX1I4ppm0sZHNtENJXzf/7HPhoo+JnYOrO2qkyTwOlSHkdq
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFA84FA90FC.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(7416014)(261021121427099003)(261022105027099003)(261022075727099003)(261009223027099003)(5023799004)(38070700021)(261026121527099003)(261026140227099003)(261028144727099003)(4143699003)(11063799006)(10067099003)(56012099006)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QnF4TnhQdkNIem9WckJtWFpiVjRMb3dhME5TTmVtQ3ZLdmczcGw5T0pZd3Bn?=
 =?utf-8?B?N1Vhb2w4NXVHZ1BNMlFwV2xScmF4SFY1ZVQ0N1BFUlVJTVh3QU1jZTFIZVpZ?=
 =?utf-8?B?MVZWS2g3U0JHeWhuaEdPZUZQY2gwSHdxQUFCb0RhWEpjM1BYRjZWQmo4ZXds?=
 =?utf-8?B?bXB6WDk2eTVsK2VCdlFZaGQrRDF2MGc4cjdEVm1samc4TlZwVlczZVE2eERG?=
 =?utf-8?B?eFN3aG1pUldtdWFTRHE5K2hSczRQY0pUQVFOV3lBc2JmRXZMa2JIcVpqNUs5?=
 =?utf-8?B?eW5ZQzI5ZE93L1ZqeHRQeklPcjM3M3FqbE9UanMza3U0MWg4UjJZbG1hWEl5?=
 =?utf-8?B?bS9ObXpPNlEwbTdOV0VSby9QMVR2NVNVRFhzMVl5ZXZydVRVeDAvNzZPdlB3?=
 =?utf-8?B?YU9wUTQ5UW1EZHJ3MGhSRUlucWVWMDIxdGs3cTVvRzFZQmVTQWhlS2x5YlhY?=
 =?utf-8?B?MGhEVHJHMW9IcSt3ZGMzNEpYNlRaOUZ2dlJ5REhnRGlhYVdZdTVsK0pGd0lY?=
 =?utf-8?B?U1BBVXorUXN3VG0rb1lrYmNDN1RISklQYmx3eHBSMW5yT1U2d1EzcWVlQzJa?=
 =?utf-8?B?MUNXZWQ4elFZTDRMcEZiNUVScmIwV1BrYUdhNXJuWjZBOGR6dkZHOElQTHdJ?=
 =?utf-8?B?MURrMW04RmtiOGVHajBHcUQwSGs5aWxlYnFLVE5FcUdISHhTZkhKai9jc1Rz?=
 =?utf-8?B?UlJtd0VEancrTyt4Mm81c3FvS1pCd3VwOGRyaTRVNnp0d0xMMXBFRTdZWTE5?=
 =?utf-8?B?aVJaV3ZqR0Vna05KYm40TFFLWTNpRUVlMlJQU0J2djhzb3F2U1N0Kytob3pr?=
 =?utf-8?B?MTRuT0diYitQYmZIdWdiRTd4VTFnc2VLVWdsRG5DWm8vYkt4dk5PZWRFZ2Fw?=
 =?utf-8?B?UXA2YVppd3QyRFI3NkY3Y1diWk56Sm83c3l1RllTaUZvSEdYOWduVTV1Zk9W?=
 =?utf-8?B?QUJaUkxPSDBGRTQ1TVBZeXBZeHBYa0RhT0F1amplbXkyZjhSdjNqRHUyTnMv?=
 =?utf-8?B?VklzYkNxZFJaQ054U0I5ZGFuQlRtaG9pTWgyT29RQkxUL1FEbVU1WEQrdmhT?=
 =?utf-8?B?OUtuT01zL2xSUVowdnkvK2syWHp3NjFYM2EzM0NuT09tc3ZYd2l3YzJ6NENH?=
 =?utf-8?B?SFlTMHlJNHdGalU3dzVQR0tUU0xsVHJwY25TdVR1MHNnMmVXV3AyTDFWTDdP?=
 =?utf-8?B?bi95SWdXVzdXb1dvc2pwU2pzMTlVNzJxT2JQVUtTRVkvMVQvZG9ORDVoR0Iy?=
 =?utf-8?B?eUlFem9oajYxUlFHNTBhOXhqU1lRM2JIMElmaWdVcHk1NHZlQlErbGhBTkFT?=
 =?utf-8?B?MnNuSy9RNHhHT0hmZFg4S0RBN1puSytZTmNYeDl5OUQ5ekNjWXRGbU9HTndw?=
 =?utf-8?B?OGw5blRFbzFqcldDQklqVjhuNGxzTGVJaEc5MXA3RjEwNWozSTFIdWhycDRW?=
 =?utf-8?B?Tmd1L3FxbUpJc2pwQ0g4ZlZTaHNyU3o5cFc3Mkl0a0srMGs1QXpCMmN4WFFW?=
 =?utf-8?B?dmQwZnVweDI1emt4S3pOKy9veEJOdGJIR2xzN2Fvc1VzQWI3c0d2NG9oY0c0?=
 =?utf-8?B?ejU0bksvcGkyYVdxcXJpQlUyTGFmMHA1aFBpLzJ3T1dWNE1qSi9oazVOOWtO?=
 =?utf-8?B?NVRXNm1jbk5POG85d096T1h2cjE5QUZpT2l4WGFET00xVmlIVXZJUW1jZ2tB?=
 =?utf-8?B?U2hvQThUYkpkSTFFZ0dRZHhRajZsaEVHZldmeXhKaC9TTHFOWEYzajZGd25R?=
 =?utf-8?B?NE1vQ3VGYzNSUFBIN0NLZ3oxRkJNSEwrWFZJZUhLT3dKZTNvVHg0Yy81dExl?=
 =?utf-8?B?cUc1VmV1UW40OHN1Vi9jYnprYkg3d3Rxb3MzWFJ0cVo5N1J3eTJrQkpnZ09a?=
 =?utf-8?B?N2poNjA3RWtlRngwQVd0WmFlYU9iN0JPTmxQdDJCUWFMUUpBTmZiYnl2azlr?=
 =?utf-8?B?L3ZmVnRFQko1alBGV0ozMlpJUVZ3TFJJMTk1RlVuWHMvd2VqZDhYU0JONmhs?=
 =?utf-8?B?cCtaU1RzY1FZcDBqTENZbHJZcG1kamx1QnBad2hORFVYSmJtMHVZaVovZHc5?=
 =?utf-8?B?cDFzNm9FbVY4VUtpeUoyNHB2ZG9ZVGhiczBQV1JtckU5K2g5ZVhheURFckMz?=
 =?utf-8?B?VXJsbGE0RlgxUkZHTXB6SFVsWVRuWitmTkNYSFNyQWxJZTlJUG5wTW9PZTJ6?=
 =?utf-8?B?L2lFOWswZ1c0bi9McDFYVmJBM0JycFVyOTJVSjZxNDlJREJkZTlvaUU5K1p3?=
 =?utf-8?B?VUNMNElwbWxxM2QweXhBVCs5M3crUFR1cFVsM3BGM0dtVG5IZ2tmUGcweFls?=
 =?utf-8?B?bU9xSUM2WWFBNlk0N2VXQUdzTDBKWWw5VTZOaGlKTHlBQklZTEtKZz09?=
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
X-Exchange-RoutingPolicyChecked: iQ0SlAbM9y7UzIXStssrafbxZ3splxJqysqmS1PBAECM85tYvHy7TeWqKHoPBziQMT7un9QqrCQIRnmGR+DxQsj0Jb+TtRsNmWp3ZP42ZTQXkgAoHgeT51UpOJbNWnm+NbeU5KtrpAqKJJm0Ag7XG6zyp2wYYU72jrTbLRYGUOSKDKuq28FSBdKBdRoQ2g7wuY0xQt+KeQeyvgjlPxWpt7RVfz1EtReijY/Es85tb5FmSYQKfz+CrvhR/oRycB7IsgPKaynO2LAaH+Sp0leFZMAlivPCIO8/swZRUBxG7T8v/cfZbUg3f/EmzCGLAoLhZ8bYidu/qMmEnbN05R747g==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFA84FA90FC.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7fa7e98-fb8a-4683-1253-08df38c9b2b7
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Nov 2026 10:11:44.7464
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FF5+0IrJUAeRkLg8YI0KS1VEAxwv2rsRD12OwDqr3ukyiaThUNfRgK1BGzC5ptEcSpS9xyHknR7dr5vqT20S/iZjp0UWck+eW6iMbcz0Thk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB6028
X-OriginatorOrg: intel.com

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQW5lZXNoIEt1bWFyIEsu
ViA8YW5lZXNoLmt1bWFyQGtlcm5lbC5vcmc+DQo+IFNlbnQ6IFNhdHVyZGF5LCBPY3RvYmVyIDMx
LCAyMDI2IDU6NDcgQU0NCj4gVG86IEphc29uIEd1bnRob3JwZSA8amdnQG52aWRpYS5jb20+OyBS
ZXNoZXRvdmEsIEVsZW5hDQo+IDxlbGVuYS5yZXNoZXRvdmFAaW50ZWwuY29tPg0KPiBDYzogSmlh
bmcsIERhdmUgPGRhdmUuamlhbmdAaW50ZWwuY29tPjsgbGludXgtY29jb0BsaXN0cy5saW51eC5k
ZXY7IEppcmkgUGlya28NCj4gPGppcmlAcmVzbnVsbGkudXM+OyBUaWFuLCBLZXZpbiA8a2V2aW4u
dGlhbkBpbnRlbC5jb20+OyBBbGV4ZXkgS2FyZGFzaGV2c2tpeQ0KPiA8YWlrQGFtZC5jb20+OyBY
dSBZaWx1biA8eWlsdW4ueHVAbGludXguaW50ZWwuY29tPjsgQ2F0YWxpbiBNYXJpbmFzDQo+IDxj
YXRhbGluLm1hcmluYXNAYXJtLmNvbT47IFN1enVraSBLIFBvdWxvc2UgPHN1enVraS5wb3Vsb3Nl
QGFybS5jb20+Ow0KPiBTdGV2ZW4gUHJpY2UgPHN0ZXZlbi5wcmljZUBhcm0uY29tPjsgS2lyeWwg
U2h1dHNlbWF1IDxrYXNAa2VybmVsLm9yZz47DQo+IEVkZ2Vjb21iZSwgUmljayBQIDxyaWNrLnAu
ZWRnZWNvbWJlQGludGVsLmNvbT47IERhdmUgSGFuc2VuDQo+IDxkYXZlLmhhbnNlbkBsaW51eC5p
bnRlbC5jb20+OyBKb25hdGhhbiBDYW1lcm9uIDxqaWMyM0BrZXJuZWwub3JnPjsgQmpvcm4NCj4g
SGVsZ2FhcyA8YmhlbGdhYXNAZ29vZ2xlLmNvbT47IEFzaGlzaCBLYWxyYSA8YXNoaXNoLmthbHJh
QGFtZC5jb20+OyBUb20NCj4gTGVuZGFja3kgPHRob21hcy5sZW5kYWNreUBhbWQuY29tPjsgSm9o
biBBbGxlbiA8am9obi5hbGxlbkBhbWQuY29tPjsNCj4gV2lsbCBEZWFjb24gPHdpbGxAa2VybmVs
Lm9yZz47IE1hcmsgUnV0bGFuZCA8bWFyay5ydXRsYW5kQGFybS5jb20+Ow0KPiBwYXRjaGVzQGxp
c3RzLmxpbnV4LmRldg0KPiBTdWJqZWN0OiBSZTogW1JGQyBQQVRDSCB2MSAxMC8xMV0gdmlydDog
Y29jbzogYXJtLWNjYS1ob3N0OiBQdWJsaXNoIHNsb3QgemVybw0KPiBhbmQgZXN0YWJsaXNoIHN0
cmVhbXMgYWZ0ZXIgYWNjZXB0YW5jZQ0KPiANCj4gSmFzb24gR3VudGhvcnBlIDxqZ2dAbnZpZGlh
LmNvbT4gd3JpdGVzOg0KPiANCj4gPiBPbiBGcmksIE9jdCAzMCwgMjAyNiBhdCAwOTo1ODowM0FN
ICswMDAwLCBSZXNoZXRvdmEsIEVsZW5hIHdyb3RlOg0KPiA+PiA+ID4gSXQgY2FuJ3QgZGVmZXIg
dGhlIHNlc3Npb24uIFRoZSBURFggTW9kdWxlIHJ1bnMgdGhlIHdob2xlIFNQRE0NCj4gPj4gPiA+
IHNlc3Npb24gc2V0dXAgaW5zaWRlIFRESC5TUERNLkNPTk5FQ1QsIGFuZCB0aGUgaG9zdCByZWxh
eXMgaXRzIERPRQ0KPiA+PiA+ID4gbWVzc2FnZXMgd2l0aG91dCBpbnRlcnByZXRpbmcgdGhlbSwg
c28gdGhlcmUgaXMgbm8gZGVmaW5lZCBwb2ludCB0bw0KPiA+PiA+ID4gc3RvcCBhZnRlciB0aGUg
Y2VydGlmaWNhdGVzLiBUaGUgY2hhaW5zIGNvbWUgYmFjayBpbiB0aGUgZGV2aWNlIGluZm8NCj4g
Pj4gPiA+IG9ubHkgb25jZSBUREguU1BETS5DT05ORUNUIGNvbXBsZXRlcyAoVERYIENvbm5lY3Qg
QUJJIFJlZmVyZW5jZQ0KPiBTcGVjDQo+ID4+ID4gPiAyLjEgdjAuNjYsIDQuMi4yMC4xKS4NCj4g
Pj4gPg0KPiA+PiA+IFllYWgsIGl0cyBmaW5lLiBURFggd2lsbCBoYXZlIHRvIGRvIHdoYXQgQW5l
ZXNoIHByb3Bvc2VkIGZvciBBUk0sIGFuZA0KPiA+PiA+IHVzZSB1c2UgdGhlIFJ1c3QgU1BETSBE
cml2ZXIgdG8gb3BlcmF0ZSBET0UgcHJpb3IgdG8gY2FsbGluZw0KPiA+PiA+IFRESC5TUERNLkNP
Tk5FQ1QuIFRoaXMgd2lsbCBhbGxvdyBkaXNjb3ZlcmluZyB3aGF0IGlzIGluIHRoZSBzbG90cyBh
bmQNCj4gPj4gPiBwYXNzaW5nIHRoYXQgaW5mb3JtYXRpb24gdG8gdXNlcnNwYWNlLg0KPiA+Pg0K
PiA+PiBJIGFtIHNvbWV3aGF0IGNvbmZ1c2VkIGJ5IHRoaXMuDQo+ID4+DQo+ID4+IDEuIFlvdSBh
cmUgc2F5aW5nIHRoYXQgcHJpb3IgdG8gZXN0YWJsaXNoaW5nIGENCj4gPj4gc2VjdXJlIFNQRE0g
c2Vzc2lvbiwgeW91IHdpbGwgdXNlIHVuc2VjdXJlIERPRSBtZWNoYW5pc20gdG8gZGlzY292ZXIN
Cj4gPj4gYXZhaWxhYmxlIGNlcnQgY2hhaW5zLiBIZXJlIHlvdSBoYXZlIHRvIHRha2UgaW50byBh
Y2NvdW50IHRoYXQgYW55dGhpbmcgeW91DQo+ID4+IGdldCBhdCB0aGlzIHN0ZXAgaXMgbm90IHRy
dXN0ZWQuIEEgbWFsaWNpb3VzIGRldmljZSBjb3VsZCBzZW5kIHlvdSBhbnkgY2VydA0KPiA+PiBj
aGFpbnMgZnJvbSBhbm90aGVyIGxlZ2l0aW1hdGUgZGV2aWNlLg0KPiA+DQo+ID4gSSBwb2tlZCBh
dCB0aGlzIHdpdGggQUkgZm9yIGEgd2hpbGUuLiBXaGlsZSBub3RoaW5nIGFib3V0IFNQRE0gc2xv
dHMgc2VlbXMNCj4gPiBwYXJ0aWN1bGFybHkgY2xlYW4gaXQgY2FuIGJlIG1hZGUgdG8gd29yay4g
SXQgbG9va3MgbGlrZSAxLjQgaW1wcm92ZXMNCj4gPiB0aGluZ3MgbWVhbmluZ2Z1bGx5Lg0KPiA+
DQo+ID4+IDIuIE5leHQsIHlvdSB3aWxsIGNob29zZSBhIGNlcnQgc2xvdCB0byBiZSB1c2VkIGZv
ciBTUERNIGF1dGhlbnRpY2F0aW9uIGFuZA0KPiA+PiBzZWN1cmUgc2Vzc2lvbiBlc3RhYmxpc2ht
ZW50IChzbG90IDAgaW5pdGlhbGx5IGluIHRoaXMgcGF0Y2gpIGFuZCBhbGxvdw0KPiA+PiBldmVy
eXRoaW5nIHRvIGhhcHBlbi4NCj4gPg0KPiA+IFllcA0KPiA+DQo+ID4+IE5vdywgd2hvIGd1YXJh
bnRlZXMgdGhhdCBhIGNlcnQgY2hhaW4gdGhhdCB5b3Ugc2F3DQo+ID4+IGF0IHN0ZXAgMSBmb3Ig
dGhlIHNlbGVjdGVkIHNsb3QgaXMgdGhlIHNhbWUgdGhhdCBpcyBnb2luZyB0byBiZSB1c2VkDQo+
ID4+IGluIGFjdHVhbCBTUERNIGNvbm5lY3Rpb24/IFdobyBpcyB2ZXJpZnlpbmcvZW5zdXJpbmcg
dGhpcz8NCj4gPj4gS2VybmVsPyBVc2Vyc3BhY2U/DQo+ID4NCj4gPiBOb3Qgc3VyZSwgaXQgd291
bGQgbWFrZSBzZW5zZSBpZiB0aGUga2VybmVsIGNhbiBkbyBzb21lIG9mIHRoaXMgd2l0aA0KPiA+
IHJ1c3RzcGRtLCBidXQgdGhlcmUgYXJlIGFsb3Qgb2YgZGV0YWlscyBoZXJlIHRoYXQgSSBjYW4n
dCBndWVzcyB3aGF0DQo+ID4gaXMgYmVzdC4NCj4gPg0KPiA+IEFJIHRlbGxzIG1lIHRoZXJlIGFy
ZSBhIGNvdXBsZSBvZiByZWFzb25hYmxlIHdheXMgdG8gaW1wbGVtZW50IHNsb3QNCj4gPiBzZWxl
Y3Rpb24gYW5kIGF2b2lkIGRvd25ncmFkZSBhdHRhY2tzOg0KPiA+DQo+ID4gMSkgV2l0aCAxLjQg
bWF0Y2ggR0VUX0RJR0VTVFMgYW5kIE1VTFRJX0tFWV9DT05OX1JTUD10cnVlDQo+ID4gICAgMSkg
RG8gdmlhIFJ1c3RTUERNOg0KPiA+ICAgICAgICAgR0VUX0RJR0VTVFMgLyBESUdFU1RTDQo+ID4g
ICAgICAgICBHRVRfQ0VSVElGSUNBVEUgLyBDRVJUSUZJQ0FURQ0KPiA+ICAgIDIpIFVzZXJzcGFj
ZSBzZWxlY3RzIHNsb3RzDQo+ID4gICAgMykgVFNNIG1vZHVsZSBkb2VzIHN0YXJ0dXAgYW5kIGFs
c28gaXNzdWVzICdHRVRfRElHRVNUUycgYXMgcGFydCBvZg0KPiA+ICAgICAgIHRoZSBzaWduZWQg
dHJhbnNjcmlwdA0KPiA+ICAgIDQpIENvbmZpcm0gdGhhdCB0aGUgZGlnZXN0cyBmcm9tICMxIG1h
dGNoIHRoZSBkaWdlc3RzIGZyb20gIzIgaW4NCj4gPiAgICAgICB0aGUgVFNNIHRyYW5zY3JpcHQu
DQo+ID4NCj4gDQo+IEkgYW0gY3VycmVudGx5IGRvaW5nIHNvbWV0aGluZyBzaW1pbGFyIHRvIHRo
ZSBhYm92ZS4NCj4gDQo+IGh0dHBzOi8vZ2l0LmdpdGxhYi5hcm0uY29tL2xpbnV4LWFybS9saW51
eC1jY2EvLQ0KPiAvY29tbWl0LzA2NTdkMTY3YWVlMWJhNDNkZDI3NjVkOTliNWUzMjQ0YjgzYzZl
YTYNCg0KSWYgSSB1bmRlcnN0YW5kIHRoaXMgY29ycmVjdGx5LCB0aGlzIGlzIG5vdCBxdWl0ZSB0
aGUgb3B0aW9uIDEgdGhhdA0KSmFzb24gcHJvcG9zZWQgYWJvdmUuIFlvdSBkb250IHVzZSBHRVRf
RElHRVNUUyBhbmQgSSBkb250IHNlZQ0KYSBiaW5kaW5nIGJldHdlZW4gY2VydCBjaGFpbiBkaXNj
b3ZlcmVkIHByaW9yIHRvIFRTTSBTUERNDQpzZXNzaW9uIGFuZCB0aGUgb25lIGR1cmluZyB0aGUg
VFNNIFNQRE0gc2Vzc2lvbi4gDQpPciBhbSBJIG1pc3VuZGVyc3RhbmRpbmcgaXQ/IA0KDQpCZXN0
IFJlZ2FyZHMsDQpFbGVuYS4NCg==
