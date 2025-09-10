Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BB9332ED52
	for <patches@lists.linux.dev>; Wed, 10 Sep 2025 17:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757527176; cv=fail; b=SeVdlR4eUKFZLVk4FhbIPclE078jdQQengZrYTusohtjKkUrbmNXs68ATkSRFc2Tqv5j2ASqP9WnVseTJ6iJA0LLv1A5aynuB4qH2d3o62yGZaeJgHm/dOAbmjTYBOl/2KU/LlkV4QCGosMg3Pwc0l/uA0+nEO/ZwUXeWnsJYLA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757527176; c=relaxed/simple;
	bh=+ud/i4Q7KhAoW7P2RsFonVAqtN04el2nXXIWaUPhXrE=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=e+/ZrtOSY+6Vj8TOemDbx57hnoT2mjoqNl3k/HfJ2jZj33OYsPsJuX+L8U+lDLHWReHs/OHzBdKVTsBrgUbv4cfB2nLv00H7FhEn9VkWVIEgzqGkAUbZqARgl4O84CczMZmx4Ej1tV9zfcPV75zgzLcBduimUv/1t85AgBgzGUs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CtVGmxh5; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CtVGmxh5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757527175; x=1789063175;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+ud/i4Q7KhAoW7P2RsFonVAqtN04el2nXXIWaUPhXrE=;
  b=CtVGmxh5mhu0cgAgaB+JpRUc3Nuqr2jzYA5dzxX/aM0llvwshPnZio0N
   Tta4GcEK6uqy0ZYhG1rqZ9j0ZwF+IOwdd+OpScdfl050tDrUDtSNOjk2W
   29sKL0NJ+0sgBJ1+hOSrj9xHnVSwupffcCU3kKV6fayhyInh/kLvUhfJD
   XchdYxTguHt/PtLEpvpaRumy2T9QlCgoGosoAsgn5Zfpp5ZtSGV9a+o1i
   XNw89pdJAKMScxjfOpjAWQUPewr40RW7ccI5JHiGt74GbhFmnLSaHtUfx
   GJhJFlz+TcEwwGqan1+tGfqMlHmPJhV4a8SsW17E+YbG7xgE46rMf3VpB
   w==;
X-CSE-ConnectionGUID: rkFQ2VTRTQK2j+uVmEBusw==
X-CSE-MsgGUID: l3u1dIL3RE61IoX0j3e/vA==
X-IronPort-AV: E=McAfee;i="6800,10657,11549"; a="70102985"
X-IronPort-AV: E=Sophos;i="6.18,255,1751266800"; 
   d="scan'208";a="70102985"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2025 10:59:34 -0700
X-CSE-ConnectionGUID: InHUl1blREKTIJD1UMGnLw==
X-CSE-MsgGUID: R6qN3Re/QT6QC4u8SfkWwg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,255,1751266800"; 
   d="scan'208";a="174272614"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2025 10:59:34 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 10 Sep 2025 10:59:33 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 10 Sep 2025 10:59:33 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (40.107.100.40)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 10 Sep 2025 10:59:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Hx9sA18OA6cVCxGJRRy5Px1NgsjMmKQcOu9tmmLJK0ccN/IOTEiEBeMs7VkhYJrAWsLrGt5kNhwUVURLGgnb5vCKmv+Hka45/6NUWULrY1AOzwqacLrsu7XtbyeGFkmVgVmxNOQXPfrqFRT7zOH3PAb/9h3kuc6zHWkn6xwFxFmhrS9srfK1d6E5doENkSf9oCsRFi8rzT9pix2Wf2WXA8vgJzRkfpilsuyfDI8d3RjONZKqAMJvLmMzhiQjDQl4vCdAwuXP1D5zk0cdLjmsWg1ooF5Urq/gOJ1lP+1zuyB6yUsUNGnUQ4dSZy3E1o67uaDW+gjyLpSkglrvUytkag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oloHzox67xN5L83zkuwCjL34xS/mUz0wSOSPXnGBxPY=;
 b=pQs91h8VgTU4RUJJp+9nBFoicg/5RJYEU3n2404BOwmiE56AsJ/eLztGHuvjjNOzBsjdLj/QShkX4nughSJIxUa+zZtJz99bs6WelC+4nbyvCOB6+PEy5kq4qDQ5gCskvG/XfMefNBCfkB75p8qLExTmlQGvruHHRTp3kN1jbEtrMNj/1VBM+V8aboFuj2lbTJ/QmAVo49q++4eSVxABXSZbkBBe6qFAD/GxfmI8970SXvymu46skJjH9sacrDoDaZYtlzqLwzhRHN7fOLbnDRr+CAnBTwp9xMLGQHmCK3jh2g6RTHYPyCKAzG5378ZlFZmwWtX4HaU/qjxQe68z/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ0PR11MB5937.namprd11.prod.outlook.com (2603:10b6:a03:42c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Wed, 10 Sep
 2025 17:59:30 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9094.021; Wed, 10 Sep 2025
 17:59:28 +0000
Message-ID: <43537b06-c80f-4705-85e0-37f70a0f4e6d@intel.com>
Date: Wed, 10 Sep 2025 10:59:26 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 31/31] x86,fs/resctrl: Update Documentation for package
 events
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250829193346.31565-1-tony.luck@intel.com>
 <20250829193346.31565-32-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250829193346.31565-32-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0269.namprd03.prod.outlook.com
 (2603:10b6:303:b4::34) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ0PR11MB5937:EE_
X-MS-Office365-Filtering-Correlation-Id: 1fadde63-425f-48f1-b412-08ddf093c94e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?VDRyQ0E4Rm0zR0RqSHROSlE0eUJwUURYMWR0Y2hDb1RkaXQ5ZXIxQUMyZHlh?=
 =?utf-8?B?T0czRE5tTUJqQ3pGVjI1UXB3a2VqRjJHc01kMnZTOE81Mzcyd0d3aXJ0N1hF?=
 =?utf-8?B?bUxrSVVOOU1UQXV5bUk4QWVURHZtUTFSblRyS1Jpd295bndLSllORXJpZ2gy?=
 =?utf-8?B?elg1Sjg1aHpmQUp5bzlvSG9QZkpGc0RYTFUrWC9iN2tySnRDUDN0U1pUbkRh?=
 =?utf-8?B?dUIzNFR5MC8yWkg4VVVzL1ZiYWlzU0NSN2ZBOVlZSHJnOElIRVVGS0E3ZlhK?=
 =?utf-8?B?UkdDN2ovdzlpWERBVlpvMEZzUUhyTlpaMER2VmRHYldMUVZvMjVvUDNYUGYw?=
 =?utf-8?B?dGdhanRWbGFaa2MxdHJxazN3cjJyQlQ4N0RaMS9QcHREWVpiVEtaQnR0Q3ds?=
 =?utf-8?B?SG1zMTZQREtVMGhUL1k2dXhyYUkwbEE4YjVORk8wUENPdHhvWDFHQW56RjRi?=
 =?utf-8?B?cFZ2NVlnazVldlZLQVVpWlZ6WFRtZVVza1owbTFHOTM3S1VZZEdiSzFLRjF1?=
 =?utf-8?B?N1ZhdGxzYXBhMjg2VDhpOEZkTXhnSWFIUUNjdHlrOWYvd3IwWENXdUtaOWxJ?=
 =?utf-8?B?NTlEYjNEN2dkZmtGWFNFL25PNVZ4SEg3dzBlODFSMHI1RnlFaFFhZ3NXdGx4?=
 =?utf-8?B?dmcxWkNmN1g2S2MweDVLYURlSlREcUovQ3RncVhESjNkdXFkVkppZ1EyMFRV?=
 =?utf-8?B?dzd4QmR6U1U0dm1TZDQwUWR2RWFIT0JQWU5Ua0xyVHlnQUQzRGJoS0s4MVRL?=
 =?utf-8?B?WHZtb0VuUU1PdnJOTGNPNDNHUWFZSWxvRjdjZlBaOFZHU3VOQ3Bna2h4RHN4?=
 =?utf-8?B?RUY3aS93L3hKb210MWdOWmNMUUx6c3lXeU94QmUxbFE5bHNlR3JQMGFtbnZi?=
 =?utf-8?B?VFAwVTlZdCtaU2pTN3UrSGxhQlpMVURUWGcxTnhxODE3QkE5QVk0cGRSdlBu?=
 =?utf-8?B?VDVmNStIaDRuek9kdGh6a2pWbWhacFlodm1mcGdtT21BZ21uOGV3WEFsUnQw?=
 =?utf-8?B?Y1QvRFRJa080WjROMm5ydHFnSDA5TzYraVJYMXJEekg0QVFSeXgxRHZ4QWsw?=
 =?utf-8?B?cEdRUGh4UHV0OFBYMUVqcDIrZGQ4M05nRzdFNFhzT1gvRjVvbzN5RXBvWjc2?=
 =?utf-8?B?MlJEYTVZczZkZlRyaFVQelg4ckVMSEN6VDEvZk5tc2IrM2hMYUxQL0pPV3Ar?=
 =?utf-8?B?NTBXb2Q4YWNyaUVrV2RhMHBiakdMRTIybE9qTjFKNVhYV0U5b2t0ZTNSMDY0?=
 =?utf-8?B?Tm1oUXJ1eW1UQVppSnJvUC9OTWdCYkp3UWNYYTBick1EaU9OT1BoaWdpdElL?=
 =?utf-8?B?ME5nMDh3TDFXbzhna2FlK1M2akZ2cUM0T0hoN2NYQWJ0Q3ZLK0JJUEZZQmFv?=
 =?utf-8?B?Tzd1Zk1DUW9IRDNoVFVRK0Myd01CSlBBdVJqQ3BvK0ticVZ3MmdvZUF1WS9y?=
 =?utf-8?B?dncwTFpqUnE5VU8rZUt0bGNxK2d5bTNwVmJDNXJ0S0pVVVVlN25oMWxTdnFv?=
 =?utf-8?B?eThKTlJMUUlIeTN2N295N3p2S2dYdUtYYVJHbTFvbGRqWFBwMFowWUp3SFpk?=
 =?utf-8?B?eG1zSWd1ZDZodGY4T01jNVJ0MXdXUSttWndlNTVGQTVkL2kwR1dsTFQrbC91?=
 =?utf-8?B?cUlONDNqdTZVR0Z6YnRxbmR6d0RtMkJGZDVsZEJRbjdxZlhPc2kwR0JIalJh?=
 =?utf-8?B?ZDZmN1R3WllMeEJWYXVobGtoV3g0VmlTd2lUend2QjBXejBvbTNMaVNCUUpm?=
 =?utf-8?B?UkRmeHhQNzg5dEFHeFBuR3ZRZEVSbm1TRzhyTDc0WHZueU5pNkUzc2lYdjQv?=
 =?utf-8?B?YVdFVTZpV1h5Y2hLczdoeFhsZEc1T2RGd05LZ2cyTGVlOG1ZTmQwa1NOSEdZ?=
 =?utf-8?B?NnBlWi9La3IrekRCS2dCaWxmMlJnSDdFNk1rTHgrUG5HQm91eWFQa1JjcHBR?=
 =?utf-8?Q?KcbyKbL/r4U=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aDUwMGk3dmFLWVpzTWZHQW1NWG9WMzlENm9CVk5HMEIxMFFBbVozZTBkNlli?=
 =?utf-8?B?YXlYVnREMmtZQTk0eE5iTnJZcFdBQjJaQ3B4MHBRWDFSeVlRRm51S2lCUXky?=
 =?utf-8?B?d2hFVWcwNW8xcnQrK1dIVnl0dGw4RCtpTlpMM1psM25XaHdieHZCK1MvaE9u?=
 =?utf-8?B?RTdSWTZSRndUT2hKcDlVL0E3MUYxZ1hleXc3bzRQVWd2bDB6bnBKRXR3cXNy?=
 =?utf-8?B?WlNacm9wNzNYMmc1b2VGVGJsVldFTTRpR2hXTDhtRUFURWxsR21zdGJqb0h0?=
 =?utf-8?B?bVg1dUFEUHpuWUpiMnhpRmNpNVNLYk1aelVUajNKNy92Ujc4WW9CRGR2aXBO?=
 =?utf-8?B?Z0psOWdhVU1BTDlEVzl2UFQ1MlJMTlB6WFBrMkc2cTNXdGc0V0tnZmRhQm1L?=
 =?utf-8?B?Sk4xMFE3bUQxeGFxY3ByUUFOU1F5ZGVSMDhFUjRuQzN5VjV6Y2ozWFFicFpV?=
 =?utf-8?B?ZEEraDBmSkF4NjUxdTY5RGhlQVZiekZKQUREMVN4alhwM3E3eXVPbTVEK0U3?=
 =?utf-8?B?Um5sZ2haNWZlOFY2ZUVaSExoUHhHSU51NStzdzUyNStOMExvaEVHZUdUVFBG?=
 =?utf-8?B?TUQyMUYwTHJtNE9qaHgzU2N6TjRaeUx2Z1ZOeDZWODloMkRmaVJKS24xUVB5?=
 =?utf-8?B?ZlNGUzNGMDhTcUQxUWQ2WEZvVjA0dFI4dGhjazhuSVNOc2lYZCtsSG5tM2RS?=
 =?utf-8?B?cjF1eWJtYmhkMlNnUkdaa0xyVjhvUjl5TXBOTC9EclF1b2J0ZHFQMmVnaGtG?=
 =?utf-8?B?alh4eS94SFNtdGd6b2IxZkh6alZLc3lrWDNJbTd1OTJ6Rks5QTdSc2tvaWZy?=
 =?utf-8?B?RDlnMnNpNlhzSHQ5SEhIZloyVjY2d05IVDkwYjVZOUhwUDJsMWlnWUNrNVZN?=
 =?utf-8?B?anlYWU1xTGNqUHdYVWFDblZKYzlSZ2lpSHIvRDJLcHRDZXhsRjJGaDlXQ3Yw?=
 =?utf-8?B?WTA4bnBlTWQrNXZXbUE0bDNTWHdLazlwWDFxUUlVbmxkQUxxRTlmOC9DOTY4?=
 =?utf-8?B?cGJJeFJYVWk1QWFaOUJQWGRwdTVHdEZLM2V0aWhmdTVEdktTbXVSVmpHdHUw?=
 =?utf-8?B?R295K0V0bUowdE96Q2VTMDQyd1dBSy83R2grTWsxMnZtTkwyd2xoa3Ixa2xa?=
 =?utf-8?B?TXBqZjR1NmhBRXhydnhOSVk5eExlRnNjTmg5cUJBRlY0ZVkwTVhIa3RMbXk4?=
 =?utf-8?B?WEd3S1lCWStRNm9SakpkOStMK1crOHdrYzg1dVFLb0huem0wSEEvK2loc0tq?=
 =?utf-8?B?ZEhtdFZlUDdUaHRzaC9ITHJtQ053TmdkVUE0V1VtaDQ2aFQ5MFArVUlJVTh5?=
 =?utf-8?B?UytMcU9FUXdGbmtJdTMxRkRGOU42bHVzcFZZdTRVWjVrelh3N2h1MFZOR1pz?=
 =?utf-8?B?MnhHN2lha1QyRU9HTlo1WXdWcGVXS1NKUEFTbU91a3JUNDBXRktBR3NjQXRD?=
 =?utf-8?B?VEd2WUNFUDBjZGh2TkQ4cGFabHIxYXBEWkZZRER3aTMvZUlsNHRrOHZnWndy?=
 =?utf-8?B?ZTBHREl5MHN6QUJqUlZoNEhKTTM0WDVUanFobUJ0a0NsYUFaWlNiTXVXYlcv?=
 =?utf-8?B?RVFCemRYa0NUNzMyNktHQ1lTZkM4K0daenVnUDg1OWRzdkxnVjVYVHZGTVlJ?=
 =?utf-8?B?RVM2cFgwd0NmSmdkTzFSR0YvSWp1VVd4aGRRWFd5WllLVUI0NWVNYlV3ZWMy?=
 =?utf-8?B?T04zOHpHR3lMeE9mMzJSazl5dU1NdlAwZko0azJsNGVTKzBmVzBRb2JPZVhk?=
 =?utf-8?B?U2xWSGhmNEVKZ3k1ZEtzRmRMQkJSc092L0t1N1JjbVExcFAwTGoxeU9FWStD?=
 =?utf-8?B?QXBaN3g2SlZUblJSNUtpRzBEQUEvUm1KNXprMnFYUkhPWC9kOGZpdTNUbGFL?=
 =?utf-8?B?emh5L2M2dHAwMU1JdkFKL0VER0VBTS9lUWJ2ZzdESFE3d1hjbkhoSk5PbHFZ?=
 =?utf-8?B?bVJnaHB4akkvMVlFamFqRmZNS0VlN3hXd1VOUzRUZ2lQV0Y5NkZwaE52Z1lp?=
 =?utf-8?B?VkxxUmV3bjFpSXVURmhtTUZlVXgydkNaSXZBaWhxZnFXdjRIb0JHZ0V5V1h1?=
 =?utf-8?B?S3kzWTdhNVFGZTdoa2s2QUhTNUVTQU84WmRBK3dsdlFDRDVVZ0c1SkhQWkRW?=
 =?utf-8?B?RkRla1JBY1ZOb1JpZkdJelMyTkx5THhlWW12bDZBdzZHZHdBbGQ0T2VPNkQ1?=
 =?utf-8?B?bVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fadde63-425f-48f1-b412-08ddf093c94e
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2025 17:59:28.6349
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PsWy1Ca1OKbCmRqGj+mSbMqbuFquMOCrYZCxvP79MXY0+g8bMJswzY9YiZF3c6gUAKttjTPxSfxaEfC6cbJ4zH7n3T4Uftb2kMnuKBjVcwU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5937
X-OriginatorOrg: intel.com

Hi Tony,

On 8/29/25 12:33 PM, Tony Luck wrote:
> Update resctrl filesystem documentation with the details about the
> resctrl files that support telemetry events.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  Documentation/filesystems/resctrl.rst | 99 +++++++++++++++++++++++----
>  1 file changed, 86 insertions(+), 13 deletions(-)
> 
> diff --git a/Documentation/filesystems/resctrl.rst b/Documentation/filesystems/resctrl.rst
> index c7949dd44f2f..7ee2832a3aa6 100644
> --- a/Documentation/filesystems/resctrl.rst
> +++ b/Documentation/filesystems/resctrl.rst
> @@ -167,13 +167,12 @@ with respect to allocation:
>  			bandwidth percentages are directly applied to
>  			the threads running on the core
>  
> -If RDT monitoring is available there will be an "L3_MON" directory
> +If L3 monitoring is available there will be an "L3_MON" directory
>  with the following files:
>  
>  "num_rmids":
> -		The number of RMIDs available. This is the
> -		upper bound for how many "CTRL_MON" + "MON"
> -		groups can be created.
> +		The number of RMIDs supported by hardware for
> +		L3 monitoring events.
>  
>  "mon_features":
>  		Lists the monitoring events if
> @@ -261,6 +260,19 @@ with the following files:
>  		bytes) at which a previously used LLC_occupancy
>  		counter can be considered for re-use.
>  
> +If telemetry monitoring is available there will be an "PERF_PKG_MON" directory
> +with the following files:
> +
> +"num_rmids":
> +		The number of RMIDs supported by hardware for
> +		telemetry monitoring events.
> +
> +"mon_features":
> +		Lists the telemetry monitoring events that are enabled on this system.
> +
> +The upper bound for how many "CTRL_MON" + "MON" can be created
> +is the smaller of the "num_rmids" values.

To be specific this can be "smaller of the L3_MON and PERF_PKG_MON
"num_rmids" values."

> +
>  Finally, in the top level of the "info" directory there is a file
>  named "last_cmd_status". This is reset with every "command" issued
>  via the file system (making new directories or writing to any of the
> @@ -366,15 +378,38 @@ When control is enabled all CTRL_MON groups will also contain:
>  When monitoring is enabled all MON groups will also contain:
>  
>  "mon_data":
> -	This contains a set of files organized by L3 domain and by
> -	RDT event. E.g. on a system with two L3 domains there will
> -	be subdirectories "mon_L3_00" and "mon_L3_01".	Each of these
> -	directories have one file per event (e.g. "llc_occupancy",
> -	"mbm_total_bytes", and "mbm_local_bytes"). In a MON group these
> -	files provide a read out of the current value of the event for
> -	all tasks in the group. In CTRL_MON groups these files provide
> -	the sum for all tasks in the CTRL_MON group and all tasks in
> -	MON groups. Please see example section for more details on usage.
> +	This contains a set of directories, one for each instance
> +	of an L3 cache, another for each processor package. The L3 cache

... so two sets of directories? I am not able to parse.

> +	directories are named "mon_L3_00", "mon_L3_01" etc. The
> +	package directories "mon_PERF_PKG_00", "mon_PERF_PKG_01" etc.
> +
> +	Within each directory there is one file per event. For
> +	example the L3 directories may contain "llc_occupancy", "mbm_total_bytes",
> +	and "mbm_local_bytes". The PERF_PKG directories may contain "core_energy",
> +	"activity", etc.

It can help to append information how user can exactly know which files can be expected
(by looking at mon_features file).

> +
> +	"core energy" reports a floating point number for the energy (in Joules)
> +	consumed by cores (registers, arithmetic units, TLB and L1/L2 caches)
> +	during execution of instructions summed across all logical CPUs on a
> +	package for the current RMID.
> +
> +	"activity" also reports a floating point value (in Farads).
> +	This provides an estimate of work done independent of the
> +	frequency that the CPUs used for execution.
> +
> +	Note that these two counters only measure energy/activity
> +	in the "core" of the CPU (arithmetic units, TLB, L1 and L2
> +	caches, etc.). They do not include L3 cache, memory, I/O
> +	devices etc.
> +
> +	All other events report decimal integer values.
> +
> +	In a MON group these files provide a read out of the current
> +	value of the event for all tasks in the group. In CTRL_MON groups
> +	these files provide the sum for all tasks in the CTRL_MON group
> +	and all tasks in MON groups. Please see example section for more
> +	details on usage.
> +
>  	On systems with Sub-NUMA Cluster (SNC) enabled there are extra
>  	directories for each node (located within the "mon_L3_XX" directory
>  	for the L3 cache they occupy). These are named "mon_sub_L3_YY"
> @@ -1300,6 +1335,44 @@ Example with C::
>      resctrl_release_lock(fd);
>    }
>  
> +Debugfs
> +=======
> +In addition to the use of debugfs for tracing of pseudo-locking
> +performance, architecture code may create debugfs directories
> +associated with monitoring features for a specific resource.
> +
> +The full pathname for these is in the form:
> +
> +    /sys/kernel/debug/resctrl/info/{resource_name}_MON/{arch}/
> +
> +The presence, names, and format of these files will vary

Same comment as in v8.

> +between architectures even if the same resource is present.
> +
> +PERF_PKG_MON/x86_64
> +-------------------
> +Three files are present per telemetry aggregator instance
> +that show when and how often the hardware has failed to

Sounds like all three files are related to failures, but I do
not believe they are.

> +collect and accumulate data from the CPUs. The prefix of
> +each file name describes the type ("energy" or "perf") which
> +processor package it belongs to, and the instance number of
> +the aggregator. For example: "energy_pkg1_agg2".

The "instance number" is assigned/enumerated by INTEL_PMT_TELEMETRY.
Does this have consistent and clear meaning to user space? 

Reinette

