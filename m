Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2040.outbound.protection.outlook.com [40.107.244.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7853D6D1BD;
	Tue,  5 Dec 2023 19:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kQdj/E8k"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bT0oHE2LrpaXLkTWMNw3DVsS41FAH7/WfCv4pVx6LJ3RMo1c6peRk2e4iK3mJDjY5oJxQ15DV+HIeTCSAzqDOW74bXC5UPNKl1u8rbUxdID+eEfN8yr3fpZjhfpXRI33XcKRYh7ofxC0rwW3stkrcbNFQswdbNUqXKaVHmc/Lc4uATsoMJ06B01EV0KBNDIm5+B3acngIcSQZ0n5B5Owtet/ZjRdxF6gR8pODB23yxXNnYWdZvoHeUutgihAp1+foJZQRwpknZvLlFS2P3MSdqQYp6MNiw+MNI9v0HjtUtZERElXYcAcEJwR5ToIqco51hEs1k9uOY+AOhvKDhHnYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DIo84qe+Yt6Sh9dIF+rEefWutZVAHA9U9OVGhmn1XWk=;
 b=lYbOaS8g8qCVK9rvOQHqM5zl6nVvjWi9O+m95n1UvGwSrHh9NvzpzFBNaZ9t0AB7gBOuLG6ZW2NzhMZTSl8QJCSYS7JfvIrWH7zOIr4bqis/8GDlYyje2SfzYxiDSlwVnpAIsg6nil5YnnLbvQ//wZggLuFd1q0Q6DHiIPVPTqm+ZZxlJZ7M5/2kwWkZBs/3ejBvzjsL8NbfSvaaetEezptetMhbllE4rL9GLwaxf5aq5/bUOov3VGFU0c7N4C0BbYll5Cl3bYVZBDhy5OvPIhKGaQLYsrO78x+GidH2lnrI0IZcg1ym/3jZh2+NWpIt0sq/Zgw3eH4vRM/GAIKNzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DIo84qe+Yt6Sh9dIF+rEefWutZVAHA9U9OVGhmn1XWk=;
 b=kQdj/E8kFnLIe7STLz1uvEbMUHd9tc65+f8mMRZ/yEKLi+7WXRUUS98M/F3+59NIRvPQgWELLFRkSdfIiLqOruGE8ss2YPnpTgaEaFxBmjlapgZXZuflHHfbtb4XTrSP2nzUvRz9SPOvUKxGXX07Mw6drCKYfsl1O1x1qvTPU6hFn26aNORwK24odIEzk+0qpk6AgXAtThIMEHtg0d63kvpoIklBmUbUYgJkLWoM5S270N4Rvtl3vu0AuS1Zu1muPCGU49GB/Ec/+9NvZDT4SVTcpzky0yIxc8B/arBhCp4Hrju5UXcI77TicZm0rhmHo+Isboy9aZOfSVik0ubsvg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB6588.namprd12.prod.outlook.com (2603:10b6:510:210::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Tue, 5 Dec
 2023 19:14:56 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.034; Tue, 5 Dec 2023
 19:14:56 +0000
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
Subject: [PATCH v3 10/19] iommu/arm-smmu-v3: Compute the STE only once for each master
Date: Tue,  5 Dec 2023 15:14:42 -0400
Message-ID: <10-v3-d794f8d934da+411a-smmuv3_newapi_p1_jgg@nvidia.com>
In-Reply-To: <0-v3-d794f8d934da+411a-smmuv3_newapi_p1_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR15CA0040.namprd15.prod.outlook.com
 (2603:10b6:208:237::9) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB6588:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ade9a41-6413-4d42-138e-08dbf5c67545
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	OkqM7HDIMux8hcdGOH7xJiM46URQtMizRUGyJxleGdVKtMzQXoxrz6NfY9dS02m7CMY0GOd7c/0GM60TuVveDG6zm0DMRiL1U+iIvu3RR+ocNMAI9obbn7CyrZzswnAM7oktesT0pgpgdBmuNXje/DWQ4Z7xFz4Whk9W4cnQc3lum8KOMQJTVq0G7sO6VgzOy2P3fia063ItzTeurQvg6GU0FILw6Z7/rGIutpDVM1civMCy8vH2JW4xZn3FqNlbEbsHulvODR2GocNc4i1hFVnkbqa+d45M/L+zTCbkIalDxPxXFPR6MScQMMr3S1vgBEgu6iE37OjgtCF3hi6a+hRi5Ww0qpDSJCrfKMliGZK/MIia5she1UkARetfU4kUGVXHdxMqA1bFcUGrQnSf904Aira1lkviOfKfYv58KdlSQfgaH9210U5nLlKumNF/i8E075S/dqLJ+3JuuoalEsiNPz/JVsZ7EfeD52dbMxWyxb7PoNzpwTUo6MQiKowDrmHTHFYZ2locCZSZm7OnnGzxFln0SambHDgr4CZjX6XoL1nh271q1C/1ju3j1Ste
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(136003)(396003)(346002)(376002)(230922051799003)(1800799012)(451199024)(64100799003)(186009)(478600001)(6512007)(6506007)(8936002)(6486002)(2616005)(26005)(6666004)(54906003)(66476007)(110136005)(66556008)(8676002)(66946007)(4326008)(316002)(83380400001)(38100700002)(7416002)(36756003)(5660300002)(2906002)(86362001)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qgO1PASRBBrtcIZwe6H2uH3qSM/9323Alym+KJAk3Mvwigq9aSgaqw5uLMQE?=
 =?us-ascii?Q?liK/eL8UJZblHxj9es+YxZuSaJB78QfkC4pTnVU841V0vfGUZhoQKMrSs6gY?=
 =?us-ascii?Q?1m5RpV93wXAwqTEd9IRXr/rX2uYWAXTBwj9f2wfML/3rkGAh/VbS/Zjbes9z?=
 =?us-ascii?Q?6x/rlIrR0sEsS6Ouz0ZhHq8/JK8J3PROkz+KgyF/J1ZGx0bl8iuahuBgcWYk?=
 =?us-ascii?Q?WSpQahShSMWlMWcvyevlwZoYe9G8x7pZ5ZtVYHThilEsuaD5wDovYofpU5Ai?=
 =?us-ascii?Q?6yRMu3LweYZPGlCDyEI/E6TAI1EFAAI7+ei5BSjs+KhcFZm+wK98fenwq5if?=
 =?us-ascii?Q?TXQNTgEqw/ajvhb1Od2ovM0f9QCOtpaxhEDpQ4m+xa6PtRVMkVMymabt50MI?=
 =?us-ascii?Q?B/5vdhmPP1NM+gd14mUCH+G4tTc5Ihg04Fh9Vzvly2q0VFsu2cq/81IbKcgn?=
 =?us-ascii?Q?5uX41czNU9ciUcNWGPRttkzEU9loN1UG/2dCnD/5tr1mGdZdz6AOHUHn9HCY?=
 =?us-ascii?Q?CiMkzF6zjI6fc8jkYCHxfMmPYFCfReZEGT5G0Fa0Z6tLKki03sBl4lFuswpe?=
 =?us-ascii?Q?P6rkVC2doE2pzNXRPv1g9evcUtSfuvZqCMLQpeThHK+IJ2bBHKeVo3ra8PpV?=
 =?us-ascii?Q?DC0zyjdYSK6a3PBgZFhmhyCX7vaiucHXlFh3r81nFxf9qOtUcBK8aQHGubnY?=
 =?us-ascii?Q?2JWk/LnFQJlnnnnedIvLLGdpjLZIqOdB23jecrzH2XkX6WdcwmhPZarQrEaB?=
 =?us-ascii?Q?N+Jozb2THNWahbHPRTQ+8zIqPDXWeIldDPV2SrEMGyTI7ceaAQzxS9Z5qgWy?=
 =?us-ascii?Q?mgdQ7nEJYEbvGKiphOmQUHGoy4xgByC4rZ55uMWSbGEtsS1n1CJvoM7Zm/G8?=
 =?us-ascii?Q?kgPnehZG0FeytXOqhTSj4+dcUeypgOtfycY6Nzaa/UglzEgqUe3mAG3LOyo/?=
 =?us-ascii?Q?BhiS85XXg1z9iwGZ34YvQ7qTpQXTPW7FU5rd/WXDmn9qJajIJ7bW9VKtoDwp?=
 =?us-ascii?Q?3xca/onL85XOydoH7W30AJEh+8zMEIIZMO1LTMH+smvjDkky9sOIGYcgTDnU?=
 =?us-ascii?Q?99r4T4xPpsjw8WnK3TdaCWBx9BCr8PSH07B0YgmvZjUq6SvqdHorPBXiQQlj?=
 =?us-ascii?Q?zIV+eOEnVvKnte63zGpcGtxIJ7f1uACTAU3TqMpJak+ZAl8Jqy8iLN34CBOX?=
 =?us-ascii?Q?O/SwesxLQpWsSsUD1HrxAvJpYddqe0MY5w20PoVN35290Ao3VUpZdZDrDEze?=
 =?us-ascii?Q?52tXUsxjwu3u2+hQRwX93WVZaLSYqfPqblw/IqQQckzZnDE0LCpsIjccXx96?=
 =?us-ascii?Q?QSC3FsumZbKC//Su00A7LcbCe9SglN7OCQVCzcYBpFgzMLwbRp/0ebtbQaht?=
 =?us-ascii?Q?axgeHd6piQ7TPnP5027V62S+Wf7otTHp0Joj9tGbqgHHQziWfiX3LwoRkKOU?=
 =?us-ascii?Q?dvOyHsPltmVwiH88M3XzO3bpcO0BIz3beUM/q5NzVmhZSrEed755e/ZzJ17R?=
 =?us-ascii?Q?BmiN/MqcrTbuwcrUf+a3URMK3AC/A0HHzVTcXW2lxNEIpO/9Ul9U9MqxstWg?=
 =?us-ascii?Q?2qO3MRQFgwbiOfHLfMBK561tiL28JwE2HkeWZLj7?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ade9a41-6413-4d42-138e-08dbf5c67545
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2023 19:14:52.3980
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZZttRBBpsX0Qsha/jFPtFY3jU43D00g/uC1akwA3YbjcgLkcymReW57EfLi3L0CS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6588

Currently arm_smmu_install_ste_for_dev() iterates over every SID and
computes from scratch an identical STE. Every SID should have the same STE
contents. Turn this inside out so that the STE is supplied by the caller
and arm_smmu_install_ste_for_dev() simply installs it to every SID.

This is possible now that the STE generation does not inform what sequence
should be used to program it.

This allows splitting the STE calculation up according to the call site,
which following patches will make use of, and removes the confusing NULL
domain special case that only supported arm_smmu_detach_dev().

Reviewed-by: Michael Shavit <mshavit@google.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 58 ++++++++-------------
 1 file changed, 22 insertions(+), 36 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index c375da195af713..0c1d70b8f325ed 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1535,36 +1535,6 @@ static void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
 				      STRTAB_STE_3_S2TTB_MASK);
 }
 
-static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
-				      struct arm_smmu_ste *dst)
-{
-	struct arm_smmu_device *smmu = master->smmu;
-	struct arm_smmu_domain *smmu_domain = master->domain;
-	struct arm_smmu_ste target = {};
-
-	if (!smmu_domain) {
-		if (disable_bypass)
-			arm_smmu_make_abort_ste(&target);
-		else
-			arm_smmu_make_bypass_ste(&target);
-		arm_smmu_write_ste(smmu, sid, dst, &target);
-		return;
-	}
-
-	switch (smmu_domain->stage) {
-	case ARM_SMMU_DOMAIN_S1:
-		arm_smmu_make_cdtable_ste(&target, master, &master->cd_table);
-		break;
-	case ARM_SMMU_DOMAIN_S2:
-		arm_smmu_make_s2_domain_ste(&target, master, smmu_domain);
-		break;
-	case ARM_SMMU_DOMAIN_BYPASS:
-		arm_smmu_make_bypass_ste(&target);
-		break;
-	}
-	arm_smmu_write_ste(smmu, sid, dst, &target);
-}
-
 static void arm_smmu_init_bypass_stes(struct arm_smmu_ste *strtab,
 				      unsigned int nent)
 {
@@ -2387,7 +2357,8 @@ arm_smmu_get_step_for_sid(struct arm_smmu_device *smmu, u32 sid)
 	}
 }
 
-static void arm_smmu_install_ste_for_dev(struct arm_smmu_master *master)
+static void arm_smmu_install_ste_for_dev(struct arm_smmu_master *master,
+					 const struct arm_smmu_ste *target)
 {
 	int i, j;
 	struct arm_smmu_device *smmu = master->smmu;
@@ -2404,7 +2375,7 @@ static void arm_smmu_install_ste_for_dev(struct arm_smmu_master *master)
 		if (j < i)
 			continue;
 
-		arm_smmu_write_strtab_ent(master, sid, step);
+		arm_smmu_write_ste(smmu, sid, step, target);
 	}
 }
 
@@ -2511,6 +2482,7 @@ static void arm_smmu_disable_pasid(struct arm_smmu_master *master)
 static void arm_smmu_detach_dev(struct arm_smmu_master *master)
 {
 	unsigned long flags;
+	struct arm_smmu_ste target;
 	struct arm_smmu_domain *smmu_domain = master->domain;
 
 	if (!smmu_domain)
@@ -2524,7 +2496,11 @@ static void arm_smmu_detach_dev(struct arm_smmu_master *master)
 
 	master->domain = NULL;
 	master->ats_enabled = false;
-	arm_smmu_install_ste_for_dev(master);
+	if (disable_bypass)
+		arm_smmu_make_abort_ste(&target);
+	else
+		arm_smmu_make_bypass_ste(&target);
+	arm_smmu_install_ste_for_dev(master, &target);
 	/*
 	 * Clearing the CD entry isn't strictly required to detach the domain
 	 * since the table is uninstalled anyway, but it helps avoid confusion
@@ -2539,6 +2515,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 {
 	int ret = 0;
 	unsigned long flags;
+	struct arm_smmu_ste target;
 	struct iommu_fwspec *fwspec = dev_iommu_fwspec_get(dev);
 	struct arm_smmu_device *smmu;
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
@@ -2600,7 +2577,8 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	list_add(&master->domain_head, &smmu_domain->devices);
 	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
 
-	if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
+	switch (smmu_domain->stage) {
+	case ARM_SMMU_DOMAIN_S1:
 		if (!master->cd_table.cdtab) {
 			ret = arm_smmu_alloc_cd_tables(master);
 			if (ret) {
@@ -2614,9 +2592,17 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 			master->domain = NULL;
 			goto out_list_del;
 		}
-	}
 
-	arm_smmu_install_ste_for_dev(master);
+		arm_smmu_make_cdtable_ste(&target, master, &master->cd_table);
+		break;
+	case ARM_SMMU_DOMAIN_S2:
+		arm_smmu_make_s2_domain_ste(&target, master, smmu_domain);
+		break;
+	case ARM_SMMU_DOMAIN_BYPASS:
+		arm_smmu_make_bypass_ste(&target);
+		break;
+	}
+	arm_smmu_install_ste_for_dev(master, &target);
 
 	arm_smmu_enable_ats(master);
 	goto out_unlock;
-- 
2.43.0

