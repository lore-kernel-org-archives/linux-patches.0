Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D7BD225A38
	for <patches@lists.linux.dev>; Fri, 10 Jul 2026 21:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783717307; cv=fail; b=BAwsePOMmoQIZV1uDSZt5zcIHJ1SYVxbZiASzPaElV+T9Vmviuy7PkfRFtbhOBwqBqOrjeQKiSNE00RdGeYDVuEOAv1epT1vY3CUuhzNsBmiWywf7W3sSl5vjAztwguXdwTNBJ6shF/Qz+xXYbO1DEnSBeXMxkubuAjQvQYmJwU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783717307; c=relaxed/simple;
	bh=4nYV5RzY8cnJjpXZH4ifopEJh2fYEX15jnLHt86GnG8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=mVoOk2PJXX7CNK1FJ84JQAyNv120m0HQo0u0CYYKfQ/XgcVvbV4m6uoTzsQfDMsb5iG70ybBJ0sMi5j+n3OCaxi2Lr6jBFB3mtMXCwBW+NzaQiJwIWO/Yv+q5Rcfa8rTIrK9Nb+kGWcKidDHpAXjCEm8hD7mKGbtRNv8cxDzY7w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YO5YocdO; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YO5YocdO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783717306; x=1815253306;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=4nYV5RzY8cnJjpXZH4ifopEJh2fYEX15jnLHt86GnG8=;
  b=YO5YocdOUj4QbPAQ/wZGhtnhxLpoz2oBO5a1m44M1c9YIJCQLjYjIQm5
   nV5RDVuWreeuy6yaJbilhFYMcr8v3GKNQbf+woA/bR4cO/w3DduuKCmcU
   PSUxoiyWLjRfbjtJ1oxVt9HBw41j3Z/RQlXhVRtoRdCAjOWjC/sljX6gW
   +wqScvOePx5W1legYQBoWV0793YtJwbMR/jx1xmdnIsrfh6LFCzIyyjK3
   Eb7N2/EOHtVqbchYdnFynL8jaEI7mfJKFXB7Mbig82BCFtt2EeZ2Xq+7S
   SzrZX6CqXcj3MkVTJEw29vJmlO34WFVQd3dJ3tMw8JjgJ4nP1o5/3ehm8
   w==;
X-CSE-ConnectionGUID: SO1GoqPhRbCJJXM8D/i6AQ==
X-CSE-MsgGUID: 7TsB3hu0QG+MB0dD6usVpg==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="84298033"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="84298033"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2026 14:01:46 -0700
X-CSE-ConnectionGUID: DahubQLiQJmojQupCibcOw==
X-CSE-MsgGUID: b3nq3r/qSPexE1zK8smMlQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="254484330"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2026 14:01:45 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 10 Jul 2026 14:01:44 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Fri, 10 Jul 2026 14:01:44 -0700
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.60) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 10 Jul 2026 14:01:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E71gHJ3Y2BlHLq72bDbVWtT/XMQVJRasdibANhIh8wcrXTGivHRsU0v2LjGIybnTBj5OjOCZycWT6ENG8KiELtx/lC3oPjkhH7UVQyI0uh1AhmxmsF/UyZCliUmr1+Wu6HClwQsjAZ0Sjg26ICBaUaFyuWr0cyu8Ji6OrFlODDVKfEJ0YsLImHfRC4qlTbTBU2vCxJxg+rdynMrbpEkLtO+RW9qyOiOUWaN6NHu7KkKiFW7DyBE229dYAbuYaaclH7MUymCX0MS8L7SoiI/kvUxqkWrdSY21IqqzrwUkOvN8h6H9xwRpDxHRiTN5IFnxxSv2ExeAnS3hZNcBqC1PqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wgJAZmrDQ8+KmZ8kUMERFQwIPfWLSVucvydp9SmUpW0=;
 b=LXk8KlXfZuBmAiDptbGtJAwc+xfnJiNVemB+fODKruecHtRKGq650QPwSQfQqdsGDBm7ZY+AFXigi3QwEZPDK894rESPG7UTFcvivJwH1Mhh2YAgOoAwIYnztC85+IT/cXiUceOq1cBihaJSCBi5PMayZjdve7KsvXP2tEdt+dHkLaqHBZXSzw7GQDB7S68LPyRrenCHRFNlIZhkpzyE1VpFMspeEHo2zS++VAh0kshHun7suh4YQHvHPf/Isu14wmD11L1P8Yh9pj3t+qD9ptumMajIgiecKMxIEFwTOCg2Ys0SNxA5JyqtAPNIyNhxQ6Hj7GdDPHhROMC+/c+aLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by MN2PR11MB4709.namprd11.prod.outlook.com (2603:10b6:208:267::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.18; Fri, 10 Jul
 2026 21:01:40 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%4]) with mapi id 15.21.0181.014; Fri, 10 Jul 2026
 21:01:39 +0000
Date: Fri, 10 Jul 2026 14:01:38 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v9 10/12] fs/resctrl: Call architecture hooks for every
 mount/unmount
Message-ID: <alFdsm2qHWcstlSb@agluck-desk3>
References: <20260701213553.15222-1-tony.luck@intel.com>
 <20260701213553.15222-11-tony.luck@intel.com>
 <37274b66-13b7-4ced-9d79-e52d68a7ebae@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <37274b66-13b7-4ced-9d79-e52d68a7ebae@intel.com>
X-ClientProxiedBy: SJ0PR13CA0063.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::8) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|MN2PR11MB4709:EE_
X-MS-Office365-Filtering-Correlation-Id: 90f24d1c-2ebe-47c7-833d-08dedec66ff4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|23010399003|376014|22082099003|18002099003|11063799006|4143699003|56012099006|6133799003;
X-Microsoft-Antispam-Message-Info: 0j0h9dRuIDEi7BjbX9LGsaIPiAg6lrcU11bDUl6KjsKH2Q1kheQq05UbyWcOBqiQNf2HigtlI7+zDU0CPk2h4ngr7QnZs+k6/6oYwX/tkF7hf7UAWvobb2T9YBHLccCxdKEHhv4dciqsXUlgClQJar29tOx04f/IQgOo+L0KzQScwvoojHYS7LxYWUTNBWLqJT8kUf7f3QI31ZtYnncuF+LHf1YLr801lbo9txUaVIe70NJ940RCofNl/YCd1YVTD0FzEYpKowRiqoCeQCM+t0dAnb1cuKwV7NcEFbFSXliGWimWQvTfMJwqNhrVa3HRrKWTBQrzYXe+f/j6IObbKTGpGXjy+Fpn3otNAO900rs8BrWnKOov15DBMMLK7uIBfVQ5HrXwC3fZM2ffy8T7JijxIlk4pTpPjTLd90jGYCPQ6acPDNA9lHDlM6JrawiDOOIyr8iGOvuiDJujeKx8FXxMDsGLnz0na7zsH0608afkS3V43EMNvcYBQ/4bq+iHa6RZKPRiZ/fUE/mPn8R7bsMC27XJNczmdgtSyL2H87b4+u5ulAShpwX/fn0/jXBn6Uhkd21Yg9ItCdSxb1M+ZOrWDXO5UajARc1NsGb1crELrBpIdtwNr/b/tuuqRaIk2B1wkLobLC8xvkxg7zEx4mTUCVuLpLX9GP5hubA0McE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(23010399003)(376014)(22082099003)(18002099003)(11063799006)(4143699003)(56012099006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MsWGgVRwvemj2hg5RtamppQ18xc5AFqd3VO3SlxoL0wRLNKFA5ktz6Xj0o0N?=
 =?us-ascii?Q?oVUTNB4ie0kwfQp4B/+rCV5B3bBSecFxcijpObFsan4hRIJQpWWzlhXqT5qG?=
 =?us-ascii?Q?j9+L/doHfeoXv2ahxApdC2K4yoRyn+UiIY3YRXD6Ld5k96uw3Ow5LK+oc8gI?=
 =?us-ascii?Q?58ANUOu/5C3FTOxlgzBpWFp2vrZAojNldB70Mx9CdIYXbYsQkkA6p77R9eld?=
 =?us-ascii?Q?VLivr+NaRCWseUhsuXNbgVHdgVYbe60tYmxbpwReEHPAPTANlYsgM/J0nyT0?=
 =?us-ascii?Q?UotcK5r9yA/MDZQcoBy9aYJS3dEhipV26GAMWJ0lfsnXfc1Mz6OKAhI45O1N?=
 =?us-ascii?Q?WtFclJ9DJqYoqGUPitAFmzPzuC4RZqkWaPcDGW8C4cuRegxp3Pz2iHBd1WSM?=
 =?us-ascii?Q?V5ixA1UzivNdXp5THNRvqzOkABdzWC7b/tkWi5+6EP3CPosT907/y25sBRiE?=
 =?us-ascii?Q?fWDv0ZyJWtueFf/YboFDI5dXsEsP5KdFU62g57GW5ySbEPxDjc/mnLiAP1tP?=
 =?us-ascii?Q?23QqfQ1OEPlbrfNIUzfSmcXd/7HNJnEIiaRCyQZNcPTPIRbM3fWiQEESPkov?=
 =?us-ascii?Q?gRrqutblVjndEz9xGfTcfhmBuvNk+n6eRU1IOv56ByqmdO95ZvSlAiQxuJUG?=
 =?us-ascii?Q?Rnhfqz4HK6QKFOr9bP0FGJD2Pz18b5l+SgGJsVRYtJWJ3iZZoFqyfxtzj3Xd?=
 =?us-ascii?Q?eTJl10kUiFJCOAL1v5mgW1ORfm9GuRbzSPhnsbskMJ/S+CIi1NOasvzwacuB?=
 =?us-ascii?Q?JS8pdS+zqSIrgUdoQP9B8PeCUzULSEHrvPZ4e/TF6IR50s+xbcKm6ppUndyN?=
 =?us-ascii?Q?SGwknw+6hrIkgJ5B2Rgb1acEg1Kt9KTcS/59oA4X8RFevJR9rvsk23mrbuCz?=
 =?us-ascii?Q?1Bn4RU25XdykH99o5rhFSs16Ke7lJsiMcmMOfpTU9QcQoVZE19lWNrx377W7?=
 =?us-ascii?Q?gA27v5XzSgoRhb/CwBY2HRHnuAuFSYbS7Dcg+iOz2Ha+gi8sZQQvWEySNKoK?=
 =?us-ascii?Q?oaEHYKJ155Toh695mkQJSRYabUdqzhFoqX203gfWKXbBOPluZHJhQ8SR6v4k?=
 =?us-ascii?Q?wqd55fNG9H7fqqdHY8zrXQ944vSFa2w4h/WZKUadxumQ5AN91mFfxYejJqcn?=
 =?us-ascii?Q?eCDcbVZbW5MaLy1ZzMdLBMq04BodvKsImAE8owx7BJ0geKL9GlWqD3eoMmZ6?=
 =?us-ascii?Q?vhQ2YZJCxgsT6JrYJ2F3M9yMXNR56+4zsD2ksofgreWBgCMS46+yCZ3qHmCa?=
 =?us-ascii?Q?6+5nrY9TRcslpXAibQ2VXudVw9bXwPywUw5w34VS0jafaBJAaRuKcu+jeaiX?=
 =?us-ascii?Q?I41h9yNjFyJ66zeINgZM7H/nqEztVwapRqcGj681J71VgkJ1ht6zWgSdtf+c?=
 =?us-ascii?Q?EtqLjjEpVX8OGFtSdbmCY/gYptWF3mdPiyNmcKYsBzuZYQCvC+j1cmrpjUew?=
 =?us-ascii?Q?lIMzI6gBXHXnYhN6c1FySzYkszYpOvCPI0rTe4Sz2iQIB2ikAD087Zfc6nmG?=
 =?us-ascii?Q?lqPwPmw92gXSmvhvSJPs6dmBA7wAluIwnJ6nQeL/CxZgsAhRDKFzE/JHDVZY?=
 =?us-ascii?Q?9C+J2J4ntzf0ugdECaxRwbDjqJOzs9KjMq+ybo3PmyMi9qPeCAVVsXv7cmaU?=
 =?us-ascii?Q?bNYyFBKL1sN1MtNiA0ikooJx3SiIePwjBzmKeIZLildqTYLJWvQ/0yrgzPHq?=
 =?us-ascii?Q?nWMAOuKrwS6kpzMRCWCmDoGqH1igZ4uZwoppv216rBiokQKrlT27Ha8l+V20?=
 =?us-ascii?Q?FTvuRzggEQ=3D=3D?=
X-Exchange-RoutingPolicyChecked: qkk3WLqIcn9yGuNqhzubcZ+XwUCfKruSFeveIG917QCBkOfbYYbxwtbTcHFM7uxylykZDjycsOilHHNFO98ncUUfLfSJFSokGDJ15EAOIaNRyqAkKR6ANOKWNcd3snGXBNt7FxldDMfjhP7FXg/pJ4Sf0axfayd9Pp2lv90nqFSZFVmcBB3uvECW+Usec7s4CjPJJp1oA90oijs5ZCyahYn1rBxDcDBKu90JF7RXKd9tmyDi5pev57Pl4W/pnWsbLTwM6Pb3AqrYQ/PElq0XRgwbqFz4/sVJ/YQuysSZIbrlU4ZPzSuxOtMzJzFhZn2GilGgyTnAf3j4CaXpsouQDg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 90f24d1c-2ebe-47c7-833d-08dedec66ff4
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2026 21:01:39.8237
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +rLDsCLXGX4TxkHDfj+SDy+luWaAjxh+8RhI27yWWbnVP6ghuMD/WCDvRDClHz3Q6OHjODTJ0BOvlsDRyE3pnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4709
X-OriginatorOrg: intel.com

On Wed, Jul 08, 2026 at 03:53:20PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 7/1/26 2:35 PM, Tony Luck wrote:
> > The intel_pmt module should only be pinned while the resctrl file system
> > is mounted.
> > 
> > Add hooks for every mount/unmount of the resctrl file system so that
> > architecture code can increment the intel_pmt module reference count on
> > mount and decrement on unmount.
> > 
> > Signed-off-by: Tony Luck <tony.luck@intel.com>
> > ---
> 
> > @@ -3168,6 +3167,8 @@ static void resctrl_unmount(void)
> >  	resctrl_mounted = false;
> >  	mutex_unlock(&rdtgroup_mutex);
> >  	cpus_read_unlock();
> > +
> > +	resctrl_arch_unmount();
> >  }
> >  
> >  static int rdt_get_tree(struct fs_context *fc)
> > @@ -3179,7 +3180,7 @@ static int rdt_get_tree(struct fs_context *fc)
> >  	struct rdt_resource *r;
> >  	int ret;
> >  
> > -	DO_ONCE_SLEEPABLE(resctrl_arch_pre_mount);
> > +	resctrl_arch_pre_mount();
> >  
> >  	cpus_read_lock();
> >  	mutex_lock(&rdtgroup_mutex);
> > @@ -3318,6 +3319,9 @@ static int rdt_get_tree(struct fs_context *fc)
> >  out:
> >  	mutex_unlock(&rdtgroup_mutex);
> >  	cpus_read_unlock();
> > +
> > +	resctrl_arch_unmount();
> > +
> >  	return ret;
> >  }
> >  
> 
> rdt_get_tree() jumps to "out" if resctrl is already mounted - in this scenario
> resctrl fs is mounted and the telemetry events exposed to user space. Above would
> cause telemetry to be yanked from underneath an existing mount?

Correct. I think I just need to make intel_aet_unmount() return a "bool"
so that the early return when resctrl is mounted knows to skip tearing
down the domains etc.
> 
> Reinette

-Tony
