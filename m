Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=192.198.163.11
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1793111826;
	b=r35riz2h0FFItzsRgUOpwaL/n/RD5RsG25IxY+HyDb3FW8s8fpswP5x5T5t7wzmnwIdp
	 o7l1n88+MkW6aOVIGGoxo2Y8bbxYLEXZs8k3cT9kQobtiijZKWGyR3OiChUkXAUvFCw26
	 MQx15MlQPtG2fRGh8ZyioufJxJYwr17IM4az75R0/2LH/nHFUAUEEbGm9NF/TuNLYLzol
	 SsUMa/B+uOYn5D9/hPA415KdzgK0Mwhl0kggLhGjosnGMhQKECqSILw5O3QI0Y2SyfLvo
	 CAxpdGJ6erfr+eI6VrY743e8K0VUBiEZJVcfE8aLCChFqxuR9YaCynJy0oYsNBWXG4Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793111826;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:Received:Received:Message-ID:Date:User-Agent:Subject:To:CC:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	bh=+twemTKKrR3hkhfgPkwxAMSJM6o/J0Lsb8bNwUTxW1E=;
	b=aXHrKMkiI3W++5Ql1VsPuqP/GVWu1pSIjpr7NYsIzSZ7tbgi1xv5snJHaaKDjAWg09Tv
	 a+mlvUWmCATF7o5YL6bw309NFqWcMzoGRp6+OkYNq6G2TlHAbCuIHbSa61Rq0vaG1uodO
	 MB+UFZLyDkCwoxFf7uERu/b0ymgw57/UIiXYedvVMgWqdYr6dd8cw115LJcPtfB7cVQt3
	 6+E9iX3ktRwloDsWCk1vDPOoJcUUCB0A9Gbyg3N7+dlBSb++ADKnX6R/edkl6se0Z4/tg
	 ZzDSSwInV0QhysIrmFVKWojCPXirWpSEtFPvOpvOl4Hw62QX9pyKIGzweI5NejekWHg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=kH6B6N3o;
	arc=fail smtp.remote-ip=192.198.163.11
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8F5F606A31F
	for <patches@lists.linux.dev>; Tue, 27 Oct 2026 14:37:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B8F5F606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=kH6B6N3o
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793111826; x=1824647826;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RkquvR3KOpiekPlWmvM7jfsYNscC+IwLpCavZu144Tw=;
  b=kH6B6N3o1uCVwjaGA09VpzHCHKoDrNDFBfVwFdQkQzi4sy26yUz0OUNX
   OxvgkNIYQtReNyVFZc8gBNj92wSYHxklijSu2Fs8stdE3I5Ah878yesh2
   GE9QzpP2iLHCJPUCjOGRUY+wjnr4j2jsjwJcrYmagMoe1SyD9UErPOzWo
   vyYDzykIuamrPe7aLrVTC0g5lcMn5zIF21aftLywSQgIjfu11IxC1U3oO
   gPSyrQ62NimZawyL0a/Ze28OYmw+BITMFIppUc6pyd1ALvOi9KpHpRAxO
   AX+kcezO2TzHDMPnIKcUM+r2CBak/PaZZFsXJqjiJ8OthoFOewB15jSUD
   g==;
X-CSE-ConnectionGUID: 27mj6IPvRAC/ycqbfxZHAA==
X-CSE-MsgGUID: 61MrOTYLS8aUNiUKbXXdyA==
X-IronPort-AV: E=McAfee;i="6800,10657,11948"; a="1720594"
X-IronPort-AV: E=Sophos;i="6.27,181,1787036400"; 
   d="scan'208";a="1720594"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2026 07:37:05 -0700
X-CSE-ConnectionGUID: wvHtGg2jSzi6r+UH97w0Gw==
X-CSE-MsgGUID: H3CjZwWKQoKxuAwJ8wTDKQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,181,1787036400"; 
   d="scan'208";a="4658166"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2026 07:37:04 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 27 Oct 2026 07:37:03 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Tue, 27 Oct 2026 07:37:03 -0700
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.65) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 27 Oct 2026 07:37:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uObK7kMc0dlwDD+JVZ96+IHvz9GG9KsXt85EsOSmix2hkv8v0v2Y0jjF9e0pr/5XMd/epD8TAA6bROJQZpkfQvbd7dh1Oq6ZR2nvd3x3ENDzA4Oo+jL5IzBL+oit26fGU947zMssqACv0+G3p2O3jm4INHFwS1fTR+yLF+Vt++YfA2ckd/Y7+DrB+Omw0xBFkMOyK1irALhqOQu+INThMezJvLXp+hF30E9FAZJiNIV0Is6GdI5DK8FHVcAOa/+OFkbkcFtXwHh2xJyjBZilkvdV0l6z0alMPZjO/qDVEyu49eGyqHiKyRWLgcBILjHB49msTZUQrr+2WEvNqupB/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+twemTKKrR3hkhfgPkwxAMSJM6o/J0Lsb8bNwUTxW1E=;
 b=IOebYoOxyK2LiB4DE2PjDGXLD6cQt96vcmbk6d6hwpqEpyc7w5lIhEsT6VkMhWfsB3uUUlo950e8adq03nc2N4O1wtKPTtr5CjwOA3Z0zS0R0sRSHe9iOOgxkKbF0GICTAfW3ORqOwV68j+FlYhoHUOyexvVWWYBELXJRZAx0P7YMcwySBBRpXRRgyZG1GlpXNre25PDyibiPrjsG5yJnQMvMtXQVRB3tcVfbdDHgV8hz58df8WnOZOHdZnzXJ9oEJEXVmmAn9pqOhaH/lPYzYRxG6vIzlBJEBCToVOlnn+hHC8Jr+lzZeMxeTN1Xsg+GwzqDeM0kSt+6aA+7dD+Ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by SA0PR11MB4685.namprd11.prod.outlook.com (2603:10b6:806:9e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 27 Oct
 2026 14:37:01 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%6]) with mapi id 15.21.0546.016; Tue, 27 Oct 2026
 14:37:01 +0000
Message-ID: <6e0483f7-1b45-4c70-aa00-51e43a6d7305@intel.com>
Date: Tue, 27 Oct 2026 07:36:57 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/5] fs/resctrl: Drop unnecessary parameter from
 resctrl_io_alloc_parse_line()
To: Jinjie Ruan <ruanjinjie@huawei.com>, <tony.luck@intel.com>,
	<ben.horgan@arm.com>, <james.morse@arm.com>, <Dave.Martin@arm.com>,
	<babu.moger@amd.com>, <bp@alien8.de>, <tglx@linutronix.de>,
	<dave.hansen@linux.intel.com>
CC: <x86@kernel.org>, <hpa@zytor.com>, <fustini@kernel.org>,
	<fenghuay@nvidia.com>, <peternewman@google.com>, <yu.c.chen@intel.com>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <cover.1791406459.git.reinette.chatre@intel.com>
 <b01d58ebb13c6cadd68c0fb33f469fdb32dcb597.1791406459.git.reinette.chatre@intel.com>
 <4b671902-3cee-436c-87fc-55ec1cb14782@huawei.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <4b671902-3cee-436c-87fc-55ec1cb14782@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR03CA0138.namprd03.prod.outlook.com
 (2603:10b6:303:8c::23) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|SA0PR11MB4685:EE_
X-MS-Office365-Filtering-Correlation-Id: 9047d4b6-7cf7-4659-bff1-08df3437c308
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|23010399003|366016|1800799024|4143699003|11063799006|56012099006|261026121527099003|261021121427099003|261022075727099003|261009223027099003|10067099003|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info: FV/4wbxJDlyAM2kcwp/sn6w+NnkSKNV1nd1M/324YoHRZwwHSysZz55arq6u7aXwC83IEPaXPLuCkEQnFrKZSXC/SrVADCr3Gg1bnWbyhkffBdfTpwcgRu2UtNmHNvgTU+7X5rbEMCdKbdQVqKAnmraLUMIkWk8m3HUJE+mpFGl/SxyieVOqMVw2Qe9sZt0tYTXsBELXdC7N/5i3rhYEHRQrXBMbSs6LHMR6JKDSHJO0MDCz7JSjXENlRX6wwGHDtX/GdhQcyC0xmPhkL9icOaYzr8lAbgsqbSF1yCLPQ9ttlk2xo/HH1SkaLX3zWwiaj4mGV7iP3xg6grERgyoq4Mud1NVwuHNBEYLqBjwehnMFxUtkBeswWY70sNCR6stBLEaGnMuqXooNRQRVS27Ky0SySkzTyFtTnfwCO3emagr5nSXHRh/v7TyFThnAMAT/5+ZUuqrLdzEdXC63EGqy8LIY30SLpEyRcPnLd+b7fmdKcURk5OcO4PvL/ulnZi1Uf9Uq7522HpsS4oGld43d/9XzZiNC61nXXBHJN+oAr0CUS1ydSQmy0c3YvFgI5L0YTW+/IqSW1kH2W/tJ7bunE+pna3p/sv8v6YgeB3ayRhhaO8HU3n+DDBGU0oY9bmvBQ+CrmNA3XtBXt926pt1g1cCIrb85xothLeQ5qzz9hZg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(366016)(1800799024)(4143699003)(11063799006)(56012099006)(261026121527099003)(261021121427099003)(261022075727099003)(261009223027099003)(10067099003)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K2hYTmthVC8yYkRRMGdIQ2dpS0sxcFZxZ3NGTmN0aS9CSGYrb3BsNU9rREtN?=
 =?utf-8?B?VlhQbTJaOTl2TkZGd3pKNVVXVnJEV09WNjNiQnNUM2cwNWFUVVRuUDhvYWR2?=
 =?utf-8?B?UUV4RG5ONlIwM3Zoc3poRUtkaXZMUmhVZm1XazZLbmd5TVJDNXduYys2WUJY?=
 =?utf-8?B?eGYraFMzME9vVHlSWm5XdzRCbDNDWFloVzdyUXRTY0MxbmtCQzROMCtJd1N2?=
 =?utf-8?B?MEd6dUxUTWF4NmFqNVgrTGNab0E0ay9VOHRweFZ5N2JtNWJkQjZ5bHVNV2FY?=
 =?utf-8?B?WUpTZFpzTUhaTS9lTlU0QjU2T01yQURNbG44OTlqRkNFUXg0Ykx4djMrZjZU?=
 =?utf-8?B?ODdDVitOemFVVGhIdXdWUjBPTjBDSi9ZQlRMeVV4T1I4Q3VqSVhCZmIvM3NG?=
 =?utf-8?B?VXhqMld2WXY5ZWYrU0ZubE42Y3FzaWhZTTZPT0sybUxKL1FKZ1JwRk9kSEZS?=
 =?utf-8?B?Ym0vNmdTQm9Mb1hWWHhPMHhNYlZZWVpHVDRXZkJBVXUwWDZ3Njc5U2xwbDkr?=
 =?utf-8?B?MHJkZi9FQ211V2RwN0pHWTFVQncrMVhTRXhnVzZPUFlLSVJva0VzSjhkSElk?=
 =?utf-8?B?VmVjbklqZHFMbVRyQkxGc282aWZicmtDVHFrOGg5U2dQSHR1c0tWV3g2MFN0?=
 =?utf-8?B?Q2dpdDg5VlRBeE1jWC9sL0dsenJTSjhTZE9YcUI4UEsyclQ3L3BORmpURXZB?=
 =?utf-8?B?aFB3TGdONmFXdjRQaFpoRjg5NURjMENuMGlWQ0p4SkRWdzNFWk91OVVOMkRS?=
 =?utf-8?B?Y0dOVDI2cjJOcjhsOXZqdVUyVzQyWm5yTGFOcE54RFNJNER6Q21BVUc2OFRr?=
 =?utf-8?B?bXhqQ2VMMmp2a1dYNU5ZQWgvcEVWTXduSnFnckoxRmRxcTl0K3p0SnNCblo4?=
 =?utf-8?B?ZXlWdTEwZ2k2a3hCRnlhUWdERm5CTm04MUR4Ujl2eW5Qdm41Nmh5ZGs5ZkJH?=
 =?utf-8?B?cDNtV2F0b3ZoanF0QVdrMEpxb1NTWU5DOFNvZlIydWFGcTRlVVZvL1RUT3Vx?=
 =?utf-8?B?dlhwZlJlRmFqcVl1QVlhdENSb2d0Q3NRMFBobC8zYTZxMDRjSlpkWkN6ek5P?=
 =?utf-8?B?U3dtaGdNMTVJZkpuK0cvUXhhSzdJbE5ZdEZHZjhnK2I5REZEaHlNUE85ZXBY?=
 =?utf-8?B?M3lDWXFsc2pWNzBlNGF3dTgxTDRaMEYydFRrSUFEMXpNMVlJejRpQ3QxUVAv?=
 =?utf-8?B?cnR4L284ODdabEhOeXFFM0NxM1dKUHFYWEdKZDN4eVp6WWltbEwwWFFhZDdQ?=
 =?utf-8?B?WWJiMFNpVnh5VkRMZWo0S1NRQ2JoMTVqSDdnTU80cW9tWDFTS29HTEdhNXdI?=
 =?utf-8?B?dDVhemZNM1l2blpmK3JIK0IvN0c4YjZEWFhNRk53am9ETmpwVnZuM2xHTU9F?=
 =?utf-8?B?cjlPdlk5MzJGM0Q5WXp1Sm1kQWVhSzcrQ1JlM1U3VHZHUmtOaGtaMU1XUkxm?=
 =?utf-8?B?SGlZay9uc1l4WE5KaE9PTVpEY2pzR1g5ZmhhNHUydVB3bkhkRlcxUWkxNDVI?=
 =?utf-8?B?TmVTWHlMeHhubEU0V2k3a3NaTDB5Q2J5R2liZHI5L2dSZ0dyWFE0dUxNVGV2?=
 =?utf-8?B?WExINGFYYlVaS3VoWDEwVEVab0NIT3F0WG1Ea1lsd0IxZXdYazFpa00rWmZB?=
 =?utf-8?B?WDg0aU80b2hBZnpOZGI0dTBVREZha0hLWDNYdUl2VTdFVjdYQmtiSVorNWZW?=
 =?utf-8?B?Vm5odnpjVEJqOTVYMGxzenJsMFpINSsvdmp5TTBSd1R1b2Y5aW1ZblpuZzIr?=
 =?utf-8?B?NnBEZDZEV3I0N3lPdktHZXdvNThralRtV1pac2J1c2dmRHMzT25TU0ozTUxk?=
 =?utf-8?B?d0RGZ0F6VzBGM0Q0eDZOc0NZaWhCUkp5U2hkN3hpSG5nWWwxdDlWZnFWNjZy?=
 =?utf-8?B?ODlpYTlJbHNRODlsbXVRYzdMUDJZbjhUc2pHSXNLYnloaW44M3A1VUR1NWF6?=
 =?utf-8?B?RVlUWEhPUHJBT3R5bmdZVFFCNTk1d3BPNTZQVjZhRm55OFpPVlYvZldtS1d0?=
 =?utf-8?B?TzIxTnlvNUlGVlVaSjNXWnZ5ZndDT1JSd0EzSFg0L3RsNFh6aEFkT3FpOUJx?=
 =?utf-8?B?cWJBWlBOV2tGSUJzUmEwVXU0LzRGZHhnUTdVMkRjVFZrZ2x6L1V3OU1oc1ox?=
 =?utf-8?B?ZmZLemZXSkN5c1ljUC9HVmhCWXlPWHUyZDhNaUdkV0sxMExVcVkxbjcxTHF0?=
 =?utf-8?B?VDl2VlZXVnY1WlhWbWk5M3Z3clJCSmpDMXQ3VGVnTnNhd0RXQlMrN1JPMXFi?=
 =?utf-8?B?MStoSllmSDRuL3NoTUpmOEVHZGRlQXJHNFlDamxDc0xQUTNUZkhBVllNbVhV?=
 =?utf-8?B?eTBkUnhNSVdEa0lEUU1ONUtVVTVYMHB1eFJDWWhCY2x2MEczUjlIYXlKMnlh?=
 =?utf-8?Q?iYlv1lL0ALNr9rXA=3D?=
X-Exchange-RoutingPolicyChecked: HEAQ9kbq65kEED+LfxABvFbEGjG5EztztVstHtsmRoDNa1gr01eDureguZQbVCd7tnGcR0COLRxAMwK6nQWt1diYiY9uX458wBqMdEl+DgjE75gKHPUrqwVkg0aAsUseyuSdcP52XvP4B5UeBkPLq1A4AO00zV8G9baK6JUGdIqBuz3yr+eI7y4DwRjM79RjIJfxn6z74Rlb2r1Nt2L1xNqDXqVjbzw9nUVZXPA4BfxMrPAQv2+E0x26lyKOvZeGPpb8yaDm7LmYGR2W+LvTcR7+hGKL9tHaMdya7FFkIxNZrcgC/4cxlRDuoNv/m+8ODxt6aYwoLPMGU/16fe8pCg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 9047d4b6-7cf7-4659-bff1-08df3437c308
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2026 14:37:01.2049
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BvUu1KkHZZP9sJngMGRfCIY+uJhtSZ4XgYaUETX1nwl9x3Wc5gzjMccj22zC44k6eT+t6xGwuC693c6nkAdGYIXnnRQgT3KTqG6Jj2qQDOA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4685
X-OriginatorOrg: intel.com

Hi Jinjie,

On 10/27/26 1:35 AM, Jinjie Ruan wrote:
> 在 2026/10/8 5:06, Reinette Chatre 写道:
>> resctrl_io_alloc_parse_line() parses a line written to the io_alloc_cbm file.
>> It receives both a schema and a pointer to the schema's resource. Its only
>> caller looks up the resource from the schema just to pass both.
>>
>> Passing the resource separately is redundant and allows a caller to pass a
>> resource that does not belong to the schema. parse_line(), which parses lines
>> written to the schemata file, already receives only the schema and determines
>> the resource from it.
>>
>> Pass only the schema to resctrl_io_alloc_parse_line() and have it determine
>> the resource itself, matching parse_line() and in preparation for passing
>> additional information when supporting multiple controls.
>>
>> No functional change.
>>
>> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
>> Reviewed-by: Ben Horgan <ben.horgan@arm.com>

...

> 
> LGTM
> Reviewed-by: Jinjie Ruan <ruanjinjie@huawei.com>
Thank you very much for reviewing this series.

Reinette
