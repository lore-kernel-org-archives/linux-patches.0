Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B22AE3603FB
	for <patches@lists.linux.dev>; Thu, 10 Sep 2026 03:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789012602; cv=fail; b=tEcXn9JuEZ9vzno9ncJwsnm8vkpQCPo1NWC+C2QyLa81UvUiFT1DwJCm1/Lhx/f4Bv7VLfTStpR/h4Ypp8Y5QLRNrH5B5tglRfRQDKqhu162yNpvndH/g30bAmoegONZCUj9VXZvyZPUCnEQUA536pPd9jH3fEF79RSJ6yiRxHU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789012602; c=relaxed/simple;
	bh=2Re92eyfNBiIDMxT08donFZKqjOG2O2JN+s1oRcGUf8=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Fv6sUMtCMhqai87o0eBuZBr04zIKwXETJyysQ6SKL+hrTLgfOVpUTHNYrhh5ohZ4AjmtCtp2nEGZUGg9apwJsJWifsiEZK5zybcIcZ2flrbw6GSzY77vS9+VFR9ZhEK0NHCvHkUTiIhPE0zG6Hl3/OkbwpzB4IbR0WWjQhaOCCo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ke0nfpPN; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ke0nfpPN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789012601; x=1820548601;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2Re92eyfNBiIDMxT08donFZKqjOG2O2JN+s1oRcGUf8=;
  b=Ke0nfpPN8NFPehoDIT3ieYN7Y9DWXSI0eX6Ha4GDicOKr2FBdxzWHydD
   EsK7zvO0ousJ5APYMdvdRP+3UNuTiKmRzhfv8q/JWro5WMv1egXvHynZU
   hF/3RvzElqyy/a5zq1f4LHHIAYKD6AWiGUcGG28usLO7M9XwzTBjc+iNd
   awM4WZLUui/kIKdvyhNygru6+309C8/XOyUXeR4Xq9ht1q37wnwP1t0pa
   3qIaFPNuY/OAbLparGklfjPmzsvj6ufkPJ7NjsSUHbyoDTmzKGWSt3LhZ
   R+H8HNNbPflJbNUUCPWZCG88A7VT5KPWJ5Qgav7Iie3r/BTNLKvTtjpj+
   w==;
X-CSE-ConnectionGUID: 3zjkWpJnQ4OKZzQdyejXCw==
X-CSE-MsgGUID: EO+5tl5GRgKCS49VwivcRg==
X-IronPort-AV: E=McAfee;i="6800,10657,11900"; a="89492982"
X-IronPort-AV: E=Sophos;i="6.25,271,1779174000"; 
   d="scan'208";a="89492982"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2026 20:56:40 -0700
X-CSE-ConnectionGUID: I2BdRH5uTQS/FryudqQvHw==
X-CSE-MsgGUID: 13QHWHVUTfSooUyQTjvIcw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,271,1779174000"; 
   d="scan'208";a="265302686"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2026 20:56:39 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 9 Sep 2026 20:56:38 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Wed, 9 Sep 2026 20:56:38 -0700
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.2) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 9 Sep 2026 20:56:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Eu3s3fYwVyRVvQL6IO+mQTxteJIGTN8Qw5wRU0Ihu1icdtRyqaIf4TbP1jix8+epfcRc4ToQzJdJTe1EV8Z0ct5ZSRz8mGPvegcEB2jlWONPIommvLu7hrIfIcHRZaPqxEnyUfS2P1CeLvLqSi0MgLG8uEb2Fe+/vDAMJGdHQ7Bg0HKS4CTxqRQX3fFP3p6WEQW/F0f5w2ltLVpDVjXguCwdBE6YCzFSjVnkHILAfPK24ujiKB+LGpVSzBVOenPa+PKJstPfngnVgrpcgz6nrpB+d43Ygx6XBM7N67p0bJoZpSrDIpbXsAFBF0PcvjwmWdJuiJnpKYp2QHNpFPXd6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3lkqyDjoggnbgFZ9ncSO3H8cl674Sq8Gr7nkiwykXNw=;
 b=fpt476FsMf290/bgs3BmFiL54+cPDzPPel6843yfSv38h1ew1wA5BBYpj2EIUTx0Wtbf1yR9XFD+jDxQhP7Il1jgOamCsCXodX4jo4Z2mWxpFGPlODBGJTgTjjqD1EJ+vscfruTlNO02E/95uZ1vOcGDmQiEENNgP4Cv9HcyIb901E8mSGJNS6LFvi9dgrZxVFXtZbKDJDqf4qxHslGgZ+wcF57DGj5S8SxyZNiZw7jNoX81cXU9lv7oBCRJaFTZ7VZ6AWc6afyKWuQVuS8kQa5pDwtIiS4/FPSkaDWQtHjLCViyTMGbnqfwUCTPWoz8Yd2xjBOKPtJXeQkVamAKvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by BL1PR11MB5979.namprd11.prod.outlook.com (2603:10b6:208:386::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.8; Thu, 10 Sep
 2026 03:56:36 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0406.005; Thu, 10 Sep 2026
 03:56:36 +0000
Message-ID: <9df24f19-0e4b-474e-979d-e5809aecc53b@intel.com>
Date: Wed, 9 Sep 2026 20:56:34 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 07/23] x86/resctrl: Add special case for Intel Haswell
 enumeration
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260831174421.13921-1-tony.luck@intel.com>
 <20260831174421.13921-8-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20260831174421.13921-8-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0347.namprd04.prod.outlook.com
 (2603:10b6:303:8a::22) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|BL1PR11MB5979:EE_
X-MS-Office365-Filtering-Correlation-Id: 6bc812b4-3d91-4cc6-3808-08df0eef82c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|366016|7416014|376014|1800799024|921020|10067099003|56012099006|11063799006|4143699003|5023799004|3023799007|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: oqltYU+9TV8OQkZnLebIzKqSHShmsmQJx3yOUf2TFCtbWrr2oWD5ydNEc9VZP5rnAiRoxqan8ReqV4aDD7armSW1b8/JVNRcZOmC5X/p0Sr5E+6Q4cPDI/vlpXzYDq9ZeEPr6fV3BrTdUUoT2Zp40Nr2ro9KMEGbyKGc+SZE0GCg/YntH4CKYstm8OCGHORMROYIEsEq13+L+erx8XM1iEDRHBi5f7VV1tGOBfsaXpOR137FG/aQnp7MwudshIYif5H2ersqURnVTa3bP+vwtKm+D5YXjNkBX7DPg4vVarGDGCrtayHMYtkixlUI45eiGybH7wjhefvnNfttgWGMcms32Sk6L6F2TY0WramgEKkSnruLMPFVdBXPGQG+X+Q2tMKlSwU/L8vgyzv1iDEgUec1oTKMs2iwJXqqZmYeL1Q9ZVTFcBJLf9F1ONFsxCgDmPS8i1KRgI+NZL884VkJvgTUynp86+5rmVUoJYKVqa9LVNi0AVMq0iNlvZ1iA85n+P+hOEMKMDm+M/nuIGE/vKQx47gDFvApNipoIKpzV0xvpgKdJGnc2CnKI+PWpmrTZlykDwhJa4JtwB9BIOyYoEIy1cVLMcV8ukUvpFLsW6YO0LcqFoCa1e0Vcn9T6a96DvPrdW7NwWBAQbg4ZSWck9+ueq1IBnWVHqKDEnTgnxdP63VC0eDeneVUiSxLEN90jvepKDAJsXvRRb127QBq9w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(7416014)(376014)(1800799024)(921020)(10067099003)(56012099006)(11063799006)(4143699003)(5023799004)(3023799007)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RTVyU1hWdzhvZFlOblVqYUdOdm1Qd2E3cWoreE9wTkZMLzVVYnRlaVpBWnZx?=
 =?utf-8?B?RWFaQnF2U0lzdnVkRGJ0bDVYTGRobjVORW1ockY1cjJNak1Jd2lHckpNZG8z?=
 =?utf-8?B?WHdGdllLMUdTQldFeEFvb2pKRVg5THRuQUJwbkJONFNtRDJrMWFsSkliL3NU?=
 =?utf-8?B?c3l6RXY5djZha1NUT2duQlhlRlRIM0pVRStJK1p1bHF6b1VsS3hpUU50UllD?=
 =?utf-8?B?TG00TFdpOWhUWHdWa0JGdWVRTHF6TGx6elhnMEt5Wjc0R1IxajFFNDlTVDNz?=
 =?utf-8?B?ME9JazhQRndabXB4MDYwSjZpZEdQUWRQRitJenJhUGN6MVlSZzZrWFVpYUtB?=
 =?utf-8?B?N0xyTWVLdzBBRThveWFZdlVCemZnMHRmOWQweGNqYnZRQU5pVG5SOTlQSjA0?=
 =?utf-8?B?a0l5eVBReG1Ld29vNXdaTm9oSktIcDZxYTZGRGM4Y1NvNGJjdFlzY3RuNFRR?=
 =?utf-8?B?RVNKdFZ4M1NyOWEybWFBV0RqWm9DQ3RFTjhaa2tJeWFtbStWSWZjTGw0Z2Yr?=
 =?utf-8?B?aG9qRVFhRnpTcnRwZGdMeFJNVFBkVklRVCt6eVlzSlludDA2NEdEZTM5c2wz?=
 =?utf-8?B?Y3M3bnBHZ2lXT3V6Vk9NNnM0SE9XT3RDcVpzTWJ0VWRDREFKLzNQU1NLendY?=
 =?utf-8?B?blhlREE5aXdEaWJ5UjFDa281ZGdHWWM1cXRpYWppeThjaWxTS1pnMWtLcmxW?=
 =?utf-8?B?b1JsUGVCN2VtY0dKSm9wNHB2TCtsMDQwVFREK1l0aDRMUGFMNGpldFI2ZVpB?=
 =?utf-8?B?T1ZaclEzZnNTVHp2STNlYjRCeFRjT1JvT1MvMEozMWI0Rkdld2doRmtIamw5?=
 =?utf-8?B?cVk4ZkZ5SEh3UDRzN2JBeXhnV09ReHRTRUY4YTNWL3VjZlZycGYwNXRWMWh5?=
 =?utf-8?B?N2VNbW9PM0pkeFQvQVhjL2Z1U2QrcVlMS0lSYms4YjRIUUxRZ2pCaWNJakgz?=
 =?utf-8?B?bCt5TkVqMUdQL3grcFZUWDVZektqa081UGdiM0d2WU4rc21GaU1RaFhXU05H?=
 =?utf-8?B?aXFuMEcranViZDViR3RVS1hjbFk5NVhKSm9pbjE2UnVMdmZWNXAvREptTUFV?=
 =?utf-8?B?ZFUyd2RGNmM4Vk8yYzYydHZUV1Y1WVozTXFRNFlUS2taazl5SUFQV3A0YTJ4?=
 =?utf-8?B?QjU3aWF2eG1pLzd0SUZUVTdaNElzVkpaQXVjb0p0c0lOR2VvZmoyYWZRSUFM?=
 =?utf-8?B?RVVGVHpSMytiREhtWVdZb1NsT1IxYnAvYjFDSkJKdzNBM2VWcW1mN0h5M0lG?=
 =?utf-8?B?R0ZWY2EwRmNMN3RGN2EzUzVicmJ6c0M5cnZuV1lTQm01QmMwUUtOdDBhOWRj?=
 =?utf-8?B?QWVmZzBpSm5td2JtQVE2bXhsbHZzdjBySDcxNXp0N2E0dTFWQXJUTFYwdW9w?=
 =?utf-8?B?d0NaeEF3cy9PQjdLU1ExQ1d2aFhSaXB3SENCQU9zVHlnaUFmb2wwT3lKczhm?=
 =?utf-8?B?T2M4ZVJjQXVYTGMzWSsvSVZMVFVrdjRrV3NKZGlXczVMc1ltQ3krWHZscXpy?=
 =?utf-8?B?RjdqM2hhN011TEQrSktQbGx2cHVjKzVJVk5JNWR1dnUxRjFRWisybDlDd3Fi?=
 =?utf-8?B?MkRKcDR1bU1WN2xKS0FoZUFsMUVKZE9zVy9zT1dUdFpwRW8zOFZPSXU4VXY4?=
 =?utf-8?B?c0ppbWxPdjVOR2VHZ1k5WCtlK2RLNm9rSlJPRElrQ0RGSGQ4ODhwd25rT25u?=
 =?utf-8?B?TDUxejNadnRxaDBsM1RXWjhpVytncklHeHZ0di92WUJnOFRhaGppNkl1ZFpk?=
 =?utf-8?B?M1pXenNaenhJQ1dlZGtrWUFDc1g1ak1LcVdtZDdmSkZBQ3pSem1vV3FzNVp1?=
 =?utf-8?B?UnVneXVsWFJIU1I0VFB6NmZCSHNRT2Fua25SS3Z5Zjk3VWV0d3g2dlFRUlh0?=
 =?utf-8?B?UmZuR3hDWmdqZzh2a28wTVFLb091YWEwZ0U1RmNhSEpyMVJnZzMwYVdkc1Zs?=
 =?utf-8?B?bmhpdHczbXUwTkw3Y1lnZnE1ME5KK2lhTGNhVDdTcS8wRTBUMTdnNEJTZGR2?=
 =?utf-8?B?K3B3N1NSclgxRGRzNnN3UUdJVXZ0S1M0UjZMZ3A2TUhscld5VG5LTlJtRnBL?=
 =?utf-8?B?VnlwWW1MRjF1bDc4bmlWT3BkMEZCa3IyMG5JWkRBQTBTcFp1bVRKelZRcWd6?=
 =?utf-8?B?ZVczYmlLMmxzYVlpRmZyYzFnTmh5cXliazFaUlZ1ajQwSS84amRnbzA4V0Fy?=
 =?utf-8?B?N3UwcTlzc2xzNGVTL2ppQVRBbTBtL3FidnB2TWRkZVI5MEVTaGpiNHR3bWhL?=
 =?utf-8?B?bHd6Y1hWajloSkFMRjh6ZGdieUZva09CRnBiOWxZK1ljVE90Qll3TTFCY2N5?=
 =?utf-8?B?ckdwQVFadGNCT0ZwR3V5UTNITExCM3V4QnBjT0JCU01nWk9GMVlGcVR3QWVs?=
 =?utf-8?Q?G1DDdLmRBxuJdCOA=3D?=
X-Exchange-RoutingPolicyChecked: ILEz87evcTjx4abbkLx0FKNJryhUrshPjDEvii8POda59PWuoICTLg9ol12NYTtKJZq6IZExUqNqi9P+At58skM4JvPJdIx25FLA8T5Ew7mAI6b97PxPVgO5RD3MB8kR2A/jdFCJ9Kj9OnwvK5AQW7iaTR0ywdNaDAVPx9YdSbUjU7i5ZjCKcw66s+XM4i33nanS+xKj44rpuJD1ix4FevtJEextQAKEJ03DLwVH+suu4JAHWaxpcTIRMg0MS+3oEIy19dokvVFO9x0ysGP1scazyppVVuOepZbheuomHhyM3Z5j1wkvXZmicf9AACUHNAcZbbyWy7JNCywoHqpTFw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bc812b4-3d91-4cc6-3808-08df0eef82c8
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 03:56:36.5328
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K5aEblyoXfr66pjcMq4yrwX9yPTIGxzmJT/YoU9H3y8o0lmPLEQCWcuDNNa1y1nlogkA9dspP+tO0iC8bOAgv+X1gF9PS/U9k0oxshh83qk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5979
X-OriginatorOrg: intel.com

Hi Tony,

On 8/31/26 10:44 AM, Tony Luck wrote:
> Certain Intel Haswell CPUs have support for resctrl L3 cache allocation
> but do not enumerate the feature. There is a quirk to check for support
> and provide hard-coded parameters. This quirk sets rdt_alloc_capable
> to indicate to get_rdt_alloc_resources() that normal enumeration is
> not needed.
> 
> Replace the set and test of rdt_alloc_capable with a new variable
> in preparation for the removal of rdt_alloc_capable.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
> v11:
> 	New patch
> 
>  arch/x86/kernel/cpu/resctrl/core.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index b657eab4eb0c..62b97e357ce5 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -138,6 +138,9 @@ struct rdt_resource *resctrl_arch_get_resource(enum resctrl_res_level l)
>  	return &rdt_resources_all[l].r_resctrl;
>  }
>  
> +/* Skip regular allocation if cache_alloc_hsw_probe() succeeds. */
> +static bool hsw_alloc_capable;
> +
>  /*
>   * cache_alloc_hsw_probe() - Have to probe for Intel haswell server CPUs
>   * as they do not have CPUID enumeration support for Cache allocation.
> @@ -178,7 +181,7 @@ static inline void cache_alloc_hsw_probe(void)
>  	r->cache.arch_has_sparse_bitmasks = false;
>  	r->alloc_capable = true;
>  
> -	rdt_alloc_capable = true;
> +	hsw_alloc_capable = true;
>  }
>  
>  /*
> @@ -930,7 +933,7 @@ static __init bool get_rdt_alloc_resources(void)
>  	struct rdt_resource *r;
>  	bool ret = false;
>  
> -	if (rdt_alloc_capable)
> +	if (hsw_alloc_capable)

Could this instead be replaced with:

	if (resctrl_alloc_capable())
		return true;

>  		return true;
>  
>  	if (!boot_cpu_has(X86_FEATURE_RDT_A))

Reinette
