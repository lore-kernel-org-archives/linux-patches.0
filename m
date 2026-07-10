Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75CFF37F8DB
	for <patches@lists.linux.dev>; Fri, 10 Jul 2026 21:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783717740; cv=fail; b=YtkCcJ+jgf+ibYzYGOhjyybtfCxw5Bxpz4Wpztvg/DVC+4R4tZ7TZIQVsauIkejEcOom+9jxXzG3uq58mUFuU8fzCZMdg3teQ5uxGlGUBTduREo3A+EtcISrKyfHxh0V8HqfT8UBisD1qob/4RBch1n/i/LTAq3ZtWoelhzQZiQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783717740; c=relaxed/simple;
	bh=vGz4PEw+Fxqyvry2oD418uhEEVr2vIkwEG7FiwieprM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Y10t+4K17OINcu/0d4g9RHQQb+x0REAgxErrDmwYvQi/YyQS6Lu1EP1Hs4zhJXSyL8lTbj9Bg3SBCo/soq5JxYO0+v24bbP/qS5Ur/9CPidFxAsvt6B72XjBVE/la4yu7xoRxve42sKNUhSyztPug7puF8ye/0skhoujsB4KXro=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WQqeTQ2Z; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WQqeTQ2Z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783717739; x=1815253739;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=vGz4PEw+Fxqyvry2oD418uhEEVr2vIkwEG7FiwieprM=;
  b=WQqeTQ2Zvxfz7ipiKGLTbPt9CZzFocED1dY3EgAZCoRH0P6H+S6ftk38
   KD7qafmYvpwv7UNG75pz/NOqQHgdQu8dIaY2uCO+df6UcJx3ilEiZx1vT
   iGvbf1YoeP7ljIo5mrZEwEpTiCjQQpmlo2OCCReVUIvdcHqn/4iOBbvQF
   3VWaSPg+K1XmGT/9kXtVatBFqkQ1JHo1umuDjAU613JMwCQZS1yx0YDwJ
   3pdPL1eDrGT5iO6Y63g8KLbkpHDdMVQoq9/Jl4W21v2gXSSFxv8aIaYp7
   tuXB8Ps61/4Usb7M9nl74625n0GTOc3WTCg7/dC0vMOvZPMurKYF6iQH/
   g==;
X-CSE-ConnectionGUID: YmVcrs2BTy2yoQ8+JBEzmw==
X-CSE-MsgGUID: pXmejO/AQPCWGBAvRi2UiA==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="107218044"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="107218044"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2026 14:08:58 -0700
X-CSE-ConnectionGUID: FnWWB592S2CwkpQRLuek9A==
X-CSE-MsgGUID: ke+D10GPRhu0wIyh9JTgDA==
X-ExtLoop1: 1
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2026 14:08:57 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 10 Jul 2026 14:08:57 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Fri, 10 Jul 2026 14:08:57 -0700
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.69) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 10 Jul 2026 14:08:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Pm8CG+gEFKgqohqSkDn+c+B6dcDVkgji0Omjc+SfQC2WVWf477wg/kCqui60AVDgof6M9NxYvwqu0OJwzEe0nYAIaxaeeBqcsU2DyibyAQaa3dk4UBeR0Yy5awS4b3R969Cub7w4kpK11+JH9kcOfhhqEi0uyUIrRZcuNeFQFudsSgnWR1i4YvntJ4+TLUNhyvXh/9fx11zsuFTJRr6QYoYXo+1lvLo0yT3ckENirUgsPBAY8bBIvTH4pbxZUZ0qD9QD9sHSBOG0wDmQ0e4mxGQEAjBsMXdL0vTBN1MPPP4fkVj6QwDTKnW/n9qRp8Kq1b5xhXzTnL4+z/mQtVLCqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V2asYRRX5d2VCClXy5lR3y/yTjmO6e8CHY36LpLTtHY=;
 b=Ta7KsDi+evMFBkIGcJVtIEy1R83HSGmyKWkZCdQBEBY64/R3ijTNhx94o3dh2yKtvDJrtNi7C3VTmqBY4z/co5AS3+KT0GE+j84cCrCxQKbu4MKrU83DFGY2A2nrSjA16hMpdLN6nsNUPtLLOiLXJuB4du+E1EYHjDPHHg4p5iYyux6cbyTRI5KQLyLJTFFe6K2SfdfFZdcb9Zuf5iJRt5Vr9r/7WHnwI26tAl9JkPQ6xDf78dkKehxF2k6dQmPi+vYn5Uc2VvvxHhH0yP7lhmXPfvlKETdqqg2ICYjI7eq7jb071MRsip6yqF4RRAB2UTaNQan/s6wHrHx39CBZkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by SA3PR11MB8002.namprd11.prod.outlook.com (2603:10b6:806:2f6::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.15; Fri, 10 Jul
 2026 21:08:53 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%4]) with mapi id 15.21.0181.014; Fri, 10 Jul 2026
 21:08:53 +0000
Date: Fri, 10 Jul 2026 14:08:51 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v9 11/12] x86/resctrl: Simplify Kconfig options for
 resctrl
Message-ID: <alFfYxgEUAA-Cxv-@agluck-desk3>
References: <20260701213553.15222-1-tony.luck@intel.com>
 <20260701213553.15222-12-tony.luck@intel.com>
 <87950b8d-c7f2-42dc-a2ca-2d389304ef16@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <87950b8d-c7f2-42dc-a2ca-2d389304ef16@intel.com>
X-ClientProxiedBy: BY3PR05CA0030.namprd05.prod.outlook.com
 (2603:10b6:a03:254::35) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|SA3PR11MB8002:EE_
X-MS-Office365-Filtering-Correlation-Id: 40c3ee83-4e1a-4873-5ad4-08dedec77249
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|23010399003|7416014|376014|1800799024|22082099003|18002099003|56012099006|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info: dZW3juRfomgH9rJvAo0PHApzH8QbBvbOEXDrea0tDNr7nZOOcATTRflqD61ez8qSWV3qrdreGwknw6AN4biWfFnTRS9Fe3nRNjWI16r/1z9qpz9YDAArMyR8NCU3StRj8qdL83C+htDoJ+mEDCQdRazWvGxmMLyBjbyqepj0fWnLAK8g3+UQPMxwCxVWU2JFuOGNzeIzpauH4SYrTP70XIsktC9K8edI77J6xQhfwyfXdPKFw9EjYI7hdid4HdN91cbOq+WgZ5Z/eu/QkphDYUQH5t1U4ov2F/P/Dw1M95y73rW983wUrBsxHI7f50kfQb+ImdQrhyvhZBmSf2tebknewyNgZrEPT8YQeOwf6BQEzQ7z1BErS2SOhVj5npEB2gm1428sjKV6N0gTeP2/gTdVtMVghkrEfdX6LM8w2Cw9A/IzgDQP686zWvCMah4oINsxatg/LNkE+veLmsPSXreh2ew7wAKyVc/DBF+nUrMqbJJixiS8xBV6eLd4k+K+2qg5grOGxIT4iMHiEMkodeDKSdEOnnVSIe/IB8U1nFyGkzz3ukPgaX54WWyUkRjK3KTs+zPlttpuBKuZvklAc4xWX4ulehA+J84HS81kvMNK23O+62EEJlgiEa0ejQoV08vHX0X/APYEMJbBd56CnGz+oKzlwiUKfBIYX3wnyXM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(7416014)(376014)(1800799024)(22082099003)(18002099003)(56012099006)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?i2pjlwIRJmVXFoYh4skA88ckjtYesD8r8360FRQnbVwjqG2vB5ahoM9Ri6bJ?=
 =?us-ascii?Q?SRoCg9xy7ZJw3SZ82XnY6/9EX4rFfbmsRabMAbeCT4UKAmel7h3ndx1o19W6?=
 =?us-ascii?Q?dHKlhwyll1p3bDJ6V9G2Y+8UxXb36x5SbSWwBXfxZ2nigHr/csOJIjYPiWzR?=
 =?us-ascii?Q?iNm3YxGXxK/iqMFUOcxgUZi5pHTk9Ipuz85qlOxJSNC/BaODfqUWaE3EyYfV?=
 =?us-ascii?Q?VFZfbJPQjrFXsxjdER+iccjMRhnjU7s1huXsYVBUh/BLj8pvfGddbclJGRJi?=
 =?us-ascii?Q?SmFHLRkQ7tDh+iWoAoTJpZ1LG5mM1Zh6abQ78D+B+Q7R9xNWzARh5utKVbMr?=
 =?us-ascii?Q?t6KthSoPCWEACWCGb7rAECAgYXFlRkb9XZiKYizM70gVfid7qQyPsXaZA3po?=
 =?us-ascii?Q?p9d2CKw8pBCpvnzrYPr58wGtS27zUO8m+MtSD2WpSf+ZpI4BAnlkO12fYnVy?=
 =?us-ascii?Q?Z+k1rKvdahYB7Gv6bisp9v4SApLnRr+BuPbntIOr3jsR2Tjmofnk1iyDyr2f?=
 =?us-ascii?Q?0etfDGhPIPwgEnBxWB7W7fIxF5+UKMnW2Lj8ZZAmvv6E3hvsfhLY+ClTAG/X?=
 =?us-ascii?Q?kXUU038QRnfN8zgBV1k7iZDEkJuyCc75pD99zr7vj/AFrvYpjXnHi7pzGgyl?=
 =?us-ascii?Q?IKCkMzzMlZYk7WrZtrRZBoY3GMyv0o7NfKcBlP0IO15/E59jq6otZ1pWDU13?=
 =?us-ascii?Q?W8Y3oW6YtPH4SqRQq+6ed6VhCkh1Az0JV2bQWWIJ6gfa7Nkh9rGiYzBuVe0x?=
 =?us-ascii?Q?jZiiWWK4Jik2379wwF0lD6fBGMojgtD3LMTgCxmlxrLQOzpcnrY3wlL0cX0b?=
 =?us-ascii?Q?H3V1tNVnnTyiQCfddECIER3xFxENZJAUrVRGMwi2Q7AjqxrjyUhPuceNkxUF?=
 =?us-ascii?Q?NklzSKqYG0Ct/Zom6ktNIlo3I4E9acr2wK1+BlthkxvhUmdGs/0UEGBG+9ac?=
 =?us-ascii?Q?NmpH2fwaG1O4EVGCZl3sL/GrBRQD6E3nqsbWcBt1lEtrh+kaXjQCNIlP0D+v?=
 =?us-ascii?Q?megwz4WS7aS9fUg2DNNmHzpBPo0gq+6ccXuFcNd4lkky7CLtlNhdYSxinlRd?=
 =?us-ascii?Q?qY+bDr7Lq9fExSoClajH7pW4yJUXN0z6799kRH8iD8b7W+ZkB+N2BERXUnl8?=
 =?us-ascii?Q?+Jt1NI4cweIL7Sf+d3KNtj5cDo4K1asYDF/PYYCuWzAjvGfFKA5ibBVi4dbD?=
 =?us-ascii?Q?dpOydhV3tBTJBwK4oF2nOAeda6tws99gtz4w/E51t+4NE8Q/pisA4s4K+mOf?=
 =?us-ascii?Q?0La6DMUIexrlJIdMHJxBtWMTvUhLCu8ltNnWO67IAxVcdx1BXfqZOdpvXfDY?=
 =?us-ascii?Q?/ds3bp4VD6IUtJXoxpkYRIbE6a9u5eQ4MUBNesI1rx4DK59YXECMPyhikAI8?=
 =?us-ascii?Q?6KqaSZK8PLvKwEi52dmgMvKfGq7FPdJ3zMuMFUQncB/16clF4frT9y8XRdP/?=
 =?us-ascii?Q?kJz6tKlbfOD8e6UtbYxiVojeWUXdJBvfFMRxvI+wljvwH0h5sT3oerX7ayU4?=
 =?us-ascii?Q?I3tE6POE87KysEOBNrWxD3v+uVu8A4kmJyXIMX21sUQZjnChYCQMAFZh5adq?=
 =?us-ascii?Q?yHoMHmndnU20xjxzyK/vW0javH8m5ZRaLk+D1R3wkSNXfVKk/S+ooqeptXLB?=
 =?us-ascii?Q?ZwhZkH0jw2tWqONYlBpbT0vFKHIyy0GPz9jNjVaX7RW00twhpWoL92wPmUm0?=
 =?us-ascii?Q?vRlPuIc2zDdM1d99Xb863/aZcBUx7db7b7vI6HR3tl02BOwCOYQqX1S5PFQb?=
 =?us-ascii?Q?skc6IsZgUg=3D=3D?=
X-Exchange-RoutingPolicyChecked: mIQHKehPoGXD49MuJmu/kebdABTYdOs0lJ3KliKaGYQBvaXTSRHJfyPHNOMiqcYCbZjp5AY4LqgZ0bboDTNIq724MSAuLwgEUeWqdxG293Jw/Bl3uAYss9Obd2/pFiHCKWffD7kFRBSyNkqulAFKAplFL1qXWb2p9ma3oE/NhQfkJXshYQe94ZZf9JdN6Yw3RUzI1iwxw89k1HeoMsgxehRucCoMoLBw8AM38dSK0UHV9lCVBiTkErgNy0DJ2lJCxdaB0sLcsjCIjwBMQp57zHKskfDQsjvRxNnRwYEeP6JDtDhaR5qWhATkycM9/i5VwUcCrGMv8DHlNHIGlaEIVw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 40c3ee83-4e1a-4873-5ad4-08dedec77249
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2026 21:08:53.3135
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w623muf/4CZTt+Z9rH0eoX6UIb7zMjbTns4/VFCJnJjMX1MFA3QHWy6CNq38wKLvsq8VjSHQWTEHZlS2NK761g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB8002
X-OriginatorOrg: intel.com

On Wed, Jul 08, 2026 at 04:01:00PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 7/1/26 2:35 PM, Tony Luck wrote:
> > Linus Torvalds complained[1] about Kconfig complexity making it too
> > hard for "random people to build their own kernels".
> > 
> > CONFIG_X86_CPU_RESCTRL_INTEL_AET has been causing problems since it was
> > first added as it required other config options to be set to "built-in".
> > 
> > AET now resolves PMT symbols at runtime via the registration API,
> > so INTEL_PMT_TELEMETRY no longer needs to be built-in. This means
> > that AET can be included unconditionally as part of X86_CPU_RESCTRL.
> > 
> > CONFIG_X86_CPU_RESCTRL now depends on X86_64 because reading telemetry
> > data needs readq().
> 
> Above reads as though it is a new dependency as opposed to an existing dependency
> that moves one level up. How about something like:
> 	Move the X86_64 dependency of the removed AET config up to CONFIG_X86_CPU_RESCTRL.

Needs more than that. Before this change RESCTRL (sans AET) could be
built as 32-bit. After this change it is 64-bit only.

I'll clone Chen Yu's patch[1] that makes resctrl 64-bit only and
include that before my patch to remove CONFIG_X86_CPU_RESCTRL_INTEL_AET 

> Reinette

-Tony

[1] https://lore.kernel.org/all/cbd33bf5d99b27e98ddf899b36384d9a41f14201.1782866200.git.yu.c.chen@intel.com/
> 
