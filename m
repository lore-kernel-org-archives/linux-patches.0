Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A0C43E3D89
	for <patches@lists.linux.dev>; Mon,  4 May 2026 17:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777916643; cv=fail; b=hnlf8zyKCyqqvn8YQv9p5r8iBGreJnLSC5AxDnBMjrGEovv0Y2ECnr1D4PlZRebfYHLgTgdKs9rbsNhDQx86kQDe8pff1nIp+fanOlG6++2JRh6+mts5D4als0BGJC5uzspJdD8QtFAjDLIOtb0ZE3w1zl6nox/94WI5yLn+zGg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777916643; c=relaxed/simple;
	bh=sFVoPNaIMARtnbHBwqRZhyRrpWDfctxLAQ9YDlty0GU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UDEEuI4ddBdiOWPnzRkYKgG0fVysR/eZ3SIh07JPz7dKo7xXpeRIIlD/KQHx3U3OvSa3jgWpdo97993rSdfzy96wESf5AI3DMR1NBYTD38DQchK9RJkeneAd4WSRfjwoprzgw1slUDGlBEZXoZILzLYfeBxmHUATcaieLOPCepA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BSpFQDIr; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BSpFQDIr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777916641; x=1809452641;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=sFVoPNaIMARtnbHBwqRZhyRrpWDfctxLAQ9YDlty0GU=;
  b=BSpFQDIrc/J6Vxpjz9GHvYCDT59tZgrfGcU+BCFpMkP/FmwU3ClJv1iU
   Oq16sH7HfNn9gq5zgmN6vCIxmnRU/Caa+mTK0VaAl86SKy6gduOtChlFh
   SwVr6iFpajhcJcvpUSVi1vo8WYa1Zx8OzHNSMWyZlQjXCXbgqhl+T6dJa
   B6qtE/S2vEZYAHBkqbOUdZ7lKei0NP4xhl2oW8TiTAHDbdkVJPeB4RwyV
   0qga5+MaLY3p6M3aCzipP2FhhdBn1cxBn2t2JjT1Rcc2tOZ7lPYlivTgN
   /anGzl0kCG7Ih5XjFD8cpZuHzFS0oI3xWQogbEKQ1X92LFBo9emSvUvqQ
   w==;
X-CSE-ConnectionGUID: W0Ls93T+ThmGBSwyCL1b3Q==
X-CSE-MsgGUID: nDyxlSVlTe+WVmBnhMzLUw==
X-IronPort-AV: E=McAfee;i="6800,10657,11776"; a="78710134"
X-IronPort-AV: E=Sophos;i="6.23,215,1770624000"; 
   d="scan'208";a="78710134"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2026 10:44:01 -0700
X-CSE-ConnectionGUID: jZyU35paRZ2Q3Pfuc+nGCg==
X-CSE-MsgGUID: XewcnoqTQG6n6KmuX7AEsw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,215,1770624000"; 
   d="scan'208";a="234559640"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2026 10:44:01 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 4 May 2026 10:44:00 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 4 May 2026 10:44:00 -0700
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.25)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 4 May 2026 10:44:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oURAL/II2kdLUtEClrTx7SiYXHSHRAIE48oB9c69VDEpFQr7ewYnfqnGyJyA6CHR0FtWEFRB9hxdqCz12cYl+QQWPke9Iu/AZ6NBlRCnQ+wsQh1jASsgl9CM3X2b67GdgW4N1MwutcGAhNz3yFTraOoF1UpbTZryaj0fX3I04Jd5ZF6qA6hcITK7tjQ0Nze2wv0abyY9tSJT1FN8d2cF1c2D6qnRSxdl2xyMn7w+oSrVqLlP8vp38RZ34n4cd6TEpHJZwgxBdzHDsFpdQsUYd1bvCfsV5KL22hJQ+QEGLJ9crvt/8aEe1Ry8wRW/MHjGtazLvFlNNWPTkVHXT9j0AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SyJlRx0laGCbVWMXx+c/Gor+HJDGg98pK9Mp0kjoPH0=;
 b=TUfgvc2xqMXiiEm2zUH6fX8qWWTFy+++eb1fAsZA17EsyYREBoGThq7UzwMD/L9ku1R7AbPBSt7Qf08o2Yy7ZE8jbXxu3H385e0v9nN69KQlA0huVzIh2HvHBlzwc90SsnkrZm1/+axh/cD8hNeJsG46D9BNVjnkX2nukH80hm9cPmiqerXpLMay8EyeKgif4PWwX3dGK3fIzMmiRatVgEXd/JIjNeOznpwTNLAR/OkqQ3CmN+5FVlfAHMFnKnb6ESz5n2nU+bJlczNlRQJun8apDKgKayoyxY/ZIPfNtdAgmPLrHRkfVjEvdbeUXjhU8ufHFQK1o69XYmejgFx0WA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ0PR11MB6621.namprd11.prod.outlook.com (2603:10b6:a03:477::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.25; Mon, 4 May
 2026 17:43:55 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%5]) with mapi id 15.20.9870.023; Mon, 4 May 2026
 17:43:55 +0000
Message-ID: <51bc4f90-2979-4102-b503-930dc69ca517@intel.com>
Date: Mon, 4 May 2026 10:43:53 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fs/resctrl: Fix deadlock for errors during mount
To: "Luck, Tony" <tony.luck@intel.com>
CC: Borislav Petkov <bp@alien8.de>, <x86@kernel.org>, Fenghua Yu
	<fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260501185612.14442-1-tony.luck@intel.com>
 <1cdef1e9-e484-4929-be2a-793e42a49cca@intel.com>
 <afjIXKwVpSAh5kAA@agluck-desk3>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <afjIXKwVpSAh5kAA@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW3PR05CA0027.namprd05.prod.outlook.com
 (2603:10b6:303:2b::32) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ0PR11MB6621:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ed88635-81d3-49f5-7d57-08deaa04b6b5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info: wsuQuNKM5ATgzCy64Jb17QYPVTqX6F6E1BmdBmPI5Ed0GjE3t5mavViKQ8hvlsjxuTQuWB94++OnbJK6NCmE7CvSLgTU+ekaFZw1gOY8gDGI5EXuM5PyLzV62VU4wHvBpoz0+7i5XWcJmwGSpXfPGBWSRDLYYjfY2O+hjmKeGZ1tlIkVOuqzNIRn6UMDS8bGil2e6LQOLEzpEVm2hc8BkG3mR1OY300iPN93ldfyhlr9f5b/CFhoLHNzQllK0YJ75wA/5MkdZjD3GExT0dU3IUhdguSruYJ6aYh5KdLExjw1q1Q4SgRePWzdrsUXLcEoG7govW5e4iR7l4/OOCjgZIufweAeeZA5UbTqDDuCiv5KaMaUw8gdG+HY9uO6RBw8jAS3N/4IvP2zz14P2L3IjU2f6moxDd8ei3WGj+U9UhL6D0fy4SUbj0jazayh9xi+PTHy6iLlROUsy0igxNaBQSA2ptc8e1DCUwIkCkrY2pUBjX/2ffzGfjXAgFhp/pw/WWUrtomcCeDAuNkSpEJhfu58EZGjTUckhwyO4voHXUoC97MPZuN8zXpUpe/K2bkbQ8be1GCxsLAXCPZB4tG9+kgz4LgoOI/wferf8SgafefqFRYbuQw9r1VB2qwueXpClL0El2jRMDLyNiBfQh7Y3RqszV2NkWynCoJjqC563Pz811Zx/IWqkK4p7Rfn5X3r
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TFd0eUVDb1o0NWZiOGQvTzFTZmYyVEFLajJHWHNiaGRXVnlhUkVQSzNvays0?=
 =?utf-8?B?ckFMemI0K2c5WjZaL1NBdHV1RnVQYmV5bWdDd3VSMXRTQWMvUEx6ZWlha3VJ?=
 =?utf-8?B?ZXJlckx2bnpackdVK2N0V0Y3YTNGS0JObTNSNmpXTW03cUJtZmlNdENqODVk?=
 =?utf-8?B?NksxNlFJTDdoS0daMGg0UW1BVk5WSGdPRDVmL0wzZEtRQmRZV3RFR1VRdEtV?=
 =?utf-8?B?UHE5WjlmeTdncklZMWJsS3oxSk1nUzhwMWtWU0k1alRZQmNLM1pPdG51MlFD?=
 =?utf-8?B?TjdOSFdpUzdXQzl1QnhVRUxnVFd5eUFYT3BkV253aklzakVOVmo0d2Z1UEN5?=
 =?utf-8?B?YnhiS3dYckxHeU9yV1BVdjE3dUNUVUw5R21WYjByRFYremtVU0Z3WVUxNWNn?=
 =?utf-8?B?dzJneEhsQUNpK1pIcXRSZ3RVVUk4T3puRkNhWkJpK2gyOG5OU3RjS3l1Nk9D?=
 =?utf-8?B?S0NIcVpwSkpXTWRHVGxqUWl3YWtOb2kyV1B6Q3NaeFRXamtmZ0R6QWlFMDdP?=
 =?utf-8?B?aS9HZCtlNnVtSy9TeTE3RERrd1E4NEhEVWRnRHRJRWdON1BxcVI4Q3Nwb1dU?=
 =?utf-8?B?T1VOa2wxK2VHU3RDZWE1QlJ2NGViUjhDNExBUTRmbWNpc3JNejFFb0puM1d0?=
 =?utf-8?B?NEZ2U3FqNTIzS3YzMUlVUHZJTTNRaTVoa2gxV2lEbDd2dWJteGZMdUNLdEZi?=
 =?utf-8?B?NGdORGRadzI4TWFlWXFIeGQyTHRiWjJwQm54OVpRZGtYRmYxR3E0QTlyRkNU?=
 =?utf-8?B?SkVzZURpUjRXZExubktkTjFyK2doWWFzUkpNRGpUbDZvYUlkWUhUQkxLME9Y?=
 =?utf-8?B?eFVGdGZ1T2VoVEdQdXM2ZnNHaGtZVjlMSHBiUGpubFZWOW1sdG5mSXJ4UE5a?=
 =?utf-8?B?eXNJUUMrcnZJNVJYc1RrQkFxbUM0N2dVNWRKQ1JwdWFkWTZwWjBMT3hiZmov?=
 =?utf-8?B?WjcyRVJDM01XTTV6amVXYmZwUk9JQ2FaN1Z5WEM3R0diV1FGNVc1N0tsbzlW?=
 =?utf-8?B?cnBOQ3VIdVhQd0ZtMEVGWTdoM1Fxc2FEWFRhVzhrNjNtOFZHVUU4YnJ3WHlK?=
 =?utf-8?B?cm9uM0hWanRXajdPVnhCMTdHUzlCb3BJSjBpbEJFcHdnbWlZalN1Tit3Myta?=
 =?utf-8?B?OXBoRi9rSVQwMTZaT1Rrbjd6M092eEFRUjdFZUExbVpWVTZRc0FlakVZbVpi?=
 =?utf-8?B?Y1NrVGxyZ2NaYWUxc3VyMHBjNnRYcHpxaGh6OGVmVjJvM2t1ZWpkTGVNcVFO?=
 =?utf-8?B?REZsU1FmdktrMHErREZJQVhOQ0U1eGtDZFdaRGlETUx1M1pZUUJUcWZXd2FU?=
 =?utf-8?B?UXZlR1VicDl4bk13UWYwR0xHOUFKQUVlUmQ1ckNhRjkyZFNYRDdtV2F0YSt1?=
 =?utf-8?B?Q3ZJYUJZeFFRWUdxalBNN1RZa1h5eXNCOXRSNTJTSWVoRGZ1Y3hpV2JNSy84?=
 =?utf-8?B?SmR5U0ZHU2wzYVdhUHgzSTh6dTFCbXFiRkI5RHljaHd6dXZGTzZ4aUtpSng4?=
 =?utf-8?B?U2JSMjNQQ2hveG1UcXJjUTArcmh0UGpGU2xuZ2FYVWxrSEhEMmpIMDNKZ2k4?=
 =?utf-8?B?NWFXQUhYN29mSkdqd3Y3SUJXREFXMEwwMW5pOVpkeG96eUwrYUkvT0l0bjFl?=
 =?utf-8?B?Mkxpa3YrSFdrM1dOMjdCZ1NwRTM4WllFcmpIQU1LKzA4NUdkb1JCSzBDS1Vx?=
 =?utf-8?B?c0k3eS8xOGlnb2tYRmsrOUVPdWRwNmptWjd1YnJWZURjUXR2OFRxSWJnZU4y?=
 =?utf-8?B?b09Faktid0tneUU2ZmxCY1hXcHN2aXhBUGVxa1dYYzQ2bC9iMzd6YlZndWlu?=
 =?utf-8?B?emdHTDg5U1dxM05iNG1raWFwOE5jaDJhc3ZvNUFUeWwwY2w0ckgycld3WmNj?=
 =?utf-8?B?VS94bG9TTGdLNzFGODRCNGt3S0NrMkNOU3Q3bzJiZnpPR1ZObnNtZVFQc1NP?=
 =?utf-8?B?MytIYjQvRW56UWdQWGVaN0laVitqQUhYTFJ3L2JOaU0vRzF0M0gvbzA2UUNG?=
 =?utf-8?B?cWRNa3h5Q0hQL3Y4dFhNdlF2MTBjU0M5TGdkU0ZueDJJRXUrdnl0KytvTnNM?=
 =?utf-8?B?bFJRYVAxZytIbC9KdDhTbllHMTNIRklTZWlEakwvMWZjSm9lYWxkeDdZTVRt?=
 =?utf-8?B?TnVWSXliRHFKemlJaEtHeWxMVmdvdWhzNEJlRjBlOUJMWFJLWitudnBCZDZo?=
 =?utf-8?B?c0lxbWl0TkJYdUhyVytHQTZ2Q0JXZXFsd0JHamh1WTZlS1FnSHlJOHphNGx2?=
 =?utf-8?B?T0gwT0VyOHpJbURSVlFLZ2o3aWUrcXlwSVF5NVVDNTZqTUYzSzI5SGZtU1dP?=
 =?utf-8?B?Q01yL2ZhTHIvSjBOQ05oMHV6ZlhiYmQyNVNXL2NTdHNhc250T2kvUHlTTFQ1?=
 =?utf-8?Q?6m0x5CllwjtMlFNU=3D?=
X-Exchange-RoutingPolicyChecked: LUgpjOsd1+W3PfaS2QG4TX0ml+SUq2B530AhA8nKAKiKuzrwYTECRZQnz7jcfzRIyQbUWH5jfAVsFAq3ASttctszdmZ4jJusrmLfHg7PiNi6yUavzPlejIf48f3lQgXFR3PsKK7rY02gRkHd2TTVTFW4hPAwaKdfcnYFwtKXBa9AV72bTVNCcAYHxI+Yk3dK5L5Bxs8/rhVmKhNa6Hg0rJ8lopEQxnbkvscVHugE9RuAazsW7kJbzR3Lt1/19NhscT0J6sxO5KhljddsZgddwarK0ZcTO/lbPFj6ant1mTGpuL+Dbxf6vZ9LO4g6Mp3l7sKwEWn/sby41Y9G89a1Jg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ed88635-81d3-49f5-7d57-08deaa04b6b5
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2026 17:43:55.7750
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ydB0B8U8yQZhXpwfU03b1avxqL2v9GwHsOMg1eK20bNff4QqkbptOyQoo0tb7uen/F5Q/8hdD9UEQn6HKvIG3Kb1YXlBu0IQ8981JflASIs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6621
X-OriginatorOrg: intel.com

Hi Tony,

On 5/4/26 9:25 AM, Luck, Tony wrote:
> On Fri, May 01, 2026 at 04:17:18PM -0700, Reinette Chatre wrote:
>> Hi Tony,
>>
>> On 5/1/26 11:56 AM, Tony Luck wrote:
>>> Sashiko noticed[1] a deadlock in the resctrl mount code.
>>>
>>> rdt_get_tree() acquires rdtgroup_mutex before calling kernfs_get_tree(). If
>>> superblock setup fails inside kernfs_get_tree(), the VFS calls kill_sb on
>>> the same thread before the call returns.  rdt_kill_sb() unconditionally
>>> attempts to acquire rdtgroup_mutex and deadlock occurs.
>>
>> Thank you for addressing this.
>>
>>>
>>> Add a boolean rdt_kill_sb_locked flag. Set it for the duration of
>>> kernfs_get_tree() and check in rdt_kill_sb() to determine if locks
>>> are already held.
>>>
>>
>> ...
>>
>>> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
>>> index 5dfdaa6f9d8f..8544020ef420 100644
>>> --- a/fs/resctrl/rdtgroup.c
>>> +++ b/fs/resctrl/rdtgroup.c
>>> @@ -2782,6 +2782,9 @@ static void schemata_list_destroy(void)
>>>  	}
>>>  }
>>>  
>>> +/* Protected by the serialized mount path (rdtgroup_mutex + resctrl_mounted). */
>>
>> I interpret above to mean that every access to rdt_kill_sb_locked can be expected to
>> be done with rdtgroup_mutex held ...
> 
> The comment could be much more descriptive about locking and limited use
> case.
> 
>>> +static bool rdt_kill_sb_locked;
>>> +
>>>  static int rdt_get_tree(struct fs_context *fc)
>>>  {
>>>  	struct rdt_fs_context *ctx = rdt_fc2context(fc);
>>> @@ -2855,7 +2858,9 @@ static int rdt_get_tree(struct fs_context *fc)
>>>  	if (ret)
>>>  		goto out_mondata;
>>>  
>>> +	rdt_kill_sb_locked = true;
>>>  	ret = kernfs_get_tree(fc);
>>> +	rdt_kill_sb_locked = false;
>>>  	if (ret < 0)
>>>  		goto out_psl;
>>>  
>>> @@ -3173,8 +3178,10 @@ static void rdt_kill_sb(struct super_block *sb)
>>>  {
>>>  	struct rdt_resource *r;
>>>  
>>> -	cpus_read_lock();
>>> -	mutex_lock(&rdtgroup_mutex);
>>> +	if (!rdt_kill_sb_locked) {
>>> +		cpus_read_lock();
>>> +		mutex_lock(&rdtgroup_mutex);
>>
>> ... but here clearly rdt_kill_sb_locked can be accessed without rdtgroup_mutex held.
> 
> A much better name for this flag would be "resctrl_mount_in_progress". With
> The header comment noting that it is set-and cleared inside
> rdtgroup_mutex protected code, it is used only in rdt_kill_sb().
> This specific use case seems safe as there are only call chains leading
> to rdt_kill_sb():
> 	1) Error cleanup from failure of kernfs_fill_super() within the
> 	   call to kernfs_get_tree() [rdtgroup_mutex still held in this
> 	   case]
> 	2) From user call to unmount the filesystem. In which case
> 	   rdt_get_tree() must have completed successfully. Any new
> 	   calls are blocked from changing this flag by the early exit
> 	   based on resctrl_mounted.
>>
>> It appears that while this change claims that rdt_kill_sb_locked is protected the
>> implementation instead seems to actually be "this works for the scenarios cared
>> about here" which I understand to be based on considerations of how the filesystem
>> code interacts with resctrl callbacks _today_.
>>
>>> +	}
>>>  
>>>  	rdt_disable_ctx();
>>>  
>>> @@ -3189,8 +3196,10 @@ static void rdt_kill_sb(struct super_block *sb)
>>>  		resctrl_arch_disable_mon();
>>>  	resctrl_mounted = false;
>>>  	kernfs_kill_sb(sb);
>>> -	mutex_unlock(&rdtgroup_mutex);
>>> -	cpus_read_unlock();
>>> +	if (!rdt_kill_sb_locked) {
>>> +		mutex_unlock(&rdtgroup_mutex);
>>> +		cpus_read_unlock();
>>> +	}
>>>  }
>>>  
>>>  static struct file_system_type rdt_fs_type = {
>>
>> Did you or your AI assistant consider running kernfs_get_tree() without rdtgroup_mutex
>> and CPU hotplug lock held? Consider, for example:
> 
> Not considered. Thanks for the suggestion ... But, see below.
> 
>> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
>> index 36d21652616e..9ee6295d6521 100644
>> --- a/fs/resctrl/rdtgroup.c
>> +++ b/fs/resctrl/rdtgroup.c
>> @@ -2892,10 +2892,6 @@ static int rdt_get_tree(struct fs_context *fc)
>>  	if (ret)
>>  		goto out_mondata;
>>  
>> -	ret = kernfs_get_tree(fc);
>> -	if (ret < 0)
>> -		goto out_psl;
>> -
>>  	if (resctrl_arch_alloc_capable())
>>  		resctrl_arch_enable_alloc();
>>  	if (resctrl_arch_mon_capable())
>> @@ -2911,10 +2907,10 @@ static int rdt_get_tree(struct fs_context *fc)
>>  						   RESCTRL_PICK_ANY_CPU);
>>  	}
>>  
>> -	goto out;
>> +	mutex_unlock(&rdtgroup_mutex);
>> +	cpus_read_unlock();
>> +	return kernfs_get_tree(fc);
>>  
>> -out_psl:
>> -	rdt_pseudo_lock_release();
>>  out_mondata:
>>  	if (resctrl_arch_mon_capable())
>>  		kernfs_remove(kn_mondata);
>>
>>
>> This seems simpler by:
>> * avoiding introduction of additional state (rdt_kill_sb_locked) with unclear protection,
>> * avoiding double-cleanup on failure (rdt_kill_sb() called and then all rdt_get_tree()'s
>>   failure path),
>> * maintaining symmetry with rdt_kill_sb() by providing it the state it is
>>   expected to be called with (i.e resctrl_mounted = true).
> 
> All these are excellent points in favor of this approach.
>>
>> >From what I can tell it is safe to call kernfs_kill_sb() on failure of kernfs_get_tree(),
>> but this needs to have been be considered as part of this submission anyway.
> 
> Looks OK to me too.
> 
>> Oh, maybe there is a new lock ordering issue with this that I am missing?
> 
> I can't see any lock issues.
> 
> But ... there is a problem. kernfs_get_tree() can fail for many reasons.
> Only the specific case of failure in kernfs_get_super() makes the cleanup
> call to rdt_kill_sb(). rdt_get_tree() has no way to tell from the error
> code from kernfs_get_tree() whether cleanup has been done.

Thanks for highlighting this.

From what I can tell, kernfs_get_tree() can fail in two places: allocation of superblock
fails, in which case rdt_kill_sb() is not called, or allocation of superblock succeeded but its
initialization failed, in which case rdt_kill_sb() is called.

It seems reasonable to me to expect that rdt_kill_sb() was called if the superblock was
allocated. In this case kernfs_fs_context::new_sb_created is set.

Could kernfs_fs_context::new_sb_created be used instead of kernfs_get_tree() error code to
determine if cleanup has been done?

> 
> Plausibly I could do some surgery on the kernfs subsystem to make kernfs_get_tree()
> take a second argument "bool *did_i_call_kill_sb". Only other user is
> the cgroup code. So this might not be too invasive.

It is not clear to me yet that additional flags are needed to support this.

> 
> Or, I could fix up the comments to justify use of "resctrl_mount_in_progress"
> Also fix up rdt_kill_sb() to look like this:
> 
> static void rdt_kill_sb(struct super_block *sb)
> {
> 	if (resctrl_mount_in_progress) {
> 		resctrl_clean_up_failed_mount();
> 		return;
> 	}
> 
> 	... existing unmount path code here ...
> }

I find the reasoning about safe access to resctrl_mount_in_progress to be very
complicated. It is not clear to me that it is required when considering existing
kernfs_fs_context::new_sb_created. 

Reinette
