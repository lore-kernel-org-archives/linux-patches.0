Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0D5D27935C
	for <patches@lists.linux.dev>; Thu,  8 May 2025 15:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746719977; cv=fail; b=M3S3HQ7xA/thy4tZY1cu0yyeOKE8fEUwlOR+fsYX+tzoS7bPxcVx2FGs/VmaS6oNdmyv05JP89QYPuoekbI8SUjAAXV0+7wgeIgQFLfLZ43VlR7bOREoD/jAASiSizoW7xZse5tIAXPozFvhI7SmOGALAvKvTGx57DRRFXZzUB8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746719977; c=relaxed/simple;
	bh=IhPuHtXmPfdeX8R0EuTVV0BAfeATewnbeAgObruQbVo=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=LI/qWuBsFeJjzD/XDH8H+gLZih6/SsBUN/zszlTPePs5jWnEh89rWTk9pQcZhMewXo5f+PygkHmzqLN8d4UMsBmvbeiSKoCUWEl2IX6Wl93gip4ZHmpE6hPm+xfCdyL2Ft0gnCZy+e1Bf0NbhU8rexcW427yz9Ho+P0KS0RloOA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Kz9uhVh3; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Kz9uhVh3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746719976; x=1778255976;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=IhPuHtXmPfdeX8R0EuTVV0BAfeATewnbeAgObruQbVo=;
  b=Kz9uhVh37EEUlfHq89yGpamERy85LGdij0MqrIkIeKJy9IF9FY1SCQpb
   hfaqK4etBZ1GuXg2zFenhntFxnK88IYevy1MUPfM1AbCyms7MrJF85nMa
   4EJd5eLyiQ6Hn3fM3ETtuYftaXUB4T6T0Jp+5jFfe3x/owAp7aHDm73CZ
   U+LpZoPGBDDt29OULpOjAw1l66CFXN+IZ5N82yulLqFb1tV4b2Hh2hjUJ
   V2C02TyY1gxZYj8nMXp8feBiDi/4xcLaHuaLsLWNQmE1r+kdMtx1FjdRe
   Fts5xNDxHCIMaZeMjSop0igq1US84vqZOBErSYCE9EqEslCtW27MNpcAk
   w==;
X-CSE-ConnectionGUID: 0tZmNR8DTA6VViMHuAOZWw==
X-CSE-MsgGUID: N2hCYVXRTPWdQ8QGK8BXKw==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="48423881"
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="48423881"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 08:59:34 -0700
X-CSE-ConnectionGUID: BhbKG3yRSBWSMFL+E5b3iA==
X-CSE-MsgGUID: KKTLkZ+STuSzSdTJ4t1MAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="137272103"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 08:59:34 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 8 May 2025 08:59:33 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 8 May 2025 08:59:33 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.45) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 8 May 2025 08:59:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v/UaoLDfgbwo2ZZlMZX4QOOztMaTxv6PaNq7/9ol0Z7ZgT7taqWgdPqwMTf/T8MjCJAt2+wHrtCZVYfuhaqEzFIafG0OIrjtb3hhEWkzXMNcVot4viZFGXNkt3DrsVYywDQ39G3mt5522xWP1KHdtKRe84FI47zE+B1pCT9rzUQUtvFN0KCOxZe8d6MJvX68bgQ4srrjcZoh6jNIb2kvhXhC7vSPgE/CQFJAcZnDZw/+TEbiVqxefKVAbJQshw6rBsFFLinVJnHgCcbB8JlPZTkHOVQRPcgdtWQ6YjVIQ5vXf8GRm7sBIbllMMxq5zPIbVZz+agD7kLWtL0g0gejMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Etys7SSctQu89bWihn7Jg0flZjiuUL0izNTg54KKLJo=;
 b=s/pTxKwuzEzJegcHkU3p0FmK+Il1SZQavYAXKqC3v276YxwEiYJBObN25ItgNl3yNTm4Ypbo3oO9We2jG6+BhtHyieQHsdBKnKm6ZjGxs91ieiSrw7EhYH0wKM8lWOjaxHQaX93uEOlZGEpiyA56eVDaXNEoLfyeCCi6v7XMNU2EhDHKok09HroA/wgcUhm7NKC+pd72ioy6nwvfFoU0Ghib30SnUpeMXlmu4paFl96FYGJAcvuHlA5Gqa1ng5aH1VWh/5oj9j3rbBWUjq98Oph8SsCEk9l3ihxVMBcO/o7JsUNaN61JmIDsWVpHmR7LmALQZ7Bfhwwuf3YR3EXp1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA4PR11MB9057.namprd11.prod.outlook.com (2603:10b6:208:55d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.24; Thu, 8 May
 2025 15:59:28 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.8722.021; Thu, 8 May 2025
 15:59:28 +0000
Message-ID: <446cf50b-bae0-4e5d-887d-3769eae4b824@intel.com>
Date: Thu, 8 May 2025 08:59:26 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 27/31] x86/resctrl: Handle number of RMIDs supported by
 telemetry resources
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250429003359.375508-1-tony.luck@intel.com>
 <20250429003359.375508-28-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20250429003359.375508-28-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0005.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::10) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA4PR11MB9057:EE_
X-MS-Office365-Filtering-Correlation-Id: 7fcec8e6-9d9d-40a3-4891-08dd8e494fc4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?eUNFQ2dRb2djbVZOMTFndVBISFVhUWFVcjA4cVJ1c2tST0U4UjhtWGJHVnlS?=
 =?utf-8?B?QzQ1eWZ3dUtqTjkrUTU5ZDMxQjQzNWpVWmVCNjF4OGFWWmhXY1lmRmNabHZZ?=
 =?utf-8?B?NExuenh1MERITWpxOFV3WTVFNFRISkZ5cmtXQWdFNUQ4d3czSllxbHUwbjNv?=
 =?utf-8?B?VjIzL3VZZFl1ckVIeEI2T2MvSmRlRzVOMWE0WkFLNkc3WFBDd0dHR3FFc2xv?=
 =?utf-8?B?RUtWOTNzSUd2S3VPOHZFT3BaUU5wVGQza25QN0JZRDRBTVZERVRDUGw3UVRP?=
 =?utf-8?B?d1pXQlltTzFqL1Nva00xdFdOVVBSdTNxN0h2UE5SYTlWOHgzVDNiRG52RFEz?=
 =?utf-8?B?WTJhTGZXRnF1QjZzamt1NDE1SzVJbUZ5cG5ZV0w1Y3Y3NjVadXVpVGQrZnVi?=
 =?utf-8?B?VGJJVW9xMEp2YVhsRVFvY3RtQzdFSkNmYmhRTDNpQU9PRG91QTBkYnZnQXVm?=
 =?utf-8?B?U3c5YnpNL1BuaTIrK1lqcWplM1dQYWc2ZkJtcVhVTjRKcVp1OWlkYlBwOHVT?=
 =?utf-8?B?c0RrSmJIcmJaL2tNcmtkZ0FOZlZpeWYzcHlTNjE2eGEzQ29vQnFLZG5udUd2?=
 =?utf-8?B?ZFVDQjNsanpSWVVTUFZFSVk4MEpOTzhxU1N3Z2ttS1dCckNqVEdWL2RFam5k?=
 =?utf-8?B?Z1hnREdVRUdaOTd2OTVTbmdZTkcxRU5qd28yMlFBY1RodWtQSWxEMStHMDVD?=
 =?utf-8?B?dmxzdmxDQ3FhQ0lMdlFzVE9mdXBUV3JWTzFDMVQ5RGxxWG1iT29RaUJJc2lB?=
 =?utf-8?B?ZjJ1OVRId2dQbGRLRW9DbHo4dVdKc0xRdUM4bjdYWlZpLzJyNFllNmFuWmxs?=
 =?utf-8?B?cElZclkwNUE5clhqZGg1bHZaSlp6THF6VzFsNTJMKzcvcHpVVUVYNVhWdGt2?=
 =?utf-8?B?TlhWd1NMMTZwZ2ZmUWpmMG1KcnBZc2NaTVBGMmVsOUc5UERiSHh5cXhHbTRn?=
 =?utf-8?B?U3NwbVkrZHluZVdOMWpzVzBiMWxaOXpKWU1taFJYZUlGN0Urd1hsYU50WS9G?=
 =?utf-8?B?Q2J0cEkyYUZrd1RwUFpOVnkrREk5azhOejcrYVZ2bTVwZTVYZThVenlva3Vm?=
 =?utf-8?B?emVNaDJ5RTdlR0s5MFJOeXBSTm1VRGo4OFhzcUtnNDcrL2FlU21qRDRMWkRo?=
 =?utf-8?B?WnF0NXNPYzNTUFFHZUhzaVFvY0E0QTliYTFEemZjWnhsSkZ5aWFHa1FkTHZX?=
 =?utf-8?B?Yk9KKzJVZVVPeWQyR0tqNjRSZXlocWpkUHAzd2JtbmhCRHg4aWxnSWFiZlFF?=
 =?utf-8?B?NWN5WGdhRmJiaWxlY1U3WSsrdzF1eUhSVHdQTVE4MDg4U2VkMDB3QXhPaHVk?=
 =?utf-8?B?SkpYVGZkaEM4MVdyam9PNC9DWEdnWE10bis1RW1oMUQxdlFJYWoyL3dwVmFz?=
 =?utf-8?B?YzMwKy9vcjM3ajhrSHk2cmM5ZUg3Y3FoQm9yS2xiOTJxUUFnQXo3QXJoUUFM?=
 =?utf-8?B?TkdYaTBTMEJJQW4wWE04K1dIQUNDODUzSW1OY2pvb2xmRnM3SXE4cVpHRDd2?=
 =?utf-8?B?WXVMcmZnVXJJcitGNStHRFRaWlhpdFlJQVlsM2p6THlVMUgyaWtXRzF2aTRO?=
 =?utf-8?B?TWp6Zk5yejRHaVNsWXpNanZqa2xBOHVBTzB2Y2VMeDE4UExmQ0dxYjNpay9P?=
 =?utf-8?B?eThyK3I0TDk3czV0U3lkK0R1UkJyYU1VUjhPV2t1cUlTdzhPczJJREt3cXE2?=
 =?utf-8?B?dS9nd0o1UUhNdkc4MnVINENCVzU2M1BJUTRrT3N0Q0EvdnF1RHkzT3RMaTFk?=
 =?utf-8?B?QzRzSTI4ZkRRckpreGVCVFFnN0FraVFieWYyUWNVbXNYTEZHQWRCQ2JYL2hz?=
 =?utf-8?B?bURWbG9DeVVUSEJBK0xlZkhGTG43TmFNN2U0eUNPWlFtc09UZDE1MWozaHgx?=
 =?utf-8?B?SGt2ekUrdTRCQ2ViaGJqaTVWdlBZRE1MdTh6bFBLYXhsMGFCWEloNGRDVS83?=
 =?utf-8?B?M04yNlhBcStrMGwrYUtxZkhkRjZhTWE1QU4yYzVtQzBTVm91cjBiVFhaTHVo?=
 =?utf-8?B?OFV1OGJxUnFnPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QlA0dUZ0UGxlRWRNREd3TWwzeDVBSnlRazFXaDlYdjVkRTdNUU5GTjl6MnQx?=
 =?utf-8?B?ZC83SENmZkVGSXdUdU10SUxXUG9way85azAzUzJnSGxOTzRzZVdVRm5ON2JC?=
 =?utf-8?B?NWZuODhSbDk0TkNhS0J1WG8xSU4yK3Z3cFFIZ0RzRTl3Q2pyUWRZaUVWemQv?=
 =?utf-8?B?YzBOY0syN1hOd0pmZUY1Z3BxTlYra1ltMFY5SnFrN1cyR29leE1XV05IWXIw?=
 =?utf-8?B?eWp5OEhURFdQZ2hRVGdpQVVQeHZwSksvRnJReEI2MldySlk1Si9pSm53TVJE?=
 =?utf-8?B?MTlhU2V2UTBhbXVROUpDNTNJOFZmdkN3d1pRQXg5SExCYVVlRFFCaC9kb0Jm?=
 =?utf-8?B?eEVkQjNnbXhEQnJUZy9mNmUzcWVFMEJYakxERWpISjA1TGJsTmxIVkczTkZl?=
 =?utf-8?B?QVU5Sjk3ZVBOUEFsLzI1TkY2elZTMld4TkswZ3Y0YWlsKy90Z1RZelBBaU8r?=
 =?utf-8?B?UjdvejJQdWpnaUxaeTJPZTV3eEZkdFZMSzdiUTduM2x1dHZ5RlBGaXdlM0FZ?=
 =?utf-8?B?WmVJUEx5SUpLaDJRL3Q2YStXdWxUaHRFU1JqbDR0OXpCeHJkS3pJei9EWW9u?=
 =?utf-8?B?dzQreWxyTlNMck41MmYwd1JkZ0JaS3Q2V20yVXZ5L1poTE9kVDgwSDBYQmpR?=
 =?utf-8?B?Z1NUbFVDYnQ5UW9VNUZybGp5eXlBTGR0Q2JHcWFtS0Q0blkySE9DUmRRUmNo?=
 =?utf-8?B?RmJYV2VZQkxlY3cwVXhPQlVWZEtxeFI4SkJnNnp4eXVpcWw2SkE4Uyt2czRm?=
 =?utf-8?B?c3NzRHExWnBTdi9wYzJNVDI2dDYvdTFydzZ0NlBsOFQ0SzN6aWdwZktQNEdD?=
 =?utf-8?B?TjV6emkwbXR0QVRScG5iaU5MeHUvb2RoNlZVVkFJd3ZhdnVMWW52bms2cWRC?=
 =?utf-8?B?c0l6K0Z0WmFKZ056NTVKdkRkUEFmMTUzTFhtZXhKZU9TOXRsQ2pKMVBPbnp6?=
 =?utf-8?B?dTIzdGZ0ZndTTnhaSUlBL1RrRXlqVC9tWWsxdS9BYUJkS0VMdGdrUTFDakdz?=
 =?utf-8?B?dHZFQzQrczRjWnl6MkJMcHp1SFBUeWJUdFNLZ2FJVTc3UHN4WTlraGg3U1BF?=
 =?utf-8?B?MUpMYjBPNTRSbkxkSi96VEw5QnJWVmo0YitHbjBack91VTFBSE8raFZraHNt?=
 =?utf-8?B?MHFkc0wwZEZHdW1YbG1xUUtlbm9iUmJtVnl2RHVESk1FcjBvcUxCZlNkWFRs?=
 =?utf-8?B?dWhIWlFnMUtiTEI5Q3lQV0VBU2d3dWoxMG9UNEhQakNlMnZ1QUFOeERpMUFT?=
 =?utf-8?B?VVV1NlEySGl0NmorT04yK05nSHJ2MUNZVGlocjhER1JJNGg1UktUUTl2eC84?=
 =?utf-8?B?eVU2eUNuOEEwZWFNWW40VlRMaDg1VjZFRTdNQUNIclF2V2xibmtqSlVpdVdY?=
 =?utf-8?B?NXBFMmdSZlFjcFdLbnFpL1daL1BERVVNcDJybHBSN0JXTnM1cVh6MnpDTEdp?=
 =?utf-8?B?elNQaGR2K1dIeXZaM0wyRVBxZmRWcUg0OXJHQXZLcVBUZEZoL3RsbnpwWHVK?=
 =?utf-8?B?MlFhRHdqRG52eVZWTTJacXR3V2ZSczZZWE94WHJ3bWlleHl3bDRNa0J3eGRz?=
 =?utf-8?B?OTJzVVpTdVNLS1Ixck10RHBmQlpFQloycGFsR0tKdzdaTXNWVXdsWWRRNm9s?=
 =?utf-8?B?QktTbC9MaEZ3N091ZSs0UStrMVBwaExLSnVubWZiUFBoR0FwRVNnMW44dGNr?=
 =?utf-8?B?eW8zdUxLbmkxTUNXSWVDZThpZ250K0xPSitnSmdJWmFWclU5MVl6TGpJUnZ0?=
 =?utf-8?B?OHVvbXBJT3p1cnlXdWQ1TUtZUzI2ZEh3Uk4ydXI1WmpmNzA5M2ZNbGY5d0hZ?=
 =?utf-8?B?b0xNaFY0RnU4WUpiQTEraG1nclRQYXZaelpMN08xa0tYU2ZPZTgyTEFBd05l?=
 =?utf-8?B?amh1QzQ2b3ZXdHhhNnlEMm9TNUtpTEpDNXJGcnIwNjNLK1czcDJHditWRHgz?=
 =?utf-8?B?bVUyYW5IZUFEWG5zRHc1alVMUElJTmRXVzdQbzZhWkk1OGtpQXh6VWZoUnB1?=
 =?utf-8?B?NUdwK1k2T1hrdUx2ZUhOa25TTnZxSVdOVWZHTlNUWnNsR0p6Uy9GaEdwY0NY?=
 =?utf-8?B?Rk5aN1RqWmN0bjZna3ZJSGF0S3IyWnFjd21uQW4zeCtPQjJDblArNmxPSHhQ?=
 =?utf-8?B?KzgxYnYwdkpBc3R2NEpOamE3RmtlOUVPbmhMaEZaTlBQVWVQWU1NMjArZ2c5?=
 =?utf-8?B?Mnc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fcec8e6-9d9d-40a3-4891-08dd8e494fc4
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2025 15:59:27.9833
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HQq981h2AmplCMikF8trLrhtbc9qMM3n0g3ar4ITnvplZjhAlw0taLCA4ATwcYCbT5NAV2/QvIZlAUj1b3lhrQmvFkm6NQOUlxiH2NripVE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB9057
X-OriginatorOrg: intel.com

Hi Tony,

On 4/28/25 5:33 PM, Tony Luck wrote:
> There are now three meanings for "number of RMIDs":
> 
> 1) The number for legacy features enumerated by CPUID leaf 0xF. This
> is the maximum number of distinct values that can be loaded into the
> IA32_PQR_ASSOC MSR. Note that systems with Sub-NUMA Cluster mode enabled
> will force scaling down the CPUID enumerated value by the number of SNC
> nodes per L3-cache.
> 
> 2) The number of registers in MMIO space for each event. This
> is enumerated in the XML files and is the value placed into
> event_group::num_rmids.

This is unexpected and not true at this point. Instead this is something
this patch introduces ... kindof since the value is obtained from XML file
and then "adjusted". 

> 
> 3) The number of "h/w counters" (this isn't a strictly accurate
> description of how things work, but serves as a useful analogy that
> does describe the limitations) feeding to those MMIO registers. This
> is enumerated in telemetry_region::num_rmids returned from the call to
> intel_pmt_get_regions_by_feature()
> 
> Event groups with insufficient "h/w counter" to track all RMIDs are
> difficult for users to use, since the system may reassign "h/w counters"
> as any time. This means that users cannot reliably collect two consecutive
> event counts to compute the rate at which events are occurring.
> 
> Ignore such under-resourced event groups unless the user explicitly
> requests to enable them using the "rdt=" Linux boot argument.
> 
> Scan all enabled event groups and assign the RDT_RESOURCE_PERF_PKG
> resource "num_rmids" value to the smallest of these values to ensure
> that all resctrl groups have equal monitor capabilities.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/kernel/cpu/resctrl/internal.h  |  2 ++
>  arch/x86/kernel/cpu/resctrl/intel_aet.c | 25 +++++++++++++++++++++++++
>  arch/x86/kernel/cpu/resctrl/monitor.c   |  2 ++
>  3 files changed, 29 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> index 92cbba9d82a8..31499bcd2065 100644
> --- a/arch/x86/kernel/cpu/resctrl/internal.h
> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> @@ -18,6 +18,8 @@
>  
>  #define RMID_VAL_UNAVAIL		BIT_ULL(62)
>  
> +extern int rdt_num_system_rmids;
> +
>  /*
>   * With the above fields in use 62 bits remain in MSR_IA32_QM_CTR for
>   * data to be returned. The counter width is discovered from the hardware
> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> index aacaedcc7b74..eec5eb625f13 100644
> --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> @@ -14,6 +14,7 @@
>  #include <linux/cleanup.h>
>  #include <linux/cpu.h>
>  #include <linux/io.h>
> +#include <linux/minmax.h>
>  #include <linux/resctrl.h>
>  
>  /* Temporary - delete from final version */
> @@ -51,6 +52,7 @@ struct pmt_event {
>   * @pfg:		The pmt_feature_group for this event group
>   * @name:		Name for this group
>   * @guid:		Unique number per XML description file
> + * @num_rmids:		Number of RMIDS supported by this group

Can append (from XML file, then adjusted ... ?)

>   * @mmio_size:		Number of bytes of mmio registers for this group
>   * @pkginfo:		Per-package MMIO addresses
>   * @num_events:		Number of events in this group
> @@ -60,6 +62,7 @@ struct event_group {
>  	struct pmt_feature_group	*pfg;
>  	char				*name;
>  	int				guid;
> +	int				num_rmids;
>  	int				mmio_size;
>  	struct mmio_info		**pkginfo;
>  	int				num_events;
> @@ -70,6 +73,7 @@ struct event_group {
>  static struct event_group energy_0x26696143 = {
>  	.name		= "energy",
>  	.guid		= 0x26696143,
> +	.num_rmids	= 576,
>  	.mmio_size	= (576 * 2 + 3) * 8,
>  	.num_events	= 2,
>  	.evts				= {
> @@ -82,6 +86,7 @@ static struct event_group energy_0x26696143 = {
>  static struct event_group perf_0x26557651 = {
>  	.name		= "perf",
>  	.guid		= 0x26557651,
> +	.num_rmids	= 576,
>  	.mmio_size	= (576 * 7 + 3) * 8,
>  	.num_events	= 7,
>  	.evts				= {
> @@ -214,6 +219,15 @@ static bool get_pmt_feature(enum pmt_feature_id feature)
>  			if ((*peg)->guid == p->regions[i].guid) {
>  				if (rdt_check_option((*peg)->name, false, true))
>  					return false;
> +				/*
> +				 * Ignore event group with insufficient RMIDs unless the
> +				 * user used the rdt= boot option to specifically ask
> +				 * for it to be enabled.
> +				 */
> +				if (p->regions[i].num_rmids < rdt_num_system_rmids &&
> +				    !rdt_check_option((*peg)->name, true, false))
> +					return false;
> +				(*peg)->num_rmids = p->regions[i].num_rmids;

Does this need a min()? Since this cycles through multiple regions it seems possible that
if the regions support different numbers of RMIDs then the event group's adjustment to
deal with a region with few RMIDs will be undone by a following region with more RMIDs.

>  				ret = configure_events((*peg), p);
>  				if (ret) {
>  					(*peg)->pfg = no_free_ptr(p);

Reinette
