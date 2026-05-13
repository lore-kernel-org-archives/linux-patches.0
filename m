Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1318B3451B3
	for <patches@lists.linux.dev>; Wed, 13 May 2026 03:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778642709; cv=fail; b=AjZqcxFu+XvPW4QcE3DkccxNKEj8Fz4IGvOkI+pq9IoolKHlaw+ac4rVyncrcJIzELrHPTc9wEHzJ5HJUdR5NPL56RZUcAsJrSGjmvGZWzSB6XRvrIUK9F6kWCmTOeYdjKD8OS+0T7+iZaZ/cG/rg8QJeeNyjVhEFMzlFushTHs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778642709; c=relaxed/simple;
	bh=DBinxCc/h+/8vt9QeTSPERoOBlT+Y3r72pQ/Ap+agq4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=TFevZbLPLH8x7dy1FYVWBfpdnKXp77l8W8q5yk4O55cVTe12rJuoKU3n/p6xiFhGao+n3CBgU+BlxxgqIB19emmXjgGPoRbSTaYCnlEhqIQNR5LbarRC8qp3K5G5fgCNJgkLdAHbrrKlts3dT25qDdBINvX3d8QvMqxcPCHZF6Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UIZbmwm1; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UIZbmwm1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778642707; x=1810178707;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DBinxCc/h+/8vt9QeTSPERoOBlT+Y3r72pQ/Ap+agq4=;
  b=UIZbmwm1gnolkQEp0BAKso4cWgaA2TVChD46KP6YrfpeSa3VXtLfKj2z
   9bpH8g5Xdce8a1j011W9o266cy841jEcVoco8nUexT8RQkZXnnVoz6H/5
   Nm7uvIdkoVS3U+40b25QzaKxWBq0L7+YpfuKKN6Z9DIZ+RRaWJT5vJaz3
   vRlEKN3VRi4jRyf7xgaXyNsHt47skM3oeMG7+Ixvz/bSN66wal8B1Mb6A
   //U9b9wSteJi1DsrU1wbmquoSVQbW4SwBRgnB4kbLSkgfkWeLZSmoC7JO
   Yk/P56JXtf60RyRCmbXfF2b9Xb6LH6zIj7w5N04qlFxQ6G+XNiYpIudnI
   Q==;
X-CSE-ConnectionGUID: +QfkV4W9S1Gz+gFl2ajmBg==
X-CSE-MsgGUID: Mr7zKL86T4aHFWUfAARldg==
X-IronPort-AV: E=McAfee;i="6800,10657,11784"; a="97129409"
X-IronPort-AV: E=Sophos;i="6.23,232,1770624000"; 
   d="scan'208";a="97129409"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2026 20:25:06 -0700
X-CSE-ConnectionGUID: XAaG/VPkSbmr7Z/XIBwC+g==
X-CSE-MsgGUID: 1wAUPHR8Rn+GGpTeG2LvdA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,232,1770624000"; 
   d="scan'208";a="261445948"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2026 20:25:06 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 12 May 2026 20:25:05 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 12 May 2026 20:25:05 -0700
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.15) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 12 May 2026 20:25:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GJ25sx7KNHUvkxjZ6v0vqbh+w+5gMpmq1eZPKPmxFjJ6pTWLRoP7oQSIgGU6VglSVxLocbcweyBbN73zN13/OL6L17MRgRAr3CBICVE+h0KmtKWNVgAWTLKclkcOPKJRj1ePxhx5skyI9iqW3Pm4MeaBtqFOGm8qbEexfmVsXTrFjumzHyUG5Sq81FGT2zlqH9A+ng/R+QOpEHr04pWkA/YaVKasdLwSt1IdWmPri+FYU1nJtF9/RMkeBgGml3Df9UhG5KFoukNFoLR3PoYNz/Zq0KCA/RTl62kKpJ+QXpRy9p0BnbsPD5MTvT4aUiESxssMfKyBU1YF3ZM7R2ESNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8mPS9I5PICTJUIezKQ8NMazcgKfIPL7KiF13jvXhpuE=;
 b=f6nrtUx+meY5ZwTejKXfXAnn8P393upebp+F7X2FtNQKzWPc4l559Y7Ibl7ZEv0y4sOJn6MjTUt4a1UWVwnIOZ4N7ReQK97UK9WcyQTLYHCGVHpCmNt/WERK89gF2p+HinVDW2qzQkQ3b4q9odLsF/hgeoPnVZL7gSST4fZbSjdw8Did9TRRjjyor2zvChBKTzYyvnBb7uP/GIBAO4mBNyMlNawp7BHHy0402wP5J5yMMXxZWlrHSyWDLX7PuTv2yEsL5gP4mSzcAfoAsHOPa9/bc03aJIiXgZe3wENlQ5m8jEaqGBVE9g6R31cfGyoGL6VtB/H1ODgRLLrXC324Hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6020.namprd11.prod.outlook.com (2603:10b6:8:61::19) by
 CYXPR11MB8730.namprd11.prod.outlook.com (2603:10b6:930:e3::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9913.11; Wed, 13 May 2026 03:24:57 +0000
Received: from DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::3058:1480:e4ac:5765]) by DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::3058:1480:e4ac:5765%6]) with mapi id 15.20.9913.009; Wed, 13 May 2026
 03:24:57 +0000
Message-ID: <8ee967df-329d-441d-9635-47f48b5e7b8f@intel.com>
Date: Wed, 13 May 2026 11:24:47 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] fs/resctrl: Fix deadlock for errors during mount
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Borislav Petkov <bp@alien8.de>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Fenghua Yu
	<fenghuay@nvidia.com>, Tony Luck <tony.luck@intel.com>, James Morse
	<james.morse@arm.com>, Drew Fustini <dfustini@baylibre.com>, Babu Moger
	<babu.moger@amd.com>, Peter Newman <peternewman@google.com>, Dave Martin
	<Dave.Martin@arm.com>
References: <20260508182143.14592-1-tony.luck@intel.com>
 <20260508182143.14592-4-tony.luck@intel.com>
 <e0f70732-3ceb-4d4d-8ffd-4f2761922e3d@intel.com>
 <69874f4d-e64c-4d74-8ba9-eec30760751f@intel.com>
 <547e32fd-1d60-4c12-8ba5-5f8cebe5ab87@intel.com>
Content-Language: en-US
From: "Chen, Yu C" <yu.c.chen@intel.com>
In-Reply-To: <547e32fd-1d60-4c12-8ba5-5f8cebe5ab87@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR01CA0032.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::18) To DM4PR11MB6020.namprd11.prod.outlook.com
 (2603:10b6:8:61::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6020:EE_|CYXPR11MB8730:EE_
X-MS-Office365-Filtering-Correlation-Id: b310057b-7af3-40a4-67f6-08deb09f3507
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014|56012099003|18002099003|22082099003|11063799003;
X-Microsoft-Antispam-Message-Info: Q32lDZvU+5UjRqu3VHZ5otSvpFB9LoQa9chrOnILzGDIePDSauM6gLSKlKhPVfe6bVNLoLpFkSBjuyqmJ80V1nRfvTrDipdYVTPuJOl24U5By1WpIvho/wl00UjBuWsKkNA+1DD/7ULVyRPn/QBVuUfSbHHgqxVylyJS2LZaLL1DrIU/THMLIuDs9tQjgcPzwRf8T0Tku3ZXOaCwRsRyCvCfVn7wNwlWHvj409UqrCMskZet+aMFOhSpuQrV3BO70OseiOdj3HUf0G1gV6RS4XRqBBZePS4eH/PpF/0GKmDY2/bRKy6/SsSUA2HFOdlippDFpkBXwCxJY1PPTO+agMzZ95ywjvleltiDeghnroENLEOOSUUF1+kUGq0RBeZW1n7ifSnmijh5Y0csRWuphiSeGVgLvyz8apYfjxejXpzV8g2Gsati1eRAiSVYrsqnQXzJen8fCP0Y2Z15kbYSIdMxmULXUikR8etoN2GHm9pviXOzS9GxG3w3/KOfq13Ro84fGVWZoiwsAyAo6WyDiXEmvlWIXiqnY0NTlJXlgS8f/RAs+qc0I0m2hwIEvFxiXBfhqjX1LSvgNIhGq0Luyl5aRQyXqC+7IUxqZYl9xZUWB0jw/5ZvbRCj/fVveu6JhZPV8FrszIrwgNrQi9WpTIwQG4a8/d0uQ+dDRvDfUhE4M2WKqSnyWwIU7TPMKqy5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6020.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014)(56012099003)(18002099003)(22082099003)(11063799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RndobGNEQkRQZEVoeU5PZUtvcnZvZm0yZXlwaWFkOENXY3I1WWlCQXlBQ2JX?=
 =?utf-8?B?VW4xbkp5bjJvZG1jRjVPYTkxQnlLVE8xNHVaaWFPSGFHQ1k3YXZtNHRqbHFF?=
 =?utf-8?B?VHE5SVJSU3JyeHJPUU9ZUXVTWTZWUWRrNTNSdlJ4LytiaGZkNElia21CRVJu?=
 =?utf-8?B?TEJlTDZwZWJMZ1hvaUo4ZFJRLzVEWEhqWXh4Y0psUFU3cHFZNUhQaVY5OTUy?=
 =?utf-8?B?YmtHb2pub1o0eGEwT2pDcHpkZHJNbmR5UVd5a2oyT2dIbUJZL2FJOTU1a2lL?=
 =?utf-8?B?NVJXcW84VkprVEFmSjJ3M1FsaDM1Y3hwV2l3Wms4NVdxVWtBb3ZSS2EvK0ZJ?=
 =?utf-8?B?bDRITXhSSVg2T3JPQU9qSmNYZ0ljZGozWW1CVUJqTWNrWDhWaVNIQ05ibHU1?=
 =?utf-8?B?MXptVS92bmxiRFhBdmppVW1PUWc2WDN1SXozMkJoVDh3aXJLN055bHlCcXVa?=
 =?utf-8?B?eHhDQUxjYjJXU29ZWEdtdDdDNjRlemdobEM3NEU3cWJaQ0JlZ3ZkOFQ4NStF?=
 =?utf-8?B?a2JLcWszRVVaaGFPUWhYOStuL1FXMXJjTCtKOXBNeEMvSUtaVU5jQ0QrODVq?=
 =?utf-8?B?WTYvWDRPTG41VmVFTmwrUTdDcllQM21RcHl6c3I4SUpNNHdhR0ZWQkRScnlr?=
 =?utf-8?B?UGtoMWk3ZDdpc0wzUkd5YU9oT3R4QS8xeUdPcXpBLzZEdXhzdDdqUk5IRi94?=
 =?utf-8?B?U01KZzdzWWdBODVaaUhQKzMvOHR1SHF6UWxJTENMbnp4dGNicmZHN2NNWTlm?=
 =?utf-8?B?Tm5UWEdNb1k2Y3JaTG9YbTU1b0F5dDV5M1paa2lhYnhXaWRmdzNWZDBrVzRu?=
 =?utf-8?B?ZG9FcXBLU0hHMEt0Sk54S05NNi9CQ2dac3QxMCtKTnRmYUpEcEp5L3BLM0hQ?=
 =?utf-8?B?ODQxamZQMkcwQ3VtZlYwL2NLdGh4Z0l6NWo3T1ZWYmpNMDNpUWRncDlsVlFa?=
 =?utf-8?B?S1F1cHJ0VlNVMGhOWjV2aGFsNU5iQ2pZQlI1dk5ubFRPZzJKNmIxcVJzL01U?=
 =?utf-8?B?dDV2OGZ0YythU1pYNTc1a1FuTHhDdzFZUm9PdU9BZ0NNOUhrWTQrK2VLMENU?=
 =?utf-8?B?bWNkRWhsdnJDa00zUGR5ODNZVkFnZXlXVmdFVFVlS2tHdEcvUW5FbE9WcHVP?=
 =?utf-8?B?b1k4UHR6MTV2OEZyc3pBREphaEhnUGt1YVBNTWVac0dyYUtXcG53Y2xuZXF6?=
 =?utf-8?B?K2psT2pFSWtmeFF2YU9Td0xCa1o0Qm1kNm1YQWMzZVlvaVRIZnAwc2dTWW5J?=
 =?utf-8?B?ckNJb1JmN3dxM2V6cTFxR2NIa0RXcWtpUmRsZVpEQkRDSlhIWUkwaVY5RVlD?=
 =?utf-8?B?M0VrUFByNDl1Wmk4WkVFWC9VQzRLV2JNcmp2TUpkcXpIQ0QwYllDYzNKMjBT?=
 =?utf-8?B?Nk9Md0FQd2FVeWJkdWgzdXFEcE1TdFppRnlVMERXbjRYeWt3VVg1bzl0czFI?=
 =?utf-8?B?aWk2bjRmcDFIZEZlUWhodVF1S3RsMmxjMU5tcFdIaTNnTG5tVWlENFk2TmZz?=
 =?utf-8?B?bkFidWNuWjY3bVhtelZWZHlMRjBCdjkyTmRYbFlVZi9DN0J6NlpRellFZEIr?=
 =?utf-8?B?UkJxU2V0TWIyTTlQd3k2bGg2dThzZDFQTy9sQzJzZEs1QjdDeCtMU05FalJq?=
 =?utf-8?B?YTBKdG82OHZoYmpVTVF5bHRpaGZidzM4aXE1S2s3ZWxmSUJrM0tGbDV3WUlR?=
 =?utf-8?B?eUZ3V0xrdTE0TVdMOWZYNnhEemwyYVUrOGRpTUZVb0s1L2dGSHZ3S2lxc0Vn?=
 =?utf-8?B?NkVHRTUxVnUyMkRpdzFsdENXczBCbnhETURBalNYVHY0Q1Y4WmFOcHVkMkxG?=
 =?utf-8?B?MXhOdmZBOUl6WUpzaHVYTmpZblZOdzYxa2FRbFdWcXhxdTA0c3dSMjZOelcy?=
 =?utf-8?B?MnhtZTJGN3BNU0hFNWEyYjhaQzlYUWVkV2hxQXdjQndNc0d6K2g5OXZJUjdu?=
 =?utf-8?B?a1E1MHJBcUNFRktiREFHNkgreExBWEVocTJ6S1loQkRRZi8vYlpyQlY0RmQ4?=
 =?utf-8?B?Q1FXOXg1R01TWHBCQzZxS2djSTE2UXNWQTBkM05vMVpEQkJuYmNhckdEOGxY?=
 =?utf-8?B?SVhmTzJvTnJYVm1sQklHREJ1YjJ1RkFQK3U5T1VRMXppNjhRSkhtWGVSUk9T?=
 =?utf-8?B?TnpHd0hQemtaRXhWVUp6R1Q3dEFSelZ3TFJMMXY4aUgzU01TaU1SNG4rTTB3?=
 =?utf-8?B?R2RnTEh6L1pjRGR3K295NGpPd2lnQVRGMTZWTHZSUWhoSjBXR1VCd083UU96?=
 =?utf-8?B?YVh0NVIzd3ZScjNZTERqOWMrMEJ4V2xBQnlSMXRhNmpFR2pac2lpck5QT3ZG?=
 =?utf-8?B?REV0T3RNMTZwMnJmMmtYcEJ6WkVkdC9JS3ByLzhCeTV5ZW1iK3pwdz09?=
X-Exchange-RoutingPolicyChecked: FnX2cJk29hEbOLIr5YWPEFBPdS52PeSptW+uLxtFiodmxWSSnZeGScN8PPYAzSIYvOgNietNo2cPQ9HemqqTSOmc5rHm9jKvbze/93l/pD9DT0FA5BjkUIgPVwEx/cim44rhMmN6h64b17/4J8uOwdz4vgYBjuSzjhtrYlMaljj4dKSjXiEbV+LbtEBFPWp+2tyriVaQcpKXcpPwCsFSoD0LzwztKdR1DfKx7UwgUNFxwLVU4WCBy7jYnh0HHTb9uNX2qSeYSeuldR69vTmQ0UELMuRLSYHsyOlpNrrFeXe0hFgDJi5C+rWgv6lQFIsVg3KqqURVaZy9YNzLbP1NoA==
X-MS-Exchange-CrossTenant-Network-Message-Id: b310057b-7af3-40a4-67f6-08deb09f3507
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6020.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2026 03:24:57.2049
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wk7SHFBV1/LT1kOc5Wv1OmxnVR+XoGehSMOgcNYGTU1D+aM0G9msgBbTohGJnHYiwMDEWdKQLyGNJVziMeUggA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR11MB8730
X-OriginatorOrg: intel.com

Hi Reinette,
On 5/12/2026 10:34 PM, Reinette Chatre wrote:
> Hi Chenyu,
> 
> On 5/12/26 12:28 AM, Chen, Yu C wrote:
>> On 5/12/2026 6:53 AM, Reinette Chatre wrote:
>>> Hi Tony,
>>>
>>> On 5/8/26 11:21 AM, Tony Luck wrote:
>>
>>> +     * Obtain reference with locks held to protect against interference
>>> +     * from resctrl_exit().
>>> +    */
>>> +    kernfs_get(rdt_root_kn);
>>
>> [ ... ]
>>
>>> @@ -3130,6 +3144,7 @@ static int rdt_get_tree(struct fs_context *fc)
>>>         */
>>>        if (!ctx->kfc.new_sb_created)
>>>            resctrl_unmount();
>>> +    kernfs_put(rdt_root_kn);
>>
>> I wonder if above should be protected against
>>      cpus_read_lock();
>>      mutex_lock(&rdtgroup_mutex);
>> like kernfs_get()?
> 
> It is not obvious to me what this protection would be needed for.
> Do you have a troublesome scenario in mind?
> 
> rdt_root_kn is a local copy of rdtgroup_default.kn. The latter is indeed
> protected by the mutex. The reason why the kernfs_get() is protected
> by the mutex is to ensure what rdt_root_kn points to, rdtgroup_default.kn, remains
> accessible after the mutex is dropped. Nothing else modifies rdt_root_kn. I
> understand the appeal of symmetry but it is not clear to me what the extra
> locking is needed for here?
> 

Thanks for the detailed explanation. I now agree there is no need to
protect kernfs_put() with a lock here only for symmetry reason. I
previously thought racing conditions would occur if two code paths
concurrently enter kernfs_put() and target the same data area.
However, since kernfs_put() contains an atomic compare, only one
code path can proceed, making the operation safe.

> Could it perhaps make this flow easier to understand if the kernfs_get() is
> of the mutex protected rdtgroup_default.kn while the kernfs_put() is
> of the local backup copy? For example:
> 
> 	/* Ensure root kn remains accessible after mutex is unlocked */
> 	kernfs_get(rdtgroup_default.kn);
> 	/*
> 	 * Make backup of rdtgroup_default.kn just in case one of the
> 	 * following flows (that sets rdtgroup_default.kn to NULL) run after
> 	 * the mutex is unlocked:
> 	 * resctrl_exit()->resctrl_fs_teardown()->rdtgroup_destroy_root()
> 	 * kernfs_get_tree()->deactivate_locked_super()->rdt_kill_sb()->resctrl_unmount()->resctrl_fs_teardown()->rdtgroup_destroy_root()
> 	 * These flows would not actually result in rdtgroup_default.kn
> 	 * being removed thanks to the additional reference.
> 	 /

Yes, this comment is very clear and helpful.

thanks,
Chenyu
