Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2044.outbound.protection.outlook.com [40.107.244.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B19268B8C;
	Wed,  6 Dec 2023 17:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qyFx8aPy"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B71BOfSc8X6v2R0QKsDTAuaf3ZtyOrZDh2WEsk3YuC8OGHUyVYBk+XyYHpLGkDy6RcPx7VFfg7Z6cKF+Rx4Uv0M6747b+1yNQIWwlzrbg12FX83LD9IKzxPmW6JbxNq73KRXt7/PgpeMUcPeim9/AOAy6FBKmfCrDNBBNDsNMSakA/rYh6c7AHJm3qP8Mtk82rEfKPbZ7Bei+Y4EfvRys2nrNJUV0170VGNRHTKAm4pkR26gbiEEqi2oXUJcw8ya9XdY/Y23Ua9lb/UtREMa/mVlvnbTodeJuYU2bfRB2CS8pTsuN7Ou/lJrRdUhUH8Is0JDiw2wouISv+8Wlo0gkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DJt7TVjS1AM9FM/jiszbXAAXo61ZvURxUOsjWtsE+H0=;
 b=TsHNCQFlkJ5x/NSIqvYk5iV3GK9PhXP+GDe9x2JgRmLAZD66hSvsVYdcdfGRZMfmI6c3FzEoUBukOVTTvRksUuIDR33myPKKzr4dY3/YMLfMPWPHv1SFTZ2UpMgBgW99AtgaO3CD+dGD4+3S1pN9fKt7SjfI52Ql39IhcDkfuml/YTWAKZ1ftUYX6FTATMmPaf3dk2f4T+KCB1tEgQxSvi01ry7y6aOqcUpADFWh0ez15Y+KwgExQG66NDw45ULrt4e722oYE8ALep7YyS6SDvymtIjAPmKPaKOxeJB3MXekfu/hrbhfHog5zYEq9XOkQdAx38FGbWTNCWwzdf+r0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DJt7TVjS1AM9FM/jiszbXAAXo61ZvURxUOsjWtsE+H0=;
 b=qyFx8aPyO87BzK34wQAcgqGtR7yfXfH3G2Tu2f9q7dtyBfRt4lG/9RIpYJKyUMBgxvV8IJaGvfsgJDzdR0GIkaHgLtRLCalRyyFc8YEqq86jl7vM0PQtrF53v8y2NMTzGpsRAcaVlf3aVRUJ3qzieKgmSM5bwR/8IgdqrWauo+kLT01AmWC9BlXdQf1ve0fq4h64wkgHoOnTRyCn7OP/vwMev7GShREEh2VXpwMUEL9s7GX6CYGj8/qrfJcRbpfcQB8qsFIuozDO/lxD08AN3O8c5d0rVvxj4FLyzaqoHWU0uhqlshevtQcGvRZXicCV5ycW8i7va1Io2S50ff7vZw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA1PR12MB8360.namprd12.prod.outlook.com (2603:10b6:208:3d8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Wed, 6 Dec
 2023 17:28:40 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.034; Wed, 6 Dec 2023
 17:28:40 +0000
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
Subject: [PATCH v3 06/27] iommu/arm-smmu-v3: Consolidate clearing a CD table entry
Date: Wed,  6 Dec 2023 13:28:12 -0400
Message-ID: <6-v3-9083a9368a5c+23fb-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v3-9083a9368a5c+23fb-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR22CA0029.namprd22.prod.outlook.com
 (2603:10b6:208:238::34) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB8360:EE_
X-MS-Office365-Filtering-Correlation-Id: 34538971-27e2-4d1e-321b-08dbf680c657
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	zsagU0suiEmnKD0Rwj6NveQf93kBxQV2n+hA/Q8RpDdZKg9FDiDyFLHvuNtY58s4P0FCZV4yTCF5gXMXTUDyHKXrL+XHF8b1xzN+X89nUOF93CWsak12cCQkNXEBfNfq+XZL4WReMarUlM4uUIwvIsPDsf+tlFxS8hrr/iv3DLxHBrowYva7jyD0HQXstYPlB6VFpY0S4HYEZsn1I9xM9vbhSs3m5jiAaMsmalt6eYBORxMkR4uCserdD6kgpvIY9bKCTEGn1NGWIN+2MWYjPpaBqOkF5KUPJuHZ4CXNgmA2ACf4xJ//KofIDhWfyo2714M88DgYfZuPu9kCubR79bnnvlSmmjNNDr6kOg1P1wAVucifDExpbcHF4TJbBBvvRRrLZ1efPNOCu4y1QyvtOzPlnQJXHFw4gZGCj6JoI+fabHSlDYwVsd2PVJYcy9skGMAx4CIjfXt31w64xhhAi5eexKWR/FHne56oQcbOSQ9QY8Ttv/nVLbCqCcJeESGdTsUuDI8/396qhsr3PSLmihFA/WdxzVrghzP0gmeAc8+9xGsIXmrgzTUNjzgomQ1qbkoVVkuaZeb5m7HhdKcbpXc7zbCrTA79Rh/t4cK/kFQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(376002)(136003)(366004)(396003)(230922051799003)(186009)(64100799003)(1800799012)(451199024)(6666004)(6486002)(478600001)(38100700002)(83380400001)(66946007)(6512007)(2616005)(66476007)(6506007)(8676002)(2906002)(4326008)(54906003)(7416002)(5660300002)(86362001)(36756003)(41300700001)(66556008)(8936002)(316002)(110136005)(26005)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0wbknoBHG/uAf/dPIi3vc0o4mYqScU5noT2ACodwzgv8dzcgytKc7CQZsS5q?=
 =?us-ascii?Q?xFBL5/Sf25jxY1gi7vPMuTAkzzZyvCXefZStALWKl6Wu0H/64xjvoqBEhj/X?=
 =?us-ascii?Q?ul3oCEeAthX6wirhaNQVgsaMamI/bnuZtbiexO5FdwTpcNGeGQeo0fqtB3cq?=
 =?us-ascii?Q?sFJhe0Oby5DdtS6Khq0ZPsSwcLjy4rxvokTMgRvMEeD7CFT2hWe8XAQ87CRn?=
 =?us-ascii?Q?lU/+4l7UzuNxH+RgeRQU+cAfROzI1STINRHtspc0Us5BclJ8ONWKqoBPNz7j?=
 =?us-ascii?Q?WYrvnvqkZ0sFVCVmykgD0go2Vq/fWaxx9FVxKyYQNTLKWkwfCLng3qTXwIVk?=
 =?us-ascii?Q?MxER3RxDqnFiAqNhydaRqNGz7e6VXd8XNH+lHhCAGxdf4bkDVWPKcGDe9osF?=
 =?us-ascii?Q?+5FvpO3ubSQDG7vP84BlppyOATcDwdzUP9zuzXCjOKeduCxnLxjYgHNdR/ce?=
 =?us-ascii?Q?a6F+GkGtms6717pTCXFIJrZ38v4MoetBOHQiwBRYRh9aus2ztdr8lNcpC+Yb?=
 =?us-ascii?Q?aF8Hkh9hnjjafOKO0CbaEU7zMy9f11Ud1U4zVfriao4ID2KZxfkHx7fT0574?=
 =?us-ascii?Q?EwzBuJVdo43R3EK+LALwGd7IErCdPwn0W8wjk5Z5zia0V5YlNfDIz4jrcHj+?=
 =?us-ascii?Q?PTCnadOsCoHkSAPoNo7QI9hz2OMG+Kcn53+G9PP4WPoIfkzQqLU4R+Hsk62L?=
 =?us-ascii?Q?ozbrIGvwZry+hKALrYbTW9j/h+vwYCJSn0mq9PZtrGRgzGRKtGYqXXELdme/?=
 =?us-ascii?Q?9Ww1i0UXZIGeqQ8Y+nw8QFCRRE4WO0Z2uPtCi30SAJv0+IcBfLqQ69qlu8N0?=
 =?us-ascii?Q?E/TJfQJcuipInr7Qfgqm17+msSB3qtkWymiqAAz+meeXU6AJElXJcgA7/ftY?=
 =?us-ascii?Q?wBWFRH4c5YnZQUBmyoxKu5ci/xdMuNbdO5kHqhq9MfwCgnssmuiIPwfUAiGU?=
 =?us-ascii?Q?txIXNw8N4wJO/n3HsfkTevtVt9JwQn5Y48JNcIctqzalDZs2hsw7qs0zMzUv?=
 =?us-ascii?Q?SBABEX2+OvMmAkaNdT51o28Ot24qzyorjjk1TLMQeX62AjzZJny73Cfi/uqN?=
 =?us-ascii?Q?KRGOkw3FXl8GiMAP5Wqkf58Qay9+WGsM98Fx6q4MFyMm1LLcqdhn6Kk0mXIm?=
 =?us-ascii?Q?JE6x1OGNCIAxA2cTMbJepr8VQ724YXd5g+boT6ECv5rpbLI/tQp6L1N/N2Y9?=
 =?us-ascii?Q?ngpNyGgRSJTOHmxpZIh2Rv2cAuMbN4vehaU5khfKF+aY56Frpj/iqxpZpQdf?=
 =?us-ascii?Q?f0lhS5GguZvqnw5PnorQg8q7niFtmTV8lTFN/MkgffeCeXjtNKPc+XDuMjM+?=
 =?us-ascii?Q?xsSqvmFBUot+0t00lKCrYdKn4V+nn3TGTcHodsw5Ya52Q50grp0PXO8xFOYm?=
 =?us-ascii?Q?GxlwYEnslDQ2UWXTpaTD3TZ0L4rshnTHb4Rnw9znecwTso+NDAPOsD51Ucrm?=
 =?us-ascii?Q?xso1FwoKhm5yIsGiC3Vap78CxdDc1lgkoUXBRXtn7imviFt0suhHvYI9xqpV?=
 =?us-ascii?Q?AaU4wL/bCaoYtux/Yl1l/D9e2v3niYO1m9rBfMFq1cPW4rRW9xs74erUJmKx?=
 =?us-ascii?Q?yYR9Ald3auxQwBHSjBKRwiqhDOXIg7T/fk9iEi5s?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34538971-27e2-4d1e-321b-08dbf680c657
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2023 17:28:34.8212
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: emCw/Dz38Zx70dNMnz/fNKdjq3Qzagx0f+cLvfb0L2QypoMHckyJgtuq8WTsWUpU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8360

A cleared entry is all 0's. Make arm_smmu_clear_cd() do this sequence.

If we are clearing an entry and for some reason it is not already
allocated in the CD table then something has gone wrong.

Move the two SVA flows that clear the CD to this interface.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |  9 +++++++--
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 20 ++++++++++++++-----
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  2 ++
 3 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index ee3d148aafa26b..521bfa18879f90 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -328,7 +328,7 @@ arm_smmu_mmu_notifier_get(struct arm_smmu_domain *smmu_domain,
 		ret = arm_smmu_write_ctx_desc(master, mm->pasid, cd);
 		if (ret) {
 			list_for_each_entry_from_reverse(master, &smmu_domain->devices, domain_head)
-				arm_smmu_write_ctx_desc(master, mm->pasid, NULL);
+				arm_smmu_clear_cd(master, mm->pasid);
 			break;
 		}
 	}
@@ -352,13 +352,18 @@ static void arm_smmu_mmu_notifier_put(struct arm_smmu_mmu_notifier *smmu_mn)
 	struct mm_struct *mm = smmu_mn->mn.mm;
 	struct arm_smmu_ctx_desc *cd = smmu_mn->cd;
 	struct arm_smmu_domain *smmu_domain = smmu_mn->domain;
+	struct arm_smmu_master *master;
+	unsigned long flags;
 
 	if (!refcount_dec_and_test(&smmu_mn->refs))
 		return;
 
 	list_del(&smmu_mn->list);
 
-	arm_smmu_update_ctx_desc_devices(smmu_domain, mm->pasid, NULL);
+	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
+	list_for_each_entry(master, &smmu_domain->devices, domain_head)
+		arm_smmu_clear_cd(master, mm->pasid);
+	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
 
 	/*
 	 * If we went through clear(), we've already invalidated, and no
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 0847ce91c5cc1a..7fcd578b762afe 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1195,6 +1195,19 @@ static void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
 	}
 }
 
+void arm_smmu_clear_cd(struct arm_smmu_master *master, int ssid)
+{
+	struct arm_smmu_cd target = {};
+	struct arm_smmu_cd *cdptr;
+
+	if (!master->cd_table.cdtab)
+		return;
+	cdptr = arm_smmu_get_cd_ptr(master, ssid);
+	if (WARN_ON(!cdptr))
+		return;
+	arm_smmu_write_cd_entry(master, ssid, cdptr, &target);
+}
+
 int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
 			    struct arm_smmu_ctx_desc *cd)
 {
@@ -2622,9 +2635,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	case ARM_SMMU_DOMAIN_S2:
 		arm_smmu_make_s2_domain_ste(&target, master, smmu_domain);
 		arm_smmu_install_ste_for_dev(master, &target);
-		if (master->cd_table.cdtab)
-			arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID,
-						      NULL);
+		arm_smmu_clear_cd(master, IOMMU_NO_PASID);
 		break;
 	}
 
@@ -2672,8 +2683,7 @@ static int arm_smmu_attach_dev_ste(struct device *dev,
 	 * arm_smmu_domain->devices to avoid races updating the same context
 	 * descriptor from arm_smmu_share_asid().
 	 */
-	if (master->cd_table.cdtab)
-		arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID, NULL);
+	arm_smmu_clear_cd(master, IOMMU_NO_PASID);
 	return 0;
 }
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 24a77e0a97898b..a8e7574ab8e154 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -763,6 +763,8 @@ extern struct xarray arm_smmu_asid_xa;
 extern struct mutex arm_smmu_asid_lock;
 extern struct arm_smmu_ctx_desc quiet_cd;
 
+void arm_smmu_clear_cd(struct arm_smmu_master *master, int ssid);
+
 int arm_smmu_write_ctx_desc(struct arm_smmu_master *smmu_master, int ssid,
 			    struct arm_smmu_ctx_desc *cd);
 void arm_smmu_tlb_inv_asid(struct arm_smmu_device *smmu, u16 asid);
-- 
2.43.0

