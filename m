Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2074.outbound.protection.outlook.com [40.107.212.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75A931F463C;
	Sat, 14 Jun 2025 06:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749882957; cv=fail; b=RKivHMenE2tRIfNGyc3PzXrrf8T9t76I9OAo+Iif6a83w+ydBZOCXIkz9J0DW4iiiXiHC+3TcTRJ7uvhRHNcoTYPNfYhV7sYFXqLmfo1/8pmIv6E1r+s1IAUfSyg1EEiiL215RRCN4pteDFHY56xRtwnc/dvYT0i2evnQseKl/g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749882957; c=relaxed/simple;
	bh=6bN0pbOnd0L6tDutTofgFEm72F92YEOJLXFeLW56EiY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BbQSWObXhfdn2cXdN2ZL2wKk2p4oFUgAZlam4jN+Sv0cQrmd0VohVPyD5vXIQSJRWOkBBy5+AJ+QB53x/UcdrxI1xkCF9BI3ULPien0D5yy9o+gSsYoQLus0o+WDcckiUxv7CNoHrFyfpXyeIbkzj20zUMQjbNU5maP/ZP+ouTw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=JtYFfW37; arc=fail smtp.client-ip=40.107.212.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="JtYFfW37"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Pobj16MuErufoBJAquWsqBsk8HZ2HfQi6Hri5q+OvHnY3iGtYmi062ghLHBsapzPG1j963wGxU2ynWk74dxcvyO4NvfoPDfklC4uEHX9Kcd2S86yjx57ztqBCNop72xrBsIpPOufk4hcPcUEQWowKFfGB8s/XoVfhm1O/3Kx7fL/vtpXtetFuLzA0lru2Jw/7eWkUE70WWB80bwgC2sD91c3LAvtesa5oqMXL/7AzEKWW3P2LnxriqFYyWmn8RRlK17Kr0hrIhaHIspXVxy3t5UwlLdO6d6K9TmhTGUOoxT/Y3nYiLU54U9GGGOQIJ6XYllFEp963PbqZEHoXOIiaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0orwlMV4T32YBujd5s94+4y+QxAnqbHfwN1DgF+vnP8=;
 b=EVJ6oqjURl6+5Ncj5NXPfjl8Yfxv9eHGVMBUsRxsqkao4A1m9umnWslNw5N6DfKOuyPRMoCqeCtaOnRnPMOKtpVUmUetg1fTVXCMpN02zuDFRjTYyqQNK8JuRK7FMS9QFb4VOJMb36y4CL9Lf1I+Ccn45Xp0p92bpi79Xxk4CBv/lqsCHVZmBgvO7MCBWVOf2jMIJZ9W4UEzonOef28g+QBfvZkhLrMADPjRjQ4Nf01QMKXunPEBqgzb4H4K4DJqmAfs2nldORm7LeziWT3s6M0UlPAyFbK0dHtgB2Tg6DXFmAloj6rxUEy59KbMD/nwk5I3MtyqWbXo+h2slVSKqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0orwlMV4T32YBujd5s94+4y+QxAnqbHfwN1DgF+vnP8=;
 b=JtYFfW37uc96yWH6IzT47wScrpSc9/V69zgy+XVvuAwAaIMaR3H6yQ6ngtJOTjjfysqS4Trg9LpSMbLAS3SDtEglO7kwMVa6b5QyRYr+SN3zszqNTJwAqDohmscubPqNzec1ITf0RlUIrhRbeauxgoRPzFx1l0sV/PPzACqxmXR+U4487dI839gn7F8L32jLRuaoUz09Qhz3R/HyAVp8yAMbOg0+nL6GBdU1Wh9xuWF6n345qyqucisfASYnXiR0WijqxCv5LNluxXKKYTSfsgibOANwkjxkIkzXwcpYYNdnUtRQ9P0os91lrdeRr3Eptkp7U68HEmybjTSWD0wd9A==
Received: from CH0PR03CA0289.namprd03.prod.outlook.com (2603:10b6:610:e6::24)
 by CH3PR12MB7667.namprd12.prod.outlook.com (2603:10b6:610:14f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.19; Sat, 14 Jun
 2025 06:35:50 +0000
Received: from CH2PEPF00000147.namprd02.prod.outlook.com
 (2603:10b6:610:e6:cafe::6f) by CH0PR03CA0289.outlook.office365.com
 (2603:10b6:610:e6::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8835.23 via Frontend Transport; Sat,
 14 Jun 2025 06:35:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CH2PEPF00000147.mail.protection.outlook.com (10.167.244.104) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8835.15 via Frontend Transport; Sat, 14 Jun 2025 06:35:50 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 13 Jun
 2025 23:35:39 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Fri, 13 Jun
 2025 23:35:39 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.11) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Fri, 13 Jun 2025 23:35:38 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: <jgg@nvidia.com>, <kevin.tian@intel.com>
CC: <will@kernel.org>, <robin.murphy@arm.com>, <joro@8bytes.org>,
	<praan@google.com>, <yi.l.liu@intel.com>, <peterz@infradead.org>,
	<jsnitsel@redhat.com>, <linux-arm-kernel@lists.infradead.org>,
	<iommu@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>, <baolu.lu@linux.intel.com>
Subject: [PATCH v2 08/14] iommufd/selftest: Drop parent domain from mock_iommu_domain_nested
Date: Fri, 13 Jun 2025 23:35:20 -0700
Message-ID: <0f155a7cd71034a498448fe4828fb4aaacdabf95.1749882255.git.nicolinc@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1749882255.git.nicolinc@nvidia.com>
References: <cover.1749882255.git.nicolinc@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF00000147:EE_|CH3PR12MB7667:EE_
X-MS-Office365-Filtering-Correlation-Id: 30e04c5e-70dc-4544-54ac-08ddab0db451
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?sJYWo0kUVFtpU4Dwj1xeQU4xjWUPwAUaj9hcVqaXVPtCPZQorDnpEkPLpiGu?=
 =?us-ascii?Q?JKpyLZWDvSu+9f2sIEXO+chr7i0ZTCgggL4k0G8Q8ILslW2/Fm10K7Xze5Kt?=
 =?us-ascii?Q?n5NxpcRTsfm2C8LgnbwXPsFhAfZlWO0VlVRKfIr7SOE0ZoJHmnmqb1x78Jx/?=
 =?us-ascii?Q?WEdac2X0ONbP0sJCOZlZMINd6ZoboGRgk1l1wlprw9lGgftvb5PRvWJSTOKc?=
 =?us-ascii?Q?NZK3z1XaJ7i0fxZYD8o54CNpWJya7fEdrGa+VxCMNP2efu8Rq/ZI3Jj53ci7?=
 =?us-ascii?Q?esRpr4WOd0PS1vtkM1DRLAK+G5lz4S/IkBHTeHgo86z/RNbuOyglYuHiWVje?=
 =?us-ascii?Q?Ufyx1/Ckkuc49dE/xhAhEFWafANJox25lnzfduc8Qznn4gk1P/c2u3f5xg05?=
 =?us-ascii?Q?k9qPzI9uPUiE8vKh8N08/iN7vjt9pTgC7Ls44IMJ4LJA8Ku5QkOghyt9zc2t?=
 =?us-ascii?Q?J0oFpcr1UTRQ8PLMLwyR+W9SNbyOEgqN043tZFIX24pq101OA4ajRnSYrUqA?=
 =?us-ascii?Q?LupCO3l3K8c1Rs4WZWZO4lag3lecZgVxRTk9PU/GVr5LZApRQk6SCBMmHhoZ?=
 =?us-ascii?Q?SnSb++kRYCKYtxwbFaSEKop7DVOEHQvq91lfwNPbdHBUbtxBW4ugtSx5tu+M?=
 =?us-ascii?Q?NhovxdgPgwUi3G+ml/btV7guMbHVfziituNCo+qXO7neyCKHLvoWw+UpFgPU?=
 =?us-ascii?Q?9yILnZ/9N5Ne4ASUHNQx72+pTDh6MsTXbJquwcwB2FSpQt4c2QBhaWgKU5UQ?=
 =?us-ascii?Q?lyvNQepJ+rydLqL2ap6QJIG8W4P+r4+mmYI3Rkj0DERrmvU4jIiBm3mgWMHK?=
 =?us-ascii?Q?LB3Qu0D8+tPFZEp8q03MOzH3omH2ib+Y7wCoqDo78C0fdDiFbEL4AJDXTDuu?=
 =?us-ascii?Q?P94eiePJkbWnzhlVsX6KX0DEhN74pFvS6xtHzs1m4r1QxS0J5h1Z8fVxYjz7?=
 =?us-ascii?Q?a9jT16k4NvlZ9jLfCSHM3qYhy+PHtsYXp87sqQETLdbTM6uqmbDtJ0nlsq8O?=
 =?us-ascii?Q?qTy4/pHIul5f2fiNPTGgad9sATjykqiJJUbxC1CnvTmQvCuxUoWixOxeCZd6?=
 =?us-ascii?Q?eL+TkLaGlIIyW4lfVJVroPnfcR3m7iKWqV2OKpiYkhStcdFhMnXKaUyj1iG7?=
 =?us-ascii?Q?+VfvAVG2Z/2rUzcZ85VM7PzuMfsYRBP4ROgnepce/ZdeqsXNGLVO8REuB4Gr?=
 =?us-ascii?Q?o+PbQgORPmcVaO7YoKpPk0sFmyu901H5GeSyp8IbhcDOpwQ2+rmRI6FOKi2H?=
 =?us-ascii?Q?2ZYl++9SzHK81WjuTPjniLGQWjKa4MHhmQWNjuGpCwyUMCriwc+zUXL6UNXA?=
 =?us-ascii?Q?iz6sW63e/SdzQs2ICTe5GNiPU2f7Kmw9/QpgnAvWAIcxvc+gXq8zGHAWT3rn?=
 =?us-ascii?Q?SVbq1J013qNizwuRCIRjhqiKIIFXiqYpzTopHLhVzW1o2RZnAXPTtYccHApV?=
 =?us-ascii?Q?Vj2LHmHLOF9S1IQ+y6D3CMRwmeKO6KDD8dETojp6PVgWOdlJ5oxDC04rtext?=
 =?us-ascii?Q?D4FZgxUWgndVJgfazHqJmJE46FPhdLFMqoiw?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2025 06:35:50.2991
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 30e04c5e-70dc-4544-54ac-08ddab0db451
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000147.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7667

There is no use of this parent domain. Delete the dead code.

Note that the s2_parent in struct mock_viommu will be a deadcode too. Yet,
keep it because it will be soon used by HW queue objects, i.e. no point in
adding it back and forth in such a short window. Besides, keeping it could
cover the majority of vIOMMU use cases where a driver-level structure will
be larger in size than the core structure.

Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/iommufd/selftest.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/iommu/iommufd/selftest.c b/drivers/iommu/iommufd/selftest.c
index 4d5dca8027b1..f9cfb3a20860 100644
--- a/drivers/iommu/iommufd/selftest.c
+++ b/drivers/iommu/iommufd/selftest.c
@@ -138,7 +138,6 @@ to_mock_domain(struct iommu_domain *domain)
 struct mock_iommu_domain_nested {
 	struct iommu_domain domain;
 	struct mock_viommu *mock_viommu;
-	struct mock_iommu_domain *parent;
 	u32 iotlb[MOCK_NESTED_DOMAIN_IOTLB_NUM];
 };
 
@@ -434,7 +433,6 @@ mock_domain_alloc_nested(struct device *dev, struct iommu_domain *parent,
 	mock_nested = __mock_domain_alloc_nested(user_data);
 	if (IS_ERR(mock_nested))
 		return ERR_CAST(mock_nested);
-	mock_nested->parent = mock_parent;
 	return &mock_nested->domain;
 }
 
@@ -692,7 +690,6 @@ mock_viommu_alloc_domain_nested(struct iommufd_viommu *viommu, u32 flags,
 	if (IS_ERR(mock_nested))
 		return ERR_CAST(mock_nested);
 	mock_nested->mock_viommu = mock_viommu;
-	mock_nested->parent = mock_viommu->s2_parent;
 	return &mock_nested->domain;
 }
 
-- 
2.43.0

