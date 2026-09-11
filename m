Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03958429039
	for <patches@lists.linux.dev>; Fri, 11 Sep 2026 19:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789153900; cv=fail; b=Cymdw5ssKOQD08N6/pZgIAxPBSKe6JbkUdU1iFEwYtq40yvV26zz4xabe40mHg6ei1F98L6uh2t5gTxoqEtOw0yvRZC5fJZVe8KWKnp0icaiZtJBMzfpZutEad0XmBThvs21mHxjvP1Y9o3/2fDUafDxkmWaSauczW7SEhjxfxo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789153900; c=relaxed/simple;
	bh=PACuYwcXydMKvSh3GHKUvRqbJadTudseY72ngp2EpcE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=SdXFchJk3UiFSYxqZ78KXCY3vdYHnv0t4NB6dLs0XMY1M1dA8MEmjCRNVs/wObqsDeuMLzxZzKN2/R21WVAX/1Q5k4GuV8GWy0u6aOVSPaM0w4lLuO6aFoJ3OZzhxjMGWkGyACCS+mIwT1fFe73Hs8hZPyvZ9Q2oVLb4iUsuthc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lWspc2jp; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lWspc2jp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789153891; x=1820689891;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=PACuYwcXydMKvSh3GHKUvRqbJadTudseY72ngp2EpcE=;
  b=lWspc2jp7in7dmL2xNU23k9ZHVw29TMRVvNlRApA9ujSraxcfAmD4pAO
   V4YEMHFdaLPsY2KlxTWts/Et+OBC48y2JUfvJOsAhsWvXDgImSx++Th4/
   hzCCcnOxVmWJoFldZ4qgO3+BpdEgUQ8RkOYl4ywfgciMXZxQlIn9rLZ+B
   0gPefUjAF/HLJs4jw2GaAKXjbcl5al2yubXQASAa7OtCmlGSrg3vD1gJh
   bI67YjUQzyT4Hy4RMqiEmC6Zl/cjU9J/nDLFE0B15a1wsoLYAFmTabkJ3
   JWLBxswp1FXicqwsGYJE4oUsJKrxGz0rsxbpl2h5WHyFWO4Tk3VIs7Y3T
   A==;
X-CSE-ConnectionGUID: D4qW7AZoROynLjwj77hZtQ==
X-CSE-MsgGUID: zqdn2c4nTq2j2neOVGuK+A==
X-IronPort-AV: E=McAfee;i="6800,10657,11902"; a="99951509"
X-IronPort-AV: E=Sophos;i="6.27,97,1787036400"; 
   d="scan'208";a="99951509"
Received: from fmviesa012.fm.intel.com ([10.60.135.152])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2026 12:11:25 -0700
X-CSE-ConnectionGUID: JfWnex0fTGupS7LRBYYyXA==
X-CSE-MsgGUID: n1MBxIJlRo2wmQV0X7aK3g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,97,1787036400"; 
   d="scan'208";a="266290"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa012.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2026 12:11:24 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Fri, 11 Sep 2026 12:11:23 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Fri, 11 Sep 2026 12:11:23 -0700
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.2) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Fri, 11 Sep 2026 12:11:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ecd4qg0DOPF4cizhmru0mjbvb0GvHPYffm3DkuKDARoXaSjosyOv32WRJ/3HGBmqkoCKecUVd4jVVW/N2AEklAhIXwhoJVUfgZ4juYwRgCfvztMnADnewNbrXnWPEAmffK427zkMinulSVXyZwXB/Suw/M+mN4tSkOGD1Vg5HvjxllF7a/b8O8g8lCnPvunTszQt69B/ViRZ8LrbnVjGj8ZqLWqD/ccPkeArQNY5cBbfUafx58XgTwhK+YmBhMrZoEejQSL9cw7DJO6wnfiTzy6lqGjNbzNFnkf8N9PAiJJatYzzRrFQxk2fmdek8QsZ2pQPGgFZlnhynX2OEStHxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QUvZHupQWC/ykYP5E3vStC3LE8P5bHIyCBOkOpLBtbI=;
 b=H9EYc1ucw0uGxeW7N+2cbwPoEwA9/TQ34QbElpvy8jrOx2XuDKGDrZlv6x2H07i02A0NHlxvIkoWjYXxTj0tWoS9reSaf16vAvW97HpX65cG1i3MArvEXG94wv2jhIOdxKF/rhLc2ABVyn4qGFu6QerAprCzuOmtI8txe1nbbbWei70yBiaZeP+JJ+MiqyiAbucFe+OzbRmt9twpYN76e1ge1oWXc9KJfj4nwTOFCNO1NSVWMDpEfXYeCLi1LNazHT+wqTIVdUozl9geb0LvGhW8rTRP94idroao7Tb8eGy3aysAUUz4xHG3u+p6mHHdfDWt9ZqmA/PlAY1fC5tzhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by MW4PR11MB5935.namprd11.prod.outlook.com (2603:10b6:303:18a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.9; Fri, 11 Sep
 2026 19:11:15 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%4]) with mapi id 15.21.0382.014; Fri, 11 Sep 2026
 19:11:15 +0000
Date: Fri, 11 Sep 2026 12:11:14 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v11 02/23] x86/resctrl: Check if monitoring features are
 enabled
Message-ID: <aqRSUtZrg1O4YgPx@agluck-desk3>
References: <20260831174421.13921-1-tony.luck@intel.com>
 <20260831174421.13921-3-tony.luck@intel.com>
 <e063f882-ebf3-4a25-9d43-b23acf5db4c5@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <e063f882-ebf3-4a25-9d43-b23acf5db4c5@intel.com>
X-ClientProxiedBy: SJ0PR05CA0074.namprd05.prod.outlook.com
 (2603:10b6:a03:332::19) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|MW4PR11MB5935:EE_
X-MS-Office365-Filtering-Correlation-Id: cf807455-4c6a-4064-0a7c-08df103873a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|23010399003|1800799024|56012099006|6133799003|4143699003|10067099003|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: iHfEDcW64hD2PEyntxsUTv1VIvlOzJ/rxcaqzkKtnuC2dpiiuXYr7YB6RscFtLutYYXnwyT2cH1CVj3gvnzUjBIsbo/xpwaEAuHM/8fwuFDOgHOO/9pAFLEJ2DVKXju9yXMsIFnpcYXNlJGKXB3QFU8I7plwXXwbKRSqDfGAvtpR+DDvu6K4nKD1lW5jGTEs9pCuJAXu9PwWK8j1P+hwlTDlKxwZdyqgp5RiC6Kw0FUXE3+h7y/tvqEtH3dynUesEd9po7WueGVwt/jvXERBMK2mDohOMpwKZTijwzsslSOy5fTcsGlKKXNz1+wEp1WBzoQC54Df5iUB9nxJcMnlJNulJezhpOzm+AkZMic8B9Cqs4INMYNH5kGYsgCoqGUXuKFbt11W24deiigXxLglNMl/876TrjqMvhuzxTJ+pNgGufgxc6Wh1KMwUjesr4fM5+hSLgYjk2vitoV2tlKQCoRQOkIse9BdSL24Cuxvo8s2zgabzhEz0LG0pYOM89Z4ctP7ptaVdOzT4Nuw5L9Nnfg06Yx45SPDsuTC8mBKCbWjwq/0aExreemb/0bS8L8bDP14pXIDyZWnr5G7A/uKEJMUxpXeTb1672tX3375gmSYs1BP5cGJzzqpqEq2Q56DBPykbElJVWk9QTOQ7XjW7T0ccXze8ky6zqVlv/5d75o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(23010399003)(1800799024)(56012099006)(6133799003)(4143699003)(10067099003)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Re9PsfWj4C8Nm1RTfboWOh2nBkGB3ms2a0zj/xGz1/NPo4wzRnpmslcDu5un?=
 =?us-ascii?Q?dhfdqsh50LqUStpitGXyH1pi6hfi+2dL6uNCqDtuncPBvX59aqi/zgxamc0c?=
 =?us-ascii?Q?PHdnoEEC1JJSVbM5WNsa9tRV43MH4S1e4dqvY4/nVFH4bmCwT7aUJBt2t/3i?=
 =?us-ascii?Q?YJMEfy2rCzGas/Lo+ib8nnJeIbnUVLcZuJOy/k025Y6hEDj0kblq5T6KLnIX?=
 =?us-ascii?Q?CwDVhf/GWBcV1J7PRoLm/soBAuafqWU/7mXRNaJyvLXfa+aym+g4/VAQwKNy?=
 =?us-ascii?Q?ZSo3E+nl/36UNu8tL3H4Qsl2iA8rwskntpfIW2gsHnLaa0tZFKkyBMbWQNQt?=
 =?us-ascii?Q?GBwO86UmPRWUDoISsvwwTiEqivNUmeMOcogpx1nXVnGT7PAYBqpbdx4RluGx?=
 =?us-ascii?Q?fugGY4tSCZEfW0enGIoiJTGDuIxUB+4C305yUCr+vqPNIUhnUEgJUS8FYkzD?=
 =?us-ascii?Q?JR2+iVLSbtA4FN0MTMn8nah8pwNSDjZmc5EMR+UbgLpa05G9pJ2vHRAA/uZd?=
 =?us-ascii?Q?5fUuJ+aMbBJxpn6yDRAKLzLiPLkAxgAF7ohoMuZJsIyri6xbZbwYMzfZlK37?=
 =?us-ascii?Q?YvKstjsQtiEaApczBZIYG8i4Ou7GnchbE3HRHn5CTOH1hDIJ7X8K2bV26qk0?=
 =?us-ascii?Q?mC8nQZLD4B3/I9LfSta8p06I1BpSoeqV2GHOhQKtmgi/YEtWWAzZrn08lvMS?=
 =?us-ascii?Q?wGpMqMvtEUOwTK3mVuruMKjZT8fiBWUEo5ienja8Kct7hbbDM5DGdPQ8VyEh?=
 =?us-ascii?Q?r1JTsjtoV8Zx1XKJRHVzF69pcNDj88fltMffzh2jWeMU4eHUPdds/lq4Rgdf?=
 =?us-ascii?Q?2zp2z6d8zAFpnMRqgWYEdfgiw8oDNDZ6k2/0TuFb/yxEAwEZBbPPNNTMLmib?=
 =?us-ascii?Q?H/ti3FAf5UFhCJ6+uT0E9N19zW5h0eq+Zjlh4Dksuc/lU9s9UIpFTuBaSalY?=
 =?us-ascii?Q?iE19jVD3YT6LAPdlMgt3XKuQ/WkLuIjBtA5ebUH7IqTPjptXJrGjTZQbCpoD?=
 =?us-ascii?Q?aptH4A42RkMqqD9MYh2DWWf8tNJeWeFKqa5OCZMGK9PEi9b+pUqzhGPfyXtK?=
 =?us-ascii?Q?fvT2mFgdLKVbydk+kqYwDsr2H0JG4wCZs/Vrz4gzCwEajBXW1I924WcslYrB?=
 =?us-ascii?Q?IAxoqhpYtjxtlsobVmGcJsFtYlHhWQqKbvgPtgYX6ahYmGFLV53/WBwRmpzy?=
 =?us-ascii?Q?a7hPNb5zY8JIapypiSSNEjRDZ2c7k51rdFQai+TlFWR3akTTXL+rcFs9P2uW?=
 =?us-ascii?Q?yZ+Gk3TAiX2w9BbmpI1ofsfhlXFYnaTEtEVyenQbug5Kg/Q8UOVlCW0CjOev?=
 =?us-ascii?Q?iea9hJ8cS8lSD8y4Zm25/vzkOG8p6hRqQ5d9xcnQ47ZrY83KB5vJrjEOQeXi?=
 =?us-ascii?Q?sBj4qJa8bYXlZaN21Y2DqqfiLf2o4jB5vSV4svXz9zK4Le37HKAlooRx3zsO?=
 =?us-ascii?Q?Ko1gbmXjXUhrFDJVTIMWcGWHHxOC+HV1R11lrjsgw3mpt6UQLn+Hsn1UoEBE?=
 =?us-ascii?Q?S0ryootrPqrVY2YOKcuk6T5u/FZEUcFV47n0+kgu0Yx+SSoSNfvkI9l1/zKD?=
 =?us-ascii?Q?l5VT855hGk2Ymg1xaV1MD8YfSPQ8phmXnye+RP789aCo811nuIpk+VsTjbpS?=
 =?us-ascii?Q?zHmLRQlNKa3BBl3eijtOch3PTzUQ92dIb93t/MuMoJrN3n6cLZ73pg6GQBuZ?=
 =?us-ascii?Q?fAUCL5/sor8+K3n0H4aGn9hXaf2kvx8EpDY4/LbF5xDUQUnsstSNJzxh/sze?=
 =?us-ascii?Q?ZYUn7dYBZg=3D=3D?=
X-Exchange-RoutingPolicyChecked: BAcFbYC8Qkl7ZVkwQe/Gw7oJ9JkhPevIfyphTPxDGpefSaq2MstJ4vsT+Q+1+XY6yAFWsNfyVTj1H2JViUevJHNb24J111SxUqzxHhWC500/XQcmncqL83Vt7pMtToaFcSao3qhtsw8lp+jUDS63mu8o2+jNhZiAeMgeObOFoZAUrMD6cgza/00sT0NYCK87AU3B6/0OPkRQsf2fiz+OCwiBhLzlW5kn39flu71Xgi0tJiWPPr+p9CSeVJ54imRc95WgUQrPGRr0dFo3HhF9iBen7qsqv7zBORdkivPbdqxzaxcfEGjXeHNeosKryNM5AVJARhRqWpa5FZIjFtPUkA==
X-MS-Exchange-CrossTenant-Network-Message-Id: cf807455-4c6a-4064-0a7c-08df103873a7
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2026 19:11:15.6723
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yKUZmTHTgYZg3icEsixQaUVM0iyyVFhPPk+nRHGxWHs19NdMa1G8QiYKUfV2hUIOe+ctFUA6Ku3VacSO0E3+lw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5935
X-OriginatorOrg: intel.com

On Wed, Sep 09, 2026 at 08:52:39PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 8/31/26 10:44 AM, Tony Luck wrote:
> > Both Intel and AMD manuals say that software must first check
> > CPUID(0x7,0x0).EBX[12] to see if any monitoring features are enabled
> > before checking for specific features enabled in subleaves.
> > 
> > Each of the L3-based monitoring features is gated by X86_FEATURE_L3_MON
> 
> (nit: Sentence should end with period. There goes the promise that the available
> AI tools means reviewers only need to focus on what matters :()
> 
> To support this change above could perhaps be expanded with "... which in
> turn is gated by X86_FEATURE_RDT_M."
> 
> > 
> > Add check feature bits.
> 
> This sentence does not sound right. How about something like "Add checks for these feature bits."?

Will update.
> 
> > 
> > Fixes: cbc82b172638 ("x86: Add support for Intel Cache QoS Monitoring (CQM) detection")
> > Signed-off-by: Tony Luck <tony.luck@intel.com>
> 
> ...
> 
> > diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> > index 2435eddd24eb..fcbecf677914 100644
> > --- a/arch/x86/kernel/cpu/resctrl/core.c
> > +++ b/arch/x86/kernel/cpu/resctrl/core.c
> > @@ -968,20 +968,27 @@ static __init bool get_rdt_mon_resources(void)
> >  	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
> >  	bool ret = false;
> >  
> > -	if (rdt_cpu_has(X86_FEATURE_CQM_OCCUP_LLC)) {
> > -		resctrl_enable_mon_event(QOS_L3_OCCUP_EVENT_ID, false, 0, NULL);
> > -		ret = true;
> > -	}
> > -	if (rdt_cpu_has(X86_FEATURE_CQM_MBM_TOTAL)) {
> > -		resctrl_enable_mon_event(QOS_L3_MBM_TOTAL_EVENT_ID, false, 0, NULL);
> > -		ret = true;
> > -	}
> > -	if (rdt_cpu_has(X86_FEATURE_CQM_MBM_LOCAL)) {
> > -		resctrl_enable_mon_event(QOS_L3_MBM_LOCAL_EVENT_ID, false, 0, NULL);
> > -		ret = true;
> > +	/* Any monitoring at all? */
> > +	if (!cpu_feature_enabled(X86_FEATURE_RDT_M))
> 
> Previous patch aimed for "symmetry with X86_FEATURE_RDT_A" ... but the "symmetrical"
> code in get_rdt_alloc_resources() is:
> 
> 	if (!boot_cpu_has(X86_FEATURE_RDT_A))
> 		return false;

I've dropped the #define name change, so the symmetry goal is now moot.
I still plan to use cpu_feature_enabled() based on the block comment in
arch/x86/include/asm/cpufeature.h saying that cpu_feature_enabled() is:

	"the default CPU features testing macro to use in code"



> 
> Why is enumeration of these feature bits done differently (cpu_feature_enabled() vs
> boot_cpu_has())?
> 
> 
> > +		return false;
> > +
> > +	/* Any of the L3 monitoring features? */
> > +	if (cpu_feature_enabled(X86_FEATURE_L3_MON)) {
> 
> Could this reduce indentation and churn by negating the check? Patch #12 and #13 seem
> to build on the flow introduced here so my comments about this function are split between
> these patches.

Will do.

> > +		if (rdt_cpu_has(X86_FEATURE_CQM_OCCUP_LLC)) {
> > +			resctrl_enable_mon_event(QOS_L3_OCCUP_EVENT_ID, false, 0, NULL);
> > +			ret = true;
> > +		}
> > +		if (rdt_cpu_has(X86_FEATURE_CQM_MBM_TOTAL)) {
> > +			resctrl_enable_mon_event(QOS_L3_MBM_TOTAL_EVENT_ID, false, 0, NULL);
> > +			ret = true;
> > +		}
> > +		if (rdt_cpu_has(X86_FEATURE_CQM_MBM_LOCAL)) {
> > +			resctrl_enable_mon_event(QOS_L3_MBM_LOCAL_EVENT_ID, false, 0, NULL);
> > +			ret = true;
> > +		}
> > +		if (rdt_cpu_has(X86_FEATURE_ABMC))
> > +			ret = true;
> >  	}
> > -	if (rdt_cpu_has(X86_FEATURE_ABMC))
> > -		ret = true;
> >  
> >  	if (!ret)
> >  		return false;
> 
> In further support of above suggestion the code below calls rdt_get_l3_mon_config(), the
> enumeration depending on X86_FEATURE_L3_MON, outside the block where this feature bit is
> confirmed to be set.

Good point.
> 
> Reinette
> 

-Tony
