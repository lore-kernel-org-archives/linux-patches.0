Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2048.outbound.protection.outlook.com [40.107.244.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F16D46D1BE;
	Tue,  5 Dec 2023 19:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="eMz6gY8N"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Un4Aehrv3CK7Kwbmy34NvZy0jhoX2t2S3P8fkwbYkd7O9cQD2f2eroVfqJBrGo3NjUng5wVcpRdAGLzUIC2AnOgqUI6Ss8pua54t1gfzYDJp7t5kMJRZS8S+J77nKDF3U2TGMcl5ZyAiMto2tM0xK3GwTwU54CuBoAVZGDosVm7FZkHM7q3TIEQwzmsH/RP/xFaMqicWAHVjaj/y3uCkE2413TZh7iO6ugGp+pWg47B2fhiYGxZzanAadrPThoAb6m+H50WtHZ/t9IkdHOiIL4gZTII/LOpEAH8hdF70S4Cg7OvORHzTELRQv+RSWbodtmmcoVE3nbJElnvhydJz/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pK/GNUSu1UOKPQvkjCoArpNvNirvau5mQhuKi2rQ1OA=;
 b=acqTYi8TArBRMNSs/xlRV5s7lbMeQd9VIDE0AP8xxoicvY5gVWzevn4U88NeOtXtr7ulgR2xopVgxyM9sSOO9UFvaBicLTjlhYTyEhA/R1NQFjFIdqVZiiZ6PszcWdebsOuSlmgTWv8ys+wlZt0GgB05gXZSqpxOFP4Fhr/NDMgOamJauqHHhJd+YIKHReIeCGlhetzuwVN7jQGAGJYLSV/qA0Cy+N9sN+0jLXND9E8PJprjr/SI6YRAIXhWLHhvCtAgZOvuGyn4mrMoobm5ck/aTkL355GU2bBz0E4Jlti+IwO7fKk5EjexALOx2GM3jvwd8BLCB7iPZXmBweFTjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pK/GNUSu1UOKPQvkjCoArpNvNirvau5mQhuKi2rQ1OA=;
 b=eMz6gY8NjF0dE0FOMKE4A7JRof0mvxXDBArEblw2mrCHABSBosU9Oh0a7gm0qZqKVJIGT2RA2p7L04GwTs+Q9QxuRMMtYobE9R820OjxYCQPgjcGvXpMF+GFC4Qmu3Xc7d1Bj5NNM8h821A46vG2/Og7fz9E6d4zeraaUEDZBKziu017MtZbBge9yhMku1Gy6XJtNp3J/f1yhO8+udNKEdPS8VeYVNBw8TYaKu7eOntd2ejXZCbqoJpgBX3AwYa3aAOfFekiuuCdfQ5FAKcBQVy72xj7aRNp6FI33Z2MsI88gGBOZZl+mtH939XwiJn9Ql6Q9PPy/YIkGW4QrnDBIg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB6588.namprd12.prod.outlook.com (2603:10b6:510:210::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Tue, 5 Dec
 2023 19:14:57 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.034; Tue, 5 Dec 2023
 19:14:57 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH v3 16/19] iommu/arm-smmu-v3: Add a global static BLOCKED domain
Date: Tue,  5 Dec 2023 15:14:48 -0400
Message-ID: <16-v3-d794f8d934da+411a-smmuv3_newapi_p1_jgg@nvidia.com>
In-Reply-To: <0-v3-d794f8d934da+411a-smmuv3_newapi_p1_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR16CA0022.namprd16.prod.outlook.com
 (2603:10b6:208:134::35) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB6588:EE_
X-MS-Office365-Filtering-Correlation-Id: d59cce8a-293d-465a-9d11-08dbf5c6754e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	g38+u7h/DTCt/R7p6uTbl0/eHZedmNixdGvCD7izMOiM0uvAI6A9VTGWPJw0TP1x3hMAW/v0ABkDcTwymq94uzTCSiyrar7i/xbp3nytE1MZMFTGuSV/Xo+JpcXQ/yeId+BWi4BOtiTI4FJR0rfA9ap3LjP6KK+XNYKEVmQnpqiNEiKYg60h6/d62Io1pDfcAX6twuzhQ+Qlc8HYnVXwqLnSLOxY3K/P2bDcyY/v3O7UGk1WPfh0g24euGDOhqTUwdyKPaYMaeaNk2jGAFEBj0RGg7L2u/NACT0GNY0kQNLUxxJAS7tY3Z2pBTpV2bQDW3Rm9vBVF6dBgbFnOZyEMpXrHzMsXf9zeHVMevIJord7+RvgeRjIcufOfb6tgpVAVPw289yrRxN/gvLZ3gETaAuV4XF+bc+i0U+ZzLpT1BJmvnMRjU0ktC1ZbTSvZpN3q9sipKqc7aPjT9r/YhqyA1I/d9yMrBLTSRO5rsZjt81GSA+bXIqHNfOcwawa5j6DmwAP5MQMvSy6tkevd7gXR/ADwKfp/L0d4vP8hrpic/n0M+dohcnhENM2/sSVVPoj
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(136003)(396003)(346002)(376002)(230922051799003)(1800799012)(451199024)(64100799003)(186009)(478600001)(6512007)(6506007)(8936002)(6486002)(2616005)(26005)(6666004)(54906003)(66476007)(110136005)(66556008)(8676002)(66946007)(4326008)(316002)(83380400001)(38100700002)(7416002)(36756003)(15650500001)(5660300002)(2906002)(86362001)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?C9KHOWNsEO4LMgMVIinpcZwGbnOJnT0uRGqWzMRGdK5YPoq1OGqP1LFGYnkd?=
 =?us-ascii?Q?hyn7Hwas9iJbEn1vp5RiML1Ec8JuYCVbS2BVL42Q8t4zOc39rGK6lShhDFmy?=
 =?us-ascii?Q?2PYiVXIqtA1RM1w2m6NEEPjK/A501asyJ2Aq09SpWtdYJrtNocSdlbihHVGq?=
 =?us-ascii?Q?gVybtDwBlSLJb/2WhAWGYU2T8zoG9+fFrEY9qjjRKgybB6jjBkKp4asIhr/l?=
 =?us-ascii?Q?bK3VV7sDs/bI0v24gmFQNek/oHb6MnB4z4LYY7Z1ZBQWai9iqoBG+Y0WSwoG?=
 =?us-ascii?Q?+oDezPnf1XK3l7CQ1eNFKIK7Vy+BHnAf+bcIwz4t0oZJH0ivCUvkz9yVlSj3?=
 =?us-ascii?Q?8aXpBTJw6TlvEV04XzQedGKfcGAY8fDFdlsgkJSEJH14Ph/qJbjh/BZCYMTC?=
 =?us-ascii?Q?yry8Y+xij4aK+pXDqu0jaKasViqFk0u8nkVhhAnXlYEhlo2+A/aIhViYoCGS?=
 =?us-ascii?Q?SNyEEr8TrImXaxlB4Jp1j8+Ew0j96U0SaDKOt5E6b7KvQ0ci42W+bg58DxOg?=
 =?us-ascii?Q?BDpxKP40gZENUNMvqsvghCyrQZNfMzxJJ2YgjFZqhW9a6ZmzLD/swtI9KEPN?=
 =?us-ascii?Q?Mn3GsLTWbtYxN3yRl9ztyUURxB0OIy5ZhKM7V+eYqPY6wudS2O1bAqKZqjDi?=
 =?us-ascii?Q?SAvOaWgO9IKINg1DZbG/HghJas5wCqBXQ2FW3nKm1+7/9hW9IPTNd/xm+vcg?=
 =?us-ascii?Q?QBjLoMT+E5/OZNe/IjPQK4cSUO0CtJouK5fsgP1QXJZ/M9m1Hy4QiQ+WrttN?=
 =?us-ascii?Q?Nhcu8GPV4qZYNXdV87EmL3sU3drd2g84rjWpUpd24urqmF4VOkLgtDmD6Tgs?=
 =?us-ascii?Q?SmfUF24MBBlB8DLfUhoLhF+RwoDm0+1uJ94eXhc3RGSDYFuRanigi01kBsix?=
 =?us-ascii?Q?oNdc0kMXRGwtLOQV76/BSgs1VzxOT32NHBd88RIT1PLGCrU2oxaHWmuMAQiI?=
 =?us-ascii?Q?AnPkO3U40QmIEdHUCnl1f1rXpDV8cjAZDMWy8vC73p9+uulKvIF6VnPNZ7j8?=
 =?us-ascii?Q?cLJx4QxGnUHZnvPH266nXjFjf1kJyzZlISVkyTRdfCd0t4X6OmML4nsaBNHU?=
 =?us-ascii?Q?BMAfwhbs6m1bEzDuFh6+dCF8eOILhIDLwQdZuO3lw8vTecMgFlKKXzcZ9Xvv?=
 =?us-ascii?Q?rqK7kIEYxeoW2s4XYrA7wdwbvPkEmHXI8MhQUmQeWN1zN/8fu3NaSA5fQz3X?=
 =?us-ascii?Q?fdN6L97HOnwPSfB4xpIoc4svM+T0VyhM+TsEwoKE0K9cElE5XFoCV6XAP92r?=
 =?us-ascii?Q?5yZd0gxZOoG3XJCOFzPXtSJ2PNB2aCu5NOfukvb0aCJAgtg5lODpcdnUzyqJ?=
 =?us-ascii?Q?Mt/sJqUz4EiI9Z6dGkk4RObOO1nNYi4UJQhQlnfNBFgHh1UXmbfUWZRDLY7g?=
 =?us-ascii?Q?dHN7Qk+DBtnQVozC9kEeI0wcAOJlf8qwQrUe9bEeT2+ZM7r13W4d566x4r7p?=
 =?us-ascii?Q?qNYXpv6dod0kcxiXaiMXT4/mqudmG5dy4uqaTfxmFGpdNrg5ncJEUX26fxFV?=
 =?us-ascii?Q?E1wsEvLwNMVld776VWFY5RZz0f/lvqjA/1U+/JxZxxldmu7iRM7QPbDM+/88?=
 =?us-ascii?Q?0soZPTUMXJYFTTmQOVEfBsEEzaorpoJimdNUDPG0?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d59cce8a-293d-465a-9d11-08dbf5c6754e
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2023 19:14:52.4605
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZICc4Zi1jRwkNPmw5UqsG8NDBgoacYN4U6uxe0n/FwViNir8SAwqMIS+iME4tywH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6588

Using the same design as the IDENTITY domain install an
STRTAB_STE_0_CFG_ABORT STE.

Reviewed-by: Michael Shavit <mshavit@google.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 9899caeabc8744..386bf954542e7d 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2647,6 +2647,24 @@ static struct iommu_domain arm_smmu_identity_domain = {
 	.ops = &arm_smmu_identity_ops,
 };
 
+static int arm_smmu_attach_dev_blocked(struct iommu_domain *domain,
+					struct device *dev)
+{
+	struct arm_smmu_ste ste;
+
+	arm_smmu_make_abort_ste(&ste);
+	return arm_smmu_attach_dev_ste(dev, &ste);
+}
+
+static const struct iommu_domain_ops arm_smmu_blocked_ops = {
+	.attach_dev = arm_smmu_attach_dev_blocked,
+};
+
+static struct iommu_domain arm_smmu_blocked_domain = {
+	.type = IOMMU_DOMAIN_BLOCKED,
+	.ops = &arm_smmu_blocked_ops,
+};
+
 static int arm_smmu_map_pages(struct iommu_domain *domain, unsigned long iova,
 			      phys_addr_t paddr, size_t pgsize, size_t pgcount,
 			      int prot, gfp_t gfp, size_t *mapped)
@@ -3041,6 +3059,7 @@ static void arm_smmu_remove_dev_pasid(struct device *dev, ioasid_t pasid)
 
 static struct iommu_ops arm_smmu_ops = {
 	.identity_domain	= &arm_smmu_identity_domain,
+	.blocked_domain		= &arm_smmu_blocked_domain,
 	.capable		= arm_smmu_capable,
 	.domain_alloc		= arm_smmu_domain_alloc,
 	.probe_device		= arm_smmu_probe_device,
-- 
2.43.0

