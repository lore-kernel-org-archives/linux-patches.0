Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B66662D7BF
	for <patches@lists.linux.dev>; Fri, 25 Sep 2026 00:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790294808; cv=fail; b=gM659sEwXvBw//RuvZ37sH+HDVyBH5UvWY1ytOd17zwFSLdowzhBreMTIaWK5npd0qdHsv61z0Nh8L4DQTzGa1GxFC9rx/ylE5wUjkBKgPOP6DiQlWYKCTcMO02bnwlBwBqiwTxYPNeLR1yaiw37DqkPF3pJS6Tg2cvABgA5FbU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790294808; c=relaxed/simple;
	bh=Aylt7I+f9hQQA8qkA3bGXP0Pncq8n0bPg6Z/HboxxII=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=UmaSGq8y1hNhDdffBo/9RomuSJMNChVJxi/y8KPQWluRknqxP3iPeKbzrUqKGefAI4Ac4KHOae+0xe3St5BzlLDBRUc7OBQZkVsyhxzSU3o0SAo3KtEw+cLbmlfzsy+u8fxPWk8EXFx0on5nsNxutT9Fs0Mkc7pdzrHP3KzpzB8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fmSa7oD+; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fmSa7oD+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790294807; x=1821830807;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Aylt7I+f9hQQA8qkA3bGXP0Pncq8n0bPg6Z/HboxxII=;
  b=fmSa7oD+F1d3/gIJeZfJBT+nLoCJu7JhX4K2/Jmlod7KrL9DXhDiyaum
   d56zAeWa5yc1pzIOLyfm3Lt+X8mYVv8CotwuniMFv6FGevAICQvgCO9hV
   RpC0Xvrty8rqPXTvYJjd/lT7xxh0YS5mTrM/WMmbyt+t6MJEaStiCOec+
   jPHR6FQGG94MUdTP4WIcBr5vjOZkwcUyA1yoC3Oys9YHbhwruyitAPc7o
   FttdlmUxRDqM340t/QwB0j6k/duLd9ttsKonMa3p41LZBAl/Da4zAB7ri
   VFuRJ/HNilrvILUcTjK5BB1vN3jptsoqg+pvIv2kv366lru6xzk96Xvzy
   w==;
X-CSE-ConnectionGUID: ds1TBnVmQzKZFyn9SO+uTw==
X-CSE-MsgGUID: k+kYAFeIQpCKLB63ruI4aw==
X-IronPort-AV: E=McAfee;i="6800,10657,11915"; a="93800309"
X-IronPort-AV: E=Sophos;i="6.27,121,1787036400"; 
   d="scan'208";a="93800309"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 17:06:46 -0700
X-CSE-ConnectionGUID: ulxYVfdmTPKqpzHCzgtPYw==
X-CSE-MsgGUID: YxQGs4jvQgCSdXNPxh/Rrg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,121,1787036400"; 
   d="scan'208";a="273273410"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 17:06:46 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 24 Sep 2026 17:06:45 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Thu, 24 Sep 2026 17:06:45 -0700
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.22) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 24 Sep 2026 17:06:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QXXDMMOv0mqXtzetDc184iLgR9P0XDdFA1E2KyYpKrACAaMUIi2lxvwOvx1BkX4J23QfUTnwZE1Lid9jP3xJ96i6+9nkXGBlLLuNiH9hcjpocIPQVLGhc56T412TPxzrGfb4YFCYjD+QHdZod0fQjT6wdBXuryYYLpv5L5z8lDbSsofU3FbiRrbDxmJQaDDuQzCee6d2P7YFm7hm0WVQg1rQPwjbxcN6WvJeZSM4o02XVeszoRLcsNT9xYOrdCD0xKGgsE1kNvP8fGvS+KsD0XI3CIS7KfCIk3feR3WeZnEHMH6ukVJ8Tzu5cripYZ8HnBTPbjrPCAOzIZNApkjRHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=URfivH9mAwDDOTgEumLDoVvJcL3aeTSTD0A9Uul05iY=;
 b=t2vTOC3Kj01G7+Hxi5S7wqUpluTLdrxMQv+ytvTeUL+9f3/A6AG4JTNyP30qujDd5z+AltUW5PyYmieUsaDoxQZY01an0vCwmhXp/EcEohFoHA4M2gIjGE8/hFg03YHzyskrpJtyiMnsjlqKBL/pDiIRztRqcfhEwrsrux/ymKkdfhxFVfmuOQyxBIdp85u1DlBShDgmYQFzXcwyQcOF4pMF/S9OyWjUQzN/UktLOzXXlRRUHfiDnQwEoENQmzAuwpMO79qT/GhehzIvMz+yVwCOKkfFmUnf3X6mZyaSuks4vzAtwTNQBSBKEuhiJ8139+zLH6udnTznoYx+zJN0og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by IA3PR11MB468931.namprd11.prod.outlook.com (2603:10b6:208:548::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.22; Fri, 25 Sep
 2026 00:06:44 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%4]) with mapi id 15.21.0451.014; Fri, 25 Sep 2026
 00:06:43 +0000
Date: Thu, 24 Sep 2026 17:06:42 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v12 15/25] x86,fs/resctrl: Handle systems where AET is
 the only resource
Message-ID: <arW6xlQWVWkixiWe@agluck-desk3>
References: <20260916231320.14502-1-tony.luck@intel.com>
 <20260916231320.14502-16-tony.luck@intel.com>
 <39582d24-0fc1-4d5e-bc05-01c2f29ddfb1@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <39582d24-0fc1-4d5e-bc05-01c2f29ddfb1@intel.com>
X-ClientProxiedBy: SJ0PR03CA0378.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::23) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|IA3PR11MB468931:EE_
X-MS-Office365-Filtering-Correlation-Id: 4cf8e017-6bdb-44da-9e17-08df1a98e1d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|23010399003|376014|10067099003|11063799006|4143699003|56012099006|3023799007|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: dxs3JCyU5yjPXvOeH0iBdLay0UWptMhlflBANM8Vok32/vol0PeIJ+5/Fba0agSzWmbtNOM5QjuvfLMVi1uwMn2aocfr5bmBBueKa0ETVCO9pTwPEvcqXC1Hq3s+4AbbRDVAkwbDSiqBI37YovadvkH3OazjvyQt6pwbpO/7rtPp9FU7biCRWNTpzyCq8ooM0HB42GVuw5ch1HRhhbVOqFM/o6eZ9BRp2Q7HUM4+ECtY0isShbrx2ZaJ9H5+zyXPk9hv7KixIyi0iHhgpbf/wv4/2eduDsyRLSiEgL+CBWXl5iUTvZ8woz0kD9t8H6jnRJTIphnMUctb2WTTjQRZGULeS5xgkfxS0I54wzKX40bcggpK7AAhbW+5yjvT5KuYQPjHOhe7ZQILlY80v2zjfS6g/XOgWSxyiFkq8WFSOHUIQqtidIQJqjo1H4vXisz5OXvoIR4N5/yfs1PlvZJ+m2ViQN/fAguoCp8CPK5dsvrg1uROhDsCjXaD0v/N6k7gR7S4E5WWcaeq3/Qnp/zFnYvFQocIRr16aZzo7YQVnVsTrH6F32JEFGa7ZKCEbfzqLpmiTJPBPDZYjJVILi4MdsF/UVHDqglIIJfNnvb7WIXqrOHzGkn+YYDNQxwz0myQfQe3zddXfCshUaC/ngfnEE4btbOXl8a/lOAJvplRP3o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(23010399003)(376014)(10067099003)(11063799006)(4143699003)(56012099006)(3023799007)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/WTNUAEpaSjkFoKgoidmew38rjshBjUdTixkiGmTjU2WRMTg5uQ7sD0Hd2bg?=
 =?us-ascii?Q?ylmnX2gTJI7bXVYcuFi21cTOySh/M5UmrtVyv69444DTqQsHV9giLvrYPwtX?=
 =?us-ascii?Q?LJrV31jTbbkxRgEtt6+q8Lczji1KPkD0cirtHfaGtdWnpRjddq1L5oq24yJP?=
 =?us-ascii?Q?rBasQETX3QATRvXGUamu/gwGc2UY3cl5VmhebUwyD/iDyzs+m3AohP0jLhfx?=
 =?us-ascii?Q?u5eeKvALEQRJGrH/jaDcNq5mpvTF+jPT99YHaKXgJSCt4d2SaGiqn2+MBnrl?=
 =?us-ascii?Q?N/dHOAkMLktWKcDPIAyU67V9dRJUgta8SsZoea43KoFvhH7ZD55KByYA75mb?=
 =?us-ascii?Q?YX2HPri8CkHUur/ZLKIRtF9JXLGGJRF6UJz1PqrSL62z7AeFz9sXIBmcxAUS?=
 =?us-ascii?Q?9GShqLOId9ytSB7+ndfx8lliozBgm7NWLYoO/0dnHcLmgIy5RAZW4DsCq+yW?=
 =?us-ascii?Q?91MnDOfrgs6lgfiqKhL8/NVPMPyL8GmiX28d9MBuc+/zaWw/IoYJuBYI53gx?=
 =?us-ascii?Q?SfuCTHYof7MxnfCK9wEzoBtSFtqJTUyjaSM+R3WWqrDZIsNpLhqyxdoIlZIj?=
 =?us-ascii?Q?g0GuZKnRv+J7e0tNGpp940RRwyJ793LAM0OxMAG2vo6C4GtzcyV6vW0JABzo?=
 =?us-ascii?Q?pSipLVABVqFtOvTIxPUTqeSauL+I+CW5gB6nwwFUK+QTviEfg/L72wVVm7HR?=
 =?us-ascii?Q?XV2gQTXtpTT4ENjQwDJQygCCU+1BWjAvJu8KYMc/jgVjjJ2NXgGNQAEvLIF1?=
 =?us-ascii?Q?fxVRjzCER0Q8/xkrxhd/ZDLDZ/fYRhxQML3cELy5JCILgJNTiIF2FovcWnMX?=
 =?us-ascii?Q?aAidWAPsYWnFCmAu10w9XgZWTnV8IMchRpdY9++sapoIIzE2MYC50Va53mMO?=
 =?us-ascii?Q?DkewyL/7SdYaj6vHBlW2Z/cceNdoj8+ItbUDU8nlOroW6HhKWF886N+DLBlW?=
 =?us-ascii?Q?vZ36JVz51Y1C3bCylwIUGKfGaIHCC3Zn1H443aL72V5tKdbKcUENRYlOptg0?=
 =?us-ascii?Q?rp5K2cky1pEkDYfoh5CGQhtyjGsZd5kfAWCsqqRQ0Z0pTDVWmKvQIycNhUnu?=
 =?us-ascii?Q?tbIOnmiuZ0DAcaQud70A/UZO21QSBk3/GAfWnfOGR63J788BnEmVvCaFCjVG?=
 =?us-ascii?Q?DnUT54Vk4mjiqcqJNUHyjq8io7jYX+AJjIuicj4b63RQPy9c1E1ybRNOBQne?=
 =?us-ascii?Q?YBniX5T67oRoaujYXSjSa3oNsjVvnCdzLqdTTNbWVnRHoYMdvIK4mtkyYKa3?=
 =?us-ascii?Q?IIo8z1aXL5/h2OU6uriP7UpEviMJ3AwD+CkDvhBFKTVHCAe9Jw2DApNwm+5q?=
 =?us-ascii?Q?cn5xkFLqWZWdxUfyBBpPWRFo8dXlQUjYjPJdOr/z7uyxbcdfZDOHZ2BD4wU+?=
 =?us-ascii?Q?htt8VD+he3mke2xIKQlm3WCcHIuBOTaT7se8St6I1W2uPSb3YQVTbc4cJyxY?=
 =?us-ascii?Q?TERh1Vzy9YbbRKhvUse7On4uohXbx7PqC4udFZVgvbUVl0MtTsujiSWoBsz3?=
 =?us-ascii?Q?l+JER44pxnFZg0UqM8bw4fqSDdupVSAk2tYfhmIyHjIabh3j2JPPab35ouok?=
 =?us-ascii?Q?Fd94FaJ1QjpY/K0z4d4J+ooXep0ImM3NIFwQ0OKCzFSRJykK9uAMG+km5toZ?=
 =?us-ascii?Q?NRrJeh7+9qvRLamnJmqfZL6kI91tC2Y2RI1gPGF6Uflbbd+IpmVlIyG5aYkw?=
 =?us-ascii?Q?aJYnlIU4GaWVyaAjwW9ulfBGciR/dn0OFJypffN7uhyM6+HDE2Om4NKsUrHK?=
 =?us-ascii?Q?3CtdOYjldA=3D=3D?=
X-Exchange-RoutingPolicyChecked: N6onBMn2HYaFLxm1qk13xOZOg0uLXYI1Sjlpr+fKmBwQK+FqjZMtG6EzJ9UGax9TllXXnx8ReRUBME3lHKaE58bQQLoZemq+P94ZKLtO5W6wzSShpj6CjX2mEPY7IicqnjVJbY1hHPuCz3QqK6ZPsOrLMWzHYpgz+WYATJVCUu29Cglan8/J8etH2ndVxeClsg+n9PmHzyA77cJy6QwU6XbQ6rQmQvAupQq6r2vhzUAVIrE9aXTX2tEB+v5wuidHXSvg00f5BxpmNSsf3k9XqiisUWA5RDwHo3Yvo4lGGsJxAxmQA318WLPho2s+0UkDjI4OyusksSBZ1ysNLW3SSQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cf8e017-6bdb-44da-9e17-08df1a98e1d1
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2026 00:06:43.7810
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3+ewSz6Cdt+BkZ3fLNnnR46ekzzNmdUizN+ApaiiliJZFEcnS/xCUQenzS15HZooTvz4A5CuORjhs5bByZyLxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB468931
X-OriginatorOrg: intel.com

Hi Reinette,

On Thu, Sep 24, 2026 at 01:41:48PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 9/16/26 4:13 PM, Tony Luck wrote:
> > On a system with no L3 monitor resources it should still be possible to
> > run with just AET.
> 
> This needs more context.

I'dd add some more details.

> 
> > 
> > Update get_rdt_mon_resources() to return true based on whether the
> 
> "Update get_rdt_mon_resources() to return true" - this is obvious from the
> patch. Please replace verbatim code descriptions with high level
> descriptions and include _why_ the change is made.

OK.

> 
> > system supports monitoring rather than on the presence of any of the
> > L3 monitor features.
> > 
> > Refuse to mount the resctrl file system if there are no monitoring or
> > control features.  Add invalfc() to rdt_get_tree() so the console log will
> > let the user know why the mount failed.
> 
> This is obvious from the patch.

OK. I'll rewrite the whole commit message.

> 
> > 
> > Signed-off-by: Tony Luck <tony.luck@intel.com>
> > ---
> 
> > diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> > index e46eb9a4c725..d70c8cb1cb81 100644
> > --- a/arch/x86/kernel/cpu/resctrl/internal.h
> > +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> > @@ -226,7 +226,7 @@ union l3_qos_abmc_cfg {
> >  
> >  void rdt_ctrl_update(void *arg);
> >  
> > -int rdt_get_l3_mon_config(struct rdt_resource *r);
> > +void rdt_get_l3_mon_config(struct rdt_resource *r);
> >  
> >  bool rdt_cpu_has(int flag);
> >  
> > diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> > index e633da548959..addcb2a19c98 100644
> > --- a/arch/x86/kernel/cpu/resctrl/core.c
> > +++ b/arch/x86/kernel/cpu/resctrl/core.c
> > @@ -991,7 +991,7 @@ static __init bool get_rdt_alloc_resources(void)
> >  static __init bool get_rdt_mon_resources(void)
> >  {
> >  	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
> > -	bool ret = false;
> > +	bool l3_mon_found = false;
> >  
> >  	/* Any monitoring at all? */
> >  	if (!cpu_feature_enabled(X86_FEATURE_CQM))
> > @@ -1001,27 +1001,29 @@ static __init bool get_rdt_mon_resources(void)
> >  
> >  	/* Any of the L3 monitoring features? */
> >  	if (!cpu_feature_enabled(X86_FEATURE_CQM_LLC))
> > -		return false;
> > +		goto skip_l3_feature_checks;
> 
> This goto looks unnecessary. Why not just "return true"? Even so, this 
> also changes behavior from the previous version in a way that is not clear
> to me. I was expecting this to consider the number of RMIDs supported by the system,
> now that this function added:
> 
> 	pqr_assoc_num_rmid = cpuid_ebx(0xf) + 1;
> 
> Should this be:
> 
> 	if (!cpu_feature_enabled(X86_FEATURE_CQM_LLC))
> 		return pqr_assoc_num_rmid > 1;
> 
> Although ... looking at this closer it does look strange for pqr_assoc_num_rmid
> to be 1, thus reflecting that the system supports one RMID, when zero may be more
> accurate?

If X86_FEATURE_CQM_LLC is set, then monitoring is supported and the system
must support at least one RMID. I don't see a need to insist on more than one
RMID as a precondition for using resctrl. It wouldn't be super interesting
as all activity would be captured by that single RMID.  But it would be
keeping counts of events.

So you first instinct above to "just return true" seems reasonable.

> 
> >  
> >  	if (rdt_cpu_has(X86_FEATURE_CQM_OCCUP_LLC)) {
> >  		resctrl_enable_mon_event(QOS_L3_OCCUP_EVENT_ID, false, 0, NULL);
> > -		ret = true;
> > +		l3_mon_found = true;
> >  	}
> >  	if (rdt_cpu_has(X86_FEATURE_CQM_MBM_TOTAL)) {
> >  		resctrl_enable_mon_event(QOS_L3_MBM_TOTAL_EVENT_ID, false, 0, NULL);
> > -		ret = true;
> > +		l3_mon_found = true;
> >  	}
> >  	if (rdt_cpu_has(X86_FEATURE_CQM_MBM_LOCAL)) {
> >  		resctrl_enable_mon_event(QOS_L3_MBM_LOCAL_EVENT_ID, false, 0, NULL);
> > -		ret = true;
> > +		l3_mon_found = true;
> >  	}
> >  	if (rdt_cpu_has(X86_FEATURE_ABMC))
> > -		ret = true;
> > +		l3_mon_found = true;
> >  
> > -	if (!ret)
> > -		return false;
> > +	if (l3_mon_found)
> > +		rdt_get_l3_mon_config(r);
> >  
> > -	return !rdt_get_l3_mon_config(r);
> > +skip_l3_feature_checks:
> > +	/* Even if there are no L3 monitor events, AET might be supported */
> > +	return true;
> 
> Is it guaranteed that system can support AET at this point? Previous version used 

Yes. At this point it has been established that the system supports
monitoring ... so AET support is possible. No way to know for sure until
mount queries the pmt_telemetry driver to see if AET is actually available.

> supported RMIDs (return resctrl_arch_system_max_rmid_idx() > 0) as return value and
> it is not clear to my why that changed in this version. Although, when looking at this
> check it looks more like this series blurs "maximum index" vs "maximum number of RMIDs".
> For example, resctrl_arch_system_max_rmid_idx() appears to reflect the highest RMID
> index but it returns pqr_assoc_num_rmid that reflects the highest number of RMIDs.
> This series should take care to make the distinction clear to avoid (now or future)
> issues introduced because of different interpretations.
> 
> Reinette

-Tony
