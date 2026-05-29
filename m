Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48AFC36C5B2
	for <patches@lists.linux.dev>; Fri, 29 May 2026 03:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780026310; cv=fail; b=lIl+PWOzw1CSoa/rizlHooXpXjHwmC4czr/GkxA1/q/GM/RE6OvQsRUaByZ4FEr4FhxA+1DU0Ivy7dXHz4OG1moHMdfyAZ8n2jPA30RKPUhfnHGclP5GqOVmTc1pBlv+iRU8y5YpzlAdlqvO4DRTJbdZFnBR/SVDS/2VPf9RAk8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780026310; c=relaxed/simple;
	bh=F9X1dNwVdIYn5EO4LAObUl9CSU7ZVdA9o5KrzNMFch0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=LGUrP9SXKpYfnOZ4qsZT0lLisUHAlQxWifjd5DxlCjpbEFiWqnAuka/4hEri3K6CLNGTnJtyd0ytz/PjodzcVjZpNn+XwmIYV/zGGNT0/uqfTilMdvJf82AvOAzM9cDRbElcgP7Iw1wvYameaQ1HV+jktcQEc2DNiBcvIM6rxy8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ilo3kIvX; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ilo3kIvX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780026308; x=1811562308;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=F9X1dNwVdIYn5EO4LAObUl9CSU7ZVdA9o5KrzNMFch0=;
  b=Ilo3kIvXI+C68PQ0yTy+TArSjVhBFhLnyo0Wm6HWZP0qYVvrl26blW+7
   AVrxtoMLuvqsRmaATMQWrx3Nt1OBpaleS8JWNTEM76M2+afEIE5ve2/aM
   OAmP/QZroBrE41En5xDiXMH5L1cp4ST6YYRZQmESVWsyQJUznrzwJSO0p
   FI2qZMBzD2UxUzB93crH78HzoWGoYI0ER9amwIZFdE4hL84GpWthXIau9
   3otIeiWiRyF34rafNUDJJjCKXQP153BVhBRHgfxuweCOd5sJ0fmYfeDqg
   o75lzJZ+R0oJOboLcoDx3VRIY0aKT787RcM/c0KPOErAqJhnwI9+9JV3E
   Q==;
X-CSE-ConnectionGUID: fvLR5/AySTG/yAhJtulfsQ==
X-CSE-MsgGUID: 1IJfXHTISjmJfDAxT7b5Hw==
X-IronPort-AV: E=McAfee;i="6800,10657,11800"; a="80601777"
X-IronPort-AV: E=Sophos;i="6.24,174,1774335600"; 
   d="scan'208";a="80601777"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2026 20:45:07 -0700
X-CSE-ConnectionGUID: Yghv+vDdSK+2mdGGX/j8Lg==
X-CSE-MsgGUID: o1dmYc4/Qy+Yr8Ll/cvgPQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,174,1774335600"; 
   d="scan'208";a="242585632"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2026 20:45:06 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 28 May 2026 20:45:05 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 28 May 2026 20:45:05 -0700
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.69) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 28 May 2026 20:45:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UUgNPpmVO9cZcGCDUeYBVXtKTdlCRa/vrktKaxawm6CPzl+EvCrEQ9MSeEG42ITr8q33x/0iTwPHbadF/fBc8tV6G12jirY4h1X4vcB+R75Wg8xB4G8MkH3w3IcUCXtXsRGBCovNROyN4H3B0TKMLmPJWK02FZVOkHY2NvR2TDBB+g3vQLSP5MNowZ2mm/IR1MJYf/XnxuyVXcTrlYRAHPOJoAnMKAHIxh06pSSiDfhbqkaU51QxmfbVrzXZUew0PacCWY0s/JR538rm/I0NOGRrdqFrYaIGTDMHxO9YCRB5GZU0Ukt1bUh1l1qudLhoiXX0HwucQANGz2FnOwRGpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=88tPQJkWHwLesr5fepHnMRE1KoRmtcYTwMCaztLB9Ik=;
 b=BhLSkE8LBnLQ6BkI2pidyu3351f7U02vZ25vK3dm+mtI52NFS+DzEuiPyX7h57U7d/RsFMtxgJSnLopxM89ZJ7BmrWl2HfoafK32ebsWQOB/ZDOcL6SdKNFPQuxX+hDbLey9cTQrUgbeyScW0H5Ot7zkGDgjjRFAGFA+ej4WSgYJlgX7sQLfIH4RrQ+cZiaYDr4gaxLf33rMz8k3S6W3DIyGKxPQlXMZEOM5q7gRfN1o2zs/IZYegY13/3NxVXkUShOQbYTMXiuj9EvguY3RksKDpiHshvJMVQQ/4cXR2Bsbc/sm8Cu+6eroSV2/A8ZAwiYFecNngUeZpUnFiSWl6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by DSVPR11MB9555.namprd11.prod.outlook.com (2603:10b6:8:388::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.20; Fri, 29 May
 2026 03:45:01 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%4]) with mapi id 15.21.0071.011; Fri, 29 May 2026
 03:45:01 +0000
Message-ID: <62975502-3d07-40ee-8ceb-c906a8c55c5c@intel.com>
Date: Thu, 28 May 2026 20:44:59 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 08/10] fs/resctrl: Change last_cmd_status custom during
 input parsing
To: "Luck, Tony" <tony.luck@intel.com>
CC: <james.morse@arm.com>, <Dave.Martin@arm.com>, <babu.moger@amd.com>,
	<bp@alien8.de>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <ben.horgan@arm.com>,
	<fustini@kernel.org>, <fenghuay@nvidia.com>, <peternewman@google.com>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <cover.1777419024.git.reinette.chatre@intel.com>
 <4efad346b8e4dde0b84ff3e87c635852b6575aa2.1777419024.git.reinette.chatre@intel.com>
 <ahjR2CeEwosKXSE9@agluck-desk3>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <ahjR2CeEwosKXSE9@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P221CA0026.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::31) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|DSVPR11MB9555:EE_
X-MS-Office365-Filtering-Correlation-Id: 25887620-7521-41ee-3e4b-08debd34a952
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016|11063799006|4143699003|3023799007|22082099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info: NhetZQWQJphIKnPKucSphFhUlV5h5+Tbk3cQ/s2Hd4y5DsnoQTo+kOeY1sO1DrjP78gVN7DM1LoPxalk2VFaAH1Fn1o8rOvXn5ZvphhZ1FOJj/W/gttzu9QjN2QdO0z2TfGMQiNkSaMKbaSbKawrbsKmFXI412EqWgkTufvUZK848Tm85Sc+P9yT5txSW0rCcTBEeySpSgOcGNICcq3dCb0rcti7IxFIQC+iy+MycncmgjjPHPZM9tPObqcurEDvGOO6JfLRzQUW4KHLPCmH3xlcAGQUhR6RjEJOUcOFEQO4piwwgX3Sf3psLEerWR/vfQGsMuWdj262bJ8JjmCfPuAJmKRAoab8Ubnbqi5pd1TWpfg+b+4dj+pzIEiri/WEmdSzJzLyTCKkF46V/T26S+11EpwIPeqrFsqsWMLt3JNkrA3XukQ0LJ8nMh1BYQ3LPxd3APW/CImKgASP7jt5/LvDy7nFiSGnKGNW7beUaNdMfhVNz5P64MFPPrik1Fj+KjZjbwvrguKLt0c8DexqJ0NnZttAH2ev18MvdtIJ1qXrdWwbbtr+GwY7gPJMDsjEGKMBY8g3mLx0l84wGaR85m6jPbmtkIKw6Ydu0+pHLkj3M/ZGvvAa77AJuhaYygr2Pg0ELkv5vYNwRDo7Isk7YjroWv6FHnFNAVq7mCE7GeRn0GCH2fYzr1kQKJvt3ABr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(11063799006)(4143699003)(3023799007)(22082099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MkdrbzhtbTc2eExSMGdROGJuWUxBS3NZZEllWnZpOXRZcWdCT2dEWE5vQm9v?=
 =?utf-8?B?SVQrUi9TT1NXd0NSTDIrM0xQTzA4OUtXNUdHcDdQUVo4Z0NTak5DYzdxTTNz?=
 =?utf-8?B?TW9KSXd0bWUyOFVUa2kzWTRkRy92cGdKNTJEUWhjOXVKWU4xTkRMcUJYVWNs?=
 =?utf-8?B?RnlUMjZYZ0dOVXgySmhUL3A5V1kxd1YrOTBzMEprdlY2QjQxbEdocW5ZRGF4?=
 =?utf-8?B?amR3clB0WlJOWjBQZUEweDNxNkZwZDVoTWl2WWZ2cmsvc3dBQ2RiYURoNjJp?=
 =?utf-8?B?Mm5TS2wzdm96MjF6aG9WRWZyM2ZTNmMrM1Zjc1c0RDhqRjZIQXhvWUwwK0dE?=
 =?utf-8?B?U2hFRW1UazBJaDB1a1Z0ZGp3VFlZcGlwSEE3a2FDVUxMSzZEdzJJbXRFcnAz?=
 =?utf-8?B?K0ZpTnhCOS9CaXl4akJyTDJDMHNwTDlQQnVibFlLbHBBbzl1NzVFQi9RZlBh?=
 =?utf-8?B?alljZDVPKzdneWMzVHlqbG1OTEZRWkltSG1jUDRIcEI0Vi81VGh3OC84TVlZ?=
 =?utf-8?B?OVFlMnk4c3Y3dDB6czRWT0lENEhoV2s5TGFvc1ZVYjQxdDVuN2Z4bDVwRFBR?=
 =?utf-8?B?bmd4TjJMYUNlZHA2OHZsN0pScVhUV0IzZnJEa3hqR2JWYmo3dVBrL0lMQjgy?=
 =?utf-8?B?eFp5bE13SHc4eWZONnVDMjZKVVdTZVFZbG1SYWdwZWo1SXZiK2l6TGVoZHNo?=
 =?utf-8?B?OForczhacGJQYml1bGVIczQxejM0NHkycUo4alB4YjBVQ0tBanF4REs5SWRm?=
 =?utf-8?B?eHQweW9SNGFiY0Z6TU5WOWgvUnh2a2pxUTNWNGpzYm9LaTFweS9sUDB6anNu?=
 =?utf-8?B?MFcyUXhEbHYzQXNJT2FmeEhtUlA1ZiswZUplYTBBNGV4RFY1VkxrcUhKaEdz?=
 =?utf-8?B?bHJWRmMxQXVhanRwVkNCWFBCbU9RUzFIK0doNkxXb3BoZjR2SWxQL3MzZ3Qw?=
 =?utf-8?B?R2lGSlZDcm40Wlc4Vk5EOEQ0M2s5ZXlSaXk4cFZpaFlaUDFHM1FyUldpZ1Rt?=
 =?utf-8?B?TGludk1JWFp3NjZ1ZUhWSzV1UTNqeDUzV1E3d21lcklJSXNpNWo2b0w2eG50?=
 =?utf-8?B?YUxrajhCTnh4dytJV0R5MWUxYTBmR0J1TXdkeGEwL0swWmkxSGVZZ3Q2OEo2?=
 =?utf-8?B?SWxObWxNdFA3TVB0RGU2Q2x4NHIxMEJwKzc4NGJzcytiV1JNa05lcTRGb0Mw?=
 =?utf-8?B?WDJkNVlXaFVGc1BEK2JiMzFmMmM0UGo0U2dYK21VeFNWTndVd2FsVUdKMmFz?=
 =?utf-8?B?bmdHVVh1ZVcvV1hQN2dOalFqVkVjODl0b0FMVVY2REJTN2hYRXJYOWsyQUJk?=
 =?utf-8?B?Z3hYWWVHTHM4OWhYcndWYmUvU0UxSmxtbzF6SnB0WUhyNmd0Y0JRUWhESjZ4?=
 =?utf-8?B?Y1hwOEZ3SmMxV2t2OVlYWFY0TVFiT3dSdkVXcTg0RU11YXRoYndWNUtoY2VG?=
 =?utf-8?B?d1dHTXpac1NKRWFWRFQzVVZnS3dLQTJrRU9kaXlDZzEyT2p6MUI0Z0VJRWdp?=
 =?utf-8?B?NDRDbDJtSXd2a290VU5sblRUUDRTWGRETTBtZEFXQ0JTRVNoQUtlWXpydXFn?=
 =?utf-8?B?WG1hOVFOT2VBU2RMdGVpVDF5bnp6eDh0ODEyK09lL0lYdFNSdk5kVnRTYS9w?=
 =?utf-8?B?R0R5VHU1bFo2aGRKMm44YmF1MTdhb2V6RVhhR2orYzNrc2ZYTnFWTGJOdXpt?=
 =?utf-8?B?OCtNOFpTOC92OFQrTEhoQ25VMktwSWwrMXB3RG9YL2I0bFRVQXdWZ1ZFZHF5?=
 =?utf-8?B?aGRDeUwzZ0NDU3pSS09WNTlIYTgyK094a2FUSFdtNDRnVyswbEZmQlp3N3pF?=
 =?utf-8?B?dWh6Z0hYbGpmZzhhZ2VRNjRiR1pwTjArZ1M0RThCd3B0V214TEFqZUtFckg5?=
 =?utf-8?B?eGI4TmRGOEl0ckRMMGdMNkNHQ0dtVHc4dlJFaFpHN0ZTWmFuSlNrRjc1Tm5z?=
 =?utf-8?B?TnhLZ3lINWdIWVE4R0x4eEtwRk9RY0o0VW1WeS9FbUZUNVZmRTljYmU0VEJa?=
 =?utf-8?B?QWRGNnRsWG1oUWUyaDVkdUgwQi9lNzZPZ1liWHFnR2ZiVW5PU250Vnk5bWoy?=
 =?utf-8?B?T1JONTJZWDlzdXg4RlYyTzYyem9QbExyU3U5QnNKRmhiTEVPbjFQNkJwaHpD?=
 =?utf-8?B?eHFGRlNOWGFmNlhVQzkvOGFDUmRzR1Fxc2VrQUJDci9HRGFJVm9PTWJ0Nk4z?=
 =?utf-8?B?Z3ppa2s0NzdXT2NoS0dVV01BL2dxWU03QUZQK3NST2NiamdFZGRJUVVyYmhU?=
 =?utf-8?B?WmRSWlJoaHY3Tkl5S1JZTEE1STE1YTB4SktZWkFVdW5BcTM2aldzNmdsd1pm?=
 =?utf-8?B?NDYrQTZJOGFEMm4wZjZ4N2FvclZmc0luZUw5bEM2Y0dVWTZvN2c0cXQvYlhG?=
 =?utf-8?Q?bWfvdE7xjdwwdNdY=3D?=
X-Exchange-RoutingPolicyChecked: TwgAQIMmjRoRKJqQ0wv9Irv7BbjW8DgRUYYMmLkkEXFtfo6dYP357iaDsO5bDNiWUtqn1fo12XxLuOQ+B9flnJpmuXPFkgZrkMGjou/zvJ4W7c+YfDaoLlvvv9nutjT88FmlW1j9vKFaS/xUUSDwaghiQr/t/zqq8wt7bbSkWxb23LkAt8U23tT2Ti9tqs9BFeH8EmJLBQb6HNPAytmYowpeMbLOrkfZc46sndy5//tUVMEuRtZw+3q95p+99LjA6leTPJT8X0yA1v08fmryIaNb2W5Z3E5jIW0rB31PpALYMrMwmbC4YASu4WD6vJ5TFhqgvrdlC4N5WPZ/70DsNA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 25887620-7521-41ee-3e4b-08debd34a952
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2026 03:45:01.2719
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MtR0B3wNc1t1FxvDODkoWiXlVr/vC8BwRH8iZ//Vy9Vx322GvieZnsWBMThQXQBG7YRik+FBAWjKSuFiIO2uExUQphy2KsLzV/9AvzwiLy0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSVPR11MB9555
X-OriginatorOrg: intel.com

Hi Tony,

On 5/28/26 4:38 PM, Luck, Tony wrote:
> On Wed, Apr 29, 2026 at 08:06:38AM -0700, Reinette Chatre wrote:

>> @@ -324,6 +319,15 @@ ssize_t rdtgroup_schemata_write(struct kernfs_open_file *of,
>>  	}
>>  	rdt_last_cmd_clear();
>>  
>> +	/* Valid input requires a trailing newline */
>> +	if (nbytes == 0 || buf[nbytes - 1] != '\n') {
>> +		rdt_last_cmd_puts("Invalid input\n");
> 
> This is obviously a big improvement over existing failure to provide a
> message (or leaving previous stale message). Do you want to go the extra
> mile and disambiguate all these "Invalid input" messages?  E.g. here:
> 
> 		rdt_last_cmd_puts("schemata: Invalid input\n");
> 
> It's good to have a grep-able pattern to diagnostics.

Good point. Will do.

> 
> All the other patches in this series look great. You can add my
> 
> Reviewed-by: Tony Luck <tony.luck@intel.com>

Thank you very much for taking a look.

Reinette

