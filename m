Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2085.outbound.protection.outlook.com [40.107.94.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACA2D2F5E;
	Fri,  6 Dec 2024 00:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733444633; cv=fail; b=gp+A6nHeMXUZZR5MwbpkqfBYv5vMo/dfoJiqsbSCluz7EZvW58f62jpOl6c0uHqQJLLzwX3cfNswckml9VXAo66sin1ltBzyWzqe4NuAQx0tMLejwfnYzc0omLB8wkHIjJMyiUCNXNCPhJnKWEZ4MhAlPLAagVqQHB/TWIh79Ic=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733444633; c=relaxed/simple;
	bh=ISIsQ7sj14XbAQQRSUyMc3zN30/oJks/cxvQ7NR/YWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ZmfaprTnu/0XaSJWld+qM7rGS0RBlWXAl+EV92+UFxGUmeDmGEzLPcGQgAZMUQRcA8+b4hfLwUuWdIfrY0jr9lNtU2fbQRqAZ+tggAkW+HzXt1XQ80BVZihjm9Bmf1UnaeqX4ivTimAUyCuxNqdsg2kwS9oWb7ITzArWCCIvsYg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Hjhh1I8P; arc=fail smtp.client-ip=40.107.94.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Hjhh1I8P"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gNNqnAqvvr0hNwRmPDHyGbjLzd7g8fax5Pgg3W5kICuHu4KyEiI6dWahQA40+CXotCnVBJMO18/EphvpNpkdxYKcPef1l1txd46huJZhhKlA2XBW+x53YRxsE7Wzu3vK93YInc+k+4ifaV+27aarSj4X4jYQd4u6uCbJT8Kz2Z3jc6vGTyzk8mrgf1x80xkWIHX/DE7kzt1LUQ6+NXYjMqXJh+/ms1kdLtCgvz3p8z1r9RvwVk1UMf15V/Z6k8VpqzYSdZ4DnMsQpaDFp6g/qQozR8NA/KjGEeyoJygnEbWyIW2YFKQcU6civBaExt0FJP+7b1O7MpAl4OsF1Qrmrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/0WJ0KkXCbe0dAnL0aHj5cPNFBVSFXc/uXRumd0D4o4=;
 b=LdpoB8sI0Pjdh60Tl+0F4/JAeie3TtOGNia+sthsum+SJ+9LcEV8wHL1FN/kWkHrmX1zp0Ou7drlFKs6lyn0MTGajDQQZBilTp5qfp0hDUOj6GFpt5Xpf6h/Pnxos51oSCSBfJPninHW4XxNPRbWDI6y4ga1iP0wl5k5QnHgIaGukYXiWXiLjbdvTfYqu8qppBo4ymJvAi5kAuYUVKzce7utQyktMGr66uqghnx4lSaCud1NdeL1Pr4e2cHP0Essg/+S6+UcmuICdBVfd3QCuWUDSMcV+gWhr+jERiGg2RS4Q8lU7S5or01BflPJIfHs4uLNnKuozoR4kH5dh29vuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/0WJ0KkXCbe0dAnL0aHj5cPNFBVSFXc/uXRumd0D4o4=;
 b=Hjhh1I8PhMQaZOrzCGO/+tmcbSjAYxuTWCi49xKi3kfUiu3f34KIWRDazZx9VZIEK/pAH+/ZexUerkg0EJkJKqVq6xMhXBcUfJLrl2nNt5rxsSMOCnZyt+ixh27Jt+9A6epDoUWyFSEfRTQR5CSRE9izYbA97EID5kdzQ0WITOJVg1CDvgsW/rUy0e6ZCozMvf0R7yw3ZJskMo3aL7ewYtZNqjQ+emqzGPlxIKTnc9r5CVgHWj54QfBbRf4fJssVeuYJuqkxCCSgDDNV8/B6e+vdvcf+AzB+ogJaT2e+bq2XWsKPU+k+ivWaBkbmk7cj9Q5gAnWindCQBv5Cx3iI/A==
Received: from BL4PR12MB9480.namprd12.prod.outlook.com (2603:10b6:208:58d::7)
 by CYYPR12MB8923.namprd12.prod.outlook.com (2603:10b6:930:bc::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.20; Fri, 6 Dec
 2024 00:23:47 +0000
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by BL4PR12MB9480.namprd12.prod.outlook.com (2603:10b6:208:58d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.10; Fri, 6 Dec
 2024 00:23:46 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%5]) with mapi id 15.20.8230.010; Fri, 6 Dec 2024
 00:23:46 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Joerg Roedel <jroedel@suse.de>,
	Kevin Tian <kevin.tian@intel.com>,
	patches@lists.linux.dev,
	Vasant Hegde <vasant.hegde@amd.com>
Subject: [PATCH 6/7] iommu/amd: Move the nid to pdom_setup_pgtable()
Date: Thu,  5 Dec 2024 20:23:41 -0400
Message-ID: <6-v1-cf88773f22d1+39bd-amd_paging_flags_jgg@nvidia.com>
In-Reply-To: <0-v1-cf88773f22d1+39bd-amd_paging_flags_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN8PR07CA0004.namprd07.prod.outlook.com
 (2603:10b6:408:ac::17) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic:
	CH3PR12MB8659:EE_|BL4PR12MB9480:EE_|CYYPR12MB8923:EE_
X-MS-Office365-Filtering-Correlation-Id: 8570ac79-e87d-4057-5e2f-08dd158c3e2f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?29QppiuscmFdx/EGC2UFYwlkQWGokp8cphnzk1x9AiK024g+ryroBf8HX32p?=
 =?us-ascii?Q?/zLjt9ZEia6SpvvB/MfcVGnUTjkXkGXrWrHKYk8ZBao5VvkdrCJ9WjUv3A6u?=
 =?us-ascii?Q?Nzikj93uoRF19pzBn4zKUlyN8m9qklMLk6vZC4i6i+PJb0I1dIXdkPD+Im94?=
 =?us-ascii?Q?pHpP97zOVv/5txSG3zDUrrxOMr2mioJ5wcCX2nDcV9oU8poa9HnW3BX0A8p/?=
 =?us-ascii?Q?qNm7iECSnynrgaC53Gya8f6HX2yrDa9O/jcMs8w1Nta1o+PHyDD6v+/m+uAm?=
 =?us-ascii?Q?v4Ru6rrsb1p/lbAGGH2OkFE5GlT3M6aeraFzE/oVJc6MohMwErKbXslSLE4e?=
 =?us-ascii?Q?NY/St7XHxrBkxH45sYjm7gxiV1BQWU1EPWaIDw7hRd/v5PZqwv062ThyM7Ow?=
 =?us-ascii?Q?hZjmWMAJNYoxRQRsxz1S61oHDw/zN2DEnwBgOyeLOmq1vrHvUh1l7YcRRWs6?=
 =?us-ascii?Q?DUWKoqaeKLga0a/h1Mm+K3tnoaVoR0txZnPvASKeTI6UfeZypBpV/nzfHMuG?=
 =?us-ascii?Q?hVXnwVrDk7skj0p9mTiWh9D+p313tzjAoHjud3eymNpyTwFJXN9J/FvxNUoO?=
 =?us-ascii?Q?EREDixD8GvI3ZoCfw3IKCbrCvDvrJPO6SasJEQlVOynCOqX0Lm517LDJJr4j?=
 =?us-ascii?Q?c6d6lLwFUT6yIHTc6wK606Do+HMCqtUqgKJ27JwYIcncYudH+CEEJqS0QtDT?=
 =?us-ascii?Q?kmCRLVZJec3+j09K7esKKpbq+1udQRFR6HRrJ6h/YysaGrXEMO0xPWUKni8r?=
 =?us-ascii?Q?lI6mRdgmyKjfk9w9m/NNhe1buGe1jLqUtqxSq8V3Jf5AFphnhCV8i1cMFu3k?=
 =?us-ascii?Q?3DMqmqRLAay00xIsvy0Nflq75Nx+NPj3aJll0ihZuyvMn6KmelvA+/trP2P6?=
 =?us-ascii?Q?8UyP3ZrnVuVEa7z8qNHWiShB5mPWrTHQPs1bmfl8Nyf4tWaKizR0Ct+yPIg6?=
 =?us-ascii?Q?K9O5bhkq4aDcpkKsmx8rxf5S3k+5Dj38h4tSC13BE667Dw5NVIw7KFD1L80l?=
 =?us-ascii?Q?CDsm8awd7TtmF9wZjNzfFDwtwz3ghL+YQKf8y//YJfvFO0Mr7oq/YsKFCELL?=
 =?us-ascii?Q?cs0g4nvmKKqf54RSlspTWkvp5uBIbj76yWfHtgPg337xm3h+hsLs7X74jYEG?=
 =?us-ascii?Q?uNOto0pCbizy3nkTxXo9lcH08TkXAF974uzNECvJfDNjrl3sdUf3JVJ6bXaI?=
 =?us-ascii?Q?3t8HCJu9mITZPz4Oc598zaTRiQTe62PsM1eJxYQ+dcKWOZPdnwZd5a3CaaTr?=
 =?us-ascii?Q?Ek7iOwoQo8ix11xT6gIzyFHXSJBNSIKfdJznxU3nQPzq80i+aB3sH/o8RcIb?=
 =?us-ascii?Q?BKuEzgB1PoJtQky1cCC4Z/+rHywll2qPXPiwQVYENEap3A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR12MB9480.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xoZ7vdhyFGKh8iB/ndoNLeuutp+8hSXuK8JRILsmZTEARp54ZNRiffbEtkrg?=
 =?us-ascii?Q?lc03WVgNUU/njbxzSb6s0DquUDpO1/UVidaAHW5Wlc6+BiVeBb1coJ7HrCzo?=
 =?us-ascii?Q?ZorXwvLkd8fHtYLUZMSqJFd1GVFcPFU4pBG8pPn4n6DFePVQwVBuszP+9OVB?=
 =?us-ascii?Q?RBg8AuHR7MoclZ4TS+LPjTSlezPFAxvTutUGsJY9Lj+4wXgf0DWpAHd9QCZ9?=
 =?us-ascii?Q?at6V2r/L1tx2/on7ii3kgyVaqjhh5moau9wAPxARw0fiY9ov1OW+5QtFRhxP?=
 =?us-ascii?Q?V6uwYe37VGJzIbFOppoqDjYqzQrX71FuH19wcEeCmcsNO3RRU6GG/K970uyI?=
 =?us-ascii?Q?6fbLT3a6A9ldh0uzhuvx57GtvqeI/xYuzreq3zSay0TEofcwUjS/PDMMYiCZ?=
 =?us-ascii?Q?bD7kf77L3qlNyf5jKNi+gqVRy8DXu+J2eaDoLhtDvix61e6R7x7bQ6KE7m8Y?=
 =?us-ascii?Q?xXKrhuyjyD4UWEHIbJLpjLejTuBvFelsEr2E/CgoqeaNKBK1/NR2GxQGj99T?=
 =?us-ascii?Q?RzNdumGsfwX6pXxt104+IeTjewyYA50vC6hRxwaGHyccCv5qFRfv5S68yAO4?=
 =?us-ascii?Q?BD29KsM84cGA+CWpa+an2oHH+9fUqIo/dgIL98JrSk/S5Ln7CsNi2la4/wcP?=
 =?us-ascii?Q?h8hE6U3ddzWWRG8U4l890DlFUas30WTUwYh26ZgXykF9WNp0IKr6fXH8TkEf?=
 =?us-ascii?Q?SX387CoCgcaoExAJFy2tB+xuXpRIRD8jSp8hSgGbwlg5ajMYdEY2k9I7Ugxo?=
 =?us-ascii?Q?tp+hQBSfFo0olKTWDW4XaaOlu/RkFNXgHzXvWxSHpGkmeV6Jg+Wkr26MlRJ1?=
 =?us-ascii?Q?vz0M3kR1LvdwQVrd7PnKSUczL9P77w708phNsiU4MQetLCgzDEof1RYI/LZD?=
 =?us-ascii?Q?rnttn9EE2qt05uJC0HanpXguLelQxL4EXZHQv3SO8lGaIbBb2UUzrwG1mPHR?=
 =?us-ascii?Q?z/rTCqQ9Xh5IwIe3kdjnUDpBmMphYha8ggTCAlFeq7UWv7Z0dRa48RPBb9OL?=
 =?us-ascii?Q?9pLFJypcOAwiRc2mVIzBnU/3TdJkS++k2fw9cFRDhro/C9Q26WEoXPkX+hhM?=
 =?us-ascii?Q?DwuG46LJSXWW3HfWbO9oABaqzve6I5SurFT1GQQDWMSJBag3utNoDZPbga8Q?=
 =?us-ascii?Q?k5B33fFJ001JkxcJH7lYLTZLAZB3RWXs8gQYXJ2bxXWKvD7UlS91rDuVRwaM?=
 =?us-ascii?Q?iGXEF86phIJnscROoocbGDFpl+KywMmoCQczzV2Rqld2zMUdH2NPcl7UPVRL?=
 =?us-ascii?Q?+a+NWgH4Zxm+RosKE+2D2+75SaQeR1wwh1g/1xJ0A4fL2/CkKmiyQAzwPCha?=
 =?us-ascii?Q?U/LewWfGXlDorjao1RDmQ4ZdUge5Vg5vqdhR5PIJApy94Vs1EKCuFhjlu+an?=
 =?us-ascii?Q?or34yswpg6bnLUcq1ZoSq6BJs3JPogL5Is1agJ84WIdIg9xZAo66zxqOGTrN?=
 =?us-ascii?Q?WxT7TSyr5IFvvHQiIopjzc3tXtktPKF3HdadkXnBV/a5pyhpLCkG8Du3tL6t?=
 =?us-ascii?Q?Rmnuh2g4TBo/rLmZBiH+Gvzh1Aoav7fgX5NJjP5Ca4wC1gu216vGAQTplRvp?=
 =?us-ascii?Q?h+3Ox3L2u0k/LeoxTKqvmWg0jCWB0c67bGqv/L53?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8570ac79-e87d-4057-5e2f-08dd158c3e2f
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2024 00:23:44.1494
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UPvrzDBTfv4cxcP4oaD0bufrY9M/LQGaP2WzwiBBrt3j6O8YJOmfDaHzJTWFNyzU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8923

The only thing that uses the nid is the io_pgtable code, and it should be
set before calling alloc_io_pgtable_ops() to ensure that the top levels
are allocated on the correct nid.

Since dev is never NULL now we can just do this trivially and remove the
other uses of nid. SVA and identity code paths never use it since they
don't use io_pgtable.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/amd_iommu.h |  2 +-
 drivers/iommu/amd/iommu.c     | 22 +++++++++-------------
 drivers/iommu/amd/pasid.c     |  2 +-
 3 files changed, 11 insertions(+), 15 deletions(-)

diff --git a/drivers/iommu/amd/amd_iommu.h b/drivers/iommu/amd/amd_iommu.h
index 6eb0af2e033907..b0a30fa717ca26 100644
--- a/drivers/iommu/amd/amd_iommu.h
+++ b/drivers/iommu/amd/amd_iommu.h
@@ -47,7 +47,7 @@ extern unsigned long amd_iommu_pgsize_bitmap;
 
 /* Protection domain ops */
 void amd_iommu_init_identity_domain(void);
-struct protection_domain *protection_domain_alloc(int nid);
+struct protection_domain *protection_domain_alloc(void);
 void protection_domain_free(struct protection_domain *domain);
 struct iommu_domain *amd_iommu_domain_alloc_sva(struct device *dev,
 						struct mm_struct *mm);
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index e0c12dc44340cd..c84eb3e7bd8bef 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -1998,7 +1998,6 @@ static int pdom_attach_iommu(struct amd_iommu *iommu,
 			     struct protection_domain *pdom)
 {
 	struct pdom_iommu_info *pdom_iommu_info, *curr;
-	struct io_pgtable_cfg *cfg = &pdom->iop.pgtbl.cfg;
 	unsigned long flags;
 	int ret = 0;
 
@@ -2027,10 +2026,6 @@ static int pdom_attach_iommu(struct amd_iommu *iommu,
 		goto out_unlock;
 	}
 
-	/* Update NUMA Node ID */
-	if (cfg->amd.nid == NUMA_NO_NODE)
-		cfg->amd.nid = dev_to_node(&iommu->dev->dev);
-
 out_unlock:
 	spin_unlock_irqrestore(&pdom->lock, flags);
 	return ret;
@@ -2267,16 +2262,15 @@ void protection_domain_free(struct protection_domain *domain)
 	kfree(domain);
 }
 
-static void protection_domain_init(struct protection_domain *domain, int nid)
+static void protection_domain_init(struct protection_domain *domain)
 {
 	spin_lock_init(&domain->lock);
 	INIT_LIST_HEAD(&domain->dev_list);
 	INIT_LIST_HEAD(&domain->dev_data_list);
 	xa_init(&domain->iommu_array);
-	domain->iop.pgtbl.cfg.amd.nid = nid;
 }
 
-struct protection_domain *protection_domain_alloc(int nid)
+struct protection_domain *protection_domain_alloc(void)
 {
 	struct protection_domain *domain;
 	int domid;
@@ -2292,12 +2286,13 @@ struct protection_domain *protection_domain_alloc(int nid)
 	}
 	domain->id = domid;
 
-	protection_domain_init(domain, nid);
+	protection_domain_init(domain);
 
 	return domain;
 }
 
-static int pdom_setup_pgtable(struct protection_domain *domain)
+static int pdom_setup_pgtable(struct protection_domain *domain,
+			      struct device *dev)
 {
 	struct io_pgtable_ops *pgtbl_ops;
 	enum io_pgtable_fmt fmt;
@@ -2311,6 +2306,7 @@ static int pdom_setup_pgtable(struct protection_domain *domain)
 		break;
 	}
 
+	domain->iop.pgtbl.cfg.amd.nid = dev_to_node(dev);
 	pgtbl_ops = alloc_io_pgtable_ops(fmt, &domain->iop.pgtbl.cfg, domain);
 	if (!pgtbl_ops)
 		return -ENOMEM;
@@ -2341,12 +2337,12 @@ do_iommu_domain_alloc(struct device *dev, u32 flags,
 	struct protection_domain *domain;
 	int ret;
 
-	domain = protection_domain_alloc(dev_to_node(dev));
+	domain = protection_domain_alloc();
 	if (!domain)
 		return ERR_PTR(-ENOMEM);
 
 	domain->pd_mode = pgtable;
-	ret = pdom_setup_pgtable(domain);
+	ret = pdom_setup_pgtable(domain, dev);
 	if (ret) {
 		pdom_id_free(domain->id);
 		kfree(domain);
@@ -2445,7 +2441,7 @@ void amd_iommu_init_identity_domain(void)
 
 	identity_domain.id = pdom_id_alloc();
 
-	protection_domain_init(&identity_domain, NUMA_NO_NODE);
+	protection_domain_init(&identity_domain);
 }
 
 /* Same as blocked domain except it supports only ops->attach_dev() */
diff --git a/drivers/iommu/amd/pasid.c b/drivers/iommu/amd/pasid.c
index 9101d07b11d3f7..11150cfd67182d 100644
--- a/drivers/iommu/amd/pasid.c
+++ b/drivers/iommu/amd/pasid.c
@@ -185,7 +185,7 @@ struct iommu_domain *amd_iommu_domain_alloc_sva(struct device *dev,
 	struct protection_domain *pdom;
 	int ret;
 
-	pdom = protection_domain_alloc(dev_to_node(dev));
+	pdom = protection_domain_alloc();
 	if (!pdom)
 		return ERR_PTR(-ENOMEM);
 
-- 
2.43.0

