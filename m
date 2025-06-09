Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2054.outbound.protection.outlook.com [40.107.92.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCC8421E087;
	Mon,  9 Jun 2025 17:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749489251; cv=fail; b=ihrEJZfQiRdJ1tQ5rVLIc+Cz59w3YkFrciez9vT75LVTZHzdEhuhF6Dlj4zVF+IE7m/xSjDjV7RJ51+tgaQ6OHri5/tmshXoA2ogC+JQE1H7EbeXEz3otMV3GpEHlF6PXqVIANx1YkdUaQYq3yVG6b8l9bQ41DSru3YSDLs4+jo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749489251; c=relaxed/simple;
	bh=o01shdo1AsFaMzPMIWGDGPj2VLLc3V4veEJL0LcrxmM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EqOfbNkR6mxeWEhazP6WWTFDsU4ygAHi6EBhSUyc53z5uPI4w+yWkJv14XVvtmGe05t1PaVBw9O9fLe1nxlEnDrG2/scDhT3Rbm+/unz47Noud00EVjq9cjtzJHObBhYemJt6PvjL6E4CXsNrkIF2+Dhd00LnSL7D8N0OwPWX40=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=mMsYQ0dx; arc=fail smtp.client-ip=40.107.92.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="mMsYQ0dx"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EKCbZbF+45cBdGgxCU6eL/fUAvH1HI3n9W1r0mse6Q3C2Hp/1d7IKZ3IGfwE/RFWq67nocGgPVTP6LlVZIBXdTWprJyZoAQJPvCd9pt7bjhy5mdk9/IBN2i/12xY4Z31xkOJPrcb7XeMAR4eRJkU7o2jLeVcr9Ry0NTepO/68z7m7QCPRw1glMjl8pRwbVsoprkEJySD3G3daKq5Kh/1jhwe+pK+6uL3zfeHunRQ+tKBxA2gOcpD88oSu8Bl/6rHoKfBdb4I8W9AfyNhdoTFRpa1sa9a5ia7sXpr48VZyW8bG0ddmobfhWOMv8aRCRURI3rJx3gI3at5BnHzjet03Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mOpN88Xj7iDGwHatcTrE+ckWma0Nb4tMI6IGFXF6bcM=;
 b=JhHinfSu/Yol2UuQHu37DFFX+CLIeFONwORhW8nDU3Y5SpEdLkndnfo/xYP2VMnZyIK1m+qYSqPEmFX/b81OaBHItATe96FtjGMQZA1U+ir1DIiobjj7EknHzS6uEhTGBS/7YkiaoOxbI3/AI2zl//O4d83xC1z4alJqxM1vnCHh1THunbS9GIowtkjF8i1yKeRT+rYPBoWKICfExayJ9Kom+NPoevCf2GN1YzPsRdmfit90zlvvb7UXqEDEHGyaVvw16RAAbDaaCZpQxEBdTVi6+g4PPq4eDD8H2WwbQ397iSDZ85hDxeUR3k+YJOrS7ITH2/afQh1rzL4xgAhYsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mOpN88Xj7iDGwHatcTrE+ckWma0Nb4tMI6IGFXF6bcM=;
 b=mMsYQ0dx28ika0cOCjK8wp6Y5S5Aw2Z235ZRB5GwN+EcDcI4Q0kyw9B6klK/Fr+OnvEyQprf9xCqLhAYvG7VqvEtgQrbKSfl3TslUaXoVQSNaskpfAm5Nzh23N9tr5ad906COPMBeCSE8BJA/yvdKoa1dH4XASClR0eWxT5To9iAZqgs0K/QNlVo3GWIg8AhbB3qGLFU2cURlCSzapfNQjgEp/vsV+++o3cpvAsSiF3AR8u1OTJ8GJUoniQ3cndhwtzFx/uTYrLbI/wbzzDcVRWtPSmA4/n23O5+qCA0Bnt8YitEsiE1oF6n/sSNo29UBGCCjjzXJLEpYET8khaAxg==
Received: from BN8PR03CA0016.namprd03.prod.outlook.com (2603:10b6:408:94::29)
 by DM4PR12MB8475.namprd12.prod.outlook.com (2603:10b6:8:190::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Mon, 9 Jun
 2025 17:14:02 +0000
Received: from MN1PEPF0000F0E0.namprd04.prod.outlook.com
 (2603:10b6:408:94:cafe::9f) by BN8PR03CA0016.outlook.office365.com
 (2603:10b6:408:94::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8792.31 via Frontend Transport; Mon,
 9 Jun 2025 17:14:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 MN1PEPF0000F0E0.mail.protection.outlook.com (10.167.242.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8835.15 via Frontend Transport; Mon, 9 Jun 2025 17:14:01 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 9 Jun 2025
 10:13:44 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Mon, 9 Jun
 2025 10:13:44 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Mon, 9 Jun 2025 10:13:43 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: <jgg@nvidia.com>, <kevin.tian@intel.com>
CC: <will@kernel.org>, <robin.murphy@arm.com>, <joro@8bytes.org>,
	<ddutile@redhat.com>, <yi.l.liu@intel.com>, <peterz@infradead.org>,
	<jsnitsel@redhat.com>, <praan@google.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>,
	<baolu.lu@linux.intel.com>
Subject: [PATCH v1 03/12] iommufd: Use enum iommu_viommu_type for type in struct iommufd_viommu
Date: Mon, 9 Jun 2025 10:13:26 -0700
Message-ID: <6172ca53f6acfbbdefc2cc14b436d484ef62c250.1749488870.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E0:EE_|DM4PR12MB8475:EE_
X-MS-Office365-Filtering-Correlation-Id: 920b539f-0dc7-4bca-2390-08dda77907a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4JJz9BkInqLLZ3Hk6jjwq39kUzFmPvzHtSNq974yY/szRabBeXFadvo72Op6?=
 =?us-ascii?Q?B/cG23YDVWPQ8fc6nNim4ZhRu/uR141Rb2utSmuumqQ78wD/Mr5FIYVss6lJ?=
 =?us-ascii?Q?VLIlV+z8OIzhj8wlrIJ3gkDtP1acGY/1A2qsbrkG4Vj7iCQFQRG1oedhxhc3?=
 =?us-ascii?Q?rSXKFEzcKlb7zVMEDyfZYdus3xeS3gVY41LJfmMQ3lXlRku54Zndk9Yc1nm4?=
 =?us-ascii?Q?wq04hv5kjnlxkvTbeUgzLEVJ8PfZ9Nj5VZSlQck0kjIITaxAgOCic3ATHyQE?=
 =?us-ascii?Q?HHD8kIusqlVzuT0EhfGJV4xwj2yA5DYoVJM8r37tweQ92HM448YOq37gpDU4?=
 =?us-ascii?Q?wzptdRTJLPlJTHuqnNYm2aNSRKZ7FKWkD0/oJk5PPljK7U/0QoCiAJlaJY2k?=
 =?us-ascii?Q?B1dXciIJZ4DahIR3e27lF2mnga28Me4CAtFgHGY0eVSIKrvz3w+VAAmi5Cr3?=
 =?us-ascii?Q?BhbvDoIJfA/QTjhMYSzW1D7gdIHBTIFi66PIthv3l27xcmLzsc+6aTJBZNkr?=
 =?us-ascii?Q?mmX11B+UZvrV+jWZ35J8T5uZqa2EYtXmW6zag/QnsN25mex0fTqJAvrkOcs7?=
 =?us-ascii?Q?dkvhc0qt4mgTeBQbAdXb1aVd/9GapPp7BUZBsy9x80kY86OYbVP4KMDhvoTS?=
 =?us-ascii?Q?UYFGJT7OsbHLK5jRSnt0h4UIO7yFI4zw0s4NjDK3NI8LsJsWleov1ZLcUHs7?=
 =?us-ascii?Q?n7yijQSepCsFFP0JMkAxaswAchxtQeMn78kSgSWRy2FuHBvkXwduPx/0/ZHq?=
 =?us-ascii?Q?S81m1ZUjtVTOgKWjDv+7KP1WKdqAl8mZ4QV1hnsG6wLtk3RCOakoDK8puMF6?=
 =?us-ascii?Q?95ZHhyDtww8UIvzJ3ManmUNWSJk1DUt4dw720seJUCfkDkH8W0Z7u0KgvJmC?=
 =?us-ascii?Q?mS5ZGD/2DidqdoKreNhddDQoMu1bUry2L2z0WQPqRgXgIlhgxNbRaSAbqk79?=
 =?us-ascii?Q?IHxhLsOC0p2lTLETvfZiFtBozhMFFivqSSCQZb/w/MNVMyEgsvNrxwshLs0Y?=
 =?us-ascii?Q?TGpW/RobJbxjxSazGrKXDNkSl4gEJiY5NIq7LxL51P+fsqtZ6lLnRb0TRLYF?=
 =?us-ascii?Q?TquFPUltM9FAqs2bsEatoUnxg269KDVhW8wTLozdNvB6YGlP8RBxAvHS0V+F?=
 =?us-ascii?Q?eN5LNHGE8fzut94QINWy8Oc+ViIdWiM9ua4Sk56mdEE9JOzsqIPEPaEKhpUK?=
 =?us-ascii?Q?1IJ4IAk19WyR6BY0v/hjIIscoOd+rN6Il9MzBB8wsu7GWmlYzMWZIqh/DAou?=
 =?us-ascii?Q?aldutsvPUyojW4as/YY2P7KDmDhT60UJB5uRgRc/jTCTN+uY4poTyM2rQkzR?=
 =?us-ascii?Q?S8kx+Hhz3+j7Mg5edE8vIlcU0cfxUSNP8Su/do6fDLkrmobqqNtnV1xb9fm5?=
 =?us-ascii?Q?dHrd/FGeqVbNnLKoxdbIiEmP1oerL274Krv+B11CORgcdmA9lTDe9dFwOizP?=
 =?us-ascii?Q?H6tlg4WlB4AwSksKimNrEJaLgMX6qFMZrPSWM0F+kRa+nRjllklzs+V/83W9?=
 =?us-ascii?Q?u9d0IYiOyMLyCL8zLp6o/zW1KEpqFtDPse0k?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2025 17:14:01.5422
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 920b539f-0dc7-4bca-2390-08dda77907a2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E0.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8475

Replace unsigned init, to make it clear. No functional changes.

The viommu_alloc iommu op will be deprecated, so don't change that.

Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 include/linux/iommufd.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/iommufd.h b/include/linux/iommufd.h
index 498c9a768506..ac98e49e44fe 100644
--- a/include/linux/iommufd.h
+++ b/include/linux/iommufd.h
@@ -101,7 +101,7 @@ struct iommufd_viommu {
 	struct list_head veventqs;
 	struct rw_semaphore veventqs_rwsem;
 
-	unsigned int type;
+	enum iommu_viommu_type type;
 };
 
 /**
-- 
2.43.0

