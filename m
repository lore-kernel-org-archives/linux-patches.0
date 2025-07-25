Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE5A825FA10
	for <patches@lists.linux.dev>; Fri, 25 Jul 2025 23:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753485983; cv=fail; b=uzC7EBXXUQ1prBlB/rG0/a96xM9bW1mnsU536QaCmilvFYZKA6iblbMuRKS4Pbr8NJrCwlICB9u+loT2CcJ2rE62gEiPUct6UYbh5qI96xDaqCBe05d0i87ieW1sm0oCUpzFGkoZIlDqBjH7HyjzPKNwNqCit4SqJrEhAzRCb7s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753485983; c=relaxed/simple;
	bh=gbavV5q7yR3BnParegPpFEooGnodQzvYJ8EsKpnaJ1k=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=AIseG6dZPAnjmOBuQqcbVJM3gRqIXLJgEUZ6BC6GdiPesQUhgkBCWDcjrqJUTuVZDp7geM3AG+PhjXjaaMga13sSeSKshFzkLF0ptGaKlNf/Lc+/7NTdZkNpb7LP4AzRwRPObEQ1RXguBCJzSPtQiPlTVruF9yalVf5s6FbJfoA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YCiqTfh1; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YCiqTfh1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753485982; x=1785021982;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gbavV5q7yR3BnParegPpFEooGnodQzvYJ8EsKpnaJ1k=;
  b=YCiqTfh1hxdZN6nA1d682vH2YkBrrmxEqn0J8bxWsm+frabyB3E8MkGG
   JcVxKW1q5QGS2ut1OL4qA7+R6KFxNcoQazoGUgvU79AR0CqD7OEidUM5m
   WUfyZ7mvyhC7bV4cQjLHfjLpZUp3PIxNS2iNpnzcFrHnf6jRbyOtIoRNX
   mrX57gj7MYrrFsj7PZXZRixwbGSbGH5pbVFiF7BzM9cbPZdvTYjyx1aRz
   drObANa3Qfnec+hWrHJCnbk/vS5W6y9qiQ6exrDg3j/eYSDhVC1+Gzxsg
   4ZUcphZIbmyaH/vLT8efQZcayZjy3vBjSUnFdT7ZN7HgEB7g4MYH8GapS
   A==;
X-CSE-ConnectionGUID: 6C7Viz3KSZuWfVnHTpiuaw==
X-CSE-MsgGUID: JNl8MPHpTWKmCW+EdauqLA==
X-IronPort-AV: E=McAfee;i="6800,10657,11503"; a="55922114"
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="55922114"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2025 16:26:22 -0700
X-CSE-ConnectionGUID: 53xsBhgSQfON1EHO8mGBoA==
X-CSE-MsgGUID: h2kdhSK0R7WjlGenQo4gRw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="162050284"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2025 16:26:21 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 25 Jul 2025 16:26:20 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Fri, 25 Jul 2025 16:26:20 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.70) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 25 Jul 2025 16:26:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Jb0uZzWK1i0VcP2UgH46W6kic2pKY+a5HzJrkBOno0+HP64jbxQeqjxzhT/HhibN2qQjW8JWGwKnJsXD0vBRLXQLJ5F5b81TUGpmdxbeUoLJNNk9WDXkVlIDWd928gnDWqv0d6u8GMbELystv5fMICjBjdRO3SlDsO18nsGjEtf4/tYdjqkbtwsgu1GMobTdZVkMqR47PR/Ei6+adklsFpHrmfVghh6gn5pFbnfcu0tgW/82yD93ZtaRUegSdQMUT3kzm2jxYycWHnGeCTj2Us0AQAdQ7JSdLbC+4xYpOSK7re9+vyyLXsibe/Kgb+dEZQ3L2r3CWLYwmfuV8quBDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4nqoxFAOXstN9lRpsTjFt83U+p7tjLHdrtgRM/nFgVU=;
 b=V1rB/6xY1RreaxKKdByhRuXGqv8rXFKUsWb5dbTRdQ/2go752O/Amg/GgwdtdUZPBcvUt4Oa6Oz+igP4S/u295qEbhiwFEUnU9EOfJfrCaJJdFR+rza17jRMe27u1hrzjwGx4QDz3Y1tkkXH/OerymGyrZb2EdDxkHFhxevFmJUVDcpx7I6+SJil7pBdjTEJB4HezZXQ07f1An7Ix0AiKAYbY8eyFktGw61RAYmdk/k4taB8KX6354QWDibIFR4T6Itsdp3Vnpqk0AG63ATB8QzZRalzKAjp/C5Q/EciHYnvP0geikoWsGbqFv0zhTOhuqCbz4PyWevPRqaRtaZS/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA4PR11MB9419.namprd11.prod.outlook.com (2603:10b6:208:564::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.23; Fri, 25 Jul
 2025 23:25:51 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.8943.028; Fri, 25 Jul 2025
 23:25:51 +0000
Message-ID: <b0a744ab-cf41-4db6-b0db-3a609b0f0256@intel.com>
Date: Fri, 25 Jul 2025 16:25:49 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 09/31] x86,fs/resctrl: Use struct rdt_domain_hdr
 instead of struct rdt_mon_domain
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250711235341.113933-1-tony.luck@intel.com>
 <20250711235341.113933-10-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250711235341.113933-10-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0073.namprd03.prod.outlook.com
 (2603:10b6:303:b6::18) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA4PR11MB9419:EE_
X-MS-Office365-Filtering-Correlation-Id: 1963cf8f-489d-46f1-e423-08ddcbd297f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?aUdJUWtwK2VOaExOMVBoZExFZXozZjdONVZKcjdDOFlKaW5IWWx1WFRUMGh0?=
 =?utf-8?B?Y01aTEEwTTlOaDVOQkx2OVdUazFoai84dHF6eWlTQ3BiR29IcHFUUzcxeElk?=
 =?utf-8?B?Um1aTFV5Y3F2b0FaRThYZlFEMS8wbC9iWWRVcE1DTDhpYU1EQkxiRGd1WWFQ?=
 =?utf-8?B?SWlYQUFKbiswZzFzZU90cEl4UkRJS3B5eW0wazVFTzdFQXAvODVvRnRnYlVC?=
 =?utf-8?B?dnJVcnhKQjBCMldQdkZ6SUpVWGdsditjbklYTCs2N2pjSEwxa2FQUDZCK25V?=
 =?utf-8?B?YzJ1N0lONDZxRDRzcVVMWllFa01FUkpQd1Q4MWxTUUdRUUF3THN6UzhreGFD?=
 =?utf-8?B?TS83Y3p4M3VaY2lub2hEOGdTZlQ0bElaYTRvUzB3ellvYXkxQ05WV1ozeGd1?=
 =?utf-8?B?bFlsSkdSWTdnbUkyVzhVeWt0UXhxc1VuMmJiWVNyem1jNzhkSytteGQrUEF4?=
 =?utf-8?B?b0gySm5JMzV0MXdJeUwrcFJNNHJWRUt3KzBDVUxNOFlBL1gxaEF5MlhUSEda?=
 =?utf-8?B?U0JXQnhnUzRBd1JOY2haZjNTVjFHcDlSOHVBQXBIZ2dqNVMrL3BzaHIzeFlH?=
 =?utf-8?B?T3ZReHFNMFJ4aWsrZzkzSGpFeHQ0WHE2Vzdnc2h3RzNlcnlwUytMdVlQMlpN?=
 =?utf-8?B?STJ4bmRiTDRoL0NUbGR4WFhyT3UvN0grNWs0MTA2ekk3SWg1bUtQZXFNNnZz?=
 =?utf-8?B?dXJGVFZScDdGL0lWcWN2K0lES3g0VDNUM3Btem5WNFFUeGU0N3lvSWlXMVYr?=
 =?utf-8?B?MWdReXV2SzhyZVB3RTI0VFpkb09hWHRnOFRXalRFMkJQakdOS01FMTRiVlJ2?=
 =?utf-8?B?UmFlWlp1YmVsRlU3c1ZHY1NzRnJDMTFHK2czNjFjWFpNMVdYR2NtbkJEUW80?=
 =?utf-8?B?dzY2YVRKNW9EWnUyNzhUMHNGMjhRZEhOWngvbDlpdXNUOW54RisxU0RmWVBH?=
 =?utf-8?B?STIydGdZeWN6YUtYU2ZaQmN6TFNuN0k2OW5yVU9henNJNXZyNDFzQ0FtYlBK?=
 =?utf-8?B?cEN2S0hxVmhzanVUUTVURDBxWWFPbSs3cEE2M3QwUjNQakhUTkVWMGVYZFU3?=
 =?utf-8?B?d0R0NVJVbmk3TThiMEZiKzZyc1MxRHFKakd5eHlDSDhUTDZSVzZaYjVYT3VV?=
 =?utf-8?B?R1lWS2ZzYk1zMFptRVUwdFNxL29hcTRlYzlNYjAwQjJ5cEVlODk0dzJrVGxh?=
 =?utf-8?B?MzlNS0djcUZCSGZsTm1sQjB4SkZhU0hQVEROdnRraEdYZmxDTm9PL1BJMVF1?=
 =?utf-8?B?Ymtpc040cTJZNlpQVGR2VG5EbFRSK0xEWUtIVTF5SmFKcXRNVlhCRVh0bmpH?=
 =?utf-8?B?TDczcUVSUHRMQkE1REFLQjJTMVppbWtMVTU3RE13a0t2aUVuZjk5WkRJOWpu?=
 =?utf-8?B?R3ZoNlE3NFFsb08xbnQyWHlEdm5yeFRMNGJhN2pUSUZ2N3hROG5tU1hjNXR0?=
 =?utf-8?B?OU1uOHl5bElqcks1QklvTlpwMi96eGhTaFJWSU5zbHJoektnTER4bGFCVTFy?=
 =?utf-8?B?SXRuU3FUVXMvWnYvSEFIOVQ1MjlKMkVBTE1IUDBJMEpEaVY5c2tRU1FRZ1Nu?=
 =?utf-8?B?MTNXdFFLRStoQ2s1OENxUXpHZkNKQ3NzL0wwSkgvYmx0TUNuSmNWMGhYMGN0?=
 =?utf-8?B?QkhmNkJMSFRDT1V6alFXbERKMFM5N2d6Z2pJbzZ3MmpjMGZqdjhuWW5xZUJa?=
 =?utf-8?B?WnB5emZvMmd2N3hqQmN6a3lka2hYRWlGb0lHU0RZM2hkZHl1REE1OCtvZ3pj?=
 =?utf-8?B?YXhtSkdQMkJ5VlNCNnlkMXFYdjc1bVlzZ0MwM2FpYUlRYnRybzRwY0s5bmpR?=
 =?utf-8?B?cmE4a0ZiZERFTkhFdlJuUTFEQnc4RUlyVnR2dUJjdmEzbC9pMUVYU3VHNWo0?=
 =?utf-8?B?VmdRNW1LYldCT3Q3bzdYODJDOFk5UERIUmhCL3FyaUdzdDVTR3VHVFVZWUhT?=
 =?utf-8?B?bTA3UHdzTDdrSlFTT0s5L2J5MGRQcWMrMDd5SmpXa3p0b05PUjkwU3JhY1M2?=
 =?utf-8?B?MmVFc3V4MFhnPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cUlSdC9HaVBsY2tDK3ZvSXFtd3JGbzBTSVhjdzlONGV3azVNdVIveVI0eXNK?=
 =?utf-8?B?bE5zNUduV1RHZjVyNnhGSkZ4TUxzNHRzSkVmMldRb2xlaHpvYU45b0w1ZFdH?=
 =?utf-8?B?d2x2OFJ2UzJqZUZROXBIcmNUNHVIYjU4YTdIYlRPa2tTb1dlZE9JblJjL0NW?=
 =?utf-8?B?RlpSZGRVd0prM2o4K0FSTDNCTk13WW1PbjZjMm9YSHVmT3BlWFBYOHdXaVNQ?=
 =?utf-8?B?cDA1dGxseEZYVWpDMyszUWVqOHRpbUZRMXIyeTkwdHdETjM0SWtWb0tTQjU5?=
 =?utf-8?B?dGZCeTdEZzVIaE9iT1VXalBPMEh4WXJ3cG1mYm5wSFQrNXo2dmw4M0FtK3cr?=
 =?utf-8?B?QkgzSUptODBQc1FaMmpiQUc5YXYrdHJCTk12R3RUYUpnTURNTGV6V2hKTXFG?=
 =?utf-8?B?MVRBcW1NTCszU2VZTkplOWl4N3JEUGVnaG5TMElqVzg1TUI4amx5clFFWmFu?=
 =?utf-8?B?cFQ4eFVIcnFVTTNidGIxRGdpck5KK1lHS3FJU3o5Tis1NnpMcEYyMGlMeFBQ?=
 =?utf-8?B?czVDRGJ5cEJtSStLVDh3cWlEaUFyUExiQ1JrWW1mUDhld1MwV25yenZPcVgz?=
 =?utf-8?B?UlBoT1M2ZDdrOGR6V3VuTE1FaGJBMWZQeWk1ZnVMOUhIT0NxNkNKaFcyODdH?=
 =?utf-8?B?MklXNHlaNnI0WnVZeEN5ZE4vbTdVZi9PVS9nUkZtdXZRdWJ1SmVCQVhQMDU3?=
 =?utf-8?B?dnRoSXYxdW5JZU5LUmJOWFAxWXdZTGFTdlJpY1J0bVZacEJKSkgyYlNIaHhR?=
 =?utf-8?B?VEx3RHd3cklYTWF2My82MVJwY0RyU1ZFdWhBb0NZd1UwSE5XN1pnVlRTSHlj?=
 =?utf-8?B?SDdEY1BtWW5SRExGOE1oNW0wbXB1UG1yNkt6L0xQbHdLWWgxUmVIOGsyRWly?=
 =?utf-8?B?VUlGUGZ3L21tZjhqMTh0VFhQeFBBV25ObU9QQ1VEZCs2QUxoZVFLUXVaNEVI?=
 =?utf-8?B?blR6ZU1GeHdqTGhETDZ2eVJDRjZ5VlVMTVZaNGNYMldlRUV2QVU3V0ZsUXAr?=
 =?utf-8?B?SkFKeGE5M0dBQnpKY2U2Lzc0Q1BlNE9DS1BiWEhUcDlmeFJTN3JDL3dvZU9P?=
 =?utf-8?B?UVFobnpTMWJmNmRMcVVVTmRaSVlJQlhJcjNCMzVCbGw3NDlyMEl5ZVI2U2dh?=
 =?utf-8?B?d0hGV3AwdUtiV2s2YkdNZzN5eDQ0NVBXSDdqSlhjVk1UUGY3bnNETFB5Zmdu?=
 =?utf-8?B?NnFzSytyOXFGNzdZNWZNeVZtUFJyTzE2bVZ0VTlzSXNtWDhCUDBjMmZCRmpO?=
 =?utf-8?B?NlBQeXphTEhRajFYZUI3VDR4RGtFQ2o5cFlUeGwybXdYQm51QWU0RDRqYzg0?=
 =?utf-8?B?bmdHZVpXbWdXN0paRVpVdCtDQTdGQi9nSk5kMFlBdjZib3ZPelc4QkIyYzBD?=
 =?utf-8?B?aFNJT0ZLOGNTUExiMXFxYkF1M05iT1FKWExueWFBZm1ORGg5VjBYMEhnb1c0?=
 =?utf-8?B?ejRFOTJrQUVqWUJ6OWVINzVGQjlyWXhjQ0RPWGtFYjZPeVlYYndPQmdZNVJx?=
 =?utf-8?B?VDZDRUtCbCsrWTdoYUh0MVgwSlRrajFlSDJNYk1sQXhiU0N0d2VIRFBJWmtW?=
 =?utf-8?B?cTQ4bklsclMwUFlYM3Z5N01aazRtdk5hVGJCbW43a25kMWFDTTJNeFZZUjNL?=
 =?utf-8?B?SDZwZ0xKSUlOdzVFZXVUcVk3NVB3UEhmMzhraWNlNEVkMndFTm5GdGVkVGFr?=
 =?utf-8?B?NzBGTnE3RjY4M2xtNlZEdThhanZTa3Z2bUJYMFR6RndVVU9GZitXbmkwNWlR?=
 =?utf-8?B?VUhITmJwRFN5Q25zRklPR2E4NFFyczdmVTJ2Vjd0MzgvNUpNNzFJa2RhVllv?=
 =?utf-8?B?NUdxNDVITy9oMjVzdXRNb2F0dWlHZU1ZeGc4aDJxUXkwRHR1bUtoMW1ZakVx?=
 =?utf-8?B?MUN2U3RJd0M2bDdJMTB5MTd3Zm5mUkV4VGNENjhFNXc1TmZlWWFINlJNeTBK?=
 =?utf-8?B?L2NWRUNhc2x0MERKU1Z0WVZKVGs0MDV5YU9TYWdPQ0hDY0Y1dlB2bGZmaDhI?=
 =?utf-8?B?VTFoS1hzU0lVOVlRUzZQT2dTRWg1R2VCaFpwTGtGUDdQRGIxcUpkNFBNRkJF?=
 =?utf-8?B?c2xDWTVUOThGVjhGUW9mOGwyL0FtMTlLTlFhc1RCN25zUnd6ZlczUjh4Y251?=
 =?utf-8?B?M0RxS0l2R2IwMmt1WGRQY2dFWmlGZ1R3UE02RVMyYkcyc29CVjVoczk2OGk3?=
 =?utf-8?B?ckE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1963cf8f-489d-46f1-e423-08ddcbd297f7
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2025 23:25:51.1304
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fCgLXOuLppbEAkTPiJYU45EAKf8clCljimgd/jPWVAoM0yW9GPzbL9B9JbaA+tIn7OboRjvjsL0mTDbDvRS/6uvE3ZvmLGj8Hzm4/QBJCQI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB9419
X-OriginatorOrg: intel.com

Hi Tony,

On 7/11/25 4:53 PM, Tony Luck wrote:
> Historically all monitoring events have been associated with
> the L3 resource and it made sense to use the L3 specific "struct
> rdt_mon_domain *" arguments to functions manipulating domains.

Above is context describing current implementation so can be in present
tense. Needs imperative tone, eg. "All monitoring events are associated ..."


But
> the addition of monitor events tied to other resources changes this
> assumption.
> 
> To enable enumeration of domains for events in other resources, change
> the calling sequence to use the generic struct rdt_domain_hdr for domain
> addition and deletion to preserve as much common code as possible.
> 
> Same change to allow reading events in other resources. In this case
> the code flow passes from mon_event_read() via smp_call*() eventually
> to __mon_event_count() so the rmid_read::d field is replaced with
> the new rmid_read::hdr field.
> 
> The mon_data structure is unchanged, but documentation is updated
> to note that mon_data::sum is only used for RDT_RESOURCE_L3.

Needs imperative tone.

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

...

> --- a/fs/resctrl/monitor.c
> +++ b/fs/resctrl/monitor.c
> @@ -159,7 +159,7 @@ void __check_limbo(struct rdt_mon_domain *d, bool force_free)
>  			break;
>  
>  		entry = __rmid_entry(idx);
> -		if (resctrl_arch_rmid_read(r, d, entry->closid, entry->rmid,
> +		if (resctrl_arch_rmid_read(r, &d->hdr, entry->closid, entry->rmid,
>  					   QOS_L3_OCCUP_EVENT_ID, &val,
>  					   arch_mon_ctx)) {
>  			rmid_dirty = true;
> @@ -365,19 +365,23 @@ static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
>  	int err, ret;
>  	u64 tval = 0;
>  
> -	if (rr->first) {
> -		resctrl_arch_reset_rmid(rr->r, rr->d, closid, rmid, rr->evtid);
> -		m = get_mbm_state(rr->d, closid, rmid, rr->evtid);
> +	if (rr->r->rid == RDT_RESOURCE_L3 && rr->first) {
> +		if (WARN_ON_ONCE(!domain_header_is_valid(rr->hdr, RESCTRL_MON_DOMAIN,


This seems like a doube WARN_ON_ONCE() considering the one within domain_header_is_valid().

> +							 RDT_RESOURCE_L3)))
> +			return -EINVAL;
> +		d = container_of(rr->hdr, struct rdt_mon_domain, hdr);
> +		resctrl_arch_reset_rmid(rr->r, d, closid, rmid, rr->evtid);
> +		m = get_mbm_state(d, closid, rmid, rr->evtid);
>  		if (m)
>  			memset(m, 0, sizeof(struct mbm_state));
>  		return 0;
>  	}
>  
> -	if (rr->d) {
> +	if (rr->hdr) {
>  		/* Reading a single domain, must be on a CPU in that domain. */
> -		if (!cpumask_test_cpu(cpu, &rr->d->hdr.cpu_mask))
> +		if (!cpumask_test_cpu(cpu, &rr->hdr->cpu_mask))
>  			return -EINVAL;
> -		rr->err = resctrl_arch_rmid_read(rr->r, rr->d, closid, rmid,
> +		rr->err = resctrl_arch_rmid_read(rr->r, rr->hdr, closid, rmid,
>  						 rr->evtid, &tval, rr->arch_mon_ctx);
>  		if (rr->err)
>  			return rr->err;
> @@ -387,6 +391,9 @@ static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
>  		return 0;
>  	}
>  
> +	if (WARN_ON_ONCE(rr->r->rid != RDT_RESOURCE_L3))
> +		return -EINVAL;
> +
>  	/* Summing domains that share a cache, must be on a CPU for that cache. */
>  	ci = get_cpu_cacheinfo_level(cpu, RESCTRL_L3_CACHE);
>  	if (!ci || ci->id != rr->ci_id)
> @@ -403,7 +410,7 @@ static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
>  	list_for_each_entry(d, &rr->r->mon_domains, hdr.list) {
>  		if (d->ci_id != rr->ci_id)
>  			continue;
> -		err = resctrl_arch_rmid_read(rr->r, d, closid, rmid,
> +		err = resctrl_arch_rmid_read(rr->r, &d->hdr, closid, rmid,
>  					     rr->evtid, &tval, rr->arch_mon_ctx);
>  		if (!err) {
>  			rr->val += tval;
> @@ -432,9 +439,13 @@ static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
>  static void mbm_bw_count(u32 closid, u32 rmid, struct rmid_read *rr)
>  {
>  	u64 cur_bw, bytes, cur_bytes;
> +	struct rdt_mon_domain *d;
>  	struct mbm_state *m;
>  
> -	m = get_mbm_state(rr->d, closid, rmid, rr->evtid);
> +	if (WARN_ON_ONCE(domain_header_is_valid(rr->hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3)))
> +		return;

Double WARN_ON_ONCE()?

> +	d = container_of(rr->hdr, struct rdt_mon_domain, hdr);
> +	m = get_mbm_state(d, closid, rmid, rr->evtid);
>  	if (WARN_ON_ONCE(!m))
>  		return;
>  

...

> @@ -3065,26 +3078,38 @@ static int mon_add_all_files(struct kernfs_node *kn, struct rdt_mon_domain *d,
>  		if (ret)
>  			return ret;
>  
> -		if (!do_sum && resctrl_is_mbm_event(mevt->evtid))
> -			mon_event_read(&rr, r, d, prgrp, &d->hdr.cpu_mask, mevt->evtid, true);
> +		if (r->rid == RDT_RESOURCE_L3 && !do_sum && resctrl_is_mbm_event(mevt->evtid))
> +			mon_event_read(&rr, r, hdr, prgrp, &hdr->cpu_mask, mevt->evtid, true);
>  	}
>  
>  	return 0;
>  }
>  
>  static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
> -				struct rdt_mon_domain *d,
> +				struct rdt_domain_hdr *hdr,
>  				struct rdt_resource *r, struct rdtgroup *prgrp)
>  {
>  	struct kernfs_node *kn, *ckn;
> +	bool snc_mode = false;
> +	int domid = hdr->id;
>  	char name[32];
> -	bool snc_mode;
>  	int ret = 0;
>  
>  	lockdep_assert_held(&rdtgroup_mutex);
>  
> -	snc_mode = r->mon_scope == RESCTRL_L3_NODE;
> -	sprintf(name, "mon_%s_%02d", r->name, snc_mode ? d->ci_id : d->hdr.id);
> +	if (r->rid == RDT_RESOURCE_L3) {
> +		if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
> +			return -EINVAL;

The domain header check only seems necessary when needing to run the container_of()
below that depends on SNC mode so can be moved into the if() below?

> +		snc_mode = r->mon_scope == RESCTRL_L3_NODE;
> +		if (snc_mode) {
> +			struct rdt_mon_domain *d;
> +
> +			d = container_of(hdr, struct rdt_mon_domain, hdr);
> +			domid = d->ci_id;
> +		}
> +	}
> +	sprintf(name, "mon_%s_%02d", r->name, domid);
> +
>  	kn = kernfs_find_and_get(parent_kn, name);
>  	if (kn) {
>  		/*

Reinette
