Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2082.outbound.protection.outlook.com [40.107.93.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E6977FD;
	Tue,  4 Jun 2024 00:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717460170; cv=fail; b=Tfn81pJyXJmjMWVjPmsOMOZbzQWQezOeEvg6hrbGtCHwWcdmE022EsAA/VmpBwBgoFwWwp8evmtvQj2YAstMfD5sLOOHu9PcJjrqfoqwqx66znKxqeqxMf1wOOqyGSfKd5oMO0PL2kBfpq0MT0eBhaX4HpgCQdQEE+EBoHLaP50=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717460170; c=relaxed/simple;
	bh=Q4WQCNQIVuSjmnvK2WJ9XLCT90nz8ve0LP38XMmGUJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=m30UDgq2hRwNR9xyQNE0NjR2UlyCdpOQOL+2U2lGMCJwawI62vZ6+jpR/0jnsQPJqtIKmuLMARru6OGke651FJXdc+sQCHqNJ+MqhHIc3Tf0wcXlLBkv4B2x1AjCXR9z9enbTp2PjAJDNzb71w36eDXelx9CDoidwT01H0EHJBw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=jqeVHnQK; arc=fail smtp.client-ip=40.107.93.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="jqeVHnQK"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jIr6DmEjSa0v3eTC3mpW+yiALalUy5Wlw692ZOyURG2FszQdp/CiWPrBvaGtgteLNrxoxLXaFmdLx/5/Hgo+8ALAkQay98fW8fACd+PdMsNGcmf0yYOBfVDk8y/MMQZHLaTEQvCmJXOEUQv7g+AI1DiIidxUKdpVOLM7xSqEqP4ralnnIauarNS0+S+1I4hX2blWB7VQFgq0wsT6BdWsrMnr4aqrNIQmu8W571QzJDDdOIHg7g9XwuDTJm+H1ip+Ytu4r3fIovBZK5lkl977Qtp/B6D41wzCwti78KuEVcIPKD5nIPBOp91GEayMdP4w6Xrw/gXjhxkBSPIKJOzH2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=avdBgAJxEmMvTklD4lK2mlU8xg+oDLKwffa5vs/jyok=;
 b=II3feL8LkOdrARLpvBbziVtaIjDjIwD1FPefHEGoOw+QS89fuklwWdXBZkYYr/qAhyLf4WzNPjMzjC294xRAacM7UlkewhdcuxVv4q3CLq2XuwfnqOzXw4KYmZsARbHFkHYXvNgswTcg7Xg3vofBZHGZw5vE/gJ3gliujM5H7VCjszN0nhsAipt5e9S1+t0yC95WTx9S78DUArBWG1W1EOARQIE41t7WsIOst4BhrCaOv9OWmyQs2X2FSXNVwPnmTs9H4/LvdjXo2gKoorVOUT5yZ0hjZnnUG0Ano+hp/SOeUsMekpPJwjoU7mhJMynhaZSY+2dYjhiwLPmpMmFOog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=avdBgAJxEmMvTklD4lK2mlU8xg+oDLKwffa5vs/jyok=;
 b=jqeVHnQKOiUwoJ/SBcf0GTmJ09HfWzG/aqcg9vNlSJp0LOz6JUkP8DFaJaQTkBE9McoG2yJUIH2m0cRso2nj6lBaCaGkWcjfTWdgkevI/X1babJtwlx19p0x49kbQC6lP3uAOa3R/X9Vd5wHE8qj6P+JDc67eU75wudRzJaR0YFRDO8jn25CjkfN307vNqw77fKfODmLo7m6ZRIlXSiDy9xdiO4VlFf6aUPtpl/jmEisvV20I07Z9EtcWzMJHDXOtwbSqHUkyFZETrVdYnf/GZL1kprgv93JrTj/VwXeFUBsSBA4tl7x0zX50WgRNmBdHUuh4TgNUXC+7+vy8rpFcA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by MN0PR12MB6296.namprd12.prod.outlook.com (2603:10b6:208:3d3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.21; Tue, 4 Jun
 2024 00:16:03 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7633.021; Tue, 4 Jun 2024
 00:16:03 +0000
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
Subject: [PATCH v8 07/14] iommu/arm-smmu-v3: Thread SSID through the arm_smmu_attach_*() interface
Date: Mon,  3 Jun 2024 21:15:52 -0300
Message-ID: <7-v8-6f85cdc10ce7+563e-smmuv3_newapi_p2b_jgg@nvidia.com>
In-Reply-To: <0-v8-6f85cdc10ce7+563e-smmuv3_newapi_p2b_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAP220CA0005.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::10) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|MN0PR12MB6296:EE_
X-MS-Office365-Filtering-Correlation-Id: 2300a7e2-0261-42bc-581b-08dc842b849c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|7416005|1800799015|366007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ECFv/XVQXazhb3CvaXKV8hR9eicKg7cd9scOz9wIFD3eK4IeaJE/GS+KCzPb?=
 =?us-ascii?Q?bvr6grfgjBldEaVsM+YVJGHv4KYngO3UyKNtE++tkZCkmzIMRotPGrQie0hL?=
 =?us-ascii?Q?+VOtz+OeZ8ULVb+O8aLXeaU+Lgs5nsNOUlZ0xUaPR0tEwVz330zxKTMkNbjw?=
 =?us-ascii?Q?Nkp61lIGp0R5UGSHYCA8tvOXsFtq+cJ6LbETc9F799+Ih9Joi0uAEu6aaZzx?=
 =?us-ascii?Q?HXQjJZfC9G+9Lg2Oouz9UgY0XxE4rojA2mzp/4nlEzKJtN6eZst+ry/WTRkS?=
 =?us-ascii?Q?9Z7lAyKy9wD4I1DuXJ7tzciUS0GsGD2hMzlcvgrKTU7epUXFPvwNL4I4lPLI?=
 =?us-ascii?Q?NkJXFLA7L3QNGOnLHoX6aTeuH6ToF1V4G1EkQ1B1V4m5iPkB0vdUOUa+Mqxi?=
 =?us-ascii?Q?g+KtH/CBtmWyGSjnQlRxXW6iJxontnpDfSWeAnA7vZItR4SD4k6RJlasJjab?=
 =?us-ascii?Q?fZmVCZ3lHVQXu4wcaT9Pupmfb0akYMp68DWRHvJ/xIyzRq6noH43ELv7+WF4?=
 =?us-ascii?Q?O885B4LKSh4SoRomxOcW5/EBL/tkMhvYIxtN+karRB5EQWAxRKQ/mAp7tvJT?=
 =?us-ascii?Q?3N6+1tp1AvLnVAlNKjM7uw7nKBGCecZaFvlAws2RgJuABW5goWFwD6IlI45o?=
 =?us-ascii?Q?pT/bpEbOq0eBEx904Fg3MEfOK612BgMCnS2PWF+oGpNEsnHoWGaOxUme0nO+?=
 =?us-ascii?Q?HsNITqPf+uMC6S18oMYzyU3aOgaENuHD9HlEhjQb+OqQ6iI6WvqZSu4AVWde?=
 =?us-ascii?Q?VbUwTVPNVYVqquLNTw4uixeQ/5D+4fwd9nsDvDnF3qz5GpOYqOyWcpMl2TVO?=
 =?us-ascii?Q?vKHjEWRyPTFpoj6MV+KA5yJ5E5b6gGrZ8RgcAK+tOqjB1wnklWGWzIvONDON?=
 =?us-ascii?Q?lN1/jx0WqVWXhescxF/moxK8VxF58BVNyxw7jY1B+tXXYpygoCgpqJ/wgGaI?=
 =?us-ascii?Q?y3fV0GO6EISA8HgCwaVWbLtUJWaieBLpywKdc0Ki5a/vNcGVWbzWkldInTYr?=
 =?us-ascii?Q?PbrukRmWAk+vm/yJS2JbpkTCqewsAtki7/2NUeJU68KlBW7awqjw3W1tB4Qi?=
 =?us-ascii?Q?j/BXp63qIauYwewqaLMfXXmLjNjvqfJb7sodtn8iRRAJ8QbINq4J8oCWX2e7?=
 =?us-ascii?Q?CFVXe9HyfG7IoHVntVOkrbuiC8vSGJvR5EyN9/JRmzswt7k93VjUPeNaFKLu?=
 =?us-ascii?Q?eSiODb6wZxOZRrfMAVsvhBollo6hrGRPE24n6gkIRqpDEeR3H9JUWNUf0HMF?=
 =?us-ascii?Q?OopOuHMmEfo17AqUSoD8zQQSjjriHKSFiXANhqJ1/w=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(7416005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OmUZ9SjUUp4Zjr8LNv4wr//u/MIQJwBeKIpJKLpVU+oya+4kqzbdfAGfbtWC?=
 =?us-ascii?Q?DL8huhmTS0lG0HykzMq1ZoODHXuNZl1FE3g0a2x0LbEXe4vchA0eJ0CeLGZS?=
 =?us-ascii?Q?cuc4xxNzuGaHgZbEZ1AXbF96qxyCJUO7/PNhbFvx9RqHEw64Wja3uFI5ydS1?=
 =?us-ascii?Q?WUgyoYV1xQO5+QCt6FzEzEz5YK9tHll56SK267BmpiHYFD5v7g3R79bWAM2h?=
 =?us-ascii?Q?7jpTKmipZvsCaRC2XhcdHBVlvoWhX9jpKTu2jOOV7HYEf/2Q96NjgcMnuhiE?=
 =?us-ascii?Q?gcmeM9Z5K3uNwkLARYdaOFuJeczF1jFn1vtbkjOVEYFSFHpj9FIdiRRmvja2?=
 =?us-ascii?Q?2QvtQk6YWCRK4lkvJB3Y+jO12bg+9LI/hNWMkd53O90mmFnqNxAojvyLd9e2?=
 =?us-ascii?Q?SdSSlBZ7VddXQaaq2lKwvDKfjmIIIobSxd1u67pBZR/lPzouxwtqecwR3SJe?=
 =?us-ascii?Q?AwFmyGSA4jIVYm8oxVcffbpeDYSytuK0gyQQjGWlZl60PjLnVPeToReO3XIe?=
 =?us-ascii?Q?GGUIyPBT1mODuay7huhzCn0VLHvEecWVFNhpDp3s/ExBuJmCd0IcWiI154VN?=
 =?us-ascii?Q?Aihmx/ELE/odTjH5JuKp5wXevaLK+3ygwYa3XcxbiUVDJpYmrNxx3yiuBB0H?=
 =?us-ascii?Q?KQPIvDBP+FOYN9iidVMlsXONQx55p4Q1FCp/4UCJzAqRfYE/acgWe8EsbITg?=
 =?us-ascii?Q?SRZ1vg55caJal9Q8lMZBRqYRwEaFUxB/jt1gDeVn/aGjHpSn+NpAQTDG2ufT?=
 =?us-ascii?Q?SbWRbtC/PqXB9kQBExeQwyqRMTCNEpBH7rkAvi8lX4ma6Xvt7Tt7qYh3jbUr?=
 =?us-ascii?Q?GvLlIQosNVeY3DEIxegShx3DlN2uOwc5h8e560gBN+ZgP1YoirbfV0UkgW98?=
 =?us-ascii?Q?vTspia+nOu8wZMIlUK+Bb0cMGRmlYRJXcNzvco8mOzVZ4TcxJL2dm3RfQb7U?=
 =?us-ascii?Q?gOkFXbbnj45/9VqNo6kgi/Sz6UIZvVVEzWrIoBiCQSgZdbW6+es/LEs0P8tG?=
 =?us-ascii?Q?oFT8n9Z72aeWqMjAUfMN0rxUDYC44lyHR80XD+TEjmPOgCT61NBxFT6KRA/o?=
 =?us-ascii?Q?VUOG17GaPi/TVcMSA9+NNxnfW0PX4jBpj3u0T6nh0jtEfOROG5bKHuRiyb3i?=
 =?us-ascii?Q?NcuZUHV4qOrAJCQ0XQNghhLJS3l910e5ZknvfEMc7kyLm47DfaSpsQJ5jYpf?=
 =?us-ascii?Q?l6M80jpfrmrGe32bwJvcElLYM+n8roS9t0eIX/3buGM1pcZC3ja1GW3QR6oB?=
 =?us-ascii?Q?H+di23pZ09ralSeD5PO4kQoPB8ld1ysOX7mYwGVKR6QBKIUPKbEMENempZbM?=
 =?us-ascii?Q?7M1pfIIWwqJohjiPMMk6tfdqXbrhU/e3X9Q8ZPuAwnFEsa7TuuZUF8giAwGi?=
 =?us-ascii?Q?12o1DcEoBjSvrIc1HDI5YWxcs6pwwtRBGxUVTxO2Rwgeb6RegNY/vjKNAM81?=
 =?us-ascii?Q?EvjNvJY4hpsTH02Gh8I47aiLgEQR3E73eFxX37r90AtzyCrTX4dyGWbqwM+J?=
 =?us-ascii?Q?hwkKzLBW4X/hvsIxLogjfXcgDm2vukKct0o29aPizWkClqFLmiNd8zwcMtl5?=
 =?us-ascii?Q?vIOfvujM7jSvQH9RtJU=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2300a7e2-0261-42bc-581b-08dc842b849c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2024 00:16:02.4201
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nyQeUAoxyfwT+C23oGr1IXYjH6Vc6QblIZ+k56IZr0Jw/hO5Qvj5EvCtDSDILt0q
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6296

Allow creating and managing arm_smmu_mater_domain's with a non-zero SSID
through the arm_smmu_attach_*() family of functions. This triggers ATC
invalidation for the correct SSID in PASID cases and tracks the
per-attachment SSID in the struct arm_smmu_master_domain.

Generalize arm_smmu_attach_remove() to be able to remove SSID's as well by
ensuring the ATC for the PASID is flushed properly.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 26 ++++++++++++++-------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index e7cd1ddc03517d..56e2fe52df530d 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2005,13 +2005,14 @@ arm_smmu_atc_inv_to_cmd(int ssid, unsigned long iova, size_t size,
 	cmd->atc.size	= log2_span;
 }
 
-static int arm_smmu_atc_inv_master(struct arm_smmu_master *master)
+static int arm_smmu_atc_inv_master(struct arm_smmu_master *master,
+				   ioasid_t ssid)
 {
 	int i;
 	struct arm_smmu_cmdq_ent cmd;
 	struct arm_smmu_cmdq_batch cmds;
 
-	arm_smmu_atc_inv_to_cmd(IOMMU_NO_PASID, 0, 0, &cmd);
+	arm_smmu_atc_inv_to_cmd(ssid, 0, 0, &cmd);
 
 	cmds.num = 0;
 	for (i = 0; i < master->num_streams; i++) {
@@ -2494,7 +2495,7 @@ static void arm_smmu_enable_ats(struct arm_smmu_master *master)
 	/*
 	 * ATC invalidation of PASID 0 causes the entire ATC to be flushed.
 	 */
-	arm_smmu_atc_inv_master(master);
+	arm_smmu_atc_inv_master(master, IOMMU_NO_PASID);
 	if (pci_enable_ats(pdev, stu))
 		dev_err(master->dev, "Failed to enable ATS (STU %zu)\n", stu);
 }
@@ -2581,7 +2582,8 @@ to_smmu_domain_devices(struct iommu_domain *domain)
 }
 
 static void arm_smmu_remove_master_domain(struct arm_smmu_master *master,
-					  struct iommu_domain *domain)
+					  struct iommu_domain *domain,
+					  ioasid_t ssid)
 {
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain_devices(domain);
 	struct arm_smmu_master_domain *master_domain;
@@ -2591,8 +2593,7 @@ static void arm_smmu_remove_master_domain(struct arm_smmu_master *master,
 		return;
 
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
-	master_domain = arm_smmu_find_master_domain(smmu_domain, master,
-						    IOMMU_NO_PASID);
+	master_domain = arm_smmu_find_master_domain(smmu_domain, master, ssid);
 	if (master_domain) {
 		list_del(&master_domain->devices_elm);
 		kfree(master_domain);
@@ -2606,6 +2607,7 @@ struct arm_smmu_attach_state {
 	/* Inputs */
 	struct iommu_domain *old_domain;
 	struct arm_smmu_master *master;
+	ioasid_t ssid;
 	/* Resulting state */
 	bool ats_enabled;
 };
@@ -2664,6 +2666,7 @@ static int arm_smmu_attach_prepare(struct arm_smmu_attach_state *state,
 		if (!master_domain)
 			return -ENOMEM;
 		master_domain->master = master;
+		master_domain->ssid = state->ssid;
 
 		/*
 		 * During prepare we want the current smmu_domain and new
@@ -2711,17 +2714,20 @@ static void arm_smmu_attach_commit(struct arm_smmu_attach_state *state)
 
 	if (state->ats_enabled && !master->ats_enabled) {
 		arm_smmu_enable_ats(master);
-	} else if (master->ats_enabled) {
+	} else if (state->ats_enabled && master->ats_enabled) {
 		/*
 		 * The translation has changed, flush the ATC. At this point the
 		 * SMMU is translating for the new domain and both the old&new
 		 * domain will issue invalidations.
 		 */
-		arm_smmu_atc_inv_master(master);
+		arm_smmu_atc_inv_master(master, state->ssid);
+	} else if (!state->ats_enabled && master->ats_enabled) {
+		/* ATS is being switched off, invalidate the entire ATC */
+		arm_smmu_atc_inv_master(master, IOMMU_NO_PASID);
 	}
 	master->ats_enabled = state->ats_enabled;
 
-	arm_smmu_remove_master_domain(master, state->old_domain);
+	arm_smmu_remove_master_domain(master, state->old_domain, state->ssid);
 }
 
 static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
@@ -2733,6 +2739,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
 	struct arm_smmu_attach_state state = {
 		.old_domain = iommu_get_domain_for_dev(dev),
+		.ssid = IOMMU_NO_PASID,
 	};
 	struct arm_smmu_master *master;
 	struct arm_smmu_cd *cdptr;
@@ -2830,6 +2837,7 @@ static int arm_smmu_attach_dev_ste(struct iommu_domain *domain,
 	struct arm_smmu_attach_state state = {
 		.master = master,
 		.old_domain = iommu_get_domain_for_dev(dev),
+		.ssid = IOMMU_NO_PASID,
 	};
 
 	if (arm_smmu_ssids_in_use(&master->cd_table))
-- 
2.45.2

