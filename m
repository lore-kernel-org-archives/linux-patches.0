Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C7834BB276
	for <patches@lists.linux.dev>; Thu, 24 Sep 2026 20:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790281872; cv=fail; b=C99y+TWqqrCURP73z9MeIUztD7JZoK1Av7dyAypGU7C477CQo4cF/u291ZTsOaCsJIYesm+HcLWx4s9E/ObRX1r4iZje6c76NZDZLAtVoL3sjHNg33qCoKdcX2fxxFDzJm2bgacUcnYVAAvMw80pb1IEPSZp9vJgUzzCE0kEUkA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790281872; c=relaxed/simple;
	bh=Ylje8lRNC+x35/Hj9oRZmK9Q5m0CFGNN+Lca/6mmKX0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Q8GI6LDeQGhnEE9zXzo6z53nokagc9IlZq56mTdA2/5uP2kz2g/Bt+EbX45/xcdDho3b8emVbIpJWslq1WV3X8A/vIVH4OgjFBI8rk5JeG7tBngBTIpagf9HnvsMpSjSlw+zPW/GvK6IjefspVxIU+COvg49QiIUhotKUGnWD6g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QUCjHC5K; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QUCjHC5K"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790281868; x=1821817868;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Ylje8lRNC+x35/Hj9oRZmK9Q5m0CFGNN+Lca/6mmKX0=;
  b=QUCjHC5KexdzC7kdXRX6cekdekOxYrp6UE/fLx801sL6Wu8bMeZKYI/x
   k4KaFZD7CgmvJph5S9N+9AlpO4Qn9NyYDdbHB5eGKNpjgTNKwJHiFHtV1
   +dCaaFAmsI3/CgfLRQBxmpu8fs0Q4ZaSpXgPrbES3qM4/aswLMbc47lpf
   8zUi0GTA/g/QAFe3756htBmxN/IvW8TBa8nMhWGsPIu0SLzNGbua/DOFU
   nocm95lhU+RekS+Lb14Vpm0WEkAdeLwqgdqzQmlKBXNbw4y88/U/D4e3I
   xFL5VWlPaRLrWgt/xxw4yDKKKQhLCUkDAB/mVM7NaLZBWh/zadR4CFj6O
   A==;
X-CSE-ConnectionGUID: 8fFu2pN5TX+bGmojZ9FirQ==
X-CSE-MsgGUID: DHPQOdPIQWmtLjHg/s8j+Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11915"; a="89929738"
X-IronPort-AV: E=Sophos;i="6.27,121,1787036400"; 
   d="scan'208";a="89929738"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 13:31:05 -0700
X-CSE-ConnectionGUID: YVHtO8t3QFqHwvvOoZ51/A==
X-CSE-MsgGUID: rDa0m0j3STuOgKLfP1oRTA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,121,1787036400"; 
   d="scan'208";a="271971212"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 13:31:05 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 24 Sep 2026 13:31:05 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Thu, 24 Sep 2026 13:31:05 -0700
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.47) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 24 Sep 2026 13:31:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qnX77DT7hs2oa3YQEmDthnCbinydIo82iOZKCG/mkMpRZl9YhWHwc38IQaPmPdPYS9NZri7RYsmhYe/dc9I8xrled4kaoeY7v3VszMQzvDlTOkD5YFhK56kpPDrzbzFop8LFTBr3fCGcpoPRFFJI3ZPxZgsn3pSUa3qzxWY889MNH3J5tDqX2nETzBoeVKWGtnU0GXsBDK3a286Qe35SMxXOetDF8uUmiw6JOPz2Ll6Carni/PeFShxpQQwqd8vCFxQc/gRTw1qh/PnnHCqvCRMLboW++W4VjUIil79qU0zI3pEaMaqbelMMnpxq69LIFYR8K6bjc4EC8fojkyBfwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s07dCmg0fX9xa/t8C8pxG/wLYDS7N6LFvoF9BLByWNQ=;
 b=W1eKRfeZ4Ti/H+WWjqwp8p7yFB8qBQF5Xt5TDzBpUC4a5arRYGagKQ67EA8om1I9EdFiiHMYoag6cRRl8nhqrUNGifrWonR5QmxP9qwArq9CwbuXTJ3VkoBQy5vvBOwGa4xhW9jgp/+NOX42anaJxLHFwjhxOI51TA6XgZN10Nk067A0JDO1KKaB+DDxIJf2KnKF1/BNbRTeyqePqnhlyqPw7p3yvpBWrx1T+wI0e3k1UnhtbKU3vXrgrL8SHZuXWD8c/rebD5odoLY7oJLDc+whyEAfVixS2QatYIr8oPaCqBFrrNdrGSlFCjvCxWjNxV8m16dvUEnnfIBGb6erOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by DSM1PF9CBAC92AC.namprd11.prod.outlook.com (2603:10b6:f:fc02::14c) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Thu, 24 Sep
 2026 20:30:57 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0451.014; Thu, 24 Sep 2026
 20:30:57 +0000
Message-ID: <6c81d4e1-8058-4940-9a4c-1fe50c7b7896@intel.com>
Date: Thu, 24 Sep 2026 13:30:55 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 13/25] arm,x86,fs/resctrl: Allocate right size for L3
 monitor arrays
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260916231320.14502-1-tony.luck@intel.com>
 <20260916231320.14502-14-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20260916231320.14502-14-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P221CA0015.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::20) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|DSM1PF9CBAC92AC:EE_
X-MS-Office365-Filtering-Correlation-Id: 5209741b-f298-4685-f59f-08df1a7abce6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|7416014|921020|4143699003|10067099003|56012099006|11063799006|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info: ItxjvVrnOpX0Wxsgk2tMnwe8lnIBlHeJFe82uLarmkAB0Vobnu7xrbmDTPqsYSf3o77e7yKGhDExe4zxC746z0tonoyq0i1buBcfnrax+JWsS9qcwfX94OyNCDVwQIkZM1Y8Hbq0MSk45TkpHTuVo75c0VQdpjrVBCXIQLB/5gs9h7TFrLwqLiBiwjPkjsNpfvYGVWYp2OG/7Bd8XWYTPFojCd0vSU7Rmt8k5KMojvmvOVdTZ2g0lNZBNB01h0geoIMpnDCOkUd81HSIHLwyCBJfm6GSHClT7T/o8aArxmBBh3OQBJ/A4Uoy/mxRUcO7/DGlTc4RdzpboxsLL5GwroJdrnzmMNfh7Arei/JZtkRfdekY0faHdQBssory/gHfh6u/dZ+U/JOYePYzaYCWDgJMwndEqiYVptnd2A1mNOJxTJDcno7q/xl/4UyKW+EJTrCtOBXnwb917QIVqaURq2EmtOMgG2ufPGk1LdsEu5TQ4VLOsoVooopvjzQ4q3dEtlCJnjjBVSlopwRSCvesO8AVRqdY+kF9XxSN5U+PinCaIjv6s8sIogUOjJaP/DYUHTK7Ld6UKFOl6ffsKH3rtdYI7z5kscMd7Md2PCpdg55I9CyyUyBFCPYAHfX7WrJsF0FU2LZ1AicJ7juwe+0ZHWVwrdcj4FmPRGp/MCJBK+132pPZNM3Unl5dk6cmphJ9oW64HNTqXnPWf7CGKXD4cg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(7416014)(921020)(4143699003)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c3hlcE9tRmhJdHV2Q3VwT09ad3Z5UldqU0M5MzZEdFBwVFFLUXRlQzhJbU1E?=
 =?utf-8?B?WWNiOHVNNnFLMDN1UTVqTU5nRVhobHoyRFllOGh0SnJESXdrU3VEK2pndTlL?=
 =?utf-8?B?SjhmelhDTmJVdVpMOW5KdWJ5akxLWGxvaytUcTNlVi9qY3RDVVVLWUxxWm5B?=
 =?utf-8?B?Vi9RVE1acEJVbDIxbnhsRDkvTUxkTWVmMC9MWVAyREVOdmdmYWZVT21QcDVn?=
 =?utf-8?B?WHJaL0c2YVJCU0hkUnNjalUvbU9PZWlBT0t5WXVBVW95RG5vd3F3c1MvaXdQ?=
 =?utf-8?B?WjF0Q3N6aURNTlJMRlZkM1duMGluakRiL21DZmVHSEFHQU9yL3BzWjRqUHNZ?=
 =?utf-8?B?elp0VXVialNXZDM1aFpYMHN5NDlkSmQvNWZsVGFxK3BVaTdGZ3VCemNKNzB3?=
 =?utf-8?B?SW5KTW1aOVZzRC8yUzdtVXBKUXBDdytXekZRRnBiLzRCRExPaWljOXVlTFk2?=
 =?utf-8?B?bUpZVmdOeDlJNU1jNERQU1p0RzM1N29DeHVyZzh1cTEzTnFzVDVnNFAyWmlJ?=
 =?utf-8?B?M3loQ1hFdmhkVXZHVlFPem9oY0kwSGlKa1duWGRQalM5N2x0cDdpRHNnU3B5?=
 =?utf-8?B?MnFYUEZwMHhYZy9HS1ZaLzJtcVFUWG5TS3p3akV6S1NsTmJhZ1QvZ25GK0o5?=
 =?utf-8?B?NEN2aHhodm1KUWdlRVkyMHdZZGVwR0M3Nkc4N1NhUE05UWxMZXp3T3ZOUmpT?=
 =?utf-8?B?Slk5TWRBYlpFdmwwRVd2UlhmdEgyQ05xa2orT0QrV2dvUXpCenpnakVDL2Na?=
 =?utf-8?B?QXhvRVMvblpTYldxdGpyN1VVR0NoU2hQWjlQR3BEWXBJczZCT3lSME1rbFRO?=
 =?utf-8?B?VTlKUG1vS0dXSlRwKzRHTG9hOGtFOXpScWcrTFhrcUNUb2VQckdxUTBlS01o?=
 =?utf-8?B?RXAxU1dSTlU5L1UxUFVtbGpCeElOWkJFVjd0MmJLWnBOU09YcllyUnV1bWxm?=
 =?utf-8?B?VW9LZTdONlAxTHVaTnpLbDI0a2NCWHVyU2lNOWc1YjFRLzdPWTkzMHp5L1h1?=
 =?utf-8?B?VFFXY0Q4VUNlNld4RGNxU2gxN2lZUG93dTdTekVxWGlZREZGNy9zSFNqZ1BG?=
 =?utf-8?B?ZEdCaVJjWEVZYVQ2dXZudnNxaDNmZi9nQVE2Q2hoRGNUVkd3OWQ2MHBTcXVS?=
 =?utf-8?B?ZS9YQ0ozbTBrRjM3ZjNmVEM3ZHdEWS83OWNkNHZSTERTZnBYRnAxRFMzNGFM?=
 =?utf-8?B?NGw2Nm5oa3YxUk9QY2s2WFZBaXlDWEtIY29zd2p5cVBSQUlpOUgvU0gxUWpQ?=
 =?utf-8?B?N3dVWDZURm96Tzh1UGlXdzExNVp2Ykl2OWN2V3FvS01jZzY2Znpsc1hsbWpw?=
 =?utf-8?B?bGtMTHBhSlNVR2lKajNEZjRMWU5LTDNNSWhlYUVVcXJEUzM5QXltQmNPdkRV?=
 =?utf-8?B?bVFQL1p5Q1Q3ZXg0V1Q2K1pVd1dFb29aUXJsdmg3VkVWblNZMmswNWJOZ3Fv?=
 =?utf-8?B?UjlXdWFsRkxVV2xCM2JWOWpPRmM5VnNHSE1oQ1ZJNk4zZkV5VlFHU2xIVzQ5?=
 =?utf-8?B?elljYmdENlhTdyt3Vm1HZmJpN2YzM3RNUjF3TyswNE9WdHQ3TUkwL0hZQkQ1?=
 =?utf-8?B?WEJpV1NoajJrYlZrTmZkYk1xZjNlWWNNM0dkbjNZUGdGV2VaSHdOVEdXMjdF?=
 =?utf-8?B?WW9raGl0eDZJSXQ4RkhQQVZLUkptdm0xbldNUlIzV3ZDKy9hNnV3SlYzMTRX?=
 =?utf-8?B?RW43aDcyemx6eStoWmkxa3lmNGdJK2FiQk5GcHUvSWtUbjljUlkxNlB4L0ZC?=
 =?utf-8?B?blFXdmY4SXAvVXBGU2NKZVFEUEF2emUrd2tNb0dZZndzQVREQk1EYlpoRlEv?=
 =?utf-8?B?MFh3eUpCenU0WWsydTZkOFVyNEZ3b0pqbGF3eVUrVjVHNjdkTWdweHQrRERB?=
 =?utf-8?B?QjZJaTY0OEh4cmUyS1ZrZlA1QzQycmh1VjcySDY4NnlNeFg2dktIem1pOUdL?=
 =?utf-8?B?a2IzT0M0ampiTU1Sd05Tb3JWYnNXc0p2MXgzWFN6YVFTNjJOQjNBdE5yMG5C?=
 =?utf-8?B?T0d4Q2FCZjYwZTh6M2M5OTBvQWdDM0REV1czU3RTVXJEUWllRFlid1BNWDNJ?=
 =?utf-8?B?NGZvVHBYeEJOT3lIVStLNzRWL3ZGQVNudGJZa0FSLys1K2hCUnNvUDFZZDhy?=
 =?utf-8?B?b3NmSDFrVjhRU1g4Q1k3ZGkvYTFSbDNRL2RMWFVsOUdzYm90YlEwdlkrZ0Z1?=
 =?utf-8?B?Zzg1YUUrN0dWQU9wKzlxV3YwanQzaEt5WEdSNEUwN1BleHVXSDhKYTBGWkIy?=
 =?utf-8?B?TFpDbllpQXc1SFp0UFJjWWJkTDZLbE9vSFNTbzU0eWpSdjNCTllITytMU3lr?=
 =?utf-8?B?YnROSVVRUGQ4S1prL3FZSVRCZlVqdm1rc3J2aExrU253UWdjSnlLSVdxenBT?=
 =?utf-8?Q?oRE6qqow3Slh1Lnk=3D?=
X-Exchange-RoutingPolicyChecked: nZOFmgVnMNoAlG4sSVNd+ydfmH1+VX/muwBrsF3BPgV97+va2c4lMSxbpg8/HHAaZVurVZF1dM4HicrmfwMuSL7jJ1xO1MoQFUBtC9v1mrv9hG/cSoPo2YJOyjLFQ7lRp4LJHchAr5qzWjXDTrXGZ8yiskojEZqWwcH8QmfMd62sfByVlNxXYjg3Hv0BR70G2JUPHYli4vYJsqhzIiZNa9raR9n8qhoeNLL8W9YCLV5sd9LSQFEwtgjUjh1ByQbiYEdpVjpXjVjhtbVyT1jiA+FtQB0uBT4cX4HA0iWPoyi/PGytb10UUuzO7v97ev5u5wZS1+W87BQ6FJVMQJhF7g==
X-MS-Exchange-CrossTenant-Network-Message-Id: 5209741b-f298-4685-f59f-08df1a7abce6
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2026 20:30:56.9414
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7eAwvIu1uEDCK9+hkQTM8EzLpGvh8mo13yl9Qh04F+wjM7x8KmyOyi3tshtbXRMzkIdNtvxw90r/tzLPJWDAqtgqdyxu/P7ijEWJ3IAtCdI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSM1PF9CBAC92AC
X-OriginatorOrg: intel.com

Hi Tony,

On 9/16/26 4:13 PM, Tony Luck wrote:
> The number of RMIDs available may change from one mount to the next.

The context is expected to describe the context at the time of the
patch. Doing so helps to explain what the issue is and why the patch does
what it does. Starting with description of behavior after the whole series
is applied sets the patch up as a bugfix that is confusing to consider.

> The sizes of the rdt_l3_mon_domain::rmid_busy_llc bitmap and the
> rdt_l3_mon_domain::mbm_states array always depend on the number of
> RMIDs supported by RDT_RESOURCE_L3.
> 
> Add resctrl_arch_get_num_rmid_idx(r) to report the maximum RMID index
> for a resource. Use it to allocate the rdt_l3_mon_domain::rmid_busy_llc
> bitmap and rdt_l3_mon_domain::mbm_states[] and when operating on these
> structures.

Why?

> 
> The limbo code must deal with changes in the number of RMIDs from one
> mount to the next because some RMIDs may still be "busy" when the file
> system is unmounted, but be above resctrl_arch_system_num_rmid_idx()
> for the remount. In this case RMIDs that can be released are not put
> onto the rmid_free_lru list.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
> v12:
> 	New patch. Split from patch 12.
> ---
>  include/linux/resctrl.h            |  7 +++++--
>  arch/x86/kernel/cpu/resctrl/core.c |  5 +++++
>  drivers/resctrl/mpam_resctrl.c     |  5 +++++
>  fs/resctrl/monitor.c               | 30 ++++++++++++++++++++++--------
>  fs/resctrl/rdtgroup.c              |  6 +++---
>  5 files changed, 40 insertions(+), 13 deletions(-)
> 
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index 5535bde7b925..604ab7af7c2b 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -183,10 +183,12 @@ struct mbm_cntr_cfg {
>   * struct rdt_l3_mon_domain - group of CPUs sharing RDT_RESOURCE_L3 monitoring
>   * @hdr:		common header for different domain types
>   * @ci_id:		cache info id for this domain
> - * @rmid_busy_llc:	bitmap of which limbo RMIDs are above threshold
> + * @rmid_busy_llc:	bitmap of which limbo RMIDs are above threshold. Sized for
> + *			maximum supported RMIDs in L3 resource.
>   * @mbm_states:		Per-event pointer to the MBM event's saved state.
>   *			An MBM event's state is an array of struct mbm_state
>   *			indexed by RMID on x86 or combined CLOSID, RMID on Arm.
> + *			Sized same as @rmid_busy_llc.
>   * @mbm_over:		worker to periodically read MBM h/w counters
>   * @cqm_limbo:		worker to periodically read CQM h/w counters
>   * @mbm_work_cpu:	worker CPU for MBM h/w counters
> @@ -444,8 +446,9 @@ static inline u32 resctrl_get_default_ctrl(struct rdt_resource *r)
>  	return WARN_ON_ONCE(1);
>  }
>  
> -/* The number of closid supported by this resource regardless of CDP */
> +/* The number of closid/rmid supported by this resource regardless of CDP */
>  u32 resctrl_arch_get_num_closid(struct rdt_resource *r);
> +u32 resctrl_arch_get_num_rmid_idx(struct rdt_resource *r);
>  u32 resctrl_arch_system_num_rmid_idx(void);
>  u32 resctrl_arch_system_max_rmid_idx(void);
>  int resctrl_arch_update_domains(struct rdt_resource *r, u32 closid);
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index a9109f2bc43e..e633da548959 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -380,6 +380,11 @@ u32 resctrl_arch_get_num_closid(struct rdt_resource *r)
>  	return resctrl_to_arch_res(r)->num_closid;
>  }
>  
> +u32 resctrl_arch_get_num_rmid_idx(struct rdt_resource *r)
> +{
> +	return r->mon.num_rmid;
> +}
> +
>  void rdt_ctrl_update(void *arg)
>  {
>  	struct rdt_hw_resource *hw_res;
> diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
> index 0ffa25199f74..69c9e02d2f40 100644
> --- a/drivers/resctrl/mpam_resctrl.c
> +++ b/drivers/resctrl/mpam_resctrl.c
> @@ -247,6 +247,11 @@ u32 resctrl_arch_get_num_closid(struct rdt_resource *ignored)
>  	return mpam_partid_max + 1;
>  }
>  
> +u32 resctrl_arch_get_num_rmid_idx(struct rdt_resource *ignored)
> +{
> +	return resctrl_arch_system_num_rmid_idx();
> +}
> +
>  u32 resctrl_arch_system_num_rmid_idx(void)
>  {
>  	return (mpam_pmg_max + 1) * (mpam_partid_max + 1);
> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
> index e8775e08aa18..b8bd59c52c62 100644
> --- a/fs/resctrl/monitor.c
> +++ b/fs/resctrl/monitor.c
> @@ -115,10 +115,18 @@ static inline struct rmid_entry *__rmid_entry(u32 idx)
>  
>  static void limbo_release_entry(struct rmid_entry *entry)
>  {
> +	u32 cur_idx_limit = resctrl_arch_system_num_rmid_idx();
> +
>  	lockdep_assert_held(&rdtgroup_mutex);
>  
>  	rmid_limbo_count--;
> -	list_add_tail(&entry->list, &rmid_free_lru);
> +
> +	/*
> +	 * Limbo may be freeing an RMID from a previous mount where there
> +	 * were more RMIDs available.
> +	 */
> +	if (resctrl_arch_rmid_idx_encode(entry->closid, entry->rmid) < cur_idx_limit)
> +		list_add_tail(&entry->list, &rmid_free_lru);
>  
>  	if (IS_ENABLED(CONFIG_RESCTRL_RMID_DEPENDS_ON_CLOSID))
>  		closid_num_dirty_rmid[entry->closid]--;
> @@ -133,7 +141,7 @@ static void limbo_release_entry(struct rmid_entry *entry)
>  void __check_limbo(struct rdt_l3_mon_domain *d, bool force_free)
>  {
>  	struct rdt_resource *r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
> -	u32 idx_limit = resctrl_arch_system_num_rmid_idx();
> +	u32 l3_idx_limit = resctrl_arch_get_num_rmid_idx(r);

All the code changes that follow just switches the local "idx_limit" variables to
be named "l3_idx_limit". This seems unnecessary since it should already be clear
in all impacted functions that the function operates on the L3 resource? These name
changes distract from the functional changes mixed in.

Reinette
