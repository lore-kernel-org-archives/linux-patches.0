Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F8B5248F64
	for <patches@lists.linux.dev>; Tue,  2 Dec 2025 20:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764707613; cv=fail; b=R188atxz+2wYDwXKYWcQJOQB7kASrhGoNEDwqKq5A2xB8+4fILFLkEA7UDWwy8+X+NIF/08nD+VYrV8LPUUwyNyoXYOCN2Aq/09lfLVJ9Bakg0m2sqMIZxS/jUYKlxmMnY/GuBtyHaBT0kY+dtyeIKIl7bOaXFK/f4GWzVhBbLo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764707613; c=relaxed/simple;
	bh=Lbfr3JFc14YyLWql1j1wUImFNHwJijdWakDUs6lsPfg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=GO3wI9cDZdbxztwvQg3KMJrL+5lWlE4OAQH5xQchFcVMfpvcWs11i9JSdE/5x/lLMdoFLSgWJ969p9aNqQgODtumpWazmGcSNWy/Qdj03uPbTzsLlWJKGxApHhU6q/lCVWBbRWrCyCisv8DTQVgPiwMxmL9KTaXQ+ij/NL9D2Wo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PffL02Zq; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PffL02Zq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764707612; x=1796243612;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Lbfr3JFc14YyLWql1j1wUImFNHwJijdWakDUs6lsPfg=;
  b=PffL02ZqmIpZlni0mqoHyIGUfrCzqwf3by1YomMFIj0tj3c8eCQ1hcCo
   V+6OBvLCM8P7c6P8wPugA34qsdSsGEMt6qWiIlbATJCezQYTNvdWBqSM/
   edu266RUd0WZXA0T6Fy+FuiNRrpBV5M+zCp2MusOX1UMkQpJkst1Ku7k3
   kRspfUegB1DvoJB+S6NVIvhw3WChr58YjgqlnGJ345wRkefmgc8tl4UI1
   Fe4dLbiwqFXF/COIHogm8Pnjf8WBqu/ZgWe10tMsPiProCE0uVbxkUr/u
   xIELi8LLVNWHmrCfnBe4/+zl4bcqygKd1EhJYzYuNyHYQhXdt0Y5+DMVh
   g==;
X-CSE-ConnectionGUID: rQFkVFvyQqGmzhO/r4nWSg==
X-CSE-MsgGUID: 1WvCOiPgSGe6o0SL47TNrg==
X-IronPort-AV: E=McAfee;i="6800,10657,11631"; a="70549228"
X-IronPort-AV: E=Sophos;i="6.20,243,1758610800"; 
   d="scan'208";a="70549228"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 12:33:31 -0800
X-CSE-ConnectionGUID: 0KfL491/Qc+BcS8xTNsDjA==
X-CSE-MsgGUID: HsQXwkn3QD+4xUgIBYLWXA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,243,1758610800"; 
   d="scan'208";a="194358858"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 12:33:30 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 2 Dec 2025 12:33:29 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 2 Dec 2025 12:33:29 -0800
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.38) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 2 Dec 2025 12:33:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tREFTjLMmsKC7Zn/MKhXsft0mh+6NQvDtT5697X/fAbfwghabPM/qN7UjAmovGvNHzABNJuLuBIusmo7OoYl6uCriCDup1Yx8EObtuDGDVMY5Qm/oh7VyACqW4Bt+P5dLvEtv5mYftS6/bMv0w/LFJxB4wEbbAyQcGfy19WCxuSuy9FmiPddUS4+vctwviguUIu2El2qQ2VDDiQTAJJrUHmJp3m//nUVMO0QjeDy+M2KuhPlMTnXtbAx4fjkd7xBiJJzyI9o8c+/Qz03bo/2hwCxkBqy4DrzOwwYn7/1jn4ais5fsY8v4YV9ZoOWhOfZjBI7JHb4/vmZ2Xx/da5FiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TbdKrtEA+cRTd/BfScJDaIZdHIZ0Rfn04wC5rYdS6wk=;
 b=yxy/OiMev2TaR9s2a5U7V6Ii7JbOuIGqgFp2E60jtolare6cvD2p3ZBVKcE0E/tlKjLFCXzHM21PxZ+pjkcJdmwk5X7BQReOr/fryDahNWWObDa+Jga8PQP129zXPYsXL+i0t94s0QzCfX/8NCTjrDGb/qcEC4VjMq34C48l7g7CNXTUq0PJ3FnZp4QFZMZoui6R1IXKRD+LJ0zGPzGg2Rif71ZSvQ83KQW+llBsxLUadpjjOHnUGCXM/gx0CZCVZVTwQlZuNaxaFp6+1/ry14av2sCmjEVxzHYVFD+WIYOP2IaWqVGcdLOGhv8Q7LiKgAYdKOOgDA7hoezOB+7Eqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by IA1PR11MB7174.namprd11.prod.outlook.com (2603:10b6:208:41a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Tue, 2 Dec
 2025 20:33:22 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%7]) with mapi id 15.20.9366.012; Tue, 2 Dec 2025
 20:33:22 +0000
Date: Tue, 2 Dec 2025 12:33:20 -0800
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v14 07/32] x86,fs/resctrl: Use struct rdt_domain_hdr when
 reading counters
Message-ID: <aS9NEJAnx0MWoyaT@agluck-desk3>
References: <20251124185412.24155-1-tony.luck@intel.com>
 <20251124185412.24155-8-tony.luck@intel.com>
 <895cee86-ac6e-43e7-aece-e283200384ef@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <895cee86-ac6e-43e7-aece-e283200384ef@intel.com>
X-ClientProxiedBy: BY3PR03CA0002.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::7) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|IA1PR11MB7174:EE_
X-MS-Office365-Filtering-Correlation-Id: 04fce7bb-fcee-4b3d-d242-08de31e2091b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?rCaMiER+HOqWjMkniOR6uaUb3Yc1fZwlKhw/arfwWCfXLLkroyFD4RB1O8KI?=
 =?us-ascii?Q?ULnb9pbdZb60d3dA9fRU6zni8u4VqaLj7oTHprAOfiyo3HkXme0C4wQiYZ/0?=
 =?us-ascii?Q?7gD8V2ovOgv8YVGMX3IZUNHa753x7MbIhUQ9zTRiYrzkUP3i5RMV3p8FE2wS?=
 =?us-ascii?Q?U7O1oUNkLML8JaiGwlW7hjROaJygz2gLmDnk39k+2V4hMVWZsncMlWgAnEyH?=
 =?us-ascii?Q?KM382CSEzKQErd+2isSn8Ix+5hXX/pw1TRusbQNQcDVVOxY0ioIhQxKPP+6T?=
 =?us-ascii?Q?sB7BZYrHvgIOlUqZQainA2Viy1rMnglFCT6WxHKqSXy2g2ovBOJiY5I39tKh?=
 =?us-ascii?Q?gu3RrjSR6Rn6FrVZZWqZJuOjAe9n8cxYPvBWlbtezzHldrG/9kvAEHtu0ryD?=
 =?us-ascii?Q?tdoZanTFJci1iam0eV7S43K53HUvMITjdK64iKqA1Mr04He1o8dfe/tX9ZLy?=
 =?us-ascii?Q?/WM7sIcIibWHx/eHZ5xidUPpQQpOz1AvX8AulsZtprNtacGYci4fSImdyb0U?=
 =?us-ascii?Q?Frr5aIit8Mdt4PU1vtvJoHljVbO5DTaB/f6EJoUh8mVWPlgex7FkdtHWkRti?=
 =?us-ascii?Q?bdU7GH3qi0VgbDjWXQ4OypOQbRlrogO6rqCRf6KOBWL7ajiEW9Rq/GmZKvEN?=
 =?us-ascii?Q?QyP+6x5NXsSNvJoQT3bWjxF9ooi/olqmL0g382WtD9DldHsgr2ertFL86P66?=
 =?us-ascii?Q?9MriG51oS2B4qgdJEgknIiw1f6VL5eSQeJnFQa46wQ0M8qT0xtAF7PwwrAjH?=
 =?us-ascii?Q?EZ7oIBvBOtRDqCdr3XRGdL+k9Ztka/XpZCdndbxvApRFpakhWyX5Han0a9Z2?=
 =?us-ascii?Q?pwDcho8lHKf6ljOLFrCJNPU4+I9k887QMmRppDWe1DeklJZnihpm2UNtQKmT?=
 =?us-ascii?Q?sDA5w8E3GAfNrWf5W9+eSfEXgZ9UNFYnrojIiFPuHqIiMl8qslO8I9Bu9vt6?=
 =?us-ascii?Q?2Zg8FQpKBfrye/4GMblh7HMkuOdCyBWw5O+alX7j1vQ0LFzfQuaxAAdQWdHu?=
 =?us-ascii?Q?71S5c76ky4PxoDrLbUsarajP7ATbroeU3nRmMEbBpi9Fuf1pCedIHtuV0zgc?=
 =?us-ascii?Q?ryjVIaCbv5OQwOPdp8MnGhjmGKnTSaigLcExDKS07ycC+f5BECd7FFJ/uiIc?=
 =?us-ascii?Q?U/xhdljJ5bIxnFSsV7xclZDXp+AtdJfMG4EwddY1i5k7nR7Q0Mn72qjMhpMt?=
 =?us-ascii?Q?uhPbLBUeDZXzgsjFT6GA75h+Eh1frUo9SLJqxIZ1+yvxgqJLokI4PfnLDLpw?=
 =?us-ascii?Q?mc38zygZWwfK5JXxw7BaIDw3BGMExp1aBMLGFMOOybhf2L85poMK8X0lxiqF?=
 =?us-ascii?Q?aYvT2lrO/i6RAM5faIRenuv+vNbb/MTo0tPT1VcidTquphlLvb6T5qTG7TNu?=
 =?us-ascii?Q?/3GIv8s27yKv6JBmnTnoe51pgAEbJcPLqaMk6auNyMgp/2HwPjDKsd4BG3li?=
 =?us-ascii?Q?muoGtLtKBH6yDoU1YvM1rK4bKd+QJ/fK?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JFHMx4Rh/nxn4y7E1MjvLvY3Bb9gbax9Zu9ZsNYw1wDJjjATSfVAdSodZmHu?=
 =?us-ascii?Q?WkqSDz6X5b4C8cr9drhnzUAVu1dXLqfRP+KdeuXNrxIPlXSnc1mSEaPxpz82?=
 =?us-ascii?Q?idkczO3ezvHlAv3DGjJltC652mxAm2x/gfehaSQSuYE4UYMzqSeNLOwUy0hb?=
 =?us-ascii?Q?R5pvOyTip5jU0CZZW97r1jX1txqVC0OMTgROP/MO9ZaPPpl2F+xGFl9vxJxK?=
 =?us-ascii?Q?lx/is6nEnSR0rggE2GAVrk3+x4D8uZqNsbUV4IfiSPS69g/OmUSaT8PzEjR9?=
 =?us-ascii?Q?RLTptbYZiu+A+ZhYHIe8ph4mOitP5h5z/f7Xd4c83y0qZ1msu8lnjPsrb0+p?=
 =?us-ascii?Q?hXA17NcQLVIuCiIz9GgaCI21k7DrZYHOKVt9FLestWsGe+xvBNgLx/1e/D1B?=
 =?us-ascii?Q?veXHPOkEosziPFyU00JH9eGmD1IgFcTFpIsI3/4Xs1NW5ZhwoRGrWCQlXZ8K?=
 =?us-ascii?Q?77xXMN+7taNr4gFIGjWPQvNTn4zjESo2PrSznrGoocvGKchvxQBIJwE+t4H8?=
 =?us-ascii?Q?led+wjM4D9n2kvEJOmfwqx9x6UHF1S3zJI7VzRDwyflwLOE7Ib6Nz1kXHWNV?=
 =?us-ascii?Q?AYM8EY0XGO4te+9frIpmKyy/CAAIwqIrPWEjZKUuBZJ9anvqVRpNsuHttmxN?=
 =?us-ascii?Q?BgLCHDvPnCbyNMzIDPToL4w8iQnSCySF5nimfPa8k4wbpJn/WxZS9z0cBxu3?=
 =?us-ascii?Q?KzQdV/9nXm8CHvGA1mVXxwzOjoWuvyvAHgOtoo3pSie9yJ46XhI7emGEDF98?=
 =?us-ascii?Q?5PqqFfN+zQ4oVRQ2ftm1DhlZB3/dWl1+6QWEudHV0Z7UCqQjfVoU3I8+C5Jc?=
 =?us-ascii?Q?2XgyEeOG0OKwSBva+UCK53ZuJw3Alqq+P0juITPeZ/ajkbQa1w/xPmV0uzWJ?=
 =?us-ascii?Q?0/WIvGoTYc//wR19aPZH8cdIwGX91qcLVHn7yPA4I9mqRtvPoZ/jON9XB+IB?=
 =?us-ascii?Q?fwfGJpInSA7xbiF+NPZkk+fa1Yr6XqzaDf3GNk8iEYU8tt7GXkFT+h2skc8d?=
 =?us-ascii?Q?fJ805eisJ1L9MpMHlEfOzIBCtyYlT/gjqKOPztcS7uv72mKSU8dWZzfiLfoh?=
 =?us-ascii?Q?dseEev9i8U9K2hUIAiZEUadEvi2avUxe8DyTbHJktpnnK7bs+RvqRYrJn+uC?=
 =?us-ascii?Q?I9jVxxBDQU1jLc1Qvdq41BdcOByXjXnKZl8G3F3uKj4oxWrh9sVbp1jE9vNV?=
 =?us-ascii?Q?ql5Xh46d5XQErzjR1H9fGiar/XSwpXkPzNKVWov+lUJcr85NATnVH8P19Snp?=
 =?us-ascii?Q?Gsx8zOcD8DC5JaytkDeVN03twwR9+x0POT4M9LgDTA4JCvR3ZmhNV2ZiYAGX?=
 =?us-ascii?Q?pIhBew8b+PRMyBLjTQJMTL0pHXUMepCTTvYzF7afwGAv6YKrKooTUxvZQ5e1?=
 =?us-ascii?Q?v7Ho35sVjMxlTmx4fLNxC9vs6wg4TZTwnpvxhj9SDwgI6561qQxdQXm9yDYU?=
 =?us-ascii?Q?cd0dUY0tCi5QVl4v4veqA9i0QHrJs5Rp0zGlTQA9zCyq2I7umLhXeEAbo9JB?=
 =?us-ascii?Q?mUmPyb5+8OjZv/GxHJy3XPAnIuI6KxeOZRqQNGcizyTVIrbXZAyRVBbjBVWO?=
 =?us-ascii?Q?6E9+q26IiyFJCknJ81+frTLLG6AaseYZJzYVmN/K?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 04fce7bb-fcee-4b3d-d242-08de31e2091b
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2025 20:33:22.1751
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JNG512yeO3QIh/jTKKrvo/f7x8SC9nEXgqikskTn9S0JMBS5zb3/FKRP24cyL7PoWlqhIBmf0WAxl0bU96DDBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7174
X-OriginatorOrg: intel.com

On Tue, Dec 02, 2025 at 08:06:47AM -0800, Reinette Chatre wrote:
> Hi Tony,
> > +static int __l3_mon_event_count_sum(struct rdtgroup *rdtgrp, struct rmid_read *rr)
> > +{
> > +	int cpu = smp_processor_id();
> > +	u32 closid = rdtgrp->closid;
> > +	u32 rmid = rdtgrp->mon.rmid;
> > +	struct rdt_mon_domain *d;
> > +	int cntr_id = -ENOENT;
> > +	u64 tval = 0;
> > +	int err, ret;
> >  
> >  	/* Summing domains that share a cache, must be on a CPU for that cache. */
> >  	if (!cpumask_test_cpu(cpu, &rr->ci->shared_cpu_map))
> > @@ -480,7 +494,7 @@ static int __l3_mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
> >  			err = resctrl_arch_cntr_read(rr->r, d, closid, rmid, cntr_id,
> >  						     rr->evtid, &tval);
> 
> This is not safe. The current __mon_event_count() implementation being refactored by this series
> ensures that if rr->is_mbm_cntr is true then cntr_id is valid. This patch places the code doing so
> in __l3_mon_event_count() without an equivalent in the new __l3_mon_event_count_sum(). From what I
> can tell, since __l3_mon_event_count_sum() sets cntr_id to -ENOENT and never initializes it correctly, 
> resctrl_arch_cntr_read() will be called with an invalid cntr_id that it is not able to handle.
> 
> There is no overlap in support for SNC and assignable counters. Do you expect that this is something that
> should be supported? Even if it is, SNC is model specific so it may be reasonable to expect that when/if
> a system supporting both features arrives it would need enabling anyway. I thus propose for simplicity
> that the handling of assignable counters by __l3_mon_event_count_sum() be dropped, albeit with a loud
> complaint if it is ever called with rr->is_mbm_cntr set.
> 

Reinette,

Agreed. I see little liklihood that SNC and assignable counters will
meet on a system.

How does this look for the "loud complaint":


static int __l3_mon_event_count_sum(struct rdtgroup *rdtgrp, struct rmid_read *rr)
{
	int cpu = smp_processor_id();
	u32 closid = rdtgrp->closid;
	u32 rmid = rdtgrp->mon.rmid;
	struct rdt_mon_domain *d;
	u64 tval = 0;
	int err, ret;

	/*
	 * Summing across domains is only done for systems that implement
	 * Sub-NUMA Cluster. There is no overlap with systems that support
	 * assignable counters.
	 */
	if (rr->is_mbm_cntr) {
		pr_warn_once("Assignable counter on SNC system!\n");
		rr->err = -EINVAL;
		return -EINVAL;
	}

	/* Summing domains that share a cache, must be on a CPU for that cache. */
	if (!cpumask_test_cpu(cpu, &rr->ci->shared_cpu_map))
		return -EINVAL;

	/*
	 * Legacy files must report the sum of an event across all
	 * domains that share the same L3 cache instance.
	 * Report success if a read from any domain succeeds, -EINVAL
	 * (translated to "Unavailable" for user space) if reading from
	 * all domains fail for any reason.
	 */
	ret = -EINVAL;
	list_for_each_entry(d, &rr->r->mon_domains, hdr.list) {
		if (d->ci_id != rr->ci->id)
			continue;
		err = resctrl_arch_rmid_read(rr->r, &d->hdr, closid, rmid,
					     rr->evtid, &tval, rr->arch_mon_ctx);
		if (!err) {
			rr->val += tval;
			ret = 0;
		}
	}

	if (ret)
		rr->err = ret;

	return ret;
}

-Tony
