Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2057.outbound.protection.outlook.com [40.107.243.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB83A20EB;
	Fri, 30 Aug 2024 00:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724976399; cv=fail; b=CJCGDNNTfSXqrkhr+S1LH/S6e+fOTVP4JM9VljaVoBMWaMoIIcVleM/8I+NknbtPTpML2tlTZ/owXeEAPKaa6xSehkA0j7wC8Zyhq/qd5PW+giqYVVB0oX93520abfAX8RAbhSWG9B9Tc3UUzHJOLKcjMFRtDSVafEEagq2EjeQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724976399; c=relaxed/simple;
	bh=p4P+sgnOZnNh+Fh+vHCv/Qi+YnTod6Ly1HLnD3W1Qao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EWbxDhmVbFp1V8u2p0ZkAcrqpfWfMB3ishmExY3AW4F8xO3yMMjTYe88lhiAYszBXbnmnm0HnBc6Gj/+CG/AvzdHwz/mGAPIRSJRdtJQTlamjnh7ywJzXJEFPlv/JmmPMJ8w6331fDeBf3uJjJkc3uKDOvMoKXlBUeLF2ckuhVE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=bIPRUJwc; arc=fail smtp.client-ip=40.107.243.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="bIPRUJwc"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S0O5tl+4dC/cdo1NGrHq+ysur2oS1cMUyqIReta39Bb0K2PFWwb4ZbDlK/tvqAouMglTlvhM81Za4CziPSVnj+awAcl9zkVrrtdR5U4S72M/hc7uAY4hx9ph4KQeBm/CPiJCeEUExUWbOG6QKUG8BeOTeGwwPm/Iom6i74tgwfWAvPXByyZ2lqVrRGvSZ1RsOlyq0ze/izH5hKuQuJdS9PRPoUXGCSxcyWHd4oW0qJSgJhOveBl5TXtEQOMQMrFbdwacSQXJ8R3MzMRv/XiN1QEY88TNrL+5ByBfBG2obAPkKicTZd6DIoQKQIa2dBdGgZM5S6gjbxLfu44KMD9iyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VOQpTZcLODTTAfaAtaaVb+okJhMRh5DosQMIyK7nHgg=;
 b=sYFQ4FVS5IUjSFyMxDjaS31RYTYVz8kQK0w2TWdmbYDS3RCz+xgpRIa9UBvL4/mfoLiiLw2qgnZCsKqvXdrARMMrsfFwc5kwT5iAX3yTSBFqaNnzf9GXd7eu+c47zrZobPHvCupNJViURTpbra/fGBI16TLzJ7VVRdI795FCjWnzlCvQsGLBzgOfCv0WTVtkp8Jpqi2YljwCO1Rw2TE0EoRNScTffJ+GKha5iR170JBs6TK32RH00AZ4V5wKaAMVJxMMpQCaITFR3Dt9mAxKm9u6uAwHnQC+LuG9N88/lm6nZl2G+oz5+wkfOSLxWqJc/QMpleChbTtDCYslSHRVqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VOQpTZcLODTTAfaAtaaVb+okJhMRh5DosQMIyK7nHgg=;
 b=bIPRUJwc8mIvAgzwWJ3GcXzIbupvZqLJh2oVoTrt5tv49LRs0gosvGndhu6R8VGm6sZRQZEIjG3PqeQJDPmJ0RgNy4toW1V4prXQw5/oumGYbAh8LKHXo5ru0feCScbGBrN2w+E66UFVLUQ3C3WWNEIZ+qSQthJ/qQUJpLYNFDgy7WZiSVkq9HUiQlIxmSS+9MLMKj4+82xzKalaO2zpoeZTHsvhH/kzwAcrL23KsDPbB/aRqFBD+0FJ8hEOi9STmz9YfAc2gxO7e46YHSZQBTapeTSwnwUyOzZVtuAkw+XqjWQtd8aPhdK4tzWx3AVigIJuD2+9GDvAOaSeYRim8g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by PH8PR12MB8431.namprd12.prod.outlook.com (2603:10b6:510:25a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.28; Fri, 30 Aug
 2024 00:06:30 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7897.027; Fri, 30 Aug 2024
 00:06:30 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	Joerg Roedel <jroedel@suse.de>,
	patches@lists.linux.dev,
	Vasant Hegde <vasant.hegde@amd.com>
Subject: [PATCH v2 03/14] iommu/amd: Set the pgsize_bitmap correctly
Date: Thu, 29 Aug 2024 21:06:12 -0300
Message-ID: <3-v2-831cdc4d00f3+1a315-amd_iopgtbl_jgg@nvidia.com>
In-Reply-To: <0-v2-831cdc4d00f3+1a315-amd_iopgtbl_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0502.namprd03.prod.outlook.com
 (2603:10b6:408:130::27) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|PH8PR12MB8431:EE_
X-MS-Office365-Filtering-Correlation-Id: edcac898-6d29-464c-a21e-08dcc8879652
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?nVWiq45c1rYvhOtXFWtVRgaXETara4W3VYNq0nFd2wus3vbegzENPMMWR6tL?=
 =?us-ascii?Q?IfZ3iLlyAU0+cU324mJxt2jLU6dkpYtWfhFwVEBZp8TL6IdZkOGM5VqRJ9Av?=
 =?us-ascii?Q?dpSzbWHf/xmQPym2ajJzMwkjXZoWklArnyySRsBwIOBvU0GnGfvqtS6/FP35?=
 =?us-ascii?Q?yt1EIx9t4RzzcWAVp81A97I0sC2Jhkqq46YhAmsJy/NrnyqoL8ZWvDhGDdNl?=
 =?us-ascii?Q?JiaSsdOfR9vv5PrvsiAW1YDQNCHK+f9wJUDHJKif5uOptyFfNb5n9yo+pgAF?=
 =?us-ascii?Q?ZFBDOec6AisoRgq3TdCDXP86WMGtfTjdzs4QoN2J8XOD3XfHpWmgN1PxOgkp?=
 =?us-ascii?Q?Qv4UNZShpTpPKDqyPnjMnNWIcdnSiPUbo+X7wCOFzZ8aiHbY6wqXVpqMltWn?=
 =?us-ascii?Q?UTxnJe1Oew1Sp4Zb/KOsxU1m/fTzFRWAqF0QKv/eXyYFk/0uy01oiY8ZFXUi?=
 =?us-ascii?Q?iohjuIUKEbFWKgTsM/aLeZXXAFQu8h4vyRn2EJ2Tyl3Sx6RQC27VH7oWF17e?=
 =?us-ascii?Q?vJSnmm2i4od7I1208tZJ3IL6CAr2PDWulWPB739IXU2t6OEUL9LNHatN87OH?=
 =?us-ascii?Q?nNJ3rSFxUK4ajyAS5v3IYJYOzHKGbYHxLDWO4H/hSAxqi7qpHVTE6KwHCKqQ?=
 =?us-ascii?Q?rrCX4W1217vR//JaBrjN0F/7UUarYZ7ItfalSL17es3l5lYBtRTg0IzNtYuJ?=
 =?us-ascii?Q?JtTvjTnt5NG0c8E2noTAM5S4me9SODckIvcz7xZ6CdwRJ7m33CzLcS3JllqR?=
 =?us-ascii?Q?uL/2btxugox9ePdVtcPVtXRGrOb2srlAws5ffL38La3l/+ADDH78nUb0m7us?=
 =?us-ascii?Q?jgT7mOyXrHd/BG2k49W06j2d9MX6MQO8qgNR5AHYZ6wwNaIc0T8xoWO8Ohob?=
 =?us-ascii?Q?5Pne3YtoXbdWOA3Tm9TEVlBk1N79A+w1fMnyrEyWTjo7xShVkXgFQ2X1Vi/9?=
 =?us-ascii?Q?kK5SSrALA/yjmdRWGaEYqquKOZ5lOylB7GAS0SlhNSuaGXBlNLmhtdLpvA78?=
 =?us-ascii?Q?MgXBUUGfC8i16708obPZ2VTjAeIIb0QLVV6zsU8G2paFsgsFM6vcTVdjXEuf?=
 =?us-ascii?Q?BMbvH2jGnFNS9l3+HLeyqZxju9rI24y/kmOVpVhs2KVc8X25JfPM/x3qn8iB?=
 =?us-ascii?Q?cDEhjlBcPFzc4amyiqPVoZB4psILz8cQuKcl7fxcsm9SYEjIfcg1IEYtdeCG?=
 =?us-ascii?Q?OZEmq5V2+oVrCppqbSOJAmh4yrmch5dlmNjxGVSyl12mG3lNLdRoIaQbg3W9?=
 =?us-ascii?Q?dfmbzeY4xS8AGFP5B788elok56qVh4am5K94vTzZ0Z0BblOpVC+EyjgI79h5?=
 =?us-ascii?Q?dfPZx8ewBy87U3I6zIztnhmWvZbNQLeQTOtBWbXr5lAteg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+8xL3qOOX5B7mGPCX1puwJJE97iBMuO/IxCLsdW4x6rUybWuPjn+PRDsU9PA?=
 =?us-ascii?Q?XUfp+5Yj1mAjEq9kPaOxgLv3/rYoTM2rjdmiAbOLmxGmCyFxJ8FWn/WZ4IPQ?=
 =?us-ascii?Q?rGcNaieKYENDvCSu4dQ4ZGD684Obo5XCoy++vuiulzMJLmo6+4jAOwlQ7YFf?=
 =?us-ascii?Q?H/bsqy1CToo2dM2XJmaKwWpVwQ6O5vz/l8eaWW7s3WjQUJKLUs/3YfhoVtAC?=
 =?us-ascii?Q?RmjMdn9l8p2fmaUThY4bJ4mau8nwSXnsc2gmdG31N46esjXOud+9vuBXo4tu?=
 =?us-ascii?Q?kfaqxTnlSDXYccuvzYE21jUaRHncfv0+aim3urX6U2lxISj/4KaPC4R9gsHs?=
 =?us-ascii?Q?GozXXcj4pUUi38MLzxsWdigNDK1ksYoc1v78EYRF6atObls77WJavgsghZXx?=
 =?us-ascii?Q?Socc7s0dQOclXaERrjhVXJB44xgnr8HzlkZ/CGUjxgDE1AR0c9zrP3FRtz1A?=
 =?us-ascii?Q?pG6R7hnuf+9NTQjhgoZ6hXLsVH1iorZpBtjsSdR5MJ2nzhjd4zJxfrZm42SS?=
 =?us-ascii?Q?8PIdHwuBsJwt4PLlahc7gsF5h7OOCeNk17W/algMvps81I8mZlaO6asxv+XW?=
 =?us-ascii?Q?II66O8twtuWtoZUSV9iauBoU8YDFx3JXLlUmMOhWnTtO6tdrwfqcq9QDoIMX?=
 =?us-ascii?Q?aloOOEbp8c8KxnRMYcm2eVBAHwwUSTg53bos6emGjyn6m1535Jnk258HfXbO?=
 =?us-ascii?Q?02yDBj+C0oKL1i9DXObGK02LBvxw4Snm0JRi9oNuYSfrjVCDDHXFOYNSAVw5?=
 =?us-ascii?Q?ptJKsd+yzoxc4RBEr4SFtGr4Z46uhBrGuvqTsTwZKXdvJXyCOlkjmf318J35?=
 =?us-ascii?Q?XhGHcqJEyjHPTy6Osy8ShuYamzoIpUqmfJh+ycDEXf65xJYZLLo0VSHyCrSi?=
 =?us-ascii?Q?6HU0/l+itqwcUKW5Xkw/YSg1QY116R9OLx2YX7Lbhu8PrjJoNuVJLFI+F+bV?=
 =?us-ascii?Q?W5JaJFH6Stl8mMoZEZvXa7zcAbUx34JQJnm92HFNKzQBD/0xpK7gl2br/Lue?=
 =?us-ascii?Q?oq4T8zLm/cXAqPyJfKyPttd8jwfN2WAO8Ea7Rl3z4ODDREm8SST1zPzRNkgE?=
 =?us-ascii?Q?kL2Ca9ARYeKwXZzHI+ALtIN+Zl/opnGpPQa/t6ALoY4tkmS/I1CCi3VuPTlJ?=
 =?us-ascii?Q?4iVCPV4o1F79yEREk+pvt+a2ecEmqcxXtDsaECXnpWh2sZdsVr8k0nWgt6V9?=
 =?us-ascii?Q?OfHYpJubIW/KCO9IusBHRE+Eb455ySxAOJcTPnx5eckW0Hpiui9x1tuhH5vC?=
 =?us-ascii?Q?QHM8cT0mNsNq/JE8TDgLdE5ZPAirftszAkxwDA06lzv1moP+R5QgP3gRMq8s?=
 =?us-ascii?Q?g5EqZ4VyaJsLAUq7h0DxBIkeRNVnpcWxo6Oltn1rRVTFfmD8LnTUHePVIGru?=
 =?us-ascii?Q?OyuxWwq+FMB+hLFQ8TeBB2OucpotogVXdBQnrRlgFxAPG4dGFyQJKzj5s49c?=
 =?us-ascii?Q?MqJv0QkBV4Bee5Epuzg8IE4Cu1s8pt994Wr4Mn69KeOIQ2tyVYtETtuX0TEe?=
 =?us-ascii?Q?+o9kaGzbsd3wdA1H18opBlJU7FC7ZiWif942c4AHsyWVNudQM09H7vQ5nO+d?=
 =?us-ascii?Q?8Bol16GfF9woocz9IwbiQ8RT6D1lcw64RcXtFzvy?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: edcac898-6d29-464c-a21e-08dcc8879652
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2024 00:06:24.8707
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pEGVN2g46qXsvLmZ7vlN0oLSNILNGn8zYGbPtSSMTr2zFiSgQcdZQ8Pn4xQFlkea
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB8431

When using io_pgtable the correct pgsize_bitmap is stored in the cfg, both
v1_alloc_pgtable() and v2_alloc_pgtable() set it correctly.

This fixes a bug where the v2 pgtable had the wrong pgsize as
protection_domain_init_v2() would set it and then do_iommu_domain_alloc()
immediately resets it.

Remove the confusing ops.pgsize_bitmap since that is not used if the
driver sets domain.pgsize_bitmap.

Fixes: 134288158a41 ("iommu/amd: Add domain_alloc_user based domain allocation")
Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/iommu.c | 28 ++++------------------------
 1 file changed, 4 insertions(+), 24 deletions(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index b42e695af6dbe9..e53ffb86c3d09b 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2269,26 +2269,11 @@ void protection_domain_free(struct protection_domain *domain)
 	kfree(domain);
 }
 
-static int protection_domain_init_v1(struct protection_domain *domain)
-{
-	domain->pd_mode = PD_MODE_V1;
-	return 0;
-}
-
-static int protection_domain_init_v2(struct protection_domain *pdom)
-{
-	pdom->pd_mode = PD_MODE_V2;
-	pdom->domain.pgsize_bitmap = AMD_IOMMU_PGSIZES_V2;
-
-	return 0;
-}
-
 struct protection_domain *protection_domain_alloc(unsigned int type)
 {
 	struct io_pgtable_ops *pgtbl_ops;
 	struct protection_domain *domain;
 	int pgtable;
-	int ret;
 
 	domain = kzalloc(sizeof(*domain), GFP_KERNEL);
 	if (!domain)
@@ -2324,18 +2309,14 @@ struct protection_domain *protection_domain_alloc(unsigned int type)
 
 	switch (pgtable) {
 	case AMD_IOMMU_V1:
-		ret = protection_domain_init_v1(domain);
+		domain->pd_mode = PD_MODE_V1;
 		break;
 	case AMD_IOMMU_V2:
-		ret = protection_domain_init_v2(domain);
+		domain->pd_mode = PD_MODE_V2;
 		break;
 	default:
-		ret = -EINVAL;
-		break;
-	}
-
-	if (ret)
 		goto out_err;
+	}
 
 	pgtbl_ops = alloc_io_pgtable_ops(pgtable, &domain->iop.pgtbl_cfg, domain);
 	if (!pgtbl_ops)
@@ -2388,10 +2369,10 @@ static struct iommu_domain *do_iommu_domain_alloc(unsigned int type,
 	domain->domain.geometry.aperture_start = 0;
 	domain->domain.geometry.aperture_end   = dma_max_address();
 	domain->domain.geometry.force_aperture = true;
+	domain->domain.pgsize_bitmap = domain->iop.iop.cfg.pgsize_bitmap;
 
 	if (iommu) {
 		domain->domain.type = type;
-		domain->domain.pgsize_bitmap = iommu->iommu.ops->pgsize_bitmap;
 		domain->domain.ops = iommu->iommu.ops->default_domain_ops;
 
 		if (dirty_tracking)
@@ -2850,7 +2831,6 @@ const struct iommu_ops amd_iommu_ops = {
 	.device_group = amd_iommu_device_group,
 	.get_resv_regions = amd_iommu_get_resv_regions,
 	.is_attach_deferred = amd_iommu_is_attach_deferred,
-	.pgsize_bitmap	= AMD_IOMMU_PGSIZES,
 	.def_domain_type = amd_iommu_def_domain_type,
 	.dev_enable_feat = amd_iommu_dev_enable_feature,
 	.dev_disable_feat = amd_iommu_dev_disable_feature,
-- 
2.46.0

