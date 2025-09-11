Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D6332D7806
	for <patches@lists.linux.dev>; Thu, 11 Sep 2025 22:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757629616; cv=fail; b=dfbEJ0Zgek9LRt6vPGtgHWhWKzZfw8e0QJRAI+52wXIDvEBvPzJW/mk/WVyqXNd1EOapCijzsYt/Fd2KQP5cEpYpb7wqmg0fLeAdccSpJ8lhTvc5ZFrxZopzRUe+oqTNdXk3ELIlhCsLLJvvXAcZYgc2W62po+0jd9HoO/QdBuM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757629616; c=relaxed/simple;
	bh=NqjhRycOgt4O8rwnY2+EUCLSIHFcgHlnfPAjCfZ9kTI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=VJNCQf79CyijNhdBnL8U87DADBVhNIj6Wk7cRhVyqAcJhiVOsI0iAtgAjYc/GeGZEVTXchVSD8eaN0gJ/1wfByhyIuJo2NjqRt6y3mGJ7LWnwolEzuVOd3LB8VaFqNyq5d6xdOqcYgL4n99F3SS39dIor7ZO2dDmJbfNyC1unNg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aM7ERKms; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aM7ERKms"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757629615; x=1789165615;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=NqjhRycOgt4O8rwnY2+EUCLSIHFcgHlnfPAjCfZ9kTI=;
  b=aM7ERKms2ASAtjoHycoZo3RrA5Wnic8j8GmO1dMXEXN+ibIO4mAGmPdH
   zurJQlv/MTCFflDGkK+RZB1GIX1jdqc/34JTLtyK5ypQHaFR8l5Sif+nJ
   40H/KroVnuw8gLbeq6n4Eurdx7YgaRphpZl78I0sPcgo27Oq+kpXhzZiL
   cuAk6P5+E8synbGpKhmoDBW8BxzYuZ2ng3579QXZP2d00Qvd7bvSKrONL
   XcdYXnEDk9Rg8hgdUvkkgLH6h6UnnWJE5RukxPMpxhhieBkAZSbsvCgQo
   cjOg+JZYQ1DD8ZOOPBEVPVrE1pLQHzB8li7Vt8Q47lhEctTJHB9k/EPas
   g==;
X-CSE-ConnectionGUID: zdFs8ZxxRtyRfV9Ur0HJBw==
X-CSE-MsgGUID: BpWlIqzyRz6rMujoMGdY9A==
X-IronPort-AV: E=McAfee;i="6800,10657,11550"; a="60084402"
X-IronPort-AV: E=Sophos;i="6.18,258,1751266800"; 
   d="scan'208";a="60084402"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2025 15:26:54 -0700
X-CSE-ConnectionGUID: nno8gXrJTUOta4Us5OwRUg==
X-CSE-MsgGUID: TjzVBSCCRwGE28wNtD8vvQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,258,1751266800"; 
   d="scan'208";a="173880797"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2025 15:26:54 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 11 Sep 2025 15:26:53 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 11 Sep 2025 15:26:53 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.61)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 11 Sep 2025 15:26:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Fv/JcB6wjG6kZktYYmv3nmu0PD45vK0ElOkoX72e05fvm5PzvRu0NTzpFTO8jPgQBZql0wUN6iNU1cnSt8ZXC13gxB4P2V/KqV0n7hG6H13QMjvnQkM2G4JN8wCuTbzPYKVp7vyofCLwPV/oHJxs+a5LqAFL2KttjfwdLBNp2/PnEDQtNDMDwMnBALXovHXxUwHFr1HWfBJ/eIcFnB39MgMbEOB64xv24AtpD+AFHJLTLvW2P/Den+rtj5LCQ/NLQzKsbvHTT8BrVZQV8qeNEaKR8PMDILnNO76DgD8jRzEKJgUluIx2pwOBxWhmYe9PUNCJ+MEYnD13RpXmmQRQ5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LLHlIeQN7IqtgCbYmEQi88TM3M6GN4cEylgwkylkSaQ=;
 b=d7rSk/mGeXNfNjnfVv/SBf/ilVSbc0OQGh+GRxplm9KHKhK1dSUFY3wUFYa09QLpYJ9sw52m4dRpjG2HBXEl08sdFGy7XYHeD5iG3SFhS2ZpsLuEsZb0Y9pTzdzw2QCGzuBhcrWvwcSveVbVKKuTza0C4phsQa/HtGQjK4J+1smP1H95WyPWEWiV2+X/pBnMQtNZ0rZrCmuXZHV5riQ4uuy4MIbXs0a6Z1K4MBzgRcQX1YqjZHsdGr/L9bNjgpSo/LBVxoVki1HI7DRuAdYaQ9JwP06pezJNtpeK8xu9lBIMR3KPN/PjCyc0n7G7hD1WtDYk2yZL1h8fyLjHLxHO7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by SJ0PR11MB6791.namprd11.prod.outlook.com (2603:10b6:a03:484::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Thu, 11 Sep
 2025 22:26:46 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%7]) with mapi id 15.20.9094.021; Thu, 11 Sep 2025
 22:26:46 +0000
Date: Thu, 11 Sep 2025 15:26:44 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>, James Morse
	<james.morse@arm.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v9 25/31] fs/resctrl: Move allocation/free of
 closid_num_dirty_rmid
Message-ID: <aMNMpMns47RkJZg-@agluck-desk3>
References: <20250829193346.31565-1-tony.luck@intel.com>
 <20250829193346.31565-26-tony.luck@intel.com>
 <3ecedad8-6283-4141-9f44-2ac126796ceb@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <3ecedad8-6283-4141-9f44-2ac126796ceb@intel.com>
X-ClientProxiedBy: SJ0PR05CA0190.namprd05.prod.outlook.com
 (2603:10b6:a03:330::15) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|SJ0PR11MB6791:EE_
X-MS-Office365-Filtering-Correlation-Id: 40a683fb-7f7e-4a34-5a77-08ddf1824ae8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?wwoZA5nsklFu1URlZFLpx3nobHyv6dzZaEz43IjNCnAlcqMIw5X/4ih0PHWT?=
 =?us-ascii?Q?SZUgjiP3sAMQwfQFgWpZBB+cZCW/iPEZTyv5N4ua1zD2GoJ371IXUyNtrdBL?=
 =?us-ascii?Q?sciKJ09O0E1IXBlv4eJ8jg94m7B7sX4wxt2lvru7rwBl5yF/3MHHhEqs4On8?=
 =?us-ascii?Q?f79e1lUjDXBk54nWB+0bPDS25CVjjGhTIb9bvt+Qp7prVvslBNWTclE7iQSP?=
 =?us-ascii?Q?9Nf1JbXEpqJIpfwswyqgNkUp2RK2dXb1LCl/1cPfO6jSxRaI1akG9gG4t01k?=
 =?us-ascii?Q?d0h27vC82jK5ttfdzCDehIZTqGmTPXxJIS1bGdFAsMb4iloT1T1U9TdfecNf?=
 =?us-ascii?Q?bYq/mDvS1GuD+oL+sKmoHZhaSPhdEhHRLhwnUOVmrNg3AG87zdtyGfuSz95R?=
 =?us-ascii?Q?qc6oBv3+uJYc7k7PVAqkLWX64egNHgkjX2p3/xrloypRagXAetyxDKox/ko5?=
 =?us-ascii?Q?ACQtyAo4Zo+YcGRPMV4i+8hpDNKhgZFadB6hgjWy7HHLuR/PHEAAO/uDBxWz?=
 =?us-ascii?Q?MF/5DLOlDvKkEj1/7KlMq2ggbSMv6f6NFnON8HIIl+j2cpZvRiLvqN/R3BOc?=
 =?us-ascii?Q?FABl6nhDZj8DmLjKkyj/T5Acbh4kRHF2+2JaIUqg/r46yg37yix7LU8+P2Vs?=
 =?us-ascii?Q?EmJqx58Mi7QrPlMReaBylveHoc64cqYfdRZcTUnWxQvfO6u4noyOcnuy9Dqg?=
 =?us-ascii?Q?ZHsHapdaW7x2KsV2kp2xCHki5inWTK9ZBAqgOpry56ID25TDEC75Gjvtmtpj?=
 =?us-ascii?Q?wB1yobftkcf3tRq3t9Wn6CIWS99eZsHsrF1pvDN+wD9Qt7fvx36YVlru3d5b?=
 =?us-ascii?Q?YiAPT41lLPqdAp1me2/1qqdEyIc6nmVJLRFF62yetTbKHaYK34XbpTX6xTqa?=
 =?us-ascii?Q?YZLmJZ1kREVjhfO84bjaYWZt9T+eitBfbShCaREjldwE4i22Y9rKocV4+6GY?=
 =?us-ascii?Q?tl+fV5VEE829o5RgCCIc5fdU7qZ5L0GJcabQ2GeIxRt2iGP+25+555ii8oT0?=
 =?us-ascii?Q?xA7GJHQ5OU0Hmqhi8RdLN6z1xLqhJlAZW/16npgDv2pFfrhTsvMwJNSiZZe5?=
 =?us-ascii?Q?sYuTjlKHZauVX0rLpkcAq8r+mFj76fdfyqpo9xjuE20IpZJ5j83kRVsSijsX?=
 =?us-ascii?Q?3g0R4W94QB5KjN4F/pmdx0H2KUmh1DV65Zai1S1yCIhd6NOU1H3J31LmDfDD?=
 =?us-ascii?Q?wwSCrVuKh/CCT8qRdbIgxEtSVgJHQzH5f2tTziNcQ6PvMvz7QAd4Trsh8IuV?=
 =?us-ascii?Q?idS3Qq7Jqx2yelyZQqWD/m2K/7dCNeHwP7C5kx06iFNWXOyWmDEuvt5QmZnR?=
 =?us-ascii?Q?hU9DBFRwG2SSy+n/iHm9hXBzfSa9JRZ7zmLFQqOEQmasy6w+t0SOf1oAoBGc?=
 =?us-ascii?Q?KL9KpUFkiZugpL5Tgvmx7hZPWn7Of5QELkFTVFw8s9BOYfDOZ5tfEp8u8k5/?=
 =?us-ascii?Q?A0OjTeWS8oI=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?znsVdLQl2RxCCzQh5XFDcrWPcGd66jbLmHxEbBvNwuJ3JI3xSu8eoMEtSmt3?=
 =?us-ascii?Q?7+1Ngr3DtJyWmEnlnjiS565u2Zg7oaAVn4GTe5qIyFehm0zOYcR/Unk+8+mf?=
 =?us-ascii?Q?qBPkyrFQuSDT5aGoJj/enADNbdrFoklWArPsiCLnpiXnVedURux06laBEMZe?=
 =?us-ascii?Q?4qCrIrwf0PcfUgkc07CYHYnU3jMAwyBSXxKn/O4KA8Qf44Xj2iaVDc336GgX?=
 =?us-ascii?Q?UScFUJWe0noKQJusp4qk9foR1M9JxW680QsJga7KBvFlGQxqVfWts4Uc7JYw?=
 =?us-ascii?Q?dqon4AWze9Wvxpu+/OdIzwWpVXvX96JGhnC4ZqgTlMbWz/xAPGbYNV0lNjIz?=
 =?us-ascii?Q?vO1qqIJuJNkqSvuVLZmZc6RqRpRPMoRmAbsm0ev5IF9eRofqD9IQxAGHNz3+?=
 =?us-ascii?Q?L45cljyqkgMGbi7D+eaW7Y9BFDcxYQfZnGlBBNi4ArOb7kOG5gtoeEoUZZYt?=
 =?us-ascii?Q?Lhe+G23vCTcBXuABJwqwt26DZCwICy4tAy711ST/0rDBvD3Zxts9nmG8qOIi?=
 =?us-ascii?Q?vcjNAnHTpMaeO3HLSo30L1CGJbeuDt9whLjWok/GAYN8cDA7Kj9DYnB07LMy?=
 =?us-ascii?Q?mCbxM1OfbPjO0OKLtAM1UcMWvuve4Q67HljVOz70j1ifAbacfbhAyBK6Ruth?=
 =?us-ascii?Q?QwOrO2m41gDFeNkeQ9h2AmZgNVpq4e18BRxWBBSmrEV5gw9fHdJLv+c+63US?=
 =?us-ascii?Q?0QXV+JocUgEaGyuksupsloriTLD4Br98bK+GTZjnN3s/b7hMQAvOKoA3fCxo?=
 =?us-ascii?Q?6XvBrw3YX545OJUT302Do2mHRK7DG8J22pEw6r/Anu2x4nAkZ03RnhZDW+NP?=
 =?us-ascii?Q?VD9FudCBDC9mxAuartoh8tqn/0P5GoUhiCXwDAKMVXVEvzFMa3W1yjv9SlEu?=
 =?us-ascii?Q?2Ai1REMnc0HoA31kUK+BTgDcQujKK2EIfES8eSGbZVmt82BYouuXnBErn/l6?=
 =?us-ascii?Q?+Q9UCtZZZK8Obgi+CuXWA3TVxAqHWNi8u4qLtRqsuGsldBrRSck1bdp+ZteQ?=
 =?us-ascii?Q?58/5B0llE58gBp3lAuzpTETw3j/mbvz+pIZj0zlkxqss+2bdd8GcXUpr1gl/?=
 =?us-ascii?Q?jr8/yonxACxBiipi4F8tziHtuKIVd6xkHjwz45C5nkWiq/D7Ych3mbR0iRyy?=
 =?us-ascii?Q?aNgNitdEpCdesdeT81+JzeI/DWe9pmY5i8faVF8j2GeDaBvWSqtGw7M6ka7n?=
 =?us-ascii?Q?wTngUc0myV9RkmZyH4Osozqhnl1Sx4TfqwmP1YNxuK1aBcQ3c885XFtnHpwm?=
 =?us-ascii?Q?bqOX4S0MlnwpJVQKtS3L32TMNhRkX/rHlBPgCQ76T+0PTqS88DYZWg0srmN3?=
 =?us-ascii?Q?e472XigH7nXAydC0dB6wyydkV7LOxrGGMTizA6sRZ1EU3TILulkOSqxUVMD+?=
 =?us-ascii?Q?VQPcOQVT73bGyNqQlN6rVhpRfQpnUFE4QqQJ73mKlOVUzQArTxz7qSKrvqQ/?=
 =?us-ascii?Q?Tp3H8IWA79A1kYZZICvfp/EoEoLLmMd0J9/6saW0wND9HXtyBT3Knk+UmMym?=
 =?us-ascii?Q?ZTpkh+QQuKK9baNgQh+vwn/GsEPE6AnBixrgC9DEqWJcto2v2AGZGWA8AJ7v?=
 =?us-ascii?Q?TjAp3QN3L8TnDqOit06LWJkd4ThZB8dL1k5CHLIm?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 40a683fb-7f7e-4a34-5a77-08ddf1824ae8
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2025 22:26:46.2467
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7cpJuazAapm+TFr11ZfAFSWRuzRONPexpLEcqt/sCX4czfV154i5tYXE6jh8GCioDs2Dz0Vlw+gHGfy5+VxxYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6791
X-OriginatorOrg: intel.com

On Wed, Sep 10, 2025 at 10:55:23AM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> In subject:
> closid_num_dirty_rmid -> closid_num_dirty_rmid[]
> 
> On 8/29/25 12:33 PM, Tony Luck wrote:
> > closid_num_dirty_rmid[] is allocated in dom_data_init() during resctrl
> > initialization and freed by dom_data_exit() during resctrl exit giving
> > it the same life cycle as rmid_ptrs[].
> > 
> > Move closid_num_dirty_rmid[] allocaction/free out to
> > resctrl_l3_mon_resource_init() and resctrl_l3_mon_resource_exit() in
> > preparation for rmid_ptrs[] to be allocated on resctrl mount in support
> > of the new telemetry events.
> > 
> > Signed-off-by: Tony Luck <tony.luck@intel.com>
> > ---
> >  fs/resctrl/monitor.c | 56 ++++++++++++++++++++++----------------------
> >  1 file changed, 28 insertions(+), 28 deletions(-)
> > 
> > diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
> > index 33432a7f56da..d5b96aca5d03 100644
> > --- a/fs/resctrl/monitor.c
> > +++ b/fs/resctrl/monitor.c
> > @@ -805,36 +805,14 @@ void mbm_setup_overflow_handler(struct rdt_l3_mon_domain *dom, unsigned long del
> >  static int dom_data_init(struct rdt_resource *r)
> >  {
> >  	u32 idx_limit = resctrl_arch_system_num_rmid_idx();
> > -	u32 num_closid = resctrl_arch_get_num_closid(r);
> >  	struct rmid_entry *entry = NULL;
> >  	int err = 0, i;
> >  	u32 idx;
> >  
> >  	mutex_lock(&rdtgroup_mutex);
> 
> mutex is held during original allocation code below ...
> 
> > -	if (IS_ENABLED(CONFIG_RESCTRL_RMID_DEPENDS_ON_CLOSID)) {
> > -		u32 *tmp;
> > -
> > -		/*
> > -		 * If the architecture hasn't provided a sanitised value here,
> > -		 * this may result in larger arrays than necessary. Resctrl will
> > -		 * use a smaller system wide value based on the resources in
> > -		 * use.
> > -		 */
> > -		tmp = kcalloc(num_closid, sizeof(*tmp), GFP_KERNEL);
> > -		if (!tmp) {
> > -			err = -ENOMEM;
> > -			goto out_unlock;
> > -		}
> > -
> > -		closid_num_dirty_rmid = tmp;
> > -	}

James,

While refactoring code, I missed moving the mutex_lock(&rdtgroup_mutex);
that was protecting the allocation of "closid_num_dirty_rmid[]" ... and
Reinette caught this change.

But looking at the code, I'm not at all sure what protection is needed
for the allocation/free of this array. The current calling sequence for
allocation is:

Linux late_init
    resctrl_arch_late_init()
	resctrl_init()
	    resctrl_l3_mon_resource_init
		 dom_data_init()

which doesn't appear to provide any scope for other CPUs to come in and
start using closid_num_dirty_rmid[]

The free path also seems safe too, as all resctrl functions should
be shutdown before calling:

resctrl_arch_exit()
    resctrl_exit()
	resctrl_l3_mon_resource_exit()
	    dom_data_exit()

and if they were not, holding the rdtgroup_mutex around:

	kfree(closid_num_dirty_rmid);
	closid_num_dirty_rmid = NULL;

would do nothing to prevent some still active resctrl function
from tripping over a NULL pointer.


So, unless I'm missing something, I'm planning to address Reinette's
find by documenting inmy commit message that holding rdtgroup_mutex
has always been unnecessary, so it is dropped as part of this refactor.

-Tony
