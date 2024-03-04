Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71C547D06E;
	Mon,  4 Mar 2024 23:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709595868; cv=fail; b=JuxSRzTiMxM/eUzvcgyjJVKxVRjkRX9Wqp0Q1kaWlaoasxWIMfH6WPck8RxftKSDFli1C5i786D6IUcL1CYrwPvVCtN4HnAiw83DVq3qbl7oOu4zQ4kWAbbmmmt7lOz4bJC/Y2i5c5WJMLbFARds69tRIfQ9wAAWLTzn2/3d8Mc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709595868; c=relaxed/simple;
	bh=qrLrQupKfnRlHTH/jVAQ9m7bm4NRta+yVNJXfs4/+jA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=nO7tacqiopLshvyZ+fifFqywAFqZAw0O5zfKkW/nIijpZxaAACVvxYgF1xwCLS0DcAJVQ+DuukJxHxILzY7fOnaHo7pqb+lvEyyrsQ6aT5QexjvmhtRWeb0E94o7jZdkw6yatQ9vTSFajhJO1zQFNLeeCFHw/qum8GsrxNdYcCY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=nAUL6UfY; arc=fail smtp.client-ip=40.107.236.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nAUL6UfY"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hsGmQZAcUL+Kp+AF6EUEP5Hb8D3bPyAR1NgQK4nQbN4A+3+2lWIkpuyiWffE3YwB21/jv7XMqSEiVqu62YYFafAtBXY7oirE6BQ0rxx8z9KkHAJs9dgspYiTN82DeHCwoCsXB7LurX7nXn3ct4oYMcWDZaSKmKmhqrrqpR+U4ErueN7IyC+cYfMw0US6RNj3iT7E/OSp3RCx77DJe9pvbe9NZk+yssgbnZ0Q+xRJ4tv5e0P7knCrwmQ8wmhwwY6SaePzvYJsUQESkYRTM3z4jfiL2hWgp+voxuzIkxUXdx49QEYAOWawDtRqUwKpchPAG6ZGR3x/sH/8ANyfkHcQCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XET4rStPnLZAdka6TN/V2ZshTmiUATYNPr4gttBIl4g=;
 b=ixAFDWWuRYwPpWhNQ2DOC6jbhTfhP4/5uXLSb+fhZXXJPHuyfd84QzWubWG0n9Tspsfd5Yvp/N4T524wQdVaQq3qlpkRPPZgoZ5TAvH2w096oeEnQsaMHMUaAANkRKXYZn9Tb19vr8KfRnxlnDl9LSoiSrA7Y/Cc3EUqLGiOzjIONl/E2VeBlUdZsVDBUVUS0vNOJ0F0VMnkX6pZunxjaTibtKKdFGOE6oSsuybDSQyS7v5y4LO95ZF3RGN+K940Q8uCj90sdru7J0iKgE0USOW8l7ChWwGrXhv119CbbhGTYTQASAHieQ0ihDpv7CfRWlZdMnt1ZWgvD/r4To/Q3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XET4rStPnLZAdka6TN/V2ZshTmiUATYNPr4gttBIl4g=;
 b=nAUL6UfYyXndrYnzhtLusGVxD15DXxZGPjGh7MDl/a+KbiV+xEz7USxVz/CN9HGSlkEu297CSLJJT2eT3Y713IHqL+KeAmQ+sLHdpx/plqBlY20zBvLnMva/JbZc6ciP5zzxbHqpJvz6CqlX5H077ixmwN1MqTCBYO6N33CvWygzLH4Yc/2JG8zj7hLmDcTy3C2isJEFWDclNzrAXb58SIcFZBvHODGBBt0kRmDJIAmcw9cW4PX1nap0ZUV6++AWzJcw/AmfSyOtEg8K4BaZ9JrK5w+YkMZzM5V8eLgVNnvn9zLVB/ELDopsABquYMpC4PRoTKgFbvlpPJ4aWoPgxA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by DS0PR12MB6584.namprd12.prod.outlook.com (2603:10b6:8:d0::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7339.39; Mon, 4 Mar 2024 23:44:23 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c33c:18db:c570:33b3]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c33c:18db:c570:33b3%5]) with mapi id 15.20.7339.035; Mon, 4 Mar 2024
 23:44:23 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH v5 08/27] iommu/arm-smmu-v3: Move allocation of the cdtable into arm_smmu_get_cd_ptr()
Date: Mon,  4 Mar 2024 19:43:56 -0400
Message-ID: <8-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL6PEPF00013E06.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:22e:400:0:1001:0:7) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|DS0PR12MB6584:EE_
X-MS-Office365-Filtering-Correlation-Id: aee5ce7e-dffe-40cb-5c52-08dc3ca5015f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	2MLNeM3l6+PwEXJZAenrUsOkJ/P8N7WBj5gf4XU2cwYXEv3M0sHj5eOs7m24NGo72GA3GGr1POzpdkGnmpKcXmHpRZO/knsYtT4LCg3G9fbrt5bEP3pB1QfFU3IW1PzxFkIl9lw+J9i7BnvcrTgOhhLvy+Vcwnz5jp0lPGqI1jMyUnU507WGtHpg2djcTwkJsZsi+5Tm1Jyt1a83v7j8dp9su1igySyL9dyOI0MoimtJq/fBW5wursP48Z6AOaF0QOkeOCVI3x6i4C5O5x5n70vzcKMPC3bWnMhi3JPmAMBwbgiolFvNSjkW5HYEb0V0jwYeP1TbhoUVq77/GTSMVgANusPPdMIpMxBl5hjUKATQTh6c3B3WOjipDkWI557nMwDZClBrXn0f9Nbt5mA3L1eg3UuHvTgD0wPq2aZF1DU5RYuZcPxpOTcO5iw/pfUktOBrQcxKUXGoLaZDS90aXHPxtgikdWntnhBbV9Vg+gX5SFFnIpI1EKuT7M6BvR/Iy5sWzZEiZdK9jUvF3rLmRAZpEAi5+86nj/cNJYhJYH6J2ko56lJKNS44K1/vBoWYZ/G7ULYq+wSA75RJivW8AbCgyWOuHj4EcgxgOnnCjZCzmeYOZGSa7g0AlyjVDsPQ4dgJeEyyoKn/Z5G+RE15VzMpAFfXTsC30935s0vKsbc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?am5SMNMTuHa6dxy+Wm0FNgnwJASExAxxIFr2kzGFKAHNuEZQNTFWQg0co5Y7?=
 =?us-ascii?Q?wwEK8x/8iToiGhyZLaBh5Q/LuMciKbZzFcjwPeabIs94ALdUiUpvv1R7Ecq/?=
 =?us-ascii?Q?MGpIunQsmWCW+mAzaM5NLCerqt/7hN6wrshqH7OQ+VGNfMmcxGEqw2PN77Ic?=
 =?us-ascii?Q?XJvw2LBdLNzpDXaZuQGsoo/KyPsThdNyUBV0kI2u0fqF3z4V77F9P++6T6M+?=
 =?us-ascii?Q?lSvHTSz9fJpVi6xDFh43tdaYhKXiusdESO3c4mu+fdKCzUt/S7sgfH0P6jhq?=
 =?us-ascii?Q?wUFx7gAI2RTmyiSCzDRCkPdP7reZf2OHsVA5Knp9zveZUK46agXfoAyNQeDn?=
 =?us-ascii?Q?t8GtM3b7bCIvnklh3vm2vd7+LeGGyJTjLbEWoMKTlV4xgFh0g8UVTXltrAM1?=
 =?us-ascii?Q?8Zi/HnnrmgAguXB9BnIzS1ax8mz5e5OGx+2jQL7nP/j7yCqbiD96EGvLTgEp?=
 =?us-ascii?Q?4ILMyPJsKg56/eiQEDT3lub4xXiW9zAaUNKgEuTmlht/PrWT9aDis5xFwpbz?=
 =?us-ascii?Q?7arPph6hpXusuPCCkrp7+fDfDR5V9qzpJwk0/PAd3hxmE5HAP13/fcydGLqF?=
 =?us-ascii?Q?F1JHELoPjqASOdOLEMmOQAjPE+PdIonAS18ZTnNB91QXbNC9wzW0zEmqG5Wk?=
 =?us-ascii?Q?jpgVvW3slYOyh74jpOiFB/BikR6cld7V8QxB5vlRAZexHvut8wS0lLKWj+w1?=
 =?us-ascii?Q?bbn01CqidZdXg9dzGRUsxc3rnRIC3Ius6pLAUY4t4ilnS3U3ZdkP/bUFkXmS?=
 =?us-ascii?Q?ZUGZnjUK8xhReWhaEqjLYfy3bAlP+um2wwUTa6xGfww5zms9pB/9EjmxkbrX?=
 =?us-ascii?Q?3fogPBHj0BdptWlRM5Bn2+kWoTkVvr77Zd68UALw2JgWpUDxz5iS8KgtL2tu?=
 =?us-ascii?Q?TNrlpxqGto2vWRs/s8AbNqsbQcpwkZMff+XWGOD1rwQWTOX5oQnqZrqQ0bDB?=
 =?us-ascii?Q?ieO1OxOoKhK0iRLYXecxyu85X/skOKiS68M0+8Re8zwDXll3XvhyQrq+NidG?=
 =?us-ascii?Q?yxdIU+55S5Hm5k0lZPuCZCuDXfgmpwmRCgluTzsXh+c7AxbpG/zRDLcf/DTv?=
 =?us-ascii?Q?fyTr32/NeJt9/F5hN8571AfLIl2giuhI4kEdCYUaUIUYeHFMguEggpMGYHkO?=
 =?us-ascii?Q?N/UyCZEOy2PSDTkMHJw3raRQYB8yIgRmXbqRSNGFQ6sp+WyUZfgPPlq5gWKL?=
 =?us-ascii?Q?I2gl/181BWZd4M1gUJDCzaqUgUP8CCoZXIgaolk23tchZIeK4KJ7aVwQvJLF?=
 =?us-ascii?Q?51Bsr823/g1OLlg4lPFLMFUXtsQwra4bxsrrxEd5aHz2BaySpT2bCrF5jFq0?=
 =?us-ascii?Q?/c2neNsQGAmlyJvvAMO1Yv/D1HdGZRnAYbOdeIAbQFeGlzeKlcjBsMA8fg1p?=
 =?us-ascii?Q?yspo0iddmZaQBWBSwvBukUkyRMizL8E7efhfgEZPLVEwc3uQOcNAbfpY1lHA?=
 =?us-ascii?Q?huGxOlbuZSBiA3lIOuFl3eo1WXZHQ6SGHFP5/HU86wwjKESaU56xwg1IGF7d?=
 =?us-ascii?Q?zs+vFa722g/culxU9w0jFs1N7Cp/k4XV/ONxUpehmUFVsMvOyYvCr48f4ijx?=
 =?us-ascii?Q?sFSALrmaPf34N5Ed/3isq/mSZM2w2+bt11sndS9W?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aee5ce7e-dffe-40cb-5c52-08dc3ca5015f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2024 23:44:17.2058
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nI59oi+d19tKRvAc8F2eweRArrakFMdRLoZDMsvGI8mSgsO7vVAcqV3oz8yig8S5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6584

No reason to force callers to do two steps. Make arm_smmu_get_cd_ptr()
able to return an entry in all cases except OOM.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index e25dbb982feeee..2dd6cb17112e98 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -106,6 +106,7 @@ static struct arm_smmu_option_prop arm_smmu_options[] = {
 
 static int arm_smmu_domain_finalise(struct arm_smmu_domain *smmu_domain,
 				    struct arm_smmu_device *smmu);
+static int arm_smmu_alloc_cd_tables(struct arm_smmu_master *master);
 
 static void parse_driver_options(struct arm_smmu_device *smmu)
 {
@@ -1231,6 +1232,11 @@ struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
 	struct arm_smmu_device *smmu = master->smmu;
 	struct arm_smmu_ctx_desc_cfg *cd_table = &master->cd_table;
 
+	if (!master->cd_table.cdtab) {
+		if (arm_smmu_alloc_cd_tables(master))
+			return NULL;
+	}
+
 	if (cd_table->s1fmt == STRTAB_STE_0_S1FMT_LINEAR)
 		return (struct arm_smmu_cd *)(cd_table->cdtab +
 					      ssid * CTXDESC_CD_DWORDS);
@@ -2719,12 +2725,6 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 		struct arm_smmu_cd target_cd;
 		struct arm_smmu_cd *cdptr;
 
-		if (!master->cd_table.cdtab) {
-			ret = arm_smmu_alloc_cd_tables(master);
-			if (ret)
-				goto out_list_del;
-		}
-
 		cdptr = arm_smmu_get_cd_ptr(master, IOMMU_NO_PASID);
 		if (!cdptr) {
 			ret = -ENOMEM;
-- 
2.43.2

