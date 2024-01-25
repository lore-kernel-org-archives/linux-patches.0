Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2060.outbound.protection.outlook.com [40.107.244.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6888318EB2;
	Thu, 25 Jan 2024 23:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706227058; cv=fail; b=TYYutUXYa0y3Vb1nSnTgx5Ag1DAduo1+LV6QCYfXyo5ny7RtGOxI8+QmGuzXs4g/5z+kPm/rvhtkABgTOr7tN5xXEAsuTW1MFmYo8nz7rSxm2BF2TORRSsA/a9eLq8SUxP64hZ8TDJDDm1ilq49/Eix5jMJBC9OIrSKd9AAKFF4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706227058; c=relaxed/simple;
	bh=U4PcOdlIUyP0fPfPQv/e8hf6hw/faGkXeLIeCYGa+MQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=SkUkyXPvljNvIZJL0C8tJ86e9KmJfgkD+RqOwesUh0ixZcV6xp0pLORQvx8BnCtMqHHSMd5IJKSdu4GY9aDvKYneLy38xZsVNJs/a1+oT7CX/Khjnq/t97bEi/mgoRl6Q21RqTrG54AsJ/fbulx2QtmlVpEqlbRQnyu/RC5L7q4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=drVbSigi; arc=fail smtp.client-ip=40.107.244.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="drVbSigi"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jocpm+zsnbhW1SgiojyaZSM+x8BWYweZ8066oMEs/ixclspO0u9zfTDV0pn8Y1zBb6cXt7m3p+pYG7YSRe+4Fvcwv8DD6toEf2akEZIpMQu2nsdgGLHMuQ2oN4BPqsh7lQq8dB8cV6pEE6JDg7tYcqVoBci7izaNl5XCOjoJTEjLUlXA+nV0zEKMUWK75YnfJmRVhfOThWor6rYf78i+RFPKL3aKSGlbN9X/WgHFcQI8shBMuGO50EolPQZC0CPKMaurb9bTrFmqmq1syiq0CrIDh9rlqrUy7ZZNY9Tjwf/1HTE4Ug6CikmFsICRvK/p6OCpcaocZ5fsmMIFfasI0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QvR4Q4KPkqGBasrfNcco6yE+xMHkkdgAO+RTxEjyyQI=;
 b=hK4+jdV2e9HCIhI+TAmcfe+ByjQy1etY6gVAMHwUCSIlqcy/ytNZN1s/ju/tPPl88paESgzl7BG2sefBll3DIWJYwiu4yxB2KvXEh/A0YSRcFZ/X+cFcAtstFyQBgCxWuSvEg0qra7C2GwNDG7/7iTW/jUOwdtQL9T3lbcWh6ZQLPrY+6tSGFiIeQyu6Pq+r+2GgiB0/L38YD6PsvCYS+m3G8gfSyUvWPR0g5oWYo1N4jGaZ3HNgGSEYICCELZxnzcExF49kPFi7QjTlt/ZVWJJh1/jz6sKqinfACA29vrtAJRtHDfqjRaF2ODuRAiyowEpZSM9ZHKZuRHKdn4VIqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QvR4Q4KPkqGBasrfNcco6yE+xMHkkdgAO+RTxEjyyQI=;
 b=drVbSigi5KYTTLTYnGoVegpSewJFidjRpRo4Jke9oO2Kg5t/SekgjUbx5vpATz8bckvO5eUzACHAvBj1OtyxWoJubqnv+7VFj14hPnyXC2hr7N3fSnbCCCx6W+TpsLaMAm5odTCkBiqmptRze7fa5PNXWGkNsPWlrZzx6pB/F8Re3g6NdBjr+04/txUSWHHHnS+haEVhqbaMOrviWldANnFPMEs6clHyC89wkI1QBrTWKvXDhZFJPy1ROtF0vdV0FoQl0uVzm3JBHjdJWc1KqGzXFz+5fWv6+yuFkllukL38WhJvQhEL0dkemvtQynR3gTSZvX0bbpG5sQcAQzMWlw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SN7PR12MB7881.namprd12.prod.outlook.com (2603:10b6:806:34a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.24; Thu, 25 Jan
 2024 23:57:33 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7228.022; Thu, 25 Jan 2024
 23:57:33 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH v4 14/16] iommu/arm-smmu-v3: Use the identity/blocked domain during release
Date: Thu, 25 Jan 2024 19:57:24 -0400
Message-ID: <14-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>
In-Reply-To: <0-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA9PR11CA0026.namprd11.prod.outlook.com
 (2603:10b6:806:6e::31) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SN7PR12MB7881:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c133fbc-f9fa-4c9a-54b9-08dc1e016312
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	e+W//JuZDJxwEhZTOmfq7ImE39W9WhQtWTy/U+YAXT3pTVs/VYNoW8IcWn4W7cGyP5+2l+bKVLr6yQu6P4ybV4uLLtCZAYXXjdcaNFpz8mDGBUAILPSSytameHAcGZVN+fHFvfO35KV4NVb73q9WVDvEKTe3INnAUatwe0k6hK8gAlr7lChe1meOGw90Oc2qdeaUbA9rZeaa2PItWNMLaImkeSlmeHsjZPTuUELYjYjqrwCM9GGPaPkId0J71GLaLppefwOUTNt6UGuBDc+VP299BldWX2GCpYV/9M+rKEnky09wXnJrDabNZi6CcfDScNszRgPk6G5Pj/e2KPyZ+H1wfIgpU2XZArTwKToA0sd6C/qonaZOaDuWVTJ69zgfSc77YUIjUnvUrsE/g159g/m5rrQmE0FGtMmCFWzA/9T1NLMv3roNlwS+WRwDaVef03YvNewLJezBcfFPPvO2k7uylVGL13AeDUkEPN+zGgGgxyhomcXe4GMVPrgoAIYA0WuDRIRmVt8S1qJan+wPdJ0XunuxW5HPFZ7scqcS15Tw7a9ONuiUmgssYUe7pHo7
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(396003)(346002)(39860400002)(366004)(230922051799003)(451199024)(64100799003)(1800799012)(186009)(83380400001)(36756003)(66556008)(86362001)(54906003)(110136005)(66946007)(66476007)(15650500001)(26005)(38100700002)(6512007)(2906002)(2616005)(7416002)(478600001)(6666004)(41300700001)(6506007)(6486002)(5660300002)(316002)(8676002)(4326008)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WMwzQMrPy1FMXsaUZgJ61ni40Suu3hFfVQJJcSujVzhl9D2hsegBNWZawKJR?=
 =?us-ascii?Q?RDrhZ91LNpTqZbg2KOFJE+qq0jc2xSS/PNnVILl8HR+B4HfGdoRVR738KNQ9?=
 =?us-ascii?Q?cFARIUvcQNtcYKSObC1L4v0YVNqb+To1kTi0rACuurv0AONpjF16Qa6Y0Xx7?=
 =?us-ascii?Q?vKS1J5hlAGuImlJAs6t6eAxmyJpX/H2fps4CA8g+5ng0wgX3/kPxNXMHUBdG?=
 =?us-ascii?Q?1pJWb7XUPaDRsJaVPsoTRKLEbGxYPZcL7No1+Daes2U8OCrRHw051/UiGPzJ?=
 =?us-ascii?Q?k8geld8w8Ug81rIEXjWN20bURv0zoVewkt2zLib2ULLMdmypCqFALsc5kbM2?=
 =?us-ascii?Q?g9xS/kxv/zB+U4rJcIdSWYxy/e37AA1iC3ooa3kpcJ2wnLH9UVpjIEoP306a?=
 =?us-ascii?Q?emS8Jlq0SeIKSCVp4+DkYuSC+dgsHg2ngNADKx7clrynbtyMYx6l/25DbbTH?=
 =?us-ascii?Q?DDrbMD8C8HQtYQxhZua5ugoRGfHTJ3xBTaScnGx/Yp9RlmUWimMY9wrnVqIm?=
 =?us-ascii?Q?a8iu9EE2Ncihv8XRPV+s6OAexqJMoHqJ8WuA4KfG9zYN866TPwbUvSRDhM6N?=
 =?us-ascii?Q?TcRKKj4RZhayZd3HmMR1OoGb2FcIq46UufNlbBsLNlFXaDM4gCTXGzvx35ts?=
 =?us-ascii?Q?iAFLT55vcl4Z6DkkZChy81w624LNi/wLNM1hhR2XDQtExPN1HtYQVmmH2X3W?=
 =?us-ascii?Q?rsbAIdRe+Wt7WHLbWfF2qsmEph2kw0+ChUP8QxfC5M9q/qmW1pmPJyBQNCIJ?=
 =?us-ascii?Q?vRSjyKB0X4f1zWKAaRrUDb849qa5jw7nNwigdE8CJrb1RTpn65xl0myyqAxi?=
 =?us-ascii?Q?665OiZ7bmQ5eGHTcOxjtAo4kCNxeIZmOszUjDpKz+UL0n4J5cbDSxUlAVHe9?=
 =?us-ascii?Q?80Dlg65/VZz/e4BOpQYl8oivSnpHZv3nUWicn1iwl9yTcXUHtXnFWhny6CM0?=
 =?us-ascii?Q?GbHg7FtD79USn7t26uyrISO0cXRAvj/gwmwiebiIdvwxLap5tpFMffEmdWLZ?=
 =?us-ascii?Q?0D58qT2Z3yMHw2ps1XFPVhB2Iz3WLw5t/9hdjjGMxX48q98xJQfEDJpRclwm?=
 =?us-ascii?Q?9lARZSCATXG1Lby7uc1n1VckwVJ8d1Z0/NOaMw70wSjegzHY8cXWwNIqW4XR?=
 =?us-ascii?Q?vkKD6Agqs07N6mvai3fWOgCsCW4Medql3WYi/GKiRkHd0yZJ0Hkvt0okDw4p?=
 =?us-ascii?Q?ruTpRhxJUGgvR/aWvo1FGlMyfeq+u0WZBcTblkTheVBdvRTeAlF0AHdBFlOw?=
 =?us-ascii?Q?0mEQK/ZKluvoimwOLx0IkVbLIeA86mZj3EfASbCTY69CF6znUVrDTd8+vMWp?=
 =?us-ascii?Q?KzSsvGeKvu8Ir1/I+8IKJBDNHyIzn1pK2+cFvMfhoAHQrAZPwzY237ZhVS+9?=
 =?us-ascii?Q?l1UIGFQAJ2KzInObRSIS2XzlTshkzEa5o1ez1yKrB/rLMeTqX+woNJWacuOs?=
 =?us-ascii?Q?OQs+3NIytWYvOm0Zut6UMrBWmTYBmtmeIvvXwC8Ma6gKFl9dmM8LbFRzjIQY?=
 =?us-ascii?Q?lXxRMNjpdz8L/7P/7F4F3KIUxersDtLvIwRnCFCywXknceJUABi5P8ch/4lk?=
 =?us-ascii?Q?vyniQ008iX020LXc3CbHCtI/TVumjgQRrIghUfn6?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c133fbc-f9fa-4c9a-54b9-08dc1e016312
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2024 23:57:28.6388
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tLCFYIl3zUCDYLt6ER4K8FU7iazQdlOLMYnx3PdYZOoDD52fWhNrANuWiwJojH3a
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7881

Consolidate some more code by having release call
arm_smmu_attach_dev_identity/blocked() instead of open coding this.

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Moritz Fischer <moritzf@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 15e305253ddbb3..92a72ec6ee974a 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2950,19 +2950,16 @@ static struct iommu_device *arm_smmu_probe_device(struct device *dev)
 static void arm_smmu_release_device(struct device *dev)
 {
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
-	struct arm_smmu_ste target;
 
 	if (WARN_ON(arm_smmu_master_sva_enabled(master)))
 		iopf_queue_remove_device(master->smmu->evtq.iopf, dev);
 
 	/* Put the STE back to what arm_smmu_init_strtab() sets */
 	if (disable_bypass && !dev->iommu->require_direct)
-		arm_smmu_make_abort_ste(&target);
+		arm_smmu_attach_dev_blocked(&arm_smmu_blocked_domain, dev);
 	else
-		arm_smmu_make_bypass_ste(&target);
-	arm_smmu_install_ste_for_dev(master, &target);
+		arm_smmu_attach_dev_identity(&arm_smmu_identity_domain, dev);
 
-	arm_smmu_detach_dev(master);
 	arm_smmu_disable_pasid(master);
 	arm_smmu_remove_master(master);
 	if (master->cd_table.cdtab)
-- 
2.43.0

