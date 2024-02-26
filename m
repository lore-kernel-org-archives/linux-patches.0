Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2059.outbound.protection.outlook.com [40.107.96.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8040812F5B6;
	Mon, 26 Feb 2024 17:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708967265; cv=fail; b=uFc4I907n9ZhPQDt4H0KpT3586Kg/zrGXk+iO9E6Y/N6IZ/JgViAc8hqeYGlNASOy42kJQeGAEmfFKcJzjyiwqXgubkeCTBSw6L1vVFF3jei2jc8vTRSMOKWCjjdZkjQ1zJ9NP4PvteJP25WrQc6O+AbnsN/D9qe7Q5SSehsFkk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708967265; c=relaxed/simple;
	bh=eHhy3v8IhbQCA6x78tNI4Ll0u8pmhjs+IonJjnb4J8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=d1FrmNuhpH03RdyF5RTTaRFNlLXUL5Y0hTTNaIAOdlBcH6bNh3tLCOiokXZXjbTxPzfcXDPIMtkZKzYStG1tLvOTQK3URgYQdbcInkvEgyUIdcGt8boUQak5G1Wabdp0u7Lg4SVA/du06GTESVoS0woRx/XkvLD+oRndXYqbKpc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=JV1mXfF/; arc=fail smtp.client-ip=40.107.96.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="JV1mXfF/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NYKUHTL3p3NCwac3JFBwS0ofHqIAZgNYaWHJkTtctyjmjT9JJjwraD20UK+nV/B1kXSpG585PBIdF20QwyIVAMKUq62ftruJSYXLMXNWvhBNwuKnJUORf42Oa3vulAasbsz7p+jIJ/9fa3h9VEqNH8WuYP97j0E9641yZh8Px3UtEtWYGJCQBSZL180Y/PQ12Z0kZs5UFDwl3GyNx5EiFWJ3bbAmOT12DJho4RYGG3jcYVPEviGLzOGaN08LvrAVaIbuQ+4rs51l1Bu9U6NHFKEgAK2tyF+45fcSbFtjbfJdWdJ1UEq/piSaDTswXoHj7csI1WUHVJG0DLW294APyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kNhxe6eMYEbii6HPeFDwaMDwArH9oJKo9Sih9qVvjY0=;
 b=ObP6BxfeS36viyZW12A1E6JjJwna8q4zSjvIPNy4YfA1+JY80XPqgMkXqsscj+iHTUjgpB1MhkIUlX9oPf65to3wFsv7YZHKaS/mGqZTLrpPku6sszk81FlJRdXK0vOgsQANg22eMhDhSMoepTFJ2XGw/t3WvTMUDjxU45ZubWSvL2aN1DRPaeetruJ5y97EsLq3Wo48W/KfxnuqXZ8XHmnZ9eOr6OPkzAMP3x1/hByPTQW+mOo8QhoZIV2GSq7ku50EvorFskU3/UXwxDE/DHUewccVpNDCHalZ50Rs6lsc/DChwCoXRuAsyAujq0NYbqhzB1MDu1So/UVQX0gdnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kNhxe6eMYEbii6HPeFDwaMDwArH9oJKo9Sih9qVvjY0=;
 b=JV1mXfF/zmuMyGVenepl6w1ZEsm5kb3ciYIimFvO2QuR3qDE0Z+eNfsg3oOBNMA2xoollld3OvbjJkCwXL5c6+4MdjedMA1tyeMi2e0FtKi/6Ruxg1q0Caq5XD+pC1G5KI0s/vA783Teo0FcV4PT5lW9sQ+jW3azg4XiI56tdZDNXyuwUTfH170fGoS1FkZ30ofjgM8X/ZJyDDsfQfP/Ox4CMz/Rrhx6tXc2wLNj+x8MjLlXKyg3rypPg0aRQKHEYRS5rCUsU01XfQCkIqBRys8jLXNIxXITNRpoq540QwhW+0u+NfXS/qTdV1kxLAgxdR+qL/MfwH0Sy1uTgBA5AA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by PH7PR12MB6905.namprd12.prod.outlook.com (2603:10b6:510:1b7::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.33; Mon, 26 Feb
 2024 17:07:34 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::2e3e:c7c0:84da:3941]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::2e3e:c7c0:84da:3941%6]) with mapi id 15.20.7316.034; Mon, 26 Feb 2024
 17:07:34 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <jroedel@suse.de>,
	Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH v6 09/16] iommu/arm-smmu-v3: Pass smmu_domain to arm_enable/disable_ats()
Date: Mon, 26 Feb 2024 13:07:20 -0400
Message-ID: <9-v6-96275f25c39d+2d4-smmuv3_newapi_p1_jgg@nvidia.com>
In-Reply-To: <0-v6-96275f25c39d+2d4-smmuv3_newapi_p1_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR1501CA0017.namprd15.prod.outlook.com
 (2603:10b6:207:17::30) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|PH7PR12MB6905:EE_
X-MS-Office365-Filtering-Correlation-Id: 93b76a7c-207b-43f3-ba86-08dc36ed6a6e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ax8ckTOoNOkpACU/BKr6FKu2mqzm6P+y7zsg557XQU9U5Lj8VCYFsd+zl2ib7h8+UGBrbE96dPdMrj3VcEJRUVx+ynV1a2S0uQCe/hmb0cu+L0U8CKnGaPO9FxnaZ9RN9rkpvgG9u6w4B4fb51HX7p0ahwQcYqL2ki7QaQ6Z+GZIjb8rnkuDieEBC4GxsOenMs8do5FYv+Z2W+KF2sVQf4XXDxdks78MMpRx6IpRfp2u0m0ZV4W0l3nKzcp9HUGDJWBFB9z8ybhkTc3jTr+BbMwiavpao78UVUhr5DWefm9u/M0vuJPjzDG2g26MRKkRtJxcdABqObZg3A5GEgCj5nrsus8k/e0oJhycLT2xgcA1FylH0Ya/MFunPebARV6uxjkfKAJfRvuVJXTaYsvhjSBVZkN+xwTK8Vzzo7gJOU9jVgI/ybNDmxlsczG9kVWNWzhRmZpZown01nZybIeVhikt2HNch9nRosMildGsv9OXjHUsI0hLRShXtPm7/2QqEAWkEAcGKeXloLU2bGOYH03tBSxR8fy1JrnGSmw0EKNed3hZGow2zEJT2z/TrqgmPZsleEE0oswuA1cRJKXigiwEziX3xoxCTDpOOtl1YzOuvhyO3GIOhf7Mkd6jddd3lQeXDYGTJrVc6SUHyo5ptw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DrEvga3yB0Yuch7uEF1ZLdFPn8nK9gp7lReOGeFNzqlsUkXAOjz6nKls3rsU?=
 =?us-ascii?Q?ePJl7gerIcDi9N8bYNqiNhg5ctDhuhlAcagGAndQFtP+C444UfGtZ61CUfdz?=
 =?us-ascii?Q?d48kMGSXGa3tyx7YdBNULNkqsjHW6CvmySfRZoPtuT4gOWLAb75bwUlmNQMm?=
 =?us-ascii?Q?nQb/lXaT02B3tbR/+ddcOAIJOYQqsmLHTQV5/q27WnHCD7mAPupfuXYLYO+T?=
 =?us-ascii?Q?VOuyy5u9spwwHiWHiOhMuXdcvK3KSYt4ThLA4XYuEZAPV4MqFtM+RdOs0raw?=
 =?us-ascii?Q?1iYw9i8CvGzWbaObnQJ92ZxQwV1nh00fUUo9oyBwnIG+wGzC11oHNhk77GRP?=
 =?us-ascii?Q?1wFkM/bB82rTOzESxVSTjoj+hJgojoVtjq3/mXkfIw76jfOetkr7AsKsMf6g?=
 =?us-ascii?Q?VrfaqwVnSHq6ewGx+6MyNlcAavYsyAzJSPMPGkEcy/a+KrT17g3bin+1oX3o?=
 =?us-ascii?Q?WZ8zM/4TjXLJx2Nahxg4/4ADDVRNuPRsGZ79wVK/Q7qYbSM8AUdFIHjRmKwz?=
 =?us-ascii?Q?V+PeY8nmEB6422Yit8Qy9+jGvVnFzEYZg387iGukGfrei08ihyn+eR0zKaN3?=
 =?us-ascii?Q?515hd13jyMyfrDGZ42fOIlCCfNkJDQ9ijjWiRF3w522qgyPEH+r9NbL0A8GK?=
 =?us-ascii?Q?iKIG1NpWXWI3z+5nlaRrr4zVVkk5bOhUZw+QVChO4ZqIF3uXxhSHPjBuN1v7?=
 =?us-ascii?Q?+YO94I1cP7anyeRS+IwiX+Jn8Rg3V/K8zaHlYXNJYtPC8fiA9J5n7mFQEZmF?=
 =?us-ascii?Q?29smnVU/LStwfjYsWm5S2/WLbFEpKRWeVnXhiKwPQir6iMlf3/w2ZZoM8sn/?=
 =?us-ascii?Q?JpxwtVH2SFta8CVa9wO3ywwWeaLtPao0M3f5gdkvzoHD1QUldwEKRq4Q09vE?=
 =?us-ascii?Q?y4LaG/lt6eGuHMydfwvqMzsesbj9eI/wIGH0YxYsv60egj5KBL6GF1CrKkJe?=
 =?us-ascii?Q?dfLEaoKVFEU3yVklbJJdgfeSGa1L6CsezmjmjxpefFmtFIuQMscXHGy3D+fR?=
 =?us-ascii?Q?crAPh+pJFtGm7fAEVKgN6FIGrhyqz5YMOM9hTbgFCN9pF/8VI3nmZbFUzjVh?=
 =?us-ascii?Q?oZubvopBCXnH9T1XeySxtgdTeQWZ7jVlLPzXWeSuiY1xVwD8D6W4NYNaF3EH?=
 =?us-ascii?Q?mun6Tw7bxAryezh0mJ6u4Uua+CVVh5/4GDjCYjyz/7Gk8C7Q+g3D1EJfHrAq?=
 =?us-ascii?Q?VWWcL8V9SB9cw7Cy+Np1cf4kLtdmSNfAvv6gMJ/FcwruTOJQqxFld/Kf+gDs?=
 =?us-ascii?Q?GUx76xyK/HCQjp4WccdsZvfnVGy+w6et/D5F0dwIzj6EoLSi1yt4+jg1lYDN?=
 =?us-ascii?Q?rJhoqQi2+4MLVVHZLgAuWWqVYWI3y3Z9jylVCHJ9CiWuR6ERGrADEeOFCW7n?=
 =?us-ascii?Q?ZfYYFTh6ezonDRc4geS7szXv7IWP7IoBJrT+6G1jAdLVrQ8h8U+yPu/AFSdx?=
 =?us-ascii?Q?ZVdW3EjOoV3LyL3fj7tnIlJYa5cf6JWBDOLzNfSYYpdFHv3G6FVdUKUe9ebQ?=
 =?us-ascii?Q?cIgaF2W+0Yg62ydbzWf0Vi65WyWhSjPan5Lg7nqCsp2xwOrvcm0HUfAmBaaa?=
 =?us-ascii?Q?9HvCnazAbHxgR2KHTb4l9A2u8WKGn13UQMgTAAFG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93b76a7c-207b-43f3-ba86-08dc36ed6a6e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2024 17:07:30.2126
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q9xk8e3TXOIhdrlaPjmkhYTkfSKMeHhcfCxnpQVq56CKyTuIJF/bk4xtmzXsv+hM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6905

The caller already has the domain, just pass it in. A following patch will
remove master->domain.

Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Moritz Fischer <moritzf@google.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index ec05743ee20847..9d36ddecf2ad64 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2421,12 +2421,12 @@ static bool arm_smmu_ats_supported(struct arm_smmu_master *master)
 	return dev_is_pci(dev) && pci_ats_supported(to_pci_dev(dev));
 }
 
-static void arm_smmu_enable_ats(struct arm_smmu_master *master)
+static void arm_smmu_enable_ats(struct arm_smmu_master *master,
+				struct arm_smmu_domain *smmu_domain)
 {
 	size_t stu;
 	struct pci_dev *pdev;
 	struct arm_smmu_device *smmu = master->smmu;
-	struct arm_smmu_domain *smmu_domain = master->domain;
 
 	/* Don't enable ATS at the endpoint if it's not enabled in the STE */
 	if (!master->ats_enabled)
@@ -2442,10 +2442,9 @@ static void arm_smmu_enable_ats(struct arm_smmu_master *master)
 		dev_err(master->dev, "Failed to enable ATS (STU %zu)\n", stu);
 }
 
-static void arm_smmu_disable_ats(struct arm_smmu_master *master)
+static void arm_smmu_disable_ats(struct arm_smmu_master *master,
+				 struct arm_smmu_domain *smmu_domain)
 {
-	struct arm_smmu_domain *smmu_domain = master->domain;
-
 	if (!master->ats_enabled)
 		return;
 
@@ -2514,7 +2513,7 @@ static void arm_smmu_detach_dev(struct arm_smmu_master *master)
 	if (!smmu_domain)
 		return;
 
-	arm_smmu_disable_ats(master);
+	arm_smmu_disable_ats(master, smmu_domain);
 
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
 	list_del(&master->domain_head);
@@ -2636,7 +2635,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 		break;
 	}
 
-	arm_smmu_enable_ats(master);
+	arm_smmu_enable_ats(master, smmu_domain);
 	goto out_unlock;
 
 out_list_del:
-- 
2.43.2

