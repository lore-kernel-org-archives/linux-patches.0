Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B1822D9ED
	for <patches@lists.linux.dev>; Wed,  5 Nov 2025 23:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762385476; cv=fail; b=ZwXc99uklWQA+l/DLYWZoodDlJIhA9UdgM9CyPJp8o/ihbizbqdajjLFZO3BUFnkwMWT2/pgE8rtrH1De9cfslguX1JzEDeozrh3zYPC4j5P6Lvv74ToZgZbsYm6HCF8I06wy9QE67ws60w4usPaPGEGswtUwN6YlwKzca4od2g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762385476; c=relaxed/simple;
	bh=Ry0wYUPo39u1w+sq3JW4WDKIeRxAxyJBtx8O3/yuhtw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=khe5x/E+V+8XmK6TGSQ6rwE7/acaQGo9ZyM8upXhEn/t6j+K4jI3dtHgmQxOcODSq3SVMb3Xwqrr6m99AxkwgeHBNW4vLm/+xEnxDSsi1ZGZRn1lpSrbGfhpP6Ck+D/UVo4NgaBAw22W7ZQaUWpUIBe/NHaUudaqL5UQ7Q/PVUQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=c7WxQLk1; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="c7WxQLk1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762385474; x=1793921474;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Ry0wYUPo39u1w+sq3JW4WDKIeRxAxyJBtx8O3/yuhtw=;
  b=c7WxQLk1pcJkW4uFFxuUsInbC/AyevT3iz3BMjq82ChPpeF25CEHpkw3
   pivcZRC7kskpRjal8eTddQBCRjf5qdaoDif+KT2IgwdcMApv9B3KELcGy
   IiQ2oRWVIYdUjaV8IZPVlMMMQRDGMoKTrsKh0ch7Jk8WK+FffJWzAi++n
   +wZptVjZGZhjWjzP3D1dvGKDqMB05X1VaFhjLlPnh2B8a2ijowtkJA5zK
   aLr7qupQSJZ0W6abKGlYzKw5RuAuKqGmNj7un/ROLwYvx5xSYwF6jdYPo
   lNWVnXmxrrZTjUW4Uyrnz9xs58DrQktwQ8SHNclN2oDnKLkCWw/k3GH56
   g==;
X-CSE-ConnectionGUID: S/dPSDpxS022qHZJdgsKLQ==
X-CSE-MsgGUID: 7P9IW8yqQ96rVbbx3/Shdg==
X-IronPort-AV: E=McAfee;i="6800,10657,11604"; a="64551750"
X-IronPort-AV: E=Sophos;i="6.19,283,1754982000"; 
   d="scan'208";a="64551750"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2025 15:31:14 -0800
X-CSE-ConnectionGUID: 1CspR/p6SPe09gsYrrLO2w==
X-CSE-MsgGUID: kjZKV5AVQxiQV2p1Lou5tg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,283,1754982000"; 
   d="scan'208";a="191696116"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2025 15:31:14 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 5 Nov 2025 15:31:13 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 5 Nov 2025 15:31:13 -0800
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.5) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 5 Nov 2025 15:31:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XABGBXvuaLxZQEROXlWHqdhdsUMy5gaD8sKZC0fOcdJdDt3GiK4ZoeDSWLnZNoBU7HDb/sHLxOryOaRV0sbZH5FcmixWklK0zQQ054xd2LBSCorbVOT7HjSgxkOyca1JDZZNimLN+0dx2Z2ssBdF4TrQykzYCfJ2TAEcDMHr7nYNo9ViFF1Abl5E4imicquQn1zZ9kHLfuDO7h577jiRAsG5BabSrS++qjvenOMAS1q6/h68+fXYtt93Pn3Ca6rN1J+xnOxSEXxVI+5O5pTgRJDPp3QOqyuN5pj8r3b29NqONgv/pFVUSnTnt6Ftl729itfVycx1hUbAbsbliZ+wjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gyp2x/A0PqfQL4ZwB7R0rYBrLQzpFVCi5hVhS7EAoQo=;
 b=VMtm87VRWPNZYalAlLCfUj5rcNTZuxMLa9Vk14DlqJ7ftsCJnD9AUJcXYfGA5HUDxVkzwbWLjT8NTB+4GZ5vRisiRchr6Aat63Jw3JCTBniIHxXDrv4pxTQjIUK/iCO/yucf8oT8nExhaYeebc/SlBDP/EMVyvq0U7aVI/eH+ViWugMXLaPZR4A6rd3yjB2Gnv5wwVcUohcl5Gog85Pp2k8bXKI89BcejhV+NpRPPrZ5kePmRQhxOLJApEwiSphYK+JWIeeYLgHD7679oqYzpiIvYjufZaA0aPXfHOTJGVdXzRZpxLdkmjspzrJw9OPEasiVOYRJoMo4MhuwFpcvLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by PH0PR11MB4901.namprd11.prod.outlook.com (2603:10b6:510:3a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.12; Wed, 5 Nov
 2025 23:31:10 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%7]) with mapi id 15.20.9298.007; Wed, 5 Nov 2025
 23:31:09 +0000
Date: Wed, 5 Nov 2025 15:31:07 -0800
From: "Luck, Tony" <tony.luck@intel.com>
To: Dave Martin <Dave.Martin@arm.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Reinette Chatre
	<reinette.chatre@intel.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Chen Yu <yu.c.chen@intel.com>,
	<x86@kernel.org>, <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: Re: [PATCH v13 12/32] x86,fs/resctrl: Support binary fixed point
 event counters
Message-ID: <aQveOz66Pd3R0FfI@agluck-desk3>
References: <20251029162118.40604-1-tony.luck@intel.com>
 <20251029162118.40604-13-tony.luck@intel.com>
 <aQtiSmZ14b+U/J4U@e133380.arm.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aQtiSmZ14b+U/J4U@e133380.arm.com>
X-ClientProxiedBy: SJ0PR03CA0142.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::27) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|PH0PR11MB4901:EE_
X-MS-Office365-Filtering-Correlation-Id: e95393f3-5cf2-4735-2aa4-08de1cc36678
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?N77FY0rwxVx+4CQeDRgjtxHJvuGr2zJlLkBjCW2m2eYEBDgKG6GbaSgtoyvq?=
 =?us-ascii?Q?wCBSti9YQo/zSxZUKvshcUFI6ZyNYdrcxHMEjeizHbXkQn/dxdii3vWc0Nu/?=
 =?us-ascii?Q?BnDU3GQpAXklkcsxQdmkH91rFvA9FYIVqt8BvL8kZk9Qz8kvcFwi3NP4YMm2?=
 =?us-ascii?Q?oK766CR046QbK9iRsAKl2PdQX5IOv+Hu/PG5NchVX9GSphM8wTk/f2fo4afF?=
 =?us-ascii?Q?W6Of5j/Q+i2PWUmEap7NaDRoMSrqlvOdP2zkfE9Gw5iTt5X6lkfL04PjdyEl?=
 =?us-ascii?Q?Bdnj4nz55uwkViTlnAF7TViimq3X1h6qTSkq6+3qyheVakgs2JtlUZerDmee?=
 =?us-ascii?Q?2wMVUGmyju8xNGldoOY3oc56P4t/LpAnZZ0kTtrONFvPXjUbenA7YtoFdsRS?=
 =?us-ascii?Q?LOuN3C4ymFKcQ8L86LMmdzEkb0kPGw883rpntXVZR6Krb7vOFHbitb5iJgUV?=
 =?us-ascii?Q?yQ2e+comjnOegjKNFfdvW3d2fmob+GgSdmGhjZ2qkj2FJz2TaVp7cYsnGnP7?=
 =?us-ascii?Q?eoBLxcgXSC2h8Va4TloJQUnmVJqjx1AXd/g70IUHhndPBXvlJfTKeOvfRvWI?=
 =?us-ascii?Q?hdClEzkWXvADM5eo7fGPPTod3wBAiltHJnP5CYy3EUiNg7LQ3gPRxwb4awiw?=
 =?us-ascii?Q?JIL3MXzUp8vu/Mmeu8H/FyCnlZ0/w75BuOoFzdG8YqZnIaYgMM0G2W5ytQ1u?=
 =?us-ascii?Q?1QkYunnhkB+IUeM0DdbgpPwJpG+bMTp6yoHQcao8u1jiaRUKf5Bj2OZ+bV1n?=
 =?us-ascii?Q?ZBNuBKDXkoc8zvywZyQ4fyGTZ25wdEyfNnFOipVadYQAuA/toTQm9h824Roc?=
 =?us-ascii?Q?8bkJ+ruGdTm6QGQu46sGIsB939DZoXXe5OkzeBOjaf8kWgMNkrITF4NXTD5h?=
 =?us-ascii?Q?CqN+zBB3GfIO/ccXahwPNOIFWcq2g8LbPoTX6E3+v+r9OD6VTDdLtjEoxP2z?=
 =?us-ascii?Q?RdVhfi6Q1Z57UyASCzdyJlq7N7ng2I7dqLXL+2Yo2mbt4IKqi2t2jqrYiUMJ?=
 =?us-ascii?Q?JPBjLAFx8jGvQHHr1ewr0/ohqiIozHEXtTHSiT44ctPLh22D1Bm2n4SIzk8I?=
 =?us-ascii?Q?5R+KtjDJqUpWU+k96QuRwAUc+/zPaTd4Ypd2AEFXMxSxA8SEfHMUaY3lpVc+?=
 =?us-ascii?Q?KMJ10bjx2/K8KAbp3wtIHgqT5ibXo5oVg+vUQpi8rvh9f6vyCL5MrMMKb/2r?=
 =?us-ascii?Q?O8GalaCygOnWazV3RMbUKkXMH17RHfSeCNFgbSmDGFnAGcU36JLRLtmUUFbT?=
 =?us-ascii?Q?TTTF3VoPVz10cHzbmbjtSlwqse3cEk7azO27xmIf1syCiUQRiGTqUXjIwRYO?=
 =?us-ascii?Q?+mURxKSMh+NF/9TFTtCI8AnODo6SLZ32e+LbBpAols6OoMdPlKRZBCfwsfQ+?=
 =?us-ascii?Q?4V80A+Iknhpzw9mPxHqIqiUWvgVGJNZzC7OqtJ1OQTH01iEhX4na36lMsx8y?=
 =?us-ascii?Q?/nFMpYRh32FRXkWmydGvloCYofGEEg9A?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LxK+E0rkyMNDqyr8kfmY8Z98OVU8l+YqjYxsN4vDi44dTTEocog3KhRJLK8E?=
 =?us-ascii?Q?MWa9bC6EAfzwdZSrwe+NvfuUVTKyaIeLYA1IhVZl4IJJJE0Oi7KkPoP4E/mn?=
 =?us-ascii?Q?SvNHqdncO5RQHJDaSfYEMAeuaptXHqfHP7YyrTHv2KntTqZnt+PEVtikySkK?=
 =?us-ascii?Q?9yhjCnlvN+uZZxwOsM6U8NzCKO29fj1kCLk5Nx8wLnr27pe2IOp0CpCZqYdu?=
 =?us-ascii?Q?uvDPQg/o6ZwdfRP9XaljeI1OcuuoxGMu6osxXHpSmYe8xbXT59nTmktY4ype?=
 =?us-ascii?Q?/wp1Pk2VSla8VpYR8F+b+VCunJFb+Q0TS20zX0Jy0BbzdH2IUUcvHzY7RwZl?=
 =?us-ascii?Q?tZP9GGIzjJDRcCdliXXN5K4d3sGsfCCZ0+LGDNQ6J0ZGnQExhtD3YSgo6HNP?=
 =?us-ascii?Q?/WNvO0zJxpFc7vvs4DM+fX92mBOgH59tM/ZT5RLEFdJk21fErlKYP6pW1gyn?=
 =?us-ascii?Q?dtc9OAlg3wjIfGqC+rKSMjfbdaCUx3w623mTa0cJOiEfEPN3ifNdDrkOuiT7?=
 =?us-ascii?Q?Dkurfa2z1R+XCcGtKmWQC+XrRxd3gm6tx+6BSqPyHPx6fdUSIX0bm4HoQZZB?=
 =?us-ascii?Q?YjKCkM75E4CooCDnnQTsht2vqEvPz0sXo6SBa1EwjHFVM9thtTTftPFfVfF1?=
 =?us-ascii?Q?XZinJbvzeppjkQCqRCO7j3u+X+sZbSq2dh65/Ja4eLVzj5bxSKXalpcXC8v4?=
 =?us-ascii?Q?3XBWa4SXNh4iTOnmpplHNJH8nd+hJKm14CECR7pItwe5khIVejkF97EcoA4b?=
 =?us-ascii?Q?FtyWmR6eVsGRZr8LT6J3Q+cI/uUIFVvjQ+XT/hKEbGIb7TNW30S24ip12xKN?=
 =?us-ascii?Q?/1LMq91dqQ83GJDDC3eHd9uHyfIrp/dwHVqMHgbMzN20JzFqj71BA6HY8bsX?=
 =?us-ascii?Q?tApzrpoGQ0RZheKFwZ8k8q4ZsNnx7yKrxEqL1naulQ658ZprptFDqyBE1o8i?=
 =?us-ascii?Q?cpWEegImKniSZgPW7tahsOScUQog8dnLbjGaUdX+QqQ4rgfFT9jAgPHRGJu2?=
 =?us-ascii?Q?+hZciEs+ApEtrjnyUXGdhmtcaoQvicqGsTB8kUZeT7tqiIDGa6G5RMQxHhGb?=
 =?us-ascii?Q?TOTxFh+Ja8qIT8JtJsH9F9L1bgPv6HgBqrsqgiu+WwakLqOYpXVMV0tOuxsh?=
 =?us-ascii?Q?voIK5cW+NJEeOHP8tJFjFuqtW/LMDLuP9PrSDhBad8m4RVE76HU9N7JwNjbV?=
 =?us-ascii?Q?GnweaApBzaiEi+nL6raHKgYAZnFoqtyFJSjuWIkEbVtnxqmoyKDWtKh6v1+M?=
 =?us-ascii?Q?OB5edEc3dgaouxZioY7Ni/z4whWrSaziiYQwME2EnGsJr8/r9bFXsFkCJ5/g?=
 =?us-ascii?Q?B3LiDvX4aYw2/tE1mi4BkyK3JAEGtTNKuSMK9dDm3tgIi34OMHFjhkEk7Aby?=
 =?us-ascii?Q?o9sWW78oxsJB0YuNTjQZqZwgVLMXnyKkvdBxYfHGw8NENxLWZ/TCiWBtdDhI?=
 =?us-ascii?Q?gp3Rn4bd2pM/RUDFDuo2TLGAqeHusnqZNyX7f9rqgc2DzHUK/EALaooF+dkS?=
 =?us-ascii?Q?rMunBAalMnhV/Aj3TxDkRNGG9jgXtED3oDwIbWsVIeEUbOOqcITC/FZKmo0T?=
 =?us-ascii?Q?lnFIYSA34X0iE8ktfVFD73kknoAsKPsTYlaKFmXG?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e95393f3-5cf2-4735-2aa4-08de1cc36678
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2025 23:31:09.8430
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EB5lToA0dVp9BTRRcfdZjYcdckRTAZXWKocaLvb0tVmjpRYBw9mesn0ycrlYTwbnz5UN2rMl1ujdT19cNumsWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4901
X-OriginatorOrg: intel.com

Hi Dave,

Thanks for taking time to review. You did unearth one big bug
and I'm super-grateful for that.

On Wed, Nov 05, 2025 at 02:42:18PM +0000, Dave Martin wrote:
> Hi Tony,
> 
> A few drive-by nits from me -- apologies, I hadn't looked at this in a
> while.
> 
> On Wed, Oct 29, 2025 at 09:20:55AM -0700, Tony Luck wrote:
> > resctrl assumes that all monitor events can be displayed as unsigned
> > decimal integers.
> > 
> > Hardware architecture counters may provide some telemetry events with
> > greater precision where the event is not a simple count, but is a
> > measurement of some sort (e.g. Joules for energy consumed).
> > 
> > Add a new argument to resctrl_enable_mon_event() for architecture code
> > to inform the file system that the value for a counter is a fixed-point
> > value with a specific number of binary places.
> > Only allow architecture to use floating point format on events that the
> > file system has marked with mon_evt::is_floating_point.
> > 
> > Display fixed point values with values rounded to an appropriate number
> > of decimal places for the precision of the number of binary places
> > provided. Add one extra decimal place for every three additional binary
> 
> (Is this just informal wording?  If not, it's wrong...)

Informal. It isn't far off from the table. Once out of the small numbers
the number of decimal places does increment after each group of three.

> 
> > places, except for low precision binary values where exact representation
> > is possible:
> > 
> >   1 binary place is 0.0 or 0.5			=> 1 decimal place
> >   2 binary places is 0.0, 0.25, 0.5, 0.75	=> 2 decimal places
> >   3 binary places is 0.0, 0.125, etc.		=> 3 decimal places
> 
> What's the rationale for this special treatment?  I don't see any
> previous discussion (apologies if I missed it).

The strict log10(2) calculations below throw away some precision from
these cases. I thought that was bad.

> > 
> > Signed-off-by: Tony Luck <tony.luck@intel.com>
> > Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
> > ---
> >  include/linux/resctrl.h            |  3 +-
> >  fs/resctrl/internal.h              |  8 +++
> >  arch/x86/kernel/cpu/resctrl/core.c |  6 +--
> >  fs/resctrl/ctrlmondata.c           | 84 ++++++++++++++++++++++++++++++
> >  fs/resctrl/monitor.c               | 10 +++-
> >  5 files changed, 105 insertions(+), 6 deletions(-)
> > 
> > diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> > index 702205505dc9..a7e5a546152d 100644
> > --- a/include/linux/resctrl.h
> > +++ b/include/linux/resctrl.h
> > @@ -409,7 +409,8 @@ u32 resctrl_arch_get_num_closid(struct rdt_resource *r);
> >  u32 resctrl_arch_system_num_rmid_idx(void);
> >  int resctrl_arch_update_domains(struct rdt_resource *r, u32 closid);
> >  
> > -void resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu);
> > +void resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu,
> > +			      unsigned int binary_bits);
> >  
> >  bool resctrl_is_mon_event_enabled(enum resctrl_event_id eventid);
> >  
> > diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
> > index 40b76eaa33d0..f5189b6771a0 100644
> > --- a/fs/resctrl/internal.h
> > +++ b/fs/resctrl/internal.h
> > @@ -62,6 +62,9 @@ static inline struct rdt_fs_context *rdt_fc2context(struct fs_context *fc)
> >   *			Only valid if @evtid is an MBM event.
> >   * @configurable:	true if the event is configurable
> >   * @any_cpu:		true if the event can be read from any CPU
> > + * @is_floating_point:	event values are displayed in floating point format
> 
> Nit: Maybe rebrand this as is_fixed_point, or is_fractional, or similar?
> 
> The print syntax is just a decimal fraction, and the hardware
> representation is fixed-point.  Nothing floats.

You are right. I can change from is_floating_point to is_fixed_point.

> > + * @binary_bits:	number of fixed-point binary bits from architecture,
> > + *			only valid if @is_floating_point is true
> >   * @enabled:		true if the event is enabled
> >   */
> >  struct mon_evt {
> > @@ -71,6 +74,8 @@ struct mon_evt {
> >  	u32			evt_cfg;
> >  	bool			configurable;
> >  	bool			any_cpu;
> > +	bool			is_floating_point;
> > +	unsigned int		binary_bits;
> >  	bool			enabled;
> >  };
> >  
> > @@ -79,6 +84,9 @@ extern struct mon_evt mon_event_all[QOS_NUM_EVENTS];
> >  #define for_each_mon_event(mevt) for (mevt = &mon_event_all[QOS_FIRST_EVENT];	\
> >  				      mevt < &mon_event_all[QOS_NUM_EVENTS]; mevt++)
> >  
> > +/* Limit for mon_evt::binary_bits */
> > +#define MAX_BINARY_BITS	27
> > +
> 
> Could this be up to 30?

Yes.

> (The formatting code relies on the the product of the maximum fraction
> value with 10^decplaces[] not exceeding a u64, so I think 30 bits
> fits?  But this only has to be as large as the largest value required
> by some supported piece of hardware... I didn't go check on that.)

I only have one data point. The Intel telemetry events are using 18
binary places.

> >  /**
> >   * struct mon_data - Monitoring details for each event file.
> >   * @list:            Member of the global @mon_data_kn_priv_list list.
> > diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> > index 78ad493dcc01..c435319552be 100644
> > --- a/arch/x86/kernel/cpu/resctrl/core.c
> > +++ b/arch/x86/kernel/cpu/resctrl/core.c
> > @@ -893,15 +893,15 @@ static __init bool get_rdt_mon_resources(void)
> >  	bool ret = false;
> >  
> >  	if (rdt_cpu_has(X86_FEATURE_CQM_OCCUP_LLC)) {
> > -		resctrl_enable_mon_event(QOS_L3_OCCUP_EVENT_ID, false);
> > +		resctrl_enable_mon_event(QOS_L3_OCCUP_EVENT_ID, false, 0);
> >  		ret = true;
> >  	}
> >  	if (rdt_cpu_has(X86_FEATURE_CQM_MBM_TOTAL)) {
> > -		resctrl_enable_mon_event(QOS_L3_MBM_TOTAL_EVENT_ID, false);
> > +		resctrl_enable_mon_event(QOS_L3_MBM_TOTAL_EVENT_ID, false, 0);
> >  		ret = true;
> >  	}
> >  	if (rdt_cpu_has(X86_FEATURE_CQM_MBM_LOCAL)) {
> > -		resctrl_enable_mon_event(QOS_L3_MBM_LOCAL_EVENT_ID, false);
> > +		resctrl_enable_mon_event(QOS_L3_MBM_LOCAL_EVENT_ID, false, 0);
> >  		ret = true;
> >  	}
> >  	if (rdt_cpu_has(X86_FEATURE_ABMC))
> > diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
> > index 883be6f0810f..290a959776de 100644
> > --- a/fs/resctrl/ctrlmondata.c
> > +++ b/fs/resctrl/ctrlmondata.c
> > @@ -17,6 +17,7 @@
> >  
> >  #include <linux/cpu.h>
> >  #include <linux/kernfs.h>
> > +#include <linux/math.h>
> >  #include <linux/seq_file.h>
> >  #include <linux/slab.h>
> >  #include <linux/tick.h>
> > @@ -597,6 +598,87 @@ void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
> >  		resctrl_arch_mon_ctx_free(r, evt->evtid, rr->arch_mon_ctx);
> >  }
> >  
> > +/*
> > + * Decimal place precision to use for each number of fixed-point
> > + * binary bits.
> > + */
> > +static unsigned int decplaces[MAX_BINARY_BITS + 1] = {
> 
> ^ const

OK

> 
> Also, maybe explicitly initialise
> 
> 	[0]  =	1,

OK (though this might only occur if there is an event that resctrl says
must be fixed point, with a h/w implementation that provides a simple
integer).

> here?  (See print_event_value().)
> 		
> > +	[1]  =  1,
> > +	[2]  =  2,
> > +	[3]  =  3,
> > +	[4]  =  3,
> > +	[5]  =  3,
> > +	[6]  =  3,
> > +	[7]  =  3,
> > +	[8]  =  3,
> > +	[9]  =  3,
> > +	[10] =  4,
> 
> Why these specific values?

For 1, 2, 3 binary bits you get an exact decimal representation
with 1, 2, 3 decimal places. I kept the "3" going from 4 to 9
bits because it should output at least as many places as 3 bits.

After that I started stepping every 3 extra bits.

> ceil(binary_bits * log10(2)) makes sense if we want to expose all
> available hardware precision with as few digits as possible.
> 
> floor(binary_bits * log10(2)) makes sense if we want expose as many
> digits as possible without advertising spurious precision.
> 
> Disregarding the special-casing for binary_bits <= 3, still neither
> option quite seems to match this list.

Side-by-side comparion:

#include <stdio.h>
#include <math.h>

static unsigned int tony[] = {
	[0]  =  0, [1]  =  1, [2]  =  2, [3]  =  3, [4]  =  3, [5]  =  3,
	[6]  =  3, [7]  =  3, [8]  =  3, [9]  =  3, [10] =  4, [11] =  4,
	[12] =  4, [13] =  5, [14] =  5, [15] =  5, [16] =  6, [17] =  6,
	[18] =  6, [19] =  7, [20] =  7, [21] =  7, [22] =  8, [23] =  8,
	[24] =  8, [25] =  9, [26] =  9, [27] =  9
};

int main(void)
{
	int binary_bits;
	double log10_2 = log10(2.0);

	printf("bits:\tceil\tfloor\ttony\n");
	for (binary_bits = 0; binary_bits < 28; binary_bits++)
		printf("%d:\t%d\t%d\t%d\n",
			binary_bits,
			(int)ceil(binary_bits * log10_2),
			(int)floor(binary_bits * log10_2),
			tony[binary_bits]);

	return 0;
}

bits:	ceil	floor	tony
0:	0	0	0
1:	1	0	1
2:	1	0	2
3:	1	0	3
4:	2	1	3
5:	2	1	3
6:	2	1	3
7:	3	2	3
8:	3	2	3
9:	3	2	3
10:	4	3	4
11:	4	3	4
12:	4	3	4
13:	4	3	5
14:	5	4	5
15:	5	4	5
16:	5	4	6
17:	6	5	6
18:	6	5	6
19:	6	5	7
20:	7	6	7
21:	7	6	7
22:	7	6	8
23:	7	6	8
24:	8	7	8
25:	8	7	9
26:	8	7	9
27:	9	8	9

I'm not a fan of the "floor" option. Looks like it loses precision.  Terrible for
1-3 binary bits. Also not what I'd like for the bits==18 case that I currently
care about.

"ceil" is good for bits > 6. Almost matches my numbers (except I jump
to one more decimal place one binary bit earlier).

What do you think of me swapping out the values from 7 upwards for the
ceil values and documenting that 0..6 are hand-picked, but 7 and up are
ceil(binary_bits * log10_2)?

> 
> Rounding up means that the hardware value can be reconstructed, but
> only if userspace knows the value of binary_bits.  Should that be
> exposed?

I'm not sure I see when users would need to reconstruct the h/w value.
General use case for these resctrl events is: read1, sleepN, read2 &
compute rate = (read2 - read1) / N

In the case of the Intel telemetry events there is some jitter around
the timing of the reads (since events may only be updated every 2ms).
So the error bars get big if "N" is small. Which all leads me to believe
that a "good enough" approach to representing the event values will
be close enough for all use cases.
> 
> > +	[11] =  4,
> > +	[12] =  4,
> > +	[13] =  5,
> > +	[14] =  5,
> > +	[15] =  5,
> > +	[16] =  6,
> > +	[17] =  6,
> > +	[18] =  6,
> > +	[19] =  7,
> > +	[20] =  7,
> > +	[21] =  7,
> > +	[22] =  8,
> > +	[23] =  8,
> > +	[24] =  8,
> > +	[25] =  9,
> > +	[26] =  9,
> > +	[27] =  9
> 
> Documenting the rule for generating these may be a good idea unless we
> are sure that no more entries will never be added.

Above proposal - use the ceil function for bits >= 7.

> > +};
> > +
> > +static void print_event_value(struct seq_file *m, unsigned int binary_bits, u64 val)
> > +{
> > +	unsigned long long frac;
> > +	char buf[10];
> 
> In place of the magic number 10, how about
> decplaces[MAX_BINARY_BITS] + 1 ?
> 
> (I think the compiler should accept that as an initialiser if the array
> is const.)

If the compiler doesn't barf, then OK.

> > +
> > +	if (!binary_bits) {
> > +		seq_printf(m, "%llu.0\n", val);
> > +		return;
> > +	}
> 
> Can an initialiser for decplaces[0] reduce the special-casing for
> binary_bits == 0?

I'll check and see.

> > +
> > +	/* Mask off the integer part of the fixed-point value. */
> > +	frac = val & GENMASK_ULL(binary_bits, 0);
> 
> Should this be GENMASK_ULL(binary_bits - 1, 0)?

Oops. I think you are right.

> Should we be telling userspace the binary_bits value?  It is not
> (exactly) deducible from the number of decimal places printed.

I could add another info file for fixed_point events to display this.
But I'm not convinced that it would result in users doing anything
different.

Assume you just did the "read1, sleepN, read2" and got values of
235.617542 and 338.964815, tell me how things would be different
if an info file said that binary_bits was 17 vs. 19?

> It depends on the use cases and what the code is trying to achieve, but
> this does not seem to be described in detail, unless I've missed it
> somewhere.
> 
> > +
> > +	/*
> > +	 * Multiply by 10^{desired decimal places}. The integer part of
> > +	 * the fixed point value is now almost what is needed.
> > +	 */
> > +	frac *= int_pow(10ull, decplaces[binary_bits]);
> > +
> > +	/*
> > +	 * Round to nearest by adding a value that would be a "1" in the
> > +	 * binary_bits + 1 place.  Integer part of fixed point value is
> > +	 * now the needed value.
> > +	 */
> > +	frac += 1ull << (binary_bits - 1);
> > +
> > +	/*
> > +	 * Extract the integer part of the value. This is the decimal
> > +	 * representation of the original fixed-point fractional value.
> > +	 */
> > +	frac >>= binary_bits;
> > +
> > +	/*
> > +	 * "frac" is now in the range [0 .. 10^decplaces).  I.e. string
> > +	 * representation will fit into chosen number of decimal places.
> > +	 */
> > +	snprintf(buf, sizeof(buf), "%0*llu", decplaces[binary_bits], frac);
> > +
> > +	/* Trim trailing zeroes */
> 
> Why?

It felt good. I'm not wedded to this. Maybe saving a few cycles of
kernel CPU time by dropping this would be good.

> Would it be better to present the values with consistent precision?

Humans might notice the difference. Apps reading the file aren't going
to care.

> There's no reason why a telemetry counter should settle for any length
> of time at a tidy value, so the precision represented by the trailing
> zeros is always significant.

But x1 = atof("1.5") and x2 = atof("1.500000") ... can the subsequent
use of x1 tell that there was less precision that x2?
> 
> The hardware precision doesn't go up and down depending on the precise
> value of the counter...
> 
> > +	for (int i = decplaces[binary_bits] - 1; i > 0; i--) {
> > +		if (buf[i] != '0')
> > +			break;
> > +		buf[i] = '\0';
> > +	}
> > +	seq_printf(m, "%llu.%s\n", val >> binary_bits, buf);
> > +}
> > +
> 
> [...]
> 
> Cheers
> ---Dave

-Tony
