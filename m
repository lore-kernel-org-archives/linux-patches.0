Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5BE41C695
	for <patches@lists.linux.dev>; Wed, 12 Nov 2025 19:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762975153; cv=fail; b=N3ZZLcPhmrBKqDUiSN+oxZtmnmkWkvOrl/Yxx/0MHOVEE+QRRZhSmyId3ap2FzJOR0n0ex8uvpJwSM8F3vhfW57ypH0rodQlEvcHx7z06ClGRlGd7HXbOJecKhT78QaunrbYMzl1rjUUBmLXFrzxwsP2vuw4+xM2VMhSZlFxfRQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762975153; c=relaxed/simple;
	bh=dRo71DQ3lHElBmhtRKkLw/9Olev/Fa2cFuh+mDj3ids=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=aR/j47p+X0Pf73k20XS9VNzWHtFxA2fvWBBTnHr0UxPDaTsl8p3kuR8ePaKU/+oA7yRknjiQs4JEMNWt6A2lMt8fyxhJsCGHzcBdICOGItZnpO7aBYWAGgR6dHgbCxcCTQsMhl5SpmNh3s6lhjX0M4KkOlJYmFp1P3D3ttxLoj4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Sq0WdoV4; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Sq0WdoV4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762975151; x=1794511151;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dRo71DQ3lHElBmhtRKkLw/9Olev/Fa2cFuh+mDj3ids=;
  b=Sq0WdoV47zuxFk6THv9PYmV4Kbnu4E6YYwpidqLcyKK6ZJCQx30PfqiM
   jh+rc3ibg++2/6ol2HFoUApMMCDaLE1Ao730AeLRCZsqQ/hYobBj+ogwJ
   fpfsI706Y+1tp5tUZvaDhKn5e4CG/7/pMDHC9kFwVFoNq1wFRHixbGIUL
   oVdnO6LzP28xwF9gwSRLRNnNCEX0bhG+9HEN/TKsgaGHXX0GiCyW9TCva
   qV7VbqncRihMZcbETFYlrEnL8q3dQxPoV656/qwaIcSgsU7XGQSL8FeKP
   JDFwvRCf2aN9kEnP7iB5fzRFa8K0nfMV6MnvHbhRV5Bzz3Xmkag0ehAVm
   A==;
X-CSE-ConnectionGUID: yORIQ+58Qb6VaGQhX7AOVA==
X-CSE-MsgGUID: Sd41NZZ9R22/SJiUmPY4iQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11611"; a="75729237"
X-IronPort-AV: E=Sophos;i="6.19,300,1754982000"; 
   d="scan'208";a="75729237"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 11:19:11 -0800
X-CSE-ConnectionGUID: zxHZ0+l0QICuz5lvhMQPCQ==
X-CSE-MsgGUID: mP7TI4RvQBCOlswKldk8MA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,300,1754982000"; 
   d="scan'208";a="188588430"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 11:19:11 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 12 Nov 2025 11:19:10 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 12 Nov 2025 11:19:10 -0800
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.13) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 12 Nov 2025 11:19:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rERFG/SdoikS3aLg9zuz5Zj6ikocH0XA46BXGWQcZjlcHz1QnzCwjkhp8QtoHcrOUtFkd6QP+qO1EUZGZgnhWdnTptZTkiGfGRrvOCa0kbVoMcMP2L+wAlzIg6Jyxwvfm6Gogmosd1d4l1vQ4zomscaOSEY0JYr5SUrPSDdXxPNkK53Ka5egScEkEHOed0Jb44ZrcC+rBMBTHsXlhiQYr2N7ZAIAggrxHvPL9rOFu6RO+e07GbdXSH1eXgUZEiMmbnMZXS0Jt6aSU2Fmsy/DvACp4+NtOfgaAPtsDHaqvN9lbjLBccevvHyWoGYjhgBMhUeTASqLFsl3LBw1/aDdVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N7cHhqtNRh2hgPZG+u4ryE+J5dNBtB9yUBg6aREjMF8=;
 b=LTaawCbS/wc6AXAHHf231qq5eMCYvjnnJ+EmsqE4yCwzfvJbFoauZzdLTh9BUuyJUYuw+d2nc18JT9Ak3TO0M6KqjPXIdZXFr89locx+hv4Vu9XFuSA82nFALV94R7osiz7yMrSHGfIz2uxfaSZWS1z5yszeuLaSGpbnWZOW75sq5JL02w4die2X1TlWbVzITb7TGZ5MNY8egwYCTFlK+ULyl0+GHPKCa9rsIgrza88w9/lv6DsRUu5r2BcRaMgaSNo6NGKA0PCd+Ds7KUx+5TEq3VePwIvdoVuSITc2OeY18/ZozdvD9/9o6wndC+8izI1itAGOcvGCb+29LWJmfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DS4PPF641CF4859.namprd11.prod.outlook.com (2603:10b6:f:fc02::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.15; Wed, 12 Nov
 2025 19:19:02 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9320.013; Wed, 12 Nov 2025
 19:19:02 +0000
Message-ID: <0aa452af-0033-4efc-b280-be1e41e42ac7@intel.com>
Date: Wed, 12 Nov 2025 11:18:59 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 05/32] x86,fs/resctrl: Refactor domain create/remove
 using struct rdt_domain_hdr
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251029162118.40604-1-tony.luck@intel.com>
 <20251029162118.40604-6-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20251029162118.40604-6-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW3PR06CA0020.namprd06.prod.outlook.com
 (2603:10b6:303:2a::25) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DS4PPF641CF4859:EE_
X-MS-Office365-Filtering-Correlation-Id: a04be932-ae6c-4917-5177-08de22205666
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?SFp3cDNnZnAxZ3F6T0tRYlNFaGx0TjJiVWZJMFhlMDVoSDNEUXI2eTY0RXNN?=
 =?utf-8?B?YitTM3djVkFkQW9kQ2tTcmpxbkp2Smg2THhCT25VQ21XRGZYcEI4QUVIWmZ1?=
 =?utf-8?B?TWNKU2gxUVliR3lrK1gvZnFzQktKUERGeUs5dVhlbXRPMFZUcHMrNlp6Qjd5?=
 =?utf-8?B?VHoxdWZSbHJUOURzbzlBdmF3WjZWOXk2NFFqeGg1bkF1U043RkNqdXlmUnp3?=
 =?utf-8?B?SlhEUERlK0VzQWlHWDd5TExZZ1U1R1ZBOVZnUUZ4Yjc1QlNvYnJ6NTl0dWJo?=
 =?utf-8?B?ei83VWU2OWRvblVCbjV5RnVvSHJIYmZWSU1Pdm1NSThpWFV5THVJY0IyM1pp?=
 =?utf-8?B?WURoRVNia2lYOTAvSldITkh1a1huU2VBT1BWTHFLK0NMTjUxMStRWmhpaDVo?=
 =?utf-8?B?eEdKODNBNWQ2MmxPa205bHBzMUFwaGxhV1B6R2hGWVlVRUdPRnNNMFc1S1lh?=
 =?utf-8?B?Rk5yelZvYTlqRlhKdkxsSXZyVkc1MGJFbmprbTBydHEwcjZ6a3pXQmxaWW43?=
 =?utf-8?B?eml5bkMrcHhNMDRMekhlb2RLaXRFaXpTUzJHTlVxUm9YMFZUdTRPMVRZbHZy?=
 =?utf-8?B?QUFqU2g2Y3d3eDdCcmFWZDhuMDYyS1ZNMW03Wjdobmd1MGg1SDhhU1EvREll?=
 =?utf-8?B?Y1FZWlNlTU1XNzhyeFhyNUdvSWdtSWJDcW5nQkJFNkVLUXU4MVFiZDlTa2Vv?=
 =?utf-8?B?L1NvWnp0a0RFa28vdzVOSWRCMmlMMnFpUXBDakJYdFFjdk9CemNPVUFiUTNT?=
 =?utf-8?B?VTRYbHNXQ0R3ZmtYWW9IanczNTA4MmR1T1NGRjFTMENEUUV1c280RStNOTJu?=
 =?utf-8?B?Sk1YK1hxbFNXaTlhU1pScWFPd1dwNVhwSXJ4Y0hHT21HQWVUUy9JbUxHZGhW?=
 =?utf-8?B?SFFlUVZnd3BjS2V5OXNncTRCanNqZ0U1RFltNmVsQkpKanE3WW5RdzZ3eWNH?=
 =?utf-8?B?WVZTVnE5Z21tbkJ0cURFOXZaM2l4TEhXQTQvRGI3ZmNEM0dsYjdtUlhkaHBQ?=
 =?utf-8?B?WUNjYWM4MjY2OWZqdFZLUys3b1J1amtZSTN3dWRPSXd3R21ML3gwUmtOei9N?=
 =?utf-8?B?ZWx3RUlSQWYyWTJtbDdmOGNQRXowNWIyUE00c1VrYnVjUFBvWVA2WHFDVzIw?=
 =?utf-8?B?V3pzMTlrY3hsSTI1L0w0K20vVVo1Njh5ZHo3WVg0MjJFUlhVSWVHSDQvcTZo?=
 =?utf-8?B?R1lDR3Q2aXhubW9VODhKaEt1TFRUdWFVMndhZ21WbnY3UjVrYU5jZm5RZmhr?=
 =?utf-8?B?L0NSenUrMWFnMUdCZVpKc1BpY3VvVHBsbDhiNG5sREVQRmY3REx4dG9pR201?=
 =?utf-8?B?ZGpBR3FZK2dHQk9SVTFtTWJSMUNNdVhJdmhxU0hSak1nTkJzYitINEVhNXZv?=
 =?utf-8?B?ZjlvSkVtQW04dUxkYmNoVVFkRlJvWXVxMWc3Z3JiN2pCZEhEU3ZwSTZob2ky?=
 =?utf-8?B?ZElNb08rMlM5UUk0dDNtazBad0VsM0lteFgydDBvMDNTYkV3NDk1WTk5blcy?=
 =?utf-8?B?SmxOWUZMcVMzRzlHdnMvNlAvOUhkZWNjVFRVemJ4SDA1Y3RqZGF1Q2Q0ZElG?=
 =?utf-8?B?MzR6Sk9Ia00yZmM1RjdrbU52RlVjbWFyaUtHU0xnWFFEM3BkMGtMVEZYTjJj?=
 =?utf-8?B?VzRlVEx3amJSQ3M2MERqM2xidUJCdW1MVFlYUmx2OFVGaXlGc2JKbm1sOG5I?=
 =?utf-8?B?ai9KMEQzelh3cGZCVVBkMjNuajJGYVdGYm8wYk1YVlZZWDUyQThLRFBMWGV6?=
 =?utf-8?B?TG1mQ1U3TGFndjk3RlBQL1dkNXhiKzQ2TktmQmNpRkdWVzN6THlldWJRZHBQ?=
 =?utf-8?B?NU95TS8rM3d4VUJMbHQ0VGlvUDEzcEI1SmlZTzU2b2d5S25uVjhFUEh2YTZw?=
 =?utf-8?B?UkNXOC9tTS9Ld2dVOWZXQ205RjJXTVN3a05qRnMwa3JQU0p3d1MyaG9tWmNE?=
 =?utf-8?Q?e3gEWjcPRRP49xsFdyxX3W2HlW1b7ZBC?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M0xVOWRlZ21zT3ZLeWJrZzBxK3l2YnRjdmY4UDdrdk1KUFZkQmQvSXNvb0ln?=
 =?utf-8?B?cDFhbSt0ZHNWcFdNd2J4KzZ1Q3B6S1gvL0VlcmhJRHNQNWdkTHloemFMSWZl?=
 =?utf-8?B?cmZ3MDd2VHh2Z0xsSXNSckJnTkJvblIrZU0xOW9IRndtZ2VEQVVxUis4T0lX?=
 =?utf-8?B?V0FZdWxQTS9FcURuSTRUQm1VelRsZ2p0b3YrMGgrRVhuS1J0WUg3NFFzNDZn?=
 =?utf-8?B?Y1RhOEhUamo0NXVwWHBFb3JTNUFWRTRlcjRsSDhyMlpvemV4S2krMkp3SmxK?=
 =?utf-8?B?MkNTbTJwK3kxazhBL0FqZVRiaFoyT0lLZlYrM1BlbWx6UHRTaGZqeGFsMCt0?=
 =?utf-8?B?WE4rR2FhVFlqSFJFL3dKS25sZ3lmeU16eHhWM05qcHdRS3BMWitoV3g3VEZ2?=
 =?utf-8?B?dU5lbllDUkJ6aFVvSDJRZUhNSStIWWVDQ01QUkZsVGNEbnduWWJLZWpsWDZx?=
 =?utf-8?B?dkcyTlJienhzV0hRaVJHRUczV01qQi9iazZUcVZHY1ZJVjJNMXF0dDc3VlR5?=
 =?utf-8?B?UHFuQXVLa2JSZ00ydDBSb045UWYwdk8wS2owTDY5YTQ2WHF3SXZBVjJNRHFw?=
 =?utf-8?B?TUwyT2QveVJzVnNBUUJ0TTVGUE9FUElqL0FnbmZYWXdlMS9udFQwUXlUQzMv?=
 =?utf-8?B?ODl3Kzh2dVd3T01kdUNGZzlzak0vZk1lUjhzc2QyZEhuQVVHdW9YbDFzRlYv?=
 =?utf-8?B?RTF5MmdGWVFCU1I3SW1NNEY0M3NsWnd0THFHcjdDM2VtbHM3VHY4VkppYTRS?=
 =?utf-8?B?R0pCM2l4TEcvaGovVld4eHNmQko1S2g1YXk4dDczamw0cnh6ajF4a0NZdzFm?=
 =?utf-8?B?RWcwa3gvU3Q5N0VQUlRGRUVKTk5OSlZzNkh1bENwVDFRZVZZTlFuWnhNclNl?=
 =?utf-8?B?VWpNMzJOeFYzRE81V1kxczNTSTZlTUtHQlc5ckNTWHZpK2xJeTZUZXBXbllI?=
 =?utf-8?B?Tkd6OGIycHdRNEV2RGF3MFc5SFl0ZWxIZVdnbi9NT0EyYUR5VDNGSzI0QURp?=
 =?utf-8?B?UjRSQXQ0VXpTQ3NqWHpEM1pRaVl0WW5BbzFVT1hpT1Y5cDdwV0ZEc2UzbkNE?=
 =?utf-8?B?RzBpczB2aVB6RWlMSUlJNlVkbTBZdmpGRHlNOStlYUVGaTBkRndjSEppQTZm?=
 =?utf-8?B?cWlJWTE1c1JSOGw5NFF1NFZmc1JpQ3UzMEVuU1pCWmEyeDFncWVSUzlPTm9N?=
 =?utf-8?B?bzRWVzN1OTQvU05nUnpmdUhoTWdoSFhoQXVBZUpJZ2xobWtKNnNpbm5vRC90?=
 =?utf-8?B?ZkJrRnFPMEE3ZTNwdkZGNnphVXdLRm5UdVpzbStBcDVZbmZaUW5uN3ZXNGM3?=
 =?utf-8?B?NEFLQ3M1b25xZTQxUk5YYXRKVEdpenQ2SlRsejl5dlc2dW9WcStHR2ZDcG1E?=
 =?utf-8?B?YXV4ZFYwK1dFWWRiRTRhaUxkU0RKcTBRKzhCR1l2YjVNT21JbE5US0R6dkVX?=
 =?utf-8?B?QkJucnczd3pSUFRuQ09mcXBGeHkzQ3lXdmJ5TnhrVXg4Z2Vwc0cvT01UUUVO?=
 =?utf-8?B?MThzOXF6bW9MU2w0NlZLdnQ4Q3l4b0V3L3ZlWHNNNXZETHV0aHRlT2dTUmFw?=
 =?utf-8?B?R2REOHBRenZkQjhJQ0NkWWNGNEVhT0dWenQwckM1OTRyMVhRcjEwK0IzeVVq?=
 =?utf-8?B?cW92RXR4UnQ5YllWbkNQdnhUaXVqM3psSURXOEFkekd4S2tsTldpUUJkTUtl?=
 =?utf-8?B?MDlFMmg4cm1Sck9reXU5OU5Ed1p4aC9Wa3ZjK2VVK3kzVzBnbDNFQmptZFU0?=
 =?utf-8?B?SEFjZFd1dzJnOFY5TXR0aHp5MTdIUi9rLzh2ZThvV3NjWlJrWTE1eVdub3Zu?=
 =?utf-8?B?eE5NT3VBQnloSi9XcFB1QW1PNFFIWStXVnkzdy9tUlpmWHFvbG54N1lXZjZH?=
 =?utf-8?B?LzJLdVVvTlU5WGwzOFdKOUJacEpJd3ZEYStpekYrS3RNakQyajJ0eWV6b0JZ?=
 =?utf-8?B?ekpUNXRMMlJCNkwxUUR4S1NXWjBtR3RUcXl1aXdpVm9mcHUrUHZ5bDFIWldt?=
 =?utf-8?B?RU9kclBjUDFnc0tRYzFpUDM2NURPanJQWmMxSFZJM0d2NEVHaitwRFNSWDhT?=
 =?utf-8?B?blcyWmh3WU1FS1QrU3pzZ0NkeXJFZGdYRCs4SlJCN1dBc1UxMjJTQ25tMWpJ?=
 =?utf-8?B?RGpLd0JGNmZDVHVQbzRlQzlNSWpWSG1xM25SWkNhYU9HQ2ZEM3RJL1M1K29i?=
 =?utf-8?B?WWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a04be932-ae6c-4917-5177-08de22205666
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2025 19:19:02.0162
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QvrWmejwEZnKe1xwPVIf0IeOImYRrN+tc4AFZZ9UmC/fiuGJbVWojp0Eh5M/d6pUcBKeoyP3YS8ZZAFmfPc9W/ivA/ZK4GiOT7PcEftCKoU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF641CF4859
X-OriginatorOrg: intel.com

Hi Tony,

On 10/29/25 9:20 AM, Tony Luck wrote:
> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
> index 0320360cd7a6..f5a65c48bcab 100644
> --- a/fs/resctrl/rdtgroup.c
> +++ b/fs/resctrl/rdtgroup.c
> @@ -3164,13 +3164,18 @@ static void mon_rmdir_one_subdir(struct kernfs_node *pkn, char *name, char *subn
>   * when last domain being summed is removed.
>   */
>  static void rmdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
> -					   struct rdt_mon_domain *d)
> +					   struct rdt_domain_hdr *hdr)
>  {
>  	struct rdtgroup *prgrp, *crgrp;
> +	struct rdt_mon_domain *d;
>  	char subname[32];
>  	bool snc_mode;
>  	char name[32];
>  
> +	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
> +		return;
> +
> +	d = container_of(hdr, struct rdt_mon_domain, hdr);
>  	snc_mode = r->mon_scope == RESCTRL_L3_NODE;
>  	sprintf(name, "mon_%s_%02d", r->name, snc_mode ? d->ci_id : d->hdr.id);

Please note that this patch is inconsistent in how the functions are modified to access
members of struct rdt_domain_hdr now that it is provided as a parameter. For example, the
above d->hdr.id is unchanged while a similar line in mkdir_mondata_subdir() changes the
d->hdr.id to hdr->id.

This becomes irrelevant when considering the refactoring that comes later in the series but
a reviewer cannot be expected to know that at this point.

Reinette
