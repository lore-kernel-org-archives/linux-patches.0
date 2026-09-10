Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEBEA3A1695
	for <patches@lists.linux.dev>; Thu, 10 Sep 2026 04:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789013410; cv=fail; b=YSbz6paSiIJxuT47cEfmlQEpwl+I9TWWElfYKOIVZ2zyLy0UyXW9Yh6XjYqoNuX9uX1/zsfbPagYb8xB/1XSQkVv5jWWacN3zC4gVTdDy4rEpAuT4bt08TkUI8An4bGgtRaIxv6CiL5usHIPPNwNYzvO4jYrdO3cI+YLkghw8TM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789013410; c=relaxed/simple;
	bh=R3n5LBMYiBaNocZJnUguNuTxgqVTc9YAPo0k7OlNggw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SmbmhWoWrqSANfdYK969b6Dho4jUGm54fKSaH9vThYOl4uSon531hU5jbQCxJ0681BEbUpgqc8zbKslNvgYmJHvLt3tHLvTPV06oYDQkdiFP2jZKb6H3o/69X/uKyWXIXWGoAlDzI7hQjdqBIa+8A/S6HVaq2Wru49iLzDbk6b0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=POBKSAZB; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="POBKSAZB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789013409; x=1820549409;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=R3n5LBMYiBaNocZJnUguNuTxgqVTc9YAPo0k7OlNggw=;
  b=POBKSAZBPOe5ekiwmROjjm2ppojsbGD71VdNvOeYWDcyWF7hje0se5c4
   WbdP01OhcY3gfcVpUNYreE+q2c9IUy3uM/1VUJ0fmtEPURqKREHzYaEA5
   GrmG31mTILrPCXiXgbghaeOcrkNc/eQkX+JAZBEztoqafHJvByn/Ku1Zx
   dKb8iIVlUQLi/uSga4iDWbSzQhAHWqE+xFC0konYFywQFVGZr8dBtGhSR
   asbugVR19IvsfB1VDc1KQl+D9yZvZwgWD9iCeN7JM8BKHSmo11e/ZHwyF
   6fvv7fsDmFb15+yY5UhvksiM+N3t94+K/LTX9Tnukkv2J2nf3uzpwGuE8
   g==;
X-CSE-ConnectionGUID: KC5G4XzZQje/4BeUCSA9Ig==
X-CSE-MsgGUID: XYBkmIpER9innoyzzQW7bA==
X-IronPort-AV: E=McAfee;i="6800,10657,11900"; a="91968944"
X-IronPort-AV: E=Sophos;i="6.25,271,1779174000"; 
   d="scan'208";a="91968944"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2026 21:10:08 -0700
X-CSE-ConnectionGUID: sKzqOW0YTvCjuP+NM+KIMA==
X-CSE-MsgGUID: 40zhfuYIQsOqwnAH3uAaFQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,271,1779174000"; 
   d="scan'208";a="296473697"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2026 21:10:08 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 9 Sep 2026 21:10:07 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Wed, 9 Sep 2026 21:10:07 -0700
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.53) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 9 Sep 2026 21:10:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fwHIsyASu6GbGY/SCumIyWyXCpJuH1WF2kdK1sbO7kNi3NuiSg54In0lUH7LolDJaB73Hv8WDd9uvxedyByIOjpQL4p6k/mmhWVDlIlzJS0d0snc6/ikjg+BbQ5AezIISxe3ii2gdech4LDNSN/DUByBwKOJ8pPP3Pvv8a7D90C9gA1JbslIGqIyzwoAi7dCTC4C6DbhaUQQaV/BIpn7T7qf3oewCvPK4mZthFpEuGW7zFEy8AX5e0oN5+6DxDByEwF/Zgu3FWYTjJ3IYLoWQXdWz/H6JDDJVzeGFPIWPGmNb+7zfQQ6c4EHbDcSjUrDDyOIBoVeNYwA3SqneToo7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t4lnvCw1IkCfXBIBz05ZZiOxfYbaV682rCyNVQN2PwU=;
 b=OrG/EvwAf46DKq/hSPtMpd9ehJ52wsAE2u9AeGrD5EdhukJ1qP/ICKk62VKEfeg1aTo43d/wIAsTmfUWzFqBuJ63C+1aFUpDaCsZI94tszOtxYvINcAflwfGDyTbwi4CCTJax87oivnzCS8nRISLoYt/9DnqAzJ1fZRO65ckZhay/OfJdFrQ8HOt/d19YxLKy0ou2kVvvQbMIfmkBkd4srGGmsfKk6v3Kp0WEjNwYsqTHpur8bW4OUsXZy6aKyKjVoiX9rUwl2cuKzw5nEw6bV6AUAQEhcOV6t7sxrOwbALazspDWOdzB4bCJnkxPQ7NDfKxXPjTkLD+sLPQP6DrdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by DSWPR11MB9583.namprd11.prod.outlook.com (2603:10b6:8:36e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.7; Thu, 10 Sep
 2026 04:10:00 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0406.005; Thu, 10 Sep 2026
 04:10:00 +0000
Message-ID: <3f3b4277-7dc1-4fb2-9c32-5e5d5097edbb@intel.com>
Date: Wed, 9 Sep 2026 21:09:57 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 22/23] x86/resctrl: Simplify Kconfig options for
 resctrl
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260831174421.13921-1-tony.luck@intel.com>
 <20260831174421.13921-23-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20260831174421.13921-23-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0051.namprd04.prod.outlook.com
 (2603:10b6:303:6a::26) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|DSWPR11MB9583:EE_
X-MS-Office365-Filtering-Correlation-Id: 417dcbb2-5992-47c7-7aa3-08df0ef161b0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|366016|376014|7416014|1800799024|4143699003|10067099003|4133799003|22082099003|11063799006|56012099006|18002099003|921020;
X-Microsoft-Antispam-Message-Info: cD01JkQNvwhUr2XL6ycVV56aFnGIfvOH1JqhM63y0tDBAXN+kBq4IUpUWxI9vBig+d1CaKmPG7aWo6ABPAFdWapYzYr3djubGA0jGp98ZlpZUX1wqRyaBVtb2MYUr5MMTpzywmRwQgvlX9aObPkxdfQXTPyq2pu0rOHzwkSsv30yYZ8hDlqmNkAZWExn6Twltbjmcr2Z/B5JFZg9jG+b6HQnn+GFlxBxp72l5cJXa1hZkoKFYD2iOXsMgoo+WCM2uO6Yg19PgJYYEgr7FZGkmRp4bRIpTEOtkXoFjWG3oRoapystWwuhpcMFgrMCBCKZrNDKnPQ+F0eO+wwKhIRFnFbFhrtGfyV34lRkZMxP/kZGQGzTctEXBPP4BVDqbScvAB9lvt3MebhcJgkBRauoZy7xmNFX9kIBEF8O7wRxmi2tQv6tUwEwitnICC/5KTlWwSgoNblrqggrXD4DKm9Idwz1AVeCNqf3MJG5lTAcbLP5m3cwmA6l67n4WZCW21xEzwUxQAYbs8TPykKrR093/MvUTHeBDCkpApSagTSLu9VYlbY8paZpKeXUaFTDVqpnAgofdrEYEcajckj+WG+rTf08I/lTIvtmWn1Cfipyo7rDWmKT0C1rP4ankR50AHsODZPCOAKfhxTNQAGEqzZjqVN0Dic+lbhHdDziwu/7HUFlScOSUSuxaxpFskasoff0/4e4PNJ1S/e4trzlfxrn8A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(7416014)(1800799024)(4143699003)(10067099003)(4133799003)(22082099003)(11063799006)(56012099006)(18002099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VzJTQkcwMkQvZ3pydkdRV1RuZHVqTWtTQTJxN0d2VTBnSkJiN3dDYlBrbnFO?=
 =?utf-8?B?UGhVd0dwL3FONisxVjlWTTNaM2d4ZHJaNjQrNUkxTlE1bjZLK2ovbkpJS0RJ?=
 =?utf-8?B?cm1TQmE5VG9vWUxwaElZaFZ6ZWNkVnZtQ2N3TENCU3d1YXRFSXFMaXY1ZWhC?=
 =?utf-8?B?Uy9wVTh6RS80c1ZDM3BoMU1DQk5zY21SejFjUUlmQ0VzMnl1ZDlUelRHVHBJ?=
 =?utf-8?B?dnZqTG9TNk5kVnpWa1MzTzU5WnhOdC9YOTNOV0QrcXcybHdZUEg3bEh3a3o3?=
 =?utf-8?B?b1BCWGpVVmJqb0xXNVdScTJORkplRDZabFBIN2M1b3o1TnpOcEU0WEJoNGM5?=
 =?utf-8?B?UEt1N0VwUEludW9YcGRBRDFRb001RjJlNFB2U2pGbVpaZm54N0NXM1RFN1gv?=
 =?utf-8?B?S2h6elZhUFVJYVRWYVVMUnVvZC9Yc2orWTZxS3VRdkZDelBZcm5FTGdVbnMr?=
 =?utf-8?B?M2lBWGN6K2lIakdoa1FsY3llTWowVjZ1SmZNWXlHRWRDVDZnbkFpSXlxTWZ5?=
 =?utf-8?B?aWROME43TjlhdjRIa3NhUDU3cWNGWmo0clIzeS9DUTUvUkRKbjJwc2htdXpC?=
 =?utf-8?B?UkI2OW9Hdzk5SkYzSENLOTg3Y2I5OFhKNWJVcGZodGg2b0hrZkhMQ1F1ZzFL?=
 =?utf-8?B?MGV1dkpEc3RZWStzeUpuYTJNLzBRSldqM2ZFZS9ZOEFJenVzQ1J1WFgwdTRy?=
 =?utf-8?B?TGloa1hSSHBUejkvejFsajNOa0xBYzgwcVFaMEJZYzhnT2czb2pBcHJoK09x?=
 =?utf-8?B?NXVFY2FBc3laVmJ2L1FlS0ZPWTdRNGlHSjJVNWtzcWlMZ09RME8zbzZHM2R5?=
 =?utf-8?B?bURPcE9FRkpzcmRVem9nSmUrQU1YbUxOYllBbS9EM1lrKzk0RFF5ZDF5Qis0?=
 =?utf-8?B?ZEZWY1BPVGYrb1BtRGFKaFphUTlkUkJ1bFZySHpLODIxQ1BTbHRubDBqU3dE?=
 =?utf-8?B?bUpGbW04SFEzN0J5TmdQL0JPeklkR0I0NTVuZFFscFc2cE9WTWZESjBjVDcw?=
 =?utf-8?B?VkFBMDFzVnducWFTSENwOERkQklqR2JueFRCQWFtd1ZZQnZJeTdoZGUyVFVp?=
 =?utf-8?B?Vkgzby9WbksrQUJXcFA0VnhsOHg4VWFta0VlcnRmcVBkQkxRcDJsWmptQUo4?=
 =?utf-8?B?RTl6ZHFpS1hYalBmR29tV0tkT0krYnFNT1psYkNtcS9JbmxtTnZ2VlVyQ1BP?=
 =?utf-8?B?aUY0bTFrbitNdmdPZkVJYTFaZllHQU5iV2xXMkFkMTErQTZ6SlNKSW14OVVN?=
 =?utf-8?B?TmdGZmpTa2pURjhkbE54Wkp4cGplQnhFOE1aeUQyQkxhdC9RMXZ5T1UvdVJK?=
 =?utf-8?B?ZXZtZWh2ajRlUXBNMTNvVS95eTdiTDNLS3hGamhtK1B1eWd1d2Y2ZkVWV0l5?=
 =?utf-8?B?VHdySGxqS3NURCsxbnRSMFhoOCs4RW5TQkZBcXRMSWR6RnhrOFhHQk5FanQ4?=
 =?utf-8?B?OU85YlZxWCtPZG1ReERUM01sQ3pna0xWS0psWkVJaDRYZWFoSFV5eHpZdzdY?=
 =?utf-8?B?WGFCL0g4dEhNbllVV01NaWU4MXFCamc4elQwN2RLQmIzQXdPV3B2OUpMSTh1?=
 =?utf-8?B?MWdLL1NhZE96Q0htY0dGZ2N3UUQ5ekphUXRPNk01eGhpVWtCZDVaUHdEOFN0?=
 =?utf-8?B?WGpYdm42M2psRVhnSk1raW9ra3ZqZVdOWG81QVhoZnpqbDQ5ZW9UREY5WUVQ?=
 =?utf-8?B?aytaV0xUWWJSZ2hYZ0Y0QVIzMkJrV3psVnNrZTF3SE9mYm5wSUNrUE1XMk9Y?=
 =?utf-8?B?YTZhRlRtZ2w3R3kyb1RjUktaajViWEs5ZUwybnJJY2hucVNqTVZsbTNrSHpp?=
 =?utf-8?B?Y0RNaWVWUGJrVTQyOVdqTWlzMFlWTDBQcFAwWDREdVN5Rmh0SlJ0NGd5WHQ2?=
 =?utf-8?B?U1oreVRLMVBnMHJJZmxhS0J2TkhPWU5kS1FPb2VwTWJVS2ozS3BERmdXNjdK?=
 =?utf-8?B?YUx4YXBOMy9DTmNDQy9UUEFyd3VKeXJ3NkNoTGduWm13WjBJbVgxNGYrbkhJ?=
 =?utf-8?B?anVNQ3MxTmNFanpwREMzdXFyZVJPOEFwNks2RUdVZXNOb1VxZkxFK3NhbGJV?=
 =?utf-8?B?TVBZdytqamFXNnVSS0hKM2oyUVpLWkwwWG96QXZFSjY4SThSN21EQmhIUWxs?=
 =?utf-8?B?WUVaVzhDNmZVRWRWQUFqaUtVT0dXQUlKdnpGOFhIeFRhWlhMVEY2WnZLNDNk?=
 =?utf-8?B?aUJ4blMxaVJpbXZVVnlIb24vODB4ZUJJTmh1ZUcyVnZYdXpTaElhbkpNelRy?=
 =?utf-8?B?MXJ0V1JJU3RMU0x1TXB0N0Qrb1dFWHlOdUdpd210WERGZUZmajR0VnZkdk5w?=
 =?utf-8?B?SjYxaTBLZ0phcXQyTWcwZFJvM3pJTWtHQk9QL0NqdHc3TGxkYnYvOG5qaE5y?=
 =?utf-8?Q?35phWktp6bMnzvAI=3D?=
X-Exchange-RoutingPolicyChecked: W1epeontcM0t0vP7Ss9Pu6Rvi9WjrO5uLfX0wfmxMGyNllpD3l/St2Px3KkObf3g3hDs77M+MCjyQn+UIN2SRzsTIvW6iWgk7dc2PD0YxrtvrBxFezz1kv9Nw+KjhA42iHzp1UrMWJrz5XQN+audIAW8OkiQP2GDFH9HISHxlSram9nP+QoZouYWhx42x5le1M6sv/1cpp3T6CqJGp4h30RUERmX/kJzjfpBMdP18wDAlADLkR0/+ifb4fIEwOJDUIcbcD1gbzBaedrXmJcOFW+GtdRKBYfRTChMVQciw7zwOguXHAyjOufLoHRtciIFAXNDthnQOK5zTomR3A0rfA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 417dcbb2-5992-47c7-7aa3-08df0ef161b0
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 04:10:00.0033
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qBtlQNUXzl5i97rnR/NJ9C/U1fCWAs3B6Pckl8bQ75/0NXHgjNxipscFzVdiwYw1tNTwYM3Dg2uBbaOZ/7cEleHcjuRaE9D5nAr6LcN3CDo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSWPR11MB9583
X-OriginatorOrg: intel.com

Hi Tony,

On 8/31/26 10:44 AM, Tony Luck wrote:
> Linus Torvalds complained[1] about Kconfig complexity making it too
> hard for "random people to build their own kernels".
> 
> CONFIG_X86_CPU_RESCTRL_INTEL_AET has been causing problems since it was
> first added as it required other config options to be set to "built-in".
> 
> AET now resolves PMT symbols at runtime via the registration API,
> so INTEL_PMT_TELEMETRY no longer needs to be built-in. This means
> that AET can be included unconditionally as part of X86_CPU_RESCTRL.

Needs imperative.

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> Link: https://lore.kernel.org/all/CAHk-=whigg3hvOy7c1j1MXFy6o6CHp0g4Tc3Y-MAk+XDssHU0A@mail.gmail.com # 1

"# 1" -> "# [1]". 
For reference, see "Link:" description in Documentation/process/maintainer-tip.rst

Reinette
