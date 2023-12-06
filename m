Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2088.outbound.protection.outlook.com [40.107.223.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46C56697BE;
	Wed,  6 Dec 2023 17:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="JUCoZWgQ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l7aa7YlpkD/tieJGt+nEXAcFys8Zs/VwKTvnKt3OdarSk7+l/8cA0WGchYOb+ugTbM4R0Yt5WIep6saLa0tKhW2+FSKH8Ypsy6/jmMOMRq9UlFFk7kDW6P4RfPCsbvHSjlV1pjZ5sT5PZvspX2FImVEbRMKsQ1LoCzZvIGLriWGn1oY5S0wMc821djy7YNfQX8TdnRzuPtTChae3D9ABvW5Xv6R1Wr6RiU1VLTIYr62UPdT683kRxLzp6hi77+k+2imj+AKE4RoqPPS3CEzNCB6pKBstpnFYId+Niv2HIijlsS8f+KqbsIaGA8MTGGX+Xn8YLGYL1wUMA33fXb/Xdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BFa0jDCQ7EnqwSERTTcTJj48bgdBwAAyV8J/yQgvDL4=;
 b=ZBRyspauDb3iRQBcI6zmvK4LMbO0TvH3Yd6XDG3fdIlHVXVO3gdlOj539vDlqOdZZmT7wXRfsm9q5/TVaA3ODp/SCYG/Fc5YI9SWwJ0pcn5KV2kf6UurTzhv3rxLC53QG8cru/r2P7eyM2G8WwT01xG7Rusac2qaXNq3cFUa43ZN1kXEUHJ9zdjTyTi+r3SFlXh7T5YTeoI+WBJnivqjWMyhC+fl/IpDrVF0eQMXJOooFggGuU76xWVM9Rg15aRV756oZ0LhGc3C5AbIz6eWHxLA0GRYIx+MMCiNreBxtCna1svivu3Qf2ZjZQ0M+FJCGvLed8MWUdz8Azyqo7aVjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BFa0jDCQ7EnqwSERTTcTJj48bgdBwAAyV8J/yQgvDL4=;
 b=JUCoZWgQwoeDUzk9XuP+xFg0g9cBCHoFgCBOTrcty4qX/wiMrZVQcc1zdu7dzkmvxrDCUoNGTLwv6wZBt3AuuvXLvk4oArQ/CkJ13DVoFaflCImhL6gxHqobHNSVCOaILMuVLOk7//zX0FmCQces4HYoMfpNx5Msg4FlR3qMFWpFq8Zt0b6DDygp3Zl+GxpVddZbuzXPSXHYolSAldUSYnfTakGj91WZoWOxqKhv0WCFhMElFDYhpEPPKYXKWg8A/6squjRZCIzLJXnP78Eh1zB0Zx/cN+373bVfqD8tj3PPbU1q1IBeHU/td0ehk7qG7ghmHaPBeqcizoT3iJMAmg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA1PR12MB8360.namprd12.prod.outlook.com (2603:10b6:208:3d8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Wed, 6 Dec
 2023 17:28:44 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.034; Wed, 6 Dec 2023
 17:28:44 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH v3 22/27] iommu/arm-smmu-v3: Consolidate freeing the ASID/VMID
Date: Wed,  6 Dec 2023 13:28:28 -0400
Message-ID: <22-v3-9083a9368a5c+23fb-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v3-9083a9368a5c+23fb-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR0102CA0039.prod.exchangelabs.com
 (2603:10b6:208:25::16) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB8360:EE_
X-MS-Office365-Filtering-Correlation-Id: 29108c28-f026-45d0-4fe0-08dbf680c737
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	I+87ny2UYmga1s2SRcm5MqYg+SMOXgkjD91FGDUZzUv9F4ownjTweVo6o56AZxRtJnIfKRamMltfqc0mpetMm6MQ/KMubTppxDEjHeLP7ckpykVNihw4gtnRCp/PgpVpb2M0tFN5UWWEMM5UvdGSxCOKKg0pTWyf1Dt4OwLilKxTGd3QFun9X7QxVWKkSNImWeJnBooYXvWUSyhNTQ3VkehAUZQ8YNHpeMH0X/5ZVSeER+Ne8aOKgE6z6wvu5uen8mCX7Tl+fYOf+wTG1ybHadcox3XuW3GHT9BtN/7+8beGyAuE6pR5POjl1DE2N1Rmr5NEXloizhaV9Bcs4M3m0Uh7pbND+idf2lXKTXrjDZd939O4S8rJzadkIQt20mWteLgS3zE8e2oZQxGPSs512f1p5O3757yEGMsfqIYi//LgjS2qpyGzL1zJaogIx7hbtJ2O+++DGNnABOPVy8pvK+y5P50yglGIxNkiTmZEbkXxAmSmhZ0ugA9PRtEO2+CWl5IyYMb34AzqU5Fupn5Vands0bTe7jp13C3eR7wMmqIhTlrQ5l/HNgRN1o9jGqL4
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(376002)(136003)(366004)(396003)(230922051799003)(186009)(64100799003)(1800799012)(451199024)(6666004)(6486002)(478600001)(38100700002)(83380400001)(66946007)(6512007)(2616005)(66476007)(6506007)(8676002)(2906002)(4326008)(54906003)(7416002)(5660300002)(86362001)(36756003)(41300700001)(66556008)(8936002)(316002)(110136005)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+SH81RBpk8UUEXpz2eqggNDvPnB28cPX5jpYBcttWB+UeLVuAszmIATG0igI?=
 =?us-ascii?Q?0j9PBNXmGd3vo82EbN+8T4lJobhrEWlZ07Fdt1dN8Dl/VREpUgNzl8PBb5rr?=
 =?us-ascii?Q?ReuiQyy3rnnTtu+dV3fYn5aPIvhLnaGn5vEZcEvmYrVWYoOBB8hmHIfBziAf?=
 =?us-ascii?Q?E/Mq61D1oGvkQVR0AiZ+EKf/e1vX+rFQ9RraMXSQS6C67hnaq/Onspjo3naS?=
 =?us-ascii?Q?hPjhyqy0vTmvB1JMWmqwHX+hY8+ZbzA7WYXaBUeYiXVX214XIp3duLK9Rtwc?=
 =?us-ascii?Q?/vJJrfoylmsc2sxFG/sJQAZ/EaVf1pXNJThlbxLgNi7EP9lzSoYtCggEe402?=
 =?us-ascii?Q?Q2C4Vilsj013siWBYcfgMUYgkHJWZWMmdzyvTCfDeobVDv5MQ/ESfo6Y0kTU?=
 =?us-ascii?Q?pXLjcFmz8ANBRL0ti0hA32dSFl/guTGujwH0xfvTS8cjYJFwbrD4ET5E4FNB?=
 =?us-ascii?Q?kjkYS/gnL2NuWBd5T1FbDxyAeLn6/5hRu395b2SgAy110foaumXmIZ+geluF?=
 =?us-ascii?Q?T8jKdKn8+npkHOpbPfOKTVRd+IMe2tSPUWoQCH8KQTEPH1HYeiTiFQqOUlWZ?=
 =?us-ascii?Q?Z9Jce8Av/i6868+jKP7wKDlZ1zZDUolIcGuCViS3KoSkel4A2slNPzwD3bWt?=
 =?us-ascii?Q?KxCzrp8U6L0unfp7jhYJRJrrk1Xuh3o/CozU8tA5NsiMHI/ti9Op028KLRyR?=
 =?us-ascii?Q?U7Y8gsl8CsboUFhxJ6g/eyxH/1RoLKXjRA+2uU07sVe8soVwA8CgpT5W6POL?=
 =?us-ascii?Q?BK6rKlNxp16/VYTLL24qAkPi6zMYULbeBF+xbAG/bryOkkaoubHdfsBPg6Oi?=
 =?us-ascii?Q?qhIzVPWVNsVNoXac1o9QJlDwixN4k++HIzxjL3sAULlWcaqsZ2x/e4Z5Cq0t?=
 =?us-ascii?Q?0CY5g8WK9vKqvA+gkmr8wX7Q4BNzBR+ZibkISdKyrHc2CQhA0ToiBKG5pg54?=
 =?us-ascii?Q?qjgyiNpP5iBPAnjS6HQvlzu6qoLAli8ej8W77oYd7vF90SyQehH9lf7hEjak?=
 =?us-ascii?Q?Q504+FJWeQsJcH/YMbpsV9leDrG1cl5BV3sCsbfj8sAnI9w8dznWpSh+NNIi?=
 =?us-ascii?Q?pGPYjhyNHcxkeqOfXO7z5ioXPxf8yi2nZSGiL8hB5bj71AjWALdAff3vlLxi?=
 =?us-ascii?Q?AddZLQIjPmkfbiMqnD39CIxsXcHV4foBrmXEfEpnBuYufc2UYix+NUXjgtnQ?=
 =?us-ascii?Q?28GM2SdMX5oOHvVLu3AUNiO+nNzZKdkWz+/Nic4lPdSMqIO/6U6AtaAkYPru?=
 =?us-ascii?Q?/Wyf/HOoMxgjiPC9RiUY5yG5ZqPEDMMoS14vUq6TPacybhdSMDbXkoL3qmk/?=
 =?us-ascii?Q?GIh+txX7DIKnVLniTFtNY5NDp69yC8C5pZz195VoR5CAbcbHU27btQDZ8nbI?=
 =?us-ascii?Q?STxgQr9fSvlY45HXZyD093wXl9au22h8mbTzctMogQPFYnYthiuayzwbn/eS?=
 =?us-ascii?Q?AdNTLlbfSaB+luAPvjrkvsJX6Zjb91rdraJIqixBekfhuwW43SL5wBHW0etY?=
 =?us-ascii?Q?sHn6032W+Y3HGkC45EFy3RtPOH4DQewhMJIGDy1+sc9eglCXxoTDNEBEtCKP?=
 =?us-ascii?Q?iigGDKKlf7t6RAJB+nOZxduQ+HMgFOfnkt4gzPxM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29108c28-f026-45d0-4fe0-08dbf680c737
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2023 17:28:36.2999
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jrgF4tO/WbnxTwjlCUGvszwU/hIsXYS4/pduGvtXt1HVy5IynGd3KWjluPLx19Sn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8360

The SMMUv3 IOTLB is tagged with a VMID/ASID cache tag. Any time the
underlying translation is changed these need to be invalidated. At boot
time the IOTLB starts out empty and all cache tags are available for
allocation.

When a tag is taken out of the allocator the code assumes the IOTLB
doesn't reference it, and immediately programs it into a STE/CD. If the
cache is referencing the tag then it will have stale data and IOMMU will
become incoherent.

Thus, whenever an ASID/VMID is freed back to the allocator we need to know
that the IOTLB doesn't have any references to it. The SVA code correctly
had an invalidation here, but the paging code does not.

Consolidate freeing the VMID/ASID to one place and consistently flush both
ID types before returning to their allocators.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |  9 ++---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 36 +++++++++++++------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  1 +
 3 files changed, 29 insertions(+), 17 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 30cdd0661c00da..19b4d52be7ab66 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -371,18 +371,13 @@ static void arm_smmu_sva_domain_free(struct iommu_domain *domain)
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
@@ -427,7 +422,7 @@ struct iommu_domain *arm_smmu_sva_domain_alloc(struct device *dev,
 	return &smmu_domain->domain;
 
 err_asid:
-	xa_erase(&arm_smmu_asid_xa, smmu_domain->cd.asid);
+	arm_smmu_domain_free_id(smmu_domain);
 err_free:
 	kfree(smmu_domain);
 	return ERR_PTR(ret);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index c87e3f197e0fda..83e31177215533 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2231,25 +2231,41 @@ static struct iommu_domain *arm_smmu_domain_alloc_paging(struct device *dev)
 	return &smmu_domain->domain;
 }
 
-static void arm_smmu_domain_free(struct iommu_domain *domain)
+/*
+ * Return the domain's ASID or VMID back to the allocator. All IDs in the
+ * allocator do not have an IOTLB entries referencing them.
+ */
+void arm_smmu_domain_free_id(struct arm_smmu_domain *smmu_domain)
 {
-	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
 	struct arm_smmu_device *smmu = smmu_domain->smmu;
 
-	free_io_pgtable_ops(smmu_domain->pgtbl_ops);
+	if ((smmu_domain->stage == ARM_SMMU_DOMAIN_S1 ||
+	     smmu_domain->domain.type == IOMMU_DOMAIN_SVA) &&
+	    smmu_domain->cd.asid) {
+		arm_smmu_tlb_inv_asid(smmu, smmu_domain->cd.asid);
 
-	/* Free the ASID or VMID */
-	if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
 		/* Prevent SVA from touching the CD while we're freeing it */
 		mutex_lock(&arm_smmu_asid_lock);
 		xa_erase(&arm_smmu_asid_xa, smmu_domain->cd.asid);
 		mutex_unlock(&arm_smmu_asid_lock);
-	} else {
-		struct arm_smmu_s2_cfg *cfg = &smmu_domain->s2_cfg;
-		if (cfg->vmid)
-			ida_free(&smmu->vmid_map, cfg->vmid);
-	}
+	} else if (smmu_domain->stage == ARM_SMMU_DOMAIN_S2 &&
+		   smmu_domain->s2_cfg.vmid) {
+		struct arm_smmu_cmdq_ent cmd = {
+			.opcode = CMDQ_OP_TLBI_S12_VMALL,
+			.tlbi.vmid = smmu_domain->s2_cfg.vmid
+		};
 
+		arm_smmu_cmdq_issue_cmd_with_sync(smmu, &cmd);
+		ida_free(&smmu->vmid_map, smmu_domain->s2_cfg.vmid);
+	}
+}
+
+static void arm_smmu_domain_free(struct iommu_domain *domain)
+{
+	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
+
+	free_io_pgtable_ops(smmu_domain->pgtbl_ops);
+	arm_smmu_domain_free_id(smmu_domain);
 	kfree(smmu_domain);
 }
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index a229ad0adf6a49..c7c4f4fda31297 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -789,6 +789,7 @@ int arm_smmu_set_pasid(struct arm_smmu_master *master,
 void arm_smmu_remove_pasid(struct arm_smmu_master *master,
 			   struct arm_smmu_domain *smmu_domain, ioasid_t pasid);
 
+void arm_smmu_domain_free_id(struct arm_smmu_domain *smmu_domain);
 void arm_smmu_tlb_inv_asid(struct arm_smmu_device *smmu, u16 asid);
 void arm_smmu_tlb_inv_range_asid(unsigned long iova, size_t size, int asid,
 				 size_t granule, bool leaf,
-- 
2.43.0

