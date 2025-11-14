Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C8932FB085
	for <patches@lists.linux.dev>; Fri, 14 Nov 2025 21:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763157363; cv=fail; b=W1AWA13iwYA3U6hltd7h+4uuYD94Mv0YtAGf57hqM2yYxOV0DKh+2NZL2KF+7ft6fGiyvBWboL3uthfU72G5ymZQCxZVNGlP9vptn9wHCkQg3z4eozSJXwuBGwVQNIaf1jE8dhq5isujJwtvc0/uUrI87uV+C5+XvFWp+Ghl+1E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763157363; c=relaxed/simple;
	bh=rOIfgOyI3CknP9iylQx1oxImBwlzCYdndlEEMj+NWPs=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=feFlLCiY4N+RU/4EHswquZnIZXQwSSYr2yOJy83Ew+gCArZSyvuGG2nz+nBsOhnamfk5k2Sw1SryWysrce96HBuRaeQBG8NDckGsW+bYbbwL+yjcDzk8BEYvlCp/9qO0y99xgrern8VQMs5WiZNc4IBsU3578j8XwyXN/tVCSys=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gZ6tcyvx; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gZ6tcyvx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763157362; x=1794693362;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=rOIfgOyI3CknP9iylQx1oxImBwlzCYdndlEEMj+NWPs=;
  b=gZ6tcyvxZaYl7U1f9nmcPkuFuE082t529Oeil6vIwvO7tQce7fTToNNP
   VPAyJVWl5C5fXnLg79UIcaqOwfcVR48Pd5oh/S3jP53PrB9M5/+SqSjNG
   iI+s2M7GdP6/g4Zl+M6VhlTkXpVYMZ2PitG8H8p8mnm08U9VYBS49RjEy
   CC3PwV9ALlrVGl9E72ui1iRM24fIkmXXDfoi19aPxVwphX5Vsu3BOqreL
   H93qnperjIIwhVL2rzIIMTDFTLAmdfPXagZ5ty6APTvP+cTCLPNZqQc3C
   jEqy55DL6+WkjBkSoTFvp6hWPNvTHoxwTrgqEynMyEEs0c8Zjq3tOwJL/
   Q==;
X-CSE-ConnectionGUID: Xx8oGSKlSV+gnCaSVt6H6w==
X-CSE-MsgGUID: nURr0ekyQp6ZE92W7nm+rQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11613"; a="90736455"
X-IronPort-AV: E=Sophos;i="6.19,306,1754982000"; 
   d="scan'208";a="90736455"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2025 13:56:01 -0800
X-CSE-ConnectionGUID: kOLGwjjkTHaxjuNkJhVY/Q==
X-CSE-MsgGUID: yVSahF00STis4h3GXAsoQw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,306,1754982000"; 
   d="scan'208";a="194865659"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2025 13:56:02 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 14 Nov 2025 13:56:01 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 14 Nov 2025 13:56:01 -0800
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.46) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 14 Nov 2025 13:56:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XbLv/248N3EVfZPSz0gymYXAQpd0UwQCNDleOrp4ONWWaBsWfXvMNgaODLafWQ3CThY1yyoB7xnPk2q0416mr11EfBNFw1af0fbETeJEi1UvhPsE/hf/3JfHpwKkwUu0Yy4ykbt5zz5hNovTS1VeK+wkHdj0JeMJTcHwICJQvcEbTRmGof9ZCUyxYWKOLAvodmcCLFjXRrDTROSEJZR9qfaonzZ6TnC6k005hM1yg5QA4A2wCoQF0dT3gBLVsct8K2MQMQ0BJ1ji0a1oOiQy/UUL1x7OxqaLHYFUwS4NhgMtWOcQ6uCVJa+v+nifDam27anWltLHIGK8lJoB4/ecRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c3ZFkCNbd5D4VENrDyTWd62nWtWc43MUtU4X2CLDqU8=;
 b=idYlCN7z0XcGcFaz/ZpQjxClrZgSTYGxzyDZkSJzN5wRNYteVAdOFMSnOQ/6QxOwxb+RL7zWwfT0jViCflk/1gPSEMhJZT4DR/W+pwptOHvRBeoNEe5oceLqdn6ZsJ1C9We7EvhYYezhcbMD3/zvx+eVl/YV17VgnCc4yFLSS0l3TfCjF0sIViltLB2ny7zEYbCfhyHzQNjTTJsV0BJ+1ImI/AJ4gKw1m7KyxDFRbQEniXoWcfHyvpTxPz1ykAZSL9YZxuynUXOVhY7yjhIKbQC1lAcEUGTv+EkoFfJ4fcz4VI4T8oBfWLNT8Y+HlQ4XpVCNh+qtR7RHfOIjA5tgHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by DS7PR11MB7929.namprd11.prod.outlook.com (2603:10b6:8:e5::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.17; Fri, 14 Nov 2025 21:55:58 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%7]) with mapi id 15.20.9320.013; Fri, 14 Nov 2025
 21:55:58 +0000
Date: Fri, 14 Nov 2025 13:55:56 -0800
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v13 25/32] x86/resctrl: Handle number of RMIDs supported
 by RDT_RESOURCE_PERF_PKG
Message-ID: <aRelbFgQ4-11Xwg2@agluck-desk3>
References: <20251029162118.40604-1-tony.luck@intel.com>
 <20251029162118.40604-26-tony.luck@intel.com>
 <50149b02-d6ea-4fb2-806a-f16e80d3d52b@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <50149b02-d6ea-4fb2-806a-f16e80d3d52b@intel.com>
X-ClientProxiedBy: BY3PR04CA0016.namprd04.prod.outlook.com
 (2603:10b6:a03:217::21) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|DS7PR11MB7929:EE_
X-MS-Office365-Filtering-Correlation-Id: 61dd44f0-1e15-405e-de56-08de23c8980c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?8CSSb1ThEN0Yh4+6UdhhVV0XWdrkE+3lggYoXLqtY3U53YMmZY8JAGjwYNmW?=
 =?us-ascii?Q?2A8NFDHJXek7iuyBOLr6yNIhJ5kL215GucBCs+YRPbHAFX2Z+BGNcxIvgGor?=
 =?us-ascii?Q?yBRkHLYWKXS7O3AnGW1sPczdwq/uVNbGqpZC2KFOsxvKK2olfLE8NFnyPNkA?=
 =?us-ascii?Q?UrO2qw0FdfSmRv6n/QccTWnoPOVkWgkvqCL5dT4jUHhVpSb7YUPKqDVNceb3?=
 =?us-ascii?Q?iW/LREcYUM+ifNl/q0amxPl4C6gzWx3Q7NNFnohVwZvO34UwIQhIqibjjPtF?=
 =?us-ascii?Q?3/lp6M3xOQBfqD5mw+UMTN60afIjw9TlZ/n6FWMngjp26dH/fgmk8sEqPPoT?=
 =?us-ascii?Q?wi9aUGDcmZAKYeTFozwkWWJrQk8k3TyNu0ymzhSdaEVgSd9w4T+41GLorLt3?=
 =?us-ascii?Q?gIvTS7IjTnKQJKgVXUPDERmGRxtz0rnrKk1qXpKfYkVmgmKKn1LuhAGvlQrm?=
 =?us-ascii?Q?KQ94rkh960jV4xjY09HdDlO630k/v8+qz44XulvVwWblyOT6mDoFbb+qMi65?=
 =?us-ascii?Q?lnswmvv967QA3YRtMqT7l8iQu1MSjcQX4QDmgyqN00xbZfdKsIPB6Pzrla2X?=
 =?us-ascii?Q?laQoOWGJiaRRU63enV36QTAjrN5xm5be3ElhivyxQX+0mFVsEcUGf8uEp3or?=
 =?us-ascii?Q?A7aUL0PWPH5N80oj7zjEjJPUNyRj0+DiTYZJzSYIYnYUZ1Jq7ldo14N8r8ey?=
 =?us-ascii?Q?FH/VNDhPbi+6FnvQfoQEAgw2jISceRKV+Q5pjyzpQNlapQWrCk9QS+Zrlw91?=
 =?us-ascii?Q?m6u2zYzwF3ljjApprrpc+vOuzRs99H3QGnfFX4a3uQJ60zB+L4q6VmW8iqow?=
 =?us-ascii?Q?2kha6jPBdyd1MSsIeH8C8zd7OLDrBhIwvLKW8FJ8UtnX0L+kk0Ed2uMFkZwT?=
 =?us-ascii?Q?TWlNTP/XvvmlRT8sHZL3/DWX75cWCXPZG6Uyn4ixDsLFmaAwyWDLFZ/TMTmo?=
 =?us-ascii?Q?sTpIRhL5J4KUv33BSqgJzlNjKs1oEo5I2Q7eBrzvFHDtq7k5i3buRWR5v8Jq?=
 =?us-ascii?Q?oDCJ2XB2u953+v0jeklxbYoKayl93Ca50fEmu0OiJotxGbqNoWmB+z2S6lrQ?=
 =?us-ascii?Q?qL2W4eNSf5yeiGYEOz6S+dO9o6SSDIpGSvQByyl+bDQrpVfYSZzttdJWOrm/?=
 =?us-ascii?Q?m5bMSoAYzH/dkWgs5mfUeX8N1lLFk22lYAvMPgde2JdHkci8FrsH4JCT4/LX?=
 =?us-ascii?Q?MRnXhkXHiXZNVMnn061SAUiXI5UMOJvThUJZ1RjSyVkIoppwaecG8GihTBr1?=
 =?us-ascii?Q?lABwUOo4PFDnXQuC0aIRPiucE2yoVdSZrbBq5wlgTcFwjkm9hIHwygRq/a9L?=
 =?us-ascii?Q?JgvQ9S6hPyQaomLWuQ324Q6cEC9oURS174ku/Fq1HKaIB5TpswQNYHDMS8bt?=
 =?us-ascii?Q?rle+j+zKeN43QS2y/FND8mZuhpjVoqpEibvC/ieseRrN+6G7IHFXmCeLsYu1?=
 =?us-ascii?Q?Dh+//nwTkf7yyWj0gOJRPcZCdrITA/kd?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Hpezqj5O140hOpBnR81QGsBpPIMM+HYQxkX/SARh718yBSi+2VYpg3meVoEF?=
 =?us-ascii?Q?KkAkdFrJfIY8bVt0rIHwh9xHsx78kNSsqEPGL0NJ3QsXP5QuWRv0ePKQN5c+?=
 =?us-ascii?Q?C9iAmy1j3J8rjhG1L1DIPBQLzi7pGMrYT5BBIBQJdTorzodyWal7y4mpqWmZ?=
 =?us-ascii?Q?R7jzkFwrU1bPukO98LNbWn+ct1SggbtftkwU2D3Zkt6TbOt5oMeKAFi9Rlet?=
 =?us-ascii?Q?GhQ9A24Y8tItdydKDUot3il2Sb/RTGV85piK+Ogb94+rJlsjdSC13KZp2+m7?=
 =?us-ascii?Q?Q8Jnpgk+vQZbOdy7zrxXneSqOQ/49eZxJfevt8bxDTgZT9aNQarRbETN3dyU?=
 =?us-ascii?Q?ToT3tCIBDZ/pSpdLFFx/+D+iYClrHyO3Qx1Bc2wVVHZFYGTmMh2F6D8dlJLd?=
 =?us-ascii?Q?saF6inw8rgb2FIY7MZ4pAfdOZP1HZZfTPcsOgvBlKRAwW55BPFG9bDGGbdGI?=
 =?us-ascii?Q?Ox6eR+BfcWfYSJ2MYJmXX378vZBMZQzqtYcXdzmANZkUCJLZ6KE8kHPRxkLr?=
 =?us-ascii?Q?4O2xOlOM+hwfdmkDrKJOMJw2gjO9luTfWUjgSIfEdZgRtGaZzA0HHIgYSHep?=
 =?us-ascii?Q?Zl85/UloUIGGKDc4+Tr9N2SZKBkPNNvz9Peg4RbzUF9m6+LnQ/SXHw3tZHUn?=
 =?us-ascii?Q?QNU6vXby+vB3mN3OiK2xt4T066zuCPi5QiWuKIGMW8mMLycbBTJwzN9gOyih?=
 =?us-ascii?Q?WyAP5SbSl2S+8bjb+paduKg4PzJddS+8ydQ4wjs/bM8rgMcTtt9QMlIxNy01?=
 =?us-ascii?Q?gy7NzFpbtctj3e2SbKY6dAWTi5bYj9GWqNz16HS/GdDF1/AjsBgo9r8oMVy+?=
 =?us-ascii?Q?/zxnoUXxLrb7O1F8HZm32ZqegIbtYQRF+gZbkkjngdgknFyNEfVcvDChEnK+?=
 =?us-ascii?Q?iXiD1TNnMAllvTUyXztR68nhU1SVnu+loAI4RfWl10vEzIefJT6DCArji/Sx?=
 =?us-ascii?Q?lNA2LTYv7HultrM2yvP+7FQzhPzKbuf2CrJibm/Xi+1ypmAXT84Mklwn8iMh?=
 =?us-ascii?Q?ywf41p5gU3wYW6pOuWunc9ekdn35vIMtvSyT/FQi3UzYI2P9nJ0SnLlc8La+?=
 =?us-ascii?Q?HjvprYh/u/MsMydSaiKMbmEcHKI2ye5k2c2mfjsYbmskUcJQ7HJp0YNu555V?=
 =?us-ascii?Q?iqQm6mYy8/faMPL0p/tcCU2p69xYiDXaqNgfJcPv5IwSjrlGiEo35L6DH8bs?=
 =?us-ascii?Q?i7I3GSsdFvIls87IE/z9NtnDYkR6iDCvqwY+oFrHI4S3IZP4WCCJKVKug2yu?=
 =?us-ascii?Q?NPFlqXBeXIj3pFLldulsb3KN+7E+8svYopwgx/NB402WWK1OzwPPJH3wmDjA?=
 =?us-ascii?Q?2zoUzg9BvpZ0Pkfg++6zJIjYjbBOJQSR7lLQ9UAqdLarvCHDTF7K3RPZGBb9?=
 =?us-ascii?Q?TqlMti4Nag8JyWesMWkMS6vCK3ei4zF1cr54Jv679w7FrHoxj7dNc59gXGsk?=
 =?us-ascii?Q?t3r3StaoMLFVT+jhs0sCgtRp3zXTSpUSV/72F56+72RLFmDJZwZaP3ItThiK?=
 =?us-ascii?Q?2nub9rq/rdJi0ISaJCSNjnx6Dp5KtitATPxvhl22vN3yrq13VUZ21I3T2IHz?=
 =?us-ascii?Q?CjmmCu+cBoPxIbOsG/gvieVTEtLQ0UjMtR2ejJ55?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 61dd44f0-1e15-405e-de56-08de23c8980c
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2025 21:55:58.6195
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zO1T81o6rOuOB5nWKQPpauSccxuS+mI48qSEPgtjdDwxEH5ka4/013E9LzV2v6BcsfgRs1gcFXvGe862/4OTVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7929
X-OriginatorOrg: intel.com

On Thu, Nov 13, 2025 at 02:51:45PM -0800, Reinette Chatre wrote:
> >  static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
> >  {
> > +	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
> > +
> >  	if (!group_has_usable_regions(e, p))
> >  		return false;
> >  
> > +	/* Disable feature if insufficient RMIDs */
> > +	if (!all_regions_have_sufficient_rmid(e, p))
> > +		rdt_set_feature_disabled(e->name);
> > +
> > +	/* User can override above disable from kernel command line */
> > +	if (!rdt_is_feature_enabled(e->name))
> > +		return false;
> 
> Considering this from the user's perspective I do not think there is an easy way for user space
> to know that the feature was force disabled and that there is an option to override this.
> What is the use case considered here? If I understand correctly there may be a way to deduce this
> by consulting files in /sys/class/intel_pmt/ where the telemetry regions' number of supported
> RMID is printed. A user can compare that to the XML files to determine that there is an issue
> that can explain resctrl not exposing the feature. Considering this difficulty I wonder if it
> may be helpful to print an error message here? This is of course not perfect since the kernel
> log cannot be guaranteed to forever contain it ... but it may help?

Reinette,

Good idea. Here's a draft. Comments welcome to improve the user message
that would look like:

resctrl: Feature energy guid=0x26696143 not enabled due to insufficient RMIDs


static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
{
	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
	bool warn_disable = false;

	if (!group_has_usable_regions(e, p))
		return false;

	/* Disable feature if insufficient RMIDs */
	if (!all_regions_have_sufficient_rmid(e, p)) {
		warn_disable = true;
		rdt_set_feature_disabled(e->name);
	}

	/* User can override above disable from kernel command line */
	if (!rdt_is_feature_enabled(e->name)) {
		if (warn_disable)
			pr_info("Feature %s guid=0x%x not enabled due to insufficient RMIDs\n",
				e->name, e->guid);
		return false;
	}
	...
}

-Tony
