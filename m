Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2052.outbound.protection.outlook.com [40.107.93.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 815A614F113;
	Wed, 27 Mar 2024 18:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711562931; cv=fail; b=t5Eg3CuO0jLRu92cqplbEg5q/L2PWkF9Slk4BkujEISDSJPgsP5ix72UqdChWLYziMYoQIfoJjxwl1V1Fs/EqUcy8NY7d2wLlDdoEFqUKcLE+BKycUulWa7pGWDtny0n8yumVFCgkWP1me9GvohZUqafcs/VEX3JCVFaeUJvIF8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711562931; c=relaxed/simple;
	bh=jHc54TgF3bN2CifgULUQaRIjm8MXPCTXK8GSp4+oCsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=m0UcDpcVGftS2AfW9luKaG7thFR1MBT+7Kro5pOF6ooha/2bIHWiVangV+Z5CUBcmkddumuzPodbx/nqeoZM1AXYSgc+9CQR0bKWKV8RWzJCqTkuy+oWXX3Ul0UE+JBm385KmTJACS+B1S+69f3KBIeeQ5lZAXNY9fUuX5+zyig=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=pFY3frQH; arc=fail smtp.client-ip=40.107.93.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="pFY3frQH"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gwxo9PAT+vK6N+T+6q2/VxIi7WlSIawjU4Twv451NBl4MzMV0oZ2+8i+wYTT0DqmB6kcRQahf4iR/UZfaWbgzRUls/Nmr+Wj+LIsT4dK+gXn5BPJiDlZLD8wJT++Tc+Y90eagBULxKMAvOr/GSXfYctrgIdj88ybJ8X2p2AL2U1d8hclW6c2yqqb2xpfBAdD6XyhDIDuErzv+QJoHGHMAZIw9yinLBXfGxIzcu5F+6i8+c3ZPjTP9HgMcuW/86ksfh03z+JPw5HRsxu+4Pvd7Qi5U+oj2tF4PG3h1fZFtSzd2qRifOy6m9k7b9HcoQ6v3Xj1xq3nla2+sFkkotb5WA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jQBvI8OVv5BuVAW5XzdwqugUxNAWCcD+pcM/BDWuAuE=;
 b=e0pFlcm18Sueq44MoSzQhe+t2C/IkWeaz2+D0HS+PLbOasP2Cza6y77/GEjPYVfQfLOe6mdcfAyoFgW3zE/ABELZavYT5C845WsaGg0xBuBDYf0OS1qyHkP3LwnRFYXdNg8ggtjnljs9HW66a8HtAwV8wLZo3Hou0EVZiW7qmRjqy8jLsggCl3qsZphATwEdAvFW6xc3ycWXngYPOOJPVSZizxrZsdaw9bs5x6hb8iu62dGPwBzz0X/CLV+PB2C3skGGnTTwlwXktfDGLr6nf91ET06bEBDOEGqcK9fUZHUbLUWfX0oW/luKbY+/AL98YkWFLU3PDVHjWOfeLCG3QA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jQBvI8OVv5BuVAW5XzdwqugUxNAWCcD+pcM/BDWuAuE=;
 b=pFY3frQH6mhJCsjCOS9uxWFwYPiS1zl5+zEQ9dDOenI/9Cov/hUYkpuDmz8ylBTuFBlwa7pWhG3bfMJ8thEgAv8aO2Ac3fES2tX/7QLYdNPxHciZoGDwKJE8k2F51DdD7po+Tp4qf/jLEB0lJamvEvXqtFoUk5a+s1y5csjrDwVY/EDZiwBuOcUzaWgx4rbH8gpOCXMlSujvJpVLikk4HvXmIgL7KNY0OlY9id9k6tarxmMkc5GR2PRd/JhBbATAKirqbXtGTi3l5xUtk27rudOp5l8f5zi+hJEZ/gPn+Ji2h6RAlCBMbN9Rc8bowpapcVtyaya0jEbnM13BDau4ww==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by CH0PR12MB8487.namprd12.prod.outlook.com (2603:10b6:610:18c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.32; Wed, 27 Mar
 2024 18:08:30 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 18:08:30 +0000
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
Subject: [PATCH v6 19/29] iommu/arm-smmu-v3: Thread SSID through the arm_smmu_attach_*() interface
Date: Wed, 27 Mar 2024 15:08:05 -0300
Message-ID: <19-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0315.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::20) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|CH0PR12MB8487:EE_
X-MS-Office365-Filtering-Correlation-Id: 1260a44a-4284-4878-2059-08dc4e88e1c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	izC8IRY2OiEu6cYW9sZKhVc3MlNX+/DqNgbpzm0DllyD84Sl3kB0XhIpRSrkvFDTMsOkDT6ieb6KOWLp2DteYKyHVYjgnhHgGBgqNlbOBIyHCmB9UTJm66MOctWdjEXiUhyD3IxYhonbnzDfU2LTUr/ogVXaknk8qDANM3h9R+JpnrHTSyOuay3ZUxBmRuFnc9NmplQpvCQFpU20yZR39vHO6XxHK/vZLK+lHK4iu2GWcxf21GSGOMVSZxdIQWljJDAdcv8Gzn1VT6Cq5KYVf2XOI3dob81vHBzPzCe4N6pSPBPJeHE4PQEsKqbuP6G8JwmNVzKsiPlTw6UTA7XQJybFG+6nlHUE/2nGhfoU7RIv5gdIdAdUDbe/OMlpDCXfEuZtGOeNtMZKM+3QiJEuF0clFdk/uZg3DJqRkLQlL7sWUJhoqLyGt9OhsCzOzq/9AD8c9fKGqi7WS7M70yBfwvfYDaRMOySdBjnjEfXAcHpzWMMiJmHXdMF8UW1h/457Dia8+bsjyq0QqC5Dy3sR6spnETLo/yyIEdmWrCfEVYkpi8JKh1WVPnY7KruT2sMq0FenLnoLQJvGbVe+Wu8NymCGBS3t+tdwHyegK9frhvBVP/wWRc+Bgj0Vx9PXLjMiCeWh/RC85g6Lb8EM3HYO1Q==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?UddpcAazUKuArODqZJmhGh3LLOejWtih9T6uX4+ny0ZothF11nhOufI0oV9p?=
 =?us-ascii?Q?A/LSn588Pl8Lz12eYVs0U2B5VcM0y632RZH4jzL5jl6zo7qJWG5moeqNxRp4?=
 =?us-ascii?Q?YHCcn1wTgohiqVw/vk815HFoIVySjXUXXHdnwkH21UfMOxOgNlAXcfrZcseZ?=
 =?us-ascii?Q?fB2pw0h3KcBTf429GWmg6DThs1H7KiZzUcGdy5jmn+Ok9rSSygDEpemDNNc/?=
 =?us-ascii?Q?Y1HJIhvqvDeKLp718B4vS2tciB/sVn4W0oeIg2Ut1h01uDITAdzTVtvUrfGK?=
 =?us-ascii?Q?MN/tP4yGDKjFP+PlI8tk4kBryApdJAPizoXOP8cSA6/7mwTQAKoyOcK4/it1?=
 =?us-ascii?Q?aSJpy8dV+KjUYS0BsQIxG37v6WdBoVm8PDShmRzUbNhWKeZiENf+1Zh1NUp1?=
 =?us-ascii?Q?cMIvfFcJAKBdTW7KD+f2KwP2iEd5ckWOR/cx1ixt0NmQRLBKxw3ulxUQGSRV?=
 =?us-ascii?Q?VO/TGHTC6Hlu+GePw7BCQDr75lDq5G/MjUPOfHg+S4uDnEHP25AErhm8IqY4?=
 =?us-ascii?Q?5Fq7IBbKzSDWlHI4/QG5AdnlS6o9fSprswkFZ7yWrR5QpSs8kxl7KdLxYIGM?=
 =?us-ascii?Q?Ji5UHmNo3VTv8NjzVwX5jBXlnQMvDljQ0o+CSTe+zGO0dbxtzK/mJaj50Ik+?=
 =?us-ascii?Q?G1cyXC6mJNoSSv3qcbOwkLcfVGUjTfXaGqNHNQ3lU/xNnDNh1ycqyjAg77BY?=
 =?us-ascii?Q?cZGcE0xoE//l8xoMZIuWdypdUTREgutCIFlnkpYy3FZzgvVXxSEwwe8gw+QW?=
 =?us-ascii?Q?R1KrdT4izDMca87WIEAZPIgUXikJbWjBMTgnGOiQCQvUwYfTZpfxfrQsN4lp?=
 =?us-ascii?Q?EZ2M7RpoOkvEP0U8j25GHaYya/EEqS6riC9TMRyXE8P41ToSW9jT3z0RMkLx?=
 =?us-ascii?Q?JahU+LX5H1MLYi4MCpSu2R1FYt1EceiPEC0zJrcfrpZIPASq8ZK4vO6gb+fM?=
 =?us-ascii?Q?H87GFchZbdgTRW3UVMJYTknffXscVaEWQRN3N6UCBbyc5JecDFUd/PsMF9bG?=
 =?us-ascii?Q?LEQ7vZpOZguN5u9I1BA4VSZEXxZl3J/sWxgQJRdmvJvApW5Zplk4WTTDSlxI?=
 =?us-ascii?Q?B2z7MVr12BS/zTem2B8mESReO2qPYu/l9znGun/0BqHQsF/7XrmIp5BHvEj4?=
 =?us-ascii?Q?/IG+VfsqTSad/NDbkWnDcwnV10VDzmLaGKf+BobGgmaUr+gzr8sKJU+2ap0Q?=
 =?us-ascii?Q?jjKDnIh3Rs+208yZFk6YRLHxKpl75fJQDMpN5C9CI2UYih4vHxzxdTHCPGsG?=
 =?us-ascii?Q?H0br8gBc5gjcWUbAlc7LcjSXs+aNCiPaBsaSyK8oZX5f/jcdUaaI/sJyyHnK?=
 =?us-ascii?Q?YVOzW2UOIUjYZ8lVYQV+xdV+JMsfJj5p21bcX8yO/9XFi/gm6b2yXkP6eXXl?=
 =?us-ascii?Q?ed9EIg11tginJlg4rebsSOupBzXsNcVElA1iJ72jht5mUhZOgW3mT15mSvAs?=
 =?us-ascii?Q?yyGhozg6F6fOImgP38ghRJi1YswlrvVDkoc2V7ICVDwSOT5DOi2/aOjW7fpT?=
 =?us-ascii?Q?DBROUTQO0tJe0n5Ycz60CWdse4OFKAyFYkYNLfNInnAN5o1/0auSnfKvVcvq?=
 =?us-ascii?Q?RNli6nbpfJjFnZVUsw7FO214tcoglFRbRFL5eC0i?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1260a44a-4284-4878-2059-08dc4e88e1c9
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2024 18:08:19.1502
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MvqAPyPr1XkhJNiKzBi23P6LFOx4BqhH8HTZAIX5Tg2a0l8Nbb6kBaKmMqcuzJHE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8487

Allow creating and managing arm_smmu_mater_domain's with a non-zero SSID
through the arm_smmu_attach_*() family of functions. This triggers ATC
invalidation for the correct SSID in PASID cases and tracks the
per-attachment SSID in the struct arm_smmu_master_domain.

Generalize arm_smmu_attach_remove() to be able to remove SSID's as well by
ensuring the ATC for the PASID is flushed properly.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 24 ++++++++++++++-------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index a77467f8837515..0376c1bda8d8fa 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2003,13 +2003,14 @@ arm_smmu_atc_inv_to_cmd(int ssid, unsigned long iova, size_t size,
 	cmd->atc.size	= log2_span;
 }
 
-static int arm_smmu_atc_inv_master(struct arm_smmu_master *master)
+static int arm_smmu_atc_inv_master(struct arm_smmu_master *master,
+				   ioasid_t ssid)
 {
 	int i;
 	struct arm_smmu_cmdq_ent cmd;
 	struct arm_smmu_cmdq_batch cmds;
 
-	arm_smmu_atc_inv_to_cmd(IOMMU_NO_PASID, 0, 0, &cmd);
+	arm_smmu_atc_inv_to_cmd(ssid, 0, 0, &cmd);
 
 	cmds.num = 0;
 	for (i = 0; i < master->num_streams; i++) {
@@ -2500,7 +2501,7 @@ static void arm_smmu_enable_ats(struct arm_smmu_master *master)
 	/*
 	 * ATC invalidation of PASID 0 causes the entire ATC to be flushed.
 	 */
-	arm_smmu_atc_inv_master(master);
+	arm_smmu_atc_inv_master(master, IOMMU_NO_PASID);
 	if (pci_enable_ats(pdev, stu))
 		dev_err(master->dev, "Failed to enable ATS (STU %zu)\n", stu);
 }
@@ -2587,7 +2588,8 @@ to_smmu_domain_devices(struct iommu_domain *domain)
 }
 
 static void arm_smmu_remove_master_domain(struct arm_smmu_master *master,
-					  struct iommu_domain *domain)
+					  struct iommu_domain *domain,
+					  ioasid_t ssid)
 {
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain_devices(domain);
 	struct arm_smmu_master_domain *master_domain;
@@ -2597,8 +2599,7 @@ static void arm_smmu_remove_master_domain(struct arm_smmu_master *master,
 		return;
 
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
-	master_domain = arm_smmu_find_master_domain(smmu_domain, master,
-						    IOMMU_NO_PASID);
+	master_domain = arm_smmu_find_master_domain(smmu_domain, master, ssid);
 	if (master_domain) {
 		list_del(&master_domain->devices_elm);
 		kfree(master_domain);
@@ -2612,6 +2613,7 @@ struct attach_state {
 	bool want_ats;
 	bool disable_ats;
 	struct iommu_domain *old_domain;
+	ioasid_t ssid;
 };
 
 /*
@@ -2643,6 +2645,7 @@ static int arm_smmu_attach_prepare(struct arm_smmu_master *master,
 		if (!master_domain)
 			return -ENOMEM;
 		master_domain->master = master;
+		master_domain->ssid = state->ssid;
 
 		/*
 		 * During prepare we want the current smmu_domain and new
@@ -2695,11 +2698,14 @@ static void arm_smmu_attach_commit(struct arm_smmu_master *master,
 		 * SMMU is translating for the new domain and both the old&new
 		 * domain will issue invalidations.
 		 */
-		arm_smmu_atc_inv_master(master);
+		if (state->want_ats)
+			arm_smmu_atc_inv_master(master, state->ssid);
+		else
+			arm_smmu_atc_inv_master(master, IOMMU_NO_PASID);
 	}
 	master->ats_enabled = state->want_ats;
 
-	arm_smmu_remove_master_domain(master, state->old_domain);
+	arm_smmu_remove_master_domain(master, state->old_domain, state->ssid);
 }
 
 static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
@@ -2711,6 +2717,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
 	struct attach_state state = {
 		.old_domain = iommu_get_domain_for_dev(dev),
+		.ssid = IOMMU_NO_PASID,
 	};
 	struct arm_smmu_master *master;
 	struct arm_smmu_cd *cdptr;
@@ -2807,6 +2814,7 @@ static int arm_smmu_attach_dev_ste(struct iommu_domain *domain,
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
 	struct attach_state state = {
 		.old_domain = iommu_get_domain_for_dev(dev),
+		.ssid = IOMMU_NO_PASID,
 	};
 
 	if (arm_smmu_ssids_in_use(&master->cd_table))
-- 
2.43.2

