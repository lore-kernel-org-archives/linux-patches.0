Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0E8723C50A
	for <patches@lists.linux.dev>; Thu, 14 Aug 2025 16:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755188103; cv=fail; b=K5pF7cR960QbU2xy1tKZI8AmQdJYjkot2c4zkRHuvMbhmPmGEAGL1fuxOj2Jtt4ryhLGcveQ3CNaxOqQXnvUYlskUCY4m131ygmZdphQvatuddvfFWJtuYREUkGEgbbqHGl7Lwyz0QGxqUETwDHXL//Dk2mxwYgUj2xY+UQbgP0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755188103; c=relaxed/simple;
	bh=Tij525a6JRRDQf5oqFtwvcFNILJEcmh33H2fL+0+Qsc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=eldW2rbjMGWngMV7/rgKfwjN4qSzZvtHn0UK5u5FDMXdg09nBWQuR/Sotk3KOHwYjXP8MyxQGSQ3qP3hFO5FX2/sVqzk8lVX0DqKY00M/y6oH/5/JmulljOw74TeBQDLrzZdEKmCGt5ESI/qyqMSwK8FgDmOFvvl4FjsxMOLfVE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gBTY4mz4; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gBTY4mz4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755188102; x=1786724102;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Tij525a6JRRDQf5oqFtwvcFNILJEcmh33H2fL+0+Qsc=;
  b=gBTY4mz41Fs9ZBE5KVu9Egv4tPYxaMmIbFpHAw90uRZKng6xkibTyRVd
   TTx4plcQTEL8z0tbpBQzh3+tO3iCeoPukREVgdDIj6gNZrLGBYAuyhbuS
   DxgJ6cBiHdsfFZbrCg1XHKEa0D0JagMqonhisKnLfaWbWGW2cuQUb45SB
   Bmc3Ajo26HNJt+77bsYAG2ZnShD90iToH744PbgVaz1dF3//2Oa1K5lUB
   YxPY6n2BEzcUpbLZeDChOmffQiMIuk6G9fDmbu5ZDR1YlPGrnLYPWk4eW
   vnp6ebyraqKVnX4E8YTbMlTDB0yTlcQ+eU23GvfMmjMUbujJ4tf6iW4C9
   Q==;
X-CSE-ConnectionGUID: kvXvO9CGQ1OQ/rsewh3kkA==
X-CSE-MsgGUID: 2nzejXmVRwKfwTxmjIoKog==
X-IronPort-AV: E=McAfee;i="6800,10657,11522"; a="60136588"
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="60136588"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 09:15:01 -0700
X-CSE-ConnectionGUID: t+/Dy5eIQbmXEceHHyruXQ==
X-CSE-MsgGUID: mGDprjGxQwGzhEtaM1ACzA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="197650659"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 09:15:01 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 14 Aug 2025 09:15:00 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 14 Aug 2025 09:15:00 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (40.107.96.80) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 14 Aug 2025 09:15:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hXhm5EY1pjL0j/9ocPK08n47sDjSfHVPbK8zxSu0NUxzFucLRBWfQmUMG7tFrBtLB225UOgftbEB/dSBUSGMycpVRTwQTCCmyFNQcE4mV3rm0vyYEm8b5j1tcv8wuC5FrN8KKYezaZsjTunuVWVn5bKZi2VBxwtm6Di1knxsqXFt/VTdnzgEZO4IbFOftdIRJk1rxFyYExnkHUtte6O0xmhhPSU4nY6QJpsA+iQuqZgRldb3Grari9cWexcGPjzI1YtjZtHcAhhMT4jn0o4QqTPqHXgKPfQbHOuhkaFUTiKvOxzAQhCTiIv/GH6KPl/y0bkjrK1k7curvswQ166ZxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8bOg7GacnqpWmxtanLW6ZBduwWlXxmSRxz8jNmoeZVk=;
 b=nIps2JYY9VICq0AGYIMVIVEOehz2CDGXnDQDNSAw5lAFQaqzVQLE1YYdtfTTpZl8Q1dVqBGfMEV+fhPCiRzaKCQkvkjgXLot6oftypbBcLdYX1R08lhiDT+JIYxQmu55lPFPO5I2rFW4gYVvhRm/O3vRZfEx8lJgfI/mDBUBj6yVUAQ2f7sYMlHonL33y2ETt5U55qOYzod5s5hwkTo+egLbfiPnoQSpnN24BuXWQQJMXzdQ5NyD9Dx2XB9TZhn6kP9qssH8luVh1zGcMphAU6eIma+M4Q5IZuoo1YVD3a1Ga17j+tl8lep/Uzq+sWBEljWChSwWP3EN2mtfPJTKog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA0PR11MB7749.namprd11.prod.outlook.com (2603:10b6:208:442::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.17; Thu, 14 Aug
 2025 16:14:57 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9031.014; Thu, 14 Aug 2025
 16:14:57 +0000
Message-ID: <a440bbf2-d256-44b3-924a-a83c255fdf02@intel.com>
Date: Thu, 14 Aug 2025 09:14:55 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 00/32] x86,fs/resctrl telemetry monitoring
To: "Luck, Tony" <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>,
	"Wieczor-Retman, Maciej" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, "Chen, Yu C" <yu.c.chen@intel.com>
CC: "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
References: <20250811181709.6241-1-tony.luck@intel.com>
 <7c2a1c79-7ebe-48da-ad39-11bd3cc7e6ac@intel.com>
 <SJ1PR11MB608356DE7D16654F7674240CFC35A@SJ1PR11MB6083.namprd11.prod.outlook.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <SJ1PR11MB608356DE7D16654F7674240CFC35A@SJ1PR11MB6083.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0278.namprd03.prod.outlook.com
 (2603:10b6:303:b5::13) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA0PR11MB7749:EE_
X-MS-Office365-Filtering-Correlation-Id: 79085313-0ada-4882-e453-08dddb4db670
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?NnRScTJlRG11dmNhOEpxWXNaODYrQys1WWxoMlBnM1NObVBoTFRKaEFYTEVH?=
 =?utf-8?B?eUhTRHVWdWdIQlpaeDM3cmlONFNFNG5OMmdmWWxuc3NlWHdiRDhMQjhqMzRl?=
 =?utf-8?B?ckhjY2ZYQ3NpNXlDOTBaL012NEREYVhSa2IvL1VRSGtkdkJlWWNBMy9pVGtX?=
 =?utf-8?B?VkF2OTBSRkNLaXpSRTFYSGxRNHo5L0t3aUNGQU5SZUg5Zk1CTjRaTDlRQkc3?=
 =?utf-8?B?d3daVWxOMkZmMDUwYU9adGJOWDBkK0FQUEFDR1RkLzMzbTJvUlZSaTR1YlIy?=
 =?utf-8?B?QWNwQVNzUktSZ0M4WHNUSzVKYmxWNVpXVjl1RVY4NXl1V0Y5aHg5cDhiL3JW?=
 =?utf-8?B?SnIxU3hLeGozS0IxNmhUVytXa0hmNHNsdHBYSFFCbVMwUk5MWGQvZTB6ZDhr?=
 =?utf-8?B?ZjFMVkJsZTlmQ3lWMWVvOEE4SFJDS016bmUvcVRUeU95Zy9oTG1rbDhMeVps?=
 =?utf-8?B?aHpJMmI2Riswd2FRSVlqM1VVcnFxZ3o0YVhRVWRGRjJrMDFIeTFhcTkrTmdz?=
 =?utf-8?B?NXh5cElRdHRPMWFhTzdqNDY4VjIvbUI0aDRDVzI3MkVDWDArNkJsczF5UDJX?=
 =?utf-8?B?RFVTd2QyUnJSakxlbUgwK2YxSjN5T1FmQU1VUGdZeWZ6M3dCWEU4VUtPMjVq?=
 =?utf-8?B?bGJMQzVDZktnSXgwaXdqTXAyRjg3M1VKL28rQUJWOFJaT0xlV0YrT2lPR0pn?=
 =?utf-8?B?YmFpeWVDeTFJQUZPbHNVRkRVYkFBYjZtbWszd2xiaktQTmZhRWNuWFBrMU5M?=
 =?utf-8?B?VVpCZ2tIclNQdkZGRTFpRlNjUmZHZVpDcUUzcVVUc1p5TGM5MGQxYWNpUGty?=
 =?utf-8?B?aWJ5Mk03N3JoM1ZXYVdRYlBPanBkaEFyYmlsRjM1eEVoY3o3Yjd6dGFTaU1n?=
 =?utf-8?B?elJRNWRPVlZjRGNhQ05XekMrTlEwY09GOXpTUi9yZlFkbXVvK0F5NTlybEEy?=
 =?utf-8?B?czhTTk5GbVlFR0h5aENPa0FZbnU3RWlJYm9OTEpwSFVZZTVWNG9sSTR4QmpU?=
 =?utf-8?B?SXozSElmajhmZGwrRThsYjU2TExiOUxRMjYxZGdhR0R0YjNET2NyVXQwaGpV?=
 =?utf-8?B?M1pUeU9ndXFMMEdvTmVNNEFvK24vTkxzNXJ4Q1h4Ri9wR0pnQW55M1NTU24w?=
 =?utf-8?B?d3JwTm9IUFlrZTZjbnZsWHpwM1g0RnhlejVBZkN6d293bmQzUHZGWi9GVDR5?=
 =?utf-8?B?TVBEd28rT2xjd2lHMk9TYXNWYXQvWkpCVFRsZmE5N1orVHpmZ0dnV2t3ZUxX?=
 =?utf-8?B?cjJnbm43ZE85U3Q5Zytiem44RXpJTkRDbmx5NkNpMW41bW8wTDJ0d1lDTVdq?=
 =?utf-8?B?V2lxN2hzRDVwS3I0WE5BODJkNUU3Uk9wd1k1TllTZUpjQ2VBOFhaOVljY25p?=
 =?utf-8?B?WlJYNlN5bUhoNnNpSUNjL1N5VUlJdVB2WWcwVnRPZTkyY3ZaemtZWHBmSUU1?=
 =?utf-8?B?ZFpETGdYd0lXSFh1YlNrelI2V3c5RFNoc2lDbXIrQTlCN3A3OExKU2tvbzJZ?=
 =?utf-8?B?S1IvMm40MG4wcCswZVpGVDNCTExmbXh1MC9ZYnJKUW51LzY3VFpKdWdXUzRn?=
 =?utf-8?B?WHpKb2JQQ3VxLzM0NDVnNythOGtDNG9RTXh0bVdlMHFuOUpUaWVEcTJtKzhv?=
 =?utf-8?B?QldYSTVyQ2ZhQXRHKzRvbGorSzN2aE54c1B3LzJzTjd4bzFjSkRSbUZQS016?=
 =?utf-8?B?TUhJdWhMNU8vS2JTd01XdS9qNDZ4ZXU0eVJHbzFmbVJHWnVDSm50aXVvNHdD?=
 =?utf-8?B?dytUSElwcWFIbUpDNDV1RXRLOWpjYlVrMDdhQTBCeTlGUW8wd3VkMk5JcWZs?=
 =?utf-8?B?QlpoQUZzVDdEeGp0QXZJVGdIdHM2YTJvbFFIYVVocURDRnpGUFgvQ0wwcUFs?=
 =?utf-8?B?eGk4RjNsbS9JS3VsekpiUGNpS09tbnl4K0psZ1hjaW1TdFNNa29ZN1lUakxV?=
 =?utf-8?B?V2JQeHJUMmRZN0JkUnlETDJQbi94QW11Vzk4Sy96Sm01NnlZbk5nZGFONkc0?=
 =?utf-8?B?dlA5UzNNeURRPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dW1WSjZPZ1licEt1cVhJc3N0ekdnS1hQZjkvbVVJb3NobkltTTI0OGJ0Y212?=
 =?utf-8?B?cjQ3VTlaNnBpTnpBUkFUU24vMWZmQ2JBSVZSTE5HS1FidHRXYlgrcERSU1Y4?=
 =?utf-8?B?anNBdHY0cWZrVlAzbG92Q0dBUzNPNHdqY0FTdHJXaHBEbGJRaW1qNEdkMmRS?=
 =?utf-8?B?b3BOZnhSNnpKeVdReS9yRGtCWWg5WVhORlFWeFRXbnJEWDY3THV5aldqVDda?=
 =?utf-8?B?OTg2WHdnSjlEK08wVXgrRC95UEFvL3lZVjNhT2pNcXdxRGliR081QS9UbjRn?=
 =?utf-8?B?Vko2QjNJUGpmQTIyMnRlSFVnWnowYXZsb0Z1ZThTTFdwb1YxQmZaR1luYUVl?=
 =?utf-8?B?eXMxcmxWbjlGYk5Mem9LVytlRzJUNlJiYWwyN3dWTnNsTmhCcTAza3BaVTZh?=
 =?utf-8?B?S1ZjcUw2VjVzM05mb1Q1U3ZBcGQwVmFJZGdtMWhsMStCNE9xRmd3NjhzdEt2?=
 =?utf-8?B?bWk1U1pweDdzTUhKcmdHR1VhZyt1OGxHWTRTbnpMcGF0cXgrclhHbFNHTUdN?=
 =?utf-8?B?OE93Vk9RaHBOcGxPWFlITEc5Y1JFYXV6NXdwN1lieWE5WUJBWk9nNWhIeVpO?=
 =?utf-8?B?R2Q5L2xhTEFsaFY0emlOYUNMbzIwamlrZWVWYjZ1RzNncG1jZnZ2K3ZKMDE2?=
 =?utf-8?B?NTEyaXFsVW01ZEdLTEJFN0ZUVnYzOUdFbWREV2xuaTE5OVBzL2hpQy9XZ0lX?=
 =?utf-8?B?Nk1uKzl6QVhIbVprNytROXZ0NlJVb3EyN0ZUa1ZIaldkWGNUOFFKVGw1MS9k?=
 =?utf-8?B?elRUSmNIMGNaRkpYMHZPWXJURlVlYVlvSjFKMFF1QUEwSEVlM0QzMDV1bWlW?=
 =?utf-8?B?MmhOV0I2TndaTUJ1b3BVRlJuWWpPb29oc290RFJUUFUxczJVR0YzOXdMRUsz?=
 =?utf-8?B?OTNtWk8xU2p1b0xiWW44a2hZaGJDbEREZUpkT1duMjcwb2I3MjRPT1JqeGhZ?=
 =?utf-8?B?SXdWM3BQdWpJcWJvZGQ5UTgwdFVnc3VFTCsxZnIyYTY0MnF0S3l1b056T2hq?=
 =?utf-8?B?eklrd1dDbjlzMHNIakluN2VDM3NKand1ZkJmWWU3MDhBeStNV2p4bjdzZElC?=
 =?utf-8?B?TG1ITHQ1OE5kRVV3QlpTUUtnZHlsMkFQOXBPWVgwM0loRUZidDlGKzRFTkJL?=
 =?utf-8?B?c0RVbm4yNkdOdGMrVi9qTkw3ZHJ0RWRYOG5JSkt6Qm5QemdUcU5panlzQ2hY?=
 =?utf-8?B?YjNpelVMcE1DWnBnZGZFRHlsQ2hkWHNXbXk3YjRnaCtKbWRRQU5CYnNMQVY0?=
 =?utf-8?B?Vkd1SlcxWWVHeUcrSXNzbzhQQWZnVmZpSEY2VzY5MTdhcHdmcmlBckZGM0g2?=
 =?utf-8?B?bTkrS1l6WkNETGZKOG9jdFNuK0NNL1B1SnJyNzA0UkkzMGRjUUtWL3lYRGpx?=
 =?utf-8?B?b0NaMkFJQzdtU3JpTjZxWTNHVnJ0WERVSTdnRHF1RFRIWHlVRldGTEVxejNZ?=
 =?utf-8?B?eDRLQmhwYmdQbk9oZnRHd2lLbTVZSkNnNkdRa2tlYkdEOXZVd2hQTWZtT1gz?=
 =?utf-8?B?ZFRVVitpNUhIcFc2WDRXazVMcEpLVVpiZkV6WnV3T2tBcGkzMitML2xqY2oz?=
 =?utf-8?B?ZHNrL0dKUUFLWSs1R0NvS3VEVjdoUWgyRFJuaG9aSmxwdGlJc2dWeVArcmg0?=
 =?utf-8?B?L2VoT0NFTFRIc0VmQkY5YmJ0R1pKekNtYStMc3R1N1dOZTZiLytjQjdwdlh4?=
 =?utf-8?B?d0tVQmhxb2lnYXRNUWZTVnRjTmdPQVZmdG9RZGtPd0I1ZFRENEx0ZWhUdWIw?=
 =?utf-8?B?UnlsSFFoNEtBUWp4QWtTUkUzajlyTXNOdTVoVG1EZTRjV3RYQjZlNTlIdGoy?=
 =?utf-8?B?TC81NVZtVEN1S2JxMXZDWjRrdEtZT1JoRk56aUdJV0o4Z2xVWnVYVzc1LzE2?=
 =?utf-8?B?Si9GSCtwWnU3cVJtdHVqNDFEVmlTZXdGOStYMGVmaXZUVFQvZ09FRHFXa1V2?=
 =?utf-8?B?NEVBc0dNTU9mSFZMcXhyQ1VQckFsOFpLV3BuUlN1aW9ya3V1WkJ5bmFDNkRT?=
 =?utf-8?B?TWZ5RGFIZWQrdVkwc20vQUVpaDlRd2NXZ3hUa0NMSG5lRzF0Nk1XYzhpY0U3?=
 =?utf-8?B?SGU3V3FGcC8wT3A0V0xab2NzYXR6UWJQeDkzUDlCR2ZMTWJxdHV0dUhIRFQw?=
 =?utf-8?B?UCtsampNTWdaclRlOXZXNGYxL0xxdGx4QzcxWHN4T25PdFlSZFBtUUlWdGVs?=
 =?utf-8?B?N3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 79085313-0ada-4882-e453-08dddb4db670
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 16:14:57.7640
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tp/9ei5jqRL2YN4clPgfEGa2oNnfGNjfQqpWNM5sDm5A9cHin+e/g85ZUz7z582puRT/MNaQC+3DfVzkVUXSOG3apWwhuULHd+ME+ThKjmg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7749
X-OriginatorOrg: intel.com

Hi Tony,

On 8/14/25 8:44 AM, Luck, Tony wrote:
>>> The INTEL_PMT_DISCOVERY driver provides intel_pmt_get_regions_by_feature()
>>
>> INTEL_PMT_DISCOVERY -> INTEL_PMT_TELEMETRY ?
> 
> Reinette,
> 
> Perhaps.  The discovery driver is somewhat it's own thing:
> 
> drivers/platform/x86/intel/pmt/Makefile:obj-$(CONFIG_INTEL_PMT_DISCOVERY)       += pmt_discovery.o
> 
> But it is automatically pulled in if you enable INTEL_PMT_TELEMETRY:
> 
> drivers/platform/x86/intel/pmt/Kconfig-config INTEL_PMT_TELEMETRY
> drivers/platform/x86/intel/pmt/Kconfig- tristate "Intel Platform Monitoring Technology (PMT) Telemetry driver"
> drivers/platform/x86/intel/pmt/Kconfig- depends on INTEL_VSEC
> drivers/platform/x86/intel/pmt/Kconfig: select INTEL_PMT_DISCOVERY

The sentence reads:
"The INTEL_PMT_DISCOVERY driver provides intel_pmt_get_regions_by_feature()"

Looking at code:
intel_pmt_get_regions_by_feature() is implemented in:
	drivers/platform/x86/intel/pmt/telemetry.c

Looking at Makefile (drivers/platform/x86/intel/pmt/Makefile):
obj-$(CONFIG_INTEL_PMT_TELEMETRY)	+= pmt_telemetry.o
pmt_telemetry-y				:= telemetry.o

Since intel_pmt_get_regions_by_feature() is in file associated with
INTEL_PMT_TELEMETRY I believe it is more accurate to say:

"The INTEL_PMT_TELEMETRY driver provides intel_pmt_get_regions_by_feature()"

I do not see INTEL_PMT_DISCOVERY depend on INTEL_PMT_TELEMETRY so
having a kernel built with just INTEL_PMT_DISCOVERY will not
include intel_pmt_get_regions_by_feature() so I do not believe 
"The INTEL_PMT_DISCOVERY driver provides intel_pmt_get_regions_by_feature()" 
is accurate.

Reinette

