Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010009.outbound.protection.outlook.com [52.101.193.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 492BD23C8A0
	for <patches@lists.linux.dev>; Tue,  8 Sep 2026 05:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788846394; cv=fail; b=JXZoWjgtFMTKS81xmJ7qWg/8sGnpLbQ7MOO5ld4CZt8HfPkDWYId1XK98d7niUNQGt4ofNWSlj6+mYzG76zAqtMMgguE6ffDjuQXbOitjAW9m+6QchW1CnREdwsOt+/mgvSYxOOKX0g+DQ57Di4JK5jIUjr7ZGOu1rCf8lZKk3c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788846394; c=relaxed/simple;
	bh=+os5wXCxE9KVv1Iifzo2g1/vGGTzjqKx0P7y4f7dfGs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ekiHgsH4UHCeWGgWBZsEHaUZPP3MwIwbdraTn8c9GNyTzVVxASAvq7GQCirAN/0tReCRWGbrT6IDfRXVSrqPam+zCmqt1dQjrp2V2GcQ1V1qHp9DyhhXquh3TnDlAGFxRT07pUgopQb5qAwWHYojmL84z6Asr8yXEb3GaJai5xw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=altera.com; spf=pass smtp.mailfrom=altera.com; dkim=pass (2048-bit key) header.d=altera.com header.i=@altera.com header.b=PxzFxEnD; arc=fail smtp.client-ip=52.101.193.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=altera.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=altera.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=altera.com header.i=@altera.com header.b="PxzFxEnD"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=edKRvtLxsHOZp+lsPXwd49G33b+L95ohdJbcpjezOwgErv8rQU/0+MobMAhENrtyuA0NhzkrAXg640/fGJLi2hE0GWlUA0tFe5yv9JqLVxj/ZHTZPGVLSGpJ4V5MFUqrv/KaE3rCelyQ0jnwidS8KCjAbnM2RQHFHwbENtVKNTUZocCS1tXhv8y+RjgY6eOiVum9IjyriWCrbsD0AlZtXNrizZCQeIv1M2XuauZc3DYtEPJRX1P3RQfUPARqr+nwtz32rlYRXvV2gkd/B3eVMJ61RNYhkUQEzkR++GHdCZsheRHeoQPpB9JXkwxtL5ohjxsnXtYDlDvMK0rmuDIgzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mBW8WSpJZPSC6i7eTCMnNq7zi9G/0o1z3frv5ZjPRV4=;
 b=wtT3G3Fd9uozV8focbk42w1I1yXMExEiK2KCD+gtGSNIF1r7M/JXeUuuqyf0XNYpMzRCqw8Yb4yK2rvLmmIwMVPrh87LuT1TrFIO7Hs5+5obtt5jZ4tNlCZ3AcL9OZYHHMKqXwgbpZJYuNuP2NH0xMd5MEEnsGp9IHta4QBdvaaNpqVbsuYaFloPk39tfoWTMz7x7hvgU6PvEZzVHd4VR6BSr3DtDBJDZZfXXQF2DjEFjgv/SgaNpX5J1e05Z7AvvoE9mXgneKLbTO1UXIlyCtviD4h3x+tHI/+i+BblJTQ5AA+3SsNGcAGk5DVgZF9rsrDdZReyn3AUPKc7rQOlPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=altera.com; dmarc=pass action=none header.from=altera.com;
 dkim=pass header.d=altera.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=altera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mBW8WSpJZPSC6i7eTCMnNq7zi9G/0o1z3frv5ZjPRV4=;
 b=PxzFxEnDLnnkbr8uMxXx2nIXxyZ8IU7wpq37lozVGd4gxcYnmEj5uJEKqr+Y1X02kn/8lgOK6v5JQap2kHFPQS1bWPn35pWb/H+Bwgy/MdrSpHgVVTlPNuMpwnGGDJwaTfJE6EcDUomso0Y5qzNuGPjx0xPNH9eD9jyY66j/KWIiELCIQsHcsa8gqkEY0DkjkDdH/Uq6O3rzTaxp82BCBvPWijLtzfZxcLv5/un/vxyv1ycHj6vapK2JlAj5I1OCw7jbMElV+ivfpvwx8ogoaHdPdS/4Mk34iDKDi+bQcb9cnHc+riN/LAsr89ahB8y+dM5WYoGR3HvoJOZdTgZdEA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=altera.com;
Received: from SJ0PR03MB5950.namprd03.prod.outlook.com (2603:10b6:a03:2d3::20)
 by SA3PR03MB7318.namprd03.prod.outlook.com (2603:10b6:806:395::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Tue, 8 Sep
 2026 05:46:29 +0000
Received: from SJ0PR03MB5950.namprd03.prod.outlook.com
 ([fe80::53a0:bf93:6b6b:de01]) by SJ0PR03MB5950.namprd03.prod.outlook.com
 ([fe80::53a0:bf93:6b6b:de01%5]) with mapi id 15.21.0382.012; Tue, 8 Sep 2026
 05:46:29 +0000
Message-ID: <34cef7ad-8730-4a49-b6f4-8307adc1e36f@altera.com>
Date: Tue, 8 Sep 2026 13:46:23 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 364/456] firmware: stratix10-svc: fix memory leaks
 and list corruption bugs
To: Sasha Levin <sashal@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 Vegard Nossum <vegard.nossum@oracle.com>
Cc: patches@lists.linux.dev, Dinh Nguyen <dinguyen@kernel.org>,
 Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
References: <f3b734d9-d286-42d6-b332-e4889e7bcde3@oracle.com>
 <20260830195300.0009-1-sashal@kernel.org>
Content-Language: en-US
From: "NG, TZE YEE" <tze.yee.ng@altera.com>
In-Reply-To: <20260830195300.0009-1-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0043.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::19) To SJ0PR03MB5950.namprd03.prod.outlook.com
 (2603:10b6:a03:2d3::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR03MB5950:EE_|SA3PR03MB7318:EE_
X-MS-Office365-Filtering-Correlation-Id: f584945e-ae1e-449f-eaa3-08df0d6c8768
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|10067099003|6133799003|18002099003|55112099003|22082099003|56012099006|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info:
	upubQczmQTi/1aDL6CEeOtftV3QIyzWOVpzFqbRlHDiWU/R1ItV2s2GItcQdZ5mzF1xKMbHiVToJMjTNyYCEBLDqjjlFZNc3iyDb30sXASlmaS+EV0kyAd4qtKBLHsOyP22/127tNsWwcEFqiLN1COJ+quK7Sp8XinpUPDvZu1WAS6I9EOI5tdDDvwJfwQ5rYXc4HMyxBfrOAWXG5TFz13vKKn5iCxUhm1K9T8NG90YSKgknEwBGelkBd/oAKMPmAZZC7GB/P9PnW1XwSNVmCk1WQESBtQu93lNKJvRPpCKNXg9OVVrRu5bldjodDfW+DIn03iDb20jHYxt4YP2MzWUzF7jkiCiFCZrbJyXclZtUz23hBS/hlhu4wnr1IZOZBbI2MPQ/okAcBSuMviLX1hIKYaUKbsvaye1g1YgaKMZC2rAU+1EfwVvWN7G5ShaDqsez6sUr6NP5lalgHRMyw6irexsJQCR04O6XqOl5k/qUl7erQvWC/soD5VZ8YLtd1P9CgHvsyIvHvRRdSxBoGoYkGfWnq/S1f3sfbdXySzuGSjPuQOl9PwFYUeruCr1VCF162yG/VBIE9lQ/oQKoEBSHkqgflZcERZ6QtP1c7EW3cDOCTJGtdK+GJqZSYHPEV+gPF/KPv+EJW0KM/rQI3ns+OMJgBoRZmOlalikrH0A=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR03MB5950.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(10067099003)(6133799003)(18002099003)(55112099003)(22082099003)(56012099006)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TWtuSlFyQUdBSGZTcm10WEhEN2lMVFhqbDNIODNNdC9yR1pNS0QxYjhvQzkv?=
 =?utf-8?B?YzVLWXc3a2NTUzVMUUQ3cmxpZCtRWTlTeUdFUWd5a0JxbmJSUWJBeEw4OVJJ?=
 =?utf-8?B?N3lWaG5TYkhJOXlGL3ozeWI2VlBwcldWVEgxcEkrNzA0UDV1aW9SVU9BcVdX?=
 =?utf-8?B?b0krK0FIbUJ6NlRidUt6OEhiQkQvRGtET2hXMVFYeUtqaFc1NmErRzZMRG5K?=
 =?utf-8?B?QmpLVzJKdWlCZEJxSmVtUGE1K0taYnZLTjQxZkJOak8yc1JNRHFnVHdnSCth?=
 =?utf-8?B?L0I0UXJCK3pwUG9IdEU4cVZuOTBwaSs3SFdhQzR0ZzVoak41alA3MU9mOXhs?=
 =?utf-8?B?cnJjcGFYU3M2NEw5bXB4czBzYkpWMWIrd25COCtsbUNkeUhQa2ZHVFIxNkwy?=
 =?utf-8?B?WVRyUGJWUVBVenkvcnd5Si9YcitVaDFTTDFrdWMzbmwzZFAxMkFVanp5VFJu?=
 =?utf-8?B?dER3VFNZbnFHZHA2VXNzMStuN3I4WVNOS0VteE5SOUtUbkRHK0pyOUlrTStm?=
 =?utf-8?B?REFrSlZxTTFKZnVueVNPc1hvUUl5Nmkrbk5GSUpwQXZDWmkwQzNLQmRPMG5E?=
 =?utf-8?B?NG5KaDlXbUtObzJGTUovSmEwUkd3WnJERmh3T2tvTGxLQysvSmtnQVQvL2pM?=
 =?utf-8?B?cWFNd2QxSWhULzhDZS9CbGFqUG5yeVRxM1dpZTdZU01RWGh3L3RLOVZHQ0xM?=
 =?utf-8?B?Y0YzRVp0a0NpTDBFc2phY3lrMzQ3S0QxZXBON0dLaUNqUFFmN1hEdU01a0Qr?=
 =?utf-8?B?RzRhMXRFYmlHT0Q4U3BnR1UvZ01jUjdMRFl2NnhxVEJyZUFOQ2xIK0JyMkdv?=
 =?utf-8?B?K2MwWkE3WmVDWVVzaHhHNmhHREdhdm5YZjZjZVBuY3djUDZoOFVaMUFDT05D?=
 =?utf-8?B?K2Q3UWllTVlEMTVPQWc3REpVWXVBeGpRaE5hcHI5YWs0cUN5MGc2eHllTHo5?=
 =?utf-8?B?WUVMUjVtZmdRYkl1MG5JaTFqSVh2Qlo0K0d6MlBzdEg5WEhBWDNmNlkvNE5a?=
 =?utf-8?B?S2dZL3REakZ0TFlBRFhFQmcyUE4yOGYxT25BTWsrSkhRTHplK1VPcWx0RXJX?=
 =?utf-8?B?bTlYNUc4VXM4VWtSMGtMdG8xM1NPRVlLVVZocEY3TGVuSmREOWMzSkdVN3RI?=
 =?utf-8?B?VjU4bjFxc3czT2U5MFRMemtEQk1rbWN6d3lzMEs4QWorNGQ0U2RGTVF2RGc1?=
 =?utf-8?B?blZ3VU1pUGVkNWdLWlQ4Si9YQXBwUVVmNjB6UE50N2Z5K1k2NVlsT1F4MFJC?=
 =?utf-8?B?Z21nUjYwV2E0NVo2RlRnN2lVdTVIYkxBZThNbjlPSkNLaGo3dy96OFpkZk4y?=
 =?utf-8?B?NUFYejBqL1E0YVE1enJQSlJITWJOaGtkbHROTmdydXduUXZwbzVjbkprZlMw?=
 =?utf-8?B?ZUpaT1NCd2s0UGJMTWxQekt4MEs3Y016NlV2RWRGK1VOS0RVWjZQTHlBTWRa?=
 =?utf-8?B?ck4xOFJkMWJoOTg4cnNUYmszeW1KdklTYWlWOHVlOEJBVU55VWtQNUJaMlky?=
 =?utf-8?B?UEVSd2plamtWbHRUZW5tR3JOR256RTJBVEJQVWliTm1MRzdHdFZhRHBEOFhk?=
 =?utf-8?B?WDBFSG1pcXNRV3Ewbm9jeHJlcEJCRFhhalpGeEo5d3czYWdrMFZST01MSGw1?=
 =?utf-8?B?YkZtaytpTG5xaVM3U2p6OGNKMzBwYnFsbEZEd1Bzek5GbERxMzFEK2xkcWNs?=
 =?utf-8?B?akcwQU5LdWZhUm1obUpXUVZRRFZHb1lHQ1o0alFFWndWODh3Szd5bVc0UzN6?=
 =?utf-8?B?MW1xamJ6bGtIbWlXSTE1K1FQMWlraHYxT0RtYjNyb2tKQ1JUUHdaQzFoTUJ1?=
 =?utf-8?B?OXU5d1ExMVNVY0t3ak8wKzdDRytDVWRjakJxcHRjQlJSSnR4ZHhiSG5vTUdR?=
 =?utf-8?B?b3hhZkttSkY4d3dSN2htSzVGenNMdC9jbmJDQ2dnTkxPNHFPUEhzcFhjUjJ4?=
 =?utf-8?B?QjhUbjE3TE5JcWF6YzBpSzVHYVJzQkMvWnoyN1gyY2Q0akhzZ0tpWGdiWllh?=
 =?utf-8?B?YSszank5bDZZTjgxUS9CbGJJRGFpUkNHUGNYdCthYkJsSkxhYVFLdzVGY1NP?=
 =?utf-8?B?T0pzRHEvRVgwN1pDZ0R6UHdHZXJhRzZINjZuc0FTb0VlQTRqenFTR0gxa3JD?=
 =?utf-8?B?RFFhV1VyNnQxU01oc0o1TzBNSEVYeS9tTHE4SUo4VjNqbVRYT0EzMkxIRm05?=
 =?utf-8?B?RlJydU42ZWtBdnFiREpGZW1LVzlTUkZqZkNBajNUdUtHQWtBQWZnTERpU29p?=
 =?utf-8?B?ZCt2dGpqTFZMMVlHSU9pd003dXNtSi8rcDNnTWlvZVVObTRVRDJPR1FzVHJl?=
 =?utf-8?B?dm04TjkrdVBXTVo0bEFoQmNzTlE5eFFtcWI4U2NYS1Rqa2hjaHJYdz09?=
X-OriginatorOrg: altera.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f584945e-ae1e-449f-eaa3-08df0d6c8768
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR03MB5950.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2026 05:46:29.2813
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fbd72e03-d4a5-4110-adce-614d51f2077a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yPgTl4P/G3eS+/sAQ0m2aKg0jWjMSr08QpfPh9hGMhOSLYcd493zAHqvx3d8lTmO3CLHjgwIi67095GAOEGa6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR03MB7318



On 31/8/2026 9:39 am, Sasha Levin wrote:
>> Before upstream 9119ceb76e98, commit
>> 85f96cbbbc67b59652b2c1ec394b8ddc0ddf1b0b ("firmware: stratix10-svc: Add
>> mutex in stratix10 memory management") added a shared mutex around all
>> four svc_data_mem access paths
> 
> I agree. A tested backport is more than welcome :)
> 
Hi Sasha, Harshit,

Agreed to apply this to 5.1.5y:

   firmware: stratix10-svc: Add mutex in stratix10 memory management
   [ upstream commit 85f96cbbbc67b59652b2c1ec394b8ddc0ddf1b0b ]

Tested on an Intel Stratix 10 SoC Dev Kit (arm64, 4x Cortex-A53),
v5.15.220, with KASAN, DEBUG_LIST, DEBUG_MUTEXES and DEBUG_ATOMIC_SLEEP
enabled.

1) FPGA reconfiguration in a loop, concurrently with 4 RSU sysfs reader
loops (concurrent list_add/list_del vs. list traversal on
svc_data_mem). Ran clean. No KASAN reports, no DEBUG_LIST corruption, 
no mutex/atomic-sleep warnings.

2) A stress module with 8 kthreads concurrently calling 
stratix10_svc_allocate_memory()/free_memory(), freeing buffers from a
different thread than allocated them (the multi-client case this patch
targets). Over ~1.6M alloc + ~1.6M free cycles, no KASAN / DEBUG_LIST 
/mutex splats, balanced (leaked=0), pool never exhausted.

No regressions or locking issues seen.

I will send this as a backport to stable@vger.kernel.org as a separate
patch with the Tested-by below; let me know if you prefer to take it
directly.

Tested-by: Tze Yee Ng <tze.yee.ng@altera.com>

Thanks,
Tze Yee
