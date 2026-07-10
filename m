Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA1BD380FCA
	for <patches@lists.linux.dev>; Fri, 10 Jul 2026 20:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783716900; cv=fail; b=lumnfESYnLiVSZk5CrdWTpyh1f3uigzQwQcZeoKmfVUx0HJbeD5joTo28wbPOKEvz/tgSOtqwBDk3X3WBpUdUe4M3xH1rn1WR5Y1W41MnU+WL43sS+a6V7QWu80222725iu9WWLJraffI2JBg3ipbrtHw2BxLDDsElMWsf6/YJ0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783716900; c=relaxed/simple;
	bh=KWajme0zR7LQ7ZTDiDLK5pGB2jgm8kNxJf67RxB4P/0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=i+FwuRVUlO3GajHLtfh6rjqawsB+2DiT0lr39GIufDHU934P/ad7+F3psHhLHMARpcako9sy7vTStY+FBWlXEh2VSJU/GDbNPmrMwwzC7xDCami7lcLhbapNIERFSLQ4KA1c2A/b/i/zjj5eWWja6wJUhZCs0B25I8+xqCzdnAU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q9XRqZD/; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q9XRqZD/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783716899; x=1815252899;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=KWajme0zR7LQ7ZTDiDLK5pGB2jgm8kNxJf67RxB4P/0=;
  b=Q9XRqZD/aBa6h6wdDnmKQaBk1rie/F+lMj5juWd60scUf9WhhgPbF66Q
   dewtjAONLpXpTXVsbvO1gc486Qgb2WnBHjIgQCluOea6ONseUnFJVQRto
   K8IvXb/IAOOlWmuap6RrT1vaiBGWyyAZvgvweA5qnQbAxbIRvbQ6EQlKD
   XslwxqNpa4LiwNWGCSc9tO8NMFKhF0mhJqJkBW1Qmi4UIGQJmHb+bMz0k
   PNTYAdvVKdrYw44bb99EUSdVO542iDsFmPzEabHck/TRXR9bPt4SyOS/h
   PGUsC1+KvBlWh9bG5fxyUJiGCZFzNb03+hL75KlqsasQvUKftgd/nr6hb
   Q==;
X-CSE-ConnectionGUID: Gg6JQQ0eTIS0Gh+ol1qO7w==
X-CSE-MsgGUID: Y1SjesOfR3quD2KLyMvNMg==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="84389562"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="84389562"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2026 13:54:59 -0700
X-CSE-ConnectionGUID: 36bURQnDRrKhpwzyXppcIA==
X-CSE-MsgGUID: uZaLWegvTd+2YTPvhl7QKg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="258855399"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2026 13:54:58 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 10 Jul 2026 13:54:57 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Fri, 10 Jul 2026 13:54:57 -0700
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.23) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 10 Jul 2026 13:54:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qfdE0jhBZABpwYmcgNPLPFlh5evte+IYy4TMa0vQama/J1ZJ1nv0RyJpbsL/6ynoG/sV9BGd6uV4WfNk+M+x5MZFwllxdTjErBWYUY+7pPxb9MSa5yekF+9Fg64LHoSHYG7Kar1F35LpfOudvsNb2Tq6b3awICv3jseko+P13S3M2BHGMxKg9PTncQILdQaj/MSL0VjLRS/NcUUwQbdbKWl3ROqxshhQb0kZwLVrl/mMgKoXICXtGziSAxIiiXcG6qZ4n+bsqVaXpWjExcxbaf5hLZv+HCXt2OTrPKsuExhXdVTI+JvvdKqi3HILQxU9XUbve5a2ZjBH1LvrbriZWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0LlsnTlqrnLHU5ku1sjas9ayD7vksFLHQbbyW7RIIUs=;
 b=k+u3JgotBTNOa2VTk3fjq+VKEihRil5byoJkB3Ch4UqCAUkYu8jODn0EoK+vL3yuWmOeziLOg9r6IQi3Q0goEeBl5F6njcdC0/6ywwr49WkoygHMkw1o9Aa3hVETMI9C1XjSwPqC4JvcpO6M+Flimo/GGo4LrZpHKOrJXBTubP0AjQ+cJtLZ5fjlpaFfAyWDMQEysLsIs6Kf49z1FxN+JBIWoQqXa7ONhQBh8i9Nq3zE6ElhYDbd+NXmDpkpu7z/BrO/VeTFbjnD4KOVH/YtH5dUMEoWu+PWeEe4Q3qQfg7lfeZ0AAK/4rAqB4dQOUpILzw+5dodR+MmeJXGACuOYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by LV8PR11MB8509.namprd11.prod.outlook.com (2603:10b6:408:1e6::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Fri, 10 Jul
 2026 20:54:54 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%4]) with mapi id 15.21.0181.014; Fri, 10 Jul 2026
 20:54:54 +0000
Date: Fri, 10 Jul 2026 13:54:53 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v9 07/12] x86/resctrl: Add PMT registration API for AET
 enumeration callbacks
Message-ID: <alFcHbGmaDXygQpL@agluck-desk3>
References: <20260701213553.15222-1-tony.luck@intel.com>
 <20260701213553.15222-8-tony.luck@intel.com>
 <b128216b-cc06-4e6e-b6b4-498a6e135d16@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <b128216b-cc06-4e6e-b6b4-498a6e135d16@intel.com>
X-ClientProxiedBy: SJ0PR13CA0117.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::32) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|LV8PR11MB8509:EE_
X-MS-Office365-Filtering-Correlation-Id: 88fb93e4-1007-46db-7034-08dedec57e7c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|23010399003|376014|366016|1800799024|6133799003|56012099006|11063799006|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: xuHzly3yPmkI6iVx0KGa9yte91xk+NTY0UQ7QC5NOm3oSfLkjX/l9AE68mNZFK4LtqRCQ6CFuEDrLKrcSc+tgmLNbaw5VXgStFglaqyx76bPscC82xwCrwQIzv4Y5A5/bjuNYZYirzRurQjQN6Lo+j5yjh4vjEEKFQAfJT48BOXBGVmRy8DNXHgUdg67VfffMvIEDMZz4YgbnC/aMpz7LHiqv9IdT+tDhLIM3uzH8tKlwj6At4MELIqCz7SNPxKMflwp4HsZT5LEaOv5klyANLqdrQCnNHp0x2uzau+PoSMb2FmqD7/ep7u7O/KnzLtYNIyXBzfN80N5fM1C2gDQEqevExTwWV/gfyXiGwCcgyvr8ChAa5mPNkYT3jFhZBhXQ29+vQ20mOqNfuFbwV7NhpNMEm5orp6GyOmm0JrCwxjnXYxRNv0qllyjJerfpPTaRaW6xPolH7M0zmYgc/Vwo3MNPdGPUyao2buYz3ExeONl1hbB50Shzx+8+g6e87taIbqqVwWRyoNLG3UXFIkaLm/EIrJjYmmKGBrs0zndRnrU+IeB2StB11l6AfJkimGmIi7UGXpV6/OnKCF/d8ERvvKQVzjYS3SJS8aVmKOQZ+9jyK4kaNuQOw2DD9GqbwZt2JeYW4bpqe7Lgj1IjiJrL9vGG227+HpzbVipRe7Aa7k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(23010399003)(376014)(366016)(1800799024)(6133799003)(56012099006)(11063799006)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IDSUhKahQaQwYQyZd9WSa7Q7u1FQINU0J8sZKp1IBqET/ABJM2ym9mieH8ag?=
 =?us-ascii?Q?aapDBCo8b9CMPi4lPxswO3ijlKRiMJ9lSscI5Qx6RV0dATcxbWBB4IVEoPSa?=
 =?us-ascii?Q?FLX0BxqKETB0JyIVps4c7IpduebkXLbTpNoFo3c9sQysIAXo/rNSr4ALVfP8?=
 =?us-ascii?Q?ceWBhZ6YAznRfogBT7xaZXfGjub2t4xjd71YfipBTNkR5P0qeAzPsiMf64Jt?=
 =?us-ascii?Q?Z8HI4HblcsPCvCBXDN87Y5Wf+f7YFQ4ddx1ZdTqLfPYcoApEPP+E9FGhfB/E?=
 =?us-ascii?Q?qGIY1M2YtnNzfkG5Yir/WS4s2/GVMRxUqOm8FIhJwnoXRkLtY68tOMql3T6m?=
 =?us-ascii?Q?hFQsRdQJuDYcdoJ8KA6yqzyccqFPWUngDBTL/VuOgZudWN/xffF0fpnFvu4Z?=
 =?us-ascii?Q?Qm3Hzd8z4IOazxqJ11Z7esqzkYRQGgApiefmhXUHhaApGRQMQQRmzAaMw0Pb?=
 =?us-ascii?Q?J4T3PtSGZEBFn6yf6oHQV7ljDwADQXtvwN4dWu/mAoB+miKN5EWHXsxA7DfL?=
 =?us-ascii?Q?GJxVWnfksx80EtZZqHrG0wuUUzmZRmWoyugw47644e6SowHfOvp+wH4iYBoR?=
 =?us-ascii?Q?/EPU2gQn7Q5z9kYo8oWDh1Q6RQHPSKXgsgbTyJs3uMJgTvgtALPLPnJor9CS?=
 =?us-ascii?Q?P7Eb9DYgDo4CPB2cuyYsFWnmiI7HxIMZsIgBZ9andFEiaeFNuhZCMOwdmiDX?=
 =?us-ascii?Q?9T4bhn9yBbYlh6NYUyTO9gNpVjKfe8pKpsU3dscwiFBVF+zzvrD8g5/vpYzH?=
 =?us-ascii?Q?F7DDuuPZr1Qo8jBcoc+l4RnRZVARKN300xHXz3WXHBuTjJLTQMMiFu29r+cf?=
 =?us-ascii?Q?LRp1V+Tea3f53oiFJpZNReRBMcA41R2drL2ajRBdSOBShBDOPaHVZOwaFINt?=
 =?us-ascii?Q?uKR1L+6xHAAg8cgvjNEhMiPXhDsvzx6LqMMqEPWZ1K+WbLYLbiBPtozRVrUk?=
 =?us-ascii?Q?SFSff39VPjf4G2eqXPtH3J4EbbGmJyikNwlL7+KzXnvFYaQUet643tulPHJK?=
 =?us-ascii?Q?TLZPX3BHH0oUUy07sXXdQ9efgkSJaCLy1UGWBv5PKoRbyK9ge8mgkHBYIxJV?=
 =?us-ascii?Q?IrSIv8tP01O5inO89xkpWJkmtIxOTOf5jl6W/sXaIJPKRN3HtvBFhMUozk6t?=
 =?us-ascii?Q?ho+CK7HAnc1IeWd2HllufvJnGxd4dynWByBGtBUJWNiI5/CQEXS/9fiAf5mW?=
 =?us-ascii?Q?AUrSPjVZddK5yqvei1/qm5jQZH9/xVTBtGlghkqS3oulaWrZO4XD2+0bmzE0?=
 =?us-ascii?Q?5PYar9AJxxVfJEscOpkaoCtmbGxMIjz/86b2tBTerBmSz2VT7A/4KQIncvkC?=
 =?us-ascii?Q?fTDCInLJnZ+MWeyOsdppCVIYASREbirokKpLcCEK9cyw5SGmDcG+CuqeWYaP?=
 =?us-ascii?Q?GUYON/UlwaOWIIdXv3YOV9CJmu/Bva6ZFG7m4czOsYUw4imPHQoOubw/3BWL?=
 =?us-ascii?Q?tiUrB6BGaUWZG3cpf1U53WPlxGFMNquPOAJ2UP1t2JaeZGmxtU58CWm3wxLl?=
 =?us-ascii?Q?/l0N5MmIKmtyLrTkuy0rlXZYwQ1f3DBEzUC4s72auEShcXUEYrWazDA2jbR3?=
 =?us-ascii?Q?iOS3ciiPKIDOaVCfYte+nESfRwmHpIMT6mcRv7Oyh3U78dpm8KYILJGdKvzF?=
 =?us-ascii?Q?o2lh9N0b4/QNtU0f4Jf7wxelRZ7igdLljHvDTi6kDoLMjib3PBSaiEX6CFd3?=
 =?us-ascii?Q?b/QQeWPfMCztNffRFN9gLkLoZA8IJGtYYb1PIbNw41nBgMSrUtwF58WgbCFz?=
 =?us-ascii?Q?lsRckq1UlQ=3D=3D?=
X-Exchange-RoutingPolicyChecked: OWmIu1WzU19M6dNTQRay11M9goe4nHjeG0bpgI4ykeqeuw8cwCpNZy0FI6QB3HMDeRePo9gdoeq/I6qajaLIC0B4ooPpvqw6i5zg4LUdsFcDCdMAUgv5mlvImeI5rAqoJy0Wg/LZW4q9f8OhIYoZdCCvzeltKpZT3h3vnl4/BKLIEjTQhE+yVvAkyGZrBYE3eVT+aM11Xe2swu/C0Ock4UBmz+NH/NI/kM+he4MGhH5vfSFRU/DrZy/xAAk6Jc1LknDMyei1GJwDypVdOl5m8oTvXlH19N2oLp5GJ9NSEznWXlNOQPO2ucNea9k293SIIhP4P7hf7+XhFVsT8Qsbxw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 88fb93e4-1007-46db-7034-08dedec57e7c
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2026 20:54:54.6396
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1pnshkcr3E7L0DqcaK1ApARgd/owDmvFNzDIdmavucn171elNqVuNjX7sp/oZMjy2wew7SGi+shwHl/AQUWu8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8509
X-OriginatorOrg: intel.com

On Wed, Jul 08, 2026 at 03:51:22PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 7/1/26 2:35 PM, Tony Luck wrote:
> > resctrl is always built-in; INTEL_PMT_TELEMETRY may be a module.  Add, and
> > export, register/unregister functions so the PMT module can supply/clear
> > enumeration callback functions when loaded/unloaded.
> > 
> > Suggested-by: Christoph Hellwig <hch@infradead.org>
> > Signed-off-by: Tony Luck <tony.luck@intel.com>
> > ---
> >  arch/x86/include/asm/resctrl.h          | 22 ++++++++++++++++
> >  arch/x86/kernel/cpu/resctrl/intel_aet.c | 34 +++++++++++++++++++++++++
> >  2 files changed, 56 insertions(+)
> > 
> > diff --git a/arch/x86/include/asm/resctrl.h b/arch/x86/include/asm/resctrl.h
> > index a9f481b7a8ed..48ad55bcda66 100644
> > --- a/arch/x86/include/asm/resctrl.h
> > +++ b/arch/x86/include/asm/resctrl.h
> > @@ -4,6 +4,8 @@
> >  
> >  #ifdef CONFIG_X86_CPU_RESCTRL
> >  
> > +#include <linux/intel_pmt_features.h>
> > +#include <linux/intel_vsec.h>
> >  #include <linux/jump_label.h>
> >  #include <linux/percpu.h>
> >  #include <linux/resctrl_types.h>
> > @@ -189,11 +191,31 @@ static inline void resctrl_arch_mon_ctx_free(struct rdt_resource *r,
> >  
> >  void resctrl_cpu_detect(struct cpuinfo_x86 *c);
> >  
> > +#ifdef CONFIG_X86_CPU_RESCTRL_INTEL_AET
> > +void intel_aet_register_enumeration(struct module *module,
> > +				    struct pmt_feature_group *(*get)(enum pmt_feature_id id),
> > +				    void (*put)(struct pmt_feature_group *p));
> > +void intel_aet_unregister_enumeration(void);
> >  #else
> > +static inline void intel_aet_register_enumeration(struct module *module,
> > +						  struct pmt_feature_group *(*get)(enum pmt_feature_id id),
> > +						  void (*put)(struct pmt_feature_group *p)) { }
> > +static inline void intel_aet_unregister_enumeration(void) { }
> > +#endif /* CONFIG_X86_CPU_RESCTRL_INTEL_AET */
> > +
> > +#else
> > +
> > +#include <linux/intel_pmt_features.h>
> > +#include <linux/intel_vsec.h>
> 
> Are we sure we want to include these in arch/x86/kernel/process_32.c and
> arch/x86/kernel/process_64.c when resctrl is not built in?

I'll look at this some more. Maybe this code needs some X86_64 checks?

> >  
> >  static inline void resctrl_arch_sched_in(struct task_struct *tsk) {}
> >  static inline void resctrl_cpu_detect(struct cpuinfo_x86 *c) {}
> >  
> > +static inline void intel_aet_register_enumeration(struct module *module,
> > +						  struct pmt_feature_group *(*get)(enum pmt_feature_id id),
> > +						  void (*put)(struct pmt_feature_group *p)) { }
> > +static inline void intel_aet_unregister_enumeration(void) { }
> > +
> >  #endif /* CONFIG_X86_CPU_RESCTRL */
> >  
> >  #endif /* _ASM_X86_RESCTRL_H */
> > diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> > index cd8257c58f84..c26bd813e057 100644
> > --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> > +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> > @@ -12,17 +12,21 @@
> >  #define pr_fmt(fmt)   "resctrl: " fmt
> >  
> >  #include <linux/bits.h>
> > +#include <linux/cleanup.h>
> >  #include <linux/compiler_types.h>
> >  #include <linux/container_of.h>
> >  #include <linux/cpumask.h>
> >  #include <linux/err.h>
> >  #include <linux/errno.h>
> > +#include <linux/export.h>
> >  #include <linux/gfp_types.h>
> >  #include <linux/init.h>
> >  #include <linux/intel_pmt_features.h>
> >  #include <linux/intel_vsec.h>
> >  #include <linux/io.h>
> >  #include <linux/minmax.h>
> > +#include <linux/mutex.h>
> > +#include <linux/module.h>
> >  #include <linux/printk.h>
> >  #include <linux/rculist.h>
> >  #include <linux/rcupdate.h>
> > @@ -291,6 +295,10 @@ static enum pmt_feature_id lookup_pfid(const char *pfname)
> >  	return FEATURE_INVALID;
> >  }
> >  
> > +static struct module *pmt_module;
> > +static struct pmt_feature_group *(*get_feature)(enum pmt_feature_id id);
> > +static void (*put_feature)(struct pmt_feature_group *p);
> > +
> >  /*
> >   * Request a copy of struct pmt_feature_group for each event group. If there is
> >   * one, the returned structure has an array of telemetry_region structures,
> > @@ -325,6 +333,32 @@ bool intel_aet_get_events(void)
> >  	return ret;
> >  }
> >  
> > +/*
> > + * Defend against races between pmt_telemetry register/unregister and
> > + * resctrl file system mount/unmount.
> > + */
> 
> Please help developers understand what this mutex protects. I am not able to deduce
> from above when this mutex needs to be taken.
> 
> > +static DEFINE_MUTEX(aet_register_lock);
> > +
> > +void intel_aet_register_enumeration(struct module *module,
> > +				    struct pmt_feature_group *(*get)(enum pmt_feature_id id),
> > +				    void (*put)(struct pmt_feature_group *p))
> > +{
> > +	guard(mutex)(&aet_register_lock);
> > +	get_feature = get;
> > +	put_feature = put;
> > +	pmt_module = module;
> > +}
> > +EXPORT_SYMBOL_NS_GPL(intel_aet_register_enumeration, "INTEL_PMT");
> > +
> > +void intel_aet_unregister_enumeration(void)
> > +{
> > +	guard(mutex)(&aet_register_lock);
> > +	pmt_module = NULL;
> > +	get_feature = NULL;
> > +	put_feature = NULL;
> > +}
> > +EXPORT_SYMBOL_NS_GPL(intel_aet_unregister_enumeration, "INTEL_PMT");
> > +
> >  void __exit intel_aet_exit(void)
> >  {
> >  	struct event_group **peg;
> 
> Reinette

-Tony
