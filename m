Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2050.outbound.protection.outlook.com [40.107.93.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03A596D1A4;
	Tue,  5 Dec 2023 19:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="GnPn5KfP"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LKTPodJiNxZW4QBep7YSM3R4Mu9jzm8C2lLIMiCB+KWr5fJOAr7WXWXmwyy9zM8Ir/WNcdk46Xa/ZY9pRTAugTT/wabUlq4ravK55wt5ngj5CYV/unrIP1edWgqS70DNBa0oUhfqXUN/VDHK/iPQAQMQ+raxZAdX2r6kBSIlyOKR6lLNroHyqoXdnWSZudM+lPtiWHadpCTgsQGcz2bDvZBSa/Y6lxGkFPHpze2f5llRuBVbROw1SVvjmquhOm80vqM3oF5g/KekmU1Km/hA+bX3q78Q5gf26xYSww1k+rHiR2c8Q62Y26iOwHUW3acaiZ2ed/3Yzz5JztcLOlfwbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jw2/0/oSwj2jIslRLSqpZCEey9o1yv2M+zuYQoPGK9A=;
 b=IJfcVJnvrlnsnOOYzDgt+DjNvtZJB3OUmgRaka3T8wvvBoNMDYkoIr33/0LLY82UzqAoipjoHWgZ+eX316nn2ZiBEJUwHR2Yk6Q4hdCKhHsXgUkbNh3iW8iXneqJPhCjo/ebPZUWGzQ9rR1IPgpDrBc9KcRbjeG2eJooOVrJ3rbo2BmxzMB7cRiP9BgAUAcMvafLTsqtNFFktNP3PEzgd0Ikl0g8TTjy80rySYJxmize8V8jLkAirfHyJuegmAjuLLhRA0J+3vK1s6C43gyLMuRbO6NuUjEs9zeNYIO8SOn0sAytFFT6nZrb9F+OIx03KmVFGVN8/ZZGSf6W50TNMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jw2/0/oSwj2jIslRLSqpZCEey9o1yv2M+zuYQoPGK9A=;
 b=GnPn5KfPgB46eq/jK5YR8/RRIMp3KATZ7M3WP+QM0yP7NRspv/tJAuoRg+R7PlojqUgJpUdj81uipq4aKYwMk90693BsNJ1BNg89MoKpipfW1nzm/HKZWQ3eFEHNOVDwyu0YyU1H26dcXYNHfjf0JbqCdkteUG+YJyKpvws0/SIMV2wqTCL7e72cAJmyJOSIDC1RWbTj28kVSDMUqWekX9o2dtFK1qhQRoH8CPPR97msTE7vWsUA9rL7OZBjE62APwYkn8ZHMK+hkr3RC1yydegCFSWC2Q+ZD9BNeNbKP5ynMPZ5bfvNoMCMPSELXue+aYCW/CbhEAxbHTw1mCEMmQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB6588.namprd12.prod.outlook.com (2603:10b6:510:210::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Tue, 5 Dec
 2023 19:14:52 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.034; Tue, 5 Dec 2023
 19:14:52 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH v3 13/19] iommu/arm-smmu-v3: Pass smmu_domain to arm_enable/disable_ats()
Date: Tue,  5 Dec 2023 15:14:45 -0400
Message-ID: <13-v3-d794f8d934da+411a-smmuv3_newapi_p1_jgg@nvidia.com>
In-Reply-To: <0-v3-d794f8d934da+411a-smmuv3_newapi_p1_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL6PEPF00013E06.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:22e:400:0:1001:0:7) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB6588:EE_
X-MS-Office365-Filtering-Correlation-Id: 643d38ee-03e9-4f7c-5304-08dbf5c674e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	VpQlaq6I9Rh9uzHT10xk40gsxyRP1JvRVjiiPVEmpfkwTIyxCVLyXIuwWJULaUvlY4aXR+5lsceXSHLN8BxyeeF6EQz5EzkD8JimAqijN4XVLTV5GByG4s5iv8+xcWPzqRXCy3RcEy68vlFmmb3mJUG+DKkhpHFrWwYIwMgtYiukLpa5Il8EIMf3NVW1FKAyMXQGvDPizqnYoZXgxHhAoH+ZMPEoMuoYk9GjcB8nIr+VKx2Kg0DIyBmu/Jlp5Ji/PeFFhzjHeHSmRO4DplzYtJJtWe4r+85ak1CsgM0k47u35QoamQ0unQjhtbxK6OaHDHmzcl6JnhxVHl9s2jqTmDqRKtaC6MPIOLGHBGrvGk3YkZjMCbeNIK9y+Bhahx/5XRLHBLXjOBukPRjlRTZSRbo9KH6OUVc/mrOeUlGO7zs2B03WfXALvAxZNAGTTPINvde9yXY6jZlzChEEWmtr1RvfEEZQJJEjuwA5QIuyvq+oHtg+B4UPHSPveu5i9LbL++GjxOFsoza9gB2D3qudDbzKdJm2QYGIkTfrNzlV1EYVuYFIL2L+wcoTIivXFpMu
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(136003)(396003)(346002)(376002)(230922051799003)(1800799012)(451199024)(64100799003)(186009)(478600001)(6512007)(6506007)(8936002)(6486002)(2616005)(26005)(6666004)(54906003)(66476007)(110136005)(66556008)(8676002)(66946007)(4326008)(316002)(83380400001)(38100700002)(7416002)(36756003)(5660300002)(2906002)(86362001)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?h49r7rkI2wOPyl7/wDMU3eOLygQMrcSOUkrTkfNwb5zOqr++Vh8ClCxg6tD6?=
 =?us-ascii?Q?7gXq4a+fj2fl7ofyVYfxiZzvk/5ifq9THjyuIP767ieUNlVl5/AfaPk4oETN?=
 =?us-ascii?Q?cGFTvyzUy9lLaP5UogZ9ef2zfXtT+YOjS7ImLMmQgFbAXeGxdR1S7k4go/Bu?=
 =?us-ascii?Q?v3vagornOI4765fU22WZAUIGhrDB9zsHkf9Mmc4P5PlpJgXYQrNTigHRo6DP?=
 =?us-ascii?Q?t42J4sxjlVHfQ2wHSEVxP9FKlwLI2Dd+YuUDgoJnb1fb1MytLsmEefxifuyJ?=
 =?us-ascii?Q?Q6p3G65X4VU6uLXyy9lrhpLLeUvdjFpnnPB8QXwTghPcUdlp2QcJfluyFo7d?=
 =?us-ascii?Q?p4dsk5XtsIDtNaWBA7ufpd4ggvIH0mrD7lt61K09KrJZ9EOqlB/fS2seLoUD?=
 =?us-ascii?Q?AUVnEOhXuedKsuHdWutWt7BVPo+Ujp+kRewOQwUSsBAPaI2+bt5flskLIChQ?=
 =?us-ascii?Q?nZdY6OL+UeZ5IheclkgEapx4zdWFps5t2mdrnFgWu0UW3kqrpb8bjRAmHrHA?=
 =?us-ascii?Q?Ppab3CW2BSeaIn83aavVwWDrLJs+VHgiJPppAnghGnhHvVlK0yhKFS4NUR1W?=
 =?us-ascii?Q?NfkMIywU48CDGrtLk1hWXtZ10LuX7/1rtR4G2JmxDelCOwEhpvDvZHIxj/bF?=
 =?us-ascii?Q?IG9zPG9PygRhwCFXN4ngQovDfLLvuLTA89VbrVjDygTw59rmjWBK35ilfv20?=
 =?us-ascii?Q?+VXpIg886p0waPVr1RCuge7xYA+m+3r8XYZsrC0tNbE8SlpEBMaI/BJJ850t?=
 =?us-ascii?Q?LF4JCmJ0i97Bjkr3dqFaWACEtyHqsSQgJsPaN+BD42h36uJt6CxkAHG6lxLY?=
 =?us-ascii?Q?bFJ6aOnwDvqpqFeKM65lMQR1mWESTjpiQzqn0iiudqmxOJ+e8ec/m1uzs42h?=
 =?us-ascii?Q?KQeKZ9Vas1vw5r6zIN9CQU/umnPB7ejEveKD2VZYZSzZj3GNWQAjZjRbaVB2?=
 =?us-ascii?Q?/4HGfBPDypQM9DnRIrLwTUKrJwhPXNIIWkJ0YWozqTn1RduEVfszlQN0PRnP?=
 =?us-ascii?Q?ZZGObmFnhj/3tvB/67OJldIca9yIi/Z0nR/Drx3cA0jjs9ZXsGSee/hmqvR4?=
 =?us-ascii?Q?F/ANn9j0DqqlTUxAt9Sa/SX62KVuRPglLrPEcn50Z4f6T8QudQ4wsAUq3H2M?=
 =?us-ascii?Q?rqPowPZnurBiP8Bx6QWRTZ81DEoaN4xa8jM67m8NUildWirE4c/nH3Pketzi?=
 =?us-ascii?Q?ce0iSYjq3ORT5DWX438CTGnl1T1yYF8ZJnx07+1jifEkY8Ixm27podmoUrcj?=
 =?us-ascii?Q?S8YJbWPJZabdBJKQ/VAAnxgX5kHcENSLpMWX0crlNovKCKf/DJhLKJY24ZgS?=
 =?us-ascii?Q?T9DKQePYKVtn8ANJ05wljipowyQiENAV8wmtU9ocynNhmcGexa9tfslStNsq?=
 =?us-ascii?Q?w7EwWs+3qphH87OiKvl8Q59hIjITQ9L7pb1rTi7VU4bntmiWf19OILB0Kxb9?=
 =?us-ascii?Q?3p68aWUU14Xbb1Hn4GWbc09yxh/18+5ZBefFYvEnHlWt3jwNLYmZ/oedRIKy?=
 =?us-ascii?Q?fK6q0YeX6O+pY1IE2DalPJGhLMmJWkKPOUNuOTT6J9lzwH5rWSOUJH5xZYVz?=
 =?us-ascii?Q?t/LY17WIFlaGjRuU7gowYZNQAb+gNA0pgHq7Zv+Y?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 643d38ee-03e9-4f7c-5304-08dbf5c674e3
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2023 19:14:51.7920
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wkw5zWrAP1ByfVKEU0vgbkjHBjVX9o9xrUMnGFrosbvLtTLUA+RTNGhkelAoOSRG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6588

The caller already has the domain, just pass it in. A following patch will
remove master->domain.

Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 212d0ad7e5f911..e1de2799310961 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2394,12 +2394,12 @@ static bool arm_smmu_ats_supported(struct arm_smmu_master *master)
 	return dev_is_pci(dev) && pci_ats_supported(to_pci_dev(dev));
 }
 
-static void arm_smmu_enable_ats(struct arm_smmu_master *master)
+static void arm_smmu_enable_ats(struct arm_smmu_master *master,
+				struct arm_smmu_domain *smmu_domain)
 {
 	size_t stu;
 	struct pci_dev *pdev;
 	struct arm_smmu_device *smmu = master->smmu;
-	struct arm_smmu_domain *smmu_domain = master->domain;
 
 	/* Don't enable ATS at the endpoint if it's not enabled in the STE */
 	if (!master->ats_enabled)
@@ -2415,10 +2415,9 @@ static void arm_smmu_enable_ats(struct arm_smmu_master *master)
 		dev_err(master->dev, "Failed to enable ATS (STU %zu)\n", stu);
 }
 
-static void arm_smmu_disable_ats(struct arm_smmu_master *master)
+static void arm_smmu_disable_ats(struct arm_smmu_master *master,
+				 struct arm_smmu_domain *smmu_domain)
 {
-	struct arm_smmu_domain *smmu_domain = master->domain;
-
 	if (!master->ats_enabled)
 		return;
 
@@ -2487,7 +2486,7 @@ static void arm_smmu_detach_dev(struct arm_smmu_master *master)
 	if (!smmu_domain)
 		return;
 
-	arm_smmu_disable_ats(master);
+	arm_smmu_disable_ats(master, smmu_domain);
 
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
 	list_del(&master->domain_head);
@@ -2609,7 +2608,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 		break;
 	}
 
-	arm_smmu_enable_ats(master);
+	arm_smmu_enable_ats(master, smmu_domain);
 	goto out_unlock;
 
 out_list_del:
-- 
2.43.0

