Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F32FD132123
	for <patches@lists.linux.dev>; Thu, 13 Jun 2024 21:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718312580; cv=fail; b=HP/SJPXd0pAJi+lkb3mTFB6/rlIOnmAUKL0INIHx1yTUYyn94P2OfK4n9WjNCfouzagoAfAeV0k0fFjo6nuB1t3v1RX2j8VzRdZ4m1uuWZ9pdVMgr+I6NGfwSCr0mCXa7SgoRTNk2zBLfsCI6Ve9XVL1uswnvbk03h5NruYxQiA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718312580; c=relaxed/simple;
	bh=8GSep0x5Wx5HJ7FQB7FQ9SeLu2xs2jhRb7XK1/SkskE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=sEDdjaAfQI3PRAJAWY4y0AhiHGVqvATzfkVzIUAea+Vtxo6mQbBBMe8b3Wq743qWi02b66cjLG++3lFaj06ySEN5+GmRDiI7Xu6aCcfBGlTWjbCXxt2rUKwN1pA1DEkcLWjYR8+wvYEVi7BGPI9Egndcq8ir0BjprBqujKeoFig=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HCqJRPly; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HCqJRPly"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718312579; x=1749848579;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8GSep0x5Wx5HJ7FQB7FQ9SeLu2xs2jhRb7XK1/SkskE=;
  b=HCqJRPlyzrgVxWATVLoXiKu85RtVbK2xbG7C1AIssINbZWrwN5Pg2t9U
   Uw3BmIRSN3lXwTzWz7Zz8IVxihjo9jJ89YPOzbXcZAtsvs90aUT3zkuS/
   S0N/jG5WwkV9ML/KgQ2qgy0ULz0i5mC9Yiy94ZVHLd1105xsO4PUvutGI
   vdrKQVrJdM0o/YQzAyKpUUhtY7BBh7eJFEFz4/hVrtAJMJU4aiw9RaN1G
   WGtT7SnhRZmzFLlUduQ+xc0yCjhWz7T7CvxhxomycxtFoduqZdJLVC2md
   ZROv4qkPYxQ53Uhh2b0jM6ofWNmoSI9aVtvuplesQvcJ856FZTws+CL5X
   g==;
X-CSE-ConnectionGUID: lYQeZBnqQVqyySk4LTkYdA==
X-CSE-MsgGUID: WN8NpSDCSkuzoV0EbWOjcA==
X-IronPort-AV: E=McAfee;i="6700,10204,11102"; a="15048253"
X-IronPort-AV: E=Sophos;i="6.08,236,1712646000"; 
   d="scan'208";a="15048253"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2024 14:02:59 -0700
X-CSE-ConnectionGUID: b1+LmAcbSwKzvjY+3vJeeQ==
X-CSE-MsgGUID: r5NMnbRwRsi/l17YMC0GfQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,236,1712646000"; 
   d="scan'208";a="44656160"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Jun 2024 14:02:58 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 13 Jun 2024 14:02:57 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 13 Jun 2024 14:02:57 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 13 Jun 2024 14:02:57 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 13 Jun 2024 14:02:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P2m4O1jHxkngxPWijaennoopdV9mkP0W6g+OKE9hSwWQDpc0BjPB4wPeEwueAqiemP53H3dYUO4DGEDsL5RAWK8v8Sk7XWHenbpR6gn9Yp9dFy5ildCm5hZ7BYMcsOlm7HYhzCDhl/JTtq2O66c71zpeJIYM7w6CNlHuwBukJfaXf2w+1Pra3WOgNmL9hbTYoT2x02DWWvdubDvPwlYco4Dlr76d4eR7Z5B/c4DmBSvvEKsqBi84JIp/N90TiLFuPLue+Q3o+Y7dR8CV6Che6b20pMR4fITWy2SRbBn2pUr6tSHwaxevEGOL9ecWkV62UCNcP6rLcJy3cczhNLnODg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8GSep0x5Wx5HJ7FQB7FQ9SeLu2xs2jhRb7XK1/SkskE=;
 b=lWGM9h5KkCCADG6azx968RsGLmm8hwDjNpEZc+LP23WNK3RZvAk5YsL12Qt5jGq7FMzyP62KikAsycIIGFhe//BFfYL/uYFOKs1IWWc+CVTzlun0e8yoP9O1D5DX3SpSfwL+VGORi2/k3O4gmFkLo0a4EqBy1xxicxEddcIaCWOnAjlaekCNdY78jekEXntLKFdOYRd35vY3PA4I1BMyIKUdJ4yA76MAeZtMElWzhrpoKE1ElBJwfAMnCnNsJfPCSQNZSHV07IC46n50TN38qhF3r3NZkpe9+209cUejOLTIFlo5awSGFLQpStcl5/geivW4P6zkKCQtj6raHqfhGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by PH0PR11MB7709.namprd11.prod.outlook.com (2603:10b6:510:296::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.37; Thu, 13 Jun
 2024 21:02:54 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%5]) with mapi id 15.20.7677.019; Thu, 13 Jun 2024
 21:02:54 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: "Chatre, Reinette" <reinette.chatre@intel.com>, "babu.moger@amd.com"
	<babu.moger@amd.com>, "Yu, Fenghua" <fenghua.yu@intel.com>, "Wieczor-Retman,
 Maciej" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Drew Fustini
	<dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>
CC: "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
Subject: RE: [PATCH v20 00/18] Add support for Sub-NUMA cluster (SNC) systems
Thread-Topic: [PATCH v20 00/18] Add support for Sub-NUMA cluster (SNC) systems
Thread-Index: AQHau2UFsa3KPaHBLkapRoBR10crYrHGFdMAgAAU6gCAAAQ1oA==
Date: Thu, 13 Jun 2024 21:02:54 +0000
Message-ID: <SJ1PR11MB60833EDA722D482EDF52C7EEFCC12@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20240610183528.349198-1-tony.luck@intel.com>
 <658d9869-ef22-48a7-876a-5bbba4f134ff@amd.com>
 <bc52a051-4296-48ac-9a83-29139855553f@intel.com>
In-Reply-To: <bc52a051-4296-48ac-9a83-29139855553f@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|PH0PR11MB7709:EE_
x-ms-office365-filtering-correlation-id: 4bf74ed3-2256-4dde-5a5c-08dc8bec31fe
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230035|376009|1800799019|366011|921015|38070700013;
x-microsoft-antispam-message-info: =?utf-8?B?d2N1NGZreGQxS3Q1eWwyYVRiT1ZJZGVoakxWYnlVKzhOc0RVU0xRdllFR21K?=
 =?utf-8?B?UWJPTDVzTVJhUnlCblZ5dDZndXZRV2ZaajI1UUZYcmZyeGh6WXBnT0d5Vmxi?=
 =?utf-8?B?L3dTVkhTMWVOdDIzQURDSG1sVSswdldGNzdGVFFzZ1hsaWZOQmhraFhrb2Js?=
 =?utf-8?B?cHVUS25nY09zOHpmT3pBMklMQVBZQzd1Y3dYaHFHdEg4V3BHUjZuWFUyakpH?=
 =?utf-8?B?ZkJkTjNsdmgzeElCa0piOE5GSE9zTzFiUGlZc1l6UUhiamNXZ3JsbFBMeVVj?=
 =?utf-8?B?SWhzaTZidlI0ZGl4Vml3akl5azFvQUZ3Q09OcnJBejV5cjd6N0M2VUtOYzNK?=
 =?utf-8?B?YS9WelZ5cTNId0FlWG5jWFJ0U1MremsxMTVWLytzTE41Z01zODZWczNocmhL?=
 =?utf-8?B?L1pTRWhLSGlIOVpEdEFUcWdjZWMvVkZrbXc1d3FybWsvYmVXWkR4VS9jdmZ6?=
 =?utf-8?B?MjhPa2FHc1dkSHpqRmRRTmhXMnBlQk0rNC8yZnNwZjJEU21DWktFeTJ1SlNH?=
 =?utf-8?B?UGUwRUxPUVhhait3b2VsUkFaODJreDNZRFREYm9SRWNlR2E5Q3g3WExXUCtX?=
 =?utf-8?B?Ym5LN0p5ckJBSG8weFhDU2RINm5EM0dRQ2Z1QWRRNWRWcW1vejltYnpYYStw?=
 =?utf-8?B?NUdhNUtVQkFnQ2tyVFNHQk1ZVHljdGRsVW0zNDl0ZHI2MkFFMVI4N2VhejhS?=
 =?utf-8?B?K0RIV2plRkNtbm1SaXE5cDZ4K1pTbTdWa1lJY2NFRnNhU0pld2ZZRFhQakg5?=
 =?utf-8?B?SURzZnBxeVc4YUM0dDhqdnU5OHB4Snc2QnVkUGFsVGF0RmdkOEd2OXRiUDZG?=
 =?utf-8?B?UUhEcmhqWlFOTFJrZFdtV1J6V041SnRXcVlPSWxHKzgzaUVOUzR2YTlGUkNO?=
 =?utf-8?B?cHZZbHVVbVZLSC96S3RVZVZTdXpoS21FajZlNFMvMjZmNnN0MmxJT0ozdnJF?=
 =?utf-8?B?S1dxVUhSMWl0RkpYT3JTQ3dWRnA1YlJVOVJWbm9xQ0twdHJUT1dRZVVOQzJa?=
 =?utf-8?B?UytLY2g4ZTlLMUpqNEg2Y2I3NUtwY1lQOE05VFk3ZkppQXpFWlFPUHpHbnl6?=
 =?utf-8?B?L3FKL2krRm9IaGZnaWdidnpXS2pUb3BGd3RCZXU5YjdLeUZwSFhta2xRZ3NZ?=
 =?utf-8?B?U1RJTVVER1FDcWFwOUZjaDJmUU1lNXhVRnI3SG00S1ZTcnJFMXlWNUorTExo?=
 =?utf-8?B?UFpGeTlMNzcrcE8wVWF1TnpzNWVsTHhFcjdOL1ZzSU9tWFVSL3pSM1JpMTYw?=
 =?utf-8?B?Y3RDbkhOelZxU0hPQllxODFTU0s2cy80RUsvZ2F3a1gweEZabk5JMWRDSXJw?=
 =?utf-8?B?dGFFMHVKMUhnTG9vQWlIem10eWMwLzdRUVoyQUlRTEtyMk9PQjU5SGFRS05v?=
 =?utf-8?B?YkZQM0QrMUR1ZVhVV1ZMYnlCWm12VVR2YU1XM2dUK0Z0UlhCL1FTSjVZRExj?=
 =?utf-8?B?KzEzY2llZ0ZwZGtzRG90NmdsQlZSK096bFp5ZHh0VkR4VW9CUWJqdWtmS3FM?=
 =?utf-8?B?Myt3ZlZaM1JjQWtkd3E0VVo2RU1rNEQ3dDNMNCsyNytYRTAvNlZKZkxVamtK?=
 =?utf-8?B?WVNIbnNrZFFiMG1HL2ZTVFZLSDhJUDJUM3BEeTRoekc3WTZKakN3RnQwd0JP?=
 =?utf-8?B?T3dWc2RwZ0dJbmpzeXpGQjVFNndkVW5Ec3VaNE9DaGswOGpjamg2dXh3Qi9q?=
 =?utf-8?B?MUJKRDJMNlNta0V0Qlo0NFltV1orWUQxeW5NZmx4LzQ1d0VxWnRBQ1FHcTJw?=
 =?utf-8?B?QVV6NWNJM251Mi91R1JlckNVRTkwRjFBMXRLUE42R1pwYTh5OFE5OHgvWW9j?=
 =?utf-8?B?bjd3OGx2Q2dWUHBvOUp5N280dGZ0T213QWlnQkgwa1JkbnVaMzdTRkdKVm1I?=
 =?utf-8?Q?HQiCDK9eASUdO?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230035)(376009)(1800799019)(366011)(921015)(38070700013);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VW1CV2ZiZS9EcUErT3hWOE1tYjFFaS8xOWtkdWpsVy9HQmdpK0MzaXFQL1NU?=
 =?utf-8?B?R2JsK1RPdzI5ZmJvZmtCTjVxS3VRdnB6VEdHZHFjV1dsV09PeVNaK2x4S2ZL?=
 =?utf-8?B?eHVablhnTUV3b0tiZGU0YnB6TnRXdDhjbXhIY3ZPb3M5aXQzeGVYY2R1MVBC?=
 =?utf-8?B?UCt2emNDcm9RUkdZUTJBYW9wNGE1RFZmaFJ5dUh0blF6RFdSMzVyalYyQ1ZM?=
 =?utf-8?B?bThOalhvL0dGeS9kOTBzcGh6cVcyQjJoTk5zYWN5ZmJOYkoxSHhFMlovWHNv?=
 =?utf-8?B?Q0c1dSs3K0NvU2tSenZ5c2dabUlEWkYxWm9PWS9ocGI3dGVYUFR4by8veWM0?=
 =?utf-8?B?OFRMak5iNzkyV29YWWZmWFpIMHVLOHBQbGhqeFNqZnY4MER1UTJUM0dWUXR3?=
 =?utf-8?B?S2V5R0lzR01KY2VTODlPdXp0N1FTZTFCRW5DT1VNZldOMFczNm9jNnJ6UUlY?=
 =?utf-8?B?MVlGZHVaRDBKRm5DbmxZdmNrVFBwdFBRcjNHQzU4bnBiRzRTdFd2Q1RLbmcx?=
 =?utf-8?B?aXhSRkVydVo1Y1RzOWNDdU5Yd2FjRVpzZDlDUFNSNzFWR25mNjdqcDI2aVRk?=
 =?utf-8?B?QnVOZ0lkT09qRmhKS0JOVnpKTUh0SlM1ZHVleFV5dzlXVEo5Ym11b3ZaMnB1?=
 =?utf-8?B?aWRCVmwwWGt4T0s4Wk5wQ3dvV3FzU0FrZkcwWnRCSVhITTM4anZtdDhhTUZz?=
 =?utf-8?B?QTlpaWUrN2haK0QvV0ZTM1YwT3hMQWsxUXljRm9sRWNEOGRiajNhR0FoZUpL?=
 =?utf-8?B?djNZYWxUOEFxRER5U1plQ05qRDAvNWpvU2xTTE56bkN2ejFPNHVrTWRQTzgw?=
 =?utf-8?B?N21FYVVHMlVDcHRydDkwNjQ4VFBnNjVLQ1YrSGtQSXdjekRMNmdmTW1RNnQ2?=
 =?utf-8?B?di9OdlNybmRDR0pZc2EyNk1CWnJxdExBVHNZaGNabWNmcjZhMVhzKzZPYzJ0?=
 =?utf-8?B?VWp2STdqK2p6L3h3WDlLNldiMmZ1QTA3VkxiL2hTUzdhdUljNkhMYnhLbU5h?=
 =?utf-8?B?ZWtabDlqM0MvREIxWjk1Smo5MGdudzF2QjNJTzVxemVsRmd4L0hDZXlseDMz?=
 =?utf-8?B?SE5QaFhMNFFMblRXSjROdUlaUC9qSVp0eUMvbFZQZlF2c0lRZ2ovd1V4dGli?=
 =?utf-8?B?QWdIR2RLak0vdzRacDNnNUZmOER6SGRxUlpwTFBubnBndDVzUnJKKzhoVDg0?=
 =?utf-8?B?d3BEYXRUNjNvdGxXTUZWN2Urb3B1WEpxZjdyWklYdjVFeCtMa2twZzZ1UnEr?=
 =?utf-8?B?WGFpeGNOZUxnUGVtbGV3RGdxMzV4OG9rbWdrTmNXMnJ1N2tjVUJDRVlTZE9C?=
 =?utf-8?B?SjZ2blZwTFBlNTQ5c0RCQWxmRHZDeC9XbFhPcE1uSUNhTjVkN2FYS283ZjVT?=
 =?utf-8?B?emxWNUpzQUZEaVl4Yk5TcnFkTno1WEJjbnRvbVNSMXpENlA4dkFHSzNrVzhC?=
 =?utf-8?B?THFGQUE0U1QrTU9ZcFpzRGJkSlovMm1kQ245OFhGUXpUNFhvNFJqb3o3c1F1?=
 =?utf-8?B?RGJJMTlocE1OeFB1Umd0Mll2ZjhHbU1ocFhkTjVtbDVUK0JqbkVJcTlZcXpU?=
 =?utf-8?B?dXd6ckFIV3ZPdUFXbHlMTnR0TXRKdGwyWG94aU4rNU5MenY1Z2svZDhWN01U?=
 =?utf-8?B?Y2dvdUxOTmVxMVV0NTJNdXBMOXBEUVN1TStkQWpVbG9CV0cyR3RqcnBBY2tt?=
 =?utf-8?B?aFNwRHoveEkwbkRaTDA0RkJvcVgwTFZJZlhWNStNVFpldExQRFdTbCtwVTJw?=
 =?utf-8?B?R2RRRzJQVW1ScFJhZ1c5bGJVZThyOUZYejVOUGE2aS9jYzZIa1VGR2RlTjZF?=
 =?utf-8?B?RjVaeHBEWDY3Nm5IejZNZURReEcxUXpCL1g0elB3em9JcWpaQ2NSSG11UW1O?=
 =?utf-8?B?QVV5OVlnRDdnZHFjdEJCd0RJVThYS1hMTmVCakgyUzl3UUNuUytkaWc3VHdh?=
 =?utf-8?B?TTFNWE1yUkhiSU1aRmJtMSthUDFQRFA4ZDhJRkZXVXVRT0ZDcElSc0lmZlRq?=
 =?utf-8?B?emhMa1RHbHo1VmNCL3FDNEk5OUxuNWZTeloxb1ErZlc3RDMyRVFwM0NVaGc2?=
 =?utf-8?B?ZENzNXBjcGhNMnZVbVN0czZlQlJob1hJNDZLK1ZmcWIyV1B0N1owNEVVRGpU?=
 =?utf-8?Q?S04Psq8yR90MmS/LiOMB1+EhO?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bf74ed3-2256-4dde-5a5c-08dc8bec31fe
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2024 21:02:54.6473
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oDlJ6b7QL0GiWjgS7bjeY9CuHCzNKSml1HA0vFx8tKvAUg1CP1UDRadrW1OFKVqZnbaxsqZUuHQ3dRxEOwxxVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7709
X-OriginatorOrg: intel.com

PiBMb29raW5nIGF0IHRoZSBzZXJpZXMgYWdhaW4sIEkgc2VlIHRoaXMgYXBwcm9hY2ggYWRkcyBs
b3RzIG9mIGNvZGUuDQo+IExvb2sgYXQgdGhpcyBzdHJ1Y3R1cmUuDQo+IA0KPiANCj4gQEAgLTE4
NywxMCArMTk2LDEyIEBAIHN0cnVjdCByZHRfcmVzb3VyY2Ugew0KPiAgIAlib29sCQkJYWxsb2Nf
Y2FwYWJsZTsNCj4gICAJYm9vbAkJCW1vbl9jYXBhYmxlOw0KPiAgIAlpbnQJCQludW1fcm1pZDsN
Cj4gLQllbnVtIHJlc2N0cmxfc2NvcGUJc2NvcGU7DQo+ICsJZW51bSByZXNjdHJsX3Njb3BlCWN0
cmxfc2NvcGU7DQo+ICsJZW51bSByZXNjdHJsX3Njb3BlCW1vbl9zY29wZTsNCj4gICAJc3RydWN0
IHJlc2N0cmxfY2FjaGUJY2FjaGU7DQo+ICAgCXN0cnVjdCByZXNjdHJsX21lbWJ3CW1lbWJ3Ow0K
PiAtCXN0cnVjdCBsaXN0X2hlYWQJZG9tYWluczsNCj4gKwlzdHJ1Y3QgbGlzdF9oZWFkCWN0cmxf
ZG9tYWluczsNCj4gKwlzdHJ1Y3QgbGlzdF9oZWFkCW1vbl9kb21haW5zOw0KPiAgIAljaGFyCQkJ
Km5hbWU7DQo+ICAgCWludAkJCWRhdGFfd2lkdGg7DQo+ICAgCXUzMgkJCWRlZmF1bHRfY3RybDsN
Cj4gDQo+IFRoZXJlIGFyZSB0d28gc2NvcGUgZmllbGRzLg0KPiBUaGVyZSBhcmUgdHdvIGRvbWFp
bnMgZmllbGRzLg0KDQpJIG1pZ2h0IGF0IHNvbWUgZnV0dXJlIHRpbWUgc3BsaXQgc3RydWN0IHJk
dF9yZXNvdXJjZSBpbnRvIHN0cnVjdA0KcmR0X2N0cmxfcmVzb3VyY2UgYW5kIHN0cnVjdCByZHRf
bW9uX3Jlc291cmNlLiAgVGhhdCB3b3VsZCBnZXQgcmlkIG9mDQptdWx0aXBsZSBzY29wZSBhbmQg
ZG9tYWluIGZpZWxkcy4gVGhlcmUgYXJlIGFsc28gYSBidW5jaCBvZiBmaWVsZHMgdGhhdA0KYXJl
IHNwZWNpZmljIHRvIGp1c3QgY3RybCBvciBtb24gZnVuY3Rpb25zLg0KDQpUaGF0IHdvdWxkIHJl
cXVpcmUgb3RoZXIgY2h1cm4uIEUuZy4gZ2V0dGluZyByaWQgb2YgdGhlDQpyZHRfcmVzb3VyY2Vz
X2FsbFtdIGFycmF5IGFuZCB0aGUgbWFjcm9zIHRoYXQgc2NhbiBpdCB0byBwZXJmb3JtDQp2YXJp
b3VzIGFjdGlvbnMuIFJlcGxhY2Ugd2l0aCB0d28gbGlzdHMsIG9uZSBlYWNoIGZvciBhY3RpdmUg
Y3RybC9tb24NCnJlc291cmNlcy4gT25jZSBKYW1lcycgcGF0Y2hlcyB0byBzcGxpdCBpbnRvIGFy
Y2hpdGVjdHVyZSB2cy4gZ2VuZXJpYw0KcGFydHMgYXJlIGFwcGxpZWQgdGhpcyBtaWdodCBiZSB1
c2VmdWwgc28gdGhhdCBDUFUgdmVuZG9ycyBjb3VsZCBhZGQNCnJlc291cmNlcyB0aGF0IGRpZG4n
dCBoYXZlIGVxdWl2YWxlbnRzIGZvciBvdGhlciBhcmNoaXRlY3R1cmVzLg0KDQpUaGVyZSBpc24n
dCBhIHByZXNzaW5nIG5lZWQgZm9yIHRoYXQgdG9kYXkuIEJ1dCBzcGxpdHRpbmcgdGhlIHJkdF9k
b21haW4NCnN0cnVjdHVyZSBub3cgbWFrZXMgZm9yIGEgZ29vZCBiYXNlIHRvIGJ1aWxkIG9uIGxh
dGVyIChpZiBuZWVkZWQpLg0KDQotVG9ueQ0K
