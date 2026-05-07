Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D321B40DFA8
	for <patches@lists.linux.dev>; Thu,  7 May 2026 15:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778166753; cv=fail; b=mo7mg83fuEESafrAYZY+WQ8gWNfgnz9HK3dRWQMst+3kUYtxIdVVWXahnV9iTlcr+KBvyFBZpmGvVEjfRP9TnPeOEsoIDqsJW1MRjCF9VscBGPXy6SdgbxLumPetkSCSPG2mYgO8pzksevQ5LKT7RmX7vihmN1ONV9THToccoi4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778166753; c=relaxed/simple;
	bh=ejuhi7p+ge88Nz8Xb/NARrUJBOF5dPzn3SY3yFSrMJY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=WECgkiYtlV8/8yzdbvtALbH4UptY8jCF+n7GKdNLM+FnREWQzQPysNOW+musnzXlwh1w2wUSSJiRCo6J39iNMJlIvpE8p3t4m+zZ9aYAOT9KsgAdl5B+spcjONBlY/Y93ca+XyCc8SbWVTgqOncApt0/Ziud9KuQPQQclOw8LU4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lto+w2BN; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lto+w2BN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778166752; x=1809702752;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ejuhi7p+ge88Nz8Xb/NARrUJBOF5dPzn3SY3yFSrMJY=;
  b=lto+w2BNYBfxEOHo8Qgp6RuLiUT1b9U2PhpPj+G+7Ow/oB/baFqOHeU0
   iLUmTgg8qhk2dA/2mU44MYrEMo28zNKs1HmGQ+OnU1a+WKbcHN8pzitsV
   5pjDfu7MN2GGPtOKJwrNSSsx9yGhmD38b9ogifVqAwCozJeNKYqam2SHj
   yi3O7Rl3o7jX2GrTtf2OZuA9f0nb2OiIqnam4uiDJahWl3KXCqm5Rd8ix
   IDd4KOddd8FpvrIrWzLQYe1S3fdE7k1YKV+DIcmI8eVmRTq8RwynOG6kW
   9iSA8MfsR2lRz+irG6PQrF4VPXrlg3NrJy2L+j8cB86Nou7tDoNUWy6Py
   Q==;
X-CSE-ConnectionGUID: Lgaqy3m9RVST3H73WSZn8w==
X-CSE-MsgGUID: etlguewKTW2M5NiHOumk4w==
X-IronPort-AV: E=McAfee;i="6800,10657,11779"; a="104579273"
X-IronPort-AV: E=Sophos;i="6.23,221,1770624000"; 
   d="scan'208";a="104579273"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2026 08:12:27 -0700
X-CSE-ConnectionGUID: aBrJvRkrS9elZ0y2H0EhCQ==
X-CSE-MsgGUID: hANO31reR5CWnBkeGt6K6A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,221,1770624000"; 
   d="scan'208";a="235491490"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2026 08:12:27 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 7 May 2026 08:12:26 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 7 May 2026 08:12:26 -0700
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.22) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 7 May 2026 08:12:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BXkurxV+oz0ys3qdsbjzAkUVXjkZ0HOa8AomLT+QvfLrWFHwkoecSiwmk88zauCn7pJX2zJBGiABlNFLkXw8in1DAu5k3PWhXu/4HqX4fc6GYo+b4EhJzeMqmPjybApmmTwEHwCl64YlNVR4LGy5Mg/YzDk1xinQmU7Sk3D2CFptPaSeoIc0AHuPtvFTiAZD9p2z73x0FSL+THbt+gxQfZVTLbVSyTXYol8LFignwu+qVSRfB6P4N5e85IlRL842iSIOWDV730ZOQycr6I1r8Q2gVhz4HUKrxWWPNUeEz7oz+u92iH01nYHfYr4A33Gks42/eBlkpCl693N0PnbvMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wa0gfYRatv1WIFkJTg67p4epROVD26Vick9WMMrqrR0=;
 b=jsN9FSZfUQjA9nae+0VrUIm6xoXun3Ys7k/+grwJ2KQryXAUKuGXiqATv5dXt9tSAilmFKj42n82gFXbGLzPQ+1oOFSRlICpUqCxTnjBEqZ9fx+g1Uf441BDYuwMmn8DkWNhI6wl++ZhCRr8D104/A4lOFg6TSKtHXd/fKtrDU5hLU/Vn5hhUF2N01m6zhO59X7nx7iBuQWP6O8XgYMx/gLnWfXuEfF/p5jryxDFQuFJIBETFfYGAnOBGb5ggL9Zg3UC7v+48LdP/BJObG7T33fR0kGwd6XUpQhPreO4PcN8Yhm6G5GvLDGQJQTbiiHUiMC1a043Xkec7iAY78MqLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by DM4PR11MB5311.namprd11.prod.outlook.com (2603:10b6:5:392::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.16; Thu, 7 May
 2026 15:12:19 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%7]) with mapi id 15.20.9891.008; Thu, 7 May 2026
 15:12:19 +0000
Date: Thu, 7 May 2026 08:12:17 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Borislav Petkov <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
	"Fenghua Yu" <fenghuay@nvidia.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "Chen,
 Yu C" <yu.c.chen@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
Subject: Re: [PATCH] fs/resctrl: Fix use-after-free in
 resctrl_offline_mon_domain()
Message-ID: <afyr0ZjZvvw2lWTn@agluck-desk3>
References: <afoesuWB8RezVLrN@agluck-desk3>
 <7fad1d7d-c892-416e-b97a-a230fd43f2a4@intel.com>
 <afp4OkwtPpyIwAC1@agluck-desk3>
 <d065f7b7-daac-4e45-b7c9-69175dfb43a7@intel.com>
 <afubI4kYrdWUXGUR@agluck-desk3>
 <217d306e-78dd-4762-8c82-88d6bab9de44@intel.com>
 <SJ1PR11MB608334A68F7E79E6AF3C324FFC3F2@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <198e6dc2-b57e-4117-a71f-5c3983da3ed8@intel.com>
 <SJ1PR11MB608396D4D57AD6C1E079A4B7FC3F2@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <528caf7e-b548-4e80-9ec2-70697073a14d@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <528caf7e-b548-4e80-9ec2-70697073a14d@intel.com>
X-ClientProxiedBy: BY5PR20CA0018.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::31) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|DM4PR11MB5311:EE_
X-MS-Office365-Filtering-Correlation-Id: e1072b38-1fec-45ff-2e1f-08deac4b0817
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: QqwkMdeLaEJajSIW+3wLPXetZF+jraT4Apyq1l0TpNdgDgoL0SJQ6yJ5yyaRrV+puorycJSLzuTC+E9DxwZ12AjySlBZi0nqOelXIsyzeRQRq7wxiccUsKAHhApWFeBOYPAuao6SRSkWbMHMzstIkKlVZelzDO0VoSaz9MZfHAPZB1ZYJIouo1UUNrU3LwVGhiNoTMo8JCBUB8tFtFBJWCgibB8u75jA1Lj4h686Xum8y4tqw1b7ou8zUwFS2hFUN8uDYUrELlP/Y1QyvZAidSRtfKYFTTP/emfhGBVA5qY0vDBbGR1FhpQJnduYrmGRXdq6+iKMgrswVUMr13icbxjrVe1UCjwoDUYr1+CtgCPR/nFKs2SleikxbkyVtYrC0rhJoyJyr04nPC9kB2xMJGAJidbsv/1h9YexF30swwC7E4d5HcKRO1AusXGtZ4K8ihgegPSeurZZMjpc6K/Q19tY8iRNoQ0anVyEk8ojIaJwvDM4aoxt3tsdTBIK0Y+NLTjDlI2LKA0wlONEWxGsPJToL+6YVppJXluQCmwAdPuHU0JyszbqWAfX+XFno/TsyUmRG6i2Oxqyyk+r/U9RO57BSoyVXXFgiX03mBpQI02SQIEuygtrFXjct8XG54Ndr4aQb0nMHVkLWdnLZpDkhQuoFDID7ZX0mLCCFyYhFNf2dvdBTQpXkq/pFo+YmZO0oslAxqxjLLIfCOEZMmdRFA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZPxpZBB4zo3eFCRCgDqsfCTQaYjhGc1N4FrvJ1bsio08EXJ+dHkLdTefNIFf?=
 =?us-ascii?Q?whY65dSpjHh+LQ7gw2io4gqCwdqjtoLjJSL0VpbBiypYPbittyusepNi8Iq+?=
 =?us-ascii?Q?9PsKv1IoI6b8rsGdBESbSO3i2eHSxMyJTCKA7swIx43n/YcHd+O6EEGVAMJR?=
 =?us-ascii?Q?Gsv0rcIIcnnQGRupTsnTpp2ItYmoZBafexEzxtJy0ajkL4xMFYFDXrnzggNp?=
 =?us-ascii?Q?76y8vJsRjAbyzGfBwVs5yk23p2Kjh30VKf5lHfa7rtDpaReICPTU5b1L7VB7?=
 =?us-ascii?Q?1J/qU8xn4NOHO7rhr3NlNS/Te4pzqYlsPr4dKH7a+s/KbKBEIXFmlIzUf67Q?=
 =?us-ascii?Q?ozOsgCdTVVHy+UVHlZTnJPOUpoaPfzKbUrD0XBqkEfh5A7lGUJVtRuNLB5sd?=
 =?us-ascii?Q?RQbh6j3x4lIOCmhzs/LS7Q5/Tabjg5xWtiQRjYurVfsFjnijjws8qj4cTSh6?=
 =?us-ascii?Q?3sXGsVghvjKuswr8iPBMXaZ1ucQTOCVQuSNGB1CVwJjW076t+prIuA3xZ2Lh?=
 =?us-ascii?Q?xOyclUn7R+x0T0d49iJcEYxqsvPTIhQpGwCDaYzqLBeVqBtGzlgo35JmkszQ?=
 =?us-ascii?Q?q7okcM5qhHuas/2XdFya+ZjIsJJPOEgs83n0UdkqlUX79d4L3gI6BsSkqWkL?=
 =?us-ascii?Q?PGNJI/BVtdNvIhQW1Yt7jnkLzmEpjBpZNgmJyzPautgIZo9mc8WvR+14L9pP?=
 =?us-ascii?Q?gXIfMaQPnP3y96nbYyRGwKTHE5PYtzLKPtP6hn+v9nmWxTyXXnipXpbNC84M?=
 =?us-ascii?Q?CXxiQKk6GghK0Q0uluD0WPEPxd3nK4oXMdcnSD0oRJwX3y4JS+9nMFA4IM0Q?=
 =?us-ascii?Q?MBi1dKWizice08HvKKSzp53hrFhhgrb3FAYCSA16ainVFYiyFDqwCMm1PFGS?=
 =?us-ascii?Q?As6cohKx97VxH5rhcPrNx83JIFjPnqwqbmwhykL7A4GrUiqLL+gmP0H3NJlM?=
 =?us-ascii?Q?BLY2EVJnCf2pcL0Mv2tpegR8fXwbMdfwcMgT4faM3wpSFfo2NUwuvj93VZrw?=
 =?us-ascii?Q?Wt4mtC1fg1GgDSsut9sZMlCExKXrDfiZ9Kavpy+7Fnv5k///VbK5/CiKOiC6?=
 =?us-ascii?Q?38a82BUI4cCEWNGH7CaLFqZMjRcJUnuh58yiIUbw/1+utWyXnTddrzKLFfSF?=
 =?us-ascii?Q?9lP4VJ9oeTBJ/sWB6vM66nSlN5UvGGlpava0Har1pFooi4/PoFtJwV38Mmmv?=
 =?us-ascii?Q?v770mmrHlcrV8+EWfxjJsNGvNztlDvwZohlKl2nKof/+UYNdfGPcrIKJMq3x?=
 =?us-ascii?Q?iWC49JQsdLyOew6FUqaIAxyFpZndy+1Blt1wqx7YnOQvvsXrir758wT1SosN?=
 =?us-ascii?Q?2tGU7xVWbm6ty720ShdZ6ZDFNmQh+KIrnCvbIgX58c04MU9KSxjw8L5DNnCD?=
 =?us-ascii?Q?ODoK5rJQN/+oGsXkUZMDwdX1tdDAiDVsG0bkZTBjhsSk7ge+5w3+I+Tv7hho?=
 =?us-ascii?Q?Pf89fvV+cxvuiP9mmz2HCcY3jOcU8APRWG/bwdiCdiNY1KbnAJrrNjXZufQL?=
 =?us-ascii?Q?yLUJjrbKIdHP0X5zwb0cKTnyd1YW0+/iSsk6ZIiK3AWYtex+dkbYlNMRElJT?=
 =?us-ascii?Q?JJdXm9Y9AoJ56b6NoF/7a8k/RP1vSCeE5VXlmjFP4+6X1ZtGbRqIl8aAkFEl?=
 =?us-ascii?Q?tbvhoviekUeI6PfID+hm6SLOzJaG8q+sFRMsYSFvE00nd8F4Y3oRD70TmZut?=
 =?us-ascii?Q?KY/sHnWQN4w82d8WpuOpWWGNT85D1jQrrNEfAOLw7BIPgWCYiIrzZHqFsTzv?=
 =?us-ascii?Q?u+MTdyJliA=3D=3D?=
X-Exchange-RoutingPolicyChecked: pvgYGq2XpSPVwimkA+5bcRY4wBrPZdO3ZipB+Tpm5G5XcfXHGKSi2lhJqX5q+gSSXZ9Ib7mDwIDIOKSStZH7tFK6U8iY106se/e5CttKXromrWcy8Db/hTGDhQVk0M2o13qZzHLc61OsgciBwaT/HmXfC4R+Xqmml1dwir/hfqHV2NWcYe28w0VlkTUq9O2yXA6UCWOXU47c24vny661KIzDpAlN0D/w8xET9aTDb97AuFYBZ9r8prEtvNfoi48fT7mjQCofNYiNMIsLMheCfQJOO86cvoJogcKEave9h5jxqLBTKmPMpIr9rwFtVnX+eSSG7AoAUJxSAvkhaNA/YA==
X-MS-Exchange-CrossTenant-Network-Message-Id: e1072b38-1fec-45ff-2e1f-08deac4b0817
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2026 15:12:19.4373
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PqTP2Qc17a2/N4ZhMvePlzmUqAk5lYD3ZO2NDvz9WXCXejbOYg0ARlUjcFZ5AXi9WB730m6vDioAwm+f0nFmzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5311
X-OriginatorOrg: intel.com

On Wed, May 06, 2026 at 08:42:09PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 5/6/26 4:14 PM, Luck, Tony wrote:
> >>>> Unrelated to this question but may be worth a mention in the fix is that this work focuses
> >>>> and fixes resctrl to not access freed memory from the worker self. To complement this it may
> >>>> be worthwhile to highlight that it is safe for the work_struct self to be deleted while the
> >>>> work is running (but blocked on cpus_read_lock()) based on the following comment from
> >>>> kernel/workqueue.c:process_one_work():
> >>>> "It is permissible to free the struct work_struct from inside the function that is called
> >>>> from it ..."
> >>>
> >>> Scope increased from just the use-after-free when the domain was deleted. The case
> >>> for taking the current worker CPU offline doesn't involve a use-after-free. It just results
> >>> in running the workier on the wrong CPU for one iteration.
> >>>
> >>> Deleting the work_struct inside the called function is different from some agent deleting
> >>> the work_struct while the worker is running.
> >>
> >> Right. I interpret this to mean that judging the safety of work_struct removal should consider not
> >> only the workqueue API itself but also external agents that may access the work_struct after its
> >> removal. The current fix addresses access to removed work_struct from within worker itself while I
> >> interpret the workqueue API to guarantee that there will be no access to work_struct during or
> >> after worker execution. The fix under development thus makes it possible to safely remove the
> >> domain even if a worker belonging to it is executing and blocked on cpus_read_lock(). Do you
> >> see any remaining issues here?
> > 
> > OK. I'll add something to the commit message.
> > 
> > I asked my original AI about this fix. It claimed to find problems relating to kernel using the work_struct
> > after return from the function. Pasting in that comment you gave me from process_one_work() about
> > it being OK to free the work_struct made it reconsider and retract.
> > 
> > Another AI (using a copy of the sashiko rules) has found an issue with our reliance on is_percpu_thread()
> > 
> > The problem is the ordering of hotplug callbacks.
> > 
> > resctrl_arch_offline_cpu() runs early because it is in the CPUHP_AP_ONLINE_DYN class. AI claims
> > that cpus_write_lock() is released after running this, but before running workqueue_offline_cpu() in the
> > CPUHP_AP_WORKQUEUE_ONLINE class.
> > 
> > So our worker may obtain cpus_read_lock() and not yet lost its_percpu_thread() status.
> 
> Your message is not clear to me. Do you agree with AI here and thus claim that there remains an issue? 

I was suspicious about the AI claim, but I should have dug into this
before bothering you. Your analysis and tracing experiments below make
it clear that this AI hallucinated this issue.

> Are you suggesting that the original race explained in
> https://lore.kernel.org/lkml/afoesuWB8RezVLrN@agluck-desk3/ is not accurate? 
> 
> I am not able to see how CPU hotplug write lock is released in the middle of all the AP cleanup
> handlers. When looking at _cpu_down() I see:
> 
> 	_cpu_down()
> 	{
> 		...
> 		cpus_write_lock();
> 
> 		/*
> 		 * Run all the AP handlers on CPU going down - this includes
> 		 * everything > CPUHP_TEARDOWN_CPU that includes CPUHP_AP_WORKQUEUE_ONLINE
> 		 * and CPUHP_AP_ONLINE_DYN.
> 		 */
> 
> 		/* 
> 		 * Run rest of cleanups on other CPU
> 		 */
> 
> 		cpus_write_unlock();
> 	}
> 
> You claim that cpus_write_lock() is dropped in this flow.
> 
> To test this I enabled tracing and see the following when offlining CPU #38 running the
> overflow handler:
> 
> offline triggered on CPU#1 and it takes CPU hotplug write lock
>   1)               |  _cpu_down() {
>   1)               |    percpu_down_write() {  <<<<<<<<<<======== CPU hotplug write lock acquired here
>   1) # 9155.999 us |    }
>   1)               |  /* cpuhp_enter: cpu: 0038 target: 144 step: 236 (cpuhp_kick_ap_work) */
> 
> ...
> executing moves to CPU being offlined (#38) from where the different AP offline callbacks are called:
>  38)               |  cpuhp_thread_fun() {
>  38)               |  /* cpuhp_enter: cpu: 0038 target: 144 step: 235 (sched_cpu_deactivate) */
>  38)               |  /* cpuhp_exit:  cpu: 0038  state: 234 step: 235 ret: 0 */
>  38) * 20632.54 us |  }
>  38)               |  cpuhp_thread_fun() {
>  38)               |  /* cpuhp_enter: cpu: 0038 target: 144 step: 214 (rapl_cpu_down_prep [intel_rapl_msr]) */
>  38)               |  /* cpuhp_exit:  cpu: 0038  state: 213 step: 214 ret: 0 */
>  38)   3.171 us    |  }
>  38)               |  cpuhp_thread_fun() {
>  38)               |  /* cpuhp_enter: cpu: 0038 target: 144 step: 213 (pkg_thermal_cpu_offline [x86_pkg_temp_thermal]) */
>  38)               |  /* cpuhp_exit:  cpu: 0038  state: 212 step: 213 ret: 0 */
>  38)   2.378 us    |  }
> 
> ... this includes resctrl ...
>  38)               |  cpuhp_thread_fun() {
>  38)               |  /* cpuhp_enter: cpu: 0038 target: 144 step: 209 (resctrl_arch_offline_cpu) */
>  38)               |    resctrl_arch_offline_cpu() {
>  38)               |      resctrl_offline_cpu() {
>  38)               |        /* workqueue_queue_work: work struct=00000000ed014eff function=mbm_handle_overflow workqueue=events req_cpu=39 cpu=39 */
>  38) # 5920.866 us |      }
>  38) # 5927.396 us |    }
>  38)               |  /* cpuhp_exit:  cpu: 0038  state: 208 step: 209 ret: 0 */
>  38) # 5929.182 us |  }
> 
> ... and the workqueues ...
>  38)               |  cpuhp_thread_fun() {
>  38)               |  /* cpuhp_enter: cpu: 0038 target: 144 step: 187 (workqueue_offline_cpu) */
>  38)               |    workqueue_offline_cpu() {
>  38)   3.724 us    |      unbind_worker();
>  38)   2.312 us    |      unbind_worker();
>  38)   1.701 us    |      unbind_worker();
>  38)   1.681 us    |      unbind_worker();
>  38) ! 226.852 us  |    }
>  38)               |  /* cpuhp_exit:  cpu: 0038  state: 186 step: 187 ret: 0 */
>  38) ! 229.393 us  |  }
> 
> ....
> eventually this all finishes and _cpu_down() completes, releasing the CPU hotplug write lock:
> 
>  73)               |  /* cpuhp_exit:  cpu: 0038  state:   6 step:   7 ret: 0 */
>  73)               |  /* cpuhp_enter: cpu: 0038 target:   0 step:   2 (x86_pmu_dead_cpu) */
>  73)               |  /* cpuhp_exit:  cpu: 0038  state:   1 step:   2 ret: 0 */
>  73)   5.038 us    |    percpu_up_write(); <<<<<<<<<<======== CPU hotplug write lock released here
>  73)               |    cpus_read_lock() {
>  73)   0.474 us    |      __percpu_down_read();
>  73)   1.420 us    |    }
>  73) * 62023.47 us |  } /* _cpu_down */
> 
> In the trace that included all CPUs I only see one instance of percpu_down_write() called when
> _cpu_down() starts and one instance of percpu_up_write() when _cpu_down() exits.
> 
> You claim that CPU hotplug write lock is released before workqueue_offline_cpu() is called.
> I am not able to verify this by looking at the code nor the traces generated when offlining a CPU.
> Could you please help me understand your claim?

As above - AI hallucination. I need to be less trusting of AI pronouncements. My
experience so far has been that AI is right often enough to instill a false
sense of confidence in content produced by AI. I need to set expectations
much lower and spend more time checking.
> 
> Reinette

I'll finish tidying up and post next version. I've got it set with you
as author (with a commented out Signed-off-by). I've applied a
Co-developed-by tag for myself.

If there are just minor issues with commit message, then perhaps you
should just fix and post a "final" version for upstream consideration
since you provided all the key components of this patch?

-Tony
