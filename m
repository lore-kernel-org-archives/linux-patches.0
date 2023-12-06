Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2072.outbound.protection.outlook.com [40.107.223.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2477697BF;
	Wed,  6 Dec 2023 17:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ncK6+3mY"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=asXIw4RT5rvlezIO3i2GnBW1L6Lr0fKxd1xE3CLel8vGvb7pXD3Yq6erMHJOgxtqc+X2xD7yDXvM/X2ocFAvdy/sKq2hBGLTpscAUAt839gcBm5X30jOAlvW3j781wNw/qaLuCMX01G0B1FgekuBt1ZOpDt4R2AuO8/Nx9Mzw/H9auLrb/VNVO+h2LjhjMVqU0LT0uyH6UJsJ11ophQif31Xz2rbRjIokBfGWNJPI/+DyZlOWqrSimPc2jCuYfslik5KRAqKxqRYGdaV/h54bHjPIgMkTA6g1NvMtETS6gec9glKJNXQIHQHT3Jt3aQz+vc9NQB44hhrtX0NYmuqpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4gwelGD56wJhfomawNHVmawSMgQOAg08hMp+ta9/3K0=;
 b=Sjo7liyRaNiE3a0q500LJkzvcRsCn7Ev7inEmuDLDpweVDyqxnAb3dW+Yq+o6tnJM8mQt4uQKxln4O63zdVQATDqN34ZUme4sSMCylRBs5cJ55Pmve27N1Ecu7+1a/G1HdhKqCAhY5fZPuC6Q/x3hxDlWBLipPCKDl5V6oriqBCOjfq+hWPA6pDBFC5+b2IODiI05WppS2IUPFTXXxsI2jyK5dWDYNamAwlTVDGBz5aDpfVLI0CwkqTDBIyXt4dDeUPswN7ZC6gaTBevjQW2OA+rF9CpNY2ywfmzoSR/2t51Zv22eTwnwAMrs3tSqRVQj8pHNf0DjWridGMDd5hVCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4gwelGD56wJhfomawNHVmawSMgQOAg08hMp+ta9/3K0=;
 b=ncK6+3mYiITzzvcOaPWaqnoOozUDZFbmh5724IvdQTJxcvuhGWGkBwTDQfOeCoZ7CSPvEEVlOYho1/Xb6p4z9WoWhRgXGcUOnhpC6eXgrMPz+aWfl/ILhEL2lwpAU/by0ITXnD9Yb8HlvNKoNMPqGRNphQpTIUChLjsfX4wRh3wkS/SIoEmRwE3K0ErLHFalVOtJB8GgS2R3qv4cKjglpJFVNONELcUXMswNrLw5bf2ideFyhGKKHWzSnvtGiztpblAe+r26ksgC2/JIfFXgHSmSzUOszn+azKqH2Wce6e+phMms7RANKOghxAkIZotj4Qa0XRVmy9i6wmk5QQ1zDA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA1PR12MB8360.namprd12.prod.outlook.com (2603:10b6:208:3d8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Wed, 6 Dec
 2023 17:28:45 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.034; Wed, 6 Dec 2023
 17:28:45 +0000
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
Subject: [PATCH v3 07/27] iommu/arm-smmu-v3: Move the CD generation for S1 domains into a function
Date: Wed,  6 Dec 2023 13:28:13 -0400
Message-ID: <7-v3-9083a9368a5c+23fb-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v3-9083a9368a5c+23fb-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR1501CA0023.namprd15.prod.outlook.com
 (2603:10b6:207:17::36) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB8360:EE_
X-MS-Office365-Filtering-Correlation-Id: e8a96e6b-088f-4ef8-3a15-08dbf680c762
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	tHlHwwJk1TARexUHbaKuoL5xFVygfInj0P35hRBjrOpEOLcMXfPK+TxbquZh+FPQaUK8lPx1DNU8wSaAek2xnzFvPKCBF30RMyXKynnU6EpA6mhMmfBC9ZeIyJvvMgc84qHTRkA5QcifCWlW8T/axau9WH3ZoafJJAvK9TfrVWbS4n3VVNLInhY47PSS9pGM6eMb4AUJg0LlUk1P6B+m3XTY+HZQXu8qMnGTEhcgVrNntmkeg/B0NwIf3yR2KBqvJzQM9KVu7YZIJmZ28t3NNnpB8TmqtFPyQGrmz0UpjRvuD3x++QNHT8c88u6oLldLuLlshAmabck6z734eNabC3r0js6DybwTnxpaagyTw9vv4WU7vbgoFle+KdLL+FnxSQuWNsgszfV0MrWNtZ8t+vZKnuhTPT1Bvl1hx24gXj/7BtzSoJz09837f1JOQZv7qu6viRDVkIJ+nvR83MErGfAnPVaFr8rbJu0lbtWO2dYpsCONpXSG0MtmNcvBjyTzWoQVCXAjWdK6jKKCWwwPo3b1JCqazthDgKiTniFhrgWb9RPsi9auM5759n7+wF4OKMzoxH6LTYMmAa7PLVRz2iKFqVg60J7dn9ZXqhnapMLmZMw1f8zUcE+5B5mltUhjTY9XZ49yzAoWORf/XBn4ag==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(376002)(136003)(366004)(396003)(230922051799003)(186009)(64100799003)(1800799012)(451199024)(6666004)(6486002)(478600001)(38100700002)(83380400001)(66946007)(6512007)(2616005)(66476007)(6506007)(8676002)(2906002)(4326008)(54906003)(7416002)(5660300002)(86362001)(36756003)(41300700001)(66556008)(8936002)(316002)(110136005)(26005)(4216001)(473944003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JSFrOeLNXuSaaq0MsODFtEUZEGEzuuhHyG/qSxv76kLg1Pl5vTVgM96U45ik?=
 =?us-ascii?Q?SB+JJqlxmQrxtwUefi+f34JjVTYht3RJ3a433LIS/Ok9Jlv7ccpQHgSx4JGb?=
 =?us-ascii?Q?pLc5xzGAudm2qP7fwZIL2XDZAKTvZQ4tg67wFXQyTFtkPxF2ZgDj+Yj184Mz?=
 =?us-ascii?Q?qldckfjE4xJBf3quo2dC+6UO+b+miwrUxmxNA6P16BfuT2U7a4Y8rJ7qNDeL?=
 =?us-ascii?Q?MYwRW6zEfyVAnT4XzIpxNfCz2XhQnSCGLzcaDLrvh8HOfdBjJY5GggNgTsDO?=
 =?us-ascii?Q?ftVyxkM1Qu+2VQQF8cjlWO/oo/RhHU/UOVGL063EOksRZWLoAH+jkeaHYTaD?=
 =?us-ascii?Q?Ex/Ymm4KXSLJ1eCsQE4VAEJigS5MpLgusnLnUX2cyxCKTpipVDcYyG6y6OSQ?=
 =?us-ascii?Q?TPYAiYj2CnXOMMVsFixkB/Ui0JP9+c4RQ6xUpTrdO0zN4ct3zuLkLKaFOPyV?=
 =?us-ascii?Q?2UFgsHOhpP0r60xlf4O9lx89TpJ/wxFoY664AnNe0U4fZTa9Y+8MoEWGJZab?=
 =?us-ascii?Q?XsqYspEVPW54PbTJBhIrHPZSrCMfMnvAJ1wM1441g4lI6Zhezj10Exa3E71x?=
 =?us-ascii?Q?lriZpZJryjcPyZHD/FGSrQvGVmmIvDvzruW6iGZjWMZbMer9nMzgmX33LDdI?=
 =?us-ascii?Q?wG9t4VrL8AQNgtahk2yT2m3A0LGCYGBJQNA6M8vTrEq0uaAhrgA9ebIZ5fVa?=
 =?us-ascii?Q?lOm8KQFfvrDwYp7azoBeLiACx5oMPf/STzkb80tFyY70wBdhyKUyv+HPGyZq?=
 =?us-ascii?Q?b41mSvdpYXOX4NiKMWBp+quQQsEM1u2ay9HOPGGKWg8OXkZDzR2gIHjEC87O?=
 =?us-ascii?Q?KBQt1hteJbOY/LFXamsR4rXQM6PwhL51sbcFJq5tjpaPSOsg3UXibxqpKRNI?=
 =?us-ascii?Q?XUeuXzFw3yLGOVmeA2XVrJGtQWKTKdpKsVbagKvN5Mh9M/nTfzdI9Gpv15In?=
 =?us-ascii?Q?wY7OeTtYqNEIV1dotuWxstZmNFaCTQFjudhAZRxk5HZyXe9FtoCbq51OmShE?=
 =?us-ascii?Q?DnIZkxrRptTSA7b6FO37ZV//SykhDH9mlhzzM2VKQv4NweEbkiAHu6TERQeH?=
 =?us-ascii?Q?0yJBKCopyKReuaeFBEUqd3CZ8yIVBRePfw5RYPI7VhBjW3mVeN42sbPFDjY1?=
 =?us-ascii?Q?XAoYkUJyaRgrDqXce/MxHK/00JR43Mplet/IOdQNmra8TcJXVTZavJv0UOjz?=
 =?us-ascii?Q?J1JVIyOHe5h5DdwtUorCznZHftJbGfFe0saFcDgTAs+71la+Q9+4DhKcU28C?=
 =?us-ascii?Q?KxQr0oDUzD4cMaeDKDq33ByV5ozffzkJ4ewSwNNEYa7JzcjHbJPSy2yWx/9b?=
 =?us-ascii?Q?ZaRT5Kd7ZNHmkA9crwCZp2kWKL8OzhHiccjV+l0PFybEKWsbbHOsvC7wtPCb?=
 =?us-ascii?Q?DoYR5r9Kqfw+Hu6HUZNkH1tWJfPqMR9W72VbTlJRaVYuoMnaCHYxoWKUaEbS?=
 =?us-ascii?Q?FxoTaVlD+FheFYA5mD6QCLsyrlipE6Ji09KJhm8yQP+scwIM3izm37pieiLh?=
 =?us-ascii?Q?gEWDEPIf9EQkPggWLGsFVldCemzHp/A7Q1gSXCli9rohrdDWwN55L5fl/C/T?=
 =?us-ascii?Q?vjrVH3n4UX+oxGnfKOuxTZDSzV6BCRxTUFQdgdwL?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8a96e6b-088f-4ef8-3a15-08dbf680c762
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2023 17:28:36.5805
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x1HieTRDTTS6NKfkqSO+Evsl6yh+0kWfMBcuLTyYmVNuSQGpgZUb64aFui/4N2om
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8360

Introduce arm_smmu_make_s1_cd() to build the CD from the paging S1 domain,
and reorganize all the places programming S1 domain CD table entries to
call it.

Split arm_smmu_update_s1_domain_cd_entry() from
arm_smmu_update_ctx_desc_devices() so that the S1 path has its own call
chain separate from the unrelated SVA path.

arm_smmu_update_s1_domain_cd_entry() only works on S1 domains
attached to RIDs and refreshes all their CDs.

Remove the forced clear of the CD during S1 domain attach,
arm_smmu_write_cd_entry() will do this automatically if necessary.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 25 +++++++-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 60 +++++++++++++------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  8 +++
 3 files changed, 75 insertions(+), 18 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 521bfa18879f90..04a807774402b2 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -54,6 +54,29 @@ static void arm_smmu_update_ctx_desc_devices(struct arm_smmu_domain *smmu_domain
 	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
 }
 
+static void
+arm_smmu_update_s1_domain_cd_entry(struct arm_smmu_domain *smmu_domain)
+{
+	struct arm_smmu_master *master;
+	struct arm_smmu_cd target_cd;
+	unsigned long flags;
+
+	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
+	list_for_each_entry(master, &smmu_domain->devices, domain_head) {
+		struct arm_smmu_cd *cdptr;
+
+		/* S1 domains only support RID attachment right now */
+		cdptr = arm_smmu_get_cd_ptr(master, IOMMU_NO_PASID);
+		if (WARN_ON(!cdptr))
+			continue;
+
+		arm_smmu_make_s1_cd(&target_cd, master, smmu_domain);
+		arm_smmu_write_cd_entry(master, IOMMU_NO_PASID, cdptr,
+					&target_cd);
+	}
+	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
+}
+
 /*
  * Check if the CPU ASID is available on the SMMU side. If a private context
  * descriptor is using it, try to replace it.
@@ -97,7 +120,7 @@ arm_smmu_share_asid(struct mm_struct *mm, u16 asid)
 	 * be some overlap between use of both ASIDs, until we invalidate the
 	 * TLB.
 	 */
-	arm_smmu_update_ctx_desc_devices(smmu_domain, IOMMU_NO_PASID, cd);
+	arm_smmu_update_s1_domain_cd_entry(smmu_domain);
 
 	/* Invalidate TLB entries previously associated with that context */
 	arm_smmu_tlb_inv_asid(smmu, asid);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 7fcd578b762afe..696f837015771f 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1118,8 +1118,8 @@ static void arm_smmu_write_cd_l1_desc(__le64 *dst,
 	WRITE_ONCE(*dst, cpu_to_le64(val));
 }
 
-static struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
-					       u32 ssid)
+struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
+					u32 ssid)
 {
 	__le64 *l1ptr;
 	unsigned int idx;
@@ -1181,9 +1181,9 @@ static bool arm_smmu_write_cd_step(struct arm_smmu_cd *cur,
 
 }
 
-static void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
-				    struct arm_smmu_cd *cdptr,
-				    const struct arm_smmu_cd *target)
+void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
+			     struct arm_smmu_cd *cdptr,
+			     const struct arm_smmu_cd *target)
 {
 	struct arm_smmu_cd target_used;
 
@@ -1195,6 +1195,32 @@ static void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
 	}
 }
 
+void arm_smmu_make_s1_cd(struct arm_smmu_cd *target,
+			 struct arm_smmu_master *master,
+			 struct arm_smmu_domain *smmu_domain)
+{
+	struct arm_smmu_ctx_desc *cd = &smmu_domain->cd;
+
+	memset(target, 0, sizeof(*target));
+
+	target->data[0] = cpu_to_le64(
+		cd->tcr |
+#ifdef __BIG_ENDIAN
+		CTXDESC_CD_0_ENDI |
+#endif
+		CTXDESC_CD_0_V |
+		CTXDESC_CD_0_AA64 |
+		(master->stall_enabled ? CTXDESC_CD_0_S : 0) |
+		CTXDESC_CD_0_R |
+		CTXDESC_CD_0_A |
+		CTXDESC_CD_0_ASET |
+		FIELD_PREP(CTXDESC_CD_0_ASID, cd->asid)
+		);
+
+	target->data[1] = cpu_to_le64(cd->ttbr & CTXDESC_CD_1_TTB0_MASK);
+	target->data[3] = cpu_to_le64(cd->mair);
+}
+
 void arm_smmu_clear_cd(struct arm_smmu_master *master, int ssid)
 {
 	struct arm_smmu_cd target = {};
@@ -2609,29 +2635,29 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
 
 	switch (smmu_domain->stage) {
-	case ARM_SMMU_DOMAIN_S1:
+	case ARM_SMMU_DOMAIN_S1: {
+		struct arm_smmu_cd target_cd;
+		struct arm_smmu_cd *cdptr;
+
 		if (!master->cd_table.cdtab) {
 			ret = arm_smmu_alloc_cd_tables(master);
 			if (ret)
 				goto out_list_del;
-		} else {
-			/*
-			 * arm_smmu_write_ctx_desc() relies on the entry being
-			 * invalid to work, clear any existing entry.
-			 */
-			ret = arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID,
-						      NULL);
-			if (ret)
-				goto out_list_del;
 		}
 
-		ret = arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID, &smmu_domain->cd);
-		if (ret)
+		cdptr = arm_smmu_get_cd_ptr(master, IOMMU_NO_PASID);
+		if (!cdptr) {
+			ret = -ENOMEM;
 			goto out_list_del;
+		}
 
+		arm_smmu_make_s1_cd(&target_cd, master, smmu_domain);
+		arm_smmu_write_cd_entry(master, IOMMU_NO_PASID, cdptr,
+					&target_cd);
 		arm_smmu_make_cdtable_ste(&target, master, &master->cd_table);
 		arm_smmu_install_ste_for_dev(master, &target);
 		break;
+	}
 	case ARM_SMMU_DOMAIN_S2:
 		arm_smmu_make_s2_domain_ste(&target, master, smmu_domain);
 		arm_smmu_install_ste_for_dev(master, &target);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index a8e7574ab8e154..950f5a08acda6d 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -764,6 +764,14 @@ extern struct mutex arm_smmu_asid_lock;
 extern struct arm_smmu_ctx_desc quiet_cd;
 
 void arm_smmu_clear_cd(struct arm_smmu_master *master, int ssid);
+struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
+					u32 ssid);
+void arm_smmu_make_s1_cd(struct arm_smmu_cd *target,
+			 struct arm_smmu_master *master,
+			 struct arm_smmu_domain *smmu_domain);
+void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
+			     struct arm_smmu_cd *cdptr,
+			     const struct arm_smmu_cd *target);
 
 int arm_smmu_write_ctx_desc(struct arm_smmu_master *smmu_master, int ssid,
 			    struct arm_smmu_ctx_desc *cd);
-- 
2.43.0

