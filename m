Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 697EB38CFE8
	for <patches@lists.linux.dev>; Tue,  7 Apr 2026 23:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775603469; cv=fail; b=sCJZ/q2MALmfS0MdM1vo8yXfAE9Iket3kTbrQimV+Qf7z+/mgAjx4zFoSLgtDAq6wvGl0ufGn1H01Qf33TGRGhFJUK/PDQsdSUB/E06huvBmnl8AaazW+4odcZUho3QKroxedtJVWosgYHWuvuyX8uszFm5++Vt2mx+RXVwVZ28=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775603469; c=relaxed/simple;
	bh=FNQFAxEtmZ4vAQMkXWLStwm+j4UjhBolFC3iIXog9OI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tUX4ic7AwMq0o0BKrSZvRJDNbIPz22LMkXlINIrAUnyEfKTE/pHobKDM1s2yKykpRdXs8DY8JArCdsuwSK425+BZvmXb/RSww/iaML/j+s8/DbBW/tAGG84bipM/3B5b0ew66YDFvGf4ci+WoJDEOzr5IF3ucUFfO8/dxtC5X3I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WrS/uGDB; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WrS/uGDB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775603467; x=1807139467;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FNQFAxEtmZ4vAQMkXWLStwm+j4UjhBolFC3iIXog9OI=;
  b=WrS/uGDBZuTsdejHgZqwf73ensNxBTrNuYCM3+6gVzxn3V2x4e6aWvf0
   AvrjTH4KfJK5voPHeaeoeCOVtCDp0wX5qIDFSST3CiueMLaCNvXrYehw8
   oGfYqqgT5RJx6GQXho9gkYaP8mSmwsIAcMPeOgIHjNrLBtVH5c2S7y99u
   J3zzhJvCRlkOmv0iIp0e7f7BJuB3WEXlCWTlkAdbd6WVNq0pf/1AOjggf
   j6P/9l9l/Y+jR2dTGolzJHPR94gr59js/cCBWC0FyAHTlBhpeA9Bj6aT7
   vYzzlBmGRxPFlw7p72yXAZ/7GUoVJrTi8BaueOUyGqSFTd65HjeM6Mqpw
   Q==;
X-CSE-ConnectionGUID: 1SbRX55RQnqSGHthgK50vg==
X-CSE-MsgGUID: ZYx0VzfzTvKdpqSKwC82Dg==
X-IronPort-AV: E=McAfee;i="6800,10657,11752"; a="102031094"
X-IronPort-AV: E=Sophos;i="6.23,166,1770624000"; 
   d="scan'208";a="102031094"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2026 16:11:07 -0700
X-CSE-ConnectionGUID: rh65FwQNSZSVCTZLkDOc4Q==
X-CSE-MsgGUID: 3clIvGIRRsaqyV3u3nI9Dw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,166,1770624000"; 
   d="scan'208";a="225537705"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2026 16:11:06 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 7 Apr 2026 16:11:05 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 7 Apr 2026 16:11:05 -0700
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.29) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 7 Apr 2026 16:11:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C3RCtGkoFJV60inlG8oQe3E+MJro5KjqidGcByNXSEP9nhKMB4a8k7peai4heZd9VAnhefbVt6ebD5YyLyM26Xg7eJL5CbS0VXqJsbpvJjYoRn/RZSTYy5geQK/SD+0f//tM/2TbirCxh9NdAzPPX8jELfSo4SaiWrfCG//L9sTQ8N+Reo5/NpO0sJlSCFtB5kQU3RwZGVo3zm5bq4tPyLWESJTzpKNtnTQhMWXrdjLLWl1j6fX8YK/tapYC4QX+sggn4TxIzwGBtJPRQ25RbfJ/N4SdvWCpFWOrDkpcdSE726JK3wukFoauLCKXoJTKUkflKQmq2Otr/X44Vx4FwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AHUVmktiNavvn/IYazNuu/ADkJqHt/QjWIMiXP1LI44=;
 b=gR0kIk3rTkKBdiIlTeCibl5K+rZEY43kRN5xgQeLn0RETtEFijuB85BJ7dddmUbAXmq6l4uA5kPpbDZJJDu6RyK3S577Qq/m+cQ7NByreLmOyoNza375/8LrTmIgFQdrz1y/Ppc4K0SQ8IyqbWHbhyr/SSv9vzuPTJvZ8lIi9rjUOan4KYwdP5DMhh1v2C+o1ftlIuxPWolYOQYopQGD0Ia3ixlHvUEvM7fLVeFkRk9QG3OJUNCOgEWP9xMZOWY1uZgKHoo0CcSgt6AMjew3pLOMTc43QjOmCzvIF9uXvni1dMw68/V8BzEOlO7YAcH6rrmkk4wjUNRyJGdIP3cmoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH7PR11MB7002.namprd11.prod.outlook.com (2603:10b6:510:209::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.15; Tue, 7 Apr
 2026 23:11:01 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%5]) with mapi id 15.20.9769.017; Tue, 7 Apr 2026
 23:11:01 +0000
Message-ID: <4af67f52-8188-45ba-982b-07c0dbcdc157@intel.com>
Date: Tue, 7 Apr 2026 16:10:59 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/7] fs/resctrl: Add interface to disable a monitor
 event
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20260330214322.96686-1-tony.luck@intel.com>
 <20260330214322.96686-4-tony.luck@intel.com>
 <7fe71e6c-e447-4aac-aac8-30941e755209@intel.com>
 <adP86aXVJONQCFc3@agluck-desk3>
 <f6a20148-28a0-4423-a0c7-472b97ec7f16@intel.com>
 <adVPqiY8NRQSR5Mw@agluck-desk3>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <adVPqiY8NRQSR5Mw@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0088.namprd03.prod.outlook.com
 (2603:10b6:303:b6::33) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH7PR11MB7002:EE_
X-MS-Office365-Filtering-Correlation-Id: b99b436a-4d27-4a97-0d3d-08de94faef86
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: Gb+KLq0PRKjwdsNxJfBRxdwnawgrojrsShXfuc983M84UXASzg/tgdUk+LujZiULdoTRwIlJQUzGPHlc4dfUW/lqlS9zza5ieGCGDfxMq7+bxZEOj+nvbHyuO4ElYxIwboVUq8qP5oj1rxpGSb34pQ0nhYxMcqFVQwphfMf+bqU8fA1YwRkIOwLXbOPNKDULvz5tQWNeCheXwu6qE6JddyUCqORbPDUd/N4u6xGsG/GQu84FjcZ5cnbpvE6jD66YxE7nRwT8Mz0isuHQoEJFDgLzmAwQ5GdzQb7/xY+OofJLj1ufbexZCzM0adnHtzvkfxXhd6xuWrOs8VXozAmuJR9f6K+BAkpbJnvSrDuJsvwjcxnlBV9PfByQ5dOs/ks5hg3nHfNu7o6MpfJyG2AgMy1/2LQkWLhmA3WntsiZneFUJeeTp8VWZLrGFEwHEvbAYyNfWDUqn8321jqf1DkxPF3PtpNrufeyclLFQlHV7kEBYsUXn6nFAAk70v38k3EqXv/a5Ee0b4Yl0UVTzzgNqjLycG6jxRmsDIPYyOSN6olBg8HaJPyaPg3txI0m9VxEto7fp7N6pGihs/XElpgVmx/+gaNaVMrrrSZKAU9izUqM++YqVSuxk21ykf9jgVQJ/4hBdMMhjSBFKKdvT4uWkX/yn2+ys5x3+7jCXQj9IVJLePWVEiVx2wThljbOGNN5N6JzOSzUhOIs1mviVCQIEX8GbZ7d+KoRoWAK3MWZdiM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ODY3SmdQK2JwWDdvUFNoeFI3a3FUT2k0SVhYVXNZVWoyTlQxTHN0dHlJYXFQ?=
 =?utf-8?B?ZUZQSmRNSWlUVzh5cHpIQTFnKzNqVTFiWXl2b1JqZjlZc05DY3pKbkJ5Wkpi?=
 =?utf-8?B?UExaL2ptdU5YUTlDbGFlOHdWK1NVZGNXMWRFUU5tSE1YSWEzdzRPbEp3WVJF?=
 =?utf-8?B?ZkxXNjVjSTJNWXZ6NnovWmpRSnhVbDJHcENIVFBYTG5pQVFYaElEcWRYNm41?=
 =?utf-8?B?cURXSXozVjVKd1dZWHAzeGxrOXpRTHdTeHl4cmpmdWQ2dWd6M0VROVNQZWM0?=
 =?utf-8?B?ZGxiS0lHVjBvSkUxYzFBbHhaUjVraEpwM014NTBBL3QvVFhENVVONVduOFZl?=
 =?utf-8?B?YjhEMEhYSkZuclZObUM3Z2xxRzhCaVk5QkU4bkF4MVNHTTFienNjMzB6UDNM?=
 =?utf-8?B?ZnlvSDlwMk43S0ovbldWbk5IUEV2YWVOSkJFYjJSdE5BOUJSOTF4TEVLREZi?=
 =?utf-8?B?ZWpIN0R0Vm9ISThXNkEvcDR4bGY2QVM1WTVtbmdld3VhdzFYZ1hyZFM2RVBj?=
 =?utf-8?B?d0ZoS0ErNjgwUlQ5WFBnTnFlejM3N01FSE5WQ3BVeGxsc3Z0TGorRVlOSUht?=
 =?utf-8?B?aktQS2FsOHl5UW1Da3lRSnFGVFVYMzZrVlZvM2JpY1l0aDJpRFM5eE9IZmRk?=
 =?utf-8?B?QnJ2U0NOU2h2QktSdEh1TE9NTU9lR0h1d1hDamxhK0NqN0NWVmMvL0hoQVY1?=
 =?utf-8?B?RDV0Sk9jaUtCT3VqTFhNamlBdnV5Mkl0NnhRMTFzSEc0c00rdVhKc1RhVm5E?=
 =?utf-8?B?a1lyaFFwb3p3YlJvNUJCR0MvOXhXNXBTTm5LMldKNVJpYlZnUlBLUkFJSlM2?=
 =?utf-8?B?STd1ZnlIWVVKWjBhUEZxek8vWis0Y2MyNmw3RTE3eitUbm9IVVlXV2lyMlgw?=
 =?utf-8?B?R0I3eDhROTRoWm92TUg0OW5kWm5nUStjTEN3SjdPQjYyc1Irc3hTOGg2b1Fk?=
 =?utf-8?B?OG53TVpBT084TlVoK2FlTlZ1YkxhS1ZkZGYwbXk2Wml5endZNjdLYWMyUTZV?=
 =?utf-8?B?UFRuYzlaM1RkUjN0V3hGKzZ3ZVRWdFBtVlVxSDlhK1RRWnpwWUVOOGRrbXlo?=
 =?utf-8?B?OHJiNE43dzhXVkExTWhwdUpvRThXbHNVSWM4aVoyeDVXOU9sM2I5SHBOV0Jq?=
 =?utf-8?B?UXpRZVhkWG9MR3d5YWlRUm51eHdaWXdncGdrV0lrbndkZ0dvb0tpM1hkaWE2?=
 =?utf-8?B?RDBQRHROZFF5RDFMZXorR2NXWXhOYk9oay9VbTlUblc1UGptZFNGUWEyRXo0?=
 =?utf-8?B?TmxHUHlmVWVGclFmMFgwK0tqdHdSV1B0WTdTWU0wVEdnWUNrZENiQzVZSUxu?=
 =?utf-8?B?OWhZU3pCR1FuWnA3Q244R1U3b1NUZGt5T3RNVm5Qd0lVa0JBSTF2VStOMGJJ?=
 =?utf-8?B?Vml6ZjJua1VKeUw1VWtTTDBaMEdKdlo2OGZRQ0oyVEt6Rzl0OFRGZEFUNXdB?=
 =?utf-8?B?aEFuSzZEbjVXQ0F0ZVJ2TUcyOW1SWjBudnNVWHo0SytRUU11Z3ZscWFnNllS?=
 =?utf-8?B?L0RySmZCVURrelR2MWFkdHhSM1pSRUZTVk1VOUxyU2ZpN3hEN1B5QkU5OXg2?=
 =?utf-8?B?aEd1dE1IdVlDdDNQNVhTeFluRXZ6Qnd6Q0ZpMnZ5OVVaOTB0TjcwMi81dWx4?=
 =?utf-8?B?U2drK09TQVBBZkVKUFJjUW9aSldJV29jN09rN21YSTAzZEduWE5icFdDZVNM?=
 =?utf-8?B?ME5vL0VCYzJGVm1POWlKUnphTjZQTktsOHpqV3dtY1E5bHNacm9VN3RFNEpa?=
 =?utf-8?B?RVRxUnlaT2orZkhGK2d6NWtCZi8yL3kxNlhNQzBNK3dZaDFZZXN2NzZYNnE1?=
 =?utf-8?B?bThkeHBjYkhzb3hNa1ljWFk0WTM3d21ZNzIzQW1jZkRtMmRmQTUwUC9PU1dx?=
 =?utf-8?B?Vm13NnRzcm5ubVZPSUxRWGxlY1lnVUZhUWc4Rmg3VHcvdlZmMFoycHRSTTBJ?=
 =?utf-8?B?TzVJQmdIdzFvN3BwY2lyT0gxVThLL0I0N1VwSWZNdU9RbzBqWXFweG9uYm4z?=
 =?utf-8?B?Q0RDOW05cXpNMXAyQjZyTEhYSGtlb3l4OGpPRndNWlErdDNtK0Z2c3VPcEZl?=
 =?utf-8?B?SVlVRFpELzRsWTNMczdwTmZ3OFZJL09ncGJJem5zWjFYWWUyVEtVMExKM1Nz?=
 =?utf-8?B?OU9GbmN5Tnk2VHU0cTNCMmZIMnROU21rZ1JKQTZwWUUxWTNYQzVnRk1pK2hq?=
 =?utf-8?B?UUFsTTVOaTdmMVpCU3lIcmV6WG5CbU1DV052aEhFWWVyd1Mwc2VCNzJ4TXZZ?=
 =?utf-8?B?V2FFbmxYd2w5WUdFL2V5cjB4MUFmRk1qZlBvRkRJK1JBUzZ1MEV3bW5KS0ZB?=
 =?utf-8?B?QmxaL2dzczJOalRDdmlyRmFuQnJZSTZoM0hESGFvQkRBVzF4NXlKeVNzOUNu?=
 =?utf-8?Q?kZR84pXWFJw/5p+Q=3D?=
X-Exchange-RoutingPolicyChecked: tFyCymIQqt8XDE7g+SadVCD9o6GxpV8y6zf/NVhAJEff5dlIo9sUe5PA3spwwAYoHKFnOe9uzkGp34PkbzKmHnGVpmCGnLp13o+JMs9zQEeQ5C32ZUkKmn4EJci2HjxykeBqo8DAez4m3VKBErNQRfAkP3X30BDbUMhkY6tsFlMlweKnVujiqW+ZcpCeCEUW65aLpDhYvwg5a1+tA8+kVVzK8bMtUWe/9uADNUkBLtDvLPxAIOUvwDqYQoDQtyl6J86q2oJqh9Y4pA4jjnEcyyN8X3GC3HtyGAPlP8clVg9U2aD8qCqmFfqTes1rlB/sb62ddIB7/8T8wQBGHgOv3A==
X-MS-Exchange-CrossTenant-Network-Message-Id: b99b436a-4d27-4a97-0d3d-08de94faef86
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2026 23:11:01.5364
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SceaFnAtRHvj/g2kI6gSWQQbDV3Jo6WlbKYiGpZXMHU21uHN8IJ+Tu+JXGff3qlS68vKhoCyiHYr9lgA8RE7Jln2Bpivgrp7PWTwYnRfvUA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7002
X-OriginatorOrg: intel.com

Hi Tony,

On 4/7/26 11:40 AM, Luck, Tony wrote:
> On Mon, Apr 06, 2026 at 02:13:19PM -0700, Reinette Chatre wrote:
>> Hi Tony,
>>
>> On 4/6/26 11:35 AM, Luck, Tony wrote:
>>> On Fri, Apr 03, 2026 at 05:03:28PM -0700, Reinette Chatre wrote:
>>
>> ...
>>
>>>
>>>>                                                               At this
>>>> time these scenarios may just fall into the "architecture must do the
>>>> right thing" category since it has best information on how state is
>>>> managed for the events as they are enabled/disabled.
>>>
>>> Are you suggesting to just drop the check for resctrl_mounted (as both
>>> a locking issue, and an incomplete solution)?
>>
>> I am indeed suggesting to "drop the check for resctrl_mounted" but instead
>> of "just" doing that I think it worthwhile to add function comments to these
>> two arch helpers in include/linux/resctrl.h that describes what needs to be
>> considered when calling them. That is, describe "architecture must do the
>> right thing" with some documentation about what needs to be considered.
>> Such documentation may help us to start putting some boundaries on how
>> these helpers can/should be used to help guide any future enhancements to
>> make this more robust.
> 
> Something like this:
> 
> /*
>  * For events that require per-domain allocation, this routine must be called

Since all events are per-domain and all domains need allocation this is not clear.
(nit: it is not necessary to say "this routine" when the context is clearly
associated with the function).

I think referring to it as "per-domain state" is more accurate.

>  * before CPU hot plug state begins allocating domain structures.

Architecture has some flexibility here if a resource is discovered after
initialization, like what AET does.

>  * For other events the requirement is that the file system must not be

"For other events" -> "For all events"?

>  * mounted when enabling events.
>  */
> bool resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu,
>                               unsigned int binary_bits, void *arch_priv)

Since resctrl has AET to thank for all the additional parameters and this is
another AET enhancement I think it would be appreciated if this be done properly.
Consider, for example:

/**
 * resctrl_enable_mon_event() - Enable monitoring event
 * @eventid:	ID of the event
 * @any_cpu:	True if event data can be read from any CPU.
 * @binary_bits:Number of binary places of the fixed-point value expected to
 *		back a floating point event. Can only be set for floating point
 *		events.
 * @arch_priv:	Architecture private data associated with event. Passed back to
 *		architecture when reading the event via resctrl_arch_rmid_read().
 *
 * The file system must not be mounted when enabling an event.
 *
 * Events that require per-domain (architectural and/or filesystem) state must
 * be enabled before the domain structures are allocated. For example before
 * CPU hotplug callbacks that allocate domain structures are registered. If the
 * architecture discovers a resource after initialization it should enable
 * events needing per-domain state before any domain structure allocation which
 * should be coordinated with the CPU hotplug callbacks.
 *
 * Return:
 * true if event was successfully enabled, false otherwise.
 */
bool resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu,
                              unsigned int binary_bits, void *arch_priv)


> 
> ...
> 
> /*
>  * This routine must not be called for events that require per-domain allcoation.
>  * For other events the requirement is that the file system must not be
>  * mounted when disabling events.
>  */
> void resctrl_disable_mon_event(enum resctrl_event_id eventid)
> 

Similar here. Please note the "allcoation"

Reinette
