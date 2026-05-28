Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012034.outbound.protection.outlook.com [40.107.209.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3436F314A8E
	for <patches@lists.linux.dev>; Thu, 28 May 2026 19:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.34
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779995102; cv=fail; b=sJtswqx+NdgJt101bvPIxFJ/V5/vbdqv0sREgXrVSJLEhS+FfGHeLruYMQd2jZds7rawanxzditesHkvUPmdSNULaHcLl8N6CXbdCLftczwEuNZBJZhN0I1QIVBMX3gNtvihpOFipHnn1pnlOcA2iQM4h8FwIuKiGMngp35aIMk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779995102; c=relaxed/simple;
	bh=o++8busD6MKT8c+RpHftQXL2u+yM/9KP8PC0pAbJocc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=s8/JJsYPlrUSquIoM1bkVaplfVrH/Ba3uJ0TqxMUln/89xBnmu5NFuc946TrgTF7G4TzgmjLvs1B1KSnzglcdfMzt3ZIQ/sX7L7c3Ww4qQXjJTrHVR+RGW/C69q/FmAqY+2JFjRJxNN3eOu6Bh3gEVOV93XJ7qEcVDhXz2qokNo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=mT5oxnWZ; arc=fail smtp.client-ip=40.107.209.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="mT5oxnWZ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NhsK1Qx3ZvFam7Lsa6AlZGthtDfTXYIBeg8/Jo/aftTrY6XJ6x0BXEd4zO2T7kIkj4hC8Rb5XUF9jjqyXcg287bKQDVKG9mpE03p12dGBt324Z5dkSGnBN7Hg5F7Tk4LLvDp9U9AYI1kEnpR3aX+eQ5zYGor3WOmNRgi8PvMzm4Ro90dTGv43rjpJSe0/M13PzQHUjafd9yspmgdv3AHHBTXWOxssG80E24wzxdtnDh7mKhiF6GF2LWplwuaPWE6nCTLnPPORPRPUXSIOaPDc9bqaYo55fGPZaLuhDyiVlVyuSsPOsZrG61Dc4TjExlegiN4PHaI8W+ZsQs7bFKfBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=31kSmwKIRRaiZ2PqiLn3h0TdlwhEjXEe3e/74iTCwE4=;
 b=NLapmxHS0jPm2sRNb0tGwoQgt3O2og3lwpJ4oKrcWpsU18jQYaUX9vuQMbH2NfrxJKXLUjgQhxnKd7BK7qnEeAj3fht+xNKcWXviXtMrRylGQPn+Z/St17yptyLjop9jHE23Xh+9MCVgsMZ2w+vzfTSizR92wVINwhv0K4LWmkh6fmSA5g6o13VEpPk4IMFh7d3pWHaLBEuFLxVjFzhoBpnlsCAClYJLMrJwqODocxaGXdidi4Bcswxb3E8yN5UxqtYZxQWOumWIdbq6RtUencPw0T93dHpZcYr7fbEVPXQPv1OxC1wEwfz5y0fCiHiGxoVdJMFRIAdgcHVWAfp76w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=31kSmwKIRRaiZ2PqiLn3h0TdlwhEjXEe3e/74iTCwE4=;
 b=mT5oxnWZ0w5/+cdNOlzRJmq7nRHblfGogfixAFNcmsQcFzBy/8eYn4yLawm316RnPJeSDgOSbPKiIlgdkMG0Pi1D26gQ5wGCKyAk9oB231fCPyoA0UYPphjNNNPvhYcaD/R+pdrxJcwNb+jJ4RP5sOuQQWTn6wiOF7GGDtXDLzY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN7PR12MB8148.namprd12.prod.outlook.com (2603:10b6:806:351::17)
 by PH7PR12MB9224.namprd12.prod.outlook.com (2603:10b6:510:2e7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.13; Thu, 28 May
 2026 19:04:56 +0000
Received: from SN7PR12MB8148.namprd12.prod.outlook.com
 ([fe80::8262:5400:b63d:c8a2]) by SN7PR12MB8148.namprd12.prod.outlook.com
 ([fe80::8262:5400:b63d:c8a2%6]) with mapi id 15.21.0071.011; Thu, 28 May 2026
 19:04:56 +0000
Message-ID: <6a0a2f88-c22f-4a08-b3cd-b46e9677caba@amd.com>
Date: Thu, 28 May 2026 14:04:53 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 8/9] x86/resctrl: Ensure domain fully initialized
 before placed on RCU list
To: Reinette Chatre <reinette.chatre@intel.com>, tony.luck@intel.com,
 james.morse@arm.com, Dave.Martin@arm.com, bp@alien8.de, tglx@linutronix.de,
 dave.hansen@linux.intel.com
Cc: x86@kernel.org, hpa@zytor.com, ben.horgan@arm.com, fustini@kernel.org,
 fenghuay@nvidia.com, peternewman@google.com, yu.c.chen@intel.com,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <cover.1779476724.git.reinette.chatre@intel.com>
 <3ba2959b1cd3596e1e340eaee6b43487edaec0a4.1779476724.git.reinette.chatre@intel.com>
 <4053bd27-bca3-4745-9f34-65843e250f12@intel.com>
Content-Language: en-US
From: Babu Moger <babu.moger@amd.com>
In-Reply-To: <4053bd27-bca3-4745-9f34-65843e250f12@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0PR04CA0063.namprd04.prod.outlook.com
 (2603:10b6:610:74::8) To SN7PR12MB8148.namprd12.prod.outlook.com
 (2603:10b6:806:351::17)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR12MB8148:EE_|PH7PR12MB9224:EE_
X-MS-Office365-Filtering-Correlation-Id: e8c52475-84bd-439b-ff34-08debcec01fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|22082099003|18002099003|6133799003|56012099006|4143699003|11063799006;
X-Microsoft-Antispam-Message-Info:
	Fj8SFZ1/WvjYCCjJZhLcPK5mRLbTJm9Mtrkq07vLc1YOodL79b92pMLaGpzIDTh6Far7eL6J/CwVAU0hJPWWbNvxQUFv8jM/fArYzmOXiDzmLnc1zk09F85Fbv7Xj46InFb6uf42hszQWRfiQRCjV0o/wnV4R89aHGLyz7ZCXveHo9o8lBWxU1d7pvf6XDaec2GqXKNOG4iyvCh3KnIO3NatZOnUGhlJIjdiqr1PttsZhBlC5gHTEQsV/cQ35iGYIVWneJGyDMp6d99gOTATalfP8k/Q5/cawRltCLdlagSCGpCiSPkE2Rzwp1rrGQ2wu6XMXA6IQNGaQhWdNmVbRlDWctf9/iiR8jOOrxxYA5aRaKYJj0RD0dTs9Jqw5tqliNsFvabXA/q4t3TWOMXkSGy+TNnb3K0n4Q6nszGpIa8/RhyCBgXFJM708o9WyogUCJEIijWbHW2M+d3wyw8PTnc0MzlWvtcx0viWKxYIqi3Pm8LwpahHX5PGhoaNwBuq6PmussAVzOMHK7xJ8kv6gwYnjJR/+KFH6ytRKpADra8AuvhvfhQJYMIe7HWsVzIjopoABsJlpXmLrvvRyyGJR6anSgE9nPEjX5Nsr09cuptYcAUiChYbuCIesGUOHz9w9XXlXN7cbkzP7/xLUcxFUWMNMOg797ET73HQ9P+OH77cBLWWGjVMtBjIpiRa6uD+
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR12MB8148.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(22082099003)(18002099003)(6133799003)(56012099006)(4143699003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dmtPYTJhV2psSksvdWlhaS9wWFNldVVkeXRxRExRWEpWd0ZDWkRCdmlOSU1X?=
 =?utf-8?B?SGVqZVNpaTJuUW0zekZ5ZXNoU2drRHNyQWVLeE54VHY5a3U2djA1c1ZFbkNW?=
 =?utf-8?B?V216VHhVZGg5b3RIZ21LbjlNaTBXY09GR3NNUnpJb0tWaDVKd0tDSUtKTmZF?=
 =?utf-8?B?QkNjcUxsdEloU0JCMnNLU3NEaTZCK1JoQzhoVjJTdi9GZWREZ2xaOGF3VGtF?=
 =?utf-8?B?L04wOVVHVUFGM05oSENoU2t2Sys5N0VkdURNVFZkRGVEY0JHa2xKNDRGcXhN?=
 =?utf-8?B?VlhnUFo0TkxrRHg2WVRjZUM2WFZScGdLbFQ1djlMWVAvT1prVFlheTUzakxB?=
 =?utf-8?B?N3pTNGFKbUZUWTBXdE5ZRU9lV1B0M2VTdE55enQwZ0ZwWVZwVzlPSndtY3Jz?=
 =?utf-8?B?d29uWVluWE5FZ2crWmZuUDM3S1JySmRFTWVCRlZCWjNFdEdhMDh6eDBVdXdB?=
 =?utf-8?B?YmNNeXFGRjRKcDlzLy9oVW9BanNvbmYxcHlQM3E0N1VaaDd2L1J3VkpYdmdY?=
 =?utf-8?B?NG5FdSsxaDhSQXBUbVpEWGhzbmM0a25ZV21pRS9rbGNwOGtHQnVUa2F1YU9L?=
 =?utf-8?B?TTNOTGp1TDJtemRmN3Y0M3FiUTMyemZTTjNHNGdydU4ydGE4eU40UGFmNlNF?=
 =?utf-8?B?akkwc1RxZENxZ2tBQjFDQUpNL2dRaWVpWkgzUWNHTzRoL2ZCV1NYSkllS29l?=
 =?utf-8?B?UnlJeWVvbmxJd0M0cGFsRFRQQVo4dFdMWXQwYWhTMEJOaDhKYlpCY1NsWTlI?=
 =?utf-8?B?WGVlRll5d1hxZW9TUk9TRTNGaHp2UncrSE9KWExGbHFrNGJrOU4wa3QyclNC?=
 =?utf-8?B?d3F2Z3B3M0FqMkkxcjA2cE45L2k1UGZZay9WZjBKZ2d1YWtwclQxWGVDKzBt?=
 =?utf-8?B?WW5JWEx0NmVqSk41MFJqd0piUnBSUlVOMmFoWGNQNGhNemxGK2luZGowL015?=
 =?utf-8?B?em55Yzh4R0xxR285aXpwT3hoWm1wWkk2NkpjT3M0US8ycUJDN29OeE5IRWxL?=
 =?utf-8?B?ZkZ1emtzVndBbXg3UDZiejh4d29rbHk4SnYrZzJpdUMzOFluMGNmYnlhb0pj?=
 =?utf-8?B?ei90UDdOZ0FHTmthNkNaZDB5bGxHYW5maXl6MFlLYlFvRm5ZM1hBY0xzcHUz?=
 =?utf-8?B?YXZDYVNlT2NaV0s1TzdhSkJ0blA3Uk5zLzlrdWZvaUllK0pEWjZoNXZoN1I1?=
 =?utf-8?B?eWZwN2NhN243WUpWN0F2VThadXlTbTA2ZHg0RURRRmFHSzczcFlXTEExVlFj?=
 =?utf-8?B?ZTA2VXRaK1NaWDVlbGhPNWVnSy9YMEU2K2ozd3ovV2YwN2Vod2FRTW5ycElm?=
 =?utf-8?B?ZUpwd1V2dGJOMDN0L204ekhzU2tCSW1oSHY5SnY2K2lIdUpGVEpjZTNjQ2Zi?=
 =?utf-8?B?WENrUnlNeENITHZkcjIvczR2V1hDVGQrSHExTTZMZHF2bzFjRTV3ZU5ReVdn?=
 =?utf-8?B?MHJJTUZzY0dKV056Mm1mOE1xLzBGTWNSODVTUmQrbUxrTWtOZHJ6a0VTT3JG?=
 =?utf-8?B?aFl1djBOTTdURWE4Z2ZLVjl0VzlCSWs4WEUzWnBodlZobTZnZGxCSVB0SmdU?=
 =?utf-8?B?MVFNMDIvZGJJU3BUc0R4V29Mc1NYT3VmZXVYWVJOZTE5VVR1L0M4dnVPTEZC?=
 =?utf-8?B?N2xablZZMFlZVU9qbmFLY05JenZScUlXVkV1S0Rzak5UekJZY1lweXAxU05O?=
 =?utf-8?B?eisxL0lITXp2UmtuNEFzVFpqV3RvOUlmVXBmZStjTDE5N0hsTzFuS05yc2Fp?=
 =?utf-8?B?c1hkcDNQa01UOGV2UmZzenBFK0tpaHl4aEx3aXRhUWdsdkVKMmg2dEczaFly?=
 =?utf-8?B?RTBZRWVnMWFLSzhWYjlkNXRwUE5MaWFMQ0FPN2puYzRVQXFpQnFBaXA3WEoz?=
 =?utf-8?B?cCtZRE5vK2xRejBsMGkwTUtnbVN0dHJQRTlpNGYyS00xUDFGd0N2Qld1emxy?=
 =?utf-8?B?YnlRM2diSFQ4TmVrSUdnV1ZyOHNXZ2V0T2txYmxUWjhXZ2I2MkpPWWdlVTdG?=
 =?utf-8?B?R3JuSk95VW9VNXRoSEtlSmUvdWFNRWpRK21zT2d1ZmdkdzU2T05aZTBpeVBh?=
 =?utf-8?B?cUphWDhEbXN6T0w1aEpwd2ozVDFIUUZwaUQ3aDZ2ZEUrcjI3QVN4SytUWXBq?=
 =?utf-8?B?Z001b2srTm4yclJ3WE43UzBxTDlkOGlRSW1QY1BweDFpandQcmJQMW8zVWZ5?=
 =?utf-8?B?Zjc5TW5hOWpuZU9RRjdaOWNjcG9CaHdUWUc1RFkxem10QkptRm9yWXluN0Yv?=
 =?utf-8?B?K0tPU2hRaVk5VHZmK1RCYnprZVYxd3dRYUVnMkJzU2lVQVlpMGtCc2ZDK2ZC?=
 =?utf-8?Q?rwQqq3vnb0gqhqDX6x?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8c52475-84bd-439b-ff34-08debcec01fa
X-MS-Exchange-CrossTenant-AuthSource: SN7PR12MB8148.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2026 19:04:56.6070
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +W3TNeJrqp3+KfjAASM7O0Eu4zP9WROFakvnWrWpx/Rm9Z+1VikfoJb/IiT4pbP/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9224

Hi Reinette,

On 5/28/26 11:11, Reinette Chatre wrote:
> 
> 
> On 5/22/26 12:15 PM, Reinette Chatre wrote:
>>   static void l3_mon_domain_setup(int cpu, int id, struct rdt_resource *r, struct list_head *add_pos)
>> @@ -556,14 +554,12 @@ static void l3_mon_domain_setup(int cpu, int id, struct rdt_resource *r, struct
>>   		return;
>>   	}
>>   
>> -	list_add_tail_rcu(&d->hdr.list, add_pos);
>> -
>>   	err = resctrl_online_mon_domain(r, &d->hdr);
>>   	if (err) {
>> -		list_del_rcu(&d->hdr.list);
>> -		synchronize_rcu();
>>   		l3_mon_domain_free(hw_dom);
>> +		return;
>>   	}
>> +	list_add_tail_rcu(&d->hdr.list, add_pos);
>>   }
>>   
>>   static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
> 
> I resubmitted the last three patches of series to obtain Sashiko review [1] and
> respond to that feedback here:
> 
> a) Sashiko: "Does this reordering expose the monitor directories to userspace before the
>     domain is actually added to the RCU list?"
> 
>     Yes. As pointed out by Sashiko there is a short time where the monitoring data files
>     may be exposed to user space before the monitoring domain is added to the RCU list.
>     Also pointed out by Sashiko, if user attempts to read from such file it will return
>     -ENOENT.
> 
>     This behavior looks correct and acceptable to me.

Yes. I agree,

> 
> b) Sashiko: "This is a pre-existing issue, but does resctrl_find_domain() safely traverse
>     the RCU list?
>     Yes, this is safe because resctrl_find_domain() is run with cpus_read_lock() that ensures
>     the list can be traversed safely because the list can only be modified with
>     CPU write lock held.
>     One improvement to resctrl that would help support this is to replace the "list_for_each()"
>     domain list traversals with something like:
>     	list_for_each_entry_rcu(pos, head, member, lockdep_is_cpus_held())
>     Doing something like above would help document why such list traversal outside of
>     RCU read-side critical section is safe.

Are you planning to make this change at this time? It appears to be a 
corner case, and we haven’t observed it in real-world scenarios.

Thanks
Babu

