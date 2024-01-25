Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2074.outbound.protection.outlook.com [40.107.243.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D181D6A5;
	Thu, 25 Jan 2024 23:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706227067; cv=fail; b=mTBgF7JqdkP9WiKdaV22ADm2QNvcL5PN/0KRqWc7scEvEPRQfywsQeYUgVG4rihfGn9kgeslq+1n5/ntd02cLNQvzDUchuxioRABA+0nyeC+zk5dgjDpvrTc1wNFcGGZ2DJSnqxGp8u3qTFWgoBH2tkLi+PwH7HJ0WjLxLySi8I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706227067; c=relaxed/simple;
	bh=PBVvTfj52dpAGly1cZRotGLOHa37O1fCW+pQPJFNXJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=a3Z3J9W3GqJs3XnPiNbS3W3yirjJ9OtzXUoBvddqbYVWmSbH9ZI5VzHEzTkidJHOZfZYqnGN2MhCPualpu4z6yGEalvMVnE+O7LQBJJjhAq+ZsJtfx8hNFdq41d6jfwIKojJ13jcoVtUOvyumBBKP6UpdHqrnHkSdsDDOCcNom0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=iKxlWjg0; arc=fail smtp.client-ip=40.107.243.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="iKxlWjg0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GBeSfKJHsPtPn8/mFkz/OuG6/bYph0PmVJueykyuwv6PywVtwNnQlkvA+MhvDrZQx2Ku8acPM8Hfmdv0Gyne1rH80RL12RT5c14zuX3d68NQ6YVHY+iS/63bvIMCYqwDEcaM4kSfbdmeODU/LWLEIBfXvtfBSCwurovC1TyRqQVdwV8GR0s29EJsxUBKA0CgEgMbxGHhf5oUdBX9cam3nRU7qWPy3zf2ZqGVlaRve6G8N5WJRhz+uUQkU3XTaPXP/KUP+OZiDfzaL75EkaR6W23Opsq0GHPmcg3USkYxAjpvqqusoLBoY5QraYz88yxd9Jt9FgRvJxacwvT5dHSD+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WMZgSb7+n8/Hu/br6qPJ4+0r6DDayqoyl3uXL1TnWR0=;
 b=ZPDbKq79Rk33mdHsNVnmHxoS63J17lBsitSKnP2nvpLLTLQ2HVbjcFPmaVeky97mw0VRFZORSTBhnVSSzKK01v4QDZ7ip1z8txHemjEChLgVtC45Sq+xgT2BcMF9iWJmBRIR1aJZazGhIRoH3ZB37+dOGPq+atvXwLW01+q72K2BmcXAYSWggobL6dTzK76MskL0nwGXp9BR3I8pYN2Yvua1fOreA2o8MBBvuIiOXNBofBzCDH9DC1atbC8zZ17R6KjTzhZp/VrJE/fULyUh9qLjvvBzbMbeLGkYKPzOJp/ZlU+itAiGguqkj43oEOC2CwX/MUhUWYFdJ2pHKZdP/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WMZgSb7+n8/Hu/br6qPJ4+0r6DDayqoyl3uXL1TnWR0=;
 b=iKxlWjg0gD6AwKVfK0/47RFvmOocvIM1uAok8c3vGD9BbvPfM4ILVn84Injfp2imz0UVtXnX8mH4oYZO+y8agv1Ve/cUXlgzZRZp450bsSx3sbkz6vIi77Ekmk8k1Vp8/L6FPE6IcUk3EETvXaBz9319ZV7srXbdOK1fIG5DkkJwNCHtAEOwzo5/B43t/cCFSjcahJ30ihVYkXnbnx8c4r0lY/9BJOFIEViiuCTwGc1ge1+wK32op7cPox4PeTLVtgi1ia+4xMt442lOZOzj4XU2Uljo37hEII2lRW/ggaXjH+ffqV5z8EE4ZDUG7DhaEJweQ9WeXIxFiC5lawbb0g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SN7PR12MB7881.namprd12.prod.outlook.com (2603:10b6:806:34a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.24; Thu, 25 Jan
 2024 23:57:35 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7228.022; Thu, 25 Jan 2024
 23:57:35 +0000
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
Subject: [PATCH v4 07/16] iommu/arm-smmu-v3: Compute the STE only once for each master
Date: Thu, 25 Jan 2024 19:57:17 -0400
Message-ID: <7-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>
In-Reply-To: <0-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA9PR11CA0002.namprd11.prod.outlook.com
 (2603:10b6:806:6e::7) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SN7PR12MB7881:EE_
X-MS-Office365-Filtering-Correlation-Id: dd552bfa-fcc2-442d-123b-08dc1e016400
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	4iSp/wSPxKTgVfnzU0DtANXlijLfaiQYW6vpB5n3b7m9qg7g3ofXwwmp8Rdmn1h8MqrY5KNwgBYrZUBbGP8opzdNq8ej+LhaBNnGnMe/h4vr3NDIx4qfaUn3edqV716n/wQ2Y57/cOr2yuzcYTVa7JqqFV9bdg2VvQPJKWkGiT2UDhcauiYQHeMNbVQC2VH1galN4lWvNOpqzipz3wuvugl6KTgmjhUI8g8Lu8wTwy06FYwWCRgedfK+aJ6mXN1soMBql/mOBWY7CzarHXDPUmFb7TPmswBXM18XqJNyUtvPc5qIJeGUmN6N8maajTdwVGdtj0FvZCns/IVLqOS8UGfzQ70E2dix4Ky5DesIMVC6zwvtjI7bGY8xxvj//YoZLfGh5kPaX3koTZaE2J9WcxHoE5Tce0msLwHlwqGQowd9NsV5XNkBgQ836lApwkgE9OMcOR7c/M9VCzB01odSBIWcY9ao4UIvYN//vYiI/q7j1B3s90I9ER1gg+JnEA14BckiZVtvLec63zQLoVz2I8ctO4mRh1CVgt2NwzIsrcHFcnauAdiujTzXL8mPfkG9a7q2G8+7NEafkF2pWTLC90F1k1XsNm8Ahxdfh7pbHcQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(396003)(346002)(39860400002)(366004)(230922051799003)(451199024)(64100799003)(1800799012)(186009)(83380400001)(36756003)(66556008)(86362001)(54906003)(110136005)(66946007)(66476007)(26005)(38100700002)(6512007)(2906002)(2616005)(7416002)(478600001)(6666004)(41300700001)(6506007)(6486002)(5660300002)(316002)(8676002)(4326008)(8936002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?A0UJnk1iJF2adxcqkDNGGUiHxiO/vyON5h4vIiEBmSsPwZs2KjENduSWniQz?=
 =?us-ascii?Q?GrXUXjKwn8vrI/FcOM39fwyvE5NHjBIo4hgnR22LYk+mKwcRDJkaUodmT+Lm?=
 =?us-ascii?Q?0zfo++1LEtX4PSggWbqNbQA2bp37tRZOxOFpE8pHQfGHCKEBTCctiLOQ8aB1?=
 =?us-ascii?Q?fW7j2fLPPIzJqOVb9JeyTU+w8TMbztYj0DQOhm2BmPhgyMVYThNYwQ8Byezc?=
 =?us-ascii?Q?KHmNRdG8GdeXCTsip5WmMxDPQuvcIDGdN7yFfip3C9Jrtno9h3sMpAnEXMxq?=
 =?us-ascii?Q?obW1NI13I7OH2h7VVjWsw2gD3YVEMKeR7EXci469eaAICKoahwtfTskAHsSp?=
 =?us-ascii?Q?Bny90rGAuacZRZxfGz7aUZVlc66hMfZi/O6xBR/pCOt3yO4qwQ/MrmYPJKhw?=
 =?us-ascii?Q?rIzIGrLRQ0YmWIh9jeDhPhGBAfn02/c+m8lxRINXnIRgaToIgGur4iCyPFrP?=
 =?us-ascii?Q?U3d5uISJzDLL3NjfKYqkBx33ix34hZAMmEIyu6YbmoiCDIDG+YDD8nT0MeyQ?=
 =?us-ascii?Q?z47mCSNA5PfRNizveM3PtzGmLRlfoSDJ3uVdUasdggufBu8HBx2+tInx7hG8?=
 =?us-ascii?Q?10mmC4nV3pgZDo4GTIXjyASbNiCvkzRrPTeD4Q4vepTvFGVcHpN0gzoUncf9?=
 =?us-ascii?Q?smY4NdCBKd7HNvnoubotAhGquWn6fTko9iURX4dg6Gsk8ABxUnkrFspCEykh?=
 =?us-ascii?Q?fPH9DXCenKyHQEzO+Pm1KSF9UnQBWPyHu1zmdWFlVQz//14vhQ5e2whXOmsm?=
 =?us-ascii?Q?hGYn3HS5rJEHnnmjL9qN9oA2renu3+iQKCnwjiER5Jzx9Vi0hVRrMBYNlsHw?=
 =?us-ascii?Q?OCfknlv+yeLupwtskV8QbQNVEMp+GJwVHUtSkwovWUpkKkjTkzkUm232nVTL?=
 =?us-ascii?Q?/XPN1PhckPG5SYOTIellll7my99HDBnX33HnyKWDkvlJmZA+5Zy5OBqazm6p?=
 =?us-ascii?Q?sUifVWWX+4rSCH741t5LJ+2cWkx5at3qALbUQhCbFNMG82+rJec+DkkG3sda?=
 =?us-ascii?Q?wCgFhsYmSaz/0rRrFwci9HFNyXtBZkMQLhNeEU8zu//03QpCWWWHCkHpLm5s?=
 =?us-ascii?Q?3JewdMKirMAEv+H8TVfhdYaWtGoJsyS3xVHMJorsjusfBdN7Ac0a10NjG65t?=
 =?us-ascii?Q?1bZ4EECH4zxsuCh1aJ6rUWXkoafc1kp2icKIWJOREI+qnO3oZLZTzAT441RV?=
 =?us-ascii?Q?YMdsSpP/EPU4ykccaPFRmvSuOutqIBXeFje+vKq3dB22t/zpX/wX78NkSTfr?=
 =?us-ascii?Q?eoBj2ZIXLINU3xuR2ZEO8r8ZHTxVhjf/4iwlelfHR7KYURmw35lakg9O6aNS?=
 =?us-ascii?Q?oGXbrF+0MxKwLjfrhE5kw/nhN/f7LqS9YyJ5J0OxEQjRI4iVJZUhhJBETFIe?=
 =?us-ascii?Q?oQV1Lm0IdvS7Yw8v8IOdpf0ANr2aKnlJDu6s4/8Gi/zesSeNlknJ1RFOWAfY?=
 =?us-ascii?Q?ii5K3afChSZI4CRhbGhVHtgEiCpwTTlI1Ig6SZYbWIw9zP9Z2Qo7e/RuzJOs?=
 =?us-ascii?Q?nd/1EnHkydofIJVBXjOuzPZAEeeo09Uwomz3GYvRRdzL9roBDBKw2Z3/dEoh?=
 =?us-ascii?Q?phj2gBLZpRzwW1MO39EEuOfLTIb+9lFmKnpAvjES?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd552bfa-fcc2-442d-123b-08dc1e016400
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2024 23:57:30.2240
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H90/RFowEa9RucR+ZkDqMNKaaOlgoE6qL7/996P3piIYfFxE1l8cpFs9eiw8LXom
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7881

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
Tested-by: Moritz Fischer <moritzf@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 57 ++++++++-------------
 1 file changed, 22 insertions(+), 35 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 539ef380f457fa..cf3e348cb9abe1 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1588,35 +1588,6 @@ static void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
 				      STRTAB_STE_3_S2TTB_MASK);
 }
 
-static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
-				      struct arm_smmu_ste *dst)
-{
-	struct arm_smmu_domain *smmu_domain = master->domain;
-	struct arm_smmu_ste target = {};
-
-	if (!smmu_domain) {
-		if (disable_bypass)
-			arm_smmu_make_abort_ste(&target);
-		else
-			arm_smmu_make_bypass_ste(&target);
-		arm_smmu_write_ste(master, sid, dst, &target);
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
-	arm_smmu_write_ste(master, sid, dst, &target);
-}
-
 static void arm_smmu_init_bypass_stes(struct arm_smmu_ste *strtab,
 				      unsigned int nent)
 {
@@ -2439,7 +2410,8 @@ arm_smmu_get_step_for_sid(struct arm_smmu_device *smmu, u32 sid)
 	}
 }
 
-static void arm_smmu_install_ste_for_dev(struct arm_smmu_master *master)
+static void arm_smmu_install_ste_for_dev(struct arm_smmu_master *master,
+					 const struct arm_smmu_ste *target)
 {
 	int i, j;
 	struct arm_smmu_device *smmu = master->smmu;
@@ -2456,7 +2428,7 @@ static void arm_smmu_install_ste_for_dev(struct arm_smmu_master *master)
 		if (j < i)
 			continue;
 
-		arm_smmu_write_strtab_ent(master, sid, step);
+		arm_smmu_write_ste(master, sid, step, target);
 	}
 }
 
@@ -2563,6 +2535,7 @@ static void arm_smmu_disable_pasid(struct arm_smmu_master *master)
 static void arm_smmu_detach_dev(struct arm_smmu_master *master)
 {
 	unsigned long flags;
+	struct arm_smmu_ste target;
 	struct arm_smmu_domain *smmu_domain = master->domain;
 
 	if (!smmu_domain)
@@ -2576,7 +2549,11 @@ static void arm_smmu_detach_dev(struct arm_smmu_master *master)
 
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
@@ -2591,6 +2568,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 {
 	int ret = 0;
 	unsigned long flags;
+	struct arm_smmu_ste target;
 	struct iommu_fwspec *fwspec = dev_iommu_fwspec_get(dev);
 	struct arm_smmu_device *smmu;
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
@@ -2652,7 +2630,8 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	list_add(&master->domain_head, &smmu_domain->devices);
 	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
 
-	if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
+	switch (smmu_domain->stage) {
+	case ARM_SMMU_DOMAIN_S1:
 		if (!master->cd_table.cdtab) {
 			ret = arm_smmu_alloc_cd_tables(master);
 			if (ret) {
@@ -2666,9 +2645,17 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
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

