Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2A1A279911
	for <patches@lists.linux.dev>; Thu,  8 May 2025 15:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746719925; cv=fail; b=XvDphxjckwI0Ob2pyHa914wI3MTszCSJMhcSaQggfEqWLIkKVT8LJ4dOwHhPD/mwBNz+1yF81dmEYOUNCbh8cAL+HGh38R8M6EPDlFIclManXg6xruSU+zOjHnHjw5bu+CnGa0Vq3GDLqEhDUiwiEHtIadl6zeygKSIJsHd6GLk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746719925; c=relaxed/simple;
	bh=TSzdHTyTMnwnIw0wr4QOUOoNdOtowFBvB41riMR1BJI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=EI0KPKwZK+/wqLvstubvaxKXHfu3WcmFmf99c7GfLL975KVYtkX5JIqxivsHmD/Ecme2MPJ2ab9LTfmm4n/RC0LL14mosZ8FV0wJfaZae7dISq+jYQHWXrIMD4YzUTPQPfYsxxnOVkbIe8bG1NubT9AeICSAQQ9f/wxJA3u6VxM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nPWXCohR; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nPWXCohR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746719923; x=1778255923;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TSzdHTyTMnwnIw0wr4QOUOoNdOtowFBvB41riMR1BJI=;
  b=nPWXCohRVXW61S5uQFPnLe1wJP9t7HL6CosuyCr0m8mM6Da5+F5HXZ3C
   uPxjMEJdUa8+vT4JkcVlU721AiL/dNsqc0nyNsDPD+nmL//6J82Y7GjL/
   uN9MpVbG1UN23Fbpg8YGeABbYW8Ja52Iw2ZH4OJaRrkR7gNQqXTAoso8b
   P0H+HWbTNlEIGETvmIs+O8qqwMEbGxgQ70Q1zcd087asi/47rDoF3C2Ib
   GP2+OOVh/5Zt3JLHjqML7q8brnYGYoBp+PC6V/IW/EAxYK9HV3Fop1uCG
   3sVdGFbtuiOYIJ6Xl/zisNyHKQVJ21OxyBEHJVE8Dbi92F4PWDxK7b34p
   g==;
X-CSE-ConnectionGUID: YlCNBpkzSYOZb82h4Zm5Lw==
X-CSE-MsgGUID: c69XQ5zKSAuTVakicBxv3Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="66049293"
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="66049293"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 08:58:42 -0700
X-CSE-ConnectionGUID: YMuw/u7HREKm70KNBtJlkg==
X-CSE-MsgGUID: 9KQZpUMfTOCFS0MvEmb14A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="137330250"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 08:58:42 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 8 May 2025 08:58:41 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 8 May 2025 08:58:41 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 8 May 2025 08:58:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iOmrSYeYIXocc1wreHE8fRS7BEU86tlWYTPMmo7pYjPUNXifS5I9syllxhMoSp85GsDAq1ADKMFHTJBDzHbYhjFP4RgQ+8uzcqNhx+ALAcdk9rK4wUyeUwTncJIIDyQ4iQav0cIRzk2jwzy6OpUzMZPeaP00NQwt5hE8lJ0s8p0sUGZB6v2q2ckotvl0QpYWwHnAy9xOIaJA05hmUEvverXujoAoE1g7cgUv3gcaRdr7cUMx53knldUpH0+75BlX0O0jm/Qd0wIvNg9nHGljnUFuKFJpJuc2afDF6Ye/A2uIQCtG8X8j9iRuBBtWrTBomr3nMRo4T+Mpiy24IKf1BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D1aRDubIxJEfdzVeoDKnPzwUib+GsAEU+fA0IN8PCsk=;
 b=tB96d1fwtXVQV0xzJcrrq4xQXZTc+Nx8g86YLZZsmDVcJMSIldXFcMEk5Nnhrs6kV/p5v8B3WctnaazWjYQBlM0sdQYAJARzF2TgQTsn4ArIt5Gybt0ii0cyDeTPlZO6NqZgoEaMAft6i/a1NJVy7IZKmAq7RK4S6cT57yKOPyj6B3ey17QdqPOUOFIAERjO8dhdDh+WgsBdoGB3/F778Ok+N9XqdKRNG2eTYjXw4t+eaAObsrBbreFnwCVbWEYmKtHv6SnC0NxByQ6Wk/fQP725fNXZ97QyZUuRsMsB7aSNfY5dARTQUldErntmejBmzsbwo3L24AlUawTcft+o4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ5PPF0D43D62C4.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::80b) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.21; Thu, 8 May
 2025 15:57:54 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.8722.021; Thu, 8 May 2025
 15:57:54 +0000
Message-ID: <5cad8510-cbde-493a-8e73-96da685256fd@intel.com>
Date: Thu, 8 May 2025 08:57:52 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 22/31] x86/resctrl: Read core telemetry events
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250429003359.375508-1-tony.luck@intel.com>
 <20250429003359.375508-23-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250429003359.375508-23-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0132.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::17) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ5PPF0D43D62C4:EE_
X-MS-Office365-Filtering-Correlation-Id: 3484893f-89f2-4871-ad19-08dd8e4917f5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?M2dKWHcreUxKakkzVUI4WHRnekxnejJyTURzRU5MMUdlOEd6M2VieG1wYU9R?=
 =?utf-8?B?d1BhNHlJOXg0SmwrV0k5di9zTjFmY0lXU3V1OXp2RzVnZDA4UDVybE5Xc1NQ?=
 =?utf-8?B?UVZXcXdST1dnSFdhOUhJUkFpbFRUam01b1JaQStnU1NOZmRWVlQ2eVFKenhD?=
 =?utf-8?B?VVFacVZCenVLRVI4ZnVNRDlwenhDZjAwR1Q4VnZoVGQvZ1dGak9nbjd0QTJN?=
 =?utf-8?B?MExDZEFBNkUzSllXaUFLMURlZ3RuZzIrVXFWVzBtekxFdEs4THpRY0cxNWdW?=
 =?utf-8?B?QmVhbS9vcWEvZ1JMRERoUjF2aGtIbXhLeXpHOWtzK0hHY0lyUlNZOWRsMENx?=
 =?utf-8?B?WlRiSjVtTUhYY0ljcTJRNGdUVTQ4ODErK25kTW9ienBtT3M5eXczQWpBTlBv?=
 =?utf-8?B?eVZSdkM5U3hTMmdtazFGQVBwUTgxYU9Sb05PeC9jU1JsVlJ4RXRtT0RLWW5n?=
 =?utf-8?B?ZnR2dE5lU1FPUUZCSnpUZWVRbkRrM1djc25laC91NlUrN240L0JRQXFUaUVy?=
 =?utf-8?B?ZXBzd2Yvemlva0FYQ1R5ODBZbkh6NmUrTjlwRGI4L0hBV21BUGRhcHNuejJz?=
 =?utf-8?B?b05JQ2xuUzVteGtwaWFUZCtuRUUxNEpQTHAxMzk0S0prcnBTdTllQkFJZXVv?=
 =?utf-8?B?c2RKa0NKRHY3NWFZcjFvcEZ3clljeXZvNHMyRlBaZUZWNExHa2Y4SVM2c05I?=
 =?utf-8?B?MnkxQm1PdjdhSWJ0UlVmMy9qOFFFL3Y5SjdZV3phaVFxcmQydmhNRXJXQzFO?=
 =?utf-8?B?R2dqMnc4OG45MWROcDJyZDdMaVZDcksxUFRSSjZpNTR2K0gzY1BudjNvaEpR?=
 =?utf-8?B?M0hhVmpRbGx5R2pYMG1ndDlOR01EY2prWUZKQi9udy84Z1Z3bDF2RElSMnFz?=
 =?utf-8?B?UGtON0E2NHhGdEladUJVS3JKcjk0ZTlYeHBNRytDM3NzdHdjUE1oendscTFP?=
 =?utf-8?B?d1FwNHR3VURNQXEyT1ZuWGRlTlBTekNMM2FXZGgrSzNNbmprcWNPVlY5aWZv?=
 =?utf-8?B?WWQrNjBhRFUzOHRGejJJNmo0bHNhekNheGRwU1FTK2pmUlBSMUU2UjNqUVRO?=
 =?utf-8?B?VDk3K0ZDaFZtMkdWYTloaGFDSU1JQ3J2a1ZESXZtWUFQMHdHZU5GNnU0cmNz?=
 =?utf-8?B?bGNWRVRHTEh4YTFUbTlzU29wR2U5WDA5ck9UVGF0TytkWkliV0s3azFVaEoz?=
 =?utf-8?B?VytiWWRUWHp1cjluTWwyeWVpakN6Q1JKQjViWVpseE1JT1ltTUVkL2FVbDJM?=
 =?utf-8?B?YmpEdGJQVDFncE9lbEJ2enYwSC92QVNlVWMvS1JGdFFiZjRXSS92ZEtDeW4y?=
 =?utf-8?B?MWo5Vm52bE9EZllJUlFZWmlUMWRsQ3RVWWNnUDV3NnBqSXQ5RS9pcVBGK3FP?=
 =?utf-8?B?Ky9qS3hnb3UzMU5mQXVLNW1UUjIwWldXT0xiNXRZWFZIUnE5bVF2cFVyYkdJ?=
 =?utf-8?B?TGtESHh1Sm9uaDNrZ3JwVGo3ZDIyVnRzbm9JMjRUVzZJVmdScUVGVzJvbVhG?=
 =?utf-8?B?QnNlV0lTZUFRMjhXTkFCYi83TnVscytsd0pzaitQeG90cC9lMG9YOEJPaVVN?=
 =?utf-8?B?S1k3bytIUWlNc2JpNW1keFlJWkJ6TXJuZ0h1dVA5UkVmZHhqcC93Q3RucFVT?=
 =?utf-8?B?a09taUdsNDlJNTY5WFlIdkc2Yk5xd2MySGZKeVBhOFJsQ0wwL2MvSGpBY2dH?=
 =?utf-8?B?WSttaHZGaEN1NUxEcE1IMHZpT3JMSEZzYzRwdS8vS2gweHF4ZHVnQjB2NjBC?=
 =?utf-8?B?Tm9wZ0k5ZzdBRm00R1FlR2U4YVFseCtPNXlDNjhYallnOHUwSTg0a3BWMVUx?=
 =?utf-8?B?WlY1TmZ2UjFRU3RJbjZJbitIcWZZTkEyTkk3d1pYMmNLb1BJMW1qdFlHUC93?=
 =?utf-8?B?SlpVTzFMTm5RMDNxQWlQV3RJTThVVUZtK1NDSzhsT3NVVTZyUy9vL0JyQ0J0?=
 =?utf-8?B?Q0ZjVFFsSFYxditneGVhKytTZDJyZzROVWVyTG1UQldpNG9oTFJlQU0zSnZF?=
 =?utf-8?B?blJzbEVhOUlRPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dGlEbUdhdEFRckJ3ZVd6MkpFNmp3ODBPb1prcjlreisxdnM0QkFLZXkxSDhx?=
 =?utf-8?B?K0xVMVlPRmVuMUphK0ExbzBlNzFQbU1FRmVOYTh6Tm5RRGtrY0tkcjBwZjNa?=
 =?utf-8?B?NFIraDVVT2VIcVZkd0xFcVR2QUovOGkzNktDSFFGWE51dFlTekhzVWQvTG1E?=
 =?utf-8?B?Mk9MNFBRSlYvSnFUK1VlT0tRR3dHaE5yZnhIL1RkMk0xbGtPeTdneUt4WXpI?=
 =?utf-8?B?QmV5eEpxT2s4YThJMzU1YVBta2MwYmYzOWFReUJoQmhBZy83TnRHd0N0QzN0?=
 =?utf-8?B?UC9oclJrQmVCWkxWL2crVUxzWUJOTjdvZmFFQzB2VEhmUnNNZVBQWEgxYnFW?=
 =?utf-8?B?TGNtVUthRWV4NzgyYWY2WDJyWGEvVWRUV01pQnRoYXhOTGoxYnpXeGpvWEZj?=
 =?utf-8?B?WkFUZmRVMFZzaGd3U3QrZFo5Um5sQkNxQ3RwU0MzNXRPWExCN2xxT21ZUUEz?=
 =?utf-8?B?d0JCU2w0VVdobUE2eHRmd1NTUmpDRkhQZzVRLzZoYkcxQ3JwRnY1Q2JHbDBR?=
 =?utf-8?B?cnpEZkdzS1NCaHZ5Wk1MenFpTldqWjZiOVZKTUU2cHhGcDVFbGh3SThIQ0Zz?=
 =?utf-8?B?a3NOamx5cjBzSjhzYlBiY0xHUjJMNGxyQllIMmJ2N0JBWk1HVFdOU3V1WUt1?=
 =?utf-8?B?bmUvMjVhazE0TUFMUm5UdldVUEt0d0h4Z1hhY1BsUW1WWXhYYXlDNUtHcGFP?=
 =?utf-8?B?VFdydlJFRGUvRStwc3ppMlFqTEtvQlEyeWVweXJQRm5QcE1hMUxwV2NmUDQz?=
 =?utf-8?B?RjEvVXJUQjZLSXJPdmdVR1pRbDA3bGh6bE13QzgxOTdmdmxsdFZvU25qVktD?=
 =?utf-8?B?QkhZVFdKbEJoY080T0EwUWJLb3NacnVMSFpvMmxhS2NjVDdsTlZaVnVuR3A4?=
 =?utf-8?B?K2F1ckg5d0s5em05dndoSG5ta0VIYWJDL2Qrdkc1NWFsTVl2d0haUkhMWDV1?=
 =?utf-8?B?Z2c4VTRUcTRZdlIrVDhZVEdITnAyQkE0Zk1EdzQyN3V6ZDJSWHJ2Z01BcTRH?=
 =?utf-8?B?QkRZQXNNalUxWmM2bmdvcU5yY1JucmxHSDlBbVBwUks3cVBYOFdZT1VPRnJO?=
 =?utf-8?B?aEtsa3JGNGZmdnhrSUh2WDZGVTE2eSttZytlNVlHQ2pTYTdvc21NOCtxQ0Yr?=
 =?utf-8?B?WURudk9YVG15VGt2YjJ5a3RVUVdDRHpuSWFUc0gxT0ZZa3pVSzBWRmNReDdu?=
 =?utf-8?B?VkJickh6QjZNeU1SV29hajhtZmNScys5S2RZTjI5TERJY1RIZFMrVktGVDRO?=
 =?utf-8?B?V2FkL0htVGZDajVCclN5aTdOOFozVU03d3ZwYkZsRVlGTWZzYkgrWHdleW1Z?=
 =?utf-8?B?eVhKMllOZ1YwUHd5bSs5b1N0dndKZFhSSGZFeFZLaUZjbnMrWi84K2FPVTA1?=
 =?utf-8?B?VFZjNTA1bVJ5N0lkd2tFcDlGRWpVcjM1RWtkbmZQQSsxRkVpRUd6K3EvaFF5?=
 =?utf-8?B?THNIRVcwYXo0TUNWTTh3TGI0SHRheVl4bEhidjZTUFNjblczWWg5a0hFQmto?=
 =?utf-8?B?dnFvRFA5YU9qRlBLRWNqSUtWRFJqZkZIQ0p2MFdGSWM4SWcrQnJlWWFkM0J1?=
 =?utf-8?B?ZlROMnhpeU02U2I4VE5mUFZEVzN5cmwzbFR1RzFFalFsZlR2T2E0cXA3VnFG?=
 =?utf-8?B?RExLZWlSMUl5Nno4L291UUovWnNoS3VjY2N0R25WeHpralpFd2JoNW5uMTBa?=
 =?utf-8?B?MHFyZTBzbVZHcnRnSWJxeFBhOXlRVnpFMEpoMzJ0cEljRHNXRjBtckhJK2ta?=
 =?utf-8?B?V3NERmo3Y3JVa0RoOGVFSGFqOXVJSy9BWFU0K1RicWE4eVpBMWwzd2wzbTQ3?=
 =?utf-8?B?NkpiYlVDazJGaThrUDFhNFJObk5YUzA3TThsVExlZEUyQ3BEVk9veVV1YjF5?=
 =?utf-8?B?MDk3N2ZSTUxjalduNlhlb0J5b0lZcU5LNmJqRm5xbjVGZDZGdiszREVwblVX?=
 =?utf-8?B?QWYyZUpPT1Y3dlMyVGxrbWF0eUJ5SEpuMktRWW1UNEw2NWRTWjhYUU53RWV3?=
 =?utf-8?B?Y2ZKU2RJTWF5SU5VZDhxTk9Jd3ZaajlCZlpLaXZNQW54Sm1UcjAwQTJaZ21s?=
 =?utf-8?B?K2VWTWhqZG5KRXpYUURKMURwVG1sNmEzMXgrcDBHVnVvZHNOb1lLYkJ0Y09M?=
 =?utf-8?B?NzJrSWtnRDdBZHlhaTB0SEloeHFKdi9UTzZ2d2tNUSs2SEhlc0g2dzM2bHRn?=
 =?utf-8?B?eVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3484893f-89f2-4871-ad19-08dd8e4917f5
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2025 15:57:54.3406
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HC7OvTg7SPwPuvEPnnk6fslV3j+HRHZxkrIjoPZKIYMecnR8Qc7aD67heN0Ag7XPzEE88sQrNULm3ITWJ1cWteunyKrvLk8EYzuRgLc7xkY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF0D43D62C4
X-OriginatorOrg: intel.com

Hi Tony,

On 4/28/25 5:33 PM, Tony Luck wrote:
> The resctrl file system passes requests to read event monitor files to
> the architecture resctrl_arch_rmid_read() function to collect values

nit: no need to say "function" when using ().

> from hardware counters.
> 
> Use the resctrl resource to differentiate between calls to read legacy
> L3 events from the new telemetry events (which are attached to
> RDT_RESOURCE_PERF_PKG).
> 
> There may be multiple devices tracking each package, so scan all of them

"devices" seems to be in the mix of similar term as aggregator and
telemetry regions. Having multiple terms for same/similar thing is confusing.

> and add up all counters.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/kernel/cpu/resctrl/internal.h  |  5 ++++
>  arch/x86/kernel/cpu/resctrl/intel_aet.c | 34 +++++++++++++++++++++++++
>  arch/x86/kernel/cpu/resctrl/monitor.c   |  3 +++
>  3 files changed, 42 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> index 571db665eca6..dd5fe8a98304 100644
> --- a/arch/x86/kernel/cpu/resctrl/internal.h
> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> @@ -170,9 +170,14 @@ void rdt_domain_reconfigure_cdp(struct rdt_resource *r);
>  #ifdef CONFIG_INTEL_AET_RESCTRL
>  bool intel_aet_get_events(void);
>  void __exit intel_aet_exit(void);
> +int intel_aet_read_event(int domid, int rmid, enum resctrl_event_id evtid, u64 *val);
>  #else
>  static inline bool intel_aet_get_events(void) { return false; }
>  static inline void intel_aet_exit(void) { };
> +static inline int intel_aet_read_event(int domid, int rmid, enum resctrl_event_id evtid, u64 *val)
> +{
> +	return -EINVAL;
> +}
>  #endif
>  
>  #endif /* _ASM_X86_RESCTRL_INTERNAL_H */
> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> index e1cb6bd4788d..0bbf991da981 100644
> --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> @@ -13,6 +13,7 @@
>  
>  #include <linux/cleanup.h>
>  #include <linux/cpu.h>
> +#include <linux/io.h>
>  #include <linux/resctrl.h>
>  
>  /* Temporary - delete from final version */
> @@ -246,3 +247,36 @@ void __exit intel_aet_exit(void)
>  		free_mmio_info((*peg)->pkginfo);
>  	}
>  }
> +
> +#define VALID_BIT	BIT_ULL(63)
> +#define DATA_BITS	GENMASK_ULL(62, 0)
> +
> +/*
> + * Read counter for an event on a domain (summing all aggregators
> + * on the domain).
> + */
> +int intel_aet_read_event(int domid, int rmid, enum resctrl_event_id evtid, u64 *val)
> +{
> +	struct evtinfo *info = &evtinfo[evtid];
> +	struct mmio_info *mmi;
> +	u64 evtcount;
> +	int idx;
> +
> +	idx = rmid * info->event_group->num_events;
> +	idx += info->idx;
> +	mmi = info->event_group->pkginfo[domid];
> +
> +	if (idx * sizeof(u64) > info->event_group->mmio_size) {

Reading offset "idx * sizeof(u64)" when 
"idx * sizeof(u64) == info->event_group->mmio_size" is overflow, no?
How about (please check):
	if (idx * sizeof(u64) - sizeof(u64) >= info->event_group->mmio_size)
	

> +		pr_warn_once("MMIO index %d out of range\n", idx);
> +		return -EINVAL;

The function's return percolates up to rdtgroup_mondata_show() where
the return code is translated into text: -EINVAL becomes "Unavailable"
and -EIO becomes "Error". Seems like this should be -EIO instead?

> +	}
> +
> +	for (int i = 0; i < mmi->count; i++) {
> +		evtcount = readq(mmi->addrs[i] + idx * sizeof(u64));
> +		if (!(evtcount & VALID_BIT))
> +			return -EINVAL;

What does set of "VALID_BIT" mean? That it is a valid counter or
that the data within is valid?

> +		*val += evtcount & DATA_BITS;
> +	}


> +
> +	return 0;
> +}
> diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
> index 8d8ec86929fa..04214585824b 100644
> --- a/arch/x86/kernel/cpu/resctrl/monitor.c
> +++ b/arch/x86/kernel/cpu/resctrl/monitor.c
> @@ -237,6 +237,9 @@ int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_l3_mon_domain *d,
>  
>  	resctrl_arch_rmid_read_context_check();
>  
> +	if (r->rid == RDT_RESOURCE_PERF_PKG)
> +		return intel_aet_read_event(d->hdr.id, rmid, eventid, val);
> +

Please add comment or check that code that follows is for L3 resource

>  	prmid = logical_rmid_to_physical_rmid(cpu, rmid);
>  	ret = __rmid_read_phys(prmid, eventid, &msr_val);
>  	if (ret)

Reinette
