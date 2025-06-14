Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2055.outbound.protection.outlook.com [40.107.243.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 224791F4C90;
	Sat, 14 Jun 2025 06:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749882957; cv=fail; b=evUl4lnmdy5uHDaWeXoYxqhUScvNn5JkcSJT0YydttzcjcXyQ6ivpCwQypZwQyZq4KpWrrxRc7QeVOl0HgbkEE7usMJw5yV47c8CjOtqJU3FcltAwaYlPGf5L38x5xE6Z3QN1rYOLwGoc6Hu4dTCAFSWJi//AGIJQFujszhmt+s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749882957; c=relaxed/simple;
	bh=+1X9ZibP7vy4fhtD56D9FSpp736ceDxz/xtuhuAMtLs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I4KEjTFOCwpHrikAPPWTDEZ5GhFxLr7t/rLYdCBQwZ5M9ETa9bb90zN9MAOGZ32XFhUkTdv30MzwoqHlUSL3qt+M0S3SSPcs+p1ybGR+6FvZS0bdZuJKuft5BCxZupvOeCEigUm30Wro4EXD/SLqePcjDo+BjHDe7aIDTh0vVrM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=gpuTujhA; arc=fail smtp.client-ip=40.107.243.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="gpuTujhA"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gw/O2+gTkGMtEC06IvPyTCppoetktG2itp3aFE8YowTMG72QEzB9QWPIL1A0+ajh5+qHorovQ4WsJO2w5oxtVDpzGHg34Fh45nLMjx0LfuB0eNDSoFRItN9DMzuva9k2MOAwbzQkadaId9FoYx1t9W8bXaMBOD9KitrP0K645SR79dt8gM33u2zAwjMXmUmqeH85qCLCzT89aaTR51SGm3MfG895UNv4CIaEqCwVdMORoKGTghq6Dq0IR7Fs3o57aBPDqMjg0kfZJyuG1W3Q2hjewn/c7GQKqW8X35873XqSczuz/mAOGkMB9hDKZDebQbQjKF8xjuWFcTmWJSALPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/ONeKY+WdpmnjdHCBDrcBuPJxg6LgQn2VyaSVR+2Gys=;
 b=XRTpHPzNCLlfL21uEUIdefLZbUMBZvAjTrZm71zCeexFf1JlDal6IANdVu0uH4d1m+k99gne//3D+cVFHYPJPPqT7x22tWUlBI4Lg27FKukIbdWSkrqjHzMct4ZNyLQBTC24KdIS84xXbLCmj9hGfeDRlrdLSfzMLu3zfqA7yTJvqqgadPPG1uIfYt2wBQXN62pT+Eg4jHhagyyAeidaiudOQGrcP7QyAtL24IzMuhFYnZ/IFS31fZEKtGpq8wmmZq0HJDLmXGr/L+8Oh7ZxUS4EC2egj0EabvsNRzw7tYkZWdnMlnmZ6hvqn/K7lp7bO96Ca2prJj10PNnNr+juqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/ONeKY+WdpmnjdHCBDrcBuPJxg6LgQn2VyaSVR+2Gys=;
 b=gpuTujhAyjoP6LkXKd9j3X41TcxeEX9RyWnNfayUK0AsTy5pCyuwxtFiSHerWltRKua+oeiMQGnqxWS/b7oU7VRP4Hiv9ow7hSW4t6j8Y3FTWq2pbUXKg3U/8H+DYTIZImQGcN7ju4D6y5oRJtndKMF2E8nciQ0GYUzmiH64Flav1IelRW7d50EDBPMyvy9eFMciCdSG9kAj9Xz/TH/OOpvHRbM/DMtWYu6F/DRLPa+WdQ5a596KFLZq/JLFc+rNi0Y4P01iaY75k4/BljeUSwUxi+8rnG+yw4f7MdwbQUIETMT/ctEFsIs+9am+Cb4f+o6M+INzmZfvmpcZBT/duw==
Received: from CH0PR03CA0300.namprd03.prod.outlook.com (2603:10b6:610:e6::35)
 by PH7PR12MB7967.namprd12.prod.outlook.com (2603:10b6:510:273::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.27; Sat, 14 Jun
 2025 06:35:52 +0000
Received: from CH2PEPF00000147.namprd02.prod.outlook.com
 (2603:10b6:610:e6:cafe::ba) by CH0PR03CA0300.outlook.office365.com
 (2603:10b6:610:e6::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8835.23 via Frontend Transport; Sat,
 14 Jun 2025 06:35:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CH2PEPF00000147.mail.protection.outlook.com (10.167.244.104) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8835.15 via Frontend Transport; Sat, 14 Jun 2025 06:35:51 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 13 Jun
 2025 23:35:40 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Fri, 13 Jun
 2025 23:35:40 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.11) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Fri, 13 Jun 2025 23:35:39 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: <jgg@nvidia.com>, <kevin.tian@intel.com>
CC: <will@kernel.org>, <robin.murphy@arm.com>, <joro@8bytes.org>,
	<praan@google.com>, <yi.l.liu@intel.com>, <peterz@infradead.org>,
	<jsnitsel@redhat.com>, <linux-arm-kernel@lists.infradead.org>,
	<iommu@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>, <baolu.lu@linux.intel.com>
Subject: [PATCH v2 09/14] iommufd/selftest: Replace mock_viommu_alloc with mock_viommu_init
Date: Fri, 13 Jun 2025 23:35:21 -0700
Message-ID: <993beabbb0bc9705d979a92801ea5ed5996a34eb.1749882255.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF00000147:EE_|PH7PR12MB7967:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b204b24-a908-4430-8462-08ddab0db506
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|7416014|36860700013|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?TmV4yeBDlyZbbSR4GHKAlZm3UUJenL3eu6w+GlGzGrCugOsqRW/dH0Dy+UwU?=
 =?us-ascii?Q?96DhOxu5bhfZvW3u8WrqPYxdl0cptb5ISzf9DUK6xZ3jPNPZXg7eETJVjFbX?=
 =?us-ascii?Q?+tC2jyFHbk2XR2zw0YK39Qk0FrO5pD6boH3+Dg4nhwK6eVBbIES3DkPlqxmY?=
 =?us-ascii?Q?nAwslPF8lRm1PMzfhmhyiUVPld24Ote/oxsvGmE6sjf42kgwMj3UXqUl0P99?=
 =?us-ascii?Q?DrSgbXuKW8/K7AxqCYNbIeHuyONhFtO/nL6vrZ8NgQQOepDFYaTx7zFopmfm?=
 =?us-ascii?Q?3N6Dukef8dnXyWBgC2TI3Rq62xy7MZJ2uk6gtbi+kRce9jAhTL/JORekC4Dx?=
 =?us-ascii?Q?a5xZSpwANk2K8Umc+ab1c8+OFIiVqlMpVMrzi10+u8JgWtEzonsBs7yHZIdb?=
 =?us-ascii?Q?ZBELmkkOUjF5QWhGbPb52JZWQdWvnShHjODu4MZAA9k4Dvt1RT184VeIzCtv?=
 =?us-ascii?Q?z+joYL6/smPYyxrdfy7usR4xx5iYLvYkuzNXM721ToTG2KvZMZopF5kdQSd7?=
 =?us-ascii?Q?ZjDLKkyuLlhDE//+7VSDLNWBpNkC+YWvefnydjMtK9Gn5x/mE0f8LVqCQIqf?=
 =?us-ascii?Q?dCNvZKuRMjLOc3/FLiNE94SVm//1CDicLBq47FTCpcnXpv89uyvD8FscON0v?=
 =?us-ascii?Q?7O8o75+aSjnrJ04GhCo2HgVL7VzYpmD6L3utQYfdYW+MExkft0yfXfKZ81/v?=
 =?us-ascii?Q?6My+yTFVkj0lSBmSlgY0f/5IkvEVI+XLvUHlOrzJqq8f6WDBVRY1ZIoGayHi?=
 =?us-ascii?Q?RVjpGOermeEQeVzYfeI7AxHMjXzUEKf9skhhTTYnfiJDEVatUuROh1WkVf8r?=
 =?us-ascii?Q?ZWByrEpuNr69/AK3CSYVKdOlxFud/EKUP0ms0VTaU3oWW6amLwXd0kXneu5V?=
 =?us-ascii?Q?a0cFQbtWT/VicPyv5QKFPdw0SYGDqFzbic9aAmUNdAowOHf4liUvp1Hii1Rw?=
 =?us-ascii?Q?i2MtwTCUbi4k9yT63hWOr6Dq2/7+WWFVuyPnGl5ayg0hbsSx6+ZBovBk+v6Q?=
 =?us-ascii?Q?T7h2RJbDUPf9UjMJ8WnD22jKJYcgIaj/2VsUZ1ps8v0+afiB+w2Z+aW5FjwR?=
 =?us-ascii?Q?SC01NysDvr4PsheqKmywrvoVADB2sGHVt/bFK9t5vAt8xmSRMQ4kqzfLLQ0Z?=
 =?us-ascii?Q?uqmnsXvWrSv5a3Quw+2/dlwUYHhzSQ+rx3RvXiuH0rpXNdON8PJdqP+/txYR?=
 =?us-ascii?Q?gaYIbrT3x9Tg7ktnRO/3/YDPXeCRzYWs39Gft8hZiPPB7RX6pZas5k60Fnl1?=
 =?us-ascii?Q?WVU57BPg6sloHdv3BLm3DZ9T5zo6F+eaJ6ePeg0LFAqMchwQYiLbSOcc+BmB?=
 =?us-ascii?Q?CQflVLqToxcJ0Qz4+BjPQjNrHmDMlVjpI+dsVcO8gPWgdiiHDNuCqPrDxlTO?=
 =?us-ascii?Q?WGr/F6O1z6YjpdVeVHlr4wdoeim6eKrPpR+qZuSshVViLPy6LyQHFXkeGpj5?=
 =?us-ascii?Q?198/i9mbm8uqkQcp5d9cuAbO5vSpMIVwxXC1NWOGuOGkZp/vxSE4vOc3vfpj?=
 =?us-ascii?Q?28Y3Z1cAKBdS86i2TbQnNW9T0t5aBfgj8XaK?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(7416014)(36860700013)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2025 06:35:51.4907
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b204b24-a908-4430-8462-08ddab0db506
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000147.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7967

To ease the for-driver iommufd APIs, get_viommu_size and viommu_init ops
are introduced.

Sanitize the inputs and report the size of struct mock_viommu on success,
in mock_get_viommu_size().

The core will ensure the viommu_type is set to the core vIOMMU object, so
simply init the driver part in mock_viommu_init().

Remove the mock_viommu_alloc, completing the replacement.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/iommufd/selftest.c | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/iommu/iommufd/selftest.c b/drivers/iommu/iommufd/selftest.c
index f9cfb3a20860..74ca955a766e 100644
--- a/drivers/iommu/iommufd/selftest.c
+++ b/drivers/iommu/iommufd/selftest.c
@@ -769,25 +769,23 @@ static struct iommufd_viommu_ops mock_viommu_ops = {
 	.cache_invalidate = mock_viommu_cache_invalidate,
 };
 
-static struct iommufd_viommu *mock_viommu_alloc(struct device *dev,
-						struct iommu_domain *domain,
-						struct iommufd_ctx *ictx,
-						unsigned int viommu_type)
+static size_t mock_get_viommu_size(struct device *dev,
+				   enum iommu_viommu_type viommu_type)
 {
-	struct mock_iommu_device *mock_iommu =
-		iommu_get_iommu_dev(dev, struct mock_iommu_device, iommu_dev);
-	struct mock_viommu *mock_viommu;
-
 	if (viommu_type != IOMMU_VIOMMU_TYPE_SELFTEST)
-		return ERR_PTR(-EOPNOTSUPP);
+		return 0;
+	return VIOMMU_STRUCT_SIZE(struct mock_viommu, core);
+}
 
-	mock_viommu = iommufd_viommu_alloc(ictx, struct mock_viommu, core,
-					   &mock_viommu_ops);
-	if (IS_ERR(mock_viommu))
-		return ERR_CAST(mock_viommu);
+static int mock_viommu_init(struct iommufd_viommu *viommu,
+			    struct iommu_domain *parent_domain)
+{
+	struct mock_iommu_device *mock_iommu = container_of(
+		viommu->iommu_dev, struct mock_iommu_device, iommu_dev);
 
 	refcount_inc(&mock_iommu->users);
-	return &mock_viommu->core;
+	viommu->ops = &mock_viommu_ops;
+	return 0;
 }
 
 static const struct iommu_ops mock_ops = {
@@ -807,7 +805,8 @@ static const struct iommu_ops mock_ops = {
 	.probe_device = mock_probe_device,
 	.page_response = mock_domain_page_response,
 	.user_pasid_table = true,
-	.viommu_alloc = mock_viommu_alloc,
+	.get_viommu_size = mock_get_viommu_size,
+	.viommu_init = mock_viommu_init,
 	.default_domain_ops =
 		&(struct iommu_domain_ops){
 			.free = mock_domain_free,
-- 
2.43.0

