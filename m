Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C92230148D
	for <patches@lists.linux.dev>; Thu, 23 Oct 2025 17:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761241743; cv=fail; b=kQQMlgHflsPtNvkfmoeNE/rNP1uBd6s5NhaiSXaGExbOsTBcJVNWp/hBhhKufskTzY/pxl0oYzVzIVv3AXsS/doeVN2HVtUYk9XR4r7zyv/P4Ck2KdU1yWZSR+eHsLHMz+oq7rEpkRQcaaXmNyR8BH6mtGCTsM5jW5xPZl9Zohk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761241743; c=relaxed/simple;
	bh=3JMiVb3AuaWQYTUqe0wVxbCYik51Mu57bvNtbqMUSyU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=q70m5IQ3M2w3q8z8f0Jh3Io88/4Vu0iF/km/psr6pzEDYoybYL61TncyH3CY0kCzYPoOyjk5f+zoaKUuOHzWgX1d4rZtSc5RhBNW3rjJlSzIeKaGo43CzHWG+s6o63t73pq6swK1LMRkDDNe8mVKiFhm0IP6kRnae79iDy3Yutg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YjN+6S3l; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YjN+6S3l"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761241741; x=1792777741;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3JMiVb3AuaWQYTUqe0wVxbCYik51Mu57bvNtbqMUSyU=;
  b=YjN+6S3lwNFsgAfjlhS5Lt2Pz+vNdTFOXD9Lgi99fcdrFXJJPWeAccHW
   Dd70fBvw2FV0A80FMZHYxL9+kjq4V5gSErXgvxAbXxtEZ2Nu3+7/O7sR4
   7fk+vTELHTLzl1Stb2yPkSO2sDV+L17DONJL+zndqEOQRZTtfm/aNjK0M
   i9c/3nuAKvExIkF5vL/18+gQPBKwQfcxODXqPHAIOmmJ16F097YL7IFrQ
   0ePmexaNiAN96pJtzyHd6DwCO9OEfut3k34m8Wige0px0WyrI2r1LPuK1
   MnY+9VGkcfem26cGJ72GYWmPt9IdRbWTtYy4daC/JnyFRTCdhu9GYOzgw
   A==;
X-CSE-ConnectionGUID: T4rknYK4QBKcOko3m0vVMA==
X-CSE-MsgGUID: BPeRTprDTji0W7xtw5roLg==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="63515701"
X-IronPort-AV: E=Sophos;i="6.19,250,1754982000"; 
   d="scan'208";a="63515701"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2025 10:49:01 -0700
X-CSE-ConnectionGUID: 0VX0BQfpRJ2KRxpRMC26bQ==
X-CSE-MsgGUID: yKK8BYaRSbWsi83LnYYy0g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,250,1754982000"; 
   d="scan'208";a="184606129"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2025 10:49:00 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 23 Oct 2025 10:49:00 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 23 Oct 2025 10:49:00 -0700
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.51) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 23 Oct 2025 10:49:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ulU30BNQGT1pHnfXU6Qcx4wMt74Ot+G32mMbvXqiOKiw5ixSxNnFNSnxpKCPWvk+ZCOfOrVWTYF9PuCKOE4J4uTZ0GGBW/f0xZ5iE1NP7jtriQZg2303ZCe8c9WVRcUwpsNlXl4jcUGPGWk7wWGHtXD3sKrVnQoxmNxBC9DIIXENX+2XIZJbgMTOW3fjOPX+ZijjiTvPo5+13/WGH2//maOTTxW2vfhjt8pqahf+suE++hyUBae8fFvOl051zauarSmm9/bTyD+YNaknjGWlBZSIMMz5cI5rERZuZKjQeFY0bO3NjWbg6Qwxw/a0yQSVzM1lBRdHltYu24MVOq1SNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4n64bmsbspL+JsjwXyZTSUV2PgNLvDzGg+dfFOGhjkU=;
 b=rzEntg8bA6lxwgSHkjO5t611Ov10PtUfQLiFN2/039MZS9fxyIJZXsRh/kQhDo9GQM/5BkeEgVQrIoe7Zy/Y0jJtGKZTX5mBN2PE8ocdjK99MFHy/kTzFMxm+Bxmi6yNNbE7gveOT03QYicybG3sqyOMWepMOeaXce/GRw01xfQOH5jBK2154o9vuuq2DhmQAU5JTm/m70WfvVTvaS7ZFpcO4ykA5L07p6mVngtaDoABcXICYPoZ/2d2DT3ChJsu6SMXpOHHO+IzlNIYvFZjB5XtBBvAy9i//ju/Xpa901+Pw863ihywfePlbVGAOPOKbvaf7TRFQN3AJke+uVBX1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SA1PR11MB6784.namprd11.prod.outlook.com (2603:10b6:806:24c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Thu, 23 Oct
 2025 17:48:58 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9228.015; Thu, 23 Oct 2025
 17:48:58 +0000
Message-ID: <c25144f8-f6e5-407c-a6a8-f382beaabb50@intel.com>
Date: Thu, 23 Oct 2025 10:48:56 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 24/31] x86/resctrl: Handle number of RMIDs supported
 by RDT_RESOURCE_PERF_PKG
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251013223348.103390-1-tony.luck@intel.com>
 <20251013223348.103390-25-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20251013223348.103390-25-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0128.namprd04.prod.outlook.com
 (2603:10b6:303:84::13) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SA1PR11MB6784:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e523074-0b30-416f-b03c-08de125c715b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Q2QyMSt1dWNWcEtvT0tHUnNBMFloYXQ0TDFvK0IzKzJ6WWdvSlNkcitJN09W?=
 =?utf-8?B?TEJuZFZxZ3YvalJjeHN3cWI3OGRRVy9XK3NJcnlBSlNpT1NzSGdTd2dDNkNr?=
 =?utf-8?B?N2FCTUQ4eGF2K2FaRWJ3RkpHY2E1U0xKT2NCanp4Tk5FUk9zL1Z1YjRSNTd2?=
 =?utf-8?B?ZGZWUnY1bUlMNWpzakorRTBmTlgvQTZIVVBJOENYUEN2eUsxcGpVZWhEbnpD?=
 =?utf-8?B?M2F1WTJUN05tSTJ6Yzk3VndJZHBvUSs3SGNzditSUGxmNWx3YjA5WWxKbDBD?=
 =?utf-8?B?Y3JPb1JVeU9DWURwaEJMOEJwVFYwWlJwTm5ab0RtUHZhNTZjU3ZlaTZVMC8r?=
 =?utf-8?B?RGpid3N1c1FTS1JaY0RWd3dRZXQxWlNmY1g1bG5BK0JXQm4xQmt5VlE3QlhY?=
 =?utf-8?B?bE9oeXdENWFERzdHSkdydjVtRmoxb0dxYkpBTXVFWjZrVkdvU3NZNitZYUZF?=
 =?utf-8?B?Y2g5QU1TT1pqcFZ6bWE4R2d1bTYvTWNjSC9ySHY4V1dyT0R3VjllaUIvUjFI?=
 =?utf-8?B?bGxKOElMYmZTa0t6MGZRS3JERm5KT3g1ais0TjdkY0srNmIrb3dwdDEvVGVJ?=
 =?utf-8?B?TjJlT1huQktvNmFINkVzOFpVOUF1cW00RWYxOUcxM1hJMkZQaGtSOU9IdVMw?=
 =?utf-8?B?b2RMalJZNHdCdGd0U2xQVmk0UTlnMlAvVTBCYndTRVFLM21OKy94WFY0ZUs5?=
 =?utf-8?B?QlJRZjJQcWd4RjVEaWh0bjJuN1o1Q2VXb3hORmZnUU5TUEdCeEE5TUtnZUJJ?=
 =?utf-8?B?bzkwKytzTXRzQ2FEYnhZdC9EYjhud0lUQm1PMWJnNVV1REtnMkRoRWJmcWM5?=
 =?utf-8?B?eWNsZFptSnhmWjBmR0YrS3ByM3RGN0s5VWpzb2hCWlBIMjcvSFlTcXV4cXlY?=
 =?utf-8?B?eE9zRFRLTWdsaGl1UHNjTk1WaDFVMXlkYXd3cVcvZXpXTWIxY1FOY2QwNzZz?=
 =?utf-8?B?TlA0NXJ3aGllbjVoUHpYREtSYWFHNHVHU2pVNjlMZWlDVEJnQXl5NXk1TlJw?=
 =?utf-8?B?YlhHUkc2QjBuT2NyblQyQy82eGN5SmpDSHM3STlMd2dabnlXdFRHUjJGcVVl?=
 =?utf-8?B?Q1VQdkttRk1OdDU2aEZ5dFIvdU8vUnpBdlVuWnhNb1dRZXFsUVFJeGxYaUZL?=
 =?utf-8?B?TXpOZWd1NllvVnNqUjFFOE4zL3JnK2VwS1Nod1hqd0hZU3IycUtSaVpyRGlp?=
 =?utf-8?B?MWNrMEpNelRxaWl1eFg1YmxlYnROcEFWZmo5bGNGYmlWalNvcDFmUmRSOFZv?=
 =?utf-8?B?T0NkTHU2SGFRaHAwRm83VVQrZjJ4SUlHYUxQdHZzd1Vua1FFU1dCb0tNcVBt?=
 =?utf-8?B?YXZBb2Q2cGh6Q3hNWFFkQ1VSYzlRV25ocWFFVFN5ZTg5bTJpUjJLTWQ2cUVK?=
 =?utf-8?B?M3JqWmQ5bUVxNXVZM0sxT2FubGxoQ2lHNVJ6dTNnZml3Mng4d2V1bkhBQjdV?=
 =?utf-8?B?RWM1U3BuYWtLODU0cTVzckUzdTJXUExybnZyR2ZvVVNrUFF5UmNWa1RPVzM2?=
 =?utf-8?B?MmpUWldFWGxNWnpXcjI4RnNVam5nOEs4RE1sQThZWUJNakl0M1Nxak9XcnRU?=
 =?utf-8?B?eG1pcVM5cGthTG8zaDBxaUx5dXVBc2ZVc2dvZy9HZjl2SWEvbHczZFRWYlJW?=
 =?utf-8?B?bFY0d2JLTW5Ca0ZZVDNPQ3JNeEtmbi9xaExvc3JpSzBoUE1lNThzSlVGNEhD?=
 =?utf-8?B?NWpwNjF1c3VwMmtwVldOS2l2YTdFTjRUR0lncmZqZ0tNTEJIaW9tVDF5U0JJ?=
 =?utf-8?B?dFA4K1dwOGhpY3ZCN0dYc0VFbktUMmhITmpzeGozWmR3UitZUUhqOC9uZy9E?=
 =?utf-8?B?Z3FjVmdEdTdUeVBLdFJwSW1CTFN1YnRaQ2tEMXdIR1VzVndORm9OTUNOU01M?=
 =?utf-8?B?QXhDYUphcmU4TXdieEs4QTZlcmszVjdRODcvVmRsWENDT09aSkk1bWFjVmFH?=
 =?utf-8?Q?k7pXPq7GhcT1RNUwW1hZcfwPNEGX+H10?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SXBiRTRLa3l4WWZCVlV1TWxXRTBQQ0pIeDhMeVl1NUxialdUVUlSY0dFcHBX?=
 =?utf-8?B?dEc5bmh4RmI2Tzl0NTRUK1d2QWw4ODhnVUNoUlFtOG41NlR5eUgzYXVOMHhL?=
 =?utf-8?B?OURXRFVFMmZkbDljZ0JPQlMxN282VStBdE53UUh0K1Yvbkl3RlFoak1tQUVH?=
 =?utf-8?B?Q1FhZE9yOVBoNVU1bndvbkNoMVZoQm5jYzBzQ0hYR2pkVmhRTnB0ajFkcENh?=
 =?utf-8?B?ekUrMnBvYUY0eFdHOTN2MS9lVGpjYXFpNlM5U0RCcm1QczhuZTIzb2FZSnhj?=
 =?utf-8?B?aU15bzlFNThSNEhPQVBZTjY5WmJ3eFZvRFByMFRMV2cwSCtueThQT1UvSk9L?=
 =?utf-8?B?Q282Q2dqSDI0TmVqdEcxNS9TUVpLaTVkUjA3dlF2Vzh2TUdMbm5lRXlpYkli?=
 =?utf-8?B?eGU5SXU4ZWU5OUhFMTR6UTNGelRzQnNLSml2SkFKU3RUWFQ3amkzL0dycks0?=
 =?utf-8?B?L1JtU0dvMWdOYnp4NXdPNzFQb2Z2Umxxb2w2U0NYZ1FPY3g3Yy9zcW1ZKzdG?=
 =?utf-8?B?YzlubndnV1ZkUmFYU25RTmdxa2VJNEtvcjNrcGwwTmJwcU1va0MvMFlRSExn?=
 =?utf-8?B?K1ZwQlR5QnBJMWVydktMMXFhQkZIR09jUm0xcmlaZ1I3SThDR3RjNDJPZTlX?=
 =?utf-8?B?TC81eXJlNVV0VzYvN1BXZ1hrTHVsbjV3cytoZWJjSzROM2hPK2pCZXZIWjhB?=
 =?utf-8?B?aDlnRU8yNDF6aUZrRXZ4TktWazkySDJCZXBZMXVMUDN4Q2JucWhDOVpLQVBy?=
 =?utf-8?B?Q0JhMGUvS2VnMmV3TUE5SGhjRE41a2dBbFhNTTZkaGNQZlp2YjdTSEJqcE0v?=
 =?utf-8?B?ekhYMHpzNjJFU2N1Sm55QVZoYnNmNysyRzBlOU9JVVdKZ0hpcVVJVEU3cFpz?=
 =?utf-8?B?a2ZlTEZtRFk0cDNNWklxRk9rN3M3UlEwNm5xZkVYR0xid2Y1YVdWaDF2d0hq?=
 =?utf-8?B?VWp2MUhrRHpaTStFbnM0cnZPaFpqSjdPLzZkZ083S1N6Tm5HZ0thVUE5SzBK?=
 =?utf-8?B?cjhVWXJLSGI2anZUbVl6OERGWDFPdVEzZG8rQ1FQNHFlbGhWTHgzNStXUWlG?=
 =?utf-8?B?N2lMMDRFTENPUHFVSHdoR2E3emJEZmJValZDaXBKcUhTUFE0MkZmdkppQVlm?=
 =?utf-8?B?VnhxTEdjN1FtYW9ldlU5ZVU4Ry94UFlTanBMUDVuellVMXVJdGhudEpRZWly?=
 =?utf-8?B?ZzFpT3FxdEZ3WDRPUnhGMXI3Z0xWdjAwd0p0dFVXL0NhSGQzcWJWajN6OUMx?=
 =?utf-8?B?a2QzY2h5aDBzZTV3V0VjOENHVzJIaFNHcHNaNW91TUUvNTRrR0hUUld6SG81?=
 =?utf-8?B?am1BL2o5Wlp0Uk52aWNMSDkvL2JkaEw4ZUNpc2MwTHFzQ2tvbms1Q0NDZnha?=
 =?utf-8?B?STNyNUJqeG8weTZsUFpWOUNPMzRTL0JoajUyQmpxNVphZjM0dnVaK3NwZTA3?=
 =?utf-8?B?S2RkcHNzeElaMDc3Mm5SaEpjMlZRN0pMSGcxOWh6bUcrcHR0VmRLYUFpa1ZC?=
 =?utf-8?B?SS9mekhOb2hYRFdJY08xN1YyRStwUTZhV1B1WTdxUllNRDVMQWNXZTRxQi8y?=
 =?utf-8?B?dnRIU1VlLzJMVEwyWFdLbXdia1VFdVJ6bGpzTFJPMUNWZGY5WkJmVUhmS2pO?=
 =?utf-8?B?dVVzdUpZUWR3QkJEOHh4TVZYR3pQZ04weEh4L256UUZRS25EcUVWV29DYVBL?=
 =?utf-8?B?dksrZDk4MjBnOVBlWmQ3aVN2cUcrWnFtN2F1b25LMURZak1HZzVoeGplb0VP?=
 =?utf-8?B?aFA4YW8vaW9Za0sxQjh4N1lvRVZlM2pxM0xnYU10cUVTQkNZR0pmQTBmTWJs?=
 =?utf-8?B?bmVIb09lWEtaS0xKNjF6NEd0ZmhJcWQxTjFzSFF6RTVobmxYaWoxZFVsUXdY?=
 =?utf-8?B?Vi9DR0FhV2lmRUk3RzdsejgwdkRaOG1wYTdsY2QxU3J0bzdXa3owZ3ZpbHpa?=
 =?utf-8?B?R0xMSzBtZ3lxNlhyZXNkM0JveGhEVUZpNXUvWVVad0F2ZFpOTDJTSEpuanM3?=
 =?utf-8?B?TFJXNUtpUUZXejRzYWdDQzc0SC9vZ1dzT2RxRWFHOGU5T1dnUVkvM3ZpZy9N?=
 =?utf-8?B?d1c4UDNDS1NHeDBaM0dwc1ZTYUpUbUEvOHloRWFoSjVWQ3FRT3NDaFoxS2VB?=
 =?utf-8?B?ckVMQnY5RHhFZVcvMEN6TGlFR2xrWktGSUJOVmdIWEVlZ3V1aVVxbUJYWGcv?=
 =?utf-8?B?ZkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e523074-0b30-416f-b03c-08de125c715b
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2025 17:48:58.2627
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i7BlTmrLvhy+7jZel6lFs/pQkhQR3yS0wAN0Jt7hXzmFParUBPUmGYx4L8OCpBlKQeL5Qy8N9gpIGQqiMxAThMZTaa5NXzd8HlZk+mnAdRY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6784
X-OriginatorOrg: intel.com

Hi Tony,

On 10/13/25 3:33 PM, Tony Luck wrote:
> There are now three meanings for "number of RMIDs":
> 
> 1) The number for legacy features enumerated by CPUID leaf 0xF. This
> is the maximum number of distinct values that can be loaded into
> MSR_IA32_PQR_ASSOC. Note that systems with Sub-NUMA Cluster mode enabled
> will force scaling down the CPUID enumerated value by the number of SNC
> nodes per L3-cache.
> 
> 2) The number of registers in MMIO space for each event. This
> is enumerated in the XML files and is the value initialized into
> event_group::num_rmids.
> 
> 3) The number of "hardware counters" (this isn't a strictly accurate
> description of how things work, but serves as a useful analogy that
> does describe the limitations) feeding to those MMIO registers. This
> is enumerated in telemetry_region::num_rmids returned from the call to
> intel_pmt_get_regions_by_feature()
> 
> Event groups with insufficient "hardware counters" to track all RMIDs
> are difficult for users to use, since the system may reassign "hardware
> counters" at any time. This means that users cannot reliably collect
> two consecutive event counts to compute the rate at which events are
> occurring.
> 
> Introduce rdt_set_feature_disabled() to mark any under-resourced event groups
> (those with telemetry_region::num_rmids < event_group::num_rmids  for any of
> the event group's telemetry regions) as unusable.  Note that the rdt_options[]
> structure must now be writable at run-time.
> 
> Limit an event group's number of possible monitor resource groups
> to the lowest number of "hardware counters" if the user explicitly
> requests to enable an under-resourced event group.

How about:
	Limit an under-resourced event group's number of possible monitor
	resource groups to the lowest number of "hardware counters" if the
	user explicitly requests to enable it.


> Scan all enabled event groups and assign the RDT_RESOURCE_PERF_PKG
> resource "num_rmids" value to the smallest of these values as this value
> will be used later to compare against the number of RMIDs supported
> by other resources to determine how many monitoring resource groups
> are supported.
> 
> N.B. Change type of rdt_resource::num_rmid to u32 to match type of
> event_group::num_rmids so that min(r->num_rmid, e->num_rmids) won't
> complain about mixing signed and unsigned types.  Print r->num_rmid as
> unsigned value in rdt_num_rmids_show().

"Print r->num_rmid ..." can be dropped since that is clear from the patch.

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

...

> @@ -156,21 +168,59 @@ static bool skip_telem_region(struct telemetry_region *tr, struct event_group *e
>  	return false;
>  }
>  
> +/* Side effect: Detects unusable regions and marks them as unusable */

:/

> +static bool all_regions_have_sufficient_rmid(struct event_group *e, struct pmt_feature_group *p)
> +{
> +	struct telemetry_region *tr;
> +	bool ret = true;
> +
> +	for (int i = 0; i < p->count; i++) {
> +		tr = &p->regions[i];
> +		if (skip_telem_region(tr, e)) {
> +			mark_telem_region_unusable(tr);
> +			continue;
> +		}
> +
> +		if (tr->num_rmids < e->num_rmids)
> +			ret = false;
> +	}
> +
> +	return ret;
> +}

This does not look right. Wouldn't this return "true" for all_regions_have_sufficient_rmid()
when there are no usable regions? Trying to have one function do two things is not working well here.

This also seems awkward where the regions are marked as unusable here as a "side effect" but then
later the caller attempts to track "usable_events" separately? This change does not look to be
integrated well.

Why not just determine which regions are usable as a first step and from then on just interact with
usable regions? 

> +
>  static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
>  {
> +	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
>  	bool usable_events = false;
>  

This flow can start by determining and mark which regions are usable. Could be something like:
	if (!group_has_usable_regions(e, p))
		return false;

To reduce churn group_has_usable_regions() can be introduced in patch #17 to replace the open
code of it in enable_events().

From this point the "feature group" is guaranteed to have at least one telemetry region usable
by the associated "event group" and all interactions can be with just the usable regions within it.
For example, all_regions_have_sufficient_rmid() can change to:

	static bool all_regions_have_sufficient_rmid(struct event_group *e, struct pmt_feature_group *p)
	{
		struct telemetry_region *tr;
		bool ret = true;

		for (int i = 0; i < p->count; i++) {
			if (!p->regions[i].addr)
				continue;
			tr = &p->regions[i];
			if (tr->num_rmids < e->num_rmids)
				ret = false;
		}

		return ret;
	}

> +	/* Disable feature if insufficient RMIDs */
> +	if (!all_regions_have_sufficient_rmid(e, p))
> +		rdt_set_feature_disabled(e->name);
> +
> +	/* User can override above disable from kernel command line */
> +	if (!rdt_is_feature_enabled(e->name))
> +		return false;
> +
>  	for (int i = 0; i < p->count; i++) {
> -		if (skip_telem_region(&p->regions[i], e)) {
> -			mark_telem_region_unusable(&p->regions[i]);
> +		if (!p->regions[i].addr)
>  			continue;
> -		}
> +		/*
> +		 * e->num_rmids only adjusted lower if user (via rdt= kernel
> +		 * parameter) forces an event group with insufficient RMID
> +		 * to be enabled.
> +		 */
> +		e->num_rmids = min(e->num_rmids, p->regions[i].num_rmids);
>  		usable_events = true;
>  	}
>  
>  	if (!usable_events)
>  		return false;
>  
> +	if (r->mon.num_rmid)
> +		r->mon.num_rmid = min(r->mon.num_rmid, e->num_rmids);
> +	else
> +		r->mon.num_rmid = e->num_rmids;
> +
>  	for (int j = 0; j < e->num_events; j++)
>  		resctrl_enable_mon_event(e->evts[j].id, true,
>  					 e->evts[j].bin_bits, &e->evts[j]);
> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
> index 2238a5536f4b..f18cc5b38315 100644
> --- a/fs/resctrl/rdtgroup.c
> +++ b/fs/resctrl/rdtgroup.c
> @@ -1135,7 +1135,7 @@ static int rdt_num_rmids_show(struct kernfs_open_file *of,
>  {
>  	struct rdt_resource *r = rdt_kn_parent_priv(of->kn);
>  
> -	seq_printf(seq, "%d\n", r->mon.num_rmid);
> +	seq_printf(seq, "%u\n", r->mon.num_rmid);
>  
>  	return 0;
>  }

Reinette
