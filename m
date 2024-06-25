Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2050.outbound.protection.outlook.com [40.107.102.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C4E573463;
	Tue, 25 Jun 2024 12:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719319075; cv=fail; b=Y+SZbznppGaIdsbxAl4ezHh56giqnjX4FBYVULDE8wxJV7XGxGPj62E9s3cSxN3y+Q9J9uRjQp3lD3KZTwQEn6JlagJzD2KWY9RniQ+SuUEbUkEtgc7sESnES/os/RbezstR2HFKwMQ3su2PfcDf7faIQitUGDeJT2yrO8jIWno=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719319075; c=relaxed/simple;
	bh=bblHHuncDW1zo05wyCY6wkCWKII5aR9/WtAoPUj54rE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qOCiobxOmXwPHEorpqtRUe1hczN1ycaMz+WstQUIhIlTTURYX/NTubjY8vujwVxoh2Gbw5aoMaca1iSvLg+8RGS1gwaf4aI3gxLUQAxJsdSFN9qTwweZBWAywcspzexOaB8dv31ilasLJ5c90Rikh5QbBUYTqEi/XchbBqK4S6o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=kZou4tYv; arc=fail smtp.client-ip=40.107.102.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kZou4tYv"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JfFtcVUAzGz81NjgKN2ZyiySEdTUbfzuvFDMaUkRydQKGLrV1oAsN79GnOQ5e2wYuMhgDI1X9kACyU6VaVnSv+pT5ZrLCYe/9VsXFUOQ2Yp+44LsZNB7Ry/IE3ysfDtXz91SsPk6nAC28Qv5wu2hmn3Ek6Gyvv+xZRSBdGYALJwuQ+Bs+MhzJnezt0FhdQUVUCxG62DfONZ2Y0/m+JDuL9PobOea0rSdMfDRLuQ3jkHuzhG+lpgv/8qpTTKBtTgRKtJAU/IdQG3HayuMlTFP9bcSTMwvYI5An4MCA35h3s/Tzu7c/F+vs/YA9r54oQ6TgGvZU2Laz8OTW90KiIBr+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RiQNhmMdDikOXGESry1EWwFazvSFA/KajKnQo4+YLMU=;
 b=P0aw/fsa6K13UkdKd//jH5Tr05xieHtpcFwHujCuM3Wc5j0JCVNY1AZ1N897xnbIwXByRDnuS9yw5ZVFt5/DVIYv3XEiRBV+jovMrBLlcQkvX+qpdkonGZ7BANJSXjlKXVh+Qy04IIDCtnCrzGWr4r5juPkNeQSsCFOhyTRXaZuw8/Ryp5hfVnSbbRGFLDk5UnV403qfKKYKggRoi/NbSkkZa6hiT5gGtRhBdT6zSZNFkeEIB5CVTGkBKiQjWB6MHayBAPWXLtq/BtAr+hVJ5sUxpmarEHLDR6bRsHMLu7SOVfC8DMfU5BJ6v84yAdCNIR3b7pyfLJs9s3//8d1+7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RiQNhmMdDikOXGESry1EWwFazvSFA/KajKnQo4+YLMU=;
 b=kZou4tYvuoHTBofQLcLVYjMpPdHFTCcuq3DttunY9MxpTl24DQgJQcM0JRuUtaJUzr9KVsDlv31b0vDGF5mwlHUoQ8mMkRK3lkZZWwc+6E59b4iUGxtB8m03SO9bAjGGLR4hKje6bgdGPapofVtcDeBr/C6mUN4Ro00lF+RVyvcLbzdd/e7s6220h78+j9r4To7dXPPz+ySJKMKtMYPnl6i6Fz1J1SlL3IQj3LTlo82u8AXQYmqucQatzX79CvQMAkgAwvu+1NGhoeuUnznneIw6U9dDikMnjqT1JrxI/DrGELoE4YzS+d3eHUrWCPodTxMQ4rehlPIDDctduPqicg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by SA1PR12MB8946.namprd12.prod.outlook.com (2603:10b6:806:375::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.26; Tue, 25 Jun
 2024 12:37:47 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%6]) with mapi id 15.20.7698.025; Tue, 25 Jun 2024
 12:37:47 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Jerry Snitselaar <jsnitsel@redhat.com>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH v9 02/14] iommu/arm-smmu-v3: Start building a generic PASID layer
Date: Tue, 25 Jun 2024 09:37:33 -0300
Message-ID: <2-v9-5cd718286059+79186-smmuv3_newapi_p2b_jgg@nvidia.com>
In-Reply-To: <0-v9-5cd718286059+79186-smmuv3_newapi_p2b_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR08CA0022.namprd08.prod.outlook.com
 (2603:10b6:208:239::27) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|SA1PR12MB8946:EE_
X-MS-Office365-Filtering-Correlation-Id: ed97b583-3157-4631-6aaa-08dc95139d95
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|7416011|366013|1800799021|376011;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8WLJbyrueB7Nl45DjwZo79OLbZ2nFt50KfAfrhoYv0vvd65rLiGZS2F56UbJ?=
 =?us-ascii?Q?YJ+Qv93Tgo93Oa25d3E/gGH8Uxdeto6yaK1O0fAw2IpAHcGEViIYGB61hXdL?=
 =?us-ascii?Q?A+H9KK62XODQzo9GzmnEh+qIygHNKPZim+JJogFFAuhpAM/X62WMVPeQyKQ8?=
 =?us-ascii?Q?qR+BmmKzkyLrdlw324XA6wxMY+WX3iEpprZOr86loPPbzZfv15aj+ObXSAb+?=
 =?us-ascii?Q?a8/iKgJEcIGXlko5mpR/6QPCs4GhNG6w/Kw/ckbLV461b+0VJ9UWLeFmVO/H?=
 =?us-ascii?Q?gt4kbkmlZwzrLvWbpTq+V+ddAtbCWuWmJ94+p+hNP4Rhm+aawzhw5Pp/hA7s?=
 =?us-ascii?Q?XEuIp/1dAx4/HDGVDGumZBWsCLzGuF4Or2QAPOHxw4p7f1Ew9alQ0znoNYyR?=
 =?us-ascii?Q?FRY9bJmyGaP6H87qJfmwSqQlRQC9akbEZXuNewXLCD/vh8h+kYjcTFHlA5z5?=
 =?us-ascii?Q?dfOhUOGCjVzH2LlPfQO98O2VDLI3EzZqVOGvg1RCxEtzL4oaszz23RrHMdzw?=
 =?us-ascii?Q?3s+KLMs1L6YSZx/R9VyzKtwJVp3HZ5wc49hCstgT3xNhOXkeQkZB1kfqAQAd?=
 =?us-ascii?Q?2+81DAhcmUGc8wLxJ1uHo4HZXGqrnf9NEb5OHIrXBTG8+GgvAc8MuP43n4iS?=
 =?us-ascii?Q?sfBuDZo6aVgefxJ4EkGY5iy+OEUTH+xlO/pMbHlYhxQFkw07D9odP5ucdzVk?=
 =?us-ascii?Q?rnO8G8d2HZPsok0J/mpWW9Ty792NFhjE9z/GuXecnwLgowHsDIDBYy4MD8N5?=
 =?us-ascii?Q?FACUZbwSlGIWp3tB9MhPR2wAOoxKVnoB348vlC/7SqkTJS6Vv0rn3m6vLsD2?=
 =?us-ascii?Q?rhD8AF7drtq8VPDS62ujpYzIYbttf3r69dhGFFrm2RneehK5gc29pkDue3x8?=
 =?us-ascii?Q?KsmT/98AoWuYrgoYisr5Gaf9NAJeMrovY907piC28Q4YF6HyqL4wEFpA3fxr?=
 =?us-ascii?Q?TfLHLi5fCW4j6O4a13pPnBg0PsQCvVHQTjvSVv9KW1MIWYGcbXW7MtB4h/N8?=
 =?us-ascii?Q?+anR/Xke4ZXzID/h6r2PyFksAJpioMZ+pZO9PNWJTU5A0anQ8UAY7ZGJpgcr?=
 =?us-ascii?Q?GHRS+3sTgKw0n7cBW6KuppVGNEaxszMaiPhmqsyJhU2sRlcD2BYadTN2BBEt?=
 =?us-ascii?Q?F6WsOCP5+w/Up7NspygI+Ko3nEqLfLeMOemwZqbArSBE/0hdTikQMAnJbgrV?=
 =?us-ascii?Q?TNThUwjc5JTAzSFODFXiiiMoGCC41e6P5jEV7LSr+OZKkjI11kydvWbv+Avw?=
 =?us-ascii?Q?iEv1Mv97Vunrs5cd8UT7pbq92Yn8AFI7F2xBNjuUcfsXgrP4wcsttS6fmTKu?=
 =?us-ascii?Q?LYc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(7416011)(366013)(1800799021)(376011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4lPuljBv07SiLFSrqZXfYedVPj87IWZkHqzAz91+Y07FsyQQLogXF1Bn0ro2?=
 =?us-ascii?Q?wwbSaO9vTf8zmR1O9WKuhSLLSFfXD2RmuHcOPy90RtLhAg67CYpMliLCkeJS?=
 =?us-ascii?Q?J+xTem3YCNoSDITSWGR1sNiFIpKd5huGzHU6UyIQD/X8fiO/CkTTUEc9qLR5?=
 =?us-ascii?Q?TqrPJEqig6fxhrDxXQhMdNFOhqzfu2uF7kkRBHIDJBQGzLkuThY5ZqGOKdpC?=
 =?us-ascii?Q?Hwp+gYQbK7+bwM/eOgWxgWYnsLJebBRe99LrLO+kERJlDQh6yf+7wp/oaH7B?=
 =?us-ascii?Q?PBE8iiFOKPw051vq7sgb26GjSvYSWJYqsZUxZwMf84mBWKA2KN+osA12svxY?=
 =?us-ascii?Q?2Z7vKN1ml7L6onV7wYNvTc5MeU7893K7MqELM1qELLQRuumX068OsuOETVm3?=
 =?us-ascii?Q?cjWYzptgz5Q8i0cmBBsmHUW3PJqY7uAOpEND6ikfKVZ8Xvhd91L1D3DWQeuw?=
 =?us-ascii?Q?24mPNoXRtlgLvgTpZDxnP5vMWelVSshTPfP/PT+WWmqVjHX1NURJuQiGOSm8?=
 =?us-ascii?Q?hFAueJQicQ/wgk/YyseEoSSUm9bWK4qyOE72CRYNDkqmPBIi7DHfcgf8ER3s?=
 =?us-ascii?Q?5FOx8zNrPMEHRomIB0iXw726ldPY6kfQciio5Lr6aJSJ18FysW3pjp2l3EfV?=
 =?us-ascii?Q?fRVcokJr0AcAHDMBjEcDXuqv8Yl/w6sdWPwabksrQN5TjMjU39lmV9Iu+F0q?=
 =?us-ascii?Q?voSYUsh4m0boz6MllqcL4Q+fTIO7kPSQtGKo8QRu/kU2yr7s1mMjzi9vDgAY?=
 =?us-ascii?Q?jAiCJPQRnMCcSuPCl4TJcEHXNh4ExGyj8z6RydQd0OESs15vD8dIV6oUV0ne?=
 =?us-ascii?Q?HKfPn2DitrW3qRg5yVAI+kv2FUxFCA6xRPqW17f1PQnVA77LNpgdoX3KsL6i?=
 =?us-ascii?Q?3lwnk3LvXh3CHeaoKTh1J2Caie8EJX/3MFGz7u+IvZ6LtsXwIXmqARQ7lUlF?=
 =?us-ascii?Q?xRZQTNW95zYuT8SUvujhsoN/Tiv3CeZ2rgRoOLRiD/6a6rqTtaENnrIQgU98?=
 =?us-ascii?Q?Li4XOuDZZF/Nr1GeLBmlNMqRejcE04bExE2KCWCb2lrXWRVFnHDb8rOHUSLc?=
 =?us-ascii?Q?smkD+YR/fA+XKnYrLiiFnHRra/5eQ1tGsepFM7OTJgqSGXzQ7Dcvo7jw/RBb?=
 =?us-ascii?Q?LYlxTikuKUTUtwyXevXGRhtv1YakQIeFR2UN66iXzWzlF1rabU7m90kJQGVj?=
 =?us-ascii?Q?yis7qfnPfDGBJ/Uv8nfh9YQlfBTPSl5Y67dDTts0m1ZoOgwZrASvVrlxP+m/?=
 =?us-ascii?Q?WXYobfGRpkmGq33BG+2IgeXVGnk0PCUFvRX5cZqQh4PTYgJVEslmXrOTGn32?=
 =?us-ascii?Q?Jmjwpb94Tu/mP/1PICFKqJNTudXrgXOrTuLCs1twQVNpW2vbC3DEH+Pjxl/l?=
 =?us-ascii?Q?zTbVjkSGAUfhH0ty2DhwPjB8TN1cIn8xPbEGFNJpDmDBw5gaq7gAVq9lozbj?=
 =?us-ascii?Q?eawXU4hw82NYBvZuz8K/JsXp+6WIytxMCLgYv9lLhdaAiZvPx8Timw0wFIaQ?=
 =?us-ascii?Q?Kc9v0BPCqBjBGPJ70f37WeyRz8MTC9G8hBVFZhgFwINGtGYB/dzneHT9tHGK?=
 =?us-ascii?Q?5ZlnO8qVgAYWL/hmGpXVG2YteSKyB0a8wWeHJ0D4?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed97b583-3157-4631-6aaa-08dc95139d95
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2024 12:37:46.2611
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L5NFu0OPLXLhdOKxPjJfyTqGccFBW5d2QrplGiQo0N/KgK+BoSt2ln8LWs9iwaWi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8946

Add arm_smmu_set_pasid()/arm_smmu_remove_pasid() which are to be used by
callers that already constructed the arm_smmu_cd they wish to program.

These functions will encapsulate the shared logic to setup a CD entry that
will be shared by SVA and S1 domain cases.

Prior fixes had already moved most of this logic up into
__arm_smmu_sva_bind(), move it to it's final home.

Following patches will relieve some of the remaining SVA restrictions:

 - The RID domain is a S1 domain and has already setup the STE to point to
   the CD table
 - The programmed PASID is the mm_get_enqcmd_pasid()
 - Nothing changes while SVA is running (sva_enable)

SVA invalidation will still iterate over the S1 domain's master list,
later patches will resolve that.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 57 ++++++++++---------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 32 ++++++++++-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  9 ++-
 3 files changed, 67 insertions(+), 31 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 28f8bf4327f69a..71ca87c2c5c3b6 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -417,29 +417,27 @@ static void arm_smmu_mmu_notifier_put(struct arm_smmu_mmu_notifier *smmu_mn)
 	arm_smmu_free_shared_cd(cd);
 }
 
-static int __arm_smmu_sva_bind(struct device *dev, ioasid_t pasid,
-			       struct mm_struct *mm)
+static struct arm_smmu_bond *__arm_smmu_sva_bind(struct device *dev,
+						 struct mm_struct *mm)
 {
 	int ret;
-	struct arm_smmu_cd target;
-	struct arm_smmu_cd *cdptr;
 	struct arm_smmu_bond *bond;
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
 	struct iommu_domain *domain = iommu_get_domain_for_dev(dev);
 	struct arm_smmu_domain *smmu_domain;
 
 	if (!(domain->type & __IOMMU_DOMAIN_PAGING))
-		return -ENODEV;
+		return ERR_PTR(-ENODEV);
 	smmu_domain = to_smmu_domain(domain);
 	if (smmu_domain->stage != ARM_SMMU_DOMAIN_S1)
-		return -ENODEV;
+		return ERR_PTR(-ENODEV);
 
 	if (!master || !master->sva_enabled)
-		return -ENODEV;
+		return ERR_PTR(-ENODEV);
 
 	bond = kzalloc(sizeof(*bond), GFP_KERNEL);
 	if (!bond)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	bond->mm = mm;
 
@@ -449,22 +447,12 @@ static int __arm_smmu_sva_bind(struct device *dev, ioasid_t pasid,
 		goto err_free_bond;
 	}
 
-	cdptr = arm_smmu_alloc_cd_ptr(master, mm_get_enqcmd_pasid(mm));
-	if (!cdptr) {
-		ret = -ENOMEM;
-		goto err_put_notifier;
-	}
-	arm_smmu_make_sva_cd(&target, master, mm, bond->smmu_mn->cd->asid);
-	arm_smmu_write_cd_entry(master, pasid, cdptr, &target);
-
 	list_add(&bond->list, &master->bonds);
-	return 0;
+	return bond;
 
-err_put_notifier:
-	arm_smmu_mmu_notifier_put(bond->smmu_mn);
 err_free_bond:
 	kfree(bond);
-	return ret;
+	return ERR_PTR(ret);
 }
 
 bool arm_smmu_sva_supported(struct arm_smmu_device *smmu)
@@ -611,10 +599,9 @@ void arm_smmu_sva_remove_dev_pasid(struct iommu_domain *domain,
 	struct arm_smmu_bond *bond = NULL, *t;
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
 
+	arm_smmu_remove_pasid(master, to_smmu_domain(domain), id);
+
 	mutex_lock(&sva_lock);
-
-	arm_smmu_clear_cd(master, id);
-
 	list_for_each_entry(t, &master->bonds, list) {
 		if (t->mm == mm) {
 			bond = t;
@@ -633,17 +620,33 @@ void arm_smmu_sva_remove_dev_pasid(struct iommu_domain *domain,
 static int arm_smmu_sva_set_dev_pasid(struct iommu_domain *domain,
 				      struct device *dev, ioasid_t id)
 {
-	int ret = 0;
+	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
 	struct mm_struct *mm = domain->mm;
+	struct arm_smmu_bond *bond;
+	struct arm_smmu_cd target;
+	int ret;
 
 	if (mm_get_enqcmd_pasid(mm) != id)
 		return -EINVAL;
 
 	mutex_lock(&sva_lock);
-	ret = __arm_smmu_sva_bind(dev, id, mm);
-	mutex_unlock(&sva_lock);
+	bond = __arm_smmu_sva_bind(dev, mm);
+	if (IS_ERR(bond)) {
+		mutex_unlock(&sva_lock);
+		return PTR_ERR(bond);
+	}
 
-	return ret;
+	arm_smmu_make_sva_cd(&target, master, mm, bond->smmu_mn->cd->asid);
+	ret = arm_smmu_set_pasid(master, NULL, id, &target);
+	if (ret) {
+		list_del(&bond->list);
+		arm_smmu_mmu_notifier_put(bond->smmu_mn);
+		kfree(bond);
+		mutex_unlock(&sva_lock);
+		return ret;
+	}
+	mutex_unlock(&sva_lock);
+	return 0;
 }
 
 static void arm_smmu_sva_domain_free(struct iommu_domain *domain)
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index bd79422f7b6f50..3f19436fe86a37 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1211,8 +1211,8 @@ struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
 	return &l1_desc->l2ptr[ssid % CTXDESC_L2_ENTRIES];
 }
 
-struct arm_smmu_cd *arm_smmu_alloc_cd_ptr(struct arm_smmu_master *master,
-					  u32 ssid)
+static struct arm_smmu_cd *arm_smmu_alloc_cd_ptr(struct arm_smmu_master *master,
+						 u32 ssid)
 {
 	struct arm_smmu_ctx_desc_cfg *cd_table = &master->cd_table;
 	struct arm_smmu_device *smmu = master->smmu;
@@ -2412,6 +2412,10 @@ static void arm_smmu_install_ste_for_dev(struct arm_smmu_master *master,
 	int i, j;
 	struct arm_smmu_device *smmu = master->smmu;
 
+	master->cd_table.in_ste =
+		FIELD_GET(STRTAB_STE_0_CFG, le64_to_cpu(target->data[0])) ==
+		STRTAB_STE_0_CFG_S1_TRANS;
+
 	for (i = 0; i < master->num_streams; ++i) {
 		u32 sid = master->streams[i].id;
 		struct arm_smmu_ste *step =
@@ -2632,6 +2636,30 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	return 0;
 }
 
+int arm_smmu_set_pasid(struct arm_smmu_master *master,
+		       struct arm_smmu_domain *smmu_domain, ioasid_t pasid,
+		       const struct arm_smmu_cd *cd)
+{
+	struct arm_smmu_cd *cdptr;
+
+	/* The core code validates pasid */
+
+	if (!master->cd_table.in_ste)
+		return -ENODEV;
+
+	cdptr = arm_smmu_alloc_cd_ptr(master, pasid);
+	if (!cdptr)
+		return -ENOMEM;
+	arm_smmu_write_cd_entry(master, pasid, cdptr, cd);
+	return 0;
+}
+
+void arm_smmu_remove_pasid(struct arm_smmu_master *master,
+			   struct arm_smmu_domain *smmu_domain, ioasid_t pasid)
+{
+	arm_smmu_clear_cd(master, pasid);
+}
+
 static int arm_smmu_attach_dev_ste(struct device *dev,
 				   struct arm_smmu_ste *ste)
 {
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index b10712d3de66a9..6a74d3d884fe8d 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -602,6 +602,7 @@ struct arm_smmu_ctx_desc_cfg {
 	dma_addr_t			cdtab_dma;
 	struct arm_smmu_l1_ctx_desc	*l1_desc;
 	unsigned int			num_l1_ents;
+	u8				in_ste;
 	u8				s1fmt;
 	/* log2 of the maximum number of CDs supported by this table */
 	u8				s1cdmax;
@@ -777,8 +778,6 @@ extern struct mutex arm_smmu_asid_lock;
 void arm_smmu_clear_cd(struct arm_smmu_master *master, ioasid_t ssid);
 struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
 					u32 ssid);
-struct arm_smmu_cd *arm_smmu_alloc_cd_ptr(struct arm_smmu_master *master,
-					  u32 ssid);
 void arm_smmu_make_s1_cd(struct arm_smmu_cd *target,
 			 struct arm_smmu_master *master,
 			 struct arm_smmu_domain *smmu_domain);
@@ -786,6 +785,12 @@ void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
 			     struct arm_smmu_cd *cdptr,
 			     const struct arm_smmu_cd *target);
 
+int arm_smmu_set_pasid(struct arm_smmu_master *master,
+		       struct arm_smmu_domain *smmu_domain, ioasid_t pasid,
+		       const struct arm_smmu_cd *cd);
+void arm_smmu_remove_pasid(struct arm_smmu_master *master,
+			   struct arm_smmu_domain *smmu_domain, ioasid_t pasid);
+
 void arm_smmu_tlb_inv_asid(struct arm_smmu_device *smmu, u16 asid);
 void arm_smmu_tlb_inv_range_asid(unsigned long iova, size_t size, int asid,
 				 size_t granule, bool leaf,
-- 
2.45.2

