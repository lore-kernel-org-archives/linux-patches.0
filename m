Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B90CD2ED164
	for <patches@lists.linux.dev>; Wed,  3 Dec 2025 23:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764804331; cv=fail; b=gsctnfbyzT3foJn3ebEBGMJcxS6WRmO/RyDPd5Gt13mLQgcM9voRDS1Jw+4BoSZ9sdVV7S+Ghomw6dxahlp12VqGLCfxayeMN9xwzAUfsq/1gR6FIhpp1M6PR861F52eTQXPwkaaPOnzZOlIQIO1s93hzzUXcJr/l8oOMqb1LHg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764804331; c=relaxed/simple;
	bh=iOpR/raecLLlZIWNwtwmsOX5Yhpi2fLmvtAl5LYTdNs=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RkfSpMoABM2TTu1jhnQcCaLp+2CWrZkc/Ba0gjwAZt4trhtlcSJ8qujd0NHGSjdg/gNnQWe6k1I0jsSvQoO6WyZnYDSBjlSd0lv+nhh1EbnY+Z9gp//N6QXea3dttJ1Ep4P4ZQEczXc1L4ihdVC7CUXBtei5Eq9yqxEMJ3rWpVo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BrJDA8oL; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BrJDA8oL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764804330; x=1796340330;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=iOpR/raecLLlZIWNwtwmsOX5Yhpi2fLmvtAl5LYTdNs=;
  b=BrJDA8oLh6K7wa1FFHpZXtkJdO5L9ptaX+P9obfyBfNzWOx5zIVol4FW
   trT+77eNxZn08E1AaAo9LMnPPRRTLRn0fpe5tFOqA6kNmAklQKl3WdV13
   Ph0pi0znzSsKd0p1qMeFmaXrKcOfnyTLJuvsZ/dmmZwkdSS51eyb6YMXz
   UiyUcEJuUFKr56B4cViGpQ6I3foeVv5jNku9nTwWxjdAMd4NMnxPcIUkC
   t/vOKxL8BycUbAloicqtGjVFpQbtwppTQqJNy3N9sVZV1i4eYFYlsees9
   kpkczr5DfnmY9NAs9UtCi7KYs/S09TJVX3yaPm5fdiB9eLKQPzWKc8+az
   g==;
X-CSE-ConnectionGUID: 24QnjsVNSsWB7PK4EvKXAw==
X-CSE-MsgGUID: CUzzAxOmSzWjc50kxk52iA==
X-IronPort-AV: E=McAfee;i="6800,10657,11631"; a="84213601"
X-IronPort-AV: E=Sophos;i="6.20,247,1758610800"; 
   d="scan'208";a="84213601"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2025 15:25:29 -0800
X-CSE-ConnectionGUID: 9EdLC5CbSY2vIpQhJ6iv5g==
X-CSE-MsgGUID: +1bhUa8BS2SrQBWw1xSytA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,247,1758610800"; 
   d="scan'208";a="194642060"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2025 15:25:29 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 3 Dec 2025 15:25:28 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Wed, 3 Dec 2025 15:25:28 -0800
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.57) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 3 Dec 2025 15:25:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uAblQl4YewGu6slJheecMcrL9VWiSPO4YfMtynkjgu4t5v/ggm9/Cqrgq4Ntpw7/9zTvzqIdsXn2GLAGMRq3bBHkl1QCRL9RWfPCvVdyN42BlHlDbHXq+olGTV86kmirB2pxD9nvLzGZk99pplsgTkQ7PgG1jp6+/fjvOyO3kfvcKkgc5V2kS2qhGEIge+RJuCTBASfNBj/1yUWJuKM6QOmYJiz0b+yKc4LDI+ZxyGjUbFXk4towrboUmLDWVkccsKTSf6H+whxmQooMeLKDXYHeMzOvN0dtJEzQIFslvLa/KU9InyROkk4dEZ/msBhGpX52H6EKFAWej0oUKDxGSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bA//rqjbs5PgFxga0IFuy5n7FqcsGWxDfaQuQTaR3zM=;
 b=l93NctEdo2+Q54xe4JENDKlIAGRrddS5ZUgbR53yO+yimVRVzfTX3vHdIHEGdDbSLptZNEPgJ5U2Kf+eJ9ffZ7gQaPOK+NrjLplFzUMeEtdjCRP0IBRDw7sAQyQitfiDj9J1lMc1zvrNRhueOJ6t83BSsJdWxpSHLWXNMLKQtQt9Gbd1lcx6w5WX5DmBPJx4tb0GrGrjeSV+mFROeDauyXodiQCtrlVuPIzbydKbhG1VGGVRJZSCP0xQvwPM3yb48GH9mShjDY2zS9tLOyo1GjQnbOXXYJkfAQ0RTm0x+UI2vnU+sBN4d/tTQKWhPECoSK4Yhu1eoRMLznVYbvZ0yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SA3PR11MB8075.namprd11.prod.outlook.com (2603:10b6:806:303::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Wed, 3 Dec
 2025 23:25:21 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9366.012; Wed, 3 Dec 2025
 23:25:21 +0000
Message-ID: <35ce1e4b-53ab-435e-aa61-3ba074a0483d@intel.com>
Date: Wed, 3 Dec 2025 15:25:17 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 24/32] x86/resctrl: Add energy/perf choices to rdt
 boot option
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251124185412.24155-1-tony.luck@intel.com>
 <20251124185412.24155-25-tony.luck@intel.com>
 <ce70e96d-7960-4e00-bf26-8f61424e3171@intel.com>
 <aTB7rsMggy9nRgbR@agluck-desk3>
 <6fb0d504-b8f2-4b16-9d49-b97e41d8a697@intel.com>
 <aTC5ROCmAcQXNnec@agluck-desk3>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <aTC5ROCmAcQXNnec@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW3PR05CA0015.namprd05.prod.outlook.com
 (2603:10b6:303:2b::20) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SA3PR11MB8075:EE_
X-MS-Office365-Filtering-Correlation-Id: 601eaf23-d245-493b-65b2-08de32c33a12
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?VDJ5Nkh6UUdRWDhvaWVkYVVKVnRXYTdVVkVkdFZWKzk5eGFYTWg3bXUvTC9i?=
 =?utf-8?B?U1BkUHl3Q1BDNUV6bVdYeVZVNk92R1ZqU2xnM0dyZlFuZVlsamt3RHdSUDli?=
 =?utf-8?B?R2VTRzN2MzlYa3RSOW1YdnBCZC81M1ZYanNYMHVRRnB4QmF1Q3JTbnZGakNX?=
 =?utf-8?B?Z0lTaG1uS1A0VzhtWE1yZXBRVndGOG5RWW5uYkRSVUtGL09kRnJrRXdRM01D?=
 =?utf-8?B?S2MyM0E1UmlaTGJvMlNaUlBzT0NtR3cvWWJ5Q1phYUNFNWlmeko1SG1sRzlO?=
 =?utf-8?B?RHB0Uk9lYVN6OGZYWlFXOVpxaHNDdVYrRnREdU96MjVlWGhkeUFkRnhSNXpF?=
 =?utf-8?B?NSs3U0F1SFhEaWhhYk5yeldBTnBMM0gwZmZzdTgyaEFiYWdpS1Z5K1RmbkJ1?=
 =?utf-8?B?N3Q4cWM1TSt0K3gvN0RsUW84MThVeFNETUZRYW1YOTFNR1FLSWdneUJuWVlz?=
 =?utf-8?B?WHZIcXk4ayswY3ZSOGcwdzBNeTVNQlVHVnR2VkhrMkRabkZhbkJacUF3Yloz?=
 =?utf-8?B?eUtnVHVBRlNvT0dRdGs0bGZMbkl5c1NVMlBreENidlRrVWZCV2VxUlF1U3Fq?=
 =?utf-8?B?YWdoQnNEdm9TUU5QSEk4eVBaSXkvL3FlNE9oSndqVlVQMGp6b0VUZHAvQ1hs?=
 =?utf-8?B?Y1VXYllxUEFvbS9ybjl4N1kvdmhaQkZIbTVtMVZjWW1oVWx4SkxEN1doNzEr?=
 =?utf-8?B?ZXJnSnhKSHczckxtQTRQRGVwaWF0NStNaS9XWklQdEs3UWlEME56V3VoOGJD?=
 =?utf-8?B?V0FEaVRZejhWRkRLUUNXeFVhcTN6V203WEFXcnVMM3VYK1EzdmNlOEtoZXZ4?=
 =?utf-8?B?ZUNlTHFOWklQdDV0ZE1YSFlOdmIxOCtIU09TTG1YQ2RpSzNwckxRei9scGJn?=
 =?utf-8?B?R2U4QklMOTVrSG8vWVFGdzZpQlk2U05nNjlPT1BOUnZRa2NqWjhrbGwrRDl1?=
 =?utf-8?B?SXpHZjRtRm9sU0NuZ096R2hwWHkrelJsMkhUM1YwT2hOcnFBbXh1ZDJmMVVB?=
 =?utf-8?B?KytiZG5RREVUZmZCK2FXeUlPcWFIVDdQK3lXcm44QVlGVWJCbVdtK3FPRXVj?=
 =?utf-8?B?MDduOEdFR3VzajBic3dJYmtjQ1pseW9TaDdHSmJjTUlESkxzTVM2QU5iMkc5?=
 =?utf-8?B?UGVFN0FmQ1ZyWXczd0xtYk4vbXRkUHNPTDV6bS9lc296N3FwTGdxQVF3SEp3?=
 =?utf-8?B?UUlHT3dqY3NsQWVFOHVNM1ZGUmh1MUI1RVN2ZVRCZHVRSDNCeHBuL0RySFFM?=
 =?utf-8?B?UFFaVTF3ZkV5YzhXSDB6cE1zUzhGVHJvN1JzVUlLSHd0MnAyS3pIQzF2RGxR?=
 =?utf-8?B?WmpsM2k0LzFTMG5UOHA5MzRHbUh4ZXlsM21pZGl0NUdLS2l5bXZTMkw1cjhE?=
 =?utf-8?B?QTZ4OERnTE5aZWdZUDZ1M2luNU0wRGU4V3B2bmZ4ZTlWVkxaZGsvcit5a3M2?=
 =?utf-8?B?WktBUW95RnV1b092MlRqazFhelAzWGlTK2EzQjBGdmRjYW1mSEpXUmIzS2xT?=
 =?utf-8?B?U2R0WmFUZlFpRHo3RVExc1Y2WEtkcUZOMnl4UEdqWkR5TndhdzRERVZrK2dt?=
 =?utf-8?B?dmw5a25Bdlp0Z0dGN0NKelByYVM2alJwUUxUd1Y4QWJDcVFrZi91RGpHeDZs?=
 =?utf-8?B?Y1RMbmI1dVhDV3dKbHJyd0xydHAza0V2VE5wemcyU2MxT2VySGpLcU42NWE5?=
 =?utf-8?B?MG12bFJ1M1hjZEYvQ1VEUHdCQ0F2NGJZdUV5cEpTQVRkT0xNMjlMK01DRncx?=
 =?utf-8?B?R2s1eFo5dGh3aG9YelVwMTRLU0NQWWV4Z3ZQNFFSN0FOazZ6c1h1YjFtSmk3?=
 =?utf-8?B?Qng0NmNKdGl6a21sZWhjc2ltNVpyVXdMOEhiNlFWQlVQVzE5aWNqYjlxaUNi?=
 =?utf-8?B?c1BNWTZ2UkhMZW5STUVNSVpicXBSS1RDNllzMHlyZ3JHWEdNT2tPbHhLSzRT?=
 =?utf-8?Q?HEiWY25w6G405RbvKlDty3oC4eZ0YhiK?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WmdSc21hblRIMGVLajR0aEhsTlQ2ZG9CbUJCQ0VsWXk5eFJyT09yUVFFdTln?=
 =?utf-8?B?ZjZWYmhhcldVam1kQjZJVEV3ODdHTUdXYjhQTnVYWk10cFFzUDc2N0dVSzYx?=
 =?utf-8?B?VUxrdUluczJXaktZTGNmRFpBK3QrVFpmWnBRTnhqR3drNngzcG5QMlpXaGJY?=
 =?utf-8?B?MnQ1bGVleTVmVGtyblB3bW1FcEFkRjZucy9TcjU4aUhDZUlSWThLaUx3a1or?=
 =?utf-8?B?RmVXTzU3SUFiMHBzV1BxMHB0TVpGM01nY2Vqbyt6dTI1WTdJSUFsOGtNRGxp?=
 =?utf-8?B?RVh0aHoyNy9sY2YycEtjd0tyUWhyOFBQbnh6U0FIZHJLeU9pQ0NDYXBBeVpG?=
 =?utf-8?B?ZkFBZkROWFJ6WmJGN094U0hvMzlXc29Td2g4emtIdEtFcDRLTTFCY3FKc2hG?=
 =?utf-8?B?TTE1dVB5Uk5WRTZCQzFIVUhGS0lkOFBpWXU3V0JzRWd6ZmtTYmUwbW9UaWxO?=
 =?utf-8?B?dVBCRnk1YWp5NTRxMDE4VlA2dmY5ZnI5am9iU1FmWXhzMGo2Q0ljMUFHMmNt?=
 =?utf-8?B?R2RlcmdxNEMzSUFYbUFUcEg0YzNHRmxLd0RqNDJtSXNPVjgvWUk3Mk9aSXE2?=
 =?utf-8?B?a1ZWQ24zbmNwWE1ISW50UE81VE8zZGh2R2JOTnpwNndsQUdVMWZKVnc0Mzlh?=
 =?utf-8?B?ODNCbWhDdjF6VzdtNXRQUklmVHVOQnJYbmZtQ3ZWd3lUQU1COHhWenVDbFdJ?=
 =?utf-8?B?OHdQZkNaSHJ2bUhTZTFJWVVTUUc5dDJRS0NXcnBIMjRoL3V1VEpXZVFUOWcx?=
 =?utf-8?B?ZDFzTURSTHFKc0pVR2hvcnpqcVFBb3NTU0ovSDlqblgvdlY1YjlMWG0ycXJZ?=
 =?utf-8?B?dDkzVU4vZWhpcExodDlKUFprU3BwMkQyTWR0ODhTY2ZZWjg3d25ZTHhXYUd4?=
 =?utf-8?B?Q2dyOWthS2RFdStPTW5PNzN6WGFTNzkyeG53cFo1QWJOMm9sNENKMkpkOEF2?=
 =?utf-8?B?TW5HYWFiZDUwN2c1RkxFaVl2Nm93eEc4TG1WTTIwak5jSFBpMnZTbUNQcWlW?=
 =?utf-8?B?WnlybDB0SkRwU0gxSTBWZnljTXRZUG9KRmZ1NmpDQU9VSitzSURGRkx0cXJq?=
 =?utf-8?B?V0ZvcmNmd09ZbDdhU3pXSkh1WXdnaWpMZWxudzdQNGNrT0RObjRSRDMzb2lP?=
 =?utf-8?B?S3FLcytuY2I5QlRROGFyekhzd0grYktQQkRMNGVVbTZ0eHhBUEs3bXF6c2RY?=
 =?utf-8?B?YWNDMitQL1ZzWnBXUmNPcjJQeUdac01IV3U1aTVheW1WNnJpbzRzcGh5bDVI?=
 =?utf-8?B?Q1NpUnZ4cXJyQ0ZSRUZYQ2NpK2JwMUNvTTBRSzlLaFMwVzNzbmFRZzJ5YXRE?=
 =?utf-8?B?aVNwaERxTjJnOTJiOVBLaVJ2VzE1TWtybjNPU2hiaFdFbWp1bTI4cTJTdTA0?=
 =?utf-8?B?MFZmbzU4Z3dOaVYvMzkyRG0wUGZnOHlZR2Rpc2ZTaXQyWVJkODZ6OWk5aHp2?=
 =?utf-8?B?ZU1EZjBYMnpLQmlCcysrSXI0bUgrcVFxazc5aHhwQU1oL09GWnZGRnVnN05k?=
 =?utf-8?B?MDVVMTZJQU1pbUxHTGdZbGdJbHRNLzc3N2poRkhXUVhid2Q5bU9XRnMxc0hu?=
 =?utf-8?B?QmtSdlBpSEdIVUNaMWFPdXlDYk5Cc2t2WFkzVGs4MEZLaURuVTU0MkJIQjZN?=
 =?utf-8?B?TmlCaDZjcm5md3VORkJ1NkVsbFZCb0ZzcWJ5ZVN4c0N3YW5SWEdYNzdZK00y?=
 =?utf-8?B?SVlBZUFpVlcvVUM3OWhKcUhyTHBNSTVEejNnMG0xVi9iU3ZxQSs1VVppc0N6?=
 =?utf-8?B?WFJ5MUxhbm9Od0FFNmN4MUtCMHJ1dFJzVEpJa21veEtLbHM0Qks4WkIwWVEy?=
 =?utf-8?B?UkJLNWhabXZSYkhFRG5VSDZvZnhaZUlyRENBRUtVcGZDUkNlY1A3ZXNwMTJM?=
 =?utf-8?B?MXI0ODBieEhsS2J5Y29QSTRYd2JZcTJpTndNakh0NjQzYmxjWTgzcnp4aXFu?=
 =?utf-8?B?RVdlZ0hPNWVuT1lRL01ScE1XZjhCdmZTN1ovUG93V2dONEJpZTNhRUJVYkYz?=
 =?utf-8?B?SFZWbGI1K1NxVEkxR0hIOTV3WkdQN2NCMVcyWWZQdFZnanBBdDM0aHVhQlVO?=
 =?utf-8?B?ZTUyWmdFaTVXRVJqbllpVmtOYlNiWS8zTmNxazMzbzZqb2gyU004NmVDaC9P?=
 =?utf-8?B?ci9SR1kvNXJmbEE0TUJSRno4Yk9BOFZDUy9QalBtMURDbTE0Mlg2SFhhNFR3?=
 =?utf-8?B?dGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 601eaf23-d245-493b-65b2-08de32c33a12
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2025 23:25:21.0757
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vvN8mkYmKUwu/olwG36W11yiczq+zGpbj7bFHXvN40y1EIaqd1F3LqESNUCyZ6coSPM/BwT36riPw7e2ujQ+WaqGc+K04J3KTRutQLnYO7Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB8075
X-OriginatorOrg: intel.com

Hi Tony,

On 12/3/25 2:27 PM, Luck, Tony wrote:
> On Wed, Dec 03, 2025 at 01:21:56PM -0800, Reinette Chatre wrote:
>> Hi Tony,
>>
>> On 12/3/25 10:04 AM, Luck, Tony wrote:
>>> On Tue, Dec 02, 2025 at 08:28:56AM -0800, Reinette Chatre wrote:
>>>>> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
>>>>> index 46c64419ec10..50c8b4c50790 100644
>>>>> --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
>>>>> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
>>>>> @@ -57,12 +57,16 @@ struct pmt_event {
>>>>>   * struct event_group - Events with the same feature type ("energy" or "perf") and guid.
>>>>>   * @feature:		Type of events, for example FEATURE_PER_RMID_PERF_TELEM or
>>>>>   *			FEATURE_PER_RMID_ENERGY_TELEM, in this group.
>>>>> + * @name:		Name for this group (used by boot rdt= option)
>>>>
>>>> This needs a new definition since multiple groups can have the same name now.
>>>
>>> How about this:
>>>
>>>  * @type:               Type (energy or perf) of this group.
>>
>> I find this to be confusing when considering it together with existing @feature and its
>> definition that also refers to itself as a "type" using perf and energy terms.
> 
> Agreed. The two fields duplicate the same basic function.
> 
>>>
>>> That covers how different instances have the same string where "name"
>>> was confusing.
>>>
>> Essentially this is the name used for @feature and for this there is already
>> pmt_feature_names[]. Is it needed to create a new name? This would mean that the
>> kernel parameters become "per_rmid_energy_telemetry" and "per_rmid_perf_telemetry" which
>> is much longer though. The only limiting factor I am aware of is the command line size which
>> is defined in arch/x86/include/asm/setup.h as 2048. Here I do not know if there are customs on
>> whether kernel parameters need to be brief or not ... some kernel parameters seem to be quite
>> verbose while others are cryptic.
> 
> Personally I prefer brief names (as it isn't always possible to cut and
> paste to a remote serial console window to add them in grub edit mode).
>>
>> The safest may be to stick with the separate names but I am curious about your opinion.
> 
> Short names are good.
> 
>> Even so, it seems unnecessary to force each new instance of struct event_group to
>> set a parameter that is required to be of particular value based on value of event_group::feature.
>> If not using pmt_feature_names[] then intel_aet.c could have its own private array
>> that maps pmt_feature_id to "energy" or "perf". I find that doing so would make it obvious
>> what this property is/should be.
>>
>> What do you think?
> 
> I agree with one value and a mapping function. But I'm using the string
> name eight times, and the event_group::feature just once.  So I think
> I'd like to keep the string name in the structure, and just do a lookup
> of the enum in order to call intel_pmt_get_regions_by_feature().

ok. Since intel_pmt_get_regions_by_feature() is always called early and only once for
an event group this seems good to ensure that the name is always valid.

> 
> So new proposal. New name event_group::pfname for the string:
> 
>  @pfname:            PMT feature type (energy or perf) of this event group.

I think the addition of "used by boot rdt= option"/"used by rdt= kernel parameter"
is valuable to highlight this cannot be some arbitrary name but is instead connected
to ABI.

nit: should this instead be "PMT feature name" as used in the error message below?

> 
> static enum pmt_feature_id lookup_pfid(char *pfname)

Please handle the name as a const throughout, as a struct member and its handling.

> {
> 	if (!strcmp(pfname, "energy"))
> 		return FEATURE_PER_RMID_ENERGY_TELEM;
> 	else if (!strcmp(pfname, "perf"))
> 		return FEATURE_PER_RMID_PERF_TELEM;
> 
> 	pr_warn("Unknown PMT feature name '%s'\n", pfname);
> 
> 	return FEATURE_INVALID;

Looks like intel_pmt_get_regions_by_feature() handles FEATURE_INVALID fine.

> }
> 
> There are only two options, and no sign of additional ones. So this
> if/else style seems simplest, rather than creating a lookup table to
> iterate through looking for the feature name.

ack.

Reinette


