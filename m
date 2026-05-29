Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81C3647A0A1
	for <patches@lists.linux.dev>; Fri, 29 May 2026 18:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780079844; cv=fail; b=mytHjp0Gi+D+lILfGMwcukfLClUC2pADfMQU2zJLxm1GNS1ps4JXDdz2BkIDi00wI5+xNlGtrSfjFUx1rwZQi/sW51K4aruu/NUHjnH3ecGG9rK3ue6/yCESJsW0My9c7nEENwEyykhnJWsMFR+FWG5aHp+GISPRf5DpCzq9hQY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780079844; c=relaxed/simple;
	bh=+PH+hfIwIxC2Bf1Yg3fuPr8tuUjO/ydsLfUt02/NXFQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Jy+DkGdnSDwTSEHJ1ClniQDu2+NCq8RJ/9KcJX+f/DIjlvwjTB+OEDouDmy0KPBw1nDD9vuUkr5wI1UcB0Vi5oYJrJfq008HsvatmzgLLkEVY4Z1bktc+WShu/2l4MAketRvTEtcjkefxg3nHpRbr+XmKIuoX5AMDDvpTaAgfew=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=k3e5D8ht; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="k3e5D8ht"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780079842; x=1811615842;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+PH+hfIwIxC2Bf1Yg3fuPr8tuUjO/ydsLfUt02/NXFQ=;
  b=k3e5D8htjW/DWDIoOiatIpLYXr7p7a4wAQ6K0KExEh2feqB1lrudNF0y
   Akor81AXioUEHXh8DkO56GrBIH8EaGFAc2AQyHM1PtOfgdtsl3Am45h4R
   CqmEG/1+bjfNkQTL+JClBeqg+Ry7mpJrtEuIGHEQiqkBUeuPz1GQ9Yin9
   EMQv7Xwu9kIwjiR0Sgb+KC9koS/4jVOuEMRyxizYlhn/QXfPJNJHHyR3W
   1oiIjUGk1I6r+AQd+i+GGEhSs2bKiRRtXgcTXB3N/eaE2Tsc5nQkUvt9L
   IDkBxEDjsdZYIj4S6qPuSZMFN57qPW772LujqDVDSivNM+blUIU9Hq0c8
   A==;
X-CSE-ConnectionGUID: rymK8kG9T6m/DQWe9BmQVA==
X-CSE-MsgGUID: hWelPi0aQvW/Jr9tAdu4YA==
X-IronPort-AV: E=McAfee;i="6800,10657,11801"; a="80931081"
X-IronPort-AV: E=Sophos;i="6.24,175,1774335600"; 
   d="scan'208";a="80931081"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2026 11:37:21 -0700
X-CSE-ConnectionGUID: J8RzEwpLQHC5SZl8mm9bfw==
X-CSE-MsgGUID: gsTSlIlORJWX1g5KpTbKFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,175,1774335600"; 
   d="scan'208";a="240379776"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2026 11:37:20 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 29 May 2026 11:37:19 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 29 May 2026 11:37:19 -0700
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.34) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 29 May 2026 11:37:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZIiHjlk6YGGyaUiWKVW7Bn3ybbCTmXcOev3umT0lZGPGkSL081ZWY6RYZQh0oM1GhakEf50yLfQ7lzAH8+6QenXDnd6pB1b+JFyPXEGjeUguRUtZqneyOmy+mm92YPceNdvhUhP6vdY8qlRgSqE0FqcyU0Gd6h0MPglhNRkNclUDuubUpQTTTjWUkpc2FZvS7oacwAC9OOoEP3M+Jx+gsfzdmHky5waM+3U/D6aTOSaT+61LHbHLUgz9ayraxt7LZj0hkwJxXAgMFid7EK7eKjXz3kyO81290Ot3SbXYoM3heyZR3GSudq14BGphVzalVmblg9JLDpeGE6lk4XvZ/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=irO2eXaPzpAhpwfaFYxXZF7Ip4mlXx2YiCViDxGB5I0=;
 b=JpZ+BYEkTR3EdNhrWJghL5lCTWXXuU2ROAb7S6UdUj6/bZB16VjwmClS4kHwtUfmTWqHKDdf0ZtF/qZvIyNcx1y8euZ66sQ9D7Ae5WaZOCVfFL9F4fMJpbwQohZjBOouTJaECzp62lSuIVwiDTEcsIzOxTnXE5nUohfaGA3oyXMBbQ0tsEIRyLtgrZeob7uKh6CyMC0lF3ZRNVDpUUEPL47yeGvGSNr5Ef7zhccl2kwXNfy9/zD6yRiRdlI7Sldk3wUMIzDHuQ1Pom5Htwukq10HlSvyneZRCnQBMhSXoA9MyFPaADLRPyUUi0jVlzQ04iXwRBNIRSVcDxvw3CoyJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by MW4PR11MB6713.namprd11.prod.outlook.com (2603:10b6:303:1e8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.14; Fri, 29 May
 2026 18:37:15 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%4]) with mapi id 15.21.0071.011; Fri, 29 May 2026
 18:37:15 +0000
Message-ID: <8acb01f9-edd2-4279-89fd-a9a0091743c5@intel.com>
Date: Fri, 29 May 2026 11:37:12 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/9] x86,fs/resctrl: Fix long-standing issues
To: "Luck, Tony" <tony.luck@intel.com>
CC: <james.morse@arm.com>, <Dave.Martin@arm.com>, <babu.moger@amd.com>,
	<bp@alien8.de>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <ben.horgan@arm.com>,
	<fustini@kernel.org>, <fenghuay@nvidia.com>, <peternewman@google.com>,
	<yu.c.chen@intel.com>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <cover.1779476724.git.reinette.chatre@intel.com>
 <ahigzj0ewXQE-baI@agluck-desk3>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <ahigzj0ewXQE-baI@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0064.namprd03.prod.outlook.com
 (2603:10b6:303:b6::9) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|MW4PR11MB6713:EE_
X-MS-Office365-Filtering-Correlation-Id: 33b99393-68bc-4e97-867c-08debdb14dff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|4143699003|18002099003|22082099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info: znmdF9GuT+MWrPRdOAEOEkZcKxHOsB0y19f3FZP6bSF3pgXYy0LijTJaJ33nXWNXx2iF3LwTlNthtDZpk6KyhceqES2rMXpogBZ/BihrT/sgdRPAnMAXhO8zSQ68MjXa7ANpu6SSUL8zntpPpc/7boSsGgHhHb1g1PrZkpvVrGI6JqrHL6dCETAc8EtDtpa8GpDn1iBBxOksncoRX2pdi2W15WJLt3QcG1eoKCGjWdHO6zdqkMBFBYi0qKxzfoy64obCfULAw7qjgSdvvFGWisOMTguQODKVh9gWO0gjbiGCQBJGwg2vHK/d4AhN+QWbvmhxvtVEpHK36g2VCFOM2089fEZm/hW9FwAoDABKdspitzUA2EqDkg2Kqb+0XTMkMzCPtNPmm0bLytIA8D8yOsnliU+d3JOdnYiN9Jh/k6YDAzle7/zQM8liaNACR0bJGWK7Q6TN6yYQsaUaEt8xco0OuF7fMHbV8xjH2dVm4Aq8gRH68gYWVHwdZt6OJWwbeoizTzNweFFNjV7e4enwsZ+KlPyletDSkgv+GQEONPNljHLdeSI06XOALvtl0K1wkPDidalqpuUMux/a4R5EpxXzihWTQaKVzByEkpKC4vMgkgag/n1SqusEHNIXlIhY/SY2p65XyC/kKWtr4jhZynbBVboW8iY4sNhxZRmCDRAbgTq4i1iLtCU6hNmNYrZpryqCE29n1WRh1e++ZhATfw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(4143699003)(18002099003)(22082099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K2RENEhGYVhwQ1FjT25xbVdaVi8vSE0rUS84cGlqN3E1aXR3QkNHWWpDblFI?=
 =?utf-8?B?czhod3RaaXM5OHExQ05KR0J6bVF0L3ZISEI2WStLYUtFcGFjaXowL3ZIL1oz?=
 =?utf-8?B?MEY1eWNIbTBadEZnMlhVZUoyTTdJRU9wa2NVZHBxWlA5TWc0YXNpaS9LWWlx?=
 =?utf-8?B?L2M3TkhWeXRoZTJEVWVwQ2EreUxyZjduOWpwd3NTM0lKYVR2dFJxbjd2N1lX?=
 =?utf-8?B?OFpKYk4xOEV3RnRNalYrMUM2S3J2RzZ3bXo2L0MydlVBcTlwdlZDRFJtVURl?=
 =?utf-8?B?elNXc3FWaG1Gb0VsM212VzlHazFJeVc3TENmQnVtZ3E5ME9rNEFzQUxaUVBj?=
 =?utf-8?B?V1BWRVRlcS9NTlhxcm9Ea2JxYlh2cVYrVU4xV0Ura2lEaXl2SmRNbXhydVBH?=
 =?utf-8?B?ODFtdFp3MldrOCtuZWUxUlFXcmkxdEFqWTZMV0NEdFZxOVpjMFNjUkk4Y3p5?=
 =?utf-8?B?SU5ZN0psRTBBaG5CY2ZaZGNkSUU1ME1yM0tWZmJlUjNNVXRyRkF6VEpleVNF?=
 =?utf-8?B?dDVhRS9tQ3hXNlY4enVNMEd5a2ZFbnRibko3ekpabEJ5U1p4OGFXdzFFNnhw?=
 =?utf-8?B?TFFOYzArM1pWVU9RaTkvZVhLQ2VONUo3Qk4xS2l3a09OTjgyUXUyTnl5Rjlo?=
 =?utf-8?B?bENuM1pzejROMEtUQUFmZUlwQlQ5dTVGWFVJS2dXVXBYM3lRMTR4YUNydXls?=
 =?utf-8?B?THlmTE0wTlpIZ2lVR282bVZvcDlvSFgzSXI3Q291OW9HclBvcHppK282ZkE1?=
 =?utf-8?B?amNVaGRrTjJiRFJ0eHNndENXNDQ3VGw2ckZGTXZwdDRLNlBZQTFSeWoweFVZ?=
 =?utf-8?B?MVVFRjNiaTRWSVJpWTJRaWkxcjR4cSs4Vk1iS3JFay9wMHlocWdJVi9IVWd2?=
 =?utf-8?B?RnI0aTFRL2VnNXlSTkhOcHNSU3JHekYrb0JvRTU2QU5tR1JRK1FWR0R5TUF6?=
 =?utf-8?B?Y1BQQXRWdHhEMUx5cHN2TFo4RUNOYzQwMkNaL203eUo5TUVaZVluUlBkM3pZ?=
 =?utf-8?B?M2NWSlUydW5TdFY2czA1QmVvVy9pQXQreWIyS2psM0RqTDFzNFM2Q0JTcS8x?=
 =?utf-8?B?VTljQllOdDJSMzc3QjMvVE5JSWJGVHRnZUpVQXFsUmJoK0RoTTE1TGk1dU56?=
 =?utf-8?B?alVZcFlSL3VMcGpzeGpKM1JQWWdNUS9hMjl0b2VWUVFCbzRRK0h1aFBnc2E4?=
 =?utf-8?B?d3V6Yi9udk1PT0J0dnhOaEprVFVEc3lDMXZIbVRPc1BBY2ZBVUpXa2tyNGh4?=
 =?utf-8?B?UDQ3U0dXRU4wcUFRQ1ZFT01YTzhEUXNQdTBNZFRGNDcrZWI0Z2ZiTmZyNnJl?=
 =?utf-8?B?VkdSRElVU0dLM1JwbUt1bkJzR1lWTU9vSDh5cVVqaHNXS2tRZkE3ZFd2VzEw?=
 =?utf-8?B?OXFFN2ViWnpPWTd1YUNmM1g2ajhwYmZOOVhUeFQ1eStyYllTY1l5QldDV1Yz?=
 =?utf-8?B?c3JyMmFEaEYvTXEzTkdVK3VoeWFhMWNuZTNGandBUFFGTVhkKzZPeUdicVEy?=
 =?utf-8?B?WWFxeG1xVW1xaWhKQnhXQzBDSDRoWTdhc1daQStNdm9uUDArMXZNV0NxY25y?=
 =?utf-8?B?cmdzdUYzUjhsUFdVemVwUnhhV2lVWkhiR0RMSW40UzJ4SnVHM2owNEZFVENu?=
 =?utf-8?B?enhoZTFRTWR3M1VJT1lJK3Zycmh1czRna3ovVU9rdEZQMVgwQXJtUlNoWGt6?=
 =?utf-8?B?MmlEL1lIOVI4d2IxakZEUURaTDQxRFlOdThHb1BUVmgwKzVnenI1ZlpIaHVS?=
 =?utf-8?B?Rk04bU1jWVNCSHJXaEJKWnhnRk81MnEvZnpYVU1KVW1LTDRvcXI5YlV2dE8w?=
 =?utf-8?B?TU95Vy9PekZaY0tsc05BNzgwKzVzR3libTZ5YlFDTllselI1SWZoYThjNjZ0?=
 =?utf-8?B?clBpNWdZbEExM1dYb3RESnhjdUFvbkRlZ052TS9IN3pEbDZHVm9RZVp1ZnZB?=
 =?utf-8?B?TjMrTUtoZXdwa1RDa1Q1S2lUSFlXdEtEWG5BQlNqTGsyeC96YzVNb2JSWSs1?=
 =?utf-8?B?TUVwUnpTejZtQmJaWk9jWExsWWZ5b1R6VW83emkyOVh3bHUwOG0rb2lMWWlD?=
 =?utf-8?B?OWlrb2ZkZXQxZWZzZjRjbnRkQUNLbnJnTUNqa2U3TVBNc2tzbExIZW9rQ1hx?=
 =?utf-8?B?ajhxTjF6TXJ6Y3ZYdGlMaXd1OFRzcGZ5WVdZMStmS0N4MnVCTzc4c1B5b1cz?=
 =?utf-8?B?YnRDZFR5VElxQ2pFNFNlMjNaNVRkc3Zzb3U0cjhNUGMrbEVZVnV6VmsrcjVQ?=
 =?utf-8?B?TEk1aWIrRDZhamZCN2pYaHJQTm5ua0JiUU9qT0ZsYi9DYzRIblZSNjJIb1lH?=
 =?utf-8?B?dWg1RU1rKy9jSVdXRlEwSTFnWTlHZU5qVkx0bno1b2RNd1VzNXJMMEtTS0JM?=
 =?utf-8?Q?d1FBAUVesjHu/1r0=3D?=
X-Exchange-RoutingPolicyChecked: WGaCqKZxSfytl4LA/lBK8l327ekXVxJeq8HK0lY+o0weLQTI5/KojBkEARj4NadWqydET1K48bBbNj4pUWW5Xs/6osKY1Q3nbe7aL1SkZ8Mg36skPAGzqb7/q38b7xm43l9Ccvh+HsNoWAX/52BwbCKaDrkv8Xx6HKndhUKRxYoN0xq9TvJ4uBlUTOYfkd1x3xAIIBWAeZdq2k10TTU/zLjDQO+kwUKdBe+yOw1FXLZSYLFcmpSym2+x9RejCEv0IbynYowogoHdjg5t5AG6jYlG4fTsf4jGADG/zrG6hlNTggPhGGjK2tvBHieGDxJC4Ea1ZUpyPY9PdgJlQmYZtw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 33b99393-68bc-4e97-867c-08debdb14dff
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2026 18:37:15.0138
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K9AwKyqNNbJzKpsq0lkLPCmkbh4TxDqVEfVplIC+ZyT3X7qtd6EjbTYzllqhWfFJWdtaI4YPjXXyXwNjbav9So2bsLh001ZrUCIaMNjIIkk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6713
X-OriginatorOrg: intel.com

Hi Tony,

On 5/28/26 1:08 PM, Luck, Tony wrote:
> On Fri, May 22, 2026 at 12:15:04PM -0700, Reinette Chatre wrote:
>> v2: https://lore.kernel.org/lkml/20260515193944.15114-1-tony.luck@intel.com/
>> v1: https://lore.kernel.org/all/20260508182143.14592-1-tony.luck@intel.com/
>>
>> While reviewing the AET series [1] Sashiko reported a deadlock during mount,
>> and a use-after-free when an L3 domain is removed during CPU offline. Reinette
>> found a memory leak in the mount error path while refactoring code for a
>> solution to the mount hang.
>>
>> During review of V1 of this series Sashiko found a new UAF on unmount issue
>> that was fixed in V2.
>>
>> During review of V2 Sashiko uncovered a couple more new issues: TOCTOU
>> involving rdtgroup_kn_put() that may lead to UAF or double-free, double
>> free of pseudo-locked regions, potential deadlock between resctrl unmount and
>> info file readers. Sashiko also found that the CPU offline fix in V2 is flawed
>> in its use of is_percpu_thread().
>>
>> Address all issues identified. This version is significantly different from V2
>> because of the additional fixes and reworking of the CPU offline fix. I do not
>> consider this version quite "polished" but after all changes made to address
>> all the issues identified by Sashiko I would like to check-in with folks (and
>> Sashiko) on where the fixes are headed and would appreciate any feedback.
> 
> Several of these patches are either authored or co-authored by me, so
> I'm uncertain about the ethics of piling on a Reviewed-by tag.
> 
> Apart from patch 6 to fix sashiko reported issues in pseudo-locking
> everything looks good. I agree with Reinette's assessment[1] that
> pursuing the bizarre corner case races for pseudo-locking should
> not be a priority. That patch can be dropped.

Thank you for taking a look. 

After thinking about patch 6 more I plan to drop the fixes surrounding the races
but keep the fix for the RMID double-add. Since this will touch pseudo-locking region
lifetime management I expect Sashiko would bring up the pseudo-locking races
during its review but I believe this is a worthy fix.

As a summary of your tags for this series I see:
- patches 1, 2, 3, 4, and 9 have your Signed-off-by.
- patches 5, 7, and 8 do not have any tags from you.

Reinette
