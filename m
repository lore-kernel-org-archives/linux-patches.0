Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 755382F7EED
	for <patches@lists.linux.dev>; Thu,  4 Jun 2026 15:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780587107; cv=fail; b=XYhZJM9DK9TaLMzW5f+FwhvUwdvVVCRMdB76X8ZBZwvr255Xvsb5slK6NY5FgBN5BP8dEuu3LNlKvijaKANr2xGmfijQgpME6GnOJZ8fdWlb/tl3n4zUIZkmFdAKKCtLMsjhabt/pFmnsZX8Niq5+KsCfehBrdIBfWsK5vKLfZQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780587107; c=relaxed/simple;
	bh=xWOOnY2Zj1R8PMUMWetEWB4Nl8B8g86AVVkvkA9rXnc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NniyCxNM2X466BQ9yE/3o4THUy0UlRZ0P9kU+JV4ouelz0Cl6Tkq9kVDEVECS0wlmzTt3ZFrkOXpxjRkZPgLN8MlG6+Jrih3udh0qq4TrYWZuFNdhmRRXy3KK813fxDBpbTkLofwbRvO2GlSuSQF5LmTSg/N3YU905zPIS0idX8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mANrK0Mw; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mANrK0Mw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780587105; x=1812123105;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xWOOnY2Zj1R8PMUMWetEWB4Nl8B8g86AVVkvkA9rXnc=;
  b=mANrK0Mw8IGMC5ulqEJN1DkUrkAJcMdwVSz9/6h67WuQEajXd/aioBGv
   EXPByOX6GOFBvAarNarouLc2jo7mRGwTI3CmyKgrI6p3tb3nsP3sEvUtb
   kmJ8eC9tglaS6GlBnTQg0430/ufx8luWHgm1jzRHzKqstI0Q8NotnC52H
   qqspBnxIMhoWIPZ/Tb/93FEqodcATUOSzqPKurnlI2NYm0HTFj3q/AXVu
   Zr6hiGZkv1nT6T1CilbieUx9rL1CQelTppOBH2w8g1Q94bKE3TsuJt/CI
   cLRtVWNT5jBVU311xUMYew67/3gu91WyatnwLNljO7/7s+E/UWKUrXKQY
   Q==;
X-CSE-ConnectionGUID: k//gf4WZRsC7pobnXF/lZA==
X-CSE-MsgGUID: 1fTfd/dnRY+eRNGADnmKeg==
X-IronPort-AV: E=McAfee;i="6800,10657,11807"; a="81323357"
X-IronPort-AV: E=Sophos;i="6.24,187,1774335600"; 
   d="scan'208";a="81323357"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2026 08:31:45 -0700
X-CSE-ConnectionGUID: L4bkYK76RRiARj4+NNh1EA==
X-CSE-MsgGUID: NzusWEfVS567OhXjT3nKZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,187,1774335600"; 
   d="scan'208";a="268496116"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2026 08:31:44 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 4 Jun 2026 08:31:44 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 4 Jun 2026 08:31:44 -0700
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.57) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 4 Jun 2026 08:31:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CICKelSo6ijd39t/wr8ODZ2MYz4tEwjQe/HXBf4uyDWcNODQd6oTWi3UwaLTz5w1pW2oV448auTc6SMPc1rlNXO0P2G9zIq9oBrXxPyJ6pEGS0tmzYTFpa0hMW1BiF+rIzWEyx1K3tvMbTGBNOPjfA7OnBZ7koLbaaI+RUp/uuijWG3hNqxqBgTx3kJJAThUgfzv9OAlaDedkwNno4WbwPh5hoB1UASMHnW5PCg3RPOmoyz3mKgB+fWR8iaJzaZqKMm55+D5i58k7vmqnw2nt8ipzeZJHntZcRh+OMyLT6znAsZRr1u7d/bLPJOZIQZzSyZoxwctSxc7FhiNjVUAOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BAD6VUlM7B2EQLVGJzh4pjNl2QBJSApUUL7k2Ycv1QY=;
 b=IO4HvQuEOsAnTED2E/eZ9unZqoXVxlcQO4bgq8DlD3DlfPptiqK6N2UX64vMYJTp7OR1VIHlNYAUw0UEv8eozOwQENes707yG/RKyQ/r5w9IqHTiSrZkQX+5ybrde95txK6LOtzJ1zY7u0mG7FCmH/8hAqcY/phAPKVIsn6aDFyNgCNrjWxWljr9KnHwmna0uQ5s2LUjYmlzd5RvxslfSUCJvJLbjkd9IGdunhXy89FjQaZD43rilkNXzelnlp3uOSiEgrSqTA8ocCckoAK+Hg7BSqFhcZsmPexErR0A8OcRpLaQHPLXunyTs9NkP/k0rmkoSLLLAW7D7x8tcepbag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by BL1PR11MB5955.namprd11.prod.outlook.com (2603:10b6:208:386::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.8; Thu, 4 Jun 2026
 15:31:35 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%4]) with mapi id 15.21.0092.006; Thu, 4 Jun 2026
 15:31:35 +0000
Message-ID: <ec49c03f-9fda-44c2-9d3d-591818367e0c@intel.com>
Date: Thu, 4 Jun 2026 08:31:32 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 10/10] fs/resctrl: Fix UAF from worker threads when
 domains are removed
To: <tony.luck@intel.com>, <james.morse@arm.com>, <Dave.Martin@arm.com>,
	<babu.moger@amd.com>, <bp@alien8.de>, <tglx@linutronix.de>,
	<dave.hansen@linux.intel.com>
CC: <x86@kernel.org>, <hpa@zytor.com>, <ben.horgan@arm.com>,
	<fustini@kernel.org>, <fenghuay@nvidia.com>, <peternewman@google.com>,
	<yu.c.chen@intel.com>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <cover.1780456704.git.reinette.chatre@intel.com>
 <c6bdc19625e0aba4978db2031b7cefb3bfd6fbc1.1780456704.git.reinette.chatre@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <c6bdc19625e0aba4978db2031b7cefb3bfd6fbc1.1780456704.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW3PR06CA0019.namprd06.prod.outlook.com
 (2603:10b6:303:2a::24) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|BL1PR11MB5955:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c0d812c-ae82-439b-a433-08dec24e5cb3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|11063799006|56012099006|18002099003|22082099003|4143699003;
X-Microsoft-Antispam-Message-Info: J0f0oZfiHAMjEqwKp08FU4YSYh78Pryjm1koRoJA6nJDclsNoCcxjsuX2J4yR5lrYe9wQncUSkwInlEfRKpVqzRqy3vPdY+EdRgoNPBmLAhcZKxeL5i+bYnbIYfLCx46HE9tIS5tRYMR2EmvL+ILi7iDGEvKMhEAUU4faTwU8XqGg6VqmW9zAlknJ25/tMaSMBg4lmKzgDr5DbzzPSXUhv8nsDmg+2HdBGonYQvlsY7Vs/8dPLyBjuNeCiek+UFwG0kigyAA4G+O2Isl4TdzCPcSY3bLbOy9cOtAYcnuEib2SUmtTmjRDKH6fgKG13UlmV6JISreiJMV4LjtdoC1SrSYMW8tCjEfvIhvGcr8YOKNpuW0QqykNQWyh3FB4oz7Wr5sH3FDC3A9+TIb5lh1gH/YOzvxsDk6V4Ag946PZCL/qq6UHFOqW4g2+N27FszfA5z2WNf7Oi+QAgwvW2UdtLTvgEsxNw0VTfHHdnK+V2x4PdN4nExMxeq7iztNYMMm3l/1YM/AbzfhBu926VCgOuzbhzN+cJ3sQQp94usW4ZRiIoqmEetwiBqLLHIYdxJB3ldMNFhJUQ/dbdv7XWu1T4I8FtDZckEqzlzZGkg6Nnx3wGV0W+zT9YtMGzzgc0OX/TH4YFD6t0X2UF/XSTnF1g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(11063799006)(56012099006)(18002099003)(22082099003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cWZEaEFkM2JITzB5VXVrSWwrZ2dwamQyR3JIUDRBV3N4Z2tJRUFQRlRGd1FY?=
 =?utf-8?B?U0syaThsYldZTjJUaXZFSnB0WFNQNnhkWVFhSzhkTXBoeTNuNHFxWUduRVZk?=
 =?utf-8?B?YnlxdlFyNDBXQ1NvdzhtZjRSY2M4alFBSmt3MTVrYUx1czhjcVEwY2Ntd0xS?=
 =?utf-8?B?YmQ5QklxUnpTanNVSkJhdVpuMkpQTTFtQ0FoK1FsNnc4UURTUUptNVF0YXk4?=
 =?utf-8?B?cHhNbkRSNDNsNEdmUDJDbFFvMnRyc3lQUmtRRUgrbGZjWk1iQmh6WXMrSGdj?=
 =?utf-8?B?cndRZTZHcUlEbFd2OVdEWHZZeUFFZzJCZk1PclF0alNnUFpnRWZITW9KQy9i?=
 =?utf-8?B?NEI2RWxTOWVZb0tPNGhlRXdnUVdWWXNoUG1jd1doM1Znd0xodjE1bnJybFVL?=
 =?utf-8?B?LzJtMzN5ZGtDNGtZM1ZSZmdJN0JVem1PK0FrRk5ZZ0FTcGhpY0pjQ0RMMDR5?=
 =?utf-8?B?OERuaEI1Wk9lTlMzZW9BdldmZ1JFY2phWHRGY1pvd2xTN216d2pJK2xEajNj?=
 =?utf-8?B?YUg3bUgzK05wbk9CYXNHOUpLaFVRbXVWUjA5WGtlSDdMMFVzalQ5M2hVbHlB?=
 =?utf-8?B?ZFYreitMMXB3SHhiVEFIMDBtYTZzblVPbWJ5VUpOQ0dKOVFDTFVSUENHVnhK?=
 =?utf-8?B?UndQVERXd0lFVnFoOHBxbGdBYTJKTDQyVGlCcnE5WVRaOTBtdGhhRkU3bHRt?=
 =?utf-8?B?ellOVWg5SmUvM0lWcnRNTi9UREI0SHZOT2FvNks1dlllcnpnN0R6TFRJY3Bo?=
 =?utf-8?B?NHNoQ0orSmZYbVlrK0NwU04yQThNU2NhYUJ5Ni9KWmI1dTdhbGxSSDVNWlo4?=
 =?utf-8?B?YXBBbzNEQVBSeHg5bFhOS1hCMzNPR2ZRNnZTN3BQYWl1QVlaK2V4TmF1MzV3?=
 =?utf-8?B?bDBRZGloOEt3dmduelVpemN0b3JCODhPU0dZUitiZ0s0UjBIajExY29HaDJ3?=
 =?utf-8?B?V2JMQ3pzWU1GNHJNSDBrSWhlNW5jYjBBL3dJV2lpMzdJQmo0Y2didzRWL0Zl?=
 =?utf-8?B?bVFiTEIzZlpBb1BBZmRPdjZRWjlCQSt3U1EvRWN1MmI4NW01YjRtRURzc2sy?=
 =?utf-8?B?N01KeFBLM1J1YnRNb2RzUkdwdkdFUFZsVXlxRzA5ZUk2TFUxcUFOMW9LeGdm?=
 =?utf-8?B?dlo4cGt1WmtvbUhJQTVVeGRGOGZWdk54NHZRcEFCd2k0bGt4b0Q1cjRBekJq?=
 =?utf-8?B?SWpqVzQ4SnIzNDRSenppTmJTSjIzRnNRc1RPK3haQ1RDc0l6blpyQkxtdTZ0?=
 =?utf-8?B?UFcvbnRvM0dwRTZuRTRpTkVQMERscXFHbjVnMEQybTFXbU9aaEtRZEIzcWIv?=
 =?utf-8?B?VktnaVc0L1J4a2hwRitPaTUvN2JiWGtKR3YwR1lYanJ6ZWVNWEk0V1hPY0ZC?=
 =?utf-8?B?N0l2bHRlRHhMd3ZETkpJZEVNODc3Zmdvejl4QmNuUStUZHdHZWRsQ2Ftd0JH?=
 =?utf-8?B?QzREa2RmQkxJNzBwd2o2LzFYU1ZoeUt4VmhrcFFGbXA3dWVRYjgrRzJ0bFF5?=
 =?utf-8?B?N1JMNWVoU0VCMCtxTm4rYUUyZW5VY3gzWG1ZZzZWTzdSZE95dEJLc3pPSnB3?=
 =?utf-8?B?dFRLbDJOT3RtQlMwUmFLL0wySEIrNC9vTWF2UThoMUNMdUM1SWZxWGR1bE8v?=
 =?utf-8?B?WWs3R2lUQ1NLRmhERXd6VEpSREpxWTc4V05FbUtOaHZ2MVMwUlYrRFFIVTBz?=
 =?utf-8?B?WlpqK2MxQ2M5L0tqK1hUNTFjR29iU2xMTW9MKzhPcW94MDRGTEVFNVpwSTlz?=
 =?utf-8?B?U3hHZ0ZPNkRBbmVaQ1J3ZzI4N21NcmcveHBpeUhLbWJFRXlub0hyTWNxSWox?=
 =?utf-8?B?RzViYnBUSUh2WDc5SmN1ZkkzM3dMU2tZempCSWRySTA4dy9xUFBpUVg2WnNR?=
 =?utf-8?B?bjNad0xuZTR4QWRVbUtjTEZBcEZVLzJkejJ3NXBoc2hlSytoazMxOVlqd3Iw?=
 =?utf-8?B?d2hzSWhKTGgrTm1ubTdBSnlYc1ZFbnAyTW9xdG93REx5bjNkZUM2dVlSMFZD?=
 =?utf-8?B?WU9teW5obTZ2TTR6QklvZ3JMMlhpWDR4Yk9QbTdndllXSXdsQ0xiUE4wUGdF?=
 =?utf-8?B?MHhmZHRWK1pDRkgrZlBZRW50WDhPaC9QYTRvbWJvWE9IQzNGQ1o0UGpPTVBH?=
 =?utf-8?B?NFQ3eTArc29qUGVuQUtlbTFVczY3Q1FwSklqaDJ6cjdHOVdWa2VJU2U0cWdr?=
 =?utf-8?B?QUIwYWJ3TkZMY2x5b0R4a2dhRGZaeDhYeHpGeFlONnBSaThXQUkzUU1VOHJz?=
 =?utf-8?B?NVowTzB6ODlSbmNScExucTZXamNUNnRvZi9RbTBWUUZQcXRLaDVZU000WW1q?=
 =?utf-8?B?S1FZbmN5eVgvZ2U1VUVQQjFWc3dOc0d5ckk2NFkySEdNaGt3RGhRVFQ3ekpE?=
 =?utf-8?Q?Yvt5H02NBICyqfeI=3D?=
X-Exchange-RoutingPolicyChecked: lBUpHnEQ/1yb171d20f2+GFplyspNkOKg9qSWdgYs1vhkCtizxNm39EWZv0IB9JaqQFX3v3KPdmC43MFLXPeVQtBVANIqze//DB609rzYZXNmpFDgaRPjZCt5TMY6p0zXa6Ldq9ZHpqkrbYrMcQ85Z4yDzqlqEGnbkq+5DHNiqtVjZh4DBEtHfet8QcJd1znN2m2xALQgqPVkB44J1X5S03/5qK5uoMP8HNj7pYgsdTzr+xfq2ubC9Vi0L9FteHPKnzz9MFwCMGYRxJI+BAJ6Uf6XHvBtEo8AsTwQyh8FWFYhs6XuO00OWwrhtD6jgZH8fI1RpB+CR4hl132FUPI4A==
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c0d812c-ae82-439b-a433-08dec24e5cb3
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2026 15:31:35.4160
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vZ20VniPHgSJ8BmoaQBZj2CpfDvlBxRwvnzG51s3uKmqIp9VO2VPc90CNh1SfEEnLz7EEMJKk3F0LgfSOVKyzCBfF8M3oIIyAoY8nlDBiv0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5955
X-OriginatorOrg: intel.com



On 6/2/26 8:27 PM, Reinette Chatre wrote:
> The mbm_handle_overflow() and cqm_handle_limbo() workers read event
> counters and may sleep while doing so. They are scheduled via
> delayed_work embedded in struct rdt_l3_mon_domain. Architecture allocates
> and frees these domains from CPU hotplug callbacks under cpus_write_lock(),
> and the workers acquire cpus_read_lock() to keep the domain alive across
> their access.
> 
> A use-after-free can occur when a worker is blocked waiting for
> cpus_read_lock() while the hotplug core holds cpus_write_lock():
> the architecture frees the rdt_l3_mon_domain that contains the worker's
> work_struct. When the worker unblocks, the container_of() it performs on
> the embedded work pointer dereferences freed memory.
> 
> Drop cpus_read_lock() from the workers and instead drain pending and
> in-flight work synchronously before the architecture can free the domain.
> Since architecture offlines the domain under cpus_write_lock() after it has
> been unlinked from the RCU list and a grace period has elapsed, no new work
> can be scheduled. The cancel only needs to wait out existing work.
> Drop rdtgroup_mutex during CPU offline around cancel_delayed_work_sync()
> so that a worker waiting on the mutex can complete before re-pinning the
> work on a different CPU.
> 
> When offlining a CPU the architecture may iterate over resources in any
> order. For example, the MBA control domain may be offlined before or
> after a corresponding L3 monitor domain. Ensure that resctrl fs cancels
> the workers no matter what order the architecture offlines the domains.
> 
> Fixes: 24247aeeabe9 ("x86/intel_rdt/cqm: Improve limbo list processing")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/patchset/20260429184858.36423-1-tony.luck%40intel.com # [1]
> Co-developed-by: Tony Luck <tony.luck@intel.com>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> ---

Sashiko highlighted [1] that since this patch ensures the workers can complete
as part of CPU offline the worker is more likely to run with on a domain while that
domain's cpu_mask is empty. There are places where the workers peek into the
domain's cpu_mask. For example, 
- if SNC is enabled the limbo handler needs to know the NUMA node ID of the
  domain and uses a CPU from cpu_mask to determine that
- both workers always look into the cpu_mask to determine where to reschedule next.

To protect against this I plan to add a check for an empty cpu_mask at the start
of both workers and just exit if the cpu_mask is empty.

Reinette

[1] https://sashiko.dev/#/patchset/cover.1780456704.git.reinette.chatre%40intel.com?part=10
