Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35FB73BBFD4
	for <patches@lists.linux.dev>; Fri,  4 Sep 2026 15:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788537022; cv=fail; b=cLbIla++hqOx1k6+xF450WYTIurepZ0+oJyDWRFoGfp2tDJLbHWXkqCxhA8qCMqabmN5HTftYqCeVFgX3O6tMbUqpO0HIzDJd2DikpDxMNZlVbw04/vcJtxmJ6dMF74KZunXktBhMdFxbmcIpr+TECeQZepIMMNffipOiarVmjI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788537022; c=relaxed/simple;
	bh=A6FTTStyQv2QZqEjgD9wgHpOPCY8HWFjunEmNoYFJ94=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=VtY8D2NfM+GWqf53fOBQ+M4/JhXSAIgo12DT7TZoCh9afjFySxqBJccyRv7cc+QaiDLN+sojgScF+aJ46Ce5PWXcNFYO+maJdL++uUzolYHcUxtanjuQyGrbaP79eijXl0vr/ZPdzyWMZXEMTtpCW6dL/US0DZ6p7mZ9hrUpi5g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BQck+Q5l; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BQck+Q5l"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788537017; x=1820073017;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=A6FTTStyQv2QZqEjgD9wgHpOPCY8HWFjunEmNoYFJ94=;
  b=BQck+Q5ljThypDt9of8+w9IE4WfHbHbHkxDF8UBSlfP0qCoIpM5PpmNp
   bhYE5JwLRmJAZlVvV2nPlRAiR1UAwVn22IGji0cehW0hvkt69SRalUJnf
   C8w0i+qpFFGu2wvILhE6U1A/f3NxOmBMykp5pfQ4ihs6X2v4GgpHWzyZf
   LTiSzGQFNMNkqcAwMSg+MHvIgmJIZCPcA3+DaoPcb1+ymTOdR6I8oicc1
   Zh4NRqpFx27yL59go0eJ3eoEXROnVGDh5DrVOJEffGMLkK5+XUDtTohPf
   4s3w/6JL32z1cUB+zpgLgTb8MH/KeLeW3V98EKOCYos/732mBchGtg7+c
   A==;
X-CSE-ConnectionGUID: KM4+CJvZQ4ayymYLrEF8nA==
X-CSE-MsgGUID: rflwQ1udSnSHW+k6zjba2A==
X-IronPort-AV: E=McAfee;i="6800,10657,11895"; a="100201749"
X-IronPort-AV: E=Sophos;i="6.25,262,1779174000"; 
   d="scan'208";a="100201749"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2026 08:50:15 -0700
X-CSE-ConnectionGUID: u1D2SMKSSBmtMpeJrIpvLw==
X-CSE-MsgGUID: PDBSbJg+SZKStcUIfYLM4Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,262,1779174000"; 
   d="scan'208";a="269542128"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2026 08:50:14 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Fri, 4 Sep 2026 08:50:14 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Fri, 4 Sep 2026 08:50:14 -0700
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.55) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Fri, 4 Sep 2026 08:50:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MAYbpccBcTTk+wJJqBqKGwDeS5OBaA5yHWtYxY55z2drId3TnwDR7xDtn0LDSUUtgripeMyDPE5Ak+Dtu1p24tUT4LNgRV+PX1wik19K/MwdGGx5DBnotcB1dn7s9f43hu7GdHDrKBq/aIppk28kTuhs7oQAKVnsgMB6/or2q4plAo7nHoL+5TRgl5hjaUT20q3xviGmGIVrCz4KaOf68uIA6IgvtN86GXZeqz0bOPlEK05lRiODGZSYUp5xAEUmmDEuof0y8xi0P/S2hTewFP83/lunoe0ZzvWZlVuaqtNtFQgqTMX4HrNDqCj6rFkdDEIBF7BhfSDUMBEUI4ktpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KxmVd9EaEeAyxkM+87FBP78WIe8NAh353Oiv6gFbV+E=;
 b=xYB06IrOQ9TvCXZm3rbwOfBWPyu3lR9WJzeBwtU8BfeZ3RJWkS08N2stoQoDYMxFKmU5XfFTJ/PihKG0yZhPUDMikUOziibIHAZa9BExpOtogrWOkCkLmDyZcvF66ySKo2pbLZaIoCmJsnUZBUl/DeJf3dPajzOKNVDjOXnj0dCFgXUDzdn1WzSSoLD7h/tswP44RZ1X6N70KQcea+heFsBYVP9kToGDK+Q7+HqLZoYdNHY9SiE9JS2hbJ7pKZ3Hs/95EDLq0GsXAbcDTR8m9cHRFxpm85jzlIDXb5ZPsS5IfvvyWeDUL68ro+Mpi9iZojT+UMkTttcDqyvgZnhhJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by PH8PR11MB8037.namprd11.prod.outlook.com (2603:10b6:510:25d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Fri, 4 Sep
 2026 15:50:11 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0360.008; Fri, 4 Sep 2026
 15:50:11 +0000
Message-ID: <b5b1fb15-3a83-4b91-b9b8-8bc724e5312a@intel.com>
Date: Fri, 4 Sep 2026 08:50:08 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] fs/resctrl: Drop support for different bandwidth
 delay mappings
To: Chen Yu <yu.c.chen@intel.com>
CC: <tony.luck@intel.com>, <ben.horgan@arm.com>, <james.morse@arm.com>,
	<Dave.Martin@arm.com>, <babu.moger@amd.com>, <bp@alien8.de>,
	<tglx@linutronix.de>, <dave.hansen@linux.intel.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <fustini@kernel.org>, <fenghuay@nvidia.com>,
	<peternewman@google.com>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>, <chen.yu@linux.dev>
References: <cover.1788452481.git.reinette.chatre@intel.com>
 <9d39435847fb26fa7b467c563cf8bc45c314b917.1788452481.git.reinette.chatre@intel.com>
 <apo8AKv5XVggDE3J@fengwei-dev>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <apo8AKv5XVggDE3J@fengwei-dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR02CA0012.namprd02.prod.outlook.com
 (2603:10b6:303:16d::35) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|PH8PR11MB8037:EE_
X-MS-Office365-Filtering-Correlation-Id: b3ac320b-0aa9-4e09-ca15-08df0a9c33a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|23010399003|376014|7416014|1800799024|4143699003|56012099006|10067099003|5023799004|11063799006|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: Mml0ZUQqymKYGVquRcWLdgDHcIGtA8YiksMDoXw9ijaqiviv2OLSJDh/GntCvzec43xcX33kGaVlIPaQ48kJ5fkTk7IH9M7YphPwASLsNvUz+FUzK7wxwrYoji40haXAPrbIcqSU8Yc6azcmf05hsyC7h4+F48IuGR2/5BCNcK7aqPnTl+a3H6fFOrxQ7A4flQ+KvVqXPzNxDoJ1Y19ZkgtTxQ0cJf53Mc+/o/8XCjl7MVLY20ubi+s5S+QOhKaC3GoSjTQsZDNAdBCulGfOrk9DeacyzdKcYu0h9Hx6QjXs9tYtUh2zPXcP3SHM4IYkQw0rXiJlMEv7Alc0BWz9ey9yVyd4QxW8pbzIEaVbnTtds7OtuielrdRb10QeujVY9DHldn+ek4RCvduPFAbHcQo5SFNX6LJCpI7cIt5ay3ylUoa2luFccKNa+9W7zWKWVwj9CrJ/hdb91vv4u3nMHjLOePAstN0QdcnC3/u0ZZfiYpMmsDEg6iuLSx8xTyDAr48yXonXc9JI9A9APZTqSGC7O1NQvTT0LwCdNBXwERRLEaTzBPKWwzwqbmXEvDxIrTc4FrdJoW4sGSN5CrBz1pdHj9asJDWwyd//i2MZg1Uudng+pFvK+gRFli5uNhkvdKPJ5IOmEMF6bPMf2aCIjZLt0rUqAiOUOnGLdy1w5jU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(7416014)(1800799024)(4143699003)(56012099006)(10067099003)(5023799004)(11063799006)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SnRKTzJ2RnN4WE92enp6amozK2Zndk5Nb3pPVi9BQk1yUHpvZ3dGTjBZZGJk?=
 =?utf-8?B?S01VQjVKa0d0VFZtQS90L1c0dnhvQ0xvWmgwUGkyZGdXUzR0S3RtcWg2cnNO?=
 =?utf-8?B?M285dzZzbVRDMHBGZy9ITGZ0S0htbEZSTnJJUjEyNzlNU1NJdWFxRzVXRjE2?=
 =?utf-8?B?NmpKSUtUdnprUXVITnZwLzc0ZjZkaTNtU3RxVjhtYWFUUmFSZm9CMUZncUgy?=
 =?utf-8?B?bitZcXFndkxtM1FBRElMSDlEUUJTNE1MUDM0VXkxUkN4RmNvM09DdUZCYUZi?=
 =?utf-8?B?aWk4UGR3VjFySVo3M0hhWGl1NGgyZjIvUTJETUxjNFcyRWM0ckxFUmFSRE9v?=
 =?utf-8?B?ckdXRklCNThSdTdZc25Ba1RFT3RiUm85L1BaM2oxY1htS3I5TlNOaUhERElj?=
 =?utf-8?B?MktXV0lPSC9GdFM0c0MvOFlzaHFtaWdlL0x2UG5VYVoxQTZFUWR2cG83OGdX?=
 =?utf-8?B?c3k5QWdwUFFwUHNoSDh0RFdrS1FHL1dQVkQzRWhmNGZ4K24xd1pmR256SzNT?=
 =?utf-8?B?N0orY254emlTMEhFeHB2Skh0UUxVaDNIcHUybUxzb3lCZ3JVN0l0TlU4RStV?=
 =?utf-8?B?Rmp1UnJwQ2RQMEF4aFliNmRZSXhNMjZ1RzYySmxoY3F1alFRRUdFeUZreU54?=
 =?utf-8?B?MnBvQmxnWEN3MitIall4Ukt0dnh2K3VqNVIzSFlkbEVuZUZLTEhaL3BFa0Vi?=
 =?utf-8?B?cllxNzFGc2tXSEh3SnE0TTBDaTJRTVhsMXMyWVEzWGZFOUtQWXZ6Q2tBVVZ3?=
 =?utf-8?B?QThjNStvMVpWa0VGRnM3YytpWGY0ODVadVNvYTU5b1FOcXY5NTlZZW13Yyt2?=
 =?utf-8?B?cXZGeDNtN2NqOHFTMXdoVUsyQm1LTC9jc2paTmhsRE45TFJIS1JucVN2bmd5?=
 =?utf-8?B?R00veThncDZGcmhMd0k4NVprdVdveWxJYSs4R1JtQVdjOWh1MVEzNHlqRTF5?=
 =?utf-8?B?Q2pmRlExQ1lYYnE0NE0zdDM3N3U1bCtDY2huOXVrdTh0eE8zQjcrTmxSYTM1?=
 =?utf-8?B?b1dXN1ZaeHFaWHpPVUl5S3RrN0tFcDhzcWw0bmhRRS9SUFBTVTYrcGd4WVFn?=
 =?utf-8?B?WTJ4Q09DVjUzR0Y4S0JBYWJ0M2t1WVM0R2loYWc4MHI0emxpa3J0K2laTlJl?=
 =?utf-8?B?Rk9NeEU3NjhyVlJ0MU11b3ltMXptY0FGL3RqbXZCcUQxWWF2TS9YU3lnT2Fx?=
 =?utf-8?B?b0dib2QwY1FWY2lRWXVwNEhjc1pMS0ozVTVRclFwQkx0UVQzMGpDM1BqZW11?=
 =?utf-8?B?TStiTFFYbmtiV0FOQzJ5TktDSGdNK1lSQ0MyQnlNdDY2QTMzKzJ0SFkxMG5F?=
 =?utf-8?B?MzdjcW9RRnRTUDdTcWlVQWV6Z1Q3Mm1jdEF0STBMZ3RDaWpQOEN4aG9PVEl0?=
 =?utf-8?B?MXdxRmYrL3ZJdUpNU1JwZGQ3ZXU2TzFRMngvdGU1RHlDaTdFeC93a1I4anA0?=
 =?utf-8?B?eUlzb2hucHFEVkl0a2hOdlhTOW16Z0dQVm1aS3crZnY5RlN2a3VjYkh6TWZT?=
 =?utf-8?B?UWJXM3RKSXhhaTNTS01pRU1kVUxRSjZFTVJ3UVl6T0lWcVlVaUZLYU9Dd0g1?=
 =?utf-8?B?UnpwUkozUVJxcmc0RmczRUhEbzRKKzBBRHR5YVpBR2F0MDVPc2t4NFJma2Fv?=
 =?utf-8?B?T0psU2xJSENyVUxQTGFCenpXRVhZTnFIK0hpYzMyRmdkQzZISWRxZDF4V29h?=
 =?utf-8?B?N3BiTVVkN21Ncm9Qa1l6ZG1DdGljS3k0RW1CVkpjZk1SNzFqVjNjQ0xxRzll?=
 =?utf-8?B?bkdiaGttN3U2VXAzdXNVUTdWWXFBWkFnRHU1dnpMaTZTdlh6M3luRGdnM1lT?=
 =?utf-8?B?QlMyMkNOSko4eE9OYVpLT2NRemgySlBoNitFOWFoNUprdEEwWE1qUFFwWE04?=
 =?utf-8?B?U0pva3ZFalFmOTcwUjlSbE9USjlZTkVrYTU3aENDODdJWWJES0xXZmZwTTUx?=
 =?utf-8?B?cmgvZTdBVXNFQUluU0pyem1IT3F6U2MyQk5yQisvU1NpcVl3cTkyZExpakMy?=
 =?utf-8?B?YkR5cVRKRlkwaFU5QVUrU2R6VjZvTGRGSmVObS8wVHExMm8xUTVwTHFiVkxB?=
 =?utf-8?B?TWNUdlgva0crd1pzMlBrZURZN1dYNm5BdHI4NXIwem9IUVlFdlk0SGszUlRV?=
 =?utf-8?B?cktDZ3VubFB3VlV5U3RUSkFuWWxhcTdlVTVBZlQyNDNjUk93UzdFaUtqYlJ6?=
 =?utf-8?B?RHpTaTE4MkF4WWdzSWVwRmNsWUtlT2xVeDZxaHNsM0g4eVVveGpvOFB3aG00?=
 =?utf-8?B?L25tSFRXaUUwVGQyR0R0d1M2cUN0aG5ob1hZc2lndVNNdCs3elo3WmI2ZVBN?=
 =?utf-8?B?VDZ2TG04aFhRa2JpR3l5ZWh1WGdPU3NycUFuZUlTY0gxL3h1TjIxMlp5SS9U?=
 =?utf-8?Q?CKLEsjf/VtHHMMf4=3D?=
X-Exchange-RoutingPolicyChecked: av/KPPj8/Hvw3zfdibFGOQGwINqVdxcT+hUq9CGuG/ymlfv9qh1ThlI6d8b0UQEmKAX431PhhvP+4gkJ3BCbfHfD9ntSCO8jxJLUk3L6UY5F6TE8VtoMlmJBVnD5gOpXayOEDdd5XnfmSY8IHsZdheH1mgboT+1s7CxrYgofhaQbjKwEVyhn1RJtlNHcCJ8jLDDpZldMHUpC5Y8hZy0L73xfy8PAVgBqq0FjSMKloCzGefLTX9NqeGEsEJf/w/RRu+DrkElfStrZJgq1Pz1DEDIMoT0+CDNwAuzWAxB4pEa96KtrO0xSPkt83hDIOH7WxKTQTteT03/KFvLQ66pCNg==
X-MS-Exchange-CrossTenant-Network-Message-Id: b3ac320b-0aa9-4e09-ca15-08df0a9c33a9
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 15:50:11.0197
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4YDnz9nRKIjsOYNdD9y97st7kkmIz/y9YKpf2ykk2ohB2wdfZUJbnVGJ3W0Oe1MpTHxmjnhmSZeuacfXegbi1JzdoTnu13nD/w7fmtvkCwg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB8037
X-OriginatorOrg: intel.com

Hi Chenyu,

On 9/3/26 8:33 PM, Chen Yu wrote:
> On Thu, Sep 03, 2026 at 09:57:03AM -0700, Reinette Chatre wrote:
>>  
>> -/*
>> - * Map the memory b/w percentage value to delay values
>> - * that can be written to QOS_MSRs.
>> - * There are currently no SKUs which support non linear delay values.
>> - */
>> -static u32 delay_bw_map(unsigned long bw, struct rdt_resource *r)
>> -{
>> -	if (r->membw.delay_linear)
>> -		return MAX_MBA_BW - bw;
>> -
>> -	pr_warn_once("Non Linear delay-bw map not supported but queried\n");
>> -	return MAX_MBA_BW;
>> -}
>> -
>>  static void mba_wrmsr_intel(struct msr_param *m)
>>  {
>>  	struct rdt_hw_ctrl_domain *hw_dom = resctrl_to_arch_ctrl_dom(m->dom);
>>  	struct rdt_hw_resource *hw_res = resctrl_to_arch_res(m->res);
>>  	unsigned int i;
>>  
>> -	/*  Write the delay values for mba. */
>> +	if (!m->res->membw.delay_linear) {
>> +		pr_warn_once("Non-linear bandwidth delay not supported\n");
>> +		return;
> 
> Previously if linear delay is not supported, we still write MAX_MBA_BW
> to MSR, and here we return with MSR untouched, this should be the expected
> behavior?

I believe so, yes. Two reasons:
a) This is not a supported scenario. This code path should never execute
   and already complains loudly if encountered.
b) In the unlikely case that this unsupported scenario is encountered I
   find leaving the hardware as-is to be the safer option.

> Besides, in patch 2, __get_mem_config_intel() returns false for
> non-linear-delay platform thus MB resource's alloc_capable is false,
> do we still need to do the linear check in mba_wrmsr_intel() in patch 1
> as the code path will not be triggered?

You are right that the check is not required. I view this check more like
why we use "lockdep_assert_held()". More specifically, it uses the code to
document the requirements instead of comments. For Intel this is valuable
since the transition to controls and their flags means that when a developer
builds on the new resctrl capabilities to initialize multiple controls it is
required for *each* control to have the "this scalar is linear" flag set. This
test makes that requirement clear.

Reinette
