Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2052.outbound.protection.outlook.com [40.107.93.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6874C14E2FB;
	Wed, 27 Mar 2024 18:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711562925; cv=fail; b=e0Sua+P/eWLHRMQIg8hwdRFthKwb0/jeTbsEpvNZZj4rhD9vyRWlz3MkbwZr7qDIhYpBeG0QCFU5/Mj7YwxZP3zv2/eIWzceZ3D/kGFwFgrZV7Et0FdNUs3P745eUWGWqWLqGC0RZkZ3cZHNBbZc55WpJPYuW2TAgtdV3OkQeWI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711562925; c=relaxed/simple;
	bh=uxnDZssF3MsZqNdBwFu5fkXDr1CnHP3vFsvghONVOjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dt6wCACRHYjGyll2iO2ZuqmmOI9x6VhZRzgFG1yiCxBzg86fK/XwX2NF7zT15UR69k6+yIa/3FVFA6+U78pkpBPlqI9Br59cW9CcaJvnFmv5KxPlGUx/y8bpIZpxGrv1n4tXxdF+tgMqVS0R2h5p1ePT5U9WE9bez2T9d+3hOtM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=VaSnwtoi; arc=fail smtp.client-ip=40.107.93.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="VaSnwtoi"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=msEp/dLkz2KG8UcCT3hjlr/5SkDNgHDG+gleXQaCHQ7mvfnz09a1qGDukVT7QJcAvgZsCef3hBB1wdORsadOInZ6ZS5rgAdORBiDD0Q7xZGVntTDNt6XQuzFuVXZ+DWoIv7csgoZfx1xlq3AIJWr2CQH36nJqtChUHVdK9H8C37di/cMbCA+Aetp7X4IrMNr26h//ZksqpirGoe0JmB6FjeObZtX9kht12Uy+ozu8J3+a+bZHp9JH6Bk5tqzcRWHIfObKDlFMvY6VS5eAU0ogYkL3/EssoVfA0FFZblJVadrMbfJ5YTm7DR1EZGbOG7ukq1WXdghedYbapTLN/DeLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qb9Bm5mZhRpKZ1E0v2HrnDeTRaYvYu3eMk6OkfeOjbs=;
 b=n5DgxYLziBAYW1KFgB740idRBxR5RTxmbSG98df+LfiffI3ovkpvkOBnnIg4Lz+h74EEOEubIlPjn1ePl+VEdKOm49TAWLtPhdTJEb6ppoDgf4l8Os9m9ZHbk9TzHrF6wi4LUW2ZN0O/zjotqwgWeIEjK5Xn3cgG8UuEiVv/gCsDRmY7IU28ZiNPgmArD7Z9w5I2WMfeuuNz15/ZQrEtLsMBD/mix1omfDTmnEE8Zo6DvVpfyeiRW+EptsbVkf7DVvJMAxvCp4PVHqRuduXegOfxsxRhlDu1WdMp9nyDqmaTUH0y62XrIY0hN9t/CuwtgfoaGrquC3D11CdWhQmazw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qb9Bm5mZhRpKZ1E0v2HrnDeTRaYvYu3eMk6OkfeOjbs=;
 b=VaSnwtoiYzsqbF2EFlIJ/xqPvTIEAcLipRY8ynI4BEUovdUNYw6269hDJNFh2/wLQu66XrJmF0tdy9Vkp6zoc0oAjp52PAvSWX+fyLg5RlSYQLnhMZCj7dgbVRnsHwIRL92GSfko5/cj/ehrIvWPXzX36r0p293QTqNc70A1hjfQJ2Zz24PZbnDY1CNzLszIcdum19mDssNFPshOxiIrueinJJphdy/1Dy9LhceJLNH7ImimQGHUuzdLQJSMw/WStaJMHG081WuTxM6xAV3/neaQFQ/YsotgGokpp14TSlrbQn8UqGODhhjN8rck9FqfZ3MYwwV5yq28X0l9gks8rw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by CH0PR12MB8487.namprd12.prod.outlook.com (2603:10b6:610:18c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.32; Wed, 27 Mar
 2024 18:08:29 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 18:08:29 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <jroedel@suse.de>,
	Kevin Tian <kevin.tian@intel.com>,
	kernel test robot <lkp@intel.com>,
	Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>,
	Tony Zhu <tony.zhu@intel.com>,
	Yi Liu <yi.l.liu@intel.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH v6 24/29] iommu/arm-smmu-v3: Consolidate freeing the ASID/VMID
Date: Wed, 27 Mar 2024 15:08:10 -0300
Message-ID: <24-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0306.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::11) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|CH0PR12MB8487:EE_
X-MS-Office365-Filtering-Correlation-Id: d6fc686f-aa2b-40bf-7447-08dc4e88e1a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	qFMGsZPSvX9HgZWAHev5As/ETDglHu7s+iaejNXm0n9LyU+vuYmemKr0vTncug4maufUhkCPYIcCKOV1RqLQOaouymt7AsS9YwarvJoOFUGzup0+hC3HTsKDPaGK+ZHb6mbmRsh+mytVH0dZnSJeqGBFM781beRXT9wM8FQn9k1wu+MJy9IgNxGYtCQOvBUUiZnVPFMsaJpVfni/GsKu/krUW7wHZRnR6delRHoHG/Jj/BIUzm2N1LGv31hQkeKvKxhu41+lrUAGEUs57q1S4SHDRzIfr/e/FbgoXF/VyBqki+xruKmdxOSMm+oCiwNa4P5scJaF1BpRkGm1NwMiYQU240XB9zdHtK8mPm+XaHC0Z5KeHTwrR3MsHtai1/y1tyr8cLOy3cdZRje6C5XBZ85eCBO0gP6S/8x7ST3DDnfBe9Lvh2kNIU3vgZdLC5uS3AAESzHwnmVYd3An2lE6O/3SnlaRGlsH996FboQ4csqrLDFaSRoWArPCTBooS2pLxdshg55ctNzC3akBgqjSdpWSQveonIQATvRWsPdJucl9GSRUV/xh0urDoFL3tvvclMccL563N+NeUE1ZXsQFm8rMDhs2aXixJeR+NbSF8UYna0seyIC/rRwgYToggWDg+Kv2IBeZ3lPJuFi7mhnoSBcoH/Fzi/ewnZS8x/WjCps=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?d6f0VRVwQchNc52BHVTDpdtS9h30k9iiWBEj8lkt3K6m6un7FkT9yZ6P2Y34?=
 =?us-ascii?Q?q/ZNBxUOsv7newfD/7kTggnlVn3qDsDwDE8+TO4bS+VP6EmWQwGvJpW/MkzA?=
 =?us-ascii?Q?XR2TDAPM4XWXW+F7LzJPK5e/IOGN7FTBnp+KcCV7nLLKrAp6weeGUxpQhUy1?=
 =?us-ascii?Q?5v3QBg9Pq7HkZHopfyoyQYG1/KOwzDls7j1o+yNOmmnKUaclzeI4SwrgM3xH?=
 =?us-ascii?Q?TQ7MZF3Td/Og7aHb1aTIuKh76kI95gTF+MSYU87rSHZwDBVcx9zDOeKV3pvp?=
 =?us-ascii?Q?2jDD3dwuVhfi/R0n152Tp1BWgWnAxzEH1s3R60q3A8I+AotfVjFZAfVEZ+xN?=
 =?us-ascii?Q?+QMErPjPC0EA0GOjRReJAL3cRLVW3uSev/+XXeBt4AAaZtS+HTTCQz7+7hxo?=
 =?us-ascii?Q?NydjYnySb7ic3KoZTmQwKwsqtEYCepNAhH19LEpxSENrEPEKiA2e3izHTbfB?=
 =?us-ascii?Q?vusc2XVxqur/rZdQKDjBxdFPN6SG5U7b6qjNgjyNChuhh0pj3sMuZlUhGghJ?=
 =?us-ascii?Q?UhFY/XL5Cozm1PBwmVtxLGtr04yGRxSB4/eD90GLshv6PmoXVuqi2TUVt5QH?=
 =?us-ascii?Q?/ewklwGq72aox5UVmCtfPVhvy1oE62mtSx59cpNNo8jAjiAuJUHpNDRjWifb?=
 =?us-ascii?Q?VAOPib9sFy5e66L+TzsHPJytKtTLO1vBK0gq6k/jcOGmonMAxWKS1ecFO75J?=
 =?us-ascii?Q?0HmWLcC3tfWPKSwfK0ASpQt2HsJoBqGMFwApDLALhWH6kzoSbqrsQjGNzdqc?=
 =?us-ascii?Q?Lyuq3Et3nN8BBPKNRp+8Qv1QvmV0WHhb018/NQ5LfJF6rM3LstTrXYj87Ev0?=
 =?us-ascii?Q?OTaGj1yrAiCVz4hRuVOwTUTHC5SvCI3I74QfAatlYOLokzNoLCJWQ5vTZ7DE?=
 =?us-ascii?Q?BCxtXSZeg1bg+EgKfjTI/KgsZZS5+PmSexsUHvYRT0iiTBm/uyJfcz8bhTYX?=
 =?us-ascii?Q?DDC/vMcLTZGCHWao31EHNTKKhdVWq+XP2RJnnYUzdzC4WGMml8Zg0UTlPiLI?=
 =?us-ascii?Q?FFYmGEV1ThdAlHcsyx+CFUYedR35z9B+gYP2hoUgeZ6O42lMFg126cKG+ufq?=
 =?us-ascii?Q?/b9lGB5c2qcjdxxIiuYAwPhkGFiZppB89ppH7I+Y5EmdnM67k+o3RPGmzhTD?=
 =?us-ascii?Q?P+Mm49xRL3h6AdmcLax3I71cWoVrr7fYKxZ5/Affw71Kk4FwAc1CksJJF9Fu?=
 =?us-ascii?Q?p2TsfyktSLUfaiJ8weLp/lHjaHYWVxs5zX4+3l1qMpJ8w31+km/nSTPuABoS?=
 =?us-ascii?Q?bW/fMLd33z19hV7jpUFa5nc11ojBJKNL8cZHqUHCq4hHg0aRtAVKa9bkfQ+R?=
 =?us-ascii?Q?GLemFbtFfR40eabaoOrCjHx0BDNtOqia8Hj0jTTWKoNFdVswEGzauQBawu30?=
 =?us-ascii?Q?B8u2xYvgfhaob33hcwazCXMfC+TqXSI3E7obzaH9N+4JQsgCDKL92MKe/het?=
 =?us-ascii?Q?64RuvgiPih1qa7JKhCH7Ry6n/e0dIgJ6MMeyq7Dk9gAR7dkocFdyBhtM06bp?=
 =?us-ascii?Q?E9VygxHPDmXacQXMp4W8rn+5GW757sL9ABqe16+mXMbzIBUEcwqdo2O3yff3?=
 =?us-ascii?Q?DeNb9yVrvqoIH7msOIMhF9dvrq/19EIfFA9MaY4J?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6fc686f-aa2b-40bf-7447-08dc4e88e1a2
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2024 18:08:18.9231
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6KRaA4uw5m5dVFP+43W60Y6sZdJbiZPQSTEFo3fpdib+NVGh5zQOFIC52shS2Aou
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8487

The SMMUv3 IOTLB is tagged with a VMID/ASID cache tag. Any time the
underlying translation is changed these need to be invalidated. At boot
time the IOTLB starts out empty and all cache tags are available for
allocation.

When a tag is taken out of the allocator the code assumes the IOTLB
doesn't reference it, and immediately programs it into a STE/CD. If the
cache is referencing the tag then it will have stale data and IOMMU will
become incoherent.

Thus, whenever an ASID/VMID is freed back to the allocator we need to know
that the IOTLB doesn't have any references to it.

Invalidation is a bit inconsistent, the SVA code open codes an
invalidation prior to freeing while the paging code runs through:

arm_smmu_domain_free()
  free_io_pgtable_ops()
    io_pgtable_tlb_flush_all)()
      arm_smmu_tlb_inv_context()

To do it.

Make arm_smmu_tlb_inv_context() able to invalidate all the domain types
and call it from a new arm_smmu_domain_free_id() which also puts back the
ID. Lightly reorganize things so arm_smmu_domain_free_id() is the only
place that does the final flush prior to ASID/VMID free and that
arm_smmu_tlb_inv_context() provides full invalidation for both
arm_smmu_flush_iotlb_all() and arm_smmu_domain_free_id().

Remove the iommu_flush_ops::tlb_flush_all to avoid duplicate invalidation
on free. Nothing else calls this besides free_io_pgtable_ops().

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |  9 +--
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 68 ++++++++++++-------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  1 +
 3 files changed, 46 insertions(+), 32 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index fd0b9f230f89e3..9ec1a5869ac3b2 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -367,18 +367,13 @@ static void arm_smmu_sva_domain_free(struct iommu_domain *domain)
 {
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
 
-	/*
-	 * Ensure the ASID is empty in the iommu cache before allowing reuse.
-	 */
-	arm_smmu_tlb_inv_asid(smmu_domain->smmu, smmu_domain->cd.asid);
-
 	/*
 	 * Notice that the arm_smmu_mm_arch_invalidate_secondary_tlbs op can
 	 * still be called/running at this point. We allow the ASID to be
 	 * reused, and if there is a race then it just suffers harmless
 	 * unnecessary invalidation.
 	 */
-	xa_erase(&arm_smmu_asid_xa, smmu_domain->cd.asid);
+	arm_smmu_domain_free_id(smmu_domain);
 
 	/*
 	 * Actual free is defered to the SRCU callback
@@ -423,7 +418,7 @@ struct iommu_domain *arm_smmu_sva_domain_alloc(struct device *dev,
 	return &smmu_domain->domain;
 
 err_asid:
-	xa_erase(&arm_smmu_asid_xa, smmu_domain->cd.asid);
+	arm_smmu_domain_free_id(smmu_domain);
 err_free:
 	kfree(smmu_domain);
 	return ERR_PTR(ret);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index a82a5e4a13bb44..888972c97f56e1 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2057,27 +2057,19 @@ int arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain,
 }
 
 /* IO_PGTABLE API */
-static void arm_smmu_tlb_inv_context(void *cookie)
+static void arm_smmu_tlb_inv_context(struct arm_smmu_domain *smmu_domain)
 {
-	struct arm_smmu_domain *smmu_domain = cookie;
 	struct arm_smmu_device *smmu = smmu_domain->smmu;
 	struct arm_smmu_cmdq_ent cmd;
 
-	/*
-	 * NOTE: when io-pgtable is in non-strict mode, we may get here with
-	 * PTEs previously cleared by unmaps on the current CPU not yet visible
-	 * to the SMMU. We are relying on the dma_wmb() implicit during cmd
-	 * insertion to guarantee those are observed before the TLBI. Do be
-	 * careful, 007.
-	 */
-	if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
+	if ((smmu_domain->stage == ARM_SMMU_DOMAIN_S1 ||
+	     smmu_domain->domain.type == IOMMU_DOMAIN_SVA)) {
 		arm_smmu_tlb_inv_asid(smmu, smmu_domain->cd.asid);
-	} else {
-		cmd.opcode	= CMDQ_OP_TLBI_S12_VMALL;
-		cmd.tlbi.vmid	= smmu_domain->s2_cfg.vmid;
+	} else if (smmu_domain->stage == ARM_SMMU_DOMAIN_S2) {
+		cmd.opcode = CMDQ_OP_TLBI_S12_VMALL;
+		cmd.tlbi.vmid = smmu_domain->s2_cfg.vmid;
 		arm_smmu_cmdq_issue_cmd_with_sync(smmu, &cmd);
 	}
-	arm_smmu_atc_inv_domain(smmu_domain, 0, 0);
 }
 
 static void __arm_smmu_tlb_inv_range(struct arm_smmu_cmdq_ent *cmd,
@@ -2211,7 +2203,6 @@ static void arm_smmu_tlb_inv_walk(unsigned long iova, size_t size,
 }
 
 static const struct iommu_flush_ops arm_smmu_flush_ops = {
-	.tlb_flush_all	= arm_smmu_tlb_inv_context,
 	.tlb_flush_walk = arm_smmu_tlb_inv_walk,
 	.tlb_add_page	= arm_smmu_tlb_inv_page_nosync,
 };
@@ -2275,25 +2266,42 @@ static struct iommu_domain *arm_smmu_domain_alloc_paging(struct device *dev)
 	return &smmu_domain->domain;
 }
 
-static void arm_smmu_domain_free_paging(struct iommu_domain *domain)
+/*
+ * Return the domain's ASID or VMID back to the allocator. All IDs in the
+ * allocator do not have an IOTLB entries referencing them.
+ */
+void arm_smmu_domain_free_id(struct arm_smmu_domain *smmu_domain)
 {
-	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
 	struct arm_smmu_device *smmu = smmu_domain->smmu;
 
-	free_io_pgtable_ops(smmu_domain->pgtbl_ops);
+	arm_smmu_tlb_inv_context(smmu_domain);
 
-	/* Free the ASID or VMID */
-	if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
+	if ((smmu_domain->stage == ARM_SMMU_DOMAIN_S1 ||
+	     smmu_domain->domain.type == IOMMU_DOMAIN_SVA) &&
+	    smmu_domain->cd.asid) {
 		/* Prevent SVA from touching the CD while we're freeing it */
 		mutex_lock(&arm_smmu_asid_lock);
 		xa_erase(&arm_smmu_asid_xa, smmu_domain->cd.asid);
 		mutex_unlock(&arm_smmu_asid_lock);
-	} else {
-		struct arm_smmu_s2_cfg *cfg = &smmu_domain->s2_cfg;
-		if (cfg->vmid)
-			ida_free(&smmu->vmid_map, cfg->vmid);
+	} else if (smmu_domain->stage == ARM_SMMU_DOMAIN_S2 &&
+		   smmu_domain->s2_cfg.vmid) {
+		ida_free(&smmu->vmid_map, smmu_domain->s2_cfg.vmid);
 	}
+}
 
+static void arm_smmu_domain_free_paging(struct iommu_domain *domain)
+{
+	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
+
+	/*
+	 * At this point the page table is not programmed into any STE/CD and
+	 * there is no possible concurrent HW walker running due to prior STE/CD
+	 * invalidations. However entries tagged with the ASID/VMID may still be
+	 * in the IOTLB. Invalidating the IOTLB should fully serialize any
+	 * concurrent dirty bit write back before freeing the PTE memory.
+	 */
+	arm_smmu_domain_free_id(smmu_domain);
+	free_io_pgtable_ops(smmu_domain->pgtbl_ops);
 	kfree(smmu_domain);
 }
 
@@ -2914,8 +2922,18 @@ static void arm_smmu_flush_iotlb_all(struct iommu_domain *domain)
 {
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
 
-	if (smmu_domain->smmu)
+	/*
+	 * NOTE: when io-pgtable is in non-strict mode, we may get here with
+	 * PTEs previously cleared by unmaps on the current CPU not yet visible
+	 * to the SMMU. We are relying on the dma_wmb() implicit during cmd
+	 * insertion to guarantee those are observed before the TLBI. Do be
+	 * careful, 007.
+	 */
+
+	if (smmu_domain->smmu) {
 		arm_smmu_tlb_inv_context(smmu_domain);
+		arm_smmu_atc_inv_domain(smmu_domain, 0, 0);
+	}
 }
 
 static void arm_smmu_iotlb_sync(struct iommu_domain *domain,
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 3516869954ea33..a711a659576a95 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -772,6 +772,7 @@ int arm_smmu_set_pasid(struct arm_smmu_master *master,
 void arm_smmu_remove_pasid(struct arm_smmu_master *master,
 			   struct arm_smmu_domain *smmu_domain, ioasid_t pasid);
 
+void arm_smmu_domain_free_id(struct arm_smmu_domain *smmu_domain);
 void arm_smmu_tlb_inv_asid(struct arm_smmu_device *smmu, u16 asid);
 void arm_smmu_tlb_inv_range_asid(unsigned long iova, size_t size, int asid,
 				 size_t granule, bool leaf,
-- 
2.43.2

