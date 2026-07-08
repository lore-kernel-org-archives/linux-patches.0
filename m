Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22D0426ED2D
	for <patches@lists.linux.dev>; Wed,  8 Jul 2026 22:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783550714; cv=fail; b=M3hJGcijL51Lrc3m+oqNPDfVX5pcyjMrS8KboEKsSqpvmYyQ+OCURM7rQdwJVyl/71eAtHIXaGFHKPSUc7BU8EjQy/uvMS4ekZMy2jsUkEkY5FlNMgm3bKAFcWEHnMXKa1owOLiSkPCMSUtIaYi1G9AiWH35Xad5GRVpaFLi134=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783550714; c=relaxed/simple;
	bh=5sxvih1XAweogDi56ScxUdfSpbPzmqEfY03fV+bx5Ds=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=DlHglytOPcBYhLdCbAelyB8NpbePZCNSAWp7NTqOghTbSTj/mASCjXiNcXSirP0zDHojXmwUG8YG3hk5ZpSB6Qw5YoSReZiY7olfkLAkQsxgHC0Cwh4UvKcZ0BuhAyueuyBpvDyNYaTGwotlUsrGoOigPHwdX2ybELzDzXidCeI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HW1HgRaN; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HW1HgRaN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783550711; x=1815086711;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5sxvih1XAweogDi56ScxUdfSpbPzmqEfY03fV+bx5Ds=;
  b=HW1HgRaNc2Wv6upNK2ifoZKkaq+TIOd+Mb/225SNuF0f+60JpIwBZkI2
   zIlsZH8kAMCHVrwE39ME8fapCEgjc1p5fuFkFfQ0aZJGIAr2EbdyWlq6T
   FdzBfp/MpmB+B6RdmMHdjQT1J7P7yFIpmH7Jwv8gGlLMvvriJa+dutXtE
   Fa7NsdrIq8VC3WI/s7zQ4k9bv1qAiwiAMfCSTBXzPgVWpAUMFD13WpeBh
   CzTL4im4oFALfRv9JmqY33etroMJGFC35yROmLaxfopY0o4r2BXUDmi9s
   luCBttAHXIkC+rUn8mwV77nsPgX5zxhCzak1OhSMBG46WA/h6sd51nspn
   w==;
X-CSE-ConnectionGUID: 4bzOIa17RWagrsd0ZBFZPQ==
X-CSE-MsgGUID: O9wh6bt+S/icu+3eWMgGZQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="87911887"
X-IronPort-AV: E=Sophos;i="6.25,153,1779174000"; 
   d="scan'208";a="87911887"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2026 15:45:11 -0700
X-CSE-ConnectionGUID: 2XW8Fe+uTK2hJ/tUhKtXgg==
X-CSE-MsgGUID: 5xI01a1iSxOXti/WeCEO6w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,153,1779174000"; 
   d="scan'208";a="252665183"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2026 15:45:11 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 8 Jul 2026 15:45:09 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Wed, 8 Jul 2026 15:45:09 -0700
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.7) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 8 Jul 2026 15:45:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r1SQ0F9iJhs10GoA20QlHJslm+0ksB8t+c+8LKnWv4M2fgSyChZEEPTCFkxtm28jou7/8DM0zjyQhROZqix9cgavOne4CATOHIuUhxdo4PX7RUXzWrJpwo5Xk+7hF8V63fwDUcd+i4eGIxC4exMD98Uxthu0QBVKoh6tteDGkjn4HQ9Lf96E3P9ejC0HsISXQ513BZbNXTuEtv1tugsnG/nzdeL0UXKTDQClTE5PUoOhf8OV/wNHPGxYvZ2HxzMNs4PMkWdmiZWQ0IBwxas50/Ya+PHgfRq6IhxQ8UoPqhuLYKtUONWFMh5eUUY1NXpIhk4aPLUxM0F6422aX8pBZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZwIo3E9q/BQwwWzXsfMqMshKUTFg6WHBGrkf6uokjRc=;
 b=wt8gQ2E8jauARTUKI+45CpBhx9qk9Elhs2h7eYO3I5ABZO78ECvzM737NEVa9bEMgCHddVOjBi1XpA8s6JvRNPZ1kjjXEkkdWJfWc1qWQdjtuOz6/X8lclovDimlMhecEoYf2Q4/OtF3EXgM5KmuNbl0hQ8GtGobBGarYQXJ42bc51R1z+IeriAWaebcXKvmZOGiQBS01HDr4LCgIlcP3CXu+5RaPtVtNPZPw3L94SAZB7huNwTo1SOvdr6yEEbTCDzvP+AzI0f8Tcdg0rdOzaL5ghtTjBH12e3vpJRlCWUXwgr1Nzpc7c/BOupPyen9CZK0Ye+M8FvkmcdCW/AIzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by IA1PR11MB7889.namprd11.prod.outlook.com (2603:10b6:208:3fe::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Wed, 8 Jul
 2026 22:45:05 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0159.018; Wed, 8 Jul 2026
 22:45:05 +0000
Message-ID: <e2a74402-791f-493e-9824-a5e4aec61b87@intel.com>
Date: Wed, 8 Jul 2026 15:45:03 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 01/12] platform/x86/intel/{pmt,vsec}: Prevent unbind
 via sysfs
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260701213553.15222-1-tony.luck@intel.com>
 <20260701213553.15222-2-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20260701213553.15222-2-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0307.namprd04.prod.outlook.com
 (2603:10b6:303:82::12) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|IA1PR11MB7889:EE_
X-MS-Office365-Filtering-Correlation-Id: 590f12c4-e1f0-4cdb-8246-08dedd428dc3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|23010399003|6133799003|4143699003|22082099003|11063799006|18002099003|56012099006|921020;
X-Microsoft-Antispam-Message-Info: t0CSNb7wHkC0RUIAMLe/mw8eQXcMoc6KswfsrSR/00rS82cUP9hF9eePjfRmcSqqOtzoGt/bngvEIxcjmHhpdGuwXBt6vXiC3fXtSwPLl71Bsg+OTHHvlYNQsgInpiKImKKAxWADTRFZEXHagD1vBW8GF03dKrJO4aLMfC42Ka2C2QFk35PkPoE81d81sYH6AItYdXpAC0/QEvGjCfK/G5fMI7RwERg4bnyRyRywqVD509eOH63yC9m27iHXBaSA8jrLjIMvI/3qsu+Q3ik93g8ZSErBgyXDD6ETiiXCvLQMScQfGW0n2wkhogQBkitTDMUV+8vjC94whAnE5acxdIgRGkthSddesgrjdy4RyI60J1KmLdOAIFhFILcZfT1144E7MN9sXKuDOWc5cyFTv+WAYAYdbTfUDgM+oVuIKLqo6KjTUVtVBgoKSnHWHzLOt2QL8oL1bTdWKcQni4eRvQVPGvStf0+HQzG+CzOlRaMOWw9svNMvDdF9xXP+lDJ2KL0w2k5Bp0U4fiUjrcKeLW0Y5hm7fp25i2nidWJJeJWh2mkIIMw28FM8q9VWBzQJ8uqXJ3dNw5qitsZ1+7d9KrPym9T/njUiJQjpVxJcB1KVGrZXmXFZYj/DmPgnGatQIKcn2HuKUClI9ax30lgWfqHrKKIp1AFLp/JT9rr07wxKPGLqlo+8PvePLxEkXuWVerVAz2njLuCrGw33tAuusg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(23010399003)(6133799003)(4143699003)(22082099003)(11063799006)(18002099003)(56012099006)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TktwbnJVYTh4QzNHaUtGOGd1RDBXY3N2MTY5M3NpbDhWUENJYUNhekRUcmRu?=
 =?utf-8?B?anhvUkRMTEVTQU5VclhhUkd6dWpSeEdFUGdGNUNxaFNyM0d0dG5ab01VMTR2?=
 =?utf-8?B?UUZzWDJOTHRXY0pmbmJIOFFEd3BOQncrWWZGdDNicldDUW1iZTkzYW5DMGJv?=
 =?utf-8?B?dzROWjNOUVdwbDE3d3dJcU1QcEpnRjR4V1ZLUWNWcEo4L1R4SmlSOFpzWXRl?=
 =?utf-8?B?eEZkVWVwN0c4T2MxbEMxM3JPYW5XeFhhbjI3S1ByMWF3TVUwQ2cyN0xVTjA5?=
 =?utf-8?B?Sit5TTZNM1Z1cjJZaEpUcUkwcmJaalFmZFEvTVdPcDR1eHdXZXJia3pIbGlM?=
 =?utf-8?B?OUthZ1A5REpaek5ncituWFF0SUZ4cFFGMHlqTUtObFlGZi8yc015Y21IWmV3?=
 =?utf-8?B?elFwRUd6cDJuT0NRbGpSL2FGdktkcGd3OFNTK09FL0UxNHd1aGlWd1JyQTBt?=
 =?utf-8?B?NUNmZkhCL2tZTDV6czVtTHVYZ3JVT0NYeTBWek15SDBsaUNtWWxYZGFFR2dz?=
 =?utf-8?B?ejRYbjQxS1VBY3pEaVlCYzdOWUo4OU92Nlhocjg1WmhzcmRKZ0JmblNzdnQ5?=
 =?utf-8?B?MFdiMndUSGhVc2xqRUJmc3NCdUpPdzQ2VWp2V204YnB2TFRMT1FYYTY2MWt1?=
 =?utf-8?B?Zk01V1Z2amVnQ1VzZmpDUHpJTDIyeEpuaEIxbndEY3UrL0IzQ2J1OWJsK2ZS?=
 =?utf-8?B?blliUUxSYStBQ21PUWZodW9CYkY5bmFDS290NUxQQVAwcVkwVVNXYXFJaWs4?=
 =?utf-8?B?MFA0MFpodDdRVFdGMWd2MXBSNTE4K2dsWllZRTNDVUQ5TWFjc2Ztb3c1Rjg1?=
 =?utf-8?B?eWswVE92U1pmMG04bDdBVWl5azVJQ1M1d1R1RzlYQm5LRytOL2EwMkhKNEJq?=
 =?utf-8?B?WFJqdzY4Z0lGQUpCUzEzV3R0WkdkMjl3R29SQVdzL0N3RS9NTmorTE51NnNi?=
 =?utf-8?B?VHlRb3BabkUvVVh2bzcwTHYrS0tkZlRtSnVIWmJhNWNHSlJmOG5oOXRsaWFI?=
 =?utf-8?B?Q0p0aEtUZ2sraTRKQVJuUm05SGpGY2FXVlA4U1U1cWlaQ0ZhWkk3bDZzQzZY?=
 =?utf-8?B?TENMaUZxK0VjaEtVeHVPZEFQTEJMcjd3dnZxTGhUY3VnVmViVHYrMlJTbXhL?=
 =?utf-8?B?QWpLRGlidWlCcUNFUkZTdVkwaUdCQkYwTW5SRmtrTVBlajZSSzMvcVdwbVc2?=
 =?utf-8?B?OUVLYlpQUlNFZjRMeFM0UjFRZVl2Q0ZydkdvZzVYbkxQRzhma3lhZ0ovRXJX?=
 =?utf-8?B?amVKbDR0TEdaWXhjNjRHM1FZV0RIU214TFR4L0VJY0JsWUJxZHpOQ05yV08r?=
 =?utf-8?B?SkRPRG1FaHo0S05qTlovdlRrSGpFMFY4eXhhcXVxL0NwcXNHYXQ1YkZmV1l3?=
 =?utf-8?B?RGNJcWhiaHpNU3pTRWc5a3hlY0gyeFRkeWoyV0FTelhCNjZjMUNJalY0VUN1?=
 =?utf-8?B?aXB1d0VlNXZrYjNpSEtNMUlubEROZFc2VzUwSFlHdWp3K1ZBSjJSNEF0QnJh?=
 =?utf-8?B?dmRpWnVCNjVQSnFORmo0ckU4SEVsSXFjaGFyZXp5NG5kRDhQUjNOcEJZNk9N?=
 =?utf-8?B?eDVDOWJJYTBtWldNWk1nMzkrbUh6RTE5ZDZoY2VRbkJQdnc5T0NHUVU2dDR0?=
 =?utf-8?B?dy8rZiszTnh4T3dydXl2dDhvZHJvTlEyMkFZMEFJTDhLd0pBRUdSWjdETHM2?=
 =?utf-8?B?cXRoM2JjMTd5YjA2Z1pQaHRDTmVrQ0VUTnlxcVBhQUFYWUJsUkpiZ204cThn?=
 =?utf-8?B?MytjTGxocUNXcjBHckZRZ1ZZV0tSRXlFaHRxMXFrMDhTemlxYzFwd1Q2TENW?=
 =?utf-8?B?czYwSUNxT1JCU1RmZFR1QVp5aXYrUjMvbTdTNU5CWStQSE5JMW5LYUJUOHgv?=
 =?utf-8?B?dFFmOHNmM3ozMDk3T2Z3YUt5TnhsMnZ2VWNvOFVxSytObVUveVJtNWFyQzBo?=
 =?utf-8?B?YUZZa3JPZHlYd2pCYTN5dnp0NWo4dm5McDFuczFkOW9YRlE5azNkeWhCSVZu?=
 =?utf-8?B?SUNUcTVaN1JaWW5XeFNvZnFSN3R2K3QwaGN0VVdXNWhhdUpXVWJjVFAvYW85?=
 =?utf-8?B?ZzVkcXBDSFpFQlpxZERrdGR4QlNMSGVNb0F6SXVnb01rTDJpUmMvUkVtNzdr?=
 =?utf-8?B?NlFvYUpOVkx1K3lLMDdibzFKOG0rbU52NmprWE93aWl4alRPcUoreTkxMEZW?=
 =?utf-8?B?SlVoV3h6UWUxcE4vYUxqemxpOVE5cXhCK1pvZE1FZlBrNnlodGRjU1hXanJM?=
 =?utf-8?B?NTBIdjBEdW50amltVnFIVlJkd2dDQ29wTm1jcytCbVJWSTZtWWp2RGJMRkN4?=
 =?utf-8?B?ZWdaY2MxQnZvWUJ2SGZOR2xSWjVvRStKOFRLdWtlUlB1TGhwV2R6NlVLYmdw?=
 =?utf-8?Q?8mWbxfGc0gxfy8O8=3D?=
X-Exchange-RoutingPolicyChecked: UxZiEyw4fHdpoQRpaxlvk2d7hR7exFrZQp4c5iTuQ7FuwxG6z7T+8qDDzYd8xO33KBRjZHzOcth6Aj9tOjmfaZ5KNn1LoLYMWEOFS5LAh/gVcHWK0b84fseoowjHOlTWn8lsP619Jkm2qbiAtL9UpMwA4E8nhrZjHcn94DpIPCaCS4JEHZssmruIgOlAmAPxzA9vpLYUPTldxjfCbbweJ91eFZsyUvJZHhVCSTkp5Aw1btju9EZ0FEs1iw4y/21ul0Tf99uyM0RVVCANR80VrcNpKs/MhTQkDzDAqck2fZxqSBAzGnPEADchr2JVausj8mUiMxkgm6SRnHBJXBH5VA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 590f12c4-e1f0-4cdb-8246-08dedd428dc3
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2026 22:45:05.1128
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fj/9TJgk9JPfzQ3qfzs9fwLJvzXKcRhWaAJ8ygxoSInm1lfcftlgbMe/9mCTE73i96m8B2MAUn0G5cQKBjtNr1bP2aITOk07r+n4gsbOoXM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7889
X-OriginatorOrg: intel.com

Hi Tony,

On 7/1/26 2:35 PM, Tony Luck wrote:
> The resctrl AET code uses intel_pmt_get_regions_by_feature() (exported by the
> pmt_telemetry module) to obtain pmt_feature_group instances that are populated
> using data from the pmt_discovery module. The returned telemetry_region::addr
> values are MMIO mappings created in the telemetry driver's probe path,
> and resctrl reads from them while a mount is active.
> 
> However, a user can unbind the intel_pmt driver or its parent intel_vsec
> from their devices via sysfs "unbind" attributes. Unbinding either of these
> drivers would tear down the MMIO mappings, leaving resctrl with stale pointers
> and causing a fault on the next access.
> 
> It is safe for the discovery driver to be unbound. It does all its work at
> initial probe time and saves a copy of the features and RMID count.
> 
> Set device_driver::suppress_bind_attrs in each driver so that the "bind"
> and "unbind" sysfs attributes are not exposed and the user cannot detach
> the driver from its devices while resctrl (or any other in-kernel consumer)
> may be using the resources.

Unbinding via sysfs does not seem to be the only way in which resources that
resctrl depend on could disappear.  The "/sys/bus/pci/devices/.../remove"
interface looks to be another way? I am not aware of a way to prevent this since
this represents how devices could just be yanked from a system. I wonder if
resctrl should instead protect itself against telemetry resources disappearing
after mount with another helper that telemetry driver can call when the device
is being removed or the module is being unloaded. When telemetry driver informs AET
that resources are going away after resctrl is mounted then resctrl/AET can return
EIO on event read attempts? resctrl could possibly recover when the device/module
re-appears but if that is complicated then user space could just be forced to remount
resctrl.

With this there is no need to prevent unbind here since it creates a false
guarantee to resctrl.

> 
> Fixes: 1fb2daa60de6 ("x86/resctrl: Discover hardware telemetry events")
> Assisted-by: Claude:Opus-4.7
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> --

Please note the separator typo ("--" -> "---") above that exists in every patch in
this series that has a changelog. Please check all patches for this, I only highlight this
instance.

Reinette

