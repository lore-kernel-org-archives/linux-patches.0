Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2082.outbound.protection.outlook.com [40.107.93.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ACC017FD;
	Tue,  4 Jun 2024 00:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717460175; cv=fail; b=K+bZdiILI2a3/LzenZB49687xaczTxdeuQAcw4iCFRmxDMAPpQiINb7E27amCrXhu8QQ8ieaLnqK5peDNwvPOSzSBSx7beSYDuBpNCN2ZbR6B9kQwSRRp7y9zRV1nQdhnE0kFhx9/nX+4JSGtUYEeQwbiCkkwHvvFCNZejmotkU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717460175; c=relaxed/simple;
	bh=PywmCJ8Kdm4u9PbEn1q79Pvh42YmyFhTf2fmUmXf0Lw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=iAY14Kv59qhRjtvjpJ/SEQVksgOvi3uYzhs9GfiZU+bRn3hEnkYnnuQ3GXHxhjNZxCy5qs9VrYshY5Dhfjxmig2nsCdrHnio6BFlnfReZ9JDNYD9Z1y6M0O+mljM+w9fi3UfN0cYr6pTIb1hYHhf6aRDxeWDNtfCSzFKoa94DX8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=o6+GTe//; arc=fail smtp.client-ip=40.107.93.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="o6+GTe//"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H5sRd2bVuTZurROvypfNppi7CdEIafRWJv8vM/NlPVD+bju7EHEx9hlY8NrOSJY+6IVgUbbt9dqWk3B5/OvW3uRfL1IhHCsHicQlml4cne9AQ54dSUozMrNPAVP9zodAHB+R7YL1/EqnvTefiktciR15a3ORWuStaeF8eosmbqk4ygZZPvAF9HgIM32Gfond9B9pz5KpkplWSW4wD9tC4JxaFIPjXPHS3j6bGCLY3oVbuS7nOovxE+mdZp5uPhL0P5i30xGwejCMCjOFX4Mq7vCO8mQVAQt7kqprU25NJQMojxROzFPEwp7zuK8ULXsvtA2pnfevx/q9wCBSPnMz/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fTThI9TNufJe256yfBubbCVPrVing+bW0N5N7FCb8JQ=;
 b=gue/pddkk1RHJwv7lQYmX00YiEN8jJAFkG1eThKeGpUDk2UJuZXnor1t3fYJdznLa06XvD8WftLbV1iYZvzjZw4EYRkzC7z+upXJbC8FbX2c9gk9KPlxJzEzr17yDiVrT++h1df2bOVDvau7Ox7w1b5Wnrfo8lYKmtTJCvzF1YyGSzhMsydO43/STzGFwiJ9zrK4WGXJmxwIMT7qa7IpXyT/APGIs3H5TAKSYcVtDF3ElgxaQq35YooT27fZaKUMkrbxzAitY736Y79HQAQi+oImlc5Bv0lXO4nZkWHuh1y71C3uuwjPsiZftKjBPL8wCbxHJQ6SII/Cy6ZEn5k+CQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fTThI9TNufJe256yfBubbCVPrVing+bW0N5N7FCb8JQ=;
 b=o6+GTe//11XT5XVjU0+MaNzKuBgkizQcffRS3dI3J2P6PVl3ScW3pVVOsEmBJiR6+6QTxl46r1FDlEVxDEtZgUIRfhrM4blRmbxlrVC1B/XNFz+OIDysoFC8x8GwWP44O6ApE8EgU0AqQsdiMu451kYocRWzMTa0zx7O+HUYtPsEwWIQGrG8sGUQiQdyC/AGW2ygi0bT7Z89lUHLJsMahmgh2A/rpkf2X05bRSlJoVgDqNMPj/qjMJO9gYIKlVhdLM1ZFx2lNkASEb/V4WvmBXK2FnxegiE/oBbJdz/ayQcYgZf8H/PJMSyRbLAG8ZbGUFSubKX9Qd2tC9HuHGIbbQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by MN0PR12MB6296.namprd12.prod.outlook.com (2603:10b6:208:3d3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.21; Tue, 4 Jun
 2024 00:16:04 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7633.021; Tue, 4 Jun 2024
 00:16:04 +0000
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
Subject: [PATCH v8 02/14] iommu/arm-smmu-v3: Start building a generic PASID layer
Date: Mon,  3 Jun 2024 21:15:47 -0300
Message-ID: <2-v8-6f85cdc10ce7+563e-smmuv3_newapi_p2b_jgg@nvidia.com>
In-Reply-To: <0-v8-6f85cdc10ce7+563e-smmuv3_newapi_p2b_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0113.namprd03.prod.outlook.com
 (2603:10b6:208:32a::28) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|MN0PR12MB6296:EE_
X-MS-Office365-Filtering-Correlation-Id: 65b76e14-69e1-4ee4-938c-08dc842b84bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|7416005|1800799015|366007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VSWtBZxvhVzqYyQAIWgQ84BScm5cW3zp/FNSnH6zMpJC02sg6w1RgV49qadx?=
 =?us-ascii?Q?c/B9teHG7Ec3UsLYDyUCBLtknU6oE7vR1W1AVCDFLSBh0d54HReCrgHeCI+z?=
 =?us-ascii?Q?4UUVL+rS5H+wjoAkKhVt/LPXc0TiTtBlOxuCOtQk9Bmt4HenwxmSJB0JpRsG?=
 =?us-ascii?Q?K/2i4AJ/WvuZbYZc0ulfquzl7ZrtBfUpXHk9tg3rAQoEds3sAJ9pmnNqFWv6?=
 =?us-ascii?Q?m8eVg3n4JCCKLWnGj11w/YSp3TNk9pei/iIGj2p1dx6SebNC2ffbjhWF+0rs?=
 =?us-ascii?Q?2vruQmUWh+EjD+nN8y6CbrJ+gl3YDy330ujQcs4CvJeNNfTvYZ5BtLfwEurx?=
 =?us-ascii?Q?byL6XRet/bqSEcXgs/drKFMiSm2SfaL+jrmGGstroLgq8ZPNqpI0bomieFgn?=
 =?us-ascii?Q?jmdCj1DeLaEKuS3U0pX3PMuKSOQcl9tYD+ClzqN3uePGJj6PD59IVT6HJWBG?=
 =?us-ascii?Q?/Uzx8exUqYvzvvqpKfnTF3So8jCzdu5vity6VAmuzbsBXC+pbGiEGe9/585O?=
 =?us-ascii?Q?x6paWGg8EWbYsaLvvC2+dyAq5V5FHakv1G99PGlr/DBbLsaT60ErxlQR4oMK?=
 =?us-ascii?Q?KQVSG8OYvOjXSM+OamuN7L/0OVWvzxuL5Its4dr/WeF/jAkUFAxbVMEX6ESj?=
 =?us-ascii?Q?dLC1S0Utx1j9INQNxgFp6HWK8kkdwwxYDvo2eBn7YxYUAtHZJnRbR3XlOna6?=
 =?us-ascii?Q?zyG/MnTYylQKHFs2NjuS2g0/1oJ8DYtFRFDZFa/QsVllLnPzuwm9BBZNsqWm?=
 =?us-ascii?Q?yXkrlL9JFShpF2DJGzagIKRPrCETaLp0qEMz2JEpBv+T7GSpR2fDGJEL8ebg?=
 =?us-ascii?Q?qbR3R7qJnRf/t5ERFnQAbzD7PSKbwJ+YiI7QIldMxL905rVnZib/HFiBx2FG?=
 =?us-ascii?Q?52ENV/Ey8DkPC1BFoOBQHyAZMhmazz9JkILzBepA2K+uJu3cjVJnAGhD8Um2?=
 =?us-ascii?Q?NUISpmIoLxU33VaJ/Cf/WXSw0t+LAn17MF6fndpl92OEG9v0FyYHhd0deOT1?=
 =?us-ascii?Q?8w1lDthdt1Xb/AgEMLSChi5QPomUYY8Ud/AxBOQQwGju4dRxa7l9QfSihTTd?=
 =?us-ascii?Q?BGtrQDvsFlJYjHDICQ0y9NsMDtdM64U9SSJXeO/ahzT9BoYr7WukVgIWqe4J?=
 =?us-ascii?Q?XRhmYAzlw97hfYBzo/iQeqGxyT/ygkRWHYv01qGbK2QM+GOTw7PaYd2hqcaY?=
 =?us-ascii?Q?8sdv/kan2jQCx4m8zuzsG8Fb24EzkdcRMz5xP62GI2M1YYVx91PdyXzHMpEF?=
 =?us-ascii?Q?zsNdz/NDdDzTxivTC1OXoPczhp4uvdh9n4iaHGQXUQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(7416005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JJNqgx/Q+/aAsqHN0UcHESdVM+oF3sYB7fhUodcBOJWNJWBnfgeSTj+8D9zr?=
 =?us-ascii?Q?KQPEyi+YYvcjDA38PvitzcOD1SkRJ5swSH5ys7uQOTRUmkZSPvvbZk7nv5LZ?=
 =?us-ascii?Q?H/PAniIIoA2TgdtDa+ZOMLzIYz99CTxUpsnSEjIuRvHRquKJrHYZICpufcTX?=
 =?us-ascii?Q?6KqpRJ57O5AJqYlQqUx/INO359GaXJsAKsTqNsrkXz75p2QOnFYyI3QLejxR?=
 =?us-ascii?Q?mU1u7bbLM/pAH0bXQ9ZDLAxvc7xuPKlFu0GGzNx7UOeIsdO9MaqByW0LIeD4?=
 =?us-ascii?Q?XymEftksuLuNZnKG638je0/BVpdbfmowUnIz/mPDrKs5nUjTEORUM4GrVzFb?=
 =?us-ascii?Q?T2k273LmHJTsA+l+9+cKUIMQKfK/+P6Km4jtRVO+gippd6BB6xYJXXvWekHj?=
 =?us-ascii?Q?NwpF44QIcbUwcVfHA2yxpQhYIKXUMkHSgLz4e8qnq2ZftU28wUzGSo/wPMg1?=
 =?us-ascii?Q?P1GTyHZWjvx81yxgAXMfUzaYpWuMmInTgHrORKYtz989nLl1c6JDE0gMV2/E?=
 =?us-ascii?Q?+LrtdzIPNoOMbDHrh76ouM7Ov5Ml5uSzGrI6UTk7bZ/cIY9awga8DrobJKHw?=
 =?us-ascii?Q?CIdVO48bcv9LGSrchdAZW/KtLtBGmg6BBpvoX9sPGiHHhVjLzORTKpwd9cie?=
 =?us-ascii?Q?2Kbd/dcnM9Prc4R0FW+0z93glhcpQjVlPThbSBK0/vdbQSugaZJaWX3ZROqE?=
 =?us-ascii?Q?McFyL0hnePi3/1akxLhysjMM/q5uo25JDli/KVBe4RlWycoUeWsjGCibUj0x?=
 =?us-ascii?Q?OxJmVLJpRVkjOY3K+T/J6tRO8qvKVfmit3ADA70Td8oKNuezZ8D/Zair7ka3?=
 =?us-ascii?Q?QQykFcrj9VGJQrpMgmhUrhg/gnU2xCyqNqRvPTRT69Vmjn1pPRLC5b17/0re?=
 =?us-ascii?Q?6mLp5HppwLnXK1oeXqNErh2Ozn/wnFEwKGMyMPkL62xcZlKc3nDsEUViTDua?=
 =?us-ascii?Q?WQWhksb9sETwvNIrqSWTE/9GqkN0fAr1HFbK6L/5JwJOIYrBalVAz75fojlt?=
 =?us-ascii?Q?+dPQUikhDurHvL3h3ENV7WJYtmBJrGy/oSS8VQnU+5LjYG3m+2jiJyfU3Kfn?=
 =?us-ascii?Q?nZNG2MJJR6m2pZcnLFUZE+WJhUi8ajigCvO1ZewaTXxrBMIQVgkJf1oOa665?=
 =?us-ascii?Q?RWvkMJqOHgMh0FEmlmocWit678+884fuy4y5ZGRdtKFSbrtL8PlM5l2xfLgF?=
 =?us-ascii?Q?I4knQkweGj+8iLvqB6328kWwDImkxmCE7E0JjnlOFcNiszh699y1C58aFESE?=
 =?us-ascii?Q?zZDospansg6Z5ypmX0urM9hEPf9tALcs8jntXh/YzE/QXsaqXzbgHx1fFRPD?=
 =?us-ascii?Q?M5ldmgpBI5EodiQK3wVe4AkRrJH6/Nz6SWbJQG1Oc6M4atrAdc2w+JfsjcV9?=
 =?us-ascii?Q?n2fyYqwzNozFa9txH9dwffELQr9NlSPhBcf6wo4UIEqeKXhhvgk1NaFkfFwL?=
 =?us-ascii?Q?w93ONkNhrJw7PtUnub6smKghJjesLv2VLwCFXkbz+zqx11paCLmNB4WhyLTg?=
 =?us-ascii?Q?V72Z4vWokhYUMSOoguZvTDGIy5w++V66hfk8/7pckOEJNGLe0mxzT4wkY7wI?=
 =?us-ascii?Q?0VXuUxK6pWWQfGvT3gI=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65b76e14-69e1-4ee4-938c-08dc842b84bc
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2024 00:16:02.7021
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XehwwgykQixNJmGFgWWeaWvESYhWQ+IDBDe3nUVf2FDxl4H6TdmlJ7KJsevjfiQL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6296

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

