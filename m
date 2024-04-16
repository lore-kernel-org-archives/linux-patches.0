Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2083.outbound.protection.outlook.com [40.107.101.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DA72137C5B;
	Tue, 16 Apr 2024 19:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713295724; cv=fail; b=mfi+6TNjOgOE1NNEM5LXWL+pwrC4SI53vysQNXEIy6xc/yyBrj7LUesuVvWYL0ZUhaAaOAjaaoicK8XySaUnbEIBmWVog6SK0QuxbINzNHlC6ArXjrUjwG7L/i4UVvX1tPaHs77KNA3PUpaIGCuDdhsnDh35h1MaiVG4QCT9y6M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713295724; c=relaxed/simple;
	bh=a4UUBr1LCzIpi6OPQ3Va/Nq4syFb9kldccMYw6OOkmw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OCtTd2hcq57lRbNIBdKzMjKHiWwzvVExHC6eH/uUrwN/nnDX9ifVL5sVhziI5y9G3axwsNq6Hvf9DSMtL/vzcNGT0uUL2d5R839pRL+wLt+/URWM9sOL3NcQgUQOYSRUpqQODWv4PQDoFhvT9/A3MshWJvs3ZwOwu1djUSCLETA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hq56pmSr; arc=fail smtp.client-ip=40.107.101.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hq56pmSr"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V8QifPitVRxutGoluWKscYkSv1vr8U8rdlqgmkMDbx7OvrLPMg7QKzE3zqsiTzmwL3mcxFNKEuvJvIRAgSrGtM80efN5LrI5xoeXQf1fC1CZ7mtyrH216pjTxLVzbMu2qmsfkvXGFP1y7it4nVZA/4KHiTSGaYss8nU0XbmbmDrtPXGm+RjHTHqPy+PL60pBVfDTs7vCksknIft28ax6G1AfscTeQsw+3eVlUVuTxZjg0rzUCidJv1R9v9dVMX4arEBpEeiP/X6FU3RJiqe+VhPpDw/Rd/Ve8t8UNmYJWlz8osmM2BCe7fX4hVEa5rclDzURC40JDVt09yNxLnNfig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ASQiC4jkUH+R9y81XGv9aC7QMCCANMB28fOtrPUcsWk=;
 b=gZvZe1GGUqaCMQc3YmeBmwer1IfG3auu78/pDDvkDqOsamkNvCxzaWEs3O2ACcIeAewJOZCU8E37y77qoNTqIIryhvGpmYuiZyij4S5hBeN3jqi9qQw/SQm3Pe17uXF2IlZ0qeds9VHhaWDnfX2+Y2CkPRQAfOnmugafqoUG/Ri2uobIC3yjle6FHj0SllAE0aeC/gESWJ7RhXP+oXXGOLuxtXPYRJkgoALO2QYpq2L5++2U5IM9FpAwq4evbTGM0WxE2Vl0Jg1+w9aHBuINCig92Awc0iUV17hQe/u9mgpwh+aQ/yADmVwWV5jtRh1b53KJafc7xJkp/IjNAAyG6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ASQiC4jkUH+R9y81XGv9aC7QMCCANMB28fOtrPUcsWk=;
 b=hq56pmSrRsdr/tN/4qtouhaAwey9CWkxf2N8guNl7m25wDsY3nLrDJZuxXRABDS4aMb2LNo5IwqOEHHryHGvZTQOOU82M9pbG0RpJPfw1xJaOgEbp54r5ynHI7EQlVuZ9/lv1kK4bnECf/XTlSvB4E7fQxi5dPnqvzYmJHUMrzXBipCOWb8VeZChkJKQ2Q78EzyIF64axBDubLFjgIMrE6kbAiXINu/g264l5ulwXGqFSiEO60EEUx6l+gogxVCsmGtjwAu6hAd7howrOXEJGOKj28oZJ0T/LjkovRAYs9pIuGIBijbOaSc+ZL+XAncBcs2K7sdDP4LSvaSGjiUmkQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by CY8PR12MB8213.namprd12.prod.outlook.com (2603:10b6:930:71::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.50; Tue, 16 Apr
 2024 19:28:24 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7452.049; Tue, 16 Apr 2024
 19:28:24 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>,
	Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v7 3/9] iommu/arm-smmu-v3: Move the CD generation for S1 domains into a function
Date: Tue, 16 Apr 2024 16:28:14 -0300
Message-ID: <3-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0032.namprd11.prod.outlook.com
 (2603:10b6:806:d0::7) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|CY8PR12MB8213:EE_
X-MS-Office365-Filtering-Correlation-Id: 59cffe25-346c-4456-9647-08dc5e4b6183
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	2U59HQ3daFkO3E2n1IEqPkibWRvWnCWjPJqdQIgv8VtISJMnXmK+b/rb5UocvcVc0ICnvD2S2QUr09UCCCHEpGwfGvsTKyz9NumF9Sm6naFeLUfdZkn0Gcywx2351d9/j/iozofH5p2fW94gsxJo6BTruPIM+NEXWRSHtNZ6+4UuqwWoWdR8SDjzMAYuK+stCQAsD4CPej4r20FKlgkE4cwn4P5sS19DHH1gnLSL9MJKuWkeR7jNeHKqgv8LBliwURoVAralpP/Nt2wWDMFx4fNHIAcnQI+8YjPZt7jsy1Enzt1xTFL+TRYpAEA4fa+HRW/hQbvxkHBVkNpIiAa6s4yPVlzob/eo8kNb8kmnJcSQ2S4FSjqv/Vb14aZI/9P6BtoyNsY8dfNlOXTmcJfXXjspqIYIfBnZFBtkYH1Uuh+PkswxqnxhpR6h1Vz+trehgHC0HCkUcDdRUUsHS7rLaePVWXNAgdBmOmAHkoGcJwH5mOjsQzHdPM6tS9hhYnZ32rqYu0dsRvv7ihGj9OFNlMqmhcAd7pBxok5GAyWeTJd2g+R+8/cQIIILhCqeWpFZ1WHWlY22F3PsVEAhAL7UQU+VPjbqShSYWlQ+uWJCIFyxyysDQC3qQnY3gyqqy9jn/gp5wLudCTbJn57Cq34TTzN51Zaq9bv2PJMxDpLz9K8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PWf560i/o8aBHKNCD3gm2S2RxJrDL/TK0/J280VNu/hID9MugGjTQkyUKFUJ?=
 =?us-ascii?Q?CQnFrc/CMlYgXo+Ktht4JfXeFybdb+c0A73VvnQyDMsGPB4x744jYtPgMKrS?=
 =?us-ascii?Q?iGWmrUmeFapS6poAxC5g1NkVIdvCQd2pdSyij5sMJxrGACiGDpmSMOQe8wv1?=
 =?us-ascii?Q?nvNh6nrnhobY6fA0Wo/I2BIf9iGnM5fbEmSs/IKibcgxJm6Dn5e/L9bWtoLO?=
 =?us-ascii?Q?VWpXXY65aZ4ybGVPe5PYKJXqjIEYIVHfR8vUo94UAnVy6lJmrN0HQFao3i1l?=
 =?us-ascii?Q?zsimFOq5Xnyo0JGE8DZiuj5zxhdtWQ890aYt2NlAGWtlxxfTHZlz1253TuEy?=
 =?us-ascii?Q?JVk6Uq3EWz10Pt6V0XKMJ65NkKwv2Dwq8S9T4brTnS9q4qiE3sxJ7gJRk7OU?=
 =?us-ascii?Q?lITW/urghbvcUOX+n1PTEZ55L05uJsZU3L3r5Ft6/nYrUTDMUumzpkpdNStX?=
 =?us-ascii?Q?P5bYqkkl9Hkc3I6ya08OIxQO9L7u7ol/lOIdI1Il2Pw0Uhrz1EBIt9Mebr19?=
 =?us-ascii?Q?xLoM512VrrhRqK8dxhI1YCJoDYpU2TKSHs54MRSo4POHNxnquNUSKFAz4RAL?=
 =?us-ascii?Q?2y29kcfCsLOpMeQMsMteyJ0veU47n7Tw0fzTdbqxSAPZCQuu8qXzguEeXJlI?=
 =?us-ascii?Q?WPPCJOl9YZgCdMk91sjJcR2ZqdrWxpTsT+NH3JYINzAWzNQvdmWUFBbkDXn8?=
 =?us-ascii?Q?Hk+VsIB4f/GiEBHpWDYKLMZSTVXJcuf7hz7ferUBBNLtlbLJh41zaktYlWCq?=
 =?us-ascii?Q?8+hM1SdZ1FZJyZoA45zoXunRj8dPmm1jiQSL7Qn0lLnaLumudZ0MYpmzKcbN?=
 =?us-ascii?Q?wAqUKMuhJulpz8kSxoX8pu3cR1kfkSQKASMMFOaGmI7w224+QTaPYNhvIXu4?=
 =?us-ascii?Q?WzIwQng+4W7VOz9mye0lKbePX7UHSVJZQbH3Lu9LlrmiEfKHLsXV08odzPE4?=
 =?us-ascii?Q?K8VUxqEEuW07+cdQPaDmWlsAVgVB2F/Ed1/+/esr8sNTVc5W7FWtNkvoKQwY?=
 =?us-ascii?Q?f8j1I6l+PWELsdar5GlzsqdQxHI1+AjvtujG2h8b3t/OE7e/tHFvVGoT7f8r?=
 =?us-ascii?Q?2TlGaDyvdSSxL70J9ATQ63sAfRiOLU2zdEzoi6SG/Ms4stWGUrstjrGGvjr2?=
 =?us-ascii?Q?92WmZhIFSKaT15q6JDySkJuqC3As+Y54LkUbTGOBdz6Z4uWo8Bysa4f+L/jL?=
 =?us-ascii?Q?ojJkL/lQc/UOpu9R9rD2bNbSaeozF4rPitpz77f7RPhvJLJniobJlTvJ2r+q?=
 =?us-ascii?Q?YUJrMDGKIx9rvmPGKMmNbhSI8f4ZqUFzPnYjIjlXxawraRbvboMUaJWtr1PS?=
 =?us-ascii?Q?nw/6OB6OQ3tTZp/NdPiURma/IivIkv5uPopCQD+6NsVUJNY1zMzy9EIdF+Wu?=
 =?us-ascii?Q?r2eavBVaEkFdQUTgC6XsA4yDNZOke0dNcQ1Lq5PXdcu6b3Qa4w/Vc8eE/Jnl?=
 =?us-ascii?Q?YWX0RDG+ASBwneh4K/fsHoqkCmGHRKzP7Xu8CF3UGKL99KaSU6/4mTrPgjeq?=
 =?us-ascii?Q?1XMW69XGOmfIFb68qq7BwNWDRfdmmTabuO8MerfcdNc+MhOv8X5z97pFosxB?=
 =?us-ascii?Q?jmYyYVfOdJZHi2wzFaVn3LUZDOY5I22eoMLV2Tk7?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59cffe25-346c-4456-9647-08dc5e4b6183
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2024 19:28:23.4023
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qFEhJFzopDnIcYKC8ORT1/uvniJQ+YBOyu+sJ3Q7BZFjibnhZ4U+21BeZvzxUR4K
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8213

Introduce arm_smmu_make_s1_cd() to build the CD from the paging S1 domain,
and reorganize all the places programming S1 domain CD table entries to
call it.

Split arm_smmu_update_s1_domain_cd_entry() from
arm_smmu_update_ctx_desc_devices() so that the S1 path has its own call
chain separate from the unrelated SVA path.

arm_smmu_update_s1_domain_cd_entry() only works on S1 domains
attached to RIDs and refreshes all their CDs.

Remove the forced clear of the CD during S1 domain attach,
arm_smmu_write_cd_entry() will do this automatically if necessary.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Reviewed-by: Michael Shavit <mshavit@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 25 +++++++-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 60 +++++++++++++------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  9 +++
 3 files changed, 76 insertions(+), 18 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 41b44baef15e80..d159f60480935e 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -53,6 +53,29 @@ static void arm_smmu_update_ctx_desc_devices(struct arm_smmu_domain *smmu_domain
 	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
 }
 
+static void
+arm_smmu_update_s1_domain_cd_entry(struct arm_smmu_domain *smmu_domain)
+{
+	struct arm_smmu_master *master;
+	struct arm_smmu_cd target_cd;
+	unsigned long flags;
+
+	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
+	list_for_each_entry(master, &smmu_domain->devices, domain_head) {
+		struct arm_smmu_cd *cdptr;
+
+		/* S1 domains only support RID attachment right now */
+		cdptr = arm_smmu_get_cd_ptr(master, IOMMU_NO_PASID);
+		if (WARN_ON(!cdptr))
+			continue;
+
+		arm_smmu_make_s1_cd(&target_cd, master, smmu_domain);
+		arm_smmu_write_cd_entry(master, IOMMU_NO_PASID, cdptr,
+					&target_cd);
+	}
+	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
+}
+
 /*
  * Check if the CPU ASID is available on the SMMU side. If a private context
  * descriptor is using it, try to replace it.
@@ -96,7 +119,7 @@ arm_smmu_share_asid(struct mm_struct *mm, u16 asid)
 	 * be some overlap between use of both ASIDs, until we invalidate the
 	 * TLB.
 	 */
-	arm_smmu_update_ctx_desc_devices(smmu_domain, IOMMU_NO_PASID, cd);
+	arm_smmu_update_s1_domain_cd_entry(smmu_domain);
 
 	/* Invalidate TLB entries previously associated with that context */
 	arm_smmu_tlb_inv_asid(smmu, asid);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 3983de90c2fa01..d24fa13a52b4e0 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1204,8 +1204,8 @@ static void arm_smmu_write_cd_l1_desc(__le64 *dst,
 	WRITE_ONCE(*dst, cpu_to_le64(val));
 }
 
-static struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
-					       u32 ssid)
+struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
+					u32 ssid)
 {
 	__le64 *l1ptr;
 	unsigned int idx;
@@ -1268,9 +1268,9 @@ static const struct arm_smmu_entry_writer_ops arm_smmu_cd_writer_ops = {
 	.v_bit = cpu_to_le64(CTXDESC_CD_0_V),
 };
 
-static void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
-				    struct arm_smmu_cd *cdptr,
-				    const struct arm_smmu_cd *target)
+void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
+			     struct arm_smmu_cd *cdptr,
+			     const struct arm_smmu_cd *target)
 {
 	struct arm_smmu_cd_writer cd_writer = {
 		.writer = {
@@ -1283,6 +1283,32 @@ static void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
 	arm_smmu_write_entry(&cd_writer.writer, cdptr->data, target->data);
 }
 
+void arm_smmu_make_s1_cd(struct arm_smmu_cd *target,
+			 struct arm_smmu_master *master,
+			 struct arm_smmu_domain *smmu_domain)
+{
+	struct arm_smmu_ctx_desc *cd = &smmu_domain->cd;
+
+	memset(target, 0, sizeof(*target));
+
+	target->data[0] = cpu_to_le64(
+		cd->tcr |
+#ifdef __BIG_ENDIAN
+		CTXDESC_CD_0_ENDI |
+#endif
+		CTXDESC_CD_0_V |
+		CTXDESC_CD_0_AA64 |
+		(master->stall_enabled ? CTXDESC_CD_0_S : 0) |
+		CTXDESC_CD_0_R |
+		CTXDESC_CD_0_A |
+		CTXDESC_CD_0_ASET |
+		FIELD_PREP(CTXDESC_CD_0_ASID, cd->asid)
+		);
+
+	target->data[1] = cpu_to_le64(cd->ttbr & CTXDESC_CD_1_TTB0_MASK);
+	target->data[3] = cpu_to_le64(cd->mair);
+}
+
 static void arm_smmu_clean_cd_entry(struct arm_smmu_cd *target)
 {
 	struct arm_smmu_cd used = {};
@@ -2644,29 +2670,29 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
 
 	switch (smmu_domain->stage) {
-	case ARM_SMMU_DOMAIN_S1:
+	case ARM_SMMU_DOMAIN_S1: {
+		struct arm_smmu_cd target_cd;
+		struct arm_smmu_cd *cdptr;
+
 		if (!master->cd_table.cdtab) {
 			ret = arm_smmu_alloc_cd_tables(master);
 			if (ret)
 				goto out_list_del;
-		} else {
-			/*
-			 * arm_smmu_write_ctx_desc() relies on the entry being
-			 * invalid to work, clear any existing entry.
-			 */
-			ret = arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID,
-						      NULL);
-			if (ret)
-				goto out_list_del;
 		}
 
-		ret = arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID, &smmu_domain->cd);
-		if (ret)
+		cdptr = arm_smmu_get_cd_ptr(master, IOMMU_NO_PASID);
+		if (!cdptr) {
+			ret = -ENOMEM;
 			goto out_list_del;
+		}
 
+		arm_smmu_make_s1_cd(&target_cd, master, smmu_domain);
+		arm_smmu_write_cd_entry(master, IOMMU_NO_PASID, cdptr,
+					&target_cd);
 		arm_smmu_make_cdtable_ste(&target, master);
 		arm_smmu_install_ste_for_dev(master, &target);
 		break;
+	}
 	case ARM_SMMU_DOMAIN_S2:
 		arm_smmu_make_s2_domain_ste(&target, master, smmu_domain);
 		arm_smmu_install_ste_for_dev(master, &target);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 4b767e0eeeb682..bb08f087ba39e4 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -751,6 +751,15 @@ extern struct xarray arm_smmu_asid_xa;
 extern struct mutex arm_smmu_asid_lock;
 extern struct arm_smmu_ctx_desc quiet_cd;
 
+struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
+					u32 ssid);
+void arm_smmu_make_s1_cd(struct arm_smmu_cd *target,
+			 struct arm_smmu_master *master,
+			 struct arm_smmu_domain *smmu_domain);
+void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
+			     struct arm_smmu_cd *cdptr,
+			     const struct arm_smmu_cd *target);
+
 int arm_smmu_write_ctx_desc(struct arm_smmu_master *smmu_master, int ssid,
 			    struct arm_smmu_ctx_desc *cd);
 void arm_smmu_tlb_inv_asid(struct arm_smmu_device *smmu, u16 asid);
-- 
2.43.2

