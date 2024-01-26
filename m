Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2082.outbound.protection.outlook.com [40.107.243.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B724208DC;
	Fri, 26 Jan 2024 18:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706292950; cv=fail; b=sf3nN8PvA7VxvaKNNdKstZp16eJwwHYht53gGUGVDMcIJbqXArb0HxgMbGIATIOhZqe9F/iFCdI1XUrVSt4x1P/QuTQK7gEzxZB1bIOrpgVfkYFDD0eTf31g0s8mjh3x8xG9r6Fn+ynHVWadQ+qB/Qrog4oY4x2itk2R8ndVCR0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706292950; c=relaxed/simple;
	bh=ROynH1ke8KJB75cFv3A0yXCDdkFFhksF+b8mAiPPuFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QIB00c7lbvs+mrzkRS5ITFq5wvvxX+xZloaw63YCTfnFdnESJGpCOvnwl1VER91quZgf0huTkcA9VTGqh3kOH4VpVWc8f0uMbUZfyijFFqksDK8yDQNou+PTTq/tf87qBVLD/mIuxUtlO3L+n0le9Na1CbReivZ1MLtoU99hIvA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=rCIpHcT5; arc=fail smtp.client-ip=40.107.243.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="rCIpHcT5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SdqvONfJYYEgvIrHEjaLgen6bI563OlNF9U6mVHT3RSTmb2vZUvFFm1UHnTXcwcAwN0c1nytbEKARQweBdmo4zq2fzdQ3DYxldmll8p5/qaiyAPm/DdK6E4fNAJgtm0IHMNlkUuzkYB09kExmth/YEHfH7l1BF7np1QyLTFRwP4hmHWyJxC7hyFkpSs/0vvIelkBxb2ocp5rH0rlX4jIW0KZBnMZZ4no2/8uGEPKJ5jepFRtL7aw8Ne1Q9ZlsrLeCwALhn7J5BWkSXdC1l+n0qRvZ8K+uMljAH851aTHGJUp6NtGJQeau8+MhyvJe/z4cCwOxbRkdXq9K40sDYPE9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fXjA1CW8fRYb6lttpaMymfcynk4BrEasRmagUKmReFI=;
 b=lcDZ/iiU94Qggdv7ZmOiK9A4zb3Tdl/LKRJ60YrX8kpW9Iphj4iuADAs6MtDe5RDGo/zZwpO1305ow0AefvuDlof5Nb3YZ3gfVMAROl5kQ/f3peUKt9wvfLqSe0A/oqToPbA/m21Hng5WincQXK4pqyEilTD8uuKB4pdYqUya6CZ407dzGeYZxS0NA6s1PPMn6VSkyPjKDeu01nmdyUSnWu/4Z1Iuan65CoQRxPHSNyKmWEG/0YJagrGoi7Cg0lTeb0UQLI9L8XAWLRPyea3Z9LlNDLTc1IvZqdeM2SA6Tx3xIlX3skDNxhMe7uq8g0ZTwmA9gVe/U45POJRUd5Ztw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fXjA1CW8fRYb6lttpaMymfcynk4BrEasRmagUKmReFI=;
 b=rCIpHcT5wUD2rkUWcvYxHKYLDu99xfm3j4Qtz1NlBAcCT6YwuUqO30ZxH13wcTzCJgVVttJ8ocm0xR2vceWkNalJBiN09Oy1mW2nmwz9EnZOlERK7I3VDGO9563WkVqft95BQWj0YD0eFXbAbHiQDHuOBh+/cw2UanZsL8qMbacxVDzF+cmNzcHcBTzVG2y4TkrbXElzYkSX+k4DOmOFi+O/RkkRMXz8WzfkMvksEftaZBe1XNXZYIeIJPQCfeT4Um/UdGghnhtIlgfkoCJkFwC5SaVQ8RQgBCTukpmhoZKGtKf3Ct2Dv97QKZh1AP6E9yMoAxdpvyva9gGNrwG11Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA1PR12MB8079.namprd12.prod.outlook.com (2603:10b6:208:3fb::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.22; Fri, 26 Jan
 2024 18:15:34 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7228.022; Fri, 26 Jan 2024
 18:15:34 +0000
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
Subject: [PATCH v4 15/27] iommu/arm-smmu-v3: Add ssid to struct arm_smmu_master_domain
Date: Fri, 26 Jan 2024 14:15:17 -0400
Message-ID: <15-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0501CA0106.namprd05.prod.outlook.com
 (2603:10b6:803:42::23) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB8079:EE_
X-MS-Office365-Filtering-Correlation-Id: 06557c16-e1a3-4bd3-aa70-08dc1e9ac85c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	A4ZvEnWQ7xOe0ARI0eOe5bRhkliRlH29dM90799T3MZLHCbnN1yAixkFpqpSZfNE06/zYsoVPwoWgWVl4TK+ZffuEJ/0wVbo94fv+/W543DmdAbYEOp7y9l6jNZnKHDmNusa6Gfa3HdfhiJon3vJ87LB7AxbIzL8RWsyA9iMybwj779rghPHDxTfrdXCbrOvauNt6TNMpGdb5BYuQLJipRjQN045NN6i7aw77xn2NGxCSRbn9GLBe2DwdvuNBC2nWvQpKtZnonr6PLTYowuJBXS+AMmXUgDJUeBUs/jFGrqj88Uhsekane56iPJrIl9k6iEddq1KABbqj5IAy/pna82snmb7iHnsixoEjb5O0Yt2Ll6A1h/ovy5MQ8yoEGfqtkKbzwrNMbM5bhmjC+4lT08M4v+LbP7urRSWtimF6+XL5YayxMdr58HtgEFogx5o8Q/5CT83BGdYMaFrq0iLeUKklUAeunTyKZL4iFnvtcoIPTq3oHSvYBk7NxNeXL2wEvnor5+/lolLNT6MQvMTfyk8D/6kRkBNYAETXDO9f2Gntvcghy9F6TmiETIiNGd/
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(136003)(39860400002)(376002)(396003)(366004)(230922051799003)(1800799012)(451199024)(64100799003)(186009)(83380400001)(6486002)(6512007)(38100700002)(54906003)(2616005)(5660300002)(8936002)(478600001)(2906002)(8676002)(4326008)(7416002)(110136005)(6666004)(6506007)(316002)(66476007)(66556008)(66946007)(36756003)(26005)(86362001)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VCDd03VzZXeWj5GarLoxpqHrqIi/fz0NgLE/X1LcNKnr4NxmWBvU8TOS/StZ?=
 =?us-ascii?Q?erHYZu7J1iKufGf6Ja4U/gDYL5n6U8UWwqeh1S9//SGnyisGN6CB6771brzu?=
 =?us-ascii?Q?h5vvEGI/qsQlOY0q5fMh5PVHAaXbgBTPtoIMzltICvwprwv17leIQow2B8JN?=
 =?us-ascii?Q?MV+KuUBZACSndILlsMKUR09nvEM70QJ4+QmdUZ32eYR5Z5KSGB5xPr3xQaQO?=
 =?us-ascii?Q?6twzWGxnj/uVroBsN5ux32ltFxCnCz1z2LirwFUShORavba1jlTEi3lxBAOG?=
 =?us-ascii?Q?YBOy5lwiSFPLfTqiWfYSvhVHCK6eONr/fHM+F4a4YdCHq6SmKMpxFGSvv16e?=
 =?us-ascii?Q?Ut8Yp45s+xrIJfX/dzJeH82pm6dGqXF2iV141lZ2qPXo12o6gRyOHW1d65Lp?=
 =?us-ascii?Q?5Fl4h8Jn5G6UthK96WJEUtEyi9Pjg/Wl/yUuKbUFrNgKEgsM98GU/j/IrPvP?=
 =?us-ascii?Q?THvkI9b4rbJwIdRZ/Kq1t1uqtk38KeYjAq8WZFsBrbAWOaSfSowXkED2h/Ti?=
 =?us-ascii?Q?C3joOsuer4Fk/97dRIicfKyg8tJY3KHF+LZCNopFLcz3NaMuYJaIDcEPTZLd?=
 =?us-ascii?Q?7g23VdD0ZH2c67tGtF0aZK6qU0VBXxhqz4ZAKbtaHz1hvBnnzhR4G0QxvaQ3?=
 =?us-ascii?Q?2EKVifNLic2eIfvk38zgojCf4USP7inNsPvDXVpA0lxO9tUCDkGiPH9NBwh4?=
 =?us-ascii?Q?203pDKkuH7MmluHV8iWNsdKKwLKnk53KAQZ3ZupJBrhqxCaJY0lrjSBH4bEp?=
 =?us-ascii?Q?NGQg7+0oQSuydHsSIG/4CskO+QOqEcpWXJdvaVBPZwMh142sTccRaZEp/4mn?=
 =?us-ascii?Q?B7bHsUxr6OS1v8lKDKaey9G7BuDIpzwnhv4KgsJgfV3VjLFwAVr83cEYlOfw?=
 =?us-ascii?Q?ncxwj6S/J2XldL0gBX0jPclvipMgCUwsqI84jbZ+vIqRc/E7QHm93BVaabCO?=
 =?us-ascii?Q?7cCc7mbgtSr4pXT7yBYjTH+C999lP+Z79xvhD00rkBfj8g82s8WpnBFlBIGB?=
 =?us-ascii?Q?vBin9fGJX/FCwnKG8p2XYsClPvXkEfhr5G6r2t9g81M9lBG/QrlfsnkAc7ta?=
 =?us-ascii?Q?W/EBDq/8XFucTL13M5DMGbUWYYGNmnJjYsIqCtc4NOF4NoU9edjjGpix0BQF?=
 =?us-ascii?Q?iCXceW/Ol7Dv5xZu4hA9FtldkXAgqnnh/W8RUgMexXqSucSw3WKS92HQLJxE?=
 =?us-ascii?Q?8jSWxs+jDsknaRxReCnCQSDd2QRavIDdq5mzN2oaoS0+E/Vi9WMIeKvhlIee?=
 =?us-ascii?Q?/lNOZ+ZaxA/JSPn5uUknowVlHlmzvnhHJXTcWclPITRjDd2qcCodSZpK2+9g?=
 =?us-ascii?Q?oI4cq3XhIVLqJdL/dFg2CpIvfvpzStL8Oy9kcZ2f/MSGNNr2T98X/8wAh0Jx?=
 =?us-ascii?Q?Mfm9vMs70pQq2+q5HBO5TyC5zPCBRK5ih6dvRGuZzMh6yPJ9q3eRK5cpa7cu?=
 =?us-ascii?Q?dkThg3qR3azQIW0wR95KhfdNnTKNi9e1iXo9hIyBgQuCezG/V2yol/WYJIe+?=
 =?us-ascii?Q?rb6HXfCmvrkemyHLjPNP9CysA06EXxM7iGCUdXM1PWyB5GdtmygyfBZeIYeI?=
 =?us-ascii?Q?kvLZlryNUeI17O/hEa8KJkCPK3rp/4BbZbwS4nh+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06557c16-e1a3-4bd3-aa70-08dc1e9ac85c
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 18:15:31.7121
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d+Bc3GLLb/RvEp62iho3gPhjaqEl7aBAPKcxx4jrDebV2LuRYno7L8ANf4tcSIJV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8079

Prepare to allow a S1 domain to be attached to a PASID as well. Keep track
of the SSID the domain is using on each master in the
arm_smmu_master_domain.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 15 ++++---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 42 +++++++++++++++----
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  5 ++-
 3 files changed, 43 insertions(+), 19 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 5c50254be4a373..cd0a8c721d9fba 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -47,13 +47,12 @@ arm_smmu_update_s1_domain_cd_entry(struct arm_smmu_domain *smmu_domain)
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
@@ -293,8 +292,8 @@ static void arm_smmu_mm_arch_invalidate_secondary_tlbs(struct mmu_notifier *mn,
 						    smmu_domain);
 	}
 
-	arm_smmu_atc_inv_domain(smmu_domain, mm_get_enqcmd_pasid(mm), start,
-				size);
+	arm_smmu_atc_inv_domain_sva(smmu_domain, mm_get_enqcmd_pasid(mm), start,
+				    size);
 }
 
 static void arm_smmu_mm_release(struct mmu_notifier *mn, struct mm_struct *mm)
@@ -331,7 +330,7 @@ static void arm_smmu_mm_release(struct mmu_notifier *mn, struct mm_struct *mm)
 	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
 
 	arm_smmu_tlb_inv_asid(smmu_domain->smmu, smmu_mn->cd->asid);
-	arm_smmu_atc_inv_domain(smmu_domain, mm_get_enqcmd_pasid(mm), 0, 0);
+	arm_smmu_atc_inv_domain_sva(smmu_domain, mm_get_enqcmd_pasid(mm), 0, 0);
 
 	smmu_mn->cleared = true;
 	mutex_unlock(&sva_lock);
@@ -410,8 +409,8 @@ static void arm_smmu_mmu_notifier_put(struct arm_smmu_mmu_notifier *smmu_mn)
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
index b50e56cc3d9fe2..53b2d2b35a440b 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2019,8 +2019,8 @@ static int arm_smmu_atc_inv_master(struct arm_smmu_master *master)
 	return arm_smmu_cmdq_batch_submit(master->smmu, &cmds);
 }
 
-int arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain, int ssid,
-			    unsigned long iova, size_t size)
+static int __arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain,
+				     ioasid_t ssid, unsigned long iova, size_t size)
 {
 	struct arm_smmu_master_domain *master_domain;
 	int i;
@@ -2048,8 +2048,6 @@ int arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain, int ssid,
 	if (!atomic_read(&smmu_domain->nr_ats_masters))
 		return 0;
 
-	arm_smmu_atc_inv_to_cmd(ssid, iova, size, &cmd);
-
 	cmds.num = 0;
 
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
@@ -2060,6 +2058,16 @@ int arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain, int ssid,
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
@@ -2070,6 +2078,19 @@ int arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain, int ssid,
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
@@ -2091,7 +2112,7 @@ static void arm_smmu_tlb_inv_context(void *cookie)
 		cmd.tlbi.vmid	= smmu_domain->s2_cfg.vmid;
 		arm_smmu_cmdq_issue_cmd_with_sync(smmu, &cmd);
 	}
-	arm_smmu_atc_inv_domain(smmu_domain, IOMMU_NO_PASID, 0, 0);
+	arm_smmu_atc_inv_domain(smmu_domain, 0, 0);
 }
 
 static void __arm_smmu_tlb_inv_range(struct arm_smmu_cmdq_ent *cmd,
@@ -2189,7 +2210,7 @@ static void arm_smmu_tlb_inv_range_domain(unsigned long iova, size_t size,
 	 * Unfortunately, this can't be leaf-only since we may have
 	 * zapped an entire table.
 	 */
-	arm_smmu_atc_inv_domain(smmu_domain, IOMMU_NO_PASID, iova, size);
+	arm_smmu_atc_inv_domain(smmu_domain, iova, size);
 }
 
 void arm_smmu_tlb_inv_range_asid(unsigned long iova, size_t size, int asid,
@@ -2528,7 +2549,8 @@ static void arm_smmu_disable_pasid(struct arm_smmu_master *master)
 
 static struct arm_smmu_master_domain *
 arm_smmu_find_master_domain(struct arm_smmu_domain *smmu_domain,
-			    struct arm_smmu_master *master)
+			    struct arm_smmu_master *master,
+			    ioasid_t ssid)
 {
 	struct arm_smmu_master_domain *master_domain;
 
@@ -2536,7 +2558,8 @@ arm_smmu_find_master_domain(struct arm_smmu_domain *smmu_domain,
 
 	list_for_each_entry(master_domain, &smmu_domain->devices,
 			    devices_elm) {
-		if (master_domain->master == master)
+		if (master_domain->master == master &&
+		    master_domain->ssid == ssid)
 			return master_domain;
 	}
 	return NULL;
@@ -2569,7 +2592,8 @@ static void arm_smmu_remove_master_domain(struct arm_smmu_master *master,
 		return;
 
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
-	master_domain = arm_smmu_find_master_domain(smmu_domain, master);
+	master_domain = arm_smmu_find_master_domain(smmu_domain, master,
+						    IOMMU_NO_PASID);
 	if (master_domain) {
 		list_del(&master_domain->devices_elm);
 		kfree(master_domain);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 742f05df5e8b86..174e9f080066cc 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -738,6 +738,7 @@ struct arm_smmu_domain {
 struct arm_smmu_master_domain {
 	struct list_head devices_elm;
 	struct arm_smmu_master *master;
+	u16 ssid;
 };
 
 static inline struct arm_smmu_domain *to_smmu_domain(struct iommu_domain *dom)
@@ -769,8 +770,8 @@ void arm_smmu_tlb_inv_range_asid(unsigned long iova, size_t size, int asid,
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
2.43.0

