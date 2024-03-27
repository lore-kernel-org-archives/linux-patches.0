Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2052.outbound.protection.outlook.com [40.107.93.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDEF3131BCF;
	Wed, 27 Mar 2024 18:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711562912; cv=fail; b=jKZnQ98HkBz/rWoxFGduhLaMaxj7ZBx3JnDfOJPl0Kp9HgVqcyk8d9IIZpakmNeHffCwSvZnQhfLNJ6ikXgTJLdw6HlfEzAL/vd9YP4Lik9xdccacyhuvXO/V0De3zkOfbvqgURm1GRDSk+arAcxFpI0G7EkLW6I+WIfD1cLb5c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711562912; c=relaxed/simple;
	bh=KpimeC13be+JGKMODSAeiGh3slYMfgymr0NcqGxysq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=SStxJOYbwlc4yNyYqmq0A8p9iRWuhbvDno3ecbfC1dHLovXrqbq3B3UBQa7arjYw9YCmv00n11REcEHFxswR/77AVhjHLVmbu2YZSXs9N6FHOOMhCYftohAL2wTVHgNcpaLNWUmqT1Xnk5YjFN+bDDOArJhzHPzWeGFn21Xax3A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=KpfP7sPC; arc=fail smtp.client-ip=40.107.93.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="KpfP7sPC"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hSgshfu3cyu4lNKFO/KrTLeajXumiQKvVuyC+gcvGc1CuvxNfq6c0ID/pS9W38sg7jz9jZiu1epwLynkg5hvh2mkz2VtmaUJ3Idn5rDY7IMgOpQllmct/5XCrhz9ivCXjO8EzjQ3BQs/EFbyxG6Lo3EYjGyRSv7Qb3krb2yygQyFEgf9QEXkPNMphVauzqQ3I2F8DoK9TSgcKDMABc3zBqf0lA9ik6ix1jc5quTU/fQOHmbaTssKjmUyeKRnhhQDqDezn/spdKSsUNGbMdflb2sAQedJ0JWXa3lCIlNk7Yw1MNmumkhSmlAAHNqso044KLFON+occhMsMgY5Dy81yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3Py1jAEACkdkxTX90xty5HkM5BMc74Fbtk/JZIyPMq0=;
 b=ZP+ukkamRW5MOSCzsOR8URrqeGJmi+c5nBiChvrjeaI8LcARPake/4LRIaiQcIMVLpkTMeOshcKgZtbJMTJyhBWDndTaNKmSbKi4KPGJUscqA9iFUQs2XgvjEUNDENj3rL8wpb0r2FtFL0wMf0+HZF++cGtgL9PQUJFA0VI83e+8qTVMxatLosel2LqnEl8jtdRvp02hN2IQtPyUpfDvx+aQrmUcP+r1yUXgYUe6i/6TO44RN+wIkxn7ozLsio95dsXdVfhWmLvhsq4HNGBvKczH8r+5Q+8G0WuWakXMHfCaXPbM7flKalq7HLC0/MWuoWYt7zkLqA7hEzsJ9m22UQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Py1jAEACkdkxTX90xty5HkM5BMc74Fbtk/JZIyPMq0=;
 b=KpfP7sPCY7Du8bBIESh8xc9uL2Kcoh+BNmX4L+eq5u5unjElssc2d24SiIaLlnriW049bURnEAIXCUEd7IfisoF9AkhMsMaPFzSYoMdAowqjGCu66AP1NqsFbxqrEFW9heqqoz1dILximtN1Av6LKb0JQk8bi967levDvzGiGi/2Wm2qsOgBmYeRWngtjwXQZrzrEXnGCz14CmwIVdJBDIQmt6VlvL23ovUpLw1R/eFKzO56VUP6y9zLeegCxM0FZRvnKaYeN2JvmO6qshqsqLuNErvMEJCwemdcQ1xxamuHwoUA7g2GrsMoKuZ3QC/sx2lacM8ttByfMZk+klUalw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by CH0PR12MB8487.namprd12.prod.outlook.com (2603:10b6:610:18c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.32; Wed, 27 Mar
 2024 18:08:20 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 18:08:20 +0000
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
Subject: [PATCH v6 15/29] iommu/arm-smmu-v3: Make smmu_domain->devices into an allocated list
Date: Wed, 27 Mar 2024 15:08:01 -0300
Message-ID: <15-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR20CA0012.namprd20.prod.outlook.com
 (2603:10b6:208:e8::25) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|CH0PR12MB8487:EE_
X-MS-Office365-Filtering-Correlation-Id: f43e7238-d7a6-4299-f8db-08dc4e88e114
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ol52iCtuJ2na/I44b4/DAmeYU5mWvEftrNom8elUliT+M1UqoHW1XbpB7x7NgoSuQ34d2npKHC6cwRpjotTlVk/Baq2JoQe7LqCUHmgpU+qPdn2zUuQUprzx14V7cX5qAk/h5uL3XAzbt8W6XqKtldxmd86vryRdSfPe4anXsFhqVztB1H3vGzu6bLlfKbPx+e73QvrSoB/fQJdO3rN3DH96DdGKOuIZcryvMIFbJPhbGZj8asep5sT9oawuV0E6uxp8iMDN3V0WPLZUmLsyaxDgqAvxvAoQ/ZrSV2KsiIwkRuEl9BmK3eBHf5+RFATkft9QXpGg+ULIeP6OAPP1wHW5Swt3DGH8sxq4abGPZCttDATBtMddBlqCG8hymV7eQzJxK14sAV01F0n/Ds6IsF7HQD18OQnQAOed69BDoXgVXhZWCeQGTPNB+y8PaegjWopK+sivtF40T9VuVZ32C49cfmoL7r9SntlZyXyUhpUmLrsE0NPI7ODKnpkNwJ01ntqxPywiVwSrDcB9zbbslO5AdwcLgxpDFI4rAotJJ+cuGhB/JNyJzR8BXP/nOUpAsb41zQEKiHh1x2HqAfj/eN6VvWvVdO/cSNLyisjtih7KmCcP8amHbXWKeFTJA5MzRs2QhdFe13MoTJ442TZ4ydadp4azT9Zl3F0aqmN/vN8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?szpPRRZcVAPmqJhiPUH7RQY2pXqidOSv/u8OKnzMdd35Nrz7Q5x1vetvIWTR?=
 =?us-ascii?Q?ls6PLUB5hcbe1JHhcDcgi6KzKrOyE6IE4Q2g6kZvvX5XfrBSi4OyndYxvItA?=
 =?us-ascii?Q?q26nIGN1dgUw2UBktse2bhnzCkN9EQPV6VI/GGYyeWbVE8lfkCyrS5PKsdrh?=
 =?us-ascii?Q?R1+qe6TN5nj0CsH7xqt5tzdl/nWzcziuIZvNFwcACK0tNq1EZphqZLrALH/G?=
 =?us-ascii?Q?MUOhXERNfaCLgDi9/JrGitHulTbI2evM4rNvbRyqGoSwjT9hLXGqIAxCT9kT?=
 =?us-ascii?Q?U6f7bvVPvP5vGJmhoCVtRAPRD1JAIXr+W9wsv5Akr4Q6h+25GUkZLR8855ea?=
 =?us-ascii?Q?vEi1VgiY6lOMQiBtBJx2XtSoBRal+ca9nLmCA2geC9RnsN4sWhc17nD0v5E4?=
 =?us-ascii?Q?0sBdIe8mYA1rjGfZO/PZgybkMfaNoIqvMGzC27AkSaUcuVOZnhSzRO7+W8bO?=
 =?us-ascii?Q?2tqNCcOqn1m6S+VmLtRvRbkTSjJ8bGmnzcY9eG9+FnItCkOfUETbp2oqCLX3?=
 =?us-ascii?Q?NfmA6hchdTSfD92M1Zmiv3I+1y+QZcIo/Lk5isj7nIopVLWm3jUXQ9JpubKb?=
 =?us-ascii?Q?jY1mYhTI3rqQ2BWXBh67dg14E+uyOo3fIvIjf0VR3ZWJVTMhrP057BoHi+0b?=
 =?us-ascii?Q?d3SmNtow+rFj69nTaC6zAfWXqjZidl4AZ9cpAitE3mIP5RI2NDwwNLTQGufH?=
 =?us-ascii?Q?MeJEoCSjwf7wAKprXJGReo50c9UaHy1K9TZNhpkyv165yNjbeUbEHishZUJL?=
 =?us-ascii?Q?c9ivBvQrarrUNV6sWnQKRbdM1JzINj3VeNo8AaiFujn2OqNgXeHyeNLmxq95?=
 =?us-ascii?Q?IQUrsl0P1QLcUdbFLdV2o+6T5XkoGHsrVo8ppyLwD3+MpSLPx1+0cpH35v3G?=
 =?us-ascii?Q?I1yeiHmagq41zp96kreo8O77OF5aU8yAvqzqkpizGMT4EFMkMU+gYECUIMgw?=
 =?us-ascii?Q?q/n5+q5s5qtMHzMNuw2aXXIhVZG6dmZYiew5HnPxJKQg3tluSCH0y+mbEQV7?=
 =?us-ascii?Q?N7T+M5Oz4NEm1T2/YVIOY2CtR0SwoGKwaF5j/3yhek2trFqQzOAa4V/gko4z?=
 =?us-ascii?Q?ruHi6vK3oFAHBkdRCPmsQ02p01inlIJADEUp1jkJ9MLl5IplcWgIUsnccdmD?=
 =?us-ascii?Q?5Q039bJsux6gn8dd8O/M5FW6GdAMrbOg2DZFf12PxTrbogXAikRf9OSnYKqB?=
 =?us-ascii?Q?bTy5XbKWpIUUHdmQZi4llc7Oua8jIhNgt8HMQGaqspZvf/KFauoJZmeUsWHl?=
 =?us-ascii?Q?u4SJAmn88Hz1kFjOAy1xq3gE1ektm9WUmp9JKWAQyQbxUhfZ45usQzHaQwlq?=
 =?us-ascii?Q?cFwfqfWjxsDUeJArVBUyQpYgO9zAEuzTaNhKTetdpM36x9za7ZGkUevbuZ06?=
 =?us-ascii?Q?MdlpbDbMtxq07MUFYpYzUlVi6i+lXxm0ItissZNQLyEsWkHs/p49iYbp6kX7?=
 =?us-ascii?Q?L818R+lVh+gNL4Wuj/KzMzw272L7b3CTdNnRPY+HPb8rWuWVjJMXr3Ee/GYa?=
 =?us-ascii?Q?m/qT3s3U/vUwOUET+nco1/xXpcYROyvvMGzb8zfrZz1Pme5hzuMZmFAiKIKR?=
 =?us-ascii?Q?skCQFDhULnVa9PN2Y1HeBQvvnI31ep8i/aFCZkay?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f43e7238-d7a6-4299-f8db-08dc4e88e114
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2024 18:08:18.0235
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: raNFUZaalx2z1YoD6sU79TRzmVelm1Xh6K8PzDdcBHFN5cR/rjI4el+UG+FYvm6b
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8487

The next patch will need to store the same master twice (with different
SSIDs), so allocate memory for each list element.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Reviewed-by: Michael Shavit <mshavit@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 11 ++++--
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 39 ++++++++++++++++---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  7 +++-
 3 files changed, 47 insertions(+), 10 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 095d11df2a1966..63f98264b646bc 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -37,12 +37,13 @@ static DEFINE_MUTEX(sva_lock);
 static void
 arm_smmu_update_s1_domain_cd_entry(struct arm_smmu_domain *smmu_domain)
 {
-	struct arm_smmu_master *master;
+	struct arm_smmu_master_domain *master_domain;
 	struct arm_smmu_cd target_cd;
 	unsigned long flags;
 
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
-	list_for_each_entry(master, &smmu_domain->devices, domain_head) {
+	list_for_each_entry(master_domain, &smmu_domain->devices, devices_elm) {
+		struct arm_smmu_master *master = master_domain->master;
 		struct arm_smmu_cd *cdptr;
 
 		/* S1 domains only support RID attachment right now */
@@ -299,7 +300,7 @@ static void arm_smmu_mm_release(struct mmu_notifier *mn, struct mm_struct *mm)
 {
 	struct arm_smmu_mmu_notifier *smmu_mn = mn_to_smmu(mn);
 	struct arm_smmu_domain *smmu_domain = smmu_mn->domain;
-	struct arm_smmu_master *master;
+	struct arm_smmu_master_domain *master_domain;
 	unsigned long flags;
 
 	mutex_lock(&sva_lock);
@@ -313,7 +314,9 @@ static void arm_smmu_mm_release(struct mmu_notifier *mn, struct mm_struct *mm)
 	 * but disable translation.
 	 */
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
-	list_for_each_entry(master, &smmu_domain->devices, domain_head) {
+	list_for_each_entry(master_domain, &smmu_domain->devices,
+			    devices_elm) {
+		struct arm_smmu_master *master = master_domain->master;
 		struct arm_smmu_cd target;
 		struct arm_smmu_cd *cdptr;
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 3922478799e130..4411706019f036 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2012,10 +2012,10 @@ static int arm_smmu_atc_inv_master(struct arm_smmu_master *master)
 int arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain, int ssid,
 			    unsigned long iova, size_t size)
 {
+	struct arm_smmu_master_domain *master_domain;
 	int i;
 	unsigned long flags;
 	struct arm_smmu_cmdq_ent cmd;
-	struct arm_smmu_master *master;
 	struct arm_smmu_cmdq_batch cmds;
 
 	if (!(smmu_domain->smmu->features & ARM_SMMU_FEAT_ATS))
@@ -2043,7 +2043,10 @@ int arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain, int ssid,
 	cmds.num = 0;
 
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
-	list_for_each_entry(master, &smmu_domain->devices, domain_head) {
+	list_for_each_entry(master_domain, &smmu_domain->devices,
+			    devices_elm) {
+		struct arm_smmu_master *master = master_domain->master;
+
 		if (!master->ats_enabled)
 			continue;
 
@@ -2539,9 +2542,26 @@ static void arm_smmu_disable_pasid(struct arm_smmu_master *master)
 	pci_disable_pasid(pdev);
 }
 
+static struct arm_smmu_master_domain *
+arm_smmu_find_master_domain(struct arm_smmu_domain *smmu_domain,
+			    struct arm_smmu_master *master)
+{
+	struct arm_smmu_master_domain *master_domain;
+
+	lockdep_assert_held(&smmu_domain->devices_lock);
+
+	list_for_each_entry(master_domain, &smmu_domain->devices,
+			    devices_elm) {
+		if (master_domain->master == master)
+			return master_domain;
+	}
+	return NULL;
+}
+
 static void arm_smmu_detach_dev(struct arm_smmu_master *master)
 {
 	struct iommu_domain *domain = iommu_get_domain_for_dev(master->dev);
+	struct arm_smmu_master_domain *master_domain;
 	struct arm_smmu_domain *smmu_domain;
 	unsigned long flags;
 
@@ -2552,7 +2572,11 @@ static void arm_smmu_detach_dev(struct arm_smmu_master *master)
 	arm_smmu_disable_ats(master, smmu_domain);
 
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
-	list_del_init(&master->domain_head);
+	master_domain = arm_smmu_find_master_domain(smmu_domain, master);
+	if (master_domain) {
+		list_del(&master_domain->devices_elm);
+		kfree(master_domain);
+	}
 	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
 
 	master->ats_enabled = false;
@@ -2566,6 +2590,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	struct iommu_fwspec *fwspec = dev_iommu_fwspec_get(dev);
 	struct arm_smmu_device *smmu;
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
+	struct arm_smmu_master_domain *master_domain;
 	struct arm_smmu_master *master;
 	struct arm_smmu_cd *cdptr;
 
@@ -2602,6 +2627,11 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 			return -ENOMEM;
 	}
 
+	master_domain = kzalloc(sizeof(*master_domain), GFP_KERNEL);
+	if (!master_domain)
+		return -ENOMEM;
+	master_domain->master = master;
+
 	/*
 	 * Prevent arm_smmu_share_asid() from trying to change the ASID
 	 * of either the old or new domain while we are working on it.
@@ -2615,7 +2645,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	master->ats_enabled = arm_smmu_ats_supported(master);
 
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
-	list_add(&master->domain_head, &smmu_domain->devices);
+	list_add(&master_domain->devices_elm, &smmu_domain->devices);
 	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
 
 	switch (smmu_domain->stage) {
@@ -2929,7 +2959,6 @@ static struct iommu_device *arm_smmu_probe_device(struct device *dev)
 	master->dev = dev;
 	master->smmu = smmu;
 	INIT_LIST_HEAD(&master->bonds);
-	INIT_LIST_HEAD(&master->domain_head);
 	dev_iommu_priv_set(dev, master);
 
 	ret = arm_smmu_insert_master(smmu, master);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index a3b94b839ee927..e4043e48a6e20d 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -696,7 +696,6 @@ struct arm_smmu_stream {
 struct arm_smmu_master {
 	struct arm_smmu_device		*smmu;
 	struct device			*dev;
-	struct list_head		domain_head;
 	struct arm_smmu_stream		*streams;
 	/* Locked by the iommu core using the group mutex */
 	struct arm_smmu_ctx_desc_cfg	cd_table;
@@ -730,12 +729,18 @@ struct arm_smmu_domain {
 
 	struct iommu_domain		domain;
 
+	/* List of struct arm_smmu_master_domain */
 	struct list_head		devices;
 	spinlock_t			devices_lock;
 
 	struct list_head		mmu_notifiers;
 };
 
+struct arm_smmu_master_domain {
+	struct list_head devices_elm;
+	struct arm_smmu_master *master;
+};
+
 static inline struct arm_smmu_domain *to_smmu_domain(struct iommu_domain *dom)
 {
 	return container_of(dom, struct arm_smmu_domain, domain);
-- 
2.43.2

