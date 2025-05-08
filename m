Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CC8F27B4E0
	for <patches@lists.linux.dev>; Thu,  8 May 2025 15:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746719617; cv=fail; b=mL412YfEKAeKppRlmw3J+HosTVItE4z9hZ5qS/v+9bvAe1DZDjiBRi6V3EN63guMkXJWPt0+Lm798Rx3A3k4mCWYV5nc2NnRZRbmf6SC8LA0CuUXusU7JYYPzlA93X9fYsxIcQUAmgnBt4sLEVyqqnA/zGmNlv0jbR8yvFPUahA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746719617; c=relaxed/simple;
	bh=GMAj+9wvVt+U9x3KJ9gmpXZBdV7AH8jg2TGetFdIkZw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=IpvvtM+J9XTpRn0AWlQIZQIAvzC5Fo4AY0pY7+zRtN3Tc7u17NXcpYXnJAFSK6KgyveR28w69ZMJj5m2pf2LidcPdh5q229t6GZLpasC/DJU2bn3RXuH26UeSPnSCdAZa6EfNj4tFM20SVTmn2a7xL19b+lDWrYYIEneVJvaDs8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PHy72Xel; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PHy72Xel"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746719614; x=1778255614;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GMAj+9wvVt+U9x3KJ9gmpXZBdV7AH8jg2TGetFdIkZw=;
  b=PHy72XelxLOM1xeyOKOcVVWQL1++ATV1YR2AM8gLr0vzaztSqcsyempn
   mmKzkmfGcJs5XdNiIPGKN7dh5TdTqag6uQtgZkK0fZzC1cPoqUFUytaPY
   9HC6Fd2VYv7+vyyOm9/KDURyxpeo8XX1bfJDISBqXCpoDVb2tuoqGPxv4
   4EZ54qARE8vAmukoHKe+BAsAwuB9U9lXbxsH/8H6ouZJPwxlAeyhtAu+8
   qQ7d5Dl+3Y1s4SnHQhcNNzVqTKIC3kJvXwipT1z21k8SMkA+GUn0ZwAib
   uaqKlj2SQrex0DVYWD+JYbZX5h2VLWsqfBjH2jrKZil9DI1NgkA4kTA53
   g==;
X-CSE-ConnectionGUID: P+0nix4wQciHoKmpgw+oIQ==
X-CSE-MsgGUID: rwDCaeUlTL2URsrHvci45g==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="48423077"
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="48423077"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 08:53:34 -0700
X-CSE-ConnectionGUID: MmhhFWOhSGG0O0OQawxCPQ==
X-CSE-MsgGUID: B777biIsSj+YEcya71Akbg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="137268684"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 08:53:34 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 8 May 2025 08:53:33 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 8 May 2025 08:53:33 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 8 May 2025 08:53:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=raUwYKKcGeRj7RnHZlE7zBrMlbrIcHDgdacoPc8CJjbcjiRNoRsBJ+M4Z/D9OichEtrxbqjyOC2aFV2go/oCMjkTtZgcqR8TkCYn9Rf3yz2xS/AoBaZ1az8ZN5iplNBjZ+ES+M6XFkYQ1uvJl3aeJh2VE8mO8hSl+irQsE9omLyLmC8Qmf1mgCcpMMBm6wPcMsQS5TvBIWKHLOb3T7AztZlJTrcj0euwmZ1J0F2VXKkU8zImBCS0a74zqU/egtfXeyr49L7YPPl0ZlBx7x+9E/XhGzYDX5NY3DqWrHqALlg4RJRECGAJmxf9DqI0gF5OQHk4TzZMUvdTEQbEP/l23g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gy/hTbw34+Sp1t1QAA+MugI4OZ8MSP36Lx+rUEEll0M=;
 b=gJ2rLN1pmc39Weopj58AngJD2pu4JYsAWEM6xFgadwu8FvgWlwPVaPbD/B7DrUF9qi4j+PQD3zyahFhTK5cNVdqWIpGOT2dwhULroi6t6dRqZ2DWGhwIu2xNK47oQRm19xUAQ5shpNUpzDJcncC/VcqDvMgMoMHHLUDDt7Zl7TwDvsWUXXMiiHlsPSh/7bwEMdDQtxzwyvMIzzy2VNtZqHmvAU53AykxcnYj99sJfHWX9aDboWRqP9rxNp5IyIBQbpUBR/sP8SF+Nu9iLP5D2aG3knW068fTtK0/NiAdTc0s6tlP4GHqvQMVkknlwyLWkOjTeIg1wECgwahTz+Wq1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DM4PR11MB8158.namprd11.prod.outlook.com (2603:10b6:8:18b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.21; Thu, 8 May
 2025 15:53:26 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.8722.021; Thu, 8 May 2025
 15:53:26 +0000
Message-ID: <85c670f4-e34d-46da-8458-b7233a902a5f@intel.com>
Date: Thu, 8 May 2025 08:53:24 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 16/31] x86/resctrl: Add first part of telemetry event
 enumeration
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250429003359.375508-1-tony.luck@intel.com>
 <20250429003359.375508-17-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20250429003359.375508-17-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0240.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::35) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DM4PR11MB8158:EE_
X-MS-Office365-Filtering-Correlation-Id: 86f23258-8f3e-4d8c-1479-08dd8e487802
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|921020|13003099007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cFBuTjRnY1lyQks4dlZ6ZmtqUW1MU3JJU1FBdi9Lb2F0enQ2a1IxcHpDQ29C?=
 =?utf-8?B?ZDhPbHVTbUpQY3pCZFBmTGQxZHh2aHg4WHo2UjFRWDZQQjRKMFl4OVZiZEoz?=
 =?utf-8?B?ZnJ5cWF2SkdBVlpTOXYwK3REcGt5enRsS1padXBkWVhXb04zZElpeXEzWERp?=
 =?utf-8?B?aTNXbWNGSUxnK0lmZlMraXRhQk5NZ0VDeitsaU9wMk5TNk9NU3NMRmo0a1Bw?=
 =?utf-8?B?R2FBM2Erb3BYSXRzc3FzVjk1KzdiQUR5ak85czNabVg4amlvbUo0NENsZFBO?=
 =?utf-8?B?d2dpRVI3SHVaSTRSUTFyQ3BJUXBJRE9WdGV4SEttZ2E5SllabUVrOVFQWDFo?=
 =?utf-8?B?M1dvR05IcUwzeG9SdURJeUVSSGJyZGgweE02aElCMzBaNTZOWlROZEFzSCtF?=
 =?utf-8?B?QTh3cjkwVXlyZjdrTGdYeUE0bjQwOUN2bTkzN1dDWTkrbmZVRHJoRWdYbWpZ?=
 =?utf-8?B?bW9iVnB5WUN0bVNKbzJzbno5ektqMFZoNlk2MGlHY2drZmFoMWlQUjRtZWJl?=
 =?utf-8?B?SmZacENqOG9yOU5CWUh2NjNGNUV1SDU0cm5yU0U4bkU0c1dFbnBRWGZEVzhC?=
 =?utf-8?B?NDZqK1ZTOUl2S0VxWk1WcHFKenA5ck1OL3c5bllsRTMrRHFqUlZKSURCQWt4?=
 =?utf-8?B?Z1RNRW9IZkRVUjFPUksycHFlNW12K04xMVRZOU5xcWYzVjkrajY2N0xJSUMz?=
 =?utf-8?B?YTkxWWlRcW9IQmRDOWNpZXI0RDBVMVVDU3pWZFJzVGJqRy9SVTNRZUpBZ09T?=
 =?utf-8?B?QWhZV0FNTks5eExiM29WMmRBL05YKy9HSVFFeHBnbVYvR1dYTFhkUGxYZStQ?=
 =?utf-8?B?Rkdvdm1GRjNYUzl5ejU5S0NzNlMzb1IwZHFhK014M05PTzBLb2JXcDYwNjlV?=
 =?utf-8?B?S0FZc3VwMFI5dUlzVU1SSjlDc2lpdHZYaTN0MklMck01S0tLNUI5YjFMbUNG?=
 =?utf-8?B?ZFZqK1dVMzJJZmFIU0xyNVhNZ3cxcUJseXcxYTlmRnRFRGc3eUVEaEt3UmtE?=
 =?utf-8?B?NDVPbEVwc056WkZ0bW5NZ1N1MHBiaVNDZ1ZMY1daSkVpL01hSEs1dmlMVExM?=
 =?utf-8?B?YzdIek5HaFdxUDJKclJxQ1VCcTdNL3htZ0JzaTdrTHJkYkFKYkxQTVlqTUhx?=
 =?utf-8?B?eWVROTMwQ0tnY3hPMVk0VkhMMHU0YjI3TEhMTzZwYXU4R1hTSVdRQ2tmMURS?=
 =?utf-8?B?YXBzR0VHNTlLR0NTdHM2WmhyeE9tbGpOSVE3a3dUNDJJUVZaSEVPVEZOa0Iy?=
 =?utf-8?B?OGRUQWVaR1U2REh2NFMrb1NnNzZwTllMcW9IeXEwbWtIN1V1b2ZnVUQzV3Rv?=
 =?utf-8?B?UU16Qm5jaUlWeFVzR2pEZnM4a3B4MjgzQU16ai8rZmszSHJsMkcwNG5ReE5i?=
 =?utf-8?B?RE5NNStWTml6YkFGaUNpcUdnMThUbkhNTWVINkw4OXBBanhaamR1SEVob2Nn?=
 =?utf-8?B?ZkFsY3ZON1ZhRnoxc3UwQjliaXJXQTgxQ1QzWkpWZEFZc1UvY3lTL3hONFBS?=
 =?utf-8?B?Z0kvT3ZhVWl1M3loRUp2cGJnUGk5STRrdHh1ZXd4ZVk5bnhNVGFvbUVPbzBs?=
 =?utf-8?B?Z3UrQ0lnTDFUYlRwaVNLZHVJWi84Wk8vR2VyOG52RzBzS1ZQTnVxeFVMZ3M5?=
 =?utf-8?B?U0paVUFWWDFTMTM4TGtucXBqVkd1dW9CYkJYY3RWWDREUUswTlJyc1BwVmY0?=
 =?utf-8?B?ekhIOFpJaFVVQXBFZWFTTUNVSkYvV3loM3VHbFBTMGJqRnc3SmQvNlcvWEth?=
 =?utf-8?B?eWsxYzg0a0ZEeEMybTcxck9oOGQwV2VEYlArU1o1YUFHa0Zla084OHp0emww?=
 =?utf-8?B?MDlJNmVSeENtZHcxVFJ3NmVQQllKZS9XL2VlSnVwZkN6S3NkV1Zhc2I4TVRr?=
 =?utf-8?B?b0I0TFNWVEdacHlPSS9GTFk3dVhGVHhiSzFDeDgyYUZTL29TeENvT3R6dDRz?=
 =?utf-8?B?cGZPMjZLMURuNlZwcm5JZ0x3Y2w4M1V0MC9YTFA5ZTZqV3Zpb2tHQWZkZE5N?=
 =?utf-8?B?RjNCSUxJVWtBPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(921020)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WGVzeElwSVNoclZEVU5KekJuS2RtY1NjUDJweHF1Q0V6WnpXTkFnWWEvbGJn?=
 =?utf-8?B?ZW5Wa3NEUmNaMkw5Z2diamkvZzlKOWRpOEdTY0RoekpPeUluZkova0hyeDJ2?=
 =?utf-8?B?Q0FHNXlQQjNNdm9HVi9DUzZwRDZPamRYZ1dOeFVnaHEwbnBpV0hWZG52Y2Vp?=
 =?utf-8?B?Q1VtMVdURDFXaE52Q0NPRENCdExtRnIyazkweTRyTXhnanZWOWdPZ3l6S291?=
 =?utf-8?B?Tzl1dDdsdDIybmxVTVFsNTNkbFVaY1RPUjFMQVZWd0Rkcm5yTWpjbzA3Z3RR?=
 =?utf-8?B?TG9FV0FPYUpoOWlybTMrbGNRNUM1NXgxWHF4Y0pTWTQ2Yk1qUGNZMG54cm9h?=
 =?utf-8?B?YStZQjR2L3FlVmpkUjd2ak9qcGlEbjR4ZWR1MnFWemRxVFhvYW1zYlR1clV2?=
 =?utf-8?B?MFVDZjhMY3gwUHpXVHFNWFRFa290aVpWck1tYVlQL293WEd5STFudFN1U0Y1?=
 =?utf-8?B?U0JNN09qZGJySUl2UnRoTDUxOHJlN0VuVmphY2xxY2xHNzV3cWNOa0EzVnBU?=
 =?utf-8?B?dWUrZFQrOFgyWlB2eThpQTc5QkJwNEFFdWEwQW9kcGNKTldTeDNyUG5tR1BB?=
 =?utf-8?B?N0tMN2tSUXpsQ0xjR0VxUjNpS1RxK28vakJiWXZUeW01VFFMdGdoS2hzOCtE?=
 =?utf-8?B?VDBsSmRyMGpJTzl0MTJpQThHRWhrYU9NOUxoUnpqNVgycDlOY21UQjFPc2Vx?=
 =?utf-8?B?RUFacXdodmlRWkwyUDYwRGF1YkRzcGU1UUVJZHVzKzFkY3c1dG5nVlhsbkp2?=
 =?utf-8?B?dHpacm5DZEFFQ2dGT3NGdFhTYzcvcGgxOU9HS2Nya2dNZjIxZVN1clNKbWZu?=
 =?utf-8?B?d2pmbUhmR1hFazVreXJSNE5malNZTU9Celh3QkFUR01xZy9tbm8vVnMwZlRJ?=
 =?utf-8?B?Qnd6Y2xYdGIyMkF1STd1T2NkeG0wWXdjd1F1WXVOaGZQeFdzc0lDK1BWeExv?=
 =?utf-8?B?b1N4Nk5wMzBRNFN6MHFFcDBYQW91WlRvYTdyeENucHRsRkpGKzU4NVdHYllD?=
 =?utf-8?B?NzgwbTQ4bDM2Y09UajVaZzBnNnl6VTdCYVhQWE82ODBrd0NabEhZY1hIQXd6?=
 =?utf-8?B?QjZuWGJyMTBveXRRQnpEWFcrc1MxSzk3UnNYUkpmR0R4Q3RoNDhYVmdOSFBq?=
 =?utf-8?B?YWRUVWFFR0NIWXREQVlMVXprencycXp0V3ZCVFZsRldQc2JjOGtnV0xZOW1V?=
 =?utf-8?B?RXlTY3k5VzNVNjhiRE1IeDU1Z0p0Qld3T2JhUFR0TzRka0YxSlRUVDhUQnN3?=
 =?utf-8?B?ZTZYQkJiVHhuRXBVcEpFL1c4MDZ1TENqdDFrZktDU0lPRGVvRkYrTjhLWkxY?=
 =?utf-8?B?UHBmbERvWWFMOXg3RXI0N0luSUs1ZUdrZGo2Zm5KdjhQTk1xYmdKN05kNC9t?=
 =?utf-8?B?ODhZZXMrVGgxZ1E5SGJNRkJIWHJwTjNWTEIzeWFWWHRGbFVqRHg4WnNMbEZY?=
 =?utf-8?B?Q3VtUDJDQ0h2ZnB6bnFDQzNGMmhWbjhwR0k5ZDdwZU9uaVFCZVpuS0dGZjhq?=
 =?utf-8?B?ZEhiRXdZQVJpSWwyR0ZPN3I4QW50QkFOYnUxYm9naVVqZGxLcGpPVmd1d2pD?=
 =?utf-8?B?SkMvaW9zYklaNUxqSWgyZGg2dDhncGw0MWNGazAyNXFuMGVzakIwa2xNRkVS?=
 =?utf-8?B?YjlsZHJlclpac0Y1dzhkakt5cUJSWjNjdWw2eDVTWlVhNmdSSlZtUjArcmhx?=
 =?utf-8?B?MlFUWHMzUUYrWHkwa3lCQkd6TUpVTFNEM1p5bVkzT0ZKSFR0akxnV3BKUjhY?=
 =?utf-8?B?QzR6dzRFQVV1a1E4TzcvemFrTlNINEQrV1YzZ2h3YnVScXJBL2xYVU1xTFlZ?=
 =?utf-8?B?Q2RBbUoxblJleWp1MTRmZ053aWtHcFZ5empiYm9WODJ6KzhQSFMzREh6Zitl?=
 =?utf-8?B?bERvaTlGYm9Udzdud1BsSENsb2ZDcDg4TUZLbUljLy9aakRYbFpmZk9yR1Ni?=
 =?utf-8?B?SDRqVUc5NDhjS1ZOYlEvTXc0cklYd093VExyQk5JYVdIUUlyWWoza2NWL0lq?=
 =?utf-8?B?cnEwYzE5R1JSUjE4YldleEV0a2VjaU54U3RJdE5Sb1UyekxMRlBWWWFUYjhY?=
 =?utf-8?B?R0hBTWVRMGU1dEhsaTkvRWNGV3A0eEtBTDEzRXJCdEw2UiswNnZSMXNUdDdR?=
 =?utf-8?B?TE1Db1V6MHowV3Vza0IvWjBiZXlvQ3lGOE1ORVhsRVlrdUZjdnQyMlA0UTZi?=
 =?utf-8?B?QVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 86f23258-8f3e-4d8c-1479-08dd8e487802
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2025 15:53:26.0799
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ouVTH6DV5hONxDXyBiVlXf52Kdm4ANF/twDS0n448O6/QAc9r77TShjsGktR5fCHIow/3gpW4TJBoa8Y4z+5VEKpX7dx/1fAkB334oCNouA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB8158
X-OriginatorOrg: intel.com

Hi Tony,

After working with this series for a while and needing to jump between
patches to understand how things fit together I would like to please ask
that you replace these "Add <num> part ..." and "Final steps ..." shortlogs
with something descriptive that reflects what the patch actually does.
This will make it much easier to jump between patches while trying
to understand how this all fits together.

On 4/28/25 5:33 PM, Tony Luck wrote:
> The OOBMSM VSEC discovery driver enumerates many different types
> of telemetry resources. Resctrl is only interested in the ones
> that are tied to an RMID value in the IA32_PQR_ASSOC MSR.

"RMID value in the IA32_PQR_ASSOC MSR" -> "RMID value that can be used
in the IA32_PQR_ASSOC MSR"?

> 
> Make a request for each of the FEATURE_PER_RMID_ENERGY_TELEM and

"for each of the" -> "for the"

> FEATURE_PER_RMID_PERF_TELEM feature groups and scan the list
> of known event groups for matching guid values.

This is the first (apart from fake driver) mention of guid and it
is mentioned in a way that assumes reader knows what it means and what
the significance is. Please add more context about what guid means/represents.

> 
> Configuration to follow in subsequent patches.

Please avoid "subsequent patches" in changelog.

> 
> Hold onto references to any pmt_feature_groups that resctrl

How is reader expected to know what a "pmt_feature_group" is?

This work relies on a new separate feature that introduces new
data structures and itself introduces several data structures.
Please help reader to understand how this all fits together.


> uses until resctrl exit.
> 

> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/kernel/cpu/resctrl/internal.h  |   8 ++
>  arch/x86/kernel/cpu/resctrl/core.c      |   5 ++
>  arch/x86/kernel/cpu/resctrl/intel_aet.c | 113 ++++++++++++++++++++++++
>  arch/x86/kernel/cpu/resctrl/Makefile    |   1 +
>  4 files changed, 127 insertions(+)
>  create mode 100644 arch/x86/kernel/cpu/resctrl/intel_aet.c
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> index 83b20e6b25d7..571db665eca6 100644
> --- a/arch/x86/kernel/cpu/resctrl/internal.h
> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> @@ -167,4 +167,12 @@ void __init intel_rdt_mbm_apply_quirk(void);
>  
>  void rdt_domain_reconfigure_cdp(struct rdt_resource *r);
>  
> +#ifdef CONFIG_INTEL_AET_RESCTRL
> +bool intel_aet_get_events(void);
> +void __exit intel_aet_exit(void);
> +#else
> +static inline bool intel_aet_get_events(void) { return false; }
> +static inline void intel_aet_exit(void) { };

Extra semicolon?

> +#endif
> +
>  #endif /* _ASM_X86_RESCTRL_INTERNAL_H */
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index 4d1556707c01..0103f577e4ca 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -724,6 +724,9 @@ void resctrl_arch_pre_mount(void)
>  
>  	if (atomic_cmpxchg(&only_once, 0, 1))
>  		return;
> +
> +	if (!intel_aet_get_events())
> +		return;
>  }
>  
>  enum {
> @@ -1076,6 +1079,8 @@ late_initcall(resctrl_arch_late_init);
>  
>  static void __exit resctrl_arch_exit(void)
>  {
> +	intel_aet_exit();
> +
>  	cpuhp_remove_state(rdt_online);
>  
>  	resctrl_exit();
> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> new file mode 100644
> index 000000000000..dda44baf75ae
> --- /dev/null
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> @@ -0,0 +1,113 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Resource Director Technology(RDT)
> + * - Intel Application Energy Telemetry
> + *
> + * Copyright (C) 2025 Intel Corporation
> + *
> + * Author:
> + *    Tony Luck <tony.luck@intel.com>
> + */
> +
> +#define pr_fmt(fmt)   "resctrl: " fmt
> +
> +#include <linux/cleanup.h>
> +#include <linux/cpu.h>
> +#include <linux/resctrl.h>
> +
> +/* Temporary - delete from final version */
> +#include "fake_intel_aet_features.h"
> +
> +#include "internal.h"
> +
> +/**
> + * struct event_group - All information about a group of telemetry events.
> + *                      Some fields initialized with MMIO layout information
> + *                      gleaned from the XML files. Others are set from data
> + *                      retrieved from intel_pmt_get_regions_by_feature().

Please see "Structure, union, and enumeration documentation" in
Documentation/doc-guide/kernel-doc.rst on how a "brief description" is
separate from the full description.

The "some" and "others" is quite vague. The members themselves
can have snippet to indicate where it is initialized from. 

> + * @pfg:		The pmt_feature_group for this event group

This comment does not add any information. 

"Points to the aggregated telemetry space information within the OOBMSM driver
that contains data for all telemetry regions ..." 

> + * @guid:		Unique number per XML description file

How can it be sure that it is clear to reader what "XML description file"
means here? Which XML file? The structure description can expand what is meant
by "the XML files" and then each member initialized from it can have a
"(initialized from XML file)" or "(from XML file)" snippet.

> + */
> +struct event_group {
> +	struct pmt_feature_group	*pfg;
> +	int				guid;

Should this be u32?

> +};
> +
> +/* Link: https://github.com/intel/Intel-PMT xml/CWF/OOBMSM/RMID-ENERGY *.xml */

404

> +static struct event_group energy_0x26696143 = {
> +	.guid		= 0x26696143,
> +};
> +
> +/* Link: https://github.com/intel/Intel-PMT xml/CWF/OOBMSM/RMID-PERF *.xml */

404

> +static struct event_group perf_0x26557651 = {
> +	.guid		= 0x26557651,
> +};
> +
> +static struct event_group *known_event_groups[] = {
> +	&energy_0x26696143,
> +	&perf_0x26557651,
> +};

One has to study this series further to understand where this is going. At this point
the data structure seems to be unnecessarily complex requiring (what appears to be)
a lot of unnecessary pointer wrangling. Reader can ask here ... why pointers, why
not just an array of structs?. Adding information to explain
this choice will help to understand this work and make this easier to review.

> +
> +#define NUM_KNOWN_GROUPS ARRAY_SIZE(known_event_groups)
> +
> +static bool configure_events(struct event_group *e, struct pmt_feature_group *p)

configure_events() is an unexpected name for a function that returns true/false.
There is no explanation for this and reader needs to read following patches to
understand what its purpose is.

> +{
> +	return false;
> +}
> +
> +DEFINE_FREE(intel_pmt_put_feature_group, struct pmt_feature_group *,	\
> +	if (!IS_ERR_OR_NULL(_T))					\
> +		intel_pmt_put_feature_group(_T))
> +


Please document get_pmt_feature().

> +static bool get_pmt_feature(enum pmt_feature_id feature)
> +{
> +	struct pmt_feature_group *p __free(intel_pmt_put_feature_group) = NULL;
> +	struct event_group **peg;
> +	bool ret;
> +
> +	p = intel_pmt_get_regions_by_feature(feature);
> +
> +	if (IS_ERR_OR_NULL(p))
> +		return false;
> +
> +	for (peg = &known_event_groups[0]; peg < &known_event_groups[NUM_KNOWN_GROUPS]; peg++) {
> +		for (int i = 0; i < p->count; i++) {
> +			if ((*peg)->guid == p->regions[i].guid) {
> +				ret = configure_events((*peg), p);

Unnecessary parenthesis?

> +				if (ret) {

This introduces too much confusion. It is custom for "0" to indicate success but this uses
boolean that is an unclear choice for a function that turns out (looking a few patches ahead)
to be complex. Please change "configure_events()" to have proper return codes. For example, it
allocates memory and when that fails it should return "-ENOMEM", not "false".

> +					(*peg)->pfg = no_free_ptr(p);
> +					return true;
> +				}
> +				break;
> +			}
> +		}
> +	}
> +
> +	return false;
> +}
> +
> +/*
> + * Ask OOBMSM discovery driver for all the RMID based telemetry groups
> + * that it supports.

This comment implies that get_pmt_feature() is an OOBMSM call?

> + */
> +bool intel_aet_get_events(void)
> +{
> +	bool ret1, ret2;
> +
> +	ret1 = get_pmt_feature(FEATURE_PER_RMID_ENERGY_TELEM);
> +	ret2 = get_pmt_feature(FEATURE_PER_RMID_PERF_TELEM);
> +
> +	return ret1 || ret2;
> +}
> +
> +void __exit intel_aet_exit(void)
> +{
> +	struct event_group **peg;
> +
> +	for (peg = &known_event_groups[0]; peg < &known_event_groups[NUM_KNOWN_GROUPS]; peg++) {
> +		if ((*peg)->pfg) {
> +			intel_pmt_put_feature_group((*peg)->pfg);
> +			(*peg)->pfg = NULL;
> +		}
> +	}
> +}
> diff --git a/arch/x86/kernel/cpu/resctrl/Makefile b/arch/x86/kernel/cpu/resctrl/Makefile
> index 28ae1c88b2ac..8b4603cad783 100644
> --- a/arch/x86/kernel/cpu/resctrl/Makefile
> +++ b/arch/x86/kernel/cpu/resctrl/Makefile
> @@ -1,6 +1,7 @@
>  # SPDX-License-Identifier: GPL-2.0
>  obj-$(CONFIG_X86_CPU_RESCTRL)		+= core.o rdtgroup.o monitor.o
>  obj-$(CONFIG_X86_CPU_RESCTRL)		+= ctrlmondata.o
> +obj-$(CONFIG_INTEL_AET_RESCTRL)		+= intel_aet.o
>  obj-$(CONFIG_INTEL_AET_RESCTRL)		+= fake_intel_aet_features.o
>  obj-$(CONFIG_RESCTRL_FS_PSEUDO_LOCK)	+= pseudo_lock.o
>  
Reinette
