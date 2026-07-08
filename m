Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012039.outbound.protection.outlook.com [52.101.53.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F76E3B9D97;
	Wed,  8 Jul 2026 05:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.39
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783488593; cv=fail; b=IcajQksXNz7dYbyDg72qC9S/B6LA82HyBVYlYJE+ISAaa3HpqnLKyKGLMTeY9uV8KSX8Qo2cAnUbM4YqaqKY4nkYM92x4QKmj2gU1/uyj0XZohzL564cOih709Xrx6VP3vXHicRLntCwOt2ArVJEtFwczlF4OLBKTmGsJYNpVQI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783488593; c=relaxed/simple;
	bh=UuqYn+ZY3xTV5LYbQM42Q8cdoVGh0AKcF2un6ON5/Gg=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oiLRCl33NTJfDDko0Nxe+OeT3bcNbVunGf7c6RJuetx3VIlVcR1ZQn31uREbxvdwmYTij05IANv1dnzACjmySZj1THbSl2T36AZxe1omlgOs1bO2w+m/7qmU7VSZCiOHLKvAi+NXy9DjcQiF9z1s//m0LSVl5Xg3M6Rlg0LyOOA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=k8MpYvF7; arc=fail smtp.client-ip=52.101.53.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="k8MpYvF7"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ehuj5NrIAyw8gUJUiKBhgoiTAoQwMsqnuN1yRyNLCyMnC/eptqYifabiK+OGfCGU1R8khhzEb7srDAuHCkdPCNngfWnqdfTBBUXprElDcue7Xe39hcAl3VrguH8+MH0DSzop35lIqAzOVrAfP4K8OTihGCY0NnU7uz1+AFswU/IKpsmkzipFG8ECiT44Tmp6FMRFvsnExSRrKBFfRDzZGyW4qcT1cdcSHiaZgFMo2EPjXNDn1W3y7cQX0iPgIJe7UimbY0gg29HQy/eB9B55LfXHTV+13j5+EtNEtofVdDYuyJ2//vYMSjl0QygTMGNzbEri1/oArNPCm0DWYxf6Ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T90hqP6T7FJPiN3qI0bRF9tXPkt3mXT54EaEQtpLV0A=;
 b=BrSRYPcQsVBGouruz2Df0Xfje+0StQMYkPywYFRqWk6ibDrDAt9xOjbm1J4j5enITcv9ttC1SsckEK9urXjPnOevRb9CC3nySGaPXhLhVdXIbpXLh6HEeGonV8lHUBbLtJUa5S2uBefEe+9SRNGM7Da5B0ageUnzSr+wrwbE7SzjLS9bsssiDORkNGsK5+BA68e7HHIpds9SS2+9s6Cb7tYPToV+Rf9fi5dkVd6WcXbB3wuHVHTkhoIvmlAwXTxs6KKm558rmvZ72I/hNXNCetkc2C28Q7ascpctvv2QfIo3lkVEN8SZzGApsOsgEG8r4wrBbLPFmkyTvuv0XG5g1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T90hqP6T7FJPiN3qI0bRF9tXPkt3mXT54EaEQtpLV0A=;
 b=k8MpYvF7qJUu3OkB9k9n3wTM3cVyLTHUpnkyg70CRauzgSqGH7IeKrAvqvnScPaj/wSYaVsv+82BYBKLmSSf92mKaplO/CGgUw4A7zvsiYWc9ki9P1KHnSth1//+0nW1xNN/GpYdhl2wsyp/mh4pii8tWJZNkhrULC0cnjZQzNQY2plITOfar8IvwRVQhzvaVhcXjrmP8rMw+vYLn8BRIBGbYinAPFqQ2KfJiiqoQg4cl/a4qFSle2ybnzSLAYEds/PHYFjxBVCy431/KcPivGAPzJc/eWdn5PEoNgJLfbEwwuPp6hDPxZqFyP/mBHIBdtTb2xH6cOUlTr9cU9D/7A==
Received: from SJ0PR03CA0190.namprd03.prod.outlook.com (2603:10b6:a03:2ef::15)
 by IA5PR12MB999300.namprd12.prod.outlook.com (2603:10b6:208:608::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Wed, 8 Jul
 2026 05:29:48 +0000
Received: from CO1PEPF00012E84.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef:cafe::2a) by SJ0PR03CA0190.outlook.office365.com
 (2603:10b6:a03:2ef::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.202.9 via Frontend Transport; Wed, 8
 Jul 2026 05:29:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CO1PEPF00012E84.mail.protection.outlook.com (10.167.249.59) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.6 via Frontend Transport; Wed, 8 Jul 2026 05:29:46 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43; Tue, 7 Jul
 2026 22:29:36 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Tue, 7 Jul 2026 22:29:36 -0700
Received: from Asurada-Nvidia (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 7 Jul 2026 22:29:35 -0700
Date: Tue, 7 Jul 2026 22:29:34 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, "Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, David Matlack <dmatlack@google.com>, "Pasha
 Tatashin" <pasha.tatashin@soleen.com>, <patches@lists.linux.dev>, "Pranjal
 Shrivastava" <praan@google.com>, Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v2 7/8] iommu/arm-smmu-v3: Change how the tlbi describes
 the invalidation
Message-ID: <ak3gPqsdg94TTDLJ@Asurada-Nvidia>
References: <0-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
 <7-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <7-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF00012E84:EE_|IA5PR12MB999300:EE_
X-MS-Office365-Filtering-Correlation-Id: 763def0c-a2bd-445a-475a-08dedcb1eca0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|82310400026|7416014|1800799024|376014|36860700016|18002099003|22082099003|4143699003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	e2+j1xPCc3vlTU8mmIt4PEtbhE/9lps+EP0Kn1pffTBXzRGWaUBe+EVRIXuAaVTKQNGGM2kO7+aGd23uIOBxjR6wL3Lz3EbPS6eT+/rHOQtcH6ZgqF2M41T0CWBmTMbbi1G6xL13hgzcUSio+Ert3ArbEfDBUf9mq4sX+gKMfB2r/Ap+BIs63qc+YqnMNV/By+JzlZ96eyoEkb3m7HiI+w8d55+RjiVfNH7EfffHA8EekEZnouaZNoWkKJgRlTipktVAtnXFzAaKiTE+aMmcU7XQOHmfikvlpTEnxl6KWXQkWSP0mzdiZYhP3jESkCMtPiMUXU43WOnTiYETjK9oJfgBBcjWzLY7F0G0SnhsX5DgdDa8WgxDGcgyaggNZtwmv2shdhXzMTE0H1atScWDIuxG0b97CCKIBcq6GFRrlwGH+diQU1GfOze0S9UP1cXRvCmeb5q3SrY0DBL2xXfHwPDjca3KipBA0sqe6id73vQtByV56/0O2CrkVvVQANo+dcWGK9OISqmsVRquuEGMybP7su2buuEHLVBhaO2lZEiVuVh1lp4HoLyi7MbJOhbDdaQFA7K5pZ3bTfWfeGKwWnOeDSNhLIuikUm0VVXsQcThfff80E8LzYoDKeaaxdfy5ZP5eZkXUtV4bA65EkQ91jLOXCLgnO3wcSjnVf3rcz6GaFINXAiuaFHk2Fth+nJTSpRJfXSspoV2yT0gakSgvQ==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(82310400026)(7416014)(1800799024)(376014)(36860700016)(18002099003)(22082099003)(4143699003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	raHNQO0VNm6IvJwMhqzGZCM5KC2PIlG7grYVjrgStOp0t0emFXhuXTKWqeap3ZVgItw2BaeTuPRI9uukvvsnWcCDQJsdBZ3D25RjkSPNmICHiDJqshE9j0XM3aGzmnQyhFSSaU0PbCMu7mJiyp5aMCMAilcx/0zz+H9IadOKUoBFbc0R91K9io5jVTDa4gm3Uo25gcza3k2v8lcnzF8Fnn6BbDFWc6wVPIUUvDfkDv5F7TQ1WnaohDRLBhMD3ALT4+sRg7hT7XEuoXG0sw++SLvywlVVswv7NohrFbpiro1/KqtNPLeOhHhh2mYMLAqafTUnDAzw695O1GHIPnhbqi2ELFzpkT4zphFD0OKp+kv/bh0u8df53096mxfpOiZoNLzYQuqQDuFZs0Ax9mUmaBa/ZgKVUt3Y4tLtYp7QdgURJq7LKaylF13aw20tgs/0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2026 05:29:46.9504
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 763def0c-a2bd-445a-475a-08dedcb1eca0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF00012E84.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA5PR12MB999300

On Mon, Jul 06, 2026 at 01:26:44PM -0300, Jason Gunthorpe wrote:
> + * Compute the stride for non-RIL single-page invalidation. Returns the log2
> + * stride of the lowest affected level. Single invalidation removes all IOPTEs
> + * that contain the IOVA invalidated, and we can reliably assume that the
> + * architected page size and table sizes (not contiguous!) are reflected in the
> + * IOTLB. Thus if there is a 2M leaf entry we only need to issue a single IOTLB
> + * invalidation within that 2M IOVA.
> + */
> +static u8 arm_smmu_tlbi_calc_stride(struct arm_smmu_tlbi *tlbi)
> +{
> +	unsigned int tg_lg2 = tlbi->smmu_domain->tgsz_lg2;
> +	u8 combined = tlbi->table_levels_bitmap | tlbi->leaf_levels_bitmap;
> +
> +	if (!combined)
> +		return U8_MAX;
> +	return (tg_lg2 - 3) * __ffs(combined) + tg_lg2;
> +}
> +
> +/*
> + * One TLBI command per stride-sized entry. Sets use_full_inv if too many

This is raised by Claude; not sure whether it is a false positive
or not.

This changes a previous per-pte invalidation to per-pmd one. Yet,
the spec states in 4.4 TLB invalidation (last paragraph):

  To match a TLB entry, the least significant bits of the address
  are ignored as needed, given the size of the entry.

So, the following scenario would likely miss leaf entries:

VFIO_IOMMU_UNMAP_DMA / IOMMU_IOAS_UNMAP
  iommu_unmap(domain, iova=0x40000000, size=2M)
    __iommu_unmap()
      iommu_pgsize()  -> picks pgsize=2M (aligned, 2M in pgsize_bitmap;
                         irrelevant that the region was mapped as 4K pages)
      arm_lpae_unmap_pages(iova, 2M, pgcount=1, gather)
        __arm_lpae_unmap(lvl=0) -> lvl=1 -> lvl=2:    size == BLOCK_SIZE(lvl 2)
          pte = READ_ONCE(*ptep)         -> a TABLE descriptor, not a block
          __arm_lpae_clear_pte()          # L2 descriptor := 0
          io_pgtable_tlb_flush_walk(iova, 2M, granule=4K)
            arm_smmu_tlb_inv_walk()
              tlbi = { start=0x40000000, last=0x401fffff,
                       table_levels_bitmap = BIT((ilog2(2M)-12)/9) = 0b010,
                       leaf_levels_bitmap  = 0 }              <-- the false claim
              arm_smmu_domain_tlbi()
                arm_smmu_tlbi_calc_single():
                  calc_stride: __ffs(0b010) = 1 -> stride = 2M
                  num_ops = 2M >> 21 = 1
                arm_smmu_domain_tlbi_inv()
                  non-RIL entry: ONE TLBI_NH_VA @0x40000000, Leaf=0
                    -> kills the walk entry + the 4K leaf at base
                    -> 511 4K leaves SURVIVE
          __arm_lpae_free_pgtable()       # subtree freed, no invalidation
    iommu_iotlb_sync(domain, &gather)     # gather->pgsize == 0 -> returns immediately

> +	 * If leaf_levels_bitmap is 0 then this is a walk cache only
> +	 * invalidation.
[...]
> +	u8 leaf_levels_bitmap;

Or is that only to implement a walkcache-only invalidation, such
that the leaf entries will have separate invalidation call(s)?

Nicolin
