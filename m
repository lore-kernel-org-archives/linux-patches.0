Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 609952E738A
	for <patches@lists.linux.dev>; Thu, 28 May 2026 16:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779984638; cv=fail; b=LE3FwVDuMW0rsbkfuCb6T5uXW6yFEbsJxoLmQesaZ0XLHHRClbb9xZupVzMzZEJhMjnx0wvgfldJIWiuqQB9SG9ohCtXimWeZcYbDBbDhcde2x3syYF9p4GFxut2FxVAckf+UHXPaUaJbhsAK3Ufwfs2r8KJoLb7+paP/48ZpWM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779984638; c=relaxed/simple;
	bh=OgejsFbD0b+AL2Clugdb0Wm809xQS3AtF1yC6Y91ngA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=L6CKnuKzuMK3i8uuNMShrpZt1jPgoathGW2iP6RK3JIOLeMOZO5HHURWxOsSQdiO0T6Ww05DADrJYxWkrPIshk5+DcLQNEYIvzK+WbFYcCnkxeItYOG/JY/G6XrPgePPsVGI65i8gYaX6KmLtTcbTmUTCIiRFs5DayEYHmmMgmg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eRz6kALH; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eRz6kALH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779984637; x=1811520637;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=OgejsFbD0b+AL2Clugdb0Wm809xQS3AtF1yC6Y91ngA=;
  b=eRz6kALHMJEgSxmoQ8r6bb51IQVFUsGV4mMoeZT1H67Mz7yoZlSoNM8l
   peSylsVbRCvX0ZEKiBalZ27eAYo9SKpLNgFE0pSgPguGIyfRPCUo0uLr2
   YqgWefa0E15uav0qubf6C2cwLIt0y95z8ndcsdkpM8G72oFns3w1GSNu6
   QT4SbQBxMt6c5L3mK2vJGKwaPLGP7nSa9A8TQ0IWopUpv0tWhwqW2WG6k
   S8FemcbwE2eLE4OvCuNCcF+IA+7FyYDvshfbsN8Ldwct43h0FBJKs8ffD
   i19HEWQcxarbpN6KDLGJN2fBcplszJRLVn2XvqGIVNfFPPA0t4MH0yDwA
   Q==;
X-CSE-ConnectionGUID: QzpubyWjQuWpGR5AhSp1mQ==
X-CSE-MsgGUID: vql9Me7NRgGbQSHTqx6E6A==
X-IronPort-AV: E=McAfee;i="6800,10657,11800"; a="84718344"
X-IronPort-AV: E=Sophos;i="6.24,173,1774335600"; 
   d="scan'208";a="84718344"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2026 09:10:37 -0700
X-CSE-ConnectionGUID: Hd0waQPnSgKB7XKvE3Jbtg==
X-CSE-MsgGUID: 9bUpBvtwSAaWz3AaSTNtew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,173,1774335600"; 
   d="scan'208";a="236237206"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2026 09:10:36 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 28 May 2026 09:10:36 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 28 May 2026 09:10:36 -0700
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.66) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 28 May 2026 09:10:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lshDACdVsq+ds19LRt3uFjXzfBvzh5CuTfGEzb68S5W8i8oZy8dldJqlfClzU/eTvgZuoC11j3lf9K4JvFJ/P3JsxGNq+BlHJPCJPjsBn9LfN6B0/LpksYgYhdkzqVjWf0bCODmtHfNWos1xSfkXgXqF9ZNtPmjdxWJoGd46wQ49GxgqvZ837//5qhaudFqTcKC+7XgTfMecx5UIo4mRSt8mU0NqepJUgns5bqjqiEx894yOKBFwSITNJdJPZqe89l/YYh7LAaXXHg62UM2x/3Gcj8xfkMqJmVpd66sH6jqG+ccsz3BR9FKQUU+4E3t6Fx4jBZoerXixF1YeNe5u3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lgKYPqci+9rpZB6HZLu93937mgdyaaCSKKsGOf3U9gs=;
 b=daFeIMF+GRP6I/Bnjn21qMP6jKPaSpfC0JoP8FcUGqhQHrRVQGKIEy/mJsA6jw+mb3c2jWAz5WPG9AOcknowGENzfAmjEKugWW0VCNFmrGlqbfM/o4xuJGBTySmQkU3MFqvEb0lvtQaTviyuZd6ENQe6/NFGybk9SqHJclopU0YjvfN/GituDi7nf44i1R25fjb9SW8BgcliB4JgSqmVQ8AEoYwH/LUlZxENIjyh1IOYT86QzChAk85HXxSBOE9j+QOCPeRZThBu0JMqzUSgcQk27SWG755OJdPKzNuHsrigGTwRaQVhMT7on+2qZJHc5+wdyQx2zhrIaAk1Q02qnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by DM4PR11MB5969.namprd11.prod.outlook.com (2603:10b6:8:5c::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.71.13; Thu, 28 May 2026 16:10:32 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%4]) with mapi id 15.21.0071.011; Thu, 28 May 2026
 16:10:32 +0000
Message-ID: <e40a924f-5398-43bd-821a-2ff9873c5a4c@intel.com>
Date: Thu, 28 May 2026 09:10:30 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 6/9] fs/resctrl: Fix pseudo-locking lifetime handling
To: Ben Horgan <ben.horgan@arm.com>, <tony.luck@intel.com>,
	<james.morse@arm.com>, <Dave.Martin@arm.com>, <babu.moger@amd.com>,
	<bp@alien8.de>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>
CC: <x86@kernel.org>, <hpa@zytor.com>, <fustini@kernel.org>,
	<fenghuay@nvidia.com>, <peternewman@google.com>, <yu.c.chen@intel.com>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <cover.1779476724.git.reinette.chatre@intel.com>
 <e785356d9a30047b3a917d78f09b338f0cd2f109.1779476724.git.reinette.chatre@intel.com>
 <4eb7afac-8afa-4b6a-ab08-bee3185f4329@arm.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <4eb7afac-8afa-4b6a-ab08-bee3185f4329@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0369.namprd04.prod.outlook.com
 (2603:10b6:303:81::14) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|DM4PR11MB5969:EE_
X-MS-Office365-Filtering-Correlation-Id: e2fe38bb-670e-48b1-9959-08debcd3a4e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|56012099006|4143699003|11063799006|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info: ir00yvt5Bcg5LYq8XmfC1Xin824wAnqorQljljwkTbpbWxQO5oUqJHULpkzxeIBdwZ6WBu5JwyN0RLeXi4QtOd3jwQDTKFgvjJNG0/Vo/XBRjKuCZw7dTL9zorOaFlJNCy7oywpD6rKqjWs7fI8qnc31jokp1pjRhu+CIjnl7uGgdNkVM5THPhDIO9S1nfDADoBfnlctd7YrxxIsi38kBXILuRbNyGrGJH6bm3LNZg3ISSXmgwWJGfGNOQkBW4YWWso3WuHjIP4SuHNv7BwsAexz14hjKuhglRaKMSCV8qWrFmkYVSsV1xfo8l1oBple7XVGU1JJz+ShsNxuJSmYRZyAX6Ko7xOVDeeB9yfsjR0BvhXKaFUKZkAJxLyT7EtwCvOPuH+xd6wJJ9hHi403+BZNZoTr/+6YOtlLpWMz6Om/htdyXfxzORm8WOghqn2FzGvN7+JKn5mQpyE0ttvkNpdHisMyxHfKeO0ynCqJTgz2JqGocuSiehMzsgxlwsrMkEsknFy86lBiTQr60CqYm5SPyuHzUHSOBSWeigmR1OM0YBE8nMOhCqcOcMeURf+tAp26X/rYVNTgGhTg3FWJqczpSiXG3B+OTpoz0g436seIWmWFiyRXyedq70EuIcefvd1oUN4pWEWXwRQ2IHPxcA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(56012099006)(4143699003)(11063799006)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YkpPR1hmOGxTZEdRSFJhZlZhNVJIN0dNT0xJQi9OSFFIcGdXOGQrdXpQa1ky?=
 =?utf-8?B?QytOLzZrSWNkVkpBeGY5R0ZGdTVRZkJBc25MTHZtS2VvMHZVZW0ranViK3ZS?=
 =?utf-8?B?Wi85dUVJMUVyTEFCM0t0WFNPaExwZGU3OGN0ZTVnQVpzbUVqTmhzVysraE1R?=
 =?utf-8?B?enhTYmJLOFlXTTd1NlNPMXc0V2JrVE04THVpMXRRc0g1Rit5NGZwN0QzODBO?=
 =?utf-8?B?WWJvTzNoanRLRzZtNDZwSkY4Ukl3a2huSmhMYnJoR1daV1BTWUEwN3ZlckMv?=
 =?utf-8?B?ejVkNG4wVHZSUmM5eVRpSGlJQlNPSkFIRXdnU1QwcWlTczdHeXY0L1lvS1JF?=
 =?utf-8?B?NGcwdUdtMlZSdGNtQUFrZEsrZ3psRnM0eXhFeTd3MGU5OFVBVWEvWHNRMnF2?=
 =?utf-8?B?OU1OWTAwZVpLWjVLWUhXb0pzSFhiTWVzdzVWdHBxZTRmcW9DejdwK2pTMHFv?=
 =?utf-8?B?NStGaC9XWEFFbHRCY004Rm5FN3RKWGU0SzZ4SExpMVFHVS9wOGxmdGRnQzhH?=
 =?utf-8?B?UnlUbGlTYU9OczRaci9vbEswcmMzdmVMUlNsUHFlcmlvWmVxUElVdmhtK3pq?=
 =?utf-8?B?RTV6WkVHUU9VWDZ6SnRvRVlqSnBKZ01xdmNaMGhYQnNDaS9MQ0NqZVJHRHFh?=
 =?utf-8?B?Y3dpTkNpNTFZWkNEWndHRWJvNDBtdFlPbHRUVXowUGlicjBtbXN0bW1scVhx?=
 =?utf-8?B?Q1VIcHhwRmpDZUUvUlYvckxaLzk4RThya3p4amU2VVAwMmlWUmk5VGY5RWpM?=
 =?utf-8?B?SUlpYmdyMExUWWtDSDlJMk1zN3AzWENZdWp3ZVZ2MHBTR1IvV1hGZDdpeno2?=
 =?utf-8?B?YjhCSHR6WXZndldramdyRXpNKzZocXpwUVRpdDJSMDk5aUFobi9xLzhtNDlR?=
 =?utf-8?B?SjNhMHdjUjF5VWRzVzlOQTNwOWNRbUhWQXZaSzNxdW5GejlHVkE3Wm01dCtV?=
 =?utf-8?B?VTc5dy9ObDdlQlNYU29GOGxpamFTdHBoSmhWaWY5WU9ZczVzS09hQldqSmxT?=
 =?utf-8?B?bUxRekw2K0JON1FseWFYM1d5NWprcE5mVnlxc0VQTjVLcjJjazBxZTVONEg0?=
 =?utf-8?B?TzZGenpvNWRiQlBOdDNIeWNERVFLbmhMTUNuclR6ZE9TVHVabWRYLzB0eVRt?=
 =?utf-8?B?aVBpaEJscllVWmNqdUlHYlJhdmJZSnhDaHV0RU9XOVhpaUU2cDlQTU83cWFD?=
 =?utf-8?B?dCs2cm5UM21RaElYVzNyazBjNSs3TnJ0dFFnaTMzWFcwVXRFNi95aVI5cktB?=
 =?utf-8?B?eW1idVdWcVo3SCtjblBmUWs3SGxLeXpjTGpzZ3FFZ1dQYzJXY0VNOG9RVU1q?=
 =?utf-8?B?SGM0cDVjUHYyb2hDQi91SmpXcENmMkNxQldNTUtjTGdPTldsM2I1LzVOL3FO?=
 =?utf-8?B?SUlUZFRPa2dXQXRRUnUzOTk2YVR2WDFpU0dUK1JoRmtJZkYrUndMUWNNeGY2?=
 =?utf-8?B?bHkyRFdua1JTS3BXR3Q2cFF0UUpRZmJ3d1hTMlhVRFJPd2ExaU9OQ2oyQm1y?=
 =?utf-8?B?VDhLSk5JOWozNVgralVuZmpwbmFYZEdlSHY4ZE5OU0V0d1ZWeWFXUmlPWHg1?=
 =?utf-8?B?MnU3UXZxTmdkcHZJb05Lc21rdHc4eXNSamFpTmhDRlNnWmZucWZFWVVrWHZ4?=
 =?utf-8?B?cGpMVlRLczJ3dWY4S0wzSXY5N1Z2b053a0FQV3d3OFN0bEVRNldxOVA3dnlJ?=
 =?utf-8?B?aWVuclI3QUlrKzYwMmh6aUlvWnRhdmoyYjdTR0VST0FoZXFTQ0NQUUVSK3Zs?=
 =?utf-8?B?SnJXaWVFTE9pOXlVeVJkVWR4MmJ1OHBmU2owL3J6UFZNMzl0Yi9vdjF1T1dR?=
 =?utf-8?B?S0hIN0FJVUpaNWZXaXF5OVFaVmcvMndHRW0wOUtzVUNseG96V1RDaDl5VFMw?=
 =?utf-8?B?Uzl1allrWWttd3o4eWU2VGNWdFpXd1BlaHorR1VIZURqQ0pSTUF5bUpvdTNH?=
 =?utf-8?B?SzdTZWEzUSs3QnJGZS9YYXNMZWF6eEQvby84NHh5MFB0M20wa2RkbFVnR0VO?=
 =?utf-8?B?QmlXaFgxdy9pL0t1RU1vNGJEMTdqQmQ4RFNZUGJwRjZZcUVGdXE5c1V3dyti?=
 =?utf-8?B?cW5TTDRsand6aGRNVlE4emJreUxjMWE4eUE3YjM5TnpuMmptL01YdmJiQnJS?=
 =?utf-8?B?L2YyMEd2bmhQV3RLWVBIdHhDTjliYTJEMHpZOURqK2N2YTRTMi9YK0JhZmJk?=
 =?utf-8?B?eWNWVlZjcTd1M0ZvbnBtYUs5MG9PS3RLRlBxcjQrVG9oMm9idWpuWm1LQzVo?=
 =?utf-8?B?ZFBsVHlMcHJIZ3pLcHNhRjNqaStxTjQweGUva2ZCcjdWQTkvNytTSnQwNEs1?=
 =?utf-8?B?cDF5NUV0V2ZDRU5GaVdLSCtmb3Z1eWxFSXNSVVlrQ0ZPMDFtZUZmT1ArQUJG?=
 =?utf-8?Q?SxW3AQPxt548HyYY=3D?=
X-Exchange-RoutingPolicyChecked: iFQRepbhhjO1/iuaT0vJU1ZFnZ5HAc3hg78WO3aJNi/SFKQjQMV+Jp3vIIXV63JDh257ElhjFpX3vHtUZkQuOkYwu7IYIfm5jL1pePVtutscuULmdvQ9jRWghfaxGIam9aO6TIP68WZopz6cyvmDSxaQxKHdRjy6uCetd8I7M15VSXbF3oLyewdCSzUW7mXCwDZuhCWXsCdkvJQwxs5W3DG2aJm0JGWs5vAQrTuBuBnnvvUWnpbqMo0dHP4XaevxwkCg3s8bt+JLV4P+90xJn1mwjPzw88eRd+5umyAp/0do35lH9NU0zFhWnxI8f77QXyR3HO4cbopJjcA/t3/MRQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: e2fe38bb-670e-48b1-9959-08debcd3a4e5
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2026 16:10:32.6771
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HgFenjsif8r8z1vKYFV8AyapIOmgQ3oux2Zj5nOf8ABFBzb0pyyiBBzoh1DIX6cptXjQgh+bpUAhIUSxk9LEDcVVLrzW6W71rvFfgtbFWmI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5969
X-OriginatorOrg: intel.com

Hi Ben,

On 5/28/26 3:56 AM, Ben Horgan wrote:
> On 5/22/26 20:15, Reinette Chatre wrote:

...

>> diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
>> index 48af75b9dc85..e7e415ee7766 100644
>> --- a/fs/resctrl/internal.h
>> +++ b/fs/resctrl/internal.h
>> @@ -234,6 +234,15 @@ struct rdtgroup {
>>  
>>  /* rdtgroup.flags */
>>  #define	RDT_DELETED		1
>> +/*
>> + * RDT_DELETED_PLR is set when the pseudo-locked group's infrastructure
>> + * (its associated device, debugfs files, etc.) has been deleted via
>> + * rdtgroup_pseudo_lock_remove(). This can be done while there are
>> + * references to the pseudo-locked region since the pseudo-locked region
>> + * self is freed separately via pseudo_lock_free() after there are no more
>> + * references.
>> + */
>> +#define	RDT_DELETED_PLR		2
> 
> I haven't had a proper look at this patch but there are a few places where
> 'flags = RDT_DELETED' is used rather than 'flags |= RDT_DELETED'. Are these all
> fine?

These "deleted" flags are not independent. The pseudo-locking infrastructure can/should
only be deleted if the resource group has already been deleted or is about to be
deleted in the same flow. This relationship is clear when looking at the RDT_DELETED_PLR
assignment in pseudo_lock_dev_release() and rdtgroup_kn_put() where RDT_DELETED_PLR
setting depends on RDT_DELETED already being set. There is one place in rmdir_all_sub()
where the order is swapped with pseudo-locking infrastructure is torn down first,
thus setting RDT_DELETED_PLR _before_ RDT_DELETED. This is why rmdir_all_sub() uses
flags |= RDT_DELETED instead of assignment.

Even so, the issue [1] reported by Sashiko is real and how to fix that one is
not obvious to me at this time. These issues uncovered so far are races that can be triggered
by user space stress usage of the pseudo-locking files that is only possible on some
very specific ten-year old hardware. Such usage is contrary to the pseudo-locking usage model
so I am currently considering pulling this fix from the series. To add to this Sashiko reported
another [2] issue in this area while reviewing the resubmission aimed to get review feedback
on the last three patches.

Reinette

[1] https://sashiko.dev/#/patchset/cover.1779476724.git.reinette.chatre%40intel.com?part=6
[2] https://sashiko.dev/#/patchset/cover.1779834897.git.reinette.chatre%40intel.com?part=2


