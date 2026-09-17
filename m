Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA69D48F83A
	for <patches@lists.linux.dev>; Thu, 17 Sep 2026 21:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789680192; cv=fail; b=sYac9A4ET12WKp+VzDHWTX21OQY+/S1Yk+wZJL8poobFpbbZ7/CwDFIJnjBf/Ev690SXsqMM0Ou2nHKP4J66vix50ubPWGAl3uC2aB6vts+Rq9kDO1fCi2oMxQ6prPmDg864hIxiaLmC7+omSyxTstsUP59w2KfllliFnn8rJ28=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789680192; c=relaxed/simple;
	bh=opW1gC7wJvbqf5lne3/vwAjKNv0MdnWrqujdR/MeTd4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=PXaKmRZgkHsDqfLbi70QM1L8Ydrz3VRd644+KG0f/YB78kq7tG2OWK8wGXg4zb9RaUCUdr5Z4R0+yCQXunXh8wt7pr0CmqqfdnuW4cF3nTdyXwHz/mGs/85Th6zj8w18nVTjsL4u3YfnoUaSX+3EwoXzpBLVHDnFTrsYpex9xrg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=J5xMGYHJ; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J5xMGYHJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789680190; x=1821216190;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=opW1gC7wJvbqf5lne3/vwAjKNv0MdnWrqujdR/MeTd4=;
  b=J5xMGYHJlc8jB6xd+neHV9O1ye0fxbpIoZpX3kG7S0hyqHnfveUw07dQ
   WTvLzF11T7HXabweLTQWf0iJyxk7fcQqgATxoW8oWj7G8q1a/+3UBTFZ/
   Dxm/4iuafXYaPMBj5qg/yb7MBE9RWYCT/DEDhXhKDFyMAPlPXD+i1UV+t
   IswJFBw8IWTcjOA9HkHfd9i3FjYjzirN+LHqRO6gkA37KwZYz/9kqEM/K
   IXmFehaUncEKcm1UxNx56wOLit4FZn/ULHNIu1neHsTHZFNMNu9sMQH9A
   UrnQ3vPP35m/x8ND3sRhspKZDYDrfBHc7ubYSkTt6mYU4Y4EUiIRktGUk
   g==;
X-CSE-ConnectionGUID: JpK+qzYkRyqkK9XboufIGA==
X-CSE-MsgGUID: 7fKx0sflTJynI6RSPParfg==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="93982129"
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="93982129"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2026 14:23:09 -0700
X-CSE-ConnectionGUID: ZiR9qYN6SBOIVwVJdZcF9g==
X-CSE-MsgGUID: y2y4HSo1StmHuv2vefKr3A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="276004609"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2026 14:23:09 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 17 Sep 2026 14:23:08 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Thu, 17 Sep 2026 14:23:08 -0700
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.56) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 17 Sep 2026 14:23:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EMuTMNgm4DmBZOinUCDkqVVLopIYdAn0KGrKGy73zyfv/LBb2IbVJd6cNlpiiOS4Z/fv8jqgUTs3BW/XbEbfH1YEAflQQsK6BSHtvBVZKKfQC+FAPxsq+uwzbWWf+vNhFXU1bb3zJ61BshFF77AScsfVdDNTYiDQwt57vhbn/0Tbr+QcsnNo7qNomytB2nKFR8PYLJ4EVLNb9Ad15jEekkovyXf1sJ/AXuurnUJ+22FuD1vtytjEXbyVmpGFqCW1oA+PHUJyHO/Ok9HRpOGbMrkdOit4MGrdFmXVmSLCkPTSBE9evszW0gTTuP3JJmpesCfWKKHk9OSFzzzxXAAUuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kOGK+FFWT8WD25agpXMd+xsp5cVkI1RylGMnJq2mFDg=;
 b=FSLzU19NnmrzgEPS1r5WBGQqIP+aqopRDazvSexkPHcHyn64Mp0iddq6NhYPvvx17COGfk7Tzylkn7+l6TUJqsCH8CiBzpYi+jF5KPivJ7rVwMWh3yjxTdY13Ac2anZzFaw0J9r7pjIZgiaZYzX3FHxj5+DU/sZqbQ5ovSFZgm30ohhBNfBhsIo6V8Yrx2RnBLhUmdxx1LaWrv9CulH+pzZHEs8KFEIOKmA8Oeb0swwiuIA4UrdIB8/6PnSDUodi1ZEBhp30pKRVE58nJHHapNPAre4qQWcX4rJqE7jekVKg2YRY1KH8KV+nnHme52eTWD7gLDfAeHysHeA3fH8Auw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB6077.namprd11.prod.outlook.com (2603:10b6:8:87::16) by
 IA4PR11MB8892.namprd11.prod.outlook.com (2603:10b6:208:55c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.13; Thu, 17 Sep
 2026 21:23:05 +0000
Received: from DS7PR11MB6077.namprd11.prod.outlook.com
 ([fe80::5502:19f9:650b:99d1]) by DS7PR11MB6077.namprd11.prod.outlook.com
 ([fe80::5502:19f9:650b:99d1%6]) with mapi id 15.21.0428.008; Thu, 17 Sep 2026
 21:23:04 +0000
Date: Thu, 17 Sep 2026 14:23:01 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>, Reinette Chatre
	<reinette.chatre@intel.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v12 00/25] Allow AET to use PMT as loadable module
Message-ID: <aqxaNWlVVO22k9oN@agluck-desk3>
References: <20260916231320.14502-1-tony.luck@intel.com>
 <aqwWOs0WdAyssc96@agluck-desk3>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aqwWOs0WdAyssc96@agluck-desk3>
X-ClientProxiedBy: SJ2P220CA0004.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:5da::11) To DS7PR11MB6077.namprd11.prod.outlook.com
 (2603:10b6:8:87::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB6077:EE_|IA4PR11MB8892:EE_
X-MS-Office365-Filtering-Correlation-Id: 6cb5a426-1103-4369-8205-08df1501dc42
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|366016|376014|7416014|1800799024|10067099003|4143699003|5023799004|11063799006|56012099006|6133799003|921020|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: 6/3JaSzvflzW+JKgXkDJOUwhcyQQsEejdnTw7J2OIG5t+npEgrs3sBxmW4+JPUbEExSDzld0QVytCt3AawJSGOpo80WRZ6xiyIx3fk9o5glc+o5azNCpcf+RpcnUtRlq9KsxkI9kff2iD+/BfwtLLPsuJHuVUlb46uVeVZiwZs1lipXmEz7S6O/7irC8hVaCsqwpYaPYfmhxO7V6h7hA6q6gsBRZj1lNS6bCxCzzPpfZ3Bo+2eS4o1BKK7/ndNwwPc3TR06EAL5S8Q5Bp9mexBGDQ5BWCmvnDDx15C0EtkyhNj3HOHrx7Rw+alwsRcOWZ5QZJZ528OhMWkOzHf5rdvltTPvz8hWmpK0Af5mRPjeVXQzu7sJB5MyUzia66hfYWukFitzs1wqkT95pNk+uCIx0uewfXl4WWc616ZFNBliqljw6RE42nTBYJIO9CAd2d12YI4xoGxgMD9Pa/WZpG875hqeSLhaI8LEdG5zgfG0rLdZXhw0shJX0PD4y4bS7POIq35s3J0SUgVwp7lxjO9rsFg56sXff7u/WAT0f6OXTviIiHgVghbcPV1TXBKwgkxoPh67jtz3hH5YVdmRQCXgCzfO0F3onvKGGfsCfdh9rl3nHSnwb7NvbS/ZYhHjvquHxSR/prW/cY9KWM+ABxjAOhRL2UTLXNpp50CLmws2BJb/R/Oiec/6zq7OCprrhQjSwJx31VNe1hK5Jm+f58Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB6077.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(7416014)(1800799024)(10067099003)(4143699003)(5023799004)(11063799006)(56012099006)(6133799003)(921020)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?n6RSvL3R6Zd0D94vtKR4NybkrWKBqR3kHaaaAJlQESZth+xaBT3i9notODwA?=
 =?us-ascii?Q?+8NRIXtRuUVhxzrmCwAIdc/4yf22yypzPPdO+MMJsq7P8/9zbDwrvrgq9zL6?=
 =?us-ascii?Q?7xHm1CVoaeZPhSvU2DwECXJEhCh35cDq9n5+9OPV0WfhDCU0qfJG32CrnyrK?=
 =?us-ascii?Q?zyU58VLemKCoG9lXrjGYjnPtCdDzNkzNqOM91xAGs1iy2jCip/30LTymeXdA?=
 =?us-ascii?Q?lFKZzfDkJ7BdIZc7ryeUPsb+L6nh6/Kl64GDqFvSTPkJQULHBByJyt2MciFY?=
 =?us-ascii?Q?GKRUxLYhBZfAyZHCaFa/F4cK9AJojI2XzzFTnNZztnzxjeT6SiAt1BYO6EaA?=
 =?us-ascii?Q?d11ir4O0P2XYZJtWSI61NKaWtXaWYdsXGB1L1voJTQsXwsrLLwLOpp/BNyin?=
 =?us-ascii?Q?5YbhkmP3vh6O6p9n+v+LIkcTS3QXyIAmS17t4aIv3CSKupp+1wZFK3GAymrT?=
 =?us-ascii?Q?r6cMBrz6WkbNyM/AHd4xzGdQUrAusMWYT2DBEZsPKrqsYzU8P1p4hdR7mqFB?=
 =?us-ascii?Q?4Q56VLVZcofvyRbHUOs8EHxzRTOyzHHUpb1FjX0taBSqqi8JxEqblLSPdyv/?=
 =?us-ascii?Q?5NTnchkisq2C5va1KhqyGvNbXvNVchoxUPAtZmTcnoXk6ZVfTvFgg+oKLRjQ?=
 =?us-ascii?Q?I5eT3H1rUJurEfhTwq7JY80kGjyHnP6/pV2pQ9fEKqLQZ0zk/qaAcbhse0L6?=
 =?us-ascii?Q?qcnCOWaNfdDxBi/8AQU3do9mxcTlwLH5tt4EuERYADi00l7HlefkywgpVegd?=
 =?us-ascii?Q?8GuiMAql/s5u483dHpkdPE90ECmR9johNE9xm+BubdPcXtp7ZZsFhB5QWbJ/?=
 =?us-ascii?Q?XvEDxcRjOoQtca2ahF10glCggPMtSbj6WLW4Spg/685EYCvZc2Dq4Zlj6UPK?=
 =?us-ascii?Q?huhu9nAU4eKoRqnmMZZqOZsyK4Kiieuttv20O56nnS9NZYzkmdkmr6uuE4ug?=
 =?us-ascii?Q?CG1YPTHHGpWE1U6QI7XYNgufuGE950wT5GzcYEbqznI/ew7434L3eEC65jte?=
 =?us-ascii?Q?s7a4kR9iEhcdjeJJnTpSr6cBNAV0FOGzdVrW2ayFmJizKSYHyPTMMysGG5iw?=
 =?us-ascii?Q?gkt42MDhgVfymK4mDQCQrgqgRuZ6VZFcub99RGeb6FTn8h1E+jE5V6dLoxUF?=
 =?us-ascii?Q?HgbrOuJqYchJdEepCKrF1RZZSDjOI2b7gDM+1f9hW4MhefdGDw92jhNOpx/P?=
 =?us-ascii?Q?QXLjV0WpcOgLD0Tqxc8nwkXURIU97B8fVTnCC+XpTb5cOFWrBwRja6pWfUzJ?=
 =?us-ascii?Q?sxbkpuO4ODW2Qwe/41sua+fgGbv9PwoXMxDpjr+6ZT6KFgcD0QqD8aKqlLf/?=
 =?us-ascii?Q?77EIGrPzPC10rvP0dUYHfXdZEsFvAN3KTsVeChIq0czCAUTp0zq0MQMYkPak?=
 =?us-ascii?Q?xthAkxd/DgJqLoYS0gwvZ1VHVGpJRHYX1EUWBMdm3Ad11ZB4hfHQ/JAJsYsK?=
 =?us-ascii?Q?8LuNoajD/1QpuLBF+jjikVkG6zWB8t40GnVGb+VwhU0if1dWmQgHeiMjd1ii?=
 =?us-ascii?Q?aRpPTvky8yJY86MKuYHCWaeIow6ces8DOLs+0zpXunGD5vLeUhrH2P0dMrsY?=
 =?us-ascii?Q?+3TytAHA7yzaH864A+YN0BvbKCfszKfbPcxvuigFuPzQEUEtmkAr/ssg7Q0U?=
 =?us-ascii?Q?jr9mB5Qx5ieUhi001unLvhwHyWezZ4Gt+392/k3bt8Rw5YhpX78NWds8qEY8?=
 =?us-ascii?Q?EIqoFCszxp+2UTm+qvJC+doBdtNdGfO5HcnNzXSoUOWNmuD85HyR9hftdzDY?=
 =?us-ascii?Q?pvJWpUB3mw=3D=3D?=
X-Exchange-RoutingPolicyChecked: p1BsB0mWk9z3Bb+8MOdFTZtYf9ab7RyGF4SesVNcnIYvBgfp9bZMOgGtvvHGYa4EYZAnvXhauXZXakX1WClKk9BMVgw7zHohsdTUYaHjvUdnH5ijSAJSy3b657q/pmQICTRaQoXCwG9FuGrpd46o9D6Kf1S27Ejlqz+hfo+BQN1uJ28y4X0djV6DmDIfLMCpIkYJgEbBKPBdxGttnpE0zCOf5UoRcyKsE0jLNI6Rq020tjPXNPyaYlDeKX5o95U03J5qqFGgCvJnLwWFwD/jmGp1j8zDoWtK3tkg3XvHR5Ys42GMcY7Xrs7Z8iZ0kk9Xzt9Les/ndVtXRkBQLaHAeQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cb5a426-1103-4369-8205-08df1501dc42
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB6077.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 21:23:04.7531
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iDm47FgfH+42j5JpTT8ZQdrRvoOvD4czQj6DHbKP7dvEEg9Dgtwf16/b4ufQrbEZANUorAccJVpGx2iJCpvBpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB8892
X-OriginatorOrg: intel.com

On Thu, Sep 17, 2026 at 09:32:58AM -0700, Luck, Tony wrote:
>     Does dropping ep_lock here create a race condition?
>     While ep_lock is dropped, stale endpoints still remain in the global
>     telem_array list. A concurrent resctrl mount could invoke
>     intel_pmt_get_regions_by_feature(), acquire the lock, and cache pointers to
>     the MMIO resources of the devices currently being removed.
>     When pmt_telem_remove() resumes and re-acquires the lock, it unmaps those
>     regions. Won't the concurrent reader be left with validly cached but unmapped
>     memory pointers, leading to a kernel panic when dereferenced by AET?
> 
> This is an existing issue in the pmt_telemetry driver. Scenario is a
> race between a resctrl mount and an unbind of a device. The unbind gets
> to pmt_telem_remove() but loses the race to acquire ep_lock to the mount
> code calling intel_pmt_get_regions_by_feature(). All devices report
> valid MMIO addresses and ep_lock is released then pmt_telem_remove()
> invalidates the MMIO mappings for the device being unbound/removed.
> 
> Perhaps the telemetry driver should prevent removal of devices for the
> interval from intel_pmt_get_regions_by_feature() to intel_pmt_put_feature_group()?
> 
> Can it do that?

It looks like I can avoid making this worse if I add a new log "aet_mmio"lock"
and use that to protect against invalidation of the MMIO virtual
pointers. Then I don't need to drop and reacquire ep_lock.

-Tony
