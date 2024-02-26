Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2081.outbound.protection.outlook.com [40.107.96.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BB3E12FB0D;
	Mon, 26 Feb 2024 17:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708967268; cv=fail; b=hOVANAF4a76Y0x11Z9QvQaG85blFJI/o5QofPCJ1Qkxing4ynCwE0B2n37q7ImR9HSlekc6BokmKiTYdZiVv9Ctbcf3wtvierxJhBSxBOuaed+gb/iOMoZ0UulxZIbXZKevpPlBPOiNCm6snW/DXhGYCbeMyna+ZXULSG1+RHNY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708967268; c=relaxed/simple;
	bh=WnARMlNTP+j+blkVOki+4xxBRCe23wtr+Kg6XHUUU+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qp07Pzu9KpSwZ8w0hf8hjpkoGacA4z0Qek78euVFJtdH4/oPTGysgbO5Bxy/USOZXcmNkr8WdbqKV5K2sigEuCUDybaSZK21sUqyCC3Fa8PPRsNTfC14vk3CdMHgQSvxZhGDqkRrbvJExbYRfUn7vnghhoSYYZEEdPjR3GiIzOc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Tr+nSZsC; arc=fail smtp.client-ip=40.107.96.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Tr+nSZsC"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bk+4KDuBUWBRtL5vh3t8V5+/71reeouctdxe9HLyXkxV8kYeA6/9OXju2GTm2tEa53401HqVwFC5p0prvNow7ir3SBUH0D9pyVz97h0BMuRL57TMR5OvDGU7igdjbtdi+YoVdQs88cTTXw/m6l7kBLm9qFIFGvBHfj769kqnUdxKRSYfVgkUfQZYLTh0N0ETFRrVw6y6sHxsIPpkh13lqC+nkU8Ja/oYbOSq6PAkAhpJYaCuPzwFIxL2uaADq6jsJ4ifOGN2y3t/O/JBcFILjebAAZPv3iQTdigQuiveN0xO+tTpR9FOtZKypzTq9pDMb276+8zvWctsT8jhVt9gxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9HKnHrBwb+Z+1l+yckkMjT3Wrn3vM7nTUOTP4JZIUD8=;
 b=oSRceYM3sKF1XvQq9cB6OKZ9f131Bd7r4coivOKmoOjv+/zcK6ZxsDV8ccVuDqtBjQcqM/LtRcdbUvVDXp5De6yyzLGOs5f1RFRw9xZa6dpN9ohn6vCVCSOte+rfddfq5CV/T0SIIFeL/+luBgCed4IQiqGPMv2170Ifci6HW/MTVYF57TtuTazkyl1pr5xWnUMAVwsYL3d6ISAUKhSKn+WzSXu+OnZ6cZc8x/f9Bk16gI9jGNcBb6CuLJDI2NQ7dceSZi+I/e+cBqAmJyz8+c8FXj53CXCJQqnEJARV6A+WsA3RI7dz+Dbdejy2MajZPijuNKVyzcU3MuQYVz8HrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9HKnHrBwb+Z+1l+yckkMjT3Wrn3vM7nTUOTP4JZIUD8=;
 b=Tr+nSZsCnHOashcbtSws+2MmRjuIBPQWV8pjoUubl7cCTzCqSWtMJaot6CHh8rt9UMFvuOI9fBsp+E90ilaVo5o+enxMe8qXignfGdPInyXIsE4ovgvKcY4F9JHp6WHsN4iw4zWXapp7LBkAi2+7+PhJ5e2ShrHIPd2Wsfeo53gk6OA8tMfv2IgPsCE1uDT51iEuqNYy/aL653LN5j1Koeyg8AfQPpRZrCZXbMk+/T7fIsUokNXYQzk8hN/D2ZV1yXI/CaB+cadER7qEUO0uLuDoeegXLehjBBbcik8VMHniJptSA8goU+zhT3kLzCJjh1zQ76PS5+p6n92WpDo6VQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by PH7PR12MB6905.namprd12.prod.outlook.com (2603:10b6:510:1b7::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.33; Mon, 26 Feb
 2024 17:07:35 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::2e3e:c7c0:84da:3941]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::2e3e:c7c0:84da:3941%6]) with mapi id 15.20.7316.034; Mon, 26 Feb 2024
 17:07:34 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <jroedel@suse.de>,
	Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH v6 16/16] iommu/arm-smmu-v3: Convert to domain_alloc_paging()
Date: Mon, 26 Feb 2024 13:07:27 -0400
Message-ID: <16-v6-96275f25c39d+2d4-smmuv3_newapi_p1_jgg@nvidia.com>
In-Reply-To: <0-v6-96275f25c39d+2d4-smmuv3_newapi_p1_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR16CA0037.namprd16.prod.outlook.com
 (2603:10b6:208:234::6) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|PH7PR12MB6905:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ae04752-1fab-49f0-ce70-08dc36ed6aa8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	8gmq6hnMkTkpgqNJYRsFfvQ2JRo3Ekc0EI6IrKlbeGw8hwfXF3IjbxrK93OUmdZDMe1elK2EKqUNh4kvYt2jSgPG5Jxb3y6aMBwKVJ2C5do3RQu72taPC63LWrh5SQkbN6okiZWRexTTI81kKXugbMjHTka99o6k9rr/fWQ/yQqryEfCj0X2ScCyvGvfwKAMYuXZM+Nu3JJTjST5TA/MFK9XFql30TiWSrCuApmXPBEG5gnpRMaK9iL7BTJRjvZDLLsqEzX75QvFdjYpwLS1OMnpMVFZ6kAUQTHK5da7kSFjCiHE2b86KG+hEDv8yUHGYxGM51qEB5DmocAH7/FkMHA+aKccNSrtoR1zIjIphkLLgY8EaaQzl4/ZfUlNvO8cfwlQCoJraB4jhA7RinTeAtt99uaye8p9EIoan/0RsHKozq4x/6ux973bfShO5QTL8EK99rDYcX2MLz0pkSjS2MuGmx/ijCA1wi00Bvvzv2UC9RrXpsCuiYYeuXMYxEMtS47TX0qnjsG/xf5TaGsMBCMpZWH7ixXhj21bV+dNvbRVqHEXQSX3ov/96h0L7kOrK0EIGYYRmDwogXUGjuXgzIrZ0ncINU2jIEceEsJi4xej5ugm13n5tnXyLyOgfe8cP/ZkH0/QSE7Cxt3uZYADMg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?EyJxObzagnR8Sx25qZbOVq8kmHwNasVTl+hNBIEquw869ykaMbXRXYi0xkpD?=
 =?us-ascii?Q?Ul6NNTfa/Z4znOKZnKZwEQItbuNp4IL6CviHGe7tqnCzsubzljGmuezIzufE?=
 =?us-ascii?Q?0teb6ZCdr5bR5aZlxlEX4Ue6OmpGzsmpaBsP1BrU92bQRHzQYH4K9s3NqOtG?=
 =?us-ascii?Q?irLxEGHp5JbGpuT7MMgWAk/5FhvfzUuZVLh5o7TBWI8ilfWDiEV9RuQqBl3r?=
 =?us-ascii?Q?Sb/104WWz15bswU5b9ev0xvQBbjYAkNCXuu9VR5m+9wrI0pinhtuGkpGNJIh?=
 =?us-ascii?Q?wlDIYbYhNqat8P8XiUsEyJicyu9xKw93/tKDybQ/1t6cfqynT6B3IH1vWSEn?=
 =?us-ascii?Q?E3+vhYJwlV4BKQgJC0+FkwAz9QQF8cnaxmvjO00yvVaDS/qDNmZsymx0Mxxx?=
 =?us-ascii?Q?ETLjr9FJojckwm3F1H+fPUj0ZWfKPYlduOZS9axT3yrYWlGGOid4172p29gn?=
 =?us-ascii?Q?TBPm5uLoV67yzUNYdy0luB8wW98+I+BUhEmqdIA3ex9vXDAd0wow8zhH2whg?=
 =?us-ascii?Q?bK99h+nDAHzWjuR8Vd3pn9WuUuOmnFdEZFmTi8G+4NvWj6LBg5m583dAyYkd?=
 =?us-ascii?Q?dw/Du3dmk6i0JlVa0QrZqyvTSLYjwRT9AHbsJLT30GhwAFMuEwZcrsvaz4hE?=
 =?us-ascii?Q?ZhKQyRYxWvGNdxki6IS+IOkHCcdcEjLyRO280aXxf6+bA22x8e4u6Z0yHCcP?=
 =?us-ascii?Q?aTbQDQWn8zpWC6pp+WNiaM7+YIa1yyA2mCyP4kMxiE9QPvSTpc5Go07naPLh?=
 =?us-ascii?Q?4uVCIz4R7fT+w29VfL1hok8bcThlNQdY0Z/B4a7nT+ZlUkkNYc+QXgtTcu63?=
 =?us-ascii?Q?MfS9ct4wqfg+l9iH9/2VPu35GsLH/gCeT/ObhbvHj6y3hsI8BBYw+vd/acwi?=
 =?us-ascii?Q?BSzQGheeATXpke00x1g48ooxyuMhloUOuEVj+XjyHTRUcoOlWO9pzZxyNzGI?=
 =?us-ascii?Q?sR/qdVIdWaNK1T7XxAv9nyTsLB4hI8mFARea9uUT8rEFIrNzY6xi/cjSPogT?=
 =?us-ascii?Q?orWSXH+F4sQog/UhtBWGd8r2pokbT0GKfOHEf6uSyOZc10ag7OuXpVpQIZOy?=
 =?us-ascii?Q?c1nO3xx1Kl8zbt0xJp3agc0cw+jfOa9uqVyqJ7fO61EvukX/5Pra/npO9MGD?=
 =?us-ascii?Q?FRYuGD0Ef6YEb1TwB0BuCfcjVeZncNBlS+fhdwsa/JUCOHIBoRJUbAiw+8an?=
 =?us-ascii?Q?CToQjTS2uuX6kGwZDqHQ2AUNi2Z3TTM8nWHMnXRrORSufSOkMvZY25Kx5mbp?=
 =?us-ascii?Q?6TPojrpst4kq3wGteSM5iSB2BwLefjUvUjS9rWCaiNjiVkBL9Tfj3F22sipv?=
 =?us-ascii?Q?4ui4cDkwlENdxdMOzPEBtjVh73MUaUWqdDPfnzaOUjULXWxB6/cQNb5Nmy7i?=
 =?us-ascii?Q?+S9lENudshdxEGksiy+MzodgOxclVrzUHXYNcdz36/xHGDQddyyuWW7JTcLN?=
 =?us-ascii?Q?pGOMOxnzPdedNpvl1RIYmRfnNPT/9ivTgJJE5PQUnghpyBS3mdQRQGLegWyT?=
 =?us-ascii?Q?VMnzZAKiVZ1A1kWCHhzTZS5IdOwDMkMVGz6oo1Qw39m/kSWY1Jk9Odq2rY67?=
 =?us-ascii?Q?kXIt6tn4MQOyxdOMgPRieFTX56UTJcu5M1v5xENh?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ae04752-1fab-49f0-ce70-08dc36ed6aa8
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2024 17:07:30.5318
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R8JW88GMGh2FiEEf716Tz42g8gLvvKcQWrC7YswtG4OHVKtcH41cLr5fJQ+g2eLE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6905

Now that the BLOCKED and IDENTITY behaviors are managed with their own
domains change to the domain_alloc_paging() op.

For now SVA remains using the old interface, eventually it will get its
own op that can pass in the device and mm_struct which will let us have a
sane lifetime for the mmu_notifier.

Call arm_smmu_domain_finalise() early if dev is available.

Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Moritz Fischer <moritzf@google.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 22 ++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index ebd8362c8aa3ac..b7938f17222b4d 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2197,14 +2197,15 @@ static bool arm_smmu_capable(struct device *dev, enum iommu_cap cap)
 
 static struct iommu_domain *arm_smmu_domain_alloc(unsigned type)
 {
-	struct arm_smmu_domain *smmu_domain;
 
 	if (type == IOMMU_DOMAIN_SVA)
 		return arm_smmu_sva_domain_alloc();
+	return ERR_PTR(-EOPNOTSUPP);
+}
 
-	if (type != IOMMU_DOMAIN_UNMANAGED &&
-	    type != IOMMU_DOMAIN_DMA)
-		return NULL;
+static struct iommu_domain *arm_smmu_domain_alloc_paging(struct device *dev)
+{
+	struct arm_smmu_domain *smmu_domain;
 
 	/*
 	 * Allocate the domain and initialise some of its data structures.
@@ -2213,13 +2214,23 @@ static struct iommu_domain *arm_smmu_domain_alloc(unsigned type)
 	 */
 	smmu_domain = kzalloc(sizeof(*smmu_domain), GFP_KERNEL);
 	if (!smmu_domain)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	mutex_init(&smmu_domain->init_mutex);
 	INIT_LIST_HEAD(&smmu_domain->devices);
 	spin_lock_init(&smmu_domain->devices_lock);
 	INIT_LIST_HEAD(&smmu_domain->mmu_notifiers);
 
+	if (dev) {
+		struct arm_smmu_master *master = dev_iommu_priv_get(dev);
+		int ret;
+
+		ret = arm_smmu_domain_finalise(smmu_domain, master->smmu);
+		if (ret) {
+			kfree(smmu_domain);
+			return ERR_PTR(ret);
+		}
+	}
 	return &smmu_domain->domain;
 }
 
@@ -3083,6 +3094,7 @@ static struct iommu_ops arm_smmu_ops = {
 	.blocked_domain		= &arm_smmu_blocked_domain,
 	.capable		= arm_smmu_capable,
 	.domain_alloc		= arm_smmu_domain_alloc,
+	.domain_alloc_paging    = arm_smmu_domain_alloc_paging,
 	.probe_device		= arm_smmu_probe_device,
 	.release_device		= arm_smmu_release_device,
 	.device_group		= arm_smmu_device_group,
-- 
2.43.2

