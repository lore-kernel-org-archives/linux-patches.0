Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0902058B6C9
	for <patches@lists.linux.dev>; Thu, 17 Sep 2026 16:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789662791; cv=fail; b=h/5iIXmlBeXTg0TnKZeXhEF+mV/3yz2gf4ddWKHW+JjmgQgeEXxAmur6TNt3Yrkeh9fCXnHtybhmbeaZXQxXeIUF7O9Tz34kR7h5KIW157Imp6oRsHvgp+BH7zlcAwqSU2y1acIey/9nfirZOhoGBqXB/lBmMCUTrvXskE4oAu0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789662791; c=relaxed/simple;
	bh=+nT3obyDLnDKDCzXa6OYhTyc8mlGwdt5j6qouUbSjBY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ub1MeTFMW4wFW4pGd5sIdbTx8j8HoAyz51QsAnnASMKl8T0OsHogS8QkLjbNGjhYb6/nDpEWdaIf/3PZAklBszSRPPiGLlW/QDVhKiF9fqYQH95c9W6e7Xnb1i0+DWw9l7EfvDSNdoVCcws3ya23SfaOwabl1NGRbN5pkfDPSbA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LPlyY4m5; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LPlyY4m5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789662789; x=1821198789;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=+nT3obyDLnDKDCzXa6OYhTyc8mlGwdt5j6qouUbSjBY=;
  b=LPlyY4m5k3DjLP+ciPkkKLT9yLK0gVTafHSnvbw8wAXXcVlHk/FM/Ai1
   gZ/tX8PSJQKAtk901aUoR0f26x7qQlAPaFQDr40OSvFBc95YEb5ylpqKg
   btBsKfZeUKhaex9pz0wDsKqi5flgfki7mTJK+iw1q/LhWicddnrNkBeUF
   Ok/sxzEqJmh3DtHPzaVmBH25OPZGegmteEw/URws+T6o02f8Qnh/0BpLo
   JqeMKxRCaLE0vqlar85KnXpl8uh65psuTHi+ObepUCmb61qSBXyNCPC0+
   l25pbu0dIqMTgB5RQozxlJknCkP66GgEBdNsmDF+X3rdJvcmjuSVFb8Bl
   w==;
X-CSE-ConnectionGUID: 1NIH7IfUQAuoorJ4f+S8Tw==
X-CSE-MsgGUID: ZNALvo4RQiSC9xf86+AP6Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="100768776"
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="100768776"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2026 09:33:08 -0700
X-CSE-ConnectionGUID: Ob8QDlrXRqqnXbEqAQJY2w==
X-CSE-MsgGUID: IiARn8JgTHWPaRHd5Okipg==
X-ExtLoop1: 1
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2026 09:33:08 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 17 Sep 2026 09:33:07 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Thu, 17 Sep 2026 09:33:07 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.42) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 17 Sep 2026 09:33:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xMrCj1Sf/spLEh4Z9Ev3EAlnHdIRVAVeKcYCw4UOe+ONUW93Nk+MPpWkIQb/H4SIT6e9V9VH+mr/0+cJK4M0kcZ7qTzKFSnhJq7piKJi6s2yJBW9dhKl6s50SgVafhnMkPGozIoYddSGjf39b+IjB/Cf9FZL4+/j323uPnPNAADFK6BBgrs8QAtNafvds35spl40N7JjWjZs1pY62OaCDOy8VNrhVTkkVyAuVV8ezjO4OpKU1ASrEDdaunJ1kSlWv3PS8iHg59za/SzDAkSYB+qdY44YeVOWvDlLdZBpyC0hwyROY/kdtLZGnlpCk1/wr4tZKZ4p1QiFkFn5z7NX8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=etajpxKFCG5mlcA9llJpyak0RaW5t9DZFNN8Jo+EIaA=;
 b=i2vfyzsgBBo3X6a5jqkDi4jRemc7KWjEYDx+pwlLuSvl3AzoB44ImveCaUc8yvPga777ozHQhVnx5PjW1gmHs2UnmP/73Qyae++DE74KKicRloQEEsf6PPxq0Oh7hq7SkrlwxaF9x0ZBstDKd6aCn3ZoBrVsn+JDWCohql+JBV4Jt76EDz6uA9+9J6jM1aYsRIcp0h/O2WENNziKdbXOkGW8g39rEgMB7c90iuYSobHMdLCvkXwxkjswAZ+dlenY9LCCv/kCI6npliSTTNm4CIPeLpiITCXGbByf3+MofJi0zPj5F1g8wnxexsRR99ZRnh+8p/rN5bUmBW+N+jKDaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by MW4PR11MB5892.namprd11.prod.outlook.com (2603:10b6:303:16a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.12; Thu, 17 Sep
 2026 16:33:02 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%4]) with mapi id 15.21.0406.007; Thu, 17 Sep 2026
 16:33:00 +0000
Date: Thu, 17 Sep 2026 09:32:58 -0700
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
Message-ID: <aqwWOs0WdAyssc96@agluck-desk3>
References: <20260916231320.14502-1-tony.luck@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260916231320.14502-1-tony.luck@intel.com>
X-ClientProxiedBy: BY1P220CA0022.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:5c3::14) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|MW4PR11MB5892:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a134b57-802a-4ea4-c0ab-08df14d95639
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|23010399003|7416014|1800799024|366016|6133799003|22082099003|18002099003|921020|5023799004|11063799006|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info: gqZE0P/+0eAIKN8XyOkDT2mC44kPMjiWif3FY58NNE9VY4m+k2LTe06i6TOlv8DYTmzQyWOtXeBDOdETcknYfrs6G73tUTX8ulJjjCf4MuLFBWXIHKLvp7CU5gwiFHUUlfyZ//8/2Jqv7ZfwUIxgfFxaM6k4O5IZ91DJMs6etPuFCkVymxKw3KN54vjMXluO7PTbxcGntj1LcsJYQimtjpPr9jSWh9AOmymEwdWYZLiVSHkGRRH6tMvkPQDJ4SiNBf9G8DBcuFyDbtGcHE6PT7BWh9///aX9mOrojNiH/qNQ/gV1eMYFdX5nfEOOeUdHDGVasxdXO6Pi8P0raDiPQdPWq9S+pmx41pW3oSsWvD1w+xfw5ZefO1uuKbKY8lV/YOOdA0T8ky6Nzb0SZUhMWLHLWgYXhGG+qWpMTPvuehy4Bmhpm9FoZ2wT9W3h4ui2LC9KSM1+epiGtFkmGFTx7FB+AtNOGY75hp3LFiUmtecueIc1DlailtEw6+p7J7J03JYQObW4C5zHyrcm5Xqr8D2pDJq3L2BOoBm7DboysuISg+Bc7zRrnFi9e+DLwEDVxfMYbnABCoeCAGNUKJK2lNOKHq/x8ORFBonXJrAzEa5XDIlQj1/DKECoX6K+S8kfQUAd0QtURHvLsYKCbW7xSQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(1800799024)(366016)(6133799003)(22082099003)(18002099003)(921020)(5023799004)(11063799006)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3od8NkiICQ0L3128Y39TiB1TSJvPfTPASkzWgnNN32xd0+ZqY1cJT80on2jT?=
 =?us-ascii?Q?8sD+urIfCkYUwiLP+s3kZpWgXE2RVNRNaHEcOlfuzjVpbcvCqwgUvi3bk+V9?=
 =?us-ascii?Q?qjOLtKtEHX5oLs1TlWjeVsx5sRlJ2uNM5Fq9+4dAS6uBtp3DkjJq4vWg38tX?=
 =?us-ascii?Q?Mr3hKEssDBhwvhDJpYqMDEc2riw1BNDO5f4xXFIQ4Q37ALPLPwxbxpTFkjFz?=
 =?us-ascii?Q?0Yj0OFWYHRPc/BUz+Mfw6aEqaIL9KPmNtMttcKessX90gO0j1PVt3FbDl43d?=
 =?us-ascii?Q?dBueMKS4FRf2CHO/reJ2FUAehPJTlnn5wIHzbkZD9gdXm0deBypTYY2Poweo?=
 =?us-ascii?Q?TYUr5ZutOKE7Zy1e0cItKiDCrhgJRrV1FK4MiWnzUUpc+PM3qvSQg17x0rid?=
 =?us-ascii?Q?ruJNemUloNFgk5A/RapldS7SbPApSLmfsPL39C5Oodo+jU/2Kk2P75B7yiwg?=
 =?us-ascii?Q?tdZ98aheOfYJ3SoQmw/I39qMHssMvp8sIRIxNz/j+FCYJwyw4ORvZG5t0Vsj?=
 =?us-ascii?Q?Np9Cu92iZ+RHBf7lbAYgY6tvaQVdfDVgscr9z4d7ZK3jemi5WwF6xeo+4EX1?=
 =?us-ascii?Q?v5VqBlnlungiPzF4QK4fgPMrJC1+M9xZh1Y5mZZmtRmmXgIuyZRcBQ6KIWw2?=
 =?us-ascii?Q?gNLhxNSrzbfhPX3WXNsvt0MtwWhZab8zLVINCtBmB7jcDH70+QbV/NSH4G4E?=
 =?us-ascii?Q?EC1s+fofYGdjpxmbU/bYT0n41vogZVTlwIE/9EleX028StKp9eiYN7+9IY7g?=
 =?us-ascii?Q?O5uVvxmUY5gqyxz3MwVtzxf6oiOe3WCnnvCPJSRoOIfsHxcRnHkBB72vx3C/?=
 =?us-ascii?Q?Yy2mUf3LgEY4Cwu00BWvxg1EZzHLMZSoA1Ni48suAi9TdJfK5BJvnC/7K5iv?=
 =?us-ascii?Q?UbBh2qpGWGeGMXNwMoR2e3t+j+uM+dxNHvbJFESPJLxUrMiDkhcJTqr2Vc2k?=
 =?us-ascii?Q?WnKd4g/FkODorDrbX1hWw+sLL+797O7HCSRCC6GLWeb9pB+xFc4+K7Dw62/5?=
 =?us-ascii?Q?M/l3ke4BF+x6XXFEefrrKEHCtTkpsmNlKkFKvKiwd937Bb5AJ9sHjBdmgTUg?=
 =?us-ascii?Q?eky6mIPP9GnpgoN76r3w1zC4RP+RZDvuuSfXzAtmG872tWBM19NyG0se90ck?=
 =?us-ascii?Q?5sSLJj3cRexuAfBIaqchjbTcY1bIlLOyzMcBhZtA9fvbLlVBvmaYiXBuTQrj?=
 =?us-ascii?Q?QQXDXXooKqk4tE6TLYOovN643s9ap0rhXyc8klkaRmk3mdy3NR6AIS3doumv?=
 =?us-ascii?Q?OdoUrTag5VwvKVF6OAcV10He1a0389v0j0EScOUXFmQNXxtumLBQY47XMV/B?=
 =?us-ascii?Q?BnBq0DZK6H7rJDUWsi3K604d+OquK3PFag5n/QIwvTYbwiz4JLpj3UVBeBuK?=
 =?us-ascii?Q?xnf4uwXw5zKl/JVoEKdLgWP6x+ioUGeeqP9J/vjKenoQtgJ4T5mDL1Gdg2OR?=
 =?us-ascii?Q?MSvrttEDl1aiR0r60kueOUvfO+40sqmznEVBOShBbm4WY3feB2HSIHu14wyC?=
 =?us-ascii?Q?h8eHhwC9vZ8IYr8+H9Nh/5NsBX32ry3i7c09kNX5HRmv3XGuIPZLPVPuHVl3?=
 =?us-ascii?Q?e+HBtuxbaQvP4gWLV+T+p5InfcrQg6iDKsYaqu/jqBYCMMsEgHcmUlxCj4hY?=
 =?us-ascii?Q?dIjTmLmGTeUL3I1Wsocbq6ZwU93c/04zT4IAiBf4V8xJAsYvL99F4vNw/39q?=
 =?us-ascii?Q?AhYc31Ci/P974NvwbzOzwxe6T0IJuxPWMxgne+q70Ur7PYzlfevgf2FR0Jjo?=
 =?us-ascii?Q?KA7EXFlSTw=3D=3D?=
X-Exchange-RoutingPolicyChecked: OVt4bY5hAnFHJJo6ZVqQnByGvmQBctj4cpZT1XBPy63IwvOeOeT84rl10ihp8gON4ciwTRQtdSWgXi2pOTFK9NE7N/+TU6oQbdOTppf0X1v/9s/NGXpNGmjogM91dnkWgLMPt4y+WRrplCxr+1cgkz3cxF6/Any73+lpTK1gc2KL+TLKDB7xMs1xHCHHFzStef5OrU2FjDVUDoOPYxdRwJFsHAuQ69sEOBlVpj6+pDVdKZ8Dkcabup0cAd1h8jnoN7FKufXv9PXHR78LvXKNCNHfsSCnE/fsgtX/ZhtxTHHCLsTucZNMZwNG2OlFourrOPqX5+nsJ2Sb+IeaA+/gPA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a134b57-802a-4ea4-c0ab-08df14d95639
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 16:32:59.9329
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WIxSGKBJIhWW+pfJaVVp+Ud2zg6LIK/oYXXAHvoR2ffEDRBrkzMksK8WljHLJEhlDNLwBfIX27nONK8+yzm9tA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5892
X-OriginatorOrg: intel.com

On Wed, Sep 16, 2026 at 04:12:55PM -0700, Tony Luck wrote:
> Requiring INTEL_PMT_TELEMETRY=y to enable AET is a functional workaround
> to enable enumeration of Application Energy Telemetry (AET) events, but
> unacceptable to many users. It results in increased configuration complexity,
> increased kernel memory footprint and inability to patch problems by unloading
> a module and loading an updated version.
> 
> Add a registration function to the AET code that can be used by
> INTEL_PMT_TELEMETRY to provide the enumeration functions.
> 
> INTEL_PMT_TELEMETRY can be loaded/unloaded independently of
> resctrl file system mount/unmount. Perform enumeration on
> every mount and cleanup on every unmount.

Sashiko report here:
	https://sashiko.dev/#/patchset/20260916231320.14502-1-tony.luck%40intel.com

Only issues in parts 11, 20, 21

Patch 11: [PATCH v12 11/25] fs/resctrl: Add interface to disable a monitor event

    This isn't a bug, but the kerneldoc for resctrl_disable_mon_event() appears
    to contradict the core safety invariant described in the commit message.
    The commit message states the architecture is responsible for calling this
    interface "only while resctrl is unmounted", but this documentation says not
    to disable an event that may be accessed while "unmounted".
    Could this lead to confusion for callers reading the header file? Should this
    say "while the file system is mounted" instead?

The kerneldoc comment is the better description here (supplied by
Reinette in the review of the v11 version of this series).

  https://lore.kernel.org/all/f9f3cb40-bc98-449d-a801-6af836900e76@intel.com/

With the intent of reminding developers that resctrl code may not be
idle just because the file system is not mounted. The limbo timer code
will continue to run until LLC cache occupancy counters reduce to the
threshold value to stop tracking.

Commit message could be updated to match if we need a new series.


Patch 20: [PATCH v12 20/25] x86/resctrl: Enforce system RMID limit on AET

    Does this code successfully enforce the system RMID limit on systems with SNC
    enabled as stated in the commit message?
    When SNC is enabled, the true maximum usable RMID limit is scaled down and
    available via resctrl_arch_system_max_rmid_idx(). By capping AET's num_rmid
    against pqr_assoc_num_rmid (the unscaled physical limit), the resulting limit
    could remain incorrectly large, continuing to display an unachievable value to
    users in info/PERF_PKG_MON/num_rmids.

This code is doing what I intend. Making sure that the value reported in
info/PERF_PKG_MON/num_rmids shows how many RMIDs can be supported by AET.

Perhaps the commit message could better explain this intent.


Patch 21: [PATCH v12 21/25] x86/resctrl: Export interface to report telemetry unbind/remove

    Can this result in an invalid cast for non-PCI devices?
    The PMT subsystem allows non-PCI devices (such as ACPI platform devices from
    pwrm_telemetry.c) to register endpoints. Using to_pci_dev() blindly here
    without verifying dev_is_pci() generates a bogus pointer for non-PCI devices.
    ...
    When this bogus pointer is passed into intel_vsec_get_mapping() and
    eventually to pci_match_id(), will it cause out-of-bounds memory reads or
    KASAN panics when dereferencing pdev->vendor and pdev->device?

The AET endpoints are always PCIe (enumeration uses the VSEC feature).

    Does dropping ep_lock here create a race condition?
    While ep_lock is dropped, stale endpoints still remain in the global
    telem_array list. A concurrent resctrl mount could invoke
    intel_pmt_get_regions_by_feature(), acquire the lock, and cache pointers to
    the MMIO resources of the devices currently being removed.
    When pmt_telem_remove() resumes and re-acquires the lock, it unmaps those
    regions. Won't the concurrent reader be left with validly cached but unmapped
    memory pointers, leading to a kernel panic when dereferenced by AET?

This is an existing issue in the pmt_telemetry driver. Scenario is a
race between a resctrl mount and an unbind of a device. The unbind gets
to pmt_telem_remove() but loses the race to acquire ep_lock to the mount
code calling intel_pmt_get_regions_by_feature(). All devices report
valid MMIO addresses and ep_lock is released then pmt_telem_remove()
invalidates the MMIO mappings for the device being unbound/removed.

Perhaps the telemetry driver should prevent removal of devices for the
interval from intel_pmt_get_regions_by_feature() to intel_pmt_put_feature_group()?

Can it do that?

-Tony
