Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2060.outbound.protection.outlook.com [40.107.236.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E5BA1BEF7E;
	Thu, 14 Aug 2025 01:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755134788; cv=fail; b=cFT6+Uovmdd61jiBfcYaLZz+HUpdJgxc6KC+duZriUIuisLn/n+7yTNkxbj3CAL6gmL5YIagG/YWKSUU0ZMEkH7UPCr+fM8GjlmgTYyaLV1jm1TsT8nZo1yge/BTRTps1MmC7kdG2GdWY04CXbYD80Zlw9mUslFHBdsUUWOBocw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755134788; c=relaxed/simple;
	bh=blIQBQYJAfmmH54Xp/NOl8LRNtytQ6IN41ywkb1z5WQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KP8SC6z+c2ODyR3T1ndWrZbAZbcI4dYX0zpYxnV78GoYCSV6eUR0lL90ghVdyJ5pXVtNN3Jl3/KpIIUdn85EBnWS+CFXKIY2HSLs4aYW4OhN5SRtwQ4oiU6qMktSTBs2LX9zTC+VHioL23OLFUxSxJxCwF7FxtjNYmgVGvYfVK8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=mtF16Thl; arc=fail smtp.client-ip=40.107.236.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="mtF16Thl"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N9OifM/Omv1Iwa1FoJY638rgqq6yV8zhJkg+hes+ZeOwuJtQduh3SqhAMAWRXVn5taEcew51fKKoVOJLmBCK774Eg18W2QJt4EKOsOOPz1FBriNlD3cXdZKc6HmjeLxVJH/QgI7JEYx0J3CpdheIQzIcDqj63jIz5nBV8Z3AklbR/RVshIBph7MipJLeFTmFama2kmXOojXAg4WlJ9+asTsFaEKNufFOuTQ1u9XMGRwD17bfUcyIfhfNS8EDrbsk9muIeK7JBa7L345AlcejmnLGjqQ1E/bxkYWhO611AsnyzwbuiBeEX++1IukO3pwi/79Vu2XAkANDOccNaSxIWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n9tdY7vma3BZOIB/pf+qIbNyJWlUDjlUslTFVsNzYF4=;
 b=Ays3E6P8v1zuHSLQyAS8lH5Nrm2n3Q2FmO+VNq6nXbZz/nVAeSUaJPqb9wdSsIJf1FAW9G9v33HgtX+wwPfS0e91imnFxA1cWr6E/mlkVH8JOvAfoHHt/xv4sf/UnrmlJM0gLaxZS5dreqFLEprh9DXZHT6nOs8/IEcmAxnJR1N2mbFgfsSoFqNtNRbiZ+PQD/8H+1FCtAXGxqDvexCTsoFweqbBGRKvBvmfWelMlprJ/dpAzYLL5V1RSRpxZ3GqJCJ5RtVPUA6awCrz5ekvSOWz/VIFabfT61TY+eQhafHekRgJ6yIoSPIlZL/z6DW1CHvNxKBevaS49tdELj8Vig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n9tdY7vma3BZOIB/pf+qIbNyJWlUDjlUslTFVsNzYF4=;
 b=mtF16ThlgJzLkXxQ3Q3sGXCGzkEoEwnf4sRpQTsobyKln6V5Kkk5eq26DNhz7zNRVWs85sZT/mgxkTZtBOZ3naGHZYQsMZN0jgYqzvExnVeKuO2mZQZU1aw6XyVh3m+Vd/6WxmJLM8yv5MT8GbcUWYOYX9VMtbUhqT5eTC5euBRvM4Eqg3IJJYwKjX73bH4N8o0xn7ISVFSUxrrnBNGAXkBzNulNqNj/sCwHLyvElHxsowt6VLJXt63DAdsAz7Eg2xu04ao+xtUm1tGT6FHXudzIjYY8kuF9cWuOyLtP8o82YLfOwyaNQ5kTkZ2qC6Z/0sraZTHcrj9OL908UmVMGg==
Received: from BYAPR08CA0071.namprd08.prod.outlook.com (2603:10b6:a03:117::48)
 by IA0PPF44635DB8D.namprd12.prod.outlook.com (2603:10b6:20f:fc04::bcc) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.21; Thu, 14 Aug
 2025 01:26:23 +0000
Received: from SJ5PEPF000001F4.namprd05.prod.outlook.com
 (2603:10b6:a03:117:cafe::59) by BYAPR08CA0071.outlook.office365.com
 (2603:10b6:a03:117::48) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.16 via Frontend Transport; Thu,
 14 Aug 2025 01:26:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ5PEPF000001F4.mail.protection.outlook.com (10.167.242.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9031.11 via Frontend Transport; Thu, 14 Aug 2025 01:26:21 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 13 Aug
 2025 18:26:05 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 13 Aug
 2025 18:26:05 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Wed, 13 Aug 2025 18:26:04 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: <jgg@nvidia.com>, <will@kernel.org>, <robin.murphy@arm.com>
CC: <joro@8bytes.org>, <jean-philippe@linaro.org>, <miko.lenczewski@arm.com>,
	<balbirs@nvidia.com>, <peterz@infradead.org>, <smostafa@google.com>,
	<kevin.tian@intel.com>, <praan@google.com>, <zhangzekun11@huawei.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: [PATCH rfcv1 3/8] iommu/arm-smmu-v3: Add an inline arm_smmu_domain_free()
Date: Wed, 13 Aug 2025 18:25:34 -0700
Message-ID: <ba73183b117ef05b53994665be6c1699ce49877a.1755131672.git.nicolinc@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1755131672.git.nicolinc@nvidia.com>
References: <cover.1755131672.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F4:EE_|IA0PPF44635DB8D:EE_
X-MS-Office365-Filtering-Correlation-Id: e7c10e49-456d-430b-8e5d-08dddad193b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|36860700013|82310400026|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uHJgskRqArwd7LY2NWF2dkQHv125ZIuIONnD+XOTQOFmitjQ1nd1Oeu5LyzU?=
 =?us-ascii?Q?OXtIxMFdnFayvv4ezVodzUvj2kXaGzYpxTpW4OT69QV0DShOOFDDpuy1Q+TL?=
 =?us-ascii?Q?0v1FazDfSaSisTkMBShYhxB1TzXfz4KiqxPHqYeQFS+NikQQg9ZXN7ocwB7t?=
 =?us-ascii?Q?jj/pb9SMSRM+HaQ4afsPDKZIww+4AcnYpLqO3mxsc6dUSpEmAQGzQJ2An4CI?=
 =?us-ascii?Q?nXkhiVeRSjlxjvDUu+yqQX4NX3rMtf/8UyenNkv/BuXgBHP5OFFklfLYRBl+?=
 =?us-ascii?Q?s4LaaYBzsZe2BY+yfsJ1m2BzfY40WfLsIm03CTdmw8vdeWxPyeSeAWZXSCno?=
 =?us-ascii?Q?17hXJcyOjb2K2W78tyZuxoQwWa1eE4tvfTg9fz5d2QT05LndffoYkknEMiGR?=
 =?us-ascii?Q?fm0qgZqvW62f5VIr94MBrhAHmu9KEmAujnVdS7wg1CZCQesKUJO4Bc3ZhtC+?=
 =?us-ascii?Q?CuWSf835Sy99l1N+MX+PR/eB1ElvKJqu9/IcZn1iG4zwQ7PR9BHwNJyRybPs?=
 =?us-ascii?Q?WLGDoHoskoHWUkBS8e2581Mz2+gM9EbC3iT78ItEh3/o7XULTonRzhD4FzTW?=
 =?us-ascii?Q?JfcKzzil+VecYv/+MXIgwksyHcLKT69HDicZpuQWfmaCbWEn1VrDiJAhQUJd?=
 =?us-ascii?Q?FUPaf6i/VScFHxNfAciRM6lhcaX6f65r+q5qM2YAJvzdJckW1Z7+syAFRNQY?=
 =?us-ascii?Q?MstqOHoE9EUEKh0Qh/dBuB+N4PdOKU0fabNfwAdBNQa1pleiaKF75TQp8Rd4?=
 =?us-ascii?Q?uk7R5bFmAqgzLfD9YphnmygY8cDM6F2IhS1b0iptsrpsPnrdZBDMp703WUx+?=
 =?us-ascii?Q?bZXSQb3SRywkt4lRQuKQQ+X54sOwRe7TTpa4PeuWKfrwjy4TLKGYmm38KbO4?=
 =?us-ascii?Q?PPSIOIdQzjfb3SVCkof5sadXwcGu/+jHqNKQY6idAsXpiWgjBml8sZzNVc1G?=
 =?us-ascii?Q?GzBf+bRwRBjHg3TpZjlsgjmJ7DJFpoNtvH0b74YstIr/lQVTqwdWFDE3TQMG?=
 =?us-ascii?Q?9Ew5SCk03//EhH4cXBh4zUPLQhUB+EI1BdhrKflDI1E1r9+1bcOgGEFo6QAs?=
 =?us-ascii?Q?ySV9Lz/k7OZoSYJ42Pn9L8qZTbS2PIl6BkMWwoik0g7XMbE6LULyxAdgjPiv?=
 =?us-ascii?Q?zFNi9fv3qaodyYB4z4yRn1FdAjiQWITgmQwzuMtwL7zbb2E00aUVwNXXDfPR?=
 =?us-ascii?Q?OFBcTM/3hSqRAgVujuBOaeQGIU0KgPoh6qdC7WDP5L6hFaynKIAmz7Hyq4ij?=
 =?us-ascii?Q?6y2unRHwOMw+RB4xYfLINq/mUZpFZjUF+7PUAWdbOjjp8xPqFHIQV97VvaFA?=
 =?us-ascii?Q?auDIgCetOqWyF2ZeK+fLf9Qvd0XfykGaa1K4eHzVXVYEexIzcPtg1zebb+lH?=
 =?us-ascii?Q?x9C4uEhOHy9zCY5Vja+zgCgtpbXOI+L25sfYDhh9Syu2/icY1VnD0PajqgKe?=
 =?us-ascii?Q?pOH3/qOsGy1WoAnQMRtR8zLqXE6l72muZGzR+4BsT3h0SmQegf6TkDH+DgD0?=
 =?us-ascii?Q?rrzQBc0kZZ3eyENqbyZrNbVYLrMDEqTYNtJx?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(36860700013)(82310400026)(1800799024)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 01:26:21.6454
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e7c10e49-456d-430b-8e5d-08dddad193b7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F4.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PPF44635DB8D

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

