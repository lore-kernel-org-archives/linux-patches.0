Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73982362133
	for <patches@lists.linux.dev>; Tue, 14 Jul 2026 17:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784051419; cv=fail; b=tiUXdgSBHvIG6hVRYK42+uu/9uXSgmng12frmj2MQyeDw8kgV690tob3MwR2zlcZeDA3zgU0kIRT6c0XeGRYm0AB4r1wGSR3lJlPyvX42014xKDykT0Uryhg/FBm29kC1SVWaM1KYZfZNv6JFa24wwQvthIVzNONoSklks6abno=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784051419; c=relaxed/simple;
	bh=3a/U7Vf7W/IbKnimlcMkDL5WuE65AVVQ0J8II1WBooU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ng1mtpITF5BroPW8EFaHwuKcBhMiFXbUVdv3Z/KyD6LIm/r7oMX51DkJJAsBL6FojlNa56HwQFLtcs+I5/x69+mte7Erb2w1XsLYKvIKs9NLdB/XvKZz3TRNFF6//FRD1AphTSjnBG9IW48dA76E30csuif0dhRXBWZ/ZMYZ02w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C24+x0/W; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C24+x0/W"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784051409; x=1815587409;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3a/U7Vf7W/IbKnimlcMkDL5WuE65AVVQ0J8II1WBooU=;
  b=C24+x0/WFCokr7jwyVYnEMUM8MHuDbD9qD1qMef6uH5JcNRLMv30Pzdp
   LNlTnG9jKSkzA2qMzXPFMeUCS4kbUVs6qs+9S3Vw6sfjZKeDUR07skL00
   kwPwYfVc8pJok2kpz89ZPaDeFw2O3lDTYZhyEtfF/F/WtpDZRjVp1icjj
   W1J30zXp7vHD9bi7xRkDgwUiOEO1sDkfNBOYkVBLg27iOW/HWjfj7bUVy
   GS9KhEJYYQAlKTpnD6FLh0SuxqOR7SNUj7XwPR19808iwJ0804CmaRt1N
   f8wWeEC9/ukFrdm7G6xR2aUYLw7kq8zpwTYF2Qpq/XYxAFYQf2DejzUdW
   A==;
X-CSE-ConnectionGUID: ruLLJpwKR5CHIxMEEy1pfg==
X-CSE-MsgGUID: HUhsfC1pQCON6n9KH7aObw==
X-IronPort-AV: E=McAfee;i="6800,10657,11847"; a="84878186"
X-IronPort-AV: E=Sophos;i="6.25,164,1779174000"; 
   d="scan'208";a="84878186"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 10:50:01 -0700
X-CSE-ConnectionGUID: Lo+EZs4nT3SRisG8hUTeyg==
X-CSE-MsgGUID: 7GG0t+ilTl2SUL7k1qaDXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,164,1779174000"; 
   d="scan'208";a="279210408"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 10:50:00 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 14 Jul 2026 10:50:00 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Tue, 14 Jul 2026 10:50:00 -0700
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.49) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 14 Jul 2026 10:50:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=igoNhghcd98Y07Uf6BPAYZ89lKgGEeuvI5sLw2F5kHptEeIBZc/4uVnPDa1u+kXKVsnJl+2CrBE2Zb+Gn3RYHikTrtoS1o0bMdjkBhAvOTYy22uhW7SobW0n3qQpcURr+x32v1XpGaZaeuyST9g3k4QkoStNxaTplbDEIG+WmME/iVQDu4RfUJLoChrKXeopkdorEZzSImGcwfrsW9ffFBkfNepHvNwcwy3b3HX268LQ189or2naLRyvHVI6eAXgQIiT4WZW42RZeQpLB07Z807IlzVJGSxoWCOwLpZKx+V7qGyL/5LXin7fR7dpNjwgaPaWU9qNpNTW5sOaFByyTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=58TTmvdW7tkLRNLpdJzfFs5C68nxke7RPFKnsC/mlhw=;
 b=QjZbrYKOGaB6yVT4hWbrARFnO6UETslQScOkU+24WFu5X1kSZdQn3V2k+dimmCEV8oPVQTXscja1GtzFgIHMYZT9bwFzj5+1gJ0xLtEFtgCgpWwCz0GQfjnWQ+zbMu42FkFHoE3YIvYND3GIMUBndnE6Syo+ZqMVPQij9DuR3ZtUE3mPb85xfoKIa8qdLlEm8dgcfVNd1kUy8QyLquraDmwKnmCqD4yjiHZ479T0V4PvFxCHtxEfIxv1Dsv5rJAFzDEcEfJZgtjHmei9z1NtT/l0SYuM+aga7BfDVkSI0dhhaAj1v/LK3C7909K0TbfOFwWvkiGLyZD40dgyWKpopQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by PH7PR11MB6698.namprd11.prod.outlook.com (2603:10b6:510:1ac::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.202.20; Tue, 14 Jul
 2026 17:49:55 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0202.014; Tue, 14 Jul 2026
 17:49:55 +0000
Message-ID: <9d657f1e-7329-40fd-bda2-9ea0735947fc@intel.com>
Date: Tue, 14 Jul 2026 10:49:52 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 00/10] x86,fs/resctrl: Improve resctrl quality and
 consistency
To: <tony.luck@intel.com>, <james.morse@arm.com>, <Dave.Martin@arm.com>,
	<babu.moger@amd.com>, <bp@alien8.de>, <tglx@linutronix.de>,
	<dave.hansen@linux.intel.com>
CC: <x86@kernel.org>, <hpa@zytor.com>, <ben.horgan@arm.com>,
	<fustini@kernel.org>, <fenghuay@nvidia.com>, <peternewman@google.com>,
	<yu.c.chen@intel.com>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <cover.1782857711.git.reinette.chatre@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <cover.1782857711.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0181.namprd04.prod.outlook.com
 (2603:10b6:303:86::6) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|PH7PR11MB6698:EE_
X-MS-Office365-Filtering-Correlation-Id: 552a4fd1-b31d-4b01-ff68-08dee1d05054
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|23010399003|6133799003|3023799007|18002099003|11063799006|56012099006|22082099003|13003099007;
X-Microsoft-Antispam-Message-Info: mYKMOJJh414I9lX9yeXCY3kfeBCYKvo2VV0vEgTscH+e63wGyJdBiPW6cDpqnOR3kqjtZY1sqOHn0g4ykfbFvJW54spgISybmWl5mvY5WL9QkkcubdHWne+HV3A0NH/NwTiMGy1VB5TGRG7IA+APnuXWAIDk+RiuKBo035Vk3qoHNcP1OucEc8jVSujeWGBAo8oFBrB/sgCrUV3a+TVY2eIC5usZV19lo6s35BfGbcgIDzn4jpQv8stsBnSdfXDHT2yjCwzuWnTjfMC+HfRREUg1bKP1qN0hWgEg3S6sfMxmNwibwT3mSRiPFjvC9JJzWvz6OfOt/Om8G2hMrYaX3TMDp82kiHjzjlmqmui4F6L1VW1yuFbw73bAmJETdQfnJz2dzq5arh4E5kaAFMS0IcIU7R9QzKtby1Ecb5FDpenBwruwRqsyv/CdbcfOLZ7/Q7hNWZfeVMa1k6cgi5bzXRASq9Xejgn4MlxrATwV5oFkHZ0isqOUhrclbfuCqdWihiWiqeRN53wdp2z5IT/EYTnLjHRzYWLwakypaw9boXyUhAjjLZYVfg5MBiBXsjNQ4SCRIrQw25GoAoA3LjduqRm0vjYRttBnfK5nCGAb+l/+LugEdIWGpbDAFRUv2Nsw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(23010399003)(6133799003)(3023799007)(18002099003)(11063799006)(56012099006)(22082099003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NWE1V3VYcUIvQ1U3YWxCMU56bUNHbzIwM2dZdm1hSEh4RVpZT2FlbS85NjFp?=
 =?utf-8?B?MlkveGJnemVFd1krSkE1b3l0WVFKL1hsUWVmbzhtcktqdjJpWG85Q1huRXNC?=
 =?utf-8?B?enBEa2tUaTZpMHhlSlZFUEJkalJvempNV1UxV01CbTZFdVlVZFU5OW5WdXRr?=
 =?utf-8?B?bFphZlB6YWQ1RThyNHRWUUIxMS9lSVlNei9ZUURncWpRSjNTYkN1MGdCdEl1?=
 =?utf-8?B?Mk5CZ3BZZ05uYUZ0MXdGdHo5Q1oyRVlZRmQ1a091VUFYYzJaL28zYlNwWWxn?=
 =?utf-8?B?dkwxeUk1bi8zVmE2T2dON3g1bjhPMVZEbTlHQ1VTS3lVVmVhZGVYMDNRVTBi?=
 =?utf-8?B?UnBROGYzb1BjNWdwQzFJUFNCd2Q2M1M4Z1poSjlBeU5aYTYrOEFkTDdGL2p4?=
 =?utf-8?B?cEIvRDBmZDhheHRRaU8wWHQvSGY2V0IvTjNJT2c3R0xaTS9TZFhzTDEvNnRF?=
 =?utf-8?B?MS9NRTEyOHhmb0cvd0tnbFVHcEgxTmo5WkY2eFNSNklWMzd3eDlLb3BKQlE0?=
 =?utf-8?B?enN3bldoaTFodk5ZRXFMR3kyd2hMaHJaS0hwOG1XWFJhd2trOFo4WFdsenpC?=
 =?utf-8?B?NTNxWmsraWpBTUpIUXF0SWtpVVVqK3JQNVgzUWtNdEpqSTM4MjJvTktpK2t1?=
 =?utf-8?B?aFNuRkRuNjdoOG9NdHRJeWZ0U3Z5ejdpZTJVQjNLT3UzT2xzVk1rVEhSK09X?=
 =?utf-8?B?KzYzNlNCMEF3RnlTaXVUZ2orMWhFc2VaN1doY3ZrcTBOalFlWnNYdEJIQ1dj?=
 =?utf-8?B?VkFXNExobjRmdGk4Sy94TkIxSGlRSHdlYVdhOTlOUndLYmdqUVFQbHFiUW9V?=
 =?utf-8?B?RHlySVZ6Rmg3SEhkL2p4Q0tOMHB4T0NKRGxsRHlwSDFHVVQvTGxzK3FYQk02?=
 =?utf-8?B?MWNUYU9XajZtbm1XajdwOVBwUExtQjU3VnJXMnFnQis2aXUxNkRvZk5oVzBB?=
 =?utf-8?B?VExjUkI3bGp1Q3NYUXVmOWV1R0graUl1QTRZd2xQY2lVWkRFQ0JNaUwwRU9l?=
 =?utf-8?B?TDM3NWJ2QmRUdTF0K2gwSGdlUTFpVHNFMDB2dWRVdkFjMWNtbzZsVyt3Z3d5?=
 =?utf-8?B?RFNaRk5odVpBQmdvQVBweXY5SmdITUJrbG9adlNPNGp4SWtPdDdWSDViSzY2?=
 =?utf-8?B?QnVFZEp4SGZCYzZBSHdzNVg1NHI0d0VlUWlrT2tPbzV6SmhvUnpIVCtwR2sv?=
 =?utf-8?B?SDZybm84azNFNFVMVFplNGo0aHFzREl1RGpvVXI2MVJLRGV6OVdadW0ya0J0?=
 =?utf-8?B?dy9NMzluTHh3b1p3Mk8yRFFDbjBsaWZaeDhBcnFTcnl3TVF3TUdNRmpDVTR4?=
 =?utf-8?B?VVFsSG5CZXkrTkRDdHVuckhHcHg3TCtoN2dPZlNIdTgrSS9Xb3JoWUFHcEdw?=
 =?utf-8?B?RzVLbm1tQ3hIbUc2bVNJbUpZRHlSaWVOMUQwdFR3Ulp5dnhac2RoQnNZOEhn?=
 =?utf-8?B?d1BGKy9wY1cxckVQb3FZbnhOdnZMdVBjb3F0SzdOVWd2VzVrSGNnTjBha29X?=
 =?utf-8?B?cXIzRWMvZkUyZnUxWHUxZmRSOVFZUEg4b0JiemNXa3QvUitFZ2c1b3cwSXht?=
 =?utf-8?B?MzhqQU0xMXljZmZXK1V0ckp0ak8vTktlemJ0QXpXT0t3WkNJUG1MK2ZNZ3Ur?=
 =?utf-8?B?a3B3NmcwNUxTaStMNG51TmREUFU4RmxtOVdxM3RsNG52dkZIci92S0hEakdy?=
 =?utf-8?B?MVFaWDdPYmlMbEFpTTdhRVBwRHE2ODRRTG5Pc1I5OUpKMW9tUnZ5OXpReUtB?=
 =?utf-8?B?NW1Ya0ZmK2FzTTlmNTU2RG1XWFBGQkpPcm12T0pYTEQwcmRMYTlpcEpqODQw?=
 =?utf-8?B?bUdHUFJJbzNiZFJLYU5kNHNzbTJYK1hnYllEYmlhazNZUEwrWldzQ3ZjbGx0?=
 =?utf-8?B?c1ZndXhoc0pOdEpFTUgxUTk1czhhR3A5Ny9SMWxMZVpQY1pkY1RFNC91MFhz?=
 =?utf-8?B?UlpjdHVJVytxMmtkVHhCaWUzMDVCazR3bGh3SDdqdGxIN3VVQzMzWVZKYWkx?=
 =?utf-8?B?ajBkZXlCZXliV2paMGhwU0VyQTlUZk1DdGdpbFc1WGFUdy9RcXhvQ3JMbDlC?=
 =?utf-8?B?TmRERTFKakptU05kV2tvaXR6Q0lWcklUcFdmMTJPSWpMTUx6SGVJMVB0NkFm?=
 =?utf-8?B?TDhvR0piSEdDQzRmbGZSWkJaUFU0d3d0cFVJR0hGVDRvTVNuUHQ4SVlCUlpV?=
 =?utf-8?B?Z2lXNWtxYVVOZlpMbENSVFY2Ym5SamRLdWlVUktZem1kWnp1UmNoM0xuQitt?=
 =?utf-8?B?ZWlQc3htN1lJbGpucDdkWndYSVdFT2pQVzY2WThnaGV4UmVEcjVZM1k0UHUr?=
 =?utf-8?B?MTJDdEVERVpwenB0RVFyZmR5SEhKc1kxcGx2ZGYzQS9WbnZrTG85MFNCS0RE?=
 =?utf-8?Q?5xkrTBnlpZ59vFp8=3D?=
X-Exchange-RoutingPolicyChecked: VFypCUHKEq8FhGbobn2kwNp/BjTShdFRjl0mwwH7Y2uj0cpEybHAhwdalIAqoFROlaxIPiRwNJAGXXA/zaR8426lXNPDvuqMxbq/v8WUJvvHXHf7SAQF1vr6Dv69vt0RRgQH2B59re/ZfPOJYLwt1pe9Hi0ihdQ8hkccWXPLgjoy6MZ0WisUrQ20Q7sMwa44t9NoCkywWFQ+HjPa+2joeAeKoRGrQu//5Kh1slAhBMWNDMLcPJXIWdkVU2Cn4XfM+CYDTIyJgx0VBXKf5HQ7uQxCuzC/g/UjTcv6SBx2/PIz4fhNTvfb+jF3yBFlLdsVmw2mQauGsAsizAy24xK5mw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 552a4fd1-b31d-4b01-ff68-08dee1d05054
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2026 17:49:55.1623
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7daIfrOY9tdLVvAFaAmVljdKNERyI5Z6yFJskfNLWURPuQXbkIpSy43iZIz9dUCem0QyitQwAEZTG+HWBGakD2dDObIAKQlmLg8H/F33sYU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6698
X-OriginatorOrg: intel.com

Dear x86 maintainers,

Could you please consider this series for inclusion? It applies cleanly on top
of x86/cache with HEAD at
	 2566b5cd6a27 ("fs/resctrl: Fix UAF from worker threads when domains are removed")

There is another resctrl series ("x86,fs/resctrl,arm_mpam: Factor MBA parse-time conversion
to be per-arch") also ready for your consideration. There are no conflicts between it and
this series, they can be considered in any order.

Thank you very much.

Reinette

[1] https://lore.kernel.org/lkml/20260709093111.367851-1-ben.horgan@arm.com/

On 6/30/26 9:27 PM, Reinette Chatre wrote:
> Applies on top of v7.2-rc1 + v5 of "x86,fs/resctrl: Fix long-standing issues":
>   https://lore.kernel.org/lkml/cover.1781029125.git.reinette.chatre@intel.com/
> 
> Changes since v4:
> - v4: https://lore.kernel.org/lkml/cover.1777419024.git.reinette.chatre@intel.com/
> - Rebased on top of V5 "x86,fs/resctrl: Fix long-standing issues":
>   https://lore.kernel.org/lkml/cover.1781029125.git.reinette.chatre@intel.com/
>   A significant change in that series is the addition of
>   info_kn_lock()/info_kn_unlock() helpers to the info file handlers. With
>   the addition of locking to the max_threshold_occ_write() in that series
>   it seemed appropriate to re-order the last_cmd_status handling in
>   max_threshold_occ_write() to be after the change to last_cmd_status
>   custom to contain max_threshold_occ_write() changes to one patch.
> - Add resctrl filename to new error messages to disambiguate the various
>   "Invalid input" messages. (Tony)
> - Add Tony's Reviewed-by tag to all patches.
> 
> Changes since v3:
> - v3: https://lore.kernel.org/lkml/cover.1775576382.git.reinette.chatre@intel.com/
> - Rebased on v7.1-rc1.
> - Drop "MAINTAINERS: Update resctrl entry" and "fs/resctrl: Add missing return
>   value descriptions" that can be found in v7.1-rc1.
> - Drop "fs/resctrl: Avoid "may be used uninitialized" warning" that just does unnecessary
>   work to appease compiler warning that is disabled by default. (Boris)
> - Use pr_warn() instead of WARN_ON() in "x86/resctrl: Protect against bad
>   shift".
> 
> Changes since v2:
> - v2: https://lore.kernel.org/lkml/cover.1774043709.git.reinette.chatre@intel.com/
> - Rebased on top of tip/master with pending resctrl selftest changes,
>   https://lore.kernel.org/lkml/cover.1775266384.git.reinette.chatre@intel.com/,
>   applied on top to support testing with latest kernel that has pending resctrl
>   changes merged.
> - Drop "fs/resctrl: Use stricter checks on input to cpus/cpus_list file"
>   that ended up being too strict and removed one use case. (Chris)
> - max_threshold_occ_write() switch to guard(). (Chenyu)
> - Add more detail to one return value description.
> - Add tags.
> - No opinions so far on needing to update last_cmd_status on success of all read
>   commands. At this time last_cmd_status will continue to return previous
>   failure message (if any) after a read command accessing static data succeeds.
> 
> Changes since v1:
> - v1: https://lore.kernel.org/lkml/cover.1772476561.git.reinette.chatre@intel.com/
> - To simplify tracking, include patch to MAINTAINERS submitted separately:
>   https://lore.kernel.org/lkml/4274c478922c01f9ceebc805acf991f10a95519f.1771442788.git.reinette.chatre@intel.com/
> - Follow recent upstream changes to add reference to tip tree handbook in
>   MAINTAINERS entry.
> - Use new pattern in resctrl to enable looping over all entries of an enum
>   while making adding new enum entries more clear all while avoiding warnings
>   when compiling with -Wswitch. (Ben)
> - Add another last_cmd_status enhancement that appends "[truncated]" to
>   output of info/last_cmd_status if the backing buffer overflowed.
> - Please see patch changelogs for details of changes.
> - Add tags.
> 
> Hi Everybody,
> 
> This is a collection of resctrl cleanups assembled together for convenience
> and simpler tracking. I'd be happy to split them up if it makes review and/or
> handling easier.
> 
> Summary of changes:
> 
> - Let resctrl pass stricter checks from various tools to provide a cleaner
>   baseline with the goal to promote healthier contributions:
>   - ./tools/docs/kernel-doc -Wall -v <files>
>   - Build with W=12
>   - ./scripts/coccicheck
>   - Static checkers
> 
> - Use accurate and consistent type for all uses of resource ID.
> 
> - In the unlikely scenario that resctrl picked a wrong CPU to read an event
>   from, pass the error through to user space instead of claiming to succeed
>   and returning a (wrong) result.
> 
> - Since inception of last_cmd_status feature there have been mismatches
>   between resctrl file operation failures and the contents of
>   info/last_cmd_status. This pattern keeps propagating with each new resctrl
>   feature. Establish a new baseline with a new pattern that ensures
>   info/last_cmd_status contains an accurate failure description that matches
>   the most recent resctrl file operation failure.
> 
> One potential open:
> 
> There remains an inconsistency between resctrl file operations that do/can
> _not_ fail and the contents of info/last_cmd_status. If a resctrl
> file operation fails and an informational error is printed to last_cmd_status
> then a subsequent reading of a resctrl file (specifically most of the files
> found in info/) may succeed while info/last_cmd_status may or may not return
> the error from previous failure.
> 
> Ensuring last_cmd_status is reset on every read carries the cost of taking
> rdtgroup_mutex on several more user space initiated paths and thus increase
> contention on rdtgroup_mutex. I opted to not make this change and instead
> focus this work on ensuring that last_cmd_status is accurate whenever there is
> a failure during any resctrl file operation. Please let me know if you have
> opinions in this regard.
> 
> Update v5: The addition of the info_kn_lock()/info_kn_unlock() helpers to
> info file handlers now means that rdtgroup_mutex is held every time an info
> file is opened. There is thus now less burden to reset last_cmd_status
> buffer on each info file access. Even so, since there has not been any
> opinions in this regard I opted to keep current behavior.
> 
> Any feedback is appreciated.
> 
> Regards,
> 
> Reinette
> 
> Reinette Chatre (10):
>   fs/resctrl: Use correct format specifier for printing error pointers
>   x86/resctrl: Protect against bad shift
>   fs/resctrl: Change pattern used to track number of entries in enum
>   fs/resctrl: Use accurate type for rdt_resource::rid
>   fs/resctrl: Pass error reading event through to user space
>   fs/resctrl: Use accurate and symmetric exit flows
>   fs/resctrl: Change last_cmd_status custom during input parsing
>   fs/resctrl: Add last_cmd_status support for writes to
>     max_threshold_occupancy
>   fs/resctrl: Communicate resource group deleted error via
>     last_cmd_status
>   fs/resctrl: Inform user space when status buffer overflowed
> 
>  arch/x86/kernel/cpu/resctrl/core.c |   6 +-
>  fs/resctrl/ctrlmondata.c           |  71 ++++++++++-------
>  fs/resctrl/monitor.c               |  78 ++++++++++--------
>  fs/resctrl/rdtgroup.c              | 123 +++++++++++++++++------------
>  include/linux/resctrl.h            |  11 +--
>  5 files changed, 173 insertions(+), 116 deletions(-)
> 

