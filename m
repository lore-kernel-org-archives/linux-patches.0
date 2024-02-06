Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2044.outbound.protection.outlook.com [40.107.95.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76565135A58;
	Tue,  6 Feb 2024 15:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707232380; cv=fail; b=ZdRDh3QPpU9fHDCGKh8vgLT1Fg2UuKQAbJcCQuyhy6SZ+C3yog98OTaRD/DLsrFCXPUOA8uKDPriq/KHTRQkGGg1Rg9hVrEIERK7mJdeqxZSo+2BmbMK79Q2DFJ3w/ysucSRqiDTolYpFMqzg2Gi5sLc534T7AeTOmIl4K10MUY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707232380; c=relaxed/simple;
	bh=nD27oSgSDYkuTBnRVzLWhMvkxyDj3etFzFv2I+jC5Zg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NjXX5k649p7Hcpmuddo7wZF1hzHVEQI+BHrXZtiTax8UAvNrr79F90n985nSFgByuPRRssVPpyXqTBf5xRnVEvVKx/RazaHSL1tJhplh8LBltd9+LtQrO16jNM/X+44ipBttwU/dPwtJy1iB9YrQIaiokmI0Q0iBMI4oF93jfJM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=jF5dtJmw; arc=fail smtp.client-ip=40.107.95.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="jF5dtJmw"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C0yYYaSQuwjBtTE2CDYz3SOZ8wL8VKq+HoXRBWxCTmz2yth9CPAUMV3rhEBU1nJu8cTu7DO1b7sy7/Hgv1EQQNo5SI5iEuka9WDEP05J4PXItVbRDMxPVFkX5cX3E0IVzmvhfTR1G4opQ5UD/HvHxiQzVU+o0KIzs/NikfD0JEXBlPkW2Xz2298spocEfU9H5uDi31/NEI7HUEUSUXI3gdNJMHIu1JmNAWeVWNV9zUA6a9iwE1foIYvhs6X3LZk64vBJrCFXPi1t6Yh1FWD2UuIpWP1hgLFXJZiRn/rHSmJUNvvYAr9IsHr0Tef5y/9kBUzxs0NwljaqmeVsSFMj1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+I5D2gPNRHK/MBD0rY5Aas2fW2RWXiI3aJggcLD4G5s=;
 b=NjyA4fcBvDn4DXdW1SxmogQaWTr31cKDwHp0UIRAC4fwFdbZJAE+A4wWDKC8ytSToff8c3QKXJHxGuODqc/82bnEsWKxq3FgDgQOR+IjN0+XAtirb6gj27Bg/qDXPmbK+yliImaJ+UIi3rrsYl083bUnDtEGuyeIZD3mTq9xudUDueiuhMpReeFSgaABIXV/uP0xbW353urGyH5x7mFEtv26fOYD6z53FxMrGa1JuD5bSsmGqV6QQxFt65gWF9/VLQFoyMj3Ogfym2249eAJlrUCR/szjXH7DdnubJCUmpqriOmd3AoAZSxV0ic5kjP3vIcgmQCnXz/o627IX+z6uQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+I5D2gPNRHK/MBD0rY5Aas2fW2RWXiI3aJggcLD4G5s=;
 b=jF5dtJmw40JctffQclqv16HAoSyrlCsguNK7XwhKy+QuDy7+48QGvhUcZK+TRXwcEYhnWVe5g7r8YK/4IzCWmaCOkItarOpqI+sOjKCWxrjF6tDwUQNcKzdEUGNG8cPZjNFTIgwrr2fkRm0aG36pphSIcy8mubTB73a8uuNvYXYXdTzsCeEWXJ4eA5hXMppA04B9MCj3caoEI+FW4ARHO+x1S4RzTM2WBVPqkp9bvJwbQa+IGu9F1dRww2R1ec93wZSbGGA0R0B2STuUIiQAgDyX3dnkG+JfupFaOmWXlSVY2z7MThAh8WlYjTYA3NVrNi5Lcuh0i3swZ4LP0ozn8A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CY5PR12MB9056.namprd12.prod.outlook.com (2603:10b6:930:34::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.15; Tue, 6 Feb
 2024 15:12:55 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7270.012; Tue, 6 Feb 2024
 15:12:55 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <jroedel@suse.de>,
	Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH v5 01/17] iommu/arm-smmu-v3: Make STE programming independent of the callers
Date: Tue,  6 Feb 2024 11:12:38 -0400
Message-ID: <1-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
In-Reply-To: <0-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P222CA0008.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::13) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CY5PR12MB9056:EE_
X-MS-Office365-Filtering-Correlation-Id: 6dc53d6a-367e-4147-75ff-08dc27261838
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Choav4hEW8ZUN5DH1M+LyCJZkL7rA8zmntFgm3QlaCjNFHLwme0pikJkcvWKfAKwF9PNlTZgYfAPOCFuYtaigEVFyiUjFsd5xxwKN/APu4KxDoJcGTlF/Moj0ezYDF8D6ajkTYDmifeWzBtCOYCeNmoPCeKeFtmimcQl7ekmKSuESga9AnO36XN8Cmsx88wKKpt6Y+MOVP6Jc6a7FYdwiPsjHQRTpxRIY8tpfx6MLVdfrq3vxTWKH57G2ExRWPVW/6eybQ2Al4RdMJjQdGJ7gIzExfP7phq7ARe8P04Kn4m0LGYS7VNrmyX9+d+SiYg05D6bKzcvBYbXDSJ+DR5OFNwAZA+WkLQpdgsK/dHZuZ72MlKjipEQ9Uf+B43no4/Vh6uXjtuYZUsIC2ZioGxmR92L6cx8SodHKNxXMeuuHaX7xSzMn2rZYnoomTmtRXmBpP7ThpG0xKSMddKiWZQ5keiYHQqwQfCPOcaJb5bFDjEs9pibHjJPyi4ud5EV3aAUvE2juGgO71Ai0S9IkxleFQHgW+Ne+236LBPzZ4KIpPXt/juzRUVy4yv76dJD01MgX4OQHQB7IPB1AkUmsevSr80yy3XePMVbaBWhb7AHvE8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(346002)(396003)(136003)(376002)(39860400002)(230922051799003)(186009)(1800799012)(64100799003)(451199024)(316002)(110136005)(83380400001)(54906003)(66556008)(2616005)(38100700002)(6666004)(6506007)(26005)(6512007)(30864003)(5660300002)(86362001)(7416002)(6486002)(478600001)(2906002)(8676002)(66946007)(4326008)(36756003)(8936002)(66476007)(41300700001)(66899024)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7+Md2t2zM8F68AdAr57JXu+AudL140gRMeH4qtIEEgFMZoQjVfBnXkNRrxmE?=
 =?us-ascii?Q?JR1YlKzvyOklSAWRfX4IV5mXLn5D3AlBk7+RySGUTEbIy65gsnzCj+6fZtew?=
 =?us-ascii?Q?TfkA7PRX7GPfaGA+fglg+I4im+taRsqiUDjeJkyLPcq9Iygvq+sLMpxCNIYU?=
 =?us-ascii?Q?cNw507hzZzqN8Q5z4I7IOpDVmDoN3TQypoDCopjlQytTRTj6tg3byXLnkoSL?=
 =?us-ascii?Q?8m/F95b0DLtxHY+/r9UXc0DRcyMUd0wTIfIZz9UaLEk885GmMB3ez00VnU2Z?=
 =?us-ascii?Q?ytR9wczL23vI4R+43oRZFGH0gCmzcw4H2XvMMhehs0/qpGoDHlgT+wUvkjrq?=
 =?us-ascii?Q?tmDkG57nyZ5AQqcDzI/4heMr0z6AAMON+cXZkh6GbzEMg02JUhho+xol1Kk5?=
 =?us-ascii?Q?ou9daUCSZXMBEDZo8lhVj9gNu9yDyvW13xm4owuQBee7lHaVKg7WfJbmfmrD?=
 =?us-ascii?Q?erp76UH6o4a50VV03IJFcG7EamD5/BVUorVHZlvmj/QpmgjI/sQnYAsWP05C?=
 =?us-ascii?Q?B5m/PHQQmCyJ4uGbQoyONl+/TbhCHKJHNkzDXECzmINGS5P0cfpvgNSDxRI3?=
 =?us-ascii?Q?q1lFEcvoKPYTSucbU6rTs2bpBIin31FqRSitbCnY9+q00eQjD80aDe9QFEJi?=
 =?us-ascii?Q?t5Gd5GKRPdoMkzWzlBN3rIpKdugOpULo5Tw5UyatoHjz6k2AKlOcv+Y16UmA?=
 =?us-ascii?Q?h7zG5BoLjitVMjsCV/cnUsGKMkvXBY3dog7WrB/TbBtf+6AHClmMkzy5N2rE?=
 =?us-ascii?Q?+prBQW2oWl4WvoeaQQW/bx6Ax+ka+gBGLk8gakgop6AWLjGQxndQYIRKK/Sd?=
 =?us-ascii?Q?OFM9OWhKmSK/bRFUWl3MzmUC1Cy861JD9GzjKWURz6wyFTrr0kAToS/SFwR1?=
 =?us-ascii?Q?QzcvOit65LvG9IJGpXeoA9s59rjPtHmv2qtWu6HFErEpN9Wwj3WMCl7Fxh9a?=
 =?us-ascii?Q?BO0GDAyP/o15lGhaz8yRwpbEmvnq94kET9fyxzxzUuhxYL3bgW7QugTJM2f/?=
 =?us-ascii?Q?sgooLamHbpEgTAzhu4FpH/eBfgdbpTHwhXW/31wWFfvhUNknCHTT+HNbSukl?=
 =?us-ascii?Q?7PYdb/lUonfYZhuRzXaijdEDSNY9Zlil7buEV0hXwBxHUCge0/M3n2l/z/+O?=
 =?us-ascii?Q?XUTV57yOnxBSUNjeikgSDKbv1BHxrlImi+Avr6Od7Y5DrXQOaEUHSAhS/ZyT?=
 =?us-ascii?Q?y7MPtGtkRb7sXdOR5QCog1WmZEMHXw9hEWhwHjZUMYrWwOOjf2MZS4TwaYTM?=
 =?us-ascii?Q?C+NRySutfsV52v1HOaX0JDi2XzQP6gPbrnJ69aM9fC+QN/OyKpSJbyV2gh0m?=
 =?us-ascii?Q?GNlu+JQxROT2Uka7wcMSI42NPNY3vLdR+G4LRKtjg/Jmq4AJ24vN9Gea/1oC?=
 =?us-ascii?Q?yrXJ2vNS265K55W0tDMpS8YzibH5dU46dkHBlXzCUYUeVOtqg4iknQsyyr9s?=
 =?us-ascii?Q?9mzZU9bFDltGdCM9A1tLWTe8GEg/D/I/Pq1Y2DTNwSO/ezkWg6D5S5i7iuVi?=
 =?us-ascii?Q?J5SIzCBjLH/nA+AGK5nUnpRpHsFhGLiAWEbV8hG+KpYxRqshiTz0qn5BuoLK?=
 =?us-ascii?Q?/vcA1VvDlVJW93huaZQ=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6dc53d6a-367e-4147-75ff-08dc27261838
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2024 15:12:55.0563
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6ZTheOO7fB/2gOHWOhXJ+jFLQmMbAevzsyvsLaMk3pYfd/W7UjSF3+/iG7xB7zJe
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB9056

As the comment in arm_smmu_write_strtab_ent() explains, this routine has
been limited to only work correctly in certain scenarios that the caller
must ensure. Generally the caller must put the STE into ABORT or BYPASS
before attempting to program it to something else.

The iommu core APIs would ideally expect the driver to do a hitless change
of iommu_domain in a number of cases:

 - RESV_DIRECT support wants IDENTITY -> DMA -> IDENTITY to be hitless
   for the RESV ranges

 - PASID upgrade has IDENTIY on the RID with no PASID then a PASID paging
   domain installed. The RID should not be impacted

 - PASID downgrade has IDENTIY on the RID and all PASID's removed.
   The RID should not be impacted

 - RID does PAGING -> BLOCKING with active PASID, PASID's should not be
   impacted

 - NESTING -> NESTING for carrying all the above hitless cases in a VM
   into the hypervisor. To comprehensively emulate the HW in a VM we should
   assume the VM OS is running logic like this and expecting hitless updates
   to be relayed to real HW.

For CD updates arm_smmu_write_ctx_desc() has a similar comment explaining
how limited it is, and the driver does have a need for hitless CD updates:

 - SMMUv3 BTM S1 ASID re-label

 - SVA mm release should change the CD to answert not-present to all
   requests without allowing logging (EPD0)

The next patches/series are going to start removing some of this logic
from the callers, and add more complex state combinations than currently.
At the end everything that can be hitless will be hitless, including all
of the above.

Introduce arm_smmu_write_entry() which will run through the multi-qword
programming sequence to avoid creating an incoherent 'torn' STE in the HW
caches. It automatically detects which of two algorithms to use:

1) The disruptive V=0 update described in the spec which disrupts the
   entry and does three syncs to make the change:
       - Write V=0 to QWORD 0
       - Write the entire STE except QWORD 0
       - Write QWORD 0

2) A hitless update algorithm that follows the same rational that the driver
   already uses. It is safe to change IGNORED bits that HW doesn't use:
       - Write the target value into all currently unused bits
       - Write a single QWORD, this makes the new STE live atomically
       - Ensure now unused bits are 0

The detection of which path to use and the implementation of the hitless
update rely on a "used bitmask" describing what bits the HW is actually
using based on the V/CFG/etc bits. This flows from the spec language,
typically indicated as IGNORED.

Knowing which bits the HW is using we can update the bits it does not use
and then compute how many QWORDS need to be changed. If only one qword
needs to be updated the hitless algorithm is possible.

Later patches will include CD updates in this mechanism so make the
implementation generic using a struct arm_smmu_entry_writer and struct
arm_smmu_entry_writer_ops to abstract the differences between STE and CD
to be plugged in.

At this point it generates the same sequence of updates as the current
code, except that zeroing the VMID on entry to BYPASS/ABORT will do an
extra sync (this seems to be an existing bug).

Going forward this will use a V=0 transition instead of cycling through
ABORT if a hitfull change is required. This seems more appropriate as ABORT
will fail DMAs without any logging, but dropping a DMA due to transient
V=0 is probably signaling a bug, so the C_BAD_STE is valuable.

Signed-off-by: Michael Shavit <mshavit@google.com>
Reviewed-by: Michael Shavit <mshavit@google.com>
Reviewed-by: Moritz Fischer <moritzf@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 330 ++++++++++++++++----
 1 file changed, 263 insertions(+), 67 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 0ffb1cf17e0b2e..f0b915567cbcdc 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -48,6 +48,21 @@ enum arm_smmu_msi_index {
 	ARM_SMMU_MAX_MSIS,
 };
 
+struct arm_smmu_entry_writer_ops;
+struct arm_smmu_entry_writer {
+	const struct arm_smmu_entry_writer_ops *ops;
+	struct arm_smmu_master *master;
+};
+
+struct arm_smmu_entry_writer_ops {
+	unsigned int num_entry_qwords;
+	__le64 v_bit;
+	void (*get_used)(const __le64 *entry, __le64 *used);
+	void (*sync)(struct arm_smmu_entry_writer *writer);
+};
+
+#define NUM_ENTRY_QWORDS (sizeof(struct arm_smmu_ste) / sizeof(u64))
+
 static phys_addr_t arm_smmu_msi_cfg[ARM_SMMU_MAX_MSIS][3] = {
 	[EVTQ_MSI_INDEX] = {
 		ARM_SMMU_EVTQ_IRQ_CFG0,
@@ -971,6 +986,140 @@ void arm_smmu_tlb_inv_asid(struct arm_smmu_device *smmu, u16 asid)
 	arm_smmu_cmdq_issue_cmd_with_sync(smmu, &cmd);
 }
 
+/*
+ * Figure out if we can do a hitless update of entry to become target. Returns a
+ * bit mask where 1 indicates that qword needs to be set disruptively.
+ * unused_update is an intermediate value of entry that has unused bits set to
+ * their new values.
+ */
+static u8 arm_smmu_entry_qword_diff(struct arm_smmu_entry_writer *writer,
+				    const __le64 *entry, const __le64 *target,
+				    __le64 *unused_update)
+{
+	__le64 target_used[NUM_ENTRY_QWORDS] = {};
+	__le64 cur_used[NUM_ENTRY_QWORDS] = {};
+	u8 used_qword_diff = 0;
+	unsigned int i;
+
+	writer->ops->get_used(entry, cur_used);
+	writer->ops->get_used(target, target_used);
+
+	for (i = 0; i != writer->ops->num_entry_qwords; i++) {
+		/*
+		 * Check that masks are up to date, the make functions are not
+		 * allowed to set a bit to 1 if the used function doesn't say it
+		 * is used.
+		 */
+		WARN_ON_ONCE(target[i] & ~target_used[i]);
+
+		/* Bits can change because they are not currently being used */
+		unused_update[i] = (entry[i] & cur_used[i]) |
+				   (target[i] & ~cur_used[i]);
+		/*
+		 * Each bit indicates that a used bit in a qword needs to be
+		 * changed after unused_update is applied.
+		 */
+		if ((unused_update[i] & target_used[i]) != target[i])
+			used_qword_diff |= 1 << i;
+	}
+	return used_qword_diff;
+}
+
+static bool entry_set(struct arm_smmu_entry_writer *writer, __le64 *entry,
+		      const __le64 *target, unsigned int start,
+		      unsigned int len)
+{
+	bool changed = false;
+	unsigned int i;
+
+	for (i = start; len != 0; len--, i++) {
+		if (entry[i] != target[i]) {
+			WRITE_ONCE(entry[i], target[i]);
+			changed = true;
+		}
+	}
+
+	if (changed)
+		writer->ops->sync(writer);
+	return changed;
+}
+
+/*
+ * Update the STE/CD to the target configuration. The transition from the
+ * current entry to the target entry takes place over multiple steps that
+ * attempts to make the transition hitless if possible. This function takes care
+ * not to create a situation where the HW can perceive a corrupted entry. HW is
+ * only required to have a 64 bit atomicity with stores from the CPU, while
+ * entries are many 64 bit values big.
+ *
+ * The difference between the current value and the target value is analyzed to
+ * determine which of three updates are required - disruptive, hitless or no
+ * change.
+ *
+ * In the most general disruptive case we can make any update in three steps:
+ *  - Disrupting the entry (V=0)
+ *  - Fill now unused qwords, execpt qword 0 which contains V
+ *  - Make qword 0 have the final value and valid (V=1) with a single 64
+ *    bit store
+ *
+ * However this disrupts the HW while it is happening. There are several
+ * interesting cases where a STE/CD can be updated without disturbing the HW
+ * because only a small number of bits are changing (S1DSS, CONFIG, etc) or
+ * because the used bits don't intersect. We can detect this by calculating how
+ * many 64 bit values need update after adjusting the unused bits and skip the
+ * V=0 process. This relies on the IGNORED behavior described in the
+ * specification.
+ */
+static void arm_smmu_write_entry(struct arm_smmu_entry_writer *writer,
+				 __le64 *entry, const __le64 *target)
+{
+	unsigned int num_entry_qwords = writer->ops->num_entry_qwords;
+	__le64 unused_update[NUM_ENTRY_QWORDS];
+	u8 used_qword_diff;
+
+	used_qword_diff =
+		arm_smmu_entry_qword_diff(writer, entry, target, unused_update);
+	if (hweight8(used_qword_diff) == 1) {
+		/*
+		 * Only one qword needs its used bits to be changed. This is a
+		 * hitless update, update all bits the current STE is ignoring
+		 * to their new values, then update a single "critical qword" to
+		 * change the STE and finally 0 out any bits that are now unused
+		 * in the target configuration.
+		 */
+		unsigned int critical_qword_index = ffs(used_qword_diff) - 1;
+
+		/*
+		 * Skip writing unused bits in the critical qword since we'll be
+		 * writing it in the next step anyways. This can save a sync
+		 * when the only change is in that qword.
+		 */
+		unused_update[critical_qword_index] =
+			entry[critical_qword_index];
+		entry_set(writer, entry, unused_update, 0, num_entry_qwords);
+		entry_set(writer, entry, target, critical_qword_index, 1);
+		entry_set(writer, entry, target, 0, num_entry_qwords);
+	} else if (used_qword_diff) {
+		/*
+		 * At least two qwords need their inuse bits to be changed. This
+		 * requires a breaking update, zero the V bit, write all qwords
+		 * but 0, then set qword 0
+		 */
+		unused_update[0] = entry[0] & (~writer->ops->v_bit);
+		entry_set(writer, entry, unused_update, 0, 1);
+		entry_set(writer, entry, target, 1, num_entry_qwords - 1);
+		entry_set(writer, entry, target, 0, 1);
+	} else {
+		/*
+		 * No inuse bit changed. Sanity check that all unused bits are 0
+		 * in the entry. The target was already sanity checked by
+		 * compute_qword_diff().
+		 */
+		WARN_ON_ONCE(
+			entry_set(writer, entry, target, 0, num_entry_qwords));
+	}
+}
+
 static void arm_smmu_sync_cd(struct arm_smmu_master *master,
 			     int ssid, bool leaf)
 {
@@ -1238,50 +1387,126 @@ arm_smmu_write_strtab_l1_desc(__le64 *dst, struct arm_smmu_strtab_l1_desc *desc)
 	WRITE_ONCE(*dst, cpu_to_le64(val));
 }
 
-static void arm_smmu_sync_ste_for_sid(struct arm_smmu_device *smmu, u32 sid)
+struct arm_smmu_ste_writer {
+	struct arm_smmu_entry_writer writer;
+	u32 sid;
+};
+
+/*
+ * Based on the value of ent report which bits of the STE the HW will access. It
+ * would be nice if this was complete according to the spec, but minimally it
+ * has to capture the bits this driver uses.
+ */
+static void arm_smmu_get_ste_used(const __le64 *ent, __le64 *used_bits)
 {
+	unsigned int cfg = FIELD_GET(STRTAB_STE_0_CFG, le64_to_cpu(ent[0]));
+
+	used_bits[0] = cpu_to_le64(STRTAB_STE_0_V);
+	if (!(ent[0] & cpu_to_le64(STRTAB_STE_0_V)))
+		return;
+
+	/*
+	 * See 13.5 Summary of attribute/permission configuration fields for the
+	 * SHCFG behavior. It is only used for BYPASS, including S1DSS BYPASS,
+	 * and S2 only.
+	 */
+	if (cfg == STRTAB_STE_0_CFG_BYPASS ||
+	    cfg == STRTAB_STE_0_CFG_S2_TRANS ||
+	    (cfg == STRTAB_STE_0_CFG_S1_TRANS &&
+	     FIELD_GET(STRTAB_STE_1_S1DSS, le64_to_cpu(ent[1])) ==
+		     STRTAB_STE_1_S1DSS_BYPASS))
+		used_bits[1] |= cpu_to_le64(STRTAB_STE_1_SHCFG);
+
+	used_bits[0] |= cpu_to_le64(STRTAB_STE_0_CFG);
+	switch (cfg) {
+	case STRTAB_STE_0_CFG_ABORT:
+	case STRTAB_STE_0_CFG_BYPASS:
+		break;
+	case STRTAB_STE_0_CFG_S1_TRANS:
+		used_bits[0] |= cpu_to_le64(STRTAB_STE_0_S1FMT |
+					    STRTAB_STE_0_S1CTXPTR_MASK |
+					    STRTAB_STE_0_S1CDMAX);
+		used_bits[1] |=
+			cpu_to_le64(STRTAB_STE_1_S1DSS | STRTAB_STE_1_S1CIR |
+				    STRTAB_STE_1_S1COR | STRTAB_STE_1_S1CSH |
+				    STRTAB_STE_1_S1STALLD | STRTAB_STE_1_STRW);
+		used_bits[1] |= cpu_to_le64(STRTAB_STE_1_EATS);
+		used_bits[2] |= cpu_to_le64(STRTAB_STE_2_S2VMID);
+		break;
+	case STRTAB_STE_0_CFG_S2_TRANS:
+		used_bits[1] |=
+			cpu_to_le64(STRTAB_STE_1_EATS);
+		used_bits[2] |=
+			cpu_to_le64(STRTAB_STE_2_S2VMID | STRTAB_STE_2_VTCR |
+				    STRTAB_STE_2_S2AA64 | STRTAB_STE_2_S2ENDI |
+				    STRTAB_STE_2_S2PTW | STRTAB_STE_2_S2R);
+		used_bits[3] |= cpu_to_le64(STRTAB_STE_3_S2TTB_MASK);
+		break;
+
+	default:
+		memset(used_bits, 0xFF, sizeof(struct arm_smmu_ste));
+		WARN_ON(true);
+	}
+}
+
+static void arm_smmu_ste_writer_sync_entry(struct arm_smmu_entry_writer *writer)
+{
+	struct arm_smmu_ste_writer *ste_writer =
+		container_of(writer, struct arm_smmu_ste_writer, writer);
 	struct arm_smmu_cmdq_ent cmd = {
 		.opcode	= CMDQ_OP_CFGI_STE,
 		.cfgi	= {
-			.sid	= sid,
+			.sid	= ste_writer->sid,
 			.leaf	= true,
 		},
 	};
 
-	arm_smmu_cmdq_issue_cmd_with_sync(smmu, &cmd);
+	arm_smmu_cmdq_issue_cmd_with_sync(writer->master->smmu, &cmd);
+}
+
+static const struct arm_smmu_entry_writer_ops arm_smmu_ste_writer_ops = {
+	.sync = arm_smmu_ste_writer_sync_entry,
+	.get_used = arm_smmu_get_ste_used,
+	.v_bit = cpu_to_le64(STRTAB_STE_0_V),
+	.num_entry_qwords = sizeof(struct arm_smmu_ste) / sizeof(u64),
+};
+
+static void arm_smmu_write_ste(struct arm_smmu_master *master, u32 sid,
+			       struct arm_smmu_ste *ste,
+			       const struct arm_smmu_ste *target)
+{
+	struct arm_smmu_device *smmu = master->smmu;
+	struct arm_smmu_ste_writer ste_writer = {
+		.writer = {
+			.ops = &arm_smmu_ste_writer_ops,
+			.master = master,
+		},
+		.sid = sid,
+	};
+
+	arm_smmu_write_entry(&ste_writer.writer, ste->data, target->data);
+
+	/* It's likely that we'll want to use the new STE soon */
+	if (!(smmu->options & ARM_SMMU_OPT_SKIP_PREFETCH)) {
+		struct arm_smmu_cmdq_ent
+			prefetch_cmd = { .opcode = CMDQ_OP_PREFETCH_CFG,
+					 .prefetch = {
+						 .sid = sid,
+					 } };
+
+		arm_smmu_cmdq_issue_cmd(smmu, &prefetch_cmd);
+	}
 }
 
 static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
 				      struct arm_smmu_ste *dst)
 {
-	/*
-	 * This is hideously complicated, but we only really care about
-	 * three cases at the moment:
-	 *
-	 * 1. Invalid (all zero) -> bypass/fault (init)
-	 * 2. Bypass/fault -> translation/bypass (attach)
-	 * 3. Translation/bypass -> bypass/fault (detach)
-	 *
-	 * Given that we can't update the STE atomically and the SMMU
-	 * doesn't read the thing in a defined order, that leaves us
-	 * with the following maintenance requirements:
-	 *
-	 * 1. Update Config, return (init time STEs aren't live)
-	 * 2. Write everything apart from dword 0, sync, write dword 0, sync
-	 * 3. Update Config, sync
-	 */
-	u64 val = le64_to_cpu(dst->data[0]);
-	bool ste_live = false;
+	u64 val;
 	struct arm_smmu_device *smmu = master->smmu;
 	struct arm_smmu_ctx_desc_cfg *cd_table = NULL;
 	struct arm_smmu_s2_cfg *s2_cfg = NULL;
 	struct arm_smmu_domain *smmu_domain = master->domain;
-	struct arm_smmu_cmdq_ent prefetch_cmd = {
-		.opcode		= CMDQ_OP_PREFETCH_CFG,
-		.prefetch	= {
-			.sid	= sid,
-		},
-	};
+	struct arm_smmu_ste target = {};
 
 	if (smmu_domain) {
 		switch (smmu_domain->stage) {
@@ -1296,22 +1521,6 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
 		}
 	}
 
-	if (val & STRTAB_STE_0_V) {
-		switch (FIELD_GET(STRTAB_STE_0_CFG, val)) {
-		case STRTAB_STE_0_CFG_BYPASS:
-			break;
-		case STRTAB_STE_0_CFG_S1_TRANS:
-		case STRTAB_STE_0_CFG_S2_TRANS:
-			ste_live = true;
-			break;
-		case STRTAB_STE_0_CFG_ABORT:
-			BUG_ON(!disable_bypass);
-			break;
-		default:
-			BUG(); /* STE corruption */
-		}
-	}
-
 	/* Nuke the existing STE_0 value, as we're going to rewrite it */
 	val = STRTAB_STE_0_V;
 
@@ -1322,16 +1531,11 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
 		else
 			val |= FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_BYPASS);
 
-		dst->data[0] = cpu_to_le64(val);
-		dst->data[1] = cpu_to_le64(FIELD_PREP(STRTAB_STE_1_SHCFG,
+		target.data[0] = cpu_to_le64(val);
+		target.data[1] = cpu_to_le64(FIELD_PREP(STRTAB_STE_1_SHCFG,
 						STRTAB_STE_1_SHCFG_INCOMING));
-		dst->data[2] = 0; /* Nuke the VMID */
-		/*
-		 * The SMMU can perform negative caching, so we must sync
-		 * the STE regardless of whether the old value was live.
-		 */
-		if (smmu)
-			arm_smmu_sync_ste_for_sid(smmu, sid);
+		target.data[2] = 0; /* Nuke the VMID */
+		arm_smmu_write_ste(master, sid, dst, &target);
 		return;
 	}
 
@@ -1339,8 +1543,7 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
 		u64 strw = smmu->features & ARM_SMMU_FEAT_E2H ?
 			STRTAB_STE_1_STRW_EL2 : STRTAB_STE_1_STRW_NSEL1;
 
-		BUG_ON(ste_live);
-		dst->data[1] = cpu_to_le64(
+		target.data[1] = cpu_to_le64(
 			 FIELD_PREP(STRTAB_STE_1_S1DSS, STRTAB_STE_1_S1DSS_SSID0) |
 			 FIELD_PREP(STRTAB_STE_1_S1CIR, STRTAB_STE_1_S1C_CACHE_WBRA) |
 			 FIELD_PREP(STRTAB_STE_1_S1COR, STRTAB_STE_1_S1C_CACHE_WBRA) |
@@ -1349,7 +1552,7 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
 
 		if (smmu->features & ARM_SMMU_FEAT_STALLS &&
 		    !master->stall_enabled)
-			dst->data[1] |= cpu_to_le64(STRTAB_STE_1_S1STALLD);
+			target.data[1] |= cpu_to_le64(STRTAB_STE_1_S1STALLD);
 
 		val |= (cd_table->cdtab_dma & STRTAB_STE_0_S1CTXPTR_MASK) |
 			FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_S1_TRANS) |
@@ -1358,8 +1561,7 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
 	}
 
 	if (s2_cfg) {
-		BUG_ON(ste_live);
-		dst->data[2] = cpu_to_le64(
+		target.data[2] = cpu_to_le64(
 			 FIELD_PREP(STRTAB_STE_2_S2VMID, s2_cfg->vmid) |
 			 FIELD_PREP(STRTAB_STE_2_VTCR, s2_cfg->vtcr) |
 #ifdef __BIG_ENDIAN
@@ -1368,23 +1570,17 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
 			 STRTAB_STE_2_S2PTW | STRTAB_STE_2_S2AA64 |
 			 STRTAB_STE_2_S2R);
 
-		dst->data[3] = cpu_to_le64(s2_cfg->vttbr & STRTAB_STE_3_S2TTB_MASK);
+		target.data[3] = cpu_to_le64(s2_cfg->vttbr & STRTAB_STE_3_S2TTB_MASK);
 
 		val |= FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_S2_TRANS);
 	}
 
 	if (master->ats_enabled)
-		dst->data[1] |= cpu_to_le64(FIELD_PREP(STRTAB_STE_1_EATS,
+		target.data[1] |= cpu_to_le64(FIELD_PREP(STRTAB_STE_1_EATS,
 						 STRTAB_STE_1_EATS_TRANS));
 
-	arm_smmu_sync_ste_for_sid(smmu, sid);
-	/* See comment in arm_smmu_write_ctx_desc() */
-	WRITE_ONCE(dst->data[0], cpu_to_le64(val));
-	arm_smmu_sync_ste_for_sid(smmu, sid);
-
-	/* It's likely that we'll want to use the new STE soon */
-	if (!(smmu->options & ARM_SMMU_OPT_SKIP_PREFETCH))
-		arm_smmu_cmdq_issue_cmd(smmu, &prefetch_cmd);
+	target.data[0] = cpu_to_le64(val);
+	arm_smmu_write_ste(master, sid, dst, &target);
 }
 
 static void arm_smmu_init_bypass_stes(struct arm_smmu_ste *strtab,
-- 
2.43.0

