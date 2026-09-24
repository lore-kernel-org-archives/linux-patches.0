Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F7F44A5EDC
	for <patches@lists.linux.dev>; Thu, 24 Sep 2026 15:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790263407; cv=fail; b=kPO+xmpQ9yNxrc4OzEoueGL/bJpFFOoKM5e9fhUlm/mFjGnjV/h58vDRFimSsOU3Gt+y+w37U6rW3rGO7DskJ5XdgiFEOt1CjMw8lZPbNaLdL7aSGi4L84Rezlq4eFBI2Z0aPHKRnCW5W4WyjUyJFdUugPIbpRswQokDj5ZAUtk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790263407; c=relaxed/simple;
	bh=tRUdffl5VdgS1CJtdXyIcfNPn2/+WBn0fClAy76zlwM=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=TDfFIXbMT0vE6786uK9N0HmegRQk5o51B9uIVzVsAb2JhKr8q+MawcQHkdWKGjvvPH5qtJJ+J3pyy59BJmHVx7l0hXUdkmdArx2yqCLbf7TCeB6zsyrgOgX1SoBQcdQsV+KnkVe7upZcCrxzFkyv15Enus1e6wFQ6+BlWU5pCoE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=B6VVsp3l; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="B6VVsp3l"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790263404; x=1821799404;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tRUdffl5VdgS1CJtdXyIcfNPn2/+WBn0fClAy76zlwM=;
  b=B6VVsp3luXC2GFTHpg8lakJJV/h0iJsOvFxqNYog4FMBv1FlontPepND
   U/jEBOjBBwMURfcLSU6ZyAgAf4XxwtfqGnGzO+cboguWs8RcZYTmWBmle
   MF7k1/yGAv3hCoGfIvsonnj26hc/k86dUG3gJ9VUllIhhn4V7vGFAUMqB
   KquVavVtKwa3ByrkEHXbyJc4DWldSTVVss+xBHKS7X0XxBPdMeQXd6jXi
   xLhQGBiHToXA23gWtcj2FXE/D8zhHe1K0uxQ5V1cxr0a5oYOsDUifKef6
   JwnRdwrtoMyJ8YaM57EZ5kGsiWYG5zIh3m75ygIN9u7adcCiCPikp2acW
   w==;
X-CSE-ConnectionGUID: 7Av9JUYlQpeVURJo1WKI3A==
X-CSE-MsgGUID: +voe8kAbRz+1oxc+OxbMQg==
X-IronPort-AV: E=McAfee;i="6800,10657,11915"; a="102397058"
X-IronPort-AV: E=Sophos;i="6.27,120,1787036400"; 
   d="scan'208";a="102397058"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 08:23:20 -0700
X-CSE-ConnectionGUID: Pj/bFA/xSCuZ/eyi8gqXuQ==
X-CSE-MsgGUID: 9AdNgbjTTsq62WLp86fE/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,120,1787036400"; 
   d="scan'208";a="278797351"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 08:23:20 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 24 Sep 2026 08:23:19 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Thu, 24 Sep 2026 08:23:19 -0700
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.58)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 24 Sep 2026 08:23:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=laCulKP64k6w2tKw2DxWQRfWf4aKfFjATL5fet9fl7yadvGdPXNmqa1Om8AB5E53Jgd3qpQ9X9tt/W0QBa0Bouhx+Ei6mY6wEydXFRyQrT0V3WCyJA9S/YhQ5GjCdMQQysk2FaDqbg5G0uLnKVXED3Skz8G76aJP7KUtguCi3R1iubCJWfZw/squrbWzpVWCOKtdWk+72QZ2PD3xInjg1hAR/prNKFmawGWYpMVe0GkNe6Zi2ij9ibvJJ5RosJE0TZwfXB0rP2z7OHIl1TFYC7ac4sTpx4KHW50wNCdQzhtGGCLAzGPDtNcayaOc6HQ3ESDMnxNDjIhrCC+NGeOzYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vF4WnYOvT7+SM1hXqYqIuvOVVNJZzj/cyGz5nfUWwwE=;
 b=kg6xkmmwaC3cI7efzBmBYVdQeisgIfFcrS0H4Ab6ZIq8B8bQSTl86/4WGCV92GTNI7qEsymbzKhRub1tLFoc4RxaA991gA1k1uQr5t7VIL3mvSaW5c9xG/xI4qXchXbLvT4q3aTRN+8XmMLv+xb3h50MZMtOptpGX9Ee+R/Ef+xDfnu91rCBPOrC5arCQdt685HY22NwITrmixzxzTnIeAJ8ORPxJkNNAhp4wMeE8e8Eeb9SgIMt/nhO6QEoxkkM1MFGJHF8tqxWv2qcY1KIAyKJaYnQS1fPgZRg6Ba0U9q+UOI7ydnWv4FcoIiu1S/OmmTICMW42uoUceRBwlP0iA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by DS6PR11MB454219.namprd11.prod.outlook.com (2603:10b6:8:4c8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Thu, 24 Sep
 2026 15:23:17 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0451.014; Thu, 24 Sep 2026
 15:23:17 +0000
Message-ID: <10a42b38-190b-46ac-bddd-04216d44c22e@intel.com>
Date: Thu, 24 Sep 2026 08:23:15 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 04/25] x86/resctrl: Apply Intel MBM quirk from
 rdt_get_l3_mon_config()
To: "Luck, Tony" <tony.luck@intel.com>, Babu Moger <babu.moger@amd.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Drew Fustini <dfustini@baylibre.com>,
	"Dave Martin" <Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E
 Box <david.e.box@intel.com>, <x86@kernel.org>, Christoph Hellwig
	<hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260916231320.14502-1-tony.luck@intel.com>
 <20260916231320.14502-5-tony.luck@intel.com>
 <8e553b96-0755-4d23-967f-5d8a7a725474@amd.com>
 <arLpCDOPyKuOHc37@agluck-desk3>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <arLpCDOPyKuOHc37@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0242.namprd03.prod.outlook.com
 (2603:10b6:303:b4::7) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|DS6PR11MB454219:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d31f0f6-83d1-4d3c-c318-08df1a4fc24d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|23010399003|10067099003|56012099006|18002099003|22082099003|4143699003|11063799006;
X-Microsoft-Antispam-Message-Info: In2if3I/NiqWwMVG7ZYrTvuuP+8keKtikxsfzgon1LYrNkURnIh3ZUBdmQgHXBqSy/WO6CkioUNfMo4uqOpMufXSyyi30q0CLA4Gyc4mImVQKY9VrXqj319hPUk6Tc+oiILc0YgtWNJFJMP4pzwLu3ucok1qj9ISMMxW7+cXleOA3njw/5oUgjRmY1L4qz3Y+q/WD+TtgFjbFZrYtcDcBVz5BglGfuxfN6l4f/YYmyxIPPDEyd0RGOnaQRJvVV0N5YD7J61Xwv5heoqnD8r1CYHT1Ic6QqWZWK79Yt86cnTyL9A9U0k5VaNuhFcnRID5zVYcbRdGC4e/O6UHd3Q+rFWaO/MJJidoULIgKhiSAVjz3x3abSMjDU5avwUtT6mprL+O0KwE1K8T5c3Rjp71XhZ5MbEolXuVQD+LjLRDRgeqoRpxSR98qM/iO64uwzXHh4seanhg/YHWrh10wex4M2n4qr1l4jrYbRYo3cJhVqPQwra54p70uYdzpgN//scYzoVg3jjM6WG2f9DBELYE579UVeURqSieNGXr64MX/Ckesq9g3tXLxEdrdy6VvPfmun00Pyh307bqEf1Zrbtg0JLi179XzL7cQhSQkqLQinvqPYQhnKUqEz2LmHTbVZKm/aNyzVGq0cfE/YdbsObT1ekuvGqBFXeA2YAhRyI8wkg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(23010399003)(10067099003)(56012099006)(18002099003)(22082099003)(4143699003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V256V053bnl4cFgraHJFL2gwWThxeVl3MXVlNTVwMS9pZ2pSR0F5UkZjd2Fu?=
 =?utf-8?B?dXhIVHFneVNwMUpGUUdWYkRFalFqMXdWSVZuWTYwQ204cnBPYWZxNVp6RzRE?=
 =?utf-8?B?NzJQM2VybEphaGtyYmJGemQ0ekdDTVBxN3RFUDN4bW9VT05MT1F4b1JmT3dR?=
 =?utf-8?B?YWtJVXhjZzNyYldBZDE4U09xZ29DUlFtdHd6U0JjYUNqNWxQdG5CcjlnY3B3?=
 =?utf-8?B?a0dDcTc4Ym5yRk4rR29WOURTc0tHbkd4L2FNUHl0Z3Vid0xkQzJleHBFY1cr?=
 =?utf-8?B?c0JOdFhBejV4c3NwSG5rNjhJdGhmZmdOQlkrb25yY1BLQlRXRkVReTZLL1VR?=
 =?utf-8?B?dHQraFY5eHJhSXJkZkU4OVlWVFcrRlJDS2JQbGVQUHRhd3JCeU9Mb2lOQlpR?=
 =?utf-8?B?YVYvbmtGclhzekJkWFdrWHVITVhpSldYMEEzZ3VRaS91OHFBR1ZKVGFxR0JX?=
 =?utf-8?B?OWh0S1pUYzUvRUlSWnVudFpkclU0RS9iNHVoYW9lWjlWZTZEdHNsUy9DdEFN?=
 =?utf-8?B?R1o1dlF5d2tmV2FFMzZHd1NuNUluMEk2OEc0N2g5UE8rZ2Z2RWh2NEhLNVpO?=
 =?utf-8?B?d2pEV0pEbWpBWjg4L25Db3M4MG9GVHFYTldkTzhWUHNCOXJRTGFtVU1rbmFR?=
 =?utf-8?B?ZWJFWGZUb2lOTmxySE01VG85OGQ2TmduQlVZYzk2ZlVCa0RBSXhwM3ZiQkIr?=
 =?utf-8?B?UHZ1VmFLaWUvNlloRUNYZ0I0dkJuYnVHWC8rVTlpNTZZa1AzaW5XZEFRaXgv?=
 =?utf-8?B?NWxpaTNBSGQ4MVRyaEhWWkNxV01EYzBDMlIvNndQU2NldWpnYVBIOE5rWlhv?=
 =?utf-8?B?YnFMeTQvb1FTSkgvb2NFRHhiNk5WVWdyc0JBUmtRVEVtMHRISURaRmtodkRM?=
 =?utf-8?B?alYyUEZBZm00K3ZnWWsyNkVrVmh2cVE2S1ZIL0ZHdzV5SFJ2V2FJNzlwSGps?=
 =?utf-8?B?ZUd4aDhyTlBWT1ZMV044MDN2YWl4Njd2OWo2emU2MVZ2USsvUW5kbS9CaDlG?=
 =?utf-8?B?azM3UjFkc0FpWmJINGxZbDZDNkhJS1kreGVZdjZsV3lLZmdBMytidnh0YUhx?=
 =?utf-8?B?RUkrU3R4UHhiNWkyUzdRTzVvYVBmMEVQeVV4ZTFqUGZWd3RNZ2tWTmR6Mitl?=
 =?utf-8?B?Ym01SFR1MTk5UVJrdEVYVnpkYkdWYmd2Q3JEQ1B3YlpjMk1LWVp2U1pMdXFB?=
 =?utf-8?B?bG9PcFgzM0JsajR5OWhYd3BCaWZwVnB1QzJvU2xRbG1PaEI0Z29wRUFvc1Vz?=
 =?utf-8?B?dkF3UEs1dTFpVk51SzduYnJhaHdtWVBISTNoYjZ5bVk1SlExRVl0TmliWG9q?=
 =?utf-8?B?b3BvUXBya3R2dE9KUm5mNDM1RWtROXVKUG1jSW9tZ0Z4enRSUWxNR1BRWTNz?=
 =?utf-8?B?cFlBWUtYeS9EblRhMzJNSzVTS0dKNVZHM2VZd3VKTDROYkFhR1N1QlNFZ29P?=
 =?utf-8?B?MC9Va0lNOXN6NTlGSzdEM3F4SFduNU1pOGFhV0V1MXE2OXBYbFI4SXFtbncz?=
 =?utf-8?B?Q0JqcVdhWnRBYTJLM0VUUDRHTE14bXMxSUZpSWxEWHVPWUx3a29HMnBNMndJ?=
 =?utf-8?B?dEFxemwxRkd1ZCtQUVB2dUpKUzlyMHh0Z3RlaUFxTDZyMUZtbHcvSkdzM3FP?=
 =?utf-8?B?VmVJai80NmtPNm9OdGM5bGNwNk1tdVA2anpwRkZma0pIYWVEcFZkQnM2eDQ1?=
 =?utf-8?B?SUhMVWh2T2FSUTNCbUtrdjc4R1Y1dFpWd0I3dzVKWDJXbEF6WW9HZWJEYlJY?=
 =?utf-8?B?WDdiMjlhZCtETzN0M0lPenk0QVYwL2ZPRHo1Nlp4bjkxOTZIdytGWXZVZEJF?=
 =?utf-8?B?RVM3NlU0WWFNSjQ4TmlIWTZrck9LRjRBWi8wVmpoWXdwR1N3QzBVMHpxLzVi?=
 =?utf-8?B?UFJkaGNINXpDdnJNL1NmUDJaLzhGOW1KQmJqdndYelJpMFRwZHR4aVFRT3FJ?=
 =?utf-8?B?MFo3Um84amh5MmJtbDlqbmI2UGpiZXNkM1VveHRBRGlOMUxYL2F3aDR3SFda?=
 =?utf-8?B?ODFFS2pJTlZjTTk3MUtEcWZUZDVxVlRaakx3MzZlb3ZEaHpvSDUzaTkvdS9G?=
 =?utf-8?B?RlBLTEhETHFwREEzdCtPTnJPbnlPSkZHcmZDeGttWGRLNVN5SC9La3Z0L3BM?=
 =?utf-8?B?VENWOEo1eTJ1aTVOMDQvYnpoN0VRS3F5Z3Y0NjJST3dyODMrOTR5b1gzMFgz?=
 =?utf-8?B?ZVRhT2phdElDVTJlcUhLRzZ4Y1BVTThlUUdrYnBLZTRKbW9yYVd5ajVrYUdB?=
 =?utf-8?B?Q21hUXlVUmJ4M0ErTFI4Slc3U0pLaVoxS0Q5ejB4N2k0NXlSSFcwK25XZ3VV?=
 =?utf-8?B?dHVmYW5SUWJWeTJ6NTBFVEtCN1oyT0lEUzFLY0pmNkpxUnRSanV6Ly9oOFY3?=
 =?utf-8?Q?9HCA45XyF2AmuG+k=3D?=
X-Exchange-RoutingPolicyChecked: c1A4/DYPAKaNgx68DccUxX133l9vb0F0U/of4FA13gJelt0kwVGPsarX4hwDTR1r88bSIjxrZZ/SK7b3LcndQ8Xo4OQ4zj1XTZzRf3LPfITz8wc8hR0MmHrZYJe5tTtGIfbhdk12NC1hcyPMDd4dW4i+REYbzXub5OUu367pVUI0BWyQMZReaImVf4jT2zKzUsIysoFGLIEUrBDWJ0F1ZByjVa5EZxEemBW681lqcu6m8tKHBf49uqQrFcGHDRi7DR0SpzVLyRHUGhkDELj+VcL+zp0lXQWT9ONCTC9LaJuZmga0wXb/vOjRP2zC+FS8LaxSjo49zUwebfBzj2KR0A==
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d31f0f6-83d1-4d3c-c318-08df1a4fc24d
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2026 15:23:17.6226
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y3GOop+2T6D8XW3LW1fzCIKIZ6uwd9O//oacdCZjOQD++k+9Q0e6Bj5/yNa7qh2Maf/rWiq1bmR3pym24oLGznK1LYCF6i3PDgkYNMPgKj4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS6PR11MB454219
X-OriginatorOrg: intel.com

Hi Tony and Babu,

On 9/22/26 1:46 PM, Luck, Tony wrote:
> On Mon, Sep 21, 2026 at 12:45:02PM -0500, Babu Moger wrote:
>> Hi Tony,
>>
>> I cannot test the AET telemetry functionality, but I have tested the series
>> on my AMD systems. It appears to work as expected, with no observed side
>> effects.
> 
> Hi Babu,
> 
> Awesome. Thanks for testing.
> 
>>
>> A few comments below.
>>
>>>   int __init rdt_get_l3_mon_config(struct rdt_resource *r)
>>>   {
>>>   	struct rdt_hw_resource *hw_res = resctrl_to_arch_res(r);
>>> @@ -500,25 +516,14 @@ int __init rdt_get_l3_mon_config(struct rdt_resource *r)
>>>   		hw_res->mbm_cntr_assign_enabled = true;
>>>   	}
>>> +	if (intel_rdt_mbm_need_quirk)
>>> +		intel_rdt_mbm_apply_quirk(r->mon.num_rmid);
>>
>> Not a bug right now.  Is it cleaner to send num_rmid instead of SNC adjusted
>> r->mon.num_rmid ?
> 
> This quirk only applies to Skylake and Broadwell CPU models, which don't have
> SNC. So there is no adjustment to r->mon.num_rmid. Future CPUs are using the
> ACPI ERDT enumeration of MBM which includes a mechanism for RMID scaling if
> needed. So this particular quirk isn't going to be re-used for new CPUs.
> 
> Is it cleaner? It's a few less characters in the source code - so maybe.
> 
> If Reinette agrees with you I can change for next spin of the series.

This is a good catch. This patch thus changes behavior while it claims to
just move code. Architectural enumeration should ideally not hide
(without comment) model-specific subtleties.

Reinette
