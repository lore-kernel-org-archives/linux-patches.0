Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2063.outbound.protection.outlook.com [40.107.94.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42E0150279;
	Thu, 11 Apr 2024 17:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712855537; cv=fail; b=H6DBAa0vQOaUvuocJkeR+jkQxOs0jRswsghTrrtGpmot9bW6j/OBbFSCrx81r5azyARSHQa1Tut1bJegdLZEF71S2yBaEBgvAKHUqq49OUnepOKG9k2aW3wuF/Y4COYqHJRKMA1QVhV0Rf5THs1lLavxw7tWgLh0KM859/t5cj0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712855537; c=relaxed/simple;
	bh=0mZemMB02KuO66G8xrqjlJKkHi2z9aFGoqmP+3YsRSo=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=r2aWFF1pO0ieOCS2Ynm+MsQV95junAGHFieirBDWQLNxFftpj4evJNPGUW14G+8YUhjFVbdGJwlYZX7wxKWgCKRBCuFO4eTII4F0Ey/P4rRE4xDoxwpjewpmHcPRYiUk5ODhp9TyEcTLxpVv1VdZb5H0S6MW5XXa8t1wB5Br+Ag=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=uFi1hbiS; arc=fail smtp.client-ip=40.107.94.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="uFi1hbiS"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OqVWs59w7ujR90Kvj7lEPWQ6yhhKnhvE10dBDi59kqn4SKzUjIIgFVapGHiu6BsMkv2vvixDT24lmgjMRL5qVxcMiuj3Ei2mGuXuk272wO4dhODu26Z44B3rv0AoR2dg+iSEaKBvpdtlXItJa05qQA1ssmTGnU1fu9NKZmELxtkQRZom3RzCVBvOEPHukf8HhNfdPgHA+Uwc1xxFLvq8nPRrD5apTR8j6gMM06wuKhEx2fFzIvXNJ9mk4AZkx9Lh4hR16pGoxhE78ynHDxEZZTirNGFqZp+PdfIKL3QYyUF4AVQt4mAaEb5kDdLpOtQWgbQRmURJezCqO2kQGM+Mag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XFANBBPlRwq3717OhC6lyhP9YMpUCH/g2z7B5ild0iE=;
 b=T42eGtWfd5uWvZ0jN1wRfOmTV4dY+Ma8iIWY6nmNkFdr+FBqtzk3o3mPGHEjUyT8THT8qmbFQ6vZLg8Zm0O4FIROCkLndA7K+dD2EZcqcMh1IcmWJj+u2edjwMZANmsmvykJHWjYChkFM2OEGYbjJgUQL7QWgaT/D94lkeffY/zyHI+er9wy31tFSZZSLv173FdUjXJmuVhPKizM0wum8QdbFxgMS5FXNE5Mk8LRmlBib5tP+5ZJ73UWJ1bM7I7VRy029IXJ5w0/OiA1+pkzja4G4ixebkDOvwKmD0Yg2XEE++e99xG9VXUwS5QZ8MjPPddyqKEjVL6KkBtwxfulAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XFANBBPlRwq3717OhC6lyhP9YMpUCH/g2z7B5ild0iE=;
 b=uFi1hbiS0ndk7KZF/xLGx+aJ2AibkIaZ22T2+PVkawLq9+hPuANRl6soOjni8oVkcSY+sNs2a9zSVxVboc7gqCFLVjZw8rJj+RbrXfawRLGgl3dbEelat3d5DiRW3bknOiUkYIeTWZztDB5a2l7Y1Mr0JCRTBHim4bbSH80dbBjkwu+9UeLm8pCfPUi+8+jKO9h5lgo7fwhn8MdWnDDhpaPI8sNEC2rh2CBg4c9ckk3FGtz5zlNsJcm1csAC0Bb2FuHRRPCfW9ZTm8/clWtvuATi/PV8FiyDCyD9q6UCNrsZaV+QU3GdhM1mcS5rjAGAi6RSvrvaTocIBOtKML/riw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by MN2PR12MB4303.namprd12.prod.outlook.com (2603:10b6:208:198::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.46; Thu, 11 Apr
 2024 17:12:12 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7409.053; Thu, 11 Apr 2024
 17:12:12 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	patches@lists.linux.dev
Subject: [PATCH] iommu/arm-smmu: Convert to domain_alloc_paging()
Date: Thu, 11 Apr 2024 14:12:11 -0300
Message-ID: <0-v1-3632c65678e0+2f1-smmu_alloc_paging_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0075.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::20) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|MN2PR12MB4303:EE_
X-MS-Office365-Filtering-Correlation-Id: f7cc3d5c-1dda-4efd-d26d-08dc5a4a8747
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	rsKBSNwGf+vfyOg3v+PUI8Job3ZqioyU/V7tZNY7gD6aclHO5FDNs+UGzB/QV8dV2PuY1i255H05CokF2L8AcaJ1ZRBUlmvwsb12lySjG3GB+JkmUccT23ugqU3ZkvTrilUx9F21GJu++261YXGCMiwCQP0tC/JFOwVEw9uo1i9ev6V6OuDHE16eHKv+lseHxi66WbqW9a4fPyAHDZ6YBwzwvOjIsJ4+2RWgHM0pg3dSKOSOoKtovT2sEBz/E66Vp2HD2VHsLXHOgLFDy7wwkOTgJJGq7Io3E9B5gHxHLVDCPtinzgsyw2SG4XnYf0TIy+NhsDKBlwkIpHwpzipYT6rndSV6DI+Bux/it44u5JoWDTdUwJcSpd6zpcoHXyQfByfI969pjxaXU149o0EhiumieM/ZQ7YIxpit7SIOxm2E2mo+2FYWxTnZrCE3lHwmW3SaHyN0DccZwOXrlLHmhf0Mg0/DRxwAnNo5AuI6QnlaOLO6B2kyBUXvbq25dn4FtnrUzgGTUZj4QESWbefxGS36rOQnIO3XszgzR51dRBqt2fGLxFtaF7Z+QYrLLnEPzANHi96Z3uEHu76QfmnvQ6z0sHWrRxtydi2BuC1IYigc4yUT0u5fLJqdFpKhDPVZY3SDbgY9oKWmJIxe+RFwaR8JwoV0SLEoh4Y6L+qDypA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?77UZT485luldKtidhhZT17uXBelOU9bdZCrQ1EDvoDtnC8fF1SVuYD2qA+Te?=
 =?us-ascii?Q?+dVOFzC66OG8TZgTuFP6IzFAVaTTa2vraJrTipaNoB1zCSg3kgg7R1nFWNPY?=
 =?us-ascii?Q?DtEqrrkwn5cviS+jfCGeBPfhpweAFNbU5snZu8DMl7ItD3u1+fb2K3reIneK?=
 =?us-ascii?Q?BSM/Q2y1dait5W8TBgrn4UicMTco4s1YIC8wxn+s3URcLvnwf8Soxqx33/Ew?=
 =?us-ascii?Q?ED8BB/HM+bD2kKwQqUFBMMwpZgLbxtRT4MrMID9+NPF7UNn7fi1cOpkL0eHs?=
 =?us-ascii?Q?zqRvr0h5hH+oq2fRRMQUjyEpGj4/tgo7OTccQbyftay2jON7qDehOKM6hY5f?=
 =?us-ascii?Q?JJ+pWrpBTgiRhypbb9q7NQ+qv7u8abVzsJta/7JjgWpi2BNgwtjGcNp65fPe?=
 =?us-ascii?Q?TwvGaHPFcCSsybei9FPDBr6JAFB168CF1U6Idw79TnRJ9F+Q34l9SZehxUdo?=
 =?us-ascii?Q?AZi3ySgrZLOiGdbi58SZjtyJGTZxWWFWveHQ7Yw7ZNYxlX43uNZHMSM/8gc9?=
 =?us-ascii?Q?t1ZHVjkCH9cOOFZzu6QwIv1+/eH1da4u4Y1lx7Ix8dAqEiOClL9lzOZOMoUj?=
 =?us-ascii?Q?1eRj9Yd+afD1U1FVbxOy8+Yh3j5Byn/w837HW1RXjnVTns9YIVntmqdqQnlG?=
 =?us-ascii?Q?xXQcY7ACNQr8MF7fmc9IUE2f4V38Mcn8zp/IN2I8wHSH4fYgu+ab/dT7D9I+?=
 =?us-ascii?Q?6zOvBfwG7axb2DJQqffZX5EtUEAImlZggzDwOerDfqQzz/iRmOWK1VW0G4QU?=
 =?us-ascii?Q?SYr9hjGbsb/cKpHARhW5n06LlYgYx5VVWHKTupz2BbV63i4Mzc+tuOVXBLp+?=
 =?us-ascii?Q?OnoKqzE0CKS1k15nRQrYAuSojr4vMwbfQmJItku3EX2jo0gyHRMwYmQcQOX8?=
 =?us-ascii?Q?FFjnSF/xPylkr0YWdG5b7DebI82NDSBFiALgBYdxNC9WhNuUO14Td2jqXPpL?=
 =?us-ascii?Q?t2Li45Rm5Mzmwz0O1xozDO0D+Wpmk39XTfn9h7o6gfO3cfBnOpXoNAZM4f4j?=
 =?us-ascii?Q?icq5H8Z18cazuw5NqAFLOZ3rJ3KpE+7XJkOmsS+FHQC7GPzcNh9fKGQ+uKkH?=
 =?us-ascii?Q?ffO+O6JKvM58Thy9+hX19lVUpXfyf8eFArgNMMGHyOS10cJBLXVk/m1DtHwQ?=
 =?us-ascii?Q?JwCoW4Yg3qOTuVu3MfculXaih5NLw17xwHNN1wTj1tmajLpUn9TH+gd7X0ot?=
 =?us-ascii?Q?r/dUXuH72uK7BaO+PQtdWTSXrp88Dryxyf0GwuDb2PJTt9o0Z0I/owY0tkP1?=
 =?us-ascii?Q?Xxw9UTMkEiKToKDv5xcytntnm8nhKjSntIDFgysCzw1xNiIKSpkohGXrBPvC?=
 =?us-ascii?Q?1PDT3gh79CVAVwVulx8H0PimnThF+aYCslO5+1uUcmLOKESRq14/eDN1JMaQ?=
 =?us-ascii?Q?OG7j5E1Seh+WNT4iwSB2XmfycIYW4zhgCZ6TKAlUSGIisHXcNJuf6TctXp4g?=
 =?us-ascii?Q?cqNU4R3uShVA0JFmsLLYnB7CVK61GI0orLvoqoLvZudDaGRElohwuJak63vo?=
 =?us-ascii?Q?IHU5l7IjiUJGQecCsSd+OrHiyZVg2ixmf1XVQxatEbqwMBeRf4fKhzEepn7E?=
 =?us-ascii?Q?yz6+UNJr72+jS140apDFkUGGJfJRom7iUmp/U7R2?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7cc3d5c-1dda-4efd-d26d-08dc5a4a8747
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2024 17:12:12.4419
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4t9dwbdPTkjBfgzkkIvmVMvsJmgoFwf+pD/BBdttl7FLciCi1CzIrK0zUn/bW1IN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4303

Now that the BLOCKED and IDENTITY behaviors are managed with their own
domains change to the domain_alloc_paging() op.

The check for using_legacy_binding is now redundant,
arm_smmu_def_domain_type() always returns IOMMU_DOMAIN_IDENTITY for this
mode, so the core code will never attempt to create a DMA domain in the
first place.

Since commit a4fdd9762272 ("iommu: Use flush queue capability") the core
code only passes in IDENTITY/BLOCKED/UNMANAGED/DMA domain types. It will
not pass in IDENTITY or BLOCKED if the global statics exist, so the test
for DMA is also redundant now too.

Cc: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu/arm-smmu.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

This undoes the revert of commit b419c5e2d978 ("Revert "iommu/arm-smmu:
Convert to domain_alloc_paging()"") by including the tested bug fix from:

https://lore.kernel.org/linux-iommu/CAA8EJpp1wuMgawaUPnQWnhz1k023n8Q-k0_sO6P9p7ixntrCJQ@mail.gmail.com/

diff --git a/drivers/iommu/arm/arm-smmu/arm-smmu.c b/drivers/iommu/arm/arm-smmu/arm-smmu.c
index c572d877b0e102..5935f44e1d1d64 100644
--- a/drivers/iommu/arm/arm-smmu/arm-smmu.c
+++ b/drivers/iommu/arm/arm-smmu/arm-smmu.c
@@ -859,14 +859,10 @@ static void arm_smmu_destroy_domain_context(struct arm_smmu_domain *smmu_domain)
 	arm_smmu_rpm_put(smmu);
 }
 
-static struct iommu_domain *arm_smmu_domain_alloc(unsigned type)
+static struct iommu_domain *arm_smmu_domain_alloc_paging(struct device *dev)
 {
 	struct arm_smmu_domain *smmu_domain;
 
-	if (type != IOMMU_DOMAIN_UNMANAGED) {
-		if (using_legacy_binding || type != IOMMU_DOMAIN_DMA)
-			return NULL;
-	}
 	/*
 	 * Allocate the domain and initialise some of its data structures.
 	 * We can't really do anything meaningful until we've added a
@@ -1596,7 +1592,7 @@ static struct iommu_ops arm_smmu_ops = {
 	.identity_domain	= &arm_smmu_identity_domain,
 	.blocked_domain		= &arm_smmu_blocked_domain,
 	.capable		= arm_smmu_capable,
-	.domain_alloc		= arm_smmu_domain_alloc,
+	.domain_alloc_paging	= arm_smmu_domain_alloc_paging,
 	.probe_device		= arm_smmu_probe_device,
 	.release_device		= arm_smmu_release_device,
 	.probe_finalize		= arm_smmu_probe_finalize,

base-commit: fec50db7033ea478773b159e0e2efb135270e3b7
-- 
2.43.2

