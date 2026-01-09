Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D3CA272803
	for <patches@lists.linux.dev>; Fri,  9 Jan 2026 16:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767975536; cv=fail; b=QXfRmeDXcXoJql0s+Ze+S2ZRNW77h7WgzjFuDBl3rDEnWoJ2ULCN/x1G6zn7513g5CCPkFEzy43K9ecgAdisPjH/NQ59IipTbiiH/ZzcFyv2dFMDcnd+paVjbs832BLdl/02ScHjWTAuypu2KNC74yghdJgLTnyEw3TGFGUK1X0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767975536; c=relaxed/simple;
	bh=HaKfVHP99hL3yUS0tRSDdbPKXnUym9p0XocpqTpdH+w=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kUxmbNWmbufxFIbvaXqqQ/j72snTBFVLK03qoSj/T/CyHnwVCzpdv47yXjIUN9DIsK/myEl6+XpWLfPrr2t2TpmAJtFmmYfAydRWMhm6ufvIZsZ4L2WOMAGAQRJOw7WUo4rW8HpnPRh4rs2VrNGKAkeR2FMEGJd9hvxfwzn+QIk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=O/vq2owC; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O/vq2owC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767975534; x=1799511534;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HaKfVHP99hL3yUS0tRSDdbPKXnUym9p0XocpqTpdH+w=;
  b=O/vq2owCAqaN70jD2GNKHttJi13G6UML1FQbcEgDLtOaCOhOI9Xjbaar
   PKckIVlEhdQHqPRFgx//wom/42fj26vpvEbX6/Zp4Ki+RgVsUUZ/AlEJk
   dMdDIkQpX4U68Fqt/H186Gqf8PDrYdF2g2X2jFth5sHlEML+VxR+P5nb2
   hNmj3FDlMDcNH6pP21CfKpeiKdm0ZE6ojz3LxjFfn/BTSzKMPyoUjhRBg
   Ls25O3/4qS5RpD2Adk3lpYQE21gSfUYvmmRpG5NkPqdSH6sJwXiK4qcIT
   lVDyy3LJ4QdKQoZKniACRSVi5q81fd4DS18IVj1hibKb0lKA94e2dxOCi
   Q==;
X-CSE-ConnectionGUID: II/EOHX1Qn6zZfCAgmD7zw==
X-CSE-MsgGUID: 6JSu6RD8TtWUAKwCZK9NSw==
X-IronPort-AV: E=McAfee;i="6800,10657,11666"; a="94831730"
X-IronPort-AV: E=Sophos;i="6.21,214,1763452800"; 
   d="scan'208";a="94831730"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2026 08:18:25 -0800
X-CSE-ConnectionGUID: UCgwXzmiRFWAQ9o0qQ/5KQ==
X-CSE-MsgGUID: BdKv4yosSqWNdg4dEvbIiw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,214,1763452800"; 
   d="scan'208";a="208031174"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2026 08:18:26 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 9 Jan 2026 08:18:24 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Fri, 9 Jan 2026 08:18:24 -0800
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.47) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 9 Jan 2026 08:18:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iIme7IUhRmAYcJGjtcZrmP+Ws9ti1HYZfvMIWsvzTsqYtoCA0eqnLg87kMOB1yVrgqiMZnYc0GC8rVJVJitInh/UDJlWwMmc2Cyt6Gdmha5FQZpTiBiKnUfvgnYf7mARm8TAwThmqBDkPaox9TNNU/zcVOGdbAk+33aOHchBlMCFuGS05FmdF5FVxbmG1aM7mRZCbNeO4ocEH5mq3mGvsEdK5z60enQC6g7Xo37pde1VLGutMeJsDn3MxrIinIolOjsrTx5mWECKYDJo9G7BmkxrX+WkSYCZarnxPI0BF/gt2DU9VbqplvBD0hCp7Fw7inK4o8jvZYoEa2qACOec4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JDQ/XURPZe/u0CrccTbcKoh6wOqTpB4GF+sweYIYGUY=;
 b=QCLURe8u3T32OBm7QqwQJaPexirgUfh+xWr5j+BUBvI7r1wRbx1ElZSG50v9zPbT4qsWqP+sf1RnRjtPmg9w8J/4vBA02wTA5dkII1WMjIupK1VRF5KXFN3NQ+/wtEkJWw5Cjad11dgyga6Hr/7Cvlm4tkwMF3HrbG+xTMN3OMsMuoGcTrAv8khkCmyUqdoLqPBm6sT2vmk+cI4B0tSYyiLPHI57jZERDAoBQIc+peEnSjQMa87eBGku1pmdpJ0scok8CghbWn5KOLjo90mi61tfgt98MXV4Kusq5F4jkFDezbzaR7CXYSSMW/SGcgLXjNOOrGYVmlK/FLkCF1Qhew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CH0PR11MB5251.namprd11.prod.outlook.com (2603:10b6:610:e2::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.5; Fri, 9 Jan
 2026 16:18:22 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9499.004; Fri, 9 Jan 2026
 16:18:20 +0000
Message-ID: <244c62e1-ee2d-4356-b00a-2c2cc3ac2ba4@intel.com>
Date: Fri, 9 Jan 2026 08:17:09 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 19/32] x86/resctrl: Find and enable usable telemetry
 events
To: Borislav Petkov <bp@alien8.de>, Tony Luck <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251217172121.12030-1-tony.luck@intel.com>
 <20251217172121.12030-20-tony.luck@intel.com>
 <20260109121616.GBaWDxkGvgJ6sd133q@fat_crate.local>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20260109121616.GBaWDxkGvgJ6sd133q@fat_crate.local>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0035.namprd03.prod.outlook.com
 (2603:10b6:303:8e::10) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CH0PR11MB5251:EE_
X-MS-Office365-Filtering-Correlation-Id: 498fa982-1ae5-4f2d-2a2a-08de4f9ab434
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?dWZiZ0pxWnJRNDZiTmpCVzNSZDBaQ2FJNXZVWlArajdleDNTNkgzTC9NZ2xm?=
 =?utf-8?B?WDd0WkE4K25jK0JIRzJnZ1JKU1RGNUtMNXBzb1M5UWo4RG9ha2UzOS85WERn?=
 =?utf-8?B?c1g1UlhNZnUzMExlSVhjMGdIMWVmSHZ6MjRpTGVqMkdjT0x3eGVYZUlJd1lk?=
 =?utf-8?B?Sm9adFVuWkpwem96SXVBWjQ5ODFnVkorNWJMYk9sa1Y1UTZQUFlqcjZTc0t1?=
 =?utf-8?B?cmZGbE01U3Q3RVp4b3Z1ZUE2N0Y0a21mVDBPeUw2WlRZcWlNUmN0RzAxZVpM?=
 =?utf-8?B?azQ0NktWMWhKa240Y0xWS3JEcDVsSXoxS3RXeVZPSjRhRkVORlFWOXdLK3Fy?=
 =?utf-8?B?OXlYa0NwWVF2TjlSYlVNWVRJL0JPYkhZdHR5dXZTNUdNbnd3a3JVZTliS1Aw?=
 =?utf-8?B?ZDNra3FqYmIxYlFKd0lrcFozRGZyQnhINE0vVVRpYVVMNG1COVdadVU1bXR1?=
 =?utf-8?B?ZGg2cVJoZ1hVd0FwM3RhOCtVMjZTRjZMTFNUOWxKREpxcFcyejRBTktBYm92?=
 =?utf-8?B?L2pScFNzTnh0VTUrSklxR2ltdTdNY2g2OTdIWHcyZm9CcXRZZmJKQ0lXamRQ?=
 =?utf-8?B?c1Z2ZFBsdTBtbFJjK1IwSllzZEs2b3d5bXJVd0M5ZEVIcUdEaFMxK3pBdU1H?=
 =?utf-8?B?SkdLZmhwR3hiZUhqTk1RSlBocWdTdG9VY2x1djVVRzlNQmxTNjhxY2tYNGxE?=
 =?utf-8?B?dlVWQW1pbnJiV2JwSnlOSnl3cmVXSTNmeXdSNzNNWS9taThoQ2duNzlDd1Ba?=
 =?utf-8?B?T2Q0VGoyVnhNNFlITldqTk1wR2lhd2NmS2U4MlJSbnkvbXF6bjdSU3E1TkE2?=
 =?utf-8?B?RDVoOVlYUUhCejh0Q3FLTHcxeXhDVmhDNFZJTjdsczBTdkUyM3ZYcWhlTjF2?=
 =?utf-8?B?RXR5QVJIRHRJNzF6eG5mQkhoQzE0UHVXS3NFeTlTRE5sb3JhRUZoS0oweEtV?=
 =?utf-8?B?VzlyUzlHNlVqOWNZdTB4VTlNVkx6eDljRmRyTmlaTGJWSzkzNWVETjAzenU2?=
 =?utf-8?B?L1c0b0I3SUgzUW1JV3d2Zy9jYjQraXBnd3dxb201aWs2bE5nU3UxanNTQWdG?=
 =?utf-8?B?WlJkTW1QaGhRSVhyMkNtcnlvTVRWVjVVc0hiaDBNNUlmdnRRZ3NWUG5tV01u?=
 =?utf-8?B?bHYrNk9TWjJaSlU1N2lvWGREN1owS01LUUtPc240VWxBR2taMmpNMm4xTmhn?=
 =?utf-8?B?d1d2Q1ZFSlBPSkd0ZEJWUkRPZTAwTFJFZm1VRjJycTdnanVncG4xelJmZXVw?=
 =?utf-8?B?VkU4d1J5M3FaYXV3alp2OE54UjFBaGFZTHRndUdRb1d2V0JuZjVSeE4wYmF5?=
 =?utf-8?B?OHFISWFZWGRReGtCR05wZTAxZEZ1cVNwcUNuVmplTnUwZnBlVTIxYjZRZkxU?=
 =?utf-8?B?anE4SFpGQXlIVWpWbFloTGtvYWo2Q1NpWkMway9nTTBETXkwTEJUemVlSWNy?=
 =?utf-8?B?TmtrRUQ2a0VHbEZzbnJxd1JaWFZ2ZDljb1phV3c2QlZ0UytXMGl2dHBGYXdu?=
 =?utf-8?B?eHNIa1ExSUxZMVhTSndQRTc2WWlQUjNMczhUdmRWd0N5bEdGWk5raTdIZU5I?=
 =?utf-8?B?bENnTDUrUTRKRjlFSndoWGsvaUZyVjVRY3RnVXZ0QU5IYkV6aXo4YUV2dXlj?=
 =?utf-8?B?NWZGQmZjQmxKRTRyQ1ROTHdKYWNpY3RHYW4wd2c3TjVHSWpqVkUxaVY4MCtK?=
 =?utf-8?B?SkltTFJ1RExFM2c1WEgwTHN2QVJyZzlPQ2JtTU83WTgvSTF2SjBGUVVLOHBK?=
 =?utf-8?B?cjh2eWVKa2ViNmxyckxlcDQ2S3hPc3NoYnhpcnV1aFlyaDM0S3ZZem1yYzA4?=
 =?utf-8?B?VEsvRnhOWnZDeE9mMDVoQVRSMHBiSnh3aVExeTNmMUtrQWxZWVZTZ2RmVHNB?=
 =?utf-8?B?K29YQnB6ZUtlYXpkQVRSY2tLajgzL1N3VzcxOGVQKzlJY2JSNlVobHd6L3lD?=
 =?utf-8?Q?uWn+a9u0dqo4nVMRW9zt987WUxLS89+t?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SEpYeVVXVkQvNmZ3YzFUT1Bybkc1bUQvdjJROWZ3U1doQ3FpN01kYjRnQXRl?=
 =?utf-8?B?UVJQVUZvQmswaHI2Y2ZubUhwYnE3VWZ0NTBUMTFzV09zNU1tUURXL2VFUURI?=
 =?utf-8?B?bWJwd3h2Um85NDE4WXRRYVR6YTZhRWlSdHlpVVZBOEdtSFJMMlBRc21sZll5?=
 =?utf-8?B?bHhZWEVIZjJlT2Y3bnJrM1c5NVZlZ0NQNW8vOVF5YXVVUFNNOFZrZVFKZkZH?=
 =?utf-8?B?SUJucnRhVmtzOWhnY2YyMWd6NXdsT3VDaHFlR2tra2pBditLek91aHlxKzFL?=
 =?utf-8?B?dktpTU5BNlJNOUtkZW8zM0V1cUxCWDdUQ0Fxb0hrV1NaZklxL3V2cVZLam43?=
 =?utf-8?B?STg3WVpmc1RzN2lmYnFpeVdwOHJ1MnhvejFBS0ZuUlBLWE5RczlsM29yVWFj?=
 =?utf-8?B?WUI0RTc3VDFZMVhnTlJLWmt4cFVTTE1tallpMTNBd0JMank3UGc4TXlSaUc3?=
 =?utf-8?B?Rm9PNkRiUnJucnJUQjBma0x5Vncvb2JyTzJ3S2FZS25lVGxGaldlOWdiQ05T?=
 =?utf-8?B?Wnl0bERFa252NWVJajJCQXBjKzh4NVZOZ2RKVXZtN2c3TkN3QTVnU2tRYnN4?=
 =?utf-8?B?QUpXbGkxdjF3dm1qZUFtdUFiNUdUdE5XdW8rUFNvQXg3Vzl3amY4RXJPMHN0?=
 =?utf-8?B?clN4TUxmcTBXRVRvVXBWVzFYMDZFdDhEMXY5U3RFdjNLa3BJVTJ5QU9nVXdV?=
 =?utf-8?B?QXFUalZvbHBvWFdOU0s3dDRVTVE3MjFvQWV2Q1Z3UE1maGU0T0FRckhyc3o3?=
 =?utf-8?B?YzF2dU9hWXh1NTdsZXAxYUNrS1BVWm9Xa1NaVE1ybG05VSszQmQ3SGJ0YVcz?=
 =?utf-8?B?cURBWVZkUmQwclFUYmliRjlBWkp3Z0hTSkdjckNMNG1XN2FNazZqSVlKZVVF?=
 =?utf-8?B?bGhIN1RrdnFBUUNzcFVZTktRWnNsbjBuOUZObTBhUG1zSFpNZGR0U2hvdFJh?=
 =?utf-8?B?dkMwR2x6cElvSVhzajdneEw1em9CRnRwdGFUQ3hPVlYvYlNBRHZqeXdlQ2N0?=
 =?utf-8?B?ek5UR3ROaEVtSExEWjdsQWpHWFdSWXlPNi9FZk9oaEszMHJkeFl5S1FGeHVw?=
 =?utf-8?B?S3VxSktkb0xCMldXb1kzdFNNZ29ZNFZTaXFrcEV5RkN1VEVvTDJvR0swZk1B?=
 =?utf-8?B?RE5VYU0yby9UTEhmZU11QmxLODNiVVQrQStkckVLeXN0bldXY2hKVUFtYnJp?=
 =?utf-8?B?dGRZT05IOE5SWDVrVlF0RzJqVVZySmd2YjYxQXAyNk95dzdYL2ZrMFhJTFBD?=
 =?utf-8?B?TEJoOXFhSytYUGo2VTVxZVhxOUV2VCtGYzBNZGNpdUxDMTMyei9iYlVZWkM2?=
 =?utf-8?B?cTAxMWJObmIvV0FkNXNxVmVsdXRFOTk3b1lqZnNRdW10c0VDMnYzOUM3RVdQ?=
 =?utf-8?B?QlMzcTJVRHcwRytWN0hSc2hzR1R2NWFmV3dJalA5cU5pdHl3Kzk2cjBKY3d1?=
 =?utf-8?B?bUVLUk54NXNzbEprZ21yL0dxNEN5NGhyQlp2alRtOVpJcys3YlVLblJXRVQ5?=
 =?utf-8?B?c2NrdS9sa2dxeWNjc0VDb0hSVnBGbkUrWENSbUtwNjhoaFpkQVA2elNSS2Jq?=
 =?utf-8?B?OERrWnArRGJHNDMwbzJ0c2JZclNTNzBydG1ta1JRZGV5UXZOVFpXV0NaT05O?=
 =?utf-8?B?YUZXOUY5dVZocnpiK3crRk9ENlRrand1cXZHREtMdUFna0ZkejM3djFVbmlR?=
 =?utf-8?B?TnUyb3pCd0t6YjluZHlFS0duMm1pY00vemY1cS9QdmpKUWJWYWJqcktGQXdx?=
 =?utf-8?B?N0JwYURucFFSZngvRU84NXBVNHZKK0Y4eUo1d2E0ZE9xNkhlRWJScWxIdjNa?=
 =?utf-8?B?K21ZZXRLVFV3TDhVT0NmcDk5ZkVPbkQ2M0FxNmc2YkhEZWJYUHR2R2VJY29C?=
 =?utf-8?B?bXZGaUVJZGQwYm51bjZLRjJhb3p5ak9xem81YjY5cVprUXB3MTBoSWpuRzJs?=
 =?utf-8?B?bDNXNTczNE5EUkdJKy9LbEE4K00vckorZVN4SXFZNkRzQmhXM0trRUt6dUhY?=
 =?utf-8?B?bG5PUk9DVnAwUys1b01UOTFaTC9YNUNJVFVzbVF1TkNIR1F4YUVsMmRJa3RZ?=
 =?utf-8?B?YStXR2NOL2xNUHNPbTVsd0g2bFZKM1YrS0RSNmFKWi95NUJyTDJuMEVGeFV5?=
 =?utf-8?B?NmNyRkFWY0oySFlLL3d6M2VFeWxQR0xRMzJBaUFrSU1QYVJTMUVNRitYMlFv?=
 =?utf-8?B?eDI3RTl5SEhJMmE0THpjT2taMXUwYThqOVZ6WkRFbXdNQUtYeFpwRGpJMnRt?=
 =?utf-8?B?dktNV0VUZnJyT3ZhdmNCRUcrTHI5TEhoelBVVUZ4ZEFJdmE0K09GVytweHpQ?=
 =?utf-8?B?SnYvYjhneWpZV0w0QlkwSzFQZEs1YWYrTnpaSE1ybGd1TGkzeXl0elZKQ01a?=
 =?utf-8?Q?ZjpizVjE4IKYDJY8=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 498fa982-1ae5-4f2d-2a2a-08de4f9ab434
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2026 16:18:20.3977
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RUAGqX1bV1ACRSToaey8Eh25KZhk2yf1h7L+kuIcp62fVfU/GBFCMgGNqc3fG2d9AVIk58JF8BcQygv14dzijeNP+DRyCWeEiAw6sXTtEg4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5251
X-OriginatorOrg: intel.com

Hi Boris,

On 1/9/26 4:16 AM, Borislav Petkov wrote:
> On Wed, Dec 17, 2025 at 09:21:06AM -0800, Tony Luck wrote:
>> -static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
>> +/*
>> + * Clear the address field of regions that did not pass the checks in
>> + * skip_telem_region() so they will not be used by intel_aet_read_event().
>> + * This is safe to do because intel_pmt_get_regions_by_feature() allocates
>> + * a new pmt_feature_group structure to return to each caller and only makes
>> + * use of the pmt_feature_group::kref field when intel_pmt_put_feature_group()
>> + * returns the structure.
>> + */
>> +static void mark_telem_region_unusable(struct telemetry_region *tr)
>>  {
>> +	tr->addr = NULL;
>> +}
> 
> We probably don't really need such a silly helper which is used only once and,
> AFAICT, doesn't grow any other functionality by the end of the patchset:
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> index 4074fd43830e..7d0bd7b070a7 100644
> --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> @@ -112,19 +112,6 @@ static struct event_group *known_event_groups[] = {
>  	     _peg < &known_event_groups[ARRAY_SIZE(known_event_groups)];	\
>  	     _peg++)
>  
> -/*
> - * Clear the address field of regions that did not pass the checks in
> - * skip_telem_region() so they will not be used by intel_aet_read_event().
> - * This is safe to do because intel_pmt_get_regions_by_feature() allocates
> - * a new pmt_feature_group structure to return to each caller and only makes
> - * use of the pmt_feature_group::kref field when intel_pmt_put_feature_group()
> - * returns the structure.
> - */
> -static void mark_telem_region_unusable(struct telemetry_region *tr)
> -{
> -	tr->addr = NULL;
> -}
> -
>  static bool skip_telem_region(struct telemetry_region *tr, struct event_group *e)
>  {
>  	if (tr->guid != e->guid)
> @@ -149,7 +136,16 @@ static bool group_has_usable_regions(struct event_group *e, struct pmt_feature_g
>  
>  	for (int i = 0; i < p->count; i++) {
>  		if (skip_telem_region(&p->regions[i], e)) {
> -			mark_telem_region_unusable(&p->regions[i]);
> +			/*
> +			 * Clear the address field of regions that did not pass the checks in
> +			 * skip_telem_region() so they will not be used by intel_aet_read_event().
> +			 * This is safe to do because intel_pmt_get_regions_by_feature() allocates
> +			 * a new pmt_feature_group structure to return to each caller and only makes
> +			 * use of the pmt_feature_group::kref field when intel_pmt_put_feature_group()
> +			 * returns the structure.
> +			 */
> +			p->regions[i].addr = NULL;
> +
>  			continue;
>  		}
>  		usable_regions = true;
> 
> 

Looks good to me. Thank you very much.

Reinette

