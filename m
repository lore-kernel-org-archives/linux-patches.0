Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEDCC25A645
	for <patches@lists.linux.dev>; Fri, 25 Jul 2025 23:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753487195; cv=fail; b=NZB3YDMlBx6t+okbNKXiSF+jTNai6Y5/iZzIb3+BAoF8AD1dZoVPrLGNCpTAScGSMVWHd7txp3w+NJ78h3xo7HC1M5LNb34Pgd3XBHH4ZDaNEWICNwgZwFsR93LMyZ5CJ/JC9Mq/6CM58TrvlRJBLgPH9InCIzLrgzlkItNK7MA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753487195; c=relaxed/simple;
	bh=0//aD827oaGhb603heuHtCbBhY7adwHdDI96vMHWeQE=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HdxVZKIjSIeBLoJwU2Bk+/UyCFLWllQblLzWAABvoLJY1XK8NRVdSffgW1gHBYs8J3lsicB/ZHiYG0vhup2MeTNnUCG+hUPtXKfwQ47ZbTOdjc/bEjWPGkIcDQbU6ps+VXr9cWBvtw38Qvg0GiTp/sl6DRa8AVB/YIG/rTJtb2Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZyuQpnOZ; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZyuQpnOZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753487194; x=1785023194;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0//aD827oaGhb603heuHtCbBhY7adwHdDI96vMHWeQE=;
  b=ZyuQpnOZyFxu6gjiv0lFH6Gqs1ROrrOtLR3mcTV/Z+OTAeJniP3A1b+f
   NVHVJjfcU2/8IYLgXgCwRWdN23YJ9vseXiJQsPoXsJYdoJKl0RGZouASt
   o+ZhIT3CkBcvUzh25e6fCYkd0GMhluavX/2SaJtanVxP/o5L1p38QTpDl
   RLrWRe3fPIMz9OF0mucwRy1EptoSie3OSjdfR6niYL6MckPlOg5h3Rd8t
   tO39SEHfwa1rCXp3pTa6uxUp6132ND2APtYMm6nUVZIDNyYvj0rfdaU1i
   3Ks3pG/XPq2gK6grVFykqS1k32ibu4WxkgkBC8UjlLMayqd332YaQOSvF
   A==;
X-CSE-ConnectionGUID: MXE00xMhRcCvDb2eQYiCcw==
X-CSE-MsgGUID: NHSYXWuITAqsntPm4KAzLQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11503"; a="81269441"
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="81269441"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2025 16:46:33 -0700
X-CSE-ConnectionGUID: qiTYVWssT46uN4/Ktke71w==
X-CSE-MsgGUID: bpBxOtJERZ6co3sBioOluA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="198386456"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2025 16:46:33 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 25 Jul 2025 16:46:32 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Fri, 25 Jul 2025 16:46:32 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (40.107.102.61)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 25 Jul 2025 16:46:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jVgcrKNBNLCp3QKXHoc6f6YrBEOHN9Jdbxw9CcX8XuV+1133lbTgkV/BPIxCXNSWNRlIQcFtaACiR/r4+ILIXdX/qh+kfYa/HCuXnGxl22XxV2z5sb+6Z9Qalm4MvyjXPygsk7gCmxV19FGsqmp9wS3kazKCiIljSvBU8xYQGQbLy/Ik47MQm3UK/55PsrjpcdGVHfVafSZOek+bIe0yPMjlYZm5JBssbFfc6Q7AbpGG6oB7zGb01numrBEkCVSj2P1mXTmuyeIuVl3pwiuHY2GcfizTIvsR0Fo2i+JuRRMLoCMr2VGh3xlNjaGgwhM2zv3vACe6lduMcSlKGGmg8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EH1Ucvj8MknpnoxEXqsIwwJ/kWJ2TegJC0oZmo0zNF8=;
 b=GItVdnwjdFsL4BkKZNen1oeTCSCtKB+xCc97Knfbkpr0ta9wgM/Ev8yMPZi1BXZb0KPHzEoP2Y+gTQl2lzRbrwOeT5zbowEAx9VHyGd0CG99D6jGeYXTimAQ8qdCr9WhaDrtdn2wMnlSfvZz6lwhL/qOl/VWGxRxDW1IRyjfj9QG1VYAfJWzS10GFiAsG7bjWT3MchIPzZdqXrlsSUP84IyPRrDA0Uy+zLMop76N/sXg6VSghTWkOSN/Sj7fKGw38Ic/HJgYWAixMR9nYBnpeVhX5aABQev4gCaOE7X14LvNL/CZtJ8Ye3fqFUMeXt5GcmAr719V4vGfPvdMTsCsCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA1PR11MB6491.namprd11.prod.outlook.com (2603:10b6:208:3a5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.24; Fri, 25 Jul
 2025 23:46:02 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.8943.028; Fri, 25 Jul 2025
 23:46:02 +0000
Message-ID: <45d69983-c4fe-494b-a43c-7686db36be76@intel.com>
Date: Fri, 25 Jul 2025 16:46:00 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 23/31] x86/resctrl: Handle domain creation/deletion for
 RDT_RESOURCE_PERF_PKG
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250711235341.113933-1-tony.luck@intel.com>
 <20250711235341.113933-24-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250711235341.113933-24-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR02CA0020.namprd02.prod.outlook.com
 (2603:10b6:303:16d::26) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA1PR11MB6491:EE_
X-MS-Office365-Filtering-Correlation-Id: 95b12dd5-b516-4241-da47-08ddcbd56a12
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cWFzQ0FmU2NxNlJrQm5SaDU2WVB4M2xNQmJJUk1rbEdLWk9yVFNBY2dIT2NZ?=
 =?utf-8?B?a1lOeVJhUWZyTWFMTnVrOGZlUnFTek81dDlkK0lHb2Z3WU45VDE2a1FaaWt1?=
 =?utf-8?B?b042a3piOEd4RDBkZVhmNDRpTVJ1UStNR2ppZTlEUmF2OCsrWG04Skl1M2ZG?=
 =?utf-8?B?L0wwUjhwQ3FCRTNubW5yK1RaNTBFRHY4TmtMK3pIM3YxcGVyczB1bG50OEpS?=
 =?utf-8?B?TXV2dG9YdVBrNFpJSEdsMlczTjlzMDFMOGVPTGhQTEpMZzhwU2NUMVZoY3l4?=
 =?utf-8?B?N2ovVnplelpFbnhveWtBei8wY2NTVmNhM1VqbVNCajVBSXFIdFpmaVF6eUlB?=
 =?utf-8?B?ZGNVMU9CaU1UTWVvWE9MR09NVDJLZUdPR0JPYjVrUUkzODZRZUd1dGYyd3Rv?=
 =?utf-8?B?SXBiZFZVdElZYnF4a2VzSE5xaGpXV1hWVHl4N2d3RWFXRGtaSVZYVFpTd3Jt?=
 =?utf-8?B?UmZkNW1pUENlRi9jOHJFbCt2L1RLeDhGMERxU1JBSEZidjFCc1ZrN0xzaGlT?=
 =?utf-8?B?cGtkdzMrUmdVamFTUmUzb1A3bnkwa0tmcDMrbWJ5WktSY0ZjMTFuN0puR2xH?=
 =?utf-8?B?QWNMRnhXemJVMGV6akRlSlcySDRvNGFlV0htNXVsUTNBOEVYSk5uQVQvODJu?=
 =?utf-8?B?c253bm5PUjB2ZGZKOHN0STc3Y3E1U0w4U2hXMkR4Z3dqRkV4UXlNU0tkdWlB?=
 =?utf-8?B?M3R2aVU3Q2JITzRPSGYvdmtaVW5XY3VFTnVMVWl5a2RJamdkRnpXSVdkendD?=
 =?utf-8?B?UFQ3aUllcGtqNHd0R1EzLzF0bys1a3pGYk5XNmFDb1QwRG1uV2U2NU4yT1Vo?=
 =?utf-8?B?MGk5MzV0SUtSL0d5VDZkem43SXN3RThjZzM5aTFKN0FpLzBMdE9XSkliZUEr?=
 =?utf-8?B?MldvM2o1T3BaWXlVYk1qVmJDcjZMR3hrb241Zm5pNERSbzVVNFhPYnBYNlYz?=
 =?utf-8?B?RlcrdHJ6M2tqUEJCY1pTYjNMK2hqNkpQLzBsT1ROUGxkOENDZkg2WW55UVNw?=
 =?utf-8?B?TnA2cStBSGpqeEMrSEpHeFZFejFXUXNMYkk4QVVhOGsxK2tmY0NsTU9zcUZx?=
 =?utf-8?B?V2I0U3VPL2FMRnlqMFlRZDNmTjN1VW1YbFJtcmtSZEtHZk5USlJSbk9JRjds?=
 =?utf-8?B?LzFLOGhwUWlWN2VYcnlPSTkzWW41SEJWNUJVcjBYT2RCNXErbXZSZkY2L0th?=
 =?utf-8?B?U0xva05Kd2JuVVAxazBldlQxa3hRWlBnWWEvSzRHVm1zMVgwSDVOUm54NTFW?=
 =?utf-8?B?K2lyOUJ1ekZPTmZaMVZvODJreVJITjFvdjEyd1cxUUxGS1Nlb1hQK1JGUXdF?=
 =?utf-8?B?eWgxRjNzSkpiWmQ3VVJRK3Y1OG4xZktFcXV2Y1c0RmdIZDk3QlFacUQyT3h5?=
 =?utf-8?B?R0tSSkNVOTlFd0NSTWc5NFNJWitUNnVuS0NVcDlLeFpnNzRNa091dlhGOVFE?=
 =?utf-8?B?S1RUZTZYQ25wOCtWSzYzcFQ2c0VVYzRZOWNmcGwvQmpkNVloalFBdVhYYXN1?=
 =?utf-8?B?K05rZWd4ZVdvS2hRZWpQQnlycTJGU1VJSVp1bjNoS0MzMU5sVGJzeU01TWNH?=
 =?utf-8?B?SHBZZWM5WDhUU0F0cFgzWFdJRVFPajZKMWQxblBNVGp0RmxvY0tuWmw4THZo?=
 =?utf-8?B?Snk4amttWVdmN1B3TUVkbmt2dVZ3KzByQmlYeDFQSlNyQXFPVXVlVFZaSVF4?=
 =?utf-8?B?NjRQK2xCZlc3OHVMNld3SHVVb2J5N1FXQjFQeTRoWE9Gc3BXL1ZvY1pzdFdS?=
 =?utf-8?B?RThHSm9ja3BUUXVET0V0OGc3TitMS0J2QnBPWWJldmozTHFoR3VseVpPbG9H?=
 =?utf-8?B?UXdEcDlyOVZEWDNlVGhQVG1UdFhMUlJzTHlqVU0wK2Q1MElHcFJiRk1WdTJB?=
 =?utf-8?B?WE9lTkhMNkRsdWkxYjViMDFiTDVZSkhHZmpGQTMydGdnQnVnYm1OeUt4U0N6?=
 =?utf-8?Q?SX9qhb1XXos=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dmoyN1NHbTBwdXhiSUhUTnd4Zm42Yjd0QjRybVFRbTZaQzFTK3FPNllBTDFx?=
 =?utf-8?B?b29pSzVna2hPWW1Fc25jMkVDZVFUSExacmxVR0Q5ekdBNFFDbzQ5empSbmxt?=
 =?utf-8?B?WnVxTkMwKzR4RlA0TXZWdzlUODhvbmtod0ZRaDlBVnJTSWltbnAycEh3ZzM5?=
 =?utf-8?B?VEYvNmpLZkZWd2ZtVlVrWUtXbVByQzJLQWxMbFZnVm5tcGJxQ3hESnVzUmNN?=
 =?utf-8?B?YVEwVitqRjI3TWVma2RJSnZIcGxuSXU3M0plZ3pSSlpFcGppc1g0NXpNK1ZY?=
 =?utf-8?B?ZXJOZVc1T1k5ZlNsNnd5R3FXaktZc0c4MTJTczhKNmRnc0QvMndBYXBIQi9j?=
 =?utf-8?B?UTI2RVJDUjZ6eU1lTlJNSit4bjc1ZEJWQmc5WFpiZUEza01HWXFuaFIrNUJn?=
 =?utf-8?B?TVBYWlVoVXY5ZkE5SjNzaUY1Nm45aDd1bDBJQlh3emEwUDdUUDBqZmdzMjJE?=
 =?utf-8?B?bHVMaW1ubXBMVHdvRGsyTTVSN0lHeGwxVHBEOCt3a1d1RngxMWFhcGFtSGpM?=
 =?utf-8?B?VjY5YzB2UG1ERWUxbllWSmNqc3ZhcWtTMWhtS2dIdVZRMlRIdzVlbTNDWWNQ?=
 =?utf-8?B?bHh6MUJwcitpUVdpaFpjVlNXWmxoZXJIYTg4VG50ajJQZzZnRnFQK3ZQNmVj?=
 =?utf-8?B?aTM5aW5oY0x3MURHVFpiZzFUMWs5L1M4MnE0VmJ1QmNnUTRmMjlUTFJsOGxC?=
 =?utf-8?B?N2Q0elVERzJYcU1BSFVLNmg1d3RxeVF2S1BEZVAxTlFieUZXcGt0SkV0RVlv?=
 =?utf-8?B?dW5JTENidXZBeHBUWG5JMFR0NzI4MTcyYTR1ZXpmNWUrT3VYdGNNeUdOcE5s?=
 =?utf-8?B?WnR3dDNnUElpaFQzVCs4WDRxU0ptb2k4QWRHMHR4SWdaMUV4ZTIwSXN4b1dE?=
 =?utf-8?B?eVBOUWdNTUY1VGRsaU5SN3Z6dUQ1bUpENExyQWxCdEhJYmx4RVNwUXlGU3px?=
 =?utf-8?B?VXJZeXNxa1FrMGtqOG5FMG9NWm9LdXFtaTVxSW93ZkFnaDhMRjB0c0xJNTNB?=
 =?utf-8?B?dlFvNis5dmxxZ3FPZDkyWWNGYSsvb0tIV0MwdmhSdWhYQjJFVUEyY0pzclZD?=
 =?utf-8?B?Wk5Ja0k0NzJhR2xlRG91N3hWdkF1dlluYmRCNnVxV2M4THFYU2xKTjFHTmt3?=
 =?utf-8?B?bmdDQ2VkY3Z0bjZ5QnZobFE4WGh5c2pwZ0Y0a3lsNmhxUDBJblJ2c2VvbFNM?=
 =?utf-8?B?Z3k5RWhVY0I0YXdETnBXZE41MDdPY3ZDVERvUXBWQlZFSE5aa0FkWFR5TVpS?=
 =?utf-8?B?ZmFYRFJlMVhOdGptZzFTNFdEN0dqU0JQR09mcnhXYmMyRVAxeVhmOGwzMGZt?=
 =?utf-8?B?YzZRY3I0emJINkpJVHA2OXhzdFVPbHIzWVJZaVB5cmFJRkZ0MEJqaGU0d1o1?=
 =?utf-8?B?Yjk4T0E1MHlPUnhIZHdYRXh0Zlh6Ri9PWEJRWU02T0pKUGRTdzcvcWE0WE5V?=
 =?utf-8?B?dExWR0FlQVB1Q2JkdDlUZDQyTVlPRVQvaVdsZ2R0M01oalZPYytRalZ3YzJw?=
 =?utf-8?B?cW1taXRJZWVXTXpZWFQxNnMxeEVOL1VCQkZTaWh1Zzd3YWpNYS93TFJITU1T?=
 =?utf-8?B?RjVXemJkOGRmZk9KZThDU0EyWUdtNklNaXkrN0VQQkpZYkJkVHpkMXFSY0Yr?=
 =?utf-8?B?enExVzdrekZXb2lyZHZXVzVnUVVaUlRNV0h5QmNtblJYMGJiWXJkOUtyQTBw?=
 =?utf-8?B?S2ZQVWJFSWF6VEo5TEhFS29JaWdGdE9UMEp0a1UvRXk2aFV3aWl5N3VQU3lR?=
 =?utf-8?B?a0srTDRKQkx3bXBJdGR2RG1UbjU0aXZqL091M0t5YmFQSUdmQklmTU16akZC?=
 =?utf-8?B?RnNxV3o5cnFIekFidmN1bmNyb0hRZkk5RE9sQ2kzM2J0M1crWkdMQ2pIZGY3?=
 =?utf-8?B?dXdOTFVCdzhDQi9FVlNXdVlVcVhzdkljUk9pNUYwUGM3b1l3cFdNVERvRVlw?=
 =?utf-8?B?SU14UkxMN28xeGNoRGlNSjlEVnVoRVFESVBsTGxXYXUvN3pINlpydUpIUXZT?=
 =?utf-8?B?OTF1Tno0bWZmT3lXalFXbmxRMTRpZGVJTU1iZ3EvVzZmeXluSHZ2L1hTWi9T?=
 =?utf-8?B?alBFVGphYXRrZUk3VTJIYnJBYWQ0dzFCREdzdGNGek9BSTRxNU1aZE9yRkRN?=
 =?utf-8?B?R20xNFNYRW9yRmRCMmE2ZUVxM0liMzVpK1Q5VWY4UmtyLytRR3dkQlYzanUy?=
 =?utf-8?B?Nnc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 95b12dd5-b516-4241-da47-08ddcbd56a12
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2025 23:46:02.6075
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sMmuFsvKsyzRP0X8DQQ3pGWjzSazKyMaIxZsWOp8/Fkn2E7Y2GHy3NxmAbJh0ObAKoX1nxCWAIixtQT24WKNcifNX8QQAmSubV/UEavvf44=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6491
X-OriginatorOrg: intel.com

Hi Tony,

On 7/11/25 4:53 PM, Tony Luck wrote:
> The L3 resource has several requirements for domains. There are structures
> that hold the 64-bit values of counters, and elements to keep track of
> the overflow and limbo threads.
> 
> None of these are needed for the PERF_PKG resource. The hardware counters
> are wide enough that they do not wrap around for decades.
> 
> Define a new rdt_perf_pkg_mon_domain structure which just consists of
> the standard rdt_domain_hdr to keep track of domain id and CPU mask.

This patch does more than this. 

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/kernel/cpu/resctrl/core.c | 41 ++++++++++++++++++++++++++++++
>  1 file changed, 41 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index 63baab53821a..c954171073c7 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -547,6 +547,38 @@ static void l3_mon_domain_setup(int cpu, int id, struct rdt_resource *r, struct
>  	}
>  }
>  
> +/**
> + * struct rdt_perf_pkg_mon_domain - CPUs sharing an Intel-PMT-scoped resctrl monitor resource

What does "Intel-PMT-scoped" mean?

> + * @hdr:	common header for different domain types
> + */
> +struct rdt_perf_pkg_mon_domain {
> +	struct rdt_domain_hdr   hdr;
> +};
> +
> +static void setup_intel_aet_mon_domain(int cpu, int id, struct rdt_resource *r,
> +				       struct list_head *add_pos)

This belongs in arch/x86/kernel/cpu/resctrl/intel_aet.c?

> +{
> +	struct rdt_perf_pkg_mon_domain *d;
> +	int err;
> +
> +	d = kzalloc_node(sizeof(*d), GFP_KERNEL, cpu_to_node(cpu));
> +	if (!d)
> +		return;
> +
> +	d->hdr.id = id;
> +	d->hdr.type = RESCTRL_MON_DOMAIN;
> +	d->hdr.rid = r->rid;
> +	cpumask_set_cpu(cpu, &d->hdr.cpu_mask);
> +	list_add_tail_rcu(&d->hdr.list, add_pos);
> +
> +	err = resctrl_online_mon_domain(r, &d->hdr);
> +	if (err) {
> +		list_del_rcu(&d->hdr.list);
> +		synchronize_rcu();
> +		kfree(d);
> +	}
> +}
> +
>  static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
>  {
>  	int id = get_domain_id_from_scope(cpu, r->mon_scope);
> @@ -574,6 +606,9 @@ static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
>  	case RDT_RESOURCE_L3:
>  		l3_mon_domain_setup(cpu, id, r, add_pos);
>  		break;
> +	case RDT_RESOURCE_PERF_PKG:
> +		setup_intel_aet_mon_domain(cpu, id, r, add_pos);
> +		break;
>  	default:
>  		WARN_ON_ONCE(1);
>  	}
> @@ -670,6 +705,12 @@ static void domain_remove_cpu_mon(int cpu, struct rdt_resource *r)
>  		synchronize_rcu();
>  		l3_mon_domain_free(hw_dom);
>  		break;
> +	case RDT_RESOURCE_PERF_PKG:
> +		resctrl_offline_mon_domain(r, hdr);
> +		list_del_rcu(&hdr->list);
> +		synchronize_rcu();
> +		kfree(container_of(hdr, struct rdt_perf_pkg_mon_domain, hdr));
> +		break;
>  	default:
>  		pr_warn_once("Unknown resource rid=%d\n", r->rid);
>  		break;

Reinette
