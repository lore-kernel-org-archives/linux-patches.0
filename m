Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012005.outbound.protection.outlook.com [40.107.200.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97C394AD7FA
	for <patches@lists.linux.dev>; Wed,  7 Oct 2026 14:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791382376; cv=fail; b=Cpypa9ZoOflkFOcbAdk/y1zbhiHL2jHIUMsLwZrnPwcBz036RCIIaQm/Me61XrhwVvSOYJ4lw5rU8x3nix8DDQQrGx4SWXdMbwbH8cCXqTzbzLMQXX28YlUEGiHy8OQPlT++HdypdUNn2MJX4T6eOQI/Vd+VUMHQhJKYy4CuQHM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791382376; c=relaxed/simple;
	bh=PXsyPThJL5ETmsuxcx8rkk/VAQklFhxbCMQBHy46sak=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YUiBDz8qvOeueX5H5+iEonke4oHjmA/Gjv6QkcWZbYr2zkx+JoGZC6LIP3lJohqGTsWCFNrjv28F35vZSilamfGCfaxS5zVMeX0lp33s8byndVW96sSNeeHO8arKu9Uw8QGOWHVkEPbVAXoTgtQix0AnC7ooKIKqTNILfTlD4fQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=u43EuM5o; arc=fail smtp.client-ip=40.107.200.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="u43EuM5o"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XiSsUZL75WrQ2Siz34jToSe1KpOMcdwRQwGnHBJIrHexl+W+ZoTkdLUtxMTN6BnqsATLhu1ylr03TSrCeYVWkqqups46yPRwoe2TbVeMY5M6KZgWU53evOy2Fot/k3+UhMNXupbMaSu9TON9C3eMCQpOIn+N/Ag6TcM7Vtx6ljwUxGVlIjs8JvQAzZQETtHfh8IP06v6sDwwpqsYAgT32yMSggWPqZeEB+0WJ9klNlYe3cDZ1uPPOYmtZVKgHVbU37WBKzfnknKW7D0/jnRoDJrRPn6DMvLZjDC9Gj6Y/sFvYgFdCV+TQnPdVUhVm3DxX39D/B2hRQ+lEP2Cg2UtFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WtfitfPPz+iolHR8HCbmY22kF2TqUlrsUM749Tm5/qc=;
 b=HXMnNoI5HO/D+7VqDdc2k/cbDNwIv2mWAixdfbTcUuFb64w8627NPyInLmSPMWA6yqh0M7J11tYs5Uwgt/Sg0IsyPZttOnRdAoQTNs9RbuE1KxrARr+t54vvXs3P7S9pgOvAyj/awnhPNIeNASbZ0zxbkgaw5KJgqeaj2XF9HzRHAI0CYnf+pWvfHQrowUIY4wqDxtaKkhXr053r7K+Rk8nGddCapV5pbg6hL/7GHiboVb3Kp18sdNqLcLmave0MZppuNEJ12GLAJsuYLl/coBUMmAQXzEdbw7VcX/loeW2APQfdZVuLq2doS+EjBGvrAqKis+rauPfEGcEV8YS1fA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WtfitfPPz+iolHR8HCbmY22kF2TqUlrsUM749Tm5/qc=;
 b=u43EuM5ojVGtikPlzdnCQtxN58nzi+yE95hAYZPDzgQUqC9GUy22ZQIgV6n017Q1MPLRnPboMtfRx4NcO/ekGt6d5xaSCBHKnIfebxNcv4RshGJe/hJSO6NTLTDlKW3BfariT7gCkKE1wNm/riMmHzx8KGJodFYnIc4yRL98FxA=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5320.namprd12.prod.outlook.com (2603:10b6:208:314::17)
 by LV8PR12MB9691.namprd12.prod.outlook.com (2603:10b6:408:295::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.15; Wed, 7 Oct
 2026 14:10:41 +0000
Received: from BL1PR12MB5320.namprd12.prod.outlook.com
 ([fe80::1876:4a6d:2cf5:b8d1]) by BL1PR12MB5320.namprd12.prod.outlook.com
 ([fe80::1876:4a6d:2cf5:b8d1%5]) with mapi id 15.21.0496.015; Wed, 7 Oct 2026
 14:10:41 +0000
Message-ID: <b1cd4422-bbff-42f8-bf3a-0d21d62bd8f4@amd.com>
Date: Wed, 7 Oct 2026 09:10:38 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 13/25] arm,x86,fs/resctrl: Allocate maximum needed
 rmid_ptrs[]
To: "Luck, Tony" <tony.luck@intel.com>, Babu Moger <babu.moger@amd.com>
Cc: Fenghua Yu <fenghuay@nvidia.com>,
 Reinette Chatre <reinette.chatre@intel.com>,
 Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
 Peter Newman <peternewman@google.com>, James Morse <james.morse@arm.com>,
 Drew Fustini <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>,
 Chen Yu <yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>,
 x86@kernel.org, Christoph Hellwig <hch@infradead.org>,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <20260928221509.68002-1-tony.luck@intel.com>
 <20260928221509.68002-14-tony.luck@intel.com>
 <327d9248-2e4f-41b8-b4ad-4f6d01c85ecb@amd.com>
 <asVxNVeP8d6HPRu0@agluck-desk3>
Content-Language: en-US
From: "Moger, Babu" <bmoger@amd.com>
In-Reply-To: <asVxNVeP8d6HPRu0@agluck-desk3>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS1P222CA0024.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:8:44b::10) To BL1PR12MB5320.namprd12.prod.outlook.com
 (2603:10b6:208:314::17)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5320:EE_|LV8PR12MB9691:EE_
X-MS-Office365-Filtering-Correlation-Id: 24fef3f0-cf6a-4781-9ff7-08df247cc564
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|7416014|376014|10067099003|5023799004|56012099006|11063799006|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	oyAa3LwlcJJEcRsOxWap1Igi7Q5io8GUhOiqLnXYkAhUDi3Iz4gK7kG7DRyEgBJtLRv1eVy/rJ6ShEdLZdKjQngc35K87aUU656/xt/naYvW7MDBIRxkDGjRi2laGdE0l2bPeX32x9HKf+3aate0zcFquKUVZa6D6WqoYoZpXf/1Cb3ydpeURXbBiLfIMw6p1WsNUXS+wT5mLs5eX5S2rpN2ke14rgP0V83j3xJx63doC41g009N2axQiuEQb/pk396DfrrexWJqdgRM/xGzbGhAob0I74KfQjLjTOOaMwUVDZHoBzLh03it9SGvR+W/LOb5eLOdFFKaNfIS8zIcNyQb5xFqz/j3eyk5iBVz/RqCpxmH8APTXehGG9xo8Xv2vFz07VR3ToBbexglGwqnFt2SBA3LByoH9lCTAs5EMLclplBrSqEpe6tOPu4dyXzQ5xJcOfp/FqGIju/5dvCwEDK9UgJSrDc/Gijm5Rf/CUOvN7Nn/KXUM9hcV1eCeZM09uETWt3Y12Y6tZ58KKL5Eup5uGgNPovskJP4e+os/3vF9QdOEsvTyuZZaO1KKsTo7m+C2fkhdfAIJX3ZhgLCOnMIMWBWq/4Wkfja74nkpXeISCWtwY9GJmT02yNudbpOouW+YWW0NDem0ZCmXmqQMdz7NCx2NN71PKzIn6QgFB4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5320.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(7416014)(376014)(10067099003)(5023799004)(56012099006)(11063799006)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R2M5RnhmTzFoTmRPcVJwK1BtRzFYZVZFN1kyQVYwdlRaUDY2b1ZHR3BWZ0E3?=
 =?utf-8?B?NSs5ci9ScWVOUFNOeC9FZzU4SDJ3RFhrdDE4RlBlMG5CN3F2eEtTbWpKNk5Z?=
 =?utf-8?B?TUdWTklLeE9OS0RvalIxSHpNVkx2cWk5YnVvQmF5Y1FEZWxRaWRndmRUd0RB?=
 =?utf-8?B?MUluTGtDdk04cXFUdEFNdUlsZEZkUmFVbUsrNm9mMVJFcnNRMHQrcVpkdTVD?=
 =?utf-8?B?NlhkNk0yOHdLaXRWSFlPY3YrTFNHTTJ4MFJSWWJ3MFYwVyt4Szk3azU1eExz?=
 =?utf-8?B?bjJnY3RoVC85c0xSRXNzNjY3VTRnNEQ1SHNpUnZ6MnJTTlhvR3Y2bDR4NG9j?=
 =?utf-8?B?RWh6UHVReXYrYVNXUDRuK0ExL2Rrb0dHTmw0UVhKNFFqcFplSkxYbU5IODNl?=
 =?utf-8?B?WDl3cTVsdmVFOTZuWUw3QXl6ekZ5eENrb3hJYVg5djl0ZEFSYVdrZTdvV2lk?=
 =?utf-8?B?Y0lBZzFaUFFOcTNienU5cEJrL0YrUGFGTFdNaXpmRVBvSEcrejZqVDFoREh4?=
 =?utf-8?B?Q2Z1dXNST0c5aFltL1Fta3ZsRUxic3IzdTlQdEpTYjgrMzM2MG15Tm8zb2JG?=
 =?utf-8?B?QlZHY3J2VytuSFUrSHAxQmt3Q1RndWZ5d2tlSkI5SGlDWGkvMno1U3hCRm05?=
 =?utf-8?B?RnEwMXdKZnByZGhiN3VKV0k0dmNxOXo4QytpZHl4MVNrZXFrSkFqaU1hNzY5?=
 =?utf-8?B?K2NPSCs5ZUd3TDlrUDRzNS8yTmpKNzlGTjA5dlFMQTJUZlh3TGt5L21pRFpI?=
 =?utf-8?B?Q0d0eTh2WElwcW9sOG9PTFRYWmlVZ3kzR0NIK2JBdkdtNjVhb0JKUlhMWUdO?=
 =?utf-8?B?dGdLZHc4VEEyVVlVLzJmcWUxOUJQT25ZUHk3ZkZVS2tjd3kzSkdYMTZ4ZTZy?=
 =?utf-8?B?Ti85bzlienpmVTN2dzRiYit3OVIrYlRRSzM5QmQ2ZFczT2JEMU5oMCt2a2N3?=
 =?utf-8?B?Wm9nSUFkMFhUVk9vQ1U5WitnNmdqbG1oK3NhMWtlNzVsc2kzU3pHSWlsY0w0?=
 =?utf-8?B?eFJMNGdXa3BhV1o1WVJvMlBVMjd1YWQ2S0NqcTF2aU1ubjgzaXlyTzB3dDhV?=
 =?utf-8?B?S3orTklrQ29FU3RpLzJqbERsWUFKdC9BaVhKZDNrSzZadlBTbXo4cm4wQnI2?=
 =?utf-8?B?VkZxMmxFd3NHcFhEb0J4T2ZRZVV4ZWlzZ2RnSElIdTUrbDF0RVltSXNNbTZM?=
 =?utf-8?B?N0RFQU41RnNZR0k3Qzl4eDhYOG5TbGhMenIxS0VnbjJiV253d1NMNmo0UDkx?=
 =?utf-8?B?ZjhQcjBwOUJlVHZNck9FNlYxb0ZFNkovRnpmZzlpcEp2TnZJUTEvd0NUekY4?=
 =?utf-8?B?VU5GZ0k5NGdBcGhRb2pLUnExMWxFYzlkQ0c4MktPUTZYZ0c0VXNUcFdGZ2dH?=
 =?utf-8?B?ckJOMzk0VHdkYnFPU0FydnpEN1VmV0J6U3dTY1VpeWN4R3E0RE9YUFB6ak4z?=
 =?utf-8?B?QndoTHl3cHQ1cFpvaEptVTF5dmVoS2k4M01Sc1A4UnVHcE91RHFyK3N2R3Iz?=
 =?utf-8?B?VU9qZmJKZEtpVkdkSUphMXdlMDJLaU1vL2VnRjcrdzdmT3pKcXZ4aGxLcU0v?=
 =?utf-8?B?bmFJakhjR1RqdW1RY1ZocmdubGxtNEc4aHplc2NVYlhYS0h1NU9ReXE3MEpm?=
 =?utf-8?B?WmRTV0xpck5uKzNMenFFWEcvSU5QZGlQQ1h6S05pcnBCdVAveTRScjN2ekxw?=
 =?utf-8?B?VGp6Vm40YWMxQUI4cVpjRzZMUHVvNE0yV2d1MEQvdjRHTTgyVlAzNEs2eFI1?=
 =?utf-8?B?b2FqaUZIS0lZV3ZCYkZxOVY4V2R3MWNWYTJHNVA0UllMSkNRbXJ4WVFtSjg0?=
 =?utf-8?B?OW1CZWo1cHdnZEJEY0trTjd3NlQzb0dsdjJ4TE9DbW4zaGFNenVlYlJVd2tq?=
 =?utf-8?B?UU9yazNHY3ZPYkRMalJzRUViY3B1ckVqY3k3VnltK0FmUUluNmdDOWZyeW5H?=
 =?utf-8?B?RS8wakVnOW8rckRqc0lURDJyTDdwZnJFYUlCTkxKYWh6OWtsNHVkdG9TTVB4?=
 =?utf-8?B?YU5kdjh0VWdqdmtnS3NGMlRzbC81TUFScGlRMDVqenV4TDlFeHZYYlZxb2pD?=
 =?utf-8?B?ekJUb2xxVDkyZUk4VFl4bWh0N2JaU2EvQ1RRNkh6Z3BGZk5zN2pYMUNCK0tE?=
 =?utf-8?B?T056ZHhvV25kNFdwLzFoT1ZFSURXQjRhV3UyWXNSQ3M5NUV1dzNnL095YURu?=
 =?utf-8?B?d09XdnlONHdWTHpBb25JQXVxWXlFSzZpYW9zc0M4VWZGUGdJSkdCRlVsYkw1?=
 =?utf-8?B?czZLNExQL3RuRURpV0FocDJDWjV4ZTlLcTd3ejlpU2oxZWpmNXdHeHJXaU5y?=
 =?utf-8?Q?UkhNuioZqSzLeu1fet?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24fef3f0-cf6a-4781-9ff7-08df247cc564
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5320.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2026 14:10:41.7444
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vrkLemfMLFWVULqxVbnqhxtPXap84AmNMBgAq6xZ3AoyjkPszFsWfWKxeu12Bh+3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9691

Hi Tony,

On 10/6/2026 5:07 PM, Luck, Tony wrote:
> Hi Babu,
> 
> On Tue, Oct 06, 2026 at 02:53:49PM -0500, Babu Moger wrote:
>> Hi Tony,
> 
> ... snip ...
> 
>>>    int setup_rmid_lru_list(void)
>>>    {
>>> -	struct rmid_entry *entry = NULL;
>>> -	u32 idx_limit;
>>> -	u32 idx;
>>> +	struct rmid_entry *entry;
>>> +	u32 cur_idx_limit;
>>> +	u32 rsvd_idx;
>>>    	int i;
>>>    	if (!resctrl_mon_capable())
>>>    		return 0;
>>>    	/*
>>> -	 * Called on every mount, but the number of RMIDs cannot change
>>> -	 * after the first mount, so keep using the same set of rmid_ptrs[]
>>> -	 * until resctrl_exit(). Note that the limbo handler continues to
>>> -	 * access rmid_ptrs[] after resctrl is unmounted.
>>> +	 * Allocate the largest number of RMIDs that this system will ever
>>> +	 * need. These cannot be freed until resctrl_exit() because the limbo
>>> +	 * handler continues to access rmid_ptrs[] after resctrl is unmounted.
>>>    	 */
>>> -	if (rmid_ptrs)
>>> -		return 0;
>>> +	if (!rmid_ptrs) {
>>> +		num_rmid_ptrs = resctrl_arch_system_max_rmid_idx();
>>> +		rmid_ptrs = kzalloc_objs(struct rmid_entry, num_rmid_ptrs);
>>> +		if (!rmid_ptrs) {
>>> +			num_rmid_ptrs = 0;
>>> +			return -ENOMEM;
>>> +		}
>>> -	idx_limit = resctrl_arch_system_num_rmid_idx();
>>> -	rmid_ptrs = kzalloc_objs(struct rmid_entry, idx_limit);
>>> -	if (!rmid_ptrs)
>>> -		return -ENOMEM;
>>> +		for (i = 0; i < num_rmid_ptrs; i++) {
>>> +			entry = &rmid_ptrs[i];
>>> +			INIT_LIST_HEAD(&entry->list);
>>
>> [1]. All the nodes are initialized. Basically, it is pointing to itself now.
> 
> This is setting the ->next and ->prev fields to point to the entry. So
> each of them is an empty list. Maybe I should just delete this as it is
> pointless. Later on these objects are added to the free list with:
> 
> 	list_add_tail(&entry->list, &rmid_free_lru);
> 
> but if you dig into that code you'll see that the ->next and ->prev
> fields are never read (not even in all the debug/sanity routines). Both
> fields are overwritten to add them to the free list.
> 
> Note that this seems to be a common pattern. Code does
> INIT_LIST_HEAD(&x->list) and then immediately uses list_add()
> or list_add_tail() to put "x" onto a list.
> 
>>
>>> -	for (i = 0; i < idx_limit; i++) {
>>> -		entry = &rmid_ptrs[i];
>>> -		INIT_LIST_HEAD(&entry->list);
>>> +			resctrl_arch_rmid_idx_decode(i, &entry->closid, &entry->rmid);
>>> +		}
>>> +	}
>>> -		resctrl_arch_rmid_idx_decode(i, &entry->closid, &entry->rmid);
>>> -		list_add_tail(&entry->list, &rmid_free_lru);
>>> +	/* Find how many RMIDs are available for this mount */
>>> +	cur_idx_limit = resctrl_arch_system_num_rmid_idx();
>>> +	if (cur_idx_limit > num_rmid_ptrs) {
>>> +		pr_warn_once("RMID count %u exceeds allocation. Limit to %u\n",
>>> +			     cur_idx_limit, num_rmid_ptrs);
>>> +		cur_idx_limit = num_rmid_ptrs;
>>>    	}
>>> +	INIT_LIST_HEAD(&rmid_free_lru);
>>
>> Initializing the list head without first cleaning up existing entries could
>> be problematic here.
> 
> I don't see a problem. Any entries on the list are left floating, but
> they are all in the rmid_ptrs[] so easy to access them again.
> rmid_free_list is now an empty list having discarded all entries that
> were on it. Sure, those floating entries have stale pointers sitting in
> their ->next and ->prev fields. But those pointers are not going to be
> used by any code.
> 
>> The first mount works correctly, and INIT_LIST_HEAD() is not needed in that
>> case because the list head is already statically initialized.
>>
>> However, on a subsequent mount, the list entries remain linked from the
>> previous mount through the setup performed in [2] below.
>>
>> INIT_LIST_HEAD() only reinitializes the list head itself. It does not
>> traverse the list and detach or reinitialize existing entries as was done in
>> [1].
>>
>> I think you need to replace
>>
>> INIT_LIST_HEAD(&rmid_free_lru);
>>
>> to
>>
>> while (!list_empty(&rmid_free_lru))
>>          list_del_init(rmid_free_lru.next);
> 
> That would set up all those floating entries each as an empty list. But
> doing that doesn't matter. No code is going to look at the ->next or
> ->prev fields.

That is correct. It may not be an issue in this case. The only concern 
is that the pointers are being overwritten without being cleaned up 
first. I agree that it may not cause a problem at this point, though I'm 
not sure whether list debugging would report any issues.

I'll leave it to you.

Thanks,
Babu


