Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 788311CAA92
	for <patches@lists.linux.dev>; Thu, 13 Nov 2025 04:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763006687; cv=fail; b=ZQZ9M6PvEpbJ8wTSgqP1KCT36nTR+wxDiVe7zDzBbbf2RbE7clsMN8ZeKOGcSsX3MYiEw5lQVKNl5Qa33mik7AvzFIdacAkqI8R6REGLzFEKeY6tsPBuZzB8xTkvPX3nR0X9xSn8sUi6cLgxVDi2wT+CHF1zL5JQ4wd79CTdixs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763006687; c=relaxed/simple;
	bh=smQwaCN4bR8y9VSamk+aXKjj9Fp6gfCm7MWvvm5nGCU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ICL479T5GrwOlegjkPkbPZzy5vFj5DVpgoMgC4SJAlqQgZemYCkz3++1h9CgekIimlu5YAOSzWVgSQJB4C4BNYnQTxlu68gJlAlmvZgCmXXDdDCJNPuOxDZzGCPCdiwFqaa0ctmCoPC9vJaMJv26fRakjt62V6wnAbHjePN1bns=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cq3ZBCif; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cq3ZBCif"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763006686; x=1794542686;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=smQwaCN4bR8y9VSamk+aXKjj9Fp6gfCm7MWvvm5nGCU=;
  b=cq3ZBCifVShucUTZvXVFpjyG7YmSZ/YxGTcsNhxbp0a/a+ALwyJ81+H9
   e+pJgbot5zKfxEMNdwC+QwC0g94hwROb/sUH2wf5IEDJ7aVBpe9taMEQo
   TthXnqdtGQPUA7dg8Qx5VwZJ5CSyp8Uh63sMKdnOHBwS+xykXaXhVjdBL
   nVaX4NTScAIxd8oB92h7B7KJiXfo/epb39b88uQHEJl+hUIl9PhIc1KLN
   +bW+/7YZ6sueCaL/NG0EqPs+lhbXmlVr6wQ5a+eExZdhV/DpeZeXM9azQ
   DKsSV5aC3s5wzKJmI0oTnIgFTBmowbP+Cv9mjUdvxxXqe9SXe8eZDssx9
   g==;
X-CSE-ConnectionGUID: fFwlmbxlTgqMFSVKy3Dm+w==
X-CSE-MsgGUID: p8ZZOcVxQ1ySnjkqQ+yhig==
X-IronPort-AV: E=McAfee;i="6800,10657,11611"; a="76541998"
X-IronPort-AV: E=Sophos;i="6.19,300,1754982000"; 
   d="scan'208";a="76541998"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 20:04:46 -0800
X-CSE-ConnectionGUID: mGObXIc/Rva1VxramnEp6w==
X-CSE-MsgGUID: InTzjkzlQF2TLoZc6gUHwA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,301,1754982000"; 
   d="scan'208";a="188646207"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 20:04:46 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 12 Nov 2025 20:04:45 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 12 Nov 2025 20:04:45 -0800
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.42) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 12 Nov 2025 20:04:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ftTqsAdYOKQxy9h7rybP6NrTyV8KMNFx50QQJwUWuQdWvGE1IGPyCQdxND3umArPrACC/dG1jTIiCaJ9x3AMVXGEsKWIDczKmt62OoDeXSOvkiPLWE6susd/prRmaHMK4MPFFc6jWGpU1FqPm4Nwun/EsZpIZKSB/yqwxCueGLChFanFg/JttdJjiF/MYvSTgeJEU8yKNaCTHs6nb7cUNOv2SEIOxvyR6js3ImrDQ0r4MBIjBCEhPptjvtMS5pIrBStZp6T+eUDVCHNGXrmK0Uoj/FD5EZhFxi3eQfXvd31I676+LgF719eNGfNQBtOtCq4ceCBFzuf/XXbsf0c++w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4G79FmJl+K5nSAFBgJ5pbXNzKsE7HC6/BTUzt3Z2wWk=;
 b=uuBrSoVlLZjxqAigZHzWJyod3T2rW2EvnruxKSzrKlSFo1xKFMFi18pc3oTRHaIntgXg5FF3jQwRpk7xPbHJAu+0/hq2wKu2uLI5Y2JMZuUV4Kxqq7pOGkOmfRfIiULWUlhT8IrsVXM73DOvoowFeU1uCewuRL93fOpyNbRI/Qk3CO3DYZ8v1KPxiTjFNw+GM/IMiW+CpiPWuYF9usgTEZIrn08U6SI7XxyrWy4frvZiW5qxovJHYRVSFxaigRsS/S29gCrdlP+6e8TBkOPsXrhpyxczr9XpD0QYoeNZ8IuQvYOBNFIxc0axVWZAPHma0I/XimyPdQKl4VzSqrCuTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DM3PPF341F90799.namprd11.prod.outlook.com (2603:10b6:f:fc00::f19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Thu, 13 Nov
 2025 04:04:38 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9320.013; Thu, 13 Nov 2025
 04:04:38 +0000
Message-ID: <7af0a93d-d4d2-49d4-bdf4-3d8b57fcc593@intel.com>
Date: Wed, 12 Nov 2025 20:04:37 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 14/32] x86,fs/resctrl: Add and initialize rdt_resource
 for package scope monitor
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251029162118.40604-1-tony.luck@intel.com>
 <20251029162118.40604-15-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20251029162118.40604-15-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR17CA0029.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::42) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DM3PPF341F90799:EE_
X-MS-Office365-Filtering-Correlation-Id: 174b3253-4ced-476b-48b1-08de2269c3ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?NFJKUzZZY1BnVXNQaGRtRjh5MXpyYXg1Vm9WSTZ2RlBHWUF5VGY1UVpZemVG?=
 =?utf-8?B?aUM3ZDVYbld4M3kyMGs4cW1STDllNXBNS3pRMmVycWtmRjBSSk5IWVlTRnZO?=
 =?utf-8?B?VEJzbFVta2JVMUlKNkIxbkZvYzBTZWdtVG5XZ1kzbllZbGhzZlF2NXc5VnlB?=
 =?utf-8?B?Sm9qWHlEbmczWll5aEdwZjVDSnliQlFnWlVGWVl0ZnlUcm1YVGFCaWV2YjM5?=
 =?utf-8?B?QzR6THllOFRIMzlSK0VOUFpvZTFVQm11UUE1Yy9XNTVVYjZjZzJTOXpyTjNH?=
 =?utf-8?B?a3dxUkIrS095OHZaMUVGRXV4Y3o2NVZlMDArRi9lWHdLaVVFMy9MWXVKZnhG?=
 =?utf-8?B?M2pVMFUvaVF1aW5BMDRqYVZMbzlFUk95a2txR0FyWWpQc0NteXp6VzdVbTdn?=
 =?utf-8?B?RzUxUHJ1TTFpS1BFbzZmbEZncUZFWHZUZ0ZRcDd4alI3ZkFzVUVPaTBJaVNp?=
 =?utf-8?B?a0VKdTdxVnNlTTRDNmFxV05tR0V5eklkV0pWbXVLaEJ5MldsMHFlK3FxcHlT?=
 =?utf-8?B?a3k5UkxVaE1oMWdpZDVYS01xbnlHR0dSeXg2QTRpUkJHN201OE0xazB5VkhI?=
 =?utf-8?B?VllxWE5wd3hOSUVnY3F4R2lNZWFlUDdQVHU5UjF5QVJpQVNjVmhhdHEwOVow?=
 =?utf-8?B?YmZnRkRYRU90R2hqYVRaS3JxaHRjYWN3N1R2TXNUNmZ4NGxYdmN1L0lMcHZK?=
 =?utf-8?B?K01YdXdXWnJVRktRbEJlQVRmZUN4YXBuQWI1dmpQSHJYblE5SXY2L1poL016?=
 =?utf-8?B?SEFFUWVrcC94NHg5S2xyeXlxajJ3UGtpYTZEeDAvb2UzNDZFK3lLWkRzNHNC?=
 =?utf-8?B?ellMWUpzS24rdHJNbXZzNjJBbURDbDBFVmJQcmlpUHF3SDFZL0x4aXIwOW5y?=
 =?utf-8?B?c3RmOFJZSkY1Z05ETnRiK2RNZlRoOEdJQk1FUnZkRmkwS1QyVG1CdG1OekVm?=
 =?utf-8?B?SW80dGt6QjM1eWFhWWdOK0xRaklvbnBUbVo2YlBZRENpYmJHdjNwOTFETkF0?=
 =?utf-8?B?ZGQzZTJYRk85TFBzeG9pRlJZdXFxRDhOVHdUNEw5SjZEaWpFY3gxY2V0QWlk?=
 =?utf-8?B?R2E3VHE0ak5NSGhkM0F0R1E0YmdVZDdEWTRNSmNEV2dMczlHeUxibmIySnEz?=
 =?utf-8?B?Qll4REZreGRiVVNFcjd5Z0xIcEgwYkpDTTFWVzVwVTY3WVlCNmRCWEFFZG9x?=
 =?utf-8?B?QXppUmlDano3V2F2M3luNG8wMkJJUFRmaEI3clpNNlpUYW43RmdTdS84Z2NQ?=
 =?utf-8?B?TDNXdHVOc0xER2lFYzlZM1VEd3R0dzFKZVAyczI4TzZMeHhDbmYzbno1V1Rs?=
 =?utf-8?B?cStaVFVJR1BtQTNiQVdaZXVnNWdnZ3hVZlpHVEhVT1VmLzMyemN2dVdMYlE3?=
 =?utf-8?B?bHNxUGkwNW5GSzRSbG85d3BRMElzdlhQTVlmelFPOXpmeFBvK1NBQWJYZTNo?=
 =?utf-8?B?YXhPc0lmSVErSFdUQUxibzNFYllXYlhuUjhsdWNFUFUwMU42MzRsckgybXc1?=
 =?utf-8?B?aTV5aWxtUUwwTFk0OEdKdjZXdDNGajJ0M1ZUTEZJNjUrNzlzT1J4S2Z5eERR?=
 =?utf-8?B?a29tYkNOaDVpS3lxTDJwb3ZRYU1sS2VOVC8xV2tnQjZzbnhscUozMTNZMlRU?=
 =?utf-8?B?cFZlZWZDTGhrMUR1OGY2WGVScHRMSUR5RmdVV0dub2Zod0tMektwZmthTzdy?=
 =?utf-8?B?Ri81TUZHdlpwbnpWZnNRN2p3MkV0K2drR0h3OUxCeENzQ05SYWZpeDNoNjEx?=
 =?utf-8?B?U1JGaWMzMG02SFJ0UCsyUG1jM0p4ZllNUzFrQjlwL0xVcTJ0N0FmeXdsNjM0?=
 =?utf-8?B?bFZSMmZYY050ZlNIdlM0TGlmNG1OUWkrbE15UENwZUF3Z0wydmtRbWlhVHJl?=
 =?utf-8?B?d1VQbmh4L0hjbGQ0WFRpSU4zdlhJNzN3TG95ZHN1SnQ2Qk1mSUlPTkNZWUhm?=
 =?utf-8?Q?YnIAFnqoSb7X6T2I+nveuB7F3fzDRe1y?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K0tEc0szUVhwOXczQ203VHdxNU1PazFqdERVMFBEdFI3cTJEeWJMZ3hIUE1p?=
 =?utf-8?B?allvVWhEaEpPNDg0YTVlbjZmTzNGS1kwWWNzSGdwMk05dzhuakJBNTJUMDlC?=
 =?utf-8?B?MUF1RFdpR1F6QmluUXpURC9CZG1Ha09oVjl5OHZseEdMOG0wN1dRYkJsRlhn?=
 =?utf-8?B?bE41WWVzSzFYRnJVRXVTUGRtb0g5SmZLTGlrLytZMndhVXFCczlKcVNFdjRM?=
 =?utf-8?B?bkZzdGRNOGdVRS93bDB2Mi81bHFMMHdRMVJEbUxLQXEzVkt5WkorSlkxV2JB?=
 =?utf-8?B?VHJ3OTZMdWpTcGg4dHRpbXJCY0xPemJWbitMTFY4RzFWMGR2WG9wR1N2bXVi?=
 =?utf-8?B?b2dwWDFuSlBOdXRWVnpiKzlidGpaTmpwbEx6dFVmRUdlbGZZNG0vMDhqeUow?=
 =?utf-8?B?T2ZGVm4xbmxzek50L21DTkpPWkp5enJhc1lBbW9zZGZucklyY2xHanlDa1lF?=
 =?utf-8?B?Mi9vamE0d2YvNUFKSXhWakVHR3YwVzhKcXc4S3BYcUxmdlJ0enptNlJ4RWZH?=
 =?utf-8?B?bkxjL1RrSnhRZ1NGM3B1SmZuZ3NycGdYK1lzT3FHb1BFaWFlcTB1dmVZeWl5?=
 =?utf-8?B?RFlHMFptcTRlVTBwald6ZWh3TFBOcWZ1cGo1SXByRTRaUVJXY014eUE4VzI5?=
 =?utf-8?B?a2NYRDFTa1RLY25rYTVNd0FYbTNURTdoTDcwVm9lM3BHRlY1UFFhMS9rTXdm?=
 =?utf-8?B?QVB5RjJ2VnBMY0NhdDBSZ21qengrUG4zazdUb083amFMNDRMK2xvL0VuTWVk?=
 =?utf-8?B?WHE1a252QWxmV0JOS3hHalRZdkdNSFpDZDdoUkszUU9yYTZEN1QwOElMMFIy?=
 =?utf-8?B?Y2JsUFNtQlg4R3ZnS2RHTHp4Y2h6QnBsYnZ1ZGR6Z0E0dmlRUG9FOUVDVExJ?=
 =?utf-8?B?VTQ0MVBtR3p3dGIvUkZyK3lSK1hxTXlxVWRNQjFzYm45U29pSFhrcnBRdUR1?=
 =?utf-8?B?cDB3RHRFbm8vdUFza2dWNGNXclhPY2IreDdoR1JiUDBZUnJDSkxRWTNHdVln?=
 =?utf-8?B?Y3UrRGo2K05WdFJjZnhTV0JLeUJxL0xrN0hieG84TXVkWDNUSE9GVE10TUlN?=
 =?utf-8?B?cVFXMVlNakNEa2ZUbll4U1pDb0UrTUt1Zks1N3llV3NrWk40NWl1RExTUUk1?=
 =?utf-8?B?RTY5cy9yRzJtN0Q1Q1lVWS9rWVBZLzRyeUp4blNSb2pGTTdkWjdsVjJvVkhx?=
 =?utf-8?B?WEs1Nk1XS2U4SWJNTVJ5VkF0dDFPRTNxOGZqOFVUYjNrUFh4MldZbzB0d200?=
 =?utf-8?B?QnhpakV4dmY4TWJ1VXJhRnRWNEg4KytqUTBNK0hGaGNrN0YxOHk0UFkwbDZH?=
 =?utf-8?B?YzBGRW53MkdzSHBpR3lSeFM2d3F5YWVDQVZkY0FBU2VxTXV0eDkyNHNGN0Nk?=
 =?utf-8?B?TDY1QUEyLzNvTlRmNG1xcEMwU3ovejlPeURJa3FRYkZRbkZaNkdHem5LcGpn?=
 =?utf-8?B?V1pQK0Q0MC9RUnZOQmNzc29iQS9Ic2ZvSEovdE9wT2VRWWhBK2UxMHV5M2Er?=
 =?utf-8?B?ejVhenRlNEJySkhuODFxekFnMGZqdDZscVJ0MVlPellvanAvVUpZT1d3SDF0?=
 =?utf-8?B?a25uaGtOMnVFN212emg0MkgvY1piL2ZMV0EvUnNNbzU2Yng5MklsWXd4UmhK?=
 =?utf-8?B?OTY0YUtSY2xQWHBHbXl2T2IxSXZMbmpoNDBLcmpZdUF6VGpBMWhBbEhPTXJh?=
 =?utf-8?B?V0FwR2ZXR0dIbnpPbmdCTTdETDR5dVo0WlNLdlZJb2xnU0RTQ1ZNank1aXFp?=
 =?utf-8?B?Y1NYQmVsY28wYVh6Y2tRSHd0UzlBVTRWNnB0S3YwazNGbDEvbjF2RlhFUGtH?=
 =?utf-8?B?bEQrNWM3WlhIQURLNUZnMFdxSEFacy9BSW5jcVVYKzFoNVdITEF0ZXU1N0s5?=
 =?utf-8?B?ZDF6VGR6cWtXTisrdzMwQlZyVzF6Qm55MlZ2QUYrZkltRzhtbkFnemdpRG9q?=
 =?utf-8?B?M3NGZFJuMHdkUTk1ekZyUDhLZmF0ZFBieGdiaVluT1JuUUlPMVdzcW10ZUFK?=
 =?utf-8?B?ZEVWK2V4QWNzaHY0V0Vwem14U1BqbklkVFJoMGFRRXRnbjRlY2srS1dKRUgr?=
 =?utf-8?B?WG03azcrakZzMkZWdzBVVWJuNDF3R0YvZWxnRVgvdWRvaENDeDY0bDlSQlBB?=
 =?utf-8?B?N2xudnlja2VaaXNtNmNDb3E4bEZzUUMyQloyc0NiRmVPNUpIdU1sYUovUHpq?=
 =?utf-8?B?RUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 174b3253-4ced-476b-48b1-08de2269c3ce
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 04:04:38.6696
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fnjiklz71jBH6ewlTw3zqh9lzrQ0opkS7P0Ty0u7zpe0ql59HxE2vodQaUTdOCPM6Jta0tSbXjE1kGxdih8ATvzx+1MbtpAOmts+jeuZm9E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF341F90799
X-OriginatorOrg: intel.com

Hi Tony,

in subject "rdt_resource" -> "struct rdt_resource"

On 10/29/25 9:20 AM, Tony Luck wrote:
> diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
> index f5189b6771a0..96d97f4ff957 100644
> --- a/fs/resctrl/internal.h
> +++ b/fs/resctrl/internal.h
> @@ -255,6 +255,8 @@ struct rdtgroup {
>  
>  #define RFTYPE_ASSIGN_CONFIG		BIT(11)
>  
> +#define RFTYPE_RES_PERF_PKG		BIT(11)
> +

This needs a new bit number after rebase on the assignable counter work.

Reinette
