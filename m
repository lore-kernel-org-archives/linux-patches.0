Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BE1532572F
	for <patches@lists.linux.dev>; Thu, 14 May 2026 22:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778797406; cv=fail; b=Qpbpv6vTEyALq0KrKOs1K93iVqQE4Z0Xeuu9tpTqPLMUxgmFSWTHN/RC9eXuXG41ztognvsqI3s8hCvIhhSShy9CowpcQF+jY0qBAl8IJ6C31VHzUyZQtI3UZ4K0nh9ZjCRSKymd7nwMT+F7B+CLFne6ww0Y2x6+Y2bjgDBcbKM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778797406; c=relaxed/simple;
	bh=hYFEVH+majKxwHbDVgSTuDmXFL+StMmJgaSYP2HvX3Y=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=OjNtneBQfStlIojCYz8F//sYtEoKa97pQVKLbCn7FHIokT2iUzP02musfltlnOSAIBsXpg1+tlH0rq2CXyh/SHfP+8alINPr5Kn4cqbOQ3q0MwSSQABfVfBCvMPDZDGRdvNmabIiy9yADwW1h9ra0gk8soIw8zNPlPvHZMq/tHM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bR2hfVSe; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bR2hfVSe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778797403; x=1810333403;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=hYFEVH+majKxwHbDVgSTuDmXFL+StMmJgaSYP2HvX3Y=;
  b=bR2hfVSee6YLrdoyTH2VKuuZ1T94384xGgoAfpphA8J+5ufxheE06GQg
   GDbR7SaMSCUXlJBitZX+/OH1c6UWTAlnEAgbR1+SvKhnPNE+7Y3PhBAMe
   2zUGyMLaTwkSi/kGNGNl23wuAP5HdjvfxNutPVeOiRQ0CFLNuFTWEA5Ws
   dbw/FH48J6w1EHDib1IUgbkShNhkActS4jmiuir3fPaEMh1ccmSlmTre0
   rO0re+layNMtJrbdG57Vl1fPQ1w0MZIGoqgMuVXZ1+a8qfObLWznRFpgD
   VN4fT/6DYDDjuQFanHsgiAqqVlNmxTNX6R0V/ygE7yEmS3CSslJG/OSug
   g==;
X-CSE-ConnectionGUID: xXrBqSL/QSKFT8SQRJ+9+g==
X-CSE-MsgGUID: IZHqTS7yRgaJTb1zxkJSPQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11786"; a="79791298"
X-IronPort-AV: E=Sophos;i="6.23,235,1770624000"; 
   d="scan'208";a="79791298"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2026 15:23:23 -0700
X-CSE-ConnectionGUID: shceaY+VT+ue0/AnKebH8g==
X-CSE-MsgGUID: 7Ohjq2ulTwmPiFlGGX/sXA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,235,1770624000"; 
   d="scan'208";a="262033457"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2026 15:23:22 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 14 May 2026 15:23:21 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 14 May 2026 15:23:21 -0700
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.37) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 14 May 2026 15:23:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A9fqo+LIA/pTBwFTgS5A8Xd1Y4wtA70KGYlZTjZ0n9au3l9fibMRnxiNMIzPdN6qCorgGpXxa0d0TtxjH15bkeUsHBzpVTJAGdxdZ9kr4K6S3Jbh3u4+IUG7KMtByDf/F5YhyHM8LjZJFMN/s2xefTRi3xOw9UuwIT98Xqt9yyrCleQPdihh+hqxaivL3+91yBnaT8yqw2ue038Q11MqPwsunZDZ1AK/P1Zx1lvf2nCZ5Wxwftqt/uQCtMopFDoPasnGqP9jsP7sIC6zswR2zno6kvl2DhkLezs0M/P72oeBuD5Ji4Ywm8ExmospeWmqISvdp6Nz7nP4pBvpbUhZHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2se8Kl3NYxRFFitrQiFKUGy5nByGrg+V1RcfrtPUnFs=;
 b=l2mA9uNPz/oWgtZ73sJctpJpYFDbNRghWXwuUyWGOp/Xn61kqY7qqzvrwc4fG7DI0z0pnhlF8wMKW/MkvhYNKJAGPSIypc/s/Vt/if3Hx2xjhcK2653wH8NMJPYjEkNS40lbnNbsK87laIXiGMiLCQ9PxITZDwrXln6aAGRf5byarm3QAHLwsCmkM6SHbOlH+Dq52gUw6WtsuBkTSRQbYauA5cTxUTIjNFV6qtj+e8Sf8sn/JaosDNHRLBd1552XqehQPHoYFdudxe9433EvhbB8+6XQhGe3npRatSDqZvbPg/MIARADdlM0T8x36Ybtbe4qEaFDXZPLMZUCVZuQyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by PH8PR11MB9806.namprd11.prod.outlook.com (2603:10b6:510:3c2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.11; Thu, 14 May
 2026 22:23:13 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%7]) with mapi id 15.20.9913.009; Thu, 14 May 2026
 22:23:13 +0000
Date: Thu, 14 May 2026 15:23:11 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, Borislav Petkov <bp@alien8.de>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: Re: [RFC PATCH] fs/resctrl: Fix use-after-free during unmount
Message-ID: <agZLT1hIPrDIrN4C@agluck-desk3>
References: <20260513224044.17167-1-tony.luck@intel.com>
 <28f663b7-de8c-4d10-b750-edd8ab9bceb7@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <28f663b7-de8c-4d10-b750-edd8ab9bceb7@intel.com>
X-ClientProxiedBy: BYAPR05CA0050.namprd05.prod.outlook.com
 (2603:10b6:a03:74::27) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|PH8PR11MB9806:EE_
X-MS-Office365-Filtering-Correlation-Id: f0779ab0-c56f-4ab1-e813-08deb20762d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|4143699003|22082099003|18002099003|56012099003|11063799003|3023799003;
X-Microsoft-Antispam-Message-Info: KFmsYlGEbWIpYZSD97ochqxo6TzPiSHQZ8OMINlhbi9f9LKyVlSJgRtOxaiDfAdg4RPR+ST9kH2hdGXkbSVEacuzG8Uv6BZpyuZ3CvonJNbyQEV4MfDf1xHuaxxlaj1XMabeUHDNI2Syzo23GM5stfKwwGD0CWnPPwGwdBBcS2oRp56kSbe1jigKRRv2QZUgq0ymwOBcCYKAGTHLN5eWhSKPSJvCYZVSvwGWFyHyeDVjSgJUFl32M6g4NWsdFxpxSFezq00N1bZUVzSiE17M3FyugXsBg+auZebUnTs9yNbIP8r/kjWE/Tw3sLem16n6naRqINM1a5BgRvHCJm2VmUymn8g3BpV7eMOugV9OvNfLsOHin7Nu0yPlimuTpQUYsvzNwcfj3CiugBUlUWzcXzyqneQ+WSwIhNsNqoRbXmoCEU4KmrTFm8o8qbY0tF1xY8g8HPomt9eUTKQyX7IuJWdbFxkAdSX2aUMGqIxjLI8cZgNpK97UTK1PlbXiBVINr1uRLdinNv7lPRQgGxaFsNd7mnjZ2OBlUiv31BLegl7Rmrkr4jiEZvzSxQR3J8HAtVRpku+h0d9U2lGOtg7MdFCz/vXvNCNvQq0c5RGIyPsxuUeZsjg+84GpgLrPRAPUVuC3OdW0OgkraiM5qNA1tw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(4143699003)(22082099003)(18002099003)(56012099003)(11063799003)(3023799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iUP/G4M4HTxySw/idnrwdxygMj+8GGaZZo0xzULjRz6qbZeUjYKRE4K+oiT0?=
 =?us-ascii?Q?i1fQw8fauB/0aueZRKQlZh0ffuVKK6dGyrca8QDhTgVjRWkl9b7Um4dkmpVk?=
 =?us-ascii?Q?cbyDOQyWR9J8PrtsD/B4zsxBIeqGMCQK+e5q3lZds7DDU4fVEWVkK4tClZyP?=
 =?us-ascii?Q?D8OhCVjQ2HT5sXYpHfrNO8sQlpKPAvlLMQBAW1sZ1stHPPNo3o1kRx8lNKzd?=
 =?us-ascii?Q?xEZ5s9Z/PGUKXpDaPay5rg9uwVEbpgFZis1LubsSt3iViWqtLiksfVAC6PC7?=
 =?us-ascii?Q?2Fy9kMNUcaV7LTBtmEMUtZ/Y6eFfI6PFwrUFoKykLjNwzLZ30AthGDeLLDi6?=
 =?us-ascii?Q?RAXO6PgmTPZCyDatDlR8d0T9kjBxzdkJOPQYgLSYsctG15GOchGreHtJFYL/?=
 =?us-ascii?Q?VAb1+yKiZc4/SBuom4m8F3i7MAVUxTH9ADJ1rKQdL3wlMSQ0DAeE9wQ+b4a9?=
 =?us-ascii?Q?SHrjx4p4kFQZc+Jt1a55UHkz0G1jlR1U/7CmIcKJCxnxlgE0ZQ4FWFkhcRVJ?=
 =?us-ascii?Q?OjUZ3HMqkrlOc+F6GVIOZGeysC4L3f+zP0p3hlSJJqKjuxD0ooXV9uPxM3t7?=
 =?us-ascii?Q?HhnATQZwSEyMQIRHHIMBivEGUT8d0feH0htkOoCSapL2JL8NvZ6pl3DcCe29?=
 =?us-ascii?Q?pSM4w8YAoklNx9fShW8KLYqdB8igKTFUaYc1WcXbpOEMXT6JXmzpoPjYnBOK?=
 =?us-ascii?Q?LFKzUbcIGL5wnnP0ZGZgWSiWMz1nOzJ8uxoFR6Mq7w4UVcphwLFoNN11oQ2a?=
 =?us-ascii?Q?N36cReLKJASPtXZbNb6ij3yuAV3R2/rJWbNMVev3jU0bjvh1qvn2evjcnzD8?=
 =?us-ascii?Q?n4Xj11og/e35egq7XsmONBZB/M0fbQPWJ6xCb0K42KEX0Lz6m1ckH4xDKp3c?=
 =?us-ascii?Q?3v+WK9/bsZuZhpbR1WL6SvV78ERmKwWUNcs1MjFJM4TnoUQxx39yRfAKrwd/?=
 =?us-ascii?Q?40A0odPmPZYhWNLF8V3S2fAVE9S/nYclJxW/SmyF3eozqIBgGb+q7MZ6KjE6?=
 =?us-ascii?Q?XpKuYZesUJQhlk6wL2YL6rn2bbcNJFy07VyIb7nr3jubwTaqlN+xBNWw0A1D?=
 =?us-ascii?Q?Xyg4adNdfdMiXIj0JSsLoGgWzgeazkBpJ/qXXyYH+DN3hN0YOhDPHbgNTECY?=
 =?us-ascii?Q?bMzsyLlJSLRH0oUP+jywYZtCl205g5yZXlvgDwjh/kk+nL9to23GL8rARP2H?=
 =?us-ascii?Q?/ae/BioclInfeil3RXrnjGH9y6RFer+lTDMx9EoBOSv9gxrKwy4uxpkOd2+w?=
 =?us-ascii?Q?m6K90CH649fJN7iyFjvkPyWf8TEhy3EAfQi9QydrsrvB6IEio5j05mZO33Fw?=
 =?us-ascii?Q?ZviQeoL6V2+8tUyKZMd5jVxGXbSCacDexHWJvLXVP8UOSJEKnSspEn2fY8I2?=
 =?us-ascii?Q?Kk/nIDXazApBG8cjpTwUXN/ciZpUyIrNNfFizkMsWXNRqKISGRuADutRNRQ0?=
 =?us-ascii?Q?1AiPVngqwRAUCabsxh1J8uMcIoScYMmWhqs+xXW4PJLJF/caiL8MdylEyjF+?=
 =?us-ascii?Q?e3rlqQekoR8coVZn/fTLI8kT3oZmCKcarbCRC6Nw4thguJUuQH0I73RL7Jjv?=
 =?us-ascii?Q?6MfAfHz/vDBUEBzYkxYUWeDYPIiX6MTLiO4iiZQR6l0iYpoHqsxjvczYmWrP?=
 =?us-ascii?Q?BDcy5vEznVtuvN/HnnbqwxYg3Q2Zd4BWSa1UJNdE67vJ6Fi55WEpZIdHNvBV?=
 =?us-ascii?Q?0vMo2VgCU140IUw66saSSR5lnFUMRqNByBBBcRFAXenfQkXByP/riRlwOcKy?=
 =?us-ascii?Q?rw/bFqxdzg=3D=3D?=
X-Exchange-RoutingPolicyChecked: KdHoY2YLJpyXccdXttRJUwuQ0Ha+BmBpP7hHVikghmjxq5YASjqWqsmVAUe3K9hfqKV92/JcJ2t1nC/Jnxb+jl7or5V/I9nafvxxHtuk1QEtnM1D+M185KHiac4ga0EsyoAEXyhD4op24b7qNeZ1aZ493U/gs7/FnCVtpWRQWB9Be8dz8jdJuD2LfdwQ1OA/vI1weNa7B7qb4eybaa4x+Y1EodaoUZ208hphIt8ItHGTM1C6aZzzqAI/lDh/gU/nCxkb9xslVSiHl60AWm+Q+QljttbLvOnVyLqjmJ9fm86iewF+ErT77rE63RcYIfxkxTlxdy/92/AcCFS7QccSIA==
X-MS-Exchange-CrossTenant-Network-Message-Id: f0779ab0-c56f-4ab1-e813-08deb20762d6
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2026 22:23:13.0863
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3fUg6FEokHEyGEYgA9jn/WaIf5Y9IZUcJOSynSZUxnkMfTTHGsMTO/4f5ZsjmgkWNGTVF0L+ajj63GRj9JK8tw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB9806
X-OriginatorOrg: intel.com

On Thu, May 14, 2026 at 02:45:10PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 5/13/26 3:40 PM, Tony Luck wrote:
> > Sashiko reported[1] this issue:
> > 
> >   During unmount or failure teardown, resctrl_fs_teardown() calls
> >   mon_put_kn_priv() (which frees all mon_data structures) followed
> >   by rdtgroup_destroy_root() (which destroys kernfs nodes). However, the
> >   RDT_DELETED flag is never set for rdtgroup_default.
> > 
> >   If a concurrent reader (e.g., rdtgroup_mondata_show()) invokes
> >   rdtgroup_kn_lock_live(), it drops kernfs active protection and blocks on
> >   rdtgroup_mutex. resctrl_fs_teardown() (holding the mutex) proceeds to free
> >   the private data and destroy the nodes without waiting for the reader.
> > 
> >   When the mutex is released, the reader wakes up, observes that RDT_DELETED is
> >   not set for the default group, and dereferences the already-freed of->kn->priv
> >   pointer.
> > 
> > Set RDT_DELETED for the default group (if there are any tasks waiting).
> > 
> > Signed-off-by: Tony Luck <tony.luck@intel.com>
> > Link: https://sashiko.dev/#/patchset/20260508182143.14592-1-tony.luck%40intel.com?part=2 [1]
> > ---
> > 
> > Yet another side-quest from Sashiko. RFC for some human eyes before I
> > add to my series and post a new version;
> 
> sashiko also reviewed it and found a few issues that seem legitimate:
> https://sashiko.dev/#/patchset/20260513224044.17167-1-tony.luck%40intel.com
> 
> > 
> > 1) Is this real? It looks like it is to me.
> 
> Looks like it to me also.

Thanks for confirming.

> > 2) Is my fix reasonable?
> > 3) Better way to fix it?
> > 
> >  fs/resctrl/rdtgroup.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
> > index eac7e4f8574d..668ebe0b0ec6 100644
> > --- a/fs/resctrl/rdtgroup.c
> > +++ b/fs/resctrl/rdtgroup.c
> > @@ -594,7 +594,8 @@ static ssize_t rdtgroup_cpus_write(struct kernfs_open_file *of,
> >  static void rdtgroup_remove(struct rdtgroup *rdtgrp)
> >  {
> >  	kernfs_put(rdtgrp->kn);
> > -	kfree(rdtgrp);
> > +	if (rdtgrp != &rdtgroup_default)
> > +		kfree(rdtgrp);
> 
> Issue described by sashiko with new kernfs_put() is real here. rdtgroup_remove()
> was not called on default group before this change and it assumes that there is
> an additional reference that it can release here. See comment above the
> kernfs_get() found in mkdir_rdt_prepare, copied here for convenience:
> 
> 	/*                                                                      
> 	 * kernfs_remove() will drop the reference count on "kn" which          
> 	 * will free it. But we still need it to stick around for the           
> 	 * rdtgroup_kn_unlock(kn) call. Take one extra reference here,          
> 	 * which will be dropped by kernfs_put() in rdtgroup_remove().          
> 	 */                                               
> 
> We could aim to balance the references with a kernfs_get() during rdtgroup_setup_root()
> but then we need to take care to ensure rdtgroup_remove() is called on exit for
> the default group which may be confusing since it is not actually removed. How about
> instead just don't drop the reference that we do not have? What do you think of below?

This looks good. I can include a comment on why nothing needs to be done
for the default group.

> 	/* If doing below the function comments need to be updated */
> 	static void rdtgroup_remove(struct rdtgroup *rdtgrp)                            
> 	{                                                                               
> 		if (rdtgrp == &rdtgroup_default)                                        
> 			return;                                                         
> 		kernfs_put(rdtgrp->kn);                                                 
> 		kfree(rdtgrp);                                                          
> 	}                            
> 
> When considering the races with a concurrent mount mentioned by sashiko I wonder
> if resctrl should not also use waiters on default group to gate any new mounts.
> I was tempted to place such check in rdtgroup_setup_root() but it seems to bury
> something gating the mount so perhaps better at beginning of rdt_get_tree()?
> 
> What do you think of something like below?

Also good. Eliminates concerns about a new mount messing with things
pending from the previous mount.

> 	rdt_get_tree()
> 	{
> 		...
> 		if (resctrl_mounted) {
> 			ret = -EBUSY;
> 			goto out;
> 		}
> 	
> 		if (atomic_read(&rdtgroup_default.waitcount) != 0) {
> 			ret = -EBUSY;
> 			goto out;
> 		}
> 		...
> 	}
> 
> Another alternative to consider is to not call mon_put_kn_priv() on unmount but
> instead on resctrl_exit()? Thus treating it similar to the RMID LRU list.
> This may be more complicated in the long term since it needs more care to ensure
> needed state is still available a resctrl file reader that was blocked because of
> unmount or failure (via resctrl_exit()).

Pushing the resctrl_exit() is currently saying we don't care about the
leaked allocation (since resctrl_exit() is never called - actually
discarded). Cleaning up on unmount now means one less thing to do if we
ever make resctrl a loadable module.

> >  }
> >  
> >  static void _update_task_closid_rmid(void *task)
> > @@ -2965,6 +2966,8 @@ static void resctrl_fs_teardown(void)
> >  	mon_put_kn_priv();
> >  	rdt_pseudo_lock_release();
> >  	rdtgroup_default.mode = RDT_MODE_SHAREABLE;
> > +	if (atomic_read(&rdtgroup_default.waitcount) != 0)
> > +		rdtgroup_default.flags = RDT_DELETED;
> 
> sashiko found a race here ... looks like setting RDT_DELETED unconditionally would
> help.

Yes - as long as you are OK with the asymmetry between the default group
and regular groups. I think it is OK because there are already many
special cases for the default group.

> >  	closid_exit();
> >  	schemata_list_destroy();
> >  	rdtgroup_destroy_root();
> > @@ -4291,6 +4294,7 @@ static int rdtgroup_setup_root(struct rdt_fs_context *ctx)
> >  
> >  	ctx->kfc.root = rdt_root;
> >  	rdtgroup_default.kn = kernfs_root_to_node(rdt_root);
> > +	rdtgroup_default.flags = 0;
> >  
> >  	return 0;
> >  }
> 
> The "permanent lock leak" issue reported by sashiko is not clear to me. It claims:
> 	
> ---8<---
> 	In rdtgroup_mondata_show(), if rdtgroup_kn_lock_live() returns NULL, the
> 	error path jumps to the out label:
> 	    out:
> 	        if (rdtgrp)
> 	            rdtgroup_kn_unlock(of->kn);
> 	Because rdtgrp is NULL, the unlock is skipped, leaving the locks permanently
> 	held.
> ---8<---
> 
> Comparing the claim to actual code the snippet looks like a mismatch since
> rdtgroup_mondata_show() actually looks like:
> 	out:
> 		rdtgroup_kn_unlock(of->kn);

Yes. Looks like a problem in hallucinated code.

> Reinette

-Tony
