Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D038531B80D
	for <patches@lists.linux.dev>; Fri, 10 Apr 2026 18:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775847550; cv=fail; b=Y4HPAoge56edGad++FOjeZGcGZv7WbrjgyQpO7k1rouXsKQSJSPbpEJN1OzPjyEKGoUrDetwAPr1HQ7rAsJ66j6jWqkXmZ6rNvc/A3juFYgkkKEXGqUyx+YM+ygVlTe98CcfZsWcAQZuU+j4CmDav9SWBrvTGcxRzPMZS9OosL8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775847550; c=relaxed/simple;
	bh=3zzd0m0LliYhIOS458WW47C++oVKXd+XO5wA7wLwS80=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=K5bWO6G4q5YMbOui5lsP/XQJcXUkLDa9ohfTPRBFtX/NI/eGZKSVjc4Mk0vpF3vOuD+5x0n9h0Tvp938eQGQbXVOSm+nxR1eOvQ7yRSVV+dvNkaqEdik5XSBWthTUZoDlVP09Y5m4kW3Ea1ws2oaqesewunID3ecMNfGZM0/Y7g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hETm/Wwg; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hETm/Wwg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775847548; x=1807383548;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=3zzd0m0LliYhIOS458WW47C++oVKXd+XO5wA7wLwS80=;
  b=hETm/Wwg2eCdYl2gnv8lHz6R2pZTUdW9P3sZpbLukWQRZEqyuWK+0QQg
   eIiOwd5R9n/YkF4RLFNqIjvVoySN3DVltUudZ6ulvHvRtrVEnL/LWbL3o
   6ondmsWWxjgI6Qsfu6FdHUydqU8b0uLfEJx8jIg82qhGE7QkCIeC9kaqD
   3Yr393tUNvKfAaKf8Czeoi4eF/fU3mrAWcnGtxx3eTRUemsXf3qBIWAp6
   6bfJljWZen75HXGGVtAMY6M3dzUbjVtkrShNYvE5uonsKesjpIgSB0p44
   cLtWuqkNdplIsMv9NX31dQsy1GatgKHvQAw6OJ7r8ogYjXR0UwMxg0F74
   A==;
X-CSE-ConnectionGUID: pEbu+j5QS3GlWxRcbCo1LA==
X-CSE-MsgGUID: 8u8z/ZuBSr6+x2I9rhuEHw==
X-IronPort-AV: E=McAfee;i="6800,10657,11755"; a="76893403"
X-IronPort-AV: E=Sophos;i="6.23,172,1770624000"; 
   d="scan'208";a="76893403"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2026 11:59:07 -0700
X-CSE-ConnectionGUID: bCdNIFlLT7uFzDGcgGKTtA==
X-CSE-MsgGUID: BUkD7BLKTd6wyhFMoZBojg==
X-ExtLoop1: 1
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2026 11:59:06 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 10 Apr 2026 11:59:06 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 10 Apr 2026 11:59:06 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.44) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 10 Apr 2026 11:59:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VOPLrAODlqRNHKKX6NTyq7NgSAmexuWYG4JTVWQSeq4fn7qeZ+c0JVFJEl29aDgPMRwnJnQspPd9CpsfM1W+dfywPqghXz4IVFw/RF1sSCE8eYNFhjqDqKbGkpuvE+LpUgj/unWDjM7pH4e/05rDtXd8lukdtdgdZsQx7zFhqCFMBhYVgxyV/+UyqhGY2lo4eGiOs4W+qLXLRHCS0CVGY/s8voogwwdkqSkNux3yESpkMxfxjDCXjKsKL6S1QzzqMEJQ4ox7P3tb/Qhf/YejW26m53qifYNos0MJhsarzjprtmCNAY7BaCyjySxu4hlcus4fXQI7U2yawmsTRr8fxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EdncHTfM0C9gwg+vr7Q9jYf2baTs+4V/O75XJx8aePQ=;
 b=mRiLbBsYtBKNT4hklqy42Y1XSkqn3vocub/ySbx/K5+J9kAYIQRKutqkdH4bInKwai8IP7OWjx6x5IpM+/nkbZCtDBgwCTlyA81nSBD2pefhXi2lVKaRtCSDLIvHo6MJPoyLrYOAr5YMeLd2fsWPW5p+YiC57WDp6TcvIA01ihbZ4VmP5EEfoyC3DGqo7GU1rAsoInnGjX12YH5ejRPxaT+vh6shxudj58eMiuKbmen7qN6H8bDWvGlrQnY2BLPtPbcKHzStu6+8AM1PVGgdpWOYHodnYGZAyOgw7IAM1zw9JIN6FA1JRPIVSsTxHnGUSj56mKZbwX09Z6RBaP/wDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by DM6PR11MB4627.namprd11.prod.outlook.com (2603:10b6:5:2a2::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9791.34; Fri, 10 Apr
 2026 18:59:04 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%7]) with mapi id 15.20.9769.041; Fri, 10 Apr 2026
 18:59:03 +0000
Date: Fri, 10 Apr 2026 11:59:02 -0700
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
Message-ID: <adlIdusn61pKB3oq@agluck-desk3>
References: <20260330214322.96686-1-tony.luck@intel.com>
 <20260330214322.96686-5-tony.luck@intel.com>
 <45436044-202b-4d77-b552-2156be47a52d@intel.com>
 <adQY_m8I2jUiR88k@agluck-desk3>
 <e85cd466-2202-4b40-82ed-91e421d8e073@intel.com>
 <adgNfJSeHVyBXumt@agluck-desk3>
 <c948c358-1dcb-4896-9c0d-239e99d89e72@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <c948c358-1dcb-4896-9c0d-239e99d89e72@intel.com>
X-ClientProxiedBy: SJ2PR07CA0015.namprd07.prod.outlook.com
 (2603:10b6:a03:505::28) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|DM6PR11MB4627:EE_
X-MS-Office365-Filtering-Correlation-Id: 66127f79-aec2-42bf-b1d5-08de97333bda
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: VNJSIcQ4NPoyS6DpMqSm5D+8/sMtXuLFxBl7c1M6URPAq9UeVqqGb6L0HZl7sZLPO/5aVDzDkvgXvEFsCsfzcEYqoQYagw/uN2aW0tnKn88yOAjBelun8r6nouQzEtQ2WFbAl5lyXE2o/jqa7qYTqRaoVUa/aiekGkt6vkYdrw0uCEpSXIKGfi6oPAxaKiYtidZ0x6jiaRbOWuC2btRXoME7YehaNMr7ws9r2IQTNyVubCIjD8/nfLuLkGyQwhhQWncPaE4eKIaQ2tC1CM18KCDj/mh/cqKVSWTKX3kP6IGOEnZbqAV3xhQmhq3ZqVWucCholsoCIcOhNor0G7sWiNrKz89D8oTyfRgdeg42honNQuCP6muYjuhbBThg03QMscAdrel/vWtkX6kr2ASEUkNCOugUec0nJbax7phld8qDk7prP8lFDB/pbfSNNgCm4EqB7lIJok8SZSvDbBsz/diTF3Womef6T+WntCcGGCMBijW4c586P5RGlu+qrISmV2VrGYkdQd7kT3I+RCJncu38BxWrar4s8OsRIRYE00ErgfBzfzYcxV4OHMoj1Z7Op7PVfZT5OeON2/ZBVyXZfAbnOdOk8VoIBlnLow/Xu+4219bLNThCdZiKFRh4cxQRo2k+z+qIbNSdn/zFBkD6Jf+PfFaV9LD+34twt7clh2HqI+om8vwaLBX30iQuhB9BCIiqewNh0vWoszqFMzfc/D1PGUJhOp1uYhp4Mvj45OE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JRd/BO4zElvVPe3/n1blIkVfVjYp1wmbtoX/mNMdWBaniyV3xmBva/e2lA/p?=
 =?us-ascii?Q?AgMPSXsdfPoH8i1TAx6a4Jxb1Pe+f+Q3La3wPnWBot0ELOGDYl+nS/khrGRU?=
 =?us-ascii?Q?GeQnchEaAAaYoiHkQPB9ostida+4OFMC83iCk1Maj+rKNkZb0DJzOr7J3oO0?=
 =?us-ascii?Q?Nmq1xPRTjO4E7ix9Snwpg0mdFaqDQj6mH8vRGBpERzEQRchyWucE9l5c+tgB?=
 =?us-ascii?Q?H0JDdrDVyfBGIqt6Pnw0X9ueyEA+3AkQuA4FeOButH8/6zqEftffVdhOwahc?=
 =?us-ascii?Q?hBkAnLkMye4f06rrifHj1/Wj2mtuOhUBPkUiYvzwJqBjvfsF2XBmd6/PXz8k?=
 =?us-ascii?Q?Ghlb0i66mXtdaoeNpObMmhYZrOHZvWCvR0ELOsxWPQ+LhuP5Ggv2FaQBPojv?=
 =?us-ascii?Q?RIO1vqYLdiMBUMqV01e3LQucP0UsKisf/fmZAkNoWQ5YAkE8MdwZI7ODpTyg?=
 =?us-ascii?Q?H+IDttynD7JqT2Gl0mCoLZePkZzecGdAfQTDnovVsdp3mUBlAp1SKC+mWl7M?=
 =?us-ascii?Q?T8qIflhnAM6+JXU3Wy/ZttTz7gz+7Qg+4i4/FMg4/oZ3qEOj/3fA07t6GZSa?=
 =?us-ascii?Q?ogdrthhvjGXT4ka6Hd1ODEcqNP/Mu7ZPO8ErSkYnodGXbB5/JHbm/tL85dDB?=
 =?us-ascii?Q?1PkM5fIu5zziswBrU4QijPzSuxfSIBroZHo8HPzLbg3miuMgpwPDclq1bjQ2?=
 =?us-ascii?Q?3DMtAtEyoyp2BDSCMlgUe1+vlLwFQitX7A1q5F8aRbeZlKP7359HYAkwh5pQ?=
 =?us-ascii?Q?B2Nve/jeq0q1Wp0CJHApR/wtLknfXS9SwygyOvxCsjEjkzffIg7GhaOdPV1W?=
 =?us-ascii?Q?QglsJEPuea09d7412x3pYkhtzc3voQvIBgKpS9kmtdyfXL4e+8D48uMGzNjx?=
 =?us-ascii?Q?zK+RxiVFR9WF4w4sBIz+FsmhIuwLOdhfY7pMkJ+HhMMrhO1KDgFNtmIlISjZ?=
 =?us-ascii?Q?Q+hh6vcRVPIuwrpELYqroKHrf+Atim7qv5egaCrTpIUD7H0iNl3Em+p3qs3U?=
 =?us-ascii?Q?gDcQBL0FW3X06vxEgBsB1mFwQZjsojHmN/2q+F7WOXtZ8e84Z4zJp5KGuy+4?=
 =?us-ascii?Q?W4M6udeUAUkEIyu30u6ldv+l1/qjUB7KFsNo+qg1wGFoDTJNy1vKsiuz493w?=
 =?us-ascii?Q?LpanKuRRkhj5sJ0PE8+CeDy1NXh90Ct/gbdlLsa7yD3kcKLhaitBdglrYc5J?=
 =?us-ascii?Q?NRTPVS2s0nObbtohPjJP/rIu8pl2IRUKQJT/deTioQNgK36nT5lBR8Vxqz6c?=
 =?us-ascii?Q?VpAuXvjbupJ+kFAPI5eUkiZjptFfth5NUj5+nYSeWn86XHJrcjVzA1DX38wB?=
 =?us-ascii?Q?IbaRcg3Gd/f4kkLRvK2KK7P4fpiPN6jIAMkApOdeKfJPENDozfTBJHiKYV+L?=
 =?us-ascii?Q?RRR2axehDgpyrC4iHa1y380/A4r2/kTU2+gtlL3LFVwuWl2A94clFJMZywtq?=
 =?us-ascii?Q?w/7sB8+cg5rp7UFuEze70OORYInIUDt/y6AbIeRCJcs7717I1c12r9K/yDz0?=
 =?us-ascii?Q?NHhqPDYYxFPtxHGwTkUPLJZWvJZNb116/4K+r010YknXEYtkTgqxFd5k1T5K?=
 =?us-ascii?Q?5VewbJjBwCbYj7V92PxJb8RLtWlQ7wHsu23/CwXTAdX9FOfAkKB4+VxB19kZ?=
 =?us-ascii?Q?SV/NTEWWVhNuEmUXnCIn+Bea5VKPytAVQKCRu0MT05CDfqSb4HvqJvqY5gCl?=
 =?us-ascii?Q?wb5Tbu0bNEHbDYaeAfrhHNan/WYPnFrq8/PxWZdxAVvobxjf/rjSbiQhwEwK?=
 =?us-ascii?Q?D6M8401KKw=3D=3D?=
X-Exchange-RoutingPolicyChecked: SjO0ziAjfUt95IQZ0RhiQdgNPcZNUHqYzRnlcITd5BNuUSLgGhXvBWYWwUf6P/ZVbNCU18l/Q9oLOH0EKAa9JR1msINrzrnFty8IGj3zENRFMWlvmAFbfWzD7ds9Y3J6frC57Led/5MlgzbO2pgenWMCfETZFJXtsISZHnIvNBDhXAqKjXOo3nQTha5M9FRJvw0OXRGHDHLzVXG6oWgwZcLYhqg1sxNipCo0Uce/Kmbddst9+MyB3T3XvsapBn4+Xy7nhtjrmKpLi7r4DCVibfNaeM8XFUHN0Pzs3WlobKK63BXQ9OBGpYdl2rto9ziboAidvDMmKodSOVrwHhjz0Q==
X-MS-Exchange-CrossTenant-Network-Message-Id: 66127f79-aec2-42bf-b1d5-08de97333bda
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2026 18:59:03.8728
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xb98L0huEShSgi2B8xPrWr8yULjVbIyBdgeQt/FsjFj9QKsNNKBMONOO22iJ7NlNRywLDXXyAliciBw9IgdLZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4627
X-OriginatorOrg: intel.com

Hi Reinette,


On Fri, Apr 10, 2026 at 08:16:50AM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 4/9/26 1:35 PM, Luck, Tony wrote:
> > On Mon, Apr 06, 2026 at 02:16:46PM -0700, Reinette Chatre wrote:
> >> Hi Tony,
> >>
> >> On 4/6/26 1:35 PM, Luck, Tony wrote:
> >>> On Fri, Apr 03, 2026 at 05:52:30PM -0700, Reinette Chatre wrote:
> >>>> On 3/30/26 2:43 PM, Tony Luck wrote:
> 
> >>>>> @@ -2900,6 +2893,30 @@ static int rdt_get_tree(struct fs_context *fc)
> >>>>>  	return ret;
> >>>>>  }
> >>>>>  
> >>>>> +static int rdt_get_tree_wrapper(struct fs_context *fc)
> >>>>> +{
> >>>>> +	int ret;
> >>>>> +
> >>>>> +	mutex_lock(&resctrl_mount_lock);
> >>>>> +
> >>>>> +	/*
> >>>>> +	 * resctrl file system can only be mounted once.
> >>>>> +	 */
> >>>>> +	if (resctrl_mounted) {
> >>>>> +		mutex_unlock(&resctrl_mount_lock);
> >>>>> +		return -EBUSY;
> >>>>> +	}
> >>>>> +
> >>>>
> >>>> This does not look right. Here too is resctrl_mounted accessed without rdtgroup_mutex
> >>>> held. This change implies that resctrl_mounted is now protected by resctrl_mount_lock
> >>>> but resctrl is not changed to respect this throughout resulting in unsafe access of
> >>>> resctrl_mounted.
> >>>>
> >>>> Does this new resctrl_mount_lock need to be in resctrl fs? It really seems as though the
> >>>> needed synchronization belongs in the architecture. Could this instead be accomplished
> >>>> with a private mutex within the AET code?
> >>>
> >>> If you dig in lore for the v3 of this patch, you'll see I had the mutex in the
> >>> AET code. But there were some complications.
> >>>
> >>> 1) Need to acquire in intel_aet_pre_mount() and release in intel_aet_mount_result()
> >>> which is legal, but makes code more complex when call chains need to be compared to
> >>> check that the mutex is being released correctly.
> >>
> >> Why was it needed to hold mutex for so long? I cannot find explanation here or in changelog
> >> of v3. I did not remember correctly and considered the AET code to be doing the domain
> >> addition. Even so, I do think a mutex internal to the arch code can be used to manage
> >> the synchronization. Could you please elaborate why this cannot be done?
> > 
> > I tried to move the locks into architecture code. But main problem is still
> > handling when a user tries to mount an already mounted resctrl file system
> > and gets -EBUSY.
> > 
> > In that case file system calls resctrl_arch_pre_mount() with the file system
> > mounted. You suggested that the AET code could detect and ignore a repeat
> > enumeration by noting that the event_group "(*peg)->pfg" is non-NULL, set by
> 
> It would be great if resctrl only needs to enumerate once but I do not see how that
> is possible since there is no clear indication from PMT driver whether (all) its 
> data is ready or not.

That was the root problem. But allowing INTEL_PMT_TELEMETRY to be a
module adds the additional constraint that the module cannot be unloaded
while resctrl is mounted. If that happens, the mappings to the MMIO
space disappear. The existing intel_pmt_get_regions_by_feature() and
intel_pmt_put_feature_group() do not do module_{get,put}() to prevent
that. New series under development addresses this.

> > the original enumeration. But that fails in this scenario:
> > 
> > 	# rmmod pmt_telemetry
> > 	# mount -t resctrl resctrl /sys/fs/resctrl
> > 		... succeeds, but without AET present
> > 	# modprobe pmt_telemetry
> > 	# mount -t resctrl resctrl /sys/fs/resctrl
> > 		... enumeration success, but now calls resctrl_enable_mon_event()
> > 		... with the file system mounted
> 
> Thank you for catching this.
> 
> > 
> > I think the bast solution for this is to change definition of resctrl_arch_pre_mount()
> > from "called on every mount attempt" to "called only when resctrl is NOT mounted".
> > This is because architecture code cannot tell whether the file system is mounted.
> 
> Does this mean the addition of the extra locking in resctrl fs? I am not comfortable with
> that asymmetrical locking.

Conceptually the change here is from "architecture must do all
enumeration before file system code starts" to "architecture is allowed
to make changes when the file system is not mounted".

There are currently several limits to what is safe to do because file
system only does a partial cleanup on unmount. But general development
direction has been to move initialization code into mount path. For AET
things need minimal tweaks today. For some future feature more
refactoring from "init" to "mount" might be needed.

> I think a problem here is that resctrl_enable_mon_event() gives the architecture code the
> capability of manipulating internal resctrl fs state directly. This is a consequence
> of the original design before the arch/fs split. I see the additional resctrl fs locking
> as an attempt to make it easier for the arch to manipulate fs state but I do not think we
> should go in that direction, instead I think it is better to improve the arch/fs boundaries
> here.
> 
> To that end, what if resctrl uses its familiar "capable" vs "enable" separation here?
> That is, the architecture informs resctrl fs whether it is *capable* of a feature and
> resctrl fs, based on interactions with user space, determines whether the feature is
> *enabled*?

For the AET features user space could look at /sys/class/intel_pmt/*/guid to see
which events could be upgraded from "capable" to "enabled". But how can that
be conveyed to "resctrl fs"? Adding more mount options would seem to be
the only choice. Config files under "info/" are only available after
mount. But by then domains have been created and the top level mon_data
directory populated.

This also runs into problems if INTEL_PMT_TELEMETRY is unloaded between
telling the file system that some set of events are "capable" and the
file system asking to enable them.

> For a simpler addition resctrl could obtain a new helper, for example,
> resctrl_capable_mon_event() that only marks an event as "capable". resctrl_enable_mon_event()
> could remain as the "early" call that marks events as capable
> and enabled but may be deprecated. Both of these *have* to be called before any domains
> are created since per-domain state would now depend on whether the system is "capable"
> of an event or not. resctrl fs can assume that all "capable" events needs to be enabled
> and it can mark them so at the beginning of each mount, resctrl will only expose
> "enabled" events.
> 
> There are likely some simplifications on top of current implementation to not make
> this too invasive.
> 
> What do you think?

I think it opens a new can of worms. Maybe the most challenging is for
the file system to add a "hold" to the INTEL_PMT_TELEMETRY module when
enabling an event.

> 
> >>> 2) The "only mounted once" case meant extra state (AET_PRESENT, which you note
> >>> in next patch may be redundant) because intel_aet_pre_mount() is called, but
> >>> needs to do nothing.
> >>
> >> Right, I do not see need for extra state. In fact, since it is not clear to me that
> >> PMT enumeration will be complete when intel_pmt_get_regions_by_feature() is called it
> >> seemed worthwhile to only rely on event_group::pfg - if PMT enumeration was not complete
> >> during mount N it may be complete on mount N+1? This creates a poor user interface
> >> though since user would need an alternate way to know if AET is supported and then
> >> a "remount until it works" approach.
> > 
> > The race remains, and is lost if resctrl is auto-mounted at boot from /etc/fstab.
> > 
> > The user can tell if AET is supported with:
> > 
> > 	$ grep ^ /sys/class/intel_pmt/*/guid
> > 
> > and checking if any of the RMID based event guids are present on the system.
> > 
> > Delta T for the race is small enough that delaying the mount to some other
> > startup script should be sufficient. Users are likely to have such a script
> > to create the CTRL_MON directories and configure schemata for their workload.
> > So annoying, but easily solved.
> 
> I do not have a clear understanding of how the new implementation with registration
> function will look to understand the races involved.

I think I'm ready with v5 of the series. I can post (as "RFC") so you
can see, and comment, on the details.

> >>> Adding resctrl_mount_lock to the file system code made things simpler. The
> >>
> >> Adding complications to resctrl fs to make things simpler for x86?
> > 
> > I believe it is necessary, since architecture cannot tell if the file system
> > is mounted.
> > 
> >>> pre-mount code can't be called with rdtgroup_mutex held because it needs to
> >>> build the domains. That needs cpus_read_lock() + mutex_lock(&domain_list_lock);
> >>
> >> ack. Can an arch-specific mutex be used instead?
> > 
> > See above.
> > 
> >>> I need to add more comments on locking. resctrl_mounted is only modified when both
> >>> resctrl_mount_lock AND rdtgroup_mutex are held. I believe that makes it safe to
> >>> read the value of resctrl_mounted with just rdtgroup_mutex held.
> >>
> >> ...but not to read it with only resctrl_mount_lock held as in snippet above.
> > 
> > Holding either of resctrl_mount_lock or rdtgroup_mutex makes it safe to
> > read the value of resctrl_mounted as it can only be modified when both
> > mutexes are held.
> 
> I am concerned about this approach due to it not being symmetrical and how resctrl fs
> now adds additional locking to accommodate drivers.

I'm not sure I see the asymmetry. File system code already calls architecture
code with some set of locks held. This just adds a new lock (at the top of
the locking hierarchy) that is held across calls to resctrl_arch_pre_mount()
and resctrl_arch_unmount().

> 
> Reinette
> 

-Tony
