Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F821307494
	for <patches@lists.linux.dev>; Wed,  6 May 2026 21:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778103924; cv=fail; b=On7V8W9XvNy+NdjMp5OQKujlVQhiVTZiAI46eLWtOpOOhWSIVmNwfwMij+pHK9hp43dIRNlB9OMW+xIIuGHxgzCeTJHuvWj5sK9bRwCdlv0Q8EY0btu4jaUwza/Im8BHDayAEmFrH4AZTnjgjIphQcu4UUL5rK3fA986PCJEDnM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778103924; c=relaxed/simple;
	bh=rsarAwrEVGzPnU3JO4p9CIYum2g/Ke2thDDsa2DblzY=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=VL/6ViXKHf9GtSbrHUSqcmGuvuz99QS8Gw+SOinxPJMs1jcD1JXDO9yuDfv64RcWwUkIQlsJ95n+wyWoXDwW6eX6ZAzJOV9eEmU7jAscDATBytN1gVTkPTNFGunhrJnH2K0hGbUkq+802V/+d2j5dk2jsM8XlxKoEydkI4v1gBY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DxVWNsjS; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DxVWNsjS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778103923; x=1809639923;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rsarAwrEVGzPnU3JO4p9CIYum2g/Ke2thDDsa2DblzY=;
  b=DxVWNsjSO1zR+ALWlizskk1vUpef0sAQnM45mfqsIzrmuxxvG3NdWKrP
   KSOQ6XcWGyqblKK63OUYEKaylwf1us6uRzFWg39ZmQOVrE1w/RoETshem
   hppm5K/hi6nnB2yglhyZ6RBO7P3cwcY3dVNfFlTszl6fqy7laPJL1RlQT
   lFCcaXuyEmdde1nCA2qUC/URwLHPEEnN4Je2/GzYrw/Q4v7k9oTaXRaTq
   BAMGQL9w3jCSapURoiE4FihP8TDbXHGq4N/cLzxA/UbaxjF3zRSbMb/6a
   wI6F/LBc3gQL7QJoWTn2RwkVWUI67LEkyBP3bXQHpb5kwC54fU1lj2Oz5
   Q==;
X-CSE-ConnectionGUID: 27JLd2E1TpGjiDdgxLZ5eA==
X-CSE-MsgGUID: rWjForR3S/K9EP4HYvJpCg==
X-IronPort-AV: E=McAfee;i="6800,10657,11778"; a="79036588"
X-IronPort-AV: E=Sophos;i="6.23,220,1770624000"; 
   d="scan'208";a="79036588"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2026 14:45:22 -0700
X-CSE-ConnectionGUID: 81QDPu7ARf+E5SGi+f2X/w==
X-CSE-MsgGUID: /xuP+zBRTZeRwoePcF0Y1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,220,1770624000"; 
   d="scan'208";a="231733949"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2026 14:45:22 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 6 May 2026 14:45:21 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 6 May 2026 14:45:21 -0700
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.5) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 6 May 2026 14:45:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JJktmieyI7/JTRAL/t1/FlkanfZwc5QQ59sh/CsLN+XZoxv3fMY+KQ3oss5rVd2zh6whIr3q7TimHsGmESRgJ6FNokywMnq0/KE8QX1KHSOD/pAo3U4leX8ZV40dLiarVuIkv+2WSyox48Gsj2L9hEO/9XZHwyscU1ahe54nBxPnxnEChHiSfzahDUqH49mVMl0P01kgvCgBObnZC3tdrrEOGkiE8n6ye5YUsUv/skL2pE8rxqeivpGYSttVRYh8GBwTXGi3Dt5WvQgf6A6OAx1eguC8vJqYztsH9pTKi8HAgY4nhFmVXBHsbHnDk6ze1yiN3Y+LGiMtAzYWcSs9Pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fn5nrSDJ9zyKYEJLPm+eI1u22gTf+34YlupfukCJ4Yk=;
 b=Yup8ZieaWnjOLo2kzn/jaIsEbLAAfL+meqdlNTEIyZGhy3oKLARUVPcqV5Wzc4tKySTkc9mzDx0MEOcg7Zd86QYmdxbznnLbQhJvs6ruNk8weltssODdgWiF5D6/2hPCTow/7UkNDaSB7K+O9pwjwoAMOKd3zBxuIprxTzf6fv8DZ9mj2UJAvuFtCIE+r17e6soaPm4r4fma6xbDsNYdudSQ0tA9iNoA+SEubrneDZXap3phOO+fUjLBG66Bz07jkXOkBaY6jujwS4WNf8a6+XvqkEENIh/TLlPbDjsgvnvH6r4Gpw1y1v7KBPepTBDV2e7GyHF+4TVkYuonwB+Wmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SN7PR11MB7708.namprd11.prod.outlook.com (2603:10b6:806:352::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.27; Wed, 6 May
 2026 21:45:18 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%5]) with mapi id 15.20.9870.023; Wed, 6 May 2026
 21:45:18 +0000
Message-ID: <217d306e-78dd-4762-8c82-88d6bab9de44@intel.com>
Date: Wed, 6 May 2026 14:45:16 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fs/resctrl: Fix use-after-free in
 resctrl_offline_mon_domain()
To: "Luck, Tony" <tony.luck@intel.com>
CC: Borislav Petkov <bp@alien8.de>, <x86@kernel.org>, Fenghua Yu
	<fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260501213611.25600-1-tony.luck@intel.com>
 <2236fae5-7e66-43fb-ba05-76fd4434e2c9@intel.com>
 <afkizhrSwJkiLD3j@agluck-desk3>
 <3f13c7e4-3812-447d-8c42-b28fd6b9d0fa@intel.com>
 <afoesuWB8RezVLrN@agluck-desk3>
 <7fad1d7d-c892-416e-b97a-a230fd43f2a4@intel.com>
 <afp4OkwtPpyIwAC1@agluck-desk3>
 <d065f7b7-daac-4e45-b7c9-69175dfb43a7@intel.com>
 <afubI4kYrdWUXGUR@agluck-desk3>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <afubI4kYrdWUXGUR@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0138.namprd04.prod.outlook.com
 (2603:10b6:303:84::23) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SN7PR11MB7708:EE_
X-MS-Office365-Filtering-Correlation-Id: 9516044a-f89e-4922-5b97-08deabb8c412
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: eM4YgClWzmRiywfy7gyxE4cXtunkULr//aBCRfKu6Tq//KxsDGwZhRTQh4TOfUl28axY2I2meOeGk2hCU14ROQdKX/tD5nzamg/I0Cbq/Fzu6RC6IA1DonAcRz4cje4ECCk+aox9QMyLEzDLF2HuYQF0B1t0QQZWYElcFFbtMvtyQMgHfTOCem9w1Fla1umCsW9pyS0MuzwYnjf6JQfkUpIN8+fcKs6I2y1WgJ1e03klhhr0P5FMAz0rqptNdN+IaaW1UpYe3d+E2T7JSbkcq1PayuGDYNdkJ6B/8lrnQocCab4dqy7hhtQDfuC69qhhK0qc8PlGpSRWzzZEj1Bf0Asmpx5PiPnOBZmUO+FAp6IsVFxN4GT9Ym6GaZ0LPR/AAm7+mCHCqxtU+cks4DR5JqaXx5UzEBRvrhOlkfz0NtmdLP2QGmKB09GDCbM3S30XVmnpbTQdx5CypPMWL6C1T28QKgNaFY3JhEC7qW5QKc2ZF5srQJBlsvZhrDCteGMhhe0yAXRC3t66Ilm71Gos47jDKGhAZSwJgtgnOVaFM7YpY0Oy203UUIvQFy2qYpXn3toibD5eywrok/rak6I7SONVvSrF6k/MP+O50TNcwmGSl4rrF7EeXUAVJ1fut2P+QazoEq/yekmIe3MCfLvTPoGk94wscJ2CwcQA+zlIOCrGa09oPQrNq8KyAFpEFQjo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WFljVkFZWUNjVWhoSWRjVUc5Qyt5ejE1aDF5bXZmQWdkcWVKTDV0YSsvUGpG?=
 =?utf-8?B?TzF5bDRiNGg0TEF5NDE2OHVMWDRQU21jVFdpZDBLNXFmcFl6dVpxYTM1UWVH?=
 =?utf-8?B?ZGMxVk9uaE54eExBNVBXdTdOMzAyMUxJVVZJSHhvaVhSNXBLbkRKY2d4TGla?=
 =?utf-8?B?bEpvZnZVNU8xZmx4OGFmU1ozSG8zSVk1djFwTnZVWTZ5eno0TmY3NDFyRkFY?=
 =?utf-8?B?NGZxSDVvN2JsVFlENXJzZ0k2N1MwM2cxUXE3YzF3QjBxOWt5RnRwNHpCZ1BL?=
 =?utf-8?B?YUZ2QS9Fc2Q5QnMzQmErY2s3ampoajRTYXFrUktsNUtrenFqS1pvdnUrbCtL?=
 =?utf-8?B?YWdwZ1hoaXRRQ0k5YUVhSTY1eDJEMG1SRjlYM3lFTndKMU9nSndaVmd6dG0v?=
 =?utf-8?B?S0tZWStsZUVQdkQwVGltRWdFY1lSUmoyeXZtY2EwU1h3dEYwNEJKaEpUSDJt?=
 =?utf-8?B?eEZxQWtVT2pXaXpwR1RWb2YweFVWSFpVTklGQURRL041bENjN0ZidlJYZG1P?=
 =?utf-8?B?d1ZRWG9qMnI5ZXVlMHdQV3ZibkZQZHI3bkVYZ0srNjVaN3d0Z0gzWEowVVM0?=
 =?utf-8?B?d2lLbG15LzI2KytmaFMxNVhvK0lhM0RSb01ydDc1dWQwV1c0SEwwd3pXYzA1?=
 =?utf-8?B?U3lnVEpjTlljZUNJM2gwZFljSXdpbXl0M0d6Tm8vaGdxNW56cU45bkdhT3E3?=
 =?utf-8?B?QlJrTVlVeU0yU2NwVXZvZ29BdHZscW5ZVWpjUVl3V3UvMEhMNWN0d1BkSHlz?=
 =?utf-8?B?TjY0NVV5dDIrZ2NrYWhMUzJWSkE0QXA0ejJlNU5vRDJITlRzaTNNamRLUDcr?=
 =?utf-8?B?akdPT0U4NFV2Nys2MHBjTmxnT0t5TmhQNlNSM0QxeElFMys3SE45OUF6aE9Q?=
 =?utf-8?B?czhnN0tHWjdGM1FmUTFSWE5BSWx5cUtLTXlMRHhhVmI5R20vdG55SjdKUlRL?=
 =?utf-8?B?N2dIakRBS1hlR2ROZ0VRdmRnTnhMdG1FQWZjamwxSENRRERZaVJwc09IMmx2?=
 =?utf-8?B?ZDJEcEFkNHJoVFdUSGg0bWJ4RUJoSFRhMGxNWmt2cVIyT1pFQkpaV2hDRlJh?=
 =?utf-8?B?RGxqVGhtZzM3NGJrZm5TY1kxNFBOUjFwMVU3bWsrYWYrRE55VldVR1I1ZXZC?=
 =?utf-8?B?Si8yVW9kUWNJU2p3czYzdFMrODBuNlUyQ0pMUkpJangwNWE1Z1BoeGpGWlA2?=
 =?utf-8?B?VDRuU0JwWElqMFlTbUVBbGR3K2hHakJneUVQbDZwc1BlWlJyNjdJaHdsWkxo?=
 =?utf-8?B?aVpMVDljK29qOXoza2pvTmsyYkpqaE9vUWx0VURUK1NMT1lRNTk3eVFoL0Zw?=
 =?utf-8?B?djUzdkR3STlVQXVLL2dJTC9uV0t0SDZGTXdYWVdOQy8zdHpseVhzRU1sZENU?=
 =?utf-8?B?VFhDUzJRRDhKSWg2SDhBcVpmYWs2Y2lYbEU2ejk1UWNOSGpRRWtjVGVFYW8r?=
 =?utf-8?B?bjlIR2ZXanAzSkNhdUFJV0cxSEE2b3R3bnhKcERDN3R2WjQ3SjFlNVZXWjRn?=
 =?utf-8?B?RmVMNTJKNTcrOUZPbUptM0E0R3hYSXdDb0VsSThaRFlDUlJjR0FYK1ZzK3I0?=
 =?utf-8?B?RmV2TVZ5Zzg1T1lSNGpHRHcvT2UzdnowOVRrNXpYQ2lHTmFlTGRIcmcvR2Zt?=
 =?utf-8?B?cENzNTExSzRRWEEyaDdwYmJhNDJMRGUzSXpiNlhEL3pBc3RwaTlVOEVsUEZq?=
 =?utf-8?B?bXBPRGd1T3ljYk95czdBSWo3L0R2VDJndk9XUVZJUHo4dHd2LzZYZStvbGlO?=
 =?utf-8?B?bWl5bVU4d0dmZ0N2MmU2UklYdmx6YWExRG9TOHdNa1ZncXJqSUlQRW1QVnpR?=
 =?utf-8?B?Ui9POHlUbzJZUjRyRUxXdGdEVHY4SWtNWE5ZeGlpV1kvaDc3aUN2YXg1ZlNZ?=
 =?utf-8?B?aTZuaXluSHNpS3RJWkZrMWg2TlJiMWl4dW5wL0dJeE5VUDIvaGlHTDZqQnBy?=
 =?utf-8?B?dWQzLzRXbUxKaEhlTVBsbmxTM2Y3dVNhQllFL3JCMlFhNERFRFBDdTJDYWFn?=
 =?utf-8?B?WEZrcUN5bHUwYTQvNi91ZFJMMGFPMGVQNXUzSHlMWnhvbm1UTElIQk9zQ0w2?=
 =?utf-8?B?R0lKeTBLeHliUy9YQnd5MlUyK2c2VHhyQVA1d0NtNlRjcWRtTEJIckh4UU92?=
 =?utf-8?B?M1dHR3NFdUttYWtaV0dBSjhRNlNWb1ViOGxDRXRGeHVYN2hNYVIzYjRIMlVK?=
 =?utf-8?B?eVhSeld5K3pic3ArUXdlUWM0TzIvdjBRUW5yVFh5UnhDSFM3b1JqelpXZHQ1?=
 =?utf-8?B?aWtQMTh4VE5XcHFROXhldlRlVkNSUTd2ZjF1WmxQSFgvckZ0dmsvNkd6b3hp?=
 =?utf-8?B?cW80eHZXUmsyTU9lL01OY0I3UnpMemZ3T1J4UXFQaHlSbFF2MnppMk5BdHVM?=
 =?utf-8?Q?4n9eMRF2k2IH4gB8=3D?=
X-Exchange-RoutingPolicyChecked: luex/xzPDMIfLmxVBftjhgat1H1v609JLhxS5gkKeQ/+GT9LPVbuMdFoaOmv3bqGOP5o9NDLzraQgbOOMvd5lpmrolnJZ8u6pUU6NzzhMTnv86F4V4w/knW+XwJYfQBS/bFaF/q3GMNmDDUbcreyUHKChiyFby2nDepKgC7jtA9YL0YTv4go70AQXIiVZm5FlcBHzGc3FJSUxJo7WAz10Kk6Yz6FbdDTgm78ty1hnVBd53KalDo7uU3PONN1+78G7uVJn4cyBQ2IlARASuNBj/Dw7NTIpQma6OAMz0iyHzUlOZDMA6V2K0SBTeCN62LUdKC3cvKT7Hi/euYcvq28ZA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 9516044a-f89e-4922-5b97-08deabb8c412
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2026 21:45:18.7136
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4bGVpZCsAikxpeS75GO9ZfpSe5NPQKJufUcRpe8CDjPO/87sIG85r5B9LZSpYmhFHBXJEDEDdO+Q8dRRr72I9+ddPbUSX/ABaN+dkYLZpgQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7708
X-OriginatorOrg: intel.com

Hi Tony,

On 5/6/26 12:48 PM, Luck, Tony wrote:
> On Wed, May 06, 2026 at 11:24:30AM -0700, Reinette Chatre wrote:
> 
> ... trimmed discussion on how we got here ...
> 
>> schedule_delayed_work_on() will schedule the work but will do so on CPU going
>> offline. Does not seem as though schedule_delayed_work_on() should be used at all
>> if the worker is currently running. As an alternative, when it finds that it cannot
>> cancel the work resctrl can avoid attempting to reschedule the work and instead just
>> set rdt_l3_mon_domain::mbm_work_cpu to nr_cpu_ids to signal that this domain needs a
>> worker to be scheduled and that to be done by the exiting work.
>>
>> Combining the previous ideas with the results from experiments I think the following
>> may address the problem for MBM overflow handler, not expanded to include limbo handler
>> and untested:
> 
> Initial testing seems good. I added a big mdelay() in mbm_handle_overflow() 
> before cpus_read_lock() to make it easy to hit the case where cancel_delayed_work()
> fails. Tested both the "still have remaining CPUs in the domain" and "this is 
> last cpu" case for both success and fail of cancel_delayed_work().

Thank you very much for the testing.

> 
> It looks to me that resctrl_offline_cpu() handles this completely and
> the additional cancel_delayed_work() calls from resctrl_offline_mon_domain()
> aren't needed.
> 
> Do you agree that those can be deleted?

Good catch. I am not able to think of a scenario where this is still needed. The new
flow opens up some new scenarios, for example when the last *two* CPUs of a domain go
offline while the worker is blocked on cpus_read_lock() and worker not getting opportunity
to transition. Even then, when the MBM overflow handling code in resctrl_offline_cpu()
is totally skipped for one CPU the cancel_delayed_work() in resctrl_offline_mon_domain()
seems unnecessary to me. 

Could you perhaps ask the AI agent that assisted with original patch if it can find any
corner cases?

Unrelated to this question but may be worth a mention in the fix is that this work focuses
and fixes resctrl to not access freed memory from the worker self. To complement this it may
be worthwhile to highlight that it is safe for the work_struct self to be deleted while the
work is running (but blocked on cpus_read_lock()) based on the following comment from
kernel/workqueue.c:process_one_work():
"It is permissible to free the struct work_struct from inside the function that is called
from it ..."

> 
> I'll look at fixing the cqm_limbo path in the same style.

Thank you very much.

Reinette

