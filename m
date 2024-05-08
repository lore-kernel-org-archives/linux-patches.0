Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2063.outbound.protection.outlook.com [40.107.93.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 055E5182;
	Wed,  8 May 2024 18:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715194651; cv=fail; b=m7imIU6sYwbaDPyKd8l0YB47UK2JE3Q7rYysjST5FHqYVk1yeYu7/j29Jo/ZIr5AUAXmSCKdV/HaG3BaDc93lbGj01ZzaEJN3kNKn6sVcravxw2PakXoAXqVZE3ETgmKP+FlT9oRjTvCWJMtGHmUicN6MqiXMCV2Lz2k8k3BbAk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715194651; c=relaxed/simple;
	bh=2Zs6Mz7JHezhHehjb9npiBz0Tnh5RhGUt35J7VIwYzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BKF3xj3eyRpIxluqV0qNoSdyBXrS1e6nOYtB93C6I0Ice0+BPrejd1pjGmOeUJkUbe44PRFtCNBK+FicabdY6QxSDQfA9HiU+aNKOn4NfszZPBarSZ+Fz8XhExgjm48s9h7w+I42AYn2PSqpZns+LtK+g/Hsb6rk3z0tulQfjnc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=c7K50nfU; arc=fail smtp.client-ip=40.107.93.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="c7K50nfU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WoOQ0Gf0c+FzBoh1uOkLFql0ew+CKN1i1tPCy2+j5O37viVvz1vYywXgXjZH7+ajA69F4u747AHw+NdExRX3GgbyCpmBgd99VX2VqNPMtnumCNYn1YzrAsatKHWdZcUUXb4Wve0CdyASg4BlM/dssWjKOP8k6RjuebGc0wJ4dhFm/zV77+oG6I4oIV2Is3hC3egAKF83Xrk3mCouUa2fOoi//rp48ZdoZLHkI+O8kydGC1QIO91pje+3pL5lEAwgJVNpigHPgYu2q58SqZWMHiEO0tPBep6ATiwjQYox2lUiRdyv4AD4U75fSggFEUYBaSXA711mY5FbkeLWgv01+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zA4LpcSGupkkN6Fq3FTszpjZ3K+o8PFd02Wzq1eQV8o=;
 b=NfQtKIkHOqZ4s6zlgSp0wzcc2hCcWnxtPwV42IXUcUh0OKb+/lZ1r2Cz0nlq8qH3xwyrLIjFGRizKyjUmuwvQpsKVvUH8EdhWZkRb2ulpjOsE1NR9pQYTHQ/QJQGKkIgyJ+I3C7znU4RpDcB5PWb08ja8q9jJYX1LeFW9avtvSshBb0mxYTkv6wqZm5mHIEbGqSOwbiQTi/heVW3yN2QO6W6Vc2z81iwmCr94HyV8PskXpoFRMvLuwOIRXz+PmOVxYIOq3Ho7yyjjG4Zp0GqdJ3+mXqxA26+W8XK31qHb+/2xQK/EWpJTzWL0eWcEItJPOzFBO7W2H2dpNh/ibQr8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zA4LpcSGupkkN6Fq3FTszpjZ3K+o8PFd02Wzq1eQV8o=;
 b=c7K50nfUN12xrG/E6q7x/PGHiUv3uJosZMVLRxTZNdbMqllqmdwrhnU0wAUXxe8tTFMgjDGPI9fUoYCy56+opAQSpWCOTTRAvTqi7sr12tGinZN4xvLgjI6iFcwCoFiLmvbejn0eoCM0oRjreukBH82ojmT1ZaS68FOl5IYuCoTrm6McSNH+WmFe6VwnMpXzIiOP2FwKGzM0zljAD36SjCbOkiSDKQPTPCbNKLb2pn+8CwwxaaPtqzqnEYe8rCufqP+yZdMyQQH4dsjqm0/SlOWBW30aJ10d7hcmWY4NcPKCqy4J23865rrxafxfUwpU0YxnfFkvfz1KxOfrjjT5Zw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by CY8PR12MB7514.namprd12.prod.outlook.com (2603:10b6:930:92::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.46; Wed, 8 May
 2024 18:57:24 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%3]) with mapi id 15.20.7544.045; Wed, 8 May 2024
 18:57:24 +0000
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
Subject: [PATCH v7 01/14] iommu/arm-smmu-v3: Convert to domain_alloc_sva()
Date: Wed,  8 May 2024 15:57:09 -0300
Message-ID: <1-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
In-Reply-To: <0-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P221CA0022.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::16) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|CY8PR12MB7514:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b3f0850-b106-4bf7-2237-08dc6f90b28d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|7416005|1800799015|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pF3r7IQ4dohks5tT5YKmgjHm4DLejXSJlq+3MmqATRf0q0bB4GALePOHs2+J?=
 =?us-ascii?Q?23xRRzllKBJojqyTC5ON0k7ekgV8VkeLSf1K7IS0DIDTO+VX6nr+hbfPyBuf?=
 =?us-ascii?Q?yErRNs80OTKFNC4/XrHlIaZZHT7+JUIaFU10Am9ONonxYDm/Jt+80vFWAovz?=
 =?us-ascii?Q?4pWyRcXuwNoinUvDTO3IklV5e2S1tW25pu7E77duHeJ6IW1MZBfDFU8hlCLg?=
 =?us-ascii?Q?9aTeKose7Z5dvd8TNT8aj6kwGd+vq8n4wvwZ5Aq5VG1FHjjU4ACddJRsQ0mS?=
 =?us-ascii?Q?3BK3Q9O00kCDzWQaakanro2f688KYr42ZjhmhRLOIxH8/nsStEuda49hrEjW?=
 =?us-ascii?Q?Zh+mS+HDrwvnTnfDAH4bJoiD8pz0TDpynjBuqudE1M0IwoeWZ/Xr30mfht/p?=
 =?us-ascii?Q?glx/BRlCRJMQYlq1Igu1sKeAq07M1iWoIukyboOVeuPdoHPx5ivkf/421xa6?=
 =?us-ascii?Q?fdcRPNus8Iq2855FZsulYXnHTksDXWGC/mFZaq56pBtVrBYUIdpefVe2RoSS?=
 =?us-ascii?Q?CdmpSTLjagXbprkLFIzK9MrZ7U9va5lBq/JFZqyB6ffAvTy0PODv9oinOFVE?=
 =?us-ascii?Q?MBm7irVWVZfYiQMVAUW5C9gjzRAZGMvyUCDmMSwLE5Rla29LDkHPEZrUKXvp?=
 =?us-ascii?Q?KlFyR+QDuP3aP859GXZzIT1ngWqd2NTd4DJsgbWNzAI/60QhMkzoJZPZwlYH?=
 =?us-ascii?Q?9dTfQM9qQgZ1VVCljG4GF2NUOavNRZbIBnaA0Sfk8WJQBBybw4plRKh9cOwc?=
 =?us-ascii?Q?qB22TGwc7gLdM3Cg8l+thbXgPicAP8YG6o4zq5TydpYtZN72JPRXgiYW1GkJ?=
 =?us-ascii?Q?ih1+vsjFQ62YRgdy2UM/RdimBMtVmJqLnJujFsBOXCZGBi/ML/7GeN/Onywz?=
 =?us-ascii?Q?pxQD/yDWKx193ttV9jHeEFri0BGbyFGvOKO3J4ThOX4UhpztrB3Nnruja/J0?=
 =?us-ascii?Q?8q4a2iqL92ZuaAOcjizYmzMxAr9hLtjwcD8bbvutOenjqsZCyM79FZEoI2+K?=
 =?us-ascii?Q?eEjQoFNPpI++rfD8wRKWuZy1hfpzvJJB5rBbzkktloNTZWtyQNmgReY6DnJM?=
 =?us-ascii?Q?SsYZ0niYFjKn+AStfZNb7Br8NY6ccgfgnJxq6VTaoQaVXgwxUabbT1Kwd0PW?=
 =?us-ascii?Q?IF2o4B55JGTjr2YZeTkckXM+5/9wuFNhpfnIlx+1kzjjFDQb1pXVN+2oTwsX?=
 =?us-ascii?Q?MsdDr64nnyiSRk00Ser6OVQV+kWG/Ju99sBocSfRLZdzrfDa1Mp+rcJGqAaH?=
 =?us-ascii?Q?aNKhkmAFJMNmp38V9gLvcrjl6TiO/5uy/XcK2HAyJw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?AqEoZUUqR+1N61bL046esm6RsqXRo5W+xXuePUCpsWV2aUDs5bnc5UaomwMw?=
 =?us-ascii?Q?MFNw1Q9Uhssv4Nb1B0qddqI1jqJDhfl43rpxrAG+Yprusghio3UAUGmZ6lsP?=
 =?us-ascii?Q?PSpmRA07g6MurVQw420uUQ8ufxpHmxJlql0qE9sMoEsOCL+Zd4KbGcwkdhKn?=
 =?us-ascii?Q?tnzSSdqV0lPc1/ittbH6LJyoSiMDkAcGwaf0EEJUUxjTzv34c1nSxSN8uQFE?=
 =?us-ascii?Q?u957cO04HExNjQACGOyzN24KhRcDqyTJur3CCo+qkPW+u9FWJ8opqlbBIrpB?=
 =?us-ascii?Q?UkwLNaT52pv/B+fvBkjiuhBYRQFL1aYWH2wRnLX2FYvGPxeB4BiZDhDxTcg0?=
 =?us-ascii?Q?BTl1QxcAakQDPnnBhnZVeQZtxfqfOwgLG8JWgQLnafYDaRML2UNjvbzi31BC?=
 =?us-ascii?Q?I2Szw4l7ZggaPFw3vg4RjNij4SnZzR7R1ySbbUKU9MHC2Z7w++9sMkHgyFLC?=
 =?us-ascii?Q?u7Daht97S/G2njLCXEOR3gmg/C49xRJEu0Nw8g1xtqeLqbtVDex8i/1An4BD?=
 =?us-ascii?Q?rJqAceMWf+GkTGedWKgUKUr/O89JvHFMG088GSflJP1CHwFe+ubyyey0wzF4?=
 =?us-ascii?Q?DsRMQb1F44tIKELGl5v56IevB7UftMDr0XaR7O9QWbY5Uer2kk2vycOU0caO?=
 =?us-ascii?Q?iDtZ0KTu2DKtOameXVkndxTeI11WXVZlj36N0X4mxoVpw6GtlRAwpzBkX0m+?=
 =?us-ascii?Q?4S6843WiW0c7WZmoi4ft7UytYWVSSw5pr7MfknmT0/imj6vyGPPWfLg7AqTE?=
 =?us-ascii?Q?38YiBbJ6YSNBZ74W3ZqNKXM7EpPYkRBpnpvIRo0I5WGfUitQcFIlqqTnVlhd?=
 =?us-ascii?Q?M+b9ae58cuk35kTat3x281QyTELU6b2lray0crnzVkU8OsxCfvrsrmd/Dfny?=
 =?us-ascii?Q?bInTIly8vvQoJM3uRP7yrBpvnZ105wgJaoLnFwGjk+5yTORkQrTLREu/gs73?=
 =?us-ascii?Q?F8ljkKXHfVuKPgI9OFkLGWipw4xgc4NslQQ/sFLYRCvURgwx/GgwrseytaqH?=
 =?us-ascii?Q?QdBV4MTO6wHT3GI8zzW9IVzuE/kpoSVbhuLDqf1wb891iKIW0nDraksxVENG?=
 =?us-ascii?Q?igabjr/p5Ia7sStNRq4NbIeUBJapcguxZcomjK+wOv+aG4B/i4a63B1Rax+C?=
 =?us-ascii?Q?zy82b8pkiRWMiwHe/d1DnzPG0MrSijufGjXd335EfTa1s9fvjCxulXFbrM/F?=
 =?us-ascii?Q?JFTFb29LheMoe4LKZIcTRsx0Ocgs4AUPdvIhTe+2fTNTE1TEuqBu0ziNH4qb?=
 =?us-ascii?Q?ttDAaT5tN0VzRkt4Kq63wWxfjWPFqtJZ9YCwAcUVtIEnm4DlZaeOWXMqG53N?=
 =?us-ascii?Q?oDld1jts9/gKBaGrt2yTuRHmGBoX8MMgkcsQ+QTGidd83z2u1Ef6SDJgTgC+?=
 =?us-ascii?Q?76W1de8IA/5fo9JXMAQoRf6EtvxYNgZBWyBD3EChjFRYeA/dqURRbcDg5Dev?=
 =?us-ascii?Q?Urm/Sgneo4lbmWaISTuK6vyespH7TWvEhQB06gsKyF4wwg8xZPPy+2NIFrrx?=
 =?us-ascii?Q?X2+SwIQMX0LrP453cj0Um4kiyKxOL+rbZIecmL3LjQTf1oLNIIOmeEW/to7x?=
 =?us-ascii?Q?qQKq5lst66XMrbYTBZSVx3Z9up2yEmcjMmGrdxsD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b3f0850-b106-4bf7-2237-08dc6f90b28d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2024 18:57:24.3283
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NddKqfuEeunMHL07fynZFbndX6uLiGdMciXq7RE5T2ySZsoHzHOe7qhEFcsMqrAN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7514

This allows the driver the receive the mm and a always a device during
allocation. Later patches need this to properly setup the notifier when
the domain is first allocated.

Remove ops->domain_alloc() as SVA was the only remaining purpose.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Reviewed-by: Michael Shavit <mshavit@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c |  6 ++++--
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c     | 10 +---------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h     |  6 +++++-
 3 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index e490ffb3801545..28f8bf4327f69a 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -656,13 +656,15 @@ static const struct iommu_domain_ops arm_smmu_sva_domain_ops = {
 	.free			= arm_smmu_sva_domain_free
 };
 
-struct iommu_domain *arm_smmu_sva_domain_alloc(void)
+struct iommu_domain *arm_smmu_sva_domain_alloc(struct device *dev,
+					       struct mm_struct *mm)
 {
 	struct iommu_domain *domain;
 
 	domain = kzalloc(sizeof(*domain), GFP_KERNEL);
 	if (!domain)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
+	domain->type = IOMMU_DOMAIN_SVA;
 	domain->ops = &arm_smmu_sva_domain_ops;
 
 	return domain;
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index ab415e107054c1..bd79422f7b6f50 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2237,14 +2237,6 @@ static bool arm_smmu_capable(struct device *dev, enum iommu_cap cap)
 	}
 }
 
-static struct iommu_domain *arm_smmu_domain_alloc(unsigned type)
-{
-
-	if (type == IOMMU_DOMAIN_SVA)
-		return arm_smmu_sva_domain_alloc();
-	return ERR_PTR(-EOPNOTSUPP);
-}
-
 static struct iommu_domain *arm_smmu_domain_alloc_paging(struct device *dev)
 {
 	struct arm_smmu_domain *smmu_domain;
@@ -3097,8 +3089,8 @@ static struct iommu_ops arm_smmu_ops = {
 	.identity_domain	= &arm_smmu_identity_domain,
 	.blocked_domain		= &arm_smmu_blocked_domain,
 	.capable		= arm_smmu_capable,
-	.domain_alloc		= arm_smmu_domain_alloc,
 	.domain_alloc_paging    = arm_smmu_domain_alloc_paging,
+	.domain_alloc_sva       = arm_smmu_sva_domain_alloc,
 	.probe_device		= arm_smmu_probe_device,
 	.release_device		= arm_smmu_release_device,
 	.device_group		= arm_smmu_device_group,
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 1242a086c9f948..4c6c843669aaf9 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -802,7 +802,8 @@ int arm_smmu_master_enable_sva(struct arm_smmu_master *master);
 int arm_smmu_master_disable_sva(struct arm_smmu_master *master);
 bool arm_smmu_master_iopf_supported(struct arm_smmu_master *master);
 void arm_smmu_sva_notifier_synchronize(void);
-struct iommu_domain *arm_smmu_sva_domain_alloc(void);
+struct iommu_domain *arm_smmu_sva_domain_alloc(struct device *dev,
+					       struct mm_struct *mm);
 void arm_smmu_sva_remove_dev_pasid(struct iommu_domain *domain,
 				   struct device *dev, ioasid_t id);
 #else /* CONFIG_ARM_SMMU_V3_SVA */
@@ -848,5 +849,8 @@ static inline void arm_smmu_sva_remove_dev_pasid(struct iommu_domain *domain,
 						 ioasid_t id)
 {
 }
+
+#define arm_smmu_sva_domain_alloc NULL
+
 #endif /* CONFIG_ARM_SMMU_V3_SVA */
 #endif /* _ARM_SMMU_V3_H */
-- 
2.43.2

