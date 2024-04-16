Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2043.outbound.protection.outlook.com [40.107.92.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18130137C3E;
	Tue, 16 Apr 2024 19:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713295721; cv=fail; b=mJf9DOQahtJsqfEmM1ona76R/4/uPSvYhU/WKzKxJfJw8ZP00X+L4CbkMtd67m+FNvwCqX+oC6CZjRg0NjrcniYNJM50pp1V97vYQAx0dwfWi0aqU0zwuxhXY/hTIvGtt4KO14v3RcF3oLaeX8Ve/uI4VfpFOb4gKVtiFXtg2Xg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713295721; c=relaxed/simple;
	bh=hYTSqUgRfqUZXkZfq15VDFfWb6bKqqLnp/HiTQDv42k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=s360Kmzic3RPwqF7Sn001Hjrkh3CXSoL1g2pcfi33HYZiePHX6abW3ZK3KUUVtXxgYDYxwqIBitqKDjOXhEypixpvFly6MpLvNnNg/udXwC30OaXdg9qlmvCifl65tL9rLfZLbUt+lg2YatRybB4qspqNgre7CedzVt+ZN7qvgI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hikEl3l3; arc=fail smtp.client-ip=40.107.92.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hikEl3l3"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gng72XtWHkxhn4JWHlws/9Av3sPLuMvyRArPVwalE14afSwma4spLCHzM8DnW2iMiCXUwNpV+NFmm2ukT/Jtox+3psxBfuFlB0WVjbnq2ZqV6jO2C1aKWKYoB8/RpoyG/bqKGsgRsa5QnTMjVcp7hrur0higUIovMd+Qq0zwoAeCB/0uESGXjl7WGxyAyEmFUtVC2+J9kTxyIPEi91PhWMmjgX7mErs+vES8/lm7SNNbJjls3rnceuGigmcXBdA11cVtHK/tF4ijohQ28HCJXMlO/TcNeSY61p3i5MW2yaFFXXaTHc0KxD29aOZrjAhzPlX4oKvdjQKpE8wz2BzvfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MGJWq/IwWubTSvQESDQ2LoocBJQ+Q/Eg0VdRZOpSZ8g=;
 b=cEp5h+4mKdW41eMHJGcTpFu6zJLrDYW3QhJFdhYgNzXova5QXSvARU+5WMviSqugXiUU2KHUNL04cqzPt6DVJ6W7l7q8d2VCgKv7/ag+7Sjmn2LdtOVneLYoJRuKKpgHan1bcyQCjphAO2QlhKSwz/s3IKxj7kkwtQMNMptIZdomKyIWiTxCkk2MC+pogzTCIDEFQksWyiVF8fjXLHb32NFOG1K76vTgUJU1D7cLdHHpwtFgEhsUEELUaa4wHYl/wW0f5xMqzb22U4zKM4mtgEXGl4FsBYzVHQnpvpUmLGfQZA4Mmrs22mLsSY9YmQ37gYDFdvkZHTuJ95miiT237g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MGJWq/IwWubTSvQESDQ2LoocBJQ+Q/Eg0VdRZOpSZ8g=;
 b=hikEl3l3LE0OciBT9BmfzmWejI6DSLqbODAFBkDDoVrrssGDxyyYBB4ceTtDX7mdF74S11Lp91qNE7rwkVD6ijaBnL6TynetE6aBb3OCoZ+wOwfWEWY4seethFnLqVWLCPEWR9JTxgEoUFvF38GKkvHkbcCktqNiW6P6Fko7mbEPrvYSSsEG4EhQ+r8h9Uei/BqmqIxqmUXqs24ixP35k3BX05/WPdunvQMy4mCy2T6mTdW3QEEr0RvHatWdZlsORohYZ6DFXNfVqAlJhXXI1EJAYW2d0n9t2z5/Co1nCSUBsKywR+OTb8U0NYQcKJTnFsKEkTskmu683Bwy+K/8pg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by CY8PR12MB8213.namprd12.prod.outlook.com (2603:10b6:930:71::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.50; Tue, 16 Apr
 2024 19:28:23 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7452.049; Tue, 16 Apr 2024
 19:28:23 +0000
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
Subject: [PATCH v7 6/9] iommu/arm-smmu-v3: Allocate the CD table entry in advance
Date: Tue, 16 Apr 2024 16:28:17 -0300
Message-ID: <6-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN6PR01CA0004.prod.exchangelabs.com (2603:10b6:805:b6::17)
 To DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|CY8PR12MB8213:EE_
X-MS-Office365-Filtering-Correlation-Id: ce4d2837-2eef-40cb-271b-08dc5e4b6070
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	scfsq3rf5sZtTM6uj0KT6/5QNQDqCB+IFBu96USFwFzz59nv5QSUiDK0A6H7wWjQZv6FCdsxhh6pMKPdmA0af8Z/ZoUIka5OVXtNmlfKW4FGYlc2jfNfspCMSQQHO/B5u+r4rJmq/aiZkaAo1rVI8AhHgCAIcOXE3bVF4Kug563zKLo9uX+CQG+ngY4/m8RvGrc/ISMZw/1vQxqQyqHqAMNQUz+QnYTCXXnF4YWrNtRDmZUgsBjTKp0u3hyauYvgQNLHNDVIr0YXlC5671UY+8YXfshqzqlCAlP5oxqZstDqA44jN3jYYDy+aWdxA7jaYIE6PVCQ1B2YMbS0eJWZmabMWFN5E9ce7mI3fqk8F3/HDQLE7SlNvPITsmJH498of+DdS2hUw6wmM0+m5oyzEQ3VRGcASmHQ1rUXqB2AlUJY/3I95siOf4GBol6GZvy0RqR5Ybl4/Hj4TcJMYHx2evy2FVVrwU3MwpbF9zQoyqPueiuEL1aJ/nYG/FTUiS2mnvEpvU3Q7V0wC3oPe8H4sM3cDE9KVh4JAbNzQlZE/jxXhcm8vLF73FxnOSEbbRHzb5e7Yi+NCICYenNoyGqPwU5XrBPChOiS83TMPhJoiSNrtSlRECRGLq2deE5Oe+310IHeoDdz38UI4visar5+NDsUdC82M05qTeDOCDh/xN4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?g3ONQZFpyXDGQ9Ckptiv1E2Eg+r5N9yrF+mSCVL4kbyfGT75O9qEGVHsFEo1?=
 =?us-ascii?Q?qBeSlS7h4gcxr8LIVJwxtTD7Xz2FA6VJZs2/YF8MTFM9MR7fbXpQgSR9MuHw?=
 =?us-ascii?Q?xEeVmh6rjJu+WFJRR3vk/TV47CYG/yRDPq63eLXP+At7AZ5vcAQ6sUASYnzF?=
 =?us-ascii?Q?2HzuEDZ+p71GlAReGwTHQCLz3juRsJDEpkdQ/wVfFQzRNf4pdovO4wBXWIha?=
 =?us-ascii?Q?pjJ+6lckgs8/qYsuJejHqY6l1fF7pS95BrZ9GS47MRac9OeDHq9qLgMBlmqf?=
 =?us-ascii?Q?iN8LhBm5GEp7xt15zzkpeUot9ciquTRF27EWjjGLZDjAVd4eYaith+A55Ih9?=
 =?us-ascii?Q?ImFWzkSKz9OTYtKmKzhdgdNE+ug9M0QNie46ujDEwntsqcDAlOvpecxu37xI?=
 =?us-ascii?Q?aGxpgpHrUYmX90R4B6uNK1rKytudfBQ4tnoMdz6qfnmqUrzYRDWjw2wUy6kb?=
 =?us-ascii?Q?o70yKAUvJr7R0P0xCcCENBwXXe4UFIE/AZed8mATkzBXy+YfUi34iggtG1rm?=
 =?us-ascii?Q?04eFZm1NdOc884kZseOL65UvOY7XSKvu6lcgJ32nNFGZ20ztgkth3SXRp/Ra?=
 =?us-ascii?Q?aDDoC63WaSA2NGCpV9sdxNAMEnMnnpMUy3oTM+d1fAQiF3P8oJjurktoW08E?=
 =?us-ascii?Q?YyG3KesY4RqCCo4YiuSfjFxghFLaDzcfy8IRY0GflqYknGbgr8FTJfM8ePGI?=
 =?us-ascii?Q?ZdQNFGT3tni1JPV5BG4nAxiTkRMC97umMUGb7MBSYtsMf0tMWB16XaFDS9Ay?=
 =?us-ascii?Q?cOckxc+t6QTZgaRx9ZZsPrBB2Vat765/Qt3yIXztmltESU59kZSktHh9L3tF?=
 =?us-ascii?Q?gv10qZ39hhu6lvs3PdFB034LEaxar31bAjiWBkF0r35poCXl/XfAdKWUEMJJ?=
 =?us-ascii?Q?WQDbmaLGy3937bhOfIKNJIVkUjGaupE/RrAxAk1HVW4JQeWnnSdddiYofEfz?=
 =?us-ascii?Q?Z6gQWlpO9E7DgHxC94vI4HEbKuDul+gwn2OG+MLlmKEMtRWEs1x70y2OdxnN?=
 =?us-ascii?Q?4aWUmP73IDKG8ekxUu9prZfG9p6Q6AeSVMpztb2UQPw4ak5MDx2CzhZyuxQ3?=
 =?us-ascii?Q?OZLiwPA3fRzi+m1ptb1T5NIAelm5PohHT0+KfBw+71G2URTmV2A0ynknLNAF?=
 =?us-ascii?Q?/T3srhmdnh+bTSOkpb7LDOLpPFBwPx74fqRoZ1rrJAycZMqszBUzb1lrPb1J?=
 =?us-ascii?Q?8zYhZo2M+M0OHkhyyrqi/Ie6v07BMaW2mc/bJnO2zwm2+uELBc3oB/aJ8ESZ?=
 =?us-ascii?Q?KrFPn6s8ePOkfW5JwzPLtPaaRzMMmILb9oOGdozRbl9VzCK9XtjlFIxTWrfG?=
 =?us-ascii?Q?t7eWnkZIpiqw7IaIdAJKpw8XK2cVD0TQzsvBS4LxMP8gnHq9ZwSE2pU9nojl?=
 =?us-ascii?Q?Aukoc6hs/hu7G4CzwlzebvVlD1sJIP/efQ8nnrtSb+ZyNIT0yytJ1sooLGag?=
 =?us-ascii?Q?t6nnQt3FackA7OiGEE8p+iT54xhqLrrBcNCbYjeg57IPpsuIsTWzT8nA20tc?=
 =?us-ascii?Q?JIATFmwIqxhk52hlPOHlxUmaNSTLEPyAK9HakTjqshcQHk5xnBAJmRYyblQy?=
 =?us-ascii?Q?Mviyx5o1yl8RwlvYbKC6/I/YnhmosLY8pqYAP/1x?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce4d2837-2eef-40cb-271b-08dc5e4b6070
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2024 19:28:22.1190
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UjOMe/MZDUDQymC3cGougwnuNLWLCRNDSONdTtVzE+SjmE28twa1OH3X2txw74TN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8213

Avoid arm_smmu_attach_dev() having to undo the changes to the
smmu_domain->devices list, acquire the cdptr earlier so we don't need to
handle that error.

Now there is a clear break in arm_smmu_attach_dev() where all the
prep-work has been done non-disruptively and we commit to making the HW
change, which cannot fail.

This completes transforming arm_smmu_attach_dev() so that it does not
disturb the HW if it fails.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Reviewed-by: Michael Shavit <mshavit@google.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 24 +++++++--------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index a0d1237272936f..0aacd95f34a479 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2661,6 +2661,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	struct arm_smmu_device *smmu;
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
 	struct arm_smmu_master *master;
+	struct arm_smmu_cd *cdptr;
 
 	if (!fwspec)
 		return -ENOENT;
@@ -2689,6 +2690,12 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	if (ret)
 		return ret;
 
+	if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
+		cdptr = arm_smmu_alloc_cd_ptr(master, IOMMU_NO_PASID);
+		if (!cdptr)
+			return -ENOMEM;
+	}
+
 	/*
 	 * Prevent arm_smmu_share_asid() from trying to change the ASID
 	 * of either the old or new domain while we are working on it.
@@ -2708,13 +2715,6 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	switch (smmu_domain->stage) {
 	case ARM_SMMU_DOMAIN_S1: {
 		struct arm_smmu_cd target_cd;
-		struct arm_smmu_cd *cdptr;
-
-		cdptr = arm_smmu_alloc_cd_ptr(master, IOMMU_NO_PASID);
-		if (!cdptr) {
-			ret = -ENOMEM;
-			goto out_list_del;
-		}
 
 		arm_smmu_make_s1_cd(&target_cd, master, smmu_domain);
 		arm_smmu_write_cd_entry(master, IOMMU_NO_PASID, cdptr,
@@ -2731,16 +2731,8 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	}
 
 	arm_smmu_enable_ats(master, smmu_domain);
-	goto out_unlock;
-
-out_list_del:
-	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
-	list_del_init(&master->domain_head);
-	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
-
-out_unlock:
 	mutex_unlock(&arm_smmu_asid_lock);
-	return ret;
+	return 0;
 }
 
 static int arm_smmu_attach_dev_ste(struct device *dev,
-- 
2.43.2

