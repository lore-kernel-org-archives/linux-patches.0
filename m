Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 682BE4D2EC8
	for <patches@lists.linux.dev>; Thu, 24 Sep 2026 20:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790283481; cv=fail; b=lYkJo5V6AyyQCJNmIeJ5ElBLNl7aKjslFq+w9X7hNN6MMDtedks0IrcWNqGDxp7pru4Gq3scnZP6ouT793P80dVMu6SqXRGvV2YG8G00XHhM9VeGuqgMWVoB00vgNZQfTPdZbj+03YH+iHyUa6bhBHyBLOxQZke9lukYyjeZGNg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790283481; c=relaxed/simple;
	bh=0vRNr6ROaaEiTQxiO7H2Dbf4CIu5jC1fpIyyQpYQ6Ds=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=g01Kc5VV72B9rJ8Z3oc63X3hL8JekjDeST/CU4MvIEWZ6vmeGed+ROYdrVnEIwyecxn5Oo8QRWcIcrpSsubZdkEfbUrXwgyzet0m9BYtZ+S7KmPQhuzd81oo8sfIHudXHVEtb3aXHznYtq9uoZJ6K9c17kmGlDlxAnSLojYRVnU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QaYxu6LS; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QaYxu6LS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790283479; x=1821819479;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0vRNr6ROaaEiTQxiO7H2Dbf4CIu5jC1fpIyyQpYQ6Ds=;
  b=QaYxu6LS9uoli/qZAPhR/KPBEFdvok167L3uyqp9P/vPAj2RZHpef9ha
   ATs4aG8cRe8wyuyMgDr9myBGhI+D1qKpz/eo3CpZUtYD12ST8zvh7dGI6
   fqKK88GS2b5TpotH1f20JMKujugv4PD0HP2T9ecbM+wJATXGpxoro2Z+E
   7vMvrtmBEqj78j/feUr/Ay1rg5Fg5woAlro7Q2FdLHR5ZPqLqZai7o8bZ
   n+wvlGUpgXOME5dx79nakuXXZcJu0b79bA6kzTXP3ODjb0mRREsW2IYq1
   gh6wP+4i/kLL0ot0g4WjIqBF5RhKXzMPA1dnPG+tDyFNG3md6YZgpztiQ
   Q==;
X-CSE-ConnectionGUID: 2QoQKX6LSSiT905AxhYLzA==
X-CSE-MsgGUID: XXtNtvBkQhSQ03JLxbGUKg==
X-IronPort-AV: E=McAfee;i="6800,10657,11915"; a="108560812"
X-IronPort-AV: E=Sophos;i="6.27,121,1787036400"; 
   d="scan'208";a="108560812"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 13:57:58 -0700
X-CSE-ConnectionGUID: WvuaYpjFSM+TyNqqPb9xJA==
X-CSE-MsgGUID: LClrYNX1TwK1YKcvNWz05g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,121,1787036400"; 
   d="scan'208";a="272260394"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 13:57:59 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 24 Sep 2026 13:57:58 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Thu, 24 Sep 2026 13:57:58 -0700
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.59) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 24 Sep 2026 13:57:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YPNZXzoJwrquDbCl98+5krqx1MrSogPPfc/7Kg6Hxg7BHsWklRGytESz8NN1cIl2BDWO8Gx2h/C8l+4A0nPcdNV0XCO+QBEiogbt+2oxT963Ii2UW7nQTw/8XIhHOsTE2zb7/AG++rlSSHfRuAgNvwUyB/eoQjcg0PqMnSTBrk5Jcfls1zVFVFRmowQJEIfKtHOqqQZph2SCG8BtjVjEV22k8yKDL1nAZl+R1UBL+xoMeSYmg2jSs1+aeKZmdzHqwlZPEJYbXrZjqD600bcYYpG8PxWUxCFlCgawjtsv1o7C6F6NES4CJUJZCvQZA2t7It4Of76HQ/3hzRwp+/Nz0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hlbXWNQ2YhKvDSgc/QX5drOphr9G+y83NyNdWGVxNrs=;
 b=UwL06dI3b2EKAYrL19BRMI0y4vI/hl8ZRUQbGJfVApazeM8ZOckwrAoO5o+5SUtbRD+gQ/tI9SDgzNNP+XRBqfbTZForS/TcZY4tMHy3sfbs110Tp2EaRjUk0b56HDQGdmOIxN34yZZzMvGl1N7S4HZwgDmerD0+TazoXjfPu2cgZGftIZt7EUQ1WQltaEApGcfCyWjZLnBQeXsjM2aKZhqB1FsfjXrxyEq5mYzhwdSMDFUkZTEGdvf4qbTWrMeGBdSoFiWCrB/E5GouYEnDu7jSrzUzHNA7IojcUhZ4MUN15nHvv7Mnb7ex/mjB5R9iz8JENj8+OK/DiyN//7UN7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by DSVPR11MB9916.namprd11.prod.outlook.com (2603:10b6:8:45b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Thu, 24 Sep
 2026 20:57:56 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0451.014; Thu, 24 Sep 2026
 20:57:56 +0000
Message-ID: <15de2e2f-fc2e-4d06-9179-100398865624@intel.com>
Date: Thu, 24 Sep 2026 13:57:54 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 23/25] x86/resctrl: Require 64-bit x86 for resctrl
 support
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260916231320.14502-1-tony.luck@intel.com>
 <20260916231320.14502-24-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20260916231320.14502-24-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW3PR06CA0011.namprd06.prod.outlook.com
 (2603:10b6:303:2a::16) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|DSVPR11MB9916:EE_
X-MS-Office365-Filtering-Correlation-Id: 84e43871-e825-41ee-e252-08df1a7e823d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|23010399003|7416014|376014|921020|4143699003|11063799006|10067099003|56012099006|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info: 6zud/vvUc5hHz3/8r804Gj3//BWVzpXGbA6UzGtv3ecqK+f+xylUyy7pTCf40HY4d0eZP/yIT2mDktpMmDUeoWFp0gBKXMVLJcAHZVl3ayXLbYat7VIHxhkZC4eNNA5Zv6uaD9DlgoxiSBH8C7OO44x1VtvkK7wIXYHD1R+GTOIUurjwHppxTrnndSz6a7Ysd2LB0O3gOrVwOMDbkLd1XnCmwQzZuSTa5zRRUFnlvnur3zQOSGNtC9fTgokLjcZ/WjtoRf+1u267wgwvxUHnJTHgOwQyYa771lvNCGQOpFfYFgxakbKIbXtwQyRml3TzHHU7BMyGoTxxsZsVCXGr0WZPTKReDKIN8//vH9CH270PhalLLyd9uO0q6DbMIYtM/hBl8U+7BNZtE/D7hFYKlj6agr4taNpbF2euZ9m72AhUZbHVF1xoeMFrfsYvFobe9WUKnZYofYhM0wOsOPa/J8EKUzBU9BOhZMHLANnTx+8t+ZRWz8TnuCbsou7Bye0wqN/Y2oDQHJrCE/VEewuK3PHw73s0hCbVhbAhUunD/kC6Hd0cmBHUSAW1Aej8mVLo51CHPnoEkvXBjwhGdN3LV61e3gciMliYzc/jOW6/XVmeFhJDLjktHcQOXSxxfmXhhwoqWBi2pjCzJxtZmHfUmgDFUqEHGFvm1SFRIinYU/o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(7416014)(376014)(921020)(4143699003)(11063799006)(10067099003)(56012099006)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cWZRUis0Mko3aE9QWTJlTlRkREVtRnVqZmp1VS81M0pFaWJuUUZFUjRRQVV2?=
 =?utf-8?B?NHRHZmxsc2lXMnpOWmxKUHFCVUVXSVRDb2QyaUlseldteVZxODVQanRsWGMw?=
 =?utf-8?B?bDFPTlJLdzNSRVFoeWNudnpuSnlTY3h2aTZobkdPUFVuNEpjeUR4d2NhcG1u?=
 =?utf-8?B?cTNKem5hMW5CK2lBM3dBK0dWZVQ1M0dOV1hYcjZCSk56TUhLZVhIL0tIQUVK?=
 =?utf-8?B?MGVweHdUenpjMXl2LzVNYVBZdktydW9QcVRYYS9sckxIVS9wQW5rZW5XbGNn?=
 =?utf-8?B?dGVaSkppQjdWWHJIeitDOCt5eVN6YVB3Ulp1a2FpcE1CTGwxZFNhdXJsYlRr?=
 =?utf-8?B?Y2t3K2NvNFRVWldoL29MY2tnSkErcDNrWWtsbzdXdExYaWtoKzJNTHgwUnpy?=
 =?utf-8?B?TzlZVXVFOTNKaCtNNVQyUWJrcDdKSWhMRCtqODBYM2tSalBlVUFXaS9JY3JK?=
 =?utf-8?B?cExMQUNFTmhRSk1DNEpLcG02US9qNEQ2UGdsWWttUk15WnFrODg5YVI1NjlJ?=
 =?utf-8?B?NHBLUmVaMnJLOUc3cG5XSUVHRkZLdlA4TE1XU3pQTi9LbzVobEpHYlFQbmVQ?=
 =?utf-8?B?TkFvUU9NVVhaMU1rSVBSWDluUUpCcVRDeVRlaTE5V0t5dXlwYUxzNUdmeURN?=
 =?utf-8?B?cDlUK1BjcS81TWJxYjhya3BZZjFiZzRtNEhrMEU5VFFhM095a3J5S0NxdjJN?=
 =?utf-8?B?aG1ZRkdIdTBhQ3ROUk9QY3ZOOXkwOVYyanhMRk9MZWhSL0xKbEVPTmVneFFq?=
 =?utf-8?B?Y1o3a3N0MXVzMnc3NG5GVks5SUpRYnUyWlZjNGs3eC9LdkxkN2ZidHZxdURM?=
 =?utf-8?B?d3FrcXA4NUJhNkFkbmFrcE53TTJMY0p2V082REJUdGFlaGZIMmZ6cnZDUGg5?=
 =?utf-8?B?bW5Eb2tPZzgxODVNak5HWDNWemtRb0NKYnBuYjJVUHNJUEhDZ01XblRMRjha?=
 =?utf-8?B?RDN1Ui9XQnA4cHJJYzZYYjQxMzFONmNOWkt1RTBXdUdMSGNDaHgxUTFtMldw?=
 =?utf-8?B?UzhHY2xLRkRibDA4NE9KVlBhamNxSTFHeGNTREpGeDY2RVVKeldMaWRvWnlt?=
 =?utf-8?B?aWNSR0oxQ2NQSmkzTm5RSzBOT1RSWjdyNHFpOUdQTkpRTVJlbW9vRDVsc21S?=
 =?utf-8?B?NnlwYk5TaHJtTlNzdWtka3F6MUE2czA5bGdLeWFNZXcyeWtuS2g4ZGRWcEhF?=
 =?utf-8?B?bWN1RGtjVEN1S3lmOGVBKzVtMVhRYmpiNkRTejdSU0VnbTI0eU1MQis0TzVv?=
 =?utf-8?B?UmZNUUhoZG9wck1wczVjQXd5eERxRnBGd0VyUVVWOWFmVVpqVHBwQzhjM1VD?=
 =?utf-8?B?RXBmMmlHSjdOTW41dGVvTWlHTWlxbVNBQmlYMk1NYkVNb05uT0xVUGJ5NlEw?=
 =?utf-8?B?S2ZjdjlYRTRkRE1EQVpXYTV0bG9WdHkvNmVuczRqSWhDb25GaEVqSVpiaUsx?=
 =?utf-8?B?YnF4ZjdPMHJRV1NxVWhKdld5MXh6Y3FYS0I5eXVMa2JiOXJtUHEvM2U2SDJ0?=
 =?utf-8?B?TDlucjJ6RHpUblUxTVBhSmgyZEtQRHlRVDN6SWZ2eFdWaG5kQTFJL3lBZTZa?=
 =?utf-8?B?RkVVMkpJQ2ptcGN4MU5pbVZQZjlqSjF3ZGhPTkROejlmRjhpbWdZR0x6QS80?=
 =?utf-8?B?djNXUmJGZmhscFhIT2IwMllCeTVzR0lhRUt3K1hZWGp4eFc0ZzYva1MrVEh1?=
 =?utf-8?B?UElEenFsNjRYaHNCNXllZWhHanJaMjVSQTlVN3FwSlp3TVRrWi9vdFlHcmJU?=
 =?utf-8?B?bGdYdDYxR3IxN3B2UGdLbFE2K3pIcjhsSjRwUHBsVTBjQmxpOTF6YTZwMFBn?=
 =?utf-8?B?SVpZb2F4Q1VWaGh2cnhhVXBQVWt4eWdyQnBuNkdFTEtRYmZBVUt6ckhYcTc1?=
 =?utf-8?B?Y01nd3VHeGQ1bW8wcGpqRi9PR3ZzR3l3UXdHazJjZ1lYMFRhSHU4U0NqNmJl?=
 =?utf-8?B?U2c0ckNwa1NlL3pmQjh5cC9OWTl3RTBadGVkVUhyLzdnb1V0ZXA4ZnJrQ2Vk?=
 =?utf-8?B?elczckd6S0V2N2lqaFhCejFPTTJPT1VxeThndG8ybDEvUnNVN0lmQXN0bHh4?=
 =?utf-8?B?UDJROUpxMEt1V05kT1lsR0NYU1NYUE9UdUd3NjRXOFYyOWZ6VXp1U3pZekdl?=
 =?utf-8?B?YXluU2QrbFNKOVFRbkNteFZNS2NUQnhpTjd0c3JZNDBrOWd2ZjVYV1hkNGR2?=
 =?utf-8?B?MC9Pb1pvb21QbmVCTUsvekJueWwyYmlVa2t1MWVyMjBIS3JETjVPeGw4bW1w?=
 =?utf-8?B?bkJyRDUyNVI1MUc1UFVmV1l3TGdVTUd6eWNISTVZUkRmand1STQrU3ZVdVpj?=
 =?utf-8?B?b2lrQURpQlhxVG9HY1BrMHBJSG1KRlFTNVdoZERsTU1EV0xEVzhQS2pNd25q?=
 =?utf-8?Q?LQYYFaKJYJ3YoWWo=3D?=
X-Exchange-RoutingPolicyChecked: cwEn1iMs40pIfoox6d7IwFdvxABQo5b/r/mj9Vp9IC1KDgo8gFSSGK6VbUuBbCsjV/Z1X2FsPy/mz4EmbwsmF79sa7CBIkvdFUT15Z9ZM+KTCYo1P/zRRIlY89yZP2Fowyt8HATHjaFDN4hpvqfiEkIOJYJ25QXQfWEdCSOFgQ077fP/QfljNBWKLtB/qYdiFsArT4NPW659wkXB9SDlzLAf/i7/d5JmRTyfXPJu7ocTxwdfWHYQfAalM82DWXJhkbajNcnDMOX1DgskTwCO8EN6q48phK8AgrVkprE+M2haomlsnVBs+UEiAFa5NxO31OaJ3ZIJXwlb8j5r9y8MMw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 84e43871-e825-41ee-e252-08df1a7e823d
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2026 20:57:56.4272
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nRhdUvrYJmBU+Sdb6bgYGumz/0kfCdd1XjTi+FOhCI0smxjEbhrblSAbNdcxE6VLOKynb18V1ODaqmK2tUvvj8vA9neN33SExcNf9VyY9tA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSVPR11MB9916
X-OriginatorOrg: intel.com

Hi Tony,

On 9/16/26 4:13 PM, Tony Luck wrote:
> Intel Application Energy Telemetry (AET) provides event counts in 64-bit
> registers in MMIO space. For accurate results these should be read with a
> single 64-bit load operation from the CPU.
> 
> In preparation for the removal of the separate CONFIG_X86_CPU_RESCTRL_INTEL_AET
> configuration option, move the X86_64 dependency to X86_CPU_RESCTRL.
> 
> This in line with Dave Hansen's proposal[1] for an addition to Linux

"This in line" -> "This is in line"?

> documentation that details the state of 32-bit x86 support.

Instead of requiring reader to follow link to learn what the state of support is
this could just briefly summarize it and reader can then choose to follow link
for the details. Does not need to be detailed itself, that is what the link is for,
just a small change would already help a lot, for example:

"details the state of 32-bit x86 support." -> "details reduced 32-bit x86 support."

> 
> Link: https://lore.kernel.org/all/c6ab0c24-8931-4f0d-9be6-23498ab4c38b@intel.com/ # [1]
> Signed-off-by: Tony Luck <tony.luck@intel.com>

See "Ordering of commit tags" in Documentation/process/maintainer-tip.rst

> ---

Reinette
