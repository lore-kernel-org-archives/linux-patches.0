Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 080FB1A9F82
	for <patches@lists.linux.dev>; Mon,  6 Oct 2025 23:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759792246; cv=fail; b=Ijvz/Q5PSZQqqkJ8YIIcX4zU7gcWbWUYIZVr3IC+KtT6B7r9dUtJkdvQZALKDY4gHIxuZ0XE+iJYukcpEUFp4/KWJzPgn7id68nUP1Ai/6ctr/BDvXcxvGs4KMZ/KbglGwV6kxjdzcm3AIB6w76uu5UcPZkGUjZZIrcpVJDD6eg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759792246; c=relaxed/simple;
	bh=3id6DDPy8oHmBBslNXnBB1fe/2O+ThQzav+oNEMpOY4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=uuKOGPmwj2l3dS/Lg8CQcDpYXw6tX3L+UB/Q8FK3vpI6fqVw5WWynI5NtZGlDdHdJaePTIVTadtbilFZylrUHWRiVetMtiAz4BisoHNL8l9dyvJlPQb92uCSSQTNfnuaD1K1ab6lMsJadN6EzqwMZ96x9iwRR2/dk3Onco1LL8s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Lj1QRuZZ; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Lj1QRuZZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759792243; x=1791328243;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=3id6DDPy8oHmBBslNXnBB1fe/2O+ThQzav+oNEMpOY4=;
  b=Lj1QRuZZgdzRrBpDHw0GZO0rP8R57sDgX/QGHeHtebSpa5jqlU8vm5s3
   +QYV4c3oYUdlY+FI1ykL01+ci193sHmWXBciue0PbHN0Gv3PW6QN3bJsI
   0jIeKQZe+tND9T6kKzNT+2la9cigsSBV08BtlPC2AuoIEzdcC2DebVWk3
   t0FltDg3vKFloteJ4wll3aDJlIETwW6cLurtTXSDwks3XLCvHzHOtCz/z
   Lv2PFDhWAoBfRdWtXaK1gPuSv0OD7YcT5rY/bgAPFzAUdMaG9GZ0Ldz2w
   l0zxcE+bpz5Ci5ovYPH8/SwNabaO+72HgymW62zyYl2DDGlDDEOdF9o0n
   Q==;
X-CSE-ConnectionGUID: WcwI+V9WQLCBZQEFdbwl7Q==
X-CSE-MsgGUID: Z/ImomYQSauJKcrePsOYeQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11574"; a="64590372"
X-IronPort-AV: E=Sophos;i="6.18,320,1751266800"; 
   d="scan'208";a="64590372"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2025 16:10:42 -0700
X-CSE-ConnectionGUID: cpVqsu63SeieK5dG/Dy1Ng==
X-CSE-MsgGUID: p+KKAJ6iSCWJ0va1E8vNuw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,320,1751266800"; 
   d="scan'208";a="185284673"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2025 16:10:41 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 6 Oct 2025 16:10:41 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 6 Oct 2025 16:10:41 -0700
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.36)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 6 Oct 2025 16:10:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JIgIqqKqVz010ZCHKyug6eBACcGce0EgzhZfAGSxJJghlMnMHOuzTSzR+SDDRMaTyGfn0yCwWzhNvhCA3AauXbnK/QdHN75Q5/MBjpn+jHBTQGgQjEyhCg3w46ipsplXaxAXOyF2WrRtpaSf20CvQOV860c1achH3sKtmAjq7FHbPn50uJFLg7BxAv5Dp/VEToeRKN0Lic+r66fKc37X+LdmetKmTbw+0lpnsw1jR3FLk77KjQziMg+LTh6uuHvMWTOpgt9u34HTHyhJKiQTWzwRywE09dGZTOHtj0EwZXHYjcBo5u1EaiOSMpsZ04QArUjnnnYjMZEFHcxdhPjVZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9VN8QqbIQU0yS/ibmzYiBuM0on8CfRIKeShKenpKB1g=;
 b=V5UQXu6lR/yXwAXlx6RWOsa8jUxnZx0J9Jima61rIJ6iRWKM+6JuOxCJOchDbhzwuAvb4rJTha5QMUhtdDywqzGHORlMCaMcwl0S9ERX8k4MA2W5WW0Tm3k7v152ApJzzetlK8cB+NfarLbo426eNuIDMvYS978YCpiWEgUaDL4iuyJFfozITPrNeTybYSP5/RF5gfRgGZnB+3qOgOf2eBfW1l9xjPraA0D3aIrullJdmYEAHe780HuE8dO+xWXDf93isDh/yGllVz7r0sbCsg5QlaaoFGv76M3Yq4oqez+D6VB/J8qhHhfMVj+v1ltMP6bu8gVGTSolX1onLQSLQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by SA1PR11MB5875.namprd11.prod.outlook.com (2603:10b6:806:238::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Mon, 6 Oct
 2025 23:10:34 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%7]) with mapi id 15.20.9182.017; Mon, 6 Oct 2025
 23:10:34 +0000
Date: Mon, 6 Oct 2025 16:10:31 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v11 20/31] fs/resctrl: Refactor Sub-NUMA Cluster (SNC) in
 mkdir/rmdir code flow
Message-ID: <aORMZ6NUXMpECHU6@agluck-desk3>
References: <20250925200328.64155-1-tony.luck@intel.com>
 <20250925200328.64155-21-tony.luck@intel.com>
 <fbd49f1a-ddb2-45e2-b943-df43d2173503@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <fbd49f1a-ddb2-45e2-b943-df43d2173503@intel.com>
X-ClientProxiedBy: SJ0PR03CA0143.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::28) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|SA1PR11MB5875:EE_
X-MS-Office365-Filtering-Correlation-Id: 1125e18e-ee5e-4ae1-15f6-08de052d8d67
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?T7MYboRBgvHjq8+VpUwK2kQEVV8AcYTCc5UxN4//EKYgdYzlHwuOgIR8zwyV?=
 =?us-ascii?Q?xheG6RFbgM2lwfDhVmQwFLsiu4HzZ9PSA0mlnOd2Ymaq5b/5noZFWNPeUa0u?=
 =?us-ascii?Q?eSbZUEo5Y+omEWLwomwF+bkFf7mbHl6JVaSQ8KKuQkh/1N8YD38gr3pAIKm9?=
 =?us-ascii?Q?yv4jtGWMjO/6DP5DW1pPKqIM6/2uIIuSDL+RFLWgSQ48Cn5M4liaK8E5RvJc?=
 =?us-ascii?Q?FmeUx5IAkT9BdgZiuuPpG7v63JCa6sfdoAe7PVsJBkAuj0QdmfgrXE/81CuH?=
 =?us-ascii?Q?1QuSi4mILpEEEECY1Awjzd5PNbiX3sIvhASLtpNqMDzSUOZ4GcoqMr8lTnQk?=
 =?us-ascii?Q?n4yXZSWN6hArPUB0Hqa5mQBhAEKTra1jQzIe1VRKverW9eyhchp31g+tMl/e?=
 =?us-ascii?Q?UwFZxsPPg683IQkmE+VGl4RF6G3hfx05UJaRVnIcgaHbylH9MCD+96FU/Ep5?=
 =?us-ascii?Q?uy/Ic7vlmVFmju1aekzazuCfegQrye3u1aJtSaSTLFFQ1EEPNPF1+Ofrw4Dc?=
 =?us-ascii?Q?sxio2KBKBmkr8ePc1ukPP6reM5B96ls/OnE+LDyPy/UEBSdn1u82VuEHqkR3?=
 =?us-ascii?Q?6OmMZu88/Thl7kNVV9M86H9mxh7YH1xGEzKd6CafSUbL8smG1oA+Eihus4fC?=
 =?us-ascii?Q?la8JJueGjGueJsBI0wJzz2dS8nNuUpN/nTwpb5V7HIui82sX4JVa3pTHn1fT?=
 =?us-ascii?Q?1deIjvRKd844gZFVBWo1QElKJxxFotPqKH5iV0D28/Q3JREBhNNlzzXq+GjO?=
 =?us-ascii?Q?Ncujb4u9jrjgGsICE8V6eTORWfCcs5ACfXufmv/T97E0kTIYChIY+Sej6iOO?=
 =?us-ascii?Q?IYLlEFaUD5U9E2FdZMiDayCQP70iWFnSXeaZtSNrpbNnEmE1f27IZOGCozFo?=
 =?us-ascii?Q?wlHNHfegBYxFDc8GLK1AHUvbD0W3W/4WjUu/0Yzqz9fjRofGpzYgLxcl1hL+?=
 =?us-ascii?Q?8lSJOyDIvx5qg8IU/hJ2IkPI5Zf9swbIW7Or/+hEHTjQxP/65H+LoGKBQhC8?=
 =?us-ascii?Q?i6i96PfT5R5IKDZ3B6mh+DooS8rwGei0FVPlg3D5C5Oe7KjlaW3bDNJPCJ+d?=
 =?us-ascii?Q?S4Y67F/amV7X/P7IpZk/T3g6z7ilnvz9Sx5gCFkqbbZavoltjaKqnak9Jgx0?=
 =?us-ascii?Q?aCKicWk3bjvjQNEssUhaJ3idgB8Dq0Zk3eX3uF6AZPLaVIKyN/UOUp99YTSy?=
 =?us-ascii?Q?FqUq6kJ6sP4fIeZJqQEsA9Y6yIHnGhBA8XbYRsLi40dwJmPZPDUAp2Ktnfqr?=
 =?us-ascii?Q?KixuYVra4v0g6tRDX206i62ZEmpTRBy9jo4jDvNND6r3Ye5KaJOqGJ2MDTYd?=
 =?us-ascii?Q?t1fxQIiX0gaJv+1ouH2L70o/oowgFyVEwAiHWfpBj8MnwWHRRfLREk9cyPJm?=
 =?us-ascii?Q?FDtR67VuLz5/9+qFFI0Va8xkn8W4nV+JsHstzhmo5QveAGmnYs2va38veYmz?=
 =?us-ascii?Q?Zzp4zLnbREAAG2IbcZt9N5VjJGd39Sb3?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LIMB1b4/+0yz03qZxnDHFWRD2CM3Bk98RTmgZLnwXhwA0kBM2ihtR3JGdMJg?=
 =?us-ascii?Q?9L18HYsVVMIgOCmA6Xj6cOe+VFQyr8xdoRL4HAB54645Wfwlx/i7FwI2SSIV?=
 =?us-ascii?Q?7bTCMCLnMoVvQQ/epLd1b4QXOKaK4JqOrN9LYiuKnQ8fTpXnFWGW4O6krjxF?=
 =?us-ascii?Q?tsFu+cVHCGMFS63OjT3ciUAOvIb1BlpKN80XehJie+dIibSUtzBEKi0LDh7o?=
 =?us-ascii?Q?yCbNrQo9cUuyxXbgcvyJWzkjutaL0pQXN69UMIVF8wGMNU84wof8D0xouXT5?=
 =?us-ascii?Q?6tssvsBD5hqc6ZGXpTLuRwXDqfT2MKLc+5UByR1408OSrF0GSLKFxJbqq3hK?=
 =?us-ascii?Q?BeNppC55M/2tKA+TAgbH0n9TlDE2q1vjQRmCpNlbO2qLgBQcTnA02Ful8494?=
 =?us-ascii?Q?MWIMex8NP1FWhaWt3sQ8JC7+ozPnSL8yA5yTPsEHcOczW4+j7tyzyJXF8vF0?=
 =?us-ascii?Q?NpMdFKQffbLXkiIvgLdeV91PEYW3dK7kMg86zZcweAgT4ohKa63ACjGhiPKf?=
 =?us-ascii?Q?ehhyE75QkrshJM8bD/3rTjXqYdjZLd9gHCdafGnm7tgcEL9+pcBUAhFXKt/I?=
 =?us-ascii?Q?OgjYDEdoMG7gH0Q6b5oMSfZ1uwsj5/khjCA5H0KhOHsdxYH5nGH25JyxbXlJ?=
 =?us-ascii?Q?p1ITaYpf1Ia5mQZ/rr2WQasg4YAPSmL3nHmg/SZXvQzMzieHt3fvUcoS12FX?=
 =?us-ascii?Q?3qasQBlYv3H3VtZiNab/nGtp7xqNNxlXHFBYgpchztQZ6+MqY/1n4VrOwYYR?=
 =?us-ascii?Q?k7VDOqjDjTMZjdoa21a64SocixDuZHSiVipW1VZY1cVxIrGGPKntjz7kaBz7?=
 =?us-ascii?Q?r9tUopwdOEAB4nH/bzvoC81BX3bSAGACpc/s6KH5zF5vf8BxPbiTT3z6j58g?=
 =?us-ascii?Q?R4KSgZ2CzvHskG3IsinNMf6QNAKPCdWK91aangG9Jk6iRcdOiWkMa06RAMV/?=
 =?us-ascii?Q?FSdYrlVuXFQqd51TevBaXbhFHNUq87T5/SFysD0iXpmNkFwxsEmiKYAbHvT5?=
 =?us-ascii?Q?FT2FIX26X5i+T6UcmOlzLN3uECVPvc6PcTlanVJhOgzK078TDIQM9R3Ah+fk?=
 =?us-ascii?Q?gQIb/TbfEyQmw83WnJ39M66dzXRIj56e+deytHzSiDIsD1ZZoWTqxFdaibTf?=
 =?us-ascii?Q?FkrCaUXe4f0PRRAzkp3YS538bEnVzTwc1RZ0F9aExvCBZ8Zshrhy/xmTcxPv?=
 =?us-ascii?Q?ZfqH4dz5EDDwyJyzmBpzjwbbhgUrAawpguYPuzpwsDbRSE/yup9aE5u2trD8?=
 =?us-ascii?Q?jdsIM50JHK98BxKH5E8w8q0EzM1riei2GxNTapqnaDZjf552AVDFSx2+A/eB?=
 =?us-ascii?Q?VgFP77qONK5jB5vaHtJF89TJqCVkMpLTZLYG+HxQiC3lzgYpKx4iU9H+dMIj?=
 =?us-ascii?Q?gWXBnXU+BmCnJvFRF1kUV2EDd8o3rS+5ZBuLLaDtENi+QmCp9Hmoivv85Y8R?=
 =?us-ascii?Q?1YggeTfRaK+2Kk8WrS30folLG83BjOI9McUeQ75JzGzGiCn28OjkySe2b2Zo?=
 =?us-ascii?Q?cLMLhtlLBcvL6yXmDy2fkrw8PbU3fwwb3acbk+dG97WFc8+QZTPmOvZvb3DD?=
 =?us-ascii?Q?4bgl0nKtEt3J/Se0lGHNHWhnAu615Gec6dQBh/6o?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1125e18e-ee5e-4ae1-15f6-08de052d8d67
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2025 23:10:34.0016
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iRNyuSq2qb+JdMJgXy/AJ+AliyD2sSSEzq02pGu4YhmgYfb0MfZ444uxJiN7JC39NWFsyKM8iT6yj+LB3ozn4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB5875
X-OriginatorOrg: intel.com

On Fri, Oct 03, 2025 at 04:58:45PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 9/25/25 1:03 PM, Tony Luck wrote:
> > SNC is only present in the RDT_RESOURCE_L3 domain.
> > 
> > Refactor code that makes and removes directories under "mon_data" to
> 
> "makes and removes directories" -> "makes and removes SNC directories"?
> 
> > special case the L3 resource.
> 
> Why?
> 
> > 
> > Signed-off-by: Tony Luck <tony.luck@intel.com>
> > ---
> >  fs/resctrl/rdtgroup.c | 50 +++++++++++++++++++++++++++----------------
> >  1 file changed, 32 insertions(+), 18 deletions(-)
> > 
> > diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
> > index 6e8937f94e7a..cab5cb9e6c93 100644
> > --- a/fs/resctrl/rdtgroup.c
> > +++ b/fs/resctrl/rdtgroup.c
> > @@ -3155,6 +3155,7 @@ static void mon_rmdir_one_subdir(struct kernfs_node *pkn, char *name, char *subn
> >  		return;
> >  	kernfs_put(kn);
> >  
> > +	/* Subdirectories are only present on SNC enabled systems */
> >  	if (kn->dir.subdirs <= 1)
> >  		kernfs_remove(kn);
> >  	else
> > @@ -3171,19 +3172,24 @@ static void rmdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
> >  					   struct rdt_domain_hdr *hdr)
> >  {
> >  	struct rdtgroup *prgrp, *crgrp;
> > -	struct rdt_l3_mon_domain *d;
> > +	int domid = hdr->id;
> >  	char subname[32];
> > -	bool snc_mode;
> >  	char name[32];
> >  
> > -	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
> > -		return;
> > +	if (r->rid == RDT_RESOURCE_L3) {
> > +		struct rdt_l3_mon_domain *d;
> >  
> > -	d = container_of(hdr, struct rdt_l3_mon_domain, hdr);
> > -	snc_mode = r->mon_scope == RESCTRL_L3_NODE;
> > -	sprintf(name, "mon_%s_%02d", r->name, snc_mode ? d->ci_id : d->hdr.id);
> > -	if (snc_mode)
> > -		sprintf(subname, "mon_sub_%s_%02d", r->name, d->hdr.id);
> > +		if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
> > +			return;
> > +
> > +		d = container_of(hdr, struct rdt_l3_mon_domain, hdr);
> > +		/* SNC mode? */
> > +		if (r->mon_scope == RESCTRL_L3_NODE) {
> > +			domid = d->ci_id;
> > +			sprintf(subname, "mon_sub_%s_%02d", r->name, hdr->id);
> > +		}
> > +	}
> > +	sprintf(name, "mon_%s_%02d", r->name, domid);
> >  
> >  	list_for_each_entry(prgrp, &rdt_all_groups, rdtgroup_list) {
> >  		mon_rmdir_one_subdir(prgrp->mon.mon_data_kn, name, subname);
> > @@ -3213,7 +3219,7 @@ static int mon_add_all_files(struct kernfs_node *kn, struct rdt_domain_hdr *hdr,
> >  		if (ret)
> >  			return ret;
> >  
> > -		if (!do_sum && resctrl_is_mbm_event(mevt->evtid))
> > +		if (r->rid == RDT_RESOURCE_L3 && !do_sum && resctrl_is_mbm_event(mevt->evtid))
> >  			mon_event_read(&rr, r, hdr, prgrp, &hdr->cpu_mask, mevt, true);
> >  	}
> >  
> > @@ -3225,19 +3231,27 @@ static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
> >  				struct rdt_resource *r, struct rdtgroup *prgrp)
> >  {
> >  	struct kernfs_node *kn, *ckn;
> > -	struct rdt_l3_mon_domain *d;
> > +	bool snc_mode = false;
> > +	int domid = hdr->id;
> >  	char name[32];
> > -	bool snc_mode;
> >  	int ret = 0;
> >  
> >  	lockdep_assert_held(&rdtgroup_mutex);
> >  
> > -	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
> > -		return -EINVAL;
> > +	if (r->rid == RDT_RESOURCE_L3) {
> > +		snc_mode = r->mon_scope == RESCTRL_L3_NODE;
> > +		if (snc_mode) {
> > +			struct rdt_l3_mon_domain *d;
> > +
> > +			if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
> > +				return -EINVAL;
> > +
> > +			d = container_of(hdr, struct rdt_l3_mon_domain, hdr);
> > +			domid = d->ci_id;
> > +		}
> > +	}
> > +	sprintf(name, "mon_%s_%02d", r->name, domid);
> >  
> > -	d = container_of(hdr, struct rdt_l3_mon_domain, hdr);
> > -	snc_mode = r->mon_scope == RESCTRL_L3_NODE;
> > -	sprintf(name, "mon_%s_%02d", r->name, snc_mode ? d->ci_id : d->hdr.id);
> >  	kn = kernfs_find_and_get(parent_kn, name);
> >  	if (kn) {
> >  		/*
> > @@ -3253,7 +3267,7 @@ static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
> >  		ret = rdtgroup_kn_set_ugid(kn);
> >  		if (ret)
> >  			goto out_destroy;
> > -		ret = mon_add_all_files(kn, hdr, r, prgrp, hdr->id, snc_mode);
> > +		ret = mon_add_all_files(kn, hdr, r, prgrp, domid, snc_mode);
> >  		if (ret)
> >  			goto out_destroy;
> >  	}
> 
> mkdir_mondata_subdir(), similar to __mon_event_count(), is now unreasonably
> complicated. Just like in that earlier change this inconsistently adds 
> RDT_RESOURCE_L3 checks, not to separate L3 code but instead to benefit PERF_PKG
> enabling to reach the handful of lines needed by it. 
> Here too I think the best way forward is to split mkdir_mondata_subdir().
> 
> rmdir_mondata_subdir_allrdtgrp() may also do with a split ... most of the
> code within it is dedicated to SNC and mon_rmdir_one_subdir() only exists
> because of SNC ... any other usage can just call kernfs_remove_by_name(), no?
> 
> SNC is already complicated enabling and I think that PERF_PKG trying to wedge
> itself into that is just too confusing. I expect separating this should simplify
> this a lot.

Ok. Splitting these makes sense. I'm terrible at naming. So I
tentatively have:

static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
				struct rdt_domain_hdr *hdr,
				struct rdt_resource *r, struct rdtgroup *prgrp)
{
	lockdep_assert_held(&rdtgroup_mutex);

	if (r->mon_scope == RESCTRL_L3_NODE)
		return mkdir_mondata_subdir_snc(parent_kn, hdr, r, prgrp);
	else
		return mkdir_mondata_subdir_normal(parent_kn, hdr, r, prgrp);
}

and:

static void rmdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
					   struct rdt_domain_hdr *hdr)
{
	if (r->mon_scope == RESCTRL_L3_NODE)
		rmdir_mondata_subdir_allrdtgrp_snc(r, hdr);
	else
		rmdir_mondata_subdir_allrdtgrp_normal(r, hdr);
}

Better suggestions gratefully accepted.

> 
> Reinette
> 
