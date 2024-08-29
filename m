Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2082.outbound.protection.outlook.com [40.107.100.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A0B47E59A;
	Thu, 29 Aug 2024 10:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724928450; cv=fail; b=FI0MD1fg0WOR5Zd8yHSSgoCoLHqvTxSfdq7UdeXIU/YXJzG3rmc2CaxUh7YNIFcqFx/7PQgYYeZAQuT5fQsAyhPGwm0pi2qzLmOJ1pjMSSTj17HOJO/mOZciaEMDu/FUezMBzS4Hw5nWfoSxHsnDoiNDGqtUbeSNdF6ZRAM7QKU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724928450; c=relaxed/simple;
	bh=Wnci224xYl3VS53HBx0WXrW7KcsjQZZwcW4gX7TQOD4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=PlgGHL1w6QMFL7wXKwr7HmbAuJtSKd6TxijHLco2/ZGx+SQbm1B9OXZpB2LONfbhukKtExHMpcCcblrqkPLkCdgO7boESEVke9/Jqw946Zc2KEYUvIzJptFomOGKVp+sldJIT0fpF4fhhdJ8PoxbTQ8V3GZ4EEcCx4PzyvLmDlY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=1yd1RKPf; arc=fail smtp.client-ip=40.107.100.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="1yd1RKPf"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Zx/j4AANkOwZWthzfF3s8Q9O/+7DTfDjSXVxcr1cdX4zcJaK6kRJ0BR8cRLFLWWb4sP7vBF5LT1639djcxgNlv4s1HBvs7itTY45pruruDRZXcnne+uoZyM5PyFQNvHmamBQpBp/zAY9LLP2alIoR6+EKzsBP6FZg99FQOdsnJkscpSF/1gH7TKccWCe/fskxoIyYopZbUqDX/ewucI7bugKQj1mKYMQezbDRL4LnhEoT43osjmrIY0KAOZDn6U6QTJ7vvV9Jj+mYvfO0klcI73rUzRcAYfJt613YtRMamwzChnGimaSXzQl3BZf6AZoDuXIS8kKIiCQLCp7UA934Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fbEccP9Z7/vqPqbM/vcgX3Bo8xYxD20F3KMDiMGTkfs=;
 b=y4hTkphoveWyU+7mCQWY1D9R6w5f8D0G/ZeARy8raFVV6tAXHVyJp3RIf9sXaL4Wzdv2eyTO0wfGhb5PFXycEvntIZL9ryQ2bex/fMYpG//Azk5rk9BNFcM35UiRWXG/PMHHf6pcOEPcQyK9l2k8+y00CFtzeXV2Z3m6vb/d10zUd7JctE9HhGXZ21CjNYtYclnIIhZbcHwpk81sNJ9grm2bkFKFoPzpbl3yepLeEtNGryvG57OVZmc3y1Rxr6qBhkuyyI1TJtylJM0gulwINNYkUSwvfmeMKXXdA0zWLcjyycVm+HYlw4hhuu/fJ2TVhkUkjP++NnUGHVRT+9ltGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fbEccP9Z7/vqPqbM/vcgX3Bo8xYxD20F3KMDiMGTkfs=;
 b=1yd1RKPfKyIXGQCjmrbETXW+k9iMX+XlDJ+96CWfy7fa+WTAj1mc5U5J9V8IKbdsnYU/4C0+3vup5Bb4KQCOZLqkMWc+B8jIN4vtI9/GaqY9EGNlTYfr7MtKhXCBiq9IPgc0plrEegG4Vd5qrLWDySwITy6mwCi3rSrFTcYcf3E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 DM3PR12MB9434.namprd12.prod.outlook.com (2603:10b6:0:4b::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7897.25; Thu, 29 Aug 2024 10:47:25 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5%5]) with mapi id 15.20.7897.027; Thu, 29 Aug 2024
 10:47:25 +0000
Message-ID: <71b91974-109a-45ee-a94e-326745a22d2a@amd.com>
Date: Thu, 29 Aug 2024 16:17:17 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/14] iommu/amd: Store the nid in io_pgtable_cfg instead
 of the domain
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
 Robin Murphy <robin.murphy@arm.com>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Will Deacon <will@kernel.org>,
 Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
 Joao Martins <joao.m.martins@oracle.com>, Joerg Roedel <jroedel@suse.de>,
 patches@lists.linux.dev
References: <8-v1-cdaaddf80abb+14190-amd_iopgtbl_jgg@nvidia.com>
 <fb029720-17a3-4cb6-8a2c-6a5931279e98@amd.com>
 <20240828181352.GB3773488@nvidia.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <20240828181352.GB3773488@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PEPF0000017C.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c04::47) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|DM3PR12MB9434:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b6383c0-0db8-48dc-ede1-08dcc817f7f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dUUyNTkyREZLSWR0SEN4eTdPaXpmbVNQa3BsSE11eUVvVVZMVVRsUSt6U2tu?=
 =?utf-8?B?TW5GMjhmK1BweTU1blBKdlo3QnRvcDI3dy8vNmtjQzR6TU9qSlF0Ni9YaUtV?=
 =?utf-8?B?THdLWEhacWt1ZnU5SFQrMVJSUE5ieVhlNkh4aGhsaXk3Nmo4ZVZkajZ2d2J4?=
 =?utf-8?B?dEhrQ1NXbWFydTNYaGpnRlRxTThtUHNDSWRsV3pBWTJTWEJ5eThXQkZxTm80?=
 =?utf-8?B?dVo3VllaeXFnY3lZRXkzeUk0NmowQzFXV3NCM1BaWkdHbXRVeUJ2ZUZ4VWhI?=
 =?utf-8?B?MWhVeDE1Q1FpWHByZmFrbjZSbUlYZnRtZTJHcEFYNFNhNXQzTmFVSjJyM2Zk?=
 =?utf-8?B?aFdZSEhHOWNvajRxSE5QUTRkSzArMitHUlYzNDh3Zm9WVEhBWldKais3b1FW?=
 =?utf-8?B?Zzc5dlpuOXFpWFNJalhPd2FoTmdVQnZUWHhvbktsMUNnNERvejIycjROYWJp?=
 =?utf-8?B?YU5kVSs3Q3V4ckgvM0xxclpIMlRPWnJEMk10dTk5NlFxUTM0K0hkVlJxemNn?=
 =?utf-8?B?NmFpSWRIMjB5OU11cW5Oa3h2T2VUZ01JQ25HaWtnQ3pIdU9SaFAxQmd1SDJ0?=
 =?utf-8?B?TzhoNDBRZEhFaVh0WE15ZHpyc1dKWTNVVkUrNnQ4bjJHQnVUVENPZnJrRnJ3?=
 =?utf-8?B?eHo2YlBDT2xHSmZOaHJVcFVqcEVsS2lZaHg5L3BvRFd1dmZjY3p4dWUwdWdY?=
 =?utf-8?B?RlBJK3hoYm9sM0hnNEVaSVlnaGR5OEpycXlRTzJMRnd0cDJ5VzZaNlgvM0xu?=
 =?utf-8?B?d3pYOW1oKzF1cnhCeWRZR2Fra0tMVHhha0VudjJURm1obzQ4Si9EaGU2YUFG?=
 =?utf-8?B?bS9qOFMvN3pJZUc2MVlHbW1MeWk4ZHUwblJEZU1TeWpmQ1ZnOHNpYUlsa3hj?=
 =?utf-8?B?ME93SHdaRFpKSlA4by9tQWZiaXRwNmxIM2RrT2E5SjNxMW8vZmh0d3RmOWw4?=
 =?utf-8?B?S2hSb0NNTkxRT0FCb2xZZCtVRTZpRHJMcnE3YzFiRTRaL3BYcURrQVIxSDJj?=
 =?utf-8?B?c2t1alhuM2N2amFqNmI4SXQ4T29IeE9qVFFZQ2diNnU4RDkxMG5uYUZXSWFj?=
 =?utf-8?B?SmIyWDdXWXlLaGlxUlUwZ0N1Q2tiUmZUaTV3N09ocTNKTUl5SHcvdHNDS1Rp?=
 =?utf-8?B?UW1BUjU2SFV6U0pCUE93LzF0ZStZVHBHSW1aWGlqMExQcEplNExTK0wvOHNC?=
 =?utf-8?B?eHBlalpLK0hpdm1oejF6RURuZjJkdUxKK0NtUS9RY0hUTkI3Y0dmSDRGSDdh?=
 =?utf-8?B?bWI2ZlBFbVErNXJ1MkMvNjRkTFpnUmM3UnJUWG85ZWt3ZEtRT24zM01vUmN1?=
 =?utf-8?B?TTh5T2hVR29GbVJaUjdiV1hHMFNFT3lYdmJSSUhOSVBwaUZRTm9VeGh5U1li?=
 =?utf-8?B?WlFPMkd3NGhXQ0JEM1U5R3c4RCtYNHQ2QzRmWlJITlFOM1JiTXI0UG55Mmgy?=
 =?utf-8?B?bGs2bmdXRDZNckd1MDM5V1p4TVBwOHRzNWFmNUtLYllKaTh3TjJEV01BSjBk?=
 =?utf-8?B?d1BaSGlidWpUYnpqdUkwVUp5QXdoVTF0YnBRWm92K2EvbHJBMlBmbTVKRDBz?=
 =?utf-8?B?ai96NFFXRk13NHNRZGhmaXROanBiUnNtZ205SUJLbitrUDhVYzF4UVhsMzlk?=
 =?utf-8?B?UTRMUVp2N05WVzN5TTdOK1B6dXdkQmtlMzZFL3FDSVJueUhCelF0WUczaWV2?=
 =?utf-8?B?STlVSng4RG1mTWsvYmdQMElIOVZ5QWwyVnZldC9LYi9rUUQvWENpQVcxWC8w?=
 =?utf-8?B?bXR2dVB0RDBkTEg1aUdVSjh5WE9TYzJZelhKTkgzWmhReDZlbm9lN3pMcXZq?=
 =?utf-8?B?Z21kbmdiM245Z2xXUi8zdz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VzFXa3JiSHkyZytFcnQ3TGZwanJKQWRzZ2RpQ2ZzWm9DVDhPc1gwaDlKVXFo?=
 =?utf-8?B?Z2NXZTUxWG1HMnVJZHZxalM3ZGlJYVhNS3BGT3Q2Zkc1Zkp5dVE2SUhhc3pT?=
 =?utf-8?B?VGdDSks2aURSWEd2RVd5Y3F3TERZUXpyOVBNUVJhNkdxUjdxclR1K3F5Z1dD?=
 =?utf-8?B?TnRrTkJBZmc5dDJmamRTZ2QzTVptSXFsWXBGbjgwK0pENTlqQ3E3R2hPZERY?=
 =?utf-8?B?SkZXRmNvSmtCcUZNMEJlRTVwc3VpeVh0VUk1cjZkVUJJMGJzTFc5YmhuYmdB?=
 =?utf-8?B?ZEZ0TTdIUldiNnRmVE42WDFqR3lkS2pCanpKdjlTNEZPejd6RWhyM094Qk9a?=
 =?utf-8?B?NmY4SnhSTElidkYzaW9SNSs3bjh2WkR0RmJvTXkrUGdBNVllUGV5ekJZNmg5?=
 =?utf-8?B?K3RUdkFwYkRyQmUyOE9XTkppOEptV01jOXhGK3p1Z2VtMTRySXFicWlIdDBF?=
 =?utf-8?B?NURSV1FEYW1ydUVkRVpaeHptbTF1N1RaT2x6L1d3dWp0aVhDeUJNOGphNUNW?=
 =?utf-8?B?em1Kend0clp5dUFBUFB3ZUNOOTBVeS9HQy9GV3BjeEJWUlZLL3hYS2U3REc2?=
 =?utf-8?B?QVIzVzhJYWV2ek40ME1makhsRnkrZXlVOWNjUzdTUEo5bno3SEx4N3EwZ056?=
 =?utf-8?B?NkJBaEhORDA2Y0FVQXJIZmtiZmczck9rdHBKK0tPMVNxRmFSNkNPYkhkT2pH?=
 =?utf-8?B?SFpwbktWVlBVbGhxZXFDSjBzTlhUMldtTFF5UHJ4amRDRkxoRkt5dnhTMHU2?=
 =?utf-8?B?bEhNRWtzTVNBb1JHOWlkUVh4Y28vVkY4cW5GOVR0UWt3cDdIQ1p3SEppK3JG?=
 =?utf-8?B?RjhVZFNhakgvMm9FaW9ZWWUxTVFmOW1GdHFWK0J5WXZXQnEzcHJ1eVBQaEpN?=
 =?utf-8?B?cjFGS2I1U0lhSkJqelQrcFd5SWt4M3E0UkZlRUhXcktTWWttNXNKZG5Iem5Q?=
 =?utf-8?B?bWlHYXdDd3hIZ0YrR2gvUHpQRHdBWjUzNllHZkNNWUFiR1V6MGRNTm12REUy?=
 =?utf-8?B?SEVRMloxOWxkelB1TnBubXZ5RkpGc29ORmlGMEFhOEFBQnlteWZhTDJQb1FY?=
 =?utf-8?B?Mm9DdU5aTFlsMVN0eStabFBhRjBLRlZnaUdVWXNQeDg0aHVwK2w5c3pwR0h2?=
 =?utf-8?B?dUI2ZTR5cGtGdzRRUDlXNFdMcGxUcHRsS3ZwdzgzZStrekcwS2p0U0VCTEVD?=
 =?utf-8?B?R0UrdUo2L05yUmY2b0o1YVRsb3dZdzlYQW5HODVtYm0zMm9YWXJqVnE3Vjgy?=
 =?utf-8?B?MmdjQjhpVCtzTnlGQlhncEhCZHBqTkhXMU0yanpZUjF2ZlVYODlmSTlEM2Rq?=
 =?utf-8?B?MmJBTDNFTkROandjdWIvblVOdGNzcHROSldPLy9JYTJrNW9rWDhSeGdtUTBM?=
 =?utf-8?B?emZ4V2s5N1NWc29DRlU2VkVsNGFjSU90QS9sNElFamZIUnFzY1NOMWRoV0Jl?=
 =?utf-8?B?emdIcjk3eUZkUVJzTUpMR0FGTnN3TkFyaUd0UytuOTJuRzlvVFFlZ3I5YlpV?=
 =?utf-8?B?dmlYYTFYdWl5QjZETFprWE9sd09KUWVmOVhZN1lzaFFDZ1RBeXByT1dNSVFL?=
 =?utf-8?B?TENFb3dOenovdG56Rm01dk85dnFzU0FtQWcvOWR5U09kRDlxdzlTRURKZFhn?=
 =?utf-8?B?RXN1Z0xKdmQ0M1BVaTZXMEVoSkExWDg0R2pFa2ZuMTNxSVBRRDJBMUdreDN5?=
 =?utf-8?B?S1VtT0RyY3lVMGQwb2ptQnlzL2VWMXV1OEdhcnhpbWt3cmFvNEtub0dRa3Vh?=
 =?utf-8?B?WmJ4T2FvSElHZlltYVdMak9MNDVyL1lacitST25RSEV0c0JlQ2xmcUJNTll0?=
 =?utf-8?B?UU53U0RiUS81cGplZkFhUjRvWkc2dElvZWVvY0daYXhvdmF4OFJNUG83YjFY?=
 =?utf-8?B?Qk5qcUpLWHdwM3Zxb2xVRWlRb2JLM1gzcG1mV1hTZFVjVm43clJueE9MK1A5?=
 =?utf-8?B?ZnhpM1dKSDIxVnBuUzBwN1JiNFMyYWo0YVZSNHFHOXRRTjVBc1JFTUZSWjJi?=
 =?utf-8?B?bWhrZlhiQStkRFgwNGZtTWUrYkVrdVZ4ejdxT2NCRE5ONEN1aTB2RHJpY1Uz?=
 =?utf-8?B?eHJGUTdsY0EvWmR1UVlidmtYdnh1ejBieGY4LytwcFhENkthTWNXeGlMN3VC?=
 =?utf-8?Q?HBS7YZEk7ZeZhR8EfDMtss3El?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b6383c0-0db8-48dc-ede1-08dcc817f7f7
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2024 10:47:25.2967
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4L/i3TbZ23R+sWiavdFdpaBwmmxJj67sl2MYh9+RvJNt3Tu4Rass2VHBpTbGcapD9GnevGvQOwzmsV6JIBQ6tA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR12MB9434

Jason,


On 8/28/2024 11:43 PM, Jason Gunthorpe wrote:
> On Wed, Aug 28, 2024 at 12:09:01PM +0530, Vasant Hegde wrote:
>>> @@ -145,7 +145,7 @@ static bool increase_address_space(struct protection_domain *domain,
>>>  	bool ret = true;
>>>  	u64 *pte;
>>>  
>>> -	pte = iommu_alloc_page_node(domain->nid, gfp);
>>> +	pte = iommu_alloc_page_node(domain->iop.pgtbl.cfg.amd.nid, gfp);
>>
>> Too many level and used in multiple places. IMO its worth having helper function
>> to set/get nid.
> 
> There would need to be four functions - set/get domain/pgtbl which
> seems like overkill.. How about we just put some variables in:

This is better. Thanks!


-Vasant

> 
> diff --git a/drivers/iommu/amd/io_pgtable.c b/drivers/iommu/amd/io_pgtable.c
> index d56be842c0b71e..f71140416fcf6c 100644
> --- a/drivers/iommu/amd/io_pgtable.c
> +++ b/drivers/iommu/amd/io_pgtable.c
> @@ -141,11 +141,12 @@ static bool increase_address_space(struct protection_domain *domain,
>  				   unsigned long address,
>  				   gfp_t gfp)
>  {
> +	struct io_pgtable_cfg *cfg = &domain->iop.pgtbl.cfg;
>  	unsigned long flags;
>  	bool ret = true;
>  	u64 *pte;
>  
> -	pte = iommu_alloc_page_node(domain->iop.pgtbl.cfg.amd.nid, gfp);
> +	pte = iommu_alloc_page_node(cfg->amd.nid, gfp);
>  	if (!pte)
>  		return false;
>  
> @@ -182,6 +183,7 @@ static u64 *alloc_pte(struct protection_domain *domain,
>  		      gfp_t gfp,
>  		      bool *updated)
>  {
> +	struct io_pgtable_cfg *cfg = &domain->iop.pgtbl.cfg;
>  	int level, end_lvl;
>  	u64 *pte, *page;
>  
> @@ -233,8 +235,7 @@ static u64 *alloc_pte(struct protection_domain *domain,
>  
>  		if (!IOMMU_PTE_PRESENT(__pte) ||
>  		    pte_level == PAGE_MODE_NONE) {
> -			page = iommu_alloc_page_node(
> -				domain->iop.pgtbl.cfg.amd.nid, gfp);
> +			page = iommu_alloc_page_node(cfg->amd.nid, gfp);
>  
>  			if (!page)
>  				return NULL;
> diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
> index 1cdd1675a01af2..806156632bf70a 100644
> --- a/drivers/iommu/amd/iommu.c
> +++ b/drivers/iommu/amd/iommu.c
> @@ -2030,6 +2030,7 @@ static int do_attach(struct iommu_dev_data *dev_data,
>  		     struct protection_domain *domain)
>  {
>  	struct amd_iommu *iommu = get_amd_iommu_from_dev_data(dev_data);
> +	struct io_pgtable_cfg *cfg = &domain->iop.pgtbl.cfg;
>  	int ret = 0;
>  
>  	/* Update data structures */
> @@ -2037,8 +2038,8 @@ static int do_attach(struct iommu_dev_data *dev_data,
>  	list_add(&dev_data->list, &domain->dev_list);
>  
>  	/* Update NUMA Node ID */
> -	if (domain->iop.pgtbl.cfg.amd.nid == NUMA_NO_NODE)
> -		domain->iop.pgtbl.cfg.amd.nid = dev_to_node(dev_data->dev);
> +	if (cfg->amd.nid == NUMA_NO_NODE)
> +		cfg->amd.nid = dev_to_node(dev_data->dev);
>  
>  	/* Do reference counting */
>  	domain->dev_iommu[iommu->index] += 1;
> 
> 
> Thanks,
> Jason
