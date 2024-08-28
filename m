Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2071.outbound.protection.outlook.com [40.107.101.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A4D11411DE;
	Wed, 28 Aug 2024 06:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724826375; cv=fail; b=p4Q3G5nU9HjWSHXzbaz985GnLw5UIA+V/A7ZAnc8sB+qqB+rBQS8cnXMjfvtv+Jx6nkewMyHP5BmXvHNZq5AvjWj4QsDqAi7rMBbDZLcEtIHFsUe1i5Ip4hrnYbEmeXwGnzy4SmCxF1j6nEmV4+3rHiBltQvTRRhZbpeBkq4xvQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724826375; c=relaxed/simple;
	bh=8z5tDclAnCZ+leQVWGXBWVrS/LyfOZNw47Yidt+QMjI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=dtJSZqFPqIc5x9cf+661K5IQ21JLbWQuFING86Ws5iETegFHLwCpK4bQmQXg8ludwDRdQvfbHef0R5bAlzw2GdWQuDlfV6BoHuNFEC4q2vntdnGf1EZ9Chi228qcVLv/huRisEBVKS/aCB3uKsao7M0CfHsrWZhEfRt7ny6d7F8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=lvS7icTY; arc=fail smtp.client-ip=40.107.101.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="lvS7icTY"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u4RQ+xSjAB+F369AU3fE1R3CpOyzUrB3zhvM4RlMkU61MVuBBmkRajabNDY42M6b87TzaRbUKPs+/HdTwDbWW10Tls13KBzhitio9+QDkCyDkpt0DOCPL6DfaotdX74yEVJFNk6EEK7Fy9HmMFN6+WHYJ9rkXrfhTOq39zxQZRj6Z7ym8LAZL762KYi91bMvFAWfyM6XSbrKxIF7CSAaG0HDR2ch+WxM4NRmCkNtrrTSW8wTwckOmgR+zsWFT/4oNJMBIPEgXEW+I/3LHc1+nAp9CIljsq15GIRDkj2abYYPwTW2TLP5Foubmhek3GGNQ9p+nNR2S1YFI6t9latYOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4C6wlX2SyMD4p0s7ZiPM8BYvJbrWDPldbsZh/i4N5Ho=;
 b=wwKtKRJvc/x83CJpTNhHkMiXbTuHHtYL5qfh1sHgWQ2tikkS5NdmvAB/I18+a+OnS7F2BRbA8rlqw/ul9tdgrNdgnebbjrPo4FpvymH+jDK4zgiYrTG+KerOyxC/cGdZGzfLDJOZXIE3Ani7H1zy74th0gmdalJH1J6uH7jkApqF5UHjS/QCHJZgfKtZ36y0uIs/vA+Q8FSZ7cTdrLEhIcWyRTCoc+1zELGuJav/gu9FBBX6tPnNK/7W6HoqP4K78DT2Z7Qs6g659P2MChTCP8dfSi5k2MkOzSAXjPOXeE9gJWYCmzeoiQvPPZ8hc0fjc/7jOGesBYg0eZu/My/0tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4C6wlX2SyMD4p0s7ZiPM8BYvJbrWDPldbsZh/i4N5Ho=;
 b=lvS7icTYiEipPom1MuXTD26ezO1/cVjrv7GOp8UnquK6MBZDa9td6KeGVNZVTKXsgipTmSsCrOS03gwVwUF8JEJyRQ4lT5LFMAs1qORKm8Ru0TNX2RwqRIKvhMr8INqHZicmj9ka2sCY/rebQQQo/STvqpfysgUb9qS4B3HqriM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 SJ2PR12MB7989.namprd12.prod.outlook.com (2603:10b6:a03:4c3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.25; Wed, 28 Aug
 2024 06:26:11 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5%5]) with mapi id 15.20.7897.027; Wed, 28 Aug 2024
 06:26:11 +0000
Message-ID: <be807c3c-7ed0-4aee-bbe8-122b763ea5e6@amd.com>
Date: Wed, 28 Aug 2024 11:56:03 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/14] iommu/amd: Set the pgsize_bitmap correctly
To: Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
 Joao Martins <joao.m.martins@oracle.com>, Joerg Roedel <jroedel@suse.de>,
 patches@lists.linux.dev
References: <3-v1-cdaaddf80abb+14190-amd_iopgtbl_jgg@nvidia.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <3-v1-cdaaddf80abb+14190-amd_iopgtbl_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0196.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:e9::8) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|SJ2PR12MB7989:EE_
X-MS-Office365-Filtering-Correlation-Id: d2437ced-8c6a-479d-02e3-08dcc72a4f5b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?L0pheEdTd284TS9VRTZWSlZNWHkrc0RldStIY3BvVDIvZWQ0aFBwaHZjMmdK?=
 =?utf-8?B?K1c4cmNmZld5RXdCVS83cFhXVWRNeGQwRGFXbWx4R28yNng2L0YzMUtMb3No?=
 =?utf-8?B?Y09SK0RveUJCQmJnMlVHQ1FmVEtEdEpibWd4K3RhMHlaRXdHWWZrUEl2blpT?=
 =?utf-8?B?VVYvK2NYUldQQ2U0MU05cGVTNXNMY2c2Q2p4anhwYmlsRXJMSTI1Z3YrVlhL?=
 =?utf-8?B?VWVHdnpMR3J2TCtMeEpGVGdMTjNsRGY2Vy9oMGxtMy95dy96c1laeUNpSGFq?=
 =?utf-8?B?cTBWZENLWm9uSWwvREtqblUvTm4wcDZlbTZyRkRBSWsxS3lqaVRaU3lvVVB0?=
 =?utf-8?B?c3BEY29DU3ExcllOOUxwVC9mUkNUamxrL1RBemp3YTRKNVpMU1ZpRmN4OVpv?=
 =?utf-8?B?ZzBSWUhHUTBMN2FHWlJRQW0yT09BOVF1MFUrUU5TUW1oUko2OFZ3anNLTnF6?=
 =?utf-8?B?MGV2WHJjeVFKNzhneUtkc3RhU2JLT210M0JCUDRPZUhTdVBtUUpPNGFXWThE?=
 =?utf-8?B?RmtlQzhJWktodzNPUU8relp4RDRuOEwzdnUzam0vaFUxVlZQc1BHODllUU55?=
 =?utf-8?B?S01aM3MvRTZrZG04cUlDRDdyOEFSam1lTHlKS2VFbk1SQ09DYWZNT1pZNUt1?=
 =?utf-8?B?RFZlZjRuQ05kaHBuZkJXejJJOENhNGxvMzRwWXZ6WEhWbHN0T21DMnM5elhX?=
 =?utf-8?B?aGZsY2ZMN3prSDRjcDd5blhMZm42YUR5NjVGdmJKS1F4TUhSYU5xbC9ZcHJS?=
 =?utf-8?B?dTdlOGQ1TE1PQmd4MnlHaE9xVTQzWDZ2cTd3clNXOCtFYmJlbTFlUUl3L2dG?=
 =?utf-8?B?LytUWE9aSHlMOTFCU3VqOTgxRGNCWk5nMkRXSTJ0VnFoaHErWXJENXNFVS9s?=
 =?utf-8?B?eElJNENOa3pNeE1rYVF4dVQ1OFZOMU1WOUhCbHJWdTcrNUVaNXNSMXBzN1lO?=
 =?utf-8?B?aVIzK0hsVENkc3RXK2pFMGJxbnY4T2pENThhWjlQR0ZiWjBScEZTNzgrbFVH?=
 =?utf-8?B?SnZkOVhmTXlDbnk3am9FTVZvT3ZJYWduVFRlZzcweGJpTU9VMDBmYS9kWkR6?=
 =?utf-8?B?UGtFUnFOa2ZoUFFWZHhpMEkzN0FOUFNvdTZOa1ZzZG5udHhjVzZtUWxhNjc4?=
 =?utf-8?B?STVCRFhXM2hLVDc5V1dMQzFJVDMza284WmRWaHhxSHBFcmRWR01NSG9CTjhF?=
 =?utf-8?B?Y0NGU3RWL3lCdXljT0RWZmpseUNkUjRLeHkxOFhnQXBaazRqQm1pTmluajE5?=
 =?utf-8?B?S2U2aDIxWkpqdDNGdUprc2ZaRDdtS05NWG9uL1YrYjcwRXB3dXFEVUtINUdq?=
 =?utf-8?B?R3krb2dSY045dkRvR3I3MktCUXhINDFVa1R5ZXVEU0JyOURuSW5idE1xa0Nr?=
 =?utf-8?B?ZG1ZZ0pUMktGZkFsMUNYWEJMV2Erb3ViaWtCMmdIcExIcm5lS1YrZ2owWUFE?=
 =?utf-8?B?SWt6VmZMMmQ0eTVVUHVoZmh4Qk9lOGJ4djh6dFlHc3YzbGI0TWJaZmhvbEIv?=
 =?utf-8?B?RE53M0Zxc0JqVnFQTnZQN3U1Qy9VK2VYd21wdkxXamd3ckdQYUs3RXVGN3Z0?=
 =?utf-8?B?TXZ2NzY2QWh1NEhTeGhnR1k0aGhIK01wS2lGRGNBWFRLYTBYWXhuLzF6Nk9V?=
 =?utf-8?B?emdxL1BnQVlYMmVrNUdUY1JZcTlHTFJWcm5HdlRZU2N4c2V2RjFSUmpFVnFL?=
 =?utf-8?B?V3FtRmh3Wmw0SjFOS1lOZWhKOU03WUNsUFVVdFdtamFCV1ZrQUJNRENGMHQy?=
 =?utf-8?B?REoxWXRFOXdtejBzQ2NzZC90WTE1Z2hKQmdndjRNdy9CeVBHbE9jZkhrL0VS?=
 =?utf-8?B?bys0bXdmYkxNeUlFYXE1Zz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TSswRUVIbk4vTjc5WkxUQmMwYnRLNGZNRXovSVIxL0ErSFREQkxPU0UvaDdw?=
 =?utf-8?B?SUpQZXBsL3RWYWsyaUZ6RTlFaEd0WFdiMUg5K2tiZjZLWnVlajd0cXhMRG1t?=
 =?utf-8?B?WWgrSWZtOG03aWk3SHk1RXVLQk04R21lS0hNN1BHV25Ua05BVVcvcHZRZXBY?=
 =?utf-8?B?c2pKK1hycHlSU0VQanZGMjJZNGhIK2FSSVY3Z3Ywa3R1NHB0NDZheGp1Nm1T?=
 =?utf-8?B?TkJnUjhLQjlFRHhpWlFuTkx4cXRZWFZZeWhncnNKcm9EYWwyb29XWWlwMTZx?=
 =?utf-8?B?ak9oeXlrc0NRUFNyajVveVRjSEhrcEx4VXZxbCt0ZVlhN0ZFSzN5N2VKVnBJ?=
 =?utf-8?B?TWY1VUFLZkxQMUJpUDd5YXA5YnF2cTNVM3pURUdBMHpCQ2N3OVAzZVVBVms2?=
 =?utf-8?B?Tjg1em1tQ2h3RlhqUUF5eGVBcWV5YjdsSW5EYjdvUlc3b1pvK0ZNbnlwNjJu?=
 =?utf-8?B?TjJsMUJxS2ZTOEtGOHZEVDdPRlpXd1gzLzFXZHNFK2owSENvUGh3ZXQ3Zjh3?=
 =?utf-8?B?bVBCZlVEQXpuVkFkR1p0KzdmbWNlNTU2QzluRzArRUZNbWZSY3hrNFdBcjlz?=
 =?utf-8?B?cFJhSzZUYUZxZEdNRVNlNUtrWlN4cDRyWmNsNERCeVMxclpFL3R1ZkdBUFVZ?=
 =?utf-8?B?M0FMSjR5ZzB3Mk9GRTF1eFBxNE5PMktGa2pwSFRHbmpuaFVsc2MwV1NnRDVS?=
 =?utf-8?B?Z2VHdHJxLzc5eTRjT0hETzRWV2VZVGpCVCtoc1hSUnhkcm1EKzdEMDFjOERo?=
 =?utf-8?B?eVQ5YVJhMXd1OWF1QXFXNjdHN1NxZ1lZck90d0ZYblVTVTI4ZDFrajV0WHVT?=
 =?utf-8?B?bG9UNUVhSUpPRWNiTmFHdWlsZDBjaWYzcE0xZy9BQTdSL2xjdkRETDFUc3pi?=
 =?utf-8?B?OTRwTzF6amJVaWhvUlJ2NTNxdU1ZSWtHbFduaVQzWjVKeG44UitCUXpFckpm?=
 =?utf-8?B?WUJvZkVUVy9oNzJjaTc2U09oK1p5dHhQbDMrSnEzYnJqWm1LOXZYdFlaNHJm?=
 =?utf-8?B?N0RnbEtwc0NURU5TNXhLOS94QzBKVTNHTW90SGlNV3I1N2JQL0M4bWMvOGhy?=
 =?utf-8?B?aWNPWVRNY1FsaEVOSFhBb05BWlA2THBhS1FtYzBZZXcwdStKZWlPeGNDTE5j?=
 =?utf-8?B?TC9OTGlRZzVOOTlqMlNBeTZSNUZYakh6QlFGVGoyTDJNdVpmakYyTU5GVDkv?=
 =?utf-8?B?b0dxTmlKVWFsUlVIRS9lQ1RZZytWeEU2STJCZHBYNEhEQmM5TkdUdVQ0ZDhD?=
 =?utf-8?B?Q1dVY203bjZ3SmNNWVpONzczeWxLYkJxQ3JiY2RxOUtJc3hiNkNsZ202eXhl?=
 =?utf-8?B?cFp0MUN5OXdZeFF6SHIvYTIrQk9PUkFscW95T0dKSlpPU0x5RC82eXVZeVFH?=
 =?utf-8?B?Q2tnNVhQdlRwcUN1OFRVRTVpeFAwQTZTcmdEUzRqVVhtSStRMkFUSGNKZXlr?=
 =?utf-8?B?WXhzREQzeE1UYk8xWTYwU1hGQkR4a0dUcEs3eU4raTZUTnBPY28yYk41ajNu?=
 =?utf-8?B?SG9kVW1IWFRiSWFETllla2FPbnl2ZWZubExqVzUzZGhFQ1NVbXVNZE5hc0Va?=
 =?utf-8?B?R3ovM1pRQ25wSEFWemgvc0RLNXUwNkoxSzN2U2JOdldodXg1cmEvWGJHUVUx?=
 =?utf-8?B?bUVWdzlxS050cFZCREw4ODg1NUlJY3ZCSFE4QnI3bXo1dzNkQ09NaW52K0w4?=
 =?utf-8?B?ekMxTUpMRjhaczJXYk4wNlcwSzR3R0FxMnBxVFJQSGJ3dW1EOC9rUUdQbTR4?=
 =?utf-8?B?ckpUOXg5T2ZNWi92Mlhac05BYzJGOWsrS3BFYmw2aDhoZVJWRG1hWnZDVXVH?=
 =?utf-8?B?b0pYUzBsN0M5eVhoK0kwTWYvY01kekJIOTM5Uk1lU3liQUNUS0plRk54d091?=
 =?utf-8?B?RHp1L2ZWTkFMeHVKM2Z6WFAyc2tSZHpLbHY0TVNJdHRNSWFReDgzYm0waGpQ?=
 =?utf-8?B?L3M1bzE1QU1ITksvQi8venM2LzJLdEd0TDRRdGxOOVNmZWdIbVdoNlJ4QktI?=
 =?utf-8?B?ZndBbGNsL09WaFhIN1M5N3Q4ZkRaMU1mQnU2MEwxaDB4Y2xDZXhSektXSFBy?=
 =?utf-8?B?UjZQV0VKU3pySU8wSCtFSmE0SkVKb3Noc05OZGdGSlVoZGovS2RGYkJuYjVO?=
 =?utf-8?Q?nW4uTqAHxiUYtAhUXDkE3peUI?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2437ced-8c6a-479d-02e3-08dcc72a4f5b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2024 06:26:11.6654
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yBTijGEgmFWgGBfBV6PXxvmoKXdmMPmxScXKXsIfRki2ATosy/CzspeAKuXlRFxbRNezCqCx1EIYpCyJoTlM8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7989



On 8/21/2024 11:07 PM, Jason Gunthorpe wrote:
> When using io_pgtable the correct pgsize_bitmap is stored in the cfg, both
> v1_alloc_pgtable() and v2_alloc_pgtable() set it correctly.
> 
> This fixes a bug where the v2 pgtable had the wrong pgsize as
> protection_domain_init_v2() would set it and then do_iommu_domain_alloc()
> immediately resets it.
> 
> Remove the confusing ops.pgsize_bitmap since that is not used if the
> driver sets domain.pgsize_bitmap.
> 
> Fixes: 134288158a41 ("iommu/amd: Add domain_alloc_user based domain allocation")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>


Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>


-Vasant


