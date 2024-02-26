Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2059.outbound.protection.outlook.com [40.107.96.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37E3512FB0B;
	Mon, 26 Feb 2024 17:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708967266; cv=fail; b=g9MZf7NHojf35vCkhBfPecD70YHmUsNXiPcbnaNWXvxPurAZYZnsUUlfSoYTEMx5WrqajAEENawS8IrkD4G4uEz04dMtUAU+5WiHNblbNrS91/A5EQJCyauEZ5EPbNvCqbONMrXq4rx5jp+To9ChoSURqm4Un0iSANoIjxXgUAQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708967266; c=relaxed/simple;
	bh=ewA4/dtqgLOp+ygySjdR+rDw87K+P9cs9Bkmu29JMyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=iRaNp1f43Rkz67xEnXl+Gk32tZUFsDacvdFp8uyLRqcfQ3UZT4tTVPX3r3cDNk1Soo9rmkbORYa7xBIzZIvvZFiuI3edOSrtFRIXlKAU2Tcn/rwDSGJ53zsD7jKdQxD8+VaSLuwksZwth6t/0I18/Q1FsZqyWkeGq7goYuyv+YE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Hvkxi6R3; arc=fail smtp.client-ip=40.107.96.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Hvkxi6R3"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fHChGi3sig2HHhuCcilpBGN3gtfJUWo1B7aYMWOykIZ5mZGi3wJH0itisT4J/7hqLFIC1YZqzrOFcFd7M6LbGG6E4XsloOztDsI0AwpZlxipIYB7xlTD3nBiSmV4LSpsJanpetuB3ih0Ru+i+6NgBbqikrK8dghX3Q5KipOboA4yifxAnhO1iQIFnGmoeo3PQydZ7ZNNDCDTNjxRp+OjD/ExU/d/xZgIlvXxzIwJe4NK3USDmTFOgnBQ2AoGL8sJQ/XvyFt9b1BuR8FuWveq9TNb3C0LWT5L/eeu8XOH3Ij/wdkd3b0IW+/OcIIQf6qRuRKZyFPi61yJrfNnUNflKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f+ji+QP2aCOzwqj6NjqZb3JKTosomI5nRxnuWErOoDo=;
 b=NutIQ5yEnqri6lrywWh9PEmioWx0hv3vb3L4SWSqfzAiPW7ep6v5CqaUzWlYoAW23yw5wYXv3vXJWNhuumUyFfAPuH+ZsEQWyRUNvuzfh0aCwy7XKJm/FF3JNSqJxLF3d4CFHrGgO0nANcxGPSuQXF9qvC/Tvf0wpt0vufUrCZSuwEL2fzMm6Sr3g+g1dqWfoc/+jaV4i5BAMp0W4sh8hmJr7NswzhxToZPZOdeccWXp090bLj1HeMOfs2pfKzWqTbb8UmZKkNgfp2ozurFhs9X8Kp9Z8SrMdTidnN+6g/hFt1p4TL9TFI8abJ9/+Eo6Hea/vfHKTm9tYAkwyGbTXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f+ji+QP2aCOzwqj6NjqZb3JKTosomI5nRxnuWErOoDo=;
 b=Hvkxi6R3V2R5fxrweFY4PmYInualU5J0ycbDkF0S2jAciHT238IrwMCXuiqhz6GXApyZ9n8I5ZcIC4XVBnIHmHFuNTo534JSq1ofsE1NOXKbocRRRIvGmctJSgVdfGyOD/jh+7hJUzs5uBYp/KqiHdjL/g8ZLr3qvbBFfMXiFGGyAl/uoWbeVpwEzHuVlvUoq3ZK85/0swBGHYrU8r9PZjb/RRXVDUXcLjRWAvP1GCK6yL8UrkIUWPAuJWU7mYATQVpgQCkI0ZK9RomA479vczIk4/f3WPv+Hf/RsLYxG2hhksUnkuvhAkjF088nsGOty1ESdbtn/w2/jeFY75Dvbg==
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
Subject: [PATCH v6 13/16] iommu/arm-smmu-v3: Add a global static BLOCKED domain
Date: Mon, 26 Feb 2024 13:07:24 -0400
Message-ID: <13-v6-96275f25c39d+2d4-smmuv3_newapi_p1_jgg@nvidia.com>
In-Reply-To: <0-v6-96275f25c39d+2d4-smmuv3_newapi_p1_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR1501CA0009.namprd15.prod.outlook.com
 (2603:10b6:207:17::22) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|PH7PR12MB6905:EE_
X-MS-Office365-Filtering-Correlation-Id: 3aaa5234-2963-41ca-9eab-08dc36ed6a9b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Nf5MDYKpUMsOGcDFXPGWeTB2jvpp0FKBNsTN7fU8eMksjqQGmDP/f6UzhCNVUdg7ir/VU2gzu7o/qXJOQ2P27C6Le8UBp+lBaVaDZFlGLzYgHELq1C77m5qZL/i0Qsrcu3dgxSR/ACIBWbXYwpEntGE9CRALiqOlR08QVNULWfyJrkbjk2Xg7kVhwgJsrAo/RgrVgGCt6+4FFQdQ/OWyLicQqJNJqnvHMfCXm9Q3q2tog3G9qnukbLoPdR2c3M+43ejJIioL0guvS1ao1+0CSmCnHqw4c7TKk/RkB/sHyl6zwMWhNtyHPU6/hg89nGw6hSBUeer5e9OsWaUIW7mB9buyLgOvmB2fF2MNmeUuavZKkFV/UvQYM2RZPy402sKcc6XkZQXiHm6Q+0sNDA3Tsyf2yrUz3iLp56Lcdo/24ZyYlbOtedDOE02pFe/D4DlggHJuOYKhJsfMK0YYzNZ675UAVTWEkfQWGmwjJmLLvpaemVIoWkAjFK2EMsVGTzBAuBM3Q/1/XdeZPbRroVinsRd8ym3IFZ1jPorxHS+gW2K5BGjbV2f1hiMLZH+OKi2f7WQO/gKjcizVargu8qXXAf3rut8ZwhQu6CdyeHyQ40sYivuw7sbkBIs1VrHalq4zcafnns+p/aLfeSuL2NKzsw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?a/uh11+OBR+lHLT776t6J9jBCU/sMdYxNKKV3S+OOQunHcfYfXQAD7Akb6O2?=
 =?us-ascii?Q?UuJKTrTq1k9nDjBZ/vNukLoMY+pq4zzpzxW5lIdOxA1AXsczW9AsfxdUPZQG?=
 =?us-ascii?Q?N9lzpR82hKIb++ZH77h4ywclxlMS9MvhbPXWM4i4XSxn/EhT0ILW4WfROH/M?=
 =?us-ascii?Q?0n6/Byo19Xtlc+GNdDaWbx6QGr+6o0dTCQzMssMfbnnCq6w5s6qtKTksE88V?=
 =?us-ascii?Q?S17iC2VV8TqwshsZ4eWWJHqBc4S7HBp0caRCbgioxy7eigYjNmN+TVAjWaIp?=
 =?us-ascii?Q?K1sSKKc5N03+UQxYnms5BZ8/0JytgQhT0nssvCYfou/oBdiiDs0eZuMk/zYC?=
 =?us-ascii?Q?rlMh+5OyEyGUYYtt7mMsqjkj9ZDegrPJOw4xX94A9ovVP5sJliXmpu0C0jxm?=
 =?us-ascii?Q?Zpe0T4yuTMKuwxCIXjcQerwrQKzHaN84hWJFPriw1ZCEcm5vfRJ+/Rdhll/x?=
 =?us-ascii?Q?zPDx9xNh/ZWd+NfEvLLlWPBJ0w7jjNsgl5bHtrugBGfMhmgfw6nCiiA7YGvV?=
 =?us-ascii?Q?OSrW8Qgw1N2WDH25w15ZnN9zsnk8CBMD4gCw4ogwGjo5yIyKCghetuJa22ed?=
 =?us-ascii?Q?HpNkcB5G4Gz8GixH0QGQ+2s6b/Xg2vFCeq8OrJdjz5JT6jCbMznJlLnF6Yep?=
 =?us-ascii?Q?bG40+Qg2yMj5V/0uOw0SSzV7Cb3UAVKygz7GoPb5b0rSVvRynJ6zVw0AUwEp?=
 =?us-ascii?Q?QMLrK6uyd7NZ7NEbwY6V0MakwtQxGDFx2RAbe+1dnVcySPBLMAIDJkpweO5F?=
 =?us-ascii?Q?FKfcmAlC7ZmyZ+mpN/m1XJD9sEJ5eNkPCKI9fq6ge8YxhawQ45r9vh4G9Zoa?=
 =?us-ascii?Q?NOqQV9mkW/jcDNsilxQJfVXF117LpI4sPPfuTpScbh5cQ9RsULduhzuyBu5w?=
 =?us-ascii?Q?13GelvMUpruksuDYArTziPr8uUbewcl7EnKcYvCeuo6R+907eVazR2r9EXkH?=
 =?us-ascii?Q?cB35UxwihG8ebDwZ3JEoRgo9oNbVyByiVoDABzcETudLq9/dVcLxivUdXfcx?=
 =?us-ascii?Q?09Rf9MjyahyDlnW1C6gIa/ZGQ8spDtyIgF1kFm35VvVKRKKSTrJeQcT9mapJ?=
 =?us-ascii?Q?Ob6cMWNDURsqhjHAfCAbqYT5dYqUvPnyMVHMZOg48mSYhDzevKp6ACXiTzkD?=
 =?us-ascii?Q?3Hma89OoookOtRMDx3FimmgyzXrvsTlF/9MqUSF9PHd0Q71KDIHU4Efp4rqy?=
 =?us-ascii?Q?IaPmh/9AHqXRKWzBQ2mKzhpiOWxiblBoeE/no+xj1nE7UfNSD5ifvWyUwtqF?=
 =?us-ascii?Q?rLtuVIqsiqhodfk9XZMVMjAQt4uKC7Hfkpc5Llns/WPdRDnuTvVebI4ZoTrG?=
 =?us-ascii?Q?wU5iXYMF6XrQ3UpRmdkEdwbPJ2XZqAj8NCuoDgydv1PdVQAIg7LKWLz4Kno/?=
 =?us-ascii?Q?Njg0zf7xzBiuYtTt3X1d6lT1wZHZn2VSHKRdtfCxFxYKiGAsJQ7H0FbBRkRn?=
 =?us-ascii?Q?G7cpqguONopdllPTkryGD92slx+mVFj3KJiFN00zNi4xxG9GKeD6H2jKmvcX?=
 =?us-ascii?Q?AKChFbhMrbBAqiUYMY1TihUutHeJNLiry/P6u64aEwt/qAI7kgdSWy9u8oYq?=
 =?us-ascii?Q?+Ntxexcs4OtQCSdCJ135uWJpsM20w8mrjs0r0i9P?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3aaa5234-2963-41ca-9eab-08dc36ed6a9b
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2024 17:07:30.4434
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gElgIMJ0vOKk75KoKxOLMI9PvqhUgkS5wSHeTy9rnfZWoPJKGCOqEpo+eIPB7IUN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6905

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
index 842ff8a95baa12..baec827e6ae446 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2674,6 +2674,24 @@ static struct iommu_domain arm_smmu_identity_domain = {
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
@@ -3064,6 +3082,7 @@ static void arm_smmu_remove_dev_pasid(struct device *dev, ioasid_t pasid)
 
 static struct iommu_ops arm_smmu_ops = {
 	.identity_domain	= &arm_smmu_identity_domain,
+	.blocked_domain		= &arm_smmu_blocked_domain,
 	.capable		= arm_smmu_capable,
 	.domain_alloc		= arm_smmu_domain_alloc,
 	.probe_device		= arm_smmu_probe_device,
-- 
2.43.2

