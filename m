Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 221532D94AB
	for <patches@lists.linux.dev>; Thu, 28 May 2026 23:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780011492; cv=fail; b=XqS5sav4OEjg56mUNRoM2FbwHLR0ZuM0/uvJBmHZh/hNcnri69EFPaDZjyR3A/HJHjsItkcAaW4nnLprWsT3lhydRwx3DQL+qvzz+NR1prrRVoyj6dKpUJu1xLlC1E+Bh+l402MBwkLubqEfIh5Vf56Gzx7eAM5pXDsCF8j2OjE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780011492; c=relaxed/simple;
	bh=DQp7beu1t+Znkhcxfo/sktWYSt8rwYoBjezMwOEw6WE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=f7D5tTgvA8AXfEMkFdewKHpmQWzdq66rbdzEKfgpq0C1RL3SM4T7gaEKsDnjdMxaQ6rD7NYJFjTe68cXgajpxTX5H8myvjKur5wDTrPA7nXu4ZdJLww6HuhsnHgWKL5DrL8g/uTBTLXd0maU8K3Z76hmE0VXppSONvzREDNOU24=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Wjt1dD9a; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Wjt1dD9a"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780011490; x=1811547490;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=DQp7beu1t+Znkhcxfo/sktWYSt8rwYoBjezMwOEw6WE=;
  b=Wjt1dD9aWxNJFJhECPhGh3tZlOwc7BgTucFCc/WOp0ESW1jFDL32JcC+
   vLM/A2yIZMaF4XddLuRGxVAOxm5RyNL4QsTCXQGCr2zlhVUkAbkDRDxIA
   2G7/KcTF0guVFj36ZqHNNuznHZDE9eLgwsuWKu69pGUZ//Cte/lYATsrr
   91rDWavP+BGjJkfSoi6BrEme/RkjKwgw1T1ViS5lt7e+gT73+Zg9VNLPW
   zii8AEnA1U/eMvivrj1XsTqHX9pMVB2kq4047i419z960sTACTTpCzf8v
   Se9IaAizQg4eXEz5ohpXI4lubSlwfMVmJqNWGtbMANEm25U92fkEpw1kA
   Q==;
X-CSE-ConnectionGUID: GJNM25BPRB2gb8QiCo7+4A==
X-CSE-MsgGUID: kNf3rtAYQASJziXUiNOxXg==
X-IronPort-AV: E=McAfee;i="6800,10657,11800"; a="91171147"
X-IronPort-AV: E=Sophos;i="6.24,174,1774335600"; 
   d="scan'208";a="91171147"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2026 16:38:10 -0700
X-CSE-ConnectionGUID: UFagXaicSYqVsCSmtfC+mg==
X-CSE-MsgGUID: e7200XCqShCpKkGzwMdJ4w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,174,1774335600"; 
   d="scan'208";a="247641090"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2026 16:38:10 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 28 May 2026 16:38:09 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 28 May 2026 16:38:09 -0700
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.9) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 28 May 2026 16:38:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wppqpPq4Bg5jKSFh3yoUt7FAYSzWOQ4csiXX7491JmZVgnuqZQy912Bz1easSIDWSVX2MZbusioF1mYD7uKCYF/Rqzyd9YWRCWKgkca3vbjNjjTQaL3ydea+bHMll2wjLRPWGCXZSVjSXOXA1Vsz/2fR8dRmhg8g7zy0KwqkvDDl/oMQzguFv6AH18e5Wnb7eqcMLLHJRVjiLkHX8jsysIOVU9iHhecjmEw5tAodvoSIdilGHboZs/Y/+q9Q4S5V2Fdz3IAKKdBjpKs2Z4ZadJbTpWFoqgDaRGCPA0w7Y1DwG7fSN4Ypj3RQIzqogiBv7M5bwfef9CbsXBdXO9SzDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U3MoTyBaX0BOTYV8W6XA//quAxEOiB/z+53WMFguHAY=;
 b=ZJmiIMvHDRYaEXEMafKV1w0KYyX3JKv+EzRsj/lVTMRmPTqr009326AnnVSQwNqksXlXIKLL0U41bzL1SOxKvwnrhTnaXsIjF5B3t42hqKMpSNPMAtWyRyzVbWxLzTw4hnCCIxXCr89AJyjil6u3QLeCUOwTFEpwSpYnUQOXEMqZ4veKUi0m1LEHbCkI8SAnGGkEVXZsdVLOcnGZBM294PQ1PBEA/NXykZ32FoAKcoC2tmYTWBBHFewrLN28GH2xJZaP/WFDo21ro+G9AN2ibIZ+1oV6+ujhpPKp1aI0vx3UOmU44ShZQaZ4VXd0/xOQWoIrl1K3m+gmmVjf/0LY9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by DS0PR11MB7263.namprd11.prod.outlook.com (2603:10b6:8:13f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.14; Thu, 28 May
 2026 23:38:02 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%7]) with mapi id 15.21.0071.011; Thu, 28 May 2026
 23:38:02 +0000
Date: Thu, 28 May 2026 16:38:00 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: <james.morse@arm.com>, <Dave.Martin@arm.com>, <babu.moger@amd.com>,
	<bp@alien8.de>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <ben.horgan@arm.com>,
	<fustini@kernel.org>, <fenghuay@nvidia.com>, <peternewman@google.com>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: Re: [PATCH v4 08/10] fs/resctrl: Change last_cmd_status custom
 during input parsing
Message-ID: <ahjR2CeEwosKXSE9@agluck-desk3>
References: <cover.1777419024.git.reinette.chatre@intel.com>
 <4efad346b8e4dde0b84ff3e87c635852b6575aa2.1777419024.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4efad346b8e4dde0b84ff3e87c635852b6575aa2.1777419024.git.reinette.chatre@intel.com>
X-ClientProxiedBy: SJ0PR05CA0099.namprd05.prod.outlook.com
 (2603:10b6:a03:334::14) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|DS0PR11MB7263:EE_
X-MS-Office365-Filtering-Correlation-Id: 0536cba1-90ef-4023-8e82-08debd1228b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|7416014|1800799024|18002099003|22082099003|3023799007|11063799006|56012099006|4143699003;
X-Microsoft-Antispam-Message-Info: UjFHnXbOVwP09qDuPlgMS05VfikP+tVSLrmhTrxu+S1o/FjzpVsjl7gC64fZLdtxW8loI0yVh1Jy+Gxs6bv7SiRXPIVG1cNxHAT7js3p8e6C3SmPFGPdbNTv+6UhbaqxfjrVImvr2/P15YrpUCrtxq7UYmhQdSaGVmOL6Ct+SYG4CuBFaCENeGSFvGJmSQTQ1WSYEibnHCccKm2HS0A0pRj8AxEj72UaAgOrjh+WV8YNcFNrc5HcE+JKoGrSua93SFAJn9vZ2uggE/kTpv1r2LvnYppHhtRsC9MYaiXpQVz28TRLN2XwsjOBQUip0zjNplIKT9aBcoonY8oLrK7jANdjjZM1/cpr6ft1VFhnwJ263LV8HNDw9O6ysqrhMT0tfWKyA1jrJhiyCtIE9OTYstIVlC5rV+XzGeVcEm34S3ZppaqQoaPp+Nr5GLanjz1cuyiMT4WvJUVsHI8sprkMjRS1So3Xb+N6wTl9M5mTO6SywcXOwiu1BEXh+m0mXrxwctefTp7VAj9VjibH8bHioNfYFzoo0j6UwnptziDJKy3KY+o0wRF/Cne+RQGzaD2sVjmXbNN+5e+uThagr4tyjoJWJjpmGX33bDkc00UPlTBzOtiuOYTh56oFTXsthOwT3/1OSjwQCn/lMZsEx2u8ocRWl+vYcnRjwzDynZhnatotpI6Z79Bya/XOT2VHcN2T
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024)(18002099003)(22082099003)(3023799007)(11063799006)(56012099006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sXHeWIBtzWj0TSjvoRcZi145IbzT9PZIaGJ2AA9aAwqudXAHkl0V/OG6zAgB?=
 =?us-ascii?Q?/JxKmfc5gmjGN4GYyKlgwKIvU9ajw6e+9TVVWQjwJFz9Ft0PAQl8j/PcUURn?=
 =?us-ascii?Q?StzBKoQinRJbPeAN5KOD9WpJIzP5d5RgRRfiNoBNUKGbDZzXe+6R+PeK7Csr?=
 =?us-ascii?Q?ri8ATNauOqrNj0LmFVWN+mW30hyYajMqMhYRvWqqKVhsBaZ6gZSPbgOjv1TP?=
 =?us-ascii?Q?xHbQUUJ9bGMNqvzTESjHajgbZqYiGgLnYRje9ghzPID3+pU7CoAf/3b3bmHX?=
 =?us-ascii?Q?0EHsUBGZrRLcdM1M6iudXKlYbe/svYfs7dUkzFWenCe/aCYPr0acwnrJ0WUG?=
 =?us-ascii?Q?fxwttSGEArp0EWyHWSnR7rbNJxpgXhjEQ7OJNt2LcaAuiOuAfdoinX74F8o1?=
 =?us-ascii?Q?ut3VrosbBTS8Qkrbz4VvujGAUMwRXPFlnl4iDFs+UeC5R25xRauIHYwNNQ+f?=
 =?us-ascii?Q?hP1nl1dnTbFRYaIjLBm0JapAcXUP556f/8ync38I6NEWEUpOZJjrOBmzor8R?=
 =?us-ascii?Q?tqDs7RWqJ8bjk1+g0H6bL/eO2tcz1gdFQrkFZ1SYTwA1T1dGSBpL3owY6in5?=
 =?us-ascii?Q?7qNsuuKpSpmke8JtgICEiiEf75Gf5yFe81ovbdXYh6THdg/rx2rsSMytcX9L?=
 =?us-ascii?Q?xET9QvywAs0EuhX7DYroz+1nSTsTzbQziviIgDaFXLgmJUNUyQKmJq1Xevtp?=
 =?us-ascii?Q?VKt52b2R7oxVz5/fm7fc1BDhP9yvQO6VGyjUh4Pef+7//QzSJvpRbxVU3ItI?=
 =?us-ascii?Q?yDQv+rLPoaS9F2OZs9K2OqBbLank2bbMtYq2hl6tUJ6KdpKMvnjTsnjpiU6D?=
 =?us-ascii?Q?uwAJsCestxYvqd5GVr64X1NZypOjZWAPMQAV6P48EgpYub2XWEh4CEVVbXqZ?=
 =?us-ascii?Q?EmI1i6vnVMrs+JtMZL1+GKqTwDfFzewsJeLSZrLDhBCxZG569ycXoNVNL/dU?=
 =?us-ascii?Q?gw63idRvvdnFI8GwyTgIp5Um04fWyTL6a8YyY8hlJswfV0kNLH3IMB7XcQiL?=
 =?us-ascii?Q?hMxYmTVAjvFTlF4zoIZvbw4G7j+Nq8ccQp/H5xXbG/veJfwh8ryktCdCIb+x?=
 =?us-ascii?Q?awE7uo1oTZB25LH1sKyPzx15uvbUP5QRL9CCt9FKVfqby40q2ODPD9EqWT1m?=
 =?us-ascii?Q?YSfjiB713SiO+2NFi/r4WNx3x/VslMynQAVe49MzC2zM/G4eXi2PBgRG5yx8?=
 =?us-ascii?Q?5efy/xdUoPOCRPKkdo0CYPWc68SryGraGN+rJaFaPXaI26nuY+6sEoFj1oeM?=
 =?us-ascii?Q?BF1LFX6IW9hottMp0qnbWKjKbl6+4mD+aATJ4tw+n4wHej8rXZLYLWb2dUKN?=
 =?us-ascii?Q?09mDvEqd3dpkJp9Ah+q2eM9cA2SBUYyX/9i3wJKv8nq5nN1HD8e48WqMiNNL?=
 =?us-ascii?Q?r3k3hFyL/W/l4h5Tkx4um7eceSpJO48cUoh8m5RO4Y4scTGfedbzRLx5KrCO?=
 =?us-ascii?Q?jbCUOJgr52N7TqdJRjdm9E70TZPcOiUjEuppshBIKU2zDSFD3HrWbfWo4dMR?=
 =?us-ascii?Q?l+U8y9cKoKsyBaVLQ9BCVptT2FCutjCaWZLCzvg1M1FPMiXFdzIpOsfS0XGI?=
 =?us-ascii?Q?V0WTlUhR3rP2oSoNUFBRahQ65CQ483CgZs+7lpmj++Vi+sMHhibWii+X1X0l?=
 =?us-ascii?Q?V2ZmCu1dRcEe2KcB3U1Hey2Y2nD/XuxBXSGmKSq9Xr23Tlxax1jBl39FAtpu?=
 =?us-ascii?Q?Df1QHF4plB5k2TDfJo1rVtSpoMgGfAXiIPUq1PNZ/LqgX+5fuinkBGVFbu06?=
 =?us-ascii?Q?FFyH3c6ObQ=3D=3D?=
X-Exchange-RoutingPolicyChecked: fuC8q2Z41wDVZ7skBAy7wGNsmOwBdQ6gykY631tfPbFpvPomxbop8HoP4f07YpFZmSPZOMA9Tg5ENARieDNiz9WpBdt/mQacE0DDQIYhwSNFA41sFkOyrGHIjWZSZqFXWqF8r+cO8fLN8CK1NpXBNMYxyCUz0Md1aO0CZm1/judH8iK4ueMJ6fnkvwcAOgj0TzP9T+gQrTpT8gs9EK9JhZdM5wFAyA/L0miqP+A+hWDj7cjMCi7WuUP0eAe13fwuv29DaZERhg9GDqV8VHCIBu3JJgKskxLQaWYMz5SkS/3KnTZiNLVv1CMNOsYPOKmcYaohJGlV8DjtNMXCF8ngsQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 0536cba1-90ef-4023-8e82-08debd1228b6
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2026 23:38:02.6403
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GaroTUQqASB2LNidWcSaHgejUEabnh2/vNsHA/seWWPXZc9NqE95cTZI1vgyp6G8QjqpahaLkS/9KlBUvrQP9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7263
X-OriginatorOrg: intel.com

On Wed, Apr 29, 2026 at 08:06:38AM -0700, Reinette Chatre wrote:
> A pattern of usage of last_cmd_status was introduced during its enabling in
> commit
> 
> c377dcfbee80 ("x86/intel_rdt: Add diagnostics when writing the schemata file")
> 
> and since copied throughout resctrl to result in the following custom:
> 
> 	..._write()
> 	{
> 		/* Early parsing of input, exit on failure. */
> 
> 		/* Obtain rdtgroup_mutex */
> 		rdt_last_cmd_clear(); /* Clear last_cmd_status buffer */
> 
> 		/*
> 		 * Act on user command, failures result in detail
> 		 * error message in last_cmd_status buffer via
> 		 * rdt_last_cmd_puts()/rdt_last_cmd_printf().
> 		 */
> 
> 		/* Release rdtgroup_mutex */
> 	}
> 
> If resctrl exits with failure during early parsing of input there are two
> possible scenarios:
>  - The last_cmd_status buffer is empty and a user's read of
>    info/last_cmd_status returns "ok".
>  - The last_cmd_status buffer contains details from an earlier ...write()
>    failure and a user's read of info/last_cmd_status returns this outdated
>    error description.
> 
> Writing to a resctrl file is considered a "resctrl command" and the
> resctrl documentation states the following about the last_cmd_status file:
>    "If the command failed, it will provide more information that can be
>     conveyed in the error returns from file operations."
> Neither of the current scenarios is correct behavior.
> 
> Move early input parsing to be done with rdtgroup_mutex held after the
> last_cmd_status buffer is cleared. Let info/last_cmd_status be accurate
> when an error is encountered during parsing of user command.
> 
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> Reviewed-by: Ben Horgan <ben.horgan@arm.com>
> ---
> Changes since v1:
> - Add Ben's RB tag.
> ---
>  fs/resctrl/ctrlmondata.c | 54 ++++++++++++++++----------
>  fs/resctrl/monitor.c     | 60 +++++++++++++++++------------
>  fs/resctrl/rdtgroup.c    | 82 +++++++++++++++++++++++-----------------
>  3 files changed, 117 insertions(+), 79 deletions(-)
> 
> diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
> index 8a43efe67a95..5d5e844429df 100644
> --- a/fs/resctrl/ctrlmondata.c
> +++ b/fs/resctrl/ctrlmondata.c
> @@ -312,11 +312,6 @@ ssize_t rdtgroup_schemata_write(struct kernfs_open_file *of,
>  	char *tok, *resname;
>  	int ret = 0;
>  
> -	/* Valid input requires a trailing newline */
> -	if (nbytes == 0 || buf[nbytes - 1] != '\n')
> -		return -EINVAL;
> -	buf[nbytes - 1] = '\0';
> -
>  	rdtgrp = rdtgroup_kn_lock_live(of->kn);
>  	if (!rdtgrp) {
>  		rdtgroup_kn_unlock(of->kn);
> @@ -324,6 +319,15 @@ ssize_t rdtgroup_schemata_write(struct kernfs_open_file *of,
>  	}
>  	rdt_last_cmd_clear();
>  
> +	/* Valid input requires a trailing newline */
> +	if (nbytes == 0 || buf[nbytes - 1] != '\n') {
> +		rdt_last_cmd_puts("Invalid input\n");

This is obviously a big improvement over existing failure to provide a
message (or leaving previous stale message). Do you want to go the extra
mile and disambiguate all these "Invalid input" messages?  E.g. here:

		rdt_last_cmd_puts("schemata: Invalid input\n");

It's good to have a grep-able pattern to diagnostics.

All the other patches in this series look great. You can add my

Reviewed-by: Tony Luck <tony.luck@intel.com>

to them all.

-Tony
