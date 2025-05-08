Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57EF627935C
	for <patches@lists.linux.dev>; Thu,  8 May 2025 15:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746719704; cv=fail; b=hXh1u8dUI4LNWaqQWk71JSKQnZtWDSk39OwOlFSxWU9B8kmxHSp09nnBkpCCYrkNoC2UDEL9chTsIck6dRBF5KiR34XHTEzyFRG0DPsKkNiayd4yV/9V9bnMXF+9YY6+zx4n7cmAOPy1k3kDj9/5ftupMR8LpWdTjs9jB6dg/W4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746719704; c=relaxed/simple;
	bh=c+NM/EvQ+PY/7MeKnCHOIPgqba5ZlaTSUb7QI8x+txo=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=uNUbmHKzpr+BLlgLzp2MCjGXFhJs9LRuRyXY7rUjBk3fhOBXY0d0DS5ZFsklssVlvqcE6g9svbnDV+ePSR2Jbkt5G3Ah5b8PXpbtnChSlCx5yuO/GpqJyiU3VmROsUKU2DeWUoFo4Lbi9b7nM5aghl6NkjaTL4D+IoYtw5endjM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e8Q3ghOf; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e8Q3ghOf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746719703; x=1778255703;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=c+NM/EvQ+PY/7MeKnCHOIPgqba5ZlaTSUb7QI8x+txo=;
  b=e8Q3ghOfYnsK8SM3Rxa9tRGdaeu8JecH0Bk9EDFByBsMXcmh2aAa407g
   Gw8McxTuhMAFweW93o17iRSuJGJ5RpiyQ6wR4ydcdVHbfHk8b6GS4zYtD
   D9IeJzic9/QQYfroUw0u/tcTkiDSix2ENz4Pf4BF2dkPLO5rKLx6YpWge
   q/3ixjqBuv7lZUFQWKwB0Fu1X8SqXcRxHVU/qmL73u7N7iZ5dfPaR+ez7
   BfKE/IIoBbq0ER45kLrvLxG2Q6116k9QbFLAJtwRJo9IpJAJwt0Z5inCO
   RLjCGqL/wI2F+O30ojIOUevlTwmo7Tto1ggWDhJAJjVVh32H4utVXSglT
   g==;
X-CSE-ConnectionGUID: GqnG46xORTKQp3yFPPfIgA==
X-CSE-MsgGUID: Wn9UyLvBQvykpr74xUqczA==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="48223431"
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="48223431"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 08:55:03 -0700
X-CSE-ConnectionGUID: UKqRfISmT+yHVyD2GTr6yg==
X-CSE-MsgGUID: ae5e9lQ3T7CyC3z98/xdjg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="159636672"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 08:55:03 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 8 May 2025 08:55:01 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 8 May 2025 08:55:01 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.42) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 8 May 2025 08:55:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Fh2/ITIJpSi3cSnazU9z8w90nZVyILHg/25vFxqQOhghnl2sm2jfIHr3GhDQSS6IOVQAyUOUC5vKtBIFC5pmmgpTwGU0Eez3X+iysmx023gVQiPNFu54QyAiRHMpZGpnFnIiSGUAKK9iu2Wdo0xvQ9Hy/HDdEM41477QIe/payY9KJO2wbBBOi72ouGCDacJuZO2/T200tunCDx5KtrxNa9sxEmFNU5xS1/vwhdkd/otrbJ7i8A1SOrx7X9y3p6Q9OjX39c97JhrS/KpboXCVKLVzWzeBuPKqQU0aAvPRd+3b9CgGdMM6cQpeD+5a1GybOZ1S4PncYshSY3KSqDD2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mHje0owjEQ7ozJpWoPpiKE6TCWfdlQnjZMZ5HjJTTmI=;
 b=IezdPwdSRkOgz92hMvjYcpySUs9RDUiUrJlG3uB65t4Z0apOlkPlrCgvIcY6dZvvo5HlJqPrsV0c/1zTQ5qb9dCkd5UTrfxQIKfl7bXHksAdiSGOy7uuLD4qcjFedcMYYZlLiv8VT67ZgOBeI3v9K2p2SXuHkyiihF/pjyvtyFexaNLxsCosayNsK+leLUtBjNwfXyoA4w1qbg9HLftIxHUwJ0iGZ9BHGC6xSGdtBiCBpYyxrCdsPqhfoL8H0kXf4BHcl6P36SZpPJXs2NV8mw0P/xS7TN6nNzTiETq8A7Vqjo6P7ZoxanYjHoq1roRJy7hBsCyC6MNivMKhEMLksg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DM4PR11MB8158.namprd11.prod.outlook.com (2603:10b6:8:18b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.21; Thu, 8 May
 2025 15:54:08 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.8722.021; Thu, 8 May 2025
 15:54:08 +0000
Message-ID: <74c45403-ae57-440e-8a49-d058bae9c21a@intel.com>
Date: Thu, 8 May 2025 08:54:07 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 17/31] x86/resctrl: Add second part of telemetry event
 enumeration
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250429003359.375508-1-tony.luck@intel.com>
 <20250429003359.375508-18-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20250429003359.375508-18-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0240.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::35) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DM4PR11MB8158:EE_
X-MS-Office365-Filtering-Correlation-Id: 85738436-6792-4978-ee1b-08dd8e489174
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?aWRNeFBkK0xBVWUwV0FSYXJKZjNzczFTNm5EWGVXbnk0RUtLdlZOWUl3YWpP?=
 =?utf-8?B?K0xybnJTVDMzakVUS3ZFSnArTEpsQnFKMHhqcTVuZytNQ2J6MFBqTmhtY21C?=
 =?utf-8?B?YnpkZzAreW04amphRTFXUHFLeEsyM1JPSjJ5dU5LOUU4cXBPS09UWU1aUmlT?=
 =?utf-8?B?Q3BNdnpFMXVQeTFNQUp0VG5BSUxJTkFybExRU0hvcEtXZkJpMFIyUXZpME1u?=
 =?utf-8?B?Um9iZWFmekFDSUEzOFErbEF3MDd3RTBoaW1ORk8zcGpKRUJvZUJnbmdBbmxR?=
 =?utf-8?B?RzJYNXlPM04xdndaSWlBSDFvMUxaMTVJclF6TzJRanNMODBydmhEWnJodUU1?=
 =?utf-8?B?ZzFLYTh2VXYzSkkwTmI4NFcra05rRExmVDR1alBBKzZtVnU0NklQOWJjS0xr?=
 =?utf-8?B?ZjloblBHUlJodUFYUGIwa2JwbHZNOXgxYmQvUklxbm5lNTJQVHlwUEVlN1Nk?=
 =?utf-8?B?OXFteXZUbkdYc1BaY0MzUkVEb1dGRFp6ZlpqRmRlV1VZVEhqR2g4ZFpNdmhz?=
 =?utf-8?B?ZHJ6NG4wNk5KZDVhZVBmaGpLTWlURGlmc1FlU2c1RkZPT3ZsSFRIYUF0NVBB?=
 =?utf-8?B?dzlXNVZEUHRqbEFrSTAxNnhtZUJPcXVYU2J3SURHVVhQcS96VDZGUHhOOWxz?=
 =?utf-8?B?aFpWQ1hzSXR4NnNVb2pETzVlK3pRUUdGZENHVnNPZ0dXNmdkMnI0RWhabnZw?=
 =?utf-8?B?MmhJNGFDbUphNGtqdEdJT1A3N1pzWHNIYkZSWlFFUEE1WWpld3NKL216eWJJ?=
 =?utf-8?B?Y2pNenhRbVFaSzU3ekh0WklHc0tJdEw4c01zUXI0cjI5SCtHemwweFZmZitm?=
 =?utf-8?B?VmNmd2RsSDA2L2ZDTUgyaVZDNThEZ1doWm9WSjdXZlcrNk10Z1FwMWJZTnFZ?=
 =?utf-8?B?SjM2NmZKT1o1WlRqWUM0SEJjMlBUMFpBVklLeVFaWEVFbmlRQUtwYms2dnV4?=
 =?utf-8?B?SVRlVExYd2dJT1RiY3ppbUsrMllmWG1tUkxwRVdhUFY0UVA1ZDNCK2txblVY?=
 =?utf-8?B?amRDUDNrcXQxUW9rUW1uRTVwdG1DM2NtSUZITVY1UStUZG5wOGpjSjNQb3VO?=
 =?utf-8?B?R3dVR0JYck9QQVZ3OXg3Zm13ZlpFTjhhOC9EL2Y5ZFMwaU1vZDdkVURNVFZN?=
 =?utf-8?B?TXM3SmQwUHF1NjVLbTZJdnRLR0VqajAzVTM5UWZ0bHlISHk3YXk2ekEzaE5s?=
 =?utf-8?B?U2gzYmRmNnEyRmZXa2F4dDdILzcwekFRRDJHLzFNZFZFVndQMDM3R2N0SHRT?=
 =?utf-8?B?cnpURUEyb1FQSk8rdmQ2Lzczc2c2aE5XTnVCY2MwVWdqUVA0VGVraFhBdDI1?=
 =?utf-8?B?em90Y0sxN09NQ0Uxck9wU1JVVmxhcUlZZ3Yxd1dVR0J5TmcwRGJIRTAzdWd5?=
 =?utf-8?B?Y0ZoVllTVUJzcWlLMEFCekh6WE1BS3BURWEzTEloK1Q4Y1lNcnVjZC9IVlMr?=
 =?utf-8?B?bzluVys4ZUxobkV3SzB3VERYL3FTbC9XVlAvWHdVM08yc05Ra1BRUk54MHVT?=
 =?utf-8?B?SEIrb3hsS0ZBZkFoMlhYcC9kcFBydU80dUNUY2lGa0VTVE4ydVR4VUt5Qjk0?=
 =?utf-8?B?eHc2Q3VjYk1CeGpvd1dJUTJVcXZpT1NrM2kwVldyNXhoSGhhNG1wMEtOeVk3?=
 =?utf-8?B?RjIxaUtHeEEyRE4vbWpKUkJkQnVJb2YvSUtCV2IvM0Rudk5GT29JNnRZWFR3?=
 =?utf-8?B?SERXVERJOERDRHNmc3g4YTBqc2cvOVlyVlZLSmh1TlczYWxwcUJRRVBpbjl4?=
 =?utf-8?B?QlVvNzdCb01UZjdFa0l1Nm11R2RqenlkZGwrRWFaK0M0K0J5cUxJVmFKODJo?=
 =?utf-8?B?dEVmTW95UTZlakI0aThRYVhvRzFMVVlnS1gyb2c0ZUVxUVcrZFBodXFycW1z?=
 =?utf-8?B?cERzamVwblZCMk4xaXQxMzIvakxxN2FlVUZadHdYT1ZJSnBVb1NnOENQV2NB?=
 =?utf-8?B?RFZIcG9mTmdNaC9hNlFnYnFPaTZzVXdtK1E5TFRtamJWeGJFMnhlQjVWekxF?=
 =?utf-8?B?ZGJJRkY5cVdBPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cmhmbDUwcGwxWlhMdFI0dkVsMFRpU05TQ0huR0srNU9od2dTV1M5S0N6MlBF?=
 =?utf-8?B?bk16MmFZbUMwWDMzZFg1VHhrc1E1U2ZSM2p6aFBCMlhPTUtXUWJ4M2kvd3JW?=
 =?utf-8?B?bVdoY1FGTi9iSDhPQnBPR3ExTkRGSCttbWJiME5zd083c3dCU0wzb0Uvc1lP?=
 =?utf-8?B?NE02ZUhRd29mckhWOTFzcGY0Q0tKWXFGdFgwR2tMU0xsSUN6MTBOc3JPemdq?=
 =?utf-8?B?ZVlHQnJYODNYalFMYUNzcXFlS1RTYTVSakxMbCsxdTN6VHJ6Zk9HaEc0aWU4?=
 =?utf-8?B?SHovaEhueDEzZzQyWm93QU1ta2hNRGxLRElDU1Irb1hoc3NMajNJdG03T2ZN?=
 =?utf-8?B?UDEraWtzZFdyRnFwMUtsOUJxT0EwV0tFWDdQaUl0YU9SVTY0czlCdlVRMDZv?=
 =?utf-8?B?TUpaY2JUTWZFb1VTMVEzYTZwK1dRQWlUeGpSRmFiN2M5cFNqM01GYWpHYXZI?=
 =?utf-8?B?bWt0V09FNWlWamRlamY2NVR1eWU5ZC9NQnpkY3JIZTBKS2tOSVczTXhMdG03?=
 =?utf-8?B?UThiSjI2V0dJaG5ZRDErQmpIeGF5b0pTQVBlUFhlZ2JtcEY2bXdXWTFqNTFx?=
 =?utf-8?B?SDI1WjJqaEQzK2JwQ3lhY0RySUFaQThIOHl0ano0Y3lkM2dKc2Zpc1lXRHR5?=
 =?utf-8?B?TWYzYVZyTjRhSUxGT2gwTlllWlRBWEFOOG4wbEtlQXJhN3RIdnYwclRYZVZs?=
 =?utf-8?B?VHVDSEgxZHp2UGducVg1Z0M1ZmtQWm4xL1ozalc5a0dKbEU4OGhWM0RDRy9I?=
 =?utf-8?B?OTNIbGRCQWVIcHUxRkI1S0xUU1dzN292d0VKeFpTL3J6eGRoVVM2VC8wT1Ba?=
 =?utf-8?B?MlpKWjRSMDJIR1hzOFNCVCtMQVk5RnJFc01EMGZsY1E4b25RSlordWdFeHZw?=
 =?utf-8?B?UHBkWlZHR0QvaXM4SmUwSVNnQWpFeG00aGh0eSs0RWdpTVh5S3ExNC9MdWg5?=
 =?utf-8?B?VlRnZlpqU0RLMmJVNXZGS24vMi9vRWdycGpVellsdFZlb09qS3lpeWNJRkFF?=
 =?utf-8?B?Y1N4Ujl1UXMvVklUcG40SmRRZ0syZjZVQVdsN3duTkw2Q2kydFBYay9RWVJj?=
 =?utf-8?B?bTc0YkM1MXp3VFk1NSs3THV3Vk5aZG56aTlOdEhXK2Y0NkloVnlieU9EM2Mx?=
 =?utf-8?B?ci8xaTRNelRrc1JrZmxjYTlqODhZNWd0NGVsMDcrVUdWd3B2N2xvVEZJZHNs?=
 =?utf-8?B?Sis2ME1GQnRONWk2Rm1IWXJxQ0hlUEh3RmZVZ3JOV2JOL0lRazdZaVRUTWRR?=
 =?utf-8?B?dEdhYUgxbUd4TmliZE1xb3FmZnJwQTBTUmF5NzFxY055TEZ4WDlJZWs4NmF6?=
 =?utf-8?B?bmpUYkFETHo0LzhjYXNodit6WnV4UVVvT2k2djR1K2RaWDMvdnFaZW8zVTF1?=
 =?utf-8?B?S3hOaHRBT2JPQW40UENDS3dxb0NxY0RUTXA2M3luUklKQVg5WStLZ21OQ2la?=
 =?utf-8?B?VkVnNHpqbklqTnFHbjNreVBhaCtyTFJ1bTErTzRnbGJxWC8rMXU3TEFUUHI1?=
 =?utf-8?B?MzNET1FtZ0VFVHZHY015WllLaXM5by9CMnI1Z05JRHBLaUJYc0ZDREh5RGVQ?=
 =?utf-8?B?d0h2S2F6cjVWTG9uWjlxWlFDSnh4SDA2NUdNbW1iYVNlWVFVV3hWeURtTlN1?=
 =?utf-8?B?bDRIV1JhLzVqNWVCUEZwRHB0UmlLT1JYT25ua1l0VitnR3JhMkF5VDYwRDRJ?=
 =?utf-8?B?Mm4wRFE5RDUyQTBaR0JIU3BYOSs0Q2E3MmVlTktvakdkOU01RHZjK3dYNXh6?=
 =?utf-8?B?K3RJYndEeW1nR3VSNVJmQ3c0dk4reXpyRlMyZ0lqMThveFJtbEZJSE1aVTda?=
 =?utf-8?B?aHZtK28zd0QrM0hKWEFNVENVUHdJRTdXVk5zOVltL0hwUXV3ZThJZEdDMGlk?=
 =?utf-8?B?R1BjK2dNWktDVmZxQ2hjZ3ZwNlRjWUpXb3hnZHB3ck5TdGtuTjV2a3hIOFVY?=
 =?utf-8?B?ekg1RmdST3NPMFVTZTNUNjZLbmh1K2djL3JlYzQ5aWd0c1F6VHdqa0JkZGl2?=
 =?utf-8?B?TitvZ29JNXpmRlg5c29IZGIzdTFDd1E0L25iOEpxenRXOEcvQlV5UWYrK3Ry?=
 =?utf-8?B?czZ2Q3BJTUNldXI4MloxQms0eEE5aFgya1M5SGpWdlJNM2tFWG9ZbTBEZmFt?=
 =?utf-8?B?R1kvdi9rL2huS3djcUEya1ppc0ZFcjN3b0NBSFlldUJ3b1owQml5T3RtWmxl?=
 =?utf-8?B?R0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 85738436-6792-4978-ee1b-08dd8e489174
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2025 15:54:08.7009
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /tNTQCSrmhzuxPoMB1BVAYD5E0ewGAGuemDGo9dPbBJo4evNSQ+lzVHNBzIYv6klrSegIUOFSpsgsBqSDvqqBKWir2Jy3uMBDp6gHafCqZs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB8158
X-OriginatorOrg: intel.com

Hi Tony,

On 4/28/25 5:33 PM, Tony Luck wrote:
> There may be multiple telemetry aggregators per package, each enumerated
> by a telemetry region structure in the feature group.
> 
> Scan the array of telemetry region structures and count how many are
> in each package in preparation to allocate structures to save the MMIO
> addresses for each in a convenient format for use when reading event
> counters.

Note that reader does not know at this point that the subsequent processing
will be done by further expanding configure_events() or via a new function
called by get_pmt_feature() after configure_events() completes. Without knowing this
this patch looks buggy since it seems to forget to save a pointer to
initialized data.

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/kernel/cpu/resctrl/intel_aet.c | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> index dda44baf75ae..a0365c3ce982 100644
> --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> @@ -52,6 +52,27 @@ static struct event_group *known_event_groups[] = {
>  
>  static bool configure_events(struct event_group *e, struct pmt_feature_group *p)
>  {
> +	int *pkgcounts __free(kfree) = NULL;
> +	struct telemetry_region *tr;
> +	int num_pkgs;
> +
> +	num_pkgs = topology_max_packages();
> +	pkgcounts = kcalloc(num_pkgs, sizeof(*pkgcounts), GFP_KERNEL);
> +	if (!pkgcounts)
> +		return false;

-ENOMEM

> +
> +	/* Get per-package counts of telemetry_region for this guid */

How should "telemetry_region" be interpreted? If this is intended to refer
to the individual structs then it should be "counts of telemetry_region structs",
if it is intended to refer to what the structs represent, it can be "telemetry
regions"

Also, it is not obvious what is mean with "this guid" ... there are two guids in
snippet below.

> +	for (int i = 0; i < p->count; i++) {
> +		tr = &p->regions[i];
> +		if (tr->guid != e->guid)
> +			continue;
> +		if (tr->plat_info.package_id >= num_pkgs) {
> +			pr_warn_once("Bad package %d\n", tr->plat_info.package_id);
> +			continue;
> +		}
> +		pkgcounts[tr->plat_info.package_id]++;
> +	}
> +
>  	return false;

configure_events() returns false on success and failure? Perhaps this is temporary
until all parsing has been implemented but that is another thing that reader needs
to guess now or look at later patches to understand.

>  }
>  

Reinette
