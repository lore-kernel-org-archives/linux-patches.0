Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2075.outbound.protection.outlook.com [40.107.93.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B1B14B956;
	Wed, 28 Aug 2024 06:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724826520; cv=fail; b=U58tU4fW4LfppV5rbGFhRrrD5/n1gmDnMVTviw8+StfNIVpM29Yxrxf2P69zV1vHDEs8aNsgqraTosHuWhtyHiLC0GVd5TCYk0I2w+9UuaawuaJby+YaImS3D8E6tvIoJina/oeGyiUU4u3GcuD1Xx2swAih9+3q+kdIZHZKVFI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724826520; c=relaxed/simple;
	bh=+wZA7rAgY9ZFmVNjQEd69xADKl6pxbcirGoV78QmTkU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YCeInjE7Qm+uAgeQhyzKnoFGYgpIjvIjmxquXZIaFDG8lnnkiZF3WJAHv1+dBy0dYRAmq6dDPI+raqB+1zpvz8byD9OulKqB2Fyoi0mpqIZyikdKRNw/LcR102PuqqcJYupJmem1+Ita6h5sOnf8eIMMaRQPnYg9PmDu6B9BxLs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=jVqNpOEB; arc=fail smtp.client-ip=40.107.93.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="jVqNpOEB"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OYXNvRfnrfAC1zCg0l2jiBmH2T+abtRMn8aJD22Gc5ilD4xHT81NIrh2wOZJA8p0XilG6n4bYqlfKd4wc6Fh8jf06u0IUflafU+nVYrrLbG+abzR/fzwMeQJfeAMqFtR6X7hATkWHABIpiSjEkhBlZIdbaJf5KvA84Iy2/SEEFhjjlNvrthO73qpYEta/5P/iKHkzlqgA0bycLNIWYH5apJxtH0O1++bJGOM/xG5j6QVN5OUrNRh47VGMxk/al3+BcpieBa5chfgVlDM75OpOMVu18CSy0zlx3X+v0o/DZrknJT310ciEex6pV3GJfRihS36BmVWzVngiWZ0DGdhfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/W6TgNYjoKwEZ26l4whnkZv1n1TcvDydOmF6G5+/Qhg=;
 b=MzwydNoudfj8FuDMvRJY9SAiYEDJPi+LI9oHLCPt69U2/+QDk6XC9UONWHg2EtDDrvZ28eFvHNcR95kgayrr2PaByZZhc/xQGRAPSM7VtXGZzCk43N1/8+xGJVee4RRy45h9ptIKIylQ90FNKPxftUFdbvN9qhTnILbhQGFbBro/kCHltnxOvthyEXYyD0eFdkUHQPwtL/mQg99Hwnl0j2Z9chM2yS79rkVvEZU/3Ax9aLE9uGTt1+Ke0twFxho4mn6e1cYp9ZpWA8sgm8c6lKWxvvUyiEJBWGwc//JXVufbfK17piz4vfZVQ0P+ziVhT16NTygoEvjk6kRObYNw4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/W6TgNYjoKwEZ26l4whnkZv1n1TcvDydOmF6G5+/Qhg=;
 b=jVqNpOEBjHvR27LJKhdFnZSBjA99OYpfyHNbp1Wk5XHfmtP6Qc5LkjSZ3yMtme1m+46DEEm01z23PbgAFUTfoyNp7t76Bo/XB9ffwQszVmi0Oo7J3zZ8/ja3KAdPQOAFVnp7onqyI6+fPM1gLeWO5UUvejQmM0Thw68S3wE1nNM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 SJ2PR12MB7989.namprd12.prod.outlook.com (2603:10b6:a03:4c3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.25; Wed, 28 Aug
 2024 06:28:36 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5%5]) with mapi id 15.20.7897.027; Wed, 28 Aug 2024
 06:28:36 +0000
Message-ID: <40fe7b3c-fbae-499d-94c2-60799cb04ea7@amd.com>
Date: Wed, 28 Aug 2024 11:58:27 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/14] iommu/amd: Rename struct amd_io_pgtable iopt to
 pgtbl
To: Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
 Joao Martins <joao.m.martins@oracle.com>, Joerg Roedel <jroedel@suse.de>,
 patches@lists.linux.dev
References: <6-v1-cdaaddf80abb+14190-amd_iopgtbl_jgg@nvidia.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <6-v1-cdaaddf80abb+14190-amd_iopgtbl_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0194.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:e8::19) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|SJ2PR12MB7989:EE_
X-MS-Office365-Filtering-Correlation-Id: f7e6345b-5b54-4c8c-bd2e-08dcc72aa57c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Q1VtNWlqa09taDVvclZWemRuR1l0VTRUaDVvMitodUJHY3RhS0V4N2E5NzhV?=
 =?utf-8?B?VkJ3TVFYb3BLZzJwS3ZZVCtVRitaTmNsTzYyblF5LzdWUjlSOSsrdGJSaEZo?=
 =?utf-8?B?cW9HNyt0NGxma2VIR1QwVHpxUVpjUmVNU3EvMlMwS2lBdnp6WS9wQVo2eDhU?=
 =?utf-8?B?NU9QSEpJOFBzUlNrNnhDUEJJbHdoamEwRFdySGVSb1NHSy91ZTRnaEhkSlNk?=
 =?utf-8?B?ZndPQ0NsaTE1SEtuRG9Ca3Y1ak9RbDFUT0xvL3U4K21oUzZGTi84blAyVERV?=
 =?utf-8?B?dHZzZldJZjN1U1lzeTIvRlorVEZlQktobXNpRldsT1o5ZDFpM2hDcHRLMkxx?=
 =?utf-8?B?bXdWdjdRd1hTcXpKNHVBN2JsQkM5cWMra1dDcGtudXlXS2EzY042alMvTHF1?=
 =?utf-8?B?bVFQcWRQL2ZUOEFyUGRuZ1BwYThIVzhlSjduSlk3TmlPMW43aERCR2t3Nzh4?=
 =?utf-8?B?ZC9vWmU1eTJoaUR0aXJzNytucDhOdHVIZjRxdDNkZGdIY001M0NBaDhBVThV?=
 =?utf-8?B?cDUwaXRLRHZkUGhnYitFZGJmdnNnVUF0bmxvSHp1OUVMVUc2dmF1VE1FQUho?=
 =?utf-8?B?WGVBeHFmZGRsc3RRNDd0TXdwQWdXakRuM3ZJbDhHRjZRaW1HRUZ3eEJrejJF?=
 =?utf-8?B?YkM5cXhhdzFUOHRJb3loMEFmQ3hXNmVsTldwbTI2WTBPVEhRZWR2R3NtcHNt?=
 =?utf-8?B?N0tIQ2tyZ09KTVJlYzN4MW50WFZRWmkvei9GTWpLMndFM1FnS1B5MGN3SlRQ?=
 =?utf-8?B?T0VyT2pabUtxK3dXcFRWN3ptN0tZSndoNjYxK1EraXFyRkR2a1E3cmhBRUhP?=
 =?utf-8?B?OTBqMmlJMTExejQwVisvU0hCbDdGSzFTRTUxZDdCUzhjaDhyU2pjRHV6Y2p4?=
 =?utf-8?B?S0VTNWk0V3BtYVRCT28zOW80VDAvSGEyMkE5T3IyWlN2ZWEzMTYwV1ZiZU9X?=
 =?utf-8?B?c2EvaEpQWGh1SG9Sbzd5L0NrT1EyZjk3K2F0KzRPUDh5QmV5bkJ3UmNRNzI1?=
 =?utf-8?B?SEJxd3ZSUmNHRndmQ29GN1EyVjN5VE9UbFRlS3c2c2xyOVUrMzN2TFgzZXd4?=
 =?utf-8?B?SlFUOW9PWWx2eERzaGkvYnNRVHlYY3oyTmFZUCtaNUZYNmE3T0FMcDZFVHFI?=
 =?utf-8?B?QVIzd2xpb2ZlNEh0NENtQXBTZFNSNU9WZWtzTnNkZDVTcUU1UHBjaVdXMERE?=
 =?utf-8?B?OTRGK2piRTMrZGFPZTB6ZzdXVklCam50bWIzcWQ0YUVaNm05MnBnQWFzczhX?=
 =?utf-8?B?KzlKVjA4Z3c2YWIzMm85MkwvbkQ0UWExcDNTZWFBNm8vbzdTWmo4TkFZS3hF?=
 =?utf-8?B?Z1hIS0F0SGw5RVdJV3ZxQ2ZUYWJDcHF0S0dMM21oVndyanB5UFpzUUdFOVBx?=
 =?utf-8?B?NlRWdGpIODQ4MXdmcG5jYWJ1S3FPVURTR3VMWXg1dC9TcHBIekxSQXUxQUN2?=
 =?utf-8?B?eDNwSStTaUw4c3dibDBONnFCeXZ6TUxFYmxWNTRHZnBuSHRtREFjM1B0b3Bi?=
 =?utf-8?B?U2wzNi9maWxJM2NjTWgxcjVTeGZyUnV3SjM3WkNselFuZGFoSUF0R3g5V3Jz?=
 =?utf-8?B?ZGt0SE5NQks3SHhzVnB5a085eEZ3S1dlRE9TVkkrSmJmNXc3N0dGOUdKYjla?=
 =?utf-8?B?cTc3bkR6aXQ3Nm90OC9ZVUQ4RVg5VXlCSkpIbFp5czZQcDFudEpia3lUR3hJ?=
 =?utf-8?B?b1hTK1U3TStUSlJ0ZGFXYjhEOHNVVHVuYXowb0ZhaGdlT2p6YlRxUEg2V3RO?=
 =?utf-8?B?bVY1dnV4TCs3bEhmdVl1aGc1bEswTzhkNXk0V3llbk1yR1VsUXZ2NVdFdWRa?=
 =?utf-8?B?eW13aVI0bkhhb0pYTWpUZz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N0hWWnBmcENXMldScVo5Wnl3a2hmUjlnWjJYMDc0ZzA3L1VNaC9iemx5RGR0?=
 =?utf-8?B?T1RGZkw4WjRUY3A2R1RwTWpNbStLMHplWjFnTjRZSFVuZTVUKzByZG5nd3c4?=
 =?utf-8?B?a2xaVEVid3RLRnRQWXVIeWt5L0NpVmt6NFAyNm41Z2lPbDd2Ynh4Qk4wWmxI?=
 =?utf-8?B?TE1YSm9RRW5JYkZjTXdIT3h1M1ZGbHA0cGJmMFhkZ1FVVzV5NEZNNVg2M3pI?=
 =?utf-8?B?VVFjK1RyREhmMlZTU0l6Y2RpMElmNmc3K3I3YWw0ZVZmdStwanJQWUdzZjVQ?=
 =?utf-8?B?TS9yYVVwWTc4dGk1c1EwenZVWjViaGhPdkE5dGZScStjenFNei9UUVZKS3lO?=
 =?utf-8?B?SlloU1V5SnBZdmxOekJLMFhERzlHM1IwR2NWVnFLeEZxZFgwdndnQ1dUN3lH?=
 =?utf-8?B?cDVEcG5TRjNNam04ZXRrVWtlR0ZkakJjRm5GTG9wR2J3emI4SUQzaDhBNmo4?=
 =?utf-8?B?KzVUZHNEclZzMlcwMVpCWXJwalpjYktQZE16U0FyemtXNmYvcHg3MUwveFNK?=
 =?utf-8?B?NVF5M043VkY0YmZIWkNJTURiZWQ3MENiMXR4WlBFclRZVEM0K2FKNkhBdHI4?=
 =?utf-8?B?cjhzZXBaUGNwa0gzc2M4dkdCZ1lLNk4wamZpYnMzNmtVNTBGZGErZHRPcjZT?=
 =?utf-8?B?UHc5ZDhieFpMK01rVWc4MzdwSHB2UDhZVnQ2NEJBVWdnWlp0UzJaUnYyY1BY?=
 =?utf-8?B?dHpTYlBvVWZ5SHk5ZnB5QW4vZTBUeWVDVy9JdlpNOCswRXNjTkJvNlFoejZq?=
 =?utf-8?B?cDZGeE5iL1UxU3J0dG1FVW1wWXpvazVieHR5MVNRdDREVk9Tb2xQN0Y1bU1Z?=
 =?utf-8?B?VUcwOEN2MTVRZ1I2bVNIQmVSNWdHb1hicGk2MjYzVWYxb2M5aWhCbDJDUEha?=
 =?utf-8?B?UHJpL1RrTEYvTDQxMG5BNlM4OU9uQ1FtQ1pUNk00TDVPTVNGbHJwcmgvMitV?=
 =?utf-8?B?WUlRSTh4NTF3YjZRT01oNXVrQ2YxSXA1aERKMXAyTUh1ak9ycnhzT0Z6bUs5?=
 =?utf-8?B?ZVR1TUFIcGJodWFyZXNtY1Z4RDhqZExmMi9rREpUTkMzLytuNDRzZnEyMFN0?=
 =?utf-8?B?QUgxelF5NkZldUIvOVlOb3hKaVJuRmN6WUNBR09QSGs2WVU1Skw4UHFCU3Y1?=
 =?utf-8?B?K1lMbTFxczBhRWZqRkRNWGtkVEZNL3RDY1l2SHY3SEJaYnlwZTQyRmlxTGw2?=
 =?utf-8?B?WG44TUJ4YnBiWWhyazFBWGM2dmtiM1BLS2lyK1BENWlreVhaWUtvdW9hRUh1?=
 =?utf-8?B?eEhCT0phZmZkL3dMZlpsVCt1SkFYRithOThOQmVqRVBVclZxRGYvMDVlRUxz?=
 =?utf-8?B?SXlmUEFwVU83TjZNWHFkRlJjbzJjY1lIR1p1NEJNdnlDK2dCVXVEeHk3SGJx?=
 =?utf-8?B?ZXlNOTBzY0R0YndsaFNLcjZ5L01Ga2JVN3VPQ2ZEU2ZRL2ljSEZrT3NNeitm?=
 =?utf-8?B?YUJVNDhJMEdhRmo0MjZ4ZVdROHRaVjJMZXNqcWtHTlBRNWQvYy9zTFJwZXph?=
 =?utf-8?B?SUErSE9tZTg1Yko1K1RIMDgvMGw5SnBNRDBlaEY3ZDJ2c1pRL25NVTNWTVND?=
 =?utf-8?B?Tml6T3lCMmJjYysvQXlZYy9zM1dJQldxRmEwVkFsM2JhSVpwRXBKT3N6NGR4?=
 =?utf-8?B?QkU1aFlQOWwrMXRMZUh5ZGpqM2lWbm1mMXZiQVR0MlZUTzhsQjBjMDhuNjNO?=
 =?utf-8?B?UFhZcTVDeklNMGZYSXYwdTZXZFU4M2ZSZkh1THFHMnI2QUVoeVZTazVacjBG?=
 =?utf-8?B?RXJUeGRaOGo2dzFRblRWWG9KTHdrMVphYWZxaUZUekpqMFJXZDl6Rjlwb0NV?=
 =?utf-8?B?aGg0eFZ6Y0VsSFZ2emMwZXJuVkxneWtGUkYrYnpPMDdEVldVNGw0N1hiTW1i?=
 =?utf-8?B?cjJxcHIzOHhtUDREdWNzYllHOVdYN2VrYmNPTERWTkp4MGNUZmpVQXBhTzZM?=
 =?utf-8?B?dnV3L25nSWNYSVJGSkpKRFo1UlJhRjY0VkZibkwvbjgrai82bUlSY0JXcVBH?=
 =?utf-8?B?YXlyWlVIT25INE41aXE4MGRKdjdEeDdxek5vMnVUZ1ZLbFVOdGViZklIVGtE?=
 =?utf-8?B?WnRYbm9FWEV4UFhDbEFlTlJTZUtGM2RkdTBtVGNCMStQNFZLR1RYaFZJSE9L?=
 =?utf-8?Q?N5rP1YNzC01+Ij/xFAWf8xtUQ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7e6345b-5b54-4c8c-bd2e-08dcc72aa57c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2024 06:28:36.1683
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1AMdSTwkHabdg0kat0dibDT4snieaBgkNaSanxIJASTT16fMK6BehSkmFH/bhqSps/UwyJ81Q+kdOvt4DyHryA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7989



On 8/21/2024 11:07 PM, Jason Gunthorpe wrote:
> There is struct protection_domain iopt and struct amd_io_pgtable iopt.
> Next patches are going to want to write domain.iopt.iopt.xx which is quite
> unnatural to read.
> 
> Give one of them a different name, amd_io_pgtable has fewer references so
> call it pgtbl, to match pgtbl_cfg, instead.
> 
> Suggested-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>


Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>

-Vasant
