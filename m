Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2061.outbound.protection.outlook.com [40.107.237.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7393117BB1C;
	Tue, 30 Apr 2024 17:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714497712; cv=fail; b=dmxzQDf8GinOI4e1bYjsDGKOYmnBRx2WLqyOIfaU+4LSaaoZbEQTiPW1Na25ODoslIrWkcVlWl1ieO8zGe2dLCMcX8owu4zbvIpJnmpjWwuavIzOrtyTxVCEMYE7/rAhLibulG4+sv19Q8QHPl0z40QkcdQhCLzJONTa0HNgBAw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714497712; c=relaxed/simple;
	bh=YwcM35b4CppivsMz/N6q8PT43B+8cjh2B846YZrVTEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=cnJDkEVgqZpFdXMCAvThCyb6SjrEM+x+BlZeNY6OQVjaLoFNfAvrexH04FTO3GwH6r8ra8sKKrEXybc080Sadb2wvuCdSbJ2TDHq/JUDAE2pqKWZCijyRQznvFW9ibqdHmQy9MBk/pqjLvwjBbIsgOMIuD/IKUy4aJkVz/GkAoo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=bppu1Qeb; arc=fail smtp.client-ip=40.107.237.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="bppu1Qeb"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NpDtcfD/t1TeUVpPfYQEwOBiakauJWFlEfRXUn1w8VNi6uhs8xZHTz4b3CVp640i2xedQoL5hezyGZmQDU5fzNFQ1WaU4SZWLPVwqRpzLEfQwpw6KWRR7yUTN2AvPxXmlOMIZEdgjt68aLvlMilVcBLB4mUW9wD1SvP+aQUtNrtkIIhTSIA01sUZmMAi/AZqO+GGBoPaCM2OVQxUM4uBibrb1wAsOzbn+mUeB3NMUwpcCgIS6r5gaj/Zgaeqd7h8YP6wdl9tvY2rqBNViQFpTg1eR0cv8G7tN6kEp0HYPiYwXCVcblvkypV68i552/2xHMFXTX3d8jLz0+4Oa6Tlog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P9Gc0ljTfkZiDfNYJqusXC0QJBdqdT4d4ljYV+FyCtw=;
 b=DJbg9T3DRgqoj9rF9VhdeecSe95M3rGZ1u33eqfo4GRGLkoTWbJPUrbt6/zFmvUJs+8GmMoPnXV840ZIaFg03PF9aUT4NaUB0OxRuGvA9VR49eqoH5lXDURwzw2j/Etz5UsQQcG4xTzcy1dsHXj9pN7TjJTlsgMz750cYEHXDu4BVfuaaXC3m5423hhp1omjsS+HNl2naNwmwp4pdjFW/PkGRVFXXkb8w0ngQoY+vIfPJksHWjDyHNkRBq5KwCcXdvSxJnxhVPAmR8LnU15LqQWRLOeIjfqhxk0To/2c0UUTa+0dw1hC9uK7AEmVrL+jh2W9h01CZ4y5Y+h65T4fUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P9Gc0ljTfkZiDfNYJqusXC0QJBdqdT4d4ljYV+FyCtw=;
 b=bppu1QebjTl792WWmbgatin3EdNzn0fZ5+0RJLMkN63mIX42Cd93nGQX3UffH7/55XLW/dwDDwmRApr/cRVJwb1VBpNb0ebIcSBF77nuQktmj4rEzqhoCDswQBnQmdlXofDCIpEk0YKI2KAAFE5hOH5UneSCsr6AEa0+efbF06hCrxL7WY2Tj7gnpPcMmbYcoQnUfFTwA8zgArwpSIR1PF3JjEfaBdWyr4G+eDWVBNa4cZ3oRbP87VnMW9mTLyhrlWSPEGc7/MOj0b0JLMInVN1hjGwdbRE2MYS9hm2XUxUZD1AtfeDzs+W1J9FT2Y7nSCjmFIYS4HeA47zcNNDnhA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by DM6PR12MB4172.namprd12.prod.outlook.com (2603:10b6:5:212::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.35; Tue, 30 Apr
 2024 17:21:43 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%3]) with mapi id 15.20.7519.031; Tue, 30 Apr 2024
 17:21:43 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>,
	Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v9 8/9] iommu/arm-smmu-v3: Build the whole CD in arm_smmu_make_s1_cd()
Date: Tue, 30 Apr 2024 14:21:40 -0300
Message-ID: <8-v9-5040dc602008+177d7-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v9-5040dc602008+177d7-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR17CA0001.namprd17.prod.outlook.com
 (2603:10b6:208:15e::14) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|DM6PR12MB4172:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f0de155-62b7-4edc-c4e1-08dc693a0114
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|376005|7416005|366007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zA1rzPIVp/tALkc5JFnesolGay2D61kb3LBD0dfLgGBrWy+enVZmL9hPpe58?=
 =?us-ascii?Q?Q+H04IBcQgcOgICcNed8btzHfyuQ9qNLL2PLptItjkOeXVy52OQjGZbfH+bM?=
 =?us-ascii?Q?GlGjeZLxoe5L2fGePo0KJRQkdZ1A/DS0bl955X8XiwCQwBIRFfzPd6M4gZBl?=
 =?us-ascii?Q?g1DuWDs0bSHEgi5I9YCXDX8EztZABJC7IgBX/wnsn8z8WKvY76oPkMwtVXQS?=
 =?us-ascii?Q?ZdUUEbRPcJQbyEtJmhWVnTM05sVdCwDiQnHRaOvhby4374uYnn1NonjHV/vV?=
 =?us-ascii?Q?0wTHDSIcO2zyhZp/lJ6Pc0g3I6nTE8Oa3rzotLS9hxOeqFmBxHrB/+jX/R1y?=
 =?us-ascii?Q?k/MVolhDBSckM+d280tVBIULUPC0LnrX4FIWB3NZFv8uFgv168rBXgon7F6a?=
 =?us-ascii?Q?xeNvDocEbYX/s/83xoQE1hjWomqu7UbhYnxiVC3lKPjo+tjsFJMKMunh0fZz?=
 =?us-ascii?Q?lScOFD1HOqmt5k+yH4YGGcLX6TYpEege0m0QRRpPRw/15D52PZ+yjMWEkKvN?=
 =?us-ascii?Q?mA4hTIk3Vf8wyNd7RuK4OFOv95ted8wAwaz6cyYtnJxvPVaPlEeR5znukrDY?=
 =?us-ascii?Q?ZZfN4j+AMdtPFAvcRUIxGt7hoGO18cfwxI+lonMMd57zUa0GfEj5a0jtqzXn?=
 =?us-ascii?Q?WGIwaEfi/3xx8ozE7DEEqjaZw3DZUCepIlbYa6Kpft1IAqRKxgRSxEAw4/ZF?=
 =?us-ascii?Q?b8rNqaCOT41gmrUgw7j4lkHJQDsCYJCln68abMbichGPRBJwtjXZ40u35zLT?=
 =?us-ascii?Q?4SwfbX03iUttZYrHHb64LbBTdiOXSG+ayj/+kW6iQFX2bLAqR8CLwK2TTBNW?=
 =?us-ascii?Q?R1UnLAtppaUwrZXpUzP89n92CE2mSLUPkFfpn1vCF7NKKRQ/sn9Fd6obeUOo?=
 =?us-ascii?Q?BP1Kth2N9EnmB00gL9jf5A6QchAeRdgOw+66uGLa1feMHQ0QtjiJPlw4w1KX?=
 =?us-ascii?Q?DRMczidH+w7Sgpov/TkzLM86dygw8jdanafQR85RZPTLmgzQc4mZJ7mD0EJF?=
 =?us-ascii?Q?kKm4nrxEegwJumbq5pw1jpqP/AjAuEBNN12FoklTXQJt04LRTe3NUU6CNJXE?=
 =?us-ascii?Q?W2dHUQDLuXcM3igkgOxU2+4Z8k2YQUgZmfwSobLP7IJ8+vhYBt95+p0dCEb1?=
 =?us-ascii?Q?lYi9vXpD77apshNrHDpHYj9PY4WbM9C/PUVcXMThek6et5klQ82I8GBLilE3?=
 =?us-ascii?Q?vC5R1K+cygvS36k3fVWbnS7/XQKyUQ4MQmJg+IzlCkQxr9isJfks7wEh7yXc?=
 =?us-ascii?Q?d9EwGWEIVL2XIc/RHSui/U74gh+XtgJmVn3+baHHFg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(7416005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?oy+MTZ0NUvNfrOLqlr75y2msnutpBwmV5Ih6srzdX44dduQkMUgL+UGBF4XU?=
 =?us-ascii?Q?ET9s2eUV34oyhlNQZTpvFqZkH3pQlDRwdDOjrsMgcd6/zRw3h2taD5ASOgdE?=
 =?us-ascii?Q?XGA7wGE4YhxY9LWCSHooyLLBjaglosNgUZuG3dOb8gdUwCE1Iy+qXUPcyNB5?=
 =?us-ascii?Q?Ws8NTyOM3Hyfj9/5m8g7VBV3BXp/U7YzWUUlSPvcgv55je10/kg7NRg2EA2x?=
 =?us-ascii?Q?kXMPxYkisIP6O7zjmZr2H7LNqh1fMECBDTRDCvEAlwSRwwlcFau2+mzQ1XGm?=
 =?us-ascii?Q?2PZ4+xB871oJdCMIk4TMlI4qtHhP+nvv8TzNNnQlJlt8AnqfcB4GtmEbTqgm?=
 =?us-ascii?Q?LC/3sKJ9wHVYtJ37N7SJdjXCK5DQ8XihUkx+YsmgehEVGSL1Wi3weDxPrbz2?=
 =?us-ascii?Q?q3fd/KXmY1XA3oBRIOjuiOENcZY673iXl2en67oZhrmV6aBNyqZ1Gs6CXwoY?=
 =?us-ascii?Q?vfR37AQJOoJOAYtb2vDbCW42Iuu9TMT+RFq/8dWHoe5YFMO/eAc+vniATp7C?=
 =?us-ascii?Q?iXJ7VdiC7DNTebUcVZxU77lGtljvfv0cAvsWtFo2WKPnq6utoaV64u+rU5SR?=
 =?us-ascii?Q?wG2aPpXxYreeNPGFxHyPhWu6dYbdhJeetxfU09ZS055BDnaecOMmBVSLVxT9?=
 =?us-ascii?Q?3bOBo8Q5Q5ziS4zweUuQxYOYYfMXk1FsvkqHFK+LUamstoAaGiur4qIWaSr1?=
 =?us-ascii?Q?KVf5gWQqKbbXIQm4Gip+AemneVu9623YK4egBAn0i1JOVJ6CUHApg/zHIOcJ?=
 =?us-ascii?Q?p/BQNHs8R6tEaWN0jVuBbxdL6Mg6p5fQS5ksjjf1xOsHNDoXQKSgrN26xs2d?=
 =?us-ascii?Q?v6ggbX/jsV5gv3to5gHLW9UkvlCHqLJCiv0C+z1JmOK1hI8VGDz1fgCjur3t?=
 =?us-ascii?Q?3G0smEBoPsY9qpmUs+YQNzScjWSEWXtDPeckwZZ/tot6vEKl8YeovnGcTrcR?=
 =?us-ascii?Q?erU26IO0EuWonXLv1az/pQ7NgYXU7QHYd+1kevZi4sY17edYV3W4vGA2VdmS?=
 =?us-ascii?Q?3vnm110Slwi48JzOnKPXiiSynYCKXMBsLbdp6rL9gic9Fy/C2nefSp+gnG6t?=
 =?us-ascii?Q?mCvetdwFrRecAuP06EuG8ccFPoJ8TYnnh6ZY1NFJfeSOKpwd/PA4Sli8ys9m?=
 =?us-ascii?Q?hZvTXv58oS2SL4Ecyb7YfXAXyt2Fs+e+QS3yK0GxSAEPKAisAqX7GbD/QRt/?=
 =?us-ascii?Q?WHLX9VlWjQRsI03JIBs1qwwyW0rKcRZA7gTcFp5L3SH+p8/6wyQ0UqMOewap?=
 =?us-ascii?Q?WpaR+3tPmOSjiI7IJQBMmKhMDulMK4M14HQM+WUtMCe6AElRGY7yucoBaDoU?=
 =?us-ascii?Q?xIBhDq6W1qoLlgUXBcr/BNAU03RkkbOTCEo6l7meO0OBKwayaxZ14q3nI96i?=
 =?us-ascii?Q?oIDITGWfOaX7I9/OEbRbeTmlcN3BDY2Oi1Lzf/Eh4n0zd+c9aM59uCodevdI?=
 =?us-ascii?Q?L4hT3JyS9SB+TNCCy9bCebLW7Sl5f+J0O6r1MhSmX9YHF1xqQ8VZgja5XF2F?=
 =?us-ascii?Q?liACeAwDwyv9yUxqXY5BA3ZY8eXVjVKTcDj6HJBejJHjC9mCjqArz8lv/9gt?=
 =?us-ascii?Q?ScdJEkniLAQkrFp76BrCoHF0EI5EvrkY2PhBMIfy?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f0de155-62b7-4edc-c4e1-08dc693a0114
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2024 17:21:42.8413
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ET7ppnV3UMdLqQbyN2e9XojGALFLn+fhOUL7Ib0VqeJhaGgANoutt6nxH2dYx1p7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4172

Half the code was living in arm_smmu_domain_finalise_s1(), just move it
here and take the values directly from the pgtbl_ops instead of storing
copies.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Reviewed-by: Michael Shavit <mshavit@google.com>
Reviewed-by: Mostafa Saleh <smostafa@google.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 47 ++++++++-------------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  3 --
 2 files changed, 18 insertions(+), 32 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index f021268dab4763..3817bc99d7e319 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1309,15 +1309,25 @@ void arm_smmu_make_s1_cd(struct arm_smmu_cd *target,
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
@@ -1325,9 +1335,9 @@ void arm_smmu_make_s1_cd(struct arm_smmu_cd *target,
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
@@ -2284,13 +2294,11 @@ static void arm_smmu_domain_free(struct iommu_domain *domain)
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
 
@@ -2298,31 +2306,13 @@ static int arm_smmu_domain_finalise_s1(struct arm_smmu_device *smmu,
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
@@ -2346,8 +2336,7 @@ static int arm_smmu_domain_finalise(struct arm_smmu_domain *smmu_domain,
 	struct io_pgtable_cfg pgtbl_cfg;
 	struct io_pgtable_ops *pgtbl_ops;
 	int (*finalise_stage_fn)(struct arm_smmu_device *smmu,
-				 struct arm_smmu_domain *smmu_domain,
-				 struct io_pgtable_cfg *pgtbl_cfg);
+				 struct arm_smmu_domain *smmu_domain);
 
 	/* Restrict the stage to what we can actually support */
 	if (!(smmu->features & ARM_SMMU_FEAT_TRANS_S1))
@@ -2390,7 +2379,7 @@ static int arm_smmu_domain_finalise(struct arm_smmu_domain *smmu_domain,
 	smmu_domain->domain.geometry.aperture_end = (1UL << pgtbl_cfg.ias) - 1;
 	smmu_domain->domain.geometry.force_aperture = true;
 
-	ret = finalise_stage_fn(smmu, smmu_domain, &pgtbl_cfg);
+	ret = finalise_stage_fn(smmu, smmu_domain);
 	if (ret < 0) {
 		free_io_pgtable_ops(pgtbl_ops);
 		return ret;
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 5540609069fcd0..392130b840d55b 100644
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

