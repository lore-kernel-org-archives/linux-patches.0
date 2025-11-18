Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2272234D927
	for <patches@lists.linux.dev>; Tue, 18 Nov 2025 16:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763484508; cv=fail; b=IRll8woQJ3JLURJl/l5wXGnra1n8e17DFkzpWOaVEiUcXgG0DLYXrVX4YUOxiN5jLvK1A/zKQonbOEQI4SJsa7yT/V0a4wY4kCPS0MeQnVrn1ullN0iB7oT1OFWLkXkY0VMd5jTYxCJOd+lOURbF+hALpKKyAp579hhRHsg6YIQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763484508; c=relaxed/simple;
	bh=vbW6RhDDMVxlFGrXGkMBNymYoKEGwxvdEA2EiriLs4I=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=n99Qu3c17jpo1AITyD9zH//0xEgleOlh/rHWVql0TW1BDqkFgDCx5Vmb/IVgHNzu8i0LloU8ztiXu5+eSFz2cShDPSQSeROEohQrN92H3mDV2cZZYwuZc9o3DpsLBpmEouQHPRRY20MCqFgZ9NUKKU5Jn0+ky7p+hHc2WPsCOUA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MbNPGNez; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MbNPGNez"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763484506; x=1795020506;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vbW6RhDDMVxlFGrXGkMBNymYoKEGwxvdEA2EiriLs4I=;
  b=MbNPGNez7bVJTUWrqPq1pFaD99GRSQveZQihGYQwc/yxmOehg/fc8tFa
   +iHqqVulB4ffNToyGMZkoUwdLOBLfek4ASzSVVhXnhWG5vBxDtqa6/Mqm
   jGCsdPvc5LMLtttM7Xhn9nFy98S/Wr4XHhzrzB1Ci4QRQlY9lfEaojt/i
   0t/5u4vtRpW27ta8eooSqDKa9HP6i4jE2lv8eayQkWugUQT6r4PyNEhRq
   qf8IdHHXoQIA8H5RQxj42+xeud0U5A0qlr1KeyOqXPPgyhP89q4FQYjcW
   jE9kAutSrwEXkmw0m7M1tZmVDTndpHP55X5neBlxuiz+spHoG9BZCvoIn
   A==;
X-CSE-ConnectionGUID: WCn5/GPsTcSAtnfAmV4a+Q==
X-CSE-MsgGUID: jHqCeA2CQfO9rLtoU8KJ6w==
X-IronPort-AV: E=McAfee;i="6800,10657,11617"; a="76616001"
X-IronPort-AV: E=Sophos;i="6.19,314,1754982000"; 
   d="scan'208";a="76616001"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2025 08:48:25 -0800
X-CSE-ConnectionGUID: kEr6KmvTRp+pGAIiYfz4aw==
X-CSE-MsgGUID: gURQUw0hQ3qt2R8VY/kBjA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,314,1754982000"; 
   d="scan'208";a="190841177"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2025 08:48:25 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 18 Nov 2025 08:48:25 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 18 Nov 2025 08:48:25 -0800
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.64) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 18 Nov 2025 08:48:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JTGz4LODt7uRLzP/NDg110UOMtMFykijLaRd4XwFLc6GgT+ZnfI4ElMimBlUMTfnRUXfoeDbZBvRos34OBEVecApzTpCQs5MJ6eQh+IzIUK1LvTwLFKa95bdVDTjQchLmGstRhhzWiKZormF7wTBm9kEOoWVL77N9jl3y9zYfC5wNvwHtda9GeIZ4YPyXZBNYGkHD9Np15psdwD49xU6dZbuHIQ+i+IwfCdmnQlqIret04DBqPttkyObHIh+bogjKEdt6Nxd7sTCPVc6+JQ/764KituQ6ubWhbcfca8IZ87hV81ggEK0zy1tsMUnjoxRGndYFVTAFAvXlU2Cx4PG/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2kViHulXPvpBnFIOt7xI9OWLf7UiBR4EWvYxSrQuVAc=;
 b=f/Fx1rdBkcyBil/05taOw8CwwZYFBIucF0Ehc4+z33KUypSM96sqF4i4KOPRtW6IcFqfpBXF/5uqekyHv3e4wSrBRxvJ7PZrEM7cDwmtumx0O8N//QVdm9Wj6jGDQa8Q5OA/32v0lVxcr4TxYQXeJl4TZFjgLpnW9K8LK3oB9bSgQplHO81y428tqbSgWDvSlNU2erwedtf6idibDYt+2KBWi/v7yd3fMcdxKN/Tq6S1MHq3+QwnjsGNnJWsG6SEwzSCocAX86e+KKOR5bFdyh1cHEhfuXygtAY8E8DzQ6qN9hM2ayF9fvykou38KTyEdd+7Qi1dTzDNJIGldr2lJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN7PR11MB7566.namprd11.prod.outlook.com (2603:10b6:806:34d::7)
 by DM3PPF7C7D8332C.namprd11.prod.outlook.com (2603:10b6:f:fc00::f31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Tue, 18 Nov
 2025 16:48:21 +0000
Received: from SN7PR11MB7566.namprd11.prod.outlook.com
 ([fe80::2b7:f80e:ff6b:9a15]) by SN7PR11MB7566.namprd11.prod.outlook.com
 ([fe80::2b7:f80e:ff6b:9a15%5]) with mapi id 15.20.9320.021; Tue, 18 Nov 2025
 16:48:21 +0000
Message-ID: <f3ec7e8b-b042-4d38-823f-4f4174cb9d09@intel.com>
Date: Tue, 18 Nov 2025 08:48:18 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 25/32] x86/resctrl: Handle number of RMIDs supported
 by RDT_RESOURCE_PERF_PKG
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251029162118.40604-1-tony.luck@intel.com>
 <20251029162118.40604-26-tony.luck@intel.com>
 <50149b02-d6ea-4fb2-806a-f16e80d3d52b@intel.com>
 <aRelbFgQ4-11Xwg2@agluck-desk3>
 <8ca676bf-7b50-4898-baf1-92241712f871@intel.com>
 <aRtPL9IQXWiKfhEk@agluck-desk3>
 <cdbc23f6-cf4b-4e83-a037-0aaf7c076e8c@intel.com>
 <aRtu0J4os4bXTLV2@agluck-desk3>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <aRtu0J4os4bXTLV2@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR02CA0008.namprd02.prod.outlook.com
 (2603:10b6:303:16d::27) To SN7PR11MB7566.namprd11.prod.outlook.com
 (2603:10b6:806:34d::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR11MB7566:EE_|DM3PPF7C7D8332C:EE_
X-MS-Office365-Filtering-Correlation-Id: e1dcfee3-4ce4-4e0a-de57-08de26c24822
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?SVBtWnlyeTV4NzlPZUNnN084UGVqcEpNTFZBa29OZ21kdDJzbWg5UWVsRTQx?=
 =?utf-8?B?WUxGNy9KWUVYUXJiL3BORVp4Z3gybUUzMkQvU09HZ1RUUnNEZlVYSW5GWmk1?=
 =?utf-8?B?V0haWDN3WC9sOGQ3Y3FNK0VoSWErWGV0ajBGRTN0QkVidmpuT2RobVEwTnJO?=
 =?utf-8?B?Yk9heFlIRHlxSkZ4L2pHRUxsandsam9UOGtDWWQxL083UTYzd0luNDFvcTE1?=
 =?utf-8?B?RWlTSUJsMklsNmNWcmFuMzlnM2xGeXZEOTJFSXlOb1VWQ0hMUmIrYUpXS1F3?=
 =?utf-8?B?anRaWkpLRGk0NU5rSjNaTW9OaGgwRVZSZVIzVG9lOVZEUE9rWE9veHlMeHhK?=
 =?utf-8?B?NTJhVSt2dlhJTERVb0dKVW1jenJ5S2t3L3g0MFpNSE9DbzB2UHZjbjBNQjM4?=
 =?utf-8?B?c3hINFdld0kyMzN6YzQxNVZqQUQ5ZWxJZ0VscmVlYUFUaFd6V0h6bGx0Nkxn?=
 =?utf-8?B?UktwdG9zQ29rSHVtZFlWeHN5VlozWG1oL0JXczZ0ZjJacEc4Vm9COUNuZjhW?=
 =?utf-8?B?cU5SMWtIYU5lMXExc1k5OTNFNE1RVkpwMlBSMDhvamYyS1BHUjVDOHFnZDFn?=
 =?utf-8?B?TjhLUmRZNGFuT3dHNzhTNHNCcDRGeWxFeDJSREt1SHhiMGFHTGRabTg3dGxN?=
 =?utf-8?B?VXhwN1hyMG1GQjZPczJrbnRHUDRUVk1MQVRKTVE1Qmt2ZGpVcmtPZmpLTW8w?=
 =?utf-8?B?SHFMLy9wS1VzSWt3VU5SbkZHM3RITVpXN0ZFa0RIdkhMcnBhMHBHZ1grcWxZ?=
 =?utf-8?B?dzB1MzliODRPUnkvdHZqSllwcU14T2hTMzgwVHBEdVFYUkVvOVExekc2aXcy?=
 =?utf-8?B?MDIrc2xFRm9oaE85OE8wWFEwYnFzSG1mTkdjbWpWSHBZb2lwelN3bUJRVjhs?=
 =?utf-8?B?d1RkSkt2djUvbG1BZU9hajdPMHd4VFExWlM0VGZSZ1BWT1BZUE5JUDNVcjJB?=
 =?utf-8?B?QTNWOFIxUERjSlFUYmFQdXRaUTFsdURNNC9Odno1OVkvU3pUUkwzNEwvTlFi?=
 =?utf-8?B?RVhRVXh1dE1tenJJajlucXpGWk5wNTFQWDRjSWxMcFJkS2JxRVhrZVJFMTZW?=
 =?utf-8?B?VGR6bTRLODlieVBwQ3M1cWlBRkVLZ1phTzd3Skc3VnJDV1RxQ3B4b05WN1Ja?=
 =?utf-8?B?RU51cEY3SVpNZmNzZFB0dXdESVdQcWEzbXNVQlJFQnpSRGF0Nnlwd0o4SFVQ?=
 =?utf-8?B?N3MxdTluYTVIcWZ4SjJKNVpTaFBwVUF0NjFMRkdPMm5kQk1pMVFMZWV0Wmwz?=
 =?utf-8?B?aEJFRUt0QUFtb0U4aXB4MjU5UlZQQUd6WHdHMllUSkN1SmpNSUJQSWNqKzhh?=
 =?utf-8?B?NEZRMzlzcXF6Qk5hTFFnWEV5Y2JpSkFrc2RLSXk0OTgraWU4SjFLVjJWOGpC?=
 =?utf-8?B?cU91SEthT29jbzRSdTZUM3EvZyt5aGJWTUZ4K0JiajJsT3pVZ0NJdkwzNlpO?=
 =?utf-8?B?djNCSTMyNDkya2R6ZlBidWRLcXVDYmFGSndsRDZObE5DL3ZjMm5RRzhmckR4?=
 =?utf-8?B?RzRkeDhWRklueDhLdWNDam5mNUhsSmNGdXNvaGF5N1NLYm4zRlE5MmNKS0hx?=
 =?utf-8?B?azl6TlJtMGRxZWkxNFBISWxBbmcrNGxnUzRiV0ZPZ1JPckhtckkwWW9yeGRG?=
 =?utf-8?B?d2tqWDFLK0VVL1JIWk80a1pTRFZGRE16eE1tWlk0cWp0R2x6WUdWSXYrRlR2?=
 =?utf-8?B?cWdlUzlWYmIrcDhUanhnOVRUd3YrOTJPODQ2a082OHRjM1R5R3h1eGtBU0tJ?=
 =?utf-8?B?ODJIWVF3U3JuYzBrSXlCUFpJRlY2Y0ZuekprUk5NUWhWSUc1UmJzODJpOUtI?=
 =?utf-8?B?RXZsMFU3ekkya3owRlNQeERXZzcxUE1zVlFKaGdLZE11TVZqM3k2OWM0eTRa?=
 =?utf-8?B?S2JQS1F6UHN0bEVXZGVMZXAvWkw1bHozTkE2aE9ScTZNQnp3dnl5dW9jbGNN?=
 =?utf-8?Q?x+G+YaSjgDIpJqLeL9YQY6TRCrg/1MZi?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR11MB7566.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dGlqNjBURjM4Z095cCt5UTlZZlRIWHRteVV6NTlGUXZ0SDczM0g1amh3dnpF?=
 =?utf-8?B?R1JxeXhNWUV1Uy9TUTAxcUZWSVlrU3haQ2U4K24xZUdzbjducTFSRkxrUEhZ?=
 =?utf-8?B?dDhHdTE1ZEJpSVl0eDZnWCt1TXdtTTdwMFRhQmMwN1djMFVOWVQ4czlQdll5?=
 =?utf-8?B?TEF6M2ZlY01SNk1QMFQvcVRpUUtjS3FVRXZFcEFBcDNqcWhraGJNUHF4ZERq?=
 =?utf-8?B?UU1JanYxTDhLWG9VNk15MmVUZEU3enV1Y2xKalhQVWhVcGJ0d0xldnZ3WXBX?=
 =?utf-8?B?VGx4VUNPQXVJeXU3VVNMbjJrZnZ0endaTDNqcHVMREJFU295bFpTdU9NYWx5?=
 =?utf-8?B?dWU1aFR0bUg1YmZaa2I4c3licHlqYi82dERBRVlZYThXcTlVaG11VHlTRzVM?=
 =?utf-8?B?a1lZQ1pMU0VpaGN6cEFDMWRqakRPdFJEcG9UYndaaERrakMvTS9KSlZLMUEw?=
 =?utf-8?B?L2dzY3JlMEJOYWVOQk84Q3l4eEpWK0h4ZGxqOGJ2Z1NrbU1nV0V1eVdQUzBM?=
 =?utf-8?B?cXo2WnlzSm9reGZPVUY5UEQ3Vm9ObGhENWRZOWtsZGxrbnU3K0dFdGJ3NVEy?=
 =?utf-8?B?U0szcVhJY0hPZmQ2NGtIaFBUaGw5Wk1JcEFLek1TSEhTcnprTkZuVXJzcWVv?=
 =?utf-8?B?d21mT3d5bGlwSnR1amZSZDBCM2U1dmhvU20xVzRpNlhjTWcra05Pb2V5d0g4?=
 =?utf-8?B?UXRQOHdmUFpGMUo4akxDTjRmeDljYjFXbXVVTDgzRVZVZnc5L3lNelNCV1BM?=
 =?utf-8?B?ZitwN1BzRGw2QVJoM1pXeWFHR3JyUVZwbnlJVlJsbHlaTlBGdUtRRFFWQUJT?=
 =?utf-8?B?cndxSnlNNDMySDJjSHkvTkkxczA5RHBOS2QzcXNyb0ZXRUxTOC9Hd3pvQUdR?=
 =?utf-8?B?bXp4QTQrUlIxWVo2UTlTeERLOHBJWW14V1dvTGY1anlyb3lzcC9meW9pNVAz?=
 =?utf-8?B?d2ozUUV2ajdQT000N2JmUXYxRXpLNnRXU29ycmViNXpqcDNPcnJFRDVYcUNQ?=
 =?utf-8?B?aFdFVWFMdUViNUVKQ2J6V1hrR1MzZFgrN0cvSjhwdDVBTzQ4WVdnOFJhME1i?=
 =?utf-8?B?aUpaV2djUkJuNGtVUkdHNG5DN3NkUy92b2NrMjRzb0ltZmxabkN0ODdPRXgy?=
 =?utf-8?B?T1pqajZiVXhUOWEwZFA1b05TMjUwREl1MEttYzBTMVFBL0Vza0k5RGxUa3RI?=
 =?utf-8?B?RnRqeFlQKzdLVm5rUzFuNHM5T2RXb0lxR2xOTEtGMFpsVlhIYURTTXJNWXp6?=
 =?utf-8?B?VGp2OUxsR1MrYkxzQnNybEFZK2NsQUJHYW1ETkE2cnBMTFlRRktiQXRUdGM3?=
 =?utf-8?B?RzMwTFRhQ1dEVFJmd29uWU9qSXBjUmdxbWpsMWpIZkZaNUpTN25YWmxqeGRG?=
 =?utf-8?B?bHZ3NUNtUW5LZmZHY3lXTWNEM2ZPS3NFMGlxQUc1THltNzRHLzdDZFpZTjBo?=
 =?utf-8?B?UTBFQ3dla0liU1l2R3g0L3I1d2ZCQzFoQkVlbUZHNnZncEhQaTQ2UU5hd3VD?=
 =?utf-8?B?bDU4SnJXU0F0Q3VPNDZsWmllQ2VIWlFOQ09PdzZLajBCdDVNc0xwT1dsbDRF?=
 =?utf-8?B?YWpVMWIvSGdHY3kvbEYwVVMzQis4MmNrSHM3bTJEenBaL0QxMG5LWmpveWdv?=
 =?utf-8?B?UVRYaHVramdrOVlGMzFRQklobklhajZSV0lyc3hpT0xOMlBBNzZvU2pvY1dR?=
 =?utf-8?B?VmJWcFJmQy9lWE43VnpjSWoyaEZpdURZTG9YNDNyOFhCMnhMZVRna21QaXls?=
 =?utf-8?B?Z0Z6MW5iV3VkaXc2dDZHb2ZVTEZZVi95aG1oMnBDbDliSS9PQzdJSVpHYWpx?=
 =?utf-8?B?ZWF2MXBsejBvc01iak9Gd1pMWUdVOXVLc043Ky9vNG9lRHNUSC9pa1RXMGZT?=
 =?utf-8?B?ZWlGWCs4QmYwMzJUc3YrTWllYWg1MUdtazNhUmNacWNFQ3lldEhEMERsbUdG?=
 =?utf-8?B?OWVqN2NHYkZDQTBjV01jRDNpVkpqNHZNOEJZTXpnelRIVWpQdlB4WnVwdHQ4?=
 =?utf-8?B?YzNDS2wvV2ZJNVVqbFhWMGxtMHRDVndjM3VxU2VrUkFsUVh3TjRFSnZlOVZy?=
 =?utf-8?B?ZjN5M21XRlNFb0FXN0ZBUFE3WDJObTRCUzVvUHd0cU5XSC84MmxXRzJQK2hy?=
 =?utf-8?B?TU5UVE5IaGNXMXFldUZxSWF1ZjJQSkVPOVhGdG1ka2k0cFFwc1JDRk1RN3pv?=
 =?utf-8?B?K2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e1dcfee3-4ce4-4e0a-de57-08de26c24822
X-MS-Exchange-CrossTenant-AuthSource: SN7PR11MB7566.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2025 16:48:21.1459
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ozUTx1XdOcQnM6AxKRyyndZVzl5cQLNmmL6Y+nU2k4/bEvwHpXnXJoWF+qD+hDsekASQAocnLzk3NjdYIezkJ1aBucrt9XM/TeOx0Daqu+I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF7C7D8332C
X-OriginatorOrg: intel.com

Hi Tony,

On 11/17/25 10:52 AM, Luck, Tony wrote:
> On Mon, Nov 17, 2025 at 09:31:41AM -0800, Reinette Chatre wrote:
>> On 11/17/25 8:37 AM, Luck, Tony wrote:
>>> On Fri, Nov 14, 2025 at 03:26:42PM -0800, Reinette Chatre wrote:
>>>> On 11/14/25 1:55 PM, Luck, Tony wrote:
>>>> How a system with two guid of the same feature type would work is not clear to me though. Looks
>>>> like they cannot share events at all since an event is uniquely associated with a struct pmt_event
>>>> that can belong to only one event group. If they may share events then enable_events()->resctrl_enable_mon_event()
>>>> will complain loudly but still proceed and allow the event group to be enabled.
>>>
>>> I can't see a good reason why the same event would be enabled under
>>> different guids present on the same system. We can revisit my assumption
>>> if the "Duplicate enable for event" message shows up.
>>
>> This would be difficult to handle at that time, no? From what I can tell this would enable
>> an unusable event group to actually be enabled resulting in untested and invalid flows.
>> I think it will be safer to not enable an event group in this scenario and seems to math your
>> expectation that this would be unexpected. The "Duplicate enable for event" message will still
>> appear and we can still revisit those assumptions when they do, but the systems encountering
>> them will not be running with enabled event groups that are not actually fully enabled.
> 
> There's a hardware cost to including an event in an aggregator.
> Inclusing the same event in mutliple aggregators described by
> different guids is really something that should never happen.
> Just printing a warning and skipping the event seems an adequate
> defense.

My concern is that after skipping the event there is a deceiving message that the event group was
enabled successfully.

...

> ---
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> index 08eb78acb988..25df1abc1537 100644
> --- a/arch/x86/kernel/cpu/resctrl/internal.h
> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> @@ -241,6 +241,7 @@ int intel_aet_read_event(int domid, u32 rmid, void *arch_priv, u64 *val);
>  void intel_aet_mon_domain_setup(int cpu, int id, struct rdt_resource *r,
>  				struct list_head *add_pos);
>  void intel_aet_add_debugfs(void);
> +void intel_aet_option(bool force_off, const char *option, const char *suboption);
>  #else
>  static inline bool intel_aet_get_events(void) { return false; }
>  static inline void __exit intel_aet_exit(void) { }
> @@ -252,6 +253,7 @@ static inline int intel_aet_read_event(int domid, u32 rmid, void *arch_priv, u64
>  static inline void intel_aet_mon_domain_setup(int cpu, int id, struct rdt_resource *r,
>  					      struct list_head *add_pos) { }
>  static inline void intel_aet_add_debugfs(void) { }
> +static inline void intel_aet_option(bool force_off, const char *option, const char *suboption) { };

(nit: stray semicolon)

>  #endif
>  
>  #endif /* _ASM_X86_RESCTRL_INTERNAL_H */
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index 5cae4119686e..68195f458c0b 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -842,6 +842,7 @@ static struct rdt_options rdt_options[] = {
>  static int __init set_rdt_options(char *str)
>  {
>  	struct rdt_options *o;
> +	char *suboption;
>  	bool force_off;
>  	char *tok;
>  
> @@ -851,6 +852,11 @@ static int __init set_rdt_options(char *str)
>  		force_off = *tok == '!';
>  		if (force_off)
>  			tok++;
> +		suboption = strpbrk(tok, ":");
> +		if (suboption) {
> +			*suboption++ = '\0';

This looks like an open code of strsep()?

> +			intel_aet_option(force_off, tok, suboption);
> +		}

I think this can be simplified. It also looks possible to follow some patterns of existing
option handling. 

By adding the force_on/force_off members to struct event_group I do not see the perf and
energy options needed in rdt_options[] anymore. rdt_set_feature_disabled() and
rdt_is_feature_enabled() now also seems unnecessary because the event_group::force_on and
event_group::force_off are sufficient.

It looks to me that the entire token can be passed here to intel_aet_option() and it
returns 1 to indicate that it was able to "handle" the token, 0 otherwise. If intel_aet_option()
was able to handle the option then it is not necessary to do further parsing.
"handle" means that it could successfully initialize the new members of struct event_group.

So instead, how about something like:
		if (intel_aet_option(force_off, tok))
			continue;

>  		for (o = rdt_options; o < &rdt_options[NUM_RDT_OPTIONS]; o++) {
>  			if (strcmp(tok, o->name) == 0) {
>  				if (force_off)
> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> index 6028bfec229b..b3c61bcd3e8f 100644
> --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> @@ -69,6 +69,9 @@ struct pmt_event {
>   *			data for all telemetry regions type @feature.
>   *			Valid if the system supports the event group.
>   *			NULL otherwise.
> + * @force_off:		Set true when "rdt" command line disables this @guid.

To be consistent, can also be true if event group was found to have insufficient RMID.

> + * @force_on:		Set true when "rdt" command line overrides disable of
> + *			this @guid due to insufficeint @num_rmid.

"Set" can be dropped to be explicit of state instead of potentially confusing "Set" to
be a verb.

insufficeint -> insufficient

>   * @guid:		Unique number per XML description file.
>   * @num_rmid:		Number of RMIDs supported by this group. May be
>   *			adjusted downwards if enumeration from
> @@ -83,6 +86,7 @@ struct event_group {
>  	enum pmt_feature_id		feature;
>  	char				*name;
>  	struct pmt_feature_group	*pfg;
> +	bool				force_off, force_on;
>  
>  	/* Remaining fields initialized from XML file. */
>  	u32				guid;
> @@ -144,6 +148,26 @@ static struct event_group *known_event_groups[] = {
>  	     _peg < &known_event_groups[ARRAY_SIZE(known_event_groups)];	\
>  	     _peg++)
>  
> +void intel_aet_option(bool force_off, const char *option, const char *suboption)
> +{
> +	struct event_group **peg;
> +	u32 guid;
> +

Can use strsep() here to split provided token into name and guid. Take care to
check if guid NULL before attempting kstrtou32().

> +	if (kstrtou32(suboption, 16, &guid))
> +		return;
> +
> +	for_each_event_group(peg) {
> +		if (!strcmp(option, (*peg)->name))

!strcmp() -> strcmp()?

> +			continue;
> +		if ((*peg)->guid != guid)
> +			continue;

If no guid provided then all event groups with matching name can have
force_on/force_off member set to support user providing, for example: "!perf" to
disable all perf event groups.

> +		if (force_off)
> +			(*peg)->force_off = true;
> +		else
> +			(*peg)->force_on = true;
> +	}
> +}
> +
>  /*
>   * Clear the address field of regions that did not pass the checks in
>   * skip_telem_region() so they will not be used by intel_aet_read_event().
> @@ -252,6 +276,9 @@ static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
>  	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
>  	bool warn_disable = false;
>  
> +	if (e->force_off)
> +		return false;
> +
>  	if (!group_has_usable_regions(e, p))
>  		return false;
>  

rdt_set_feature_disabled() that is around here can be replaced with setting
event_group::force_off

> @@ -262,7 +289,7 @@ static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
>  	}
>  
>  	/* User can override above disable from kernel command line */
> -	if (!rdt_is_feature_enabled(e->name)) {
> +	if (!rdt_is_feature_enabled(e->name) && !e->force_on) {

rdt_is_feature_enabled() can be replaced with check of event_group::force_off

>  		if (warn_disable)
>  			pr_info("Feature %s guid=0x%x not enabled due to insufficient RMIDs\n",
>  				e->name, e->guid);
> 
> 

I believe changes I mention would simplify the implementation a lot while making it
more powerful to support the, for example, "!perf" use case. What do you think?

Reinette
