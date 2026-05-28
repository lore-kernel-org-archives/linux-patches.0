Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53B8E3FCB05
	for <patches@lists.linux.dev>; Thu, 28 May 2026 16:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779984582; cv=fail; b=s+X5D5eM1X8in8pSYCkTsRmdXomagjLHgWZ6OeXst6Uc6a29UUCx29ktQEWlxLOCWyK7CNUP5pZwh8NCiBF8nya2TO3PGquPk4PO4c50F50HvZSAvfRKGRdOOwqjJkA+tBxbqPoksDZBEOYPrLPsjVyD9OyjPuuNiQdsJSp0eE0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779984582; c=relaxed/simple;
	bh=FH0fjG2yEOWYWwk4Gi8Ujd4L8LvLgUkUGbHpo6zoR10=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NzX4rLiMkSsBbwYX45Iavb6EqqiALKd33ytGojMvdA3gepxj/Yh6HFp4Kz1ONjn/6Oy5jWKEMF1ltbrf+AH+scd25Y7aYSKGjLxWAYanSOzVTUAQxD+Lf5wj9OgyqTVpToxk8ZcIaQgGD36OTjJ7vYs2F6OedZjnRgVKLAkPawQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hoZlWR2A; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hoZlWR2A"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779984581; x=1811520581;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FH0fjG2yEOWYWwk4Gi8Ujd4L8LvLgUkUGbHpo6zoR10=;
  b=hoZlWR2A0muIbPtOPULJg4/amoryDW7CVVQub5CwquwHgohH6fX1o9or
   vtPh1TP5nXFBUewSHWhmFut3mFxj+Mm0/E9ji5cHekKY8BDV2NUmQkz2h
   9/oWd8txYm6b4lEvZbhaHKtGbGEV4CNZWY0V1X0jq+BxNIWiMRg4zdrsn
   /ILdTN/tq/2Qu785pScyB9ZvvYU9GkU3X1bbRJTDF5IQEjj15iyGsgRFx
   JhmEZQ/SSagkbal1NEfrcmaNpHfAhggGdCtS8JJT57YTmO3pNfgklhqBL
   aikfZ7ncVXbhjCGDZHzADy7LzSzaAmTlP0NDOgEoqU7d5xuLKlEzRCrlU
   g==;
X-CSE-ConnectionGUID: tAg9Nf12RnmwD90h8AiRVw==
X-CSE-MsgGUID: 0K0HtYJVT8iyDGJSeNDpjg==
X-IronPort-AV: E=McAfee;i="6800,10657,11800"; a="83407731"
X-IronPort-AV: E=Sophos;i="6.24,173,1774335600"; 
   d="scan'208";a="83407731"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2026 09:09:40 -0700
X-CSE-ConnectionGUID: iwmPY1AmQ2amjw6CrRU6fw==
X-CSE-MsgGUID: Fh9JQMC1R9K/wrLYa11JSQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,173,1774335600"; 
   d="scan'208";a="246611495"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2026 09:09:40 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 28 May 2026 09:09:39 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 28 May 2026 09:09:39 -0700
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.46) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 28 May 2026 09:09:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h1uT2YWrFMV8LvdjEFzVVFtCvArTHt4jWVRmxM8Ie/3bDJC2RrU2F30ai6ac7/PBwogk5+QbH1l3P2t/LhG4ZnpDwPAmC/MYJ0bR9ufEq+VT9CpgIQvMDGakQOxG9ttCnsyS2zVUKTuaS9bW7WuUHFxC8yCv00F+ySwlVqGCGUp+T/X/11vTgUJcoQS7LNhkFmjZKamff2JqQLz8Dr3LL+Vtc5w5SMzEHqmxCZfJmT9k7a/P2CDXGbqmr/+MSLUCa/Wgg4Xqy8Dklm54fn9AMJLQA5LdMCbWghY3LpSDD2IeaPKWSxz+7NBVJVmM9giOGVR5CDp8zoXzwGqEDsWpDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F5GklChTqupNYAhTV4G9C9ZzdsID5KNdD9PJao8Zmow=;
 b=QYFAl96duqXMm1pTA5ha8YDG7QJ4deT9kXjKxXx0QG03EInCTD7iyw1oj2RQXrltwGckjHXmWlwFpDaVWYM/CEtXigHQhgQMzcPYkdcln/+dOxIewpn4lOzovB9hawS7n2IHkfnXFsymX00xerxTzV/msFLXqDWENlslMpi7DEDM3FGd9bMLxijk828Xy+ut4Ih+F8U4VZjGbYnqDri1Kd087SWTTL8QjPNVJ5cafKubwC9Gt5MK7ELIrCKcGBhdd7IRKQRBevqlL1Y+Gt/UoTQzlK4defsrOnOzco3hf+L8wpOVd6Xe0ikQJp43tt50J4uNWlO1WeDjHNbhwFLb0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by DM4PR11MB5969.namprd11.prod.outlook.com (2603:10b6:8:5c::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.71.13; Thu, 28 May 2026 16:09:35 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%4]) with mapi id 15.21.0071.011; Thu, 28 May 2026
 16:09:34 +0000
Message-ID: <d6345182-76dc-4671-87eb-0889cc96763f@intel.com>
Date: Thu, 28 May 2026 09:09:31 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/9] fs/resctrl: Fix use-after-free during unmount
To: Chen Yu <yu.c.chen@intel.com>
CC: <tony.luck@intel.com>, <james.morse@arm.com>, <Dave.Martin@arm.com>,
	<babu.moger@amd.com>, <bp@alien8.de>, <tglx@linutronix.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<ben.horgan@arm.com>, <fustini@kernel.org>, <fenghuay@nvidia.com>,
	<peternewman@google.com>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <0a48bc36304da0fce4525672cca5f41c3d8ae678.1779476724.git.reinette.chatre@intel.com>
 <20260528134810.337000-1-yu.c.chen@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20260528134810.337000-1-yu.c.chen@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0367.namprd04.prod.outlook.com
 (2603:10b6:303:81::12) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|DM4PR11MB5969:EE_
X-MS-Office365-Filtering-Correlation-Id: 79b534d0-13d9-46ae-712d-08debcd381ff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|56012099006|4143699003|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: FPSQdnDFKXaTuvLVH02CQdjpWXLW41tXV2Diw6krR2eJTfJawxtXoPeigI1i7nG1X0QJFoZWiruB5SX5P59sXZ62kbXgXKRMNS5QeVSLP3zTN950RjOUwhnV99DDGntKHP3fpT1Tnl1+m60FPjqjubC5ix7Nw3GqVxWCuZP8RGvLyrcFxHHBqyLzgte3UPqqToxGjEzUV80TFQyn+Gy+3RSTw2MDDxnpFGdWk6Ihp+QT9IwPImZc3TPuZipvcHV5JIkqJUAYyGZh8/+IbqfPJNepxr1GeZNjSCr4xFn24gQxnjvz4EtFgU+PZJtC40Yto2xj3H+E2iiW9IJ1JLIGWnAd7vTcuziqq1w7LsCTU0fZIL56ioiAWU8vvrYZnYOfjuzJJPAckbhe4sMGp8Q+AS9XoFkzh59Y2aozKOB4yi4VtjR7rULUERenOncJODhN0Pd4iLvZ1iu/VQ6EOlAEPMgHS+00cwpSx5rdj6DyTPcX0pa8q6niG4/fblZdpOKcwGHitEsR2tQON9rpkC/P1FQbxq/HgfknNIR4RQa7xXnf5/l35fsh4kEo/IOSlYq6nmVii038EF5bDRz6SF0nDUM1oR+Yvcb/c2qxHReRiFSOJkWjJqOZiJLRc1GUgxB13l1q3G5Apaluuxzxv+JCSQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(56012099006)(4143699003)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Ujlqa3NTVG1RNWpIYUUwT2gxWkhPaXA3SGtmUEJSVHhvMDJlbk0vTjdUQlZ3?=
 =?utf-8?B?eCsya1E4eE1YZDFQVkxNWm1ReGlZVXlsY2wzejV5VU9qaUNwa3NhZHZNZ2g1?=
 =?utf-8?B?VHhRK05WcEdoaWJtTFFUZ0VMYWdPZkRYMnJUTUhpUjcxMXJvYjVvR3RjWFpV?=
 =?utf-8?B?Z3V3bHY5OUd6R3V4dmYxK095dnVxRG5XYUNBOHlISXB5SnFCL09ERnZ6SGRl?=
 =?utf-8?B?TU5CQTI4cjYvaUNWZFlNVDBJNzB5V29KM3F2S0pRc1ExSVViM2lvY3VPTjdm?=
 =?utf-8?B?SU1tRTQ3V0UxTDlQSGthbldHYlpKeVpOdjU3VUxjZWw1czIxMVMvSkxNMzFl?=
 =?utf-8?B?bHFxZ0xlSFNlaXpOeWhiUEczVmlPUnM0RWVsK09nSU1IRFYzMm9meVlKcXIz?=
 =?utf-8?B?M0ZKYnNHeE4vWmwwUDRoVmhCOXpCWFp4akJyVmhGQlVpWUhxRG1WelR6a2Iw?=
 =?utf-8?B?TXhLVjVpZURFWTU1b3czOWZqRk5pTDFiUDRvYXBEV3FJV1FOQ3dHS0hYY1N1?=
 =?utf-8?B?WEMrWlYraHloOHFVa0hsaDRwaW4rTDVTVlhyNWNpaWUxVitaY1MzaWNmZVpG?=
 =?utf-8?B?L1k4ZWJJcy81UmhwTnJIS1JUc2VCQzgzeWJwckoxamRPWit4OGs0QnhtclJy?=
 =?utf-8?B?MVdqV3hQZGJKbURadTlXOUZOUWRaWVJzcmU4U3JCcU9KRkdTMis4SmdlRFFw?=
 =?utf-8?B?dFNnOWkxOWJ0K0Nibms4aUtKRmJGZDhFNHRGUWNhZzRPQ2RwWjZUVkN3NTJQ?=
 =?utf-8?B?T0VqQ016L3BXVnpjSDV4bHhldVMyS3YrVlRkSEdmNkZBenFQRmFJZGhzdEFv?=
 =?utf-8?B?OU5hNHRjdUFGR1A1Ulc5TXNrcFVjUGF4OUJhZzA2bWxMbDg1d2dLVndBNjN4?=
 =?utf-8?B?YlEvVVV3Z0lYUHVmWTBoSVl2TG9tcis3MHRKK3MwakVreGh0VFRSdzN3UHNQ?=
 =?utf-8?B?VURJQXB4RnErdE01RTQyU1I2a0FEZmkyRTdQTkhmdFBoNkdyaE13NklOQmNV?=
 =?utf-8?B?TGlIeU5EQzRCWXA2V0ZiWSs4ek8yZ0s3dDFVenhXeExiTUZEbllGL1RiTEZR?=
 =?utf-8?B?M3hQU2JFUk5QSXpITUNiUlBhVXdESUVRNGxvOG5oN2lXKzlrVjBVVHE2WWxt?=
 =?utf-8?B?K2dJeElBTkZVb3FGbWFhaXg3M3pRMVljYnZWS0Q0djFkK0VCUm01UFgzYUht?=
 =?utf-8?B?bW15SmRoL0puU3F4R2lNVlJNaWdhcGNadXkzd1Jxejd4aksyVHArN2RHaXpQ?=
 =?utf-8?B?RmprV2pRNm0yazdIVXM0aDhjOUlCTDVXaGhTV0Nnbk85THAyU3pwM0RMcW1Q?=
 =?utf-8?B?czEvMnJ6YkE4Nk9UWHpXTnVkanRCMFNqNHVRTnp1bnJQKzNCTUtVS3VQYTJX?=
 =?utf-8?B?TU4vaWtDT2prbk1oK3NyRDRvWGVtblBUTEpDZ2F2UXcrcnBuOXREdDhTeGRJ?=
 =?utf-8?B?VFNmQ2pCcERWMVNVSXhtNm53Mjd2eFpHSzQ3N0MxcnY5Ri9kaGVUbVhSM2NF?=
 =?utf-8?B?d2NJemJFTnoyclpQUVR3UTIxYVp6a3NOL1NJNUt0Q1ROc2pSQTNJbnBhODhv?=
 =?utf-8?B?L2xPZUx6K1IvOXpoR0JnM0J5UHhCeTQ3VDEzWlJkWmVPenFKQmpoN3VrUHpK?=
 =?utf-8?B?Q3hzcEhSS2xJaHdhRGZUd2JDek9zTTIwNzJacXB6S2twNzloS0QxZG1RNVpJ?=
 =?utf-8?B?VXZNQWlvN3BndmFxbnhzK3NRdGZhbG4wekc0MU0xT0dUT0pVYUY1MjJzSytF?=
 =?utf-8?B?cS9zcUtDaFJVcGZQT1V2VUNmTDZ6SHgwSzNmQittTDNJbVlxRGYzZlpnOUNG?=
 =?utf-8?B?Nk9YWTZTQWRjRVlGM0M5aWZMMWZ3L2JaZzdlWXYydkxuc09JR2lGYW5lZE5h?=
 =?utf-8?B?eFNJVWJXUVhJY3JXUlI0ekozY1dPYTgwK0FTODFsc3lzR0hFZVgvL2x4NXBC?=
 =?utf-8?B?SU1FN0lTTDdwOEpZay94VVhlanpMN2o4S21zN1V0WjVQZnVMNTdtN0tOQ2pC?=
 =?utf-8?B?Y1ZwcXRrSGlOWFdWTnZ3MU5qeEZhdXExVmRVbzhPK1lydGhMS1gwR2s3dllC?=
 =?utf-8?B?L2J4WFl4Znc3Ti9KZFhHWWVWSzFjaGgwUVpWMmhFanZmNGQyODRhbmc5SHZL?=
 =?utf-8?B?eWd6M2l3YXQ2d1NNWGczVjBOUDltV0pHdzFNMTUvRXhPOEdWTmtkT2tPQmg5?=
 =?utf-8?B?ZmpUcVVJVWt1ZFdUUTJ4QkV4RnMvQjJteDZ6K2xrWmxVam9ZTDVGTUI1QlFV?=
 =?utf-8?B?b0t6SEtEWUpEM1hUSy83LzdKV244Yk1FejhPZXUwaExlRTFkNEFRRWp6Rmdp?=
 =?utf-8?B?bGxoTGlpRnpENUFjWlRweGhiSEJSc0prdk9DYjc2akNqQkQzQlF2UW4vZVJR?=
 =?utf-8?Q?cKxwH0fhUyUq9OWg=3D?=
X-Exchange-RoutingPolicyChecked: Sw6fXGgB6+2ejrTw/KUGmoEWV/FZRU+kcfOUxiSPaUd3HmsKdjvky0FMsep+m/uhpA1XU1mRG20Cu7yf8FbVe4FyVN500NLnOjTvM3J1iYaDN5fIGraSLdUaKb/5hsxovtenqv60Zdk4L47oB5IIvRH92RmWUKkyxwqwv36JpEJgC7Pi2kZdE06OHyFaCXV4E38yxKDNhH8kVnIJzgAUKUC89bdE+7W9ENENVUR5seY0fBf5Mxb81yOEdO0eABaBbYz+RJVLwbprd42ikynZszFyKfUn1z3gIBazKYFRU0IR1cX3X2WHRHsLlqPt6xJdxtT+mCJzGHXa1WsBTdgjgA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 79b534d0-13d9-46ae-712d-08debcd381ff
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2026 16:09:34.4567
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /zrrqg460Aj6As344k+lrQbgvh9zYe+N6luCVf1P5Ba8jNDZG7SSJBi6ilq2DeBYEFMVT3MX4wCT/bdZ5ndxUD9iZmVwboXpK4xv8tLxmv8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5969
X-OriginatorOrg: intel.com

Hi Chenyu,

On 5/28/26 6:48 AM, Chen Yu wrote:
> On Fri, 22 May 2026 12:15:07 -0700, Reinette Chatre wrote:
>> When the mutex is released, the reader wakes up, observes that RDT_DELETED
>> is not set for the default group, and dereferences the already-freed
>> file private data.
> 
> I wonder if a code call sequence could be added in the commit log,
> which would be helpful to quickly understand the race condition:
> 
> CPU 0 (read mon_data file)          CPU 1 (umount)
> --------------------------          --------------
> 
> rdtgroup_kn_lock_live()
>   rdtgrp = &rdtgroup_default
>   waitcount++
>   break_active_protection()
>                                     mutex_lock()
>                                     mon_put_kn_priv()
>                                       kfree(mon_data)
>                                     mutex_unlock()
>   mutex_lock()
>   rdtgrp->flags & RDT_DELETED?
>     // no -- never set for default
>   return rdtgrp
> 
> md = of->kn->priv  // UAF: freed
>

Yes, something like this will make the issue easier to see. Will do.

 
> 
> I did not find issues in current implementation,
> 
> Reviewed-by: Chen Yu <yu.c.chen@intel.com>

Thank you very much. 
I just realized that I omitted your other tag from patch #2 [1]. I am
very sorry and will fix that it next posting.

Reinette


[1] https://lore.kernel.org/lkml/7f7712d9-2b23-412a-a3a8-e36c22b4ba32@intel.com/
