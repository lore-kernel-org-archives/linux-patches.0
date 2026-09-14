Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 040F8345EA8
	for <patches@lists.linux.dev>; Mon, 14 Sep 2026 21:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789421626; cv=fail; b=OLzHS0MC+taIOAj8Nqik0KTZR9W+9WtyOADOz8Lblo+hPJ88edOgoY0/6WjvbxWnhwVp2uu8BO3RfpNEbke82v0tvGmfBS1NIslSiCPtf/x/IpGjhgYUSJkFaqt+hxWNJcppP9tfLREih/y+c7fEt0SyoIwuocUQyU07G0bey9Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789421626; c=relaxed/simple;
	bh=yEJ3YYsf6sLfxfzsbsASF5gEwV/zd3MtaJ1t8PRZ51g=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=uFfabU5EFTO7pYbG9qAaXHjq+fsV9r29neoVGby12uq3r0+app7tpTF6BPOxYmDAKGht/VCY4vke1rGIA2wm7PVITvnBf23RjtE12k/yFsYl76tQZO0pMl4Rlzteah53w4FkCcTDZgodJNvWh/DdXpRH4AO5ctgH0eVzEdA1Ogk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PWpjWd52; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PWpjWd52"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789421625; x=1820957625;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=yEJ3YYsf6sLfxfzsbsASF5gEwV/zd3MtaJ1t8PRZ51g=;
  b=PWpjWd52wml23Npa/IG2G8jXFvQ4GMLiTqS9UQYBP3svw7MCM1Cy/F8k
   EHcbQL3lyulBmU0OgGynOLyLmCmZ5qu80CZw90wxLLVV/EXjs0FjQxiQR
   gyT1oqUduUNsJl/fJbsMzCBHls7t4DdJQIE6Gytx7sJ3sT95f7lqjLFvW
   8Ic0EUhua1mBjzmSvsNgAu4im7r48TAeHlRaskWKlpUeFT3pqXMI0NIh7
   cBSL+zeFa8IATvveKGtU5En6Yg/WX7uz1EZLjPhYZU+bbsp8tQftDWCf2
   bQkC8xXr3weAhjoXr9RZLBt62N4i6MwEaOL4H0Y04qW2Z9FnqftBkZ9rc
   g==;
X-CSE-ConnectionGUID: d6q2gBG1S0SmoY1Az07QUQ==
X-CSE-MsgGUID: tVyMXqE8S2aOPLlm7VBMSA==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="89908950"
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="89908950"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2026 14:33:44 -0700
X-CSE-ConnectionGUID: 8D+XPXOjRRC5CvoWvy1Amg==
X-CSE-MsgGUID: nZ8XshQfSyi/onpnGqlY7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="270937882"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2026 14:33:44 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Mon, 14 Sep 2026 14:33:43 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Mon, 14 Sep 2026 14:33:43 -0700
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.13) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Mon, 14 Sep 2026 14:33:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dsWtDk/87xMSic1meENsGP3CtJ2DkTBTp+WoG0kR6dUq+oJ7xoOx5U1P4PWzrY/h25rUfTqqrRv3ZolLYc0LO8o/Hlo0sK54L+WgbmNiqflG1D9ZK8F2NqBYs/oX79TxkVINSHU2fIDX5hpOtabsK4g2NGN1OE9OAVcEAqAA4vM4gyORxvbgJD41bwF0aiacHkqNeKIM7AfjIIZQKlQA6Lj7Bfnt+pBKLhZj7sjmc/K6n1sM6XFzDKDVsaq/wPXixRvoN8d6M56eSiGH5VS+sejgi47sySIq9Br1ecjA3zN1VpxUG3wCflO68BF6My/bScUEodCGh78Gzht9UHEs+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cMmD7DHCZowzrvcbrK8exmdDpYukiy9gbRJtgKDMiEs=;
 b=a9akKsMogD1QlkOdSRYlcVygfjfUaRE2xG3BUZDMlt9Ra8Rq5Ru2FY4Z6Jt8jhbkFn9IGC8VUBW+dbD4Ex5NRzA8LTq1MdOUeXZZTnmSQRpfgOU6Y9QyudtoYbiXwh434woqhGUP1FLXe8rG6NpqSdafNDZ6xNEQ+pUYcBlQebS0P3hKR6rLCHZMV8dCFBsmVvI7lQZv8+BFR+wqtBh02WlBVhnTKv01c2g9UY8a7n/oYnZFpvOc1KfovPfoYTzZgoHcNvG7R6Vs3cgcUmgX3kgaNGNIT2ZTDWmjjVHxW/VhzZSPGDVFvVjahZo2OZ3NugEvlTCjKfmRM+wSmsdtYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by LV4PR11MB9489.namprd11.prod.outlook.com (2603:10b6:408:2e4::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Mon, 14 Sep
 2026 21:33:41 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%4]) with mapi id 15.21.0406.007; Mon, 14 Sep 2026
 21:33:40 +0000
Date: Mon, 14 Sep 2026 14:33:38 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v11 14/23] x86/resctrl: Enforce system RMID limit on AET
 event groups
Message-ID: <aqhoMhn4rsl-HWmb@agluck-desk3>
References: <20260831174421.13921-1-tony.luck@intel.com>
 <20260831174421.13921-15-tony.luck@intel.com>
 <4cfe5c3e-c061-474b-9c47-483b87eecbcc@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4cfe5c3e-c061-474b-9c47-483b87eecbcc@intel.com>
X-ClientProxiedBy: SJ0PR03CA0335.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::10) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|LV4PR11MB9489:EE_
X-MS-Office365-Filtering-Correlation-Id: dd30e89c-5dd6-4b27-f15f-08df12a7d80a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|10067099003|4143699003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: OEJ394TzUfZBnk2WiIQPQIYEurazabEi3LfVaKVu/zVOaiyVeg4qXTW/guhqiCk/PmIJipb52taactdI176M2LKVF+GjntjCNe03Nrkigf5LXE2BAn7ONoiurbr6uXp+EikIA7F+2bbdD34XwOjEW8t80KhjTWHvfAUW1wq7v2dQHvbrZtx6WBIl1Dv6eycMhSL03qrznbQDYsWVXpOc0IqOTBknJXKgIyMtsTKJJJULlEXWZqsoSIcHs0SW5tM7DWQbR3mKwEV6N7DDMKT7TvRG5l8fpeJZr80SaEmXiukZvjZeb1+DZLn1qOuzaqN96Zc9ROhSBMx9ms4G6b+Y27NTIlHjf7gdztX2cV1zW43e/HUQ646ilNSv4eYVbewRurOYG5OL4vNSnzZHXDcGhC00IQFEYvUPM6E/Gm7qjfs+wTSzoUfL4vut9iYmd2TBZweE60BwDFjv+NZRQ0RACTjLzArjK8T55xY7AEkg+CaDIdWIfA3/90Ph65ce7Rd9BlsV6WvJSmQuufI6hc9ZhlKftJxBCIpcFkkCUrGQB0TZ1OBxXG1oBRoQPhZt6leemvX9WvMR3Rd7fZLjeH/FUKWp5nz5BKwepaCl028LORzSQ84RNdc0hDZDeBUlgtUa44n6rdqszaGmObEDk1xXi68sedAoA5fuDZBZsyNePsQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(10067099003)(4143699003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QLs2kz0fbeH5dfMFfgPm7e6kaHC2zc+nolnRasMcGHkezLl0nCZGa/tFd1zR?=
 =?us-ascii?Q?XYjMuJYKQUURJyVcmUsi6QHLjciZ8ApUrUUlpq7fyyhMcDvR2cDhP1T3467U?=
 =?us-ascii?Q?o/UYwYCPntSq4ozuwQY9mIXNPBZISPNIKq0Xrxy6Elrpha6H2S15pqUgXizz?=
 =?us-ascii?Q?gN6YDCGaDSW0JQKoy4aeD6uajpa2VckOZ5ORzVE5nhOZxr2JAxVyTOULIRuL?=
 =?us-ascii?Q?1IABN93Ay4WVug/Auorl+rrAr6kWjbhjxhd+DGna1YQMooCUShkj/tCwteXp?=
 =?us-ascii?Q?eSutfk3pirkFPDyt103BH7NcnkrStm8MTccNlQGdggNB9lAdNdZ7Eg4tzfMX?=
 =?us-ascii?Q?zdESggNWQrvEXdqindW9CXkj1U1UeKAZTP8bg0AUsIh1UXf7oaPmyVcDYJfX?=
 =?us-ascii?Q?2lhwePlqlMgXlCFto+6W3BHkBnRzBcT7vXKEDimL/S13wgwIAHIna+77qWEs?=
 =?us-ascii?Q?YiKjHvvHQGqAjRkU9GC9g2rY7yHTdxp1cSaKONorIxAm01WEEctriTFZOBZP?=
 =?us-ascii?Q?rqUCJEY3QYtOoIfkNTczpjUVyROZYLh06J6xM8jXXhAkdC0dLTNjCTNgRxRA?=
 =?us-ascii?Q?VX2NBqrYhRzeGWyIiZsYoCEpvMWOvDS/mfKMI6APRABYmIhIFWUMdmJDyYFo?=
 =?us-ascii?Q?PzqT4Ums+5BNFprrn3SbbVbn+Pgltz1RgG57v0EIGtT2ksbddJ3EvPaPbhbD?=
 =?us-ascii?Q?Y9r96iIXo9tfXnHJDs1wLtpqCUlXf4U7eiQOIYILWl9uhVFRLMKGlFZMJcnr?=
 =?us-ascii?Q?uPsv3ljQyQ7yXhpxeToMSEzJRXiQMAfFZXj5wQIee5KdunlFNV2cNny71GNP?=
 =?us-ascii?Q?Upyhy4eK1fStdV75CG0fi3UNKaM/mlXouJelNUf5hV98v6Av8aWCU5siZAZC?=
 =?us-ascii?Q?cAqM78x/Jz5Fax2vbCtaFxxD24exYqiUMSwx7/kFWImSJ+4GjfSkN/1v080U?=
 =?us-ascii?Q?XwClLtMEdAGLVcpZfAuxd8xgqBx74V3tZ/0klgpz8S/o0ctg4iJY4MUBWJAh?=
 =?us-ascii?Q?+3PFgi/8kmj3mVxxWrjxTv/qIB8446mwsTx80SsuAfWyI/w58SWJZbIupGDW?=
 =?us-ascii?Q?yk3Fg6AxB2UIazyRXChZqmCZoe7/zYG2TWJueH9bTc3mrtl6xSMC7C1wSBOB?=
 =?us-ascii?Q?JOwE6M7yTQRqa6OSa0fPd8RvbskbA+HLlOMz0jq6/pbkl/wbAfWwGAAa3jCR?=
 =?us-ascii?Q?Bt6+E3Zjh/+cJY/3WvQLTGQfUuWCNSwpFzgBoCqvCIEmIlADiUIHL/VVdeiE?=
 =?us-ascii?Q?jNpqNFT9jZoPFiVQORVytgh94RzmNkK9WljriHeh+0j3w79fRYHWiA5hsyPV?=
 =?us-ascii?Q?sDHhww4aaYf9rSZ6qQGvPwWKlbWX2fje6568oD/1QPvVY7a3zq+IXZZL7nt3?=
 =?us-ascii?Q?oiNnE5hkVfvLgLTZAMDamAlI3YkqPGa+o/SwXtCYNAkIoYobXK2JC0psSUkI?=
 =?us-ascii?Q?THUFsLdNwIbosxJonnN7V7F+R/UqGaVo52+hpnbLKrTHT5cDBs5RiUJkH2gH?=
 =?us-ascii?Q?e5siZGQZZOPhTJwR6AZsSiy69+xaaZ7ZUS9N2v37iTiSZM6Wpoh+HOEPuIKA?=
 =?us-ascii?Q?Aa3s9uCIqJIBRPYP2wGGvHb8lOK7oVE+Apy3Mp31koKrIXSoXEH4OBQzAESY?=
 =?us-ascii?Q?APQ7Gbpxuj3lR4w+4Z6LzmOzvELSODtxJR4t4F5Iao59rftJGmpH4HWQUTu0?=
 =?us-ascii?Q?YTGjbqYVnTM0PmsjAiyXupfswCqOi1JlzF536ZmrsEf+Xohz38/ztxaHmquO?=
 =?us-ascii?Q?Xt1Rr/PiDQ=3D=3D?=
X-Exchange-RoutingPolicyChecked: 4TTQKlnKutuM1+8hlCas6f/wiSOVj87qEKXm+KsuSOo97iaER6+NVRqQxf//nYBWCdyRGEpYI4utSxEd1AbTMn1CKoq5G9ty8tQvYs6vks5OdD0ZtlB1mFerDM7TIZ5vGuU/RzSrjXjkVMnvNpn16qYdr/OvIca3CrxY/d8kYMpjg8Isg2EXEXBjM/AB1EoSiCPWdoT71cdCuCGUI81CX+bgiPBHbrihzT7kv14xc/INl4QY32qRz1qvgXqLffLBmnaUmv6I/7cJwOPQ3ImfxdJz+6H5GhKxbQn1ZKfrNtfLGiJ+yx/c5LknsfGaf1Wzk7L322JGr9wPUeTz+axduw==
X-MS-Exchange-CrossTenant-Network-Message-Id: dd30e89c-5dd6-4b27-f15f-08df12a7d80a
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2026 21:33:40.4950
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yeQ1ltDVSoBy0J7Hvwbic0PtwN/7qX5aAr89BtIQKvWlAOSRje8AAJGSIvFIT0+fjwxxRrSr1AUr2bRm5FAdiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV4PR11MB9489
X-OriginatorOrg: intel.com

On Wed, Sep 09, 2026 at 09:05:28PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 8/31/26 10:44 AM, Tony Luck wrote:
> > AET (Application Energy Telemetry) event groups each support a specific
> > number of RMIDs. But that number may be lower than the number supported
> > by the system. This is especially true on systems with SNC (Sub-NUMA Cluster)
> > enabled as that reduces the number of supported RMIDs.
> > 
> > Reduce all event_group::num_rmid to system maximum.
> 
> Why is this needed? Doesn't resctrl_arch_system_num_rmid_idx() ensure the
> minimum is taken across all resources? I do not see why a resource needs to
> artificially reduce the number of RMIDs it supports.

rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl.mon.num_rmid is used
to display the value in /sys/fs/resctrl/info/PERF_PKG_MON/num_rmids.

It would cause confusion if a number > (CPUID(0xF,0x0).EBX + 1) appeared
there.

E.g. suppose AET is the only enabled monitor resource, and that you are
running on a low-end CPU sku with fewer cores so the number of RMIDs
supported in IA32_PQR_ASSOC is scaled back because of fewer cores.

AET will claim that 576 RMIDs are supported for the energy event. The
user would see 576 in /sys/fs/resctrl/info/PERF_PKG_MON/num_rmids.
But mkdir for monitoring directories would fail before that many
MON directories could be created.
> 
> Reinette
> 

-Tony
