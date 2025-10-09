Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A27E343ABC
	for <patches@lists.linux.dev>; Thu,  9 Oct 2025 17:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760031953; cv=fail; b=K/XrXsNNH+mt5ux113hQdN438v0H5zvbPwOophA3JG2mOzgwpueSNcrm+tWBIEb68r4FhEOhotOq8OKWJkzsLR91+35V6BnZErKwTlgYJ1KgD3847eB+w+f3cIBq0PWR/vThvx6MWUH87g7YJFF8U4IxSJYpQFyIxjOyN6uWOrs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760031953; c=relaxed/simple;
	bh=/By8ifvzxbkosfnO40sfqFvC1lrbA5HRiHjH2lAi1DE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=X52ZdSqbjTdDJbUMiiXKo20rTJyJpOkmxfnHhRWetlX29xU2o0rkS4Op39jwMdLY2u5KNpyNCtk5I3ys5Y0kiDMD1rDrRIaAA1zaKqcQA3gJrw/MG7vLwTeb9VW1nuQViRTA0JbKjOLSyRTOCIE6q79Lbvu8bg6FrbIYfrMTmDo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Z/dcI69X; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Z/dcI69X"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760031952; x=1791567952;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=/By8ifvzxbkosfnO40sfqFvC1lrbA5HRiHjH2lAi1DE=;
  b=Z/dcI69Xl/lqfUACv+64L+zUMBhlsE+pFn+b5ZapYx5he2OkQmcv9QYj
   ZBXrQn9OBoRrCv3AXhSdK0JKn9l9yH2XD9hrPI4PiAhmxW75IM8dYfJGf
   zvJHnlKQ415SegZJgN+LSU6ZlDmAV4z/5TDNMLqu3/v9uISmOaur2xhRH
   Cn+zclt9IJ+E+60uM2CInRnMLTyfme7sm7W+havVuElj9NQh2s3bGERjE
   J0tTCbNaUmeNrDdMDKeW3p0Y/B/B8EN6FvwNVvYWWM3QA5e3Kokc3WjR1
   dCIctl6R8yVz2xW9kxu88HHGuYD+Dfr9HvVgO8RI40eePAGlOogxdyAMs
   g==;
X-CSE-ConnectionGUID: 24+cGpz8R+O1y62xhP6jxw==
X-CSE-MsgGUID: bjR2SMk8T+CJZHs7jNlSMA==
X-IronPort-AV: E=McAfee;i="6800,10657,11577"; a="61457841"
X-IronPort-AV: E=Sophos;i="6.19,217,1754982000"; 
   d="scan'208";a="61457841"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2025 10:45:51 -0700
X-CSE-ConnectionGUID: Vr5ywfdYSTGLyZXQE7U5Vw==
X-CSE-MsgGUID: jTrUikKmQSGjyzZq/FEjOw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,217,1754982000"; 
   d="scan'208";a="181549187"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2025 10:45:50 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 9 Oct 2025 10:45:49 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 9 Oct 2025 10:45:49 -0700
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.42) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 9 Oct 2025 10:45:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nNGLDnH0l50t7Pl23NLZmv8P4HdjqgLBNNz5rq39nFlST3/+Y9ef9U1rG+P6jXVAbKnqX03U8dMnjmiEk1A8ErJK7dQGO/bxIN/JdZoeBSRfAv5bXXck9g6VTRjUkd26SXsIiBbdqvNdQ/LAVzYH6e0n2WZ4ups57Sd8X69BlY36sLyVAK91gNbdDgYNKEce74wggsxxyAvqU5yoULhZoYQx4M8O8NcSNJrXk7P9Hn4i/et8orNG5NK5uEz6qitp/7YgjUITjaZrONE4q9at//n0NZNBBkzMXOHsTEe0ilmyyzfVEHKLRnWR5IrbVxba4DxjvjOBspGdghh9GEuJAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=isvaFRy2+f4f7vDlikCaigprSRlEdq/c5A3tzXnV10k=;
 b=Uxzn+VBb1iFkuwHpPskAKpdcx4hckFAAAkiPxDIQg03HlKr6saEPqnelX6ODGKaPXEwEJaPugZ7Edy4QrhZP63eM8u5E34C159pdmOU4FrIdke8wS+cRe6Il6tU8i2Bz/9/EPOvPrrl7XWo10PxiuayFgspWG1YOgMTnxmLdHMYurfXeHXl/401HGwFq9tQoKWDHJ5eVMoWWlc26dhID4lrpfOB1ruJgEghDu2clyyNKJwQGNmVNpQophWAObOs6Z9r+Akhn29Zv5b6i1urOxYy7T1GJfjVBB3ue0jAwhyntSv4sMHtxHYWY+RZhlt92tx4ByHMBA6bye8EAfoEylw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by DM4PR11MB7254.namprd11.prod.outlook.com (2603:10b6:8:10e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.9; Thu, 9 Oct
 2025 17:45:47 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%7]) with mapi id 15.20.9182.017; Thu, 9 Oct 2025
 17:45:47 +0000
Date: Thu, 9 Oct 2025 10:45:44 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "Chen,
 Yu C" <yu.c.chen@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: Re: [PATCH v11 20/31] fs/resctrl: Refactor Sub-NUMA Cluster (SNC) in
 mkdir/rmdir code flow
Message-ID: <aOf0yA1AWlzJLf8H@agluck-desk3>
References: <20250925200328.64155-1-tony.luck@intel.com>
 <20250925200328.64155-21-tony.luck@intel.com>
 <fbd49f1a-ddb2-45e2-b943-df43d2173503@intel.com>
 <aORMZ6NUXMpECHU6@agluck-desk3>
 <ed1a10d2-2f13-43aa-93f8-7dfe8864cf47@intel.com>
 <aObUZU8rnWIDR_tH@agluck-desk3>
 <860ded3d-2003-4d72-9013-a5fe97657934@intel.com>
 <DS7PR11MB6077A0323678A68DF5878C0CFCE1A@DS7PR11MB6077.namprd11.prod.outlook.com>
 <e536ea0b-c466-4381-b92b-993be92fe65e@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <e536ea0b-c466-4381-b92b-993be92fe65e@intel.com>
X-ClientProxiedBy: SJ0PR05CA0088.namprd05.prod.outlook.com
 (2603:10b6:a03:332::33) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|DM4PR11MB7254:EE_
X-MS-Office365-Filtering-Correlation-Id: 158b0b75-5f52-405e-0540-08de075bad8f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Ol07msURxRHUJ+92lwG9ftpcl676wL6aZnYnK6IDfdvTeJ/w8Tee+YPxnpu2?=
 =?us-ascii?Q?nnT9WJWcbu9GRyNfBwHDi6y7hJqWA5NEpA1s8lpzpFC/3ZHZ3QGfAf8TXKZf?=
 =?us-ascii?Q?wWF0PJNm9Ok7ssOFd1nRu88deMgKyD+gLSwxNVij0QXOuSHq2o2JLKfXn4X6?=
 =?us-ascii?Q?UvNSH8uAZ9vsgfQa2WEl7Cxfwi0+nEan/r9tHrcOEZseEskvbpPTmmplqKFX?=
 =?us-ascii?Q?j199+CZFHMtTOq23rjUKLxNkRYLMUBC2E7TCutT7wGS64nVVM8Q28qm0HbHi?=
 =?us-ascii?Q?KIgHCuZf1OXYwxfuaMersA8rDUN4/O4/IaCreekhOXTbR6IebNv/XIMnL7Q/?=
 =?us-ascii?Q?avvnzRMO0aOe8YfOXKSRLF8ZwJDXGQt0qg917Vwa99IB0n9iTAP0c0BDiCi6?=
 =?us-ascii?Q?BP9e6h9jIRE2oPKHzQVHeOHHNsk9HaOOVoi9SNNszsbsCtsbiSiobH4OmSXK?=
 =?us-ascii?Q?zGuz/64wgA1Cqq2zqWatYpT3nvIePRNWu67xZn84vH+9X8Xf4FAa542ZJ7UJ?=
 =?us-ascii?Q?sGmVJ4egJ+Zob5AJypHh5plkgdz4RvJEIsadd5RG4Zt9UJb5OUnEeGB7nALs?=
 =?us-ascii?Q?0I+cNNDsD2o9ikDuz8Cdr06Ij5v0YlMaRrzMKtsS5zWvvgAHam913eARtbuE?=
 =?us-ascii?Q?H0yrTp1sIPIIyMzDaR6z+RrdgRNKnv0byyFTTOKSKoPRauvo2HcV+10+c5Go?=
 =?us-ascii?Q?fbxB6rWwXKLr4foGrGU6SwPd5ODGJOBgo1ECnGpqR3uaIw0E7YLoPbTX3T4D?=
 =?us-ascii?Q?WO/lHjBmrxdBxxfuphr4EUnayh94ogiyWjwHiJLAMPTS+l9CqssBu4g+OSd9?=
 =?us-ascii?Q?/yYFCPx+OAlHGUcDjQcIwbu4drc2q/CtgdK0eI5ikvZtbiEwoA5gVjgS+4BZ?=
 =?us-ascii?Q?dYaalIHn7MYtnvu8Xm4x7DwertoT0/Yqs06XrKK56oBun+f2/EdmXfXwurMe?=
 =?us-ascii?Q?qgJJrZ5GIHsX8oe9lynu8qcTwxh6xdd8MSSAfqyalizqPaoOJOgQT0tNNp9M?=
 =?us-ascii?Q?mXkXMypta+INiddWxFPwsN+VemUEuotNQIWMAclH4REKYTZFJQzmSQCMyQXy?=
 =?us-ascii?Q?df7slxkEkaC2ByTcLmJP76lNDLog5sIn+xhIle0T/sFkjgRYFFjCvIzuCW8Q?=
 =?us-ascii?Q?IGXmr4MIDUI0XrDidP4gE0JkEc+k8Mv+BrNqV0bPr1jokPvLCp2yyqLYzN79?=
 =?us-ascii?Q?HKF2+zRyFIGkDmj60+vh+652pmXH6PK8GudjrkwC84vqowtt6kBnNPSF7usx?=
 =?us-ascii?Q?vf9MNF58TKW6WIvGfOFIMBcnqcq0VVV7bt/tLirmIQfm7ZRPFsDhSA+tKfx2?=
 =?us-ascii?Q?VU+2cUWsmSVFexeyVqTiB3ADedAzW3Ryr/SC1HgyEfNR/hCGdmU980mSLm2Y?=
 =?us-ascii?Q?IaTd44U08+SE9GWWax2MdsHtJNyw5MVUOT1X343W7wb1ibe7wNl/iFOq6J6K?=
 =?us-ascii?Q?ALB5ZkKXD9hnFTVu2XW1ing3LMdrXa7p?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XrO1a+tg+43ch+07HZ8BR7LY0LZ45eNbmeDqls8fmZR2ZH11IGF5viApvkN5?=
 =?us-ascii?Q?zZjL6/zQcPK3qTa8eWNboEqd6n+NyBJOS+jWWHfwTUxjngVLD2a3IaUR6tOM?=
 =?us-ascii?Q?/wRsAUiSsuYPaiFWTelb9UuNINGDJ6WUNBYTEIv3bpaQRLEl4W1h/aHLopg0?=
 =?us-ascii?Q?64uaquXh/d5TMtQgPoJB7NZrlOlejdPj8KxFzaSWR2Gm9rv++gomjkVO74Uq?=
 =?us-ascii?Q?Qgghjzzgu1y6ZMXsxNpf3PVGzv8elvC+2hiMIxmnz+Za65hVCQ8vsbxL7dvA?=
 =?us-ascii?Q?c7vVnalvoZH29Zx8TryuXEYTMT3twtAoigdrrRToaKRIo4pdAbfIjzR+pyPQ?=
 =?us-ascii?Q?1sUpWhb0YrahOelerGkS0hY6XxLlsG7IDT4WgstlxFT4KB89PvIBolYoSODZ?=
 =?us-ascii?Q?XLPVEXT/Hp+mbkFTXm+ALMYtcnnX+I7ztr3i/fST0Bj4zkuZw3Sy+Zva8Anw?=
 =?us-ascii?Q?TWdWt1Sd+yP6hD9XbMeuCEgCFExILaLop2dWyAG+MsjEIlPChOUflA0InwhW?=
 =?us-ascii?Q?1PtXsFKeDA2raFz9VevCjjZ9wpEfpK787QTvhM1+Zby/yPd6stlHwp2j9Z++?=
 =?us-ascii?Q?6xJr0Nu93kIP7ZiGYgYjh6uizK1/GMfi+tZp58SM/eh/t9i+WFuNZu4GFzfZ?=
 =?us-ascii?Q?w/9mb1spkVmNfa5ae12rmA2mTjvuooIY1NZFXpfw0K0BO9cVWqW/iOGsCEn0?=
 =?us-ascii?Q?MrlvTeFHi3uEtn+LaEVZzxxcsBbagB6szsfjSOipXQzYMkMBWJkanSSdG404?=
 =?us-ascii?Q?Z0WCmfHhLW9SRuzO6KIjABio7AgbFdupCfa295GvqdV4EbPWKtNLbskEZjqV?=
 =?us-ascii?Q?sfQR4GGYoRYPpabauMlcpPjPXIRt36mWtylLwXDhUr8ttQzDxa8UNswZaJDc?=
 =?us-ascii?Q?WkGbLKE27J4zKHFcgl5u/CVFS75/NPbpOnFQkmLCFxt68Bg1ALhufREDTtDT?=
 =?us-ascii?Q?yl3842L6+l9+e+SYzp+UMbcSYGWsZCIxUMP6GpvPuP5jtRatAVl0Q9IKOr9/?=
 =?us-ascii?Q?gJsH99Zw9CVjGjWBbxtj83cMopfCOJ0mTviHLaqHjitE9Umron+6CUmGKq0e?=
 =?us-ascii?Q?yHB/jNnSEEp2sve+rhShm2pkVW+THquLbmQPHm7hSjRxEjZTE0/K0ToWgE13?=
 =?us-ascii?Q?8rDG63flcjAXiX1x4mCmio5imU8NttJfybu+Ph7SRxG0nrDFlm8SmBL2nRcP?=
 =?us-ascii?Q?hCX3j78tv/3vH+qONnSxEKxpyxrWE6YahDXjC5n1e4rYfBV2xneFP6mY4Lre?=
 =?us-ascii?Q?kJhhxMStg+FgmTVdVUX74d7DaAZrkRvt9lxLaWXBS1O/QwlJUzGPv5+gzsKm?=
 =?us-ascii?Q?8+M9klcetjJuYPVg8k8/0I/1An3c74nO+LqpnD2xtYAI7QYZsfULDWshsb3o?=
 =?us-ascii?Q?h5vBUFmaVOTsQY8B0xjHf9XGNFkpGSJu3/xcjluTQAAvS7c+NR5p+jCBhccF?=
 =?us-ascii?Q?1nL+T4oMH1SmL2RKt6ze1Szf9McqNZAI0po63kPh8SqJe65US+ktzRI6gNy5?=
 =?us-ascii?Q?/SzAUYRqM62RqtOrwOu4SiRDYt3G5tJ0SfYwW33hKfLObVurOJthvdca+oXd?=
 =?us-ascii?Q?/ebY0Fn/l7vvabBoQ5YLmgnqZS90YBzDc19hv+vl?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 158b0b75-5f52-405e-0540-08de075bad8f
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2025 17:45:46.9997
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fWEwl5F827oOhu4pZo2BlgxfWK0I5XQV1hMBp6+DfXnkJARmyUleaDx2FkXCxMETbynR2Df4JVF45dpXxhNWhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7254
X-OriginatorOrg: intel.com

On Wed, Oct 08, 2025 at 07:16:07PM -0700, Reinette Chatre wrote:
> Understood. This is not about correctness but making the code easier to understand.
> What I am aiming for is consistency in the code where the pattern
> in existing flows use the resource ID as check to direct code flow to resource
> specific code. In the above flow it uses the monitoring scope. This works of course,
> but it is an implicit check because the L3 resource is the only one that currently
> supports the "node" scope and does so when SNC is enabled. 
> My preference is for the code to be consistent in patterns used and find doing so
> makes the code easier to read and understand.
> 
Reinette,

Should I address this "only one that currently" issue now? Maybe by
adding a bool "rdt_resource:snc_mode" so the implicit

	if (r->mon_scope == RESCTRL_L3_NODE)

changes to:

	if (r->snc_mode)

There are only two places where SNC mode is checked in this way. The
others rely on seeing that mon_data::sum is set, or that rr->hdr is
NULL. So it seems like a very small improvement.

If we ever add a node scoped resource that isn't related to SNC, it
would be needed at that point. But I'm not sure why hardware would
ever do that.

-Tony
