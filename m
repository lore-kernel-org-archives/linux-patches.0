Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012051.outbound.protection.outlook.com [52.101.43.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A715319857
	for <patches@lists.linux.dev>; Thu, 28 May 2026 23:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780009838; cv=fail; b=OVS2fKZOm3xRVWRM369kA0EOeHXVPQ1X0Emlh8mv7pI5drGheaEedQK808f2bYaCzQGGAHQAY6z4MlS91NGtEoEFBKlITiaj+51OIlmJ6aWDsiZMfAVbBQb9K2QcVW12zq8lFbd6eTWjFGJ5guDZAEpXtQbXZdbdesUe0iWiPJQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780009838; c=relaxed/simple;
	bh=rrHLsyO0Y0rYfzkoxhr4gftMxMUmGaI1XPxB9V9/oZo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WX0SseihfsyeNkIzAcsHHH1x5MSRi1ewOryptR7O4nptGGyMtgIY2oKTMWrXF1/Sde909ltPyCkZTZW1sXKZ3XVYJvwblM93Pzn8yH8uz/d/wgzz1HE5fXIqckKX3WqjzeV8psrTezAsLAodBt7pKtuiD9xhFTqI1XVL/P+8XWE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=dfaXYpW5; arc=fail smtp.client-ip=52.101.43.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="dfaXYpW5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UDKy+AsSXJZsNRUFaEgne7zlHO7imt8Ut13mmf8lMiCjA2K3Inx0AYQR9lHDcYAZ+l9Eo0dJutdhrwDlefPg5pBD2FmT2V7/wwWl2odn33lKUk8F2DtEjANL9Atv5ubNuebM7I1XedFCP3Gcq0uGMDgYtCIgBXQBxFw2n2uMqpG5f8I5FC6iHb8ZRVWX9z/s7ifjnahTH+16Ax3smgts1lZ+bBkWDrMSULgJ5BbNbhQWTONCmhq7gOaYO5YeTM0VlcqCC1vitb9vu9uQ4HveQ8dg3ZkyeJ0mO5qKYC5DNWDWFSP/amE6+GlPq3mQa6pkKL2GRjuNj/dDuzGlgVV3DA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lpct42TLw9c3mZk7cEfcrFRBmkxx33Kks4JC15EWIiM=;
 b=PSTDCZ12rr5mjR0Le2+Bj7Z1/PI9SL+H3TzRvfnarG+ZWAozExSO/MYK0Z1dqH5tPDGWsGmPJu+9JztdeOaV6X5M0sRR30elCiIR6KjH/faixeOaS10J6I/NziLx+M2GiLmU7z1GVCSyV1peBG9ABZWNFVQ5iktd9gsgK6+GpN8WR4mYPHUWHarRpngxWM2VHjlkRm7fX16PWQxjF+PoClFnRuLjMtxpp4XKCk55BaqKIZ3re6Fv7dDrWR4PC95EdlUNQJGchCyvN81XzpAuZ6E/eAUFngMtEkbZq0yrbuN+Nss9AWu5tkMvs2qnv/iXRL00fJI5vlS+ZTmv8IG55g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lpct42TLw9c3mZk7cEfcrFRBmkxx33Kks4JC15EWIiM=;
 b=dfaXYpW5a42kgEBToCDsr2bYxXzJmeCMUvQwU02z9M3+gEpFUnc2q/XVeLKljZA+w1tnm1knMB2RMbShzGcoCUAwjQTyj6xvFdRicx0wT0KI4AnnPsgJUt4mnQ2AErdSvwXu949/myfqw9kvRVMMR13Y/+AQzLVaoMHYrDqLqjY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SJ0PR12MB8138.namprd12.prod.outlook.com (2603:10b6:a03:4e0::7)
 by SN7PR12MB6839.namprd12.prod.outlook.com (2603:10b6:806:265::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.12; Thu, 28 May
 2026 23:10:33 +0000
Received: from SJ0PR12MB8138.namprd12.prod.outlook.com
 ([fe80::633:3c3f:3a9b:993]) by SJ0PR12MB8138.namprd12.prod.outlook.com
 ([fe80::633:3c3f:3a9b:993%6]) with mapi id 15.21.0071.011; Thu, 28 May 2026
 23:10:33 +0000
Message-ID: <96eba597-65a7-4df3-b0b7-ae811de0b8da@amd.com>
Date: Thu, 28 May 2026 18:10:29 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 8/9] x86/resctrl: Ensure domain fully initialized
 before placed on RCU list
To: Reinette Chatre <reinette.chatre@intel.com>,
 Babu Moger <babu.moger@amd.com>, tony.luck@intel.com, james.morse@arm.com,
 Dave.Martin@arm.com, bp@alien8.de, tglx@linutronix.de,
 dave.hansen@linux.intel.com
Cc: x86@kernel.org, hpa@zytor.com, ben.horgan@arm.com, fustini@kernel.org,
 fenghuay@nvidia.com, peternewman@google.com, yu.c.chen@intel.com,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <cover.1779476724.git.reinette.chatre@intel.com>
 <3ba2959b1cd3596e1e340eaee6b43487edaec0a4.1779476724.git.reinette.chatre@intel.com>
 <4053bd27-bca3-4745-9f34-65843e250f12@intel.com>
 <6a0a2f88-c22f-4a08-b3cd-b46e9677caba@amd.com>
 <c6bc7632-6076-4bb9-82d5-c1cf1b9e8188@intel.com>
Content-Language: en-US
From: "Moger, Babu" <bmoger@amd.com>
In-Reply-To: <c6bc7632-6076-4bb9-82d5-c1cf1b9e8188@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0P223CA0027.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:610:116::17) To SJ0PR12MB8138.namprd12.prod.outlook.com
 (2603:10b6:a03:4e0::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR12MB8138:EE_|SN7PR12MB6839:EE_
X-MS-Office365-Filtering-Correlation-Id: df5a3dc6-a5c7-4018-2fa2-08debd0e518f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|376014|1800799024|18002099003|22082099003|11063799006|4143699003|56012099006|6133799003;
X-Microsoft-Antispam-Message-Info:
	MtwhwpmfGRIKI99c3QaEs4avVaYa5xHOVOVK/QrWsucvCxEEMIsRPSfYySmP46YdK82egKvb0y1+1VdAN9z4Uj+G9rg2kTuVVuG5Hs335ZPex1gMEr2aYE8CFEiG22yALRsDm9AWjDAxtsXTV8r1yuk9Og4QKjAUZ1PphugZCImzrOytDXOfvvY1eSHpEF50iEig8tFYFNKyzYuBZolILKL7d1Y+gSpgkFLc/kr+vsTScNPxCmTAZQQQvBjj8KbHI50J3gG7hOdnYpibBHjkDBNOzfwBcs0ds6ysDDlwxFt8o7RNmI+uwl8BPuXTVpSuFpUjUR7WOJpGKPo+S4Q5rpi++XpgF/iDEbxUfkOBuYYfjNa7d5WcKG+PZmcU7+BD97feOVAt6ar3YQt0v3AiMgS4ipqr8U7vMCEZZDtO7StMm3vBA+j1NA9r83fwlASsytNSFIid5RSq2EaXNRsOAHra4ZACfpnC0ubGEutySTbcWSqOBFbcr+jKFnb2VNCK5qflrYZeT2BHWJynbEFPnWoCzTiDWKPdfD51DghZUUj8CdcUFWol6zc3Pir/vTxapV+8BQXsP6Z9NqGqAetWOqEcOSuv/qmQgTdDLqtc09vxjLdoDMoN5osb1xTOSdKKtoVvGtwiP8bNKSMsvkYrGTm7jQw6/HQmycno0z7GbvkldHptSABLbmNd2F8nDddY
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR12MB8138.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(18002099003)(22082099003)(11063799006)(4143699003)(56012099006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?di9RV29MVlhLMUxPVnVoVTcrRGdKOEJvQjNvdGZ4UHNkYTBBNmVKZGlPWTdt?=
 =?utf-8?B?NFFWd0tjOEZpMmt5SkxuMWtXTHJyMGR6ajY3MTJBSUxOYUo2VDlSNDRISHRR?=
 =?utf-8?B?WktxeW0ydjk1RDdTVHhoUzdQYmNxS0wvU2FRUGRZT0NiTEpCMm5ZdnZncitP?=
 =?utf-8?B?N2ZYZU1VWDdMMTFnKzdvOEdwK3FkeWtWaFlaU0w2Z0piUVVWM3F4Q2gzd1Zu?=
 =?utf-8?B?RjRjOE5VL0xoMkVpd3VlcDJLcVh3cjg1RHcyRTg3eWJ4aTluSW5KTnRhYlpm?=
 =?utf-8?B?TDFuanJZcWlzOG9adGxDNk5iRDBFZXlNQWJkZEJOVUtiT3JOVFhNVW9pdXph?=
 =?utf-8?B?dGx5WnpFRE4wdzdka0YvSkJmbUF1Sm5qWWZQZWE3bGFmdTdmamJuOFFndGNK?=
 =?utf-8?B?ejg2dEpoRmkrSjhuTlBvMjVHT0hOTUtSaG0vQ0g2WXhLNkJQcU12eTV1TWFu?=
 =?utf-8?B?aVhDS00xcmZHZG04dEdpdk9BZzUwT1VKOWJkT2VjQmNTQXY3MGVKUlhuUkxV?=
 =?utf-8?B?ZjNDWWFVb3RXa3gvS1pGckRBK0NZT2xzOEVCYjJHOXRXN2tWc2xSYkJEMHkr?=
 =?utf-8?B?ejQ1RkJIR2YxUU4wcldrUUtGZzlibHRmZFd3dGNiNlRIWGorQmovRmI3Y2lm?=
 =?utf-8?B?Uko2dW5jVjNnVy9OM3d5UUp4dDdLU3NEWjZzb1ZBQktzOFhWL3RpT0NHTk9N?=
 =?utf-8?B?dGNaa0QzYVUxRjJST3QvU3FDZTFFT0c4bjdHaWNFYlVueEFkQ3luM0xnWExu?=
 =?utf-8?B?T244WEhPSUFjN3pneExuelpnd0lKQ1paTURUVUNKR3k0Yldyd2w3bE41V1N0?=
 =?utf-8?B?c3BRQ3ZodHFvajZhbFZha2cwOEVuNmY3WVhpRnVlVnZ4ZTVQS1pERFNCbTU0?=
 =?utf-8?B?bi91a3ZTaXFkVHhjQ1lqcHFQd2FpNlRLOUtJNVY3VDF3eWlyc3d0eHp3ME8r?=
 =?utf-8?B?cXVXSjBKakZWdlQwYklHdkNIeTdEUWxCMWtVWjBLM3lEaHBXZ1lkWllmSnlR?=
 =?utf-8?B?OGVEcWI4cGgwOG44SjF4NXlobGxNbG9OaTJLN1kzUldtYWtiUkkwUDh4TDBw?=
 =?utf-8?B?NCt5d0JOektoYWxyTVd4cGhYYmRobjUxbWhDVmVuUHpibGpoMEw5bDJhdXBQ?=
 =?utf-8?B?UFB2Q2FMSGJXTmVWR2NkMlA3WU5iZFhtZzREVkd2cUhBb0pTbW5VZW5kSnZO?=
 =?utf-8?B?dXJtZHBJTk5OeVZETXFIRUsxcDNPdDF4MDJqR3NPeXdMYzZSY2NmMzZnR2Vr?=
 =?utf-8?B?VUxYOVowQmxlU3VIR1c3RDUrN0ZSbW5kOEk4Z0QrYmVwWE0xQnZ0L1B6SEdn?=
 =?utf-8?B?VkpUeWd0MitSOURwREZ1N1JtR3VxeWg2RjJISE82VWlKdEZGamNoaGtEN2Nn?=
 =?utf-8?B?K0w5RVN5d1FydUlzbHRzcjFid210dWdYVVZoTXR3ZmtGS0FYTGlUQlh2VHhG?=
 =?utf-8?B?OVFIb3lxTFdxbkgvSEk0L0ZKWUdhbi9kc2FrQjYwVGd1UGxya2x6NTZ3c0dQ?=
 =?utf-8?B?bHUrQlRJM1F3bGZhZ1ZjQW05T043SlhiSEgyV01JelZEYU1CZTFsTzFiaDgr?=
 =?utf-8?B?dkxPbDFQc21wT1ZrT1lBNHdkdFd1cUFOd0RaV29NWHNzZ3liWXNxbkxVdG1l?=
 =?utf-8?B?RndnZ3FYSzI1T1JURmhoSnhBN2hvamtqanRNbSt2c0grRHljblJma1lNRm1E?=
 =?utf-8?B?MkFFOWhXbTJtQ2MyVjBxNHJFZTg3KzRWRmg2U0JPeWhMbXBxTjIyMFRVdlYy?=
 =?utf-8?B?UWRZeUg0MURhcC95amw4TmUxNy9DSGhXbWl2SENMdXVYS0w4cTExMWxMa05w?=
 =?utf-8?B?UzJuWmN6ZUNaTkIwMmx3VFhHK1djR3V4eUZBUGx5eFBneWY1UFlpZVd6b0dm?=
 =?utf-8?B?VWRCdVJ5YTczZWVVN0Vxb1Z6VEwyR0FOT0xxcWlhcXdLV2EraVR5bG41UXBj?=
 =?utf-8?B?TlNVZXFmTFFjZkFBQU1VaUJlck9mSVErcU1na1Z1b0dVYnNWenUyTUFSZEMv?=
 =?utf-8?B?SHFYdTNPdmd0NG5PZ0JsMll6TFJXUDd4djJtTW1tTThOemM1MHJDL0NJcHNh?=
 =?utf-8?B?S2ZJUEJTbzBCYU9EaHZuSjYzbWFWdXhpdG9jeUkvQ3p5SnFPd2xzNGVwY0RL?=
 =?utf-8?B?NXBacTJ2b0NhdGdqQ2V0SW5DaUxmSHNsQlpEamVBU1FKMFhMc3J4Ym9Tby9O?=
 =?utf-8?B?TmRYQVBObEovSkdSSXV6NytSNTExUDRIQTR2YTQwZ0FaK0R2UVpqMXhyVzNu?=
 =?utf-8?B?RzJsK0c4ZUx0SCt6bVFoa1Q3dFpOM2ZndUNESURGTHNrTGZhUUlOd1JwUUdS?=
 =?utf-8?Q?ErGtMmBCIhAcQc59V9?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df5a3dc6-a5c7-4018-2fa2-08debd0e518f
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR12MB8138.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2026 23:10:33.0818
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JTyVBO3bckrKpKBgA9f758DBBhQuvGG48Ep+3tpntqO/RCKgNbHVGlfz0gZ1SiUR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6839

Hi Reinette,

On 5/28/2026 3:56 PM, Reinette Chatre wrote:
> Hi Babu,
> 
> On 5/28/26 12:04 PM, Babu Moger wrote:
>> On 5/28/26 11:11, Reinette Chatre wrote:
>>>
>>>
>>> On 5/22/26 12:15 PM, Reinette Chatre wrote:
>>>>    static void l3_mon_domain_setup(int cpu, int id, struct rdt_resource *r, struct list_head *add_pos)
>>>> @@ -556,14 +554,12 @@ static void l3_mon_domain_setup(int cpu, int id, struct rdt_resource *r, struct
>>>>            return;
>>>>        }
>>>>    -    list_add_tail_rcu(&d->hdr.list, add_pos);
>>>> -
>>>>        err = resctrl_online_mon_domain(r, &d->hdr);
>>>>        if (err) {
>>>> -        list_del_rcu(&d->hdr.list);
>>>> -        synchronize_rcu();
>>>>            l3_mon_domain_free(hw_dom);
>>>> +        return;
>>>>        }
>>>> +    list_add_tail_rcu(&d->hdr.list, add_pos);
>>>>    }
>>>>      static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
>>>
>>> I resubmitted the last three patches of series to obtain Sashiko review [1] and
>>> respond to that feedback here:
>>>
>>> a) Sashiko: "Does this reordering expose the monitor directories to userspace before the
>>>      domain is actually added to the RCU list?"
>>>
>>>      Yes. As pointed out by Sashiko there is a short time where the monitoring data files
>>>      may be exposed to user space before the monitoring domain is added to the RCU list.
>>>      Also pointed out by Sashiko, if user attempts to read from such file it will return
>>>      -ENOENT.
>>>
>>>      This behavior looks correct and acceptable to me.
>>
>> Yes. I agree,
> 
> Thank you for taking a look.
> 
>>
>>>
>>> b) Sashiko: "This is a pre-existing issue, but does resctrl_find_domain() safely traverse
>>>      the RCU list?
>>>      Yes, this is safe because resctrl_find_domain() is run with cpus_read_lock() that ensures
>>>      the list can be traversed safely because the list can only be modified with
>>>      CPU write lock held.
>>>      One improvement to resctrl that would help support this is to replace the "list_for_each()"
>>>      domain list traversals with something like:
>>>          list_for_each_entry_rcu(pos, head, member, lockdep_is_cpus_held())
>>>      Doing something like above would help document why such list traversal outside of
>>>      RCU read-side critical section is safe.
>>
>> Are you planning to make this change at this time? It appears to be a corner case, and we haven’t observed it in real-world scenarios.
>>
> 
> I am considering it, yes, and was planning to make the change first to determine the impact on this series
> before deciding. This is not a functional change but instead making the code conform to best practice that
> implicitly documents why it is safe to traverse the list outside of an RCU read-side critical section. I
> think this would be a nice addition to resctrl. Including it in this series may actually help reviewers consider
> all the flows involved in these races. Do you think this should be deferred? resctrl cleanup work is not
> popular [2] ...

If it’s as simple as just using the new call 
(list_for_each_entry_rcu()), then that should be fine.

I think this is a good candidate for deferral.

Sashiko appears to be reporting every possible scenario, so we may need 
to decide what should be prioritized in such cases. Finally, it is 
your(maintainers) call.

Thanks,
Babu


