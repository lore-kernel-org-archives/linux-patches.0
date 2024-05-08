Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2063.outbound.protection.outlook.com [40.107.93.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C72212C80B;
	Wed,  8 May 2024 18:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715194660; cv=fail; b=emfx6xOwgzFUQh0wGN2CtyaY7AKi5KRAxAUwt6wuQTv2sF9K3iBMJmY9pXgvUej+Mv6xaKYWvbRKW+wply0gYW1SRTat6MY9uQYLDN7MMFOg4zexoCyfyG/qoBMwK9yBxBIvYBrhltUmZMM79t5PQy0mSx7yMsBgum4Z+b5ZKRg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715194660; c=relaxed/simple;
	bh=50I5m0Owr0Q+vRaAuB84rGhVyJGTuUUvHBcyF96enF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rOgvbA/Wan02H8XXPzBY6FcWWv3swEsSsmqNHxsogCD0lzgrYjFz2PL+YZsca94SIp1PFHIgl36eNw9etplEUOxiaaCmGEhQwW08PqGEyHkPJjdyfkEWcd9KMlNlHrtjBsllrne+t1AEHtpf+mz8t4u0LXfW1w+VtLbNzne+TK8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=g3rd5H06; arc=fail smtp.client-ip=40.107.93.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="g3rd5H06"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T+NkMlFQB9OAyS6gnFo4Rmggi9IK+dVquUc3uZsNTWBkXV8PTT272aWI6XnYjpxJGZpsFb71IgYrExC5XQi5hqpgnGcfYlm5elkvyrXKJiP+9Nt/riUCfgWPnbyYpYf9WR1Q4JWdF2RteyCzyowDRZ0CkIIfxZq4NfERXqV7alJ+RwATr5v5itpH1hAK2LMSgYU9MMN45og8XbAB6X2AFGNMeKJVnFOabmNJ/w61y7t3O3O+VHIsJ94iJMjGB6ukKOoUAPDDoooExfNDN3iewMhl5ZURMpftuFV3nzbbF9XN9/wJS/6oe6hXXMRzZ25tAxBZcqwqXo896G2x2AsvIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C7v3lutwpuP7PIuMzMt9fFRmd+GNq7ZG2T8w7WcpurA=;
 b=fviiOC8ErGJLgqw4SfUMmEzszmK/XpZyZ5X+Pw728KZ48DFlkEjKtSrVFSraUuEfelJHoLN2XJ9dbS7ZQEebdp7XCtNBLtVBtAO7XJ16/bFWCsPeocGB8HhDC1hAv1xxUEFioIipVz/0RT0Rc5Gr0eCOAHTMATJMIvnmZRI3dA3MUeMjT5SI6GoVYCFkQGvaxt2CPJXU09yREsKmAHcC77Bw7MmJj+F92evnGgCYKH/oKvhuXaFiSoKFJjIpD+QehS8TO8ymzR3nbAf6aA1NGGH+Ad506Qp3nW7DF805m6X0NVzAy6r6FBv00g1zIE99rm4Apdc+8L+nXFg7rMWnDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C7v3lutwpuP7PIuMzMt9fFRmd+GNq7ZG2T8w7WcpurA=;
 b=g3rd5H06gPnvmgDMwYQwuLXASUInMCypqyGJ3Givh1CIybfpydtIt2Dc/DWxi0ppJXLiNaxSIM4gk4zlnhKDHe2pGeeABRg4NFcD1BX3kqSn2rukJnZ5LZWL1KVf9IoSFcdnw67TWKRhCLUtrxId8Bkm//delQOnq74a5Fm1aY/ROlIRuO5lz4xcPS5IcZJQ49sgPb7I3GUP6bo7VB+tIeYRFZ7hxCMs+vk1AdM7NwqbLh3lNvyfddofhqQ0gORHnRMhIvduMSp61Ylj6tWvLRCKnpXSTIUe4GcsX2Q6PaV5qqOclKcSNTsm/9j8MZ86hCWrmImPUWgYp5T+aQ3p/g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by CY8PR12MB7514.namprd12.prod.outlook.com (2603:10b6:930:92::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.46; Wed, 8 May
 2024 18:57:26 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%3]) with mapi id 15.20.7544.045; Wed, 8 May 2024
 18:57:26 +0000
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
Subject: [PATCH v7 04/14] iommu/arm-smmu-v3: Make changing domains be hitless for ATS
Date: Wed,  8 May 2024 15:57:12 -0300
Message-ID: <4-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
In-Reply-To: <0-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0089.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::34) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|CY8PR12MB7514:EE_
X-MS-Office365-Filtering-Correlation-Id: 51730357-9a0a-4f1f-0839-08dc6f90b32d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|7416005|1800799015|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Jh6/0GuedKShb3RTq3vWpUN8fPx0tpPZbKSps/esRuMrM7GxWcWpgA5q5iss?=
 =?us-ascii?Q?3ePI1NtVrTHLBpgfEU4W0s1IoLTILk4DKmWUFEfWmGHD//fFKPAYUCVkioql?=
 =?us-ascii?Q?s/nLSSQH0N8HT0+vc/kJx4iQ2moA9sMwnfz/SXR6g167ySo4qVJkNMHoulOu?=
 =?us-ascii?Q?XZjThkFThRBD0lE+4Sfdqz9wkRdZ03O50stNHDCxxpG7RiZhuVHvu8kl+emC?=
 =?us-ascii?Q?gygVgf/d3S8e2Q6tADrBdGsttEizY1YsfllRIEDaECz+9RT7/KWeGRZe0HKw?=
 =?us-ascii?Q?F+P7mfXpR4/yj6mUohZlLW9Zky87CQM5ItalUlHJlZcMk+lBIprgN+YLpw9Y?=
 =?us-ascii?Q?CF/HpeUM9XNaqBtpy3fSTQgCNfwGSgQNxm8MFQlrObKEB9GMuOKWvHrA8K8u?=
 =?us-ascii?Q?ToBZx/f7VE1Qj8mzzaCQIYQbc7LKeYgycGozHwT0JLWQ33j8/Pj5/rusbU2q?=
 =?us-ascii?Q?CR5aCGjMG0HCwRWY9pS63k3Nhz9pNZANCqJEaJrxcNiDD90MvO2YYTJudEcX?=
 =?us-ascii?Q?eH5r65slKrRE9+8jGBljAgWeuIN0aQuuGcT96WHUI9297ntDuYtJLlR7V3nB?=
 =?us-ascii?Q?8jXaDQpo2W+lJyzY1BnqBzOWUab7LDtbtdQ1J8VWqLr/QP/nX58qK/fgiKRG?=
 =?us-ascii?Q?W0SJfj3s1SpsEAeRcmkc9xYrWVNwgBdOE57icH5+TCHxmhg19JfJ9loCbOOw?=
 =?us-ascii?Q?xPG4ObmPjPLIc89oVq8qQX4FPPUwZvCPsPN0SZDC2mn9Q8v4o0pC3RPXxJHt?=
 =?us-ascii?Q?SuWcNIGa2Vk2lb4Tg0M1Lgp/TnUh1sWM/CsQ4LTt7NXH46uvFNxA9QVN9pYR?=
 =?us-ascii?Q?gTMxXBxtHAxwB0LpqPawRyf6qSIYnXfRalRfCOvsTmn4aK1XFfA88tmrPq+B?=
 =?us-ascii?Q?7spgN23NXY38YpDEU6hrlWoyV9MOhx2NdpzaguFo+fUwQw8w3tjvz0dyP5sv?=
 =?us-ascii?Q?RTX7WeV68enOE7zlcrG//l3MZk3srJy4zY4Q66Fj82wAxecP/YrmKdH8+OPB?=
 =?us-ascii?Q?xKMZbYqQXAwXAqQHJa1wYvT9i99JIj6faTa6UW0m4eGHC8xilcoQIIeL7CDp?=
 =?us-ascii?Q?JECDB5qhYHwYPXbQ/JGzy/7ndwoJGH/MFIiyEcO+vh1wcHAlVnDqBI8KcEGl?=
 =?us-ascii?Q?NMuw5AzQy4oFkBEPnsM35rJiDI+UZV7NVoyaSzV60BtMB7EMYtcx+U4oaMX9?=
 =?us-ascii?Q?ldHKvbCiSYoGmGIwTz4loHwJOm3PqjFC7fPpVHCigxkhSe9MQU3HH3xwclW6?=
 =?us-ascii?Q?KTP3x1PMHzoSdrzYlw8vOnyYxrD8Y7hMbpkpBBznaQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CYaWQo2TgLeCyro/D4uua6gkqQInEuaDGaQmI88VEFg9auKutUssBQMbE8NO?=
 =?us-ascii?Q?y/fsK/KepEUreVNSnZq+SreqkEHQZ2aIJPZHsErFDfadQqsj0XBNrbK5Jluz?=
 =?us-ascii?Q?oraWsz4+jxLi4rGswg7ECuD3qTtiT/QzbDZyyGn9J9z9MIxDV5cxxoV2Q3bH?=
 =?us-ascii?Q?mHE94qCRZnqyG/9py1rVwT1mo8oIb0DpLn0GkNpTXMfEseTmtSAjpLATPC11?=
 =?us-ascii?Q?AeVLH46kGy/uXWWRQNF2NpkFB0ipfMYIQJlFVrJUXm0N9Kcb+9uyS58xzkJ5?=
 =?us-ascii?Q?R9odnjj0kNaWC07XZm43ZQDkV5fmfB++tLD2EY+/lPn65wZda+chaS9PhsJi?=
 =?us-ascii?Q?EUipyOFCG6zzpgrlcH0A4S087yHJ9XrNpXFTT8bodR8DzcpmU0KxCputr7Cb?=
 =?us-ascii?Q?dS7sjAtMv+c14pmP/Gz9NquHUbQZZgBQZLQbSQXD+Es+tGvkI/LLo6ZLMiBE?=
 =?us-ascii?Q?u6R91hj7IDxARJD98ZCfBz3dCkp+cr9i5eeyCd7aZjOpBw79lNXZ1yeWpZnw?=
 =?us-ascii?Q?17sIvqGNNxlxk/xqxcK2mXXgquBXAtIRyTS/7pFVPa+btB5je5fKa4HzvIyl?=
 =?us-ascii?Q?1sMMY4fAJduRKk37pn+FmpCj6rwReCrVGh4UjuAz0dbPAp/B+01VUjmVReoA?=
 =?us-ascii?Q?O0dUIUkTUjkoyIDF1wfVJFvMUBZkNuj0f4v/mhhos8hNvI6Ji9JQV3XQlviB?=
 =?us-ascii?Q?O5obEbCrTlJkCCkxpIye5TIKbgE9YzdLMCsMpz09d4uXbAad93h6W2GIsxio?=
 =?us-ascii?Q?d5qT62kVOReKZ5JVL8as0q9m9EW3ZznGoJLoJvMMchn5bDQzeCk62lPaCkZI?=
 =?us-ascii?Q?E8JiA8+byrrjpOwxhCHnJqd7GUdGyWtfgljcvnOZobWmf23Mc80UpDzZAfYQ?=
 =?us-ascii?Q?AI7p28JPHdX1BFPJMJg2wmJJcPrzoTe3gSLg4pqhS9GrBOAaXzbuAyGTDWZ9?=
 =?us-ascii?Q?TyBUuw3qYsiDQA5gqJQTuLZMqS8L06D1sK6bB9bSQ04F9SEo+vIzAE9bncUH?=
 =?us-ascii?Q?gFolcfQnCCFVElP5iRrRRR0wQ2K1nLiQOBuRierQJBKAF/5xoXY2f/+mKLYf?=
 =?us-ascii?Q?MUQ8pmdfV3WCWBqvRYj/30B/P3G4R4msHjhwfjPtID2K8GzajJ6QO6xSHo4x?=
 =?us-ascii?Q?B2UhO/fIVtRzJlkuroCG58X5/H4N9nByMfuJ9Ogv6NssPrlaXXGDJxCZ/x4q?=
 =?us-ascii?Q?eyuQn5O66gdcnvKDg2rZNEtuFeJBe6WLx76BaHfR1WIzj0YGs381IAYl+lHy?=
 =?us-ascii?Q?7gBMvHGqynj91KFP0mjgwJAOBpPCTpGbchpPPtnp0eNMI+VeMXJzDDc6EJ+J?=
 =?us-ascii?Q?AaCaFJv9N5fmFKPCcuQDnYfn21x0weTo8l3EnVTgW1VvRgC/2YQAQZWLdYMN?=
 =?us-ascii?Q?LTmjFfaccZcWnz86PpYYLFIDD3mtHpTdKbS7TZqLuFm37a+Dc5AVvP7IWea1?=
 =?us-ascii?Q?l17Y3qKS64NhEl21mMovH1iHXV/7ZcFgra0lkK7PFNg7sgO91/aw35PwpWCn?=
 =?us-ascii?Q?JLrMja8nR9Jzr4OV5MwyrG0dpJM7G+xrJLMcFSSLB/QDN67IQfI9oxO3jWRY?=
 =?us-ascii?Q?HJ7zEeVAF2AzQ5R/kB+nFfKtV0y48QbPI9tbqIfg?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51730357-9a0a-4f1f-0839-08dc6f90b32d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2024 18:57:25.6144
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WXK50U06CVW1uToGixz63FrZfOe7ENyt71pA9RAgX0gjTOAMcu+KUjrdw5Hgj5Im
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7514

The core code allows the domain to be changed on the fly without a forced
stop in BLOCKED/IDENTITY. In this flow the driver should just continually
maintain the ATS with no change while the STE is updated.

ATS relies on a linked list smmu_domain->devices to keep track of which
masters have the domain programmed, but this list is also used by
arm_smmu_share_asid(), unrelated to ats.

Create two new functions to encapsulate this combined logic:
 arm_smmu_attach_prepare()
 <caller generates and sets the STE>
 arm_smmu_attach_commit()

The two functions can sequence both enabling ATS and disabling across
the STE store. Have every update of the STE use this sequence.

Installing a S1/S2 domain always enables the ATS if the PCIe device
supports it.

The enable flow is now ordered differently to allow it to be hitless:

 1) Add the master to the new smmu_domain->devices list
 2) Program the STE
 3) Enable ATS at PCIe
 4) Remove the master from the old smmu_domain

This flow ensures that invalidations to either domain will generate an ATC
invalidation to the device while the STE is being switched. Thus we don't
need to turn off the ATS anymore for correctness.

The disable flow is the reverse:
 1) Disable ATS at PCIe
 2) Program the STE
 3) Invalidate the ATC
 4) Remove the master from the old smmu_domain

Move the nr_ats_masters adjustments to be close to the list
manipulations. It is a count of the number of ATS enabled masters
currently in the list. This is stricly before and after the STE/CD are
revised, and done under the list's spin_lock.

This is part of the bigger picture to allow changing the RID domain while
a PASID is in use. If a SVA PASID is relying on ATS to function then
changing the RID domain cannot just temporarily toggle ATS off without
also wrecking the SVA PASID. The new infrastructure here is organized so
that the PASID attach/detach flows will make use of it as well in
following patches.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c  |   5 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 201 +++++++++++++-----
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |   6 +-
 3 files changed, 149 insertions(+), 63 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
index 315e487fd990eb..a460b71f585789 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
@@ -164,7 +164,7 @@ static void arm_smmu_test_make_cdtable_ste(struct arm_smmu_ste *ste,
 		.smmu = &smmu,
 	};
 
-	arm_smmu_make_cdtable_ste(ste, &master);
+	arm_smmu_make_cdtable_ste(ste, &master, true);
 }
 
 static void arm_smmu_v3_write_ste_test_bypass_to_abort(struct kunit *test)
@@ -231,7 +231,6 @@ static void arm_smmu_test_make_s2_ste(struct arm_smmu_ste *ste,
 {
 	struct arm_smmu_master master = {
 		.smmu = &smmu,
-		.ats_enabled = ats_enabled,
 	};
 	struct io_pgtable io_pgtable = {};
 	struct arm_smmu_domain smmu_domain = {
@@ -247,7 +246,7 @@ static void arm_smmu_test_make_s2_ste(struct arm_smmu_ste *ste,
 	io_pgtable.cfg.arm_lpae_s2_cfg.vtcr.sl = 3;
 	io_pgtable.cfg.arm_lpae_s2_cfg.vtcr.tsz = 4;
 
-	arm_smmu_make_s2_domain_ste(ste, &master, &smmu_domain);
+	arm_smmu_make_s2_domain_ste(ste, &master, &smmu_domain, ats_enabled);
 }
 
 static void arm_smmu_v3_write_ste_test_s2_to_abort(struct kunit *test)
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 532fe17f28bfe5..01e970f6ee4363 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1538,7 +1538,7 @@ EXPORT_SYMBOL_IF_KUNIT(arm_smmu_make_bypass_ste);
 
 VISIBLE_IF_KUNIT
 void arm_smmu_make_cdtable_ste(struct arm_smmu_ste *target,
-			       struct arm_smmu_master *master)
+			       struct arm_smmu_master *master, bool ats_enabled)
 {
 	struct arm_smmu_ctx_desc_cfg *cd_table = &master->cd_table;
 	struct arm_smmu_device *smmu = master->smmu;
@@ -1561,7 +1561,7 @@ void arm_smmu_make_cdtable_ste(struct arm_smmu_ste *target,
 			 STRTAB_STE_1_S1STALLD :
 			 0) |
 		FIELD_PREP(STRTAB_STE_1_EATS,
-			   master->ats_enabled ? STRTAB_STE_1_EATS_TRANS : 0));
+			   ats_enabled ? STRTAB_STE_1_EATS_TRANS : 0));
 
 	if (smmu->features & ARM_SMMU_FEAT_E2H) {
 		/*
@@ -1591,7 +1591,8 @@ EXPORT_SYMBOL_IF_KUNIT(arm_smmu_make_cdtable_ste);
 VISIBLE_IF_KUNIT
 void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
 				 struct arm_smmu_master *master,
-				 struct arm_smmu_domain *smmu_domain)
+				 struct arm_smmu_domain *smmu_domain,
+				 bool ats_enabled)
 {
 	struct arm_smmu_s2_cfg *s2_cfg = &smmu_domain->s2_cfg;
 	const struct io_pgtable_cfg *pgtbl_cfg =
@@ -1608,7 +1609,7 @@ void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
 
 	target->data[1] = cpu_to_le64(
 		FIELD_PREP(STRTAB_STE_1_EATS,
-			   master->ats_enabled ? STRTAB_STE_1_EATS_TRANS : 0));
+			   ats_enabled ? STRTAB_STE_1_EATS_TRANS : 0));
 
 	if (smmu->features & ARM_SMMU_FEAT_ATTR_TYPES_OVR)
 		target->data[1] |= cpu_to_le64(FIELD_PREP(STRTAB_STE_1_SHCFG,
@@ -2450,22 +2451,16 @@ static bool arm_smmu_ats_supported(struct arm_smmu_master *master)
 	return dev_is_pci(dev) && pci_ats_supported(to_pci_dev(dev));
 }
 
-static void arm_smmu_enable_ats(struct arm_smmu_master *master,
-				struct arm_smmu_domain *smmu_domain)
+static void arm_smmu_enable_ats(struct arm_smmu_master *master)
 {
 	size_t stu;
 	struct pci_dev *pdev;
 	struct arm_smmu_device *smmu = master->smmu;
 
-	/* Don't enable ATS at the endpoint if it's not enabled in the STE */
-	if (!master->ats_enabled)
-		return;
-
 	/* Smallest Translation Unit: log2 of the smallest supported granule */
 	stu = __ffs(smmu->pgsize_bitmap);
 	pdev = to_pci_dev(master->dev);
 
-	atomic_inc(&smmu_domain->nr_ats_masters);
 	/*
 	 * ATC invalidation of PASID 0 causes the entire ATC to be flushed.
 	 */
@@ -2474,22 +2469,6 @@ static void arm_smmu_enable_ats(struct arm_smmu_master *master,
 		dev_err(master->dev, "Failed to enable ATS (STU %zu)\n", stu);
 }
 
-static void arm_smmu_disable_ats(struct arm_smmu_master *master,
-				 struct arm_smmu_domain *smmu_domain)
-{
-	if (!master->ats_enabled)
-		return;
-
-	pci_disable_ats(to_pci_dev(master->dev));
-	/*
-	 * Ensure ATS is disabled at the endpoint before we issue the
-	 * ATC invalidation via the SMMU.
-	 */
-	wmb();
-	arm_smmu_atc_inv_master(master);
-	atomic_dec(&smmu_domain->nr_ats_masters);
-}
-
 static int arm_smmu_enable_pasid(struct arm_smmu_master *master)
 {
 	int ret;
@@ -2553,39 +2532,147 @@ arm_smmu_find_master_domain(struct arm_smmu_domain *smmu_domain,
 	return NULL;
 }
 
-static void arm_smmu_detach_dev(struct arm_smmu_master *master)
+/*
+ * If the domain uses the smmu_domain->devices list return the arm_smmu_domain
+ * structure, otherwise NULL. These domains track attached devices so they can
+ * issue invalidations.
+ */
+static struct arm_smmu_domain *
+to_smmu_domain_devices(struct iommu_domain *domain)
 {
-	struct iommu_domain *domain = iommu_get_domain_for_dev(master->dev);
+	/* The domain can be NULL only when processing the first attach */
+	if (!domain)
+		return NULL;
+	if (domain->type & __IOMMU_DOMAIN_PAGING)
+		return to_smmu_domain(domain);
+	return NULL;
+}
+
+static void arm_smmu_remove_master_domain(struct arm_smmu_master *master,
+					  struct iommu_domain *domain)
+{
+	struct arm_smmu_domain *smmu_domain = to_smmu_domain_devices(domain);
 	struct arm_smmu_master_domain *master_domain;
-	struct arm_smmu_domain *smmu_domain;
 	unsigned long flags;
 
-	if (!domain || !(domain->type & __IOMMU_DOMAIN_PAGING))
+	if (!smmu_domain)
 		return;
 
-	smmu_domain = to_smmu_domain(domain);
-	arm_smmu_disable_ats(master, smmu_domain);
-
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
 	master_domain = arm_smmu_find_master_domain(smmu_domain, master);
 	if (master_domain) {
 		list_del(&master_domain->devices_elm);
 		kfree(master_domain);
+		if (master->ats_enabled)
+			atomic_dec(&smmu_domain->nr_ats_masters);
 	}
 	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
+}
 
-	master->ats_enabled = false;
+struct attach_state {
+	bool want_ats;
+	bool disable_ats;
+	struct iommu_domain *old_domain;
+};
+
+/*
+ * Prepare to attach a domain to a master. If disable_ats is not set this will
+ * turn on ATS if supported. smmu_domain can be NULL if the domain being
+ * attached does not have a page table and does not require invalidation
+ * tracking.
+ */
+static int arm_smmu_attach_prepare(struct arm_smmu_master *master,
+				   struct iommu_domain *domain,
+				   struct attach_state *state)
+{
+	struct arm_smmu_domain *smmu_domain =
+		to_smmu_domain_devices(domain);
+	struct arm_smmu_master_domain *master_domain;
+	unsigned long flags;
+
+	/*
+	 * arm_smmu_share_asid() must not see two domains pointing to the same
+	 * arm_smmu_master_domain contents otherwise it could randomly write one
+	 * or the other to the CD.
+	 */
+	lockdep_assert_held(&arm_smmu_asid_lock);
+
+	state->want_ats = !state->disable_ats && arm_smmu_ats_supported(master);
+
+	if (smmu_domain) {
+		master_domain = kzalloc(sizeof(*master_domain), GFP_KERNEL);
+		if (!master_domain)
+			return -ENOMEM;
+		master_domain->master = master;
+
+		/*
+		 * During prepare we want the current smmu_domain and new
+		 * smmu_domain to be in the devices list before we change any
+		 * HW. This ensures that both domains will send ATS
+		 * invalidations to the master until we are done.
+		 *
+		 * It is tempting to make this list only track masters that are
+		 * using ATS, but arm_smmu_share_asid() also uses this to change
+		 * the ASID of a domain, unrelated to ATS.
+		 *
+		 * Notice if we are re-attaching the same domain then the list
+		 * will have two identical entries and commit will remove only
+		 * one of them.
+		 */
+		spin_lock_irqsave(&smmu_domain->devices_lock, flags);
+		if (state->want_ats)
+			atomic_inc(&smmu_domain->nr_ats_masters);
+		list_add(&master_domain->devices_elm, &smmu_domain->devices);
+		spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
+	}
+
+	if (!state->want_ats && master->ats_enabled) {
+		pci_disable_ats(to_pci_dev(master->dev));
+		/*
+		 * This is probably overkill, but the config write for disabling
+		 * ATS should complete before the STE is configured to generate
+		 * UR to avoid AER noise.
+		 */
+		wmb();
+	}
+	return 0;
+}
+
+/*
+ * Commit is done after the STE/CD are configured with the EATS setting. It
+ * completes synchronizing the PCI device's ATC and finishes manipulating the
+ * smmu_domain->devices list.
+ */
+static void arm_smmu_attach_commit(struct arm_smmu_master *master,
+				   struct attach_state *state)
+{
+	lockdep_assert_held(&arm_smmu_asid_lock);
+
+	if (state->want_ats && !master->ats_enabled) {
+		arm_smmu_enable_ats(master);
+	} else if (master->ats_enabled) {
+		/*
+		 * The translation has changed, flush the ATC. At this point the
+		 * SMMU is translating for the new domain and both the old&new
+		 * domain will issue invalidations.
+		 */
+		arm_smmu_atc_inv_master(master);
+	}
+	master->ats_enabled = state->want_ats;
+
+	arm_smmu_remove_master_domain(master, state->old_domain);
 }
 
 static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 {
 	int ret = 0;
-	unsigned long flags;
 	struct arm_smmu_ste target;
 	struct iommu_fwspec *fwspec = dev_iommu_fwspec_get(dev);
 	struct arm_smmu_device *smmu;
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
-	struct arm_smmu_master_domain *master_domain;
+	struct attach_state state = {
+		.old_domain = iommu_get_domain_for_dev(dev),
+	};
 	struct arm_smmu_master *master;
 	struct arm_smmu_cd *cdptr;
 
@@ -2622,11 +2709,6 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 			return -ENOMEM;
 	}
 
-	master_domain = kzalloc(sizeof(*master_domain), GFP_KERNEL);
-	if (!master_domain)
-		return -ENOMEM;
-	master_domain->master = master;
-
 	/*
 	 * Prevent arm_smmu_share_asid() from trying to change the ASID
 	 * of either the old or new domain while we are working on it.
@@ -2635,13 +2717,11 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	 */
 	mutex_lock(&arm_smmu_asid_lock);
 
-	arm_smmu_detach_dev(master);
-
-	master->ats_enabled = arm_smmu_ats_supported(master);
-
-	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
-	list_add(&master_domain->devices_elm, &smmu_domain->devices);
-	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
+	ret = arm_smmu_attach_prepare(master, domain, &state);
+	if (ret) {
+		mutex_unlock(&arm_smmu_asid_lock);
+		return ret;
+	}
 
 	switch (smmu_domain->stage) {
 	case ARM_SMMU_DOMAIN_S1: {
@@ -2650,18 +2730,19 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 		arm_smmu_make_s1_cd(&target_cd, master, smmu_domain);
 		arm_smmu_write_cd_entry(master, IOMMU_NO_PASID, cdptr,
 					&target_cd);
-		arm_smmu_make_cdtable_ste(&target, master);
+		arm_smmu_make_cdtable_ste(&target, master, state.want_ats);
 		arm_smmu_install_ste_for_dev(master, &target);
 		break;
 	}
 	case ARM_SMMU_DOMAIN_S2:
-		arm_smmu_make_s2_domain_ste(&target, master, smmu_domain);
+		arm_smmu_make_s2_domain_ste(&target, master, smmu_domain,
+					    state.want_ats);
 		arm_smmu_install_ste_for_dev(master, &target);
 		arm_smmu_clear_cd(master, IOMMU_NO_PASID);
 		break;
 	}
 
-	arm_smmu_enable_ats(master, smmu_domain);
+	arm_smmu_attach_commit(master, &state);
 	mutex_unlock(&arm_smmu_asid_lock);
 	return 0;
 }
@@ -2690,10 +2771,13 @@ void arm_smmu_remove_pasid(struct arm_smmu_master *master,
 	arm_smmu_clear_cd(master, pasid);
 }
 
-static int arm_smmu_attach_dev_ste(struct device *dev,
-				   struct arm_smmu_ste *ste)
+static int arm_smmu_attach_dev_ste(struct iommu_domain *domain,
+				   struct device *dev, struct arm_smmu_ste *ste)
 {
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
+	struct attach_state state = {
+		.old_domain = iommu_get_domain_for_dev(dev),
+	};
 
 	if (arm_smmu_master_sva_enabled(master))
 		return -EBUSY;
@@ -2711,9 +2795,10 @@ static int arm_smmu_attach_dev_ste(struct device *dev,
 	 * the stream (STE.EATS == 0b00), causing F_BAD_ATS_TREQ and
 	 * F_TRANSL_FORBIDDEN events (IHI0070Ea 5.2 Stream Table Entry).
 	 */
-	arm_smmu_detach_dev(master);
-
+	state.disable_ats = true;
+	arm_smmu_attach_prepare(master, domain, &state);
 	arm_smmu_install_ste_for_dev(master, ste);
+	arm_smmu_attach_commit(master, &state);
 	mutex_unlock(&arm_smmu_asid_lock);
 
 	/*
@@ -2732,7 +2817,7 @@ static int arm_smmu_attach_dev_identity(struct iommu_domain *domain,
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
 
 	arm_smmu_make_bypass_ste(master->smmu, &ste);
-	return arm_smmu_attach_dev_ste(dev, &ste);
+	return arm_smmu_attach_dev_ste(domain, dev, &ste);
 }
 
 static const struct iommu_domain_ops arm_smmu_identity_ops = {
@@ -2750,7 +2835,7 @@ static int arm_smmu_attach_dev_blocked(struct iommu_domain *domain,
 	struct arm_smmu_ste ste;
 
 	arm_smmu_make_abort_ste(&ste);
-	return arm_smmu_attach_dev_ste(dev, &ste);
+	return arm_smmu_attach_dev_ste(domain, dev, &ste);
 }
 
 static const struct iommu_domain_ops arm_smmu_blocked_ops = {
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 125b52ea5ad71c..ce01d3fc768ad6 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -758,10 +758,12 @@ void arm_smmu_make_abort_ste(struct arm_smmu_ste *target);
 void arm_smmu_make_bypass_ste(struct arm_smmu_device *smmu,
 			      struct arm_smmu_ste *target);
 void arm_smmu_make_cdtable_ste(struct arm_smmu_ste *target,
-			       struct arm_smmu_master *master);
+			       struct arm_smmu_master *master,
+			       bool ats_enabled);
 void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
 				 struct arm_smmu_master *master,
-				 struct arm_smmu_domain *smmu_domain);
+				 struct arm_smmu_domain *smmu_domain,
+				 bool ats_enabled);
 void arm_smmu_make_sva_cd(struct arm_smmu_cd *target,
 			  struct arm_smmu_master *master, struct mm_struct *mm,
 			  u16 asid);
-- 
2.43.2

