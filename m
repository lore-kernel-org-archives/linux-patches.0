Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2050.outbound.protection.outlook.com [40.107.93.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 978DB6D1B6;
	Tue,  5 Dec 2023 19:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="mbxadi+j"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X6uyCze1w7s7PCRVPXIf1ejUuQdBSoPcLEX4pZCSGROA/HvpV7ieyCzXeQqovT3xxXmepEGKpcv/Qwpg8sIVOEKaMniekf+OV2cV3hFEd4N5J964Sts8DkiiubPTiO6Rbtem9wzYhIiNpO1R+QoIndPDGqFLAGW2Zbi2s+VQAyv6Zb3iLPwg/hHKx/xPqJ5PqNZ/QWojw84Z8kjzhkxES/zKmp6SD8sUhPUGf6CD5gnpOAY3rsx8Q2M1/J+oKC65m6DyGrYP14Kt5+1/owWL83Ape25X8vu13bYRcyahFGjLehcnQa85Bam1XlR7MlpP/dgNzvqgoVwvN1yT1aWLdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hMtO+c6Rz56DDPNFuGIK8+MaN4HCYtn+EIDg/VGfF4Y=;
 b=cFr0fYmS1l40SUIQp3OV71WDnH0RkhzzpbgnfZcOeM06n9Wj0YtGpJFl/yg4p6DmkXfP8299PQ++kK/IzbqV/bcZlbFBFMIbId1CT5NLt2G6gNG4JRHxCRPqBgZgyAMxgjt1Pl8z/XSIVtqN25BSWf7PpP8j7yrmdsCS9hRTJGHpGxC7L+0sqrsF9DQM7wNM08VUbJOLDLey7Io9P9w2uNsaDMrJ3GieMqTUEE9UmnFL7uKtnQgHJ9Cu4cFdcjkhlfTO5rjlB7QngFz4ST/T9QA+ZXHSRL/Yo1lOzmHrl7FxQiIjbK9RGxixwkyU/Ro3vU5oe8i9RUy2LYYD1bwqHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hMtO+c6Rz56DDPNFuGIK8+MaN4HCYtn+EIDg/VGfF4Y=;
 b=mbxadi+jOOJR7VgF6pbqFIvw0U+d7a8wyQtbzSVAZT6daS6GiQmSs/FsNVU/FzxuA1TiIusxOdGJqW5OLhrExoQ5ECrqNHwrhIIOs3Opo0ltTlKaXQr1/2mIWmfkEEHgNaJaC71LeF3M+Gy2joTFRv0xIiNil5KDDbMIjFLEAv3kLlWXHcgxnGIfCVlB9u+AEU4pPN/FU7kEHh1URi4oOikNyPD4yLIDIo7o9JwojwNI4RWwi2AEiMJlQEadk71o23uNS9ghABSi+rn1xRkHQybL8au4osWDrdoTutZdTJomaxEEK+iTmBUhaucO6MmPR0subqAmvLXrhudu1Stsnw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB6588.namprd12.prod.outlook.com (2603:10b6:510:210::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Tue, 5 Dec
 2023 19:14:54 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.034; Tue, 5 Dec 2023
 19:14:54 +0000
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
Subject: [PATCH v3 09/19] iommu/arm-smmu-v3: Hold arm_smmu_asid_lock during all of attach_dev
Date: Tue,  5 Dec 2023 15:14:41 -0400
Message-ID: <9-v3-d794f8d934da+411a-smmuv3_newapi_p1_jgg@nvidia.com>
In-Reply-To: <0-v3-d794f8d934da+411a-smmuv3_newapi_p1_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR16CA0032.namprd16.prod.outlook.com
 (2603:10b6:208:134::45) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB6588:EE_
X-MS-Office365-Filtering-Correlation-Id: ba0cbc76-f682-465d-c6cc-08dbf5c67517
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	gJwnrUo9OAOgOELR2SxKJphhkZ9eZC731IiTuSo68AEkAcsgWayLf6HbSPUFOo5dddLjHHqzuor2+JybhdbiwK4wbcb9ZndepZz+6xDpvfkS9VFVAh1vA0fnMpaBtguVVvOZsGeA5JJKBSU88Z3sj0uIWD9YLFLi8ncoX8SuzRydK5S0Te23628sGRWDRwIWJ+q6hrB19GFC+qWo3tSyOKEzcbH8EE3WST4XTjpWo4pn0djRrQliddKZ069noZZjeOz7VW0hzpce7Wv+XVMmSIzNLnr5oGeiu0NYelZdtBBv8w+6X6i4S0jcQfXT4QnsNT5+3jBv9e9IR0N/suk573N9x4vWxyiVMcQ/Un8IVo2N8r41BmW5XdDPh6EqmD9GdPKBMLBBCpz65nGicafwOSghCDVfqt0UaYnrYHNrC9tXRyvlJ1glXADqRGQPZX5eTZuahkKz71DjByk0EVT0zrxMtfdifgoGp+MNzK2Yat7nCPGdEqUIy11lreC2QvqdL4RlXqzllLX7bgifQ+3r8puJith8EM7GX8kPhkFwCqOwA5yvUadlCYaNtXqIUIVscfsOOpJQv4a1B48K/zZgh7ojXz+5LCNcl++Fw/qTgOY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(136003)(396003)(346002)(376002)(230922051799003)(1800799012)(451199024)(64100799003)(186009)(478600001)(6512007)(6506007)(8936002)(6486002)(2616005)(26005)(6666004)(54906003)(66476007)(110136005)(66556008)(8676002)(66946007)(4326008)(316002)(83380400001)(38100700002)(7416002)(36756003)(5660300002)(2906002)(86362001)(41300700001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?S4og/OPXivBcxsrrJO4bgkkYAo6sT3mIprpvleJjUdHRIqoXwiqqUFgu1ZhE?=
 =?us-ascii?Q?YukdDOeCez4u7QwU69IL6rY89yfFSIybGLvgz97m2GFjVwmqalIdP/U+5nyb?=
 =?us-ascii?Q?7cCpksKESgtkK97fin9MFdG2rZgfAjOcokVuqEKYQxta05i9RfMEool2CUJ6?=
 =?us-ascii?Q?ySCeBnnF8kBzQOn+UMWjlnvRTlpZGbjsuPiIfiiAmjgUuLUUtjrhNvWqbLbA?=
 =?us-ascii?Q?B23iZhU1PvrEo0tij+u8eYtSRi4nyuROI+gWI/QURrHPprpsZoj+e+TLgWqW?=
 =?us-ascii?Q?ZAAqF+gynVHVZibeSjL3aVoJ/sAM0qRNko8pra1rSKmXH5TCcQ0ia+o5XzIS?=
 =?us-ascii?Q?ShgM+Hhopwg+mk7esXd/ue+2RVw8tSzCrJYnVK6r1j4Hxwjw6+Ct8/Jvm1r3?=
 =?us-ascii?Q?Q8SsOB4XXB/iwrtTq+GpedhgpwcAwQSDpgDYBRRuc6h/V3PD03kNixYWNFlV?=
 =?us-ascii?Q?lz7ZbrcCQv/alQtcGcJMAekVGGSH3oAeBTFFFZ4lYJFMBPmyThlM0Y/8afRL?=
 =?us-ascii?Q?prjmfrP7w5dC+xnn3gRmI6pz8j0pXa1A5G8ZiEkw/Cf18pd5NgqmP/02zTxM?=
 =?us-ascii?Q?HDTSGUW27hnGGdTztFU2j4s61LWJhVkCJAxl8IPKHSRX0XXS0S6fOmYPW3X/?=
 =?us-ascii?Q?k6t5Mb4z9adu90c8ub0J8tIKe+i5bDiFzjh2p/W50NCPbEgHzJ8kZE7q5dzs?=
 =?us-ascii?Q?++fUvlGDdqy1+dE7bRm/lVYCuvPAEbi6nzRNZqqwq9xkTv/lY1Oxlu+Exsm1?=
 =?us-ascii?Q?jD0s5ilxohWKKVjR0Bg9iY+BxDYuodTSUJbHKXJ+s1prITBHQNKB5vclL/7v?=
 =?us-ascii?Q?sPb0ALKiZH7SoOrkRDjaIrEpmITHOvwf9aoFZHmIiYZbfPzDSM9zNTTncBOP?=
 =?us-ascii?Q?zlCX0no/nlaGcnoEBjN2Z8+Y2olTstN5Ichq4cBX1jUWeCAsfnfrUCd6ohhz?=
 =?us-ascii?Q?J9dIXi4pN7aybdlxN9Vh6dn3Kk/h/DSpXMtk5+MVGfCXE2jMBfSQkVX4LThM?=
 =?us-ascii?Q?PXTt5LTPAMHD7FLWlQfCslpxC74pSVspp1Q8B5bFkOTGgXeDoIdWXugxjwa9?=
 =?us-ascii?Q?bQASCq1qUZ+3jEaXuVsS6/23aQsYubHWclGb6r7K2tnllX0XJoZgbf6IV0X5?=
 =?us-ascii?Q?SPCCl8Eu3CNkFDbyL+jRPpYH9cO/F4sTGZv0koB1AKlnCbQ8P1YinAWXKx8A?=
 =?us-ascii?Q?FgWEfq+1hScXTWaNJWdWW1G5r3bJfVSo3UxwbzqqjV3DHtgxg3ks1Fz1MP5e?=
 =?us-ascii?Q?geSJOmClYsCLv+6c1o/YaN/l6rqC/xjxjOxwAJKyHu70f44TA5XVPYS76bU9?=
 =?us-ascii?Q?jQPhxrgKSawFO27mqMjG6+OBq2QVB9P9mTj+a5p6NI+adVKW2k3bJfjfY2ON?=
 =?us-ascii?Q?UgvK7A44JmIrsfzg3o0MBpPWAo31m5c3PrzoNBJQ+DD1Gk3+6jQoSa3J6C6J?=
 =?us-ascii?Q?Z/+wI6IqcL0uvmS6/mvKIYkWfSafVneyn4PsuVjAPlKrCuuk9Xm1Ou+xFQSN?=
 =?us-ascii?Q?vUX9zY362Q/yGsi+ryirA8Ly9U4mh/fUEdIu/muV1zXxUiM9Uot5cJtaXaBn?=
 =?us-ascii?Q?rUfkzn3uSisp/DiJGaatEw6JfcVQ5uFV6H24xKsL?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba0cbc76-f682-465d-c6cc-08dbf5c67517
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2023 19:14:52.1088
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tSc5mvNKTFubiT8CVZ35l9XV/AdqE2l9RYBIwtsl0VLPgemlZZP2JFn8rr6KNf40
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6588

The BTM support wants to be able to change the ASID of any smmu_domain.
When it goes to do this it holds the arm_smmu_asid_lock and iterates over
the target domain's devices list.

During attach of a S1 domain we must ensure that the devices list and
CD are in sync, otherwise we could miss CD updates or a parallel CD update
could push an out of date CD.

This is pretty complicated, and almost works today because
arm_smmu_detach_dev() removes the master from the linked list before
working on the CD entries, preventing parallel update of the CD.

However, it does have an issue where the CD can remain programed while the
domain appears to be unattached. arm_smmu_share_asid() will then not clear
any CD entriess and install its own CD entry with the same ASID
concurrently. This creates a small race window where the IOMMU can see two
ASIDs pointing to different translations.

Solve this by wrapping most of the attach flow in the
arm_smmu_asid_lock. This locks more than strictly needed to prepare for
the next patch which will reorganize the order of the linked list, STE and
CD changes.

Move arm_smmu_detach_dev() till after we have initialized the domain so
the lock can be held for less time.

Reviewed-by: Michael Shavit <mshavit@google.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 22 ++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index e2ae0081c47820..c375da195af713 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2560,8 +2560,6 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 		return -EBUSY;
 	}
 
-	arm_smmu_detach_dev(master);
-
 	mutex_lock(&smmu_domain->init_mutex);
 
 	if (!smmu_domain->smmu) {
@@ -2576,6 +2574,16 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	if (ret)
 		return ret;
 
+	/*
+	 * Prevent arm_smmu_share_asid() from trying to change the ASID
+	 * of either the old or new domain while we are working on it.
+	 * This allows the STE and the smmu_domain->devices list to
+	 * be inconsistent during this routine.
+	 */
+	mutex_lock(&arm_smmu_asid_lock);
+
+	arm_smmu_detach_dev(master);
+
 	master->domain = smmu_domain;
 
 	/*
@@ -2601,13 +2609,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 			}
 		}
 
-		/*
-		 * Prevent SVA from concurrently modifying the CD or writing to
-		 * the CD entry
-		 */
-		mutex_lock(&arm_smmu_asid_lock);
 		ret = arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID, &smmu_domain->cd);
-		mutex_unlock(&arm_smmu_asid_lock);
 		if (ret) {
 			master->domain = NULL;
 			goto out_list_del;
@@ -2617,13 +2619,15 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	arm_smmu_install_ste_for_dev(master);
 
 	arm_smmu_enable_ats(master);
-	return 0;
+	goto out_unlock;
 
 out_list_del:
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
 	list_del(&master->domain_head);
 	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
 
+out_unlock:
+	mutex_unlock(&arm_smmu_asid_lock);
 	return ret;
 }
 
-- 
2.43.0

