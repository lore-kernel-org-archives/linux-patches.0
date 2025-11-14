Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F31262DECD8
	for <patches@lists.linux.dev>; Fri, 14 Nov 2025 18:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763146293; cv=fail; b=HnD/5GYY31uaXHiSf9Nu38vdaVEdITNqSz5SaxtHQXnvhvErJMDO7it+EKvTHa2PNpovAzDwFvRESTjQggDiNyj4fpu2tN2MngRFn357ubCQRWT7I+SLuYC1xTWzzODUVehX0haXv0uG+INJLBhNbcGwV4MrQOQoR8LrAssrNiE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763146293; c=relaxed/simple;
	bh=/7mNpw7jy7i7TKeECUnFNyCNPW+ytzZI0ORl3V1iBVE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=kVqf3k4CkEegBx+Q/yRzJPlonVBy3u9r+SjgBLKKSuhx4rYLJCSNR3cgjo7obWXBOwoZ/iG4Twse9AUmin1ndb38BxOoKPMM5q3BQKd9KMg9lNCVlJ1wsnF8e38sTQkRiRHibM22q2U0KJs0qzniONmPd6Xz6sbSwm5WSv05ixE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZaiFKOKG; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZaiFKOKG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763146293; x=1794682293;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=/7mNpw7jy7i7TKeECUnFNyCNPW+ytzZI0ORl3V1iBVE=;
  b=ZaiFKOKGuggqyNn2Rt8kQHvPX8k4dGTmoEiwiYKygZGiSFAK6njxntoA
   ToRosVD+xbl1V++Kfqx0PSNaxfJMbEfUL771Kih/YVo5Bb26/pn8RF88X
   JuWmNNcN0opDLcLjlvEyPPuqSjj5qtqwm4eFMMQNreGY1ELYEGbfjxBlf
   /PA+BcnR9k94JdIutiAn+QqNx2hLEUTkbdpyn2ULjj7wAwBeAoaRm9z/b
   xXEdAWgVWZryHUoIDEU9Qg5txGUCs7i5bczqVkHwTdAaj957T5VGekamK
   2nU+m1AvK8IBMypNIbQuzW1ALIriCZP7PEttadovUzMjYRRivbECcb95g
   g==;
X-CSE-ConnectionGUID: UyQw32+0SG+goUiHRZfSVA==
X-CSE-MsgGUID: BAjIZ5HER7eDU3cIG28Fvg==
X-IronPort-AV: E=McAfee;i="6800,10657,11613"; a="65133246"
X-IronPort-AV: E=Sophos;i="6.19,305,1754982000"; 
   d="scan'208";a="65133246"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2025 10:51:33 -0800
X-CSE-ConnectionGUID: f9++PYMhSuapIpycyD4F9g==
X-CSE-MsgGUID: T8Ou1rDWQ6aQ1j5mla1iqA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,305,1754982000"; 
   d="scan'208";a="227194858"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2025 10:51:31 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 14 Nov 2025 10:51:30 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 14 Nov 2025 10:51:30 -0800
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.71) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 14 Nov 2025 10:51:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Zg2ktKLkkqOiBSZNo+dXmU58aPIJcuQBWzn8//JrNOZjuUhWmHnmdbEUWZbtG3dMmixksaRnvDehX1eGbSUWvfcFwmi4J8vU/9c8Cgg+TemYfc55TToWCD9UbcBKLp2bxXpPURCArTepElRObpP5cC0RaVB+KG9UYBnTAsoqTIr8P9570s3ykqDW/oLpXdqhsumSAp5qCmINJmm5TVnb4aPVbkma9kM5Aed/pMLpk2w7bz9YfXqzYohae97tR6RCE1yncJ426jduWk8YWlLNpiG9uA1/3rF7jqKUYA4CqeeqayXUtBl4LM1xZYGGxwC/bZWpS6WNwGYzZ1/8lmOmqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3amQ7QbKnEQuKl61XePwSdj0PVuQgUgpEu68vTCgjGM=;
 b=ndGJ+yyrkINR8qyZOM8FP7U3rmBZhUgLhF+T+xOgUaPKYH5J/E2ln72PNHevQdig2CjxAnohzYXCJQoZJEJAzR6ERhdf8cy1ymB17+85fhu4vi1L+SGKm0+QZWJDhVAaJIfLYAFzrWtetL14fdyjDsj9lcCcmd6qrsGHnYHgAQqHuT/vE+NUwS5lKX2zwNiX78YJIoc+CkrJ/qdwLZQ+WwDgGtP7ofBfumP138q8ywLMUM1hwqPLfvFz/jrO6qWF4BM8+Qb0FNovH72zg/yAtMoGn7fEvxsUffFFr/uKGtR/ZdVfU0HDO0IUWBIRPGZCgIAHCB4N9aM/XUeGliDfQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by DM3PPF8F79256C7.namprd11.prod.outlook.com (2603:10b6:f:fc00::f37) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.18; Fri, 14 Nov
 2025 18:51:28 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%7]) with mapi id 15.20.9320.013; Fri, 14 Nov 2025
 18:51:28 +0000
Date: Fri, 14 Nov 2025 10:51:26 -0800
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
Message-ID: <aRd6Lv2ZJzkJIq45@agluck-desk3>
References: <20251029162118.40604-1-tony.luck@intel.com>
 <20251029162118.40604-13-tony.luck@intel.com>
 <aQtiSmZ14b+U/J4U@e133380.arm.com>
 <aQveOz66Pd3R0FfI@agluck-desk3>
 <aRNvZvNnEYFXfZmI@e133380.arm.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aRNvZvNnEYFXfZmI@e133380.arm.com>
X-ClientProxiedBy: BY3PR05CA0032.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::7) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|DM3PPF8F79256C7:EE_
X-MS-Office365-Filtering-Correlation-Id: a595a587-b543-4fff-97d1-08de23aed179
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?boS7DhOQuFxAw/9xxFjTXzu+mojNuoZthw6gyfnEiER41kQ0k/aglYIEGman?=
 =?us-ascii?Q?buThJpjWEN26PZFuAfQMSjidD8Dg4RtR43Ktb65R+epOgtxMn9ekRxBED77h?=
 =?us-ascii?Q?JcDywbqTNcZmgXsci/f9l9WX/+x7PSG2i6Z30grIZRZbpvS5R/zMSghWDdS+?=
 =?us-ascii?Q?rtp9M6fN3vlljmV2TG+7p+s0EIpEe9EGJvwjnJrF+jlNxd8G8/0OZHd0VlJk?=
 =?us-ascii?Q?Dxr6Ge8JutMBkALpkCghkJ2RIJuZ1JIM3YxcRVzTA2w8TAoJL9D71sxAJYpU?=
 =?us-ascii?Q?RAqWAeQLpok6AjrRHFJAtt3bq5g88FYplyL08qt8ZyCOj6Gk36B80kEGE5xZ?=
 =?us-ascii?Q?tdoE0BqhU2TXsK3l3Vjoylkores3smsooGL8VXPiLKzYzxG1bJGfVw9DxYg+?=
 =?us-ascii?Q?MlsuDGWT8QypLRui4huAKJzgYmP8BH0C8ybQa5iz96VAb/kpxrqJTB6oz0V1?=
 =?us-ascii?Q?/FZrFPZ79GRg3CrqU+6sH0Au6Jyai9/CE1/04LjCtxYR5fmsGZf+QWbzMDtJ?=
 =?us-ascii?Q?YIbY/ME2liuRpldE/ldy9hV0qLpeobLz0LeavcOZNrOUDWA1QjVpc94isUBo?=
 =?us-ascii?Q?SmTW0VcGNdK7NllhBhQKZFh6+WvPTD/iWNyg8ounqX2Mr5LPoFMSazax/SH5?=
 =?us-ascii?Q?52BM2iWS2QTdpboFLgPb9kov2sMPFwCsOpeF8Pkw6PQ/GjgB8bgRJvT/UlOd?=
 =?us-ascii?Q?mD4LAbhUv/BcNZaZuX09NcYP+ChFDkOJBsGv8Hodkg7HT+Yi+fs4MJ1As958?=
 =?us-ascii?Q?OBXAoJEqyJNjr9S/lLxaIZXxklYoOyBBljCLZKUTRUcORPlHFHiJynrIRB2Y?=
 =?us-ascii?Q?InbE6wRYMNGEKcQ3VCdElrA38CmJ/Mw3H+cDsXWY7hz5dwIc9m1Bq561EGGy?=
 =?us-ascii?Q?cBBIckCRhDf4ZfULCNMFPIVnor8C6tY5Rp6nEKlFN0e6Ta9xhuyuDNI38QEq?=
 =?us-ascii?Q?HA2ny8m6Pe6u3TvX4cNk8jqZdhuk7fOTOsGI+HYfd5UWjb2H3JPJVoINOKRa?=
 =?us-ascii?Q?V2ce7zurLn2aujMBINdXK/StPRhTwFfrnz3rmLmWcYBrWj4V9xMWZ0yJ94lh?=
 =?us-ascii?Q?1YeRgjyNHOSFzXatePl1O6X6ur2ywY0wk5jfnwlrkaJ5uUSs/bxBPk5OoxEy?=
 =?us-ascii?Q?vXJFgdYWWhySaDP4F3/nCc0mNlXPtsOgo7MDFqcAY5VFuvPpcRyPINJm+kqh?=
 =?us-ascii?Q?xWdE2KiZQPwtfsKyvU8hQ3Awuvq4d/aak+zTv+7HGFOf4hofh9buRGbDW1X7?=
 =?us-ascii?Q?ygrl6hsYITR8RAOsQuuKtSH3Y5YPgKcm7Z77kra9rdFshx/6HMdaG5dJ6dp0?=
 =?us-ascii?Q?1oh5YpxC6CfNxfkI6u3jt0v/v3T15QBnv3PyYH9CSWiAQsQABfMhX3f6doiy?=
 =?us-ascii?Q?gmRzaHzQTGrDNijhpMVwZCox3+8/evdVkDRrfRc2AzJtyBMZC0Gv2ir6OKsH?=
 =?us-ascii?Q?zcvur9ZUowhLKWgXt45eD2krsE9g+jVOpZjzSKUxEfDL82sS6oY8jA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Xo/hf9jzGOuLJvGSi39O1hcxdnhJMFc9/YKQytX8lGQeK3jv+LL2y8qFvarC?=
 =?us-ascii?Q?K7g1ykS55okOJ03yksVJTVTdE9o1gFOG8Ll2eLNDI8sZuyrAxb94AtxLjhHD?=
 =?us-ascii?Q?a6cHJ5Qx7m6dg62JHUo3TJ9uzRSlGy+7czO2pCK3aq3arRtT+1pP//IFqNBx?=
 =?us-ascii?Q?3LzCxaVrhsv0dzgd0I5TAMa/ghI3c0rdOrL2Kc+0bdFsbhoUuf4iqbhwGe+C?=
 =?us-ascii?Q?puRiPpKMVpuTiCxzXVRY/cFqfnV2miYIMV+glMlOnWMwavlA+a4LtwPQAamJ?=
 =?us-ascii?Q?4TSAdlEjQkbfZhjiBtLmJQeMXHZsIXbsjpld7cr19f22uHm09n3ioMIFPG3J?=
 =?us-ascii?Q?sNIZW3i5V93vwblIyvlXImDFKsGW4HCn4xfcj36ZXqfxA/mDK/yicvs69XJ5?=
 =?us-ascii?Q?vtecnAfaUl31pBLhRZnDw/if+buP5dnRvYggzWYRh2Yi3QwWQMkzml7dy10m?=
 =?us-ascii?Q?i+Q3RHsB524A5sBd2vMWCIYtyvD/oyOsjlLLsywiAPGsvt9QfZJI6rjTt2wy?=
 =?us-ascii?Q?Q6h3VSnU7x3z3W6De9vSJsaWC5isDT+lgD1a52rzCWx4JVM3Gp/Q5Zo7Oao/?=
 =?us-ascii?Q?usBwIqFORZXep0+rdE2em2C6TAPzIf2Xzj9BeT77kAjtndLszYXdUL7EcZnA?=
 =?us-ascii?Q?B+3XmTcBJk0g/0IN+k0O+x+XzGBrF45wmX/wrFGQd4UpqmgGU9Ef1KWtPeg9?=
 =?us-ascii?Q?+cMUcsp0bCWg8BXMhw3ookiWOyf0KFpQlj5cehySJ4domyC6V/6dGRGGVHTx?=
 =?us-ascii?Q?FPxnGVDXW0/SVT9IlWpX1CkINjp993Ht2FB7aKz9A8pYdJD6C1bv/g0k60xP?=
 =?us-ascii?Q?cTpdjX/2a+y/iB8xEEF+mKp6/9+/DF64y9Blu9Zfk+oBifvTzWvjksmjy15I?=
 =?us-ascii?Q?qd7HCVqXgArOoecdHGIwXnOtDlMApBiIeNG9euUn7gt8lVhlsSh0Di4Div84?=
 =?us-ascii?Q?bdg1ClAdOgSpyWN0IWQgLSe3yKAsHNNUSD80Red8PhjI0aHV+iTCFqwSGGVJ?=
 =?us-ascii?Q?mLzdQmC9JIYq5sADQNlYsx6so6BkYPJd6k4h5Cgxqi2+NLN2UZdm9oBq0jN6?=
 =?us-ascii?Q?ME62O3M6H32TjZFBwAHtlOwvVI64Dwh9Yk6PWR7wHLvE7aEWd8bBmC+o7Dwt?=
 =?us-ascii?Q?Bj4iW7fY7GXV6G32z7enEMTuGELqVF4683vgfph39CPMM242egbxQyfpdnNh?=
 =?us-ascii?Q?K1dMSBeuQK+LTpcg7YrskxMdum+bZ14WmvqBtgs7QenYI3p89Toh+jEUFtZ8?=
 =?us-ascii?Q?+1/4tomrP4UkoIIfodrh4HLqCJ9w0zjAIxhoFCyeCVJQGeliVdHfn7WN74fR?=
 =?us-ascii?Q?lz52CpfE71otULcbnmwNgB1MZVWflJrz5l6AbfaqmHqGBck6eSnBcY919AuS?=
 =?us-ascii?Q?xT82lLefK/55e4wfZUyTQdYErpZ68szJ2Wk8+U6i048xbppgzbFnETv1fLZe?=
 =?us-ascii?Q?SgwXhRhbmOtgiD4gchGwsDm+SFFGDgyd1jlpYcZ3m2Zj1fOkvh9NX3EOm4Kn?=
 =?us-ascii?Q?Ikeko1CP8zRZLoImx7e5UO4ZKg5XXrvOHOYxmOFq2YZobygDiAK0V9qevnIT?=
 =?us-ascii?Q?0rqVJuxzqrzyZjj8wqrTpJmJSgwVCa4K6DMkwYYz?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a595a587-b543-4fff-97d1-08de23aed179
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2025 18:51:28.1041
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Dh7FOxws9IRKQPyvwvTwmMiA6zzhacDgk9SmBVjRz/bEZPgGAK/vhAS+rOxBiX90KsRALneUJtS9ooOwxQzbJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF8F79256C7
X-OriginatorOrg: intel.com

On Tue, Nov 11, 2025 at 05:16:22PM +0000, Dave Martin wrote:

... snip

> > I'm not a fan of the "floor" option. Looks like it loses precision.  Terrible for
> 
> Loses precision, but does not advertise bogus precision precision
> beyond the precision in the original value.  (This is why it is not
> standard to print doubles with more then 15 significant digits, even
> though 17 significant digits are needed for bit-exact reproduction.)
> 
> I don't know whether this matters relative to the use cases, but it
> would be nice to have some rationale.
> 
> > 1-3 binary bits. Also not what I'd like for the bits==18 case that I currently
> > care about.
> > 
> > "ceil" is good for bits > 6. Almost matches my numbers (except I jump
> > to one more decimal place one binary bit earlier).
> > 
> > What do you think of me swapping out the values from 7 upwards for the
> > ceil values and documenting that 0..6 are hand-picked, but 7 and up are
> > ceil(binary_bits * log10_2)?
> 
> If there is sound rationale for hand-picking some values then yes.
> 
> I haven't yet been convinced that there is ;)

I don't have a rationale and I've been doing the thing I tell others
not to do "getting attached to code that I wrote". I will switch the
whole table to the ceil(binary_bits * log10_2) values.

One exception for binary_bits == 0. Back in the v6 version of these
patches I printed as a plain integer. Reinette commented[1]:

    At this time I understand that it will be clear for which
    events user space expects floating point numbers. If the architecture in
    turn does not support any "binary bits" then I think resctrl
    should still print a floating point number ("x.0") to match user space
    expectation.

-Tony

Link: https://lore.kernel.org/all/8214ae1f-d64c-496c-b41d-13b31250acea@intel.com/ [1]
