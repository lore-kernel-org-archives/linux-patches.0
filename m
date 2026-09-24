Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D48242D88
	for <patches@lists.linux.dev>; Thu, 24 Sep 2026 15:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790263901; cv=fail; b=sjCuU07okYHkuSqTqKHFlev0+QIxe1mrsQc3uO3faKSMH8eJu8RH8AhwW6RW32BrUJkb3/6AUVcPxC/gBdv5rjNqz6QTbDxXboDhTc2Ons6oi4R622UgoV6eYmCy1l459DU/56P1TF4NWRJq8UZouPqV8jW5aYrQwgBMZuO8Lao=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790263901; c=relaxed/simple;
	bh=A8atnsyFinZxmNsuVqvltCNGzQEl/sXfIS3834opNVQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=TTFxTPggqtyynAXRXlKfvUfYIoNyh4bgcrQtuHcBw0chHtIko2uHuSOVU4YmaSN96v5Ak2+NbbzRmZVGuMAM5aqPxqF4shDAK+k0shbYWyeJPGkdE4G45tM1n+UVvhKc5n+TsY61ZFWeN3dTuZ9IIxD5BiJWzcCR8dW7z94+ip4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cON9fIKL; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cON9fIKL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790263900; x=1821799900;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=A8atnsyFinZxmNsuVqvltCNGzQEl/sXfIS3834opNVQ=;
  b=cON9fIKLhSJy52J5lOhIKf/qwoM3v1X9Se2J3/Ig0jj8wr8DKWQ3ky6W
   2vN5vxrmviQBJkC3OJbHIArZjzQOkluWTsKdqORPTcrkgqQZRlCcrvc/y
   mtzThLsvmP0dAQd+KMnyVdCHzrDFxRRn+xMqwfd9SblRMnsHLt249p6Ir
   V+ZIvP5EsMUknBqx9ZhLwL7kT7ft472SNwJW+IWOpTOuHpVZoDKEdZbrq
   DcLgdH+yFvHea7cSpsQdL7vN2AkfMquvkoRaLxTZ/l/AYhHJTcmPRtm6l
   w9++fHXifubUmZDDqfyq8sXrj7XF72CtTLi5i7KR+cIS55dFmTR04T2Mk
   A==;
X-CSE-ConnectionGUID: Cfbvz6hWQeO4quMi+2kH7Q==
X-CSE-MsgGUID: SajQcKsOSLW10Elc7+Jl7w==
X-IronPort-AV: E=McAfee;i="6800,10657,11915"; a="89901374"
X-IronPort-AV: E=Sophos;i="6.27,120,1787036400"; 
   d="scan'208";a="89901374"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 08:31:36 -0700
X-CSE-ConnectionGUID: kPGe3CszTh2RPY9U7orj+A==
X-CSE-MsgGUID: Gszg6yAYTeuzAxUfVti5ww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,120,1787036400"; 
   d="scan'208";a="272191848"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 08:31:36 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 24 Sep 2026 08:31:35 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Thu, 24 Sep 2026 08:31:35 -0700
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.33)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 24 Sep 2026 08:31:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O1uFl2TRyBavs9SLt9kwOHUxdfEblHqcw5SumlQKBWHNTJ2m7hp3onAsifTw7gL5R3XjZEUHsmElzeWabuQXMbOFiZ1Q6OckXSebF/dZ2918qS+FJBdUbzHXRq3pEGgGMXtE+EIxmHuv3qhmuY6t2HyzNxbr6pY5R55LVlAKzQ5IkBZayHPnN5FJMC3YX603S9GGi7nAFEkTGx1bogcrWD7v95R8YXSidZBHFe//vDWNMsWYmhtqBHZ508zgFEOjvmZ1wQK3l85yzS128/0rncxB1yI7bO0MPhLwvg3ES5c/NNoQlKt/m/sgCFUCwtDaRt0aWWuZ/vqcUT7ONQG/oQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kAF982knLg5SsDLae9LCGoGxNPCddWRmKZ68XeKwDXI=;
 b=ZJX/kt5dNTrpROyFeJYjxBx/OuuZEh8tbvUTp4tOBOiZ0yFN5eX5bYY+4mF4llRqGvQB0tZYl4YZWSt/2PpAcee5f0r31gyzewGzEffBFKCA9a4OSzome6pDe0/qKMzWzd+FrFc7MmEkvHHmvBqEnNhheZAwwYznprfn/7jnEI6tb8igwX6pfnI6jd09xib705aNVbXgUDgOjt1ovt8Q5FV7brBI4Hw/Zc39slAqOgklUoXID7eCTA+3otVG+i5l/DtYcwzqUZ0NIsRSWa0SsqCy6T5bMCfSBvZVVLrHbz0BkTLSX9qvgLo6sG37yZHMp/nuFHc9+L8HNswHDgdC7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by DM4PR11MB6018.namprd11.prod.outlook.com (2603:10b6:8:5e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Thu, 24 Sep
 2026 15:31:31 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0451.014; Thu, 24 Sep 2026
 15:31:31 +0000
Message-ID: <471955ab-25f8-4a32-9d0c-2f87ce350183@intel.com>
Date: Thu, 24 Sep 2026 08:31:29 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 11/25] fs/resctrl: Add interface to disable a monitor
 event
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260916231320.14502-1-tony.luck@intel.com>
 <20260916231320.14502-12-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20260916231320.14502-12-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0085.namprd04.prod.outlook.com
 (2603:10b6:303:6b::30) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|DM4PR11MB6018:EE_
X-MS-Office365-Filtering-Correlation-Id: 669781d2-e410-45df-77ce-08df1a50e8a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|366016|7416014|376014|1800799024|11063799006|56012099006|4143699003|22082099003|18002099003|10067099003|921020;
X-Microsoft-Antispam-Message-Info: 3AfhdXr/zOb7V28kC87a1gL2Oqc6eXs/ZZNla0uMCigcD6W0l7L3yajJe2zJoYbyaDZIfl2WxtuRmsrb1dd5Y6MsUep1CyPEMD5GU1Ofb3KKjwgdh7EWczHxB1I61MLpv0F05vpVhn/V7SUGF7bIDFtaEC3kGNirmrJ21Ce8mSI+hmnZzmGcRUQwRmyiHRVjvk0Pe2YPELRq9ELF5T63zh0+0pHa469LaiEPqX2YjZOKrqE+kg3XalEXVA/6NoKDpgIdsyB2mszj8O1s3tlU98I3yQ3dWP/R7W0qMdjFq2ME5b7eL5MoRsxB0w82uhM2SmFN5y1KIOALqHbF99WyBfLLH17RY2oTWioXbNw4zUQ6GtCpip+davioknfoMrkKRdrC1sSrTXTKVmR/h8Wzt5M8A5zt4dHZUDeGxtNz0rzBn9esyCRrjvbrFlGZzAp6QclOPicmwWvHEiDAppfjzQEkloholDbYLR+GSrPzOesKCvBrgKrCH++W0FV1oMUtGkTvOmlFJQgO9byArXFx3tEUrpxp6Ac1XJZQ4w7itAHlCG4+dhG3vSiThwlHF7fxTUl1B5MvO5gnqm/jvqVZ1dmvkITfEpr9ozFL6fCIT9Jk8rv7PI1FsMFOdK62Cl7nCpgPwmjkjAoJv9yUkvTW3IKOzskvfsMBaCFkzXTU7Be6HmP7X1K1SC2STNxNf61HJkEoQkVZnoPVJHQ8jHUk+w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(7416014)(376014)(1800799024)(11063799006)(56012099006)(4143699003)(22082099003)(18002099003)(10067099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c2dkREFJNWlHaUpVV2FWRjhwbUFlaTIzT0UrS0toT2VWUHlNN0dPN3VTQzdn?=
 =?utf-8?B?L3ZlbGJndGp2aTJEaTZtK0huMUVZeVpGWHFDZVBQdmRpeG9yOUJ4UENMdm9F?=
 =?utf-8?B?VWFiNkJPcGFDS1NEYndHZGRZcUZ1Vm9tdVVYTkZRRGcrUmM3emJXbzhlQWM0?=
 =?utf-8?B?Y1VRNEpYcytjYmE2QlI0N3NTL1Y1ZXlLRUU4azVoVVlmL2x5eWozMExlRnhZ?=
 =?utf-8?B?cGhVaXJDVDJUcGRYVCs3V0RNai9HS1R5RDZtSXdTOWl3dExHSXQ3MVVXY2t5?=
 =?utf-8?B?c2ROU0VGY0Z0Z0I2QThnSVVIRFhRakM3QUdMUEY1WFZkTUhpdk1XSmkxYjN6?=
 =?utf-8?B?VzNWSTdGSVJhRm9CczZaejVhUm9wbWk3YmwrTTZ3THlMOTBhNHpzYlJXMlhO?=
 =?utf-8?B?TSs5S285cVRSbWhNL2F3KzlVTWZIbThVUVVUdmxvVmgvS0pBZHBSREhBUzFq?=
 =?utf-8?B?Q05UNkFXeWlRVnFmNmxpcFNsa0xBb1V5QW1OcDhvSXppeHFvZW1mN1M3L0th?=
 =?utf-8?B?OGFMbGNCWk53ek9HSU40R1N3bTV1aENxUnlIOW1JdmphNm81RnhlYkk5Q3hZ?=
 =?utf-8?B?TVAyVWtoZ3pkSTJuYWpMOWI2R1BTYkFoWkpxaXNLYXBnZWRxNHIwdmlIOHdI?=
 =?utf-8?B?Wm5rT2hTRjU5dld3Rnc1ZG9qSVk4UGJnd29vV1F2UDNFQXorY2VFMVorYTdq?=
 =?utf-8?B?NGxwYmRFcUNkTm9KZVAxdU53N01WbGtUMHRJUzlZUFlIaTBzN2lwS21zUDNt?=
 =?utf-8?B?LytVMXFyMHltZ1VKSUNhcE02emJmcy82UXFCaG9NMG0rRm8rZXlEQnp1N2lW?=
 =?utf-8?B?aERqR2dvUjZQZzZ1bmdqNERkL0h3YlZrWGZkTVYzb3czQk1qRVV0YXcycmRJ?=
 =?utf-8?B?SU1iOXk0SjFWWEdTdVJ5T3pJem5lS0VWTXp3blhHL0gxeW0wSUlHbHQzMXRY?=
 =?utf-8?B?NDJqaC9NVjRCdWVtK29WamloL3dPWVZCdUNPdkl4VmZxcjdLVThKWlE0Si84?=
 =?utf-8?B?MVVJT2Q0SGpVU0IxSm42QVRYQ0dIQzludjVseU9FaGx1YmEwaDRzeXU1NUJx?=
 =?utf-8?B?dGNZV3M3czZJVzFLMXEzbmNDNmEycnFUZVYrOU9MNk1ycTNlalgxNTU3TExG?=
 =?utf-8?B?dmFOTGlSSTBYTGJPaGNLc3dVVy91dHNMVmVzWkxPSlhENUZwV2ppc2dmc0dN?=
 =?utf-8?B?VUF3T0Z6czNBWmRiMVBhVHdid3FxMENPUlhyWk03bWtHNG8yb3JrVjlKTWtq?=
 =?utf-8?B?a2ZXUlVib2wyWE5JYzNSWnIxeVNaTnBkWHNqdWlPbTFXanM4TVdoMkdwblJH?=
 =?utf-8?B?YXFkNWZnaWtqdlVmbm5IVm1HUUpueHVxTVAyWHNRY2tpVzVUU21oSisrV3ZV?=
 =?utf-8?B?SEY0Y08yYTRrS2xyZWZYVFhMamhjVXNTQlpudlBFN1R0Qk5sVFgraWR4NkVm?=
 =?utf-8?B?TXhzd2Y1dDdDZnFIbmhueGoycEpNMVFRN2Y4VHFMTGhkZThJY0Y3MGpGblB5?=
 =?utf-8?B?OEZSUkZyWkRFZnczVzd2WDhUU3ZpS1ZvQkp5ZXhqUnA3dW4vL2laaXdQUXBs?=
 =?utf-8?B?NnMyd04vdGFrSWFRclJiK1AxYzFjZ3lmbGMrU0pkOFpPbmsxVGZBbmRTZmZx?=
 =?utf-8?B?YmRZMXg1NzRRenVCU1FzR0pFK1hXeXFnaTBzUERvZlRSYk9QRzNEUGRjRjhU?=
 =?utf-8?B?d01GODl6Vzk1Z3hkb3o5WldFeGR3NGZUYzVXakZzUXBWUDFKYWxVWVFBblk5?=
 =?utf-8?B?cVZoNEMwQVhabTh1K2ozSzNrR1VRcW1yUWRUNG1sd0F0MDVxWSt4S2NRNXpV?=
 =?utf-8?B?dmY2MHp3NzhHZjBGMnI5bm1xbHZxeU1POXBsOFdqSHY0dXpYbExwa1V3S29q?=
 =?utf-8?B?Zk9lbElNaGlqWldQWG4vMStDSW1WNHdmZ3NINEhOaFJWcjBsT0JWQlRMVWll?=
 =?utf-8?B?UG01RHRlV1BjNjdBeWIwa2ZISjFCbjZYa0p0MEhpSXRsNEZJdSsvVTduVWpF?=
 =?utf-8?B?czhuQmdCTzFWVGxwWXY1VklUZkZmcHZUbnU4MWgxL0s2Y1NIWFFmVGVZNHdD?=
 =?utf-8?B?czhyUEhkazRBZzh3bHdhMnR4cmh5OGljSlkvcUoyUlRtVWlUazBZMDFZemFI?=
 =?utf-8?B?ajhIWjFSRjgzMkdnc3hadmpUU3c0SXlHdWxXUGdndkgvUGkvbFNvYnl3OGxr?=
 =?utf-8?B?Z3Y0RHVXV3VzRTRaQ3pHbFgvZGVweUo4cUxBZGRseEVlQ3NGUzRRclNoVkI0?=
 =?utf-8?B?SmloMFFFMGF4R3FFZFlmVGs2ZHhLeEdMM3NlYTlEbGV0MFd4aXNtYmxNTG4r?=
 =?utf-8?B?Umpwc2h4OVc2RjFuR1dIOHp0clBUYU1sb0dWekp1TTZ4K256UHdpa1hlNCt6?=
 =?utf-8?Q?LSphZ6PEQrp6hBAU=3D?=
X-Exchange-RoutingPolicyChecked: 28rNfoja7Z/wBRCTpiSQKlWb8tXdBLtAYbNH3kxKwe4rrVahIezofXXtZf8huPQaBEPgFALF4Qk4Cmu12J1/c/giG5Njqi5xOLGLmveXr0zvQOUbYSgc0dgULODBFt5fchjmlcgjvW/58FoORibH3i1J+vAIDhzhwJbZPwF5S9R54KyKworqx10u85XMSv3j3T0F/HWPHTwBNKEXTIN0eFmllgDGdxowIga+VeTJc0dML1KHDL2XLZD3L1Ams9HLzKrW0syBffTWdFClCYOR6idUEyM2BQ5rnM4z9oF4MUKGVyJmN9HlkGDEuTi+vc0aiCTp8+MK091nEcYGLS8hjA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 669781d2-e410-45df-77ce-08df1a50e8a7
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2026 15:31:31.4010
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zMvBuQbhwTwsJr6HRLl6q7loAIcTTMRd2nLmqUAdKCrMkMPKCNYBDD1O0gqCtK3PPcDvlTgufogaaTATyEjLoptvSstPwtVRV6V6bkH0FNE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6018
X-OriginatorOrg: intel.com

Hi Tony,

On 9/16/26 4:13 PM, Tony Luck wrote:

...

>  
> +/**
> + * resctrl_disable_mon_event() - Disable monitoring event
> + * @eventid:	ID of the event
> + *
> + * Never disable an event that may be accessed while the file system is unmounted.

Apologies if this was not clear but I intended to propose that you *add* the above
text, not replace what you had. Could you please bring back:

	The file system must not be mounted when disabling an event.

Reinette
