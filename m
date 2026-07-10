Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 042332C1594
	for <patches@lists.linux.dev>; Fri, 10 Jul 2026 20:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783715483; cv=fail; b=ScE0twql0OLR3pPvRm1ZvHcitlVVVUDg4J52KeFtZvp88k0x8bMvWPa3Fgnjydf7aJKIzmJWkWRIaryLGjIp+QEiIW8dAzoH7+gqETTMFqmMUEk9V5uQlIG0Huc8TwWbtaBGkl3yM/L0mIEgG2czPBULDISjEz4qi0lF+Jw7mqs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783715483; c=relaxed/simple;
	bh=fP+ah8Cwyc5trRmB1f8ttl1y+YNDbY/AphCbDp72Il8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=FP/Aymur2trr3YXSp2ll7jJalVeSL/Lwm2hZaSHMSyCA2i87NG7nLUGyaRBDxaYlU5f4idbeJptulT4jkh3MI/vK0zdQNgLKSseS6oGh8f6X/PJxXKi+Ltxn8r8r7e/tO8M11i6Te7ahvPZuYd0ghbV32vdP/iloMyRefFKvg78=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mLzyl/kl; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mLzyl/kl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783715482; x=1815251482;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=fP+ah8Cwyc5trRmB1f8ttl1y+YNDbY/AphCbDp72Il8=;
  b=mLzyl/klR04Z/8KOTKDVeiFdtXWcc4EP/x1gBlgoM6niVz6iD3mqHqUP
   bLYYjDzvHwmSNb+lZJseW1tdHpWZbuQveHWr+owJ2mket7WsirbfACd23
   liiHn1SbLbdGUNo/Xr6VgDUP9uKX4TEpm1eimh+g+aNOsDgEw+126Rr8f
   VZeYS1MpIWUlKz7wN0BRG3cjwWAjKeGqjik1DOciHcor21HYNzMm0ctdR
   Y/pMUElScNCiipyhmQEHSQ+PCg9nUcTzEPBw1aJK3c/nQPw4/siiX9Jo6
   X/mc1l9HVIybr03JdAIzTN4Nbz8E1PPuSDYHN4k4gnOk8hi6cBJWax7SG
   g==;
X-CSE-ConnectionGUID: T9M5nd9/R8qDIfOk15N/pg==
X-CSE-MsgGUID: xiHiRqgRQLKyTtOhpMRaLA==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="94772903"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="94772903"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2026 13:31:21 -0700
X-CSE-ConnectionGUID: y4/QQYTzRrKBgmK85LvZBQ==
X-CSE-MsgGUID: 0d8M85CaQBiQCp80yeT23w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="252341603"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2026 13:31:21 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 10 Jul 2026 13:31:20 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Fri, 10 Jul 2026 13:31:20 -0700
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.59)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 10 Jul 2026 13:31:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KkHEZl/lCrL9RHxRDtVVmnVA+ET2Srv0Q0bFZGyOgw9rXwYi81Ua47o09qjVbXHX23GTOJgyHi9PdEUe7QnAxaklD8WTfZb1IKl5whw7ae4ZXlm+jmEQfidOXNzBvcQGnbSJ22ZHPW18bYOw1V/0bCB+rRzqjWM8ctEBX4JopiT/uObH49rdJNq/EFHUAFic9zB6P4PXH7OZqGl0l6ThsPV2arUfXc6LEi1IFkN1shz+1dhgAQAzsfJ2HXcoH5i+rKJ4fMgeRVsJ6TWGKPdS21QNGCq2nNEQLr1LhzJOmLuKIZNCRgzJcXU4A8HLaHFGln7hD8RDRyuEw9I5iVgY6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DEckj5u95j6sBWyDFPyCSq9NihbdY9Oxn1HiniV7s+E=;
 b=mzuD1WYN9RwPkKJwheul2dkhs7MjmU36w6ms3yffW+MdttvzAQS0qVXOJAsstdcKVnCwAg5zK4aDLPxesEp8A5KRuZD3ANhqAEi46RjKW7FiLj3DXKYOdMOapkQ7/OhY/9WG2o/dqGSx3aBgg8pPTUKFMJJJCX3apwGW5rgtHJvU35xs8yOoY7Xmu5UsIKedPWcO6GADPsKimHx7ZQgpmVbxnO5XCZAjudu43uOJQ8ZFCKP3PHNAJwFACzcTJuBsWt8bYlXYDdC8FV6YGJrylxGqEnUtP/dZvoeeltawoDt4XkTxZKEm6yfaiVURMOfLp0RAhelWAXozqbNyxIhebg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by SA2PR11MB5148.namprd11.prod.outlook.com (2603:10b6:806:11e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.17; Fri, 10 Jul
 2026 20:31:17 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%4]) with mapi id 15.21.0181.014; Fri, 10 Jul 2026
 20:31:13 +0000
Date: Fri, 10 Jul 2026 13:31:12 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v9 05/12] x86/resctrl: Drop global 'rdt_mon_capable' flag
Message-ID: <alFWkJR4tZuEISey@agluck-desk3>
References: <20260701213553.15222-1-tony.luck@intel.com>
 <20260701213553.15222-6-tony.luck@intel.com>
 <52d50893-cd45-4460-9cfa-81e7a7b75231@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <52d50893-cd45-4460-9cfa-81e7a7b75231@intel.com>
X-ClientProxiedBy: BY3PR03CA0015.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::20) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|SA2PR11MB5148:EE_
X-MS-Office365-Filtering-Correlation-Id: 62aab4b3-c5e9-400f-c7b0-08dedec22f53
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|23010399003|4143699003|5023799004|11063799006|18002099003|22082099003|56012099006|3023799007;
X-Microsoft-Antispam-Message-Info: sd2iiGJoEURJDZNn1DS1qt/ZNHzdJ4vqHTr3aNdmxzdMfNLa1uyZuxgzoaAYuj3WVADnvgbTFwJAp4L+oeP9W1ZGliUBqLfgs+atOHAVLlcnaeE24cAM02dSRE/MSaSmSrkwMQxEAXuXVFzJSQTYAbPrygbk1IQXcC4mUsM+lImSwyKauoBkhT4jE5s4bV2aF3o5feL1pkEUfEnpkQmwS4JqTgwijX5gABJHsWzgn4OTKCYcZvZU8WdPR7evHH0Qram+AsF+Q4HNdkNeFI5kioxhCTgqnsVG8fTL1K9jmACUL64+SBlOdAKUMFUjtUiRqXS0IBZQzLOXEHC0jlr0YW/ap46sRLMZt1f3evPsqRP1cTcA2T1ZPbE19ISsgaO7oShr7hiasxIJUw8qbghtzEneXQq5QVTptmj8iP14fO4XJBEspM8u+HwpEfACzZiCjEbJnkPyVF+ZVVNSkSJICvh+zYLB3aPxDtlgXyvtlWNQh56yc7J+CWnDRrJpCG/41bVUhuE2Yqe8QizsqbYtmUtsXCshowZoVT8fjXO/bhqdjqE+Jn7aAMmQDeIYSt6Lgfk0YMEgD2hvzmKZyzbYx74uAkx65mItSo2N8Gp3XxPawcsXBVGCuStF8c9jCmoHBx6gCVsc959z8LQ41MguHsQA19UjdGceBxQNu5Dfyqk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(23010399003)(4143699003)(5023799004)(11063799006)(18002099003)(22082099003)(56012099006)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Pdy2mDOUlr2lU1cn6IppZMJwthMdDS9W1oPaPDmBUhRRVou+ov4xdGGfxcqa?=
 =?us-ascii?Q?tMPnb2CVHfjh4iQpZCtI56vzBQJyxDG5fszIcjC2wgjhCc4hzp19QhAuDPoL?=
 =?us-ascii?Q?CLaSlhOsA/58PP2ohtmO8o6QBlyViRG6dNxsJtfL3d4e1hmJc4uQ4SAhjAhr?=
 =?us-ascii?Q?RVLZtl9sNKg8zipcMSWmrxrHQstaObJmvDrWY9hh08OJe9Yrrww49Mtt0BGd?=
 =?us-ascii?Q?Gp/B4iLzt324rK5eFsLZHti7/ssSD4BKQhqikCyCNqry9lcypDkuiX6EUtGM?=
 =?us-ascii?Q?6EOErHE1WoKn5YeV3tVIRENO0QBYPj+AFJfFW0FQBRCMCLVwp7U1Gj4hmVz8?=
 =?us-ascii?Q?gLxBYgeMmJ8LWDoCgDnqeKzq5LNssJ/un+5R0VUJxhSMqHBYPM5dUI0xG7oU?=
 =?us-ascii?Q?DxBH2la/fzPVF3cAAWcrOiG4Bs0EhMxQ4YrqKzWN7WZR2IKMJcZb9qIXLStZ?=
 =?us-ascii?Q?pXnsH4NgfgyhflQ3f5tIWKq8EUZ8SWxZwYtlFPBLc43GkZ62LkEYn9Wzm3t8?=
 =?us-ascii?Q?IZF575d8FIA0hDVXr5Y8JDOAWmCFmDNpNFFNNq5dyE7c9Eu2qdc1nqUBRMkz?=
 =?us-ascii?Q?ANFNyULc4gBJ7Z+E2OgqezU0EHVnFpys7mOI7cxuxcudrEyzMKJZ2eDNHVu2?=
 =?us-ascii?Q?YsfunMTrFrFF9GlS2/To3BwWorqVcjMEHdRXMusv++cHboXV0XH5yfk3+7Hc?=
 =?us-ascii?Q?3RxNWDJBHIzQ/4ClFxOmyCurLBCxv0noEgsqp6ACoWfcifHE4TbHB850hs/E?=
 =?us-ascii?Q?Dmbv0SeVsQPOIvTB8AialwLwhGHRSKYbqlKaUMuJoMT7NWmifDDTLKTDBOlC?=
 =?us-ascii?Q?4ALdjNPuuDfUgGMw1NFWC8Fmxc9uV7jIqNYgKdbPsaSqpN7PL7H45KCRUNIE?=
 =?us-ascii?Q?BTRaK4MpmWG0KTJC1OKWaNI6yyOofj6p5uZUhEIpNls0sLGzcc6QpPCTKdRo?=
 =?us-ascii?Q?zt3HLCWSk/CwrKLbquk2z36Z6JNjND+0RiGGO5DbslAAZkG88MjvxPPOY1WA?=
 =?us-ascii?Q?q8hkiem5qIqKNmq5o3WYQcSP21JsoLtZiOihLlZhlLK+KGAHym/E4+xaTgJE?=
 =?us-ascii?Q?CMTwKZmtoqu4jTqf2Mtyt/YRrEyRWaI7uXMV8xED6e55XHYbEb62Y9lWb/rF?=
 =?us-ascii?Q?S8AfVmZgllyV0OoNZh7EezkcDAfZoUatKPd+/ap2OsRjx/FvKOf+mpUqbcQg?=
 =?us-ascii?Q?IBh0qULFVMSJtIYmnuePjpz5IJ99/hrzfPK61wECCkmSiPRss1IdyYVDSY4f?=
 =?us-ascii?Q?KGDsH2F7mHlAN1B5Ob1vpUJYvjU+7vSCDRDoQW0XOZd+ZlAPr5DiETtKliZZ?=
 =?us-ascii?Q?rHHbzIIcG2CdZek9hh0wkVKD6eQqeR/yBA1/sJ/6X0tjLsGBHOjD0fVBUHGD?=
 =?us-ascii?Q?/XyHr+QSYR6ceGyVeNrSDUSiD9RRnT/cXdJAGyZxRcTcDH4bUBdVKzqbf56y?=
 =?us-ascii?Q?VMiYLFjuz6oIsxpcBHj9OqbO1TmB6ij0RrnB+i2XpJZ8EE5L2IZFkgdd5zBO?=
 =?us-ascii?Q?0P1vGSeMVOKd9sUm+QbB7CwrWAQl27cHfl2RXOGJUMqOKkvufcH/UAvtMdVp?=
 =?us-ascii?Q?glVM/qGdsNCx3FLG8ldCDSNiuFb1HbkjyWmxe8D+xgmtXz0wU4zK3dDRYSxO?=
 =?us-ascii?Q?BKfb5TBYfh+wOb2Be5HznU+fCWA0xPZw11meThB8ej5afEjBU+elbCCIH3IH?=
 =?us-ascii?Q?K1wIiib2RbExUq91BrH9l67BKXWc6p2+OQsy87TMKUrl+RJkOBA2rI0+lTXa?=
 =?us-ascii?Q?NpWEnimp5A=3D=3D?=
X-Exchange-RoutingPolicyChecked: XzpTZDaHy8uOauEKxhGum6GaQcc9bfOPeJZVjiBlY3MHUZ2yiTK15rHpmk5RRQ1Oi++A1KtMdIME7rSM2Z30THhidymVNW65XLhXz8n+hLdBmfKqU+inqnESiGXQOnqQSFLeM/zFjGC08V/ZDmfCsh1S4sh/6UnWZQVzvJ2Cg+fhgQ4YVGTvoW/abbulDCGBpauxELn+C3EiB7INBxNy7GD1UwK/9Un3/wfmyci1UL7BKP/McyJVkI81rFu1RI2kJki5zn29VMyqgrJ0penvNTC/+EsIXu5edC1mIGIJFNG4pDo13K6mqs0vcza6SmpeISdce7FYR8njeaO2rC2ITw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 62aab4b3-c5e9-400f-c7b0-08dedec22f53
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2026 20:31:13.3934
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vaaJsPudZEQSIHqq3JduhUQsY6oLhsT0RuOOFzunZVpkxUWI8kbiMPffRNfK8WwjqZLkt/pGkDYifXq5owqXiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5148
X-OriginatorOrg: intel.com

On Wed, Jul 08, 2026 at 03:47:51PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 7/1/26 2:35 PM, Tony Luck wrote:
> > File system code calls resctrl_arch_mon_capable() to determine if the
> > system supports any monitoring features.
> > 
> > x86 architecture code sets a global flag to support implementation of
> > resctrl_arch_mon_capable() but the upcoming change to enumerate AET
> > (Application Energy Telemetry) features on each mount introduces a new
> > corner case.
> > 
> > Specifically when AET is the only monitoring feature, loading and
> > unloading the pmt_telemetry module between resctrl mounts may result
> > in monitoring support enabled on some mounts, but not on others.
> > 
> > Replace the global flag with a scan of resources to check if any are
> > marked mon_capable.
> > 
> > Signed-off-by: Tony Luck <tony.luck@intel.com>
> > ---
> 
> ...
> 
> > diff --git a/arch/x86/include/asm/resctrl.h b/arch/x86/include/asm/resctrl.h
> > index 575f8408a9e7..a9f481b7a8ed 100644
> > --- a/arch/x86/include/asm/resctrl.h
> > +++ b/arch/x86/include/asm/resctrl.h
> 
> ...
> 
> > @@ -66,10 +65,7 @@ static inline void resctrl_arch_disable_alloc(void)
> >  	static_branch_dec_cpuslocked(&rdt_enable_key);
> >  }
> >  
> > -static inline bool resctrl_arch_mon_capable(void)
> > -{
> > -	return rdt_mon_capable;
> > -}
> > +bool resctrl_arch_mon_capable(void);
> >  
> >  static inline void resctrl_arch_enable_mon(void)
> >  {
> > diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> > index 9b9495174041..60d50ac79e7b 100644
> > --- a/arch/x86/kernel/cpu/resctrl/core.c
> > +++ b/arch/x86/kernel/cpu/resctrl/core.c
> > @@ -51,6 +51,20 @@ DEFINE_PER_CPU(struct resctrl_pqr_state, pqr_state);
> >   */
> >  bool rdt_alloc_capable;
> >  
> > +/*
> > + * Need to re-evaluate on each mount whether any mon_capable resources
> > + * are enabled.
> > + */
> 
> This series introduces a significant change in behavior of this call and I
> find that having the declaration in asm header and this significant comment in
> arch code to essentially bury very important information on this
> call's usage. Could the declaration be elevated to include/linux/resctrl.h
> where its function comments can provide the details on how resctrl fs
> uses this call and what its expectations from the architecture are? 
> Basically this series causes resctrl_arch_mon_capable() to possibly return
> different value depending on when it is called so there needs to be
> a contract between resctrl fs and architecture on when resctrl fs can safely
> call this and expect consistent results.

Ok. I'll move declaration to <linux/resctrl.h> and add comments on usage
and expectations.

> > +bool resctrl_arch_mon_capable(void)
> > +{
> > +	struct rdt_resource *r;
> > +
> > +	for_each_mon_capable_rdt_resource(r)
> > +		return true;
> > +
> > +	return false;
> > +}
> > +
> 
> Reinette

-Tony
