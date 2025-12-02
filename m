Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED693279903
	for <patches@lists.linux.dev>; Tue,  2 Dec 2025 16:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764691923; cv=fail; b=ASsOcsC2HHgSJpJ5LcszjWC0WjU9Pa++Z1hLvMftdj1oAeuS+JTJ5cMwWtD4J8pbVYEDjqsQo+OwbMpsPRlhcDELefekylYp+klbrBJy+ZHK+V5ZU23p/UG4fsoGp3BLYXRAkHxtOjx5oqUxvnRUy49WU5yMGsBEITOxmVxyj5A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764691923; c=relaxed/simple;
	bh=FyJTqWIRssuEygdC5nFsy8PMlbCkav2is5+XVV/NwcU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=PqPQ0Dy/pue0PPPh/45/6fNJBr09LtGX96/5frgza6M2E50OaN8G13VK4qmPoQFnTNqVrJNkTiFNE+HruUuGxuMg/SNC+/vvE32Cg3jS0cX6xCYORh4lxJPTeYQRldl4vd/8BuJH6FgUXOcwCfcNPuDSQXAHzjQiTkGku4ZbXcU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=a0rg1dif; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="a0rg1dif"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764691922; x=1796227922;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FyJTqWIRssuEygdC5nFsy8PMlbCkav2is5+XVV/NwcU=;
  b=a0rg1difENMv+0yWnvVfjSSW+Gv9sCCD6n00lMsNKlh569tJr8ANJlKp
   oCh48VjNoANWZVyXtHRsu7SLau3xpKch04LP3N98XC8256+UNpPwqef3H
   xo/MAr4QkO18QbUbtrFRgvf+Ph9wUOeEQDr1T20uf+yr4fsGNP2htBW++
   j3wFhw6P4zk1kJAqtuPsUiWKA1bm8mBV26AGCLSEeX87ZshQENk8fG5q4
   bsEoL/jDhXjfbMqkEPKPPusoMEl2ee2ZUSpMAhrGUu2bHKyBnF7MO3xAA
   Aewe+3QHwS3gBRH9IBzyadaACKv3tJsMKzgr8TNsUKqn/cXz94nQoDfUP
   A==;
X-CSE-ConnectionGUID: UEUaRcGRQeOidPkBqndqFA==
X-CSE-MsgGUID: EmDLoAUxRr2WQkGzAAM5NQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11630"; a="65669515"
X-IronPort-AV: E=Sophos;i="6.20,243,1758610800"; 
   d="scan'208";a="65669515"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 08:11:31 -0800
X-CSE-ConnectionGUID: gJk0LDbgT7C16gekpmYwUg==
X-CSE-MsgGUID: NVjfgVZCQTWn9BE8AdPB8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,243,1758610800"; 
   d="scan'208";a="195228126"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 08:11:27 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 2 Dec 2025 08:11:26 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 2 Dec 2025 08:11:26 -0800
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.32) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 2 Dec 2025 08:11:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pTDH8QxV6tkxFOpJWoy3lJSH0t21M3nck9ht78Rv4rw4yob7SMyVBDJiLhNAGbA35okjDm3rBPmtHgvwdp/t3DaGPwJwnacVsZ9/+KZHXTb/HWEKYApJwuK4FmVcUN+HEm4rEUUdFqpj8/ZRORUBTxr+27Hlc6p6IWtR5735b2Vrn9s8LuGgBphmvRfYeaw+l7wVEARZV/xRLUZKI8eC/6OXCIEQewTX5VcCCkgd97lE8gTwAL1HG93lCLw7d36KYtg2xbRhkMG4ZD5uzCeS1BmLhdy9S3fheUyHvH3sOHtOFEYQc5hnHkwHAJ5Q2/2v6thdENiHPhgIakVeIzzFIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JbsGDOeOmuPjBIEdvNLfIcob2gKjyUrFbDp1iV9Nhbg=;
 b=Oc0gzKrCOU8/6dWHSY2U/u7s3MIADR+rCpqnFxKIf36PlJ0THmTtJM6rLnrJelE505eSThYU+B44nclZznIvXCvGCE9GvfxzCYhQRSbRaIOGDgXs0lPsyvvS/6bWKA88xjrtmR9vtHpz9SPImQhUWcHGla0Nmz6yeRmJqb/GjfCaZH4Z61DJKY/g2yszdKC4+RL2X3sUfvJdhMi2Dgj8gwifvgwWjkf5XfBhf2gQDI8eIWjjISU5IaZ8fJempvOXFBtq6P5sLzSHXERHtdvdjsWPmp+Q4pAVr3htB/Mjlais6Nt1yM9QhyHIepUMgwtisrq/+d43AHYX4glgelyswA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by MN2PR11MB4759.namprd11.prod.outlook.com (2603:10b6:208:26a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Tue, 2 Dec
 2025 16:11:24 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9366.012; Tue, 2 Dec 2025
 16:11:23 +0000
Message-ID: <19a6a5ec-9039-4735-a260-613cd63a9791@intel.com>
Date: Tue, 2 Dec 2025 08:11:21 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 12/32] x86,fs/resctrl: Support binary fixed point
 event counters
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251124185412.24155-1-tony.luck@intel.com>
 <20251124185412.24155-13-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20251124185412.24155-13-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0302.namprd03.prod.outlook.com
 (2603:10b6:303:dd::7) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|MN2PR11MB4759:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ac5181b-5710-4c21-d39c-08de31bd7030
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?eWZBbkFwQ25ybVJBSk5veGRjb3V5clNDeGRBczZZcEF4ZVpiN05nWUtadlFF?=
 =?utf-8?B?anBHNHU0MDNPaWNORUlUVnZ4M1YzQkdUTTlXZXVxM1g3SWt6TnBHLzFLaWRi?=
 =?utf-8?B?SkJnWUVnbmNqYjZjWFhoVU9JZ3Jmc1RPZnl4UVVXK09OMmpaUS8wRGYvZnNp?=
 =?utf-8?B?aDJhRjdJR2lRYU1CSmtnTFJOV2JpWnFoYVQvWVZlaXYvQThtcXRmSTZjVXp0?=
 =?utf-8?B?VGVVU0R4VzE3YnV5KzB5YUJhaHNMNm5WY3lMQjJTYXVHc2JRTkRPenN2WE9k?=
 =?utf-8?B?d1ByVytxdUUzWmhlZFVsWnJTOXJDWUpwRVMwOTRKbHVzaVArazVmQ2REbTZy?=
 =?utf-8?B?V3p4b3p6ektINjRhaWxPSWhYejNGUVU3NEU5aitKWnc3b08wOWlUUUo1eDNU?=
 =?utf-8?B?eEtrSXB0VU5ZaFFCd212NWtmL0RtNG11SUVTaCtJRndWVG5yTWRRNzBBazdQ?=
 =?utf-8?B?RGxYdE9YY1RMaHROK2tRLzFMOWpNOVVCaGxKRHAyUHBsZmVWMjUwQ2piSnB5?=
 =?utf-8?B?azNTaHU2WG9idEtyQnJEK2R4SGs4Qjh2ckxPMlU2b3N5VGZrUEgzWkI3MlRB?=
 =?utf-8?B?WXpPYW43cFlUeCt1aVNMdytPci91N05HNDFZTFhXUHE3N3VqYVNYb0t5ajk1?=
 =?utf-8?B?cm1TaEhnM09DZ3JTUUpMRUx0b0xpK1RKZ1V5a0RNR1k0bC83akdwc0ZCL1pw?=
 =?utf-8?B?bElBR2tMZVFaRmRXSU1QanhIR1d6eVNGaEZrRDdmS1hBSzJpVmJadzdxM0VD?=
 =?utf-8?B?TWJCRnhQdzQ4UVQ1c1ljUVM1TWE3RmlFUjNhaUc3dlllMlR2VVVTTGI3OWpK?=
 =?utf-8?B?WGt0cUpCeEdIekpaR1Z4dkUyVU4rbk85SzhBMUNkc1Zkd29sWFFySElRQXZJ?=
 =?utf-8?B?WEVNdXo4eUhmNWhKQ1djcnhiR1VQRlRRTFFmTGlPV3VOZUplcUF2QW5LVlN6?=
 =?utf-8?B?OXVLUTVWc1FHamFadVUvakhQUEhwSEo2K2JNK2UwaWFncDRDaGxEdjZZU3BH?=
 =?utf-8?B?UHM0QVNjeGtxYm5ienNDRWF3aU9ZS0RzQ1dBNC8zTUl5SjdJb3lXdWV4bDll?=
 =?utf-8?B?aERNcExrZ2hCdVJWZFhIUnMwMUtjT005elhDdXBCUk5lVWc1ODd1TGp1WHJF?=
 =?utf-8?B?clM4Mnc1UzlwTWJMTXFzeGNhYStrakFIb3dGaWhmcng3NVp5ZHp0bUZ1L1dF?=
 =?utf-8?B?WGZqdUVMNXg2U2FPWi9CQzJLcm5wMmNjVFAvVUFoaG9FQzd6L1M1ZWZpRVVR?=
 =?utf-8?B?TUZ3QktteUN5OERUN3hyVXRSQldqYWsxTy96VjVzb1pKSUtveDRtRGdtajdM?=
 =?utf-8?B?amRNNWlVN1F3R3BrK29vTU1GVjIrMlZydU9ZaVB3V2h6N29WZVI2TXhLOUh6?=
 =?utf-8?B?eEp1Qnk4dEhVSHpOV0NCSXlLb0ttbUtMUUR5NzRIenByTVRlcnFINjArMDhJ?=
 =?utf-8?B?bXVUcUNuYjZGMDFtVmRyS3doQXlKVmZqQ29XdExBMG5QM0ZDbWRwYlB6ZmI2?=
 =?utf-8?B?VUxRbVFreGYyWUdTRll2eURrREVzV3pYcy8xbkVqMUpHS1U2a1VxSHA2NGlU?=
 =?utf-8?B?MW9HeXdoUXk2WklqeldSL05LcjJid3M0WFN6L3hReFlFZUtZYS9tZUVicEp3?=
 =?utf-8?B?clFlYTlkcVNXL1lOTXI4Skc0cCtoRGc5Z29jbGhyTVI5VytSNk1aOGFMQ0JI?=
 =?utf-8?B?aUhVRlJrQVBBeG1yalF6YnYxRVVhNVloVVNDcjZNQWNGVEx0MERhOFR0UnVG?=
 =?utf-8?B?T3lIRDJ1bDdidWliRmZrdkxSUVROZDBPREtnaUZyTVFlTUx2cEtsYVdwcE9y?=
 =?utf-8?B?ZDAyLzAyMS9pMlAyQ2FoMFlFSEJWN0dKVWxNRWc3ZkJzTjZrTE1ibVFXcFli?=
 =?utf-8?B?L0ppVDdVNXU5TEVuTjNhM2NONkpXY2hLNkVaL3IyMGRyRkVscGFIOVVRd0ho?=
 =?utf-8?Q?0BjwIsUv0+hp2/0TCY46GubLdEF7Zya9?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UDVWZnk2WU1jemt4WU1FVm14QjdTbno1L3VQaGxqTFNQbW9wZmVBb1FiOG9Q?=
 =?utf-8?B?aFd0eXdEQlpEMmdveStOV0IvK1VPdWJMVHZGWXJjVmN2SEMvdVJYSGRpQlFx?=
 =?utf-8?B?KzdrL083cHowdE0wdHFjYmxianBEOWhrc2FRa2plTFFubHp5MlpaOC96WXc4?=
 =?utf-8?B?RHdzdFV0QnVHajhuVm5BTTlZaWI0MVFBd0svZm1ZblVPSVh4dnA0dWJ0N0pt?=
 =?utf-8?B?WUd2ZVNrWXpUNCt5c2pTenoybXRIUUIybmJpQ0V6WkVRZTg0RDAxVGo2M0pR?=
 =?utf-8?B?WFNYZlpBbEliNEdrZE15dDlGQUlQZHNIREVzejI2N3JQdTdoZDVnN0hZVXgr?=
 =?utf-8?B?MGxaSGxwN3pzS0pBcDhPaUtFTWswS3VoZXp1MVhMU2pzOWhOWGJNS3dlUEpi?=
 =?utf-8?B?SFJqeGtKQzFMais3cU0zNTdWdzVGL292dmRPSW5BQ2tmcmg4U1VmUDN1YU5S?=
 =?utf-8?B?LzdZY29vcFV5ZEp1MXJKQXpkK3dEMUtSYzRmb05XcGFmWWVMdnN4M2huL3V4?=
 =?utf-8?B?UzVPVmRhWnhrdDRxYjlJVjI2N0p6TDE4S2hwK2VTUjFCYmdkaitEd2JqSTRB?=
 =?utf-8?B?UUdJWFYrVXhoUUVHQzhBYnBub2VvOXlSaFRJQjlWamxxSE1QUXhOTXRZQkNX?=
 =?utf-8?B?SGpIcnhUUDJmUkJ6cHZFV0swdVlKT093dHEwT1RacVFSbGh1U0JQYnFSUUNs?=
 =?utf-8?B?UWdaYXJYOXl5RThzZnlQa2YxcCtpS0RiTklOSnFicllnT0JhT1dZakN1Umpk?=
 =?utf-8?B?L0NSTjBUQkc0RTJEZ3ovczA1ek9LU1pYVEJZeklhWUpZQWE4WE81YWVGcGxZ?=
 =?utf-8?B?emk5ei9HZWE5d0dLck1HbUFBdFRjcXBnMTJocWlKcmo0NmI4bGFUR3NjaEs1?=
 =?utf-8?B?MndhRGY1Q00wOS9QVUNXbEtaZkhjM1l2Szk2Z3B2bWdJZzhvQkhyVVZySkk2?=
 =?utf-8?B?b2FscWJzRTlnbkJXczRlWEdwMk41ZGNua3BwQ1BxejFJL1ZZN2JDV0pPY2ZI?=
 =?utf-8?B?aWhrY082bjc4bDJqaEYxMjcrOEU2Lzk4L1VYd0ZNWnZmY1MvYjRpbDBMa3R2?=
 =?utf-8?B?Q08rYWpaZjZWR00rUzN5eTF4SjlqVXBZU1FqSGY3bEhOTGQrZDhsbXBCWEgr?=
 =?utf-8?B?TW5Wa2FCY0YyUUxUYWxKVi9qbFpxc2R1eDl4WkxaeldQYVdOOC9aWXhLU1pi?=
 =?utf-8?B?V3JwNWhxbzE4VVJnT1FObTduTkVnMzl0aFYrYU5VSjZKb1JhbDJSN0s3OEZn?=
 =?utf-8?B?bDdQWWlDMU1PNDc4a21PN0JHcWRiZkwvTmlYQ1VDR2RXUWVXU3dlSzVWSGRs?=
 =?utf-8?B?OWtFOVNpNDVXNkhIeWo2Tk4rWGdVVlhvVE9PRnNQaHdYVWh5TzZXN1VQZlBm?=
 =?utf-8?B?U3VEVVpkRFNwQlFrN3BIK3JLTTBKTVRTVXkxejEwK0l3S3VVVVZDSXJsN3ZY?=
 =?utf-8?B?YWNwdHZNWjZKQnY1WDZ5SjRMb0tiLzYrQjJJOGh6VGR1WGJaUnVrbG5TZWx0?=
 =?utf-8?B?SU5sbHhWZEJTQUtiajRaU3BjeUZKbllEd2liMk9YYXQ1dmVMbGdZNkxrUmQ3?=
 =?utf-8?B?bEhNdUg4SmhWUzhWdmdiRitNUWZmamhIdTdJQmJaWFF2QnpIUW90U0RZNFFL?=
 =?utf-8?B?YzZBTTZsNG84SlMvZ3VJdWlmQ25mMHBFa05lc2JDL05uUWE0UHFiUmx6SVYv?=
 =?utf-8?B?Y20ySy83akNxR1VFbVJ2bEJTT3dYV0pPVHRFd1JuazBCK0RNdzcwOTZDZkl4?=
 =?utf-8?B?TlFINldwSEYyQlMrZDRoekl5V0JCaG1vamh1aWhrU04za0VLbXFZQ0VqYklZ?=
 =?utf-8?B?MUo2OHVTRWRramdLYzlqdm1CZ1o1QnNqOHdpcjZPYnJ2VDNIZXBIaXZDRjhm?=
 =?utf-8?B?TkpiL1NVYnQ4OFBheWhDL20wRS95dEY3UkxjN1daOUE1VkQzc0ljVHlTdXJU?=
 =?utf-8?B?aThTZWJHYnRiN0NjS3NCb1pCdnJTSHV3VGFHZ3YwOWN4YTIvd0FwTmwzTk03?=
 =?utf-8?B?QjFOK2o1SVh2Um1INmhwbWFULzROU2ROWEY3OTZseG1QMG0zc2xrZTZUdUt5?=
 =?utf-8?B?WmJvZzlGcHJYTnl5OExkQlJ4ZWJ1Z3ZmbUtxRnFlVE1ieVJ3TzMyRzBaREJU?=
 =?utf-8?B?WERlS255UzFNMjIyNTJmRHZ0V1gwN0d4Tk51OHZ6SVR3N1d3TStDaVUzNUJs?=
 =?utf-8?B?WFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ac5181b-5710-4c21-d39c-08de31bd7030
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2025 16:11:23.6779
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OSbUwzqlm+f7YAGvXrhydFgzxFUM9QSz4w0XMm3XCqiITHGQZvhcp1zJ9SCMAcAqBVnKcpakxnZ78BZs7SUmhlsTvpBNwVoCsnJBltQb97M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4759
X-OriginatorOrg: intel.com

Hi Tony,

On 11/24/25 10:53 AM, Tony Luck wrote:
> resctrl assumes that all monitor events can be displayed as unsigned decimal
> integers.
> 
> Hardware architecture counters may provide some telemetry events with greater
> precision where the event is not a simple count, but is a measurement of
> some sort (e.g. Joules for energy consumed).
> 
> Add a new argument to resctrl_enable_mon_event() for architecture code
> to inform the file system that the value for a counter is a fixed-point
> value with a specific number of binary places.

The final paragraph of changelog seems to actually form part of above, and did so
in v13. This new split seems unnecessary and confusing to me.

> 
> Display fixed point values with values rounded to ceil(binary_bits * log10(2))
> decimal places. Special case for zero binary bits to print "{value}.0".
> 
> Only allow architecture to use floating point format on events that the file
> system has marked with mon_evt::is_floating_point.

Considering some questions surrounding this name this could append something like:
"... which reflects the contract with user space on how the event values are displayed."

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
> ---

Reinette

