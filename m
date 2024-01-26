Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2086.outbound.protection.outlook.com [40.107.93.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9000720B11;
	Fri, 26 Jan 2024 18:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706292949; cv=fail; b=aag+S8lrhGTVSE6cKzbAFi6w6kFaymbsqS3quhghQE9cMWdvQlOYN9v9So1u2LmBzMuoj1rFVGBqjOSwvaVqsieBBhkp8AAJO8M9aD+1e9QIG+zzbmhSzux7vzJkH9hRfeBKlTCIARgN/298gNQ3D6tTRMS3NsOmRRUpMIsRNA8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706292949; c=relaxed/simple;
	bh=A7afK2PMJMeSUiDvwxCIFvI9xgKdzTomcVvzyuwcCH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XqOyGBQytoGZGkmf83Y0xdAvBtTbhEJ+xy5Pwr/kFDdB4G71tfjHZsfS2hHxH1OSumwNftkF7EOpdgzCMtlxuYi99lqZ+Et32LT8i7OUTME7Czn8+fdsBGI/1ShMPpnKHMpu1RYtZFVoWwRYVnbjDuo4e+9Nw6iHxVy1Mv215Do=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=gx3eAx+a; arc=fail smtp.client-ip=40.107.93.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="gx3eAx+a"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UOwuUZkaaRrQYgaqaucKNhs8NhLguMeBSdgt6sztEvwPWG/o9wCakh6pklsm3JxvbzsET8WOFfXm1qgKDDaK6zX0ixhJA+tAa+lB2ovNaJyTX8Z8FYKztd1a2VR439xvejIGOdQNRCcypRyTu8UUN/g2C0X4jqMaeXTe/YVUErfpkhbu70eMVP3GbAZHBAF1cxfy163midzxEpHPXymuwPXqh1hGiV2kuNrwF7gx4qOJts8V/ABl+4xfLbWsPAqfCKf4efUzNCUfLwmCyrpoC/eqSY8JfjkWjxV39KwxAE9QC1SQcjhA1T9zRY6trNm9ZqDa0jU0tKvoY1XdpdtTPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RG+E+V9Cw7653vTWJJ8EHj5QXr8LZWLPCvwRN0xt32c=;
 b=ESTrA7i4H5bZGKYtUgvaxe+JuGqdix1ue3Ux6LE5Lq07P2qQUo3tRyTm5XTYCnM2PR4WijfgE8ZuSZ1nLv8pTm5dvHMm78sb0X5k7lsq9hu4LB+f4NzfShoJQK65xsGoo7jsBWyNuZBDhHiBg+EkKohQxu7hNcwppuoIywhwnqONdbRu6R/9/wwYELVaWstRu3ndOCR2elNTkT/RcjKLkelzqVZ5IUOvZRNT5bfUXEVW2ZFajzlbTtwxGh8kxqVodNtem0CzjQVnUb1mdwoajYF3YHrfPykilG6N/zgoJobgjEgAB7fq4hOU2ilM4BUjTuwRtmcR3QQilZHBp6P+9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RG+E+V9Cw7653vTWJJ8EHj5QXr8LZWLPCvwRN0xt32c=;
 b=gx3eAx+anld4uWd5udgHNvAiLYsNZuZhSmh6wMHmfJny06QtDRhQ5tAzZDrpv2QYDEtlK1c80gqky1G0NHiKkohiPJBjGMd21lTDgKgDctVXt46AZRlhhh74Qvi0DKSEdFGQZdlifJ1b/HqWXhalFq81j1K/6kjXnEwHm0MNGw1y2Lsaez9vTNyQImI4TSZ2GNOwJubvMjM7x5SHPSIGSJaXeHfuLDcOG1q4QAMDp/sJYvssQR5fSePOrkBrm2rBRea7/pNPTl/1JO2IWOst5LzMEJy9gEi+rHdPFriaZGHB7eVPH6MmjBtK119tlc1xAhZlokvSOwZxU1wOL2OqLg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB7185.namprd12.prod.outlook.com (2603:10b6:510:201::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.29; Fri, 26 Jan
 2024 18:15:38 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7228.022; Fri, 26 Jan 2024
 18:15:38 +0000
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
Subject: [PATCH v4 01/27] iommu/arm-smmu-v3: Check that the RID domain is S1 in SVA
Date: Fri, 26 Jan 2024 14:15:03 -0400
Message-ID: <1-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA1PR03CA0008.namprd03.prod.outlook.com
 (2603:10b6:806:2d3::7) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB7185:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d4b8b71-d714-4598-0545-08dc1e9ac92f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	CdmfPJX1h86R7SfLO5gtY/+njwZG4llxsk1ndGxelNb049SiyuVs+P1JtvwqSPdMP1uyO++/3IwRnqn2F4BDUZoZop+MJE+tt2gWEmjTqkJcHo8Yz/9kkapiZK291+dPU6FHCTwzOlGSIDS9DTKVKOCPNLu23s2kmVB81Tgkqa1F2XUFqcBHz2NPldkhQv7PUn7XKyor9Rn3/g7B6hmZbOmaHhIiUNwgqWjThRUMZ+d1x+ZbA+a+E1SZNmi4kZ7EoIn2b5ufPZ8/j+WOuUtady9959b46FodX0ARATUkkbHgAmkHePfrjaKTILcFHJKejD81nZZflLoW1eT9rrdVOqhqc/aLzLL1nFLBwx9AzlzqLk+WIcmbbbzGAcMyrEnnCLRGGW0Edke08gJGV1y/bavw2zsdLPlceT54Cx2/N2RxGlzvrVGW7tIbVMReSe96sqqQARtt8IkNb9ioIf/xQJQW4t5+XybJAgmfECP7HiPwly17z0QeX+NY2Jt93PCXKnZy10MQyKu2aISh001N7kWYvSD3D+vmWuecEqYQm7Z5EyjTZobYD8EeewBkwISneV3OigJN7gTA6YQKRX1EWMzHl0hYI9Ui93cAA050tD4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(396003)(39860400002)(376002)(136003)(366004)(230922051799003)(1800799012)(186009)(451199024)(64100799003)(8676002)(5660300002)(66946007)(316002)(66476007)(478600001)(110136005)(54906003)(26005)(6486002)(6512007)(6666004)(2906002)(8936002)(7416002)(2616005)(66556008)(4326008)(6506007)(36756003)(38100700002)(83380400001)(41300700001)(86362001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TeN8skbQo9kuBMP8ZqxxFXTV80EEmmqVqVI2nOrw4+Yoq+i7cAVvLi0kshNi?=
 =?us-ascii?Q?B/OguK1+4ZkT0sEGmbKxmKQWYXNjMc4f6yVU+sMMWcJHv7dHmRbF1RgNLJjb?=
 =?us-ascii?Q?Qmj/w0y0jb2A9GTFUwwojeqYfw/4JRx3MHI51OKl67++SlKHJ1m+Y3HAHtuD?=
 =?us-ascii?Q?8b/0bM+B+2TojRpcQ07zUzMp+YRivsDUUuGUGgO5sVUYuyUt/1BUJXTMwI9x?=
 =?us-ascii?Q?WdSBqgG6zZ48nr7EumZcR4Y6ZRDt79TE449rGyuATnJc7tsGd9N82ZP4OTlM?=
 =?us-ascii?Q?dVOxO9if8k9qybt4nuRNeUs8Yv8WyCjNWHpNrjfk9wWfy5fi73YjeYcx9C4q?=
 =?us-ascii?Q?RAAYGCbVc0AY5zzqKXj2toCkGzBsufpllX8IO+Xa9YAswLK8dvz5NiLbuoDg?=
 =?us-ascii?Q?tFwTfUJWsKtyhm0V1cxHqqrZQsJsjt70F4RA3wGhYJ8hQw5kb2bC7rD1Tpwx?=
 =?us-ascii?Q?0vIH18RbMNadyNvXc8aftDC2riQeuQjZtO6DfoZ6uRjeJyJmbht8CLxAHzPW?=
 =?us-ascii?Q?9iAuj++yqLVLepvaJPiYFCezZqBUuYiXzosykmZYes3FsTxXmmxZ1Qv+igsb?=
 =?us-ascii?Q?qqMPYL/KFl/Xaw6rhZ7IRQ+O5YpkWE+gmzn2uvNwpTH1ppB9Tkr6hh4266vg?=
 =?us-ascii?Q?Obb1g7Ra4uD93fJIsydQxkGP5aXPTUvDNu0JzrajHLHqzNGXSTYiDem28Dg7?=
 =?us-ascii?Q?4quQTyKI4FRcOzAcFSht148Zw3C/ISaVVGtrsyvYsQDI9kQZzfsYRUKaotNR?=
 =?us-ascii?Q?jcAPog6kTKbhQ/0yrK8eXkE/Wr9T5Hy9RAa2Sjg14NLHY2yGgFSLDiqhZZ2e?=
 =?us-ascii?Q?o+I0Y6VvNjsYNidbbZ0JT/CK888+g+ZFCdShp/hBclLAPjwoYfuVQ3W1EEEf?=
 =?us-ascii?Q?mwGRqLkLVpX0bYGvB9Uc7MDJ9Q9SRGmaUXHFmmE9ahbv/05m8gaNzCBs/yU2?=
 =?us-ascii?Q?CByQT1dT+Isv26bhOhlMVL9YrpLBDvpKqLsuk9AIxsOzWfHW4qDhLwIfpXcf?=
 =?us-ascii?Q?OKlPOJTcAp8mbCAoqIVdY1XfejS/MVPMkEuO07tqlRn0dM0CihiVdcT8XNZq?=
 =?us-ascii?Q?2TZHdu4xH8gMmJK9VhfXbjUqNpDnEh86J4yCy58NYamY3C1PucEvKTbNx7kA?=
 =?us-ascii?Q?IvNAt+Lf3ssnYCQ2lekJSZVr69hWpl7iDd7//DDXLtyqm7SStv6PbTJmTEg4?=
 =?us-ascii?Q?AO5sd64aWEWMCBDTA9rQuPuQ9P4BKU/mqSsu4jvFWzC1kCv0Oe7Za7380R5R?=
 =?us-ascii?Q?Pbmkj9iOsp56+pTXw7AGBzGIFC4lVDyIMruW37sbV9rIGSPMblh8FGgyVfc/?=
 =?us-ascii?Q?k+m6UewQBmXBQC2xdLUUuugtUw6bo7SNNg0NW60DpZScte5MOd1NEwKlS2ch?=
 =?us-ascii?Q?a5twd1emUXUh52D8EuLTa3vDkUorBk+adQ7DPOGMZu66/Zb9oJXWuU6M0fKg?=
 =?us-ascii?Q?/LxTrpe+bB4lQHO29M4keq9kp7fC4HoFlxSU22zxhP9Mt2Tl1Uo0b7XEbtMr?=
 =?us-ascii?Q?e93JUyqUuZgo605yV0jSX6uHK7VYFej+DnadjWFk8oc+CZLjSB/jg5hpYD0D?=
 =?us-ascii?Q?FJD935GX8dxW0m3KFf7dFghdKayRd4nPbRhNgp5C?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d4b8b71-d714-4598-0545-08dc1e9ac92f
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 18:15:32.9584
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ixlxdMhezFAFN/RKcBWtOqezBnD13AMIwm9YDlS5Qf8WADB4OyIkNELfXPV2wVUc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7185

This code only works if the RID domain is a S1 domain and has already
installed the cdtable.

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 05722121f00e70..b4549d698f3569 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -387,7 +387,13 @@ static int __arm_smmu_sva_bind(struct device *dev, struct mm_struct *mm)
 	struct arm_smmu_bond *bond;
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
 	struct iommu_domain *domain = iommu_get_domain_for_dev(dev);
-	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
+	struct arm_smmu_domain *smmu_domain;
+
+	if (!(domain->type & __IOMMU_DOMAIN_PAGING))
+		return -ENODEV;
+	smmu_domain = to_smmu_domain(iommu_get_domain_for_dev(dev));
+	if (smmu_domain->stage != ARM_SMMU_DOMAIN_S1)
+		return -ENODEV;
 
 	if (!master || !master->sva_enabled)
 		return -ENODEV;
-- 
2.43.0

