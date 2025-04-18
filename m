Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0329843AA9
	for <patches@lists.linux.dev>; Fri, 18 Apr 2025 23:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745017896; cv=fail; b=IQC5L4I/z0wf8C8NKoJ69e56H7nwpMiM1LCkFgRnjboD/TxF96fhhkgXRtsT8Eb5BEnLV1E1b71x5mWw4fvzCawqDNzB+z0mk/XUgY907267lFQRbwiJjB1g86vbnc9rl9okuh3q8GZKAEaga3FIizaFhiqhMt0MEAVqc5KgDZw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745017896; c=relaxed/simple;
	bh=3/LatalPRJxf8IPK5Db1w+Pk3rrLABdxA3KyGWlKeLs=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Rr9qbZjWWPuOzvmfNUhfx4u6oqr8dZL88zBaoZk6tGSwNYXnZDBBuyW/Piji2WdLLcZC0kk/Zhx16zhavgAAb+X/5FIBWOpb8JYVUKWzlfwzYsw10YXHcoKcav/4FDa0jBDjXz5+bQTcBQTEugSYC1r3p7N2Yvh720YbennClPs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GGxfv7bp; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GGxfv7bp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745017895; x=1776553895;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3/LatalPRJxf8IPK5Db1w+Pk3rrLABdxA3KyGWlKeLs=;
  b=GGxfv7bpmT8z1ZXFe+aBJy1wlsOcFWMuVzhebHkxZfc21i7ItQnY8mV8
   cd9NMnPo25pXBdrIoyduVf/kl4R8Ay1bYFU76AsRhpIaAHHYVB+lg7ueX
   cL8kTM42RI2glk4Z7bzhRkv0LWK7cLrU+JiSs8YscC3Cxzg781W+g0vKK
   TWY2PVXvyc5pp+n9g+qzi4hFotcAhWJsEsHx6dkJmwQxjEvL/WSrWeTca
   V0val1ljoWx6PLmdQL/LYfOjv4FWoHRxuOeNbERJpBfUOqh9JPXjGioYf
   vf+wvkJYgZA06+9KnElFHlSinj70YnjvTmiy4+WlB7Hzao9g30hDhodjs
   A==;
X-CSE-ConnectionGUID: RDG58kkYTYSQOwFNpiMmyw==
X-CSE-MsgGUID: Abc6LuEvTJO65iT8p91vgg==
X-IronPort-AV: E=McAfee;i="6700,10204,11407"; a="46571487"
X-IronPort-AV: E=Sophos;i="6.15,222,1739865600"; 
   d="scan'208";a="46571487"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2025 16:11:35 -0700
X-CSE-ConnectionGUID: 31vkt1cZRmGFSF6qxh8j+w==
X-CSE-MsgGUID: 974w5vIqTu6ALpZDHr70Eg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,222,1739865600"; 
   d="scan'208";a="131528765"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2025 16:11:34 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 18 Apr 2025 16:11:31 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 18 Apr 2025 16:11:31 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 18 Apr 2025 16:11:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BYQP6Z9ptdNhAZVQzKBQhjExFl8LQ5n4C7Pb/fjz9FN5MxOUXbkE2yGlidTZApSfqKeCvy7SAqptUd2/5nWXH9vpF1ZnGTEGGT/b5tCdiISVV+xFJ4TdrbEjN2+QAMgJKQgL0ZwISgJGnwmIQewgOqUVs1ZkxMF7TdPz94+P06aY1qxmzWOCtOwpIADT8H2unp8pNywzFISXkn9MpF7OhXqqXKEUNu1Weah8Gmfj0DEJlFqYoFEPRrPRw/urnJaFmS2qr6UUAWgveuKxub23X6gS1aVhlQGmmWDJvjP2YZVN25iBYL/IT9o930cBuqBE6si7XCbaH7wgGecO3FhDnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eG0iWiADFRiWL4qE+TyyLxdKv8bZiajpKFNfw36x3Uw=;
 b=teM3M9wkr0llSivWhvWHbZfhrze3R+Nvhm/8bTbJf7QVjfsWO38+XZJkoQwuMqpM2MJBalE6kUOY6/dygQGV2I0PvtARziQWYzsZx8noQ8+wXgOXdwvXRiWty3jWirfc3gMedb7iOUtCVc1pSpZkq8KdyKsbmd5pniqy5/5SUG1TMA7oCDhqg3I4T124tezdRKvIN4k+d65fgtCYGymAH/uhZK8jL0kLGn/6aVpRM/myxP3lZXRKTPxlo74HxmjCiV3Tn1cjg4LsYsi/MQJ05MMXoAN4fjMSygeXGIkLm6UamRS1LHvTmeDn1TgQcoCkemznb5SaWgDaKPK+rVbf0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DM6PR11MB4723.namprd11.prod.outlook.com (2603:10b6:5:2a0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.25; Fri, 18 Apr
 2025 23:11:24 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.8632.030; Fri, 18 Apr 2025
 23:11:24 +0000
Message-ID: <948e4fb6-f1c2-4547-b430-7d9ca3af7cf3@intel.com>
Date: Fri, 18 Apr 2025 16:11:22 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 12/26] fs/resctrl: Add hook for architecture code to
 set monitor event attributes
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>
CC: <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20250407234032.241215-1-tony.luck@intel.com>
 <20250407234032.241215-13-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250407234032.241215-13-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0297.namprd03.prod.outlook.com
 (2603:10b6:303:b5::32) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DM6PR11MB4723:EE_
X-MS-Office365-Filtering-Correlation-Id: a8e851f9-5938-41fb-b3ed-08dd7ece56a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?dTR2OEtQanlrNXlMSVd3dllueG1ObThHV2F3MWVlbXVXdkJzaVBScTFDdktN?=
 =?utf-8?B?a1dZR3pHbE9hWGFmOUZBVTg1ZGRNWXlYTHp6QmpVSVNVZlFpYnN1WnA4RXls?=
 =?utf-8?B?aWY1blZBRTJJQjdkSkZhTE1iZHhoYm5kWE16cVR0a2c1V1VsRDA2RmpUeTgr?=
 =?utf-8?B?aWZuOGp6N2UwNzBSVm9PTlduMlNYYzVQc2VSSzJnSEIremtncFdMdFZyeGlP?=
 =?utf-8?B?bVpEN1BUbmZVUDU0cFhIZGJpS0IwWEExbDdycjlMU0tzWmpxb002VEd0am9J?=
 =?utf-8?B?RkdJVkhFeS82cGg4azIycW5FMWVUV3k1Mll5Ly9KQ1V4c1B4aFlCRHh3cUhx?=
 =?utf-8?B?NDZCRnpCQmQzcG51bWVmMFFvU1JGbzgzWG5mWUk3NjE1NTdvVEhZN0hpZGZX?=
 =?utf-8?B?Z3JKaXBpNVBEMmx6ZGI0UndMQkM2THkwdzNDdkJFZmdzZUpGRFo0a0U0NlRI?=
 =?utf-8?B?Zk9iV0pPTEtYR3RnSzdOUSs5OTFTNFV2bXNZYmUwMVkzSDVRUUcyZjFHeVNy?=
 =?utf-8?B?NEdObDVpazd3R3hCSXgrTGVkMmp1d2NFbmNnV3RMcDI1OENKemtuY0NUMDV1?=
 =?utf-8?B?Q1UyNG9mM3V0U3pYU0dFQmJqc1RPTHEvKzk4L3k4d2duZ1ZBK28zdmwvZ3hB?=
 =?utf-8?B?RDVQNnpGUzBjYmEzenpMZzhLQ0JldEVRVlNIbnlPZGdFQlRaU0MwNkplNGxO?=
 =?utf-8?B?ZFFvTHlnSG1mNkRkZXJxUDlHRDFJcEF3NGg4a2dQNnVaZG5SM3BlaUFPMDZL?=
 =?utf-8?B?V0RPMzhyWVdqdm85UTRXTW02R2dpcTZQNURidGQvUTdqV0hrNnBURFJ3K2lY?=
 =?utf-8?B?NGNWT0pLa3JqQnZUaWUrQTJsODlVcGdUbTI1bFNyc2JlU2JnamZqdlR2ME5x?=
 =?utf-8?B?Qm5vNjNCL2FGVUdJL3lGQjlzUkRHVlJHZmVIV1VOK3JENDlvbDBsNW1VQUhu?=
 =?utf-8?B?Y1hOV2RQK29XZXZZbDlqQlhva25LaGxLRE5ZK2ZCK0QxZ0ovNkR5bFBKUHE4?=
 =?utf-8?B?a2RUY0VJQzYxM1UrbE5sRnk2Ri9sTC8vREYxa2ZRL280L0lUOFU5OVUzenRa?=
 =?utf-8?B?bkl6cE5aM1huNkx0d0V1aStzNElOZDhNa3pzOUF2ZmpkZi9iYWdIcDlRVVgz?=
 =?utf-8?B?NTlYOWZibWlnOURLTXdTU21kaVN0SGNoOGMrSHl3QW5LdE1CVFlLa1BsNFJy?=
 =?utf-8?B?Y2NhemRVMiszVE1zRHU1TEVRbkdFd0NPVjZ4eWR1WTVmZ0VveEx5ZHBMR2Ev?=
 =?utf-8?B?dDBNM1AwVDBMa0VTUTF1VE1hZjBNOWdTVXVqdXdNTDJQUTBNTlMyeUEzWnAz?=
 =?utf-8?B?Ti80QTVqY25pRU1UdnRKcWZFOUhUWDJxSFhDTGU1eXpyOGF4dk8vL0R1c2RI?=
 =?utf-8?B?WUlzUmcrdVNaMEZwWWRnNWJzWmFoL0Q4dEw2NGs2cHdLZ0MvK2phTUw4WXYy?=
 =?utf-8?B?T2tvZjhhZ0RxNDdiZi9uMHR2UUxSSzJTemQ1NkRuV25WNmtjZGZ2RWNZK0Vo?=
 =?utf-8?B?d0wxRXdtV28wMHl6Sm1PRHh0S0w1bGlKWHdyK0ZhLzhqVzRCUjNsNmVoYjhn?=
 =?utf-8?B?NXR0YSs0MWMvVFlqclFzMkNxaFVsVis3c2ZGcEhqaUlOODI4ZXlWR1g1VHM3?=
 =?utf-8?B?cDJ4YmtmRVdOMVFzQ3cwZTlqMmFQeWtSQTlMTWt5SUg4dE1vOU4vMFB6eDhX?=
 =?utf-8?B?M1RsK09WLytjT25JQ2VhZHJOejZoU2NXdFRYMlpEVndFVVV3ZWVmZ3pVMDlQ?=
 =?utf-8?B?aHVhZkw3Uzh2czAxdjVRejFTdjU0azh6cXJQQlhYNHB0dG1HRHNCVW1oT2kv?=
 =?utf-8?B?eUV0U1Ava0N4MEM2TGZLVkNyNHZTYVlSSm9TTVlFL2swL3FwekMwL2M4bXF1?=
 =?utf-8?B?enNjWTEycThPNVYvYVlLdGh3RUdac0NGZXlvWFRpcEFreHc9PQ==?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MmVmY2ZveEMyOVNqQ1FITFJUWEpBRWR4L2pUd3dnR0hwQnJkcFZNN2ZOSGZQ?=
 =?utf-8?B?T05CdTlLckFoQ3lsT3MyTXA0SU9RUHhNRnRYVGcyY0VuckF3WUV3VlVyeWYy?=
 =?utf-8?B?QkphT3BtRU1LZXp1dW9PcVNRT3V1ZU14eXpqSHVZQnh0OENhUVBvODNONDF2?=
 =?utf-8?B?YVFISmZWdlJVWjEyQUQrUWVFb21oaHdnN2NUN21Rd3c2cklTa1BTWkR2YmNH?=
 =?utf-8?B?dVJCWTlnZk5HUndOMHZhN2xXMnZFMFRib0pKTWdVZkFWMVhiVTMyWkdWQ01F?=
 =?utf-8?B?ME5wZkcwT3RDTloyZ0k4Z1Jwci84SFFVNElab3k3SEtIS3l5T2EzRHJIUXpO?=
 =?utf-8?B?dk9JS05LTmF3QlBSOTFmeWRIMzNDT0NnSExFdURWeG9yUVJBZ3kvQjVlajNv?=
 =?utf-8?B?QXNiekk1d0R3SVNrcGFQZWVmN2crZTFoVmV0VHMvL0N0VW45VEpoOGs4OG5E?=
 =?utf-8?B?QXJwSEZSTzJGVDdqSnFSRkZRNCswamJ5Q3hVTzNMOUh6ZFNFdVRmLytIQlNC?=
 =?utf-8?B?SWhGdG53UmhJRnNWT0J0VVFHN1ZyMjdwd3pQSy8vZVgxTHQwSW1jLzZqdE5G?=
 =?utf-8?B?SnEzZjJMcm5yMDR2TmtHdFp0ZGU5SFZVK3BiYUJvcWtaYlNwMHk4T3gyU2t1?=
 =?utf-8?B?bFRuQXk4UHRYTXc5Qk9VVTcycDZTVDdGeDN3Z1BHWGRnay9tVGVaV0FkYkZy?=
 =?utf-8?B?TmJRa2lURjBPYXRsRFVoS3pETFVISnlWK3ZkVTg3Zm9IUHNMT3ZCMU8vOStI?=
 =?utf-8?B?SVkyUlhxUUExR1hzeEd2T2FWTGFFeUNRWUpPdWxUeHBsYVZVSHBKVXRIN2ZC?=
 =?utf-8?B?dEN1K0xZSUdJN0dUdERnak1ha0lOQ0NkRXUzZnA5bWN4TjFlR1BNSlhKOW9C?=
 =?utf-8?B?ZWRQdjEreGZSRDBqSG1WaWJTR21teWFpelY1NG02TjltK3p3T25Dd3lXM2xZ?=
 =?utf-8?B?aVFIV2hJcW5hWVlseW4yMWVSOVQvRGFZbkUyRktYYTd0di9USEp6Wkpha2Va?=
 =?utf-8?B?aHFYV1VYblJ1d3VaUkE1SUdqeHllNTJOT2ZVNTV3ZWtJand0MGUzdGswUnQ0?=
 =?utf-8?B?enorK0t3Ri8rV1RXZE8rZzFESWpoNTBOUlJ4aitUcWxoRHJHeTJ3QjFXNnFr?=
 =?utf-8?B?VzFKTVd1UlpONXR6UDVzdXpaZlVwZmI2K3FDb3A0YjBVR0hmY0xhL1Zpek5m?=
 =?utf-8?B?Yld5WWkzbUVLa1l4d3MxUS9ydStxbkVMZnY4emxUaFcxc0QxNng4bmt5OCtN?=
 =?utf-8?B?Y3JFSUd2TVVkd2xid3lGcDlCZDRRTFk5dUpia21pVnFYTm50aVhQZUFXTHNw?=
 =?utf-8?B?MGxPMFJpd0VSb3ZOL0tVdFB0dW9CSWRPbGVLdWtwcDlCSng4R2dndy9qL0FM?=
 =?utf-8?B?K2VSSFd0TzNKWmZvYXUrd3V6NEFlODNRU2FVVGlOUVNVaFJRS0s4L0cwV1c2?=
 =?utf-8?B?RWJCN0thb1M0c1FjaUNoRXVERHhlaEZubHFvdi9YOE5lbWRwMjhjSXBWNEU3?=
 =?utf-8?B?MFpHdHpsb0JyejR6L3IwOFl3Tnd1aEIvdlYrM01sY3dhNHNNWVNMOFlGeCtL?=
 =?utf-8?B?b1FvY2d4YkpibkUzSmVTL29mYm0xT2dLbWhxb1h6ajNBcGRGVytPZlBtWkpD?=
 =?utf-8?B?RWJQWm4zWUp6SngwNDVNbzltS285LzRNYWUyaHZ0aFBCZUZRT01rdzNVZjdX?=
 =?utf-8?B?Qjg1Q2VGSllqMTR6ZXUvSUFwaTZkMWRUNjQvaTdQcy9BK045N09KaDdBdWw2?=
 =?utf-8?B?K0Rmczd2SE9FQVl1UTB6UnNlY01jcTZ3cWZnTUw0OEozc2pkWE5EcG1aQW44?=
 =?utf-8?B?bGxUQVB4eEdUcVNBa3Rnemd3K3NoMUhLRFhUV3lYYXlLQlArSnZVa1ZBalVZ?=
 =?utf-8?B?ZS8rNlNGdGUyN1NucE1NWUUwei8yaVR1RnJ5MGxva3QwNmxnZHZUMDJ6SjlR?=
 =?utf-8?B?YmJnLytSS1VPN0VWemtnMjdGYmlER1RMakZnU09CeFgweUhYViswVFl3VVl2?=
 =?utf-8?B?RGF5NmMybW1PSVhlTkJDa2R4dGZyMnIrVmtEM0ZVVVplKzl5bXdrK0U1NCtm?=
 =?utf-8?B?c0hVeUVVZ1JIQk5jYkFrL2NTZ1BLZTFqazZMTjZFczhudlFXM0VqaWtqMWs0?=
 =?utf-8?B?Mmpubk1RcmFrVnRuL1R3OGV5ZFN5aklNSkN0Y2pYK1RxamNSK295QmFFZ2xB?=
 =?utf-8?B?TVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a8e851f9-5938-41fb-b3ed-08dd7ece56a0
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2025 23:11:24.0331
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zNt9WWcL5BZXyg8Fzi9FE5PT28X79JnYufblirqyEjJN0PyglZlVA3G1pG6p4dk+3q1oGmtVFnyJbESLj1JHLG9NUjsRXUTlYhKPOXh+0PE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4723
X-OriginatorOrg: intel.com

Hi Tony,

On 4/7/25 4:40 PM, Tony Luck wrote:
> Architecture code knows whether an event can be read from any CPU, or
> from a CPU on a specific domain. It also knows what format to use
> when printing each event value.
> 
> Add a hook to set mon_event.any_cpu and mon_event.type.

If the architecture modifies the output format then the values exposed
to user space will look different between architectures. User space will
need to know how to parse the data. We do not want user space to need to
know which architecture it is running on to determine how to interact with
user space so this makes me think that this change needs to be accompanied
with a change that exposes the event format to user space.

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  include/linux/resctrl.h |  3 +++
>  fs/resctrl/monitor.c    | 12 ++++++++++++
>  2 files changed, 15 insertions(+)
> 
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index 0fce626605b9..8ac77b738de5 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -418,6 +418,9 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d
>  void resctrl_online_cpu(unsigned int cpu);
>  void resctrl_offline_cpu(unsigned int cpu);
>  
> +int resctrl_set_event_attributes(enum resctrl_event_id evt,
> +				 enum resctrl_event_type type, bool any_cpu);
> +
>  /**
>   * resctrl_arch_rmid_read() - Read the eventid counter corresponding to rmid
>   *			      for this resource and domain.
> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
> index 1efad57d1d85..5846a13c631a 100644
> --- a/fs/resctrl/monitor.c
> +++ b/fs/resctrl/monitor.c
> @@ -863,6 +863,18 @@ static struct mon_evt all_events[QOS_NUM_EVENTS] = {
>  	},
>  };
>  
> +int resctrl_set_event_attributes(enum resctrl_event_id evt,
> +				 enum resctrl_event_type type, bool any_cpu)

So this is not actually a hook (in the resctrl_arch sense) but a direct interface
for arch code to change resctrl fs internals ... this needs to be done with care.

> +{
> +	if (evt >= QOS_NUM_EVENTS)
> +		return -ENOENT;
> +
> +	all_events[evt].type = type;
> +	all_events[evt].any_cpu = any_cpu;
> +
> +	return 0;
> +}
> +
>  int rdt_lookup_evtid_by_name(char *name)
>  {
>  	int evt;

Reinette
