Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2079.outbound.protection.outlook.com [40.107.96.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E321914E2C0;
	Wed, 28 Aug 2024 06:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724827189; cv=fail; b=cYT8T6FGUGGyhhlN5bw10PCgGBTNTfY+O8PnmLYGo37b5uAN/iu3May7d5O9zzQpYjassk3ouUCB4ep4MPgNfzpb6HHx0t82iLVGW+VpH7lc4XoSw8kiehPXj7uxusDez4oik6l3Hyg8I0PI1Q9iTR8S2rRNYCsvqZjdqhLvuuc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724827189; c=relaxed/simple;
	bh=I40BUU2yhGcx0uQf5mvYPScxtOCEymyIqhofuG5vDIY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sc4DVfSpy3N3oic3fHfQ/0fdSFvIXAbm/k+mE3GEtorNRySc6Zo/EXicS3iGaZvAicPClaBhbcPUzuzfXr+4a/8tU7XGxFIBGANiEhJGDhLPAK+jNuoHEMJBdHR5E6uqlbr0tGH+/EgN7gbHoE/E1yAVWBGfoGt9u4L+UixxAGI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=M4nUD3Y7; arc=fail smtp.client-ip=40.107.96.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="M4nUD3Y7"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jXAru+ZKcZJnLkArBXH+2N/Y2W6WbmQV5IP9u1USGBqPuojNfjTkwhO5yEMVUtDw/iBHgez8GuR23lCV1nZbn2UFc99pM0tC/V9Osg8o6bZHKxVku5CmqMxxhkDt400UUs17h0qxsqVwSY9lmA2LZ+DtaBskKh4f86fEV5a5EkOmpJzodkv88lQet5lgZXfl3nu2WL9PAb/5NbeeL12dv7VVoVzRe+ivcQWTACHbuiu0Uhxk43TtlOuiL4Eud6bM3zUOWxqomJqVxU6RP0H8kUcpmSEYMMY7mrsj73ByLUkWYO0Jh8+NoccX6f3BMeBQb8zPZOoaLN8Vh0ivL/j5MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=afYoYKUewmdg4oDIFPE2/lyino7Hg9iiCayrlOaR4jg=;
 b=elrzsd0MzXZTSV8xw08s8xI9Hc/33gG2jmfcbe0tL7DuMRBLGgmpPBloeQLiUCLw6tgr42QvDLOcWY4pdD1HR8Es51iOLadVBds7LnkQh4iX+r1faW9shvI+M8Ga8Gol3w9iKCPA49Oq7q2f8FDjF6cqlR/3BeMERmFlal7ImVmuvEvb2dl6IHjMtGZSzVEJ5SgUGQ9bFT5PVXJBsp5Ds2WijUCkFKWNGyR1Om2+RSW/vwpXa2oCnj3lmnTTDMOiZMu/pceZeRG1SNm8BCf/NEuaeohursgeCR3E1ZlAEMGM8ggLVFZCp7+h8LcbsWDcd1VmReXD59halVU1oUvUlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=afYoYKUewmdg4oDIFPE2/lyino7Hg9iiCayrlOaR4jg=;
 b=M4nUD3Y7SLBLgxkYi7uytJDi4xf646GXNL5zLOv8StxD922wqQba0UL5zJh1Tq/BthYSVuKToDCkg+OAeTfOQWWx4jpwKRR+l+KeMsA4SlpjbIF7rF7skoi185i2GeyU7flYBakc9I7BzFKGSJFG5+HNyP0L4/DjC+RtpHwKk/U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 DS0PR12MB6392.namprd12.prod.outlook.com (2603:10b6:8:cc::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7897.26; Wed, 28 Aug 2024 06:39:45 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5%5]) with mapi id 15.20.7897.027; Wed, 28 Aug 2024
 06:39:45 +0000
Message-ID: <c17a8c1a-f827-4337-9d8d-08572c79fff2@amd.com>
Date: Wed, 28 Aug 2024 12:09:36 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/14] iommu/amd: Fix typo of , instead of ;
To: Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
 Joao Martins <joao.m.martins@oracle.com>, Joerg Roedel <jroedel@suse.de>,
 patches@lists.linux.dev
References: <11-v1-cdaaddf80abb+14190-amd_iopgtbl_jgg@nvidia.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <11-v1-cdaaddf80abb+14190-amd_iopgtbl_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0009.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:25::14) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|DS0PR12MB6392:EE_
X-MS-Office365-Filtering-Correlation-Id: ef950bc8-666a-409f-be63-08dcc72c344c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NENaWmI1L2Z5ZS9MRzEyK2Rpa0RNc0pRbnpZcFZrNGg5bVRMK2hQdjEzLzdS?=
 =?utf-8?B?YnhBSU56cFhEUUJBRHVYeTdkMzFDM2FDTmdzUGh2SGFIaE5ORzExQWU0V2VP?=
 =?utf-8?B?cXE4Yjd3dnRSTHYvNUtFaldnRW9oQXBVR3Q2M3J2aCt1M2lNUFlVaDdZb0Y3?=
 =?utf-8?B?WmhjdnNLOEpRdGVsbG1MMTdRWUxST0svTDBWempwaUkrZnB3cjYxZnVMTEl1?=
 =?utf-8?B?clV2MDlUbWFOaGV0ZkZlSjBPMDJ4TE1zeXpEUGZ5T2I2WWRXT3orWFBjKytN?=
 =?utf-8?B?endBMTV0TU5GRSs0Y3A3Sm9YWk1aQ0lWQzB5bjZiQVFWazh6RTIvQ3ZEVnNr?=
 =?utf-8?B?Q21EbFE2eS9xQXAwVE9IUDM5TVRSeWN0TVJLTHRWbVVtUCtMeFNYSWFzR3lB?=
 =?utf-8?B?MjhnQXY0SjhsN2ozNXR5NGtPWnN1aUdid0VsbEs3WnkzQWt6b25lSDh2ZVVG?=
 =?utf-8?B?emwxZUhTSWZVSlJPN3F5STl2Qjloa0dNR1FiS3NpTXpmNWwvNEJuZEs0c2hX?=
 =?utf-8?B?VEtMb1RLQkJSenFGd3FIUUZlNHNzWG5EMUtuMEQybWxMOHc3YUF6eDE5Mzd3?=
 =?utf-8?B?MUF2OU5Ua1lJN0crajNrSE1aNkU3TDJLUXRoRlNTbVlEM2Zrc0JUcTcrUjVB?=
 =?utf-8?B?Z0p4TDU3dHV2dzBhbGxHT096SUtxVmdaR2pQSjdaRkNGdE42ZEJ0VDVCanhk?=
 =?utf-8?B?UkhBYU93NTQzcU9WbU50d3MxWkxxbU1tU3dqZ0NPSTl3RFFNNlRYYnhCMHdq?=
 =?utf-8?B?OVhqdFhMUHlyZUwySUQ0UDh0Y3dqb0FTaGtGVXNzZzI4UFpMNHVsUU1wSzls?=
 =?utf-8?B?S3VCN1F6KzVSYVFQVXg3eFF6UkNOU2FVeWNSdDFlR0pDb1luV1o1Wkd0OGpG?=
 =?utf-8?B?Rng4R3M0eTYwdWlvUnNQQUNoMUtZdWZzZWJDMVJqaXI5ZlJ6cnVoeFpYWjNN?=
 =?utf-8?B?bkRtTGh5SHUvSTJac2FyMmlmVU16c0VCLzN6YWIzVUs2elhzUTNtcjI0bnZP?=
 =?utf-8?B?OWpMT3lvajBkRmhJaVFnamNiSU1OWHBVUUlXT25jVUIway8rZVdqaVVJWjhE?=
 =?utf-8?B?dkppbUg4c0NxbnRtTGlad0hVWjByZWFDWU8rYzRHQUJFS3U0NEdncmdSay9O?=
 =?utf-8?B?aXVnV2QzbnNWRk9VdS9qanV0eTZ6RS9XcVkyVkNJeGtnV2ZRWHBEMWxWa2Ez?=
 =?utf-8?B?WGRtM0Y2dXFHazRPZ0pKWFk2UVdVQW1WUnhSU2kwSFNKcTZHZ2FmcnZDdk1a?=
 =?utf-8?B?N3N1NXd5RndIeS9FRk9lRjIyRUUxT1djbnYzN2V6Q2QzTWNNWXZMb1BoOHFr?=
 =?utf-8?B?a1hrZkw5NEJ0V2l4Q2hoOG11TUlMdlJ1L0J1ZTU4U2M4VE1TT2dTY2t5a3Q1?=
 =?utf-8?B?cnVHMThYbitISWpwdGpBcEh3MFNONENYWjlzY0F5RXIxcUhzSjE1L3lGUk9E?=
 =?utf-8?B?NjNyekU2KzB5dHJ4aWluaGdxSWtNb2h6VVdQL2tyUmhZK0NySGtpQkJzK1h0?=
 =?utf-8?B?aGd6ZWlFRHhWY0psUFd2ekdueGZ0TjhWdkNTZXg2NDNQUVp1bFlUOS9MbDJo?=
 =?utf-8?B?VXAzUjJHcTErZ3dna1A0VTloY3p1amIrWXZkVXFRWWxJMWJUeXJvOVhqS2Vp?=
 =?utf-8?B?dnNvK2JXbDdaa3I2aFFSdDFmZHNOeDBralRybEF4aXZ5UXBaeFV1bVB1Z2ti?=
 =?utf-8?B?UEdWT0RTMlZUcHRZY1FMYTljM3V6VFg0VUtBVXhOakgrMGN3ZHkwaHdVYnZh?=
 =?utf-8?B?Y1RvUW8wTGlRaEhDRmRWSzE3THh1c0toTFNyK1ZEaElZN3BMbWJ6VFF3dWt0?=
 =?utf-8?B?MDdoamJVZVY2NEtpVW85UT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Skd5WFVTOTBPTXBkZHVWMmhYeG01NHNCUEptNFphSEdEd01ZTEQ1MjFPbG8x?=
 =?utf-8?B?Zm5sTjZwb3k0SDlJSUFzZWRSeUkvR0ZodE8yN2U2alFwbGpFY1dwV2NPbkpn?=
 =?utf-8?B?dWtKOU1seE40cUdoL2NXUWZXWWZtSzdpZG92S002bm9ZUlVkUEYxOEdkYzZN?=
 =?utf-8?B?dnJ2dHY1R21RcEdKajVBR1hOdWVlN3dFMTU0cS9pTk12SXFmZHNDaVNZcy9P?=
 =?utf-8?B?eHZ0anhFU2x1dWlrVC9tbFhzN0lNUUFPekJQWU5JYVd4dUtJTVovWHBKSmpz?=
 =?utf-8?B?V2IwbTE2Z0hURnRFY2EzbVJkZVJQV2JMY1AvYVhpb2xmR3ZPU2pKdkhmMitk?=
 =?utf-8?B?cllXS1kxbGRxWjBxS3gzYmRPMmRQV2Z5SkJuUTBLQXk3U2IxajBlSVk1eE5j?=
 =?utf-8?B?akpRZEs3VW9RU0ZOc21IU243Yk9uRW5KMmtuUC9FOFJuM2I2UW5Yc040T0dF?=
 =?utf-8?B?QlZUSi9idXBJWEQ5em5yMWpqOVJabVE5N0hpNHpIQmVOR3N4WTFhTWFSSmFJ?=
 =?utf-8?B?dDJRZkI0Vk9nOVJMYm45TWtwZzFGOXB0REd4andycXpPZHBqK09VZU55TmJw?=
 =?utf-8?B?RWl3Wkk5VXZQZTh5RUttTGNJQTd0MStlVU5hK2NQdmJiTUpldDZNeTl3bWc0?=
 =?utf-8?B?aUhUd3pQcENxUDNNRWgzaG9sV21WdlhPL2xCVTl1SGJoSlVQR21Nc0lJRTdT?=
 =?utf-8?B?c2pYS0hyYmNHK2phNGJDQnBGdzY5ZFdnSGlLZmxyMkhSZTcyU2lIWXVRbGdv?=
 =?utf-8?B?Ri9ZMWhNc05YUHZSWFVPUjlwN3pjR0FaWEF1dmZ3dDV4bWRpd3VpN3FkeHQw?=
 =?utf-8?B?b2tyMXEvbHlJQm9pL2ZnLzk3OTB2R0kvYnFRU1RjZ3FhejhDcFhaWFNVUnZp?=
 =?utf-8?B?T3ZGMWovNy9wejNaZmh5ejFpT0JHVWhzTWVhRnpESlB0cVhEdHVsaUd2eWlL?=
 =?utf-8?B?bmQ4TTBjQkRyeVM0TFozalpHeFhGVWtCSDVvWGZacVZwRm5EelBJRVAwWGxt?=
 =?utf-8?B?bHhibnFxQmMrQ0RCT0pBZWk0a3QrazlPdmRIQnRraVJWN0ZkRkdtSmlmQm1S?=
 =?utf-8?B?cHNHa1IwSXZsK2JLekVXK3ZKbmRKcU1VNEtqL0tVaGdFTkUwUFNjc2ZsdlEy?=
 =?utf-8?B?RjNuR1g0OGZBZ3ZVbWRxb29WaTFPSS9na1I4VmJ2QWdFWmdLY0p0WWUxUkR0?=
 =?utf-8?B?MnVvQVNmNENsQ2VSSVYwWVRuYVVldWk4L1Z0REFyUjNNSm00ViszcGhwSnQ1?=
 =?utf-8?B?TldHb1FSdFo4dXRWSFJDWEVpdy9lbVVWbHg5b3BObFM0YVV4eGhxVXdMSm9D?=
 =?utf-8?B?cEZHcUtOMXcyWGMydHVYbG9RUzcxcm9lSlhkd1lYa0ttWjRnR1lMMERGTHBF?=
 =?utf-8?B?Y3RGendzNTd4a1luaiswSFBzRjlXZkJNRm5UQktKU2lUQ1lhWnlMYVp1UzFZ?=
 =?utf-8?B?UmNGTWNzMCtQbk9lSlBOekV6Z1FuMzBQaFBabDZod0FpQkN3K3N2L0RqaUYr?=
 =?utf-8?B?cGZhRE5Gc1FiOWlXcXJYaG1CZTN5dzVPdjN6R1VkM0VZNkFRU0lJTm4yK3RH?=
 =?utf-8?B?UWpyUG5nMGVuejVjVjE1enpTL2dWWitNZEZFY2tkUXE0UVFSY3IyNUhJTXJt?=
 =?utf-8?B?RkpGa0wzM2RqY1diK1crSmorZFFoMkdhQWlQTkFjRG42YmEzRE5QaXB4MlFr?=
 =?utf-8?B?cjVXN1JqamI5Ymd1c0dvNFIyTlJJMTNXMUZPMDdBS05MaXRraVRSRVpEbEF3?=
 =?utf-8?B?bXRXbDlpQ0dTTTdkU2kybXJSdVRJa2FVc0dDRGM5cUxYeDdOWTNTUFdadDY3?=
 =?utf-8?B?d3d5Z08zWW1teEFBNzNyd29aYlIwS3NaZjN3bVUrZFA0YlgxNWN2SU9HQ2Fx?=
 =?utf-8?B?dDdyOCtXZDQxbm5XOHVULzVLN3lmamdlRGx3dE43VHc3bjA2b08wS3dxWWtL?=
 =?utf-8?B?S1MwSzdpaE9ZTzg2Q2ZpV0p1T0ZWYjhUSjhCVTJ3N1B1STBYME5xOWFidFJH?=
 =?utf-8?B?MTFjdHovMWZhTFdwdk1BQmU1R3hoNm9nakNxamZ6NkpJdGpjMmlhdFd5TFFp?=
 =?utf-8?B?YlV0V1o4WGxaL29PSC9MbXIyeUtoM3RmRFBGMDE3dmpjQi80TDdmb01Dc2JZ?=
 =?utf-8?Q?5IOejDcetz7UKWe7oSXEtLUcs?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef950bc8-666a-409f-be63-08dcc72c344c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2024 06:39:45.3126
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4eIhU6GiRkicBQJZQCSkLcAcFIkCOuIsS31Lwuve0h/Mpvfaxgc7sfYlgk+XYkmp27FnJ3RhEmplg7pHXU3HLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6392



On 8/21/2024 11:07 PM, Jason Gunthorpe wrote:
> Generates the same code, but is not the expected C style.
> 
> Fixes: aaac38f61487 ("iommu/amd: Initial support for AMD IOMMU v2 page table")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>


-Vasant

