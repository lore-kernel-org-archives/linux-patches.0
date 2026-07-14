Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F2F1271456
	for <patches@lists.linux.dev>; Tue, 14 Jul 2026 15:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784042321; cv=fail; b=ZTf7cVysUXbr88meuwqm+yiPyiwIaW4e0CXwIdxfJ7sQzUMEcmyGfXZ9FjK0LuiNsvokJjixgh+UjCM/twLYRPxAeM1Ygd75YpGmYQJh7U0BbGLI+mIneDWKzkaQ+JMVWpU8nOfuoMjuoy24sWHtzvDJ+ledXx8jt/JfbGn6ICU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784042321; c=relaxed/simple;
	bh=uu/DzqOLpjONcEIYGftQ03lF8OZHgRO4MtuHMuWerbg=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=P8Ta8e1tc8YHnatUrb3ytK49ENXekyPR+iWTWFMk7DVwcfm/a4veNv/bnKUneMtPa7ZpLp2juB9poJYpYjbeVP9cxaCb3jTqg56kJda5bgmyRM56HN26QfkhoUKdxOD5fcbNkWVO3npMzrkA0ZdUYYi23zOLC8U45qgDMrfU3Nc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CsY5iimd; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CsY5iimd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784042319; x=1815578319;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=uu/DzqOLpjONcEIYGftQ03lF8OZHgRO4MtuHMuWerbg=;
  b=CsY5iimdkQDpD1gwyHOWP2idS+FOZr1kNvdlEB7qoTD4b+YLHm9GsjFP
   aW8BLxLxUsxwRUFgpBAyBDUQXiILWaoMJP4EZEMbxPBxwpt2fxiuXkj8M
   lJU5XXwRDAHCL8Ytsd0L24KHkzRPoVfHrlUjltZR5FzS2bAHsaQRO9iiu
   5jncvOkC+q+sgqGyT7Z+pr725tDO8PWoecNvzZNuAnItFBf6+lLlE6GT4
   IhEiALL8o3vIfBqKonDMo/QkGiqrpgDlS6DcbDvDhbj9RT+Unnz+VpfGL
   IMdUCOH8ZhSoO2/EjeJyYP15EZZSmJ0bazVrEIM5eN+rGXHzyKvpK89Xi
   Q==;
X-CSE-ConnectionGUID: uUFeq9h6SKmoBOkhMIEshg==
X-CSE-MsgGUID: IT+OEwHHQTKhks4O2QCFzQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11846"; a="84521586"
X-IronPort-AV: E=Sophos;i="6.25,164,1779174000"; 
   d="scan'208";a="84521586"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 08:18:37 -0700
X-CSE-ConnectionGUID: gwc6gF7LRLuUcFTV49S5uA==
X-CSE-MsgGUID: NLyKJeeTTeC+JofAKO5z8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,164,1779174000"; 
   d="scan'208";a="255389751"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 08:18:38 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 14 Jul 2026 08:18:36 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Tue, 14 Jul 2026 08:18:36 -0700
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.19) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 14 Jul 2026 08:18:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qrW8gANWzBX+QG8xydFd6rBm3ac1uFiRQhbdNcxh6ZKS0Aw36wwEOm3MsLjxD1/7hwuI5rRlyY1QesJwxMW8ftOsds06sXx+/E5l7Wo5/5qsVpPfUvfAIRviTwQrxN1APl2KVM5ht1rnExVgx6Fx87oLklOG2jK0WiLZQu3yooIQHh4FwdDsmno5cW/iP9xNy4iuaVMJhQF9HDAeCYldbuQ8S00nLnkfok60IKYqe/42M4Zlu6qHjnRFTLQsNx0h4wK1q7yVoXu6kqQuDOAvSOuq2Z5UNHlNwa5VVFP+SdEnYRr99F8WePWLcjZ+hJi3xIWu4nrkUnNX6+juJdN3aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NnTqXjnQLgzzmsCJ6UNLn1+2Oop/6QhlMaK3DuqvxyQ=;
 b=pBNDb2jKJVBtyRkCby+45Yrx4nk2Tiy/dfFgzXb1p/dCMq5QMUnngwItsSHtO3/XD9hB7om15eXO1h4r3YvR6KX4O4GvKyTqoV3dv4YtxWy94mFcLsiWkcFid6p6ro8SAyYaGYevcmDEDlE+zjm6KM7cdhol9OSOLwoDx2IjYlPeiznaGDAotty/ZzuYnpMYaecHeN5Mgzvv8TTGEuQFdgaBf7CZVH9t4v5brMQjLZDZAMfspagH4Zyz1kyDU/90XcFyrw1l/MYOrauQywR5SX7VnOrZriks4qwSM2l8dniNNwZvLI3EGYwaLzQoaTFbDW7NpdW84P3rn+TEVq6Kjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by DM4PR11MB8090.namprd11.prod.outlook.com (2603:10b6:8:188::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.10; Tue, 14 Jul
 2026 15:18:33 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0202.014; Tue, 14 Jul 2026
 15:18:33 +0000
Message-ID: <e937d05b-8381-4d4e-bc36-7165a7214694@intel.com>
Date: Tue, 14 Jul 2026 08:18:30 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 06/12] arm,x86,fs/resctrl: Handle change in number of
 RMIDs on each mount
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260701213553.15222-1-tony.luck@intel.com>
 <20260701213553.15222-7-tony.luck@intel.com>
 <06cdd789-bf1b-415d-a588-b72938d3b0dc@intel.com>
 <alFbX0tItMg9CbB5@agluck-desk3>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <alFbX0tItMg9CbB5@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0162.namprd04.prod.outlook.com
 (2603:10b6:303:85::17) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|DM4PR11MB8090:EE_
X-MS-Office365-Filtering-Correlation-Id: d66ae809-c2e5-4444-6ce2-08dee1bb2aef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|23010399003|6133799003|56012099006|4143699003|11063799006|5023799004|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: 3N2/5wh29Nc7z0tR5Z4zFwme2KRTgXarHzMWhbcYj5bp9fam5nkXYyYMYAKQ9urwMgYseUp1tzj4WVVY5X67BF4uwd/fyahvPTkWp1EDockx2O1QApUpCUVDnISuzVX/6398k6hA58ErY+JkvjjbzeE6Zqatyxr8GGd9C4kwZelECzwylcvGNqdzsgpN12esNhBwKlf2Z3a815UMr0GEpfPndVql6bUxO1Lu/DbdRdiVmtRGjOuc7ER6Gsp32WgdGy91TJoNCj6gkDHWGGKWSmJxn41f6fFFsCNLg3JGJehLYPACg55v6Dvyq+h1qyZqjcgon3GxHUmE4aVTnYPLbRIylGXyg9qK7YfTJX9WfBQSv8ZEHlxawrZipUa/ayjJSBbli4PL7kOe074ZcpZOkCtuYW1DJ6Q+w6nLJZ+rBzGunSNEXGYRs/paAfHxw8RIdbYeOrxQHlrC7b+883+PPZkH1rtB6peUvq2NvPT55fHfsZdjx6xfxdjQ2ubcDP5PolCiPRPTcXEOwgmOkMLNeJq7+KqPkeb05lV+dZFBmgTOa7JkeAIzsBV2pKLmpOczJ0ZZV+LBD6llhvpiTMA8ZxkKDIryAMCI3oNEk2vJHqLjBu7DEk8vXVGr1UHNQeCmFwD32ov5jUXyVBis0ER1PHDZkDUMPHGpApJFFbWwc8I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(23010399003)(6133799003)(56012099006)(4143699003)(11063799006)(5023799004)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eERNeXRGSnNBVVlrSDl6a0Y0a2RueTNraHNzUmN5eU40SG5yQXlxTWUrWXZB?=
 =?utf-8?B?TzV1UXVON1AxZFVSTmpqN09PUlFvbWhDY2xYWCtWaDF1QjgrK1EyM1ltUUd3?=
 =?utf-8?B?SzMvRjYzcGZLYmpGSmh5TnFCK3dZRlFMZGdicHNRK09iODF4b0FCRjZsZy9N?=
 =?utf-8?B?RkFNSVA5NUU5SnFKSExQMzl0Nm9wZU5EWmhiMUJMV2VNZ0hZMHRuZnIrRnpK?=
 =?utf-8?B?MmxXV2Nja0NSYnBHRC9OVzBxbmQ3L1FhNVdzeWRHT0VLZm1yRmQyV2JSNGF6?=
 =?utf-8?B?WWNwdG02bGVqdzlQUXArcll2ZzUxdDB1UVI3UVVieGhaMWJTMksyNTZMdEUr?=
 =?utf-8?B?MzhnVWx5RmNaRm0vTFA2bVcxaUFHaHpFVUt5SnJnZnR1N3FuVHBLbktQbU0w?=
 =?utf-8?B?QnZmcjg3ejR1VDQzWWxuT3l5TmRiRVZucFB3NG5ldzMvTkdTQzVoYjdicDh3?=
 =?utf-8?B?T3hkdFR0cFpGQllCWjRiVm1XSUkxeExTc1VTeVhFZW1YSzZkTjJKWi84TzM0?=
 =?utf-8?B?b3AvTkJjOHR4dWxta09lS1V5ZGljNjNKYTlGbjNkRldyMngyK1JEQTdLVjdu?=
 =?utf-8?B?a1ZwNHU1ZkhXV1lNN2JaWW01T3VBU0p2dFZKSzhScUdGakFUalZyY1dSaEJs?=
 =?utf-8?B?clJ2VDFsc0o0REduQXBrd3I2LzJ1ek9HcFJIeVJIaC9acCt0QnVPendmUlBr?=
 =?utf-8?B?R0dONEpqSmhIWkM4SzlwR3lJUE1xOVZPbjJRbzE1VFV0N1ZUbHZtMzBCOE5Z?=
 =?utf-8?B?YlpXdGFpRDRNTVpTaXJaVTVaclh3OVR1M0NpM1FTWE5XV01vZGd0ZEFzOGhw?=
 =?utf-8?B?Ri9YejJJSVFTdUtjZVdqT2JIM2ZLZ3NMTnBTOWhBd3JuejkwdzZkMXdwSC9X?=
 =?utf-8?B?RzF1WkxjVmY1aEgwY1p3UDVSa0ZyZUhlem9tN1FHYXVibGlGUGZLYWQ3VlJX?=
 =?utf-8?B?ZVprOWtzL0ZqUmVSTTV1anYvV0lSS2I0OVRzd2tQeXlJVDVaMndWUk8rWDly?=
 =?utf-8?B?M2xMcmlzb0JZS2Q0MjVaYTNCaFRIWTBYSVpDVVZMTXZveFRNSTNNTWgxTUlU?=
 =?utf-8?B?QUt1NFFyZXVaNk4yWU53bzBNQXVwaTVWWHJack5zSG1uL3ZtOTJxSzNZRzVr?=
 =?utf-8?B?YzlidjVsTG43VFVlOThnd1hacVB4eHA4bmtaR0tJSTNqeTlXZDVxY1U0bU1T?=
 =?utf-8?B?VXhsZFNTVUQ3TDhib3YxOU9vQ001WUIwWXZ6eFBzOUJ5QXJTQXRqVHJyUFgw?=
 =?utf-8?B?b0tlWG9lRlIzeHp1Tm93WWkzQ1pwZVpsUnlPcnJIVmVDdGw1S1o4b240RmJm?=
 =?utf-8?B?OGRNSWFGVGpKTFJWalZPcmdIVjVPNGhVZU5nTUZEUGp3Wm0xYnB3V0c2dW9y?=
 =?utf-8?B?d1QvVTErYjE5V0xkQTBCcXBYNXVPelI2MnNrU052Y1JyWDRieER4UXRpY05k?=
 =?utf-8?B?d3IwWG1BL2kwaUN4NERXK3k0RHpiRDl5NlJDYmlTKzNNOTNlZ1NYa0gzNlZs?=
 =?utf-8?B?Szk1WjlsdkRiV1dlMTdpbUlUd3FPRFJWaS94VEVrU2lHWE1pdUMvQmp4OTNh?=
 =?utf-8?B?ZFZydWNqZDExZXhmK1drYUE3dG9vSGdQSGk2NWx1MjRxQndqV08wd3VORFBU?=
 =?utf-8?B?dkw0b1lnaDQ5amEyS0FFRWxUcDNzbVcwd0pkWFZvWlZUT1dMem5qZlVRUExw?=
 =?utf-8?B?dDBBRDZiaFZPZ1dtVzloN2czS29MRUN6aFNMWWhVVEdGbjhJazBJL3ZzMmJt?=
 =?utf-8?B?aGdTRGJ2RUtoZkMydUtSa1hDOXQ0UjE1ang0MGFFTUFKRml0TmEvLzJSMjg5?=
 =?utf-8?B?R0ZPaExCYzNLanhWODFYT1BoZDZ5cnNRZW56QmhtbVJOd3VlTEdjTzBzMmVm?=
 =?utf-8?B?SEozRTg0NUFoYmtTbzBsd090b2lMMnZ0L1loY0NkQUV5bWxleHhucFMzazF4?=
 =?utf-8?B?S2J1QlNPMVdDVUtITmcxeHJzQmljOC96Y2lLRnQ0VXFROGlBRkc1VlpMdE1T?=
 =?utf-8?B?VHViZ1RJTHlzMG1YT1Vac3Uwc1FDS0l1Yk5RQTl2YnROVndXYnBVZmU5bVow?=
 =?utf-8?B?NFNQNThjd1Y2MWpSSnRoL0tGck1aNEZwL0phcFdPVDI3VWkvLzFnUThIZ2R5?=
 =?utf-8?B?VHFMMnVNT0k4anhpbWhSYVRHd2tlR0J5WGRXUE9yTTJZWmljU0R0WkNlbnd5?=
 =?utf-8?B?UGFFZWpncmJkcEVYU24wYnFjeVFJYzh6L1hMaVBrT0JZMzhxSStacmh3TE5k?=
 =?utf-8?B?REZyRUZrU0I1YUxLQjVTcWM1RUZHV3c4TkNUcVUyMTlnUEJ0RGVCZmxCTkZF?=
 =?utf-8?B?QkxDL3ZUeGdZKy9TMWJ6YzE2dUJ4WG13L1N3UGZveFpDeG5tT3JMNkxRaU0y?=
 =?utf-8?Q?7gE9EhAHhOwZrsf8=3D?=
X-Exchange-RoutingPolicyChecked: lMZMaI701T9RiXBNgd8sxDtX/LXbb7LuT3YmeXC3pBqBDsddCmgk6b2yVj2CUjUuLcI9c8OpIS+MBRF3XCGd0+fA1dJnJ7L4SVw+fM0on+ob5EjA9c0swkoT/h7wMzFkTxbbcX8p4x6eh47pCg6ktoTIlovT5NFuR/BYGYMCnq3SSARxOEtngPptvHFVLq+R+nBpPPZQxlTRq2d0fczQxv4+oSL5TGZVgACmlgyflTsVqxyejuVu8IRaZDTU/H8664pqjT0LdIquFlYyslkK/mv7OPjXO0RMSPMGKvYgRXFgQ+vAbZ0M+DNSqZbDR03CYLAQV0BCBfGLV76mP8NyPw==
X-MS-Exchange-CrossTenant-Network-Message-Id: d66ae809-c2e5-4444-6ce2-08dee1bb2aef
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2026 15:18:33.0204
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qUrub3Zq5tc8z8z79rNozY61vh5ZytBDl5a8YYSyA6C1H8Z0OLsh8gHuvnPDn7yH+4y7NxZxC+5SNuK4i7SFW1S+TfrodnO4WrKb+BG3VTg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB8090
X-OriginatorOrg: intel.com

Hi Tony,

On 7/10/26 1:51 PM, Luck, Tony wrote:
> On Wed, Jul 08, 2026 at 03:50:45PM -0700, Reinette Chatre wrote:
>> Hi Tony,
>>
>> On 7/1/26 2:35 PM, Tony Luck wrote:
>>> Application Energy Telemetry (AET) event enumeration takes place
>>> asynchronously. Linux builds the pmt_telemetry module into the kernel to
>>> kick off enumeration early enough that it completes before first mount of
>>> the resctrl file system.
>>>
>>> Allowing pmt_telemetry to be a loadable module means that it is possible
>>> for different numbers of RMIDs to be supported on each mount, depending
>>> on whether pmt_telemetry module is loaded.
>>>
>>> For simplicity, calculate the maximum possible number of RMIDs and use
>>> that value to allocate the rmid_ptrs[] array just once. Also use this
>>> maximum RMID value when allocating rdt_l3_mon_domain::rmid_busy_llc
>>> bitmap and rdt_l3_mon_domain::mbm_states.
>>
>> This does not sound right. Why use the maximum RMID for L3 monitoring state?
>> It can be guaranteed that L3 monitoring state is only accessed when that
>> monitoring is enabled and when it is enabled it can be guaranteed to never
>> use more RMID than what L3 itself supports. Why would it ever be required
>> to allocate more than that? Could this not instead be limited to
>> rdt_resource::resctrl_mon::num_rmid? From what I can tell such transition
>> will make it explicit and consistent (since arch code already allocates
>> this state based on this) how the L3 monitoring state is sized.
> 
> L3 monitoring on X86 happens to provide the overall maximum possible RMID
> value (any larger value with #GP fault when written to IA32_PQR_ASSOC MSR).
> 
> AET could potentially claim to support a larger number (and this could
> happen on low core count SKUs where the number of RMIDs supported scales
> down with the number of cores).
> 
> resctrl_arch_system_max_rmid_idx() needs better comments, and
> implementation. On x86 even if the L3 monitor functions have been
> disabled, the limit is still bounded by CPUID. Not by what might
> be found in the AET->mon.num_rmid.

I see. I assume the implementation change you refer to involves dropping
usage of r->mon_capable that depends on rdt_cpu_has().

How much to rely on CPUID is not clear to me. The direction seems to
be to move away from CPUID, which makes adding new CPUID dependencies
less ideal? 
> Though perhaps intel_aet.c should look at CPUID to avoid believing any
> larger numbers seen in AET enumeration.
> 
>>>
>>> The limbo code must deal with changes in the number of RMIDs from one
>>> mount to the next because some RMIDs may still be "busy" when the file
>>> system is unmounted, but be above resctrl_arch_system_num_rmid_idx()
>>> for the remount. In this case RMIDs that can be released are not put
>>> onto the rmid_free_lru list.
>>>
>>> Signed-off-by: Tony Luck <tony.luck@intel.com>
>>> ---
>>
>> ...
>>
>>> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
>>> index 60d50ac79e7b..3169441a2d40 100644
>>> --- a/arch/x86/kernel/cpu/resctrl/core.c
>>> +++ b/arch/x86/kernel/cpu/resctrl/core.c
>>> @@ -144,6 +144,20 @@ u32 resctrl_arch_system_num_rmid_idx(void)
>>>  	return num_rmids == U32_MAX ? 0 : num_rmids;
>>>  }
>>>  
>>> +/**
>>> + * resctrl_arch_system_max_rmid_idx - Largest possible number of RMIDs
>>> + *
>>> + * Return: If L3 monitoring is supported, largest possible comes from L3 based
>>> + * on CPUID(0xf,0x0).EBX (scaled down on Sub-NUMA Cluster systems). Otherwise
>>> + * maximum from any other mon_capable resources.
>>
>> Above reads "Otherwise maximum from any other ..." but the code is actually
>> "Otherwise minimum from any other ..." which contradicts the "max" intention of
>> this function?
>>
>>> + */
>>> +u32 resctrl_arch_system_max_rmid_idx(void)
>>> +{
>>> +	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
>>> +
>>> +	return r->mon_capable ? r->mon.num_rmid : resctrl_arch_system_num_rmid_idx();
>>
>> This smells like a function that pretends to be generic but created to provide
>> correct results on specific x86 hardware. 
>> If this needs to provide max RMID why not cycle through all monitoring resources
>> and determine the max RMID, why special case L3?
>>
>> ...
>>
>>> @@ -961,8 +975,8 @@ void mbm_setup_overflow_handler(struct rdt_l3_mon_domain *dom, unsigned long del
>>>  
>>>  int setup_rmid_lru_list(void)
>>>  {
>>> +	u32 max_idx_limit, min_idx_limit;
>>>  	struct rmid_entry *entry = NULL;
>>> -	u32 idx_limit;
>>>  	u32 idx;
>>>  	int i;
>>>  
>>> @@ -970,27 +984,29 @@ int setup_rmid_lru_list(void)
>>>  		return 0;
>>>  
>>>  	/*
>>> -	 * Called on every mount, but the number of RMIDs cannot change
>>> -	 * after the first mount, so keep using the same set of rmid_ptrs[]
>>> -	 * until resctrl_exit(). Note that the limbo handler continues to
>>> -	 * access rmid_ptrs[] after resctrl is unmounted.
>>> +	 * Allocate the largest number of RMIDs that this system will ever
>>> +	 * need. These cannot be freed until resctrl_exit() because the limbo
>>> +	 * handler continues to access rmid_ptrs[] after resctrl is unmounted.
>>>  	 */
>>> -	if (rmid_ptrs)
>>> -		return 0;
>>> -
>>> -	idx_limit = resctrl_arch_system_num_rmid_idx();
>>> -	rmid_ptrs = kzalloc_objs(struct rmid_entry, idx_limit);
>>> -	if (!rmid_ptrs)
>>> -		return -ENOMEM;
>>> +	if (!rmid_ptrs) {
>>> +		max_idx_limit = resctrl_arch_system_max_rmid_idx();
>>> +		rmid_ptrs = kzalloc_objs(struct rmid_entry, max_idx_limit);
>>> +		if (!rmid_ptrs)
>>> +			return -ENOMEM;
>>>  
>>> -	for (i = 0; i < idx_limit; i++) {
>>> -		entry = &rmid_ptrs[i];
>>> -		INIT_LIST_HEAD(&entry->list);
>>> +		for (i = 0; i < max_idx_limit; i++) {
>>> +			entry = &rmid_ptrs[i];
>>> +			INIT_LIST_HEAD(&entry->list);
>>>  
>>> -		resctrl_arch_rmid_idx_decode(i, &entry->closid, &entry->rmid);
>>> -		list_add_tail(&entry->list, &rmid_free_lru);
>>> +			resctrl_arch_rmid_idx_decode(i, &entry->closid, &entry->rmid);
>>> +		}
>>>  	}
>>>  
>>> +	/* Find how many RMIDs are needed for this mount */
>>> +	min_idx_limit = resctrl_arch_system_num_rmid_idx();
>>
>> Since mon_capable resources can now come and go from mount to mount there are scenarios where
>> rmid_ptrs[] may be smaller than min_idx_limit so above needs extra checks to protect against
>> overrun below.
> 
> I don't intend for that to happen. The initial allocation of rmid_ptrs[]
> is supposed to be large enough that no subsequent mount would need more.
> 
> I.e. resctrl_arch_system_max_rmid_idx() must return a value >= than
> any subsequent resctrl_arch_system_num_rmid_idx() call.
> 
> Perhaps I should add this to resctrl_arch_system_num_rmid_idx()?
> 
> 	num_rmids = min(num_rmids, resctrl_arch_system_max_rmid_idx());

While trusting the arch helpers to "do the right thing" occurs frequently in resctrl
as a result of its evolution I do not think this is something that it should keep doing.
I think it will be more robust for resctrl fs to protect itself here. For example, could
resctrl fs obtain a new partner variable to rmid_ptrs[] that reflects how many elements it has?
This could be done in addition to changes to arch helpers that will then be required to
meet resctrl fs expectations.

Reinette




