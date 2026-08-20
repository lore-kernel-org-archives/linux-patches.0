Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29489392C50
	for <patches@lists.linux.dev>; Thu, 20 Aug 2026 18:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787251388; cv=fail; b=Nx9PzBMcgv1uKPH53opVlGQa/i2ZaHNQ2faAZ5BbMXDtbN7Qgm6IBW+vG0Snjokk3VNOtiHcY+yveU34fmkBRRB6KhLDJlBRO6l0T6+dZnJiIrh3CfloqMNLWE30/9hk3YVSBFJUk/Log3Wuq6L6c/jge20KVZYwsPZefbTWaJ8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787251388; c=relaxed/simple;
	bh=5LbqibqhSgc92sTlT43mnN4KopEzmVaiJuPFa5BElY8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Xo+mfdZ8lyq5rgx4di15V/rGhzf70GoN5xpXAGoBej93H6gMPXwth96iBnAsQJ3byT2Mt8FxaHTSJrqFOVNOetbFFL7K8fp7+GCqe1xOrFR+iQ4mY95EfijtdRN/8GQUtSAgJ3/LGFmta4Y+5IxqhfElA+UPZoVlNFHk4fi/oFY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EfXfVIVc; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EfXfVIVc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787251387; x=1818787387;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=5LbqibqhSgc92sTlT43mnN4KopEzmVaiJuPFa5BElY8=;
  b=EfXfVIVc1BsriSQLuQTrtZIHq40GOepBUn0nUPSSEooW1tpZIwACSIDP
   qVYRiN3ZhchQR5S+zn8pLKGarljh1uWjPRwiYnZS85B0dCJdutCd1n2YS
   q3b4ZvqgXeGxY4sp6Y0RBTQWmHPxWoO+MIhETMqPxWucfbmWmWoeZlnGm
   3G7IQwSgGEl+LteTR5RfuXbdVF1uuo28rRG88KdhMTlI6Mkrs00CZODJe
   8DoCwAJlzfjOpcZvgZ5bl1L52U99FCOCU9ceR6mcKb9sBcle+VJajc8h9
   ugbgnULFBoX5a8vHyaohYRyctrRugao7RrFbYmRphC7DgodDXmN7A7S/E
   w==;
X-CSE-ConnectionGUID: ypOkePjsTu6jXPmKvRsqeg==
X-CSE-MsgGUID: 69lMM8xlSCeBblsb/ygJdg==
X-IronPort-AV: E=McAfee;i="6800,10657,11881"; a="110586061"
X-IronPort-AV: E=Sophos;i="6.25,233,1779174000"; 
   d="scan'208";a="110586061"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2026 11:43:07 -0700
X-CSE-ConnectionGUID: jmbBapUgR9SLrFocFNxmtQ==
X-CSE-MsgGUID: r9L5iz3JTw6B0lrwiNmvBQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,233,1779174000"; 
   d="scan'208";a="269940057"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2026 11:43:07 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 20 Aug 2026 11:43:06 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Thu, 20 Aug 2026 11:43:06 -0700
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.14) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 20 Aug 2026 11:43:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sUuVnWhOQ2hqUugff+MT2R0qhM2z8GaSCp8LXuyHz8pMg8qjSsjz/wSIaG3lNBhj3yXTCu7wQZVaSINjujkubI6i0FBOckJ3iUJo8d3F2BHSBjP4To4jYl1S8v4xDxKCT2j/hA1oSupQKgFiXkDxgcZ7DkakaBy8aPohm324uJV6EIWSXjqiPuNVSwIRzROIGGoSXqZ68bPGnJV3UtUD3es93Hv6IKWDoUef+xyJg15JebdyhPw+Q4tMb7nHF5ingm6N/cJDd6NrMuLojL2vzVIYulFbCDrKtbYkxnbtInCUKJBEAzHE9o/RpIdOL37xwYPeCV718y6TceIbq35deg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pqcp26pRmynFIeXDavvAKaFzC1sopnTLkHG4q0p1mbI=;
 b=jjhaMKk8Px40aQsTUl0VEqAYsFUAjEUxEVMbR7vk/1QU0lXafa40B7ilkQJvfcfo/6GSQ3HUZc77GgapUYgF3U4WzfuTeumOuBFp1QPwwqH/CBvc2cBPZ9G/bdqXOsF9f8ZYZJxvsh6vZ3mldRIp9NUHMo9xiVkPZesWwJpXsf//pMwyzB/pARSXgZpzQm7I3yp4iHKu7V5r3U76f+Un9QBB3ug2bQfUTB5VlLB5mJa4juy5wp/MTMkEmD/nZPD4j3atuDLbhLWD98DnBKMuEJP9pgIgXsXQ4bp19zwBVfqpsArQlMVkBue+unAgHKG/ilb2uChAEITgtlj098oPtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by IA1PR11MB6539.namprd11.prod.outlook.com (2603:10b6:208:3a1::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.10; Thu, 20 Aug
 2026 18:42:58 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%4]) with mapi id 15.21.0339.007; Thu, 20 Aug 2026
 18:42:58 +0000
Date: Thu, 20 Aug 2026 11:42:56 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v10 08/17] x86/resctrl: Enforce system RMID limit on AET
 event groups
Message-ID: <aodKsOMxcdasi0U6@agluck-desk3>
References: <20260729172752.11561-1-tony.luck@intel.com>
 <20260729172752.11561-9-tony.luck@intel.com>
 <cda8483e-8c83-45b9-b52b-0e465e49b698@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cda8483e-8c83-45b9-b52b-0e465e49b698@intel.com>
X-ClientProxiedBy: SJ0PR03CA0130.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::15) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|IA1PR11MB6539:EE_
X-MS-Office365-Filtering-Correlation-Id: 9be9fd9e-80b0-4429-f65a-08defeeadadc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|366016|1800799024|7416014|376014|18002099003|22082099003|5023799004|4143699003|56012099006|11063799006|6133799003|10067099003;
X-Microsoft-Antispam-Message-Info: yfNFx+dgxz8pr9nejVwnT8p3Pa05TwZkhOVqV/gaahUtp6ChMcm0BHvc1ygEcYHo2iAaeYQdq82lzPUIkEgYZoHkU9fweuDWrHV0CwyclSMWTTSbDcW4dmSfiepbfnTpTzQKLvan/SG6tlaMxE5vFjcuwrxRzJoPFIXVNj2VipoM/fJH6uTBckuIvTBQMDlTQj+yN+t/iw+9QdleMixTi8G9kG/TKNkXZuHBxa/pkatc7r/HBgPNyetzdfQlrFPR7cRrVOUJcy9SlhXLB4Q4dxgLqKUdfIxzuEcu4VpMUc3ixGjQF4B1JlKj5dL60uo5N8zKE3UW/pOE9fAdMlazgT0a7wDLrCq8b3YHhZdRjnYAsY+WPGyVW0RB50T4t2PfvgOfk34Xg9jHUlMlfw267OHldaJysOKpjlwgz98r/AkXGpBBZapJvz2wxwJwtrEqCfIHtWr48fZ+lvjV7V/abaubO9x8g9nX2FsEnm9krYG0bCtKHPuclRRAsyP05ujsppXvEZShbs+Egg8AK+LjJAjuKm+KjarQ3x6xidrF39/lJGY7ufgMzw251hAzOYZboBLG+budL88VxFeaiYdaCfWgDf7GCNJKFqsV3K1J7DjP5VaJoA7cJSOoRz6N/ke54KkhEX6Vq3tD4gvHQ/m3xTb6LQjIzHPMo3aIMmPOry0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(7416014)(376014)(18002099003)(22082099003)(5023799004)(4143699003)(56012099006)(11063799006)(6133799003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Gx8ci3rX7odS0sT3Q9XHRAycL3iIGgrNQIFVq02/wo2lzaPHmziT+grIhoEh?=
 =?us-ascii?Q?LcJZqt+sZVC1S9GNVKBrDV82poMe+qr9+XXFZ66WDstF2fqSUYWHdAPsAJhv?=
 =?us-ascii?Q?tPJs5zMI4uhpON4k7FUS4YteGHwcn81PI7ZDiok1nJeRrZ7VzXte6tcW0G14?=
 =?us-ascii?Q?bYZnD9cX3+H0tAM0YskW9rpDnR6o5ssZJ8c2MmLIztuUiLgRxGAd3YmPQq29?=
 =?us-ascii?Q?l3PKBWtKCUd9mQYO6B/1wUyRbjahtgto/En6ny+cK2WWqFRS5Cre1g/XZEZE?=
 =?us-ascii?Q?zpjuMCBn3ZjSubXqUjFGhwEJaobC3Zh40Ul15+LyeQYHTaRYQC0O3kk1qUxe?=
 =?us-ascii?Q?k93ui5M549tqi7vd5WuY3n6avSXCfP/Y55TxeRXLTwH51vZ+ZpvqHr+yf2EA?=
 =?us-ascii?Q?XRb9k3PyTHr3QLqowEuAeb3HmO91UTtKEZUs2/A4JdO9yhl9rYHG89EQbHQ8?=
 =?us-ascii?Q?ajeUqgeGhBD8me+qT6KT5XBlvwUly7XjSR1BQ9Yq6Lvpm0E/OWZGe+Jf4Dey?=
 =?us-ascii?Q?bKFSk32ne64SCRShR2q5weOH3S7a4GONkCYoYblUG5MhvqLRkVAcYlhl2fvc?=
 =?us-ascii?Q?oWgjbngBc5FMpVbn8P3RkM56sKRl5vYC8hPkMPLS1Spw9S4lFPmtvgW3k801?=
 =?us-ascii?Q?hGzML5lttJ/iuXRfCsc/5H9mPWZUadWfsak6xv367aiXnD6WkGIfz6LnC5B+?=
 =?us-ascii?Q?QYIsRmS2HSGTsH0LB/iwkrNkL8W3rdJRJBH8JyZwMyz1G61NH6WHjLlygGKa?=
 =?us-ascii?Q?gf4/+9x5UoTygwkWECci6HiGkY7nUyL+eNfew+7RR6yO9mG8tXI1Fjjb3EUp?=
 =?us-ascii?Q?DXHh4qFfCzvQu37rCsnoFFE7TnpynSH3wXn2gqDtFb86EkqRW5R0UThTOXs1?=
 =?us-ascii?Q?ij562xHpT0QAgIsG5zqKMGtzt35W7ekBNEGHksnmBTj0TW+TER6SGscYwU3j?=
 =?us-ascii?Q?tFTj/OMDmN/KjmWOSOuDGIlL+ywyNBB451CZFJVLARUWYcdsqGRzS6r6wqSi?=
 =?us-ascii?Q?+4FCwWGI42rYYNpxIhPAQ3mJTsaueh2TwdEafNEekwJdDcMF6Ii2brrqyQ63?=
 =?us-ascii?Q?C3jRq2XSFPrXh82cl71o6m+0OtOcSKSiiJt3KM13TTvaAZgURlVkrdK038th?=
 =?us-ascii?Q?SJU/7MVJGiOYvyLJFP4lzW4KBO7eFpen2XjBpos4IpBuSA0lBmfzPxAyCo6Q?=
 =?us-ascii?Q?yobunaQGuXpqYxUyTbwROMXKSqbXCcyEgwZch/CiQp/YGXPOjPL6wLPwTNOH?=
 =?us-ascii?Q?BhbB/LIuaZXIwpuuFtyQLxUE6WWunurfHUFQdKcwIiqEmOOXY6zijVOzpdao?=
 =?us-ascii?Q?XTkHBvVOlucFSTkMRY6s6cje7QTHdSOCQJM5jPXwtlU8idb1/UAnDZOLcTZ3?=
 =?us-ascii?Q?SHSLri0/2UycGKUxPKqheSeyZiasJXBPdVH56ES21dgUGK7vUuYQFWizYw5A?=
 =?us-ascii?Q?2HnWtFd1gSQpbWcIzEjPaGVVwPhfMEnQAFOTHYeE62Y3CXYeXs7yQXjek6Pj?=
 =?us-ascii?Q?6YhrvOcfigj2fu34KvdKCpYz/e/mYsR+EwSE+KiqHhB2ycetPjKCrBANUjFK?=
 =?us-ascii?Q?XePsRn1uPVx1Ve8z3ryYgiNZlPfu81YclYpJIZrngCy9dUTETjmwis5x6pbA?=
 =?us-ascii?Q?eHiqvH2RYG9j9Hy7XoqtGwh3aZK2o+X9RkXfQ/FsUIx4MzXF4DEDzW+Ervgy?=
 =?us-ascii?Q?7I5s5WCPfYNPxbCzkOTPzREGtDfd0uPnMDdOf4F2mMRoD6Q+eUmJVBfluI9s?=
 =?us-ascii?Q?HUTK0HTe5g=3D=3D?=
X-Exchange-RoutingPolicyChecked: i8D1tIKTJ+dmVsQcEQuKzdphiToaI8lpYYphqdaOvCIbv1paJjTRNV0Buji+pHediOE8VGE8hEpxe7VplAFlzmgMqOjGnETyznIA44OUtGS4fmMxRAe2Lrd4VB/M2xk5eSQ0W9IkE8GHcC4ZANDHwDBqDiYT2qtHwcYQO/LttG1ep3aGWctgk2vOcbcuLBgSaxvtQdEmQaB8q+6BLjEIjufX006s0AejVE+YOE370HNkTVyE9vj6saRkwtElYIPoa7k/Wr1jNHTbFSktEaZMgNNGDwgPZdbY2oo1HlfnaxLLPWqkyWKXgczrmVVcGcdwzdeHAgLFqjzgxO5mu1Om8A==
X-MS-Exchange-CrossTenant-Network-Message-Id: 9be9fd9e-80b0-4429-f65a-08defeeadadc
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2026 18:42:58.2377
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jEbdXuNE6rYTwR7RFkPeNbUA9NYvI3TpCOF0PKZycbbZiXtrRKP2i4vu9+JCxxR0cgzIwX6tUGrDmUnrZiO2mg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6539
X-OriginatorOrg: intel.com

On Mon, Aug 17, 2026 at 05:58:13PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 7/29/26 10:27 AM, Tony Luck wrote:
> > AET (Application Energy Telemetry) event groups each support a specific
> > number of RMIDs. But that number may be lower than the number supported
> > by the system. Especially true on systems with SNC (Sub-NUMA Cluster)
> > enabled as that reduces the number of supported RMIDs.
> > 
> > Fix get_rdt_mon_resources() to return true when any monitor resource is
> 
> hmmm ... "Fix" makes one look for the accompanying "Fixes:" tag. What is
> the fix here? What is wrong with existing implementation that needs fixing?
> To me this does not look like a fix though (more below).
> 
> > possibly enabled. Call intel_aet_init() to adjust the event_group::num_rmid
> > values to not exceed the system supported maximum.
> 
> Last sentence just documents the code. Please describe why this is needed.
> Is this a separate logical change?
> 
> > 
> > Signed-off-by: Tony Luck <tony.luck@intel.com>
> > ---
> 
> ...
> 
> > diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> > index 092764cf693f..2c938b97b147 100644
> > --- a/arch/x86/kernel/cpu/resctrl/core.c
> > +++ b/arch/x86/kernel/cpu/resctrl/core.c
> > @@ -1019,10 +1019,10 @@ static __init bool get_rdt_mon_resources(void)
> >  	if (rdt_cpu_has(X86_FEATURE_ABMC))
> >  		ret = true;
> >  
> > -	if (!ret)
> > -		return false;
> > +	if (ret)
> > +		rdt_get_l3_mon_config(r);
> >  
> > -	return !rdt_get_l3_mon_config(r);
> > +	return boot_cpu_data.x86_cache_max_rmid > 0;
> >  }
> 
> >From what I can tell this will return true when the system supports monitoring,
> but no resource may actually have monitoring enabled at this point. Specifically,
> no resource has rdt_resource::mon_capable set. 
> 
> The resctrl initialization now proceeds where it used to stop. resctrl_arch_late_init()
> will proceed and initialize the resctrl filesystem, which in turn would allow user space
> to mount it.
> 
> rdt_get_tree() handling the user mount request could thus be run on a system that does
> not have a monitoring or allocation capable resource and then we see in rdt_get_tree():
> 	if (resctrl_arch_alloc_capable() || resctrl_arch_mon_capable())
> 		resctrl_mounted = true;

Should the inverse of that check really be an error condition and result
in failing the mount? There seems no point in a mount with no monitor or
alloc features.

This code appeared as part of James' separating the x86 specific static
branch code out of the filesystem generic mount path in commit
13e5769debf0 ("x86/resctrl: Make resctrl_mounted checks explicit")

My plan is to move this inverted check earlier (right after the call
to resctrl_arch_pre_mount() which could be the decision point on if
any monitor resources are enabled.


rdt_get_tree()
{
	mutex_lock(&resctrl_mount_lock); // NEW (revived from v4 of series)

	check for nested mount -> -EBUSY

	resctrl_arch_pre_mount();

	if (!resctrl_arch_alloc_capable() && !resctrl_arch_mon_capable()) {
		ret = -EINVAL;
		goto out_mount_unlock;
	}

	...

	resctrl_mounted = true;

Choice of error code is still open. I tried -ENODEV, but that results in
an error message to the user saying the resctrl filesystem is not
supported.

> 
> The above flow change would cause resctrl to think the system supports monitoring
> but resctrl_arch_mon_capable() returns false. If there are no allocation features
> then this will result in resctrl fs mounted ... but resctrl_mounted is not set to
> true and thus allow a remount that is not supported.
> 
> Reinette

-Tony
