Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2047.outbound.protection.outlook.com [40.107.212.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FACE20B14;
	Fri, 26 Jan 2024 18:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706292951; cv=fail; b=JuOlbS26FdFXneTtRh/+i/Fmdnwj3ARphbXMgiFF3cFBnsKcglYeYzx8YVX9Sa2ctpw8p7hphxmZlwYBLzqS85NXYkP3Gzje4SWurGtj7EkmOHf2YtnxZQD9zcBV0uOyJG6uk3WtPRWBjj+Ha61AHAqyiQC3VPilwrjFQPUP/ik=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706292951; c=relaxed/simple;
	bh=xj97CzSACp+u0/tqgM6H295cf8pPON+qSm0APAWp0HQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=q+QA44Vqv1gGa45zx8Vkt9Ls1A3RLTcbgfBxgN7TCA1+0HFtxBixQCMTcIN/okJRBJ+IfKtnpk4SvrK5dzxrW+80ySju+q9LOffimhNpRYcB4M31FzTHAM5U+7ce18oeyk93x6rZprXyisCit+rNygE2b8n7f7dvqSRkNZl6+o8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=SnHrH9bm; arc=fail smtp.client-ip=40.107.212.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="SnHrH9bm"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ax1yT/XEekVEXOKz8WDkkcEKBaISvoD6e/hqyVxTS1oUZHscDF1zmFxm+pOevf2PUbWi/NH+cdIM/el31pZ8vRcQmWMlLip5NyYHHvyQ2cMUY08de21ufYg4Pyib1zi7ltlzIbSjN7qorwTODp1PRkpiDK9f0y2LUNp+5WFJzNVP3uHNrxTCOnthVq0e0qX1PpnBSrja19Oj9lWqXhMBHIy4jVOzVZQ19sLnYPCNlDHRtjlB2RDBrIl8C1Hon9fy4D2QU28g0RXoIPbwnIpXzYDA8sSBL8L1jbPJ/KQe2UwEJq467V9tpEk+9GtlSnMNIV3EbCSIqfJOxTVuU09P9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RjwMmjSh6EyZ6674r65qF/Zz8ySPkRFe2Gm9+tR6FxI=;
 b=dYukgGZbDpGJN+iMOjx+lIcuelwaHD/NTDwZAK02SRky6g+RVxQ+ON/JDeO93AhCkQXOu76chw6QDjZr+1GGedbXcaFI+Zwb7RZonOfSPJtrD3pXcyc3N+0G0YtKE43uXiu33C6xB6Sr7/cXpK4EhCc3iaK6GH4JMM657lqkVtKGl8ALcWmOBn42Kw5ZesgVJPnErCyB8YSO3eXfILl7ePwWykq25KPPhlVvfncE1uKKbxJHpaEeK4fF7YKu5jY7XGIs/cxW/32F38O9XcY74uqzmPDNU7BNaKsDdye64jegeiHofIBldZRoFD88SzJAHwMkF3OChDq/cG/J/aexow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RjwMmjSh6EyZ6674r65qF/Zz8ySPkRFe2Gm9+tR6FxI=;
 b=SnHrH9bmBbnhCtcsKuiBntsxvI24wRtXeE5JB5VF+CT2sBz1J5i6PgVyeUwaya2tX2/fiPVCCuPNVtrOKqTLSDmT0VWvaeteXvndT9tta4HoDhwXKT7i8iquIOZv4VeOTwzxfRL9Pi/GuNJMjIHVqaWowvElkSCp7W27hwpH6W0EkrsNT9XCpSfF2UWG0uoqswKAXZBAqLn7EEwg9rh+Ig0l082zHUInMomTJ1dKy/0WwphuPV0G+9mUQPv8mT9tnBV4rVuR7CvqGG+C43hGL/48bqSwddWQD7r740ZE6ZWYRQ0qaJkkIvWv4oTARB5PzOjPu4wTRybH0FhkK3vCPA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CH0PR12MB5186.namprd12.prod.outlook.com (2603:10b6:610:b9::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.28; Fri, 26 Jan
 2024 18:15:41 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7228.022; Fri, 26 Jan 2024
 18:15:41 +0000
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
Subject: [PATCH v4 22/27] iommu/arm-smmu-v3: Consolidate freeing the ASID/VMID
Date: Fri, 26 Jan 2024 14:15:24 -0400
Message-ID: <22-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN7PR04CA0232.namprd04.prod.outlook.com
 (2603:10b6:806:127::27) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CH0PR12MB5186:EE_
X-MS-Office365-Filtering-Correlation-Id: 4303618e-1c15-44fc-da03-08dc1e9ac972
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	WNHlJEQ4asoi3iVlz3sTfr40THuBNOYGiT6W2e8HP6iFh8T4NE0qz30yF7lQ/AKyrrIQYD0nN0W5JT761N5UiIajQ95ngLrd/TpoGSUIiItKkQWupQwrgG8DT00qrOMQGFG2uf+fwxhJnwLv4Vr1Ooxb1jyqAj8JNyYi//aM8WLjmki9k0CZXOnqX/b5GKPlRfAgQoedDkw67O8cqkp2hJ5dJU4L+GqIsbckXK93zBXIDIyObWaY/royf+VZG/MOTMtKerL66cC/ZRWFcCwvXxmupl9UMz5ipUeHOJzaa8OyzroFB2aFT+Kplf5BGPR0iYs+Z34mLbxVtmNM6tfXenSXmkyMJHm8cpu2cNZonsszw0pR7u5vuo7oreQxdh98FLbHM+rqAe0WZPSJKD2DsnuSAu45HjBHHZ7s7I8tBOIxv3mHtZI7X9MGKv16D0eDT6475bqvLal1kBH1e2quAjfYjg79pbhmiSEAxY81GK5X6+sBQB6pLqSXwc5sQKbDwIzJgxdOi8/17mScr5xVvh4wYEE8gZJvcnF3daIBFKtalMak0/lMGEtA0tXOXryu
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(346002)(366004)(396003)(376002)(230922051799003)(186009)(64100799003)(451199024)(1800799012)(83380400001)(36756003)(86362001)(8936002)(8676002)(4326008)(5660300002)(26005)(2616005)(38100700002)(316002)(66946007)(54906003)(110136005)(66556008)(2906002)(7416002)(41300700001)(6506007)(66476007)(6512007)(6486002)(6666004)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0RTKavtN9w1VXBPXAr9xeGsWYOi/DAtNnVDBqBh9pPSJb9rKLjNkxdCUv696?=
 =?us-ascii?Q?tpJ/07vorT1oomDERmtnHE4tv9fBLYxNn/SI2V1OJBW0GaNyv8Hl6CX4IPOZ?=
 =?us-ascii?Q?G0thoJtdEWqUcxLKwyCmQCfkchl+5OY5F/F0HPqHZSQUSbqAkkC19ZFyQ0MT?=
 =?us-ascii?Q?sMIbw0nCpmQ5C4vts90+/LbJ2MG7bSEb9/jpJcbSywEbxuM6/OcGzJraC11o?=
 =?us-ascii?Q?Ifb5XvQ94pV9CEBLsImKZPGrxEeFOdJT6eRmvFRS2EgTgMxvQiaRy3GzQNx/?=
 =?us-ascii?Q?ZX2UCufrpFmC29Wmpr4H959wtENDtqCG4RiwHdWm8wDuj53D69j9BDDjle5X?=
 =?us-ascii?Q?ENI86CEtpx48rGAaUGZF+0oqfirIxTBoXfekh4CqTL1E7is7tkMbI2OR/LpG?=
 =?us-ascii?Q?DOwoum2iy/7EuBC+cZTzcI6FQUAjZIjNPHFLUqA5Az3/dUW9q+uzPSE15l2Y?=
 =?us-ascii?Q?jrErNwbWdvr4t1g+k2yQqWrKYXWwQLSMtJNGZKb7ezUJM4pPexolGrLzn5J8?=
 =?us-ascii?Q?5NYxfDBPK+Kj/DA6kw3TV9M/2aLtwLQRJGuWkmuR620wWoXILjUwF4s2gHtk?=
 =?us-ascii?Q?Z7xXiOX8BbKHm6Rx74t177rDYq2q2kMtU2AkLfONeKo7wXfvtMFM71j33YuQ?=
 =?us-ascii?Q?sVKCzu6VWT5Ik2ZmPSNzcfy5FcdXJvf4+sSCUFuBV0rpBjcmJ2SsN5HlAJZr?=
 =?us-ascii?Q?GolMqTcHR8wrcp1SbyyWQCZD0cdkwFyeHnoVNBYdhFjRmfX7w/O5+NG0W/Sc?=
 =?us-ascii?Q?2BBfmeHilHnZD1VlruHns9Hjjfgi6Pb/2WM+2IU6VfVAT/c25AINOYXcGQnV?=
 =?us-ascii?Q?d8iGS2JZ5UaOz8kAJyNIctbDnfFUKQrXcoI4FC2QauVD6Xjj/+b6grfkkhsh?=
 =?us-ascii?Q?Y8be0KsNuiQaKrZ+qbIFIILnMN5lPKV/zKsjVywwWpLw73fx9JgxwvTyKlf3?=
 =?us-ascii?Q?K6FyB0bma7vyZgumKO1tREUf56HTzmIvyjOsCx187fo2FHFppvRG62iJt/lP?=
 =?us-ascii?Q?YVuyxdCHI27svo31SHlvvXa1VWGPdpso2IQtsHNysV9jbjF+3jXZbVfHI2jq?=
 =?us-ascii?Q?RWV92Igp+ZNYh1LPJlApZ8K9ssaxhmp2YlAEL+qfTzhQ/2FCQb7ypHY34u7O?=
 =?us-ascii?Q?4N5wlQfBlkgJ8+v6ov0hvGuNP6//8EvLaAWZCkqvfa2kTgEKjAC+hdengMqd?=
 =?us-ascii?Q?KT+kY61xChr4+t33+X6z1/MWxo/OAA++0qpeK3ODyoXQSCFh7/1iEIzrJ+bB?=
 =?us-ascii?Q?1tLgYO3UwzNqoJf3C3dV+Y3p7Z9g2XX4c0T6pkx1STIhKSb/xnLn8sSKFDWb?=
 =?us-ascii?Q?X9ji8he8EMTQkBMxxm6EhvNgOoC1M5ZIJMpJLKFuaYtx6pX59n6oS2TdLXbk?=
 =?us-ascii?Q?M0n3N7C45WDOIhOEtJdrY/6sAjh/HnNX/yTAimHFwJldUSgI7G9mu1hu38B1?=
 =?us-ascii?Q?ndUmKo4uV3xae2V6EUECKpwdEKD2Gz4hch2fCeCQINZ+ymbufJtUbKLVhUZb?=
 =?us-ascii?Q?GYtsQISfp4bCxrZYewOt88Vgv4VKGisQeeATf7vsDVHNh/Egjjn6+SK82Pj5?=
 =?us-ascii?Q?yirKHIDAefD7Dr+JSQijGGnx99QYRX+fJjfzU0Hy?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4303618e-1c15-44fc-da03-08dc1e9ac972
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 18:15:33.4082
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ndKjpC2nctDV0hSqYZqbIFylOR+DCTOX7UKXKGYz1XhD8aF5lsJFtx2rm3DlHKYT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5186

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
index 3b35e61cf1bb49..46b4b7626a7c2d 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -381,18 +381,13 @@ static void arm_smmu_sva_domain_free(struct iommu_domain *domain)
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
@@ -437,7 +432,7 @@ struct iommu_domain *arm_smmu_sva_domain_alloc(struct device *dev,
 	return &smmu_domain->domain;
 
 err_asid:
-	xa_erase(&arm_smmu_asid_xa, smmu_domain->cd.asid);
+	arm_smmu_domain_free_id(smmu_domain);
 err_free:
 	kfree(smmu_domain);
 	return ERR_PTR(ret);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 58b4dcb6f56f99..fc7824c8decb50 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2285,25 +2285,41 @@ static struct iommu_domain *arm_smmu_domain_alloc_paging(struct device *dev)
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
index 2bc04802ab01bf..4e8806862ebeeb 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -774,6 +774,7 @@ int arm_smmu_set_pasid(struct arm_smmu_master *master,
 void arm_smmu_remove_pasid(struct arm_smmu_master *master,
 			   struct arm_smmu_domain *smmu_domain, ioasid_t pasid);
 
+void arm_smmu_domain_free_id(struct arm_smmu_domain *smmu_domain);
 void arm_smmu_tlb_inv_asid(struct arm_smmu_device *smmu, u16 asid);
 void arm_smmu_tlb_inv_range_asid(unsigned long iova, size_t size, int asid,
 				 size_t granule, bool leaf,
-- 
2.43.0

