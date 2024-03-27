Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2088.outbound.protection.outlook.com [40.107.92.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A657A14E2FC;
	Wed, 27 Mar 2024 18:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711562928; cv=fail; b=K596vgweOGmcZUI65DAkvuasp1YJ0b7Oq3uKU1gk07NI2Sx5/2c/P3H5XmWf4DTbu2UpY6flTUuVShmWIQ+13YgJOB5dSoYCcIJDwEs+cbmMPjWH62JmX30yMHgB0mDY7NtuGKJf9pdFhPjchfizPvKTxGikoWksx1xhQB9HpCE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711562928; c=relaxed/simple;
	bh=kqhh1rxfAtOC7/XY8hNfJSHCEh661AMgvft3OnrsBQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=d9Vi7JemdotuO81v7msw3ZeLFMiBbChB9qSQv/MtIoj8CsdZp0CVIgHkQOI2DFgcL1z9ZdBq96dWJybKQx9XIZ0bdxdx3bw5ZFQtaROJ2I905/05Vx3qqvgeA86za3ZGn6KLaY+h6qNYPsnx6r+YpaN6QWUR82KfZzGT07kOswk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=SaMG4PQU; arc=fail smtp.client-ip=40.107.92.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="SaMG4PQU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lWBvQfNJamQ7fArcgtC3z0329PRRm9xhdmUGYTTs79fx4Bg6V6NLPjYRzEmluYJCelDAN4QTPRfGDL9ulBTzCVdW3IT+wgycatS/b98QEqw+13ecsOPVdIYL9jlMjlX/beonJVXK/dWYAP1DeK82l/C+TreG/UrlatulQFQ7Dk+L0XzSlQrEfTqxTGhWfQrPkwpr1XRuteSEooFkl2TV3fhIrbLGTvLeFeUPI/webCCuhrEoUoUnG5Y0+cyfxuAR+Mi5luKtD56dbcH4rd58qe+RYF6WB6UdCKqOLXi6M0L309mh6MZNJNXif25vNnkiDFlxsvXZbqQTt0Ch4SnN7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wuZ8uXi0Y7MfOGtYqppEmrCbTgTklmpT9Fao4yNrIhY=;
 b=UaLxEFxLW9439R3+CC2LvB1arlhxxegLnWMxwuoXnLp/iQLqE4cLcS4dz2d5X+Lg+RUCqZdcgFNgB6QurxTFBcRhqM/JweMjbDQMFxuxnRw5shjT6TIjGsjEP3MHp4xHwOVLunwkqhz+0qsE3V2ukgEI8hfGeqy8UrY5D/A9mLHeT01mNlr+HHPmwt7ppxqddTs78ErUgehKsl3pUiWxZd8AgI9ndLYjPFSWyYvHB3RsBP+YDmx2TKaPReSI0ZLjbDMMAWThsaXr4BtsY4fEshKNZ0GQBZEv1H90HuSarG1H1oQELk0GF86QN4BKc5wjN6bZ30LkJkqMK8hu0CTz0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wuZ8uXi0Y7MfOGtYqppEmrCbTgTklmpT9Fao4yNrIhY=;
 b=SaMG4PQUAkg34cwHVBPItxnHXdkcl/q9YwwS+8y+GG143vr2CGDpMXkHlSU5QJ4K+upYhZEG+QLLQ5SUUqrxeEaBDm7RDdwoIjIuCLX4czIFjdh/fHfkXOcwipYi7TG1CPRcPPgP0FYp8FsQrshDYy4bvyxes2A1Yaen/RLCf+y2AhgM5mhHsPt+Elpo6blFE8BDBVzjWPuQTkuFguwBHdpptohjMaKV04wD52wg4MI78kNJuEVnjnZ89++a/BD2FuBsz6RbN4Vo649q1bLChH02113y98P9s+yDx5wov/7TcWtN5MMOzYMq+39daWcco+sy5ViMDhqrISQlaAOi/g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by IA1PR12MB6044.namprd12.prod.outlook.com (2603:10b6:208:3d4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Wed, 27 Mar
 2024 18:08:33 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 18:08:33 +0000
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
Subject: [PATCH v6 17/29] iommu/arm-smmu-v3: Add ssid to struct arm_smmu_master_domain
Date: Wed, 27 Mar 2024 15:08:03 -0300
Message-ID: <17-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR05CA0015.namprd05.prod.outlook.com
 (2603:10b6:208:91::25) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|IA1PR12MB6044:EE_
X-MS-Office365-Filtering-Correlation-Id: f99f0824-4a9a-4be1-1327-08dc4e88e22c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	vE5X32rUgi/4dqxw4a5U+rhJxTxaXFIn58dVTaW3ubHfrQlqrmoHENocAugxcTSe66/Xb/14HIO+cd3soE/MuMxMIYntdVDh9uDugep4Uats1MiYgwV7870PF3q39L5ufhDU6rzqNuIanGb3PHvJxZaJ9DTJwkzOzWi/qG4B2s84ha+4lytePpMTI+fvq1jaldSxBVqxn/qWoPptt0zfGrV40T396p2d4+VdXBEmEpOW8eSHoUs2Py/SLL2P+1zHMsBmN6t58ZaxA3quW8vGMzJ+Y9UqqUhChIikzdMIb9p2qCDj8T45tPV7gv7UIEDvvCo54CDQ46NuoFPNcVpPZYCAdBLfJzAxelEO5IKmpH33xiDyMCtv32rMgQLapYrM3ctLTGQ56bhxB85OWef6AXuhGIUZbAlgnwbLmLCakDz3HySOBf/86HK2XwWEiRTLo/CL6+rCohO+VkxavcZxuWcyDefZx9kk15QCxq2yCCzTp5t1ztCVxOvpuFPQbnv4V1T8d9rvhId1M+Z9nIf614dAjflQgquMU0edv1L09ZhiZQGfhuV5V6zLICpvnq95AWPLxEniCHrGKCu87LQlI5iotRfVSZs2AGeR7J0h7hzWE0umsHVPZy1uU67LPJySAFP1AsHZDfG9LASL4kilLkihra/JtysyFuNrSFA6kLQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GbKOtGa+cN+CjzkSAXugbWkbPaQ6MUWiV4+UX7kLUhnJIU4/jpZ7O1SP8oTS?=
 =?us-ascii?Q?Fkx3F1JoL0Vmxml68BQkzCFad1r9YBrEKLIOB8oh/jmdLtuaFid4quxrJYNg?=
 =?us-ascii?Q?hl58K2UjywyGBi8Crv/u9OG6/Ok+p8rFrKOa32F7cGu13VjfjzbsoKiO0Tb6?=
 =?us-ascii?Q?iMJmzVKYmNeD6enFwRSKU+HwCNU9XZptIqEpRMmpuuZ65TCHjOq9fguknZaz?=
 =?us-ascii?Q?vchci+G1dR5mXIjNpGIWbkmfG3CHdwT1qZnbsbnL6WE+RqTKzGTNLqOuD1bQ?=
 =?us-ascii?Q?WonEd7/TR2ZOF/fBZWxOTQJU43+6AKpFYMVLoUJmy3E93G1b+qfxfKFWtMj4?=
 =?us-ascii?Q?M2FYbj1glxWdFsIq8HrCkulQ1rpOXWCCkb1JZKhdsJiq0clPWrH6HpgjO/82?=
 =?us-ascii?Q?BcKnfIyWkdERUGkcvmBLYCqYVF0Yk4AgUe5Hsz1UCCmEPVfRxHiDmTaFlRcS?=
 =?us-ascii?Q?cyTIVZh4hDOEHbqY4vxiCQUeqNkO9Zu/437gFCtd2v4PybLr4Jp5V6em3OXY?=
 =?us-ascii?Q?crMi5TztWkTptb4eEH7QlG8GfqSTrKC5M1ND0swCB4R7lAN3Pf0uoE6rgq5R?=
 =?us-ascii?Q?yYY/XUsRlr54bvZrLekjVHe6nkTJ9iUE8Sc4AnntX8WbrV3Ql4jMJlTmHQvE?=
 =?us-ascii?Q?Rn5qjzO/h0BJuDdIqrXn/qyvWboOmJGB3KKUrjm7ixE1GYQGe7kMEmSV6OvV?=
 =?us-ascii?Q?tuIa8/ed1d4j2MwESQX2E9KhgKPGgBPp03Pg9rkOPY2tOS4pDfWcuvZhxmYD?=
 =?us-ascii?Q?IhH7PKOY4jEtSa3KvQ/BjM9zMcRZXOVHe1Q/sTWraxupKkez7zWFNROamiJh?=
 =?us-ascii?Q?6+/sTUJaoewWkquz0uegCAmotz8GNMrPEmDLJ+d2dnkybcy2cAx9iWPmuHCi?=
 =?us-ascii?Q?Os33a+1ZpYZlvzIxPNp7MGirVtyJ5aj+ZcMHOYqEtPsNxL+bxNHlftuZV+XD?=
 =?us-ascii?Q?JlB971xEQ/FZZpVgtjt01tAxYh0LzIFhaZTnpjMcVHbp4xtRzc1b7jd7CAGW?=
 =?us-ascii?Q?4nt8TRvxF0e/kSmnbJw2LDhXeoN8UWKRVyqVCoraQwuJxambCDqWsnA6+taH?=
 =?us-ascii?Q?/BHcxjcXJp3CiDxv18l+9GnsSp5getIlGRpHXj449pVMyMiqWCpQvyVKODNm?=
 =?us-ascii?Q?mnvYi8hGn5v4EF/Tw93paPOB6RK81zZxOpu0OQI/hJmPKKJGJp7sr7BiY2PF?=
 =?us-ascii?Q?lcwgspeq8877KKOsBe/i8vr7dZLnrglvQOm7wA9F1Bgb1MdlB1Hyp+RrYhCR?=
 =?us-ascii?Q?Ls3GQ3Vv3us0C5HSzFd9h1HYot7aeY97X60tMFEyzUJ7skbONcdegQbrT5T/?=
 =?us-ascii?Q?5mymptHscjzU7R8Ri4HKznbQWKnchXP+PVJ5BZhyCTUrxp9xULAgQCcjuQmF?=
 =?us-ascii?Q?19RqcMuu0N5lODh+2QDdsPV1KWcF4wY4PSP8/qHMibp8gNPKt+dpTpD2NUzU?=
 =?us-ascii?Q?C9wIWOstvERt5b50mO/qcmMIOyuW42PjKtJz3i/7e5v3gvHovnRyyDCalaYJ?=
 =?us-ascii?Q?+0B8i4b1/f6vwLfP47kWkDQ1R3VK/Z/nKvQoRLMxl49v/jGeoSeI5KATLvpR?=
 =?us-ascii?Q?3z9IenpVoj4+71qdNllMpdMvZsxw1qJBtyEthzYh?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f99f0824-4a9a-4be1-1327-08dc4e88e22c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2024 18:08:19.8256
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DDSukouBalazORgrk5T9raLe1be1Qnup5vyo5n4iPsFQFHB7aIl8rSBaOWgVNQF6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6044

Prepare to allow a S1 domain to be attached to a PASID as well. Keep track
of the SSID the domain is using on each master in the
arm_smmu_master_domain.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Reviewed-by: Michael Shavit <mshavit@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 15 ++++---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 42 +++++++++++++++----
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  5 ++-
 3 files changed, 43 insertions(+), 19 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 63f98264b646bc..be54dfb89e880e 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -46,13 +46,12 @@ arm_smmu_update_s1_domain_cd_entry(struct arm_smmu_domain *smmu_domain)
 		struct arm_smmu_master *master = master_domain->master;
 		struct arm_smmu_cd *cdptr;
 
-		/* S1 domains only support RID attachment right now */
-		cdptr = arm_smmu_get_cd_ptr(master, IOMMU_NO_PASID);
+		cdptr = arm_smmu_get_cd_ptr(master, master_domain->ssid);
 		if (WARN_ON(!cdptr))
 			continue;
 
 		arm_smmu_make_s1_cd(&target_cd, master, smmu_domain);
-		arm_smmu_write_cd_entry(master, IOMMU_NO_PASID, cdptr,
+		arm_smmu_write_cd_entry(master, master_domain->ssid, cdptr,
 					&target_cd);
 	}
 	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
@@ -292,8 +291,8 @@ static void arm_smmu_mm_arch_invalidate_secondary_tlbs(struct mmu_notifier *mn,
 						    smmu_domain);
 	}
 
-	arm_smmu_atc_inv_domain(smmu_domain, mm_get_enqcmd_pasid(mm), start,
-				size);
+	arm_smmu_atc_inv_domain_sva(smmu_domain, mm_get_enqcmd_pasid(mm), start,
+				    size);
 }
 
 static void arm_smmu_mm_release(struct mmu_notifier *mn, struct mm_struct *mm)
@@ -330,7 +329,7 @@ static void arm_smmu_mm_release(struct mmu_notifier *mn, struct mm_struct *mm)
 	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
 
 	arm_smmu_tlb_inv_asid(smmu_domain->smmu, smmu_mn->cd->asid);
-	arm_smmu_atc_inv_domain(smmu_domain, mm_get_enqcmd_pasid(mm), 0, 0);
+	arm_smmu_atc_inv_domain_sva(smmu_domain, mm_get_enqcmd_pasid(mm), 0, 0);
 
 	smmu_mn->cleared = true;
 	mutex_unlock(&sva_lock);
@@ -409,8 +408,8 @@ static void arm_smmu_mmu_notifier_put(struct arm_smmu_mmu_notifier *smmu_mn)
 	 */
 	if (!smmu_mn->cleared) {
 		arm_smmu_tlb_inv_asid(smmu_domain->smmu, cd->asid);
-		arm_smmu_atc_inv_domain(smmu_domain, mm_get_enqcmd_pasid(mm), 0,
-					0);
+		arm_smmu_atc_inv_domain_sva(smmu_domain,
+					    mm_get_enqcmd_pasid(mm), 0, 0);
 	}
 
 	/* Frees smmu_mn */
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index fb18d9d500aeba..00be1e2ebefaa9 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2011,8 +2011,8 @@ static int arm_smmu_atc_inv_master(struct arm_smmu_master *master)
 	return arm_smmu_cmdq_batch_submit(master->smmu, &cmds);
 }
 
-int arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain, int ssid,
-			    unsigned long iova, size_t size)
+static int __arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain,
+				     ioasid_t ssid, unsigned long iova, size_t size)
 {
 	struct arm_smmu_master_domain *master_domain;
 	int i;
@@ -2040,8 +2040,6 @@ int arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain, int ssid,
 	if (!atomic_read(&smmu_domain->nr_ats_masters))
 		return 0;
 
-	arm_smmu_atc_inv_to_cmd(ssid, iova, size, &cmd);
-
 	cmds.num = 0;
 
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
@@ -2052,6 +2050,16 @@ int arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain, int ssid,
 		if (!master->ats_enabled)
 			continue;
 
+		/*
+		 * Non-zero ssid means SVA is co-opting the S1 domain to issue
+		 * invalidations for SVA PASIDs.
+		 */
+		if (ssid != IOMMU_NO_PASID)
+			arm_smmu_atc_inv_to_cmd(ssid, iova, size, &cmd);
+		else
+			arm_smmu_atc_inv_to_cmd(master_domain->ssid, iova, size,
+						&cmd);
+
 		for (i = 0; i < master->num_streams; i++) {
 			cmd.atc.sid = master->streams[i].id;
 			arm_smmu_cmdq_batch_add(smmu_domain->smmu, &cmds, &cmd);
@@ -2062,6 +2070,19 @@ int arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain, int ssid,
 	return arm_smmu_cmdq_batch_submit(smmu_domain->smmu, &cmds);
 }
 
+static int arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain,
+				   unsigned long iova, size_t size)
+{
+	return __arm_smmu_atc_inv_domain(smmu_domain, IOMMU_NO_PASID, iova,
+					 size);
+}
+
+int arm_smmu_atc_inv_domain_sva(struct arm_smmu_domain *smmu_domain,
+				ioasid_t ssid, unsigned long iova, size_t size)
+{
+	return __arm_smmu_atc_inv_domain(smmu_domain, ssid, iova, size);
+}
+
 /* IO_PGTABLE API */
 static void arm_smmu_tlb_inv_context(void *cookie)
 {
@@ -2083,7 +2104,7 @@ static void arm_smmu_tlb_inv_context(void *cookie)
 		cmd.tlbi.vmid	= smmu_domain->s2_cfg.vmid;
 		arm_smmu_cmdq_issue_cmd_with_sync(smmu, &cmd);
 	}
-	arm_smmu_atc_inv_domain(smmu_domain, IOMMU_NO_PASID, 0, 0);
+	arm_smmu_atc_inv_domain(smmu_domain, 0, 0);
 }
 
 static void __arm_smmu_tlb_inv_range(struct arm_smmu_cmdq_ent *cmd,
@@ -2181,7 +2202,7 @@ static void arm_smmu_tlb_inv_range_domain(unsigned long iova, size_t size,
 	 * Unfortunately, this can't be leaf-only since we may have
 	 * zapped an entire table.
 	 */
-	arm_smmu_atc_inv_domain(smmu_domain, IOMMU_NO_PASID, iova, size);
+	arm_smmu_atc_inv_domain(smmu_domain, iova, size);
 }
 
 void arm_smmu_tlb_inv_range_asid(unsigned long iova, size_t size, int asid,
@@ -2524,7 +2545,8 @@ static void arm_smmu_disable_pasid(struct arm_smmu_master *master)
 
 static struct arm_smmu_master_domain *
 arm_smmu_find_master_domain(struct arm_smmu_domain *smmu_domain,
-			    struct arm_smmu_master *master)
+			    struct arm_smmu_master *master,
+			    ioasid_t ssid)
 {
 	struct arm_smmu_master_domain *master_domain;
 
@@ -2532,7 +2554,8 @@ arm_smmu_find_master_domain(struct arm_smmu_domain *smmu_domain,
 
 	list_for_each_entry(master_domain, &smmu_domain->devices,
 			    devices_elm) {
-		if (master_domain->master == master)
+		if (master_domain->master == master &&
+		    master_domain->ssid == ssid)
 			return master_domain;
 	}
 	return NULL;
@@ -2565,7 +2588,8 @@ static void arm_smmu_remove_master_domain(struct arm_smmu_master *master,
 		return;
 
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
-	master_domain = arm_smmu_find_master_domain(smmu_domain, master);
+	master_domain = arm_smmu_find_master_domain(smmu_domain, master,
+						    IOMMU_NO_PASID);
 	if (master_domain) {
 		list_del(&master_domain->devices_elm);
 		kfree(master_domain);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index e4043e48a6e20d..5f49a5771ab027 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -739,6 +739,7 @@ struct arm_smmu_domain {
 struct arm_smmu_master_domain {
 	struct list_head devices_elm;
 	struct arm_smmu_master *master;
+	ioasid_t ssid;
 };
 
 static inline struct arm_smmu_domain *to_smmu_domain(struct iommu_domain *dom)
@@ -770,8 +771,8 @@ void arm_smmu_tlb_inv_range_asid(unsigned long iova, size_t size, int asid,
 				 size_t granule, bool leaf,
 				 struct arm_smmu_domain *smmu_domain);
 bool arm_smmu_free_asid(struct arm_smmu_ctx_desc *cd);
-int arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain, int ssid,
-			    unsigned long iova, size_t size);
+int arm_smmu_atc_inv_domain_sva(struct arm_smmu_domain *smmu_domain,
+				ioasid_t ssid, unsigned long iova, size_t size);
 
 #ifdef CONFIG_ARM_SMMU_V3_SVA
 bool arm_smmu_sva_supported(struct arm_smmu_device *smmu);
-- 
2.43.2

