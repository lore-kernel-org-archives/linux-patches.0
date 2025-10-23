Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D05517D2
	for <patches@lists.linux.dev>; Thu, 23 Oct 2025 04:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761193352; cv=fail; b=mIGnfgiNUmBCbKC3kGEpSbBx9p400iyiQSTqg41DRIOvSY9vb6Zllpgcv4mZPG1WAubC9Nr0Y01TJWIPbaCru8T8g0vWk54jj+CFsUgbkrXsgqmdHbbDb24lP2fDLtsZvxyRdKPScPVJb7XoVZXffVBHmxIJS/gzIn43ealWTyM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761193352; c=relaxed/simple;
	bh=7Gthk0FdivXgNwaWUuNrM7RoY33KdprCG8xNJttbYok=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nmwxyOEY/Oc8TmzzfMkXx6jDVcukCe1krQGonZSNm0uLZmsXy5bUNv5Kqdkue9ue2aqG39vNCqTf3UkQTbFcvtFf0eDPMfN7E6/dCwjJaff18j65F0h5+z4lUy02XH+eYvjnV4qxxaVH9NX7cvckPsfnHs/W+jOH9AAqkz0qanc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bVi7m+wb; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bVi7m+wb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761193351; x=1792729351;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7Gthk0FdivXgNwaWUuNrM7RoY33KdprCG8xNJttbYok=;
  b=bVi7m+wbzh5SbQ+lxUPY7HGXGKsxMUS/Tj2OIva9S6Sv/Gb4Hf3xrNQ5
   GZFVFEp88Oioaap/GcLlK1pMPsPUU73SUQ0WqJboakVSY0Ls1XLxAQonv
   O6mAgC2GeWWZEGoRJmyiCxMq0djpB8FkDkXu6YUDTsKXym5WJzxgOlmqC
   tUpxs3plZl0d5iWN/nLMCZirAuwLJJ2wEoKhHEqyz4mo/Vi39Kf4zB9hA
   Im+PX0CZ2vFITMIrFygPAezMDqFZ6tPZF5hWakTXpZoQd4p4uN88qSLjn
   7IUu+UeOwePGg8yjVCMNTENePO1IXT3DPufbSCzwrUlkmrySpun7xstKt
   g==;
X-CSE-ConnectionGUID: KrTKo4m3T/y6V58SVf0ooQ==
X-CSE-MsgGUID: jKfbEYPWT6aH2ib9NflRlw==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="67188893"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="67188893"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 21:22:31 -0700
X-CSE-ConnectionGUID: AjoZREqWTLW0w9aRxzZ5TA==
X-CSE-MsgGUID: BM4iR97LRdC8zh321c0yjQ==
X-ExtLoop1: 1
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 21:22:31 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 22 Oct 2025 21:22:30 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 22 Oct 2025 21:22:30 -0700
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.40) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 22 Oct 2025 21:22:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iZG2NguZxJTBiXBqo4jVcmdax4RuFCod2umWPEDBg3zs1WVocOFY2BEV7cgxiWhHwdPaL5gn3w8FiOkiDhorKbEHZw1U+Tra0Gwcz4a+Tyt8TBVQ1FgJMWhfhaExZuzzc5VJNpndhLr87S8nuusKwCbp9BWSeNVnZArGykn1NIM6zLGEcZXm0GsBLVu6iFsdo02VPkufMSgXvYMHDsgWEsGVwmefZwJ0uJJav7fZwMEkv58R9DQQsoHrkUvc7OUUsdJ4pUXD4A8GamZsfh+X3NbC4ZVAii0E76YGu8u7lqlRs1HP/Gg8fHA5QFd1rpq4WMxQ7BBmufIGtgPeTeNRPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h/XfBRUrbw6SUsMHnTIa1RhCzHT8D8dYoL/e2xoOq5U=;
 b=ngB7xqd9EePE9mlqqaSgZ+Vrb4K9MMmWQydcQ5/70v5TqaD6CO7csBPMCm20IRG41i199YyCsd0yJZVvk3M15de6+HboURRylVxEiJOq9AtphT64EeQYBWkKDKWgkN8ASenOnBK0LCa3x57dFXlFhL8VQJaUJrZk6CvLlRPUphgOfHQRM1Zchve7CKfAG+nNQVEmQCIA/3CFD/Uh2iUSQoQlNOwtFZAwY1CyZ+5ugOjn5+BN/P8DPamQTzoA9dnbmVFbBjwgWR3eBEkbDZTdqgWOlHtDSe3nBD5sGxQ5atknOk4tCn2jz6NYQpZMdGZhrIDd9oY0wYlv7Re6sDqHFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DS7PR11MB5965.namprd11.prod.outlook.com (2603:10b6:8:70::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Thu, 23 Oct
 2025 04:22:28 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9228.015; Thu, 23 Oct 2025
 04:22:28 +0000
Message-ID: <5d38a009-5d02-46f0-bc76-3a39f8a5d16d@intel.com>
Date: Wed, 22 Oct 2025 21:22:25 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 10/31] x86,fs/resctrl: Handle events that can be read
 from any CPU
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251013223348.103390-1-tony.luck@intel.com>
 <20251013223348.103390-11-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20251013223348.103390-11-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0086.namprd03.prod.outlook.com
 (2603:10b6:303:b6::31) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DS7PR11MB5965:EE_
X-MS-Office365-Filtering-Correlation-Id: f9a7036f-33aa-4084-d4cf-08de11ebc678
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?djZGdzZSNVkrOG4xWjlBQWV1VzgyT1RLWUtRTzIxSWZTVExXMW55aTZnRENn?=
 =?utf-8?B?empkeHMvM2FXa29GUU16MHFHMlNTSmFOUTRUUEJzdDMvaDRXSjhpcnJRWWtp?=
 =?utf-8?B?TmxhZ3U5L1k1S05zTHBxQ0hMdEVibndPZ2pVcFprOWNoR1JPbTVVSUpTcDBl?=
 =?utf-8?B?MzNRRE9sYnRRQSt3NXZqQnVvMTl0OTBLeWcxcTEzRXdpL3FLMFk1OXgvdEU5?=
 =?utf-8?B?TTdrN0JmQXlXMzZNUElkdERJcThDdlpva3gvMVJwMncxeCtqOCt5a1FKbUo4?=
 =?utf-8?B?ZGcyYm12ZWxhVXBacTRyTUZvT0xBTnpQQjRsa1VxejU5S2pPdm1hYjdCQjVp?=
 =?utf-8?B?a3pVRE9IRE50Zk92R3dHS0xDZFJmeDdCcjN1d1B0VFphZ25wU3cyWllESUpI?=
 =?utf-8?B?cUdwODdROGRPMnhpbzdRcnJTdVBYS3A0cEszOHlreXBSbTdPamNMb2g4VFo1?=
 =?utf-8?B?dkgzd1lGRmMwUlE3bFZhbEZPcVEzM3ViU2tScmhCNTFSY1FZUm5tM2lDVWFW?=
 =?utf-8?B?ODlybDgwSis4WGpuZE1zSGZKMDh0cUhzb2MzMUJXSTFwWG5Va1REWWdhSkdI?=
 =?utf-8?B?Y3huN1VLeTdTbnczVFRIQ01tN3lJdmkzK25FdldTbnlqT2hSRE5RN0RkMVZC?=
 =?utf-8?B?YlBLY0xqNm8vSUc1ZnJCaFh1aDYrTGlTWjFpYUFDSkZWeHROQWJXVHVxb1dZ?=
 =?utf-8?B?akR5UUV2MHJabG1nQU8xUjRjWjEwa0FRZ1FRR2QrRENOVVY2cTZOS3FPckZO?=
 =?utf-8?B?RlhyRDVXNGVBL1Bic2NmM2M5cmQ0TFFSTGZZeG95bjdac0kwUnNtVVk3K1U0?=
 =?utf-8?B?OGhYcFo0SmgvTExIZVNiWCsrcXNkaDRVVmpmTW5pLzVmVzMvcWxJZWN4OGZH?=
 =?utf-8?B?dDAyWFdYR0t2ZjFaVGNIZEtaSlpDOHFTMURPTk1xeFNFM2FWbW9pUklNaC84?=
 =?utf-8?B?Umt6T01kNU9aekFucytmYmZQbjVYZFFkNVg2VFVrRTJJUGd2Yk8yQlpTYXQy?=
 =?utf-8?B?Tnowd3JsM1NRUkl3ODZrc05xSHN1eERPMDBrSEVna1NqSVZsMWxpT2J4K05w?=
 =?utf-8?B?WlJCTnRVQVMwQ2UxeXFRSTBoMlJteUpva3dlem1sOEYxVkZIdWJNZHJ4b2F0?=
 =?utf-8?B?Zzlld0l6OGwyM2tEZitxZ0RUNU9uR1RIeUtvRG9HTDRabXI5Mmk0QlkwR2xK?=
 =?utf-8?B?Wk1kcWdOcjMrUGcwWGpOQ21nQW5QRXNpaXkzSlRZMEx2MTVSd3pFS2FUcGlR?=
 =?utf-8?B?dTZKTEZ6ektWblFienp3d2V1a1JaSVllaU4rM0JiZ3ZIelVIYjA2ZDdEcjFT?=
 =?utf-8?B?YnJmU0JFL3AreHB4SzRPYml1cW4rTEY2VGpIY0h3YVhmaEx2SjhtZmxiWDln?=
 =?utf-8?B?YWNzaE1uVEg1Y0V5aUVNS25CdUJrQytaMHZlOXpQZEMrdXArUmM2NkE4S3R1?=
 =?utf-8?B?bkNrejBwcTdoUElqL01SYWd0ZHhwWHpmNUZzS3Y0Wld6MEhFOVhpRkswem93?=
 =?utf-8?B?dFlVcEV0YVpDVmhVbk9lend2N3BuaVVqZC9sV2hIQzZyVUdhNWhEQm5nLzRP?=
 =?utf-8?B?MUNDSE0rUWc1bUtsa1FnWE5lKzdFYml6QVFkT1dPeW1CRG96dnR5YjFyeEhq?=
 =?utf-8?B?KzhBVVJCeWJhOFNqMHZrNjd5b3pYbytYWGpIQzlHVjdjN3Fmekh1dyt4djVr?=
 =?utf-8?B?LzZuOEVZWGNMTlJZc0ZKM1oxcXF3TlNkZXhqNUJ2d3p3Uk5KR052aGVCZ0F3?=
 =?utf-8?B?REl1MExta2tZVi9zenFwcmFOcUhUdWZtazZwUEp4R095L0tFa2tUYldGWDll?=
 =?utf-8?B?Vm9rWEtpMlFvZTF5bmpkOGh4QjZKMHVNRWV1dzVia1ZzMGpWanBMcW1yTEcr?=
 =?utf-8?B?dzVHQ0M3aXhKR0drTHhTaFg4SGwyN3NxeEtjVmFFUDkzdGFxOXoyNEc3cng0?=
 =?utf-8?Q?ueJSV7w+m7LO4FsFG7fE6YldCx4uqKsx?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y2FZZGdDNnBJT1dMVytYeGRHWXV1QzkzaWhiMkszUDl3RGFUanROYThRV215?=
 =?utf-8?B?bGcvZkJNUXFUbGcyZ056dU5uK1lDSS9sNktFRDVKNmN3TVNieTF6dDFLM24r?=
 =?utf-8?B?UFM0d2hGUEpHU2ZMaU9PTmhDbWlIdXVraklOaWJpK2pMUW0zOHcxYXpoSE5i?=
 =?utf-8?B?TUlsU0JLVW9IWlRHR3BSaEt2cXlJaENZN0FZM2tHNnlBOGx0VjdGeVd2UFZp?=
 =?utf-8?B?bVVvZi9JUDExRVoyQjdRSjQyazFmUS93dGR0TFZvRVg1L1k1cWhSZUNjTTVM?=
 =?utf-8?B?S0QzdEJSbFpBY05OVk9YNkZqUVZGWWRSbjB1cVZzYW1IdVo5RU43UTQ0QXVK?=
 =?utf-8?B?WUpNU3Y4TWZlY1dpSHh1NEl0dFlUdW9zZnhJY2dXQ25rdDV4TktRa25PZmp4?=
 =?utf-8?B?VXkyREIxUThCWTRSR2hTUEE0Qlc5OUsvTyt2TVRtMHNEN3l5UjYvOFNjUXJI?=
 =?utf-8?B?VmNDZG1nQ0wrbXRCbXRrU01xaHNPTStNQ25zMzY2c2JGTlU4dEcvRGdqclBR?=
 =?utf-8?B?ZnR4M3EyNHYvV2FOMXBxWi95Rm5iZ0RDcWlENjJ1Sjh5VWlwWXlmYkFaTCty?=
 =?utf-8?B?b1pxSi9rUGZBUGcwVm8yNlNEVDVYSEpOSjRLK3hURXFvNkdTSnc3Sjk5dTlu?=
 =?utf-8?B?eU1JUDVoZEswWWJLUlRjV3FJbzU5eWoxTjhOVHRjMmsxdzNaeEFnRGxIRTFN?=
 =?utf-8?B?U1Z4ajFFTDdYS3drVFZDNnNFdXZUdXNxUjdOZlh2THlEVWMyRzMwRDRJOU5K?=
 =?utf-8?B?dC9OOS9hUDRQeW1aeWNiaWdvdkw5V3pBNmZUR2hBdDBNZVdaZy9BZlAweDla?=
 =?utf-8?B?Z0pUY1ZNUWlBZEM2MjJqWW1WSUNvcFZkM0x4QzA5WU9EelFaUnVBenBEMzdp?=
 =?utf-8?B?QzVoOWRyd1N1dDRGVVZDQUh5UEh2clhiRVpLMm13SG92UnRRQXN1WFVkYmlR?=
 =?utf-8?B?dDdqQVJleC9YdHRjUldweXFXdm9WcWR5b0N3d1d6VG8wNUI4bmE2VERaRjZa?=
 =?utf-8?B?MGtIN3lSRjdhMUNmR21yekNnYTlJU0dmakdaRm43VFB3Q1JhVjNzdm1ZZHEx?=
 =?utf-8?B?VXFGQXIxSkNLbEVuWVkrbWFjUDdaZ08xNkhFRFFaTkk5a3NwYm1pZDZGS1Ja?=
 =?utf-8?B?YUwrV3FrVkVDMWlpTC96VW9ZR3lUYjA1dG9EdmpkUnkzYU94WFNnQlhva3pD?=
 =?utf-8?B?ZFI5NDZIMTNPUWFKWXAxV1lDaGwzYm5xYWt4YVdOODJjTlZpbnlZWlY0cWFv?=
 =?utf-8?B?M1FKV3BWeWZWTVBnZHJkSUl4bnlId09DOWp1eHlRK2VxY0RySmFJN00xTkVj?=
 =?utf-8?B?clVkdEthY2FNOG5oRFZLUVA1VmVKdzljZDVIelFjcWZTRTJOY24vaDhXUDhl?=
 =?utf-8?B?SHAza0pnZzV1OGVUWUFpemxLR2FaZTIyMC81T3M4NmdpS2VmRDk3TXZ1Smo0?=
 =?utf-8?B?a2FZdzZSTHJjUnp5U1RCaFJaYzNkeldHZ0NBTDlpL1E0ZFJacHg0amkrMkZK?=
 =?utf-8?B?ekprOTVvNEQ3NGVrMmJaNzBnd0NabktCYVFuSVJsWEdYWWh6aEpsbUExOGYw?=
 =?utf-8?B?aDgwb2VBWkFOM1M5NERrSlJoR25MRXRONVFWSExNaDRPdSs0VjdSd2dVYkl2?=
 =?utf-8?B?NVdpUTIyM1l4Tmc3UnlkclNGeVo5R2l4eU1EODFGS1VlSityWFBBYmdlbjN5?=
 =?utf-8?B?NU9NcHg3N3RSZGRQdjRZR3NkTm1OQkw0THB1Z2dUQXJQUXBPY2JaV0hqM1ZU?=
 =?utf-8?B?cncxdlEzb2dPbysveGNkY1NVZTNCOUtKcXEvRWlUYmJMaGxMYmdxZmIyTytH?=
 =?utf-8?B?NVVxcU1rU2o0bVlHRTlvL0xIOXg0QUVXcEJBL09LOU9ROExaMUh6WlBKUWdh?=
 =?utf-8?B?RmUyaVlKU0cveUZ1SU1qejA5OWRteldWTEM5VkI1NExlZkdJQVkyVitTL1I0?=
 =?utf-8?B?K2NKUjdOQ2xQYWI3ZVpDRUtuSUgwdWh3WGgrR0lpVE5DNVRMdk9TWnd2UnZP?=
 =?utf-8?B?YzBMZ2VuRG9JQU14eGlDczk3OFB3NllSSDlKMzdkdjNHVGU4STk3R0lyemJl?=
 =?utf-8?B?OHBTNERBbGJBeTZYTVdLeFh5VlB1VitESHViQVorU2UwNTRFcDlHS21ROUYr?=
 =?utf-8?B?M1p6TzA2MFRvV3BzaEZsOWs0cURSVnp1VmFVQW5yV2g5ZERTNWVhNkFQcElw?=
 =?utf-8?B?YUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f9a7036f-33aa-4084-d4cf-08de11ebc678
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2025 04:22:27.9661
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e/Hkwvp+gyyWci6soBLllMKDcK2vZnOU2Lm6Xy3nJjqIgLQ1axV+1EXa4dJQSrGq9HC7N02mKr0fwWpPogpGFNhpJe0cZneCibwegYh+H68=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB5965
X-OriginatorOrg: intel.com

Hi Tony,

On 10/13/25 3:33 PM, Tony Luck wrote:
> @@ -424,6 +448,9 @@ static int __mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
>  	int err, ret;
>  	u64 tval = 0;
>  
> +	if (!cpu_on_correct_domain(rr))
> +		return -EINVAL;
> +

To ensure error propagates, could you please change to:
	if (!cpu_on_correct_domain(rr)) {
		rr->err = -EIO;
		return -EINVAL;
	}

Reinette

