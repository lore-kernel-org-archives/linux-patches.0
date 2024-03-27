Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2052.outbound.protection.outlook.com [40.107.93.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45F0514D29C;
	Wed, 27 Mar 2024 18:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711562915; cv=fail; b=UYkCGy1JOXA5j1tRRHmXzF23gnVdoyTVzoclAchElMvX0MkkAzf+yblg2ondiWByN+RpGIO8UtUs17ZeQzbu1lx7WXv8Dj5YMsUkU00tji1WO5jgk1M/5eADwrdsbNGUjErT3r8mA7ZNfwZrwzIbK9PMrpUJH97CUpicZWPc+wM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711562915; c=relaxed/simple;
	bh=lw7HFuDXn1LgpkojRD658Ju2VynfCAgp2BvR3d3bz9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=L2smFuxjc5vvlwpEW9IQIXK71IEIRH5p/vukIeVtduKleoNpCEkJlEtDLQPX61bpUyOCgpgGPTXhsv80JCqoHOU3lwthPHgB8A5kFciFXlOzNjAalNbGdoppUuedJe4rEReehViWXPLJ3RslHbHPiWtSJXCK6ABADKSG4IY0PTw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=QE4k2jdu; arc=fail smtp.client-ip=40.107.93.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="QE4k2jdu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CO9sLFb5Dn/UkeIcd4sbDGS2nDl8zdPdAlVhkK3VRsjQbyIoz8JT6U+4muezrmSslBTyZsCLT+RgqZJe0Ucwd9x1CGb7KgfpO/BNhDEMiFusglCGEdf1EF4YgKXsIPbyQlBZACCuUI7FcW5mbo+qlhPwQsMboNH/kjf6kHTgb2ymimF/QaQSNcWr7bwsYMw8kalWkgza2C2KFYcovo8L9Eq4Hkm6bzbGyHRNifxFm3yKjRcR6jyHmLn97qz9I9lfH4NL3XrwNusUaMPu7PH3Y2rZpjNnFCqLwYoGTydd45YtMRLfHrWJ3uIp6ouWRmep8g2mKdVBQ/sLI7eJZ4Qi0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g5v/9484J7yDEom6gZ4kYML6HpwQWLCC2pzh9JwczH8=;
 b=jxSZil+pdQSryPkCLKybpmhqKxgp1WHOxWYAgnmdzIhw6iAJYi0xIzOAaq51KpRF2UFgibT7pT9jOGCEQ/n2rp3G++Mfy+dPETf+qYgEQW45dkIuIfFYtuDksaNfDOrzokZkKII7PILMdUkYrdAp0f4m1O7owfGHBgAPJKtkHG5osQeyOR/Cc1O3eNd7n9eqlyTArEV2t1X3DjJQ05+y/zlrQcAaaX/vy6iEnJk0CqtY14qDR1VT33Yw5Ks7E0C2MycdnEashlcrerHDt0+y7PHjfu2AAqejUZ51OLrRedLJ5bQao0byQVUvTDd69jM4YMBB1z8TMyTk9183tjixww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g5v/9484J7yDEom6gZ4kYML6HpwQWLCC2pzh9JwczH8=;
 b=QE4k2jdusKRhWoo3FKWQXRX+c/IkBqNeqX+YCofxlsA+3FpBN2wE5vH6cptDYPuZVrjrSvITxiaS7oYFN9R2aLrz0esnaLgUfi5RVY7QKVW0nbFTbTBue9CHv9ld3+jgR3ex61Wvh81S7D+yWuAHCnnYd57TZaf56C+HBiAMfJql7h5kmatjE/Ren0jlKgx1VBmGt32G2aOrtOnEEyF+NQneEjeUw5CTe1xnvbwNC1LJzeFbacm661Drb3qpBq/1DMmYHHs2ovJHi9kcaF3bLy5d7IUxgII9UOIvpGtMoI5z8MTA+KbqxREZBquwAF/CMLNnDgUEi4BQ8L5bLij5tg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by CH0PR12MB8487.namprd12.prod.outlook.com (2603:10b6:610:18c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.32; Wed, 27 Mar
 2024 18:08:26 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 18:08:26 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <jroedel@suse.de>,
	Kevin Tian <kevin.tian@intel.com>,
	kernel test robot <lkp@intel.com>,
	Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>,
	Tony Zhu <tony.zhu@intel.com>,
	Yi Liu <yi.l.liu@intel.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH v6 21/29] iommu/arm-smmu-v3: Keep track of arm_smmu_master_domain for SVA
Date: Wed, 27 Mar 2024 15:08:07 -0300
Message-ID: <21-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0303.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::8) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|CH0PR12MB8487:EE_
X-MS-Office365-Filtering-Correlation-Id: aaf91855-7165-483d-8687-08dc4e88e15b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	klSwySpAjlnp6WnR5mZt7F1mef7D+aPBSf7fGdy0/p3r6hqR3prs2cwtcpBdoTCMtYhAZ6dQjsihDqYeerMVRtoRv5MR5nxWBD8wPcBfFDnsCYABTqqX6qKXuyqax0tDAp9OPY+04v2uxlJ5TridvisN/4u5KMEG+ReZNUH4AU5RYzmLTm3paXmdaAfIBoA1IyuQ7hOVB8mBZij1lM9WFa3VCOzrlvt1Jbh1xxcYoO+vSq28uwnc2sAusCc8QylcHefoa2iFaSziiFslDgm2aDKCsl44WzUfQB6aBqg6SGGme/GnRF/Iq79YlcGHLzg7riniEg+ENA54EGIGhnCdsZWmqBNkqy568n/LAsfx1BZrp4dP7UatZEOd0Q5/SN0m0Sl9h4d/0iRIcn8sYvoPhvfI3fI61fae2zBlDTwwR3MoiJqXxE0lT/pcJ59w5cB1UJmKbBPmEjrH4uyL4oUPqPFVZocoOzs1qMIvkDnbedICsuZNY7K8dJ5ogwdisVsOd+nY/oVUaMeFulheFF0tpNk9ED37ojvOn85pp/WA68xYXaTBGiOK36ATTyDWtgCPnEkUfCPObF6218VTFee0aNoOtYdfzYNdFIlxbwFIEsqFjmKiENvnGjcYQu3x5iVUcL+ZUVSvDviz5RyHC2vqCb7bd2TSBwmMEV6FCvwPpwg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?F5Naphl2DTXFAa8BikszPzeNngMqHjB1eqa8Ad1O/DRSDUBg2gcAx0kJxxop?=
 =?us-ascii?Q?rzYozFTvgQmGFdaR0/deWYBz8B2paiKU6THAcs5iMkyPc8eWyPj32AAaX+ah?=
 =?us-ascii?Q?D9VIOIWbSlpeR0PzNQxFrZsHOXwO2bot/5GlzYZyzPwyAbHMGudCwG2X4Smj?=
 =?us-ascii?Q?lAVLX3srCyNzughdZaNhgIEyg5ilzMmIdZ9v8NGrPDADWsrED2ye1IQN9Dit?=
 =?us-ascii?Q?MLYP1KKfqgs9CqEUkRcpm0uFV2E5c5sYn4D/kEvUrAND1g4fd5sCS1zzXANe?=
 =?us-ascii?Q?abOPvGHWMFVg6fjzd/1/3ZUd9xpfZIBuwusQYtgE0cYjdJ3C0vt0lhgWuTFU?=
 =?us-ascii?Q?OKGgHPh7yXejAytDN7iXgeJvqIQo91uFX1xDn87Y4i54atxqUTuWPBAbsax6?=
 =?us-ascii?Q?rAoMV2uqK/mz+shk+BAm+VZt8WKqVFyV83PPUpXVGwPQ0qElNCB5wIZhRzAY?=
 =?us-ascii?Q?97Q46VVRxBeE7ETJQCYOwg/PBmNWWn0NohqaxBI9Wp28BPashIqBs9no3Ssx?=
 =?us-ascii?Q?ApEYG0FI3R0KB+jUQQJfiy9QKKYPLP2MKGekWirdRjuwJbGcO7AOczaxZQmf?=
 =?us-ascii?Q?AZnWje7Qb99dPR+NUZp5fpyVyBzHoTWeoleu4VFoZu70pjwxu17MKB9QI2eA?=
 =?us-ascii?Q?3sZVieNRXyWkwEaFrUpych+udRgw/h1StM3naeAwNmJlUB2jKMT+CiA9Hvbh?=
 =?us-ascii?Q?/G7CzuDMwukqYHGadAU0bTa40/AXxhJNBmORTPCzY+TJyZYs4N/tKVTymTw/?=
 =?us-ascii?Q?sGgmT2LmpDNhIniVMxNeNCPK/NPJi6n76/HZByQJasugUpu548s5kEU1c5t/?=
 =?us-ascii?Q?CzqOunNC8KeHwF+aTWDjVZGyau3SQFued8L3KfM0LLuWB8KzeUeS8JM9ffw2?=
 =?us-ascii?Q?U+/IM7A4VSLsGciNIfHeRSQRzP0xSittjgj8panlaOsgWN4OqWPpdawV8ZPN?=
 =?us-ascii?Q?Y8qqjwEg/DXi7AL+nHYo4wx28yg5ThQYyqUkPqhUxfMfFfg7VJiqgIZ/PF5C?=
 =?us-ascii?Q?P+XFTfmZPX2qpnfVLmod9mKtx7HB6iCuqI9fZn9d02PIO7ewtJ8DsE2b7+I3?=
 =?us-ascii?Q?9xg80Et8Eyho52szCvUhi1ytcIdDD0SkdQeKXY3g3dGPWYEGcJtzFGdNgYNo?=
 =?us-ascii?Q?KPRr6DRigOgW9UCyeUM8N4NHnwFwcvnzgCfW6N5wEFOvGwA6bYJZ8QbBwp2q?=
 =?us-ascii?Q?T6Md6SutoMB/N9HqNa5d7E3yJ30uLdcSWohK2ne1zecgB72fofkF+tElV8Ly?=
 =?us-ascii?Q?wDlQzBjtItzvGTVJh9C6unLPd73p1UUQmPLrCoa3A4Xg53TlB8sJzE3Bz6eJ?=
 =?us-ascii?Q?ZwzGxgRwMoGEI4I8JAHcyTYk0ouI3Z1OyvB+HUwx3W2FG0aThcPkGSEUPit0?=
 =?us-ascii?Q?q24aiEmj/AICEdBLVwRijLGMIhG7gWZlVtfVB6Cm/Wfr+I9rAtV4ZJekeJg0?=
 =?us-ascii?Q?n7SGHD8Td8q6U27trSWAqaDNOPJQEwLtH4+nvV0yueKjTC/iMW1pkPuIqgaj?=
 =?us-ascii?Q?FpNXfIcai4/0IBArqicyR2xXMKjR2qYJbyQqTYys7EatzoTH6h3p4Pg/lAcn?=
 =?us-ascii?Q?cxnG7CuTcCpdQ2+FxOls55IIJ6wqqc2mTco9tSjL?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aaf91855-7165-483d-8687-08dc4e88e15b
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2024 18:08:18.4526
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XKFluHDaH2DPj4E8rQNELH0Jer4Liqpnl3tc8G5MVCZ44GkPoeKe0qEvqspqN0E4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8487

Currently the smmu_domain->devices list is unused for SVA domains.
Fill it in with the SSID and master of every arm_smmu_set_pasid()
using the same logic as the RID attach.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 29 +++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 9611ac239fea8c..3d9109ad60c19c 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2586,7 +2586,8 @@ to_smmu_domain_devices(struct iommu_domain *domain)
 	/* The domain can be NULL only when processing the first attach */
 	if (!domain)
 		return NULL;
-	if (domain->type & __IOMMU_DOMAIN_PAGING)
+	if ((domain->type & __IOMMU_DOMAIN_PAGING) ||
+	    domain->type == IOMMU_DOMAIN_SVA)
 		return to_smmu_domain(domain);
 	return NULL;
 }
@@ -2792,7 +2793,15 @@ int arm_smmu_set_pasid(struct arm_smmu_master *master,
 		       struct arm_smmu_domain *smmu_domain, ioasid_t pasid,
 		       const struct arm_smmu_cd *cd)
 {
+	struct attach_state state = {
+		/*
+		 * For now the core code prevents calling this when a domain is
+		 * already attached, no need to set old_domain.
+		 */
+		.ssid = pasid,
+	};
 	struct arm_smmu_cd *cdptr;
+	int ret;
 
 	/* The core code validates pasid */
 
@@ -2802,14 +2811,30 @@ int arm_smmu_set_pasid(struct arm_smmu_master *master,
 	cdptr = arm_smmu_alloc_cd_ptr(master, pasid);
 	if (!cdptr)
 		return -ENOMEM;
+
+	mutex_lock(&arm_smmu_asid_lock);
+	ret = arm_smmu_attach_prepare(master, &smmu_domain->domain, &state);
+	if (ret)
+		goto out_unlock;
+
 	arm_smmu_write_cd_entry(master, pasid, cdptr, cd);
-	return 0;
+
+	arm_smmu_attach_commit(master, &state);
+
+out_unlock:
+	mutex_unlock(&arm_smmu_asid_lock);
+	return ret;
 }
 
 void arm_smmu_remove_pasid(struct arm_smmu_master *master,
 			   struct arm_smmu_domain *smmu_domain, ioasid_t pasid)
 {
+	mutex_lock(&arm_smmu_asid_lock);
 	arm_smmu_clear_cd(master, pasid);
+	if (master->ats_enabled)
+		arm_smmu_atc_inv_master(master, pasid);
+	arm_smmu_remove_master_domain(master, &smmu_domain->domain, pasid);
+	mutex_unlock(&arm_smmu_asid_lock);
 }
 
 static int arm_smmu_attach_dev_ste(struct iommu_domain *domain,
-- 
2.43.2

