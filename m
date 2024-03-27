Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2087.outbound.protection.outlook.com [40.107.93.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A92F14E2F9;
	Wed, 27 Mar 2024 18:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711562923; cv=fail; b=N8YKA/8o1+5q4qDcbqWenYdfO2R4ew8Cle5DKyh5E0IDYCsVctqjDAdb0l/u5lofU0VDzJyI2aKhcr6qFIASQ3AAecQiafKpG1JXAXO1YWyJEYRU2bNaumS3uVACv/BP9MUiggq+LEO35MzSSwxlyJStVBBB05ugJqxQ+an1/z0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711562923; c=relaxed/simple;
	bh=4Pclknds/GrOFPbRZ/K0JDHxGAbkW52EEiRPINydB+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ZRrsr0CEEV4lI15bSjZ89AVbbsAaZtfUhpHejhysLKRbdU0W+rU/+h5jZC/p3cFjAQ31b5WKxbpL4lgseUHjZVDgz5pvOgoMlfLBG4TkQPghjgz047wIViOMytHEpZ5tqQbpgN5KBrdQbnrNgqeix4ftlZZEaXVnIS2wPO6choA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=OTWy3qy7; arc=fail smtp.client-ip=40.107.93.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="OTWy3qy7"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PNWQtYUMMDgJrIa4DqOrDxSt4WqnkIJ85wX0O9l6U+uloa9Dr+WOPxSgwL9yBMS3eLkl6COmEWYeZWDftVNm2JxpU9A/friXyOFzZxKCpTjiY6+Zzgy/AmD7nSnzDA+FvEs37vcBrmKmSDIYO80gAHhFfBsLJDjbGWbY4gQk9lotduHukPhpJPlJi4mh92XwK4kf61JiH7u1s8+urKL8m1iaBOfmMV8zRDMfkWHqxBueL50oqKdgALz+IdKt8fFDquWqSJjH6RnF7g4RG2fl6mITn0Bbvb2++pJJBEpw8ooDfgrc85JL30z2tWiV7XjHdHYQHLrgOxGKKJTO+b+WOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hyL/S52DRL+W1JlOeobeWf4tel8CHEt6/GhtyCTxIxk=;
 b=cQ3IcCbAR2EI53+P9z57qPIepvrDt9b0GmJur9IT8ssbc7AAb2Twg+IjXe4xjfAsrpC1NzcX7zySm1r3bvxSHnlMJBRQVzMFTwim+G9GvZoV2vRkNNCOYNiVtgqt1bCbjumpa6iU20KBlrL1FhcrEjnrZdhNAspRUP+88fglG2ei+imnUMvydPtd6uWYHxhdNpJqT/sHiO5TJ0pBPaWLj01jTXGEuWF3SQMr9Oy0Ri/sDtXMRnTwoX4VQuJoWH1wQMDMlQjwB/G/LyTM7DTx8F42RbYuN+Wz53IG8GivqN6TxBbSCb/xlipZOn5IMF+CyT/A8TeXBE2a8+Ec1fbDlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hyL/S52DRL+W1JlOeobeWf4tel8CHEt6/GhtyCTxIxk=;
 b=OTWy3qy7FYdaP4TxfFV99C/MNWJuneB53xqA9CAAl1XXbbg0uSa+MoK7SHyxcSlOIxTNUD8/+VnP/lHFMw25mFX2ptv4S5K7a30tCNMaFxeQaGsdDrDlyhcj2EWzt/6uQ1M8uNPZqgs0kNGtn57Fa5sYtwM3pSatSWqLHof3ldv503FCDY7v+hIr4JHN3/7HLJb/GCbbawvlwo7ntK73OjnvR9YuJWuRPvy59Qebl42JhjKulGxKkLhgRh2uoBi3yzrwjK04oTQ+cwHvifGgTX2w5gyP6YRL1UOuwZmhCIhUfh5KxMLPCenqffItmTST2m1s2/PItdlIrHz3Wgmw0w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by IA1PR12MB6044.namprd12.prod.outlook.com (2603:10b6:208:3d4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Wed, 27 Mar
 2024 18:08:32 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 18:08:32 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <jroedel@suse.de>,
	Kevin Tian <kevin.tian@intel.com>,
	kernel test robot <lkp@intel.com>,
	Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>,
	Tony Zhu <tony.zhu@intel.com>,
	Yi Liu <yi.l.liu@intel.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH v6 05/29] iommu/arm-smmu-v3: Add a type for the CD entry
Date: Wed, 27 Mar 2024 15:07:51 -0300
Message-ID: <5-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR05CA0046.namprd05.prod.outlook.com
 (2603:10b6:208:236::15) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|IA1PR12MB6044:EE_
X-MS-Office365-Filtering-Correlation-Id: 58bafbf6-c3e6-41ce-e36c-08dc4e88e222
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ZdMd3ejNZawLe+BKoGxyE07HCvagD1diw0OVj6oIbeijOoZmmns0Q9Sv29HdMtXM0Q5r41vnVirT9n4rBpR7ZV/lHRpEt4xxdLDATh3uMnfJWNx0Fjt6rJ5zHEPtndMDsZih05z6YAx04cePZB9nj9aOOXFXOWzEeH7KCxujrsVKR+2x9tW9VuYidn3cVVfU5DHFhAZgET1fYfwH8MEthyRVM5FNv0HQ7VXv6Oz2fHlbingwEHcA243VXLMRGaqiYFZNIJt3ox3Mu6Iys9P6xZZy2cPouOpZNoaPtO9H72pO0Hn7cAN5fjY5gcdP/QZf1VDX5DdurzyKfr5jYsaF/ckrOoHg/8Ly0vlkqvrmtg4zqzsT5saQYquwbmlKZtOlnaYaRx/VyvLOPOce6eOOUdyaRQB1pmbIYKohskAOmnyjS5tVFiwZnMsNEsdtQ+9OL1qJGxmiFHF+cFL7HnnBP8oLhumv5zbXs/yj3NAKRTGK3h0265pmpWX9EqskgvA2XemE8lpvrVzQod3QxDZMJWixuoSYc7Jc+vQiSfPfDjTr5+cAMhXnP7voEwS4NxrsogiZY8sppWUOwGsuSpg0bnSpOmWed9O67j1pJ8JrQTHkNu2UKrgpSfZ1wxW07tkEm6t3fS1x+6y8PObAt0OcpNBobzu0FcDJpHWgCW6UMAI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0l8rTyPwI/pYbJqjriFRCw8ABZof/vjV4sQ1VEUuoqkkmjl8g4yKIe719hRk?=
 =?us-ascii?Q?/fh6L/IqgTwiDUyTnHIxd5cncsx/ohTZE08E/FGhpxmdadlewFVBN/rNVU6u?=
 =?us-ascii?Q?A1UqhXqFNdmWfVYxpwDZ/V5zwGxKEqm4rWroV6+t74n3C/7pkCVf7zo/fBLQ?=
 =?us-ascii?Q?Ww72yL3gFcTrFgtIewE2WbMcBPjhO4KFTBGAKiLPdm1RHMWGxM14IAcFqdJV?=
 =?us-ascii?Q?8wua6VvaSqeW6jGf6kqyWzbLNcJZHfgLiNDyFMJiZe1/S1Ws/X+RXFoEfPnq?=
 =?us-ascii?Q?Ntlo934nK6pI09WkGAWrlvQcMo/FAIrZwpAaWVCQ850T+E/RhUSqmC2yxLee?=
 =?us-ascii?Q?oLd4ryuwTdUHrIThvRjGS3SFg27MbA906bWV3edh+qTwQnjz/r6feClSXF86?=
 =?us-ascii?Q?faX8NsncPLWheSomVLfS3qM2xejQNTuAfAwT/g+5pvlBKTXZudmyp4itTpLo?=
 =?us-ascii?Q?Q7E8qn3L2HzdZuH30LW96J/pCMZeCpaSFjfqhyfNBcREr2SinVjBgBXY6X9I?=
 =?us-ascii?Q?5zgwtPZMlko+F+R7JvurA8LR+hMJMSz2eq7XDHp5k1z1D3s9udAJeP8hFEk1?=
 =?us-ascii?Q?D0jROyMXGAFNwUe2FzdUGLwjZfKnodfrq8iY0ULB342L4Da6nMQgoPYNJqq7?=
 =?us-ascii?Q?c+B0soa+GhX90xKOMPn3xDCJxJDQSMC16fY1xDqHcBr4XdH8sXUm34k21yl1?=
 =?us-ascii?Q?1iBRhTurhrxVqnD4PBycXcbWvSPSsAOkfLoIFjm8ggG/ejV3XAUGwA/7WL/T?=
 =?us-ascii?Q?sXGU0k/MQ1HrOTeL/X/okvBb5FRlc0A+/hoXJtlrAwzIyrnAnZEF37jUAcag?=
 =?us-ascii?Q?htiGfYaigCVsDIeH22Ue3x7c6HDnXJ0toP3DJt4x555whKAximhHbn1ndWgm?=
 =?us-ascii?Q?TTZJUfSDERtqZS5Rvbemnk08GRAn27oqY6M+7vG2f1BnEhaQ3oLITl7Opopc?=
 =?us-ascii?Q?ZZXEGllv4oFGt3QeYBHy8k/VkPaEp5yY/0ZY3XxUH+P8CxYWLb0oBDLdbcad?=
 =?us-ascii?Q?X3bgmbZz4ioly/OXaDr2z9xMJrLjujJXUBvNyDkHfIoWMjiL9mxc4HI7SWBu?=
 =?us-ascii?Q?t+nz3e+/dRbWJwD+ZoiULlA6HYJqO38ZwECxj/YCkls2AQEUtNfzOFh/iesD?=
 =?us-ascii?Q?/7vXGBKWcUQIvrLct/PKm41R25Sf5TKzpNUNe44bq3fnkEUMl9a5y3g60VZV?=
 =?us-ascii?Q?7XWg/LATIOqvkAUuKc52vU2vlwszrfqti15L9cyRNAZEhtUibJUAiMTxrSH5?=
 =?us-ascii?Q?7rfilbzYv7CSCvuqII7IQ/fnkGEuu1DbY2hRHQPOcdj80Fe36T8rTIhOEAwk?=
 =?us-ascii?Q?pjnGrim24I55Ii+Mf0PYTaziMLLtCLJZFbwpMvyx8KdFBM9xMuokgP4g61rS?=
 =?us-ascii?Q?N3EBhfXnaD3CaqnWMkA1Aqs4ru95QvQcI9+EPWzF1QZQVZl3MI47J9PvuYr8?=
 =?us-ascii?Q?AIMiU87KrfIMhvv2slJ6nWz/0WymakJ1c/VzIsthsWGfTYW6AgVszx505d7r?=
 =?us-ascii?Q?2813UcPIFdMWS/mQ15jT8MZQ9Oxm148oYrcm6z/RDdCYuRdiOXX9XzpTuQuc?=
 =?us-ascii?Q?HtEnY9OXlwe7BDF2Uh0AfeBKQfagGrie1t2hJ2uG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58bafbf6-c3e6-41ce-e36c-08dc4e88e222
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2024 18:08:19.7069
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fPThecL/FthzAwKOzPf2XbaAVKRGoYVsavp/WJLMNIK/iLZnNn3ROefQl2BuLdCI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6044

Instead of passing a naked __le16 * around to represent a CD table entry
wrap it in a "struct arm_smmu_cd" with an array of the correct size. This
makes it much clearer which functions will comprise the "CD API".

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Reviewed-by: Michael Shavit <mshavit@google.com>
Reviewed-by: Moritz Fischer <moritzf@google.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 20 +++++++++++---------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  7 ++++++-
 2 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 7480f70701a045..6f62a38052b504 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1214,7 +1214,8 @@ static void arm_smmu_write_cd_l1_desc(__le64 *dst,
 	WRITE_ONCE(*dst, cpu_to_le64(val));
 }
 
-static __le64 *arm_smmu_get_cd_ptr(struct arm_smmu_master *master, u32 ssid)
+static struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
+					       u32 ssid)
 {
 	__le64 *l1ptr;
 	unsigned int idx;
@@ -1223,7 +1224,8 @@ static __le64 *arm_smmu_get_cd_ptr(struct arm_smmu_master *master, u32 ssid)
 	struct arm_smmu_ctx_desc_cfg *cd_table = &master->cd_table;
 
 	if (cd_table->s1fmt == STRTAB_STE_0_S1FMT_LINEAR)
-		return cd_table->cdtab + ssid * CTXDESC_CD_DWORDS;
+		return (struct arm_smmu_cd *)(cd_table->cdtab +
+					      ssid * CTXDESC_CD_DWORDS);
 
 	idx = ssid >> CTXDESC_SPLIT;
 	l1_desc = &cd_table->l1_desc[idx];
@@ -1237,7 +1239,7 @@ static __le64 *arm_smmu_get_cd_ptr(struct arm_smmu_master *master, u32 ssid)
 		arm_smmu_sync_cd(master, ssid, false);
 	}
 	idx = ssid & (CTXDESC_L2_ENTRIES - 1);
-	return l1_desc->l2ptr + idx * CTXDESC_CD_DWORDS;
+	return &l1_desc->l2ptr[idx];
 }
 
 int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
@@ -1256,7 +1258,7 @@ int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
 	 */
 	u64 val;
 	bool cd_live;
-	__le64 *cdptr;
+	struct arm_smmu_cd *cdptr;
 	struct arm_smmu_ctx_desc_cfg *cd_table = &master->cd_table;
 	struct arm_smmu_device *smmu = master->smmu;
 
@@ -1267,7 +1269,7 @@ int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
 	if (!cdptr)
 		return -ENOMEM;
 
-	val = le64_to_cpu(cdptr[0]);
+	val = le64_to_cpu(cdptr->data[0]);
 	cd_live = !!(val & CTXDESC_CD_0_V);
 
 	if (!cd) { /* (5) */
@@ -1284,9 +1286,9 @@ int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
 		 * this substream's traffic
 		 */
 	} else { /* (1) and (2) */
-		cdptr[1] = cpu_to_le64(cd->ttbr & CTXDESC_CD_1_TTB0_MASK);
-		cdptr[2] = 0;
-		cdptr[3] = cpu_to_le64(cd->mair);
+		cdptr->data[1] = cpu_to_le64(cd->ttbr & CTXDESC_CD_1_TTB0_MASK);
+		cdptr->data[2] = 0;
+		cdptr->data[3] = cpu_to_le64(cd->mair);
 
 		/*
 		 * STE may be live, and the SMMU might read dwords of this CD in any
@@ -1318,7 +1320,7 @@ int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
 	 *   field within an aligned 64-bit span of a structure can be altered
 	 *   without first making the structure invalid.
 	 */
-	WRITE_ONCE(cdptr[0], cpu_to_le64(val));
+	WRITE_ONCE(cdptr->data[0], cpu_to_le64(val));
 	arm_smmu_sync_cd(master, ssid, true);
 	return 0;
 }
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 23baf117e7e4b5..7078ed569fd4d3 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -282,6 +282,11 @@ struct arm_smmu_ste {
 #define CTXDESC_L1_DESC_L2PTR_MASK	GENMASK_ULL(51, 12)
 
 #define CTXDESC_CD_DWORDS		8
+
+struct arm_smmu_cd {
+	__le64 data[CTXDESC_CD_DWORDS];
+};
+
 #define CTXDESC_CD_0_TCR_T0SZ		GENMASK_ULL(5, 0)
 #define CTXDESC_CD_0_TCR_TG0		GENMASK_ULL(7, 6)
 #define CTXDESC_CD_0_TCR_IRGN0		GENMASK_ULL(9, 8)
@@ -591,7 +596,7 @@ struct arm_smmu_ctx_desc {
 };
 
 struct arm_smmu_l1_ctx_desc {
-	__le64				*l2ptr;
+	struct arm_smmu_cd		*l2ptr;
 	dma_addr_t			l2ptr_dma;
 };
 
-- 
2.43.2

