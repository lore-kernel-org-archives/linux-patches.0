Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25FF52459C4
	for <patches@lists.linux.dev>; Fri, 18 Apr 2025 22:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745016145; cv=fail; b=tyPPhZne0JBSCK/VoyCTgXck8WAH6ghOwSvDFeNHINyy2Gls7DEeQG6pnaxng/UgL2DgX7NCQMTInPmMhuL+038+A/W83ngDNroC+Fc79fDaQIx6GFTevkIEbCzvFdsqcEScXWjeLsS7l5FFeBBH/ThkLpovPZ+C9p2tBGUDh+A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745016145; c=relaxed/simple;
	bh=ZHaq2gzeO8EwleQPxUsumJzm0nt2Wa8couRUeWtkId4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SQgcGuKy74R16FZCsD6ldtsOtbp87iPm+8nIH14In+aBmVYjp8xtsqCX0EfovgRH3PfwHTBNfYDhqsQ/gBjCdaCFlTL6/hj9saXPv3GDinYaeg9uGHyvCou0JswYG4/vXJzVASvIS5SdATnKSIMUlAvyCcwVJYR1FUM9avnSS/g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hFGvlgX3; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hFGvlgX3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745016144; x=1776552144;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZHaq2gzeO8EwleQPxUsumJzm0nt2Wa8couRUeWtkId4=;
  b=hFGvlgX3JU8xoqsIL4hf6GnrLC1tFAbTAB5SdMv25nUtgw7hIz267aWp
   Sd61kGXchygFpH8coAc7qLV8cTaNNZJpZoEgSbLDcpuDg/Cba7aJ/xosk
   uD6Y0q1nd6NMR2ZNX/loGhRdRFDrc01SJHEt1MyBZLdQ6kHNl2453uGJq
   1FX4xK1bogKOBFO07rK3Hs/HnRi8baJv0M+p5lpLcWG1SuuwWl/8VhGjz
   JfkNtn8sjNaOlMrmafYxnlUi0d30y0GY38jEb3/PQvIYBsg5RfVoN/kXa
   92h3OlEdBm+TnhgY93n/ASeSGDdEIRCpqL+IYD836n9LUhy23JqH8D7D4
   A==;
X-CSE-ConnectionGUID: Mi91clT6RN+5SjfrLul36A==
X-CSE-MsgGUID: Ha1jhc/VSHG71JRO+tdDUg==
X-IronPort-AV: E=McAfee;i="6700,10204,11407"; a="46821522"
X-IronPort-AV: E=Sophos;i="6.15,222,1739865600"; 
   d="scan'208";a="46821522"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2025 15:42:23 -0700
X-CSE-ConnectionGUID: JCPZjVWMR4OUOA1NxAKh+A==
X-CSE-MsgGUID: 3VZZg6LoQzCzjk/d/p0v+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,222,1739865600"; 
   d="scan'208";a="136048352"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2025 15:42:23 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 18 Apr 2025 15:42:22 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 18 Apr 2025 15:42:22 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 18 Apr 2025 15:42:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WeSPoWPSl1Ts0WV7FcnEu7J4VfJk8I8ocZEmcRRtz6XXRp5rpfU8tb5molPtoZnoYHoBdqAyZsrmE/rXqF5cRSE3XW4HUs/nPhbJiPvaM0oVWRy/7uYUJDADqTdJpB2yJMZ5Y8ZD/IJS5is/4Jgi1wFcKqk3x23mmtzx9amVW0mdn7sxdFxHjhFjhS9WBvQRUz59Owk6AX865s2vyfZGb94pUTvhM5CfoEQkP1R/iChcLX8SDXNS6XSEUjESxxQYMpavjc8gGFB9vLhhOVqpCVsx1kfhFfc4u5+Zixqmg8+6s512vyBn0cCUMIx6g0YXRdMANMDOPRBA0CcAsACvrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tuue7NGvgbZU0sF35hQvR8PSHKjnF17x5Ssiibu1akI=;
 b=x2WjOIT1kMiUqP9XTqfIUOWx8oBTGkzqd27cpJ0rJHsEcT5IvjvMTyhX4y0HiLxedL+gM9kr995mDp3Uc9R3LnCinL28QPnR2R7X8U85Gs3S1QuWcuJuUDg5DfHNvpfggmwEEWxbqDHXLgdbcyQmEspyKKpr6NOgtflnIqXRfoCRJKELZVYWjIYQLXZEoFGPxgKaOjSEaVWmOHqKolwgb8NrfPOfiTgYFzDK22k6ADA967L4Tb2qozG3qIzeM2zLlI8I5WlvLHHStHqHnf7T4888Ew/hABstwCdHQ8rjUQVDZZfDfCnxtwkdD5rERjyfsO2WX5a564vpFkGuOJ0DZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DS7PR11MB6015.namprd11.prod.outlook.com (2603:10b6:8:74::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.30; Fri, 18 Apr
 2025 22:42:17 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.8632.030; Fri, 18 Apr 2025
 22:42:17 +0000
Message-ID: <759a4cce-2d3f-4237-861a-e7865c8c9076@intel.com>
Date: Fri, 18 Apr 2025 15:42:15 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 09/26] x86/resctrl: Change generic monitor functions to
 use struct rdt_domain_hdr
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>
CC: <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20250407234032.241215-1-tony.luck@intel.com>
 <20250407234032.241215-10-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250407234032.241215-10-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0295.namprd04.prod.outlook.com
 (2603:10b6:303:89::30) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DS7PR11MB6015:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ed4658a-9665-46c8-9863-08dd7eca45b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?WXZxSTF0RXJJOFJzdlFoQzVFVWpDV0U1MEtnY2twUk5vQTYvZzltbnhZTTha?=
 =?utf-8?B?VFNHbHFBbld5UkgyQmg0bm1VeVZhUStKaVRWV09yeHozWjNXUkVPRkV5RmI3?=
 =?utf-8?B?cjh5QmtDRW1lT3dtdEVHcWU2MWRFWEw3c2U3WWdXZGxFTjRGajA1a2hrTFQ1?=
 =?utf-8?B?dHpGRUVXU0kxNk5ycVN0dk5mZmQyakdUN3UzV09YdUlaYUtjNS94Y1pQWm5Q?=
 =?utf-8?B?cHEzZXNJMmc3T054dWJRamlLZ2M4SHhtekF4Uit0a013dG9pUGNjVnNoVFFG?=
 =?utf-8?B?aWttRUhzNU9WWFFBSDBoWm93dUhXdTRXSmNCZU85cEZOV1pTTlU5Nzl3UWVt?=
 =?utf-8?B?ajU3SzZJWXlWYm1YcEtVVGRDZytPaVBSM3ZzWUh0UVZ3ZzBFN2FjTnhYYTBF?=
 =?utf-8?B?cEpXWTJPRG1aZ0hBYVo3T2ZmTUtlWENyLzJoNGtNRzl0L0g0YnV6dkpCNkt4?=
 =?utf-8?B?RzFIVHMvVWJVTHJMc1pQTUNUVkM5VGVnMitydWo2WlZMc0kzQ2cwSStVN3BN?=
 =?utf-8?B?YVNCaUNEQ2dCTURGRDRKOFdmRkJZQlE3cERtZ3RrM3NMdWFrQjNOajVES3FO?=
 =?utf-8?B?Qk9rQ1lBTDFObGRSYkEyWmcxY3dJdWtmRHJiYkVCOUo4blhvUzU3cnpqQ1JR?=
 =?utf-8?B?QTloanFWdXlxNlBaeDN0TWRVLzR0SXlEQkVMRktFQytLL29jYjRFTGVzWjZD?=
 =?utf-8?B?ZFcxbnpxSFJGMUJaTUhySVQzRFBiUm5Zd21DbVZqRnN0MVhIcG05cXlxSVdO?=
 =?utf-8?B?bWFMUEIyTXQ1MHh6d3dIWFJQZE5SMzlJdUhiLy9yTVRNUU9BWWNIOFhDZ0JS?=
 =?utf-8?B?ZEZtNklDL0JyS25GNDRDckhyL3pDNGZXK0VBUXp5MFRPUkNSTm9yQjB6TWxn?=
 =?utf-8?B?RkN1RUNaVm44TlM4WW0vU1dKclBvSXJtWnlOY2MrdkhDT2tvWitQNEFqTTlq?=
 =?utf-8?B?SnhnTzhhODJoWWxnWklsUG9wM0l4WXN4Y3RnVldaaHRIMllEMjFMSDVZKzln?=
 =?utf-8?B?d2g0QmdzTVdkREF5TU5EV2pDZFhJVkowVFdGcks2UW1kUGJ2QW5vZjVGcGhw?=
 =?utf-8?B?NWhlMGNkU2FyQzdqY1ZCa0xML216TUVLaGxuaW5sNm13c2tTbGozZGNiZTZ3?=
 =?utf-8?B?Y1VtR2tQZ2tjSWF1RjhyWXg2K3hVWFQ3Nk00Y2NJZzRrMmNJdE5LQzNZZWgw?=
 =?utf-8?B?eHF4b25mdTRob2c4blY0cDNuejRQVTlEbnFuU3dBVFBHSGdtbVhnSGdYd3Bx?=
 =?utf-8?B?d3YydTNLdlJDcmNKbm1CYTFpTDQvMzFwb3V6QlFSd1pUYXY4Ylp5RjY0TkZC?=
 =?utf-8?B?aWMvakJiVTdUZ0ZsUnJNeTBrOWo3TzJCR0NTZndnd0prWTB4Zmw2VU5rRngz?=
 =?utf-8?B?NFBiRVdvRlIzOWF5a09vWmM0NkE2WUp2bVRCTVRncmFWWGdCdWczUStlVUJx?=
 =?utf-8?B?OHpHTmhWNWdmK2ZSYWJ4Y0ZoWit3QldSSXNVcXlLTWRyQzNsWm5QWGJ5ZG9a?=
 =?utf-8?B?Mmh6bVRNSk1YcDY1WEorT0ZidXRFRnVPNkVhSXQwb214akx1WW9UVHhvTzht?=
 =?utf-8?B?dmhvejd5bUhQb2JZc2dCSm9jKzB3QzdUTUp1U015NURHVU1CUWpURnVXbXRH?=
 =?utf-8?B?Mm1vVzJYdVBhUDBmc09kSGRVQlVnTFFScTFITzhEbVV3TmdJV3UwdzRxZ04r?=
 =?utf-8?B?KzJkOWk0MDFjWWpWRTZ1UmhwdWZTRGFaMzhLdCsrdS9Qc1NvbFFqK3JRZkdC?=
 =?utf-8?B?cHpxamx4NVBtQWU4TmFHMG1EUGVhajNQY3ZaY3Fjd25nZUtiMzR1RzQxbE1k?=
 =?utf-8?B?b0ZCL1hsVXQzOFFiQldYaWxxTlhVOGs0czgwMUJ4bndaSjdkRTd2Y2JpdmtI?=
 =?utf-8?B?Mjd4UkxibkRMd3NuY282VXRZcjIyTmFheS93MWF0UXJqdUJsWm1rUS9XZTc0?=
 =?utf-8?Q?vXTr9VjdOHM=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R1ZOVmJvYTNIdXZ2Rm1HallhMXNiUXFBcFpKSnVWWXJhVGh2UnZEalZ6a1J4?=
 =?utf-8?B?dnhHWEp5aGwrWDNPbmswbGZxOVd6NFJseFNWNWh4a2UwbUZPSjcxYUxLdytl?=
 =?utf-8?B?V1VBL21MbnkxNkFzMnU2cTJTTlFGVndjaGZEYWxpd3BEaHZ2c01kZXRvTlow?=
 =?utf-8?B?b0s1My9TdFg1YjBZQjIyZ3ducVMzWVEvQ3g1aVpTOU5wd0hqUlhKT0twaEtn?=
 =?utf-8?B?SFJYYnVNTWlJNXh4Z0lyVEkrbTQ0YUdYbVFOOWU2N3FaRzdscUEydkdQQUZl?=
 =?utf-8?B?VUpBNlFqUnZZakNCaS9aU1V1VndEMVRZRW1HdVRZTkErZUlSVVY4cUxwVDdM?=
 =?utf-8?B?cW1WcldWa1pOZmxRL2gxNEtVMkdVVHNHaUFTQXAxN0lod0JOeVhmS3ZRaFNo?=
 =?utf-8?B?TndmK1lJT0VBcmdPaTRObHhSUEdCMEZSU1NreUU4T2VZNFB1bi85VVdndXBQ?=
 =?utf-8?B?SFJZUzlPZDg0aGxESktFUG5aRyt6TzcyaWc3UThzczRiNHVCZ1cySXlJOXk1?=
 =?utf-8?B?OUVuanVaWjI1VlRObmx3UE9BdjRDc1YwMGZCUC9pdkpvcUE2TTNaamJaeGZl?=
 =?utf-8?B?ZHZVWmFaN0pUTU5vSGtrMlBESzZjOHp6QUVUQ1hFTE9RRWcwcFZOaUJUYndL?=
 =?utf-8?B?dXhTOVgxREhmbFh0YWFQRlVES1VtQnlKVUhaanMwSnA4VER6alZBSVBkS0hG?=
 =?utf-8?B?TEZwR2dlWHB4NFpOL0tselNXdDJSQTJOeGFTTjdyZVFrTXBvVU1OSjhCMGtM?=
 =?utf-8?B?RHJLZlc1YkVBTzVGdDNmRVBKaXUvdVhpY0pLQW1vdGEzQjQ5azNlK2N6L0lU?=
 =?utf-8?B?c1hoQzVHNHdKbElUYVRUTTg3NjAxbTVmc1laVktuOVhMYndVR09xQVNNK1I1?=
 =?utf-8?B?eElyVy80bU9wUE1TZHU0MHZ6VVdMN2c4UWdaQXI1dTFybFMxWmJCUkM0b0xh?=
 =?utf-8?B?MllhOGJwQnF3ZWp2ZTVCc092Q2hQZTNjRFB3Q3piR0ROYzc1VUJydW5jMWNJ?=
 =?utf-8?B?SUY3WVQ0ak5EMWt6Z2M4MFZhaVZVckR0MWx4NE90ZTJTc3FtdUkzbysyeGM4?=
 =?utf-8?B?SnRQcFZTSTF3dXArZzVKZ3R5WUc0M1hvSUtHTzNzdHh0RDVvMy9TYnk0WkE2?=
 =?utf-8?B?dG5ueWcxeWNjMnF6d1VDWFREN3hVbTZKUXIwWEdOM21iRFB6RWNCSUUyT3l2?=
 =?utf-8?B?U1FNVnlIUzMvYkhFOTRDRFJpYkhZUTh6Z09ac3VFb0V2UDdiR29PaSthcXFy?=
 =?utf-8?B?UTllQkVYQXk4eWJDejR5cTFsdWZhS3JGS1VjRlRyTzBFa01pbTdoOU1Cd25a?=
 =?utf-8?B?WWg5M1BVUWc5Sm9oTmZJdnIwcEtITVAwS2hDSmdteCtqb294WHVGZUJEdmJN?=
 =?utf-8?B?N21FeDJhcXdtS0RHRjBvSDNGTExwYUJrSW1WQko3Rm5tdkZENS9Uc0d6UlJG?=
 =?utf-8?B?SXNacVB4SFNGWDYxUVNqTE9PeWZJaVdOUmZscWx0MEUySjR3NFBLVmJ1aXda?=
 =?utf-8?B?Vkx4bnAyMDc4R0Nnc3hBZmluUTlHRjJaaVpvV0tTTytyWHpwNHlzd1pPcHV4?=
 =?utf-8?B?RnIvdXJ6ZUxySk9udUcya3VJbndma0Y0WjNxdEc4MGRveTRadkhoSWZER2V5?=
 =?utf-8?B?Z1FyUWgwRnQ2ZkxncDQ3Z2VwR0plZzh3aGpmRnVQUVZaVUxFcHdCTVc1NzJF?=
 =?utf-8?B?UERrNGJCV3lBV3AxWThwbW5kenc5UGV4R1l2MmY4N2JBaXl3OW5Ib0VSR2Qz?=
 =?utf-8?B?QXdLaU16N2JCdnZCY25QcnZPMWRDZWhJV2pQZFA4eXV5eG5zVnNKaE85SEZU?=
 =?utf-8?B?QWI5RTJZTVBGK0hCekJEUkpwSis1RGNOdEgzT3l0ZFVVM0tiQ2tYZU5yL3E0?=
 =?utf-8?B?bHZVbEVrY21PSVNWdTNRcU5oWldCM01WT2duaU1rY2dWUGxBeXVPVGlIVmJx?=
 =?utf-8?B?ZC9CK20yS3pGNjAyeTltcExGNG50bVQ1U3cvNTNuL3V4cjEvTTRWc01PTGtw?=
 =?utf-8?B?VU9MRkZOOE1hcUNVUDRaQmZsbE1HYThSSXdneS9wQWpHVGRlMk5ybTh0WENF?=
 =?utf-8?B?S0wwMkZZNG0xVHJ3Nm4wR1RFaUpwM0V4RzRWencwUTBmUUFsK1hDdU5nK1pq?=
 =?utf-8?B?dllBU3BhL1dxdGdMeGZPTnJZTE5EUGpVS1J3WHVlMkhDdmc0QmFVU0Zvc1B6?=
 =?utf-8?B?YUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ed4658a-9665-46c8-9863-08dd7eca45b4
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2025 22:42:17.6094
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z+tzckgngmc5hiU4/h8jJcw5tZmiGzfDL4hOGODBtKuNxIibc4AHlQsdQ46gdy8T8MN2QfiBJj7O69lCaM3WRNt9wEDw7B56ezAxIcDktyQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6015
X-OriginatorOrg: intel.com

Hi Tony,

On 4/7/25 4:40 PM, Tony Luck wrote:
> @@ -4074,10 +4097,13 @@ int resctrl_online_ctrl_domain(struct rdt_resource *r, struct rdt_ctrl_domain *d
>  	return err;
>  }
>  
> -int resctrl_online_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d)
> +int resctrl_online_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *hdr)
>  {
> +	struct rdt_mon_domain *d;
>  	int err;
>  
> +	WARN_ON_ONCE(hdr->type != DOMTYPE(r->rid, DOMTYPE_MON));
> +	d = container_of(hdr, struct rdt_mon_domain, hdr);
>  	mutex_lock(&rdtgroup_mutex);

It is a bit unexpected to see code added outside of the mutex_lock(). This looks
fine since it is accessing domain list from the hotplug handlers but since it is fs
code that is jumped to by arch code and fs code relies on arch code for the locking
I'd like to suggest a:
	lockdep_assert_cpus_held();

Reinette
