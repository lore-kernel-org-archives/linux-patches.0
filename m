Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2050.outbound.protection.outlook.com [40.107.93.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCAED6D1C7;
	Tue,  5 Dec 2023 19:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="pRjZqSLe"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TWYzBeftc4Yfbu4BpA6WkVTxO+rTFEq47joOcc19jc8CuVHgx46CiSePQxJtXj9eMdnQOBw9iqwCR+GS3iq32T/l0zJk1dQOnF2M6cKAj1NTlUJNHNR//lHOeIzDNt7vOYR3AhVvx5UCX6VrRoEvfAltJmIdI7tU0cuUb6iU0w0H/rkJPQi4xnJRJaMHuDJF150pXlTbs7bLfczqWhBzxCfnfaIeTFwlwggjR58+MWFOCUx0FG1voAZ8gRytSAdiw3fDMJTrxW9uNNJONx610UuMw1Mt6/PGGZhWg+uOBHluBOoZS+AGTwEt1Ng12jXf/VaHAGRzLJwA1b9OLSY3tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1rX071TW7IHzjhqW8BaEjoxygqb/wH4pos15IYzeQ9c=;
 b=BOl0GUHe3dW3xmD9M7fBxzEaCKsfcfcqU+h8U9ppeqQmJ88197MNW+RoEjUpg1+d92N68hCIyBfNbkqKcQ+FHzIhdD9rna/DM99Ll3m4/pgRsusrsVYyAaEB+BJJEotmBmchCa/rfNk4fG+DQLj8KGQAv3UEINz6DL2h6cQfL6NFbo344eBS/cpZP9eIshJWE0ATIUU82gDGB5Ys+zy/cvtll4JoCMGszEnLtArNwqar4S7eZ4AzvuP8sJOkl7Vt8MhW7aMK1y1w2dvJs7H1lZIo55+BbK1jvoq38UsZhSMThnzBHquDfQUqX5rLHk0UAU6UDtHvNT5KsDC2hoHkwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1rX071TW7IHzjhqW8BaEjoxygqb/wH4pos15IYzeQ9c=;
 b=pRjZqSLeMwdw/QNnt2KxWOQZ8RbhgV2AXQsCK+OYu3oBQc7BzJZ4jgzxPSZdVC+qoAhOQqYFFWPEBXknHBvW81zxq5ksS0F33DIb8jSJGoKUnxzz7qeY7Jv/YTb5QJUzWBWC3DdsarRAaYFs7QvrxPz5P3MAzmYhSQy8+V2Da9efRVr+HEjot0awsw7ExZZkIp7qrKbZbdkgYiYueoI3szg+yrECJ5ymT/fNgKPdF3DCCtjJAak6ELSaR38EGg68f05yR3JAEYm+2yDkk6OzfmccsVUDoxMSGKcC5vlDoeZJ/vlUtERbrNOTDOGPhpKgDrJKk/AJKR7v1pTRAQRKVA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB6588.namprd12.prod.outlook.com (2603:10b6:510:210::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Tue, 5 Dec
 2023 19:15:01 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.034; Tue, 5 Dec 2023
 19:15:01 +0000
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
Subject: [PATCH v3 11/19] iommu/arm-smmu-v3: Do not change the STE twice during arm_smmu_attach_dev()
Date: Tue,  5 Dec 2023 15:14:43 -0400
Message-ID: <11-v3-d794f8d934da+411a-smmuv3_newapi_p1_jgg@nvidia.com>
In-Reply-To: <0-v3-d794f8d934da+411a-smmuv3_newapi_p1_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR15CA0042.namprd15.prod.outlook.com
 (2603:10b6:208:237::11) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB6588:EE_
X-MS-Office365-Filtering-Correlation-Id: 21cb0e12-e511-40db-1b46-08dbf5c67650
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	P9EyiQMnu31HikIjjNwrVmfW0ssT633ZXSCo42hQMPITIUeZ2orfQnkm/2bkqcqhSHbVotTGcDQqnwkyWj4BU7x2e/pBg3mgauiPGh5etw5GIdVF78OxzbK0L6c2OyyU06e/UFsruNS5YUTtRoW6rqMaKSI595lPniEhbk/T059L9wjIkPbEp2MOHapkZ97tYG7jmOs89NoId/jJcdAG98+7AbgDnMFzvewieokJSVOM5zhRJRooQPHrMF9RWd0631Rz8toFtz3ynhXFm56CwGxbtjrDjAsPOd6xdYQ4+qtoyPjRNz4YsEqqkycxmINAgriN5s5BaW26FISJ1pJnE/TPxB7JLDEqXUgiWRDFZji1GpfBsU7H7RHYgIbJ38Areemd7IylnBfBQLK6e9MIGLYzFA5s3APTyL5NmVnFmoLr5MSKozGPj3lYhSa6X4ix0WqwPoqd0K3QREMu2u3LW9cpnbMNV78UIqx2nynqr01HDrObvTZqIfRg8Tiw/Z0BqkajuDJrhjirvEgFM8jQZLVh1awQnA8VzIFBWENpV+eguroLnUxeBJAGcLlom6Nf
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(136003)(396003)(346002)(376002)(230922051799003)(1800799012)(451199024)(64100799003)(186009)(478600001)(6512007)(6506007)(8936002)(6486002)(2616005)(26005)(6666004)(54906003)(66476007)(110136005)(66556008)(8676002)(66946007)(4326008)(316002)(83380400001)(38100700002)(7416002)(36756003)(5660300002)(2906002)(86362001)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?f2PELPqOZbcU9ApwjuXgvrJtkCSVphTzsYv7+PCTiXbmT+2b3GrB/glsuJw9?=
 =?us-ascii?Q?7iscD7xBDYs6FwErzCCsaZjHbcg0MSKHcmqOemb3+SSHvnDjd2oN3SFRpqlC?=
 =?us-ascii?Q?NMjVBUNUYAXYXKNnUvJekK8vsFgXc4SP5kHRC2BXJ7a7B1mQgQLJRJi4PtoI?=
 =?us-ascii?Q?aBOD5JxhQo2WF7xnQB7kOlvKkOJtiHnFP/6eholSZdb+sw43jbVA3QojRKN8?=
 =?us-ascii?Q?5NZLd1485LAtAPSxHcuIlLikyOP4q3kuOEifsuz5lH1xTzl8WR6Nad1sFTN9?=
 =?us-ascii?Q?XHXru1JmGxijAolmpqjT5Uhbs3HfQ0gnb7AyGI9ZZPBvQXGn5l/5npGcl1xW?=
 =?us-ascii?Q?mdk2/fl8Id/fquAlNTRqhb0GYKWN3ahPvCXHCoHbrWRNCIc60N7piiZkooRh?=
 =?us-ascii?Q?A6HY/0RXSXup6CA4Dybzb7ar8iCa9i2tvosLt7Cjbk4shr0uC1oi7nTdrU2e?=
 =?us-ascii?Q?m5f2My5QR7K3YgabUyzvsvs3YQZ7AAyZO26md5yed5KvwfDCFSwHluebJL+m?=
 =?us-ascii?Q?nnxfiWbMe+8xDL23BQxjV7zVI78VXaTTmCE5iR1jQfbBi5c5GMv1BAT12Gpi?=
 =?us-ascii?Q?pkZdQqEibqC6eD5KJSjyDpksTU1oNg/KsuOwaia6csnEUm/+ime6EXWONNgU?=
 =?us-ascii?Q?/A0og7sGMOmrFMprk9C9cvPufO8lwrd8+OFy+0iGqTgrzPd+pAPPa9KSLfPu?=
 =?us-ascii?Q?HYYf7rhjCNiogFi/AJP+PPU9T412iFoh/cuNm4XrNPOIaqVwLVJMFEnjOCov?=
 =?us-ascii?Q?CXr0vEr/kWhIAPYY/V32Sc/+Cwk7I1YL8D+RarW2PQgF79/R8aJIjbmLsNf3?=
 =?us-ascii?Q?QrZlykG8MPspZch4My5xpXWNzjY80jZWTUuJpI6TW0JeykQ9jnI2kBI25t2a?=
 =?us-ascii?Q?2LbPO2GmFf1/d8PKmU4A7eyL1tAsiu3maB+OoRTo3AK3fUdN9YsAdE3WVH2K?=
 =?us-ascii?Q?YgIGAH+y/3o5QonQTbLxxc/zbmsIg9NFAiuTqtIIv9bt3uDgSuGt4kPy6gJ0?=
 =?us-ascii?Q?Bhg1BhjRPYKVmdywXc7Yr/xyy50ujCE9oUOR+eHu1t1MvP11yqIDhbEHA98V?=
 =?us-ascii?Q?Ruy6IBeWOFce/gX3/6mfEbnmj1FQG6I2Y0zNC3vXCIq0hSCt5pIGAXKliigs?=
 =?us-ascii?Q?HhLy+cLdOLd74v/yHFfOpmuVmi9QtTlzuGHKtFlBdwa6TOYKxAUf1WbOXciU?=
 =?us-ascii?Q?MYYcIYT3ZJZjBNIbAqJEJMcj+uFUYN0Uf7pSQ17N9E/+cY2zKum3BCcPTKNG?=
 =?us-ascii?Q?BrwACdn5ZO8RsJ/Me032GpGkEoqnmGn7Z2xOmDT1mKlGHpsHkSKiD+hOoyYZ?=
 =?us-ascii?Q?jHlW2X4dW0VsJqBuEjUyBT/q19wFp3jqNsP2KHVfvJc4aukmZEZX8yq685tM?=
 =?us-ascii?Q?qLi6v3ak2lYhVNpfB+Pf8wgFXZlwOCIHubLgsk4dJVrzypN1JOy1cOFk5hwN?=
 =?us-ascii?Q?Zcgi6kONl0lQYAPyCPtfT/Lc40WO6G8FeQdoW9bkLA7NZBi03HmI+l6qfIwF?=
 =?us-ascii?Q?LPmGDbi0qSRXQBVT8wTHVvjHojcJzQiKKw/o9VfzVH3Lg7srrXJcAuIkSnIs?=
 =?us-ascii?Q?XXRKX5A2ZjU0nRmyuZygAKddbe6ZdUH4GgkhjTGT?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21cb0e12-e511-40db-1b46-08dbf5c67650
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2023 19:14:54.1375
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XcbniNq8UpAN7E1UQsxArsD9Y+J62VXdDf57AUPEGXHfjRE71osCeByvQVOP0pBk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6588

This was needed because the STE code required the STE to be in
ABORT/BYPASS inorder to program a cdtable or S2 STE. Now that the STE code
can automatically handle all transitions we can remove this step
from the attach_dev flow.

A few small bugs exist because of this:

1) If the core code does BLOCKED -> UNMANAGED with disable_bypass=false
   then there will be a moment where the STE points at BYPASS. Since
   this can be done by VFIO/IOMMUFD it is a small security race.

2) If the core code does IDENTITY -> DMA then any IOMMU_RESV_DIRECT
   regions will temporarily become BLOCKED. We'd like drivers to
   work in a way that allows IOMMU_RESV_DIRECT to be continuously
   functional during these transitions.

Make arm_smmu_release_device() put the STE back to the correct
ABORT/BYPASS setting. Fix a bug where a IOMMU_RESV_DIRECT was ignored on
this path.

As noted before the reordering of the linked list/STE/CD changes is OK
against concurrent arm_smmu_share_asid() because of the
arm_smmu_asid_lock.

Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 0c1d70b8f325ed..7b1f7fa27b3df0 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2482,7 +2482,6 @@ static void arm_smmu_disable_pasid(struct arm_smmu_master *master)
 static void arm_smmu_detach_dev(struct arm_smmu_master *master)
 {
 	unsigned long flags;
-	struct arm_smmu_ste target;
 	struct arm_smmu_domain *smmu_domain = master->domain;
 
 	if (!smmu_domain)
@@ -2496,11 +2495,6 @@ static void arm_smmu_detach_dev(struct arm_smmu_master *master)
 
 	master->domain = NULL;
 	master->ats_enabled = false;
-	if (disable_bypass)
-		arm_smmu_make_abort_ste(&target);
-	else
-		arm_smmu_make_bypass_ste(&target);
-	arm_smmu_install_ste_for_dev(master, &target);
 	/*
 	 * Clearing the CD entry isn't strictly required to detach the domain
 	 * since the table is uninstalled anyway, but it helps avoid confusion
@@ -2852,9 +2846,18 @@ static struct iommu_device *arm_smmu_probe_device(struct device *dev)
 static void arm_smmu_release_device(struct device *dev)
 {
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
+	struct arm_smmu_ste target;
 
 	if (WARN_ON(arm_smmu_master_sva_enabled(master)))
 		iopf_queue_remove_device(master->smmu->evtq.iopf, dev);
+
+	/* Put the STE back to what arm_smmu_init_strtab() sets */
+	if (disable_bypass && !dev->iommu->require_direct)
+		arm_smmu_make_abort_ste(&target);
+	else
+		arm_smmu_make_bypass_ste(&target);
+	arm_smmu_install_ste_for_dev(master, &target);
+
 	arm_smmu_detach_dev(master);
 	arm_smmu_disable_pasid(master);
 	arm_smmu_remove_master(master);
-- 
2.43.0

