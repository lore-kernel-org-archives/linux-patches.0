Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2085.outbound.protection.outlook.com [40.107.243.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62342157E74;
	Tue, 25 Jun 2024 12:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719319077; cv=fail; b=ag8W6tkqESOv9XMZiRoWXWjxTi26WwdqK9F8tQJMRWK44AO5RKh1/uqaz/5Rl6XQ17NlQto0QWpXIL/lq+3AE0PaNtoFkMZS4uYqnEp/LDH0ffVIcvXyJHxCAVDDNFsRLBjB/6Gc7u4kSwhb1Eb7G0VdyTZLzvztuaakhSLLZ/g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719319077; c=relaxed/simple;
	bh=RMUUDt5TTsdrOyVhsOWe2vtQm8lKHLq6MF0yuPVNLhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hrdtHtztx3ZJx+o7+4xNr/qBF7pBo/CRWjYlcVKGEDzj8RyMYlmZJ/KVDlV5gK2ZdUy9eNvUiyTEVtm7xO/wwGf/LUMdihUfbm1x/0a4eNVu5FwyHJDgSdLShQHtfU2nq8fEuyHveGs26kYPoLv8F+3QhzV9g2kNRV7XNG0kBbw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=tMknIM6g; arc=fail smtp.client-ip=40.107.243.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="tMknIM6g"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kedrYKLc98xunUYZCAgAQJb301j1WtQk9Pnus1TBzvj6iiUBmwG+/sdyoNAuEf/pikmahUfb31iEq1pqyTJ78cNsKWR/ygarYiQJ4rLlDPmMBdNugxSDcoJDC1yOumR4P/s9DUstONw7GHnfMI8iZXVrZ0nRTBcZrT9882T4utzUWaED3k8Acojnq/6u38vdztCDcjjrIb/uVppXsRs9u4Eu47BSNpAIM/owTl+VBJl6RRPBnTYrsFbR9O0y8YS7ytjUqxuNPIUipniLT3D+nbuTgemeGyRGsQvCtqQYllfbT56JqLEE+OBkrpTDTd1C4nL9RBbRZe85n2CO7ngR7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1i++RQCQL5qxV7vyGBJbGGXKxmuLTHlROMHhcJi/+gk=;
 b=jZPhGigW6yKKZaJ6SdJyp9crktCKEjC2uBDXXDD2C3KqAq/xqAsC2msIx0vIEDf/TlfQOwxGEZRPN5GxSUXdbzLLybBNJRAqmVPcKYMFtksQjNSCxIRA7EQVB/eBNesNaycUzHxgVrfBKx76O0OTSOpzEr9PKYXegSTNl/EWzm/LnKKucMUz8c2i77pvDcBMfKGmfWOrM1nSlN722sfbrgMhFeug6DHkbvTvBGKoa5EUr1pnrKiYhyzTD0MtLAhYtu4JmMX81eVu/GkPtjq8MRouMoR2hnRGbepd34v8HS2UhcPOqT+OdSbJJcRAx1WPPsFWQGWjpj+666OecGhVig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1i++RQCQL5qxV7vyGBJbGGXKxmuLTHlROMHhcJi/+gk=;
 b=tMknIM6gw7enQP+JYGMMYhSGp5hW8/eC3UE1ZsUxWI/HSMy5ZeZhrjRYi8E5iuFnHqTs5u0FTHBdCAA2BPQq58XwllmtfMc2CPce899D5OjkdAoJuSns65BH9a7xtwxF592H2cGRipuiQrZiaj91arCpfeyRLbvVwB9hySFSzxOyaZXp4ZKfV0Oxy/hJgOJ4lIKdcsHaWDsLc2UolHr+jewQj1+U3QEnkqqxCgxF50dhWGYZCIxoTh8GAPxX8KK5YtC78iuOQHKrWo0lTfxp79umlfOe1Nn1CdUkoI30/OiIwQCNNmejpLzqwiK8w3qxr7xHFwRuXQSoN99CY3VjwQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by SA1PR12MB8946.namprd12.prod.outlook.com (2603:10b6:806:375::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.26; Tue, 25 Jun
 2024 12:37:48 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%6]) with mapi id 15.20.7698.025; Tue, 25 Jun 2024
 12:37:48 +0000
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
Subject: [PATCH v9 09/14] iommu/arm-smmu-v3: Keep track of arm_smmu_master_domain for SVA
Date: Tue, 25 Jun 2024 09:37:40 -0300
Message-ID: <9-v9-5cd718286059+79186-smmuv3_newapi_p2b_jgg@nvidia.com>
In-Reply-To: <0-v9-5cd718286059+79186-smmuv3_newapi_p2b_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR13CA0008.namprd13.prod.outlook.com
 (2603:10b6:208:160::21) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|SA1PR12MB8946:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e6b3a05-8b9c-4791-c112-08dc95139dbf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|7416011|366013|1800799021|376011;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Yt8oSQO4ozpoGYwcXNpGFk/v8SfXQJdsimVKH1zuIuCg0pjnoBtKYZFytgwY?=
 =?us-ascii?Q?DWZvpCTFezEZf/1RaWhHTSqkS6ZuUVgc9ZU3L1+IoaOStJtLQL/imjMwFM3k?=
 =?us-ascii?Q?ce65aa4kOf2FFOn5/iH7MKRHvNbvC1sDZ83hN3Rb+7ndpsddCuHuwrLThRyA?=
 =?us-ascii?Q?f5s7BEXsi3SG0FdIJhGbTE6rz9w2uMD5/+XFFkgpMtk8WlATqryDFQs4sY4X?=
 =?us-ascii?Q?D6UEAW1oEX0uzo+q+WNKn0P+XhEisaEZSyYozeo41v1qU9f1CgyY6PXcOzci?=
 =?us-ascii?Q?YUDI1nXoFHzl/dQUTjHCzwnlqm3MI37SwJsS5mblXc+j3LlDCWJWtrxE6u4A?=
 =?us-ascii?Q?yfai3+3KyG9yl6AKx9orZwZ7vtkwWIzwfNUTnkfoDN6zSfue/TcbsXNa6OSr?=
 =?us-ascii?Q?UG/mkXR2TlR0Go6/20aLBRqneJ3oIYoJrukImCKHumicoORc8xdcIKZqbdnJ?=
 =?us-ascii?Q?sDTKS3YUowG3QohiReyCLVGBkZ36+FN4j2O0RiCBW4qygodBo4gCQ9lvLgZ8?=
 =?us-ascii?Q?Gb5tnSUVwNLcKmSk+4BOcg5l5eI7Ar7n4NNZgpkOwPMybMJ6IuKY0DjO/rtD?=
 =?us-ascii?Q?VfOpk1zsP050qvXi1bOoA4kbnPq0ataMfC6iOCCPwJ2pqknQgHwuq7/AfELL?=
 =?us-ascii?Q?r4XmrjByVTOwgKg5K2LQxu6tnqzNsxOXfFdTLORh3EaQ4mb+lSN9BbhkWud7?=
 =?us-ascii?Q?+dlCSyJIPHCoTI54B0nwwDWdSRGpnpmHgave2Sv5qssnDuEqENeYd+0wjChd?=
 =?us-ascii?Q?WIwajfm5Q8qNRIy7syU2TPNApI1NznHaYS4it/nU8r/yOpIbFAqq70DlV2ny?=
 =?us-ascii?Q?QaqvTodN+DQGif9SnMUYsEzAH5GWi+CAIg/vtK2mPYc8X5kl8Se2uAYx7Xvx?=
 =?us-ascii?Q?Wyto2yNAkU3TdJwBqIv9ZNyUo0XzADUZaSRnv3S4/MNbfM/GaCNvv+Lj1Yhw?=
 =?us-ascii?Q?3Q26y7V5lcM/DH+D6UNnvtQNVcme2djNh/R3KEUMhdeP8+yfX6+rHB27ErRf?=
 =?us-ascii?Q?/+YpVStcHs/pxsFtgBnuYHLJRcO39Z3L8vUZSLiqNIr5UhRJipGMcp8DXbgq?=
 =?us-ascii?Q?NHaaP8KX4zXPhsX5q5OL3yQr4GZTPVITPsIzJBf+DN9rzc8q7b1TuG0Xhev2?=
 =?us-ascii?Q?X/mqMI3Gb0H3z4KrAkp9UF6CCacq4yyAXQmPamuFwLiRtM/TJBA0FTuStjXi?=
 =?us-ascii?Q?91q9pyRCNLN0EroNVIznU7eM2s1Oy26kKzYY1gwigi2SeUR4Ok7OLta0WgMw?=
 =?us-ascii?Q?EsVRYTC8KFgcKvx4CKbEZPEbSgn35oCdFz6vO8XM8dzWPn2fRF0RgSSrBYKp?=
 =?us-ascii?Q?68o=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(7416011)(366013)(1800799021)(376011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Z89r19csGpd8eW8bYXRo5895h5PZNnWhExuhJRwcIVFKIR8k4ON1v7/1rbfA?=
 =?us-ascii?Q?oGDNhzAf4kftlZPw1AdKg6k54AdF4NLZL+Etfo37ZMVWZjWhee+TjiMnNJ8w?=
 =?us-ascii?Q?rX/ajUurS4+fSq8ZeN3mQmh/6zMBz76qiyKI3ksny/RC9xqMBR3g09JxSl3s?=
 =?us-ascii?Q?zl3reDKUasVMhCHI8NXq4TlqZPAd7DpasuSGESno1pzihdDnohY8Gpdpjmkq?=
 =?us-ascii?Q?Z95mWSHn0FSKbmXd/ivg6W+WCnUGyM6gnSL4qoFKtUrdBxIr56c+oY9jH/cQ?=
 =?us-ascii?Q?TI4mtO2JHQx+AxgQ1OVOEoSLwhY7Fu6VGquqAE40cUPEE78h4yp5hDM6PNrR?=
 =?us-ascii?Q?7ckfkoLA6C8O9XbqAC2g7VNzgD/qVyPt/o3WYPb9sgdPlsVmJ1sOhlwBjfns?=
 =?us-ascii?Q?Y8N//qc70r092DxcjGJyOT0wuGR/c7akhLA6t/sV5LCO8ArgbGm8f+ogRbrk?=
 =?us-ascii?Q?y42RQUF/N02EF6dB8Zghqhk0GNAw2iPpIVp1mP3DQaqc8CCrl3QVYYpPh5Ir?=
 =?us-ascii?Q?/hPWX/njSfmQ70gJ2bthpyAr/Sx1wqwSsEkmGrGT+vZfeQCZYE0zhBxDdVzD?=
 =?us-ascii?Q?KHt+eOwxG7mstsnEx/yswbRV+6EwgL07SPuwOKW9GGJqI4H+uuxbll0vYLz7?=
 =?us-ascii?Q?oGKc3ueF3IC71a/bktTJ0gvSn2xIMFWni/trG4zWv99BWFxlye9VrRtYZ8v6?=
 =?us-ascii?Q?byEGvql1JPGiN9iW2Quor1Gj9q3PfDm9nbEs6TdVeWm2Cete/fXTLEv+FT58?=
 =?us-ascii?Q?e+cdRQsuZ1L1mNUcb+dsxW/3Ya0QY2as2c2NJTlY6f1AD1r74HwDoX0QpmOy?=
 =?us-ascii?Q?WWcULqA3GkzgihkzVJ4N6howYwSzTy8PKV73YcdcmJADgviX2ILOIwb9Jx4V?=
 =?us-ascii?Q?AVfX7fIPSk4wwiZjRh99so9knZYDK5Z5F21H5Sa0sqfxladWCmNGam70I3cR?=
 =?us-ascii?Q?wvq7wxnS1wu9qo+zOYHW4FBojIi1uHqxqrkjXhUTzBYQ0VNfhmnOTqgmevjh?=
 =?us-ascii?Q?5QiL0vcZjEbm2rhQpgY9oZouVPI+uI4KpvFpps31V4VOKMmtwAg/bYOgHGjQ?=
 =?us-ascii?Q?RuQ9x4LokDWk3NWrDlOZ1Pn+IvsIvndc6zOfAf+VPF5OkmmnAEoxu/On9dbF?=
 =?us-ascii?Q?kmL8VFLI4qbiDKTIhX9ZJFClwAM+FhSH4RMgSxnZupVATqp5wtZBvC+b9hRN?=
 =?us-ascii?Q?gE1RVF9psL5+xsHv6NHwEvvmBbHylRLmlCgmLSSz9qGV5p1vet//f79vLaAQ?=
 =?us-ascii?Q?JrDN6/pZjeZg4vSsI3nu6rcdTJFBgKCcSKnXBBpr1kBHvc6FYhOVrKIC0YRr?=
 =?us-ascii?Q?/OpeODGaNBzHH8yWptD4QbKnjCXxtHn0W/1J0BihDiF4fKPYK8c5DKm+0jMQ?=
 =?us-ascii?Q?TcVM8B9C2OVQxRUaSC59iX06Jlviqxzoprhnm+ozccAWMRxFnSy3+68piHsp?=
 =?us-ascii?Q?JLibmM+KNPYdWh5tUHWfLA9m9vFW7fSl92Tb8mL2C/W5hZp25f2yWEmK07Lm?=
 =?us-ascii?Q?6/3PEleJSB5oxbs37dixrguvFJEpAkIBg7nDcHZl6lpWMbLK+5aSgFE+D/B8?=
 =?us-ascii?Q?tMK0nJvI7/bu0/2eWn9gHog/cWeAUMBu6gBxNlPy?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e6b3a05-8b9c-4791-c112-08dc95139dbf
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2024 12:37:46.4663
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i9Re99zyu1IIvzu/Cb1wNNIlrND4n25neus4OVS84a9ZD0CpVtGGCZsFXrtgL9Nc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8946

Fill in the smmu_domain->devices list in the new struct arm_smmu_domain
that SVA allocates. Keep track of every SSID and master that is using the
domain reusing the logic for the RID attach.

This is the first step to making the SVA invalidation follow the same
design as S1/S2 invalidation. At present nothing will read this list.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 30 +++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index dc1d53ce2b40fb..527560b36b3993 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2587,7 +2587,8 @@ to_smmu_domain_devices(struct iommu_domain *domain)
 	/* The domain can be NULL only when processing the first attach */
 	if (!domain)
 		return NULL;
-	if (domain->type & __IOMMU_DOMAIN_PAGING)
+	if ((domain->type & __IOMMU_DOMAIN_PAGING) ||
+	    domain->type == IOMMU_DOMAIN_SVA)
 		return to_smmu_domain(domain);
 	return NULL;
 }
@@ -2820,7 +2821,16 @@ int arm_smmu_set_pasid(struct arm_smmu_master *master,
 		       struct arm_smmu_domain *smmu_domain, ioasid_t pasid,
 		       const struct arm_smmu_cd *cd)
 {
+	struct arm_smmu_attach_state state = {
+		.master = master,
+		/*
+		 * For now the core code prevents calling this when a domain is
+		 * already attached, no need to set old_domain.
+		 */
+		.ssid = pasid,
+	};
 	struct arm_smmu_cd *cdptr;
+	int ret;
 
 	/* The core code validates pasid */
 
@@ -2830,14 +2840,30 @@ int arm_smmu_set_pasid(struct arm_smmu_master *master,
 	cdptr = arm_smmu_alloc_cd_ptr(master, pasid);
 	if (!cdptr)
 		return -ENOMEM;
+
+	mutex_lock(&arm_smmu_asid_lock);
+	ret = arm_smmu_attach_prepare(&state, &smmu_domain->domain);
+	if (ret)
+		goto out_unlock;
+
 	arm_smmu_write_cd_entry(master, pasid, cdptr, cd);
-	return 0;
+
+	arm_smmu_attach_commit(&state);
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
2.45.2

