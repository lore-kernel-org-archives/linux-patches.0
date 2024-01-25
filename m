Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3193A1862E;
	Thu, 25 Jan 2024 23:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706227056; cv=fail; b=ff7IRgRb54Tv3JghAmETDip4w228MGshhR5dYa/CfQaq89ZI1/5LOAO3ROCo22Do1H4l3Ce6yh1+l2bB3wXaN6GYLLnjacj64Z6VOG++qF0qv3aQIyRlA3mS4NDZix24Bv8xzzTkdfyMcjtMOSmGuuWU+cso+spefzwjkvT/KHU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706227056; c=relaxed/simple;
	bh=IYRbPA8d/gZqG4fCwOx+1aTis2Uu1nxZQ9AREDc1CQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OiraaJvIn3uHM0sQ2mb/1OE2ocOU4l5E5wp2aZCb7Fgt16rPIw9naiLQihD1h2pACSuiThD10ACb3VP9bbtx2zKajxA/PGGOhkD0tIT60dFYvClJ+OoNN1jW6ItubAQoKQ9HdCWyuWZfvbBkTQ32FmLm2qJmshMUQjr7u6ctMgM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=B3suX4cH; arc=fail smtp.client-ip=40.107.236.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="B3suX4cH"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fqBqsSbNBIDdFZ3FXgWjcPdJKGtCZRfCbI7Bg/EEPDXm7icWqHKP/wfcWnILedcCMwW2kJBh+cvuWiBunHlXd8P8zWE+F5I/nxgT4PhhbZpVPfbVDWiU6QILjuY8tMgcyy/qW2EzDzVX5GBP2ngY6hVpcQuwmt4gf6ww9QYcqr7KXcnEOfeomQsqypa9lJQ2QxeLV7A45zOdNo+hJ2rZ6gaRfwoCfNba1NuoIWQ7kclRPqLfTa/v0LI/pGLQi4ql0ls4Ugt1NobCM4UAD1PqH0ItkykSkYt/ka6yynpL4xEqD0s8nVCVnSqHXxxhXbSD8P/Ca+hp8uCsX5YT+8KbEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pXGeQI5buSb+MrqJunH7QfqXk/GRkxUdOsZKDbiVdKY=;
 b=AL+TwE6jONHXky/7w8QEZXV11ox0TJt/eBAYABDC/5hFxRPTzxVmc3F/LqC8PXtODATC8vh1ExPbG3JGYYv9sfa70Qlkky7q6T+/8+Qy6Dzlc384e+goxLV5oDKbrP7muQaNi83xaUlhSJmsV0NN18LHvHtwhlqwKM7hMeVAGrPMJNfk3vEigycbbaxfonWo836OOClVOjdlWnRi6wSUr/YsXkBqSkZzF7CnXeBu3nY1PXdxs6bcycRslIhtneI9+90t/X919VTyIv6mqVX8ZVMi35NaPzOGQR1BLHp1valZ9rX7/kEXAhN8HLhP8ICZGItHQ6pwgoFEkHAFy2rdwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pXGeQI5buSb+MrqJunH7QfqXk/GRkxUdOsZKDbiVdKY=;
 b=B3suX4cHAqh8u5g2POgUJZahQloQXQ87mVS0eLwRo4z+aSIMsaS1Rd1Pk5QUCYsqrNAP2xnsroTEdcNMIPixTXHGFZNm4ZAedl4QS7H+SZT60M8KLeNg3k7kq/ADMLbq1B+FdnLDfnWYWtbgR/0OKurHsl7Ggi1ap/pk5Ix8vIyAroyPLvfr4YwpNBDscZSSj8bcRHeomICIycl+YjDDPQPaiLrEIRW3ZZ4dk6IngQH/7K/Sb5uxC+NzEjBK42PxMVZlBjsWgjB3W56XvEEdyZYtvZB1t9ExFDbrmDaenhA2HA0hVV71wKmSOuac2GoUgUqQ6sERu6APSTy2ZvnSJw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA1PR12MB7038.namprd12.prod.outlook.com (2603:10b6:806:24d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.22; Thu, 25 Jan
 2024 23:57:29 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7228.022; Thu, 25 Jan 2024
 23:57:29 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH v4 05/16] iommu/arm-smmu-v3: Build the whole STE in arm_smmu_make_s2_domain_ste()
Date: Thu, 25 Jan 2024 19:57:15 -0400
Message-ID: <5-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>
In-Reply-To: <0-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0501CA0064.namprd05.prod.outlook.com
 (2603:10b6:803:41::41) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA1PR12MB7038:EE_
X-MS-Office365-Filtering-Correlation-Id: edbcea7f-332d-4139-4cc6-08dc1e0162e0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	+Do72n7+yZbBpAUT61QHsrITQ2u1r177HaFPsOoC0cp43wwC3pLlkUQM980NKC7V6sxbr47yhdXOpx7aU/2J0Q9iBrjveRUImtfmgJ5yP0Yf8IPej2vIDIMOk012/3Fbr6EMwB2xxZZkT6dyZAbl9DxRrouiRPD3k2eQHaVkwJxLqRQY4WPMryJuSH+NPwgnJYtyZ/JzAolRebDooFpN5msB+CW6AZtVn3oCsdqXRPP+0ajlZ71xOlU8xaP0QAgdoGvZ00gQ7tGO2/QY6IwHRTBava3Ggk9BlA+gE7JzUdQ8XEuvhUIbY1mor7k1IZfUayhieM5GR3RVbpRC4lofkJV0+wlQZrXX0sGPYeIZY2lssIa1Qnl2VkaxbclgOaeXEO0ClBMXs5JHB41os+r2yJ+1lW61LuEpxGcp6Y+4kPBwP8j65cH8yCqzN26YP+CdiNfDf/qlTinliNi4ddimiI6MBVmIcFa97eXfH8TJFpRInvJoFCukKWmx1ajtyOn/7jIivqP/cdOqTAVI0WrE50zbR9XDye4lB1IpejW5V7TKyAR4n+8fDU5BQonHwxAI91xCXkUuLlukm0Usj83ZKOP5q0mDvUbsNghJHgtBVkk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(39860400002)(136003)(396003)(366004)(230922051799003)(451199024)(64100799003)(1800799012)(186009)(66556008)(54906003)(66476007)(5660300002)(316002)(66946007)(8676002)(26005)(6666004)(4326008)(8936002)(2616005)(110136005)(7416002)(6512007)(83380400001)(2906002)(6506007)(478600001)(86362001)(36756003)(41300700001)(38100700002)(6486002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MKH9U1BIVlGoY2T+RHpeZncmuwjHCfn4gMh0ryhKVap0VpPgifTF0q3ec9Wf?=
 =?us-ascii?Q?Lo1siE+z7CeSuR3JjmfyYhoqehSzpfOpeVO7DYR7qg2R1kOdpAQusoxDYTfG?=
 =?us-ascii?Q?RA7/4kgxPlb5SRTWHFVER+EJ/frggF3rqdtgr9PhhfS2FlAAcRfukZAB11zn?=
 =?us-ascii?Q?VtfCoB5rEYzKxS9H9GTlnG7SohivsSjV19rsNsmYIhI84ou7FWucKQMhy7f4?=
 =?us-ascii?Q?S2/5co/7igaT1JNpefa9JeGQ7EXgxc+2cWuy0YKYWf62foK5KZbMKeSztKgV?=
 =?us-ascii?Q?0N2DIrgOp9ftrNJR++DAVBxyNBXfkOlCnhBECJr/EiK2G4EgTrBgZkiBYVNS?=
 =?us-ascii?Q?Y693KX/+7fJZ2C26kYJ0v/xU+V0TvXO/CTnAsNrhHjSraNZNO7mEaTb1p7oG?=
 =?us-ascii?Q?0ZsIc4b9xCi8WwpnTD43Qukvpo9CJGBp6HHafDrX0GbluGtil2iiffOobaxz?=
 =?us-ascii?Q?ybUGHVG2CnkS4npK7hEy0v5fZuRl/7c/LmV5xe3OuJ/UTt69yAgt6HTORg1p?=
 =?us-ascii?Q?qF80P8PQ52jsgxhQPRhjLuCAJN0LmtfVGJvNBt5a7V6CrTR4lRysq48+K9nh?=
 =?us-ascii?Q?j6B1bdcAHi9t2FjRE0ZZIWi7UYVu96AijaALxkCOQa48FIw9cM64RNGkbZlH?=
 =?us-ascii?Q?M/g3ON3sm7/YMB8nP3+oe7jRKf804FbM1e05s2hJR9mrUGLK2xGoryYQ5rBD?=
 =?us-ascii?Q?TPcoS4VVMtyM8NZUrfKmpFw1A9lRfjz35wcUnZ5NjxWGJA58jDlAR+qqcVzw?=
 =?us-ascii?Q?TFrdNsbSh2mIWded2b+P6wX5cX1iiQyY0I3u+/8P9XMNwXXvjVxJvksYWwPY?=
 =?us-ascii?Q?TvjFMu7lXdvmxdAQPu36VMP93s5jz4f8kzyVkzPq7ze7GAclzDZlgFipAF1A?=
 =?us-ascii?Q?YsXa6JTwcVZiZtyJu+NXYrZ9GtgvnYC8nmUymH2CgYCb8XyzKVQZ76rGUsKJ?=
 =?us-ascii?Q?ZFUW8dabneM7H0KFpbw8kMlIRViCkq7Z6NMGZTVsptjWSNBzXe0QJGpQD0wv?=
 =?us-ascii?Q?HER/YlXEn6WZmgRV//I0+u/hvarIuQ6Ry8k60bkomCupeh5arPZ9y3dg1Q+v?=
 =?us-ascii?Q?gkPInVkyXSp18rEKlB1CJs+NJkSBtyOrBojJT/3QRQbsZvq6DdiytdaxEQnB?=
 =?us-ascii?Q?xofsYJJT7Q2ViuhB+3R6GSQEJ9Jy41s+JVzq9v4TfTAzUN1/sfGFe49lwDer?=
 =?us-ascii?Q?6E+FDNnaRcB6yxdo8bHr6EHaGu8D/I9ciaptyWmDaEC6mOH0ebpZ4wEgH2RK?=
 =?us-ascii?Q?LnGM6pEK+5nKlQyRhqW0j2i/xhgK/G2P/wmAi78cgvcd7gStGD6sLzq+jkf6?=
 =?us-ascii?Q?ez9FmklHPt3yO+If4YD/AhBYl2sB2IF5JeeVHCajymCRbzi0qyPLUv13SCyE?=
 =?us-ascii?Q?OujMdqG/1xhdeHNQ4aIsme6pCsUedh+5nDdlgAfbfTNL3PdjV/nYVqWzubmq?=
 =?us-ascii?Q?TkqPtRqmtzfz410/RS1oDhKfClktl3+sGk1zPfrXTGuAlnRKbuQfufLEelg/?=
 =?us-ascii?Q?OA9JLeYGlxQK/M7dBDc9DDBfM3jlNW3RzFJYa6OU6N2/FoKJLLLYQngsBUbf?=
 =?us-ascii?Q?0Az9ir1Xh1aFkAktBP+G1CnfSD8/N3OLi0uIpxIX?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: edbcea7f-332d-4139-4cc6-08dc1e0162e0
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2024 23:57:28.3207
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yK6k7sbiN2PA14C9MRy4FnDUn+H6GciWQOSbpA7YsmJL55DZY1tNwMNL02LoMXVP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7038

Half the code was living in arm_smmu_domain_finalise_s2(), just move it
here and take the values directly from the pgtbl_ops instead of storing
copies.

Reviewed-by: Michael Shavit <mshavit@google.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Moritz Fischer <moritzf@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 27 ++++++++++++---------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  2 --
 2 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 910156881423e0..9a95d0f1494223 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1552,6 +1552,11 @@ static void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
 					struct arm_smmu_domain *smmu_domain)
 {
 	struct arm_smmu_s2_cfg *s2_cfg = &smmu_domain->s2_cfg;
+	const struct io_pgtable_cfg *pgtbl_cfg =
+		&io_pgtable_ops_to_pgtable(smmu_domain->pgtbl_ops)->cfg;
+	typeof(&pgtbl_cfg->arm_lpae_s2_cfg.vtcr) vtcr =
+		&pgtbl_cfg->arm_lpae_s2_cfg.vtcr;
+	u64 vtcr_val;
 
 	memset(target, 0, sizeof(*target));
 	target->data[0] = cpu_to_le64(
@@ -1562,9 +1567,16 @@ static void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
 		FIELD_PREP(STRTAB_STE_1_EATS,
 			   master->ats_enabled ? STRTAB_STE_1_EATS_TRANS : 0));
 
+	vtcr_val = FIELD_PREP(STRTAB_STE_2_VTCR_S2T0SZ, vtcr->tsz) |
+		   FIELD_PREP(STRTAB_STE_2_VTCR_S2SL0, vtcr->sl) |
+		   FIELD_PREP(STRTAB_STE_2_VTCR_S2IR0, vtcr->irgn) |
+		   FIELD_PREP(STRTAB_STE_2_VTCR_S2OR0, vtcr->orgn) |
+		   FIELD_PREP(STRTAB_STE_2_VTCR_S2SH0, vtcr->sh) |
+		   FIELD_PREP(STRTAB_STE_2_VTCR_S2TG, vtcr->tg) |
+		   FIELD_PREP(STRTAB_STE_2_VTCR_S2PS, vtcr->ps);
 	target->data[2] = cpu_to_le64(
 		FIELD_PREP(STRTAB_STE_2_S2VMID, s2_cfg->vmid) |
-		FIELD_PREP(STRTAB_STE_2_VTCR, s2_cfg->vtcr) |
+		FIELD_PREP(STRTAB_STE_2_VTCR, vtcr_val) |
 		STRTAB_STE_2_S2AA64 |
 #ifdef __BIG_ENDIAN
 		STRTAB_STE_2_S2ENDI |
@@ -1572,7 +1584,8 @@ static void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
 		STRTAB_STE_2_S2PTW |
 		STRTAB_STE_2_S2R);
 
-	target->data[3] = cpu_to_le64(s2_cfg->vttbr & STRTAB_STE_3_S2TTB_MASK);
+	target->data[3] = cpu_to_le64(pgtbl_cfg->arm_lpae_s2_cfg.vttbr &
+				      STRTAB_STE_3_S2TTB_MASK);
 }
 
 static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
@@ -2328,7 +2341,6 @@ static int arm_smmu_domain_finalise_s2(struct arm_smmu_domain *smmu_domain,
 	int vmid;
 	struct arm_smmu_device *smmu = smmu_domain->smmu;
 	struct arm_smmu_s2_cfg *cfg = &smmu_domain->s2_cfg;
-	typeof(&pgtbl_cfg->arm_lpae_s2_cfg.vtcr) vtcr;
 
 	/* Reserve VMID 0 for stage-2 bypass STEs */
 	vmid = ida_alloc_range(&smmu->vmid_map, 1, (1 << smmu->vmid_bits) - 1,
@@ -2336,16 +2348,7 @@ static int arm_smmu_domain_finalise_s2(struct arm_smmu_domain *smmu_domain,
 	if (vmid < 0)
 		return vmid;
 
-	vtcr = &pgtbl_cfg->arm_lpae_s2_cfg.vtcr;
 	cfg->vmid	= (u16)vmid;
-	cfg->vttbr	= pgtbl_cfg->arm_lpae_s2_cfg.vttbr;
-	cfg->vtcr	= FIELD_PREP(STRTAB_STE_2_VTCR_S2T0SZ, vtcr->tsz) |
-			  FIELD_PREP(STRTAB_STE_2_VTCR_S2SL0, vtcr->sl) |
-			  FIELD_PREP(STRTAB_STE_2_VTCR_S2IR0, vtcr->irgn) |
-			  FIELD_PREP(STRTAB_STE_2_VTCR_S2OR0, vtcr->orgn) |
-			  FIELD_PREP(STRTAB_STE_2_VTCR_S2SH0, vtcr->sh) |
-			  FIELD_PREP(STRTAB_STE_2_VTCR_S2TG, vtcr->tg) |
-			  FIELD_PREP(STRTAB_STE_2_VTCR_S2PS, vtcr->ps);
 	return 0;
 }
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 65fb388d51734d..eb669121f1954d 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -609,8 +609,6 @@ struct arm_smmu_ctx_desc_cfg {
 
 struct arm_smmu_s2_cfg {
 	u16				vmid;
-	u64				vttbr;
-	u64				vtcr;
 };
 
 struct arm_smmu_strtab_cfg {
-- 
2.43.0

