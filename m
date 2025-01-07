Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2072.outbound.protection.outlook.com [40.107.220.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F5F7158868;
	Tue,  7 Jan 2025 09:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736242787; cv=fail; b=kAnLX3DZDZ8xE+sD53jbNRHpRo/aYIYmTRAfJK4CoTLd3/U1Pl40tOVJrDG7CuXDQAFP2bWP18Z6/UxyPsMPt6S45mlfi8GqRps+lmOWWzZCNA2SBheNFFjrx5TpVIZ7660OdbcoWc6MXNPthBvfBJWGPAt78m3nh6KPQP+GAo8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736242787; c=relaxed/simple;
	bh=/WeQloRyhTFByepqth22EM5RcPApkHY1LSk6z430rD4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=F0XZ0dm3Oup6FFIMm+pbcLIiMVx/mawBvpY9WAWnkgJ6TcDObXJm3RJgWtxzfkXRXZyWhEPQ/bvqVd7pSpSKmmtmkHoGjAvHqYmwuxxk7ub5wu6YZcgHC8EkeSr2zSVwA2siTrwKStRfmiC453dAPqTYWJ1dVg0fNFtJrt0lsIo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=woUmagnV; arc=fail smtp.client-ip=40.107.220.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="woUmagnV"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jnBUncRutMWGqax+E3iNeah+G7JnhqLltFhYQSQWWKDn0plJqXcSRhWHBIOCr6A+yRJ+RgR6fy/0F0o5DVcHF32XinTjYLTz1j1aVwTt9D1pTmiFt8vzEriFxvoNumg9diiu+dTVF5vT3RmKdlmVp4dUaQXcMFQWjOVcGKu07j/5fhSqzXhl21h1KOUBlE+W4WfPdmGA72M3cl10ezI/d05c+nbs1k6s2cbeOV6imRqCoelxTCoKQHpXQPUgx1E5XurWqXmf2ygcyXtvlbvNIE/KOq8cdGnHdzhZhr3CZx30mg668VULvTmcfBzg0k7yIr8QrVXws8SXRm1vcA/HSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=frBZnu67raQx189/b+Z6zIEAL2wS+CAr/Ad74av4+RY=;
 b=QukINcmkhdmwb7ofbvZ/bupieHboabuH5EKx3Gn4vo+pBLHhCYAkcQ/v9HHtsj4u3CYoo/vaaxVJDtLl6JeiYlBIgfSI73FyoavcQwW7yjXTPne0ze3bkA1sepp+HLwxgPPwVCi5/Gwa6yigLJIyQpJLGe92fdsOhiIlrGyq64qwohXtBh8CAAVYePpX3+GVBVYCC2990Gjt/tFjmJ/FOTHu0QODMlyBlbNRYi8tNItuhNPzazEkYYCrWUaOHSjj3rf1lN12faX70BiOQVhGk1DP5MKZQGfR2QZBpPP6W/h4CRr22rrXX0USia9axNEB2XLd93QflQCk3zA1iZ89Lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=frBZnu67raQx189/b+Z6zIEAL2wS+CAr/Ad74av4+RY=;
 b=woUmagnVJ6RTXl/yHTTIsaD7VxgKe2qqEuwp6X6Iu6PCNhrOulyDFZYDF6zoNLxyDl2U8e/3ZO5/pSBZ+Md5AZmJfQ9DfJmZXAbshCZj6wt1uu7D/+GACt6B/0FBKpzpZy6jgbSX/SzkJ2so3fPEb7V3yZVS3JWbzTaqdtvwB4I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 CH3PR12MB8187.namprd12.prod.outlook.com (2603:10b6:610:125::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8314.17; Tue, 7 Jan 2025 09:39:37 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5%6]) with mapi id 15.20.8335.011; Tue, 7 Jan 2025
 09:39:37 +0000
Message-ID: <3af4e1d1-2db6-46b8-8b00-5d55fcb7d077@amd.com>
Date: Tue, 7 Jan 2025 15:09:21 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/7] iommu/amd: Change amd_iommu_pgtable to use enum
 protection_domain_mode
To: Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
 Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
 patches@lists.linux.dev
References: <5-v1-cf88773f22d1+39bd-amd_paging_flags_jgg@nvidia.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <5-v1-cf88773f22d1+39bd-amd_paging_flags_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BM1P287CA0020.INDP287.PROD.OUTLOOK.COM
 (2603:1096:b00:40::23) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|CH3PR12MB8187:EE_
X-MS-Office365-Filtering-Correlation-Id: 625cd94f-8f89-47c7-2233-08dd2eff336c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OFJ6U1NCanMxUEp6ZExuQjBBY3NjZWRnK1RyRzl3L3ZLYjBjWGVKVzJaV1Vq?=
 =?utf-8?B?YTd6Mzlzd1MzNVNqK0thM0lZQzcwUUhqT1JtWFhQbHRsWFpSRitMaXQ1c21w?=
 =?utf-8?B?cEtCN28rRGx0eVlySG0xRjA4Vlk2ZHBTc1ZqRXN1WlBCUENiZ3YzTGZjZU5x?=
 =?utf-8?B?MGVhTjZKZC9JdWF1OHk5ZTUrZG80SnNJYjJnU3dmSUVkbGZzMFdJWHhGeHoz?=
 =?utf-8?B?eWNxSW5OT3U3RHl2ZTE5a08rUTdCeTN2Yk9hbGVxZTY5YVlZdmtLVWZGSWxM?=
 =?utf-8?B?SHhNVTZiSko5UFBoVFhIdEhoZFJOdlE5SkZoZjJFdExVaG5DZTl2YjFkTjVY?=
 =?utf-8?B?RWNpMFo5Rlo0U3Q2T084RXU1ajZMRTBsQlhESGZzZ1prVis5dXE4eDlUbStN?=
 =?utf-8?B?YlAwUFhDNFpKVmdhMU1CUmNUQnVTd1ZaZ0luMEhsYloyQ3hJQlphUTYwQXNy?=
 =?utf-8?B?V3VXMmwwSmE2cnkwcUN6NmpsMFQrOVczbThkQzNWeEtYL1d3eUg1a3V0NnZY?=
 =?utf-8?B?ZGlVQ2h1c0NWaCtnd0hlcnNWSTlhMnJ6UjVzMjZtVDBoYW1RbkZWb3NRMmJp?=
 =?utf-8?B?U0M4cGd3OHN4MnlQSTlEUk9LQTMrc21WYUxyRUFEVjBUSmswbjJQSTlsTGYy?=
 =?utf-8?B?c2RYMS9nL3NESis2VS92WmlIaThYcTVrWjV1NkhYWFJ6UTF5VXlCampxVVV4?=
 =?utf-8?B?ZDZ5U3dkU1NEZ3NQMGEvNTlNaTRrM0FwNDNpN2V2YU9LVXBFT3YrYjNSSmVu?=
 =?utf-8?B?WTkwZkhXWjRFYk5rWTk3T1ZpY1lnMnpnZEdTQ0ZZYmtyK2xnMEJJN3djMysw?=
 =?utf-8?B?QXRSWUVNcGNUWkNsbzBjb1E4TkFSaDhORG5UdmZUeHNZek1OSHVKZ25jaFd2?=
 =?utf-8?B?ZjR5ZDBLdUxlTzZRaHNaTndnS0pkNnBNMVhVTFBkS0V5bk9iTk00d29OREFB?=
 =?utf-8?B?NGlwVXk1dG1wNFBiUHlIcmxFUk5UVlZPK1czYVJ4TCs5UXg0dDUyNW1OTkI2?=
 =?utf-8?B?VkJKMEZBTnRINzZIak1tdjlLMHk2NzdPeWxwZnN3aThDVXJvc3V6R3JSMjZZ?=
 =?utf-8?B?MkpOcDFGVERUdDJSSnRlQ1Fpc2NseWNrUVdpQXBxOVhiQ3VzZDN3SkZCWGs0?=
 =?utf-8?B?aWFTVGxRUytMOWVtK1VyTlU0WjkvWG1NaSsxdjFDUno2bWlreW1iWFc2Zjgr?=
 =?utf-8?B?QmhLOUEzVFhINklQREltL2t5YjI0OGt6Qk9xTmd1NXFMTjlMNDI0elBYbk1R?=
 =?utf-8?B?NTJQNE95ZlBaa2xWWlJYSmFtbW5iODZTYWhlbXdiazh5YU1PUVhKUituZzlo?=
 =?utf-8?B?ZW1qdlBUTDZmWFJMUTlnaXhBdG9JQXJ5MUM2MElMRm13aGVENEVyZlFReTB1?=
 =?utf-8?B?bncvdnVqUjgvZ0tVdThEZmsvalN4bkV5UmpMYkR3eVFXREkzOWlMZ3FGVEl1?=
 =?utf-8?B?YnZTWUpyTzhnQ0pPUGxEMHBTaXpsYjJYUEhZaDlZMHNsSTNESVRaanNZeGtC?=
 =?utf-8?B?LzVJTXgyc0g2Z2k0ZnVMTkszOWlCUktQaWc5Yk1aZ0IveUtqN0ZKTC9Mb0hO?=
 =?utf-8?B?aUVpdHpIS20xTzFQNDFXTk1XSllNSGN5bGUvRmUyM1laVmJrSjBJdzVSUUtV?=
 =?utf-8?B?ZVpBTjZkL3pOZFhibWdnM0swLzhKQjFDdnlBYmIyd1RnMlNwR2IvOHNQRmRn?=
 =?utf-8?B?RUhxOVhRRjh6R0tyOXU5cHJQNSsyYk9WZ0dHV3c0K0JRQlVqN3MxUE9wdkRB?=
 =?utf-8?B?MWs5R2h2ZnJhei9KRUZPeTdhLzRNTGh4NVdZblYzdGFudHIzTnJuRTgzYUNo?=
 =?utf-8?B?NVZJSFN6dTlOWXpkdngxdTQyNUZiYUorY3ArNzBRMG80UDRnb3B0RGc5SjMy?=
 =?utf-8?Q?vjDz/oO391K4T?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M3ZpUktUSURQc1N2VFRtamhqRDc1eStSbmpxeGpSVGR6czU3UWx5VkdlclBh?=
 =?utf-8?B?Y202cldkRm9zbEpMTEowT1d5bHdQdnJScFFJWi94SHY1UkxBZDVmY1ZRa0Yy?=
 =?utf-8?B?eG9OMVhtTndtRThCVm9HUXNMaWRXaElnNHcrckFlWXc3Zkx2ZDhEeUM5Yzg1?=
 =?utf-8?B?dXJWYzljK201VnJVb01LVzZOUlNMUnZRcFpPOFltV3ZwUTYwM1pIREM3aFZl?=
 =?utf-8?B?MVRpTGFrMFIwNzhwSEwrcCtBME42d2t4ODR0QW5nd0UwRUVSbFFUK054QXE4?=
 =?utf-8?B?aE9yS3A5MVFTbm0wY2xxdE5ZUlF3bGl0blpVOFd0eGhZei8xVkdDaUJaTmc3?=
 =?utf-8?B?WHhML1JvNnd5OUdMNGhTVjVXbzhnU1E4Zys3d2V6Z0NKaVlPR1hPdktVQ3Vv?=
 =?utf-8?B?VzlRd2pmY0VZdUNQVTUyZDNXeldoZGY0UjBXa1lJS2xYOVQ1a1JOUHh0czVO?=
 =?utf-8?B?eHVCNEx2K2VxNDRFL0RVRVZycmh5NzZsYlQzTVFSbmtaNFl5RCtjY2VlYWpB?=
 =?utf-8?B?cVJQSXVmSm82blhNUCtzZlMyN2RYSTdHcW50bDlHUmJKK1JCQ2dCbFFNck1n?=
 =?utf-8?B?cjdSbW4vVWFLWGlkWTRzcDNYVGg5VEpKZFoxZG5jV1ljdlZPUStsTzdMSmlv?=
 =?utf-8?B?VVNXOVl0aTNWTVRYU1k0NWxQaWtUS2czSEhQVTRRa2Z4TXV0b1hZWEw5OURX?=
 =?utf-8?B?d3NFNnNHcmJWK05XVkpnNEFKci9meW1KOWs5eDhSTkFMaUNLUVZhdHA3UndJ?=
 =?utf-8?B?VWN1YnovUG9uMG95djcrUWNoa3ZvYUt2dGdmMTNzV1dMUndWYVVYMVUrTnJt?=
 =?utf-8?B?OEg1WjUxRHVOeGJtWEV5ZlJvNVErNzlFd0dVdnlnS2hpQ0hSSU4zNVdxZHBn?=
 =?utf-8?B?SFR3YzN0T0g3S2NxVGFsbXNseFdQcEpnbjFiTmpsVFRXZjRQTVo3OFMyUmZy?=
 =?utf-8?B?UC82TmFxcmV4K1JvUVltclg1a3JybjhwVnl6UVo1bUhPaGNkbVZVTklPVFpQ?=
 =?utf-8?B?ajhjbVpZMlBLQ2QzaTVQSU45dmxoSGM4eHRzMmprTHBLbnlqMGlMTm5MWk54?=
 =?utf-8?B?azhxNGxndXRmQVBFRm9LTmc5Rjl3VHYrZzRtZEJyakh5YU9scmptcHdpQUQ3?=
 =?utf-8?B?U2dvSXQzdzRSYS9EM2pDUzV1azNxb2RROXRPK1UvTEcxL3BBMnRHZDV5TzY5?=
 =?utf-8?B?M3VWMzdZOWVYc25sQTMxU1NzalVxUFNkekl5U0N5K2JEV2Q2dnRVOTZmOUFo?=
 =?utf-8?B?SjdCWitGV2p0NENxNTZXWkI5Z0szSkN5WDJLdElyZW1HZWhpdjdpUFZ5OHEz?=
 =?utf-8?B?c01YQjc3SVN2cmtCS1pudyt1YklWeHFwU3FKYm5Yb0xBQkdBcTFvUW5SZ2VU?=
 =?utf-8?B?aVNicEpzMXRJbkF2eTBrcmhiMktjQzlNWkNPQTJVZldRWU9lRk1iVVVlZFNJ?=
 =?utf-8?B?bjJwcWxQRXQvUXRKRTA3ejJiU3ZBZCtZeHdPRnMxWUpHNW53R0EvVHBaVEpJ?=
 =?utf-8?B?SUoyRkFKRFgyTTNYQmsxRmNHZWtlSlF6emtRT3pKU2hMM0hUTlNia1MwTVli?=
 =?utf-8?B?UUpyUmpqNGcwQVcxOFRKQkQ1TDdLMWIyVXluRllWTktoR3YyTHBuaFNWTERI?=
 =?utf-8?B?Qkhra3ZHbXVOcUo5amxQMFNlYVRXU0RseTlVNVJmSXhHWVNoOXRMaGhPV0o0?=
 =?utf-8?B?MTJOcDVyQ2xYTVd5cCtBUE82bGZXYVMwWkMyQzQ4dEtIbEhBZHBNRHcrUVlq?=
 =?utf-8?B?U1E5RGlteUVIVUhBMkpDcmErcityZnM3R1kxa3ZUVEMzTWFiejV3S2NIdGJQ?=
 =?utf-8?B?cENVUU9MRnYrMkhlcFY3eU5nZjZhdFRqZkpjemFQVFk3RzlaYjlBS2duNjNL?=
 =?utf-8?B?MjM1eE9YTDJ4cGVSVkVucU0zbmRyVUFhRnI1K0dEeUxuMmVYRk0vbUE4SGVH?=
 =?utf-8?B?ZEw1NWs5YVBhQnIxU0lJcWdsQUlkczd6cmRRNUNDSGE3YU1ycDFIS09sS1Bw?=
 =?utf-8?B?S21vY0MzMWZpb0J4Q0Q2czRMNVVXMzN0NnIzZWlTeXNsLzAwWDRtMXFWbDdi?=
 =?utf-8?B?eWF1d0ptNFJ1TEpjZnRoa2w3dVliUDZwUS8za2txSFl2M3FWeXVzNit5bDhC?=
 =?utf-8?Q?BRbaDsh0DvcfG0M3vkuaP27LG?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 625cd94f-8f89-47c7-2233-08dd2eff336c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2025 09:39:37.5079
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W4wWa9EvCSpaKJlbpN8TdGjqXepjFAEebgjqDUnwVqZ0C6rNa10WW1ncadlIyKIVsXHqACGMHDOklmpE8/x/pw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8187



On 12/6/2024 5:53 AM, Jason Gunthorpe wrote:
> Currently it uses enum io_pgtable_fmt which is from the io pagetable code
> and most of the enum values are invalid. protection_domain_mode is
> internal the driver and has the only two valid values.
> 
> Fix some signatures and variables to use the right type as well.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Good catch.

Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>

-Vasant

