Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DC0727380A
	for <patches@lists.linux.dev>; Fri,  3 Oct 2025 23:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759535939; cv=fail; b=QqVcpWcg6nQ5H3L5Z/0ljWNwJtMEV3G52fPf6RyiHDZFtTQYf+p1dH2O/tT2Y+xBZsKaHA6u7tNpwLVjkygDLBoipvHhLnlldj2gDvTNCMFqd1dECSkgFo1DnH5tqW48hEiESl+PAh+xfTXRMRvY3vHvWXKPmOzEJ7CeW4fLmDg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759535939; c=relaxed/simple;
	bh=HseT2XVWidDpvFiNyqXSl1AOP8GDs3BV1ZmJynU7B9g=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Z4/7/cPp5OvvJCYgHwAqjP67ZwOv1rNYWP7xGzwXeYCDU0bqdXN5phOYBouE22QL9hFNxTI2ny6ayqLhZo1TPaqJ6Wj2nTwDU6hPCbTd66i9s+aiaXi/+rhlkVJoYHGOu4lHUH3/X6fFT8GR2AfuoCRqFjlkQMDa2HPMiFTq6dA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=neA7wHI+; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="neA7wHI+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759535937; x=1791071937;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HseT2XVWidDpvFiNyqXSl1AOP8GDs3BV1ZmJynU7B9g=;
  b=neA7wHI+QjDxBekmRR7ZxPX8QB2Rb7URrtyQdJGD9nD8Xj9vO3lNdCR4
   JvwvzAhGDqlF23t7qOSRLal9kPEFjqDV82C6S+CSij6VwX/pDExPhnp9o
   ZHGY+nojgDAl/cBRTg/tdMQFtjAiTNUj/02JoCtPNCboiIor9ZqGWW9Cg
   wvadbRNxefbwd//Wp+uMUL+rkS43chUpVjR1PODMBAebJO99fwH92CRa5
   MJobtDzs6YZnOS+9IIi6gEWCGNk+toVCheRXw2IRCl2ue/gKtkw5uM7vx
   jpYF1Gnec+nMVMzGBWRoXN8V9uRr9ygr/2gSQwTXxGApJKDV3rRKrhLSX
   Q==;
X-CSE-ConnectionGUID: sv1tv+j5QqarxmPTKh+mtg==
X-CSE-MsgGUID: PJPbbfGWTc2TKXoHmylUVw==
X-IronPort-AV: E=McAfee;i="6800,10657,11571"; a="73172748"
X-IronPort-AV: E=Sophos;i="6.18,314,1751266800"; 
   d="scan'208";a="73172748"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 16:58:57 -0700
X-CSE-ConnectionGUID: 41JQI66vRzuVqUNW554LdA==
X-CSE-MsgGUID: OxpWKBYTQROhzomEGQlkCg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,314,1751266800"; 
   d="scan'208";a="179326682"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 16:58:56 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 3 Oct 2025 16:58:55 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 3 Oct 2025 16:58:55 -0700
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.58) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 3 Oct 2025 16:58:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Eeh3ku47zQUAhDTm72MJupKHtnfMShD7M24Qvqt2QSD1LfHl2B1W7fP+04zYDaknBKbANKX67a8jCFCjM9EQhmLzmXtOYe7vq3IwC9ySN1f0qk+zaeG2X24Yimh7msRH5kDpDBb3wCtfDjM7aVqX/hwjd5soIXEblxGgMzGLcX/PZRhxP95RcWZFYo3AbJrTGl2rEBWmFBIhDDQrGI1B4N0svjGxJlhXCwjfmkQeJeh0oEC7faizqrU5hBPvUksS+kTksNRd5H1lDxoXxMdT5Bl2rPnMX7Mqi15cTJMs8qUJL4o8zx0apu0++dIB/Bv5ydg7DVWIvgUhxVCguGfnQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3v9xLpEj0FxMhlAADTqMTaG3fIj2j8nD7YwTB2PpXgY=;
 b=GR9rG8didMTYiIZZAqI4uPzoiZicIorV3Rn8G2G7B5GwJz+IYLCIrraLyqvmIZ+FW+QULNlxHaOD371uoP898vHfJNq9nt+FrWZaU+NOdeOkFvJ7JPZ7XlvnCU7KDXz+o75ySfXwc44d1GGDdL6aHvj4ljXa2PK7d7vj1Y07o+OcYU4Z54MgCll/iGtWVrBXR+W1OWa4dvFWWSShp5/8yviGhITuc1LX+T9dNRZhL5nz4TxGT8lnXt5UNhXGD+k2FTK2t/z4e7FcrMe484s6RpMygOsIZ/YP7HLyvdNMczhhBa380FEBDrJqvJ0jmrpgsq2gQxIG6sVy4ctPOqeCpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA0PR11MB7911.namprd11.prod.outlook.com (2603:10b6:208:40e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.18; Fri, 3 Oct
 2025 23:58:47 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9182.015; Fri, 3 Oct 2025
 23:58:47 +0000
Message-ID: <fbd49f1a-ddb2-45e2-b943-df43d2173503@intel.com>
Date: Fri, 3 Oct 2025 16:58:45 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 20/31] fs/resctrl: Refactor Sub-NUMA Cluster (SNC) in
 mkdir/rmdir code flow
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250925200328.64155-1-tony.luck@intel.com>
 <20250925200328.64155-21-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250925200328.64155-21-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0189.namprd04.prod.outlook.com
 (2603:10b6:303:86::14) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA0PR11MB7911:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d8f58a5-ab4f-4231-0e93-08de02d8cafc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Q0xRQ25HKzNmeTlldm42ZUF1Qm04M0Rrb2R0VmI3d1J1RStxQjlGSVZmbUJl?=
 =?utf-8?B?d1kxR3VDODQwYTdqODRqSHN1SXAvdGZSbGlkQ2QxNWQ5M08vTDNxaVc0THlk?=
 =?utf-8?B?S0ZvZForbGdtS1FwMTdKZTJjeGdySFF6M1hORTBmN0pHMEUzNUlVZUFvRzEz?=
 =?utf-8?B?cmlLN1BtL2pUclpCQUdMZDY2c3FidnFxdXdwaThsSUVYdWl2U29TWVc0Uys5?=
 =?utf-8?B?QS8xVjZOamdjdWxZL2EyUmtaVGY0QlFVYllmWDFlY2hSQUVQbWtVY0pmdXhn?=
 =?utf-8?B?U1lPWE5uZk5zaHRSaGdzMTNZSk8zdHl0SkpJTHFtMXpUQnRJaHhsVDhjbHQ3?=
 =?utf-8?B?bXJHUWVmT2VxV1NHaWtwTUh6aHA1TnBnL0U4OHMxcER3WlNCRnlocklSR2lM?=
 =?utf-8?B?RSt3c3YxV2RYaHlZbzJ4SmlGYWdMa3RVTnBtcXV2L09NaTR6YzdjMnczVG5W?=
 =?utf-8?B?Vi9BQmFUV1F3K3BMTnJrSnB1Q21oLzExTU9TMGRDQUcxMDdIdzh3ODh2ZDFM?=
 =?utf-8?B?NjZsSkRxc2RnVVZxRGJSNE5JM3Q1UXQ3Z1FTN3ZNYWRlMmF2UjV4ZXZYTldY?=
 =?utf-8?B?aVpndGZTOTNPVyt6SE54MjBSUEswUUNYOE9JanozbHlxVHFRemZsZGVXNHo4?=
 =?utf-8?B?dUZLTndsdGh4SGtvVk9PMmg5VHJWL1Avem95SnNPcW8wZ2x1ZU82WjBPVThk?=
 =?utf-8?B?REU3N3VwaVdadW8vUnBGNGpQSW5NQlZ2aW1WdnBXL1czaVAwTjYyNkZ2L2M5?=
 =?utf-8?B?TXdqWjhScHdPT2xXRjdzWEtKbEl0bFQ4c05vbmRwN1hUSzZORnVpMjZKNlV4?=
 =?utf-8?B?b1hCd0dLWHNiRXNjU285ZzdFak5seGcyR0NQVVo3cXBTemljdHdyUFlrR3cw?=
 =?utf-8?B?OW1aMlFMS3c3NzlKQnJLeXZua0RBcW5FclV4RElTL1dZcVZ2cktuaEdGS0ZP?=
 =?utf-8?B?c1dCT3g4V1JIVGdwUm5mRVQwM3Frd1BIVVNWdk9PbVBEa2tZV0cweWxwUVdl?=
 =?utf-8?B?dUdWT2I5Q2IyeVRCR3Z6Vm1RUFQ3RzFiSjlLZ2V0NWlESVlFY1BockNIdzlX?=
 =?utf-8?B?SnJ0S1laMURJS21ZV05mcm8wU2pLZXVyMGI5RFZwSXVFVHJra3E1L2RBaGhI?=
 =?utf-8?B?OXF1Q1VlSm1pMmxzVUZXb1o1KytabkVWWkRQbTJyc3NZbVNqa3lnMzJJNGM2?=
 =?utf-8?B?VzVrRmtKSkdQdi9WTko5R3E2T1RNdHFudW4xUDZrNVBRUXF3a0p3bDZOamIy?=
 =?utf-8?B?UUptTFdvUFZNbHJJaGdqeGFjZk1tSmx2VDZPMkhxa0ZNNmNxR0liWHZzQUZq?=
 =?utf-8?B?SHpzUTgzcUVhOUxQeSs2aG9qY1dmTGdzRUFKUUNhT3RTRXNvQjdpTFlJVXNR?=
 =?utf-8?B?Y09WSVlkZ2RGdjkwSjN3WEM1WTRBMWIrR3pmdGU1RWZxRXRjbzdnWGJ4WTJu?=
 =?utf-8?B?OHVET3Q4K1hDT2pZczhkaHpyU0haYjV2Q2tuaDhlc2FZV1Q3RzhOZDJwaEtr?=
 =?utf-8?B?V2dZUU9Qb2RPSVZCdlYvT2Z1ZGRSWWUyUEpkRzZEeUVKeXg5OGFpRTJrb1hM?=
 =?utf-8?B?V0RPMm9TOXpiZmlBWmtsMXc0eGo3VTlzbmJYZ25WUnRTVVpwTXpsRnRIZnpK?=
 =?utf-8?B?cGM1M056NFpndEVDWWJleS9PTTFoSHQwTUtNM3UxcHZ6bTVxSUo1cFk1TXI0?=
 =?utf-8?B?cDVrOEJTV2pkTXlVN04vRGxsY2FwVkdPNFZBV3ZQWGhUSVh6VUVVRy9oYTRw?=
 =?utf-8?B?WWdVRXVKVjFla21ma044TllwZmZ5Uks1ODlXUGhoWjRteU5xMjEyUTJ1RHhK?=
 =?utf-8?B?U0g4cHF2cFBnNmJtZmxIclQwV3lEazN5dmxKcWoyVTNmWnFlSzEvdnZkbDlh?=
 =?utf-8?B?MzNObFdBbVBUN3FmeXVHUFJhY29xTFZXdVFKZm82TkRUV0xIM2RhT05KeThT?=
 =?utf-8?Q?YBx8Tvj6sj8ycDiIpR4GWE9K30oDuzV/?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T2RoYlR6TU5MTlZXVW11YmtDUjdURXkwajNXYmwyN2tpcDYxUTg5aUNVbHhH?=
 =?utf-8?B?RVVsVkdzQUx3TGN3ZkZiVTRJYWhIZTBUcjBldUxma1kwMTZWYkNpT2pZeVJi?=
 =?utf-8?B?VDZjYVU4VFBlTHVjdThYZElPbEYwYktRZm1BRXNtbEc3WXNiN1BHblllRFJZ?=
 =?utf-8?B?SWVYSnFkUkhjS0F1bUlFdG8yTzBERE9iWkh4blQxSnZubGM1S0dranYxN0FS?=
 =?utf-8?B?c1IxWGhUK1M4TVdsRWhLRk1IREtLaFpDaFF1dE9MbC9DMDR2cnJ2RXhUdzlx?=
 =?utf-8?B?NjNxbW01aXNpdGl4NDdUbTNGMWhnRWhsY3hJZktNRkEzTnJYTzJvdFFxL2dB?=
 =?utf-8?B?TTM5b1F6YngyVldQa2ZCNm5abE43MUtBSll6K0h0T05BQjdGVEFsSFZ6U0pU?=
 =?utf-8?B?OTN0dEpISVlhQk5RWGlqWXBCcGIySm9tT3ZKQkY3aitCMkVFd3VhdFUwWVZz?=
 =?utf-8?B?djFhdVlFMnB4NmJndC80aGdrZ0YwYmI5UEd5Y3RzTVVwd1NRdmxrUXF5VWc2?=
 =?utf-8?B?QjlFT1B1Y0tSL08xN2tudXYvUFdTeE1Pek9lMG5JaWhqSkY2ZDZWNnJzc2p6?=
 =?utf-8?B?c091NkNORElqNWpBcDFCVGJpRWNYeUxTUHkySS9nQTlSV2Jua3ErbU1xWEVQ?=
 =?utf-8?B?dmlpRVpxSmNpQW9sbzdkMTVOU1BQV1htKzdXVTJ2KzI3VHJsdHFzK1hEOHNZ?=
 =?utf-8?B?TnhYMHZDU0VkTzBDT25FeWVMOU00dGcyTWZCQmFZbjMzTTFhb2RhdU8reWpI?=
 =?utf-8?B?N1F4YldWa2trU0lrV2ovR1UxUWlzMFVhclZVZHd0M00wWnhZT1RuRFZNSWE2?=
 =?utf-8?B?NDVXZDhaRy9NSVZjZWNpSGxrc2FlTUlpaGRSa3hQWHpuS3ZUVzJTVGd1eW15?=
 =?utf-8?B?L1RKdkJZODA3eXF6N1NGN2w0LzlhUVlJUU95dEhJZE4yVVBBYkFOU0Y3bFBF?=
 =?utf-8?B?TzczVlpTRTBjclpMQzR1UHlCQkJMcVE0dmlFWkFmR0VrNnBNQUJPM1B5SWZ0?=
 =?utf-8?B?VW16T04rS3lmbk5FclNuWGZFNVB6WGNhNHU5RnRsdTBQbTgyejU1dzVYanJI?=
 =?utf-8?B?R1VDejB4cjdIbTdNMU1vSUppQTEyblFzLzFyTTlJRS9ZQ3doM0d3TnlwWUlZ?=
 =?utf-8?B?N0ViRmpxWjBIRlRYdXhMRlZFVGVRTUJsckd3Ny9mWkRkek9FRENVM2RUdW9Y?=
 =?utf-8?B?R1YyKzNrazIyTWVwR3YzbVdKV1NYUXREWHdRbEhURS84ek9GQldkV1I4a2RE?=
 =?utf-8?B?TnFkVElzd3dzQmIwVllsdUVWelJFQnV5R1VPQXJxdHM2elhTYTF2UU9QaDV0?=
 =?utf-8?B?VUJUVk9MTWU1SWVqeWptSzdoNHlwaUE4U1RZUERHUE82S0txMlNpcVltdHFG?=
 =?utf-8?B?ekRTckd0K2w1OGM0RTJXN2JxU1FPU0tCczBOUnFOL3hid0EwR05mM1c5ZkZx?=
 =?utf-8?B?RjJvZ3Q4aVdlV2hDVnlqMGZVRmJBdGlyek5nd3dFTUtBRFpmYWFjMHZPTWN1?=
 =?utf-8?B?UG5lSGVvenZjQ3h5NVRadW56Z3VGeUZEU2tpcFNOTENuK00zV1Q3SDk3SlAz?=
 =?utf-8?B?ckp4b1pCbGM3OS9jdzMyS3JqajJENFNEV29qa1NxNmsxK0pBb1FKa1A0cUIv?=
 =?utf-8?B?MGZBTGpCaVdFOVFveE00YnU0UERaUTVXbVhRYm1ZYlR6T1R0Y1hwVzU0Rlkv?=
 =?utf-8?B?MU5SQllEVW1QQUg4VVlXNzRQby9KdnhvczdhN0tSQjY5YVBlakRTRmNpUUZR?=
 =?utf-8?B?V3g0eUtlUHk0eVlhMzFOWStRd1AvVnJMcW1mS0hIY1p0cW9YaEthWHNTN2dX?=
 =?utf-8?B?blIxZzgyL0YwOEx4V2t3ZmtXVEQwOTRPNEN5WlYrejVGSWxQK3lyb0tGMXVW?=
 =?utf-8?B?cDBDNEdVeEgwaUVsUFFkUGx6aFFlNnZrWVZpbXFrWi9BUmtFZDFDWFZrcEQ5?=
 =?utf-8?B?SGI5Y3kra05lb2lkaEZqSnlyM2RQbGNaL0JtclBiWGY5SVZhSGhSYTNBelp0?=
 =?utf-8?B?eWxDL0YyS0Z2SCsvWW1ieEIrUm1rOTFhQ1Q0QjUxM0Y4TkdpZXNFZ1R0RERl?=
 =?utf-8?B?ODJJdjB5S2JzcVJFODAwZWVNOGR3TlVTUm16L3NSMHJ2ZTZCb0M0SFQ2dk9v?=
 =?utf-8?B?WEZxL0VKMmdBM3B5Zk1JeXFYblVaUXV6NlJZUnl1QUZLTmEzWEhtdFBLVktH?=
 =?utf-8?B?UGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d8f58a5-ab4f-4231-0e93-08de02d8cafc
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2025 23:58:47.6038
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Nmmt6b+YlApn0nIG1oKUJbO4aEUxwtMi4ZY9pzgpuBgbpeWsLR7NV2XRs9M7b56ZqyhAbiPxt/3Ao26jnquENsvNVm4i3fmyPsI3ZWkt9Pc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7911
X-OriginatorOrg: intel.com

Hi Tony,

On 9/25/25 1:03 PM, Tony Luck wrote:
> SNC is only present in the RDT_RESOURCE_L3 domain.
> 
> Refactor code that makes and removes directories under "mon_data" to

"makes and removes directories" -> "makes and removes SNC directories"?

> special case the L3 resource.

Why?

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  fs/resctrl/rdtgroup.c | 50 +++++++++++++++++++++++++++----------------
>  1 file changed, 32 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
> index 6e8937f94e7a..cab5cb9e6c93 100644
> --- a/fs/resctrl/rdtgroup.c
> +++ b/fs/resctrl/rdtgroup.c
> @@ -3155,6 +3155,7 @@ static void mon_rmdir_one_subdir(struct kernfs_node *pkn, char *name, char *subn
>  		return;
>  	kernfs_put(kn);
>  
> +	/* Subdirectories are only present on SNC enabled systems */
>  	if (kn->dir.subdirs <= 1)
>  		kernfs_remove(kn);
>  	else
> @@ -3171,19 +3172,24 @@ static void rmdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
>  					   struct rdt_domain_hdr *hdr)
>  {
>  	struct rdtgroup *prgrp, *crgrp;
> -	struct rdt_l3_mon_domain *d;
> +	int domid = hdr->id;
>  	char subname[32];
> -	bool snc_mode;
>  	char name[32];
>  
> -	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
> -		return;
> +	if (r->rid == RDT_RESOURCE_L3) {
> +		struct rdt_l3_mon_domain *d;
>  
> -	d = container_of(hdr, struct rdt_l3_mon_domain, hdr);
> -	snc_mode = r->mon_scope == RESCTRL_L3_NODE;
> -	sprintf(name, "mon_%s_%02d", r->name, snc_mode ? d->ci_id : d->hdr.id);
> -	if (snc_mode)
> -		sprintf(subname, "mon_sub_%s_%02d", r->name, d->hdr.id);
> +		if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
> +			return;
> +
> +		d = container_of(hdr, struct rdt_l3_mon_domain, hdr);
> +		/* SNC mode? */
> +		if (r->mon_scope == RESCTRL_L3_NODE) {
> +			domid = d->ci_id;
> +			sprintf(subname, "mon_sub_%s_%02d", r->name, hdr->id);
> +		}
> +	}
> +	sprintf(name, "mon_%s_%02d", r->name, domid);
>  
>  	list_for_each_entry(prgrp, &rdt_all_groups, rdtgroup_list) {
>  		mon_rmdir_one_subdir(prgrp->mon.mon_data_kn, name, subname);
> @@ -3213,7 +3219,7 @@ static int mon_add_all_files(struct kernfs_node *kn, struct rdt_domain_hdr *hdr,
>  		if (ret)
>  			return ret;
>  
> -		if (!do_sum && resctrl_is_mbm_event(mevt->evtid))
> +		if (r->rid == RDT_RESOURCE_L3 && !do_sum && resctrl_is_mbm_event(mevt->evtid))
>  			mon_event_read(&rr, r, hdr, prgrp, &hdr->cpu_mask, mevt, true);
>  	}
>  
> @@ -3225,19 +3231,27 @@ static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
>  				struct rdt_resource *r, struct rdtgroup *prgrp)
>  {
>  	struct kernfs_node *kn, *ckn;
> -	struct rdt_l3_mon_domain *d;
> +	bool snc_mode = false;
> +	int domid = hdr->id;
>  	char name[32];
> -	bool snc_mode;
>  	int ret = 0;
>  
>  	lockdep_assert_held(&rdtgroup_mutex);
>  
> -	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
> -		return -EINVAL;
> +	if (r->rid == RDT_RESOURCE_L3) {
> +		snc_mode = r->mon_scope == RESCTRL_L3_NODE;
> +		if (snc_mode) {
> +			struct rdt_l3_mon_domain *d;
> +
> +			if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
> +				return -EINVAL;
> +
> +			d = container_of(hdr, struct rdt_l3_mon_domain, hdr);
> +			domid = d->ci_id;
> +		}
> +	}
> +	sprintf(name, "mon_%s_%02d", r->name, domid);
>  
> -	d = container_of(hdr, struct rdt_l3_mon_domain, hdr);
> -	snc_mode = r->mon_scope == RESCTRL_L3_NODE;
> -	sprintf(name, "mon_%s_%02d", r->name, snc_mode ? d->ci_id : d->hdr.id);
>  	kn = kernfs_find_and_get(parent_kn, name);
>  	if (kn) {
>  		/*
> @@ -3253,7 +3267,7 @@ static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
>  		ret = rdtgroup_kn_set_ugid(kn);
>  		if (ret)
>  			goto out_destroy;
> -		ret = mon_add_all_files(kn, hdr, r, prgrp, hdr->id, snc_mode);
> +		ret = mon_add_all_files(kn, hdr, r, prgrp, domid, snc_mode);
>  		if (ret)
>  			goto out_destroy;
>  	}

mkdir_mondata_subdir(), similar to __mon_event_count(), is now unreasonably
complicated. Just like in that earlier change this inconsistently adds 
RDT_RESOURCE_L3 checks, not to separate L3 code but instead to benefit PERF_PKG
enabling to reach the handful of lines needed by it. 
Here too I think the best way forward is to split mkdir_mondata_subdir().

rmdir_mondata_subdir_allrdtgrp() may also do with a split ... most of the
code within it is dedicated to SNC and mon_rmdir_one_subdir() only exists
because of SNC ... any other usage can just call kernfs_remove_by_name(), no?

SNC is already complicated enabling and I think that PERF_PKG trying to wedge
itself into that is just too confusing. I expect separating this should simplify
this a lot.

Reinette

