Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010039.outbound.protection.outlook.com [52.101.201.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D15A3B0AFD;
	Wed,  1 Apr 2026 17:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.39
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775065018; cv=fail; b=vAvPPPtYZDxSyxfYSaPEDDDYx0zWXb7BJZnm2bqUEijF9tkAHkc+ngU7voZSlyqRCg+MroldnPuEy2vGoovm8AJA8gknu8by15WRWML4igOESMapTjBcqAJEXdWxqz+QjQ/jithQBborfyf3SLEObeqFQSm98eujY2ZBVAkh60E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775065018; c=relaxed/simple;
	bh=vz1n179LJmO6ow1C+4igcrtUuyxM2a+XnEuW9v1BDbQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=WBFgQ/0/9j15e9z402ANyK3Y7ZsG3P9nV9NO+AsvYrGD4cSpqVFvqIVUVyamYjqvCm5C5mFZdKYFWvjQKWSixH0Gf8wdAjf+rbM/E0PPMhDikqjTyzLl3beaQ8fxyAG9/JCsTU/3rSi/l4BjZh693aojY0O5K6GzIgi4EFjZSiE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=q4DEFYep; arc=fail smtp.client-ip=52.101.201.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="q4DEFYep"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SxM2maOj83b0d5hxQMNInmztqGRJibEJZPdS06VfJfg05HlR0S1Eg7+Fk6tP4CSYLaUAPjvRWzuqpT7uosGSjdH/Ehppa1b7adT3dIjffFsKxv/sJN3OSkL62YztNY2gjiEuCPa0L3psvnONfLtDMwX5VZ/1at5UJvx38I5KHktypFqGZ2uyf/ZjSN9CbI5kLhiOe6v7EM88TmDKHi46l/V1e86LGJtcy9fEGT6JH9leWd8CP4tlpp4fPsVGUreTWVzewXNxJjBENf9FWxtJT5FwIlt5YDOSN5ijS3nlhJg1tUA086Q39EzdUqNpVjNEOPKOLKDGouPfhdV5D9vpmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a8ocrs4T5ioB4gcna5RJSflFqO+GeKr4bXA/KoHdINc=;
 b=NCW4dx/wuZClatF3TvNnwb+rw6wFs9pFG4NQXMWkNLmlH4+HoGf/bAmre0a/fahsAtaVJ65InZaS+AhKHbnLXMtO1Vn9DqWBjFS0KuJsgym5B4MsBa7unffUrDfuVwMsTGqtVVLWdFddNzygpdnssKN+A3i15NdPIVoGYFsbLSWkGY9iMiY5fw1x09bW2hj4d1y7bTHL5q3zsNX46pK3PMp9enmB+hC7Ko9QmF5eQnQDP0aSetreWbKkn69Yy2tv2LI128HTVC2oLqNi9YotlNTipM+ZENFEJhcqJpgYUMogJ1XXVZLA7ODV4zZayyo+pzjoO0FN7hhjJX0IbSxL3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a8ocrs4T5ioB4gcna5RJSflFqO+GeKr4bXA/KoHdINc=;
 b=q4DEFYepsP2s3p8POcQ/7xLtw//iBrvOYnkUPdPTe0PBmglJ7MiDa+Gs/uwk6vBFaOKHLEaI9JspbVRQ+B1xLBXx9BS5O/ny5mPKI/WJf0XvXvDXanB/AziIvAfKLfV3GQdS/L7l/9kd72UkU3G/PeoKBSLjLTzf3G6CIKiBXRxiQ/eihXpxl/nQRNKxom5bXAo4mYWUvJYmIAprEJHrVluUgC5YwG++dckjIyCybzvvvl1Zm0GyKYOI443Fx//+7GznxjVf1pKBmvHSHFbVdmfGwk7JWNICZjvGeP7uG9TbDhzKoTnhXuhOqf2vVpWslHPIj81dyO0PY0Bp96ed1A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by LV3PR12MB9188.namprd12.prod.outlook.com (2603:10b6:408:19b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.17; Wed, 1 Apr
 2026 17:36:52 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9769.016; Wed, 1 Apr 2026
 17:36:51 +0000
Date: Wed, 1 Apr 2026 14:36:50 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Robin Murphy <robin.murphy@arm.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Albert Ou <aou@eecs.berkeley.edu>, asahi@lists.linux.dev,
	Baolin Wang <baolin.wang@linux.alibaba.com>, iommu@lists.linux.dev,
	Janne Grunau <j@jannau.net>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Joerg Roedel <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org, linux-riscv@lists.infradead.org,
	linux-sunxi@lists.linux.dev,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Neal Gompa <neal@gompa.dev>, Orson Zhai <orsonzhai@gmail.com>,
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
	Samuel Holland <samuel@sholland.org>, Sven Peter <sven@kernel.org>,
	virtualization@lists.linux.dev, Chen-Yu Tsai <wens@kernel.org>,
	Will Deacon <will@kernel.org>, Yong Wu <yong.wu@mediatek.com>,
	Chunyan Zhang <zhang.lyra@gmail.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Jon Hunter <jonathanh@nvidia.com>, patches@lists.linux.dev,
	Samiullah Khawaja <skhawaja@google.com>, stable@vger.kernel.org,
	Vasant Hegde <vasant.hegde@amd.com>
Subject: Re: [PATCH] iommu: Always fill in gather when unmapping
Message-ID: <20260401173650.GD310919@nvidia.com>
References: <0-v1-664d3acaabb9+78b-iommu_gather_always_jgg@nvidia.com>
 <ee2c2044-e329-4cdd-ac35-9365824d3677@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ee2c2044-e329-4cdd-ac35-9365824d3677@arm.com>
X-ClientProxiedBy: BL1PR13CA0171.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::26) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|LV3PR12MB9188:EE_
X-MS-Office365-Filtering-Correlation-Id: 4213b8d7-188c-4a4c-2c33-08de90154269
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	b3h+N4/EQ+SSFkWEPdZ/vA4Ojml7XNb7jTdobmvgRvlxRerYHMrqyiW5///T40fz7Kzi5dr9OmSV4YvoLOwwva4eiE/eT+sL7NYk36YJ5N+ImFkmmoTNzXi5B2BfptFjrc16lyDV+d3AM56enCOVFwHCB+nIIT7bFw1TCTltlSHBVf4khdIUA5VKHqtnYc9XxVzv9te9BJarFc6UtiXTv0EMdVF5gfh39brX3rkECCNmV/oYLqunvnJaQpRjtMYNIX+QDBbrEngsexmm1YG1MMJ7bVIz7mCDbECVixj5esZwxxUmrpB3RJNzfrGrQlq6jMJnzAn3T7Vqb5CkHfkD/p2dAmRgVogVjgqQpdhQ/eSj/EiF6kFoU+ZyICZuz6fJ6m/A/YaHOpMI2YInORiAYMeg1pUIR18aft6LmmaiXK82rpEq2aoECAg9+/veKCnOpYS1OCf2lg9SFeTwiksEhhhL377oz2xIVx2lhu5Mhir11gKtPAwYQyQdyvk8S+VQCrgVWHJuOv0zppvuuvqZdYlpuUEZIoSzB34uhzTSjNg4J/sgwbRF8MwEmtIKPeE+2XTyjY8YfElYkv8ri0khQAQtNke/uOkCcH7pj66wLqpGGY7GVqAGgkTgLxH1+izqqovyeLr22K0aOQRp5vE+ymTXDN6S7NOVNCFQLDr/26jmblUxEQS5GvZ2bDGPl1+HkdGwmO6FOAsclYg296nxVy4Hy4qvHPJFJNLFk1SrpAQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+b/n8Baqi+201j4Y+dQgc8bFc2lRNtCmQP2s7qbDJPmfeDnXa7nkMWIIiO2+?=
 =?us-ascii?Q?hbomudAWjGGl1j+iOKZhqDCzYGT82FGDAvhEZWoKwQ3m/QxPdWdvfyMSPyUM?=
 =?us-ascii?Q?ZLhSvyMFi/Y4u/6XhBhLzIJB3RBjO1DDZgAabA/IQhVMeT15GEqn4ICfFNcS?=
 =?us-ascii?Q?EzpTN8SN4jU6vb2FYRbFtARoedLKjflxGWpGMHKgBLpYOLTF7HDDpE5B+xXP?=
 =?us-ascii?Q?5cDePlkACXrXydNEjjlHhCexWwFfpO+ziTWedWl13l10JoVgkc1a8pFZHE0V?=
 =?us-ascii?Q?xIYm6cCVi1v1z121GIg4sDwV2/DkB7qer45N0HH85oewJzVK1AOvYoL9HqWH?=
 =?us-ascii?Q?2aLTt8008v3dpgiHuvbhVLKUBCtkPMegDurqwBW8T6Vc/4LA1kBjzQADysZz?=
 =?us-ascii?Q?/ZwqFDfPFXTM6z8NzQnt6dyGH+YhF5nU57QlT5NeWkSCcfU7ewSGprK7YKGW?=
 =?us-ascii?Q?17776Sqk6FZ3iJ1zUwwAn6kzkh0xrYAKFAUEE/x7AknMeDXpb1F4hEnOwqQy?=
 =?us-ascii?Q?vBotWkqsuZE+z4JOPn6a6gx5jTUfiD1V9PQ704Xr5+UfS7JAN6d5TAQCidj1?=
 =?us-ascii?Q?MVVjNhxbvpvV/q+jHYvpI3NVgw5bDKqryYKeBqWoPNDP/FbjI5wvsKw0vwAJ?=
 =?us-ascii?Q?GxHIyVPwHUxKcIsiNRiy0fpKs0M4SqZGmIRfWkgTW/Sgr38rb5q+kvnN9iBl?=
 =?us-ascii?Q?1UspoRPPULG782wPqonm/Sky93rvk8/bAntPnLUgtevpcib/fb19GcKurofL?=
 =?us-ascii?Q?FDqaWH08NLWcTUycuPNgkRipaz77Kp4bHhaCrfJekVdWEC5LJG7A/77pW946?=
 =?us-ascii?Q?N3uzfd8NTRQ2vg4TCzili75xsB7ZWmpxgX/KqWmoqPcRkfsVk/NvzynIBSY3?=
 =?us-ascii?Q?97Ez21fCDnhcxNbZq3aswkJNJymG90OZqv0POW855WrJA2c9elRQlMesXr9f?=
 =?us-ascii?Q?my18SlmyZ4vgc5c4Y0MzejSIOowUTUzx261Y9bDTob5OsplXoh9Zy8fD2xQm?=
 =?us-ascii?Q?YPz3Exv8yN6+5anYo1RGXlDzuA2rYk/7py8A6drWDzMa4NkQ+T5mQgAsbqbz?=
 =?us-ascii?Q?VTmmIKNyDjkAsCqTvQ410d3CxWrcy8MoFi/MfhYUR36+axjKu+uhd0MDHyIy?=
 =?us-ascii?Q?WtqCpWzDf2toQkuF+jAy+gLawJR6PcHlpbZT0OCBW1nXGvmBm1JQkSbTywRC?=
 =?us-ascii?Q?aiA3giCi91XCqtwJ9415Wpuau0zziH4apzOY4NfVxzm2pAGJh2LupkyP/+Xw?=
 =?us-ascii?Q?X11k2LxK6mTXtSQOUNG95HBQ+sdS2oVvLOFpjrEfIXjWqtbaf2M2aBIdKyvI?=
 =?us-ascii?Q?fX7exW69LnT61I0MX/ZlngnhfqEbwPQKi4Q3vZ+2lWJuvDF0IRJk06N1RGm7?=
 =?us-ascii?Q?2r81spI0KHrOprBq4Ir9pMh9exrZuZxHOLAxaos3XKjPq1y3e47178W9sVrB?=
 =?us-ascii?Q?f3hf9kPuQI5DKwYOht3uxvvghaLG6a1mvUMrtAvbb7VUcFqJCTdTXskjQoge?=
 =?us-ascii?Q?VRR+H3e72cizw6t2ofQFaqOeqsi+tTqyxUDHtmrJGivbloSKekDfL18/D+9H?=
 =?us-ascii?Q?XQMag9M5cJNBWATmXsl7RPqcXVzlpydA6poo3Hna3TS5sHDLEZLrl7/J/ICM?=
 =?us-ascii?Q?4miq6pb7TcM+PTagIJorhwi1K2EKWaXV0zBeIEwdcHZt9lMd0NB8LWYJeid5?=
 =?us-ascii?Q?JnYryBombNVKBPBKaOoJlLJ4r3fykFRQDIRE1tnT4vLsP1i+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4213b8d7-188c-4a4c-2c33-08de90154269
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2026 17:36:51.8830
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XdgabD9h7+D709XGIK8f89EpmAHt3LadLsWER9A/KNHChSciAMKbAS2/tyj7GLou
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9188

On Wed, Apr 01, 2026 at 05:33:28PM +0100, Robin Murphy wrote:
> > io-pgtable might have intended to allow the driver to choose between
> > gather or immediate flush because it passed gather to
> > ops->tlb_add_page(), however no driver does anything with it.
> 
> Apart from arm-smmu-v3...

Bah, I did my research on the wrong tree and missed this.

> > mtk uses io-pgtable-arm-v7s but added the range to the gather in the
> > unmap callback. Move this into the io-pgtable-arm unmap itself. That
> > will fix all the armv7 using drivers (arm-smmu, qcom_iommu,
> > ipmmu-vmsa).
> 
> io-pgtable-arm-v7s != io-pgtable-arm. You're *breaking* MTK (and failing
> to fix the other v7s user, which is MSM).

I was very confused what you were talking about, but I see now that
the hunk adding iommu_iotlb_gather_add_range() to v7 got lost somehow!

@@ -596,6 +596,9 @@ static size_t __arm_v7s_unmap(struct arm_v7s_io_pgtable *data,
 
                __arm_v7s_set_pte(ptep, 0, num_entries, &iop->cfg);
 
+               if (!iommu_iotlb_gather_queued(gather))
+                       iommu_iotlb_gather_add_range(gather, iova, size);
+
                for (i = 0; i < num_entries; i++) {
                        if (ARM_V7S_PTE_IS_TABLE(pte[i], lvl)) {
                                /* Also flush any partial walks */

> > arm-smmu uses both ARM_V7S and ARM LPAE formats. The LPAE formats
> > already have the gather population because SMMUv3 requires it, so it
> > becomes consistent.
> 
> Huh? arm-smmu-v3 invokes iommu_iotlb_gather_add_page() itself, because
> arm-smmu-v3 uses gathers

Yeah, I missed this whole bit, it needs some changes.

> Invoking add range before add_page will end up defeating the
> iommu_iotlb_gather_is_disjoint() check and making SMMUv3
> overinvalidate between disjoint ranges.

Right, that flow needs fixing.

> I guess now I remember why we weren't validating gathers in core code
> before :(

My point is not filling the gather is a micro-optimization that
benefits a few drivers. I think it is so small compared to an IOTLB
flush that it isn't worth worrying about.

So, I'd like to make everything the same and populate the gather
correctly in all flows. I'll fix the SMMUv3 thing and lets look again,
this patch is not so scary to make me think we shouldn't do that.

> @@ -2714,6 +2714,10 @@ static size_t __iommu_unmap(struct iommu_domain *domain,
>  		pr_debug("unmapped: iova 0x%lx size 0x%zx\n",
>  			 iova, unmapped_page);
> +		/* If the driver itself isn't using the gather, mark it used */
> +		if (iotlb_gather->end <= iotlb_gather->start)
> +			iommu_iotlb_gather_add_range(&iotlb_gather, iova, unmapped_page);

The gathers can be joined across unmaps and now we are inviting subtly
ill-formed gathers as only the first unmap will get included.

We do have error cases where the gather is legitimately empty, and
this would squash that, it probably needs to check unmapped_page for 0
too, at least.

Thanks,
Jason
