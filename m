Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2040.outbound.protection.outlook.com [40.107.95.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E911C135A64;
	Tue,  6 Feb 2024 15:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707232385; cv=fail; b=e0dkk+AXrA7wlcRv+AtpIeMpwlb69bHAR3FoCRx4Kuk9wIfC8s+3Mj2bnamMPYM7pAnDKeSl7OZREsQsLa47tPKBIiID1g3O0dak+Wy4NbNOVc+3c8GIonYHCcm0zTF/kNMmg9ZBqBeQoOAO+8q7u9ETrlRYQnvCt5DfyHtYg1w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707232385; c=relaxed/simple;
	bh=Mml9LbE52kBwHFTLtBxzTU/0Uwz9MIuA4CC/Dll1i/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XKGZ6xVZ1kQeZvTslp6SiPHw/OSLP0XVK/QB38vF59plslJyvnIJ471IXNZFLpopMfGZsnR1mi8hzsy/K6BG0a/a5cV0Q7i5THkqIAZvG98eZm27rAORnXdK1S8D4WgN7uczkMVpV/vNeKoT+CXBO5hGt7SPUCdNRGr2re9Bf+I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=fsz9xqG0; arc=fail smtp.client-ip=40.107.95.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="fsz9xqG0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VTehXGQYygm0mC2Dfai9/lNrP+RXI6EiVkYZ1Kywp4/eY4Ku4eIf9Ni9M6MzwtjrDPaFRkekK4a1mMB6nA9RHPRVPC4grbpNvGxFGDJIO+5uvSc2Quv1WkNpl0McSxW7WX3MBuF4TqBC9i8a/S2iZwfBgvIYv5qokTny7bUodOnr9EsSr7oIr6bvJqcmB62LmZnfNZtu8wByK3bQfws5z5K+ef7Cu3Ue2PxMUpwy/uPLzr88aTSdzpprBgyRqi71VyUMkAvgtcqfYzExRVx2HDJSf5qIrEIqsxWUfq41k2eiUZ147fVZ6D81MvvGamA7c3REdASPj/SvN1qu8eTV4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n+bt37hTuYpnkRrBIpijxkYGil7ZRe5EF6XUVOULzsE=;
 b=NEd9sSAV0jOWix1eY5pQOCiUydBt3qS3mm5DdEA2vtYCbts06z+zUbEtVegtUFcVOyDXvykcaJEWmZb6CVOKRs0wbLQ1zf184kF48qY+MIt/5wbvJk+OwJfOMO5GEXjr0OsLbT5Z3TpuzbnvpgRH/szg4xBnfRSt8N2q/u+6J8O14r9KHp5RYKopf+EAJ6AAepVaZdkBQTJdKz324K9CwEH/URpTxBUt33JmMWZGk4z6xeVjad02SPQtNmD4a6dfc8tcBSZTA2J7R4M/TPZ2SQ5K1W+fs17SgjqmsL9AhhhLb7OBy+N+xUADXOSzS9+i44qmPiaPjdc7whRwu15W0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n+bt37hTuYpnkRrBIpijxkYGil7ZRe5EF6XUVOULzsE=;
 b=fsz9xqG08Yz6HUxugM24MogpvoTOZKyESbad1b75LU84lmW+66pc2hgKHTRcvSZne2NRkXqZrlNl5TF22wo65gmnb/GVM07hEeDZfy3rVljN6cpCT8irymbaUISSaOsQ3E3lsDiZ72AeWXzOeZE6vNm5DNqb9MHHzKikKrWp2Ix0kWF9fmn7Tq9s/OfQ7GfDFO94cHCI3aJGA1CXKv+Fkc2xrD22zODHXOxDu/8D0W8nuMe6wDPy65XvwmQBxge78Q3jofxwc7Xo1Z7lbPGji+u/izpP8JdSaWizY4cAnJkUrWZOKw0TTC40yS6mSuXp2vp4o30ZRA5I/oOAwylZ3A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CY5PR12MB9056.namprd12.prod.outlook.com (2603:10b6:930:34::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.15; Tue, 6 Feb
 2024 15:12:58 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7270.012; Tue, 6 Feb 2024
 15:12:58 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <jroedel@suse.de>,
	Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH v5 08/17] iommu/arm-smmu-v3: Do not change the STE twice during arm_smmu_attach_dev()
Date: Tue,  6 Feb 2024 11:12:45 -0400
Message-ID: <8-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
In-Reply-To: <0-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P222CA0004.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::9) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CY5PR12MB9056:EE_
X-MS-Office365-Filtering-Correlation-Id: e3ef8969-2d10-4b70-11f5-08dc2726186f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	MWP6bNDORkS9dFcXzjOCr38MwqaWzcyMRIMV0mf9kiLVFpaGk09Hgxso79Od64m99kuqMX/mM45XqmmfFY16tubW8n12IBDnocGtpOE75obs+I1l+4d/DsvRJSU+0qliR+uHVMwe4s8w10EvBiP2uqqb/cA8KmiORetSe4EG7Cg8BTHYtN5FJfXZpNMmWTjnovsbX2xw82nseeKVtEon0TyqNs/JEryYT/9JnRBKs5BMqosz75o1JthCCxDEXWS7zmlIvSG6YL7an5GNZVNjrwPcyTcmk7rBkGVFgI+Ex5Yr3rTcwzjZVIg2jbfxnkaiC2eqziGJqG4V03fkmV0u2cs3MbFv2fCQcKFT4wRGecyQUfpiu/N01EpI0fBP5VFhcwNc1DTU+cyzBC8CCSAj/yNZOJrwkYMpk7Bs5pivJN4K1o53r+PPw21oGVvG6BeYY4Jip7cEO5vYK5WTST5zuRrwVSrBGirMpmwG7NS2raR2n6rDEI+y1X1H8gWItvVR1dv30uONASAuQWF51U04bner6I1r9NynBimbCdngkIHTJOlAX6XyW9jp6EVFih1xpxjILXbe+3dX0reGfzFM3CV0ZE722nqJ7/z188IVVyQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(346002)(396003)(136003)(376002)(39860400002)(230922051799003)(186009)(1800799012)(64100799003)(451199024)(316002)(110136005)(83380400001)(54906003)(66556008)(2616005)(38100700002)(6666004)(6506007)(26005)(6512007)(5660300002)(86362001)(7416002)(6486002)(478600001)(2906002)(8676002)(66946007)(4326008)(36756003)(8936002)(66476007)(41300700001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QRHCxPDGDXM2+TKdFruln4GzTEMLqZqxX0thY1y0AZNBqRJTo3CiGwa+ELxP?=
 =?us-ascii?Q?sUVcWAm633zSQAiCyewDK47xfjVq94pSg4etOgmhiyAgs9OHWgF32bKSfrzT?=
 =?us-ascii?Q?wT74y9l/ahlyTQpy/WFZdUZPUyAUfrSFF/hAn4sjIPDbkHwrW2EXEf2vso/5?=
 =?us-ascii?Q?i2vu2fSGBmU3xOLWftFeQFWinkN2tVp89BTDyR+JtQY2j7VgFZ4wQnwy+AFo?=
 =?us-ascii?Q?//mQZCKbqInlIE9Fpk5PLq5E/gkwR/KE4dav6ch4xX0SykAygKYKv8SDLEA3?=
 =?us-ascii?Q?csj8dpSLUvrhDRD5CKPnqSahDzYwivyEmLGYOf8OK+9yrX9IgQfxH/Gn17of?=
 =?us-ascii?Q?m29gJvlHoG7GRAVxbJKFB2iOhgUHZGqMqJ170ng17h2TDuEPb9l3LkKcB8d5?=
 =?us-ascii?Q?KvwcXTCOWyX8yoX38Y6XAa7+Nv35clmxBX8p4UlQULNTQuksdLgopXiESaEf?=
 =?us-ascii?Q?mwGf5/CXRBw1YyIMH6T0B1FbqzWEN720jQCl4OlE+po/Gxvd7kK0mVPwzHl5?=
 =?us-ascii?Q?yTJebU6J0pxMG6jPUSKG98avEob0feADZtnu7gePi36Ww6ucimatOrrCftcP?=
 =?us-ascii?Q?aDDzljgestMafta1Nx7HLPNbkZYEWaBI0/4GkErfL7gY26BsQ9/WcXD2lj3A?=
 =?us-ascii?Q?yJDsXFDsjyz1owl9eUMfG5iW11miiWdscJ2SAlBOC0FNcD46V6SlptSBgPZ7?=
 =?us-ascii?Q?qPCU2vPyMOa/EIkhEeSMLvT8nQ3l2+mbn09gCJiIcYKVxNTkm7pYypKDlLBS?=
 =?us-ascii?Q?NOlcI4PHjrDc893dgbTDXALBjrxO2EWr/95TeEdHcGWv+SHBTYgEF9npuxVT?=
 =?us-ascii?Q?yy2OHzMDuxfI/3PUaFXtgCcM+kKMjripzjSH79CcaWr4GJ/ZcDsReyWP2i1l?=
 =?us-ascii?Q?e8Piy1LQuh9wewrU5JTD+MwWUteTDNQk/kVLwqXyvULVpMxJi/eGL0jP3fCS?=
 =?us-ascii?Q?uhb+c7FsK9nxtWVWsBT5OJ+d6RODIGCFd9eQJCHygLDclz+/59cHPLGL8Wvw?=
 =?us-ascii?Q?t/quxRUDdVENeVAGFRKWWHlkG/x1e7DxDg0XNGJruX504V70BM7J7MSv9qPX?=
 =?us-ascii?Q?8cWKfVaOlN2zqYAAYUv1Kq7rbQD5PJVWOiHHOtQIh09J/WNwRYIyz3gU9MKV?=
 =?us-ascii?Q?wUG843+ZK93iEa1dklFN5DwkFHpNV5W/dxPmBJ5VW0hrO8UVcIH2YQWdkW/h?=
 =?us-ascii?Q?7otp5VRhzkkQ2qXVVUU3TA6lisD6fxOE9fIsqG2/fUcwACvAg+ruVCyoSeV0?=
 =?us-ascii?Q?UNzjDQzjjvRsD/+aWhqFUZGWzrLXrhEJDsybefGXMh0NNnwrTl8bhKofoqGQ?=
 =?us-ascii?Q?eBjcoQD4xiEbmChUWrKOAwxIuAKc/CopG3VvDXUaNPKz+uympBvcKoSwzhbR?=
 =?us-ascii?Q?QXusySgjd6Qfk8NqCJ/B8PC014QXRxdoUSE2FolxAgcXWQSlk2s06dD9CXgS?=
 =?us-ascii?Q?UvV6wm3hW1F6+oCzSwfE+gJbXzNdFCXF4/4cYHYaYOBapQGvl1UT9MRSreC4?=
 =?us-ascii?Q?wLmm1XnXWYl4qkqyIL6DZztjS8ta3WY1uBeYLfFWmCpNXn0NziaZ+bN8LViW?=
 =?us-ascii?Q?D2KsujRxMNfwnvqrnSACz19E1ZB2aZKjC40nokJp?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3ef8969-2d10-4b70-11f5-08dc2726186f
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2024 15:12:55.3051
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yy35xImYlVsW2tYRMX3CVb5wiXrrLp52tkvW1wiOS5bwJbNAmRyQCl3gIyoD++Jq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB9056

This was needed because the STE code required the STE to be in
ABORT/BYPASS inorder to program a cdtable or S2 STE. Now that the STE code
can automatically handle all transitions we can remove this step
from the attach_dev flow.

A few small bugs exist because of this:

1) If the core code does BLOCKED -> UNMANAGED with disable_bypass=false
   then there will be a moment where the STE points at BYPASS. Since
   this can be done by VFIO/IOMMUFD it is a small security race.

2) If the core code does IDENTITY -> DMA then any IOMMU_RESV_DIRECT
   regions will temporarily become BLOCKED. We'd like drivers to
   work in a way that allows IOMMU_RESV_DIRECT to be continuously
   functional during these transitions.

Make arm_smmu_release_device() put the STE back to the correct
ABORT/BYPASS setting. Fix a bug where a IOMMU_RESV_DIRECT was ignored on
this path.

As noted before the reordering of the linked list/STE/CD changes is OK
against concurrent arm_smmu_share_asid() because of the
arm_smmu_asid_lock.

Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Moritz Fischer <moritzf@google.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 1138e868c4d73e..340f3dc82c9ce0 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2562,7 +2562,6 @@ static void arm_smmu_disable_pasid(struct arm_smmu_master *master)
 static void arm_smmu_detach_dev(struct arm_smmu_master *master)
 {
 	unsigned long flags;
-	struct arm_smmu_ste target;
 	struct arm_smmu_domain *smmu_domain = master->domain;
 
 	if (!smmu_domain)
@@ -2576,11 +2575,6 @@ static void arm_smmu_detach_dev(struct arm_smmu_master *master)
 
 	master->domain = NULL;
 	master->ats_enabled = false;
-	if (disable_bypass)
-		arm_smmu_make_abort_ste(&target);
-	else
-		arm_smmu_make_bypass_ste(&target);
-	arm_smmu_install_ste_for_dev(master, &target);
 	/*
 	 * Clearing the CD entry isn't strictly required to detach the domain
 	 * since the table is uninstalled anyway, but it helps avoid confusion
@@ -2928,9 +2922,18 @@ static struct iommu_device *arm_smmu_probe_device(struct device *dev)
 static void arm_smmu_release_device(struct device *dev)
 {
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
+	struct arm_smmu_ste target;
 
 	if (WARN_ON(arm_smmu_master_sva_enabled(master)))
 		iopf_queue_remove_device(master->smmu->evtq.iopf, dev);
+
+	/* Put the STE back to what arm_smmu_init_strtab() sets */
+	if (disable_bypass && !dev->iommu->require_direct)
+		arm_smmu_make_abort_ste(&target);
+	else
+		arm_smmu_make_bypass_ste(&target);
+	arm_smmu_install_ste_for_dev(master, &target);
+
 	arm_smmu_detach_dev(master);
 	arm_smmu_disable_pasid(master);
 	arm_smmu_remove_master(master);
-- 
2.43.0

