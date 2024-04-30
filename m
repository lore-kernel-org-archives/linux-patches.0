Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2068.outbound.protection.outlook.com [40.107.94.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9215917BB39;
	Tue, 30 Apr 2024 17:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714497711; cv=fail; b=hLRgKxphd3WBUnq9lfGkaKdfW+ecApu6/ELLrQYzySk5jthTTiBght/P52sPJL9L4BSM5BffT1zmDorG6yXleVOhi5T2JYRgPNQIV5V3PaMWCv31vEN6g+KYZH00JX53wmM+xejaIRkJJH8cLlnMj0ALSuDkJ65mrhFQzyFL1t0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714497711; c=relaxed/simple;
	bh=o0oyFegTbtQBKFLPiZgW5gFBLBEVrUWvJDoWJAh2kiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mGkeUgoL1XCWsSxyYIdjFf+6GFa555Tj3A00OrSbNrk6PO1QI8M/C6isoUwSZQRBGiGw8Ilchc8vlAkk3HAPDOMP9eKif2bXjZdS5eXsU0lLmOmeCU/IF5NevGTh7/4Osm5misCourBENHifnkZwfyprBCKLaos0kUcoIvZdQuA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BTNQ2e1S; arc=fail smtp.client-ip=40.107.94.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BTNQ2e1S"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LWNOSwUxKAO8UU3K8Rtsk+8v4yIoXBfHIeJKTnIfna8w6/4SAOMRhpzlVzF8aStibbQaws9qH1EaPZ1hb5zvaqrpZJuXrQLQWRGE9ARE8axv6+SwljBEqf2CISH+ckZ8A8C/qs6CP49HaDoum6Hf782S/Pj/MIM+Er0Ck72a6KVxWVUyOiglRE/iuAd2ailK6m0CDjxCMfW78t9J8xGx87z/ScmFezcu3gvjQWIRkuqW+ymXpPGPqcYnTE14Hgdgv/DMTQFtbDwDMECj1wRwZEL6euNJmyHXecTUuHFANf4dQHw9ii9RgLL48DOTu3z+caQHetsrfzlfbh2+n1pJpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Erk8uyaJedaiNiUmPnCRWPE/PXYm9GKIR7KkBe5beww=;
 b=CKF35W8y7CpvNjUeCfgCdBKb1KN5xCGitHYWv7vPYvgjVU0/Di/CwKwElhibo+vH3IlAwa4GpLA1JPAMPUVXjebimiyaoWPRiHKG2vsF7117AVpCYjXQE2C9wET8S/VYE/qo9DWi+joV17yPMFouKGRf2Npt3r1TJrQjm9J2OH95lL4r3g6EXRC27n0l2iMCw8G6/KCP7Y7/4u6EbDtrF3INBN1YDCdjF/aBXh/4Yo2LT7YLOS4mJZVAt1tzoCSs+KSB05BQmUznLY6EQUxUOzKipLdPBVtX0Z+N1mXy5lPEDhPeg/c1KFAnEiWfxh0bgoKk8axZScDUcpLxe1T1dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Erk8uyaJedaiNiUmPnCRWPE/PXYm9GKIR7KkBe5beww=;
 b=BTNQ2e1SpVUPOZlDJGZFFr9vIx/MnrtFTx9MTdZvxXuoQn2mAKzXm3nPmUwgIKKSB1w661x5wX2MQOw3qKdQzZw0y87G4iCUojr116v5RTEjz+AV9LV6koL2jtMR4hU0hewXup0heboYv0reW0ooH/ygJHH68rpGtumrBJrnod4S4BlrOQO/SS7fq36mhkqA4EUFeeuII1O2n6MQ+KoQ25HTlT7mGXqokaesqweZbqlTT7MWPFJqXEFFXkaCZ5cBPm5csMN/9cA6HLfo70Ymz2BdP4hvmpH99qWm1X5Gv+kdW8DvjvYaik3uHtwotgeqH9tjmygxNi/XZW873axiuw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by DM6PR12MB4172.namprd12.prod.outlook.com (2603:10b6:5:212::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.35; Tue, 30 Apr
 2024 17:21:44 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%3]) with mapi id 15.20.7519.031; Tue, 30 Apr 2024
 17:21:43 +0000
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
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v9 6/9] iommu/arm-smmu-v3: Allocate the CD table entry in advance
Date: Tue, 30 Apr 2024 14:21:38 -0300
Message-ID: <6-v9-5040dc602008+177d7-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v9-5040dc602008+177d7-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR17CA0009.namprd17.prod.outlook.com
 (2603:10b6:208:15e::22) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|DM6PR12MB4172:EE_
X-MS-Office365-Filtering-Correlation-Id: 795f9bf4-a842-47ab-1268-08dc693a012f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|376005|7416005|366007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ea6goo/l0ry7WfFidEr8VxYCdnuGMEMa9GxVXIylLIu3YikaQ1UAZOrH6jAn?=
 =?us-ascii?Q?jZV6rEkQJ4WiyRBl+aJ4ig43sLOqcjAMaYjw1CF2N57RPoKYVRfuEZSmG/lX?=
 =?us-ascii?Q?OQhGjBJqdvHmVTFKmJvfWBxIym8aQuayDf/HkBXnzEbfcUtrwQX9EyKSusyw?=
 =?us-ascii?Q?x6wMYiKQGHczKIN550MkHQfMFDUmUHSfXBz6+BqkpMZBjj2pZa0i8re8dh2E?=
 =?us-ascii?Q?9JQbz41r9bC9ljkZf4tF5VNDKXM73B9B9+cNDXLBG47JOydti7VAIcxaGIfc?=
 =?us-ascii?Q?Uk7dgsw7SRcB5jDBNq/kYyRQtxZN32u33yxZ2VISVii2jtPJWZ2rWbq4u2+L?=
 =?us-ascii?Q?84Ioh/M8X40PpSZbAkCHg+atRj/DL2MSFmUVzeBRQPmwlk+rFgnBsQz4js91?=
 =?us-ascii?Q?DY2COPesPDu8zUyJ9lPhBhjInojpqk8fgPKcWwOGfUxjKP8XVNjNV/XFLBNp?=
 =?us-ascii?Q?5H9NJXjFewB35zIHHaxgTZQqQalIFHdkynN6sURiKhHGEsLaDfxnkOzCgvl9?=
 =?us-ascii?Q?h8Li2Y1OZHLw4fmxiP0O6oz/3zJ/5abd7ckB0+ZIXxye1TqsLkkVmNnh5+kn?=
 =?us-ascii?Q?5Ox3YgAU5zO62dBAeCrLUMp586iUF/D4WNupsMVE0j0YeFvbYCOJtAX6z36L?=
 =?us-ascii?Q?1V00V37lRS5FQc2wd4cBFp5d8WqHj99iPm0FMa7xI/Bt00/SYHywoSI7pFZy?=
 =?us-ascii?Q?JS/YQ9FW1OpMmLg1N+HgXPQxrO0SyT2wCM2ESoLjPBybDc223ZXGgHBUQw0h?=
 =?us-ascii?Q?FZvmt+BCkAoFLGzVzEX2EjjQ7iatTF7lEOw1Q9JWlPa8YBaOuY7Z5pmUL379?=
 =?us-ascii?Q?I5YaczfUKVEtZp7hfo0vNG8lJiP3RYcXJurEC5Tf45z4OKOqdS2mWW7G5/zY?=
 =?us-ascii?Q?1iaxRbgAUUavWRo7ZNXKP4tfoLsGAWO9H03aDAa7/JqE0RkTx0219OGtv38E?=
 =?us-ascii?Q?A7QAoBkf0eBF9sGJleK4fzpj/TG76DxaQaOzdHYXhtCTlJwxUGL53/z5xU4y?=
 =?us-ascii?Q?GUjryVFvgqR/F3sWRTGgHNVyCOKoCDAZl2P9r8/zFjpp56Gh8vcTbIl5ql2L?=
 =?us-ascii?Q?dvbqibs7qFYwzvrZFR1rgiucZ2fZlj4zeZHBa1qac/AdGmCAkF7yUr4C9Q+3?=
 =?us-ascii?Q?KfATvnY7EqpIvCBHTZzJc/HM2qW6vzPU3ZkOAXEH5ulKGj35d6EWRJ0Mg1aj?=
 =?us-ascii?Q?U8rJ5QgnaCdUrxNaawCSzt+E4TbjyeWIZu9ScElLsLzW0vKU5eTZNh86bdYU?=
 =?us-ascii?Q?VtqHaPdFiCXyfXBmycDRSFmZjZfHzisxuSJeVB07sA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(7416005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bmeA4iOJ2lP5ERL+WJCeOPno6zrevVDeAikmpUQcKqUqSLil6gR2QMy/rA+1?=
 =?us-ascii?Q?8RQxliq3cUrl+D2nzmQpnTjKTl0DUiT3CQafO5PgsXey6LqWKBX41iotZcLw?=
 =?us-ascii?Q?TInc3Ya2cRdhf7xUkjBftqBHHd1WYJFhyg8IhknbkMr/XiFi6D27tXubce+f?=
 =?us-ascii?Q?NcMgTQgZd8v+a+fLV0NjG+eoKVgE5tY6dan6n5lRWyz7/jG6bY1MTY8d1I91?=
 =?us-ascii?Q?UeBe5YXsstNI/XLl3aS2KIaYZIsudLv3xZ3CkAWCaFrQQ1gDxmJITFEkO4Yu?=
 =?us-ascii?Q?cP6kYDVpnp6hFkV3KN0HolzYr3/EAfe0b0FpPyPYPVcuGNuMmo1c+RJjsp4r?=
 =?us-ascii?Q?K3wFI4j+JyPQaVghw7c9oBYCFL2VTTvt3L7NzAb132HFB9FlBX0iabKFpvpj?=
 =?us-ascii?Q?6ieS+9P6+nUzId4H5ttyNfaVUa6t4l5nK6n+QFleYQt1sAMGKk/4i8Z0MCYH?=
 =?us-ascii?Q?kU2A8vAOdvK0YLWG1mecnH5Dt6/dPWylKEC9ER/4Znk0h4tblCEaPv9lj9Xe?=
 =?us-ascii?Q?pHI3bwNJLZr9gcBaYxjih5FyYuw9mD74gCakzN5y2DM60qTrTeRi/fSkhLWX?=
 =?us-ascii?Q?7Mhk+MbcVWdGK9klw3+XzNfigt0rY23iQ3NUeNMZrs4HnBZAh8HbMFnw9AyM?=
 =?us-ascii?Q?ThxJ6uJKqR6NEBM/wznBou8RoJbRw3gVc4HWxzRSwN02aUDxzgnrFpzD82YE?=
 =?us-ascii?Q?uXlpTMmy9geKq5AhrS/2t/9Q6QAuali2uAK21Prw2q81NiHjt92P4pIlPRdu?=
 =?us-ascii?Q?+MK+nOs9G3dBZ0/sEaF62ryAGSOdi2CUDMrdS0L8SGSrHtUbzmOOb/l2ogSM?=
 =?us-ascii?Q?nSUZUfRqCO3Zy4sJ9R7WwRaz+HvV3weKxlRp3KEDEYnMXiy1KurGRYK/k/A7?=
 =?us-ascii?Q?UnoQkofgBST8HbPEtHIIA+ku+ZKP/GIl0rF6A6HUTPZYCyyGzYCM1QwTV5BW?=
 =?us-ascii?Q?ND0RdMxOQblsG7kMubtL1aDlRkTp5FxYUmt9Xvsq4+5gh+JLI5fn/6sIW49P?=
 =?us-ascii?Q?y5Z4ntaj6X91VhfOk42ZQRnvb3R+skPecbAVRTCRHTUNJX1aKfI/mIxR77cC?=
 =?us-ascii?Q?9ClO6VdVtw89zLyKpENF4cNVD3amfHMdISnISZIW6by4qMxLyrfJYSFNveef?=
 =?us-ascii?Q?Sreh+3vuuAgdE14ufTBLPKWkLIFH2YdALhYL9y/RQGFLVVxVMwMo4pmlbhD+?=
 =?us-ascii?Q?zZfYpZDLoCMlgquL9QEhsV7S49cY9RnIdK1EaHE2WH2qXJSoYlSMC1jLZe1H?=
 =?us-ascii?Q?0bx99wLTlmbfUPMk1kTYgXTljFd7+Czwd8WgdGsIHm8MTuE2oDkm7Gg15a+E?=
 =?us-ascii?Q?oSJkhAynoaLrmUjUgP7hN2/XSnEuUvZ+KZ6X0/E8qdnOHkkLtReFuyZyD6z0?=
 =?us-ascii?Q?Nxa+M42vrKJKuCUtZBCUtdi1UaHKjQWsyvvNeLBSXWwPBu0cCqSYuIjvpNm3?=
 =?us-ascii?Q?1TrmsNDzddzk1lXYHZ8o+YVxhqUJ6mNwfP3YnGaKf0KK+BsckDCr6VIPVTdl?=
 =?us-ascii?Q?2z/W5AnrX4sMCbZ8OuyBqZrxECjLP0372dn1MbLvnY0X3de3qGTv3F29mv4m?=
 =?us-ascii?Q?dMUImB8jLAkymm8K9PB/5jOYmLuoO3ljG+LFhipO?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 795f9bf4-a842-47ab-1268-08dc693a012f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2024 17:21:42.9652
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cc9GXGC4E1BzlzaKh9jP2KKGngucn0nWHuvN6s3vm6buBRSOS6H9nAxnuMoo7FXd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4172

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
index 7dce9cf52ee37c..d0ab49300acde9 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2645,6 +2645,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	struct arm_smmu_device *smmu;
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
 	struct arm_smmu_master *master;
+	struct arm_smmu_cd *cdptr;
 
 	if (!fwspec)
 		return -ENOENT;
@@ -2673,6 +2674,12 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
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
@@ -2692,13 +2699,6 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
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
@@ -2715,16 +2715,8 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
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

