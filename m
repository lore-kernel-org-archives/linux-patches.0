Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CE7A56E057
	for <patches@lists.linux.dev>; Tue,  8 Sep 2026 16:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788884917; cv=fail; b=M9kx8zIdB5tVdixOectltlqe3D0kn70ZUw4hrJe6f3ndkE+Gf6w3qcoZQml9CsNdHMbXR0zsL3VKym5Ax47clA6FLrUDu1dfug/Tww0XX7IX+K0By8JCfkNLDzwhUgBSai00OxdguQ914K0xZd5nbBTl8HwIGZXJOJiCO7ZHBIg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788884917; c=relaxed/simple;
	bh=h/11Cm3/dmRbDeoHlHvK/EAhLJ6NusMDxLTtUVPhNbg=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=AuRmAZqggs3+z6TrjTNElltmQCb8L4oJA6dffJtPBB5IY3hdLxEzlQHIiqN6I8hFJfQklXfQgPRszoIvBZSf+pu879g6l5esU0tAf6fDr/TMF4K++Pi6H+SuJibCHmQhg5gkNU8YILGEgpdGKKKBxrTmb+LxEiiuhSNwdDmLcMk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lEiN2oT1; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lEiN2oT1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788884915; x=1820420915;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=h/11Cm3/dmRbDeoHlHvK/EAhLJ6NusMDxLTtUVPhNbg=;
  b=lEiN2oT1+PYaEHe1L8tn7Q1dlAGV0vINJlUjLfObmnWdjDAdjnMIRlNh
   z4yvGE6eavf5IEoh2xuq+fzgWaexM6zKlFwy8zb/6KjEZYpwxK1fj3AKx
   Tw8SiuaFfftWu/UMBggj8ylmvCEwH7zvdOBw8aX9inGymhSHEMCGlOkMg
   G2gLJFBKnFBa0RylkJI5++pyHllWIedsW+t5WCrakV0WYXueRPTe3u3oH
   foIRjAKkPiVqiZiR48uovqIsCjbkv9as+q4/icONxOUmi+1P7bzQmLpY8
   s7dXWxSsQSdP7r6wNlXzM4oa4w6wRU+i2m8Ceqya4O/votvP1iqu4vplX
   g==;
X-CSE-ConnectionGUID: e6NQKp8eRjaxvMFmVek0Aw==
X-CSE-MsgGUID: 4V8+7fw6QDyeTZggFa55Dg==
X-IronPort-AV: E=McAfee;i="6800,10657,11900"; a="100648415"
X-IronPort-AV: E=Sophos;i="6.25,269,1779174000"; 
   d="scan'208";a="100648415"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2026 09:28:34 -0700
X-CSE-ConnectionGUID: 0I3bK90CTrOF/QBacNbA1Q==
X-CSE-MsgGUID: xEZFFTXsSP2gJjp7swOjIA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,269,1779174000"; 
   d="scan'208";a="309311383"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2026 09:28:33 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Tue, 8 Sep 2026 09:28:33 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Tue, 8 Sep 2026 09:28:33 -0700
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.45) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Tue, 8 Sep 2026 09:28:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wwT0EP3Glv7AY4SlpDt0+Rpx9mdG4lIyeAeym9d37I9fNapJY4XVbtYyxgNT+fwi7k0Ayv5ds32fZzrXdfViW7dgHsPkr9clY8F5IIC/gucd8CARmgNn2YEhCMccESSxazL58FvhQI5PUoJBPPkYwUlXrYrjATNV5RDMpxe/LVpHY5vaeYBk620nzwrI/G5DcK4wKJUSNvHmrVKIIsOgCvMOMNNLsewy8Duapn6yCHEUNea0WhdIJlJzoi8xvGvzEpn8Z+NZimp+8vGI8QH4hhYoWrljT9b0DAf+FuaACJVutRVOHzuag26jtE2776oBrIvzcTCEpIIjq/dHnEG+DQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VKCukgz/AjnetOOhp2hmXQx53G4362SUMdnnPCT8vyY=;
 b=CnFkE/KSMVcLY83EEWYg1qSDjALNhm4wtLFu26WTrrZlzRyIVoBw+a3r+MknzuR/RolKQUWwQXoKPYDcZ39bffMq+xWVRvbLRQwfT6C7Nd/sJOyvjdwyp8Lo5jjelxXSSgUsOfyO5Fw4rUCnLZ11g7XqEivZp0Mm2HgqWrLfmecgMvyJIuhkXtCzNcRQKKtNOCj6bWrIZ8b/TxOfChMn+F+ug3SSDdk4SPlSMIA4vnClzveasd8ofJnNC99/MJ7HCfzYEAt1JKYGc6D9Zl9sRj3Sy4OHupdlJD//PrkKi5jT/IEcpheTa4grOiYLo+y4lusd0BY/SSRqz8lM7gHV4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by MN0PR11MB6112.namprd11.prod.outlook.com (2603:10b6:208:3cc::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.7; Tue, 8 Sep 2026
 16:28:28 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0406.005; Tue, 8 Sep 2026
 16:28:28 +0000
Message-ID: <bee83a8b-3bc1-4eda-bc02-f5c5f226277f@intel.com>
Date: Tue, 8 Sep 2026 09:28:25 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/5] fs/resctrl: Drop unnecessary parameter from
 resctrl_io_alloc_parse_line()
To: Ben Horgan <ben.horgan@arm.com>, <tony.luck@intel.com>,
	<james.morse@arm.com>, <Dave.Martin@arm.com>, <babu.moger@amd.com>,
	<bp@alien8.de>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>
CC: <x86@kernel.org>, <hpa@zytor.com>, <fustini@kernel.org>,
	<fenghuay@nvidia.com>, <peternewman@google.com>, <yu.c.chen@intel.com>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <cover.1788452481.git.reinette.chatre@intel.com>
 <4d050a1f7dc0b22bd8c4e6db1c2f2781e2bf929f.1788452481.git.reinette.chatre@intel.com>
 <790b4d24-a9bf-4226-b929-1c4611cd8540@arm.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <790b4d24-a9bf-4226-b929-1c4611cd8540@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0072.namprd03.prod.outlook.com
 (2603:10b6:303:b6::17) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|MN0PR11MB6112:EE_
X-MS-Office365-Filtering-Correlation-Id: 2fe54af9-8a35-4e0d-b540-08df0dc636a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|23010399003|7416014|1800799024|18002099003|22082099003|3023799007|56012099006|4143699003|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info: QmeujfFQTCy+QKd4h7k3+HlhFVux3Rqogmxqdd1uDvoGa472KwkAXNAoeSyBuSh/sGMaDg7LJ/Xuglz4aP8HCaZg0lcQD5/n0vwcqj/ToNUKVUk2KduSiMqVrHptn7o8/PQQ8F4ebnmcxIB9kyNFt4wvkLJJGzmrG21aAmnbYvsS55sd2ztfT4phcKcDkAISg+1xIFY2sSjgyDwRGilNF840NwR4+tuwSlsspDu9uQneb/s2n8vE2YePwbKtNOTnNk9ZmN/P8BCVADf4EA7p0doutjiLH5Jn5jIfNv4zmBCW4SIYWCMwDCWF64yklGKvqIvMvxJ7dARpmce6wI37Kw+OL59ylxLGlC3tEjVGHzsNc9XhUztZIEL7m7QLPQmt7hMNdtO1/ZUnZFH5Tjm/NCg8pIbxxYnpxgiVvgyIco7Vgr18zYUd0s1jv5MJUw22kqzJVvQeMNZelR2lhJiZnFksvVK90zsypWBy9WGqoKPQofdAaoNS+cTlcqE9fkM7S/ZoJyQeMIllaV763hHAtycusxUgkLFoD0rkotdnLOsnj2O7k9lq3jlacRG/I1b3TUeMMvV9BSq/Gcd1lITSgWeF6djZ4M4lSXeajjeuQRH86ll1KUGXgm8FnTMTw/h6YeUFMNNYdgDIgOd0eaPVFOSRG3vQcOAII/NiOThgM7U=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(23010399003)(7416014)(1800799024)(18002099003)(22082099003)(3023799007)(56012099006)(4143699003)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?akRicmJDRnIvWmhXZ1Foa1BzL3dsRTJJYWF4TDRwNWxwbjJHUDZzK3hpTGNN?=
 =?utf-8?B?b1J0dkpRaUFPNTRuMW5aaXpBMUFTTWUrYlh2c01zMUZ0alNwU1lCemRVYzUx?=
 =?utf-8?B?Z2owdDVxRU05UFdlRnk0QXZJUGJrZnBJZXRHQXlPNmVhamRiRmpuOW5DYTlC?=
 =?utf-8?B?bDJUV2piZENDTUUvaDUwVVhjZFNGcm9WRGRGb2FxdVBzcHZpVkFmaUEwN2w1?=
 =?utf-8?B?NWxzOHRzZ1NEeElWWVJlOVhyOHNoRU9Zc2VCQTFVVERqb0ZXeGpFcTBWY2hH?=
 =?utf-8?B?QXllR0ZYcW8rM3BlYW44Slh1ZDlhT3N4ZDdrN2sxZEF2ZVNCVWIwQlhDM1lx?=
 =?utf-8?B?T0gzeW05L1NOWXBJc0Uxdy93ZVNWOEJmUWZTMTVvVUQrQ0lUaDcyUnVpUW53?=
 =?utf-8?B?bHV5UTJQSXU4cjRLSDV0OHNnL3FKWk5WVGNJZkNGS0NlQWVxQ3o1VVJqTXJK?=
 =?utf-8?B?VG54ZzNtTzY2UExZZTYrdmR1NjJIUzdZdFlQakVMMTJpaTc4L1hEb3hUQUxZ?=
 =?utf-8?B?WDJhNzJjM1U2NUpDSGI3WU1Gb1FSRW5lcDFSSzFuNUl2THdZVStubE1mYUlu?=
 =?utf-8?B?aHZIelBtbmwyMk5WUGN5bW00V0M3cTl6dHFhZmZndEFtcmpVQ3c4TzczNmR1?=
 =?utf-8?B?K3IxdGtkcElKbWhnemJlMGNkdHdhZXZSRnRnWGtlR3BPdEdFU3BQaThLWUR6?=
 =?utf-8?B?WTJtV1lzdFpybGFDZG5ZSGxnaitqeGJzUjM3L3UrZ0UvWUJ3SW5vbG1wYzg0?=
 =?utf-8?B?dUdobHFDK2dkWFRzVHB2cjNQYmNXdFZjWmZLcE5nbGcyMTZMa1RESXNjVHFk?=
 =?utf-8?B?aTZaWU5nVUVleFo4Z29JRldNUSt3VXhVM1BLeCtJbHNJOU0veEtnYmhBQkJ5?=
 =?utf-8?B?SURnQm1Wb1JnOVhnVEVKSGI2SWY2TmZJbkxpUDA4Skc2dlNvMFBHZ1l4SUhi?=
 =?utf-8?B?S0RGQm9HMXNxa3p4M2tkRDNqTFdiRk9UMVBSTGhMWWs5NmRaSDhrTXQrcWZS?=
 =?utf-8?B?Q09sV2dWWnBzeG9xVWo2S2kzbGZnK05HbE1MckJOSlhRN3JGRkdTTXcybU42?=
 =?utf-8?B?QXh4SGF5WFYvV3kxaFlRRUZNM2dkTGZCVFFpNjVnYllFN2JFT3JCNGJIbGpl?=
 =?utf-8?B?N05rMklNVDZyaWVWMmQ3VzJSM3V4K2QrM0ZXQktjOFB0dGxQUmlXeStIcTNn?=
 =?utf-8?B?OVNyZy96Z1RKcXAyOXhtbnFYckhnNTFqV3NIZFhXMWRzWFBRZmJXc2dVdXhF?=
 =?utf-8?B?SjdLU0lSK1FHUkVHS3hGa1Npa1VvYmlRb2NSZlN4QzRabTQwMll0WVAxa1RI?=
 =?utf-8?B?YjNFYll3WTlJSmNHL3lISlVmWFQyaWd3K3o4UTZYR0NZQndCRTNUODUxZXRv?=
 =?utf-8?B?WWZXK3JOdFlDRTFFY1dWOENxTk1MaHFCcWpaQjRvVGhWaVIwcnArSXlOSUp3?=
 =?utf-8?B?MWU2cUNRaC9aMyt5WnlUZHhiWUtVLzBMcGtDNHRYVUNhb2F5djVxMEZBTnFZ?=
 =?utf-8?B?c09PVml6cXRoOEN1YXJHUzNHVnVtSjVua3JXd1VOZ2s3MlRBRG9YT0VGeUR1?=
 =?utf-8?B?aHFlUWMwQ3R0ajRDYm5TU1hLRXhPc2pBblpmSlpHS3BnR0Jid01xNno3V1Yy?=
 =?utf-8?B?VDN0endBbjJuOEs3K3dmc054WG9WM0NpWDcvZGZOUTBSUnNXNW5XZXBKUnVy?=
 =?utf-8?B?T3NxR2dUaEh3Zm1HN1phNERFVnJMTUFMUDFVUEV0MlV5b3FMS1Z5OEpLMVZJ?=
 =?utf-8?B?R1BsYjRFMWdMc05qb0ZtRzQzbWRRMTZNZndBTCsxNFhXdURDV04zekF4ZDMz?=
 =?utf-8?B?ZEFOekpKUTdRengwdFVFYWl1U0Jsd2IyYU5zc1FGS2RTU3NhY0w4Rk1KRzBY?=
 =?utf-8?B?K2VnR3MrK1pld3JpcnJWMHNsL25YWE9VREhOZjR0QzQ1MlR2OFVQUnVLU3hv?=
 =?utf-8?B?WEZKQXNtaUtqaCtiMFBaSmptNHRVYW4rOEVuUGx6YzZ5VWdrMUNONFhEZnFH?=
 =?utf-8?B?Z0I4ZXphSjFudHNiMGI1RCtNTGU1NThEamx1bWJFTmZVcXBRcmtWbWZ1QWVC?=
 =?utf-8?B?aWhOU3pPL0dCZHdSYS9HUTNYdU5qZzEyNjllY1NHTTJucTllTksyZWhVZmFN?=
 =?utf-8?B?dzBQbXF0ajV4b1Z3OEJOWUlGNVlOV1dYckM0NlRJTUVtOXhKamcyWnBSTVFz?=
 =?utf-8?B?UU1za08xNVdkMUE2Tndram1MUUhCcGRNcTk2ZDcycnM3cHJpMUVkOEJnZ2JT?=
 =?utf-8?B?bXZ2T1NMR2tqSDNtUjdlNFRsU1NoMkVndTJXektrdDU0bDRIaE80K1NTd0Z6?=
 =?utf-8?B?d1lhWStUQzNxcXo2aUhSWHNsNEwxZnVPTjdHODRPTklNUFYzZzB3TmV3Zjhn?=
 =?utf-8?Q?mseQxZlwP9ar+VS4=3D?=
X-Exchange-RoutingPolicyChecked: DH56/CSuxEgFCCgCOsjKRS4TXyuqNnknMdcomBCMc02iatlBnz90wh1VnqftUYPXSKEOgbvvpWrFgF3/6kYqNuEK8w5jcAJ6fXB3vgJVyYb+W99gpk9SxGyxYOhzMpHBxHd5+vQZDj0geMW/AutexusSmpnKAu5oVO5rcIXtLOUt6uM1fbqCiz+/V84Y62CYj8F1rsVkPrEQQgcVUEnR12Phozccqc35fL/lMAoN79WJG9wHt/lyyOVa+fPYjVOqI+RLXiGZPiUirFgcQ4DSMdqUzc1Wjc71I1xUfpwpNDlCk8+zFv636qMKPVEOBOsgknzqF0MEqEpXBPUPA06HOw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fe54af9-8a35-4e0d-b540-08df0dc636a6
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2026 16:28:28.3593
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cruhX/CYypbRfbnt+u3x7upgUw/GxErwCp4JGmj3ZSpO/LJ8VssoHmY8H6QOvH/Xz6yjk60nyXEk+SXMjJNXUC4tliP56IyuEgM6N7Uka5s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6112
X-OriginatorOrg: intel.com

Hi Ben,

On 9/7/26 2:21 AM, Ben Horgan wrote:
> Hi Reinette,
> 
> On 03/09/2026 17:57, Reinette Chatre wrote:
>> resctrl_io_alloc_parse_line() only has one caller that determines the
>> resource via resctrl_schema::res and then passes a pointer to the resource
>> as well as struct resctrl_schema.
>>
>> Only pass pointer to struct resctrl_schema. resctrl_io_alloc_parse_line()
>> can determine the resource itself.
> 
> Nit: Without taking into account that a resource is going to support multiple controls in the future
> this change feels a little under justified. Perhaps any extra line in the commit message is warranted.

I agree. I did have such snippet in an earlier attempt and our internal AI review suggested
it be dropped since it references work that is not included in this series self. 
I'll rework that snippet to see if I can find some middle ground.

> 
> Regardless, this looks good to me.
> 
> Reviewed-by: Ben Horgan <ben.horgan@arm.com>

Thank you very much for this and the other reviews.

Reinette

