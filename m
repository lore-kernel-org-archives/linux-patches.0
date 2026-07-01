Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADFD74BCAB8
	for <patches@lists.linux.dev>; Wed,  1 Jul 2026 17:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782928546; cv=fail; b=tRp3UKgqiQUkofeUkMHZW5nq2c0vx3/8dtUK9NOoFv6h4qvuy2K45kW54OF2BeHRavQ1U5w0hqx3lphXDAhCI7mg5S6yvxoORnL35J7FX30NcBnhD+ADgK40HyNGoblqYJ+eRYb5oFmWtzbrZdsZvBGV8xiZSxGbfVaoLMAxHlA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782928546; c=relaxed/simple;
	bh=r9taHPpGqY0ruXday491ApUtZe1nje3OiStF8cStrhI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XeMKU7WGVWf4liXuWXtj8YRWzXC5ilrrvgq55NZAYnZCjM36DcwVkBskCXf0J9BXskBJiizhlWXVV8ik8yepymq2EP2YT5BJNwVtV7eAL85RZafRQyfhZcwUJSogM5w7ygLGZHETdL6LtvM9jleqQAMbn/JaTcOUDOVtUFVWGeI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EaQlsY0v; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EaQlsY0v"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782928545; x=1814464545;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=r9taHPpGqY0ruXday491ApUtZe1nje3OiStF8cStrhI=;
  b=EaQlsY0vqpqjlXlhQkE27X0LSjmRfomaVY7pZDsMfFrQE41RyeH/pctE
   EzxFmPSbg/3bgGMgbPHM5RSj5oJjU40I8QQvcJ+qlmViePnTeyEAaJ/7X
   Ki2frhg2jCUBWRdnPOvGt7LzZqEkBpxsI4a1RpXS8AppGzjVm0UhifMS7
   hOTX6c8F3qLZFXEYzvr8RmN0xpgJhSK/lf+K8Pxlc1rBf5fLji96mYsNY
   HRFuzPnKjxR/iKd4JKPEHioFmwSj7oAXYQ/tPzp9N29LJw5+yaVs+6V+7
   It5zIeopnpOJjaPJZ9lbjmjGRktdOjBLqGhFDw0jZ4z9qPq8DSrdU5rpd
   A==;
X-CSE-ConnectionGUID: MiCb6tPWTemwlSigeA03cA==
X-CSE-MsgGUID: owkTi0m8SAKudCTjJY42Bw==
X-IronPort-AV: E=McAfee;i="6800,10657,11834"; a="87351739"
X-IronPort-AV: E=Sophos;i="6.25,142,1779174000"; 
   d="scan'208";a="87351739"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2026 10:55:44 -0700
X-CSE-ConnectionGUID: fwwDHn91Q6WYhBT/ukmrFw==
X-CSE-MsgGUID: 3cKGUcqfRPe593XiatVRIA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,142,1779174000"; 
   d="scan'208";a="252772637"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2026 10:55:44 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 1 Jul 2026 10:55:43 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Wed, 1 Jul 2026 10:55:43 -0700
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.33)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 1 Jul 2026 10:55:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JVLxj/Fnf1Dw63LWxE0ZbGpzPTzVdfnKKZRMb19mNCGtoETdtT0ZLnLW0SOW1bZgweWju1ebwDkT+GVa6r1q7RWGejU4kRCjHSV7/w4axwYAPgR/6m+mkHH5m82ofTy/psx2CbVShJ1+xIj60varpAhtMjU+IWhTZC3dkDBDXWsXamdMvY+FXZoHIviCFX911hhJpxuSxmbswyFMwJxFtF0vEdUkZLZdsh82tKm8Nk5RFX8RwuYtIaDza5WJYSwVLK/HOChqNN8p8YS25K1LsAUr7jMT4CpqHeAlKQRuO13+KMsXYIkhGTgtCZueSB4bwBSKYHJcWfhWuDUOSIYEPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UX1mBz7eFca82z6y6BLyxGFcveNSjPsUXDgfqtPuR/s=;
 b=K3dh2XCdPAWHpWQHJ70GYowKAl6OgCh8AkX2YV4IhkUrxF5VKFQlrZZCDr9B9EpIihQCBpD+ZpwlqQ0YeeKdUKZbaPkFDnudPwIVEKBzVhIVyizO1f+61Ben4mPwwQVbVn6DwRgRmg+H1AKRMWVDIcUkexOsr46UgzKloq1tvc3LAlJ1wT2v1rinCOMlW+1/uoO/mUA2vnVQn/MBA2oAeb6ffO+OjCMRhe2M0A49xYNRaluwjxq2GSGaQWZn+eHejWJ5GpVvgb45Kji13+V2+5DyPsvB+v/qygbbnJV9oahOhERFz27xVZEvhr67lXkAzTdztd3mrkkaMKbcIBaNZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by MN2PR11MB4711.namprd11.prod.outlook.com (2603:10b6:208:24e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Wed, 1 Jul 2026
 17:55:40 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0159.018; Wed, 1 Jul 2026
 17:55:40 +0000
Message-ID: <4ba1c1b2-325f-477c-b7de-c12bf72990e8@intel.com>
Date: Wed, 1 Jul 2026 10:55:38 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 00/11] x86,fs/resctrl: Fix long-standing issues
To: Borislav Petkov <bp@alien8.de>
CC: <tony.luck@intel.com>, <james.morse@arm.com>, <Dave.Martin@arm.com>,
	<babu.moger@amd.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <ben.horgan@arm.com>,
	<fustini@kernel.org>, <fenghuay@nvidia.com>, <peternewman@google.com>,
	<yu.c.chen@intel.com>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <cover.1781029125.git.reinette.chatre@intel.com>
 <28449c4f-49e6-4342-938c-4a3699e3d682@intel.com>
 <20260610192137.GCaim5QSFx-YKgAzSV@fat_crate.local>
 <b58d51c1-67f1-4640-b00a-1a99dc93ccef@intel.com>
 <20260630225759.GDakRJ93cg21As0xnf@fat_crate.local>
 <20260701170917.GCakVJvegWA9R9liDV@fat_crate.local>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20260701170917.GCakVJvegWA9R9liDV@fat_crate.local>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0106.namprd04.prod.outlook.com
 (2603:10b6:303:83::21) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|MN2PR11MB4711:EE_
X-MS-Office365-Filtering-Correlation-Id: a551704a-a35a-477c-0135-08ded799f6cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|7416014|56012099006|11063799006|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: yT2ZCqdVxasq6q1wdiJi9WQSkw7P8JKP8yx04bzXFpqvZu0EMUV2Ajyuy0GA2KAoPHn4OgH9A7mJK9tlCuZDfkV3kTE695adQo+l6zgt4dXMhUqK8ro8PJpSWcAwpm0GkrfxwbMnWgu5s78czM7pqkF4+poDKxb4hIs43KGHrwLE2eq6Vum80w7fWxpyhM+LYR/fJFjjfj0HKh6l7Hs9XMDKmE/z9mPVsAmERB8S1HKGBKCHHLQoXtpohRUwuBv+sGzyDXtpwPOQNfp84xj77d4rYFCFV+QLnkDKmiJ+xi69AXYdgP7JNv4DK7WegkCiP8aUG2Kfv8hwAH/myKLDUPOtvuiyFLZJV/a6QTOvmmeVcBxLFqkv2OeqyCEl93GKrN8HbAptYsUyI6P/HfV65h2KnMM3pjs9ACs7apAgKhp9ye0nBshWq6ds0CFO16r7ycjhNBsIIOmcwXdW4QfAUBxjjl7wYvdueW4Q1NUnQ1RJzDeokUdlfC07v+EOdjKulQNVukgLUm4q4Z+jB2OdPCtuqqHZYLXxWVBjHAqaNzPoOE4XphSz7RyNLfYOSxJDR16QeZ6yZrn6sVVGpsMdYT5ExjNUXIdSG2uIX4lUkR/HuH5g95pPoe8icsonifwj6+Icx3mIsie+4IwWoaSVc+UsjKFoMPlF29GuxVGbzB0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(7416014)(56012099006)(11063799006)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZFltckNhSVlJM2pUR0tyaGZmQmlmWGxSaWlHK1paK3BlQTlYUkZxRFFYZjdG?=
 =?utf-8?B?WjR0SVpZVmRjWkg5aGdFbEVQcXVjZXVuUVhIQkdsczNjM1lZSU9laFhtWXM0?=
 =?utf-8?B?cVNWYjJsS20zaEo3bnVlRzRwNDJaMXczeWJSdlNWS1NRNnpvakd2eGcxOVdr?=
 =?utf-8?B?QzBSb09McDgxc2hOTkE5QWZ5NWx1L21rOUFNQVVMMzBzM0JJdzB3S01ManNl?=
 =?utf-8?B?a3diamY3WEN0cDBwTWhxQXo5VlRmNGR3aEFuTHFuV3J6Nm1EU0N3UmZIY0t5?=
 =?utf-8?B?SlRkZ0c0M28rSEMwdkJ3d2doZEowbmE5dmF1dk5xV25WV0FpaUtKSWJ6WXJ6?=
 =?utf-8?B?UG1KS2lhYkphSis2Y09rMGpKd3JjZllnMXh3V1hZRjgrUDhlM0lsZzAybEEx?=
 =?utf-8?B?cmFvdGVRWDZPZ2IxbkYxejNGdFVGK2g4ZVlpSThzNFBLeHIrcElMSW1uVDRp?=
 =?utf-8?B?ekxrdXNxMHMyRUVkQ1hTU2xyMjZWWUNjNWhYMlk0Z1dTVVJkbU1oV3RtYzU2?=
 =?utf-8?B?VGNzQStzRlZTVTZibTZkMktXUkk2RklJYTA0TS9iNnJvTDM4MlhHU1EvaWR5?=
 =?utf-8?B?dm1oTjk5L2lRTVhWYno3aklrcjlNL3EyZVJpaytyVEZsYUxzemdtaCtUcU5z?=
 =?utf-8?B?NlAwU2g1M0RUa2VIZGorU2tkUXhFN01qUlhWTlcyTVhxOVd6WVlNaXllRTNy?=
 =?utf-8?B?OWF5V2NFaCtTcS80dG9QQ1B1Z0QzK3c5SGVnaytDMEtjakpJZ0FBeHRMTTBk?=
 =?utf-8?B?elV0bGxtZExyUGZEWTh2Zkx3V0cwcm42bkdmRGl5c1lmMERlckszRDVHa2dZ?=
 =?utf-8?B?d2E1ZWJoMm8vc21VQk9hSjlYWjJpbjlVS2hyWWl5OFBacmxYQ1hOOTRqLzdQ?=
 =?utf-8?B?M2JVbzVBSUNqdWp3Qmc0c0VjaHQ2VUltSzRHVlJyNVU3cUNoenBkUkJYTnJ0?=
 =?utf-8?B?bE1SR25wdXFlVGlNYjAzQm9VdEovd0ZodFNhOE0wdnVobFJ4cjR6cGVRSGJM?=
 =?utf-8?B?M3AyMDFlSmh6WDBwZEVvaDR1dlRPSzBYWjR4TVJaeGlQTXcxZFpmdTlJdHVW?=
 =?utf-8?B?RVlyYUlGZ2ZxRTVCWG5zODhEbEtWSXc3NFJlbTVLRlRrbFRZTk1nY0lJcGlB?=
 =?utf-8?B?WG9FV0c0N09ac0E1Rm9nWnhiSTYwRElYd3o5VS9UNGlYS2c2c1NLUjRqMml5?=
 =?utf-8?B?RW9TWWh3L1pJRE04SXNhZzVuOEpSYmQ4cWNQNW10dU80MVNReGRPdVNRRHJB?=
 =?utf-8?B?ajB4UXZXdFlzNDlIVTNjTWVKNm5wZTlaMktOTVA1WHlxOENTajRSV0ZxM2I2?=
 =?utf-8?B?T3dlZ2ZqSkhJY3dqMmNIdHVsN1JFNHRVYmtWbmdma01pMXcyQWFRZEs4Snhk?=
 =?utf-8?B?Z3BWMjMvMzNaUGJRU0JDZ1hweXVKMmFBQy92a3Y1NnFNQndOR0NxMmZkTTBV?=
 =?utf-8?B?NU8rZ0ZZRlRvRXdCZ3B3KzZjZGZockV0TVBtcENmVUFIbndScjBveElnNU5H?=
 =?utf-8?B?YnRHR1hSYlJSOGxoTFlSR2xUKzBEYWZiZXRqeWZYQzR3bms3eXJrZ1gzUCtP?=
 =?utf-8?B?MlFFMDRJdDd0bzRweFcvTzdCVmlVL29GZ3NWVytNV0Z0aGRXMmJiOXl6MjJq?=
 =?utf-8?B?dDgrSERPUUhnYW5pOFNyTEFIZXhIcjFsRXM3REMyWmxoaThrVThkSDhuLzFU?=
 =?utf-8?B?c3QwQ3RxdjVBUTFRV3g2NzhyWTUxdEVnV3lZZHFZT3AwR09mNXZSMXlzNGtX?=
 =?utf-8?B?SzZhU3NrS0hiNjJ6N3ZmTG5ZZXJUYS9EeFZ6T083SDArM3g4aGZkSXg1MFhV?=
 =?utf-8?B?cDBoMkMvZ2F6aXM5TEdKenZYRHJYNFRUS0szc0FFV0JHbWxwZFZqU2hnRFZm?=
 =?utf-8?B?K1k2blkreTJEc1I1VnJLczZ6SHVoVHVTRmRuMUNORnpQMittWWs4cFZvY0wx?=
 =?utf-8?B?d3hIWUEyUHZ5djJBaWxNWVJPY2R0c094R0cveVV2M2RvYzczaVhIR21WK2JL?=
 =?utf-8?B?QTRkbW5DeHB5SEVEVmdQRWM4Y0gzUGZnZHpxSWRuQ2pWeTAxLy9KcE8rekZZ?=
 =?utf-8?B?Uk5OUmRxR2lhTlN4ZktEeDh5MTFNQTllZGUrR0p4TzBVU3llUDBPT1kvbC9Z?=
 =?utf-8?B?Z0NxcC8yWTAyQWhmaitiZGZjN1NTdDZ5ZE5DdWlCbGNLdm0rRFY0LzFRN0R6?=
 =?utf-8?B?NHFWQ3lNaFFSRnQwb2tyaFBJWVdSblp5U1JKTUo5NmtZUGZUWmcxWFhLbUhO?=
 =?utf-8?B?OG0xUHA3RGZ5T1U2V0JtNGhXeWlrZXJZUVgxaytZR0U1RHF3alh0WkdJNVJU?=
 =?utf-8?B?NHFFSjh6Q1N5c2JTcllNU1ZMcFI4VXRZUE1sUytPbHc2a3V0N1JkQnNzYUor?=
 =?utf-8?Q?rntE/tuR1LnHlIVs=3D?=
X-Exchange-RoutingPolicyChecked: SQLbHZCkn1QXO+L3XuThwP7xKqQEwkOnnaFn/fcaNNdzW5cB6Yzsfe5BEhP4Nk3tPMUba4Q6R0Hvt+f99TylCabSphU1GEAZt2sT7Lkbg0P17uK+518nsmFFYox86TJcCDuy42xrlnGRAgcniQ8ZIFGCuLPcd5CRIbKErAJBznYyeP1ZHxB4GqqPjg7h1uWB9oxO9nJdLKOHS6rn7q/UQQkoeL693i6UxUNsvT/nShXrnBp/i8O+7pa9o0fIoEyi63MEn5m3UX3jGPAl+5GtqNY/Dhb0g2vgNE3nImTFrxh7NZiLvUzDVG+OCJDy6Z7VLiAUNkqt+M0rBNCsH7Fs5g==
X-MS-Exchange-CrossTenant-Network-Message-Id: a551704a-a35a-477c-0135-08ded799f6cc
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2026 17:55:40.6290
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HsXWVkDKoF2LDUIskFquN7m/pEk+AePZU6zPyJ1rn+KJ4BlQO2H7OTYt1M8mNkha8/QojcrsY+99t0wqLLEq6n7le2tRpG0DG8Sca1bjgWM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4711
X-OriginatorOrg: intel.com

Hi Boris,

On 7/1/26 10:09 AM, Borislav Petkov wrote:
> On Tue, Jun 30, 2026 at 03:57:59PM -0700, Borislav Petkov wrote:
>> On Tue, Jun 30, 2026 at 02:47:45PM -0700, Reinette Chatre wrote:
>>> Hi Boris,
>>>
>>> On 6/10/26 12:21 PM, Borislav Petkov wrote:
>>>> On Wed, Jun 10, 2026 at 10:48:06AM -0700, Reinette Chatre wrote:
>>>>> After considering the latest Sashiko feedback and deciding to stop adding
>>>>> new fixes to this series, I do think this series can now be considered as
>>>>> "settled".  If there are no concerns with this series self then I would like
>>>>> to proceed for it to be considered for inclusion.
>>>>
>>>> Ping me after the merge window pls. They'll have to catch the "next train" as
>>>> it is too late now.
>>> I confirmed that this series applies cleanly on top of v7.2-rc1. Could you please
>>> consider it for inclusion during this cycle?
>>>
>>> Thank you very much.
>>
>> Sure, lemme take a look.
> 
> So some of those look to me like urgent material that needs to go to Linus and
> to stable@ now, no?

I agree there are serious issues here. What prevents me from advocating for them
all to go to stable is that the fixes to the intricate races required changes to
resctrl's core locking flows. I absolutely tested and scrutinized these changes but
having them go straight to all the stable kernels feels like a big jump to me.

> Any preferences as to which ones?
The fixes that do not involve locking changes are below. They could be considered
for stable.
1/11: x86,fs/resctrl: Prevent out-of-bounds access while offlining CPU when SNC enabled
4/11: fs/resctrl: Free mon_data structures on rdt_get_tree() failure
5/11: fs/resctrl: Fix use-after-free during unmount
8/11: fs/resctrl: Fix double-add of pseudo-locked region's RMID to free list

Reinette


