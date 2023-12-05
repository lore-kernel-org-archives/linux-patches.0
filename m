Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2042.outbound.protection.outlook.com [40.107.244.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 706866D1B4;
	Tue,  5 Dec 2023 19:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ktxpxddT"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PwAA7kMeCQfqf0Vg5YIqHnWMpZB8U8xs4cop7wV5PlcDBZeVgO611VvCyBmffh8aPmxNkLFOrdKQlt5AteeOrqsBeOwr4JvGtlDejK2Gk1FL2uNf8l6Ve5InAfVxq4xFdsUmHC9VvH64RMZ1TeU0r6W059Hj4+Q/wQZKMeUFuSwPzkllU0shfWumxQbIy7QRMcHDre0naaioeS0JFi7/yRxPjqEDS7IzZphTwp9EKECMqXvDhhHBX2rBy8BjKA6iETYsvmFsVjap8UH/z4bTr0VNZifmid6RW9dBoJrrxdYObp/2B2Hi8jV0uO4UfItQNtLqQLe/ZpD1vQBgMC8qUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oVNCF7bI0gkp7nwYGkFk1AOsaf4yb48WjpKgqKBX7IU=;
 b=gojN4TmHkhFzTN99IOd7r9IMcEjmypInpdAQDVVVKEzID00Mn1dCH4SH3qlg/oVehkLczNuzTlNJs8cUS2x+3OV3pFeHRNbqfa4TiZ3oNHjx7RtPRL7vRuU+K8dpG0FfcoXcNEw7hhugUpDmzYjdOHSv1RCISgMzPjfXc95V1vh1eFfZv4FnNxqL+/jleS6+vbOi6WbxDLO0q8aGIGgg+SJyYLAAgghi9sW5cFqZILk4CY/jygE4d0ineyuioHfoj6GFHi4+1vUzWCBXVcLCJwKkg9Pgpek3RRLHlYCnM+KXc0T4PI687QT2upFFE8iwh5bbSrQ/ww8fG7W+Cqb9Rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oVNCF7bI0gkp7nwYGkFk1AOsaf4yb48WjpKgqKBX7IU=;
 b=ktxpxddTSd7PFGLXQmpp4/5y/K1UH16940n5TqbecBMVeVJDF8KA8UCMkYS36vLMIT+j2VE3qpvHYVcmyKkf2EQjGHgBQ1y1uM4ymbfcHbk73FG6FBLd37Vdz3QOUwTWz0+7AaSd/PfKQmnIi2ONvKGjmyGd3d6lwWS1yexVN6utd48FpWv9EBoJyXCi9WSUjJKOxMXiza8yFCYsS++aFLssL4MLz1PaFl/yuH+s/ITbF3PB4dKJOuO+ZcXHE/+eFINOUm16hcgRwXAHxGlDeSvCdicobhMAn2Hf7B1zZ6kix3dZnQ18Rh9QoJzpDwekCoIOtKu3fU0FAtrskRZBiw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CH3PR12MB9021.namprd12.prod.outlook.com (2603:10b6:610:173::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Tue, 5 Dec
 2023 19:15:03 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.034; Tue, 5 Dec 2023
 19:15:03 +0000
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
Subject: [PATCH v3 02/19] iommu/arm-smmu-v3: Master cannot be NULL in arm_smmu_write_strtab_ent()
Date: Tue,  5 Dec 2023 15:14:34 -0400
Message-ID: <2-v3-d794f8d934da+411a-smmuv3_newapi_p1_jgg@nvidia.com>
In-Reply-To: <0-v3-d794f8d934da+411a-smmuv3_newapi_p1_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P222CA0012.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::17) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CH3PR12MB9021:EE_
X-MS-Office365-Filtering-Correlation-Id: 25b2831f-979a-43e5-fd8b-08dbf5c67734
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	epp5I05N3L62qQTWLYRanHrC9OnVQOX8LsTpySQCkhW4I2sfzS2ojaGWjxFdmVtR+FZ3/TZcVa+NLlGNvQoPXwIqPikZI2wzpwmj51EQ80Iplcy5inoTM6wPEoVabzav0a4V4Rm/OI+7jyQN/O3DJczCEBVPiedm/S/NC0qmZXWdIHDRzwvmtxihEmajkewvk1eFyNug/WXvekeB5ojWfWN/AXowYw1/Vhdfn945l+7ndSkA6IAGJ2DPhSiJMKoO2j2E6ct2GdOWOE7Q/+iTfuKkus+BZvYVbiwJEl+TmeoMkrA+pJDas2wuKb5iLL98Eea/kwgy1xQNH8kEgdvVZECscOUODhcWLZQYBBJw8h/4rcb3XlRmJac0Zyw/m5PpEHTN8I+8g+UwE/Bcux+8S5ab95IRhu8t3KB9Lzvr+MvP6a7v5WJQRcRHVDRaH+H5y+7YCP/4cTJ0C+/i12iZf8GvrsSZLAFgYZcUyvQu4xdQ0GDIVEPQNysc4+uMHVsDGmJuYpi9p2rFuP6fH7buN4i/6JwklYNdmuzzpAuo1t4ZHj+QgiWcI+NN5a0RcaxKIuyn8zX3SaNCd3mscQZLX9ybrvWZKHyHn/UB+rAqjoY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(136003)(366004)(39860400002)(396003)(230922051799003)(64100799003)(1800799012)(451199024)(186009)(2616005)(8676002)(86362001)(83380400001)(8936002)(38100700002)(6506007)(6512007)(26005)(6666004)(478600001)(6486002)(66946007)(66556008)(110136005)(66476007)(54906003)(316002)(2906002)(36756003)(41300700001)(4326008)(5660300002)(7416002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?x1uDNQIBowm0EoM5Ii4MrRf+HvNJMKHFrdUIveLxAeqNDVhroxtFAyJkZvj+?=
 =?us-ascii?Q?2vlFoqq9BfoxayYzEqQtbp4Qr5ZkzmxzLjw/d43lvuhDiamJzJLvCmT/rX4H?=
 =?us-ascii?Q?dDQQkgyYzvRMwlb5g4unn/Ssx1twdMhbt5tp4+3HPknqMWxg1EH2DETkNWd1?=
 =?us-ascii?Q?3GkgSW5pUPxcJ7jqT9kzapczTHUCxGLk9cwWJ9w8ryjbWluq8e4LVo3wJoaV?=
 =?us-ascii?Q?x/wlx6eeQH9eo8o3bnRWdVhwvikGQLuXMab4BKUpKAjtOqKXUmDRBkO5PxAG?=
 =?us-ascii?Q?2xuitTTEbducOKZRKgdtRop1YLIT7/DNNmyGQCSMMFTqWpaqumDj+ghTq9Nq?=
 =?us-ascii?Q?gbJqcIcA6LQ2W5dyVKs/1nXq9puLAzJJL3/Y0M1YF+OJiiFNtfb7Px/B32dC?=
 =?us-ascii?Q?Y2OaTPd0qIO1Bp/Q84PhRi1r+8h453gyto1b6K45iG19qG3/n1DSSEQxoCVe?=
 =?us-ascii?Q?pazin199WqkgMSx5ltqnJtA/qnk6eSEwNATMxtCs28U0sO5l5zkorNRzaG4W?=
 =?us-ascii?Q?H6XGrtVfQb3Yu7111d/bF9P7J1W9j+rDSCb+F7MbNCy2OnyQM2ckbeHdWviq?=
 =?us-ascii?Q?d4fzys1qdQuabbbJD5eeNXc8M8vpcSx1EVlKsFlD6MNWhum7jfPt7uUfvQxA?=
 =?us-ascii?Q?RGgjLPc/giljfJ8Ixtz9ITbHGJBliaJ8eHUu3HWPx2KxgA/5NfB+q+WeQby/?=
 =?us-ascii?Q?Dmcs7AHVZBk5LG+e2HRP5bXOSFhIvxHYStQv8GKvBztcbv116uod3gqJD+vp?=
 =?us-ascii?Q?lIWgHUHBG5X5WnLye/0tnrlQjvkjwJEsmGC1OUrf8MgEMawt2KwvkdGG1EqU?=
 =?us-ascii?Q?siyXNwl4QXM06q3w3OgnZ8Cea0vtl6sQqJVUwVIS7gxFl2Pv1rdofHp7vqgR?=
 =?us-ascii?Q?9Y5IwtBocOld2UiRHy7PfJ3SkGQTKYwpJrz45Bd1q8BosvHfXSTBxF1oGf27?=
 =?us-ascii?Q?kjw10FUIKi82WWqpbq+BeFWnkKGWwvc4pbYYGMS+jWUnGabRW8CTUvp5gEcQ?=
 =?us-ascii?Q?XW+3HhddYVzgb8W5xVhKLEDxniU5sZg5UYopEDXHfYup3RFATQLkBGVaIa9Y?=
 =?us-ascii?Q?HXjhbvLgSCqIqB5rpm01SiGb1oEpuOzE7UL+F6uWyf7T4aznT2wkkF4nttdV?=
 =?us-ascii?Q?SNgnuTKGUUaIR6XaLUGZdVbx7GqW/nCUXJCdFie3MtT1mxD/sbctnovhSkKW?=
 =?us-ascii?Q?PuPXrSPOKqYnubKEQfqpuxo+w1swiMDT8D0Nj+/P58+cf6yhWigvBsIXL594?=
 =?us-ascii?Q?Mlr/QCZZIgSMhKODwdlu+rguIdLrQZlzpjZASK3xX2XOs3zQ6W4eMYjy3tZY?=
 =?us-ascii?Q?5mVJrCNz0mVRSHP8pjyBLJnzzmpsvChvhV/IZtwCbk8YCC1ycrW5bGwM3pZS?=
 =?us-ascii?Q?S8ReBDEkn/LXS8boKuvCHAA2yeQodQAjifrzmUST7Ks6fb7H1xQDlKv/aq9V?=
 =?us-ascii?Q?XA6Yefcf4pJU0SOXQCRZ1iyi0+gc3b711aOXIYyEIA1AnuqMyhBtwRW9CWmR?=
 =?us-ascii?Q?rQtfOsowf4ofusKnZcDT8CchaxszneJ8KmOBDb72+uR05SCr8iLx6FqE8O94?=
 =?us-ascii?Q?tO2ibIQ7oe9A/sk3a7yN3l+ph7TscWDx2QQayH1C?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25b2831f-979a-43e5-fd8b-08dbf5c67734
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2023 19:14:55.6507
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3Ua/MBsTuaRwX8bZtMf1A5o7VUvNPVwQPqJeV5FjG3TbkpOM7Maya/naNPwzbLG8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9021

The only caller is arm_smmu_install_ste_for_dev() which never has a NULL
master. Remove the confusing if.

Reviewed-by: Moritz Fischer <mdf@kernel.org>
Reviewed-by: Michael Shavit <mshavit@google.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index c5895f4d7d6c9d..89e9c001faad71 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1269,10 +1269,10 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
 	 */
 	u64 val = le64_to_cpu(dst->data[0]);
 	bool ste_live = false;
-	struct arm_smmu_device *smmu = NULL;
+	struct arm_smmu_device *smmu = master->smmu;
 	struct arm_smmu_ctx_desc_cfg *cd_table = NULL;
 	struct arm_smmu_s2_cfg *s2_cfg = NULL;
-	struct arm_smmu_domain *smmu_domain = NULL;
+	struct arm_smmu_domain *smmu_domain = master->domain;
 	struct arm_smmu_cmdq_ent prefetch_cmd = {
 		.opcode		= CMDQ_OP_PREFETCH_CFG,
 		.prefetch	= {
@@ -1280,11 +1280,6 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
 		},
 	};
 
-	if (master) {
-		smmu_domain = master->domain;
-		smmu = master->smmu;
-	}
-
 	if (smmu_domain) {
 		switch (smmu_domain->stage) {
 		case ARM_SMMU_DOMAIN_S1:
-- 
2.43.0

