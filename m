Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2049.outbound.protection.outlook.com [40.107.223.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 563E768EA7;
	Wed,  6 Dec 2023 17:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="EsQ9ZyUa"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kPbgvcgRNRx3R9ruVurVtipZ/9EBvysdmwyhA5QhPBjQA5cDHlVeDSZ9XKHxiXUS34tqKXdSOSC61Z/9jNcw8/6AFwYgl/8FtrK7RF1MeHzlnVutVWybNT2hWxHTnAFjubCituLI64XW5jQAtBc/c8c9vtGkT3VB26M4pA9JGnDYI4PCXVGyE31uQYK1UiCN2FPZCrpp7mtx2SsI6bmieCwhd3skiBy/qdQdX39MvgSxT6FIEaQ7kRUUirPPKXlzZ1NP8grwPymsYp6151C97RBVI17Pz7pS3Zt/h5LKvlX0dP2LhsT9bpUQYMyT8ZEIreidxZ1Gn67mwStd7GiT4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vGUYkm9BPytjmNaW08camwInHZW5EVUnExPqcs81rk0=;
 b=OKmVRT3QoE5Y4GlSc4MoPCypHe9J0cunFR31rzem9KttmTJwD2ZGI6jROzKW613SUzFK+YgvjQCuWPT4fEgL+8266KMPIljqnIHHFi3BXcNoWUd5i0r/5kQqSzGuY/JOMpik2WY3OjdG5rklTw0BbAmnpUIMSDDrVi63HP1rO08jNF6zzT6xHkI6hW7tH0OB9knf5UGnj16h8egsnUAhqlSpR44XTiI36uuxnh3V4M4eL1lNZR37rPxjD3ZnU6Csf6owaXJU0jFnZkNRi+w6FH/xjvvBPD1s/9lh13VMGM2c6a7w7g+BXSCRMz8SlXayli0wDs9AO53QZMErFzXnLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vGUYkm9BPytjmNaW08camwInHZW5EVUnExPqcs81rk0=;
 b=EsQ9ZyUaxKrBAQE+iMZIIdQiXb5ugEhVXthESR6tRTtf0GS8aCi5wn9C+T7Lf8uLMAjBhSO3nqKusR7vRgTxo/mv+67MPatVfanPwZXTBth+ASmvr4KtDCuVKdCjnLWyh1zGpbmqElc3mosaFZfF3/DXRT3HTDLC5EJqb1fxGttbO50mnXo41CRUQn5pvz2/i+MEUHTmT8QYrWpkmznlLQXagI91HXBmhMDtNKAhSu0/KEftrVST2Uoh6ftkp9ViMG4NMIyaKe6mwjOcYsX01izsOUXBtS8ysbn7cw1xaX5uev6OF5Z2cr8LrAHcxlLeST7PUKYzn09J51Mt7HP6KQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CY8PR12MB7364.namprd12.prod.outlook.com (2603:10b6:930:50::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.25; Wed, 6 Dec
 2023 17:28:38 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.034; Wed, 6 Dec 2023
 17:28:38 +0000
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
Subject: [PATCH v3 16/27] iommu/arm-smmu-v3: Keep track of valid CD entries in the cd_table
Date: Wed,  6 Dec 2023 13:28:22 -0400
Message-ID: <16-v3-9083a9368a5c+23fb-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v3-9083a9368a5c+23fb-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR22CA0022.namprd22.prod.outlook.com
 (2603:10b6:208:238::27) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CY8PR12MB7364:EE_
X-MS-Office365-Filtering-Correlation-Id: f0488ae6-3c3b-496c-ab85-08dbf680c60f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	t7u8XT+o44nNZ8rC4S3jzQD3ElhBLs5GezdLNkcUNJnZ/VqdPZyvSJB5SiG81y6mTlxmhRFNNqSvwjlHP1VwdIJFuiPnSAwKA83+RHwqBXJ6mZcjhcCkM0LlmF7MGbaSL1Xs4aMicA2tx4yE5FHUTS/DlS3QLuo9u4VfqA9Xn/zwWUFr5pP4fTC2QSKSCcGSm8EDBMx/NnXlVJDjeMf4PwzdGZOM8YiQN1totpmvPBO0B+zI/H4mYGjyvZ0TtRgKkKyYmyjxZ22b/bbXSGufwTliEPRI3/YOmEZviDzUDw+Udkrkm7111zYVddKmH/OLQNondY91Qz+ub13MDDCqI7Yicv8VLdWvJD4h7AJ9O5XfF8pJqgYwWjZAhB/MVATjd1sYm69JV8fRZmjM95TIfLAz9rxGAveGo3L8JBN20c4R/AnKlMBYkUKYmCYUFdW7LIk9nT6RWUQMLIR2n7uddHa40Jctpq/Cc0zqIZZLZYFVWqd3YwjtMX7fkNmvznylDKNxy2IORMMteBox7SmIyQIZTlgu2UPBYBEVlJE3bNzBXRBsI4ny9THjN5bV/J2IvCST+0r5QqYgRMgaHag2CbOEAWtZ/O4SG+9AYTGbyVp9SiOle32ETrit6RowyfiRVbngbVQICX5O4vGU8M4gjA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(346002)(396003)(39860400002)(376002)(136003)(230922051799003)(64100799003)(1800799012)(451199024)(186009)(8936002)(8676002)(4326008)(2906002)(38100700002)(83380400001)(7416002)(41300700001)(36756003)(86362001)(5660300002)(6666004)(26005)(6512007)(66556008)(6486002)(478600001)(2616005)(66946007)(110136005)(54906003)(66476007)(6506007)(316002)(473944003)(414714003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jsJ6TMSjgzZZ+A971QBOcOBM/8eLei7UrH59A33R9zxjy+9PEaqYkRbQfdGX?=
 =?us-ascii?Q?Vako9Y8sRRX2ncoBtKXfPJTuNaCichHbEL5wpTTEwjX0Ab6vKZ9nE44FT8u/?=
 =?us-ascii?Q?qkr5d5nzWdrGQo650nDZsM8PW79HYjGwW6nDzk7srdzmPVr2CtDDYeNLOr5D?=
 =?us-ascii?Q?UfvA4WYdhEEJHriMv985dxhZQfwdK/2DyMpQEAsaPgCgjgR/E8Xxrd1UrYjt?=
 =?us-ascii?Q?KbO1nbukBRZULRf0g1VeQMN2bMIVCmtJSsuvlbgFqbFBh041Vd+ALBHTm5Hy?=
 =?us-ascii?Q?OXgoJW01UdTeuCJd4AzdJ9GSh5oZC76dbfNY/pCZSBAPF6tJoHJo6Yki244D?=
 =?us-ascii?Q?sSV0xiyuHF6NqQP6bbuqqUJb4Z39aFvl29Ri/FiHFEU5SqI2BmMUQ1vuCpfF?=
 =?us-ascii?Q?Wvdssxewn3Lk9rQaUslJWUFuOhWgis6dHXEr/8vpzj7QTBwwH901yFfVGyup?=
 =?us-ascii?Q?j0ly0xlhImva2mdreupaQ9QaplimNRy4boblGewx03UE5imiKXlFU/Eil19W?=
 =?us-ascii?Q?XeLpzriF7L7+ctS9P6M0+vWbmGgzRslM4jmXnhjYH350wDbsryLj5Y4cveHf?=
 =?us-ascii?Q?KY7InItGPgXWZLj80CzkQiaefMZJxO9tqYqicpuVbe0FjOuvmtf6vG/8bmso?=
 =?us-ascii?Q?bIe6xj0uwIdP8ONEKJsyXtnrgJiFySnsGnuPojj7Cdi5FtktTeEBhM9Bxdjx?=
 =?us-ascii?Q?cUXnqmVVvOnWZMGjW+PsngktZASUup3uTPYjye90KF3qbnEX3lBueqHE40FD?=
 =?us-ascii?Q?sV9T7RGH37/MM41246frCq/6qSba+5UpdgEUW8VmkOUqAj6ytmaHlGGRNGHm?=
 =?us-ascii?Q?U6KOHkOyB1BGg2y/g0OZZpDrrac8k2AZ2xUsyfA2mcxj3uBl2NsSwJK8nRP4?=
 =?us-ascii?Q?pvsrjlhsGC9RmvB5+rmNOzM8KIxMmc0+42eZKd51zYowNBY6wyAJ69HLmn9a?=
 =?us-ascii?Q?6GhNnuCWP8JFqUmDk5nW+tnJK8gZ8ogTJ+H4S+dApclUFeMdqS3DKk7qVSlh?=
 =?us-ascii?Q?dqgpoA5+8QXTgl2szmlpvCf8wIhEE95YhBBxs/zfSRB4UR9c+mnV6zlESSg1?=
 =?us-ascii?Q?gDAdev6AbRORF04kJBAQ9RaLTnuUFHr2nC2keFIaHIGGM++66FFD3Iq2W8IR?=
 =?us-ascii?Q?3D/xESPklWlS5NnjRoERNync5t8iyie/mjr7nG4Dhgg1AL9Minem/rxphPfN?=
 =?us-ascii?Q?mjaoFHMzE/k+bhBlqAYZ0HuuwQGtctRSKLYfdPu2tjRT+nvgkEWVM0qbSaIc?=
 =?us-ascii?Q?x3Al4KxtBPvhEztZoA8PXY5WAssnhDbAlTDyql0mw9NrTB4FlyxK1W3BWiG/?=
 =?us-ascii?Q?vlVx+X2A/Lb7vqdWqqeH++XccEQ25rKqBsfr6eB9WOxuT3WTAKv6tx8czlAt?=
 =?us-ascii?Q?oud9OBDAowdmMraCcOPDZtc/uq39SjB7ZUW2rsK56dqbfdmjAuQUwqvz+6X1?=
 =?us-ascii?Q?WQ97YEzgOYTqieUmoy7jiPX/aOj168iP3b4xBZk8QY8YzFRT6AWyumrej+ej?=
 =?us-ascii?Q?oGpCmKMQeMkkef+HpsW7fU28IlQjGKJKgh+cBx75PCfxXg1UwROdJeVNarrX?=
 =?us-ascii?Q?3LrbCnJCwa/C3QnPK1bp+3PZVGr6DBQCgcAzrZWD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0488ae6-3c3b-496c-ab85-08dbf680c60f
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2023 17:28:34.3490
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: etDutqek+h9DiF9ElzJGY2mCmZAwsJE39K9US2/mfkyivenT4wrzhx3I/Q5wLpCW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7364

We no longer need a master->sva_enable to control what attaches are
allowed.

Instead keep track inside the cd_table how many valid CD entries exist,
and if the RID has a valid entry.

Replace all the attach focused master->sva_enabled tests with a check if
the CD has valid entries (or not). If there are any valid entries then the
CD table must be currently programmed to the STE.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |  5 +---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 26 ++++++++++---------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   | 10 +++++++
 3 files changed, 25 insertions(+), 16 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 4644d4601c0830..2f818b24d931c2 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -417,9 +417,6 @@ static int __arm_smmu_sva_bind(struct device *dev, struct mm_struct *mm,
 	if (!smmu_domain || smmu_domain->stage != ARM_SMMU_DOMAIN_S1)
 		return -ENODEV;
 
-	if (!master || !master->sva_enabled)
-		return -ENODEV;
-
 	bond = kzalloc(sizeof(*bond), GFP_KERNEL);
 	if (!bond)
 		return -ENOMEM;
@@ -622,7 +619,7 @@ static int arm_smmu_sva_set_dev_pasid(struct iommu_domain *domain,
 	struct mm_struct *mm = domain->mm;
 	struct arm_smmu_cd target;
 
-	if (mm->pasid != id)
+	if (mm->pasid != id || !master->cd_table.used_sid)
 		return -EINVAL;
 
 	if (!arm_smmu_get_cd_ptr(master, id))
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index a2263d9c3658a3..5f6ffd816aaee6 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1186,8 +1186,19 @@ void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
 			     const struct arm_smmu_cd *target)
 {
 	struct arm_smmu_cd target_used;
+	bool cur_valid = cdptr->data[0] & cpu_to_le64(CTXDESC_CD_0_V);
+	bool target_valid = target->data[0] & cpu_to_le64(CTXDESC_CD_0_V);
 	int i;
 
+	if (cur_valid != target_valid) {
+		if (cur_valid)
+			master->cd_table.used_ssids--;
+		else
+			master->cd_table.used_ssids++;
+	}
+	if (ssid == IOMMU_NO_PASID)
+		master->cd_table.used_sid = target_valid;
+
 	arm_smmu_get_cd_used(target, &target_used);
 	/* Masks in arm_smmu_get_cd_used() are up to date */
 	for (i = 0; i != ARRAY_SIZE(target->data); i++)
@@ -2629,16 +2640,6 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	master = dev_iommu_priv_get(dev);
 	smmu = master->smmu;
 
-	/*
-	 * Checking that SVA is disabled ensures that this device isn't bound to
-	 * any mm, and can be safely detached from its old domain. Bonds cannot
-	 * be removed concurrently since we're holding the group mutex.
-	 */
-	if (arm_smmu_master_sva_enabled(master)) {
-		dev_err(dev, "cannot attach - SVA enabled\n");
-		return -EBUSY;
-	}
-
 	mutex_lock(&smmu_domain->init_mutex);
 
 	if (!smmu_domain->smmu) {
@@ -2654,7 +2655,8 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 		cdptr = arm_smmu_get_cd_ptr(master, IOMMU_NO_PASID);
 		if (!cdptr)
 			return -ENOMEM;
-	}
+	} else if (arm_smmu_ssids_in_use(&master->cd_table))
+		return -EBUSY;
 
 	/*
 	 * Prevent arm_smmu_share_asid() from trying to change the ASID
@@ -2726,7 +2728,7 @@ static int arm_smmu_attach_dev_ste(struct device *dev,
 	struct arm_smmu_domain *old_domain =
 		to_smmu_domain_safe(iommu_get_domain_for_dev(master->dev));
 
-	if (arm_smmu_master_sva_enabled(master))
+	if (arm_smmu_ssids_in_use(&master->cd_table))
 		return -EBUSY;
 
 	/*
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 887669f04b55c1..f72aebaf95f981 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -602,11 +602,21 @@ struct arm_smmu_ctx_desc_cfg {
 	dma_addr_t			cdtab_dma;
 	struct arm_smmu_l1_ctx_desc	*l1_desc;
 	unsigned int			num_l1_ents;
+	unsigned int			used_ssids;
+	bool				used_sid;
 	u8				s1fmt;
 	/* log2 of the maximum number of CDs supported by this table */
 	u8				s1cdmax;
 };
 
+/* True if the cd table has SSIDS > 0 in use. */
+static inline bool arm_smmu_ssids_in_use(struct arm_smmu_ctx_desc_cfg *cd_table)
+{
+	if (cd_table->used_sid)
+		return cd_table->used_ssids > 1;
+	return cd_table->used_ssids;
+}
+
 struct arm_smmu_s2_cfg {
 	u16				vmid;
 };
-- 
2.43.0

