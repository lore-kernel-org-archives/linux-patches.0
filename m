Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A61918DB35
	for <patches@lists.linux.dev>; Thu, 11 Jun 2026 17:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781199652; cv=fail; b=Bg9wWO3wTs0jprW94+QCFf2Wd6rUU3PAWNTw9uzNx1rSqsNuqnQjb1W6GSM9bijlsyLVN5IYrjn0i24QoNGFetoEa/a+N77YOLu5tBdLc1+dHls5HjHHextVj72JVXx+u2QCUJAQO1p9CTL0UzQMg13Fh6mygndpte8I1UWj+No=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781199652; c=relaxed/simple;
	bh=SrgeXtNHQxBbN17ifk95onQQFjsiutxtA/0qHDJye1I=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=X0mcKc9ZgWf/SzmTo+Po1QbAg1NM6BPvvTi3dxCgQDh4VNak8jOSQy/in9NPmygFmf1syBWkxGm8s930GjVe7YqS35W20jAk1IlnOJbCE1TQqAC8JY4FTV7r/XlXyZNZCC0/midqvT3msXfUtC0Ogc3c6uap0nhNKn6GchYgDGY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=a2nrRtPR; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="a2nrRtPR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781199650; x=1812735650;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=SrgeXtNHQxBbN17ifk95onQQFjsiutxtA/0qHDJye1I=;
  b=a2nrRtPRywlz8fAeRdbvh7Y8ySuIwDJNwUhcdph3qDqUr/7szG0I6NRv
   OhIP4kDSLSzQunHwdkKucwCSVI0nhnbpnQfgFmmV0smZ1MfFc4iPPiTRe
   tRR80+gvcoemkMnLIl3OPGOHFtN/ztHjxowf+pkThiM1x/9wyVg7xqQgN
   tYizNzxBPwZMhJP9lF5Hw56oVh0X1csreSMg9h44qSSDPgsumJVWgYvbz
   ybYye9SS5B4ihMzBXdMvDIQH3SGvYwnqqxK9EXpFUvf6MnsDAIGpGwp7O
   /zbSpRnB65fB4bbdzNXiLlDt8vhpH7FmNs0AGWPiA36pkQBUWV6it2EId
   g==;
X-CSE-ConnectionGUID: i7M0665NTZqYBBzm15w6Qg==
X-CSE-MsgGUID: oaPt2MsnQzOsQ+zd6EmYaA==
X-IronPort-AV: E=McAfee;i="6800,10657,11813"; a="82083662"
X-IronPort-AV: E=Sophos;i="6.24,199,1774335600"; 
   d="scan'208";a="82083662"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2026 10:40:50 -0700
X-CSE-ConnectionGUID: phV8ODC4RmiMr6NrZ6wAHA==
X-CSE-MsgGUID: SWtIIBy9QvCWeSFI/AFlgg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,199,1774335600"; 
   d="scan'208";a="251641993"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2026 10:40:49 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 11 Jun 2026 10:40:48 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 11 Jun 2026 10:40:48 -0700
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.69) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 11 Jun 2026 10:40:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wIqF0Smrj+oK2MNwevrKqyAJUIEFPT/jUBmEExOLl3faj70sMukMIrr+7sZz7dxJPqsswKGRKfW6D/+iOqIYGhaWLc+IpMKGIzs8b2nUWbwdNsmZC6aj9x4ouAnrjVYpg5xhdQ6wii9xDi+kLVoG2r4/I8LbhhyYmXCR9nSKRa79VQbJtImvNLYQG5ps3UtnjPA9JA9ZPLf6MgcSUpuloBI/LaRkSGmp0Z71UKC+EUFrid00qGiC3tAOg7jgQOVJRLzBcl4Bdie2WYDNyhobrviftnllDPJ5tltMiy0f1iv6Q/V0aVaw6F0EXuE5dd2Yn9W+Kn2PtnHYjRRVAQTZ2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=71QHYlW8aRLG+Q6rdQCnaOr6PanBu/rbjTdS1vzEC+Y=;
 b=QDc1Cj7LrP0fISvp1zp7XIxhXGbHac17FHcxyizuDHsGj1QKx6uNbNe+1LeE9k/AehqPUdua+kStksvkzYi1s2RnGIsVcPTSVaPGwHTaopIuKfKv4QxTEqKpRpMTeQPZ/ROy7zxADenaU1bQq/VlwZ3OB8hIDNjj8is/aBZDcD210TnjF8W66lznMpuaqE7jUsFliyK9bz6UhGgqSKQ5NZ/ZWtbyH8FqS+lzsP2tXprbN3wkGsi9y0SgQajLXgBXUxMeiaGavgkajJy0rBe6Y3DUWEcWJnLnmFXJJuMWNsMVt5w2N6XDbd333HUaE9dOFxDJCbuDnxsY+Jw++CLTxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by PH0PR11MB5032.namprd11.prod.outlook.com (2603:10b6:510:3a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.14; Thu, 11 Jun
 2026 17:40:38 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%7]) with mapi id 15.21.0113.013; Thu, 11 Jun 2026
 17:40:37 +0000
Date: Thu, 11 Jun 2026 10:40:36 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v7 08/14] fs,x86,mpam/resctrl: Handle change in number of
 RMIDs on each mount
Message-ID: <airzFJdQyD_Yjhfl@agluck-desk3>
References: <20260601195632.15876-1-tony.luck@intel.com>
 <20260601195632.15876-9-tony.luck@intel.com>
 <2cd8dcac-9257-413e-b345-7c78bd77043f@intel.com>
 <aiiMfPwk1oDD_2MI@agluck-desk3>
 <c46d7e2f-e247-4838-b265-e22b3791d1c9@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <c46d7e2f-e247-4838-b265-e22b3791d1c9@intel.com>
X-ClientProxiedBy: BY3PR04CA0017.namprd04.prod.outlook.com
 (2603:10b6:a03:217::22) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|PH0PR11MB5032:EE_
X-MS-Office365-Filtering-Correlation-Id: b5309553-e178-46cb-c488-08dec7e08c7a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|23010399003|18002099003|22082099003|4143699003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info: su2j8B8ItNwK8PLr8kGurNkIUBTkrDbQEJOA5712yszYBCts9xq+RuPE8tYKMF5CUpMy60ek3nPghzTxZeHPEoqq1G9pR6SVgT2aFQB7dTSeaRJOir8QrCFl0aNArwu+xFtemS+3nDAIhDYYCJdbgSCflmzPLiFb+Np0qRkyERE4H53Y+mYiFzxgTmIPbsb8C5uODFLCVbIq0I2GzZeTq/WeLcvtruvlT5tw5prMjnYp5dmpAUWIgUB0rCL4+cdi3SQgvrbSA9zXDboYjiwsB3BmLjMk32bnQAALbHtS961g770GWBoupduOoMjXMsmyq2SxPQCIF29VsDMBP4lNk3KY2L/ELe9OYBnPSOovmXrloEbm1f5EDQSBDv7BT4Z10K3TtLCCUP8N8Xug6b+BicvrCJ4ZD4uhKrQl5hrxlvyuQ7OZfsWrawRP1pReh5CFw0CQJG49fj//JIXJd2NH4ZFLKTFJrlClE/CENJe0rpWagE8oMprVPCtlWl77MH2ajA4ZWwv2O6ZNZ3Q+CD9wcnZha5sm8L7Jy/yQcTEzaw3iT89idedwYJZS68h/bdZmQAlzwzTXDa/tMZHPbw+k1JsD1D8Tud9l4ZJBwQaSP4HVjozwxz2ljd2LAj2MVDecTTSV4JrlLrLsQ9YMczHJm+QC86NqGlOYA6D2Vtug2rSqyX9EyqArmtO71PTY9vmn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(23010399003)(18002099003)(22082099003)(4143699003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ASHEFUHWNWMNgfIs2EEaxXxj+FObzat3i4TEk+vayQCZU8xkWtg2d4cgN5K9?=
 =?us-ascii?Q?Lpf8NBRzbs6Yh9ceaf39DgxXyredC1gBnfgS+ZtsYG2zUd2c1TJ3Np4LQYKG?=
 =?us-ascii?Q?yIYgr/TSPYR3gvo/s66P3DkWxuJZwf3muU3nguMbncac3lYLaxllk0H/iqXS?=
 =?us-ascii?Q?wMe+LGHzmCcaTGdiioFlDvGGvL0em4zvFjerSskm38YnG0szLa4L2G6R7BPs?=
 =?us-ascii?Q?nxdgqRWkzgqBmoFfcOJhcybT7KbYnA0nnlif4RXBQbNtd19R2d3cXEMoZIWO?=
 =?us-ascii?Q?0XOnLpOW14DQADvNrU7V2bNSFh3eslsLiTeLW2tyw34ZuWLFZCzAWWit+Ni+?=
 =?us-ascii?Q?x4CznwOiNYS2UNjtaFL9ZaSByH/4FtcbXMLxYFQ23H3cu4g+vPMEerCdguNz?=
 =?us-ascii?Q?DXTskhdb4pJslsip3SDNgVsWvwROfTbISX7ASFgEOkuSToeBsskxVIa+2K4e?=
 =?us-ascii?Q?bOJJd75DLMz4fTBpbFCoXIXyMOxct0TbV4YXEigqhLNb/afrTMb3lyjlBgy1?=
 =?us-ascii?Q?0wduc7OkbZHusxTJHcnYwgUI/tZdaQSbj46oMb9Tx5pNY3rcREIEwSGI0IhT?=
 =?us-ascii?Q?C3g7UoaqpZx8BpUUkZMeiDik4PPVveGN2XylG7QwD0UF5RzwWW7i4c6Id/W/?=
 =?us-ascii?Q?QLfD4YFuJxSSJNGlTESRAdrNbzYf9dQspcbExG4WKsS9kgwfjfc3cPfMUxBE?=
 =?us-ascii?Q?NGG0p0TbxzUe1/QGpNmKzR259vKIqNCp7+K6WPO3rI1epU41oRvbO0sQgCjV?=
 =?us-ascii?Q?G8xTU10pgzbsmDKf2hW7QOTOe6aTEwkTi/Rssdx9HfClRxoqoy4vCh+WDy2i?=
 =?us-ascii?Q?TMs1munFQogMjNbddaTfvTA5PXblmi2rsN3vg03a3NAPXI+UcsE1Q2ZHWi80?=
 =?us-ascii?Q?JG1wo6Fz+ZtTdLTUaNoXPaiDH0akGh2b5TpREkUKFq9PrhW7W2dCFyzgpfq8?=
 =?us-ascii?Q?v1bR8TsglpYTtJO/+/jype81g6oNJA+rnPSuvKsSnDVHHv93Op+Fm6bJbk8H?=
 =?us-ascii?Q?U3zJmT3I+LKAfJFiOa959q8cfFO+kTlT0ZNTITGtrdQ6vOt3HF7LhvIt+tld?=
 =?us-ascii?Q?heuwBpB/5sCjwfPtElqU+Zl7zarVPyj+l1TH1exFEoncWkSzR+26TJIYeUS0?=
 =?us-ascii?Q?LxTL2CAlrEwNfOqXJ85lQTAxdUjUIDBlby6uUnC1jzVQhyeILDrTLwEvcTUd?=
 =?us-ascii?Q?yTGkISfHDa+6WSlTX7Z6l3RsaetT0S5WAWa9+3mfzIHP4b2evzL5yJ8ukYXA?=
 =?us-ascii?Q?vtt+g8bLOIGv1c0epG0QLnwYwZTP1BaSoLasA5ePt4cwL1Jps8R3JgPO+liz?=
 =?us-ascii?Q?Q/tEPq6XlkF6AXhiBtSCl8gPD5Svw8yft/n/icDq2x2kSi9++T2Daa/7g+FC?=
 =?us-ascii?Q?VJEZV2agIqL3uhC4vbtimuK69rBSzkM7FHwBOIB2Htinq7f3jORY1GziE6cJ?=
 =?us-ascii?Q?iIGMT+3ZIK0b4VzaD9nqVRVnYgOXpEJs3UW3F0CLFhL1aUW4eHJHyhHaHECp?=
 =?us-ascii?Q?/FJzdk4m3/QcsgMh9D/C6IoR/SJ/DBdNexaVbTIsLh+DA7AJTfVlbdC3BNbd?=
 =?us-ascii?Q?JOW8DTq+82B13KWKTS30h0fDdpcKaXDgT5sb4InSokou/+GakBWBNMPoM2no?=
 =?us-ascii?Q?sxp+1jIzmEc16BrwFBOtDTEVntdxu+CQRXhCtkX2RhdgZGCgRSqzSIGGzZzR?=
 =?us-ascii?Q?oDM+0XvvVVCY0pZ+ZGX7VN3xQueo3LZjb1JUq5qv+mBH7TdXg/RN42MMTarU?=
 =?us-ascii?Q?+WWG50Iw1g=3D=3D?=
X-Exchange-RoutingPolicyChecked: CzhFYsez/+d+gImntmmuDItGzvx30orA0ArZBngNV2reGZB8iC9BCFzF7Gil6tawX75H8vLakcmcCEeWDo6LH2A3aXKTiD4ZNo6vkzkourPsJV9M24l6P7OFa18XP4BDxlsR+xTVryUZ6RhcGdh9Sxjxwt+odQJr9GqyAjG61e+9qdyl5+fcN4f0VZb1SEkHhtn05yhP2wg4quUZ3O/+WZUovDHI9tDpFrOeqZnQo+wGXUb44EVaNOrSl1MS693mHOCYjXPNIAe7mG195+r1zea1qZm3PVdST0XdacEWZSa+m8LqJhOxIdDaV5rTx6Rqov8ra1n/nfjQoHt/LZC5ow==
X-MS-Exchange-CrossTenant-Network-Message-Id: b5309553-e178-46cb-c488-08dec7e08c7a
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2026 17:40:37.8323
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZkA1K1b+HTcUXqmhhldJD6Ujf/S5dhQO27QL3lyhlUAbAcr/n3oHwjatd/oMLyfX9uoIeUhnO/hSy2c6xyzSpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5032
X-OriginatorOrg: intel.com

On Tue, Jun 09, 2026 at 04:35:42PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 6/9/26 2:58 PM, Luck, Tony wrote:
> > On Mon, Jun 08, 2026 at 04:21:10PM -0700, Reinette Chatre wrote:
> >> Hi Tony,
> >>
> > Changed the Subject: tag to "mpam,x86,fs/resctrl" to match what you used
> > for the RFC discussion. I think the implied rule is "architectures first
> > in alphabetical order, filesystem last".
> 
> After seeing the RFC discussions I do not think what I did in PoC is ideal.
> MPAM is the name of the Arm feature and soon there will also be RISC-V with its
> "Ssqosid" and "QBQRI" features. Since we currently have x86 as established
> prefix for the PQoS and RDT features it may be more appropriate and simpler
> to instead use something like "arm,riscv,x86,fs/resctrl" if such global
> change is ever needed? It still follows your implied rule of "architectures
> first in alphabetical order" ... but it instead actually uses the architecture
> names and not a mix of feature and architecture names. I am not dictating here
> and open to suggestions.

This sounds good. I'll switch to "arm,x86,fs/resctrl" for the patches in
this series that touch three places.
> 
> > 
> >> On 6/1/26 12:56 PM, Tony Luck wrote:
> ...
> >>> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
> >>> index 327e7a863614..b374e2f84a75 100644
> >>> --- a/fs/resctrl/monitor.c
> >>> +++ b/fs/resctrl/monitor.c
> >>> @@ -115,10 +115,17 @@ static inline struct rmid_entry *__rmid_entry(u32 idx)
> >>>  
> >>>  static void limbo_release_entry(struct rmid_entry *entry)
> >>>  {
> >>> +	u32 idx_limit = resctrl_arch_system_num_rmid_idx();
> >>
> >> Having the code switch idx_limit to sometimes be resctrl_arch_system_num_rmid_idx()
> >> and other times resctrl_arch_system_max_rmid_idx() makes this change difficult to
> >> follow. I think it will help to use different variable names to differentiate 
> >> the context in which it is being used and not leave reader trying to understand
> >> why there are *two* limits.
> > 
> > I'll change the local variable name to max_idx_limit when dealing with
> > the max value rather than the current. setup_rmid_lru_list() will have
> > both variables since max_idx_limit is used for allocation, and idx_limit
> > to add the right number to rmid_free_lru list. Added a comment to
> > __check_limbo() explaining why max RMID is used there. I think the other
> > spots are easy to see why.
> What do you think of "min_idx_limit" instead of "idx_limit" to complement
> the "max_idx_limit" while reflecting that it is the limit that is common 
> (hence "minimum") among all monitoring resources?

min_idx_limit nicely matches max_idx_limit. current_idx_limit could also
be a contender (though it is longer, and "current" might not obviously
refer to the mount/unmount cycle).

I think I'll switch to min_idx_limit.
> 
> Reinette
