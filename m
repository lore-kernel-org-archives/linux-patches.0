Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61FB4385D67
	for <patches@lists.linux.dev>; Thu, 10 Sep 2026 03:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789012489; cv=fail; b=MndmI0Ak4PiFXNW9OgRcnPhHC3Dzh+lfaK/rXm1P29D7Ulevas2wIEQi8OBVNwbbAuQPL7Jwq0GvJlSoCZ/Od6+Sne3jBjr7yixu1ENgM/KULAhxlvSmlzbXqD2pG/UvTjjlR6p5U3dAeYHoKtSMdv/d532XydldNn7te483ZPs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789012489; c=relaxed/simple;
	bh=CHOYVLFHuWAB4A3TA35CGJVhP/qEuYXf4ceShE9DIFA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qZGZYHdc2JmEW0MDyqICdaq0bWtgrtTalEV+3GbXIdEFJhtBxEM7HVmp0ypbjwHSp6DwBJjqC8ThiZFl/wIw8nKyaf5g6Ws6CRYayGHpN1quFuVWKvSl0nv+cmyg5Dp15td2L1T0e/tHyHuUe+w8YNTXxFVoeWEFLZ+VXxCd47c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Y4isshwV; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y4isshwV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789012486; x=1820548486;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CHOYVLFHuWAB4A3TA35CGJVhP/qEuYXf4ceShE9DIFA=;
  b=Y4isshwVS+nndb36Rj2Po8LrbKS2V/POrQnoeFfZw+z8jOB4fEwEX/qS
   TdDrpQYhVXxGr6GMEY0PMex/AFnPVKHOlSMDZ2I4CdvDXsLsVuUFp3jGY
   87X7Iz6h3vZzj0kL827Ve2t3tLaynMuvwgPEdXNGuM53ZXh/RpIuEQCM4
   yZ4SshRnbuU59Dn5RoqqUUTT9Hk+UGMFakN6eX9FrztaKoMmvLaQuCSAd
   H/3Rm2z826vaCl/bbfVOpkjjwm8Tcz/yxp8RgdeQqKGQwEGM727Mi6qZK
   Bqu4rHXBZCuR6CTbCTxwTnapjhO31J1E5u3WujNxHXb5fja7iFIFUtkcG
   A==;
X-CSE-ConnectionGUID: /jkMUk28TBeghCfmNxQdJw==
X-CSE-MsgGUID: 6BcAS3wAQdud7DWMOoDj/A==
X-IronPort-AV: E=McAfee;i="6800,10657,11900"; a="114997657"
X-IronPort-AV: E=Sophos;i="6.25,271,1779174000"; 
   d="scan'208";a="114997657"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2026 20:54:46 -0700
X-CSE-ConnectionGUID: wjeJaCl5QmK8foBurz85Og==
X-CSE-MsgGUID: en96C0fmTNyaZZKjMwbWIw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,271,1779174000"; 
   d="scan'208";a="269745963"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2026 20:54:46 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 9 Sep 2026 20:54:45 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Wed, 9 Sep 2026 20:54:45 -0700
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.29) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 9 Sep 2026 20:54:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lpKqJwh7QdCHiFAaTihCabThQbMzHeT1UUyD+OvvBO8qEH9Y0agcrZ6ZNY8sdo8spv7x3SEuziUXCTppvR7dMvZ7wXYscUJf0ERaMt6UW1FHLpDq+2SDmuMsN9KPKcovtstSbX8SKgn13YJ8OOrpN8pkFq9l6Zb7e07ytTsqAimNS10hkcegVtnZlgdo/4fdpnJz8/u7eWdDuYSBVLpugiUN0xc6LBcSGLc5LmaVZ832k71o0/OGDiigtrFfOWfK+kOlKllOzZex/rzzg8fFMWEVoyr2T1hjD/Yrb7Z0YqF1i7vzXXdI5Ddoq2edOX916ceWnFzm8uKdJ0UnWZ7NUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VxPdyl88YawZbxtI3iNq20NwnZDh6s6t9YG2ZpOcrgk=;
 b=j8kTB+ghGYaE+my93KjfHX0AVcYCc8+kkh9vILmm8LnB2RPopa7JQfQff5jop3q3gHtHItzEOuQ4K1/dxDkCrCV1YFf5bAd+WTZ5wb/EIr3I8kxuWxrcR2I3EQXK3zRkL3fyyDu8/MlP3UoeibwP6rsC4pTPAAVPybswkyL2XrR/oxYceeQvJ0L4N/dkVtxbYEs3ULUYo1eYA1qSiRZ6nHE/7ePcmqkd6kt+Qn2H4zfDnpplThZIMFWlo9jhwCLRm/9pCLbcvryto1RvJdTEIXdCK94dmBDfpaBLNuaWVG8R8rLA20ien6Hk+OoXwi5p86xJte+xB2VzNI00mnCS4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by SA3PR11MB8073.namprd11.prod.outlook.com (2603:10b6:806:301::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.9; Thu, 10 Sep
 2026 03:54:42 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0406.005; Thu, 10 Sep 2026
 03:54:42 +0000
Message-ID: <71417f71-afd7-48a6-a612-7fbb4e90c6b3@intel.com>
Date: Wed, 9 Sep 2026 20:54:39 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 03/23] x86/resctrl: Enumerate monitor features in
 rdt_get_l3_mon_config()
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260831174421.13921-1-tony.luck@intel.com>
 <20260831174421.13921-4-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20260831174421.13921-4-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0216.namprd04.prod.outlook.com
 (2603:10b6:303:87::11) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|SA3PR11MB8073:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d6acb8d-30f6-49ed-311f-08df0eef3e75
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|23010399003|11063799006|56012099006|4143699003|3023799007|10067099003|921020|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: 4FO/lEJ4hgD7JAPq5oOfjj1JyW4WaJycB77+ji3rbXy2EX21zSL3I2fr2g50eNEdw+XR4SdrjqsOkgvbf716ypFrob0u1RTFFu876rfbJiqztTlHGcvgizowbep6jl2HPiWWKgxaoQY2BoFGn/+K+I3VBQbzquiISugCJ1mo+2oG/bA2qSHcU1bJ5UQJnaXbN2p+5J1MJEu5OijthBVGIhFp6Si+06MTc1ePh7sCkczP0KMGeU837X8/zCzkmlE5jR5M7ibdkIseZnRqIQ6jUMfRWqb9lskeAXTFsuAiDMCqqxGKyOP0mClQPdtiETMLV6jAh6ZGgw4xv2don9OSVzBX2kaCLnDwkJSIQ3ptl2GC15GkeK37liqOwWc8PWfF+M/Jf61akW0d0ggykdBu87dMbdtfGxX5nwTLzweoWeXdLwmWCIrh2Rzg/zJrj1hZCpQwCZfZbbEppBpcvhCx19FsOtqCCtccTb1AnGP+52uYD3C/DeUA1PA9pYBgjQHS1qLrft0GMX7o7BEGQzKCCZW6xkuQ44+vPneFeqhS3c8UMLqQjPu0R0lMs7zlCflTEq6R9zRu6xmkngKc0gjL38Rmrn2CSGjpT6UQhRr77XQQhbbK/NOWRrhMCNh0Rd0nqz3LM1wb7f6nc+0mDs651VKWZyRUFIDIWMlMiCEdkjGOZEqCF4GXfxtJgM0AHITjiKFIl3JHuEGY70/KgjdCWQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(23010399003)(11063799006)(56012099006)(4143699003)(3023799007)(10067099003)(921020)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YTNaemo5aWNIQ1JRY2JXRWFiR3YwVTFKN3Vmd2FCSFhjRHVqekVXazA1MlFL?=
 =?utf-8?B?MDJCOWZGVjZSbG9jd05kVTNINVBSUFp4elp4b0dpV21JQ2hYODVsanRqTUhB?=
 =?utf-8?B?MFRrOWVpbnV3RnYyTlk4Ylp4dlZ4dFBRdlZEdFpFU3R1WWxuVXFYYnVDeGxI?=
 =?utf-8?B?bVlPZCtmVU1ucEdqNmtwVGZ1VjJLYjhvdklLbVZvTVRlWGljODlZWTlBOThQ?=
 =?utf-8?B?U25sNzhRcVBJTzNpeDNweGEzNW1PYk9MNFZPOUFiSkN5UkptY1k1ekttMEdW?=
 =?utf-8?B?QlNyNDhZSGIxVlRXbjRRSTUrRGZCZW9OL21CZVhYL3dCRVh1bzBIejZFTDJa?=
 =?utf-8?B?WGZvQ0xVTm1kOWlDeVQ5Wk5NZGZqczZrKzV1clpWY3VDSHVKZ1dRR2JpVEx3?=
 =?utf-8?B?NStiaXRrYW1ENXhKM1JIaDN4STRZRHFPQTRmWGRsWC91Yk1Vc1BiTXRuaFR3?=
 =?utf-8?B?QmNyVytKV0NVQkczY25mMXVoeXE2L2hEaE4zNnlETEtXNjhlU0l5TkQ4Y0ZY?=
 =?utf-8?B?VlYzU05kKzlER1FTRWROK2dMQ0xQUW9tSFZLbTlNQ2Z4Tm9mNENSQmNhNzlJ?=
 =?utf-8?B?SlE3ZnlhZ1UyYUNPNHJoeHNvTmYra2hWSWY1dDBnNCswUnlGeTdEVXJGSjdi?=
 =?utf-8?B?Und6Yyt4OWtRQVY2NVY5RjBFNitQQ2syWmVadG9MQm9heXVXVHI4SWd6YW00?=
 =?utf-8?B?amg3OHI5UUNDUUZCN2NsS0ZHb3N0OUUxUkJYKytnQXc5SzhyZEo4bFlKVzNn?=
 =?utf-8?B?akpacENWbFFmUFFDUlpaa2pXdWRBS3VVMlk5WnlFejV1cCs3cjJabXVsa3E5?=
 =?utf-8?B?U05xNjQvWEI3dWkwNGMrcnVGb2pEVzFTc1h3aW1rT3Y0dHJRR0F6aGtPbUlz?=
 =?utf-8?B?WHROcHR6MEVMa3JNMjBMSjBqUWFrblFTWEhseHprK3JEQkxaRVM5LzhPOHVV?=
 =?utf-8?B?UFl1Yjd4STB0NmdrVU1wN2xQckVTanU0WUMzQS9PQ0RSZmx5WlltRjNnQ3px?=
 =?utf-8?B?TVgyQlA1MlZidXQ3L25lRXJOM2JZK3AzcndDWWdtY3VWWW9RUHJvWmxxQUM5?=
 =?utf-8?B?T3JzeDZ0L1cxcEhQdVV4bkJzWnlKVWFXMUN6NHFXQmRPSGYxT3YrcVVFd3VC?=
 =?utf-8?B?OVlidE8rb2ExV1c1RDZPbG9scjRtc2xOTkVJK1FkdjlRSGRnd1l0VHdCeHVq?=
 =?utf-8?B?dWdUTEN0QzNhREZwTlZBaXZHTmxlWXFxQ1haQU12ZXdJVUJHSWZwVC9RK3RN?=
 =?utf-8?B?MlVVcjR4MU1rRnlpbG5RanJIYzEvSXFtNmh6TlZaUW1Fd1VEOWtpSmZoV3FT?=
 =?utf-8?B?SmQvUlVCWUlCaFR0MTE2QWhUeUh5cWkrem5DZ3o0NHdydVN3WmlkT1IvNVJt?=
 =?utf-8?B?T1VOTzJYWkFlOStMOXVnbmJKK2piM216UFo1UWI4dS84ZjRnTGk5c2Z2RDlK?=
 =?utf-8?B?dWJRaVBXQlM3QTIvN1Q0R3FMQzZCMWVINnpSeG9GbDk2c2tDcFo0STZ0SkFp?=
 =?utf-8?B?MTJ1YW1USHRqeWZOREc5M3NkTEVWbytEYmpwNmhUdW9KMS9pK2tXTHFxOWli?=
 =?utf-8?B?RDNhZ0h1a2ZMVWg0ck1uTjhhWUJQeFl4WGFNdEIxb3BGQU5KR1pRMlQwZFJu?=
 =?utf-8?B?Z2FOQXZ1TFZrbmdqQVFlZ2NVWlViOTJSKzl0YjdsTzBhOWpZTE1mYzArb0Nh?=
 =?utf-8?B?d21pME1KbHBKNW1va2FsZktYQy9NS1h3WmtVSlNkRTBhVXdQb2JHeVRkQll4?=
 =?utf-8?B?aDNTT1JjODcvbmgvZnlscThBc29RclRJU3BQaEtCUk1CczBzbWk0cEJ0VmFm?=
 =?utf-8?B?MkFGTk1aeUt1R2Q4aG5XeGFpZ2piMWpsTzNlb1F6ckNSOXBrSGxzVjFJdnVM?=
 =?utf-8?B?WUNZRDJVNUxYRmdQdk9iZ3B1aFlNallBTUhROVAxblFXNEFNV0I5amlDdFM5?=
 =?utf-8?B?Y2w5ZytqKzdrQ0prNXZIbExxQStRb0w3WVhsWS83cVRPb1NRMkphWkhOZkRx?=
 =?utf-8?B?Y2xFTEthU1ZTaUgwcU96NmF6c05FZzA0WDhJL2xwMlVGQ2MrNzhUVHQ4YWJ1?=
 =?utf-8?B?TUUzUUw0QlVya1lwNFJ6WmFodDlNVVdETkVKeUFXQWo5YzdJdWFKeDY4eHkr?=
 =?utf-8?B?blgzNHNCZStZK3FObW4vZEdyQVlrN2tpMXlOZ0ZSQWtvSnQwZThUTzNQZzBu?=
 =?utf-8?B?dkFpSFlVb3Q3WTFFUkZFLytHdlllYkxYa04vRkpGSkhSWkl6c2FHdnBSMVNT?=
 =?utf-8?B?WVdQdkJrOUttcmlmZmUySGlxWXFVRUdyY2hhbVorR1Q2Y2dKVzY1bmpyeURW?=
 =?utf-8?B?bC9Va0pIc3hLVGxBQnFOb0UxSFR5bWh5LzRtSkRNVjlhK2xmbnE1WTd2eVNB?=
 =?utf-8?Q?pBmY3MWdN7K4DlT8=3D?=
X-Exchange-RoutingPolicyChecked: PJ1jQF1ERXXPvHSEoiU6WqUeFxcOFwvNnqVcemQ3LOUqwbrHU2xBtMuUNwSJ3i6TdvKBFiO50aXaU9OzQk/oY2QF8gMdrDTngeALOiSqqQDxCHFtoF3K1x7qRPcgkgSqf5WgEx1Ebos+AoMMuhnTwqLciZtan9MnLwiI5ucK/NCfMKXmxz4/BAK6Cn1nsDqq34uVXtiO7PUHx0/e6qi5gygVLF4Bp2dfNHuDRHnLqefIfkxDxpCNSD4ea/eq2/YdVBJWoDNqwdoEpOIWQBBznoHIDe9mJ58eq094dJLBMdboex7/q0z7FRB0kpQcgePtigDTeHbjSpsFAUdL3MNqJQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d6acb8d-30f6-49ed-311f-08df0eef3e75
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 03:54:41.9009
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6dJ/vpwIhrn/pH1quOPPFhaXBgWjYDuC0QYOdG5gUJlHfqDI3Iu3gwuYWfq8RO8iRXFxqIherB1aEqOFtg9e1INLoMiyO+JzWwzKXcgCXeU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB8073
X-OriginatorOrg: intel.com

Hi Tony,

On 8/31/26 10:44 AM, Tony Luck wrote:
> The original implementation of Intel Cache QoS Monitoring (CQM) planned
> to integrate with the "perf" and "cgroup" subsystems. With that plan it
> made sense for parameters from CPUID to be stored in fields of the
> cpuinfo_x86 structure. But that plan was abandoned and the resctrl file
> system user interface replaced it.
> 
> Enumerate the L3 monitoring features in rdt_get_l3_mon_config().

It may help to append something like "... in preparation for removing resctrl
fields from cpuinfo_x86." Otherwise it looks like this patch leaves dead code
around.

The last sentence is actually confusing since rdt_get_l3_mon_config() already
enumerates the L3 monitoring features, no?
> @@ -418,16 +423,37 @@ static __init int snc_get_config(void)
>  
>  int __init rdt_get_l3_mon_config(struct rdt_resource *r)
>  {
> -	unsigned int mbm_offset = boot_cpu_data.x86_cache_mbm_width_offset;
>  	struct rdt_hw_resource *hw_res = resctrl_to_arch_res(r);
> +	unsigned int mbm_offset;
>  	unsigned int threshold;
>  	u32 eax, ebx, ecx, edx;
> +	u32 num_rmid;
> +
> +	/* QoS sub-leaf, EAX=0Fh, ECX=1 */

I know you just copy&pasted ... but above is not useful. How about something like:
	/* L3 (ECX=1) monitoring details via resource monitoring (EAX=0xf) leaf. */

> +	cpuid_count(0xf, 1, &eax, &ebx, &ecx, &edx);
> +	mbm_offset = eax & 0xff;

I find GENMASK(7, 0) easier to read and matches similar enumeration in this function.
I am not aware of an x86 requirement to use one or the other though.

Reinette
