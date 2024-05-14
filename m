Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C2E61448C8
	for <patches@lists.linux.dev>; Tue, 14 May 2024 15:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715698953; cv=fail; b=Vl7Pd6HHr56rEFqhGST1oLIi/eiVWvXydbsuz2uYikJn8V4MLROKzgCtJPe63SHkBfbIlcrpFF6CJHmJ6jo0hIa/HMmxZS6vrddc5HFjH+2B+aA7qLhAynZLlgwCcn53CuVQfjWKX8H5AOlKtvgA+t7u9d6lWSNRH5t+MYpvEiQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715698953; c=relaxed/simple;
	bh=vRzeOVF74gBWe5glDX9+8Ez1AH4/24Rh+XD7sVhpkpw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=IB4CWpWD08A0YB813IDVkH0aLTPtbrQ6jkvlyy7bEruH7ZClOocjOQXRnMyItwK5FaOkKMfnsa0UPP1aRwHmu8/13B084nSbip+KbjrzT+dioY0TQmvg5MxCqYpb6X3foK657BIZHr1anCks1bFgRalehWcUmhUBfHk1T4v/BKU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mkkNQbUa; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mkkNQbUa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715698952; x=1747234952;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=vRzeOVF74gBWe5glDX9+8Ez1AH4/24Rh+XD7sVhpkpw=;
  b=mkkNQbUaeyhcdP+usEER4AYmDNkp1lBL4QhGhUCWKmCbEWwnTm4jJs7h
   5Ewq57Sdwa0CSjo4bvbvKuy1a4ZHhVv8kr9i+XCHFDeEapygTf4JRAKh7
   DAIbpYLsA6bVfEgRgwuYFx7J5UdFQRH5hPxZYAj77EZdcMjbj2Tx+6TFG
   B1VOxwUS0h2Mc29h5umfk8ws9wIWmydZ/cVqd3Wza3pD9CwnyHpg79+jU
   GTkfsvnpHUmV4K7/03/MLMBulLFU0jRM+isMKWXbd0DXDmz7lc5VOhi/p
   2i5XImJV2iWeYy3S9Oqt0aiAYpBDmueFkhyJJZF/o94f0zMbjanL0Mk7N
   Q==;
X-CSE-ConnectionGUID: giZ8HaURTrqy8Zduvs9UdA==
X-CSE-MsgGUID: Ehkra346QXC2G39pibbcsQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11073"; a="15523595"
X-IronPort-AV: E=Sophos;i="6.08,159,1712646000"; 
   d="scan'208";a="15523595"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2024 08:02:31 -0700
X-CSE-ConnectionGUID: LKNnkRnhR9eZeH/EkYRGXw==
X-CSE-MsgGUID: rF6OgOU1T1SFqT2IR3gS6g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,159,1712646000"; 
   d="scan'208";a="35595823"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 May 2024 08:02:31 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 14 May 2024 08:02:30 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 14 May 2024 08:02:30 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 14 May 2024 08:02:30 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 14 May 2024 08:02:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OcljQ9eD1CJOAXHP9eIYNlcjYtsejoSnWe249bCNjHNaeEMvRL4th+21ycDT/eHFgT7nCULMHCSLKGEFewhJz4LVWktusXbGpyHBfQ4lZXSLqG0GD45RmlJiNn3KWKbb5wdIqBaCfvRLXLZgBZevM9EssNBbUYn3/h1V1rnKHEDyByrD0wQ6kGS1fa1hqGOHvqVs9z5XdXwhquCkgEp3QoB6fI3C004Sn5K0/01n/kgsTG7j94Apgt4+N2Woz/NKm2pzo3cwfQRa02rknd5e3MBN4HLnrK6ToS9bh8uvfXvIBV6Tpk4zInVI8sdK4dwu19S/OcmcfMcMX7vDLtR+YQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FGriJ0ogBurnQq6WnRAgnCWMdBjkCgdg0eA9bQ+hrKw=;
 b=OuETOmEOlJEOO5EUqL/razk6lTv+M2leb115+eq9x1kwp8nwYhDja/7jFFgJ0Taze0wogp4+UX3UnYZ5BaumX8xdG5w1Upa/RIQeDeRVSnSTKJveVyhR9aB7r7IbnhhXMWZxjWXuFRl+RXm8SXDX1LncX1y+oMOTAcjVHGEsqnuA9Qgd23m0QwvWdIunEw6ZmhtBJJbjc/C/bIJSKoEtLNpguRQp06RAueOstGn3M5L3m9R3QFblaDu2N5C8WCLJuOV/V41aQlJSj3MMTmB1TAh4Ho9uDqy9x1acHV7c4UI4hL7OyFmA3sO5wBGpFADd9G1KZWgLWcMjKY7UV4FpLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6239.namprd11.prod.outlook.com (2603:10b6:8:a7::20) by
 PH0PR11MB4791.namprd11.prod.outlook.com (2603:10b6:510:43::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7587.26; Tue, 14 May 2024 15:02:27 +0000
Received: from DM4PR11MB6239.namprd11.prod.outlook.com
 ([fe80::2c72:1a50:2266:dabd]) by DM4PR11MB6239.namprd11.prod.outlook.com
 ([fe80::2c72:1a50:2266:dabd%6]) with mapi id 15.20.7587.025; Tue, 14 May 2024
 15:02:26 +0000
Date: Tue, 14 May 2024 17:02:12 +0200
From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
To: Tony Luck <tony.luck@intel.com>
CC: Fenghua Yu <fenghua.yu@intel.com>, Reinette Chatre
	<reinette.chatre@intel.com>, Peter Newman <peternewman@google.com>, "James
 Morse" <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, Drew Fustini
	<dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: Re: [PATCH v17 0/9] Add support for Sub-NUMA cluster (SNC) systems
Message-ID: <j6y653o4dy7bizn2yflp6ve3qhfmco2sqeeyyny5crqit5lmuf@ylw4bcjgm5y7>
References: <20240503203325.21512-1-tony.luck@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240503203325.21512-1-tony.luck@intel.com>
X-ClientProxiedBy: DU2P250CA0015.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:10:231::20) To DM4PR11MB6239.namprd11.prod.outlook.com
 (2603:10b6:8:a7::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6239:EE_|PH0PR11MB4791:EE_
X-MS-Office365-Filtering-Correlation-Id: 278b8f5c-a2b5-4b69-e03c-08dc7426de3f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|376005;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?4woqL2pR/ZEFA3C3JYkf2BSCEVLnGFNbsaGa7xbw2ehxWHjH2lV+SjckUd?=
 =?iso-8859-1?Q?gvzCCZkI1cFOE4UIF1lKpfjGIgCZQpqpYUXKEec/WEjFNSGXygIpHBGLcl?=
 =?iso-8859-1?Q?kLTmg7MFzzhhVkiesu27kNgJfT0vyiaxo7eO6G6cUxg5uObd/5t7Nq+V2a?=
 =?iso-8859-1?Q?GOYczWVVbAhoxCen8zhKFWbaGBNFdDjcTyZzXdYd39L6htp2LvwVICfma1?=
 =?iso-8859-1?Q?zyzGT+WB2bZhPZnAodVoaJiiwXUe+JtV0EvxZnY09M3J64abddm3wmmvmC?=
 =?iso-8859-1?Q?8Ws+gfT4uYr0j0UNRyE4KoHACIPg+hOTvXCuMtArRHo5kTYvFTb7upRf6s?=
 =?iso-8859-1?Q?4ugsIHhP1HEq91uvdqi32nUb/F1vdqD9eK++AfW6rM3L3L0NFTLzBvC7X5?=
 =?iso-8859-1?Q?f9rsBz6CkWFKy83gStSIA949t/NwpFONZDJaFp6Tu97LJ1QitzpmqEGjnf?=
 =?iso-8859-1?Q?eMlI+lmanMADp9e+5IrdMIgxNNqC4kdKquSWS9cQ023yMb7bfOSxjnfMn7?=
 =?iso-8859-1?Q?QpMIevrY0s7LmJ09MYnhKnRLk+Qdf3rGfu0p/UJj6if4lGYiwwRFY+YxB5?=
 =?iso-8859-1?Q?kmtlpAyLY5nh4OPGRjI9Oc2/NqRGY5+Q72HrViI9KAZM/sMHxHrh1u1eMg?=
 =?iso-8859-1?Q?KZSKuCT4rci7UIAkqEzf5/ob3WKjx/q4wwzu75Gb6FMxvg5MzqJO10TC5j?=
 =?iso-8859-1?Q?2UNCEBqxrUEwU9+j5yP2kPe2/t3vcg4ImXf+BxCtgWn5c7ScFGfp5f0wcr?=
 =?iso-8859-1?Q?+iuqw+K8wIc9C2qpY5CXwlfUpsYU4RAUmqZBsTBYYB3htGqTb+4JzRXcRK?=
 =?iso-8859-1?Q?jHENdzbYk9BsYPS3qR8t8kIw1WxtGDnZuFRJ390At/vLVDxDI7AuXipET7?=
 =?iso-8859-1?Q?cLqWzEKAKUpbBOPtoNtOX9sC2NRJK7HL0dj1y8vtpa4u6iBhBjrde1pRaa?=
 =?iso-8859-1?Q?2gqwUDJx5ieZ1QdXXKGcxKiG1p1CMvixaNRa2rAuEpBgSn0I2mZxWPYuQ2?=
 =?iso-8859-1?Q?wafaQ59a2iNAUP2Ghlmn0wRlO4XyxALidaBD7A8I93AFFwweUaoDQb5RS6?=
 =?iso-8859-1?Q?Osji/TP79kv83YBf1MRVUZS01oluFoNvo2Svk1bVowY71JyS1jsBMog9Pt?=
 =?iso-8859-1?Q?lqzF6291PVSqna9Ci5Oc/rJXqyYFDeFE5KDCctobb0c8oqssZGCKojLm4r?=
 =?iso-8859-1?Q?qjVxBCpe7R9cFKAvH94bC1C8uZ3B/+Acod1fCWpOJMIkP83h6Q+F5f8csF?=
 =?iso-8859-1?Q?BGSbPvW5+REgC0nP2wwg=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6239.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?A75jEq6C5PVTpoSkIDhmYzXXNXGehsNAWYlM67yJ8ljFG8fmrPsAPyav84?=
 =?iso-8859-1?Q?yP3d+uswjIkaqu+WuhcjENDxg8iG1BvRwqhb8gSx1ZLxG51aZt396tuT+H?=
 =?iso-8859-1?Q?TX2xFGCp5TG5j/DYUMFVqBDSYcBWYcLcw6t6jqbBK0d4qynNq0MkVnNUZG?=
 =?iso-8859-1?Q?y0BW6LFsd1TUfTwFKfx3ODodh2KPKPygkxlR7vsLh1Ylu5f18LEnF56fMo?=
 =?iso-8859-1?Q?oLBG6p/Ynl10UsFVnHx91afbHGcFfMePrVMlaRp3LLaPOrFsGs26h0Auld?=
 =?iso-8859-1?Q?AS9pCy6/NGwVpL7rP5rwKfu/XCjcbb80HD6WUCR21EUSwHiA0XBRb4n1n+?=
 =?iso-8859-1?Q?x6uKUbLAvnQGqwp+bdK1/6Ykx7g2Mbxy8sG+fV88uJU91otSFPSaWgy5MP?=
 =?iso-8859-1?Q?F8kkZ/rgKRl80twMNg5MxjQN8Azx5aumUGcGPCsMoMUkUJtU86jVwn8Xfc?=
 =?iso-8859-1?Q?+H1bkqHFg94nPeI0BCnFINTTerboeZhsTyMx9bI/rZ+we3YuSAAjh9BA1d?=
 =?iso-8859-1?Q?ZQeuVg6w7dawuRqA5TVGluzrC3deDGbfrgKaOh0oXPt9o2zlV9ubAWiE5B?=
 =?iso-8859-1?Q?KsXV9x+PtlPGfuCaaly420sOcB8fR3jmbpgWPK4JKqEIIn6JnMAHmlZdB/?=
 =?iso-8859-1?Q?iI7dcZMEKVVn2wM+jpJL15tUC9H9pcp2srgkDivFGnagiLHqjToxofTkMv?=
 =?iso-8859-1?Q?nX6B7v8iGiQtUfSkKFTssJGWy1+kJpSTynMI2BuvBMZu0k0aQk/g1OMkiU?=
 =?iso-8859-1?Q?CPiItNz8xLpkJZaz8EOpyc/vC8N9DjAQ8eIaREwguA3CLfyRsx7yDoX2+e?=
 =?iso-8859-1?Q?lYrcCMtIJvZhU6yq1a8X0U9krmH7iECgekumFEsmLXoFvO1MWfk8rfgbjG?=
 =?iso-8859-1?Q?ipkORf98z+uBn/TXf5Wu7T9+jKYVPha8LoxSRVztOylOBNFa3fnVJNa851?=
 =?iso-8859-1?Q?vnEQkqOYsI4yYaDU6JU58OQ7CpyZwPZ8CRLw9jDZah2VyjIZOMHXk3IvFy?=
 =?iso-8859-1?Q?6fJo6jUlZryWrTbQudTnrEbA/l7gK5K2HxBeQ2XPxqMK96mA1x1uwcBz9x?=
 =?iso-8859-1?Q?aU9YVeiPFOVvMM+bN7a4txwHT9jeA4BYJc1viCJHDeLDJH0yd4ES2KAXTi?=
 =?iso-8859-1?Q?bVfg3fUavCGo3pE2rOF65nZVbQEG9pAbw7JwmUWRM1H8DSSgOLH4HVtmxU?=
 =?iso-8859-1?Q?8jla7GEdv0zGRmnXC03a8H3w/SPLqSH4m9N06isazum+Tn7Dj7RC4zr3tN?=
 =?iso-8859-1?Q?zwUJYwRoP0GsS1yj5w4coA704lLdWlTCserPGgzIeJu+SfER47HV21r7Rx?=
 =?iso-8859-1?Q?Fags54xXnEvKi6TY0wnx0Pwsb0OfpdvQaZ9ZdhLzmHtgnt4ZhoI/Qkmb6r?=
 =?iso-8859-1?Q?UqlQZmDluc2snN2euvoY4sClWGCa8iOZzHZ2BzWGmfYlqlx86qoGDsqGqV?=
 =?iso-8859-1?Q?/sK0Oie6ZuQJ7wmXXce846fKbteLFMn5jqt7Hp1mI+PYGMVsuyuvCm65Jg?=
 =?iso-8859-1?Q?my6Eb5s7WgBtdiPQGmToSPFWt+IHjNb0Lh61IM+tBmOgh/tLwTCeXWj3PB?=
 =?iso-8859-1?Q?9GxX34ieM0BgMCKj9rSx+SqOITKhoOGH5PmyXGyVDj6dVAEb5JxJkywpL1?=
 =?iso-8859-1?Q?A/DGSkd/IGDvuGxbHkU5ma4HeWqf4DQOQGK0InZfomv/Sgbfgp3oIJbtSI?=
 =?iso-8859-1?Q?B0edCi4vtKnEyLN7n1s=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 278b8f5c-a2b5-4b69-e03c-08dc7426de3f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6239.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2024 15:02:26.8716
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gM0bArfxrmxw2GGpi28yIjDIDrPeoj43VccB5lNDyXpcsb13mjl/dp7DGxPnvFJ36levVBoWyiH08n91f6ZHCLPEJvaZFeeN/t6+77orCDI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4791
X-OriginatorOrg: intel.com

Hi,
thanks for adding the 7th patch, I tested the series on a Sapphire Rapids with
resctrl selftests and the summation works well on SNC-2.

Now I can also drop a few patches from my series on SNC in resctrl selftests and
only keep the part about discovering kernel support.

On 2024-05-03 at 13:33:16 -0700, Tony Luck wrote:
>Note: Jump straight to patch 7 for the new stuff. Just minor tweaks in
>other patches.
>
>This series based on top of TIP x86/cache branch:
> 931be446c6cb ("x86/resctrl: Add tracepoint for llc_occupancy tracking")
>
>The Sub-NUMA cluster feature on some Intel processors partitions the CPUs
>that share an L3 cache into two or more sets. This plays havoc with the
>Resource Director Technology (RDT) monitoring features.  Prior to this
>patch Intel has advised that SNC and RDT are incompatible.
>
>Some of these CPUs support an MSR that can partition the RMID counters
>in the same way. This allows monitoring features to be used. Legacy
>monitoring files provide the sum of counters from each SNC node for
>backwards compatibility. Additional  files per SNC node provide details
>per node.
>
>Cache and memory bandwidth allocation features continue to operate at
>the scope of the L3 cache.
>
>Signed-off-by: Tony Luck <tony.luck@intel.com>
>
>---
>Changes since v16: https://lore.kernel.org/all/20240312214247.91772-1-tony.luck@intel.com/
>
>Patch 1: Reinette pointed out that rdt_find_domain() no longer returns ERR_PTR()
>but one of the callers was still checking return with IS_ERR().
>
>Patch 2: Tip tree added a tracing patch. That needed s/d->id/d->hdr.id/
>
>Patch 3: Reinette: Keep the "RCU" in the kerneldoc description of the
>domain list fields after the split into separate ctrl/mon lists.
>
>Patch 4: No change
>
>Patch 5: No change
>
>Patch 6: Drop the change that divided output of the resctrl "size" file
>by the number of SNC domains per L3 cache. Now that this series
>preserves the contents of the legacy llc_occupancy files this isn't
>useful.
>
>Patch 7: NEW in this series. Add per-SNC domain monitor files while
>making the original files sum across SNC nodes.
>
>Patch 8: (formerly 7) No change
>
>Patch 9: (formerly 8) Add documentation for new per-SNC directories and files
>
>Tony Luck (9):
>  x86/resctrl: Prepare for new domain scope
>  x86/resctrl: Prepare to split rdt_domain structure
>  x86/resctrl: Prepare for different scope for control/monitor
>    operations
>  x86/resctrl: Split the rdt_domain and rdt_hw_domain structures
>  x86/resctrl: Add node-scope to the options for feature scope
>  x86/resctrl: Introduce snc_nodes_per_l3_cache
>  x86/resctrl: Add new monitor files for Sub-NUMA cluster (SNC)
>    monitoring
>  x86/resctrl: Sub NUMA Cluster detection and enable
>  x86/resctrl: Update documentation with Sub-NUMA cluster changes
>
> Documentation/arch/x86/resctrl.rst        |  17 +
> include/linux/resctrl.h                   |  89 +++--
> arch/x86/include/asm/msr-index.h          |   1 +
> arch/x86/kernel/cpu/resctrl/internal.h    |  72 ++--
> arch/x86/kernel/cpu/resctrl/core.c        | 430 ++++++++++++++++++----
> arch/x86/kernel/cpu/resctrl/ctrlmondata.c |  57 +--
> arch/x86/kernel/cpu/resctrl/monitor.c     |  98 +++--
> arch/x86/kernel/cpu/resctrl/pseudo_lock.c |  26 +-
> arch/x86/kernel/cpu/resctrl/rdtgroup.c    | 263 ++++++++-----
> 9 files changed, 759 insertions(+), 294 deletions(-)
>
>
>base-commit: 931be446c6cbc15691dd499957e961f4e1d56afb
>-- 
>2.44.0
>

Tested-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>

-- 
Kind regards
Maciej Wieczór-Retman
