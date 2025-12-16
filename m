Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73FA130EF89
	for <patches@lists.linux.dev>; Tue, 16 Dec 2025 21:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765921601; cv=fail; b=ormz+WSZOB6O63H5kYRQfRZc7t0Mr/rLs5KWchn+y+b3O2mIPrsUMuDzVyoYaBZfDRQGXxPKkfi6aW5SvoqspvmOHEXUG4smg693vJoq3JdctaagEsxXE7+laBvqp556vjqE1SMGr0HeoL8D4eWjNh9nuwHr2IJjaakNYr/W9T8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765921601; c=relaxed/simple;
	bh=cUlnwisCjmGVjNuakEB28T+na31HGBSI82qoMEq3vmA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ZLwncojnx7ZQUqE8WJ9+tRbfsiLXXeSZrKridvr0ArDOqdxnv88Pj7rSPOVMxmi6OIgXg6Os6wQjq4tVueQZee4peUEr/PmiVKy4TKZfP2O50wekj7cHEbBV1m6s58xEmDZjvzyOrloEXI/XAMmeSauuTEoUc+3eUgZaN8EhHNI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hLnGa7hw; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hLnGa7hw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765921598; x=1797457598;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=cUlnwisCjmGVjNuakEB28T+na31HGBSI82qoMEq3vmA=;
  b=hLnGa7hwp/8KaxWYnimqdhiLhqTaNSs0AOOnU7OSLwST3L/+gsnpLzwf
   HZMWIEZNrkisxTEAexWyRSeTa2Xj9NaS+pQXHObzm51nxEIZP2ui53yNv
   CwDegzaHfb6sA8EVy4++OrDEdDGDUrtmTrw48AhvujlMrsj2Dzukknltd
   W6SD2Rkea5/9FYvsBBJFaWECev0I8U7UcQtWrrOoX3nyi/DkNP/mpT+jm
   bDRmSy0NXtKql5C1J9L4ffJO8SjQQSapCuwE0UHAxbYcr8E1uqg5j9/RB
   AmuXLTZhN/Vu9R19RBJE0EbKKI9+7kiLd+/N+9FRaQyP99TFStPLC8y4l
   A==;
X-CSE-ConnectionGUID: o1TF1BNHSiufljivqkRJmg==
X-CSE-MsgGUID: gVr9M+GhR+GJnJ0NhnNeDA==
X-IronPort-AV: E=McAfee;i="6800,10657,11644"; a="67733791"
X-IronPort-AV: E=Sophos;i="6.21,154,1763452800"; 
   d="scan'208";a="67733791"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2025 13:46:36 -0800
X-CSE-ConnectionGUID: mDaUAEiqThmNUrcF8jDm1g==
X-CSE-MsgGUID: u9WOPEhZRmGMwoKoctrppg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,154,1763452800"; 
   d="scan'208";a="229198275"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2025 13:46:35 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 16 Dec 2025 13:46:35 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 16 Dec 2025 13:46:35 -0800
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.30) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 16 Dec 2025 13:46:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Hpcgtc94M638uEAZVa5MVdxEKqSdhXowvnuW/z9b6NgsLQrp0updlvwFAOTu+sOvVyKh003cFbOqK//UGwm/wy/SJPkV7TGJ6aRe78pm6wCteHNtCDx5gJmHzI0LJL3OHZlXDUkJPDWgJPYPJd7sScVAPKLyhU70MzHsqD1fcpgIyN+Bu651NbE9AIS0Mxt2pSJCBEl+GiIkDmd0s3JJ0cyTFI8P3iXKqDAff+c/6R4PjrIWWgBlZNXwotTTBLesfQRt2HgIFrSM6fslp64dRZpKfbZCZaaXcwLExJWr5gMXbm6tfdFydANUX56qol8447lfu2J+5aARfCvHuz6XgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y5yZ3TTT3LpgeBuqp0Vsf3ttitWAxBg3GGqsodf5WFU=;
 b=GDzrljrR1Py1c+hlcsot8Gs2kSN9maWeBkqYF1FgNFXwKISxUa3URl/GIH1iTllWYjH7FM8HcC4190Dy/FhGjUGTVqUA6d+D++8p1zep5f82pGgDzcjj/ZqyvAyY9W7cf6s60HL/3hFBoRxEZt4bbKeVISqf4Q5y0wp65E3ixjMWJD7QW2QJ3xCvnr8vrPyePwEwtVBi8aNPW6xzRbQmsc7mdQgqp9My2bnqSfTfORWyl8D6Lsrn3KzGzRzA1pk89YJp+hkt30smgWjPqW1Eluyo/IfrhO+03YT+XHbErcroE+b4TSIggamKRIvON9+5ZHF3tGcG4OKBZ/6P9gHCSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CH3PR11MB7389.namprd11.prod.outlook.com (2603:10b6:610:14d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Tue, 16 Dec
 2025 21:46:20 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9434.001; Tue, 16 Dec 2025
 21:46:20 +0000
Message-ID: <16346440-44de-40bb-b7f5-c99b3f6c2620@intel.com>
Date: Tue, 16 Dec 2025 13:46:18 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 11/32] x86,fs/resctrl: Handle events that can be read
 from any CPU
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251210231413.59102-1-tony.luck@intel.com>
 <20251210231413.59102-12-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20251210231413.59102-12-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0184.namprd03.prod.outlook.com
 (2603:10b6:303:b8::9) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CH3PR11MB7389:EE_
X-MS-Office365-Filtering-Correlation-Id: b4b57a24-c869-401c-c0f9-08de3cec8c8b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?RksyekEyU3huaHAyV0ZyYU1KQ1FHczZ6ZnVhZU9jUk5hV1kyZm11K2FucENm?=
 =?utf-8?B?ditFdGRIbTZKTGNMcmJ6a0pEemM2dlFrM2FFdURzRDk2eWsxT0JEcm9QcDNP?=
 =?utf-8?B?RkVpS1VrQVhQVFZOa0J5Z1NRTFVqYTYrZGFTOHl2eDVDQVhoaHZuRzRuV1F1?=
 =?utf-8?B?R1BJam42U1ZIaGJyYWYySis5WjgwV2ZQQUFVa1BWQVg3aEFGU0RZT29USVRG?=
 =?utf-8?B?dGZRcDZZN3h4eWw1Zk9ob2hHVEVkMVBIaDNHbzJNRFZlcWxUdmRYUG14STRQ?=
 =?utf-8?B?Q3NQRFJQSTRBWVhwMHE3eE93NTArYVpnRWJ5R2hEM2k0d0xLejI4Zlo0MkRL?=
 =?utf-8?B?d2dhdmQyWE5JOUdZay9odEUxVHJ0Zkc5MUFSWWVmUjYwZU5Bck5JdWhPN21F?=
 =?utf-8?B?V25KMjVEUDRvTzZLcW0rdC9oenVOYkU2U2hwb0VwbDVaVkpqSFY4c3BzTGkz?=
 =?utf-8?B?a1h4WGtoSDVRN1NydnBTSFdpdmEycnVkWmFwYm53aC9Dak90blYrYVJyV0Z2?=
 =?utf-8?B?MXZKbTlmNW5Ea202Q1NpUkdPaEcvOUdUdk11dHVRZTIvcFNxbXNvNWVPOGRx?=
 =?utf-8?B?VTZSeFpMUkRiWDhoREdKeTZCNU53WjNVR1kybEZVRjBMN0U2bkZmcS9ZN2RI?=
 =?utf-8?B?NlJlOTl5eEJUV2FndmtkRHRBb3kxOGg1TVJwT1poczJFajlnbUhXU29xWDkz?=
 =?utf-8?B?dXEvemtjVU8xNHlJbUphTU5nNVl4VThGRDV5cGF4WWdOSnpnR2JXb0F0VzVH?=
 =?utf-8?B?eHJvWTR0eXZ2SjlpUFFJbnhZYzZLUUxtVXNES3cwZmpNVmpUbFdwRHU4TnpL?=
 =?utf-8?B?ODFXTVRQa3BkSjBWc3VKVVVCQVJEdTNNUVBEMGhZOUwxZndzN2IwcTVBdHV3?=
 =?utf-8?B?Um9RYWNEdHRWV0ZCQStqaGdUUGV0S2ptR3NIZDZWMG1wTTBsZGpyTHpFVzFW?=
 =?utf-8?B?M3hsaG1jYm1sTVpNQzNHMk5FMytRWmdvMEY5VDNtbUE4TTRIa2s3Uk1HcFo3?=
 =?utf-8?B?bDIvSnNkRkl6VmErM09PSkxMK0pKWHNXWUlIa2lwZ3ZqQ0J3WW01ekhIaVQv?=
 =?utf-8?B?NUdnVVlnU2tOSmxJcmpuWnVYbEErV3FtUGhpU1ZmR2Fudzl2aGVGRFNtbDAr?=
 =?utf-8?B?UEE1aGR3UmxDcTYyaGR1R1IwVW1mdjB5ZVVRcC9EWnVtckltWDFyL3ZrVTBO?=
 =?utf-8?B?TVNkWCtycEpKUkpNOFFNSTJlQ0M5bW8xMTRYOHNIVW5BL1VWSkU2V0t4dFJx?=
 =?utf-8?B?K1picTFmRThCenpkcEJEYTF3U2R3Y1FRdUMrYmhmMnVnSlVOWFJzQWNMa1l5?=
 =?utf-8?B?djR2TnQybnM4bmVsSVdxRVZnZGVtdjRjVVFpYlBRZlNvS0VFRSs5SzJxdHJK?=
 =?utf-8?B?TEhUbWxCL3BselptRHVrdGlndEllMmdhWXRrdWlpNkVuSFZhM1NPL1BzMFB3?=
 =?utf-8?B?VktVVWx2NkR0emFvNFpyU1Awa21SbHU5TWZrZ2ZaWUxIcXJPM2JlanZiUWlH?=
 =?utf-8?B?dlZ5d3BoRnJRNXd1cWQwZXdyN29IWlAzb2Y0YmsrS21sbEd3Q1FzQWNvbnpM?=
 =?utf-8?B?YXRCdGJrY3c2WHZ3Z0doU1FDamdNQVlXUjd2SUJYQTFNUEgzZ1dPOU03OWZq?=
 =?utf-8?B?WER4bGtRRlVQRzRzVmk1Sitad1Nod0hzdjByMXR3L3BRZmRvYWpsdURMbTF3?=
 =?utf-8?B?aGpCY1U3b0JWb2ppZ09rUllvMHlmME9SNWdJc0dpU1pBWTRCOVd5NHVudjF1?=
 =?utf-8?B?MWEyVlRxSXlLeGtGYUx2Z1FWakJNdCtJWTNPN2xvR1Y3bEZMcVhLaUtRMHBQ?=
 =?utf-8?B?cWZWRkdBN1hVclAyM251TEFFVWhKN1o0ZGt3Ulc5UHl4Um1jS09tZW5IY3Yx?=
 =?utf-8?B?UUg1U2k1WnQ4bE8yb2thQ3V3TEdPM09SQnMzbm5BMGtMMmhqbnJTZk9YRWR0?=
 =?utf-8?Q?SlH9WBj8C0enExlOhGCPhhU+kFiA7bj8?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WXE3eUhHTGx0eTUxcWhoSnFkc0lxY2ZDcUw0VmRnUHNCT1JEc3hnc1k5ai91?=
 =?utf-8?B?NWJJQWZSaS84dkRoQkdzZWpBcnA2cHVGZHpDRkRzL0lQOUxQNFNPZmVFZXZw?=
 =?utf-8?B?UUNFZXY3b3BpTHp5Wm1CS09ydGkvMnJQRlZaVzdzOGp5cnNIRlNEdm81bHFI?=
 =?utf-8?B?RFQ3S012WGYxdkp3WEQxNHNwUGltL0xXOUZ3R1ZOSk1GenZzZUNPL1Zua2w3?=
 =?utf-8?B?YVJDVDZ3eGNHUk9YYUJWcm15RGU0M2pzbHhyVXhMNnpjSE9YdXZFMEpCa3dv?=
 =?utf-8?B?TGJ2eDZNV0xTN29WNitHZ0p0ZWRIaHFrM0NENlpzSVgxRXM4UGJGT2V0aHpn?=
 =?utf-8?B?enFXUGZCR09rcVJ5MDZTYWJsaDZxTUxyWTAreCt5OTZPS2xLOXZkVi9HVnBY?=
 =?utf-8?B?QXFDbWxFZUk1WlJZUTRvTHB3Sk9PczZ5NGFsK0VZc1o1a2tpbUlOVytQZDIr?=
 =?utf-8?B?enQxdFpFeTg3TjYrMjM2MG1BekJJNm1jY1B4RVhXT0t4b2R6NzFBdXk1SExW?=
 =?utf-8?B?RWNsUHdLblBINHpzMlg5T1IwelFpQS8vM0RuUnNUaGNnWDZWTU1FbXUrL1ox?=
 =?utf-8?B?Tk9NSUovUzNjRGNYQm92UVhLaXRYMlYxc2dhYVlrZTRWakR0WGRjVzFTSEd6?=
 =?utf-8?B?NC93L0Y4cG9Tdlk2WXNlL0VhbHlXVnpxeXB4MWlRWHFVUHIrdGd4eWdrbDFY?=
 =?utf-8?B?WFoyOTFQcFpnSDUyZGRaYmJWWmVRdDZCSjB1YjBieERsN2xVTUNtT0Z0cmQv?=
 =?utf-8?B?N09ISjlySGhwZXhrdkZBL0JndjA2QktLazFUQ2V5RXI3ODBIU3piN0NFUXF6?=
 =?utf-8?B?NG45Q05lS3ZKZWltRVp5MWVpdzVwNnorbEw4dmRJRkt4T1k4V3V4Z1BaYytv?=
 =?utf-8?B?MC96ZEs0eHJVY0MrNk1VeFBvYWtqSzc3bnVGUTNDZGpjY1BkazRvOEYrdzJV?=
 =?utf-8?B?NjZOSUh1eGt1Lzd4Rld6QUZnOHNkbGdJZ1pIUTEvOEFLaDNnbGxuQ1FBcmxS?=
 =?utf-8?B?WU9Ta0RaQ2FqTTRNa2xMWDRXWFZJV0U2R1p5SmZGWDhsby9ESE9tOXJnRFNC?=
 =?utf-8?B?R2tKeURSMGdhSEZ2N1VyTHJmSk1LVUw2eTBGQ2ZWb3VrZkp5bElCVWtsZHdH?=
 =?utf-8?B?b2xnNFNrcmp4bVJ0TU5LQmptQW8yak1UMXVzZTk2WFRPcEcrS2N5STJRVE92?=
 =?utf-8?B?Q2Y5TmkrMnQyRnNWRU1CSXRranQ5Q2RlMzltY0pxdHlsS2xraFFYb0lnRGJZ?=
 =?utf-8?B?RVJndEtoWlBSdXppTS9KN2crckhFc1Y3OEpaSThoUkhoZTB3QW5XU01FRUpN?=
 =?utf-8?B?V08zM25iZlJCdWM3ZmZINDlrY2dzWHpzVktaK2drSTNPMzJKNkJmOTdDblZL?=
 =?utf-8?B?a3Y4Yy9iTnFZSmt1NzhjYXBpSXA0b2tIdWpjSGpZMWNFcWJFVWpaaWJ0VGdr?=
 =?utf-8?B?ZXl5TUxZczNRUVV0cFljL01mbWQrYm9UalExWkl6cTNKV1RvV0tadTQxWHJ4?=
 =?utf-8?B?czBIcjY5Rko5M2xXVXZ3dHNtWnpoVFVIaVhZaDVld2M1eHhMV2RGZDhmYVdZ?=
 =?utf-8?B?QmF5Z1plcEkyTU9WcEFiTDJON0phYjliR3ZodEJkSzVNelpEUW9CYWJkOEYv?=
 =?utf-8?B?eFMwOVh0SDVVWHhPUTBCdGxJU1A5R2FEL05Gb2JYazRiUHZVcUdvM2hDemJD?=
 =?utf-8?B?Y3prS1U1SzJkTGdqUjhvRThKL1hrVWdMNjA0TTlNMXJmL203M3pDSkFHTW9k?=
 =?utf-8?B?dm9aS0lwQjgvelduZmtjNlBTNEkwc1UxK3F6aWxGZ0djMWY4R2xFZUlkZ1c2?=
 =?utf-8?B?aXJsTEZ3TS9HSUR5ekZBVFNOSDlYUHNlV3pGRXBqc3RwWU1SQkFFN2RzK1ZX?=
 =?utf-8?B?ekM0ZGtCb1ZQNGhRL0dFb0I2ZEdXaFJlWjZiMG13M1NiWDhNMkxYQnJsT1Nt?=
 =?utf-8?B?bGdEV2UrdjFjMUVZSzBubHZLZGFJaytCSUxJSDBQTVU1dGVoSm1XYjhBdmI1?=
 =?utf-8?B?MTIyUFUyN0JnUGFHdW1VajJiUDNYaHlHMjQwOXR5V0J6Q1o3cXdoNU1reDdZ?=
 =?utf-8?B?WGlMWFQ2Y2ZqeU1qWGh2azBweCtkRVhoT1FCYjdjSW9YNHhVMk1Gbk90RUpx?=
 =?utf-8?B?clVHK3J5MXpZWTFJdWJXaDV2TGhrV1Z5Zk1wd2N6SXNTZFdpU1BkcnJpZWpT?=
 =?utf-8?B?SXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b4b57a24-c869-401c-c0f9-08de3cec8c8b
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2025 21:46:20.2159
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nf+YCd0+9+rjtI03y9ofHQTOXym9llDFYj2dyc6u+KDpEAemcDAKVH6jig8s7bv5OCELd0lKY2xAyrkQB8Z8ORTk6qC/RGXil837QWqr0vg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7389
X-OriginatorOrg: intel.com

Hi Tony,

On 12/10/25 3:13 PM, Tony Luck wrote:
> resctrl assumes that monitor events can only be read from a CPU in the
> cpumask_t set of each domain.  This is true for x86 events accessed with an
> MSR interface, but may not be true for other access methods such as MMIO.
> 
> Introduce and use flag mon_evt::any_cpu, settable by architecture, that
> indicates there are no restrictions on which CPU can read that event.
> This flag is not supported by the L3 event reading that requires to be run
> on a CPU that belongs to the L3 domain of the event being read.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette

