Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3DF92D0C92
	for <patches@lists.linux.dev>; Tue, 14 Jul 2026 17:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784051466; cv=fail; b=VO6/2Sn9GU2HfnEvp+su/M/0lZbOdHuImdBsdKvuPK/0ODSwruH6iqGQCz99EbWyEdBsnmWOr5Bzo9Wuc0m1SPOX6kSGmLLJU3dGWFBspoDEYxb+AJnhxKedZ8icrWRJeEkbJXqRBz79IcKCNjd1j4ZYdaJsQ2ChDQoCBKBG4Lk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784051466; c=relaxed/simple;
	bh=Xq+no+oaWyT+WYyuJgkri4C4E1k/UimNpXz/qRLGQPM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=fM90AWrfnK+Mv0r1kPaLPOr0OTFU3HBav4koTof21WvrsW7R5Ty3X8LTgL28f/BBhiI3LWAtRm7J3fecBbQXH29xjNoYjohKOoUoplYTMhJMZeDUBDrqFzaSxwStdSUDAroEGnYbvwVyVkGMWYKFwMnta5a1lq+Irvc4xLZWT6Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=O9mdOTfi; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O9mdOTfi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784051461; x=1815587461;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Xq+no+oaWyT+WYyuJgkri4C4E1k/UimNpXz/qRLGQPM=;
  b=O9mdOTfi2fRBKAAmE2M2TqiJQjMSkR/+dY9JZbw+BvWwciKsZ0+cCzyv
   YaCID5+SDM1V4NFk26b4sCFin/uyzMi2XvlRLpEXZSb6QqKsoTRIIeP+L
   VHD4yp/7GeVbjQGIn5Jz2g7FUEgcgTlE1NlkaQ2cT64cAiM7QFm96jiMQ
   JzPdAKLV1xvsTo5mpnDinHx7pGBGZJIGfYBAqsyNNZ2VV+Zgeir8rZyW6
   vsxY/eH3DE2QIY3ep/8g4H489w4eVUU8IAHXL7YNFUHXLR52lRXSmqwWx
   x+qspQVZ4uLCusCV01n0O4oCFTtc2yUlwFCP3SQlG09OOgZ7XcFqRw8pJ
   w==;
X-CSE-ConnectionGUID: dISdQVZ3S72BmD9aimGFfA==
X-CSE-MsgGUID: BzJ8BuaQRTq8EO9K6JEQxQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11847"; a="84725383"
X-IronPort-AV: E=Sophos;i="6.25,164,1779174000"; 
   d="scan'208";a="84725383"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 10:50:56 -0700
X-CSE-ConnectionGUID: Mj2hpWkPR2igAJvaf/8PpA==
X-CSE-MsgGUID: O4zKg34mSzqrmlnEezX7Ag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,164,1779174000"; 
   d="scan'208";a="255427426"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 10:50:56 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 14 Jul 2026 10:50:55 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Tue, 14 Jul 2026 10:50:55 -0700
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.37) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 14 Jul 2026 10:50:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K6EPKCHZ2gLnx8byLidoBGDzKmUL1cG0Tck1r93WyBsmrd1RZSMUAnBwWlkPNpiaaAEi8AMiIqLcrQEEdPeu6Eaid8HY7VoPU40WSogKNJCnw041FAaZrtAfSreeZMkvQiedghYZYXBEFGnfDtF0QFT5HTP6sH1y0F5EAxVFTlNldjvz0YHZqeP5dewFrSL63tycbsmrjEXGn1hobIWffLJwXM1MUH2qQWPEbzUI/LdW56kObNatV+6NxCJ9ANB2EmKj/VoAZMwg+z2WA+HSfeecXNM9ox3ig0JCwIuDiCfOoTWAa/IEqNJirYCk9S9FU97MN5jdfq32T8cbeZHufw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OydS7hO7Cl70cIsFLK4sIEfZZBrAo4BitfakOOuvfVE=;
 b=FfCv4CfzwgRgCZrbYLtjcQGnk8KCowttS331Kwk64cji/lVSybZ9trNW2HgS9PuUPhXC486AEijefQIZhHhStYm5fe+5YDTFEtEZSqYMpincyG9weeLH/QM73byFI4k/LUKhgSV2/yRux9tWgIg/tfU4Su7e+lMu/IXCnJKbkesQxlX1QeWE1PXioBGFf4yiwefmq3TocRyAxD2UX1UeWQZiMPJngBqBkrR9bFsjGe77KY2sn2ccj0StiIlb0F9LGGxFp0VdjZy1grBitVOVBnR3vAQ3pejE+gy53LiFayPJJnMVGDv2+AIBUcSPStOR7cjtqwEbWsTyCMDUcPb9ZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by CH2PR11MB8833.namprd11.prod.outlook.com (2603:10b6:610:282::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.10; Tue, 14 Jul
 2026 17:50:51 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%4]) with mapi id 15.21.0202.018; Tue, 14 Jul 2026
 17:50:51 +0000
Date: Tue, 14 Jul 2026 10:50:49 -0700
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
Message-ID: <alZ2-eJ3yXWHVelp@agluck-desk3>
References: <20260701213553.15222-1-tony.luck@intel.com>
 <20260701213553.15222-7-tony.luck@intel.com>
 <06cdd789-bf1b-415d-a588-b72938d3b0dc@intel.com>
 <alFbX0tItMg9CbB5@agluck-desk3>
 <e937d05b-8381-4d4e-bc36-7165a7214694@intel.com>
 <alZdWe-DACOtDwm0@agluck-desk3>
 <cbbf71f2-06a0-4833-a7b3-b8c6df440e93@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cbbf71f2-06a0-4833-a7b3-b8c6df440e93@intel.com>
X-ClientProxiedBy: SJ2PR07CA0012.namprd07.prod.outlook.com
 (2603:10b6:a03:505::13) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|CH2PR11MB8833:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a1ace45-4c89-4c4b-ba76-08dee1d071c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014|23010399003|18002099003|22082099003|5023799004|4143699003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info: zDRmxnYMl+zBqWSFftxUzJd1jFWBW3MbbtgAu4YUIb/U+sWSstVfa1lyP6ne2Oa98VBypz0gvz1NU2HHIE1QehGg4ZbIy1aVccZmPj8BlIoI2mMW5GOmq8Q+IooMM6LoMzjPbHOzwe9o55iYAHzEr9DKBKZnZ5v11Um1S+YE/U1AnWTn37kJ3g4Nw+EGmLQZhQ1pq/Se1jKeYk9M6oSplY2reMKznqb1nNFSJh1xR1Ppmq+U8eQey7kMfvKMbNKaAUhW/guWEUI0jM8g9voYRrBcef9XwMv6GPcwXbhM2PQsRDi5hHion9JlbZZB0/MUnZ6zFygdiEH0yFJJhQi9Zw336sFVAyC72mVCX3eHrpUijAKiXCJ9dfgRo0AdCrRkswU7wrg1zWvE39EzBQ7kv6cfOYKojSq+V58+rU/8m/tk6iri5QZJOqoKLTDFiIEhLhG5Tq2V+kFvRKIthPmio5780FD9Fe1mHg40yt7QrxALaEQFkz+DbbduMAzXUvczbKVrH7IXS38grh8/0N+ezS62RyPWxjfbWwKvNqlTx5M5qAois/Wngm08yt9v9CDEmDZENuFwpKvVoGjNNivraUXK96VMsrJhQ1JwBBUgKH3SgfYCCq68ddOGxDm7hgT9hDkxIawTWpE6gzg9UkWz1q1s+jJg5Ed/8PYsV49204k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014)(23010399003)(18002099003)(22082099003)(5023799004)(4143699003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8yY2vLbT0CY+5nvAXOAWnHglaVUQe4Q2sV08jjwHqos0bG0RWHgYCCWRVfmY?=
 =?us-ascii?Q?ejDrTrQp3SAIP2CAnN/i5SnC4ogLE0cojnVAY7k4elP7LK1dmFjEoNOPztBB?=
 =?us-ascii?Q?az/h8t6Hrx/g2uXHJXEPwHkjuU+4Y9fDEObEuEx+pTDMu/UWcRSlpBbsMD7C?=
 =?us-ascii?Q?3bgYV6/t2/L0oLJ/Nbd4SCOoo3gqg58m/8EOTb8J0wvHb98tSHZ+OIl+aiBq?=
 =?us-ascii?Q?XMVVEjwfbW2YEaRAqswbhf9gBEuKHEGOnDOUJm5es0hRYihfX2yNystc/jpv?=
 =?us-ascii?Q?eUB/QTtF8zmjQIt2i06slpf9wdk/ghP8EQeEYZGB3ikik2XNCfws5VtSYN8/?=
 =?us-ascii?Q?SB7nMaVpw2vg/C+RisfXAJy+SSR7PXa1x/WBDHj+U3Fg/9x48UP9iDDVcr0B?=
 =?us-ascii?Q?X1F9upSI7kuVZCDDbjZwWEmnNxcgez7vO7xgAE1kdYqS9DrFUvMgs9r68MOn?=
 =?us-ascii?Q?MQYS+EBvTr42zHtUDVMbBlKb/6jtY8ZrmsduLqBIlQVD3UacWA3wq46G3Dgb?=
 =?us-ascii?Q?4rPDEedEayNRqApSnSb3fnr24oVrmShLEPTjykrVncVnlQTxgSGTX5607olo?=
 =?us-ascii?Q?mW3wX6tkMOPfJ7gm9eSz0qtNU5G0g2cRNQXrkzG+sJX82bq2CTU8lf917fR1?=
 =?us-ascii?Q?2x7eJYdFChrobJdGziMHGrL9Or9ozMhVdPNr1jeyuO44Te5g8XAYnVqbupYI?=
 =?us-ascii?Q?vfSdzaoyMCCbP5pFTYjVXGJ5dPSbKEVL56lJsuDG9RdIhDgvV4RCVYI9eCFJ?=
 =?us-ascii?Q?TfYqdBKHkyEYvAQod0MStKi/h5HXcagLWkseo7Kayrpq4C8Ji7BNy04l2508?=
 =?us-ascii?Q?sG74AdOuxxzaIQ4IcgFbg57sS+dB1fANNlC8qdgzZA8RqmGIwid+JFDOTqTA?=
 =?us-ascii?Q?vq5srgoSzBxHmPDid/wCmX9/x64yRATKe6d+NDB253dnUtsqHQtg5NvxrSBX?=
 =?us-ascii?Q?j+GD1ynZEhsQFBQC8EbmrsuBfwLwXlROsvXASVApbmwvS2f4s65l+vYvHpAX?=
 =?us-ascii?Q?paNNHs4UerZwRU1ffmB9XCJTBQFFjf0ab4YtmNXvU2ywlfYa8gwhNJVk9+jT?=
 =?us-ascii?Q?TVGYDLHSinSaWpkIqxVe5nCStjJ+V4QAfy9aAJwZ9SRFYz4StSCfTrO1OlbY?=
 =?us-ascii?Q?iEGPkoHcWQVxD8JLZCIu4o0OxW6NOdN9UsPnC/0SDUiH6ErL+ptr1vslqkYj?=
 =?us-ascii?Q?MQVh8jlizB7hLWUNfXgXC+Zt5nRaKJ9ibySiybc74MiMB9n9PSaFxV6YEuaA?=
 =?us-ascii?Q?HZIMUUqpcMuVh3VWe/bPTtf1lXVcTjSN6liff3shBGYj0WwzZIInPpnS9joI?=
 =?us-ascii?Q?PIf1wZwSaJlhGP2T/AdqhLneOx5/ks5BBu8aHUy+CNRmiDHRDocgIWb63/jq?=
 =?us-ascii?Q?W1LLp5MpdYgeDsUZfnuFFp4V2W9dtzBlDGOvsYCj7AW1ULbA00TjWPMIHLgF?=
 =?us-ascii?Q?aJGBgjljkZPNSIoYUpsXfhjEzdwEg3yNLLXOkMw7McXjA9FjmIhUE/2Xjxnr?=
 =?us-ascii?Q?2x3psSId1VRKKZEV3Vsl0PwKtMEgK/hcwfBw/Ij5ISziiDMNBrQyQdz6tEcM?=
 =?us-ascii?Q?nauCJD4cycujuWKLSJVokRlcfhl+ZANrxtrOYPgJf6dJrYLvGcujO44b0eiO?=
 =?us-ascii?Q?P2RHl4leTmI/z5z9ZdQ9K7vWPK9X2/Ymzaojh1iVNGFis0WpFkeU/fOeJXaH?=
 =?us-ascii?Q?oaAVzWlDoGx5OfFSVXyJO5vWHJ6BW0pU6Mbt4A38Ay5VOu2OCWkFLyJBs2cc?=
 =?us-ascii?Q?470jiG4k9A=3D=3D?=
X-Exchange-RoutingPolicyChecked: aIx4YdrqjONzWJW9gHYDV2AaYcNIkhA4sMTXJlDksUsHO/wgFCzfJpxgkGwEcsogqDlJHqzGvr5+95Sl0NVnHmmanpRhfxHorGX4WXuKZR2CByrM+3etvPp1cd/vQlLzt094RpbGB2x0FAJ/LYWgL+NQB5Ie6pNXqwMe7O0gDoVWYTn4Rc/+s26tK9ZXGPYCHFdNGD7pN0FaGHF4xpfD6p2uReYeGT7YmaAOG0NEWx19d8Yo8NMlIdJvMJwxAuR6sC2B6qIT/4OIpZl9aqa76gKsyKekOIaFgj4qMu35y8TVj3lmw2PYbq6XBFRMy14T6KdzfrpQSFLIHH4lOOd8zA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a1ace45-4c89-4c4b-ba76-08dee1d071c2
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2026 17:50:51.3274
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bN+iItAOBrbyQhif3HEGcKM72ofqeVmLZL6zUgVVYeuEnpORZ2ksDZYXpxIFFwW8baX4x2hbnQwJDQEbpk43SA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR11MB8833
X-OriginatorOrg: intel.com

On Tue, Jul 14, 2026 at 09:45:04AM -0700, Reinette Chatre wrote:
> Hi Tony,

... trimming to open issue ...

> >> How much to rely on CPUID is not clear to me. The direction seems to
> >> be to move away from CPUID, which makes adding new CPUID dependencies
> >> less ideal? 

Where is this direction to move away from CPUID coming from?

> > Here's my current work-in-progress version:
> > 
> > u32 resctrl_arch_system_max_rmid_idx(void)
> > {
> > 	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
> > 	u32 ret;
> > 
> > 	/* CPUID provides maximum possible RMID value */
> > 	ret = cpuid_ebx(0xf) + 1;
> 
> There is also boot_cpu_data.x86_cache_max_rmid initialized in resctrl_cpu_detect() that
> could be used directly? Looks like resctrl_cpu_detect() already scales the number of
> RMID down if needed when L3 monitoring is supported, but it does not take SNC into account.

I looked at that, but rejected it because it isn't adjusted for SNC.

> 
> > 
> > 	/*
> > 	 * if system is capable of L3 monitoring the maximum RMID value may
> > 	 * be lower that system maximum. Either because the L3 monitoring
> > 	 * feature supports fewer RMIDs (CPUID(0xF, 0x1).ECX), or because SNC
> > 	 * (Sub-NUMA Cluster) is enabled and divides RMIDs per cluster.
> > 	 */
> > 	if (r->mon_capable)
> > 		ret = r->mon.num_rmid;
> > 
> > 	return ret;
> > }
> > 
> > CPUID seems unavoidable in the case that the platform doesn't support
> > (or has disabled the various L3 monitoring events). In that case using
> 
> Since L3 monitoring is the only CPUID supported monitoring resource I do not
> think cpuid_ebx(0xf) can be used if the platform does not support L3 monitoring.
> I expect that would mean that leaf 0x7 would indicate that monitoring is
> not supported which would make leaf 0xf invalid? Interestingly resctrl does
> not seem to consider X86_FEATURE_CQM from leaf 0x7 at all and just goes straight
> to leaf 0xf.

I disagree. The definition of IA32_PQR_ASSOC says:

1) The MSR exists if either of CPUID.07H.00H:EBX[12] or CPUID.07H.00H:EBX[15] is set
   (in this case bit 12 for monitoring, It does appear to be a bug that resctrl is
   not checking bit 12 before looking at leaf 0xF).

2) The supported width of the RMID field is Ceil(Log2 (CPUID.0FH.00H:EBX[31:0] +1))

So I believe that a theoretical system that supported AET (or some other
monitoring) but didn't support L3 monitoring, would have to set CPUID.07H.00H:EBX[12]
and provide the max RMID value in CPUID.0FH.00H:EBX[31:0].

For resctrl we have the practical case of booting with "rdt=!cmt,!mbmtotal,!mbmlocal"
to software disable all L3 monitoring.

-Tony
