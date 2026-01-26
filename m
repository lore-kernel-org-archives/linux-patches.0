Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012035.outbound.protection.outlook.com [52.101.43.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A50662E54DE;
	Mon, 26 Jan 2026 21:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.35
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769462405; cv=fail; b=kYexFReICt51F9YBibwm/qllUipgos1T3wJqLecdj7lrSNKgMi6clrMQfoCUIDWbDIHM9R7xwHcU1fd7z4GyGOyX0VLLJGgaCDdcEHoCSC7IHY+zc2OqiijPyN6I8U6/nIwnGo3Wev3siMRR5SIh+Wa35l/f0A0N1o5x0FT1E8g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769462405; c=relaxed/simple;
	bh=NiPYHOYnP0DYPhoH1kclvtB5vM2yw2uMX0mnDUxR9Ug=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=U8YnxpFbkAi7EftG1ODULIfGgMmTMKnPlWVnkV6F50Il1flDILi8wKvkj4B0aV1DWmNn7SyNylYVdM8dn0M/bLgN53qDrmCZ8go5OFvhWH528a1r5eOIATBe0RcXzsBzH+5nsv+Y0vE+4yfm2X0Opi4Oj6ND04miFaHpWYsD7J8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=lFhV/N+G; arc=fail smtp.client-ip=52.101.43.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lFhV/N+G"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kG4cZQleb60Dja4Iq8tyRitzSli1apt2iXV3NOZamF0QrfEBTJ+JmEXHQuRgXmhXoC8E3+YdYGpFDPGhlWPqPer0vV2nb062B3WK4lM9FcfEWHFX5bsDIyIw68c2prV02EAT+TCx9YYNO0pBXooOktTKrpnpfog4+f5aj8UcSzfNnEf/cnI7dEK1X9g+tUTOQxB51OU7dEr7XDvNR4SxQ3U/bogxKn5NR/Bcr2+gklBofCp/NJAlFIxexCKPAahaw/91thfdVLos5Ah2w7etoRU7AfUQVqzU7yMvxA4xhOFNI5wYME/uje4eaJgcZB1gH4Ozokidm9RjH4NUn5GGCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mWQQzXMs3m8rBQyTA+32bJ2mc0MTp65jPW+GQkTPHqk=;
 b=pKnL/zyxFXIDj0sB1Rk7rJF4NCBq3d0pxw88yHnulLqDIOpI3IPWnyDo5UTVR5MIcBSRxpoBUjGkhCU9vMcSzLssJFg3wOtmFvc3OXVUuQKIe33Y7v+Jpz7AZLjD/6vUZ1CdKWf9ihRbIL1LGCfOUwaMfoiZQjTr4cLl3jjMAqMjvZiDmq9vrVRgKXNyHe6m6TL0yMZZ/tKo3KRSrXJY0fQBHNCrzyZRgsCNaowiT81xuoYDtgGe7RpCfjrTRO2vyap68rm2qxKTIr8zg1ZnyDL7iB5uyWUO0vbl4IMWpMIAPnjvbtEEpxzDCwQ0hNf++gtYtD/qrQ28MxpbkmCn1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mWQQzXMs3m8rBQyTA+32bJ2mc0MTp65jPW+GQkTPHqk=;
 b=lFhV/N+GGAT/DRNPKd13mU58F4txh04gI6oa/Ehm7eiTCD8L577bqyrA0fNCxVOvyeWUVYjpG2S4a/b6UDCbinCFF05DklYpYpZ8IjuC0Z0Yy2A5RdJKtqtdRuZg5Na+M9EbOfkmlBZtNF6stYpvaNz9AFqj4vjRYgxgGt5K1e7e/TuONZGL3JJf5LM+HCYw/hkbh+r7JC2unfvKEZsiSvWmVSsfhbmN0JypD6VtySxXeVDQkG2/75t7LAmocvJ5T2aHNLOpplmzEsuiguuINj8GO+ARZjod7gbZVxz0LULBstbRJtgNN3ekO0K0lgWXB57UvnkOmP2yVUE9ptFusg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by CYYPR12MB8922.namprd12.prod.outlook.com (2603:10b6:930:b8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.16; Mon, 26 Jan
 2026 21:20:01 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c%3]) with mapi id 15.20.9542.015; Mon, 26 Jan 2026
 21:20:01 +0000
Date: Mon, 26 Jan 2026 17:20:00 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: will@kernel.org, robin.murphy@arm.com, joro@8bytes.org, jpb@kernel.org,
	praan@google.com, miko.lenczewski@arm.com,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v2 07/10] iommu/arm-smmu-v3: Pass in vsmmu to
 arm_smmu_domain_get_iotlb_tag()
Message-ID: <20260126212000.GC1134360@nvidia.com>
References: <cover.1769044718.git.nicolinc@nvidia.com>
 <813abd4f054c21f1bdb4c26999ecb46eb54f266e.1769044718.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <813abd4f054c21f1bdb4c26999ecb46eb54f266e.1769044718.git.nicolinc@nvidia.com>
X-ClientProxiedBy: BL0PR1501CA0033.namprd15.prod.outlook.com
 (2603:10b6:207:17::46) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|CYYPR12MB8922:EE_
X-MS-Office365-Filtering-Correlation-Id: 851a6ba2-78e3-44a3-082c-08de5d20aa4c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BjY4SwxN2VLhWh9nkjoRwxiwXTWyzcv8BEyjqRmwZffK1vjIsF8rie08PQNW?=
 =?us-ascii?Q?yojQ4R9XCwkhsaWYp+t6XTebaCu3wTjN1C+dDElhY/aPDYXPdybzSJ17hUPz?=
 =?us-ascii?Q?aZ5FhGwHQLFDYiZleRjQ2G3X7UoNOZfSIgNUitt/ajD1QfrAhgJdkG5GAtfT?=
 =?us-ascii?Q?JsIK3Lwdp4UOKzGSZdG7q7nL0Tp5+OnDVaIZiJqzpB/XbllvAl689U0MPDw9?=
 =?us-ascii?Q?3FK1Yrz46uInsz25xrLPYWRwUoF2soq8s2rEIuwdMwOZ11mqJ4AzMRIp78/K?=
 =?us-ascii?Q?CEEFKheG3w3fl9NCcvB0CNZMKr6z6eoXUuSbI0C/Aoyey7wSMzka1uJ94/Pr?=
 =?us-ascii?Q?ZRNJ9zMqKy6mcDWsq5jX9lu0HiuDLqugdabzBcdyPW0+WtDt8vGEcq0SWIcg?=
 =?us-ascii?Q?C/mmghOpjWGPsPyDW9nCx8jG4UMgHQ3cleS1QRwwY7i5Zwx2Mk6idCM6MRaq?=
 =?us-ascii?Q?psggY/JiKaslY3VQS5W/EZaFBKvDH1QpqTkAJHeCZuVFTWwt/dIfggQr7GCH?=
 =?us-ascii?Q?f/Zi6qoB0aQdBLSX2XRpQkgfySQs7xyZGbiaycxqYF1JIXsE6adsrzjNHX4x?=
 =?us-ascii?Q?RRqahP+SaY0oeIkTdS1MDd90qm1V3kkLDVHgvXBVhKu0ZW2KlhfBRB7489i2?=
 =?us-ascii?Q?5QEo8okeFSzeICcQ8SeHmwc0aj5wxhx2q+bEtx3fqlMGrQkIwjuCUjYENC/W?=
 =?us-ascii?Q?DARq6P6ffgrI07quekqgDDdZ155FS/kVUvzxJKuRcd0o6B2qER8hRNfC1zyD?=
 =?us-ascii?Q?/zg1d8F/PsaxYD8H+tsd7iJo2jqC2Ye47q05J3067CjF6iT0O3LkrGXwLVYu?=
 =?us-ascii?Q?2RIYd6EcjHL/i2K1V+qRuz2RqfzG6egZZgFs6nhZIWclJgh0agZwr90tiMrg?=
 =?us-ascii?Q?9VEV8HcKPqb4SkXs/D8KF86Sq3rx9MhCG5JgsWVSGf0JcTxL3lSb88RHT0Kr?=
 =?us-ascii?Q?G0cqVpmwxDQy4VBAL4DG7GZa0Y2yZ6J4TqhB2KH/0V1jEq3IcPgi6y2bSA3s?=
 =?us-ascii?Q?YtTPuEAGxWZ4HpDKWfI0FkKbGaVebF86A9rzdJdesGgUP3EzRrStTf0jzrvr?=
 =?us-ascii?Q?md1QL3aH56J9uWPkjeW0d2Awpha5KWB8fG85e8Wk8K38QNsarKVosNuj+kSF?=
 =?us-ascii?Q?1XUDg00NA93lqcnOUZ/tLRI3MFwjksWdvREpj0yi1VaMd6NTRGNP8odZ+42c?=
 =?us-ascii?Q?yjSD/HeJm/p8gD3UBrGuEqD9IRRUN7MWpJfssaV7ZsSeQZWQoteIjWIsankU?=
 =?us-ascii?Q?oRCznpruWDR6mQvsXFuBDJDzW5rD5+E6KlXzlsdRXsiw7J0qn1qTu7oPzKq/?=
 =?us-ascii?Q?0O1IU/MnSDZwSXoIie0jyNcJOMcIfWRKkkZIsBcn/tjZhbJGecdgq6H21vpx?=
 =?us-ascii?Q?bPkcLIi4VAGfJewGrnIMtNVPvPzHCKsGcd2TsLESLVBXMqXYCULinbDaLei9?=
 =?us-ascii?Q?DsTiKT+vmLhTJKEOFiiNMT0O+CD2Se+aSv6DP+/UnCSB+awjAzJP1vTWf3hb?=
 =?us-ascii?Q?JZC0dOqzmHhkNX2KYCi2OKxPS1VrwFUO0GS7daO0vU6rIIlEStAZ16aQ39QS?=
 =?us-ascii?Q?4Fxod15YHGSRohDsWUg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2cyBjyf6SPYm5oNKpVJBOpJiVP9blxv+jTdZ5tQGQ5tq6ugckTbYdk+pkXvU?=
 =?us-ascii?Q?QAdpGpFbCm8vVB+d/Wseb1A7KrDD+sVZ7D32enA1MwmUb3g5OdmSYjidJDp6?=
 =?us-ascii?Q?vqFi4uNXhkDigCF5wwBdCQJHrYC0nZDlOvdDiuCEaSsJxCoaUwsvtB/OguRj?=
 =?us-ascii?Q?cxynzOurf6WynW0l/v7420Hh5ZZ1Gi+5+Us35Bv4WOJnVJsOeaI4A3z48SDH?=
 =?us-ascii?Q?RBbqKCFNXEzYtCZEVz0rr34OPU0Q6xL/yuLYZFmK2+OXO/1LoStHTYPs9ZUT?=
 =?us-ascii?Q?1eoJ/UJeKLc6r3h7Ae15J2H+1vQdgO/XTOHY67rn1+BLPoHIuZBz+gZH1whR?=
 =?us-ascii?Q?bMHxWD8Xjgaz8kgREx0jsYtf2Q5JIUFFjEb+zj3ijZIevTnwW48/9F0czNfQ?=
 =?us-ascii?Q?r2c7BoXI5FMD2vbL6SlSzdFWLDhRxncOi1tJW/6Vis1AfmlFXzVao65lQMga?=
 =?us-ascii?Q?L08vUVU8O+MMqEy/SSVaZ9Uzay5DhxGpFVPtk9fUNma1OsKWkgTFeeqTcH9G?=
 =?us-ascii?Q?OjH+T8KWeS/9GGFTQkSfLPFYu0+8Y90fXAJkM6UEaAFsCoAzgiDDQSYlWkp7?=
 =?us-ascii?Q?3+7Xrmo4uKZME/fNJUc9nDBwB+Rq8f3kdcynvWVv+fyUp4NFZYdI0d5cbNmQ?=
 =?us-ascii?Q?HYRqlRso3zT5aPLm7q3tGL9VrObvydbAp+jPLwWo2r545cc5kJEfUpkdAz4I?=
 =?us-ascii?Q?9OURvbF1GBgGOiHoJjqQAywM2gAoSDzsSFCImUBNlxLArhVe1JGsVPJI6yGb?=
 =?us-ascii?Q?K3bSaWcid4+oiTBNtR40rPEUf6mOHBxq3UPFnp0h1JAOYArn2GxHYcizCgyY?=
 =?us-ascii?Q?GroB1Hftr1mXfpwzvnsDwBVSHhCTlZlPe0NfqTpwlvYgKzMKVoNw3gZVhtJN?=
 =?us-ascii?Q?5me9KkIR8d0NVuppSC57P/xWvUCH51vG4n3VGnLZno3pRFbasUKqfeX0CPn0?=
 =?us-ascii?Q?ykYrmqXzMzaRZWp9sv/5UOUlBVkt39KEM4vydYkeH3APQAowZZzYhsh+0sBF?=
 =?us-ascii?Q?oFtlwVP88fh/ZX06NVVEVmjK4BR0Vnn4aNMhVSm6Us2E8Zi2o+09UjIigbEv?=
 =?us-ascii?Q?jdPJkwQBQ7Z6MkhahrQADX8252BRyw2oj6kmy5h7CgxNkVWugNkHaS8LK7is?=
 =?us-ascii?Q?1/HTYa/RwYi775fg0FUdxNwTvwC59CURfWhEdKVYGGRuUaMSTGy7fvElqriJ?=
 =?us-ascii?Q?lVWruH9Pzdssvs2sFxfdg7oyBtLtk5LBZLZhsE61jk7xOMsoAhusz9ZxM1Q0?=
 =?us-ascii?Q?S8moRxoYfFx43VJHCvyciKyKaCA+x3/6stGmcEU5iCD75/JXyvP6XKo/9fdL?=
 =?us-ascii?Q?S2jdGxTs0DmPtqJY9THiB+M8xpuVO6Q+/oNBriACHuKVescqTyNQZs6wFkPY?=
 =?us-ascii?Q?B4wP/B1BciraqP1n0HEeA4P3oSTfvtutnqgP0D+QHY/xY4PkkMVy1ue/Joid?=
 =?us-ascii?Q?EVrvk7uW5zWD3HyaP+uaFNbSwaRTSacibEHyxL36z3/eeb/vxFeUxHsqO2A8?=
 =?us-ascii?Q?bAspNv5ebbVrJFZj18+D9pLtcyiifzTXSskYSqvi5ZajYNFPsLekBJRR71oY?=
 =?us-ascii?Q?Hffev0/Pr7MGxewJABR9lzyTLby41CstInM2j3dJDPjgC6s9a6T+jCLcxIBy?=
 =?us-ascii?Q?TlioXETYVeAiyy1ro40Ugep3fDBYq5fTllG4HQMTHuKUEheBOoHJh0eLs7Wu?=
 =?us-ascii?Q?+wxmnQpDnGvwlFRbWsq6yoM8/vXiUv4+Bozq3ssmYSg8qTCx5sV3+JU8VVTx?=
 =?us-ascii?Q?BmxzlgMWVw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 851a6ba2-78e3-44a3-082c-08de5d20aa4c
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2026 21:20:01.2576
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PC7DDYKnkO9gVuCRMP/qeeBys1Dc4KGY+zfYcAFznLUl34poTUHC1phC0bMkZY+y
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8922

On Wed, Jan 21, 2026 at 05:24:25PM -0800, Nicolin Chen wrote:
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index 5a7032081553..8323f74c8923 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -3137,6 +3137,7 @@ static int __arm_smmu_domain_get_iotlb_tag(struct arm_smmu_domain *smmu_domain,
>  
>  int arm_smmu_domain_get_iotlb_tag(struct arm_smmu_domain *smmu_domain,
>  				  struct arm_smmu_device *smmu,
> +				  struct arm_vsmmu *vsmmu,
>  				  struct arm_smmu_inv *tag, bool alloc)
>  {
>  	int ret;

This all seems too complicated, the domain passed in should have been
a iommu_domain, not a smmu_domain, then you can just do

if (domain->Type == IOMMU_DOMAIN_NESTED) {
  struct arm_smmu_nested_domain *nested = to_smmu_nested_domain(domain);
   tag->type = INV_TYPE_S2_VMID_VSMMU;
   tag->id = nested->vsmmu->vmid;
   tag->smmu = nested->vsmmu->smmu;
   return 0;
}

Here and everything is simple.

Jason
