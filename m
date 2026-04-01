Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010041.outbound.protection.outlook.com [40.93.198.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE9F53BE162;
	Wed,  1 Apr 2026 10:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775040040; cv=fail; b=XK7vEjMlcGPdHwCjbBNM7X/+rlhcdh6Tj07nSpHOiGaaVG4U/eGTcyQkKRE+yQdoTGkCRbspfOl3J0Eyh96XCUbiffYkyGcMJwoAZR7Xgsbjy1NSm0rdg2WtXUuZziddIKZttfqTzbWkpDwe3l2/3RiRrHLkJalK1NEXDNorEY0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775040040; c=relaxed/simple;
	bh=ulkNmF/gF/hmgYBtKTAA9NWqCb332CtCLYO/c6Xac3Q=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rmHVNT/f3D6ysf3HvyulAmM/0FtUEYGUj37JZhJhLmJ36PZshroDQDBT9gGrlu+R/QnG7xITbawimeTtPm5agzeIo0NCWvEn+45m+Ys61JZPwbVBXXofUsXYIEORvkVAaWKArKP9A6ZUhx3++hKzcUwFS1ZAHXN4Gvx7kpmA91Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=lbLFSEB1; arc=fail smtp.client-ip=40.93.198.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lbLFSEB1"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pix2tM6fEo22SZebP26QTTO7iiiq33tNpDhYMoJ7hSOSU8opGVrIhvxj+3K4KiXBeXOVtC49TSwohc/O06hQ9B/EnzUkrxco1pKE1ZWEKRPBvca2bVE6NuUyNriHggD/utl0JPRTASPhwBL70JpSlWAuMw+qH3zvQfGdnao5nPHquxGPqf0oFdIBQRwgAUBpqv2id3eXETGvSr4+WlQ8t5FI4k86rw4zJOd1Lf5//7joV9QsjxBtPaHtHoMf+bYAKmZckAfLWRCSFyya0z9Np5v/sP4dMcu7/1H4mQa59Rrt0+2/IoVFRl66dgi0u9+19CzZw2Q1xGettum9fc6UWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jz/chB0QzApuayglLthI+iSbvWAVwplpofNPCzCfxPo=;
 b=i3falHN9fKRTn7uB/mU57KdRSrgtYVkY7pti34RrEqLpr0hK46t9CBYwyVocpHEpEVEB/to/yx7lugG9v06/d5B6608QcyBYcZ/bdqYBmVXsW0Tctc37EjJYDO3JzkvJ2YyKXetUoGCtnOiS4MKC4JHNsCVyj4pDJokbCODaocpd95ibibBpfN/QOj9HlCLQy1IQdoIJRPiij+0AiASzbXCEaPkqCc/S3tOfldx6nkxjyeS5LXCmiU6PgO2M7n7D2khF68baZpU5gpHlYucP3fqGimS2s9VoHljPbjy0KLH+40SP3jNMiao8aMxeRldZwZrxlXIHHitnAvtqVw5q1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jz/chB0QzApuayglLthI+iSbvWAVwplpofNPCzCfxPo=;
 b=lbLFSEB14V8UfsVfsNWSEKSO2+KACrCrBhsndo1NwYyvX7OXFNTGVB6OB9DRzAh1ySlrs0njlVS7arZD3SIc9arrKVaPH3BVaDbHP5oucetTtFcsTdRuAp+RnwnhOTv7LD/jV2Jf81DaTdx9axPazfqHCnSyAkegeJxVtd3UtekszJpEuwrtFFuioNRHv19AmuEIBDg3A3cBIGlod3K+SWef4aE2fWq84STkPnOjmsoMrqZx8ScmyHExCiMplo0aZUFboARmvxAisUkbURjNx8y5Gfz/uSLJGu/Z5s6joTiCN30b3BzkaHKVfz9p3yJBNfkiVJm2PF/434hv/jFsmA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS2PR12MB9750.namprd12.prod.outlook.com (2603:10b6:8:2b0::12)
 by PH7PR12MB8040.namprd12.prod.outlook.com (2603:10b6:510:26b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.15; Wed, 1 Apr
 2026 10:40:32 +0000
Received: from DS2PR12MB9750.namprd12.prod.outlook.com
 ([fe80::56a8:d6bf:e24c:b391]) by DS2PR12MB9750.namprd12.prod.outlook.com
 ([fe80::56a8:d6bf:e24c:b391%6]) with mapi id 15.20.9769.016; Wed, 1 Apr 2026
 10:40:31 +0000
Message-ID: <836a2750-579c-4134-9098-c39ab0ffe856@nvidia.com>
Date: Wed, 1 Apr 2026 11:40:24 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] iommu: Always fill in gather when unmapping
To: Jason Gunthorpe <jgg@nvidia.com>, Alexandre Ghiti <alex@ghiti.fr>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Albert Ou <aou@eecs.berkeley.edu>, asahi@lists.linux.dev,
 Baolin Wang <baolin.wang@linux.alibaba.com>, iommu@lists.linux.dev,
 Janne Grunau <j@jannau.net>, Jernej Skrabec <jernej.skrabec@gmail.com>,
 Joerg Roedel <joro@8bytes.org>, Jean-Philippe Brucker <jpb@kernel.org>,
 linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org,
 linux-riscv@lists.infradead.org, linux-sunxi@lists.linux.dev,
 Matthias Brugger <matthias.bgg@gmail.com>, Neal Gompa <neal@gompa.dev>,
 Orson Zhai <orsonzhai@gmail.com>, Palmer Dabbelt <palmer@dabbelt.com>,
 Paul Walmsley <pjw@kernel.org>, Samuel Holland <samuel@sholland.org>,
 Sven Peter <sven@kernel.org>, virtualization@lists.linux.dev,
 Chen-Yu Tsai <wens@kernel.org>, Will Deacon <will@kernel.org>,
 Yong Wu <yong.wu@mediatek.com>, Chunyan Zhang <zhang.lyra@gmail.com>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
 Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>,
 Joerg Roedel <joerg.roedel@amd.com>, patches@lists.linux.dev,
 Robin Murphy <robin.murphy@arm.com>, Samiullah Khawaja
 <skhawaja@google.com>, stable@vger.kernel.org,
 Vasant Hegde <vasant.hegde@amd.com>,
 "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <0-v1-664d3acaabb9+78b-iommu_gather_always_jgg@nvidia.com>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <0-v1-664d3acaabb9+78b-iommu_gather_always_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0076.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2bd::11) To DS2PR12MB9750.namprd12.prod.outlook.com
 (2603:10b6:8:2b0::12)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PR12MB9750:EE_|PH7PR12MB8040:EE_
X-MS-Office365-Filtering-Correlation-Id: 4de82710-b469-48e2-cac9-08de8fdb1926
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|376014|1800799024|366016|7416014|921020|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	r5sCks3kJjkQNB5vW5szXpL+9X0p8o23Rd/LbmGuz3H6u+bm3Cs+knt6t56JD9a55waLcDohzhZ2OoC+1qHaHPU2w0Ts0bGMb0cAIqjHhjrBG9JV0WNvIZqxQc8itXeV9vyTPbDxbVo8oaPmQI9xq6PdPGplWlu5OnT/Rif2qRil5BIYH2qVj4wWQgm44TJI3rpZ2Bhrbq7e/JAlVK6pV10W7VvFVLPwYJ0DRe3BMD/+822W6QNTp7Tm0mIYOfZS3YEnKewn+SfpLWpzwVm2pUH10DJmV3jEo2qWDgG6tf+OqhLZc5Pukx2j3yO7YDtPgmeQCR+eYxVN3ivFqTT1pXljruevZ+WU1YOQLaatmli2QQF5oiTD5qrw9EoOhFRF8pGglvD/lhh2ruLqpuLgMx7K/DDIHtFr4851C6+a++1PbNTGw/cK31zcUpcp7VPpO0bMQJkuFlAo+2Fu4lpGUOGbO1r7nN3F1SdwWtD/wBguXdv18V+uzoVuDmS9NBi160gUJA3nKGssvXEuv4cPdmTZxycfFTj89XtubkmD26jbh4w0VW7BL0MtqD3VLA4c5SZW4HNxCfK2K9BQENjnTebInV4gfQoMWgK7ngo8UdCQbz2WABx3fn+AhWgvubbdyZKhZXJNdZRp4SORIVf94+nUvvc6HBA/+1uA/dP0GlmD44RgnxcIJWzpTunhgWWa7UUgeqOHWN/JYtvlGfFPqL4bHgkxIU8Nq3YLiTO4trJUquVJBQXC9DDBBKKBvZlyPSbNJO/l/PKnTo1F9CRC7rA+vwL2CiRGJPGRxVV2+gA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS2PR12MB9750.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(376014)(1800799024)(366016)(7416014)(921020)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WlVQdGpiZDZkVE9QSlAxU2ZIN0pxdlMvQ3ZRZ2JQZ2UvREJmWi94RmhBQ2F2?=
 =?utf-8?B?ajVidlk5aElGS0wvNUNEN09lSW5YeDNVMTRtZmZHRFowVldxTGt5M2RvMGhw?=
 =?utf-8?B?b1ZWWjhjcG0vYWhCYjZsZlUvdVhlRFhEZUp4eVJqYzhzQmN1c2pKdnVRSGMv?=
 =?utf-8?B?US9VdEJta3lUSWFkZmFsUm4zN0FjWkNBeVpDZkk2dXNFenpxZnovaXZLZjRj?=
 =?utf-8?B?R0YvSVRsd05pVko4WEx1QkxXZXp0NTdvZkV1bE1oUndsTHk2c05GNlA2L0oy?=
 =?utf-8?B?N1NmQ21QZTE0QzQzRUIxaXVwRmFRK1pnQzIwUXkvVlhxdUxtUkRHaHBOT1NM?=
 =?utf-8?B?RFZjd0RDc0tnY3oyTlVrYVNTQS84dC9JWktQY2Q0azR0UnczcFFiaFVvMHVj?=
 =?utf-8?B?TnJNU3RsWlJ3WEM2S1RkNmU3M3FSbnFYVEh3eHdUUnZ6cmdjb1pxMDZFNGJ5?=
 =?utf-8?B?NnBRM3VzeFpvZXEvd29yMW9YK1UyQ1loUkQ0SEFkNFpEcjJTVUsvc2RrTS9m?=
 =?utf-8?B?UGdBUW9ZY0E1UStUVnh0RS9uc1kvNXZrdTkvUmRpOWNhSXZZV2JWTkVhRXJW?=
 =?utf-8?B?VEN1TWhNUU1KK0UyTk9xWWRIRXZ0QlNoSUFBM0I3cjRNNC9aQklHeE1QbTNn?=
 =?utf-8?B?YXVUM09WRURTMno1M2dUN3FjSVhrdENEeVRLZ0hIQmxPRmxqQVNOZG9XSzlQ?=
 =?utf-8?B?UVJTeHJmblY0ZlNmbmw3WW9rYXJxNEVGUWZMUGhjMzNqbmN5NG9RNkhnYjE4?=
 =?utf-8?B?Z1NSSlFrS0ZETnFkVjltTElTei9lQkpPVkNGQ3NjYmw3MHo1cHcvclM4Rk9x?=
 =?utf-8?B?elYzeWJOTllweUFJY3RNUittanFKczNhR0JqcXNUNU5DdmxnZnFENlVudWFh?=
 =?utf-8?B?UXkvM0lKQ3V6TzB6T3FUOVJvQnB2VzN4bXd1Q3pMR2lpa1FCeVltR2pDbkhp?=
 =?utf-8?B?Slcrcjd2Q3ZkNWVDRVBwa0kwQldBVDFNK1FXaG5XM0ZETUlMS0tFZEVnaHcy?=
 =?utf-8?B?bDVocFcxOUU4WTdHSzJsZUh1VjVFVlluMzdoUllpRVl5VEIyVW5CNGVnbm8w?=
 =?utf-8?B?T3VqT0dQVEVFRmtyWWFLN1Q3TUwwdVg0S0VKcXBsY2E2cmxOV0FvSThtT0tE?=
 =?utf-8?B?b20xZ21FOVB4Sk5lS1IvUEd1OHJZRU5QME5YQ0JiaTNEbHFVbDdaRk9HTU9Z?=
 =?utf-8?B?UnhFYnE0MHllZjZLQmkzUzl5dG9YaGpvak0reDEwQzBiTDJmeGoxc0x1eURL?=
 =?utf-8?B?eFN5eXBJVXB3SWZKUXUwYSsralVnbmN4ZjhJWVNyS2ppL2RMeVozQUM1STU0?=
 =?utf-8?B?aVQzNExSZ0xZRFFXRHR6Sk5oYzlmdjFHS3hndFUvRTBUbm9Xb1QwY1VyMjVR?=
 =?utf-8?B?a1JKOVNSZ0tDbXdWellGc0VtVWtXYkdKMGMvbTMyMnNmV0xaWWp4NjgrT3BJ?=
 =?utf-8?B?VFpzeis3c3JvMmR3ZUJ5amZTc2x2L09nbnMzeTIyMzZDUlBJTmVSM0NsOVYr?=
 =?utf-8?B?S09qQ1NSOU9UZXJrSWFNck5icldxbk1JQ3EyQWhBMEJwZ2tTVnFPMEtXbzBU?=
 =?utf-8?B?ODhCd2ZhSVoya1E5eERyaEdhNHNlNUtNN3RtYW1YUldTWXoxek1tK3lTcW5m?=
 =?utf-8?B?eFYyWVZWbVVtU1plQTcyZTZGVnRzSkU1VXB4MzBEQXZ4Y0h5RDVyTURXTG8y?=
 =?utf-8?B?L0d3eGN4dXp1aWdjbzNMWDYzMEJXZnh2UzJ4ajZBdTFrUStLYUh3QS8weVdE?=
 =?utf-8?B?aFFDY0w0NS9pTTg0L0NPcWtpR2RadWpKY3ZLOTliZVFXa2ZIdHo1UVppYmVk?=
 =?utf-8?B?b2lGbmlzeHNqS3BwVVdXa2h3SjFDVW9pak95cHl0VEJLQnYzbVJFMjVLc3Z2?=
 =?utf-8?B?WGlGV3M5SDVHTXdmcS8ySXdib3FlL21BNEI4eHRTVnhueEVLdmh2L0NCM1lu?=
 =?utf-8?B?NVRGNkViKytJTjBtU0tKVzhsbDA2dGhraTJQc0xJUEh4bmhDaVRCT0ExYUxn?=
 =?utf-8?B?dEx6ZERJeW1BaE9GZ1k2Mnh4UCtnbkN2dHJpNXEvTGdsL0JxQUZERmJkZEhC?=
 =?utf-8?B?NUZwVSs3bDFhTlVJZTZUSndCQVp1cDZiVFl2V3Y5ODZlK1d0RkNZQUVTZGNu?=
 =?utf-8?B?dmZaVFBPUk9Qa2FKMlhJT3NjTWtDNlhnZnRsQ2tXNnhXNEpza1FTdVl4NUpX?=
 =?utf-8?B?dndvQnlrNlZ4ZFdqSnFLSUdiT1RFUnh4YS9pajgxRHE1SzNBcDg0aEFKQ0xX?=
 =?utf-8?B?cmJQblEwSDdQLzQ4YVI0QjBXTmpFWkJvQTVFMHlUKzlMSDM1NDV3ZG9Qcmw0?=
 =?utf-8?B?N1pqN1BlZzFyMGN4SXZhamEzYVhQV2JteDRCbDJMQWFFcVA1aVhoUmRKZHJ3?=
 =?utf-8?Q?/2zyOY5uOwTB7yPtTQOlTRtYPWa3NRwPs44qruUSFxlyk?=
X-MS-Exchange-AntiSpam-MessageData-1: srQrK5c54H+r4w==
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4de82710-b469-48e2-cac9-08de8fdb1926
X-MS-Exchange-CrossTenant-AuthSource: DS2PR12MB9750.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2026 10:40:31.6938
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4Q9CxVQzpqkoCXe5AXDdeWG06/J7ZRyMucxGhXmkOcXjecW74nooH1rTJsdDoPF5QXH+ZUWFJrlQoV8FxwUg5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8040


On 31/03/2026 20:56, Jason Gunthorpe wrote:
> The fixed commit assumed that the gather would always be populated if
> an iotlb_sync was required.
> 
> arm-smmu-v3, amd, VT-d, riscv, s390, mtk all use information from the
> gather during their iotlb_sync() and this approach works for them.
> 
> However, arm-smmu, qcom_iommu, ipmmu-vmsa, sun50i, sprd, virtio,
> apple-dart all ignore the gather during their iotlb_sync(). They
> mostly issue a full flush.
> 
> Unfortunately the latter set of drivers often don't bother to add
> anything to the gather since they don't intend on using it. Since the
> core code now blocks gathers that were never filled, this caused those
> drivers to stop getting their iotlb_sync() calls and breaks them.
> 
> Since it is impossible to tell the difference between gathers that are
> empty because there is nothing to do and gathers that are empty
> because they are not used, fill in the gathers for the missing cases.
> 
> io-pgtable might have intended to allow the driver to choose between
> gather or immediate flush because it passed gather to
> ops->tlb_add_page(), however no driver does anything with it.
> 
> mtk uses io-pgtable-arm-v7s but added the range to the gather in the
> unmap callback. Move this into the io-pgtable-arm unmap itself. That
> will fix all the armv7 using drivers (arm-smmu, qcom_iommu,
> ipmmu-vmsa).
> 
> arm-smmu uses both ARM_V7S and ARM LPAE formats. The LPAE formats
> already have the gather population because SMMUv3 requires it, so it
> becomes consistent.
> 
> Add a trivial gather population to io-pgtable-dart.
> 
> Add trivial populations to sprd, sun50i and virtio-iommu in their
> unmap functions.
> 
> Fixes: 90c5def10bea ("iommu: Do not call drivers for empty gathers")
> Reported-by: Jon Hunter <jonathanh@nvidia.com>
> Closes: https://lore.kernel.org/r/8800a38b-8515-4bbe-af15-0dae81274bf7@nvidia.com
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   drivers/iommu/io-pgtable-arm.c  | 4 +++-
>   drivers/iommu/io-pgtable-dart.c | 3 +++
>   drivers/iommu/mtk_iommu.c       | 1 -
>   drivers/iommu/sprd-iommu.c      | 1 +
>   drivers/iommu/sun50i-iommu.c    | 1 +
>   drivers/iommu/virtio-iommu.c    | 2 ++
>   6 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/iommu/io-pgtable-arm.c b/drivers/iommu/io-pgtable-arm.c
> index 0208e5897c299a..8572713a42ca29 100644
> --- a/drivers/iommu/io-pgtable-arm.c
> +++ b/drivers/iommu/io-pgtable-arm.c
> @@ -666,9 +666,11 @@ static size_t __arm_lpae_unmap(struct arm_lpae_io_pgtable *data,
>   		/* Clear the remaining entries */
>   		__arm_lpae_clear_pte(ptep, &iop->cfg, i);
>   
> -		if (gather && !iommu_iotlb_gather_queued(gather))
> +		if (gather && !iommu_iotlb_gather_queued(gather)) {
> +			iommu_iotlb_gather_add_range(gather, iova, i * size);
>   			for (int j = 0; j < i; j++)
>   				io_pgtable_tlb_add_page(iop, gather, iova + j * size, size);
> +		}
>   
>   		return i * size;
>   	} else if (iopte_leaf(pte, lvl, iop->fmt)) {
> diff --git a/drivers/iommu/io-pgtable-dart.c b/drivers/iommu/io-pgtable-dart.c
> index cbc5d6aa2daa23..75d699dc28e7b0 100644
> --- a/drivers/iommu/io-pgtable-dart.c
> +++ b/drivers/iommu/io-pgtable-dart.c
> @@ -330,6 +330,9 @@ static size_t dart_unmap_pages(struct io_pgtable_ops *ops, unsigned long iova,
>   		i++;
>   	}
>   
> +	if (i && !iommu_iotlb_gather_queued(gather))
> +		iommu_iotlb_gather_add_range(gather, iova, i * pgsize);
> +
>   	return i * pgsize;
>   }
>   
> diff --git a/drivers/iommu/mtk_iommu.c b/drivers/iommu/mtk_iommu.c
> index 2be990c108de2b..a2f80a92f51f2c 100644
> --- a/drivers/iommu/mtk_iommu.c
> +++ b/drivers/iommu/mtk_iommu.c
> @@ -828,7 +828,6 @@ static size_t mtk_iommu_unmap(struct iommu_domain *domain,
>   {
>   	struct mtk_iommu_domain *dom = to_mtk_domain(domain);
>   
> -	iommu_iotlb_gather_add_range(gather, iova, pgsize * pgcount);
>   	return dom->iop->unmap_pages(dom->iop, iova, pgsize, pgcount, gather);
>   }
>   
> diff --git a/drivers/iommu/sprd-iommu.c b/drivers/iommu/sprd-iommu.c
> index c1a34445d244fb..893ea67d322644 100644
> --- a/drivers/iommu/sprd-iommu.c
> +++ b/drivers/iommu/sprd-iommu.c
> @@ -340,6 +340,7 @@ static size_t sprd_iommu_unmap(struct iommu_domain *domain, unsigned long iova,
>   	spin_lock_irqsave(&dom->pgtlock, flags);
>   	memset(pgt_base_iova, 0, pgcount * sizeof(u32));
>   	spin_unlock_irqrestore(&dom->pgtlock, flags);
> +	iommu_iotlb_gather_add_range(iotlb_gather, iova, size);
>   
>   	return size;
>   }
> diff --git a/drivers/iommu/sun50i-iommu.c b/drivers/iommu/sun50i-iommu.c
> index be3f1ce696ba29..b9aa4bbc82acad 100644
> --- a/drivers/iommu/sun50i-iommu.c
> +++ b/drivers/iommu/sun50i-iommu.c
> @@ -655,6 +655,7 @@ static size_t sun50i_iommu_unmap(struct iommu_domain *domain, unsigned long iova
>   
>   	memset(pte_addr, 0, sizeof(*pte_addr));
>   	sun50i_table_flush(sun50i_domain, pte_addr, 1);
> +	iommu_iotlb_gather_add_range(gather, iova, SZ_4K);
>   
>   	return SZ_4K;
>   }
> diff --git a/drivers/iommu/virtio-iommu.c b/drivers/iommu/virtio-iommu.c
> index 587fc13197f122..5865b8f6c6e67a 100644
> --- a/drivers/iommu/virtio-iommu.c
> +++ b/drivers/iommu/virtio-iommu.c
> @@ -897,6 +897,8 @@ static size_t viommu_unmap_pages(struct iommu_domain *domain, unsigned long iova
>   	if (unmapped < size)
>   		return 0;
>   
> +	iommu_iotlb_gather_add_range(gather, iova, unmapped);
> +
>   	/* Device already removed all mappings after detach. */
>   	if (!vdomain->nr_endpoints)
>   		return unmapped;
> 
> base-commit: fcbe430399ca5c318e99bfda6df9beee90ab051c


Fixes the issue I was seeing ...

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Thanks!
Jon

-- 
nvpublic

