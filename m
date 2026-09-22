Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 658FE429CD7
	for <patches@lists.linux.dev>; Tue, 22 Sep 2026 20:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790110012; cv=fail; b=CQYXTVrABsGRfQY/PCoJdqjgWnwV8ztAN8H1PwqFLlExESrwNKFyDw2dEUcklQ8DyqcbVhbelUsJnNlydZGAS/hGfEumI1miBV5Woj6HvWDfGhGhEPY7JKuLwO/Ml3dQmLvs/J7abf25sGZXqQmaPrN4Da7TYHBNlycEcVVuFgs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790110012; c=relaxed/simple;
	bh=onWsmasfZrQNZq1oSM4DIXKpo6Pv+NOPq83XlBJyMt4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=isY5765/gUEclvWzxVzh39N6Znf8cKJqg+gSDzmf8seTPoDGxGIYTuwZqmz+12hi8uJC7A4Q9qo7TUGP97uxBCBHUds1JFyOdfKzEr3YgepsBGfiGbdwjMKjALHyG0UW8oujVtM1pnWHStsq15SlCfhW4d8lEtRvldv+6zRqlEk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KgfbhMQH; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KgfbhMQH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790109986; x=1821645986;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=onWsmasfZrQNZq1oSM4DIXKpo6Pv+NOPq83XlBJyMt4=;
  b=KgfbhMQHt/V6PVLf0O4Reh+6qXaqf5l5OLooTxUeTYts9j3Nyz+u0pIe
   5uEzvvUvcdOTL0CIpOg41+WmwiBWunVsKGrpVJHPTRxxDdtDjsfeggv5f
   KY6pOZxJAVB5biRrIxlHIIMJf1FEwOS9bZO5JEqP6frv0+9gN7DNDstF4
   llZTycJTpCXc7wHFGTjFuR4O+xYX8IwhS7eb2g4yiUtrR3zDgPp610Jug
   w6i4/SwG33KPZkZ7mNirvylakNA6S8rpZcClN/Z3pD2b+C6dy1RdOWCoe
   TGBDEpaGY0Fk7YY1FGA3M8JR8bgH57MegEpPvxwSH/ejKunlgmHOT5o3m
   A==;
X-CSE-ConnectionGUID: t24dcywpR7eBw/YrI3Ve7g==
X-CSE-MsgGUID: g9gZkhQnQlGPWjkgLOkRMA==
X-IronPort-AV: E=McAfee;i="6800,10657,11913"; a="89670453"
X-IronPort-AV: E=Sophos;i="6.27,117,1787036400"; 
   d="scan'208";a="89670453"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 13:46:11 -0700
X-CSE-ConnectionGUID: APuw6WU5Q7GutaTlH4Z+DQ==
X-CSE-MsgGUID: 5X99N2izS4e18JYS0ZkIxA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,117,1787036400"; 
   d="scan'208";a="301212676"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 13:46:10 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Tue, 22 Sep 2026 13:46:09 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Tue, 22 Sep 2026 13:46:09 -0700
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.61) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Tue, 22 Sep 2026 13:46:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ebjux6lFusdtYmrG5maeDpZmp6DTDdmGghCj/0i2anZXuKKJvFgBfjAcHC63WAkNImK/WcJ+kgOhzF/AHB9af0zWJG070O9pipbLadl91quSiG0Cx2fbhPEpuSTQ9o8x5zWpZyS81kgir0p6YIkPUhy6UMWk0qn0K8Ou1t7jR06XQYqcfkpmDqFQxB97XK9VbdpWZ8fh40x9R5pfqAYpzcAQKqbLYuw32g6rfxNlel9lAdUoLOrJ5xrjVj0Zv/IPSEXQSV53szV5/Xsj1CjgiIK146PzVpacg9xm99fWimAVIFGYUM2V89Fa+e99SfBN84CEU4+aUM5TlhlC+F3Sfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=clmW5jFQ2/v2fLsOgu+/EvcB5eEeTEbn+feXx3e1JMs=;
 b=pVhgys2SqhYeS/T2JvVkrjJzuhglF1IqVwcAEHXbIOg4fiJ93/7jJPYqe/HyVtBlqg9AU6eK4kTvgVKfLLIiJH4O93RZXVX3f0mpzR04cAn4v/26xZnGNJYN2Amk6bvcg8Ukt8yge/xYQ/oIfVCsL4QDguoBVmabxHc4SVkE3/qX4BNSnsAdNqoyvu+N8Wqcwjf1z8+6o99rGwPxcqD3FUO00MY4S2luVrCbuX7MjGgx4KhRGCGBKMR76l5fylFsLsureR63k1v6vzPbm3VtQulns/YKQqCLiRmJ8opaNsEOaaB7XjXaAvsU95cklUJmes2hF4WZmIiNNZEIu/9aAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by PH7PR11MB7663.namprd11.prod.outlook.com (2603:10b6:510:27c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Tue, 22 Sep
 2026 20:46:02 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%4]) with mapi id 15.21.0451.014; Tue, 22 Sep 2026
 20:46:02 +0000
Date: Tue, 22 Sep 2026 13:46:00 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Babu Moger <babu.moger@amd.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Reinette Chatre
	<reinette.chatre@intel.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Drew Fustini <dfustini@baylibre.com>,
	"Dave Martin" <Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E
 Box <david.e.box@intel.com>, <x86@kernel.org>, Christoph Hellwig
	<hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v12 04/25] x86/resctrl: Apply Intel MBM quirk from
 rdt_get_l3_mon_config()
Message-ID: <arLpCDOPyKuOHc37@agluck-desk3>
References: <20260916231320.14502-1-tony.luck@intel.com>
 <20260916231320.14502-5-tony.luck@intel.com>
 <8e553b96-0755-4d23-967f-5d8a7a725474@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <8e553b96-0755-4d23-967f-5d8a7a725474@amd.com>
X-ClientProxiedBy: BY3PR05CA0047.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::22) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|PH7PR11MB7663:EE_
X-MS-Office365-Filtering-Correlation-Id: fce45b1c-894b-4d26-be72-08df18ea83b5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|1800799024|376014|7416014|366016|11063799006|56012099006|4143699003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: /B+MmJZAATIe7zI3DzYIxRmN92Z5kjzQweqSTL1EstIfxa1d5gpcJztUJlInzadCuWMQFce1UXxGd69l3DyMU3g+tLswuw9IBSpvDVy+KWsIN7jvf34clJMsnM0lY5NMb8WYo2uGuKTidzrcJme5WFX2o3or/j16QJ2zsSxn6pmWjoRLrTshauUl+3yqDbT+Crbaz08NDMgILno+0SIVeLueGRtSuGjZTJnHWlwMvSJuYfznuSt8eE7gp/lvU9HBOGTKgC+61Z7WALlUlLzemTz2v6lfbqz2C34o4Nuv+T9ziq9ATTd0Xf9anlWJdQ6fw5K6byIesckaSbrSdv+z4NEXtgs5d3lBQBaxWZL8qSaMnke8uKPK9BBVqWqZWc7/JJz1h0MyHN2heSXqltL0OP1AmWqF5Xz6hykRqwY834A0bAPMtkhW5bvZjfMAsQx1gibs4rRhpcKP6rG0zOQvLtvzoY4VcAOpjpnP3o99HsPtYo0yM3oX6mt/usXk9WfJ9hyBz2Bz3PxhX1oCNaoUJQfoGdPUy8BBvwpWpFOPs4n04Fn6zoFDETadWZP015kPVUSj3DRc3PtDSEX941t2fUg2H/n0ow0U3sq5ZGIXVoM3TNGMxuO0Yzi6JW6WgixQllk2g2oCStTvQbCZHEoWTdsNxpIRCnD360Uwt3mmfIE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(7416014)(366016)(11063799006)(56012099006)(4143699003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wLCXMStt0p1pT/5RtvBcX2Zpg2kapqXxGsFZJiReqGgthQ4k7bA8zbZ4O8wF?=
 =?us-ascii?Q?UcddoiXaEcl73YyoIfGRDInnciQUHylwaCjLYz7RcSFGuROIZxyZc+/dUtta?=
 =?us-ascii?Q?h8o8CzGqzHkKMZjyyYybnbNMaoxqyiF2MZFH+fGTmB1ZkiB81iI6UGQBOd+N?=
 =?us-ascii?Q?O0UGa1/aS06C/am44XYJRvabZLC+hPWrNgQ7CGVJVhI6OiKYXAQUSqdBwmCG?=
 =?us-ascii?Q?HGcPvfsBlFBVORymkMNrLkB8KPqVBqoHV0Meh77urNrjIpvwwoX2ku5v12VC?=
 =?us-ascii?Q?cWIpNgJQ/GTvawfuxs6T4vGTL25nuvyDEaQLdzdNQNxx/tbqPFM3e5ZSqMDl?=
 =?us-ascii?Q?/taCashizUiP55StdXWv4mmfbdWtcDe8t9rAcijsB+AaTSLMgL+BNt7JAUf6?=
 =?us-ascii?Q?fLkS4qbWpOhmlyJsV/5wwTD0/V3Lay/J6f/lftpAbVWv4McpcAhGuHtP+h8n?=
 =?us-ascii?Q?FF7C5bPJGl8TIYmdapuwRMY70N16amR7dn71rGlKGYZGblApwATfTCZdqUSY?=
 =?us-ascii?Q?JgbSWqvZV6NvWKA9AeP3I/BBkF0ceJPYEfmSHKsCXglHjX2EzaSIPPbtN/Li?=
 =?us-ascii?Q?j11AeRhW/zws9tjAT5ClSh8SzEgnl86l0VZeKiS5/QTrZZG6NFsPGWwDEC1/?=
 =?us-ascii?Q?3cW1DmzW10hU9qpZbjOs6mNTQ+Et3fpaQgLWFaUJb0EF0RK4xfMDZfw9Yefk?=
 =?us-ascii?Q?/7nIul23JMWMo2pcO23zXwsDNCGD+49QDk1HC/AdGFq4g6FlXBJxgnbnyMUx?=
 =?us-ascii?Q?yC3XKZABp6hrRkvSBN4S8f32loydQJ/hvAioFf2Z3ZhtXfR5n3kSMR7bEK4I?=
 =?us-ascii?Q?aNfguwMSR4gOE+lCXwvNMYHsKccLiRKOZvAsFRk2Hstt89nClhsiqmRV5fR1?=
 =?us-ascii?Q?AjgvLbCl7TzaTNKtUr4RNUjIWvgtANOBBrzDB28AOhwDnqtYOAo3/gooNxaM?=
 =?us-ascii?Q?qqdoywaFinvzLNng1R/CWUnEUNzeLxwkaguoa+rgqHaoX7XaEkX9ahQ8JYFD?=
 =?us-ascii?Q?eWVytWkPNNxFYSZ0eJc5rDS77shMkCsyyaLqUewb4c4bRrNAxPkdIkWI9Gz3?=
 =?us-ascii?Q?+s/D94YMvfeLR5HoqnaOzhW7/BUefb0ylNEZXs4GLsXSLwi0BAI4CxdvGyVU?=
 =?us-ascii?Q?oUl0ttlyudQs5xFL5vHKgUh2bpVJJDd/tnIZtRr6qwBjyBtiy+DSPZfsyRZu?=
 =?us-ascii?Q?a5JRQezBtHe3eLfFTsS6tpo94jSYQOJz9HZFaqZtpjkaUqANlYXkijjbcgdE?=
 =?us-ascii?Q?UPy9f5CosP5QC9/9wJGS+ewlCWxRrfppYZsOGduA+skTbbItnM0AHgUOUyRb?=
 =?us-ascii?Q?BVGSXGZelqgFC8j4rjd8J9RC1M5D3vG6iMR0nfcFMfRB+Q2ml+OoaFgAD+bC?=
 =?us-ascii?Q?x06/0vOIbcRcuEfYdY+5nO1OLIfsX0+43SP/4i7bLs/dbrDgzBasLzBGewvF?=
 =?us-ascii?Q?7bVudp+G5rHCqXUerErVjTBdJRPEmex6EugAMLDkkiU3Z0mFCOlxaXuw0QdQ?=
 =?us-ascii?Q?TX40uETt/E1VRkl/dYHHZ794VWQowN6Cu29PUpux5YtcH8J2tL5zTQKu3xbk?=
 =?us-ascii?Q?dvRKfBxRyHg2ur+biWRpxhFxrlZc4xsjBnvgwYhRBMHROCb202nSfS92htKI?=
 =?us-ascii?Q?wJr06ol5GO68NM/8HQX0RuL2pP/DjiMfhPmEtaxJdYQeTa+rTRNHuVqZMo1g?=
 =?us-ascii?Q?SXT5YZ/WnRyh+r/7g6JAPaGOb+Qo/P38hrG2JiQU9inA54l3tPGevBTeKLZY?=
 =?us-ascii?Q?iaRP4loZVA=3D=3D?=
X-Exchange-RoutingPolicyChecked: GVvCYYKQ4cfXsREFIp2cPFpc3qo/60E4dufq2Pvxut7uIzA4KMF5It8J7R7M81VsYWiD+e2gzYk5VHW4zSputsJ9zA0LeOaFA80G6o7FQnQTf15q29FQdoYypVy5rhwQ+f4SwctQ20Ji60M/IomMH0a+howEKwc1aXWEi30D6PDhfWzrDcGzqsNE5R6h1jzih9H3tZd47ZkQGyuedvyclZ1dPurayLmw0lH831Qf+yBiHp4MC4zgP0K5R12UWployvR6p508Z+fkwTBz2QdcLKiFwDGzV1OjUmpGvgmmdNYZxVnJ+5ZbJtSAAt32T6Belf5uQeln+WtEH8XHTeVAmA==
X-MS-Exchange-CrossTenant-Network-Message-Id: fce45b1c-894b-4d26-be72-08df18ea83b5
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2026 20:46:02.2520
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HyrhoEey1DuvvR3dj3H62jJ8qxIW2E/RGOTH3VoakxvJdaPDNW7BDmRVGDXgnRxH4IF2x1gECMjLzjzagd4dOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7663
X-OriginatorOrg: intel.com

On Mon, Sep 21, 2026 at 12:45:02PM -0500, Babu Moger wrote:
> Hi Tony,
> 
> I cannot test the AET telemetry functionality, but I have tested the series
> on my AMD systems. It appears to work as expected, with no observed side
> effects.

Hi Babu,

Awesome. Thanks for testing.

> 
> A few comments below.
> 
> >   int __init rdt_get_l3_mon_config(struct rdt_resource *r)
> >   {
> >   	struct rdt_hw_resource *hw_res = resctrl_to_arch_res(r);
> > @@ -500,25 +516,14 @@ int __init rdt_get_l3_mon_config(struct rdt_resource *r)
> >   		hw_res->mbm_cntr_assign_enabled = true;
> >   	}
> > +	if (intel_rdt_mbm_need_quirk)
> > +		intel_rdt_mbm_apply_quirk(r->mon.num_rmid);
> 
> Not a bug right now.  Is it cleaner to send num_rmid instead of SNC adjusted
> r->mon.num_rmid ?

This quirk only applies to Skylake and Broadwell CPU models, which don't have
SNC. So there is no adjustment to r->mon.num_rmid. Future CPUs are using the
ACPI ERDT enumeration of MBM which includes a mechanism for RMID scaling if
needed. So this particular quirk isn't going to be re-used for new CPUs.

Is it cleaner? It's a few less characters in the source code - so maybe.

If Reinette agrees with you I can change for next spin of the series.
> 
> Thanks
> Babu

-Tony
