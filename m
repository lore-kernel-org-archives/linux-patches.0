Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2040.outbound.protection.outlook.com [40.107.95.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6DD513B2BC;
	Tue,  6 Feb 2024 15:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707232387; cv=fail; b=IYZrGq5hGHKLkEl7uBQzfBH27h+6IJuF+1CzBfDh7NMVQnvpiyTurE4NdzZ4rTFN0cIw+jWOCC9RIHeaUWDEMzhVFvBeJSd6w3TEbzFvvuAPzIbCZplrpgld6hz1mo2uMltwGSDUB5eyhghToE1ICx6ZprVVmb5j5CP26kcMeEw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707232387; c=relaxed/simple;
	bh=a8Zvac2dwJLG4XGiheEz7mCppKqzMpasiI0YQmN8MoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tEB1WdAeQmYYLDYGkW6/JyybaWzUPMaS08xOk9WB6Wgi0Hk9xDS+ApWU9umQz8PCQ2EbFbtG0XIdFROfQ3FGM3btv0yBgUqHAnoNSSB9L5mvMGMR5intk1vCawMFWaSNmHvcgi71GBhVD1OTiQLzINLkRsmTXDZVzi4AjSUsDZg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=KKXQtVK0; arc=fail smtp.client-ip=40.107.95.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="KKXQtVK0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SIrXy1vp7GyuK/P6j+FCOXqx4rJbpxCwR995lFj5DcDlwzyViWtFwm/PjVy+Kd1kHi6wWmI0G/4KdDViEfPcGt+8HWt3riNNXyeGDkhIMd6KIZoH4o4YGhCMlpQoD+QrHkjDNlbXcOsmfNSK0Z7G7bg4/spoFtAatIumHqvLD5lgx2yghx+j83EM3ZNdrDs1jg61bwpZ8JvIJJeJfw09Vc7H5wilb8dNGc3dGRrniej8ivoYKxE0Phq8cY/2/8+uVshcbZrEv4QLDN10UrDt5fnCP40ktQIbyQ5VWsPWucXutp4+7duKdzHtgsmnVqaY5njU4KiOFbTkdPJXHRx5lQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cl2D0SBsu5wOHnADSxmOIpgcLebBg+x/x95uXFL1poI=;
 b=nMCUfTo+xRPGcrWl6peiwhAPFrIA/tY0KWw+hdgsj19Cwv/iu05eBpGwE6rdbAC2iPVgiMj4LDQ/R7XHID6xsWcrx0i1+CXA+nWi/uso6KvZPH4OctItlex4cvF1T9y2kVTESAxO89KSHqkL/kqxLOQlisPPSjW/1O/oemjMPUm/3ugJtX0Hx1ZQolhZn48bv8EqeoM8x1+G3oxY+UWVWmiaTrMqNY0vQDLMrGHHSZbatO37tzhgKkDOnxFUhlSUWlDn6S8T5pj0BavfVrXTmgWwrld8HxmUvNuwGks3KmgnER16aLHrMcR0aIqTq7t5HQrqIbWLY2S8Bbl6YLf1aA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cl2D0SBsu5wOHnADSxmOIpgcLebBg+x/x95uXFL1poI=;
 b=KKXQtVK0LkyaSLwHT8BlmAYW6euyZiInYAMTMPKYwqaM+9/NoLfYCy+gE0n1xN3bKjD6WrTfJTrVtZvpFu75SAM37+R6VEaVr5IQlbzcKgtpMFbfQyQt7qLjk9NZ6Bj4GP3P9yjBuXy7cqDeX9LDGealTNd//J9Bll7aQEqMND13iDuyP6dHebFS5esiFZq/YBzUby+KO2mP9zk6S8BhZLsCbdETv/kraYGvrihtE/Th2ZpL8q8uOztX+/M8NL0HT9qx1VoVKoV7VG10ZsjywXsB4lQVKY1b9+pXvkRkV1cBvMSe2GqlwiA8i4AkYMPo6OBmtSZoUsa3rdwT+KgwWw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CY5PR12MB9056.namprd12.prod.outlook.com (2603:10b6:930:34::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.15; Tue, 6 Feb
 2024 15:12:55 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7270.012; Tue, 6 Feb 2024
 15:12:55 +0000
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
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH v5 02/17] iommu/arm-smmu-v3: Consolidate the STE generation for abort/bypass
Date: Tue,  6 Feb 2024 11:12:39 -0400
Message-ID: <2-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
In-Reply-To: <0-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P222CA0030.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::35) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CY5PR12MB9056:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f5ff0b0-f658-4f82-7820-08dc2726184e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	RBSnNIVwGg9qcAmIvA4Y0OLGLrtVnEIiZjV4pye9EpOFYhEzGjcp+pc1vPcbYinDIQHPeC5Rk9jypLZXRzfn1gICyiaAQrKu+76VSR7iLXLmRxwYx1+0QeuJmdbKAyidcgd16uLqUxZeTSyttNDtOPbobt8w0xSNqhuEv1GJY4/639pHcZVlst77v2LPqUsMvIxJsyjY5aHvimatXLH4gN1xqX0mqAEr7wFJBAQz1r50gb9J0gfAPR6pYQx3WC+9bYmb3JygNWMUqYAXE6WEEONCklJR7ldwe+FHIDCjBuSmBEvQGLv6qEcyJx+MB837L4bKpSh7umfJCbmQl12kB75Yf7O2QGybRziUxjwFGomj5zOfc88pG2q0PAeS8pMn0uh4ns5vcABWixXOKqQelFsQR08X6i9M/t4WpndwyWcZuOfugYTttl9IR14UO9s7R9T6lcbi6daWQooLmRG/J1y9cfx5DRIVtcFgKRbYENBezL+h9CM7biXizIbielgFSsBd2tlFJ0AB3vMhDxUwmGSWFylTcnPq6LwijcJVBHWIXNY1KUvD5RkA1Es5GQMRI8w8u4ZdKY9QCKduWNvI/iy96/kdoCuPPYximfaNd4Y=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(346002)(396003)(136003)(376002)(39860400002)(230922051799003)(186009)(1800799012)(64100799003)(451199024)(316002)(110136005)(83380400001)(54906003)(66556008)(2616005)(38100700002)(6666004)(6506007)(26005)(6512007)(5660300002)(86362001)(7416002)(6486002)(478600001)(2906002)(8676002)(66946007)(4326008)(36756003)(8936002)(66476007)(41300700001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?D218N0Rh0QZinxL0bTaurPaJD9hF9sm9XPa9sgUAoyyAaz3AKF62QSstGR8E?=
 =?us-ascii?Q?iaGqSYxSGdcKA7s+LMG747ap6o5r5UxJ6uaRJ/8yQbXN4d2KUui0EP8u97ys?=
 =?us-ascii?Q?T3ABpQmZEMG3p3wRPzBrKyTWX4Te0T2Erd3/sxtT6qGDgU/yLv4CHswSb3Nk?=
 =?us-ascii?Q?TKSuhv7LOlCgKkxy/3GizhB7VIHFVOt1djfrN93HwArhiM2ozWlppelH9uja?=
 =?us-ascii?Q?OZfSj9nBFB/bUCV+rG2Fl/PaqwjDrpmZSHuz+tr9ghHrK2KnWh48aUgcqWXP?=
 =?us-ascii?Q?hkuz+G1c5Gl2fi1r6K4THOqCjhI4RHWzG6uyS1vl6xQnAsQSGkrzZNSOvWEk?=
 =?us-ascii?Q?yVlfOLABCxGJTkhRr9B9YDEIRjvPwD2Pro4Q0h9/pLP6MXN+YzFKgKtzpy9t?=
 =?us-ascii?Q?J2YIhAWgrHomKfWxtxHdlTzxcfEecPPvLO3+7po45cuP07zjnuzEQBw/N4BP?=
 =?us-ascii?Q?/A0bZnRzvbv7FJh/vvVacuTWnlPMuG2IEBcRg+3nUHLdjvXn3PQlPoLjmDav?=
 =?us-ascii?Q?Fd0JnNPjtLZKbOtKhCio4BwFabho68MQmzOedsqmH+cNgc5to4iQCaQxP1xF?=
 =?us-ascii?Q?L7gw31WVs4uhaqt/eyZFwie7bH8nIjHcZ2CJhrDB3CDPvvH5eAPAThDW652N?=
 =?us-ascii?Q?fYysSjUnQneh+1MnoJDwwcIJIXIi0hK/lruP4J+/cisUWQw9wbuV+YMQ4gnL?=
 =?us-ascii?Q?+p3XTj2gfI2zQoQ3bu9FUa009dxIc4hJ6r59UI35vRYDPOWfpmgAFrCDNHDe?=
 =?us-ascii?Q?PcquZWYrTCRo7InOprYgR0MrGrJtQHowQSOpxUOaS9Lf79PydKm8p/1wk/s8?=
 =?us-ascii?Q?LLSfgrSNtipL1yV2vVjR6XvCa+kUds3yY8QzEGY8jLbx8ad2tMwWdvTVcxJ6?=
 =?us-ascii?Q?hq+Xfw8Uzakui/WNntv0CuaT1rXX0nz+/puvHjVx0iSkWaD3l5OHzialqpd1?=
 =?us-ascii?Q?2wdm+A9f7kSrZWdVGG6M2eSm1NGuyKorIVR8sw5Wv0+C395pgDmj77JSLGw8?=
 =?us-ascii?Q?l3i1M6gjTYW5n9IC518wYw4u0w9Mx8x6KCpk2MpYYuglAL8GJf+ZzxKwQV1w?=
 =?us-ascii?Q?wDQ9A+gnKnJ5ZNo3H7b5PWfxmfRyXsRjC1qqU0c+MNGcVSyhULK/jU83gamF?=
 =?us-ascii?Q?JGqj3hAA0iRU8RZvvdVZsaL715gE6hiBC/ULMV8B9gaTlZGxNH2D+PNFHWRQ?=
 =?us-ascii?Q?85+xw8hocul3u4TCo9DFA6jDAK6VqeOVVj9q3YbHAsdR02uYcSufNdYEni55?=
 =?us-ascii?Q?LVJKI+8GpHrtwl5z6qRjWvGjJ3fXQJqXPYGGIDLCnADJeprGSaWcbDS6EqPe?=
 =?us-ascii?Q?iivnk7SJBSxBX5lsxJJ7PTDx6Jpp6VToLVP2cNssMiwu6eGR0+Q6SbA7FZ26?=
 =?us-ascii?Q?Jc7dyK8uSCV9vamXUTdvI2UBD7To8bERlWC4/cJ6QRGtB+sApQB3Z13V/6cS?=
 =?us-ascii?Q?EML5ww83DnQYWa1gLX5QKgzrjiSkSw3Q3SO4e6LrOU7HMXV7g5OfuB+xx20U?=
 =?us-ascii?Q?I9hxZeSBirdcIbHHAnc65UcFaIPtN1oaUiLzEduDlfaPYdTx5EqKMShKFqJ4?=
 =?us-ascii?Q?IBNO7qQ0W00ITHslPdI=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f5ff0b0-f658-4f82-7820-08dc2726184e
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2024 15:12:55.1270
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vk97teK6gujfuMvCMhtFvIPHal21QbRf8ru4ImuDPjFJ4ezajVgEmwnxvA1B1GAW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB9056

This allows writing the flow of arm_smmu_write_strtab_ent() around abort
and bypass domains more naturally.

Note that the core code no longer supplies NULL domains, though there is
still a flow in the driver that end up in arm_smmu_write_strtab_ent() with
NULL. A later patch will remove it.

Remove the duplicate calculation of the STE in arm_smmu_init_bypass_stes()
and remove the force parameter. arm_smmu_rmr_install_bypass_ste() can now
simply invoke arm_smmu_make_bypass_ste() directly.

Reviewed-by: Michael Shavit <mshavit@google.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Mostafa Saleh <smostafa@google.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Moritz Fischer <moritzf@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 97 ++++++++++++---------
 1 file changed, 55 insertions(+), 42 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index f0b915567cbcdc..6123e5ad95822c 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1498,6 +1498,24 @@ static void arm_smmu_write_ste(struct arm_smmu_master *master, u32 sid,
 	}
 }
 
+static void arm_smmu_make_abort_ste(struct arm_smmu_ste *target)
+{
+	memset(target, 0, sizeof(*target));
+	target->data[0] = cpu_to_le64(
+		STRTAB_STE_0_V |
+		FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_ABORT));
+}
+
+static void arm_smmu_make_bypass_ste(struct arm_smmu_ste *target)
+{
+	memset(target, 0, sizeof(*target));
+	target->data[0] = cpu_to_le64(
+		STRTAB_STE_0_V |
+		FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_BYPASS));
+	target->data[1] = cpu_to_le64(
+		FIELD_PREP(STRTAB_STE_1_SHCFG, STRTAB_STE_1_SHCFG_INCOMING));
+}
+
 static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
 				      struct arm_smmu_ste *dst)
 {
@@ -1508,37 +1526,31 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
 	struct arm_smmu_domain *smmu_domain = master->domain;
 	struct arm_smmu_ste target = {};
 
-	if (smmu_domain) {
-		switch (smmu_domain->stage) {
-		case ARM_SMMU_DOMAIN_S1:
-			cd_table = &master->cd_table;
-			break;
-		case ARM_SMMU_DOMAIN_S2:
-			s2_cfg = &smmu_domain->s2_cfg;
-			break;
-		default:
-			break;
-		}
+	if (!smmu_domain) {
+		if (disable_bypass)
+			arm_smmu_make_abort_ste(&target);
+		else
+			arm_smmu_make_bypass_ste(&target);
+		arm_smmu_write_ste(master, sid, dst, &target);
+		return;
+	}
+
+	switch (smmu_domain->stage) {
+	case ARM_SMMU_DOMAIN_S1:
+		cd_table = &master->cd_table;
+		break;
+	case ARM_SMMU_DOMAIN_S2:
+		s2_cfg = &smmu_domain->s2_cfg;
+		break;
+	case ARM_SMMU_DOMAIN_BYPASS:
+		arm_smmu_make_bypass_ste(&target);
+		arm_smmu_write_ste(master, sid, dst, &target);
+		return;
 	}
 
 	/* Nuke the existing STE_0 value, as we're going to rewrite it */
 	val = STRTAB_STE_0_V;
 
-	/* Bypass/fault */
-	if (!smmu_domain || !(cd_table || s2_cfg)) {
-		if (!smmu_domain && disable_bypass)
-			val |= FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_ABORT);
-		else
-			val |= FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_BYPASS);
-
-		target.data[0] = cpu_to_le64(val);
-		target.data[1] = cpu_to_le64(FIELD_PREP(STRTAB_STE_1_SHCFG,
-						STRTAB_STE_1_SHCFG_INCOMING));
-		target.data[2] = 0; /* Nuke the VMID */
-		arm_smmu_write_ste(master, sid, dst, &target);
-		return;
-	}
-
 	if (cd_table) {
 		u64 strw = smmu->features & ARM_SMMU_FEAT_E2H ?
 			STRTAB_STE_1_STRW_EL2 : STRTAB_STE_1_STRW_NSEL1;
@@ -1583,22 +1595,20 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
 	arm_smmu_write_ste(master, sid, dst, &target);
 }
 
+/*
+ * This can safely directly manipulate the STE memory without a sync sequence
+ * because the STE table has not been installed in the SMMU yet.
+ */
 static void arm_smmu_init_bypass_stes(struct arm_smmu_ste *strtab,
-				      unsigned int nent, bool force)
+				      unsigned int nent)
 {
 	unsigned int i;
-	u64 val = STRTAB_STE_0_V;
-
-	if (disable_bypass && !force)
-		val |= FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_ABORT);
-	else
-		val |= FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_BYPASS);
 
 	for (i = 0; i < nent; ++i) {
-		strtab->data[0] = cpu_to_le64(val);
-		strtab->data[1] = cpu_to_le64(FIELD_PREP(
-			STRTAB_STE_1_SHCFG, STRTAB_STE_1_SHCFG_INCOMING));
-		strtab->data[2] = 0;
+		if (disable_bypass)
+			arm_smmu_make_abort_ste(strtab);
+		else
+			arm_smmu_make_bypass_ste(strtab);
 		strtab++;
 	}
 }
@@ -1626,7 +1636,7 @@ static int arm_smmu_init_l2_strtab(struct arm_smmu_device *smmu, u32 sid)
 		return -ENOMEM;
 	}
 
-	arm_smmu_init_bypass_stes(desc->l2ptr, 1 << STRTAB_SPLIT, false);
+	arm_smmu_init_bypass_stes(desc->l2ptr, 1 << STRTAB_SPLIT);
 	arm_smmu_write_strtab_l1_desc(strtab, desc);
 	return 0;
 }
@@ -3245,7 +3255,7 @@ static int arm_smmu_init_strtab_linear(struct arm_smmu_device *smmu)
 	reg |= FIELD_PREP(STRTAB_BASE_CFG_LOG2SIZE, smmu->sid_bits);
 	cfg->strtab_base_cfg = reg;
 
-	arm_smmu_init_bypass_stes(strtab, cfg->num_l1_ents, false);
+	arm_smmu_init_bypass_stes(strtab, cfg->num_l1_ents);
 	return 0;
 }
 
@@ -3956,7 +3966,6 @@ static void arm_smmu_rmr_install_bypass_ste(struct arm_smmu_device *smmu)
 	iort_get_rmr_sids(dev_fwnode(smmu->dev), &rmr_list);
 
 	list_for_each_entry(e, &rmr_list, list) {
-		struct arm_smmu_ste *step;
 		struct iommu_iort_rmr_data *rmr;
 		int ret, i;
 
@@ -3969,8 +3978,12 @@ static void arm_smmu_rmr_install_bypass_ste(struct arm_smmu_device *smmu)
 				continue;
 			}
 
-			step = arm_smmu_get_step_for_sid(smmu, rmr->sids[i]);
-			arm_smmu_init_bypass_stes(step, 1, true);
+			/*
+			 * STE table is not programmed to HW, see
+			 * arm_smmu_init_bypass_stes()
+			 */
+			arm_smmu_make_bypass_ste(
+				arm_smmu_get_step_for_sid(smmu, rmr->sids[i]));
 		}
 	}
 
-- 
2.43.0

