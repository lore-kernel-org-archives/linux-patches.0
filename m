Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2042.outbound.protection.outlook.com [40.107.220.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B7DA211A19;
	Fri, 10 Jan 2025 16:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736526913; cv=fail; b=pDsRF8GVQy455/pzddqiTxfjPBH2+EKKxwpfZ5B9pTPfK/aHyqCtqtpLOfkd1oBgDdvZx1jna/jfHREULorEKqf4x5okvPbW51S+ZNYmN8uCKKFjHB5oTddoFwNZQcXDvvhLrriPz3L4nv1vjoSSQXMN/zBBM1iKD3ePfMFrBlU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736526913; c=relaxed/simple;
	bh=SB2OG9N83MADOogoW72l7b6jqsILSkTfn0kg96qgztI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Xbak2hZPXzd9ynw9KFcJQuLstDApiP1nt70U1I1yKaCk5G4wS62AmSloXHrGgBfhi+COJ06kItX9R4nxgR1PTqOD+Gaodsks1u1X+j5EhlNc8pVRVaDIVLvvbcFQFLq0kUs9d1sLhklgYKyCknbLVlxL+nQ+5ymLjF3w4AKPob0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Ofqp/5r/; arc=fail smtp.client-ip=40.107.220.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Ofqp/5r/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UqgR6adxLnoAg0B+a4HTMobQ6fHxaegpa69wQznYUpqfG9FT6cVAsn3ND8CXffpmxroi7VWyUu9j7jyGOxDTXZoiA26Vgp2bzp4Cu7oei44eQT0uUWDxfa2Ye+nYryEmwiWmHjLKURgfUyXtHujOsuwxy5zyWtUfVS/yiq0x0zKY5WoVLPxwLeZZfJqWPhVpV987KtuQ3k/3QJs21FdgND39KCaEh+2UU6VnHTCnQs9CJjHmoJqMXVGmXI6EmRvQNWckDQ3WUS7Gmfi56Gqys+gaMekgRvo65Qcu0GxBKb4PlI4xb9f69Q4ydizYoatqXrN+n+Jt8UwUASFN4ry5QA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bAXuAXjU4E+YnoWG3lWYDKeOMlLNA4ouDk+An79wHTk=;
 b=BWxxe8sbqUL/nJglaB1LKDEzXR4uHBqlGwy8wxM//A5zBa6PZLtGZ5gSLaBLrDRZpb8vbxLHrWrtTtFDIwbkdphxVDG6jqFR72r2dNgRgkQUC/hmkN2JgltWDAr6JyJBBj5hFhc7Sj2+dqy/3tcQ4D0NCenhSl8IIOEHva0MOneXChI9DrR7xKS2VeHSCq49k7CBrHmcdHOy07bl02WJ2nAtXDqGu/1TbMHsxhgZBHP8Pv3LGEs0wxFZu3KIsZ+l67H97G2cqEykp+TDAW0yD0OoP1Bd5KXuvfTFPrCN/r8my6s1CAHqSmDr6Z9J1JZjm2JYr9RvF2XV73NCFdcaaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bAXuAXjU4E+YnoWG3lWYDKeOMlLNA4ouDk+An79wHTk=;
 b=Ofqp/5r/kgS5ntsZTepGTaXToqfN51IYqdLr/Q750OIy8wriHvLnByum7Vt3JCEMNDY1DDiPPaangQic0oc1GHV9C6Qbc0+JqeTOBt77eOoXrLPWOQig2Jzeh6VidS1GqsLzbCqv5DONkPQw2rlhtJOgqLmVj/fMKd3ZANqMR5lQdOd3OfnkpzJoYdVruIsT2tBW8ihSVjpLWbMd4unzzW0jbD8TsyTa6auLYJMWEBur0yxD5IjkoAQe1hbEf31haatSozd/ew5XnYU40wZ31oCViSDSfowPvvHcfWvcdLAft95zCmrzYTU61xLPNb0TNotLR4AIGQU4707s65MYOQ==
Received: from DS7PR12MB6120.namprd12.prod.outlook.com (2603:10b6:8:98::5) by
 BY5PR12MB4259.namprd12.prod.outlook.com (2603:10b6:a03:202::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.12; Fri, 10 Jan
 2025 16:35:08 +0000
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DS7PR12MB6120.namprd12.prod.outlook.com (2603:10b6:8:98::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8314.16; Fri, 10 Jan 2025 16:35:07 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8314.015; Fri, 10 Jan 2025
 16:35:07 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Joerg Roedel <jroedel@suse.de>,
	Kevin Tian <kevin.tian@intel.com>,
	patches@lists.linux.dev,
	Vasant Hegde <vasant.hegde@amd.com>
Subject: [PATCH v2 7/7] iommu/amd: Fully decode all combinations of alloc_paging_flags
Date: Fri, 10 Jan 2025 12:35:05 -0400
Message-ID: <7-v2-9776c53c2966+1c7-amd_paging_flags_jgg@nvidia.com>
In-Reply-To: <0-v2-9776c53c2966+1c7-amd_paging_flags_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN0PR02CA0037.namprd02.prod.outlook.com
 (2603:10b6:408:e5::12) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic:
	CH3PR12MB8659:EE_|DS7PR12MB6120:EE_|BY5PR12MB4259:EE_
X-MS-Office365-Filtering-Correlation-Id: 0210a5c7-65c3-4a2e-cd9f-08dd3194bdb6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cb4/dWlQI+26u8/xtt2X1JLnW5sQTMKclaAho8yRBdG32HTqYFJ/8Hg70W8T?=
 =?us-ascii?Q?rDw2M/2WrQTHSol2A3RoXWUxh3SEanbkrAjd/FVgHBh4E2mtdk0af5fDl+Rt?=
 =?us-ascii?Q?mVtp93rEoOF7oOXn6/pTYmF8BsC5XD9ee+YFQOvYB/nWfn0Psj4GcmK6WTOi?=
 =?us-ascii?Q?5XCeZ0YTBgXUsGrvIbZdr1zwlxvy3vidwWEE+9GcdjUIu6pTCYECTtaLhGcm?=
 =?us-ascii?Q?QwtZRNRzQCbJimJv3rxJXhRx+WxMMLg6Px9DwtpoblAW6FlBDPe4jnyUoaPc?=
 =?us-ascii?Q?tjXZZI6y0o9MgmKEU/TZkS8x3Yi00sEJrYb8nYZz/eQXT+pDBGNdX0fzAktX?=
 =?us-ascii?Q?5xJE/8Gy9r17SBgvFV3D7E2ZYd3VthpXzt1Pw0s4+m6K6S0VNyOJSxVxfp3d?=
 =?us-ascii?Q?yWjSm4iLpljSnFEsywaQ9EJHLZQqJqGSWN9R/faTA984qZYVBV8LqziTKM5q?=
 =?us-ascii?Q?OF8wUgrSP2/mFysw+omV8qFQRE3ZZ/UllKGzztxrDrOBQR5JNJdSSi5kyQcO?=
 =?us-ascii?Q?LOG6TQredI59asnoiPDAbWWa/Zwo9h9R8n51wMaKvv7ZbXIePivVNzfo2Pmb?=
 =?us-ascii?Q?V3f1Ak8Is53VQK3GyLuk6SOVPDRq752WZx2DetVD7x9n/axHdzTgr3Njld2v?=
 =?us-ascii?Q?FT7NE+0motFIjoQev6Lqu3qObEqK8O1vQXckrwSyxF1cGj85Hx2eu3CahI84?=
 =?us-ascii?Q?b5HxSoNMzHk1R59vfjujpizmVfX45apBRxnk1tcfXOWIrbI/935QEDYPj5Hh?=
 =?us-ascii?Q?L344CEuEVT4VAN4RDq28TqKyxclYelkVMVwnW5yfJyPLvUbZDIKGrJk7T3r3?=
 =?us-ascii?Q?FCmgtEVOqlk1ccHikhPPP+F/3OWF52S8rHBsyhvrBnq2/HDWD9Em2rbmGTpa?=
 =?us-ascii?Q?jvND9lwvx36rUmKZw9BHY1lsX/YZvP6oFZtdUwTN25rCXNpXkwL8CFN5yTzb?=
 =?us-ascii?Q?ydGhb+WpvROxQ2is42pukKJ1z2/DvbJEQ5lNbCxEUxSk6EVuDJCSbf+8TJT1?=
 =?us-ascii?Q?YU0F3tSwiVzpJzoo2rSxneaQUcj8RxWYNpbl1yW0f+oVOb0sLcxeFeb9kcuM?=
 =?us-ascii?Q?xwjn2ylcsouBLShRkqtmkVwbz4+rqMJoHY1D0R2y746+EBuaEDOwqIgosS49?=
 =?us-ascii?Q?2uSRyNNVt3nwNKoUbGR/CERw2TXpWFJsB/jnySud7odlQAkAopeAFLNVo5Mm?=
 =?us-ascii?Q?rArokRJOaeR3qOp5J3UxY5Rqhs/8YovU6WPFvPqNTomjI+Nnt/rkh+x5rwpW?=
 =?us-ascii?Q?N0xXvwS0hSW4t8L2ECEVtSERPOPqQ3TRIF8xPkKe+6fwQsFTCpZ0iqpmxHs1?=
 =?us-ascii?Q?cLE0KO1O3QfU/TPlgBkj4gwMdw2lYLjavON7tEcCSQxTBAkSuuy0XLKuYsKv?=
 =?us-ascii?Q?q2OXGZIfYl8sWyBCt4/ZZIzTCXJD?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6120.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TwXECYOcmAnFC7rWjZor0f8q0lk4NcF9gDWCza5j7NST5QERjf+PtaH4f126?=
 =?us-ascii?Q?aNHUWn10auQT2Im0ZQmzE5nepBlklrIKqnMFoL0t3qStnqxDV9zf9TlF8U/e?=
 =?us-ascii?Q?FSRwxtmX2ZemgM32io5BP2et40naP57l0vaspF1UefI4yjnPYYLB9V9PSHlh?=
 =?us-ascii?Q?w2JdxHPe2PHcsvyH4ZWm+TcXFm/EScE4lB+5JH6NFjF9AZdgDB43UYInAjGL?=
 =?us-ascii?Q?BMhF/zSMdDkbeeDLCwypij4eWImOzPk1kGzanFUJ2qiesjCWWghJVgStJIpX?=
 =?us-ascii?Q?lgQN1toaNuwGk2WpeTujZvBPbmWXfRIQV2dZeOZ4p9PuQP78C1dso5U/Fn/t?=
 =?us-ascii?Q?t1SwC6NVfS5hHhvwG6EAdbKj8IPn9FnV/sIABK+wGoVKjwCU+21Cc4WSymzV?=
 =?us-ascii?Q?PpCDh2RsNI23GwD7Paj3Egf/Jw5qfSO2Wsbcp+6JFxAOdVilnQZb97uilmiJ?=
 =?us-ascii?Q?g8WVSqxoNbVUk2Ic2j0pA+8GbA6oL56esbS4SP9DyY2RQb97ilehWXFoyVV0?=
 =?us-ascii?Q?N+rLOASyU/nlnvYqst51YJcsmtno/m9pL7wWJ1VsJp5LElxLgYALG8AF0Ynp?=
 =?us-ascii?Q?/SCvF7OoTizqNt/JPWx+XxMpNiCFZ3eekYtkmbMdxosqegipiQPfzKvJKmtJ?=
 =?us-ascii?Q?vJ4fuWttA8ni8rW0LW2GtA7SLEqk/9qUeStmNVUjdt4Ot7pZgNPTZ5PiBF/1?=
 =?us-ascii?Q?walkSEuj+QEMzINHSuPo9T7bwM80WjntoP45JWdXdZR7cULwXGK6Io0i977i?=
 =?us-ascii?Q?9E1iDSsATXmLMfCOfVWz7/avBl2/kF6jgYaBySPe9Z1ZMp6a6ZIfaZVYmJWH?=
 =?us-ascii?Q?ju5sl1narT9aQJlvsiP7a5I1j/tJBoCXEwflhkVW4QoEbEqkvAq6vbGQbuFe?=
 =?us-ascii?Q?iYky9ndVZcWZuezIHkfyYRrBrydvrksri8kFOiEtONLw1oWWSs4u9NXpfdq2?=
 =?us-ascii?Q?FaiJZ1aaLwfGqSGh4VHI6Zre5yjBol3LxK8oFSESlSf8Qyq/1e1VEhMjXnN2?=
 =?us-ascii?Q?jBAQSukH4+lE7j7AcJ8OqcU9vWYCrf5ApCks6y1A4iKOmsmCQsvB44RfpG5i?=
 =?us-ascii?Q?49obRwGU/indJkUG26uNGzjlv7Asm+hTYJSNMHP1HpWrehUk+1i4NLwIzKB4?=
 =?us-ascii?Q?9oTD+zNxgdLWa82uU0oWOtDAAe18QmEgerhdoGTFFiPg5ha2ud4E57+xVX94?=
 =?us-ascii?Q?1ORu6g9ynMsRbCCL6rKgfZrtuD5nd/eeZB7dKUKB5J3Ib271swdmZOtnFz99?=
 =?us-ascii?Q?B8xiJ2KdK4nmiqOpJCh/LQP2HgSLwwUK+n+z36VQFkPD7k8F4ZnrUkXy8GmQ?=
 =?us-ascii?Q?l6i/dHnkKGMHGDQScDcERiT5xhvm5NbeUexxQvXpqGL/T4NFPGgq/OYHonVd?=
 =?us-ascii?Q?o99qoXXQOkoVbwZuF+FYVL+z/S7cekaUAHhUNmdjc7cVXVkjuNpNsFziq9C6?=
 =?us-ascii?Q?W5XsKvMo7uA1b8VADdC0FqLRSTJPdHXGskjyO5iO5X5InWs9m+ixpyPZCXPy?=
 =?us-ascii?Q?uGh9juBjit8/JiAla+ai5FQtx+/ei0Uuu3MHHOm4hoFH3fN4tWByW/Z55X0q?=
 =?us-ascii?Q?SLFa7F2ejTr3uiRvrxv87QXdfRlYTyW1tJ4j/g4h?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0210a5c7-65c3-4a2e-cd9f-08dd3194bdb6
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2025 16:35:06.6009
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CsibRFtt91xd4Gazm2SlbQDezeWEjsTM1h/nqo5A3t1+LtayjWXvGAbWOqJyjLI2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4259

Currently AMD does not support
 IOMMU_HWPT_ALLOC_PASID | IOMMU_HWPT_ALLOC_DIRTY_TRACKING

It should be rejected. Instead it creates a V1 domain without dirty
tracking support.

Use a switch to fully decode the flags.

Fixes: ce2cd175469f ("iommu/amd: Enhance amd_iommu_domain_alloc_user()")
Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/iommu.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 7d7317dae2528e..d75f1b13b3dc73 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2554,24 +2554,24 @@ amd_iommu_domain_alloc_paging_flags(struct device *dev, u32 flags,
 	if ((flags & ~supported_flags) || user_data)
 		return ERR_PTR(-EOPNOTSUPP);
 
-	/* Allocate domain with v2 page table if IOMMU supports PASID. */
-	if (flags & IOMMU_HWPT_ALLOC_PASID) {
+	switch (flags & supported_flags) {
+	case IOMMU_HWPT_ALLOC_DIRTY_TRACKING:
+		/* Allocate domain with v1 page table for dirty tracking */
+		if (!amd_iommu_hd_support(iommu))
+			break;
+		return do_iommu_domain_alloc(dev, flags, PD_MODE_V1);
+	case IOMMU_HWPT_ALLOC_PASID:
+		/* Allocate domain with v2 page table if IOMMU supports PASID. */
 		if (!amd_iommu_pasid_supported())
-			return ERR_PTR(-EOPNOTSUPP);
-
+			break;
 		return do_iommu_domain_alloc(dev, flags, PD_MODE_V2);
+	case 0:
+		/* If nothing specific is required use the kernel commandline default */
+		return do_iommu_domain_alloc(dev, 0, amd_iommu_pgtable);
+	default:
+		break;
 	}
-
-	/* Allocate domain with v1 page table for dirty tracking */
-	if (flags & IOMMU_HWPT_ALLOC_DIRTY_TRACKING) {
-		if (amd_iommu_hd_support(iommu))
-			return do_iommu_domain_alloc(dev, flags, PD_MODE_V1);
-
-		return ERR_PTR(-EOPNOTSUPP);
-	}
-
-	/* If nothing specific is required use the kernel commandline default */
-	return do_iommu_domain_alloc(dev, 0, amd_iommu_pgtable);
+	return ERR_PTR(-EOPNOTSUPP);
 }
 
 void amd_iommu_domain_free(struct iommu_domain *dom)
-- 
2.43.0

