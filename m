Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ED713A6EEA
	for <patches@lists.linux.dev>; Fri,  6 Mar 2026 19:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772825175; cv=fail; b=m5V10AL4mkY6P1Nc+fcUqInlTHC29qyUx03eBJntcXj+mmiBM5UkGpUBCTQMoovs2t+1I0kurV3u5PI2cpDDGU22BtppbJsgODul1CHkCz1T9iMLS2SwjS3lERMsu8pWddB255Fcaa7TiwUFtWdJTo0S2DtAqayzGMM1sa0/5Y8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772825175; c=relaxed/simple;
	bh=LUXNhEukSG8SkRGQvIQ17RZUCle6xQkzkhdXjpVT+H4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Y75jRT/CQQm9XHAa365XQG+3noqQGnYoZmClEpVEOodm3ddPV1hhTnWytjzXH7kJgneGXhDUcZGnGxv3EzQsI6DGovcD3rCqZf5Slg25lqOpegoWSwOcFH92Y2Nsg7tJoQ2DZiLwU6ZtOgJ0zvStgXMes7mqBMQkgVYeFCCBfok=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kZtrh6ps; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kZtrh6ps"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772825173; x=1804361173;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=LUXNhEukSG8SkRGQvIQ17RZUCle6xQkzkhdXjpVT+H4=;
  b=kZtrh6ps0vRAJX+eG/tSm95bO/X/N7ARy6JHsY+x0oEpXVpajE8B15SN
   CHShWtdv2SEtVThTMat3BVEYajCgWjFvVqTXbAeCZTb/k1CYzn/ldUMNC
   CGEZlQsUrBRBJxPpFmJHI7S9dmZL+RN5av83KSb+8MDKuOKGkwXUrAB2K
   GAkSGDB1i8+4hl067joEUazBtfhe3X3LyAZ+8g5ozvEUW8/WW43r5E9i7
   vP9ok8XjoOQG310TZwhZ6k2I2s0LVDmukqDy8stA8W4EIuz+qTqSalgXP
   CgnZVGGYrPO6J+I9lYmOqiTfYbZ1cP0yxH/DwoPMQsds/NOBrpzNIgSE/
   Q==;
X-CSE-ConnectionGUID: G5qs4mppRwKfvmqKWeLuUQ==
X-CSE-MsgGUID: f1ZuW2fPRMWuN6tU7Ll45g==
X-IronPort-AV: E=McAfee;i="6800,10657,11721"; a="84651638"
X-IronPort-AV: E=Sophos;i="6.23,105,1770624000"; 
   d="scan'208";a="84651638"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2026 11:26:13 -0800
X-CSE-ConnectionGUID: Rl90JdDvSUOLuhp7p0wKWw==
X-CSE-MsgGUID: nVp1Q8ghTbyA1UXMlg+3Ig==
X-ExtLoop1: 1
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2026 11:26:12 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 6 Mar 2026 11:26:11 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 6 Mar 2026 11:26:11 -0800
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.46) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 6 Mar 2026 11:26:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lnGCG/kfkTXtHuspxIpCKKCnC7JlA5jTMy7WuGQGYwi6W+KAQOwgsNs6rc7Ba7IAhl0b4OO6YokTTh4409yXH+QbJto4dvSVpLvhYQ2Ijry48DbNFCid9UUv31O5bc7Ua4Fu67Qdh9EsVOipYRjKJt+H4VGniPxBMhGc4dxrE7LQ9tK0AuwLDh+DvflwMjm/v8DPC2N1k0sl6Xz1qiwVw7upVBFEaE/T+CsmzUF16S9wjWbLDqvT2des6RYlC2VWfr3KvRJDfTc4ptBR2TKDN7CtQ/oWhz0BJ9pu+JLC/wL/ncIjX48kIle8FkgTnGYpBhv8KZK6duq6qsuH2/gczQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4ULlvhIgSKlg1mDhPl31i0URXLZh8WXWBDLUk4UeR04=;
 b=ay329eh7KE71nKdnxqwCzDTZCbYggubCDw5IByAZtnahMS0Y4O1dX8/TdV93a3nX3Fg+sQd688Wi5euFvoPImsQWD9IatGu7BnAOvtTx0gvVAYthc9f7Ymc6CSegESfcI2ZS3gslUD5GmetxfArb4AdQreVHt5Q91kM6Whi4M8d9kuSRFw5HOojNXVd21u8i/Y+ZYgPGfWxC7KELKu1vmKAJnAySX//vBjDbpxATtyBsy9fbkTYnK/3CGU9f0gfTEOlOFJfxoPJeAF4CSVYOGSxTQQPFQsDssSeSMtTTf5KXAU03rMNBhetrMSjOt1JtewB8AD1JBiFiGiJ/QijMTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SA3PR11MB7463.namprd11.prod.outlook.com (2603:10b6:806:304::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.18; Fri, 6 Mar
 2026 19:26:04 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%5]) with mapi id 15.20.9700.003; Fri, 6 Mar 2026
 19:26:04 +0000
Message-ID: <5eaa2094-c07f-45e5-a125-2c47cd9d120c@intel.com>
Date: Fri, 6 Mar 2026 11:26:02 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 9/9] selftests/resctrl: Reduce L2 impact on CAT test
To: =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
CC: <shuah@kernel.org>, <Dave.Martin@arm.com>, <james.morse@arm.com>,
	<tony.luck@intel.com>, <babu.moger@amd.com>, <fenghuay@nvidia.com>,
	<peternewman@google.com>, <zide.chen@intel.com>,
	<dapeng1.mi@linux.intel.com>, <ben.horgan@arm.com>, <yu.c.chen@intel.com>,
	<linux-kselftest@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <cover.1772582958.git.reinette.chatre@intel.com>
 <74657e85c607b1494c898353087fa40e80a8af01.1772582958.git.reinette.chatre@intel.com>
 <a36e9760-f59d-5bfe-640f-7ec8679336d4@linux.intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <a36e9760-f59d-5bfe-640f-7ec8679336d4@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR03CA0332.namprd03.prod.outlook.com
 (2603:10b6:303:dc::7) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SA3PR11MB7463:EE_
X-MS-Office365-Filtering-Correlation-Id: 471c85b7-de7c-462c-1210-08de7bb63568
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info: zBokOQLbdc86XJ5x8AaYSEnDZNtXSxrm/u5Q/pNlthQkG8yTsjngRVopo/GbjEGTHyT0Nx9tZjIFY0HIdweKeiz0EQjpw6Hok5VvhSSGh4G8cpVvK72DunaGqCyGVyxW0vxYIO3VcTuoWCq4bhpxE5aASy2Epd9RQQNZrfviXPpz7TQ0KvCcoZz+rNDz6j2n2jc6aMllwfz0/97gXqqD/X+vW3+WY/O80AN1DwojsJDW21kBOwGs+v7VupZIyaHOoJwPk4d+HfiIBO6fevHFeKAmF7Xw85JIffNmuWooPycThmbczXG/fOmgvDCWXqZZcZR7nI8bAM3F930gbBOa/4ssaIbZ2Oh1abjMf9FHsu6QTOZnih8lgvcwaJDqY/p7NRyaTtSzIncuok8GD4mSrUJzKtra/ME5l+jeQJoiCzOFFzn7wfqCpBud+r8k1uaBaggXOpSI2ijp7tw/rOPL87SZZI1mn2CV22nNjm7gtbcT0xIc/HnNJ76Vo1C/CbGL5XyepXm4R+9UXDzqFwVo7oDPQEs0afW/vLNQ+1U7qCtPT9VjODkfQOqjL7HgzNSb7GWq/IAg/9/4XRBJrPLkOJ0fMLBCEBCfSLB2IWsC2aQUVPT4cnnUf4Cz7MuYbIdPmDBMJ2TVf229OtPrz08RLCAWO+GNFPOHd7BWeWkDN8Z4p+vlXQaZhi+Ghy+rW3x4JTub/IGhWYj/o3O/HhIyi73/nHT9MDSmG+yia1nLz/c=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U3RhcVcvaXVtTnVEajNHNDZVeXY3WWx0Y3FxWFd2RHhCaWdoQlRHK2Rsc1Mx?=
 =?utf-8?B?T0JYKzR0STVKcFVhQWRPaER4NUZaMG1IMkNvM3pJVW9EK3VrNUluaWNka2Q1?=
 =?utf-8?B?cGI2V0pCYjdVbEQvMzdqTVB3TTdzOThXWUQ5MXM2Mnlsd0lZZnBralRYNFRy?=
 =?utf-8?B?MEcwbVd4bWRRTkp0eGlIYnZWQzQxakhybmg0Q09yZE0xTGhEMGZqRENWamhW?=
 =?utf-8?B?cmZpV0trdVl3SlQ2VFdURmpYVUhyS1pLaFBTSW5MeGxPK0pIenB3VENLSVJl?=
 =?utf-8?B?OTVsOFYxTktiSEFhMHM5Vmt0bytjTm9FWWVIY214ZXJJcTAvSlFybHhpa3Ra?=
 =?utf-8?B?c1JXZGZjRkN3R3RiVDQvdVkvY2orWkdoQkdhc09zOFJiWWdHM0pzUUNwZ1lr?=
 =?utf-8?B?SnFvQ1NIVUNmTnF6VHNEWmZydjBWWnJxTHlWSjNTMFI1cDNVajF6cDlBNHpK?=
 =?utf-8?B?SGdUazZ0dG11NVV1TVZUbWdjL1pWZmw2Ty93SDM2MVVFK01CdHo4UUxFZXFE?=
 =?utf-8?B?L1QzNDBtVlMrdVBHanRjU0IyL1J0VVNTVHNDaUZwRkdCaVRjN2xvR1lQNnNI?=
 =?utf-8?B?cWdpaU84a0dFVWJwbDZrSGRtaDRJaVJmQWNwVGhrSlpKMVJLNmdZWE9sRDNs?=
 =?utf-8?B?U0FrZmxYYysrU2dlbGlkSTB2R3UwS2diMW9vTWhWendDKzZsS3Ixc1NyNDdE?=
 =?utf-8?B?OEpBL014SlJSVmFBV2IxWEg5aDJ3akYwOUFkTUQ1L0RCZEdmSG5jc3ZhQWhW?=
 =?utf-8?B?QVI0MGZmWEMxd0U4emFSdXNZbDVkS293U09ybjZIR08yNForU2NBZHQ3Nnc2?=
 =?utf-8?B?RkJlc28xaFZ4dDlEeWMxcWxUTkl5YmVwdDRUMi9oL0puOCtsM3I4d0FseHVp?=
 =?utf-8?B?N0NjbjVHOG9HSmx4aGZaTEV3UzlyZFk1L3dEQXBPM1JFQVpXZklOMG5kZnBJ?=
 =?utf-8?B?YlQ1R25BaEtWOGhYWk9UaVh5eS9PQktBdnNSSFJxVUJsc0w0c2dZYzlpaGlj?=
 =?utf-8?B?a0ZkdmhyZDJmR0s1MHg5cVlpRHNIRWovWWFvNkQwOXBPUTZpU3FxTFZsSndu?=
 =?utf-8?B?MU8zam9rZHBDUXZnejBxUEtaUmFPam80L3RCMDE0NzV6VnhVZlE0WDBKVVpJ?=
 =?utf-8?B?S3l2Q2FTU2tRbzZZcEdjUXlCTGRPOFRvS1VlZXU0c1FCSzN2dkZYU3hmREox?=
 =?utf-8?B?ZTFqQWkySXF4WFBQWFhRTExyalNERm1lSWZWMHhzUmxuQkNlN1B0M1d1cExG?=
 =?utf-8?B?VlRQTDQzNVdFMWdKeTZyNEtyUlJwMjBnUWs3cHY1SXRCL21RaGpLQ2MzTVBu?=
 =?utf-8?B?S29TZDRNZEYvM1Nwdmk0SWhyV2hKTndteC9Kc0tYR1dDN2ZPRVZRZ2dwQWd0?=
 =?utf-8?B?U2JsaHBVOU1MRjFlaGxKOVVDVUhrZjQ3RkhCSXpmWFd1Zk5UWWpWQ0RPU21u?=
 =?utf-8?B?WHZLcWdlRjliQXhMWWJLZjFWN29lQ1pLbUpDRG5tUWJYSGVTNEVkODJpa2dY?=
 =?utf-8?B?RzlmMlBSa0tnME92MHNOZld3dEo4eFRGekNUVXM1WlVyb0psbWY5V2NCb1I5?=
 =?utf-8?B?VUhTYzFHb0ZKWWliQmh0S2lXaE45eFZML3JSRVQ2Z1l2bFIrd2YvTEtHaTBU?=
 =?utf-8?B?NktGRHdSZ1kyV1c2TXhzaUU1eUZuSXk5UnVhRXJieEYvM09SYUlHVnBoUkhO?=
 =?utf-8?B?QUtaRkREbW9GVE1CUkJQL1BoNlBFaXVYbmRRblJHK2NkeGdla3dlVW13SXRh?=
 =?utf-8?B?VXI3dnpMTzZPRjlseGt0MUlma2FRTHJYSXpRSm1oWWxTWWFWZzhBTkl2NXpB?=
 =?utf-8?B?cUt0ZkRkL0dBYmVWem1oTGpPOS9RZG5kT1ZXSjFoeDJMbERxVk1rMVZtRzJ1?=
 =?utf-8?B?bVN1WFVIRW1uR0FiZEtTZ1RnL2YzN2JvRXlteEg0cGVCOU03VzJtV1hIYkh3?=
 =?utf-8?B?NmxnTEJRNFVrbk1zbnpqTEdGOEpua1QrYjZvTEVSbmx0VS9nR2kxdmtRbDFY?=
 =?utf-8?B?QzVTZVl5cThRN2N1Mk9Lek5XM245cGp1R1FKaEhETUczbFREc0tZV1A1UUNn?=
 =?utf-8?B?Q1A1aVZoNmJZOFNyR3doT3A4Y3ZiaXRmWTdvQjJ1c0xsR3EvbEQ4SEhJL3BM?=
 =?utf-8?B?Uy9jTXNrUnV0RHpaN21pNXhDQUNJV3N5WkVrZTZtNEVZKzczRkozclJ4V2ZO?=
 =?utf-8?B?dU5uZGE3Qmx1UEVYS2F3cTFWSXNweHlQdHF5WHNRMk5mNXFFRzljVi95Smpp?=
 =?utf-8?B?NDkvUWpGeVU2MmU5SktiUTJPUzBLRjNwOEhNK3VlSUMrUmlxZ0pwZGh2L0Zy?=
 =?utf-8?B?MkhNa284b2dKbXgyMGxVYWVMbTFOS0tOY0ZManl2RHR3Q2Q0QTVGT1d2OUZK?=
 =?utf-8?Q?VSLmXzEK9BU629Ag=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 471c85b7-de7c-462c-1210-08de7bb63568
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2026 19:26:04.4495
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c6JOl2O9M9oJDxunjPa+Vxc9pa1lLe5M0FBFc6KQ9aqQoKDDxkdRE0qg1bUKq/68Fg4iEn1vKYrj6J7bV3v25I8ndbvhM4eozxSCKlqxPuk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7463
X-OriginatorOrg: intel.com

Hi Ilpo,

On 3/6/26 2:35 AM, Ilpo Järvinen wrote:
> On Tue, 3 Mar 2026, Reinette Chatre wrote:
> 
>> The L3 CAT test loads a buffer into cache that is proportional to the L3
>> size allocated for the workload and measures cache misses when accessing
>> the buffer as a test of L3 occupancy. When loading the buffer it can be
>> assumed that a portion of the buffer will be loaded into the L2 cache and
>> depending on cache design may not be present in L3. It is thus possible
>> for data to not be in L3 but also not trigger an L3 cache miss when
>> accessed.
>>
>> Reduce impact of L2 on the L3 CAT test by, if L2 allocation is supported,
>> minimizing the portion of L2 that the workload can allocate into. This
>> encourages most of buffer to be loaded into L3 and support better
>> comparison between buffer size, cache portion, and cache misses when
>> accessing the buffer.
>>
>> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
>> ---
>>  tools/testing/selftests/resctrl/cat_test.c | 6 ++++++
>>  1 file changed, 6 insertions(+)
>>
>> diff --git a/tools/testing/selftests/resctrl/cat_test.c b/tools/testing/selftests/resctrl/cat_test.c
>> index 6aac03147d41..26062684a9f4 100644
>> --- a/tools/testing/selftests/resctrl/cat_test.c
>> +++ b/tools/testing/selftests/resctrl/cat_test.c
>> @@ -157,6 +157,12 @@ static int cat_test(const struct resctrl_test *test,
>>  	if (ret)
>>  		goto reset_affinity;
>>  
>> +	if (!strcmp(test->resource, "L3") && resctrl_resource_exists("L2")) {
>> +		ret = write_schemata(param->ctrlgrp, "0x1", uparams->cpu, "L2");
>> +		if (ret)
>> +			goto reset_affinity;
>> +	}
> 
> This looks similar to what you did in the CMT test. Maybe add a common 
> function for minimizing L2 cache size so it doesn't have to duplicated to 
> all L3 related tests.

Sure.

Reinette

