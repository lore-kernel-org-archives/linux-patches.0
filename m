Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=192.198.163.16
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1792451208;
	b=YMqHQ2XECwn5JKLoM0vsqkreO1/XgRFw8fIglnaX4ldr9VbjwXcwvWWWNsp5xbefDJsR
	 Ix5dPI3pJH2xeTBx6J7QrFeTxYAm7KgKsOGZ4+jOi9OG2ky+N0szZ8IpVZgqD5JdD4KB7
	 MCtuHgS5q+4Gsnqk2lcWqvVIWDk7JKel2bPqH3kqfzbCsFxJwLgcJmtPF0iFerF+YhRg0
	 lm2vmZgUoz7mjiTevaWCJY0kF6Yt13UQjj9sp2GCdj4HTKSOtr5ba4Cty4YS+PSWQllQA
	 4ZI2pAc5QRYToSRUC3Ohwrgdb0nsKC77qjqnnBTGzKvc3Yuvb8+na+a4/xEPSIwFvZg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792451208;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:Received:Received:Message-ID:Date:User-Agent:Subject:To:CC:
	 References:From:Content-Language:In-Reply-To:Content-Type:
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
	bh=+fPERF99B5ahc8wXTOrEa5IPW7HucxygJ72GCwZdZxo=;
	b=nBRk3X/MZHiTT6gCIAm+e4EM8H6urc1y67Q73V1a46WRrMucQZee3/Fb39PJzLMn96qc
	 qUyWiCCv19nzq5MX/Mbiqi0l44SAG/OHnzLikSu/N1oS6cljZRh68dRuJW6fKuma/DMbc
	 NaQMvsRUmHRNy12g1nADO1mG1WBpjdA9ENd51XR6+ppqTrz2V4hwWpIjIwtuAELjhbLZE
	 dcxI0FeGIwaEH77c81/xsvLmCQ5zZn1fyszINPM5n4qUY0dHZB6e4E4aHC3+XV9LphsXu
	 vtx0Aimfgj6aXVwVE2Qw0+LVZh21uNpMUGKoZ7hKvzc3Se5HOHaMH8ZZlq4X6EV7K+Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=cHS9MmO6;
	arc=fail smtp.remote-ip=192.198.163.16
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1D77606A32F
	for <patches@lists.linux.dev>; Mon, 19 Oct 2026 23:06:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E1D77606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=cHS9MmO6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792451208; x=1823987208;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=itPQ8YWjMx1bwCiamP5qrMCynS/MDCzQ7r8y5lFagFA=;
  b=cHS9MmO6oBIX/lJlj5kcHk5aILAQNYoIYxvCGtUSJQiMRmGKoJKYNnvA
   aQ6qcvImrgyWfBTSuxeLizybpLvPeF8x6ih74CbX/0ashO4LpY/gIx34a
   zd2rpK68kcN4yv2+bnHO5jwblkGZllJmLukb0XDph2MpumGBp86b/979K
   epQmDAD8Iycg5eplJH0//K/e49K8ylvaJNnPduqBewhsWjkELzCAKjfU+
   AehKCfy0cEZbZWoZ4AkrPFBC3cTNDcOCFQLRPl6jzbCa+ZhbzjQeZ9kLe
   TXOqrsU+fAxEVuvvRUWnDDNm2iAGyBox4CBYlIsjEpUlxjP9FXhk6Cs5P
   Q==;
X-CSE-ConnectionGUID: bCvqbMgfQRi5olGeqoMFJA==
X-CSE-MsgGUID: 77bUVVVtSziVCuvbWp+PuA==
X-IronPort-AV: E=McAfee;i="6800,10657,11940"; a="1162945"
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="1162945"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 16:06:46 -0700
X-CSE-ConnectionGUID: ZabPa0seTaGn64NTguLT4g==
X-CSE-MsgGUID: XiB9Pku/QtqywrmS3soaOg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="2764262"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 16:06:45 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 19 Oct 2026 16:06:44 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Mon, 19 Oct 2026 16:06:44 -0700
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.71) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 19 Oct 2026 16:06:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bB7ZDvRyPaRtwSYh4guwmfxDSp4XTFsvMLkuGT/oNSsSHycA+V08puKPyvngp1qGuHmTWKAIDCcUHy54FuVcX+ilzyE67AWxIRCe1njQTV2G+EcIHlRbx4ajlNJQ28LRR//ve3ogK/fy3Pnci5+BGGjMcKnq5f7k+lovVjr1eCJAutCtr+/ZBgXWZ+tm91qgFN36Zze7zpSOygNdrPpn3ojGjl0IR10qQhetBurk4c4sqMP8zra+YJyJG5Iwde83jE+wWTCk762OXfqy4BWBHvozikW1xaxRtG9ZzNFwhVFfIbuAs2zpcQG61kT+b2nz1oTPiy2DLtUVxI2DpD6KLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+fPERF99B5ahc8wXTOrEa5IPW7HucxygJ72GCwZdZxo=;
 b=hxdp60fKVF0oWZLMmSFPVWdz5GXRXwiYqZSvXacrr+CxqyWoTYHMzZe3lL58QSoMtqFQBqLxE3L39uVtCGKODxZFPggtfEE5vQ2iXAX+k6xZiZ8YkuFmKP0eq3GwNJwnWNigAN9NX0r5dRk1zB3U1xVrgb3TD1WbOU+IgiJDXAqgzLXmdP0fyO916zNpcpRX6RVRCO35/t26wcpSvUiAvtT9YYcAGdwdqI6He4lFQS1OU9edDe5Q8l1lQLbomM0r7xRXgSV4xALJ7pmBAbtgD4LC/fHlWOH1icI81V95PzknLZv1cWGOQsRKtgdGDYfJrwIIbWum01XLmRHFGGelZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by CY8PR11MB7797.namprd11.prod.outlook.com (2603:10b6:930:76::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Mon, 19 Oct
 2026 23:06:37 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%6]) with mapi id 15.21.0522.017; Mon, 19 Oct 2026
 23:06:37 +0000
Message-ID: <f054255d-f34a-4f8d-87e1-e7d296bef93f@intel.com>
Date: Mon, 19 Oct 2026 16:06:35 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/5] x86,fs/resctrl: Move MSR_IA32_L{2,3}_QOS_CFG scope
 property to x86 resource
To: Chen Yu <chen.yu@linux.dev>
CC: <tony.luck@intel.com>, <ben.horgan@arm.com>, <james.morse@arm.com>,
	<Dave.Martin@arm.com>, <babu.moger@amd.com>, <bp@alien8.de>,
	<tglx@linutronix.de>, <dave.hansen@linux.intel.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <fustini@kernel.org>, <fenghuay@nvidia.com>,
	<peternewman@google.com>, <yu.c.chen@intel.com>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <cover.1791406459.git.reinette.chatre@intel.com>
 <c873c62e78f335df6f7b99cb0cf0ccbcdd62b09e.1791406459.git.reinette.chatre@intel.com>
 <atUEpF4pd4YBncbL@three-body>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <atUEpF4pd4YBncbL@three-body>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0354.namprd03.prod.outlook.com
 (2603:10b6:303:dc::29) To SJ2PR11MB8370.namprd11.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|CY8PR11MB7797:EE_
X-MS-Office365-Filtering-Correlation-Id: f5dc90f0-71f3-4d78-3be3-08df2e35a0a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|23010399003|366016|7416014|1800799024|6133799003|18002099003|22082099003|11063799006|4143699003|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info: jTvAyNL0Ny2hQxtXFo6mbSBkE4+mjhAR42hnPa7GgpOqAGjT9c+Sn6LoesrTEZQWNgF1jWeN0aPo9tNdWKbBBXUVfR2zEvaS3C8picuiCgYoILqLr4qWa+WGDt7l1IOE7cPr4fWo36IVe+axs9Jr4YioQxMDsL89lBEAaPA8IhmbUwUkZ5gwUzy3oC/bpqjC5sYFG6cRMwAgXk/OlilqobsKACfEKZh1gqFbZ2tEPwfESE0RCGBwfgq8j9X1udevvZrkSbdVoK74dZUzIKB/Fccd/x20ttYHRiCsr3bg1IVkDvlTYyuASTVd6BanJ/k6IWercjA8vx0bnYal/IzGauFqYlVbTygDhIHpKTDKVG1EqudstaFof4OUslwWlDeaHQP2fWIRq7ula5FvTcRmown8DDZUzno5uzkAz4qMcCjigCrTwSbqSgFbIiQ4bM6RHln93BUJhxrLfkcz/JXzog41y9G97Iqp7ww7a+FPs6jUflii061Slug0ylu15oLvZKSDbl7SUZGSgzsDugp0PZmkmqRToSQs2lRL3K+aDKxgz6GlUUpw438xoJ35FZbUGHHsbUh++LXOtt8AAdec6I6XKaptL3QJPR5EpzZxw+jNSFSxj1C9EFWUWPgZWUW/Gj3qPPnDNtK4o5vDSMQcO7AfNEx47n+aX89vNHJ+Xq0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(7416014)(1800799024)(6133799003)(18002099003)(22082099003)(11063799006)(4143699003)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NTRpc25qQU1NeCs4QmhLUGVCNnVsUDBpVm1yTDVOcWxrNnc4akFhT1d2U0ZU?=
 =?utf-8?B?L24vWGtNRHRjakIyNk5KYWp6Umd3R1lhaVA0UFNzUVV4Ty8yaXdVa0hkRjFk?=
 =?utf-8?B?UXA0UWlNU2l6SmRsWFNCeTFqUldIcC9aVDZMK05RWXVjM1NORnJudGNsZzBU?=
 =?utf-8?B?RTNyUUFHdTFOOFRYb3Y3Uk54K0cwMm1OSEpwYnBoZ1FjM2tFWnZYbllWcGNQ?=
 =?utf-8?B?R0h0c0xzeUZLSFVuVHkzUlBSaW03SkdlOFRGYjYzbnQ4ZENUemJGWU5EaFFk?=
 =?utf-8?B?cE4yc1hXRTNwbEV3bDdkU1ZoaTZ4bmYzei9oL3hyTElPeDBEM2k4Z3p3VFcx?=
 =?utf-8?B?djJtMm9QUDhNdXl1cmxJL0JjMTFrY2ZmWDlVVi9TVkFXQTgzSHd3djN5Q3hy?=
 =?utf-8?B?VlQrMTlMUDVvM25BOU84eEkxOWdXNERDRnFZWmFLTDBVZlRTRldNSEVyU1JX?=
 =?utf-8?B?OG83MFJqMm9pbWlNVUJWQks4OHI3Ymp5SnhZUDVCWlM4elJqUTIyMndScWVF?=
 =?utf-8?B?MGcrOXE3Uktvb0xDTklzNzhpYlhFaGllMnhFOE5yYXk3d2ZwODdHMDA1Tzc0?=
 =?utf-8?B?T0lzbUYrUW9NbEJ1eTlvQmhSMjBnYnVwVHAzUGRFWk9vRDBYVjdoeHBKbFBR?=
 =?utf-8?B?SVp0T1JzTUJldzNseStOTTl0WTBxbnNPL0Rsckp1dm9xaWp3UDcxdkRCcXc5?=
 =?utf-8?B?TW9MZ0NTTXZqK2pWMCtnVW5HaGU0eWhycGNlNjBWTWRWcHYrZW0zVENzRHpL?=
 =?utf-8?B?aXFuaUovVitLYmtKZHdZcjNYU3Z2ZVFMYWR1ZFg4MTIzRUlETllUaDZkdGNL?=
 =?utf-8?B?RjZ6b3NNR0hNVHpYNXhqVlc5dzJiWXMydm1PdEtnSnM3Q1NqdElFZEJJaW9E?=
 =?utf-8?B?ZkdkV1pEM2Ric2p6Zzl3WTFGUVVpWEFtaVFvOFYvVlE0VTc3ZnZCMmhPN2pO?=
 =?utf-8?B?aXFpODRPMjlxVDlHNDgxMDRtNHRrN1J5Wkk4eDBDdjZuSFhQWFZYR2Mzd0sr?=
 =?utf-8?B?SUsvNDFoN25tYnNwbmg2YkFRNHhUSTRma3hKUkptUlVJMTZ0YmdubmFrQWV6?=
 =?utf-8?B?R09ramwvc2wreGk5LzE3YU9CbWg4SjFROTVTM2VYdHU5YTJ4NXdWTzdEZjJv?=
 =?utf-8?B?cFlGTEhuZkhsanZpSDlUWm9iNVE3SDBJcHl6QlhsckZPNHBQaWExTkVKeElG?=
 =?utf-8?B?YTExYWVVRFVzaXUvaEpydUV2dGh2NFJLdTJ5bmVqZjJzNWdnZ294MEFvejVQ?=
 =?utf-8?B?V1Jia2k3NkdNRUNrNGNOeG50V2lVZm9jZ1QwNUc3UmtXVVJvdEQvN29YSFJZ?=
 =?utf-8?B?YjNubTNPWEtzOWFZcEZRdVd1NG5NakV6YnM0dEREb1BRMEl4TzBIMlQ5L3lZ?=
 =?utf-8?B?WWQyS3lra2RvUGtNSEdnMFluT2NmOXh4V2prQVUzbzRRMEdma0lUMzA2Nlda?=
 =?utf-8?B?Qm51VDVHVEhKR3AyY1lPZmd6ZGV2cERZci9GT2g0UHQxU01WRmZmVENYWnVi?=
 =?utf-8?B?bkRNVzVCR2gzZjY3eUlwUkREUGEyUkFJcjV6VDkxZ2lOMHhYeHB2MkZKQ2U5?=
 =?utf-8?B?Y1RudE14elpDSGhnaloyaStNai9sOEx5NFZhZlptTFZLbHhKaTZFc25pTWJJ?=
 =?utf-8?B?Y3FlRGNsQnZwbklIOXczdjkwaVJCY3VvZ0dZTTl0NklLQWZTYmtpMFR2bFVy?=
 =?utf-8?B?cDlJNCtqaGN4bkRkZkJscFVVM2FvM2FxUmJjSlRTUnBGdzV5bTVKNnY4NjdG?=
 =?utf-8?B?dHRRRFlIa2tRVFp5ME5xRGt5amhoTFd1TTFzUGwzeGI4dzdjdTVMYmYwcjlZ?=
 =?utf-8?B?TFJUSk53N2lGMFFHbGF2OC9GbVFmS2VneHU1Y1E0cHNQeEphdUdrQXhuRFpr?=
 =?utf-8?B?bFNDbmJwMGtzdmZhRkhHNng5Ny8vQmtGVnJRaFVkZEpuYVJET01rQ1dBWG9t?=
 =?utf-8?B?Y3NVRlhiOWNCR3VwYXExU3JUbWcrVUNjVUh6ZHhWSlhwdHF2OTJJdHE0UkhT?=
 =?utf-8?B?SjNZSkMybjc3ek9iNCtSUnJINGNJZVlFY0JsQ3lseHcxTXFmdFhRWUdhRlI0?=
 =?utf-8?B?UlJBU0VsQ3lXM0h2SWcrV09hc09walgxajNLUHZ0bmRBYVg5MzBLbjFjK3BD?=
 =?utf-8?B?ajU5cUtWaUhUQlpkTHUzVEFGb3EvQmtyMW0vNGhhek5yQ2llVmtSaHJtK2Fj?=
 =?utf-8?B?ditpVUg3ZzNWbmx5YVlWWVkxL0NPd3RoSlZiOXZGbGN1ZzdYeC9YdEF5SDJC?=
 =?utf-8?B?d2tqcnpFZWZDZlhSMzgyQ2RCU2JUTGtxRCtpRFNnd3p0MXBCWFhFaEx0dW5h?=
 =?utf-8?B?UGwyRkF5dUJFcTg5bDN1S3BxdjlURjZYSGNqMExXTUxxaWczamw5bkFMRWgx?=
 =?utf-8?Q?UZWrIohzGhZiaR0Q=3D?=
X-Exchange-RoutingPolicyChecked: kvRzOAoqkqkqCJTU76SgwmrtagQaCNj+lhTN3RTtAibfqaw/ZOmdZUGynwPR6ADFlaKWnRrit8cjm4PKO5q8mh22q5APZP3+e2UHwWxVp88IaVtD6hixK2zz9eymfO74ExDX1cJLjA12xnV/P906dmM0Zm4Bd5XKZskvZWvbFhhOJvEOJSbWa+J17hQL8lQAg8UEE09zOsIr9TpZcxjYWBsYtNKq5+lxLHPVcQ+Gx3UREaSLEH/JS7SGf2O6w0jj8eBx51RnFIP9X31NSUzyLdT536UkdTRHXgYdbyCAQyBaw+wUrv4LkktzyxqhpV3X7N4ywki3XIaz2VXc+cMvuA==
X-MS-Exchange-CrossTenant-Network-Message-Id: f5dc90f0-71f3-4d78-3be3-08df2e35a0a5
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2026 23:06:37.4832
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AzkMDZfAMkEP50jb8Q6V6WzWwS0uAaBLCa7q8ez0+pqXT0bVeKpmXAx/6XQFZ45lDT0mXH/DTr3ZqXMAi1pG0AsBpszP96eD1qz4yDuXZMM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7797
X-OriginatorOrg: intel.com

Hi Chenyu,

On 10/18/26 10:40 AM, Chen Yu wrote:
> On Wed, Oct 07, 2026 at 02:06:45PM -0700, Reinette Chatre wrote:
>>
>> MSR_IA32_L{2,3}_QOS_CFG enable code and data prioritization on x86. On
>> Intel the registers have the scope of the associated cache while on AMD
>> they have CPU scope. The scope is recorded as a property of the cache
>> resource's control, of which each cache resource currently supports only
>> one.
>>
>> The scope of MSR_IA32_L{2,3}_QOS_CFG is only relevant to x86. Even so, the
>> property is found among the resctrl filesystem's cache properties while only
>> x86 code sets and reads it. Keeping the property with the cache control
>> properties would also duplicate it across all controls of a resource when
>> resources support multiple controls.
>>
>> Make the scope of MSR_IA32_L{2,3}_QOS_CFG a property of the x86 hardware
>> resource and name it for the registers it describes now that it no longer
>> needs to be generic.
>>
>> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> 
> [ ... ]
> 
>> @@ -140,6 +143,7 @@ struct rdt_hw_resource {
>>  	unsigned int		mon_scale;
>>  	unsigned int		mbm_width;
>>  	bool			cdp_enabled;
>> +	bool			qos_cfg_has_cpu_scope;
>>  	bool			mbm_cntr_assign_enabled;
>>  	bool			sdciae_enabled;
>>  };
> 
> It seems that some flags are in resource scope, while others are in the controller's scope,
> cache's flags are in the resource scope, MB's flags are in controller's scope, for example "linear".

The goal of this change is to move this information into the only (x86) architectural driver where it
is relevant.

These "flags" are different in a couple of ways:
a) qos_cfg_has_cpu_scope is specific to x86 architecture (thus located in struct rdt_hw_resource of
   x86 driver, not struct rdt_resource belonging to resctrl fs) - this information is not exposed
   to user space nor is it of use to resctrl filesystem. This is just information internal to
   architecture whether the x86 MSR has CPU or domain scope to accommodate this difference between
   AMD and Intel.
b) the MB controller flags like scalar and linear are associated with the controller,
   exposed to user space, and managed by resctrl filesystem.

To me this qos_cfg_has_cpu_scope flag is closer to the architectural support you are working on
that contains within x86 architecture driver the decision whether it should use ACPI or MSR than
it is to control flags.

> For now, there is only one controller under the L2/L3 cache resource, so it might
> not be duplicated if we keep qos_cfg_has_cpu_scope in the controller scope to keep consistence? Or do

I do not see how qos_cfg_has_cpu_scope is related to properties of controls exposed via resctrl fs.
resctrl filesystem may request CDP to be enabled/disabled on a control but how that enabling is done, whether
the architecture uses MMIO, CPU scope MSR, or domain scope MSR, that knowledge is private to the
architecture.

> you mean if in the future there are multiple controllers under this cache resource, all controllers'
> flags (e.g., qos_cfg_has_cpu_scope) would still share the same value, so it is OK to put the flag in
> the cache resource? If yes, the code looks good to me,

This patch is not about moving a cache control flag into the resource but instead about making
an architecture specific flag (unrelated to a control) invisible to resctrl filesystem. 
 
> Review-by: Chen Yu <yu.c.chen@intel.com>
Thanks, but I do not think we have the same view of this change. Please let me know if you
still feel this patch is ok after this discussion.

Reinette

