Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E09718EAF;
	Thu, 25 Jan 2024 23:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706227058; cv=fail; b=Uj2gGFIto9Zm4a9o30CgHlA5RYAvAUi8pF49auesSr39zbtfHNjl4QLX5YFQzq+PDFj6byJlfq+nDnPvuFLTzfXUWrI2eY7wHO3pjx3M0nMULVuYFhs4wclq1t4L1yuAyQeT9kJgFjU4SYvRrDJV173cPVk/s2/SmI3WIop+B1w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706227058; c=relaxed/simple;
	bh=iU1wIQHA9oR2YUofyHGEh55932cfUOZDJpZsNPYruz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=USeCEQA3WhQXgMsz5twcf32UHt96dAxzHo9vrcVKit6xtzL/A2wBTaQEm/RGO2tiTALkblPA1G2EO09Zmret16diGqHYiJ3Q0MWc1YXaKj2ydHY2eVYHOglgR++LbvlScyM9ndNqxr1qW3UcaFHsPcmKsH6bwj7UFEgaYJpNGK0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=oesfzA1j; arc=fail smtp.client-ip=40.107.236.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="oesfzA1j"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nxpcB+XbUgsWLjKWlYIYDGrx3cbyeeX0jWr1agn9KB/yiv3F/CVzdrHkx7U0dXri8Iia4GCgCtU2Lj19pDWc1r18JBVTpaAFtkP0nIH4cx2sioxrW88J5JyywxLomdwVpMk6t5zlqhNh1cXKpqfvBKbX8+P5JMEaftY0VweVz9BuC1eEiGztsUIlMu+rkFWt4Qk2l2o2I14Q2h7iMpPetUGLl6VJIMHlzmODqVCs5Wx1yszqkixoV/F9zn+h7WgtCN+TTlIeJNTE1N8Or2qmZY+p2h/MShMR1U5EPKXnpn8GY5i2qG/HwJkllb8438pexFG3ftll/9i2e5hvjdbogQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=anlqyL/gBdlqrW8QW8ZJOtrF9u/+OhbwSx5t9+yl6cg=;
 b=DraLtI/7cIIAGWJru2uL07rspE6O9RCfmZ95ntt6m8yHJDY7vESBdVVMOsdXD2uc0r2HWlZjvud+vvJaEsnpl8w2+9+CzxfcNsbf55wr7YodyNfZhcrlKvPc4ORdc29zMMQWVaAZcIJLG1GKqAN1sS0ejM3giFqDRC2INJGFGUz01PVd4vSn1R/lAvimyI86Ib4bm64hwdtB4VClhs+JWPL8Tq4Pn2CGN0NvXpBNPZzngTipfPJHQ87BPW9k6zqReT23bh3F4j/MtCXuzoU8JwtfGmQcboSr7rhN438uFlDWMsnF02mUTvabmmxDlZ2NfrsueY6B/6027/h9ezVCzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=anlqyL/gBdlqrW8QW8ZJOtrF9u/+OhbwSx5t9+yl6cg=;
 b=oesfzA1jJpFSOCFSXBM9dKLdvPVyLQEjdKWHH8U3c21dB/G8oxvTJBHWkEv8snGZMygO91/0qBxMHeUL5pjC4PPMH2A+E2ybJro5Xvvz0T8WpaRoT+YGAcsmfHC/GUtXTK9d6hvOUN70NkJId/l3zAFfA/WLJnvcpqolqk36t7nKWDVypT+Ap9Ah6bDcHm5TuuhHiL0cleaQMI/Xl4C3ech84nvmUak9xboDHZjZUOCI59dg2cV2lIE0eAuRZdi1AzTsnT6i+72K6fgKpKketlMd4Z+XpdVEE3GcqJUx6jgL5B0ZiEmwo7Uz5+LinBk61c6FyWPhvcgNNZ0M+Jp61A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA1PR12MB7038.namprd12.prod.outlook.com (2603:10b6:806:24d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.22; Thu, 25 Jan
 2024 23:57:29 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7228.022; Thu, 25 Jan 2024
 23:57:29 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH v4 10/16] iommu/arm-smmu-v3: Pass smmu_domain to arm_enable/disable_ats()
Date: Thu, 25 Jan 2024 19:57:20 -0400
Message-ID: <10-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>
In-Reply-To: <0-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN7PR04CA0002.namprd04.prod.outlook.com
 (2603:10b6:806:f2::7) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA1PR12MB7038:EE_
X-MS-Office365-Filtering-Correlation-Id: fc9e6fed-180e-424a-709e-08dc1e0162e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	l1wDlnF+LYVGrbJJrwp5XFfkjfAPJkazmMdrPXvuSQE9QNnPVfInfddLp/eyQuLfpkAzu02ZcA5aAyKnvy1hqFb8Jdmf+2eNqxOG1DZU/mamY5+emeyNLjMFHuIXEFFPU58CQ3fF6se8nCHa5bkl9F/ckfChnO/7OSJX/rUGKSA3qX1FpJ+qa69PW7uhWqNPIr+pACMJZ/Qj4jeUcPCqzva5LkE8wFqmJ5uOxKiqI3vSpr9c1WIO29KSCpLjbwzb4l/3wrAG8SQzs2HpvzSShL75ogXDfCEgd6kmLK/QBik8+s1AA8K3TWWXLkPhlzZhOT0tLAAQCeGwFtrFOkLBkIiZ55iX5B9ozteuO5zgHiUP52XuoHnT0LWYC0KD+l3XlWeiz1AszsoCIaJPw5V2kctoGrd0LkmQFPBX/PwoPLRtfCSApys1iJsXMRlsWKxg1SZhUHPkcseZ2aBT+XHKirK3PLyg2zqEp5vq2S/zId4dPBuqWWLKGodHUQW5IaXJyG7+uQ553UXF7fbh0I/40Fs1Ti7KlPQf5S64Kt+vYTvqTJSB+TOnngSDVKxeOwvs
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(39860400002)(136003)(396003)(366004)(230922051799003)(451199024)(64100799003)(1800799012)(186009)(66556008)(54906003)(66476007)(5660300002)(316002)(66946007)(8676002)(26005)(6666004)(4326008)(8936002)(2616005)(110136005)(7416002)(6512007)(83380400001)(2906002)(6506007)(478600001)(86362001)(36756003)(41300700001)(38100700002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RD2O8+f0H7ZBLIYmRUFEXj/xYz/yfLqHSofj8V1p5+E2smTuCB0+qHfkd5JQ?=
 =?us-ascii?Q?a3CkZoti0vEAsTdWWzZn+5z5IYiFnVQPvmrecs91v4Y96BDMuichrAQ4YW+E?=
 =?us-ascii?Q?i2jg6q7FHH2jcVDP3UDuQcU4/Cxckklo1geJHodRlxZVty5T1lpCE28NNYUD?=
 =?us-ascii?Q?UKOP+aNJEljZuBZ1SiepMMMH97zBSuuHH4ylMuX2+imlwfNbx7H7yHh5fD1j?=
 =?us-ascii?Q?rlBGVhiyWmBXmrd9sLSNJPEtGZNCs4gF9hFL+RVnFtHpMf9wjcALP2iGk7/1?=
 =?us-ascii?Q?b1htWGOyz1VmpvUa9+S0kaHniuM4R1pDOFPKyC7hIE9umWFr/cYR/Ebi3bdK?=
 =?us-ascii?Q?53FSaECs3bdUuBXpJJQ5XnnBZyjnh52VbWFVDcyZDLqZCCwQF++IXM1vzr+H?=
 =?us-ascii?Q?u778o0hEAmWeiy0aq1s+DCzGO/j/2s+djAqdpgrjwm4nI+6nQ4605r2gSJk8?=
 =?us-ascii?Q?2xKmBdKUrbZwNWc5MfZFR8yfZXSSFkHSrDfRfN4KqfZrgVG8Cm/RB2ezq+fO?=
 =?us-ascii?Q?KyVo7keO7LDZNkHt9UAxCAxKAxW2sRGObdz3UWGUvyjw4dID0nrpFazr88MG?=
 =?us-ascii?Q?/P8dKaj8vnyr3V1A4kvg/6x9P+UObOy5WwWPZns06moFle1YETm9afZ0xIEp?=
 =?us-ascii?Q?fKXsG2u8zOCvGfThXKvQ+G2nTvfBiYB3+/0MdvWBwJCGKhHIB9OLlib2wB0f?=
 =?us-ascii?Q?bTuzXeye5E3jWEkfGllDzKwnFjFGIuGBKFsBxmKBcnjNbufOXxcdj+g2X4Ak?=
 =?us-ascii?Q?QSSukPA4DsBiag3iEOGZpBJG9rFIbCXoNoz7avwKF6HaKoCFi9kvWrC/Seui?=
 =?us-ascii?Q?632vdlvoaH+pgEKDCvvbOABhjXjZYiP4QxWxuFFGBhLbT9KbsMJzy+AdJ0ma?=
 =?us-ascii?Q?QR03EqTK7w0hjo8yHSInRwCijifgOTMfNoA1V9fMOJxhvl4M/32gDqzHlWEE?=
 =?us-ascii?Q?Q3f0lZRLbcugCkn8ny+sGGVvsvw+OduLbHS/Kzmc5ja7Xuu5jbzLCYYMwBnb?=
 =?us-ascii?Q?8yyzrGs2+OcLNAMycwnpWinIqvspGMgedRsswi97R4tDdKK10qcAqXaB0xRD?=
 =?us-ascii?Q?9lHgUgMlI7yYZf9PNXUM+9vKsogtT09ux5BMU7L2EqRzjShgdhNhO28WMxY4?=
 =?us-ascii?Q?mbwqzY4XuvtmmFi3B6hye4mKPHfzCDOQ6sYkrxqLOTB4JmF9CgHXEi83mA/t?=
 =?us-ascii?Q?kcepLkwzsemVgQ3k8xf4Pu3QNflwgwPvXY1R8oH4E9iSRR9Vsdml4Q7GOsNk?=
 =?us-ascii?Q?XUWTmfcBRofpAGuyBD4SpAFOfrgCqHbG0UpEzYXSudVNnY2agl6nWep9tYgY?=
 =?us-ascii?Q?/RJmY0TfYGMEKjCF7GHfs3lwJORUPHAufhZbDOjepzgT9O0T+ir6p3RSlhJO?=
 =?us-ascii?Q?8BkgOrsV1qa+jGa7qunAhwzXrbaYItyKwiD864XLYzUH1ShgFeatRL+QgcY5?=
 =?us-ascii?Q?tc+DOWFgjG4LVsUGkOgRfABFsoG60K/kv0oFK1x8Lq8XwR0QMHRDxgcUzYnk?=
 =?us-ascii?Q?xhdGIbQIA7SgMbie0c1YhZaz3798yWfPHXahhTMLFCQkCwvzHFwcuJI+DTXM?=
 =?us-ascii?Q?HbqguU8Vp8ORIjWTOOwaYvzSV0ITjzd2rjBUZbs5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc9e6fed-180e-424a-709e-08dc1e0162e2
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2024 23:57:28.3646
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uiqFmpBjbSNCpJjlpDEBJ9HsAXLv+v5kS2KLkstR//UraWxkfPcmVcw8fJ2e2EzN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7038

The caller already has the domain, just pass it in. A following patch will
remove master->domain.

Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Moritz Fischer <moritzf@google.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 09b40ba35a9cee..d7b0cea140f12b 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2447,12 +2447,12 @@ static bool arm_smmu_ats_supported(struct arm_smmu_master *master)
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
@@ -2468,10 +2468,9 @@ static void arm_smmu_enable_ats(struct arm_smmu_master *master)
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
 
@@ -2540,7 +2539,7 @@ static void arm_smmu_detach_dev(struct arm_smmu_master *master)
 	if (!smmu_domain)
 		return;
 
-	arm_smmu_disable_ats(master);
+	arm_smmu_disable_ats(master, smmu_domain);
 
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
 	list_del(&master->domain_head);
@@ -2662,7 +2661,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 		break;
 	}
 
-	arm_smmu_enable_ats(master);
+	arm_smmu_enable_ats(master, smmu_domain);
 	goto out_unlock;
 
 out_list_del:
-- 
2.43.0

