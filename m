Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 367502459C6
	for <patches@lists.linux.dev>; Tue,  3 Mar 2026 19:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772564822; cv=fail; b=a7xeWOR18qlb+SIMTka/taWvH/teNh9BjGilXsyWkDQV5a4t+AeIz2OHiN4UMbWFjlsEK+npb/B0Y0wmMJqYZnT0T0WaEeD1INnckxPEKlSGyygKGas/4LW6V1c7Cm/2UNeEOU8XNA1Efcwuv1J1iFE1x+FdzICHIR3RS+gtJv0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772564822; c=relaxed/simple;
	bh=VrkbLvWcB7iq/VzPdelzXs1qjZFJXF62gQ2PBwgeGws=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=FHjnXiyxplAVWWT27miUKT2t/JTI6UYNrGViBQtNZdiJvtumA8XZoHwIrIpB9+cw2fhAQAim6wWIZ8QrM/IsKqqJo4UMDR9/RwOeAmKx6rmgnXTaAyLXYPVBm/3yqEMOilLm6QF/fG2BAM5b31UUkhoFyvr9t2TEpMp5v6HnlfU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EPyqaylS; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EPyqaylS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772564821; x=1804100821;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=VrkbLvWcB7iq/VzPdelzXs1qjZFJXF62gQ2PBwgeGws=;
  b=EPyqaylSUNUT6fwqeBf8WrXoKQuhQ3hs5C2UJdkMLaAW20yAbGjz28rk
   0T2b8QT53+UMzeFJ+siN2eQUaeTP22aUPRTcqWIV8Kp5qWtX6LN55Yq0E
   Hk1ZCvm8yOVneLBdcL91ZbKJdyJPiAEpt0Tlilb/i3zstWHMJozzP4Qe5
   leaTP4QCmA0ezBUDYZG5HMq5ktX4jOiAm4RT62wiITJeMHh+KCMUb9c9B
   xs53ks9BJS8gsfi7jTtapc6ddKgbCqqcx0UT6DbHuslqKbYOkze4pRJvP
   0bSdCoGK257Ogzc464DGHMR4CjnWC9/NpEQvx26sb9R48lZpR9OFABPQ5
   A==;
X-CSE-ConnectionGUID: Y/sXoDt0SzSTckHBYQFfCQ==
X-CSE-MsgGUID: LUzLFH5ASe+vkjBqIviU+w==
X-IronPort-AV: E=McAfee;i="6800,10657,11718"; a="73665315"
X-IronPort-AV: E=Sophos;i="6.21,322,1763452800"; 
   d="scan'208";a="73665315"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2026 11:07:01 -0800
X-CSE-ConnectionGUID: 60l4K5/ZTZ2UiPHVCkI4+g==
X-CSE-MsgGUID: krze1Nz6Qn+VR/dzQYEP1A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,322,1763452800"; 
   d="scan'208";a="215562294"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2026 11:07:00 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 3 Mar 2026 11:06:59 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 3 Mar 2026 11:06:59 -0800
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.6) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 3 Mar 2026 11:06:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fp6uL+Sw3+DO0ZebmolkeiNDj8kNoAxBDVj+54fbkzMHsxrBUXTc5mJnUCd+wVuQcFSw8t/oSBsIMuFTReeCUMOMOS5FuIFLDzZRIuP0B5X7D62MVZsRBBQAR5UmZLeyMtae3ZFsuPqDwvej6Ub0wfT8ip+qhWoF3N54hkKCdjeU1eue6DX7+EbMU8M58PQcrT0YuYLq9IoZiVlwulAIRv35gYDAo9dba9yCo/iA6AZHimc+seqcOgycUBe4NPk/FoseW1J7tDnm+tayMv1XG1He+vcvd9er8GsB9mHejCzCk+gBJClkwWcpBOT6lwTZW4gMxf35oq0dBVt3Qqy+jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+QLCrvLlzAX0zWpveMgfy0j73za/vEPDbvB83zD8Fbc=;
 b=Qyc0daLkHqPUFpeFmsuxpQFIKLREYNwhWwmqOPVuKLvKqGMJ0xq2vq+bbHEorenylMECgGjjxfaMr4FqhcwaTPoY87iSHJ2+XlTQdZnL4xxz5lgAg+wKeTOTsbKcz8UVxZfhbCZTqOh/KSat5AdSNronYy3ZUE7WazyAgZlES88AJb41tFyl45xf7ZbtnHaujpVV7rBHHAldwWFTJtV+A9a46BIobu5RIwet34tatCzV1rzRbMcw5pzlUAgrKGw4jL78ZzPojmJAieeotDEJIFen7g65xkC8/Lqrcff2iD2SCiiPh3hFQ6VBw52p0rVfq1OgD0FQLRRHt6kuLHrbXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by BY1PR11MB8030.namprd11.prod.outlook.com (2603:10b6:a03:522::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Tue, 3 Mar
 2026 19:06:54 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%5]) with mapi id 15.20.9654.022; Tue, 3 Mar 2026
 19:06:54 +0000
Message-ID: <a3343e9b-e481-4282-a775-651a516164a1@intel.com>
Date: Tue, 3 Mar 2026 11:06:52 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/11] fs/resctrl: Use accurate type for rdt_resource::rid
To: "Luck, Tony" <tony.luck@intel.com>
CC: <james.morse@arm.com>, <Dave.Martin@arm.com>, <babu.moger@amd.com>,
	<bp@alien8.de>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <ben.horgan@arm.com>,
	<fustini@kernel.org>, <fenghuay@nvidia.com>, <peternewman@google.com>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <cover.1772476561.git.reinette.chatre@intel.com>
 <956a7f8c9ff85b873ec85159a66d5e3c8b468d70.1772476561.git.reinette.chatre@intel.com>
 <aacmf_CM52gHRMot@agluck-desk3>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <aacmf_CM52gHRMot@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P221CA0030.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::35) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|BY1PR11MB8030:EE_
X-MS-Office365-Filtering-Correlation-Id: e8ee41c0-d019-4cd3-01c4-08de795808c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info: me0tz3gzuFwKqhuzMtmd54FspBVzVr5mXmrjtA9sn/Vee+qgRykxdRYtgWDXA6CcaTe1oMC/xfpj1CJzrEBEtiE5zQXooA+JOubDSN/DVwOExWzooYq4Gi8l8vdFNXjitusa4QUm+0KMFPoCYkSF+znxdgGChWuC6NZwXfoJjAYKh4VqH0+nYZac3zmcFo9/ohSQne6qeVh3vvws/fOy6mJ41RLVpwyL1V+7ASq1D7ULPgT2gHCgq+Hi8pWF4Utm90ZKsm+Qz2jx0vcsNPuUNsTURYNNgrNNeNli0VImn0arVKPgcEWPyYB/0oc1r7YOVCHKfbpXfjffTUkW2Thb50Cs//UR9oysn1p1KNTmJJSpNCl80lU2VBaMyyAoL4SwVGgLZMhHSWsz5urRiPMg67El/aAKj6Bb5tTydgOwQrJ1lRov8VPaeiz90NdfmFHYV6rfJ0Z+Qxg6/Jhkpp3ei8wrzV+1DLyvzch2outfcENhxDNl99LuybZzTaVVHVmTtZDAr3UJokKapNTzJ+XMXVR4FTBI4NbjbU5toLxJ1qycGHnkn8TpzZ1Oe4PhJN4IuXuUQfSyQ+Fbq/HcMVQaE8TxRoB/+XxUKdC3TyyqzVb+ZuyRysLjTXkRAIoCAaNiNFSKoHkX9phFz0q/eKQLxAAHauLfT9WM8O3vxXZLMDiaTWMuYLm+4fIHh9gpUsnqgOslMQ08FWbm8e9gnOtA0uk+jtMwJYoxA87PF3ealO8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aG5abEZtaStrZVczc3dKSzlMeENQbkpqajFDWlFtSG16WVZvNGhuSlV6QkQz?=
 =?utf-8?B?aFdjNVc2ZU9MSVVjUTJ6QjcxTTMrQmNqYVFQbjcyNUVmWTcrUE1iUWJBVVg0?=
 =?utf-8?B?YUhNWWQrK3hVN0N3SVMwTStYMmZvZitVa09LS2U2N1VqV3pKUXNjaEJVUjg2?=
 =?utf-8?B?UDJRdGhIQ2VkZ1dOY0ZFTGxaS09DdWRMaERNSExTbWp3TEt6YkZ5QmJFY1Nv?=
 =?utf-8?B?Q0xnUHhqODZ4QlZ4OFFzbWJtQnhZRmVNYjN2dHBUekVzL1pEeVBhckZLajZ5?=
 =?utf-8?B?NmU0T0RtQ1dlVVZJcXNpQ0daN1BxbURwOG5rcU9uSUwrUGJrZTdoN3BRS1Bt?=
 =?utf-8?B?Ymdkd2VvWGRQUE1CQmRha3ByQjhHcUtQWTVDUDQ0NzlGdWU0aTRWQ1M3QmZp?=
 =?utf-8?B?R0NKc09xZmU4OHQxWHhGUzlPelRHdnVVZHFpb3FvY0FtbEQ5WkxjcHQwRnNj?=
 =?utf-8?B?cG5PeHI1UW84bUt5WWxYMFFkOFZVV3A1ZFQ1bkRXZkxJcHplbmFRK1oyaDY3?=
 =?utf-8?B?UEZtT0VpTFNRSjUvWERrZWdWL04wK2NiK2pTZEpEekx5TTg4RThlWUN0aTk5?=
 =?utf-8?B?anduUVQzVTBoWmRHcmozNHFEVkhCNHM1QzZXeW5udklsYTJZYlRMT0VWRi9n?=
 =?utf-8?B?QUlCdFd4Nk1LelVQN1ZVcjhFU0dWTzRYWGMwWDBpY29GNWdRTytVcUVSMkp1?=
 =?utf-8?B?MzFtdDZzYzFiRk04Y3NIUWF3M2NJMjI1T1VnWVRXQ2JPSEpCNjBrdkhDUmNi?=
 =?utf-8?B?aWRZaHo3VWZxL3JWQzBlOGZlN2sxR2pveHp0YzJxRk9iQmhZZjFpamdZMVRS?=
 =?utf-8?B?TnIvdE5MQTFnMDJ4a1RZMzhwbVd6ZlZ2Q3RDTDU5ZFZGblRPOGlMRmIvV1FB?=
 =?utf-8?B?Ym1XUXYyUC9zUmk4d2lGa0hQTkJpYlhjVG9ISHo3UGxIUkRubVdHL0dDVkhy?=
 =?utf-8?B?aEszb0VTZkdsR0hmWFVwVm9USFNVWmpacmRMNG9jSnhJNWJkZEJxUVdzd0tX?=
 =?utf-8?B?ODY5MjVjWGl3eit6QTV6NzlXNmt0RUJONHhkam1EbTV6Zm5TQ1BYZnFCckl4?=
 =?utf-8?B?OERSamIwSklYOWc1M0x2eGU5d1FJb09xRnA0aTVsRmpBRndtTWs0bnRjZzBx?=
 =?utf-8?B?Q3JXRGRRaG9wUFB2RE9xU1NOdFRYWWxGN21IQUNXR1NGMzkrbWhaeUUwZ0E0?=
 =?utf-8?B?NU1saDZLN0x2aUhGWGxMR2JLd2p2clIweEMrM241YklqM05pckdkSEE2SzF5?=
 =?utf-8?B?L2xUbUJXZFZTQmlGdjZvYTk2K0lONjJaZ1E3bHltQXNaWmhkcHI0N3F4Y1p0?=
 =?utf-8?B?NlVRTUNBOUxZZEF6UHdSWmMvNXRDTm50K3d5OUNJeVk4dFU5cFljWHJGL2E2?=
 =?utf-8?B?Y2JWNDcraW0zcXdnMFdOVE50djRFL1pqQlp6Z29jWGR4ZWM5WFppb3NzZzV0?=
 =?utf-8?B?VmgyMXRIRjQ2UWNRaEVHZUZ5N2JnS3RJc1p0VnhzajAzMjJ0b1FqSnRSZy9K?=
 =?utf-8?B?ZjAxNDhBQURlNGszZzBsRGwwbWhGbVFzTWlvYVhQRWNkZzVtQU9JM2l1Wmgv?=
 =?utf-8?B?ZW1GSU9ia3ZEOUJ0RWZCNkVqZ3pHYkJuKytlU2Z0aStVYitBblhQbWtBd0t1?=
 =?utf-8?B?dDVCd2xDeWpRSFVlUjdocWZjMFVPamlWcXJXMVhteWZhYlRPUE5BWVZrSWEw?=
 =?utf-8?B?YWE2OGQxZG1ORmhOQ3dscU9TK1pZNExsTUFpQkNoWEtYSkNqVHl5MU9wcFJp?=
 =?utf-8?B?RDJSWDAvL0dZWUE3UVJnNnB4TDBnNGM5WDBmbldBcTRBbWRHM29vcS92bmxV?=
 =?utf-8?B?MnYrMS9pV3p6djlZejVnN05UenpTdTJ1VjNzOENZNGRYK0xIa0wxSjErRUlp?=
 =?utf-8?B?REtOa0tpU2RUQkpFQkJrSGJIL1lYSitPOGpSQTB3R20vSE9FSUZPMWxyVllt?=
 =?utf-8?B?VG1sdkdmdzhnODl5RytaczhBZE43cjNHREFqNk5ENnVRWG9Vb2RjRWZWMXk4?=
 =?utf-8?B?elJsYmNydXdidXZ2U1htTTNMV0QxaHFsSEltU2s0aGRYdGlZVUs2ZHdaZnhH?=
 =?utf-8?B?MXl3VGZxT3MyM2lWemNLbDZDVC9KdVdoY1VFcldxQ2pOTXAwZHlpRWlrbVR4?=
 =?utf-8?B?NTkvNEdlZW0yMWJwMkJyTkx1bm5kWmRmQlI1VFhiaUxvakpKbCtyLzZaakw3?=
 =?utf-8?B?SGhaUFpUdnBWR0hXaEt4MmVkckR6aTliTUc0cjF3cHgvU1pIQzVtV0daNld3?=
 =?utf-8?B?bGx3dmRyTElWUkRGWHY1S0xWMW9lWjNyWFovM3d1czI0VGhwZklrUDNRSS92?=
 =?utf-8?B?Y200Ykw1SXpSc1BTUHVxR3lJQjZ1d1VNTS9GTUNxSTQzNzZaUm1oOVg5R0V1?=
 =?utf-8?Q?M7fGiNKCuGPEVfkg=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e8ee41c0-d019-4cd3-01c4-08de795808c5
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2026 19:06:54.6150
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0CmA5FVvtElHy0IGj82F/9g/b4xKekMxJODkI8T8Ji5ZQPIZbgBab7Um4HuiWCEe5s2njbSTJw37OCJnKkprnQ/Tp0vhbm17ht3S086pmys=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB8030
X-OriginatorOrg: intel.com

Hi Tony,

On 3/3/26 10:20 AM, Luck, Tony wrote:
> On Mon, Mar 02, 2026 at 10:46:11AM -0800, Reinette Chatre wrote:
> 
>> -	/* Must be the last */
>> -	RDT_NUM_RESOURCES,
>> +	/* Additions to enum need to update RDT_NUM_RESOURCES. */
>>  };
>>  
>> +#define RDT_NUM_RESOURCES (RDT_RESOURCE_PERF_PKG + 1)
> 
> Alternative approach that doesn't rely on developers reading
> that comment and updating the define.
> 
> Replace the RDT_NUM_RESOURCES #define with a variable initialized
> to ARRAY_SIZE(rdt_resources_all).

....


>  include/linux/resctrl.h            | 11 +++++------
>  arch/x86/kernel/cpu/resctrl/core.c |  9 ++++++---
>  2 files changed, 11 insertions(+), 9 deletions(-)
> 
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index 006e57fd7ca5..ef2efa2e4b39 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h

The resources resctrl fs supports are defined within this global
resctrl fs header file as:

	enum resctrl_res_level {                                                        
		RDT_RESOURCE_L3,                                                        
		RDT_RESOURCE_L2,                                                        
		RDT_RESOURCE_MBA,                                                       
		RDT_RESOURCE_SMBA,                                                      
		RDT_RESOURCE_PERF_PKG,     
		
		RDT_NUM_RESOURCES,
	};


> @@ -27,13 +27,15 @@ int proc_resctrl_show(struct seq_file *m,
>  
>  #endif
>  
> +extern int rdt_num_resources;
> +

....

Architecture code below ...
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c

...
> @@ -57,7 +58,7 @@ static void mba_wrmsr_amd(struct msr_param *m);
>  #define ctrl_domain_init(id) LIST_HEAD_INIT(rdt_resources_all[id].r_resctrl.ctrl_domains)
>  #define mon_domain_init(id) LIST_HEAD_INIT(rdt_resources_all[id].r_resctrl.mon_domains)
>  
> -struct rdt_hw_resource rdt_resources_all[RDT_NUM_RESOURCES] = {
> +struct rdt_hw_resource rdt_resources_all[] = {
>  	[RDT_RESOURCE_L3] =
>  	{
>  		.r_resctrl = {
> @@ -110,6 +111,8 @@ struct rdt_hw_resource rdt_resources_all[RDT_NUM_RESOURCES] = {
>  	},
>  };
>  
> +int rdt_num_resources = ARRAY_SIZE(rdt_resources_all);
> +

... and this proposes to let the *architecture* initialize how many
resources resctrl fs supports?

This implies that all architectures need to initialize this on behalf of
resctrl fs. resctrl fs does not force an architecture to use an array nor does
it require an architecture to support all resources. What if an architecture
decides to not use an array and does not support all the resources resctrl fs
supports? How should it initialize rdt_num_resources?

I see the number of resources supported by resctrl fs as a resctrl fs property,
not something it should depend on the architecture to initialize.

Reinette
