Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2078.outbound.protection.outlook.com [40.107.244.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77782208C5;
	Fri, 26 Jan 2024 18:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706292940; cv=fail; b=V5uyBeP4VMZ462VIfgq6ENQb+krq5zterhkyERe8M4jh/lY84kmphykXE9mLUzrY5oip6fRw5WoRpJ5uSx5DtTkjh7pIdVEv7cEUSM+OTExMr/GbEk+5QS4Zru7qyGO85qoM5BIGOwuYnQNWXRKpAmmVSnuLtxx4Tqg5Zr/7b1k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706292940; c=relaxed/simple;
	bh=GB7oMMIF+h/egXRb2CRUjMvox1GxMdsRl57rlb1ymlE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Zm9bk31qL04364s3xp6a+bCauFURH6JRuZV3tbGQMK3v+pnkn7C/X63gomriOnpjLhxM/DH6VGW9E0ES4BnSh7WSxmiwnZsWOhZkgORuZISCOYHGT5Fq3lqGRvF4DqIb/8SD4EZCW2ncmdSv+gcB3LLQ4bBGOX+Zp4MuXeN6KFE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=CdJWLLD2; arc=fail smtp.client-ip=40.107.244.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="CdJWLLD2"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YWHSTHR7/KCKvd3rZ59xpcFmIfh82oqyHFG7pl/pbYWVqFVW8KjryVuKXK8jtjktgdgiHSVBL5/6RUNUwtc/OjXpymgoaqPPxWPQh5W8r2xp7qh2ti0bvYNFGQkN53lsYeoUZBhbG7fyuGtunW/SYcV3uHSqWPuFdOBoKtYy7gswFRCj11xUqkR3HNm3RWcb/X4HL6Arpeu00VIVA2+ZurkhFyGNfmG99yd3k3XZwchMRH6AqPfq9Js58AQM8+aQa8gcWLqHNxn7MP5nkCeLgi69ao9JYrKwmffBzmOypJiOJGJRjb2TGxXrlrs5zpE8BYO3zjl2jZVeTIXdbm9dqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2DsLic7tyWvi7ro5BGBFjvUVtIfg4r8Z306lbCoOIqg=;
 b=ISQlFxwu5p6WW+3l+QpIGNR1/zK5ST9lmQ0gB1xeHMN9rfjwxmfAv7Cu0BSbhCvvIXb6NNjB73ztOVuznZxomz8dtBS4n4XcULEIvkk+hylQGs9nmoMiaEAJxqvjyO0O6K3RMPTjB+/w73qtRBHIJ7hMYBfwXOfdy/7rh9+fkfOENcd19e8tjQuncZYosaqgZXd04iSfNE3ZFjZjL5BFiIfllBKsCWxbMwU0/Ia6+M9xHnWZMUqQJS0VbMzZmvFJVBZKCh88Tym3P0t9MrN2YUL67jzrMeSINaALZvekhJk9vWlIJJ0rOkfu8uiYjbzTrEcVoJuKKfO0pojDQF2lsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2DsLic7tyWvi7ro5BGBFjvUVtIfg4r8Z306lbCoOIqg=;
 b=CdJWLLD2DBMmoz8SPx3/51jCPVnw00tGdQEwBjRtRN3Dd5wZHO0DTqLs07jJ3WT4kXSNlHsm0jlzzz2lUOJTjN7lyz5G9dnvkIZs7P0FMy1ZdeEyhK5G4K4gpzfQzwzH3u1tfAGnuHW72gXymLU+0yV8PqXP7u+EFGBcR28WEE2+OeUwVzeR95RyyodF2pZ0B6rShm+HsSJbXhTmYyo5JAWfiREcJlPZzTKra0y+4NbMvjvuv/3UYz79mQy2si5my/o0pSDwbUi8TOzUKpLggEqiabi3jTgutxqfHwXDdhG+rUaGM75VPgPE9fy7pD/HjBMAqj69OEQ8PuTWggyp0A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA1PR12MB8079.namprd12.prod.outlook.com (2603:10b6:208:3fb::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.22; Fri, 26 Jan
 2024 18:15:31 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7228.022; Fri, 26 Jan 2024
 18:15:31 +0000
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
Subject: [PATCH v4 06/27] iommu/arm-smmu-v3: Consolidate clearing a CD table entry
Date: Fri, 26 Jan 2024 14:15:08 -0400
Message-ID: <6-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN6PR16CA0053.namprd16.prod.outlook.com
 (2603:10b6:805:ca::30) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB8079:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c8df419-2315-4bac-1623-08dc1e9ac815
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	cBuPAQ5gBkgzr+gSeMwnQ7+MkwSHhr+ZNsPtQcGdXPjB4GdVK/j+s2Ep15zvxF1wMbcedhgoJREWniMVaAdIW0fdo8qSAumkDiITLN6kSRFZgS9F2bM2miAnP8RiqQibRPQVarsShxj2/6HHrKVSsIONkaOa7nqmf41KsoQGsalyjAAIKasx2h5JDW7WfZLnx6nBr5+i0tOd0NIhs23zYKyzEIfb99EN8Ig/HhewQozsXS2rqB0USWg1uWPg5E/VZN+rF3uSaMiSBGZ4jgW1teUW1gXCmhdtGxhWlcg9LqJzcpI+6MnjMVySZ/MWX0Rl0qdh/RdZkgKSLmc1ue4pABFE+XkZwPqksnR7BEhivIyRwUVAGVxs2Jssb9YV5AZG7nzwDeBS9hzJMZ+D8QqUjZus0C2+5fRwndXvwtzY0Zja0faf4XWc06UDA2VJWE7LlIjBRIj9yfegCpuDkRgSsEOF1/SwdcGqEwMYttVWMg8uZ0YUqOFxtNjpPbqtEJb5T0GGqaSJ6J+Id8CJfMz79y6Qd7XFZ2YRWLKa4nOHVlW+L5W/iFAn1Pa8cVSpQp3XvIZIrc5S1a/AiOz00tTVx4ZxCfpzVtFgDmlg33Hn4Gg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(136003)(39860400002)(376002)(396003)(366004)(230922051799003)(1800799012)(451199024)(64100799003)(186009)(83380400001)(6486002)(6512007)(38100700002)(54906003)(2616005)(5660300002)(8936002)(478600001)(2906002)(8676002)(4326008)(7416002)(110136005)(6666004)(6506007)(316002)(66476007)(66556008)(66946007)(36756003)(26005)(86362001)(41300700001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?iGQnARit2RXem3m9NcDaSt3xBlK4FO+d+2GecKN1xkKCku6sUA3nxvvj9V/a?=
 =?us-ascii?Q?6HcYhOClKBiAd5UfaoAT3/oN/hF1tTmAniIBWb8NuAKhUi/ewMMoBpiOmNJR?=
 =?us-ascii?Q?6WPosGJYajwqYYkQzm/R4UAXiMDVoQqvddUazTmQHpcnehA+no55HZWeruVG?=
 =?us-ascii?Q?nj2Z6rxb0X+Zl7qn3krki0ueF670GDi2CmZZfiYN00g00vwnuNrxZJfwPKAx?=
 =?us-ascii?Q?AaeQhBiU6f85O+2DoydGqjDzl6MTYIJzv6B40hzNhxHuTrpJKiS8DIAtazpE?=
 =?us-ascii?Q?WlDM1ka3IKl+Ljw+tn5xZ99xw39PuKr2mlpSJj0vHAVp0FfzjTabCOYJEqJJ?=
 =?us-ascii?Q?+aMMSq1HDT1dDw2kDo/gYlabkr57H70N3t/Tf8X7FiQpu5p+UBR1CQS6pDob?=
 =?us-ascii?Q?pEmemaorOyo8Qx5k2G41A5NsRcJuVd2kYUmy8vzlIzIfQc+WeB4WGhsX4iw/?=
 =?us-ascii?Q?CSZWVc5aC0bHxSJyVhNBJO9mdix1o68xcxbOZiCfEPJ6gX1P2d8vEgjEBXfO?=
 =?us-ascii?Q?Xj8IdlCAAr2XLniyVFnEfmICMpfN12XvEA/PYynlledoBfFLoXlWUxwh8GP1?=
 =?us-ascii?Q?G0OAgp+rvzDqQ8sxkbas2Fok8FsLFkwoAp5A8HU58BVhWowaRY2okfRK9APQ?=
 =?us-ascii?Q?VVQq2jWYiLtrLhK2TeJ1vnqRDoOEjACSqr3iFm8EYGbteuPx/8o+C9mWALeG?=
 =?us-ascii?Q?gR1kzJfXIYXFkXDlwwaDS9t7e4jlBAS5s0EYdaaaLAdwXVIEkdIvLfD+5tZP?=
 =?us-ascii?Q?BMddIt+gdAC7bbJX21k4zQZF0CdNOCCKlaUjadb8JUtPKGs9q7qLF3hNv+sJ?=
 =?us-ascii?Q?NIGaAoJ1mWTFVIRHpAUGQ+fL1Hgz5NsSPB+R5VGP69gNVTJRPT00BO+AMFE3?=
 =?us-ascii?Q?joJ3g0s7EiofMkvrXRM2nEIzTQ2tIBpTw5LHGar4BFgV0xDYn+fpWteEv1V1?=
 =?us-ascii?Q?vLgOKKB7d8DWfy4ZmWdWB/YdOibbcrTnFzb439+WL2A9mXFmao5tw4DQ17ZK?=
 =?us-ascii?Q?pF0yti8P43i3LwzJxX7yGjaO7vvk0/C7ph7slpihv7dn+c2K1LYRYlzic090?=
 =?us-ascii?Q?OkfyylF1u2YJ9/LiRYGl3iRw1bE85D7AUc9qloBWoXeVIJWWNhLxK1splpbI?=
 =?us-ascii?Q?G9cMfhYEbOU6ztxMZixBVQCZgutagb93FGSAZ6gSCoT8lnPog1Ss7DmgJf3r?=
 =?us-ascii?Q?CamVcsT2JeGOGmeq3ub3BUoIkz9WiLyYcezt3/FlwONyO0nshtMOTFhEvPdG?=
 =?us-ascii?Q?pk9rDZunxfesE8ZFeMKM444xHWmTK4bE1Yt4+wwhikJIrOiV6IQ46VGJ6fyI?=
 =?us-ascii?Q?44J4S0vJJw/t7CoP45g+iOfDb9bPgygy3u5XQCuE9LDQ3g7vqee+n8DGhMUw?=
 =?us-ascii?Q?EAG/38cD7ol65HIvX3/rZ9JBNl8CxVR5goBGxJ+I+ieOWIiF/hVCfoKfA1pV?=
 =?us-ascii?Q?iEs2qLQbO5Z/P8X2JVo9Yw+uM1QRRVqpbm5u1BtvokjSmGVcq8r4vBIGWgCr?=
 =?us-ascii?Q?aDSGBLkpPWI3HtKUUDoamdfZja3KZTmxJm4s6yxvINlI4ntmqtg5fuRrUdhZ?=
 =?us-ascii?Q?WlD+L6qK+qOlGQc0w6bleNy9Jld5LGXRu1/xQolQ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c8df419-2315-4bac-1623-08dc1e9ac815
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 18:15:31.1511
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZgW2wtJ2QgmMw87SAawjSNqFA74QLQZXLvN+aaPf/KS3U/Rsug9noq32AtvcUs6k
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8079

A cleared entry is all 0's. Make arm_smmu_clear_cd() do this sequence.

If we are clearing an entry and for some reason it is not already
allocated in the CD table then something has gone wrong.

Move the two SVA flows that clear the CD to this interface.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 12 +++++++----
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 20 ++++++++++++++-----
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  2 ++
 3 files changed, 25 insertions(+), 9 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 556aa832c63f15..3eb32b9d4a72a3 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -332,8 +332,8 @@ arm_smmu_mmu_notifier_get(struct arm_smmu_domain *smmu_domain,
 		if (ret) {
 			list_for_each_entry_from_reverse(
 				master, &smmu_domain->devices, domain_head)
-				arm_smmu_write_ctx_desc(
-					master, mm_get_enqcmd_pasid(mm), NULL);
+				arm_smmu_clear_cd(master,
+						  mm_get_enqcmd_pasid(mm));
 			break;
 		}
 	}
@@ -357,14 +357,18 @@ static void arm_smmu_mmu_notifier_put(struct arm_smmu_mmu_notifier *smmu_mn)
 	struct mm_struct *mm = smmu_mn->mn.mm;
 	struct arm_smmu_ctx_desc *cd = smmu_mn->cd;
 	struct arm_smmu_domain *smmu_domain = smmu_mn->domain;
+	struct arm_smmu_master *master;
+	unsigned long flags;
 
 	if (!refcount_dec_and_test(&smmu_mn->refs))
 		return;
 
 	list_del(&smmu_mn->list);
 
-	arm_smmu_update_ctx_desc_devices(smmu_domain, mm_get_enqcmd_pasid(mm),
-					 NULL);
+	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
+	list_for_each_entry(master, &smmu_domain->devices, domain_head)
+		arm_smmu_clear_cd(master, mm_get_enqcmd_pasid(mm));
+	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
 
 	/*
 	 * If we went through clear(), we've already invalidated, and no
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index faa60827d72726..ada4e85b1917fa 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1263,6 +1263,19 @@ static void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
 	arm_smmu_write_entry(&cd_writer.writer, cdptr->data, target->data);
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
@@ -2691,9 +2704,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	case ARM_SMMU_DOMAIN_S2:
 		arm_smmu_make_s2_domain_ste(&target, master, smmu_domain);
 		arm_smmu_install_ste_for_dev(master, &target);
-		if (master->cd_table.cdtab)
-			arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID,
-						      NULL);
+		arm_smmu_clear_cd(master, IOMMU_NO_PASID);
 		break;
 	}
 
@@ -2741,8 +2752,7 @@ static int arm_smmu_attach_dev_ste(struct device *dev,
 	 * arm_smmu_domain->devices to avoid races updating the same context
 	 * descriptor from arm_smmu_share_asid().
 	 */
-	if (master->cd_table.cdtab)
-		arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID, NULL);
+	arm_smmu_clear_cd(master, IOMMU_NO_PASID);
 	return 0;
 }
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 7078ed569fd4d3..1b4104e9cec3d6 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -749,6 +749,8 @@ extern struct xarray arm_smmu_asid_xa;
 extern struct mutex arm_smmu_asid_lock;
 extern struct arm_smmu_ctx_desc quiet_cd;
 
+void arm_smmu_clear_cd(struct arm_smmu_master *master, int ssid);
+
 int arm_smmu_write_ctx_desc(struct arm_smmu_master *smmu_master, int ssid,
 			    struct arm_smmu_ctx_desc *cd);
 void arm_smmu_tlb_inv_asid(struct arm_smmu_device *smmu, u16 asid);
-- 
2.43.0

