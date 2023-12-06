Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2044.outbound.protection.outlook.com [40.107.244.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 508FF697A1;
	Wed,  6 Dec 2023 17:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="c8l6htWN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=heCJ92T/gIihu2+qC/VjtewFQLJqJhssfFCJygBMuDnBpKZOOdM+YvZVFyKeOdVltdzZseoij+ZfF//2AICY4zb17cFjsXmf7x5Zyy7nIFzN4ziJjvkRw2pr3WZsOhDLbBdADicMBAVvi3U2l1tVEfrk5SX5B1vFJisgRcLjeMeXdnUW5AvLW3CgB6rbNoZILLtMAWCrJGKJdbDRiFEak/0jJkaSpUrQk8U5TSbdwW3c/ppAjuOtcXetDmF3DAdwJqWmDocwUKNqf8c1XQd7cdeg6q1nlCvMmvjIuF/WfkrbKW3Jaro+NOzlTRczdgiNXaoSemKAxFONfT0ExBB6Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4vl6lp3QuHYqbaNJWw6aeMZow/i48DkCMDwU6zuHchs=;
 b=mTqTbwia8Mxsc16Er8TpY+iTjcuXMqOn2pbDQMBk4zMyrOG3cjk0BUA+Q3olx+OwPc1ISioHYhG37ZQreIUMxwbRlpq1ptwnwrAZ/MhEJfbKk5WRu2r8s82AQn8ZK21snTGF5tnc3oD+8oC2tG7Yx5yFgXP1rKHwfrZM99h73/T+BYaNQUAIa4XVxnDvbkKWwKpSm6C147txdCT6mz/qWyHyYKhsSeNnAQS70JgkAWFy+lH0HuA5vsTdFHpXvC5WGo8CwLlSNRqOcuqnnEXMDOrq9TwpjSbPngdG46KuPQHDYC5+PW4GsZ2nZaqphsJv4rJ/QU6gE6zFKoyezKB2Lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4vl6lp3QuHYqbaNJWw6aeMZow/i48DkCMDwU6zuHchs=;
 b=c8l6htWNkIKwGynZNzNc4rFlHeQpo415zDO0msgaVUNnvKnyODkNK5ulZT29ZoK2gaHsnbI3z0lgQsUGx1UvAQa3h8FCbHq+YhMMRrOjDxBTvI8mo5oUM9OQ1dBzBVtQNRxPahvRKWKoTqOfRx+5JTjzQ960mx+VdJtQUlwGQ1vJnoEaHYsITAqLNSY32BV6FnCjn+T9bqeJRCx2oYhvOcdrgRQfM27Ti3TWSDpRp825qNSpEG7TdnTEu6C2EaB912GL70xfg860Qv0e+ufvdP26pegISTv20AjHxZX5Xppbca+GQxjvjFMtdqmWww/C+LDKV8aiOg0mlaunGPRd5A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA1PR12MB8360.namprd12.prod.outlook.com (2603:10b6:208:3d8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Wed, 6 Dec
 2023 17:28:42 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.034; Wed, 6 Dec 2023
 17:28:42 +0000
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
Subject: [PATCH v3 13/27] iommu/arm-smmu-v3: Make smmu_domain->devices into an allocated list
Date: Wed,  6 Dec 2023 13:28:19 -0400
Message-ID: <13-v3-9083a9368a5c+23fb-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v3-9083a9368a5c+23fb-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR0102CA0053.prod.exchangelabs.com
 (2603:10b6:208:25::30) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB8360:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c1242ed-ee52-453c-2e27-08dbf680c6b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	dN+YB2wtAPb5f6obOuMcGbmPWrzxyOqjtsGs9iyp5P+aZJAcgp1yaORZQ0ydxTpdYU3f+WVbhvKwH2O3zy28S+LvLickeQYM1G9b2k2UiC7FNkyGgaaaDDEbcUJBZwLhQrq/y+ThY8r3C6b9GKMmbJaZMBlzxFcQlTP5QWXegDn3taFM3i5wcVQ7CcDC+Kk77RoEnQ9X+4FOeafhg7nLoBMcMfCf1dN393nBPHiLeuPXKir4K+Zidc7z1Z/aZoy+pmbPVkUDMGHjVvZvTZY8Ktkll/T8u1bfUFppIBv9mDP1/QjziNPfhI8ExxpWWf/lD11eaDx1M6ArxciiKGmJoShP5UbBIaDfGfDdgmmI+WfWcCY402NHjXQdnEsqSoTtumu6uuPGSSosQo4RZ3ZfkYkFr8oSkWX4HZCQqmzskI1shPAlIrtUuXb7BPy7wr2e3yGLgWTEa0ORxtkfJW9S0PVxSN4DGzgXnmoQOBsl/pp4az8QDXxGihtnOBcSbXjaX+VIcWY49aeC6U1bCLlTHj9rZumMD6UyrvbFA29UwLBbXvA+8xG79j+9ig9qd0X6
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(376002)(136003)(366004)(396003)(230922051799003)(186009)(64100799003)(1800799012)(451199024)(6666004)(6486002)(478600001)(38100700002)(83380400001)(66946007)(6512007)(2616005)(66476007)(6506007)(8676002)(2906002)(4326008)(54906003)(7416002)(5660300002)(86362001)(36756003)(41300700001)(66556008)(8936002)(316002)(110136005)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vKYVZbIotAEcw6s8mLlw34t8s7CIpwZGo+UzWYD9xDPcR1OwwiZSawKc7SfA?=
 =?us-ascii?Q?WlOHCLwWx5ksBGq35bawFNrmkEDtZW5437YJ+LZWwVkJ7zhJkZMEQk4zgM65?=
 =?us-ascii?Q?G1jCKCeXanGIb686Ob5LDtG/uaUY0TtWuwJ9oVUqtXfCy7s0/dn4soUgtQRF?=
 =?us-ascii?Q?tfAlevw+B8IH2QfP+okS82fXFQFScFSxaH6y/8msVn8KCy545gx+KqYQ7kKR?=
 =?us-ascii?Q?1mejD77vfpJklloNHDGkXxOpxE/46LY2EMtKDF7xoCydq+8UdaUrhT5qKHnf?=
 =?us-ascii?Q?eMm3GPu51MzqHAG78fcYS9J438/4In+rsr0KrnjtJ3GdBErqR325L77Myuv7?=
 =?us-ascii?Q?Jf0aX3u7gd3F8EG/9wsq+YBZQ9wP3ShOy85Qux2yaS5Ftl/WvgcZc73LcTfk?=
 =?us-ascii?Q?khJ1Z9Hiv/Icjnb70tT9bUhbJYhdzuWB4cDUXSDcTb5OZhnXNzHvxa4DVrTF?=
 =?us-ascii?Q?e0stUSxkOjyQHLZCY/I9sq+ZtgnS4zrVkUz3v64/y13xDtafFFjeRrWMndCq?=
 =?us-ascii?Q?hVQ8VmRD/SjRL8AOJQVxNnmYPY2l3079MMP6KwArT+K0l6fF3g6cJCu045MW?=
 =?us-ascii?Q?E8vyTFNkAzmiPOorbfgALQU5s7yzyG9GE7UVhkME/22VQtyHYdLxW7JErhKI?=
 =?us-ascii?Q?X/F+mSVFA6TbtVm0MjiSDDX/XjEC+mfRY2A7ysHYEdpFda7A/0YLWjd+zNjR?=
 =?us-ascii?Q?PigucEZFRQaUgtAqbZkSozYUDgtQ9rvN7Jw77btg3og/ZCnUdC8nWKP5uVqr?=
 =?us-ascii?Q?YyHaZxcgHY2T8FKgjLoLyqb9zugcnNC5RszImtQxmkwtuse68ewk9gw6gDxG?=
 =?us-ascii?Q?UxmJaezbUZqIZiNFnZCNn9eHGA5iihld7WAoQ+jpejPg1vBbo0I8UP354Gf/?=
 =?us-ascii?Q?TYPTFK0KZ34q9VXpJon6XcjNRcHZLlA8z1lVvwbVVoCVGlfnGUyCI8EaG5Ag?=
 =?us-ascii?Q?jdFeghsm3r96d5VUlWD0EnObckt6uT1UpUdDL8NBVasmMeU9yj9ySk/stu73?=
 =?us-ascii?Q?o5wQGx16Nt5ZUyrieoBN6XFVpiY1+olQH/29rsaqWCsFw/W2SZ71KuTcmR4C?=
 =?us-ascii?Q?z6jDN9DkOgQgjaaqbEeR6CRiVyCLw1LSPk2dAlpGNCo5SicDhi+9ZrLjw7xV?=
 =?us-ascii?Q?+dCHrrtXMTnDk+UeadnKR9WJDAOdQ+HEUaTW6QIyz2LqIu4pKEeV8UgfI2dC?=
 =?us-ascii?Q?xgfljm0PuON+Bc6mWqcOY81kzPMqUmHpU6BHwNb9xbsh+VBxECzCFSwSkxaP?=
 =?us-ascii?Q?LuRYDwrnOgvLJqN8MdhKKaMUqcDea+QtQh7JuKKXEUv9Mt32Yh3QOuG0t1Pd?=
 =?us-ascii?Q?ouKrY2S/ZHtQ+9YUxhckYnzOEOspbTfJcdnOmTNyGVRvvYIkIpO2cooCgHf6?=
 =?us-ascii?Q?0y6ZekXtTwF5QcSFYDAE7xXZ1qfur6q7GNPfOvJdb94hsjYVCnGmccREb4Kj?=
 =?us-ascii?Q?7x7m2D/prmi5Tdu16loNDkmtvz47xYYVWY2gkUFP+zPexerRHhe0MeihB3Ef?=
 =?us-ascii?Q?o4ZRrJeaM6ym7acTsEFNw0ZFChNl6jqoRYwM42zVnbd3oCNvo3rEDF/HNkbW?=
 =?us-ascii?Q?5PYLLmGuTGqq6xroUoZPQjMb2rUD7Au3bj9T6IKa?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c1242ed-ee52-453c-2e27-08dbf680c6b4
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2023 17:28:35.4629
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EWmEIwV31ETzr520bCF5O8hysEuyK1c9y3AU381hO9eie38jfOfxV8awq/a5RHpR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8360

The next patch will need to store the same master twice (with different
SSIDs), so allocate memory for each list element.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 11 ++++--
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 39 ++++++++++++++++---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  7 +++-
 3 files changed, 47 insertions(+), 10 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 29469073fc53fe..c541b94917d036 100644
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
@@ -289,7 +290,7 @@ static void arm_smmu_mm_release(struct mmu_notifier *mn, struct mm_struct *mm)
 {
 	struct arm_smmu_mmu_notifier *smmu_mn = mn_to_smmu(mn);
 	struct arm_smmu_domain *smmu_domain = smmu_mn->domain;
-	struct arm_smmu_master *master;
+	struct arm_smmu_master_domain *master_domain;
 	unsigned long flags;
 
 	mutex_lock(&sva_lock);
@@ -303,7 +304,9 @@ static void arm_smmu_mm_release(struct mmu_notifier *mn, struct mm_struct *mm)
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
index 38e83386f631f1..6a3a5df836b9c7 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1968,10 +1968,10 @@ static int arm_smmu_atc_inv_master(struct arm_smmu_master *master)
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
@@ -1999,7 +1999,10 @@ int arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain, int ssid,
 	cmds.num = 0;
 
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
-	list_for_each_entry(master, &smmu_domain->devices, domain_head) {
+	list_for_each_entry(master_domain, &smmu_domain->devices,
+			    devices_elm) {
+		struct arm_smmu_master *master = master_domain->master;
+
 		if (!master->ats_enabled)
 			continue;
 
@@ -2489,10 +2492,27 @@ static void arm_smmu_disable_pasid(struct arm_smmu_master *master)
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
 	struct arm_smmu_domain *smmu_domain =
 		to_smmu_domain_safe(iommu_get_domain_for_dev(master->dev));
+	struct arm_smmu_master_domain *master_domain;
 	unsigned long flags;
 
 	if (!smmu_domain)
@@ -2501,7 +2521,11 @@ static void arm_smmu_detach_dev(struct arm_smmu_master *master)
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
@@ -2515,6 +2539,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	struct iommu_fwspec *fwspec = dev_iommu_fwspec_get(dev);
 	struct arm_smmu_device *smmu;
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
+	struct arm_smmu_master_domain *master_domain;
 	struct arm_smmu_master *master;
 	struct arm_smmu_cd *cdptr;
 
@@ -2551,6 +2576,11 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
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
@@ -2564,7 +2594,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	master->ats_enabled = arm_smmu_ats_supported(master);
 
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
-	list_add(&master->domain_head, &smmu_domain->devices);
+	list_add(&master_domain->devices_elm, &smmu_domain->devices);
 	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
 
 	switch (smmu_domain->stage) {
@@ -2881,7 +2911,6 @@ static struct iommu_device *arm_smmu_probe_device(struct device *dev)
 	master->dev = dev;
 	master->smmu = smmu;
 	INIT_LIST_HEAD(&master->bonds);
-	INIT_LIST_HEAD(&master->domain_head);
 	dev_iommu_priv_set(dev, master);
 
 	ret = arm_smmu_insert_master(smmu, master);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index b7a65e37c51e9e..59bb420af52e28 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -695,7 +695,6 @@ struct arm_smmu_stream {
 struct arm_smmu_master {
 	struct arm_smmu_device		*smmu;
 	struct device			*dev;
-	struct list_head		domain_head;
 	struct arm_smmu_stream		*streams;
 	/* Locked by the iommu core using the group mutex */
 	struct arm_smmu_ctx_desc_cfg	cd_table;
@@ -729,12 +728,18 @@ struct arm_smmu_domain {
 
 	struct iommu_domain		domain;
 
+	/* List of struct arm_smmu_master_domain */
 	struct list_head		devices;
 	spinlock_t			devices_lock;
 
 	struct list_head		mmu_notifiers;
 };
 
+struct arm_smmu_master_domain {
+	struct list_head devices_elm;
+	struct arm_smmu_master *master;
+};
+
 static inline struct arm_smmu_domain *to_smmu_domain(struct iommu_domain *dom)
 {
 	return container_of(dom, struct arm_smmu_domain, domain);
-- 
2.43.0

