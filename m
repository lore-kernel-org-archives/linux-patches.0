Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B902C54705B
	for <patches@lists.linux.dev>; Sat, 26 Sep 2026 00:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790381490; cv=fail; b=TVtorDKUf0MIuOBKJA85GOX/FW/VJGSoRd/1jssQiSH9B48ppO+KH21fUoIM+Mb/pEjJ1vlbS95JdK+GHtIsHeBTCA1KzDhy9cUFvvuyz33LMEs1JqTEI4m3Aq8j9FWec1xOouLq6Hs9EG49YCyXOon0x5jEGVD++OAsC/nl1VE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790381490; c=relaxed/simple;
	bh=chFwT2Gu2S2USqjm3K0b1+EE8HMf34vnvW5Denjgt4U=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UA579FfoaVbpnDFJDgN+MIOZpLZAHgD3YJXmVgNvhzFjTJMRgry0HMMScsBceIm7dxyqXb1h02GFHd0H2V+zybWi0NPNQibKS5l2Jf8Ajft8pLHSt4/MFoXnk110npCPNkOE+1WFCA4SVkT6Iq+atu9AT8NiwqHDUK1iJ07zN9I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=a6GvtJP1; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="a6GvtJP1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790381489; x=1821917489;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=chFwT2Gu2S2USqjm3K0b1+EE8HMf34vnvW5Denjgt4U=;
  b=a6GvtJP1nPco5WCl3RNcKsLCnsk2Vhu28D7x3VDTqEfKprdHUHpM9ddr
   MtC+LNgQj26fYmqgkPiUrFh3aENFiDLkM9M1hGm3K38LonbDAHIvYafYN
   qjHqiaQAkcXlg+MYX6Dj/nOpzZAMe9LNwHn6gIvcKe2vyBfVKeagxFWHZ
   8CJH79JSo0WbOYOhz17E5un7DRZ8PJQeygA3wN0BZ+doav4elcgnryjRM
   FGMTQ3kAh+pFT5100gSkhJiTKpTXitqVfeEbt6yFHXh8IiHOLWBZ4Z85n
   zD63clLC5J0nJOZFsYwg/b+e0ig+AiTR2+Gm1m0Fieni2e1Ura+YzMFMQ
   w==;
X-CSE-ConnectionGUID: kO04eNC7Qz62C9bLLwlp+g==
X-CSE-MsgGUID: DwX0JuMfSlK3HFXI4uPuxw==
X-IronPort-AV: E=McAfee;i="6800,10657,11916"; a="101745677"
X-IronPort-AV: E=Sophos;i="6.27,123,1787036400"; 
   d="scan'208";a="101745677"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2026 17:11:28 -0700
X-CSE-ConnectionGUID: ibpovdJUSjOybFsL83zTig==
X-CSE-MsgGUID: 9PwuAEBIT9KxXOQmYXq7vw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,123,1787036400"; 
   d="scan'208";a="273569569"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2026 17:11:28 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Fri, 25 Sep 2026 17:11:27 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Fri, 25 Sep 2026 17:11:27 -0700
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.65) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Fri, 25 Sep 2026 17:11:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yygA+EVUMWQDGYTGtYkYc4fH4w/OMEh8A8bAuRtcfYjfr0ZEM2QLWHGlInmuhoHN9Bal7f0lBAfCri1+qnpd3W2MJUT4hHfxbcqyX2qj+nGIk33Ummw3sjIKuYX8o+xGR2SDaPGoNJVZlciS8dT0mhCd9wrnqL7Amo4n1xsrjlAAE2xnI7jrw28o8ngZINhwKA6NDxkTv9M800m3uh0KdHyYzwzfaErJImjGB9lGjY6bf5qs+gjOgLop0NZV0YXBa7veT7xONXc+tGkcJ8l4sMQKwY2v1LR0h8ZEMmhkrLzrrFfueHGnwTAQfF8cjrgo8qnpU58J7bA+jyHKyHZfig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AlKhZ01Ir8fGDgcEm40NVmEyUfcmssV6Rx4DSxW/eLA=;
 b=idgUJ0+36AP/bUGWOWmd027Gff9ly7lxrUGOolGxkGTISY1uS5K9ePcEOFB+LoPwkWu1DbNC1BBsjkZ1DxVOPYiU6Xz+sgjNVy/gaxMwQrnsTrlHeLc1UNQBRd9HJgfAUyOFw9C27yFfZh6S6G9veRcNSj8rZ9yKDL+PCqafJFbogejJCFud5RP9UPz3goOrhmvis7v8w9G1+P6Hb7GHelZn9NEmbh9jmH916AEuKIcvj4a8T4oC2Xw0o+50Ts4WxueOcUoU7OkGdpZ4JvzW+zZZQPKYiycwX8eeDyoUNb+tslFaczv5156vjNEBwWE/f7GiMLFwuT3vJH2cGybySQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by LV8PR11MB8485.namprd11.prod.outlook.com (2603:10b6:408:1e6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Sat, 26 Sep
 2026 00:11:24 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0451.014; Sat, 26 Sep 2026
 00:11:24 +0000
Message-ID: <39627dfb-31dc-4b09-bf35-230e655ece2d@intel.com>
Date: Fri, 25 Sep 2026 17:11:21 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 06/25] arm,x86,fs/resctrl: Replace architecture
 resctrl_arch_{alloc,mon}_capable()
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260916231320.14502-1-tony.luck@intel.com>
 <20260916231320.14502-7-tony.luck@intel.com>
 <d0e563ec-65c4-4a00-bd54-61c30d80890f@intel.com>
 <arbyVMoQOeCq5F_m@agluck-desk3>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <arbyVMoQOeCq5F_m@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0359.namprd03.prod.outlook.com
 (2603:10b6:303:dc::34) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|LV8PR11MB8485:EE_
X-MS-Office365-Filtering-Correlation-Id: 388feecd-ee8a-4eaf-4f37-08df1b62b365
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|23010399003|10067099003|6133799003|11063799006|56012099006|5023799004|4143699003|3023799007|22082099003|18002099003|13003099007;
X-Microsoft-Antispam-Message-Info: aBCYnp0312mjBwrupNCOv422rqkJKRQHCqC9ZW6NIq27QA45tIlT9XD91jc2vuXaCKBuKwj88RBCt9/0EU5D3lGTE7rSwHfIk8/pmKGQe/+Pi4EMUtHDRS6LM9C+5nbK7mzYQCT9XqXHSG8X9iXswZADm6DNcVvTeSAdAT/rXogEqrBn8t3/BdC3tkl1GKLQZE/gynwRixs8IjHBT21Iz1Ui5CW+/iwiYCM40HVPnEwILilb4z0JfQ+vvQEgnlGCGBK25PUyxXQI0BpCp2izN6DmaIfOQFTBzRoH/IeMaYgedqcTBNWPEmeGU2ERGu8W/ahfp/0W4hFPkHgT5fgt1nlqxkNqgehMpNVATYqI5bavomT9p51wqf2W+Qc0/YMlngQLbuRHxCCW0lowF6GJxphJIUQ6A2nVmarQaRw2duAIIX8UIo9VJ24d6EW3lH4OuAcFmK23uK7nphuwMc1Ic3phVLci3bAUfTuyZm0DtzsSjL+Z0LUrM1aaJj8VDnHHGWVIrPcd8bkLL9WYzz/OG2fGfEW5KthbH9M9YzNarE8DJ8CYwpVYeDZrbS7bVGDPMCksJFS9H9da+04QsnSkBUMpTynIWGzQZWsAty5X9tg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(23010399003)(10067099003)(6133799003)(11063799006)(56012099006)(5023799004)(4143699003)(3023799007)(22082099003)(18002099003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RG9XNHdSMDJsbmpObWFoQ09sTS9yR0xOMHVJVjF1eVNSZmltTTJFdjFtTkh6?=
 =?utf-8?B?ZGM2ZHd1dUhDQlZiV1lSSUhQRG43MkpBTmpJUVpHWGhGd1VtOHdQOFdSOTVQ?=
 =?utf-8?B?eDFmUG5WejBJZmZxU1gxRm1lUEZhWVM3c3N0b2FRVkFDRFRJUFY4TVBGVlZF?=
 =?utf-8?B?LzZCU2loMTUvcGsvRGE1Nm1IQitlYXZnMkhqVXBCdFR5b0RrVUdBSkVEcGpV?=
 =?utf-8?B?RCtiTXlQU0FzdzBldytmS01UaFI5dzEydmVRYWJmYlphNTZDclBSWWRZK0tU?=
 =?utf-8?B?MnAwOGR6SWc3S2pvZEVVVEJIc0l1ZitNd1JraWE0empvWnBVdUlwUHc0bytW?=
 =?utf-8?B?VEQ0aFBwaG9IcFNjcTJTaER4Z2l0bDFnM1Y2KzJrOWdrMnNWRFFQcTQzZDRO?=
 =?utf-8?B?aGJFNVk3cS9NWTF0Q2JoUFZGd2l1UDVtZXozeE5uWjVCNnU0SDk1MW1pQ3lm?=
 =?utf-8?B?by96SmNiT0JLTHlLVkJxSENaa1FBZUl2MnJJd2JHZDVIYTZOR0ZSYitOYmJO?=
 =?utf-8?B?UzRQZ2NkRHFoRERTWkpGVmRmZytuRkxVblp1UnZGcXp4N1RQc2VBUDNGNHVx?=
 =?utf-8?B?QTluMGJvSlRDandVRHdLNGpoaVRmZXkwNkdmSXV2T29oazhoZVpkNForOHJH?=
 =?utf-8?B?YXg1R2lYR0JCaVhlaER0blFGWjNLKzkxN0tQR1ZkV0owQ1kyWHg2dVFYbXVx?=
 =?utf-8?B?OWV6LzV6WjcwN09vQkU4UUM1N052ajJZd1hJRkFBVUlFSnFOaG9Ub3FCdGtV?=
 =?utf-8?B?RHQ2QXhHUjRSQVNwREJidlpuMzVnN2tnNmVSaUd0di9IRDF4cGE2SENtNHhr?=
 =?utf-8?B?NC84bS9wMVhRc2JvZDlVY0YyU2hYdmFPN0hRS21xRTBxazZEd3RITldsbFR5?=
 =?utf-8?B?VXpCVXk3WFhKM3QvR1VMWjZGNWdXYzFvbWV3Mlk1WnZUaTAxSzFJTDRoSDdm?=
 =?utf-8?B?akt1djZrQStlOFFKOW1JeXhOWmFCQlV5RncvU3E4NFRnK0t2SDJmQnZ6NU5P?=
 =?utf-8?B?R3I0aGJnd0c4MVR6T3d5c084c0RrR2lyMkEwWCtmNU5lZlJoUkZaaWthbEZQ?=
 =?utf-8?B?eGp5aWdqRFF1RWpxajI1akc4Rnc5ajlYZmFsQnJneUZFT0o1RWVEMnkxM0VN?=
 =?utf-8?B?bURkbGRpMHhnYVJ2R2hWamlPWHUzVVNGbHZLRW4vVjNaQUpCSnJVOElLa3Mx?=
 =?utf-8?B?eG9zQ2pGUFFuaFFteTRWWEp5Rm9FcUJXSUkvQis4UU5LT3VsOVZVWGNkcVRi?=
 =?utf-8?B?MkhyU3UvUjJLRlNScnJzRVhVZk5HR1ZhVjVFVGtWWElWc1kvWHJPeWhoSmFz?=
 =?utf-8?B?WWl6MmR0NGx6Z3pxUmQwbWszZXhFZlk1R2RqZ0IzM2lhNU93dUdON3RtcDZm?=
 =?utf-8?B?MTV1dG9udHplL3NSWnAyYjJ4RzhhQnFlYjBTUGJyOGtZQmhkbHZJWjhhakpN?=
 =?utf-8?B?TmwvWm1BV2szWndsRUxRNC90Yk1FSUNkUk9xNExJTTlwVlNFMVVPWE9PNTg5?=
 =?utf-8?B?cGN0djZnTWhDcHF2ZmFIMDZWazhrNVRMOThNT2V2NVRBK0x2ZFUyMEc4Smph?=
 =?utf-8?B?QU05NmY5SWRSSUgvYjBja1BwLzRxL0xiVEdySTlxZHI3RFF0aVJRT25Vakp3?=
 =?utf-8?B?NGpPRWhVdEZFRFZJVHFWbVYyMnJRYkEzdXRWUGFOQW50bWZIdk5qZzFmRmk4?=
 =?utf-8?B?K25PME4vZG9tQnl5ejFmejJ6ZnlzQVVUYUg1QU5kdWcxUEl0UG1zMDVHalZw?=
 =?utf-8?B?N2pVL24wcGxvWlZXVzM1dnlTYTJ2MGhIL3oyVm9YRFdKUWd1MFVUYXJsRXV0?=
 =?utf-8?B?OHpqanU0bkVrVHBsWjBUM2JKNlFoc2ZtckdSSG80ZE5zYzRaN0xvNHI0QzNX?=
 =?utf-8?B?eHltSHBaMEtES0VZVkVtM09zckNsRXFvQW9NME1jY3F1WEJkL2pBc2RTemxR?=
 =?utf-8?B?SEJTVUNoYmNrM2xUR2pid3Exc29EdFBrT2JKc3hnWXRUL210TkV6M3cwZEd5?=
 =?utf-8?B?T3ZBazRYc0xQVlA0RHhtajhiUDEyRjF4WWZiTHpiaEdZWkU5L1VOSnpZRFVz?=
 =?utf-8?B?OHNaRGJzTGtla2xtQ0Rwck4rbE0zVlFXWHgzRGtiaUkwNjl1ZWVKUUZ0U3gr?=
 =?utf-8?B?T3ZqTGNWT2RyaGM2STRoN1IxZFlVZnFTL0tScTlHRXowU2ZESDIyT1NvOTQx?=
 =?utf-8?B?K1p2WWhhemNlV0NBbG5Eb0VreGt4d0FGektBT0xyQ1BTT0dBU1FUR04xQzNr?=
 =?utf-8?B?MlZhb1JKL3lBTE8rNnBPR3R4b3Z3aWxQSUJJVUdraWo1bWFVUDZMdFlvbGlz?=
 =?utf-8?B?QXg3ekZtRzdQaDRiMFJmMG90Q21uM1BCdzVEODZyRVVDYUYzcEdFQ3lEUkNm?=
 =?utf-8?Q?ytgjhMHh1BpftMuc=3D?=
X-Exchange-RoutingPolicyChecked: AJ/pBaNRC6D5d42NkbcCaiR0hhMNqYpJOY20ZegW8m1pRLJXpDGk7e3ZaEHLJeMCvzjmHnsCOA6FMUC6QtHQUtJaW6SWvlaNqwXtF420QF4JWrz4/JeG3lQuVAXq31abckMwUddQAU0SO9ZluDel5nsTz4zRDhv9DIS1VjeN7Z3lDNd+c15tbWdxwSPzBOc0lgavKa7AnK+MEefPWr2WTMtmpuGJm+mmzPYYm9ZclbyM+56UWq3Ekt6Giq0rr8F8VlJ+aeYITa/dGYMy4Bt1FFLBilWxkGgRCs18UWQiljZcgfXA31wLTrtuNtENZqP/rJMkXJ8/yMgoy3ZXFGhTIA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 388feecd-ee8a-4eaf-4f37-08df1b62b365
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2026 00:11:24.1556
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lyagwDDYiBFK0Zun3jM9xhhsZIes4KeQcKHFoqjc0+XoT+xNh6qOFZBixVC8ByO124ZBMGSIY09QQiwUX0dfm+hsqIWgfL6Nlqg3lXs512I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8485
X-OriginatorOrg: intel.com

Hi Tony,

On 9/25/26 3:14 PM, Luck, Tony wrote:
> On Thu, Sep 24, 2026 at 08:22:47AM -0700, Reinette Chatre wrote:
>> Hi Tony,
>>
>> On 9/16/26 4:13 PM, Tony Luck wrote:
>>> All the information to determine whether a system is alloc, or mon,
>>> capable is available to the file system. Architecture helpers are not
>>
>> nit: "is alloc, or mon, capable" -> "is capable of allocation or monitoring"?
>>
>>> needed.
>>>
>>> Define generic resctrl_alloc_capable() and resctrl_mon_capable() and
>>> replace all architecture versions.
>>>
>>> Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
>>> Signed-off-by: Tony Luck <tony.luck@intel.com>
>>> ---
>>
>> Please note that the pending RISC-V enabling [1] is not compatible with this
>> change but there is a change planned that will let resctrl_alloc_capable()
>> introduced here work on RISC-V also. We need to coordinate these two
>> series.
> 
> The first few patches in this series have relatively simple cleanups
> suggested. Perhaps when I post v13 you could focus on getting these to
> the finish line and have Boris consider them for inclusion.

I was hoping that me rewriting so many changelogs entirely for you would
already make it clear that I am already trying to get this over the finish
line. 

Alas, me writing the changelogs for you seems to be the wrong strategy because,
as the new changelog below shows, the points I keep making about changelogs
appear to end up in /dev/null.

> That would get this change into TIP x86/cache and let the RISC-V
> folks move forward.
> 
> Note there will be one new patch in the initial sequence. The bug
> fix for is_closid_match() that you suggested I separate out from
> patch 9.
> 
> Draft version of new patch below.
> 
>>
>> | Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
>>
>> Reinette
>>
>> [1] https://lore.kernel.org/lkml/20260917-dfustini-atl-sc-cbqri-dt-v8-2-7964e8d73fe8@kernel.org/
> 
> -Tony
> 
> commit 986bf1a4e789de917e955fe549bdd71e51dc2e48
> Author: Tony Luck <tony.luck@intel.com>
> Date:   Thu Sep 24 12:40:41 2026 -0700
> 
>     fs/resctrl: Ensure default group reports tasks on monitor-only systems
>     
>     Sashiko reported[1]:

The custom for this is to use tags. For this patch it would be:	
	Closes: https://sashiko.dev/#/patchset/20260831174421.13921-1-tony.luck%40intel.com?part=9
	Reported-by: Sashiko <sashiko-bot@kernel.org>

>     
>       This is a pre-existing issue, but the resctrl_alloc_capable() check in
>       is_closid_match() actively breaks the default group on systems that only
>       support monitoring capabilities.
>       When a user reads the root /sys/fs/resctrl/tasks file on a system with
>       monitoring capabilities but no allocation capabilities, the following call
>       chain occurs:
>       rdtgroup_tasks_show()
>         show_rdt_tasks()
>           is_closid_match()
>       Since resctrl_alloc_capable() evaluates to false on such systems,
>       is_closid_match() unconditionally returns false for all tasks. Furthermore,
>       because the default group has type RDTCTRL_GROUP, is_rmid_match() will also
>       return false.
>       This causes the root tasks file to appear completely empty, hiding all tasks
>       on the system that have not been explicitly moved to a monitoring group.

Please separate paragraphs with empty lines. It is easier to read.

>     
>     Remove the resctrl_alloc_capable() check from is_closid_match().

This is obvious from the patch. <sigh>. Please do not just verbatim describe the code
in the changelog.  

Could you instead describe why this check is removed? I understand that the bug
description already mentions that it "actively breaks the default group" but it
highlights that this only happens on systems that only support monitoring capabilities.

Could the description of the fix describe *why* removing it is sufficient
to address the reported issue without breaking anything else?

>     
>     Fixes: e6b2fac36fcc ("x86/resctrl: Use is_closid_match() in more places")
>     Suggested-by: Reinette Chatre <reinette.chatre@intel.com>

I do not recall suggesting this fix.

>     Signed-off-by: Tony Luck <tony.luck@intel.com>
>     Link: https://sashiko.dev/#/patchset/20260831174421.13921-1-tony.luck%40intel.com?part=9 # [1]
>     ---
>     v13:
>             New patch (split from patch 9)
> 
> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
> index 5dcbb0a964e8..6733ed174f51 100644
> --- a/fs/resctrl/rdtgroup.c
> +++ b/fs/resctrl/rdtgroup.c
> @@ -685,7 +685,7 @@ static int __rdtgroup_move_task(struct task_struct *tsk,
>  
>  static bool is_closid_match(struct task_struct *t, struct rdtgroup *r)
>  {
> -	return (resctrl_arch_alloc_capable() && (r->type == RDTCTRL_GROUP) &&
> +	return (r->type == RDTCTRL_GROUP &&
>  		resctrl_arch_match_closid(t, r->closid));
>  }
>  

Reinette
