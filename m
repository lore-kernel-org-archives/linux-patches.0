Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0959A3806CD
	for <patches@lists.linux.dev>; Mon,  4 May 2026 22:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777935070; cv=fail; b=ZtwzrBSNWUoIksNkkt6z7+x+34CrluNqRlRjtsMryVSEmDQITPxVc7PIyuk1Jv+LtDiE/7anihBCDKuYGa8duLDuCNeBkhZNp/oLnyNAI9WMyoVO9ceem+YKc0XOHHGWqnLfQpXoVJ50ss5ebGUlUMDOb0Ig0Q3zkw+3K9fA91U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777935070; c=relaxed/simple;
	bh=zoHVHwlBUmRNHknyAenpYbncjfqSq9H+BdF/DdArtM0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=QOrcQPjjrWEuz5Vo7cljh+rEghGs2GQVUO5XfmU90KTzWfV8IGxsY5pXxObSfL7/EsvVRvB3aEDRePTpfcRJaRadpP13TdYMwWR+7fOWU3OG8gjFoGegtum/xITdwGsmJSwBWFR0c6YDZPHkZhUa0R/NHeSL9nT5+kw+jlZBm2g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Xbrji6Ea; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Xbrji6Ea"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777935068; x=1809471068;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=zoHVHwlBUmRNHknyAenpYbncjfqSq9H+BdF/DdArtM0=;
  b=Xbrji6EazzJllgRHDuzEGBGiXjeOtMrMC5TCs1R/7WsK/jvp6E6Eupy8
   i9XYpQes8Uov+X5Stj2RmWIHaQQ1AoDwhLcmtQz6CzI6Cbp+VT42IC/L1
   eFIBii+vg1MpU7aYEzLguAdt7p4MtILZhRBdW2Z+6Kgl16KFVBt6qEkNW
   dmavtGv3JDHK1xXW9ZgtaBZWUhFu2RYJWARI6siinU3ixfTUzAudPRkyD
   F50L/SAbJkKFugsupdSuxDfvCwaUImM9ZAPIU6CAlPsbgDS8LGZD6fGNL
   ijfL1rQYJjk+YuCuhK/46O7A14Afuzy1EV1DX1sBNZy89yyQQMHsgaOSn
   Q==;
X-CSE-ConnectionGUID: 36M9nhZHQ861uf52BnV/+A==
X-CSE-MsgGUID: 5OU7HfRUSlmRYoaMD4UK0w==
X-IronPort-AV: E=McAfee;i="6800,10657,11776"; a="82411139"
X-IronPort-AV: E=Sophos;i="6.23,216,1770624000"; 
   d="scan'208";a="82411139"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2026 15:51:08 -0700
X-CSE-ConnectionGUID: 43kd8S9qRjeM1iQjrtCnSA==
X-CSE-MsgGUID: fqG5h7CGSfSdD+L1vtYN2g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,216,1770624000"; 
   d="scan'208";a="234771352"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2026 15:51:07 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 4 May 2026 15:51:07 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 4 May 2026 15:51:07 -0700
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.35) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 4 May 2026 15:51:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lHlnxPtQPgJXlwIxwzEt+ZrQhPq71FCueCFNbBDwwFEOXy2guTEiZsQyGFRzbg/ko8Evjy3ftHYuabipYQxUDNJwuOgM93CEAU7TJUTnGcRzJT9XCTphlpRKzHTPhtz1YT1zSYbAzjqiAlce757wiz9Pl3ZqDmzc9jU4xEB30Oq+Cjw3uH98zsaEo+NznVTWdpI5ibDBxN4kR+WgBwPso8LpvQjFXxp5jmIZoqIP7tXa251fyQzqdYdGpdxpdpuF0pQnDXYo/amkZp1xZry6Ewrc4FRfJVsoV+p08KUuwNUEGONwsf2Y3kukfcEUAj3de9a9OPhe4BAMzZMCvdy9Zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hGtC8TLVwBNZS1yw6d4Su0g9GTVOAtZzmm7iQnXFWqg=;
 b=i/8WfExDWoPPp1MdskNIK7wjwwB1gtf8Kyz3OOrUtTwSX7JXXOY05YavL9276fwImkPsioVXeD8edbQFYzimLsGo/5JQoQ8m6uk1xubiRtYVRzQJSkDAKEqbY4patvGUmsBmPpvZdijfqc8AFSHYfaKHXV+2KYIrxoMgq5Pj3M2bggFSxRltie2O9MHeIALmfZzHXUJ7kkFbOELJGxuiLsU+xBCuAkGj8tNIlR4vkp+N89pAiCPqZGUI1m1Xxkb6oTNCmO7pgefkBvObAuQ2ZT2xNPmil+IJvBVEVUKaHIH7sLIF9zjaY+bTQY7bI5+54j0O2pLiCYkymnxcrg1Meg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by IA0PR11MB8353.namprd11.prod.outlook.com (2603:10b6:208:489::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.25; Mon, 4 May
 2026 22:50:57 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%7]) with mapi id 15.20.9870.023; Mon, 4 May 2026
 22:50:57 +0000
Date: Mon, 4 May 2026 15:50:54 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Borislav Petkov <bp@alien8.de>, <x86@kernel.org>, Fenghua Yu
	<fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH] fs/resctrl: Fix use-after-free in
 resctrl_offline_mon_domain()
Message-ID: <afkizhrSwJkiLD3j@agluck-desk3>
References: <20260501213611.25600-1-tony.luck@intel.com>
 <2236fae5-7e66-43fb-ba05-76fd4434e2c9@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <2236fae5-7e66-43fb-ba05-76fd4434e2c9@intel.com>
X-ClientProxiedBy: BYAPR05CA0078.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::19) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|IA0PR11MB8353:EE_
X-MS-Office365-Filtering-Correlation-Id: bf82e89e-6c9a-43c6-e7ee-08deaa2f9a80
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info: Zj/aDHlI3cPfULJ5Bw4BT6WqU+C0G5H47EMNWJkYaVt1Reu+lYQCLNA5tCoIc20xf5Qd9507QGkGoDdbBvBZYDS3/UcT3/rzrxlsPksy8Hxboiz96+SyBr2dlW6b2yCO45SEhv0HtRuswQCpyX9vFowkRssouiW0U8ZskJsY3o5ifww3OZkyBZTTHuN/SgSPf+HpSKogv1AoUcsuuuila55rTP0z2thkXPNKi0UaWKe8HGzzi7SWT029FnIBCHDdmkhT4Peotb5rkUtBFOAgJAG/++k2Mv3kuexQx+2DtTRvr7RW+tyfaXdoo2NYnbT5SC4AYvHqQ8gZEH+4MSFSw7DizxHanhR20WK7+f/pVzEfJa3REzD062Cz0TIhqrxTXBYcmmE8Q8sCITnX3u8JMMxFB9S6gxcb5lmHWdwLT9boVIlaNnLiZKEOloaMIH7DNebbGASDmYFbCxcwyCT3xej5z/qFT1bBQrVf3PHBOgfsHP9vMAfwxvM183odtOqjekZ+TKo8zgBsYK5LK++V/qlhl+DMo33xcKvy4XDNFRTtm3bpmwoT+eya/TMv0SKGnHKRmgTCZ/olVKOma8kcYd1USPcvKwXPPh9V9QtfShn7KlCLSyJUadzm6NKzEZ2YY84fbWQVRKFBNCfqJ7KZpw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WgkONHFlIF9Glt2exlNO4+6sZ2BCR+fjE+jT34CGE3hjTs/yJYworF3xWUKZ?=
 =?us-ascii?Q?ajFivyJbfFiM/pFuKJudLqR/1ochmL/fiWYFTUP72wvQb912c6bFb2yFtolY?=
 =?us-ascii?Q?dDAQZYkNMhgxm9RI6TRmzxI4uzjrdc11KntOwiyLeBIeidpVz1RbF0HT0LIL?=
 =?us-ascii?Q?WA3S9JeQHuko5/4ZaP8axu4GL6BkaiQiDnLZykkBOFhBZ7PUcQmUXIlQlZkx?=
 =?us-ascii?Q?8xziyCwx1TKLhWB4GUurdY0wwQmKZiTJvUQKhTlGctGujttrmxQoYjYS2bWD?=
 =?us-ascii?Q?8GN5jhioORm5qZNd1t4cu4nTtUOvUUknGEoAxxwb1bu3QrFnXd8PyArgperD?=
 =?us-ascii?Q?2+fQ8c3YNyNlk/RYY3M/VD2o6sMEoTdtCtaDvNxsuiS+x6Tmtsl1PtZ3khFh?=
 =?us-ascii?Q?P3IEKxHoXHNXhfoNG7612x274yjTz8LlocMZSarBGySvSKf3HPOd22GnYV2z?=
 =?us-ascii?Q?W/ePrioyaKaoT00VXHYuDHibdtlFZ3jnsH58caeLycsS5QrHi/c5ruzrC4De?=
 =?us-ascii?Q?it3HffkudIgN8PCQyNN+EkVByLnawRUrlTu2Co0hnq7sxGbR/7p50rRaDS8x?=
 =?us-ascii?Q?GwC1FsejZXxvJtDwcWp4UiJ6LIQBIc+goSKUl2bgzbU5rwlZvN/eE0VsceEm?=
 =?us-ascii?Q?XROyFzJp0irdO7C6zbQ8JMbxatRHlA92BxBvDo7hslPrRBdn2Jif/Q+LEDqt?=
 =?us-ascii?Q?IQaUNi/YeHzWDr0nJDGkaV42enLmHAwX42E9Hz8f9Rinq3cPO+IonBHipEfT?=
 =?us-ascii?Q?i06keoikUFuKe7d8jUbZEAeblxgz2+JLLMbcWV0iP4yYOqg0A/GirUXarQWK?=
 =?us-ascii?Q?2VyN9Sz4sVzm1DKaBmmOvrf9rnoZ1KcCIlQbLpLFY3xrWAaystkG6TUkNdai?=
 =?us-ascii?Q?ntCL1/OZAhzeSx8fsKBA8zW7AV36pmhDGs9juFNnQ71J/uRgaWrL0ku2myTj?=
 =?us-ascii?Q?HMit72EzPiYdP3SHD5Cx80sE9rJ+zSzmnZyDNmCcz3M2hLeU51UbW6RwiCGI?=
 =?us-ascii?Q?AC73BzyBsY185pknGgqK5GdJ3ng0YJNSbO5n9N26xf0hNUf5W2K6osoSYpMl?=
 =?us-ascii?Q?+MnRE9kbkSDRaL0tjLwbnyt9wIrKaAYp6AWOeTUNcSc8FjDzNoVnyO4VTbDK?=
 =?us-ascii?Q?G0Giacy4vWj1hcWtTCP9dHpRMYCGZyrzt8rWGsjWjDIsFI8itvG5MqJBuVhn?=
 =?us-ascii?Q?WYrYJBiurVex4b+uK7ubO5gUcDgEVLcV0S7ygQbZEwDb6dfYpbHAi+R6hQIX?=
 =?us-ascii?Q?Ko/tGpRKC4g9koXzYv1QQGz2tQckPu4gSvItgdgFHcTMaihsyvIwDrz7JEVe?=
 =?us-ascii?Q?aTIgYHRB/J575vGUAc2KKfRZgxoEYLnEXrlNL2dl8/qtMSh5Ul05wJgAIg0P?=
 =?us-ascii?Q?ogxRRkf1iY4gv+BkPGjYhN8HIsncG3ezFea5KC34Sf29u9enArqp3jT5yHcz?=
 =?us-ascii?Q?b5xxX6BPzo0eVr8Iy3bl0hK44nfcwI3iL9lAgrMCO6hg33THxh0DOyXXC/Wx?=
 =?us-ascii?Q?lbQYQh5D+hJlXcq6gOX0SlEFDYkNt74cJPc3suJIC3BjT4Msj6Oh09w2ZJWd?=
 =?us-ascii?Q?7URk5WamjcB0Zef6DjnIjgM8FNe3yoNyiEgfvIN6EIC8nOI3HQARkU49Nz16?=
 =?us-ascii?Q?PPVBRQdh3VTrwfsoW8WZYDePiggFMz6hjmFNDJ52S5hv/KtVzUdhBoEMUDoI?=
 =?us-ascii?Q?MqwIKK4fPruUws5uPvyDcXRvJFXp9kxKG5MskcfD3IWH4zwxyB0R1hL5Og/Y?=
 =?us-ascii?Q?R7aUC+apFQ=3D=3D?=
X-Exchange-RoutingPolicyChecked: VEM4Y8SbBpfAFH+cDrS/kXTMrArolev0I/gGxUsEmPSiYivL3S3HWsi5CtCXXWbcp3JXbff1fe9xYW4tD0qhHaY9udwJivj2C+RC2YRlwDU4SszdIBghLdBy4zTQukvEGW65hHTCvu+nEe4Gr6fJzoSA0ABxuRo1FZM8aW2TA7vBhJhYIdlvmNh/WOibe6QOK72jln4r7IEozWrdwoyyJH+LzDcPnBROBHr7ffztlBvwzCwIxyvCQYfai36XQ+A/Zm4Z9D7ShlHqXzS4QoNymtNOs2vit1+6+tKacJvnbZ4ZVi56ClexucTI7DP9PZeeLjpihR0ZNsV8lvcCLKM46Q==
X-MS-Exchange-CrossTenant-Network-Message-Id: bf82e89e-6c9a-43c6-e7ee-08deaa2f9a80
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2026 22:50:56.8367
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TKVx0G3sXQTegbqPVYLOA8Z6mZnpJyPjDtwa88HEAh11hR/EO9S6yf2u2c4LHsfL276bCAWGqGkTPZviA6Lc2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB8353
X-OriginatorOrg: intel.com

On Mon, May 04, 2026 at 08:11:48AM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 5/1/26 2:36 PM, Tony Luck wrote:
> > Sashiko noticed[1] a user-after-free in the resctrl worker thread code.
> > 
> > resctrl_offline_mon_domain() acquires rdtgroup_mutex and calls
> > cancel_delayed_work() (non-synchronous) on the per-domain mbm_over and
> > cqm_limbo delayed_work items, then calls domain_destroy_l3_mon_state()
> > which frees d->rmid_busy_llc and d->mbm_states[]. After it returns, the
> > caller (e.g. domain_remove_cpu_mon() in arch/x86 or the mpam equivalent)
> > deletes the domain from its list and frees the domain itself.
> > 
> > cancel_delayed_work() does not wait for a handler that is already
> > running. mbm_handle_overflow() and cqm_handle_limbo() each acquire
> > rdtgroup_mutex before touching the domain, so a handler that started
> > just before resctrl_offline_mon_domain() runs will block on the mutex.
> > When resctrl_offline_mon_domain() drops the mutex, the handler wakes
> > up with a stale 'd' obtained via container_of() and dereferences memory
> > that has just been freed.
> > 
> > Drain the handlers with cancel_delayed_work_sync() so no handler can be
> > running or pending against the domain when its state is freed:
> > 
> >   - Add an 'offlining' flag to struct rdt_l3_mon_domain. Under
> >     rdtgroup_mutex, resctrl_offline_mon_domain() sets it before
> >     dropping the mutex; the handlers test it after acquiring the
> >     mutex and exit without rescheduling. This guarantees that
> >     cancel_delayed_work_sync() does not race with the handler
> >     re-arming itself.
> > 
> >   - Drop cpus_read_lock() from mbm_handle_overflow() and
> >     cqm_handle_limbo(). resctrl_offline_mon_domain() can be invoked
> >     from a CPU hotplug callback that holds the hotplug write lock;
> >     a handler blocked on cpus_read_lock() in that window would
> >     deadlock cancel_delayed_work_sync(). The data the handlers
> >     examine is protected by rdtgroup_mutex, and
> >     schedule_delayed_work_on() copes with a target CPU that is going
> >     offline by migrating the work, so the cpus_read_lock() was not
> >     required for correctness.
> > 
> >   - Restructure resctrl_offline_mon_domain() to: set ->offlining and
> >     remove the mondata directories under rdtgroup_mutex; drop the
> >     mutex; cancel_delayed_work_sync() both handlers; reacquire the
> >     mutex to do the final force __check_limbo() and free the
> >     per-domain monitor state. The cancel must run with the mutex
> >     released because the handlers acquire it. Cancel both handlers
> >     unconditionally on the L3 path (subject to the feature being
> >     enabled) rather than gating cqm_limbo on has_busy_rmid(): a
> >     handler may already be executing __check_limbo() with no busy
> >     RMIDs left, and that invocation must be drained before its 'd'
> >     is freed.
> > 
> > Fixes: 24247aeeabe9 ("x86/intel_rdt/cqm: Improve limbo list processing")
> > Assisted-by: Copilot:claude-opus-4.7
> > Signed-off-by: Tony Luck <tony.luck@intel.com>
> > Link: https://sashiko.dev/#/patchset/20260429184858.36423-1-tony.luck%40intel.com [1]
> > ---
> >  include/linux/resctrl.h |  1 +
> >  fs/resctrl/monitor.c    | 18 ++++++++++--------
> >  fs/resctrl/rdtgroup.c   | 38 ++++++++++++++++++++++++++++++++++----
> >  3 files changed, 45 insertions(+), 12 deletions(-)
> > 
> > diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> > index 006e57fd7ca5..73f2638b96ad 100644
> > --- a/include/linux/resctrl.h
> > +++ b/include/linux/resctrl.h
> > @@ -203,6 +203,7 @@ struct rdt_l3_mon_domain {
> >  	int				mbm_work_cpu;
> >  	int				cqm_work_cpu;
> >  	struct mbm_cntr_cfg		*cntr_cfg;
> > +	bool				offlining;
> >  };
> >  
> >  /**
> > diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
> > index 9fd901c78dc6..e68eec83306e 100644
> > --- a/fs/resctrl/monitor.c
> > +++ b/fs/resctrl/monitor.c
> > @@ -794,11 +794,14 @@ void cqm_handle_limbo(struct work_struct *work)
> >  	unsigned long delay = msecs_to_jiffies(CQM_LIMBOCHECK_INTERVAL);
> >  	struct rdt_l3_mon_domain *d;
> >  
> > -	cpus_read_lock();
> >  	mutex_lock(&rdtgroup_mutex);
> >  
> >  	d = container_of(work, struct rdt_l3_mon_domain, cqm_limbo.work);
> 
> Since work always runs on a CPU belonging to the domain, could it be simpler to use
> get_mon_domain_from_cpu() using the CPU running the work to obtain the domain here
> instead of the work contained in the domain struct? 

Is this true? When a CPU is taken offline Linux picks another CPU to run
any unexpired queued work. No guarantee that new CPU is in the same
domain. I think a robust solution is going to need a check that the
delayed work handlers are on the right domain. It looks like existing
code doesn't handle this well.

> 
> This seems to more closely match the pattern used in rdtgroup_mondata_show() that
> stores the domain ID in its state instead of a pointer to the domain and then uses
> resctrl_find_domain() to find domain.
> 
> >  
> > +	/*  If this domain is being deleted this work no longer needs to run. */
> > +	if (d->offlining)
> > +		goto out_unlock;
> > +

Claude seemed quite confident about removal of cpus_read_lock() in these
functions. Sashiko is confident that this has opened up several new race
conditions:

https://sashiko.dev/#/patchset/20260501213611.25600-1-tony.luck%40intel.com

Maybe we need to add a reference count to the rdt_l3_mon_domain
structure and delay freeing it until the last user is gone?

> 
> Reinette

-Tony
