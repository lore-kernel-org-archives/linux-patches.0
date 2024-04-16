Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2079.outbound.protection.outlook.com [40.107.244.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD0F3137769;
	Tue, 16 Apr 2024 19:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713295715; cv=fail; b=fBckgezAxO+68kA5Sl/EE2CbT6zmyE602sl5OlII6W3FNf/hHg6iiFJcZqN5c9MwJdw4Pla+pBn04LIYjOBEiins7/tVHXZAZ6U/rNNOqGwRMwQ9OjOlfr6IW3O/WaUwKPbFyv0baTnaW+GefqMPfXTbQketenKZ8D+YjcVjUGQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713295715; c=relaxed/simple;
	bh=vA9BRIDuRNz2K7/SkSvZ44/k1sDA4OlHd6wJnnbFvLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KEgHPfxrZ6jrs0JWY6o/OkUZPMtP6xgdJI0eDXw4/BRSGp78na3hrnKvdKzwlhTHgfzCo16MDiEaRyA5457zJs3clGxcjbSR4Dd4WAZzh+hdSYm3cj5mr2TFLAWzHKJ+F1//ZpbBjKRz/UhWYoXKlGeDpI8J1rlxxA30nQFBBg4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Od+o7Jug; arc=fail smtp.client-ip=40.107.244.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Od+o7Jug"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f5VAX8oHpJtqC9p+NekOiVDaNoy3kFzEdYkDbUFnnJTqForCDl/FKbhwvdsGDNGLQg4PQvs6kU4Z/kX3Vm/+ZQSJVt1Dr7eYpv45ATfZHG3KA1i12EKBC6oPLkGfoNrwfnGktspIMJuUEGGRbxRFZOJ3zaiPpZEcJALWE1sDG0nGSNXxif4w/HhXV8zLFXcEdw/e0ZCD8uNgYLb+pjQDFXc79J36vPBuoDhXBi701B7+hd+aLSbgHNBeNK4y8vbHaEd9gTXIX7pS96laEoHO9HTMpg7vF83t1gel23XAePhRna+tjoReroFDOOKdCGhh3OxjvSV4dxNkc237+IE2VA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=noviFek5dK1FJybLVd7tzoMY/WnRustfBIibVZJwQY4=;
 b=hvWWBPEGAYVj2zOl7/iuQBCgsrvT+MVeBHkswYN7z1svrgQ0n7KYQgBRMHXI9Twg8/5aQHH1zg4WlJSPAuYGfpcxX1TuDXgOtX1reYDt93QnqXh7Tpeh0LuLqM1QjRB0KuDiuip0oDgxwtumiTfON0ZNIhxFxwh3KCVkbzOfjz9bwoCf1Ki3L2p/CMi3AuFeHbkEGbEr3NBE4HvZoCQlce+C9E9fm/U827+U9yZhFUTe0xPoDPGiiVKCCYrZZkYKI/7fd7UwfrtdpKy+fme5PTzi1v5eJ3JaI1frO6e3V/8kLqdJgIIgSm0cOtNo1ykEnIxBizAP7RbuMLtxoxqo3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=noviFek5dK1FJybLVd7tzoMY/WnRustfBIibVZJwQY4=;
 b=Od+o7JugvYwydGiKCXKfWap+WtTln8EsACueds+cwO8DvO0FShIZ3WNU4ycD9D3jCDFjEgvBOiDQrheWJkE60OuVmeGdnBG7wLpvDVa0nnTTES14zClOcsEgcNLlq1+AlqFgSEn90bQn4+sEUwTB6J2DwFDbgKZHp0FOBW83zT2ge5lYSNXEyWsBUmy/B0aEXNi5LHYuQi/n4L2N3w3Cj/gcfg8qkELdLkfEC+yV5vKQkZ/NpBeAGCenZuPqM0aUhy0B7SODpPGoIu/QJOdee1YRh26Jng6eaO1aRcQHBMhFknNOXtqnc30K5Wfg5lFBA2mTPOPVdokHSoO0AfyMnw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by DS7PR12MB5912.namprd12.prod.outlook.com (2603:10b6:8:7d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.50; Tue, 16 Apr
 2024 19:28:30 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7452.049; Tue, 16 Apr 2024
 19:28:29 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>,
	Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v7 4/9] iommu/arm-smmu-v3: Consolidate clearing a CD table entry
Date: Tue, 16 Apr 2024 16:28:15 -0300
Message-ID: <4-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0042.namprd11.prod.outlook.com
 (2603:10b6:806:d0::17) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|DS7PR12MB5912:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ab21a22-02c0-402c-5b5d-08dc5e4b61d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	kVteyYHLgrH9vaSLPFU6teHhyHqKSILsd6VhjjPr4JoGoMaSZGupw6XDwsmDYx/1b7EbNmtRnUirgLHCC05u5xZonz8sad+rUH7n6FSZGrvbkCiGU3I/s+2U2ZI45orWilTNrTgMMWqTDEKJHBtIRaec7jOdymPt8hYMvOW7OALq47mlcT/VHo5Xy00W3uwpWuKtd/bxfhDme2lOI6FZsqHTbWPqt/JSt8s1t5OCHqLyDAsIOiDkOD/2yCv9rPLrn/kxr2mm4SzTXEwjPLtEvYsExIlWjAiMkUQjHJvv2ejzCPYzuGQVADh8wos1TlAANicDY86QeyGsVO9xKlpT7V/avZmJDFQmIZ1bsLCsyhefvRk0+v4aAe1dd+NvOiiGsQCvDJIg9KSoSqLsbiycqTuIhKyZafRa62Cpf87s06PngU3XuM7H2UqpX3bp20XyqlnRMWHxmqkU6u7/FD8IPpaRSGO0DBxtPvsY3f8Jns2lrGjZKxaROfqt/tQeNSvZrBvq+zAOclfN7lFOgc7Qn5UCTvRbTyFVjeNMdyIQ8VYfOk17hzXo6NP4JTO/ZtRnL0Mj5bLzbj0kO4sriwwJblxflJIITOwBcI3/MBIC5mhC48kChi8XuKcJr8q4koHwJ9OTTZ2iVOwoJFQBDVJD3GKZN9/rf5oNp9sEVYd96AE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?r6G7ftTWcwP2abpXDjJYyypMd0pgXom2R/IIU/GyB4eb+4PAhiEIvtO4Zntw?=
 =?us-ascii?Q?IXhJ22n38MKRUbyER9xZgsG2ChPqRtxJFmG88dYzLaM/OQmhkXfnOXB9/EvU?=
 =?us-ascii?Q?5nUA40wu4r1aigKeAt4sy6MuVBZPHhW/dBzMJXFZbL8DrWriMwMTE5v4AXS1?=
 =?us-ascii?Q?IzVOIbMZRlX7cjfDaQ04Jtev0te+8bReXL4PuZnZtwBS0W56RChW3O+03WAX?=
 =?us-ascii?Q?7Rbsa6w+/X3xQnATEJIxUzq+Zdvs0Jlmq9dGcEnrmfEfXG/xklV2fB5y1bKr?=
 =?us-ascii?Q?oiCuTuUlzJnDxzx6w1IaN2p4M1y1Sv1RXMZ7s65nrWE/RFIQmzpN9yqZHD93?=
 =?us-ascii?Q?45tHjW2HBzbcAofoV2ZArV7iZlvMayWfTvxESO4kvfNBiKu85dHuWO2EZ7ZT?=
 =?us-ascii?Q?UB6Y0TEQd9fH988PTXKt+X4tbJZwQfz+3KkRVdDJO1ufpv4+kfe3NTBuxNlE?=
 =?us-ascii?Q?/M+zcmfUhC30oyO/wp593/KbwnCjEKV+B89vLKVLEx514xWlX1C48B26mkN3?=
 =?us-ascii?Q?Y+z8SQn/scHRRvtWg5yKAA53B9uEtSJhW496feQhxkXcyEzn23mJa7iBb62U?=
 =?us-ascii?Q?I0xb8VMewxAjFq6XU8wx/ChuBUQT7zxBpoaDVdPP+yuKglwDt18PwH7Aac32?=
 =?us-ascii?Q?TJ0w/ALldkABcGqb+vc8nhzS+jEZM0k/KTMAxOuC0Ksgt5P9Ds50YCTcQHeh?=
 =?us-ascii?Q?+COrGEyJFhcxK8EqIGJNAYLhpRmKy+R5D7aOvu1S4xHPl7dZseqgKMbW0nkX?=
 =?us-ascii?Q?BH5hmc3quQ8G0xvoVzggBhgIz23w4/HIPcF0p+KmnrmC7/NJcwbsbLnsz6w4?=
 =?us-ascii?Q?qhQg/xl4O1l0tZ/MUQUfY7ktP6LSg6H1nHbm/Qpk56rh0x3R+SiayTcByrEt?=
 =?us-ascii?Q?pOAIzT5zHsasgVMchTaQVebVo+i4hLzRwRvvIb1SyJMEvMi/sCP7V/XkBi/S?=
 =?us-ascii?Q?Nd5iqe20hiQdVK0kIzKYoNH83hNerhyJGnEnwB/pMj/88pqbPLqgLMQWRonR?=
 =?us-ascii?Q?4LY8p3KcyckWX7YHY5FjPEj0awvrBmJWyviI5O2nUP44VPFlKkKl9xq5PguX?=
 =?us-ascii?Q?sPINjKOB5EPChMaDvet52eQL2QdTjw5k0oDF/zVHImtH+J5ciRoMI66qllfX?=
 =?us-ascii?Q?9rjALidH2Sgr9vm4yBoXB2nXqWpZYTd6JV+f7jlIwkdHsRL84RhYuhinOkrs?=
 =?us-ascii?Q?70RcqRHmppD46ESeUCaA635hAXHSBkC1UuW1aLxV5MdIeeNStYcagE9N6+fg?=
 =?us-ascii?Q?1zT+3EMkONxmFoZItMTtsjmNv1CY4OF1ZxIRaPtRem9rffZkdsWexI/TBB0x?=
 =?us-ascii?Q?Iap8TjnUoABDfOfYh+vVIjdW4GB/cdBh00Nen//j0xn0fmlpIbs8z+IrkUv8?=
 =?us-ascii?Q?vLTYW0TSHw67TxIEKPRTVScntII+W4xGCSn15jleFMDp3SsFdZh3loqNj4G7?=
 =?us-ascii?Q?5/eipPXHPXN9jZscaPqRCDj4OYf+mGfI7PvtCOBNQsTkXnuS//Hunad25T2E?=
 =?us-ascii?Q?x02egGvyQNDyaNVS0TAaXPyn/0CLlyu1NT1R0+sL8CMHLEKBnQXipLOqcxs6?=
 =?us-ascii?Q?U+Mfk5Uk2u1jScbrkVwGhbSsGDRm+We8d6kEZEka?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ab21a22-02c0-402c-5b5d-08dc5e4b61d7
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2024 19:28:23.8208
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J2ihp6sLFoqtVZKL8qg5bmP7ZylHp6fzANzTm7dRCmE2SC25GDc2osDyUjm46cxR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5912

A cleared entry is all 0's. Make arm_smmu_clear_cd() do this sequence.

If we are clearing an entry and for some reason it is not already
allocated in the CD table then something has gone wrong.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Reviewed-by: Michael Shavit <mshavit@google.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Moritz Fischer <moritzf@google.com>
Reviewed-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |  2 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 20 ++++++++++++++-----
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  1 +
 3 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index d159f60480935e..7cf286f7a009fb 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -569,7 +569,7 @@ void arm_smmu_sva_remove_dev_pasid(struct iommu_domain *domain,
 
 	mutex_lock(&sva_lock);
 
-	arm_smmu_write_ctx_desc(master, id, NULL);
+	arm_smmu_clear_cd(master, id);
 
 	list_for_each_entry(t, &master->bonds, list) {
 		if (t->mm == mm) {
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index d24fa13a52b4e0..f3df1ec8d258dc 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1309,6 +1309,19 @@ void arm_smmu_make_s1_cd(struct arm_smmu_cd *target,
 	target->data[3] = cpu_to_le64(cd->mair);
 }
 
+void arm_smmu_clear_cd(struct arm_smmu_master *master, ioasid_t ssid)
+{
+	struct arm_smmu_cd target = {};
+	struct arm_smmu_cd *cdptr;
+
+	if (!master->cd_table.cdtab)
+		return;
+	cdptr = arm_smmu_get_cd_ptr(master, ssid);
+	if (WARN_ON(!cdptr))
+		return;
+	arm_smmu_write_cd_entry(master, ssid, cdptr, &target);
+}
+
 static void arm_smmu_clean_cd_entry(struct arm_smmu_cd *target)
 {
 	struct arm_smmu_cd used = {};
@@ -2696,9 +2709,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	case ARM_SMMU_DOMAIN_S2:
 		arm_smmu_make_s2_domain_ste(&target, master, smmu_domain);
 		arm_smmu_install_ste_for_dev(master, &target);
-		if (master->cd_table.cdtab)
-			arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID,
-						      NULL);
+		arm_smmu_clear_cd(master, IOMMU_NO_PASID);
 		break;
 	}
 
@@ -2746,8 +2757,7 @@ static int arm_smmu_attach_dev_ste(struct device *dev,
 	 * arm_smmu_domain->devices to avoid races updating the same context
 	 * descriptor from arm_smmu_share_asid().
 	 */
-	if (master->cd_table.cdtab)
-		arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID, NULL);
+	arm_smmu_clear_cd(master, IOMMU_NO_PASID);
 	return 0;
 }
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index bb08f087ba39e4..99fd6f24caa818 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -751,6 +751,7 @@ extern struct xarray arm_smmu_asid_xa;
 extern struct mutex arm_smmu_asid_lock;
 extern struct arm_smmu_ctx_desc quiet_cd;
 
+void arm_smmu_clear_cd(struct arm_smmu_master *master, ioasid_t ssid);
 struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
 					u32 ssid);
 void arm_smmu_make_s1_cd(struct arm_smmu_cd *target,
-- 
2.43.2

