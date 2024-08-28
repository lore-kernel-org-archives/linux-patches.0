Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2060.outbound.protection.outlook.com [40.107.237.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 874E75A79B;
	Wed, 28 Aug 2024 06:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724827391; cv=fail; b=MzSD4fyQZShiXO3PY2cBGIevVxuJDjdSMOCVP8AIZEDcf4nZq1LiU2nSYkHCwmre7XNucL9WnccaOJDv94SsKHXDF6pyV5VkXmM+82qO+8JOqNhDfyuytOpn65g84lGqOTJ1gKu2xazgHSJNKtBpG2DRRTSQDThxjvqI01yBcnc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724827391; c=relaxed/simple;
	bh=agwlO7AC5Af10Nt2KGSxmps44TBQQ48GLDNZpewimvk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nGtS97MhnSIO88jCvnYXnoDsAmXkN1We6Dz0n7xzlNJQI/MIfDak1orOx7uFqbBu/46m8AbjL704+nY4GoSp6blH9bgDPbJVm+KbkqDDCvnJDjrNlXMrvrer4bqCuIF6ulZv20VIQyNmbyuQmlMpqvScKuiy2eKHlp0hQZAgo4I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=c6S+vAAP; arc=fail smtp.client-ip=40.107.237.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="c6S+vAAP"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eRxWzbLqUmKrogyUa/FpZK3qyGgdMrHfrQOxoVzo7vUGxf2yc37kfbTVWwjus6HDO2I8WBb23E9EK5aTkDb9x1mXN3SypKNwWDiOAfnV8kl51Vv92O/LoKAWL9gAs0XnZx99MmOd48+EvZzJqH77OyzqW1xVF/oRdz+KWdowd6HtBcfvlTlo6F9SB2SZYok/dF0dzXMib1IlTuUC5Mh/dA3ZwWix2UnZQW2PhiERp0PQsxeuIs1jf4sfzgHueVdDLRX2SIA42oLvAr1IPxaMmz1xWUGSv0sF25CvaJd3B3gs159/TmYuqK/cdaAHBN8qU3ZX1ubI9xf0HbjGU8uXoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AGSp2KcPZNmI2G9CtlrFWtyy0VsYZ9GqFjr556Xb53Y=;
 b=we5chCaYPLQB2S0IyIYOD2v7kiaWHS4XozPD1Q3N9+nL6KpD7eFWS3QJQJ6TJ/9ijrLZ1WzAbe1mdabloFpbQDtXB+zLefqGS81C7PpqXovne0b19JiDLQWDhsa/WiLA3btBfc0590NuwDzz93JzFhGANwB52Zpet5hQxvKDK0/QhYOGkZfdw4l7wxTRFfnpNVOru0CtB2AxMmDlX69D0lUcSNAw8eJEmQHR0gXOToxqFZ7TJQRucHb0J5rcFbqqE38jReGhp0mZ2yXAvi4uLYfx7XmKhkVH/emU/8aHFcQLsyyRUC9wR2q5mWabABcHQa3dqKMvyk3+3u5lOk9KnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AGSp2KcPZNmI2G9CtlrFWtyy0VsYZ9GqFjr556Xb53Y=;
 b=c6S+vAAPG+RbFNI/LJzE3djuqF3/Ff9ofvXrYjR07NeqGCuZK5XzxKP+BtgVlF7LR21TeM22KZfxslHWOoGXo4yd0eyZ8eqENnpX/VBoXdNHy7aU91fGy7Fc8CXlK5pxI+R3tLWIklDgpXMBjw+XlU1xFV88z1OgmGx1xiDSGrM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 MN0PR12MB6344.namprd12.prod.outlook.com (2603:10b6:208:3d3::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.27; Wed, 28 Aug
 2024 06:43:06 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5%5]) with mapi id 15.20.7897.027; Wed, 28 Aug 2024
 06:43:06 +0000
Message-ID: <da34355c-2d53-4a87-a110-c75861940b5c@amd.com>
Date: Wed, 28 Aug 2024 12:12:56 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 12/14] iommu/amd: Remove the confusing dummy
 iommu_flush_ops tlb ops
To: Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
 Joao Martins <joao.m.martins@oracle.com>, Joerg Roedel <jroedel@suse.de>,
 patches@lists.linux.dev
References: <12-v1-cdaaddf80abb+14190-amd_iopgtbl_jgg@nvidia.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <12-v1-cdaaddf80abb+14190-amd_iopgtbl_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0075.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:ad::16) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|MN0PR12MB6344:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a9337ec-5351-42c0-b057-08dcc72cac25
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NzJwRWc2TnhIZjZYY2g0cm45MXF6WE1zcjlEYU9qVHFNTHpCaldkY3B5MHZN?=
 =?utf-8?B?RlNzelQzWUpRWWFFUlJLNStjMUd0Q1dyQ1NYYWR0YTJObmkwNFBucDE3WVZr?=
 =?utf-8?B?eHhraXZEeWxteUtiTkJuMlhkRlN5blRoSllXVXdoNTA5U3gybDBLTkdYYWNR?=
 =?utf-8?B?ZXhhTGtjOHB6elAzL3JHRTVZVVAvMmE0bVJFZCt6MEFsYUJqWno2ZEtqVmNP?=
 =?utf-8?B?NVZrWHVRY3laVjdpdUhmdTkyckluR01oTG9aRnNLbzRxeFVyY0V0YVdJSHRN?=
 =?utf-8?B?SkUzd29hVG9tTzBXOXdlN3haaFlNN1drMWtweUJEdkljc1AyVk1MdVJDWkNP?=
 =?utf-8?B?TnB0dTdweEp2NXdEZFUvanhoTGdUVnZEMHFGOXpNclRER3dXdFlXVCtlQ0Uw?=
 =?utf-8?B?VVJmMks4QXp4UlVqWHFET1RDRFNuTUVBYUZBTjRMRk5sM0pXWDJyQlhjUE1x?=
 =?utf-8?B?NWczZEVuNXc4cjdKaHV1SWhPdTB1c2VjRHBVMDA5SWRBeFRFUlNpRm4wMC9i?=
 =?utf-8?B?bVd4ZFVDOERISGtOa0d1TFltSDB2aWpwcHJldGJROHU3ZkFBdGcrazZBdE9U?=
 =?utf-8?B?eFhvYjdXNlQyWVFuQ3FsRXJIdDF4dWhJanNvcDhqV2VocGRBcE5qVWJnbjYr?=
 =?utf-8?B?OFo5MEFNSS9UcHVzNHdURjdRY0MzVW1sR3c1cEJ0R1lMbDZGdDNFYkhwUVdX?=
 =?utf-8?B?QXkzTXA3SU14UGxwZURKZExkb0pYUVFIWkF2SzJBaGFMb3NDZFpyL3hRcWto?=
 =?utf-8?B?Z1p1RDgraWdxZFZWVmV6K2lERnloaXpxdjg5K0tKNW9scnBDN20yMnBjSXZU?=
 =?utf-8?B?djFicnV1ajdwcTllRUNGdytzRENHOWVCTHNvOU9EcWg2SnNDQ09oRHFhUllm?=
 =?utf-8?B?MjhSV1pqSjhSQmRkWkZHVVhkTGJsWTNpdVY4K2tjWlptellkRHh0YkVHZVFz?=
 =?utf-8?B?d0V3T3BjWCtYMkluV3pRSXN5K1Zpa2VTcjF5Uk14bE1JUjNibHQ2RUhoZ2Ji?=
 =?utf-8?B?NUlmK2lLdjVtdzdGUGp1K0FVYm44MC90MVM4TTFWNW5ObnhPVmhXODRpZjVZ?=
 =?utf-8?B?N1ByVEFWVTYwUm5UVWRXL0Z1M0VUemFJeHlNVDRHdE82WXhHYXhXOFhCTFVN?=
 =?utf-8?B?OG1FQVhKOFgyWkovbTI3RGpoZldWRE1HeUJrK2pONElacy9PemFSTmdIV3JI?=
 =?utf-8?B?SEpIWFFHamIxSEswemZjbmtlSk15Zy95M1BPamFMR0g2U2JDRGdvUU9ndDlB?=
 =?utf-8?B?VTdmR0EzTkVQb2dmeEVsZUx2dFRVTnB5MzlHdWtlSlZGOTVHQlRWUTN4a0dE?=
 =?utf-8?B?RHhKSXBPbUJrTnNpbkZ0ZUdlT09jSFhLd2dlUXgyVjZwamJJRlhlNFh3YmVa?=
 =?utf-8?B?V3BXTUFyYWcrZ3IrdGxOQ1JnQ1VIWTVRcE0xTVhnSHBFcjd4NTBGYi9KdVMz?=
 =?utf-8?B?K1I3S3NseU1aMTZuNmxldDhBQjUzSnZxR1VnR2Q1NUgxZ3hXL09KcXJDb1lM?=
 =?utf-8?B?d05QQ0M4ZWVJSTZOWEdPRU9OZllsTGRyVmFmVFEzR0hXT094TmZnbWt5UVFs?=
 =?utf-8?B?OUZhME4rNWJEdkNlM1FuNjMwT0x0dk9NT3gyMkRzbDVzaUpyUjVvY1MrQ0tM?=
 =?utf-8?B?eHI0SHNMQ1ZoeVVNRSt6bmljMG9FQUlBQnFUdlRta1ZrWEI1ZGxpQ2FJbDJo?=
 =?utf-8?B?SjNtUllJdkRYdjBrU3J2TmZTYTdjQUNXZGUrakNKN1RPRDY4Zk1US1dYWkVl?=
 =?utf-8?B?RElZVytBVFlKaGEycGVyN3BFZE9xeWFJZ2dCN2pKMktycDg4Nm0xSHp1RVVJ?=
 =?utf-8?B?M1JGN0E4MkxYMDR1N01odz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Vy8vNS90VnJnWWVKbjQ0eERTS1BMdUxCazdYM1dyNTZLakY4UFZGNHJQbGJL?=
 =?utf-8?B?V21XQkJydEVLK2hhaitNa0JGelU1cG5xaFZUUGJpYTNraHovbGNWNmNuY05s?=
 =?utf-8?B?U0lPaXBVMEhVbnpvVWUrNXptOU04dnhnQTB0QUgvMjRtVkdWUkErRXUxSjlh?=
 =?utf-8?B?ZXIxcEszQm1DR0VtM0pFQ3RoZ3NFV1FNektnZzI0MjNLL2lSOU1yZEM5c1dI?=
 =?utf-8?B?bzkrdzB2M3dqdUhjbE10UENMU3lrbUtnN2ExQ0NEMUpkSDVSY1A4a3JKODJZ?=
 =?utf-8?B?WGkwWnlCeW1FbkpOVFRDcEJIdjM5RlNLYWhSN0JtMGJUMGlsUEhFeEVBdWQz?=
 =?utf-8?B?YjJjTHpEam1UdFJ4NFlPY3R2OFFTVnQ2Ym5OR0RyVEpYZUt6dGpMb2lrbzk4?=
 =?utf-8?B?eExyMmo0M09QR0hGRzE0VmtxMEhrcDhkdkRWMkFFRDBqYThadTc3ajZiRGNW?=
 =?utf-8?B?SXJFYUd3d3BxVzFabmErNXdRMFdVVnQ3U0h6OGhTZEZMRGIrUnAyRXp0V2Fi?=
 =?utf-8?B?Z2xJc2N1Y3ExeDNsazlKMmlTR3dTWU5JM1FyMlIrblJpVUFtNDZKbUlIUFht?=
 =?utf-8?B?UnJUQVFuNWdLSmFmM09VL3lBYlpJVVhZRGdaNW40RDNxYlFvTm52T2dwS0NN?=
 =?utf-8?B?c0JFVmg1ckhtdjhycFRXb0RRZXBKei84ajMxRE5rQVZQVTZHWmtPNnc1MVlR?=
 =?utf-8?B?VlI4aFlGaVdHQWttMTJLaTllVlB4VENlYWdtQy9RSlJCYzRrQk5udEsrcnJ4?=
 =?utf-8?B?bktlNC81ZXVpellkRWdVeHNiWTlvaDEwa002eFp5aHVkVTl6cmkzNjBVb21t?=
 =?utf-8?B?UEJlWlJMNEw2SnZNanBsMFFRNTFnbHRWeUhxdlA1WTRhaEYxV3dYUTIvSG9Y?=
 =?utf-8?B?OUc4algvNEhZemhDNzd5RUtYQjMyNFd2Sm5UcEViR1VVMmtqaUtkVVlheWlj?=
 =?utf-8?B?VkxUM3lOR1dCR2ZGRWVleGF1OVhQSzZzK3I5Yy9zcG52eDJLYlhzWkIxekNp?=
 =?utf-8?B?SnZUbGF1Tkl4NjhzR01EaHpLbmo3WGtQMzllZGNuczR4dkRzcWFZVStQcUhF?=
 =?utf-8?B?OS81UkE1alVjcytUWDlneWhhM0pHVmUzNzBUVm5SeTBsT2gxTUN4dUVxUjgr?=
 =?utf-8?B?b2pvczQ5eVlCUmxrM1hpYlZDZ0lsdGRSZFdlRndxN3ZOLys1MGp2dHA2ZHM5?=
 =?utf-8?B?YTQyazdpRWlsUzdyWTNpVzhaOGlJaC9mdkRCUGlMQzM0V1dpQjUvaXRiL2Jz?=
 =?utf-8?B?SW1OeHZjNlNIK2JMSWsyTk51UGlaODR1UmtRNW8wUGZoV0lZbTJuYjk4bFRq?=
 =?utf-8?B?QVdGNi8rMXlqWDhUNVNidHdOeC9XRFFUTmswbDg0dTNlbmdlcDhEZS9ITWpB?=
 =?utf-8?B?WDBncWk0eGU2NVNxKzhDb3B6cFcrWUZQNXhoUEphOHhjcFF3b2Y4OGtvZVM2?=
 =?utf-8?B?bGpia3hWY1phN2ZFUkZRRVZmS2o5TUI4b0dxcHlSM3ZrNWVEOTRBdXZTMisw?=
 =?utf-8?B?bVowOGFHQUNJb0lyOW1CakJBbzhkWENHcVVhNXRkZEtvVVI0bTV5QUoxSStQ?=
 =?utf-8?B?T1owdnlrVENTVm95RFdCS3UrU0VycndzZTZzb1FHUVhabnByVUlaM2ZreEFs?=
 =?utf-8?B?Y0JUUXFqOUdkUGNiU1U3ZlJzT0ZkbVd5b3R5YVlqMjVYei9jTkZtc3ZlRkF1?=
 =?utf-8?B?RkxKUVZpcWVVVVYyRnVxb01CdnduUlBKbUFuYUJGZXRKV0lYSzh5enRqV3NO?=
 =?utf-8?B?Q0w4bjF6Z3FRTHNmNG9reXN3d1BqYUs3NUhYRXVVL3BrQ1FaaDVBcU9ML3hG?=
 =?utf-8?B?OUdhQ0Z3eitESXFKWE1JNEgvZ2d6V2dmMUcyRnRjVWdnazB2SjdiNEJqMjZN?=
 =?utf-8?B?dFoyK0JaTG56RzRtai9CS08wWmdPTU9tWXJDWGM5ck4xcEpoT3ZQTkNndElN?=
 =?utf-8?B?bmJmY3N0bnBJU3ZjdnZEblVRQWdBV3diRVBuMVZUakdTb21UYzBYcWVHcHJh?=
 =?utf-8?B?UUUxdExDckJadFlKSW9vcDNpS2lwd1B6UUhIVGU1QjZqSVR4eWxTb21ZTmtP?=
 =?utf-8?B?V0RMWXN3RWVia25adkpnaktnN3Iyc3hsNXN4T3JHTk8rMCs4L2xsa1ExV2t3?=
 =?utf-8?Q?b09DHVM6ngnQC9wK7EKBK7mLJ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a9337ec-5351-42c0-b057-08dcc72cac25
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2024 06:43:06.3445
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: emEJ0dGcpDS6NFKrfUe1miD2Oo9gVAE+s2AD3+Yox4+7z1lvZYuij1RyuQpn/1BsAnbULvjVi63AoXaOwsY+Cw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6344



On 8/21/2024 11:07 PM, Jason Gunthorpe wrote:
> The iommu driver is supposed to provide these ops to its io_pgtable
> implementation so that it can hook the invalidations and do the right
> thing.
> 
> They are called by wrapper functions like io_pgtable_tlb_add_page() etc,
> which the AMD code never calls.
> 
> Instead it directly calls the AMD IOMMU invalidation functions by casting
> to the struct protection_domain. Remove it all.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>


-Vasant

