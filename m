Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC7DE3148CF
	for <patches@lists.linux.dev>; Fri, 11 Sep 2026 23:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.6
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789168112; cv=fail; b=ZKOH+3NeHANSyx5GYwWVp4gisuXI4VL49rkuibZWqxcumcahHvi550FrFnixehIDl55D8cMD9cSRYOI/Vd82l9FYwBpUsT8yoZAieyHP6D6/pzfWxv+sK1cpwhLorZm7BWmNl9eXFATc+f6cqFKitXUXCGsoGWS0bjcGTcVSQQY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789168112; c=relaxed/simple;
	bh=Loq9r6L6NzD92wHyMZ9uQd3g08pVAMizGFMcxakPRxk=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sqC1Wsg/OXqXL1Bpk6RzFu/3rfHwnLBko/ziGf3ZFeQZYKiyHTxd5KY3QlIpFA4tcO9XjXB3x2Ioo7Ei4hqgrxMRLdU9p9Dcpcq5sgZuK7RnWc3aMWpBWrRSpA8S1n+pEl4Mta1PtCKjNAq1mtIws9K1Q13NcV4K5b9BX4GCScw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=D2bFcmjr; arc=fail smtp.client-ip=192.198.163.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="D2bFcmjr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789168111; x=1820704111;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Loq9r6L6NzD92wHyMZ9uQd3g08pVAMizGFMcxakPRxk=;
  b=D2bFcmjrs3/4HYSHQ/Fx2kvQyxykdWT26xqeofBrY9q3aw0B33y4PH5V
   SZ21Do3ZFVVX6dqyB+iqy3wLxJokmgW/xYj3nBsqEm977OdBFBZl0kK7y
   XBtLQHVcAbjx6rp6XHRdttHQB4F8Sxdd9zBFJljMCNZ6net+nQvoNEJaN
   cvu/Yv/ViBgQ0Q2tMFceY1lRAfoTgjycerIKfKLHyuM0+mlTptSHDeYzL
   5YiwANEqq7IBEeQX/AMDZA6nKY0VMRFjojneZIhr7qa1dxVDVh3V4SYsy
   c5o2p6uFUAfKZoX0d8Vp6G3aszMR3hgYPcBUWNvbecjAaCAKdnKkjM3I5
   g==;
X-CSE-ConnectionGUID: 8x6TjKNnREW7t1dPXeJiHw==
X-CSE-MsgGUID: aa+tiNHqSqyYGf/ZmHjvpg==
X-IronPort-AV: E=McAfee;i="6800,10657,11902"; a="145068"
X-IronPort-AV: E=Sophos;i="6.27,98,1787036400"; 
   d="scan'208";a="145068"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa116.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2026 16:08:30 -0700
X-CSE-ConnectionGUID: IY3TwCLMSSSnlcn2t/Oo1A==
X-CSE-MsgGUID: hDWr85yYQYKkhxExsadJyg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,98,1787036400"; 
   d="scan'208";a="267760721"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2026 16:08:30 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Fri, 11 Sep 2026 16:08:29 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Fri, 11 Sep 2026 16:08:29 -0700
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.2) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Fri, 11 Sep 2026 16:08:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SQVjzyQIu4Z0u7EgnfpqH8WDZSeszcGNxJN8lMl/DdszmIHL02eBgSCRP0K2JSHvQKaIAU8/4eQWwDGZVrY4AOfcoXZsaxjGoRoZfNoalD1JzXatLdjkwjb9zxoNPQyfBH8D6BrFhdMcEYRjq51bECOZB7MCGqGfo6Xs3IRb2KgOA0rt3d6Qp/bWUmcPWDRESmCB21FrnsJhzhSn9vLLvtCwjySbTfd31Gmb3rlJAnFFshgVUZSvqoe61ojejuuVLEvgc8Y5wYsixrqUKGntDPOiBIkSirXNI4gf6KUqe6a0o/gj2X8xUfCfAegSh69aBK7HQ+Fef+014vnzPrsEjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=isiA74g+zYgk9wonGXSg+9ygUUFyjCtjG30SDtBXPQk=;
 b=MLK6i0wWQsL6S1c82P+4W01JTMfsWeRsADHFUHGzQQYHq9UpJfdNN7rCJ5a4a//6Mzwvh9KRURIvMAd5yTs9yG6QOZJOGl4Qr5nYRras7psl/aBLAeklIC/CuNK5PIxEim5iy8/aOgLyiEMfD1uq/l7Jiokh2Onf46yWA6SKwyi1usm4QbXf654BELlZW4TlIBo7IeR4+tXu+gZUH+splplPrqUdr/jKk6k5ZwikV0IFGMQpdaAEOnJjI6UtmfMDSXXsK1Gub9M6Tij1fqtFvCFfHrM/edEcsd4MYh3Cl1pkW/ZAjndnz3FCsTqEyJJJv8lRCjY4M/mW/0c84Jx9oQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by LV2PR11MB641471.namprd11.prod.outlook.com (2603:10b6:408:40f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.9; Fri, 11 Sep
 2026 23:08:25 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0406.007; Fri, 11 Sep 2026
 23:08:25 +0000
Message-ID: <a62774fe-8b2f-4967-b052-204601adc515@intel.com>
Date: Fri, 11 Sep 2026 16:08:21 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 02/23] x86/resctrl: Check if monitoring features are
 enabled
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260831174421.13921-1-tony.luck@intel.com>
 <20260831174421.13921-3-tony.luck@intel.com>
 <e063f882-ebf3-4a25-9d43-b23acf5db4c5@intel.com>
 <aqRSUtZrg1O4YgPx@agluck-desk3>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <aqRSUtZrg1O4YgPx@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW3PR06CA0021.namprd06.prod.outlook.com
 (2603:10b6:303:2a::26) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|LV2PR11MB641471:EE_
X-MS-Office365-Filtering-Correlation-Id: c131ab17-4da0-4483-e797-08df10599480
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|23010399003|7416014|1800799024|376014|11063799006|56012099006|10067099003|22082099003|18002099003|4143699003;
X-Microsoft-Antispam-Message-Info: kgljq7AvF7brSwqGwKNknYoUK8sg+cTdODpC7/QbdRf19Mvvt8jSO+C/vQXZkjTqUG2chGZiWAo6B57uy41JdnLYRL9wmFci+jWDNBnMThroiuFHHle7vPv6l1T6ZGNLKECGCugo413vNAkP2MX/8AQF8Tamci7AqPxwQly0umPMC3hTj64pFe0PQWOblwyGrlN1su/6ObGxaZYzO/KtVBUZhnInTP7/a91OLjyz0e3pZXOC4g4CfVEaZ4egIVNbfPp4lxV9OTKc4hJar4CaCEeXccAptcTM4j3Xe13KJ2ttQ4Bs/OQRRPbTJPeQr8/JizHZDx0qzSMZ9h7vRA02/M0XFMwMjsbnNQ4ifJ/tAPfDeOp5DCT4FCghJbDMiUF+dEJYzmIC0v3oPJPkMogwtxtAEu3Ym+tYzO6ekd4jWwEjABFuvSe8bn6WeTzByrZ+8a9OVeLdETElQDNTUhU9vSE+JxOoo1/Rm3pZJNYOrpZbvyEI1kif+HGPjXFRyAtHUybJtuGprwl32cUAFpz96by8SvTBp2/WyvStxqV5/XaNjB8wjr9gHgMfSpJXjqa/F8euADRZxprVRgh/8GF7q/dlV0/JVD5+4Tgia2/XNwBMGLp00rFtBPaZTuDw2iz02/4UutSntLX6HznRQu6ui+pC1hx+tRarQYiVSnER+90=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(7416014)(1800799024)(376014)(11063799006)(56012099006)(10067099003)(22082099003)(18002099003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZXBNWmpvUnlvbFpxaHpId1A4czNhd0pOSjlGZzZXQlJFcUxrOHR2cE1aR2NB?=
 =?utf-8?B?cWhUTnkraXkwNzhaTTNJSmxWeFkrWHkrOEMwMjQ4RWx1U1g1ejVPZlljYmZC?=
 =?utf-8?B?SFI4M1BONHdrUS9uQ1Q3OE1SNDE0NnpvUmQ3V2lwT2RTY0J1QkR4bUtLNHBP?=
 =?utf-8?B?QzdmdjgwajZNUmh6ak5rMnJZNWI3V05NKzZPc1NQSkVsMm8yTEZsRzAzandD?=
 =?utf-8?B?Zm9Cd04vQlNPSEh0RjVpRlFEbEd6ZWZqTGJmOFRqYXVERGtGQUV1Z05XRHFI?=
 =?utf-8?B?c3plZWNMdTljUkxPemYrekJVOWxQaTZnYUhGNVEwcUdGMFJRSjlZUXUxK2JQ?=
 =?utf-8?B?MnFUTEtxSk5uQUUwbjlJUUlZVkdZVUdETXpXMFFwSml4dUM0M0NQTmNNRzda?=
 =?utf-8?B?QVEva2tYT2FoWmpiVWtad1pGU3AxaDJacmVKeXVneElhOWdaNDBRSkg1Wm56?=
 =?utf-8?B?S2xNYzVuWDd4UDFuaURqR0UwR2tBZHM0NDE2NHpIckRWYjVKRG02Tk9RTDhR?=
 =?utf-8?B?M09SdGtiUFVYQUVHeGpvZlRuQXhKeVVFY1BsR3RJOTVUdGs5aGRmL0tleUVN?=
 =?utf-8?B?aGRnTjNYSzN1enBRbG9Rc0ZKZGdzUU9TdmhZM1lHZjRlZ0pMVGl6bEFZOU9n?=
 =?utf-8?B?b1B2YThQeDZ3aFdaOTJrTFNHc0V6VVlkSmE5K0FrUXZWRHpMWm9KZmk1ZXZC?=
 =?utf-8?B?RzdWR1hBOWZMSXpqMXVHdGxOMXZPbmxpbzk0NEYzZi9wU29WakJoUm1McUN3?=
 =?utf-8?B?UHFWYld6L3lyU21nUm01T0pUc2NOcVpTYXdsd0pjWnZ0U0JOcGpQbWRXeUdS?=
 =?utf-8?B?VUwzWHl2M0tUZ3RVZ2prSkN3cHRWcEdTM05vYnR5dVIyei9wWWFrcDdWK3JQ?=
 =?utf-8?B?bS9tWkp1UmREUzJOWHFVQmlPUldqcEJ4a3ljcTZTOXRZUGFDWlR0RzhLU2dG?=
 =?utf-8?B?VkFoRlRFelJlNGNqbFdKblE5djVwbWlON2ZSeEpUOHRBNjJoK0UwOGlKWmlS?=
 =?utf-8?B?MmFQTENsZE9uQXZDNTNNZEx4M0wyYm5KVE5rVXBwd1l6VFg0Z3ZqR3lGQ1hi?=
 =?utf-8?B?VTNCNlpNeTRHZEtOckRVREhOQTFIdkdDOEQ5cUZMdmJ2U0M2cUJBVlViU1Q3?=
 =?utf-8?B?Z0YzOVNZMnUvYTViamJKLytBRGN1LzNpOVdBRk01UG9LZTF6SXh3ZURTUkNX?=
 =?utf-8?B?dTkvVDZ6WXJDSjBtcFg2bnJkTXNFelB2ejlEVTE0c2MrVGZmR1VNdUpXM1pw?=
 =?utf-8?B?eVcwZFpMVU1hTTZCREdwU0JvcGZ0TU5QQk5FeEp6Tzg3RmR4cENnbWdpdE9T?=
 =?utf-8?B?WVdTd1JOUHJNNk8wRUpDWGtDU1VEbzZKWHYrSVZ5cEhFQ005WXRFc2ZWcmMr?=
 =?utf-8?B?eWkrc0p3ZGx1aVV2bjM1NUZOblVUNlArYXVFSmg5aDVYT3ExaFZtWlF5SjM5?=
 =?utf-8?B?ZkJreWFnL3lZYzZsckI3Rm9GcE1CV25DVVFMS1VWZkNBRTdEMXhmaGtVYjJn?=
 =?utf-8?B?NTVZbnF0NktsMFVMWmlVK2Y4SkVvcGF1WkY3KzZGZ1ZEKys2QWtlMWREdm10?=
 =?utf-8?B?QzRCRkxKWGZFZEg5cHJEM3dEZ0ZEWnpiV1RkOVFWMGRaRUFSWUhwZzJpSzdB?=
 =?utf-8?B?c2I3c01CNDJ4Z1lKeDJ1MjV2dlB6WHVHcU1JWVp0aU0zMVkzUkRTUUdtWWFn?=
 =?utf-8?B?VHJrSHpoZFZuNTNaeFdXUUZGUGl3TG5FWGJ0b1ZydTBnZjl6ME1oRXBRUUpl?=
 =?utf-8?B?a2xkanJKQ2dka0w5TFFZM3VPNmF1NFJjZ0RIdVdDa1luV2xOREoraUZSems3?=
 =?utf-8?B?U0VqQ0VDZDU0OVV2VWY2M0Zxc1FGckFDZHF5Sjc2N0l3TkxHRW5QOGxmL0dR?=
 =?utf-8?B?bFZ2UnBTVlA5UTVPL1l1cUJmOW5nV0ZCLzgwektvRnpBdWNwZW5DcXJlR29K?=
 =?utf-8?B?UFB4bzd5LythUlFJTERHbm5JRlM4bXpkbVQ2cHgvbFdWWWpnMEcxTXVWYlN0?=
 =?utf-8?B?ampJOVVKbmdOUDN1TFovZU1iTHFMeFoyWGRSbFJUM0Fjc2E4TXFXM1grNGpt?=
 =?utf-8?B?TUYybzlYbkpCQkgzQVd1OC82VjI0bTFCeDBUcVlDaGVHV0tHNjE1aVdxWExz?=
 =?utf-8?B?cHZuZGNRdEpkTkpVOWVMVzNVSlZmU2c2OFpNVy9jQ3BIQ2pHNHhwRkhROFJr?=
 =?utf-8?B?NjJBWDFWT2JWU3RPZU5IOXp4Q1pPOXd3aGl1UnprN0ZpYVJLNUt6U1A1cUQ4?=
 =?utf-8?B?bEl5ZlZuQXNIb1NlOVhsSGIwREg4N3h6bFVqN2tDWnFaQk9oWmVHYnNRb3ZZ?=
 =?utf-8?B?N2tORmt3QTJpRkk5MDlKK1BlV01YVDJYaENDOXdsK2laMm9pb3VUSkpRUHRQ?=
 =?utf-8?Q?tMGm+mVgDWlRaP68=3D?=
X-Exchange-RoutingPolicyChecked: xElbs4lRtVn5ub4okQ5qP5NLtKSUceI8WNAuP1FEFKAIeX47sVZPTKbW+y3a6xi2zMbhYc858wjqhDA5bF3Uk1j+qlO73MjuAIzGd9/4Z8GBZCAlyVTLp8zkk8MY4UgNQU8xsyyKYvTGPEtLz5fNreHEBV6IGBaAqXSeQCLArUhiuzIfyLpWQH7tPYIyyVKk8OnFhufBwXx+KyIKtAtL55VbFWY4bYbjyZnEMQ5ffOx9mKBX0rCb6I80QwxlzUHIbhR1f9wu/6ArIqx7WWo/u2O/X1ib32ubeP7uJVDjn9JCe0AnEkONAITUyJcWUavj1pTE3YcjpyTJ+0M5PgzVBA==
X-MS-Exchange-CrossTenant-Network-Message-Id: c131ab17-4da0-4483-e797-08df10599480
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2026 23:08:25.0523
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5leJipI8hcXD51STODdoiFBmDuC6iGkioHPiG9PWfs9AVsVHMzugOK1VTrG9vMB4sRZsa4jHz8+RxyGzDxUr17Yn4VbPWQauMOPUVvgijgw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR11MB641471
X-OriginatorOrg: intel.com

Hi Tony,

On 9/11/26 12:11 PM, Luck, Tony wrote:
> On Wed, Sep 09, 2026 at 08:52:39PM -0700, Reinette Chatre wrote:
>> On 8/31/26 10:44 AM, Tony Luck wrote:

...

>>> +	/* Any monitoring at all? */
>>> +	if (!cpu_feature_enabled(X86_FEATURE_RDT_M))
>>
>> Previous patch aimed for "symmetry with X86_FEATURE_RDT_A" ... but the "symmetrical"
>> code in get_rdt_alloc_resources() is:
>>
>> 	if (!boot_cpu_has(X86_FEATURE_RDT_A))
>> 		return false;
> 
> I've dropped the #define name change, so the symmetry goal is now moot.
> I still plan to use cpu_feature_enabled() based on the block comment in
> arch/x86/include/asm/cpufeature.h saying that cpu_feature_enabled() is:
> 
> 	"the default CPU features testing macro to use in code"

Thank you for pointing that out. Looking at the history of that line it seems to
originate from one of Boris's patch checking scripts so would surely be required
when requesting its inclusion:

	https://lore.kernel.org/all/20241025155830.GQZxvAJkJnfLfNpSRx@fat_crate.local/

I was not aware of these patch checking scripts. This looks to be something I need to
start running myself. 

Reinette
