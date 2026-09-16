Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD66F4B405A
	for <patches@lists.linux.dev>; Wed, 16 Sep 2026 16:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789576015; cv=fail; b=gn6mgl+iHAv0nFT0QYHvROeZFujaNw9lEt6wspfgTu4SvO3vqd1d9QETqX60UrucGIsaP+BHG13ysRISSXmlCJ4u+S/ksCOTmhF4t08vYWCX0pLJCtJrOYDad04rpC0AoG7xjqH9ejd+39/8KA3c9HedatG5SkanIFtGj9nVrLI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789576015; c=relaxed/simple;
	bh=jwDTbt0g9Cn3qSuNexURwDqVwPYPWyAxbJFa4gG2iz0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Je2Hi2ADwxJEVcuTxgwbdDtmyd/FtZW4XbjqHTdvmzBoE7BjnRe1qRU1KM554Yuj1oaC6MIOoc/pIwL0t2rdXMMUJDeGaPUPOSPWYSE8oFrHJ1KnR3kJ0lFZlOhaf4sZSEr7wx2Rqlh6NXq0I7KhfCtt3k2qY8CQGiEjyX0YMAQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PN57CFLu; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PN57CFLu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789576008; x=1821112008;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=jwDTbt0g9Cn3qSuNexURwDqVwPYPWyAxbJFa4gG2iz0=;
  b=PN57CFLu78BBx96OE95BKXrCt3PWWpEO/iqR9EBPVvnxMAg4J0IX3ka+
   bZE1kna80wCITPonYx08jmtjPaVSVjUD+Q56QcoI8QduXH1gryZQ6lYPo
   SwlJ6u8xnHbbiS5cTAKA9cI6wdK0iBkr5MPW3SKmROQJoPIvf9hkYtDZU
   ZCobXfzlDJqmIn1mwsVy2ZiVUlEf45+avkqdyxdQtTNnQ5MRERpxoQwAT
   SvM3qVvpi5dCwOZuSAjiHO6lcYSJlwOpoww3pWVKDX7TR0nbcDDWU34l7
   kJdpk9+tVtG+1VGEzyDD+jgHJFku25adS558gALLCjFuzumERRvshcFnk
   w==;
X-CSE-ConnectionGUID: rCaTx9gdT6eAQHhydkIQZA==
X-CSE-MsgGUID: 1Gw1aubmQBebUywIVp6bCQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="93831701"
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="93831701"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2026 09:26:45 -0700
X-CSE-ConnectionGUID: 9OPL1SanTHKsFWXC6A9KmQ==
X-CSE-MsgGUID: 7Ikc/Ew/TayMuBmNFIFvHA==
X-ExtLoop1: 1
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2026 09:26:44 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 16 Sep 2026 09:26:43 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Wed, 16 Sep 2026 09:26:43 -0700
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.5) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 16 Sep 2026 09:26:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kLhUCD88vtdlBLUC0yK1L5WG41bi3Y8pk8seCeOzu7vDDqawpuw5y6ipOZJsklcftCmYIQvliAxe1oWm2OIWeNwVbiZT+qE6wWSz2/eUKwX6uYdE+WokAVob14TbDPTi8rHOj8Uxd0XjwxxISCjIPgz8LFJDWsaeDKudVbG5IOoaw9Nc+s63wCc8w5uj+WvTtCRanUmu9AAU37Ut+HnFx0p17NIy2s/IIVGRPijZWFZQEKoQsv7V159tQcWGcIZcn3LdipZ5ZmILltabLjcQouBCUH8iaBCm3vYG+8wGTGpLAbvjilhZnuTx53xE2rWcOqUcBzfgGr51CEGFTFD+nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=akCk/+1YBq5fJjXzlFS9BVP7hGUtVzlmTqGLm9HeZ2Y=;
 b=K9dF3zcO4HnAyT8ebiBvFyFx46NNW38noUeFPfRGXJRbQCeVyB1Q8Vq4HOZy/CtEJYWcispmqkQnvDLjmHgY2R6PpYUO408iCj0xg+3N6riJ9/BAC1jxp426ocF0Y9GebCzBTIxn28piYtl98+6fG5pd6ecuPD27xZ6XeKT8YTURKPFpqlZvcjyGw9rC2ZCX+9ZjF1NvoOc3ZnM8HM139YY3IDflzNAX937QlipAhWoVoO1so6wmUcmdgijE8ODqkK8+ib7VSJhx3WUDjHRlrAw2wLRbl3lY7m0WL14BJ/lJrqArQrDVOky17mxGRJ6LK1EMVvXyis6YRRbo2s/Bjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by IA1PR11MB6514.namprd11.prod.outlook.com (2603:10b6:208:3a2::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Wed, 16 Sep
 2026 16:26:35 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%4]) with mapi id 15.21.0406.007; Wed, 16 Sep 2026
 16:26:35 +0000
Date: Wed, 16 Sep 2026 09:26:33 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v11 19/23] x86/resctrl: Export interface to report
 telemetry unbind/remove
Message-ID: <aqrDObHc99BX1Gmf@agluck-desk3>
References: <20260831174421.13921-1-tony.luck@intel.com>
 <20260831174421.13921-20-tony.luck@intel.com>
 <1a418996-fe0a-4553-bd21-9881ab182e51@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1a418996-fe0a-4553-bd21-9881ab182e51@intel.com>
X-ClientProxiedBy: SJ0PR05CA0176.namprd05.prod.outlook.com
 (2603:10b6:a03:339::31) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|IA1PR11MB6514:EE_
X-MS-Office365-Filtering-Correlation-Id: bf1a85d0-f3b9-4373-004e-08df140f4672
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|23010399003|56012099006|18002099003|22082099003|4143699003|10067099003|11063799006;
X-Microsoft-Antispam-Message-Info: HcKbpU3Cj+zVcmQ74AXaQBI+TdeF5OTYb7vG3m0iBg9Qgqu8GYZ/vfv3FqCOEJdkqN+eMXCRus4nz48nRzmdbLa+3nbrHvgAIWLDgNc4TmcI25A+RJJkdgLuWBXueDmhbBGRzytiE9ZgG5uYn53BXl5ffFaZyamSB7mbZVDZczNtpXrTtAP5Uo2AWTdbEe34+C/GjhShgZq/KLfT1YUulMhHCvF54G7JaXWH2turtPcSKg6yuXg0D6ZKqAZ9jU9oD4Cbw3FIvombGJ1kVahhlA4OkiDjOr4LitpqC90LSenoJmXK505PYx+hFWjgU0LU9rqvJmcEHkg1bX3sWOuexCqePXFe4wTKmmRF+gHqSWRY7Z3ZwAAL6iYUAYLoqkfIYyCKlz1+WYEsXroUuCQy4CkJbjf75vmcPFnYACUwuuhVh3FwSbKespf2dsqUY1OyN5ccBW9wCqioV7uNGPWnIdrD1p0BBp5oGeCqezl7mGMMnA6Yrn80Z5r3FFDzoj5iSoiY/svZnUDaLD6LTXmjzfRHSPlmnmKu87ExWvcWHxcWwYoKgmWuh1A/qeGYUZsZqbeISF2xPRXtTLsANmbuzWRtsR+llnL68L6CCmbGxnx7yaxm7JBXWzsxQx0mJqtjUc9hNBmYAR5PglyDgk2JEigXkjkwrgrWF077Eih6p5g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(23010399003)(56012099006)(18002099003)(22082099003)(4143699003)(10067099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YUIpfnajDwXqHMFaQE0DbW0LPdQd+mk6ndnV7VLeiB1dvTBlUgNLBVfGg84l?=
 =?us-ascii?Q?+t8A9ILKqllxtz4cETmlCcxNv1rVAYj49vfMCRXREyp5V8P9pSimkkPTjWTw?=
 =?us-ascii?Q?r1I3mzo+a865gSiO5F4YXLeViqL3Jd83owuy/FsHoRuNZQ+dJGZswTIN4MHn?=
 =?us-ascii?Q?iRcbboXJ/3O+afYJqlUUUXVsG33H1PB0VLLzn7woP+YKBPAU4X8wsdOl3+vc?=
 =?us-ascii?Q?qQ3r9TCNIKUZkrov4KmealDFxFgOs1gzqP1TGXWRVsDGHE64O/oBLSYAfgKl?=
 =?us-ascii?Q?NemacXyYsb4MRp3tHoUXPp6OkM2ikWMfP5ZJpd00FQ/9tlEjredM9rw1dnns?=
 =?us-ascii?Q?r/WDWcfv+H0zsclNtQglZtbDwP5VYa6lnzoiyVlkRW6VKtr7q7z23KgIMLy9?=
 =?us-ascii?Q?2Xd8WWFI8l8PmKkyAoorTKpjmaSD/M/DHdlA6Z+ZOAXEQ+HBpi5OMU+Jb0f6?=
 =?us-ascii?Q?Puujg4IUxJtRan0itGEs/jE3myaevwr6+d7nQmABfannP5+kM3sXT8DO+65j?=
 =?us-ascii?Q?ECiUZ4sfhW7JstzFCi5p40L+3OO5dGw/vIadK5sDx8BnwethYqeNB9Z0XfzO?=
 =?us-ascii?Q?fhBmfXbcFNLLSVI68XR5FDj6+hV/zr4zSulxlfLvw+NF3mwTyb1Zmk8ipBrl?=
 =?us-ascii?Q?KdDfu5G0S4pkuyXHltWh3H0rUMQUoTjR0iN/kAF7JupGUpdLe35+PGHsZI+T?=
 =?us-ascii?Q?BCKNMo012O4sQKyApZ6UI9moeeEpWd5DRge5Q17bi0dJHHtg1PXagGVX0IFj?=
 =?us-ascii?Q?TH1J+ukU4TPj63Aa14PKH5BhgOdR4uXoFtRNeokCV8I8b3pWz8YLzl2oSi/i?=
 =?us-ascii?Q?R3SbWwLNT5RDPuOehSzWZ/CLDGNxbybrc1fy/zMSVR9YgfinpWSxefNpFcqb?=
 =?us-ascii?Q?S5urlrcSCDbq+MMyKNV5ISUfDrjvw9fq8Se8Zde37qJkDhCU7c8dHzuVpKB6?=
 =?us-ascii?Q?KNJu4L0N+pvrUy/hbBNGCEZMf1Uj533W2HeUL63M8ryIXqQE2tg9vEZPUoE8?=
 =?us-ascii?Q?9/71eTJeFH6ECYD1fxyDPkFTD/FYEOi2MxC6TXOUw6sRu6xFASJIC2WLxqVj?=
 =?us-ascii?Q?UZAWcEsYSriyvU9m22ptnxpKmUAosAi5hS4gtqhpU676LW+6s7nOu0J93wOq?=
 =?us-ascii?Q?CJYJLuljLxPNCWtY1alc2sG51tYwvwSb8nPt87CHcWb1VgIBjNAis05ZFIL/?=
 =?us-ascii?Q?QIzuCHurvZ5ADYOaomSlQLdx1V1f+PZs/t31vXLPvTxEOHaum6I9GdfZqNkO?=
 =?us-ascii?Q?0NbNNHODr8l3Qdsf70wNNgKMznuRN4wFdg/6cOHcvTtnhmJVc2yg7JKZwizH?=
 =?us-ascii?Q?jf5RlxubXhIcjlhbSdM5a22ajBONq+yJ7heuhL94Wu9N6z4ubb38shZmtKx8?=
 =?us-ascii?Q?FO4SkHAJeaqwUiZWWJj1QE1J4rmDx17IBuzgUYUr062IGaEyn9OWFh/zhO/d?=
 =?us-ascii?Q?BjHe5TzBt5XX/gso//K8Z3A+WBfz/UmV/obD4Xs9iA0JyKXjK4qmqmaDQnrW?=
 =?us-ascii?Q?QmbcHMZJ2Qwxkxy6Z6vNHrWa4hu6wmBK2lM51IZg+VRT+cCXv6nAMpLAqAMT?=
 =?us-ascii?Q?aKRAeejfjhodFy/ELyi2RhnkBWukdmNSoUIp9MKHqrdM0NqPhsY3QtPHx4eq?=
 =?us-ascii?Q?umuahfKFHHY606cj1abVBCpCXw1eLFcow5X7W4NFiw2nH/DzmX2J5o9gC3aj?=
 =?us-ascii?Q?sjtweYdUlUknnUpOKpOM6daIHTg2np0HX97fL1MNDF6eFSxnDBnM252TwgVH?=
 =?us-ascii?Q?EaAPf2Prsg=3D=3D?=
X-Exchange-RoutingPolicyChecked: IuCTuaHsZ58u6gbW1B6xcfyAWlHr1ZnGDScNWqL6OsTij675Ww4jgMWEbo9mt+tzqw08pJTKY3VThDESiuqNBtBEtGaCzn0LfvW4OcE7f8IzkeysO1XuIR3/wyWiArmhsxG4HUXrrC0QlX/HotEIvjB1FkWn/FKYV+FgwTNf803xw8XbmezNxUBk2ewjgYAEjdzTUm+7aLgULdfT29yPJPm3ji0xaaSzD5+DsOYEUb4C02hbKwfEgkA5IAgzNESOTf9flmcHwZriHQ0DfOdgJ082b1l8vvL7deCKmsJwYUuOLoKZA0HUMZlCtLE2bIRJHqtkfNonbx02Z206dpVzhw==
X-MS-Exchange-CrossTenant-Network-Message-Id: bf1a85d0-f3b9-4373-004e-08df140f4672
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 16:26:35.0205
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 79cY4lm7cem0AB4c17lzFMzk867IoE6TMsYORU8E5IQ+BvxZiWhSkMbmrOz54MLUio5dZuNMh6InNMmiQWOVXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6514
X-OriginatorOrg: intel.com

On Wed, Sep 09, 2026 at 09:08:29PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 8/31/26 10:44 AM, Tony Luck wrote:
> 
> ...
> 
> > diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> > index c3bd3536c514..5cd2711d00e7 100644
> > --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> > +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> 
> ..
> 
> > @@ -439,6 +462,8 @@ int intel_aet_read_event(int domid, u32 rmid, void *arch_priv, u64 *val)
> >  	void *pevt0;
> >  	u32 idx;
> >  
> > +	guard(mutex)(&aet_register_lock);
> > +
> 
> hmmm ... this means that reading an event can sleep now ... but it is still
> possible to call this via IPI (smp_call_function_any()) if the CPU is part
> of the nohz_full subset?

All AET events are implemented with counters in MMIO space and can be
read from any CPU. So this check in mon_event_read() bypasses the
check for nohz CPUs:

	if (evt->any_cpu) {
		mon_event_count(rr);
		goto out_ctx_free;
	}
But even if it didn't, is there some prohibition for nohz CPUs to
sleep? I can see possible issues with a timed delay that might rely on a
clock tick to wake. But it would seem that any read(2) system call
from a regular file might sleep waiting for I/O completion.

> >  	pevt0 = pevt - pevt->idx;
> >  	e = container_of(pevt0, struct event_group, evts);
> >  	idx = rmid * e->num_events;
> 
> Reinette

-Tony
