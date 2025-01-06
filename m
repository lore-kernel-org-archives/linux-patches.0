Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2065.outbound.protection.outlook.com [40.107.237.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B28A02CA8;
	Mon,  6 Jan 2025 11:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736161796; cv=fail; b=OeGJhqvmF8hV6r0oZbVutGX/6KCFr4E53IKTCe0+S4ohvzcBR5pkS8Ephr6e5kr5ySh8KdhovYpcPuw7AHnRT5pEDJEO8UX1wwRR7IZ2tafJdCfAz2fYdTVKPSCdwF0B+oiNMrKC/mTAV9Fd7qEmauWzci1lheoKZcw1xzbRKmQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736161796; c=relaxed/simple;
	bh=k7qKlKTQs2EwAJ2bQClz0DzwVN3cU7zr2fD1c0W12Sc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=mwvcFN/CGDGH7bKYCkkY6BhIMcRQuxIWttYSzAjVeUwJYEYFEnya2pbscsUJqPusTfPwa7zTSxb6gAuP7LKzM9zmCe3YPBJkuBXMtRKGTfYUR/c5vvtNxZeoc1IwQfp2NRMyPJiLej57tXx98UQZHqKNRDKn0xJI1Lk9XgN3TDQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=EQRv03KM; arc=fail smtp.client-ip=40.107.237.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="EQRv03KM"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V1sijoh1FiEom0X0xUyZVwfz8h//0E9YOdJ+UieUyzhyo9YelihPBCVv0mGxvAOzsbRv2SdpoTwE20UdXiiBkbcPARb6MECwx8isXNJsXxUqwd615Fp7hN42WAsTLe3aMrNQSNgJdKzbRvc3LJEW0/KVyDftMV6OGtPRD5qtE/994y7UnFaenmUvQGBmtQHTmwezw3WtXqnTdyoqyxEkfTueUF7HkfUpbO5VjVVSQmhW3WhI4HWmdZsD0XwEBuZ2wZZXNc61xGIFMiM5hgD+PqWlGh4t8SHUZm+hxhfaMug3Lro27+aTQj2Dm5/3T8aKKHK7Zr2Xf7+RBBhgEHqXfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oEie1xwLdYWROqlg7JFwQ6pjQarYy20G9MDPCQstlR0=;
 b=ov2jzHH4JmpprRJdv50Ovc/B8lSAJctUCl1fpjQnQr/0D3kIkOMS64+ZPdv+avKsS5mcsLqY/LTXZJUSf5f88k8foqhAYV1zAPfw9OmSYFnmu8sCTx4hLL8PKHHSieXdLgpMNzjOJwdxQ+hVoI3EOI5rSG/t/tDAcuZJTzhQ0CTM4fgK4ucG+WDhu18kOP7iq9pqE1xvUVVccgyZ032JJqG4VjcUYrly8UrCdDdR8S62UUDkgR52PYFweDY6wczc467aH9j6HdaUwPb3aldWvPO2XfUZBBBB2zc3mhHQuGUm/XGOOZueGaV1Fjo1gENPVvSuwRdvwsnJoIZ0s1EhgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oEie1xwLdYWROqlg7JFwQ6pjQarYy20G9MDPCQstlR0=;
 b=EQRv03KMTptT6QA/8sBtFfaDbHs8fzBCF/miho6HPeGpzig0Pa9V+d4IaGTgDPDixkSRrOQret98qq+oesDmexFMoOjlOT2XT9ku1yrbiEWYvY13Jh6ydyAtmx6FlE/10m/7Zlr3dGo6CDIgcU9UUlvOZiD7d14OlKpqESt8rHs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 SJ0PR12MB7458.namprd12.prod.outlook.com (2603:10b6:a03:48d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.17; Mon, 6 Jan
 2025 11:09:48 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5%5]) with mapi id 15.20.8314.015; Mon, 6 Jan 2025
 11:09:48 +0000
Message-ID: <3cb58a5b-a42d-4064-8c98-8f99b5794fcb@amd.com>
Date: Mon, 6 Jan 2025 16:39:38 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/7] iommu/amd: Remove unused amd_iommu_domain_update()
To: Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
 Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
 patches@lists.linux.dev
References: <1-v1-cf88773f22d1+39bd-amd_paging_flags_jgg@nvidia.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <1-v1-cf88773f22d1+39bd-amd_paging_flags_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BMXP287CA0013.INDP287.PROD.OUTLOOK.COM
 (2603:1096:b00:2c::35) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|SJ0PR12MB7458:EE_
X-MS-Office365-Filtering-Correlation-Id: 71d3ba9d-a4f8-4451-dfd3-08dd2e42a1a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZGQyVXljTDUzb2xUdFBRM1VVZzVxd0hCRnZXYWlEbGozVVhHbkJEZ2lYbHI4?=
 =?utf-8?B?V1FsZVZpbm5Sak9nYjN3QzZlUVhBV3pBZ0R1NXJqUnpDeUpoNjZDYk1JMEt2?=
 =?utf-8?B?SnlBVmdETmdhT3Vob1Q1RWRLTURCbllOVXpsYm9vRkNTbUNqV0FUR1ZmSmVH?=
 =?utf-8?B?QU5zZ1Y4dkRaMHdrOE52UXM2WGEyckt0UWJReFRqVUFZZDkzcVh5ZWFzRnlk?=
 =?utf-8?B?TC9ua1ppMGJWejZNMnNGNmlWbXNmYmxNME85TnpWaHJDS0h2bkU4SFVrM2to?=
 =?utf-8?B?Yi9ucnljbGJ5cWFrTE84LzZhTEV0UmpsblFIK1hQS0tGK1UycDBFV2QzczhD?=
 =?utf-8?B?bjdrcExaN3g5bVZ1ZG56Y1dMN052ekpMSEVsRjM2aVVCaGhaQ2RJTHJjRG1U?=
 =?utf-8?B?WkJuUHhQTmgvalE3aUF2TVFOUWJ5RitLNWYwZW9iU3EzcWRjem12VUdiWndv?=
 =?utf-8?B?OE5NbXdJREdzMkdVcnpOL2tXVzNZM1Y3NXFaVWMwZnhnM3ArNC8xMXNQUnkz?=
 =?utf-8?B?VU03OWFRYkU2OUtFLy8ycnZtYUJUWUhLK2l1SHZOSjhNSFMydHhoSVlBQWNm?=
 =?utf-8?B?YXJzcXRTc2E3SnByR09TNVpLNDhKd1lRLzhGL2srVi9qZjBzd2ZpRFBrTjdY?=
 =?utf-8?B?QVRLc2RvNEJTM0dORG04bW0vSnBreGZRRy9ENE5WSmYyeFA0RU9RVWlVdHpy?=
 =?utf-8?B?bU1JODl6NkVqSldndERVbFpjbFRPTEFqRlFKSjdZa3RWYUpGaHlQaDRSYjRm?=
 =?utf-8?B?NnB2SE55Z05LSy9OaEs5RS9WMFl2UUw1QXE4V0d1UXo1NEQ0U0Urc28rQTha?=
 =?utf-8?B?bjA0aEk1RUtrQzdBQWx6ZFE4MGhSeXlDVUR1UGN2eFVnYlNoMG01dHAxckJH?=
 =?utf-8?B?VzMyMG1XbjhPc2NRU0lJQjRIbzExRk5hVG8xRlpxNWNsTVVVcVM5Y3dITi90?=
 =?utf-8?B?TFcyZDZiT1dobEg1V3NwdGxmeGFYZ3NCcHU5YnVmTUxaU2dSK0FHM1drakFF?=
 =?utf-8?B?Y2FlMERwdFVIOVVQdExyTnVHUkptY0s1SUJKN1FQR0lOSDFIL3liUC9EM01p?=
 =?utf-8?B?eUxWTTlMOE1KUjdFWERONDFWUnFOMGl6OFNqZ2txTXhleW9nVFZVNU9Hbm9H?=
 =?utf-8?B?b25iaFVhUXhsM2FXWks1UmdKMFMwUUFCdnNGdXhhd2pBTFYveUR3cDNQSHR6?=
 =?utf-8?B?a3R6RlFKSXVCaXhPRzVFS3ZFVEx2Y3N1eUUyUWNhaU5nUG0xRElUUmxBRDZO?=
 =?utf-8?B?WVlYNkx5WUxvSUxFSXBKUFhNUnNTbm9mNjlRbUFGYkVWMHgzWnpNdjkwUzVU?=
 =?utf-8?B?V0tFS3BYeE1mcjdPT2NEZGZ2V3lnRzljSGVocmVsNThSRXJ2NjgzSGZvSVpN?=
 =?utf-8?B?bjVvU1g2VnB1WExxUDk1dFR2ZzFHc1RNRXBBY1Q2S29IR3ozMTlIZDlnQXBQ?=
 =?utf-8?B?U1ZSN0xnMGFQL1FzMnJBdnErTHpXaFFxZjA5SkJneXVCdzduWGNMcDYyMTRr?=
 =?utf-8?B?UDI5ZnhBZURyY25WdUo1cS8zTVdjZCtzcWszSUVUdEJqTlZVT3FydHhjTHFU?=
 =?utf-8?B?THJQamZiMmR4eDNuajkzSE5ldkV4ZG5jSnJaS1JvcHN4QVdxbjVpOTA0TVdo?=
 =?utf-8?B?bjBtcmdrU3F1ZjhkWHd3R0wxVGxzUUJJTVJscnpuOEN6VkpFd2Jyclozbkw0?=
 =?utf-8?B?M1N4aUUrcEYzVkNiMXFXSlBYNzJIamc0TDVJYWV2ZFJLWHhjOFc3YmRFaEhs?=
 =?utf-8?B?TUIxMlZvVlpxc1dTQms0Ymo3bU1PTU5tVjNlVGJNSmVSS3Y5R1lRRmhOZlo5?=
 =?utf-8?B?WjNPa3N0K0lacFN2eDlTK1g0S1dOMHE4eGI4eXBTWUlGUmlZT1BXbU9OeU42?=
 =?utf-8?Q?ngTBmizNWJDbR?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TC82dmE1N2VwK01LbXdEUHRBRlFWYUFpUDlZbmVKWFdIL0pXWUkybEZwVTMv?=
 =?utf-8?B?TG82WkhLWVZqeTJ2YThFTDgrcThvWkxyaitlWUp3MjhHQUt3WXhBaDdzOWVC?=
 =?utf-8?B?Z05FV3lWeFVkZ3Z2RWY4ZnJPdk5XQ0xKL2szU0t0T0YzaFZPOExlbjF4VVNr?=
 =?utf-8?B?RHBKUEZrd0pDcUkwbFFhU3VTc1AwTXZXYnVSQ050UlZpZ0hUYkxZZDVIclVJ?=
 =?utf-8?B?SklML1BTdGFZUVFCVS9GUGQvbGJvenhKaHprTlcrRkc5dWhhK3hQRnNwbXFx?=
 =?utf-8?B?L2hMeTA0WEIwSHljOFFNcTFSN1c2QmFSQlRyU3M0cER2aXRqdy9kbk5Hcjhi?=
 =?utf-8?B?SXhGZlROZGFxOTJwZjNPdmRRWi8wdHd6ZTV3RkIwdGtGVVR3NlYrU3RUanho?=
 =?utf-8?B?eEJwdE9yNzhzblEyZUNPYWM3QVdkQ0NZaWJzeDFEU2hoUDFTNkhPRDFIN0hw?=
 =?utf-8?B?TGhNSkF5UERlMFhKUGZ6d1hmS0swc0Y5VFZ6Y2tJam96S2JwUkptVGFVcVFC?=
 =?utf-8?B?TVZ6dlEwWjRSckJCbVc1cno0VTlEbm1Ld0hnOHlVUUplYlpsUFBuT0JTdkNJ?=
 =?utf-8?B?RE9iaUJOQ0R0RlZnZjlUcExiSnlPOGtjNk9iNk9Cbk9WZEpCSk9sVXM3MVdO?=
 =?utf-8?B?TG9sbk9MV0xrNXJXR2oyY3RVejY2VDl2NjFRaldraXIrdlR2T09oR3VKRmJn?=
 =?utf-8?B?c1RYeC9GbkkrMUJRb0VMUjNrbkZFYnlzQTNzc0lXWmYwVmkrQzBSaEM4U1RD?=
 =?utf-8?B?ZlRIc3BIajVLdFFwWXg5KzBMV3lPSTZyS2FnUW5FTTQ5L3VleGJob2orcHhI?=
 =?utf-8?B?TjE0dFdRcFZSYkQxVnJtK0E5bVlkZFEyQ1BtMUI5Q3VBRC9KMytXZm8wS3dJ?=
 =?utf-8?B?dTFkMDgvcXhHWlVVYkcySkw4d05YV296cGRoK1dhV1FiVmcwRkV4YUgxTE5w?=
 =?utf-8?B?Rm5mTlZ5UFc5N1I2TmVqd3k1TDc2dTBVR21Dbm5ia3h5aFliUDQ3MXplVVV5?=
 =?utf-8?B?cEpIa04wcXhPeFRSbFBEUHppbGRYcGtodytIOGtqMXJsTExweEpJRkwwYmR5?=
 =?utf-8?B?UXE2NVBlSUtKRlByTWEyS2lxRG5QN0lzWVhrQmxIaHVXOWlmTVE0UGR5R2sv?=
 =?utf-8?B?c1Evb3ZqRTVsUHJFeFZSQWhVcCswSmhYSERTRTBTNHMrYWtuRkZobzlTS3Zp?=
 =?utf-8?B?R0pvZmx5eitrNVgrZnRYTTZmdkVxTkZGejJRTHJpcFBZWjhrQytSc0l3M0h6?=
 =?utf-8?B?dDZpNmpabUdITjlWTi9tdEhuNWJMbG41SGJHR1djVHllUUk3aWlaZVVISlR0?=
 =?utf-8?B?NlZ2QWJtT3NDNFd6R1hwRDQ3TnMweXJPWmw1THhPdWkydG5rNUNXL1Fnc2ty?=
 =?utf-8?B?aDRwTDRmT05TOC9Sb2VYeWxnSFdHUS92N1RYV1EwWXh4RGNlckxFUkdGVS9Q?=
 =?utf-8?B?OWxLbU5uK1JwSDZybFRvVzlPL01JZlYxQkVXMzBrV1VoR28yN3B3U3A1UlFu?=
 =?utf-8?B?ejFsMnMxNU1GNEVWeTZGanJaWUUwTEdDa21Ma01GNlNQemkyYnlscXdvcE5s?=
 =?utf-8?B?alpYa3dNTjlGMjUrZHVuUm9OcmNWZHk4bWsvZFg4VHZ3eHdxeWlaSllWY3VD?=
 =?utf-8?B?REptK2RiWVBJMkhZUENJd0xRUFR4eHgwZ1FRSlJXekV3QkpYNFoya1hYVE1G?=
 =?utf-8?B?eE4zWG4yZzlCcG5QazFmSU5RSURSTThPZkt1R1p1eXlPUy84eTZZckE5KzZC?=
 =?utf-8?B?aDZPTVp3UnlsK3NENThlRk1XK0E2OHpMMk1aOVpzWHBSd2Q2dDdBeVozQitV?=
 =?utf-8?B?ZFJBbkVHRkl5bW1rWk5Mcjl1UUxnVWF0NmR3QXlFamFXZTRLZUhlbXVoWWZW?=
 =?utf-8?B?VUExZzZhSGZLdzlvckdONENGS05ES3BoS21jWTVTd1o2SkNVQm5NTFJ6bEMz?=
 =?utf-8?B?SE1jNVdodS85WDFMVEVPakw3bkM5eDd2azVtc3RuTGVUMVZzUlBTWWZpVStR?=
 =?utf-8?B?SVorOUhXQmNoYUNhS2pjZ05MaVJmbGRhNTZWbk9WY0Yxb1lOQllOaUJhRTM0?=
 =?utf-8?B?bkJVSnNwRDNyc2N4N1gzV3VheTduVHBJVzJiaXFXakg4RGRoRFVNSVpWTWJi?=
 =?utf-8?Q?JwC9vIAgvQ4DwcVcpZLs6h7qq?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71d3ba9d-a4f8-4451-dfd3-08dd2e42a1a7
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2025 11:09:48.0124
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LFmOKXb0X4EQDmBFKFUYHqJN+Lp/bFHgt0lfW7i4DZ3xUsBCpL4Yt3zbkbApiwr2UxT3etJEPcqnjfoHKsUF+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7458



On 12/6/2024 5:53 AM, Jason Gunthorpe wrote:
> From: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
> 
> All the callers have been removed by the below commit, remove the
> implementation and prototypes.
> 
> Fixes: 322d889ae7d3 ("iommu/amd: Remove amd_iommu_domain_update() from page table freeing")
> Signed-off-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Thanks Alejandro.

Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>

-Vasant

