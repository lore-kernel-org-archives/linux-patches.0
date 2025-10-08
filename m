Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03B951C27
	for <patches@lists.linux.dev>; Wed,  8 Oct 2025 21:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759958162; cv=fail; b=KqxaXVgyG4EStE8hS9iJ1RUX9NQ0z6/jK4PiH6r/M/6JUwcWSpYJF+OQov9GuZ5RfhEsYxO+OdPU9CDkOnd+8WtMbis6nB2FGliaF4y9KMRBDYgHfzKdFhmbti0UIU7IzJY3SyaycBCbBhXupHqHRuxK5MByR4lWpZMltJRfaRA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759958162; c=relaxed/simple;
	bh=AHXkbfH7MMq6bHiJORDsw6xiNpNUngMFPTigwtQLn3A=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=dkORz6vYoOwO8zHRVPTdcziLomVDglQJhRSqw5rUAc/mGVPUTAby9rOyqTaiBKrUaCkUSMrk7pQTAYssHqFptPZvUS78AbX0z/O84ybyIk8HW7F/fnxQOqCnzpoQBr1zdpbWqz0FXCScButvAfkEQnS0FAXCWC/QxCEHTkIpZho=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XEmAtN/e; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XEmAtN/e"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759958161; x=1791494161;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=AHXkbfH7MMq6bHiJORDsw6xiNpNUngMFPTigwtQLn3A=;
  b=XEmAtN/eW3ExfP9HO1Zp63kg9OzalBvc4kQYbztM9PCG1exBSEoxfHte
   wSxBf3/eCCGA42peVrf2WhfmUJwTCGnRV7hkOSTk/B2guKQM6U4Ftv2kB
   zICjz7i2aIjilVxm09qMlWrsXW/cfCZK04W5BXU7fiHnopVfgXfACEj0e
   5jEysBGaMRpUoRZT6EYtvcTKdP/PpYXiNDVdXHBdtMZ11ybGrxT8Fj6ZF
   FwkqMZHL+UAU+0e3K12vS4DAm1C7t/K26FwqH0LJdFD+LRoc4yTCIIUVb
   JzW88kiUmqGVvOvqnmBVTN+rvYTa21Q8Kg10PavkzeuRVLeoi8NY8gLli
   w==;
X-CSE-ConnectionGUID: MtC+5ljdSbWp6vXmd0Q40w==
X-CSE-MsgGUID: aYC1djuVQoyvi8GqJjb9Cw==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="62082083"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="62082083"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2025 14:15:28 -0700
X-CSE-ConnectionGUID: b/pGIoLVSsOLzuGjvak5Wg==
X-CSE-MsgGUID: GhP7IOidTH6PMYIHk59f4Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,214,1754982000"; 
   d="scan'208";a="181300482"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2025 14:15:27 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 8 Oct 2025 14:15:26 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 8 Oct 2025 14:15:26 -0700
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.5) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 8 Oct 2025 14:15:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OSe1xpBE65ZD+Rj0qi323/J70dCnzpKZ4j9PELTV9fsUwNvwSxyXi3qYsGLZU+FYSlNxEhYY6cf/R5VeTTIUcijH4TB0TwX3E6WL7hD2HrueFXX3GUsJm1zyqS5czWnXrPUn9CEyLwKyo4jBqI1xFAIezIS2lk1tXdIVa5eTyAkbxCgTw1sbMnakrcg8SmxqyP/Jix92OpltA6GYyM8+ZK5bzMtKmcUOMu+dTzKb4UGqMLthiTRzbJd7EQrdxDuToa3IwrO+3kp2mP2v6BaTvU4a9kBbLcMsJGVBfEUlE9zZC9Hk6JZaDAIS0vfV286QvePCmjweFi7BzZImoyQ8mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DP4fOxnGUwOvtwyzQeoDD7mJ9SRAl5Th9JHFSrwFPOM=;
 b=g3e/TwvBCqfRW74KLCrgbV5DM2mW4ioGWC+KrIcPshwy3bL3102tEjZitiJDfqoS5iD4XxTsUaC8pvVWPdGSrScL7ggubpizmO31RmHKg5TWL7Xa9leV8pl5koDvqDLD47jeb8TPpzBJgCPi7Yec8Eg89PS3DmcneVZNNe5mF153Fa5gfzwg/i9YNQzF8GdZerlELhDC7JfT+/DhmBn+j95dOoagjTswk5sET4dWwNZDTd3Zuu0FqRLev5LL7NkGy8qlOMd9gYE3oOY6Xb2Hy59C1rMSWHPKt5Onk1BN8evmfLx7E+UavyaVmYeJIPkHRrqS2NWs/vriVvJmkY7UrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB6077.namprd11.prod.outlook.com (2603:10b6:8:87::16) by
 DS4PPF691668CDD.namprd11.prod.outlook.com (2603:10b6:f:fc02::2a) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Wed, 8 Oct
 2025 21:15:20 +0000
Received: from DS7PR11MB6077.namprd11.prod.outlook.com
 ([fe80::5502:19f9:650b:99d1]) by DS7PR11MB6077.namprd11.prod.outlook.com
 ([fe80::5502:19f9:650b:99d1%5]) with mapi id 15.20.9182.017; Wed, 8 Oct 2025
 21:15:19 +0000
Date: Wed, 8 Oct 2025 14:15:17 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v11 20/31] fs/resctrl: Refactor Sub-NUMA Cluster (SNC) in
 mkdir/rmdir code flow
Message-ID: <aObUZU8rnWIDR_tH@agluck-desk3>
References: <20250925200328.64155-1-tony.luck@intel.com>
 <20250925200328.64155-21-tony.luck@intel.com>
 <fbd49f1a-ddb2-45e2-b943-df43d2173503@intel.com>
 <aORMZ6NUXMpECHU6@agluck-desk3>
 <ed1a10d2-2f13-43aa-93f8-7dfe8864cf47@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ed1a10d2-2f13-43aa-93f8-7dfe8864cf47@intel.com>
X-ClientProxiedBy: BYAPR08CA0062.namprd08.prod.outlook.com
 (2603:10b6:a03:117::39) To DS7PR11MB6077.namprd11.prod.outlook.com
 (2603:10b6:8:87::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB6077:EE_|DS4PPF691668CDD:EE_
X-MS-Office365-Filtering-Correlation-Id: 707a8d52-f3ed-41c2-8527-08de06afc91a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?LautfkmHZovCO8vt3hY0WkXOMQmYsPeTzFnwYhVj70KyG9BG6ZDz5ykbwxIf?=
 =?us-ascii?Q?K2GnJuZCDE+p4swz17lPfc2c3WgjopRKWXRO/YCtmVfr3KA2y8/niP/8aRqz?=
 =?us-ascii?Q?uhKeZzivjEhj9fvFsK9cRDZ0L/ZpPA0OzAtSGGkrP9aK9lb+4v6cQEFkejPP?=
 =?us-ascii?Q?EenZdjfOlqrMTrwXkWWrQ2seIUjgyDCOxBjvT4y1ZKxXHsitFeyjsWV042cY?=
 =?us-ascii?Q?a457qxldH6sMV+vdOJfO3tEoM0JxK1qXw7RHFrWB7xGj2X7vMgUKKxOIgDKw?=
 =?us-ascii?Q?uIWYKbsT1TCUInbauGf4Ve2hCZw8JtKGijbCiNiA9U72lwMj7pbdz7OsRMHe?=
 =?us-ascii?Q?M+HPh3+sVxaMvIAAQMdMOUl+eEwnhLbOQ5Hqtdd3Ibwv2Lwxui7dgwRCHrtr?=
 =?us-ascii?Q?fmUPVFspdlEpX4wM4EJ3ERcYN/XM/2Gw7MRHqudtk5PK15BiiOPg32V3Rmvn?=
 =?us-ascii?Q?HasIEmlQC9mWt/A8h2k2pjK6C5KKgIBfrRg/2dRyC66A3T44FfysuesdZ/7J?=
 =?us-ascii?Q?ejCCfWnKSe3VToHoHIqFZxw3yxHpglE+Ke4NBlFoBNt9EiEtWTF+j7qrwSDe?=
 =?us-ascii?Q?lptJJJ4CsAfxo6oE4Vokov7cKxm6eM5M1gGbDXJdse7pC/3xGo9Bt/vnC5wp?=
 =?us-ascii?Q?WNNI+bgW338BzN2L2PZ4xS4QN3rJnKWTw1P/EWKMNexQpegW4gA+xzBvEM0C?=
 =?us-ascii?Q?k6YJLPLPL0/g297jjUyvfFK7ZzSBT9Fhpt2vVOXnmLKQB7wjxI/mfNpl+TGd?=
 =?us-ascii?Q?Ef77ppr5O2rMGrWEGys5LAZGKiGJTt4DttwY/aO/s+C+xx48JA0zVSMe9C3d?=
 =?us-ascii?Q?XWQA08hR+68JRS7CLwP3+m1ilWYShC0CaxzuNz1rjm0O+KsVRtj7ED7UQxlZ?=
 =?us-ascii?Q?2KAl0Ms5Sv53JvPKhpODXHy7BGrxpjGK3I7zV8k54tlFNCwuY0UKZtuuvYWO?=
 =?us-ascii?Q?awRk5St696QyrIAqy566i8dPYNXrA5/eiyO6Mi/hMLjEfqJUS4VGs/o7aPsu?=
 =?us-ascii?Q?+ZzPyrhBhBDFGH8lmqzICDOro0GG6xMCCCGJ2dRlSzVclbqiQMwyQqTEZ1Sr?=
 =?us-ascii?Q?2zDfNsKlKV6fmmrHg82O4BFnxxl5XI25Ei0q3a/W/2IbaxCCrehQSF8fFYcn?=
 =?us-ascii?Q?u8VChM/b65lnJa4zyEQVYnX1gTujAAVHCe5Kg6kyiRU2y0YtntxQBQOLuBC4?=
 =?us-ascii?Q?7qJiqJpZnlAssem4/YzFJR0BieOz85HEV0AyHJEkPKDRYn18ZhxnCxbL1+Ip?=
 =?us-ascii?Q?0BifqbC2e6U5YkWgV8MamUfTrpb47nHsixvTwrkk7g50EFI/OZ8RhcAKjzFl?=
 =?us-ascii?Q?LK2rKXOaW2g3zAj/8Etg8liijQc4HhwxrZEcZ0IJ3r3OcXBjpXYS4I1rYlkK?=
 =?us-ascii?Q?PbSO3iA73NK3rHiPc5K5SEiHnWBiAY8kMDphcX8W6TsobD0mgMuqoyXLJS6N?=
 =?us-ascii?Q?hbuGNQhB14Yb9gy6pjdGpzGox8dolJGs?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB6077.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ic54BHNv7v1Omb6HFtmsIwMdjhsqC2g7VKwmifsuOpO+rfFhzUodErHj/4NN?=
 =?us-ascii?Q?6TodWCXaI+Wh4uhIsCL3JNVpF0083a8LbNPaqBn0YsNHMEDtLA24G5ng+XW2?=
 =?us-ascii?Q?OPOCEtHlmgglGLVmszYhsV6b/cyC4V3A/wrfm2nbemUbq/FrfYbXYQQ7tNM7?=
 =?us-ascii?Q?ni1F5zIcf8KPrbyVpW6S1A7+RPi1MsL2KyHVvEKVeYtoR9yXvGccfFBBHKRb?=
 =?us-ascii?Q?/zvYvpJ7BU9r1LruKyuYpfX5EsDUctAJOfTZ7SCHNAgOPQAdUMGOa7AwMbUX?=
 =?us-ascii?Q?GeSQEeEJDBtBLPSd00jh7oZmrqyzYyF4mCI6jPErWYSoAuRdNe/E2Pd3TFV8?=
 =?us-ascii?Q?VLRyQlOoE72wDhqoz6rFy6gwyu1M2ow+Jqh8JUwBS4awsl9husGZqiqrymSc?=
 =?us-ascii?Q?Tf/BLujh91Swb3G8PbsDoXwHBfMp6fKdGhZWUnPICXYlsBHbnDWZxXy3kXDS?=
 =?us-ascii?Q?r9U/Q9pzd8Q7bKe4drGWB33brVSnZ4TQvJQPn1iIwvqEJHeMX7hBeloATNdv?=
 =?us-ascii?Q?JBEXUpedGWcoDdNzqrijWsJ0P7ZpIRaMaSLHvjNgceaXMHEI5JgYU5DLBf5U?=
 =?us-ascii?Q?a7NS4MirwRRYNJWgpsjezaUSosRjgS/StS6BHG5Qh73xHzqDSzn2yJW8eFjv?=
 =?us-ascii?Q?0vs/SZ8Cnqus/RBZ4+EbtXPZWPN/qBdBCrBdjVIzK4umxoQX+GYWzu6toQWO?=
 =?us-ascii?Q?uLeTSNM/kXIyhTult+Z8yJq+t6iWwXNKSAdUyjayrqfnwYSiYG3e6yIWR2l2?=
 =?us-ascii?Q?HX+dCSuREavYCiVLlJnC/brJKet934t2X1gkH0teM9u2v7uM/cLfndC+JOgm?=
 =?us-ascii?Q?Wym12Kpf+sa84LyvrO2w0eRkVYDlHw8+IMWNPaPoaqamN0n044m8vlIGpAd3?=
 =?us-ascii?Q?PZVuRWYLzJdLU1r8NONpNLvYcfLTDcV6jDIfzK0pn/AxT3Zd/74f2IzXy1Mx?=
 =?us-ascii?Q?VMVp3s25aSpVN50td3pqeg5opQD45prAx2QOQNAb1P1rzJIuVodZtvoGxP3v?=
 =?us-ascii?Q?hl8JyPXqNrONRqTn6dXTZOpNHvFb7JY0s2/ioxw8EhaL0GxwFz9dyn3UDg3n?=
 =?us-ascii?Q?bVFsRPDiHXUb6cSvuNpSIRM2+2UCvnraLq0r/HAIrPFvJeOzq9IGni9n/MkQ?=
 =?us-ascii?Q?TKH55B49c5sfieFFFEkPi8+H1YYonEbv8TuBBvVarj91vj80M0GsE6wnsGeB?=
 =?us-ascii?Q?yNMmNkW/2DaGl+kjQyef+B9fu6k5uwXiE4ATi8KAjfvMRPdP3IArJLsTBGPc?=
 =?us-ascii?Q?Goh9D+W23+y+rX3QZdw6yd1DkEuygrUseo1y5oAOnjexEV8icLfPfJf1Fx47?=
 =?us-ascii?Q?vN+aKOrd7wxl3m0IsODnYJm+QjA8bzMU4uBaVX3klUDoSg1i68OtN9RFY2yb?=
 =?us-ascii?Q?zBFyXwPEv5zMTEak48ksdp+uDjx8FmTlZKldazn8afQovVTUdo2XqSD1A4du?=
 =?us-ascii?Q?ItXHwevMjkyrV0g0qc8jXphCZTHt5HcMeou0O5ngiL113Dj5RYwEgPaLW+9m?=
 =?us-ascii?Q?G2t6Kq+RVUfHUTVqHSnbG87B/HWu0RJ+50GpglZOluSStVfIQO1ePLEZpyfg?=
 =?us-ascii?Q?SZK4wjZ/1X/Bx6si2CNj9ci6C84PZPOnRNVASsqE?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 707a8d52-f3ed-41c2-8527-08de06afc91a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB6077.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2025 21:15:19.7347
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MvophAbKMLoe4FebtMI2siwb2CVGEG49phDCcO53MT+Y+lcE9f1m9w0dULfc1xWy+VyIs2Hl8WRQ8N8ux+Qd1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF691668CDD
X-OriginatorOrg: intel.com

On Wed, Oct 08, 2025 at 10:12:36AM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 10/6/25 4:10 PM, Luck, Tony wrote:
> > On Fri, Oct 03, 2025 at 04:58:45PM -0700, Reinette Chatre wrote:
> >> On 9/25/25 1:03 PM, Tony Luck wrote:
> 
> >>> @@ -3253,7 +3267,7 @@ static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
> >>>  		ret = rdtgroup_kn_set_ugid(kn);
> >>>  		if (ret)
> >>>  			goto out_destroy;
> >>> -		ret = mon_add_all_files(kn, hdr, r, prgrp, hdr->id, snc_mode);
> >>> +		ret = mon_add_all_files(kn, hdr, r, prgrp, domid, snc_mode);
> >>>  		if (ret)
> >>>  			goto out_destroy;
> >>>  	}
> >>
> >> mkdir_mondata_subdir(), similar to __mon_event_count(), is now unreasonably
> >> complicated. Just like in that earlier change this inconsistently adds 
> >> RDT_RESOURCE_L3 checks, not to separate L3 code but instead to benefit PERF_PKG
> >> enabling to reach the handful of lines needed by it. 
> >> Here too I think the best way forward is to split mkdir_mondata_subdir().
> >>
> >> rmdir_mondata_subdir_allrdtgrp() may also do with a split ... most of the
> >> code within it is dedicated to SNC and mon_rmdir_one_subdir() only exists
> >> because of SNC ... any other usage can just call kernfs_remove_by_name(), no?
> >>
> >> SNC is already complicated enabling and I think that PERF_PKG trying to wedge
> >> itself into that is just too confusing. I expect separating this should simplify
> >> this a lot.
> > 
> > Ok. Splitting these makes sense. I'm terrible at naming. So I
> > tentatively have:
> > 
> > static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
> > 				struct rdt_domain_hdr *hdr,
> > 				struct rdt_resource *r, struct rdtgroup *prgrp)
> > {
> > 	lockdep_assert_held(&rdtgroup_mutex);
> > 
> > 	if (r->mon_scope == RESCTRL_L3_NODE)
> > 		return mkdir_mondata_subdir_snc(parent_kn, hdr, r, prgrp);
> > 	else
> > 		return mkdir_mondata_subdir_normal(parent_kn, hdr, r, prgrp);
> > }
> > 
> > and:
> > 
> > static void rmdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
> > 					   struct rdt_domain_hdr *hdr)
> > {
> > 	if (r->mon_scope == RESCTRL_L3_NODE)
> > 		rmdir_mondata_subdir_allrdtgrp_snc(r, hdr);
> > 	else
> > 		rmdir_mondata_subdir_allrdtgrp_normal(r, hdr);
> > }
> > 
> > Better suggestions gratefully accepted.
> 
> It is not quite obvious to me how it all will turn out from here with the
> addition of support for PERF_PKG. By just considering the above I think
> that it helps to match the naming pattern with partners,
> for example rmdir_mondata_subdir_allrdtgrp() as you have that matches
> mkdir_mondata_subdir_allrdtgrp() that is not listed here. The problem is
> that the new rmdir_mondata_subdir_allrdtgrp() is L3 specific while 
> mkdir_mondata_subdir_allrdtgrp() remains generic. I thus think that it may make
> the code easier to follow if the L3 specific functions have _l3_ in the
> name as you established in patch #8. So perhaps above should be
> rmdir_l3_mondata_subdir_allrdtgrp() instead and then there may be a new
> rmdir_mondata_subdir_allrdtgrp() that will be the new generic function
> that calls the resource specific ones?
> 
> This could be extended to the new mkdir_mondata_subdir() above where
> it is named mkdir_l3_mondata_subdir() called by generic mkdir_mondata_subdir()?

Reinette

Making and removing the mon_data directories is the same for non-SNC L3
and PERF_PKG. The only "l3" connection is that SNC only occurs on L3.

So maybe my refactor should look like:


static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
				struct rdt_domain_hdr *hdr,
				struct rdt_resource *r, struct rdtgroup *prgrp)
{
	lockdep_assert_held(&rdtgroup_mutex);

	if (r->mon_scope == RESCTRL_L3_NODE)
		return mkdir_mondata_subdir_snc(parent_kn, hdr, r, prgrp);

	... pruned version of original code without SNC bits ...
}

and:

static void rmdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
					   struct rdt_domain_hdr *hdr)
{
	if (r->mon_scope == RESCTRL_L3_NODE) {
		rmdir_mondata_subdir_allrdtgrp_snc(r, hdr);
		return;
	}

	... pruned version of original code without SNC bits ...
}

-Tony
