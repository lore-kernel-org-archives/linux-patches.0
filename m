Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2072.outbound.protection.outlook.com [40.107.93.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44C481A7AC6;
	Wed, 21 Aug 2024 17:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724261850; cv=fail; b=ZbhC014J9QcxCaLSs2twFYVxpbBmeMzfuTp+hv/pf/OnBVqd2d/KaRrRCrrWpyacSlSjUybbT1Lyec73P4YJ54n4V3m6mCoaE8w5MFyVwrJc7pZGfDwiLkHjMgAajpmYEbRaLAmEDZ+pPX+WQrKAwu2Vwrh5U0wFm618MiGGz0M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724261850; c=relaxed/simple;
	bh=GcAI5FxPFXX8IAPzfGIuGujSRSn3MDt7IXb5GXKSS5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KPiuC5lf797glcbqcTiHZYvviKbn6RaZwua24c3Fy55sY6Lf1O6ivdZvqnkOzoSpxR5MyTdJTdSjtdB1/sTX5vLvO1uxUVMxe7+nL2IlN+LpzV7GFyFw9Qck74t9Ti1UxG/jWPNdN4PmO2foxozIq0SR/l2YkDimf/UpGhTLrhM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=iZlwtmx2; arc=fail smtp.client-ip=40.107.93.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="iZlwtmx2"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FcCkSGjDNDHAG36MDYNzDud8LhNqL/mohQnjWOtE2LE9BZOTnGSc5U10lXo9WIIxULF8xNHhYaU34ui6k8YL2j7oDn1X6hyUNfYcGm8EFRUBQ3vD88YmCJkDOz49Ti+MCS5eAVz41QWgmak20z9EeaTHWijTwjfs2tjviCWnTIMbORtBC5Pf9LgtJDTjRbN15+C2ppLvhgAErby8EZbvBX5sRoccxQAWgRdtg7Tsh3V4IGwmCZGK/TPuDHIxXkPevm3+XDhQsltvderpFG0Xd2Op6LnAuK2k25W9DTvinzYgDZAXnEcsmsqn9jAENUb6HpFsvvgSOV/X5bGZLKlX2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DP2OCN0uPdwZzszQDMh9Jl+7S1Y2JOw1VdnUdtWypdQ=;
 b=mrZMCKAObU+/rzn+zFNXpDjSkycC9hO8KUwoKJ4wQws4VKaBHqeQIQoSQZ2e80fH5Vi1amwetYfZljXbe5WTF4r37UxMYX/mwbmaQMflNK0FZexyVxTfWEASkCQBNi7OSM8skw4qcuuelZhmnoTeTg46mpAO8cFVFg5xEPuW1Ebzt6LW4slVLpqDR1CSNe/sNKX9i47EUT8Lo+0QE2Fvho/F7tOLGZPTwGrlKh/NtBp7jGqiDeKGwiYWY1VggMT7wUYE++y3vlofclLsLMyKgWC6IOA033JMflStNngfwDqs6Ca4vmWbXGrTmSIU1cdFiSpcRtmiPq2nQXp4mqieig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DP2OCN0uPdwZzszQDMh9Jl+7S1Y2JOw1VdnUdtWypdQ=;
 b=iZlwtmx2RJG+rMUp9EG+YLLo+T74yfqYyBojLQBGEswREkzCQbTuaprE4U66nQf/FsmonKxQCKXM/yg1/4EXZ31f2uM2OdRJI/mQgE2/PqQVMutK86GMyFHDmpx0cn4SbVq3BTRpHpn1OplyptDlmGHcHLdtNK1c6YNb6eoW/6ij7ajViylhu1bxRMV12PFR4UHD4a8WKr95UmR+FNuF+VrZmx4ah5IKEbXpXyu9JkUh21QkFyqzYphVtJeeJxXUOaSQEDuzd7fYEzOZwU1h6Ts5yFwJA5HpnvQZC/e43SlHbnXPT4QM/v0Z7ZyFMriPbAx2mk9bjOPnolcLDN5nKA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by CH3PR12MB9098.namprd12.prod.outlook.com (2603:10b6:610:19e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.25; Wed, 21 Aug
 2024 17:37:22 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7875.023; Wed, 21 Aug 2024
 17:37:22 +0000
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
Subject: [PATCH 03/14] iommu/amd: Set the pgsize_bitmap correctly
Date: Wed, 21 Aug 2024 14:37:09 -0300
Message-ID: <3-v1-cdaaddf80abb+14190-amd_iopgtbl_jgg@nvidia.com>
In-Reply-To: <0-v1-cdaaddf80abb+14190-amd_iopgtbl_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0006.namprd03.prod.outlook.com
 (2603:10b6:208:32b::11) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|CH3PR12MB9098:EE_
X-MS-Office365-Filtering-Correlation-Id: d4086af1-6d5b-4be4-9537-08dcc207e947
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?yR0YpZ7oJy3SAExspmA1w700gpewIfyOyfowtcUPeRGvfGraZyDnyBLzBDPB?=
 =?us-ascii?Q?e2EM+uGm2DxoJfINgRCq0ptW0jZzFQUnSK4d/sXG8e2EysUyLLLNlpfj0T2v?=
 =?us-ascii?Q?Ovvly69tQ5dkEONSfjO9uPGDI2hUyUPoytCOmODYh96DS+c5sjZy5gNNaaCt?=
 =?us-ascii?Q?Ceun/oc5SCqvau++NCv5ZnlzstMtoNDXQu/aVE9qMLKp6ZmThhgjslEATkpn?=
 =?us-ascii?Q?se3WRcDsIL+Lkxs6XwUYNM/noh6eGb9Jy2s0JqQzgg4D/urS3UEN9aIDxiIS?=
 =?us-ascii?Q?1gg6M04tEJcz7WLjwJz5ZGG9FkXd4uDqhoe6JT4wyOgruQZSXT1VTMmBk8dd?=
 =?us-ascii?Q?qdWZLRRP9BLGNKwbLXe6kAajiT4ZuW/ThIH6/kKgYHmXrDKDKxjYEYtdGXys?=
 =?us-ascii?Q?PNtNICONRnZylQI6S0xDobBHgn3raZn9fogWjl4TmUUis9GUM+s0GAHJgzSM?=
 =?us-ascii?Q?e/ibAPmIl6aoWPhRDGGyySrZD8zZL8G/A7xMb8gakQxf5P7bwMwSEp06Mr90?=
 =?us-ascii?Q?TPOBfc6EwYQVRVGqIdeO8Ab79ko/959qale5nw6TyEA+h+bf1/U2f0sVR75+?=
 =?us-ascii?Q?n0zyLkdkqphYguyC+0SMxWZAN4ZBaIrOrdgDVRPWkimhuviLQri4SbdQBcNf?=
 =?us-ascii?Q?ELB0Yr1OrAEOj7PomRFl/e0grcDgUD0Nq9yLvqsdXHj3o5d867UyGxwlQiDr?=
 =?us-ascii?Q?D8QGSbs8t33ZnqRjFTkzkm1M8hxF2MH1SsBR/wrvXxscjZPS+LpiEphjTgLf?=
 =?us-ascii?Q?JZuiTA3wytUdjs00sCn2FuL5Spi7NpKhF9PKXW3+/ZdZ7QPTAK0AzUJMlck7?=
 =?us-ascii?Q?XpEePXIuEInPCrgZYgzXkL9WrGjsLffec2t4XQCiKiSsGai7lOXo9r6VRGo7?=
 =?us-ascii?Q?J/+D+D1pEmXG9DBFH4uTNLyaoFZxhIa5Lh2IeMpuA1eLs0qpQ9dL5YmuqIRd?=
 =?us-ascii?Q?fEXB+CtSo1c/Cv39IpPDlOq83GqA2915HsuVgFPahj4g+Q33R4F4UFSD/MsX?=
 =?us-ascii?Q?vNGQCM461z5G4DmssSxpPDk1v513f3PF7O5bgcNlSpd+TcC+xAbS+VLxAmSV?=
 =?us-ascii?Q?h8Y+VrG1IU7B7WXL8jVjf9xPH0lky13NqoOYNi8l6i+NBYoCkc0RHZCj3Wgk?=
 =?us-ascii?Q?0i4ThO5DKUz/P39kxr4J6sNnhm8yXVuKqpaR4VDDAMxenxBdUCDEd/IT6l+R?=
 =?us-ascii?Q?MAM5WBCTfi8MAnzCGVEmFZRZwL0DsKCzXPUORuR8JnC13tuZknuU890DK8sy?=
 =?us-ascii?Q?MaMVdwskgVX+BpV6dDHJwe/Cozid+6/PpZJiscF8pA6xR5LN8OFsJFF4jHN7?=
 =?us-ascii?Q?f4RLkS5qrdjrZCZ5NF9TZfQUzbWWv8w+n3SOcdK7cZHeWQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8F37korzErA7INPbfh2gw65X0FBGxsicTcw02UdKQI6MAN3BtczSosXPdQLk?=
 =?us-ascii?Q?fcDIKOcZmdImsLGj/ioMnJMZ0EzDgEDc0HxwSvRMqpCfckP7rnesBXsWBSbw?=
 =?us-ascii?Q?HUyLPl1e2mLmFBRkas3MNMEtYwP8bIGEyQH9jpoP/PvCjF0S9InrW3ys3itQ?=
 =?us-ascii?Q?eofKosX5lDFo6rN8KPOPcUYswCtND2Jf2ADPBYmN3s6U/M31mpYaHaE/Ihoc?=
 =?us-ascii?Q?MvS1KjY72nNrPeYxJD3ttRI3Bb+qmC//FdZCgk9DfHJqd6uBep40v6LaQ7nT?=
 =?us-ascii?Q?XEfEFll22m/PDyoMHBgvgvIBId8Ca/g1cnG6oE9gG5lvXzc43NX/bwVIF22j?=
 =?us-ascii?Q?A/XzrtUrAkQny5ROy2q8EDymEZSE9T9DaKdaRTdtS8qhTm9nU1yveclJ0chl?=
 =?us-ascii?Q?ocbCCQYXaKe29/Ustj5IvEukrgOrlO5O7xgmALRFaEDpbMPh0ygUz3BKeYWQ?=
 =?us-ascii?Q?iFWPNf/rJkqcgB61Hh1UwbIlAex0aNF+893lNIG7mLbs/AnDeKGmGUtm9JNz?=
 =?us-ascii?Q?LqMmNiYn92XBAqf5mCcBPdzTvqhCN63btun4rSmAjoCa2NgKfdmFV+xfxDFa?=
 =?us-ascii?Q?fRXnVR12ntWM3veuyHIK3WX5umWoW9uDLZAw+E7mOH4/+7bMsXqkfjjVN/LC?=
 =?us-ascii?Q?6LKXjvRpoXvmshiD3AeTvtcQyT7NFrFjVlOTfcpzWgFu7i6G6RgNmuBm0Zqn?=
 =?us-ascii?Q?AVsd0HKQfuVdJIWTz4zyqJ1ll+wVM6XqCpsbhB2uhOtDb8m2JlwSUroTZyYL?=
 =?us-ascii?Q?m6RN6G129qXAaiOCnW9oavkmNXORw1dKMg7hM0btTXsgo+VegLezSTGLecZc?=
 =?us-ascii?Q?aasiJUq+bH+WpPId065xHjxM9wmyssD2kQnmqp96WrpYFagmbbgLJzoKhFmp?=
 =?us-ascii?Q?lBnqv1FH9UW+MIBLfzdR+Iyvc4K6LEX/0pQ82Pa6PzzahZC+eXiXLc1/LVEL?=
 =?us-ascii?Q?WD2Eo0re4lWlPF8TP38wXQ2tfECe/veCLRXhxlqduWzDcygUF1HGrjcfZMZd?=
 =?us-ascii?Q?Fri0+JkkPZNAK+NKjJsdF3X7VnMw1GKUkNBIHt7TRctqUmKzX2Tbt4+jW9lL?=
 =?us-ascii?Q?Wf4ntBVgtd/r6tGRwzM/F4jktO9VobCSLvYcrkxVMro2Vvzd9FTuWgFKe4eN?=
 =?us-ascii?Q?1hlq/i1jBQv/bi1fdKR3MkX5DaJwMNvyYeTgT+Jb0cYjEgPR8rhJBjTlTLEV?=
 =?us-ascii?Q?t2Y77FV/GxXultxl7gz7c4FCqRttm3SinBvnDbRbk8TZnsk0sRWznwouzCbg?=
 =?us-ascii?Q?7tcJ8FvlU+GhhZFbXMWNXy893SLf6HLI0SZPb0uTuqBsXZac673EwntPE86w?=
 =?us-ascii?Q?Q0A7otJUiXDarCSvVYRM5fTyujRWzw7HKSj5HvSiT7yA8Q72JeutZJTa1keA?=
 =?us-ascii?Q?AJI00SsCyE8LPY7fh0jV4AicHQoLCAtZJvnjtGcT1Afluzq3RDYvmPTD22Bc?=
 =?us-ascii?Q?1TzPENfyCrbRBzQcLKLhNIFJM47RXROQlLqTl9+oyMDzINXAE+gbcDp2X+m2?=
 =?us-ascii?Q?J4TqO/MWdOczeUMZzGYOIh17CT1B6s5AxiKUa7dltT6xko6Rcx4IKyTbAcnW?=
 =?us-ascii?Q?ZCKKNRRrii7Bon0DWmEhWQPNUVsb8RQiY7uZsfS2?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4086af1-6d5b-4be4-9537-08dcc207e947
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2024 17:37:21.5209
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hwHJJEd4VaNYoth/eA7g/bVos+cDSPn1ynm9F2fHy5i56iJGkd9DqdEYi9HKKfbW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9098

When using io_pgtable the correct pgsize_bitmap is stored in the cfg, both
v1_alloc_pgtable() and v2_alloc_pgtable() set it correctly.

This fixes a bug where the v2 pgtable had the wrong pgsize as
protection_domain_init_v2() would set it and then do_iommu_domain_alloc()
immediately resets it.

Remove the confusing ops.pgsize_bitmap since that is not used if the
driver sets domain.pgsize_bitmap.

Fixes: 134288158a41 ("iommu/amd: Add domain_alloc_user based domain allocation")
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

