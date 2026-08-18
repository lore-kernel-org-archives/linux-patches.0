Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5641226D18
	for <patches@lists.linux.dev>; Tue, 18 Aug 2026 17:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787074344; cv=fail; b=SPYik9ToeE1/KJX2b8buVTzXPkI19zs9KkNEQ2Ksz5B8f6wmI9JT8wOvPoCTTILRw24KUsQKCqvs5wa3p6iDRGiq3Yyf/H/2u0mtJQJY6GReYC8hOfG4818V2x9zK8sJreLoDVuxXxvwPkOpFnNkn/0STWXFPwNJehvqsXRg25Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787074344; c=relaxed/simple;
	bh=5OrF0FeSzHSs42AkEvLbqDB5FRA1IuLZHMCwpngNYWs=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Nhs0poQyJP/kh8nIEkD1lZXJawycNGi/x9ympaXAsXjUPWetvKPeV8Ao2GX6PiEcpNdbNAYQSG7gr2G05ycDQVefA5e5SaysygQ69BlDAbZ0ntvRkosDmIjOTDw9CBp2zGM7sKELy7D5Wt2FXfv+fIkQmM+LaVDDuQrl49N6Tec=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=X0E5FXcc; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="X0E5FXcc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787074342; x=1818610342;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=5OrF0FeSzHSs42AkEvLbqDB5FRA1IuLZHMCwpngNYWs=;
  b=X0E5FXccSbZx1Gy6GtzSUW2QmLsonaEslHUX3vHRiYbquheukHXAEbQz
   DZziMCFzOk0GcZpXrH7HwTYitg3DpSKdsk4kwVVQFF+sHtWUuwGUlJQIN
   j/Yph1m/Z9iVAaD17ZMkZ33QO8ho0Kgj+lfrX8wDxh0ueKzcMWus7fto3
   R7BgLUHt4MkcND3E6BxArIXYnZepfQQ+9DzTg7FGoy99l7kH8dipkrxMd
   HUn8fQpcL43GEBiDwVb3f00NhvhNfLfz8AXu9HQ+Z+1vBn8rhh73cK0aC
   qKsmMq6lX2fSzyuu9HkLS1CrCtTcYuNDZM5ZWNjxe7n2CX4d0HiZdpf1U
   g==;
X-CSE-ConnectionGUID: nzfH3Ve+TNmOLTja/alqVw==
X-CSE-MsgGUID: ZTltEnwBSW+yB1SDhW4UIw==
X-IronPort-AV: E=McAfee;i="6800,10657,11879"; a="91448812"
X-IronPort-AV: E=Sophos;i="6.25,230,1779174000"; 
   d="scan'208";a="91448812"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2026 10:32:22 -0700
X-CSE-ConnectionGUID: 0TjLT8xjSDyJYiVYzsP0jQ==
X-CSE-MsgGUID: IrYbX6ZWS62NMTH6+CSSyg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,230,1779174000"; 
   d="scan'208";a="262652771"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2026 10:32:21 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 18 Aug 2026 10:32:20 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Tue, 18 Aug 2026 10:32:20 -0700
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.67) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 18 Aug 2026 10:32:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fqSb9bypr9egF1BI+T1ViNnGduWyCwmxXeYNSjXKJufBFZS0quyt+ecDALSqq7UgwXYoQr9qEd/yBY2OQukW4v/oo6Lq3uJZQ5rioVHI6RtG+6V5feX2i/qECZumAMZ+C4jDwgvmxndDwt0vWvur/e9vUxiwcvDe0XqWGMK7gqsirnkOVMLmppFcFoO2slk4U3BAKAY0GMtECPvkNfHg5EV2RJxVtp6OfogRNGfZn7V7jnXaLhoPY0L5AzaZGMIvscze48BHO/Hlvf79u5s/4Y/n1lD4i8Ah9FDJwC/AO6C70OpO98DUg5d6/fU/WM2wH97ZRhHg5s4m8eXVl9mSfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W0zoGP+bzaAoFlioVNknEOEsDITZEHDd0MjePpCwrFg=;
 b=HxXQl2ryt6aIrQia73ZdT4FMLdkWA7ceg5WvgConyJ7kdJEVm3NGF4Prz3mSb9tmPczj5tsJgF8wtv58tmdRhEonhUpE2voQD/ItX9Hd7vZIifLUdMGeuhfZ8A+f70XSO+RWpjls8iBi1TSxYyl+2AyhkUhaVq/G0JvBKwQg5iDCCYp9BkGMkQABWx+M3vj2Al+G/bRvzot/6Txp+Rh5qSsQDV3CUlAxjkSIZKjt85dv4PhLtgWlMYKGIW2GI6kGnRZvUyue5ZnTjCaUVpkIToRCaH47pFHG09ZqdJ7BP87B96ObT0/0GR55LA1p661FFPCfk+Rns9x6lw4C7ZmBTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by BL3PR11MB6412.namprd11.prod.outlook.com (2603:10b6:208:3bb::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.16; Tue, 18 Aug
 2026 17:32:17 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%4]) with mapi id 15.21.0315.016; Tue, 18 Aug 2026
 17:32:17 +0000
Date: Tue, 18 Aug 2026 10:32:15 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v10 14/17] x86/resctrl: Export interface to report
 telemetry unbind/remove
Message-ID: <aoSXH-JUatl4qSTS@agluck-desk3>
References: <20260729172752.11561-1-tony.luck@intel.com>
 <20260729172752.11561-15-tony.luck@intel.com>
 <6b6ba68b-ece9-49dc-b1d6-55715a913fcc@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <6b6ba68b-ece9-49dc-b1d6-55715a913fcc@intel.com>
X-ClientProxiedBy: BY3PR10CA0001.namprd10.prod.outlook.com
 (2603:10b6:a03:255::6) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|BL3PR11MB6412:EE_
X-MS-Office365-Filtering-Correlation-Id: b9f47001-4c4b-40e0-575f-08defd4ea629
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|7416014|376014|1800799024|366016|56012099006|10067099003|11063799006|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: KGW7TWwa/xvoyUY1Ah0WFX1Luo3sNPgoS1exAUtcj1tVMOKisYOYd1kAWgac7pTsxZLsqd46vZraTVN5cXjmos9NeSdMabPXSbVHBpCV6FmZKujiVF6RM68qDCcD68MBjKZrOOjDQoJGm5vMOm9UhruXNBiBaFl+1bt6OcDrX+T/RFVTov5wu0Mvhzxp3I/9ioJ4zxvKh4B6RKFWhGSyQzwvpjPaxqd4RLpsI9Hi33k6WZCPxgZQX8ypaWVNleGguwHObk0xHedv7YVmELsz9N0n0129TNr8kxotYk6Uu0iYRxpZd2fXlN8UqLecz0Iumdhfi3Vd92Xo7n8q9wMyT/Huf6oZkPa2libGjsk/Kt1M6//BqOsHA+lEVpN7Dl863ZeHmsPVPgUjxNbKBNFWIn0KhZSSnW7OdptO4X0vWlJaUcaP3szS3dSjjYE77+O6Dq+OgZZ2fsEP2ClJ967hjkGe7WbQL3VUqUMTLJn8RwIfBWqf2BZ0iA8ed97iFIp6orwhHStF+vy2KosBXXJcmcac4bmO9z7kDYj7WuCTRYC9iCAo87JCCImQaSbWqJIppbniUza3K1qf6PVQF1u0htvhzd97vt9VFrr1coyUNdcBNGrSjvHlSR71ckS5+i1bJKBIwkBX9axhpQ2ZbvaxbeOr47hho1OvBh56dgVyDX0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(1800799024)(366016)(56012099006)(10067099003)(11063799006)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aWFYT5JEc/LoF6KZkCuzcDtNL4i50ff3ECMLZEy8PN4v9rzcUtBNs7vxe0l4?=
 =?us-ascii?Q?exoLnp+vQbktaLcpkGVPUSud+RypfAFoWvyZ5/MxoqNVuhh12mGHsbztdG/1?=
 =?us-ascii?Q?LddkP7fubgZLSk++D2jt4nNiIO9DbMFhKKmh3ndDeSpdDh8BnPPqsX+tCWRu?=
 =?us-ascii?Q?CH5e8gmzyuZmhkAfeZ5rU/oRoyV0X4G5RxG7a6KoW6JKZBulp/A3xM+20/tx?=
 =?us-ascii?Q?mTjDW2R/kslwSdUbTe8rgULeznGNxST+z3yxy7JS/5n/yxJ2/rL9aK+v5lj1?=
 =?us-ascii?Q?PoXKUWZX2VFKBk5ZL4z0TLdFqBcPfe9aHirsucf0P4FzCh6a1Cd4JfU2AXJ4?=
 =?us-ascii?Q?8ZlAI9NXDdPs7RbAUQVJ+AyRxYBdqEE+PqzqVLyVwz3CbehKo9gCJbYki0m0?=
 =?us-ascii?Q?7qvOML6KygpNnUr6EI9kewLYzEWcq9yrnNApxOAL6nor+cdXdZEliWUfsQb6?=
 =?us-ascii?Q?e3jCQpgcPqZE2H2QG/pxDIscmodoMB8wV6E50DxFgoX4zH0xrRELTqBEo3CI?=
 =?us-ascii?Q?SXaSYVGM/FESkgdc3+iBMjPMZAOqclzbDmWfeA7FnNV5KhM0GKrm/Ue/JPVu?=
 =?us-ascii?Q?91Qr79UYeSNFaYfJekemv9MF/SYSF+aQtjsCK42S72bmWE3WWttEivLI/Ud5?=
 =?us-ascii?Q?0O4p8MesOUqACk9EQ7mFhKKFiJtGSUmzJgXB9m+Vo+dhQECsMgYqF0dARSOg?=
 =?us-ascii?Q?/Th7MB6jvB1WWjr+ScSUAcI2qRYcP+cn19Wgv7Fo574fP1I9+XaOFZ+0nvDf?=
 =?us-ascii?Q?hGHWw2gf0bdIv4UVXDTbCv0cWm3wwBwakRpZzhdhG7yFvtSRZUyDJUiwwz7z?=
 =?us-ascii?Q?LAhWYYUqXvP4aLQw7+qjBhsH92myxBbjvI9gWx/IXGfn8a9m1jIW5a/RcdiI?=
 =?us-ascii?Q?hEZQd2wUD4Ge9tiZgypsCdDLGwX2dMjkQlg4rML1yud42Hfz+GB6+74DUK/b?=
 =?us-ascii?Q?eBQqQ0s1x2Xd6Du0p6to0oVrCi7Ef35cngmyzT1k5N1aGZZGJnVCHxPKkRv6?=
 =?us-ascii?Q?7LBUhotNtUP/o+4XWVI1j4Z3CDBVSt1QGnLsvA3CexJCxgXwYs38KZsGcFaJ?=
 =?us-ascii?Q?P5H+7kgBTtLK7ZJRqkSmARBq09BG/gVbWeVhET01+C51BO4F91gM0tR0d/3z?=
 =?us-ascii?Q?zAzF7u2B6JlYJhjUaZWCLUAVvSJoMpJvWbCBAq+n142/COoh8yCaVb8FMaPx?=
 =?us-ascii?Q?WnpgjfwCQFlEh/RXRkPoPdWSaUfSLWwdRO+PFAgafYYu76xP43GWeopBcPTo?=
 =?us-ascii?Q?+4ApZ65u1zGNJLl2Lvg6/9ZOG4H9dZAJYFFJJQWytpZEGs2kPxHKob7Sk5+m?=
 =?us-ascii?Q?ePEGKW5PKrUrmPNRz/EI0bkW+8aLttAMW/bkfngZyMS5EnARKYl2ox7eUvGV?=
 =?us-ascii?Q?V6xqHmmwXP1TCrLRJyM0mgsmvwdWrekY9GEHEQWXaJWFQaDNNm4tp2zBqFut?=
 =?us-ascii?Q?S48TvLMcvFg6hmvbGBls+8h2Xaj1M2wTq588A7L2nNLi/KaZ6p4ESN9/IbE7?=
 =?us-ascii?Q?HYLUPvK3q0vq0A3tLAp502+c7RG1rRaPZiI90imoPfU8TRtmC5vpS3IjYib5?=
 =?us-ascii?Q?XzRDWCq9KCZhx+GZtIVltPV+pBbwVrvTHsioqs7oVH3kRNpSFQr2W5Gxy7E0?=
 =?us-ascii?Q?TWLtvG2p1AKEIk8L+fblzmMN0vxRfBrio8hGNe03emVKN6aAnrzte2LlDEvU?=
 =?us-ascii?Q?DR/q8MOW8WIHnQzNqSW0j7YL5AZqTfbEsOhMVivw0+gMA92AWB03s31KD6xx?=
 =?us-ascii?Q?bbKWawuI0g=3D=3D?=
X-Exchange-RoutingPolicyChecked: Iiioz5GmZI0/+/dwdjr0RT9wHhRe9kyZwYGxHbJleaJpHoUiIOPQ5X/fOhr8iLG/VZIqzRON3bxXbNWo9P0z6aEhTu7Tnw4ZEnWpY0xwK0oUlG3GaKDoIyMy7qglAq1Tr+p9hBrWptWu9sIGEqABgHDZ1fRo0XVtagAJo73/ms1S9k5XuF5bFDDXc8Xi/JTi0ZgxztBo7/L/E4FOQxpE4EM4Xxfl2/LwCK5wcid2XMSowuKV4lkUEuvQn2pxChMgJR/rgBBoGZUPk2jjvhsEWByCGJanzKLKTcYKfPDWQYGga2Y3wn7UgVfziBnofEsyLKBqEAU53tc7HSqMkuk80w==
X-MS-Exchange-CrossTenant-Network-Message-Id: b9f47001-4c4b-40e0-575f-08defd4ea629
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2026 17:32:17.1939
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cgNkgH1/TCIaiHC75oTYbXwhbzvPU6PArFLT2EM+6kikEgtwKXxmZYpxDrCeIDmODVQCHtCyGJxhOE++1WzY3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6412
X-OriginatorOrg: intel.com

On Tue, Aug 18, 2026 at 08:38:05AM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 7/29/26 10:27 AM, Tony Luck wrote:
> > Linux allows devices to be unbound from drivers, even if the modules
> > cannot be unloaded because of reference counts.
> > 
> > For telemetry this results in teardown of the virtual address mappings
> > of the MMIO regions which hold the event counters. Subsequent access
> > to these counters will page fault.
> > 
> > Export intel_aet_invalidate() for the pmt_telemetry module to inform
> > resctrl when invalidation is about to happen.
> > 
> > Signed-off-by: Tony Luck <tony.luck@intel.com>
> > ---
> 
> 
> ...
> 
> > @@ -373,6 +385,18 @@ void intel_aet_unregister_enumeration(void)
> >  }
> >  EXPORT_SYMBOL_NS_GPL(intel_aet_unregister_enumeration, "INTEL_PMT");
> >  
> > +/*
> > + * pmt_telemetry driver calls this for unbind/remove operations that
> > + * will invalidate the virtual addresses of MMIO registers provided
> > + * by intel_pmt_get_regions_by_feature().
> > + */
> > +void intel_aet_invalidate(u64 pkgmask)
> > +{
> > +	guard(mutex)(&aet_register_lock);
> > +	invalid_pkg_mask |= pkgmask;
> > +}
> > +EXPORT_SYMBOL_NS_GPL(intel_aet_invalidate, "INTEL_PMT");
> > +
> >  bool intel_aet_pre_mount(void)
> >  {
> >  	guard(mutex)(&aet_register_lock);
> 
> I noted your request for discussion in response to sashiko feedback on how this
> disabling is done. 
> 
> The internals of PMT are not familiar to me. The goal per changelog is to
> handle the scenario when a device is unbound from the driver. Could you please
> help me understand what a "device" refers to in this context? The new API appears
> to accommodate packages/domains coming and going and I am trying to match that
> with the pmt_event_group/event_group. If I understand this correctly this API
> a "device" going offline means the same package(s) of all pmt_event_group/event_group
> go offline concurrently? I think I am missing a lot here.

PMT internals are a mystery to me too. I may have been overly pessimistic in
the complexity needed here. It does seem likely that all the entries being
removed together would be on the same physical package.

I'll check with David Box if it is safe to just get the package_id for the
first entry and assume that the others are all the same. If so, the interface
to resctrl can simply pass one package id instead of a bitmask.
> 
> Reinette

-Tony
