Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2081.outbound.protection.outlook.com [40.107.94.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85CA61B267;
	Wed,  3 Jan 2024 15:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ECum1qaZ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UQtycOxwCgnYuFvoJEAt1bXDk0UZXDS1rhJke6xuGkIPj4cHloV9cio7I75i5SkYq+5UPmBp0vlEpOZY8pqQ9Y4n70k1gLznCNro+2xgIqqHSqIYwQhVZs0d2N+BHzV1s78Vf+vK2E1sNBeprR22s0xHdE0Bm2PA0FW3V7fq1MUtJwrvGGnzfbLYDzMsL8iZcGovr/Q7JNQ7GDHtEeQ7k//fO2Kb4RXeigBSM89xSHNbvkunmfcxqMyohbq5hPIppDuxl3sgzfyLFDHfZWMx+ggMMSZY8Y5Wtu+eLfkSuLyMGZSFwXIAVHreNsh0YsrXE5PePU5zJ18KaQg93+Ki1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C0cme/QXy+M6frlbqDecVwzFYCjwSCmhWuDO4cauMZg=;
 b=MxApw4M7Gz6yChs/JmDOoAVxSI9fE2AmAcscgr2QedExbZvzR/BDxpzwOv1qfyijp8NF91ehncdL3a5DMOKxXZk5Te18l7BqFm0FIWsR8TklbLrqxGa3iPlbYTCR96TaupYU527rbIWgZwvp48rH0g3R5MhUe9knM5E1JVnH8TPNgEidWqZIlM0KuWZsOY7/2+tAtnK8BSRYjwDXtpPp0kV6HHJ8lDoVlJc6ryVnuZ3nx1AyoMr6UsPuRm3zg1AOmbt23XrFtZwre9NgFdNb2Lqop82E9i6Xdj1C8VoGlvB19H1PC55lSV9DFHfoBWYhybQtk5viJuw04F1OKROabg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C0cme/QXy+M6frlbqDecVwzFYCjwSCmhWuDO4cauMZg=;
 b=ECum1qaZQqPdxnvEOdpx2JnvXs2e8x0NWeN42kEokOET01VbwNHBlaRxQwe9GEDdbYNwVy/KtJZ8NA/Ql9BSuXAckcOpvjsHYl4Y6j6mm7qZskYtczu2MQoCYrUaqgXlnBiaKZmyTJmbYOnkw+VMcRA63lMyVePYxllaA6wtWC3JU86quYJW3lTWCmAOwMQYU5jw4geNf7JDKgO+GotBYc1gFL1q9bpozbUJRhL0vOWhPX94BtBKWZoXsivbS1k7OskAZUOemI49vzuRqjFIaZU1ThbbgfumcsOdLD4zVhpYP3AYomLFWv1SwvXW1440DdC9dBJocJThHjn+REFNPQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CH2PR12MB4873.namprd12.prod.outlook.com (2603:10b6:610:63::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7159.13; Wed, 3 Jan
 2024 15:27:23 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7135.023; Wed, 3 Jan 2024
 15:27:23 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Kevin Tian <kevin.tian@intel.com>,
	Will Deacon <will@kernel.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <jroedel@suse.de>,
	Jerry Snitselaar <jsnitsel@redhat.com>,
	patches@lists.linux.dev,
	Robin Murphy <robin.murphy@arm.com>
Subject: [PATCH] iommufd/selftest: Check the bus type during probe
Date: Wed,  3 Jan 2024 11:27:22 -0400
Message-ID: <0-v1-82d59f7eab8c+40c-iommufd_mock_bus_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0272.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::7) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CH2PR12MB4873:EE_
X-MS-Office365-Filtering-Correlation-Id: d9e7fd46-4e4d-498a-79ea-08dc0c707be0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	h+xBbTt1Z6chqInCKT6K9V1P+ZxchMCFaBbr7Tw7HkWiaceWcAYr5gJfYV1rbQMexzgXd8kRfpY2RnUfuJTLCjTVqDbGrGHr68Mhb3TCLiNEC9o1WmK5B+VyhlCdF2nYNgZkfFF28spJdnkfehbXDLX5KSqwxMbIQGbcLExqbcdp2qxcwQ5hsGTsLxmRI0j1lyaYUkoAjNFBxg//3G0EmKHEVoqAtPiNA6JKu+0TVA+IRpWcoiLlXYnqN7QTpFj8jSk0iCIG/c0e1ilyduuYuPIDQnU5lqES7VV4uNadtZywU1G1sZJy2GqasoKApukYEFZHbPoq0xgEjEPeieO9h+yJuUhUDSg2ZlLM2hZWmw1eFC7USK1q8pfbTeD5Vfhz1QK55B/uJMuFvs+w0R13mXGxFh54RJDz3cIwkM+F+PCVWIBMJnndezs1Yqa1FMIa2rKOzplWD/Mp3wESybQAZfvFRHG7J2S4xGMqG9XQEdS2vBwijKRCHuuQfNuogll7PDXQ5zV0mz1jnfrWscAWj8Pg1/Jq0ZX5ggHBMef9fIK6VeaWKNk6y6flNBA/+3tpK5TCcZcIHOoml+f/pRPclwLCcrtHYXnCqGto4eEHMlM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(396003)(366004)(136003)(346002)(376002)(230922051799003)(1800799012)(451199024)(64100799003)(186009)(86362001)(36756003)(6486002)(6506007)(478600001)(66946007)(66556008)(66476007)(110136005)(316002)(54906003)(26005)(6512007)(2616005)(4326008)(2906002)(5660300002)(8936002)(8676002)(38100700002)(83380400001)(41300700001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?v0d5VTlBhQGxljp//rZRftfXaJ/jw7augwv+zxDZqgBf7bQk0P9pwu3zXofn?=
 =?us-ascii?Q?CkhrU/xo5e8nOeAT7+j8kPDSOuCee/f/K1vnAnp2hNg5RW/F5iMHak+dTxCp?=
 =?us-ascii?Q?Gz/a62ptFBS7iZUyOrUTuoqFVPV1R0JFxNrHW9tMicYk3NlpA3rTu8EWW48F?=
 =?us-ascii?Q?DTfvWBj3XC5uPcChDmSlfkaeDZ6qU0W/snMGM0RJm+41cjQm3JUuNmqfoxZd?=
 =?us-ascii?Q?q6J0esyGOPYJttHCAi0SbCg4Z/VtmdIONKd4scaRyn5604fJtkruMYwuBMDP?=
 =?us-ascii?Q?BZYf+HFdhfka2Mn72/DZl5ovXDXpgDQlZdyx6xVYbe0fabX7ixwzRpvSZ41t?=
 =?us-ascii?Q?EsqN5fc2Xd+lZgcTGSn+88anK6hpOR5zuqHKnyvyrFUmfuyIlzOsr1iuBEZt?=
 =?us-ascii?Q?RswRAi2aIHQzc8n01U3VXowV7+q8Ok02lSbXhDTEqV7ejj8zTKhF8fMtE8ou?=
 =?us-ascii?Q?8orH/uMwky5qVlEPL3BdFtwjWnig+IIiWPbZLII8WH5Q8HoHE/Ulwy5bnCm5?=
 =?us-ascii?Q?Ur9c9hDUBOv8BbaGJhELaRlLbGBcXUA7RhqSnXhrgmYj4mPGYnn+vWE953Om?=
 =?us-ascii?Q?DlEhe+q1MKZT4bduACJmS1gbU8Jd3lW4BzT6/F5Hx0J2lyh+jAITxbJm5Y3i?=
 =?us-ascii?Q?EB2/8t6PoNGQnlrJ7hIKg6SOpiY1XKVbRBTJFtuFhajF1RMLQXt+tdX+pXQ/?=
 =?us-ascii?Q?7W3sJxqJeVzoMIapem0vKxu7TsRzp3c+IQ6S6bGZzscxoh8Q9KFyzRfpsufw?=
 =?us-ascii?Q?rgJgjvif5BqXOc8pQGFYmF/0gJK2xeD50Sw745vjGHeso3zqvYsnWRYOEwL5?=
 =?us-ascii?Q?AqeEeVChrvzfM6IPumETR3znLiZKNFWIC+sz+9ygsflsbAatGWvrm6YnaUi1?=
 =?us-ascii?Q?mEzRpjMo8K5hPy9RIWgCvkkF1GEwOCkpFSmd+LvqHbC7ETVVcPlOkyTe/TIT?=
 =?us-ascii?Q?nqm5hJ0nVTRlY8YARVHx6xcQ/5cOsFOOFs5CTu/FZhLuppEdTmjxemSDodQu?=
 =?us-ascii?Q?Aom3sgL/bFF22QgEOIalwAjMY9LRfukizj4KChRlnChMsiwijZ2G8cK3Dw8Q?=
 =?us-ascii?Q?7E7CRrPIBMuybAnXGJoaF/ymu5nY1P40fYnaawNJAAXtGZBmayuzu/0rdvYX?=
 =?us-ascii?Q?8FfmDOpZitXjhA44YUwF2OSBcWO1NpDpDgVqgB6SPReQKg4RCyg8ZvlPTGvN?=
 =?us-ascii?Q?HQI1iGo54Cg6kM9Tu+CgF+Gz0yBd+lYZc0V+f3DPDfAESpiFLCWkLDehhF6S?=
 =?us-ascii?Q?fpB19mdGZZ/e+AFXp0P7oWHyhaYcqEtmIO2ysxXv2exOdzdB+fC2kBi82D/T?=
 =?us-ascii?Q?OWVmtMnCi9+0UEKa6x8iraQdxGH1YzQIMfl+af2hasXz1h8iaqGFIFSWccRb?=
 =?us-ascii?Q?1XWKQPdt9EOCvBx7KK5Eg3PhHWDS+Hh3BaRgVD/eOqy0qFTEegPIZRRF83g4?=
 =?us-ascii?Q?SG7fXtqcOnhNx8wuBBqZIz/CXoOkpThL4w+6JwmYfBP04FkEf2G5Tncnt9ti?=
 =?us-ascii?Q?hBc7TI8iVDCst9zj5wYNwvS/4wb384Sam0objAiLmUdL9ht/jrNU4h0Phr5p?=
 =?us-ascii?Q?6VOSJ2KQKfVCBXLXSq4l+WzOMemikYICzU0r5Ofd?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9e7fd46-4e4d-498a-79ea-08dc0c707be0
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jan 2024 15:27:23.5008
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qsRlLPr6gjn9LsqyhW8b0iWpVAo4I3Sx0HmWw3FccLpp+1i2DFYTALatvhK3A5nK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4873

This relied on the probe function only being invoked by the bus type mock
was registered on. The removal of the bus ops broke this assumption and
the probe could be called on non-mock bus types like PCI.

Check the bus type directly in probe.

Fixes: 17de3f5fdd35 ("iommu: Retire bus ops")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommufd/selftest.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

I'll pick this up for the merge window, it solves some of the issues. I'll
send a patch to iterate all the global binding drivers for rc1.

diff --git a/drivers/iommu/iommufd/selftest.c b/drivers/iommu/iommufd/selftest.c
index 9528528cab2743..cf3e9fed039ee7 100644
--- a/drivers/iommu/iommufd/selftest.c
+++ b/drivers/iommu/iommufd/selftest.c
@@ -25,6 +25,19 @@ static struct iommu_domain_ops domain_nested_ops;
 
 size_t iommufd_test_memory_limit = 65536;
 
+struct mock_bus_type {
+	struct bus_type bus;
+	struct notifier_block nb;
+};
+
+static struct mock_bus_type iommufd_mock_bus_type = {
+	.bus = {
+		.name = "iommufd_mock",
+	},
+};
+
+static atomic_t mock_dev_num;
+
 enum {
 	MOCK_DIRTY_TRACK = 1,
 	MOCK_IO_PAGE_SIZE = PAGE_SIZE / 2,
@@ -437,6 +450,8 @@ static struct iommu_device mock_iommu_device = {
 
 static struct iommu_device *mock_probe_device(struct device *dev)
 {
+	if (dev->bus != &iommufd_mock_bus_type.bus)
+		return ERR_PTR(-ENODEV);
 	return &mock_iommu_device;
 }
 
@@ -586,19 +601,6 @@ get_md_pagetable_nested(struct iommufd_ucmd *ucmd, u32 mockpt_id,
 	return hwpt;
 }
 
-struct mock_bus_type {
-	struct bus_type bus;
-	struct notifier_block nb;
-};
-
-static struct mock_bus_type iommufd_mock_bus_type = {
-	.bus = {
-		.name = "iommufd_mock",
-	},
-};
-
-static atomic_t mock_dev_num;
-
 static void mock_dev_release(struct device *dev)
 {
 	struct mock_dev *mdev = container_of(dev, struct mock_dev, dev);

base-commit: ca4a310350b8795802e392ce005fb17075345fac
-- 
2.43.0

