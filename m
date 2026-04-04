Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED9A1CFBA
	for <patches@lists.linux.dev>; Sat,  4 Apr 2026 00:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775260903; cv=fail; b=fbRAqrjWljwUCni6qwlNWhuVgxjcQme7/vfNV7J2HjyVQGBVcYFN7JLFcOwrT7k5ldubDq71Av6FESKibrbpX6x7MSTYqF3WHhYqqy5ANNUSoVpLmTB2EEMux4DLigbeogreZpyPSGe+F+o6GOYCj5MJ1jX/LLTwVyjdZjy2Hbo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775260903; c=relaxed/simple;
	bh=XugCkZdkyTFUHDmeZW7qV9Ht99olLrBmDVYLgZ5+E7U=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=J9GNa3hKYG8/bEqPLuGOfBqpA1f1RwVBugoY2Menx/RxmnalbMDTdfhzmXhH9iQ3YR8Iyehjo4I+hqU88gw5f16Wqqwr+zVHwSN9tcV+3BsCsYZ3quhwuP4Q3S0nDWyeTLACQkWauyV+LHkHN0oyjdWK7z4HRwJVBxHcC2E1tC0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gKnj+hXS; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gKnj+hXS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775260902; x=1806796902;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=XugCkZdkyTFUHDmeZW7qV9Ht99olLrBmDVYLgZ5+E7U=;
  b=gKnj+hXSRKOBx0C7kWlvpIdk1kfEC8VBigPTMl8U+PWrt9r6laM+614Z
   8Mj+dfxsHkci6RmVGGRuMJG4YlqjmUIvAk05yRcEIoK6jnb+6HPUqsQSv
   fQakzHjERBzcgBFPLmd1pzsNOKcQGFgnFlJOAZ9OzQiKALDU0mWkUSjDX
   cpt25EvXlxyuZmKKPRcO3XhclnhaN2QLm67B/KXVGJSlN07+JyxpJ2RhN
   7BG19ucm2jx9kMwIYnL2eX7sFVWL3eYfTPN9mwy9g/7Y4Rr+uPqGDJpA/
   z5MgJXVFkFHljHsdyg2UKCiF+zm6dsoCYn6Mb5Z8z5BJljob3vkEsB03E
   g==;
X-CSE-ConnectionGUID: Llx0wBaEQwSghUskUsh5Hw==
X-CSE-MsgGUID: LF041rl/Q9WTwdMzvbbbTA==
X-IronPort-AV: E=McAfee;i="6800,10657,11748"; a="75367217"
X-IronPort-AV: E=Sophos;i="6.23,158,1770624000"; 
   d="scan'208";a="75367217"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2026 17:01:34 -0700
X-CSE-ConnectionGUID: di1kBu4qTtugTs3wx6X8tw==
X-CSE-MsgGUID: WrkFoF7IQS6cZXFojtLpew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,158,1770624000"; 
   d="scan'208";a="227243183"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2026 17:01:34 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 3 Apr 2026 17:01:33 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 3 Apr 2026 17:01:33 -0700
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.21) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 3 Apr 2026 17:01:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YniQtW+Kls7rXzNYUhxyXcueOdaxm8J7LZ7RBPzhyfj9oTHD6dsB7lOObhCoWx9OjI/dYHgjdswcVIhXliwqnd0eML/En+znvKhjNKQldwCo1yY+q1ijWwU9EE0kiF+b1IsLLgyHQxBP0gM1fq9QFlR6P3rndkHJRzYLme3PgILNDz+ocMbhqffnzeE9ekj39w2st1gYVuiE24GeAbv53j97L7bHPAMEBRpgLbZRKZzAAazamhKLMcQL85t54pWXlnwQg6DpazH6QdCmfr0lCEvj+a36l7e2HzKUwu5XaXr3rde5bn9nR/d7LjsvdG1yWlKrwGZKdVcdGS1CTv9vjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1hu/ehy83Jvbu7xkgGwFwjv9pOfc8dETgYE/VCCHZd4=;
 b=BqnAj7DQ3HRZujbdvm57+aXPSpasGgBsPXEI2kw5jzblnp+vM9PCiMLLpfJU0Nyy/ZTqPX9k+3L8WVSgOhiYBy+/3ThK2ns4zfCPr3BaE+kBuFEsi6ZXA5IGE6X7lzmtFXpZ9H95161Xg4ro/Znerl2WcnleB4res+7dRGS3LYbV722Vuh3q7nHMsVEshz+VGAObKKhhbwb/NarU3TeWiIKS9k3F+cPZhUm2lzTuKY4kmlD4/hUNEO/jWTNhXJC9ERyqVa1+Twg5O6wyQ2FPY75DF9hb6vfwPMjd3kjrhaQwsO8C135aJ3iJrU/z/NbUsas7hjfwAht1IvlkkHwJZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CH0PR11MB8234.namprd11.prod.outlook.com (2603:10b6:610:190::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.18; Sat, 4 Apr
 2026 00:01:27 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%5]) with mapi id 15.20.9769.017; Sat, 4 Apr 2026
 00:01:26 +0000
Message-ID: <f509e705-3585-48e0-9fda-4ab2bd7b9ceb@intel.com>
Date: Fri, 3 Apr 2026 17:01:24 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/7] x86/resctrl: Drop setting of
 event_group::force_off when insufficient RMIDs
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20260330214322.96686-1-tony.luck@intel.com>
 <20260330214322.96686-3-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20260330214322.96686-3-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0109.namprd03.prod.outlook.com
 (2603:10b6:303:b7::24) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CH0PR11MB8234:EE_
X-MS-Office365-Filtering-Correlation-Id: ed17cd6a-4a7c-4719-87b2-08de91dd5111
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|921020|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info: /gfKuZ6iUNvZkHPj1PGjTxBeNrazsH98VzKoLEWThJO7ZTDsO4WcEMYOwk7OshNt9sDB+QK702vpNmtrXWkgfFNN/2HNYVh1DEfYyzvcBbfEEYjglLeVaiwn6VJ8cmneuz5sc6iAx5MKEpWUG9bZhJqiV3xKtdoNQI7vOkuhJtoy9orvPsSQvI1G5xPz/R5pKX9MJE4r2urUCFGj1Au9ZOdBXj+0pQ6+smCb9HxF9/gF5Vcnop0HPSc+xFQC9ueM1kOpvGgSd+FiaxaYECq5ZJpswCwJ8xOXzoxlnBiObsJC2aEn3pyQfA5VUC9emhavNnZEy5MP6j09u770LvTZ0yJPeHcdo4nrovfLY6BlZfz0qstLmOLyWNxPrtCn6gRGggiisnqV2DpiK8EDkKQFtHAik6PKTzktKyhDWIX/wCUR3qOmshVAraADsBP8pRG/mWxqyym/yYbGC3nmW0lsWtrc8ueFf4fq5ZvTlGDWdUl8EzjH2mEmHBAV8OkY9YTM4pi+UczI5pr8KffLbm5xJg+WXUjnf1FUQoTxNi6S86f+zX2B6T8oFhdwpEvC78yHBfjKKJt0o7PvaMX5aeKqcI1VqF5txleJ55heU+N7LXZWkeq59ldAOXtIBPIEB1rirUfDtz5kuD5bnqNKSImGCIbR7gINCcDy2AYPlXd2g5mvCikUj+0wbbWz6NRZ04aDrmXLwfWtVfcDWwpT1zgB1Lk3QXNDSOukQsdB4r3znd+XFO4rClkT+2Jrio4bb7vciXJMVVTRZ7AiQBmRc4m4mw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(921020)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R0orRmZoOHhSTUtVYUJabzIxdzN6MlhkTnVlTlp3d1RiKzFsVDViMzJmUTMr?=
 =?utf-8?B?MURUbmVxY2xJM3FMTzFsdFA0NVlwUDFLNVNJVWMvSS9HN0JLMmtyN2xqcm9P?=
 =?utf-8?B?blJMSitIUFI0N3JJT20rdXM5UmpISXNRMmxERWoyVWszNVozaEU2Z3ZNOUE5?=
 =?utf-8?B?SytkQ1RlYko4dFhyVmFFTjhZODI0WTZXa05LVDVNa1ZXM2VDUzZPeE9HTnRR?=
 =?utf-8?B?UExqcVJZd3NCOWJnU0hhWWxTZHhmN1JScll5QmdnZElHZS9tc3NuczR1L3BS?=
 =?utf-8?B?TitmSUJoMVVWemJKOHgwSXhURTZzRStRT1NieGtYazhDaXhFdnBpUy9zUU5x?=
 =?utf-8?B?b3NOa2ZMWXQwZnU5OGdJREt6TzAyYUJ2UGl3WG55RERMdDdTaE8xZ2NVbTVo?=
 =?utf-8?B?TTU4WlJDWkR3SThtNis4d09JdkhnSHFZaW91cW5TcXY1R3Z1WVZUTFFzWW9s?=
 =?utf-8?B?bDBQWHl2ZnBtb0QxUmZHOGt6THM5QUNYNDdMVXhKVXpNSmJhemNSQlFoZ0Ur?=
 =?utf-8?B?NzRuclplcUZFUUJUcVJCOW5qMkpLK1VCZVhVMlFyYTZlZTh6eTR3L2RZYXMy?=
 =?utf-8?B?cHhZZC9UUUZFM0VEYkpaWHJ2V1ltYzdIb09OaGxUMWJRM2dCNGZpcER5VGV5?=
 =?utf-8?B?NDRsT1dhTFcvMXVZVDhLbHB6YzRYODJZcWF2RWxpZ056cVNYdnU2eEMwSlhF?=
 =?utf-8?B?eHA5YmpWRWtYd2pZZi9oTTFaQi9SWlpyZXRocVE0NEd6Ti9sNkJtYjdwS2w3?=
 =?utf-8?B?RXpOV3FBNDViWnB0SFZvOXBhTmxLVWQ4dWc0UmVKZ0tHMGQwbU1GY2RGYzEr?=
 =?utf-8?B?R2NyNTFFYWd3UzZ1Q1l3N3ZrN1hTeEFMTDZuQWhlcnNVRm8zR1NTdWVVY0N6?=
 =?utf-8?B?bUVjY3R4TnB3TVY4WGFsbTgwbFY5Mm0wOTdKcU5kRlFtVS84OTdTMkxZZEhF?=
 =?utf-8?B?VUFpaVlmSWlKZ2k1UGZ3emtTcDZJQjdVcGNLS2tCcXhaYnNFSnU3RnFnbXBa?=
 =?utf-8?B?U2hGSTFDQkNQeG1KZWtCK092Q2hib0d4dkV6OHVrSkJsT2hjL0Z0dWpwMmxi?=
 =?utf-8?B?TWk0aTdYemtVZnJ2Y3pkOW5kRmhmTHdLbVlJNWJBNlljZjZFZldvQmxtSCs1?=
 =?utf-8?B?aEUyWGtQUEh4U1A5cTV2a3d1dHRJYXlpNWh1Zjl1OFo2S3Uza0gxWWFldEs3?=
 =?utf-8?B?MzRkWXpEQURVcUFwdzFsekRwSUFZNzVOWlFvOWI1TmNnR1FaK05Udzl3OVlu?=
 =?utf-8?B?bDc5S3BtT1JoaHc2NmxvdFBNTlZSbHJ3bU5ram5mc3ZZYndOTTdxS2hDQTNj?=
 =?utf-8?B?L2t2cVpLSlgyVmxleEdSUFJBQmtydW5ROCt5akxBOHM5RXRXdDlWWU5JUlZP?=
 =?utf-8?B?R1Z0YnVFTmx1MCtZUUM1N1UrMWtSU1pXSHJETk1LN0xsZlkwSmRQVWZ1a3k2?=
 =?utf-8?B?VXhwa05yV2VSWENQTDRBMzdCeUNBWXh1dXVpdFJCdmlwdldPcXBNSWVoejBI?=
 =?utf-8?B?RFhoV3V5c3Z3bFNIVmNYQ3FFWTMzL1cra2NobzcrbHppTno3UjI2L0RZZTRL?=
 =?utf-8?B?NzF2N0w0ZXhCYjJLU3g2bysyUkpZNm43WURITWRVZ1l3Qks3cTJ5UUoybFlK?=
 =?utf-8?B?cU1paXUrcENIa2gyOTRBMTAzUGpBU2RJY3JPbkNyL3JsQnNqbzFZdFdENGx1?=
 =?utf-8?B?T0E2VmNrVVp4Rnh3Z2g4VDBrM1lkd0UyYmF6VHhOaW5LQmJGUXVVR1BicVVa?=
 =?utf-8?B?dkZ3UE55bGhFL2tZcnZzUXlseGZIT3JNakVqNFR6QW5CSW9kZ2tQY0ZVVUtr?=
 =?utf-8?B?ZC9LVHVQTnNEL25NWmVEMi9yM1RkaTIvUG5OM0tmV2J5Z0w1aXVUcU0yZ0t5?=
 =?utf-8?B?QkExb2xjSlZ6RVlERTA3T2d5N1F3V1BIUDd2eGdrNnlIbUFPdGRpWlhOZHlI?=
 =?utf-8?B?a04xTFBjS1pvMVNyeE9aTGV5QUNLYlc5ZEVkbDdNNWNhcFJUd1R4N0ltVjZU?=
 =?utf-8?B?bWpieDJZYlJHTXpNc29KWjhFVDAwTGxIVnRJcVRIVGxUWUpmMFpOVFBPeldk?=
 =?utf-8?B?ZFFtSUUvVjRBVDhsZGcvUnB2VE5kTkVRM3dpdU0vOEFGOXNYQU1CSEsycjFY?=
 =?utf-8?B?ekZZUTZjM0pYUGtKcENwVUw0dDUxc2hMby9GRWlIVXNvclB6ZTBxWDI3ZEEx?=
 =?utf-8?B?c3dqMWxjbHJrTHJHcGZ1ekJEaStWam4valg2aDJnYjNVRU9WSWNZclErNUFv?=
 =?utf-8?B?TTdnVHRjUitJcnAzaU1vcy9UbVJ2c2JqQ21FUDhRSWorK2pUaDk0YTZlaVBu?=
 =?utf-8?B?V2gyMVVHeDE1b21tSExLR3hXV2MvQzhxeFZScjcwcnFZbUlRSFFxRHBZR3hp?=
 =?utf-8?Q?ku5rEi1q4bQhrpbs=3D?=
X-Exchange-RoutingPolicyChecked: ithHvADVGYIM0Z4xgDPioqlS5e0BgI7Z6M0qaAE1aP+aDLzr+VRBrOnlrBv23gqZbnRBIRjmaj0YvkGj8ABWnc/jour1/Q1+o7fyf15O19eg0gWH41NCbt61DdrCdb05Vxwv0dGkImw/YMVIpsvystk3qg1G7zUoshnFXPJflIKQvmMpJzZoSiyzkP9som2vR9t1ZhmZVz+aEFCTPj4mkughc9wQxzaLYTXNyBes8Lh6EYw7Di3gMjEQhMvkjYhsJXeHvCfek4ea55ldr/3U64TUF6cRj0Jb5Rp6TkyOWOuXo5PtZRM6ijiAqVOQxhVl+kcL8LFqDqid/twwN+Ic6Q==
X-MS-Exchange-CrossTenant-Network-Message-Id: ed17cd6a-4a7c-4719-87b2-08de91dd5111
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2026 00:01:26.8181
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qmrHYYVXTU/5h1OHVjj5iX4YGEot9y8ovkcQF65jBmHNJXkYQp0GdgeZBbtr7+InhmhfiIc7yaw4tuEATxYFRRo65lT2cRCKXia4zOA1nd8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB8234
X-OriginatorOrg: intel.com

Hi Tony,

On 3/30/26 2:43 PM, Tony Luck wrote:
> Setting the force_off flag does not matter when AET features are only
> enumerated once (on first mount).

Missing motivation here. Consider for example:
Enumerating AET features multiple times is needed because ... ?

> 
> In preparation for enumeration on every mount, drop this because it
> overrides user request with rdt= boot option to force enable a feature.

Missing answer to:
event_group::force_off is intended to reflect both the user and architecture's
opinion. This removes the architecture setting entirely. This is safe because ...

Missing:
Change definition of event_group::force_off.

Reinette
