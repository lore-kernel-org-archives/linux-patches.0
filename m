Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1923E3E49CF
	for <patches@lists.linux.dev>; Tue, 21 Jul 2026 16:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784650470; cv=fail; b=eGiVD6MTGK0Gr+XxQThlTFuinJ0fLatob6pVVj3M7P2fGMn5UWYis30NmE+g8cO8JdquFzZz9i/rRh98YZRIXS9e5dmQIS8ro+KnxylONKwR+JzCTWG5QkqyRzfe9B850CZoNFiuQRAI7tnP1ADWw9uiyk05f/nkiFsxwOuHkc4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784650470; c=relaxed/simple;
	bh=Ny8lbCQ0MrUw74aqq/iktG2ri7rWuNRlq4aW/KW4lIg=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=scBY5Y9dEHk454doLpHaIwiw4VOQhHxpYMsCSI5cNVHZhU3S0m3R1MUbRbDVqFkG7PPtNAW7rQD8BLZr9NNdMQcCDFEoV9hRO4F/udxshhfiwbr2mChidBeXf8E3T6Di5kL/wGBSmKKlF2ITCVguApsk+3SVUtRrArYsWjHm6gM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bBmw+7S6; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bBmw+7S6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784650468; x=1816186468;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Ny8lbCQ0MrUw74aqq/iktG2ri7rWuNRlq4aW/KW4lIg=;
  b=bBmw+7S6NvVcOJNtsyXMbg4VmXsqkonWgmBdcOMa+zmVt5y20mrvOJlg
   a7IuWPuH1xp2or1RmJUIiHIL5ge2mWtUujA5nc3o6kkBL2lfBw9JPfiD+
   gVjBQ16azj8HbF8L0krPwJ3ypnLksxAGnLOoNJwfU8og99JdKywkFrlP/
   eA5/vfuPLjzO5xOc+4zaAbPubRpU/IrNbtvTrUUico/nifutifVX2G3vn
   574+Xo9PqUhcc8XPMNHyOaq0XLfzYeTxYuW5NdOiKQ/jj68vkLz6yuwJH
   cE9i8Wm/i8NX9pLM7GaXUtmqN4/LqPwtAQBPcBevSrg/uHZ84+skwcFD1
   w==;
X-CSE-ConnectionGUID: JVHSR+tjRfGMxISbYnDAvg==
X-CSE-MsgGUID: h6A+Aia5SAiJQVPqt52m5A==
X-IronPort-AV: E=McAfee;i="6800,10657,11853"; a="96391923"
X-IronPort-AV: E=Sophos;i="6.25,177,1779174000"; 
   d="scan'208";a="96391923"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2026 09:14:27 -0700
X-CSE-ConnectionGUID: fWsSTe4gSN+i7JaOjUqkDw==
X-CSE-MsgGUID: M+wLnVWURwO7AdMk0X9ZPg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,177,1779174000"; 
   d="scan'208";a="262090060"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2026 09:14:27 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 21 Jul 2026 09:14:26 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Tue, 21 Jul 2026 09:14:26 -0700
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.37) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 21 Jul 2026 09:14:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ml11a0wwUcpWTZOhSZac0qtNtUbmJbpjN2e5Z0PVl7Ly3dcDJQctPNmu5ZKrfdZ3AUkQC0vhN2UjDkGMOiDiJxy9cIN8BEpy8/LR59927F2IRFyPzC/ZvyJChH7bKXjTPGLTKMHtOBaT5D6cAdQrN7YSqLym4B3TSPjUmKZKusWTgKV/0oIH1R1EZaoiojuYLZjI8i+4lqbyPh39mGfXiEQtqngfj9xxajhTnZJ4dC3J2+gHndha3muRpYe5j7DYYBevx3mnHtYGthFeWVbNCm7TPAlMNktpbWX4jFsvx+HxYZMOKK38cwTEB96BKXUo5MTtKohrm7ZlcGTcoYpmxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NtT0oiu8QDFLT+HypjVJYToPea5H7s+/ffbPqNKKV0Q=;
 b=En1m5fycbV4KWebv0GJD5S0P9gatXEr621Bn9ZigzPIu14LHpIorT7R94zjfr++UcjyYoofrFx0c23lDrAiPIlFmpcmTADS4h8DEYxKurLw5q3GAdyvJNoMwnmhGHoOcTKiBXGet00OXWYPNqaZ76ugjjEjfQ7zHxle+nq2JLh8zcuVIWHqU03kxh8vaPEiLNKw6NU9u3VERqLeELHZTaFgEfJ2h8xyX3Rk846tUKrEGi4/5ydeptG2Tyr2fYHJ/SCDodrDWjhJ3t2wFCL79Y+D2r+MKRifkxNDdtfO1QPp6CPQ4fjA/XIZcD7weHozZlAVJzbVkq+QJcyC9arElrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by DS0PR11MB7359.namprd11.prod.outlook.com (2603:10b6:8:134::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Tue, 21 Jul
 2026 16:14:23 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0223.017; Tue, 21 Jul 2026
 16:14:22 +0000
Message-ID: <2184678d-1b67-4d2f-94a3-c4bb22823cd6@intel.com>
Date: Tue, 21 Jul 2026 09:14:20 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 02/10] x86/resctrl: Protect against bad shift
To: Borislav Petkov <bp@alien8.de>
CC: <tony.luck@intel.com>, <james.morse@arm.com>, <Dave.Martin@arm.com>,
	<babu.moger@amd.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <ben.horgan@arm.com>,
	<fustini@kernel.org>, <fenghuay@nvidia.com>, <peternewman@google.com>,
	<yu.c.chen@intel.com>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <cover.1782857711.git.reinette.chatre@intel.com>
 <bc6ec5102227b4617265e015ce84335a8e902bc6.1782857711.git.reinette.chatre@intel.com>
 <20260721015959.GEal7SnxxR8D3801cr@fat_crate.local>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20260721015959.GEal7SnxxR8D3801cr@fat_crate.local>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0282.namprd03.prod.outlook.com
 (2603:10b6:303:b5::17) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|DS0PR11MB7359:EE_
X-MS-Office365-Filtering-Correlation-Id: f9b816f0-0d2d-4356-b3c4-08dee7432074
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|7416014|18002099003|22082099003|3023799007|4143699003|10067099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info: Ag2L3oR4JaoMuI30kK9o6irTvw5+KBcwCC7SzIJyWaLXgj600p57cWshxCN8MPmW4I2P40XFEm/GXskcudPtqzOfijf+ho635ForHqXnP/ptDTcycoBWUBNyAYCygJjLats+KGjWShyEeF1vgqHXZfoPB4g6CqBggJZAm4sZu5X3YNG//O8LQTH6z2mWhxK5r3DazFI5EizVxJR4v72t2mqfAuFuLSDCY8nyglc9TDAohwbwZYNvL3my143W0x0WiAFF29vjRozVonFLa1S5i51o84Sxrp//zfrh4kViE5HJJLqlSOOmRcaaGaf0JWVBC78AK/AFcTeW9dZULn9jFTXKVkuZBPDLXJOFzniluK3TrDGvz2C8CJdqHe40aSap3GYp7xCSX2G1zHXUw0xOOQ1Rl53emXx3A5Y02+8wPitwMNM34VT3mXjZbgLShPxnw9PHAyYkgi4EI2GXnAkkq8Q59Qden+i0ltaHaI+QBDlN3kK39IeI27fL+Oe9xlxi/yCq+OE4wS4wvmv9Pgoj6JikoARTBlayh8cIk4lUb5E64ma3M/9CUchV8SnItCGDfMIg8QG+ZWKGmEy39gFTTYFX90C5Vp89WUh5AOq8xRE70OEkSjwjdqVYQyIGcgk6OCD7xoSrThzeokchRJHIB07I+WJoTJ8UUmacQccbD7k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(7416014)(18002099003)(22082099003)(3023799007)(4143699003)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZnZxZEM0WE9HaVdOWTM0R2x2YWRiK01KTFl6Ykh1ektxdzgwMVc1TC9rNDN6?=
 =?utf-8?B?MEJka3lVTXppU3hRWll0NklaeFhoTldxVHpBL2l4ZTIzZVlEQWhWVy85RUVL?=
 =?utf-8?B?QWRjNmhpU3VFdkpnc0ZIWTBQVkZOOFIySzV3akRmY1FpZXlIZGFoQUZPTzdO?=
 =?utf-8?B?ZFllZkgycWZCTTNPSklOQ2hMNTJ2a2JkWkFCUXFTMmtDcnR5dEpoYUtVZjRa?=
 =?utf-8?B?TXNQU3p4UjZLQkEwaS9JSmM1dENPZzlTaEJQcC9CVzdWekY5RTMvSk5xdkc5?=
 =?utf-8?B?QUJsOHRMSHdMMTJkQXAyQkpCMWFpSGdqS0o4b213Yk4wK2VHcXdub0k5bWla?=
 =?utf-8?B?WXFNb3RTZlRBWWg4ZTF5MUxkZENycjcyQk1iNVZ4VDNtcTRMM0hqNVl1cnc4?=
 =?utf-8?B?STNyQVpCN0dTNVhhV3BRTFh6ZFJKT2Y5YVo4RHRMc2hHZWFrVnhtWS9Td1hZ?=
 =?utf-8?B?dHVQVmt3czhUTTBCTytZcnl4amhBakZBdFZyVEtzVnhFeExHdFhVV0RrOTZi?=
 =?utf-8?B?dmlpbkdaZ1RMN2d1R0lXMDhKbEdxTzFQdXMvQXJXTkw1aE9qVGVESTJxMFd6?=
 =?utf-8?B?Yi91c2Z6ZkdNN1RRS0VYUDJvMVZpZ1VMamFabDdRdFk4L1FNOWx3R0VQUnhD?=
 =?utf-8?B?VzA3ZkVjT1pMWVhBenMrUmdOQlVZU0F2VFc4bVhXSUtYU3dhcGNXZENvV3dl?=
 =?utf-8?B?Qm54cVdxV1NjOThCeVU2cTVHaXgvNVdreGxYMDFzRU9QN1ZhYjArZ0w1Wm50?=
 =?utf-8?B?bW1XeWNqa1F0eitvcWt0cU5kU09XcEhUaWRZRUlRUFV6K05vQ2hsYmxzcEN2?=
 =?utf-8?B?OE1NTk00eGczdU5yT0J6d3JuY3A4N1lVNVVxTmFNWm5CWjBTT2E4Z1NrenJr?=
 =?utf-8?B?SUVLMFM1dkExdnNOMUE5MW9uVlM1elNtWXBjY2dNbXhSY0RDcjJVUHJ2RlpG?=
 =?utf-8?B?WXB6VTRJRjBHcUFFMTQzTGtMTVpNRElob0xLeTVQVVpNME43N1ZVZjFFWGhK?=
 =?utf-8?B?c09MNkx5by85REZwV0JQV1lYblhKeGdQK0NhUEluYVY4Z0dhUnd4YVZ1T3hI?=
 =?utf-8?B?cnM5ZStCajAwbG8yNmpiWklEdHkwSHEwZHJ6RVFxeWNxVnJReFhlREsvYUxH?=
 =?utf-8?B?cGMzNGRma2MxcGh6TVI1dHZ2N0h5VG03RXVtcVdzZXlnalNCcmdhS2JLRmg2?=
 =?utf-8?B?Q3JQOXA0NDRzeHdPTVRUV1NhMzZpUHBoWjFZbWxJREx4WkhkQVBDblJiRE1h?=
 =?utf-8?B?YXArQzhLT0psTyszQnU2Y254dS9yUTZSRkh2eER5Z1JRa3dQcmxuWC9BVzJm?=
 =?utf-8?B?VlVLSnN0TkJBL096SWRxNUhWcDdIeHJrRG5kVXhFSXVaT0o5cWFWT01TQlFH?=
 =?utf-8?B?R3pqaUMvd3NJTENFT3Q1SkV3OUhsbTV4SndWOHBJV3ZwSzdjQ2tBQStvNjl0?=
 =?utf-8?B?a0NROGEwM0FXUTFCVjYvZDZzNVpLc1d2aE15MHA1a1Z2VVBaK29lWHA5dHRq?=
 =?utf-8?B?ZThHdFl6aDMrUFhZOFJnK2lQN0g2eSsxWHdyWDBQTkovKzJOV040bThOaHJ3?=
 =?utf-8?B?UE1rWUt3RWdaNzkyem9sMnFQR2h0RWl0THpGSkdOdWlKZXdTY2k3c0Q3MWVC?=
 =?utf-8?B?RzBGTkxQYjdpd2txemYrZGlUQ29rQ2prbTJHUkdMcWpwMGlrWFlweittS2g4?=
 =?utf-8?B?WVU0OWRSNGdZRVJzREhzNjEzSVhHd1JkOXFSdzJHZnhHUW50VFh5QVZheDZD?=
 =?utf-8?B?QkNBWE1ZekhSc0xvWHc3d0pUS2hpMmhBRnRiaGdsVjB3WVhZY1dJamdvT3Fi?=
 =?utf-8?B?TkFjVFlpaThyUHY0SnNSSTltdnR6RU5rNVUwZUFnZ093TWpIQWtOT3lMRkg2?=
 =?utf-8?B?UzN0Yk9mVlU4ZTlSM21UK0tDNFdEM2VVMWxCZTVoaldMY1ZseUxQZWd6YW1J?=
 =?utf-8?B?c0Zma01nVEQ4L0RjRXJxTGhBczMzSFZUUVZKdXIrTkhPM3pFUnVBTFo3YWV4?=
 =?utf-8?B?VmhsRFhBbzZXN21yTGlaZjQ1Tlh6WWNrUjVaVDJMZ3lxV2lRUjQ5S1dLRzV2?=
 =?utf-8?B?amtyeGpxZXBjNVdGbHdNaTVCTlNaUFNNNGZ4ZHBaakZOd2U4aHllcndGMGVu?=
 =?utf-8?B?bVIxaUg5TlgrdCtpb3F0ellkMDJDVWUrWXRsdm5ibmJuYWNjWHE0ZWl2UkF3?=
 =?utf-8?B?eWpUb0Y1SVpicm5TM2hDaXZmWndwcWM0SGVmbzM4MnZEdTFtT0haNHhiL2xL?=
 =?utf-8?B?ajY2dm53L0IrdUJkdGJMckFXNDlrYnNxZFRvL3ZHK1V5U1Ziem83THBwWStH?=
 =?utf-8?B?NEhtUGwvdm1Rek5SREZETEx5Mm9RQU9jYmtvVTZGQ2ZjSkhkMkY4RkpIL0Nx?=
 =?utf-8?Q?vYL7OoEf/sEIIwlo=3D?=
X-Exchange-RoutingPolicyChecked: lQOm9B/SjPCEWDShG7p8E3ESMAJCjrGgS4qws/Ot5k6cuIiGmC3keVgjmCwKAcWbkDwEAOw1MBMzDV/aKVE9eJ8oYo2aOnL+Oi7KFBaw9X0OdDiVizpRbr1mCvuyoMno4LNc68Q78un+9242sFTfDsqiP0k8XrcWZ79DKLxcejstzRvyDZ6HzPypK7mI4tEbhNSwkUYTGjW/NRIIEt0CPweglpx98kz5m9Uhs4zIZOukEFD5q9mK4sTXjCGe4qjLWk+7kmPRw5zQnP2D4htJPgSNduAN6IfJUpHcLv3qkP8pIf9z2WG3Jm4LzE13HA8sSMJL0mibxef87Bcn7DO/+w==
X-MS-Exchange-CrossTenant-Network-Message-Id: f9b816f0-0d2d-4356-b3c4-08dee7432074
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2026 16:14:22.8034
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YIZ/3l0/5tjG6BRP0ReKo9s6BGJpol4Yjzh5COJZBXEmCZs70sAD5ksRLDezDrnRwbljiSq5Aa0O3UrsAFKtQ8S048pcHsVMWzK1zOpnj6k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7359
X-OriginatorOrg: intel.com

Hi Boris,

On 7/20/26 6:59 PM, Borislav Petkov wrote:
> On Tue, Jun 30, 2026 at 09:27:02PM -0700, Reinette Chatre wrote:
>> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
>> index bca782050198..9b9495174041 100644
>> --- a/arch/x86/kernel/cpu/resctrl/core.c
>> +++ b/arch/x86/kernel/cpu/resctrl/core.c
>> @@ -247,7 +247,11 @@ static __init bool __rdt_get_mem_config_amd(struct rdt_resource *r)
>>  
>>  	cpuid_count(0x80000020, subleaf, &eax, &ebx, &ecx, &edx);
>>  	hw_res->num_closid = edx + 1;
>> -	r->membw.max_bw = 1 << eax;
>> +	if (BITS_PER_TYPE(r->membw.max_bw) <= eax) {
>> +		pr_warn("Unable to support hardware's maximum bandwidth\n");
>> +		return false;
>> +	}
>> +	r->membw.max_bw = BIT(eax);
> 
> Why?
> 
> Why go all the effort if the field can be 64 bits?
> 
> Why not make max_bw u64 and handle *all* possible values naturally?
> 

resctrl does not support values larger than u32.

The value represented by max_bw provides the upper limit of control values that
user space can configure via the schemata file, which in turn represents the
control value programmed to hardware. 

u32 is expected in several places:
- Parsing of user input in bw_validate() is done via kstrtou32() placing result in
  "u32 bw". It is this value that is compared against max_bw and would thus need to
  change as a consequence.
- Parsing of user input to schemata file via parse_bw() places parsed bandwidth in
  "u32 bw_val".
- Upon successful parsing the control value is staged by resctrl fs in
  resctrl_staged_config::new_ctrl that is u32.
- On receipt of programming request from resctrl fs, the x86 architectural specific
  code programs the control value to rdt_hw_ctrl_domain::ctrl_val[] that are u32.

resctrl, from fs to x86 architecture and now also MPAM, would thus require changes to
support these AMD systems. If I get the math right this will be systems that support 
1073741823.875GB/s and up?

If resctrl is required to support AMD hardware that can return up to 64bits here
then that requires more changes than what I am able to take on at this time. From
my side I prefer to stick to this resctrl safeguard for the scenario and leave support
for this hardware to AMD.

Reinette
