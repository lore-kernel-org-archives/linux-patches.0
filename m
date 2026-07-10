Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54DBD3A4F50
	for <patches@lists.linux.dev>; Fri, 10 Jul 2026 20:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783715390; cv=fail; b=KEoHCVJECnendp3wZ4METyZXur6pWeye/eGJSrjYrH/749jjBbkrHbM8Tl8mew/AmgC0WuvpUnyOvS42W187oE9WgOko+gw1FYPzOwfkWgzjblyrf9JAjPw3X4i0TmLY9D11Ph3F1tabQ/CiSL1L0xphSCO2Ogfpqi4tPwDKIHE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783715390; c=relaxed/simple;
	bh=C3bgnZoNUVuwkfifuSTm1ZOgeXfeX3S39nnxbpEWvKc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=kbjrA/xIINoyPEvCGWedtg6lVhO+QUeaUG1POfD3GJcVjXWUrjM7d34kgN6mzfPYD0JNRUQ+wnDd9s3fJngHHtdNoaqBPaBEpBE8CcKfGenMW/SrX6RE5Tai/KD0hSfMh1QUlwnMwbtSKxEPQW0kNtsCMM58gOUViU+swnIaQgw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ElCO8PaA; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ElCO8PaA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783715388; x=1815251388;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=C3bgnZoNUVuwkfifuSTm1ZOgeXfeX3S39nnxbpEWvKc=;
  b=ElCO8PaAxuvMj24TRbWv/WKNXNrM065xWvXyssjmDiqFUZSUgSrPFwwM
   oeOMnfqGrV/lHAMEpjMlbyiYa3RUmxBxjBfiSrAVRXwNqKGvAoHKJmafX
   okk43pcHunweA0PNL+x717acEE0WhZSSG92akapuz5iY6uX0c624Ga0Kz
   5j2xGWB7+y55yeKN+/3b4hLSLaFCrthFOAfVF81MV2I1FoGrOGRscWUtl
   ajBOpgnABFgGKLnSgQsCWXc7EmUm8zy5ulYko00hFurpDH6saTcjDXMOx
   U8CC356kN1u8fZbxEpuebDjP2eYeIYwQlod8CCC2pk3ZdQ7OAr3lsJ5AA
   A==;
X-CSE-ConnectionGUID: 9T/b/TOzQ7uhg72fHwHCUw==
X-CSE-MsgGUID: zOsS31uzSRqbZZuoB3TJFQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="94772788"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="94772788"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2026 13:29:48 -0700
X-CSE-ConnectionGUID: yKO/h/6qT4WvKc26dY8ANQ==
X-CSE-MsgGUID: Q1AacLnuQ+qgflKUk/2r2Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="252341225"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2026 13:29:48 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 10 Jul 2026 13:29:47 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Fri, 10 Jul 2026 13:29:47 -0700
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.60) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 10 Jul 2026 13:29:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j7O3hsHX7D9R3+ExmBJN6rQIdSLm+YiHRROt8rxNloVyYFQ7nVWH4ZeFbozh2xLkIHFxUDrMEx4JWCzFQG3MZxzXO0ve9pz1jbZ1Wt50nbmXZ0qdGVSxxYN+6sqC4fJlZQb7aptA4hRuYyDTr22UoYyhaE2CmRixyG0OPMBWggOUmuyOQ0vCi0KxNVRSyWI8/fAnYBPY+C5AEOh6yD7LUCDVy++HZyYh/YRTdccELqgP+pgm1G6MWqDgNJ4VpfEnjyoY6GKWlka2qnviNYLK5pqSfJ0zFeM/6KTpb6hGc+rnx3kar9rzq59n43bLkZslce6/t9/Ataui5wkeQqL90g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a/6Fn4kVEpy9VloaJpxi2TzfYugkP86aEdIM+CUx59A=;
 b=siOPZ6A/d4TvWeAiSvBp17ILQ2jVUOX4YBItZgvc57lIMISK0T1zoOI34P+fCkjptx4QRI2g7MmJWuuKUuo+nK6XjAhPyaL9/uzPnfg0zdjubH88HC0V9BRyFQP3M2v2SsgXqrZuMENPzB5RmOFjSAAecMke4qE2P/DLk22H52fkIG0TOnHwDe7wuJiPNk2xDhVAHX8Zquh+3fZxR9XqUmKBUTRAGjWCGLrXH2MbpN2e+AD/rUfUC0OqSyZ2nifc0sqG9z+pJYIXvY1CW4ZAHxNAZKAewg2vBLyTEZHPMD34R8spqOEgK58fWgXMlaH1XWc+faoCRWO1m+FFiOi2mQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by SN7PR11MB8262.namprd11.prod.outlook.com (2603:10b6:806:26e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Fri, 10 Jul
 2026 20:29:43 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%4]) with mapi id 15.21.0181.014; Fri, 10 Jul 2026
 20:29:43 +0000
Date: Fri, 10 Jul 2026 13:29:41 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v9 03/12] x86/resctrl: Honor rdt=perf option to force
 enable AET perf events
Message-ID: <alFWNRYZuX-323H-@agluck-desk3>
References: <20260701213553.15222-1-tony.luck@intel.com>
 <20260701213553.15222-4-tony.luck@intel.com>
 <a6a0d46d-1b2e-4e6a-85e9-e0efb9aad8b6@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <a6a0d46d-1b2e-4e6a-85e9-e0efb9aad8b6@intel.com>
X-ClientProxiedBy: BY3PR05CA0023.namprd05.prod.outlook.com
 (2603:10b6:a03:254::28) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|SN7PR11MB8262:EE_
X-MS-Office365-Filtering-Correlation-Id: b5e8c5e8-0e86-4259-fcbe-08dedec1f999
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|7416014|22082099003|18002099003|6133799003|3023799007|4143699003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info: aug3XT48YAu0uYQcRWR3jAQQwfmlEm1PdsjrpYbysgHAMCXRRsqqCb+GmpkVXFPzhUAJWWuN0ljOOA7boajSmcnKn5HR1ajcYfpT78XL0D/T2QCZ1YXHcecm+/e37qKbmqBEIrQi/W5bl1ilWgwMVemjOEj7/iMt8kFENrh+X0Ix8lzq0M27GnEuOGBFQK5hxtYm/dS6hrD6S83T623GC0Sf5H0RhuyKiPlw5FLF2RwTWTIy7W+P4ngJwjuNI/pmx+6GM5PXv/1U4adxpZZWomofhiqorYVKcGxjtI01+UXXKzTiW3Qr5KFUuNJuScVmk1sjvmnwiMRXqBLT2VmVIROUskJgk+BJpt6fZr4cBSXbkNDAUkqcC681MYmyp64ioLe6+NwHaciK07LO+BHdjBLplhvJx/9Rgsil5GaJ6AZJWtNFE8pEIiPdsaSzJ895jsSiTsOLYvnh03i5exYHYHgCLVYKs9uykLFIITXVxxFKijdRZQpPKRhbIgIZNs8ZQqNUm3qyvHbeFAhyX7aBZaEw2qWMYWN8ipU8+txqNIfIOpgKy3buvYN3oU8iijqW+5zglwuQEPqPE3491O7ie0JypLWC/TUFxtlI0BJ03yj1vRhaZJzA67tK+Yq9Sdu4+Y1hQKnPijMnpywlH2J7lNwUNLCctGs1rSnxmKnVEzU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(7416014)(22082099003)(18002099003)(6133799003)(3023799007)(4143699003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iuK/cRlgnXuUp1e2tCLAC6H1x/NkIR1gBAEcCojptd5oG+dpnunpE/pqHbrv?=
 =?us-ascii?Q?I28gF+XJNQ8NIIo2GgQ4AvKH3JgAAyVLqMUmvpc7DolLJ8/0jkdnJ9xxCtk8?=
 =?us-ascii?Q?tKAye0DTcjgmQM8IMRzsAcni/p2r9C9kYPSMV29oR4kbdoJVwC8XZ9X/sQHV?=
 =?us-ascii?Q?QHFoDLFQF8/ypflmpVmy9X7RkqxX2rcshagD1pfZQq7QX+T4/JkTC+lUO68b?=
 =?us-ascii?Q?esrP0TDzyjlsLBTZy3n6RM5K5/rFGIr5NZw8mSy0fyQMrFUpA6rPMgfkRLG7?=
 =?us-ascii?Q?B+S/nCh+wIx4AwAIxjcG5f2U2xjEDLxFqR405qVBEusLQnrZvcnZKsZCB0Qm?=
 =?us-ascii?Q?qujEu62DIFORyiwlE+nCqNprPkWCSaJPC1+2EJ11ipdu1YuUugRQoq4WEb44?=
 =?us-ascii?Q?dSLW55FusaHSEZLtSdQQ2FHrS0yLYdd2oY0Jx8iC7yl4w0LUGvIuHGFISl0I?=
 =?us-ascii?Q?DsBLoHg6fvwwO6B1g5oa1v+EygGHxfQZ2m86EDK4u6XEXtOjJm4KuDkGfRZu?=
 =?us-ascii?Q?/qvBbXFoDq7gibnaq5Muu5VyJK/pjsZrgvfsV1MaaSkj/GsXDLjmR/U8uTzC?=
 =?us-ascii?Q?22ikTL9tx7mn1f66oHDM7674oty0K6awqtJD+u8lobLIkrNyoiKibuMzgiVe?=
 =?us-ascii?Q?E+E+PW4qgIDAiMvHKqsTLIldxLfgoXWQbqOiEbWpkDRCXo21derVXIQOVlpR?=
 =?us-ascii?Q?1Dc4Ug5AWK+FQh2d46bgafVD4yJCvdhDnWm8zl2Oy19l17IPCvMjQqHJ38Rx?=
 =?us-ascii?Q?27gJ8rufXapPtz8Mb545YrW1VYZK3QhiIhMXxZ1zXtu/EqNZcSVSY9eH6dib?=
 =?us-ascii?Q?3SgSNil6G0A1RVPa0AeF+oylcCdFkpsejeeF1I0QpSTrnWRR9yav8mfHybzU?=
 =?us-ascii?Q?xmkJF/g0gEHi0kiS3Kg0R1CePQpyRCDgvvACBoAKlOZkXfGEIhakRb5Ctlr+?=
 =?us-ascii?Q?XMVE5gvByirJM5CeIDIZikmIgGdbTt+YxBPcUopH/apcFbbhaiEzrcB7rHvN?=
 =?us-ascii?Q?dFZBViGHSZHwI4WkUbLuQxy8xROjPrh787QqIpvBLwA4ncMJvNRbnh26Adpz?=
 =?us-ascii?Q?di02KeAGiZbhVLQAZ3xtBvexoult/E8q0Ym5dlwDzJSFPB4R8Ajba6aRqyju?=
 =?us-ascii?Q?pevXm+dD5Rjhr5SH5rMsmMpMQw/lVCZoHVibJIvh+6CPnqOcodLQIK/letIy?=
 =?us-ascii?Q?WUhJxikvnlqzLM/D2wIrSdC7zIeCANPF+hi4Q/R320cEW3/hmJkLV3iKKyfY?=
 =?us-ascii?Q?WyqhcWfyaQq0MeC9f99ypAvD8PiK44wy4k1OTulvhwN44xymTfDEjn757ZhR?=
 =?us-ascii?Q?3Xzx6JMx/LLGfT6qkdE3BCdeLkwzTAC45bdz/fOjR1NUPXqgpmLX14LgycDj?=
 =?us-ascii?Q?XPZ7UucKiFbzfuAVaGYO63sAl8LdV4SqL2k5oGdt5n4O62lEim2iYND7HSa5?=
 =?us-ascii?Q?CEFv2aKbRQ6hCfgH7aeCMv7IDMeyXf8lWPStmqwY2kNxNc0TpSRsScJkVo8x?=
 =?us-ascii?Q?khkkdpTtraRT68p5l86EXdxrMm+64wFQzYhFus0j8/r4oEB2H5uYURgG5EiS?=
 =?us-ascii?Q?gOmyvOfxXZay1jV3PTS2/yiCbPRfPe4m5LFWw51W9rCg1aS79ruWf5MNwH/t?=
 =?us-ascii?Q?MUalg4xNAiQOdpUJgAEBvD4qbTrea9fdZPLbUoHmfp2vGcPXs2QqdSVxQZke?=
 =?us-ascii?Q?hY5ijAwXsQuouuJLPpd24qTVXonSk9wYwrJ++jqv7/1YHRY78mZDpfAEY8xT?=
 =?us-ascii?Q?H70AUbgUfw=3D=3D?=
X-Exchange-RoutingPolicyChecked: qJIo+t1epV8lPpUhaY2PB3UqLy3rI8ff4pS0UIXIBoweS9+DnstDoxk+9S9ODY99A9iJ4iPah9IrPmCEzCjSMC0oWGv6x4ae96Y2uHaCZG0Ccc1aw7VI48bFgWVmnOJ5E0zrzyjRKsgXSG5VklS9IcIALaU9pNOxi6Y5G+hkFxWaUAmz46rWWeVXZEJSXTgBCG+aiYafjCBfQ/xBaxaZk5sN1xSuTGOYYiinmGBBh3IloG7peEL8RVe8AG3K+0z2UdmAVIgtDhpUTvpyixCgLjteVsuiT0LT1KmkCerQnEW6OglIerRWK2EHXznUVWfC3U8YDUrAVo70foZWLlvHcg==
X-MS-Exchange-CrossTenant-Network-Message-Id: b5e8c5e8-0e86-4259-fcbe-08dedec1f999
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2026 20:29:43.2902
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8G7e/3rXc8/vVZaB3jN2FRqX4ooosDwPX6IO4hf8lRNe9ukPSieE/GMl6RPqH+l/8Brt+8hmpCQ25I2FwCmVaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB8262
X-OriginatorOrg: intel.com

On Wed, Jul 08, 2026 at 03:46:45PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 7/1/26 2:35 PM, Tony Luck wrote:
> > The kernel command line option "rdt=" is used to force enable or disable
> > individual resctrl features.
> > 
> > Linux only enumerates AET (Application Energy Telemetry) once on first
> > mount. But that is going to change to enumerate on each mount to allow the
> > pmt_telemetry driver to be configured as a module, and allow unloading when
> > not in use.
> > 
> > The following scenario will be a problem:
> > 
> > 1) User mounts the resctrl file system.  all_regions_have_sufficient_rmid()
> > notes that a perf telemetry region supports fewer RMIDs than expected for
> > the event_group and sets e->force_off = true. But the user had specified
> > "rdt=perf" on the kernel command line so perf events are enabled for
> > this first mount.
> > 
> > 2) Resctrl file system is unmounted and later remounted.
> > 
> > 3) During this new mount cycle enable_events() sees that e->force_off is
> > set and stops enumeration for this event group. So on this second, and
> > all subsequent, mounts perf events are not enabled.
> > 
> > Fix by checking the state of e->force_on at the start of enable_events().
> 
> Above just writes in words what the patch does. Please reduce repeating code
> segments in the changelog and replace with higher level descriptions to help understand
> "why". 
> I think a more detailed context will help with this. Consider, for example,
> something like below (a suggestion to start, please do not copy&paste):
> 	resctrl can disable ("force_off") a feature supported by the platform if,       
> 	for example, there is an erratum related to the feature or, in the case of      
> 	AET (Application Energy Telemetry), when the event group has insufficient       
> 	RMIDs. The kernel command line option "rdt=" can be used to override            
> 	("force_on") when a feature is disabled in such case and also let the user      
> 	disable ("force_off") individual supported resctrl features if they are not     
> 	needed.                                
> 
> 	Linux enumerates AET once on first mount and skips this enumeration if the
> 	associated event group is supported but disabled. Since AET is only enumerated
> 	once, this check is guaranteed to only consider disabling via the rdt= kernel
> 	parameter. However, when transitioning to enumerate AET on every mount, it is
> 	no longer correct to skip enumeration simply because an event group is marked
> 	as disabled. It is then possible for resctrl to have force-disabled the event
> 	group during an earlier enumeration due to insufficient RMIDs, which would
> 	improperly cause the kernel to ignore a user's explicit rdt= override on
> 	subsequent mounts.
> 
> 	Ensure the user's command line choices take precedence over system-level limits.

This looks good. I'll dig through it to see if I can improve any parts.

> > 
> > Signed-off-by: Tony Luck <tony.luck@intel.com>
> > ---
> >  arch/x86/kernel/cpu/resctrl/intel_aet.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> > index c22c3cf5167d..cd8257c58f84 100644
> > --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> > +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> > @@ -60,8 +60,8 @@ struct pmt_event {
> >   *			data for all telemetry regions of type @pfname.
> >   *			Valid if the system supports the event group,
> >   *			NULL otherwise.
> > - * @force_off:		True when "rdt" command line or architecture code disables
> > - *			this event group due to insufficient RMIDs.
> > + * @force_off:		True when "rdt" command line disables this event group
> > + *			to avoid system limitations due to insufficient RMIDs.
> >   * @force_on:		True when "rdt" command line overrides disable of this
> >   *			event group.
> >   * @guid:		Unique number per XML description file.
> 
> This is unexpected. The original comment is more accurate and I understood from 
> https://lore.kernel.org/lkml/ainCnu4xmHbgh91r@agluck-desk3/ that you were not going to
> make changes here.

Oops. I'll drop this for next time.

> 
> > @@ -228,7 +228,7 @@ static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
> >  	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
> >  	int skipped_events = 0;
> >  
> > -	if (e->force_off)
> > +	if (e->force_off && !e->force_on)
> >  		return false;
> >  
> >  	if (!group_has_usable_regions(e, p))
> 
> Reinette

-Tony
