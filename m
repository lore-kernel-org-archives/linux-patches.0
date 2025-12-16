Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02411328B7D
	for <patches@lists.linux.dev>; Tue, 16 Dec 2025 21:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765921704; cv=fail; b=jXYPpSmVsmlfXY2ONLqKQpMBWEXgAWjYZkG1hfqHBIkzlYqfWqIFoJei4r6Vh+vpaybiTiRzJNNYTVU4jtZtNqjtjmaqbBXfRDNoK3b13SAOaD9fPrirw/ftwbcpQ86jkNf2hJdgtvoondLk0z08xw5mAQo4IPKhwqukxySxl7U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765921704; c=relaxed/simple;
	bh=Z7ysgUg7fRmnmCd7AGN2LcStlz0PleSofHiv9zkHB7I=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=N2i2EZWhnfRiC07dvRUeWPkSxYTG7nnpDJxy8c8k7ns3vas9d57ynCsq2vFEmDyuTPVmWBNrG73MUHSoBGwgXUgmt99vAJSAJVg17PC9CG6ThTxbi5Bw5eQMtQMOer4G1OFUQWkUlvUeriDoTn8K/SFTvNXNeALQKXwVYID3ud0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HSSw+jTA; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HSSw+jTA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765921700; x=1797457700;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Z7ysgUg7fRmnmCd7AGN2LcStlz0PleSofHiv9zkHB7I=;
  b=HSSw+jTA2juZLQgH256XIgc5blf5mNG7+xPqSvusWPvxcIyjVOvkMt/K
   cGB95/M5OldOa7T6CZrWYxk1ymB3n017brtS5Teg6VwRHcxlOsGXcDlKD
   9pVqOiunfcBHJ7tS8Rs7RUgeK/3VdUndCII3rzUdNg441WtJJCvOz82/M
   cGi2HyABgr6G7h8N2J5cF9/ge9KUscOg7VLbLbC7suJ2/WZWnsGAF2AAA
   jZZezYHUebKiZ1wOinIcNQjsKOMFFqy5WwltgbOvn0wYS3D78sqAxlURl
   ow4xMHCSlM+TUvoPOwtA9Vn5oNcWyBqIntH6AH4SEM5RZ7lE+ddcSx19K
   w==;
X-CSE-ConnectionGUID: HyECQiU6Q0KIkVGvEOXPaQ==
X-CSE-MsgGUID: 2XzZ0UcHSsKpto+9y7J9Qg==
X-IronPort-AV: E=McAfee;i="6800,10657,11644"; a="67733976"
X-IronPort-AV: E=Sophos;i="6.21,154,1763452800"; 
   d="scan'208";a="67733976"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2025 13:48:15 -0800
X-CSE-ConnectionGUID: iTG6UXBCR3yVQtoF/PbYTQ==
X-CSE-MsgGUID: f3Rff1DyQmaoIxrYcb83CA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,154,1763452800"; 
   d="scan'208";a="229199036"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2025 13:48:15 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 16 Dec 2025 13:48:14 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 16 Dec 2025 13:48:14 -0800
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.13) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 16 Dec 2025 13:48:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UXRrfG9LOGtms3U1AIGqMhnTefNJgwVSbMeZII+/hhkcZSbGo17LKaPjyjFOHT89vqsDO8VpVeeOQhYu3TeT2c6IIxAAC3eekksU/mY60tmqASPuLp34VI9qwoIKZVimWdGEqbUVoMAb36Ef/h2famqkRcinyiR0CzdlJg4JUAkQuCIycQlzFyBcXw0hpJ/IYRz7Oadj0FyM7Iik2c6AjrnGdGPVu5Sd+OBWC8qbGzE8pkD6HUWweJsQoN7j8mP/Vlw/vAjXSdjMuG9Wi/rQ5RuchVNgqxSHhv3dOx3l0AddwZJulFklNVQHlwUqgFQAIhMrg23wHs0NB0GA7i4xkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P4r7fzw3r97Ad1pGSV87n5X0f5YnC/8vFqKD4A6N4xo=;
 b=MFpLQw+e2idL0ffCvWREqZ+eOsGTSyXUnb021JbDIY1BFyZZ55S2Ahp2QZa4eFpGFmNxYjKNyGFh32ta2DVP7hWFDCGvDahqH0lOqgX4CVHwccHCASK0CSgLQ4i5wnlInWJ1uiIdtELZxKdi5DbL8Oxheur26zUZ+HYYy7j6IzhJgbXwfLG+x4TbS8luMpW7lwsYLzFyBEbbwIzOPebX1Mb8p5P6ev5OYs+/jVd0+9WPjuzFE4b1gWRuh0buGQXff434TSFbarsH8S6wyQsjB7zn3LTn9HKFriMjOQRzNwFW07kdrvNDGjm41oP963Gz5kMeEiKHMh9yO1PDZ0MCgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH8PR11MB6683.namprd11.prod.outlook.com (2603:10b6:510:1c6::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Tue, 16 Dec
 2025 21:48:12 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9434.001; Tue, 16 Dec 2025
 21:48:12 +0000
Message-ID: <9e18ee06-bd23-4c36-8489-c9ffb0043c9c@intel.com>
Date: Tue, 16 Dec 2025 13:48:10 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 32/32] x86,fs/resctrl: Update documentation for
 telemetry events
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251210231413.59102-1-tony.luck@intel.com>
 <20251210231413.59102-33-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20251210231413.59102-33-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR05CA0082.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::23) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH8PR11MB6683:EE_
X-MS-Office365-Filtering-Correlation-Id: 1bcc4ed0-2480-4761-9e6c-08de3ceccf2d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?MXhhTmc0N3R6QkovNnhFUmY3aTNCUTVjKzg5ZS9yc0U3Mm85YlVXeFlXVzc2?=
 =?utf-8?B?QzFGZGFCVk5PN3pURFIwTDh3MjZQTGhFTk85QkUxVHNOdUZYbno5WDNNM01Z?=
 =?utf-8?B?ZVJ0cDRlOWhXTTArMk1ONGxpZUFUTUMycUVRMGcxd2lQTENBR2ZGODVyOXY1?=
 =?utf-8?B?S1VQbDFHWnBnL3dSbTRSN0ZrNU45VUFwS2JVMUxBMHFxcVpkUkVnNVpkTXJt?=
 =?utf-8?B?alRUbWxCQ0dId2JRMzZhdUQwcG9hS2h1NEpRVyt0NHBxY3lIVGhtckpWRTRq?=
 =?utf-8?B?M05TR0Q2UmNJaHp5YW9qWTRVRzlTTE81Ym9UcFhBZ05tY1dnTUt0TnoxWFFj?=
 =?utf-8?B?YXZjZGEvTUQraENrM1ZUWG9pd3BkSVFFN21zQmFVemphK0JpdldXa09hcVJB?=
 =?utf-8?B?Rmw4QmhkTzZDQzlrVkJvcExFMlU0c1k3UldNQms3aXl5SDQ4Wittc21kZ1k0?=
 =?utf-8?B?c3RlR2NjSnovd05OL1llSWpOVlVKVnF6L09tdk1kc2dDS3pSaEp0YW1OZFZW?=
 =?utf-8?B?U2ZEOUNKbGp1ankxTXlNa09iWVpTK250eGxVNWE1L05rQkJwR3FFRHRVMzVr?=
 =?utf-8?B?NWJhL2ZZRlVzaGNYZTZzYldaemF0TmFodnFYSWRoMzl3RkJCb1diMDB2bksx?=
 =?utf-8?B?VTliOXUvRUhsKzUzdkxxbVBrZTgvakpLS1I1aTBNZVNuaUhUeERJNUhQWU0x?=
 =?utf-8?B?QndQdnBPdmYzWElRcjRhYjVsQnNPbDlSVzl5eEQ5ME1FNngrNkczZHliVFZ2?=
 =?utf-8?B?MThtSGg0a3dVWXZMMHQ1dHZwa3RxajdnQlQ5TzJkUUNRWERNL3ZWMEt4MG5Q?=
 =?utf-8?B?SzM1OUhNVHYyRVJxeE1lVFNzOVhXem9zbEdPQjZMU1U4Vk15amZCL1A0RS9a?=
 =?utf-8?B?aU5kcjZIWHh3TDdiaEY4WnVQWVJkaHdpYzJaQ3VRbXlvWTE1SmNhK3cybSsz?=
 =?utf-8?B?a2QxY0oxZTAxbkxEMjY0VlNIZk5Ubys5VDRBeUJ3QVQ4b1d0bEM3Yjk5Ym5S?=
 =?utf-8?B?WjUwMFo5b2pJNkhnSFFqZncrSVF2Y1hnQjVmZUdHS3BtdjNROGNKK1FvdXZY?=
 =?utf-8?B?TjZqMnJiSlhhN2ZRNVRmZ3VQeVp4TUZRTVFsb1hiaXlwSlZxUWN5QVBqMi9w?=
 =?utf-8?B?bGJFOHFTZXd2ZHJwRVJlSU5rNjF0eitKMG9hbklkeEtNWm1QcHVTazhTMUly?=
 =?utf-8?B?MlAyUER0NHZNRXI0dHltdjN4eTJIU3p2eXZoNlNtSnpURmN0bzdkYjM4bFFT?=
 =?utf-8?B?N2FTanFlOGg5Lzcvd1BWcklaaVpXcS9Gc1BxSEs2bjcwRTFXL2h2c2EyajNO?=
 =?utf-8?B?c0VXU00wWmVXcW1KWGhrcjZ5QmkxNEFiN1BlRnBlUEFuTmpPMytlY256V3F0?=
 =?utf-8?B?YkF2UEZUbHMxZWQ2NjJTSmtXWXBQWnUwTE1IMlJ5MVl6WldVeXNMalU4Smxq?=
 =?utf-8?B?Y0J5K1lJR3lFY1AxQjg3aWRONXBKenYyR1hxTzd0cUk1YW94K09DUTgxNkJa?=
 =?utf-8?B?UkJTWHlCb09lV3pjenFPNGdFWU9nNnVubDZJT0phVGFaYjBCdkl4VTcva3Jx?=
 =?utf-8?B?dTAvaENtaDlxOFhBK1Q0Qlc5ZEJxSDBhT0hUdVA3UVErNnhpK1ZsblBZbDVh?=
 =?utf-8?B?aEhaQURxSXQvNmZic1pWa29RMGdZMHcyRWtLcC9HTmpxcGJoaG4xdUZwaGRs?=
 =?utf-8?B?c1kyUVZ4UnJpcjQ4QW9rTzVYbythc1lrZW9oS1pMWHlOcG9RN2w0VDIyZnFL?=
 =?utf-8?B?S1Z1a1VkTXFva2dERkF4T1Y0WmFMelR4MEMwelBDRzZuSnJManB5enFiQ3dW?=
 =?utf-8?B?Sm9Va3FhcWltdzRWZWQwcXQzQXlDZzl6ZDJoNXcyRjVLL0ZSY3NGTWtId2Nu?=
 =?utf-8?B?amJmTUVoQ1VNbnlvL0VsUWdZR1pHem5JVS9GWUJHdXJGMzlmeWNQSitVb3Fk?=
 =?utf-8?Q?2USLkLyPMcsijqjjzChvDiHn2rjVTbL6?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SXhpNVBMZVo4ZHQxd1ZDVXZ5ektyU2tJVERNdWwvREIxU0pQOUhxS09IWmY2?=
 =?utf-8?B?ZkJPc2FDUFdHdURqd2pubE11cVBZOFA5Rzh0djVOZGtSTWJDdW9NRVBPM3ND?=
 =?utf-8?B?TVppaXJuNjBrR1R0TDRRYyt0RmtjMGNURThiNW9CaTc2bERDb0hpUmJHOVIw?=
 =?utf-8?B?Wm54dXo2S1IweGlHVUFBSjUrY2k0bUpOSWJ1Vkk5NHFRcG9qTzF0WmJOWHNN?=
 =?utf-8?B?RGpMSlJwV3hQRFpYL3FIbC83YVZKa0F4MkM4czBXVjErczFGbm83ZlBzYlpO?=
 =?utf-8?B?REltNnMwazZIWUVlbmZLeGxuY3FsMDNwNXpHdWpEYzliZHRzWVhUc1pKcEpx?=
 =?utf-8?B?NzBTRzdZV0J3U2pNL1JsNmRzTFV6c29hRktJeU9Kd3o0L1BqcndHS3c5OUov?=
 =?utf-8?B?TkdrRm1nQjIxcVR2ZlR0U0xQSWpyOWlYRmZvYjEyQWlqTjFYakpUamcyN1dz?=
 =?utf-8?B?dDBVeHJKemEwbFlENzVTMU9VTzhuN2FyNkk3SzJVSkUzSnZpYjF3MmRnUkkx?=
 =?utf-8?B?SUtNWmhnU1UzeGN1Tm1VZWY5b1FzUEhUNzdVaG9EMVppaENJcU9NdTNyMEwx?=
 =?utf-8?B?RDRQM2N0M0FqRUVOY1cwblJXQ2cveGl5cDByNU1Eb1EwVTgzbElvWTY2U0lv?=
 =?utf-8?B?K0diWW0xN0pTYUhqMEJJM1pNL1N4cW1GYTJ0aHRlODlHZXgrY1huNWNwbUw3?=
 =?utf-8?B?emZsWkFScTBJVDJsMEk5dHpzOThGZUpTbHhxWVJWd0NXcEYzd05Fd1RQWHdE?=
 =?utf-8?B?amViaEI4SjJxd01vQzJRZ1lrNmNPcHBvamF1ZlQ3MW9lUEt5NWU4MjNCUHdB?=
 =?utf-8?B?ek1oSXhyV0VuTTBpRmxhN0VwMEJIYkJJV0hSTGF2a2Y5M0NxTWlBRGl2OThh?=
 =?utf-8?B?UWQ0cmppU20xUEtsdFZBS2thY0tqeVU0VXNhQWtvQnVvTHB6MGJKTHcwVnNx?=
 =?utf-8?B?RkQ3Ylc4YW51cm9QME90Z013WUxhRlZXOW1LZ2szYUxYLzF6Z1JvTjY2R3J3?=
 =?utf-8?B?L1FhcTNxcm5oSTFhREIvbkhBS3g4emhsRFp4N0paa3ZOU1FnUjdlZXlML3JF?=
 =?utf-8?B?SkI2djAwaW9NN2VYdG8zU2J5YU1EK0p0MnFXcUxQa1Iyd2cyVkpiYzBqOU5m?=
 =?utf-8?B?aDlmdThIQ1djZjZuUWtYbDlHQVBXdG1nY290MEhtMTVHMVFNaHVZcVRJbC85?=
 =?utf-8?B?eW1vbTlHNUcyVjRzNUl6cjJGLzAzQVBaeW1BWWZJNUVGdFFIdEFscUFMdEkz?=
 =?utf-8?B?dWpXVWZiWDkvR2dwRDd0dlY3c0F2VlFGdGRNdXFUbEFZQlVkNmF5dUJwNDlN?=
 =?utf-8?B?QnAzY3d6bytmVU9yTk5NVk5GRjM0YkQxRzJGbGhCQnN6SGZXUFJCam1MbkVn?=
 =?utf-8?B?L0F6MS9id2ZYRUlUK2gvemUyS2xGd05uRjJPRzd0bHZEZ01IWlAyL3d6OUF2?=
 =?utf-8?B?WTlMYXlGNk0rVURQQyt1eDZ0d0J5aGxESlhNUzU4dTBSd05TRGhFK3lzSHRC?=
 =?utf-8?B?L1ZXMmQ0WWdxejhUSVpCa1BZQlY2SGtic1BrVW5wUjEyZ1R0TmhhYStlNDFt?=
 =?utf-8?B?MDkwMnN2VEZxbm82aUhaMnVWQ05ubmVPRVZUenhiTitkWGhVMWx4NGwwR2JE?=
 =?utf-8?B?a3c3T3FxcnlnM3F3cEpJcmxFMzhDQWdmY2NNeFhBMnlBRzhlMHdZVGhNeGN0?=
 =?utf-8?B?bzk0cFlUN1dPSUgzbGVveE5rOFZ3blJVZ2NxWjNIU3dLYllxMDZqcy82LzdZ?=
 =?utf-8?B?RGxRZGdjaVVtaytENjBRVVdqcHdIWHpKK0NMdHAwQ2hTMjlyWm5Rbm1lNjhN?=
 =?utf-8?B?VlgzcjY0SlE0eVp4TjRDbUNVK1lLY3Znblc4aHhRY3FTTWoycUszTVEzcm5H?=
 =?utf-8?B?RFdGeUkrbkxuTHFRZUhpdlFlNlMwN1J1ZmxIRmkzY20wV05oMEhMajVJYTgr?=
 =?utf-8?B?ejBsZ0VNZTJ4UEtib09KclFzd1FFVzBBblhQTVdCcEFPbkFUb3FrVXAxYWFH?=
 =?utf-8?B?QVlhSHBYcDVIcUU0bVRwTVlXN1M3UHRSQXJMaTdkYjJhUVpCQnVQbkJubXJN?=
 =?utf-8?B?L0o5TExvV20rWmpzMTlhTmEvcExOUEFtcDZFelpHZ0RtM1dTUEJmYkhSOVBv?=
 =?utf-8?B?NEFnOVZpOGV0bGhkVjg0c0NlaGNFUmZHTG9ENVE3NFBxVzNvME42VUtPTDVM?=
 =?utf-8?B?WHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bcc4ed0-2480-4761-9e6c-08de3ceccf2d
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2025 21:48:11.9880
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5INiMUo35VGJmX5ogkRAtFOR3+cv2+yFd4nXGNFwOjheeNsnqOuro/CWXRdydUF+lKn3eTDLy3C6uNH4yhHYAJJOim4/yhlpWJFH0/Im6ps=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6683
X-OriginatorOrg: intel.com

Hi Tony,

On 12/10/25 3:14 PM, Tony Luck wrote:
> Update resctrl filesystem documentation with the details about the
> resctrl files that support telemetry events.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette
