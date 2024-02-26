Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2081.outbound.protection.outlook.com [40.107.96.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B57712FB04;
	Mon, 26 Feb 2024 17:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708967266; cv=fail; b=jqUjni9s3Y7KvWY3xrcoJi9hFye5a/1k6auaxnZz4XL4dz6Mu546JEH/DTdbJrCWJSUSs9h93TrwojmvgAXdh7/CrSBjW6dFucNfEqv37jj1Rlp/kxGQJ0tY/BPonyvR3ZOVBJN+4ggVrr+pnNn1C2SI5qCDtvoweLnd6QjagKw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708967266; c=relaxed/simple;
	bh=XkwxN+bjbxfv09Tcpcb059h6dhXqhO6repaONVh/2Ck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=f1OaUebX2AEGJwDVPFNZwNOuz3IokjS+q6bnhFCHLzKpememw4OslRW4Eb9pCeReTEVqWcu9c7fvjonIsbfKYg/MqltA5o5+Mf3vHRbnZGI5zBKjkbQqn3Rc1HvP9r7d4iub73zD1vLxbp54azQDaMi/+8e5fYWtAg8CDcJwYM8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=dABJ8X9t; arc=fail smtp.client-ip=40.107.96.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="dABJ8X9t"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jfvEWh19vBVL3jloXjXPsRd9IA4+hyLuLJEyKNQGKbRGeHA0DU9mdYmhZOJIbs9eUOYKP0hjrRNscZAhsPXXEoKDYveVFTD4SDigse1Hz87AMkldWHgpLGgaa+sEhfYBVfT7bLVOkoNbgOADHF1cWIu4boUreQ1BAEspKAJqjjteB7m3zCCwgavo9xLwmVE93G4lo/fNqzi08u3YKsSXiRiwlufZgq0nKl8sD2F0o3PEi0Y6mX+GsH8NdDYcRhgXUvMXg9KwmhSSkUqkPWEyw6wB1CinvNZq6SrEC6fek2Jf+0pbkdYIAlMpA4wCGxnITm/8+Q0jFM2oDqoZcjbD0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/GzaHdu8XubOBxsSutXbFquuYh3EtV6Ivkf67pBgTM0=;
 b=b1RxZJ4fcvDgAfhkBFlZ3Hj7XkrNO399XW/+Njqk4d4Q4Qt8upmQ490nPEvu6hDk85PsXzOvYcLqgZFQN7SJoRQ5aRPYUsXEDECHYQ3BzQADACgPaME1NW8fEI+gtA7vJMSMmPwndNm6XQA4Lfub/Q2xPkGNd8sy1gbmZU5kIiOIl7SLBTpLE/hcF9/xSZ0dFxi8vU/ccgsP9zELL1Hsfbs23QVFw6vy/J2HanxcfKTHsf1jtmVw4n8Ozs1HtaoRhqmCX955ibnbR0EJpaHoB+oSwsFnmA7UDmFfSQOLC8JeSl5AklMLAobcbw59dIMeGYocK6Mzjv2ZpMGm64L2zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/GzaHdu8XubOBxsSutXbFquuYh3EtV6Ivkf67pBgTM0=;
 b=dABJ8X9tODDQGnB3cXE7XftfkY/qyc9+LPCcZSd5Qs9NBlN6+I8p0UfgGsf1hGWWb9ADKHvC6KodeBxOEz7ktRQsuJc9/9oS/fwdzvOJSjXRb0AUI2TEEGv6yMBLY5ozgH14fyOT262g1HG+J6FA/vbjinh3gdhPMaEMUmIKCj63nbRMZ883R7jBzPixcYg1LoOcM0fafP8OGA0Oz1AAmqQ5XojOE6ElnRRHQNj44FOV4NCbOQqa+6//NKyn8LJAnn3djLFdZkiaqDeeMoEwldZY80p5bw+do1JK1U3AYoJjO6wD3RY/uibn3hqvZiFXeMOUCjvLJ21WhykTpS5K6w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by PH7PR12MB6905.namprd12.prod.outlook.com (2603:10b6:510:1b7::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.33; Mon, 26 Feb
 2024 17:07:33 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::2e3e:c7c0:84da:3941]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::2e3e:c7c0:84da:3941%6]) with mapi id 15.20.7316.034; Mon, 26 Feb 2024
 17:07:33 +0000
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
Subject: [PATCH v6 10/16] iommu/arm-smmu-v3: Remove arm_smmu_master->domain
Date: Mon, 26 Feb 2024 13:07:21 -0400
Message-ID: <10-v6-96275f25c39d+2d4-smmuv3_newapi_p1_jgg@nvidia.com>
In-Reply-To: <0-v6-96275f25c39d+2d4-smmuv3_newapi_p1_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR16CA0046.namprd16.prod.outlook.com
 (2603:10b6:208:234::15) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|PH7PR12MB6905:EE_
X-MS-Office365-Filtering-Correlation-Id: c3b9e8f6-3439-4da8-2d33-08dc36ed6a65
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	n4k/O9Nd56UY/e5rAFsQD8EZZLZAA7ElINDD+Pbg8TLVhtWeMcA238h7BwnbHgdWQKhgadryzQff0Y2941F9mYBYB4v+x6ycQl63DLlv+k2qloaTBAMDvAOrtOzBVJUYSc9jjqpmTd1tANRHUlY0pNReJo9s6Hx77vTVoj3n7VMN9XA2x8bLgwWqo/rA8h1u9lbU9EDrB+oNrOsK3V4veDARQbhwFRx2fw19KrWKx/O/qyYZJezGGq6a/Qqh8wCk0Kv2OpoU93JNFl4WaqnIAVR+e0R7zZhXPa5BMqB3pTMc1iDMFfQ/kDH5T5UPJrlhZvwp6RzqKFbiSM5hNR/QAVm/pBRmrWtL3WIMN6r/PP3KRuHXSqZkkjtvzV1AWbxmQYfwKvDKQcvB2WTAFfkFy6qt8DZ0tOxRWHWVj/pDVx6qdsoOxQS7x22jk6yb8pyZOSajFbHl+b0NthF6tJkSWfePgMqgrrdtzDGrg2djJ8fgcxcLGqlvi0Hva2EgdqMhnapShi93OYZ5Ebk5/WFFqrMlXQDm4ueAb04KZgOplaRKsjlSBmIut2mM1TLkbaHgcB2/jCPTInN5RxdmSBjWIrmUCBET+AXhwhk3OsKT2aXv7J4eUZehzG51Fi5l9z1ZBWOgxluo6WXGs6OKK7ojAQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hGPqqvkZlkw9Y2IsPSQ3IKmv61ae5kSjCQ57IcPjxyiK6i5NWsaWViJmuJbn?=
 =?us-ascii?Q?7NlL3oz+YxiDppV1uOU56q7fxi0yYHxFwZo99doEI54wI1JjZ8b1M1tecY1N?=
 =?us-ascii?Q?RXMVh1+/2Y/iffc+YCsDN1lye5QyygI4jSQ+6NqLK/4rpKef55B+AbkylxWC?=
 =?us-ascii?Q?BbJLqDi01qtCag/VC2K7tj7LcHIJgavpuNFovImhD5VPYj7HZZV0IKqQyOXu?=
 =?us-ascii?Q?Duus7ylXpPDlle0H9TxPFMuAyX6IgvDn9f6KuFcpn4wymyZdDw7NsU51W51c?=
 =?us-ascii?Q?LOfaaySfRKvoMNbijUOsid/UOVoBCktPmVic6w6IcfBF7a17X2uGe5JVsmYp?=
 =?us-ascii?Q?M1K9IV+Ge71nkaMe/hWmAtmMsREJkYeKaEohrPGmoJASrV7Kru8vC0halfUF?=
 =?us-ascii?Q?5H9Ehxcj3f4xCmHenCVn+a2chjeovcCgaa1HI7ie85G1HZomPAXCKAg5+p5k?=
 =?us-ascii?Q?+BIjUIOEowi8shTLsUNFxFl66uP3zn95CeZE1yGMS5f+S6NpZggacHHgtNYr?=
 =?us-ascii?Q?B8IqSk2cJm7HTvtARzL1Lz57dUmb4WlD0NUsAVRnEAPgsgfUEijRC93sOeMv?=
 =?us-ascii?Q?qyf3RpEh82LERzPi0sfHepOY/kDBLcZwCA4Cxe5sEYf2IZHs7m+d/RSzo9tx?=
 =?us-ascii?Q?GjZpqQA/u0WN6E8VBrRwv+rrk0cu6OYaGXELK1OmEPzTSM9mcYXH4KYTAc11?=
 =?us-ascii?Q?82ggCDGtmx9TbsO6tBc04nPxApxAiPKnRCVYHmyomhoDkUxoc1S4gTdrA0dD?=
 =?us-ascii?Q?uG+8lyDlAh+VUdhbj/SJAgf4QDGODalLhfC9LaBUicep9wjNd1IvpPAxGzh8?=
 =?us-ascii?Q?j/VexTjkakh1PHI05dDsWro5ZvzwDu7/1u6VORx0IKB7u4Q/8eub9usQtWZ5?=
 =?us-ascii?Q?6bqGt7hc68wwq4smJyhxqEl5qDxLp+i3lE03eQevt8CPtRtfYgRDxGT0btj0?=
 =?us-ascii?Q?2a0nPnghAoT/PDPp8sxfV0ZuNDRFtBDikGbFOrdvV+/aue5uvF1sVCmFz390?=
 =?us-ascii?Q?kCFBw1SnacJRmBGVAU6rff6KDp4fcxZJ1e3Rmj+EXQm4ZqcrgqT06Rbmyv7e?=
 =?us-ascii?Q?3SsfWzS6auL8WaX9Brl5LVWg675V9xdbHuzhVPQ4jGL+bt73jru0nFRsXsvP?=
 =?us-ascii?Q?dgaa2E0c+g/xL8vF9YPHl1Iwgsb9l3jRQ9vPTAWdz3e9PIKIhbYUUQCGiss8?=
 =?us-ascii?Q?j0uO2eAeDxzsKaEhxCZOJD4D4iqdQuaiJJIvGKZtLv7e4jrwwFPgXVKEn5ec?=
 =?us-ascii?Q?XYPa/HgSi2aitn46Hmp0MyL+tAsOtdscBrlTQU5iWPH/khovnucygmdmR7rO?=
 =?us-ascii?Q?KKE7AVdO/f0jnnH/gkgutpH/eyMID4wE6As2eM2VkLLxr2YgT/azDV1u1Bv0?=
 =?us-ascii?Q?xd7t8Gj+nd5K3aI+jV9pSghDA0lCqPrWJ3jTAW+489irHS1o2lcbeWW5VCSs?=
 =?us-ascii?Q?eVe9zbNSaCG6sggmpn5yROdeUHz6zk44ZQEhVpkXejvF1ePCcOnpDEBKZJQ6?=
 =?us-ascii?Q?8F4tzOtTiguWEcC2miAi3A0jFhdARAGRshXqM/+JJ9iFMmfXCwrioFNn11Yv?=
 =?us-ascii?Q?ro33DYMpFeVYVRG2YGN5JzxvKNbs1Vh+ZcavLDK2?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3b9e8f6-3439-4da8-2d33-08dc36ed6a65
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2024 17:07:30.1416
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 16r/jHl3EqcUEj2BGOwRlxnAyewgWp4eKD9LV4uaYLftEnnwtAifk/u/VB8WwPNM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6905

Introducing global statics which are of type struct iommu_domain, not
struct arm_smmu_domain makes it difficult to retain
arm_smmu_master->domain, as it can no longer point to an IDENTITY or
BLOCKED domain.

The only place that uses the value is arm_smmu_detach_dev(). Change things
to work like other drivers and call iommu_get_domain_for_dev() to obtain
the current domain.

The master->domain is subtly protecting the master->domain_head against
being unused as only PAGING domains will set master->domain and only
paging domains use the master->domain_head. To make it simple keep the
master->domain_head initialized so that the list_del() logic just does
nothing for attached non-PAGING domains.

Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Moritz Fischer <moritzf@google.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 26 ++++++++-------------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  1 -
 2 files changed, 10 insertions(+), 17 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 9d36ddecf2ad64..19a7f0468149cf 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2507,19 +2507,20 @@ static void arm_smmu_disable_pasid(struct arm_smmu_master *master)
 
 static void arm_smmu_detach_dev(struct arm_smmu_master *master)
 {
+	struct iommu_domain *domain = iommu_get_domain_for_dev(master->dev);
+	struct arm_smmu_domain *smmu_domain;
 	unsigned long flags;
-	struct arm_smmu_domain *smmu_domain = master->domain;
 
-	if (!smmu_domain)
+	if (!domain)
 		return;
 
+	smmu_domain = to_smmu_domain(domain);
 	arm_smmu_disable_ats(master, smmu_domain);
 
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
-	list_del(&master->domain_head);
+	list_del_init(&master->domain_head);
 	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
 
-	master->domain = NULL;
 	master->ats_enabled = false;
 }
 
@@ -2573,8 +2574,6 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 
 	arm_smmu_detach_dev(master);
 
-	master->domain = smmu_domain;
-
 	/*
 	 * The SMMU does not support enabling ATS with bypass. When the STE is
 	 * in bypass (STE.Config[2:0] == 0b100), ATS Translation Requests and
@@ -2593,10 +2592,8 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	case ARM_SMMU_DOMAIN_S1:
 		if (!master->cd_table.cdtab) {
 			ret = arm_smmu_alloc_cd_tables(master);
-			if (ret) {
-				master->domain = NULL;
+			if (ret)
 				goto out_list_del;
-			}
 		} else {
 			/*
 			 * arm_smmu_write_ctx_desc() relies on the entry being
@@ -2604,17 +2601,13 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 			 */
 			ret = arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID,
 						      NULL);
-			if (ret) {
-				master->domain = NULL;
+			if (ret)
 				goto out_list_del;
-			}
 		}
 
 		ret = arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID, &smmu_domain->cd);
-		if (ret) {
-			master->domain = NULL;
+		if (ret)
 			goto out_list_del;
-		}
 
 		arm_smmu_make_cdtable_ste(&target, master);
 		arm_smmu_install_ste_for_dev(master, &target);
@@ -2640,7 +2633,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 
 out_list_del:
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
-	list_del(&master->domain_head);
+	list_del_init(&master->domain_head);
 	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
 
 out_unlock:
@@ -2841,6 +2834,7 @@ static struct iommu_device *arm_smmu_probe_device(struct device *dev)
 	master->dev = dev;
 	master->smmu = smmu;
 	INIT_LIST_HEAD(&master->bonds);
+	INIT_LIST_HEAD(&master->domain_head);
 	dev_iommu_priv_set(dev, master);
 
 	ret = arm_smmu_insert_master(smmu, master);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index eb669121f1954d..6b63ea7dae72da 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -695,7 +695,6 @@ struct arm_smmu_stream {
 struct arm_smmu_master {
 	struct arm_smmu_device		*smmu;
 	struct device			*dev;
-	struct arm_smmu_domain		*domain;
 	struct list_head		domain_head;
 	struct arm_smmu_stream		*streams;
 	/* Locked by the iommu core using the group mutex */
-- 
2.43.2

