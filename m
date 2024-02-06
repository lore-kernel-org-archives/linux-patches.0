Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2040.outbound.protection.outlook.com [40.107.95.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 441DE134747;
	Tue,  6 Feb 2024 15:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707232383; cv=fail; b=UPJRdTRhYq3aXVmNHXVCkU9xjkZmwnAiwTZynt5BND3FFYmkEPy+SHz+TD6my73JlSt3KtCFs/lAaacXyJd7WdAfmBEeM3sleljTCWrp5zlmolM9BQGxZabF+rNVGywf66iYZFQ1ZRbZSooxh2AHjee51kkqeDtwU6OQUY+HGkk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707232383; c=relaxed/simple;
	bh=ppXt9FeQ83YlkjdEj0aMysn9YOP1KiIhkjNQH3yHoac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DPODTiN1WvhUa/haX8vCwsNmFpqlymRPfhs/cTZ+zKeqB70Dn9MJv7LtQTSvjW6LJTRMU9xK0Oup4HW0mTFnDHP+hvljVKFz72cVDjZ0Vvb+27It+o+Q9WHNrvLxb+eNl1u99XDPXwVdUSHJpy8kTjS37V/fiFgp0FK2YYXzfk0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=lITDn6LH; arc=fail smtp.client-ip=40.107.95.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lITDn6LH"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RJWGqq0AqPoRQzYq0b316XOm+m+D84+01gKdws23yiJqHGJG0oqqtU20TaSDmMhuw0pKtJXMlO4/r+f2W/fw006QCMS21J8y12B3tsQtPNGNswEXmDEgx+PxmXuBZhgjLhAQ7ceX772x75lZ2bJS2NPhLPbfDz5vldlfLDLkYcXjWoumwRC53mLrq0vmYhMZ4Bf4br4jBbJOtZnq7Z/jOgFGRtIveKCHtMdlbG26CswcjXJq1IC8IrM8diWnBYDnLhOlZ9QE088oc9ZYT7cMdeOIe7tmwVykA1WxOq4PAZMvcBSAXjgfH/hZEpRB23v41pRWG4j7y9EyB4qNli7JDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3MTlkhWEC9fX18quSmtS4wAXnXr4cMfsGl3GZP3+oA4=;
 b=oX4RpOeuqkGdFjL5DA+CKxgkd8lrTrwqX5kQO++ash2yQnZnzwz+4Uc8ittVyXHgqApAREjQAQpwSZiVPI/CVbmMPcfNMwVaf0Q0trS8oWP7VtltpsiyNz0nQSvP8xZ/kUmkIYZT8irGhVIVKhuaGWMqwTp7/Wn4duk+X/nnx9aUHz5pkwUX8bp2Qnu0eTQIkdXUf1X0hbE8EiE9ZE0xMgOv6rxpYzUmSgxIL4do4JXfvqeIcQb0OloyTzAXB3RuZloW3fIVG3Hpa8Xq4NGc8IdMTj5GZ2dfkgSbLrrYve7Alw2gYC4Y+rfdXXI40/NkaEGEiqjdXjMjsxCzOw7TRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3MTlkhWEC9fX18quSmtS4wAXnXr4cMfsGl3GZP3+oA4=;
 b=lITDn6LHy+jCV9ylvqDG69Rmv64Zi+fos6FJjLd2ZQDEq6r/O7iSpOmhnMobpqrVc3Xou8b+zrjsc/m53AQ9ZoHA3NrXNQWTV3UzlaXDpg18hWSkIs0721N3PYP7DKVeXopoQVJ9t3kKHP2AT27QNYub3FpXeM8kz5tnCMqhil71egqd/+DRgvHTkDAc+Jra3XMLyayelXehCUrg+XqXQKMKChM0lEmSdOl5A1MWveHQheQAacv6Q1nm2/QP2dEQcjtgvP9uZQnGHuX8/CcgdMwW+vuXwccYvnthy1WeZJkRY+dGKPoVephsS6H2M4i+RX7BGFz0u9II9mzoZ8Pi5w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CY5PR12MB9056.namprd12.prod.outlook.com (2603:10b6:930:34::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.15; Tue, 6 Feb
 2024 15:12:57 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7270.012; Tue, 6 Feb 2024
 15:12:57 +0000
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
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH v5 14/17] iommu/arm-smmu-v3: Add a global static BLOCKED domain
Date: Tue,  6 Feb 2024 11:12:51 -0400
Message-ID: <14-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
In-Reply-To: <0-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR13CA0001.namprd13.prod.outlook.com
 (2603:10b6:208:160::14) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CY5PR12MB9056:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d2055ec-166a-4f82-ef41-08dc27261857
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	6REEQfWKDJs+PTafMeXbhpX2uul7HNEPaDicsOCxLqjPgBlxtJ0rGBd5hrFAFDu2JMZARsfwVSxLehBIizcpnvC8Khq749dvVliF/F1Vj/ocCdMDTJHeVl3YkeD8ONFftIlAqhOuQ0ClD+b/xihx1mIOcdPKPezZSZSLeQlBuTephisfbaflw56BxEs+Jj8C9z5ojq+8wIf4WJn2OKQygwGX3uqH+RIOd9WpuEnUnGQ0V5mzyQqDlSutIJTQttEBFFfJwK0cn4sfW2iMfoSRw6ES40FP4bqckzXr4u4cuzzOGACUMZUoH6ZuankulAY+TX5FcaMmfydmgU7xkjx2gBAfIF8KgbIwZrK3Qi3mpNwgjnhDuCp1F7MqcHAS6XNrFyuvKOayXa4/sxKOCiURTApdQQkGUc1MVB3sdcTmGKD6WMjLJs+pSr2JcSaEZHITDkEGwF8kCpY7SYNC7cE5qj6G/JN7o+nz1xKeMc2VjGBo29GGZBtBQ6A2ipb/zP4s9SJxCAKua9Yntz36tcuyQOMoAj8BxzIjDn1epan5XA4Hx+Xl3X4C+Sj98w062OyU
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(346002)(396003)(136003)(376002)(39860400002)(230922051799003)(186009)(1800799012)(64100799003)(451199024)(316002)(110136005)(83380400001)(54906003)(66556008)(2616005)(38100700002)(6666004)(6506007)(26005)(6512007)(5660300002)(86362001)(7416002)(6486002)(478600001)(2906002)(8676002)(66946007)(4326008)(36756003)(8936002)(15650500001)(66476007)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YMKzEjOTVvEh9MKgAJXwiS4f5ycPvWfFpqgVGmYyUraKsXUszmBGF9lg4hB0?=
 =?us-ascii?Q?e3+dPOt1lhbQ80WbxqYHAw4/k1U1QiSiWoND+wazvfOdLinpOejzgtLPjNnE?=
 =?us-ascii?Q?joHM7L7pkACZ9ZJj+Mrk6QmTpCPwQ7B0f3z3zCXKLXYm2EJd0PReuB+B83fL?=
 =?us-ascii?Q?nVpeP2k7DpdbsPzP0hu7c7oHDZaOZ0zI8EUXsf4YYqpi/U7ZqJJ7ef0RrHHH?=
 =?us-ascii?Q?CR44dYUmi4JBtvxeGqdGfJ2BXNsvzLtKf7F2aPFZ5FvVEPE610PLviMBEC4o?=
 =?us-ascii?Q?iTfr7BS9JOL7ejolv/fh9scMshpKlzjZQg/o8kRTcB1hU2ygUuJV14Lv8rny?=
 =?us-ascii?Q?dO1gHbocBrSlIcPX8JRFOfu2hetIMPUczzrCYE2whBUjpFeYdDzBvERl5VH+?=
 =?us-ascii?Q?KGTu8XoDJSTL7an0fsoA8D7lXoucazIDwerRkV4oNvAKSKF/D4EpVXjG6x3V?=
 =?us-ascii?Q?cHCmrseR8SLU7uumpKf+j/Bl4xYJxwcTfxJBmRcPRLoO+Lnus2V48S8GrXYm?=
 =?us-ascii?Q?x/D14QMZm1Uag01xfPrRw/CC4AYG72gD15Z0mko63yTgGK2xhdEAKhHIUBqR?=
 =?us-ascii?Q?gguBx7EMynK1PmqNSPSNNTt7T5cFwEwkD/2ajZm8INUmum0poaI2SNagTXPG?=
 =?us-ascii?Q?AKk6ibd501/A8kUmYRI7QTKFqNTXBOkTmbd1S/fK9bGd7ccUvmR9AVZYpbQ4?=
 =?us-ascii?Q?Ck8qQy6+eQv7llnpomhgjfZTBOdnrf8RD2tnUC5zVmRzphSs9BJH9hHoz1gT?=
 =?us-ascii?Q?Tqr9lTJlcakqDxSCc6J+/G0Yr9Npx4rz2qc/FD30XBiM4eQ9dve1fv8Wukmz?=
 =?us-ascii?Q?XdEriyP9XRYFXg5/yd5fmQxgN+bY7B4gy3DdUq+alaOm1WlnFtR7BwoSurg2?=
 =?us-ascii?Q?EcQDvuYd/UP/c2j/q8mMjZZEox043L8UYOjFvKy9vhJ2DAlY3086HT3UZpby?=
 =?us-ascii?Q?a0WzqURfK1HVaV0L58xOkeb4nw8dLzTbttiAgCE3RKOeRePLzPbl1mMEqmqS?=
 =?us-ascii?Q?vewK6yQ8GV5ICSKt9jAhXSXZ4YNdpxsm2LhcqqRWNJaJBS1gxEu3gTPu3AnZ?=
 =?us-ascii?Q?b62m3/nEfgifzSrQ/L7h/61xpecPCibixFqKjC02xGg12osO0BKvgDZoB+v/?=
 =?us-ascii?Q?DYa2WU/Y/TE+5f2xTiDTXFQo/82LOILnUI4T16ACXgP3gpYaPZpgtwbqzUuW?=
 =?us-ascii?Q?A1S7CiaDQNdN56GUv4k+ArdSfAyuAJMOtB6ZR+NyBZdMM5s5mH7yEwp/egLC?=
 =?us-ascii?Q?XWQ/CL7SE6wZY9kpUFAFQSVIrw2EIVZxnKQkAu0YYwbIutK4StXoEQ5PnTsM?=
 =?us-ascii?Q?XpsNUNb3QY1uQizp+Uxrs/NgOrFIF2gylW+Ey0Dg8ADo1b7fbVTtpmMIvXjK?=
 =?us-ascii?Q?L9bbpR6MQmODnl7+7DcVcBkm2mivGLuJb5DliDgC/cRw0yFQ0TqJ+WVge0Qg?=
 =?us-ascii?Q?1EOyYZShd0nPsJ78gyMKAm/do5bNq27ndA/UrBqbNUJJa6ksD4SuZkexCcA9?=
 =?us-ascii?Q?6M0JdbSWjl/A7CMYXMrLB5HatuyQwutUTXTke/DJQrB/H6VVdbuiH6rKeoAA?=
 =?us-ascii?Q?KB0KwAGxjT7vrjAFTlo=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d2055ec-166a-4f82-ef41-08dc27261857
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2024 15:12:55.1734
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g8falV3Q6phKjcCIfiJ0aWbmZuhM2PbyHLawDXhrZs+quJmaCLrTuC1Uyh0ANOaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB9056

Using the same design as the IDENTITY domain install an
STRTAB_STE_0_CFG_ABORT STE.

Reviewed-by: Michael Shavit <mshavit@google.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Moritz Fischer <moritzf@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index a940b5ff96843c..9271f3a035b5b8 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2727,6 +2727,24 @@ static struct iommu_domain arm_smmu_identity_domain = {
 	.ops = &arm_smmu_identity_ops,
 };
 
+static int arm_smmu_attach_dev_blocked(struct iommu_domain *domain,
+					struct device *dev)
+{
+	struct arm_smmu_ste ste;
+
+	arm_smmu_make_abort_ste(&ste);
+	return arm_smmu_attach_dev_ste(dev, &ste);
+}
+
+static const struct iommu_domain_ops arm_smmu_blocked_ops = {
+	.attach_dev = arm_smmu_attach_dev_blocked,
+};
+
+static struct iommu_domain arm_smmu_blocked_domain = {
+	.type = IOMMU_DOMAIN_BLOCKED,
+	.ops = &arm_smmu_blocked_ops,
+};
+
 static int arm_smmu_map_pages(struct iommu_domain *domain, unsigned long iova,
 			      phys_addr_t paddr, size_t pgsize, size_t pgcount,
 			      int prot, gfp_t gfp, size_t *mapped)
@@ -3117,6 +3135,7 @@ static void arm_smmu_remove_dev_pasid(struct device *dev, ioasid_t pasid)
 
 static struct iommu_ops arm_smmu_ops = {
 	.identity_domain	= &arm_smmu_identity_domain,
+	.blocked_domain		= &arm_smmu_blocked_domain,
 	.capable		= arm_smmu_capable,
 	.domain_alloc		= arm_smmu_domain_alloc,
 	.probe_device		= arm_smmu_probe_device,
-- 
2.43.0

