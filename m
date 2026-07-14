Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35E1E412BED
	for <patches@lists.linux.dev>; Tue, 14 Jul 2026 18:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784053023; cv=fail; b=TCnwjuQyrxb8mfJikJj41B80XGugI1Pfp1LJQ3LY1w5H4lrb7s0ZrJbqkT3DHx5/uMutZJr4stNjUW7C+NdV5OBN1ofRO0Tkuz/l5+gCsI22HfjLsOXyxmay5CCOn1AzbEdxEMvpQuLZEa5qQa7G/Ml40XAP0nfghF/9fFc0j/o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784053023; c=relaxed/simple;
	bh=WkLz9h6D05QTheiLnz1Brv5wsh09PyLWKHnMCk2krlk=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WHyqYwjvlruEXhYDa0u8u4pR2Ms5acsU0oit3Quxi0DTG0kgBM+Comt9oCecwUHEsM59GfpcrMoOvr5N29+HH+e/XrrnDl1BVSlyBaodQ02ckjiy5X67Cx5yS+GUkJisJ7shoW2+MW07CcgHn8Jkd+YQzz6J+eE8HdnZHzcLxL8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lVpuE6VA; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lVpuE6VA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784053022; x=1815589022;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=WkLz9h6D05QTheiLnz1Brv5wsh09PyLWKHnMCk2krlk=;
  b=lVpuE6VA4HFX4aHi11556toeY/EJJJMNh45jz0MtUikm5zEBUI9oz8sM
   7B8I5kAOz4+K8uW60VzwM4GNweB8w9ImjryiN9x+QGWPclmCp3ROns/eY
   dHItr0PyEYW1bB0nShiAsVcSdz3XtuCtPOmJDEJSKa2+ODnfJ+AGHq7Yt
   7D/b9fTQ3h087UxSPY+Fiy/xR1/ipXIsG7F1M435EEj0LANoOj1cKe4bd
   +Hia9ak7f/N7rHtcMslUyi/ZLSdnLh7jydGuasYsRD8JH77A3eiYgmxhv
   G4s11zik0Z8Avvx/yFZTWFkFkhuws587SRN/BAF8KqE56e0rl1pi79qzt
   Q==;
X-CSE-ConnectionGUID: ppcExVhbQvaT6gmXr5GKIg==
X-CSE-MsgGUID: 5/+YlVATQOev3Pk2iSLgFQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11847"; a="95829775"
X-IronPort-AV: E=Sophos;i="6.25,164,1779174000"; 
   d="scan'208";a="95829775"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 11:17:01 -0700
X-CSE-ConnectionGUID: Y1BbIv6PQMarIX3nIx7KCA==
X-CSE-MsgGUID: JTJ8gxhHTWW2P+oyxNkNcw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,164,1779174000"; 
   d="scan'208";a="294143993"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 11:17:02 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 14 Jul 2026 11:17:01 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Tue, 14 Jul 2026 11:17:01 -0700
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.0) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 14 Jul 2026 11:17:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L2VfjV6oxRmrkMKL9Tzq+MH5y23UjDWjxJgkfGlQzBrnYW8++BnoM3vewU4ueYriB5XU7LfQTHl6w9AxQ1vFymE71cEfPhC9sWGl4vPK0jkKytgEW/Pob6cOKCMYcLI1kwti1fpapSIw2+rR61270CS1qILBHXcxP3wFOk0qHVGMDuoJ/Tw5qZkD0rDKH//IqReQvGliJd2rvunoHuVH0Dh+dBdsMPRBZbXs1joQg3oeVhZahwRXhmzme+Im3Vp4gTF9jb+Dry+lMotFHtqFRoRnt36UjnslVgw9pAUIzkp1NtfWIl60DpYUuqPShJI9O9iQlMae0+bw9DfSRQ6bjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Eiibm7YKTkzR6wIyjlcxTQc0Rxcqo3Wmr3QSCOQfvqI=;
 b=eMBoA3kYlqhBLD+J2EDSGlClMLUGuGlvh0JhCJxNxVnKPFqOp0nTred45AAWp4AcE1pT1FJP8915K9c2tJ/T5PQctQAhOFEqECdav0Ub/xqtB6615XwwGlXlMNoAN8YQy2lwXasw5dYuOn9a7KsM24mFCRjPNXk+uA0P2hBqAToaRAndF2zkwB9BZOzOeatANXnMbj1MxV7nlv4Ur1ROFSsqLPxYABUfNo/KU5/mP39DxVpWqHU07Fw8Qwmcv6DR7XnxxGEvRLPBcPwaUH9UDquU+YNZtgEnjGhOYVIu6W9YkOeIupuzGPfKPQ64NUknv/D0lvASK4Z5m4Z1rv/wgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by SA1PR11MB6685.namprd11.prod.outlook.com (2603:10b6:806:258::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Tue, 14 Jul
 2026 18:16:56 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0202.014; Tue, 14 Jul 2026
 18:16:56 +0000
Message-ID: <4f0124ca-d4a5-40a3-9bc8-3a1e75ff576a@intel.com>
Date: Tue, 14 Jul 2026 11:16:53 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 06/12] arm,x86,fs/resctrl: Handle change in number of
 RMIDs on each mount
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260701213553.15222-1-tony.luck@intel.com>
 <20260701213553.15222-7-tony.luck@intel.com>
 <06cdd789-bf1b-415d-a588-b72938d3b0dc@intel.com>
 <alFbX0tItMg9CbB5@agluck-desk3>
 <e937d05b-8381-4d4e-bc36-7165a7214694@intel.com>
 <alZdWe-DACOtDwm0@agluck-desk3>
 <cbbf71f2-06a0-4833-a7b3-b8c6df440e93@intel.com>
 <alZ2-eJ3yXWHVelp@agluck-desk3>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <alZ2-eJ3yXWHVelp@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P220CA0028.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:303:115::33) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|SA1PR11MB6685:EE_
X-MS-Office365-Filtering-Correlation-Id: 64708c64-77a3-4bce-bf32-08dee1d4166b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|23010399003|1800799024|4143699003|11063799006|22082099003|5023799004|56012099006|18002099003;
X-Microsoft-Antispam-Message-Info: fnZvPzmBZEurtGsJBfu9zhvIqyaiD8i5bCNDRvE5MjoL7QZvw5dnDwFtYzlbckao5uW+aV+tjzI6Ah/bJZYq9ALDIPN79AF78ImIFQiVCrukVl8YeBijAIf+sC2i2yGb7K/2noCqiPob5WF8oOlFHtohgXilIzYwBIvuKDBDXeoNOA18b/cJumFjPECZtk968xMP+Rkpmo/NkYU4HfOeFMhEhMasvBSbIdSc1KNrmEZDpfvSOZBPj75Qc6Q5e20iJjOmev5MOy1K/yrOwNDFaMQe+sTP5jt3t1tqBpxk2Mo3aOxfiO2OMgNUmYOkrF8Ib/vSQuqHivC3D8YEqcRLO4yK2j4v1G5ckPpQOLxUJ0DEHj/8JmTtKwJZjEgMUD3uzU7cZs9rv6SHV5HUX2whT7gAmYw3BodMYlh/cGeqopSxj/QwzXP4RffC8sNKN8RIuHx9REQQZu+ShPs0YM23aw4NsCvqaKiHFBH8zw1KKPEJQhFA01h17AyopIOeAdFucDBby+guzgtPSx5qFi+3fpz2MMoaMscR5/N4Yhk+6drXmSidtMlwVzEttDi57sMmx3YV5CMS2ZxYF1+SP5kbHsrovO7pBiTHvd9IU1SxsQ7LvDCZ/NndniuOskCo8B+W
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(23010399003)(1800799024)(4143699003)(11063799006)(22082099003)(5023799004)(56012099006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NDhDbjVUZ0QwU3hXVjNqeEhpTzJGcDI1OGh0RGE4clQ2V2ZiVkwzSklxNG1r?=
 =?utf-8?B?VG9uZ0NRWEtFeXdTRFNzMDkybUs1dzhZR0FlRTlrT3Z3UnNubWp4V3VQTmJ1?=
 =?utf-8?B?RVl6azRUc1dXL09CRWxqdk1VcFhvMjZCaE1QbjRyRWgvQ0sxMGF3MC9CWUN3?=
 =?utf-8?B?NjZCMkFmbDJObUpZZkgrSldvSHJlUTI0OUVFUkdqQXpxeWJ5SnJYdDh3Zlh5?=
 =?utf-8?B?VlBYNnBxUEZwRjF6TzNDYkVNMVBhcnRlLzNqZmxSMTlCMmJLc3BTUW9xMHI0?=
 =?utf-8?B?c3ZvOFhoRXpiWDVJLzlMQWE2MWJkUXM1cDdsZEdxOUcrWHlPSFcvZU9CRmJO?=
 =?utf-8?B?Nlo5UHZzVm5neWJNY2tHRTZpeWlhaXpvcE9pV2Q3NG1pdGZXK2Q0K0YzTGxQ?=
 =?utf-8?B?ZWp5TDVKWHQyMmJmV0M0ZlhGR3Z4cmU1Y2F6MkxYZFphdE9GWmxpQmpYeTBV?=
 =?utf-8?B?S203MytuYUdZV1NlRWIxNVV6U3hxcWRJcjRLak1zaE9VWGRHVEl2M3BGend3?=
 =?utf-8?B?K295RENHVE9BelBKSXhacG1VbGNVNmQ4MURVckY5Z01FUUVPRmNXUVB0cjZX?=
 =?utf-8?B?aDdkaHB6Rm5pcS9RbURoRWRUL0E2SmtnNzlwZEFYNzZuM0Z3RVdkSGZZVVRZ?=
 =?utf-8?B?M0dLaFZQVEVsRnJTZVFLTng1enQxdnpMWkgxWkpqVGt0TEg5bjlZbzlUdno3?=
 =?utf-8?B?TklMTkhhL1NrNEpwQU5DQzU3RWpLKzBzcTU2SUFMZkovcnl3ZzgyUndMdzE5?=
 =?utf-8?B?TFU4N2pTa3I4cWp5cGZJaVd4bDdET0lvZmhxQTFkUys2M0U0TnR3ZzMxVUdJ?=
 =?utf-8?B?Y0dSa3FERzVUQlNtV3R5NFNlL05uVytVZkFHMTBYVW9aYUx5WTZTYXVUcVoz?=
 =?utf-8?B?UDdEcGgwSGdKQkptM3RmSVhiMXY3eE1BWERObDAvVGczNG5PSE1BRFR1RkJm?=
 =?utf-8?B?M1RvU3NqRmZobmVGcjRXOEpFTm5kaXY1ZXpkYU9RUTgrSDNSSkFNZTl2OGdH?=
 =?utf-8?B?Z1hZbHFYN290NGlTUlA0cTllVWNKVFN0OXpqU3U5cklVVFdvd0NobG5Vb3h1?=
 =?utf-8?B?ZFF3ZmxMUUhZb1AwMkdjWk9yQ0JnSm43bjRDdjZTWnZQTHNNNFM2ZEZlb01O?=
 =?utf-8?B?L21XYXl6Z0tsNUQxVzdLd3U1cVlZRnNyS3Y0VVIyQkNrbzd0d29DTS82akNa?=
 =?utf-8?B?cjJUV2t5WFhLcEJ1WlI3QWV1UGZzSThpQS9uMDM1b0hhaHNUUDZPeks3OWt2?=
 =?utf-8?B?b3VZQjh6SUo3d0NaR21HaVJHblBVcm81QllPa2J6bUR4bmdYdTdDTnNLZndj?=
 =?utf-8?B?ZjRZWXJLd3ZwNTQ2ay9MZllHOGtiOUNYaklISVdGWFV4SkNWK05HMGZBNVdp?=
 =?utf-8?B?VWwySGhydFNMWWl3RVg4WGxmNWhVRzZaRmcxdWlyWjBOOC9yMWsrVUxKU01P?=
 =?utf-8?B?bVpDQnhxMzQ5OTBkZ01vWHpRQnZMVWIxUDJuRC9WM3djTW52SGtWMVYxaTEv?=
 =?utf-8?B?REV0TG5NN0dXNW93ZXZ0c1VWY21BZUlaTllnMXBVMmlJY3lLeUZKSmFhSXF6?=
 =?utf-8?B?b0lDVDhZYXE4OEhvOW45SEk0cW5rVHdoRUhpV21aeUlJTGEzQWRvclpybjUv?=
 =?utf-8?B?Wi95WWN6UXBib2RwOEVBZ0Vaa2Y4aHdJOTNoYSs1TFJlVHNiVFVGNWl4U25V?=
 =?utf-8?B?Q2E0R3hZcE16SEJINitNR3BEb2U1WE4rNXhId1pmK1JyS2lBM0tFRVFreXlt?=
 =?utf-8?B?YnY4cnA2RWJZYk5pN1cveFdUWEJMZ2xTM21DNm5LWmMreVA2cWFuRjNJYnZY?=
 =?utf-8?B?czM4UlNyUXdsaWVmTytvSXFJYWNPMWhqT3p6SEluT2pxcWdaM2hQTFZjbExt?=
 =?utf-8?B?OFlQbHM3Y3hLbWJRQVZydml3SVRRdS9tRXJybkxMVWlXUTFhMXV5N2VsWkZF?=
 =?utf-8?B?aCt1a29EY0lkeG9GYTZPeWhDTG9XbHo4MzF6ZlBOcWNKeWJ5cUZ0QWUyclYy?=
 =?utf-8?B?YzFQdHVnYTBxc1JPNVhEaEZGcDVOWkJNT0hYQ3NDbGc5MjJXMVdnZnFGMDJG?=
 =?utf-8?B?cEE0QmY4R3Bydy9EQTBhbWxRMVVtZm54VUtyTThTcHNFYjZQek52aHNtR2w5?=
 =?utf-8?B?NkFtRWNCNnVmTitYTlVwbFpkNEhzQW9CSzFWSlB5aHYxV1hUemdXMGVsMzNU?=
 =?utf-8?B?d21IZFVqUkpHK3NaZW1zZ2huOG12OC8wODFTQ3pIa2Eva0hlTTdUblNzazls?=
 =?utf-8?B?UUo0VitJZ1ZBWVFHSitvcjV3NlF3RjRHWkdkNkR6MnQ4YmdyVmI5MFc0b1Ro?=
 =?utf-8?B?Y2Y2YnpBc29mWWptL0NHdHpxNTZWa09vL3ZrT20rbEg5TVZCc2NNek5PMnNJ?=
 =?utf-8?Q?nqArdTv8qSSD5smE=3D?=
X-Exchange-RoutingPolicyChecked: B+T18nh3VNIGIiBIKUCXee7k2FGPEJnoMfGdaVo8+sV7MaXl+MYMTsspo8Cvk6toGaFBGox7PQp5+tfnIzikjqiuaRtatH7OQc6A3R+DVtwF2eMww2zPkLoBHA/Z+J3Eikm80P8kDhz4HMD5HoqBUdoznnEam80zpokPeA8ZGFH0JQ7uGvp/QrFNX+sZIuV87917Dlz4/9s5O1fsA2zylud+U8p38ijhp9LDpI1hNSGGADa8T3u6dq9Gc+MQKI56y7DkgL2mTvZJu3akdVCnUgOTN0tvNoBztALPiLaocDwNlsMd8HT+2BQPxvm/ZNUcHJZB5dc/aFZDmLuPSwAbFg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 64708c64-77a3-4bce-bf32-08dee1d4166b
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2026 18:16:56.1223
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v28ZNDrfHlDQFXNUtW0982vIyccu7pt4Si/3+q7IO2DcBp+TRhSD2vxNl9bYZ51JlTKVwLkgiBOBwsELYi7ztTcw84vvLf7NtqhzbmvlhLc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6685
X-OriginatorOrg: intel.com

Hi Tony,

On 7/14/26 10:50 AM, Luck, Tony wrote:
> On Tue, Jul 14, 2026 at 09:45:04AM -0700, Reinette Chatre wrote:
>> Hi Tony,
> 
> ... trimming to open issue ...
> 
>>>> How much to rely on CPUID is not clear to me. The direction seems to
>>>> be to move away from CPUID, which makes adding new CPUID dependencies
>>>> less ideal? 
> 
> Where is this direction to move away from CPUID coming from?

This is the impression I got from the discussions during series that adds support for
LLC occupancy monitoring via ERDT (https://lore.kernel.org/lkml/cover.1782866200.git.yu.c.chen@intel.com/).
If ERDT is the future direction then I do not think resctrl should assume that the
same data will always be available via CPUID also. With ERDT there is a separate
per-domain maximum RMID that should be discovered via ACPI.
 
>>> Here's my current work-in-progress version:
>>>
>>> u32 resctrl_arch_system_max_rmid_idx(void)
>>> {
>>> 	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
>>> 	u32 ret;
>>>
>>> 	/* CPUID provides maximum possible RMID value */
>>> 	ret = cpuid_ebx(0xf) + 1;
>>
>> There is also boot_cpu_data.x86_cache_max_rmid initialized in resctrl_cpu_detect() that
>> could be used directly? Looks like resctrl_cpu_detect() already scales the number of
>> RMID down if needed when L3 monitoring is supported, but it does not take SNC into account.
> 
> I looked at that, but rejected it because it isn't adjusted for SNC.

Right. Neither is cpuid_ebx(0xf). Is it necessary for resctrl_arch_system_max_rmid_idx()
to call CPUID every time or could it use the cached value in boot_cpu_data.x86_cache_max_rmid?

>>> 	/*
>>> 	 * if system is capable of L3 monitoring the maximum RMID value may
>>> 	 * be lower that system maximum. Either because the L3 monitoring
>>> 	 * feature supports fewer RMIDs (CPUID(0xF, 0x1).ECX), or because SNC
>>> 	 * (Sub-NUMA Cluster) is enabled and divides RMIDs per cluster.
>>> 	 */
>>> 	if (r->mon_capable)
>>> 		ret = r->mon.num_rmid;
>>>
>>> 	return ret;
>>> }
>>>
>>> CPUID seems unavoidable in the case that the platform doesn't support
>>> (or has disabled the various L3 monitoring events). In that case using
>>
>> Since L3 monitoring is the only CPUID supported monitoring resource I do not
>> think cpuid_ebx(0xf) can be used if the platform does not support L3 monitoring.
>> I expect that would mean that leaf 0x7 would indicate that monitoring is
>> not supported which would make leaf 0xf invalid? Interestingly resctrl does
>> not seem to consider X86_FEATURE_CQM from leaf 0x7 at all and just goes straight
>> to leaf 0xf.
> 
> I disagree. The definition of IA32_PQR_ASSOC says:
> 
> 1) The MSR exists if either of CPUID.07H.00H:EBX[12] or CPUID.07H.00H:EBX[15] is set
>    (in this case bit 12 for monitoring, It does appear to be a bug that resctrl is
>    not checking bit 12 before looking at leaf 0xF).
> 
> 2) The supported width of the RMID field is Ceil(Log2 (CPUID.0FH.00H:EBX[31:0] +1))
> 
> So I believe that a theoretical system that supported AET (or some other
> monitoring) but didn't support L3 monitoring, would have to set CPUID.07H.00H:EBX[12]
> and provide the max RMID value in CPUID.0FH.00H:EBX[31:0].

I see. That would mean that CPUID would report a max RMID value while also reporting
that there are no resources being monitored. I assume ERDT is an example of "some other
monitoring" and it has its own per-domain max RMID that is separate from the different
monitoring features. How do these different max RMID values relate? Should this
architectural "get the max RMID" be expanded to also consider the per-RMDD maximum when
ERDT support lands?

> 
> For resctrl we have the practical case of booting with "rdt=!cmt,!mbmtotal,!mbmlocal"
> to software disable all L3 monitoring.
ack.

Reinette

