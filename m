Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2086.outbound.protection.outlook.com [40.107.243.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 255461552FA;
	Wed, 28 Aug 2024 06:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724826405; cv=fail; b=qPcNknarmdvSNw6Wajm2+o5Q515KNVeBBxf/+kgosFBQFbsITFCJ1rW5IPc9/KTZsr+aaDoQsaOSzuApxxqAEkuBU/UyPJBp8Dho2vSZL5FXLYERXEB31TelI3XqbxKSREw/nSauLZX5ydeRRpFiD1z5Fan0kj+EA4Iku79/zU0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724826405; c=relaxed/simple;
	bh=U6B0lSdeaPkxa532al6N0ZiZrwgNqlHDYCF/9QE4EGc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=PyGDN1LhTwkXstGyTjFRVsz4I8yi2z3kG2HiEPXAnbDS8dIL8wAOFuurqZTUBr5iURrfDYB7QveCS0dEXMZHKjiqflv7NoerP7sIzGOqgzd+s7JJYVpVp8WchegFKHlz8OuP8hwCgsyXmP7y/SAb/pvH1rZpaHG/J5zTroZb26A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Fog3f1Ys; arc=fail smtp.client-ip=40.107.243.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Fog3f1Ys"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lvnyUu4qFMfO+KnZNHNpImb/cDvVoN0SZv1GSHyjcpZfOD/Wdxp0DirxUrbEkTrEWx5wzKpqdYuiOvq9vs3Fd81ed8Zm7TQ9kOzm7RsMxr8s7hwTfnVWXRhn7D3jL2MJa9PVJk2kQsZuLUmlLxFKK8DH9nhgRVXZ0iRQzk6mbniw11h0Cc+nN5IGCw8fq5O+P/LYCXCY/ykiVLlgxEGECYPQri+A67l53/CeVEbMeVSBF8T58jJwu/pURSwggmlj5/haZ593A9i5jQOoaiiUfX8xBJ0SbdqI2mJe+OZHS+yBe3mwJlUS87S6XZjs2h0wFj5lHTvuHDnO8IcVVvSUXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RK8tTCdRM2vEmxfQMZzeYhfDRm8KAI3NeE6UzmvZT1w=;
 b=ElXMIwkX9RRwZ0xof4MYsKA+AtiTdD/HsjUe1Bd3Zd+kMSagkfqLhaZ6wu/FczheZLyzn1qD8Nexssj+CUbdDadJXXFBPxZ7feKccDmiOWmxk9wiCB1pTIYRl/HIMtrdAKJaCKax+HBbue25j1Xn6eKqUxa49IG1Shzvu353u9mjsGdTwh7UxUyGpf4dxY0hVA8Rj2zEq7+GhNa0rV9RLoCCAuPJTkqW1Z2MRTHrLv08y2jhJk2130sHM+hRXc+R/neqe/cFlYWEqm/NXfMigFCQ0lDgcGZhFNppQcsNXaJlxBymvwOM2c+CJIvfh9YEPAzbJ8V2vnuw9ht9RK6Snw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RK8tTCdRM2vEmxfQMZzeYhfDRm8KAI3NeE6UzmvZT1w=;
 b=Fog3f1YsUh75ebmoblpL58pcR6ARM6xWc6kI8S0MHm0ohUeZjvhqoZyfm1uP0bCyI7d2DJXNP1RDwNlFQODC4osdXaG5aqmtqiGfMfZR6QDey8Po9qIq856rNdlRWnsfUhm+bTg83DYMJ4lOgs2Uk07wYQcfp16rctH4xEpvZbc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 SJ2PR12MB7989.namprd12.prod.outlook.com (2603:10b6:a03:4c3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.25; Wed, 28 Aug
 2024 06:26:40 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5%5]) with mapi id 15.20.7897.027; Wed, 28 Aug 2024
 06:26:40 +0000
Message-ID: <3895806c-485c-4c8f-aceb-66789a8cb625@amd.com>
Date: Wed, 28 Aug 2024 11:56:32 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/14] iommu/amd: Remove amd_iommu_domain_update() from
 page table freeing
To: Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
 Joao Martins <joao.m.martins@oracle.com>, Joerg Roedel <jroedel@suse.de>,
 patches@lists.linux.dev
References: <4-v1-cdaaddf80abb+14190-amd_iopgtbl_jgg@nvidia.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <4-v1-cdaaddf80abb+14190-amd_iopgtbl_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0201.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:e9::13) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|SJ2PR12MB7989:EE_
X-MS-Office365-Filtering-Correlation-Id: 35948b28-c548-40df-6904-08dcc72a6093
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Zy94VkN5UVozc0JTK3hZYWVEQm4zZzUxVGJVRUZVeEd2bU1LVjdVVzZRdlIy?=
 =?utf-8?B?TEsyS01Ib2ZXTnM0aFc4b1h0cmxVV1dTdlBXZksrVld3VGIweGFGR2twMWFt?=
 =?utf-8?B?RjFKNzEwOHFyQkhWTkRaWG9IbENXTDMxclRGMCsyNFVoSTRRSHByWlhmT0pP?=
 =?utf-8?B?TkUyYzVPK0d3YUpaRzkvRGZhMmkxMmI3S2E4OE9ZTDc4QmQ0TU5UTGVzbkJm?=
 =?utf-8?B?MW5GSWR5T29vWTNkcTZNdS8rZEh5QVpWdFQ5ZUxIU1BuZVZQZ2V5SW91RStB?=
 =?utf-8?B?TUZvRDBWNGJDbWU3cEQ0cFplQ2ZNWW5ZcTBGaHV5T0k3dzQyUld4UGdUU1h4?=
 =?utf-8?B?aFZEemFPTnhYU0djdDFxRmhDV2g3dFdPMU5QUDVwLzlLcmdScS9hS3pUNGlO?=
 =?utf-8?B?cDYvWkVOZWtVeEJnMFBNMStJRzQ1c0pHMnJGR1RkNkNKUmh6MHNXbUo2K1d0?=
 =?utf-8?B?Vk5kTVRwMmp5eGwrWGdUY2FmRnpoMERRbFcyMlFGUzlIU3RYeXIrZzBabGw1?=
 =?utf-8?B?RGJCbGJwUXF2c0NDOC9yMEtUUDVQK21raXJ2bXgyRDNNb2pTMVZ0R2RmaFB4?=
 =?utf-8?B?MFpNeDRvczRYZVQ5VXVsblR4T0doTVVWTGgyYnpUMTE5TjZpT0pQeWdRTVYz?=
 =?utf-8?B?Z2VJQzRML1R2WXBNYkUwVkdWYWZFTVlGUlJWQWVHckw0elZlQXNhenVPM1cx?=
 =?utf-8?B?b1JBZHhmYkk1WVlUR3AyeDJnaWoxK0ZUK00yWEtNRVNqbEwvbit5a2tLMWhw?=
 =?utf-8?B?ekk1eW5wSGg4d1lLL3BldEdyT1N3dWxvYWxQTFdRY0tCZnkxaFlxL09KcjJu?=
 =?utf-8?B?UVFhMHhxNUxjRkFHcytyTXllOHdoUEw5eUNldTdOT1NBSldYV1ZhT2t4bVhn?=
 =?utf-8?B?TjQ3NWliVE9zbG1uQ1VaVWtRRSt3Y3hOTWFLT05hYmlTWFN1Uk05YTZ3cThK?=
 =?utf-8?B?UCtaQlJlYmVIRmgyeFhxRTQ4K0xOWEhoNG1hYzN0R0Z4dlNkZ1grclZyb3pF?=
 =?utf-8?B?bUZQMHBFV1VOUFNqaUtYVkIwdWJQN1JmR2dwbGRnemlKVEMzZWM1Q1Rpd2M1?=
 =?utf-8?B?ZzI1MmRjWTZQY2lKNkRVTVVaOENselVvRTBnWFBGM2J2YjNqOHowM014VnVh?=
 =?utf-8?B?ZDhCbVJpcVZmYTYwcDNiMTRiVkg2VHI3WlNIa1B0anlLWWxCdHJKUHhMNkFB?=
 =?utf-8?B?K3dPL2M4MUYyQVpENXh3N3dIeVZiVjVWU3NMSm1vZG8vaWZqUWN2cHdOVGNq?=
 =?utf-8?B?WFpnRUNncjJiWmh3cFprcXU0MmxOSEZBajhZZXhNMVlRMjFQQVd1NVgvc0Vi?=
 =?utf-8?B?bEFoMHA5Rmh2Tm9GWkxGZW1ram1PVk9WWDY3QXRrM0ZVSTBvbVF3TFZtTVpz?=
 =?utf-8?B?Njlaa1NiZ2FzZWptRUY0M2V6ZmhXTHM0MVRaby9KZElEdHFERk9ncTRTMENF?=
 =?utf-8?B?Y2RtQjR5U1ZHcXhvaFRMUStwTkJMZU1uMElPSDI3aEtsNDdTZHI2QnZiUUZH?=
 =?utf-8?B?UHFoU3h5OTAwSkt6V3QrMWdaaXo5TmVXZTFPMlZpL2w4UXBWelBtd0d3UUQ0?=
 =?utf-8?B?WnVWMDZwNTNEcHo0MWF6SFBkL01sUk14ajhwZ1JydlU5Y3RReWttTndHS0RR?=
 =?utf-8?B?ZGIzc3ZQUCszTnZ4UkRZUHM0TTdkak4vNWE4UVhjQlQ2VmdkN0JEc3BkTUpp?=
 =?utf-8?B?SVhuV3dldjZQOUdyR09xN0xqaUZsS2RiVVBnenlQTHVEZ05UVThlREhiTHJy?=
 =?utf-8?B?a0JtZU9kbVcxdnVNcnlDV3EzTFg5K3BCVjFWR25ySm9rVW41UnJUZXowcUVV?=
 =?utf-8?B?b2IrUHhLTWx3WldSQUFaZz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SXpPZFNXU3djazNEZ3plcFFOZXZJTzJRdjVOL1UyME1KYWZ5SkEydzI2cE96?=
 =?utf-8?B?alU5dE0wWTZlYlpBL3hQbklqQW5sb0R2Y1JDVFlxbG1iUVZocmVuZjh4SXlG?=
 =?utf-8?B?RmpvNnFhQXk0UjFtY3VYNXpiMHNhNXF0U1U3Mi9hSkp1VWwzNzhObTBYdFdh?=
 =?utf-8?B?Wkh3MjRMK0JqeSs4THFWR0Zsd1hqTXNTK2lXNncrSVJrNFpzdFB0NWhxSnd0?=
 =?utf-8?B?UVErUjhYaEFyYWVUcmcwaDNVM2FYS1VhWnAxdUtJZ1l4QkphaHVncW5nYmZN?=
 =?utf-8?B?NVEvbUFxS3FYSGR2L2dMVXJ4NTZBa1ZEcGROL2poSWYwRXJBQUw1empNMThv?=
 =?utf-8?B?OUNicHo4MlJKbldqUkZVRENoNTIxV2ZVdGFpZllLODZFUExLY1FIUHJEdk1T?=
 =?utf-8?B?Tkw3dUJBWTZpZmQxRU1lT2oxSEF5Mkw5MDVSaldHZTlXczVjaHJRVmNZeStF?=
 =?utf-8?B?TEphZUgza3VnQ2FCU3pSZTk0SFY2QmlPOEJxeHZCdHRjVDhHQUk0SHdoVlBj?=
 =?utf-8?B?bFlzTDQwZWZJMWF0QjFROWlaOXNLVitRLzhyUk1UMmJWOE9saS90cW83OG9G?=
 =?utf-8?B?S0lLUnBzTGl3ZHRNbnJIYWxvNmsvcU9rM1ZPQ2tWclp4VHVvcTAzeVRUbDI5?=
 =?utf-8?B?RTVJNkZ6WGEvdWtQczZOb05kTmM1RXdSYUY1YmpyQTNtUEc2UTdxR1d0VFV1?=
 =?utf-8?B?eFcrZnBJdmFkT0ZuNm8wbU04bUtCaVZZeUhJVjA2TUxHMkRtR29qQ2daZXUr?=
 =?utf-8?B?bGkxSlhBTTZ5eSs1aDIyQkkxY2c3MS9vb3VRM0oyVFZmT01iTVhEYVFTcEJy?=
 =?utf-8?B?N01HMlNLaGpYUjl1ZTMxZEVYWW9JWEUveldNVnMyeGFjVkJrNG1aclFuN1VE?=
 =?utf-8?B?SHNZYjIrRFgreHJnYWUxa3lxYTFMMzE0am9mU1QyWWIxU1hsUE44QXU4b2FT?=
 =?utf-8?B?Z3dHZlVSZ09xU3M1MEMvaW9iMUR4bkgrVHV4MVYwNDNrT01BTjFIL2IzMTVV?=
 =?utf-8?B?eXZ5ejZqYU1kTGVmRTd4MUc5RFQ0M01DNGZYazl2ZjVMMVFpY1poblJuQ254?=
 =?utf-8?B?V3FZYjdmU0RvS3dhcE9EZGc0NG9mQTFGaXJ4SWVRV0JSd0doNVpGNFJFRTI1?=
 =?utf-8?B?NCtPeVdENk5LcVE3dUJ3UWV1bHdtTnMveXBPWDZUM2RXc3l6dFhaUTFVOS8v?=
 =?utf-8?B?VWxSbk5pZEwvWHdBeDZ6MmtPNG10dVRIdnlCbkoxekV4bXpXbFJ4R3JFY2dO?=
 =?utf-8?B?QjZCQ1Z6anhWbFlQZ29qVzlnYmdLWTYxVGUwWHMxbmtmdk0wL2FmTkJ0azBP?=
 =?utf-8?B?MUdtSlRCN0Z6TWxkaDBZd0V3YjNTcmpDd2Q2dnVyVTRvVWNORGZLSmttQ213?=
 =?utf-8?B?SG1nM2lWdWJjWjdJeEtDZnFXQ0tUN0J6eDlLY090Mmczc1QrNGRISy83V2Zs?=
 =?utf-8?B?OGlPN0hldDZicjlRUm5HeVlzOHVWcXlJMURWL0QvcmlrMUMyTHJ0SDVVaGNm?=
 =?utf-8?B?dmFoUDMyVElyLzdCTlZjVVMvb0xtTHJNSUdKdm0ySHNhcEVYNnAvSFJ5MnZO?=
 =?utf-8?B?bDNtbjRrdGVpdU1RUGNiMlVoN1dwU1htcW5TWHlMTUt0Z0FDbitLaWJBczhN?=
 =?utf-8?B?NzNxeFZhcEk0QXFFRktPcVppa21MNjdjazJSVHJ4SGVlcHF0L1lPeDBSQmdy?=
 =?utf-8?B?T04yT0RESWd1MDlCM0hnbStUakk4aGo0L2ZGNmVFZjBBc0dza3RDOVl4ZDY5?=
 =?utf-8?B?RHFLNUdPLzFxbnFxL2JKMDh2RTdKNXBsSVB4NUFYYUlubHFRWFBsNEpTNXVI?=
 =?utf-8?B?T3NmM1hVWjNDbmVVUE9xd2FWMTBZUXhHSUNubUsxdkNsRVI1cWcxSnpSVVNr?=
 =?utf-8?B?NDZ1ZFh6NnhCSFZtK3NaTndDMGt1Q0VVUGxmalFUazJWRC9vTG5xNWtHQ2Ux?=
 =?utf-8?B?MlJZdlZKZUhleStSL29iN1NLSEhiV29DWXJ1NnVNRWRTZEg4cHRHSHRLSlpa?=
 =?utf-8?B?NUh6YWhkbjhxTVRFLy85djZJak5vZmJmV3ZsV3VOeENoRlp2bHVCV0daeXBJ?=
 =?utf-8?B?RE9LTG5xakFldGdSWjVEMDVpbzZNb1owQUhjZXVyVXlyQzU1YXJMbE4vc2h6?=
 =?utf-8?Q?FVzBgmbYtG2EUwOXVqInvFCFO?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35948b28-c548-40df-6904-08dcc72a6093
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2024 06:26:40.5868
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DY+gqVdqhmjzXp6udrNZ5VHpFlyhTIf2B9DcwKrpuTLqJ7dRo66lWWsrSK2NjlYGGPDkXkFcZJUEbCIlTdbtWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7989



On 8/21/2024 11:07 PM, Jason Gunthorpe wrote:
> It is a serious bug if the domain is still mapped to any DTEs when it is
> freed as we immediately start freeing page table memory, so any remaining
> HW touch will UAF.
> 
> If it is not mapped then dev_list is empty and amd_iommu_domain_update()
> does nothing.
> 
> Remove it and add a WARN_ON() to catch this class of bug.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>


Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>


-Vasant

