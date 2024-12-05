Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2047.outbound.protection.outlook.com [40.107.101.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 882CC21CA18;
	Thu,  5 Dec 2024 15:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733413422; cv=fail; b=Qa571Y4bvorFCSxBqYdFMIia7EMsOeBrb9o15lpLlNX6UoGx4mc8uLk6i9fAol4s+dyvPBS7fBQ/5O3n2VVF50MgaRkSr9nNup+zkm0YSo2Lh0RumHjXw0Bo3NhUFC0Kj4azcfeXJ6RZ4al42C97yd9Mvia6DeaiURVMbn/MuLE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733413422; c=relaxed/simple;
	bh=PzAl75w7Wmr2zHG523sCWHHisH0N6FOoiSTq9sd9n6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PFPzumkP6YkbYNEx0bBraU/RxxWBrHao1zlxb1/wi4+bcODY+WjvRCMbV82WKGSIxWXyF3jREpL86IDiRQBKMC5CPs07NxB0KQqXErE/tfw+tUXGVOnVsYGxOhRx7gNK9O+I+witk7CO+nP5iUFjA76cc0wkAbJ4+4IcJOAGlV8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=nrfbfE/Y; arc=fail smtp.client-ip=40.107.101.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nrfbfE/Y"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AbvL/RB++alOaY/Sk9tN2EnrF5/gRy1gtGV64+zwo3HBsG1JW+JXVwDXUhQ2c2WXhETOURzWibHl8n4/trSrv2mPhmCl66YQW+tqto7OzbjIN6H3FgVn4SL2c1WUBHLYDhG+RKV0yAL2sFIcHVdEak0T3unImdB94G3AG9FEkfMSDM7D2ENddmlnDH8XpI+YlB3X1I4OeGWhhALeYel+/jl9MMPbl/8Tjv8rg+92JxTN1vj/hhM+0YjBhu0SFOihiDxUt4uPnJdagHeUGcEMWvWK0a8IZUkYArvdm47ndiO08DLQntxsbjQzeisiOHI3PgchLogsnBWJFzjxFd5pHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kNYVzTqD67s/KKUJPEF43ljbroFCLLbV60xYQ6rEgkE=;
 b=ZeE37uPlfvvBdPXKCxYp+8DPFqsuWoNaX5CMT/MPxWGxeZY8Z0izKpxzSxZmO2hsZvywiXqYGWmkY2Drrn73qrNR9IL7zod48EdWXhXBjlfkA42GJGJpFAWrwTUkCXrsH6lOXZ3zyvLeCceKpeoDFxt3M3+3ymQnMXEjzCTW0XWV2Qu++i/iaeA1rlJ3nZPqqzRU0qbDw9lp979UvYWcjcNPR8u3u+Qea7MVQPRgB7yHvI/oz8fGo5V1Evm1jGfqm42JpsCpYJ+E8kama3i4207gPT5WwYHXtUCjUNqgLeyQLb81HiUTGhn2UYLD3BQfIT1OjL8/+F1CVazk8Fu/Kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kNYVzTqD67s/KKUJPEF43ljbroFCLLbV60xYQ6rEgkE=;
 b=nrfbfE/YQIWXeRwmzdK2NdfQyuGRrVBsVxBsjxkGg6gDHx2sKaBGGGtEMyg3Jy16rliC8RbKbDpblaBim2wyS2PYSw0jLPsJt5TykBDgfFJ4Kys/9woGac1A3jdkypbqzRWjGK9TsMhW4Tafk1psE8mlPvEmLWUOvdZmivb/NCbZBVwek+rG33WTU/Ktl4F1TmIdrvQzt80HABzVJJgjvtnnryvBVnPxC+QXKPWD5m5CaKunJagxRb/slFFYgSyLV66tHteMqSNJKCoMhYYMxIWtd6QY539xM2tFAj6QzxsYuJkp7T+CokCUrblY1ao9d/BX4vDHSz7eYuf2W9gsCw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SN7PR12MB6789.namprd12.prod.outlook.com (2603:10b6:806:26b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.11; Thu, 5 Dec
 2024 15:43:32 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%5]) with mapi id 15.20.8230.010; Thu, 5 Dec 2024
 15:43:32 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: patches@lists.linux.dev
Subject: [PATCH 1/3] iommu/arm-smmu-v3: Remove arm_smmu_domain_finalise() during attach
Date: Thu,  5 Dec 2024 11:43:27 -0400
Message-ID: <1-v1-0bb8d5313a27+27b-smmuv3_paging_flags_jgg@nvidia.com>
In-Reply-To: <0-v1-0bb8d5313a27+27b-smmuv3_paging_flags_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0054.namprd03.prod.outlook.com
 (2603:10b6:208:32d::29) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SN7PR12MB6789:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e4b1bf7-5ac2-41f6-2b77-08dd154391cd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?YyyISp2Fzgfe1Ea+lF7xtcwPHeUUCS+oZo4h1NdEwelpKcvy5krJfvGVLtzc?=
 =?us-ascii?Q?JEZJb0dkGlXe7CF0978+6wU2NS2ZOZ0XVTmg21vyJl4sVGr2IEZtzmNlv7Vw?=
 =?us-ascii?Q?JyWmKY6tQOX3L9YL3cIKuqvyVPLS8j51lv2t01SyaC6qZmO9RYzKmSqGffj/?=
 =?us-ascii?Q?cg/qTfBscKLDO+SAzd1muk3lqUCg5JYzqVaKFu0DliCf2Zo4Dierf46c8e6E?=
 =?us-ascii?Q?hJHrr2a6lB+Kg6ORr/iE1pzST4NIiQI9glZhIq/Y1/HDfkNbcNo5Uxvjn5BS?=
 =?us-ascii?Q?B8E1S779onAWFTAqOtW3q7NIMLYbB0yU+LuqmMPKb0nhd27Ey1mY+VTiatZc?=
 =?us-ascii?Q?afPYyI90o0QMuL1Mes/bCh8q1MCw4HjvzCgMYJXLnGI9ajneK/FolLbWvzoG?=
 =?us-ascii?Q?Di0K7ey//KLCIFtEMxJfbH8QqBFb/3kdPR4gsEzDecOtaIDkEpyFVlULjm/E?=
 =?us-ascii?Q?LPLBp4ctIhbprN4wS7WyRpCR/RaPrcgLNNn8/5xLhDeSwxkigoEx+JfvavRP?=
 =?us-ascii?Q?RCW1BkCeY/IzyHTuKLTUAqOpBcm5mBBUx1lLjDlVVsIo4Up2HAPR86Oofa9i?=
 =?us-ascii?Q?VYumC28QqzjW1/nJJykecAX12vCsXpG6NkSPDWwfFOeLsbmObQG4piijwXrJ?=
 =?us-ascii?Q?aAKQ54T2b0CpQoGx63cwLnrcA0Kpnfagk8iwZ/J7zBp+Svo/K6WSFX9V4pCo?=
 =?us-ascii?Q?//Ck+oAO32VQJVci0M1l6xGNlYkpTbPbDLo6AjGSM6B9MnIPSV4v0I4DCi5M?=
 =?us-ascii?Q?SOXTe+/JgE03DL3CgBa4rsOstQpd79Nn0wXwcn2uM58RaeXe/fHU8nkL6EvG?=
 =?us-ascii?Q?WwEPnmQDPtydWzLg41CxoTDw2PEP2J2VY6K2F/NQtyINng8YqFIdD4iQ986R?=
 =?us-ascii?Q?0sjqVxZnM+hrPFll5glHQ8VdvrnmCPec2aIkCjBAN8fWE/8HvxnlGxSWGwiU?=
 =?us-ascii?Q?p1kWhdF99d4E7NE9qpgqn0CgA3PA8TTscKJ4yUbCBWoqJtIZN6paPBPdT81W?=
 =?us-ascii?Q?75+vG5rvGH9gbo9o9OQCjobLSRwkjx4GwF4g/IWf+HPZRsB+NHjfElalBB29?=
 =?us-ascii?Q?nj7sBtFPkR1bhcZk6h+e7Bg3vxT+Pp0Zl2M9KuZPfdKDQQmBiLQjLsk0XO0Q?=
 =?us-ascii?Q?ko6YBp1EVUJWHXTvcS2/2Y+G7ZG8ySmCA09ykqY3RJkIpXBrWzTVPua0gDrW?=
 =?us-ascii?Q?7Q84CfYDAndq92i7mZLRzM8OBhaCDj/gm/GL5uiyMhExKAgIhU45YNImc1Nx?=
 =?us-ascii?Q?ltnxIJxcROZ1cTIHIS5jeCXG2GiyahlFHpMkfwtv+vJCUaSyh1UXe82gVGfi?=
 =?us-ascii?Q?M/F3i/NKG74kSQJ8ZW2oWSSBh061svc2nLcj8PrBOydyjg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6XL6Q77q9TQyVQCW9Qc6VjwF9Tr7SMj9vPuv9WsAOc/brBMQbd5HX4J3ZYV5?=
 =?us-ascii?Q?vdhVKgwXTZub6nk0eaXps6IruDoXq/WF2L+OQbMuHXGcvVOHTCE0aydM+LIA?=
 =?us-ascii?Q?/pDV/SVIkaKFRnD5jNT0XXFqd2NwBWpvqQ/6j+muP5loJgbTn3AUCds5w/N9?=
 =?us-ascii?Q?X0UbuUwSDIQ319SG0pjwxyKgIuK/DhrMSDVA2BMCWk/5YqDHH9mYsCvx9yfp?=
 =?us-ascii?Q?af5RlQFqLT2MNMHOSmRCBK0FNrd8N7CtXoLMn28Hedy5Ps4Nb3KFm7686rOq?=
 =?us-ascii?Q?T/jQn/PCIIw61lFc0S+Y2iCLGqU9o6QkT6uPN0I9fNQZE5+yBDfmZMCY2UGk?=
 =?us-ascii?Q?FZhbINZt7MfPXSGWEcUhZHAhWwkW2iZCfbbN5v4rGAjGzyAMYcsxH7Pgivwb?=
 =?us-ascii?Q?35lLdh3rLzqbuOACAtY6cprvKv/h6n5Nb46IHqp02ks7wr1u3w+0ierBltbZ?=
 =?us-ascii?Q?clV8vuggyTFKBl4oFyT7gcRnrDrHFOPl9xuk1UmJgHKZrcVHpfRmp4QB0si+?=
 =?us-ascii?Q?vRvIXwpcyzGYDlDUJLZVKx1WSZBZhrcDKf88p566LAWeWAAUg+gMVS0aFKxE?=
 =?us-ascii?Q?2N3AWZhJUcGImMCzT4d13omfbeKAyGxb5qWtLW2+6craMdZCAloFRByEekQv?=
 =?us-ascii?Q?DbThTBedk4bS3ihOLnw70VhXMtFj4YwyFvmJsQ4ZkCeG6/vAeHXK0i913mR3?=
 =?us-ascii?Q?4/UKoXxOur7mSebARQg7pAgR+NDPEZ7TV5ZBc46YTtr6yX8CGA12RROFn2cb?=
 =?us-ascii?Q?0Cr5TevJL3MAlDX0fNbd38oY6zQaT9fR6h9t/k1lwWnO4DhzSLPI8uOUwDSi?=
 =?us-ascii?Q?das+eVJJw2wlhntOwQxL4ohye7p5LFAgCrpyQ4ihNtQfM0m3pd0pVVUUeXSp?=
 =?us-ascii?Q?6sKvP0vIbzaV7NZYg65wSh7hh1NgVl+eQt2KexAwUe23KXS1e36/pdlJZWHU?=
 =?us-ascii?Q?ytxOY2p7LRr93neCyHcz2LZ9KrRxiB1Fv98JSTSUJpMrqvpIbdegRT65zFcf?=
 =?us-ascii?Q?6IfTHyWVAHMZtsluiH7zyBsjNS8E174CPSSzQ/qOzgo6qwOUBqkB88C6GSAl?=
 =?us-ascii?Q?N3SrcvyFcS94DJwbLovNJTZYB8wgTKSIzj8gbYcDjehrVkAE6jlzDGVcm2+K?=
 =?us-ascii?Q?biA1+Az1hsVMZChZXPkKTd+LBnENcV4Xfu3SOQ8yCmsT0iUJ+cRXSBtJ5b+7?=
 =?us-ascii?Q?8RhknBHIhTBlSTtpmq6XoCH4jhdC1jV/Bb/BUDwDf6sMkhgxdpHyzKtKCKMO?=
 =?us-ascii?Q?1RJhlI1HspyYvR0BzM3WtM0730cStaweS4AsjgxdbLKR4ovPuDEPa4aJrgaR?=
 =?us-ascii?Q?3IpsYXXv3fFftQkVGxCzF22I+Oz2UWVB2UYA2Nhbr1pemK2yyGvGlzZ5gbel?=
 =?us-ascii?Q?QSw9WM+071yWGNlkwE6dv0YYR+qeLc9M6fNyrx/sWGSBdKljtjV9TXD3zhF1?=
 =?us-ascii?Q?fAaYCe1GScFif95y4hKR83zcEBre29zmOmroVb0BgA2n9PcSh3FQbYZeNyDq?=
 =?us-ascii?Q?Yqk4BpL5AhTgZ1vDNFd8eOQglC2lGCDzIfEkouPgIPUSlWgR8mN02AoZuzod?=
 =?us-ascii?Q?u2I1/fpmIlJ2xPr+XqnKa/SWHlNbUOIY98Ib+mEk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e4b1bf7-5ac2-41f6-2b77-08dd154391cd
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2024 15:43:31.1284
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XKG9iM5vzndA7GQpt2NO7IJe8ra8kmKdVchkhU4Vtg0wT8lmqZJVTosA4zosTGMl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6789

Domains are now always finalized during allocation because the core code
no longer permits a NULL dev argument to domain_alloc_paging/_flags().

Remove the late finalize during attach that supported domains that were
not fully initialized.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 37 +++++----------------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  1 -
 2 files changed, 9 insertions(+), 29 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 7605b264fbf983..e62c8d0f47a903 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2353,7 +2353,6 @@ struct arm_smmu_domain *arm_smmu_domain_alloc(void)
 	if (!smmu_domain)
 		return ERR_PTR(-ENOMEM);
 
-	mutex_init(&smmu_domain->init_mutex);
 	INIT_LIST_HEAD(&smmu_domain->devices);
 	spin_lock_init(&smmu_domain->devices_lock);
 
@@ -2362,7 +2361,9 @@ struct arm_smmu_domain *arm_smmu_domain_alloc(void)
 
 static struct iommu_domain *arm_smmu_domain_alloc_paging(struct device *dev)
 {
+	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
 	struct arm_smmu_domain *smmu_domain;
+	int ret;
 
 	/*
 	 * Allocate the domain and initialise some of its data structures.
@@ -2373,15 +2374,10 @@ static struct iommu_domain *arm_smmu_domain_alloc_paging(struct device *dev)
 	if (IS_ERR(smmu_domain))
 		return ERR_CAST(smmu_domain);
 
-	if (dev) {
-		struct arm_smmu_master *master = dev_iommu_priv_get(dev);
-		int ret;
-
-		ret = arm_smmu_domain_finalise(smmu_domain, master->smmu, 0);
-		if (ret) {
-			kfree(smmu_domain);
-			return ERR_PTR(ret);
-		}
+	ret = arm_smmu_domain_finalise(smmu_domain, master->smmu, 0);
+	if (ret) {
+		kfree(smmu_domain);
+		return ERR_PTR(ret);
 	}
 	return &smmu_domain->domain;
 }
@@ -2858,15 +2854,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	state.master = master = dev_iommu_priv_get(dev);
 	smmu = master->smmu;
 
-	mutex_lock(&smmu_domain->init_mutex);
-
-	if (!smmu_domain->smmu) {
-		ret = arm_smmu_domain_finalise(smmu_domain, smmu, 0);
-	} else if (smmu_domain->smmu != smmu)
-		ret = -EINVAL;
-
-	mutex_unlock(&smmu_domain->init_mutex);
-	if (ret)
+	if (smmu_domain->smmu != smmu)
 		return ret;
 
 	if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
@@ -2923,16 +2911,9 @@ static int arm_smmu_s1_set_dev_pasid(struct iommu_domain *domain,
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
 	struct arm_smmu_device *smmu = master->smmu;
 	struct arm_smmu_cd target_cd;
-	int ret = 0;
 
-	mutex_lock(&smmu_domain->init_mutex);
-	if (!smmu_domain->smmu)
-		ret = arm_smmu_domain_finalise(smmu_domain, smmu, 0);
-	else if (smmu_domain->smmu != smmu)
-		ret = -EINVAL;
-	mutex_unlock(&smmu_domain->init_mutex);
-	if (ret)
-		return ret;
+	if (smmu_domain->smmu != smmu)
+		return -EINVAL;
 
 	if (smmu_domain->stage != ARM_SMMU_DOMAIN_S1)
 		return -EINVAL;
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 0107d3f333a1cc..e121b30e612f64 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -813,7 +813,6 @@ enum arm_smmu_domain_stage {
 
 struct arm_smmu_domain {
 	struct arm_smmu_device		*smmu;
-	struct mutex			init_mutex; /* Protects smmu pointer */
 
 	struct io_pgtable_ops		*pgtbl_ops;
 	atomic_t			nr_ats_masters;
-- 
2.43.0

