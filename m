Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9758831F9B9
	for <patches@lists.linux.dev>; Sun, 29 Mar 2026 12:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774786167; cv=fail; b=UtoC47Am3sTktmBz9v5YEOSZ5RYyDb+6K1a/7CyXTfyKfXMnLpgKMEdwuTfvKAOXf1UrSGM+i+RmaIqDGX28CPNLjhBHMl7brbBnPUwtZTUAkdIOW33h5A8I/3yzqbLsjTA0+IimZlHOY0mYImp03ZjMGKXfI3mZr4vPqTWV/ok=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774786167; c=relaxed/simple;
	bh=YZdjqGuPhNuSDf58E8S4MBelMgSQ+Su+yS8oFOVrP+k=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NXR8PfQhvMh6IQe/iN3azQDf+pcFCXA0oLvdyeLk7yYvYFrbyxImM56ic0EoOWu/uonJ7dZh8+clzyn+JdT63hQw5ij911LIzfXzzArvBZ9lPsJLm3ZcwXo7y+sFS50zfg/arGjypHCvF3TtXZ1vzLq85jphQsGmsSTBWQGpuRs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iZzO7DOI; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iZzO7DOI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774786166; x=1806322166;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YZdjqGuPhNuSDf58E8S4MBelMgSQ+Su+yS8oFOVrP+k=;
  b=iZzO7DOIUjgR4JQF+8x+aVzTzHzmMGkN+MnngyopZ4na5DEiGkGLJrFv
   l3eVwrh27ZGO5cfByVWcAkrjRuLrV5BkENBl2Ey1HIzlbwD2hxKVe5j48
   QRFct/joQLBR66NXO/I2HWRZQ0GA+hqz7KBkjgPAY1WkHdb4orGzc0bfr
   rrraHBoV0tBrSYRs/Rodt4pqGxfflG+uLJOrxBOaNhgQtKN/en5Doehnd
   3qFc4rPtawcvfOA4+p7zNWUOaLDtDgwrxALzgzw5+pUjmYtc7TTaUp//Z
   d/lqxN/tbn+eHKDusrUCzt8LNHzmmpLD45n8tkaKgCh2fm39h1ezMp9g2
   w==;
X-CSE-ConnectionGUID: omYjNMbBR0WIx3W0q/XzKw==
X-CSE-MsgGUID: qhn5M0+CSXyA6hB/6tAWYA==
X-IronPort-AV: E=McAfee;i="6800,10657,11742"; a="86873272"
X-IronPort-AV: E=Sophos;i="6.23,148,1770624000"; 
   d="scan'208";a="86873272"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2026 05:09:25 -0700
X-CSE-ConnectionGUID: HOzhwXYTTyO1XMOZ2smaEw==
X-CSE-MsgGUID: pR3Mq254Tv+ciHEpBhxc4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,148,1770624000"; 
   d="scan'208";a="219156526"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2026 05:09:24 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Sun, 29 Mar 2026 05:09:23 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Sun, 29 Mar 2026 05:09:23 -0700
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.19) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Sun, 29 Mar 2026 05:09:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q8Hxy8rm8i+VA35vVJ9FeBscWm/gFGDJ8v0Ao7fUg2IOihJLO13smJf7WE9ZKjiWW3wJF+YCajxHuw38jpUSyzcyR+smtZTKrnEsXnb+hMDH7uEx0NWi7QjVtAqpVSS1i29U4OUBJCYUYDYUQRMBbWPb1MgT6MJWfD6HI5QfMA36mX975LP06p4ZqYPuLXjrcgaHXJgy/KOQmDZEjNDfGMF4UH6QaT6EVj+iYYSIDKQlx6kADYxtsgHnjsaI8UMijeNWjMsgG7vDXlkpVH9dpWHFxin6gRPBnijInv8SkqCEqNWA8HUfwdEDL74GgQOpsuXJhsNCd/rYcROIKCPMig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+KTrvlQHMoslAM3j5IlxAa4mnYptlpLjdZpSG7CVXbc=;
 b=GOxFU36J+CFZqOx95IzYmSrF8KnjXyMxZmO76JnJx6Pq5hyDKFx8LM0LgCZiYFL/05OEqJELrXHs+pRUR546Jxk2oNsIIDHZoePOR46MWe/e85z0mx/Tvtnk3yjT3nvtddTZA5SZ4iAprv/WVskBu9aTtIcaCuqlByqhJ7czm3AZyA9kRdM+xYvIJxlMvBoXoQNltZA0DQH8+FK7LE6+AB93L+fLJjC+4O1MfILbaVWRrdSWG/s6VqA4Cqm1IuVTXdH2NnPVbgJNBPMV5w2luh0XJo0b4mRlRcZXU+zdp6Vle1M3QUbH8RtBh730wO1MUucckPgfoeSo+F8w7ppe0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6020.namprd11.prod.outlook.com (2603:10b6:8:61::19) by
 PH0PR11MB5207.namprd11.prod.outlook.com (2603:10b6:510:32::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.14; Sun, 29 Mar 2026 12:09:16 +0000
Received: from DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::3058:1480:e4ac:5765]) by DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::3058:1480:e4ac:5765%6]) with mapi id 15.20.9769.014; Sun, 29 Mar 2026
 12:09:16 +0000
Message-ID: <7323f542-8e97-40f4-bb32-728d79b48025@intel.com>
Date: Sun, 29 Mar 2026 20:09:05 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/7] fs,x86/resctrl: Add architecture hooks for every
 mount/unmount
To: Tony Luck <tony.luck@intel.com>
CC: <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>, Fenghua Yu
	<fenghuay@nvidia.com>, James Morse <james.morse@arm.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Reinette Chatre
	<reinette.chatre@intel.com>, Babu Moger <babu.moger@amd.com>, Peter Newman
	<peternewman@google.com>, Dave Martin <Dave.Martin@arm.com>, Drew Fustini
	<dfustini@baylibre.com>, David E Box <david.e.box@intel.com>,
	<x86@kernel.org>
References: <20260323163452.25044-1-tony.luck@intel.com>
 <20260327230208.18094-1-tony.luck@intel.com>
 <20260327230208.18094-4-tony.luck@intel.com>
Content-Language: en-US
From: "Chen, Yu C" <yu.c.chen@intel.com>
In-Reply-To: <20260327230208.18094-4-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: KL1PR01CA0024.apcprd01.prod.exchangelabs.com
 (2603:1096:820::36) To DM4PR11MB6020.namprd11.prod.outlook.com
 (2603:10b6:8:61::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6020:EE_|PH0PR11MB5207:EE_
X-MS-Office365-Filtering-Correlation-Id: 91839d97-c8b7-4121-f287-08de8d8bffb3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info: uK5xIEDcJyCCJaYf9yCYMQ6B+DVTxvRbVQJce0cwQsndHdIDTTZCkNg8DLRkw0UO18RqmA1r6rufvlZEvJMaC93BsH2MR0WHzpccCF5/5D6iZggYuQVoqlVbM+aHzi7hu0g5+HNlx57NHGFXwmafbYqxmacWVvCSrjNVOafhW8GleMc22tHeyMGhOfA5NI//WOghKOmnoKk49YOhm4rc2Fsw81lW5+gfF9zVdfjAvPQqMUWWq64lbcT0IL6/8R3Ew2atKAyPmAbQQ7O/GJG+0S9SidJm59NBjOLuO4i+PNULzT2UGwX2YtjY6Dj9si/vHDx1eCJYM6YSMOzmAIbB9DJ5IcUIFMV/k12+boMXX3a9JyhBz18GBYKwoS1l4Y7vxKwfXHFXMVFiXQWGz1bOaXnNieeJAEFSsHxsRW1xHVWWnbNMW7IbAfiUOAmj1dvo/DaE4dDoM0+i+QMo7WlRyHTn2woK/r3R6xgogeTdb5suS/P+5sABUH3K1iw8B4ZA4knu4MXlPYsG1MEtxxuIRbQi/qSkdmYWe6QbvM+jtv+v3FUVvtvM51glYhjVqjD3Cp+VVin4CRezYCw21+xDHvx0OCLyEvklnvc0CEiHn9ZxeFpa3iEC77f9NaZjNCaErEjH7GbGqQ6agpDsRHoaqn3L4iqlGPS6SCRHpEyzmkZkLveUiineU9Iq39eDE74p3pLV+EUA6tKNcfilKPbdUiX0jE9ArK8EvOYN0e07u1k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6020.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?djlBaGk5WUdjdjkvTmpmTHljV2VzUi80Q2FodWdKV2c3SXljc0ZncnI5RmNy?=
 =?utf-8?B?MTZJSnlCa2JXQXRlYWcrT3RlMS9Dd2F0V2lWQURVMkV4T05oanlsUjk5RkFU?=
 =?utf-8?B?bHVoUGVnTnQwc1A5d1UyeStBaVZjbzNiaW5oZldTR21VZFBNY2w3SzZYZUg3?=
 =?utf-8?B?cnZZUTArOEVmY3J4VHJNVGRSNUpCMlF1ampTMzRRd1J3bnFsVmU3SmNaVDly?=
 =?utf-8?B?NWlsNFRKM3VJUTkvTGtPYy9NU1NGNzA0SHpQek16V3dhblpHR1k2b0JyM1c5?=
 =?utf-8?B?QTc5bXZzdFZSdWlXQjRiMFMwSStMMndSNVBPTVprU2RvSWErV0tsSVpmZnAz?=
 =?utf-8?B?QkJMbmxYNGljTTM1WEV4V2pPY01xN094dW9SVVNrVDlMTkJjM1AzREFBUE1y?=
 =?utf-8?B?ekFuZFp0YVFXMWJwKzIwTTVMZlMva1pFY2tuQ3RISWQzcjFUdmt3M1gvNDFS?=
 =?utf-8?B?TUh1M0FOUWoraytheXNnZ0p1UWU5b1J4STR5Ulg3OVlaUDN3Tm9ISUljb21l?=
 =?utf-8?B?RVFnNGxPUkdKUWhhN05JMWI4OGkyTll4d0haVTNhVGcxM0pKa0l3c2hRVGF2?=
 =?utf-8?B?Q0RjeFVCSExETC9NMmVzMnhTbVk5YnJQTnJtbDF6L091andRc0dLUVdsaDZY?=
 =?utf-8?B?YmxRa0FTMktsRjNUZ1FLMUozK2tlSXNZczJsOXdYN3BHYnhqbjZFY1JnN2VG?=
 =?utf-8?B?bXFwbmUzZUFvaXVLZVBmRzhnZ0J4UHZKNGxXSHlMUndVU3loUStRVTRYN3Yw?=
 =?utf-8?B?UktEL0hkdS8yREdNemFLQlNTQk8rdURRWmdtYXZxTkkrckNCZnMrTmtWZGhK?=
 =?utf-8?B?Q2ZIWSt2Ny8rSm1PSWszY2JLTEErZU1pM0FCazhTbUtGK2Y1Q0xtdXNtd2NN?=
 =?utf-8?B?ZXB3QVZrVXRUZkhwaytrRXNra2c1LzQ0cGhpNUxLOFJJOCtMKzlEdm5xRlVT?=
 =?utf-8?B?dEEvUkZYZjNFaGw5NU9lWG5nTVNiK1ZtUGlSRE1BaTR0MVZxMHlWbUN2Mlhl?=
 =?utf-8?B?Y1IxOExQWmRoNVdtNE1CMDIrUkU0OW1DN0piZ292Y255SG82T2R2V3JYRHdq?=
 =?utf-8?B?RnlzMGg5aDk3SGRsZHA0MUFqV3BzaXBiZGRsdUVZZ3hRNDk1Ym8wS1BBYVpD?=
 =?utf-8?B?VE1MSUVzakJlcVZ4eXRZQUFrTG1zNjZXY3lVaGRtcWdJTFk0Mk5vNFdkN1J0?=
 =?utf-8?B?MlB2TFFHQ09UVGdJRXROT3dTWjU1Y1QxRGNQNjBkVklTcFZoclZYWm1Nd205?=
 =?utf-8?B?MXdibFBYMnV0WFhWSTVzcy80QWF1VVl6QndsSXVsNE1WbFVGb2l1cEkxaWQ3?=
 =?utf-8?B?czJCbm04dXZZQXhXVy9TQmMzN211ZHNOVkhpRG4wQjc0d0RsbHgzc0VrQ1hJ?=
 =?utf-8?B?YXFCS3M2K3Nxa2FXYjVDWXFhOExtMjRpQU0wdTJrQ1NvOC9zOWZHY29mVnU2?=
 =?utf-8?B?ajNMOWhBdWd6RHZsck9wTmt3cGp6ckVCRS9zZldTTVlWSmloTjd1VEREQi83?=
 =?utf-8?B?eGwrQ01mVktld1BzK1d3Z3gyRW16WFQ2ZDh5VHkyeWZBdG1jck9GMzRHWnNW?=
 =?utf-8?B?aXhodi9QK2RsdUQ4OXJsZ1FJYTNGL2VMeE10SjdMZ2M2SkdQYlptSUVDNjI1?=
 =?utf-8?B?My9ROXpES0JXUzlhelI1ajRZR1cwajRDY2dLeEV4d3NNSDhDMFBnT1ZSMkc0?=
 =?utf-8?B?ekhFR1NCRGZGanV3WFlINXEvWkNjZjNQSE5POTVjdUNTcVhqajBGZVRTOXZp?=
 =?utf-8?B?Q0VZekk4QUpueXNqcTZuMG1JVWRGWGI0eHVaeWpTOXJNK3lSNlZGQU5kZytV?=
 =?utf-8?B?dDR1eXRYYU1IUHVUelFTT3VnQ1dKcXIrUXNCVENCVUNNbytHNENaRFhLcDNQ?=
 =?utf-8?B?TzdsdUMrYjhuU0RoMU93NXhoNk5kWU9WM094WUVXS2VpdWdXLzZhMkJNUUF0?=
 =?utf-8?B?S1VEY09McXlidTFhbTAwZ1A1T25qOFFPbHdIYXpURms5TXIxMVdHalRzTjFN?=
 =?utf-8?B?NmFpMEdNRE9mTlQrKzI3REN1WSs1RFByOGFVN2pKM0FiSWQ0Unk4am51VG1Y?=
 =?utf-8?B?SDVPUTBtbEF6cGd3YU9icUEyelBpSmJWSG5CS05SeUxxbVBwM3ZWTHUyQ1pq?=
 =?utf-8?B?U1B6TG1WTVhkeGZ5ZnhsT3M0V2x0T09EUG1pbEJ0SStOMm9IWEd0eUpES1RO?=
 =?utf-8?B?SHcvbkdMMDg3cmtSOHBQU2JXNnpsRU9teit1UWJkUUNDbFRMeURBbm1WWW5U?=
 =?utf-8?B?UEttMTgwb2Z0SFhBc0RzQkxFOEZDRHVLQWJablFVOURTZ1QzMHdvT04wZ1hK?=
 =?utf-8?B?aXE5emJSSFJTUUpSSU5ScFpZSjVKY2pMMTBtbUJQbUtqZjRaREZpQT09?=
X-Exchange-RoutingPolicyChecked: pe+9Lq3lNaOaCyAlDNDjMWDsGvrIu/pETsIieBacwz+L1EmpozX8IUW0nY99lNBNXWSWA0W5xqCE+85yYx4+U+kKroRhAs8GZKzeDLWOKt1oeCGX8XDNO5tny951gonz/B1cfsBOPWoN4IgdcuXDd0zXtBovIpAxT6YbXq/4nmfQbWnOIGLzHdd7eC7c4WOU1e4PJtPEvu+hV4e0+HdSsSfflR/6luBG3fT+imkNUYR38u40s4Q4W4pfhtVKuE8D0sDC18OAz5jg7lvF4KvP79Wh3aWG6y0OrHXcASyxgQVfDnGx0mMlvFz7HqJHvHx7k6gK1WrWrzotIvPUn2lPhQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 91839d97-c8b7-4121-f287-08de8d8bffb3
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6020.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2026 12:09:16.4396
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YdhWfDUIWBucj1VicKtT6AXHhyABEq/eSGCbYUmMyeBk/+6GF0LdJUV6e3gsdSERarD2l7auB6LX4uoUd/KNpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5207
X-OriginatorOrg: intel.com

Hi Tony,

On 3/28/2026 7:02 AM, Tony Luck wrote:

> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> index e3cfa0c10e92..6f322818a9e6 100644
> --- a/arch/x86/kernel/cpu/resctrl/internal.h
> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> @@ -234,14 +234,18 @@ void rdt_domain_reconfigure_cdp(struct rdt_resource *r);
>   void resctrl_arch_mbm_cntr_assign_set_one(struct rdt_resource *r);
>   
>   #ifdef CONFIG_X86_CPU_RESCTRL_INTEL_AET
> -bool intel_aet_get_events(void);
> +bool intel_aet_pre_mount(void);
> +void intel_aet_mount_result(int ret);
> +void intel_aet_unmount(void);
>   void __exit intel_aet_exit(void);
>   int intel_aet_read_event(int domid, u32 rmid, void *arch_priv, u64 *val);
>   void intel_aet_mon_domain_setup(int cpu, int id, struct rdt_resource *r,
>   				struct list_head *add_pos);
>   bool intel_handle_aet_option(bool force_off, char *tok);
>   #else
> -static inline bool intel_aet_get_events(void) { return false; }

The declaration of intel_aet_get_events() was removed,
and the function definition still remains in intel_aet.c.
Not sure if this will trigger a warning like
"no user for intel_aet_get_events". Since intel_aet_get_events() is
renamed to static get_events() in a subsequent patch,
perhaps we can mark intel_aet_get_events() as static in
this patch too?

thanks,
Chenyu


