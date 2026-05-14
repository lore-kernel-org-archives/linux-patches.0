Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012017.outbound.protection.outlook.com [40.107.209.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A9371F131A;
	Thu, 14 May 2026 05:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778735248; cv=fail; b=j8oNGHmqtRjzXd7lVhCbfr6rkeppLsJ+jIqLDJ+ReuRlkfg2UJMsE9kQBoMho4N48E+S/FyJFVdfU3//O+gIKXsQN0lYW3tHiU75+YRVqiuyGLQ+8HK01/r1mTCS3rwxVPpMu/e2giWtUbhCZ/hbpF4xMeQfz+/LTb4TSS0Gy8A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778735248; c=relaxed/simple;
	bh=L2i/sn1m4YKEXPYirfruseOl7D3UhkaFYwFG5BNEi04=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=EuycFGpOrb000bSoL8q93Oe0GpMUVfF7FskMWKBw70gQCI8hBDjvNX5fcBZbLeeaZZJkGsTgfgjN5J51GVaRw/J9yXcqd2mj/CX6tC/iyM2GM0BFsEHRq9ka+uyHcrRGDwVX0c4PShjACqHDFlCuCdcyYcbWmSfe8d7h0jMonLw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=VoTQPwNb; arc=fail smtp.client-ip=40.107.209.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="VoTQPwNb"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n74WtZR4OoI59lYDSC9XEsl4nJlBB/zA1bkHHbK5ME3RSf2rYKxvX+0nKsQg+N+e3LDv44QcfYc3SvxQ1RVGhjH2SWWfxbluuif2jldsrioOQxmVAIhDwdFG5gv7i6Ef8bbOehqY2tDxu/TWUmb2+7otH9XSEf4zyR0Ezdm9n4PeOz1HP/EAxvDUBNPpmErKkXyFdQQ655iGRWo/ONSL/P5FKxStwgaOcEaJqUiu/k7h4EonSUo3YUUnKtNyq71QU+WETYEbVX25oyRkW+Uq6Ux79Yop3+b74S6Md+CWz0s5QEpI/ltsA/aLbjwadTIpCZCWbgPNbg739TCNA115Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XcjVsKFBlyCFQqsHEi7qCBRIJ83BtSL+ReTo2xmM+Rk=;
 b=dJ8fpro8vu3u81TPMLTQWMwQcOo08HogtzhT11+XQvP9wWVhJFbo5JX4ZLZKoDBb2W7xSnbM5oHlL3obZuP7R5loRlnWnfUrHgxmKFoGWg8FLDB4IlKiJKB9WTSs/H4fI+eAt1epzpWluAnsDVhpqcsMah+dxeZwazUBMRBUxstlo520tbLDzeLDRFpzBf3K2GgWIIvsPi1nHYlz2YHc72FO/K4cTQcwCoKGZhbmiyLum5ubRrjD2Crp7m+xlZUZWM9BpRK3M5vTZwUo236H5VlIf0tTO5pb+CEart3zOLBELOc3Ofq2iFKlxBialgMZHessX+TyClnI4SgPsugc2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XcjVsKFBlyCFQqsHEi7qCBRIJ83BtSL+ReTo2xmM+Rk=;
 b=VoTQPwNbQGQEyZIJdt5HfYQUMdXxGpsl0QiUF0aI9xCeUGYTiqh+IWou91UnzbL7XzYNKL0QaxpUJmmS+Q5U8FyqU5mQnZLtcmdTUyQvUH32WVcEQv6/Vq75j2l/XD8W06bBD1Y6jppET/Op1rauYNLhVa5Eso0dJoL65KiCrAc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 PH7PR12MB6860.namprd12.prod.outlook.com (2603:10b6:510:1b6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.18; Thu, 14 May
 2026 05:07:20 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::b5e5:12ea:9815:b7d4]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::b5e5:12ea:9815:b7d4%3]) with mapi id 15.20.9913.009; Thu, 14 May 2026
 05:07:20 +0000
Message-ID: <abb62e4b-30f3-46f0-ac7e-458245570430@amd.com>
Date: Thu, 14 May 2026 12:07:10 +0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/1] iommu/amd: Don't split flush for
 amd_iommu_domain_flush_all()
To: Samiullah Khawaja <skhawaja@google.com>, Weinan Liu <wnliu@google.com>
Cc: iommu@lists.linux.dev, jgg@nvidia.com, joro@8bytes.org,
 patches@lists.linux.dev, robin.murphy@arm.com, wei.w.wang@hotmail.com,
 will@kernel.org, kpsingh@kernel.org, josef@toxicpanda.com,
 "Hegde, Vasant" <Vasant.Hegde@amd.com>
References: <20260414210626.2097722-1-wnliu@google.com>
 <20260414210626.2097722-2-wnliu@google.com> <ad7TzkuA1VC26vkk@google.com>
Content-Language: en-US
From: "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>
In-Reply-To: <ad7TzkuA1VC26vkk@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN4PR01CA0001.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:272::7) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR12MB5445:EE_|PH7PR12MB6860:EE_
X-MS-Office365-Filtering-Correlation-Id: 32d06915-018b-4fe6-ada4-08deb176aced
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|18002099003|56012099003|22082099003|4143699003|11063799003;
X-Microsoft-Antispam-Message-Info:
	h2NLiuTpNhCkngtENvHOoaaI2cmuZuGJHPK+Wi6bq195G7anGaXwCEFbkmLaIxhw6/enSchFBz4agWg1/a/bIx/hC7tBtdOLN8C8LJ+zvJWPuzag6Ux9UkP+HSFqonb19hJQKWMRfsQ8Lrg2nSiiS1rIZDAOcP4PDQVw6sjo9LzA6I1KI/axOfV5T6hoTy8fu+0n4K7IIFVDT3Qz/H6EyvLZe7uiZEdz8gPz61I8soutCBwg2R/3xC68PAUnH1C5lpcwIsWpefLszNvOn8Msl8B8HxoSXPF5VxIpinTtPpI1dVm2Zlt0FrxEmOZMH1P2PNmvqHlBOvYJy3+B1EdyVh5626g/XtvlhriSZx16QPN5mfVHmNz68Ol1TTbWJGWIXIHWmPZkFV4tKwHjCalAPACWdW1yBXURqzsshaBw7QV/wO44DBCfyciQUgAH3/IX5TqGMkG76dDVjCfCnufB0AyUH95jQgH/bw626AKU9uPsA32SpnKi5rPgEedmN61ZEANPBMspHbDavBSbIQx6RREam10Z909bsRCD54T2oiaoLKjExj1JUEUMyEJG9Ev8S3nUWEzltN12k1oMRHplQlPAryZEyNPkZXvl9jEy7Hue0BQNhAvbJhuN82ciGnD/8T4eaLFGubU/KVs/V1qMtfA7ndsP40WcQxy1wgypnGzmApGiuVD73HoFgX0Eyd+j
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(18002099003)(56012099003)(22082099003)(4143699003)(11063799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RWpPQU1XSk5JbGE0UEloZ3VXS3Jyb2lIS09rUDg1U1M2ckc2ZkxXM3JvMHk3?=
 =?utf-8?B?T1FCYlpQRXgzYTRISXdPTWtKdjd2MU9ML3M2cTJOU2NhWS9IVFJoTTdOTWJp?=
 =?utf-8?B?TnFIcVlHaDc2d2dLWDliMUF2YllSMGh0a2VHVENPT2pRZzVIS0JMakMyOGFC?=
 =?utf-8?B?TFZSK3hYK0U4UDVxaFNBUDR4ODE4S211VGtoOUJvUFg5Q2lMRnlGeG1ocEJI?=
 =?utf-8?B?cTBibGg0N2s2M1F4YnY5OHBRQTdmUzg3NTZJTzBIbUFJTk9EZ3hLa2JMUEhq?=
 =?utf-8?B?dklyeGRjR1lHeEV0akQ1MEt6OEN4YXJsWUxONHY1MGpEdytaU0pzZ3BOaEdV?=
 =?utf-8?B?cEdBa2xoaXNvVEl3L0lHTmduclN4S0t1c0hFWmJtb0U5V2d3WEExRjVpNUI5?=
 =?utf-8?B?WHNZUm10Tll6dS9tU3lDQ2t3Z1BSS1VtS2prWEJVVWpxWFpERDdrTHFhZHdU?=
 =?utf-8?B?V1hHY08xTEc2M3lBYkVqdjdER3AwTGxwRkdZVHhCWFlENXZqVlpqaENNMmpo?=
 =?utf-8?B?Ynl1ek1JWFdZUEtOWU1HMGtWUm4zckhRQTFtNHE1REZIOHN0dVVUVkZ4bkh6?=
 =?utf-8?B?SHBWNm9lMktrQmxrSnplWGtXbEtISnRFZXBJTDc5dllqN1ZBSEJKWGdlOVFx?=
 =?utf-8?B?SXJMRzRrSDZTMUcxcUxodlUvb1NiNXI1a1VuRWl4WHFDY0RJdlNTRXZGejFz?=
 =?utf-8?B?MmVoOUh2a1VuWVFyM3ljYlRLbnVJSGIzbXVOYUlVemUxZXVZWUlROEliV3Uv?=
 =?utf-8?B?c2RHSWpPR1hHdFl5MytYYXFadytZVXhkMXNNOTBBOXp2QzRtWGZqU0dUdTRV?=
 =?utf-8?B?Q1hHbU9QNHFPSllwQXc5VURRNFd0dElqaWd5RlBsUnQ5NUJwRzRrVzJPMVlG?=
 =?utf-8?B?bmlVT1JpZktCNGhEZkVFdWVBT0g2aDFYK3pLVUVFek5EOFBxdlpSNE90TWtu?=
 =?utf-8?B?MG04OE1qRWcvYnhtODYxeUFvbFZ2ZC9HT1pkTGk3dGVqSkNKU0xIUDRzeTAw?=
 =?utf-8?B?ejZFaWxQZHBZNkpld0ZXMStQaUFmUkdjdG1pY0piRy82TmN3c1pjRWZ2WDJC?=
 =?utf-8?B?U0Rpc0VZSmdYSjBKMmxiMmZYQ3NIaEF4cWlSVE9tM2w3M0Y2eXVNSDFtNDQ5?=
 =?utf-8?B?OWxGd0Z0aEVudXJzRG1zcDNaSHpiR3pjV1BtdXpHYkxFdndXYnBZSW1EUHYy?=
 =?utf-8?B?TzJrRmIvZTVUbTRNckhVditCUkpXTDIzMjFXSnl0czVCbEI5SklzTFpDV09N?=
 =?utf-8?B?NmlBKzZaY2RteGNFbnI3cXFBMUZ4Q2RDNDZ0Y2hjY3ZYS1BBQnJ6T3dpVlJI?=
 =?utf-8?B?ZC94L1FsVVVMTUVxaHpzdHkrNi9tQWo4MmdTNzQ2K1krR29CVUt3Mll4WE5Z?=
 =?utf-8?B?SDl1L1FwTkxDYTJScC9zV2FrYW1JaEtLWlJMaTR4cmhZUmdCTS8rQUhBNUtZ?=
 =?utf-8?B?SjlENUlmbFlMYm1KeVBPRGxEeEN1aEtJbmVIa1R6a2xUTTJ6TWtnbFRkcDNn?=
 =?utf-8?B?TEsvNlZtNC80TXFjZWNVOUVKKzFDZ283dld5c244Ym1ZQjR1VkhlU0hsUVdn?=
 =?utf-8?B?MHA0dEVWWUp1VGdkRkRJVXcwa0Nlb3JnU2FQalVLUGw4MjBkbFNpYWJOZ3kv?=
 =?utf-8?B?dkxqU2MvZWFqcE9ud3hXbUNjeTgvUmRBQnBBMjROKzNSV3Nyc2hORi9za2Vy?=
 =?utf-8?B?NXJHVUFNRkFtS0EvTytNYUZlRmE1YnlnZkVGZk1uNzZhWi9EMkhsUWFRaERL?=
 =?utf-8?B?UjZ3TG9hU1U3UHQxTlZuSGJudFQyNmZIZ3ZVRnNnclF3QnJvVW9tSkV3S3Aw?=
 =?utf-8?B?U3kxaE1JYjNMdG1KOHA3RmJkOXA3L2V3MCtQV1dta2hlMG52bzh5U0orakt1?=
 =?utf-8?B?TUN6TWFLU2pvTEdtbDdjclp5NytubmJuQllqK1p6Z0ZHZnRCOE81WUJhRHMr?=
 =?utf-8?B?TUlBWFJySzVIOUdNckhCMjVtT05MajU5TzhmMDc1Q3RYbVBSTjVOaUliaS9q?=
 =?utf-8?B?cUp5dUJ3emFDL2R4TEtaWTJ6TGFLeTZHRTllYnBxT3VUbzZIL2JFVU1ZSHI0?=
 =?utf-8?B?KzlTZDJiMm5iTkVFQkJmTzgxRjZPWFVpNS9OZXNVSm1QVWgwb1dwSVdVYnl4?=
 =?utf-8?B?MmM3S1k2SXdvQUJRQm5HaHFQblBWWFE3M0U1Qm5JOEhHWDZXZDNXVytndmd1?=
 =?utf-8?B?QmU5YmtXbFJDaTdKd1h3M05FNkh0TVJ5YnRnTHFQaDVBUXBueHArNlpUa2JK?=
 =?utf-8?B?cU1qeE1Mc0VHSUMxdXZoMUlEcVdyaUtYUlliTkErUGxvUm5obW1qMTRXTWRL?=
 =?utf-8?Q?qQ3bLSV7N9bNuRvOt/?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32d06915-018b-4fe6-ada4-08deb176aced
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2026 05:07:20.3706
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 70I9glbZpjhIGcbeluIYuJYU3RzPAaG1PcQNwCBMqXUAXwbRoGlm07Pj9xyk4v2gIkA7YwypgIgUQfoU7GfcbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6860



On 4/15/2026 6:55 AM, Samiullah Khawaja wrote:
> On Tue, Apr 14, 2026 at 09:06:26PM +0000, Weinan Liu wrote:
>> We have observed multiple full invalidations occurring during device
>> detach when we are done using the vfio-device.
>>
>> blocked_domain_attach_device()
>>  -> detach_device()
>>    -> amd_iommu_domain_flush_all()
>>      -> amd_iommu_domain_flush_pages(..., 
>> CMD_INV_IOMMU_ALL_PAGES_ADDRESS)
>>
>>          while (size != 0) {
>>
>>          -> __domain_flush_pages( flush_size /* power of 2 flush_size */)
>>            -> domain_flush_pages_v1()
>>              -> build_inv_iommu_pages()
>>                -> build_inv_address()
>>
>>         }
>>
>> build_inv_address() will trigger a full invalidation  if the chunk
>> size > (1 << 51). Consequently, the guest will issue multiple full
>> invalidations for a single call to  amd_iommu_domain_flush_all()
>>
>> Without this patch, we will see 10 time instead of 1 time full
>> invalidations for every amd_iommu_domain_flush_all().
>>
>> Fixes: a270be1b3fdf ("iommu/amd: Use only natural aligned flushes in a 
>> VM")
>>
>> Suggested-by: Josef Bacik <josef@toxicpanda.com>
>> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
>> Signed-off-by: Weinan Liu <wnliu@google.com>
>> ---
>> drivers/iommu/amd/iommu.c | 3 ++-
>> 1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
>> index 760d5f4623b5..bcec8721d228 100644
>> --- a/drivers/iommu/amd/iommu.c
>> +++ b/drivers/iommu/amd/iommu.c
>> @@ -1769,7 +1769,8 @@ void amd_iommu_domain_flush_pages(struct 
>> protection_domain *domain,
>> {
>>     lockdep_assert_held(&domain->lock);
>>
>> -    if (likely(!amd_iommu_np_cache)) {
>> +    if (likely(!amd_iommu_np_cache) ||
>> +        size == CMD_INV_IOMMU_ALL_PAGES_ADDRESS) {
>>         __domain_flush_pages(domain, address, size);
>>
>>         /* Wait until IOMMU TLB and all device IOTLB flushes are 
>> complete */
>> -- 
>> 2.54.0.rc0.605.g598a273b03-goog
>>
>>
> 
> Reviewed-by: Samiullah Khawaja <skhawaja@google.com>

Thanks,

Reviewed-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

