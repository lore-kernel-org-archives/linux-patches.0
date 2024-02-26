Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2059.outbound.protection.outlook.com [40.107.96.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F16E12FB14;
	Mon, 26 Feb 2024 17:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708967270; cv=fail; b=nNkcTfR2nKp+wnjEaCIov04f6HFSExKYw1oR/nH60udTEHSFbPHGrzeuDGU9sHz25Yp1iZBfURNRGEZHnFDCaGDUdclOjzSJtjJMjThi15xrEh8qpH47jt+BeN6HgNQLRDHftoBq4/f3ZR5S6NiimQK9JBHSZAfiE929IucRxvE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708967270; c=relaxed/simple;
	bh=wlDhOWMmgWKRaMG2M1z1uHBdO6GT0cNDSYTiCW+ORaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=J5l4q65pwnUqxU/uW/S58CDtZ6D4/WoXCaDQd+s8XuBU35uAR+nXbXXb0+IWUoem0HZkVhW+mdKfHtg2ozvZl6zVIYicMQLoYbtTMvntoRxXfjy75M3aaNcKHvkk+QnTnOVps0n4ftohgiENkEP+gNzSN6cGJvZVDwjkVVdMyBU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=cp9timaU; arc=fail smtp.client-ip=40.107.96.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="cp9timaU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O1Z+msfGAnkCwPfAq4+Cm92RkcnzHcO9CfAtHYy7dc6QrxvCrbfiGhfmTjAg3tuE0Iq6yUt3oSVvv2eXPOoi60R2lCtV+o1wFpjk7tW5XJhz6F5fc1exL6hHirOvv5K/Ihde7rYR71WZ1I/xz2iBwnA2iWlnfqzVBoeeG9dnpFrxQ7xD2PcslKtTOnYsx8MHPwzqtvZriJ3LvowhPBrTuPq0XH9k1dpSz8sYdU1zK4Wq0SjuGcFwxG23aLsSdTqefi4M7nF0Vy608V3ORUNaNFOezWUcIfVv/4Bi2ZsL3fHubBreoN268V7KVb5nQIu+S+zSNwlQkvUmxZqR6ZG8Qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=56zE1cCMNvD/FkO8Ni1b2Qx/pMDGtEjDvt+jBWYMAr4=;
 b=FAcdd8Dy0XvDskZc8H44AedmwGpor7jwgPi7M8fEIUnxcBFzS/vXP5e9evwrn056QinELsr//Q5hB2YykuF/rNe33lGy5O8Lf+rgzGejYARN8BZ4ACiNFO+JjCGO7OP7c4jsTQWO/Fgqatp4OcQB+lUJQshf0dzDvQnF8PxJNywy7pcAXrXZEwAHVLu3UWSdgGroSws7EboLrL7ptQWpGgx+PN2ui+Xiz/VZnESuTGOnwkgGFALuv8V95jfdg5mHyDKe2+vy+mc3x++bPHIh+Clc9pEKtTpjzTKmC1Yge9Mak8eLX+0Gk4h/gg94iyU2oxqroTS1Yg7uQfcKoje66w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=56zE1cCMNvD/FkO8Ni1b2Qx/pMDGtEjDvt+jBWYMAr4=;
 b=cp9timaUHsrVpe5y9jHeQDzfiQrGbPIANPmjkmrMrod7H0VxqycERSBe0UlA4BXJ8dYIy0FydjhN88bCJkB9eDDC+qOCN9zb/0l1M448e2UIm0IwJNNQs54PZM/ChXEqtuc/+AixKuACAyvYFHpZogITsNP4HmWlqvFtXqu/IGWE8F4Ip/EZ8Vy45y5vKMOe5iX29JwaIfq/AXOr+OgyiglNugmOxUx/VCteiIyC2VjQrCASkzvTPaGkNGMNc9/UsW+iTnOB89K1JUw5yHaATTVgrUsmKiPCQtQc7wAHzvDsdCv2zXr0POUPaPqUP1zVy+XemM43esnqXOwArGqW3Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by PH7PR12MB6905.namprd12.prod.outlook.com (2603:10b6:510:1b7::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.33; Mon, 26 Feb
 2024 17:07:35 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::2e3e:c7c0:84da:3941]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::2e3e:c7c0:84da:3941%6]) with mapi id 15.20.7316.034; Mon, 26 Feb 2024
 17:07:35 +0000
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
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH v6 01/16] iommu/arm-smmu-v3: Make STE programming independent of the callers
Date: Mon, 26 Feb 2024 13:07:12 -0400
Message-ID: <1-v6-96275f25c39d+2d4-smmuv3_newapi_p1_jgg@nvidia.com>
In-Reply-To: <0-v6-96275f25c39d+2d4-smmuv3_newapi_p1_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR1501CA0009.namprd15.prod.outlook.com
 (2603:10b6:207:17::22) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|PH7PR12MB6905:EE_
X-MS-Office365-Filtering-Correlation-Id: 4cccee0a-e3f9-4c5b-cc68-08dc36ed6aa0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	3VLjCs3x/C9fPZoq0GrcbQQMrNrHIEfhO3rLQJ7Ss/3r3+BJUUwbYqg4IPFeBj42b8V8PUhn0tpXY2tRyKfg53I0ouAvJ0j4VdS4OvPvNoC5ltDg0/XnL456xUkCc4Mq3QN91C6mhvItK4l4YjPQy5oXjuF6H0RdUUJKE04zogsQyKpSLNT9RLO5n7KI8VWnKF1Ft3xMy2pDBI/6fD9JLXGpPLM7brJXSV2voBuUrr47f0e78Dfz71J9PAIexbBpX+2tgzr8QNcgkB+fMqyY8wMMLSWIQpQF3ptBe/xWTmuRJv6VAmonCJ/wb3bx+AbxUApaU3l4v5hyz5WfWOOZ97yxsrQ6UU4WSv7gU3FuMMy7A495wPloqC2GV58oce+1I2Q7aGSGYnOtLAkusmWms/calfiM6LIlo/H3Nx9SgV9O/BLhGX3+qtFRIZ6tKh8vPYHoJt67lRst2qwh41rWgIC3bDXpG0mBcjk5iEr53oZLzParY+UvB9Fw0zawBI1OZ84UEpfAyvl8krzr4HbjcmvN/pwLwX52nbtMO4oLvkez8m6nblFti4ROIAhmNuar9erkIdztLBwbPtADeOIw2pX/B0C7Gt+Ld/NtKHP7BjRIXZr0jkWBiQ+nlOqPyVIMyszuXywh3VgEWmcKY5zMEw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?UYn9QZIgtzvaJhJZcWuaKKNri0XNt4KdOfO3BKF3TNqVYRac1oVmQAmzvz3x?=
 =?us-ascii?Q?6fK319uTyV6STiCZeFuCbPGV+HhFbGBSA2lv+G3pYmZAfQDFzzBEG0aMaR4d?=
 =?us-ascii?Q?GAtjrfihLW2LEUHMK/1P4Tku/M7P0IKvStWaz9FQz0qHraWMoohwrR4HRsZM?=
 =?us-ascii?Q?gGoGaICJwgGB5+9NGn6gXyPFV40ss1Ft4H0mXpu/Ou29IjUYh1bg+nbTV9Dq?=
 =?us-ascii?Q?A6UKtOgPSxX6wABFrOb6njeExtgjKThMh95PSqBfTf2aFHY+5QYAZ/qCNUpZ?=
 =?us-ascii?Q?vWGxAmHaD2sPix0xAd9wSvZZ24l/xEK43ClJWppXF31nkpjf4NhiiR4LIWcz?=
 =?us-ascii?Q?/UxHUuO/IFP86Jqcgb95I4tnn9UDJMwbdtoLFQRHb7O6l0s3ZvTGqjJBMafH?=
 =?us-ascii?Q?Zofs432ml8prWE/N1gRNVOsGPb8iMmpiy53CugJwC27DUD7tCq3cU1Ozx9Uc?=
 =?us-ascii?Q?vZuPJjMwBrdcD26L6NuJodUCEllzRBJeqsXPmlXsyzFBkbhmMAjSyQjUloJG?=
 =?us-ascii?Q?KQ0grKPDoGYiWO4XGhQsWvI9Q6syHLi/uLT7dexLsr+jJPXP3jtqJ36kI/fe?=
 =?us-ascii?Q?8eMDnchKhYdFD3OCZhI9dsDRaZgDJfKceovLICXHRdsw2LdYICp7Svqsvd2o?=
 =?us-ascii?Q?jKLJNZbdVt2djOQLJ33I2xXGlZQtoz6khWKuCi247+s8cp37QqRpRwAxkgTA?=
 =?us-ascii?Q?IITsKlqdNW3lE79MIh3vzBq29u/Nnfa8I2SU9xdpvpi7imJcgtYDkd+g/V8O?=
 =?us-ascii?Q?53S7dC3gK9sFW4UBFRmx7Pb4NiZlgSM+rtKFz60zj1fRy1e6Lcvsqo2FmZ/w?=
 =?us-ascii?Q?fLt7qF10TI6bWt7eWd7iQryzf6V3UaftoTi+88eODzYFQrSa1EdA7VDWhkzA?=
 =?us-ascii?Q?tFB1yH8mpf+KYijhU7gFlztI1kLWIIRp6HyMdsOE4c5uyvfQ5410v5raveFe?=
 =?us-ascii?Q?NzFuERSQGa72JVocNlNeRj4iZfyjy68UL0Cgz0KFhS8XoRRMEBfj0aK4UEgY?=
 =?us-ascii?Q?+EKVtZKCk/yzyOkPacHBnpFJ/Kxfyyy4Wfw/KQemWyqODcuTOnDKzYQMWMkB?=
 =?us-ascii?Q?fcyHlWA0cysChO/Qj7pRot4QToIo1/b3vhgfZwhMNhb1ptPo/ZTk/OZAlYfi?=
 =?us-ascii?Q?7od2heRm3EYvLr2YvbhWbjuvQpEa+Lvbg01KHfUDBcQuh5iVWcMROIlw6TZQ?=
 =?us-ascii?Q?rEn0mPLAAnpcqOeY5jH12dtVZKCLXWCv53C/Jec+U6uNZzJvAbuV7nJWba3i?=
 =?us-ascii?Q?Wt0EqCf399q3+PboDsMjGoat6qWIVRt7jz2Zz0RltQ97kze2YjGy+ub0yn6y?=
 =?us-ascii?Q?rw403FrD9HAtKjiDdTZpkXJ7cq48+DUjh8muMhC3vSgi0uIZQDEUsVxTWQax?=
 =?us-ascii?Q?Tlapm6xpBJYoHRRW/NtHFiLhpoCR+UompPSXEfC9xzfe/sIJYPD0wmeN6VYd?=
 =?us-ascii?Q?nk27p7RxFagbAFhGwmZUfriTw6J5o2JXuKiAvv9ZPYSntlrfXltMZ56ejIXD?=
 =?us-ascii?Q?qE+7cCNNGpc8h3l4o0GTudn7yJMdas/UZUQnpZjtIV2pX50r9DXd3pwyG+ER?=
 =?us-ascii?Q?k96Cqyca5yHREObL8OnaZz55UErFkKA9vI4d2FwF?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cccee0a-e3f9-4c5b-cc68-08dc36ed6aa0
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2024 17:07:30.5950
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YxACDlowARtQenH5OzDmNBc8ENoK3BA9Qm5i4RaGauYM7bjtHzEVn4alU/tIgZ5Y
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6905

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
   into the hypervisor. To comprehensively emulate the HW in a VM we
   should assume the VM OS is running logic like this and expecting
   hitless updates to be relayed to real HW.

For CD updates arm_smmu_write_ctx_desc() has a similar comment explaining
how limited it is, and the driver does have a need for hitless CD updates:

 - SMMUv3 BTM S1 ASID re-label

 - SVA mm release should change the CD to answert not-present to all
   requests without allowing logging (EPD0)

The next patches/series are going to start removing some of this logic
from the callers, and add more complex state combinations than currently.
At the end everything that can be hitless will be hitless, including all
of the above.

Introduce arm_smmu_write_ste() which will run through the multi-qword
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

Add STRTAB_STE_1_SHCFG_INCOMING to s2_cfg, this was editing the STE in
place and subtly inherited the value of data[1] from abort/bypass.

Signed-off-by: Michael Shavit <mshavit@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 275 +++++++++++++++-----
 1 file changed, 211 insertions(+), 64 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 0ffb1cf17e0b2e..9805d989dafd79 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -48,6 +48,9 @@ enum arm_smmu_msi_index {
 	ARM_SMMU_MAX_MSIS,
 };
 
+static void arm_smmu_sync_ste_for_sid(struct arm_smmu_device *smmu,
+				      ioasid_t sid);
+
 static phys_addr_t arm_smmu_msi_cfg[ARM_SMMU_MAX_MSIS][3] = {
 	[EVTQ_MSI_INDEX] = {
 		ARM_SMMU_EVTQ_IRQ_CFG0,
@@ -971,6 +974,199 @@ void arm_smmu_tlb_inv_asid(struct arm_smmu_device *smmu, u16 asid)
 	arm_smmu_cmdq_issue_cmd_with_sync(smmu, &cmd);
 }
 
+/*
+ * Based on the value of ent report which bits of the STE the HW will access. It
+ * would be nice if this was complete according to the spec, but minimally it
+ * has to capture the bits this driver uses.
+ */
+static void arm_smmu_get_ste_used(const struct arm_smmu_ste *ent,
+				  struct arm_smmu_ste *used_bits)
+{
+	unsigned int cfg = FIELD_GET(STRTAB_STE_0_CFG, le64_to_cpu(ent->data[0]));
+
+	used_bits->data[0] = cpu_to_le64(STRTAB_STE_0_V);
+	if (!(ent->data[0] & cpu_to_le64(STRTAB_STE_0_V)))
+		return;
+
+	used_bits->data[0] |= cpu_to_le64(STRTAB_STE_0_CFG);
+
+	/* S1 translates */
+	if (cfg & BIT(0)) {
+		used_bits->data[0] |= cpu_to_le64(STRTAB_STE_0_S1FMT |
+						  STRTAB_STE_0_S1CTXPTR_MASK |
+						  STRTAB_STE_0_S1CDMAX);
+		used_bits->data[1] |=
+			cpu_to_le64(STRTAB_STE_1_S1DSS | STRTAB_STE_1_S1CIR |
+				    STRTAB_STE_1_S1COR | STRTAB_STE_1_S1CSH |
+				    STRTAB_STE_1_S1STALLD | STRTAB_STE_1_STRW |
+				    STRTAB_STE_1_EATS);
+		used_bits->data[2] |= cpu_to_le64(STRTAB_STE_2_S2VMID);
+	}
+
+	/* S2 translates */
+	if (cfg & BIT(1)) {
+		used_bits->data[1] |=
+			cpu_to_le64(STRTAB_STE_1_EATS | STRTAB_STE_1_SHCFG);
+		used_bits->data[2] |=
+			cpu_to_le64(STRTAB_STE_2_S2VMID | STRTAB_STE_2_VTCR |
+				    STRTAB_STE_2_S2AA64 | STRTAB_STE_2_S2ENDI |
+				    STRTAB_STE_2_S2PTW | STRTAB_STE_2_S2R);
+		used_bits->data[3] |= cpu_to_le64(STRTAB_STE_3_S2TTB_MASK);
+	}
+
+	if (cfg == STRTAB_STE_0_CFG_BYPASS)
+		used_bits->data[1] |= cpu_to_le64(STRTAB_STE_1_SHCFG);
+}
+
+/*
+ * Figure out if we can do a hitless update of entry to become target. Returns a
+ * bit mask where 1 indicates that qword needs to be set disruptively.
+ * unused_update is an intermediate value of entry that has unused bits set to
+ * their new values.
+ */
+static u8 arm_smmu_entry_qword_diff(const struct arm_smmu_ste *entry,
+				    const struct arm_smmu_ste *target,
+				    struct arm_smmu_ste *unused_update)
+{
+	struct arm_smmu_ste target_used = {};
+	struct arm_smmu_ste cur_used = {};
+	u8 used_qword_diff = 0;
+	unsigned int i;
+
+	arm_smmu_get_ste_used(entry, &cur_used);
+	arm_smmu_get_ste_used(target, &target_used);
+
+	for (i = 0; i != ARRAY_SIZE(target_used.data); i++) {
+		/*
+		 * Check that masks are up to date, the make functions are not
+		 * allowed to set a bit to 1 if the used function doesn't say it
+		 * is used.
+		 */
+		WARN_ON_ONCE(target->data[i] & ~target_used.data[i]);
+
+		/* Bits can change because they are not currently being used */
+		unused_update->data[i] = (entry->data[i] & cur_used.data[i]) |
+					 (target->data[i] & ~cur_used.data[i]);
+		/*
+		 * Each bit indicates that a used bit in a qword needs to be
+		 * changed after unused_update is applied.
+		 */
+		if ((unused_update->data[i] & target_used.data[i]) !=
+		    target->data[i])
+			used_qword_diff |= 1 << i;
+	}
+	return used_qword_diff;
+}
+
+static bool entry_set(struct arm_smmu_device *smmu, ioasid_t sid,
+		      struct arm_smmu_ste *entry,
+		      const struct arm_smmu_ste *target, unsigned int start,
+		      unsigned int len)
+{
+	bool changed = false;
+	unsigned int i;
+
+	for (i = start; len != 0; len--, i++) {
+		if (entry->data[i] != target->data[i]) {
+			WRITE_ONCE(entry->data[i], target->data[i]);
+			changed = true;
+		}
+	}
+
+	if (changed)
+		arm_smmu_sync_ste_for_sid(smmu, sid);
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
+static void arm_smmu_write_ste(struct arm_smmu_master *master, u32 sid,
+			       struct arm_smmu_ste *entry,
+			       const struct arm_smmu_ste *target)
+{
+	unsigned int num_entry_qwords = ARRAY_SIZE(target->data);
+	struct arm_smmu_device *smmu = master->smmu;
+	struct arm_smmu_ste unused_update;
+	u8 used_qword_diff;
+
+	used_qword_diff =
+		arm_smmu_entry_qword_diff(entry, target, &unused_update);
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
+		unused_update.data[critical_qword_index] =
+			entry->data[critical_qword_index];
+		entry_set(smmu, sid, entry, &unused_update, 0, num_entry_qwords);
+		entry_set(smmu, sid, entry, target, critical_qword_index, 1);
+		entry_set(smmu, sid, entry, target, 0, num_entry_qwords);
+	} else if (used_qword_diff) {
+		/*
+		 * At least two qwords need their inuse bits to be changed. This
+		 * requires a breaking update, zero the V bit, write all qwords
+		 * but 0, then set qword 0
+		 */
+		unused_update.data[0] = entry->data[0] & (~STRTAB_STE_0_V);
+		entry_set(smmu, sid, entry, &unused_update, 0, 1);
+		entry_set(smmu, sid, entry, target, 1, num_entry_qwords - 1);
+		entry_set(smmu, sid, entry, target, 0, 1);
+	} else {
+		/*
+		 * No inuse bit changed. Sanity check that all unused bits are 0
+		 * in the entry. The target was already sanity checked by
+		 * compute_qword_diff().
+		 */
+		WARN_ON_ONCE(
+			entry_set(smmu, sid, entry, target, 0, num_entry_qwords));
+	}
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
+}
+
 static void arm_smmu_sync_cd(struct arm_smmu_master *master,
 			     int ssid, bool leaf)
 {
@@ -1254,34 +1450,12 @@ static void arm_smmu_sync_ste_for_sid(struct arm_smmu_device *smmu, u32 sid)
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
@@ -1296,22 +1470,6 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
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
 
@@ -1322,16 +1480,11 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
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
 
@@ -1339,8 +1492,7 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
 		u64 strw = smmu->features & ARM_SMMU_FEAT_E2H ?
 			STRTAB_STE_1_STRW_EL2 : STRTAB_STE_1_STRW_NSEL1;
 
-		BUG_ON(ste_live);
-		dst->data[1] = cpu_to_le64(
+		target.data[1] = cpu_to_le64(
 			 FIELD_PREP(STRTAB_STE_1_S1DSS, STRTAB_STE_1_S1DSS_SSID0) |
 			 FIELD_PREP(STRTAB_STE_1_S1CIR, STRTAB_STE_1_S1C_CACHE_WBRA) |
 			 FIELD_PREP(STRTAB_STE_1_S1COR, STRTAB_STE_1_S1C_CACHE_WBRA) |
@@ -1349,7 +1501,7 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
 
 		if (smmu->features & ARM_SMMU_FEAT_STALLS &&
 		    !master->stall_enabled)
-			dst->data[1] |= cpu_to_le64(STRTAB_STE_1_S1STALLD);
+			target.data[1] |= cpu_to_le64(STRTAB_STE_1_S1STALLD);
 
 		val |= (cd_table->cdtab_dma & STRTAB_STE_0_S1CTXPTR_MASK) |
 			FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_S1_TRANS) |
@@ -1358,8 +1510,9 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
 	}
 
 	if (s2_cfg) {
-		BUG_ON(ste_live);
-		dst->data[2] = cpu_to_le64(
+		target.data[1] = cpu_to_le64(FIELD_PREP(STRTAB_STE_1_SHCFG,
+						STRTAB_STE_1_SHCFG_INCOMING));
+		target.data[2] = cpu_to_le64(
 			 FIELD_PREP(STRTAB_STE_2_S2VMID, s2_cfg->vmid) |
 			 FIELD_PREP(STRTAB_STE_2_VTCR, s2_cfg->vtcr) |
 #ifdef __BIG_ENDIAN
@@ -1368,23 +1521,17 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
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
2.43.2

