Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A802B3793BF
	for <patches@lists.linux.dev>; Thu, 10 Sep 2026 03:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789012367; cv=fail; b=WQrn3V8A+Yl1eXApzJSJLrU2y13IRT3+uGkeEE1tXoQrpTVSR6UhjuRzYkCM9V14DIwH8tZogrnKwPw54xjUDL1gJ0RI84tHvfVB7TN2vsY0MJ4TYrGaGjf6EYY5C5fu1SW1A5jOsiN97OnT6Xtl3WFiGOAdM1GKoG3KO+N9sFU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789012367; c=relaxed/simple;
	bh=0ekgyaC8ZvKxXSBrjaakcnRjy4Piq8RX/SSYRfZmhmc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=k0wm5QEP7Dhld+DGZ1jxyYhdlbgolC9voJkZQ2qg7ZhJYwrJheyLPzfvve9k1i+9TapFfq+IQGdQSMQZnkmAthnfutLHjP+jY6Q6TPSYdHakya1JBMDvDypwevQnwW6avMK6uDXKC8ucQL0n0YyxNvb9PtluB6sHXeH2VOl9r2w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aVxtgEA+; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aVxtgEA+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789012366; x=1820548366;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0ekgyaC8ZvKxXSBrjaakcnRjy4Piq8RX/SSYRfZmhmc=;
  b=aVxtgEA+/84J2IffDnpsCRg595Fc5k3UdfYedwH5h2L3sQYRn4+/p7un
   7PYL9hb+7Myl8MCTnoWeFG/mYqS62CLNcQkIC+8oUWsH45xV5Vabl17dU
   EgUiGDPlMGykPxPmWNpUpjuncAV0H4yJGgPu0AMmlL6zA3oBi8Cd/ikET
   IP6y+6XrUnxWc8d+GRgi6+i0Gq2iFDB4dcTnYLiAb+NVvaXibJneD2kqy
   IgoXzC4E1HucvXM4OpnwQ1dr0cHudwEm5kFeiYhHxOvH2CAFVhvx27h8q
   0AJ1L1sOH9NDe/TUj13eJAlnG2onnd+tQZXwXeHS5NFACRdhQKoqfcl4f
   g==;
X-CSE-ConnectionGUID: Ewybc5W0QFa+nFA/1rMBYA==
X-CSE-MsgGUID: RTp/PO7YSf23MQ40SC/xvg==
X-IronPort-AV: E=McAfee;i="6800,10657,11900"; a="106822001"
X-IronPort-AV: E=Sophos;i="6.25,271,1779174000"; 
   d="scan'208";a="106822001"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2026 20:52:45 -0700
X-CSE-ConnectionGUID: 8GCG3eHUR9WpVk6EWc1ZLw==
X-CSE-MsgGUID: EBnTmZPCR4GTdM7ugZbgPQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,271,1779174000"; 
   d="scan'208";a="276754752"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2026 20:52:44 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 9 Sep 2026 20:52:44 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Wed, 9 Sep 2026 20:52:44 -0700
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.66) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 9 Sep 2026 20:52:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JALgNa6gbapWXEd1HQZG4fkZ6Vc0F1M/AYibqzTq+WwDLqOoWemUnfHaBjw0wGI2Xb/iPt86SS3ZPXWkIwKr0nu3OrrWla3QjlbB6bISJGzxj3B8O2QSAz4/NviIfiZf0gLlyLLMSh2Gj9oWSEh1gK7oFXs8LPI2HYw4BijPuOqz6ztUAHghil5apwkeDiorfbW5HuSgU8brnprm4AvdLCkkAaps1TTVuVFNvnzPSgOGePr95QOzEyrkuwL/3Dx1kvr83jQgWYCpDMH/7FtNmHfOAOjIYzXOYDOdCLjkkZ4yrWyYfAOYq/AV+BQ0tVTHbFGzbO9952+ykkDMjQM1/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zwQzS/M4Y07F85VkquLJKr1wpcljirZJywa/5RvuBdI=;
 b=bePFCwO1DGq3sxfMPTXVQhwSLzpLFwB/8+6A6Njq8WSjn2xMI8E9pFiiPvdCmmgt30H5ONKCWEGl85AyrdLZ1kSxlqJF7zVycehOilBFwHMq1urk83Iacl/vEAIKjFLPC5NsP2+qGEfuavZHJlDdp+qSP8XdVgvzsn81Kvoz4khH0q9aclSos6VInQh1cYxSrB9S3CmUhixlPMqvGTOZxeBMgCjZEaXx8L6m6LUd2W4jmgZOV8Jku7EEE1z6D4iNliAOOldySbp0cYd6NdtS+7BXiCjUfWze8IPgu8zM7yI5CN75vSYnrFKbShVdRKwe7sWTQoYeD32iJySKEFyejw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by SA3PR11MB8073.namprd11.prod.outlook.com (2603:10b6:806:301::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.9; Thu, 10 Sep
 2026 03:52:41 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0406.005; Thu, 10 Sep 2026
 03:52:41 +0000
Message-ID: <e063f882-ebf3-4a25-9d43-b23acf5db4c5@intel.com>
Date: Wed, 9 Sep 2026 20:52:39 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 02/23] x86/resctrl: Check if monitoring features are
 enabled
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260831174421.13921-1-tony.luck@intel.com>
 <20260831174421.13921-3-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20260831174421.13921-3-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0274.namprd04.prod.outlook.com
 (2603:10b6:303:89::9) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|SA3PR11MB8073:EE_
X-MS-Office365-Filtering-Correlation-Id: d19e983e-d62e-4864-3f94-08df0eeef668
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|23010399003|11063799006|56012099006|4143699003|10067099003|921020|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: LywsjB6MNIb1HXANTY/AA12ePLYMXFXBt3TSHLf+HNDlHTfhVvKNctSeslqMpivt3uD/rac4io7XSxL0Qiya7L6yysH/vI7M3iFOAqbNt3pz0iLCsxVtjibE3lfRBmbOJxpnB/BdE7OpQBqgWLrUyjXzi1yDN48LEVL2Xw2RnJbcAm6Sh3BaReXg7MZrQaISQ9xF6wLnUAjpzrYQPef7PUadTV0e59CIQFN0O/RbR7TJ/VBlZo4Ri6VuxYCWZI9IRtvxb12bQAnk4jaWhacajYvwFzJFKg5st7tJM7ZijQrDZJoFrwQI2cOFtsxeIzJCJJtFr+aCpPKoXcT9ymXGKMkFOtmOxeFYOfDtoljXREIHb3LIlqYosnlNnHfpoY1gcGSMvVs10kKy3Lh9dMwvr4pCLQ8APFsG1tEsNLLhG3tnDY7Op5SlwJzAN6ZtHdwy8BONAliQQjrSpFbOUE2ikrB/XYe6EJ9XJ6WT1to5Mv0IAJFhGOgxWXG+BJ+2dWvltfpxkiqZHnxnuFsAQmJfWc3+OhQsKlbFCqXGq5Ne1vJKeYT3vOsIyR+WRh88yaSacgHUI6SEtiDtJRHSAVa8F3GuJeg9iyA0PS8AKjhgsYAr2Q5DJyWzMQgQ7N+d7iPSZDviMmQQebpjA0tUG07rSfop+cEc9Jv84baNUmvM9Rzaz32MakiMQXSf69oqaaMxG3NeXZpelurXb75cn3/I0A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(23010399003)(11063799006)(56012099006)(4143699003)(10067099003)(921020)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZTZyVUlVQ3g4K2ZQc0dvNEZsKzBjY2FmeDhuM08wRE5iZkpyazQyb2t1bWEx?=
 =?utf-8?B?cndWK3ZoV3pvNHk4ZXZBNkpTK2U3MURubnlSdFFmTzJiY0M2dnk2VmFYS1lU?=
 =?utf-8?B?ZGVGZEx5aXFRVEdNSk96dzZJMHhPb1ljNmhjTU1ReVN6WStVNnJSbVQyTzYy?=
 =?utf-8?B?b2FCQUJYelYwa3RNY1ZVeHBqZE5FVmtEcHJBTjdOcC85Vm1IcFBxM2JIL0ZQ?=
 =?utf-8?B?TmpqVUZlMGpqK3U0Vy9xV2FFazZ4Ukc5TzE3aXZQS0ZoaEZsV280S3pvTzJz?=
 =?utf-8?B?eFNxTVozYWJ5TVovbFlkK21ZZ1o5VkF1NjJXQ1BxKzRpNUpCNUxtbHRuVzZO?=
 =?utf-8?B?ZzVqVGhiMXhGUkJjbGZvY2tBWUlDRTFNUVBtY0lzUThMeml0c1BmWDBubXBr?=
 =?utf-8?B?VkFHWE1aa3YxQWxTYkd3czZsdlR6SVp3d2EreHMwWHdRck8zcGFZTS9sOXZN?=
 =?utf-8?B?Mkl1ZHVGdXZBcTJ6NGlHamZDdDJnaytIQ3pmd2RIUlJVaHJNZGRUdEpyRFU0?=
 =?utf-8?B?ak1uV09qaVU1eldqWWZSZmR4akNNakQ5aVRBa01JbGdQVy9QaFpjMmxYeE1s?=
 =?utf-8?B?QWVkQjV3Y0hiVFBZQXdhMVUxWElxektiL29IT1JJU011MnNLMnNFSUVZZjNh?=
 =?utf-8?B?YkhFYkxCL0JjUis1Z3J5R3ZmRFc5VU5BaGw2Nm1uS25MeXJIZWRKQ2JCa1h4?=
 =?utf-8?B?RjhWVy9ER2lBakZYa1llUW5QbEZaeW9pVGI1UldpT21QUG16MU9FRFVCNzl6?=
 =?utf-8?B?WGt3MHZIc0ZscllaaU92eVZDQmhpVU9lNzJ5QlVrN1EwZURQUkNrbW9lU2hq?=
 =?utf-8?B?M3dPeFdqZlhrcHkxZ3FUUG16eGZNVmpTaDVNT2NmNGR2MkFwRm5jVEFBZU9O?=
 =?utf-8?B?OHROK2dSa05YdDRaUFhxenFJYkl2eDF5UklSdk95ZFh1NzhDZUhWK21nVnpw?=
 =?utf-8?B?THkwUEFwczFwY1hhQmsxYm1ueG9BcmhkdTdpalpSV0VPWlJqK0dodG1VVWRS?=
 =?utf-8?B?U2pQSXcvOWlqMWd4b1hZc1VYb204QWRLaEVacGY5ZmRqeU9mMWc4WU9zU3kz?=
 =?utf-8?B?bVpwSTUvVVN3UGk0WDRUdWZEVEIxZzFnRlZkVlUvMUJKZGZaTFo1cTQ1SWVG?=
 =?utf-8?B?Q01sUmxiVW05NnpvQlNMbVVwQjdkVjBwd1JISVFzNGg1TXJDSVV0cW10K3Y0?=
 =?utf-8?B?T3lEdEFhVWUxWUlZV1ladzh1aHZaa1c3aVljMHpmRWgzdUV5aDRCcmhZODRH?=
 =?utf-8?B?cXhtRUdkeTQ3M0M5aWdhYVZCdlkrYlRpRXZHcjVwVWIzeTdISTNUb2szV09v?=
 =?utf-8?B?U0N6RnZwSlRrTzQrd1ZKS0p0ZEdZbUdpV2hkOVRIQy83QUo1clZVQzFGQzhm?=
 =?utf-8?B?OG1RL1I4aS9oaUtWSDVDY0YveFFONUYveWE5VVJVdXZkRzdwVmFaV2Z4OTZ6?=
 =?utf-8?B?aVFPMDNiNnZNVEZaTEcyM3ZEaUhteW1YT21BMWtobWxleCtSNThtSDZaLzJq?=
 =?utf-8?B?RkdsVWFIKzNMdDhwa2VuZ1d5N3ZNWDdKSTJ6bDhuNmtTVmU0bzNsLys3VU8w?=
 =?utf-8?B?YlFNY0lRT0lacklLQjF0Z2NvM2NXSi9qcTE2emI3QWllWGQ1N3JDSWhZdTVu?=
 =?utf-8?B?eVpEMzRONGk2MGVxY0VEQUYrOEljandhNGNwUDJFamVWWDJIaEt0dHRnTXNr?=
 =?utf-8?B?VGRGbmFCL01kT0xuTG9HRHhPV0dZWlpIVTZNSVF2ZTNKZjA2S2RSYUYwei9S?=
 =?utf-8?B?b0svMGNxUzgyNkVhNHBKT0dIY2F4ZHgveDdhZnJFeC96bGIzVFZWSVN4UDRX?=
 =?utf-8?B?NW5zNjRWcUhnZEZGVkdVUkpMTHRwaUk5bE9LL0dCL3VmVXh2a1NwR25EcCtq?=
 =?utf-8?B?V2tBYzlvT2JWWTN1UDdPRVBXTHU0S2szcDNuVnQ5bG9laU1FWVVDYWR1MEFU?=
 =?utf-8?B?RkZqd0pna2E5OFZBTGorV1JuTHVqTC9lak9CaC9ZS1NzbENVVnN4d3dJK3Fj?=
 =?utf-8?B?RWhpUnE0TGUrUVdBUDNnTUlnaHdCbjQ1T1orR0NVRy9DMDY0N1JBWmxsUFBM?=
 =?utf-8?B?cXcvbU5kd2lRMnZVbHVCSjM2TE1LWDZWQmx6VG9yeHNUMmRuRTQ5T1lTODJ2?=
 =?utf-8?B?MXA3WUEwUGNHcXl4TVZNcGR6WVdPc3FFSlM4Q3Fha0tDbzdoZ2FjeDhsQVhK?=
 =?utf-8?B?V2NzK1JPcnpYdU54QmFEZ2VrNTJMdGNDQkdST3FGNlNsdG5yd2dFdUMwbHRv?=
 =?utf-8?B?YzdlRkxTYmcxVzRQSTRHT1RFeGl3ZTNMS2VwVFRTSE1GbVMyOWJTRmlhb1Ux?=
 =?utf-8?B?SkN5alpaWXE3eTJWR0s2QjlBdVBtd0dwV2FnVXp1WlpURjdnQm12UUxtd0lq?=
 =?utf-8?Q?S00tG+ssrnfkubB4=3D?=
X-Exchange-RoutingPolicyChecked: oHUiVeWGi2RjFHFZilTHgoL8/jru6aAotPC9J6a7me3RzaZOtlw3dWE8Wh2KjkF6qUpIjq7NdzsmkE4abK/dulBV0519haxDE+JCbFEEQBzMDuMX7H6Rx6HAgjh2iL9jJ5r6y0T6wXFlnHK5DKoy+BFYS4H/IL35Mi7YdUfBUUZPUYGRNoNd75i5/96rHeh+X4EVEZLvHXeeSSMl0jogXnunJkEY+xgooLvO53Y9qOBzeG1NE/9AjrbGKJd4sXyBKzfA4vOK8/wLpLJ3e1jv9/kHPUP+DhKt5P829CLlt9X5DMl+iDwj4aLoLeWvHHz5Wybp5wWvbB6a9zkNsw9CdA==
X-MS-Exchange-CrossTenant-Network-Message-Id: d19e983e-d62e-4864-3f94-08df0eeef668
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 03:52:41.0153
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 03OqPtySQpSpcvfPM2QNeueKAtX0ZkbiNvztnX1Tic+bgazwx061GuGWC+aNQ7C1z4wzyNEeW/HROIemu14pxQBXTWjaV27XyU9VWDV0sPU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB8073
X-OriginatorOrg: intel.com

Hi Tony,

On 8/31/26 10:44 AM, Tony Luck wrote:
> Both Intel and AMD manuals say that software must first check
> CPUID(0x7,0x0).EBX[12] to see if any monitoring features are enabled
> before checking for specific features enabled in subleaves.
> 
> Each of the L3-based monitoring features is gated by X86_FEATURE_L3_MON

(nit: Sentence should end with period. There goes the promise that the available
AI tools means reviewers only need to focus on what matters :()

To support this change above could perhaps be expanded with "... which in
turn is gated by X86_FEATURE_RDT_M."

> 
> Add check feature bits.

This sentence does not sound right. How about something like "Add checks for these feature bits."?

> 
> Fixes: cbc82b172638 ("x86: Add support for Intel Cache QoS Monitoring (CQM) detection")
> Signed-off-by: Tony Luck <tony.luck@intel.com>

...

> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index 2435eddd24eb..fcbecf677914 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -968,20 +968,27 @@ static __init bool get_rdt_mon_resources(void)
>  	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
>  	bool ret = false;
>  
> -	if (rdt_cpu_has(X86_FEATURE_CQM_OCCUP_LLC)) {
> -		resctrl_enable_mon_event(QOS_L3_OCCUP_EVENT_ID, false, 0, NULL);
> -		ret = true;
> -	}
> -	if (rdt_cpu_has(X86_FEATURE_CQM_MBM_TOTAL)) {
> -		resctrl_enable_mon_event(QOS_L3_MBM_TOTAL_EVENT_ID, false, 0, NULL);
> -		ret = true;
> -	}
> -	if (rdt_cpu_has(X86_FEATURE_CQM_MBM_LOCAL)) {
> -		resctrl_enable_mon_event(QOS_L3_MBM_LOCAL_EVENT_ID, false, 0, NULL);
> -		ret = true;
> +	/* Any monitoring at all? */
> +	if (!cpu_feature_enabled(X86_FEATURE_RDT_M))

Previous patch aimed for "symmetry with X86_FEATURE_RDT_A" ... but the "symmetrical"
code in get_rdt_alloc_resources() is:

	if (!boot_cpu_has(X86_FEATURE_RDT_A))
		return false;

Why is enumeration of these feature bits done differently (cpu_feature_enabled() vs
boot_cpu_has())?


> +		return false;
> +
> +	/* Any of the L3 monitoring features? */
> +	if (cpu_feature_enabled(X86_FEATURE_L3_MON)) {

Could this reduce indentation and churn by negating the check? Patch #12 and #13 seem
to build on the flow introduced here so my comments about this function are split between
these patches.

> +		if (rdt_cpu_has(X86_FEATURE_CQM_OCCUP_LLC)) {
> +			resctrl_enable_mon_event(QOS_L3_OCCUP_EVENT_ID, false, 0, NULL);
> +			ret = true;
> +		}
> +		if (rdt_cpu_has(X86_FEATURE_CQM_MBM_TOTAL)) {
> +			resctrl_enable_mon_event(QOS_L3_MBM_TOTAL_EVENT_ID, false, 0, NULL);
> +			ret = true;
> +		}
> +		if (rdt_cpu_has(X86_FEATURE_CQM_MBM_LOCAL)) {
> +			resctrl_enable_mon_event(QOS_L3_MBM_LOCAL_EVENT_ID, false, 0, NULL);
> +			ret = true;
> +		}
> +		if (rdt_cpu_has(X86_FEATURE_ABMC))
> +			ret = true;
>  	}
> -	if (rdt_cpu_has(X86_FEATURE_ABMC))
> -		ret = true;
>  
>  	if (!ret)
>  		return false;

In further support of above suggestion the code below calls rdt_get_l3_mon_config(), the
enumeration depending on X86_FEATURE_L3_MON, outside the block where this feature bit is
confirmed to be set.

Reinette


