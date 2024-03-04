Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2075.outbound.protection.outlook.com [40.107.94.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F8C7D41C;
	Mon,  4 Mar 2024 23:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709595874; cv=fail; b=Bj6jquvioJW8ZuP0pOFch2fvMs4CiKdVBsfHQRTnqFBedoqd3IgLP+J2GUMgHMVBAJhHsKztL2bVICOJOQf7XrJ5TSUA15gZ52tEx5tKFCpPt8wSfkHE9rLbL7WjVWYKwWuZnr7pdiVy8joFXlWHymu79uIYMRG+pccsqlzg+4g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709595874; c=relaxed/simple;
	bh=4CZ8o3VKoIc5ALyAGJYwGgM//kfgWMjIpXCGtdYTvGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=nUtTzp0LahcepklAc6E65F+emwL6V+YT+agsOZObI/FarDmJi5iSNuQxPi4JlLRSrXkgReKjr3lj/LISXBewDNStfzGPfxyoBKCGv33Jyje+Ho+krwNY0dKxcRihD2h2Pa/6fbpSQ3YtLTgVFC066UFkvoMkOIsx14YBzbjUJqg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=pcKqXo5m; arc=fail smtp.client-ip=40.107.94.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="pcKqXo5m"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lKJjFqa2Mt7+/QPx/DE6KbtMt3NEY+A0IEznMkjcAB7f7lSAuGKJZwx7nKsOAWHND3/xjj94ZoslmZC9BcAyqVfKxHPEHIg62WXF5GfaY3R6uIgqoVNKu4HKP9seUcsdx6iw/+0FwELaPVjfV9dLUtYMsTWTAc+zvC0felDoZWtp1fRx/WdJz5riOUuVwFaJqL1sZXfzEtCVg8x0PI9Oa8GEYP1pXGrZtq0G7h5pHkiRVjUZIP+0yVoGbVRa60nN6NGZTLgGuBuORtmDu3MkpstDunbUxDPdzZr3OwsyeBlCacnOxOxUNrKY/nwrDZ2BpTH4LiG0MJ/RfZyVIgmgfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x3HFqZi2vf0+LKWaoDn0YGT29s/JYuhRNhx79bUVCQg=;
 b=CipBsP2/jsRfkli1ZRI6rA2V9bOzM+tebesYPrHNQo6dtG/0t4vDYndI+g+Z0my5rEwMmBgsjxNtFD2vN2WI6ztmu2yAA+QfUEoSY6bDph8ZAfObdkxFwQdxzzJUkLHwWvRM0Hdi5+ytYog7Z4oQwtd0+R6Tqy5+3kNRuhoLuQg0SpnwbowMMAicqFY5jPeCzql+pXReUFcnQRvp3Yc/VCYYsclgEqVNuxp8emfUHoRrJKVNSl40vgjhmSvmUTdR1XEv2h+koombnzKh+5cyx9jtoDtwEpyYqi8icFz+caySMhNMdbsVMJ0RwAKWu1ibJKD/a9kaugLYQB1yS9XO1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x3HFqZi2vf0+LKWaoDn0YGT29s/JYuhRNhx79bUVCQg=;
 b=pcKqXo5mK3awx7PB0obg8rloqGB1LhDQXbZXI98bnwQz/tryE8JhtV3zmX2Pgm242LRa7WCkb4qvzUqylCg2oIBC3mWrJ5u1YVza/JH4i9dp0i/cBDFtCZ7p1vV5pQIpr/x3Ku4rAuf7R4KUlhg8k4u/omDFJbP5zzZ56coDxhuDScyMeBTZfq/n2+njszlbBSjAXmhnr5Es5XamE9+ClBusyE7JP2hzkI2M2Y7s63sGaDK2pjplwIfW7o4H5mym9ZFEHanIFpaOPkIQEjh5VIJKcBXPV3UsVpNpIAGajqOoh74dmF6c62e5/mPq+R669ZTV6yE20KtbjUkmm6116g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by MW6PR12MB8949.namprd12.prod.outlook.com (2603:10b6:303:248::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.38; Mon, 4 Mar
 2024 23:44:21 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c33c:18db:c570:33b3]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c33c:18db:c570:33b3%5]) with mapi id 15.20.7339.035; Mon, 4 Mar 2024
 23:44:21 +0000
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
Subject: [PATCH v5 25/27] iommu/arm-smmu-v3: Allow IDENTITY/BLOCKED to be set while PASID is used
Date: Mon,  4 Mar 2024 19:44:13 -0400
Message-ID: <25-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR1501CA0029.namprd15.prod.outlook.com
 (2603:10b6:207:17::42) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|MW6PR12MB8949:EE_
X-MS-Office365-Filtering-Correlation-Id: 4fb05ece-14c1-4d06-1ffd-08dc3ca50133
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Ksq2E7qYd+ktFm2fJ0rhBvQ0AUQEPtu3M6O7r+zZC56lkqRCzvH2NDk50Ct7yzbBOXyIC+fbAGgpPulDOmy/hCILtZ1fNDt3+rbWXB7TP68q4wyZ+NHE1DjBS5xblYnydNgM1oI/8B/FATV9LrEEpFV74JfSmf8MbNDTk0iWwBHUfn637RK4fRGYJegJikDoc6ltgS+dj4noMC/8QrNDoDVmXzbFEDOrXTCWGfWDS2EHlwUXytCnREJ2fOPWOfusUTrR4aXSLVj9up+u3rt+7cHdq+J0QBXHcAtl7UpnQDwA4N1T1FzYlbNXLUzIOj+6k5XEiFsZfQ/qzTowy5ekZkrt/P7ge+H0i+k1m7DqyDnAv5MFS8bYyK3NqhuzrvjkkyvXyW66ypp8BvLzLqHGDKRlQyfl3c4RgIwk6qa8sun5MRnb5jPBOMpBCkW3GQzSFV6znAV0yQ8gc3hI++zh+bYQiPaROHdL7fzf0xeJpLCrkh8WfXeO8PbboU+NhQ89MGTmb4ULd2hvDW+/R+QH2TItvW7D49ojA17JAL2mlg4EPY7F2EDEnRijAWEXeqBzF/GBdGndXhIjuwxmUj+ojY9TYBRIm/KnedFcATiCbtR0JkL0OBgnGMc6UTjqmhfoJyUaNTL6uzIvF+XoI3WSxQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WhyXH5mayYI8zRPRULoShO4SyR6MG7pQygJb5q9zXqvuzQdWsaIlLt9YplSo?=
 =?us-ascii?Q?0gCps0okECkvP4aCA4RE4lv4tDTi3lUayzM5nXC7xiSVbLRO/2/A9ovAQRPZ?=
 =?us-ascii?Q?Sci1RZpK2/qpzjHQoFQ1JCO4XCzX6C+pBrO8TTapWmFUHut2giv/WeKE69YN?=
 =?us-ascii?Q?6Agcp2igUrJqAM9rh4B1IGPtHwK/kOHuujc/ybcCwMin4/0UY4O79ZteEee8?=
 =?us-ascii?Q?OXlahcV+8Ma6z+L1nx7QiB/ehodpDkYxOdWpqyUODJ4lf6DlQRM9vFWOJjEf?=
 =?us-ascii?Q?kBrHoFVZCQ5GlbcPxawUGmw35O1VUNeWp8hPaiZQurl4MLbzfHX2ydzwnXqK?=
 =?us-ascii?Q?zXGYlauXe5IxyA3NQsmSX0szaQR8Ei2D3J3w9YrZofGf3tZELNNmHuLUUzjW?=
 =?us-ascii?Q?lhmiULrKlowfgRc7xSA3kKjSWMJUAs/sVHm776Rwfw4deDgQTAjWitiNKSw4?=
 =?us-ascii?Q?K1SBmZP2u4LEWYEUY2nzzvLeViCRhmoqtxSyR1fdi9fbA9iuOjoXOW8orTS8?=
 =?us-ascii?Q?3LBKFkzdCDnlP/u8NwPbGNpFlb4jc7QI6Zhw+ceHpg3zrrMOBOOYaafUFVjF?=
 =?us-ascii?Q?M0629AOWOGT9+8E4b/vd1GWBcyEsscfljo3Ba96pYW6MS3R6uKdm09NOUsy1?=
 =?us-ascii?Q?L3hyjlz8cMUc0CvcPQQgN5JVtfmuoacZYZTQO/FYT8NxJEhXi0nYE68ICQ+9?=
 =?us-ascii?Q?zXb+yfD0C3ImpjdFrXIHiHXM9X9cS92k9tRsaMEhttR4ReTh0xpe/8de357K?=
 =?us-ascii?Q?SHWx+cF3g15eH/x6gB1aTJCcoWRNgbFrC1MW9hI5rNy1MFxlBSxvaGn4d4j8?=
 =?us-ascii?Q?HXFBxWlL3kB4R5sej/ZWo5j5CA2qV9t9RVHXp7NrInOmEG/JLXYoOFkkJPeR?=
 =?us-ascii?Q?IwvISDycUFM/x2mDS41NUTXzdsCIly65DAp+olJXuNSEhYLT00F6hNqBZ4t6?=
 =?us-ascii?Q?vK3bYyGLbq1C76e5mosj2CPB9igtUw2WyxsF4MEHd8Eu2c1COcegCTWQJ/IR?=
 =?us-ascii?Q?JFP3X8jBz9squbVaK815EgJW8GpWgAtQuf/cbOhHeCezbJTn9kzZFnVIlDxY?=
 =?us-ascii?Q?v+vdT4NSXoOGqSlfoFZncyGgIW68KNlgTv+C5vOw1l2+2Mb6lCdLCtO3T65l?=
 =?us-ascii?Q?lmGOPPxzpJIBrAFHDLevQEyrnXLc3fyV4Zu6vrMcjsvM1BlTwse9ZDcGmCsD?=
 =?us-ascii?Q?z0VmHcVse5aY1WH4bQ0nI89HjqD2Q2r2BN5le6cEsqfIR/q9IkdoKWEIjji9?=
 =?us-ascii?Q?IFtA+VurYAs4rHlhrWjL0qhngDldrBmQ0ADPMCdQCsUvgAh4QFe+okqAiHz6?=
 =?us-ascii?Q?mY6AgM+M9eO4glvtDW1EzCklwTvIoLc/LjrmO2G8lt2GFfG+hhHfJZ1C3Qnt?=
 =?us-ascii?Q?UM+KrGa+HftBMFBiNhGoFlN9L/0W5Svkz5976tUWGplCjx8MOl/2mUdpInBD?=
 =?us-ascii?Q?JsgFTxR76IDQ8zVn8Z3Bx4rFDVmeVOjmYY7WvBrfH5eeNnlmPg+ozTWRbOah?=
 =?us-ascii?Q?0Hk+BW60BQb1X4CHIPSkQjX6ZAxm6RbY5N0zo2tZra0OrpH5/79A1ZKY0Gxq?=
 =?us-ascii?Q?Kq+w0lyJDjNKngeY5R2C09e6dVSJCDk6+8EBgGpc?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fb05ece-14c1-4d06-1ffd-08dc3ca50133
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2024 23:44:16.9130
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J8PfcMlilhqfxWLGEKiZIZ+94p05qWoiEQljIvyFvUZmG6TmMbFzwfP5KgbrTqPj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8949

The HW supports this, use the S1DSS bits to configure the behavior
of SSID=0 which is the RID's translation.

If SSID's are currently being used in the CD table then just update the
S1DSS bits in the STE, remove the master_domain and leave ATS alone.

For iommufd the driver design has a small problem that all the unused CD
table entries are set with V=0 which will generate an event if VFIO
userspace tries to use the CD entry. This patch extends this problem to
include the RID as well if PASID is being used.

For BLOCKED with used PASIDs the
F_STREAM_DISABLED (STRTAB_STE_1_S1DSS_TERMINATE) event is generated on
untagged traffic and a substream CD table entry with V=0 (removed pasid)
will generate C_BAD_CD. Arguably there is no advantage to using S1DSS over
the CD entry 0 with V=0.

As we don't yet support PASID in iommufd this is a problem to resolve
later, possibly by using EPD0 for unused CD table entries instead of V=0,
and not using S1DSS for BLOCKED.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 65 +++++++++++++++------
 1 file changed, 47 insertions(+), 18 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 01737a0fc82828..6b5a30c86dda2d 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1009,6 +1009,14 @@ static void arm_smmu_get_ste_used(const __le64 *ent, __le64 *used_bits)
 				    STRTAB_STE_1_S1STALLD | STRTAB_STE_1_STRW |
 				    STRTAB_STE_1_EATS);
 		used_bits[2] |= cpu_to_le64(STRTAB_STE_2_S2VMID);
+
+		/*
+		 * See 13.5 Summary of attribute/permission configuration fields
+		 * for the SHCFG behavior.
+		 */
+		if (FIELD_GET(STRTAB_STE_1_S1DSS, le64_to_cpu(ent[1])) ==
+		    STRTAB_STE_1_S1DSS_BYPASS)
+			used_bits[1] |= cpu_to_le64(STRTAB_STE_1_SHCFG);
 	}
 
 	/* S2 translates */
@@ -1522,7 +1530,7 @@ static void arm_smmu_make_bypass_ste(struct arm_smmu_ste *target)
 
 static void arm_smmu_make_cdtable_ste(struct arm_smmu_ste *target,
 				      struct arm_smmu_master *master,
-				      bool ats_enabled)
+				      bool ats_enabled, unsigned int s1dss)
 {
 	struct arm_smmu_ctx_desc_cfg *cd_table = &master->cd_table;
 	struct arm_smmu_device *smmu = master->smmu;
@@ -1536,7 +1544,7 @@ static void arm_smmu_make_cdtable_ste(struct arm_smmu_ste *target,
 		FIELD_PREP(STRTAB_STE_0_S1CDMAX, cd_table->s1cdmax));
 
 	target->data[1] = cpu_to_le64(
-		FIELD_PREP(STRTAB_STE_1_S1DSS, STRTAB_STE_1_S1DSS_SSID0) |
+		FIELD_PREP(STRTAB_STE_1_S1DSS, s1dss) |
 		FIELD_PREP(STRTAB_STE_1_S1CIR, STRTAB_STE_1_S1C_CACHE_WBRA) |
 		FIELD_PREP(STRTAB_STE_1_S1COR, STRTAB_STE_1_S1C_CACHE_WBRA) |
 		FIELD_PREP(STRTAB_STE_1_S1CSH, ARM_SMMU_SH_ISH) |
@@ -1547,6 +1555,10 @@ static void arm_smmu_make_cdtable_ste(struct arm_smmu_ste *target,
 		FIELD_PREP(STRTAB_STE_1_EATS,
 			   ats_enabled ? STRTAB_STE_1_EATS_TRANS : 0));
 
+	if (s1dss == STRTAB_STE_1_S1DSS_BYPASS)
+		target->data[1] |= cpu_to_le64(FIELD_PREP(
+			STRTAB_STE_1_SHCFG, STRTAB_STE_1_SHCFG_INCOMING));
+
 	if (smmu->features & ARM_SMMU_FEAT_E2H) {
 		/*
 		 * To support BTM the streamworld needs to match the
@@ -2754,7 +2766,8 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 		arm_smmu_make_s1_cd(&target_cd, master, smmu_domain);
 		arm_smmu_write_cd_entry(master, IOMMU_NO_PASID, cdptr,
 					&target_cd);
-		arm_smmu_make_cdtable_ste(&target, master, state.want_ats);
+		arm_smmu_make_cdtable_ste(&target, master, state.want_ats,
+					  STRTAB_STE_1_S1DSS_SSID0);
 		arm_smmu_install_ste_for_dev(master, &target);
 		break;
 	}
@@ -2831,15 +2844,14 @@ static void arm_smmu_remove_dev_pasid(struct device *dev, ioasid_t pasid)
 	mutex_unlock(&master->smmu->asid_lock);
 }
 
-static int arm_smmu_attach_dev_ste(struct iommu_domain *domain,
-				   struct device *dev, struct arm_smmu_ste *ste)
+static void arm_smmu_attach_dev_ste(struct iommu_domain *domain,
+				    struct device *dev,
+				    struct arm_smmu_ste *ste,
+				    unsigned int s1dss)
 {
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
 	struct attach_state state = {.ssid = IOMMU_NO_PASID};
 
-	if (arm_smmu_ssids_in_use(&master->cd_table))
-		return -EBUSY;
-
 	/*
 	 * Do not allow any ASID to be changed while are working on the STE,
 	 * otherwise we could miss invalidations.
@@ -2847,14 +2859,29 @@ static int arm_smmu_attach_dev_ste(struct iommu_domain *domain,
 	mutex_lock(&master->smmu->asid_lock);
 
 	/*
-	 * The SMMU does not support enabling ATS with bypass/abort. When the
-	 * STE is in bypass (STE.Config[2:0] == 0b100), ATS Translation Requests
-	 * and Translated transactions are denied as though ATS is disabled for
-	 * the stream (STE.EATS == 0b00), causing F_BAD_ATS_TREQ and
-	 * F_TRANSL_FORBIDDEN events (IHI0070Ea 5.2 Stream Table Entry).
+	 * If the CD table is not in use we can use the provided STE, otherwise
+	 * we use a cdtable STE with the provided S1DSS.
 	 */
-	state.disable_ats = true;
-	arm_smmu_attach_prepare(master, domain, &state);
+	if (arm_smmu_ssids_in_use(&master->cd_table)) {
+		/*
+		 * If a CD table has to be present then we need to run with ATS
+		 * on even though the RID will fail ATS queries with UR. This is
+		 * because we have no idea what the PASID's need.
+		 */
+		arm_smmu_attach_prepare(master, domain, &state);
+		arm_smmu_make_cdtable_ste(ste, master, state.want_ats, s1dss);
+	} else {
+		/*
+		 * The SMMU does not support enabling ATS with bypass/abort.
+		 * When the STE is in bypass (STE.Config[2:0] == 0b100), ATS
+		 * Translation Requests and Translated transactions are denied
+		 * as though ATS is disabled for the stream (STE.EATS == 0b00),
+		 * causing F_BAD_ATS_TREQ and F_TRANSL_FORBIDDEN events
+		 * (IHI0070Ea 5.2 Stream Table Entry).
+		 */
+		state.disable_ats = true;
+		arm_smmu_attach_prepare(master, domain, &state);
+	}
 	arm_smmu_install_ste_for_dev(master, ste);
 	arm_smmu_attach_commit(master, &state);
 	mutex_unlock(&master->smmu->asid_lock);
@@ -2865,7 +2892,6 @@ static int arm_smmu_attach_dev_ste(struct iommu_domain *domain,
 	 * descriptor from arm_smmu_share_asid().
 	 */
 	arm_smmu_clear_cd(master, IOMMU_NO_PASID);
-	return 0;
 }
 
 static int arm_smmu_attach_dev_identity(struct iommu_domain *domain,
@@ -2874,7 +2900,8 @@ static int arm_smmu_attach_dev_identity(struct iommu_domain *domain,
 	struct arm_smmu_ste ste;
 
 	arm_smmu_make_bypass_ste(&ste);
-	return arm_smmu_attach_dev_ste(domain, dev, &ste);
+	arm_smmu_attach_dev_ste(domain, dev, &ste, STRTAB_STE_1_S1DSS_BYPASS);
+	return 0;
 }
 
 static const struct iommu_domain_ops arm_smmu_identity_ops = {
@@ -2892,7 +2919,9 @@ static int arm_smmu_attach_dev_blocked(struct iommu_domain *domain,
 	struct arm_smmu_ste ste;
 
 	arm_smmu_make_abort_ste(&ste);
-	return arm_smmu_attach_dev_ste(domain, dev, &ste);
+	arm_smmu_attach_dev_ste(domain, dev, &ste,
+				STRTAB_STE_1_S1DSS_TERMINATE);
+	return 0;
 }
 
 static const struct iommu_domain_ops arm_smmu_blocked_ops = {
-- 
2.43.2

