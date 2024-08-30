Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2046.outbound.protection.outlook.com [40.107.220.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF2F51114;
	Fri, 30 Aug 2024 00:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724976397; cv=fail; b=TztnkG1so40jHSxgP4s4Xc8AtoSOGBIWJagF0xeC3UqOAW+RVIWlZTu1zEafE2xhv8rfBB7eoOJSSU7TVeaNr/S2PN9YaBDQj2Yqtn6yA+KfYig4RQhH2VEBdD16lttbXI7rfZl1BValpRqGpeYMEXas4AZH/a+cWwxYvK0e8uk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724976397; c=relaxed/simple;
	bh=yFt4kEQUcIwPiv4tZffoHNTFdkRMu3L4/Tmdw5x8Hg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=abPX0Lu+qsRHhI2TkUvq8qqOYnDBlGuhQP1KZYINsb2A55PZTftSTfg5JcxqU4iQ0IxoVKwJpXNv9vf/ftcn/tBJGTFxUum0cwgpS98sbiz5pz/39QanjrhyGSICCYcJJDSEb53Ia5ALaOiY21nGTOiK+Cdt26RB9GyrjJcc2os=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=eKOWmdiJ; arc=fail smtp.client-ip=40.107.220.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="eKOWmdiJ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SM+Ge+ShAppK/LrVl9kvrkeAZ7CIdRcVEHo0nAY9k5YXRD9NZ24WR/P4pGC1ekesE80DmKw3qaGfWjFJShZXNSepztcqkiZg88FYVJSoi3nTABCYAQnJBUMKBOqyn7YHGrIPZzt4c2eEp3j50x6UR5FDtUrmoiV+S5GHtOAwtIiisroG/EIhN+1i2Obp+eDcqtCY9ikzXFdSV7/4CeGGsUlgWIuGdqLTW0tfe6DrJrrYfUcEFA7HR51VSfOOr8JZbvrGLHhrBbaeyIkQXSGhE2qcKBp/ThbnDpBxs4DR6/ng4wTDorNIyXEAygEwoEA6c0k8Rg8GazYLL2BEHAqK0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k/yizIUbS1DqdtuzuVBMULXO6x4bL2suZRdia8g5abU=;
 b=j49oot2vNddBlSbwn41ddsTU+f5UKR7ZRiRAlRXFgmXAViQApf8hAHGDS8y/QrZzbEub+2eB9XSajybUaQAf7fw4BlR38uWGY/zsIgLlNEDFNo74MlWznEJu3D44Bb3aHkkEEUTUK5GN7m6VzjCLY4WsyzqPnaihti5PFBOeEwSGzjwXZrDtcGurUuC0PsuGnYD4Pv1aJVA0BS6w/dq5PYkpHiHgD5OyIghxD1uJ0LzaYg+pgK21un10jPiU24wj8kP+cRklqNOaIm3t7fYQtJ+nY3Dr6n0fyHErmb3HfKcq/Vi1uL3MtBnm1Wf9N3hpgzj2RIdUXlXQ0BkCyB4JUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k/yizIUbS1DqdtuzuVBMULXO6x4bL2suZRdia8g5abU=;
 b=eKOWmdiJIatkFrF5P+SA4nIpIAHrgzBq7fRU70veh8TMIzpoyc38zXcoaUvqaBR/cm7R32NrUPY6ohy5azFK3L2o6DnhZzjFc7SxIutzRYyEXwEQXV+2f4uRf14eCPt6xMIpMmMG8dGNgU60nQy1agdtAuD1lIaoXE8lyZnQfYpNpPx0+otp/BqqtANNFoF5qTmIPSTgOekDaUzkjr2WCoOIFqNvd9YwZEozItszQDcOXXgYtjBWs3lBld7a1kNNGWv+uiHs7c+M9HmtT5XSNDEm8rHYr/ANcLmP8x1XvT9RkXppw6HXUmm3ojGYn9uQvQ6VwRgey72Fcm1cA8skWQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by CY8PR12MB7415.namprd12.prod.outlook.com (2603:10b6:930:5d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.20; Fri, 30 Aug
 2024 00:06:27 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7897.027; Fri, 30 Aug 2024
 00:06:27 +0000
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
Subject: [PATCH v2 07/14] iommu/amd: Remove amd_io_pgtable::pgtbl_cfg
Date: Thu, 29 Aug 2024 21:06:16 -0300
Message-ID: <7-v2-831cdc4d00f3+1a315-amd_iopgtbl_jgg@nvidia.com>
In-Reply-To: <0-v2-831cdc4d00f3+1a315-amd_iopgtbl_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0509.namprd03.prod.outlook.com
 (2603:10b6:408:130::34) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|CY8PR12MB7415:EE_
X-MS-Office365-Filtering-Correlation-Id: d7a63dfd-667d-4718-6d73-08dcc8879616
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5wx6DesRoN2weV6UkcTX+z72u+ImUKVVCjEy/d+oTVZ+ZZqtnYdmMWRc8J1X?=
 =?us-ascii?Q?xDXhXITdtP9IxxLZl4FCoHadH426YBGUAIf+Jboy0Aoy9Uf2MzyfR+nCXsUc?=
 =?us-ascii?Q?LyOyE1MHvWmqYZnjGbNDgEBbjvl3tM6txduzUbO7c5WzCAYTFrRHrrg7zwXF?=
 =?us-ascii?Q?9GNKnVz8Tzz/W5JQHjkwpnIufM2StU2KHro9F3I5QxGrUecWn8SfrM407c6o?=
 =?us-ascii?Q?8oamY4074pKH21BzoL8NBoC8GgUpaLiqKnuUo2bs0FkWVefp6SQkVFZR2jFO?=
 =?us-ascii?Q?iSTvGLR9Cd6XIBy8anpTvnOtd7HazPmHhMm5Iwfk/iC55tEyiYKNfmtyHBfK?=
 =?us-ascii?Q?rMYnv95jELvFpth1I3ZJUpNcC695XFH+almirDqTpXZ1RDD3g4/9RlXD5I7o?=
 =?us-ascii?Q?Ry9oZQpCdsEt0Ah3p6pnuHCzAMIBfB75/L4PIJ0T+C23R/I/lpaM68CFP7I+?=
 =?us-ascii?Q?FBYbG/hiSm8v/2h821mpLjGdpmKDbI7+fig+L/FECBGBajTTw6SfMfc0S11Q?=
 =?us-ascii?Q?/Zllf9zxFkUkgtEzVpjobO+15f1pbYi1P0jJhaf+bKhBThw9xK29PrQKxXVI?=
 =?us-ascii?Q?19VFwFq92fJ9Am6eeCMWM30mHLXDSopBDzB8qdMcf88B4pjvWwzPXztqc5CV?=
 =?us-ascii?Q?OCjCAeV4gVTleHunQH11Ky46rhDZASaaFC3EHWJzvrmY3dKFMBBq30gluRYX?=
 =?us-ascii?Q?RIW0k4VfhiyIl+yaPTYbu4Ewl1Ugpnt1KwMeJ63/tqr10tdwf2H+OoF0rXpn?=
 =?us-ascii?Q?3Tp1+LqXnD5GVzfxvL36cHjAjfmcuneMqHe2jaU5Jwmy7TiVGYM6G9rGYdqj?=
 =?us-ascii?Q?qkhHX9JCXXzie/MXWSSDai1o+5RVSoBwXQFI4hnkeaDLfxspz08ICwzPWRg2?=
 =?us-ascii?Q?3b6YKVNpMKnzP6s0tVZMQIIUyjj3ASOVamp779XB8RYZPpDoVzMfl1hUyNH8?=
 =?us-ascii?Q?ZXzoV39mDneF/C+xVBYBw7EusF+O7y2l6hAFB/LISDtI8QKRLNBMVPz2c/Gr?=
 =?us-ascii?Q?j5gkXPIhmACkuU4Mw+zSqo2rdTWObZokpnne/iFuqX0aMouEpO5iwyYVH0B6?=
 =?us-ascii?Q?PDQ/hrU4TTDwlS5f4789chCxU7Gg1EvCmVhkzRJqFQfiXzdxpcLCtt66cSmN?=
 =?us-ascii?Q?ZQmkYIIrX0J/vsqOlBnxb/sTko/QEA86EtzYjUzCtfuknEZw5Bg3R7btpt3P?=
 =?us-ascii?Q?QWtlKY3Syy7Hx3hKs1oP0EvAwVAzbiq4ui7CzBF8rQAWFk64UEu7KK0ExvE8?=
 =?us-ascii?Q?OAyJeB3KYayXPIO+qijBBr/I6eXbGgb0p9yvXicNe+V5nWy4tx3k4/BAMzrs?=
 =?us-ascii?Q?dG169gLv0cTYo7oQX1MzX2w70wbIsFnkUl+vTJRI+oeafg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rocdzxiIvJGahbdNb7/+B9Mh2dasKdEmb2CnaqdhSUdBueI/zUDPK4XlyM3q?=
 =?us-ascii?Q?L7j6TiP5x42acG87lbDT0365omFcjRXq2jT2iCHLSrESUeyemt8NdHcpldkN?=
 =?us-ascii?Q?UN+SqCzcKXzrDTiNoWAxTZ9dAN1IDdKA1QPJpZx2g7ZM1cm/8rsRSHXMgasZ?=
 =?us-ascii?Q?jurs/1tqr5B7/QGRmPgmdgnKZ6jAl85n6MMlzydq2TkWQ5dIz7HQ+be3i7Ls?=
 =?us-ascii?Q?0dXhqf3nRtEJvsRg+F/2KNi+ro4AwAvQK3nEfo8Bymmc5jvOeAQIonrKcnVz?=
 =?us-ascii?Q?iw2QClxgN9eeeF6TsfoRXt+pAPHtgAuXtkXgFIn1lGdLfXr9bJYB2nmh8PZF?=
 =?us-ascii?Q?BsUerRnv/lYBOeqBUYWcd6RwysZk13MyobftgSjgU24oXu3Luq75jeyJ/Khe?=
 =?us-ascii?Q?KbHxbm/RD1X6yAfEkYJrXiW06n/n9a27sVERL/5dHH27KNMwOVxTmjB3F4t4?=
 =?us-ascii?Q?Qnc+9ovXtISikStGZDRkh2EOZgxAEeHe4mdIuRpHPGXzsJxVDo3xBUruTZfp?=
 =?us-ascii?Q?rAtUrs5gK04rwe/MoCP+LEpuoz2xUnxMsq8VcH0W31dc1tJua2zul87INGNH?=
 =?us-ascii?Q?guX559MkB5o+tRNAtblcynd79JxzlPTbaEJ9L6dMaoXgpXzCigklpwJiwJZy?=
 =?us-ascii?Q?GA8gFrV9dp1pnGKm5ciPm8jyde+oo7QEACEJr8KCgNQGk3xy2FOt6uu+xa+C?=
 =?us-ascii?Q?wCwxkhWKD1x1pu/pezJoeY+/uP0MZcuXFgP9bUN225JHY6VndrlDwwyYBubd?=
 =?us-ascii?Q?Haicj0QRp+2Mz4NMkqBU03fwRFYTyrWLJLlwBPd4seVFAS5ZCU0GNYLheIbc?=
 =?us-ascii?Q?NNMDNOWfdJZ6kUBUEo2scDiWbu1bo/ebTL/NnhY4BvtVmdWl6TsKpnwCIlLc?=
 =?us-ascii?Q?O8Je0/vwpfQgZep2Trjv33L7KlODRFXWCdD20je5uoqe11MAca/iiQoGdGeY?=
 =?us-ascii?Q?kBZAdQW0Kp1X1zfWj93PmismC+HuX2nqHDGa0Kc27akP89Vx/L1kx5ac/Qbp?=
 =?us-ascii?Q?38qhUFrg1LDXgE/V0qTl+lfeTjxCOLcL2edroJ4qUy6MHdCnJUOYoMcn4hGz?=
 =?us-ascii?Q?m26EHStsg9s0+q/8CpjQkRbMTOXRcRORaEfI140QqRduU4BNvlccMXWJRZ2+?=
 =?us-ascii?Q?u29S8dyBHUCdP020DSyigE+LYbkga9v9i9gHC8RCJxvSDB+9fx1ZXPxpqhCa?=
 =?us-ascii?Q?WbyBcabKjDROkxLoY+zFF86NRYwRtsIKmo/eBkP14MAyOWanIuV4vI9ea+qO?=
 =?us-ascii?Q?Nf9ERaJX2rH/YN1fHWXTwvsfGGaD4l0wwXqmygrAwm48RlVNR5+zy5z4OXPk?=
 =?us-ascii?Q?78acUPM3NxbEx+3hokkSudJIItFjZGHkYX1MPHPWyt4JCjaNtk/iQCGl0OQr?=
 =?us-ascii?Q?ljayXVajHIBSf4nI+lnl+zinhdHFMEB5yY30MPJXrLyns2N4FZq17lEUKiCL?=
 =?us-ascii?Q?/CZOqQnkaxZKLTxMEGA8eqmuEnF0Vk64BOMIJx/IqxEXF/FjM9iYVZdPtW1d?=
 =?us-ascii?Q?1ns36ZHOPbwRjyoxPKeAGt8y8T0nd1Au2BB6x+vM9J9zJ+MwGQMtzJwS/eI4?=
 =?us-ascii?Q?Q7za1tqOnBZ1TGTQ9ojIpq4Ve95AZsXs186NWMCl?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7a63dfd-667d-4718-6d73-08dcc8879616
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2024 00:06:24.4799
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: By37RaJheQ27Q3VDxRIevuNWEPfAwiQi94CBPj+GMu/njQlHRoXtNP/o+INnXHF4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7415

This struct is already in iop.cfg, we don't need two.

AMD is using this API sort of wrong, the cfg is supposed to be passed in
and then the allocation function will allocate ops memory and copy the
passed config into the new memory. Keep it kind of wrong and pass in the
cfg memory that is already part of the pagetable struct.

Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/amd_iommu_types.h | 3 +--
 drivers/iommu/amd/iommu.c           | 5 +++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/amd/amd_iommu_types.h b/drivers/iommu/amd/amd_iommu_types.h
index 90a2e4790bffdf..ef4c4887cbbbd5 100644
--- a/drivers/iommu/amd/amd_iommu_types.h
+++ b/drivers/iommu/amd/amd_iommu_types.h
@@ -537,7 +537,7 @@ struct amd_irte_ops;
 		     struct protection_domain, iop)
 
 #define io_pgtable_cfg_to_data(x) \
-	container_of((x), struct amd_io_pgtable, pgtbl_cfg)
+	container_of((x), struct amd_io_pgtable, pgtbl.cfg)
 
 struct gcr3_tbl_info {
 	u64	*gcr3_tbl;	/* Guest CR3 table */
@@ -547,7 +547,6 @@ struct gcr3_tbl_info {
 };
 
 struct amd_io_pgtable {
-	struct io_pgtable_cfg	pgtbl_cfg;
 	struct io_pgtable	pgtbl;
 	int			mode;
 	u64			*root;
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index e3e935b0fdf637..3840b3ede65d32 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2262,7 +2262,7 @@ void protection_domain_free(struct protection_domain *domain)
 
 	WARN_ON(!list_empty(&domain->dev_list));
 
-	if (domain->iop.pgtbl_cfg.tlb)
+	if (domain->iop.pgtbl.cfg.tlb)
 		free_io_pgtable_ops(&domain->iop.pgtbl.ops);
 
 	if (domain->id)
@@ -2320,7 +2320,8 @@ struct protection_domain *protection_domain_alloc(unsigned int type)
 		goto out_err;
 	}
 
-	pgtbl_ops = alloc_io_pgtable_ops(pgtable, &domain->iop.pgtbl_cfg, domain);
+	pgtbl_ops =
+		alloc_io_pgtable_ops(pgtable, &domain->iop.pgtbl.cfg, domain);
 	if (!pgtbl_ops)
 		goto out_err;
 
-- 
2.46.0

