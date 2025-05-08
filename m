Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08ACF279908
	for <patches@lists.linux.dev>; Thu,  8 May 2025 15:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746719706; cv=fail; b=j6MhjdnFZ3qn39xYmZ5e5UtyvR9Vcp5k31JmaRJWItvpJxqJZI3qFkMMAgFICHWjzvHND49hxIo9w/rhayu+zYRXCc/XemvRBHXW+kmfZDF/GrpMy3Qe9b4zwo3W+vYvla1LDEfUfQSNpRdof35ovii7DTjVjRhD/tUW6GlH1IQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746719706; c=relaxed/simple;
	bh=Tyh1Ljeq92BgEatQRxx+r8ZOVlREEcWdH+cM4NPB62Q=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=g3MeEZaMcR15C/zXOnIVWxPmcHI60eOYqrpfUKISQXrEhtUVyKKHOnf+84JY+M5NNbs4YYPGr6SEMrHDK7J3hCasIyHUkc5QkVH7PloyWLGePGBnMT+T7yLJbsleJh1ptKGrzSWeEzImMUqeGVTgeJcQApJtM9+cVn/aP6Ln+0I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mLb/M2oe; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mLb/M2oe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746719705; x=1778255705;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Tyh1Ljeq92BgEatQRxx+r8ZOVlREEcWdH+cM4NPB62Q=;
  b=mLb/M2oebky6b8HlMdM6LyvEUsHH8eouSoYMHV1C5lV0h1VYqNb/sZFm
   wvscsP1AOF2DeDw0+jew55S0gjfwj6Wd5u0i0Yr4TxLjpnewy5XypukVv
   pNesd5n1M7KGj8zIwxoXuW0s0Zpn//x6dxhgkBxqAadTWkJX5aJgiBsuE
   PQZgtsi+e4ykLj08/2+BP+I7XYVCGKqRzL45t0zfomYRZkfyrju7w4mC6
   3KOCG2zoWE+Tzicc3qvyfzakgflE5+jlbpAhlOCQPDfUHrybzgFCfX7hx
   +6/F/bMYq881wqvxb9yDa/tkXcfZg80ZRA/pHRunrNoASD/MYBzt2efKQ
   A==;
X-CSE-ConnectionGUID: SNxM2Xj7RO++H+D/Bm01tA==
X-CSE-MsgGUID: UCdMIM0/S3mIr/yYTbEzMg==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="48223441"
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="48223441"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 08:55:03 -0700
X-CSE-ConnectionGUID: 0OI+2LEeRaKzlYvwr/tn0g==
X-CSE-MsgGUID: aLVnTIduTEm5JLP9IzNMOg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="159636697"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 08:55:04 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 8 May 2025 08:55:02 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 8 May 2025 08:55:02 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.42) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 8 May 2025 08:55:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XkiSbLlxxGMzgR2z49H1QfCc/aD6bCFtvf3mtdi5CvdL1gKfXFv9GYHN+NuMGBPa9syOMEJl+8MeOqD4rejleoyo65Z7Kvyu5aqJv/mBEkV4QGThQbpqhXhMwuUVFv5ZueOh1ltBYorOqji1mWRkaw+8Z56MUmcETTZmrsC43vzeU1ppey2ifFsmgSMsCdwIz2/UFEp7BBCfdxYPaMgknMURkkFXUjoqZWzePfgvGC6exxBd6srEdPYTFxaPVv7ROfzdDoiGyN93kS+Erwk3mp7TH3Lm/Jf5OKTG88yPJY8AgVqLC1+Bp8aI/z3wNy/RKcDaSRlygjIF9aba6Ff4yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jmF9WSQa6F1rqqJ3qMlS7crOq5dPxKJ+vPSsI3Q9QGw=;
 b=Y1VIaELH1R9n/rfiILKGd8jXDPUTDhgjt7JZ/7kC5auuHQFDo5DkbQsLkNODBtMXnbchmmnBCPMAf0CPVG1DuCnKVzGBFVcLbXDx/yiKAT5FFRjiiwI6R+iEQNUx33djbjHhD9ByCrx+xkPIVq/BcJflTi87RkdLBesRL7094jej0XtYHutxB5K2j3JZi6coTgr3c2FkROb3p5d2IiUB8ANY6fu3uSxZbMq2DmkfZ3/FTqqK9MytyU7tZ9//bUJOkgDqUztpZbLJK4fYjrDlqkAXPux/vvi3LKYwlFCl05gaxYqgmg+/GcKbZPxnJzjwgOo1+eQX9cYFwVKJzWe5Bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DM4PR11MB8158.namprd11.prod.outlook.com (2603:10b6:8:18b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.21; Thu, 8 May
 2025 15:54:32 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.8722.021; Thu, 8 May 2025
 15:54:32 +0000
Message-ID: <d7f5ba57-5237-48f8-a29f-f4ed81eec4c1@intel.com>
Date: Thu, 8 May 2025 08:54:30 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 19/31] x86,fs/resctrl: Fill in details of Clearwater
 Forest events
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250429003359.375508-1-tony.luck@intel.com>
 <20250429003359.375508-20-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250429003359.375508-20-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0236.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::31) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DM4PR11MB8158:EE_
X-MS-Office365-Filtering-Correlation-Id: c027699b-daf7-460a-4076-08dd8e489f60
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|921020|13003099007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Q3A4dFpHTG9oZnRUbFJTNDRFNjVvNEQzT3ZWQ3hzdmdialV3aVc2NzNUc1d0?=
 =?utf-8?B?OGJXV010aWJOUGxqYzZHT3BWUHhHUkFlK0E0NDVNK2NaU04vSnl6VFdwMUp2?=
 =?utf-8?B?aEQ5b2F4UFlobVRKNGJMdWU0YzZyMjNLMEtxY1VDQWZDeXdROHlzWGZ4b0dK?=
 =?utf-8?B?bjl5N0kyMDlzSUFLYStuZnBJKzNCeG1ZRGlpQXp1UkREaENCMkFEcDNaanlY?=
 =?utf-8?B?bVN4ejNPQ3ZOL1JiaGJkREg1SlhnTTZQelVZd2ozTVRJenJ4aENGUkt5MmYz?=
 =?utf-8?B?QWM0dk1KV05pOWRrS0RvZnFJcVhHQm1xU1I2Sm9mV0NHR3puOGxLRUkrNnRF?=
 =?utf-8?B?amxBQlZOallVWngrVENaMndFQytqMlFlQU5INU5vYkUyTk5QaWx0bFN1UDhM?=
 =?utf-8?B?MFRra2RFY25nZ0ZPVGp5dnI1ZFRvbHJJSGhhZzZxU2dUVDBJSDZ4MVBBTm1v?=
 =?utf-8?B?cS9FRHBKanFnK1JvQjJ1V0RjQVpVRlUxZXVoT0x4dTIxbmswYXcrSkNvYkd0?=
 =?utf-8?B?SkU0TUpad29xYXJGMENERkZCeFVWQnZNamJCWnBLRUVsanNOeEUrQkVjYnJR?=
 =?utf-8?B?eE5wVU0xdWk3V3Y3TUFPcjNXUlFhTmJ2ejhOSnI4QXNnOXVnbVVSZG45V3I1?=
 =?utf-8?B?eHBEMHpzNWVHVXhWWHpoYUNXUlRtZEM0UXBJdkY4aTNRNGhtNkxVY0FiL3VR?=
 =?utf-8?B?NWY0NUhWTDJwM203SUY5a01maFlBSUgxaExoNXVqTDFrZlFOUmNnbWQvZFpv?=
 =?utf-8?B?QWd1QzZoTTBtd084a0ZTRTVHWmtldFBnT2pscTdwaFFMMWczd3MxRXhnNEtZ?=
 =?utf-8?B?TG4yczdXbzB1Q1dmcG5lMEFtQ3pHekV3MmIwR1g2d3Z1dy9BU3hBT3o3VnBu?=
 =?utf-8?B?TnFDL21tV3I4WklpdUZkZkJHenQvUUhVL3FKS3pNYnFMZ2FqZmpWdDNPUzlm?=
 =?utf-8?B?NEpsM256dmdzcnEzaDN2amU4VktIdE9McHpoY0lrMWpPRUZMangvTWtHNU5y?=
 =?utf-8?B?Y01jeW1YU1V0YXZzbDV6RTFzb3lScTlpcGhnQlh1NmdIRE5laXlHTnJ5VEpZ?=
 =?utf-8?B?M1UrYnlxQjZRVzQ1Y1Rpa2ludnQ2Y3h6SkxDaFdhNXRxM05nR0hnTDhXRHJT?=
 =?utf-8?B?a1JXcENCVnNIRmVweVBvSkEra0MveGtWS29kL0NLM2VWYitMczFBQVlKN3pn?=
 =?utf-8?B?RlpXWUErSVk4dGtvZ1gvOURhT2hIaTRpSm1hdEFjamhxOG9ZMGllVzI4MEFQ?=
 =?utf-8?B?Zk9iWGhGd2xDZjl1d2lGY2ZaVTAxREMzbE5JWWo1MnBnTzZJRUVOQm16enhM?=
 =?utf-8?B?N1hhRndxcHFyR21FYjNibExRRk5VdGF2RXQ0bnlUSUg5V3pFV2t0QXJtKzNU?=
 =?utf-8?B?MlVzcDhFcS9ldkV0VzBiMVdYbVUyMk5VQm9ycjdYY01Sbmdzc2pqTldFajlL?=
 =?utf-8?B?UkgwTU9hRXp0a1VrUld6MmxoU0tJYVVHU2pRbzFBczg2MG1vM0R1VXFLQmFE?=
 =?utf-8?B?VE5ZcThHenAwMTl0TDNYamhJcXgwY0FEbCtqV2pkUU5RRGJxd1RMQjVhYnZQ?=
 =?utf-8?B?YVZMamlYenpQS2xaTDIveHozNFh6RTA0ZS9SdUw3LzNwV1hJeUJ3YnBObkV3?=
 =?utf-8?B?RGcyNHRoYjRROGkrVnE3WHhZR2tWOHVMTG9jZmhHT243N1g4UEFJdnkzZThK?=
 =?utf-8?B?ZFNkME82eUdMcUpybVg2amdTM3Fub3lnU2NQSG5tTEQ3cVhrMEJpd3hpTGNn?=
 =?utf-8?B?eXdzWGZEVFVoVjBUQ2hOdDNyZFpJdmhwazkxNzJtcXVYaFpEamtEWlhHOEk2?=
 =?utf-8?B?QzFWWGVENEF1KzZ2RWoyKzN4M3BDa0JPWlBETFV6SGQ1Y0QvZU9zTWRxdUlB?=
 =?utf-8?B?ZTlnRG5NSFhaWHhnbDJSQ2tDRWF0bno0SU8raldVRmpEMUZGczFqeTQxSjhP?=
 =?utf-8?B?SHBibU9QWHBGeEY0OUNyaHZxUzdNTmY0eGFxdmpWOXZTd25uQkJ1cVhYOGlY?=
 =?utf-8?B?alFmL3JJZFBBPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(921020)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QVZJMWNOZGRScVJHdTE5TUs3cDJPNldRNzJmN2tMNEZENVhCUVQwb1RGQ05N?=
 =?utf-8?B?Ymd3SEc5Q0Noa2ZXb1FpOXFvUGJiN05Bb1hDK2lYYWEyb2VDVjQ0NXJpMFlW?=
 =?utf-8?B?NVJIcW5PQWdrenZ4bjRPUk1wVjM1RlI1UUgrYzFOOGZRSzhSbEZDM0ZaM1RO?=
 =?utf-8?B?bzFFc2gvTDJjYTZaNmhSeUJOcUlWbXFoNURyZitWNzJMWjUzb3JpUlVhalFS?=
 =?utf-8?B?QTlyOEI3QmhIRUhsSDJkdUwvaUlOY2JTVXhuZmhuK2YzNHNiZTljOENoR2pD?=
 =?utf-8?B?WU9qdFBlM2xzclA4Z3FrU2c1dWl3UTNrdGRFSm80dEhCWlMzd2huOHVnUGVm?=
 =?utf-8?B?WE5ra1VZdXRHVU9DbldITmZTcU43V1lBdDdvcS9SU3dWemt3WE96Vmw1cGZR?=
 =?utf-8?B?cjdDNk9ERUxBbWxKclV0SFhEeDNLYnZzbm51MWEzNCt2ZnZEVzY2ZjdZYnNQ?=
 =?utf-8?B?d2pJVGdRcWcyVHhxa2N2MHhEWWEyWU5wcDdrS0xKU09Bbk1xdnprbnV6S3NZ?=
 =?utf-8?B?ZFRBaCtpZ3ZjMjJYWDNJR2FRcUNmdm8xelR3NTYvWHZneS90UjROV1UzMXRJ?=
 =?utf-8?B?cHJCdm1HUGtwdzdId0RBYWJsN0VWY0VWYlNOVThKMStjb2phek92eWNpSi8y?=
 =?utf-8?B?b0RwaWFaMzA0RktNVHJ1ZEFxblZmWU14aXNLR0FpR2FlMlRyQWRTZlB0QVhP?=
 =?utf-8?B?ZTdhNE1HUUIzMXpOMDNpOVl3RUUvaHlZZG55K3NDckYxQlNabGRjSzJ1eTRH?=
 =?utf-8?B?NnRiZFpvQ2F3SmRwdExmRjNCbm1oRGZkQndGVStWY0hzamdTTVVXQmNlZDJx?=
 =?utf-8?B?b3pselJkU1ZpUmU1Z3h3Tk43L1NvYmtyL1lTeU5TUHkvcXlOQnhzMG5jdHB4?=
 =?utf-8?B?Y3pmaEI2cjhwbFR0MUlCd1RRdUNOR1B1cGRYRVE3NEZlVzJSV2NZU1BkNCt1?=
 =?utf-8?B?TFYvMEpIbFFHYVF6OHRyL0h0QzVsZ2JDbGIzc2JoS3BwdmIyVEVKRmhBTFlk?=
 =?utf-8?B?bTRWTmRoZ3RPdCtxcW93anVVNkhzNmRaSE9nTEpiR29SVFh5a0R1R1dYajNJ?=
 =?utf-8?B?ZW44aDE0OUszWFJyMUZqMXpmb3BLT1Byb2IxUXVEZW5lTmpvSXNrWEMvQ2gz?=
 =?utf-8?B?b3JCV2tOQU1CcXpKYW5RejdQM3lDTVM2WmVFYlNRZ2VLaTRBbkpadUxKVHJK?=
 =?utf-8?B?MXkzTjg3UGtxYTNJVE5wNnJ2UUc5Y0NZWGt2MlpxLzNRblExbWpySUtONStL?=
 =?utf-8?B?YXVXMFEzT0tIQU1JQU1UeUNxcmpPMkk0OWgvUjZ1aXQ3WmlMb0psN1VBejJs?=
 =?utf-8?B?K0dTbWhxWmFVS0Y4YTZ1K2x5TnlSdFdEQVdOMTl6djNSOG03NmNTamZyN2lk?=
 =?utf-8?B?YkJLdjVvUTNYQ252dmNUcy9LOC9NMW9JK25uZ1N5UldkUXhPc3FBR1RtRnZ5?=
 =?utf-8?B?K2lFU0xGZnNIRXlMZHNSeDQ5NGtvdFg1ZVREVEZmeElzODVLdW52ejJXME1S?=
 =?utf-8?B?aWhOZUVaeVFYTTFmTHFLZ2p0MjdHTTVPVzhLaHBmaVIzSkhtcjZYaDU2Mmd2?=
 =?utf-8?B?YzM5ZDhhcEJvRnJsdkMreVM3Umlabk1ocDFzeENVQlJZL1pjWVUvZU5DSHpK?=
 =?utf-8?B?eUpPcGUyZ0dRbmpod0xtZHRramZjZUg4Z2JwVHVwTWlaVCszQ21DNENEOGlZ?=
 =?utf-8?B?KzVkcVFTM2xrd0hDeTlMUk5xcCtoQkJtY0xCQVFrNFRKVUI5ekljM2MvVzh6?=
 =?utf-8?B?Vjl6K0FGS0NYYWl0ZDRGT2Yxb3VING1TeURydnZxdVNHaWNxbCtRKzFWYSt5?=
 =?utf-8?B?UE1OY2hOaERoS1ByV0RxWi9MV1lvRzRmNXZIS1BhSXJNRFFGVlNRSkovdGcw?=
 =?utf-8?B?cGxCWVlRbFE0bHpiTTBuTjVUOFhRcTVQSUZTY0hwOWZHSFc3YmVybTRlNUFP?=
 =?utf-8?B?MzlON0Q3Qi9KV3dobUlhOHEwNU0xbFA2UURHVUNrNDBFWFVXbWhNckVtZ1cx?=
 =?utf-8?B?M1FIdDUvVlp1WEdsZTBYazFFcWd1eVNXaXhCMm0yNDlxSzNZVk1vVGtIRFJS?=
 =?utf-8?B?bDA3WkM4YUhTZjRhK0JCMWlVU2kvNWY1RUt2bFY0NnRVaExtdGErdkVDSURP?=
 =?utf-8?B?TUx1VjFzUVc3ZXY4QjQ1QUhrQkNNOHdCa0NLSzNiVGczVCtrcVVFeUd5Q0N4?=
 =?utf-8?B?bUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c027699b-daf7-460a-4076-08dd8e489f60
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2025 15:54:32.0725
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NGlTNu0fBYmD0h5+gPP3j4xNxqDFZ2M1+ktBE3mRRw8ItRSssxSw0KwpdplLw0hWnCDodUwghRoU/l89HS5d2JITcI9GfvJ5y+/CHXIJ0oI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB8158
X-OriginatorOrg: intel.com

Hi Tony,

On 4/28/25 5:33 PM, Tony Luck wrote:
> Clearwater Forest supports two energy related telemetry events
> and seven perf style events.
> 
> Define these events in the file system code and add the events
> to the event_group structures.
> 
> PMT_EVENT_ENERGY and PMT_EVENT_ACTIVITY are produced in fixed point
> format. File system code must output as floating point values.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  include/linux/resctrl_types.h           | 11 +++++
>  arch/x86/kernel/cpu/resctrl/intel_aet.c | 31 ++++++++++++++
>  fs/resctrl/monitor.c                    | 54 +++++++++++++++++++++++++
>  3 files changed, 96 insertions(+)
> 
> diff --git a/include/linux/resctrl_types.h b/include/linux/resctrl_types.h
> index 6245034f6c76..39de5451cff8 100644
> --- a/include/linux/resctrl_types.h
> +++ b/include/linux/resctrl_types.h
> @@ -43,6 +43,17 @@ enum resctrl_event_id {
>  	QOS_L3_MBM_TOTAL_EVENT_ID	= 0x02,
>  	QOS_L3_MBM_LOCAL_EVENT_ID	= 0x03,
>  
> +	/* Intel Telemetry Events */
> +	PMT_EVENT_ENERGY,
> +	PMT_EVENT_ACTIVITY,
> +	PMT_EVENT_STALLS_LLC_HIT,
> +	PMT_EVENT_C1_RES,
> +	PMT_EVENT_UNHALTED_CORE_CYCLES,
> +	PMT_EVENT_STALLS_LLC_MISS,
> +	PMT_EVENT_AUTO_C6_RES,
> +	PMT_EVENT_UNHALTED_REF_CYCLES,
> +	PMT_EVENT_UOPS_RETIRED,
> +
>  	/* Must be the last */
>  	QOS_NUM_EVENTS,
>  };
> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> index 03839d5c369b..7e4f6a6672d4 100644
> --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> @@ -30,6 +30,18 @@ struct mmio_info {
>  	void __iomem	*addrs[] __counted_by(count);
>  };
>  
> +/**
> + * struct pmt_event - Telemetry event.
> + * @evtid:	Resctrl event id
> + * @evt_idx:	Counter index within each per-RMID block of counters

Where can reader find details of how this "per-RMID block of counters" 
looks like?

> + */
> +struct pmt_event {
> +	enum resctrl_event_id	evtid;
> +	int			evt_idx;
> +};
> +
> +#define EVT(id, idx) { .evtid = id, .evt_idx = idx }
> +
>  /**
>   * struct event_group - All information about a group of telemetry events.
>   *                      Some fields initialized with MMIO layout information
> @@ -38,21 +50,40 @@ struct mmio_info {
>   * @pfg:		The pmt_feature_group for this event group
>   * @guid:		Unique number per XML description file
>   * @pkginfo:		Per-package MMIO addresses
> + * @num_events:		Number of events in this group

Can append (initialized from XML file) or just (from XML file).

> + * @evts:		Array of event descriptors

Can append (initialized from XML file) or just (from XML file).

>   */
>  struct event_group {
>  	struct pmt_feature_group	*pfg;
>  	int				guid;
>  	struct mmio_info		**pkginfo;
> +	int				num_events;
> +	struct pmt_event		evts[] __counted_by(num_events);
>  };
>  
>  /* Link: https://github.com/intel/Intel-PMT xml/CWF/OOBMSM/RMID-ENERGY *.xml */
>  static struct event_group energy_0x26696143 = {
>  	.guid		= 0x26696143,
> +	.num_events	= 2,
> +	.evts				= {
> +		EVT(PMT_EVENT_ENERGY, 0),
> +		EVT(PMT_EVENT_ACTIVITY, 1),
> +	}
>  };
>  
>  /* Link: https://github.com/intel/Intel-PMT xml/CWF/OOBMSM/RMID-PERF *.xml */
>  static struct event_group perf_0x26557651 = {
>  	.guid		= 0x26557651,
> +	.num_events	= 7,
> +	.evts				= {
> +		EVT(PMT_EVENT_STALLS_LLC_HIT, 0),
> +		EVT(PMT_EVENT_C1_RES, 1),
> +		EVT(PMT_EVENT_UNHALTED_CORE_CYCLES, 2),
> +		EVT(PMT_EVENT_STALLS_LLC_MISS, 3),
> +		EVT(PMT_EVENT_AUTO_C6_RES, 4),
> +		EVT(PMT_EVENT_UNHALTED_REF_CYCLES, 5),
> +		EVT(PMT_EVENT_UOPS_RETIRED, 6),
> +	}
>  };
>  
>  static struct event_group *known_event_groups[] = {
> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
> index be78488a15e5..f848325591b4 100644
> --- a/fs/resctrl/monitor.c
> +++ b/fs/resctrl/monitor.c
> @@ -861,6 +861,60 @@ struct mon_evt mon_event_all[QOS_NUM_EVENTS] = {
>  		.rid		= RDT_RESOURCE_L3,
>  		.display_format	= EVT_FORMAT_U64,
>  	},
> +	[PMT_EVENT_ENERGY] = {
> +		.name		= "core_energy",
> +		.evtid		= PMT_EVENT_ENERGY,
> +		.rid		= RDT_RESOURCE_PERF_PKG,
> +		.display_format	= EVT_FORMAT_U46_18,
> +	},
> +	[PMT_EVENT_ACTIVITY] = {
> +		.name		= "activity",
> +		.evtid		= PMT_EVENT_ACTIVITY,
> +		.rid		= RDT_RESOURCE_PERF_PKG,
> +		.display_format	= EVT_FORMAT_U46_18,
> +	},
> +	[PMT_EVENT_STALLS_LLC_HIT] = {
> +		.name		= "stalls_llc_hit",
> +		.evtid		= PMT_EVENT_STALLS_LLC_HIT,
> +		.rid		= RDT_RESOURCE_PERF_PKG,
> +		.display_format	= EVT_FORMAT_U64,
> +	},
> +	[PMT_EVENT_C1_RES] = {
> +		.name		= "c1_res",
> +		.evtid		= PMT_EVENT_C1_RES,
> +		.rid		= RDT_RESOURCE_PERF_PKG,
> +		.display_format	= EVT_FORMAT_U64,
> +	},
> +	[PMT_EVENT_UNHALTED_CORE_CYCLES] = {
> +		.name		= "unhalted_core_cycles",
> +		.evtid		= PMT_EVENT_UNHALTED_CORE_CYCLES,
> +		.rid		= RDT_RESOURCE_PERF_PKG,
> +		.display_format	= EVT_FORMAT_U64,
> +	},
> +	[PMT_EVENT_STALLS_LLC_MISS] = {
> +		.name		= "stalls_llc_miss",
> +		.evtid		= PMT_EVENT_STALLS_LLC_MISS,
> +		.rid		= RDT_RESOURCE_PERF_PKG,
> +		.display_format	= EVT_FORMAT_U64,
> +	},
> +	[PMT_EVENT_AUTO_C6_RES] = {
> +		.name		= "c6_res",
> +		.evtid		= PMT_EVENT_AUTO_C6_RES,
> +		.rid		= RDT_RESOURCE_PERF_PKG,
> +		.display_format	= EVT_FORMAT_U64,
> +	},
> +	[PMT_EVENT_UNHALTED_REF_CYCLES] = {
> +		.name		= "unhalted_ref_cycles",
> +		.evtid		= PMT_EVENT_UNHALTED_REF_CYCLES,
> +		.rid		= RDT_RESOURCE_PERF_PKG,
> +		.display_format	= EVT_FORMAT_U64,
> +	},
> +	[PMT_EVENT_UOPS_RETIRED] = {
> +		.name		= "uops_retired",
> +		.evtid		= PMT_EVENT_UOPS_RETIRED,
> +		.rid		= RDT_RESOURCE_PERF_PKG,
> +		.display_format	= EVT_FORMAT_U64,
> +	},
>  };
>  
>  void resctrl_enable_mon_event(enum resctrl_event_id evtid, bool any_cpu)

Reinette
