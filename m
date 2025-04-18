Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5272D2DFA4B
	for <patches@lists.linux.dev>; Fri, 18 Apr 2025 23:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745017346; cv=fail; b=WPB2jHjWbhUgujS/HGVpzYu9TImZ1qBfKHdv1ms2fzdqo+BwCialSBShuBoPS/bKADk0fcTEBGqFp/SuF8eQlq1iMxqJ91eVLdWAc2hRdituZEHcl234mDQBGAoS/RHDVAFMNXTW3/gGMcsIEGYScEa1dJ8C/vlUTLT+qp2lPNQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745017346; c=relaxed/simple;
	bh=1Mnri/yPBuYzN1FntCjRLGjAZC8cuL6+bxwb09HF8FI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=DHe1qnxeIdAObikcsV0rrLIgSSkJ/OwQ+fiqhgkdk1jsH9ij/yPMEC4xHdmFg3rorF4MTpXkI1OAGE8BzNLX0s9Z2zFzrVQobSFcYq8AOWELGa+KstMa1lVZ72FnY2aJBtPYAtqD6HrnFHAZlic0GtfEIKjvWpt9IjBUisa9Xs4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bzuO8r1x; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bzuO8r1x"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745017344; x=1776553344;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1Mnri/yPBuYzN1FntCjRLGjAZC8cuL6+bxwb09HF8FI=;
  b=bzuO8r1xdZsoMlz5nSI7cBoalVfoPb4DoN17OpjZ2UyNi/+cJ+Ohbots
   2d5qBpQLHRYcr1/Xb0GdG0gZ4frBRh0NDSS3ISe5naVlpJjXvpBuxCbBd
   CopNpJMvH3wNjj3SHkOO3IofA9iSIOUXWRR/RKVDF7bvCOXm9P/yoR6eF
   ruVLv5iP/jjQz8MZvWYcUEdPNmsloxjeeo8TFFXC8JwKcoVJ1zwE/manT
   ZlcvHkGZoFlCTW4mKhCG9USyHYwPuVp65ghx4j7IGQb0SffVHngq7sSNP
   tPZw1UjE6Rdzr9j/IK8Er1EU9qS42QzCULfyvWUzvrNmHGE/rvkUJIowS
   w==;
X-CSE-ConnectionGUID: AEbjxZpRTAeZzCWmRcQ9Zw==
X-CSE-MsgGUID: 9wBvuntLRpGBDG5ZkkxLtw==
X-IronPort-AV: E=McAfee;i="6700,10204,11407"; a="45884085"
X-IronPort-AV: E=Sophos;i="6.15,222,1739865600"; 
   d="scan'208";a="45884085"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2025 16:02:19 -0700
X-CSE-ConnectionGUID: 0t8DUddmSgySuWj0pBHyYw==
X-CSE-MsgGUID: ypvPUgr3Szyz8HSSrb7FtA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,222,1739865600"; 
   d="scan'208";a="131203776"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2025 16:02:19 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 18 Apr 2025 16:02:18 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 18 Apr 2025 16:02:18 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 18 Apr 2025 16:02:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n+PsiZftQXzYBXSAGWtsIhY1RsoljBwt+hTsmoeIlT0oVI2DF4KcdGPagw5aYjOfW5E72OD77k6r5wdkIQuhYI4LueU69CGw8sJ7pugHbcPaMrSTVj2CahdYsufHFnEtB6GBA/9S21VHIy0vecH6bIGELYB+5m2VzGa/3Bdr9ccf5mdGYsx36R8DjxaurNHros8nX6GW4ItcjkDRx+iSW6L2XW0uOTKFIDzp8jB2ePM0W2XNyyGanCm5sGFqr01OF7H84DEUBL0YCFiYg1v/hzC83nMDlFYD5vZ9uqag30uWEVReVnDvy2uSe4oewI13XUcdhLVuto+PWZiF6ClAOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SsNY2nZTfRTxMGyKFkLYYW11QxXHUj78qh+Y00q4vbc=;
 b=PpP+CdLgd5eJQUdGots8OoYadceyEuxmlJTkWNWVvN4Cx+huoCJLtqfaY1EC8pyFmLgjEREqc+HexZ5ztk/DnUczykgV2vqyurgP16rBCQr9tiAUtV0Ftkr04YMqyEKLxZIMGAA2oQwQPXKcMbAwWaT9Zvxjq6cVDLN1GlA51IOzBjCdwPFfk+0BngrfLgi2fCQ+UFwXtVWmrZG4JTe2G2Mm6JR5/EU8CaOevzCouHTqCL97TTKZDDaOTRjSBbffzEDSEaBGrGTY5shBmgxd5yj4tP0Qi/o/JsrMtGFkMrSK+AcgwUvs7VYVY4ZbLKaPzi/iyP3a4C8GAXuOnDvxwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DM6PR11MB4723.namprd11.prod.outlook.com (2603:10b6:5:2a0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.25; Fri, 18 Apr
 2025 23:02:10 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.8632.030; Fri, 18 Apr 2025
 23:02:10 +0000
Message-ID: <4c8da281-fb6a-423a-bf8f-56c9ee45514f@intel.com>
Date: Fri, 18 Apr 2025 16:02:08 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 11/26] fs/resctrl: Add support for additional monitor
 event display formats
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>
CC: <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20250407234032.241215-1-tony.luck@intel.com>
 <20250407234032.241215-12-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250407234032.241215-12-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW2PR2101CA0002.namprd21.prod.outlook.com
 (2603:10b6:302:1::15) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DM6PR11MB4723:EE_
X-MS-Office365-Filtering-Correlation-Id: fcdfc36f-64bc-46ee-821b-08dd7ecd0c76
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?N20zZ1dMd1g4SzNsT1JubnczVFUyU25tZFBTVWdYdWtybTM0NUwxMDNUa05x?=
 =?utf-8?B?bCtXd1JOOVdsc3o5dzMyVDEvQ3AyMTF0d3B1L2g1cm9kNk5naFV5VXhvb0Qy?=
 =?utf-8?B?RTJBNW8xdkRQSTVOM3ExMlhnZ2lFMW5waXluakN6aEEvZm1WeDZYT1Qwakhn?=
 =?utf-8?B?ZUFYdEhNTDI2Z3NsNkZXSEVuVUFoZ2ZOYnRjRXZYVGNJT1EwS1VzZmw3dU81?=
 =?utf-8?B?and1ekExdUszWGorRTZqL2xhQUpoNWc0cUdZRUR6SzVTSjJ2UnVBWGdzTHJE?=
 =?utf-8?B?d1R2ZjhUVVN5ZmVyYUhoNU1oaHI0d0s3MkdrUUZrbzFiOU5XK1I2aVJLdElC?=
 =?utf-8?B?aWlsYVluZWMwaGlOaXNTL3Vyb0NySHZmcHJSNm1acUkvZTFBT0dFeXZvdHFm?=
 =?utf-8?B?QkZmMFBKc1prY2l0SHNjUlVCQTV1Y3BOQmZtOXE2TDQ3V3JzUHVldStjUkUv?=
 =?utf-8?B?RmpubkZRY0xhWHRzWnduYTRuV0cvVDRFczB2K1lVNEhWc0RhNG1waUg4Q01t?=
 =?utf-8?B?blNKelQ1L1dybXJjLzhWSi80bEwzNGF6bVk2aGpybDNlYUxCaFN6aXcvUzE5?=
 =?utf-8?B?WDJLdUNPdytMNFVuL1JzMTJneGtDS2xpdUpta2VVUmdrcG9ERWptcHJVV0Vr?=
 =?utf-8?B?akhKZU1hWEtpeHpDZzRSRC9ZNUYxVFVydnpTQlJTMmRhZThJRWFTbWptbHk1?=
 =?utf-8?B?alI0TmdodmZPK3ROS2FkdG12ci83SkIvRGJyaFhmRTlnK3MrK043UXcyMkZQ?=
 =?utf-8?B?OFpmbng3dHVEbm0wME5GL3c2S1FFRjB6WVFYSllyay92YmVOUmJjWktJdElN?=
 =?utf-8?B?QWxKQmw5ODA0OUVCc2NQajlRM3NLMnArNGN6WXpiVmVMM0F0Zng4UUdSN1RG?=
 =?utf-8?B?eTRFVUtCLzVLSU5nRlZwUjYzNlFDUlZHSDZYN0JpcHkwMnRkc2dna3dMbUNy?=
 =?utf-8?B?aFdpeUdZK0Zkdk02OHJBZWx3azhHZW1IeXVqc01uU1JDL2VYeDcrZUNSWDdu?=
 =?utf-8?B?MmNPK0locGlTVytVd0hSc1NiajNGdDNVMGhlMEdId0wzcjd3TWNaUmJScWVr?=
 =?utf-8?B?MnJMSDFlQ3VlMWUxZUVZekhma3ZIWWVnSlBNUng0Z2tTVXQzWkNSV01HQzE3?=
 =?utf-8?B?a1NjbVdWZW5WbmlNRFc4bGp3WnpYQ0tLMEdrYUE3NGZkZjZ2a25uQzBlTG1w?=
 =?utf-8?B?MW1kVGFtaDdhSjdiQnAvQVgyLytlS3BlbEhOSzloSlV3c2tVdUkrM1gxVFJ0?=
 =?utf-8?B?U3pTNVY0eDhDYkU1S2RBZzY2VjNPMmlGaVpIcnJEd0EvRjZaaGo4Y1hBZmFF?=
 =?utf-8?B?cG4xMFgrcmg5YTFNdmhGcGJuYnpDQ1pSREpRTm1xd01CdGw0VC9KN2lEMEFk?=
 =?utf-8?B?VlYxai9EZjFwM2hLeExWMmh4WE5pejlWNkZBaFFKS2NLQmt6SUVZZmY1bUN0?=
 =?utf-8?B?UW0wMzNIamJKMDd3M2hRUENjcXZ0OEtjcG94V2gvbkdaV0VXaitTZll0NTZv?=
 =?utf-8?B?Z3k5aytPVnd5SlRnWHkwQTNNZHZ3MXNBY0RnT2VPWEdKd2VjTlJYTzdVQ2lo?=
 =?utf-8?B?Z2VOdndxWGlRTENQSDVoUjdobDVhbWp5UmJ0dTM5c2VYYVVCQWtDVjhUc3ov?=
 =?utf-8?B?MmkwSkNEOS9IMUdUZnoxcmFUM2hYaEtGY2xwZk0rQ2tUdjg3c2liWXUvZDJh?=
 =?utf-8?B?T0VOR2RFMTh3M1pES2pUVyszM2NVQm15WkJ5VVczMjVuSnlzNmZtOEhsN0Z5?=
 =?utf-8?B?NmRPYUZiZWNjQ08xUXcrQWdIVkRtWUJFcThnTTQ0K1FQeHN1ekpjU1BaSDhx?=
 =?utf-8?B?ZGFHT1R3YVROK1VnVmJCdEdVejdIYWFOS3hTdUVzMGZLN2ZQenJEV2pyNjNY?=
 =?utf-8?B?MElXelhyenRwdmgyZHVlSVhpb05QUGU2S0tCWkswTzFpUlE9PQ==?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VnZSSHJ5bWJ1TEdZd0hrM0VLZHY0ZEtieDNqOTJMcElLVW5HdWsxcXBWSk41?=
 =?utf-8?B?RTNvYjdleEU3SHJEdjRsSFFVUzhOMFlXaC9HWlYweFVJQmpvLzdEK1pyMjRL?=
 =?utf-8?B?TmhKR3VDTDJHNjBnb0owMER4blEzQ2FjTm1DWU5LalB6QXlZc0ZNeWpGTG1T?=
 =?utf-8?B?YXZCWTA2Qk1yWGQvUlJPL01Pc1l4cDlZbGpzRm5CMUtOUERMeWk3Y3lVbGFw?=
 =?utf-8?B?bUhKbFFRVDlOSklZc3hiOXVqMk1YeXg5Vjdjdk5BdnR3cjFvRHRtYm0wd1BX?=
 =?utf-8?B?OXdZK08xNTlsZmgydHBnbVBwUlh0b01CcVVuVW9TUU1BcHh4TkV4dEk4SjVK?=
 =?utf-8?B?SnBUSFIwVFQwVlZxQllsNFZYb3QzWE16d29FQUNqdmpsZGJVcklWZlRGZlJY?=
 =?utf-8?B?NW9vcjdHS1YxUGRBWHZuN2xsR29odUdmUlFNL0tQbkZMa3luS1BmYUVuVjNs?=
 =?utf-8?B?S3ljbEdOdzc1M2xjeXpUaFdxZ3liRHVqN3c4dHVtNWc2a003NTRDS2J5eUV4?=
 =?utf-8?B?WFZaUFd5VmZGQmowbStyYWZBNi9wd2xGU0FhbDV2Mkl1RmVZTWExVWVKYk5Z?=
 =?utf-8?B?TzlUVk9DbHF2dE5kNnpheUdlMjRZVnFWUVBpclNRNzNoa2R5dDMyWXVyakd4?=
 =?utf-8?B?L1c0OFFURzN5VTFMQks1U0JPS1JnSlEwZHVzMmJ6R0I0SENNUktSWEJKWWk0?=
 =?utf-8?B?SXVGbTNUajBGYks1VlUxY1pZaHdVZURhcWZJYzJ0aW1lcStZZDMrdXZFdWR0?=
 =?utf-8?B?elVzQStTWHdoWkx6S2hZcG1xM010SGlmTzNSY3B5QnExcDlWdE82TlJaa2pE?=
 =?utf-8?B?Y3FJYktYR3M0d1FFckJFNkZuWG83MkwveHlTMnVxUU9mc0Zra3BsOVZHblFY?=
 =?utf-8?B?bUFHaUdQSDdSNGRWeTJyVWZhalkybzFWNFVUVjRkQVcwc21tNkNEUzNYVUM0?=
 =?utf-8?B?aGlYMXlDMkoxb2dVMGpvNnVmaEN0UHZXUkJUNjhHZTRYd2tydmQ0cFRtYmgx?=
 =?utf-8?B?NE41Wm94aE9KdlpWZWRhQng0YXFvNGJFZ2NocHg1RDcrMVNZUnZEY0pmQVNK?=
 =?utf-8?B?U1NvbEJLUFdzc3l5UHBjb3FuaGpqSG54ZWhweFBMbjJDRXZwU3JYWUVRTW0w?=
 =?utf-8?B?V244WnkxTVpzQmp2SHVqb1JCVEt0eVB3Y3djRTlYNVVBQ09tODNHOURLK2lz?=
 =?utf-8?B?TlNUY3p3Y3IvTmMvdDg4eDF5MGpTd2FUcHFENHdQaU9Jc1hiWkVvaW5DTXVn?=
 =?utf-8?B?bzFObEZ6VzI0STZBcktVZEtkR05WMit4bmRjd2c1MDBoOVgrNnBUR0lPa055?=
 =?utf-8?B?eStpN3FNUkdoa2IvU2xvWU9uWSsyQ1M3KytNMTUvbElod1pDVlpNM3J0WWcv?=
 =?utf-8?B?M0xlRWpiOEU1MEZVanZjVUZsMnhiVVRaNXJWa0FPRVdHQXljSzl1WTV5TlFi?=
 =?utf-8?B?VGxDZWxBaUdPTWtZdlpQOGppbGdGeW1NbVhCMUpDUG9OZldZa1ZIOTREMWEv?=
 =?utf-8?B?b0FVUFRjemNLbVBZZXl1dUsybXBZVWkzNW51Y3ZhZGluOWpTUTJ2bWMzNzV0?=
 =?utf-8?B?ZlV3TmxJM1lWKzkwRzRwZ1pwWkJBS3BKNDZRSTg4dDZPWWwwNTFQMGx5S1Mr?=
 =?utf-8?B?NXhOSFRtdnl0ZDQ0cjVvNFY0L3l0d3F4cFhwSlg0YXNHNUhtSHUrU0VDZlU0?=
 =?utf-8?B?NGo3NEN2OHN3Qm9xNmZnV0lHZlhLelQ3ZDFXUXk0c0ZNRUh0QzVnWWUwbjBX?=
 =?utf-8?B?ZDAzU0s5L1ByQ3cvUU9tNDRrbDdPZmRTdTRBMkhYUWZQTUV6MFZrVWxGVE9j?=
 =?utf-8?B?WlpucjBXWDJOUWMzNXBucko1Sm0xYUtOeEtMcFBMcSsrRnM0cCtIUnI5RUZn?=
 =?utf-8?B?enJsVyt0d1F0WjJoeDJTd1dJTHNxd3VxN040SEN5QTducStFdXZwa2VBbUdG?=
 =?utf-8?B?bUpmbWx0akR3VVNuMTd4eDd0RlBFbGpOWVYyTnhFZkl4ZEM3OHVRK0xyUEdE?=
 =?utf-8?B?cDJiN3lXd0Izd0ZOUHhTeDNnUDU2ZWNFL1UwZFhxQldNcTgxbTNQN3MrYy9T?=
 =?utf-8?B?bVhrdEJULzVZa2d3d3A5YytPMGU5WjRKRWFISFF6NjdxYWt6R2V0N295L0hW?=
 =?utf-8?B?a0ZuaHZpRW1NM0dnamFFNGNTRm1QdDZaWHJHc1hGaUtLc1pKVXI0NzJacVhs?=
 =?utf-8?B?VWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fcdfc36f-64bc-46ee-821b-08dd7ecd0c76
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2025 23:02:10.0101
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gWXjd3eDpxxg1f2P2j+CAHjDjG60V6U0hE3lzPGAsqscf/GAk4dUlXwhlwNF6zyWEbRhr/oF+Q51+gPnDFuh1o3ktGIUBsk0GGwG+t6BKhI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4723
X-OriginatorOrg: intel.com

Hi Tony,

Please add context.

On 4/7/25 4:40 PM, Tony Luck wrote:
> Add a type field to both the mon_evt and mon_data structures.

This is getting too much? How about mon_data pointing to mon_evt?

> 
> Legacy monitor events are still all displayed as an unsigned decimal
> 64-bit integer.
> 
> Add an additional format of fixed-point with 18 binary places displayed
> as a floating point value with six decimal places.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  include/linux/resctrl_types.h |  8 ++++++++
>  fs/resctrl/internal.h         |  4 ++++
>  fs/resctrl/ctrlmondata.c      | 23 ++++++++++++++++++++++-
>  fs/resctrl/monitor.c          |  3 +++
>  fs/resctrl/rdtgroup.c         |  1 +
>  5 files changed, 38 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/resctrl_types.h b/include/linux/resctrl_types.h
> index 898068a99ef7..fbd4b55c41aa 100644
> --- a/include/linux/resctrl_types.h
> +++ b/include/linux/resctrl_types.h

Why is this exposed to architecture? There are no users in arch code.
changelog gives no hints on how to interpret this.

> @@ -58,6 +58,14 @@ enum resctrl_event_id {
>  #define QOS_NUM_MBM_EVENTS	(QOS_L3_MBM_LOCAL_EVENT_ID - QOS_L3_MBM_TOTAL_EVENT_ID + 1)
>  #define MBM_EVENT_IDX(evt)	((evt) - QOS_L3_MBM_TOTAL_EVENT_ID)
>  
> +/*
> + * Event value display types

How about "Event value display formats"?

> + */
> +enum resctrl_event_type {

resctrl_event_format/resctrl_event_fmt?

> +	EVT_TYPE_U64,

EVT_FMT_U64/EVT_FORMAT_U64?

> +	EVT_TYPE_U46_18,
> +};
> +
>  static inline bool resctrl_is_mbm_event(int e)
>  {
>  	return (e >= QOS_L3_MBM_TOTAL_EVENT_ID &&
> diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
> index 74a77794364d..4a840e683e96 100644
> --- a/fs/resctrl/internal.h
> +++ b/fs/resctrl/internal.h
> @@ -71,6 +71,7 @@ static inline struct rdt_fs_context *rdt_fc2context(struct fs_context *fc)
>   * struct mon_evt - Entry in the event list of a resource
>   * @evtid:		event id
>   * @name:		name of the event
> + * @type:		format for display to user
>   * @configurable:	true if the event is configurable
>   * @any_cpu:		true if this event can be read from any CPU
>   * @list:		entry in &rdt_resource->evt_list
> @@ -79,6 +80,7 @@ struct mon_evt {
>  	enum resctrl_event_id	evtid;
>  	enum resctrl_res_level	rid;
>  	char			*name;
> +	enum resctrl_event_type	type;
>  	bool			configurable;
>  	bool			any_cpu;
>  	struct list_head	list;
> @@ -89,6 +91,7 @@ struct mon_evt {
>   * @list:            List of all allocated structures.
>   * @rid:             Resource id associated with the event file.
>   * @evtid:           Event id associated with the event file.
> + * @type:            Format for display to user
>   * @sum:             Set when event must be summed across multiple
>   *                   domains.
>   * @domid:           When @sum is zero this is the domain to which
> @@ -104,6 +107,7 @@ struct mon_data {
>  	struct list_head list;
>  	unsigned int rid;
>  	enum resctrl_event_id evtid;
> +	enum resctrl_event_type type;
>  	unsigned int sum;
>  	unsigned int domid;
>  	bool any_cpu;
> diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
> index cd77960657f0..5ea8113c96ac 100644
> --- a/fs/resctrl/ctrlmondata.c
> +++ b/fs/resctrl/ctrlmondata.c
> @@ -562,6 +562,27 @@ void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
>  	resctrl_arch_mon_ctx_free(r, evtid, rr->arch_mon_ctx);
>  }
>  
> +#define NUM_FRAC_BITS	18
> +#define FRAC_MASK	GENMASK(NUM_FRAC_BITS - 1, 0)
> +
> +static void show_value(struct seq_file *m, enum resctrl_event_type type, u64 val)

show_value() is a bit vague ... print_event_value() ?

> +{
> +	u64 frac;
> +
> +	switch (type) {
> +	case EVT_TYPE_U64:
> +		seq_printf(m, "%llu\n", val);
> +		break;
> +	case EVT_TYPE_U46_18:
> +		frac = val & FRAC_MASK;
> +		frac = frac * 1000000;
> +		frac += 1ul << (NUM_FRAC_BITS - 1);

Could you please help me understand why above line is needed? Seems like
shift below will just undo it?

> +		frac >>= NUM_FRAC_BITS;
> +		seq_printf(m, "%llu.%06llu\n", val >> NUM_FRAC_BITS, frac);
> +		break;
> +	}
> +}
> +
>  int rdtgroup_mondata_show(struct seq_file *m, void *arg)
>  {
>  	struct kernfs_open_file *of = m->private;
> @@ -633,7 +654,7 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
>  	else if (rr.err == -EINVAL)
>  		seq_puts(m, "Unavailable\n");
>  	else
> -		seq_printf(m, "%llu\n", rr.val);
> +		show_value(m, md->type, rr.val);
>  
>  out:
>  	rdtgroup_kn_unlock(of->kn);
> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
> index 1cf0b085e07a..1efad57d1d85 100644
> --- a/fs/resctrl/monitor.c
> +++ b/fs/resctrl/monitor.c
> @@ -847,16 +847,19 @@ static struct mon_evt all_events[QOS_NUM_EVENTS] = {
>  		.name	= "llc_occupancy",
>  		.evtid	= QOS_L3_OCCUP_EVENT_ID,
>  		.rid	= RDT_RESOURCE_L3,
> +		.type	= EVT_TYPE_U64,
>  	},
>  	[QOS_L3_MBM_TOTAL_EVENT_ID] = {
>  		.name	= "mbm_total_bytes",
>  		.evtid	= QOS_L3_MBM_TOTAL_EVENT_ID,
>  		.rid	= RDT_RESOURCE_L3,
> +		.type	= EVT_TYPE_U64,
>  	},
>  	[QOS_L3_MBM_LOCAL_EVENT_ID] = {
>  		.name	= "mbm_local_bytes",
>  		.evtid	= QOS_L3_MBM_LOCAL_EVENT_ID,
>  		.rid	= RDT_RESOURCE_L3,
> +		.type	= EVT_TYPE_U64,
>  	},
>  };
>  
> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
> index 97c2ba8af930..bd41f7a0f416 100644
> --- a/fs/resctrl/rdtgroup.c
> +++ b/fs/resctrl/rdtgroup.c
> @@ -2927,6 +2927,7 @@ static struct mon_data *mon_get_kn_priv(int rid, int domid, struct mon_evt *mevt
>  	priv->sum = do_sum;
>  	priv->evtid = mevt->evtid;
>  	priv->any_cpu = mevt->any_cpu;
> +	priv->type = mevt->type;
>  	list_add_tail(&priv->list, &kn_priv_list);
>  
>  	return priv;

Reinette
