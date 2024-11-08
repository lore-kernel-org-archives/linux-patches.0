Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E87D1C1F2B
	for <patches@lists.linux.dev>; Fri,  8 Nov 2024 23:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731107358; cv=fail; b=LMSNnrYdftNLgqowIRazq4U+shXHAB1V12aQ2nd6c6VmJbsIre07WU7HfcvrcWzK+QBH4JzjeE2LoavcuWR+Aottc9Pri1lz0LXr775NIWMFpf5VmRFr8u0BJmzAjPJRO0BeUdNEI+8Hh6ilBcl0rCPF7gX/JREvVO27UhKqWmk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731107358; c=relaxed/simple;
	bh=BAwZw7Ky2/GhzyGdLzTh/wd/T62GiqTVUMMkN+bch9k=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=d24xQjhahNb74gsWJ6xnMR/l/YXzdBSvJND0ZnloZWvdOY7/8twECSjXB5te0bBFM1RjrN1oCgcE6lDk0RsYZk4znYW/xHip4eI3N9Zn3K6af6IrS6MLhT67aYvjt6IYrLSZSuFBjr76WuCUazT89FZWABMHArwZoCy6pwEKEjI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TvY3JDzE; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TvY3JDzE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731107355; x=1762643355;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=BAwZw7Ky2/GhzyGdLzTh/wd/T62GiqTVUMMkN+bch9k=;
  b=TvY3JDzEbsY3CUK9TsjHPPmYrkbpci7/WElFZpgzcGnYJwUtq7GSQk21
   txx5zGgmJrVjtqp7J1kgaigyLkgIfWcYM1ywRvMtJKKjP5rTdUDCS8a9J
   WHkNzP8WVyCWCS9YuCHKwSVnQ5vc+1cHMoVOVxAwdxIlEdOgDfOUIPxNq
   rqYfLRGZsL1uDGtMtS53xpq+eSS4rNmaQaGH2/MxqFvKz/UZJKk6LYoAz
   yHA7WAVzcGiG3eRXTP//RUP0G5FWDvl42tR2/r0ySZcD4RgoYa4e01bnz
   MjRgIvxxiYRUJ/O9MFY8CnbnTMR6z6GT7LYV7NX/1G/AOodeiAAjc8Qey
   w==;
X-CSE-ConnectionGUID: eyHtFpy7QaC2HJUgtx47ew==
X-CSE-MsgGUID: hVEAItBeT2usRCkljzxKxg==
X-IronPort-AV: E=McAfee;i="6700,10204,11250"; a="30420100"
X-IronPort-AV: E=Sophos;i="6.12,139,1728975600"; 
   d="scan'208";a="30420100"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2024 15:09:15 -0800
X-CSE-ConnectionGUID: v/NP3vMHSyG2WO/MN3dk2A==
X-CSE-MsgGUID: flT1QUtgTYG+vAkym/5LNQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,139,1728975600"; 
   d="scan'208";a="85777037"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 08 Nov 2024 15:09:14 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 8 Nov 2024 15:09:14 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 8 Nov 2024 15:09:14 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.49) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 8 Nov 2024 15:09:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HSL4gsyvg/qksjU8GQwtnDoV+yNf+vByHs3mRio31epZvq49Fu4K2V1DJZzvw4mJY1XDqPfdQ4ESA1C1SYci/M98KGUezckSt/I/zoj2nBIbm3j2MNvMhYp3lsruMgFG+sGRX2fKNu7A7VIAOTiNDvFvnuK3Uc0whABR/D/Mi4Tl+nl4nCjUoOL34tvyr5Bc5t6VH2Fyd5/VJOF6telFReK6umDl7Gj7yG6U3CyTj4tT0rwdZkyIgSVDsDuyndKGIZCpMG+rqDejTYubZOoPZK0GaOOnnKZJ/OqxrkGc+FFV8LHfKBA+c4xe+hYdp7rHlyNhCxrOZpM4TkZXz9QLQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xt8fUhG+TKgRU/+ZbIcpPkUVt1XR00imwUXVu2bu5R8=;
 b=dHS6HP7xqO3WC1bphBoG63hVIPnX/qHncO1WZSgxv3WrLt4Gy81Pt87WDeSDq6t+v66sXuzq8TJWevgKh6PK1+bSbwMiYe9jjAynVC7gDGGsQSWyMVHUxE0v0p9d4/L5Ra2d+SWuPucO42ODsU8y2xBpEyYjvDhKfBiLiZ1j6RnrcU21TH3hPPHX6azuRPleF64zWae667KWbMW93ae4aCKg8cvtYsh6LuqqZGhau11Ljo3t205uu2vtzuotcjXJxYfpwUGiA9xSy+NQEJJjfSKDapap9NcquETvmkOxE/orvsNQdsK7HZni4gM3hT8TnWp95NomF1b2nQG5Rp0IMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3320.namprd11.prod.outlook.com (2603:10b6:a03:18::25)
 by CH3PR11MB8591.namprd11.prod.outlook.com (2603:10b6:610:1af::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.21; Fri, 8 Nov
 2024 23:09:10 +0000
Received: from BYAPR11MB3320.namprd11.prod.outlook.com
 ([fe80::e8c4:59e3:f1d5:af3b]) by BYAPR11MB3320.namprd11.prod.outlook.com
 ([fe80::e8c4:59e3:f1d5:af3b%5]) with mapi id 15.20.8114.023; Fri, 8 Nov 2024
 23:09:10 +0000
Message-ID: <436a6b74-aa0b-42d7-a364-fce3b96ccc02@intel.com>
Date: Fri, 8 Nov 2024 15:09:09 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86/cpu: Fix FAM5_QUARK_X1000 to use X86_MATCH_VFM()
To: Tony Luck <tony.luck@intel.com>, Dave Hansen <dave.hansen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20241031185733.17327-1-tony.luck@intel.com>
Content-Language: en-US
From: Sohil Mehta <sohil.mehta@intel.com>
In-Reply-To: <20241031185733.17327-1-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0149.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::34) To BYAPR11MB3320.namprd11.prod.outlook.com
 (2603:10b6:a03:18::25)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3320:EE_|CH3PR11MB8591:EE_
X-MS-Office365-Filtering-Correlation-Id: cf9db0ae-d49f-4565-d8d6-08dd004a5a4b
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?OUFCVUhIVjNnK21vRWx3Tml4TDNGOFhNd290bVJZOVhvcUxWNU9iVitFMnF2?=
 =?utf-8?B?a2plYjVsK3Y2YnJMNVVxRnAvT295SVd1KzNWRFI4aHVsTXIwUUdXTlVkYXM0?=
 =?utf-8?B?UFRZYzNjakRqbTk1Q1NvZnJmaTFzbnFFc0doWkZUenF3THplUTVEYWhQampS?=
 =?utf-8?B?UFNEN2dHVGhMYzltdmxwRUE5WVlJVnpoVFVLQVovdXR2UnVtMUpLN3BlcmF4?=
 =?utf-8?B?MkF1OGdYaEpTWU9pSXBEN2lWRzhoeStua3BTMjZXUVczaDdWbWFobFZMdEVV?=
 =?utf-8?B?eTBhWHNjcTQrL09GcU92VXVkRU05R0p2ajBsNit4aytxV2EzQUxRbEVSS0Zh?=
 =?utf-8?B?MEhpaDFtdk56d3JiOFQ0T3BxZVF1TmRvdXpvcDhacEhMWnJsMGRvdmhjeG5L?=
 =?utf-8?B?R1pqOFV5KzFSWENqa1NhL3RFQzR4ZmdqTWljblFkRnhVMzhFOFF6VmZKVk5U?=
 =?utf-8?B?Z2lQd0VoY3oyRmo2Q3pOd1MwcWVKVWhtdXFJRERKMERMb3dEcS9zVEw0OC9G?=
 =?utf-8?B?TlNWN3BMSUtvOStwSjlhZ2tvdHRGTEl2SC9RMDlhWVpmR0RuTGtjVmEwcVpr?=
 =?utf-8?B?SGdkblFEekhWNVcxRWthNlVoYzQybDNRTkpZRU9Lbnc2R3F1ZE5EMWZROTNK?=
 =?utf-8?B?a1hGM3diV0ZvNFpIaExRdzBkRFRNSERqeCt6Z2FqcEhuU0hZajdacjFMMW8r?=
 =?utf-8?B?ZndMRjNxYStjcjFhaUp2Y0F2bXRmR1RiZ2c5MnJJV0UxeVo0WFpobU84WFZr?=
 =?utf-8?B?b2I2ZjJ1a2FwdzFxYWI2dU1PNit1Mk9uSWE2N3hSeXhzcXVWNldTcC9YOXZu?=
 =?utf-8?B?ZUwvN3d0aERlUzhLV1lIMHRYT2VNUTNZNElWZ0ZXL2FpR3FudTl4aXRBcVpa?=
 =?utf-8?B?ZU9FZ0hzWURndmxwV0JiRG55UEJUVDlodW1vQ292NUNIVktKNGIreEdqK1BY?=
 =?utf-8?B?dk5IUEpRL2ltR3luQjUyNjR6clRmb3NLanBJYkRtWGlEYUtHZlQrYzBBdWlv?=
 =?utf-8?B?T01HUjZzWm81Rk44S3VtQnczSS9vamhoTGRkQm5qNW1wMDRQZGw3cU9yTGEx?=
 =?utf-8?B?SytzWnNoajdCYVR4QVJiVHBvUEdHMkJCMDBMUFpoTGtoczVycThvVEcxNitk?=
 =?utf-8?B?dit3dzdQcVlWM0l1UEN5NmpNUmY1c3o1Umd2MTVidTdiMEl5OENiY280ejg1?=
 =?utf-8?B?MnAvVE9rZXBGNXJMclV6SGRkRlhaZ0tkL0xreWRPbXpsZ2hEbjdSY0ZDSW4z?=
 =?utf-8?B?M1JKZUdwOTBLclNTcHpkWjFpTFdkTTljV1Q0YUdkaWxwditKVUxxSjZCMGF0?=
 =?utf-8?B?NnlMK3IzU1VKVVpPRGtpNGd6Qm5PRjZFNEpLY1lmVnBXY2c5THhJcXZQVmx6?=
 =?utf-8?B?bTZObmt3SzJWVXhkSU0vaXFMQksrVVRsbHl2a2ZkNVdFeWZvYVBGblMxTFF4?=
 =?utf-8?B?bWdvVmpiSkNONmtTNU5Kb0lZSms3eHlsYVp0QnRSOUxjNGhUR3E4cDhvbTZH?=
 =?utf-8?B?Q0d5RG5kOUJWYThsS3BUQnhXTmR0b2JQd0M0MUErMlMyOVJ4ajZHTFNpZWRa?=
 =?utf-8?B?RDAyQ1d5Vk1icXJCY3o5emdnbVJKbUpIcERlc21LVjc1aU83SkdMd21UdFEw?=
 =?utf-8?B?aXl5MmcxUWxpU1ArYW50VmRSalduQW5mMWg2dDB0QnBsUitFT3VQVGxqbFFG?=
 =?utf-8?B?K05uaTBhMktadlQ4bU9tSkowSlJnSDZqcmhEUVA4eVoyS3ZHVXlEK0pkamFv?=
 =?utf-8?Q?hrSXiGSouY4tU9dJuQ=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3320.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c1E5ZldBS1o1dXJ3S2VpeTZ1bXh1VExHeFFDd3ZjbytkK2dheE01L2NMb2k3?=
 =?utf-8?B?dDc5NittQkpJNFpFRTAzMkxTaWJaeFFOMEF0a3hGTCtueG1Zek0yNkFMK1JR?=
 =?utf-8?B?MzdQQmhoUzJNcndlc1FSRzV1SGc3VG9KNVI5WGZOb0FZOWR6TVc3emN6YzhC?=
 =?utf-8?B?a3I5aVN5LzA0WGlxQXl0dkZ1UlNLOU9CRlhxTHhjT2RwYmRlSXZaK28zUlIv?=
 =?utf-8?B?d0xNUWFCdHA0RTlqYktkYjVPdzhCZDgycHlrby8rV3ExaVBmcG9yemVWcDNk?=
 =?utf-8?B?amZTbWxSYUVCa0t1c2x4RUFGQ1UvWmI3dzAxQVIwSHR0elY0UDg4NFppREY4?=
 =?utf-8?B?RDJQRzRXaE1keHRuYVcxck4zb2pGSGl0RWJ5ZWtWRTEyZkRuRk9TYnBabTdm?=
 =?utf-8?B?MWlsOWJpckIxdU8ybGRYQ0xyNktLVHB5ZERtaWJ2YnVKdUxKSFQ3dDhQTTRr?=
 =?utf-8?B?SFQxNmNnVWJmSlFpSWtiUHY3ZFBxb09VNlJSdjNETVowMzRtdFZWYUNJemJV?=
 =?utf-8?B?VnAvb0Z2QnJQRHg4K1NaMFpnakczcUlpWklVLy9OcGtxbVVWQnVwNkM3a1JP?=
 =?utf-8?B?S3BvTldwT2swTTZGYS9ydExRWkh2amYzRkNNZ1M3d1FIYmFIVnVMWUE0b0tk?=
 =?utf-8?B?RnJucUlyOTlRd056RkZRZndCeXl6ZDlwMGZEeUdzVlFhSnhXbFZocWZMRG5Y?=
 =?utf-8?B?aUJLRjl2M1Jlc2VGR2JiL0Uxc1hnN1RPb0tZdVVNM1VLV3BQaHZhUCtuVW51?=
 =?utf-8?B?RjBZV3FSUEk1V3c4UW9FdER5VjQ1Tk9reVVIUy80OXo1c2JyamIwczBVN01Y?=
 =?utf-8?B?QW5jekszTkJlUDVwOWJvb0NlQlQ5MW1rcGlXVkNNQS9hSkxRdG1yLy9DMWxZ?=
 =?utf-8?B?RmMwVUx2VnZoY2lSVzlDaWZBNE9zQ0dhS0t4bVhuYTRWOWNJTkFrMTdMTEV6?=
 =?utf-8?B?NGFSSXFxdFFLeWNjb0hKL3JrbEYwZktyRTMybVVOR0FMUzh4RU83OWxGVkdu?=
 =?utf-8?B?VFl6K1pvNER6WHNMYnY2dFBzYmY4K21hc054NDhJUEJ6UnIwVXRveTRCaU1l?=
 =?utf-8?B?dHdPeHJaV2drUkh1cW45NWlGKzJGTUxpTUR0dU5QZ3NaYzREQW1WUi9yOW5a?=
 =?utf-8?B?cStvQTU3UTNsaGVQb1ZVWkVHSjJORURSRVA2UldEeFFFT1lPQkFMVnlhTjQv?=
 =?utf-8?B?eTZYOGNGcnZyampHMUpxSlc1dHpmVDU4V3IzVFVzYko2KzErK3hJUmo2eU9Y?=
 =?utf-8?B?d1JLRlNiYVVkTktUOU9IK3VtdzNIN25LS2hxamJDMVZTbXRNSExXckZiazYv?=
 =?utf-8?B?VXlmWjRlaUJXV1JoTjdIczVxNHF4b0pLQTl6azMwUGZRWGdXZWpIdXJsQjda?=
 =?utf-8?B?aUQyaVpwKytWNlZOaXVuTUdwdmtydFRSZ2k4VUdNNGRKRGVsaDU0NXl1c0Js?=
 =?utf-8?B?Vk1Lb3RqcTJDOFAzQU5GM0NTVGkySC9OUnl1dzRKV1dySkhjSE9xcGR5VHJz?=
 =?utf-8?B?N3NKV3hYMnBwdXVrdE16YThURlJpRUxMbTQvWDFVaHRPbEtQYjdXY2c4a1lu?=
 =?utf-8?B?VVZwOStIV1ZQdlErRk1xN2lUQmdjRzhMRFl2S3NhejlueG9ITTFuRW0wc3Bw?=
 =?utf-8?B?b25pdDFpRFMvMTgrVXJyWXkveElidnI4TCt4QVd5cWpGMnNMb1lNVktuREF3?=
 =?utf-8?B?Zk5VVUVkQWpXL3RTWFdWc0hzdmVFVlF6RUY5TlhhbkxRZ3EyaWpLeUJKRGh5?=
 =?utf-8?B?OU5UR3Y3U1hZZTVOUlJ6TVF5cXFUT3h1allGSE44bUNDWFRWNDNxVFZEYW8x?=
 =?utf-8?B?U25yZVpsTG1sWHZxSlVLSUF3dWdEbXlrWTR1a2JFMFhxWUcvdTg3Ui9reTBN?=
 =?utf-8?B?Z3hvMGxPMGVoZnM5U2V3R2kzbTFKckFIeG9nSXMxV1J0YUNFaFp4RzdGV0hu?=
 =?utf-8?B?MUg4VHNWRDRyNENXK1djTFFSd1NLUEVKUXFjd0Q2SFpOV0QwL25iM0lKRzBk?=
 =?utf-8?B?Qys1bjlxR2dRREwzdFcwTnM5MGNnVER2RjJvUmhCazVUQythN0d1TVNnVDgx?=
 =?utf-8?B?ZVRGWHBRdTVXUnc0N3BkWDJsaFZXNVF2emVmd2RNRFJlclRkL0poeDNMOGtH?=
 =?utf-8?Q?xSpMWimAabj7CKa1jfDohuW3i?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cf9db0ae-d49f-4565-d8d6-08dd004a5a4b
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3320.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2024 23:09:10.0664
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gZ9s24P57u8LXtT2jjCvmwZEzhZsPR9+g66gVJ/GhioZXUoTSvhU92unBzaXaTqdG1F7PcW2/lOX1Ap8IpqUeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8591
X-OriginatorOrg: intel.com

On 10/31/2024 11:57 AM, Tony Luck wrote:
> This family 5 CPU escaped notice when cleaning up all the family 6
> CPUs.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/include/asm/intel-family.h             | 1 -
>  arch/x86/platform/efi/quirks.c                  | 3 +--
>  arch/x86/platform/intel-quark/imr.c             | 2 +-
>  arch/x86/platform/intel-quark/imr_selftest.c    | 2 +-
>  drivers/thermal/intel/intel_quark_dts_thermal.c | 2 +-
>  5 files changed, 4 insertions(+), 6 deletions(-)
> 

Reviewed-by: Sohil Mehta <sohil.mehta@intel.com>
