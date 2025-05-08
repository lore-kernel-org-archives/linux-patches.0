Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77AF217D2
	for <patches@lists.linux.dev>; Thu,  8 May 2025 03:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746676464; cv=fail; b=e2csb+FYapeqcLtE5R3T5D9W2ToXg2g/e3sbCm46JlvxZSFR3lNVu9MQjHjkHGyCZT7UnkOeYJtHJKf54rMChL1AlV7joV8NMw1ix7XkGFJJSaAwAYPIXLgyfWyuzvj/3GcZnWmQn8v++FSRJmD6lyB7BQDZJwmirPBTNKcjcc0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746676464; c=relaxed/simple;
	bh=WQQJqNca4sgPHA6lgO4qZMbISwovfuL2brPq8DyAPj4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gLs1zDLD5g64ShGlgmUfL49dwQUVfZU/geNXr/m02f604gycYe2mPEsjjmlIntoQkbSWJP0H1YiT5WtbIDglw7xZ6ykPYerUhKIInntj3Gf3uJLfoCj/opOS7FZXmOZpdt4XYP7XL4fQDptgXlFYQM4CQpyj71+Kxru6TuVIpYA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hEL2p097; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hEL2p097"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746676462; x=1778212462;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=WQQJqNca4sgPHA6lgO4qZMbISwovfuL2brPq8DyAPj4=;
  b=hEL2p097SesfkIK6/qBb4EHk2MmL+zJNz1Eq42fzoIje2WfIirL7UBHP
   3ZgrZL7+lWZ3ov34+1vMPR3sQ9vHzZ8y/FKAlBDCyq/5M1H71C83fcg/W
   8zYshKhH2jTrZVpLUqR4wfllKpaDCEPVAP/Xh1szud3+4noZ9IK1Vhd/N
   E4dn9JUXsMeI+q7R4q/espeqjWT+sUx2ft4u56UKAENKWt1TzsNm2RxYP
   iIS3UQS7G0bew18Q07Dz0UCErff1mPVxljDcoYizWedomL44eqrCx/zCd
   QmaBbkbtaKYXivIeJOkE9DYDS+/eOdu5SxW4MzNfIQx86rSAzAJNQDidV
   Q==;
X-CSE-ConnectionGUID: aciCygArR46U5v262CJ3+w==
X-CSE-MsgGUID: 2aE6BMDgQEGsGA+c43JC7Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11426"; a="48602762"
X-IronPort-AV: E=Sophos;i="6.15,271,1739865600"; 
   d="scan'208";a="48602762"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2025 20:54:21 -0700
X-CSE-ConnectionGUID: zjRS2rjCTgSHwTyLn/yNkw==
X-CSE-MsgGUID: OY81DpMFSvOoqe49jr0yIw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,271,1739865600"; 
   d="scan'208";a="135862137"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2025 20:54:21 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 7 May 2025 20:54:20 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 7 May 2025 20:54:20 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.44) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 7 May 2025 20:54:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TWzXVj/4KtQl3Zdd02SCkB/f5v2ormjm/tn6HkJg/LbJZJZN/rJAHGIE4J4lX0AkVNbYkVyqlvxQ8YttFxnx2rnQz9BjNas2l9lJY7ddErNK1qKOY+GHzd9Zr2n/aYiEsQJY0dU4cws71cwL7ArI/mgbcC6z9AMW3sNQKnjZ9MXPFwHup6W28bwO6qIIbKjdi9N1r5C18MYAXPrN++7KVlm+qjSYiK2OWZhqGEHWlkH56ByO774ByTZcfEmRfMzS+pNqcKjsyB6JA5T+fhgHfs55zLM5tIcTthHptjkAUNn1ZUrmoMm+c67kaN/jDByqmz0o4mnA6qFiMGbmU4f0JQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zIzSyUGIT/iQ5ISzDcQ5ToPNOsYQlk0v+bjtNm1k7h0=;
 b=aCFKGRYSdk72cGi0nhdOjpljyFy1CmG1uuMUKp49OyGSA7Hvv556EjLVfYMbQ3BGLVLAa2123cBoCraR++FS1rBZ0r2HDW/kkNcU8+UG45kUSv4KEfTP31kb60QjEMPWw7gowkQcy65BXfXi19A1LusIGvbcgSiM83NT8OPZxPOpa624Xhy2BH6Xx2oFXxmRcPT3HAaxzJr7oNkhMCUBpl2A96y8gFfwal9be3MGkZrtJwZfhhzfvj9G9V+z/HA5VMV3vhTy9c3sqT3AY46Oh1ttEyR/Rg/3HQQz4StjkZuR/MEJngUCEsQzeWbuUW/OTLnKdW8hfK8Kyp++TRuPsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ0PR11MB4846.namprd11.prod.outlook.com (2603:10b6:a03:2d8::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.21; Thu, 8 May
 2025 03:54:14 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.8699.022; Thu, 8 May 2025
 03:54:14 +0000
Message-ID: <5344df28-aea8-4f21-aad6-5587c4e21aaa@intel.com>
Date: Wed, 7 May 2025 20:54:13 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 12/31] fs/resctrl: Improve handling for events that can
 be read from any CPU
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250429003359.375508-1-tony.luck@intel.com>
 <20250429003359.375508-13-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250429003359.375508-13-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0110.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::25) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ0PR11MB4846:EE_
X-MS-Office365-Filtering-Correlation-Id: 78f0c61e-4cec-4d12-87a8-08dd8de3ffa8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?NlIzeUU3dVZzN08ySzNYL05BaEVGT1dDK0M2L3VnWUxEWW5IQ3ZNUDZqaDBl?=
 =?utf-8?B?MWc3SUZoUEFjdXhHZkxCT0tWS0tCTCtoSHUrQ0xSZ2ppbVRqa0NsaEgrVU5F?=
 =?utf-8?B?V3FQbGh0R0prRkRyemF4OGdzWERsRWVwQmROdXhWcS8vTFlMUFFDd0VjVkRI?=
 =?utf-8?B?YndvaGRqZzBacjh0VE14OXNxRUlrZUJUbUpQUXJpZUQ5Z08zSGxtYW5tZ1dZ?=
 =?utf-8?B?bnArN2dqazBaWGdXY3Z1S3NBVFdraEZzWTdiaERhVG9TSXVIeWVPWmxNT0Vn?=
 =?utf-8?B?WXgzY0RQR2VJbGNNQnNVVFllNi9VWFY4TVhyZTJaN3E2OTFIME5XU0R3TWo0?=
 =?utf-8?B?SG41RHNudVpTVHd0MUlnajFxY1pETVVoWDBVdzMzeXA0K3Z4YmNRK1E5c2Z4?=
 =?utf-8?B?Zk1GYUhPZUlmem52ZUQ5SHVESGFiZ3Q2MXM3dTlpb2U0VThqT1piMDVWckF0?=
 =?utf-8?B?aHBua1RFVVNPRWR4L29tb0ViUzJtM0ExcFdtY1hzd1E0MTVaaVhKTmNIY25Q?=
 =?utf-8?B?M3pKTDdEeUdXaG9MSGNjNExIdTVFVVNELzlTcVdUMk83MmREVC9PZEVFVWpj?=
 =?utf-8?B?dzh4cjEyMExMZnVQNWV0QUw4eFVvUjNZRStldUc0dW9DT2RXb0dxSzRCVUph?=
 =?utf-8?B?bUYxaEcvd3BFVkFOaWlLbFZpbXZaR1lsTzI4ZkdoNmZxMVlKTklsdzJPZ1VH?=
 =?utf-8?B?ZE9RWlcrVkN6VERqSldOaHBQRDdxQUxrME4wdG5neGZIWXVSZ0swZFZzeFJs?=
 =?utf-8?B?QVlKREJLQ2FRTlBkeCtmbkRyaGFla0VPYjhxcVhMZWJCaXVBdFlXcS9nQnRm?=
 =?utf-8?B?aVlxYUw0SXF5Rll6TkMreGV3TXBYZFduMHlFeW96eXJsdWg1VUZ3QXpOUyt5?=
 =?utf-8?B?dHZQVk1ZY3NhUHBteUNLN1B0OTZPRUltN3AvWVdsZU9LbnpjNmZyTTFRMzYr?=
 =?utf-8?B?ODZWSG14WkVUWVBOMDM2UXB2QlFQdjZCK2hqVmNpSmZiZUVmTjg4a2pSNk1T?=
 =?utf-8?B?dWxkSHBZdWtQUnZIZDVIaWtoSDkwdzlVVHJPZzNFL2RiZitoM2FzbGpaM0pJ?=
 =?utf-8?B?UnhvUUh0bCtGT01FRzZHSEM1WFIyTmlVUjRTRkdNOXRXM0pSaitwQ1hkaUMy?=
 =?utf-8?B?ZExzQ3hUWXQvNkJYK0RNRCt1MysrM3d4enJLS1ZrajVTMmhGdnB3UjMxWmhv?=
 =?utf-8?B?VkRxTkUyVGFxdmJnQzRSY2VKN25IS2ZaNElQWG1Qb2lId1VUZDJTVXU3L2pZ?=
 =?utf-8?B?RXRqeG5xSjY3eEF4VFc4WUpGc0U5YmRmVklSc3FNY3Njang0RlIwYWlxV1Bm?=
 =?utf-8?B?clFwQlRXWTFOcHJ6Yy94bVZXZmVYOFJGK095NGpaUUJEMmlZQkhpR0tMQlBP?=
 =?utf-8?B?NlNkbmYvOUczeGxUSzU5TXBkY2VNMTdpYkIwbU1FdkFrQmlDVEdXL3l3Z0RV?=
 =?utf-8?B?cUIxVFRsRTd0Vzd5SEx1Z0ZQNW56ZVloYnlqQjl3OWdCNVZXSS9QanpoeTc1?=
 =?utf-8?B?R3YrSTU0TjdmUGI5bmQ3WDhHNjA5N1lLUjdZL0VWL0lhTEZMWmErTGZKRlZu?=
 =?utf-8?B?eXVWakpueEVFdE9ZT0NjbnNjTHIweFlWQWtVTTFCcVJBNHY0Y3d2NXVIQ1dq?=
 =?utf-8?B?N2pXeGxLb2JwRk94dm84bnNjQW9ZVHJmOEpnRzdac3JNcHludFhFYlJ2VVpj?=
 =?utf-8?B?ZkNmQU5XM0VzMjZWSTFyeTRGY2hCeGsrYVlubWs2Y2xoZ2tFbjJnbGRySnZr?=
 =?utf-8?B?a0FnRkh0SkZDazl2b3cvODdvaXppNWVRMEk4MnhEdXlyN3p0aEkrek45SENa?=
 =?utf-8?B?c2hQbnlaeStZMVhPSGZvWWVQNGhJdWZzaXozTjYxa2h0a005K2g3SHR5TCtJ?=
 =?utf-8?B?bWFlVlplUk8zeGRURnEvcmhka2ZzMENuRTR4VGY0MW12MHpxbVFpTmF5S3B0?=
 =?utf-8?B?ell5SFlveUt6Q3JDREp5Q2h5ZVFrQnJFRHVrRXI4anl3NG5Yd2czWWtxYVUz?=
 =?utf-8?B?Q1p5K3JURFR3PT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RXhKcXowN1MrNTBUQTFQZ3VqVzNTQmlNWERJaVR5V1plRlNKWlAxdmVOMXpF?=
 =?utf-8?B?YTBpSXY0KzRHcUFaR3dXQUsraXdBRVdrek1xZkVrQzJMK3l1RW5rZU10RVBs?=
 =?utf-8?B?c0NzenJxM1BqSHc1eHF5b3UxWDdwS2xhVWovaEhnR2x6enQ5TDU4bllQMW9H?=
 =?utf-8?B?YUZsTGd2RVUxREt6WXdGWTk0ZFdtRzZocWIvM296b2N5Nm1iYzRhQzZ3ajg0?=
 =?utf-8?B?OWZiZFFZTWJhZXNLRjREMXNZQ2dRcVppN3JSSmVEQURDYzhvdHZrZWxkOGN4?=
 =?utf-8?B?NGlqNnRMdUI1YWpDQWYyZnRZNDl5Uy9NVDU3UXEwdWVUd2Q0eEp0c3FBLzhV?=
 =?utf-8?B?OHZCQU54T2hURFVPRTFpWXdDcy8rMmpRUGdMbUNTVm9MWFJLcm1GZzBsSzVk?=
 =?utf-8?B?UmZhWnI1RGdVWHliL3YwMlZ1YXMwS2gyS1JLVURJVUw4TDJFK3JpUXkxendR?=
 =?utf-8?B?M25vK1pUb0tMR25MOFUrWmdTVDJRNkNJdnU3UXBtVTVEemQyVTVrN25lOFlL?=
 =?utf-8?B?NjZkd1h1WFlHR2hxeTdsb3JveU1DbS80RDhGZEtJbHpEOTlZbnZpNS9WMFlD?=
 =?utf-8?B?ck9hSlVvK0VwT2hwZGFRclFYazNOdlp0VlhiYllBTzk5R0NDaVZSdDR6aDNq?=
 =?utf-8?B?aUo3WHhPbHVxRThoMkZSR2JtaDQ4Mk9BVGZzUUFTdXZ3Wm5ES2lPSGhpTDB2?=
 =?utf-8?B?UFlsUG1xcFBockhGeDhtUDZVa2hRVzVOa1YxM3hNYnBFbWJ4L0xOQ1Q2bVND?=
 =?utf-8?B?c01BYS9wY2dKSkwrVVZnaDBaUXdiWmVHMW53elNuV3hIeUtzb1RORmpoeHYx?=
 =?utf-8?B?c0I1Nms0cDNvWVA2ZGpZdUZmUnZlODhpcVR0M1VvUEJoRU1JdWFLVGRZK2xq?=
 =?utf-8?B?SE1YcmJ5Y0FOaVIybjRDcitscnJxNXhsNkpxSFJYNE1jZVBWK24yU21oclZM?=
 =?utf-8?B?UFhJOUNkOGNLL1B2aXZ2Nk5JR1V5RVRGUDJ5S2puOXF2cjRGeSs2Q0s2OERn?=
 =?utf-8?B?L010Z3pFSXpxNmZmYTVlc3BFMkVDVzdHT0lwOC93dUF6bDg5MDNIeTN6QzJw?=
 =?utf-8?B?c0l1ZzFkRzJFR3JmL2lxbWxTU2N1LzU4emIrbndKMWx1ZFlYQ3FYczJ1ZFU5?=
 =?utf-8?B?UEpUZm1PNTVTNnZIMDQxQkNTRVdrVHU5NlAyM0xORG5rY3Q4SkUxMlhaNlN6?=
 =?utf-8?B?K3JjMjJTSVZRR2ZkUlVySzNJRkxIcE1qcXpzQ2VMZWVleFJXdFdsWmJvd0tX?=
 =?utf-8?B?Q2Y1d1ZDQnFpTDltRyszRVRudmp3UWMyeEtKUVBWRE1JUHlvWTArOVBkb09i?=
 =?utf-8?B?Z0RpNXlzb20xKzIwTUFLZWN4WmVLUGNuRHpWaXlBbGljQlhjbStjQnRBQVdH?=
 =?utf-8?B?QUxXeFJzMXJMRFR0ODdNZmNKWDV2Mi82dHpSd0d3eVMrd2VKbWlkUjJ4blFV?=
 =?utf-8?B?eTBnZVJ6MWQ0a2RNVVNKMk9HemtMVDV3eFozcjBFUnE0Rm9DSi9vOFB1MEtn?=
 =?utf-8?B?Y05Cdm9rZjN0K2lydmlVREtRQkRzbnZJOSt5WEp2NTR4ajBWb1Uvdzd0TnBk?=
 =?utf-8?B?c3JldVhWekJKSmVRSmFLV21ISFVOZ2xWMmFpQUc4NFJUdTA3c29ISG1FeVl0?=
 =?utf-8?B?Q3BKM2I1NUpXbjQwL2RMQUh1ZlJvR3lKM3JpMENxSHd1aVMxb3JzUG9HYVJS?=
 =?utf-8?B?c202WVpyM01NaU5IdnBCdHJFZmE3S1lTeU5kbDJvZUNsM3JkdW1xaHVyc0VT?=
 =?utf-8?B?THR0UmJOVlF3Zm04L2JCNUZMbjlDRmZFQjBXRjBONGdyM1hpVDNZWE1mOVdj?=
 =?utf-8?B?VFkzSC9YbS9TSHZnTWhoeXp1QTFxS29wYmFqNkFobGpuZkdTM3AybTMrbG5s?=
 =?utf-8?B?U1VQZ0YrOExyNisxd0xTUUVpbkhNanNsS3lSWnRNRDJaT3BXamF3K3RCei9O?=
 =?utf-8?B?bHpVSTlKNE1IVmR0Uks3TlltcEVRMlFWM1dHbktIYzUzenZic0MzRzRWMmpS?=
 =?utf-8?B?cUh5MTRaclZRK1JDa2htVk9jREwxancrbVM4NXVoMnM2M1kwS25yczBJZjBz?=
 =?utf-8?B?ODI3RktoalVBVHA2ZEJabk5LOXRIRExyaklzRVA3V2w1Uyt1c1dPRlVka2Rz?=
 =?utf-8?B?ajJYeUZCTVNzZnVvbmRlYW81dzN3WDNDdTlaZ2p2bUpSWm5MeFl1cjl4UUsx?=
 =?utf-8?B?akE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 78f0c61e-4cec-4d12-87a8-08dd8de3ffa8
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2025 03:54:14.3981
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vGukraH2oLgU33rDG/M6j/ysSIfOCcgmDFQHMz9k3vSuW1OP4iPb0ozzWgdm6J2psDMNiKU7ob8ej1z+fLgk12U3IbyM/Yma061OYW67w4U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4846
X-OriginatorOrg: intel.com

Hi Tony,

How about: "fs/resctrl: Handle events that can be read from any CPU"

On 4/28/25 5:33 PM, Tony Luck wrote:
> Resctrl file system code was built with the assumption that monitor
> events can only be read from a CPU in the cpumast_t set for each

cpumast_t -> cpumask_t

> domain. This was true for x86 events accessed with an MSR interface,
> but may not be true for other access methods such as MMIO.

Please separate context and problem description into separate paragraphs.

> 
> Add a flag to each instance of struct mon_evt that can be set by
> architecture code to indicate there is no restriction on which
> CPU can read the event counter.
> 
> Change struct mon_data and struct rmid_read to have a pointer to
> the struct mon_evt instead of the event id.
> 
> Add an extra argument to resctrl_enable_mon_event() so architecture
> code can indicate which events can be read on any CPU when enabling
> the event.
> 
> Bypass all the smp_call*() code for events that can be read on any CPU
> and call mon_event_count() directly from mon_event_read().
> 
> Skip checks in __mon_event_count() that the read is being done from
> a CPU in the correct domain or cache scope.

hmmm ... this patch is bundling quite a few changes. Most are related
to the stated goal but I think separating out the change to 
struct mon_data and struct rmid_read to have a pointer to struct mon_evt
will make it easier to recognize what it takes to support the
stated requirement of needing to support this new style of events.

...

> @@ -570,7 +575,8 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
>  	struct rdt_domain_hdr *hdr;
>  	struct rmid_read rr = {0};
>  	struct rdt_l3_mon_domain *d;
> -	u32 resid, evtid, domid;
> +	struct mon_evt *evt;
> +	u32 resid, domid;

Please fix reverse fir.

>  	struct rdtgroup *rdtgrp;
>  	struct rdt_resource *r;
>  	struct mon_data *md;
> @@ -590,7 +596,7 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
>  
>  	resid = md->rid;
>  	domid = md->domid;
> -	evtid = md->evtid;
> +	evt = md->evt;
>  	r = resctrl_arch_get_resource(resid);
>  
>  	if (md->sum) {
> @@ -604,7 +610,7 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
>  			if (d->ci->id == domid) {
>  				rr.ci = d->ci;
>  				mon_event_read(&rr, r, NULL, rdtgrp,
> -					       &d->ci->shared_cpu_map, evtid, false);
> +					       &d->ci->shared_cpu_map, evt, false);
>  				goto checkresult;
>  			}
>  		}
> @@ -621,7 +627,7 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
>  			goto out;
>  		}
>  		d = container_of(hdr, struct rdt_l3_mon_domain, hdr);
> -		mon_event_read(&rr, r, d, rdtgrp, &d->hdr.cpu_mask, evtid, false);
> +		mon_event_read(&rr, r, d, rdtgrp, &d->hdr.cpu_mask, evt, false);
>  	}
>  
>  checkresult:
> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
> index 19cba29452b7..e903d3c076ee 100644
> --- a/fs/resctrl/monitor.c
> +++ b/fs/resctrl/monitor.c
> @@ -365,19 +365,19 @@ static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
>  	u64 tval = 0;
>  
>  	if (rr->first) {
> -		resctrl_arch_reset_rmid(rr->r, rr->d, closid, rmid, rr->evtid);
> -		m = get_mbm_state(rr->d, closid, rmid, rr->evtid);
> +		resctrl_arch_reset_rmid(rr->r, rr->d, closid, rmid, rr->evt->evtid);
> +		m = get_mbm_state(rr->d, closid, rmid, rr->evt->evtid);
>  		if (m)
>  			memset(m, 0, sizeof(struct mbm_state));
>  		return 0;
>  	}
>  
>  	if (rr->d) {
> -		/* Reading a single domain, must be on a CPU in that domain. */
> -		if (!cpumask_test_cpu(cpu, &rr->d->hdr.cpu_mask))
> +		/* Reading a single domain, must usually be on a CPU in that domain. */

No need to use vague "usually" when it is very specific that it must be on a CPU in that
domain unless it is an event that can be read from any CPU.

> +		if (!rr->evt->any_cpu && !cpumask_test_cpu(cpu, &rr->d->hdr.cpu_mask))
>  			return -EINVAL;
>  		rr->err = resctrl_arch_rmid_read(rr->r, rr->d, closid, rmid,
> -						 rr->evtid, &tval, rr->arch_mon_ctx);
> +						 rr->evt->evtid, &tval, rr->arch_mon_ctx);
>  		if (rr->err)
>  			return rr->err;
>  
> @@ -387,7 +387,7 @@ static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
>  	}
>  
>  	/* Summing domains that share a cache, must be on a CPU for that cache. */

missed comment change

> -	if (!cpumask_test_cpu(cpu, &rr->ci->shared_cpu_map))
> +	if (!rr->evt->any_cpu && !cpumask_test_cpu(cpu, &rr->ci->shared_cpu_map))
>  		return -EINVAL;
>  
>  	/*

Reinette

