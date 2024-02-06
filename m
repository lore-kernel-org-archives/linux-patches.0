Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2050.outbound.protection.outlook.com [40.107.237.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7327613BE83;
	Tue,  6 Feb 2024 15:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707232406; cv=fail; b=PbaF9iUdMIKiqacJ5S08ReNhZFSswRXzuxAcDUG8KebzYjpzpwQRI7OMvX9Pd7HerX+77637T5zRqEJMEdLfBWL+4CIuY0VpCelHQSErzxu8BxS0FeqzmAK0JL67/QVO3DQDYr+XOvlfnxxksgMYM0hHoqmCOgY67+an4aSrNlU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707232406; c=relaxed/simple;
	bh=JXRaekPqDxJ3y66Z+ub/+3MZlWQsb0TPuOe4smB6wWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dwDicP78glVbu35yE/K7/s8O0sbe0OEfUMWn26M4gVAt67YoxcVNYBA6fD5KCkZk4l2D5JChlmJd+7slL7DRJplMmaeTdNqwQ7sNl+VuzQ0cC1YMVinKJJXn4c8shmIl5gXXQsF2EwZcwIm4BnqCrmCaTO0ivmyL7RlWXI6wf+Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=IB4AhPXS; arc=fail smtp.client-ip=40.107.237.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="IB4AhPXS"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R+1NOuVIKVJA33Bh/BFuFbrKK+mC0/VNuAL+FszmwcF/9OzZvF3rfDjtejAuBBkFAwnIUwEPn/GbkrMyGmN+EWXlxlBAI8eGHVoYp0qYH0q+qPgUZKNgEVgRz4Fn0a8N0XJh1L4eYYiRlRkpHKuPtyjr/VtjU2/JeCkDOsg+QjyO2+EXA/Z4EaNe+p9AVrReAoQkg3NKJMnONCO/9rUrwt+egwoOJN+phUaL+BeF+CzmjSUZDaGmU78VX6gSe87U5Z9LyJexEfQ57I8rGcReif/ac1pOyx21+rYHtrOWV8fsUp0O+KMHC8pKzh4kLVJ2x0W1GmMOaNr7Mpgp7ydCMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qoyh75BViievlqyr0zoccpkZVfxb9X8pkM3NWQ8Ut+w=;
 b=T1lAN7Kfk+LJYmqLQFfLyIyogLkRwkppYLrDki5FtJugd2j1To7dy5OeBe0Y3yCKCCxcAQ1XCYpyxrWANX9GUsKfSbX3uCFtJchZ5ITCwkDbgHtScoYCwRmvXOP3/1BCatgpikYfK5u0Eodmp1epV0G29njtLWlTQg5n8yx90wMRO62N7kWigcE4Af6tqZocgHoDSKG5PLUBs5ud9PWqXnipuY8u5dh6TfotOahXM0SjjCfdc/qHl5c+NwSEWDHc3O2zA0P3rqtEucdtocs3Ig0Heh+/9aavdX61k8m/1gH0TyE5pVtFyQNxO9bSUMLxTjF/Myqv0RuUs9X+0v2sHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qoyh75BViievlqyr0zoccpkZVfxb9X8pkM3NWQ8Ut+w=;
 b=IB4AhPXSL9Bw1purrVRxwsEKJr5ZP9RkjKypkwhIGq+v+01J+fpDBsvjtElQtBubLIS0cQ+gafMFvAZGGU8D9AXMtArniWxHQlRyow4auOVh5sReWN5bzd2tHcQPEcMexvjWaewGoX5AJopUO7McFB4PQPsyNDob5zNJPBL34yBgFS3k4PQfO4usE/X/9VORHUHvq+CBdMNRPuu3V6QdsETuBGME5StNdsHCLZHhGvPdz3XB0GXNwGOs+BYL0eWwYqCNvqP5zyBH11eOCcWMUQEAEmD/D//uaMy9ZynvEW9tV25lMa/NAcJmBci/v5i8mY21/KWhZuTG5mdu8wNMKQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ0PR12MB6733.namprd12.prod.outlook.com (2603:10b6:a03:477::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.16; Tue, 6 Feb
 2024 15:13:07 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7270.012; Tue, 6 Feb 2024
 15:13:07 +0000
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
Subject: [PATCH v5 17/17] iommu/arm-smmu-v3: Convert to domain_alloc_paging()
Date: Tue,  6 Feb 2024 11:12:54 -0400
Message-ID: <17-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
In-Reply-To: <0-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL6PEPF00016411.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:22e:400:0:1004:0:9) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ0PR12MB6733:EE_
X-MS-Office365-Filtering-Correlation-Id: 371f71d5-40e3-4277-ee84-08dc272619e0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	bmkeY2adzF4SVKZ09q9+YCiKZIvpddFTBdBKZP04T42iUT4ooYnkbrtfzepS/s0mGykbwkmjHwTBvWQFQTlH2wRmrq20eCGWPhGR2WhRCxx4e7x+SsMMtzKxqnNK6AoNnYQbYOhdYt635KI55Z9VsBeR1R9Ixg5VzIoeWCB846p9y1bvehy2UsroICaCLbAEjcLdoCBKIMD33fchLG5tg+ToR5ziokg6okiAn8BApYChYT/aD2ZphWhjGbgocIIAoEhL9fy1h+KvysUDLZoArjW1Pj2S48xF3Jh2reb8tdjQ+93ZYqpmBpovgKDasSI90mdRryO/JI2qq9GciQ4Vx3RbYv+3MZdwNmlxclYr1znqUN3gSQaUAywT6WWqF3ER4M+6bYsfYh5oxdtcK6gXXYlrFaLaLI34IQLt8Tx1HmLU+89VZ47MGBafp0HWtd7eWsIvk7AZrzz7joyj+LhVtWOBFcwQ+4OfmRFjSSSXbE08xtqqQWmDApIuzRsowd68byKAmn7NagdVwDFWf/OhuEC/jnvoIyP2Xj9FJ0UtnIZFBoUDo6q/jDF9kDTrfGTb
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(39860400002)(366004)(376002)(396003)(136003)(230922051799003)(64100799003)(186009)(1800799012)(451199024)(54906003)(316002)(83380400001)(110136005)(38100700002)(2616005)(6506007)(6666004)(26005)(2906002)(7416002)(6512007)(6486002)(86362001)(5660300002)(478600001)(8676002)(66946007)(66556008)(4326008)(8936002)(36756003)(66476007)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HHkRzIJcdmVUHCvSt9hil2wRpqApkzM2upTKY6wAtM3xA52fJM8KUBmuutS7?=
 =?us-ascii?Q?RdhtdOO1HXcvsfolqR4MUdINurchTU3gDt9CkJgUa1Zj+eU09ZNtB1zm+n3p?=
 =?us-ascii?Q?CGAmIHia8Wt5LXDxTEobGvY4oeb5kK8vpO8j6MyZf6CI1XdUG8MS7eZxSbG1?=
 =?us-ascii?Q?f2qXS6ZZqTMIh9L+zswwmpIpx02S5PF4rjrUcQyYLLraD/dGAps7kghbq2eL?=
 =?us-ascii?Q?PQ1u00XQXoiwCwN6F0HNqZ1pWhhgd/zDX8wpuUD+Md7HgeFYz/zVXH01h5DD?=
 =?us-ascii?Q?/zX6qTdFbXM1cVSaAo7UCK+96q8N2AHAs43EvPaYaxUhZfBSe5bChmktFPAv?=
 =?us-ascii?Q?kQCEJHPCdRmOyo1Z81WlgIxuQAQtEBi+v8fW8odqYFUhvOutanNb2ZQtDkVt?=
 =?us-ascii?Q?9e/71NPpYQekMsaQoNl+N/7UV7hKgJ6b1U83quP9a3cMvvCRbn1t98cRYFzD?=
 =?us-ascii?Q?39/uD9JJ8QTTzoOZ27azNMjePBK9eHNxWwxk+8xyYWFr3yIRtQov8NyQ6Mse?=
 =?us-ascii?Q?bnByhxlG58EaQtNChtDm5XUJqqnPCgptEXL0EUR7IxNPQoqWG40VjnVZMGj1?=
 =?us-ascii?Q?UiLZuDN0DrbzO6mRsNSysvtGETPIhfYLjnerE2JE+rh8IoOmtg+Tup1OWLK4?=
 =?us-ascii?Q?BpLpRy0+H+9nfcd8IM9aZy+1t1kcmKPEDqROQhBghiy/wcvIOKauAxcG9vEr?=
 =?us-ascii?Q?BvsHBtI2k+CisjVS77CeuwkMV0A64GZ7xxCFo6e9KdYPXVvbHzqaTHxK94pg?=
 =?us-ascii?Q?Vzu+ZvCbPBoKT/pVwzvMcJjBpCsWzQmS16lR95eMK8OgRqPAi1By87eA9K/D?=
 =?us-ascii?Q?Nxmx2puJuY13ScBRlhbnBy4Y6K8fx2wI6d8e3Bmwe5sWe2TdFOKVXe9kTiiw?=
 =?us-ascii?Q?DhCTkSJVPxW7J/kaNVBMeBVj7xbWA3eCEErp9EQ/3HzxwgeIJoTwVXrNeMdd?=
 =?us-ascii?Q?h6kKCFwkkKiJV6TzNfr39FbGK2c9ic7KqU7x0LrVr4TerBFBOuImNJI7leOu?=
 =?us-ascii?Q?6QqLfUu8MyTmydDVy7t/2QqTEnpsttXdwLM+BUgbK5XCEQ6edmP4la8GgB+2?=
 =?us-ascii?Q?SxZOr4dHj8RzyzdhjoNSvJ0gBCle3vpLhTiopo5m1p5OVH479q+9LD5zh8Pf?=
 =?us-ascii?Q?K2XMyP/BOqkfDGdm++UiP7kITdOqO8AojrVVx5uCVXOPmIG8wMvOyqa4QAE6?=
 =?us-ascii?Q?/70hDx0TubIncdYHhr/bObXDXAWCinsvuBknOoemNqrrSGU8qeqkCq7KBk1v?=
 =?us-ascii?Q?yJUafYj8mV97xa5sIaZEVpHNVJsNLXs/vC1i6FdwHArUzkUaGIGKDB9cDFli?=
 =?us-ascii?Q?lmzedyzCFvw6qpd8VxgH5GzwRwZrzpXZ67uZoNVYkHyZtV3iCe+Om/85OPTe?=
 =?us-ascii?Q?zi1XfqZvTQXtLtE8o0bAKHxesJMQgP8gB6e+K5fjBxG38eIDQF06Uh5l4icF?=
 =?us-ascii?Q?KZu0HifzAwE8zis1pLbgN9n7ijPWx//JzEwHXx1Uugfi5CKpYddyRfIj/jQF?=
 =?us-ascii?Q?ct2UVe8rEV5tVDy4+I/AyvzYKWkBIxSXdmeYt1dbHo3UPvLJXiVZXrE9AUDl?=
 =?us-ascii?Q?+tbv6HCJao0QvKW57Hxc0fMWIwPrnEIZ+re5QXsC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 371f71d5-40e3-4277-ee84-08dc272619e0
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2024 15:12:57.7343
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6Q+icFWjD/f3WEQozOcrmbg5GD282iBP+J19kLH730AT2Izi7gJQhfT0oX3oRt1s
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6733

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
index 7116874c332ffd..ab2f5ac4020d71 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2249,14 +2249,15 @@ static bool arm_smmu_capable(struct device *dev, enum iommu_cap cap)
 
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
@@ -2265,13 +2266,23 @@ static struct iommu_domain *arm_smmu_domain_alloc(unsigned type)
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
 
@@ -3135,6 +3146,7 @@ static struct iommu_ops arm_smmu_ops = {
 	.blocked_domain		= &arm_smmu_blocked_domain,
 	.capable		= arm_smmu_capable,
 	.domain_alloc		= arm_smmu_domain_alloc,
+	.domain_alloc_paging    = arm_smmu_domain_alloc_paging,
 	.probe_device		= arm_smmu_probe_device,
 	.release_device		= arm_smmu_release_device,
 	.device_group		= arm_smmu_device_group,
-- 
2.43.0

