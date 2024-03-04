Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F487D41B;
	Mon,  4 Mar 2024 23:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709595875; cv=fail; b=uNYwjhRHrcIdtYvtBmxXUO9b3duijeJd6A0qMOZshLpIyaQ4gXHbIV8/uQfyNUUvYOxe+lSIHql8ZbU7p+XTwifd+lhqj8RRplyGaQKj3W9l9uWBAf+yeLTEEbovx1e7xz5S9kTuOKGdaMicBe9763XglbjytEgy9YzbRwQZc2g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709595875; c=relaxed/simple;
	bh=zAjgH6UpDdWt03CszD8W6Ch4HPH9M4vOisbuhB7VsRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IFArAazEmR5aaONE10YOxlAMOJ4a1VT3quyQ2JsYLchwr51fiP+21X0AkrfQ/Sy+wwVv33TjQ2ZF9xRQ/WlmgBRMPlksLnPnK9x4DQLpqsIoW5NXR6906Agf8OCOtcRL2xU5aWgesMYQBndMKIhkz8FdRJL76hasu2tslMrXZKA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=m7d9yFU/; arc=fail smtp.client-ip=40.107.236.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="m7d9yFU/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YCzL2c1LwIS7eIdmtOvUnXzBJXR3E1RgyDptLZf+gEv7ZxnWtEZFWKD7EtbDSs5GslVSlykOcv8p2WJRRUTBc4lPXaXUwp7RytOoy79vlFuhgHntCB8M9VYQKxC0GNsnr3HYkeXEovp84O+MbFv9tdViP4a3Rc1tT9V2mFanEpZzYiQ/FHK1anPIGi0hXkVdz9dCKjq8Z4+6IJN8k3DvPSNzl59zWUpPwvouwC4Q9o6yBj4FAkozYxn4ILAIVV/tmCYvmLfBNF3cs2XreDasZVdlgEU/vLBCKHy//MDb0+ZYWlrCwHvk15aYUru4nbNcn2t3kHlKZ+gdvFluWod4JA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CxTjpE86PFWZfZxaD5Qic0Glv07KhwFBlXGdL599CLY=;
 b=Zfk+5mhy6tXztTczM9IdpYMIKmM9QTEHFY3UupTYXnctDaRNuTeTOTH+TZ4n/6aQrwqwt0GNpJx4SQXnYE8jk1/yeFa3t0NlUUnJyhaiDQxJWmDE4zjq52MgEGDTJ9CMpWgQ2QHW6ZSlTydUEYKOzAsjRlSkWH+uiBtBjuA1yQAZ5YC/04cOIX8C3kuXwsMEb+dTTDfqQh8Tuszffv+8WjGNu8OSThfOR2l/bDO8CuNh4jB9m7QPtuLZ7dk3n6cFaKkJ1gmvbnbzxQUJYow3SE6Dnz36m61vz/eCwJnr/rQKek2W1nxO0+0HcDCdqmzav03z8aLVLrqceVakjyyX4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CxTjpE86PFWZfZxaD5Qic0Glv07KhwFBlXGdL599CLY=;
 b=m7d9yFU/KHtS1SdhEzrB1tu+HC0eGvlTREmE+5e38yS0/RnV2kdm+AG4I6t02N6D1si17GZkOPbeyH7EIKV4/hE3cVrz/LsWK1vsZIEKBuJ2nttVEx1v0JK1AMbOnoMqXIYlZX7Kp7JKmm44R/ZWVl4t8qS2CV6wkVDQthHid8PvoqINaCYKZmbXLsjdbq/idiIk7ygh0yfTxxOXmsQBeHcnEHnUxJY8nGUw9znINvXmYBeDgOgFyMLr1fW9MKoO4x+7Idr3h6NoZeXobr07uC6pKj1jwHLfT9z36cgd7hQaHEb4P8Ja/rIdkUGQfQCQ4Y33kdxYCYnxEej4FOY8Kw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by DS0PR12MB6584.namprd12.prod.outlook.com (2603:10b6:8:d0::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7339.39; Mon, 4 Mar 2024 23:44:25 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c33c:18db:c570:33b3]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c33c:18db:c570:33b3%5]) with mapi id 15.20.7339.035; Mon, 4 Mar 2024
 23:44:25 +0000
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
Subject: [PATCH v5 07/27] iommu/arm-smmu-v3: Move the CD generation for S1 domains into a function
Date: Mon,  4 Mar 2024 19:43:55 -0400
Message-ID: <7-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR20CA0048.namprd20.prod.outlook.com
 (2603:10b6:208:235::17) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|DS0PR12MB6584:EE_
X-MS-Office365-Filtering-Correlation-Id: c9678695-1cb4-4f1d-c944-08dc3ca501bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	IHAIyNkZ4NjB9rqqjYslJlj+sSFO8GFAEI7DziZnhc57tfir6NBqtsc8QKaEPTBZng55BhFXVmQK+AiTZ3E8eeb0iZenRSiGnyA92swheIlaogPiAB6fZcv0lC1v5D/bRH1IizpHppKdTP0Kx28KEC/1EGeO9+g7XV4XmKDSOHbR91XmTYBAUtTY64MjlCC0v75hLtJ1fi5yxhKBEPVoX3Slb3VQiU8qvGiT8wWhTIJEVmbmYTV9MlVP7eDmlTgqMcf+Upb7E17tqjP66MzJmnKEh4lkDmSkIh1DSXWeGAA+LX5ZD6omyXqlLv2BIBGw0qXvgowq3HT8AVBq+S3WP/XADJhXdO0UM86cBG6dBT3gIQ9PtdfVV46qHk3ESI/0GnWj/8nLKwcB/HFPKnPJ1r1DWm/w3f/hkN4bC3Idx4DrhzevQg0OfAy6dGgyvzXeH8aVaGOuqci+qQilDtM4Ok/qn3ghv/LMPuVfzMP2dWdxA1sxgBAtwlgQIqklm9qOZ3OfT8ri2zNZt1qIa1codKS1pTsUF1obro5P7Pjjg6yRCYJmmQ/yXEzYPaiJ37IGR65JQnFeJefn+IELCiiaZBFcHELPKLuBnpBT0qo6RtJKYIp9cVsENjVJsSc42b95m9e35Rmp9YhzaOzxk0zVmmdDg1fWogSCCPqkVVkzCEo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?owaS5n8y7z1ye5WgIlqpH/vun8mOk1Vz0wlAQIlCXeuSb7YD6OLN/sobtLpU?=
 =?us-ascii?Q?Z7hvpDlvsatyKwsRC+a9Mt7IC5bKg+6OlsD8T3EcwlBIK3yh2PhBSgZoswnC?=
 =?us-ascii?Q?Aejab8/6XoklnJUFjaMgCn8ixwUN3j156pjYQ4LEEFBsZmqrgx1mMCod2Ptl?=
 =?us-ascii?Q?TO8/8tobLzuRat2BNOVEqBNxALm0TT47dwOoXRP5gfryU++j9ULhRD5RD7j7?=
 =?us-ascii?Q?UYtYWlYzpWdJ2b6WQL1ldNousaBLYzi/Azu3rzZPpb0oMdCTrLdkUqRT1XBk?=
 =?us-ascii?Q?rCafziW+CO9zY4Sd8a1D9eZ0dEHqCKdbw7ce3WrY4NsKlr86oWAtqW8dH8lG?=
 =?us-ascii?Q?qdcM9L9SlRHvXjYpPWX9bWTwm+YH6pp+YrJPkZrqOR1fovjvfNaHmy+jPKq/?=
 =?us-ascii?Q?8ETjO6HGkiXa5TmpLzQm+PTdSW300AXW+M7ICKSDUFPdCiW/BQtPtP14alQY?=
 =?us-ascii?Q?0OMyjRwOwot6Ugyi5IXkqfj6IbAK2xySCfrRa0oTBPoUMLUtDbcSH8N+SPW1?=
 =?us-ascii?Q?SY1w7fN7vESHjwN8W2Giw4P2DM8EqLuJ26PoAYBGCs5kKJrkew+cbBFuoADB?=
 =?us-ascii?Q?O/wuP7j28JKXE84lC0R1vjXEe6tmtxAiqrcH44VqfIAB5g6VD+ofOh6ox9Im?=
 =?us-ascii?Q?wjsaBiNML691TUkOtmfkbAE4VxlBTkikCERa7soY0JitvssKrDM4R4ym434N?=
 =?us-ascii?Q?YowXOiUkIyr73bJRrQmgH9ND80NyfSCCkLR6+u52VK8AcSKF3SGGeyix6wFx?=
 =?us-ascii?Q?ghDv7hWxoi6uqup31uwg35WjwJRyhVQzh9Bhhn3eyns0lSozfVdXLiZH6GnO?=
 =?us-ascii?Q?45As0PVkysiqm4Rkh3dWJkCXaMfUr8t6qV6I/qs54NobS9LU0w7WHDKEZBI/?=
 =?us-ascii?Q?abKs96V6lH5HybDbtk24yscjP7s22QIQnC5o9q+kHIkQp18m7nIE/EBCl1wj?=
 =?us-ascii?Q?SmhTfwv+s1PyQI8I+OwDI9GN/Z6pZGY+3DcSo/5KWUrPu1nGLIdndBOnsjn4?=
 =?us-ascii?Q?0xoVQgQsHEGartSL+Vl2navtFPXlnAlNAqjUWIHHn0yrRqdeMIpN2oN0QJjI?=
 =?us-ascii?Q?WJhnRd6yzvlsQvw6gy1NF6+0wM5jQsv2RZPZhVtDtRdnC8ZQG301jczq9bWL?=
 =?us-ascii?Q?Qyw0N6IgDBv+/HclqKXCFvrmUCMsoSV7tkrREamdx0zrl8xGZlSchXqbV6aK?=
 =?us-ascii?Q?xSnVsPCRWfY1sWOsoVgGneVzTwXgnyhj4MohI9vz8FpKxKplcU2FVCduunos?=
 =?us-ascii?Q?SJJZmxTjHEKa8WA5kXtLEAPFfcEaz8neLzhaqG1AxxGy+TGLgZCs2gPtqSRD?=
 =?us-ascii?Q?DGigKujo8PRS12GinU6tx2DAQ9FfMc54VtfqIj+GGTqEFJpicWEu8pgC3xwx?=
 =?us-ascii?Q?HhJYJEAaG3SqjHjkXAyTlkp1rfiOmokWjaoTCWnZfdlpomt3CpKQ7x2fXMCi?=
 =?us-ascii?Q?98pPqJ1ssdXNNjaDyzwIq5IgrP0qVtp4B/tZBSydvv1xpHDm0QfktBhZbGOz?=
 =?us-ascii?Q?s7be8Eq2P9Xm6iG1A1EFzFO5yl5wlLdB3X4jhc7dKxycBlVyOZbgiSQGf+me?=
 =?us-ascii?Q?JSHTsYIBGswe2ATwlstdcHsaQWLIkyP1IEVFraod?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9678695-1cb4-4f1d-c944-08dc3ca501bf
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2024 23:44:17.7877
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PMxIMaAKAwDSbdE2v7inuH+YOECV1Y0MfgHkbHwuSPS4IBg2H3GBT5FJ/2YCBDtg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6584

Introduce arm_smmu_make_s1_cd() to build the CD from the paging S1 domain,
and reorganize all the places programming S1 domain CD table entries to
call it.

Split arm_smmu_update_s1_domain_cd_entry() from
arm_smmu_update_ctx_desc_devices() so that the S1 path has its own call
chain separate from the unrelated SVA path.

arm_smmu_update_s1_domain_cd_entry() only works on S1 domains
attached to RIDs and refreshes all their CDs.

Remove the forced clear of the CD during S1 domain attach,
arm_smmu_write_cd_entry() will do this automatically if necessary.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 25 +++++++-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 60 +++++++++++++------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  8 +++
 3 files changed, 75 insertions(+), 18 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index bb9bb6fd7914ce..6acc65f6d00a71 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -54,6 +54,29 @@ static void arm_smmu_update_ctx_desc_devices(struct arm_smmu_domain *smmu_domain
 	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
 }
 
+static void
+arm_smmu_update_s1_domain_cd_entry(struct arm_smmu_domain *smmu_domain)
+{
+	struct arm_smmu_master *master;
+	struct arm_smmu_cd target_cd;
+	unsigned long flags;
+
+	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
+	list_for_each_entry(master, &smmu_domain->devices, domain_head) {
+		struct arm_smmu_cd *cdptr;
+
+		/* S1 domains only support RID attachment right now */
+		cdptr = arm_smmu_get_cd_ptr(master, IOMMU_NO_PASID);
+		if (WARN_ON(!cdptr))
+			continue;
+
+		arm_smmu_make_s1_cd(&target_cd, master, smmu_domain);
+		arm_smmu_write_cd_entry(master, IOMMU_NO_PASID, cdptr,
+					&target_cd);
+	}
+	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
+}
+
 /*
  * Check if the CPU ASID is available on the SMMU side. If a private context
  * descriptor is using it, try to replace it.
@@ -97,7 +120,7 @@ arm_smmu_share_asid(struct mm_struct *mm, u16 asid)
 	 * be some overlap between use of both ASIDs, until we invalidate the
 	 * TLB.
 	 */
-	arm_smmu_update_ctx_desc_devices(smmu_domain, IOMMU_NO_PASID, cd);
+	arm_smmu_update_s1_domain_cd_entry(smmu_domain);
 
 	/* Invalidate TLB entries previously associated with that context */
 	arm_smmu_tlb_inv_asid(smmu, asid);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 3fb4a1523d1d3f..e25dbb982feeee 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1222,8 +1222,8 @@ static void arm_smmu_write_cd_l1_desc(__le64 *dst,
 	WRITE_ONCE(*dst, cpu_to_le64(val));
 }
 
-static struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
-					       u32 ssid)
+struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
+					u32 ssid)
 {
 	__le64 *l1ptr;
 	unsigned int idx;
@@ -1288,9 +1288,9 @@ static const struct arm_smmu_entry_writer_ops arm_smmu_cd_writer_ops = {
 	.num_entry_qwords = sizeof(struct arm_smmu_cd) / sizeof(u64),
 };
 
-static void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
-				    struct arm_smmu_cd *cdptr,
-				    const struct arm_smmu_cd *target)
+void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
+			     struct arm_smmu_cd *cdptr,
+			     const struct arm_smmu_cd *target)
 {
 	struct arm_smmu_cd_writer cd_writer = {
 		.writer = {
@@ -1303,6 +1303,32 @@ static void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
 	arm_smmu_write_entry(&cd_writer.writer, cdptr->data, target->data);
 }
 
+void arm_smmu_make_s1_cd(struct arm_smmu_cd *target,
+			 struct arm_smmu_master *master,
+			 struct arm_smmu_domain *smmu_domain)
+{
+	struct arm_smmu_ctx_desc *cd = &smmu_domain->cd;
+
+	memset(target, 0, sizeof(*target));
+
+	target->data[0] = cpu_to_le64(
+		cd->tcr |
+#ifdef __BIG_ENDIAN
+		CTXDESC_CD_0_ENDI |
+#endif
+		CTXDESC_CD_0_V |
+		CTXDESC_CD_0_AA64 |
+		(master->stall_enabled ? CTXDESC_CD_0_S : 0) |
+		CTXDESC_CD_0_R |
+		CTXDESC_CD_0_A |
+		CTXDESC_CD_0_ASET |
+		FIELD_PREP(CTXDESC_CD_0_ASID, cd->asid)
+		);
+
+	target->data[1] = cpu_to_le64(cd->ttbr & CTXDESC_CD_1_TTB0_MASK);
+	target->data[3] = cpu_to_le64(cd->mair);
+}
+
 void arm_smmu_clear_cd(struct arm_smmu_master *master, ioasid_t ssid)
 {
 	struct arm_smmu_cd target = {};
@@ -2689,29 +2715,29 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
 
 	switch (smmu_domain->stage) {
-	case ARM_SMMU_DOMAIN_S1:
+	case ARM_SMMU_DOMAIN_S1: {
+		struct arm_smmu_cd target_cd;
+		struct arm_smmu_cd *cdptr;
+
 		if (!master->cd_table.cdtab) {
 			ret = arm_smmu_alloc_cd_tables(master);
 			if (ret)
 				goto out_list_del;
-		} else {
-			/*
-			 * arm_smmu_write_ctx_desc() relies on the entry being
-			 * invalid to work, clear any existing entry.
-			 */
-			ret = arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID,
-						      NULL);
-			if (ret)
-				goto out_list_del;
 		}
 
-		ret = arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID, &smmu_domain->cd);
-		if (ret)
+		cdptr = arm_smmu_get_cd_ptr(master, IOMMU_NO_PASID);
+		if (!cdptr) {
+			ret = -ENOMEM;
 			goto out_list_del;
+		}
 
+		arm_smmu_make_s1_cd(&target_cd, master, smmu_domain);
+		arm_smmu_write_cd_entry(master, IOMMU_NO_PASID, cdptr,
+					&target_cd);
 		arm_smmu_make_cdtable_ste(&target, master);
 		arm_smmu_install_ste_for_dev(master, &target);
 		break;
+	}
 	case ARM_SMMU_DOMAIN_S2:
 		arm_smmu_make_s2_domain_ste(&target, master, smmu_domain);
 		arm_smmu_install_ste_for_dev(master, &target);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 87a7b57f566fbc..d32da11058aab6 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -750,6 +750,14 @@ extern struct mutex arm_smmu_asid_lock;
 extern struct arm_smmu_ctx_desc quiet_cd;
 
 void arm_smmu_clear_cd(struct arm_smmu_master *master, ioasid_t ssid);
+struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
+					u32 ssid);
+void arm_smmu_make_s1_cd(struct arm_smmu_cd *target,
+			 struct arm_smmu_master *master,
+			 struct arm_smmu_domain *smmu_domain);
+void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
+			     struct arm_smmu_cd *cdptr,
+			     const struct arm_smmu_cd *target);
 
 int arm_smmu_write_ctx_desc(struct arm_smmu_master *smmu_master, int ssid,
 			    struct arm_smmu_ctx_desc *cd);
-- 
2.43.2

