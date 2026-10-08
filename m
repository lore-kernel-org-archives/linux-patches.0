Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AEC3389458
	for <patches@lists.linux.dev>; Thu,  8 Oct 2026 16:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791475941; cv=fail; b=tonlL/Xu7fLBu7d5VyUaG3OlaNPgDPu2I0NAp7DZtpunOBkv646sA83bxMB1/zUu/6LLimQE5EACdNT1vwT954VMGojUQ+ljq4ZhQkaghsjumxjSfxsO3w5yGTjkCiXPX9bMcxRRuNc8Z0N7d4xKZfVWhmZ6WRP2uoG78VNYVvs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791475941; c=relaxed/simple;
	bh=gyjaq8CLaM/EyUDOIAnO2+odi8pWTqLSkzoJtKs7MWs=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ltNhwedRwLeWprzgvg93BD2HEaxvKNSaQFWpMHne1Mb0P9KWU7Dts6FLGceSzt0H7R60OT9NszRDbkpp798AMyuPfbg252H+KW8Z6HlV0pBDYiVHkHbS8qT9HabafJkeK2LDnkVrnMDE7uw+DDZJU//6ngR5bj4zYlorLqa7kYs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ASVdzLDc; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ASVdzLDc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791475940; x=1823011940;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=gyjaq8CLaM/EyUDOIAnO2+odi8pWTqLSkzoJtKs7MWs=;
  b=ASVdzLDcw2FvgBhvdi2vXPYpE3uLglIpNhNV6EVq01fW3K2u/38MA1Dn
   7bDw902/WX0Fsm9Rd/ZkGX6roeYDU2jl/eX91eQO3ZVKcnEXMfZ8rwYkY
   N9ElUolPgTDpsufHbp6n6yrVGQx7pXr95R3dO/JoZQxcpgkd8XbWBxpnz
   48L5A3ftAQe4DWJYthe4c6s5IGfMYy+8HYUGQVT2fjaaTty26Ose40xAP
   0VZxyOHhhXICj9wF7EfScNvROE8rUZ5TgsjupMIT+sZYcEa+W/+Xu3oLb
   0tspNvslDGPGS2xSyVg5vnR/XbyXHRozZ6qRJbSbHabrIETgm7Sn8c+/r
   w==;
X-CSE-ConnectionGUID: 186+9RfySxmr8joo3rtdgQ==
X-CSE-MsgGUID: oNiwQYmwRGStef4hFmlOnA==
X-IronPort-AV: E=McAfee;i="6800,10657,11928"; a="153372"
X-IronPort-AV: E=Sophos;i="6.27,146,1787036400"; 
   d="scan'208";a="153372"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2026 09:12:19 -0700
X-CSE-ConnectionGUID: POKydOCfS7GZkf1fIeO2yw==
X-CSE-MsgGUID: oSQS29gRS0iWRmXThcw+qQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,146,1787036400"; 
   d="scan'208";a="525425"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2026 09:12:12 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 8 Oct 2026 09:12:11 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Thu, 8 Oct 2026 09:12:11 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.24) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 8 Oct 2026 09:12:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HJMfeAPaTpRpx4AeSGsrbyjvWyBZ8aJtNHlbZ2ax5SViI2aHfbDtXZdxUihZkwFs5LmNqol+bUqM/+/b5Y7mqTrFxHmrhGONKFSSSqAvRfv77QMpDh/m9uViDN69xNvY8z1eoBoJB5nhQQiuT862yscJsuahUFwecs/ZnQchzRbZ7TqD68S29GOs44u32KIMB5p+lZMKSCpVQrhuyRAYILiwQUFuk2doU6Nw8WrWO5DqC+2mNTQHJS2n1pKDWXs+taY16ZMPr1KotILpOqh/CkzRHl7sgnr09GIJdiL9c1bsXLheQU/stAvbScb2StMbQMkowqVPjUDJbM3fXjbVRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LZzjvPgi5gx4TDhOSfj2gBRXRJJU1BrIYd0gnoZ+Pmg=;
 b=qy/LcSlu0bOG0VQzzMBymefCaVUAP+mhUSqrKtoZRXx/mQqXYxRl+HhTAKhMrnY54vRPDqxSWqcdF9BGfYMAyjV/icqCrsmd4kEhpARrNxqrxUcLQLqDS6NlByrMk8yFHS1cA+PTWCuVV5k4BG4c4e/ZfNJ9LsEhCFzrRfTY08AsLeWIy4A+92IqqD8y00PI2UJNjOhT+8Yw9FD1d7LQcHjba4wJzHShIDQYvFbwCfhwRR0weh+KX6k8z6p2ylLhHWUNJEFatZHBCz37xr+1ZjXFCX3gwA6tqbAPxiT0oaiY/kwRlG9sKLMMHBx+ZL1PYe7D9rGAX5odPZhJjJGIJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by SA1PR11MB6783.namprd11.prod.outlook.com (2603:10b6:806:25f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.17; Thu, 8 Oct
 2026 16:12:06 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%4]) with mapi id 15.21.0496.010; Thu, 8 Oct 2026
 16:12:06 +0000
Date: Thu, 8 Oct 2026 09:12:04 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: <ben.horgan@arm.com>, <james.morse@arm.com>, <Dave.Martin@arm.com>,
	<babu.moger@amd.com>, <bp@alien8.de>, <tglx@linutronix.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<fustini@kernel.org>, <fenghuay@nvidia.com>, <peternewman@google.com>,
	<yu.c.chen@intel.com>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v2 0/5] x86,fs/resctrl: Cleanups in preparation for
 multiple controls support
Message-ID: <asfA1E-lBs5aRItb@agluck-desk3>
References: <cover.1791406459.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1791406459.git.reinette.chatre@intel.com>
X-ClientProxiedBy: SJ2PR07CA0020.namprd07.prod.outlook.com
 (2603:10b6:a03:505::19) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|SA1PR11MB6783:EE_
X-MS-Office365-Filtering-Correlation-Id: 14536d51-dfdc-439e-7aa9-08df2556e58a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|23010399003|366016|1800799024|56012099006|11063799006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: W5B1cj3Bb6E7Q1O3VqaRSImPz2ZPLt3Rax1mr0EKx8k75eeeJbP0TPNk4BJ+da4WzqhpaflfUXBFuYGlZoU1mOTkksHPWY+JXzuSMNSnfK37ehCnI+uKytKEx1IVBYhzT/kQPAMLr7gf0HRnj9gi13Bamyx8/JGN0alk9db8l320Yr29hYZDqrd0POq6+EMOQuYGvKU4prh9LZlZTEl1xMWj3DIpISJ6oF/HlFB+J9ygELAsDpYNwv1lP4IYsflyGj8Fh7SP0OGJCl2QXPmbJIH1oVMFrsscf3brrANfVVv/zL6hbFYD6LCRh5+wajnIXCCdbe2ECxq6RDV21ytjKaEctgkSEfhubkcUrkwkNHTLamaTpC08ttxMzFIIPJth+r8BNhXz2TwmuYasDM9qw1I7brWlBKv9COQPxyietI42O+d9RM67sRsZaviTxRoinB+qF5RjwuxM6vr+8lvHj9HtopDuLdseuDGVLNL5uJrFwrNnV1jPSfDOAfeLA0c4vR9i+26MeeYhkAkp41uyeQr/YactRf2S/qpHTwFFaAweolUKNVllfsFYMSr485E+b3+gV2d13hVuBS9iSAbs41eNeJBVHs7kpGmZhWOI8onsopnkZUKEwLjMi47JXCXF9MbBOZr3k0jSeU0WB3NU6FCk2KpOiL8MLS4zRs7TGgU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(366016)(1800799024)(56012099006)(11063799006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oUbUq2xEzDrZfuoOrvK/I28Lqky+NbKQFR511QyWCloV+o7ChEmBUej8d+X1?=
 =?us-ascii?Q?DdIswtAQeZqJXYbUUbzNhqy5/ZGA/UMxbEsYxXMJiM3L4AQ0/5aobX20HqMO?=
 =?us-ascii?Q?pcJWmwGB34HkffRb2ajZhJkAJa/IuEJPWNteQEZXi62CCHukeR2U5u+I1f1h?=
 =?us-ascii?Q?sqGjn3Hd+UOf8CBQLQmj2Pk1G6oNwFyOpsoa0WQAOzfIi+uMrnVbL5G18rGM?=
 =?us-ascii?Q?WpJQ/O2GapsbpqOsG3cstz7IODWb+iWl0sh13HJJNSte5wQts6bTTe0gDoaX?=
 =?us-ascii?Q?iLuJT/XQgEbb3kxxEFpfHcVJ376SEaic5fMJFNNqSoT60dzdiBp9pq33CG60?=
 =?us-ascii?Q?Ba1mijendXblz47jitA35nlIqZa1/ttaADu/qlEhVZLYm969/HWcFzrGBLAl?=
 =?us-ascii?Q?HozMlt/eHQKP8boDE9hAwstT/3W+ds3dD92L+eYtCgH3lUtjUnlKceJRoGse?=
 =?us-ascii?Q?GvnxyU/6MWSZra2ctiqqAIMgF5ByfPMY96ckrUV9PMVzCQYmL9HGElWCOcij?=
 =?us-ascii?Q?sejr89/61oZVp3LhxKACWgvYaf5kHHzkYeKdOlLFrFF1aHzDy7bsR4/qv0il?=
 =?us-ascii?Q?GQ/dwKy2+Jk5QLKJfrVbL9U3SUbF8nKlu3zVhMJRFN9W/VEUVTuxycLrju9b?=
 =?us-ascii?Q?+sJEwa8f/dpn3bHbr2U5Yl+/jVWVJZj/brGp0Fpatl3syaMC3+u7vYMroUkT?=
 =?us-ascii?Q?6MF030/3Gl4C6THTcVPl33BHXVu49EMbuJZti8cFg+ibT8wdUXj/ocwisUT9?=
 =?us-ascii?Q?8dRwhWtAWl/AlTWnzUGj/oBQpNcn6Nrh1yDNOKM9devBisIgZVKK6o3JlVxO?=
 =?us-ascii?Q?p4pFwyu4pzpc5PPtRyR1bcp4nkofdS5oo5cTCZkHp+VbKydO/4IQyzsgBvkq?=
 =?us-ascii?Q?1dRrT5hQVF/LP5X/N3mGQbPM3Ekn105LfEHmkgacAiLwiJjM1mIJYJcOZWSQ?=
 =?us-ascii?Q?cz4jfCNbYD3ROGZZ16i2BdkKbkmNQZ85Ozm0+Z4o3VMpCYERdaJbiiA6FeYY?=
 =?us-ascii?Q?ghit60iZJ5BRQ9cusnyGF5h++6RITizcOIiRcddcgD+a/tlbeCwYTwud7d/R?=
 =?us-ascii?Q?I3A0ykfH+HEmh6Zjrwl+KZJw39YO0pdLuQ9na903DgYgwF9hpfktymHHKt45?=
 =?us-ascii?Q?i9s1GRdRTEVMK8b6EXkHWnXRPUJhPAtIENaRCtW/X3niDGxXPO9dA6+dRRNM?=
 =?us-ascii?Q?0jXXgc2xepUKmDkiUkQ6VvH13WNwSXxcb+SvLVlCaZZgEzexIIR9GlUiNtRn?=
 =?us-ascii?Q?dmfJptFMxtUwfMte53042+sZolbFk3cuMwTgEJEqjGpx0+r8TuTharH1DEGF?=
 =?us-ascii?Q?/bZTMTWgyHX3XmMOFZrV5lBHM/9UT4K4OWN/HzI7eIv1ya5zuWFcHmHcCJOt?=
 =?us-ascii?Q?Dt1U4Eu3VDPSfLClvlCezTH9bB3FVcXr7ruo7IMH15DbzprYyV0Ouy5kCO2N?=
 =?us-ascii?Q?olXi6ax3zffZ2RSg82IkX2rlEl/nG5h0tXZueZP0haLRUPvhDhP85ULX/vPf?=
 =?us-ascii?Q?vIQ45DNMOa2adUInr6es/uAxc4Py0LWoytqD9I6KQqaqIKxPMC+VazXwiY63?=
 =?us-ascii?Q?mUzI+yHmY4hPHXoNP9/8nvTgoQDCJgoGlO54ONqhP5nOKWbeHMKwugyvq+Ux?=
 =?us-ascii?Q?utIGTqw5GK0p4u9VNwzQBz2YGU8dKmmpW7z0CyCozwkUrm4YA0gCzHBPSoBP?=
 =?us-ascii?Q?OPJdE97bU2fchHnrYzM+pzE3GBlfA19/BkNemXSMcfsV8zGQPVgjs1WMIN+a?=
 =?us-ascii?Q?+fxq2xLGQw=3D=3D?=
X-Exchange-RoutingPolicyChecked: vGn21HGt5TpjELVQIYNI7NaORZECOZW8aAO3DYoHuyFhk0pkvPy8ZewZxrn5W7SM1sSWZBosjYMVRm+DbBjK6ZvMwxEf2XHRzvnwHVSB7yLlMsv61en0vP+VEDtX+6M3KzEDP2lD0r9k8mVIsmJ/xR2E2d5QOKTie86/ej3rL7ZbIL4w55rldloj0HXwNDWJjOGCLPRxDGzSye+oMM0YKKgJk+tbHyDUSLWpK6XaXgHKSyM49sdYkFdtJg3IOktU59ESKXQfNjQZHhebjaIrJUF94wfVqu8/XqnpqsNHzB2NrBuIDNrqZzUKvKOJ7KkfFm+/MQ1qVyH0N/PDpzxU1w==
X-MS-Exchange-CrossTenant-Network-Message-Id: 14536d51-dfdc-439e-7aa9-08df2556e58a
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2026 16:12:05.9853
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4+k1sxbwG/f+KQ/4ZAZMmlG2KkV0Bsa6IQ+/Xm3PQpQTpjXc9cOwN22o6y653zw7N89oOPBqZMmoqTuFz/Qg3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6783
X-OriginatorOrg: intel.com

> The only intended functional change is a reworded informational message
> printed if an Intel system with non-linear MBA delay values is encountered.

I set r->membw.delay_linear = false; and booted to check. Console
message during boot now includes:

[    7.372455] resctrl: Non-linear MBA delay values not supported

Attempting to mount resctrl with the mba_MBps option fails (as expected)
with:

mount: /sys/fs/resctrl: fsconfig system call failed: resctrl: mba_MBps requires MBM (mbm_event mode not supported) and linear scale MBA at L3 scope.

I've been using the older versions of these patches from

git://git.kernel.org/pub/scm/linux/kernel/git/reinette/linux.git resctrl/controls_rfc_v2.4

and haven't seen any issues.


Series:

Reviewed-by: Tony Luck <tony.luck@intel.com>

-Tony
