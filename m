Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC0FB3019BA
	for <patches@lists.linux.dev>; Mon,  6 Apr 2026 20:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775507719; cv=fail; b=XdU+ZRcQn55NHjr4P00OnowHkbVTCUbGeRuvKXf/yjF4UbtLsK2pGjj2p7zJAZ4UZZEDl14+bPXpbCNaZ20gmw4C3FMthgCNeaOIKvO2bE6iQEPS78BkE31t/6Pp+kTl3J9f0VcyQTHWLwksqOi6BJayvr/lbpjQtSqzguaWQ8s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775507719; c=relaxed/simple;
	bh=Q2EwzjyGEWYl4D1hTwmRUKdemhBWZ+93cN0boDgkCRc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=gcVbs91NwzrkRfj04p22ujJDe4BqHrH6/uKxr476dkCBEnXElQojdTp7VvKK0q9ijiX/VxU4MpCEUGSMOFliBKFdEB8T2zAxSQexP2P470eUp4oWF9S9JPnMXRR4Bmp9mNcE0vqLVzF5ZLoWL03TQXld3R22znOBgmbLpt1fNrI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=N4A0/gj8; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N4A0/gj8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775507716; x=1807043716;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Q2EwzjyGEWYl4D1hTwmRUKdemhBWZ+93cN0boDgkCRc=;
  b=N4A0/gj88Cp+2Q9yObA4UnnXY0MIHRIb4Cxrnu3aEAkxcuiu2Hh3jV7H
   S3IgcjZZDdPmWO3nTgiGuA04jdYOKDxybyBLY3/kZdbpE8fnMusBWdXaV
   I6HJjGs2xVXtXXGlgTYJGo5U48a3gwI0LD90zZ5pKdlAyk8JGOKwNSQXn
   sIqkMbv4p2jhpbO0pK2tnZbWXb/jEYLqLURQzGQW/R2nvLir+ObU+bVCv
   9wtg2cjjoq132g8Icqrg7NIW5qqzFyx+TE38YUxM8keFNyKKw6/cIaZHv
   k1/FtugBE6uhHGF9axOhku3HTPmedewvW/MfliLHiMyu942ykqHRB7M8H
   g==;
X-CSE-ConnectionGUID: TKfks/XPSXWivwu95XEJsg==
X-CSE-MsgGUID: nqi3qvp0SDGCeZV5juHDKg==
X-IronPort-AV: E=McAfee;i="6800,10657,11751"; a="76358060"
X-IronPort-AV: E=Sophos;i="6.23,164,1770624000"; 
   d="scan'208";a="76358060"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2026 13:35:16 -0700
X-CSE-ConnectionGUID: tcoNFDWLQ/u/VvKHBQfqZw==
X-CSE-MsgGUID: CnVK2VlPSi2SFGLb9MrlUw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,164,1770624000"; 
   d="scan'208";a="232022090"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2026 13:35:16 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 6 Apr 2026 13:35:15 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 6 Apr 2026 13:35:15 -0700
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.69) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 6 Apr 2026 13:35:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GMgGubSWkyC3yZotsHXBf325uARRDrI8f6LfNBON3Xk9U8jdBTFSl1RVLPi7cBSZxuDgv9OEH2OZRj5bW3TcACZRjpPorXC3NKHGKIg3w8lMkiiWT9vTrqeQAnSxKn1C8DBL0Rl6jIl6CV0dOhLxCaxyiWDir/CMtkDmaT32TmRjdyewX9bSjUjczXSl/4UqcKhDwL6yQRWXDB5KQJ6Dz18aLYFoSkFN1kHLEGvLeIVHoc9sALApISw+Kb3qCaqbP4RMCQ2qxdq9DNr5PSMJ2t/zXcCi+g0+9BMjws7a5oDY/FkKGZ6UleFZtvFErBjZetY/WWvTkRWS2dbT5ELhHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8PDsMBAS5Ainv2w5ETXoqdWVZirHWGakeeMm98FjKMk=;
 b=hLEmDmPtfhIxPznwyori7nFnnZq/AuKU8lWOfKqzkMOosxJWs7I6aMOORV68rQMdIa3CQBB5B7wwXpUBgUL/YizDyi93Up7+bZmQG9Zd8PWkxUcQRLqCDSXlj+mWOgoGb+vBtr/P7IaVmtSmfE0FNIHQHTdcuspIAyv8be/khtYikBhyYlCjR4Lnlr0el5rteCPj54w14rTLRMaKIqmOKU100k/PBtWFOUeAx5TYcgDfCJzQg9GNQl0WpnKcfwIdLqRYmXVhUXiyO+gOrVoaROWej9x9mG+O7BASW9LsdcptuhdRoWJWvvyjSmzb4uEFE/ic5g/MS+Gu0bwtcXSesg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by IA0PR11MB7813.namprd11.prod.outlook.com (2603:10b6:208:402::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.17; Mon, 6 Apr
 2026 20:35:12 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%7]) with mapi id 15.20.9769.016; Mon, 6 Apr 2026
 20:35:12 +0000
Date: Mon, 6 Apr 2026 13:35:10 -0700
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
Message-ID: <adQY_m8I2jUiR88k@agluck-desk3>
References: <20260330214322.96686-1-tony.luck@intel.com>
 <20260330214322.96686-5-tony.luck@intel.com>
 <45436044-202b-4d77-b552-2156be47a52d@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <45436044-202b-4d77-b552-2156be47a52d@intel.com>
X-ClientProxiedBy: BY3PR04CA0008.namprd04.prod.outlook.com
 (2603:10b6:a03:217::13) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|IA0PR11MB7813:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b2dfe44-05a5-46a6-f7dd-08de941c0067
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info: VOKfY1BhyTeJEfWWMU0QhJ3N9p+ei7e2k66OVZWaKUYYZTVqAMSNGwVGqDe5wbm/nly2OpP6GRPq2PiaWVL8WZRkuFS9ohDeYcVinDu1PUpnSV9GAfXm6qO7FI8JALUJ5giBrjCfLpn44hdNj611uIMHVnwT6ED1+L+yc2/BHCyUrihTfz9EngsbOR9W8uppF2/ZCKs5dfZC98VgnExIJXzEc78Q8u0b8n6C3jRbMHuyJ67oQMs5UrVlMSRoKbFBmO2EUXszVEbSB/tpNoj9E9zjIyGBQ2jBkA/vqTqgMEglBbeKqDskF+VSKAo5eRFQXlC8wj18CJ7KdjCVgX+Vq+fKtiPMygJz9h5aA+JcySbzbinzSjN5qg/LPwIRqCSD9zV3f+o3s0BYhuI6rTGpULzttXiUjN3zl1cxFUIbWQOsPM39fkgKlwsVSJocsMCgmVttfjGt/Gj3kziCV2h83mNta4sBKg/NSfw5pYHn2qpFSrP+2MHHzurmdzWLPF+ilZdgMTkDfYz9jUAwEpw/OCZvwfa9e45/Uo343ix2j4F+nANUWFWYRVJyepfGENfH5oCatOKMlvdOnQxBhqUb39sUu3uA76tGz2FHgA1/QbBUfBB1rTPzbXD53b2Wwj/hzp0Bs0EapYUFwtssYmwbOrsnQnqKfFhQMiguS0gdc5y5id5I5MgLcRkTzFdO5JONj3otjRoPPjiRFX6aB8S+xGo3QtQE9OWYp5Uj0FO3Awk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pzz8DACwdEOw0T17fCr5yEwFCvkS/4R8aCI8Su79d1PR0bWwS8n83fp04IAl?=
 =?us-ascii?Q?FTaq55ua6BHO2huwgWa1O42R9nIPC9I8GWNtBSF7HRfQik/XisKX/k5/bRSO?=
 =?us-ascii?Q?IblkC31cQkUT2+c5RNvHkheuqMAdMy0Im56Xnm3XVAdqg9KmBBAqm0JaCB4C?=
 =?us-ascii?Q?kAKDX4Bq/9W+WIAudAVW7CDyXrjlerSW3HThm1sTFaPZs+n2T2VZbwwZlG3x?=
 =?us-ascii?Q?TLCtIMO28kQZv9u2tbYRkHAOE0eERv1TSXfix75X0hpKbv0K+s6kGPiFr8vZ?=
 =?us-ascii?Q?/tymkIJprJBZpKQ9O+66CKGT4ltepEG3T+aEzcDyGxeIy0j0V/MAVACgo8CZ?=
 =?us-ascii?Q?3tMy25IrIo2ueyeT71hsaHFB5yAHSC0VCNxOAkerQNHeOt7h1ipBH8gsDx6A?=
 =?us-ascii?Q?2T0XD426Al/CoiGcLGSOIXhJZ71Maa5KoY0g53onOwalXYTKAEdJ4S89/HQc?=
 =?us-ascii?Q?ILPXkz0rjPMR16VMybcxfd8ktwPEkrikiLbcv6olCZdBx4c8VxPr+Izqfzwf?=
 =?us-ascii?Q?HSgcmqaP/RMrrbIwoMrA+kURkG5h/Z6vqA7DGpsO3yfQ05K5fM50Loxjie3p?=
 =?us-ascii?Q?heT2ujofrJoaSCTTkIUS/uE2R5J3wq47rzw75RupJ7yp7TfokjGsdnuDUBFh?=
 =?us-ascii?Q?Q/KjTov9tOSKvNAAHHa8QInvvw+inRI3t3UBcpUn8KwdVWV8Zcf/KD3NprQG?=
 =?us-ascii?Q?0kcqPvIid1Mh1Tl7dPj1GwXexOx8pP/lGCFRQLU02Vsws+FUDQU9Bq9146Nu?=
 =?us-ascii?Q?fYmc7wlT4onTSsn8pdd3qljMSkg9su32OehInpz3PgTFxed1mh9nF0yVmy+J?=
 =?us-ascii?Q?yBHy60nQMwCAwIycmq/ZRZQe++jpFwgzg8FFJlV5aYD/I1ALOi9+IJapw3wQ?=
 =?us-ascii?Q?N3tPM6cCNjpDXZYJYj7lAqQsn4mRPIjwIwR3yl41x65rEdRCrt3CjQD97hBQ?=
 =?us-ascii?Q?7xKCRUAhXJijog+jk9q3P2vB9Z66ElIaWTaHShzweOPEpcx0qDtqXzM7XDB5?=
 =?us-ascii?Q?jDHkSUaKwMNsBZpHc6EvGzWuawLXctiIMLxehYjlVAGZ2gybq6EK3aHr2bA9?=
 =?us-ascii?Q?OL/oIExBD6QkBXH8fgw/+xgs2368TZyo6c+7vi1UGDzkU8V/rEKvpvMY0uHW?=
 =?us-ascii?Q?9MgtyaWMOtBerbC43T3xmt5kEUU3mUERJ4AgS96hWKnZ6pvM0QFt2EXoLgNW?=
 =?us-ascii?Q?HNjwwK2hKh4C2kJla7eHbtrvcBvSqkdUHsCQJ2ChXrWgE+HTLnRPV/Pw242d?=
 =?us-ascii?Q?LDXPYfyNXlZfsYM963C3ILKkZmV/EMUYGssj8Z91X7eouMqtwnradw5J/UZ+?=
 =?us-ascii?Q?TKsbCimQhhmjyWlxgELW0ZqyNqxzeub78dQeopbbTcnspJ9Zo8KsH/jglvBz?=
 =?us-ascii?Q?zs1Vqt3LExbSlt0d1GLwdAbrnwUiOiMH7ceay+fGvq1jK0Fd7PsF5r93sUNu?=
 =?us-ascii?Q?S03P56guGSz5VImVFffCjmTbglhcBuE+ZraoyzV31kAWZlgEg5y6c07VRJK8?=
 =?us-ascii?Q?+AFccWQTLTOON0jMeBCEZUA829BonZcQiunRj8CsR070kaJMVbWAfxdKhOWu?=
 =?us-ascii?Q?ovWfMbxriphdznkruW+Uhv8bJpgEqnIw/gmkun36whNRyPxBWHIN7qxgp4Po?=
 =?us-ascii?Q?AZCIDZcjKO/McJ6UkMjul7fFfdtly0QNxqrNuVoTaR8gLB4ojXtEOkYD19LP?=
 =?us-ascii?Q?b+pt3Z5Ac1xo/5n/4hS/gG4s+CFOrx4cNbwTOYkNIirulq10NqedDsa5op9u?=
 =?us-ascii?Q?zKxdD/Xl2w=3D=3D?=
X-Exchange-RoutingPolicyChecked: in1xjGV0h/SurEnQYMHOzUD8oE3lLue4cKLmQblOByvXDwUMq0JLMzydBmspBSN1GbtFFdbx3AcxMqSPqSwAlvQY9Lcrj6yjEfUlZ7ym+L718pH34qW/V4YSYf6E+uPh3/zAZpO+UnDm+RgHaVKli1qL3uWKnq742GuTaHShlE/1ZheCqLIZs4wzZA7jec0BQlr/iSa4R0R/2u36ONg8m/db7hSZOrZGAfOS8rI7qSDaVJxnHuRErK9n8eXd/G/N005M3we9bIGIsSdy8S7sZE2eSZXYCN5PbfVXLDS/VqhWUg+Fd+PUKbb7nJ/uQ1BAtHTanAatkhh1SE4w27Q06g==
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b2dfe44-05a5-46a6-f7dd-08de941c0067
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2026 20:35:12.1371
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6usPjjyD9ifqAqpKK1sXcE25QKz531V8uOVYDHEaMmaa32SMg1OsAvraq4H0Rq60k65D4EVagCGhCHlLG0WFbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7813
X-OriginatorOrg: intel.com

Hi Reinette,

On Fri, Apr 03, 2026 at 05:52:30PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 3/30/26 2:43 PM, Tony Luck wrote:
> > Add hooks for every mount/unmount of the resctrl file system so that
> > architecture code can allocate on mount and free on unmount.
> 
> Please use the changelog to describe and motivate all the other things
> that this patch does.

OK. I will expand.

> > 
> > Signed-off-by: Tony Luck <tony.luck@intel.com>
> > ---
> > 
> > Note this patch disables enumeration of AET monitor events because the
> > new mount/unmount hooks do not call intel_aet_get_events() (which is
> > not ready for the change from "just on first mount" to "called on
> > every mount"). That is resolved in the next patch.
> 
> This could be part of the proper changelog.
> 
> Could patches be re-ordered to support incremental changes?

I'll look again because several things have changed since I ordered
the series this way. But some bits got overly complicated trying to
make AET ready to be called multiple times. If I can't solve elegantly
I'll move this into the proper changelog.

> > 
> >  include/linux/resctrl.h                 | 12 +++++--
> >  arch/x86/kernel/cpu/resctrl/internal.h  |  8 +++--
> >  arch/x86/kernel/cpu/resctrl/core.c      | 14 +++++++-
> >  arch/x86/kernel/cpu/resctrl/intel_aet.c | 13 ++++++++
> >  fs/resctrl/rdtgroup.c                   | 43 ++++++++++++++++++-------
> >  5 files changed, 74 insertions(+), 16 deletions(-)
> > 
> > diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> > index b312aaf76974..489c7d4ae3e9 100644
> > --- a/include/linux/resctrl.h
> > +++ b/include/linux/resctrl.h
> > @@ -518,11 +518,19 @@ void resctrl_online_cpu(unsigned int cpu);
> >  void resctrl_offline_cpu(unsigned int cpu);
> >  
> >  /*
> > - * Architecture hook called at beginning of first file system mount attempt.
> > - * No locks are held.
> > + * Architecture hooks for resctrl mount/unmount.
> > + * Each is called with resctrl_mount_lock held.
> >   */
> > +
> > +/* Called at beginning of each file system mount attempt. */
> >  void resctrl_arch_pre_mount(void);
> >  
> > +/* Called to report success/failure of mount. */
> > +void resctrl_arch_mount_result(int ret);
> 
> Why is this needed? Why not just always call resctrl_arch_unmount()?

You are right. If the mount fails in the resctrl code, resctrl_arch_unmount()
can clean things up.

> > +
> > +/* Called to report unmount. */
> > +void resctrl_arch_unmount(void);
> > +
> >  /**
> >   * resctrl_arch_rmid_read() - Read the eventid counter corresponding to rmid
> >   *			      for this resource and domain.
> > diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> > index e3cfa0c10e92..6f322818a9e6 100644
> > --- a/arch/x86/kernel/cpu/resctrl/internal.h
> > +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> > @@ -234,14 +234,18 @@ void rdt_domain_reconfigure_cdp(struct rdt_resource *r);
> >  void resctrl_arch_mbm_cntr_assign_set_one(struct rdt_resource *r);
> >  
> >  #ifdef CONFIG_X86_CPU_RESCTRL_INTEL_AET
> > -bool intel_aet_get_events(void);
> > +bool intel_aet_pre_mount(void);
> > +void intel_aet_mount_result(int ret);
> > +void intel_aet_unmount(void);
> >  void __exit intel_aet_exit(void);
> >  int intel_aet_read_event(int domid, u32 rmid, void *arch_priv, u64 *val);
> >  void intel_aet_mon_domain_setup(int cpu, int id, struct rdt_resource *r,
> >  				struct list_head *add_pos);
> >  bool intel_handle_aet_option(bool force_off, char *tok);
> >  #else
> > -static inline bool intel_aet_get_events(void) { return false; }
> > +static inline bool intel_aet_pre_mount(void) { return false; }
> > +static inline void intel_aet_mount_result(int ret) { }
> > +static inline void intel_aet_unmount(void) { }
> >  static inline void __exit intel_aet_exit(void) { }
> >  static inline int intel_aet_read_event(int domid, u32 rmid, void *arch_priv, u64 *val)
> >  {
> > diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> > index 7667cf7c4e94..162eca2cfcdb 100644
> > --- a/arch/x86/kernel/cpu/resctrl/core.c
> > +++ b/arch/x86/kernel/cpu/resctrl/core.c
> > @@ -769,8 +769,10 @@ void resctrl_arch_pre_mount(void)
> >  	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
> >  	int cpu;
> >  
> > -	if (!intel_aet_get_events())
> > +	if (!intel_aet_pre_mount()) {
> > +		r->mon_capable = false;
> 
> Why is this needed?

I'll move to the next patch. It's needed for the case when AET works on some
mount and then fails on a subsequent one. But that can't happen at this point
in this patch series.

> >  		return;
> > +	}
> >  
> >  	/*
> >  	 * Late discovery of telemetry events means the domains for the
> 
> 
> ...
> 
> >  #include "internal.h"
> >  
> > +/* Mutex protecting mount/unmount operations */
> > +static DEFINE_MUTEX(resctrl_mount_lock);
> > +
> >  /* Mutex to protect rdtgroup access. */
> >  DEFINE_MUTEX(rdtgroup_mutex);
> >  
> > @@ -2788,17 +2790,8 @@ static int rdt_get_tree(struct fs_context *fc)
> >  	struct rdt_resource *r;
> >  	int ret;
> >  
> > -	DO_ONCE_SLEEPABLE(resctrl_arch_pre_mount);
> > -
> >  	cpus_read_lock();
> >  	mutex_lock(&rdtgroup_mutex);
> > -	/*
> > -	 * resctrl file system can only be mounted once.
> > -	 */
> > -	if (resctrl_mounted) {
> > -		ret = -EBUSY;
> > -		goto out;
> > -	}
> >  
> >  	ret = setup_rmid_lru_list();
> >  	if (ret)
> > @@ -2900,6 +2893,30 @@ static int rdt_get_tree(struct fs_context *fc)
> >  	return ret;
> >  }
> >  
> > +static int rdt_get_tree_wrapper(struct fs_context *fc)
> > +{
> > +	int ret;
> > +
> > +	mutex_lock(&resctrl_mount_lock);
> > +
> > +	/*
> > +	 * resctrl file system can only be mounted once.
> > +	 */
> > +	if (resctrl_mounted) {
> > +		mutex_unlock(&resctrl_mount_lock);
> > +		return -EBUSY;
> > +	}
> > +
> 
> This does not look right. Here too is resctrl_mounted accessed without rdtgroup_mutex
> held. This change implies that resctrl_mounted is now protected by resctrl_mount_lock
> but resctrl is not changed to respect this throughout resulting in unsafe access of
> resctrl_mounted.
> 
> Does this new resctrl_mount_lock need to be in resctrl fs? It really seems as though the
> needed synchronization belongs in the architecture. Could this instead be accomplished
> with a private mutex within the AET code?

If you dig in lore for the v3 of this patch, you'll see I had the mutex in the
AET code. But there were some complications.

1) Need to acquire in intel_aet_pre_mount() and release in intel_aet_mount_result()
which is legal, but makes code more complex when call chains need to be compared to
check that the mutex is being released correctly.

2) The "only mounted once" case meant extra state (AET_PRESENT, which you note
in next patch may be redundant) because intel_aet_pre_mount() is called, but
needs to do nothing.

Adding resctrl_mount_lock to the file system code made things simpler. The
pre-mount code can't be called with rdtgroup_mutex held because it needs to
build the domains. That needs cpus_read_lock() + mutex_lock(&domain_list_lock);

I need to add more comments on locking. resctrl_mounted is only modified when both
resctrl_mount_lock AND rdtgroup_mutex are held. I believe that makes it safe to
read the value of resctrl_mounted with just rdtgroup_mutex held.

> > +	resctrl_arch_pre_mount();
> > +
> > +	ret = rdt_get_tree(fc);
> > +
> > +	resctrl_arch_mount_result(ret);
> 
> Could this instead just call resctrl_arch_unmount() on failure?

Yes. Thanks for the suggestion.

> Reinette

-Tony
