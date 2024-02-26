Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2057.outbound.protection.outlook.com [40.107.237.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E624912F5A7;
	Mon, 26 Feb 2024 17:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708967268; cv=fail; b=jdqHttXHmWMkkK03m4VDJr884KBI5pKpPAt2SGks7SeD990UdxmTrZhvilTMPzShHxI3UO2b44nW2P6QQmAYaiyyBE2+Z828GYmbyI3Y7sbgv9RATmybdGsyPxmFOT7tioE7XkxPae3hfxUvwzC+3KJUGrtMlgtF5PjNvd7VnWU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708967268; c=relaxed/simple;
	bh=0B2r9sdoco+V3sKqvnPQY+Sg4zFx5eo0zzsSWFnRm3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GniNDzXvwbZiZgBWzWX7XeykAIxhk/XwX4pvMxp6Nc12dkn+phPvcJSNwwtfE4vkHQHJqSTWTMTsbYqtKMsuB1vn6Z/74mcBliNoJlPHJi2OnhUbUKLsAcx1N35X5Uqct4gVjUvwELrBG35AhUp5tLG2DmYHSSY1dKVJk3mpf4w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=O71fJvps; arc=fail smtp.client-ip=40.107.237.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="O71fJvps"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ii7AMo2pNYdY7MKO1R2B59sYXTX8bpnsVlMag+KmgnaMbeJFH/jGWEzfKq4XBz6VHQsAxGqPfIMRZz9IIx9b1UCMw8IoP6SSBS1WWUBw8Wdg165DgW8Zmfa5CEZ/EFUVqOe2mKm9pxDaBoRswjmMhYSG8oZI+Hxk/b8JcAja1pRxYKbCSwqQ7VAd4qcm2LZ0bSm1g6JFnwd066xpGb+hq06izmtWsBPf7DzUJRxcYwAVTkwmyBgJ1of1RdNop+7jEwzGCz9vy3zqS3TzQuYdIZ9OOI+0c15hGL9ZaPp/r8ieoMwqo/Qk7f60z5IrIweWUXfoig2H/5IJBekRDNxKSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5T/3Da5SgzU/Vy0hm23N8FJaF0+S35B8BrDUE/AdJb0=;
 b=k9WtwxmXPcwPaZYd5+/X1pcas+00QMW/3qTVoXQYky/N/ETMVkeyH7POzywAEjMXZfHsOEVEW+OVszHoUF432oketkAcj/MJvfktA5DBmCJ/NyzFaYr9oOtw7JgAjqm5gBdeTR5hwsrATrr0Owwmggm9XxA+E73de0VOPbTMcSAfa85/D66KfpZ3GUnHSPYayL0nOE6zESnekDNZLrUnG8WHVRpBvwI9jRFfEpTzVFy6XYs9bHWG2ugFo2ekVty4wkNaP93KWJVZ6o9nZShEMniYIPcfRnTaQWTRpuZcx+f+f/etoYSCg+DrAmh53G6FJLPaATRefPdBmo6Yzh9QQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5T/3Da5SgzU/Vy0hm23N8FJaF0+S35B8BrDUE/AdJb0=;
 b=O71fJvpsIe1Rlyp/OImnNOk7yc3Ncz4oN+EWYiPedXH017ke7MVknVqaxYQ5/oTdG/ZZ03aWtXUojF8GBMVvAE5sZWKj70+JAqiLwidQIP7GpjurbDOmVcRs9vRx4wATLy9K1z2nWp1d1gPfdwwiCXDYC2aoRIZT1fKsJmdbR8MHAWXcnZbhUHEQfNpjKrbjrJzU6SiUBjZaMBM1gQ0oxhjc90aoz8UtCld7AkQ70Q2LE4xUNupbwC8yZMqP1/ysARmJZwWUL1Fo3DGUqDcMzgNRoSwna3v+HSy5vFJ2idcnB1sTxuf3ceBAVCgOjIXQPzeFti+4ieQJwVTypz/QCg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by SN7PR12MB6768.namprd12.prod.outlook.com (2603:10b6:806:268::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.33; Mon, 26 Feb
 2024 17:07:37 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::2e3e:c7c0:84da:3941]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::2e3e:c7c0:84da:3941%6]) with mapi id 15.20.7316.034; Mon, 26 Feb 2024
 17:07:37 +0000
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
Subject: [PATCH v6 08/16] iommu/arm-smmu-v3: Put writing the context descriptor in the right order
Date: Mon, 26 Feb 2024 13:07:19 -0400
Message-ID: <8-v6-96275f25c39d+2d4-smmuv3_newapi_p1_jgg@nvidia.com>
In-Reply-To: <0-v6-96275f25c39d+2d4-smmuv3_newapi_p1_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR1501CA0023.namprd15.prod.outlook.com
 (2603:10b6:207:17::36) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|SN7PR12MB6768:EE_
X-MS-Office365-Filtering-Correlation-Id: f91f606e-66e6-4179-e82d-08dc36ed6b1e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	pxvbKKz4UcfQpJ+q3p1ASe2PATlWa768uEiyr+sbQxIjGKAP8sesSKlEtJTzbR/jgQFmBYDCRzF+FBGe2Y2ZJ9IPTBBRGYUgtaJ96JMisF1cTLxHEc7TxZYmqYekTQfAwPaPUMS7u/R+WPIjJsdeMFwTMZn6FxA5XYSyaxnFmyKgqQWScwkpht2qWvdhONR5YwzMNd9aV5bj64bLAxLOUu5Jk6Yt3a7mWlPucaSb5xSTa5mlqrTXQI5aF58CRc6oZqMDCgURApVVl1SnZZQdNMvMgUIOb6rCe988k+9Y2wjpIFAWjlVqQ7iaqmkabIBdHEQBF9JrluDpZInOYsqR08YiqcYZO6sInic93h4KSHcc8LwyVuwphb1Mi0v414wn7hZSTrIhJxmXfqCI3PWM9R+dg9LxUSiIJ46Q75Ktv2Mf0HEjwXfxZD5KeHE8HWfXicrVEbcTwTXk7Is+XXdT0BfKtK9hXwGErm/ZnjkrZLY/9gQd1PzH4rQa3Kvi4Z480frpJLAJzQTCZspbo+XvbNGMJKhCiS8zV7mRy+/Y2VGdPIhspWio1IbxWaF8xWm4BtKxmEfNajScIDW+cgIjQF9aXaLB6bEmuAEojZIloofMamzR9XARKtTPTjmaSEOajKtMUijEGSeQFa8yLNfCYg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?s9Z06JI+2c5MrxMHD0sO49YrXtpdNv+hM2CWr6h2u3p9K6edHkp7Mx+6cAFP?=
 =?us-ascii?Q?njqdikVW08WZcSmQ5lPtaP9zZ5qHB9viEQv1BpIe4LcH3lh4RkQ4UN88LfiR?=
 =?us-ascii?Q?SlUqEk2A1lQLnC8mFTnnz39ppbamh7D9UTakdQIaAcfWyivo9GhlLGzAiPhD?=
 =?us-ascii?Q?24EkvQULtYkkUxXNjgGazrkBnpIbkxxdo/yjrknzGpOtJ1FV/VukP32veB4I?=
 =?us-ascii?Q?t+DE8FvoplTF3r0qiYz06/4IMg6M0rDiLfmSL3eRCeTjSc/GOwSx0RYPBoOR?=
 =?us-ascii?Q?aCB73RCxYEUsUR70jO4bFJueTqAL1lqi8bWvbtgr6AhxeOL58R8eXHjf9wui?=
 =?us-ascii?Q?V3CzwQ3n4+pW18w66d/EjWmr3nrDEwEH1nevjDqU83k0LuOBSPkWFzIM9Cel?=
 =?us-ascii?Q?O3QSJ3Z/mhpYteUklYxbxU574wfEHLmoNYxHVhtT/9ZMDiBJ49Af2kwKuWU5?=
 =?us-ascii?Q?IMHrFsFN+/w0w4GG0sW7T7x7WwxWAeFK3octYMUexuc5Avi7JjGnhqLXD4ML?=
 =?us-ascii?Q?KI4ySZKNAnnYvtRPa+as3lafe+c9feEDGrUJZ0xVywzpig7PMzD8WetCJsDg?=
 =?us-ascii?Q?6FAMiOb/g5cgIvjI0YyylR+9yeZJOLJpKbBNmuJXffxZ6qm0VTFsAL6x3ifY?=
 =?us-ascii?Q?drNJuu17NS18xK4NeIq+VpTUXPAeWmEH0S4hcxpunTWgO/tfECagEpr10pcl?=
 =?us-ascii?Q?cUSa9dM0DQu3/unGpqOhMf6bPWk2c0W2tS9OGJefW0f/YzurHilnwU6rPSRJ?=
 =?us-ascii?Q?3+dkqqFt/1L9ymgXuNW6q12ptXm2opWCTKAzvEILfgR2ZruY6EGtJXTatsaz?=
 =?us-ascii?Q?mVeG60YqQFJrhwL2adekWZUmZMC6XVQtz7XoOgUban5/I+9RaF4dy+yCvQC4?=
 =?us-ascii?Q?dNV8YtcQp8sDpBYXoPxN842KF1ONDaJzbWVS2d2OtPfNOBIhKCgdS2Dm7PXK?=
 =?us-ascii?Q?f9WnWxpM0TQNUY8/tELVXHBn0/BIaHVP1ipP61n2p6NJIl4fPUSQC6Muaki2?=
 =?us-ascii?Q?HFSVT0qAdp/mk/Be+OlW/M59rYkApGCFiAHwX1+I6JnHKVZWLl8uPQE8G0Fs?=
 =?us-ascii?Q?sf0wQnG1WL1ZkMbU6mupTH+5VdVouA8rAPfZ938fQ9qgPkaSgXBqBekv1T0H?=
 =?us-ascii?Q?r++5OD7yc9oMy0vBLpcQ2/64NOrtpsSMYO9Tstoc8zZ0TqWPqo2QC2MgTcSc?=
 =?us-ascii?Q?QZ45eWnFxQJyqylNHhmLhdA7UiZO89etZ1Ju/j1UOV7Gip2E/VbFZiSfh14O?=
 =?us-ascii?Q?q+aNfH1r9IkHB0/GATlu4kGTGHPY/uIc/O+/HpEm27im8gwyM95HM89DcKDK?=
 =?us-ascii?Q?B3Yopo7QoXCOjf9rT8HFotKGAO3P08RhWI8kNVV9zJvLj8YoX7IrJ/f5R1XB?=
 =?us-ascii?Q?r233zRxRNAm7mh54pRdfz93BqVFwjbTRWbrJZ0WuU/KPHe3QH6m+qE9qu8NU?=
 =?us-ascii?Q?VP5uJkWlEKiPYMW9NyIDxq5rltZSUd5uQnNDPYq1ahKNDOPqgfyHKW9q4iVj?=
 =?us-ascii?Q?eNwEOYGqnSlMNFvrz0UBj86xm/Uh2AxilWrdi8fOsZnawg0JjkWISGWr23bg?=
 =?us-ascii?Q?DPwVM7Too4i9HEWpz/I4jWpms4iPrvwsLV2J4JQD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f91f606e-66e6-4179-e82d-08dc36ed6b1e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2024 17:07:31.3411
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uIXQYka1EiC7prSrbhPxJlRokmgbUtXCBBfXIhhciKPYnD1zuU6Z0zaDzKgxvZJO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6768

Get closer to the IOMMU API ideal that changes between domains can be
hitless. The ordering for the CD table entry is not entirely clean from
this perspective.

When switching away from a STE with a CD table programmed in it we should
write the new STE first, then clear any old data in the CD entry.

If we are programming a CD table for the first time to a STE then the CD
entry should be programmed before the STE is loaded.

If we are replacing a CD table entry when the STE already points at the CD
entry then we just need to do the make/break sequence.

Lift this code out of arm_smmu_detach_dev() so it can all be sequenced
properly. The only other caller is arm_smmu_release_device() and it is
going to free the cdtable anyhow, so it doesn't matter what is in it.

Reviewed-by: Michael Shavit <mshavit@google.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Mostafa Saleh <smostafa@google.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Moritz Fischer <moritzf@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 29 ++++++++++++++-------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 597a8c5f965899..ec05743ee20847 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2522,14 +2522,6 @@ static void arm_smmu_detach_dev(struct arm_smmu_master *master)
 
 	master->domain = NULL;
 	master->ats_enabled = false;
-	/*
-	 * Clearing the CD entry isn't strictly required to detach the domain
-	 * since the table is uninstalled anyway, but it helps avoid confusion
-	 * in the call to arm_smmu_write_ctx_desc on the next attach (which
-	 * expects the entry to be empty).
-	 */
-	if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1 && master->cd_table.cdtab)
-		arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID, NULL);
 }
 
 static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
@@ -2606,6 +2598,17 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 				master->domain = NULL;
 				goto out_list_del;
 			}
+		} else {
+			/*
+			 * arm_smmu_write_ctx_desc() relies on the entry being
+			 * invalid to work, clear any existing entry.
+			 */
+			ret = arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID,
+						      NULL);
+			if (ret) {
+				master->domain = NULL;
+				goto out_list_del;
+			}
 		}
 
 		ret = arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID, &smmu_domain->cd);
@@ -2615,15 +2618,23 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 		}
 
 		arm_smmu_make_cdtable_ste(&target, master);
+		arm_smmu_install_ste_for_dev(master, &target);
 		break;
 	case ARM_SMMU_DOMAIN_S2:
 		arm_smmu_make_s2_domain_ste(&target, master, smmu_domain);
+		arm_smmu_install_ste_for_dev(master, &target);
+		if (master->cd_table.cdtab)
+			arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID,
+						      NULL);
 		break;
 	case ARM_SMMU_DOMAIN_BYPASS:
 		arm_smmu_make_bypass_ste(&target);
+		arm_smmu_install_ste_for_dev(master, &target);
+		if (master->cd_table.cdtab)
+			arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID,
+						      NULL);
 		break;
 	}
-	arm_smmu_install_ste_for_dev(master, &target);
 
 	arm_smmu_enable_ats(master);
 	goto out_unlock;
-- 
2.43.2

