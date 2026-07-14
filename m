Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F08A24A33FD
	for <patches@lists.linux.dev>; Tue, 14 Jul 2026 16:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784044903; cv=fail; b=V7dVWoenyZirV7/xmRDhBuBhzOi64QpZC1MgUEaI7crNKT+JbtmqlSJE3qMkq52Oprhyd4ONmQLe9o3ms61Vdat06YNlvvV1itDL4FxnUoXNJH5iFu3Xdb/RToZNH4tphDb6pKmFAfmBwrpKufLr65I/Le76iLICq0VQ0PFY8n0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784044903; c=relaxed/simple;
	bh=I/KBmBwSIFx1wVWN4EYxMG52TAdN51TzAW/oIGHq0kQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=gwWjXGXXzu9o6zS3a6KYZ6ZGS90MVSyTqTWPSNWHd0Irx3+j593rvWvv1PebTIAb7Q7CaruylVc4Ib3+JrT1MKPjoAcIClF669FICj4Dr9DW1DlZJGL39FAiAR0l/m+rLSvEyFgpNipG4ZvH85umYRAfBAVw25UbVy3uy3AFFnM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YOAPAP2M; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YOAPAP2M"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784044901; x=1815580901;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=I/KBmBwSIFx1wVWN4EYxMG52TAdN51TzAW/oIGHq0kQ=;
  b=YOAPAP2MkknJGyUSf2+Fmp5KTlsqKYfL90ojPs2KQcxgg3vJVvW2aVny
   TwfZESwq/1NgXU8rkTZ5XTYh5ZaLolANk3LZ05gaHz1UrRC9brZGWxkf5
   cR66ETq/A4x4E2+EF5rvaUGO/SyVDpfCmrN/tEpH3BuiW5lKbgxXzjRZ4
   Xu9W2uZ+dkrZi3Gdas7//C25CcjXdpI5NK1LAcNTIynN0r707fp5p6N/A
   +tflqEwQIIY+6RqokN95cDr/jXgYyPB63U+APOqnOB8HUKLcRw2c6DF4F
   rXMgOTTr0YC7qAah/3pF8dRgzBMKUk8WaVdi5+lqPkKfXD2RWRJk+Z1px
   Q==;
X-CSE-ConnectionGUID: NEfj7VgpR1age/yhF7WB+A==
X-CSE-MsgGUID: TUxUK08rRry26e/oHFargQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11846"; a="95816554"
X-IronPort-AV: E=Sophos;i="6.25,164,1779174000"; 
   d="scan'208";a="95816554"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 09:01:41 -0700
X-CSE-ConnectionGUID: iUxI6K5eRlikTO2CznzBwg==
X-CSE-MsgGUID: EvChG0ZKTlSA2wxyxqQ5PQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,164,1779174000"; 
   d="scan'208";a="294103644"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 09:01:40 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 14 Jul 2026 09:01:40 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Tue, 14 Jul 2026 09:01:40 -0700
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.48) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 14 Jul 2026 09:01:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iH6741c08g6yD9XRKFkZryIGTz2tvhUjK1EnAfiwgkTBgf4gIfnKm9mGi3OYw90kwIsJH30YRtcW5MmgJ1YK8iDW+2bl3+8ejj6ynb2nlhvbmR7UCY8YsysSd7N9nUoMSB0rYOcpJlA9cSieePCHga74CRR5vbOIqo0wtC5YmqU1F7cwpQgAcEOJfhCd2LfG6GWhaXMaMHilyvcTwuPScWnv/S2fzj2Cj7WxkYSA6ZhD+0mrACt0H1GR1J41q0z/Y6c7moW7BS8c2teQk21GXmzgEnMg0e8cEDlVTUX+ygMaQeQABqihPlDE2RcoVEes8LeoRaa5CCu7m54nMTd2dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7Oj4JdU/lzekcI8OvUi4db9S155i1mdJwQlSNYHhSaQ=;
 b=RPI9uBdA27KZdCmSTBJ5g9pVYTGnEpsRv3LDlkP9pXtuNW2RIhlk3dFWff4tQdG8Of78aTQA8PYujiUQU43BRkD3MAoFC7Gzq0XeJ45tMMahNT9v1iQbkXP3cOgpeSILb0xgPsh0PRx3xuptmtfL3MGdGxLJBdOhi8mO8NzPbDcrzGKTk8aT47VWONb9vnsEXcTRLcrvw+wW408DpJQ628Vz39VOTAcLxAxhA05l3YbZ0lLc49JToPHBFaLU4mHh0pXESMjm31QJict6lOp2Ns5Y8H1A+cze898rmgzrnKzhc5LbyrcPPLnJep3jr2xmpHTl6aUkxdqTQ3zEA99roA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by SJ5PPFBD6B1667A.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::84f) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.22; Tue, 14 Jul
 2026 16:01:30 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%4]) with mapi id 15.21.0202.018; Tue, 14 Jul 2026
 16:01:30 +0000
Date: Tue, 14 Jul 2026 09:01:29 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v9 06/12] arm,x86,fs/resctrl: Handle change in number of
 RMIDs on each mount
Message-ID: <alZdWe-DACOtDwm0@agluck-desk3>
References: <20260701213553.15222-1-tony.luck@intel.com>
 <20260701213553.15222-7-tony.luck@intel.com>
 <06cdd789-bf1b-415d-a588-b72938d3b0dc@intel.com>
 <alFbX0tItMg9CbB5@agluck-desk3>
 <e937d05b-8381-4d4e-bc36-7165a7214694@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <e937d05b-8381-4d4e-bc36-7165a7214694@intel.com>
X-ClientProxiedBy: SJ0PR13CA0020.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::25) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|SJ5PPFBD6B1667A:EE_
X-MS-Office365-Filtering-Correlation-Id: 25223a50-2858-410e-3f6f-08dee1c12b3c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|7416014|56012099006|5023799004|11063799006|4143699003|22082099003|6133799003|18002099003;
X-Microsoft-Antispam-Message-Info: Cghxz9K0I5Mbvrp0I70FSjYMK8u56IHJtrkNKH4qxhcyahxOgGJN2kiK6IevmEVlv5BZ39Fj/n6lesCOEMZwLMZlYkRPHdHVRrgsNz8HJ6oPcFGOfLeXwmk1/MA8/quxWbRwFyj6OkLyDpOZ1uO85Yb0BOm7VCcbBykIDYpbvEgvhgixys54fRzZ7CYK0LRuyJ3sBqDJNQPFOBMcOREAOqbBm9G1syYh381zCixocOIOvlTRKJLa7cZ71VFwhMexCpZlYZnW55aJxon1MKh3XFjNKchD3pOTNBMMIeCj+1+DWo/hRk1Dm/ZMCm/tDQFAotDWz5swPk1H3j5hY5LRmd4fpjd2pjVFBAvACLzAA0nh3c7aiDwhEm12oxPCryz0gIDC/hyQdQFiuN9qJDCFC8ekuhCTmwQKOiqZIatqrCiy7hzdtdGPr8nIYzrERMx27Wr3HyQf4g3wCMmkGPTIJMXuQUEH12c5yGWelLRyTYBJUPearsnrM4pOUg/E2qtNwNwwZl9gV2LKz+6+6SD6Vqt+EsUJSmG2Rx5lzUk//EfMM46XF42dg9ll/yCTPbORX3FRjLN7hCBDnoB3wccIogDTcFA3XCIKaYP/Fl9yW/2MMb71NLdZZ5grwExo8FeT1ZDeH0OPRULQ3rAdg1NNesLOANMzd4n7CvU2nZt+lJE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(7416014)(56012099006)(5023799004)(11063799006)(4143699003)(22082099003)(6133799003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2qL6EmDiN5lglqjccqcXIx3eDdV+H6/CHcZqFcV09s7WvQzHQlxBqfM58Pud?=
 =?us-ascii?Q?bywa2tSBf1HtVdP4r29oKcyKtOI1bijzq2a4NLWG7VNzwvAH6brjJHKrk28/?=
 =?us-ascii?Q?quC7sRbEne3sligGmkgEpHmty9o3XAsp9PTkuf/MYeQ0MhBJIErUzxfRcuLB?=
 =?us-ascii?Q?Y9XizVcGav3j8zTIWjpjWpRUivL41FmQzye2o/pbXS+2x7U9sIvboEQKOj2o?=
 =?us-ascii?Q?qIYRs+udZBzjH20L6msJeM1xZhkMisNqOjv1vr9gz9k7o6D5KDW+ooW+pZBf?=
 =?us-ascii?Q?nl+U3LjyONLh+TYoMxOxU1CAgT+MvastQIvN4fL6Nn5xRrXxhw4Rev3bFcQK?=
 =?us-ascii?Q?p2UsOHckUvDxvz1pjBDDqdyppl2lEceR3mzCpL9gX3CjY+aTg3gPd4b9ASRo?=
 =?us-ascii?Q?vjsRgYEj1OAKbhCsFz9vBoBP9aF+wEBnRYCFhbehFeVfT2Q2v/gJFUwPUlat?=
 =?us-ascii?Q?HkC7bUyHe+Ub5qSjBbNtS2WEPuazJJW/maMmZK1d5aC7H/ReUFdmZXI97B8U?=
 =?us-ascii?Q?+2udi0UKKN2nBOsQum7S0KH0/cCEzBIfNwhEH27n3Qxeta+79mjRb6swqOH8?=
 =?us-ascii?Q?30JEXT+ir0+EUY9n5ccgsAb6uGCUCMu369MZ431t1rADSvOZ5NH9SkhZTbPf?=
 =?us-ascii?Q?KZqRBA8akjCiXbb7TljcR4AVa/KvYZEkhsuSxhRkeV3YCgjwoNDuzjNa/aHY?=
 =?us-ascii?Q?vZhtQ2zKIdPJJ8NR86TWdKOKfgbi1UVx5G32bYhpIWaDgk3UpjBZOxafuZ44?=
 =?us-ascii?Q?up8EQwmtzrmaSXF6ivZaQbwRUnWLdvbANQcLtLiwX3QSxRrwrR6sAtk+hdzc?=
 =?us-ascii?Q?mvIvNfGNuKBgZtdKUTnIAt1ToYAFvULpFbyxN20ASaGDwyUUp8uYxR1JVWJz?=
 =?us-ascii?Q?UqHqHNyBrHMs8t8OTrFeRK43MDUu3lWkbOYWdHO1KOKlyr5gJI7vUKt2OqCX?=
 =?us-ascii?Q?v+Hf1NNhQBNLs9+QJmBGgQa9N1k+fkGKuWYbI64y4eW3dFKM1nUPEmgwyOUX?=
 =?us-ascii?Q?SfIFaYCcurUyPLfiWhwOhxPeVst31v9jrExERR+ldX+iMklZiLgn5zq030A0?=
 =?us-ascii?Q?DTApAOj2GQdDmlg63Dz3iWQfNTxMz7jLFkjDHLKyAZ3AnPP2XwdJuk375P1l?=
 =?us-ascii?Q?tgHdN1jVia2kQGQfC/UhvUeT8HGqdwKM0J8KXKLfnT3bd+3usauM2+DXBpYw?=
 =?us-ascii?Q?CBlb/GBGCoO8IfnZ+pTqGyYcyEUu9ap9wR5mFNvGMMaVAP7qtSH3ejduDKdE?=
 =?us-ascii?Q?TZk9CcKzEbTAYzjEzEMUMF6GmmSXgz1wq5IxrWYMObw2UYNWXP/P8QsTPzNh?=
 =?us-ascii?Q?ZHquUReNgI3bmFy34nS927bXBZAYOaetsqAjJdG86LvJSEvStiDUVVdeJVOg?=
 =?us-ascii?Q?f+dyZA3tMntFVge+nZLJiirkLvji8yWtwT5YvGw/cpIja/KCMr0fQ1jtWsqu?=
 =?us-ascii?Q?Rqq+LwS+qdUc0Rm18O9xEu3NEEwiibSTDMy+Ux/EnFt4NSiXK8PH8NBqI9NG?=
 =?us-ascii?Q?izVJdchdZ95HApi2cAnUczbaNqOc5EMwolSC7mibFg+uOpwCcqg0U42GAmP7?=
 =?us-ascii?Q?LHBFsnIuYCqetRqzY7eolgWDq5L7feSaTXmmNxWb5pC/FBOiD88xgExX4sWV?=
 =?us-ascii?Q?d8Gpnlbg412dVtQ6hp8h1yfy2OzeGhkX2lO4TNq3HD/2LOspRRPDPRi/yfo9?=
 =?us-ascii?Q?6Odj+IJSK2hp8xf5KVHHizLaZZkKVs9zBe8A/+thSnqmqCtDBWHipuYCKMH3?=
 =?us-ascii?Q?3GDy3FWVYA=3D=3D?=
X-Exchange-RoutingPolicyChecked: seh6+UoaYQysNctWKdLjZAorGweVj813YJk/u5+OkhhctmC7ej9KzacrU7QskNtHWPk2WBLgFM1mX0uxYTjdiqU96FVWSBsibfxsC4Tp6vtXWCORGxDm7d/eYn87M6OlQ6GhwbfsHWkFe3t+7D5TiV2c95DJTJ47YI89LuwSXjXIXO456KXokLAyFqMCPYtsuEo2wkj4DjoU6sQW+NBZWd9PJTLgxtkXScQ9+muXk6PnpSUHlW/TlPCkoemi8Frb8WcAD5JxT9V4nSHBvzyKphgjTMBbyiywcYfiNhTzozl9BDh2g/FmWEOhs7X+rEyo951E3T3q/vrUWQyl5YHK9g==
X-MS-Exchange-CrossTenant-Network-Message-Id: 25223a50-2858-410e-3f6f-08dee1c12b3c
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2026 16:01:30.5195
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9ZYMiG8Q4hSoYF8zVm20oC73EoDF1PbHM8dFAZMtAA25L+UGaBgV5bVFMFbk60jrLy+v9d77Im/MJUkXH2at1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFBD6B1667A
X-OriginatorOrg: intel.com

On Tue, Jul 14, 2026 at 08:18:30AM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 7/10/26 1:51 PM, Luck, Tony wrote:
> > On Wed, Jul 08, 2026 at 03:50:45PM -0700, Reinette Chatre wrote:
> >> Hi Tony,
> >>
> >> On 7/1/26 2:35 PM, Tony Luck wrote:
> >>> Application Energy Telemetry (AET) event enumeration takes place
> >>> asynchronously. Linux builds the pmt_telemetry module into the kernel to
> >>> kick off enumeration early enough that it completes before first mount of
> >>> the resctrl file system.
> >>>
> >>> Allowing pmt_telemetry to be a loadable module means that it is possible
> >>> for different numbers of RMIDs to be supported on each mount, depending
> >>> on whether pmt_telemetry module is loaded.
> >>>
> >>> For simplicity, calculate the maximum possible number of RMIDs and use
> >>> that value to allocate the rmid_ptrs[] array just once. Also use this
> >>> maximum RMID value when allocating rdt_l3_mon_domain::rmid_busy_llc
> >>> bitmap and rdt_l3_mon_domain::mbm_states.
> >>
> >> This does not sound right. Why use the maximum RMID for L3 monitoring state?
> >> It can be guaranteed that L3 monitoring state is only accessed when that
> >> monitoring is enabled and when it is enabled it can be guaranteed to never
> >> use more RMID than what L3 itself supports. Why would it ever be required
> >> to allocate more than that? Could this not instead be limited to
> >> rdt_resource::resctrl_mon::num_rmid? From what I can tell such transition
> >> will make it explicit and consistent (since arch code already allocates
> >> this state based on this) how the L3 monitoring state is sized.
> > 
> > L3 monitoring on X86 happens to provide the overall maximum possible RMID
> > value (any larger value with #GP fault when written to IA32_PQR_ASSOC MSR).
> > 
> > AET could potentially claim to support a larger number (and this could
> > happen on low core count SKUs where the number of RMIDs supported scales
> > down with the number of cores).
> > 
> > resctrl_arch_system_max_rmid_idx() needs better comments, and
> > implementation. On x86 even if the L3 monitor functions have been
> > disabled, the limit is still bounded by CPUID. Not by what might
> > be found in the AET->mon.num_rmid.
> 
> I see. I assume the implementation change you refer to involves dropping
> usage of r->mon_capable that depends on rdt_cpu_has().
> 
> How much to rely on CPUID is not clear to me. The direction seems to
> be to move away from CPUID, which makes adding new CPUID dependencies
> less ideal? 

Here's my current work-in-progress version:

u32 resctrl_arch_system_max_rmid_idx(void)
{
	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
	u32 ret;

	/* CPUID provides maximum possible RMID value */
	ret = cpuid_ebx(0xf) + 1;

	/*
	 * if system is capable of L3 monitoring the maximum RMID value may
	 * be lower that system maximum. Either because the L3 monitoring
	 * feature supports fewer RMIDs (CPUID(0xF, 0x1).ECX), or because SNC
	 * (Sub-NUMA Cluster) is enabled and divides RMIDs per cluster.
	 */
	if (r->mon_capable)
		ret = r->mon.num_rmid;

	return ret;
}

CPUID seems unavoidable in the case that the platform doesn't support
(or has disabled the various L3 monitoring events). In that case using
cpuid_ebx(0xf) gets the max value that can be written to the RMID field
of IA32_PQR_ASSOC. This is common to Intel and AMD.

If RDT_RESOURCE_L3 monitoring is enabled, then it could impose a smaller
value from CPUID(0xF, 0x1).ECX. SNC might also divide down the RMID
space per node. That calculation has already been done, so just re-using
the result from r->mon.num_rmid avoids mistakes.

Even if AET supports a larger value of num_rmid, the system is limited
to what can be written to IA32_PQR_ASSOC, so no need to scan all
resources.


> > Though perhaps intel_aet.c should look at CPUID to avoid believing any
> > larger numbers seen in AET enumeration.
> > 
> >>>
> >>> The limbo code must deal with changes in the number of RMIDs from one
> >>> mount to the next because some RMIDs may still be "busy" when the file
> >>> system is unmounted, but be above resctrl_arch_system_num_rmid_idx()
> >>> for the remount. In this case RMIDs that can be released are not put
> >>> onto the rmid_free_lru list.
> >>>
> >>> Signed-off-by: Tony Luck <tony.luck@intel.com>
> >>> ---
> >>
> >> ...
> >>
> >>> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> >>> index 60d50ac79e7b..3169441a2d40 100644
> >>> --- a/arch/x86/kernel/cpu/resctrl/core.c
> >>> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> >>> @@ -144,6 +144,20 @@ u32 resctrl_arch_system_num_rmid_idx(void)
> >>>  	return num_rmids == U32_MAX ? 0 : num_rmids;
> >>>  }
> >>>  
> >>> +/**
> >>> + * resctrl_arch_system_max_rmid_idx - Largest possible number of RMIDs
> >>> + *
> >>> + * Return: If L3 monitoring is supported, largest possible comes from L3 based
> >>> + * on CPUID(0xf,0x0).EBX (scaled down on Sub-NUMA Cluster systems). Otherwise
> >>> + * maximum from any other mon_capable resources.
> >>
> >> Above reads "Otherwise maximum from any other ..." but the code is actually
> >> "Otherwise minimum from any other ..." which contradicts the "max" intention of
> >> this function?
> >>
> >>> + */
> >>> +u32 resctrl_arch_system_max_rmid_idx(void)
> >>> +{
> >>> +	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
> >>> +
> >>> +	return r->mon_capable ? r->mon.num_rmid : resctrl_arch_system_num_rmid_idx();
> >>
> >> This smells like a function that pretends to be generic but created to provide
> >> correct results on specific x86 hardware. 
> >> If this needs to provide max RMID why not cycle through all monitoring resources
> >> and determine the max RMID, why special case L3?
> >>
> >> ...
> >>
> >>> @@ -961,8 +975,8 @@ void mbm_setup_overflow_handler(struct rdt_l3_mon_domain *dom, unsigned long del
> >>>  
> >>>  int setup_rmid_lru_list(void)
> >>>  {
> >>> +	u32 max_idx_limit, min_idx_limit;
> >>>  	struct rmid_entry *entry = NULL;
> >>> -	u32 idx_limit;
> >>>  	u32 idx;
> >>>  	int i;
> >>>  
> >>> @@ -970,27 +984,29 @@ int setup_rmid_lru_list(void)
> >>>  		return 0;
> >>>  
> >>>  	/*
> >>> -	 * Called on every mount, but the number of RMIDs cannot change
> >>> -	 * after the first mount, so keep using the same set of rmid_ptrs[]
> >>> -	 * until resctrl_exit(). Note that the limbo handler continues to
> >>> -	 * access rmid_ptrs[] after resctrl is unmounted.
> >>> +	 * Allocate the largest number of RMIDs that this system will ever
> >>> +	 * need. These cannot be freed until resctrl_exit() because the limbo
> >>> +	 * handler continues to access rmid_ptrs[] after resctrl is unmounted.
> >>>  	 */
> >>> -	if (rmid_ptrs)
> >>> -		return 0;
> >>> -
> >>> -	idx_limit = resctrl_arch_system_num_rmid_idx();
> >>> -	rmid_ptrs = kzalloc_objs(struct rmid_entry, idx_limit);
> >>> -	if (!rmid_ptrs)
> >>> -		return -ENOMEM;
> >>> +	if (!rmid_ptrs) {
> >>> +		max_idx_limit = resctrl_arch_system_max_rmid_idx();
> >>> +		rmid_ptrs = kzalloc_objs(struct rmid_entry, max_idx_limit);
> >>> +		if (!rmid_ptrs)
> >>> +			return -ENOMEM;
> >>>  
> >>> -	for (i = 0; i < idx_limit; i++) {
> >>> -		entry = &rmid_ptrs[i];
> >>> -		INIT_LIST_HEAD(&entry->list);
> >>> +		for (i = 0; i < max_idx_limit; i++) {
> >>> +			entry = &rmid_ptrs[i];
> >>> +			INIT_LIST_HEAD(&entry->list);
> >>>  
> >>> -		resctrl_arch_rmid_idx_decode(i, &entry->closid, &entry->rmid);
> >>> -		list_add_tail(&entry->list, &rmid_free_lru);
> >>> +			resctrl_arch_rmid_idx_decode(i, &entry->closid, &entry->rmid);
> >>> +		}
> >>>  	}
> >>>  
> >>> +	/* Find how many RMIDs are needed for this mount */
> >>> +	min_idx_limit = resctrl_arch_system_num_rmid_idx();
> >>
> >> Since mon_capable resources can now come and go from mount to mount there are scenarios where
> >> rmid_ptrs[] may be smaller than min_idx_limit so above needs extra checks to protect against
> >> overrun below.
> > 
> > I don't intend for that to happen. The initial allocation of rmid_ptrs[]
> > is supposed to be large enough that no subsequent mount would need more.
> > 
> > I.e. resctrl_arch_system_max_rmid_idx() must return a value >= than
> > any subsequent resctrl_arch_system_num_rmid_idx() call.
> > 
> > Perhaps I should add this to resctrl_arch_system_num_rmid_idx()?
> > 
> > 	num_rmids = min(num_rmids, resctrl_arch_system_max_rmid_idx());
> 
> While trusting the arch helpers to "do the right thing" occurs frequently in resctrl
> as a result of its evolution I do not think this is something that it should keep doing.
> I think it will be more robust for resctrl fs to protect itself here. For example, could
> resctrl fs obtain a new partner variable to rmid_ptrs[] that reflects how many elements it has?
> This could be done in addition to changes to arch helpers that will then be required to
> meet resctrl fs expectations.

This is a good idea.  I can switch "max_idx_limit" from being a local
variable in setup_rmid_lru_list() to being global (static). Initialize
it exactly once from resctrl_arch_system_max_rmid_idx() here, and remove
all the other local copies and initializations.

setup_rmid_lru_list() can then defend against bad resctrl_arch_system_num_rmid_idx()
return values with:

	/* Find how many RMIDs are needed for this mount */
	min_idx_limit = resctrl_arch_system_num_rmid_idx();
	if (min_idx_limit > max_idx_limit) {
		pr_warn_once("Attempt to use too many RMIDs\n");
		min_idx_limit = max_idx_limit;
	}

Does that seem reasonable?
> 
> Reinette
> 

-Tony
> 
> 
> 
