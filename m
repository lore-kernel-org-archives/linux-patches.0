Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 725844611CC
	for <patches@lists.linux.dev>; Thu, 10 Sep 2026 15:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789054652; cv=fail; b=NBHDS4cj6H6Mj+c3nOdxz0vqZ1XIl6ZC7TBjR0UQfVsQs7PYiYaqNW1PCGIppjCvldZzBMoHUnpn+9PvYvpSAm1rAwF9sZCOKY32GnEuV6nYTsF/xwOucESBFd3ZatOJbGNicABBcI2B0Yw4igEwg/g9E4mYo2JFDjTTky1OJGo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789054652; c=relaxed/simple;
	bh=gpOGmEPAX4YNoysN85xbfdgBajbYKH4PNwmZKCEmFFc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bOkuAm85CWyFFfPEyxMXg8qsxOC1tKqCNlJo5YR72TFylcxVlNzbXVXXYviy1SXlJ4Wi7X0N+nokp9KewbfIpodsjrRznABRVTSs7d5wW3pY1c4aUYDf8YSnUyxT0LM4zWxTGmIevY32wyFiwooz+ihcLFfzn7XNTJA5JPBL0rg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bR//uCke; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bR//uCke"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789054651; x=1820590651;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gpOGmEPAX4YNoysN85xbfdgBajbYKH4PNwmZKCEmFFc=;
  b=bR//uCkevexIb7gwFsgfKiGU6hTimXsYfrlVKEbGdr9+dZ+jhvrPpv8F
   2tjbdcragNs/3zLDurBwSxBwt1wLClmUNWEQA8J+lCuTQJAftIJrjxgTo
   4CT/oO0iaEhsbYbHjC5YH0G0g8AZiTy5bpb0E2PnohRBPhk9KncWvM913
   GWfC2mX5M53541W5cSqCy02VqBohkaI7Y0OPs6oHvGsy7+MK01XF4ifPb
   8CmCIXGOMUq32HyGgg/9uZHgt4aGcDcA0X47AQEm6WZOyI5RwWv/ywSvn
   C8nPlBhe7d92R9AM2JPJttu19CUvRZ/B+5gmZTm8bKUb/s9EXNmP58Uia
   A==;
X-CSE-ConnectionGUID: WNnSIvwcQLm6WXxgXxoXoQ==
X-CSE-MsgGUID: BDNFBh+nRo6EFoo7jhPXjA==
X-IronPort-AV: E=McAfee;i="6800,10657,11901"; a="89380823"
X-IronPort-AV: E=Sophos;i="6.27,95,1787036400"; 
   d="scan'208";a="89380823"
Received: from fmviesa012.fm.intel.com ([10.60.135.152])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2026 08:37:30 -0700
X-CSE-ConnectionGUID: KFtfgJ6QSzKXxYKXerRfhg==
X-CSE-MsgGUID: ZY2lwlIrQymGbB20jneQuQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,95,1787036400"; 
   d="scan'208";a="23302"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa012.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2026 08:37:28 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 10 Sep 2026 08:37:27 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Thu, 10 Sep 2026 08:37:27 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.43) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 10 Sep 2026 08:37:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yQTHMHKPK4XL8c6nA9dJ+xGQ04IL7zRpis/r9RnNyAokN3TVkcRSz4N+HQHpiyh432BKvPkGp9EPTstpns9PB6J0IzrUUJgJgNClMdz9Yr5Jre9MDe6eUuJwzYVMb6w2Q93Eay8nUb/MzYHah/e0RsmNfCo+wiM1ci8znCxy/16M4+Brzq3lPctBDKmTAEcwwi+l+k+1E3Vgl10yVmzmj7ytz9wm1/mXMHwKc0hq7rWW2/jMqy9rMVZ7XKqHrsxfDh7f5rrUprtOByZV3Y8mdVW4Ut/FYnZQoVHrST9xKygleLrFDHKuHkJBmrNtx5CWBQA5/4fpdjIHE+S9gTOJFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pcb1ZJPlkLh4Tmi4KNptmKo5xUJAe6uMusZREhHzBMU=;
 b=xt5Qt73vI4ol0aboIJigkEIIaP7U9veUsI1LEx0nvEbA3zD5z6qT3T0ZKLSP8T+BtCA2qAJ9obL3EPjMfMA0JHLbNE/HHOfadz5CmTVYMqiFmqW9MZFnSVoqe9HuPi3ae4DesELmnv7K/gk2dz71NtdSiCjT3DVaLCstxN7sn7DbPqnZAQ5LSaAwoVOp0LRbx/Z8YaIemoP2VxAM87gIWpRTAeYMYXWoguthbF0OFiZfXchB95CusOCSrnNQCX4NmEcHs2MTaRItgC2HEBZBz7/xKIOXaEcUKMGVTJzqb61Gjs/m+LeuHcBzHubujJnJkV7zs8ZkCIZlM6wIk0kjXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA0PR11MB8379.namprd11.prod.outlook.com (2603:10b6:208:488::20)
 by DS0PR11MB7481.namprd11.prod.outlook.com (2603:10b6:8:14b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.9; Thu, 10 Sep
 2026 15:37:25 +0000
Received: from IA0PR11MB8379.namprd11.prod.outlook.com
 ([fe80::549f:e4b3:e10d:aaa6]) by IA0PR11MB8379.namprd11.prod.outlook.com
 ([fe80::549f:e4b3:e10d:aaa6%6]) with mapi id 15.21.0406.005; Thu, 10 Sep 2026
 15:37:25 +0000
Message-ID: <26e294a0-76a6-4ec0-9df8-021a76bf8ed9@intel.com>
Date: Thu, 10 Sep 2026 08:37:22 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] arm_mpam: resctrl: Separate MPAM domains
To: Ben Horgan <ben.horgan@arm.com>, <james.morse@arm.com>,
	<Dave.Martin@arm.com>, <fenghuay@nvidia.com>
CC: <tony.luck@intel.com>, <babu.moger@amd.com>, <yu.c.chen@intel.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <85ca29e89eacf12cfa7071249419e7cadb8f0691.1788220029.git.reinette.chatre@intel.com>
 <0b0eef2d-ce3b-48c8-af08-5889e7396e4f@arm.com>
 <a492ffb3-c12e-4986-8f36-c907382c67e5@intel.com>
 <96eda554-64a1-4f1e-9608-98cd106b00da@arm.com>
 <a3cf9362-007d-4c6c-8f6f-1c9b8b41b1b9@intel.com>
 <ad1f8ed5-266a-4d79-91ef-ad8ab3febfb8@arm.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <ad1f8ed5-266a-4d79-91ef-ad8ab3febfb8@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0211.namprd03.prod.outlook.com
 (2603:10b6:303:b9::6) To IA0PR11MB8379.namprd11.prod.outlook.com
 (2603:10b6:208:488::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR11MB8379:EE_|DS0PR11MB7481:EE_
X-MS-Office365-Filtering-Correlation-Id: 62f895af-99e7-4df8-cc69-08df0f5169cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|23010399003|366016|3023799007|10067099003|4143699003|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: fbSfXdF3YD9/lLSP21Nha2BjNqC8gGeS9e5sDpgZ/FW48hEfpsJM17DHjU/YF1UEUr0t4yk4OLNWMtqCZFFfKM5iNtloszxulfaeQ1Fx9ihpR1WBonNoFwPtDML2knoulmU8jCDmzlfS5jaXo77BjoqU2OOuo6Dxc7BUiPvdUPPqYFbH3PKKtFXS37EOdfpPixLcBOOicvjAcQT0yezFYMxEH6vkEs+Enwvv3Hfov+VXxFz+0Dwe9jxYS7Tt4V9IN6oGicL+GC+K6Y+LieEIUqr9RSGUG8NXJaFNuhBuHzHux+sbs7dWfW5dhGWRYilRZguew5ft0dWkzYcV+W4aAf6fBmknDmaGnMnt2SFYo3GxYl3Lo2LXC+pyWa75yrMt6mMZhILsS0BLHZfGq/+g1Cu/oec87CTTN1h50I4yGukQ8aMSX6QGjnQhsmxiVReopVLxv6EYhH58Mb3gN1BvKlPiYTRQNCnYMWgHoiPBBHad/gGh7s/1Yv1yTtaLAgGCs0vsqwYox3QlgQuP060OlFgeRjwUV0MIVQuN4ViBjuWlE+pOH051HuZ/TXWBDcvvWaKD8c08D+qohPAi4aPZuWxBNBg+jqke1Y1B9nYT1E/pLprf9wez0uVp+F2JvzatcBKIJFcE0hVFwy1iw5+ekkep7zn4owlw+av3kRZNu3I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR11MB8379.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(366016)(3023799007)(10067099003)(4143699003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eXVEZ1RDaHFsMmVMcGVUOG44S1V1Y0orUlFaRlVKTGZpeVJLQWx3SjU4ZVZq?=
 =?utf-8?B?MnFuQTkxcEIwYWFCM3Y4ZFdnVUovY2xmQVlFSXdrTFR5QVVNdzdUR2svdkZB?=
 =?utf-8?B?NUdNcWlCU2hjWWZ0T0Rvd2NvajFUc0oybTNxZ04vR3hTMHZ1Vk4zVElMMGdR?=
 =?utf-8?B?dDN4a3FKejhqcDFsbWN4VjZQTmdlckVscGlEeENJcHU5NnlkN055OXY5RGV6?=
 =?utf-8?B?K3Q4ck9OTm1mSXBBWTRFRUQrVGc0dVVGQk1mdmJpb2JLZWFTeEpvdEtvaGd3?=
 =?utf-8?B?QmRLOUN1dXdaUlluUCtwbUpuUTNlZU1NNkZ4SnRvVVhEYXgzamUvNElJRDZE?=
 =?utf-8?B?OEJINGgxajZjd3VSbVlSUXpWTDFVemdHYU5kYmx1ZFJWaWh1anlraVhBdXlK?=
 =?utf-8?B?Y0lvK0kvRHphRjFXSXdSaDI5TGdRc0JSRWtzWVh1WElVOFdTVDB4a09mV1BK?=
 =?utf-8?B?QnFBQ3UxcTE3b2o4NU91Mlp2YW9wM2lNeDI0aHJJajFYVk05WWVhQjc0K0tN?=
 =?utf-8?B?Q1I1YjlBRVdPVExrU0RqYXNiNGNORXBnRm5VaDlObVZSRTI2OFhzS1BiZkVV?=
 =?utf-8?B?eHd3azY1WGFBbUJ0TUhDejl0YUc4dGpWRCs2bVNnVHpMM1BMdG84YmIvc1VY?=
 =?utf-8?B?ZDQzWDQrTzN4bStzWmNLN1hUcnVCRVJIZzVhVDF2Nmc4V0dtbDh4ckdJMjRw?=
 =?utf-8?B?QkJleVBOaXZZM0xoR0ZCeURKWEgvZlNlS1BuampjRzFZaVdGbmpUb0ZGRnhJ?=
 =?utf-8?B?QkZKOW5uL0I4UGc3ZkU0NEdpWGtMSklxNXR3OUdYZ1UxZmxRblY2aWx1WFFu?=
 =?utf-8?B?VnJyK0MvaEZxRDY2MmppNUdlY3p1OXk1Y1FwU2VRc3lOSG9DK3YzQTF5TGYz?=
 =?utf-8?B?aXVBL3dkOXNxYXMvWkN5eCtZR2VxeHFRbWdpYStZd0pVZkVEYnFJRi9IN085?=
 =?utf-8?B?QXorNDVteDMwNkJLZlZ1dlNvay9EcC9WcnAxTGZhdkVqSjh1ZnhwYkJ2cGxK?=
 =?utf-8?B?b0ZLcjJleEJ4QzE3Q2RPR2dpaTRjaGExZ3lYSWNBVHFseGl4SldJTEhET0M1?=
 =?utf-8?B?WG5ObVVWQTBaNXlhenNDalJBMzBEUU5NRWRaNUtFay9ONjlkYUtwemtwZmVV?=
 =?utf-8?B?Y2dSUnB1a3dHTTRlUmltUGx0L3RMZ1hGSkJKS2I2ZFVDcWc3L2NUN0JnRnBL?=
 =?utf-8?B?Zm9tZjRCSHpkVm8wR05ROVVQZnA5cTE5WTZwSXFITkpHZmplOFpXa21xNTNM?=
 =?utf-8?B?Q1l6emp2ZTV5bUowRWQvRDE4QzFoRDAwS0hGMzVCSmEwQ3ZlU1p6TWd6bUxD?=
 =?utf-8?B?bFJTVnJ6ZXcvR3RBeGdQdmU4UW9vdnJIOEUrMUNmYS9nOUpKOWxDZDZrbStY?=
 =?utf-8?B?TXFxTDRMYW91empvNlk3KzRiRENQaU9VWE90RVVzdEtVL0U2aW42YXlvT25o?=
 =?utf-8?B?dkcwTEFlN0NhMlBwS3E0aStNUUhIWWZIUEc1OTZyMU42TFZPZTl5bkpNYm5r?=
 =?utf-8?B?eVhtRUMyMEY4aUtFY0RuNmRGOFk3VGQzOHorMzNjRi9Vcll3VUg0Q2RicnVx?=
 =?utf-8?B?QzBNb0FuVE1hUVBVeW5mN2hlQnRrcE9DWnJzOTlWYUVNNFR5RExFb01DUjFh?=
 =?utf-8?B?MzVxaWIzUDBtK2RmVVhReUR1MUNWVENFR2pacDJYWDJKRHQ2bWlVTzdCUkYv?=
 =?utf-8?B?RXVTYkRKZ2wzL0lwdk9oQTM3WDUyNkpkcE1GRlQxa1RFdS9kaG14NG1uQlNI?=
 =?utf-8?B?d0lvejVzbEVsRUJ1L1AvK1k4SmxUTnV0M1lCeThsZXJtakl2Mng3TzRPSUU5?=
 =?utf-8?B?YlFiRWt4d2VkWnZGVEdTMkRXcTNMUzZ1RVhCd1ZhQnZBUVg4NnVmN1U3bFhG?=
 =?utf-8?B?bVRKdTVlay9hWEVadmEwcS9PWHUrMS9DejY3R09GcDFOc29ySmI1WnVPSE5j?=
 =?utf-8?B?My9vNWkvTkNHMWRHaytVbS9VWDJ5SG5zZ0dKL2c5MmR3RHpHeFpTc01TMzA0?=
 =?utf-8?B?NUQ2RzBhMVJoZ3FwblNNVVNFQmpTbHk5S213ZHo5NXA4czRwdmNKUnRaNjJ5?=
 =?utf-8?B?T1FhcVdXRmhKdDFQR2NhT1g1YVlCblBVejIzdDhxTlJyOXlBc2hMSDRtQmVS?=
 =?utf-8?B?OVVVRlNmVjltUmR6R2VtZHM5STBsQTZKcnAybWxwQTNkUk4vc0VyNVNjNU9C?=
 =?utf-8?B?M0NFcTdEUzRlVW5kV1dqcGVZeHRMYzkzUFJDcEdGUVlmdkhOdkg1OWRVL0Fu?=
 =?utf-8?B?b29Kb2tWTHVlUUU4UytGVVZFcnJlMk82dUlsMTFRVlNQVzcxZVdtVzBoOHM0?=
 =?utf-8?B?WXQ3NWRGK0ozOGl0d0xBUkgwZmIyNDJzdzhXYUZBT052bUpPNHdVQXUyTmVz?=
 =?utf-8?Q?pbVmhOwONUxr5v8k=3D?=
X-Exchange-RoutingPolicyChecked: Tfgz8ckbk17DuJYwu3S1l0LkDIfou20ysca+E94BtoXYz4JNINw1xZnz8Vwrdcl45KCxZaVbJZ+UMwCUVuv4iQK1Url928c5G166RCrAWtKP4f2s+gGtInHcLA3dxG7bsxohX7j9TTsESHU1WpkceJHaZLAOgV8nTVcCdYhMsLzoDEem4x8sHGDx/jZ7EolZ5DrrMF9ieArd7yCHU4FZqoLPLcVruA2K8krJkX9LlBOx/fIuWSFCnLVz+QNe0zbePeQEQgYY/4obbnKKhG50m0OKaUuNdGysB3Z+ARpTe6wYvza/rt/NN9EOYml9gIoXmBuiKgoLGVtF2Zngf/eDyg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 62f895af-99e7-4df8-cc69-08df0f5169cf
X-MS-Exchange-CrossTenant-AuthSource: IA0PR11MB8379.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 15:37:25.5322
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cZZB9fRu1+dS482Bw8yNr1qHXGLL1WZtOIWiKBkj1sndhh3xlTrVoXY6pMJFUwFOYqp3n+TheZeA7OT2UqtMv58S+4GOdEeronsGrLTm0k8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7481
X-OriginatorOrg: intel.com

Hi Ben,

On 9/10/26 4:11 AM, Ben Horgan wrote:
> On 08/09/2026 22:12, Reinette Chatre wrote:
>> On 9/7/26 10:01 AM, Ben Horgan wrote:
>>> On 03/09/2026 16:29, Reinette Chatre wrote:
>>>> On 9/2/26 9:10 AM, Ben Horgan wrote:
>>>>> On 01/09/2026 00:54, Reinette Chatre wrote:

...

>>>> It is not clear to me if a mon_comp of NULL is able to handle all scenarios since it looks
>>>> like mpam_resctrl_get_mon_domain_from_cpu() and mpam_resctrl_online_domain_hdr() does not
>>>> consider the component at all. Would that not cause monitoring features to depend on which
>>>> CPU of a domain comes online first?
>>>>
>>>> Could mon_comp perhaps be required to be !NULL here as a replacement for the earlier
>>>> "ctrl_comp" check to ensure there is a component with the CPU in its affinity mask?
>>>
>>> Doesn't the !any_mon_comp check provide this?
>>
>> This is the part that I do not understand since any_mon_comp seems to support the scenario
>> where a mon_comp may be NULL which is a scenario that I do not think resctrl can support.
> 
> Ah, I see what you are getting at. As the monitor components are only considered when there topology
> matches the l3 cache (same cpu affinity for each instance) then the find_component() call will never
> fail and so mon_comp can't be NULL at this point.
> 
>>
>> At a high level there seems to be three affinity masks used by the monitoring code:
>> the CPU affinity of the component belonging to the control resource class, the CPU affinity
>> of each component supporting each monitoring event, while these are three separate masks with
>> code sometimes treating them as though they can be different they are actually required to be the same?
> 
> Monitor component CPU affinity is enforced by topology_matches_l3() to be the same as the L3.
> Additionally, traffic_matches_l3() adds extra conditions that mean that there can be considered an
> uninterrupted link between l3 and memory and so an MSC at either end is effectively the same. Namely
> the same restrictions I've mentioned before, only a single l3 cache, a single NUMA node and no
> intermediate caches.
> 
> You list two rather than three here? Possibly you are also thinking the MSC cpu affinity which can

I did mention three masks. Thank you for clarifying how the one mask (the "ctrl_comp" one) is associated with
either that of the control class or the same as the class associated with the first event. 

Regarding the other two masks: it seems to me as though the CPU masks associated with the two supported events
are managed separately. This means that theoretically the class associated with QOS_L3_OCCUP_EVENT_ID could have
components with different affinity from the components of the class associated with QOS_L3_MBM_TOTAL_EVENT_ID. A CPU
being onlined could thus be associated with QOS_L3_OCCUP_EVENT_ID (resulting in mon_comp being
initialized for this CPU) but not with QOS_L3_MBM_TOTAL_EVENT_ID (mon_comp is NULL for the same CPU). In
this scenario, "any_mon_comp" will be true and the domain created and onlined while it does not
actually support both events?

...
>> I think that it will support the multiple control work if this is done upstream first.
>> I will incorporate your changes in the next version ... I believe that would make you
>> a co-author?
> 
> I don't think co-author is necessary as I've just offered review and you mentioned you'd already
> tried out the new structures. Up to you though.
Let's see how the next version goes as I become more familiar with MPAM.

Thank you very much for all the insights.

Reinette

