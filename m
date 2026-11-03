Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=198.175.65.11
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1793729636;
	b=1pwF6hONc1g73j6dlwKdAwKWv/mrOJMaBsgo7UveL2ZewlwxSNqoO36wAO4TUpxpqqZg
	 PXRhwGgGe7gdrnpdSAOyV+uQ/sDWdMSqTLifIa7/hnGYUDtaeHRe5xvu/xMOlYfeYEvKb
	 CkyqY0RQcb5CQAGGVJrYPEUbF4UwYYtzlsrsYrMr12OsHkUylCMcaEZeN2RS9M11HWhtf
	 CAFIjAbpXUdvjPB78SHruzUCVO6Nj5i+qsSW6jN+CnY+ZL3DyEawVgN+/Gc0aTUk8e/dG
	 8Cxyg6hNuljsTwe5SNS3NL6ajd1qVVJsAYliKlJQAS/gvJP9nzDd2UtHTPGQCPhPGRg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793729636;
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
	bh=RGRLpeiQDVpgpyNfCTWfzcOPeVa8dACW2J+OlMQhGVk=;
	b=4utD7PtTXLev53EthnydKIAWbdSg5XSUWK4SkqYhJyKK04dBbuaERbGQ6Rx4quffhrKA
	 qjgXhhurPHcSJNOvVccsNLPPEAxqsNFdjWFVHZvqAVfFqiqJoaaRPZFL1cx0vtKQqez6n
	 NmGuDa9JODS9Yq9oYhcg+1F6Diem4y2xujwiD5CdpRtQGrOUHFBwm64Xme0Yod2Ex2cKL
	 tJ5UNVKAl7E4EjK95ZzOgHPVbHya1jLA7DlI+oFfDtNIQqJCG3JVR/tk/lSccrZUCoDuN
	 ZtjqhUFYU7+1aqqbNiAkskED0M8yJzV3nnyOFX8N4qBLFi1JtXKYRdOgf+naRzbmung==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=ZAeRdVfU;
	arc=fail smtp.remote-ip=198.175.65.11
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14901606D83B
	for <patches@lists.linux.dev>; Tue,  3 Nov 2026 18:13:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 14901606D83B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=ZAeRdVfU
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793729633; x=1825265633;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TZQsXYCE0+Kejl4simNQSmLKySW17SGXxEMszVo4ti0=;
  b=ZAeRdVfU76DSdqsfK6Pp0oFxoRyRlfKvButn4GTdODCJagQtZlAYs6eu
   RicJFUu80LiQHPNl7i2Zo3tvgTULUw56Y//umvJlsESwTht9fGy2Pf6oz
   xqhYG4jn5XqHbTH5ENptMcMVhPM6Q5eH0MqQ/dfLpug2fbfZcgV+8Jblf
   xD/+Q5npguW2GzsR2U7M67n9VG191FYgEZqWOZhYpN8EiZ9zE+1hUBZRj
   FSjua6ORgVl0sGCmsg2fmZ8RS8NRnTl+WOYHjpEV9G0Chh2jnGFcAG1V/
   /mHYJT9iDT9qITy+zzz6D2p/x20Tzt4pUiFyggMNwDbIGgVckHz4ZRReZ
   w==;
X-CSE-ConnectionGUID: K902/m6TR+SaEA6kj4Z02w==
X-CSE-MsgGUID: VpbM7S9nRT2AcMifrnpTkw==
X-IronPort-AV: E=McAfee;i="6800,10657,11955"; a="2347243"
X-IronPort-AV: E=Sophos;i="6.27,193,1787036400"; 
   d="scan'208";a="2347243"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2026 10:13:52 -0800
X-CSE-ConnectionGUID: X7LPckgqT2aQeDqx6xCg2g==
X-CSE-MsgGUID: EcpaJKXXSVWDS3wmTK7h4Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,193,1787036400"; 
   d="scan'208";a="6490355"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2026 10:13:42 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 3 Nov 2026 10:13:41 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56 via Frontend Transport; Tue, 3 Nov 2026 10:13:41 -0800
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.38) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 3 Nov 2026 10:13:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nVCHzjUtDONUeRH2mOm8d75zko65Xcu+QmZt4+Arc6zwlolqR5fejoBg9OH3AeonS8Dt254WjKZwHbEUPfOhVaFq3u6VJKZHkp8ZfkvaQvVrg/lEzbNrwmrD/zL4GHeYSpnJENNJCFhP6QEsZM+91wfe3WuISiLeJcqGeCNg/qMhmQ+iAcAos7OOZtAvXgApumzQkPJQH9/h+GMbJ1XP+CqsKJh2p4ijYvURP9hzTVNGVJQcM9a2JiTBrZ1IT4qq9yIM77rF+mCcXiP6vpCpnDBfUDGUK/jwBkDWh1V1NK6m3QX2zEjZKWnqZpIJJMiqVbuIfGMXa1pNI72fvW/yxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RGRLpeiQDVpgpyNfCTWfzcOPeVa8dACW2J+OlMQhGVk=;
 b=MhTFALb8x9tUQstifn40q1YpYK92nmRRrjhn+Ij3I0HYZO9DJIMEbOsIGNqyMq2j1sbV01wttuTeV9/HLUx5rT43a7xRaLi2o77nggslwlTZmKEwaOheihf206U+dlIZ4qKDlbDiGO6h8kgP/J+xJ16CWYzOCEGew3/C6UtPXXP1jMruneamLxgsThAQjFM/3rCZDZQNyMcm6+NZiyGum6PzsuSaAM6Hv7TcgETgUsS7JrAEGYZh4131lvJBIUJLM8j0W9SiRBPKXaPQphsS61zvkrbkemTJGCr1e//JBMsevIMVj83mOmgk24lvdE4pc7AIUK7byZy4MNnuhVhBnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by DM6PR11MB4579.namprd11.prod.outlook.com (2603:10b6:5:2ab::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Tue, 3 Nov 2026
 18:13:38 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%6]) with mapi id 15.21.0569.011; Tue, 3 Nov 2026
 18:13:38 +0000
Message-ID: <200bd69e-61fd-4680-8e14-338e2d45c266@intel.com>
Date: Tue, 3 Nov 2026 10:13:36 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 01/10] arm_mpam: resctrl: Use find_component() when
 allocating a domain
To: Ben Horgan <ben.horgan@arm.com>, <james.morse@arm.com>,
	<Dave.Martin@arm.com>, <fenghuay@nvidia.com>
CC: <tony.luck@intel.com>, <yu.c.chen@intel.com>, <babu.moger@amd.com>,
	<fustini@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <cover.1792443633.git.reinette.chatre@intel.com>
 <94ddff51b91f4a51965baf0384c2368e292c1a8c.1792443633.git.reinette.chatre@intel.com>
 <308b326e-9fc8-4d49-9c85-c3b9cb9288f3@arm.com>
 <9400d7a6-3d00-474d-bf1d-6db1a08c16fb@arm.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <9400d7a6-3d00-474d-bf1d-6db1a08c16fb@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0340.namprd04.prod.outlook.com
 (2603:10b6:303:8a::15) To SJ2PR11MB8370.namprd11.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|DM6PR11MB4579:EE_
X-MS-Office365-Filtering-Correlation-Id: 1dd16100-10be-4f8d-b3f1-08df39d62ebf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|4143699003|11063799006|56012099006|261028144727099003|261026121527099003|261009223027099003|261022105027099003|261026140227099003|10067099003|22082099003|18002099003|13003099007;
X-Microsoft-Antispam-Message-Info: NT5qdVhb0TyFDI0pe2A8Wxr0+7If3LWJJ46MfNjvToHgwCvLf0srRRKzm3hxbj5eVNXS1xaCprX3Slh+HHLmv4CcFq6ned3F2IByCC5OtO6PkS6fTTFub7yL1yPCq6dzhhFEeupz4wF589C89O++Dq9spks8ds1LJInYzdi5YEz3Fw58QQzsEFmfSVgai/F9fJ1xRKtVYwXhvfcPgDZYgvh6RA0hhPLQ+bs7KEEJNy7padLkQnKXEsvmdhnHbRwUGvgSa/LrsWYaidvdoB6wGZT8Cp36kxMchERVCkecIJBgTJ61OxbA/asHm99NmtYMJ+md6oUWua4wEeRm9yrIxFTCAK+GXf+tzLvsTH6/X2n3V45Osfsvi85LJVI1IChyIyehteLo71LTU96JISNiurEfVoH83+s069vrkxRP8L7ln/AwBcEkPyuPCxvsf7orlMysSVEOT9k0scFgd3puot8ZCuW7/Y+kuvk07Z4NYJe4j+4ro4TnWCDB6a5T7Go9PYd/GbzVA1CjKD1SsIAIjt2Caqv8aaCpjwEqWdMvcQ0W1xd0Z8HyltGVhdktd1NzYme4e92iIVR4xIrVyWKqwvTwYeua85Ymu1dJ7awqjUY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(4143699003)(11063799006)(56012099006)(261028144727099003)(261026121527099003)(261009223027099003)(261022105027099003)(261026140227099003)(10067099003)(22082099003)(18002099003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UHJkMWVBamNkdkM4aW55cWt0Y1Y1dEtxM1k5NzU1bnVBVjNOdG84K3V0OUU5?=
 =?utf-8?B?RVhCMjU1Smp6OVIwL2NKeThDaWxvOEQzdFRYVlNmV0R6YkduN0VDRHNoZ09K?=
 =?utf-8?B?cHZySTdzZVNXS3Awbm9zaUx6QUJLSDcxVUMzU25zdHNmS3Q0Z0VzZ1VLejV6?=
 =?utf-8?B?ZFZ6OS8vMm5tRW1QeHhQUFJTTTZiNUV5OGZqd09TQWd4bWhDNXhtUWlEMnAw?=
 =?utf-8?B?b05rZ2tEMGZNSkJqdzBHUmtSdVl4MGVWVmo1cG5JMnliSVVrR0lhcjBWMHBz?=
 =?utf-8?B?dExpamlGNHFVdE1jYUZqSEV2TFNDekdtcFA0VTB3UGMrZnBrR0NiRWhPenVR?=
 =?utf-8?B?Y2RvNjFMVWM2djNiNE4vZ01ka080TUcyVUoybFlWTks1Qk5VSjFKNFd5WDVF?=
 =?utf-8?B?R0wrOCsyZ2xJa2tuRFplY0E5WXlRSHRUS2JZc0FEdHVQRElYYUZoSS9CMVdp?=
 =?utf-8?B?Z3ZYMkVDN0crREdycXlKMm92T0MraXMvRUIzaG8wU09UZ1p2Qkh5aUZ4NENq?=
 =?utf-8?B?U3oveXVPT1VWTEpKbks0YS9QK2QxVkJQVkZiMHBjS2hJZlRoZXNORytrRU9w?=
 =?utf-8?B?VGFpczRDeDFHRjVvdlFZazFjRUJsTm45L2R4UDNBODdTZC9tS3lFTTQzUGh3?=
 =?utf-8?B?WUJMTmd0RFpYOHBQQlN1NHpHVEc2L1VybVEwdy9TOGtvOEo3SC9DWGpMMG5H?=
 =?utf-8?B?aW1PTkQwendNamFpWlNYanNLYW5KdWo5b0pCQTZob2F2R3AwSXZMZEF5c21r?=
 =?utf-8?B?ME0zc0F1RXlFTmo3dE5CV3VhZ3hsclBPWkdEQldCTkFFNzlrOFlEUDN4dDB3?=
 =?utf-8?B?ZTBUOWlWSE9DU1R6NHF3em5zb0h5TW9vcWJrZTFzZ1Nzdk92eEY0MFVDZFd6?=
 =?utf-8?B?RmZNQzkxQ2dYUFBwdFUvb2ZaY3RpdHJibCs1aGw3TTI2SStvTzNTOU94TXNO?=
 =?utf-8?B?Q1FuMTE1L2xEUjRLZFZReUgzYWVRc29wWVhLWUJRUklRVkZVSXMvcmlOT0Va?=
 =?utf-8?B?S1ZmRHFMREsxbWY4VlFFWUpZeWorMGNTUnFienBtRzlBNVFRMmx1aWdmMWV0?=
 =?utf-8?B?ZTh6TjRsVzFsUSs2VExsaXU2cmdMUmJMeURNNTlKbm1vYVBISEdvdzJKTmgw?=
 =?utf-8?B?MHhJUlFkSWdzbFpRQWVNRU90UWpzUHJTVHVGT3dzZDFnV2czSFFCYTEwbmlJ?=
 =?utf-8?B?bVFaVG5qVTJ0UGRvaFQ1WTB6QUJyWURCWmt1SzYxUEJBSGU3SDhJOEZVNWti?=
 =?utf-8?B?S3R5djExbGR3V2NJaStxN25MTGl5QXh3dCs3RGlKRGt3VHc1anU3UXFENlJW?=
 =?utf-8?B?UVRvS0Ixd01VT0VuNDEza2RhWUlGWC9MNU9ybzh0VzE2QkVaNGdFUER3S0ZW?=
 =?utf-8?B?ZnFScldBWnlyVDhRakZoV3NDc1FmalFNRndOWDdlN2pzRmNkTVBTSUs5cGxH?=
 =?utf-8?B?VzA5QXdYdHV0K29Relh5emd2UE1tazgxaHJ1NWVEaDZhRDNiRlViZGw4ZDBK?=
 =?utf-8?B?RVROY3l6SHRvL2tLUUt2UVlMWkZKek5QaWVlLzlZUE55MitFTVZaQmd3eldx?=
 =?utf-8?B?ZEhreXhRNjJ2Qm1jczVabFRaMGNXaUtreGg3cVNHRHNwZHErOUJyRzIrUkg5?=
 =?utf-8?B?MEkzK2ZiZ2JJc2tLeFRXd2kyZHZiU2VjQ3E1aUZhMzZXWndESmxic2wyb3FT?=
 =?utf-8?B?d3NYVEVTUHAzU1FSUkU0c2FNaHdrMkxBcVFRYzcwN3NHa3RvWDhTZnBIRXJy?=
 =?utf-8?B?ek9NaEoxY25XVEtBeHdZT1NQQ0s4ME8wVnZYT0pOQVFyQXdWWmtjNWNNMCtQ?=
 =?utf-8?B?TUI5dk02RUhCTFRHZzYxeUs1bUVQbFQvd1pOZU8xajhVQUJZMFVaMldTcDZv?=
 =?utf-8?B?RVE1VWI1K2pYallNZW15c3Z0bDAyVUJ6c2l0aXRFeHh5YXFtNjZ3S1dnNE00?=
 =?utf-8?B?N2NwSjcxWE9CWTJrSnI3UENnTGhWdGhGbThWTWI2d283RUw0MHA5Nlh3c0RG?=
 =?utf-8?B?aktPbFlDU0FSOUtuOVAyaDBuRjE2Zk9naFJRSkpBQjB4OWNpR3JzNmovTzVo?=
 =?utf-8?B?NWZzcngzT05CK09wR1ZLb1pGekZFYll2bHJscjhuVW15cFdmdDA5Mnl2cjRU?=
 =?utf-8?B?cVZ2TjNCN3ZGb2RZT0hnbjNVQlN4WVFwbDdlS2RqYVZ3RHhJeGJkTVJ5TklY?=
 =?utf-8?B?VkZ0SFVFWU4zOStuS0ZqTk1KUlhtK2JmOVFXS1VkT2FUV1Y2akpqOWdwWlpp?=
 =?utf-8?B?cGhaTk5UeWw3ZlFubDNaNEsrVzlTbFpJV0t2WENWVmhpRGF4VEJZL2VQV2Rp?=
 =?utf-8?B?RzJLMG5zUHU3bTZIZ1lFRVM2QlViWFducCthS0JmWVVjT1V4Z1BoOWEweHRR?=
 =?utf-8?Q?04W2sUnxsrLIQKwY=3D?=
X-Exchange-RoutingPolicyChecked: bO4owHclYJC0T9EUJyQxiAon6fBNluRHHQRTp5AEtwkrRKFr29T1W242gHnB8XqO3GD5erqQKIqvClar0jptP9ClDZblIwDtmwDdP4sx6AXcKUEHynsTSPdSVSa6LOEWeQLZYJ80kxl7C2KzHAiO6hN8IzR4LzQoQ8+Ah3MdOD5uforWI0lclGMahUsGkF33tzofN6fKmTUDCaOlGmcS24ON3gCS2tX28BUCP9pd+BB9YigB5/5m0HgDcfW2Cw6e8T2Mjtbwh++992zJmK8wyt4vi75G7LNqB8u7r+8qKi3Sxa7oaPUtcFTIu5pFwrBTwif6OdWqbw/uPoHQBaJcvg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 1dd16100-10be-4f8d-b3f1-08df39d62ebf
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 18:13:38.1508
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NU742PV8WSam2RXsUUNSAh5xG/C48Db3kNt4bi6H7AZLMTz7HJBSVtgy6yvzM8+Q79giCBagCsm+NTPSRbWF/GBn/5SgbuXq/YZD/cPQL/Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4579
X-OriginatorOrg: intel.com

Hi Ben,

On 11/3/26 9:48 AM, Ben Horgan wrote:
> On 03/11/2026 15:01, Ben Horgan wrote:
>> Hi Reinette,
>>
>> The change seems good but I think the commit message can be cut down at bit.

Thank you very much for taking a look and providing the needed changes. Since I
am unable to test and especially since this involved a locking change I ended up
with changelogs containing more than the usual reasoning about correctness.

> It looks like this patch also has the plus of addressing this sashiko
> report:
> https://sashiko.dev/#/bug/linux-9a564d61-b4d8-400d-b4b9-cd5f20729468
oh. Would you like this commit to capture this? To do so I can add the following tags:

	Fixes: 09e61daf8e96 ("arm_mpam: resctrl: Add boilerplate cpuhp and domain allocation")
	Reported-by: Sashiko <sashiko-bot@kernel.org>
	Closes: https://sashiko.dev/#/bug/linux-9a564d61-b4d8-400d-b4b9-cd5f20729468

Reinette



