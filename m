Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2063.outbound.protection.outlook.com [40.107.243.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5C571459E0;
	Wed, 28 Aug 2024 06:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724827154; cv=fail; b=naXBZPypp3EY9tyavjmUabqCGMfhA3QSLfeTzkf3ZN++1v14o5sbhCFiBkrWlfBdhYJ8uPdixh3eE5HWKARwk84oAG0aw6BsD7JwACf7+3wkpXUgAIzxzZJmdg4dOeHBdWix9qXHTN80METx3+6YYWDpNxPDPuD6oMbnY+Ry3lk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724827154; c=relaxed/simple;
	bh=NsxiG2k1d0UkCu/9WDkpOXmBMTqBsAUrrvYYW3cF+XI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ZBbsxmIZl/IGpFUou5wNZfbJ9k+jH/zv9EH3aR7/gaYqIky1JScaEJzjz98zsg7JJxYgm0jtxTbIKgkq63ftFYKotP2yP3+TTMMkmwh1WPXA/B8RcfRErt8UszeSIZM57xZe5Vipngh3gU84CsVMeYOjn8aOe7fCYq7DMK3vj4s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=kt/l/nFZ; arc=fail smtp.client-ip=40.107.243.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="kt/l/nFZ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Vaq6aRjzEWbd7l+nvsc/xXM2Wyt99RW/uzbtyjJb81oWO9ftJzEEeGrEBUbfbwV/zlRWCHG9wen9pO5/P+aexUrClx32VqHACeTM3l6Pn/U0R50oPR/3o+G8ibfFBWHDmh2xQ9sinkNB/ECYHbT/h6wW49ALqTXBjH7w9kmsGGFeTYZJaa0L2osj+jk4+2kDJ31VxBMwnGkjv959/ESKyRUMpuBtwanFoIAUfnCMSrvK5fPe79bODTsMokpxMfi2OZsr/7FROgFsbC+HEcMs6mXtn3uWwbMRO6CcRzXE3Ict7ZvAGil9VN/qIWNxI9doZwZ/KmCtlUdBf2qvzlgUJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e5S4q25cJh21kL4hratUJBUjJUGUKDIVRJqVBe9UxPo=;
 b=we7iZ1AAffJHb1ne9nfmtyY2nJtWTvm6ojZnmW5vdSVHObhouN3YfakKHrNU6ug7LgWaCtGH9uMU2+KiTLr68gqPRMj+fxp5vRct86i71/+9t9avQzfaTlEXWDLMVyEfAJ4BWGunOxWpHaBV5tYUJZ0QR/83JFKbWhksAnjahb32VOucVX6rOlQ4h7vp6X3qt0H7+JljGbk0eWZa8m7iJFvh71zva/o5htCAtzrOICY9THCx0nDKGvm6SmeK+7dCd0ZHPhC6IDQcXg8GhMwQ1PHKJPswUeuMntBwVESdsr+8jPFKeKxpHPQgkdCceJi8GQNq/g7+3JhmfvAsEjigSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e5S4q25cJh21kL4hratUJBUjJUGUKDIVRJqVBe9UxPo=;
 b=kt/l/nFZw/2LSm1ZunymLFy2u0pulnHvVqlIIp2yRCQR4BCYF7WRfCpq8TuR74/6KTJzUsJAUJ+9rzatxehCG4rTXjcYlz6N6G8ej1IyMM1mD6UMH7aNYM8v1TEAV5RjRwO1osNQXtelC+3+sVVynLtEtpfbidWVnZiAwP2k4Ew=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 DS0PR12MB6392.namprd12.prod.outlook.com (2603:10b6:8:cc::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7897.26; Wed, 28 Aug 2024 06:39:10 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5%5]) with mapi id 15.20.7897.027; Wed, 28 Aug 2024
 06:39:10 +0000
Message-ID: <fb029720-17a3-4cb6-8a2c-6a5931279e98@amd.com>
Date: Wed, 28 Aug 2024 12:09:01 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/14] iommu/amd: Store the nid in io_pgtable_cfg instead
 of the domain
To: Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
 Joao Martins <joao.m.martins@oracle.com>, Joerg Roedel <jroedel@suse.de>,
 patches@lists.linux.dev
References: <8-v1-cdaaddf80abb+14190-amd_iopgtbl_jgg@nvidia.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <8-v1-cdaaddf80abb+14190-amd_iopgtbl_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA1PR01CA0147.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:71::17) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|DS0PR12MB6392:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e8fc336-836d-4657-dc93-08dcc72c1fae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WGZoV1ZEaWh3amd1U3hnZVJvTGNCcGtBcHpuWkphWFhzMzhoWHZRbklpTWhM?=
 =?utf-8?B?S1dUclkzVE5xcDhrZUN3eWtSbnNvb01mNzgwSFJFYm1NWlY2YjZqZ1orYWFv?=
 =?utf-8?B?UnowYk05aWRkdHZ2NUNaN3F5d0hyS2tRQk9DVmd5bzVRZEVjcjRxS0Fya0FM?=
 =?utf-8?B?K3VEUTRpc0FSaHAxa3ZXNWIwclQ4M0VjbDlMNllrblpEZk83d082UWJ6ZG5B?=
 =?utf-8?B?dHVTZGJXS2xvT0FlajU2M2tyWDk0T2RKK3VaMjBUTHloN3VYZHhCUTBJbmVa?=
 =?utf-8?B?Rk9Ha2R6WTQ5U0NxQzB3T0hVM0ZqQ1dVSUpBYWMzM09KYS9zZk5tOEVrTXVL?=
 =?utf-8?B?VzFpYS9wbzRRZTdPTytGTjhuM2RyWTdtVmt0QlhxSVhCQUR1OWh4ZEV3bXZs?=
 =?utf-8?B?OFBqWENrZ0xBSkdydVJ1UkZiRkE1dlcwcnV3VG9DT1hHT0Vpa2M2WHN1d3d4?=
 =?utf-8?B?ODNIbWU1VU1BeHhSVk5HMTlLVVFGUXE5cFgxRFRGS254Q0pncHgzMDI0ZUdN?=
 =?utf-8?B?RzgrNE40cTM0WUt4SFdFMERjTXNBc0JDWUhKTGxGZmw5a3kyVG5wZE9iaXJ1?=
 =?utf-8?B?dlIwMHI5KzdmZnF4K1BteGltS2JxRjUrcGhoaDhBSGJXd3oxS3ZtdmRLRTFo?=
 =?utf-8?B?YTRpTHZjdGthMGdrQWdObVpycmVGZE9jN2NNc2FmSU8wNWc1MkdIUWR3cGRx?=
 =?utf-8?B?ZU5wZkZkQ3RZMGFMZEtJUTd6d3FuUHhURWpYV3hPVm1PQlhJMWl5MWR2a1Vu?=
 =?utf-8?B?OW9qemVHcjVyZUVnVzBUZ0RuN0xtak1LYURkU0V6T3ExcFNrWVlIdlMvYjNI?=
 =?utf-8?B?cUhYVzBYMnNOd29pZkpuMnhBNUI1anJVWEJ2TElGak1TV2hpQmxLVFZ1TmNW?=
 =?utf-8?B?RjZlOEV5RVpiS3o5bGR6Rys3dDBOS1I1Q2pyYThWWmhLMzVobDdveHh6Z2pS?=
 =?utf-8?B?eS9yTkxKSC95R3dBRkplV2lrWDczdkxGK0VMdFJIU05HNVRMamExdnNwMFFU?=
 =?utf-8?B?QWF5ajVRdDlhL0RQSDZlTlJXWHRhTWt6MXNHdWVlVEhDaWgwRWtRRStkdlRh?=
 =?utf-8?B?cDE3ZXNYMFU1Q0h6QXYydUdlNHNWQTFuNXQ3SElERDV0cWsxYkZFN0s0SDVP?=
 =?utf-8?B?dlpoM0lUQXNwZnJ1Y25neE5rRS9PMXBnYTV6U1h6QnR1Qk5HYlk1UkRkd0JQ?=
 =?utf-8?B?NmtWNDdMcFNKZUZjRDAyVklPYXR1OEtDWU5JOFNRd0k3OUc4ak1IWlRTRi95?=
 =?utf-8?B?cEV1OEtMSWg4Q0h4V3hHdUVKZFJEcVdaQUFtdmFIaDExNGkyWU9VNlN4Sm8y?=
 =?utf-8?B?aklGN2o0dVZPMGNnU2JPcDcxdW5rYzJ1S0dsVmtuMEJQZVhndmw5UjRuTmps?=
 =?utf-8?B?YjRKRGlFRVdKZlp5MGptV1Jzc0FyT3l6dlhDbjVuRHZveUV0OVFIYkdqUUZW?=
 =?utf-8?B?U3VnSk44MmlzeWZLRzJNT1dSeFdZMlZ4V0VzVnFBcnE0eGtJMzFiaVJ3RlZZ?=
 =?utf-8?B?UTdJajNGNlBHR2RCOUtkbHdvKzlXeEd1Y2lXWXdEc0U1NnhybDVzVWllMmps?=
 =?utf-8?B?SXphV3ducVo0NW1LYktEc3ZvbVdKdmt5VGU0VHNWdXhOQmt0WUFIRi91RnJ1?=
 =?utf-8?B?aURJY1l4TDFhVzh1V3RuWUw4a0NwYlh1cnMvc0VDTVAvRVc1a0pldWtYTmR0?=
 =?utf-8?B?WEsrUStpNVJ1N3VUL2d6UVd1ekpDVlo2OWtlRmc4WUpiSENIL0pQYmN6OUlr?=
 =?utf-8?B?OVhXa3pNN0NiMGxWeUlZM21KNm9yeUJhc3FZS3I4UEJRVDdRb0NDUWpGa3lH?=
 =?utf-8?B?R2JxY3h0UTgrSHcxbkhIdz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Um9wQUJWeVlCdVBJVmZqZHdOalBaVkUrS2NDUVVWYUcrZTZEZDl4amc4NWhs?=
 =?utf-8?B?RXk5RzA3cUtFTnRZNlNLVFI4dmlQTFpaei8wMXl6K2hJTGRNci8wd000amFx?=
 =?utf-8?B?RXR6RHAvSVphWHJkM1NEZ0ZtZGpPM2g3NFJaMlBQWTQ1UmI4dTlUMnFWNWcy?=
 =?utf-8?B?K0lRd01xUHdXcnNTNk9FK2pCZ2xWa3ZMWXVOM0VtTG5Kc0ZjeTlXNy9jRlNT?=
 =?utf-8?B?UDZkaHcyY1FmOXZGRnRhU1NMZ0tycWx5UGltWGNEWHgrOWJXT0ZRQ3p4bHpy?=
 =?utf-8?B?aDhic3BTUkhlcHhxQlRFeHBna1RCU2VxZ2hLMzlMcTNrUkhKbStvYWtnOVp4?=
 =?utf-8?B?NEJheXpMb2dDUkxSTEIrTkdLMzhvT25ndWhlZnN1NXFoVjRrSmlLVjBNaVJn?=
 =?utf-8?B?eFQ1U2hPM2J3bnRZWjN0RmFoWGJIK2k2a1NrbnlVNHlLQXN6VlU4eGpHV21r?=
 =?utf-8?B?MmRQTWRmWEJxN2xtd1pONTh5aERDU2Q5bEkvRkE2dkxGUFZvZkdhQ2JqNS9s?=
 =?utf-8?B?SzlQeDVOSmtIWWVNR3QxWlI3NmtqUnNEVjljazU1Y2ozekZsdytwY1BDMm04?=
 =?utf-8?B?ZmlzNGNnaGVYamtXOGhPQitVbGVRVkpvSmpEeTAxWHZYOUg2R3QxM2NFbDJa?=
 =?utf-8?B?SnFwemhZY1JwMXRmZFNCSXphTFR0TDFJZTFzVWlZcDZEM1N6VXRWQXpzbmFE?=
 =?utf-8?B?MjNlcVZyYW9maXJZZUlIQzE4dk55SEpxVzZlVDlUNHUzSHdtaEdrTkVRc003?=
 =?utf-8?B?Vmc5L3V5bnhwQkRwV2phZlYzaEF2emowQzJXV3k5bFk1U2xLYTZRK1k2Q2FO?=
 =?utf-8?B?bkRwRWc3a0h1MVlOYmpXN1hiVmxTc1V4RE1hWThkaGxKazJMR1dqdkN5cjR2?=
 =?utf-8?B?RCtWYUFGT01VTW5jVWdBdjdnSURhb0JUb1YrY0xGb1N1RElVVm01VExrM2Vi?=
 =?utf-8?B?d1BkdVR2Sk5Pay9mMXpYTy9ldTAwemFyV3IrZ3F2OW1wWmMzOUxNNFlncWFx?=
 =?utf-8?B?Qi9ieGdReTMrOVl6Y29rbEJKczVoZmtTWEZobkx0aTM2TFlQYlh4Q3prTnNj?=
 =?utf-8?B?Y2NkYm52Sm9DTjYybS92cGNqbkg2S2V3WnlDbjJsYUV6bjlzZGUrNHVuTkVE?=
 =?utf-8?B?RzhGaG1qamxaVW4yaHpvcWxZanc5ckhoQjI5b1hNTTk0ZnhETjI5YzdvcWFl?=
 =?utf-8?B?TmJ3M1RNSklwQTFoYWxhYTJGKzQ5VHJCQlZadXd3K3VMclZFbTNiTmx1b05l?=
 =?utf-8?B?ZTRMWEc3bmJtWGI1LzhXb2xVQk92ZExKMGdGNFp2SWk1c28wS2JPdFZKTUR5?=
 =?utf-8?B?TjRRWUZ5eW5MQ2xyZUNBcVNjQnpQQWd0OENFZG9XeVlFY05kUjZUbkxzQ2Fa?=
 =?utf-8?B?dVVpRkxZekpoWVlHRDdneDh2MStJcGJoUjZwOHpqWE1KSkNkV1V2dnZtN29h?=
 =?utf-8?B?TkxsdEMyYW5pNnM4cWNSRFhjR01tK2JIRnY1dlJob0Q0MVJjZlJMWkMzSXVY?=
 =?utf-8?B?TVROYzNwNlpIbjl0dURXUldRQ3Rmb3NxKzkzSTYyKzFMRmZieVZ5aDM3bUM4?=
 =?utf-8?B?SlRiVHlPQkRZaWNuOTlZZS9hSHplOVhBWDUyRitxcTZITFhuaHlPYmdjZ3hS?=
 =?utf-8?B?NmhwRW0wY0dkbmp4M2N5azRKdzBnNzlLQitnMEpNODB6NTBrUEhjQktDR2ps?=
 =?utf-8?B?Vmc3REo1YzJKNEQ4N3BMNVFyY1NwbjhVUFU5cXV2QlpxUEZZbHlmYS9VRDZK?=
 =?utf-8?B?dU5iM3psakdncTBTWjBMMjBLZDNHcFpWbVd4M0R6U2krYk5GdWU1OWxpejhq?=
 =?utf-8?B?azN1eWNxQ0ZDaVliRm53RHcrSisrLzQ1a1kyeVpOQlIwdzZZaTFmaGg5a3Qx?=
 =?utf-8?B?UVV4ekVCVlZ3a0tRYUNaakxHU1RMZU4yNFVxS1FYSVhOT3Y3dU5ReWpEcVFL?=
 =?utf-8?B?UVBxc2tvcHBVTGN2eUVtUU93Y0R6bnhkZUc3a01xL1BKS1lWVk9yY3ZwMHkz?=
 =?utf-8?B?V3NwdFVWODVQS1UwWERIaG9TWVNzZkJobnJZWVFJVHFPVDVwL1hSVjNXWEpi?=
 =?utf-8?B?aUs1U01rSS9pTlQ4cEFRUGtmcjdSL0taWDJaVzFYK0tYamtIVzFqMWYySmhN?=
 =?utf-8?Q?8pNAe4BLxHzlDQQQjSyCpkeif?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e8fc336-836d-4657-dc93-08dcc72c1fae
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2024 06:39:10.7087
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DjbFsepK3vNSEv0r8ImnwJ3ZAXL1GbEkicxhfcLxzPwuvB1yJ506ahfYPGRlcTLYkhfaixGgo3fl+b4p9W9vAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6392

Jason,

On 8/21/2024 11:07 PM, Jason Gunthorpe wrote:
> We already have memory in the union here that is being wasted in AMD's
> case, use it to store the nid.
> 
> Putting the nid here further isolates the io_pgtable code from the struct
> protection_domain.
> 
> Fixup protection_domain_alloc so that the NID from the device is provided,
> at this point dev is never NULL for AMD so this will now allocate the
> first table pointer on the correct NUMA node.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/amd/amd_iommu.h       |  2 +-
>  drivers/iommu/amd/amd_iommu_types.h |  1 -
>  drivers/iommu/amd/io_pgtable.c      |  7 ++++---
>  drivers/iommu/amd/io_pgtable_v2.c   |  5 ++---
>  drivers/iommu/amd/iommu.c           | 11 ++++++-----
>  drivers/iommu/amd/pasid.c           |  2 +-
>  include/linux/io-pgtable.h          |  4 ++++
>  7 files changed, 18 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/iommu/amd/amd_iommu.h b/drivers/iommu/amd/amd_iommu.h
> index 5a050080d2e814..5459f726fb29d6 100644
> --- a/drivers/iommu/amd/amd_iommu.h
> +++ b/drivers/iommu/amd/amd_iommu.h
> @@ -45,7 +45,7 @@ extern enum io_pgtable_fmt amd_iommu_pgtable;
>  extern int amd_iommu_gpt_level;
>  
>  /* Protection domain ops */
> -struct protection_domain *protection_domain_alloc(unsigned int type);
> +struct protection_domain *protection_domain_alloc(unsigned int type, int nid);
>  void protection_domain_free(struct protection_domain *domain);
>  struct iommu_domain *amd_iommu_domain_alloc_sva(struct device *dev,
>  						struct mm_struct *mm);
> diff --git a/drivers/iommu/amd/amd_iommu_types.h b/drivers/iommu/amd/amd_iommu_types.h
> index ef4c4887cbbbd5..74dc003f5b7815 100644
> --- a/drivers/iommu/amd/amd_iommu_types.h
> +++ b/drivers/iommu/amd/amd_iommu_types.h
> @@ -579,7 +579,6 @@ struct protection_domain {
>  	struct amd_io_pgtable iop;
>  	spinlock_t lock;	/* mostly used to lock the page table*/
>  	u16 id;			/* the domain id written to the device table */
> -	int nid;		/* Node ID */
>  	enum protection_domain_mode pd_mode; /* Track page table type */
>  	bool dirty_tracking;	/* dirty tracking is enabled in the domain */
>  	unsigned dev_cnt;	/* devices assigned to this domain */
> diff --git a/drivers/iommu/amd/io_pgtable.c b/drivers/iommu/amd/io_pgtable.c
> index dab1cf53b1f3ff..d56be842c0b71e 100644
> --- a/drivers/iommu/amd/io_pgtable.c
> +++ b/drivers/iommu/amd/io_pgtable.c
> @@ -145,7 +145,7 @@ static bool increase_address_space(struct protection_domain *domain,
>  	bool ret = true;
>  	u64 *pte;
>  
> -	pte = iommu_alloc_page_node(domain->nid, gfp);
> +	pte = iommu_alloc_page_node(domain->iop.pgtbl.cfg.amd.nid, gfp);

Too many level and used in multiple places. IMO its worth having helper function
to set/get nid.

-Vasant

