Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94026367F25
	for <patches@lists.linux.dev>; Wed, 22 Apr 2026 21:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776893309; cv=fail; b=jb4UySlKjd9vRp7J871mpbtRgz3LCX8YEt8GixOI62J6mTW9n3Q9LGhqA8/BmYzi/b2HDVFdkm/pjtgVdN8aRn4noAeyLP7yIFnDiL++f88lUVajRedPw7r3+NwAYbAPWbnZUBBODMfRM68rSbVpl8MyqwSTENrrSKigS4+e0YQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776893309; c=relaxed/simple;
	bh=dbytc5HAXJHoQxjosnPvof68O9foP9i0U8tkk5514S0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Wx2DUFCbiA1iM59pEDa1sNCULjb5TnU311X97fR5ZaoW8vOMGLmWFfy0P0YbgrcJti9QFIF/2E5aqUZvmuJ38U2rX2A+VrmtLNIMh3KF6GpZoVseaQo2PlHw/NkSKeupm+Q9B1ShlNwyI/NWoOW9TsIRkcdXbBpY5KfbT5pe0Q8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KysUEYVK; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KysUEYVK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1776893306; x=1808429306;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dbytc5HAXJHoQxjosnPvof68O9foP9i0U8tkk5514S0=;
  b=KysUEYVKcYrbXUxPU23lz5S0gK/R2HHBic0HlBxxOnY4/pZvkwSVSUJz
   6LbyUwg5XLySLmMUl+IFPjDr9ev3emsqPu40o3dq7NW1/VQbX3pmcNAtJ
   mTNHrhDnBJgO79NQIyxnfbh4HS70bvjt1m5Ut2ofHgnp2Sv8aJMzFw+Bl
   6ZnUPe4SRxOVYy8J+m9N6CqfJ1v17k8e+0ZVgbQCp0WpOAVN421usIXJh
   0OcrGJkLbwFVgFvqNkHe489RWYkdO+IRETR6XxHZFtLxq5Rf+Ls41qsA7
   S1//GxN1d+ILBL3lxXlMJVWx1+H2d5lcvveS/np+tIcwsEMIRu588xibf
   w==;
X-CSE-ConnectionGUID: BuUQzYUiRwe9TZmRzwUfzA==
X-CSE-MsgGUID: UH9EhMTYQzuivqeDVLh9FQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11764"; a="77872929"
X-IronPort-AV: E=Sophos;i="6.23,193,1770624000"; 
   d="scan'208";a="77872929"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2026 14:28:26 -0700
X-CSE-ConnectionGUID: SsRK2Yq0Q9y1fXlNAxuahQ==
X-CSE-MsgGUID: BpJljHEnTYqqmVuohKEhWw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,193,1770624000"; 
   d="scan'208";a="236464115"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2026 14:28:26 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 22 Apr 2026 14:28:25 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 22 Apr 2026 14:28:25 -0700
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.70) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 22 Apr 2026 14:28:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qw1WNQ4fYKr9GZSiV3jRS22IktSCY6xEEtTAqsFwEd+7Yya9sG8TmovnGyHs+T9igupqDooXksX6vV4FN2ZthpXzTE18xn2R0ABeFvOH2ph6/T8Q4Xz/hdTE6DGbVvVj5ufNGnUbDOBwgPG9rCfTdQdkhz6zd4gbPGYjIjci6Gpf2ydgVtGdPQtr4tWZFNfqKz7BOHaZlMPHfAY0WrW4l8oqapYgFKMftg/kvwQRoNb99wIPcOUdaO1Q4pkJqKHPAHmElFxJ83kiDKEkCGvrjESkBtjsq/jJpwXRDsa/uGH5sUlDozDt15RKMNVzRFd14aLAthhRa/78ak9dfuOigg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lOfFqP0eYy7A3HPmZfgmngc0hOmEtQSXu2X0+Q413vo=;
 b=W89OdkUShvmblAfad1DGDf8kJ8/xUHV59b61Dn1d1vrqhWVDJ/BahvMjgEQWeqGHo155vuhRADsdZR//6aAKavgP3Cyn/am6D+nm2zjmw7D/5abC0PEIBwwUjNvZLCLp4z7d2Z8t3zBFPCbANqccV+J7JEMrj/0TCPJmVbO6hfb6chhjbgPBw++wrB9M29NuBA84FgsXeVHgktU1pC9JhuQdp3tP4vDBXUC1Hds42OaqHb771JABK9xRWPwlViACqjdcYP+s0GHZcgO9j/E56FVdKoicx3njDkc9SD0tXUUPhD0eHkNop2mXVu1i0iz90vUs20OCcE3mZ6ftF/Z9PQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH8PR11MB8287.namprd11.prod.outlook.com (2603:10b6:510:1c7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.8; Wed, 22 Apr
 2026 21:28:20 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%5]) with mapi id 15.20.9846.014; Wed, 22 Apr 2026
 21:28:20 +0000
Message-ID: <1633a669-ac1f-4ef4-b733-e12bb1c6a5eb@intel.com>
Date: Wed, 22 Apr 2026 14:28:18 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/7] fs,x86/resctrl: Add architecture hooks for every
 mount/unmount
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20260330214322.96686-1-tony.luck@intel.com>
 <20260330214322.96686-5-tony.luck@intel.com>
 <45436044-202b-4d77-b552-2156be47a52d@intel.com>
 <adQY_m8I2jUiR88k@agluck-desk3>
 <e85cd466-2202-4b40-82ed-91e421d8e073@intel.com>
 <adgNfJSeHVyBXumt@agluck-desk3>
 <c948c358-1dcb-4896-9c0d-239e99d89e72@intel.com>
 <adlIdusn61pKB3oq@agluck-desk3>
 <5a62a2b8-fef8-4808-bbcc-c268f9013651@intel.com>
 <aefdJG4y8JS_aTse@agluck-desk3>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <aefdJG4y8JS_aTse@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0060.namprd03.prod.outlook.com
 (2603:10b6:303:8e::35) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH8PR11MB8287:EE_
X-MS-Office365-Filtering-Correlation-Id: 27a8d232-f8ca-4625-5463-08dea0b61365
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: iJrjbKFCB3hbJ5KPwsmlvVa+MCv+H8GqjdaeodwMsGF0XEryCVU3GY4SH9yLhPN+zWBApLBGTKDnrSULIXih0ldIR+5qqBH+ZK5KZLBlNZsQMkB7VCiiF2RTxpCDbcbtuQH7OpuHCk3OknlsqUik0qsdUaAWtXg5F+DWnox18ey9lcJB0UzT/+f7G6Kx3/FUH12yzSrnfGMvEpCnxj1Nj8c6ahrt2z/kX2LC/Zo/+nUB1jDdkRHRALHduusVBUCJ93xJ9s4exg6FWsG4Xyt7lLFwigOID+7tc2DFwe9WjKgB3Eiy6tYCb/nyeht6x7VDjDC51EQ16L9N+FUwkgktjzDFAzcqxC5kJqONI0cDp4qZhxbK7RZ3NgTgKf2NxjOXPygBCG4Vu4Qy5OUPZk7gWe4JJu++jB0fhirmJXnYtavf+i4IU00BDPu4CorP2DTVbTpT2H2dWGR8/x2nt5zDYhLps3+0/ll+7UCrSRrknnGu4ZAFy55X7MRG62xZZu4x6K7xOzOt7mJi98UZjRL/jFt1L6QygEax9jH0EakahL2g/rgrXkRR4P3r0SsINCho+5RZ8txM6gV4MMElkFgBZvniDVZ68JBq6cFtWnJVdeH5Yzblp9kWR9I+x84z7bdXsVDgT9S/tI3h2d22ZH9Qim08GzLlhtlBIUHNEcvUOXOjnO9XKuRdo02lPHWdRd6ZlzVZaJOa8+zyP3FnQ8dJF5gBSe6I6uFQ9y54m9HE83k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VEEyZk5KRDcwYUZtdDkzSFV0YjBBS0Y4RDhTUUJEbW94MDBROWN5cSs5SHht?=
 =?utf-8?B?SXJqK25ZSE9ybGJxQWRYNDkwcWl5UVBnY21NUURLSjNaUHJyT1I4a3BFSklL?=
 =?utf-8?B?bnFYV3BmOHFOMXY1bmRjVEt4WmVjaUpQdXI1cFdvMk53OEU2ZjhUVW9IT2Zh?=
 =?utf-8?B?L0RweGQ0L2w4SWpVT2FDc0FpQW5RWlNZVmVBZnBrNHRXRDdFWFhiVE9OZWxO?=
 =?utf-8?B?aXFnVDNBdFVWMkJwcFI0NTdMZU1mWVR2RExsOU8xWjhrMFVZWCtKV1AwQjJx?=
 =?utf-8?B?VnlDMzdsMmp3TWpZOU5DR1JReXE1NW8ydXB0VnpFVnpQQXk4S21HeE5RWFBK?=
 =?utf-8?B?NTljRVh5bEpTN094eE9Lc2h3SStuNTFnYTJ6YUxteE1VaXcxdGpFc1lOM0FP?=
 =?utf-8?B?ekw1NjViY0tOa3dRRTRyaTc0dkRYQ3BGWTVDbGJTbkNMbmYzNCtSWTJzOXlT?=
 =?utf-8?B?TENsYkw1MkxMZzFQY0R1dzVCSmcvNFFNRk1XRC9DK2NwckduSXdZVSs5SVV1?=
 =?utf-8?B?QnMyeCt4YlR0VmZPTGZmR1pJTWJFSkdXUXhMd040SFRMY2lYNkc5djJXQ2dx?=
 =?utf-8?B?OTgyN28vV3hJWm00RkpleXRMMHh4eURhcUo5RFNWQ0ZFWDBkT0E5M2NUMUlZ?=
 =?utf-8?B?YTErVXBEbVMrMGZMSnV6UGQvdHNkZ0pFcmJvZzJFa0YzRkhoa0xOK1M2UmhB?=
 =?utf-8?B?ZW4zdzlsMEhDT0ZGVTRsdlRBS0NEMk9kQ2pwdzV4djc3UkliTXZZa1NKYTJa?=
 =?utf-8?B?VmVZTDlyZUgralJZU0l2cW5BVDcwbm4xRnhpWERzR3c2UE1ZWG1DVm5pMG5v?=
 =?utf-8?B?cDc1MU43NFArQmkwMmpvb21OUVFURm5ORXFtdHRidDNJUXlYblZiNUd0akdx?=
 =?utf-8?B?NEFvQUQ5NXk5R3craThsSnRXa0lMRmdvNE50eWFXOFFBYW44bmpTZTFPOUN1?=
 =?utf-8?B?eHk0dTNobFhxVDcwU0pHZWxLUDFYRk5jeE5xMFVCK2JEUC9qMUNiSC9JZEwx?=
 =?utf-8?B?RDF3OHRSUk1Xdm1xbnJUQVJORmE1U2cxcjFsS09hbGw3Q0ZNK3lSRGY5K0Ev?=
 =?utf-8?B?SDFObFY3LzkvS2ozU25abnZiQklLelNYUzB5NXF2dzRjMFo2OC9NdnpVdWFk?=
 =?utf-8?B?VnZUZGVYaVorT3RaaVBNOWZpak0wT01lQmlYSUZwQkhnSmxMUDBDUFF0aGdW?=
 =?utf-8?B?M1cxR2JlOHJMemZMV0Z0UGtnanhHaHhhL1NUM3M5M3NETENlT2Jlem9VNUdN?=
 =?utf-8?B?Y2ZxakRxallwSVdxQ0FSL2pQNFU1S0hVM2grUUg2dXhPVSs1MUJkZ1kwRDdx?=
 =?utf-8?B?UENkeTJJVHhXbFpuVjR6NllvOXZiRzBGU1laYnNlMWhVL0xqRTUyakFpc3Z1?=
 =?utf-8?B?YW9HdWhYeCtpdzYwck93VlB0Um03dUZyRndEUlVDV01nMkt5NUk5YWIySlF4?=
 =?utf-8?B?VExoMlpGUXB5dGMrYmxEZUI5WGRWaU1VRkZaN3NKTExCazA5WERKS0cvcHdO?=
 =?utf-8?B?YTBGTERUajhRUEs1eWJucS84Z25DMjdWcVZ2QUgxZ0o4R3NFaGVoZUoxZVhH?=
 =?utf-8?B?NDZ6QXZ4eWdtbHN6SWhYd0VxU3ZoZUlVaE5BSEs0d05CQ0c4dEE0OStWbmxY?=
 =?utf-8?B?NVRhK1gzVXNZbFY2Zm5NVUdnVlNVVklPcXAvYnpkNGpxcnk3WFdQanVQT1Np?=
 =?utf-8?B?dVVGcEZlRnl6RmMrWGFoUkxZWUE4bHBRc25zWWFuOElkM3VlVUhSSnN1QnNH?=
 =?utf-8?B?clVBckwrU1ZlWWZZV2NVWmxyeEMwNm84RDdmV2RLSG5GVEdzZGJxWjVEbEhk?=
 =?utf-8?B?ZHFHZDBqM3N0bVRTTXJIbGtDak9kMTkyMTRQNjZjUzIzVG9iZHpuZHFRS0N4?=
 =?utf-8?B?RkpYUGovSkI5NWh2enJmUndqcHhuQW5KZi9DbmZodzJ5S0VNNW9lRDhuWUw1?=
 =?utf-8?B?YUVuRHNqbG5Gekh4YVYzb3hHWis1ZU9idm4ya1Z4WER4RlZQeGRiV0pqcXZI?=
 =?utf-8?B?V3FTNHA1a0FRcG5iQm8ra2hKRHRLN1R6TUNzcnFzOG41dlUrSm9yRitaYXJC?=
 =?utf-8?B?MGZVU05Cd2xRMTBkMFd0N0JDVmkvQUFLWll6azNQamwzSkYxQ1p1cktKVkxt?=
 =?utf-8?B?OTI1c0tROVl6ejhmN01sb2JUS1JyeGNHaXVBQkg0L1ZpamtxTWxvM3Y4eFBr?=
 =?utf-8?B?MlpTM29jT2V5UUd1UTJxRTVyQkN2Nm5pa01EUFNmQ0hlNXJhR0xyTmxFeXZv?=
 =?utf-8?B?eGlQRS9wZE5FeGhWcE1DbCs1K09vRjhoUFpSRnlIS1FLOUlhckYydmdUMnZU?=
 =?utf-8?B?OEU1TG0rV1B1NHJ0WHkyUzB3blNYNHdzelo5NjFsMzFJMTJjYjlpTm92cDA4?=
 =?utf-8?Q?knkIFy7gYovmU9pI=3D?=
X-Exchange-RoutingPolicyChecked: EguFMLHew90jKCfZ+rTIL93PwbreOgaKez0FwLfwW6wrnFGncdzzh+JdeCVlXEEEj3rDA9MjgnBocpiTVCNIFK/IK287j3ztGYnfnL6InZmmpL3UAInP28JmwdU1JazlHjv0KF8cRmxzsiojtJdn3a6s2C5FIFgolyjnUQGrtaiotJemqjTjuwn5Xic715VqjqDsnpL6jMYLWrP4rfuVo8nGxXXkEQyVl49iZ3XZH9U91U1i2AiFMcb6ElAQcuHH7OiHnH+YGcYM0xwSC2BUBD3hh6ZUhmFuzx9beUYrvE/gac21iYFKfFn9MDawkN+IdzpfjATkN0aEjDwIe3Jowg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 27a8d232-f8ca-4625-5463-08dea0b61365
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2026 21:28:20.4704
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3vjsmsKZ4gOxlVa8BkPSNAZ4USJ/2qweqs/uOBUpWSh95P0D7+/UJWsEsMmrz1XeGIoFN6+53Vaa9mPwXrpUhwZFlD0gJpHbeIXDzEB9UUU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB8287
X-OriginatorOrg: intel.com

Hi Tony,

On 4/21/26 1:25 PM, Luck, Tony wrote:
> On Fri, Apr 10, 2026 at 02:21:35PM -0700, Reinette Chatre wrote:

>> Here is how I understand the relationship:
>>
>> - arch enumerates a new feature at any time and calls resctrl_capable_mon_event()
>>   to mark any event discovered during enumeration as "capable".
> 
> This is possible.
> 
>> - arch is responsible for domain creation and is trusted to do so *after*
>>   marking any events as "capable", any needed per-domain state is created for
>>   the "capable" events.
> 
> This creates a new problem. Domains for monitor resources are created
> for resources where rdt_resource::mon_capable is true. But this is

Right, and both (specifically, setting of rdt_resource::mon_capable and
domain creation) are done by architecture.

> visible by file system code. Maybe the same "capable" -> "enabled"

Right, this is required to be visible to file system because the filesystem
needs access to the domains as well as rdt_resource::mon_capable.

> trick can be used to separate architecture creation of domains from
> file system use?

Architecture creation of domains is already separated from file system use of domains
via cpus_read_lock(). This is already required for synchronization between architecture
and resctrl fs and used by AET implementation that creates domains with
cpus_read_lock() held. The domain list is an RCU list and can thus also be accessed
from RCU read-side critical section but no such usage exists for x86 at this time.
All accesses of domain list from file system is done with cpus_read_lock() held.

arch thus already controls when the domains it creates are visible to resctrl fs.

 
>> - when resctrl fs is mounted, before creating any files, resctrl fs automatically
>>   sets all "capable" events to "enabled". resctrl fs will create needed files only for
>>   "enabled" events. 
> 
> This has a new race. Instead of a binary problem of AET either being
> fully enabled or completely missing. User may see some subset of events
> if architecture was in the middle of looping over events marking them
> capable when file system is mounted.

AET currently marks events as enabled without any locks held. It does so before
setting rdt_resource::mon_capable though and will only set rdt_resource::mon_capable
with cpus_read_lock() held, which rdt_get_tree requires to do anything.

One scenario to consider is if it takes a few attempts to enumerate the event groups
which means that rdt_resource::mon_capable may already be set when a new event is
enabled/marked as capable. This may be a problem, but would moving the
call to mark event as capable to be with all the other changes to state used
by resctrl fs address this? Specifically, by moving the call to mark event as
capable to be with the snippet that sets rdt_resource::mon_capable and creates
the domains (again).
 
With this the behavior of "fully enabled" or "completely missing" can be maintained?
Although, there seems to be some other state of "only some event group(s)" enabled
as opposed to "fully enabled", but I believe there will be no partial enabling of
an event group.

> 
>> - if an arch discovers new events after resctrl is mounted then it can still
>>   enumerate the events and mark them as "capable" - resctrl fs will pick that up
>>   on remount.
>>
>> - arch can only disable an event as part of the unmount handler, this will clear
>>   "capable" as well as "enabled". This can be enforced with a check in the
>>   callback where only rdtgroup_mutex should be needed to access resctrl_mounted.
> 
> Seems OK. But to make sure that events are accessible, architecture will
> now have to "hold" the pmt_telemetry module regardless of whether
> resctrl file system is mounted.

Could you please elaborate why this is required? if I understand correctly the
"hold" on the pmt_telemetry module will be done by itself between the
intel_pmt_get_regions_by_feature() and intel_pmt_put_feature_group() calls.

> 
> Since architecture doesn't have a reliable indication of when the file
> system is mounted (or if it ever will be mounted) the hold prevents
> pmt_telemtry from ever being unloaded.

Why does architecture need an indication of when the file system is mounted?

> 
>>>
>>> This also runs into problems if INTEL_PMT_TELEMETRY is unloaded between
>>> telling the file system that some set of events are "capable" and the
>>> file system asking to enable them.
>>
>> This is existing problem and sounds like you are solving this with the module_get()
>> and module_put(). 
> 
> My solution only works if architecture is called in initial part of file
> system mount, and trailing part of file system unmount. As detailed
> before these calls must be without rdtgroup_mutex held because of the
> need to hold cpus_read_lock() and domain_list_lock around domain
> creation and removal.

Understood.
 
... 
> "Double/split locking" is used at various places in the Linux kernel for data
> structures that need to be accessed read-only in separate contexts. Both
> locks must be held when updating the data structure. AI (Gemini) listed
> these high profile instances:
> 
> struct task_struct: protected by task->pi_lock and the rq->lock
> 
> VFS / dcache (Rename Operations): must hold i_rwsem for source and
> target of the rename
> 
> Netfilter / Connection Tracking: Modifying connection state requires
> a specific bucket lock and the status-change lock.

AI did not need to look outside resctrl where domain list update is
protected by both cpus_read_lock() and domain_list_lock but reads just by
cpus_read_lock() or RCU. I do not see why adding such additional complexity
is needed here.

Reinette


