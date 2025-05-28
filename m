Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EBB71E5B6D
	for <patches@lists.linux.dev>; Wed, 28 May 2025 17:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748452928; cv=fail; b=BgoCjeY3GIeP/gF7nLZY+VSaJIZQc84ipLLhefE6qBgHZSf3cezU6M1qPsLhP5ulIQLcM8F7d9CieQ3B+yzK7xFUncm7zG1R/rxYM+TAg8VVMaVFKz48lRbmre1CuIzQHXn07wnER3iMNB1hMsmsLkuj+yAM3eG8q3znqF9qDN0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748452928; c=relaxed/simple;
	bh=+L/+10zQsn9endYx6ITeT5C+bvk8+dHI+SkOw96HQbY=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=eOZDWMzGwwYYvkbzOVduqvBjLlT0bGHJQnMhn8r2cNkbSx1/zl15IzQENm0+bf1CAevDpxsjcOFFVZ0zY/0PkiDkuwUdJAh4LXL55GpQnpx2jMIsKU3apPM8mydTklBHW3QsLV6vUN+z+7Dcr/gNQUj0mcTsoucln2gJEVKX8ws=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LIdnI8Ay; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LIdnI8Ay"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748452927; x=1779988927;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+L/+10zQsn9endYx6ITeT5C+bvk8+dHI+SkOw96HQbY=;
  b=LIdnI8AyLEO87OTNQ+O2HwnFljK7Q1aO1/bnJ8A2Bym/2miZTs+1t6gt
   X8NMOQmGF3fCDPxRuvOqr/QmGLS3gm7TTMvYOV7aJ76HceP3qH/mecTh2
   g49jD3joOvfwSMBNR9ZArY88iT1OGcCPNNNEc41flWd3fqMfbMZcIJJ5J
   /3CpEWaedzGW7mOAHw3rnbBKKWGs+gA2wdAmVIEY8x7KJmI/gQTiQYOZY
   DVxxBA+DFlaex4IDil95UBJUjjDpsS4IDYpIhkT07RXsdnLILPxmz02cR
   eoL0ir9ennbLR/lzfr9Yr9hlPOjuZgDQzUu6XGCZHI08MM0h1Lcqo9QoR
   A==;
X-CSE-ConnectionGUID: Por9ZBDZQaaaadlsJYDlNw==
X-CSE-MsgGUID: RMfPuIsRSrCnPk8EPmy8GA==
X-IronPort-AV: E=McAfee;i="6700,10204,11447"; a="50643036"
X-IronPort-AV: E=Sophos;i="6.15,321,1739865600"; 
   d="scan'208";a="50643036"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2025 10:22:06 -0700
X-CSE-ConnectionGUID: 4wvmtCaGQg+Q0UWOAUX4ug==
X-CSE-MsgGUID: oR11CYF9S8ecks0CrqgSoQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,321,1739865600"; 
   d="scan'208";a="144286047"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2025 10:22:07 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 28 May 2025 10:22:05 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 28 May 2025 10:22:05 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (40.107.95.50) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Wed, 28 May 2025 10:22:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SJK13GANJXNZ6oKcMBoHXAyDOe0GfN5wcQAlcSVoEdblHXCy6inZV8xzaMBnWgSB8IocqNRzmGiSC7KfdK101FUBlnYyz1cnUY7CnNfH1yPqcQgsxcqoiF9k6CR/Kpgbo4k1Ppp6HszDpv4XYFv5rQiZp45DCSvZcjdsdD4SsN1Y5NamhVNEYKNee5DieHQHF5zezzTLjosSihJIKPYthEA22lJG1Wo4mQ06mdJ4LwYWZmr/AxYhLUCnpIhFk+POyIgNR+3Z0oV94TDaW5jrqAFC0d01Y91IaWKVUoRaJ8lihp1aSXDa/maBrl4YS0jEK/4zx2iTe+me/GOVuPQY3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6jAZ2hjWN5o5+RaoNCEOOpzG6WUyyMxYVorm7Eje4Kg=;
 b=LUC9CP50vIndOG35KoWbYV+Vxo6KAaAMZ5zbYQoK1xjZ/n+wlKeLTRFrY65wvHDr7VbTMl635Uouth/WUV+6xNbRJjKmvOpbxynvndLoC8DEDAwwQnTsvi0vLbZvGgyYwqMOxdImIudRfRcQK8PKq8GdqtBwrP8Tp+4f58pI7YmeotYN8JD5GU3Q+SCIusqFPpNXNGOKbHpq//rvNgL1vMXA5vEuApwuhGSZNOwUG/D/alw6JTXD5a+yqyvg3DmxptRmWa+7i4+eBZ/f7ymilSE1qFCPAG1pQyohv3J1vYChIqm8/OEPT8E5XxymPXyS1/07qla36jz63GMEa8/4dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by MW3PR11MB4601.namprd11.prod.outlook.com (2603:10b6:303:59::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.27; Wed, 28 May
 2025 17:21:21 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.8769.021; Wed, 28 May 2025
 17:21:21 +0000
Message-ID: <b8ddce03-65c0-4420-b30d-e43c54943667@intel.com>
Date: Wed, 28 May 2025 10:21:01 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 00/29] x86/resctrl telemetry monitoring
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250521225049.132551-1-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250521225049.132551-1-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY1P220CA0011.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:59d::11) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|MW3PR11MB4601:EE_
X-MS-Office365-Filtering-Correlation-Id: e0fac0f0-5602-443c-7758-08dd9e0c1052
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?R3pJM0VWWk51blovY2t6UXJPY3RHUTBmTkVGSHE4MHZGclVSVzByRGtGTzNR?=
 =?utf-8?B?NVZMOWw2RnVTSjRYRkUyYkZlaG4zRlRjT2RLYXRxcWxCS0JkTzQrblVQOXlP?=
 =?utf-8?B?bml2cmtlNXRpUU5lMS96U3A2ak1salB1Wmh2ektGKzVDMHN3cGdHVjRiOEg2?=
 =?utf-8?B?elRRemk1OUdKRFhUa2pLVGZwQktWQ0dob0lRekF2OEhiZ0lwWGMwVFhWTVRL?=
 =?utf-8?B?aU44M0hKQlFjWVpmVkR5a3VmVm45d3diWVQwZjAxNWZEdUh3dm1mcjVxTlBB?=
 =?utf-8?B?RDRXNjd5aUtaQVlsQ2I4cUVBQW0zOXBYaHA0bHdTelhZeUJkanVpMkxlMUd0?=
 =?utf-8?B?ZURqR3ZFSkZsZlRid2hBV2s0ZGJibnFhS1JGZ2FzZVR6UXlqTVI3S3BBRlR6?=
 =?utf-8?B?Nks0eVozZWM4TnJzWmFjOWdVVmRjSHFJVWJrY3VXVTBEL3JEVnU0SUVwcE1M?=
 =?utf-8?B?UERPcjZUT1pDenhqUDBPV1Qza0hZS0d1KzBEZEc4K2x0bE1KdUpCRHBxK3RZ?=
 =?utf-8?B?d0xJLzBWYXVBU3h1ckFjcHVBajFtSnp3QVlwcXFzbW5pdFVTWVNjYXMvUDF3?=
 =?utf-8?B?Z3F0a0prZXFUWWhWbU40bEJRbHRiZTJDd3g4VFdtOUN5UmxmMmp0M01hOENq?=
 =?utf-8?B?eGs0Vm5kNmRUbWxoWlVUK2llSmhnUnBNbU8ya3JkQnh2MFBQUk90R3h5YmJq?=
 =?utf-8?B?UjNvUU5wdVZZdXNJMjFLZ1BuM09XU2ZOUkFDYXdpZnN2TE9XV1RUc3o4ejh1?=
 =?utf-8?B?MksyRllzSnJPNnBFT0tKSFZZUDc5WWpJSEJjN0xOaXdsNzFOM3Ezbk1tSVZ5?=
 =?utf-8?B?R1FpL0dRaVEycDYxdE85UGFjc3dtTTlqWm56dnUyaUZwU1ppTGl5aVZZRkZO?=
 =?utf-8?B?azE5M25mSlBlbkt2UUhYMm5HLy92M29VdG1TVzkxNFdFZGpld05qR2dCcUo4?=
 =?utf-8?B?cFd5MmNwc201OTJKbmpxYjlDRWMya0ptVnlOLy9JUVdrdmd1czVzSEt0YVFE?=
 =?utf-8?B?SXVjbTBYYkZ6U09NNmpqanVBMTZFZTB0aHBURllkR2wxZFRsdTB1UytFUEgx?=
 =?utf-8?B?cTh4aFRWL2VGR0hkc1BQWk9wNWZ2VTZGMlhsYmt2M3BrcnU4SkRXMDBxMThD?=
 =?utf-8?B?V2lGWFFha0g5YWk2a3A1RE9VRVZYSkNMZFBGUml0NDZodHc1c0haOFFhbkVx?=
 =?utf-8?B?RElvMlpoNWpxZ09RcEpjZXZzTnRyd0JvNGdXTjRWSnVKTnBsQUxRNFFPUDhB?=
 =?utf-8?B?a0Q0Z1dHWkE3dVFRbzV5MHFRU1BleFlzQi90RGdVZDJnVkJKM0NOWEpQOHgw?=
 =?utf-8?B?UmprbjlKb2lkdllkbzJvc1N3cGlmZW5OQk04ZFVHR0o1Q2dsWktrZ1c4THE2?=
 =?utf-8?B?Nlkyekt6YzJiSUFhSEZpWVNuZEhsN0xURVhpMndXVkJqdG45cWhoSlRtZ3pU?=
 =?utf-8?B?M0ZKeHp4ZGJrOGtBWFkxamxwdHRwdmx3MEhqeDUxNDBoay95MTMvWlF5TStr?=
 =?utf-8?B?U3VpaGZaRmJoMEY3VWhhN3orVFlnMSsxQTcxZzlRc3IwNkNLMHc2TG9JZ0hQ?=
 =?utf-8?B?K3pJcjhuTHlzUHBoUmNETkdFRW92WWVReVArQVJlWUYzRkFQbDdvT3J6Nzhl?=
 =?utf-8?B?M3dTdXZtNmRzWDloWjRkRU5pMFU4SFN2M0dIaitjYUVnVUJhRDZQTElsZ055?=
 =?utf-8?B?WDBFUnM2QXJLQUVMR0tSZVJXcjd2NFo0N0pFTkFsU3hGUUJYbzVXR2dhM3lV?=
 =?utf-8?B?RHBnZ2djYUREbkx1Y09jTDVkVHB1a1VxK3dtUzBwRGIyOVFLOVowUXBZNEhs?=
 =?utf-8?B?RXlVL0hUbzNzblFDRzJabWV5czNvSGluRTB6V0FhUHBMZnYzN0QySzV5NjQ0?=
 =?utf-8?B?RnhLM0dSM2M2NHlkVmIvcnBtdFFsSjZ1aWJwT1NYcXNUVWF0cE1IVll4a2Zo?=
 =?utf-8?B?Uy9mSmplQzh4c0pWc0tRYmhIUnV0RlhkQXBCTGk1dEE1MXU3dFRwMXlnQ0hW?=
 =?utf-8?B?YkhUd3BvdnFBPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S1FHMXBBRkNNcGs2RXhudVlGT0dHTWo5VmR3b1NGZDlOVWtsYTlDM2lrSlkz?=
 =?utf-8?B?T1Z4a1pCWTBGcmhBS0RqazRMV0dyQm9rWmhWUVFNTnY4UEtYSVRvNW1ubUtZ?=
 =?utf-8?B?TEMwNUZGUWRlREpPYkVGZkJMQjBNRHdHQm92NzhNWEowR1dQNzFvTHgxY2Y4?=
 =?utf-8?B?VFNLYkZPRWNIcVVCV2FycXl6bDR4bWJ6SHVtR05jZTVrWEsrT2ZpUERvVlRZ?=
 =?utf-8?B?QUVoVVJ3Zkt3ZWJpMG9XaGhIaFlkdXR5ZloxOEl4MjU3OWw4dEsvcC9XbzZx?=
 =?utf-8?B?bTFuZFd2UnlVa3lOMWhoVlFWcW5tZDNmY21uZ0VtYkFsRld4SUhpcmpWb2I0?=
 =?utf-8?B?dlBTbzNJcnRRV2lpWHhIdHBIWGRXQUp2djdtSWRIMC84dXdiR0NyZFRyOU9j?=
 =?utf-8?B?QnhsVVZlWWVOREpZTFRjMzVMQjFwd1Bic3QvemE4TXFnM2dIMTIxWXk3UGZt?=
 =?utf-8?B?bFdESElRb20xSlZjdUlXejdrdEZrcTQ0bGNsKzFGSVpURzNhempzZ0lIb2gr?=
 =?utf-8?B?VXQwck1Ick41U3BwYThFRk9iRUlIQjNUNHdOTVJKQTNZWkdXdTJ1aWl4ZlZM?=
 =?utf-8?B?NVppeC9CN1ZwNllPTUJMYnJEK0k1SXVHUkxWUVZCdDlOelp6MDFWQVlpZ1Vn?=
 =?utf-8?B?NzVuUlNvTzM3R2l2M3J3eWVRaE9OLzBsQWxuVkNiS1ZTQVZiVW1JZmFwUzhF?=
 =?utf-8?B?ZCtBUkg4YVE4N0JnOW5pVnhVTTZDQ0lCaEVIS21pSi96bGlpODlhVE9qaUQ3?=
 =?utf-8?B?RVl1ZXM2STdEdFIwTSt4cWtrZFJacUFueXFrcEh6dEV4ZkdET09JWkdLYUhK?=
 =?utf-8?B?NFNkbWhaSEMyWU9tOU01aVZMQ3FwWHRacU92T1Y0cnArd2c3QlJvSWJGamIr?=
 =?utf-8?B?dWVSNHE5cTV2QUtQNmhXVTcyZnBXMVdFV1k4TDJSSXc3czV3U0d3a0pYVTI4?=
 =?utf-8?B?dEJmVjhEQm5kK2RXbE0wTXd4VjJyaFRQR0JIVFMxeUlnK29CcVFPWWoyUGRn?=
 =?utf-8?B?anRjMUV3OVBaVXd0aTBtNkZpQmtvdDl2ekEzRElNMWRHQjc2U2prTFV6Zkk5?=
 =?utf-8?B?aFZGSEpIcTFPTU51UGFubDRsU3FVdkxCSVQ2dzMwNXZHdlJPSVFRNVM3c3M3?=
 =?utf-8?B?YXNFYTdYVGNveVBNSDR1eDNNUzA5U25xZzFXdEJSU3JvS1BvT2wwY0U2dU5F?=
 =?utf-8?B?TjVzYzNyN016SWJocnlRUGVURUFxYkJFRkxrdDhLWjBnM0d6ZmtrQmllZFlu?=
 =?utf-8?B?ZndvM3o2bmkzcGQ2MzdLSWg4cDUzZWpTRjR0K1QxcTI3LzQ5ZU5EdTFuSmFV?=
 =?utf-8?B?T0hPZGhoVDF4cStEakJ5elV0VWVNclM1NjdueEEvWXFlN2FPOTFlcVJuUjcw?=
 =?utf-8?B?WFVoOVh0MmJ1ZHluRWM1Ym1RWVZNbmdoQVlDOGJwcmJ3TW9iSHNkUERyMk44?=
 =?utf-8?B?emlXazZGc0RYYXpNeDE5aW52UHQ3SEVuKzJQa2lXbS9tTk42SE5DS2NEMXhs?=
 =?utf-8?B?emFCYjkwTmlXcGZLMjVQTFQ3d3VRdkppeVd2QUF3cUxaUUMxZlBaWW5CbDIv?=
 =?utf-8?B?aVJBNjE4RDE4YTlCajVndjdlRDRNTHFDZXVDQ1M2bjV0MW0xa1FhbFhQVTlO?=
 =?utf-8?B?M3ZwcGI3Rlg2VFBTREZJRFh3S2xLcVBxR0V0bitXQXI4c0JUVlRHdEY1R0xw?=
 =?utf-8?B?dUdwVGNIUTlJMnFtMDVLVVA5TTZ5ZWl2SEJSR2wxL3VjZWVyZmFhb0R1MWI2?=
 =?utf-8?B?cVdJbStPRmpnRk04UXM5aFFMeStPQzJSNjBvNjFSaXhXcFhWVXVKY3RVUEZj?=
 =?utf-8?B?d0FHTG5BdU5TeHhraThCbFZwem9wd3ZmSjY3cW02UEJSVU1KbWliNVdUd1pO?=
 =?utf-8?B?Zlg5M0hCUWUrVVU0amxtUzF2ZENqdjg3M2hvb0ZhTTI1MHM3ZlJRR3BSNUU5?=
 =?utf-8?B?OE1qdW12c09iaWFSVit4aUVsc0picXpIYm9MSHY4VDZPR1pqd1dnSTdQUStx?=
 =?utf-8?B?NURKMmRlcXJJRmdQRll0VGxlUDJ4ZUtqck81b3RIOUh4aWdMYUZQUzFWeG9q?=
 =?utf-8?B?N3A1bFVEN0puN2hibklqNWJCMVdqWmdZcGVNcWtZK3RkdFFkV09BT3ovMmNT?=
 =?utf-8?B?SVF4eHhyVHNiNjlFQTZCc0t3Vy8rTEFYcXhDcW1Ta0ZJZm1mcHYxNzU1Zlp4?=
 =?utf-8?B?cHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e0fac0f0-5602-443c-7758-08dd9e0c1052
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2025 17:21:21.3148
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cmNetC/dRuJvNkZV7uvX5IjzcDOzv+Muy1GBknQXCMTJVzbD+pJ1QadeCN9iU0Y313UHkVzwzuxUOOb2ZcTtqF3UvfnwFOEIIFMrbeEF5NY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4601
X-OriginatorOrg: intel.com

Hi Tony,

On 5/21/25 3:50 PM, Tony Luck wrote:
> Background
> ----------
> 
> Telemetry features are being implemented in conjunction with the
> IA32_PQR_ASSOC.RMID value on each logical CPU. This is used to send
> counts for various events to a collector in a nearby OOBMSM device to be

(could you please expand what "OOBMSM" means somewhere?)

> accumulated with counts for each <RMID, event> pair received from other
> CPUs. Cores send event counts when the RMID value changes, or after each
> 2ms elapsed time.

Could you please use consistent terminology? The short paragraph above
uses "logical CPU", "CPU", and "core" seemingly interchangeably and that is
confusing since these terms mean different things on x86 (re.
Documentation/arch/x86/topology.rst). (more below)

> 
> Each OOBMSM device may implement multiple event collectors with each
> servicing a subset of the logical CPUs on a package.  In the initial

("logical CPU" ... but seems to be used in same context as "core" in
first paragraph?)

> hardware implementation, there are two categories of events: energy
> and perf.
> 
> 1) Energy - Two counters
> core_energy: This is an estimate of Joules consumed by each core. It is
> calculated based on the types of instructions executed, not from a power
> meter. This counter is useful to understand how much energy a workload
> is consuming.

With RMIDs being per logical CPU it is not obvious to me how these
events should be treated since most of them are described as core events. 

If the RMID is per logical CPU and the events are per core then how should
the counters be interpreted? Would the user, for example, need to set CPU
affinity to ensure only tasks within same monitor group are run on the same
cores? How else can it be ensured the data reflects the monitor group it
is reported for?

> activity: This measures "accumulated dynamic capacitance". Users who
> want to optimize energy consumption for a workload may use this rather
> than core_energy because it provides consistent results independent of
> any frequency or voltage changes that may occur during the runtime of
> the application (e.g. entry/exit from turbo mode).

(No scope for this event.)

> 
> 2) Performance - Seven counters
> These are similar events to those available via the Linux "perf" tool,
> but collected in a way with much lower overhead (no need to collect data
> on every context switch).
> 
> stalls_llc_hit - Counts the total number of unhalted core clock cycles
> when the core is stalled due to a demand load miss which hit in the LLC

(core scope)

> 
> c1_res - Counts the total C1 residency across all cores. The underlying
> counter increments on 100MHz clock ticks

("across all cores" ... package scope?)

> 
> unhalted_core_cycles - Counts the total number of unhalted core clock
> cycles

(core)

> 
> stalls_llc_miss - Counts the total number of unhalted core clock cycles
> when the core is stalled due to a demand load miss which missed all the
> local caches

(core)

> 
> c6_res - Counts the total C6 residency. The underlying counter increments
> on crystal clock (25MHz) ticks
> 
> unhalted_ref_cycles - Counts the total number of unhalted reference clock
> (TSC) cycles
> 
> uops_retired - Counts the total number of uops retired

(no scope in descriptions of the above)

> 
> The counters are arranged in groups in MMIO space of the OOBMSM device.
> E.g. for the energy counters the layout is:
> 
> Offset: Counter
> 0x00	core energy for RMID 0
> 0x08	core activity for RMID 0
> 0x10	core energy for RMID 1
> 0x18	core activity for RMID 1
> ...

Does seems to hint that counters/events are always per core (but the descriptions
do not always reflect that) while RMID is per logical-CPU. 

Reinette
