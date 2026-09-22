Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011028.outbound.protection.outlook.com [52.101.52.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBD65325726
	for <patches@lists.linux.dev>; Tue, 22 Sep 2026 22:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790117901; cv=fail; b=YsPvCG9eBojt7qy+C9XurwpcOY5C5drkUZbzlsk5fz9tZFjeHMkDP1LQCfV/xtJwNIU8L7XicQTMROalAWo52rjgSAAJoXExWIHZ5XnpIJsev04ugJaQpyvCk6Plxu3rhDKezvRScXk4lb9wriRm9UfZqtkkpiQ+X6rNqLINtTk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790117901; c=relaxed/simple;
	bh=4gBrDrwC/Gjnf+g/GlQgzm0xdhbDYueWSXR3jngTS9k=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kQj8cyyDcjTUPcQa0SRM3yDWEXZm0iIuuBhm1NRWXcyIap6UWERrseW+raY+7AdJo3Ff03lTQqkUvjK65f/V0ZghYI50oc5j2JVBLpnp7FA+6oXUAAD6eSUQKWKCYULsHeZbZ4NKMRefH4NAKqBBT954V/+/eeLkj9VdxefXuG4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=tiEPwf2y; arc=fail smtp.client-ip=52.101.52.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="tiEPwf2y"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hlqgVEqBlOPhXcI4Sz40XsY4LLweCIW5hO8FCqRBqfFAF5363WkWMTgtrGPwk1GaabWLBIWNUJfcfW2h56iSqScUj4KuwuxJE90ar4GFJc2JKd0IWoBep6QkHWVXFXe3X11nj6HWC7D2qur82hkZH3lthHpAJOm9VbIyESIQPEhtUnAZSfqiEZvjJDUVew/mdxuQeA3a9oQ44c9g6xukhAGhww8lQ2G3/a4Gfu7QT95Z/z0S6CrkS8rbCjgNkg45yeZasT+ehJB7yqLnio/4VVTaOCr06OGfDnNBDzq6zZIEiFTJeCts3/lkCm2aQz9AewcAgN2v8nmekr3sFGCNew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v6CUzg99LprsdkUhLuHzKxutAO0Brg/DKI/IC9Px6Pk=;
 b=xa7pBoADOlxDmpD1B5zxPnbQTCqR1Y2knaftu9v7Tx5hNfB9QNSa+V4dVr+b8CX5hihWk8TFWEyWELNvud3wP/yq6Fzsz14zX9kUAmLKhh4WSOhKDLbrtSq2SfqbhHMFypsyf1tbe64gQ9KJsExbuKaPpDveIVWYT6BPHyjakMKJbtSEapGBc5BIiAF8gLxfmKdenGs5L4n9OExx6rH8GrThv0rGciNi3NEQzuYinxY2mIC25xj2FFpQtaT4InraFIbd4VaHSYocOn6f6HXsifQrPQ3C8fufVnd1K1JPzYpoyWuJ1wt2eHMTGhyAziD3snfRjXAcv519xbW9J5Z4bQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v6CUzg99LprsdkUhLuHzKxutAO0Brg/DKI/IC9Px6Pk=;
 b=tiEPwf2ybxuBYz/Js+EBZ+9lBCfm3WWWc9CyaQP3vXY9TaUZoKRlwafZlgGzGojNV7elQVgo8CmnQ8KAKIoaCWsfBAp57B6tHqDStn5mhuK8hiWOaXyutdGW/rMs8OWhzkH6CNSteYYjJTVfmE3CYZKPmAL3JLnupEhqxAa0NIU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5320.namprd12.prod.outlook.com (2603:10b6:208:314::17)
 by PH7PR12MB8123.namprd12.prod.outlook.com (2603:10b6:510:2bb::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.15; Tue, 22 Sep
 2026 22:58:08 +0000
Received: from BL1PR12MB5320.namprd12.prod.outlook.com
 ([fe80::1876:4a6d:2cf5:b8d1]) by BL1PR12MB5320.namprd12.prod.outlook.com
 ([fe80::1876:4a6d:2cf5:b8d1%5]) with mapi id 15.21.0451.014; Tue, 22 Sep 2026
 22:58:08 +0000
Message-ID: <a6a2e7a1-9b07-40f1-971b-9e9866bee048@amd.com>
Date: Tue, 22 Sep 2026 17:58:06 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 14/25] fs/resctrl: Rebuild free RMID list on each
 mount
To: "Luck, Tony" <tony.luck@intel.com>, Babu Moger <babu.moger@amd.com>
Cc: Fenghua Yu <fenghuay@nvidia.com>,
 Reinette Chatre <reinette.chatre@intel.com>,
 Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
 Peter Newman <peternewman@google.com>, James Morse <james.morse@arm.com>,
 Drew Fustini <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>,
 Chen Yu <yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>,
 x86@kernel.org, Christoph Hellwig <hch@infradead.org>,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <20260916231320.14502-1-tony.luck@intel.com>
 <20260916231320.14502-15-tony.luck@intel.com>
 <8bd7c456-c11f-4c8e-9b95-6825a00194ad@amd.com>
 <arLlcFYZiu7OcBFc@agluck-desk3>
Content-Language: en-US
From: "Moger, Babu" <bmoger@amd.com>
In-Reply-To: <arLlcFYZiu7OcBFc@agluck-desk3>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR11CA0003.namprd11.prod.outlook.com
 (2603:10b6:806:6e::8) To BL1PR12MB5320.namprd12.prod.outlook.com
 (2603:10b6:208:314::17)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5320:EE_|PH7PR12MB8123:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c6e190f-b03f-4305-24ca-08df18fcf7f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|366016|1800799024|18002099003|22082099003|10067099003|56012099006|5023799004|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info:
	KhFIikjMW86hBNkUtlvaKqDtNrCcdmjkyBwH19Kjajux8aNzQDM5W1FtfUwLEwQUM6tlbz1VCA7y77WZpfI9zSyCuTyZYjH8YCUjQl/i+vx4CfZ3aSAnZQ4eZhaCNYY1g87VsLnd/MSC32bm+pAOghPsoxpA2x6BWsDYafp4USvBAWDlEKtyRyKj1Sc/TLt3Po+p86VX55jDO5sIxSCLcQwRQkHAwZ0BQ+lhQEJ3EQ4Vd8c1b6rmHNzxSvXnMEYWsqpGx/0iGu6T9JQK6xP02CdIsCxBpRiGJ50qqpCFf6wEqHNuIRdV1sGBHqY9JZRr7XEuOkUPFsYQbB0d5y9tdbtP/3Vg8yb3JQg7bwhKaJrbf1Sx0aKfdStTD6lTSd7KXBtNAPYAhXJ1B7+Xq+D1hnKp4YBGChRLUwOQky82jYdKuRi5SdZYEQtcPvJDYvypaaOcgS3musj6elld7xqJQ869dpHsSZgV1ccpJGJCOmTUtsWtJyY9MOQtYlOaUFscPT5MAfaMhuxAiTXrGWfBQNV76sck1ToA+fKxeLLdadLmYKO0/lwuMFEPa2cma6S0ky/ekVdcRpoWEls9fWAu4Xzt0hHg/CeXbKpDh5slDDmFatuNeOAJP49eQlDPFEOwatrlch23LCU6IKwaHAHUC6ZU87MZztmTutYhMS6wqK0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5320.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(366016)(1800799024)(18002099003)(22082099003)(10067099003)(56012099006)(5023799004)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UVRSMzF2RUF1dGRqMVBEY1lFcU90U1ljVngyY2RNYlpuY3dNYzI0TkxQc2M5?=
 =?utf-8?B?NE1Jei9HTytCL3lUOE5yOWtUck9uWTBkNFBDQ3VuNXI0M1hKcjgrdkdkVWFQ?=
 =?utf-8?B?MHdzZWozRW4rZlJDMUZ5V1hzemdKalhLVERLNkozekNTK2NJZFcvZXVjajFH?=
 =?utf-8?B?d3djK1RPUTBjWGowTEVSTnY1anlLOUlDck9lU1lrK0VXbGQ5NEpXa0daN3p3?=
 =?utf-8?B?ejMvYnBGMjQ1b3A5WlIxaDhSbjVVZkhXNVVhWG1WdmNVVzVLS1dvTUNTZDVm?=
 =?utf-8?B?VXpTNk1QUFE5VHFQZGp0SXlBWlE0eXEySHpqZUloc1FwNjZSRVB2SFFwYktJ?=
 =?utf-8?B?cXlYaHJmTSs2OW1iRDFYOStnN2p6MWlQeWdDWG1YS0NYc2hiR0ZFSEh3WXcv?=
 =?utf-8?B?dnp4TlZxVmZhNEFNUW1ZazBvYnNwUjVDSlpQZ2tkeDltZEVXWnUxZ3c0Qlo1?=
 =?utf-8?B?KzQ5aGNwZWlGWWxMR0RUbmVJRVlsTGZFSVdNSUpRb3c2QjNaZjFWV3dKV0xw?=
 =?utf-8?B?ak5LMnlOT01Gd3ZsaXJyVlFPbzM3YWFFUEJ2Q2FINFArdzlLWTBOMThKYlRy?=
 =?utf-8?B?bG9xN1FMYjFCc1lGd1hmVSs2ZXRFMnEvREYrc3YwNlppSmc4RUh2M1A4ZnEv?=
 =?utf-8?B?VUxwY0xESXlPbjFrOVluR29nblc1UldhKzRNUnprTVFxV05hZXZjVzZHQWZF?=
 =?utf-8?B?NmszNC9rRXV4cDhaWVZ4elpHOXlaWEU1a1ZjZlVlbDZ2RURrMStMK05mVVNT?=
 =?utf-8?B?N2xkTDJUZWpFeDRVQnlRNENnL1ZhWnRhb3k0YmRTMXlLbnhNamNsRWh0VDRY?=
 =?utf-8?B?akIzM2hGMUlrcU5tR29KaldXd1dVZStsL1JERFJKUDl1L0R6RFpPaTJYdG9N?=
 =?utf-8?B?Mlg5YXUvejEvcDZ0Y1RzWTZLREErSnl0eEpqR09PYVJSVjRqUW5kWjV5M3VR?=
 =?utf-8?B?cTRDYmtmbnhlNllQZUx3RlV2dXFmdmo5cjR5Vm9nMkNidDR1eTMzK0FzODBz?=
 =?utf-8?B?Q2Vha1gyRlQ1MDdmbTVvSHJEdVh0QTRNRFBDQUFJN2hhaDNNeGxxL2gzUFZM?=
 =?utf-8?B?N3g5V1NSalBSeXc2SFQ0dUhvU0VmVjFFazhwV1RkZlNMRk8vL2pHNGFIaWRR?=
 =?utf-8?B?M0pWWDhyZ0g4YUI4QlVSZUJkS3UwVzY2bmxSNVUrWnpzRlQ0VjZjR2xhNnlz?=
 =?utf-8?B?U2JOVklSOENoTTIzNUdjamFjc0J3Ty9jbElRN204Rkw3c0FYdlBXMWR2bHd6?=
 =?utf-8?B?YXh3M2owa0ROd1Z6c2ZRTTdNS2dWb083MTlNRnp0RnJaU2Y1N1YwQXpUUkZ5?=
 =?utf-8?B?eExJRFdaZjhBQlQ1NEQ0enJScHZTb0hmS2FTZmc4UENxd1h3QmlQVlFFVkFM?=
 =?utf-8?B?ZW52VWlsemNCMGZPTi9nSFppWWp1VmtrV1VuM0drZHBUc01ieXppNCtTcldZ?=
 =?utf-8?B?UC9OUHhZTk52b1JVa0tvMHdzQWxMd21rOGZuUW1rQkNoclRhc09naUhRRzBr?=
 =?utf-8?B?dTR4YUtZN1JXYjYxVlFCelRhL0g2b3VBYUtScHB2T1ZvN0R0aU5TZ0Y1MXpX?=
 =?utf-8?B?NFVCUEc4ZFEya1NwTTByYzg3U1NkM0NjVSs2dFlUVGxjWFg4M1Z1eSt2bDNM?=
 =?utf-8?B?VW5QQmtkU2haRGlqVnBYKzRDTkw5QlFkVHJXSnJZdGxETjVTbGRzZmk3cGIx?=
 =?utf-8?B?Ym9Wdnk3NUpEMEgyWHBCTXgvUUZwWFpVSVNiTmlBblBtRndkWVhtOGgyUTVq?=
 =?utf-8?B?MnllaG1LK2E4UUEwWnNBZGlKZFVBZTZqb0wxUTdRVDI3L2FkcUlIUVgyN3lF?=
 =?utf-8?B?cFFacmhJNURVdWhKbm1adVFENFVRdlE3YlI1OUpHaWpHYnRqT1pHQW1nZzFw?=
 =?utf-8?B?eVpNZEY1VFBGcnZ3eHBMc0ExR3hTcnNhTldIUThneUpsSDhyQ1VmSDZHVkxn?=
 =?utf-8?B?OUtuZmdhcTcwYTBqWitMU0t4aUpFdjJlRHk3a1BlN0xKUWZHdjZWZGdrblFK?=
 =?utf-8?B?aEo0Q3doMjh4RGVwSWFLT25BWGNoRDNWQmNCdFJTUWlleGtpc2RsL0h5V3FT?=
 =?utf-8?B?UXdmem8xLzFtVG9FRjF0dThjU0N5UUQ1dStZblQ2OER4bVlwVXg5ZExPSXlT?=
 =?utf-8?B?d3ZuQ0dkQ09LVUVqSnZyYU00OG5MUU44Uk9DdGxHbGU0WnJaZURpSlZlUmxh?=
 =?utf-8?B?dll5djgvYm5GN3N2WHYxa0NGb2t0aHA2eHh2TldXL0k1YlNnQVBmOHRQOFht?=
 =?utf-8?B?TlVnK2o2NmpIdDdBNWkxVmVJcnIrUHlmeE5qb2g5dllnVGxUK3c0TzRVRU5q?=
 =?utf-8?Q?GXZyh4gUS8A0lpDX5J?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c6e190f-b03f-4305-24ca-08df18fcf7f4
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5320.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2026 22:58:08.3391
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VL5qX8AfO/kfGioF+EXIX7s4EdRHPvAvMeWVChPM94rBqpShf9Egqn5wgcXB9dVw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8123

Hi Tony,

On 9/22/2026 3:30 PM, Luck, Tony wrote:
> On Mon, Sep 21, 2026 at 12:45:56PM -0500, Babu Moger wrote:
>> Hi Tony,
> 
> Hi Babu,
> 
> Thanks for running tests to make sure that I didn't break any AMD
> functionality, and for reviewing these patches.
> 
>>
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
>>> -	idx_limit = resctrl_arch_system_max_rmid_idx();
>>> -	rmid_ptrs = kzalloc_objs(struct rmid_entry, idx_limit);
>>> -	if (!rmid_ptrs)
>>> -		return -ENOMEM;
>>> +		for (i = 0; i < num_rmid_ptrs; i++) {
>>> +			entry = &rmid_ptrs[i];
>>> +			INIT_LIST_HEAD(&entry->list);
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
>>> +		pr_warn_once("RMID count %u exceeds allocated %u; capping\n",
>>> +			     cur_idx_limit, num_rmid_ptrs);
>>> +		cur_idx_limit = num_rmid_ptrs;
>>>    	}
>>> +	INIT_LIST_HEAD(&rmid_free_lru);
>>
>> It is possible the list is not empty at this point with difference in
>> numbers from one mount to another?  Should you check if the list is empty
>> and clean it up?
> 
> After a clean unmount the free list will likely be mostly full as
> resctrl_fs_teardown() calls rmdir_all_sub() which is going to free
> up RMIDs as directories are removed. The only RMIDs missing will be
> the ones in limbo waiting for LLC occupancy counts to decay.
> 
> But the free list may contain some RMIDs that are out of range for the
> new mount. Simply rebuilding the free list from scratch is one option
> to resolve this. Another would be to walk the list add remove any
> RMIDs out of range for the new mount.

Either is fine.

Will something like this work?

list_for_each_entry_safe(entry, tmp, &rmid_free_lru, list)
              list_del(&entry->list);
INIT_LIST_HEAD(&rmid_free_lru);

Thanks
Babu
