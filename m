Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2082.outbound.protection.outlook.com [40.107.223.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E5F612CD8E;
	Wed,  8 May 2024 18:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715194666; cv=fail; b=pljPSF3XXsfTh7RBa73mUPyH9/RQklEW9B+J2Y7p/TeXZhZIQtnTUntfR+bj9QpVxZjX2hbokzSw+iebTC4X9dmOv5lb0Y883g0We4jTvgIIgFzxUuTKmqb7Q6jjiUQIf3TKDrzc2Frop2ODQt56vs6GkJKvCm9j5sT01nFRNp0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715194666; c=relaxed/simple;
	bh=yeLZme12TzXA+1BCDLJNLQMtrzLex1ugUiTWNRCTT24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jfcVMI5YduBU7x1yo6lkgqAQUzkS/5zg+RoDWgiPpnVDQhDIa7FcSR5dOZJXgP8IFM0MVVWXk8DjM3B+U4zThZvxr+jf093rqEs20tolxfFEBpkLjdjE+uhD/J9wbFzan3RSkV5ICa0c1obmGNmnZDdAU9Bsa4tHjtPrCwVXJRo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=lj2ZiNwi; arc=fail smtp.client-ip=40.107.223.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lj2ZiNwi"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d3yXwJ1+7HkoBotx4gFjdkrDOmXICBqQ3LSWgGXjVkrvqYXcKuxbB/uYd5kr9PRvrqdhF0+SQXBdraoX+1z1v0qSyz7loGDzT4Dwn128q6CC8NHHf/DpQ3ZwrH0RixoOFWOwiVfvURJ8qAyVhwoA/clgsKLxKJAWyW7n88zzmJeNB1Rz5FjD3oF8Ooa387UOLHFmr6oEeAkPmo4b7yWpn5rrfkwVOgJG8kjYNGZjaOPelxNeAk1fu8waRgWx/7e6w0ymL+AdyViPz7RdTnQQrNjfRqh75q/IVDo8opP1Ldz5CI+GhUx8KgUZE5jV99GKWkLVsXuSa/brlNyLQNWllA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rHrDdFn03CQuhDxPeEhiYssYd1GLkbrfxQW7fV56mbw=;
 b=RtPNvZ6Rm8EZyH/R6apwuYY2trrifF2OqVFEPIxG3cmVO6H03UYyzVqqg7o8Ak/bq4py66UEYsSOwt1cxSX58ndIFDlJ8W18Xv8+a7rounF8xNeA5AUBjQyR3AQv1jAVRcL4YpgmjMtcdENjEQ0UzgNyadJb4YR29NhWL4aor7ygnQk6Sd8XERwHCzHrDlYOBEp2DeNgqvjWWRfjSynM1py50+RIOVFWB37XWk/CM39fXvGgjX7/KtEnVkqih/XqR+N5sM+gr0yg0SN52Oc107V/z9lUvMfASR0gTNxDnFvCx8r5oZvMG7ragz2IMH/Bp07FfTp1QJeMvg6XY+a94Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rHrDdFn03CQuhDxPeEhiYssYd1GLkbrfxQW7fV56mbw=;
 b=lj2ZiNwi3w+d9u5jrrbKNMAufuiWmW3m8AJVQ6lUDUlZ/4husuv8BQ6GDWQu5rECcmAFyR0G4Mp2n2SVV1y55JJW5YQoCRU10l4qIVPAly/nVXHxs9KgTOgpwN/n8i30dH1wYtyFHCPGEQZiTk9t1RGxLyD0YpcLV9mi5X9ud38TUoiAjAg2SRI4oDRFpfqiDHPXMjSWKJ4OwnTxUIFpx1q1/+IfkU91odgs6p694lOvomc+OAstMAS1CsRMuYL7QXEcTqMY/WJnGuShXfKuq3aQA2GyBguQAsxYklg0cPRKniIdMy3pPLnm1gnMWEyrJpNyzxi4RxqDrGoGeNXUWw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by CY8PR12MB7514.namprd12.prod.outlook.com (2603:10b6:930:92::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.46; Wed, 8 May
 2024 18:57:28 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%3]) with mapi id 15.20.7544.045; Wed, 8 May 2024
 18:57:28 +0000
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
Subject: [PATCH v7 03/14] iommu/arm-smmu-v3: Make smmu_domain->devices into an allocated list
Date: Wed,  8 May 2024 15:57:11 -0300
Message-ID: <3-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
In-Reply-To: <0-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P222CA0019.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::24) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|CY8PR12MB7514:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a8b830b-0119-483b-0b3e-08dc6f90b4ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|7416005|1800799015|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?UtzU34EGnFMsrT7sciCUnzpPdQSoY7na+OCmGat+Zb3IrSt3pCO7nrjzRW/r?=
 =?us-ascii?Q?zTRu2KWMe8oh2/38cADVOUfwZKSDZVDwFfaqTQJKlX3fp5OStGJ9hqdkWNky?=
 =?us-ascii?Q?HrbYU+C4gh9Ogq5w/3wYuj33l2zNVvoVombhY1MpKWa2ViSOG7+nIvnIBS5Q?=
 =?us-ascii?Q?rdBqZWKHurAqtu2xhMIcgNSilXjw/pibe8cbSsdefRHFr/MhbQYyzYt67m87?=
 =?us-ascii?Q?1pTbSuJmHyquczSyIBacUcFC4tCVr04gqvVBu1sFIoX7KlZljhrqNwDBscPa?=
 =?us-ascii?Q?5Z3zgqhoffVg5m+tLQzyo4eXBiAFTAZNfsbLIz9xqtR7lHL0OaEeH+/tm1u8?=
 =?us-ascii?Q?gmccaCTfKdlM/GrDhq6qS58w7APw89gqcMYNEyHt4hJtod6K7MJHoYc2xmSq?=
 =?us-ascii?Q?gkShA/rj/LdBJdxTSbQYRYBlfAeKmC9ukufZT0UuD/jQg5Rif5vDdcLZdH+s?=
 =?us-ascii?Q?CQ69MtqbvuYxowX1O1LmFWKVcIaxTgxXxYmQJ7GxK45mXNjk9B143xZ0i5AO?=
 =?us-ascii?Q?cTQpUOLk4iyfHXREgQpKdogITxEAzm91kKd2d8GEuFtjLLjTUHwLetlbK2oL?=
 =?us-ascii?Q?XURnSH4xJk6aRvMXESGvNv2KvqU9mQQzwmVNo1662HRAEgZAzJtRF09/Hot4?=
 =?us-ascii?Q?+Is6R/L3vDSjPtGg+5k+T6IexbNlwvBm8AES7i53rfHY+4uFUFMj7fat34L3?=
 =?us-ascii?Q?UMkVu4WKtlsI+up1DbFcqhq6dZZ8UkIhfzdcuCuIi36ZaGSzozZo0OcGHnR3?=
 =?us-ascii?Q?UUGSbKurNwxI4LDPgelYX7gpSgBvo6/vsqvEbCZS95pYcXEV6Vw6EoxGiptU?=
 =?us-ascii?Q?AcBIUWk7flo3a1yY2vs53CBuvctrTuvFK6/PgTBvsYq9ViianmtPUhgDLWrM?=
 =?us-ascii?Q?/6BJaHmByP4FxzX4MdytLJ10cDTMQMa5s/D2ABEGZxZ6be08sOm75XpT9o5n?=
 =?us-ascii?Q?TY9YDZnzXnk7/C9hr1BJFSWxB7xfH2l6SyVxgfaEVB5LHCAvXVQdxMHynlq0?=
 =?us-ascii?Q?gsY2J6UIGnD4EmfWxaHkQsEnfO2EgS1s5Odd4NUaSIoe+jlK4uphO46i4pIt?=
 =?us-ascii?Q?SJBctQRbsZ/cXiWsocwhUY8Y7iwUgMVQXt+1eIlH3R6+YK5C0wf5tKnxRO4/?=
 =?us-ascii?Q?IEdoEc6sfTe7tLTlpaJy9APZXy2pgB89rzQOcMGhf+xrqjjj+mFutxHrL4JG?=
 =?us-ascii?Q?kZrd8EehV64JXymBwPdouH7UwJ+CuUDPy9s8xbGmikq4srSieFrLp1pmh9tG?=
 =?us-ascii?Q?vgax0TXcmVka3Pv7HdRmHDsp/TnGSoIyWkrUPrSEyA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yLk8VkRKbWos/R3PU8gnzSs1x7jhRGM23WavjnvtVj7onrMU/BDQed9RPKu3?=
 =?us-ascii?Q?YeMZs6VZSYnVoWt2Z1Frk3H159zAz0GLqzPTfnxXqIw0DEcCiHOpuJRn+oqq?=
 =?us-ascii?Q?WvSuhK61lATMXJiKyy9NZ+5nv5ad2MnIpHO12toHaO6LCpHCWtybU59OQOAh?=
 =?us-ascii?Q?u+ckrIYUIL1P1+JGiJajdaXk/z634t7KncVSd3JIXE82zYhIBRpBhG0AoDID?=
 =?us-ascii?Q?J9IgF0f1M/ACU34Lf9y1+Ot1Wfah9hZiYDKTPcF5cKNyF+iW924lA1IrMOWL?=
 =?us-ascii?Q?1OtUtOgMUKHeeQ89BcTZj73x9BIkTWQ3TMXhKEIZ/PZnGdt5osiD73mkRGCK?=
 =?us-ascii?Q?reSflg/JNK+SUX+UB2TaJzUN53gZ9g0DrHXwHBXTKG8GAg6P89u8+y9LPwRw?=
 =?us-ascii?Q?TzvyrwV2pE/Y9N2QBYgAS4IvE5DZTwVVepPqyV/TUXsdd56nNkR+iyX7ofef?=
 =?us-ascii?Q?VV3qLo+0qHVJjq89/El050MZfRujsrqMOT4Sv25udmBwwJdsCTZiskfwGvef?=
 =?us-ascii?Q?BYhI8qzauternNeGUQ+2/xfAa+fsDrT+cfosx6ojgoNF6x684vEbBcGlipC2?=
 =?us-ascii?Q?CSKxdLa0QO7BSb4Xn4GpY2jeoMdAXNkzPQNLnhyU8afWZKifsCXiZMopG9F+?=
 =?us-ascii?Q?r8VtPPx1B+VQ+evZ9Zd6Fp+4z1hypw9qhmN/mBWmBqF0keGXQZQixm2xRy7y?=
 =?us-ascii?Q?y6vBtfvVPOCcUdDHZL2MDEqTuATbEMkxZZEKqFiM+MCIyLJLo3ZV7WGGorfR?=
 =?us-ascii?Q?AsDr269tdsUTPxQc2CjvHi1fU3pQqf2Qh4VoOcSMdZ5YnB90sUGN5jurrA5K?=
 =?us-ascii?Q?+aeDAkEflmfFXk5d1zseVxfuqhZhBgldCJh+29UaP02yiGOZeBmzkEAmQ2MU?=
 =?us-ascii?Q?8AilmJTO9BPCSh7nxfk1zbxkOTtV2lUgwFyE9HQ7gnJMtk4MDgmi381QFkFj?=
 =?us-ascii?Q?zKpjRDSfc4kRRPe5xSf2mir73Iyd1Wn82sNoWiiqL36AQo+xSElS9kwalVJu?=
 =?us-ascii?Q?riOndKDPpuW3ZgkF542jblWRn0AOxA/50md2JsQtvQRc3pZOOk7gMYv+IcP9?=
 =?us-ascii?Q?cbhRj+71wvZS/QLMqroTvpsibaZDmoAR1fT59ZrQSPECWwKfx9wManawsrUr?=
 =?us-ascii?Q?dkH1FM5mD37Fr/mIwhxS+e/yMo1F6OmfRMo4wKcudZI+YOkFGMSxrSVMqZT6?=
 =?us-ascii?Q?WkFqHq1A2PB/psRIsFqs+9liTtHMLHUiVte0ZWKlkltPK6CyFbkv1nFIDP6Y?=
 =?us-ascii?Q?bxhqW+Xg2Nc6a6mAqUy1lO3ceQGDT8pMORlaSfjOy3da4kDkIV5PPGhsLYB9?=
 =?us-ascii?Q?08G3LY/TWEeI4+crgXDtx4HQWjdFol6euwKP/yClOdzNhC+kNAVqJjFnkT0S?=
 =?us-ascii?Q?ayTh8D3/Dwu7sBUPtsjeOXKRnTzh8hxhJFV/KC6Eorb9yLVF84P6DYQquehK?=
 =?us-ascii?Q?yP2rJNeqdn6qE0Dem7akBqLIXGQTCCDn8FxTp/rn9kfpuBoVzcBs/nWqXhW+?=
 =?us-ascii?Q?WGuFN/Nx4Yw4XVDuPjXK0KyOAIxUT5sGdalJugcR4a85xOnHLHoMZwEPFYPX?=
 =?us-ascii?Q?J37QZvfi6fCI1PcFjnz8gEqNo2vjmoxzDO7mCmw/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a8b830b-0119-483b-0b3e-08dc6f90b4ac
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2024 18:57:27.8613
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cL/LDchzLo52h4Rp32bmnnC7H+OZSwbV66+xxXQcPv3hhLemq3sf3a7FlZL8VRxK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7514

The next patch will need to store the same master twice (with different
SSIDs), so allocate memory for each list element.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Reviewed-by: Michael Shavit <mshavit@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 11 ++++--
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 39 ++++++++++++++++---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  7 +++-
 3 files changed, 47 insertions(+), 10 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 71ca87c2c5c3b6..cb3a0e4143c84a 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -38,12 +38,13 @@ static DEFINE_MUTEX(sva_lock);
 static void
 arm_smmu_update_s1_domain_cd_entry(struct arm_smmu_domain *smmu_domain)
 {
-	struct arm_smmu_master *master;
+	struct arm_smmu_master_domain *master_domain;
 	struct arm_smmu_cd target_cd;
 	unsigned long flags;
 
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
-	list_for_each_entry(master, &smmu_domain->devices, domain_head) {
+	list_for_each_entry(master_domain, &smmu_domain->devices, devices_elm) {
+		struct arm_smmu_master *master = master_domain->master;
 		struct arm_smmu_cd *cdptr;
 
 		/* S1 domains only support RID attachment right now */
@@ -301,7 +302,7 @@ static void arm_smmu_mm_release(struct mmu_notifier *mn, struct mm_struct *mm)
 {
 	struct arm_smmu_mmu_notifier *smmu_mn = mn_to_smmu(mn);
 	struct arm_smmu_domain *smmu_domain = smmu_mn->domain;
-	struct arm_smmu_master *master;
+	struct arm_smmu_master_domain *master_domain;
 	unsigned long flags;
 
 	mutex_lock(&sva_lock);
@@ -315,7 +316,9 @@ static void arm_smmu_mm_release(struct mmu_notifier *mn, struct mm_struct *mm)
 	 * but disable translation.
 	 */
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
-	list_for_each_entry(master, &smmu_domain->devices, domain_head) {
+	list_for_each_entry(master_domain, &smmu_domain->devices,
+			    devices_elm) {
+		struct arm_smmu_master *master = master_domain->master;
 		struct arm_smmu_cd target;
 		struct arm_smmu_cd *cdptr;
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 3f19436fe86a37..532fe17f28bfe5 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2015,10 +2015,10 @@ static int arm_smmu_atc_inv_master(struct arm_smmu_master *master)
 int arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain, int ssid,
 			    unsigned long iova, size_t size)
 {
+	struct arm_smmu_master_domain *master_domain;
 	int i;
 	unsigned long flags;
 	struct arm_smmu_cmdq_ent cmd;
-	struct arm_smmu_master *master;
 	struct arm_smmu_cmdq_batch cmds;
 
 	if (!(smmu_domain->smmu->features & ARM_SMMU_FEAT_ATS))
@@ -2046,7 +2046,10 @@ int arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain, int ssid,
 	cmds.num = 0;
 
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
-	list_for_each_entry(master, &smmu_domain->devices, domain_head) {
+	list_for_each_entry(master_domain, &smmu_domain->devices,
+			    devices_elm) {
+		struct arm_smmu_master *master = master_domain->master;
+
 		if (!master->ats_enabled)
 			continue;
 
@@ -2534,9 +2537,26 @@ static void arm_smmu_disable_pasid(struct arm_smmu_master *master)
 	pci_disable_pasid(pdev);
 }
 
+static struct arm_smmu_master_domain *
+arm_smmu_find_master_domain(struct arm_smmu_domain *smmu_domain,
+			    struct arm_smmu_master *master)
+{
+	struct arm_smmu_master_domain *master_domain;
+
+	lockdep_assert_held(&smmu_domain->devices_lock);
+
+	list_for_each_entry(master_domain, &smmu_domain->devices,
+			    devices_elm) {
+		if (master_domain->master == master)
+			return master_domain;
+	}
+	return NULL;
+}
+
 static void arm_smmu_detach_dev(struct arm_smmu_master *master)
 {
 	struct iommu_domain *domain = iommu_get_domain_for_dev(master->dev);
+	struct arm_smmu_master_domain *master_domain;
 	struct arm_smmu_domain *smmu_domain;
 	unsigned long flags;
 
@@ -2547,7 +2567,11 @@ static void arm_smmu_detach_dev(struct arm_smmu_master *master)
 	arm_smmu_disable_ats(master, smmu_domain);
 
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
-	list_del_init(&master->domain_head);
+	master_domain = arm_smmu_find_master_domain(smmu_domain, master);
+	if (master_domain) {
+		list_del(&master_domain->devices_elm);
+		kfree(master_domain);
+	}
 	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
 
 	master->ats_enabled = false;
@@ -2561,6 +2585,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	struct iommu_fwspec *fwspec = dev_iommu_fwspec_get(dev);
 	struct arm_smmu_device *smmu;
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
+	struct arm_smmu_master_domain *master_domain;
 	struct arm_smmu_master *master;
 	struct arm_smmu_cd *cdptr;
 
@@ -2597,6 +2622,11 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 			return -ENOMEM;
 	}
 
+	master_domain = kzalloc(sizeof(*master_domain), GFP_KERNEL);
+	if (!master_domain)
+		return -ENOMEM;
+	master_domain->master = master;
+
 	/*
 	 * Prevent arm_smmu_share_asid() from trying to change the ASID
 	 * of either the old or new domain while we are working on it.
@@ -2610,7 +2640,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	master->ats_enabled = arm_smmu_ats_supported(master);
 
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
-	list_add(&master->domain_head, &smmu_domain->devices);
+	list_add(&master_domain->devices_elm, &smmu_domain->devices);
 	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
 
 	switch (smmu_domain->stage) {
@@ -2925,7 +2955,6 @@ static struct iommu_device *arm_smmu_probe_device(struct device *dev)
 	master->dev = dev;
 	master->smmu = smmu;
 	INIT_LIST_HEAD(&master->bonds);
-	INIT_LIST_HEAD(&master->domain_head);
 	dev_iommu_priv_set(dev, master);
 
 	ret = arm_smmu_insert_master(smmu, master);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index a1b400e3e41878..125b52ea5ad71c 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -697,7 +697,6 @@ struct arm_smmu_stream {
 struct arm_smmu_master {
 	struct arm_smmu_device		*smmu;
 	struct device			*dev;
-	struct list_head		domain_head;
 	struct arm_smmu_stream		*streams;
 	/* Locked by the iommu core using the group mutex */
 	struct arm_smmu_ctx_desc_cfg	cd_table;
@@ -731,6 +730,7 @@ struct arm_smmu_domain {
 
 	struct iommu_domain		domain;
 
+	/* List of struct arm_smmu_master_domain */
 	struct list_head		devices;
 	spinlock_t			devices_lock;
 
@@ -767,6 +767,11 @@ void arm_smmu_make_sva_cd(struct arm_smmu_cd *target,
 			  u16 asid);
 #endif
 
+struct arm_smmu_master_domain {
+	struct list_head devices_elm;
+	struct arm_smmu_master *master;
+};
+
 static inline struct arm_smmu_domain *to_smmu_domain(struct iommu_domain *dom)
 {
 	return container_of(dom, struct arm_smmu_domain, domain);
-- 
2.43.2

