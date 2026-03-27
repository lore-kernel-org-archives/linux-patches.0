Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE6E833F5A9
	for <patches@lists.linux.dev>; Fri, 27 Mar 2026 23:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774653825; cv=fail; b=iwLw5jZCBaBpgauO5jwlAxtqM9xejdIML+TV9HrhUBU7ye+PHRxTQJy5jhrQu49P9Z4vZHpw5Os1UHok3yp7gcLtonVTLLh7BIp7j0qNbUv7QTYTWKjfRbc58SITzbegTsNDCB433bE6s4/U95/dzj7jmve2w2sRIpzpC/io4e8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774653825; c=relaxed/simple;
	bh=lzOfVWSey3VNipZOvDGX6Vq02USQr9lafS1aU65U7ok=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=OhmN/lomLivgBjqiIbYWT5KXf3b934iGV8R0IC5ggpmBW1OZ/PuIBDSgRBAaKRHC2kphvcpukbTwPesraSY/90cF36a8pSnGs+Ub6dHNGi333WyTA1FEX6WBIOOiR4pGTyW3bNOWH/eux86quZNjosVY4mTc7w3kPKUs1MT1yJU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HioTlmQ7; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HioTlmQ7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774653824; x=1806189824;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=lzOfVWSey3VNipZOvDGX6Vq02USQr9lafS1aU65U7ok=;
  b=HioTlmQ7L3RSVQHEjADIx5kix0CFJfnkVKnb6JHPnCN3GX2B7e7mfvJd
   SPExJHDb57+goXs2U+wts5qhUPE2V5mz8/ZWhXoBUsQManmwdu9V3hutd
   sS62huILRJn+bgroslq0eUjxIzEWu6apHtDGWP0BTlRyK/WtdMFe8Dvpa
   gs2z+dpu+J1v/lf0vCTNbTEyOc6LYEJSNnX2Hds2RW75xYxA/BcDsOon0
   qKWAnq+Ur+iO3dWlKs4ChiGiMp+fgAzMzevIiMAFfDCM6V8ZrSeWcl+Fs
   Nf89WjLu0UPP/3EY2gx5YTdGH926Km80hxYesBwM74FkS3nDDAbUX8xT5
   Q==;
X-CSE-ConnectionGUID: ZhziaYrXTPS9b4S1xrif/Q==
X-CSE-MsgGUID: cYG7RID6QHy2cX9LTiMQ9A==
X-IronPort-AV: E=McAfee;i="6800,10657,11742"; a="93314690"
X-IronPort-AV: E=Sophos;i="6.23,145,1770624000"; 
   d="scan'208";a="93314690"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 16:23:43 -0700
X-CSE-ConnectionGUID: gs5lwB5kQba/hWUJOmM5sA==
X-CSE-MsgGUID: YirDZY/FSriBbreuezsnrg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,145,1770624000"; 
   d="scan'208";a="222573880"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 16:23:43 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 27 Mar 2026 16:23:42 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 27 Mar 2026 16:23:42 -0700
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.67)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 27 Mar 2026 16:23:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hpCUqlctZnBHQnAZTd0EWAbNDDKKEjcc9zIUPUSC287FhmE94EL2BjV9ss6MbsuKBLRvjGhZJzLL/WNEM8e8DQQ1sCTbrFJt0YRbxE6q/dfrIBDJk46VY5MCcWyQaQFvDKp7VeqqNoaLCeP6gjcNEhi9jC7bzQGK+zZOhXsFmlWn6sV/xLrRLZLmlmMAXNsacQGFqb72iFMbHsrceqFfiwtvvTVpT2Ue99SP1IG+FSXqZ2w0kfYaxK2xHhsXoTiA9a/Wo8NkkmI/0tap8ji3KEmxWBjf4niibNQhTE6AYvp4Dl5JAv8vbFaW083AGWxvgKQxKTUk0rni+TQ7hG0y+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bcjBA04xGwJQix2OAQ7vrILeKriGrm81sZkFNCLiN9Y=;
 b=JY7OkdRtozeyn9VjTE2S8ehqVoW1ld0eapDC8AHvLGiXguRe5Y4X98YcPNzkVXGdtE0681I1Om/zSEv1I9v2rj73YmeOm6xj9kmrEAQQQngeV4kUnCFXZJAPJ3aYpwJd/55RfJDD6FeimfXThhnw6h4uwFEVOfyIuosmbHT8Ea/ephenw62Zx69ShuDRX2c0LMBfxkNggj7bOZx7hHt4lolx8tL6rs3Hf4PFDymVSni+qQ3Rk5vjLT2W74GJotxMdomsjNSJYlIMVyhXfGvHnVyyUWhQ1V6r2bKqBSf3+2pFeasyZoVXu9yB4JzSkvSbx9nsMuajtKVJfMCbPdBjaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CYXPR11MB8711.namprd11.prod.outlook.com (2603:10b6:930:d7::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.8; Fri, 27 Mar
 2026 23:23:40 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%5]) with mapi id 15.20.9769.006; Fri, 27 Mar 2026
 23:23:40 +0000
Message-ID: <71fe5d8c-3ff1-40ee-b4de-522a5a7b4195@intel.com>
Date: Fri, 27 Mar 2026 16:22:29 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 10/10] selftests/resctrl: Reduce L2 impact on CAT test
To: =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
CC: <shuah@kernel.org>, <Dave.Martin@arm.com>, <james.morse@arm.com>,
	<tony.luck@intel.com>, <babu.moger@amd.com>, <fenghuay@nvidia.com>,
	<peternewman@google.com>, <zide.chen@intel.com>,
	<dapeng1.mi@linux.intel.com>, <ben.horgan@arm.com>, <yu.c.chen@intel.com>,
	<jason.zeng@intel.com>, <linux-kselftest@vger.kernel.org>, LKML
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <cover.1773432891.git.reinette.chatre@intel.com>
 <d4e13dec81de69c7ab08638d3f928b7d4ee2b1ac.1773432891.git.reinette.chatre@intel.com>
 <afefcfb5-3f6a-6d6d-976e-c10dcaa61abb@linux.intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <afefcfb5-3f6a-6d6d-976e-c10dcaa61abb@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR04CA0247.namprd04.prod.outlook.com
 (2603:10b6:303:88::12) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CYXPR11MB8711:EE_
X-MS-Office365-Filtering-Correlation-Id: 609a3a0a-a763-4b3f-d2d3-08de8c57e11c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: Kwysq3ioXcuS8t2051wOOKvPaQEeg7R/hTdzimDSDl8CMbDLcqkNFzH8pjdFjZg2WKbVdL0T29c5p0B5Dms9Y/WGlZixEuso/Nhsi3mfeTiAKXa3WJvn/YMZL7InP7J+0HqO9ch6IGOLvPmusZ8RFmmotWVvZCQwgem5deNVFSaL4OERxDgF0ahSEySA5uRNc40uwCpN5AcsgZdt0eX30qbDOCevOCwL1RxMpbfcuUZEj2Pq3kOWrPkg7GxFn497AfCP1SEbbfwtClIisWx8jJu9eGGu8vvpI3q80fghI2Gk29BdvNrInhSKh1GMPgwky7jHkCm/xa+wn9Ztm3sDV5PFGaAthZ/jY4W5aPshPDlQ6azP7wXgpL2kIarnrOG/Up27GeAXI+JIZZwkobXAXL4LP03TemfJzrr3Kx9mgYv6farnmEX22v3ZipThx9rBY7yEQVP8mmVv5zBqmjsfhf33rLAtKgEUZjPmnCB/WPNDWpvdiFyKVAM+YrH/wTaF4SfbDQRoyVtGPsG+hIV9xh/sJWF17tZAbyZvRFtMcFQv7/DDD+fRYPquWM5/D8f+8qmqieMrxnsk4Chcd24NpDqa0uguBgMGcaXnuEr1QxZSeBAG4+8c7iZ4fiZPtzli2KxyGs96lal1+lweSqfxKt0/PTPPBs+3MA0XC3mq0FUxLKodq4wIiqqRA2dJZxU/2cYVrs/jhlG8g8618k2z/FIUOVA52AjU0O0640SWqVc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?azBLWXN2bXF1QUVBWVBLRXFqendOek9UVnlsTHAzMnI1RmQ5N29DN25mcUIx?=
 =?utf-8?B?QjNIaU5PZWVyNVVtb0ZkR1QyL1BySjU4clp4elNQeS95WWlxMk9uRlZlZTF5?=
 =?utf-8?B?NTk5dWJxTFNFNklaQ2VNeW9Ic2tDZkJ5UUFuYlZhWjBVdE9McWJ5WWJnVWE3?=
 =?utf-8?B?VlJSVzJXc0VNZE01V2d4Q1ZaODFqbWovLzdxWUc5N3NOSkNDelFlVzdjdnVH?=
 =?utf-8?B?dkRYOGpJY2thcXZLa2hRSmRFK3dlaXE1SlJnM1hDbUZ5QlVaY3ZnbkJveUhl?=
 =?utf-8?B?K3FKKzREMDBOdlR5TGZJUUxsNGdKUXZ1b24wdGlES1VoTzVVc1hMZ2NUZXlD?=
 =?utf-8?B?WHhGRXZaT0g4WkVsRTUxeDhZUWtSMnpNbk82UkdxTzFsblpXZU9ITXI5Vmk2?=
 =?utf-8?B?SytpaGlMc0dPTUdKRFpOYzdtZzR5QjEyWE9YMStaNUZDYVhWV2duV0xBVkUv?=
 =?utf-8?B?NW5tUzVuQmE5N3U1dXlZTFZhVmt5eW9jaHpIb2hubFl3SmJTSjM0WjU4OGhC?=
 =?utf-8?B?anRydFVpTEV5RlZjVldkQVpkd3ZSMUt3Y1RwWmhtRXl1WmlMSVlJWjlZZlF2?=
 =?utf-8?B?RndvaXFZYUVmSG1RY3QzNSsvd3lkeU54Slpmb0tFdDZJemFjUFJpd1p4YjYw?=
 =?utf-8?B?SWx2ZXV3OUt1VGZSVGxXTitPVVhPYUIzZXRyTHN3VTRXaWJMM1dDditpbjR4?=
 =?utf-8?B?eVJ4SzFzYmU2TGtTTk91alRrYmVmbWpseDhGaXpkWUg0Z2RuSDY1cmJVSi9h?=
 =?utf-8?B?dVF4SlJjMVJrWGM3WUVmelJ2b1MwQkZQaGhteVRaMkQyYVoycDVnY0hJS25R?=
 =?utf-8?B?MlJxN25WMkdjaU15d2ttcFNtU3FYS0V4ZksxTGhWNE16eUFUckVPM3B2QTNJ?=
 =?utf-8?B?UmJsYUpjL1FkTFpaZ3ZLczRVT01uN0t2UWd0aXdiVlgzMkRUY3lxWE1KK0Fq?=
 =?utf-8?B?NjNWZU1ialdPQ3BON2ZhL3BseGNlUjU2cXNqcmlycFRzVElxQ2h1YVJEcFhT?=
 =?utf-8?B?Mzl4T0xWQ0hFcE1FcHBVNW1iczBGcnlKRjJPRTdjb2gzaTRXU0hZdWNUYUN3?=
 =?utf-8?B?Q1BVMjA5bU9takpqQ0psRXNIcnBIRzA2L0lsbHhPNUoxMWFYMUNUcncvQ0Er?=
 =?utf-8?B?RnZoRmI1NDdDOWd5RktEQ0xJOG5meWMrMmFQUmY1bnhNQi85VFlxSi9jd1Z1?=
 =?utf-8?B?L1pKK0llTXhONmRmRk9YNFF3c1RZUWVEM2RHSkc5KzY2MzA2UmIvOGpzRWx6?=
 =?utf-8?B?cnVOcFE3alVobEx3OUpaSHBOaHFCTVR5bWVCNWZkampuM3pjWXBMMzk0L3JW?=
 =?utf-8?B?SVBiZlFQai9KU0NHQ0xXKzlFMHpJQm5lamJxaVRmOGZkc3BzMEIrSldMTlp5?=
 =?utf-8?B?SVFYNEJGa3k3OTlXaVhaQmRCdVR5NnVxV2NHYmhrWUtIdHhWWElZd3l0a3Jl?=
 =?utf-8?B?eGxZNTRWZlUyZ041UE9UMFBlRmx2T3ZWdXRYYlU4ZUV6T255cmpHWlpVSFhS?=
 =?utf-8?B?bzN6Rms3TG5CTUVqSzRXalNTdjdSYVA1elZSSG9yOXBtTHl1NzdvUHQyMldF?=
 =?utf-8?B?LzBkWG85b1VRQVQwbHNoRUdXYi9wSzN6Qll5bnhaalVIWFRHc2d0eDVJUjB4?=
 =?utf-8?B?RVErY0pCRE5oMzVnYUN5MVN3TitETjJ6WGRFMy9za3FtRW8yV0RjNzFPQ1Zv?=
 =?utf-8?B?UkdtQU1EZ295OUx6T1RpSC9iV0REWTlLbTg2QVlFb1JVc3lubzMzQWxob1Iz?=
 =?utf-8?B?amFLa1pieWQ1WTQvY1picm9OZUNRcVdITHdPK2pWWlJlMnRzUi9vaU1ENnF6?=
 =?utf-8?B?Q1J2aHVUUkpVRGZScTNvZzRpbS93WStYVVhTK0VLekFPVWdTWllDalY4NGpm?=
 =?utf-8?B?S0NiZGtMSEN0ckRmeGJHKzI3a2dLUTh0YWYzZGxjWk1xbFVJS08xdVYwQmxW?=
 =?utf-8?B?eGw3SFlLeGpRbXd2T1JWRjRzYUNKa1Iva05IZ0pPTExsSkY1L1crNGExQzNU?=
 =?utf-8?B?TDFlYlBrb3h6R0NKU3psUGllaGh5V2kxZ0lsVUlhU1RNMFBrMGJzMFpyWkk1?=
 =?utf-8?B?Z1lPaGpuREJHcUZIczcwdmVxOFRhTVBrbDliUkh2WHZrRlhtQVhSaDJMWG5o?=
 =?utf-8?B?MEI2emxXTFlOcXlCZDdiUDhHdkF2S216dnlvUm5GY1cwb2VwaGRqVHJIbDdN?=
 =?utf-8?B?SWYrRWFrN3IvUmlBZVdVanBtbVYxMHM1ZklQY2lnRE1OTHBCdVVQVVMvOHdS?=
 =?utf-8?B?UXFvZGw0M1ZFajc4OEE0WS85TkZQNDByM0F0L2RkZDRDSkJxYXJON1NoZFg5?=
 =?utf-8?B?V0VCTFgyT0RjTDBtWjN0d05XOW53a1FjVy9MY1NuSEpjUWJEdCtpTDZUMmcv?=
 =?utf-8?Q?l9HeeDhabI1p8+Eg=3D?=
X-Exchange-RoutingPolicyChecked: i9d8g7Z54flWRA+qeyEz8gUAUaIiW59cY5S3GEaUPSQZ/mL4hLGhOUnNXiC+bo9AB5VvN40z9yeCCazfYRjNPmRM8VoyGuYQAMWpSTeY26jPkP7ilty76RAI//eitvvIMLM3CLFNMFe9pLZbe/LOuFPL0F2XtB1caAJjtsv8/4oNF0wzcQIV8w6qoCA/NXUse29y/zdF0l/2CTcAq0Bolh8s4jtixALY4iWEPrQPg/PsywjaI7OJZqzERDgHqAeLk9SiyXZNMaJ7CtG5l/Zzu5nHqg2aZuTZN3pfOUWgHNtuE2TCDmhmF0v2/wVlCIiBf53/EtrjZi7/L68EdyiN4A==
X-MS-Exchange-CrossTenant-Network-Message-Id: 609a3a0a-a763-4b3f-d2d3-08de8c57e11c
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2026 23:23:40.0824
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tbH/qhBLrlaNQa4hYGuRAdkIYvEThuCFPcXcuCRSWsCSqSiXYSFArWHnqFJou/FoU9sYVtA3USv9d6Q9ezMKw+t7l47Pvbqac9RuA5LpMvs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR11MB8711
X-OriginatorOrg: intel.com

Hi Ilpo,

On 3/27/26 10:49 AM, Ilpo Järvinen wrote:
> On Fri, 13 Mar 2026, Reinette Chatre wrote:
> 
>> The L3 CAT test loads a buffer into cache that is proportional to the L3
>> size allocated for the workload and measures cache misses when accessing
>> the buffer as a test of L3 occupancy. When loading the buffer it can be
>> assumed that a portion of the buffer will be loaded into the L2 cache and
>> depending on cache design may not be present in L3. It is thus possible
>> for data to not be in L3 but also not trigger an L3 cache miss when
>> accessed.
>>
>> Reduce impact of L2 on the L3 CAT test by, if L2 allocation is supported,
>> minimizing the portion of L2 that the workload can allocate into. This
>> encourages most of buffer to be loaded into L3 and support better
>> comparison between buffer size, cache portion, and cache misses when
>> accessing the buffer.
>>
>> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
>> Tested-by: Chen Yu <yu.c.chen@intel.com>
>> ---
>> Changes since v2:
>> - Add Chen Yu's tag.
>> ---
>>  tools/testing/selftests/resctrl/cat_test.c | 4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/tools/testing/selftests/resctrl/cat_test.c b/tools/testing/selftests/resctrl/cat_test.c
>> index 6aac03147d41..371a2f26dc47 100644
>> --- a/tools/testing/selftests/resctrl/cat_test.c
>> +++ b/tools/testing/selftests/resctrl/cat_test.c
>> @@ -157,6 +157,10 @@ static int cat_test(const struct resctrl_test *test,
>>  	if (ret)
>>  		goto reset_affinity;
>>  
>> +	ret = minimize_l2_occupancy(test, uparams, param);
>> +	if (ret)
>> +		goto reset_affinity;
>> +
>>  	perf_event_attr_initialize(&pea, PERF_COUNT_HW_CACHE_MISSES);
>>  	pe_fd = perf_open(&pea, bm_pid, uparams->cpu);
>>  	if (pe_fd < 0) {
>>
> 
> Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
> 

Thank you very much for this and all the other reviews. Much appreciated.

Reinette

