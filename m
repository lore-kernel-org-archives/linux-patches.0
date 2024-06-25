Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2050.outbound.protection.outlook.com [40.107.102.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03C3A156C68;
	Tue, 25 Jun 2024 12:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719319077; cv=fail; b=a5mouaPQ5UeW5+q95855WGdtHVt03zIewMuxUgwxW0giu6Kb7fNV8wJ6HSAYsHL4a4ZyTVgT9bHu5DYrI94iiMJ1WB1MX7YskEhsx2IxSBC+fhP6YlGaWL6Ax36Fljz7W/uC+oauQahXDDSF8rewqRNN9bZf3ZEywyXzn5dSsmk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719319077; c=relaxed/simple;
	bh=r1rtOmGeYXVFLJtyWjpNXRf3qdXkpAmf/VfMW4gT4DA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gyOZMAzJwtdBHxQfET9uc3yX7YXAisH8qsBwqudhuyobnRxe36PnQPlYmHKKf2FS5/j08+FW+SV74zMbmWdFmXCjtsaAuoWHJLWsL6cPF/kaXg+AAXeeptIK1vh5ZgZwbe2O/7nL00lH3xUzuYYrJb6TfUuR5v28DaZcO3XTHPg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=HtUitHIY; arc=fail smtp.client-ip=40.107.102.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="HtUitHIY"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iF3j/UozLAQVV4nZsJZEVeZ1VNe+243lCEDoDMDAlAmqP3qBX3HpYNWKbak4EDFhTdPaMXHBVDa0VtDB1Ff+gNTc8eatoXJR9nBkl1pZhqbW9ZUOgSIQRRv7ctmRxNzxS6fBB8iRoXeyRmhsZwb9fjb+2Xz3gfHpUErCQoRL2AJOJ/DFN7iMzzHspsGJNNr/jEry5dzmjCVBZTtOps7Y6VsBxwAdGH5I5NGIbql8MCa6pxIHTk11gnlXitI+tYzQup0OzaEyFUifk4K6o4jyh9PaIZegjH6CCAfdg6n5/Zy7eC14dpx42HCuHrOmVMYWeLUvhmP+PSVoJc7kgbEtCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+l4qD+mKFXX4MhsIh9r0N1HWTEmP80OD635uvKRa8VA=;
 b=D05YVysICTdTclhGiiQmcI0WwnyXszsLIjNoMSHoHA7Y7GjCMEtwiafxpoaeF5eLX4f8yVDWYJxtyqcEHVU2knj+JXCIOhhsWeP9ZYvt37PGfHDXMk5wHL/2u1744uQ7zn9iMoMNjYQXYYbqW6l8z0KFZUwQH3W+e7ESzP6fzU0yHIRob6dhYX0Ih/8gx6rd2nNeFgZFH3wm1H8g7W779iTK0qmilGopDWFixhZeX2sfalhyPYA9AieD6euFwnLHJQ/OGP+Wdw2Qw8JcPqDCR6Z1LNW6ptdKcrKcwdXTBJvzBrEWQ1X5Mhbg5u+VsFnDHzZRboFAAOjWtojSWyAA6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+l4qD+mKFXX4MhsIh9r0N1HWTEmP80OD635uvKRa8VA=;
 b=HtUitHIYSwq2eUr/n+iYktXzdPWaxpoYszKeP5Sjbm6KdU32lH8jZKwJty/ohNH2yhZ7r1o8UOofIFuF0l7KKTU8gpSGLlrG4eCBLXt9/MtpQPL64m5ymNo7RcF143CWiLM2EOHniXl3Epjwm3gbZAnS9ycOz1Uk1ru9Zbnc5uSKF9cC34ZVKMjx3FbFo933FSyUpKr2Yxbic+0SVZlLA9dAuuJPNWR0JkYN2vdlBr+yISu87+HklAuF4VGmALAqYC0HRu5mOjiTOxGXXQa2EAwYiGgpqMqX0120H4Ec2s8PQDXyDF8lJPc25mLdQa0XX0Rx41yJCCB6mMZWQsrzbw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by SA1PR12MB8946.namprd12.prod.outlook.com (2603:10b6:806:375::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.26; Tue, 25 Jun
 2024 12:37:47 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%6]) with mapi id 15.20.7698.025; Tue, 25 Jun 2024
 12:37:47 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Jerry Snitselaar <jsnitsel@redhat.com>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH v9 08/14] iommu/arm-smmu-v3: Make SVA allocate a normal arm_smmu_domain
Date: Tue, 25 Jun 2024 09:37:39 -0300
Message-ID: <8-v9-5cd718286059+79186-smmuv3_newapi_p2b_jgg@nvidia.com>
In-Reply-To: <0-v9-5cd718286059+79186-smmuv3_newapi_p2b_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0171.namprd03.prod.outlook.com
 (2603:10b6:208:32f::31) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|SA1PR12MB8946:EE_
X-MS-Office365-Filtering-Correlation-Id: b8c1121f-4a81-405f-c886-08dc95139dc1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|7416011|366013|1800799021|376011;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xRlVkEDqdzMedYf+mMa6WWdZEA2EMZY5VKBYCbO8bE3TqYL/b6ExTUtgN3OJ?=
 =?us-ascii?Q?ZvrkdhGSQxARE0DRErBaN9RHcFfUtjGOs976hy0ozq/ntQHPKIZeA1EGA7Ce?=
 =?us-ascii?Q?2beLVLD1JXaFTVSvr3vaYBicUPrUHKzWtI6KjljuJ2VO5Sf/eiLt07QdjP2K?=
 =?us-ascii?Q?ere9Z3HBl22gnS3Y9POybC8fkjPNrXdJxdXdwBj6k/k1jInau2+Z2v7YpS3U?=
 =?us-ascii?Q?QJpZ3BRx7H3MGDlTdRh5ogMWoMa/2pHJjj4Dyb4/nzlk43XYMxlA5LWdYbMr?=
 =?us-ascii?Q?Z3qNdFe/KSA+PZFThGnrH8jog6a9IQn/ZBeGt4+rBh1YXcJKobfPpIn6I5Ve?=
 =?us-ascii?Q?yyZiloUmcNSQZ3CR3pANUzSFcFGT94a0cq+aPvYqsKhrju1gIYy00Uq2difx?=
 =?us-ascii?Q?sZ25U1nW/mcL9nUfXLPcz1lhlDpiZJTqfR/DjXu4PvGCs8J0uCclLsDZChWK?=
 =?us-ascii?Q?a14nIvcq/oarlX6nea4xMZ9FwnDUWpznTTSKRdeiEZNfT6SXgD8/GpY2alYf?=
 =?us-ascii?Q?+djqtPxzTMpT/3NrHtucho6pIypGolwk0Id3wb/omd2IjNgGVIl/gV4pc7WN?=
 =?us-ascii?Q?MO0jyzsyyranxyrDm2wncR3Dvpi/EBy21hXU94jtUIu6bfRuwu3nR6DWTnCX?=
 =?us-ascii?Q?tEN2WXp6xCvQ/Z5gtNW0QObVVDA5ERXhbBkmTzTHJd7Tfmzp0/qHzehDxujK?=
 =?us-ascii?Q?YJbYhCdUQicuhTnQhYqdShMxlDc9u2Y/QxrwJxV4o5kNyw8HGmAScsn8pgyz?=
 =?us-ascii?Q?n6H3V2wSlU2rSijoNxTuTpEQt7v7vQwdxcDLujzDIONL/8zSIfQGAQaXSbGy?=
 =?us-ascii?Q?hXTabRnlZuusnyc40SZbTYlCtIbP/2cBT3gBNigoK4LJUXO33vq9PMnUz8c8?=
 =?us-ascii?Q?VphunzB4XPnYZ1eyuh0tSfp97CPTy4GN7QYKZDtgDVqCJ2Z1rZRuNVVoFIQ1?=
 =?us-ascii?Q?mwbvSDKPM9wq29N6qxiDKApyo5lJFwykRFsku5D8W6zKFR5KFkdojcYOaX31?=
 =?us-ascii?Q?iqFKaT4GH66+fYdlbI0rJacyXxZg7JrACkllzttDe849ym9eie084GtTYpVJ?=
 =?us-ascii?Q?mgdhkTku0HTXlh3JIqt8bSEcHkBr+BELPJ3bkQRWCqwist610RH6FnrKAuKk?=
 =?us-ascii?Q?+zjdClpi0ro3WN5TGXE/B92M9ySh5GZpMoaJAVx0XVzhDgS+Yy5cBh+uxpzY?=
 =?us-ascii?Q?FGtpKVxllXOcTJn7f8wooTrE8oUMDpSGtlT4mKeVDCJcSo/ZyHwtJ9aF6LLd?=
 =?us-ascii?Q?5uN9753JMSCq2jJTu7AZW4nPQKZv03F51S3+JCC3YTqhlZH455oV54oAEOWG?=
 =?us-ascii?Q?AEg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(7416011)(366013)(1800799021)(376011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3ZEYPZXYv2k4vJhkxG2+OBZXeIwH4e6fq11N0NQs6Rux6ZJBCtIIcLw3T0NC?=
 =?us-ascii?Q?DWTLh1FzxQwpJVJDAHIHfY7C6C8badAckyV+ShD7gj0Rl+Uy3gdsQiT2vsuz?=
 =?us-ascii?Q?bogbSOvEt8+ExCcnQkGV2KH1FrJWkW/rBTr2pIdtdoXSYZw1S+2BTGyvTsG4?=
 =?us-ascii?Q?yACyiCeHGMjQUsjm8C7tMMQUpUi6IiujtfojTgCW3mGuMc5vEWMW+PAAOZLI?=
 =?us-ascii?Q?s1Rn0LdG9VRQiTDUJNpaNj6izmq5vRXt+rDJCzGLayD8IaOmbf/jdjiGH0q0?=
 =?us-ascii?Q?XPvKEeYuE7Nu/VjE8zARU6URqfF0F/Yi8KZRrzHTUs5bOMkyyJQI6P9ZOHKK?=
 =?us-ascii?Q?PC/cYbSoDcO7ESoJxSBK2DQYpsrOp2PSNCkycgH8Ql7bLzpYe60eeYoZTdWK?=
 =?us-ascii?Q?AXl37JFAy3qX89/NLKDhMOgPV5SQTC48ZA5OhfbHnnn710rqDkcGhwgUiwtR?=
 =?us-ascii?Q?NQ9bOstSlrhP153AjjdmdTyBlhXOWQIWJc0FiNYRQiuKSads1b7vt7Neq3vO?=
 =?us-ascii?Q?ZIgYeIxu9i0r8xGHduDZ7xKKVVF4++MyW3zAvxvzyq7t1AIC9P69+z1nfPHU?=
 =?us-ascii?Q?nQQ++3u765u1xw4EmelztJNpACgpkk8W2vz2LH7FT9TWtx+XfIoSTL0DXmPb?=
 =?us-ascii?Q?PHsGkdaefNaZXg101DNtiJUtcOpDRR7wvAJphq2IlSfITQoVEUMsieu+sc4L?=
 =?us-ascii?Q?lrOgmFq00bFR9sNnjgXEHuE4FhSKD+34zqbcZSzECvoeIfr/gWpoc6aNH4sq?=
 =?us-ascii?Q?y6+UGlMmmpjUvPIw7KIGEKZhYP3agjo2JqsTc6XwF/a5Q7Ws/CYes8ER7QR0?=
 =?us-ascii?Q?AgQuIo9IVjsgg/BNE+Lkd2LtgCuRrPPC+Av/N7UFFb2GxcdE536I7Sd7W2wO?=
 =?us-ascii?Q?UXfL0TGmGByPMFFvlu+dYhoNe15GJWjI2/n5LCDZ5Ca+4LUkHQYi1kzXOw2O?=
 =?us-ascii?Q?d9Ruek+1Y+A8Bz248sJ83dszpZ8ZU3xacL/6Eq9S+Fl2p+k9XjDTA2jxp9MM?=
 =?us-ascii?Q?vFUE3dN3gUGLU5wgv9mHk9HhlhzbPiZQLOYEg78l2Cpbj0bDIZUletWb1tUX?=
 =?us-ascii?Q?wErajs7NqgEeJPrPYbm9hWD08E8O6EwZ5Kgv6L7T6wVqCGM5zQSNsTkO1Zu+?=
 =?us-ascii?Q?6EoykJd4NxcajmKIH4R5cWbUTdCUZBDl1iNDXXSHO1qR4IUIKLdKVtWZUcSo?=
 =?us-ascii?Q?LE6urvDK575s+vh93vdCeR9iAivXSEpygrsBARJ4t7SrjgmgIfII+B2NMcHJ?=
 =?us-ascii?Q?9B/nMkgxHvo2kErjW1FptiXuWssEKCysOjy9gL+WB4PJqmO+UDyhkFpMbxVZ?=
 =?us-ascii?Q?W67gHPJ/ZJOTB2Mvqom9fb7x6x3TKMpAqkLJ3CLeeyMRK/jkb42hXLQo81CX?=
 =?us-ascii?Q?m+NkwmDH+cFQIcxEmZTsD10PfbbiyIRs57lSxBpG6Nah8if+vU1EvxIlE2/u?=
 =?us-ascii?Q?A1PFGUCYrW8T7nKd5aKdNfKFbo+pZbWoP6N3WT2h+r/JvegMudwizAraVqCY?=
 =?us-ascii?Q?/5+TuqTVjQamBI+wQLlJ6EOn8YZDFVtPyY8PkjsoFMcXtyAeVsOXmYR+kW+S?=
 =?us-ascii?Q?USdmgF+zj3E04l3IzXsamNx/GbpYS81AxqvZEOhP?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8c1121f-4a81-405f-c886-08dc95139dc1
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2024 12:37:46.4248
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HkfgeLe71cMEtG4D4foMUx/66NA+LKjoCZ6m/CQTKlqHB1r+q2cuzmtReWjrIkO5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8946

Currently the SVA domain is a naked struct iommu_domain, allocate a struct
arm_smmu_domain instead.

This is necessary to be able to use the struct arm_master_domain
mechanism.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Reviewed-by: Michael Shavit <mshavit@google.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 21 +++++++------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 31 +++++++++++++------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  2 ++
 3 files changed, 35 insertions(+), 19 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index d31caceb584984..aa033cd65adc5a 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -639,7 +639,7 @@ static int arm_smmu_sva_set_dev_pasid(struct iommu_domain *domain,
 	}
 
 	arm_smmu_make_sva_cd(&target, master, mm, bond->smmu_mn->cd->asid);
-	ret = arm_smmu_set_pasid(master, NULL, id, &target);
+	ret = arm_smmu_set_pasid(master, to_smmu_domain(domain), id, &target);
 	if (ret) {
 		list_del(&bond->list);
 		arm_smmu_mmu_notifier_put(bond->smmu_mn);
@@ -653,7 +653,7 @@ static int arm_smmu_sva_set_dev_pasid(struct iommu_domain *domain,
 
 static void arm_smmu_sva_domain_free(struct iommu_domain *domain)
 {
-	kfree(domain);
+	kfree(to_smmu_domain(domain));
 }
 
 static const struct iommu_domain_ops arm_smmu_sva_domain_ops = {
@@ -664,13 +664,16 @@ static const struct iommu_domain_ops arm_smmu_sva_domain_ops = {
 struct iommu_domain *arm_smmu_sva_domain_alloc(struct device *dev,
 					       struct mm_struct *mm)
 {
-	struct iommu_domain *domain;
+	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
+	struct arm_smmu_device *smmu = master->smmu;
+	struct arm_smmu_domain *smmu_domain;
 
-	domain = kzalloc(sizeof(*domain), GFP_KERNEL);
-	if (!domain)
-		return ERR_PTR(-ENOMEM);
-	domain->type = IOMMU_DOMAIN_SVA;
-	domain->ops = &arm_smmu_sva_domain_ops;
+	smmu_domain = arm_smmu_domain_alloc();
+	if (IS_ERR(smmu_domain))
+		return ERR_CAST(smmu_domain);
+	smmu_domain->domain.type = IOMMU_DOMAIN_SVA;
+	smmu_domain->domain.ops = &arm_smmu_sva_domain_ops;
+	smmu_domain->smmu = smmu;
 
-	return domain;
+	return &smmu_domain->domain;
 }
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index f6634c37601b89..dc1d53ce2b40fb 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2272,6 +2272,22 @@ static bool arm_smmu_capable(struct device *dev, enum iommu_cap cap)
 	}
 }
 
+struct arm_smmu_domain *arm_smmu_domain_alloc(void)
+{
+	struct arm_smmu_domain *smmu_domain;
+
+	smmu_domain = kzalloc(sizeof(*smmu_domain), GFP_KERNEL);
+	if (!smmu_domain)
+		return ERR_PTR(-ENOMEM);
+
+	mutex_init(&smmu_domain->init_mutex);
+	INIT_LIST_HEAD(&smmu_domain->devices);
+	spin_lock_init(&smmu_domain->devices_lock);
+	INIT_LIST_HEAD(&smmu_domain->mmu_notifiers);
+
+	return smmu_domain;
+}
+
 static struct iommu_domain *arm_smmu_domain_alloc_paging(struct device *dev)
 {
 	struct arm_smmu_domain *smmu_domain;
@@ -2281,14 +2297,9 @@ static struct iommu_domain *arm_smmu_domain_alloc_paging(struct device *dev)
 	 * We can't really do anything meaningful until we've added a
 	 * master.
 	 */
-	smmu_domain = kzalloc(sizeof(*smmu_domain), GFP_KERNEL);
-	if (!smmu_domain)
-		return ERR_PTR(-ENOMEM);
-
-	mutex_init(&smmu_domain->init_mutex);
-	INIT_LIST_HEAD(&smmu_domain->devices);
-	spin_lock_init(&smmu_domain->devices_lock);
-	INIT_LIST_HEAD(&smmu_domain->mmu_notifiers);
+	smmu_domain = arm_smmu_domain_alloc();
+	if (IS_ERR(smmu_domain))
+		return ERR_CAST(smmu_domain);
 
 	if (dev) {
 		struct arm_smmu_master *master = dev_iommu_priv_get(dev);
@@ -2303,7 +2314,7 @@ static struct iommu_domain *arm_smmu_domain_alloc_paging(struct device *dev)
 	return &smmu_domain->domain;
 }
 
-static void arm_smmu_domain_free(struct iommu_domain *domain)
+static void arm_smmu_domain_free_paging(struct iommu_domain *domain)
 {
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
 	struct arm_smmu_device *smmu = smmu_domain->smmu;
@@ -3305,7 +3316,7 @@ static struct iommu_ops arm_smmu_ops = {
 		.iotlb_sync		= arm_smmu_iotlb_sync,
 		.iova_to_phys		= arm_smmu_iova_to_phys,
 		.enable_nesting		= arm_smmu_enable_nesting,
-		.free			= arm_smmu_domain_free,
+		.free			= arm_smmu_domain_free_paging,
 	}
 };
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 65b75dbfd15914..212c18c70fa03e 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -790,6 +790,8 @@ static inline struct arm_smmu_domain *to_smmu_domain(struct iommu_domain *dom)
 extern struct xarray arm_smmu_asid_xa;
 extern struct mutex arm_smmu_asid_lock;
 
+struct arm_smmu_domain *arm_smmu_domain_alloc(void);
+
 void arm_smmu_clear_cd(struct arm_smmu_master *master, ioasid_t ssid);
 struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
 					u32 ssid);
-- 
2.45.2

