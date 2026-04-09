Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A57940855
	for <patches@lists.linux.dev>; Thu,  9 Apr 2026 20:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775766916; cv=fail; b=W26fNkE7WTCfyV2GoYdPSJPrWkk4+3/hU7z8KmSzCUdA34Bot+hOhSub1M8M3XFJkeyNAGxqC/PVf/kpMrbCWpYyVHgMJIsLLCexNAUzyyZr6cmoTL642+cEc8IitYugiRY1isgRybb0s3mf4af45cB39vCuSv9NmvXhf28vem0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775766916; c=relaxed/simple;
	bh=CuYpSvh09IMply7bX0h9jdP4Ej5peT1vALtPwPJJEp0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=a4/r6W2vfmr280l4lNloBqEQ92POy6jpCVsFX6w41KKt1wi5ypvwg6W1yiXFo5NkKcitkBylhgEpzbqu4nWp8OI1SfcfauQePJy9AaFerChOiSeMeICi7fLHiyc7KkQlJff/BlChzP6i65V36Rg4VgrjfImSthZzI1vtqLHGK3A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Zz+xuBT9; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Zz+xuBT9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775766915; x=1807302915;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=CuYpSvh09IMply7bX0h9jdP4Ej5peT1vALtPwPJJEp0=;
  b=Zz+xuBT9dLLvhzNaSsNJmgxzCRTMmJjHmzDNnz28FhFLZRJP8S0Moaf8
   4Dua3c2AZEK53twcpGEnGQMLP7FTCaAjZXK3exdxChuu7XVwInVi6f+Yb
   D0eUA1ksE2tNrQ9ER0c+nDwokbqfsiQy0pHsKzSAhJdntm7isyxY+ZzQx
   RruGvFq5iAS7+/JpNssyrJRlfM7bK+7ArMV7wEaoAH4xbI8dZj75zWJYF
   TpCcHbQFHAOLNl7YRMNnuyi6YiaidC5W4yJ5jNM5m/8ATGnPZoWHj/yey
   llwUTEdw2/7gYCnZ4pUsoUn2+cyidIvsEk1x8yrju+JruS1VDdPMjnFHZ
   w==;
X-CSE-ConnectionGUID: tZ+vycjOSv2izkh3yGGZjQ==
X-CSE-MsgGUID: u89EDm+fTOCUH5W5bYcVnQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11754"; a="64323119"
X-IronPort-AV: E=Sophos;i="6.23,170,1770624000"; 
   d="scan'208";a="64323119"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2026 13:35:14 -0700
X-CSE-ConnectionGUID: N4AX7gDHRris+LDSmrOLOQ==
X-CSE-MsgGUID: c8bflY58RayPIOS2bVlBvA==
X-ExtLoop1: 1
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2026 13:35:14 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 9 Apr 2026 13:35:13 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 9 Apr 2026 13:35:13 -0700
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.53)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 9 Apr 2026 13:35:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Xe5+xZWowtQ2HEWVzW/Q6bRemQjTLxbMOpxwGDRKbTv+Waiyaxo8sBCEbsEHO9BXokRXC268kRqFrNTna7SmJnZ1UeUQhTt/1GeYUp1ay90seSa7lNT/nRa1zQRMlNMXCSW4QkMVjQUPvZ/ylXNanhE7US34Vi444UVmxiDW5bbHcuIBMjt6GgJx7nRU2V3k7r+5r7Fmhk4eS/kmHW8V7qd5hSmcGlyhx2MbtWAMY+8gqrvKfJSbeb5+mbP+FECDIOZYImNSNBuwgFe6sOUi3afDP0ICuZreknlix40yn3ntPFNbY/EtX8JyuZjVhft/ej8IFY/VCDHwVdgwTK3aWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GGxGENU42Q9j5N35YIH5DIaEbBtxMiVHQlR6iLJBnVY=;
 b=Bg4ribYwRqPeeBaX8CdPiBDYnYJRO1uLIecVtjqnj1I8OPjNcX/2KuLKhqaZVU0dzi3VLAd8L6a7dZpo2Kl3xbK2RLFq1BJ/eKhYdPNa6BmPYON45ew2Qf3y1DnDKICkcg+KN2L/j06JnVV66vDNewkr9YZu9GOXbDOL4uDWOwnSSKIJI+3GplwcSER2cuHo2jj/y77bNzPd0YiIveYM0iQ70JWJsILT5QH9ZYBXAwA1TdA685mVHz9napbKTh3nFW7Uq0QFMCi0u1nnbnGx4TiIPYw8ovedTmXnGyVRt748idVnC4TDyf9o35AYQoJ6XApQ6Yj9GvVdBOdnUS1Bxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB6077.namprd11.prod.outlook.com (2603:10b6:8:87::16) by
 PH0PR11MB4872.namprd11.prod.outlook.com (2603:10b6:510:32::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9791.32; Thu, 9 Apr 2026 20:35:11 +0000
Received: from DS7PR11MB6077.namprd11.prod.outlook.com
 ([fe80::5502:19f9:650b:99d1]) by DS7PR11MB6077.namprd11.prod.outlook.com
 ([fe80::5502:19f9:650b:99d1%7]) with mapi id 15.20.9769.016; Thu, 9 Apr 2026
 20:35:10 +0000
Date: Thu, 9 Apr 2026 13:35:08 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: Re: [PATCH v4 4/7] fs,x86/resctrl: Add architecture hooks for every
 mount/unmount
Message-ID: <adgNfJSeHVyBXumt@agluck-desk3>
References: <20260330214322.96686-1-tony.luck@intel.com>
 <20260330214322.96686-5-tony.luck@intel.com>
 <45436044-202b-4d77-b552-2156be47a52d@intel.com>
 <adQY_m8I2jUiR88k@agluck-desk3>
 <e85cd466-2202-4b40-82ed-91e421d8e073@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <e85cd466-2202-4b40-82ed-91e421d8e073@intel.com>
X-ClientProxiedBy: BYAPR05CA0039.namprd05.prod.outlook.com
 (2603:10b6:a03:74::16) To DS7PR11MB6077.namprd11.prod.outlook.com
 (2603:10b6:8:87::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB6077:EE_|PH0PR11MB4872:EE_
X-MS-Office365-Filtering-Correlation-Id: 24590f38-ea89-4302-97ab-08de96777ed2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: v42gNShlJH1YGtKvIcwdWB/an9eU1yGzgjn823nR5+V/AmnJWwOnIAQp8GNlekB6Dwoi6uCtBsMVug4QHLM5CS9qpH29xJzsA+I5yhQIp/u3ORPsQmcWYqBrS2K7klKr+pLwoUGd+3G/4s1brP9Ep9/6z8zlNnjEzJxfZ2nw3nfd3j2k3n/2J8yJtdbybGnicTIzCxLU34Oov00ASviZ2Q7TCJG8woesk59VJu/u06/wyaCfwE18scL3McPLpoNSJYhuzl7zzdBHtXIJCzhjEmWpD+oiv+LAFVDoRVrby2NzbANoMvtFBwfyYo4cx/pheYqfbM2Yy80wMsw1OADUubQMMk4sp4f1Hr5RPSI9Sv4CaX4JWIUDR16YoJAXQ8l5F4lHnH7PXXaVHkOvjWmHGnE/AtIiDg7AJKt8TVvl7/NKp74CRIsQRAxk8en/TskAi9LSIsaiSzgU8BIeuZ/feQlKEzS0NsxqpLUiys7DHqwNgPIsd3KJy0q7lpzcS9EbUPOfYZzVGjETZ4WluiSq6fk1fT1ZZXxCha/u566QNuDA9tUi3z9yAR8tGKXBO+onYD7Y5/Hu4HQXHp2Th/eLvwz5bWEM02br9AAe8SF90N3R7uhO+dAEzqgX5jI7eTbMVZETPoALzb4tz8KCRgoMwOOS7EghbxCS5mGufTUmKaG6QfGGKvkkjz4YJmpO4rGS5VKQ+/w5IcX4g0aJ3B+Or4WyKjEn7vUNzVo9wb3ToMk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB6077.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?q7DovKxZUad6bIxNnLLtSeloevXikOMsSbrRH/NO5HHQL5ILfqwS6n8DffVv?=
 =?us-ascii?Q?P0ThwOJ1PMCmwhZ1+21yNiYQC3F3syyxWH8S0Zu0TnCMntLgYK7+y65RFBg3?=
 =?us-ascii?Q?RhuWMmOcxaXSuDE6BITVs/Uhy8TNPTFA+NJeU72A89fGIQ5HZp4pTQ6xkGTw?=
 =?us-ascii?Q?tC1eHn25CSUfqBfDqcUhUfLYBgn68whyK4ygS5cFL+BhoxagWbESwBxxVQdl?=
 =?us-ascii?Q?XU51GFNlqISfBDV1+S7zeZQwCX2UyDufi/9lKMwfzYJg+d5Fqq/KmLHBScjw?=
 =?us-ascii?Q?bbB2remULlYY26/I/MNAYS4NwfRFjQ9tkstGPwvI5eY1budSs3npWWrPayNi?=
 =?us-ascii?Q?IWS1Gr3GPxwRPxTDIq7hdGgDARduE0XfPDelbDc/35FD7JXeD2V+mAfc5g45?=
 =?us-ascii?Q?31mkrWdOCfHfKkM9S6WTGeCYUSYL15L0LvRy1jBS0GQ3D+pGBbWUxSVlhG2Q?=
 =?us-ascii?Q?mLSPiCsI03OKTgRMAe1xYF+X9ffCB9qfyFdjI8aoHhJXyHQ9suK7J7Lvn3Ou?=
 =?us-ascii?Q?qugi3CTLhUygfvqZZntZpO/aw5y1KqhL7WPj7poWORp5qI4qwYxYDPT3AGkR?=
 =?us-ascii?Q?zXxPTIjhMWZtAUdW0cWojNMiuR1FIBw2LEwPGRBvD+/cH1FNqnAOtTalnNK7?=
 =?us-ascii?Q?n624X0UpcnVhyAkQ3O1dH/ChtKKlqfvsKUsdJQR1+Pu7/zjex7VaTYH+E9v3?=
 =?us-ascii?Q?539sSmfDw5kn70pyltCovuTgjdtr5PQqOavSTX/+hvvmE1Sp8fhL7x+uqlnB?=
 =?us-ascii?Q?wGRnL89tcHTUGeIPMmpua/6ylrYg9xN6B+OlyA9KCboX6bdjv14QXH6FZpjI?=
 =?us-ascii?Q?i2E37iQTiABdJKmHxHhfP/PPvjC+qztXKlz9xHKTOCm73Hb4zoNerVMIHB8S?=
 =?us-ascii?Q?zBuOFifHPQoSlIwG849D9q6CDVYu/4J5d/E7S+KyrLt5EmAhDXQmBxAGzvbl?=
 =?us-ascii?Q?n8faDjBwCfbvqgjeJh6eoCU9oh2KFpjRoBdWV7JUKs+pghlJ8+ySMjouH4FQ?=
 =?us-ascii?Q?53TpTE4wCUfCNl2mEd59NEshYJr8sKq3NV++vZhtYR4BE5YkNZk3Q2n+9SSj?=
 =?us-ascii?Q?5OFy3ZWMdVcw7rt0bhdiVDkD7FMh1imtJ6ImL/f6HW8Lgl/2ESnbr99CdIPt?=
 =?us-ascii?Q?u0xA3i8BP+5vN5zywQgavJvt+FkFNCXF39S4SRNgC+Osg9wRUZSM51NYaQdI?=
 =?us-ascii?Q?uubsbt8faeBF3LQt6eCwsaaHtUoBW7OFpSEuQq+NiWTUyrArN/2jIION9aRq?=
 =?us-ascii?Q?k7LC45YvtLfkCg3b9+Ue1qACHUjjl95Zn0R5XviXz8NNtBCubJ1JsSByex8p?=
 =?us-ascii?Q?RRqoJK043r4jeo3jJXk/TBWl7fiZknmDOZ7R+a5jifbQYXbpykMTTbkXrDj+?=
 =?us-ascii?Q?382Vv4uAxqibwIcLplh5OGdfqxW536GBZMYYGGqidI9nkXfAwvFG5I/p/KmQ?=
 =?us-ascii?Q?q3X+J/0Yxmjbgr3n6QfllFFsLmzbNNck40JKJSbnbKrx7ZYRNN1Lx+iVWUrC?=
 =?us-ascii?Q?bNjzAcYxsPsQdRdADpk7XTUS4HnylLFS6aVu3gBGjgx7NSyoUxK0eodUtwPs?=
 =?us-ascii?Q?fx4RtAsTJfE1x+GPDKp2layhtbrY1/ZWzyoiZqf2WWEw1KCvX/h0Pd0m08So?=
 =?us-ascii?Q?F+RdUzQQ5GL1vtI1QdoSBQWlIH6dSKMmlskgcBrx5v31/FFXniTQoPk8Uu/I?=
 =?us-ascii?Q?i3yDdg29SkKR3CV6xthhlS8SpHNxw9WkOJeJxJ3X68fSmvD0brEmm7zCE46H?=
 =?us-ascii?Q?QzeUiIIGhw=3D=3D?=
X-Exchange-RoutingPolicyChecked: Bsi0dExvzfTkG50ZUHshIF5tkuGGo6G/fIcZjspBvZXLXw99k63shwMakk/ztFBS5KJpE9IGl4PgZfk/ugKKPh7EelXW/LRfBURMlLiJ0U7JKCPDE3s8t/BpYTXRzAyynMFOvp93uKyAt7BGlZI+qY8i0euzN8tmw5owJlHSKY6Vytlf4Q5sGFe0tU1gNMhfOizu+v3GoeWDJi/9feRTDJ30Fb8uajFjqUOlUxom+lK5P/WUq16COLmx2EuKZ/eSZhUdz86hhZWEwU4P4+zA+0HbCcbUu3wuU8+H+X0vqmyViEMn8vHNUaXZ+pE/DpnP/kjUejOkLn4AfAZS3HzaDQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 24590f38-ea89-4302-97ab-08de96777ed2
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB6077.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2026 20:35:10.8230
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uQd93tnX6Cs0KqzVwgAAk7o1US0NeSfMgTunTo3Srxrxo3AI/iES2mXMNO9A8EJSY0gYc96SM6oEnqnJybPT9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4872
X-OriginatorOrg: intel.com

On Mon, Apr 06, 2026 at 02:16:46PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 4/6/26 1:35 PM, Luck, Tony wrote:
> > On Fri, Apr 03, 2026 at 05:52:30PM -0700, Reinette Chatre wrote:
> >> On 3/30/26 2:43 PM, Tony Luck wrote:
> >>> Add hooks for every mount/unmount of the resctrl file system so that
> >>> architecture code can allocate on mount and free on unmount.
> >>
> >> Please use the changelog to describe and motivate all the other things
> >> that this patch does.
> > 
> > OK. I will expand.
> > 
> >>>
> >>> Signed-off-by: Tony Luck <tony.luck@intel.com>
> >>> ---
> >>>
> >>> Note this patch disables enumeration of AET monitor events because the
> >>> new mount/unmount hooks do not call intel_aet_get_events() (which is
> >>> not ready for the change from "just on first mount" to "called on
> >>> every mount"). That is resolved in the next patch.
> >>
> >> This could be part of the proper changelog.
> >>
> >> Could patches be re-ordered to support incremental changes?
> > 
> > I'll look again because several things have changed since I ordered
> > the series this way. But some bits got overly complicated trying to
> > make AET ready to be called multiple times. If I can't solve elegantly
> > I'll move this into the proper changelog.
> 
> Please mark patches as RFC when still working out details. When reviewing it
> helps to know whether something is being submitted for inclusion or not.

I thought I was close enough for minor tweaks. I was wrong. Especially
so after learning from Christoph that symbol_get() and symbol_request()
are quietly being deprecated. I'm going to use Christoph's suggestion
of a registration function in the next version.

I have succesfully reordered these two patches to avoid breaking AET
enumeration for the next series. The minor caveat this time is that
architecture code is first updated to handle multiple mount/unmount
cycles, but file system code still does the DO_ONCE_SLEEPABLE() to only
call on first mount attempt. So the resctrl_arch_unmount() is defined
but not called until the next patch.

It seems nicer to have a "just architecture" patch, followed by a "just
file system" patch. But I could move the definition of resctrl_arch_unmount()
into the file system patch that first uses it.

> ...
> 
> >>> @@ -2900,6 +2893,30 @@ static int rdt_get_tree(struct fs_context *fc)
> >>>  	return ret;
> >>>  }
> >>>  
> >>> +static int rdt_get_tree_wrapper(struct fs_context *fc)
> >>> +{
> >>> +	int ret;
> >>> +
> >>> +	mutex_lock(&resctrl_mount_lock);
> >>> +
> >>> +	/*
> >>> +	 * resctrl file system can only be mounted once.
> >>> +	 */
> >>> +	if (resctrl_mounted) {
> >>> +		mutex_unlock(&resctrl_mount_lock);
> >>> +		return -EBUSY;
> >>> +	}
> >>> +
> >>
> >> This does not look right. Here too is resctrl_mounted accessed without rdtgroup_mutex
> >> held. This change implies that resctrl_mounted is now protected by resctrl_mount_lock
> >> but resctrl is not changed to respect this throughout resulting in unsafe access of
> >> resctrl_mounted.
> >>
> >> Does this new resctrl_mount_lock need to be in resctrl fs? It really seems as though the
> >> needed synchronization belongs in the architecture. Could this instead be accomplished
> >> with a private mutex within the AET code?
> > 
> > If you dig in lore for the v3 of this patch, you'll see I had the mutex in the
> > AET code. But there were some complications.
> > 
> > 1) Need to acquire in intel_aet_pre_mount() and release in intel_aet_mount_result()
> > which is legal, but makes code more complex when call chains need to be compared to
> > check that the mutex is being released correctly.
> 
> Why was it needed to hold mutex for so long? I cannot find explanation here or in changelog
> of v3. I did not remember correctly and considered the AET code to be doing the domain
> addition. Even so, I do think a mutex internal to the arch code can be used to manage
> the synchronization. Could you please elaborate why this cannot be done?

I tried to move the locks into architecture code. But main problem is still
handling when a user tries to mount an already mounted resctrl file system
and gets -EBUSY.

In that case file system calls resctrl_arch_pre_mount() with the file system
mounted. You suggested that the AET code could detect and ignore a repeat
enumeration by noting that the event_group "(*peg)->pfg" is non-NULL, set by
the original enumeration. But that fails in this scenario:

	# rmmod pmt_telemetry
	# mount -t resctrl resctrl /sys/fs/resctrl
		... succeeds, but without AET present
	# modprobe pmt_telemetry
	# mount -t resctrl resctrl /sys/fs/resctrl
		... enumeration success, but now calls resctrl_enable_mon_event()
		... with the file system mounted

I think the bast solution for this is to change definition of resctrl_arch_pre_mount()
from "called on every mount attempt" to "called only when resctrl is NOT mounted".
This is because architecture code cannot tell whether the file system is mounted.

> 
> > 2) The "only mounted once" case meant extra state (AET_PRESENT, which you note
> > in next patch may be redundant) because intel_aet_pre_mount() is called, but
> > needs to do nothing.
> 
> Right, I do not see need for extra state. In fact, since it is not clear to me that
> PMT enumeration will be complete when intel_pmt_get_regions_by_feature() is called it
> seemed worthwhile to only rely on event_group::pfg - if PMT enumeration was not complete
> during mount N it may be complete on mount N+1? This creates a poor user interface
> though since user would need an alternate way to know if AET is supported and then
> a "remount until it works" approach.

The race remains, and is lost if resctrl is auto-mounted at boot from /etc/fstab.

The user can tell if AET is supported with:

	$ grep ^ /sys/class/intel_pmt/*/guid

and checking if any of the RMID based event guids are present on the system.

Delta T for the race is small enough that delaying the mount to some other
startup script should be sufficient. Users are likely to have such a script
to create the CTRL_MON directories and configure schemata for their workload.
So annoying, but easily solved.

> > 
> > Adding resctrl_mount_lock to the file system code made things simpler. The
> 
> Adding complications to resctrl fs to make things simpler for x86?

I believe it is necessary, since architecture cannot tell if the file system
is mounted.

> > pre-mount code can't be called with rdtgroup_mutex held because it needs to
> > build the domains. That needs cpus_read_lock() + mutex_lock(&domain_list_lock);
> 
> ack. Can an arch-specific mutex be used instead?

See above.

> > I need to add more comments on locking. resctrl_mounted is only modified when both
> > resctrl_mount_lock AND rdtgroup_mutex are held. I believe that makes it safe to
> > read the value of resctrl_mounted with just rdtgroup_mutex held.
> 
> ...but not to read it with only resctrl_mount_lock held as in snippet above.

Holding either of resctrl_mount_lock or rdtgroup_mutex makes it safe to
read the value of resctrl_mounted as it can only be modified when both
mutexes are held.


> Reinette

-Tony
