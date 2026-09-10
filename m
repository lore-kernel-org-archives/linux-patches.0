Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 107B33A1696
	for <patches@lists.linux.dev>; Thu, 10 Sep 2026 04:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789013446; cv=fail; b=b7Oqwz8n92Yob7YXKY6Kf0ihIH0D+3XLtl+RFBxeS+BoWzLfiClqwpsjLgf3nnNCP4+fOYvQ96/wp3Rh4iXG04gj6UVPNn60/W2Jxxkoc+GIykC3Wnj46PZOwX6u2fX+HHKY++UKqOA6QrN7Uh6iKhcoYnTyRXUyn7NXnrC5LE0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789013446; c=relaxed/simple;
	bh=Kn1yveJn4HKfW9VQQrWI9iP/juj2KqJhhhNlFidF0o8=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WqhL1H6SYp6V2WRGHRDwXcKuN7RSwxXR8bVgzFBvRmfYtIWgSHTOv+uWPctzhdDK+raNkqqAX0UHqak4o3THgOKJ4J4QlpQu/RtYerrvMAcnlUrn6bwe6nwn40viTHFBkeb0jNwNFywIBjDBqWcPMP38CudFTb8HXYIbFNzF31Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Sc4VzUM5; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Sc4VzUM5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789013445; x=1820549445;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Kn1yveJn4HKfW9VQQrWI9iP/juj2KqJhhhNlFidF0o8=;
  b=Sc4VzUM5pOo6DroEcnwQ2F5HgxjczWt7Ig/iAkwm5To/qHq15UQLdMZN
   QZ5Fk62FnQbGGkH7vCRcCLIacrsCnlbdptL+7cKJfvnXzSCg1QHgdo62h
   ap0Jro0FsCz7ZmhOe2DnjW9FXEs98tbTbKy7hp4C6FrM4ImpjFCDo/ur/
   Z/jJi4+S605TvCwF8CL33prnVx5iYhNeEiSU50HlFGdumX+ZpdYoD6+jz
   FSg9ku/LteU3yUm6uudSOF2DCPvevtEjRQaVa3CnkWCLT8VWjkmOgVsUU
   M99EII9EAkIYT+mNKlj1u1vGy/dAC2SMwr4D9RpPcSt64xyhkflIwBXe6
   A==;
X-CSE-ConnectionGUID: LfiBy9sMRx+NPxUqkLr3BQ==
X-CSE-MsgGUID: ADza9NMnQ2qLlc2C/EuTsw==
X-IronPort-AV: E=McAfee;i="6800,10657,11900"; a="89485675"
X-IronPort-AV: E=Sophos;i="6.25,271,1779174000"; 
   d="scan'208";a="89485675"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2026 21:10:45 -0700
X-CSE-ConnectionGUID: YwLnkV5bT72e77jQ+hrHcQ==
X-CSE-MsgGUID: MEZ15c4MSXuU6Hzmk6SbsQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,271,1779174000"; 
   d="scan'208";a="267224268"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2026 21:10:44 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 9 Sep 2026 21:10:43 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Wed, 9 Sep 2026 21:10:43 -0700
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.40) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 9 Sep 2026 21:10:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IhJYDxOp1rfhd41O3FPccEP5vV4y0V4aphJdffexWv8kMll76yl5qFztcm60dJf+rBG/sjkekh2kaulcgZnHeEy46WtKKA2vUH+raWu99046+NsdaSpeWscp83nd7v4q82J4WwaBs5Y3D3QujCxbLYAP2vr9Rvao2td9QslbtJfE3Uhg86U+QDq46sbzpZtxJlePlSVypRMdN0m7384t+q6tP3Z8Nb8C2QCqPl0u7fp0r4Hno9rTOy7n1Z0EUPYTJYOYQ8ORQlIkjYQb0oyFamClZghMojODo86NS1j5xIP6GNor710pJJIuZFz4bOcsDBTkMjeoluHw79qdGbFCsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xihXZCa+EqV3ZVCM9U8nB3BVxHP3MecXjbUa3BnnMfQ=;
 b=bPqPf64UqsFGnjeuF9qUaf8w/v3AlZ3wCSABr+jhznCrCExdP+r9vAj122Of0RwOBaAJWSIxzUfco5CekaiTiPGlRn9Io74MHfv4GJIlRzIGJu8SCXQUi/broH6YKgoUlZq2OOW7CR3FdBvD6XN+c2On4uThgRl0WnofaCYAa3kl5C0S7PhyXsHtiVB4ToXb21VcVizyhm3YhJwRk5ylYwpamciGgr+45HLmesqO7T71WVzOTr2I3LRFH56LnpvwjRw/2XHK1cRKL7zBbWelckNKJrmakhOO896rei6aYvJXO4PPdfWep2OWjXyY2c6aMNwuZlttFBcwvh0yVsPhzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by DSWPR11MB9583.namprd11.prod.outlook.com (2603:10b6:8:36e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.7; Thu, 10 Sep
 2026 04:10:36 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0406.005; Thu, 10 Sep 2026
 04:10:36 +0000
Message-ID: <8abdca6e-a3d1-4d43-9ede-a11e17860519@intel.com>
Date: Wed, 9 Sep 2026 21:10:34 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 23/23] x86/resctrl: Document telemetry mount timing
 caveat
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260831174421.13921-1-tony.luck@intel.com>
 <20260831174421.13921-24-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20260831174421.13921-24-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0043.namprd04.prod.outlook.com
 (2603:10b6:303:6a::18) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|DSWPR11MB9583:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e0bc553-fa46-48e8-1577-08df0ef17755
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|366016|376014|7416014|1800799024|4143699003|10067099003|3023799007|6133799003|22082099003|11063799006|56012099006|18002099003|921020;
X-Microsoft-Antispam-Message-Info: UD73czGE9Hy9Mra4CO6Dc/KN7yBvUcodpyUabH99NYUOjGOEprL9/XdWGkeK8GRIQH3tm+6lkmEmhc3IGBnFch56ORzE1BEIhvz1Ydp2O3gV08yokXk8ojZGgSo17lfX4TXd9weV/2W0z0w2LXtpyJDcAhvAkGbBgVWhVGDSdg6E/jm4UuAy+/52MtRwlUfr5v58O1Tyz4c6y2tZV8gyujKZ0bjpmhqvNdR7b37Gcq2+RscvIamrmzIUPUioCAX2KdeaeHVviuKeAwHMk6mR/7oDWTf5sb4x+dib4/Qs7QvrtpPqwhT5cb3NXG9bUizJGldiJwW6L9xIYxR8LJ+SiZ4cbZd5vHxbwGZj+RqgvfWu3lnfFgM5rhD55JqgxQiKlJ6Y7DtDECYm9/x1exqCm3EnCeQKxdK/urBH1Ou54bH/6VRMgPuVhmEHgSVhlYmGbhY66sAD9YyaSOE/SpRp1ntg+EfDbTMcgX8hgspZiQQceQa00ZRaGeO7P9K1MX40WKDt+A+u5300geEeqFu3yDChflaF+5mKql0UpOvUkcU6EB0bioSbKRq9hqSRgd9J1Hn0UjWCeKrFFpHRfjKtqPUvAy6XCY9tJy+tXpWUunNPuaIbab7NOpE7cGF5eUoOkioTLaSCLEyhMAjZCrBy1QQLVticPC1P+U62bh+aibqTy74b1fD2WN68y3TzQ+rjBQ88VaNlUiatUwAODqzh1w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(7416014)(1800799024)(4143699003)(10067099003)(3023799007)(6133799003)(22082099003)(11063799006)(56012099006)(18002099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RmVFS05pTWRlblZOVVJVZXhwVWFRSy9BSE1TTkxhaE1UeVo2OXlSV0NBOGtp?=
 =?utf-8?B?UFFMZEQyOWY2VEVxWVBmS3cyWU8rMHh4WFBTenY1RU4vNnlrVWxHcUtYVHd3?=
 =?utf-8?B?bXYzOEF5VFJpdmpzYnc4ZmdqdFpMeGRsd2dEVDk5dHhQOFRnWldUMlBpWS95?=
 =?utf-8?B?VjFDYkpxTDBuQkhPZGtPUFcxVG13cmpMWkd5L3ZOUHBFeXZkd2w2cXV4TkZT?=
 =?utf-8?B?V3Y2UjZONXhpZHR6bUJLUExOQUUxRk9LUitvc1pwL3BOaGRUaWZ0Zlo5cWIw?=
 =?utf-8?B?Ujl6ald5Ry9wbFJmS05hZmFXdWtZT09VdUFTVWp4TnRtV294Ym1aVXlLQnQ4?=
 =?utf-8?B?enZLV29wa1d1RFJ6KzBsZzR2TUkzeDFEcStsV09PKzRtaUJlWlhKemZUck5N?=
 =?utf-8?B?TDdOUGZqN2IxTmF6UExldnZiWmpOZGRvclNlT1AwN2ZJM3MzMEFCWUdyM2g0?=
 =?utf-8?B?WGw4L2R6Skt2OGNNcUgzSjlVTVcvUTdXb0tjQi9ObEpRckl1TUcwNmt0Skx4?=
 =?utf-8?B?VExmeTUrczlWYk9FWCtyUWZNakFSV2Zldm9JaDRhMzN0cDBrcG1tRTdyeStO?=
 =?utf-8?B?dFU4MG1RU0FCWDJqS2N4ai91SzRybXp6bU90RXNxVnN1bmJwVHpKdk8xTW5O?=
 =?utf-8?B?NUlnUS9VY3FPd3k1Y3VXMmVlU1pGdXh6Z0pGR05VYTBZQnJSbDlPOWJ6U0Uy?=
 =?utf-8?B?YjNVNlpvZCtqUHBiQ3MyZzFlVFluVU5zcVY5WVpiOElmQXpWd0ZrVVRoSHJO?=
 =?utf-8?B?eG1XVVJ4Z1RySFJqTFY5Sm51QXJZNWFlNSsyM1NRRE1COWpVL3ZqSGZPeE9w?=
 =?utf-8?B?K2Z0ckI2NU5yVW9FalhmS1hBVk5NQ3JYallmRlc1aEp0MVVnQi9vbGRROWkw?=
 =?utf-8?B?a0lkS1lpRHVSQy9WaVQvV3Y3VzJ1MHEyLzVub0ZiM0k3bnhuNmF5UXZVY0VH?=
 =?utf-8?B?dGtqRHJJM2VxRk1OTnE1MnpnMjkyNXVEbDJqODEzYTJIaldDdXdpMVJRRjQ2?=
 =?utf-8?B?SEhSZHQwT2t2SnB1UTNiMUtRdHdqUWJYQ1ZTRUxHblZuRHBKZjJleEIwUDlw?=
 =?utf-8?B?cHc1TXB2STE1NVZpalRJNmg3NnRRNWZEOWZRNVA1U1hnNWZMMEt1WnZjazZr?=
 =?utf-8?B?MWhLUWxkdlVXN0VSS1k0bk5FdS8yV3RNR0VJcXk0L3M4QjFQY2NTK1RCbHVM?=
 =?utf-8?B?NjBaVWltR3VJR0NncDZjWEZ2OG9YQmVPWmxLUXZXRVRxVGlSM1RSU0ZQL0Nt?=
 =?utf-8?B?bWxtQ3lCRkg5WXpuUTVYQnRCSFg0eElqcU8zTVRKRWJhTzQ5WmhxSkxtaHh4?=
 =?utf-8?B?a3JscDQxcU5UYWxEWU02c0h2SnVYbjBvUFY1Sm5QYWlUeVI0N0sxSzVDS3FD?=
 =?utf-8?B?eGI3YnZIelZiUUR3aktkdzNwMzZGcHE1T3h1NFpwOEpCd0Z4blV4eE9QSDE2?=
 =?utf-8?B?QTllaEp4dnNRRnA1cENJTlJSdkhUVUgxcko0VjdkallzUXlFMndVSUl2eFZm?=
 =?utf-8?B?bjF6eW1lRFdmVXJxbkRVcWp0TXg2UE12NC9VaytOLzM4N2hIdVV0Qm04d2Jy?=
 =?utf-8?B?WEtoNG5NK3U5ZWRpa3FNUnFJZjE2WS9BdXJQakFHUWpiaXQ3VkFmT05OSU9a?=
 =?utf-8?B?bVZNSldyVklYUUZXQnZCS3k5MFZJVTRxYXFCRE5xT3J4VWtlSm5kVEdjU2t4?=
 =?utf-8?B?RHBuREVJbHg2cndQbmVENTVISXRnM0R1dVVnb3RPaUJZSUN5bnpBeUtVRFdj?=
 =?utf-8?B?dlhJSHR2N3VtU3NkL1hzTW51SnNjVXptNFpCUWVveFFacGpPZnpqV1ZmSTdm?=
 =?utf-8?B?ZVE4b2JCR3pveC9XWTV5RGhnTTBocGlLbFpMNTFMUlRwUVJCRmhNeHprMFg3?=
 =?utf-8?B?VzY3RVMxVDN0czVTT3hSaiszNFQ1Q2hwdy9MSTBwdnBCRUYxWHlWOGloNWhi?=
 =?utf-8?B?Z1N5dHY1RUY4ZG9SRTd0Vll0TThONWZJNUFPOU9oZFd2b0F3cEFoSHIxVmNK?=
 =?utf-8?B?VXZ4Mjgvem5JRnBoNTZjemhSTW1sb01RNzd3K20yWTFtUWJtQnpVakwyWTRy?=
 =?utf-8?B?a3A0eVpoOHUvZGVJYmRmZG0xZWJqMm5GU3BxUVhzNzVabHo3bEFrZXBnWWFz?=
 =?utf-8?B?R245VzFoZ09uK0hhNnVZVWNaNERBUjFBKzlRalRjV3FOOGtzZU5JcGNSbjFt?=
 =?utf-8?B?WC9kSm5reFcwc2ZyMGtLZzVLaEJZVCtWVU9GaE82aTh3SFlReTFMZlVJNlY3?=
 =?utf-8?B?MndHamhpejJqWWlPL2xaa01DSVhLUlFEL0trSzFMK3IrVHZTSmg3U0x4ei96?=
 =?utf-8?B?QUpnYjJZanp1YkZSem5VeThQR3dpdkY1MEI3T3l1cGg2aXZuUDFrVHBuVWRs?=
 =?utf-8?Q?NOz4WUf45x3wVq8k=3D?=
X-Exchange-RoutingPolicyChecked: Q2Ms6kRoZQL4d2Kv99W34zpzFvf8TsPuu0VAbXUhKx4hSBIvtG8TWx97cUAw/1bdZHof7C0x5WjvazTfuQWKTzoMngqL3o2W9MLWYvBGlab7MQBTkekw9ULaLAzfyk1QXtiX+q4guJb5kjsd19uM9hzNbQY1slEAm8WhxO4JVlCRssN6+Vh0BWo45xZz0yBF4M2JQQk3UYvrf3u34zVzOyXoDMTMdLL9OrQ5jTJa1GU3fIagIh/5QRY6TAHh3MY173bi57zgAb3rXEH1A9gQyqQ0amG0KcYu5UO2C+uhfOLHKcGk3eLrlLuCaJaUirwhlLNPuaO42JBe+y3+6PBshg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e0bc553-fa46-48e8-1577-08df0ef17755
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 04:10:36.3039
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fCcHdtQ4OqNH4gSspP5XkoEyMgHQk11/6RWoOi1Ph1PYOlCpguld4/e50clo4nbPpLFgVbsRMsTRJb51jhaj9q7R3gA99mt/r3Mth263QxI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSWPR11MB9583
X-OriginatorOrg: intel.com

Hi Tony,

On 8/31/26 10:44 AM, Tony Luck wrote:
> @@ -1898,6 +1902,60 @@ m. Unmount the resctrl filesystem.
>  
>    # umount /sys/fs/resctrl/
>  
> +Mounting resctrl with telemetry
> +===============================
> +
> +Telemetry features (e.g. the ``mon_PERF_PKG_YY`` events) are enumerated
> +asynchronously by the PMT driver. If resctrl is mounted before that
> +enumeration completes - for example, when mounted automatically from
> +``/etc/fstab`` early in boot - the telemetry features will not be available
> +at mount time and will therefore not be enabled in the mounted instance.
> +
> +To avoid this race, defer the mount until after the ``pmt_telemetry`` module
> +has loaded. One way to do this is with a udev rule that triggers a systemd
> +service when the module appears. A tmpfs mount onto ``/sys/fs/resctrl`` is
> +needed to prevent daemon tasks from obtaining references to the resctrl
> +file system in the other namespaces that systemd uses during startup.
> +

Getting the example right seems to be a challenge. I will not be able to support
anybody responding with issues when trying out these instructions and
I would prefer to leave such details to the experts. Could the text starting
with "One way to do this ..." be removed instead and just rely on the high level
guidance that resctrl should be mounted after pmt_telemetry module is loaded? 

Reinette

