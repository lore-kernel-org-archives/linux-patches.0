Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2043.outbound.protection.outlook.com [40.107.94.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64C2D41202;
	Mon,  4 Mar 2024 23:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709595861; cv=fail; b=VwXMCoDO0oDuDp0gsGT8Q43sgMC5HSXDv0lqTz3FXc4KDtqKxNHYvajqmk/jtgkSOiM+s/S1IWt6YkqSIAzx7ylKtnET4Y+fK5XDR6XjKKNjFU2gYS62hnUt3jO40FJZABfC4LDrLOFsI9xr0LRT9VESeVdlEpR+MdOkvB1kxec=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709595861; c=relaxed/simple;
	bh=A4smyIsemcozpKD5hITJpfIouwZpga17mlb5ujeIIeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Co0MphknbQ42tP6WeI2uw+2x8ZwvZszW20m2L/Anbp6vphN6Qem0cVY+f11ZEea8DDAvh0vJlCyJjZg5ovl3qtlK2V7U0HtvMfxtp6EfAvp5gcoE0K2PXqNf/2Oe+Hxe7rWnMC6UoNTgb5gn320mmuePw8TYOESb8tJ5B/4In4Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=bz1eemwn; arc=fail smtp.client-ip=40.107.94.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="bz1eemwn"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bvuh12fT8bo/j6DyQPSB1U9eMwX5liXl2mYuWgYX2J9hRb9rs2utfcgfkwPawr4ZDFQ9PE1Z+zPH2mQYrQkC+57WlMPFmeRFBxHRJpr/SJ4ixLwQIf5kObQFr9+s1Y3PPGaWHqmFm13HS/po2GQJ8K2kntb6+/7N+HPFcX2tG6mvGlfYv9s6/0qQSeeHCNawDS3/ubRGEOKw/4xjPr0jTqYZMNeUZKGXfoH9KFm0SszkJIQUhXqiwkrIj2K9yR/+qJBUOisUJTeVO/NZ0ap4Rfb/3U5LFh9tQWxPyH140vVVP31dOPlxYiO7QSfu45roCP2ymN6I3+rgDsJwvuoqDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kor5j9sJRzLhrgy8s5lQdSkD3iGyRw0Ak4+rI/KxQ5c=;
 b=bzpaCxw9x/2xRcK83JCBsKlvC7CMhV62WHDpkXkzDle77KEVQA/HclNzW49ZRtFJ2kjLN3Ts1jiBc0KKApZfPxDIvoLwpKhCTen4eY8Norebw/MI25DZAwQaBuAst5sMvrmGD4pP+4LIM5zx/3HB1pPgoVH1ay1bZxlJtVg9un06xIththvkxy2XbU1k+3eFhjtf9dHPZHHg+ENXGD48tOqwCx1g23GKSj/TgGmu8etbrz3rTfADITmLjoME5JH9vfF1qzKElUFajS8ep9olzBp/eCxmReiVGtDEZzZ5yAArwvVTQb+3gXHD9rY3JhHuUevWd0O8jp3KKyYkcR9g2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kor5j9sJRzLhrgy8s5lQdSkD3iGyRw0Ak4+rI/KxQ5c=;
 b=bz1eemwns1ap4IPRW93/H1dUZEQ2RhKESgMGPmW2KeWKjSOdGo4KtdAXKVj2nZxEWMBmTpWcnesPuAgqQM8MHN9zA5Jklo8mBJyqqGa4mLgg+iW6LffqbxHJVvzZVYCjBcBtku5dSVSR68sUveIEIkMMo6AOY99+iVQ/dAve99e71S4chPaSovXIfCIbchU61yMYE88jW+mHeMXRUy03LftB/tRhjJltWmYRibRgs79s7KOc6JopBC7bRx2z1EqGCRYJUA1T8ge3VuDWomAGEyq3rgV27HC/WPWCCrpdmAwcn7lmI0LCdCq5bxAEf3OAtOsM80aOLaEbD6LdxCTZXQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by MW6PR12MB8949.namprd12.prod.outlook.com (2603:10b6:303:248::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.38; Mon, 4 Mar
 2024 23:44:16 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c33c:18db:c570:33b3]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c33c:18db:c570:33b3%5]) with mapi id 15.20.7339.035; Mon, 4 Mar 2024
 23:44:16 +0000
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
Subject: [PATCH v5 01/27] iommu/arm-smmu-v3: Do not allow a SVA domain to be set on the wrong PASID
Date: Mon,  4 Mar 2024 19:43:49 -0400
Message-ID: <1-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR12CA0028.namprd12.prod.outlook.com
 (2603:10b6:208:a8::41) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|MW6PR12MB8949:EE_
X-MS-Office365-Filtering-Correlation-Id: 8716751d-576b-483c-1b32-08dc3ca500b9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	WN9RRihtwe26Q7gUNXl1IBF8wL6Kmp3IGZia7p7lgDa0oBdqijU5+bjdv1LVFVqI7IMQpuitA0baHvEGGZctP0ySwHPGMIoXvPLstwOIAVLNa3Z8zcmP2gfNA1Rm04EbTSYwhAD8FQAL0hikqb5DM0B6MB/6Xmc1hMHIYUlcJLNVJBHVHhN7vkc6BpAVB3wngowM0BcPRJB4OBwB6OiY4LkYjF5+SPgzglqeWwNeTo2BBF/Xg2GQgPmLWnc7bGPORZDcx6bF1l3jAwluJARm+/2Sje2RdGluuRvuOMSWDp6VgeT5DXhyLjBQqgNd0FENfshyCBBPsYeOkj1Ix/DbCxfKs7YUQ4GPclxpviImCfpfq7f0jxWAsvqed3PFuF27LFz6wMrF+Sga6onMNKVBZPPvtCJ0DgnXicyAfzEpjeDULYs2NwoHAGE7TPiEEvksDdRrCxMXODvJ+ei3lu6kI58zHIcnjOZZzUou7bH1WaJWSdYbzxfUifYz4n4jQbNtqZrBTRQ1lZSP+ShogakO4B4G/HszqHUcO+XgYSMPMdlb7jE9IbAjkxYhMSMJ6XhHf20ok2Ii0ch25MtSRVAXQ5GYSJ68fI1x34MM+c8xE4VkFh08Mpy3/kV7XpVC3ZPv4CJycAK8HYeV9GILz/K3PxIGMm0IDZXPUT3AQJ0g8fc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WoayI8oqhas/mriZtZtXky8HnlfEB4sphf+6ZQ9t+0BrE+H7m0HqxRGYD68p?=
 =?us-ascii?Q?M4R8S2mtbL0R+9/PDOZPSJCu39K8sEIRgPuXD9G5HDIfedkSoIevar2tOkmC?=
 =?us-ascii?Q?WSn+XOMRACPREfOT3qW3OYju2nWItfjZ4Hw/V8RyKgXJ3WG9GLqKlT+eGPut?=
 =?us-ascii?Q?UW3RkVRJsRyKmb79K617ykgzEG9/L845mX03IsN0lCAH2tpbqVYivxIo3ED9?=
 =?us-ascii?Q?pAl/NQYkkaynYeGgOFhaLJ/82yWjpvzSFUzGoO384wUoiSgO/io6zY8w3jJ3?=
 =?us-ascii?Q?Hay/CUzY3BpidoEVcAVVKnIpZobhwzm9BjBARznSJ/gYksjS7Xe2ERlQoU8s?=
 =?us-ascii?Q?eOXbpMzn0IzryIZWZRM5lj+q7LSzoLVNKBBMYp6c+e1kn1e21QzIxqb6zqPO?=
 =?us-ascii?Q?Erw6IId5l1LWAaWdbLy1PXMKQAG+mcGn20kSd1Y2D/DpmaHht0mpmAii5qSP?=
 =?us-ascii?Q?mmOJyUs1Hkyp8OqNT5rBfeJ23Zw3qWlYB7HVm4V26dunVleqA6eCxfpGkTHO?=
 =?us-ascii?Q?ztO+zUCLszzC+SOBiCpKMuTasRO9MZfI+N+AEsZah738WvLZ28335uQXUXiu?=
 =?us-ascii?Q?PVky1DhRdpe1QSTICxKTHcie24wJBILL/jZCEYj7HN9+WaLNva42aiFhFjVd?=
 =?us-ascii?Q?pGQs4+bIh5Un/9EBOOdB+KjzRX5x0BSpiM9YOwAUuEQ9dPijSDItJpC7jYlK?=
 =?us-ascii?Q?GMIzpAjlD7ThbTdb4A+bGCBwh+yAz/fO/iOZHuRgnB8vpMAXti7cA7Y+OTpf?=
 =?us-ascii?Q?zVqoGkQZUFXkIrKmusSgZrPcTZjRjeVprg9usc3pAAgVLdnIapnG85fFVvwv?=
 =?us-ascii?Q?wH69njHWqz76pjqA4W6yHYI5FsYzuXZ2e5A+ZdVb3fHrTQdJzDtlM9KX6L3s?=
 =?us-ascii?Q?zsunqHaodIsadtmuAVNRKjSNNjNSMNgfV+yUvb0IHwh/Z6c17MGfeIl2tZv0?=
 =?us-ascii?Q?c0+lbdh6NMQwSbuWhoRK0or6+LRVkFftfw3MEDO5fgx1DshkXFJRbzrlgfwr?=
 =?us-ascii?Q?waGIs8H67HFatXiY+NSpMrbXrdBKph+a6arDlVKZFkP8uWYfchFaKOeBBknf?=
 =?us-ascii?Q?K2lFaLnalvlKosPjQbKY6+ACamMIgtiVuY3QuZE/d036gG0YZCahcN8mT6DZ?=
 =?us-ascii?Q?NqwfeB3R6TSwzBS4v8iuX/WINmVCRf2Ckgzaa3fYd9mRREYFMu7S8nkNEKL9?=
 =?us-ascii?Q?12ou6YLVOKpFfyta65vW/jrl6U5/3UQFomVQP8FIe00Xr9oZK8gzv5y3J4eE?=
 =?us-ascii?Q?mR90dz/un6qgjdHwNgGRuOMgnIJCPVksmDFw1IIitJefG/7f/OBP4EIhv/Ly?=
 =?us-ascii?Q?bZCuUKvHN6+bRhfI/Og+QwMeK8reOElxKVJKm8Nw4Ufo8Z/0qXSBs546kIXT?=
 =?us-ascii?Q?pdBe4CoumbjFKDupMS2SXg5bV7h6OABropE6R042uyQJ0B75s33QQ+/zzqZk?=
 =?us-ascii?Q?0he5N55WrjvYODIoX3h5mVjVcIQ1B8Ih3VJX6ekRKUDEMssYf5rEneZHVaiK?=
 =?us-ascii?Q?cCq6iUkxhP3UEsQ/aLRz/qkD4Rs091B8mgqfnOvBkzbXaXWuxeAicHyX42jO?=
 =?us-ascii?Q?vRP42uDCN3PWD0WUTvR+p79Oae3u5vzDwUUb9HgL?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8716751d-576b-483c-1b32-08dc3ca500b9
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2024 23:44:16.0502
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xZSzjqKO5yKWxE8e5jl0PqNt8neQXu6B8/OfdI4YIY46yOymOnv8BVGN90Y3JpS9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8949

The SVA code is wired to assume that the SVA is programmed onto the
mm->pasid. The current core code always does this, so it is fine.

Add a check for clarity.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 2610e82c0ecd0d..347c2fdd865c1a 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -581,6 +581,9 @@ static int arm_smmu_sva_set_dev_pasid(struct iommu_domain *domain,
 	int ret = 0;
 	struct mm_struct *mm = domain->mm;
 
+	if (mm_get_enqcmd_pasid(mm) != id)
+		return -EINVAL;
+
 	mutex_lock(&sva_lock);
 	ret = __arm_smmu_sva_bind(dev, id, mm);
 	mutex_unlock(&sva_lock);
-- 
2.43.2

