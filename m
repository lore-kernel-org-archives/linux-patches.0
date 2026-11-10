Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=198.175.65.13
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794316514;
	b=dqIAJ1ehz1vVkrdzQR9mSHJKqp93PoiptLutew+xpBfaGM9VZ1AFH4pKrGW69mJDT6Ab
	 3vBOI0EQkZiMrR/Q/oKKqferahDRCb5trMeZ9keT6kMQOwR2geMDsguAt4Gk7LXeTA0FH
	 PIaeQLYjko1CZyrrmZerJRIf2+u0LosN9WGOSI1ZIuqFk9ZZio8GRGOmI5C/S+IxJPkbG
	 OQ9450f95/P53xFIcYnbmY3zwrmCAui7RfIaU/FM1RPrLar9mLcN8sFZ/2gz0fXGAjY/7
	 5swrFVB/g5WwivcNPMNJlxuee3Mv5i/+CZYxg8R82xzbfS7ppNMzl3GGjbgdpA/QZlA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794316514;
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
	bh=0GjDq1WsIyx8tLro05DeHVSmMlGK0f794QIiecCfZLU=;
	b=Tb50Pdhx4L/muQwXxTtjX0KeOF7JYHIbKCnveu99qtUSYx75hYEYxwDER8sFuW3mmv9o
	 KEk06NfWHtdAt2FdASjHZy7tyz0SDOz8Px2G4DN1fua6oVJCWUthyH6w/xAuyq6on9RDa
	 w/hNRujYVcXtz72lll38equZMdiJcH3VKgLFCEqU2rRphbWZEJBHLVzW3494J5jdG7x8e
	 /UkbCUqZfFqfUeTkk2FLHLd91Vp7UpyqKRMKilDBjjsqK5hR10/wNMNSu8nuJ1NuOgQun
	 Hla8EmMquFyXsJNWj1rr3Kuc2BTy3LHrNhLkcKADpPTWsgPT6bqmuwFaiUr9OQf+nlQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b="FQ4CGvu/";
	arc=pass header.oldest-pass=0 smtp.remote-ip=198.175.65.13
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 756D0606A7F4;
	Tue, 10 Nov 2026 13:15:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 756D0606A7F4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=FQ4CGvu/
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794316512; x=1825852512;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0GjDq1WsIyx8tLro05DeHVSmMlGK0f794QIiecCfZLU=;
  b=FQ4CGvu/zaF8u2wdpXMk3GLtb00UEhJHM+WU3S88iv0UuuXq3HxdhuGr
   w8S1KnXNTmCfsevUtPBWCwcK1HXtHSpbCOI7uiN2n1xmY3fc8fapwepUf
   pxi9k8TTwh6wVrCC3udu+oCBCNFBF9NB7ZuV2a5tLSftr2Wd9qjpN/U5p
   W1AQwF0oo9dM86VWi6z3SDE05CkZ1b5Zh9sC46gNqB4H9m8K0PZjvd/A7
   1jICdeE3iHZkcANK8u0NemR5wBKVW+AqSmKPqQAHJHP1GlG2Kj6Oah5n/
   6GOdbYy4uFwmkmJ81N8P+MomI0y08e/hZPcHV+bNVpHe9I+XSiXTQlgBv
   Q==;
X-CSE-ConnectionGUID: 0mT0n8+GQwmHE3SZfy4ygg==
X-CSE-MsgGUID: 0i2OsPFyRoakH2toxFsMkw==
X-IronPort-AV: E=McAfee;i="6800,10657,11961"; a="2938107"
X-IronPort-AV: E=Sophos;i="6.27,205,1787036400"; 
   d="scan'208";a="2938107"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2026 05:15:12 -0800
X-CSE-ConnectionGUID: KlE4C9Y7T2yrnpSX9ANYWg==
X-CSE-MsgGUID: gmj28BlWRAGJF0iJ00lq4Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,205,1787036400"; 
   d="scan'208";a="8009974"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2026 05:15:12 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 10 Nov 2026 05:15:11 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56 via Frontend Transport; Tue, 10 Nov 2026 05:15:11 -0800
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.51) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 10 Nov 2026 05:15:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kSgb53ZarvrSCZ9fy4M1IVcX5Vte3giQWPBcnW+11EZ9DmqxsJLBETufGQih8l7ZQpfOY1l4Wp3SoZaJ+H7mpPn+BhmfQcRRaWBG2nc9B0+y0rkUcNSPN9xsd7x2jf0chGMWewA67KLl8TgGFAtFzpBBDOx6rLCEksegQjM05LOz7NBf50xxwQ5ZTcgaM++iXuTHzMjvbk2CP0/RrDeeg0SX7IHoUrHkh7ZayXv24HPLTHH7otUEiCK3c6W+XveQffUna5YT5uTbyqnsfEEkJYcpFUUhAzVGZF6GOmMmF8QiCjSGs/L3U/kyX5Sh8YoiaRO8QxthtwXK1yA9Pkojsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0GjDq1WsIyx8tLro05DeHVSmMlGK0f794QIiecCfZLU=;
 b=GOXx1Dc6zUUIgkPFLN5CzHbGevWBsrpgXg7h03PZolyugQgDTM6Jaa0cj0QJtzzmQmhrwU3yPRsA98Tw59U/egcTxrIffbjACa1QVzQfhUaXMX5pom/SkMLv7p3tg7MvrNAxge8YQLWwFrHkG9J5bFziCkd/42kogLZW73cDnLkXj/zwlmFVNmVhK/WHVHLet2lw94/VoMQdJNSAsxKxqQC1XzVdkdzvbmivOOcS0DM//5sxY/JJgfTWM5o2o1+QfTVmX2okNW+/r2tjYw3kzyeUZTV4aSSOt4QrhwZdJWINdlxfBCfuxh6flqVlWKQRbe6ypojcVdIu2NodHSc3CQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from IA3PR11MB9160.namprd11.prod.outlook.com (2603:10b6:208:57a::19)
 by LVWPR11MB9881.namprd11.prod.outlook.com (2603:10b6:408:3be::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Tue, 10 Nov
 2026 13:15:07 +0000
Received: from IA3PR11MB9160.namprd11.prod.outlook.com
 ([fe80::9bec:6a7a:c06d:741]) by IA3PR11MB9160.namprd11.prod.outlook.com
 ([fe80::9bec:6a7a:c06d:741%4]) with mapi id 15.21.0592.010; Tue, 10 Nov 2026
 13:15:06 +0000
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, "Jiang, Dave" <dave.jiang@intel.com>
CC: Xu Yilun <yilun.xu@linux.intel.com>, Aneesh Kumar K.V
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
Thread-Index: AQHdZvIx/4WLyAKeS0CHM51th/PLq7cUvvoAgAAECYCAARZEYIAAOl2AgADzg4CAA46ocIAAevEAgAEloGCAAEhmgIABGSiAgAAXIXCAAEdkgIAANdmAgAMTyoCAADyIAIAANPsAgALf2ICAAYKUAIAAFT2AgAAiAYCAAC5DAIAA4I+w
Date: Tue, 10 Nov 2026 13:15:06 +0000
Message-ID: <IA3PR11MB91609724D29DA39CB0AAE25AE7722@IA3PR11MB9160.namprd11.prod.outlook.com>
References: <DS4PPFA84FA90FCDC94900C2FC6CEF4D428E7682@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261104134119.GR274202@nvidia.com>
 <a3f95140-c49f-42fc-b92c-73c8cf98336d@intel.com>
 <e05a71df-3b20-45a3-bb46-fb1bdad164c8@intel.com>
 <20261106193018.GK770409@nvidia.com>
 <53bc57bf-1ee1-407a-b48b-bc6b2deee12a@intel.com>
 <20261108183337.GL770409@nvidia.com>
 <2b89b830-f1e4-4304-93ee-40287a4b5b2d@intel.com>
 <20261109185315.GS770409@nvidia.com>
 <e1fe8fa5-7bcd-46e3-bfe8-368582304222@intel.com>
 <20261109234032.GT770409@nvidia.com>
In-Reply-To: <20261109234032.GT770409@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA3PR11MB9160:EE_|LVWPR11MB9881:EE_
x-ms-office365-filtering-correlation-id: 143b5339-fe0f-4cc5-6dbc-08df3f2ca3af
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|7416014|18002099003|22082099003|4143699003|11063799006|56012099006|10067099003|261028144727099003|261102123227099003|261009223027099003|261026121527099003|261026140227099003|261022075727099003|261022105027099003|261021121427099003|38070700021;
x-microsoft-antispam-message-info: 13Ab4+hSRQv7+0qElnW+EXYNdmU0KHw60WkcCFdXvfcgEBMSz5Njm5HzU2x3Q4w25WwG4+b8GJM0i3BaoPrY+59hrs+QySl0/L7j0HSKVz+xOrdFbeg0foWR7esDlaIEVQRIZZCPvPvLNCLWgBBDpgILzrC39gQszXDpYLJkzLtPfp6RSL6CAlUO5kB2rpY4yxA8rnBXz6PEJYObXQgRfle7t4jST1uyJKF27mRy/voz8nPmECP95T+aIJC4ULVRXL5cod6ZNYt/8KDCd6z5XfE7XGINTOdHn9j4wLQYzL3dtyOT7PZqi09lWZ+WWHsBic8kb6oyLGL33s/VEPitP9piim2MC5fWJzFPbfsS1BUU7dbv5w8fvZ2jHTuWEybkzi6bwPNgLSq/2JFgJwXReT8hMp04BiRdPH8b7x1rFTQqsfF51/wVWpV3oePPlmYbJlpxNQROdfHqlBv+fSFAaBFqpJUPsiVCgnFp3zipA3B4cfOku9+WBL2dtGd56VdJirFMP+0ILiXR+5XTo3id0QVYZAGtcpXHWxbHMdDrgXOjAyByl3lgGoGSxr9XYGcvfLARzUZ9NYTxn1ZBuFkNfC1n91CxJSWsZdDOp4/1D2NgsqWvpMbgpYxpFiRSUPGLQnV4zOW78az+oVfKHZttHtJ0zZOM+m3et/+mhZ1uFUh4ZYgrUMrWF0kplJOCdnw1idK0UGut5b4AsHU0bjQtpxpClV+yB5HcSINrpGg+xZg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA3PR11MB9160.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(7416014)(18002099003)(22082099003)(4143699003)(11063799006)(56012099006)(10067099003)(261028144727099003)(261102123227099003)(261009223027099003)(261026121527099003)(261026140227099003)(261022075727099003)(261022105027099003)(261021121427099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZkZDV0F2WjNaODdlOThzNGFPUmJ5VkdjRXlTaFF6Vlg0NFFMMHcwYk84VnZ3?=
 =?utf-8?B?TW9SeFJPakJYQ3JWbFM3SDd6QktTOHM5M1cwTEdCUkhhdUVUM0xHVHNrQU80?=
 =?utf-8?B?ZDE1SmppRkN2eTd1angwVFBLMVZkb1ZkTnZ6ekpleWZlVk5VR1pqQVBZV0k2?=
 =?utf-8?B?ek9LL1REVkxmS1M3aUtCL3Uyb21MODhDSTFnUWwrTTY2VUFvZW9DbHNWanpZ?=
 =?utf-8?B?bmtDUDdSaWVtUGljNjRKbDJEUDVNdnVrT1dWMVJCVFlkVDFCb2w4TU01cTBl?=
 =?utf-8?B?U3J6NHBLKzdmSUJHNml3UFJtNU5lZ3M4TVo3aFZqQkxKQ3E1ZUgvSkVtdWVx?=
 =?utf-8?B?STNzeDYrUFMvVzlMcmVscVFwWnVTQ05sZUg3Y2NQckc2ZVdPQ0dtTWVmTTJ2?=
 =?utf-8?B?T1o0RmtDQVJJbWY1NXUwd3ZvUVpjQkptak5iNk1WazR1bVd2eHl0SWxSYkdE?=
 =?utf-8?B?MTJndnpDOWpBYkJXTGVEdE41THN3dmxjVlM3WmtVL2djTHFwRUtoY3E3Z1J3?=
 =?utf-8?B?bjlpTU5yRUx6MlFzbGF1OG1rd0NzcHFxR0xQOUZRT3E0ZDYveFpDOVFSVmlt?=
 =?utf-8?B?MVBJRjV2RE1peXdRWFlXTVltVmlPblpiSnl6TURGYUdKbmJtUUllcFYvb0U1?=
 =?utf-8?B?UjlFd1VtbGMxYVBJK0RyT2p0Vlg3SU1mcGpySzA4YjB0cVpubjJleVdHSnpB?=
 =?utf-8?B?akFrU0NnMEdMRk8rUnNmNVJSbHhpYzRFQlpXSUNZUjJ0bnUzOHArV1JhTGFy?=
 =?utf-8?B?aXRidFNBdWFkOTZ0bFZObVN6MGg5akJnd3lDTk1CUTNuS0EzMm5KdGFrMUFG?=
 =?utf-8?B?cHlpS09EdU9yZnozVnBOTjkzc3NWcm9iMkZ5R05mdHo3QUVhRTh3SzliSzlT?=
 =?utf-8?B?b2lFdDRKSkcrZmxjMnhWSHozSTBoWHgrb2YxcFN4aHpIVVlUTThEQmhZS3BH?=
 =?utf-8?B?QmlYSlNuYnFPTGttV2xWK1hKcVR1eDVJMGs3QndxL2p6bEt6S2hlR2dSRE1Q?=
 =?utf-8?B?RmlKcUlKTHNyamlSTDh6SG9LWUduc0tKUFBsUytkbkNIcjdTbjhtVXU3ZXEr?=
 =?utf-8?B?bkhoR0FwRThtM240aXZlclh4azJVUzM4bXpjS1owZHM5VGZiNnJoMHF3R05Q?=
 =?utf-8?B?aU5SeWFwRzVCV3hqclpKcERZaCs3YTJJTjczRnlPTVJQWXZpTjBPdzNjUkQy?=
 =?utf-8?B?ODJXc1dTdGlFaXZHQ3RRaHRYdjh2WG1lRGtFVHRDSnZibHZuQnkyK2VwalhI?=
 =?utf-8?B?N2tDTzlRSTJWemU4Wjg5QXNWbysxTEpKOTRBTUVDZGlWT05KQi91NVhnbzJT?=
 =?utf-8?B?eVk4T0ExTmhVQjBjWWQzQTZwYlk0RC9BbFY0WWFnRTVOek1YaFNLVHVBZ1lL?=
 =?utf-8?B?MG53djFNR3g4R0xXV3hCT08xK1Y5eDN0NEF5WlUzcnArb1hrZ3N4bzBhaGox?=
 =?utf-8?B?cGJ3OEdKSy94WVgzSW9NL3FVOGRuS0FOTEtYc05pUnBPZ25MZHAvWm9TQlBG?=
 =?utf-8?B?ZmVDV0VMQnpMRkl4YTdGMjkyeHcvS2FaNlFab0xVVHYwUnNCd2FoK2xmaG01?=
 =?utf-8?B?MnBvMmx4QjVPSnFpUmpkamp2WTR4cGNBc2ZET0ZHL2s5MjJxWVV6ZTVOZzBV?=
 =?utf-8?B?Y0lqbm1IczlTa0lQdHBPSlJFZ0hjTUhXUktuSmhUQjVRbTVmWWpucmE0c0hK?=
 =?utf-8?B?YWk4M0w1bFFXdVBTTGdiNE5aS0IwSVptSW5FVVlld2kwOHZGMGUzMUpMS2Ri?=
 =?utf-8?B?SHNYdkl5SWMvUWE3VktRSmtSdEtxNzh2QjJNTFZhVVpNWjRvUTJ5R0lFK2o5?=
 =?utf-8?B?bEo4Wk5ZL0JuYTdLbkpEa3FhSXdYV0RuWnJ0Y0F5RE1RQndLTnQvU3QxYVdL?=
 =?utf-8?B?N3lPY0NFUXhNS3Nhai9wMEIvRGpNNi9zbGkwVVFnN0hKU3ViNWU4RUwrQlo0?=
 =?utf-8?B?engxWXAvZTJwYkNncGJWN1dKbStET2lNN1VnaWlYc3YxWDZ1MFN6R1oxSFV5?=
 =?utf-8?B?ZHJjWjh4V0dQWUl4VVVVZHVEMWhycndnYi93Q284cFA3UmwzVnVrMTl0Ymlp?=
 =?utf-8?B?QzVJQjF3WERha1lLZ2dEbHVNa1VXOFBJWEppTlB2YjYwTytJRndTQlg3d2lC?=
 =?utf-8?B?blpWOTgvQnVaYTloS0xrdldHaHF3Ly9oMmFXTk5aVE9TcVFlelh2VTQreUo2?=
 =?utf-8?B?UVFNUldLVE1PVG5sajFKZW56NXdOcER4Sjd0MGg2ZmhORHJEMnYxMlNqK1RI?=
 =?utf-8?B?bDQvSUhEaC9SYzRjVlltT3lzWHJTUDF1eFl2T3RmVFMrcTBZVDIzaG9PQmdk?=
 =?utf-8?B?UUxXYWJpK1E5cUFOamJaQXFUZzN2dWNXT0lwck55ejB2SXdsazhuZz09?=
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
X-Exchange-RoutingPolicyChecked: NQIveph40ENP40jJlpSwQ7L/llqXTFSZk5LxBnsUYDpXsjOlo92+awQ1rUr4TTtz89pjNemV5wtTKKDr7wmekdvKVklQDM47x5fniesPoZO6ozIO7efT2kH2rYBr7nq9y7sW9kcUVBVcBTnPqALvQXJkEfVeLZQVf39obY57uBTiTobsivkfx+9IPIbOq0QGvrw20oGrbAfE4bJVXS6isHW5wFuMeMFIA4yi4e4A/alTH9GrCwf8mRj/TCrgGtv/1kDDgkvgH24/G1CPBhd5AO30XfwGC4IFUyEMzJ6NLHaNduYwJjLcCxbZEkVkf/Npdy7mnjDhWuvNZw+JnODqwA==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA3PR11MB9160.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 143b5339-fe0f-4cc5-6dbc-08df3f2ca3af
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2026 13:15:06.6996
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tzJm6FLl545MrC0iF8scTO57g0rk6HNe+PxBjR4NF2aLyBs7H1eYZYEx6CEm/GkRtiJZ5V2NiE2UgH8C3jXv0SXMWJhw8u+c2qq4z4W+MqY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LVWPR11MB9881
X-OriginatorOrg: intel.com

DQo+IE9uIE1vbiwgTm92IDA5LCAyMDI2IGF0IDAxOjU0OjU3UE0gLTA3MDAsIERhdmUgSmlhbmcg
d3JvdGU6DQo+ID4gPiBXaHk/IFNlZW1zIGxpa2UgYW5vdGhlciB3YXN0ZWQgb3BlcmF0aW9uLi4N
Cj4gPg0KPiA+IFRoZSBURFggbW9kdWxlIHJ1bnMgaXQgYXMgcGFydCBvZiB0aGUgY29ubmVjdCBh
bmQgd2l0aCB0aGUgY3VycmVudA0KPiA+IG1vZHVsZSB0aGUgaG9zdCBjYW4ndCBza2lwIGl0LiBJ
J2xsIGRpc2N1c3Mgd2l0aCBFbGVuYSBhbmQgc2VlIGlmDQo+ID4gdGhpcyBjYW4gYmUgZGlmZmVy
ZW50Lg0KPiANCj4gRG9lcyBpdCBjb21lIG91dCBhbnl3aGVyZSBhbmQgYmVjb21lIHZpc2libGUg
dG8gdGhlIGhvc3Qgb3IgZ3Vlc3Q/DQoNClllcywgaXQgaXMgdmlzaWJsZSB0byB0aGUgaG9zdCBr
ZXJuZWwgYXMgcGFydCBvZiB0aGUgaW5pdGlhbGx5IHJldHVybmVkDQpTUERNX0RFVklDRV9BVFRF
U1RBVElPTl9JTkZPX1Qgc3RydWN0dXJlLiBUaGUgZ3Vlc3QgY2FuIGdldCB0aGUNCnJlZmVyZW5j
ZSBoYXNoIG9mIHRoaXMgc3RydWN0dXJlIGZyb20gdGhlIFREWCBNb2R1bGUvVFNNLg0KDQpUaGlz
IHdhcyBkb25lIG9yaWdpbmFsbHkgdGhpcyB3YXkgKGFzIGZhciBhcyBJIHVuZGVyc3RhbmQgdGhl
IGRlc2lnbikgdG8NCnN1cHBvcnQgYSBzaW5nbGUtc3RlcCBhdHRlc3RhdGlvbiBhdCB0aW1lIG9m
IFNQRE0uQ09OTkVDVCB0aGF0IGENCmd1ZXN0IGNhbiBnZXQgYWxsIGluZm9ybWF0aW9uIGl0IG5l
ZWRzIGZyb20gdGhpcyBzaW5nbGUgc3RydWN0dXJlLCBhbmQgbm90DQpyZXF1aXJlZCB0byBhc2sg
VFNNIGV4cGxpY2l0bHkgdG8gZG8gR0VUX01FQVNVUkVNRU5UUy4NCg0KQW5kIHllcywgdGhpcyBt
aWdodCBiZSByZWR1bmRhbnQgZm9yIExpbnV4IGlmIHlvdSBleHBsaWNpdGx5IHJlcXVpcmUgc2Vw
YXJhdGUNCmNhbGwgdG8gR0VUX01FQVNVUkVNRU5UUywgYnV0IG90aGVyIE9TZXMgbWlnaHQgaGF2
ZSBkaWZmZXJlbnQgcmVxdWlyZW1lbnRzDQphbmQgVFNNIGFyY2hpdGVjdHVyZSBtdXN0IHN1cHBv
cnQgYm90aC4gDQoNCj4gDQo+ID4gPiBJbiBwcmFjdGljZSB0aGlzIG1lYW5zIGFsbCB0aGUgVFNN
cyB3aWxsIG5lZWQgdGhlIGtlcm5lbCB0byB0ZWxsIGl0DQo+ID4gPiB3aGF0IFNQRE0gdmVyc2lv
bnMgaXQgY2FuIGdvIHVwIHRvLg0KPiA+DQo+ID4gVERYIGhhcyBubyBpbnB1dCBmb3IgdGhhdCB0
b2RheS4gV2lsbCBkaXNjdXNzIHdpdGggRWxlbmEuDQo+IA0KPiBOb2JvZHkgZG9lcywgYnV0IEkn
bSBpbnRlcnByZXRpbmcgdGhhdCBhcyBtZWFuaW5nIDEuMiBkb2Vzbid0IHJlcXVpcmUNCj4gYSBm
bGFnIGFuZCBpZiBhbnlvbmUgZG9lcyAxLjMgdGhleSB3aWxsIHRoZW4gbmVlZCB0byBhZGQgYSAn
ZW5hYmxlDQo+IDEuMycgZmxhZyBmcm9tIHRoZSBrZXJuZWwsIGZvciBleGFtcGxlLg0KDQpXaGF0
IGFib3V0IHdoZW4gaXQgaXMgbm90IGFib3V0IFNQRE0gdmVyc2lvbiwgYnV0IGFib3V0IGNhcGFi
aWxpdHkNCihzYW1lIHdoYXQgQWxpc3RhaXIgcG9pbnRlZCBvdXQgZm9yIGtlcm5lbCk/IEkuZS4g
aXQgc3VwcG9ydHMgMS4zLCBidXQNCmRvZXMgbm90IHN1cHBvcnQgbXVsdGkta2V5PyANCg0KQmVz
dCBSZWdhcmRzLA0KRWxlbmEuDQo=
