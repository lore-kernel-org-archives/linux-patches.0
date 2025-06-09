Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2078.outbound.protection.outlook.com [40.107.236.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72DAC21D5BA;
	Mon,  9 Jun 2025 17:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749489250; cv=fail; b=jGA6b74vN2j4VBVSV1p9tbCCq2nlX+55uqo2Upzxd9EGwfQBwdED7X43Hoi2YAabFP0OcHcuZ5dH4N/eDIGcKvFfG6mi+ZWTtcP/gEh5I/AuOki0jyCTKOsNQ5oyBjTu1UCQP6UKJt30iCk3huoV/FWCt1cw8/CXFBq/2ZY2lp8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749489250; c=relaxed/simple;
	bh=4gbW5bvzWWGDBU6sNRrqAIa5oSV545jeVmKLcT0iMnA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZVDg4DxSW9kW6bN5Ur8YQ2+sL0UdDWwS/cO6nO4xZnMJbZZBrDShOTor3bPNXJc/UYsNXRBY6VHXTjX7Qo9iNLu2YtW+N0h6pBir+7KJHP+wHHZkUyFe3VkNkT/fRHVJkv81pKglT08DFmMWXLTIPPK5qGVbAPrugl/b+ivSP6g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=dxjIEmBD; arc=fail smtp.client-ip=40.107.236.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="dxjIEmBD"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GuO9SD39HseGvBiZauVTcPh7d1QiUXxnptezwIJ/087CH3ZdULNUvpk+jAYHDNrSnUjIcJCPX0OB1uJ2z0PPOJTRvMzW4ca/FzP760SV7vcO6d+4UORN1Ri5/5gJu+KH6TjA2WhLJR+zH7Yypg43RWcBBwR6rIofMf1ukuaAgOaUglUWlz1CowmQp9Ae/Q+V6Xmb5H65YgGFHlj6gkZRsA4Dw+sWOa5mjdJldaC0yEsrNUA9354EIpkg52HsrBmFQ3/bsPM6ITIxTFBHQlsXjiTp3W+gY8CnL1nvrDKVtzlVSGZO39uFtgqowxOJrB972nHl7aMOgy/A/2jvkGT+WA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GJIQUSEzZCpe0t3dyy5R8tHxGaPm2oNFqvtH8oE0MEY=;
 b=K6+MW6/NAwR6iRiS+STtrzEjrdF65Fl2zp9W1lYVz5rQFRYmf8YrmOO+sjeWAnsc9Dr8y/YsxewHF5N75Or/d52/NOUG6Dti2hJ0tgawqEF8AqRHSTPfNN3XVVF61B86MaglYREGL4RqpftI6jml4tKQhXa9TXLhQgrbq/wjdzONQdAzRnBy+UmXHVBz6rgQ1s+T29pTLYnSTLXZ5nnDmrlpFS7F3RShPG4ZESda4mzrTnK29DWP6ZisVJWP420sF9e85BvKyNyWNxFXBkoY1W937H6MaS1pIUPK0ubVBAC2hp44nI97MstxDqRD5zPn2bD1k0pciTzHrj9H5PhLag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GJIQUSEzZCpe0t3dyy5R8tHxGaPm2oNFqvtH8oE0MEY=;
 b=dxjIEmBD3TAF8itS4oYx/bH+B9lzCcABEKDjkuWzF/+yF//9/hStWIG5YdbTuWGVFPbkarpi3M6W08JqBSKSv8upI5WCECt3Kt7QRVdy/+2wmK8pEv+CqdyRN1NAQwl3O1Ia51P3jU5BiVyJLx+f8KJ/TiO6wCoK5ci72yINShOX18UkQXUVEJJosG2KYO9V0ZPIgKiXMPzFcJixQt1iZHG4vqt0ePxlEwCeu1DS+5UC26DclON0yoqjIIRHq83okDrsCQXDIf8rN+pjJDeo3AwpcTUFID7MGelyexRnSzod4mHSjQW7YbTj+hUIuNJMaEWhavjuKvZUQiv+UeEOKQ==
Received: from BN8PR03CA0019.namprd03.prod.outlook.com (2603:10b6:408:94::32)
 by IA1PR12MB6164.namprd12.prod.outlook.com (2603:10b6:208:3e8::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Mon, 9 Jun
 2025 17:14:04 +0000
Received: from MN1PEPF0000F0E0.namprd04.prod.outlook.com
 (2603:10b6:408:94:cafe::64) by BN8PR03CA0019.outlook.office365.com
 (2603:10b6:408:94::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8769.18 via Frontend Transport; Mon,
 9 Jun 2025 17:14:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 MN1PEPF0000F0E0.mail.protection.outlook.com (10.167.242.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8835.15 via Frontend Transport; Mon, 9 Jun 2025 17:14:04 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 9 Jun 2025
 10:13:46 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Mon, 9 Jun
 2025 10:13:45 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Mon, 9 Jun 2025 10:13:44 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: <jgg@nvidia.com>, <kevin.tian@intel.com>
CC: <will@kernel.org>, <robin.murphy@arm.com>, <joro@8bytes.org>,
	<ddutile@redhat.com>, <yi.l.liu@intel.com>, <peterz@infradead.org>,
	<jsnitsel@redhat.com>, <praan@google.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>,
	<baolu.lu@linux.intel.com>
Subject: [PATCH v1 04/12] iommufd: Use enum iommu_veventq_type for type in struct iommufd_veventq
Date: Mon, 9 Jun 2025 10:13:27 -0700
Message-ID: <d60d21de0ea6bcb6e0bb1afe624a9045b38c8ee8.1749488870.git.nicolinc@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1749488870.git.nicolinc@nvidia.com>
References: <cover.1749488870.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E0:EE_|IA1PR12MB6164:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f1c3535-33da-447b-ea47-08dda7790926
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?G5N5c5v4WsuhVKKmi7aHXNffnaHIycVYxagQTug2bH9iklRMj/fTv+THLtlN?=
 =?us-ascii?Q?3vYZ8srcKk2RBHtvDYVSdu99sumbCxqSviU0K6eLpWQlpUgJge97jM4kQKkO?=
 =?us-ascii?Q?ZQAS3ryEzwz5bIj9eqZ4/BTXfCvzVW1sEcFKTzh0SaaJ5lwSxaLH7IKcXFL2?=
 =?us-ascii?Q?RP4Q5TXCS/LYJZkoQsnx9wnWAxp5c0WRKJhxNkHFeglQGjUb+H5v6iypepte?=
 =?us-ascii?Q?95aE7x69GVDAJWm/bSIqAdNjsEMvicMd77Q8JgKfkYoQASWUxlYRmo0fflys?=
 =?us-ascii?Q?JMQCOYXG3eux84CZzBix8etf0SI7NRuwsIpbESq1mjD4GzHM2izedptJdA/0?=
 =?us-ascii?Q?9hw2wtnJKwJ0SXYUn9Yezwj1c+Ddn13cC21AeTUuiIPYx3XfvjeB2aFQXFrB?=
 =?us-ascii?Q?9rEUpUQhzzqe+17DELZCTYGrVmZpgK+OXGX0AO7AspvCr6ipZFvhnxm3LZu0?=
 =?us-ascii?Q?7f7bNifsT/QVC5mfg7Jo6XbbDQBOVb+oJ/SkIf+IJHFHmIPzsoNgMn1Io27C?=
 =?us-ascii?Q?IKmo3dE7nqvxfzdBy5T/O9q4xo3wDDA4M8CAT9nqKgbkmYxofc12TZX3okC9?=
 =?us-ascii?Q?HI2jhY9MKzh5caCxwogb+gs1vNcm3vKUF4F9v9LZ8uFA1ivP3foPeb94v8HD?=
 =?us-ascii?Q?TsriMvaKVREFxEKBwXkcq7UB59SwdFNTFlHJmfJoKm2x4dfbrohmdrXeM2eL?=
 =?us-ascii?Q?ULmsegIEW8RMTAaL9B28cP7Q4im0Di6pDHKQbWaBes7ENcKtzYBJcTOoYjZr?=
 =?us-ascii?Q?8MtTHW6gIAd9dG2QaXmhfshicYrNqkKcEHaHjMbjT5xdiYGOuZwULNL6z4CP?=
 =?us-ascii?Q?txWsFI/7FLuBjUjCMe3Fg5fkgj2Wm4OiGJ/RBze701XhkQaiPH8uW2GU3p+L?=
 =?us-ascii?Q?IwdNJFFOY/LAZ9nY7RW7bvcruIs+8VR3nCkcFd+JIvbhr1hpqKe/AVSaDcZE?=
 =?us-ascii?Q?DAIzce1ni+Z7tVQ4bBAIqxhFONp4uP7iUrSZ+t3Jhc6H31ZEm0VXu0Jxtlwe?=
 =?us-ascii?Q?fdhciLWmkKdBvGXk9FZL7VQeWVCTX7UKB1P7JdxNgZ8+vGP+pdGlXKzyi5cb?=
 =?us-ascii?Q?3kVoFLocrKtDXRnO/C7xuziq6SHNqXg8kx90x+E0kOf76AJL/A6QSHGcRTSM?=
 =?us-ascii?Q?xHgT9sTKDEdu+wmeEdQP0eZy/0fREl4Z3Azmf3a3VY2/Wl007OMxRNM7cBuy?=
 =?us-ascii?Q?8aYYqj6vIv68oKS58EXz8WcPiryVIRPEqwXlltUq8LevAUt2AnUCDZMJ/Qad?=
 =?us-ascii?Q?MfNWjm4XvMweLTex4E61qFlFTuPc2CjGDupWcNewg0mz0ykCbKjQVidLVW9+?=
 =?us-ascii?Q?WzLtzEFZLtkzwsUPRIYFMkXFSoodCtq78ITPkq1w3WZeLd1lNIeiZz6rZS5+?=
 =?us-ascii?Q?pIdIngI64uXfkAV3SyiMjBLCfRo1L4ludhpMrGPMdetE8bTtMcqfZyNg1Gcv?=
 =?us-ascii?Q?fVVWm6GtQWpSw2u4D2c0RrJ+KK4HRSaBxwRbnFTxrAcqnbNdTieZJw2q9N0t?=
 =?us-ascii?Q?YJcrDauQMT8fTBTSQcu291l/zYMemkR+v46Z?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2025 17:14:04.0891
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f1c3535-33da-447b-ea47-08dda7790926
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E0.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6164

Replace unsigned init, to make it clear. No functional changes.

Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/iommufd/iommufd_private.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
index 4619285c09b7..32f0631368e1 100644
--- a/drivers/iommu/iommufd/iommufd_private.h
+++ b/drivers/iommu/iommufd/iommufd_private.h
@@ -526,7 +526,7 @@ struct iommufd_veventq {
 	struct list_head node; /* for iommufd_viommu::veventqs */
 	struct iommufd_vevent lost_events_header;
 
-	unsigned int type;
+	enum iommu_veventq_type type;
 	unsigned int depth;
 
 	/* Use common.lock for protection */
@@ -581,7 +581,8 @@ iommufd_get_viommu(struct iommufd_ucmd *ucmd, u32 id)
 }
 
 static inline struct iommufd_veventq *
-iommufd_viommu_find_veventq(struct iommufd_viommu *viommu, u32 type)
+iommufd_viommu_find_veventq(struct iommufd_viommu *viommu,
+			    enum iommu_veventq_type type)
 {
 	struct iommufd_veventq *veventq, *next;
 
-- 
2.43.0

