Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2063.outbound.protection.outlook.com [40.107.93.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4C5412AAD6;
	Wed,  8 May 2024 18:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715194653; cv=fail; b=VxlcgSLImAC8rmbg/zDmTs1co9Vrb/iIboeReKcHJqn8qMq8hRMKgQL1WkNZ5ztBSiAGXzuCQCDW62I5PYpWK+tgG0b3aoeubqlObJWdpcn4rKajyREWk07yWFgaKN0rEQY76i8W/NZCjXGaDVCmKXPjPCDqKRHwEzgmsWVSV1A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715194653; c=relaxed/simple;
	bh=K5c7vBd5KkUQm46ReKfmofK9qom2GD91tcqN76y37Wo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=eDMJ4Foit7jSSbR64G4SzW1kfKCmUpTCo7JFMRC+VBrIYYTUd0JjOXDTLln92Sqqg4wOR5BpmyJ91TBIyzsOYw9D0zTXYaJ0XTFgSLnFLNn5exQHJ9+hwT+1VR7buJOoP2Rpzp4vpBOqGc01F34CNapZO/xtu4DvCcjTfT1cBUg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ZtrcspbB; arc=fail smtp.client-ip=40.107.93.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ZtrcspbB"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LAFxbN3LknkqSvZsIcLr2xRoFgSws92qEWKvNb7FQ9FhPavzgy17bQcGO6B070NQFSTFDM3AMX8/f1ngWGVon0RCCi4Q1aoG9msaOyPCRq0iBqm4ARAvJeK/g7YQPilk+PtlC51xDuImL2PRMvtlh8mrklwUVN/PfVVA6uT62WANKjw9d3o2DCXGpuUz/2klrNo8s8A/t/A8PTS+uPsAhsoChSEPHyOoawatsEenz1CY5HjZAcytIEmrumF5saKT0mRpMIHVC1jLdnwFE9AK58tWXVJhl9okNhtUQ1dWrR5kxYZBt3HT4/i3wcOlGal7sfDVGe46Tfz3UK1JLK4/Qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u25uE5oWSzghTR4y+8jL3OuatCgTBPJ50yUGkygAQMM=;
 b=CWceAabMip/sPcjR9eoyfJgrC2Hn90gb2wK7ZzhYg6NSXVFayr2W4xSmd6qC1Zd1pjL1aAdhbyifHjsRbcyY5tQmuHOwQZw9hdzKq4mG9yU62vHPyqR3ODTMWAuzskMSJ9qkWsvNnupKmk9ARW3h9KNLVBgPQNczNPdvVabhO6YXxyBdkaOaclUAsYKsl64cLqB9Vzl052g/7PxFj3NBu8bgXHzRggnZtUHadvv7R3ut7f4OaX0TKCU/25+jhlMhdZJ2AjgwzAvx5HkHoJQrZ4zDMs4PUypC3NNOZGavTWbt5Y9QZQ8h3Fg+tba2UrBkQAbGX8MM11lT3KXc1gXP8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u25uE5oWSzghTR4y+8jL3OuatCgTBPJ50yUGkygAQMM=;
 b=ZtrcspbBmPs7yujv8qcKgKPvisHjWu/hyJ+C1sQAsjK82hYDRORsr9nKcZoonNf3KV4rybtcBhsC06LDUpzvWOlEC6HzD4nQf6VdHYlBoIZLbLLPAsT7BJ+pqzI3TsyWpnArolDhGZNlTeqpU3Y3g9Jb5HpE2J5JYutY1Hyeez+RCuqYqeJoSG0u1epISlaQhiweq5VaRC/McMHK2nuhy2QikAVBHggkKeJULNs0kKMDd2JIu0lGKQHZKpxKa2i5KtF0tmhjo2qRFuoD7VrORmh/AjK12zfs5N/7K8Mnw0cofFe8Xi6KP0BTrQnsr1tpv10jF13EV5fC7TvKfW2eaA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by CY8PR12MB7514.namprd12.prod.outlook.com (2603:10b6:930:92::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.46; Wed, 8 May
 2024 18:57:25 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%3]) with mapi id 15.20.7544.045; Wed, 8 May 2024
 18:57:25 +0000
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
Subject: [PATCH v7 02/14] iommu/arm-smmu-v3: Start building a generic PASID layer
Date: Wed,  8 May 2024 15:57:10 -0300
Message-ID: <2-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
In-Reply-To: <0-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P222CA0018.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::23) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|CY8PR12MB7514:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ee1773a-74d8-40c6-9de1-08dc6f90b2af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|7416005|1800799015|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?twcAolKT3uYOzi/O1nY0i3i6+YFxjpwKWT+49xhAYXOLAGsRlys2+Qh1FlWr?=
 =?us-ascii?Q?rh4WB/EyEl8Ne5SfZBX6h6znFtdvBzg6iIdhmZsY/kXyh+p6VFspFm5+ch4f?=
 =?us-ascii?Q?Ay7Dydph+KudLsXxMERFmps1hJAss9WThIlFVpUidFP9yIYo06vwHo/vHet4?=
 =?us-ascii?Q?u3WEDlWlPSkc6pnqggHAR8MpGFO74a/D9L0+Nli14+ekmhqSeLRAd42mj9be?=
 =?us-ascii?Q?FAX1wOqd+fUweKfgJngKfdDivwY+Xve362pVAVGxdKPMis9s2wD1tsLue5Av?=
 =?us-ascii?Q?J2fXnXdaqcVG6LiFJEBGtQjSnKEcOIP4MapPBtnBoA614P52UQsbGeeQErLG?=
 =?us-ascii?Q?xqgoWzKqqVFVBegVz4yQ8Hi6HIjaR4Ekbebzc7fXkL1fc38PhfTTlYxqW5Fn?=
 =?us-ascii?Q?YfwNWqPNgIPd01M/Y1iH8j2JVE30SZCqp9MI2A9YU7JkAh6cUSHsoK44U/iG?=
 =?us-ascii?Q?0giNWcldJZLoWUY0gdKRdxLoMVBz25cb3Fq+kE/ybpcqRC+uhdT6HoWzR30i?=
 =?us-ascii?Q?eKMgYwKBPucT/SUxZqswTcNz71ZgZA1/mzUAAfHn44n3OLJ7WeS6WeJOSrKy?=
 =?us-ascii?Q?6HF15zHyNDmRdIwdZle3mKO89kyk9E/XyCo96hQd/ZSABMM75fL81qK2s9Em?=
 =?us-ascii?Q?pPUXA6kBFbqPKJbf69YlWh2VG4NNh4Fg7JPqyzdGNtDbyfiH/zA7jLW6604R?=
 =?us-ascii?Q?vaIbKavaVVAvHyIEwLQOXw0jqP6oo7Ite3j5QIZ/5XVt/O6SWL+cwn4r0XQB?=
 =?us-ascii?Q?FpKtwhGTuvosqa9XoD7PIJJ35NJ6ARPfxCe/2pq27E52WsD0BtBUv/ATAmuj?=
 =?us-ascii?Q?qx372n32Tqjw1CgqyFyej8TA/TD99/li2N2REZWLk8xCbMjRB4JYRwFG8llq?=
 =?us-ascii?Q?gIgNzQ5p9g8PJRu8bpga/kTqsgf2jL1J7FNuoC5usZUoMa22QDWMh3sXjt5G?=
 =?us-ascii?Q?YWeQd4Ny1gsnmkRVgNstgOYz9+CgmtZXpp4pzHybakS9+t06zk66l1H2ZUdt?=
 =?us-ascii?Q?ba0WWSxr/5PcVCjHIum3LfQHXrTrsMSJEPPVKhbfig8UdYUrjWTV0Czs47YD?=
 =?us-ascii?Q?881QHXTeWSLsU6fdLiyWYgR5suhKfPkw4feMw/LMHp8aY7LQ/xlzEa06LAkb?=
 =?us-ascii?Q?+9/8Tggf6tZziqSc21LBSAWvaIS30SXxxG1fkZ0gqLcfDMCucIcq9uRkLAeA?=
 =?us-ascii?Q?EivTKclmji/TPixy8WWIrRFA773Y4PZGp3oTxTAw0aV5Cg4fPCpq/LXZfiXs?=
 =?us-ascii?Q?XCqCiHXvVG3/WLgYKr+DpwojWwBDc61BaM2heN/i4Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hiInYl4YdxxKNvbTDbVFntwlX1qIfFGFv0YbjfVvDjeLwHRvJW/gyrtbhWwn?=
 =?us-ascii?Q?iv5sOQUj9iNvNFviu7jgdWSn85tARKvn63Y1STCEAM2rG5PQUD60jhGH5qND?=
 =?us-ascii?Q?GPFSyrhdPiR2dpSf9U7Y6b0/E6cqybV3VoulWXh4opRLuqUu5TBtTIWcFj6f?=
 =?us-ascii?Q?BzNyxwxyQh8h/RH1Gf8h30+iCZpls+C4AYRmXtU5Hp5smMiLPOQmqKjpZvjB?=
 =?us-ascii?Q?ixU7IyX8SdwGRc1ewZksgvDl8NcHjHFAXEpujZNFuW39V0LsoXeybfM2SRBU?=
 =?us-ascii?Q?74vT7EUaPC9jAunHWECIvRz4olprZWCkyqYSBCDcSsEKnLYxL8IwG+r3h9/D?=
 =?us-ascii?Q?PasrU6IYp73srBti4LhFg0Xbwco/34X6jQjZV3JYRixzya3Dyw5XwNn/CO5J?=
 =?us-ascii?Q?AlIkJ1z+lnrZkseVDAfwF40x4zH8enDn221WRpPd5obnUjf6JOTp94LcOcQ2?=
 =?us-ascii?Q?2D/QYPWKPz0ORQBiN7+JzL77iZ82ptOrbZfp6mZ3Pvc/kV8bi6cPV6k++Kk9?=
 =?us-ascii?Q?S7a49IpR7Q0MFBT5frDd2Dwmaxnn8pOUheAF7/6AYVUzXwhnogX27oUx61Bk?=
 =?us-ascii?Q?pAsLRewdsDpMHss8XKbMf5iOvhb2YnMXis/bU47ichmHs8AQZX8FBHRKFJDu?=
 =?us-ascii?Q?N62omDRAAbhWOciwJG04ugk1C339ATYAwklwZvrl6icogBvKACtXeL2hzEz5?=
 =?us-ascii?Q?7fxoiWhmm+d/eQF8kN/ZJJbsGIpLUUkkkTpDWFrLeEffGFXPwR7BRah94J4a?=
 =?us-ascii?Q?IobBWg2SnhvOO93BZYq9mNUjk6lOUtC7O0ENqCVdUDshOajdHTNY0lSpAJkD?=
 =?us-ascii?Q?rHwq5+KxbH4fcRa4gcuNHjP3ZFH1KCbieqK43xwwCh6GxAdZS2ED/pLAGanF?=
 =?us-ascii?Q?1U/EntMLOLM3u+Opyqeldz6YLOteSEOFh/tYmJliq3EOkhbhPVtHFbm191II?=
 =?us-ascii?Q?tNReUApoLzdV8Y3GTt4t40LbOF0YP4KtMkyY+n8flYM8f1EhP7ejVDVJZoYY?=
 =?us-ascii?Q?42LP4ISHKS4XD6fBchPoxY1OxTWghwBh9QLI3JwXW4WYzRFX7cy4wAjmH6Dd?=
 =?us-ascii?Q?9qtQNs0Ujbr6a8jTOXHSJkZ2kwbwTcyEal+iO+2iYI1VSfQmPiJV/o8aEKDC?=
 =?us-ascii?Q?5P18Aw4j1bQZOgZ3gTrVFEU4lD8PyUkZ5ADZPfLZfNwyDYcORfcfL6Qy5Z2F?=
 =?us-ascii?Q?Hc94PL98a+a2x6gubUo6NYtCDOjJOPJ/6SVqVopAteV4WxiYtelFhw595mnS?=
 =?us-ascii?Q?l9epHgOABvJVWFiulXqPZlCPAvrZ7AOH7BtW8bkFVJR3F3139FuarGUC74nY?=
 =?us-ascii?Q?LGPA15MFLYG73h3k1lcpp3MKuAVYPH6ZrYGo8cTDUWIC18FYKkQf4K9+knM0?=
 =?us-ascii?Q?XoGUdZK8Zdq5+EjKxvPtlAOvg6NmUcGD2dz2VW54fHsXVQCiTZYl+GjvoviE?=
 =?us-ascii?Q?3DiODj299YPtzJpkzPNjhw+UhhQmULvwje/zwFkRu4GE+apW7f21jcanofLk?=
 =?us-ascii?Q?a4+4Ua4Z6ZUwtQlFirnOKUQYjXXlkpbcPucqenBrITT7ByeX2QhDDEJ7RNuL?=
 =?us-ascii?Q?189sf2gRKuKHthn5wNquahLeqt8HvLUd2MLs7Rym?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ee1773a-74d8-40c6-9de1-08dc6f90b2af
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2024 18:57:24.5061
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iJdUpOmN6cxoR4CXobuzPIqjI3dI9Fysmwt+YzwCBJs7Q/xyj4LWUZByZOB8t/HI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7514

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
index 4c6c843669aaf9..a1b400e3e41878 100644
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
2.43.2

