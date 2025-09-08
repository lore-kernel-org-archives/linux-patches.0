Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2081.outbound.protection.outlook.com [40.107.244.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26D5223AE87;
	Mon,  8 Sep 2025 23:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757374141; cv=fail; b=UvE/uHn21nsLdBVWXpdhlPnnVdlz9qweVNZbNJvtavNs9RN3hbc0lcf27FBnOqUl5g10J8jyUSJj64rRaez8wcn4gvl8R8NYJPksLTbezKIc2C8hQBi6AGFz91FFcA4cIxVl8ZGXUHv74xJI8WyDuMGg9inJASB9zXF68mRt7lE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757374141; c=relaxed/simple;
	bh=blIQBQYJAfmmH54Xp/NOl8LRNtytQ6IN41ywkb1z5WQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Uh60OWBeauHIYEG5aGHLwA9tuCty8nkVlH4Mj8BYtfiwekKRt9sZK9a1mhY2fDVhSiZKF41XONKc+7oftMsvqIeKr3Vxp9Z9jf0Yp1IFNSZSLedJXASbWNFxO1otUorwiB6Bp/pTpxzZHET8+akpxm+mSbhV66Lv7baVRGrba5w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=MFlssMZZ; arc=fail smtp.client-ip=40.107.244.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="MFlssMZZ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JxnjmIHgVaEMb0c4glzxE9fedltMdGEYq98NOx+POTXTS/35qm9HvNQlelnug5WiSSt+Gt/DNzS9xiTpWajDf69mtppCaf5VzhD3Akqy6omZN0yoyikb6I18OzrZ2mS1XlT+YCjCEHWp4JzkZQVHQVs9GC9hXA0KXM8H8k4XeP41PBl1THLihyd36mkA00E1+uwvNFt4jhkHdmH8zxreYc56OQbX4p70TMwydLRABmOnJEt60nK6aQCQzBtaVuAEaktdoqvYrOiYP91hewa9KUeSmUqZUkUbnl6HADWGNZKAEDhcqwhoBpzmxYDfp2ZzljgeO8qvf32lyNROWZY6fQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n9tdY7vma3BZOIB/pf+qIbNyJWlUDjlUslTFVsNzYF4=;
 b=p3PkSrR/48X84qKDyOeYgiRVhvIRZMi+3/2pmTsfbZ6uyvCYtc5tQAMGAepqrGaf3t0dsbHl8rfRV10xtCXJFCWH3/BSnNA5dvb9XKolQICAtX3jSvzdic4QyQ72yVaVrY0pTuYITNzyxdEhPrSiF4QOVqClHhfEL5t98pgED+UXQXkPkDXnHczu3/TDMEn0nKqz8t9Muft6PQZLTkkgDZSaw81W+Yst/KJQc1LhQERDwRfdUpLOwyeMedtleAueeMqW0sO/divXw/ZIG0uOWBSQ59pSVbICZp1Al+Gwss2qVL4ETRcFxG9M4RPUY6YTwJVRlhHkFiKcZO0M/irWrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n9tdY7vma3BZOIB/pf+qIbNyJWlUDjlUslTFVsNzYF4=;
 b=MFlssMZZW4PFlLIydI8253GR2cViNWpKjho0eoQUQKW8wIU89tCkkAf/x3rJKxzbmX8lQT5ZFYaTqrznvPld8TMtVgkPGRckGnrApKJIUErk/LvOnQAZLAhpMbQu+qPLKaVmOCpqjpupGtptBoYMmmb11sF6yMCctocLuhRBusNAhJDPwbhDC/Zf2KRb3xtldSbNFSaNSvCU8jP8vpmNzCGHmysq+nhpvA3/xL4oAbizy5Uw6/jysA816hwHR7UdtXaPTpy7ccWouz46HcWez4htyZaciIapu7K4kWFg8TtsiG9Jb8WqEGFCgvOpU8G+asTcgYt9P8HORTgFQxF8tQ==
Received: from CY5PR15CA0237.namprd15.prod.outlook.com (2603:10b6:930:66::6)
 by SA3PR12MB9160.namprd12.prod.outlook.com (2603:10b6:806:399::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Mon, 8 Sep
 2025 23:28:56 +0000
Received: from CY4PEPF0000FCC3.namprd03.prod.outlook.com
 (2603:10b6:930:66:cafe::f5) by CY5PR15CA0237.outlook.office365.com
 (2603:10b6:930:66::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.22 via Frontend Transport; Mon,
 8 Sep 2025 23:28:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CY4PEPF0000FCC3.mail.protection.outlook.com (10.167.242.105) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9115.13 via Frontend Transport; Mon, 8 Sep 2025 23:28:56 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Mon, 8 Sep
 2025 16:28:41 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 8 Sep 2025 16:28:41 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Mon, 8 Sep 2025 16:28:40 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: <jgg@nvidia.com>, <will@kernel.org>, <robin.murphy@arm.com>
CC: <joro@8bytes.org>, <jean-philippe@linaro.org>, <miko.lenczewski@arm.com>,
	<balbirs@nvidia.com>, <peterz@infradead.org>, <smostafa@google.com>,
	<kevin.tian@intel.com>, <praan@google.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: [PATCH rfcv2 3/8] iommu/arm-smmu-v3: Add an inline arm_smmu_domain_free()
Date: Mon, 8 Sep 2025 16:26:57 -0700
Message-ID: <2066c45c004cde5c5e9f334c40e5683402e6deda.1757373449.git.nicolinc@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1757373449.git.nicolinc@nvidia.com>
References: <cover.1757373449.git.nicolinc@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC3:EE_|SA3PR12MB9160:EE_
X-MS-Office365-Filtering-Correlation-Id: e43cfac9-3310-4b49-237a-08ddef2f7aea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DtD+q+JeFE4scypAE9wedycZktYHa7+x8OkDWCVwew4zo/TPndBrarHT4vbM?=
 =?us-ascii?Q?MOxDEOMJUHsnOrhKNsU2npISyDvS0KkuNpd/NSmWy1dUs2y9WVMrV9fo/4i7?=
 =?us-ascii?Q?aaJE2QEDw4isZWDjrq02N0S5YYGtfOW+K6qqNk54ZsSbRkKa7AcxytHxYfrp?=
 =?us-ascii?Q?6otZKWsjpMcXkNP7ZT5u2hgRzked+rv9e3Fd+Yfo5Up7R2UNu6Xr6UOjntR1?=
 =?us-ascii?Q?q9dqALCifrTtmhqwz+BGQQ4POpb3AvwdBLBo9blr2NTuuDOFpv1466jjBVH/?=
 =?us-ascii?Q?g5Nn+878454Xp/0ox+snwbsDTN4SRsBsDdRSqG4iQ1WmWFAzCns3sNnJO+PR?=
 =?us-ascii?Q?ItmD+NmOfuraw1eknd6cbbtKyhRYGRTj+RWDHRMW8jTAf1dyvGJo5c0sVEir?=
 =?us-ascii?Q?qaxmtS1j/LjvQYUk3Saf4LssSVILckYtm6SEExkSCwTDHCh0BSsLDV3gBUuU?=
 =?us-ascii?Q?qoCR3HXYvBs68xUWAppUSKMSzLl/ZNPERQw5z8NxRLqrB1R4K8cTotZKjbSu?=
 =?us-ascii?Q?72WIqRIG3PKdn7x/ofTJP8oYsLyNnzvLyuniWuJGJBGR77XKv2szFZ5M0qIH?=
 =?us-ascii?Q?dq3z5bslQsOl8c6u1Nzf4xD/Lyjsg97gWIlbj+26JKgNceDIKkz87jlow5gQ?=
 =?us-ascii?Q?qapy2CRJ5J27Mx6wM1MGDaWMp52/ZmuEhNcEJS1ZeoNPlKQgPySEVLbkboda?=
 =?us-ascii?Q?d9liSY0ZOTh0ecHCd21Xi/l935nMJTkLZS8zFYwcC3+axyU1TdxGrZKtnJd1?=
 =?us-ascii?Q?OCvl8Nw33l8h8FaV/AgwqFOB5/MJzIKyAIPROK4LuSBNUMwJyGAXzTZtfd5q?=
 =?us-ascii?Q?yXAkwas0qANoK+azYY2V8GL4hF6S3Qk3RwrQkDMLvCh4U90nV9QVu4uBMFg6?=
 =?us-ascii?Q?B6pu3SNvwj8pKFhRvriyNur4xgThnE+8t086XWB4mheZWwOnajc9+ywyAgH0?=
 =?us-ascii?Q?TNcnVGlXdaJU9eAP8wS2D/eEjAdpAC8ethH+UQguS6Rels2z2PjcUa7yEKcp?=
 =?us-ascii?Q?m+7vCuz++PMY4sxsBJFSsMKaxnehuhgkiCU9SP3SoTZw4w28mj2Pe1bIKwcy?=
 =?us-ascii?Q?kOTMRUOZjdb81Gv4OymLqTPuc+j4p0esp6ITH0l4tcNu3LTNzSP5Na0swGWo?=
 =?us-ascii?Q?ngZbFtLAV6hv/KxPqZzbYw2ITBO9N/xcTdrObGYpFap9beC+R9oKDkWaBr17?=
 =?us-ascii?Q?YMIMybBv7BMJfhfa+cQoME/t59lQ3Wuz4Y7YvXtGAXKZfqwO2vy/tILJb1z+?=
 =?us-ascii?Q?aUjsiAM4lgl1WTpNIT/1SmAzpLeSAYTyNtTfAHZkZNOYBXulcW0L+XbPC/Yj?=
 =?us-ascii?Q?mHWbh3scxx5ELoSWKOuIiPD+UwIDzesU8CPblRZfyZB1X4mqT6ZRSR154BVb?=
 =?us-ascii?Q?LJ82aaREic5vuxhoSd9d7NDpHNdB7NWFGLVxJ7aegOcwPltsjeKDRiPBlh9h?=
 =?us-ascii?Q?KypD3BiRg27zA1F6yWY2egV+uirwqtqurE6EpcNMRUFgxRoS50z8TaK6Bu43?=
 =?us-ascii?Q?7+kytD8NNsis7MV774BirZWEWWRSYFhJbBeF?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 23:28:56.0165
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e43cfac9-3310-4b49-237a-08ddef2f7aea
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000FCC3.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9160

There will be a bit more things to free than smmu_domain itself. So keep a
simple inline function in the header to share aross files.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h     | 5 +++++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c | 2 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c     | 4 ++--
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 5c0b38595d209..96a23ca633cb6 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -954,6 +954,11 @@ extern struct mutex arm_smmu_asid_lock;
 
 struct arm_smmu_domain *arm_smmu_domain_alloc(void);
 
+static inline void arm_smmu_domain_free(struct arm_smmu_domain *smmu_domain)
+{
+	kfree(smmu_domain);
+}
+
 void arm_smmu_clear_cd(struct arm_smmu_master *master, ioasid_t ssid);
 struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
 					u32 ssid);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 6097f1f540d87..fc601b494e0af 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -365,6 +365,6 @@ struct iommu_domain *arm_smmu_sva_domain_alloc(struct device *dev,
 err_asid:
 	xa_erase(&arm_smmu_asid_xa, smmu_domain->cd.asid);
 err_free:
-	kfree(smmu_domain);
+	arm_smmu_domain_free(smmu_domain);
 	return ERR_PTR(ret);
 }
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 0016ec699acfe..08af5f2d1235a 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2498,7 +2498,7 @@ static void arm_smmu_domain_free_paging(struct iommu_domain *domain)
 			ida_free(&smmu->vmid_map, cfg->vmid);
 	}
 
-	kfree(smmu_domain);
+	arm_smmu_domain_free(smmu_domain);
 }
 
 static int arm_smmu_domain_finalise_s1(struct arm_smmu_device *smmu,
@@ -3359,7 +3359,7 @@ arm_smmu_domain_alloc_paging_flags(struct device *dev, u32 flags,
 	return &smmu_domain->domain;
 
 err_free:
-	kfree(smmu_domain);
+	arm_smmu_domain_free(smmu_domain);
 	return ERR_PTR(ret);
 }
 
-- 
2.43.0

