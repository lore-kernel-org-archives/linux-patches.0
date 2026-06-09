Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E87840D594
	for <patches@lists.linux.dev>; Tue,  9 Jun 2026 23:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781046141; cv=fail; b=e9hCsjKAcaQs8alMd5LZGPIWVda88+IXThgxC3JULx3SRPMiam2c3qREZorITDLeyAI3fA94AVihBCf9E4WD6XXhgIXHhYJ9nay67MmMgOrUebPH5zub0Ml/rV2CykdbcqsyfrVNyAgJ18bdF2HxXOPuqxHdiqD3M/kdUB2R5JQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781046141; c=relaxed/simple;
	bh=+N5YRswdevFf6Zxz7g00yiFgveO5/BPr6r3V57RYrWE=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=pE9OxFe99wE5QI6GOkrlmm745cDO7L8iJz/QNf6omdp9bxuqcmdMp2OH5YKNhJEGVRjJpdqa32o+RIs/kiwZymSQt5HXZYQ0tqoAv80snFgpaFntvoU8T4aObXZxOrnfqVMxWrAZ+RH5NWKzRlKuTnel4QkmZMMqiK83TtS/t8k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dCwwOtGo; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dCwwOtGo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781046140; x=1812582140;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+N5YRswdevFf6Zxz7g00yiFgveO5/BPr6r3V57RYrWE=;
  b=dCwwOtGov8kMBMC8lqkSHz64hA3SM9dHnrWui0RjX9291WF/K0A9OF6g
   GWACT8qJJaoDtY/wmK3TOh/exRCja9gTzSq09kPtffLEtLunqsGQQdFEE
   XMvZf+F91scigaFM+Sqn8UXSrnELbW9b24cv/rFrtsIhFzbyKsHv7wXTc
   qXnope/x4DaNO8S9sVjlh8srFRj7wEo4yfKMeTLFgnqh1z4ob61+ttNfX
   OvTeNhcQKnFkFF3UBLH+ZwexJyo8QTdmN6eOyBHvb5TKbj1oIVT4Jrqnq
   WgmumVZKngLfhYKdi6KXbBmonVxKRL38f1Zdt20hbEafg41YKmGJVXbVN
   g==;
X-CSE-ConnectionGUID: v/vJD9G5Q9i9FuHi7u8tug==
X-CSE-MsgGUID: u1hrUiTKTJyHn1ob8stYbQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11812"; a="85676016"
X-IronPort-AV: E=Sophos;i="6.24,196,1774335600"; 
   d="scan'208";a="85676016"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2026 16:02:19 -0700
X-CSE-ConnectionGUID: yroMK19cTq2QF6MEFBK9Jw==
X-CSE-MsgGUID: ocBHQrQvTE2NmFH99F4z0g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,196,1774335600"; 
   d="scan'208";a="246024677"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2026 16:02:18 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 9 Jun 2026 16:02:17 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 9 Jun 2026 16:02:17 -0700
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.44) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 9 Jun 2026 16:02:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KiuhKU17FKvsxbNnGjTXafJ0FyUboEFBNRsM4kGlraMkwrgd3J0oac8nhHmDdSe7xH9wJwGfwO1RiER43LzGrPiIt2NhKhANCoYjwdiWwVNWIMs5+tpAejLON2lZnj6IsIlp0v4GEfCagnbRW+Em+XFaLBmaCBVdL3vyelY0scrdaaQ0/bgRQIqVkubImA8JqiyYY9mLBmoSBeDuNXu0SEQDGn5TOUm0JcJXO9gQZestA2ujIgxkORNOfAuVB+UyEFtNwVSIudBxSFWqnGjQyULF07jXF03G1XTcSwujj26uDcG4l5WnIDlYFb/psWsyHf/8mDrHXQEo7H8zMqVOlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VRQB1SnHehNlsqFWb4OKxtAhHUY9LwvSVVlp/W5u3q4=;
 b=i4CvoXcZLYXzxGt88kEoHSXA2jxnDqptemhLaDKdr9xsbI+Auk1UAM6iUE3QnBby6FGy6ebCBjvQMih7dLOhBapoG82PHDwbAyyHuu+QjkbJXm0z+6Wk8DsvC/ApeI0dwnTR3qwnveZYcLpjU7d/rD36H4tsKujF6emspFrV8FFBSKcrasMJlbkGOoCIMS0FznD4WZEeiuNKveQigpGu7ZXX+1kRH4+8Vx4EKT6PDciPnOzF4g5+k9osz2ft3Yr1mIM89u+fA0U+WchxSPAawpAsFqdOil81S78lDWerhbmgs9RdJZkesyImC824d0hdyewweSszDEJKq111FmCC7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by DS0PR11MB7336.namprd11.prod.outlook.com (2603:10b6:8:11f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.13; Tue, 9 Jun 2026
 23:02:13 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%4]) with mapi id 15.21.0092.011; Tue, 9 Jun 2026
 23:02:13 +0000
Message-ID: <933eb065-17ea-413e-875b-3783ad2456aa@intel.com>
Date: Tue, 9 Jun 2026 16:02:11 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 05/14] x86/resctrl: Stop setting event_group::force_off
 on RMID shortage
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260601195632.15876-1-tony.luck@intel.com>
 <20260601195632.15876-6-tony.luck@intel.com>
 <4a62b53d-fafb-4f93-b724-e39ef93f0e99@intel.com>
 <aihEdw6gikv2aSKK@agluck-desk3>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <aihEdw6gikv2aSKK@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0255.namprd03.prod.outlook.com
 (2603:10b6:303:b4::20) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|DS0PR11MB7336:EE_
X-MS-Office365-Filtering-Correlation-Id: e2ff7a80-3a6b-491f-2b9f-08dec67b248e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|23010399003|7416014|376014|366016|22082099003|18002099003|11063799006|5023799004|4143699003|56012099006|3023799007;
X-Microsoft-Antispam-Message-Info: 5bFxa/RhrG6RS29XFoeRHV0lHr0mRp9loEj11fYKHIARu21g6D2u3lP+wBg5gpN7LYlIJ4Ob2h37C/JZk+0DTAj8YBXTXPP8RZekeWw4/VSQ893rH4OOhrOXRAPx0xyoS15nZCVP+g8SIrZ4+hoBfLJaFOwJMrKAJwcx1TzmV+FUxRtYnuUeyxVjeGEZDTc0V3awPsLSD/sFfNyDegx/nWBNGBZfHYKG/oZ17H4LhSSfVXLZwEv2/2DXp8a2AGV7TS+/rIzYosENwtX+qrgOYJR6agrfuuuDmk/o8sUYZwqaW48WNZ+OWoSWa6lIJQMEkxJAdQb4WhiQYNKmH3skTdGZntkg/vR17nVTkZEl+AoafsGNwj5EeID3ODqtDGDnKSAufRwY0geBPmC9HmDPu/SLxlAcT7L4x5f90UNKaG8xpU9BKzpJP6U7QfKj+oj+W/JJXIJBgXknPyk9WBS+n7E6nfFyJHzF4xxS5VK50y6y35J+Hl17Xwop0ivTDIP+anw06/WwEvzxdxz9rYGYLY+JPMoBu4wg2QtDNcPbzX2fNnVujMO5etQsWFZo8ST/ftJg6JMfyYGW+oiUFFVgCP+uuVxDTA7KRzV/1R3/9wcwwfgWXSE24zT+KXyx3bkKSZTeyQuz7LDwjWep0IZ/Jg1WNB/L2pmPhDr++HbNH7+RJPyE2IkxwZ6XcXEkAFO4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(7416014)(376014)(366016)(22082099003)(18002099003)(11063799006)(5023799004)(4143699003)(56012099006)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NWNTRG5IeFdwRWJIckFRSXhUcGRNdDdsMnBLWXJPamlJVyt1STFNSC9sYVFX?=
 =?utf-8?B?eXhZSVFOS1k1RkpudUYwRDVkenFrdTgyaERwcUlnTnhmVXVUZXFRUlpnZEli?=
 =?utf-8?B?Yk9zdTg4eTI4QndXNlpLUVBJL1k5My9hQW5UZHV2blBZcHRWcE95VXN2MG9F?=
 =?utf-8?B?YjJlM0hidEhiZVJsbnN2VVFRbis2VVdRL3BBTjc2dUV6c3ZzOHBpanRaNG5z?=
 =?utf-8?B?a0VUbHhVazZSZ3NWSE1iRHEvTjNmL2ROWFJVTDhkTTZiZnhZR0dIYWptVFp5?=
 =?utf-8?B?dXRlQTlIdjdjWHEyZ1NZYUYvWEYxQUlOcDBvQS9DWlBpTEhWVDBuMjM0WGt6?=
 =?utf-8?B?dXdzZHNQSjBDUHF2MXViWjR0TURxMGN4VmZ0NThJdlU1KzFmck0wa3ZzMlhL?=
 =?utf-8?B?Q2NTR0lqc1NMWnJPbTUwc04xRXJ5czlVRmczWElXMG9GeS9scUtnWWc4bEV3?=
 =?utf-8?B?WEw0aXJOb0d3cERPa3pLM05abS9NcXVYeWxMVGNGMFVEWDRxSjc2UEFQV2Mw?=
 =?utf-8?B?MkdsRHdVeWxQTWI2Y2FXcTQ1bmFqeFE0VndhODdzT3M1cFdZR295b1B3eERU?=
 =?utf-8?B?TXlyQ3YvTDdVcHRMTkVOKzdySzhidW9iU2V5MEJJT3hSMnFkLzRyQUFUczJL?=
 =?utf-8?B?L0Z1L05Id2Q3SkdlTGw0ZnY3MTlYZThjSDRTQm83QWNtZDFBbnY5aXlzMlZ0?=
 =?utf-8?B?eVhaN095UTNyNSsyTFR5OVFpekF2ZUdsUVFETlJDdTF3UmN0WlNSWDF3SXNE?=
 =?utf-8?B?R3o1VnlCUE9LK3o5cko4NWtZTlRJN2grc3VWM2NPckVFWGxDQ1dlb1JmNlBP?=
 =?utf-8?B?QU0rdmorU0d0S2lORlBzbU94WjFCaUR4MzBQOWdrZlN0SklEKzFOdnVEWkFC?=
 =?utf-8?B?Mlc1djI2Qm1MTTd3VTZpZVhVZnVGcHBmYVlaVnpyWDZFZ0xURkdmWkRseXZm?=
 =?utf-8?B?anRjMU9QUU40ZzgwRW16NjYrZHE2RnBtR1dZd3o3Zm5nM2hma2Q2ZUhhY3o2?=
 =?utf-8?B?RjdIQ0NuN2MrRVFsSklNTlNwRC9CQnpYdEE2bmJvcXZ2ekZucXQ4QVYxUHlK?=
 =?utf-8?B?c3BVeThPVzdMWGFsaFdPQUlNSXpDTkhwVmg0cFVGb3BtUjZkanVsQjYwZXlI?=
 =?utf-8?B?MGFGbmRRWWl0MU5ldThvRWFmaE8vUGNOcGsrejBxbks3ZzJOZTBTZDRFRnow?=
 =?utf-8?B?OUwzMzc0SGdreGZpMStkTnhKZjdPcHdpeGtGcDRwRXJ0YlRQeTJFRTl6aVBQ?=
 =?utf-8?B?cko3YnZQZWMvZVcyZFcvSU9pMG1qSEt1aUFHcHNsZUdtcERNM2hIRzcvbngw?=
 =?utf-8?B?SnhRVzVOT0t2MDhLRk81MHFRUk1YaU5ON2hHd1ZpK2dkdE9sSlFSRkFhQXZC?=
 =?utf-8?B?ZGpnUFI3MHhlc3FOVktUVklMSlIzVUc0ZjMvbWFNaGNDRnBidEtBTjdSRk53?=
 =?utf-8?B?UkRZWnNZTzJDUTlYZHlraDNYWFg4QmdXOGNIcnc0OC9IcHYrd3lNYm1vYXNM?=
 =?utf-8?B?NmtBeXplUzl3K2lTcVZaS1Y4VEplOU9JV1RqcllqK2dGcDJxMHgxQzMweXND?=
 =?utf-8?B?YkZnNUdYLzZKb1FVMzJvZ21ienlzQW0xZ056MnVDcTJOQ2huWmFuMGVIcUlH?=
 =?utf-8?B?NjNCVHdNZGRQRk96U3p4MFpDdVZ1bWgxK1drcmM2cTR5MXZHZ0pPa2p4NXBj?=
 =?utf-8?B?cUREYnZKR0xheW5BdjBSbUFXbDZiY3ZraXVKWHMrTklMMmZkNlh2M3poWGdM?=
 =?utf-8?B?a1F3ZHR4ZDQ2TnlkRW9hV24zVGsvZ3loUElqeFhEWkFlVmFsOUprQnFIbWNr?=
 =?utf-8?B?L3psb1kxbEpkVE13ZXoydjQzd3hiQkJxQ2hIcmhiZnJTTEhTR1BNdnNidTRF?=
 =?utf-8?B?L1JTa1lpUmVQbWtWR1JzTUFyeUVDMjRvajNTb2tWeVNMbW5GL2FVQnc1Qm1P?=
 =?utf-8?B?bXFUc0xUYjJpLzFvM3A4Y3FuQzAyN3hoa2ZyZjVjWTVFbncrTDJzNW8zM2Vn?=
 =?utf-8?B?VFBHVTZZUDhlaUNLU0NOMXZBbGFDTHFnKzlad0NkZ1ozS2dUZ2Q3Y28vbTlQ?=
 =?utf-8?B?OTJFd1Q0aTViK1pOSmhUVlgwQ1NHbmJDOW9Sc0ZUamhadTh2TWt2WnU0bVUr?=
 =?utf-8?B?WS95cEROUFB5aGNkMEsvV0NRQmRQczRPWGRmeUE1MmR6KzVxNzV0a0hpelJr?=
 =?utf-8?B?YUZXRUwvQlB0bEhKVUdDN1QxVWJ3WWZlczRFcXBxS3JQWjhJeGUrYlRyZVgx?=
 =?utf-8?B?N2VhWUJNUUNQYys4WG1BdE9tYzQwNDE5ZGJvdiswTlRXUDJrYXpkUHZFeXc1?=
 =?utf-8?B?UU9pRFpKYjNyTHhIYmYrdEI4VEhON2JJYWo3ODkzbVVSeTFUanpwQjExTk84?=
 =?utf-8?Q?9IpyBS7FPdmK/kf8=3D?=
X-Exchange-RoutingPolicyChecked: Z0VauCq91HKgvgWe/dQ4Dx5riucg8Hr8m6/NFB7s+0tAGBTuuv6+Gtm+35Dhotyv1zrFMAWn6f8nEIcys2KbzisxW8/OWYPIPQDWzOHzvGwdBmhg+3eBqo/BAfhXhn8qyq/1f44YDT8OpiYCcdbEPobCuuv3zpaQU0j4EkT31c+fNAGmReHXBN5invuwah28AmSxeaEBpTYq6udNqqFlwO2s0rkBpNJ+33u5lzHWjLWQofLiOiyMdZnwg5FIfnvHXGcRc36+2Th7SmIUnj7nJh80vK//FCVSqRe8ME26If32nlo8LgFaLEDJl4v6PaNcZWfp7y7H+7GPgvyEFOXf5Q==
X-MS-Exchange-CrossTenant-Network-Message-Id: e2ff7a80-3a6b-491f-2b9f-08dec67b248e
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2026 23:02:13.1946
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cHkRRzuD5fLVRNJfuEKaWlIFeu7EhZbvTxSyfEJq4bgJ071Y+UXmFfMVP2VpnckQl2q4lEOw3Crgg8MtgKeehiBKWhYSfzygWuUvlDA8DXI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7336
X-OriginatorOrg: intel.com

Hi Tony,

On 6/9/26 9:51 AM, Luck, Tony wrote:
> On Mon, Jun 08, 2026 at 04:16:58PM -0700, Reinette Chatre wrote:
>> Hi Tony,
>>
>> On 6/1/26 12:56 PM, Tony Luck wrote:
>>> Drop the force_off assignment from all_regions_have_sufficient_rmid().
>>
>> Apart from this being obvious from the patch, this is not how an x86 changelog
>> should be structured. Please see "Changelog" in
>> Documentation/process/maintainer-tip.rst
> 
> Revised version:
> ---
> Subject: x86/resctrl: Fix usage of event_group::force_off in AET
> 
> The kernel command line option "rdt=" is used to force enable or disable
> individual resctrl features.
> 
> There are two problems with usage in the AET (Application Energy
> Telemetry) feature:

Above seems incomplete. Could it be "two problems with usage of the rdt= kernel
command line ..." or "two problems with the "rdt=" usage ..." or ...? 

> 1) If the user specifies both enabling and disabling of the same feature
>    (e.g. "rdt=energy,!energy") the request to enable should override the
>    request to disable (for consistency with other features).
> 2) event_group::force_off is set true in all_regions_have_sufficient_rmid()
>    which will cause problems when AET features are enumerated on each mount
>    of the resctrl file system

Two comments:
- In general we should aim to make the changelog as specific as possible to
  prevent reader needing to do any deciphering. This makes the review easier
  and faster. So, please avoid general things like "will cause problems" that
  requires reader to figure out the problems (plural!) on their own. Instead
  just be specific about what the problems are.
- Is (2) still a problem when (1) is fixed? An underlying question is: if an
  event group is successfully enumerated during resctrl mount, will it always
  enumerate with identical properties on every subsequent mount?

> 
> Fix the first issue by checking event_group::force_on in enable_events().

"the first issue" seems vague to me while the rest describes the code that can be
seen from the patch. How about something like below to help describe what the code
change accomplishes:
	Enumerate the event group if user space overrides any disable of the event group.

> 
> Fix the other issue by dropping the assignment to event_group::force_off.

"the other issue" is very vague. Here it will also help to be specific. Although
per earlier comment the need for this fix is no longer clear to me?

> 
> ---
> 
>>
>> Please note that, after the preparatory fixes that are expected to land separately,
>> this will be the first patch of this series ... having this first patch just
>> kick off with "what changes" without any context is a difficult way for a
>> reviewer to start considering this piece of work.
>>
>>> This preserves current single-enumeration behaviour while preparing for
>>> the upcoming per-mount enumeration, where latching force_off would
>>> incorrectly suppress re-enumeration on subsequent mounts - even when the
>>> user explicitly requested the feature via "rdt={feature}".
>>
>> I believe that user space should still expect that rdt= options behave
>> consistently. So if user space for some reason provides: rdt=!mbm,mbm,!energy,energy
>> on a system that supports both then it should not be the case that one is enabled and the
>> other not.
>>
>> I this think that, for example, enable_events() should start with:
>>
>> 	if (e->force_off && !e->force_on)
>> 		return false;
> 
> OK.
> 
>>  
>>> Signed-off-by: Tony Luck <tony.luck@intel.com>
>>> ---
>>>  arch/x86/kernel/cpu/resctrl/intel_aet.c | 8 +++-----
>>>  1 file changed, 3 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
>>> index 89b8b619d5d5..e2af700bca04 100644
>>> --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
>>> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
>>> @@ -60,8 +60,8 @@ struct pmt_event {
>>>   *			data for all telemetry regions of type @pfname.
>>>   *			Valid if the system supports the event group,
>>>   *			NULL otherwise.
>>> - * @force_off:		True when "rdt" command line or architecture code disables
>>> - *			this event group due to insufficient RMIDs.
>>> + * @force_off:		True when "rdt" command line disables this event group
>>> + *			to avoid system limitations due to insufficient RMIDs.
>>
>> >From what I understand it is only architecture that can disable an event group
>> "to avoid system limitations due to insufficient RMIDs" and this capability is removed
>> in this patch. Above implies that this capability now needs to be implemented
>> by userspace, which I do not think is accurate?
> 
> Should I just drop the second line? The user may have various other reasons
> why they want to disable this event group.

Now that enable_events() starts with a check of event_group::force_on it seems that
the existing behavior of event_group::force_off to also reflect architecture 
disable can be maintained?
 
> Combined with the code change you suggest above, this would describe the
> use of these two fields. "force_off" disables, "force_on" enables (and
> overrides any "force_off").

I believe the "force_on" description below already accurately describes how it
overrides an earlier disable.

> 
>>
>>>   * @force_on:		True when "rdt" command line overrides disable of this
>>>   *			event group.
>>>   * @guid:		Unique number per XML description file.
>>> @@ -214,10 +214,8 @@ static bool all_regions_have_sufficient_rmid(struct event_group *e, struct pmt_f
>>>  		if (!p->regions[i].addr)
>>>  			continue;
>>>  		tr = &p->regions[i];
>>> -		if (tr->num_rmids < e->num_rmid) {
>>> -			e->force_off = true;
>>> +		if (tr->num_rmids < e->num_rmid)
>>>  			return false;
>>> -		}
>>>  	}
>>>  
>>>  	return true;

Reinette
