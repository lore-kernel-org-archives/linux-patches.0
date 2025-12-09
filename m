Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F386A306D2A
	for <patches@lists.linux.dev>; Tue,  9 Dec 2025 19:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765309278; cv=fail; b=fFd/jhURBo7wVxGxl4fKd+XoVfYn49TblWCzjfU7Zi78SejwCf8qY0Q2DdVdR0acP0lWJi/Sbt9MzohuNGrOUp1axWBw4qvh8zn3WsP/rRir2WkSqrjwzCZjLACWR0N7Q+moEZIk5QE3otfWuCf5Ahc+OsSlkO3wdv3aJeJA7a8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765309278; c=relaxed/simple;
	bh=5p1Pi113uCKGVcHNHBC8OLMI21iEfpbjIDZ3CKkOZBw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HuCExgOgt/nlYTbWEIZlS6529TGRAQIFJfiBnhqC4S3Sqtv71INbe30RvOiuTpP3+uVEK3eIraHRnioc7P86byXSfZSo9eRn8ebZWBxtNTU79vCfTD69P/me9HirSz52XiULGgc6T76S71wgka3wNGwBP4NQhpPhg/S5NMXsEu0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gAQvaMmM; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gAQvaMmM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765309277; x=1796845277;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5p1Pi113uCKGVcHNHBC8OLMI21iEfpbjIDZ3CKkOZBw=;
  b=gAQvaMmMi1G6rS2xoyrDWwryWkNwsLeXGH0oRUMeIGuB7ANkDWKDWzmw
   fznMPHu/mLPemFvltPYVvNVByfoY3yqmH7OzIKlJMVTBQudqe1Ew94ouj
   lN86JlK9HuqacWTGFFa9p5+/m6jlm8H5PsgvcpK25fSW3ekkOKNepkdAq
   f3WzVL+kD7JvHwkWipWwL6Dsn//ybgNdPA0VHovCs0JljTKtYEvrFUV4Y
   +ljXdeksN8fMppbueOob4N8yOFUorHTBaTrgwPx/VmnI2GHHEpxB/B6FW
   h+bP5dSMiUyNjGVC/U8oKdinV67WcVqvS8WHIHHdABWZ5XT7M01YBXZ2i
   A==;
X-CSE-ConnectionGUID: m7eg8+MTTqOQwSXhM6TZTg==
X-CSE-MsgGUID: eLUHnsjaRR+7+r2EcECL7w==
X-IronPort-AV: E=McAfee;i="6800,10657,11637"; a="89926746"
X-IronPort-AV: E=Sophos;i="6.20,262,1758610800"; 
   d="scan'208";a="89926746"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2025 11:41:16 -0800
X-CSE-ConnectionGUID: WkVhrdxRStWBJaXCcX7JPw==
X-CSE-MsgGUID: ntNSPof4TbmYASP2QOmg+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,262,1758610800"; 
   d="scan'208";a="200480742"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2025 11:41:16 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 9 Dec 2025 11:41:16 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 9 Dec 2025 11:41:16 -0800
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.48)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 9 Dec 2025 11:41:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X+bkFtomm9XXKu2EB7v+55y51Xux+J+O8CIbP03XHCfwHDQJc+0x1zgJoGxSOgTgPIYGABOqwuO6aHK6VT1SbbOiCJskL1x/UcZC/u+EFdvv+Ms6D3KfNQogeSDdnfzPvXiUnWEarHodfAK7jF+aJc5yUk3iJBQxIejCYi2BJFjvYy3xmzw5mb769HiFhPMsZMjLc26D6i3yYl+so4UWka1QAMY0GYytO9Z8XDDc3tZGkcohYmgGcmXCyyIvob3lQcUG+ttlj21//NIbdYeYCCpb9PP8KLyBbqhBe/EvyBBA3/afbRQBjr44El6q81ug0PWVr1XvFuI5TbrnYMvbkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NniKAOULNa1w9tC1jdX8Z/jX0jHG3PBEQaw0FHs2YMA=;
 b=ydMpI4lshM3DBRuYIg0GcdC/MCizy1v5k9OPUN1mwnXzRfoW66i56H2pBvgDZAwbuEJJjUWSFgxOjdjxQS8xRlwFrV6sInBq0QECs256vVjCtqBLsCvPyxoLeiZxD60J0oNtNM6EPY1cDYrUxtXGQOozL47x27lZO6GcqSJFMoOo7mEfIOzsEDHD5Ba1jDjQZL+gLJTAyzckrCQHZi5Z/s7a11EFM3Ent4u81LicH/y6VsopTabX6DpX/e/c66Ds12T9hQvSjUxKOodZ/Fhg5OqW8rSYLpd/oL2lBDOYfgWZpJJvaZxSOGUbWzZ/2WEi+fegEENTw3LdjQJ6oqSODw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA1PR11MB8152.namprd11.prod.outlook.com (2603:10b6:208:446::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.6; Tue, 9 Dec
 2025 19:41:13 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9412.005; Tue, 9 Dec 2025
 19:41:13 +0000
Message-ID: <c7529737-9ce5-40fa-8dc0-bb6ba3ef0778@intel.com>
Date: Tue, 9 Dec 2025 11:41:10 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 16/32] x86/resctrl: Discover hardware telemetry events
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251204205404.12763-1-tony.luck@intel.com>
 <20251204205404.12763-17-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20251204205404.12763-17-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0134.namprd04.prod.outlook.com
 (2603:10b6:303:84::19) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA1PR11MB8152:EE_
X-MS-Office365-Filtering-Correlation-Id: cd86a574-20e2-4736-6aa5-08de375ae8fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?dm0vaW1tYXovY3BVTlRIdmJ4N2NlQkxnSW9QbmRzNlpkcFNNYlRLa2JocjVD?=
 =?utf-8?B?OTF3NWIrWTZXYWVGWGVNZ2d1K3NSOTJBUThoNDkzQzZGY09Lcnd1VlNseTF1?=
 =?utf-8?B?eExEMlhRWitaekF5WHMxYkxCWWJuaUEwUmd5d1V1MThlcGFweHNhNlc4NnQ0?=
 =?utf-8?B?VkVDdGYwaVd2QzJaQ2pHa1NsV2tCVG5WUXhnUUQwVjVUT0JwWjVFczg4eUg2?=
 =?utf-8?B?emV4QTRwMW5rVDJlQWgzcUhUSzgzRHd4c2NwSldjaDB3Ylg0YlBPWkx5MlNs?=
 =?utf-8?B?SDZ0aEtaYzJaeDk5NXBDbEZSY1gxalBxMFFxeVBhcGJVYmtQUEJ6U0dMQy9F?=
 =?utf-8?B?ditFTlJlWVpnUGhNUDllSnB3WkNLK1NkTktOeXdZNy9zem5IbTBoM1V0eEZL?=
 =?utf-8?B?NlFtVmhmK2FqTkx1eFF5bVdsdFFtb2NHalNkRnYxNm14Ymw4YndsQW1Nb2dK?=
 =?utf-8?B?aUJRZkhjeXFuajF3dURHL0NJejE0M1o3SnA2QnhpRzB5OVB0aUh4N0NobDFu?=
 =?utf-8?B?U0k0d2orZVV2K0JCUndGTy9ZOElhUmJ5dGpyUEYzQ0tDV2U1K3JGMUZFSnYr?=
 =?utf-8?B?YWZiNkQvdDlobGRwVTFXTlBOdFpqR1c5N3VpdEVBNnRvaFN2dUdCNnIrdXJp?=
 =?utf-8?B?Y3VCbURac3VPazhidDhwMHh3MTBsdVovVEcxdkFUS2VTYjJKUjJpeDRndEgx?=
 =?utf-8?B?VUJvOXVVTzEraWgwZ002ZzBsaTUzN084VTZiNjhjVDhWMndqdVpsWTd5Wkxk?=
 =?utf-8?B?UXhrZmNMbnpMek5nbHgybXZHYTJwVjk1NWV5dmEzME1RVHZpTUJieThZblhz?=
 =?utf-8?B?N2dDNWo0MUpLQTdhdFFqSjZOMXIraG9tbm9RNWlHdnRPUU91TVVwWlJRRlRS?=
 =?utf-8?B?QzRLZG45UHZoRmthc3N4VXFSY3FxT0c1U3hpWEd6ZTUxcHBRVW5nbmdFV0Z0?=
 =?utf-8?B?MjgzcVkvT3FWMDRoM1lGRjNIRTYxcnovcm1ZZ1FWUDcvM3FHaEw4UHl1bFl1?=
 =?utf-8?B?T0ZQZGdvWG9TaGh6WVhZcC9Ka1RzWkR1UGRPRUJlbTFKeHVkeHF0cUswaEFs?=
 =?utf-8?B?bG4vZEpqQmRvWGE0MGk3amw4WEUxbUNVRU03emtxY0t0a1RXYUdTUXFLRXFC?=
 =?utf-8?B?VFgwSmJTcG96YXlPWXZ0SjkrYS9vOG42UkNwUTVOUlpNTWw3RWxRcDJVSThO?=
 =?utf-8?B?WWNCeXlMMVZHUk9Jc3N3RGQ0ZDMrVFgvWlUvUldJcWJYckxaL3BtWFFPNW9x?=
 =?utf-8?B?TTJZalJLNVFyQXZockRVU0RQNldJWjlZTWloMUEvK2dEZnE0VytwejRsTTFL?=
 =?utf-8?B?cTJUMHFnZXZUaHd0azVmeDhqQk1PNUVkQWYwQ2Q5RXpYSmc5NjBONmFoR3lW?=
 =?utf-8?B?RjBpRE1EWkdQZlkycTRxZEpNTWlUU2hHbGVJamxVQ3ZqRGg0ZUl1QTJycjk4?=
 =?utf-8?B?cnczRzRLMnJiMHVRdmtZMXpXbUVkMGxmUlBiVHFkRGduRXRoTFdwbG5BY3g3?=
 =?utf-8?B?Qk13NlliR0QwUWsrR2pvZnVzMlZpRTBmTzRoYmlCQnMreGdHNlhxZlRQdDha?=
 =?utf-8?B?cW1zOHRtN2lKNEt0MFg0N3dnRytDWGVyQWJMME85VThLalpYNmhMRE84QkVx?=
 =?utf-8?B?U3VIblZ2dzg1UklLbE9pcitRRW0zdFhNRGVjNC9Ic2lqNVVYZ2tLSHFoRUhm?=
 =?utf-8?B?d09rOWJZeDBVSm5QVkhCTUlhTlc2VmhLQ28yRnpyVm5zbmpBVzg2Y3VvdDla?=
 =?utf-8?B?K1Q2YUlwVFVrcG9IOGlwOWM1YUJ6TFVIRWpYcmp5VTRmcm8zek01TkUrR0VQ?=
 =?utf-8?B?dkdOTzgvN2ZnMW9LM2N5NlAwT09JTG5wNzNUNUdWU1VDaHF4VlRYZVBxUEtN?=
 =?utf-8?B?SlpJYXZWRml6RDhYWDhnN2NJSlIveHlxV1JyZUU2VFAyN0ZnTk1YWU9taUJK?=
 =?utf-8?B?R0t2Q000a2JvME80UW5SRzFFUzBBQ2s0VEtRSXcxMm1zeGJVOVlPK0FkYXZ0?=
 =?utf-8?B?MmtDdmkyTkpnPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U2IwU3FBVGdlbzJPaytYQVg1YVd0RkU5U1lkYzZJa2tOYWtXbFBpR0JOSWox?=
 =?utf-8?B?aU5ML2R4RXh1NVhwZndtZlBMU1p1eG9YcFpObnpiYmRwSFM5ZnF3VEx4cFYw?=
 =?utf-8?B?UlVWQVNRQ0dubWdBa3VSOUZLUEo1VHdWZlNRSGd1MzJOYkhhVjg3dGJDYUJR?=
 =?utf-8?B?R3BZVXU2MUVmQlZ0dmNoUmw2YXU1UDJicG9IdlhMVkRxbkVTT2xlcE5DcExh?=
 =?utf-8?B?RFI5L0RXM0JMZkpzeXpkbDkvMTYxNGRCa3dKeS9HbjZCL2xOdDE0SERxa2pS?=
 =?utf-8?B?cEZPMUNRRVRLR0I1SUY3TllIdjRuUUFMbE04d3pMWWNZckhEVlpSY3NZRG8v?=
 =?utf-8?B?VzBEMzkwTXNDVmNlRnlqTW5QQ0xBK1p4Y1RDbE1Pd1ZrS2YvK3lJa2ZMTnlK?=
 =?utf-8?B?N1BHcWt2d1ZaWm41dHB3L3I4aVZNMXAydytCZmZRbURXREFMUjk4a0JqNWtN?=
 =?utf-8?B?c21zVnFrUmVvWTZ4QmtJZmJEYkVtT0ZXa2ZLK2lBaVZQOHZoSUtYbUlBaEZw?=
 =?utf-8?B?a2JGZm8rSVphS0NmcTMxRG03WEVNdlp1Ym1Ja0IyVkltaTYwM1RUdFdBT0FI?=
 =?utf-8?B?WmFjcXloRGtuMGdvM1hpcm9Qam10cjNsWFRXdkVNaWdBNmRhL3pmbmJEcy9x?=
 =?utf-8?B?VFNTWVprWnllUkppRDJFU0Yvc2dNWHRzQ3MrTTVsYlpscHpaTFkyYzVpSlF0?=
 =?utf-8?B?Q2tlU1ZPNk0rZndSdkhwUVhyc3g3SEloODdYeCtEMmVXTkFPNFJBL3hkZUxh?=
 =?utf-8?B?R0trNW5rVm9IMnc0SDd2OXh4QVcwZXcwbWFIc2dXVjdFWW91MFl2aFhRSHds?=
 =?utf-8?B?QVRPYTBtK2tVWTBRbDhjb0ZoU3Z3VFZhZjNTcWRhWnptNTdLMEE5MUFFMmxL?=
 =?utf-8?B?a1A2MUpvUVZpSUYvLzNiVFFuUlhzTGJMa0Yrd2dMYjBrWS9ORE12b3JtZi9S?=
 =?utf-8?B?QTJxOVMxRElsQUh1ZVN3S3MxQjlYYmFYLzAvdC9XNGYvTEh3amhPQldnb3FY?=
 =?utf-8?B?a2ZWamRKT3lnV2JJNk1QMDQyRGpLcktja295KzJIK1drZm9NWHZnUU9Ndjho?=
 =?utf-8?B?aGdiZGR3bjMyTHhOT0JUSUZIbXU5ZTllQkorbnBiUllBMlhSMWkyYUUvNkgy?=
 =?utf-8?B?dUw0OTJzdnFqMUpmallJM3hTYnBvM3FMaGVTQTJPcGdScDkwNDNnVVZsN2x5?=
 =?utf-8?B?VHY2d1BJU2U2WUVSRmlVdDNNUklrS3p6cWxxOHduL0lVZElQb0MvYjVqOTJs?=
 =?utf-8?B?S3gwSlVUdXBSaTFJRTU1N0ZFWHgvNHFLaHA4Tmd6ZDdKb0V3dEpIMXJUSE9r?=
 =?utf-8?B?WWxaSDVlaXN0T0VFY1JuMGg1d05qVElMZDNjNmo0RVAxTmhQeHNZemsxOGxG?=
 =?utf-8?B?VzhiT1dwdmZHaVo0WWdmd25BaklNWUl4VTJRY1k1TjdObHVMRDVMRURoVktD?=
 =?utf-8?B?dnN0TExwNUhFUXhWNmNDWmFOdWo5bmFNczViaDVzcUx5azlxL0RZQWd3bC9n?=
 =?utf-8?B?NkF6WHBGSlRzRkozS1Rqa01yd1pKRXB2RGg5Z0JzZW5nUlhxOGhhQWxFMlZN?=
 =?utf-8?B?TzlpWmsyRmZJbDVWUk5XSTM2K3kyWFExUCtRVUt2VnFwNDRmbEhISWRwT3Rq?=
 =?utf-8?B?akxHV2V3OHhpNXZMWGU2SmJrSmgrNGdERHhMRnhHVzRZZWxoWHc1a2FDeEE2?=
 =?utf-8?B?eDNrRTFHN2VQbFQxUUNScElwWEFBSFNkRWdkczl0MVpuM2dWcjhaYkVGN2Ji?=
 =?utf-8?B?Y1FDR0pCWFdoVTZBNHQ2QzZ6Q1M1MjBTbWtBMVBMNnJwQ2k2T1pEbSs0ZC9q?=
 =?utf-8?B?NUluYlA2VGdydW9oMUNaY1hnRFQ3Qy8xN1drTWtHSHZZY2M5SDgxRFhrbkRN?=
 =?utf-8?B?SVFsMzNiM3FWUnBCQndlVTJGbTRRYkM4YWJMOFIwSXdta0MvUHpPVE80MG5j?=
 =?utf-8?B?OUxTUmR3NHl5MWE2NjZ3cnpJa2xmTGlYQy85b3p5eHRscVJBcklEMjlrR3B0?=
 =?utf-8?B?M1VDTytXc0pTUkZWU0kvdjRnMlRkTXZVVWlrYjdQdmJTRy9oNHR4OTYvTW9V?=
 =?utf-8?B?TDdSMys5Ty9mUkdHM2lGdU10UDB4VjNGVVE4ZWlXdEZzenI3NWIzbU8vOE5F?=
 =?utf-8?B?SzlLNXpMZEJTT2tGM2xVZnBRcjg3TXNTRjV3ZzNYeGs5dDRxWEp6N0Z4aXJa?=
 =?utf-8?B?NUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cd86a574-20e2-4736-6aa5-08de375ae8fa
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2025 19:41:13.0880
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X6teFtbpb/WhADirh9X4NCXllYgwQkDrRB5Em8rRwxqsw0OX1wckAn2p//8E8FUhSZ/+8TeVmIkV20dYzzpOzu2MpP/RAYU4nbI+xDE6LyE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8152
X-OriginatorOrg: intel.com

Hi Tony,

On 12/4/25 12:53 PM, Tony Luck wrote:
> Each CPU collects data for telemetry events that it sends to the nearest
> telemetry event aggregator either when the value of MSR_IA32_PQR_ASSOC.RMID
> changes, or when a two millisecond timer expires.
> 
> There is a feature type ("energy" or "perf"), guid, and MMIO region associated
> with each aggregator. This combination links to an XML description of the
> set of telemetry events tracked by the aggregator. XML files are published
> by Intel in a GitHub repository [1].
> 
> The telemetry event aggregators maintain per-RMID per-event counts of the
> total seen for all the CPUs. There may be multiple telemetry event aggregators
> per package.
> 
> There are separate sets of aggregators for each feature type. Aggregators
> in a set may have different guids. All aggregators with the same feature
> type and guid are symmetric keeping counts for the same set of events for
> the CPUs that provide data to them.
> 
> The XML file for each aggregator provides the following information:
> 0) Feature type of the events ("perf" or "energy")
> 1) Which telemetry events are tracked by the aggregator.
> 2) The order in which the event counters appear for each RMID.
> 3) The value type of each event counter (integer or fixed-point).
> 4) The number of RMIDs supported.
> 5) Which additional aggregator status registers are included.
> 6) The total size of the MMIO region for an aggregator.
> 
> Introduce struct event_group that condenses the relevant information from
> an XML file. Hereafter an "event group" refers to a group of events of a
> particular feature type ("energy" or "perf") with a particular guid.
> 
> The event_group::pfname field is used to choose the parameter to pass

Needs imperative and "field" is redundant.

Previous paragraph can introduce event_group::pfname, for example:
	Hereafter an "event group" refers to a group of events of a
	particular feature type (event_group::pfname set to "energy" or
	"perf") with a particular guid.

Then "Use event_group::pfname to determine the feature id needed to obtain
the aggregator details. It will later ..."

> to intel_pmt_get_regions_by_feature(). It will later be used in console
> messages and with the rdt= boot parameter.
> 
> The INTEL_PMT_TELEMETRY driver enumerates support for telemetry events.
> This driver provides intel_pmt_get_regions_by_feature() to list all available
> telemetry event aggregators of a given feature type. The list includes the
> "guid", the base address in MMIO space for the region where the event counters
> are exposed, and the package id where the all the CPUs that report to this
> aggregator are located.
> 
> Call INTEL_PMT_TELEMETRY's intel_pmt_get_regions_by_feature() for each event
> group to obtain a private copy of that event group's aggregator data. Duplicate
> the aggregator data between event groups that have the same feature type
> but different guid. Further processing on this private copy will be unique
> to the event group.
> 
> Return the aggregator data to INTEL_PMT_TELEMETRY at resctrl exit time.
> 
> resctrl will silently ignore unknown guid values.
> 
> Add a new Kconfig option CONFIG_X86_CPU_RESCTRL_INTEL_AET for the Intel specific
> parts of telemetry code. This depends on the INTEL_PMT_TELEMETRY and INTEL_TPMI
> drivers being built-in to the kernel for enumeration of telemetry features.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> Link: https://github.com/intel/Intel-PMT # [1]
> ---


...

> +/**
> + * struct event_group - Events with the same feature type ("energy" or "perf") and guid.
> + * @pfname:		PMT feature name (energy or perf) of this event group
> + *			used by boot rdt= option.

nit: use quotes for energy and perf as in previous line to be consistent and help to highlight
that these are string values.

nit: move "used by boot rdt= option" to patch that introduces that usage.

> + * @pfg:		Points to the aggregated telemetry space information
> + *			returned by the intel_pmt_get_regions_by_feature()
> + *			call to the INTEL_PMT_TELEMETRY driver that contains
> + *			data for all telemetry regions of type @pfname.
> + *			Valid if the system supports the event group,
> + *			NULL otherwise.
> + */
> +struct event_group {
> +	/* Data fields for additional structures to manage this group. */
> +	const char			*pfname;
> +	struct pmt_feature_group	*pfg;
> +};
> +

| Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette

