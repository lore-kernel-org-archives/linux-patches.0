Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 957B1325727
	for <patches@lists.linux.dev>; Mon, 11 May 2026 03:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778469368; cv=fail; b=GsiNFdx/YFkgPlmxA5RpEjhCnsda3Ngw2RaS+OCSzyqlWABDY9yqoTCkw8qAVfXGvPfdmb6GMcooiUSqmZdOBri2A/83uEJSHvEt5xtNKt3u2BNhan0FbbagLiOcB9IJNxvNnSLYv7A32gNX8oUpsp2tUpbl13mWwlvdzZ9VqCs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778469368; c=relaxed/simple;
	bh=Oc+q3eM+BzFyMlErJygnPcnAYVkesULaQIKIIXkGF8o=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=qVq+fIYz7eih+W0TXBLLGKcFjuvCrh+9AmcueTmC7i0Yc9Q6yoo3xbHmWn3igty6URV7XYCKatDr7/EoXMNR2X9I3JHDVUyc3RcjpbmU9EpVfZiliv8f8Tx22WLsDAjQMp90B+g7pjnUFFgBEEP5jpw3TGWUh1zZeY0FjWk5ewQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PwRbOd3B; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PwRbOd3B"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778469366; x=1810005366;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Oc+q3eM+BzFyMlErJygnPcnAYVkesULaQIKIIXkGF8o=;
  b=PwRbOd3B9r9D7On4SqXZjzXebvU7Ctgvh+G95jUysC2fZUEGT0O1qwr8
   RJooY8J4YScnuKPhpeH8bse7V5jLEAL7OcObncxcU0D7FiS+wxtYyarsV
   nWcDSXlCbvpQ/jLn6fY02f2NBY0QqsA+lkafYzRswgnscfuAIsqNByccW
   CMRHuRYd79TNlPZ/kGvNjE+/s/gUSSY5U3bovJ5YXzHiuVo24U3ST5NOl
   RyKS3s5RfZROJKr7lZwMHNEyUrraylQGNAV4/RYPsd7zGX9RJ+94PwXc2
   TdmkqDa5EucxSoiNIaa5+aM1c1FGVpfWXqlM9ZTx5CNsVqIDyKVGC8vSS
   g==;
X-CSE-ConnectionGUID: wYbd0FvGRf2PfCzSuxuaKQ==
X-CSE-MsgGUID: gBPU4IuXRqahQ/Z6oxlvKg==
X-IronPort-AV: E=McAfee;i="6800,10657,11782"; a="79373594"
X-IronPort-AV: E=Sophos;i="6.23,228,1770624000"; 
   d="scan'208";a="79373594"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2026 20:16:06 -0700
X-CSE-ConnectionGUID: 5ZKvnaGnRR6b3z73epx77A==
X-CSE-MsgGUID: /fumR2xjSPCKOuPKu3desQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,228,1770624000"; 
   d="scan'208";a="241304948"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2026 20:16:06 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Sun, 10 May 2026 20:16:05 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Sun, 10 May 2026 20:16:05 -0700
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.34) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Sun, 10 May 2026 20:16:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OoBP6wpdryRTb/4dZB655qHj89hEoOJmYEOZeah+piNAVVkJF9DC/S87Hltd5AOStiP1fnjZ6WPHe77PylTpwioGlze84/iPGw6PYe/khOz++YA11QLzMSOSI/fIIIc7vetcECq6KYoRmRUePTfK7ZWpGHeoNmoJL+gUHluEShVkkSTWZ5J7RAS8T5I1ac+vLggKkrVsRDGBiJbRcqbej0UNRNCOdFj+C0tJx1rHZ1588DtUWaynG/zViQHLO/VwiqxJ1dQ4sTxL1ABBD8MgQCiTAyoA9pS9Urb71Gg8lBz6xOuO5vKPmKpfbpIZeo4n8kIQ4aG72lwbkgKNaSE7Pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n5gfRLKHBF6PZC2DUO4hdNUxEQCAOUJqiS610YCY3Og=;
 b=Wq/yMIFfdh0OkpQQ9lhjTqI7Req1B5TewbJl2Bzb/285EF7A7PU2yrKQJDjusR0jAxGo4ZGevbw8WVmycYRtFWHiK+LSNO16TkuzvffH5mTmTH6/3SJVconzdKHrpt5/U0rnTeQoLB96ziEByTaET15DXneB71HPYBL5PolwFTKabAsuR7liwRsEUjnhR6ek56bIfnJA8AcuH9W95gpAqhlW4X+1Cm8KKbSjkDuIe9ZIa8/cAFDhQm1qq0sEAFHAGFa1IH7GDWeqIpcHf3cb1GCSR6m8nXo/Oc1Hgw9xRlA6UxV1mlUYfJE8frfAFOzUBBb+wur1dA3zgSt+lmpqpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by SJ5PPF0D019E8BF.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::809) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.22; Mon, 11 May
 2026 03:15:58 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%7]) with mapi id 15.20.9891.021; Mon, 11 May 2026
 03:15:57 +0000
Date: Sun, 10 May 2026 20:15:55 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: "Chen, Yu C" <yu.c.chen@intel.com>
CC: Borislav Petkov <bp@alien8.de>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Reinette Chatre
	<reinette.chatre@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, Babu Moger
	<babu.moger@amd.com>, James Morse <james.morse@arm.com>, Peter Newman
	<peternewman@google.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>
Subject: Re: [PATCH 2/4] fs/resctrl: Free mon_data structures on
 rdt_get_tree() failure
Message-ID: <agFJ6xNx3zjtEaOS@agluck-desk3>
References: <20260508182143.14592-1-tony.luck@intel.com>
 <20260508182143.14592-3-tony.luck@intel.com>
 <af5XYNAklCdaAfsy@agluck-desk3>
 <3c1a99f4-de10-4953-92bd-4a93a5000a93@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <3c1a99f4-de10-4953-92bd-4a93a5000a93@intel.com>
X-ClientProxiedBy: SJ0PR03CA0122.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::7) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|SJ5PPF0D019E8BF:EE_
X-MS-Office365-Filtering-Correlation-Id: 74cc878f-7e40-4932-4d1c-08deaf0b9e80
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|18002099003|22082099003|3023799003|56012099003;
X-Microsoft-Antispam-Message-Info: 5uMKzG4wgnTK0QSltILSxEgM6TdBVWc3qO+jSfG7xMtopVi519Sz2MQ8iQXBx3EAegzkqSZiAesAzVYXkLs5AHBUFFhjdDKFtvOxLl193MxkaqwSut6MeRFJb3Q4aER69W51M2yZnPq4Xo5jMF3rNUrzbnJfxlL09/Q98yNISw6wVhVWBEKBgHbMs2uEQJEs0zLUO4yU+Lo9y8xweX2dX1ZBW2q2IijyE3ksoV+MQ6r4VvTCAeyZbNJ8X5fKXEIkSG/n88SjIfVMIXCDvei0FDGra4iqKYx4ZBEjoRTr5lOCGzq9u/rDo2CZtJDAOUHTnk1CCzTzMM6s6SIY8L7KgZ7URSKHDJht6p2k3zYgRi3M8GmHsycuH7JzyNy7Z/YHuE4NI/LR1KY4wTgPuTukx9p12ktVAjFh4+8VR6aLuRAgmuvQMMS22aUv3PwYUqxh44hVrhWP1kSieym5Dl95d2h1q0k7mPMzjnK0wSQrrnyYhY3jiqDLPU1Kfz9qa1M5wtg5NSd6rQNUzydeAE/l7GDQcM1wlpLal6kszrNgE5c9/OmLe2aP9n5aZ95EdBSGiiEi9fFcJGbsXLrYFZ2sBJDLrtyKz2OlywpijuEVUxib5EELYiplsl+hXlxcrZfhjmQ9LrP/JzE0jiozkoCRHGaDhhpOvboXZRZ03xZk1R3iNRjWupUwtz0AC29atczGoRbbucWTfY12wMY/hRCkzQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(18002099003)(22082099003)(3023799003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DFOHNLukrrkaf/zFFUzChtqd6LotDsFPQYDZDoNGFCJwVY1LQlj4CBy94+FR?=
 =?us-ascii?Q?sPaWuKhjngmBRUW/256RR20t0pwY7uv5bUcjHfiZRJ0Ufa6cciGVZ3Dj8WXA?=
 =?us-ascii?Q?dUcFjZ/1frTuqM7izKq1opTP5OJcJGs0i4GlA6aJdJF4l3/pf23kXn+BsANo?=
 =?us-ascii?Q?DZ2DjIqhcvmSY0AJRV/qYhTDawO3aoiX82IWU6KhHXopV54cEUV+658dwGT4?=
 =?us-ascii?Q?+pZ9BtrUHjhHFlOM8ZleAQD/h8kCJOf5P5VGICMaa2e3MGhxosrsExGwl87X?=
 =?us-ascii?Q?FKc4Son4nWl8J96aHLjSVtTeEGD7JHaMJqNxg05S/683xMoOzB4o/TKZGw8B?=
 =?us-ascii?Q?cktahQEuC3LCUYUEtFYOGlhn5GZwtgTohZ6CZrljRdZtiEk3B/MSWbMtNYo8?=
 =?us-ascii?Q?B0tvcoqkPMKQj/PvINbrdM/L8C8vmfYjpo9bi8XEJebsWncjcfFMN4gCCGJa?=
 =?us-ascii?Q?qSNAuSkGwa/O1POty73wCqlO+nvU6Wr3iSlmbLLCVeLc9z1LZewFojND9m/2?=
 =?us-ascii?Q?MjNJw9gF4Y8nzC0mW8SbSzg2+NC7tQXDbOws7LkR6hJtYuZkw0nT/2LxIFbe?=
 =?us-ascii?Q?dA6vvHUx7E6Eifaofc6K7DmIKuYF9a7dPsXuTe7czRR78mUTvlXG/HLVWGP6?=
 =?us-ascii?Q?0Ngj6YFJRaQoL1TuyWmEcQN7Zq9UkWngYEVPtpF1RnIRWvJ5rDESZqZi4Ypi?=
 =?us-ascii?Q?N/MAJ+S+Hfp5luSU5uP3O5mtbF2Hkw5mQX61LPpFDmuH0XgmIYekmaI9N3GR?=
 =?us-ascii?Q?pvuyv4/u7vSaRHJyVQadL9yo/jkg95yfasnW+JGq58WvCLlb9SP1t2rCKbqH?=
 =?us-ascii?Q?0HuL65UsjK8SxDHS0w9aUcb504oUJYqloqv5oOKfdcpgCDEQKEmeOIZpXtU7?=
 =?us-ascii?Q?aIBY5yoD8JSFXTmVL5nAg/g+ayTXfWzxeyYSeXvlOI26HA9Vlk/h+98X1+rv?=
 =?us-ascii?Q?Ckj91fPFN3VDmeTsu6TGeRhlHmj7D5AoTUu7TvFpsPmPbDIhRQUfH/W4SraY?=
 =?us-ascii?Q?YirmDWgy2d1FvbImvoWqOsY7mQaXuvtpCs8OM12h1m84s62K6Cole7WHP0CL?=
 =?us-ascii?Q?K1kEq/8mnXifjOIC5mHJ8gECyfntPoAnpRGHJvNW6FYh+vdNon787lYGr5pF?=
 =?us-ascii?Q?/IrKmYOp7+j2dA+fq9cG4eQJpRxOcxh3CxhDmg4YUdMIFl0hKucTKaTkGOUP?=
 =?us-ascii?Q?omlldSRVpHxTKLiYoKroaBfacGd1QoV6uNzKP27HYzfx99XEpB5gWDdbaO7E?=
 =?us-ascii?Q?S6MUxm4zyuZ4cVjtLp93NK/4GfdXNQv9PVqi65XAR/JAZ2wn9uNOVfkaz9w4?=
 =?us-ascii?Q?WfzKB5KB4vFwByB3NdkZxdffzXoWcIZcWr+ufz58oLLbCAn76IVip8StLy5f?=
 =?us-ascii?Q?bVXpQ7dGDoMTpsDBrfKHVurw60WLKHeNcWa2YRiYtUhHmk+/ZhhSVF+NYnu9?=
 =?us-ascii?Q?ImtbTe4cLw8cPhG3emGj6yfR+JfMc75KGYMC8P3ImhX7shtcd1B3K0NGxCEg?=
 =?us-ascii?Q?S6UPsnnoy8ImCFhtvz0mKFsdz3Zu0pUhdOmesDeJ8VF/ptGoXulcnEPHRcS5?=
 =?us-ascii?Q?AJdPjG+BXqLoQ3SkVyVv8yWDx5tpzwepaYko3QrzVwDp351ZZ+/8KPJMFM+t?=
 =?us-ascii?Q?Wbi6BHzO2WHc9n+gMG9ry4EEJBfjGfkX9M3cNBv5iYObPkMLoBs/HiieRSF2?=
 =?us-ascii?Q?9eNdxzD4agwGmvwZXd2fh/FemBQijiMFBTaGRn6GoDQPyJJ9FQvkPqzDIK/P?=
 =?us-ascii?Q?3w5QCJw64Q=3D=3D?=
X-Exchange-RoutingPolicyChecked: MH1Nca7HQo8PtcjyDNavNyViGCpw1F9XIdC2cgMU0NYZoT68xplwM+s3TLf2D1jFd/02uCCVzihS4CRsJEUuz3QGUPbGH6TXOoWTQbmd4ZxTuf+wqnJHiS9EFpSSOuMWlfveiEcVBgED1AUkVPbOfVpWs6BUlxy6tGxKmxB/cDhQyDDglZPzHPKli//4XOtiBAhlZq590vSz0UfU1zLkY5Vh0mQodGKqZXX5vJ/Q8t/Uv1khUuQMafi33re86vPnl6RTnyNMl08K7B+YirJ8oq2AP7mzP+Ue2G0tYVSYEEWpDiOXGacDVlpp7Z59n+XbQyoZtyP6Ud/c8NMeMIVDsA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 74cc878f-7e40-4932-4d1c-08deaf0b9e80
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2026 03:15:57.8140
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4oqN1D9NZdJo3Pc9VJg69yE1FnWH04kQKqaCYT1OKWmFK2X60FEoaMRs/SHQeJinZHfPmWCWRhbqMxpPJJlI7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF0D019E8BF
X-OriginatorOrg: intel.com

On Sat, May 09, 2026 at 08:43:36PM +0800, Chen, Yu C wrote:
> On 5/9/2026 5:36 AM, Luck, Tony wrote:
> > On Fri, May 08, 2026 at 11:21:41AM -0700, Tony Luck wrote:
> > 
> >  From 0263035539f805f5d4bddcef8968b551354cb86d Mon Sep 17 00:00:00 2001
> > From: Tony Luck <tony.luck@intel.com>
> > Date: Thu, 7 May 2026 13:48:51 -0700
> > Subject: [PATCH] fs/resctrl: Free mon_data structures on rdt_get_tree()
> >   failure
> > 
> > If mkdir_mondata_all() succeeds but a subsequent call in rdt_get_tree()
> > fails, the mon_data structures allocated by mon_get_kn_priv() are
> > leaked. Add mon_put_kn_priv() to the out_mongrp error path to free
> > them.
> > 
> > Fixes: ee4f0ec938ad ("fs/resctrl: Simplify allocation of mon_data structures")
> 
> I did not find above commit in vanilla kernel, should it be 2a6566038544
> ("x86/resctrl:
> Expand the width of domid by replacing mon_data_bits") where
> mon_put_kn_priv() was introduced?

Thanks for the catch. Another strike against Claude. It didn't hallucinate
this commit for the fixes tag, that commit does appear in my local repo.
But in a dead-end branch I created to write the patch. I posted it here
in v3 of my telemetry series:

https://lore.kernel.org/all/20250407234032.241215-2-tony.luck@intel.com/

But James Morse picked it up in v11 of his "Move resctrl filessytem code
to fs/resctrl" series:

https://lore.kernel.org/all/20250513171547.15194-13-james.morse@arm.com/

where it was applied upstream in the 2a6566038544 commit you found.

I'm somewhat confused that Claude dug through my other branches instead
of just looking for ancestors of the current branch. Maybe I need an
explicit instruction to AI agents on how to find commits to use for
Fixes: tags?

Claude is now double-fired.

-Tony
