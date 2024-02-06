Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2050.outbound.protection.outlook.com [40.107.237.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A39A131E56;
	Tue,  6 Feb 2024 15:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707232394; cv=fail; b=gpOHZJV5Lqo8RgRPXrFtY3+rv+4ymM0gu4MYkg6WcETvLGf/q/M4jB6Z5gBdtqKPlYmHPKeyGPrZlU33F8qbnHzrz1tucARN8tfammN7CbaIPognCiJQIEobJXKmybieLpZCl/fWFI+v6BecHAFuutWwB2PV0OYzl8z/YUJKADM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707232394; c=relaxed/simple;
	bh=ChJ4h7XGcGyu74+eT4K+Rd+AMq9wVsWsoh1cy/mco3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pmt2cvGflV/C664GVhp2jxFfw2cbrfHsFCypngEk6LUqZJBmaLr2Eooz7ws0rnzpTSdAFa2Vb+6T70JfiJgkDzyq/ubNFYLyebIfU61fp93px90U3f0NA/Tdi8NMavYfqRqZJNh34+a37rqrN3E/Vz0ZDG0kozdbjZMKA7nsaXk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Efrnc4nW; arc=fail smtp.client-ip=40.107.237.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Efrnc4nW"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ke6YKfxm6Lm6wivjVEk7pdfCgsvrdx2q6sgJRERoEIHX0tAMuYx/0HnBlgisz7wGbMIXVYxKQcobX23ENP5jnHBEViWychPOXSiad3eSxqRZ8lLyzGlkJMfLmAwdOzntRDWDSmf63NT0dLY9jTpxZTZ4qE7oppgl2RKJ+B18aoMq5xWG1qaT7Hv0UUgcdU2qx9pVXGPt8qvlIb1dpJMW6m0e2vpMkBgNIiDin72cs68/AkXMLN4N8GuL6cY0bG0O0U4Q2/8RIa159DDJPQvYUNtyPBJwnOdU4+jBVXetgsWpWrxDRkmZuw6p01ujbeARZVGJ4L3FpTuJ9w0flTQKkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sW7tNq7eII2YgxdUp8hr/WJuijsGCbYer4kJFcT6kv8=;
 b=L8R1q8sgNDvz4iff5Fszb09avJ+vs45agcLZYyCuUay+D0TlkX6HZyqErobZk31DD98o47zMZTyr3xcgcV1sXXnwJAgqv5JSw6DcZKVYgTGYO1guJ2vd9u5uWPSW6rY6JUaWSh3nPFeWv6ItI9jUmX9zeiqgmEf6CKyITZacNQw2k+k6sPePFenm2bmMyBjex4VSt8LB6q5Pl/9/AeEd8HummelAcWZNtCKvszmt1LEyCgdZ9i2tuCapBTZrZd9odcR8PL/TYZtjSxo2KHs4sSSoEFkPe+Eh9A4C9duOxWeRYZXUjY/mosZOMf+uFkhAz1xYni/HN/6++MIpAjlaOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sW7tNq7eII2YgxdUp8hr/WJuijsGCbYer4kJFcT6kv8=;
 b=Efrnc4nWdvlwoK4u1MU5Sfi4q4YLe+pKWm/+HmQ6AHHxmWBWIJmvV3Z02sRmuqwLVPBT4DIBP1zcNYsaVL5cRzqtZZOOAnxRbIC+dEHrLXA514lAj4N+M9LrI8oi9JM/3X6VEevt26ICUfNLmqXA3n5NYElAWw29ujJBQwsQlXEbAoruzxFh3/PnD5f2ZiqlGgWLa2dpP4aDMMM+Jsx54a47QvDglrm9luXuDhZQsrp8vDXQ5EKWqoL+AmNvTsbOv/Az1C2BDflsAvLuDgqZAw8qrcXKRennC4iuL1yBIRtLOECTU04Y9oL7Lql5Dv9iGUe2nwbRbAiWOOLdPv7MIw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ0PR12MB6733.namprd12.prod.outlook.com (2603:10b6:a03:477::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.16; Tue, 6 Feb
 2024 15:13:03 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7270.012; Tue, 6 Feb 2024
 15:13:03 +0000
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
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH v5 15/17] iommu/arm-smmu-v3: Use the identity/blocked domain during release
Date: Tue,  6 Feb 2024 11:12:52 -0400
Message-ID: <15-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
In-Reply-To: <0-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL6PEPF00016410.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:22e:400:0:1004:0:17) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ0PR12MB6733:EE_
X-MS-Office365-Filtering-Correlation-Id: 18e8a1a8-39a4-4dda-cde7-08dc272618da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	I4Zr5oJZO6K5I1XRHuc8tR9YhyjQdl3EwsPx/H6ZcJrGIT5Ef160JJSw/nd9V0W5xebhKWJLITjySwUp2pGVNCdIrjrk+zE2P/xmKe49eXxwRKp0IbIHG20/SgS2tiUVyYCqYpBuZmPl824OddTfNZVsFegriEz5eExDtwHTZ7GL7IIzuwggJIcxtSMHazIjT8Uk+zb+lyQLBqAv8oEKRo28PwmB3Qb6xxML37olB2YyYSdVSqwMrKhNfs3Oxtsrz1/B3UjqZdOvCtS7K4ffJjh8vjVVggU31ihuTFu9rq0IW6D/SrSIIVAG/Xm/sN8i/X8vdoFBLSuMd1YA9WX/UsNsyD5dPKv6RCQ2chwnZ2Od/DxozADjpBal83yPX2R1H3VBCamT/WrFh/QLLNJbNDPtqDV35Ul2YbbLkxT+/PH+0n6GmIBp3ru66vzE0QgaEuSRg9fd+tZLZ2zAr99mHWhada07AH2VQO+BA0NoOxGjKMFM17CwhbhNcnsZ9IPFVKqiiTQg5FxU4Qu1NAmcJyHZVylQLWRkWPNnThLmKovMS5+GTZCDpZ3yCA+mTlKJ
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(39860400002)(366004)(376002)(396003)(136003)(230922051799003)(64100799003)(186009)(1800799012)(451199024)(54906003)(316002)(83380400001)(110136005)(38100700002)(2616005)(6506007)(6666004)(26005)(2906002)(7416002)(6512007)(6486002)(15650500001)(86362001)(5660300002)(478600001)(8676002)(66946007)(66556008)(4326008)(8936002)(36756003)(66476007)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?i0KqCXxrX5TSLTK7K1gVOsk45NevrScTbjGMI0c9hXcfmW8hkA0sBltLpX3X?=
 =?us-ascii?Q?TkzVqTCdL9wJtUqAsJSMgppG4Oc92+HsArmyxsEkHGufM3zlI9sSEiLtEldm?=
 =?us-ascii?Q?toOsZPhKrO4HDeqyyWbCWX2zY/7xCx/XDLq/gJrr6z0hFxx+KHjo7ZfLXYiw?=
 =?us-ascii?Q?risVlWYL1xoBQbNrHVcQgSQNRsuHhSBZ9oUIg8ZQZ9RVifenRRuj3cEB9SmQ?=
 =?us-ascii?Q?M799jhnjMC/c59nlLCPXtlPn/asvEDDJZUm5k075eYKCIUr5nJ0/T20rkXNC?=
 =?us-ascii?Q?O9/VoiHLOsZlxXb63qjDzhl7gdiit8zYs7PqtLsD4pwDyhZokd9PiE4xngEn?=
 =?us-ascii?Q?liW678B+NRrFtZDqGiOJIjRIU0oYb4YkJD/rX97GXNtNz02i/cBaEXvjyHZ3?=
 =?us-ascii?Q?T4CmLi8do2cvlmRVDq0iiFMCq6YK/SW8bozGi1u7om5vcxM9QqjxvDHYqpva?=
 =?us-ascii?Q?QjnY9uLWVuz7s7tYOwz2k1+HDOaryQDyAnjKcU+du6Aqyt//4ATlMKB77LHQ?=
 =?us-ascii?Q?S6Q5qYMqj1+zGTKUH0QnnesoSYUUZq2mW7IuiENg3GqAQg7YvULlQ8pGWM6V?=
 =?us-ascii?Q?88kLDPOQzDy4mKWxjP9R+my2FFcGo5o/1yrLP6507g3StOgAyH+4ci74WhKv?=
 =?us-ascii?Q?ewmCwk6BSOLbp6/Y5/BT0LHGxVjL5julPz+IRtMiJdbA+2LqTV8kxX4M9pmK?=
 =?us-ascii?Q?2Kk/+YTdmYzSaSXAkMfJNGcWyX4sXfZs7SwTh1pAXyam4d7bthQ4Y6DfcPO/?=
 =?us-ascii?Q?BLnJGM1Iz9tHxRWpIEFElN79dwwqa8rh1530OiHlfPrdQf8GeZWdqJxsk/N+?=
 =?us-ascii?Q?wmYc4K4grjYFUd1C50k8qzjMeuZPVqjpfy2iD6ONoJyCLpNHL0NhdqGCBvKJ?=
 =?us-ascii?Q?a5E5XM2tNDhZUiTBfBtPmbQSP/kAxn71jam2f9iR6flucxkGa+u/4HJFjlXq?=
 =?us-ascii?Q?72gDHE5ogKfahncU7LbUB/K1Pn1XTB1MRKnVAVdxeQqggJNukeE2QBcHav5f?=
 =?us-ascii?Q?qlZIhWDsUYm9MxNLpDzozoA8RweW2MCq8sBL3rpsQCCAj4wsrR1hwSF/w8jn?=
 =?us-ascii?Q?DRYj1LysCUY9Hu6WhN4HMfKeYKrNL5YUog+epZhTe7Upc/OgDPaAohWw9IyG?=
 =?us-ascii?Q?BKYfyXs/VDnotgCyDGHi9MY0FTfzCkIUBKv0hqMQTHCH3tkjPyMswHNMfO3Q?=
 =?us-ascii?Q?fUz8RNo/vQmwLznG9xTyBqFp7N9vs8c3198VUvEe+nwmd2/BYJDnulEP/J9Y?=
 =?us-ascii?Q?ktAO8yMu0oud7EdxAEmqnvpSEqHo/eLKWfd/leqOH/L+O2Y4lXCgdaRnd4pr?=
 =?us-ascii?Q?pV8T6MUM/d1//qRHbyPr92x7xI/buvoY5CW2sTkygRQNg2Ne+uX06wAPDbNX?=
 =?us-ascii?Q?Cb0atF5hvnRT+z8JWS/tFHlT0OFsnmTIzVs8QNiXTz4VU3X2afbe8PnjMkqQ?=
 =?us-ascii?Q?h7yV2sCZpZ95VlnQ7J7kJJvEjn+IFBB1qF+jHbG6HptLJySu1w7VQ/9w4dOM?=
 =?us-ascii?Q?7CXrD1IZXpq1vRKaNWNNqUvhmJ1Wq3iZwMsgVOHKqzaqRi8fqYDFwne4RwDD?=
 =?us-ascii?Q?rNTav2DUVpDr9RBlQuQO7siRhq0qwXYqhtQGmsPO?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18e8a1a8-39a4-4dda-cde7-08dc272618da
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2024 15:12:55.9991
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dnSZ/ZZH0hWGvi9Q8bOmdnqpLbMpZVoYsrhm5Gs9fa6eOIo7r9ND25NwEmBH63Ys
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6733

Consolidate some more code by having release call
arm_smmu_attach_dev_identity/blocked() instead of open coding this.

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Moritz Fischer <moritzf@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 9271f3a035b5b8..27a2792a6acd76 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2977,19 +2977,16 @@ static struct iommu_device *arm_smmu_probe_device(struct device *dev)
 static void arm_smmu_release_device(struct device *dev)
 {
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
-	struct arm_smmu_ste target;
 
 	if (WARN_ON(arm_smmu_master_sva_enabled(master)))
 		iopf_queue_remove_device(master->smmu->evtq.iopf, dev);
 
 	/* Put the STE back to what arm_smmu_init_strtab() sets */
 	if (disable_bypass && !dev->iommu->require_direct)
-		arm_smmu_make_abort_ste(&target);
+		arm_smmu_attach_dev_blocked(&arm_smmu_blocked_domain, dev);
 	else
-		arm_smmu_make_bypass_ste(&target);
-	arm_smmu_install_ste_for_dev(master, &target);
+		arm_smmu_attach_dev_identity(&arm_smmu_identity_domain, dev);
 
-	arm_smmu_detach_dev(master);
 	arm_smmu_disable_pasid(master);
 	arm_smmu_remove_master(master);
 	if (master->cd_table.cdtab)
-- 
2.43.0

