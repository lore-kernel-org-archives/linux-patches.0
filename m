Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98132242D94
	for <patches@lists.linux.dev>; Wed,  9 Jul 2025 22:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752099252; cv=fail; b=UB1xOx5M41nImNdo34e4QLLE4Ctn6z6JD3aGTDpscNPrypSk+517qFyNF4DEwK3+Yr56SKAVW95FVuevQvmylRLUFNePi5xtO5WciePgQeHrT+GMlb10JJ9osBCAtkxQmAASEeXlC78Ta67Yczbh+7yBEz6PpiDgbd556GWAfvs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752099252; c=relaxed/simple;
	bh=CkBoGFBnTGiYJ2EoqDcdnw06Cw0WLuA8Jprpjvik7d0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=o4dlWoIwz/4M5JqRhl1NyZuJYfLy4HbZaN/6mtevRjTQ6NDJojMAKHI+8WQmFHcfE6joN1hFwwiLytWgbDlH5hF0Ysi3p9Dn3WNuNllVy8Cwfc+N1yDDYZ0OQlkOBL+0faNbmmrtm0DM38EBSVxIKCJjkhxdU5SSruGZmhPO738=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nkvabFs0; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nkvabFs0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752099250; x=1783635250;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CkBoGFBnTGiYJ2EoqDcdnw06Cw0WLuA8Jprpjvik7d0=;
  b=nkvabFs0ABdWoUCLfp7zf50FN7zyxLK7rs7lq9Sw9M3uoOzBINq5fym/
   3myV+SlBCpQwoIjhnPjf33MjBfTTs9j3oMeK1lSuocdlCGwbnIU4Y6vCw
   VKEx/qZcLbTiOCr4nFrma0fsQI/VLDRwE03voA3whnYbGCAxy2+7z1AJw
   O7jakwsfzPFz+BG0L0WoFT4ldu9XkoDChDpMKOTAi9efrG5JpxQkRwBVA
   ajJ2EeuJ8a9+1diTpSlmsR5ONITpeety2JjIW868hRNq3iyChGCVwFYsS
   ZFR0lbFS5tyvrXzngtutHoQmrA+g/CNgAAnuHsarxnIcSdMYOWQD0Bwy3
   Q==;
X-CSE-ConnectionGUID: oUIOCc9IQ9y9X3S4t3SZjw==
X-CSE-MsgGUID: e0/nTPwsTCSXkxZxI2yXsg==
X-IronPort-AV: E=McAfee;i="6800,10657,11489"; a="65722576"
X-IronPort-AV: E=Sophos;i="6.16,299,1744095600"; 
   d="scan'208";a="65722576"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2025 15:14:10 -0700
X-CSE-ConnectionGUID: oY0TjhxwS+WPwvfei88MWw==
X-CSE-MsgGUID: zLgJ/NqUS8OnNtpA6j0OEg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,299,1744095600"; 
   d="scan'208";a="186865395"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2025 15:14:09 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 9 Jul 2025 15:14:08 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 9 Jul 2025 15:14:08 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.69)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 9 Jul 2025 15:14:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pOZrTLBK4zEuFfrb430kw05VA35JJVxByUWItueLVqg1vLuCcsR6XgIvCEirkdwFpHfAYIGi6E05ZzXVTAy2jW9ALqvDSqao439DCeMAY7AiFgBtGFlpEAYkkm6cUBLaZPRuHlOdMhCrT70PrWakrkkNeQbbplPRiklAGy6dyUxQyXyTEqMyiX0HDagaVQB8t0gJk0DGJzkaJO6P0GFbEzpuB+3WYt9Mbq6XXBIkQcF7/YO4Adht+G0fKFsQwrPNPyJv2EKAYinPUMJNEnhx5e0EHM4VsyLssrwu6xsHxT0IzgHhvkKf51gXGk6G0f43dLI3bgy58DZrhPjxhbz7Mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J9/hgHwPrSx1dl/gQlSakyJeCRQT0JdEHNd6chZCnxQ=;
 b=q3lt7euqXmgBq1HDKmkUDKmFBxUwOFIBTDDimeAZ5Wy0QhRSciBFwl7A9roCGzsgMSiKfeQ0D2LeEPhVG98eOkRAbUb9nUCu8lSmty/0m4TB5gdT5PA0btcTFkBXJEXjlqTPsK4g8mKPFSTdy/BmD6FghczDSJwytzSZcbALIXzYzSL0sVBaRqrtbxXa5K8s/6K0F1jo5HgzJYyV5H8NUpJr6E6jiIsepW8jjM/pdWjRYFHgK6K7WSzCdlDMiNT/wZ05xhw5LkL9d94vovb5PDnG7GiSS8WizO7VbfRNi1VEntP+LZpY8N9qb/iq043DIIcOBy/0KDd+MMECom6nXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ0PR11MB6791.namprd11.prod.outlook.com (2603:10b6:a03:484::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.23; Wed, 9 Jul
 2025 22:13:40 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%6]) with mapi id 15.20.8901.018; Wed, 9 Jul 2025
 22:13:40 +0000
Message-ID: <fb180b2e-8677-4533-81e2-174d427f59c2@intel.com>
Date: Wed, 9 Jul 2025 15:13:38 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 22/30] x86/resctrl: Read core telemetry events
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "Anil
 Keshavamurthy" <anil.s.keshavamurthy@intel.com>, Chen Yu
	<yu.c.chen@intel.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250626164941.106341-1-tony.luck@intel.com>
 <20250626164941.106341-23-tony.luck@intel.com>
 <37708e34-9634-4488-aeb7-6a61ab01947a@intel.com>
 <aG7l0M1axoSDk1xa@agluck-desk3>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <aG7l0M1axoSDk1xa@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4P222CA0005.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:303:114::10) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ0PR11MB6791:EE_
X-MS-Office365-Filtering-Correlation-Id: 5132204a-c6eb-4f2c-d323-08ddbf35dbd5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?U2tHdzI1b2YzbExheitiSnFSc3ZFOFptcmIxQzBRZzhTZk1xdTVGdWswcEkx?=
 =?utf-8?B?UnlHc0Jvd0VMcnY3TW1LQS8xV2ZqWjRycDhjU2l0dVcrYkZxeDhwN3E5WnBq?=
 =?utf-8?B?M2NjZEplTGJrOHBuT0pTZjlhMG5COXhET2d3ZUdTN3hhUWNJSzRLb2p1dFBp?=
 =?utf-8?B?b3lSYWZ5eUQrODkwaFVVODJRWFpoZG1EMnJJWUdmYk5wdDVKeURYNER2UDNC?=
 =?utf-8?B?WWJ1VmQxRlpITkZtNHRONnJHL2FucVdtb212ZTluYm1Ud012NExVRjN4bkY3?=
 =?utf-8?B?TktxOXVIZUl4R2kvcUtEQ1piYS90TlRSeU84TWpTQUpuNjFSbVlYK2dpYWFS?=
 =?utf-8?B?SXlHZGMwZmwzaE50S3dPeFVSOXBoT2dmVmREb1dOcDF1bmRzQzdOdU1LTXo0?=
 =?utf-8?B?cEFYZGk2UFNDdW9vbEY1ZmFnMnpZL3IrNjg0VUVxOGwrcGRKTWEvOHZEb2lC?=
 =?utf-8?B?ZkhkbG1BZWJJdkoxNEdMZFNjbm85SmF4emtTSkRhejRqNXVTQnBUbGxreFFk?=
 =?utf-8?B?eTFzT1ZOdEdORVdKYm4vRTgxSjBVZklDZGJobFBUa3d2ZEtaeml2VkJiakpa?=
 =?utf-8?B?Z3kzN1dGQWJYVW5JVEUvUTF0MmJ5T1l5VG5jdlkwQjM5RE80SjRyTDBKYTN2?=
 =?utf-8?B?OE45UzlnZ1M0WlFTWDRoRVl1SStTWVpNUE1OaDRTUk55ZiszU1cvRWZucXU2?=
 =?utf-8?B?ZlczcER1OTg5V0s1eWdhNDVzOHlkcW5mWWlXaWVCa295VGxYN1VTQ29LUGJ6?=
 =?utf-8?B?TlBITEdUeFVpSkZxYVJwZlowSzNjblBLOTRTcWRKTi9JMXZ1RGtQa1NFcWdp?=
 =?utf-8?B?YW9oWGhMRGVBSnR1WWloOFVKSnhFMUVxZWliTEpobExieklkZlFBV0R0T3Nu?=
 =?utf-8?B?dHhydkQ4WnZLcVRicFloZHFkbUhFcU1ZZnpkZU9HTnB0bGN5cHArKzY4bnZ1?=
 =?utf-8?B?VzRFNFdjV1Z6dXN1OTV2N005NWtaZlZpeSt1MVVmNjlQL0Z5T1ZjVEFFZzFl?=
 =?utf-8?B?aCtpNXNhNFRTU3E5Nk1Pa1d3bExGOFBTbHhmNjM1VzhTM2R6TFdtVnJQSVg1?=
 =?utf-8?B?UEZoVjhYVHFTWlFOZGQ3MkhqcTBJNFBMTnFrQ1dENkZUWFZYY2RpbnNsTmNs?=
 =?utf-8?B?UkIzakdEZWkyWDl0cnk4Y0JxZnZPZEZ1Wk4yWUNLVWdxeldIc3RWWTlNbkhP?=
 =?utf-8?B?Qk9xWk5LWW16VVlsZFBPTWFCYXNDUDJKZlp3Ykh5NDFQcC9YY3owY3Y5Nk1K?=
 =?utf-8?B?Rnl0NEYvVCt6N1pJT1NSTm5vSFZ4dlFMSG1uZ2gvSUZTcFBrNE5Qc3cxSUJo?=
 =?utf-8?B?L254UnJrUTF0U3Urditka3FCSWgyTFBaTkdIaVkxL1crM0JhMmEzTFhZalNx?=
 =?utf-8?B?c2ErYkpnbEZ2Z0NuS01kWFdVNDVIblZpQmdFeTFnV1NkNXdwdFhjYzBtYUdz?=
 =?utf-8?B?NVpoeVFSeXF5TUxONnJTUTFFemh6WnFKcFhvcEh4ak9lQ0lTOGozS0NMSllT?=
 =?utf-8?B?cGRKd2FucEtUWHEwSkJGSWhRS1F5ekZCNUZVRytvRUFucWdCMCtGbWZ5dmRk?=
 =?utf-8?B?MGhLU1MvblVqOFdlUXN5dmsrNEw2ZjhSdmpUS2E5UzB6eUdMOTQxWWtXSlVt?=
 =?utf-8?B?TzhPVzZ2a3p2RmQzL3puNmxnT0dvNDc1Zyt6eXVXZmJ3ZWs3NlpjSlB6SHRE?=
 =?utf-8?B?TlNhb3YxTnVMMFZFWDBGcUJtWjlWRjZXL1p2OVAvL0QxamdaVWxGQmxhWjJ2?=
 =?utf-8?B?SjJVUU11YmlobXZpWkFjM0JWMk4xVGpkTXVvVVpJR0tJNnlCZENHNnZOYWlV?=
 =?utf-8?B?eVV2amdvcE9uZW1melRhdVlvc2RseVJLSUlsWEVYQmlNWDZZR1JocnVnS2k5?=
 =?utf-8?B?Q1hRT1Z2VDBjRUJwUWNlNFQvSy9LU1R4eGxyM3hBZjNWVUF1UERldXB1dFg5?=
 =?utf-8?Q?y6uu/KOt1mA=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R05ycEtzL0ZHT2p5Qy9DMXVCbzVFbUpwRGlESkJIaTFuOVk1eGM4REdzKzNk?=
 =?utf-8?B?KzVxWHAxY0lJMVJveThLRDJBOGZRSm92RW5DRU5kS1MzUnpJaDJXVGdER3N3?=
 =?utf-8?B?TUxpbnQwZm8xMmZ6d1NlNU9vYmN6bEE4L3B5WTlOVkhqakhhejhCYnRvbmYz?=
 =?utf-8?B?RUxwc3VlVW5qa0g1QUZ5WGREUFBEWFczcE5qd3BaVWxUTC9xMWhZWXVUVEhu?=
 =?utf-8?B?S3BEZWQ2TFNidzBXWHlmKzNvc1c1Y1dOeWZxTVEwUlVLQ1NVUkEyUUI5WXdD?=
 =?utf-8?B?SXVhdGRPcjZnak1vK2hldGRMZURtdUNDeVdxa0RMT1NJcVpiRWtsUzNrZExv?=
 =?utf-8?B?M1VxNy9rR1IvRTV6OEZzTFlBbFZZdmhscUxFbDVkeWlCdll5Rk5lWnBJbWtj?=
 =?utf-8?B?bVMwR0djbEt4cUxOMytIUUFLemRYdmV1ditCR0srSDdHY0w4Tm16ZnhzYVAv?=
 =?utf-8?B?ZHoyTE5ia010eHZaYVdUa1p1R2NXSzNPT1BDRkRYeXN1eTZadnR6OFRWS29v?=
 =?utf-8?B?TnpsalR0UHRRNUtWWVJNcEJYdXJ0VEg0QmV4akZ1ekNJSllRaHdScWVnZHgz?=
 =?utf-8?B?Z2FyaVNqMU1uUU15Y2I3QmJZTnQzaWtLTXhZNkg5UFpydTRVU0ZSbzJsdkh1?=
 =?utf-8?B?bEpvZ1VoY0JvOWNKZm5kSzhrTHlWSEJwdjlYeXhZR3RaWXRmQXRESU9ZdjRp?=
 =?utf-8?B?UE1pWW4ybFJlZ2VBeHFtT0lEL3UyVm85NGZBSVJrS2lnU1hzdUQrcW5iT3Q2?=
 =?utf-8?B?UG95V01JOEZpcS84MGhDVjdENmhqVERRR1NLWnJHbkJ0d0xXVkR1ckNybFJR?=
 =?utf-8?B?TmxSU0trNGlKU0R3dUJybHNuVk80UXdZLzRKcUI5UUg1c2U5NXAzTW9XdHNy?=
 =?utf-8?B?TGxEaHJQN1NxUUpHUVVRdDlSWlpZWkI2Wi9STk5vQVFKc0c5K1BwUkpsblJK?=
 =?utf-8?B?ZVpIQlNxd1FpYVJkRHhCanJPRWtkOFpleFNnWk1GeHdFUWY0ekRBZldJUVVC?=
 =?utf-8?B?L1F3WTRpVnlzWjg3Mk5wOGc3TDJuWHhiOVE5aFAyR21hSFBXSzJxUTZnK04x?=
 =?utf-8?B?TG0zMlNpQ1llakFzSGlHNjBjcnE2MEEySjBRdVBIeVJCaHEvS3NuTDBITGt2?=
 =?utf-8?B?UzRHcVhzZ2xIYmtkekFvRUx3WnRXNGF0R3BGZWEvM2hKRk9ZNXFNK0NWSDNV?=
 =?utf-8?B?NStZU29LeVZiTm95SDZ6MHUvaVpqWDF2djdkL2dYNHBSaENsTGlOUCswVDhW?=
 =?utf-8?B?cWQwdEc2VlRCODFzaEZUbCt5aVVKb25TM1VYTjhpa3lwTGtRTE1hQ1FKS3dl?=
 =?utf-8?B?WTBJcWpnSCtnN2M4ZUw0Q3NjaXNYRVlnak9QbXc3Qk41aCtydWlDeGZMMVVV?=
 =?utf-8?B?YnRCUlY4bmxodnp4UXVDWU9IYUt3b2h4aFN0VzA4VUkzSWdmamVzK003M0p6?=
 =?utf-8?B?a2QzclV4aFR6cWZCTkd2WlFLbGtZamhvbEgwdVFBclRvOWdVcytEc2pNVGlq?=
 =?utf-8?B?UW95ZUdNS01mOS9DczRadnJyRk91bDBYVkFYSzQweU5zbHdUdi93SFhZdEk0?=
 =?utf-8?B?TzNkdE8vRmFid3BOQjQ5QnZnSmRLbC9Ea0JYSHhDV3UzQ0t4UG10WjZOb0xn?=
 =?utf-8?B?NGVRUUxmZHd0UmVSM01pdmxVMkt1MW5iUW5iSDRlZExlT1BpemFEWE5MZXd1?=
 =?utf-8?B?d2hPdk9sWmdrSll6NE4rME41TjBiRUNnbU1NZjYwQkFHTmlBR3V3cWtCL1FB?=
 =?utf-8?B?ZDRUYlgwWTNPazM5a1hXUHVYQmNubnlXVlR2T0kyNVlZWFQ5WE5GbmQ4N1M3?=
 =?utf-8?B?TnhidVYrdGZPUGpiSVUxSm1KQzVWS1pxSFF6SUl3YmtHdEdPVHM1VUlBRzI0?=
 =?utf-8?B?Szh5M3dVem4vZ1hpY1NGL24yMS8vSHhLMlNWbzFYWTJOUXhHYlBYWkd4Q0dr?=
 =?utf-8?B?bzhiTUFNVkRHUmoydzJnYnArWEZZeXdDSmdZekh0bEUzQkRQWStLUjYxaUxk?=
 =?utf-8?B?NkNOVExNVWQ0RElEK1EwMFg4Wmk3MWlyRm9vZ20rK2ZOaUNtWlQrZDloNTlx?=
 =?utf-8?B?S01KVVFVcndHQUVJb3hHcGdkREZxQWhINnZSSDBQNXFyMmFaVWFHdVhEa0VJ?=
 =?utf-8?B?b3dtaG04T2JibytacVkwSUNqUmZoSXZnMHhHeE1tRS9kL0RhMlNnMzlXMUp3?=
 =?utf-8?B?dGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5132204a-c6eb-4f2c-d323-08ddbf35dbd5
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 22:13:40.0808
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gmNqW36vrBZB3+SL043FlB/sgbKZDYnVWmwCiyU1meWGLFFQsm1rgnXKs3OMIA1TJG1ef/2GEE/QG0l6v5N7NCxRXm9jsJIPB+vVa/OiekM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6791
X-OriginatorOrg: intel.com

Hi Tony,

On 7/9/25 2:57 PM, Luck, Tony wrote:
> On Wed, Jul 09, 2025 at 08:48:47AM -0700, Reinette Chatre wrote:
>> Hi Tony,
>>
>> What does the "core" in the subject refer to?
> 
> The events are collected by each core. But since resctrl reports the
> aggregated per-package values this is confusing. I'll drop "core" from
> the Subject line.
> 
> [snip]
> 
>>> +/*
>>> + * Read counter for an event on a domain (summing all aggregators
>>> + * on the domain).
>>> + */
>>> +int intel_aet_read_event(int domid, int rmid, enum resctrl_event_id eventid,
>>> +			 void *arch_priv, u64 *val)
>>> +{
>>> +	struct pmt_event *pevt = arch_priv;
>>> +	struct mmio_info *mmi;
>>> +	struct event_group *e;
>>> +	u64 evtcount;
>>> +	void *pevt0;
>>
>> Should this be a struct pmt_event *?
> 
> I thought that too. But container_of() gets confused about types (I
> think because the evts[] element is a flex array.
> 
> With "struct pmt_event *pevt0;" the compiler complains:
> 
> arch/x86/kernel/cpu/resctrl/intel_aet.c: In function ‘intel_aet_read_event’:
> ./include/linux/build_bug.h:78:41: error: static assertion failed: "pointer type mismatch in container_of()"
>    78 | #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
>       |                                         ^~~~~~~~~~~~~~
> ./include/linux/build_bug.h:77:34: note: in expansion of macro ‘__static_assert’
>    77 | #define static_assert(expr, ...) __static_assert(expr, ##__VA_ARGS__, #expr)
>       |                                  ^~~~~~~~~~~~~~~
> ./include/linux/container_of.h:20:9: note: in expansion of macro ‘static_assert’
>    20 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
>       |         ^~~~~~~~~~~~~
> arch/x86/kernel/cpu/resctrl/intel_aet.c:311:13: note: in expansion of macro ‘container_of’
>   311 |         e = container_of(pevt0, struct event_group, evts);
>       |             ^~~~~~~~~~~~
> 
> Making it void * is the "get of of jail free" case in container_of()
> with the test " || __same_type(*(ptr), void)"
> 
> If there is a better way to do this, let me know.

Thanks for investigating. I did not consider this.

Reinette
