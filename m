Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43A573A1CEA
	for <patches@lists.linux.dev>; Mon, 14 Sep 2026 20:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789419056; cv=fail; b=GmlloVgbpcIu2rCQHcR/Pb9Ly8RaH48YG0cOXtHyaLkPD1MFAuEp5YzY9WOXbtA8a3ti4whBMYB/u4D3wmMcEVEUhl0n+MU39pBE/LL5zG3D2nm+riOaUXGU3jHDYMD3BoM/+AmsHgHt/BJqyMENo2NSPak4tmTOuby0BtYYH0Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789419056; c=relaxed/simple;
	bh=OgLVgPFv8BQo8Z7/YOjAMgpOsloe6IyHaBqpx1YDCrs=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=U4eu5D0P6GVrQwQdxnp4pxbN2/6zy/uYJt0ThqKCYHU2WC6QYVQ24OFbPGNi1TAmE25ySt8W2ewuPh/03acvYKBlE5bRWAwjaZc1bSTrs2IIKEOzwejA4LsE6DkgxBtkyNgGQo5yJDMpuYnMIM7XMTPFeD2rT7OKwNFVK6HnGkU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=oGJb5MIM; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oGJb5MIM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789419053; x=1820955053;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=OgLVgPFv8BQo8Z7/YOjAMgpOsloe6IyHaBqpx1YDCrs=;
  b=oGJb5MIMd9R3alHy2jNgWX4CIdxz2wqWMYcq/ukQCouSPi3fqys2VRQo
   vYvrfZruXIP7Lt1WDWwsefEwdJF6kx5pX1bDyQ4jhbY+3sKhIFvLzpA+j
   ve82014E5KvHWiMlY424yyBqKfAzMAMRU9KNyUHRx/+1qQ3/M/+qnJV1t
   jNQItB5sLw07TSt2XimDl65jAWoS2gjZiBvAqxCIPnUoTZ6ILp9DvFG9C
   Hd9gWOhUFSwGv4OORyp5Rk5m2/kuYNBex8fwWEmu5QXB6fjF5ot3YcPkF
   aC68NinzNBzdJ9yav0HAtjnSexLjTBW+E8Ht9Owojyhab6EkI/E0SSxiY
   w==;
X-CSE-ConnectionGUID: 5i+6XrprS8u8a8etNgWaxg==
X-CSE-MsgGUID: SqHsAk8qR1uRCZELAQTUug==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="115313231"
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="115313231"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2026 13:50:53 -0700
X-CSE-ConnectionGUID: 8WRNCG42SHu3ZadxzDCyTw==
X-CSE-MsgGUID: eja04zjATR2uRjpLZmBcbQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="302635414"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2026 13:50:52 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Mon, 14 Sep 2026 13:50:52 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Mon, 14 Sep 2026 13:50:52 -0700
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.36)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Mon, 14 Sep 2026 13:50:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FJ/q7/kQ++Ixl9l15VDvcLB1AYXwVjrpy2e9EEwWnwOM2dnrK3UXI1v5K7h6bBGsO19UQpa3gsJk4XuCqql/ycLdBiuKKtCHpDqdyLU6kx/7Kd9Zp3lHipkma03ALZaaoCAjbx7gGFR1coU/Cpd82HkHeDX/T3rQ87X34ASU1lb0Sbqk9cFqfdT8tihL/mH6pE8LvKmlsbaGNkoPMTIlKUJTaiLzDzC7/21yLc2hBqhu95Io1t7Fx8LFho8F2XvgzT7zQn1nsuVNpTdRrOrbvUyjGPsp2aNVvu278NOGM77he3KrEqKseYW20VmnkMXCEBxH5W3CtsUZQ9mmiJ6ulg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DwipLpKXL5YZsSaf4tHofN3JV03H3vV++pZN/jzYXO8=;
 b=LahR1lpW9KFzgl3nJSwMmeDmeFnl1VbAZvSQH00uX6xXKhZ+bfZAIc1Zzz/ytgD1konJ6z7w06jzV5AYWTLyy9VCzKl7uHw/sTkGkqNRTT8DKHjnVm66QM17apBSs+HgjAX/2Hxd5Xsyyepyvs8ayNxjcVmL8VeQnpzwkemIRGnAQtMfOKk/TT5ePF7P4BsJwuQ5JWRdqXIGyK/5Qs6pSWUzezsDxvigbkUT6Qpg9qgG1oKxQfpp6UAr4DqGXnkbakttxTsibv4Qlvoc3XyqE5ieFCp+UK6oiLwP2M9Vnz4wKCvEUaCDCKif54+oNuy5PHqOwKKWB3ziUt5U4sVFCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by MW3PR11MB4764.namprd11.prod.outlook.com (2603:10b6:303:5a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Mon, 14 Sep
 2026 20:50:49 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0406.007; Mon, 14 Sep 2026
 20:50:49 +0000
Message-ID: <308cb991-9c43-40bd-bfae-81c22b6f5948@intel.com>
Date: Mon, 14 Sep 2026 13:50:45 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 08/23] x86/resctrl: Delete rdt_alloc_capable and
 rdt_mon_capable
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260831174421.13921-1-tony.luck@intel.com>
 <20260831174421.13921-9-tony.luck@intel.com>
 <cd00837e-3a60-4b22-96ce-738c98bd47fa@intel.com>
 <aqgsSj_qDM8ICWgt@agluck-desk3>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <aqgsSj_qDM8ICWgt@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P220CA0013.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:303:115::18) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|MW3PR11MB4764:EE_
X-MS-Office365-Filtering-Correlation-Id: 22dc84d5-726d-4863-84cb-08df12a1daad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|23010399003|4143699003|56012099006|5023799004|11063799006|18002099003|22082099003|10067099003;
X-Microsoft-Antispam-Message-Info: hg/s5hXQh7SXG0w9wqSqTm//BgHOR6u6hGTwKI/wCU+pZJeXfukKcbX64ShBrZo+5VS8X/5/ZSlS1JEHJvGLtRuW4OiL0ddTTO98GD+/4KD79wXWS1oesWa2tfZm8ipnRrkgNjviW8igweXrN9dOKJT0DwtKP9dveMuUOmpPfehCOOAYZtmaJb6tTGoIPSf0fX6YlF/Auun/vCyTO2Z3AnQt3VDOraBZ2nsE+t640TKEPMkvu5QwaWrochyeR9JnV07Vs8E3VZ8e3ldR0fwBn2eZ0gyC/l7plCwI2Glnh//ZrhTMFMeod2HkRbxleNHx79suQbDwqE4mbk1vLUG3bYa9Dz2zSzI+rwzCTj17niHYPjizgk2jH4K3U3iygZP9BY6ERLUd75rOK2k9p0rLdv/I7ruIbzsocVSNnYIZ7MMuAU3Rguzjoew9Cap6BwREcEijWhRyGkeDVKHm4LN4/vZdSCu9XDT5/Tvf61ZG5IRH85GnjKIb0UY9ARD4Db8jhW96w99V2XJT+LlQk1p15nkR9yrtwNuEUx5ig+5KJvrZ54xBuIx+CVQH5NL3IBuAKT73+fLZV8fD+FV7Jg4LFFHvp59IButvK3Lln/sf1X5Rm643IVsCrOd36NttPtY94F+uEf4lfHeXCGD9iUDxoZNyjvMfWoKKaBfli7VJOO0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(23010399003)(4143699003)(56012099006)(5023799004)(11063799006)(18002099003)(22082099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SXpIVDdYQ0x3T1g2MFRia3VXSk1GSWVzK1h0NCs0dTVWaWMxeEdSeG04NURl?=
 =?utf-8?B?TFRaWHQ1MTVLVE5VTlpPZEp3RURWOXpOQm1uM2xNVzd4RjNWS1ltN2pTWjFW?=
 =?utf-8?B?M3NIYnF4R1Mrck5FM2FCYzRoNlJzc0xOL2F1QUR5WGZBazJ0L21WQVRjK2dw?=
 =?utf-8?B?eGZacmJhQlQ1bWJiU2ZYaFNxZE1QN3BCRG1OaFVPL2ZTUmRsNjRGc2NEbWlj?=
 =?utf-8?B?dFdWK1BscVRRa3hyb1lZdWVLS2FPNVFPTXpWeXZwVGp2QzNuSDArQlhpYnFj?=
 =?utf-8?B?WFVQVDdnUFhFTDlQRUxaLzJ0RHYzZjMzbVltY3M3TGt0bXFEeTVJRnI1d0N5?=
 =?utf-8?B?VGpaWDd2dkVleHc4VDhRbmp5b0R2YzlIL2JZaWU0dkZPUWU4eVhYWCs3MDBT?=
 =?utf-8?B?RFpjSHNVMXJFNkVLZ0J4ODFTWjMzUzhGY0t0cEtvMW9vdkpSbmt2Qnh0d0Fx?=
 =?utf-8?B?aGdUa05SQWJFU0QxYzlJRkxtMy9ZMS81ZElqK2lHQ2tpWHN5ZWUzRUdpNDhv?=
 =?utf-8?B?RUlaWTh6YlZRYWZsbzBPTDRaWnlMcnpxZmtEMkZCVDFBb2FnQWhaNDlNV1Nn?=
 =?utf-8?B?VTBtVS9RTnpDSzNJNUFSdExEMTZnYVRRNVNObVVuckJTWFh0UkJBbG5KTEhH?=
 =?utf-8?B?Z1R0UWUwa2JqU3lwcC9CTGk5TU1uU1BleHpMU3gwY2VVWjAzc085MHhqRkNP?=
 =?utf-8?B?RWc4SVdOZE54RG9QbDRGNTJXc25GS1NGZ2dORjdDTGR2c3ptRTBoT3NSWTFP?=
 =?utf-8?B?MVVYWFlSTVNuM0hMVG5QMDlBUWhPaHg1S21RR2Y2UWFPcDZvdXFIanVlTldt?=
 =?utf-8?B?aW0rcVVqdVlDSEFtNG94blBpVW9RSVpMUTc4bFRkbUN3S3BhQlZzNXhXRzJk?=
 =?utf-8?B?SHE3MEFCYW9XcE5EbnRFaFBobllEMXdHOU16VGIxK1AyWUtKRG9pQS9HRnlL?=
 =?utf-8?B?ZGNGSnZUUUU5S1hFVGVtNEZ0UW4wWjlBcW95eTRFUmQwOVBVamN1M0ZkajNV?=
 =?utf-8?B?dTFiMVdHNzZRYXhiV2lhcE12cTFlZnYrSDduSlpBVUtwR0c4K1JhNEhqNzlY?=
 =?utf-8?B?YXJZemQ3bDBFQi9iZTNtZ2htWnU5NW82M1h3NnQ4SWVtTjUyWTZhaEtONE5M?=
 =?utf-8?B?VVZNcFdIcU5VdEF0QmVRQzZGMm13VGFybTUwNnE4V0lGSjBYR1BPbzFPRkZ6?=
 =?utf-8?B?b3dtdktEb1ZSV2M0cXdUbTNxY29KbFVCamhiRUhyb2lqSURNUk9mUEUyQmhQ?=
 =?utf-8?B?bURJQWl2MjVQNzFJdXVEREF2MHZxNWZHaXUvMEQweW44RHJRcmJ3NHJmYm4r?=
 =?utf-8?B?eW1laGtBS3JVZzlZeHRNblUxVUdPdnZua2ZIOGJNYjNRTk5WM3YrQjh5K0tG?=
 =?utf-8?B?QUFGOEpua242QXVjMEtEKzl4TFlTRjJ6UnQxbmxLMGtMWmxJazF2RS9FaGgy?=
 =?utf-8?B?YXo1djNnaWNvSC9VYzNhd3pCL1JHQXV3em5MbTBhNjFscU8yMDFNK24zbWg4?=
 =?utf-8?B?TGI1N1c2NFFPcElZdzJVQ2lTR2h0dXZIL2hKTzB5dHczbktXUzdaY1dpeDF6?=
 =?utf-8?B?K1cwRjlUcU0ybFd2VUwybjI4YlRGb1RmdzJWZ0x4UnVDa0hmYU5xSytaSWxF?=
 =?utf-8?B?Q3pZVEdJeHA0c21XRFpXa2tNYTIyQm1GcW04S0NDRGdyNWJZcmFoemw0WVJM?=
 =?utf-8?B?QjNER2FrSDlKekdyK2U5NmVCVytCSTFWdE9EOWhtWHVQS0JTV1h5M2tyTGZT?=
 =?utf-8?B?WHcxcmJFSDF6cnJiYXFMTkYwUzRaWVlxdmlIaUFJQitCbHozM0E3dk1nVXgy?=
 =?utf-8?B?bzVlRHFOTWNuQTAyYmowZEFaenNNUVRkSHVyUjByTFhpRGtJWjlFaGExdVNP?=
 =?utf-8?B?QVl1RXdkaytzU1YzWW1wc0h6cUtCaFpBQnkrNVNEbjNlZDdXbElBM3JmOVZT?=
 =?utf-8?B?WEhxbjZZK2xsRzhidUNtR0hZTVU4NmtUVEpBczlMV0czT0ZPdnBTS2xMMGtK?=
 =?utf-8?B?Tm81RHJHZ1dtVTdxekxLZm9zd0gvc01LR3I3SjArMHYvL3FVaHUyNmp0b3Nj?=
 =?utf-8?B?Tk01YmlOUU5KR3IrbHJZLythZ2FJWmVmSVJncXBzdURkeFMrRG41VnA0MHgy?=
 =?utf-8?B?NXZQMlMzZUo2TGlJUmR1NXV4NWFrRkowSFY1L0hUUGxIWHlBR0J0alVKNlJP?=
 =?utf-8?B?WnZkRmpZcTVPdFRWVDVQY09oV3dHNTQvaUZUckdIQ1dlOFU3bmpRRGJYTHZW?=
 =?utf-8?B?OGwrQlNzcFhRTVM1aTJSZWJQUkVnUC9oVmgrNlVINVlUM1JBQkpWNWV2R2pt?=
 =?utf-8?B?dmNiK1JYNVIzYTBpQXdIbjFCazNpYzN1QXMwS1UrUnpmd2dDdTZyZ2pCQVBP?=
 =?utf-8?Q?MBXNw+eRR572z0Sg=3D?=
X-Exchange-RoutingPolicyChecked: clXVVG3WW5Ln5E7K02dHhU0BnX+zVJZK1OUjevDtDUpss4vY6NBt94ZPG616HvqTSnCoH7ga0dOuh1S91X+RzAiFC5WoAUCa1q8Q8kSK0qjz5tTf/+OL+toN9WQC8opu1x0k/o1RWUcBpf17B9e2Rd1A11f4xocpYUzMG9xTjYD4rDEeDSc+GnOywDF1AMyTHPSv5p73eQdz3QrWsXjxumvwJgKzjlaQjLod5dJwHK6cXsTc3xd24b74v2fyqWqBRa6Yx5w3V9HHigBy9VAvOG4Aqlvx/aJS8iiEHzctNyYIXb5bvXUfPWtj0pEqHy6/9GvFib37M+cRWBPQLQC65Q==
X-MS-Exchange-CrossTenant-Network-Message-Id: 22dc84d5-726d-4863-84cb-08df12a1daad
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2026 20:50:48.1462
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RXjHYEZB5H9LbgOIF3796+cgbbqBUFoA80LpNuTbVxfIo4BqLdwlO7OKyQpSA417wSJyLPb2p4LzqKdeHYFAJIe17iG/nZBXQdzb8AClyfY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4764
X-OriginatorOrg: intel.com

Hi Tony,

On 9/14/26 10:18 AM, Luck, Tony wrote:
> On Wed, Sep 09, 2026 at 08:57:04PM -0700, Reinette Chatre wrote:
>> On 8/31/26 10:44 AM, Tony Luck wrote:

..

>>> @@ -1026,10 +1019,12 @@ static __init void check_quirks(void)
>>>  
>>>  static __init bool get_rdt_resources(void)
>>>  {
>>> -	rdt_alloc_capable = get_rdt_alloc_resources();
>>> -	rdt_mon_capable = get_rdt_mon_resources();
>>> +	bool alloc_capable, mon_capable;
>>> +
>>> +	alloc_capable = get_rdt_alloc_resources();
>>> +	mon_capable = get_rdt_mon_resources();
>>>  
>>> -	return (rdt_mon_capable || rdt_alloc_capable);
>>> +	return (mon_capable || alloc_capable);
>>
>> Are these new local variables really needed? Looks like this can just be a single
>> return statement ... which in turn makes get_rdt_resources() look unnecessary?
> 
> I need to call both get_rdt_alloc_resources() and get_rdt_mon_resources()
> regardless of the return value of each. Changing this to:
> 
> 	return get_rdt_mon_resources() || get_rdt_alloc_resources();
> 
> would skip the call to get_rdt_alloc_resources() when get_rdt_mon_resources()
> returns "true".
> 
> Am I missing something?

No. My mistake.

Reinette

