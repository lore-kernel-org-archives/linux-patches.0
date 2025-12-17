Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012064.outbound.protection.outlook.com [52.101.48.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11F4F2857FA;
	Wed, 17 Dec 2025 17:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765994298; cv=fail; b=Ww999sZOl9yIASEPAtpKTWLhmfrOd+BOzbtLkM/XgKGvXJJ9uZlU1hGOhFadgmNMPjwfKi246YqfY/7+trsghHFWN9suasobK3RiWTYmXqnEQ86J3VCY8qMgZm31/zLT6k4eDeojOua5s2xbA3hinydnuGPQzHhpMIXewGQLa1Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765994298; c=relaxed/simple;
	bh=fD3rID6h2wMaJjd9lWJvZNVrQQVDgTKA6I1M1pAL1qg=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=SyvnXv4LRXSgLSXL44hLLBJdPSrVgRJK4i8WNlB07mbJZNU+Pw/pFMsqnDZj10FTN+sAzQqSygajgXh/udHEkrxskhkPVyiKpRo+4T4ded//AIz6mOiwR6fIWLnsBuL9tbXMwFUGNXRw1q4GCfWHh9q+glIBwdIIwvPj+l+/Hl8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Ufji3rJp; arc=fail smtp.client-ip=52.101.48.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Ufji3rJp"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=frbyIjtN4ZfpgsDUgB8VGbAXPlUX64dddEXCCt3m4llYURtKAD1bKrKN0tqwg51PGvFiJLY5IBoOBPXo6QDtBgYwdNKS3vCrF5uGMy4pmGJj9Woybq2nJ0n7FJcOHRoGVcZXZjSx1cnf27RNUO8e1Fz5Ajdjx9l8WUWD2BkDmodIQ5MsnCkYUGFg8xUfEpOi4g81rK0Akfn5Ltf/NGKcLW4u4WitDCwMzx2JG38gWMi4POXFulxQMpr6vjiUOC8feDxWvCbvQmBU1ePzABuNT7FkKi0YkTM1WS1a2YlIA95wWHGLOutJMtpOK3dSnZJxy3FsN74I6LhlSedHRNBPYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=108qTJ8nxVJHMVyvb3yfy9XTzFHPaKv8JMfOeJ+SG9o=;
 b=avXTNJnDbJazTHwifskMiEoPcknFC2aDugpgu/Vv+8n7ndlaNbdnbH5UW5RW9370KzlKXpymuv7fMv4BvijkMshSeJOSM2j6hAdFIZFIGUhzEtuWnvzbgZFgNtbw/JscnpulwdW9POPw/PpkHG4IpxuKRzp83OHGvdWa/6SWo5qmgZUdTqEsnT2dvsCC2L+z/NAtevN03LcIvWOqBne0/EZ70rrC1GoZ0/TjdL84yiO8afQpDN/qRgYbPD/3TwQP9aXhnXtjTnPvAYD/JytcWa070SeznSS19ZEfir4uDDN3NBB/flcDPyLHYT/3ipwv2pD0Y2JfVoL9m0jaS3Wz2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=108qTJ8nxVJHMVyvb3yfy9XTzFHPaKv8JMfOeJ+SG9o=;
 b=Ufji3rJpKPDie+xJzU0V7pnJUCKsEbO5SzderrrX4WQIiBipLGroq5wHdfWKc9jCLaeQn4oP/PykwX2FYPhe0QkSfiJox7ju2Td8cFQeP0kZruEaC1G+dF1aXLp3DLprrfFf2lR+2V5JuccEo7lFhzpqxkNslnmeZQhUXrT25niQcHJ706KkWBQkzKAE1koFJQZjaajv/M3wcEN125lTl4uppLhz+FjwYCJ1l8bxZEoWpL48MNox8qT5dzBQLa/cqxqkHh0GZLjhR4qLU+4ZiYs/8eoVlG4xoWS1n+I89jQTd91nby8NB0stUAmI6x80ue8Sh93oFxzSdJ0cWO8yBQ==
Received: from SA0PR12MB4414.namprd12.prod.outlook.com (2603:10b6:806:9a::11)
 by SJ2PR12MB7848.namprd12.prod.outlook.com (2603:10b6:a03:4ca::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Wed, 17 Dec
 2025 17:43:07 +0000
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SA0PR12MB4414.namprd12.prod.outlook.com (2603:10b6:806:9a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.7; Wed, 17 Dec
 2025 17:43:05 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c%3]) with mapi id 15.20.9434.001; Wed, 17 Dec 2025
 17:43:05 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	Samiullah Khawaja <skhawaja@google.com>,
	syzbot+e06bb7478e687f235ad7@syzkaller.appspotmail.com
Subject: [PATCH rc] iommupt: Return ERR_PTR from _table_alloc()
Date: Wed, 17 Dec 2025 13:43:04 -0400
Message-ID: <0-v1-5e883e102420+59d-iommupt_alloc_err_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0272.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::7) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic:
 LV8PR12MB9620:EE_|SA0PR12MB4414:EE_|SJ2PR12MB7848:EE_
X-MS-Office365-Filtering-Correlation-Id: 69a6eeeb-2f0f-47c1-101f-08de3d93bb98
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
 =?us-ascii?Q?ESxDfyj27v6JcGMBapdfF+R8CzLFmgpwZ6TmkczOJdatkRrrvJ18W61OWxrV?=
 =?us-ascii?Q?L+6Hk/KlKECvSiavW8j6w9QLlXfdTCsrSR2biPKHu9YwMBBzK0QCmX0+NN94?=
 =?us-ascii?Q?FTNZGG6Tgt+LVJQWPDbXQFFd2UnksMNE+Mpivnn28LKWy3LXsX/BUSL9rkh6?=
 =?us-ascii?Q?ozCHm9qXmPSf9654VeRTISK6Hj5maBubwyoinod75fHG4/4vQv0Akbu+ciUI?=
 =?us-ascii?Q?aWqfK0g7tCVubUbPn5c7pXXcOqTD137O36DZsOE8a/wvMNk4hu4xdqTmSOhH?=
 =?us-ascii?Q?BnL5/Va1GZebm2gNj8Z4d5a7vQMnurIDVrhSuTeqQHRKnWtMiGQ5Ndy3/SzX?=
 =?us-ascii?Q?68xC3iA6JiCmtzaI4y2TF9+kkvG8SfrErBGt+vj+WxIQm+KWxKAA1EwG1ly3?=
 =?us-ascii?Q?ocQOXWByTxAYrukRcykEre0CZ9CD3/JC+AZrOh+GVl1WW1WRfwAiUM1IJEp4?=
 =?us-ascii?Q?+kGgpRcake5fY33UgRxn7Ud+3M03r789YNK3DQA//tjI4yTTLq0FE+8kG5S0?=
 =?us-ascii?Q?pWP6hbTfYSmK5tZAs5fEhpgB8aD2ZiYKs0QPN4003UYnpa8NF2YKNVN8f4qs?=
 =?us-ascii?Q?dvRciu9FD9djfzaMCfpQp+J1Flu3dRYF4KQeIRswA0M2cmmHqt5ZRVYjpOfP?=
 =?us-ascii?Q?+Vq5OUkiGJZBtn413iOxINEsXRT9NxjKUCM7BNwW5rDij0C/nzxk1F9LhlgX?=
 =?us-ascii?Q?Fc7H8gpkWamU5k2rGrUla790neBNxomSlMdCjoiSAu7iJoFSPAULkptSKAyx?=
 =?us-ascii?Q?glJSDR0FFxbYBKjn5kZG+fdcccIMCW0jnWb8hID3y3eiP+cVdKk8HAI0O4JI?=
 =?us-ascii?Q?R9WvOScfVKX/9Nbk3ElVae1nEV0LHwkIkvirxqj9XFO+leh8SUBD882lNdjE?=
 =?us-ascii?Q?RO5ivpHLKOCAOtlRPZDbPmGqHUMzJA4jBQWP3U6If4OUOjiCuQrl/KC86h1x?=
 =?us-ascii?Q?2qi7yNcqqcHEEzaGx3XTMkbX9G7Yz3kZyYas511mr1TAeldl8+v9eduD9Umu?=
 =?us-ascii?Q?QlRU17dAiVb18/7Vl42JL/S9G4KEKRhgecjzBVbzpCzCtBUgSXhaIUvVqXJ0?=
 =?us-ascii?Q?rvA24zlfEi0d37dwudxNYljxnB+BkW8lnom+x91EogCeKW0t6DRay3Ea02jt?=
 =?us-ascii?Q?aISA8gYGsGWDqYNTAX/xBLGWSV5VJ07WJQSTN+tWvmB4/ek3jx5JciX+tEt+?=
 =?us-ascii?Q?bEKEqP18NDBWHXDi1ye7JLIRdAK7zWt+11YO6wKxmNFQASAwV1GNKjvKMX9v?=
 =?us-ascii?Q?Tpw9vA2rdagH42e06JNzcs8tH1PGJNs5x0cbd69JHjkBGaa6iEf1xXfHnYnU?=
 =?us-ascii?Q?3bWcK9Mi9wTLktI8h374fnCKMS6eoWpmnJx3ztPX549OHr3c7qpDC5IwRhlz?=
 =?us-ascii?Q?7Y7Hi5T1eKynJcP7xULCrCM53YofIzfPb4dmLZtpWi7Dx9KxbpoHEujWl6Ed?=
 =?us-ascii?Q?EYHu7Yz8TZVbi79Brns+sPP+7OyElY8r?=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB4414.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?PJgF2lNVV1vtnK7qCTSQHplgw6tiM1j3G4VMOECcFjSrIg1GlffqFssa0aJg?=
 =?us-ascii?Q?w8Xg16ks1lqySLGfIZLC55H4R0cYqNeHUtMrTTBkd+rj/YyVgLat3VAB8UbZ?=
 =?us-ascii?Q?4KFbqOHDRbR0tl7TSHAzwEMOi9cCfy7KLNRHoXLVoMLIcESYc5UJhkbZoM/i?=
 =?us-ascii?Q?4Pugj9SbyrwQKfaAgnH8WZvZrCsvGhEkCkBBVr+uTfmoEsMNXv1uRWFaKa9/?=
 =?us-ascii?Q?6Pf92SlNYuS1g5xEztgS4oFLm36WGPyZoDQUP4XHsifyVaeK+u81805eUliB?=
 =?us-ascii?Q?Am9mvSGlTlA5Ht6ggDHvoPl2ymmGyt+yKCI3l2bOlzFjrZ4tKUGariKGU09X?=
 =?us-ascii?Q?kkBVS7+XxgnnuYGAOifpefnu2ZIUOjD+zf4od7gcgd1/KSKPDt1AlROVr+BS?=
 =?us-ascii?Q?1qOzhKzAQ2EXMKRzYy6dLfWfkeaJ6z9Aomt90+J23yfFNd7WJ1O30iQoiOTa?=
 =?us-ascii?Q?VFysvNEbSmw7+h4QXPwNnW086zbnv6aPzLbXsvr6E+W8ELftvRO3kdqsGSZb?=
 =?us-ascii?Q?+XFYRVMC7NLD6QNjYFwIThIwh6tG1WFHAgE3fuCj2QuydajmTbg9IZBi4C6l?=
 =?us-ascii?Q?PyMEXQRoaqJrrMntwA1axZ3Oq3DWUW13FBY8RNzGad8p7TRgsev3i4/jG3b1?=
 =?us-ascii?Q?49tXxBKlHABjtJHUrEzf7nDLkFT70zJ+aDc4zm1UCLbHdgr/YV9liBdS5i2O?=
 =?us-ascii?Q?u3l9aQf0xlxz7R6vq21Wzjpsdjm8RrscFBhq5k5vXHHxhRx8EaoWm0QseBUt?=
 =?us-ascii?Q?rsH1xmCOv+UIbOH/F39IMlWpzNTxkr8COQfqsKkyrFlG5k73fqf72XyCJrCp?=
 =?us-ascii?Q?hEGIQUWUUPe3YzmRbvb/ILkkLD+n1HLZ8/8ZopFVxiKPXr0KXMniZf57+u8b?=
 =?us-ascii?Q?vnUUvQ4KtrxZwXr1pheeo1MJYGYMwYc3p+etssD2buZQ5SwMO4e3cZkmHVr7?=
 =?us-ascii?Q?4IbU6SjLoofHad9BZl8sdNmLLp7RTJF89Mv3cK2sBf5AmnAFhw7Dz4rcx13B?=
 =?us-ascii?Q?9WjYShBMw9P+N8JX/kxVF8kDtgVnrrD3STRDD7pkWPtNK3FxzCHl4HuPaGN5?=
 =?us-ascii?Q?U3NSGLXrU6sUVp9F7NO5TJonHJmTxsgbeIaYZi0Fph86hCjDS0Cfo1sEgBLy?=
 =?us-ascii?Q?iYHIpEafYjpbfsBRiEG+pjNC3NohSfrZcVI9YBaNzOnZ0rUUfllJcq+X5zta?=
 =?us-ascii?Q?hsdc0h0QmpE8sVS5o5NNOrGU7PjcQfq7E0JvE3IFr2vlaGWruuI069NR+BWT?=
 =?us-ascii?Q?sRjvUR9eg+qiTVMoCIek+VB6U1hsDS72Ut7loJ49eqOH8ampVN8zOgTdYVTJ?=
 =?us-ascii?Q?R6DinxlBCfEwxxb6raltI9NM6+7Mb4ZYyavVWFVTHHpR8DHpQKkZ8mmX0W5X?=
 =?us-ascii?Q?UJMBf7IwIhXMrq/QyYxTnOEWz6RZBGnclToh8ijNuFMHWhAPQew98NVwONIO?=
 =?us-ascii?Q?BQL5YXXHHcF19JvLGOBnTW/RlXWNSKaaZsiyB6HgAx5XTIbrqEFzAFU0G2vw?=
 =?us-ascii?Q?RCFe+OmvLyJRmiJnBp1fmpF7wS6s93Pz5geOpqjxHyzee7CqnN9m+yIR8yyq?=
 =?us-ascii?Q?o7ABLK78qvAEl1WKLbc=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69a6eeeb-2f0f-47c1-101f-08de3d93bb98
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2025 17:43:05.1640
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bJnwXgVsrO7cyL3VnvMhqP0gUCprzZTP6z5MfkbhSgJrsbitZxry+dcqEge2lQMz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7848

syzkaller noticed that with fault injection a failure inside
iommu_alloc_pages_node_sz() oops's in PT_FEAT_DMA_INCOHERENT because it goes
on to make NULL incoherent. Closer inspection shows the return value has
become confused, the alloc routines on the iommupt side expect ERR_PTR while
iommu_alloc_pages_node_sz() returns NULL.

Error out early to fix both issues.

Fixes: aefd967dab64 ("iommupt: Use the incoherent start/stop functions for PT_FEAT_DMA_INCOHERENT")
Fixes: dcd6a011a8d5 ("iommupt: Add map_pages op")
Fixes: cdb39d918579 ("iommupt: Add the basic structure of the iommu implementation")
Reported-by: syzbot+e06bb7478e687f235ad7@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/693a39de.050a0220.4004e.02ce.GAE@google.com/
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/generic_pt/iommu_pt.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/iommu/generic_pt/iommu_pt.h b/drivers/iommu/generic_pt/iommu_pt.h
index 97aeda1ad01cca..3327116a441cac 100644
--- a/drivers/iommu/generic_pt/iommu_pt.h
+++ b/drivers/iommu/generic_pt/iommu_pt.h
@@ -372,6 +372,9 @@ static inline struct pt_table_p *_table_alloc(struct pt_common *common,
 
 	table_mem = iommu_alloc_pages_node_sz(iommu_table->nid, gfp,
 					      log2_to_int(lg2sz));
+	if (!table_mem)
+		return ERR_PTR(-ENOMEM);
+
 	if (pt_feature(common, PT_FEAT_DMA_INCOHERENT) &&
 	    mode == ALLOC_NORMAL) {
 		int ret = iommu_pages_start_incoherent(

base-commit: 8f0b4cce4481fb22653697cced8d0d04027cb1e8
-- 
2.43.0

