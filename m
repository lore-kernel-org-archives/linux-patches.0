Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F3B72BDC05
	for <patches@lists.linux.dev>; Tue,  7 Apr 2026 20:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775595059; cv=fail; b=L6XYM+OcrG1GgqqpDhETlRY/R2lYMg7b1CPlBEexUdKESmZXS/tFmJDFhR6mvU9Jqw/3vAX0LW0bcNB2cZCsLJiVHFvGvX/cSfM8oZHbM0MR1TBfX+t03tafmSHUHf3HgkFdg6sVi8fd/0rRbvJN/0l6MbaUBo5wAJM9R8cBPbA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775595059; c=relaxed/simple;
	bh=nYOJHnn23YJpdidyMtK8ckrSpX7YG4vqBlfSBUlLUNQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=o438e6gkof3vQyMlXaR8dxnChO3ZQ/ZV7p1eRfZ+fGWXfHf3dnWHYEXd3ix6SWiMDdbnVpKlJZVdnNJphriuT0e3Bhay74C/WiFXQb1m3/wGXRewx/gOEPjQU3FDfozoYBnkpa/H7KSxkI5+udv4OL3pHj3Ow9I2l4i2zETvnY4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HbOKHcGZ; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HbOKHcGZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775595057; x=1807131057;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=nYOJHnn23YJpdidyMtK8ckrSpX7YG4vqBlfSBUlLUNQ=;
  b=HbOKHcGZW3iC+Qu6kqcYvoHDBPkc2lWb1fUPQmG2mQaFE5UfE54ciaau
   6uPjCjuCSrmYw890G1RtQ/H7IGuwRgFg4KF48/+XyTxTyJ21DCGpnXZGq
   mboajXfkuwpFL7JqfqmPRbLcPmFP6AWlYeSlJ7XZvyyapJ+Vs8S5Cqqyd
   JpaZSYRuF/Ed/LR128UvdrcWaoP6P1J2leVjzjw8gy0+vLHzO1wnpTYvD
   F0ImSArH5TBP8wzcqBIQHsAb7WGnp052uJ65oS9GDc+cx0eisIkKiExpl
   RD3i5jWOXf606VaGM9IKEuoKTt46EpjCcHmjcDEsfaaauo+M9hDyE6cRs
   Q==;
X-CSE-ConnectionGUID: +86MOmINQQOgzc6bBgT1sQ==
X-CSE-MsgGUID: o6ZpT62oSzuQyJ1b+nTJaQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11752"; a="76756807"
X-IronPort-AV: E=Sophos;i="6.23,166,1770624000"; 
   d="scan'208";a="76756807"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2026 13:50:57 -0700
X-CSE-ConnectionGUID: KRUX6Kr3TeC2r9yM037n7w==
X-CSE-MsgGUID: dcjcA78mQ8umW2Ij2Plk3w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,166,1770624000"; 
   d="scan'208";a="232657467"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2026 13:50:56 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 7 Apr 2026 13:50:56 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 7 Apr 2026 13:50:56 -0700
Received: from BN8PR05CU002.outbound.protection.outlook.com (52.101.57.59) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 7 Apr 2026 13:50:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ow/P/Aq1AQkErN6wi/9K2G2OdK+B61YMWMUTJckCCduL/74+hbK9s74msaFhLseIvipLVHr0sw2xWFOcCDDVQJOpt0hbUQvYh7+ww0/Mb6IlcNsNdKA4WjZDNVBJMARE9in2/XIkUOm4OiOnDRz4VxYvDQIirckbWAkCNSI5om5IY97FW85GPh/hGofisQdO5u7JPW7GcPj+91VDOJoFm8sp8YfsQ7BfKP9y0HVuvoRu9WGUtFdpK3tADHKr0ZqL3TdISwGtMymXymtrTgOxKRtiiC02IJiI1oEArUw27uA0J+5uW8nRCJKeoItxs3EVQg+9jurPeZSi8W2EUIp8Ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7EqbsYV0199ykxXK+bEAyQCSxMiF3sBkPwIMQK61tWM=;
 b=i4hX2JX3p4Mnt7f5DskM73kyp9D0bqBlHZU3BMKyv9rUZJ4G7uROwf0+rDY6jjDkfF4tz7HI2TE1603MvJ+XfgGDoYkp2sG2iRwhpk9HaMYpIG4eaRubFvlcNJZa/WBxX9CFH+5nSl002xA8kzXlNn+BoLLd7fjvxzn2u6o8waq7qPl7FsVW0Q8SLrxUAjbS/sVFeSs2v0ivDjlwuBPbq6NA0Lh28FUjQf3PKbNgDbl/hPDBWfEm1Jqo5l+aINsdVr1TrLH2Km8z8vScdcUZLPnvoynFXB6AvmssobcCTzt5wX6KzgqVd+2UCsYAEFEPEEa7YDMEzk9yquittUYndw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH0PR11MB5902.namprd11.prod.outlook.com (2603:10b6:510:14d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.20; Tue, 7 Apr
 2026 20:50:52 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%5]) with mapi id 15.20.9769.017; Tue, 7 Apr 2026
 20:50:52 +0000
Message-ID: <e89edbdb-b6a4-453f-99da-41991ad25712@intel.com>
Date: Tue, 7 Apr 2026 13:50:50 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 03/13] fs/resctrl: Avoid "may be used uninitialized"
 warning
To: Borislav Petkov <bp@alien8.de>
CC: <tony.luck@intel.com>, <james.morse@arm.com>, <Dave.Martin@arm.com>,
	<babu.moger@amd.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <ben.horgan@arm.com>,
	<fustini@kernel.org>, <fenghuay@nvidia.com>, <peternewman@google.com>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <cover.1775576382.git.reinette.chatre@intel.com>
 <56fa3b5937ec6fda4eec162393463d8dbfc1abe4.1775576382.git.reinette.chatre@intel.com>
 <20260407185543.GFadVTLy82sBzT3eej@fat_crate.local>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20260407185543.GFadVTLy82sBzT3eej@fat_crate.local>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR04CA0158.namprd04.prod.outlook.com
 (2603:10b6:303:85::13) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH0PR11MB5902:EE_
X-MS-Office365-Filtering-Correlation-Id: 035dd85d-54b7-44b4-c0df-08de94e75b69
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: A/lBYZfWN0FF/TH7anIW++U1Wmm9U0Pb1Eg8bdkQnEHmLP7Zfd1oG9MJw5kISWZTZfcRNc42ldTelalUh7mZrHPqyx/Hji6nEo0m/xSYZFgoNG8LIoRSha3bkwt8fWV472uj0JG71nj9QXujFOWO0RNCjPrKzTnBTE1vP5/CCo5Qwo2KW+WOUHyzUczfsIRvMlnYYJsabNtqbyAZp0Nzlwvyk8tScrHLPl7EAkOst03+VwtP9Rk7jnFixww6/Jxrc+FRePsI7/Dep4JJn9FvvzIO9WLGTj3Xquw75FK3KLC4bb6uGGCMbN+KXjZr/elRN+6okER3pFz+WH8sYlW9Q9CmUI0dxFIP1wPxJqPk/5foexHCivbgvsOhhpfAVaBx6qLq7iLO4YLxR0xRYk6nImpTw1bFFJNkdCFloulWVP+j4GVJWhtUjMDLdVAPDPRX8tPfkHyWlU99opfpee65qJ0vHXR6u2OdaOfLKNoqBHX7ovM62s05SA5ECB6N1ZdkRtnmIDzyYt1VT/YwCGa4gYSSZoK/nUq/SivM4Fh1yVYPeMwER4Y37oPjhECvKgbgytysFjBxtwMiDfSz/DiBhh+26h4+caoXqlJ7EkZ+uHmvCrlbJ/zU2J4FngzjtZJEe6jogKuL2fPGaogu06/N55hoFoVXNMgFQcwmFb8nS1kOLUuv3PQFHzGzQNxk5CQmsXwYnNegnU6E1ZvdEwD6NiZ4ak8Gmr/oWii+cu6/yHg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VzRrNm8zSjFZd1drOFZ5WjUwOTI5UXNJaGZtMWpVQ1luTmlXNHoxVGdvSU16?=
 =?utf-8?B?OVE5YzVqbnp3YnE5UWN0dU1VL1NtRTI4aGwvYllwWFdSaVI2ZW5TSWVoVy9n?=
 =?utf-8?B?bVc0UWhjUVFWWC9SdjNPTUJxUGNibXA0WE1lWnlVRHNEWFZNZ0g5VFRqV3Jh?=
 =?utf-8?B?TWFSdlBramRYVDdxRXVIdzIvaW9OK1RXWFhmUFNQQkpSNitlejJQczY4OUx6?=
 =?utf-8?B?MVpsQVlmR0ZvOWNTbnQzaGxDYjJ3RGdlVElvdGRsV20wUi90UitmbnJKSTlT?=
 =?utf-8?B?dVpiRHQ3cURTazFwd3NERUkvL2l1RUV1ZDdkY1BicWVIK205anorYWgvc3la?=
 =?utf-8?B?TGJucTlYcTRESkpyeXF5M2JmeTdVTjdaUHFHN1JIa2ZQQkZySSt3bHJUNmpv?=
 =?utf-8?B?ejZlWmI5R1RtRUpUUUs0QzhIQkZKZTN1SnFUTEdFUHRiZSt3ZWVTUnE3T0pz?=
 =?utf-8?B?NE02Y3NsSEdyV3VZRVVJd250d0hCRU9BSHRsbHdZbm10Z25HNEszRmZVcHVQ?=
 =?utf-8?B?eHdzQ3hiZFdaOVBCSitvYjE5RlpsY2VNSDN1cUtzYkdNS1lsRTQvM2RQNFJZ?=
 =?utf-8?B?NVpkQUdINjhobmRmZysvS0FsamNXZGFLeTB6enRyL21adEZZelhmcWFvRlFV?=
 =?utf-8?B?THdBbjdmY3ZEYmh4K2xJZ0VoNkIvd3hwaUFHRjR6VlM3dCt3VS92ekNIOWMw?=
 =?utf-8?B?ZzRwUGVUbTU2THU2OFM3VzlTYUVsa3B0VnBrK1ovTnVlRGUxZGM4NzlHV29i?=
 =?utf-8?B?NDRxeHBQbW1TVkZ1aTNocVkrVGc2eDg3cTVvNmJndG9xMm4wbEZWQWdXNFBt?=
 =?utf-8?B?aWtLQnEvQXRnajE2WDZNWldJWXhwRjBLejhRUlJFZWpRUHVxV00wajM4N1Yz?=
 =?utf-8?B?b0Y2VWpXWEdjdXRjWkZXYk1KUW0xY2w0NVdpMXcyVHh0VVVhblM4Rmg0VXd6?=
 =?utf-8?B?bzZLTTZkNDRTd0pucndTVXA0NXRJN25vS25tRHpWZ0E4WXJHMzQ1Rkp0OXJt?=
 =?utf-8?B?SkxRYlVVSENXek5scVl1bExpOE9rV2hsbTJmbjF5YmtDNFV3cUlreElkcExK?=
 =?utf-8?B?Qmk4eWFGYW13R1V1a3ZiVE1pdHMwZjREYzFoNVJ2LzErbkJ3M2ptbDVmYU9L?=
 =?utf-8?B?WFJVcTdqRGN6dlRZTGh5bk1IQXU5K2tUMDNmK2FQWm5hVmVGU3JlNnUvVldM?=
 =?utf-8?B?RGcrWUd4MHdjNkJzUVNKVVhGVlprcGNQOXVYNUpZUHRkZytQUlZlN1BHTTF3?=
 =?utf-8?B?TWRmV21nUkt6UlBHeGtKT0l5UFJVcEhZNVlKMStVT3I1S3JsU0pZYnBwVkI1?=
 =?utf-8?B?QWlJNXc0dXo4SnBlQ0JPanBwNFFudHJOdmk4ZmdPMWk1MGxTbnUyQnB3NnZL?=
 =?utf-8?B?R1czdUR1QUVjVjNVVWltaC9ic0xjS21Ya1BsUU9HZGpqZE9TQ3NGWm11NDZ4?=
 =?utf-8?B?RFpsTHFLcHhCbWZCNHRGekRPZS9wTkVhMmY5aEdzU0N0QVhIZUVjbFAwbVZp?=
 =?utf-8?B?bDFNdWk5d0xxRlhLTTIvZmZpamw4U29NY2ZCeUhxRTI5T2F0VjZCWWVKVUFI?=
 =?utf-8?B?TE5KQ0hqQUhwb2FsTmFYRHJQMVJmNUtORFlXZDR2R2FxZnFOYjNoR0JPRHlq?=
 =?utf-8?B?TjhkZ25ESVdlODFRaU4yc2ZsZXRRMENMUGNRbHBjY2grWE5VR0ZPZlRySlo0?=
 =?utf-8?B?NE05Z1NVaFFtM1pYeENkMG9mM2sxczRaYy9jZ3d5OUUyQlJJeXhnQ0RxY2Jx?=
 =?utf-8?B?L2s1NDNTQXVCSG8rQnhtbHM0bmxyWS9TQ3IxTVRvSzlMWFM3SG5sWnJuUlVk?=
 =?utf-8?B?UHByMzJJSTR5OWo3TUtnUmdlelhDN21MRmxKMWdRTjhTTVA5eVhLNjJjWVZt?=
 =?utf-8?B?TjNNUXlDOWRLYlR3cmZ6bTR6SUNpNFV3ZlhUMnhZK0J1VDZybUh5YVVVa3FP?=
 =?utf-8?B?R2N1Z1hjVmxoVHFFbGk5bFJFSTlmNTgyQnRNTzlDT1huR1R3S2FJaytoaDlO?=
 =?utf-8?B?YlVmTWhCV2c0WTRpcTlCeUJKZkJjeVJEa1hhSFViMUFKRm1HZ09oanRwVHJR?=
 =?utf-8?B?N2RpTFRYcjV1bzdTS01rR1FDU3VFMDV6eFkrR0ZnVDZEVVBiQm9jUDhTaWhY?=
 =?utf-8?B?MHpMTVpDaEgzOWw2aC8wWTBMc3dtNmhQck4zVWsxYzRlL0FXaUtmc29Tb0xo?=
 =?utf-8?B?enFhak5LNVlLallhZkkzM004TXhuMXF1R2tzSFl1NjM5VWF3b0ZKNTlNZUFa?=
 =?utf-8?B?d2M4NGNucVBTdVpRUEI5TFVzRE5OTis2emlnYTE5cCtER3NFSXVjZU9YeTZS?=
 =?utf-8?B?V2Y2em9seE90clora1I3MWFuM3BDYUtLclZocnJZeTRUMWoyWGhjMHhMZG1j?=
 =?utf-8?Q?dvrbmUKoWNVe72Xc=3D?=
X-Exchange-RoutingPolicyChecked: QQImT/L7cwTbVDyS6qvPZBFq+wFfVSoykWefy4leqWAJ0IBLXQhksU64x6+QWiZK8OPzB+vFR5MWocIwFxh+CiFtji6zaOmd4BRrWnMqHaHfYAWB7QHbVX6QvcEd4YCMTQyg/fiV5qO7BDHP0LyVgA9wTcpQqiHpDZcnmRHI8LZWY4DPz8SIR2lSLizw4QXrnlqFLvsVEvJegnTqkorWJfb/1Vhq/tTzBG+V/XTq+dLApY9GKOQpgi818BW77LZQVbEYnANC2NGkDaWDCGmqct+qEpZ9X8Davm+YDjLM9+XEgMvRKVC+Mu9HGG3j4RMWVs14fxifDUuRdNwiZ5PlBg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 035dd85d-54b7-44b4-c0df-08de94e75b69
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2026 20:50:52.6296
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VjJpnEWqUKFnWxyglqFRZmWALqYh21qxVf/BBKhpCP83BD1S8H2pKAisfcM5ot0tnI0el7PQ9QCceQNpswewei/nQ0q+L3wRewVqKEN7Geg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5902
X-OriginatorOrg: intel.com

Hi Boris,

Thank you very much for taking a look.

On 4/7/26 11:55 AM, Borislav Petkov wrote:
> On Tue, Apr 07, 2026 at 09:02:00AM -0700, Reinette Chatre wrote:
>> Building resctrl with extra checks ("W=12") produces the following warning:
>>  .../include/linux/ucopysize.h:22:17: warning: ‘buf’ may be used uninitialized [-Wmaybe-uninitialized]
>>    22 |                 __check_object_size(ptr, n, to_user);
>>       |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>  .../include/linux/ucopysize.h: In function ‘pseudo_lock_measure_trigger’:
>>  .../include/linux/ucopysize.h:10:13: note: by argument 1 of type ‘const void *’ to ‘__check_object_size’ declared here
>>    10 | extern void __check_object_size(const void *ptr, unsigned long n,
>>       |             ^~~~~~~~~~~~~~~~~~~
>>  .../fs/resctrl/pseudo_lock.c:754:14: note: ‘buf’ declared here
>>   754 |         char buf[32];
>>       |              ^~~
>>
>> __check_object_size() ensures the provided buffer is within a valid location
>> but does not read from the uninitialized buffer. Even so, initialize the
>> buffer to silence the warning to help resctrl have a cleaner build.
>>
>> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
>> ---
>>  fs/resctrl/pseudo_lock.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/resctrl/pseudo_lock.c b/fs/resctrl/pseudo_lock.c
>> index fa3687d69ebd..e1e9134474f4 100644
>> --- a/fs/resctrl/pseudo_lock.c
>> +++ b/fs/resctrl/pseudo_lock.c
>> @@ -750,8 +750,8 @@ static ssize_t pseudo_lock_measure_trigger(struct file *file,
>>  					   size_t count, loff_t *ppos)
>>  {
>>  	struct rdtgroup *rdtgrp = file->private_data;
>> +	char buf[32] = {};
> 
> AFAIU, you're not leaking any uninitialized stack data from that buffer,
> right?

Right. From what I can tell __check_object_size() just checks that the address
is from a valid region and does not read from the buffer.

> 
> If so, why do you care about some silly build warning and are willing to waste
> a 32-byte memset on every function entry?

I care because I am including a W=12 build as part of checking all resctrl patches
and having this be the one and only warning that always shows up is distracting.
Removing it to accomplish a clean W=12 build does not seem impactful to me.

Of course you are right that this wastes a memset. This function is not on a
hot path though and I do not believe it would be called frequently since it is
intended to demonstrate how successful the setup of a pseudo-lock region was and
successive calls should produce consistent results.

> 
> There's a reason those warnings are behind W= ...

Indeed. This patch is for developer and maintenance convenience and not required for
resctrl health. No problem from me if you find it not to be appropriate. I will just
continue to parse the warning out of the logs.

Reinette
