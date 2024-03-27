Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2055.outbound.protection.outlook.com [40.107.93.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CF4912F5AC;
	Wed, 27 Mar 2024 18:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711562915; cv=fail; b=KEPcNbugfjLdnrxldqa6G72M56OQxdvnIgN6poJ5j9/M7BZEJBEtaP6sUHQfBBY473MZwtMAACcwFMDaKomIm15crHsafgHtNmyC2AtzrYs6bHjnBX7XlNlPX1znokhmJb8fwGyTvAgFKy3JYwcE8mKbVvHt570wN9LVkJSytPY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711562915; c=relaxed/simple;
	bh=QKhnjR72gGtMfQdfQx7CRcztx8FvEiX8xrIZeVr/YCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=cRaVAqLdsqxqUMGk4EsWBY9XR71k0U6GJqUkJcRbwKLcnsDewBuTJKNXCiWaKQMacVY6lrrlJG4eoK89+J2JLmr5/CyuOsZUyChgqSXvTrkM2ki3Wtfk6XOIL1p6DsX0BY8Qyw6dtIpWDzEh7lh50BkE8uP7SiZpWej+FtfLMws=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=AzaXUWPk; arc=fail smtp.client-ip=40.107.93.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="AzaXUWPk"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ha78aRk8Ym1iyEOasd3n9zttL54CfVoaa6OnglPGgqSQMtwSQ6SDbl4mp/X7aM9kdWNcxPuLG4V1MWB3hklb8YZmQBFrKM8+YSYSv31g1iy4y64UCtnPLZUfxDW3db0BwqQWXDPiv2yd0D/aISGiNkTETKOLdSmpR/+fMlbaTyW5zp5Z5/2Kr3F8ZpcMoP57BUHDghswZ/HByEGzBe4U7JgO5CipZec6v3hnnq0ddlnjNw1dOyOrke+V9KElkWkTpP97ob1coesKXV9WL6dSiZAV80dz0CHgw7rzksvqdl8Nhp5XKXPKa6FWD9vWKhpcpp4y8YtyiyEE8lCHjf5/bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0e1UYuPTCAp8UJlsQZ32Rt4F34NQGChm2NGhgWKckdw=;
 b=VLNbyeI/cAMKiHlEHKAxMctK2dKw7KK0+JgC/XmxfHYINe/qHGdfyrQ9i9inhLKg5kNr7EHL+PsxTR96ZfOTUW/fOM9Zn54eb3vgLtIno2yYWUV8W3VP60ON0GpztcJToQvJrqadseVbxutsK2A6j5HPRSbrNimZISBfhMDuttm+yUtM0XRP7NSuiIektJolk6DfKIBmMEx6CzFq98fGiD7pdw+TzreG6bI/Wc/CvYGHOQYoAgW61RLGsLjk3pXVpGubosmc+WsJhxQZTFuSskeNBBE8vekej1ij952log4alKuflUsQejrlVrbSiR3PAIG+xf5SomNIVIc5y2MaVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0e1UYuPTCAp8UJlsQZ32Rt4F34NQGChm2NGhgWKckdw=;
 b=AzaXUWPkJAg0zo803xDjww3dExyInJEZKtThZzPlJ6dl/oRIte9zKthp96yHeNk+GOF6WFeZloNkO5kct7T1M2CRVxeKKdPNK4CGZCMvQ8+PtjCjGC/Zb9S2ezwLwdK3k0gICFP9zbjc+8bTDhR3427NhybwU1orjT0HBwbDtWC41Ohv7WleasEFgkYSbNnt03sjS3bFm/mlD2PS2/O+EM+btO0oid52Ms146mif/7bjh0OMSilSi7H7iLwr7fqxT6vUcN73RnB2+GLxMimBJRWpMUsveeNas/ZQFCbymm/ZWonny+ZQ/wNwI9Mf48YQiSlSJvPe2SKDaPNtSw+3zQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by CH0PR12MB8487.namprd12.prod.outlook.com (2603:10b6:610:18c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.32; Wed, 27 Mar
 2024 18:08:26 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 18:08:26 +0000
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
Subject: [PATCH v6 13/29] iommu/arm-smmu-v3: Build the whole CD in arm_smmu_make_s1_cd()
Date: Wed, 27 Mar 2024 15:07:59 -0300
Message-ID: <13-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|CH0PR12MB8487:EE_
X-MS-Office365-Filtering-Correlation-Id: 6779786e-a58d-490f-ac9f-08dc4e88e15c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	spufI9xcvTf/TgMxjUwXi/OPa9Dn7dVydqxGgrQqTBaG5ULmaovHVTaGf+C2zU8g1yhMlSe7awiNBWwZxZRKH0J2zbykfYS84XqJA0x79JgnlusF7R8lLX6lnQafWI+g6mz3aEYKeML4G1w9iQDoolJ3vhCfkrwjDxMtmacHdfSyXVmiIdKoNjHO/QThFRpKUPEiS8pXFMeaHk5jLr17vnwxTXkkBpn1/3LN3NW1+77jkM6MA++p0mv7NYODVwiDBlq/mwIHH5QcImzNQoe591io/vokmDieFjbBAyUV7hPXzxVmMK4hYDvznNfberm1fOI5+3a03tlDToIfvQ35unM9/RtrQVmCqmu//pbWzndDI1S9Nk7B9CY7Bev+T4yu3t3m6eZG6av5CBHII1oiY/91NQxFortxIk5D7fNcoMFiKHJrmhHZyVGzCrM+kE1v7lzhwtavjj+9N/74VXF+HneGOFIojg15JiEn0UHdxCWoKYvcQZ93sY17/0QGdBXUuxtYOPjfvRLKOSZpZ50bFyeuRa2QIEPjpinlc1O36TOzqGiwHCJFfoV44d7IsrQF2wc0Mb4z91yAtUnL9Pasqz8enadOByGZZrohilnkX0cT32rg615jAhYWk0mgAR+PqOl1niFrYPk5peT7skGwi6vHnWufQOrufGP6hnnZkcQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ssRdDe2z2FwRhMsr5MDsevNF8GBVleVG0fn+a6yi8H2tCFF7xffsYV7ZOyOt?=
 =?us-ascii?Q?fo/Bfpz/o9NtRoh+thxPsJgS0xplTnq3MpQyYGlEsp4B/+2JIEPeJ4NB6G4Y?=
 =?us-ascii?Q?Z/bUSSWIb2Pumhw2LjVtRlQaGUAYaBWx7yvoipt5WMHVv2ftHqANCtDRLIyX?=
 =?us-ascii?Q?/S2Ow/R1EWYk331jgVF/CFuo8sXBijeVpNpMXsfIDCXStFwd+TmJOOpRdbwU?=
 =?us-ascii?Q?gVoVze1suL+Dhdzyi96HIi4O1j7gMYO3RRWXRSj8neCOf1ebb3PIb0Aws1ZB?=
 =?us-ascii?Q?hMEEucO4u1MxKDRA0VmYE1s+Lj8RljU6XrdKxHmEBb715MgNIA9VIAny0gkH?=
 =?us-ascii?Q?GdrYcV2145oKwdQ/68c80Gxu5A3UPeA3qkQVx44Vwx54wYvNs8O2Q3gDstDm?=
 =?us-ascii?Q?Lucy077Icrqo7alwZfPW0iz60HtZWeILcSikO6x/oAnn1kHKczhXaqqxydKF?=
 =?us-ascii?Q?7O3cDd/x32TTBuy5TGVO6VEaxSJuiaXSBxMdJbRCMubnyWaaJ24DswV8cgv6?=
 =?us-ascii?Q?8ymbjwXsU61TnNs8SCyfOM6QCVVYQJE8mTBEo/fKDZ1w9HId1Ix7MaO70w4N?=
 =?us-ascii?Q?HwslNJ7Ozmr/NG6H6o02UnhmNCgk/V4tezAj8RRs9mrbU7RcSis4fdbm5Q72?=
 =?us-ascii?Q?CnQBZNxfNsZFsO4SMvmKsAcSoAXF31RMi7DMfo1Jv2yNi+g/3JIou0NEy6hU?=
 =?us-ascii?Q?QMGBzMVwajSsLxnMOa+PRmVcLQ1y9RLrebIz+hr6R5Yfd4MvFharCf7uhR2H?=
 =?us-ascii?Q?zzXHVpfCMArjggCzjkbK1c/FeFmgKvutNEMhTha5jLcMEmYW1Sgqi8fN/Fgv?=
 =?us-ascii?Q?l6cS3rQRYoK97r+NRQO35CHSa3TTCddVlWQOMBkseE99pWpuT1tVDBGuKQAd?=
 =?us-ascii?Q?3mkZiI1CDbvf0I3IDHD/4nFRYCmG5+L/DSnsBdW7AGZlZ7h8fOOzxkV9qwc+?=
 =?us-ascii?Q?aP3zYga6yQjggGGNcPx68EU/kiY5NGJSQmvZIeAPFSrFVu2NktpqNjQwm7SA?=
 =?us-ascii?Q?LkV+eYHgCu9SZLziL60Amdg//gA4GsEWxatZHoXYGRfHzIABWrDBjN4QlnO2?=
 =?us-ascii?Q?wCzpLRPmQrG9c1ICMk/fQ5LTJns4ktasGrM9g8J/02SAABYtbsmyXAymtjJZ?=
 =?us-ascii?Q?qGKm7D3Qv8bnDO3NgrV6c61yJyfhIpr19NZ19TQwZXhEsBXkjGhMuB8F/Q4u?=
 =?us-ascii?Q?xnO7aHsrDR7FWI9ZQSeGSlknu8dJk5e1XzeIzu4Ru+CLxet4WhGBaskicMWd?=
 =?us-ascii?Q?/d9zfQoHdQnBPU3vjG4iGvyirGV6RvIX5h4vn3dh/xPO6ffAqDJMyw7dxLip?=
 =?us-ascii?Q?L6fNi0xxR/7DLmvd3TXVjlLDt5rZC+bLLhapoouab0PVfX6sd2geAe/ERSVC?=
 =?us-ascii?Q?0zDM10l9Bi0nlz/PYgfbFVTb1RJ6EEyuZAEDQ8VYmn56y5FwpGUt6e1rG5/A?=
 =?us-ascii?Q?1K5lLRjEhnNgL49B82ceSW1fihGc5+2i56FQ4arhyHWTfG2tfWQl5l8dLfPy?=
 =?us-ascii?Q?yK8JS3oKEjUKPxDK9ewEZk1Blw2f3EodArZYPAQ/jL9491PCi64PdsNZwCby?=
 =?us-ascii?Q?crGXfh9FPpr8ulAfLRUCddXvTjUDLIi0DgyzOBnb?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6779786e-a58d-490f-ac9f-08dc4e88e15c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2024 18:08:18.4602
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TtFEz5gmhHjRnKW/1Eq+qO+IhBlt49rheg3FR/pX/QSPZzo9+sNoxjc3MTxMZ3bN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8487

Half the code was living in arm_smmu_domain_finalise_s1(), just move it
here and take the values directly from the pgtbl_ops instead of storing
copies.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Reviewed-by: Michael Shavit <mshavit@google.com>
Reviewed-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 47 ++++++++-------------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  3 --
 2 files changed, 18 insertions(+), 32 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index af5ebedf0f0beb..49e51bc1a5c788 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1313,15 +1313,25 @@ void arm_smmu_make_s1_cd(struct arm_smmu_cd *target,
 			 struct arm_smmu_domain *smmu_domain)
 {
 	struct arm_smmu_ctx_desc *cd = &smmu_domain->cd;
+	const struct io_pgtable_cfg *pgtbl_cfg =
+		&io_pgtable_ops_to_pgtable(smmu_domain->pgtbl_ops)->cfg;
+	typeof(&pgtbl_cfg->arm_lpae_s1_cfg.tcr) tcr =
+		&pgtbl_cfg->arm_lpae_s1_cfg.tcr;
 
 	memset(target, 0, sizeof(*target));
 
 	target->data[0] = cpu_to_le64(
-		cd->tcr |
+		FIELD_PREP(CTXDESC_CD_0_TCR_T0SZ, tcr->tsz) |
+		FIELD_PREP(CTXDESC_CD_0_TCR_TG0, tcr->tg) |
+		FIELD_PREP(CTXDESC_CD_0_TCR_IRGN0, tcr->irgn) |
+		FIELD_PREP(CTXDESC_CD_0_TCR_ORGN0, tcr->orgn) |
+		FIELD_PREP(CTXDESC_CD_0_TCR_SH0, tcr->sh) |
 #ifdef __BIG_ENDIAN
 		CTXDESC_CD_0_ENDI |
 #endif
+		CTXDESC_CD_0_TCR_EPD1 |
 		CTXDESC_CD_0_V |
+		FIELD_PREP(CTXDESC_CD_0_TCR_IPS, tcr->ips) |
 		CTXDESC_CD_0_AA64 |
 		(master->stall_enabled ? CTXDESC_CD_0_S : 0) |
 		CTXDESC_CD_0_R |
@@ -1329,9 +1339,9 @@ void arm_smmu_make_s1_cd(struct arm_smmu_cd *target,
 		CTXDESC_CD_0_ASET |
 		FIELD_PREP(CTXDESC_CD_0_ASID, cd->asid)
 		);
-
-	target->data[1] = cpu_to_le64(cd->ttbr & CTXDESC_CD_1_TTB0_MASK);
-	target->data[3] = cpu_to_le64(cd->mair);
+	target->data[1] = cpu_to_le64(pgtbl_cfg->arm_lpae_s1_cfg.ttbr &
+				      CTXDESC_CD_1_TTB0_MASK);
+	target->data[3] = cpu_to_le64(pgtbl_cfg->arm_lpae_s1_cfg.mair);
 }
 
 void arm_smmu_clear_cd(struct arm_smmu_master *master, ioasid_t ssid)
@@ -2286,13 +2296,11 @@ static void arm_smmu_domain_free(struct iommu_domain *domain)
 }
 
 static int arm_smmu_domain_finalise_s1(struct arm_smmu_device *smmu,
-				       struct arm_smmu_domain *smmu_domain,
-				       struct io_pgtable_cfg *pgtbl_cfg)
+				       struct arm_smmu_domain *smmu_domain)
 {
 	int ret;
 	u32 asid;
 	struct arm_smmu_ctx_desc *cd = &smmu_domain->cd;
-	typeof(&pgtbl_cfg->arm_lpae_s1_cfg.tcr) tcr = &pgtbl_cfg->arm_lpae_s1_cfg.tcr;
 
 	refcount_set(&cd->refs, 1);
 
@@ -2300,31 +2308,13 @@ static int arm_smmu_domain_finalise_s1(struct arm_smmu_device *smmu,
 	mutex_lock(&arm_smmu_asid_lock);
 	ret = xa_alloc(&arm_smmu_asid_xa, &asid, cd,
 		       XA_LIMIT(1, (1 << smmu->asid_bits) - 1), GFP_KERNEL);
-	if (ret)
-		goto out_unlock;
-
 	cd->asid	= (u16)asid;
-	cd->ttbr	= pgtbl_cfg->arm_lpae_s1_cfg.ttbr;
-	cd->tcr		= FIELD_PREP(CTXDESC_CD_0_TCR_T0SZ, tcr->tsz) |
-			  FIELD_PREP(CTXDESC_CD_0_TCR_TG0, tcr->tg) |
-			  FIELD_PREP(CTXDESC_CD_0_TCR_IRGN0, tcr->irgn) |
-			  FIELD_PREP(CTXDESC_CD_0_TCR_ORGN0, tcr->orgn) |
-			  FIELD_PREP(CTXDESC_CD_0_TCR_SH0, tcr->sh) |
-			  FIELD_PREP(CTXDESC_CD_0_TCR_IPS, tcr->ips) |
-			  CTXDESC_CD_0_TCR_EPD1 | CTXDESC_CD_0_AA64;
-	cd->mair	= pgtbl_cfg->arm_lpae_s1_cfg.mair;
-
-	mutex_unlock(&arm_smmu_asid_lock);
-	return 0;
-
-out_unlock:
 	mutex_unlock(&arm_smmu_asid_lock);
 	return ret;
 }
 
 static int arm_smmu_domain_finalise_s2(struct arm_smmu_device *smmu,
-				       struct arm_smmu_domain *smmu_domain,
-				       struct io_pgtable_cfg *pgtbl_cfg)
+				       struct arm_smmu_domain *smmu_domain)
 {
 	int vmid;
 	struct arm_smmu_s2_cfg *cfg = &smmu_domain->s2_cfg;
@@ -2348,8 +2338,7 @@ static int arm_smmu_domain_finalise(struct arm_smmu_domain *smmu_domain,
 	struct io_pgtable_cfg pgtbl_cfg;
 	struct io_pgtable_ops *pgtbl_ops;
 	int (*finalise_stage_fn)(struct arm_smmu_device *smmu,
-				 struct arm_smmu_domain *smmu_domain,
-				 struct io_pgtable_cfg *pgtbl_cfg);
+				 struct arm_smmu_domain *smmu_domain);
 
 	/* Restrict the stage to what we can actually support */
 	if (!(smmu->features & ARM_SMMU_FEAT_TRANS_S1))
@@ -2392,7 +2381,7 @@ static int arm_smmu_domain_finalise(struct arm_smmu_domain *smmu_domain,
 	smmu_domain->domain.geometry.aperture_end = (1UL << pgtbl_cfg.ias) - 1;
 	smmu_domain->domain.geometry.force_aperture = true;
 
-	ret = finalise_stage_fn(smmu, smmu_domain, &pgtbl_cfg);
+	ret = finalise_stage_fn(smmu, smmu_domain);
 	if (ret < 0) {
 		free_io_pgtable_ops(pgtbl_ops);
 		return ret;
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 5aefb0ee2b9bb7..7bafec4c0c2fac 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -587,9 +587,6 @@ struct arm_smmu_strtab_l1_desc {
 
 struct arm_smmu_ctx_desc {
 	u16				asid;
-	u64				ttbr;
-	u64				tcr;
-	u64				mair;
 
 	refcount_t			refs;
 	struct mm_struct		*mm;
-- 
2.43.2

