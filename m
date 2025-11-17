Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3E7A305063
	for <patches@lists.linux.dev>; Mon, 17 Nov 2025 17:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763400711; cv=fail; b=sqUSz3abCPIDD0RndXH1EoiVyV0YRrIFUHUKqsElDcP4KpLKS3XOD+B6dRpDBjDwnfowDQ0yfZwMn+/3O03QVAZLhBRdcJzrXzSr39sHVDLilZnNixel6nkmkspmIB6lLcnjRcY9iGGqh15NJly1tveXDWJmU0fVSW9XIjhxoi8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763400711; c=relaxed/simple;
	bh=pGD/TW5XH4G/GtgXvE7RK0iOwlNESQAF6IUOB/klU2c=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=I9L7OZ1uHMPmX+xIB4WXE1BU6N2QNgrqz70g3aUIGIm4yQ2wMM8v/M3nUeufu7+pGMpdMoY6faHGbbiUQz8FXqbSXqCWiMgWPFvxDUAIp+K9nb2QAw8mDbSR0sdKNZdthl9zHPXb1y+FWs3jbPXKqvg3C/quptynXd98nzAXZ0g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QM4a+N8o; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QM4a+N8o"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763400710; x=1794936710;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=pGD/TW5XH4G/GtgXvE7RK0iOwlNESQAF6IUOB/klU2c=;
  b=QM4a+N8o2wcpuBXmspF/iySgymLK6AdZxvO7u7+7T6pSXDgRDdufi/M9
   8AGjPVrSWodqUYjRD3rjKSFYZrr1JG/ortl/F4DD7ySOuFZrEToDFehli
   4gDuabe3hJnwxWnLxygfE4SLEiwsfL+5Q9/z+x5BiTJluwEHjFDVxiU4w
   EJ2P2YQShvR2dwNM5UWbmcpouyYtlAmOt8QVaKGs1uvOUZP2wRGdypf3B
   XwJwQoywsEsd9kIlBvNJQ4raQh6u1vFfXeNT6E2TA9/AVX6rbYes4B27j
   LjG9W89OYKuuriiiVV8UkeE6nBZN+zNYW4LAKcvZipD3BD8CD0VdOZun3
   g==;
X-CSE-ConnectionGUID: mBvFylxCQxWuXwBqIpdCGg==
X-CSE-MsgGUID: 4R//dCNsS3iKZjuV8pttAw==
X-IronPort-AV: E=McAfee;i="6800,10657,11616"; a="64409682"
X-IronPort-AV: E=Sophos;i="6.19,312,1754982000"; 
   d="scan'208";a="64409682"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 09:31:49 -0800
X-CSE-ConnectionGUID: rwaa8xVTTxWowBVt4qeRwg==
X-CSE-MsgGUID: Vr7b/8sjSGWhx1chhYGHIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,312,1754982000"; 
   d="scan'208";a="190747074"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 09:31:49 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 17 Nov 2025 09:31:48 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 17 Nov 2025 09:31:48 -0800
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.5) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 17 Nov 2025 09:31:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kw39fmMFjUeZGzIlso3VMw7YP8yQJARu5U7++CEImN5VQrbBJwxqndFQ94lue85DvlwqLijC9ZqHY3YrGtWGnYbciVBUjGFzwgSNieAE7EoalIUsyDwiyOwJITyBShVdjZK/XXMXUIPba1Fvh9q+SWAgjUJmcBwFXW1WoyiOeWAuKIZxGiGY/XyshNGrejRwQT7nHLjQvKBsLLjWZFHEn483Fb89JoMxOoKA1Ryl3GyBTlU67DcigvhCx//U8EQ2Ky6AHOmokfrBlsdmN/wPITmCKFmnXcSySC+TUV/tMPOeTEq0JR5ItlGl/l/t0VS52suLmUNiOcsO7DLSFXcUuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wT89XTPXUeawRtMLEZgt0Gx3BkoWihjrBZNBEf8FQ8M=;
 b=Gkcrhpou9U0Y9VB1Swoc7KQHFxak8Tb1k9V+AQLp6oJ3UYVN9Lf8fsRwt+1ritYkkp7YLykPOmqWanD2CpFzdNajhV/bUoy5WB2oy7tTTr/aAHyeD6bCTuRI3CuRF9A1T8aoSs8RxAybkkDWR03q9RCgR3k+UxKk9+hVGm2NyH9mD67EkmWL1E/7RctvJ9Ndy+xisHeyL6WG60gIvgbOm/KXDBDV9CyCkuSSmDs4c9u9/L/FEm101xliAg9OLWIwD5GU/uwM6KQxsgz47KN4/8U+lWsYE40HVo6D6wpXaE5SgQ2aoVW1R5F1oBT70K2sbstGFb7SWagEaNMMQlSjPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA0PR11MB7789.namprd11.prod.outlook.com (2603:10b6:208:400::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.22; Mon, 17 Nov
 2025 17:31:43 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9320.021; Mon, 17 Nov 2025
 17:31:43 +0000
Message-ID: <cdbc23f6-cf4b-4e83-a037-0aaf7c076e8c@intel.com>
Date: Mon, 17 Nov 2025 09:31:41 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 25/32] x86/resctrl: Handle number of RMIDs supported
 by RDT_RESOURCE_PERF_PKG
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251029162118.40604-1-tony.luck@intel.com>
 <20251029162118.40604-26-tony.luck@intel.com>
 <50149b02-d6ea-4fb2-806a-f16e80d3d52b@intel.com>
 <aRelbFgQ4-11Xwg2@agluck-desk3>
 <8ca676bf-7b50-4898-baf1-92241712f871@intel.com>
 <aRtPL9IQXWiKfhEk@agluck-desk3>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <aRtPL9IQXWiKfhEk@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0251.namprd03.prod.outlook.com
 (2603:10b6:303:b4::16) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA0PR11MB7789:EE_
X-MS-Office365-Filtering-Correlation-Id: f4b5897c-a58d-40e4-a039-08de25ff2ce9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?UkRJREpid3IzZHlzaXBFanBta0lkSzNEenk2V3JKaTJVV3ZhSE1yWFQ2cGRw?=
 =?utf-8?B?VGhjeituSCs1c0hIMU9lRzlBcURXYStUK2V5am80eFI1bGkzd2xmNUNzMHdS?=
 =?utf-8?B?em82cjFGK2IyblphVThROTVlZzlBU0VHRHVhc3hxT1h2Yjd5RE1tRDVqNk9k?=
 =?utf-8?B?dytIcEhEOGdZZysrNlZ6OE1Sd2VrYTdVd2FNQWJnM1lqckZaSDY3eHBRMXdZ?=
 =?utf-8?B?OElDRmdCV2I0MjQzVUg2UVJ5Ky9ydzhDdWppeGlqL200MzZYSC9UYnI1TGNo?=
 =?utf-8?B?QW50bmJieWF5QUtFS3R1TTV0M2pYVzJYNzQ0YVhyQUJ2amdEOFhRMGVTNTN2?=
 =?utf-8?B?U29qOUo1RFAvdE95YmIvM0YxcDRFZEVGTnFjZ1U4M09Pc21ZUWlGWGlrLzJz?=
 =?utf-8?B?TmdjcS9DamdHM2R4N2NZNWVQWHpNTkFueG0rL2dHSDdITUdIY0R2WnFnenZS?=
 =?utf-8?B?ZkxFeE9udkM5bkkrWmc5S2xXR0RFc3N4ZEFoK01Jajc5VEFpL0lwYTBack5B?=
 =?utf-8?B?SWZ6endVc3hoTWRwSXNSRXFQL2ZoRGlpd3dQc2N3ZzlBbFZOTXdpOWdZTXdi?=
 =?utf-8?B?dldhd0ZhUFRHaHNHcDJWb0tQWUhEUW1WdFoycC93L09pc3NWM3NtQVBHRE54?=
 =?utf-8?B?cWw3YlRkLy9vQ3N0Wlo1dm5CZmRkY2VlVS9BejBUNktDZHJmejFYMU1RTVpZ?=
 =?utf-8?B?RmZrZ2M3TUVJZ2hKWFdWUVF1cG9vZWx1ZFdnWEVGQVZha0d3Ky82MUtNNENx?=
 =?utf-8?B?eHZkWWxjLzNWZ2VLNGFVNU8xbVB4WlY0MFBuVVRDUUsxb0RqTjNCNlR1d0Fn?=
 =?utf-8?B?WWNicmNWRUhLRmlyVWl5WXlDVXpCVkVkc2xuUXRZWkpHSm1UMUdmcitqcjFv?=
 =?utf-8?B?cFZBNDdDbmZlWGZDYzQ1UjlwZ25SL1M4ZEVad096dzUwN1p2SVNsZldzVFpV?=
 =?utf-8?B?K1lVUDJ3ZWNlcjVjQysvNzl3L3JvOHBGeGNJQ25ZSE56Q002WUtDQkMzYlk4?=
 =?utf-8?B?U1ZkUUNjeUNRZFEzeHpxS0hCaTdRbXJ0SHltWGZJcXpCUGFhV2VVK3JrRUR6?=
 =?utf-8?B?T1htZUFrZlc3VzRVSndYb2o3dEh6YVJncEFXdks1S3hyVWVPNUt4YmNsUnAv?=
 =?utf-8?B?RVVtaEFSSmJiTzVFTHROSnk0LzJzbGd5am5mR0k3a2FkVFRERjkxaWR4aE90?=
 =?utf-8?B?dzJ3bm16b1BKQ216TEpQaldIK1Rob2pGN2NCWWRqZWFXQU9MSFJpSysyZG1T?=
 =?utf-8?B?NVpFUDhNZEJaempldXdTRjd0eHRLbmhOZitjSWVneTR0YnZmOG5IWlNidnRE?=
 =?utf-8?B?bFRlS2xSaW5TNGYzV3RHSkNOU2dDcjFzYUYrVnpCdXV2OVNWZXBXWVhJNEVh?=
 =?utf-8?B?MEVYaWJYYVRNQVhSSzVkUUt4U0MxRVRuV1VjK3dnUEVqdU5xL0Vqb3U2UllJ?=
 =?utf-8?B?ZzZ5Z3MyRzhSV3dYVkc4SldGcUJSOEFnOHdYd1pMcFQraGpVRm1lcStIa1B1?=
 =?utf-8?B?MjF1cGhJWVVTOGxGWDdkNmh5b0JtbHAxNW5RcGdxWXNCYjlIZ2lEZ1A5cnVW?=
 =?utf-8?B?THUxajFHNzJNNGFOZWlrQ2NqbmlWanRMRGhmbmZ4RmgwUWtnMTV0Q0xDeE1m?=
 =?utf-8?B?bHhWYmV2Nnp1U0NDek9WYWdoNHRDMXZEOGlHT1NEREJ5QUF4ZS83MU5abTdL?=
 =?utf-8?B?d2FlM3QyMVp1c0FRa2xVWkNOWkRpQzVjcFRJR3RDOEY4M2c2ZnU5Zm5GakFU?=
 =?utf-8?B?NXVhOUtWNm4rRFp3cVdUNXltbFFsUzRQYkZPRUJucnlmR0Z6NnA0MjVqSDhu?=
 =?utf-8?B?ekptWExFbWNDa1ZmVzlmQ25mWlV1RDJ5VFhxQlp3elZmcDJ3Q1ZIa2pLakYv?=
 =?utf-8?B?eU54TU5CWUZydGNldTQ1VjlrdWpqejJVZ0xqam93S0JOaW1ISHpsSmpZZHky?=
 =?utf-8?Q?ehM/NYUqPTSSkvbt1iPO6ZO+DEHcCfae?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cGNUcDM0My95Vk45b0xHdHhEM1VONkxyenJXMTBtQ29MU2ZQU01rMXo4UlBK?=
 =?utf-8?B?RWxBNXRuZ1lSaG5GVGFzN3dFd0ZNMTZuaDFmYXZoT3RrdlA5My9aSXpreSt2?=
 =?utf-8?B?Z2FGSWEvc2ZSNXRZRWh3V005ZElzN0ZNeXk5SWRSYnVzSlduZjhOM25aamdi?=
 =?utf-8?B?WnVmTjEvS3RLdEd4K2Y2Nm5LUngrODUycHF3VDlJWjV5SmphMkxXdmpNU0Qy?=
 =?utf-8?B?cUhIRmt3cnZvUjhLeEVuNk1hRm01UUF4c3hVOHo3Y0hZTXhQOUlRTlM4WlZa?=
 =?utf-8?B?dkd4WHVGbnlrejZqckNYOSsrR2NZKy9nM0lmOW00YXdPU2Zrc01JQ3NyQ1hZ?=
 =?utf-8?B?MnBtbU5KamJ1Z1BXeThwUW16N241SzY3UjZXRFE5a1J6ZzlURldWdmh1TDBU?=
 =?utf-8?B?d0F2QlViQW9CVTJGdzFrYzg1dWp0UGE3RStSSjJSTWFlZTFwUWRSQ01ldjYw?=
 =?utf-8?B?TGZYb3MzbFZrSFVKd3c0WERESmVKUW4rK0hod05yYjZoRXBtcjFiSnVnWGxZ?=
 =?utf-8?B?ZHNSUmMyYkRRYXFGOWNWTzJmall1ZkVmT2ZsNEJmMmtUbTRaS29hRnZQV1Ni?=
 =?utf-8?B?a1VvMU1POEE3YmhPTGhaMDRPQ29LR0NZSUFyOUd2U0svT2RlNmNUdWhlUnp4?=
 =?utf-8?B?eGNoa0hTVGRBTS96bkoxWVBEdFlKRkRleEZWKytwMmZuRTFtVW5UbmZjT1ZJ?=
 =?utf-8?B?TnJDZmpuL2FiaE5tQkJXSDdwbGozeXlFWkpjNGJZU29vNWJMbkRZeGM0K0gw?=
 =?utf-8?B?Vy9SQ3RRS1dWTHlZdkFVNTR5ODJ1TUpJRnFFcG5ncTFJdWU3KzZxdWNlU1JK?=
 =?utf-8?B?U0ljYnZyYXE4UDhGVGhDUG9MeGR1aWFmOUlaVGNBVFFCaXo5Mkx6ZmtONTIr?=
 =?utf-8?B?Q0hqSVJ0WGk0aW16VEZnTW5XVWJ2b1d6TXNXbXNKL0x2aURBVjdnSGJDckt6?=
 =?utf-8?B?K2VLMkluK1gzZTYzMmVwWEt0V3NXeUVHZHNWVGhRT3BLS01tTnFPak1YSUdL?=
 =?utf-8?B?RGgya0tPR0ZpVlZwbE1ZZE5nMVJjbEpWZWF5UHJWeDBselFJa3YxcTh5c21k?=
 =?utf-8?B?K2x5cFpMRjZsMFlhb0JxMHlGYUJvblpDV0Mzd1lRNzBZZTN4UG15QStRcHc0?=
 =?utf-8?B?aWxuUlFZOTUrazBwSnNzODNqZ2hvT1UwL0xxNHNBVW9CSnhQOTJBTzEwNEVV?=
 =?utf-8?B?ZlZHSUhZSEUxcTFSYmtZR0l1ME4yYXNVSDByS0Jra3RoTkZlM1BFaWdVK2gx?=
 =?utf-8?B?QktObjdod25CL1ZyTEVLY2RJaW9zRUllUjFONDBLVnlsanFhN3ZCUWRLTVNz?=
 =?utf-8?B?VEhCWFdKa3M2RmVTTTB4TnFMNlZtMEgwcDA5Z1QvMFVJYmdDTERFRUpnYnZx?=
 =?utf-8?B?ZWMxb1hGOENvbVVZSGd2Nk56RHVZTTRJWDhBK1d6YUpzNWk2aU5SQm1KZSth?=
 =?utf-8?B?dTBlYW5yTjkvcHFJa0pMQmNCcGRQblg0UUQ3LzM1WVREUlkrWk05d0JJVzNO?=
 =?utf-8?B?KzArV0V3ZGtuZVZoQWFpeXVjYWR5OWQwMkd0VDZocmF0M0VWZmVFaks5VEJ3?=
 =?utf-8?B?aTl0Y2hFSFAzdENSRkhCckJVaEl1L01xTXVmMncydVdXMGJmZEV4Wit0VDl2?=
 =?utf-8?B?TmJFWHIyMzRnWVU2VzhUSmRhRnNaemZCN1ZWYWM1d3ViSDVuRkhLOXFRK1Ux?=
 =?utf-8?B?dW9HMzlsa21XRXJtekJVaXRsZkIwRnpWbGZUTkJ3OUcraG9XZDF2MW10Z1lF?=
 =?utf-8?B?UFp4WExsZW1WRFY1WVRlakV3eFJXLzd4RDBuQjF3cmp2OW9HY09aRUpMV2xL?=
 =?utf-8?B?MFB0ZGVESENWamg4WElUYmFWTDd5QitPQWdkKzB4bDRJd2hHNUhSREllU3I3?=
 =?utf-8?B?M3JkS3lObE9HemZSRVYzVkxNc2lCS1l6Q1dqVlBQRlhUdjVMMHgrMGp0Rmhk?=
 =?utf-8?B?YXVHVkVFUnlCbndIaU84MERVems0RHAxcmd1dTlJNzNvdms4SUZQM2hxN3k1?=
 =?utf-8?B?d2JDNzJsSkd4TDkyRHJZZGlGNFZlaXB1WWRCWnZsSjZaOENEL3BhSDR0d3pw?=
 =?utf-8?B?T29GdlBKSmNpS0F0cFpwVWZBVTBTUXd5RWdjR0VDVElwc3U3cXNqNjFHS0Vv?=
 =?utf-8?B?a1pYUjBsTklBRFhnSGU0bENQQldBRm1nZWFuU0xaL0NpY0ZZSVFWWW1sWnlr?=
 =?utf-8?B?RkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f4b5897c-a58d-40e4-a039-08de25ff2ce9
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2025 17:31:43.5236
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oFCuRJeksdhb7+fMNL/ITLn3X0a66PdKz7EPHtrcinhXIkSs3XzYQRXW6Mc3wm676YvfrVo5KwNIQh8wY0zI+zVtZd0y/HGZYOtuLo4aZtE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7789
X-OriginatorOrg: intel.com

Hi Tony,

On 11/17/25 8:37 AM, Luck, Tony wrote:
> On Fri, Nov 14, 2025 at 03:26:42PM -0800, Reinette Chatre wrote:
>> Hi Tony,
>>
>> On 11/14/25 1:55 PM, Luck, Tony wrote:
>>>
>>> resctrl: Feature energy guid=0x26696143 not enabled due to insufficient RMIDs
>>>
>>>
>>> static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
>>> {
>>> 	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
>>> 	bool warn_disable = false;
>>>
>>> 	if (!group_has_usable_regions(e, p))
>>> 		return false;
>>>
>>> 	/* Disable feature if insufficient RMIDs */
>>> 	if (!all_regions_have_sufficient_rmid(e, p)) {
>>> 		warn_disable = true;
>>> 		rdt_set_feature_disabled(e->name);
>>> 	}
>>>
>>> 	/* User can override above disable from kernel command line */
>>> 	if (!rdt_is_feature_enabled(e->name)) {
>>> 		if (warn_disable)
>>> 			pr_info("Feature %s guid=0x%x not enabled due to insufficient RMIDs\n",
>>> 				e->name, e->guid);
>>> 		return false;
>>> 	}
>>> 	...
>>> }
>>
>> Thank you for considering. This looks good to me.
>>
>> I now realize that if a system supports, for example, two energy guid and only one has insufficient
>> RMID then one or both may be disabled by default depending on which resctrl attempts to enable
>> first. This is arbitrary based on where the event group appears in the array.
> 
> intel_pmt_get_regions_by_feature() does return arrays of telemetry_region
> with different guids today, but not currently for the "RMID" features.
> So this could be a problem in the future.
> 
> I think I need to drop the "rdt=perf,!energy" command line control as
> being too coarse. Instead add a new boot argument. E.g.
> 
> 	rdtguid=0x26696143,!0x26557651
> 
> to give the user control per-guid instead of per-pmt_feature_id. Users
> can discover which guids are supported on a system by looking in
> /sys/bus/auxiliary/devices/intel_vsec.discovery.*/intel_pmt/features*/per_rmid*
> where there are "guids" and "num_rmids" files.

Should disable/enable be per RMID telemetry feature? I do not see anything preventing a system from
using the same guid for different RMID telemetry features.

I think it will be useful to look at how other kernel parameters distinguish different
categories of parameters so that resctrl can be consistent here. Looks like an underscore is
most useful and also flexible since it allows both a dash and underscore to be used.

Another alternative that is common in kernel parameters is to use ":". For example, 
	rdt=energy:0x26696143

With something like above user can, for example, use just "energy" to disable all RMID energy
telemetry or be specific to which guid should be disabled. This seems to fit well with existing
rdt parameters and be quite flexible.

> 
>> How a system with two guid of the same feature type would work is not clear to me though. Looks
>> like they cannot share events at all since an event is uniquely associated with a struct pmt_event
>> that can belong to only one event group. If they may share events then enable_events()->resctrl_enable_mon_event()
>> will complain loudly but still proceed and allow the event group to be enabled.
> 
> I can't see a good reason why the same event would be enabled under
> different guids present on the same system. We can revisit my assumption
> if the "Duplicate enable for event" message shows up.

This would be difficult to handle at that time, no? From what I can tell this would enable
an unusable event group to actually be enabled resulting in untested and invalid flows.
I think it will be safer to not enable an event group in this scenario and seems to math your
expectation that this would be unexpected. The "Duplicate enable for event" message will still
appear and we can still revisit those assumptions when they do, but the systems encountering
them will not be running with enabled event groups that are not actually fully enabled.

> 
>> I think the resctrl_enable_mon_event() warnings were added to support enabling of new features
>> so that the WARNs can catch issues during development ... now it may encounter issues when a
>> kernel with this implementation is run on a system that supports a single feature with
>> multiple guid. Do you have more insight in how the "single feature with multiple guid" may look to
>> better prepare resctrl to handle them?
>>
>> Should "enable_events" be split so that a feature can be disabled for all its event groups if
>> any of them cannot be enabled due to insufficient RMIDs?
>> Perhaps resctrl_enable_mon_event() should also now return success/fail so that an event group
>> cannot be enabled if its events cannot be enabled?
>> Finally, a system with two guid of the same feature type will end up printing duplicate
>> "<feature type> monitoring detected" that could be more descriptive?
> 
> I need to add the guid to that message.

Sounds good. Thank you.

Reinette

