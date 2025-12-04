Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA29E23A9BE
	for <patches@lists.linux.dev>; Thu,  4 Dec 2025 13:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764856472; cv=fail; b=anwg+PyniVZ5SvLjbjPFHrIKV2Q72EBGmYrXDgUS9fcgA5BndkS/FwgBEmfIJ+K3p7U4/DumcPTIdj2q+0xLUvPR7zvQwoqXLs0BozFDBWqIYYScQQZNbG4XWAQ5dI5OfpfGV5s2ItUg89B/1UFMHRPH7jNp4USLRCt02vS5DQ8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764856472; c=relaxed/simple;
	bh=UmgezQJIgQgo5Hb2N6pcsheqcxQMoCQ7Ni5etrUp5mo=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=TK3jF8ZmRinOPiypGrZWIiTNFrv2OsjZupf3vfuN0z+D5PSI8mDu4+SjQDCZzYOM/HhuCuigVWDF4K+yT19vQnp7rN6a1Mjf6WYignFhN6EDHmvQRXefp0nRjZJPnWD9DDUSwTOSWnmE2Jz5mGapq69eiVEirJpcez2lFkzJfL4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SzsLTg7L; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SzsLTg7L"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764856471; x=1796392471;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=UmgezQJIgQgo5Hb2N6pcsheqcxQMoCQ7Ni5etrUp5mo=;
  b=SzsLTg7LU7oqvngxqYHUq6JZz2HL182JOEbzezjlRGrHsyE0IhUHqJDP
   jBFm1szXbJ9247ahLf8j9g8X3y5d0I19lkv049Rz2rTHHnI27gP2vr1Dp
   LoTxA0PgHWvG56SU01Z46x5LKoRAYmmuGRz0W3HVtoydXgDVCg3rMsYi/
   3yidSvi/6SlKcSwSPp4u+e+/C0UF3jUj5E9NNMQ7vZQDomX2hwc4uQmLU
   gKiuZZdFBxUipU7dxxPRmbsE3zJIKlCvRckZlbMCTXJ5FzM2gPm3Q/hJX
   ah7OBMli89RHLhiAhCdO5Otf1BsLIRybLzeYCGAKxBLp5Mq1enuj3xjVI
   Q==;
X-CSE-ConnectionGUID: WHdsSUw/TyGXL/cISkq/kg==
X-CSE-MsgGUID: 1iKUejhxRRu49guEyKLs0Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11632"; a="84271956"
X-IronPort-AV: E=Sophos;i="6.20,249,1758610800"; 
   d="scan'208";a="84271956"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2025 05:54:30 -0800
X-CSE-ConnectionGUID: oHCteBFSQsmnTrZbO1ubaQ==
X-CSE-MsgGUID: 207ROOHUQLia0ZxzkWmBXw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,249,1758610800"; 
   d="scan'208";a="195413734"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2025 05:54:29 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 4 Dec 2025 05:54:28 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Thu, 4 Dec 2025 05:54:28 -0800
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.0) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 4 Dec 2025 05:54:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Jl4xwwymeMI3PCYE3EltvHF8iuXi4G0qjn9e3U7xk+K12nJGd1n9j/7ZEM6qsXNNgna4mgQMVJ7N0XomPruSnUxye/K9fejirp6yIPjSpap+3gixVAZ1sE7hQlgbTKPLvpGpzSpxpb05vfEP2qPNwLGxmSo6mPSMwdSoJi00WG+2p7GL3unhSa/KcnxpvpLSqDrfZ2jEsfo7+OszJT1y6wJuCF0F86PY+zbPa9LXIguM/jLYDAwtBxSWDPwMC7zB0WyXboXjWpUEYA60YQXrqGWjyY72ff5gA9eJ3sxx3326owtAd6cAFLQZuYXQODuv7z3TXJ5l9nBwORp8ufP+Vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CTG81KY34t/CPlmSbFqsgHx3UM/75Tl9GqyJztqCgk4=;
 b=O+YI5DWMjDGXpv9ZiXVpnssd1p3V9AnwFVM1PG9mTWyAl/HJD9toFXoMoEEn72q2rRd4fAUoH96/GjKs03shtgtVtMIka0T1K6SiouHDmHuYbboj7eW0WIVdHU/PRs06vz1+HwUaOsEHrOdOIZaGLhac/Bw1Qed2pc6xmX5Ui6I/n6iNnxCU7Ds3zmesaQyC7YNZv9tYusmgHYg39+u5qus4jyuBK+h8j1sfd8B5wxf9CMapOEx7EWhLeuDY9J0DZkBZfTJ8cgt0gKR1kJM6+pI2k/8JHbCQZ9NwKL1hnxqLIDpxRhObiM/53DVcrQrlTIBY3PpYmiJkNvqFXft01g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA1PR11MB7198.namprd11.prod.outlook.com (2603:10b6:208:419::15)
 by SJ2PR11MB8452.namprd11.prod.outlook.com (2603:10b6:a03:574::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.11; Thu, 4 Dec
 2025 13:54:23 +0000
Received: from IA1PR11MB7198.namprd11.prod.outlook.com
 ([fe80::2c4e:e92a:4fa:a456]) by IA1PR11MB7198.namprd11.prod.outlook.com
 ([fe80::2c4e:e92a:4fa:a456%4]) with mapi id 15.20.9366.012; Thu, 4 Dec 2025
 13:54:23 +0000
Message-ID: <6f16db6d-0c42-4115-bede-ab398c819742@intel.com>
Date: Thu, 4 Dec 2025 15:54:15 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/568] 6.1.159-rc1 review
To: Naresh Kamboju <naresh.kamboju@linaro.org>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, "Rafael J. Wysocki"
	<rafael.j.wysocki@intel.com>, <kai.heng.feng@canonical.com>
CC: <stable@vger.kernel.org>, <patches@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
	<akpm@linux-foundation.org>, <linux@roeck-us.net>, <shuah@kernel.org>,
	<patches@kernelci.org>, <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
	<jonathanh@nvidia.com>, <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>,
	<rwarsow@gmx.de>, <conor@kernel.org>, <hargar@microsoft.com>,
	<broonie@kernel.org>, <achill@achill.org>, <sr@sladewatkins.com>, "Svyatoslav
 Ryhel" <clamor95@gmail.com>, Mikko Perttunen <mperttunen@nvidia.com>,
	"Thierry Reding" <treding@nvidia.com>, Arnd Bergmann <arnd@arndb.de>, Dan
 Carpenter <dan.carpenter@linaro.org>, Anders Roxell
	<anders.roxell@linaro.org>, "Ben Copeland" <benjamin.copeland@linaro.org>,
	<sparclinux@vger.kernel.org>
References: <20251203152440.645416925@linuxfoundation.org>
 <CA+G9fYuoT9s1cx3tOoczbCJDf2rtrmT1xSg-wut5ii6LG6ieMg@mail.gmail.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: c/o Alberga Business Park,
 6 krs, Bertel Jungin Aukio 5, 02600 Espoo, Business Identity Code: 0357606 -
 4, Domiciled in Helsinki
In-Reply-To: <CA+G9fYuoT9s1cx3tOoczbCJDf2rtrmT1xSg-wut5ii6LG6ieMg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DU7PR01CA0027.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:50e::14) To IA1PR11MB7198.namprd11.prod.outlook.com
 (2603:10b6:208:419::15)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR11MB7198:EE_|SJ2PR11MB8452:EE_
X-MS-Office365-Filtering-Correlation-Id: d9fe6092-5cb6-4929-674c-08de333ca146
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?VGFEUzJUMTBxRkpsRDJEUDVJcXEvdjdLcXRGdTBOS0o0VlRQSFI1c2JNcThC?=
 =?utf-8?B?ZHBHTHM5MlVYVGU5OXNnOFNtQ0VBYW0zTjcvWFFVVEdzYTJMSGc1SWJ6Z2JF?=
 =?utf-8?B?Z1NwRkhqZGNxa0E4WnV5djhnNUg2TGdtSElsakNDcERtQ01xQndnYk5uS21n?=
 =?utf-8?B?OVAvV1ZxQmgxbXQ1WTVoUUpFTy9oRGhiTFFNclZPNHNiN0xkTGVwOG5jRXM5?=
 =?utf-8?B?cEI4OUhubm1yS1plbjBpek8wYzczTGdpaUUrNmVYU1BRZkZDYkJvaWhVNjNt?=
 =?utf-8?B?aHB4ZFAxMVhLM2VaSTl5enlIa0JFckdzSmpvbzkrb1UycjczMm5GODIrOXlt?=
 =?utf-8?B?MzBIRFN0enFyOFp4Z24ra043anlVUkZGaU5PMGJpcG11ZTZXMEhJcEN5VkxY?=
 =?utf-8?B?eklPWFFRZzNldi9tZk02RU1ybFhHOEdoRHVwdXVWM1Y3V00zdk1OUDFRT1J6?=
 =?utf-8?B?RTdreXVvRWN6MTNSS2xKakVpYTNUaThWTUlac2JUeGNDaFZGTnZHRjA0Sk1N?=
 =?utf-8?B?T09KUDlGa2EwSWJCLzNTajlkb0tFTld6Y3lxRWJjTGR4T3NsWTBiaUdJY1Y1?=
 =?utf-8?B?NzBqaEZpWE9EUlN5emVEbFlPOFpybHlNTHQxRkRRdVZvaVdOQmRubHNacTdR?=
 =?utf-8?B?eEs1M2lEUTVBM1dUMldLYmVhL1c5UkhXWGJYd29JR0lwTmxlOTFFMTNiVkd2?=
 =?utf-8?B?Si83VmVaQkVTUWRZQTNON3pEMVJXZVhvem5PM1dXdjVNWkdpQnNOZ1dlY0VS?=
 =?utf-8?B?RzRWUkkvYzhMQzlWV2NWWFlHQldzdmlGS3BYZ2c1WWRTN3dDbzYvNkd3NUda?=
 =?utf-8?B?TXdwLzA1d2pGbnlOQjdBekk5SUU0eEg5enVRaEp1SjZ5YWQzYXpBWlNCK2t2?=
 =?utf-8?B?SS9SWmZXMlM4WTNoSWZJczl5QTNGdHdaa3NMOW9UcjVDdnlvWjU5Mi9BYmlG?=
 =?utf-8?B?cGRycmsyeUdzRU8xT2RxQ3loR0FHNlFvQ2Y5TjJ5MVVDTi9YZk9wbXlRSTd3?=
 =?utf-8?B?VEk5bW9MbElkRFNrZ3RxR1JCZURqUVhScWROb1ByeU5DMWx5WmxzL01Gang2?=
 =?utf-8?B?ZHE4ejdtWmtobkFLOXZ4ZThzS0Q3ZGxNdnluWHNRRGNkYTNxeWxxMXVVWmFR?=
 =?utf-8?B?S3NLOEJjTXlaZ015U3ZydWtZckdTNGJOOU1ZQ0tEbVJjSmJsNnJRTkJvenVn?=
 =?utf-8?B?cHJPWWFHUEFTTytPSmhpM3Z3aHZhWGl6RXZIdW8xUzkrd1hxYXBFU3RBSUVi?=
 =?utf-8?B?Tm41S2gvd0ZYWnYxZ1J3bldsSGtYYi9iZ3l6YUxnYXZEaWRUKzJHNGM5dHpR?=
 =?utf-8?B?L3Zxd0Fjem05K0tyZFlHem5KTWxRejJINThiUmJMc3Jnd1RGZGlpYnVycU1B?=
 =?utf-8?B?NWN0aVhJVjlHVjZQZmRuOVcrd2c4dWpnVXdUQ1hGZDdldVlhTjZxQlBSeHN4?=
 =?utf-8?B?OUlyL3hDR0k5RVovQ1NTTkQ0RzRWLzZ4d3ZLSG95Vldvbm9obmlCdDNxTEd0?=
 =?utf-8?B?dXJhMlJJOW11RzRnL0FSVUZ0ZHRSNlNRNXhCT1I3Y0h1elB1SjhkZEZCLzYy?=
 =?utf-8?B?OEdEL0pVU2oxY3JuQnFhWW9teERQaS9kVVZtTkhJdXVJOWJ6Q3BxZnFjOUxj?=
 =?utf-8?B?c3oxTHdERjFjK21XNk85dFhqcGtrWksxUkNDd3p5NnpTRFBheFBUTWpxK3BP?=
 =?utf-8?B?Y1NIWFFDUk5lbTJkWHNhRGNVZGZJZVAxMU5FSE44eFk3Um93TmpCZEMzRDAy?=
 =?utf-8?B?UzE2dWRVaFliaFM0L3N2blhsVmM3L2pBb3hMUEtXaTVNWXZJK3JmK090SjFW?=
 =?utf-8?B?a1dNVitZekVMWDlTekdRSlJSVVN2VHN2blBkUXEvM3FsYjRqd1FIWFRmTjlI?=
 =?utf-8?B?V1YxVUYxMkJveHRYUHZFQW82VEVzTGx0SmlPbi9naXh0VWlFeDZxdmhLS3lE?=
 =?utf-8?Q?1XPjbAEFL/Y6/ChSoOSzewJ5VsbAxKY8?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB7198.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c1ZRRkJjY3BGWGZETm94Y3VlUldZT3JRUjVOaFFHaE9RMVpVeXY0TjBLb1ZL?=
 =?utf-8?B?Z2lZK01tdTBDeklybDU4V2t3TkluT0hyL0tiVmVwOXNyUUQ5cE5ta2l1WklP?=
 =?utf-8?B?Zy9GT29ia1hXc2sxLzROdnlja0xpQmd2Q2phNnNra1VMY0dyY3hqc2dWQTdK?=
 =?utf-8?B?VDBKeTBLOXhhb0dTdjhYSGZsMGtPWnlPRXNOcksvd2hjMVNyWG5FTkphbHpx?=
 =?utf-8?B?Sjg5d3NvUXpPODZ6TnBzK0NUVCtZdGdmcFNCaUdoSUJqcTFYNVZQTGJRS1pt?=
 =?utf-8?B?alRxazB3eER2N1lwbWdpWk80ZmxmWTZxcXhzNEh1MUFFR1NNenFoQkVaN3dC?=
 =?utf-8?B?bEh5blk2NGYxSVNuYnQ4M0tBOThPUWZ1RFpHUGV2VGY2TWkwcHE4K2E1RWNu?=
 =?utf-8?B?S3R1OUlQOUlENWxGampxdWpQS0R6MnZ2WXhuYllENGJycmZBVjFmRDF1NTR4?=
 =?utf-8?B?RGlJTVk1bzlxbHo1WCtsT1lOMkdxZ1l1c3FMYnRZdlpocGRZK1BaSTluSExo?=
 =?utf-8?B?bUtnREx5UmZUdWZLSlBsMldhQUtnK09Qd0tpc3FkUWNHSDlmN01BSjhCZmth?=
 =?utf-8?B?V1h6UVFLdXlLSWhLVG1SV2F5UmRabnVHWE9UYVM1U2lEUTBuY0QycXVsZ1N1?=
 =?utf-8?B?YlA5NkVrYjI5a2tVdldJaHBXQWlXTjRhVTQ4R1RkOFRyQVJ0NUtQdUFDVUZu?=
 =?utf-8?B?cmxMQjRCZ2NudDdjS3M1Y1NaSjBMdStzOUxDVldWYnhEcHAwZ0xKUTMrcmU4?=
 =?utf-8?B?UGJyZ2FaUmlZL2FTQVFldlhQK2lVdXp1WDV4M21ZOWdXcmkvdGJaczRsQ3J4?=
 =?utf-8?B?U0RPZHFYQTBxeTFGdlVXZTZTcWhPTmRUcjUwM3JtdHpEVm5XdUwrOHVuWmVl?=
 =?utf-8?B?aWcvNXp1bi82eEZDQXlYZ0taL3hXOU10dGxKVGFNTDFPaFVXRmxTZStiTjJy?=
 =?utf-8?B?bGdqMm5zdW9MMm5meG02bDhHV1V0Q1JzZWQrbk1XY1EzQ01UQm02K0RzdjdB?=
 =?utf-8?B?S1RaQzJiNnFlNmhMcWRsU2d1azNjNUJVK0thcGhKMUJ5VVVnL2xpQ0Uwb2p3?=
 =?utf-8?B?ZGpuOGdnK0RhR3FKQll6WVNRNGp5c1N0d0ovQVFqY2p5V0RTVjZKRWplWW10?=
 =?utf-8?B?cW50WDdzUGdiVEpDTTMrWWc5SDNuZ3d5Z0xJbkhHR2VwanFOTE9JZmNQN3dW?=
 =?utf-8?B?L2VoWnRtV1NIUlJ4Z0JaSC9XWmpxdzFKQ2t0bVBxR3dQRmt1NjFnVXVmeXYy?=
 =?utf-8?B?bG5ZR1M3YWxCYTVnSTZlYXU3YytTbEZBdlE4QitwMUpldTV6UTBubzluU3Zu?=
 =?utf-8?B?SzRtVkYvR2xza3lkMGgyeW56dTRVUnlJTFdIc2I4YWZGbzhDd3I3dEh2L2Jm?=
 =?utf-8?B?dFp1U1hxNHJTNlcxV05qZXUxb3lBcnFvQ3h5MTRTVVVyVVBmU0NPZHU5ZW4v?=
 =?utf-8?B?SUM5Z1FCZDQvc1B6aVk3RmFXN29qNDRvWWxUaFJncnhsNnRuTnNtSm5yemY5?=
 =?utf-8?B?S3BBR0Zib01DYUIrNVhwSit2MzVVZlN3T3BpeStJSVRPVmxpYllaMWpQNlh1?=
 =?utf-8?B?MWFDL0h6ZWUxdVdqK3JKR2hreDAwbGxUZThsYXo1OStSaStRckNXWm1QemxK?=
 =?utf-8?B?ZGhOTFpBaGVwTHErMWhTSzFzdlR0VHBpSkc0bUY0TXd5cTVvOGlMZlJQTGhH?=
 =?utf-8?B?Wk4rRG9iRHcxU3lPU2ZQZDV2WVRmWWtqR0pUVDBhK0pSMzhoZDZqT2VSdk5w?=
 =?utf-8?B?TEN2VDdlRVl1M2N5eTc3YkMveGZiQUI0cWxORG1KUnFScFVnalRkNS8yRFZv?=
 =?utf-8?B?TDB5eG9rdG8wNHJnWmplNWFDSWUwUHBmdmVQSVBFWmtCSGN5UVRjUTJTTUJp?=
 =?utf-8?B?b0hmblVFR3FHZTNTSEFaYnh1a3pDUVpQQytodGpvclBScU9HK1dZcG1WWTJQ?=
 =?utf-8?B?VXFCVk0zY1ZmZGU0Rko0SVVNblZ0aUpNbm1vNFNmZmpvcFJ0VkIvMHQ4a3la?=
 =?utf-8?B?Z0xabHpSMFd5aHVGMkh6VFhLTEJMNXZyd0NUQVZuUzV2NmtBcDNxaTBzU3BD?=
 =?utf-8?B?dEZ5T05XZzA3dkdGdnFPbm9uRDdGN0F6UlRqc25rOHdjUnArR2pSb0ZQVWV0?=
 =?utf-8?B?c0xEcHV5M3oya04wMGxCQmZ6YnF1UnVveS9zTVR6NVh4NHBkbm5nYzFxaEJ4?=
 =?utf-8?B?M0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d9fe6092-5cb6-4929-674c-08de333ca146
X-MS-Exchange-CrossTenant-AuthSource: IA1PR11MB7198.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2025 13:54:23.3087
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Uwy2ttY2Dhr8FVHryl1WCUD1CO12VE0OQKtnhKxJ6YUrQGeQBkmC0Pn+NpM1ka6AMXCEGqzE2E/XTb/zUfZfrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8452
X-OriginatorOrg: intel.com

On 04/12/2025 12:43, Naresh Kamboju wrote:
> On Wed, 3 Dec 2025 at 21:48, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>>
>> This is the start of the stable review cycle for the 6.1.159 release.
>> There are 568 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.

> Build regressions: sparc, allmodconfig, ERROR: modpost:
> "pm_suspend_target_state" [drivers/ufs/host/ufshcd-pci.ko] undefined!
> 
> ### sparc build error
> ERROR: modpost: "pm_suspend_target_state"
> [drivers/ufs/host/ufshcd-pci.ko] undefined!
> 
> ### commit pointing to sparc build errors
>   scsi: ufs: ufs-pci: Fix S0ix/S3 for Intel controllers
>   commit bb44826c3bdbf1fa3957008a04908f45e5666463 upstream.

For that issue, cherry-picking the following provides the
needed definition:

commit 2e41e3ca4729455e002bcb585f0d3749ee66d572
Author: Kai-Heng Feng <kai.heng.feng@canonical.com>
Date:   Tue May 2 17:04:34 2023 +0200

    PM: suspend: Fix pm_suspend_target_state handling for !CONFIG_PM
    
    Move the pm_suspend_target_state definition for CONFIG_SUSPEND
    unset from the wakeup code into the headers so as to allow it
    to still be used elsewhere when CONFIG_SUSPEND is not set.
    
    Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
    [ rjw: Changelog and subject edits ]
    Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

diff --git a/drivers/base/power/wakeup.c b/drivers/base/power/wakeup.c
index 7cc0c0cf8eaa..a917219feea6 100644
--- a/drivers/base/power/wakeup.c
+++ b/drivers/base/power/wakeup.c
@@ -19,11 +19,6 @@
 
 #include "power.h"
 
-#ifndef CONFIG_SUSPEND
-suspend_state_t pm_suspend_target_state;
-#define pm_suspend_target_state	(PM_SUSPEND_ON)
-#endif
-
 #define list_for_each_entry_rcu_locked(pos, head, member) \
 	list_for_each_entry_rcu(pos, head, member, \
 		srcu_read_lock_held(&wakeup_srcu))
diff --git a/include/linux/suspend.h b/include/linux/suspend.h
index d0d4598a7b3f..474ecfbbaa62 100644
--- a/include/linux/suspend.h
+++ b/include/linux/suspend.h
@@ -202,6 +202,7 @@ struct platform_s2idle_ops {
 };
 
 #ifdef CONFIG_SUSPEND
+extern suspend_state_t pm_suspend_target_state;
 extern suspend_state_t mem_sleep_current;
 extern suspend_state_t mem_sleep_default;
 
@@ -337,6 +338,8 @@ extern bool sync_on_suspend_enabled;
 #else /* !CONFIG_SUSPEND */
 #define suspend_valid_only_mem	NULL
 
+#define pm_suspend_target_state	(PM_SUSPEND_ON)
+
 static inline void pm_suspend_clear_flags(void) {}
 static inline void pm_set_suspend_via_firmware(void) {}
 static inline void pm_set_resume_via_firmware(void) {}
@@ -503,7 +506,6 @@ extern void pm_report_max_hw_sleep(u64 t);
 
 /* drivers/base/power/wakeup.c */
 extern bool events_check_enabled;
-extern suspend_state_t pm_suspend_target_state;
 
 extern bool pm_wakeup_pending(void);
 extern void pm_system_wakeup(void);

