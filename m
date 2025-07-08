Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40063223DE8
	for <patches@lists.linux.dev>; Tue,  8 Jul 2025 23:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752017202; cv=fail; b=Pm3AjEOS+jA1m7o1FUyzFvvQORY1RIRrnEslkiG7YYxIddu2dq4hgwqWkgG6KZK+KTv9nWEeyz8X4+Z+4xQNfxkjIYnGkZvN1776wyKROWY9Ha3NUl3EQ6ZummwM+QWO0ZzOYxHNm4o1xenjfOVd02L5XT3qJ9fS4qQMlNl/K74=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752017202; c=relaxed/simple;
	bh=JOGqwJOJAngGjPeaseCCuxrzJjmajpwBcjhdyU4CN7U=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rXUZ3G3zexBHim43agBMKwUoJX4TgI3oaSoyzeJfZDYow3UrWyX9avUExHHs8dCkshg8lTRaapzMJRLIGku1vuZX5992yIIhmFV7FOeh8z+24vmy9/hxNFs4resr10pB5rMYFfsGiqAFbNM9XKW3GEhI3P3m44tPMpR5lRsYcXQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YEpxeK79; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YEpxeK79"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752017201; x=1783553201;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=JOGqwJOJAngGjPeaseCCuxrzJjmajpwBcjhdyU4CN7U=;
  b=YEpxeK79Afue5y7q0L3F3g/FDzf2dMSyj+6Phy/F9hrpdva25V/ufphP
   zdV1aXSIumit3aD7iwon3xXIGU2ByPSllJ9gjDi05j0bzMD6hdD2yWKD0
   frOVToo5sKYi82LXA2zhA2er86ZBG2rg7JfJLlx98LAVf+GbnlhyrK7IT
   l49ENTE0KNOMT6OC8yzQaLTMUppKgs9So/nvMgQTyebp1RqcyOINZ+R6m
   BR3zmw8Z5wjEQrN3xrc6MjD1AdbB8+EmitpuzWBmGZwL9ELlkCTKQkDR5
   7eO9gmikyi8VS41cRpjoa55MR+AmP5RmijxHkIgmXkRCdzHd+BUGIR+nW
   w==;
X-CSE-ConnectionGUID: +lM23aLIT/mBjbj276Ilug==
X-CSE-MsgGUID: TaiNasAFTpCO62UX28OQ/A==
X-IronPort-AV: E=McAfee;i="6800,10657,11487"; a="57936674"
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="57936674"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 16:26:40 -0700
X-CSE-ConnectionGUID: 6EShYk0MTAmBFSLQKuO4KA==
X-CSE-MsgGUID: ABFzQoYHQdCDCNwclIQcIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="160150761"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 16:26:39 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 8 Jul 2025 16:26:39 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 8 Jul 2025 16:26:39 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.48) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 8 Jul 2025 16:26:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XlztcAEVQ/8MZXGuxWIqmzl3EfSaDAuxPmgpMiEHIl2eN29xalwTqXyZdOPKIK0TzABNdEpJ15pEECgm2AtCSe6Ippc4FTZC0UuBDr6lH20EygA2btmJxypuXY6z3T3OAeejoUHOYmw1QAtrAvcLyS4bm8hroa/wcz7PPmU1U+dBZmhKyXLpo7qmf4G4PrFqM9O1rf5PjfIjtf5RdmnH8iSHdMPgyM2qXW3IKANxB1E1Q2ohW+xc7ueoOOTebgo2RePVxfmtDDmsrSSbScv66zEkmmB5O/YituuMP30nbD2NFJBQYmDj9mIaKti+Tzyt7T+fZBIYLrovweTJVy5Twg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FgaVr2jeizyGnkbCYYsLMNYEwH6moRrBo3oDTkdqRAk=;
 b=vcSaHZoCHMRbiUIbzompopvK8vixGrYP4eo4ZNm/RP0rzXWZIO71AHPiFG67aPiXTYQpWssEPWmh8XhciV2jl2oG/dj5a5BIHKo+m6SPF3UQDlIrXmyuTfbHq6llZMQKo/iBAVtC6PyZi1f8Nbg3Y998bcYM+b62JLv6l0BsLBIV+/E1/+OjyZRxsatYo54OE7aor0hGg74aaXSpLQ9J7LqY1fEKpxQXv739fJEnlMcRud+5qYtiuc6ZUYiYZu9i3MAV0k9kgf1dvoD+YRnU3Q8wJRuTffEc0QVZTW5VnBmShNf8mffGsfPduTeozuv/Kjc7UKtN9q4UF8ul5NM1ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ0PR11MB6767.namprd11.prod.outlook.com (2603:10b6:a03:47e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.26; Tue, 8 Jul
 2025 23:26:37 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%6]) with mapi id 15.20.8901.018; Tue, 8 Jul 2025
 23:26:37 +0000
Message-ID: <577e508e-d66a-4413-98c5-02ae7c830470@intel.com>
Date: Tue, 8 Jul 2025 16:26:35 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 00/30] x86,fs/resctrl telemetry monitoring
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "Anil
 Keshavamurthy" <anil.s.keshavamurthy@intel.com>, Chen Yu
	<yu.c.chen@intel.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250626164941.106341-1-tony.luck@intel.com>
 <b2de4c92-a883-40b0-92e0-16fac9e386b0@intel.com>
 <aGa8Pg9pSCJ3XjtY@agluck-desk3> <aG1sqKBJSfHydDsx@agluck-desk3>
 <5b2d621f-459f-463e-abc6-9157513f1fee@intel.com>
 <aG2fBp5VojStKcCd@agluck-desk3>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <aG2fBp5VojStKcCd@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0070.namprd04.prod.outlook.com
 (2603:10b6:303:6b::15) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ0PR11MB6767:EE_
X-MS-Office365-Filtering-Correlation-Id: 44b6e756-e0f8-4c4f-766a-08ddbe76e29b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?dWVGSHRQNTNHMXJTZEZneTJseWUvV2pCY09xS1lwbk1namJkVExITHNJdUxV?=
 =?utf-8?B?QVI1NU9xbFZjeVpzT21meEpSN0F0MkpYeGpGaWthRDBUT0ExemlnMys3cU1t?=
 =?utf-8?B?NEtodnJaMllWdHFqZkJJSFBmVm4xcEpUVWhWYXBOVlIxWDBpNm9xU05hYzZR?=
 =?utf-8?B?ZXp0L1d4bGNJSFN1elhCbmZoMjRTRTJZV2ZZUVM3NElEZ2YvajhjTzdlcjhI?=
 =?utf-8?B?cDNLZ0hEWFlERFljcEFxeHlCWGJkOTk4Q2FJdWw5dnc2QkdzTzUvblBvZzU1?=
 =?utf-8?B?czZDU0x0QXlDVjdMaGh5WjVtSzE4SVFzZUdOK2t0amhFcGFlMzNvK1dGYi8x?=
 =?utf-8?B?cFJJWm5CM3U1Si92c0MwdzJVRS9zWWlyWENxRXdHSC9CUjlORm9qV0s3WlNr?=
 =?utf-8?B?SEZNem9MUncyWitGR3J3ZUZlNVBRMzhNQjRTWVZaZ0ZaaHhydU80azhISTNC?=
 =?utf-8?B?NkRYVEdmSFJRZGQyV3krSGtoVElMNEh6Rkd5OE8zWXJmK1lTNHI5UkM4TmFJ?=
 =?utf-8?B?RWRjbUFwQjdWbDdURzFUL0h2dldEQWU0RWVZTi90dGc1ZjJQUG5MYk0wVCs4?=
 =?utf-8?B?amRyT0dzc2RmYWIvOVhNa3dxKzh5ZERyTGFZdmNJYXk4d1hJaGNmeWlQMkVC?=
 =?utf-8?B?NkxqMHpXZEFJdDBoR2NKY1NoTmE4NDIrUFZPakJiZ0RrUlJWd0xoVDZwODhm?=
 =?utf-8?B?VnNpd3RVZHVsT3pTdFhtdkNDZXpTOUEvSjRaU0VGNXlLRXNpZE5FRXJyYTYy?=
 =?utf-8?B?RDVzVE00WU9LRThkbzBNWk5samZBZkJkUXlDN1lIdURWSWoxZ3orS0g4R2VY?=
 =?utf-8?B?YnBtV2tKVWl4TkFUSThqM1ZXVTNGWGVwV05ORnQ3dUx5OGhuT2RCaUZxVVU5?=
 =?utf-8?B?U0FwcTJZSDlWSnVGNStrV1JaSkZtTURQZGZMVENjSEVsRzNNbWp6UFN5VDc2?=
 =?utf-8?B?bHF2dGt1SEFGT1g0YmJlZFJKOXE4cVNvOFZZMlp2eXd3ck53bUgrYVlzcmtD?=
 =?utf-8?B?cFY3NHVtMnRNeEdhVFhFZS9vdlFKZmNQWW5QZ1NNWnVpWWVZS2R5Nkh5TnMv?=
 =?utf-8?B?UndXaHlBTzA5Mkx6V2s0NG1zelQ4VXRuTlBCS2cvRzhtWXhYNUw5alRxa3d6?=
 =?utf-8?B?Q0xKS1VtY2FBT1VKMkEreU41cDZIanRsY0hRcHpndEREc2o1QnJoM21OQ1Y4?=
 =?utf-8?B?Qmh4MU1FSXJsQll0aDE3QmhnZ0JaQjNzV015QTlwMUcrRjR1SFdBSytZNHln?=
 =?utf-8?B?RXViaEIwU0hNdW5EbEFLQWk5QjQ5NHJrK0hwRmNSZTdMUWVOQTJaZzU1OGV5?=
 =?utf-8?B?MDZxU21paG5qS0NEVE9LQUNDelBOUUI2MWJ6c2x1bUNSejA4VklBVU9Qb2JV?=
 =?utf-8?B?UCtjWFdBTTR3a2oxdEZSbU9CZFdXNnc3aFRoYm9DVFJtT044ZWZsUTJtTTVv?=
 =?utf-8?B?YTZ1eWpiL2ZEZWZlUkIyaW5kNVZRV3FBREdMLzYrVW4vcjRmcGV4ZEdBdnh2?=
 =?utf-8?B?aFJCSmQxUGxkelhJQW9hOVFremFnNktFalE0TXZFTldTcER2ZDlvYURkUksx?=
 =?utf-8?B?VVlBaDNzSHoyRWlUNEZ5cFdBZHZ2WDduTkd4djgzRTIxMzJPaHdDMXhXRVp6?=
 =?utf-8?B?cWRWSlJndWNzNm5mSzluTGZ4Q3F4dEZCa3BOem9aN2dkQmdzRUJHeHIrMXdv?=
 =?utf-8?B?Y2Fxa2lsRG9BVXF0TUZDNE1KaUJuZE1tYTR2eHdOVWZGaTBsdkJjdWFncG9p?=
 =?utf-8?B?WlRGcC9UeXMvb0lKS0xwZ1VBRnNyVU9nYWFFWFdyR3V5OXFDNDhKRGFvaXJP?=
 =?utf-8?B?RzQ2UHVTV29vMElNbUg0VEpQeXV5TUkwc2xoMEcyMDlqdG94V290YXo1NUNK?=
 =?utf-8?B?TmtnbElibDJtR2FvWGlCRFUxbmhzaVp3NENSNUM1cVcramNJZ21WNkZBNjBS?=
 =?utf-8?Q?EvCkI7SEfH4=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?alZFaW9pMEN2K1NTRkpteXZ0YXVFTDJqcGFXVy9KRThMWmVRQzV5RGVZcm5V?=
 =?utf-8?B?cGxDMFRRYUllQUdLMXNId2dMcTZLZ0xZVXJFUzBqSEROa1ZnQ1JSeFR2SXVP?=
 =?utf-8?B?aVFaNlREVXQ3Y1psT2t4cStZOWFRbGxua2lwNVI3bUh0SG1iL0V1Yld2bUs3?=
 =?utf-8?B?TDBhNXphZEhTWWgzNHlaK1BkYXBVMjBieExNcFpjY2M5NXVJdWRyeUx1enB4?=
 =?utf-8?B?OENmVzBDeUprbkk4dDloTDVFbFArYk15UGlKUVkxQW56U0duTVFFNEIzcERh?=
 =?utf-8?B?U05wOHZyQlU3QS9LL25NQ2IzaDBkekt2OGJ2UEJXMGdQSXlmQjQzZ0xVWERV?=
 =?utf-8?B?OFV0eHVjaDN1UHkydUh6TDF2WFhnTitWUUsvTHRhZUR5MG1RTS9OSEZHUnB6?=
 =?utf-8?B?UkJUTFNETTVvRHlsREtpNXFZZzgwSWIvWU05SmxTYWFlZ3paWHN2TTBWZEhQ?=
 =?utf-8?B?NWlsWm9WSXdrMU5ZaDFSeTRYbDQ2M055ZkxDWnR2cjJoUFZMbE10di9DOG9U?=
 =?utf-8?B?M2QwbXIzSFh6ZnMvU2QwSk9UZVdLcUlTOXV3WnFjbmYwcHZWU2VsRXZ6QStZ?=
 =?utf-8?B?VkovaGZpOXRTWWhIcVVNM01ZMVNlVFI3ZFdOV01xWElFT1pmTFdldjlqSzNr?=
 =?utf-8?B?YUdON2JkVTdyanppWCt2a1FlS293WjJWS2kvOVpSeWw3aUdRanYxTXliYVVO?=
 =?utf-8?B?dTFPVmJ4TDZjZVJTczVuVU9qY0ZHb3RhMmphc05oU3ByU2VuN0J5NmtlNkJO?=
 =?utf-8?B?SFNrNUtSRitxZ2ErajFpWWxhVDkxNHdjTzRSUnk2MmlITlNuQjlFS1Q5bXNq?=
 =?utf-8?B?eHBiQ1g5cUp4ZVJ4MW4yd1RKUnFqNnFwQStBQ1h2QTVkTktwMVBkUFRXNnpD?=
 =?utf-8?B?NzJtak5aeUdLdmkxUzNzQXlPRGdsSmRoeHdkOEZrcG0za3M3czQ3SnpZZHh3?=
 =?utf-8?B?cThLMFlwNGpuZXNBRElsRERLdVJaVlppSTMwbmVEc3ZTRHZGSTgzbEx3TFh6?=
 =?utf-8?B?R2JDcUd0RVFUZ1VmWFltM2dEb1F6aW1ibVZnSlZyckZjQVhNUE5Hc2tQbGpX?=
 =?utf-8?B?YWwwQk9JZGNQUG5hdk05RklUaC92MFRPZ3B3b0JGakZiZ0NNdElzK3FYdWoz?=
 =?utf-8?B?TFFUQ2xYVFl0SytYUlJvcGFsQVdsTUFOaHRGZWRyTEFkaHZYYlVUVFBWQUJi?=
 =?utf-8?B?L0Qrb1VpcTRpWjdHMXYzYnFNQ3MwR2ZxWGFGM1E0azNtQTRaS3E1MHVYU1VK?=
 =?utf-8?B?SS9DUEpLOEIwM1NYZElDVkVyTlpjc0tmZWhwcmtwUmllWEl0K0V2ZXlpbXlG?=
 =?utf-8?B?YXdwcHJpTG9hTGRPeW01eTVEeHR3bTROWjFuYm5sRkgySjJTaVlSUkdIVXFk?=
 =?utf-8?B?NjZGc2t6MzhTZGVaa1I3UWZwZVBlcGJCWUgxbERMcGRvNDFCUmtVSFp5UmZq?=
 =?utf-8?B?emk1SHdwQWZNWFprT3BBeG93dXA1UnpIbE5SWjQxVmtxaWFPdU44S2RYTWJG?=
 =?utf-8?B?MlpJMXNBbGl4S0cxanNRL09US0o3cGJNOFdwZHFFeVZtUWM3dDhyZDdyUldm?=
 =?utf-8?B?M0JIWnFTcmxvRm1LdldyLy9MZ1h3Ykt2S2VjOWJpWEZhQWJmdnNpTXRsSkdz?=
 =?utf-8?B?OERHVnFqckdaQlRTWFZTRi9Iejk4dnRqczA3Y0d5R01TWmhMUFZwb2syUElK?=
 =?utf-8?B?VGVyd0NrSjFtY0FPVTI1ZlU5ZENHYzlvZDZJeXZ6RTExUmFtZ1BtTUR0R3F2?=
 =?utf-8?B?ZmlyMVVPdmdMbUNDWStMMm5NRGxRanNXdDdkQ2hGSkh3Ym4rQWJZVGhOUUdy?=
 =?utf-8?B?aXE3Sy8vY3ZlOEdZaG90YzQ5aStWekhMbmwyQkhjQ0h1MDNiUFBuQk1ueVpZ?=
 =?utf-8?B?NklHanBvMjF3MG5VeDVnMmY3eDNLNmJ4NTlUUGM3b1ovQWJqVEFMdmtvaDgr?=
 =?utf-8?B?Ym4rY0QzK3dxeU5VaUNwWVlNQXUvUXpFdUZzc3dYSmNNa1RoQytaK1FvQUFP?=
 =?utf-8?B?SHNRa3I0eTNFY1h1M1BMV29uOUZJOVNnQlhIalZMeGFDbDRyTmI5bWoxK0Jh?=
 =?utf-8?B?by8zVS9MbDBUb2JiV2ttSE8zR216RlVvbVM2eWR3UFdLb3JIcklUdWdKL1U4?=
 =?utf-8?B?bG1RRTlWUitwMWpVTlI0Q28rT2x4KysxczdHTEdzVFJRU0prYlE2Yjg1OFRE?=
 =?utf-8?B?bWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 44b6e756-e0f8-4c4f-766a-08ddbe76e29b
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2025 23:26:37.5949
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aQre31+ahSf367E9zVWKaQLnphiNYUiTIDGjBiN5wNq3uSjJW4To55SoXzGJ+NGZsk3YckBDexS5ucdqL/Yg5e3wkK9FmO3/iJl95t7w/sY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6767
X-OriginatorOrg: intel.com

Hi Tony,

On 7/8/25 3:43 PM, Luck, Tony wrote:
> On Tue, Jul 08, 2025 at 01:49:26PM -0700, Reinette Chatre wrote:
>> Hi Tony,
>>
>> On 7/8/25 12:08 PM, Luck, Tony wrote:
>>> On Thu, Jul 03, 2025 at 10:22:06AM -0700, Luck, Tony wrote:
>>>> On Thu, Jul 03, 2025 at 09:45:15AM -0700, Reinette Chatre wrote:
>>>>> Hi Tony and Dave,
>>>>>
>>>>> On 6/26/25 9:49 AM, Tony Luck wrote:
>>>>>>  --- 14 ---
>>>>>> Add mon_evt::is_floating_point set by resctrl file system code to limit
>>>>>> which events architecture code can request be displayed in floating point.
>>>>>>
>>>>>> Simplified the fixed-point to floating point algorithm. Reinette is
>>>>>> correct that the additional "lshift" and "rshift" operations are not
>>>>>> required. All that is needed is to multiply the fixed point fractional
>>>>>> part by 10**decimal_places, add a rounding amount equivalent to a "1"
>>>>>> in the binary place after those supplied. Finally divide by 2**binary_places
>>>>>> (with a right shift).
>>>>>>
>>>>>> Explained in commit comment how I chose the number of decimal places to
>>>>>> use for each binary places value.
>>>>>>
>>>>>> N.B. Dave Martin expressed an opinion that the kernel should not do
>>>>>> this conversion. Instead it should enumerate the scaling factor for
>>>>>> each event where hardware reported a fixed point value. This patch
>>>>>> could be dropped and replaced with one to enumerate scaling factors
>>>>>> per event if others agree with Dave.
>>>>>
>>>>> Could resctrl accommodate both usages? For example, it does not
>>>>> look too invasive to add a second file <mon_evt::name>.raw for the
>>>>> mon_evt::is_floating_point events that can output something like Dave
>>>>> suggested in [1]:
>>>>>
>>>>> .raw file format could be:
>>>>> 	#format:<output that depends on format>
>>>>> 	#fixed-point:<value>/<scaling factor>
>>>>>
>>>>> Example output:
>>>>> 	fixed-point:0x60000/0x40000
>>>>
>>>> Dave: Is that what you want in the ".raw" file? An alternative would be
>>>> to put the format information for non-integer events into an
>>>> "info" file ("info/{RESOURCE_NAME}_MON/monfeatures.raw.formats"?)
>>>> and just put the raw value into the ".raw" file under mon_data.
>>>
>>> Note that I thought it easier for users to keep the raw file to just
>>> showing a value, rather than including the formatting details in
>>> Reinette's proposal.
>>
>> Could you please elaborate what makes this easier? It is not obvious to me
>> how it is easier for user to open, parse, and close two files rather than one.
>> (more below)
> 
> I had only considered the case where the format does not change while
> the resctrl file system is mounted. So users would read the "info" file
> to get the scaling factor once, and then read the event files with a
> parser that only has to convert a numerical string.
> 
>>> Patch to implement my alternative suggestion below. To the user things
>>> look like this:
>>>
>>> $ cd /sys/fs/resctrl/mon_data/mon_PERF_PKG_01
>>> $ cat core_energy
>>> 0.02203
>>> $ cat core_energy.raw
>>> 5775
>>> $ cat /sys/fs/resctrl/info/PERF_PKG_MON/mon_features_raw_scale
>>> core_energy 262144
>>> activity 262144
>>> $ bc -ql
>>> 5775 / 262144
>>> .02202987670898437500
>>>
>>> If this seems useful I can write up a commit message and include
>>> as its own patch in v7. Suggestions for better names?
>>>
>>
>> I expect users to regularly interact with the monitoring files. For example,
>> "read the core_energy of group x every second". An API like above would require
>> a contract that the scale value will never change from resctrl mount to
>> resctrl unmount. I understand that this implementation supports exactly this by
>> allowing an architecture to only enable an event once, but do you think this is
>> something that will always be the case? If not then an interface like above will
>> require user space to open, parse, close two files instead of one on a frequent basis.
>> This is not ideal if user space wants to read monitoring data of multiple
>> groups frequently.
> 
> While hardware designers do some outlandish things. Changing the format
> of an event counter on the fly seems beyond the range of possibility.
> How would that even work? A driver would have to rerun enumeration of
> the feature every time it read a counter. Or hardware would have to
> supply some interrupt to tell s/w that the format changed.

There is also the new direction of resctrl dynamically enabling/disabling
hardware capabilities to consider. Here it could be reasonable, since this
would be triggered by user space, that a note of "doing this may change the
format" would be sufficient.

Something else to consider is the possibility of hardware using different scales
in different domains if the packages are not "uniform". 

> I think it reasonable that resctrl be able to guarantee that the format
> described in the info file is valid for the life of the mount.

I'd really like to think that it is reasonable also.

> 
>> I would also like to keep extensibility in mind. We now know that
>> unsigned decimal and fixed-point binary needs to be supported. I think any
>> new interface used to communicate formatting information to user space should be done
>> in a way that can be extended for a new format. That is, for example, why
>> I used the actual term "fixed-point" in the example. Something like this avoids
>> needing assumptions that a raw value always implies fixed-point format.
> 
> This is fair. But could be covered in the "info" file with some more
> descriptive way to describe the format. Perhaps:
> 
> $ cat /sys/fs/resctrl/info/PERF_PKG_MON/mon_features_raw_scale
> core_energy fixed-point scale=262144
> activity fixed-point scale=262144
> 
> To allow for other types in the future.

Note that the filename still has "scale" in its name making it specific to
fixed-point. 

It may be expected that every entry in mon_features has an entry in
mon_features_raw_scale (name TBD). This means the existing possible "mon_features"
need to be accommodated (except the _config ones). This may also be an
opportunity to introduce the unit of measurement. For example,

 $ cat /sys/fs/resctrl/info/PERF_PKG_MON/mon_features_raw_scale
 core_energy fixed-point scale=262144 unit=joules
 activity fixed-point scale=262144 unit=farads
 ...

Reinette

