Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2077.outbound.protection.outlook.com [40.107.244.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B61F7189B85;
	Mon,  9 Dec 2024 08:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733732623; cv=fail; b=ISnp1f5YkqsSknIEf7F0B1KEO4X0lvYGSlPi8wiMbtvFznmcU3Or25hClOtnzVJT3apJtcIpPr1SjRXdbWWWFbu6T9s/jU4mC1B0/qAJ+zIjBXDcYmsADBDTrNA/ddCAW/dQ5ROqucFSTc1MS0727SB8gvuTyiqXFpyqMbuLvlc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733732623; c=relaxed/simple;
	bh=7oOtGETnSr7AA/LUMtVM3IHP62VUz8XbC4xD8jfSm0A=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=quj2zAS7yxiy59A+OlMi/8WnCbgwQ9xNA5bKRaIO9yiOeKDmdZtgbyqhc1ZLWIEO3s5xEjB6NZgzk2PYATio7Im1TJk+V3x0nE4p0DMHD9fV9Ysat5mGopo7KlVtB8vGOrtGoRdJPGDx3+19ug3xD1m7bV/4You3lFJt7QzoZ+0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=AYfzxvaj; arc=fail smtp.client-ip=40.107.244.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="AYfzxvaj"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FlZh6H+tsOfHeq9JA4awC+57FfEzBc3b2AyNAiD79YE1hXeZsaMwd3wEK0LEcUUnttaztrSG6C51U0ODztLxtU//i2PMeMa3EwaNpxxNOEYyTzU0IrC4f06/vp+spc+BRI0CJj6iK+kYCpw7SkxVPeamAGeUvUbuKySnmKPLpNrK2GSXGSRuOTg/0wf+fgJP1bGKE3Rc2KkYLbggrUCjxQOpLzGMau4qpiSEf49HDwLB48lBNhr4BnQvD87KkOP9bhMfuIodzXiaX7I64FBwY5PT7PRdwKt4jnSBTAm5VgIj11Ugw2dBUjEPQm39TzNqcM+Zll/bozsq58mhveq8kA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LTp6PUubeWql1yvJWdUdZnJT4SQyfBGxu9XWOMB6mqc=;
 b=yw6lMjipXSwv13kmov9oJUqc4aoOLIywNKvvhNpNwtGUicx+3O5yRFT/5iXeGr68gLOvBkLjU4HZvGkx1s/MrXfmF3OF88FYuB4xUXakPfMOO03X71GBMmA369+HdkimdjpLO847TY/hwSsN1VzoXEPp+rIW/U2ylM9lPtGAyL8FeHII7DddU9mtLLrdWiV8OdGdMYSzKunq+YcKZjZ2/KajG8Vz/7f5D+WbQEf3AhgbmIgY4ZD27jDQWJTTAsUrDMAUEZ6lzlq0v6Rf0bfF1Pv8fuw2mS17/06YEyY0kei51jW57ls7XDGNk+IYSBl3hBQmnvdQJ1RI2mbDqujstg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LTp6PUubeWql1yvJWdUdZnJT4SQyfBGxu9XWOMB6mqc=;
 b=AYfzxvajgz77neyHHKBKvf/ac2DVQli16AVvFo4mHwqHVRkPD7ap12osRj1f+uMKYxdnbctf4t6NAGeEweJykOR+ohMEktQ9HqWEWPVPUpzQJZQh7JOCGqW/KueHn0P0fGpsXY37+JUHOHo3D463iyAD8FxHy1Qtpt8cCYMpcxA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 DM4PR12MB5747.namprd12.prod.outlook.com (2603:10b6:8:5e::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8230.11; Mon, 9 Dec 2024 08:23:38 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5%3]) with mapi id 15.20.8230.016; Mon, 9 Dec 2024
 08:23:38 +0000
Message-ID: <54f4f74e-b58f-4b35-8bb7-672ae23a7bf5@amd.com>
Date: Mon, 9 Dec 2024 13:53:30 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH rc 1/2] iommu/amd: Put list_add/del(dev_data) back under
 the domain->lock
To: Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Will Deacon <will@kernel.org>
Cc: Joerg Roedel <jroedel@suse.de>, patches@lists.linux.dev
References: <1-v1-3b9edcf8067d+3975-amd_dev_list_locking_jgg@nvidia.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <1-v1-3b9edcf8067d+3975-amd_dev_list_locking_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0030.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:97::21) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|DM4PR12MB5747:EE_
X-MS-Office365-Filtering-Correlation-Id: 2376cde2-e4bd-45d7-bb09-08dd182ac811
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Wk9DUFZKVXJCR3MycXhncFRvT044SjFHbm1DcCsxQXFBRzNUcG01RTB1UWkz?=
 =?utf-8?B?UGkvclhkNEptU1RibUphSFZac25WWGN1QThjWVN6d1hZNmlROHFiZUZ0VXQy?=
 =?utf-8?B?VWRucXBjQkdXZTN5Q2ZJMXM2U1phZzRwNnh1ZXJpd3pPU1lHTVU1L25jM3RX?=
 =?utf-8?B?cXV6dUNUN3FvYzdRSjVZM0VNVFU5N1l2b2NhSlhjR24yMitpUzdyM1NwaSt1?=
 =?utf-8?B?QVdGb2FTY1ArbTY2cldBWUhZUWp4V1g5MFM4eHc1MjdQVHkwOVcwNk81R3R0?=
 =?utf-8?B?eWcwbmlpTTZRUnJ4cFRUSVUyQU9WVDYxNXNGYVBIbk04NTcrUW8vZk1ISVhV?=
 =?utf-8?B?YlN1amUwcGp6UDNkWE5kenhTNUdybGhudnREMElBNTR0bU16blV5L3drUmxi?=
 =?utf-8?B?M2RjSTc4RU1tK0VmZWMwT0RsRmdINm9lUmNoSVRrYVN0UVlWRWdnaElOMlVL?=
 =?utf-8?B?Z3JDZjVsUjFxbjMvOVhDZU5VOUs4aENjZXRjVC9ndFBJQTZxYS9wSm1JSDZ6?=
 =?utf-8?B?TnhjM0hHOCtpUUEyaE5oKzgyampWamprRlVhcjJmUkg1bG5Idk9ZdEUxV1gx?=
 =?utf-8?B?NXhmMEVtWUJDV0FqWTNJa3BmWlpyS1E1czFUT1ZtMkRPcERHdFNTSVdFUkor?=
 =?utf-8?B?eTIzUlFmL3M3SWFmd2JHelp6YVE3RTNiL2RGaUdMSEFnSTBPb3RpSm1tb2tR?=
 =?utf-8?B?amFDT045eHdONXBFaVc2bkJ5Z3V4N09vNmxlWmp3TG5GanRnZytYQnFHRDZy?=
 =?utf-8?B?ZmR0ZXRia3htZlZtMVQvQlBLK1pGOTZoYUM2NS84UGpBRlNpbmxzTTFVMGhM?=
 =?utf-8?B?Yy96T2ZFa00wbWhkQlhVSEw0MElBUVU4R3VQczRJMVFCeVVudGplZlA1eVB0?=
 =?utf-8?B?Wm9GcG9NYTZ3TElabHlNd3hzL0FuZkZGV2lISjlNdEFNYjR3VVNpQjdtZmNo?=
 =?utf-8?B?enM2cFhUQnV4QVRvc2hJbHF2Y0Fud1MwazgrT1FGTm1rdkIxRUoxbmFYdlky?=
 =?utf-8?B?U0xocUpNNkwvYW1OOFVvdE5VaVhUSjVPMUEvY2p1NUpuSUg5WC9aNkZ5TDY5?=
 =?utf-8?B?UDViV2NHcEpoUGZRTjl4RVFzWUloaDVQTzJ3Z2FzMnZQSXA5STMzQkJDYzk5?=
 =?utf-8?B?UWZJR3FncWExS3dGNlV4d01FaXBJamZKckpSWkg0L25La0l5ZVAzcDlJVUZk?=
 =?utf-8?B?cXpNM091WmNjb01PZUZXcXNybDBTeXdUQXVUaERGZnVVek5NcUZTYzJpQmh6?=
 =?utf-8?B?UFByVCs2ZURXTHQxM043Z0FRMW1mcHdJNmlsbUNmSFZQdUZKZmxGbXR2SVdC?=
 =?utf-8?B?RnM3blBQN0w1VjI0NklEV3diM0k1UHpLMTRxZm5UanFYN01OTzF5aHd5K0JB?=
 =?utf-8?B?VktPRWUrVSszUUZURklLZ3haQnVzZ1dPZ3E3UmRINkRzd1IwbUR0SUhMbVpY?=
 =?utf-8?B?SHBRNTYwa0xZZ3YzVDJua0hXK0RlYXFqcW9aeE5nMHJucWNVYTloTUVJbEtl?=
 =?utf-8?B?c1Q4VTJwTC9lUS9VOGs0RnpSN1JWU1oxd0ZGSnhnU1NvZG43T0VZY0tlNERP?=
 =?utf-8?B?czdVSW9DbHRha1hjQnRzV2tVMUFFK0NjbTdaY2xSYVdDbkVrcGVLWlNHZkJj?=
 =?utf-8?B?YXVGQVdFTTlSVGhMTzUxS0liY3BlMEloNzR3TGVWU3g3aXFla2crdkpJMmtC?=
 =?utf-8?B?bEdRT2oyZjU1RytFOFI0OFF5aU82VkFKbGNJM0tDeWJIVWxUbjJoelFBVmpM?=
 =?utf-8?B?OWNiZjVDeWxETGNpRVNRSFpNZ2U5elFkVVdaLys0eDVXOXFBQmJzdkFZN3dC?=
 =?utf-8?B?dm4yT1lXQ1A1ZVRucEYyQT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YWxvb1I1ZDRmSXY3Y2JLMkRvYms2bVlnRUlWcERxWmdTT2xCSWhFUkVKOWdG?=
 =?utf-8?B?S1VHRjQzM1B6aDFaUUhhQnpXV3ozMERBMXBubTIvNDZxdENvTnp4M3V3SmNC?=
 =?utf-8?B?WG1nWlV6MUJZcXJmWU9GaTkxK3BPS2R3c3RKWXh0SHFnMFZodXk0SEVnNmV0?=
 =?utf-8?B?YXhMN1BtdjBnYU4wUmF6eTNZVTdKdnZTdkIxS2FxaGhjM3Q4REV6eUJKajZr?=
 =?utf-8?B?WnVxSU1RRll6d21mUFRESkVJL3BqSDRtQXovRUtyb0hJd21MZlNyRmtWaVU4?=
 =?utf-8?B?SmFIOTgvb2dHU0VPK1lweXhkSng4WjlvLzZlK2ozNWlpNDgxeGhnQldQa2NS?=
 =?utf-8?B?cnBjQ0d6MWVvRzYxRWdtRlpLVTZiZ2VyKzBiZG5tMEFSYXE4OHkxMldXVnQx?=
 =?utf-8?B?Vng4R202S2JZMDd4eGVDL0I5TWpuQjlWTVcwS05OeUplYWJyMGJsMmRZbFh2?=
 =?utf-8?B?MURmUXlNWUxqNmNjQnBZUTNEeW0vL2p1MjVTU2lWbENMM2JhSG9wMGZkRmhl?=
 =?utf-8?B?MHlLZ0wxdmNVTmRwakZPV1dPTkpJN1FqT2hyenlKYmpIb1d5cUk1VFVFcDAy?=
 =?utf-8?B?Ri9OSXJuaytKbkpHeGxobExnTnFoMGd2M2JRRFMxQVVpa0NVWXZoMllEWnNX?=
 =?utf-8?B?bm9SdUxtNHQ1Q2dqY2NmNzUxWlpMNy9abElJa0owMDc5N2psaVZFUGtjN1ly?=
 =?utf-8?B?THdpK21iZm9EaU1CeDJWQlJyUVMwUHcraFZJendJbURUa0FuV0tRRHlBWWJQ?=
 =?utf-8?B?T01wdG9RWkF5WXdSMEVZbGQ2MmJ0NmVpeTdkWW1TaVBKdGpIaWM3bDZWdVpt?=
 =?utf-8?B?blB0d1d5WkJ0cEpzL0ZmeUk2d3BZclp3L2lHVktFRTFHQlJVWDlBazdRTkxw?=
 =?utf-8?B?dDArWEg4WlNmT0VaUWtXQXhwTHZCK0xDclZWQXpjZ2o1UFRSSi8vb1lRTFBs?=
 =?utf-8?B?aENrbDNLTWR4cEFlaHVneEd1anZSc0hIbWtaeWlLZ1Urbm83L0ZBTWZkREla?=
 =?utf-8?B?ZFpXbnZoUjZsNUc1YURaanZIOWZsNGthSUNIRWhDRGFiMEpjc2h0ZGw1c0NH?=
 =?utf-8?B?SmpoTlhqV1ovV3ByMTV2Ky9jWjRtbVJnM1hkOS80ZG5YRnNYNnU1VElHRkZz?=
 =?utf-8?B?N1JTS0RxK3BpZnZ4S1lGL3pkT0dVeHl5dkxWRVU0cGxhWXg2U1FuQ0hZU3lw?=
 =?utf-8?B?MGhLWG9tQ2VRZW54TE5rSzE2UCs0ZmxFd2x6d1IvaUpwaVNBM3BBNGpOVmRv?=
 =?utf-8?B?c2VmRlpBb1JGdDR4NG9iMnhGRzhWMDFrWjd1TVhVV3VtQlQ0Vy9vS0lzOVV3?=
 =?utf-8?B?cFZURHM0ekZBRkRIVk9HVlpuNnRFeENlbHN1c1NlWWFzcUtqdTIrTkN1ZXR5?=
 =?utf-8?B?bWtvdDA5eE1CK1BDSUt6T2tmSEx1ZEt4MFFTdWt1MWtFUFFHVDd1MElsMWJm?=
 =?utf-8?B?NDh1Sm5hUkg1R3hLNmI1ay9ZMkJ0Nk1xcmJ0N3ZhTTMreGZHVldCZkFnWUts?=
 =?utf-8?B?SjhGL0pQTVJxWHcwdVJGaFdrbjU2M25FQmptSUsxd05kSHNWOVF3TmJJZUds?=
 =?utf-8?B?bzVJYTVwdldSU29NNkdTSUJpTWNDTG5BRVJrK21rdFAyamRJdVpCeHZaUkZs?=
 =?utf-8?B?V2IwV25BWG9MeDRMdkxoMHFNMWtrMkJjTmRqb201QWlINnAyK1p2cmdUTFZo?=
 =?utf-8?B?UXM1eDV6SUlIVkc3aXZCRER6TUsvVzl3TTNsQVBRdi9ka3N3aUtmcXBmQ0FI?=
 =?utf-8?B?L0xQVVJrNnVrZU1GdjFNZGFVNi9MUFJDVHFqb0Jqa1RPMi9PMFExYWU5bmxw?=
 =?utf-8?B?SFZWNkl2aXpUbllLaGtTTjVJajdlSGI5ZkxDMHYzSVV6aUxvQjIveVN6ZHFR?=
 =?utf-8?B?eXZnV0tmakgrTFZjR3BvQnBHSTRHZk9ncUQ5L1ZkMFJad0xqTEx6UDA1SW96?=
 =?utf-8?B?eVQwVXpWSkIxaWlmYkZCcVFyTGpBOU1LTWJvcGgzK2l0NzNvTVU1ZmdiOVMy?=
 =?utf-8?B?SlNBNlU0S3lxU1VsTnhHY2l4aHJHbE5udTVxcnpzMEhDbDZINVVDMGVhSWt5?=
 =?utf-8?B?d2Q4ZU1paGNkSEtlRFBLK1VwcGpQS21IWDNLVjFFZzVjdW5zUWJYdy8wbDFW?=
 =?utf-8?Q?QjZ7NshVJaVAyIuTZQidCxXca?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2376cde2-e4bd-45d7-bb09-08dd182ac811
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2024 08:23:38.4404
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zK+FWu73jkA6A2F9w4CkUbOlf2KmAx/9hpc8rME/s6FU1oNF3uWMtC1kAIc+p1CV+43IYOuiM/TMuhNQnZgKeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5747



On 12/6/2024 5:43 AM, Jason Gunthorpe wrote:
> The list domain->dev_list is protected by the domain->lock spinlock.
> Any iteration, addition or removal must be under the lock.
> 
> Move the list_del() up into the critical section. pdom_is_sva_capable(),
> and destroy_gcr3_table() do not interact with the list element.
> 
> Wrap the list_add() in a lock, it would make more sense if this was under
> the same critical section as adjusting the refcounts earlier, but that
> requires more complications.
> 
> Fixes: d6b47dec3684 ("iommu/amd: Reduce domain lock scope in attach device path")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Thanks for the fix. Patch looks good.

Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>


-Vasant


> ---
>  drivers/iommu/amd/iommu.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
> index 3f691e1fd22ce4..23a168e229b171 100644
> --- a/drivers/iommu/amd/iommu.c
> +++ b/drivers/iommu/amd/iommu.c
> @@ -2073,6 +2073,7 @@ static int attach_device(struct device *dev,
>  	struct iommu_dev_data *dev_data = dev_iommu_priv_get(dev);
>  	struct amd_iommu *iommu = get_amd_iommu_from_dev_data(dev_data);
>  	struct pci_dev *pdev;
> +	unsigned long flags;
>  	int ret = 0;
>  
>  	mutex_lock(&dev_data->mutex);
> @@ -2113,7 +2114,9 @@ static int attach_device(struct device *dev,
>  
>  	/* Update data structures */
>  	dev_data->domain = domain;
> +	spin_lock_irqsave(&domain->lock, flags);
>  	list_add(&dev_data->list, &domain->dev_list);
> +	spin_unlock_irqrestore(&domain->lock, flags);
>  
>  	/* Update device table */
>  	dev_update_dte(dev_data, true);
> @@ -2160,6 +2163,7 @@ static void detach_device(struct device *dev)
>  	/* Flush IOTLB and wait for the flushes to finish */
>  	spin_lock_irqsave(&domain->lock, flags);
>  	amd_iommu_domain_flush_all(domain);
> +	list_del(&dev_data->list);
>  	spin_unlock_irqrestore(&domain->lock, flags);
>  
>  	/* Clear GCR3 table */
> @@ -2168,7 +2172,6 @@ static void detach_device(struct device *dev)
>  
>  	/* Update data structures */
>  	dev_data->domain = NULL;
> -	list_del(&dev_data->list);
>  
>  	/* decrease reference counters - needs to happen after the flushes */
>  	pdom_detach_iommu(iommu, domain);

