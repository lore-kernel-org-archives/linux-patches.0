Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2058.outbound.protection.outlook.com [40.107.94.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A375E8612E;
	Tue, 30 Jan 2024 16:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706630678; cv=fail; b=brXg8uiWmqQ3eibU7Ql65827M0K2X9LAAvXcn+KsRtfwMvCGy95gl0vyk8ma+Nu0RoHce39M6y7saYEZIZPeEmhF8PLemHieER9LCIRb2+JCx5RdtVJYvShtKjVXEOkJ9KGMWPlfy6R1H6LKKhUlQ2usKvD9XAjndsw28t54JrQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706630678; c=relaxed/simple;
	bh=A3pNKEEF7VqaoBvAPesSCsI9M3xENJ+iy6fBf+L0N2k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=EQpnboGc4KXT0uT+vEXQmH2PUNRKiMsCZA2MTMLJTCiSwLZpPQi5IDOxXvNQeFO0CNZJ1liU9zD8QKJWJyzl/Yqra6By0el5RnepBdlq5VYYJ+yWZBi8FaZNRyoxgejvBQ/YBb4xO3DHjQjClh4kV/dtQX5ZHFnlsgjeW2e6llY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=nbWT17ZB; arc=fail smtp.client-ip=40.107.94.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nbWT17ZB"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DvLZDgPM4BhiBaJelWT69DYy2JgVmoX6yG7kcjnB1gXa2y2mdDIA5KSurJ9Xxx7HojL34/Hnp7y9Anj4zJHihujpvzQdCD4J74s1pIL9mHnVHcQfaripJhtKLjSrtJ1l6zcjRr85533js+RSAraF02t8EWXsLqnNAoOe/emYrRz+MVRNokz797AX5WLY87pbM9YZbNfq9JXSLBBct3sz4qozlmwlU8zk5OsTQGhUQalhVD5SzOrvzMvFL1zjBf8cJ3fHSMTbGUAs0zlnG0BAoCIS3cwUv+SOKcbhShX8dNR4cq2WsEoIYCrXr9A5wWw8U+xgXzXcP3cZya5yK5c3Uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+/3pUVzqS1BQ5xK39Tmky5MQ10Iz7Cl+CW2aXic+Jcw=;
 b=kDSs/9fSfFX54s8T4kDFxfQ13oHjHDsMn7lIdwksoI9LLi5q5Ogb45N7L352EoiTBQtuZOA2qwDgH5V1PH6bIawM6RCYrQgZWpCAkK+Ghdf8pkjGRlPmHj7hhybkVZ+7XmF7NKT/G1DeNpL+nnV2mWTqKxNMnqrm43CviqQAFga1idKv+3/dxFoOQxhDmcgTXqoA2MC0GHNN0KQ2nV7bM48rIHTNJXkt5bDfLxKAnkwH/WF5v8cp14tyQVVJfS+PDU0r75xcHr6gyXWXn02xt0eftKpMFAt1tBeKs5AOPaQw2a5Uw413KzIpW8WzlnWlITtxBTxQ/3SJkdPuwrB4DA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+/3pUVzqS1BQ5xK39Tmky5MQ10Iz7Cl+CW2aXic+Jcw=;
 b=nbWT17ZBWRsJ0Bp4DbjhGZ5OyARec3+yRVuYa2Z+9FbZQreYxUzxRMiNau837ZPVQWgNVB5AWEyrqC+EeDikGVuYBT/n5yKiLbQ9yRu5PeBaLKhbSYNHMh5NHI0ZehyPKTFG/qe1/F14cq3r1V9E2Fv3m3Z+x7yiQnUZ6oR0kaV97w5rJkpc0qTse8OwnJ/qbkrn0bZtZtJaXRcaGlVBNN7O7nD8sgmY4A/wW74hJOBqcboj2NfJGNOwzsfRTFltJoIhTl7AnZ/OroeQVe7W6XfQ/UiCwtysWTzJi7UcQAdWIt5KSLFYME6H5weYVVR2NboU2e1vfykrr4EBDXRnsA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BL1PR12MB5852.namprd12.prod.outlook.com (2603:10b6:208:397::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.34; Tue, 30 Jan
 2024 16:04:31 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7228.029; Tue, 30 Jan 2024
 16:04:31 +0000
Date: Tue, 30 Jan 2024 12:04:30 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Cc: "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	Joerg Roedel <joro@8bytes.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: Re: [PATCH v4 01/27] iommu/arm-smmu-v3: Check that the RID domain is
 S1 in SVA
Message-ID: <20240130160430.GC1455070@nvidia.com>
References: <0-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com>
 <1-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com>
 <b3a7b564dcef4b518af0493155b67cc6@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b3a7b564dcef4b518af0493155b67cc6@huawei.com>
X-ClientProxiedBy: MN2PR15CA0013.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::26) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BL1PR12MB5852:EE_
X-MS-Office365-Filtering-Correlation-Id: 40e0bd8b-fcc8-4011-fe8f-08dc21ad24e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	hTi08DFwjWdR1ASY9BLzXy7SK6vJQFsw1Bjn4Rco34AHyLRapgQxEm2j23zMhA0f2pAcjDlx3G9+p/3uOo2KjaCUrI4YXNt+bd9T/mwTNCx21ieuRNE7vEjAqAonbuwQ+eOyDl5Y1LFSVv78byDKQEXyf0ZTWdqXo4JdsgzKa3NrbMu1OH2ZKUP1icjAHpy6e0sgTMmlO38Vd82a5wALHri8H2CQGADHjC5oq0ZxxKP7mFedGw1L+JL2oFYrWE+1RXh+J8IE7PSlXS7pFAIEU6ePavBw2bL4U03opKa7O+ZnKkQpHKCHR4O3VuRA4FHafD7ZKpbJbVm8gp9VIWoml1mz8pmmZflx6Kwc3OA8pZN0103XKvACeC0x6f+3PwD+GZxExfe6YW7+/nyTsX5Vosu+8pWePfjtWTp+39mRcaO1wHaVHbOSbrGgxLDQk7To2q8kM9Gsnf7LW8hknYXSpu3/MpoQ/VHEHZK0FirPzmktN2ZB5hhNxvIMiY5dUuSfx35hYKIM/1W+qZrTBL1BaavgfEV3EHz9mNItaV4vE2reC8K3eCWTKnIB9UIipIJN
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(366004)(396003)(39860400002)(346002)(230922051799003)(1800799012)(186009)(64100799003)(451199024)(54906003)(6916009)(316002)(83380400001)(66556008)(66946007)(66476007)(86362001)(6486002)(478600001)(38100700002)(1076003)(2616005)(26005)(8676002)(8936002)(6512007)(6506007)(4326008)(7416002)(5660300002)(33656002)(2906002)(41300700001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dTqeAjAdspkl7KwyqM221T/SNT5o9+p7ngoQYo22lYxLuXk7GwW9g7GafPP0?=
 =?us-ascii?Q?EB0I960A48B98kJWivHn1u5Pjp8nGUFGTSJCu20BQ2og6On9a/2K6PmPVJlw?=
 =?us-ascii?Q?b7dLbUu6/fHLT3tt20EQauvy7oHpbsIctBoxR+WCO4mmIfBy1rvFHmyqpoEr?=
 =?us-ascii?Q?gUJoCce3sZXL2yHh//lmb7PZbFqSs3XI5w5mY6fxaP0ovX+XYqOkJGdVC+zm?=
 =?us-ascii?Q?/+Yl9UQN3tInicxlEMQX0VtOFL9w2LLVC0ubEOAeim8qhcHLZAVhX+xjnyHv?=
 =?us-ascii?Q?VImSC2uTHNBxRd0gk4OVEIu7HmQsAwsJgTf87kdM20Ac/bn0ryQxO5Eq6IN2?=
 =?us-ascii?Q?5MhpIY3+ovfAYEmsgzTOBfqbZOAGOOS8jUrKhdycsfhHo3pXSyiZOx7k9VuB?=
 =?us-ascii?Q?N0ItNaGWy0e0kbZ8eb98eFRftMwSj1RbKRWGup2t/NIJBNdtghOG8Z316UQP?=
 =?us-ascii?Q?pzdnu88MV5hSgldPclMFSIOMyBuHQD3rESI9gUrzxLYj3yL2Wvyb7WMr3UtX?=
 =?us-ascii?Q?pprcDx8/94rYmg0YP4izoDiEvMv2MLZGTo2F3ZYNu9XPL83hwxxOBuf8JlAM?=
 =?us-ascii?Q?AazxGry3FxU0eesexWshSvw+Oa65nd7J5O/p2I8YxmYAuxu7+Y9My/fG5XwR?=
 =?us-ascii?Q?szANKo6R3gbI62hP9LfGKqnWx7JaEQ7lJLFOC6dxUvU9gojJPnZPBk2JsOmn?=
 =?us-ascii?Q?C0IiGRaowjiNMjw29MRtZBOd64qsheruQh12I2obMA9c6bVEtPvQr2Ut+GMj?=
 =?us-ascii?Q?R/hu+RnI8iIzbZ6uVc3hqhF2kvnPb+BZAh/zPIcu5TIHD5TolhUl9Layi/iN?=
 =?us-ascii?Q?P3CXlwcstYzWRbJYB8LYpezPDRHnGgW1vM4X1belMhpU5/gLd2UfwXfU99tb?=
 =?us-ascii?Q?kBsRxA4jm6u26xQyhxCjI3lCBBnb0Po5ArbYn/Oc/ektH6daqNLw94qD2Q2F?=
 =?us-ascii?Q?/zq8t3PjzBL8frVQfpZQwQwbaC2B8IQM1LYLxpADcY441BKZ7hOz2/VwEhMj?=
 =?us-ascii?Q?hEYeF/xA3fIGa1aEG7BLw3Ao/2EMZkVtZ9lukuz7/LI0qkXa44nhwPFlpcJs?=
 =?us-ascii?Q?SulKDohsQ6PIT3sdShwirhNtB27nan43OmwMC2VG1ah8DZ79TH1EV0rZZVrp?=
 =?us-ascii?Q?gg8CtxBxELX3+F30xX/oHGPRJlG/iBhojHaSDq8psgfo3us4GNDxNeI8BTeC?=
 =?us-ascii?Q?35nRJa7ydMNPx0MAHKSruP1CoV6PBQ+dfKWMB++6vipKjJFj8d66QCTII8Q4?=
 =?us-ascii?Q?j3VRBDYZKshA0d1I8sN3e/iHY8puUeZSwhqZHzAxyDznkVF+NDytBNnAMVDP?=
 =?us-ascii?Q?fznBjLoj7nITBKqIhL/61SkspbXX2zo8vCDyGsCK/T5mF/C3j5dAZ95Dgbc2?=
 =?us-ascii?Q?njZ0ssaY/wmrIlBTFVnNzwN9jvRLL5lzFKG4GrUBSNiousMGcuEiA/xYFA3k?=
 =?us-ascii?Q?a4e1vkmxtxgHkcOmyCcUbABBOAAx9USZtApOQ2eTGFT0FO9ZbufZKigF2OaE?=
 =?us-ascii?Q?16ifFAzQXuciYgO+oW4oxjjD9IaFmVPEc2Q70fdc3+DV5gcKZcbTCQZ/7s73?=
 =?us-ascii?Q?M6YFJWw18++CmsbQCKYdw3qQ/ddeCZXM6jImXila?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40e0bd8b-fcc8-4011-fe8f-08dc21ad24e8
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2024 16:04:31.4046
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iP5CgkKgVtJrMiVpQTGA2q5Ph5SgXxm19+tZxoAdoHEAjRBXMEUaEcJNbYMU46ph
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5852

On Tue, Jan 30, 2024 at 08:46:10AM +0000, Shameerali Kolothum Thodi wrote:

> > diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> > b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> > index 05722121f00e70..b4549d698f3569 100644
> > --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> > +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> > @@ -387,7 +387,13 @@ static int __arm_smmu_sva_bind(struct device *dev,
> > struct mm_struct *mm)
> >  	struct arm_smmu_bond *bond;
> >  	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
> >  	struct iommu_domain *domain = iommu_get_domain_for_dev(dev);
> > -	struct arm_smmu_domain *smmu_domain =
> > to_smmu_domain(domain);
> > +	struct arm_smmu_domain *smmu_domain;
> > +
> > +	if (!(domain->type & __IOMMU_DOMAIN_PAGING))
> > +		return -ENODEV;
> > +	smmu_domain = to_smmu_domain(iommu_get_domain_for_dev(dev));
> 
> We already have the iommu_domain from above.

Yep
 
> > +	if (smmu_domain->stage != ARM_SMMU_DOMAIN_S1)
> > +		return -ENODEV;
> 
> I think we need to do the above checks in arm_smmu_sva_remove_dev_pasid()
> as well.

The core won't call that unless a PASID is already attached, meaning
we already passed the above check in bind. So it shouldn't need to be
duplicated.

Further, at this instant all the RID attach paths are protected by:

	if (arm_smmu_master_sva_enabled(master))
		return -EBUSY;

Dropping the S1 check was a mistake introduced in commit 386fa64fd52b
("arm-smmu-v3/sva: Add SVA domain support")

The current logic for SMMUv3 requires that a calling driver assert the
SVA feature, which locks the STE, and then if the STE was a S1 you can
install a SVA PASID.

Thanks,
Jason
