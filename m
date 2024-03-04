Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2043.outbound.protection.outlook.com [40.107.94.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 486F87D098;
	Mon,  4 Mar 2024 23:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709595870; cv=fail; b=nSgA9VmaIsVnrR4Nyb8V88OhxxQZ+QySeJVmzvDmqgIBqLFeEtabcVxGrzir12gZRivJjt31EUYJg3rNfLQJlzY5GMqdKC4CPTdbxrKk78YdLI6TytgMALn6Lyf1xAZLTchvrHLY0Tl9xHRxH8yvw0euGGe/DOqc7agovMgR3ig=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709595870; c=relaxed/simple;
	bh=3VwPSOnkKPWkfKEThDgIi1buuLh1402lWoC7zNwMQOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=aSU/P9Sd2SCf/b/QYW/f3UAgau38KFCK6XBDAIBGzCyH8Vp5fts16nWXhQIFUGwNj4Po3XDYr047xKOTDOOOUKrT/Hd28qDvWJdBuDvzMT+AfRO0iDDFKuDHDr9wqvqTYmZJzw9eGwl4hUqWj9OB21Sb/3jPD92yOQAoBXR2i+E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BTkmogKD; arc=fail smtp.client-ip=40.107.94.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BTkmogKD"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mpdhLTxVPAQl02HyhMtIJGbS5pkRmXClq1SgmOCKUeTNCH197mbOF6Yz8TBbyf0/SwL0GxbEce6n+g3jWPo0qEdEIpNlo/jzHtR0vXDO2i4I+mzOC8WzOfymb8qiZ67z+xDarmRiKkmOjbFU29N8aOD0tflVBcUPrXjbnCbEErduzgtTeMLYjKZa4n/nN9ryGEE/6v8FOelajBAB6eKKA52drAY26ALA3rjEmPlnT/3mjeTV8j2FQaBJMvNlYudex5rN/oBFTmST7my18u/t8L+GYvrq1wWqh07257Fw4iGMaE4bAgzdew5veyXPVche9fPX2xRKsnaHo4S2RIU3rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FG6KX9Xps1kg9/29E+SbdwMhZeYRQPVHWhA475B+y0Q=;
 b=bXRzEgj3FXQKbpp17FJT1yT00FSBVoWBKplJ11qdAEhCIc2Ap9sAGpTk54rmBbnpWhIPbjikGcbXQJgQRuZaExJ3O+Yl6L/xnDn0ccQbVt4gdDPVXMfGzgs1ORm+7rdvzFRc64qaXcSf4vi2Wudyg2FMnEO1RBhmP93Pg7ubdYbg0pPA4MLGbjUMTYOuyDWMAjlEHckPS4QwF9dRa7z+VQoLcqNz3tKFDcOETpmipRo/Xoo9zum/AfdbhEOnK7OsEc4vuFTgcpcSl5lun9QZE4A9wucTdQsD1u0E4rdDpz8Xz57ymcrRis+AdYVU24MddnK0mMvvP6rPw0GPXd9XeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FG6KX9Xps1kg9/29E+SbdwMhZeYRQPVHWhA475B+y0Q=;
 b=BTkmogKDlMNdaU06pq2RheRoKE8tbQMzAf5SeWdaAaLOORJjeCfBhck0Ole0j+mfi6d/1F+vnX1mnKeiaMKm6zPqrI77QXbDb4Wsi+yUbgTHwriMCt8JVZEIuSL7BEU07nnCjjCn6Ynb8vPbNKQ4qynLWJKHaTxc9EaimFM0UwMT2nEvRiWaWpueKhJUXZlwLSbHDSRH4nVVu5KgRWj3JkI8vB3FP1F4BjPouA4VR64tD11oBMJkEWSh9SSc+0Q4sbDiXwz4HCv6keca0BWw++FwjrOwKKkiHgVWfMpL7uBArA7aNumcRW5LathtYoriXIJ7aUOeJ4QM50uoVRt0EA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by MW6PR12MB8949.namprd12.prod.outlook.com (2603:10b6:303:248::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.38; Mon, 4 Mar
 2024 23:44:19 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c33c:18db:c570:33b3]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c33c:18db:c570:33b3%5]) with mapi id 15.20.7339.035; Mon, 4 Mar 2024
 23:44:19 +0000
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
Subject: [PATCH v5 15/27] iommu/arm-smmu-v3: Add ssid to struct arm_smmu_master_domain
Date: Mon,  4 Mar 2024 19:44:03 -0400
Message-ID: <15-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR20CA0039.namprd20.prod.outlook.com
 (2603:10b6:208:235::8) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|MW6PR12MB8949:EE_
X-MS-Office365-Filtering-Correlation-Id: b3818e5d-bf6b-48cb-7633-08dc3ca500f5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	sQpWLDBhqJzK1uEcnmYyRxBQfQ7PrN2Dij8V0ZUlEF90DFc2G+xitt3r+BGz+frX3QFYXGtknOaSaemdGjhJjrBxUQngjofyD5tgBqhp5cBuOUQ5Bjz3A000zJSiubsQRIhUiYIprX6pkWmtTRk/FHvqovJWiwnBZ/0HZDLxg7gEV5PX4gjXN8Y2ab5Uf+20ofA8eQxaXkbFHBoBB6/Q2BRg5uUOl4ZOmCxAZEN5Cv435qalGW/qQcV42M3EzJSA91QLtFpfMSlD6wsSbL9jGvB/Jy7oeNKiC/I4YPqeC3xushUQbcUcPbT0b/SkumEsG9hIE+JtX3oeawDb/mPtXP0WtsoRfKXT4cY/9TJkruJBGBBawIDk0JWofC8CSev1gENboj0kpn8L5BtP4tAvkzqjKS0Xa3eaXAhfphpBNJ3hronFPUOptn6mGhHcDwaXiaLXljnDn6uuMjrm45Oxu1knW7csLBPzOW5Pqv29jRTLMp6ETUundoQjEhG3JevB+a5i2LQoSibCqOdrFlz+Y5QpkoT5+XJLZIB8HuF9qSgnNApImPlSbecuS2XXLlqppol8AswpBgtsDksmWAct2B2bDNOD34+OYS4tcjYDv2D31OhQl2kh9nPhZtfI6psw0z4reXPX1L+hTvPcCOgKXVs6jF9mnkIbZSPjsuqX4ps=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?B0VOqA2bnbthtz5mpYLaCOdbxeAXnGU9erGqx26s2UpnLy4hwXnK0Axd9w0x?=
 =?us-ascii?Q?JFmc6BT2fnpXcMcr6uz3oaZvYIwvkvXh0uMlviglwqDU9aeL6eLILjRd4ygt?=
 =?us-ascii?Q?0zf8UGnpbfBa4/68X8qk8S01ljkJfZrWCYONSb5jf5IcsfVtipEq1uduZeVW?=
 =?us-ascii?Q?43r7c1eepwisAo7h96sX0siFVCtzej1LsOzT3g5LLPRp44PBw/golMwerOAr?=
 =?us-ascii?Q?FSp75FWLJYqmKLzcXRg+mF+kF6d2zhF2JTrSUihNNQTJw1M7cNHVg3EO0KtJ?=
 =?us-ascii?Q?/y1PNvd5NnUteFXQVgMEHXgaigf842Zx2VIrs+yJYqnoMXQCd2kD7axfliNX?=
 =?us-ascii?Q?zRCQK1e3bVMCKCydzYxexLKV4JlGpZ3L88wgt4b6oYKLCZMOo26rVKr4VGFl?=
 =?us-ascii?Q?xyK6xYPZ2hgQXoeCOTyHtxtqrP/PBiZxEaM0LV3vXAQKpf1NHmSJAs8ZpBjE?=
 =?us-ascii?Q?4UFi17yIQbLCRJEyy8KACIS+gHu/kU7Xnlj3oAneKK0vvFpVhTgS+Df9fAWO?=
 =?us-ascii?Q?Uax0H4fDa4GAstBlUz4Xm/FWtEaRgXkYwsWGxNSWwdv82jidxqJpnNLhCb43?=
 =?us-ascii?Q?roH3qy47ZozFNImOMjVtSbKe5DsBYwR+phkpJ6iYPOO5IWWMkTmd6nnYERlI?=
 =?us-ascii?Q?96uHZPtKagwMP08V0RqBYs4zIQMxSbKO7S2Cme4ms9lzcBICL6udUCxfqmzC?=
 =?us-ascii?Q?ihRUPp5a+UH/zqnDYDv1e0n8JYkrfaDXIi96Uo6G9ZUuww9bTosCmfOLFrrz?=
 =?us-ascii?Q?zKEnCKlHljAjT0KhT33vaopIom6ietOFPQMLC8rPAIJN4CVaeynjq2kD+ZKi?=
 =?us-ascii?Q?wvsWiK/iC6vJOlcaPmi8HwV8YYBJkuMCpSUA4TX7NA+v2AGtU1m2ejzjcrK5?=
 =?us-ascii?Q?r3M0oRmsuCImfbICsjyjtz/MUTto50FED6rzrMEM1+LGkIGDado0TMWRfFoK?=
 =?us-ascii?Q?qr7bvgjENFAWjovi7F5CEAQ4bpx8DjXXILuyf5uwZCPTIAkKZ0AmuyWstvRY?=
 =?us-ascii?Q?o91AgTvS7t1C/iegdtAhOxkbQBpgtePdboHpzlVBL6R7eImpbgBM+Q+M1ooL?=
 =?us-ascii?Q?p1Fx13Znv1t55/xOlrBReNviJMY30VASBLvW71iZOdrkNsamt+UGp6tI9NPF?=
 =?us-ascii?Q?C7SL4SKRQFa0CjlAADRePWmAsAacSBrxOTfHvie4fSR8HBdavKmLfVCjwm5J?=
 =?us-ascii?Q?ZMpfJqRWwtDS29TphBWNrPIzu1Lluc+pA9ZmBa5o9bRZBWCCnA0GkxqhR93g?=
 =?us-ascii?Q?yzHiEerR3RgLfbeVmSSDDjjSV2Tf7dnGpLsOpqr95VOLW2cL21Yy6bLrVtd5?=
 =?us-ascii?Q?FfFQvY0GJ3y3yLDPuDTAkzSx54NMHvOMAL8ADhk41+nCLWMddeNEPdnXoFvB?=
 =?us-ascii?Q?WeHTe4Rh4/LJG94mLaup3Pg9su4AKNCIMovi56FIZcSgtz7Uu0dQ8GUOI37E?=
 =?us-ascii?Q?GoPXKeonirwKRKuYYyDfhvbrBLMXgA+yB3h+FsbuYJVfR/BRhvVIYVJIqLjF?=
 =?us-ascii?Q?HzIAeAV/C7Y4zNZ3/6joItpQhAnSOrTwaBgFjWJPkV8f9PMM9PksopgySMr2?=
 =?us-ascii?Q?0qgyt+mVGBSwVfHzlCCfXW/r6wb4btDyV+g6ROU6?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3818e5d-bf6b-48cb-7633-08dc3ca500f5
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2024 23:44:16.5235
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wESDBbtnuZTykuigrbtduf0Ig+E8mX/wFwoknIsd3eeNIKsvfP9NH46KOAPkOXc+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8949

Prepare to allow a S1 domain to be attached to a PASID as well. Keep track
of the SSID the domain is using on each master in the
arm_smmu_master_domain.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 15 ++++---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 42 +++++++++++++++----
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  5 ++-
 3 files changed, 43 insertions(+), 19 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 9a285b828e8b12..ab9de8e36c45f5 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -47,13 +47,12 @@ arm_smmu_update_s1_domain_cd_entry(struct arm_smmu_domain *smmu_domain)
 		struct arm_smmu_master *master = master_domain->master;
 		struct arm_smmu_cd *cdptr;
 
-		/* S1 domains only support RID attachment right now */
-		cdptr = arm_smmu_get_cd_ptr(master, IOMMU_NO_PASID);
+		cdptr = arm_smmu_get_cd_ptr(master, master_domain->ssid);
 		if (WARN_ON(!cdptr))
 			continue;
 
 		arm_smmu_make_s1_cd(&target_cd, master, smmu_domain);
-		arm_smmu_write_cd_entry(master, IOMMU_NO_PASID, cdptr,
+		arm_smmu_write_cd_entry(master, master_domain->ssid, cdptr,
 					&target_cd);
 	}
 	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
@@ -293,8 +292,8 @@ static void arm_smmu_mm_arch_invalidate_secondary_tlbs(struct mmu_notifier *mn,
 						    smmu_domain);
 	}
 
-	arm_smmu_atc_inv_domain(smmu_domain, mm_get_enqcmd_pasid(mm), start,
-				size);
+	arm_smmu_atc_inv_domain_sva(smmu_domain, mm_get_enqcmd_pasid(mm), start,
+				    size);
 }
 
 static void arm_smmu_mm_release(struct mmu_notifier *mn, struct mm_struct *mm)
@@ -331,7 +330,7 @@ static void arm_smmu_mm_release(struct mmu_notifier *mn, struct mm_struct *mm)
 	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
 
 	arm_smmu_tlb_inv_asid(smmu_domain->smmu, smmu_mn->cd->asid);
-	arm_smmu_atc_inv_domain(smmu_domain, mm_get_enqcmd_pasid(mm), 0, 0);
+	arm_smmu_atc_inv_domain_sva(smmu_domain, mm_get_enqcmd_pasid(mm), 0, 0);
 
 	smmu_mn->cleared = true;
 	mutex_unlock(&sva_lock);
@@ -410,8 +409,8 @@ static void arm_smmu_mmu_notifier_put(struct arm_smmu_mmu_notifier *smmu_mn)
 	 */
 	if (!smmu_mn->cleared) {
 		arm_smmu_tlb_inv_asid(smmu_domain->smmu, cd->asid);
-		arm_smmu_atc_inv_domain(smmu_domain, mm_get_enqcmd_pasid(mm), 0,
-					0);
+		arm_smmu_atc_inv_domain_sva(smmu_domain,
+					    mm_get_enqcmd_pasid(mm), 0, 0);
 	}
 
 	/* Frees smmu_mn */
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 45f2190fc31786..26c6b9f6f34fd3 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2030,8 +2030,8 @@ static int arm_smmu_atc_inv_master(struct arm_smmu_master *master)
 	return arm_smmu_cmdq_batch_submit(master->smmu, &cmds);
 }
 
-int arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain, int ssid,
-			    unsigned long iova, size_t size)
+static int __arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain,
+				     ioasid_t ssid, unsigned long iova, size_t size)
 {
 	struct arm_smmu_master_domain *master_domain;
 	int i;
@@ -2059,8 +2059,6 @@ int arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain, int ssid,
 	if (!atomic_read(&smmu_domain->nr_ats_masters))
 		return 0;
 
-	arm_smmu_atc_inv_to_cmd(ssid, iova, size, &cmd);
-
 	cmds.num = 0;
 
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
@@ -2071,6 +2069,16 @@ int arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain, int ssid,
 		if (!master->ats_enabled)
 			continue;
 
+		/*
+		 * Non-zero ssid means SVA is co-opting the S1 domain to issue
+		 * invalidations for SVA PASIDs.
+		 */
+		if (ssid != IOMMU_NO_PASID)
+			arm_smmu_atc_inv_to_cmd(ssid, iova, size, &cmd);
+		else
+			arm_smmu_atc_inv_to_cmd(master_domain->ssid, iova, size,
+						&cmd);
+
 		for (i = 0; i < master->num_streams; i++) {
 			cmd.atc.sid = master->streams[i].id;
 			arm_smmu_cmdq_batch_add(smmu_domain->smmu, &cmds, &cmd);
@@ -2081,6 +2089,19 @@ int arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain, int ssid,
 	return arm_smmu_cmdq_batch_submit(smmu_domain->smmu, &cmds);
 }
 
+static int arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain,
+				   unsigned long iova, size_t size)
+{
+	return __arm_smmu_atc_inv_domain(smmu_domain, IOMMU_NO_PASID, iova,
+					 size);
+}
+
+int arm_smmu_atc_inv_domain_sva(struct arm_smmu_domain *smmu_domain,
+				ioasid_t ssid, unsigned long iova, size_t size)
+{
+	return __arm_smmu_atc_inv_domain(smmu_domain, ssid, iova, size);
+}
+
 /* IO_PGTABLE API */
 static void arm_smmu_tlb_inv_context(void *cookie)
 {
@@ -2102,7 +2123,7 @@ static void arm_smmu_tlb_inv_context(void *cookie)
 		cmd.tlbi.vmid	= smmu_domain->s2_cfg.vmid;
 		arm_smmu_cmdq_issue_cmd_with_sync(smmu, &cmd);
 	}
-	arm_smmu_atc_inv_domain(smmu_domain, IOMMU_NO_PASID, 0, 0);
+	arm_smmu_atc_inv_domain(smmu_domain, 0, 0);
 }
 
 static void __arm_smmu_tlb_inv_range(struct arm_smmu_cmdq_ent *cmd,
@@ -2200,7 +2221,7 @@ static void arm_smmu_tlb_inv_range_domain(unsigned long iova, size_t size,
 	 * Unfortunately, this can't be leaf-only since we may have
 	 * zapped an entire table.
 	 */
-	arm_smmu_atc_inv_domain(smmu_domain, IOMMU_NO_PASID, iova, size);
+	arm_smmu_atc_inv_domain(smmu_domain, iova, size);
 }
 
 void arm_smmu_tlb_inv_range_asid(unsigned long iova, size_t size, int asid,
@@ -2539,7 +2560,8 @@ static void arm_smmu_disable_pasid(struct arm_smmu_master *master)
 
 static struct arm_smmu_master_domain *
 arm_smmu_find_master_domain(struct arm_smmu_domain *smmu_domain,
-			    struct arm_smmu_master *master)
+			    struct arm_smmu_master *master,
+			    ioasid_t ssid)
 {
 	struct arm_smmu_master_domain *master_domain;
 
@@ -2547,7 +2569,8 @@ arm_smmu_find_master_domain(struct arm_smmu_domain *smmu_domain,
 
 	list_for_each_entry(master_domain, &smmu_domain->devices,
 			    devices_elm) {
-		if (master_domain->master == master)
+		if (master_domain->master == master &&
+		    master_domain->ssid == ssid)
 			return master_domain;
 	}
 	return NULL;
@@ -2580,7 +2603,8 @@ static void arm_smmu_remove_master_domain(struct arm_smmu_master *master,
 		return;
 
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
-	master_domain = arm_smmu_find_master_domain(smmu_domain, master);
+	master_domain = arm_smmu_find_master_domain(smmu_domain, master,
+						    IOMMU_NO_PASID);
 	if (master_domain) {
 		list_del(&master_domain->devices_elm);
 		kfree(master_domain);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index c4b79bc52991be..98dc5885c48655 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -738,6 +738,7 @@ struct arm_smmu_domain {
 struct arm_smmu_master_domain {
 	struct list_head devices_elm;
 	struct arm_smmu_master *master;
+	u16 ssid;
 };
 
 static inline struct arm_smmu_domain *to_smmu_domain(struct iommu_domain *dom)
@@ -769,8 +770,8 @@ void arm_smmu_tlb_inv_range_asid(unsigned long iova, size_t size, int asid,
 				 size_t granule, bool leaf,
 				 struct arm_smmu_domain *smmu_domain);
 bool arm_smmu_free_asid(struct arm_smmu_ctx_desc *cd);
-int arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain, int ssid,
-			    unsigned long iova, size_t size);
+int arm_smmu_atc_inv_domain_sva(struct arm_smmu_domain *smmu_domain,
+				ioasid_t ssid, unsigned long iova, size_t size);
 
 #ifdef CONFIG_ARM_SMMU_V3_SVA
 bool arm_smmu_sva_supported(struct arm_smmu_device *smmu);
-- 
2.43.2

