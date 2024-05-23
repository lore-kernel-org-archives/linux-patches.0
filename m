Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DF676E60F
	for <patches@lists.linux.dev>; Thu, 23 May 2024 17:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716483823; cv=fail; b=nDa8A6lAZBgcmwD3/fX7GMYtbyZ8xQhfIVV/8axLQUv619sGuJGMTnojzfACeC1GIngAz8YoKi70M8DrEEqnOhbnIuvMr8xnbdDSiG3URMXcUCvQUqsLR/n5FyKqqRvtsd+JVITVW2BqkvsppPCBAXbnUZ5HTOibfCbMPcSpTPE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716483823; c=relaxed/simple;
	bh=yuw8VJWp6wlnmhZ6iSi6FXyXNlJjlobiTa3eI5vYkDk=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=PnetDF8zsIBLIkEw/mOARTDmYv9/0e4qEpEbAVvyOV087/RPTeTXiIvI2wpe3Jgfhkdt5QGyDhdkB55z6hWabYTysWTcsDpWJN2sOyJ0ixoGu6USjBF4ookkml0C+B98/RU+Eyqx42Ybz+tnYPNWBGU0CwEIctACaOkzAZ8E5TQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YtSUFbD0; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YtSUFbD0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716483821; x=1748019821;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=yuw8VJWp6wlnmhZ6iSi6FXyXNlJjlobiTa3eI5vYkDk=;
  b=YtSUFbD0pX0yW7HXUkh6TAF7j4nZVTaMe8IGNLtb8UfPVriSWnyk8P7m
   161KzKMdrt4t1TWJXHQWB6DC4IfpRT24AIMCsaiuSRx8j8E9FA3tM6Rla
   oSRhiGdMFkXbT8VofGSw3V2HM+xZeKSCUdpZ1Kp7Us+68a49tMOuvpe6p
   Jwga1bZR9bGZEMU6pkpbt2gYSPlyOMgae2nOKFoa3/v2VGAA+VzOSKee5
   /RDnnqaYasGgkXPnfXaI8weUb8YMo3bPWvwDPz2e1jQ6cXtVT8OdNxsGJ
   xgaBeAYz0AsTs18acDtLC5E0hW6aU0xudRlYtYACuTgwmuj3uLXvf3Oqa
   g==;
X-CSE-ConnectionGUID: IDCEFgX4SSqI6JUo/BS5hg==
X-CSE-MsgGUID: OOma4VjCTDW9iljWF8LlHQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11081"; a="30351442"
X-IronPort-AV: E=Sophos;i="6.08,183,1712646000"; 
   d="scan'208";a="30351442"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2024 10:03:40 -0700
X-CSE-ConnectionGUID: /Vm8x1MkTVmtpIyf6UCw5w==
X-CSE-MsgGUID: Qi/UOceWT96Ka+TLonzdXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,183,1712646000"; 
   d="scan'208";a="33863410"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 23 May 2024 10:03:35 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 23 May 2024 10:03:35 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 23 May 2024 10:03:35 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.41) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 23 May 2024 10:03:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aGOS/pP+obfZrY0Kl5fz56FTJYQycKdJ6P9BpPX3fqft7cyy1vDmDpFuJNWRlaHE8+Ef3qE01mDNGY9LTU0fAzx8yBbaEGIIuDlz+tgT9Yx/wLRc7jJAJH3VDcZb+fIuLBTUKcP+nlcByH8TZ0KNpPd4mlR9//RVVVOpI56E7AR2j1+FSjCv6RiF4T00jlKAX62+wopJ+eeseG7b7d/9Zh9GyAJQz9uGEOMYfNP1ZJfUoHbEy/fDfJ/UbohF0fplRRpqB6YL5egqJTJVkqpOIDkD79aXCi2GNhkhq6pGtllr6uUD6pW71RcIN6iyrfklisOwm9enMxoWBrdf3Vr97A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IDcmmKJa9yxUTsB8hAS+VdRFpRDBtg0kLJii/gwWSQ4=;
 b=CVkHNNiSRIqVqzNOUFWvNGqIASo8WY0kscNwkRjxaHKpmPQIT5zuRP6bl1NxYa8IXrl+IyaSHro78htH3SX7YxdRx1mRHCBeTshTuKMGNktY84K1sYIy00J8QuwUiks4Fuz3i6H3lC/XDC8B15HHGvbAsV1kzERYYgGEBVrI9goNF24xdLKW+08sSC8wtyb9QqBN/tA9j+BR1/WaH3ni8pbqwpGECWntl4k1tVoya5anN26e4ANErTZ3SmfO530gD8TYao/YX0/r3rNzGXzyt5EkYMmrS4mhkHgvEU6fd4Z7+cAKmXq5jifWtfSpxhbfcnnE+R7uBK/t0nauxUX0AA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ0PR11MB4975.namprd11.prod.outlook.com (2603:10b6:a03:2d0::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.35; Thu, 23 May
 2024 17:03:32 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7611.016; Thu, 23 May 2024
 17:03:32 +0000
Message-ID: <2a7cc72a-99fb-4862-b7eb-da3d515f0453@intel.com>
Date: Thu, 23 May 2024 10:03:29 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 15/17] x86/resctrl: Fix RMID reading sanity check for
 Sub-NUMA (SNC) mode
To: Tony Luck <tony.luck@intel.com>
CC: Fenghua Yu <fenghua.yu@intel.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>,
	<x86@kernel.org>, <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20240515222326.74166-1-tony.luck@intel.com>
 <20240515222326.74166-16-tony.luck@intel.com>
 <61e89a48-d1f4-49f2-8893-950e7e6ba7fe@intel.com>
 <Zk6EC12hC0wzPiIu@agluck-desk3.sc.intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <Zk6EC12hC0wzPiIu@agluck-desk3.sc.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P220CA0025.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:303:115::30) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ0PR11MB4975:EE_
X-MS-Office365-Filtering-Correlation-Id: 459d6e27-d8cd-41bf-1af6-08dc7b4a4688
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|376005;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Rk03eVBlbDM5RE1QWjFsRUhmRUNTRzEzTGNGU0VaYjk4NGNTRU9CbXVGeU9v?=
 =?utf-8?B?SlZkOVpsRllQc0RwY3NVK3hYSlNtU0x3WFVzT2dMaTVDclgrZ0NqWHBTdDd6?=
 =?utf-8?B?RUtCNC9vTFNDY0dUYk90VWM5R0JsNGs3RERwNFVxbTZIakNKQkNMcXpWK3VQ?=
 =?utf-8?B?TDl3cVNIWVhVK2VzMVh6RC9wSGZVS29jcXNUQ2I2ZUwrclEzY0JrcUNCYkpZ?=
 =?utf-8?B?eDdpVjR5QTNWRFBvQm9MOVVqdHhuVkpiK2RTRzRjdDBWcjFQK3k3eHh6T3JU?=
 =?utf-8?B?TFkvSDl4WlJoK1RJSFZvVjNRNUVkL3Y2M0dRa0hGVzRZVnRqVFU4NUxQc1Qx?=
 =?utf-8?B?YStZV1U3aW0rSlBSeCtFSXNUQzJWN0pYNUYxVXZaWmJEK05ZNng2bkpsTDVB?=
 =?utf-8?B?SnBFM2c0Mzc1VE5SM08rVmd0TFdhK1RWTTJUdWdvd1BGUHZGblZZMFBxcExK?=
 =?utf-8?B?Z01mak5mWVdHVkVhS1FUQ3h6OGJTanpOaFpRWTVVZ0xSaGNQa1hvcEZJdEhS?=
 =?utf-8?B?UXJzUW5CcGJuZ1dCU3pMWTB6eHM4bWlCNnBSd3F6dlhUdUlqZHZNRjhuWDVN?=
 =?utf-8?B?SDJ6WHNPbEJ5MERUQTBuOTBjMlZTMzJ1a202cnpvOHIvTGIrSVBOZzdSYWJu?=
 =?utf-8?B?Ynp3NzZMSjBKamlCekpmNzlscCtkQjM3K3NmZSt3UUE1TXEvSzk2aWJHVWJ4?=
 =?utf-8?B?bHFaQUVqeU1ueW0yL05JbXlwR2VmcUJoRUp6REs1Mnpwanpqc3Q2amR5RWdq?=
 =?utf-8?B?RlBxT2dsMUNmWHUzbzQ3bTN3L2IxNDJFTWI5WmVsV1lDc2JzdnU0eVdsUU1Q?=
 =?utf-8?B?NjlLZVNqOFRxaUpPQytpdDc3bmlkbng1U21XbHpPM2R3MXpoK2RrelUwSitN?=
 =?utf-8?B?RGZxQ2l0WmVadkdpMldkVHo3M291YkpuRG5YYWNHeW9wOFNJamt1TlN6NVBN?=
 =?utf-8?B?emtxYVd2eHFFM09PZHNlcVJiNnZLMm1RRUN1eHEzbjdiM2pPZEhrNk1qMENU?=
 =?utf-8?B?Q25SSzljaGJWUVpFTXpYaWpvSk9mdk96VzBHbkVwdTRVZzhDcGIvWFU0aEww?=
 =?utf-8?B?bWp5NFVTTE02OXFGcHlkM1FFMTV5VUdqNG9rWDVuVWZCVnpIR250Y245NWN2?=
 =?utf-8?B?N1JFMXg0WVlvUnBBTTNaZUdjemRIS3c5NlAvdHV1VDZ1OTAycU9MTlR2dWtC?=
 =?utf-8?B?L1J4Z2pmMnNGbSt1WENjS0hiUEdwMHNKRng1SVJXbDRucUlybHlQOVc4QWZz?=
 =?utf-8?B?ZkhBUnpsQ3ZJYi9COHcwcnpjQlhoN2JmaUFobWlrVXdlT2ZMNTFYNUR5ZWhl?=
 =?utf-8?B?UDZBSEs0NFBFampSWGsvWU9OVXNXTi8yc1ZpakJsSG4xSzFGMUZZZ1ZUK1U2?=
 =?utf-8?B?U2FZcjIxRmY3cFVzbXBLQkRVUitGbm93bWhTKzIxYm1MYlc3TWJMQUxJRDJu?=
 =?utf-8?B?cXBaQmNkVzhTSXRnd1lVaXVzR0ZTYk9wK3hCZmk5WGw0TjZ1WXoxYUFxQ0tV?=
 =?utf-8?B?ZlVvZVNrbGNXSW51bm1PSC9RRkhER1dtYlUzd0Q3RDhicWhhcHdDWDZYTGp3?=
 =?utf-8?B?QzU5WUlLRWhjM3hUVVpBSWZ2a25DdUhkNVRKdTFkT0VQSHFFaHRPZmRxSVFJ?=
 =?utf-8?B?NnVmbWtOaS9UMWVFZHE1WVJYV0JVRW8wTU1MMUpFZitHVzFmVVgvL2xRRXhv?=
 =?utf-8?B?VUt3UXVsWmZYamlHclRzcjhJV1p3NDZ5ZUJVUGRrV0dob2RXR0xHTDlBPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aDFrUVp4VkxOdlk4MVNvZ1BjZ2tmblZ3OW8rYmxFanozTGtZdVhJKzhCWUdo?=
 =?utf-8?B?MmlteEN0WVFyb1Fkc3NUWThZL3BGMG4vQUJ3bWxMK2o4QzlDeGlWRll6dG1p?=
 =?utf-8?B?am8ybVc5MzU2M2pzaENEM1pqSXZPREtSbXZjZlIwRWdCSkFZdlZrTkowZFBp?=
 =?utf-8?B?eWpRcFMxTmQzV1dSZ3Z2N2J2dnE2eFF4c1R3S2NVY0JKY0VnRmhGRHZ4TU9G?=
 =?utf-8?B?ang3dkl0bE1QaUxXQnZ2Q3pmMjVnL29yYm9rbGh1YUgrWmJiM09HbGVla1E2?=
 =?utf-8?B?NUhKYThQTXEya0N3UStrSnZqY05qOWlSTEwrVE1JVGYwUjBGdno0clNJUmxI?=
 =?utf-8?B?TUt5U3RDeUhVWmo0WExKOENkbGdacWVUekQvbTFSVVl3UjFXTE01NnRuMTVB?=
 =?utf-8?B?ZWxYdi9iLzdUZHNPNVRCeER5WlZ1cWxzSlpwWnora0xRNHdKOTdpZldEMy9W?=
 =?utf-8?B?d3pRZ212YU5PZDNKeXVIMTRHd3BkcnFhNnlvVG1xYWlhRUs5M2xXZTRnQ1hw?=
 =?utf-8?B?Y3IrT3d6R0RMUmtBUEl1WWxxdy9ZKzI4NUUzb0pKLzlIMVhNbEliekNjVHo0?=
 =?utf-8?B?dHhIbk84TFpBMmpTYkNMeG5OenBZeWdWMXdUVGdzK2JRK3c3T1JRY2JZZm9s?=
 =?utf-8?B?WkhqU1ZpZFFmUWtodmUrWlYyOWdRbUZSWXBIelZzWFluRXdpT1UrK3dqV08r?=
 =?utf-8?B?Q1A3d29mQXdBck9mNnIwTlZKd1YvRUcxQTZDZ1BmYXhrVWxFR2FkazRLTVJ3?=
 =?utf-8?B?bnhkSG9jTXpwT1hLbzAxUW44VmtzaTRickxBdm01ZlZtcFBrdzJpWmZKMHhi?=
 =?utf-8?B?SmZQVGNpZkdhbEpqaEhLUWJMVUdXSzFPVnhPQmZTejFEWkJUdGtWckVkc2V6?=
 =?utf-8?B?eGtnRFV4RkxTOXNIblBmSVdtcUwxTm5USTlkSlNydlhkSTdPS3lWMW5PRDJw?=
 =?utf-8?B?anRLZjA0TmQ2dC9vcUhYNHJLK0dOS2Q3L1lSbmJTRUNiR2JhNWFqTEVxU2xO?=
 =?utf-8?B?cDF5ZlRobkFkc25ZZnBqa05OcFlvNzN4V0hhQ3ZqeFJhOEx0d0pDVThHVW9U?=
 =?utf-8?B?Z0VpRmQ3UTJwM2ZXQkI4Z3ZIMU5BMndJelVxMnZYaUpYUlJ4ZnIrd2dpak4x?=
 =?utf-8?B?ZzZ0NCt3TDl4NWdEV2EzSDdMN2xPQzUzN0U5YXZDc0ZNYVNpVkNvb2ttcTJ6?=
 =?utf-8?B?VGpYZ2xtTkNEenF3b1dySm14bkdveUp2RTk3TDNETEUzRUVxbVllQ1poOWdT?=
 =?utf-8?B?WHlMYTJrQ0JMRkM3ODlrc0ZGZWJWcnk5ZWFwRXh4YldUaGhDSStwT1pDeUNj?=
 =?utf-8?B?cFV4SU04RDFJM0tMd0d5QmIveVhKRWJYbDJIbjBQR0xWUXBHV1NKU2l4VnU2?=
 =?utf-8?B?M1FmeHZnRFgzQ2RDcnRscmVRNzdNb0pQS2lxV0VzcVM5VG5LTUtmdThjczM3?=
 =?utf-8?B?UGY2YVVYZ2k0ZGdMWnNuSGlIdDhvUHp1amdNa3htZWREM0xiTW5xSjBncnJ0?=
 =?utf-8?B?cVQ5T1U5RWdQV2l5NlNsL1hzY3dab0ZiRklwSUFudjNaa3hONW5hVVhOT2pK?=
 =?utf-8?B?Tlp0V1cxb3BiSmtGWlp6OS96dy9WQ2YwMjc5cEpFckJhV1ZVeE1nNGdOZ0FO?=
 =?utf-8?B?eWF0MkFoNUtLRGxDRmVWQlpDRlJ6aFpOOU9kMnZNUGhScUR2ZmZqK1N6Vi9T?=
 =?utf-8?B?YjFmTzJEczRaMzlod2Yrb1ZNaUpvUTQreXRPMEJySEx5Ym90S0FldHVmWGFh?=
 =?utf-8?B?TXArcTIyMk1wekYweDMyNEFNYkVEQU5BcmlyVGdKWDlaMklWcEQzSUNUQ3BE?=
 =?utf-8?B?bHpnS1czWjE3cm5oamdYM3dDOFlxSUxkdSsvZUg5RUQ1dHRPOXJ3TjJ4M2Rl?=
 =?utf-8?B?VzRQN2Y1ZlQ5NUxwY0pQamNKeURHQ1RmNkdZVC9IYWNqaVdIT3pOWE5aWVdU?=
 =?utf-8?B?UU1HYndhY3QvQWwzeDVaMUxpcTVwZWlJRGdISDM4aTdrNys1Q1FXeTR6RjNh?=
 =?utf-8?B?VjR0UjQzOGMycUVpb01Sa2MyMEhWK09uNWZGcHRXbk5jUWU5R1ZJUVNpQTFx?=
 =?utf-8?B?VFZ6NHpIOGh0QjZGZ1VGZ0o4aWdVNXAxTkNxVEdmVHRlRUxIcXN3VlBoTmxQ?=
 =?utf-8?B?YWRHa3hBTEF5aWttODQ2aC9YOUFmZ2xxMHBoU09sSitSUldPQzJwTXliQmta?=
 =?utf-8?B?M0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 459d6e27-d8cd-41bf-1af6-08dc7b4a4688
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2024 17:03:32.2407
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BkfKfYpb3Bb9csSVS8O1oNuutukmaSn3y4/7Ubq5C0qC0mXjcl3fN4iykPH/YCoSHYIdvq4xchVKk2uHoAnpcc5HvruD4Nmshl4ny7e3QIg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4975
X-OriginatorOrg: intel.com

Hi Tony,

On 5/22/24 4:47 PM, Tony Luck wrote:
> On Wed, May 22, 2024 at 02:25:23PM -0700, Reinette Chatre wrote:
>>> +		/*
>>> +		 * SNC: OK to read events on any CPU sharing same L3
>>> +		 * cache instance.
>>> +		 */
>>> +		if (d->display_id != get_cpu_cacheinfo_id(smp_processor_id(),
>>> +							  r->mon_display_scope))
>>
>> By hardcoding that mon_display_scope is a cache instead of using get_domain_id_from_scope()
>> it seems that all pretending about being generic has just been abandoned at this point.
> 
> Yes. It now seems like a futile quest to make this look
> like something generic.  All this code is operating on the

I did not see the generic solution as not being possible. The 
implementation seemed generally ok to me when thinking of it as a 
generic solution with implementation that has the optimization of not 
sending IPIs unnecessarily since the only user is SNC.

> rdt_resources_all[RDT_RESOURCE_L3] resource (which by its very name is

Yes, good point.

> "L3" scoped). In the SNC case the L3 has been divided (in some senses,
> but not all) into nodes.
> 
> Given that pretending isn't working ... just be explicit?
> 
> Some "thinking aloud" follows ...

Sure, will consider with you ...

> 
> struct rdt_resource:
>      In order to track monitor events, resctrl must build a domain list based
>      on the smallest measurement scope. So with SNC enabled, that is the
>      node. With it disabled it is L3 cache scope (which on existing systems
>      is the same as node scope).
> 
>      Maybe keep .mon_scope with the existing name, but define it to be the
>      minimum measurement scope and use it to build domains. So it
>      defaults to RESCTRL_L3_CACHE but SNC detection will rewrite it to
>      RESCTRL_L3_NODE.

Above has been agreed on for a while now, no? The only change is that 
the name of the new scope will change from RESCTRL_NODE to RESCTRL_L3_NODE?

> 
>      Drop the .mon_display_scope field. By definition it must always have
>      the value RESCTRL_L3_CACHE. So replace checks that compare values
>      rdt_resources_all[RDT_RESOURCE_L3] of .mon_scope & .mon_display_scope
>      with:
> 
>      	if (r->mon_scope != RESCTRL_L3_CACHE)
>      		// SNC stuff
>      	else
>      		// regular stuff

This seems reasonable considering what you reminded about earlier that
all things monitoring is hardcoded to RDT_RESOURCE_L3. Perhaps that test
can be a macro with an elaborate comment describing the SNC view of the 
world? I also think that a specific test may be easier to understand
("if (r->mon_scope == RESCTRL_L3_NODE) /* SNC */") since that makes it 
easier to follow code to figure out where RESCTRL_L3_NODE is assigned as 
opposed to trying to find flows where mon_scope is _not_ RESCTRL_L3_CACHE.


> struct rdt_mon_domain:
>      In the rdt_mon_domain rename the display_id field with the more
>      honest name "l3_cache_id".  In addition save a pointer to the
>      .shared_cpu_map of the L3 cache. When SNC is off, this will be the

Sounds good. If already saving a pointer, could that be simplified, 
while also making code easier to understand, with a pointer to the 
cache's struct cacheinfo instead? That will give access to cache ID as 
well as shared_cpu_map.

>      same as the d->hdr.cpu_mask for the domain. For SNC on it will be
>      a superset (encompassing all the bits from cpu_masks in all domains
>      that share an L3 instance).

May need to take care when considering scenarios where CPUs can be 
offlined. For example, when SNC is enabled and all CPUs associated with 
all but one NUMA domain are disabled then the final remaining monitoring 
domain may have the same CPU mask as the L3 cache even though SNC is 
enabled?

>      Where SNC specifc code is required, the check becomes:
> 
>      	if (d->hdr.id != d->l3_cache_id)
> 		// SNC stuff
> 	else
> 		// regular stuff

I am not sure about these tests and will need more context on where they 
will be used. For example, when SNC is enabled then NUMA node #0 belongs 
to cache ID #0 then the test would not capture that SNC is enabled for
monitoring domain #0?

>      The l3_cache_id can be used in mkdir code to make the mon_L3_XX
>      directories. The L3 .shared_cpu_map in picking a CPU to read
>      the counters for the "sum" files. l3_cache_id also indicates
>      which domains should be summed.

Using the L3 .shared_cpu_map to pick CPU sounds good. It really makes
it obvious what is going on.

> Does this look like a useful direction to pursue?

As I understand it will make the code obviously specific to SNC but not 
change the flow of implementation in this series. I do continue to 
believe that many of the flows to support SNC are not intuitive (to me) 
so I would like to keep my request that the SNC portions have clear 
comments to explain why it does the things it does and not just leave 
the reader with impression of "if (SNC specific check) /* quirks */ ".
This will help future changes to these areas.

Reinette
