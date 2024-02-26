Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2059.outbound.protection.outlook.com [40.107.96.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB14912FB13;
	Mon, 26 Feb 2024 17:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708967268; cv=fail; b=mb45KPeU9hywshmQafOc3ar4SRdJitXnd/++AdX/c/gWkbHTv1BRDi8D3WtdPHD75XyeIg8NZZEHxu3eqI3F0B5C8V/kuR2yn7l+bftZ7cyFgl2dLdswus7kMSndLHdPG0g0fXAV8kZ7g9wb5LuxewF67lzLZ85tCcoSeoZxzNo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708967268; c=relaxed/simple;
	bh=hFp5ON6fdQDmLCBgxZqHtyS4hr/Gt5Ux9qSY97tLVDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HlHbrMi0cSxJF5/tusDKTn8rMMSdKQbpC9ZTsf9FQ0z4fW1ck9WQ/OMbLO9I+MiBCz79BTDKXtL0RM2ANqWY66PJbSI0LqeDtLpwp7/4LAAqYTxf4CgJg08CAiDWu2FTn9KQsDFmFTDnEh108HMAyJoXLL7J0rjTMPkpS9zEviE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=sOzp617E; arc=fail smtp.client-ip=40.107.96.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="sOzp617E"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HHCL2XFQWeBGq8J/Dq4u/9HE0aSAPUJ+SV7Pyh+n/Ln1R1pRqOl9ocrrdkNuu/GCtDa9IEpv17lysu3/GrnvoIjQFj05NLHCdnrHIcm9LyeL/9GQuL5Rtx8wlKAWzHPsC6vPXqyVJgUSvqdyGCbBrpLgfO9lTCXf36UM8nuioo+FdmIaytX5qya1b/gDFSpn0Rbu+r8xJF3H7smRok/RIdkcCgrA1HAaSlKndK9RmM4zZurx173lm2Kv4Hy+BlrQMDxf/thSHOMtlzB3YgsH/MGY7EOCmzKLIDIR4M1k6Kv988LA/L5DZheJNtVcqsIAyNOljqKuSid6mM2byCuZqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aGGydjNTWbOHl9vFD60RlvhE91QKMCRM8W/0YXBi9wA=;
 b=brAbFgajFpxelenDAFGyY8wZ6An0tGr0WfiLpRf3o922xVX0fMYHBo6CIWYbcQLNJdhwgGN6nEmjMEb/RkBqM2xOsU3g35trCoejwM8Xu3XCUNu4Lvo9qaQugzZ6vEhqBxcF/CVsBQpK6KS/hFo059NNmmz1AIdIhtCCPg0Q1GusFOFb3kMPg9n7+ClsG00EwQQjhR+lVON+nqttMeRh7wIbd6MsIp6u14EZhmg63HAsXYXBLv4m0lmS6nwvFrb0NLfGdW46wzxrISbL2jJKVQ6gO+J6XNQ0v5tg3hyRvQ9Z474wwrFtLCk7R6T+hy/GQdwaWEkB2viQBloRbfmPbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aGGydjNTWbOHl9vFD60RlvhE91QKMCRM8W/0YXBi9wA=;
 b=sOzp617E3xAEB2RDxlhs/0WSwHD9u0/l+f9BHvmwojMqD72vOBh+IS5UbrdHIIoo4tVWtcGHnnuffvn9IU5t9TZhwdypfAN8o97/pzNheecd+pOl07bjKnwyX2xqJUGg+5gO4atgn8yKtzJcVNNbL/mcLmccUTmnNdTSIfziQAhQPihYgfa7RNw8l+fJfD6CvHLC5WgR3UyvS4YpeF6GhowLWuck4QpCRPD7Byel20cthRJnXwh9clBuwR7x+j7qGOPVub6S6qEvXgKs/X6kPE/zKpbX74xsU3kfTke2W20rt3vq9vYuA7YHEOV8jylEl+yogomx0NLT/6WMg4vMbA==
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
 17:07:35 +0000
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
Subject: [PATCH v6 07/16] iommu/arm-smmu-v3: Do not change the STE twice during arm_smmu_attach_dev()
Date: Mon, 26 Feb 2024 13:07:18 -0400
Message-ID: <7-v6-96275f25c39d+2d4-smmuv3_newapi_p1_jgg@nvidia.com>
In-Reply-To: <0-v6-96275f25c39d+2d4-smmuv3_newapi_p1_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR15CA0034.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::47) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|PH7PR12MB6905:EE_
X-MS-Office365-Filtering-Correlation-Id: 268f0c36-8564-4561-85bc-08dc36ed6ab8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	lTRMldW+qBkq83vhtS4hv3xJfQ9Ui7L1aH1fi1jsJWEBt/jq5SziHIeNjVf7j1LWHiHLiWdwyoahJ14hcfl99hJhloab2v00+4T4788/qOtMrUD8TKPhnksSpJLt8POc1yAVLJcICWCiKSwoaEXMBLSpfuB2nMxAAtdNQ/QgNDB0tWcyNcFNdOBX5zZRtzWnKau0VNCyn8QSqV15GbYFRhY22epe9aBoWIB1c8X0uI/MygL20nSTzH7/GXZjFBiIB15JQ/x5kTSjbhy2qlqQYoDAm4LPb5wZGL+gOqVeNc8YBvbZn1nEaKToTcHOhNkKjWSPmjE2gUp6E2y7OeqKNfiTxpZ08DavU134Du2nI3+svrmlqbJ1VRNMfHWE7EahsZbpq9FCf8BmPAZ83alyInJGg5+G4ZiHOvNFCXCiwNuxKa7dSSK0+2/6rZAlPpNusU9z0DQZUFwAGro0kar5p2iWXj12tyADcqvZ34//8vMm4Hv8QpE3K4ArYcOghHyXpg9nsTm10VbQjCHEzd5d8PTvsoGFrwEBgopaKRPqxJXDHwDpmQkQtmq6uxwpPUqsNl74YQxrKVboU2Wqz8SGQVXoTVkgDI32Baa9eyDWlZQ4If2VfWtRO+KFzhlRZ3I6gipbD+JxKdbflrJODBYLFg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DaMzaiG24BOoIf1aC0l3GNc26GiR4D2+GkTxqVc2Y3gvZoqwx5ds/36zbHO4?=
 =?us-ascii?Q?E0jUB6vrx64ZcD5syxNsFTpWxEJPXD6HtO+xaY0t9zTZgnN9QUZkeFUmXFTL?=
 =?us-ascii?Q?QzNnFNQcRvmVqwEOLwDV4T3uQ/QwQILp7DQfMx0tEGl7aHiVGqDGN90esX8+?=
 =?us-ascii?Q?4DC5zFgPXWYuVNGnYyNWwUs0wIGWZgaVB/PfMGLPqUsxHYdt7/bYyzGnCg7p?=
 =?us-ascii?Q?dDF1s72yXe6o7xPwYZfh/chOp+ASVtq/E5LZjIgBZcf/tInrQMR2fCP9e2fN?=
 =?us-ascii?Q?4tUBmPxJW6kgyrlGJm6oBkEt/K9o2btLc6cB3EUdyDbDc1GHq8dHO9pZC/vw?=
 =?us-ascii?Q?D+hB+i+O6fVYI3Xo8xSZnnc5xbTWciieuRsvEDpI2KRst48habvLALZNZR70?=
 =?us-ascii?Q?e4dpJAUCfqRY2owFJBTu2UuZifn6JDZ/ZcdNEW6feWZK5SwvQSl+YJSq7fxZ?=
 =?us-ascii?Q?YhIpTnZYLNppmmuROblO//OI1F3N5EjhSLQa056ciX0bVQIKG4gjPCDkmKV+?=
 =?us-ascii?Q?nUNJ0z9F14bsPb3MFeg2O3vaA/njL5rhMdWZj5Vpls/4DUJwMNpT7oT0LaYu?=
 =?us-ascii?Q?/MKoA+OWupm3P13F/KxVxGtyWijNXPiEQl9//PuEGLQHWeOwScSFjFGpu63G?=
 =?us-ascii?Q?CvKZSoa5w9imdHemIFW33MWOY9YiwIs9znkLRJhdcbZQT98kXXAZ0Bycqrgf?=
 =?us-ascii?Q?fsAZ6GuLLJ74YAyZRgfV38Aqx6sfUBlPyC7V0aSBTF1I7iVqlCA9xFBOu7Xf?=
 =?us-ascii?Q?zb1U/WIomOuBZ5uwz5JSsReqEpYFgrrBnK0MeTNPSdtnWZt/bPGBtNsXTgjG?=
 =?us-ascii?Q?pqOO1fe3A5vgd0AIdXLrWp60etNMCx0XpET31Zdh9SdDZCCfEFSsqnrdRVqd?=
 =?us-ascii?Q?jh3ZROuFOd4ufOAyTGWH00/c+oqd+Sn06spEhHSFlEJH3vgBx7UBzoYt2qFl?=
 =?us-ascii?Q?AHN+nh6e3QcRW6I4LEhYO7vy6bT3uPfDpM9U/vH72d6zMxeWkUUhX4bNK0bE?=
 =?us-ascii?Q?UxH9TOe/cA6TCV33XitEqS5r4Ar89HZhLKOYVdyQkFoEVh0w5DKgXESnY7ku?=
 =?us-ascii?Q?iRvVkbx2LVnd2VFsoV0NVoyGOItuBD1n/wkz+KZh/lp7P8gor3ExI/NPZy88?=
 =?us-ascii?Q?n9XFwmKQ7Xg9ZsjXEGACbCf0tJ0jW0nXy+XKtYlW6gWarbk3ybZPnzabEc3w?=
 =?us-ascii?Q?r7MnQ5ylx6iknIn72D7s8W+kD+C7DbCeeQpUcX333FxMzyO6xq9KZvbd9rTf?=
 =?us-ascii?Q?eQrYueyDojPdwDySeFKkW6JkIh/dBuxq/01J/tfzul01XofqIw+B+vl/1KRW?=
 =?us-ascii?Q?J2lh+PAwI5HmTkfWiIrIqnt+IUTZ4fF0h7eslOYYfr38EgTYCWbUUtb6G+zz?=
 =?us-ascii?Q?9gOF4raXc3RF47B+73UCz66iMBeuVt0xc99kB7NQMp7U9ZB/9puo3CA2UXW6?=
 =?us-ascii?Q?4oayG3yRHAdHFiBbJzAWYbFElr2g9IZh4YVZJ+Agm8iP7MmwNm2kjlqeDTUU?=
 =?us-ascii?Q?2ysS6b7coyH2I6LpgCfUzER9EUbt1JV21fQ7PaSd9G8HWrqP/HcfP8snfeOU?=
 =?us-ascii?Q?AYeXemudq+XFv78MT1IvL3jbQcXC8CC9egjGJocF?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 268f0c36-8564-4561-85bc-08dc36ed6ab8
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2024 17:07:30.6345
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u0AZNWOUACyJak5gZlR2YS5KelVLXejNwa1CoAsgj9Y0CI2Qwk5csCLeMGT1IWjx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6905

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
Tested-by: Moritz Fischer <moritzf@google.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 6cdf075e9a7ee7..597a8c5f965899 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2509,7 +2509,6 @@ static void arm_smmu_disable_pasid(struct arm_smmu_master *master)
 static void arm_smmu_detach_dev(struct arm_smmu_master *master)
 {
 	unsigned long flags;
-	struct arm_smmu_ste target;
 	struct arm_smmu_domain *smmu_domain = master->domain;
 
 	if (!smmu_domain)
@@ -2523,11 +2522,6 @@ static void arm_smmu_detach_dev(struct arm_smmu_master *master)
 
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
@@ -2875,9 +2869,18 @@ static struct iommu_device *arm_smmu_probe_device(struct device *dev)
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
2.43.2

