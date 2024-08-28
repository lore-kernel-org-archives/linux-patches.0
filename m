Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2084.outbound.protection.outlook.com [40.107.95.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E058914C592;
	Wed, 28 Aug 2024 06:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724827311; cv=fail; b=SiuxSODvVAhCYwwZ49T55SBXN+6+YMH0y0oZFYpvqW5zBlljEH8xqXXCB4HGWFJGhnGUQIhnx33PMq3fq2/alWVrD4pgSfDc2Bfur0dGIrZ4a4od9IFBKQc6k5tHp44f0ZRcabVPXACMLL+yZE3YUSkkAGK54nFxGbhirWpWVr4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724827311; c=relaxed/simple;
	bh=L+uI1zIUMmt0xvgYldFO2O9TMvIGp/qx/BQPpKF4rAE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sV2aKulUgiEACOXkc062af48FP7quDuhQpazcsjjnkgmH/pPzIZeA9AtUxhO6fYZy89n+9J4oU8v02t8HHuUvMiB3BioWU89CNNwvnxqwJBdJMQYsQCIgTQaeJuLhu6sMIba5mUR0odSBmPujgmgmTvAHHUtj1VmFsjtn3TJPHs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=WhZtrhHs; arc=fail smtp.client-ip=40.107.95.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="WhZtrhHs"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=if0JaHSfF/RLuKVti/hYGk2EUmmdxcqHCLXkWnjFojkRoxJc1B+mVzyM4wghbitM3/fqYvX2wuOND8DvXvUcOZ6jgRQSSe7LlS+B3GAJNdZyTnF3Mgt1Xh79YVT2DWGWO9CTur4vTOSA3QP8rzIQlw1+9VV71Mx3e8wS200WZRFXP5mVYm42t7DXfv7V5lOxL/wY9kVp3p0xlbkpUbFcjnA+bekylm5+s52qdUiKLOrNYh0piSYfn5ZREAPaV5gJsw0l7iGAFNnsdDiMZqI2xXJWZHHT9W0WgCqnH3xxBMBXMRvuegk8K4+3zLNnDR1bd3axAZlr1+twhNEtSmkNNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BPtzo9TvgsAL0MU5gMV5u5RFP6EbqrV2zw56b/8wSlQ=;
 b=EHU6MDnDNBjfA1EI5chfFqouFpZom9zEvn2Z4hfVBolx1zYtTFDt7ZjWRKrrIfCdBEuK/MHPjwyi1Zf2Q0GHSeTjE79KrnK1gzf8jWe2soyKS1cr94DTPjF7xShX3qKwLlVNMgQQqDG/Y/Rd631eHI82sXlaY16jRYZI3lyjrSbRrvRXjuKVuOBafzog3WRv02hOgDYqT9s2pSM0vguBVn1f52hMzUdcPixLtnxe58wwwHqt6snWyCXVRlbOJSnqyduHioS67pIk8ufVlVvWr7Ro6LDPeYkun3ZcAPiKc3jasGZALSYXS/FoZNFGFc6guPj7umDkdKX7jPVjXJ6RLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BPtzo9TvgsAL0MU5gMV5u5RFP6EbqrV2zw56b/8wSlQ=;
 b=WhZtrhHs1nBr3FgwMZ/uzbmJNkVPyyw6wVYA5bkENAuPd1E/btEkJbKHLfblV8L0vxpmFhwUiV3fF/nt5AefBlhFWjRnd+Qwvlpn8Chd43Wf337w7UsIqACAEFSZfLBlATfPbHpKPASGAQBZvoWOAd/DglqFD0x85J8vFmOMnz0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 DS0PR12MB6392.namprd12.prod.outlook.com (2603:10b6:8:cc::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7897.26; Wed, 28 Aug 2024 06:41:47 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5%5]) with mapi id 15.20.7897.027; Wed, 28 Aug 2024
 06:41:47 +0000
Message-ID: <e379e8bd-c7d7-4b05-9032-f783bd550ad3@amd.com>
Date: Wed, 28 Aug 2024 12:11:39 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 14/14] iommu/amd: Do not set the D bit on AMD v2 table
 entries
To: Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
 Joao Martins <joao.m.martins@oracle.com>, Joerg Roedel <jroedel@suse.de>,
 patches@lists.linux.dev
References: <14-v1-cdaaddf80abb+14190-amd_iopgtbl_jgg@nvidia.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <14-v1-cdaaddf80abb+14190-amd_iopgtbl_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0065.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:99::16) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|DS0PR12MB6392:EE_
X-MS-Office365-Filtering-Correlation-Id: 73044945-a732-4dd9-7385-08dcc72c7d20
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WXZwbkJCTVJrcVVrK3FCa2dVb2FnZlQrbVdNaU5od2tYRG1wZ3JYeEJOTHl2?=
 =?utf-8?B?TTBQSmZaSTdHU0Nsc1c5aU1EaGN6cnFJaDZKK05IUlgxRjZHM0k1Z3NLeU5V?=
 =?utf-8?B?VUNKRTFDblN1ck54MHlhMmFJOEt6WEh4VE1kcS9YRFAvcXJDZWlLUkx0cmxU?=
 =?utf-8?B?UnhxdnBGaGduTWdmb0YxRG9ablNBNXF6TitZS0hCOWFnRXhQWTR3RGhyd0hV?=
 =?utf-8?B?R1JLYkJUdDdwSlcvRVFySUNyekFXV3lVZGZpM1owcUN6NjdIZVpjRHN2OWZZ?=
 =?utf-8?B?QlczUjRmc2ZtNS95NXFDdG1yYmdhQWZDYUVKQ1crQ1VHeVJpbHBEbm92eGVn?=
 =?utf-8?B?SFNUSXN3ZHpVZWNLWFZjeldaYytRVDJoVFRRL2FGUFpJVHEwUnJ6Q3B0V0VY?=
 =?utf-8?B?cW1IeWRNVmpaSWNuQlBCelBtNTVWOE5kaDU0WXVnR2d3N25tdFl0THBSRFVC?=
 =?utf-8?B?aU5HNWJLUURlTkFQOHR4WFJkdDFQV3JNcWk3SnJnMk5Malg4Y2tQczNUQkZ5?=
 =?utf-8?B?VHVxaE9xNkVpZUN2THg1OFZPR2QzNFF2ZEFuZ3ppVmFSSG5SYmFMbzlpSys5?=
 =?utf-8?B?MVdiZURsNTh3WU9tOEhYQmNJbHkya1Y1cDcxTU50NmJTLzJ1NEErNzNSWmxO?=
 =?utf-8?B?b2lQM2tQNUlnMDFjZW9QWi9mWHdOT2lwWmNjVmJ6SGlOMlBJSXliYWpUZXB2?=
 =?utf-8?B?aXk5RGp2NkpMdUF1QkdyU2o0YzEwTFFpMG56SWVOU0NKalNuWllZbEVNNnVo?=
 =?utf-8?B?OXVNMHRCSTd6eUh4WW5wT3Y1ckcvQTBWdUNpQVU3RG1iTjBDQUZUVGMrbCtC?=
 =?utf-8?B?WWpob1ZZU1R0WHd3bkhURVpJZ0J6bXRBbmpYWGpFWkt0bDlLblozQUhMT0Nr?=
 =?utf-8?B?VTBKM3FycUIwbFNkYTlCYjNrOTNBSHZ6SDFnVC9VZjk1UUVYaVFyR21MSXQ4?=
 =?utf-8?B?T3h5QkhWWXdNQ2tpSnlCM2xFR0VqM1F0SHUvT29vc3ZMWDJ3RU9hTlBFYW5C?=
 =?utf-8?B?SlJEcUpEYzNlZ2hVaHBEcnRhMHkyUENWY0hmYXI2L2wvS1Q5bTNFZTBZM0E2?=
 =?utf-8?B?bGdOeFNLb0djTXV4WXFGK1hEa2pXTmlMMFc3M3c5N1NIV3ZkWmVrMUxBa0dM?=
 =?utf-8?B?Qno0blR6UlpqLzVlSEdQMlpVeVpyMm1NUHJyQ2JublhOU3JwR2Uva1Q4czBw?=
 =?utf-8?B?b292MDBja0k3WmFXTW4vbllFTmFwdXlXMWhRdWhnZWYvakhDYXFXZERLbVBJ?=
 =?utf-8?B?OUxwTUlkVGFYSVFuVWhuRWdDalJlTnVjSUxaK0k5VnFGZFU0V3AySFM2UnV6?=
 =?utf-8?B?T2VBMVltYU80Um5nK0ZPdE1heE02aXlXaTQvdGQ5Y2J4cE1hTVpQQzlVVDRP?=
 =?utf-8?B?YW5xd2FTbEl2cTZiRFhUWkw5NmhkRjNsc0kxbFFsUWVxL3FzZjQyY3JMSFg5?=
 =?utf-8?B?MFZwVGJ2NU0wZVBKSmkxcnVwQWRsTUQ0TmNHTmVGVW9uUXdMaWtOUWx5MVUy?=
 =?utf-8?B?Wkd2Tzl5MERETVcvcDJmS0piMi9mdGNBV1h2cXBpSURXM3BSb0tVUVprRGJs?=
 =?utf-8?B?M2ozbUFCQXlSTUdrVFlORWw3YndlVTNvVmQ4S21qU2dNUGhtaEJlQ1VjUmND?=
 =?utf-8?B?a0hzcUtiMkZyRWhIbGpkZ2w2NzZGay9tQldSMFpkaFEyQzVxeHIvVDhLYTQx?=
 =?utf-8?B?dGhaYktlQmx6NXloZUNnZ2lpbkxuTFZuOFBMcFpuQmNXaWhYR3lDL3h6b2gr?=
 =?utf-8?B?MTd5ZU15M014ZFpuRExVVmFJMW8ybVgrckJxcGRvTkl2Wm1ZZEQxLzhSR2xo?=
 =?utf-8?B?aHlnWFprTC9GRTA2TFBDZz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OWJNZmdJUXU2cVdFMWNVSndnRTZpWHpUcmp2R2pNVUVzaVBNcGdMUFZoRWo0?=
 =?utf-8?B?Z0pJY1E4OGNjVjE3QnhJNDcrU0pzdUU5eHpCbGg3ckhxTmNQS0lJMVdySEFU?=
 =?utf-8?B?ZFpYTEcxWGxicVNCMWFFb3hUY1A1Zm11TkdaaU1FSkRuR1RHY0FTQ3JWOXRB?=
 =?utf-8?B?ZWxmNzVnbmI1M0FQclpqSGsya0xIOEZTS2JGbHBCN0JkRmFoYVNPU1lBQzJl?=
 =?utf-8?B?OUZNdlhLMlhobndVTFFtTWVHR3pyZFlmQ1RzU1JtRkg2MzF4eHpRRnhhYnIr?=
 =?utf-8?B?dlp3MHVDL0NuUlpKUWZjTlpNNUFzZXNuTUdMYVAwQjI2d0NKb3VicUdKUGMy?=
 =?utf-8?B?bmJxdzEzQ3hTd2FPN3h1Z3J2K1R4N0Npc3ZKUDJoa3Z4Y2JBeTBCMFhvQ3ZO?=
 =?utf-8?B?SGthVEpSQjVib2FscENPZ2R3Ly90cHI2SndNTU5iVHZGRzNNSkRvRm5qUCtC?=
 =?utf-8?B?dUNzbzY5YkRqS1cvUDZDVUxiL3ByUVo0VmhRRnlobXJDZSttbjJZMHZYNW5J?=
 =?utf-8?B?ZnhXSjhmdktrSGRkdVVXckhTTWR2QjJGaHVwZ0s1SU1ZcVVEdkJvbTZOVm9q?=
 =?utf-8?B?SjhnNmIvNDVKbkZJWVN2M3ZEdWs1b1VrRUhkazZBQjc5SjBRancrczZJUThu?=
 =?utf-8?B?cDBVaTlXM2hZWkg5TXd1TVlUaXY1MEtFcHlNVk9WdUJsbUplZ0h3NGs0OXNr?=
 =?utf-8?B?dnAvWldYRUJIdmM3K0hjaU1JRUdmbVk1VzA4OFBEMTRHMnJlNGZDdjU1SEJw?=
 =?utf-8?B?eUJ5YnBuUm40ejVOdHd6TWZJMUI2NGwwVHRNNy9qc0V4YUVqdjVSZ0VIRDFY?=
 =?utf-8?B?QVRkYk5LelYzR2M1K3ZWNjdSTmxGU2JUQzFQRkRJeGhFQWhnbS9ZdHZ3Qkov?=
 =?utf-8?B?cDQ0MXJJeUJpdm5RMmFER2pvc0Jtd1BCQXpRNytsNG9qb04xL2M3YnBPR0Iw?=
 =?utf-8?B?VUxVOXM2aXMxU3VuZTlpamZsbjdzUHpmZkh2b01lTklYUkNvbzdXRUNReW92?=
 =?utf-8?B?RXFkVVRLb3l6UUpZT000cndXYzVHdk5ldk4wNnhURVg1K1JETTBBUmkzUlcy?=
 =?utf-8?B?OWQ5OWx6V1JYNmFFYTJ2ZkthcGdNNG85aVRaUVJXT2RXUXA4aUZvTW5lT0Uw?=
 =?utf-8?B?VEtuMEQ0SFdrM1pVZjhpQVBQL2RUa08rSnUwS3VkU0pXc1hCL0hFdDdtYWtQ?=
 =?utf-8?B?YkhBR3VDUng3YmRsV2Nwdzc2WitrcWVKdzNzS002aXRoRmRhZ0dycDFkanRY?=
 =?utf-8?B?cUJ4YUlFMFVaVUNmK1RRWkVnY1JxM3RVUEhqVEdoSFB4ZmdLNFF6MUY1T3Uw?=
 =?utf-8?B?WktWemszVWVhY1BaRmNLajFmR2JQWGVtQ0pwTDA3di9JWEppU0lJRGQwUmFw?=
 =?utf-8?B?MFB4VU1hMXJ5VThVdm9kalFiTVhPTnZXdXUvb25WcXp6dmF2TEYvMXhNQUhV?=
 =?utf-8?B?OHJHVWI5bXJ2MEhRejBGai9HSEFwSTMvVnF6a1EzenAvd0UzRm4rRVk5NGpj?=
 =?utf-8?B?VEdLTjNVbTQ5QUtvZ0lwUGk4Vk82K2NWaTdIc2hIanVWY0wyeGZ5M0t5Z0c5?=
 =?utf-8?B?TEdFNkk1dUlZTXorK2VSVHNNdVhrenczOEppRkk1cDFOM2F6UkZva2p3bGZ5?=
 =?utf-8?B?cTBFYlBLYzUreHpqWk91aUFiUjlXVkRUS3NKdmUva0I2RkpObG9PeDk2QkNu?=
 =?utf-8?B?SzBQdmhySjU3cDRkWjZlSmxUaklWQ3FBKzE4bnROSE00RUlac2tLQ3gyWHky?=
 =?utf-8?B?blRodzE2Q0pJeTEzNWxvN2Q0M0hiV21XWXVKTXBCb3pSQk1JZ1ovdGhIcmc4?=
 =?utf-8?B?V2RWaUc0UHpjY1hvVEtSYmRaOHoxT1FKbUdKTVBiVW9iWFlva2xnYkRueEpl?=
 =?utf-8?B?YTBVZWl1N1ozeUlndFJrekNIM0lwYzdUNDVBZU1oUktldVBVc3pyMEU1OFNE?=
 =?utf-8?B?RXNiSUZhNTRBeUtqRFNKZzExSFNudy9WNjNnSXpFaHNJaXR1eEZtQkRyUzNP?=
 =?utf-8?B?Qm1LWEFSYjJrMFVicGY3L3BTbzZQVDNzNnJncXI4UEN6ODVxZDJpZUJYUzlu?=
 =?utf-8?B?T0VjcythM1VJd1ZocTZKclhTZWdTNklIN0NxV29YeDJHRmIyNmtEM3lMMloz?=
 =?utf-8?Q?4lCs9CWu9Cq8yvZZdbAuJvA+9?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73044945-a732-4dd9-7385-08dcc72c7d20
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2024 06:41:47.4970
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u8ugAwmIHC+zOGPwfVdzIamMOYCfYZMxshxixK+v83j+5xfFY0CMnbsyyb+iOCD7BwhTsBlElyIxbXuqWz67fA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6392



On 8/21/2024 11:07 PM, Jason Gunthorpe wrote:
> The manual says that bit 6 is IGN for all Page-Table Base Address
> pointers, don't set it.
> 
> Fixes: aaac38f61487 ("iommu/amd: Initial support for AMD IOMMU v2 page table")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>


-Vasant
