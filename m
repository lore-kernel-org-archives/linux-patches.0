Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2048.outbound.protection.outlook.com [40.107.244.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 381C36D1BD;
	Tue,  5 Dec 2023 19:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="eG8UiXd1"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GMaNdD//RzfMzeKK/EbZrsn3qHL7cp4FFliomqkCca8DZJxJaHIkeb3aIHXxZSUQgscBgX2zz+M2Qpvsskyqjl++hm8/CRXoQ7Jrr80R999jHotrgkmKZtBepw5g6xyhAwOR0qDN5lbqttIPB6IOJqGWJEIxlqodvXSODVvWbPzPdoKior3bikV74LNaACSfpv9EaJ1cVrusq9VQlN2IwZ+DRdaQXcPdKnE79Z7FDpEXbw1j8j3OkauHS6cNXRShbI4EDjQj+ZObShpgJL1wofpbblULTv5ffhaXGbKrs5vETJ6N+bEOR1UkoN8Ra6nGCTj0Zi6NvD+ehJZ2naprIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g296EJYrj9g5IN5mXbHv0rQs+6ATv/JtBT87ORnunIg=;
 b=H3xE9cMkijFUu9yDdcAvrDRc+4VKUd9HGjeTg16PccpKzBVRckz16xg1qgaJgVIggMMlm4M8EG2ukJESzsV2Od33UAj/tJ6DsLTz65ICpBm3Uakt3h1boS8xpLDMSjsJp9d/XTqLfc1gaPf3w2MZ0rIxklmLOaZMUzw4xd/fyroWc7csI1tx2yyg+1WEUkxYnvO7ZYhFr3Dry6R158/qnKTiSCHLnYAL8gZHSoAskCInbTk8FKLYY4rQka5x81Utx9xGTIv/8FHwh2qj5WBC3qi+DEwEe4mdWLxvdHvPAToUDqRnuoJi/d6oVa/j2IwAGJyGrUdiMZDZV5TblfAHEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g296EJYrj9g5IN5mXbHv0rQs+6ATv/JtBT87ORnunIg=;
 b=eG8UiXd1cOBVfg7f2oXLX1OJ6dfwDFnytgzx/Pla04td1sSUXH+CXpA50FCJvIQjwXNKJQugZLMjtFk+XQSPosNKrXCTQHKythnEKebZC1RcjzLbyBracqAOHD453gtS2FtpU/IPZTYBJzojyWcUZJeS2I5FfaQWXmm0F3uDVYZSsBomryrGk3A2IoJYUAzTwMXkRVKRZDssEkPmo8l0yRSucX4+KANjVh08IyZMz+QH/S3WpTFw5ogSfBpfPk57HGiFNvfB9MLOhkJ9qG1fQHAQuLlWtNRD82JgPcs07YFGpWUPwlErnGc6XtJBAmYLFTDKknJBvsmfIp3pX+UhSw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB6588.namprd12.prod.outlook.com (2603:10b6:510:210::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Tue, 5 Dec
 2023 19:15:00 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.034; Tue, 5 Dec 2023
 19:15:00 +0000
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
Subject: [PATCH v3 19/19] iommu/arm-smmu-v3: Convert to domain_alloc_paging()
Date: Tue,  5 Dec 2023 15:14:51 -0400
Message-ID: <19-v3-d794f8d934da+411a-smmuv3_newapi_p1_jgg@nvidia.com>
In-Reply-To: <0-v3-d794f8d934da+411a-smmuv3_newapi_p1_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P222CA0026.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::31) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB6588:EE_
X-MS-Office365-Filtering-Correlation-Id: 6daa4126-9bd4-446d-33d6-08dbf5c675e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	PtzTsFaKyVEEVMH/DOmbtC2zPnPBfZ8Ni/zNnmY261EX9qcO/f5d/zHF/oC7cWs4YlrRt+B0HAjlCrAXm6kWXSurrAM6GCGo8mNGqRO7wsQc9b5IIQHmKRmY0rnX6O6+O+aucCWYEVcQ5ytob5+rcGJUwGz89a0JpKahU/XKLrfzilel8ayrnfcafqurpuCz2qpsXBEAYK2WK58GoJWUWEHKho2D7okwY6ZbuLyrIC+X7dyrnXHYR/VmaLiH68pLNJJ/hab2U6P6/wJ46VflBh01bkmYPqF86R19JgBTk44Fo+c53hbQj09tV2pbQBz9t4JQpUJ8U5xx0c6O6x3EvGR7dCfD78x/KZw2I169M34GFhQnrWaL2L7wfiHMVdWKYvSbXsyxHEEeeqoO5yTLBuRmzhRF7V2chK1+GshgNn36lEif8wHg5LDHyVSNpU+rYRkqoXH5qwYtqCeKPJaw+mrunRo/N8uv7EGwd/ly80KdmQujrWZ51p7boBk9omMnEuOgmSR5YGxon4+Tojl/jyhPWWu1uzV5Az+GXoQ4Ciit0GrvxLsK4jThUvUINJnB
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(136003)(396003)(346002)(376002)(230922051799003)(1800799012)(451199024)(64100799003)(186009)(478600001)(6512007)(6506007)(8936002)(6486002)(2616005)(26005)(6666004)(54906003)(66476007)(110136005)(66556008)(8676002)(66946007)(4326008)(316002)(83380400001)(38100700002)(7416002)(36756003)(5660300002)(2906002)(86362001)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lNb6R2g8HtU5oX4Qt/+R9BwAtiROwtutGSMBV8ZpyIJ4pzDMGA9QHwYBgBFE?=
 =?us-ascii?Q?DgcUtBd5b5hVQP/1htVZC5DFPwJk95CCkqBxOdKqfzUMVrvhXnVJquWONdyQ?=
 =?us-ascii?Q?j0B/g5RNe2X+2514lh4iNqjPlegZ+WKmDuJfvyjFv18+lG8QSXZG9Y3MWX2Y?=
 =?us-ascii?Q?/PEIvRF2bdIQvwBYBCOaYlplazJwWSx7+pmOLjFMZgrtlxwsQ3zyCi38oITL?=
 =?us-ascii?Q?Fe531w6YUJ5ioHoaKkgi/WUkmLR0XyGfNjH9VkrhTTVxuLzjbFZaktK3t7Zi?=
 =?us-ascii?Q?m7xS+GTatdhnl+vrwsZXhyHLADO+1tWG8ZY5RVTnfYevBueXZTGMhsL0NLWD?=
 =?us-ascii?Q?pSG8ouwJmpr2UrO+aDybOs2aXAhC3ZGefoPI2XyQHIxSHaKnl+gFSaOP5abY?=
 =?us-ascii?Q?DpKR7cdJAbVSJU+lxaHgWgrCSOkIUGWwmKRQSEdGaElEFIKVYCOUOORWi8Tk?=
 =?us-ascii?Q?dYdKai8ILd/O+rh+/gX+0mrxiMzgNHHvrPxBcouixOH+IhPFgBCX2cBHEGCO?=
 =?us-ascii?Q?pCpwd9LeHdXLY8hyyqEL4w8z6+w6YqIf2sru579dvoBqQ5a6QvDSLHwwyaUb?=
 =?us-ascii?Q?RKo7225lb6C7Kakanp6hdB0mMVetiOKumrzjj1H64K7ArO2JeFumAH3Ct4Dz?=
 =?us-ascii?Q?YoVfWYVMc+eiJFDxYXmfl6Iz0YRZUwG1RBahC5LIHs0y44lshCcz/LziML7x?=
 =?us-ascii?Q?AUTExfNRD6xfaMezGEJxpjbCyFiYNKiF0NRRMazGZMP2cl9ZQuS38607ZRUt?=
 =?us-ascii?Q?syuOFMrisxp1X1C9ON46xrzT4vplLY8lE4Y1AB4sNYX51fZHkGi4owD39jYh?=
 =?us-ascii?Q?JYtPqqQgVyBCA1A28Z/K6Sv5wb6tMkw+sbBhbrHV3yBOZFbBI+2wdUFK7qM2?=
 =?us-ascii?Q?/S4LNxZQwOA56542tgUY61Pfz7cev299u+h/+zKIYsLjfEdZZM2bSuOpHVVm?=
 =?us-ascii?Q?oXvp90tUWgKJ3D0ofUkR0k8nkygaz9Wu5eaj7iF5LzmnyuFzgbeSXAMzg7u0?=
 =?us-ascii?Q?KgUROYOkY8FsDJ7ZSJ3xNdCcAgEgLx8eJoKR7xal5F5e3+pRgpiOWt2eeZdb?=
 =?us-ascii?Q?csRy3f0DG4ZyE3WO64SWXAT8YS2E+ZTaHoOWvnUva3efcqEpHdxxDetr9v6e?=
 =?us-ascii?Q?FgFb3mO5cbOuhCltTj9sxnNmrcKoIVGQV08/tkKf8QIsphdKwCz6AhB8GrTW?=
 =?us-ascii?Q?J+zYLOmPtUNCn7Us/t9FcDEtoYIsSlGYXDS4d2+6aK19yTZlCE0RogsXi2Fz?=
 =?us-ascii?Q?jStKAcuc/ItnzTSKoYmIzZ+by91sKRvpOXsYK+HOceKPoBdfo/8iz/S3ZKOC?=
 =?us-ascii?Q?mU66i0T8Mj14hhxB0JIBIWKZVwkCNFSMU3c7mvMxRZQF8sugcoDlDajycLbJ?=
 =?us-ascii?Q?U0phzyiSAvuUSzEDF8VsVW9a6pPDGC06S/bMvYx9qjYaG3cblWF8v8YFS0OK?=
 =?us-ascii?Q?yKSnIwaDvuUOfX32gC2ze7yYLfDaPpMMx7a4p73sXxW8zG+Etw08hez4g136?=
 =?us-ascii?Q?XERj2crWtcRfxoW+JZgsLv3qGCBmI8yShvzpApKO3oTepWrycES2AvlBNj1V?=
 =?us-ascii?Q?DeUHiAKU7+XZo/hEooF+OrMrAgbLriIlodglNPqd?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6daa4126-9bd4-446d-33d6-08dbf5c675e7
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2023 19:14:53.4390
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rYdetab/MEl8K3AO23YOeXmTf6FZ3M0x34JZW/9WzSrleurgTFCGtqOwhShHB/PP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6588

Now that the BLOCKED and IDENTITY behaviors are managed with their own
domains change to the domain_alloc_paging() op.

For now SVA remains using the old interface, eventually it will get its
own op that can pass in the device and mm_struct which will let us have a
sane lifetime for the mmu_notifier.

Call arm_smmu_domain_finalise() early if dev is available.

Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 873343109a90bb..f3900a3d52524a 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2169,14 +2169,15 @@ static bool arm_smmu_capable(struct device *dev, enum iommu_cap cap)
 
 static struct iommu_domain *arm_smmu_domain_alloc(unsigned type)
 {
-	struct arm_smmu_domain *smmu_domain;
 
 	if (type == IOMMU_DOMAIN_SVA)
 		return arm_smmu_sva_domain_alloc();
+	return NULL;
+}
 
-	if (type != IOMMU_DOMAIN_UNMANAGED &&
-	    type != IOMMU_DOMAIN_DMA)
-		return NULL;
+static struct iommu_domain *arm_smmu_domain_alloc_paging(struct device *dev)
+{
+	struct arm_smmu_domain *smmu_domain;
 
 	/*
 	 * Allocate the domain and initialise some of its data structures.
@@ -2192,6 +2193,14 @@ static struct iommu_domain *arm_smmu_domain_alloc(unsigned type)
 	spin_lock_init(&smmu_domain->devices_lock);
 	INIT_LIST_HEAD(&smmu_domain->mmu_notifiers);
 
+	if (dev) {
+		struct arm_smmu_master *master = dev_iommu_priv_get(dev);
+
+		if (arm_smmu_domain_finalise(smmu_domain, master->smmu)) {
+			kfree(smmu_domain);
+			return NULL;
+		}
+	}
 	return &smmu_domain->domain;
 }
 
@@ -3059,6 +3068,7 @@ static struct iommu_ops arm_smmu_ops = {
 	.blocked_domain		= &arm_smmu_blocked_domain,
 	.capable		= arm_smmu_capable,
 	.domain_alloc		= arm_smmu_domain_alloc,
+	.domain_alloc_paging    = arm_smmu_domain_alloc_paging,
 	.probe_device		= arm_smmu_probe_device,
 	.release_device		= arm_smmu_release_device,
 	.device_group		= arm_smmu_device_group,
-- 
2.43.0

