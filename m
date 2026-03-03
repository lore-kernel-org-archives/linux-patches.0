Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E72F238643D
	for <patches@lists.linux.dev>; Tue,  3 Mar 2026 19:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772567671; cv=fail; b=rloiluhM8czDbtO8gJi9ROAOJBy33G0bH+DY2lsxPR+xCoaTChpsZYh4onQp/wIT83DWkgr64L7cH1PqP72iQ2a/DA9zL2udje30wcP+SZVYaZ4VO79Zrbkuj3HTVYFHCH4G+WY96otzGrf3Nhk+FydlefGJz4Z4ME7CxQj5KRE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772567671; c=relaxed/simple;
	bh=ybQA0UTDqsjGJTPMMpE/BfFJJicuMCkvwi3j7TKXYf8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=b9wZhX/s8SM89PNmJBuPCeBnJP7aoc1Emj8tjgU/v3nlXX9ReOsC7XNQZda9fs5ob0mQmmRiQ0sB5k6qAwt0g2RZhQ+/uQc64md3XLSDyUTt3mERwWGON7CcMmL4bfc2YiW1DuNIkLk2rD+y0yWPGCnTD2+yFIRQnxiM648Yh6k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=G45SiyK3; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G45SiyK3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772567669; x=1804103669;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ybQA0UTDqsjGJTPMMpE/BfFJJicuMCkvwi3j7TKXYf8=;
  b=G45SiyK36m+mj8sBqAkd0Kq4XwemeYvnrCLyrKv17eONfJF3YT4aLyQx
   TGHEN4CyRmwvnARVYmZGydN6XCnEfhmZdepTP8ucDYRswRFgOLy0qou5N
   RpehRnUm1RnAHU2zKCd+2uXqrjxkDQET04zqx4P+uYr5N9n9A3Hz8IcQq
   QIwhgE4P+TbHKNU26sIqbK/hGm4f31SXhspPORvyluOhtE3EK+FpgiMSG
   0hobzhaDtxJ5SVslOK/OYgxLeyasfpsZ2jk9r4oJX+HunIUwL3EUBQWMQ
   98bj/krX5p/+k3WuOxIHsUVt7+cm2FDmno6doPekiqpSUTyGkW2/B9/jU
   g==;
X-CSE-ConnectionGUID: sgbpdB/VRO2wyPA36wQf9w==
X-CSE-MsgGUID: WASDiJxxSW6h3n7PO0Ox5w==
X-IronPort-AV: E=McAfee;i="6800,10657,11718"; a="84255100"
X-IronPort-AV: E=Sophos;i="6.21,322,1763452800"; 
   d="scan'208";a="84255100"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2026 11:54:28 -0800
X-CSE-ConnectionGUID: sAcg/queSMqnYpLNNIlhGg==
X-CSE-MsgGUID: fRICBVKtSdKyFL3vgV/A+Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,322,1763452800"; 
   d="scan'208";a="218229201"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2026 11:54:27 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 3 Mar 2026 11:54:26 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 3 Mar 2026 11:54:26 -0800
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.46) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 3 Mar 2026 11:54:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iZqTPKWf4ZdzNMr1W9xHqP1vjXFT1aJckm0foT7z42MUFoNJjaLN6XRT4Ul8jsa9ttai52o0N++M/VimxrchEApnVWwBb24EQKz4JssLf5maME66jcKxGTVX4ug4lwp5Tqz8D1+9jCdoMa/spehNKxhjIcO3LvJei4rc8OZEHVGlBWGBRfB35lRFM15Hqw+lJth/783KbqoUkPhQPs1pCsnnVJCpCEp0tMpUx2+uFbMPnRUhRRbBLDgxAB0QSLDUYf1WWAVW2vvMIIxdf6sLT7wUO8zj1Iz+FOJ3TlAAS+xk0/TKt4Pnc/8FJzzHWROh81KlGDUA+ub5YWAHm+wcyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QhxhNaYDsukDe6E7k+kLoFQaEMI8l8qf9KtVOEchu04=;
 b=ZaD+DMSTYs+Jle+hDmZuVRpq47kD6KjVp1rKGwN7Nr/io9tkFqn1NNWpSmYm8ZrhUPnbFTcN5z9T6oAmj8bndQZW3qY9Ri6K4eKJdyU+tbrQkyE5DcqazBozjGaqX9MdD43SP7lfCIxgkMXMuXCRTW74iTvwY17jeZuJMC/JAgPz65DYUMbTdPD136PWo0mI+ml7NhHMycBuOeSdKw57rZH67QO/Tp5ben81RyCoQxsWgKuEJKNDSwaEMl2bywNMCIN20KUPpwqfsmlN4tEaAHOnl4bgItF8KrB+31kOWSnWLup3MqB0vaLjNKfyEutA5sHpBr0l6tLWwZLPvVTPzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by IA1PR11MB6395.namprd11.prod.outlook.com (2603:10b6:208:3ac::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Tue, 3 Mar
 2026 19:54:24 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%7]) with mapi id 15.20.9654.022; Tue, 3 Mar 2026
 19:54:24 +0000
Date: Tue, 3 Mar 2026 11:54:21 -0800
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: <james.morse@arm.com>, <Dave.Martin@arm.com>, <babu.moger@amd.com>,
	<bp@alien8.de>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <ben.horgan@arm.com>,
	<fustini@kernel.org>, <fenghuay@nvidia.com>, <peternewman@google.com>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: Re: [PATCH 05/11] fs/resctrl: Use accurate type for rdt_resource::rid
Message-ID: <aac8baGgAWgpWSH2@agluck-desk3>
References: <cover.1772476561.git.reinette.chatre@intel.com>
 <956a7f8c9ff85b873ec85159a66d5e3c8b468d70.1772476561.git.reinette.chatre@intel.com>
 <aacmf_CM52gHRMot@agluck-desk3>
 <a3343e9b-e481-4282-a775-651a516164a1@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <a3343e9b-e481-4282-a775-651a516164a1@intel.com>
X-ClientProxiedBy: BYAPR02CA0041.namprd02.prod.outlook.com
 (2603:10b6:a03:54::18) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|IA1PR11MB6395:EE_
X-MS-Office365-Filtering-Correlation-Id: 61adc984-6f1e-4925-ea76-08de795eaabb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: 2wmZ3f4UrHH74DFXVo+WF9vU4rNTH8kJENRd6kJpIEtnQMVvTNjcn6AJ4oo1SzEWOzjIBWGIPAzm251dqoJe5lDMgBcT3SeLDwGnceluh7QSf/1j1C1o9fqJAJ1At6UEq49VG31jEvFqJrxUibzlwCORRlcrGoSEIrCUSS/N+AG1nHAJAv12h308VTEgjipiIKvDvqEjHn+WKUZLWmDZc6Ah8apCJ3jldFWiq5zSsGUPiXdZHhlhLpL8ovHRXmWLGUeEK1RKY10/BYDshNE4rvnp3nfilV71nefH1dsWqT9aYb3vWQZUn9bbopuj9nFA6FDq9IFmNixHTNXyQ4xJdWg90rc+cbQ76oJa7x7JbD0Zf+FvAjqVwp7Xfd5mFL6yYD46PPOhBOCbBhdorTAchtMBzSRyfK/WsnNS1cOlomSbaCt4hW1IJ6swYcEUZx/y+xZCoegUHFAf/GXqSGkIPpouGv9aDY19HX9SQq49yEZcqvT7cM8TeXSq1/sE24z37Dh9svC2hawR9uxCQF0o/nmHMOSy9pxsmP54r/lSBLEK4zP7W7Ki/e45376UzATfyyjbf9mlJbL3bMDKBkVnzCVtWAjI6vQXn9F7iYaLuXSRb9/dYAsuqoSH6J+VhAqsW9e9sLc0vblPoJNZsoajVc90MVXV8VqlglndYOguOs8BN5IgRLTW90fd9lUZ/3+FVjf2LaykRQ/26jRjxN9ZZB8hDhMc8ONM1JlYmf1u++8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bMa+sJTrvZfH31d/wrLSMzgYT/EO0YZkNvMFNvb/DcmR/VLHloCshU4SeWZ9?=
 =?us-ascii?Q?lprnp6PF+JIQn1djeQ0FFzSqG59RZSWso9epxILljtq+XqhKNAdpjQUKq86B?=
 =?us-ascii?Q?z9nlFOPneYerpzKQx/NA6DEhyowwm+atZk0O9ziQEG42WzbBQBhCRIrlG7e9?=
 =?us-ascii?Q?qUnpOZjuZfwjUu4pgT6Ntuw6TL05qy8I9qOpY7Qg4Ki1NNu0LRy4KK4mvk9m?=
 =?us-ascii?Q?ATeCYWvZy7zpc3xaD9FXgauGfzI4Iqo8tzRHSvEl8F+HTMK/fE5vrPXDpW/j?=
 =?us-ascii?Q?b4mdwL4qRprXx4BELzsG8TV2V+m2B+mjBfdlgV2geMR4ZpMSN5mxoLbFRiuF?=
 =?us-ascii?Q?r9XlAt1gGElVHZ9CjRGG5zROWBVCNz5DUcr0DKs/G3CXSg0mYm+VF8MRkCEW?=
 =?us-ascii?Q?LXgNDmnGXnvzKh38aeWhcS6VWiNxJ53b/mafd/mWNIWFutQT5m8c3vNnxGCs?=
 =?us-ascii?Q?NjjaSMHG6pwUc4BqLpKwjh7LWVfffQfUbGwhEMZR/BdVDrN/oWGG+BxWjYFg?=
 =?us-ascii?Q?/A7mjMuY9WloIsudvE5lX1T8Gq6w54VJDlL/dKGqnY9nG7i2dVEJwWAitxhx?=
 =?us-ascii?Q?fd4psb7Sa86wK4O6aiXwmcrqiDJ7BfxvYcQ+fVbi4XnKhOvg1LLyNboxOmvT?=
 =?us-ascii?Q?o6j/O73tasZX3X7+F7aD8q1KFVn9h/EkMew17ZHGf7+6ZFZL7tnRPzL49oT2?=
 =?us-ascii?Q?VogJvqM8T1vhUGUUYmvPX3XQ0gf7ZeqUsp1dvfVERcyanuEnPmLl3mQOY79E?=
 =?us-ascii?Q?6Kk7Sq8EBbNrZGFBxGJhc6YBjZJ3k0o7IGal0D6uhRm727Lu7H545aeX6/ib?=
 =?us-ascii?Q?SjzD87rNzgaQeJRsWxNxkY4yK3foo83a9cY+SEhLRumaA0/qXmWA1vqxNtV0?=
 =?us-ascii?Q?7lc5Hraf+HfA28Lru3RnzEAvVtgsEXqgqsO3hGu8ky/FQcoef1H4Ci9kuOxR?=
 =?us-ascii?Q?G3wGL63GBTL3B7rInBpymDDkd0ErNU+O/xWoDyDYySFDn7i1k46ZDDllva/Z?=
 =?us-ascii?Q?Y2StZlq1vV+DLGt4gxbJFHfE/013I+yX2ZsdLqzor6CQRkMngQElTGT9RrEg?=
 =?us-ascii?Q?NIHw8PJHiQ5wSvJsA0KyznqSqgedWhx1akivnKoQxxXsUD3W4waF4JLl8HW0?=
 =?us-ascii?Q?qKhNdj1Kw6eSJyRi1kMmcF+17F8uclKsl/94YWmyqxDIu7Yd+VpWA2pc/F1X?=
 =?us-ascii?Q?hDggFA4/irkMI8CUwhbBxEyIqJ/uJDy8bCg4xjjj95f/7yPbF4gH/IS18ngW?=
 =?us-ascii?Q?6hegevHSZiROiZeePpRTzhxvYDus9HOdV7RuYnhytJozBe78T4cknoJujhE+?=
 =?us-ascii?Q?4Q0UpipdVf1FwtRwwHvkpDt6DXFWHLH3jWXw9RjXji+spT/MlmT32dUI+KmZ?=
 =?us-ascii?Q?BVjCiFMNWEJZXEvtD+C1TnaPgS7d+azp1GKxfWSAzm4arwiBHguKN5gqRohZ?=
 =?us-ascii?Q?bxG+PAAw7PvNAiH61hEsSS2DXvWXNXPzpc2HVfetm1bi9h8o5Prkq16FNdcX?=
 =?us-ascii?Q?JE+fDfv/FORndiihYM7lj3vuV7Z3WT7g2Gu3p7Vd/DsyeSv7Nwhk/NWY0P9g?=
 =?us-ascii?Q?5qL87HvS/PidrjWX6s6iic64gP/F1Q81bw5VYZ33ARgwSv9iVluV+p5cSqsp?=
 =?us-ascii?Q?Rz0eAfMoBqAzcM6UzWX0Mt8SPE5oo7TWVF4BnAmiXU0qrnAzFCguL9aPcIjM?=
 =?us-ascii?Q?Zt9gb639ZW8oU8l7sjGGYDC+mKY2DkC4UjVh74lIyWAQXLJvtxiPXDlXs/FZ?=
 =?us-ascii?Q?FhsefnHr+Q=3D=3D?=
X-Exchange-RoutingPolicyChecked: RFRG7FhhEJjXjm+tGtUUNhwyKb1dr5c9t1lMEowHqWCRlPwaMuRo698B1ni2/r5ybkvEujCraY9yB6svE47wjx3oMRhAZA9BZvDpq+doUSxYW/Q95vNsA+Ks8WYX86nOOoEmw96fEKnHxb0YFu07YuieNknjriK1BZ8a28PFWW+0dDounFw16FAasym9dhVuJusqxx8UEhzHxPqXexWo3HlPB6ZwIV9Uj2nvRmNx4Mplr2vAVWN0X1I4KbZXxV1P5mBliu0LDUFpiT8R4VTFPzuRi+HeaNS7ECDKOgvqEFG5iyRCFywOvBMf6RYXU7YYJKPANlpBmdVsMDfVetUDCQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 61adc984-6f1e-4925-ea76-08de795eaabb
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2026 19:54:24.3292
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AkcJHo9Ckz2Hbjtbioq2fB2n+mvrhSCKvbFjztaGTE+8dRdbSZYscEAtTBKgpskRQ3jjZYFXiRV5RdQI301Nqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6395
X-OriginatorOrg: intel.com

On Tue, Mar 03, 2026 at 11:06:52AM -0800, Reinette Chatre wrote:
> Hi Tony,
> > +int rdt_num_resources = ARRAY_SIZE(rdt_resources_all);
> > +
> 
> ... and this proposes to let the *architecture* initialize how many
> resources resctrl fs supports?

Not exactly. The file system is free to support as many resources as
it wants to.

The architecture just provides the largest value that will provide
any useful result from resctrl_arch_get_resource() so that this filesystem macro
works without redundant iterations for unimplemented resources at the high
end of the enum range:

/* Walk all possible resources, with variants for only controls or monitors. */
#define for_each_rdt_resource(_r)						\
	for ((_r) = resctrl_arch_get_resource(0);				\
	     (_r) && (_r)->rid < rdt_num_resources;				\
	     (_r) = resctrl_arch_get_resource((_r)->rid + 1))

> 
> This implies that all architectures need to initialize this on behalf of
> resctrl fs. resctrl fs does not force an architecture to use an array nor does
> it require an architecture to support all resources. What if an architecture
> decides to not use an array and does not support all the resources resctrl fs
> supports? How should it initialize rdt_num_resources?

Yes. Each architecture would have to provide a value. Each architecture
must support the resctrl_arch_get_resource(enum resctrl_res_level l)
function. Regardless of whether this is backed up with an array of
resources, a list, or some other exotic structure this function must
return a valid "struct rdt_resource *" pointer that can be dereferenced
for all values [0 ... RDT_NUM_RESOURCES).

Allowing the architecture to define the upper limit of supported resource
numbers doesn't constrain the file system.

> I see the number of resources supported by resctrl fs as a resctrl fs property,
> not something it should depend on the architecture to initialize.

Having resctrl fs define the number means that an architecture that uses
an array must pad out that array.

-Tony
