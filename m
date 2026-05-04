Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D2023E1CF9
	for <patches@lists.linux.dev>; Mon,  4 May 2026 16:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777911910; cv=fail; b=Yt3SiU2H8uYI4g6RlXvA7UyR/g5yrmBDcP8BEXmucFHZBD94pSozGPu4i3Myw8tAQT0viFHmhdZzbE2s4sFGYa5ykezKpctfVzabataGF6E3JKECGzPUPMUlgmD9ojorCIHZtkGenY6SCHoPoQ/GjGkPhl7ccKUhHjaEhZ9bfpg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777911910; c=relaxed/simple;
	bh=Yo909cxSRpZJ+N1+f5QPhYETuQcrEjI6mANRC+mbu6c=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Ku82fJmd1F3UZ/FwJXY7nuXrQCA+eOgwK9uZPjZ2kFDrBHkSaR6AiO48/COKKtKZ2433iJ3wcFSd40mTATqiefZ11rC6C1/eHcA42UmZCp58Sn04t+59J640f4ltPTA3k33Fe+TRApKrvC/nMghZITC4jAf+JubSD7+SVoKWjZI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Xn/cq1rW; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Xn/cq1rW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777911907; x=1809447907;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Yo909cxSRpZJ+N1+f5QPhYETuQcrEjI6mANRC+mbu6c=;
  b=Xn/cq1rWscOtZyPwOunbIbVcHxvj1ZahZkiWXFJ7rbLiT1EZgzxBHtx0
   az0UNsG8+9WPDa+dGK8uphsE2iB1W+HEty1v9GorDYxo7ZPrZN+cwn0cd
   7lTc2B9/QR2DkRVbd2YeY+l0B/oXEqpDZlVGgIAplk2XL+7HRrJqxEeeg
   Yq7P9ZlTthz4QfomQVgwiXVAz/2ZooBwZx5WPskTHZtrUoZmiPt3vMSGr
   QkTE4egunay2RjkxftWHOCco+3Kds0cmGIspV5WDcqRstdzkgzB2V+l2G
   EapHZe9tund8iE0UFOyCECv4DmQtGQBTX9DGoMqZhO3dsAugezaX+9xIL
   w==;
X-CSE-ConnectionGUID: uNW5VA8PQSi8Lv0EjIyYRQ==
X-CSE-MsgGUID: HilDjI2nRfubHI68cgtXGA==
X-IronPort-AV: E=McAfee;i="6800,10657,11776"; a="77790486"
X-IronPort-AV: E=Sophos;i="6.23,215,1770624000"; 
   d="scan'208";a="77790486"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2026 09:25:06 -0700
X-CSE-ConnectionGUID: QyHlKlwvSEScAM6HDpwh/A==
X-CSE-MsgGUID: YaJBAr8BTFqsF6HDCMubqg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,215,1770624000"; 
   d="scan'208";a="259216733"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2026 09:25:06 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 4 May 2026 09:25:06 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 4 May 2026 09:25:06 -0700
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.13) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 4 May 2026 09:25:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LLWOIhHYelghNhF5I6uHdl3ym5k5YoeJ6AaimVbg1as+G3p/RLPNx39VMZuRn2hQ4hWmb6df7dPccFmD/Bc8ULCjxIvLp8LaBdF/caQm/ZzKxOCI2ljcpoKakfuUUjwiY9iO4KrTjYUi9SMCYLsEraPKZ6c7/GM6ubhS9qCLgw1wtlcPLppiayz32CeKgqr3TFYkUDQHkL3A6oxlTB3Y5quSB8FGqcddy/qYJ3FTZh5k7WKIsR2HIwPE7Q3gcPqHsiDY3sQ+5aTV2vKbGgJ7IiA/a16XiVNOzzmJlqqYsLDO9zXYvpsc0Emobk7vR35TbVGdxWYDNRTGOykxWF+ZlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bxondPZtkFX6VfDgACapd5j+qTSL9S1HtuWvmE7k8uE=;
 b=dEv5hRdDlnp8LiZkn11riukgtQrJULFFYDf0CFdA8asd8MR7Lv3Jnc3HdFrblvxY4wNoeJNIXyN1rBi+rKDR8jaAlyXC9nULBkyQjtGGoqmWqJ0eEKNPrWxSU6zC1ESmufwmEdMjbKo6AWT15HB+5KU/1tn21Kd1fajuUTb6Y6LYUohkxSs0HaS2966qxlSeVUZOgzSM5N1E/QI0xrsqCvndxPziXGaYHZ0hY6tRATbvo3shZHP5nV/pY4CaysPkXy52QIcHpHh3BGWrxFE/eHs26eTQr9E37m4iIX/gFs95+hM73cK9CswP6CZARiN+0qzenunqpqwzVmXNlu0nfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by SJ0PR11MB5135.namprd11.prod.outlook.com (2603:10b6:a03:2db::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.25; Mon, 4 May
 2026 16:25:02 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%7]) with mapi id 15.20.9870.023; Mon, 4 May 2026
 16:25:02 +0000
Date: Mon, 4 May 2026 09:25:00 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Borislav Petkov <bp@alien8.de>, <x86@kernel.org>, Fenghua Yu
	<fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH] fs/resctrl: Fix deadlock for errors during mount
Message-ID: <afjIXKwVpSAh5kAA@agluck-desk3>
References: <20260501185612.14442-1-tony.luck@intel.com>
 <1cdef1e9-e484-4929-be2a-793e42a49cca@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1cdef1e9-e484-4929-be2a-793e42a49cca@intel.com>
X-ClientProxiedBy: BYAPR01CA0048.prod.exchangelabs.com (2603:10b6:a03:94::25)
 To SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|SJ0PR11MB5135:EE_
X-MS-Office365-Filtering-Correlation-Id: e2f98029-84f1-4176-db52-08dea9f9b14e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: OE8Y1L7/gF1fPsqvqalE1QVvjzetR1d+FTHjWtx1IyuMnVOBlM4B6DBkuESm9WOTLH6yZp32dimTpLI8E/sZKgaR2qrj2P54LjgkyO377caL0ICgvSX5XY0uWKAqE9DWv2pm7mwqmFwZSnhMaIXNdejWS5YavpirQSqDgMrCHXiGq5ZNMIYNdlrcvce2OLf9oHAmthGD2u7/iZNjae7NaY9d3QGtT/nWKdTZzsE9gs2VxE3UTuV1VUawyWfTwioa8WJ0bqhLIYpDyQMQvstTNOKIOhfOC4q/gr4c6ExU0Kw7GmUHw2u2tUMjDj7rx0t3rApkRGZi5pDRWsUAMjg10TG8wfmewxhJx2fEQJFJ3WVQWhpvrxZLvausjiVKqsdc/nGrQml4WXZE9jlgUXevEjm24OJaJLsxPn7Lujoax6l05g3os4YzykWvOdSF1ecUwloPw7MTVjYMGubHFbDE9qxqUwFL94z87GSaqb5iXRHHgytrUNg/F715LI+8YFz+EUOpwfKgn6IDCGA99y7SbmaWc8Bn/gETfdXd6nGJeyC9+xu3Z4Qb67P+62bm33vP+91EVSi4eVxY7ORHvjtYhZKlVxcXlFspa1GrOKBmb4h/OecK71kIVgnIT550df+3QuvlJc3mYmRM/Qpn5haQQfqjMWmCZjbgl2Q5vA1OI/nEP5Z52eco9dKGzeIIu8I2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DgFmc1F3wYn652OvdFVDc1PpO8ouG2ukOnKbEZeTGHsSuJTMCuzU7ZNHNRMV?=
 =?us-ascii?Q?FUECzJdQpFfJKwkvPIDTjvwmgn87Oy98Ai+bPaQJxUnF8J6UTd3APlWXTR/s?=
 =?us-ascii?Q?unr4iVz5PTetXsAF7wn4OqXEwxDJp6NFCDxMy5W5aPTe5pfr4+ZcjzyzjIrA?=
 =?us-ascii?Q?j2eSmJFhecpN2NIPRtBTWjdcU6HN30BdaCkVL3DXrYNWjEpeVW/1SMp1obU3?=
 =?us-ascii?Q?Mp04Srwp2W1cmxluvpcNg+JmsLUFPdFcwbAYf7U6Tx6pDSc7I+LTPPcHuJ5W?=
 =?us-ascii?Q?d5kQ5NucbZ9od+siPDY/btMz73XO37bSGcjFN72J3YxxZRJdgTXvN9OUg5T4?=
 =?us-ascii?Q?vs0oalKB8L54ynJ5Tle8xRcKYVSH29Pfu7jomAfGlrTq+M0IiMWx8N2e0Cxc?=
 =?us-ascii?Q?wyTc1g77dO7vL/7GRE3V6+OJw1yNHPtJisBZpHxlVdefSutCt/wxDPnI7/Qq?=
 =?us-ascii?Q?1IiY6G6eG/ZP63kpM2nEtYnk/PtsaMBIj7LH73LB+VQe5s9Gi9Pd+IgJzKR+?=
 =?us-ascii?Q?FVkQNBxhx8RK5U5qZCx7S0ysOJc6xLGxmQt+GrKSQhn0KisVgzp2p/J1g0T0?=
 =?us-ascii?Q?Rwa5W0iwfVSNJ+NCdxaMqPiShtZUdBD86FkLGnfoWD+VamTSxD8unPnUCNg6?=
 =?us-ascii?Q?MyXHFb7DyJza5a0uie+mvYb45Jjls9M4gbrxe2HyiMf7zN49sjN+2EnTHzS7?=
 =?us-ascii?Q?MsP2RYKIO/sxiW7A05RU/6LRZMd3bIpzebPzqijWHolrNUCujXA0VMIRkSok?=
 =?us-ascii?Q?LRnLgmC4TqmjH6nsUQwSXaRkCf0C94wdAAHlIB4cDZRC4T4FOR8xuxWhBj1F?=
 =?us-ascii?Q?i+ZNNZHYwZWbrXhcZsi0TCVZMV4Kvnd/6C7HRdlC+WtMXo6uK3H7BKryguNd?=
 =?us-ascii?Q?mZICwg4ZdyMI8qxgsOJZjzQ8XdoxrXmw2HJvlZqO+kMEhniJ3WP7ILtKlLYC?=
 =?us-ascii?Q?vGbidNjVo/T4T08j3Wg+04csesNlBbdKW8JqbaFovs2Csv9Wakfcd04xWVPM?=
 =?us-ascii?Q?TbJ7+4DuVw+iHilf2Jfm1J/etlKy5xm9BSKrorhCoM+awVwEKyVx43wiAonx?=
 =?us-ascii?Q?Ky7fXJBcv0xj3Ow/ni3FAXYMOQGQIssaNlmMPTHtIU4VTCqdf7fWoS7qJBQE?=
 =?us-ascii?Q?xHMfzKtuDBCKPlxnKiyge9plMkvXW9gCOJuZQSsdjMeVxjw3hTOiwMMmbBRP?=
 =?us-ascii?Q?Qu1fo+UwuHeV0aQvKWucoZ3JEFDGWSzIppE+v2j83gewLNS9JwW7sO6ovhl8?=
 =?us-ascii?Q?skKtsB3ENioqoPVa7qljvVs0s2S5eWsDUDVl6YwZaBoafuji38QQDDmUAZHQ?=
 =?us-ascii?Q?PoJZ5dLla72nYWpFnRrmMpDy5Qs7vLxlA5Q4cJ81vHKC+ZOPtwMbvQUqXk1U?=
 =?us-ascii?Q?ChJZZhOcO5eUxmU9NFXx6BrmPy9NhGRRfVPYwL0bN36MzDk1rMGkSU7UKZrl?=
 =?us-ascii?Q?Xya+qhum8/b/ufl3IGZQ3Sppsjno67gtgw3Wp4Vi3gnbZO6CAKTP0hll/Jpq?=
 =?us-ascii?Q?M9ft8T5Pootamwuz929KCQXUXtzfc/WqLqazIQy98+5+hn7amuzQpXXgz+J1?=
 =?us-ascii?Q?T0QvwJbP7Lf40GffVjal8Kz5Yl27oR6hmB4bxsbqPMB4ylRZdNAkuOXojKIF?=
 =?us-ascii?Q?jurW3gaAT+ECP4/hZhgMX3S6NRdNe2X8lhDJcjPT8gSbMXlqcPwOCUvy3Daq?=
 =?us-ascii?Q?uXcN1Iq9/iKSqSYOYAU31sIe5fx9c+k5okPWzOp2AGne8/MYVa+p4ylU7+jE?=
 =?us-ascii?Q?Jan/bW6NzA=3D=3D?=
X-Exchange-RoutingPolicyChecked: Q9yqAn0tGQtQxXiJKexvMWRa9I27Ccwxz1W9qdwsMJhBAGv4fT7YYR8/B/NZ3SwXEHF+LCQER7SSJcaV0YGlrQVazYDvl1KaNcvBblCx8VBNgwjj9Ex0F7njLPCjOk1dHWmGt+jp6D9ikWOvIYGAjpgBq6qRVzOWBGKGB23HZ+ZHuMU+45FfugIaX5Z2xVqcZW6WwSqs4zSG7urFksJNLmS823pYIALOTF89HCYn3wGc0QVPTbwDljhhiNt9vP3Jt6Imi3N5b1DZj1fkL7x12kuz6FdVXfuZI47c4VedQEQVqopcIe7Xl9rkpm3Uo+qzamWJhzrwrMK0jdGS7PSPCg==
X-MS-Exchange-CrossTenant-Network-Message-Id: e2f98029-84f1-4176-db52-08dea9f9b14e
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2026 16:25:02.3141
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q5xhY5ZXKf5rJq6c4sAdyqK3/XOc2ZQTVyBCXnKZ+dqtUsvr0ssRhQYoKjjX9HShbWpuQyuOZPWQfJ/qpGn91Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5135
X-OriginatorOrg: intel.com

On Fri, May 01, 2026 at 04:17:18PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 5/1/26 11:56 AM, Tony Luck wrote:
> > Sashiko noticed[1] a deadlock in the resctrl mount code.
> > 
> > rdt_get_tree() acquires rdtgroup_mutex before calling kernfs_get_tree(). If
> > superblock setup fails inside kernfs_get_tree(), the VFS calls kill_sb on
> > the same thread before the call returns.  rdt_kill_sb() unconditionally
> > attempts to acquire rdtgroup_mutex and deadlock occurs.
> 
> Thank you for addressing this.
> 
> > 
> > Add a boolean rdt_kill_sb_locked flag. Set it for the duration of
> > kernfs_get_tree() and check in rdt_kill_sb() to determine if locks
> > are already held.
> > 
> 
> ...
> 
> > diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
> > index 5dfdaa6f9d8f..8544020ef420 100644
> > --- a/fs/resctrl/rdtgroup.c
> > +++ b/fs/resctrl/rdtgroup.c
> > @@ -2782,6 +2782,9 @@ static void schemata_list_destroy(void)
> >  	}
> >  }
> >  
> > +/* Protected by the serialized mount path (rdtgroup_mutex + resctrl_mounted). */
> 
> I interpret above to mean that every access to rdt_kill_sb_locked can be expected to
> be done with rdtgroup_mutex held ...

The comment could be much more descriptive about locking and limited use
case.

> > +static bool rdt_kill_sb_locked;
> > +
> >  static int rdt_get_tree(struct fs_context *fc)
> >  {
> >  	struct rdt_fs_context *ctx = rdt_fc2context(fc);
> > @@ -2855,7 +2858,9 @@ static int rdt_get_tree(struct fs_context *fc)
> >  	if (ret)
> >  		goto out_mondata;
> >  
> > +	rdt_kill_sb_locked = true;
> >  	ret = kernfs_get_tree(fc);
> > +	rdt_kill_sb_locked = false;
> >  	if (ret < 0)
> >  		goto out_psl;
> >  
> > @@ -3173,8 +3178,10 @@ static void rdt_kill_sb(struct super_block *sb)
> >  {
> >  	struct rdt_resource *r;
> >  
> > -	cpus_read_lock();
> > -	mutex_lock(&rdtgroup_mutex);
> > +	if (!rdt_kill_sb_locked) {
> > +		cpus_read_lock();
> > +		mutex_lock(&rdtgroup_mutex);
> 
> ... but here clearly rdt_kill_sb_locked can be accessed without rdtgroup_mutex held.

A much better name for this flag would be "resctrl_mount_in_progress". With
The header comment noting that it is set-and cleared inside
rdtgroup_mutex protected code, it is used only in rdt_kill_sb().
This specific use case seems safe as there are only call chains leading
to rdt_kill_sb():
	1) Error cleanup from failure of kernfs_fill_super() within the
	   call to kernfs_get_tree() [rdtgroup_mutex still held in this
	   case]
	2) From user call to unmount the filesystem. In which case
	   rdt_get_tree() must have completed successfully. Any new
	   calls are blocked from changing this flag by the early exit
	   based on resctrl_mounted.
> 
> It appears that while this change claims that rdt_kill_sb_locked is protected the
> implementation instead seems to actually be "this works for the scenarios cared
> about here" which I understand to be based on considerations of how the filesystem
> code interacts with resctrl callbacks _today_.
> 
> > +	}
> >  
> >  	rdt_disable_ctx();
> >  
> > @@ -3189,8 +3196,10 @@ static void rdt_kill_sb(struct super_block *sb)
> >  		resctrl_arch_disable_mon();
> >  	resctrl_mounted = false;
> >  	kernfs_kill_sb(sb);
> > -	mutex_unlock(&rdtgroup_mutex);
> > -	cpus_read_unlock();
> > +	if (!rdt_kill_sb_locked) {
> > +		mutex_unlock(&rdtgroup_mutex);
> > +		cpus_read_unlock();
> > +	}
> >  }
> >  
> >  static struct file_system_type rdt_fs_type = {
> 
> Did you or your AI assistant consider running kernfs_get_tree() without rdtgroup_mutex
> and CPU hotplug lock held? Consider, for example:

Not considered. Thanks for the suggestion ... But, see below.

> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
> index 36d21652616e..9ee6295d6521 100644
> --- a/fs/resctrl/rdtgroup.c
> +++ b/fs/resctrl/rdtgroup.c
> @@ -2892,10 +2892,6 @@ static int rdt_get_tree(struct fs_context *fc)
>  	if (ret)
>  		goto out_mondata;
>  
> -	ret = kernfs_get_tree(fc);
> -	if (ret < 0)
> -		goto out_psl;
> -
>  	if (resctrl_arch_alloc_capable())
>  		resctrl_arch_enable_alloc();
>  	if (resctrl_arch_mon_capable())
> @@ -2911,10 +2907,10 @@ static int rdt_get_tree(struct fs_context *fc)
>  						   RESCTRL_PICK_ANY_CPU);
>  	}
>  
> -	goto out;
> +	mutex_unlock(&rdtgroup_mutex);
> +	cpus_read_unlock();
> +	return kernfs_get_tree(fc);
>  
> -out_psl:
> -	rdt_pseudo_lock_release();
>  out_mondata:
>  	if (resctrl_arch_mon_capable())
>  		kernfs_remove(kn_mondata);
> 
> 
> This seems simpler by:
> * avoiding introduction of additional state (rdt_kill_sb_locked) with unclear protection,
> * avoiding double-cleanup on failure (rdt_kill_sb() called and then all rdt_get_tree()'s
>   failure path),
> * maintaining symmetry with rdt_kill_sb() by providing it the state it is
>   expected to be called with (i.e resctrl_mounted = true).

All these are excellent points in favor of this approach.
> 
> >From what I can tell it is safe to call kernfs_kill_sb() on failure of kernfs_get_tree(),
> but this needs to have been be considered as part of this submission anyway.

Looks OK to me too.

> Oh, maybe there is a new lock ordering issue with this that I am missing?

I can't see any lock issues.

But ... there is a problem. kernfs_get_tree() can fail for many reasons.
Only the specific case of failure in kernfs_get_super() makes the cleanup
call to rdt_kill_sb(). rdt_get_tree() has no way to tell from the error
code from kernfs_get_tree() whether cleanup has been done.

Plausibly I could do some surgery on the kernfs subsystem to make kernfs_get_tree()
take a second argument "bool *did_i_call_kill_sb". Only other user is
the cgroup code. So this might not be too invasive.

Or, I could fix up the comments to justify use of "resctrl_mount_in_progress"
Also fix up rdt_kill_sb() to look like this:

static void rdt_kill_sb(struct super_block *sb)
{
	if (resctrl_mount_in_progress) {
		resctrl_clean_up_failed_mount();
		return;
	}

	... existing unmount path code here ...
}

Or ... do you have some other suggestion?

> 
> Reinette

-Tony
