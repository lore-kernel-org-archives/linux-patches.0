Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F229C7D3E6;
	Mon,  4 Mar 2024 23:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709595872; cv=fail; b=hR3iTaxFV2rDerHoguBWMBN52Oj1KhvUetBh1MIDVhO1B9+r/2ee5Tl8OEucijnTBA2XRzHbZuWUAZ3KIyAKBcdNHogy9X8lznrNOiC12QYqBkDYY+8eqZYOXIWBr2LuRcetGDwU8TYeLAGoFpH0lf6vOypI93CAxJa3fMXXtC0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709595872; c=relaxed/simple;
	bh=RRCYVjrcjWhpQ7IbxbAi4S9d3rBG7ATU558PHLkFf2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BLdSIFW7POCv6v+oaXeOk/J7jobw2ST1FYH6crSukc51VuMkGNn/g/M0DulC3TdTZPpU8n910NnWyjoh2/u+uKxEI71f0zzJj12YoS0Y1Wup0pOPWum6bd5e1X7/k1GiUgw4j0H2jg3dWPpeU51Mm/zl5DPQ30qOZPsrH2IrG1I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=HFzEnc9Z; arc=fail smtp.client-ip=40.107.236.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="HFzEnc9Z"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L57weEBuPJS44lMlwY9q0bFJV8NVA3JqdENwVGeNY8i0X/JMUYcbvXbPNGlXpxF6W3wwhlwOK0AOnqX5T0GNPmicVp/Xqisg0KxfGvPhcQT8r7MB4cOtabP4YElsj0oMYJVwBHHglcp6maB/Xo/Yjz7lCvCIrTJ1aq0eFebIkjhDOSq8Oe92V4x8AfNeDZJ/C18vuL/9drWcHjayRu/KOpbGwA/Fd3xu6ah27hZKGH1Q6pvCVCzQFMDNxW9OFAhGM2h09EN1hJYjijWwej+202XB5aCpMk86LS4wtEBTk7Ga1nVLSs6MfAnHLtezT3ZcFRUkQ1DTU79V52C0DnLWOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AIII3wxtG2zCCtTHh29POSsCw1px1TyzzQ45+o2SN6Y=;
 b=PEEgoLK1WbBQ/AnLM0FEBCqB52imaLWO+fqtLtVIymD//Kzo2n9M566xNfyLJhhR5Rm13LJAzN+OVnI2hBnXbKqOTHz0w2ZYaO1JMzRDVvGlm7Pp2FES4kuihcrO8Fr4mr8iJLYgtC+mJQTaUcAiN/j3/W0BIvsEp2ecVGQ5yoXkbCgMjhnBFRbnAioJOT6H/4RXX99beiibbo6to/JBI1Y6IgCyvKXFQpPqW3KrDglgv8iLDa/Lc3068yNXMkJF3tBvapAXiPl/JZ46XDHBKFi4Sv0Pc7lIBgTKoJqEbsJNB74Iv9bHWdcI5yGGdV/m77P9U8jIoxx6VwImmHV5ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AIII3wxtG2zCCtTHh29POSsCw1px1TyzzQ45+o2SN6Y=;
 b=HFzEnc9Zodhj7Ya7LirDIpJE8qEs0pqxt+CgFPRCR0dbyqfBPEuGraFzVkw0k1AahuK/Jy+6UnUnUFleqSE2e5Vtq3NznINcURb75ZW/GioHKBgr0zrcQ+sbazxumPg8xEsDtFuaaHe4tKA0nr6YVNpf0MsMt3WOlmDpG7szuPik/mrSTBtSyovopaQFs4qYebJuV60bl+COuKfON0N92O/5PYIDh6vFso+VoS+uJWeZ7VGL9a489vqGNMXvC6uZKzugLMhugp1SHLWkVPQjrpeYAaAiQGSAo/pctzkGrI+wRm07EafIc449GExY2mHWEMoR+IGhSkSF6YrPOXMMSA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by DS0PR12MB6584.namprd12.prod.outlook.com (2603:10b6:8:d0::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7339.39; Mon, 4 Mar 2024 23:44:23 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c33c:18db:c570:33b3]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c33c:18db:c570:33b3%5]) with mapi id 15.20.7339.035; Mon, 4 Mar 2024
 23:44:23 +0000
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
Subject: [PATCH v5 16/27] iommu/arm-smmu-v3: Keep track of valid CD entries in the cd_table
Date: Mon,  4 Mar 2024 19:44:04 -0400
Message-ID: <16-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR1501CA0035.namprd15.prod.outlook.com
 (2603:10b6:207:17::48) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|DS0PR12MB6584:EE_
X-MS-Office365-Filtering-Correlation-Id: 6db4577e-5789-4896-4e17-08dc3ca50185
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	NnDOKiufJf0zZMSPPjvEqX41COMOSbnCsVXUiVzxM1wvIS3Lh9/LCvroDZCgFD3lLNs+VXCr7Ahzi5RQJ6glYsVpqvrNwCbQtLFcH2MjZZzEhcJWkrOZmOPDbV3Wsz9Y9im4vfY/t/7H6wy002f2P8JE898MiX7McYvHvSDQpBiTerAkwtSs95AVen1CiJbIdZM47zdnTSV9N76WjoPiXoG2GfGE2C9fQPTXSUPYZgu8Lsgb6/AnD8xdEaN/eLqOVz+8jLzmtM1+eXe1OHazE6OCotkMfclAN2VtAQEkdLOyOG15gVT+b0Nbf7BwJsNLxsJprPAxJ8qNRo+TKjQpXyl+hhwJq45f3v5SZRhFEJXW/Sjuz9v7pZVQ4dlTtUlKpdYIdp82vZU+g4WE6Ras9E4CzzGNnbbzT40fUlkkPxdO+DUvidUiGh6H7Z91XY0pAVV65G1OxqhQwabMcUwhzWp9k6Lg6Zd93g5pUWcRIc+7BrZrgJwY8Zb/n9ViwiOR4TD2JganYaexG6xztxdNC29fr5WIdlCQqST4LxVFCk3AMy1aISCOOLW5bpY2kkaZAx05bhQFob/PBSC9mjpUlkxilZjk1jKVkmlaBHZ3JSMLaXDsJf9MdrrOyU36K01nnEddUU2oax7xyXhJcSlF+R3cSewmqaifS/RFI2gnBJQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/txMTfrC2Az9Levm3TOTlQgtRNyEeFdrWT2+wXoK5/4FnzFjE8CwrK8PGGNN?=
 =?us-ascii?Q?y0csxOVMYy0f5sTR1Dt7CDX5937871LpW4cCxcNNlUCxidoXMIM4Rfe4jmjI?=
 =?us-ascii?Q?q2H23IoUYrNkOoCmT6MKWK3Ai1hGCMSVM5cXP69m1EP6AocbJCvtAI0NkPlB?=
 =?us-ascii?Q?IuQC13kE3ucVuVkde23E2YAu8cKoU2QYXHdvBlROZn9OfayODWt76lfqCh0d?=
 =?us-ascii?Q?zhItilyAASZVfBIXPKtgoFZz9wv/GPICV/EuBWpj160+cFnFdv/TodPyJ91b?=
 =?us-ascii?Q?+thJCnln63NPt2UuL40knjRHc2hEjgkG7pfidoVI1LtsvSZzKTckn+lfPZAc?=
 =?us-ascii?Q?9cyjuxt4g5NoCgWjnCvbF1AVI8bYfXo8kNX4zv1RZ3RLO3E9pq4oHJntudAx?=
 =?us-ascii?Q?LqokZTEg3FLZzLmG76Wpd3F2pTbHnD5cPE0Y9iD18fEG1jYoFc551+Y2isWC?=
 =?us-ascii?Q?jrEViU6pw9gMw3dKG11C+mqQxr50D8rV8PIJainfSytcPA+R5Qyxjxvbq82f?=
 =?us-ascii?Q?4nw4LVxzTTSs1WPBgLkQ9jQ8nxzGXNm//sMw7IZvehMuxbXhN4o919awxJjU?=
 =?us-ascii?Q?3FAlK8Zx9+xU7xz6MhB6kqKL7BzwsXw2V8Mle9CaEs9/JWQpQZCy13r8BGUf?=
 =?us-ascii?Q?jsZwgzxcUmd4uLMz75OjcdlPTVizqO47tr5uzylM5QhNZyJKqrubU8oaoO6G?=
 =?us-ascii?Q?00CDVbJuAHhgi/wpPkFPg9aheE/w+8ff1MPxOCIXHU7pYQUg7lYI3bSdWT2E?=
 =?us-ascii?Q?8iWTecXy0EwneyYjw3P0KMBysAD5Wbkq2g64g1DmsIvPyHwAq1EBrs+vsVx3?=
 =?us-ascii?Q?4usMkGGcjPirZtQvgudFiau483Wv+k1T5qwZfomHuthaMVwBXURO72ocJHcA?=
 =?us-ascii?Q?PaGQJw6M0EWFQQX8PAxvGFTIH4BWXR1fRva0H1G/vLxCAoduq9lCqLa5djXJ?=
 =?us-ascii?Q?LdgAfUJ8BRUh271T94ZFMtt/YGe/tGahH6VNW0/AzHl5tXGC1z6XtE3M3H5d?=
 =?us-ascii?Q?YHOOHGMjSMrD6JWvDMJ5QGEWJpyD8nbsYMHe2VWNmn8TPf8qFBvBxLuU0i6n?=
 =?us-ascii?Q?bEgoDqUVegG+cS76r25Rd+zOVk8tE+SnKfBaI8BH8+E12hH6r7HBE0OBWZGP?=
 =?us-ascii?Q?80Pk7Gt8u0DiO5ql4qVhD2uBgcrAQQjQ6NZx+BRImNmd4YIdVlOu8cHdcq2q?=
 =?us-ascii?Q?xZlpXh6+Bja5t7TQIBWdytkfwY3RAXiYzVzO1cotdwkS0RIy/juR9aHvWDzs?=
 =?us-ascii?Q?ZUddWHFhV55q+U7E8Vsj5U0IhUOGLqDkkg1zT3ezCo+nVYqrB9b0Eb32xsCz?=
 =?us-ascii?Q?uRBd/iAv0n8Gp0J5MPW+NVJ2Z7NsYQd8c2oRoNrfPl2hYbdLfRkHT/2O0kbP?=
 =?us-ascii?Q?Np6I5MuOi2z8OnJqMfUFaNyknuncHHHcTeHOQLGiqqTgUwUKXWOLRskdudAP?=
 =?us-ascii?Q?qcN2k2pdaAxIjMwhTT0H5GzV4QtIa281Waj/eIFg0fAMr90NPMJnD3WdtNqx?=
 =?us-ascii?Q?iyB9oC4qWJqg6vdGTzOBPLAze3+cFIlr6atv7DYpB2RyDnq4qY7+5YT9UuhH?=
 =?us-ascii?Q?9rM/vrw+Z8UDuhPAip/nCGMYQkbTEu/QalfRpeah?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6db4577e-5789-4896-4e17-08dc3ca50185
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2024 23:44:17.3547
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r/O8l7LxdpTI6FOoPXKdU6c+VYGDYTMN5L6PFOJKSZrQYbTGMFE4/AbtGk/ZHHak
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6584

We no longer need a master->sva_enable to control what attaches are
allowed.

Instead keep track inside the cd_table how many valid CD entries exist,
and if the RID has a valid entry.

Replace all the attach focused master->sva_enabled tests with a check if
the CD has valid entries (or not). If there are any valid entries then the
CD table must be currently programmed to the STE.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |  5 +---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 26 ++++++++++---------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   | 10 +++++++
 3 files changed, 25 insertions(+), 16 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index ab9de8e36c45f5..82b9c4d4061c3d 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -433,9 +433,6 @@ static int __arm_smmu_sva_bind(struct device *dev, struct mm_struct *mm,
 	if (smmu_domain->stage != ARM_SMMU_DOMAIN_S1)
 		return -ENODEV;
 
-	if (!master || !master->sva_enabled)
-		return -ENODEV;
-
 	bond = kzalloc(sizeof(*bond), GFP_KERNEL);
 	if (!bond)
 		return -ENOMEM;
@@ -638,7 +635,7 @@ static int arm_smmu_sva_set_dev_pasid(struct iommu_domain *domain,
 	struct mm_struct *mm = domain->mm;
 	struct arm_smmu_cd target;
 
-	if (mm_get_enqcmd_pasid(mm) != id)
+	if (mm_get_enqcmd_pasid(mm) != id || !master->cd_table.used_sid)
 		return -EINVAL;
 
 	if (!arm_smmu_get_cd_ptr(master, id))
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 26c6b9f6f34fd3..fc19585bf192c6 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1285,6 +1285,8 @@ void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
 			     struct arm_smmu_cd *cdptr,
 			     const struct arm_smmu_cd *target)
 {
+	bool target_valid = target->data[0] & cpu_to_le64(CTXDESC_CD_0_V);
+	bool cur_valid = cdptr->data[0] & cpu_to_le64(CTXDESC_CD_0_V);
 	struct arm_smmu_cd_writer cd_writer = {
 		.writer = {
 			.ops = &arm_smmu_cd_writer_ops,
@@ -1293,6 +1295,15 @@ void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
 		.ssid = ssid,
 	};
 
+	if (cur_valid != target_valid) {
+		if (cur_valid)
+			master->cd_table.used_ssids--;
+		else
+			master->cd_table.used_ssids++;
+	}
+	if (ssid == IOMMU_NO_PASID)
+		master->cd_table.used_sid = target_valid;
+
 	arm_smmu_write_entry(&cd_writer.writer, cdptr->data, target->data);
 }
 
@@ -2725,16 +2736,6 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	master = dev_iommu_priv_get(dev);
 	smmu = master->smmu;
 
-	/*
-	 * Checking that SVA is disabled ensures that this device isn't bound to
-	 * any mm, and can be safely detached from its old domain. Bonds cannot
-	 * be removed concurrently since we're holding the group mutex.
-	 */
-	if (arm_smmu_master_sva_enabled(master)) {
-		dev_err(dev, "cannot attach - SVA enabled\n");
-		return -EBUSY;
-	}
-
 	mutex_lock(&smmu_domain->init_mutex);
 
 	if (!smmu_domain->smmu) {
@@ -2750,7 +2751,8 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 		cdptr = arm_smmu_get_cd_ptr(master, IOMMU_NO_PASID);
 		if (!cdptr)
 			return -ENOMEM;
-	}
+	} else if (arm_smmu_ssids_in_use(&master->cd_table))
+		return -EBUSY;
 
 	/*
 	 * Prevent arm_smmu_share_asid() from trying to change the ASID
@@ -2825,7 +2827,7 @@ static int arm_smmu_attach_dev_ste(struct iommu_domain *domain,
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
 	struct attach_state state = {};
 
-	if (arm_smmu_master_sva_enabled(master))
+	if (arm_smmu_ssids_in_use(&master->cd_table))
 		return -EBUSY;
 
 	/*
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 98dc5885c48655..7e1f6af4ce4e79 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -602,11 +602,21 @@ struct arm_smmu_ctx_desc_cfg {
 	dma_addr_t			cdtab_dma;
 	struct arm_smmu_l1_ctx_desc	*l1_desc;
 	unsigned int			num_l1_ents;
+	unsigned int			used_ssids;
+	bool				used_sid;
 	u8				s1fmt;
 	/* log2 of the maximum number of CDs supported by this table */
 	u8				s1cdmax;
 };
 
+/* True if the cd table has SSIDS > 0 in use. */
+static inline bool arm_smmu_ssids_in_use(struct arm_smmu_ctx_desc_cfg *cd_table)
+{
+	if (cd_table->used_sid)
+		return cd_table->used_ssids > 1;
+	return cd_table->used_ssids;
+}
+
 struct arm_smmu_s2_cfg {
 	u16				vmid;
 };
-- 
2.43.2

