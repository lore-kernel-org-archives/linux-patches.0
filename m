Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2060.outbound.protection.outlook.com [40.107.244.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDB6A38DFE;
	Thu, 25 Jan 2024 23:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706227067; cv=fail; b=eA1/7zA44oNEnd7dI97U5gi2zrc+MdbT7+94r6vc8cTBqr07HkoNIO1pU3Ms7H2lfEbtAFHSaKaDzkDzAwUJPdsIaK7Qf1GrvJ62vbdMoXj/u2No981XzawJLoXfeMeww1LiCn3Dbutr1azMuJzBqANQEtlWSF1gtw0XiWlczWs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706227067; c=relaxed/simple;
	bh=PMBxfEyP6NCPvhyPrtGyVYznYNsgxzy+tZEo+N2aPwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=e7MfwwpPlSoIBHp6ln/RhkiZbe3fGXGb/u/3hIUpZfJ6Eogiiwmu1poVq3zV0vo8+fmv7iXhUu3eXHYGqmUQAFRwM9DfCTTVm0S/8RqPcOK3dzQZMM3+IDa6rDzJmpMsawE3E5FpA/cYHHWtSS/XAZrUnlaiD0EXyBkrSjEWfM4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=uJS2X+Xm; arc=fail smtp.client-ip=40.107.244.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="uJS2X+Xm"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bV8R86F1Cn7glBQgg8xoC80KYYnJzD2d5i80q+5fMAgMfVsLvCLV5jm1FT7DSXpmo97f4dnVPC3c+a95jcM85TwKcmstKILUqZZPkDb5VhnzZ5CnLM5ShSLf4Ss68rPurODSpsCd/lrGlTZLs2QjGbkAvk7yYw6b/71dBGJ5ielS0whWLb0UXc8Qhrdrv8j5w41cH7rg09Wx2ONKCApTzIs6WOVuDHcJMCUCt2kCdGvo9vUFuB0+ItE7pLqg0KXVQ4LTaE0j5a+PfW+AXYoNzhCc66fJTVC1kXS6pTlDZNus9N+BIBhn8thMjgvybUctLZ1CzdjdukmXeAVxlTMuEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KuXIkzfRrb+78ZUNDbr4eYKFSZ+xKAgAmc2S9NqRU/Q=;
 b=ZYuOkZp43/LFMoiM4djsGgxayJaPPKgoN4h98bNFNgiKwan8zUddFrMv0TAN21dmgAVYQ7LEn8si/5ACsg16l0m763tJt8MmL4YZuSocsbaw30sK7bfywgKiG3sK7JIPJBvC3FgSYPm4aJ/kIPhiBrwuZxmOBUjcSFu5INOb6HYZKtfWNREK7MDoiuz/t1K4rshdUZSojpZgBaYgEIBwI5OhquB5CKby9mlbBxVwdCVXTWsD7XhYyLqWh032I14Xn9PDth84UhHVkSgroQbwTmuEIvPnG8T1IZJsXv2HaD3Lqe3dC27Jp8Z+MY46Piq++vIaW1qw0AHNENITCvTxDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KuXIkzfRrb+78ZUNDbr4eYKFSZ+xKAgAmc2S9NqRU/Q=;
 b=uJS2X+Xm6jsZeg4ifEEUGsaiJhrLp+85L3QuB0kl1wmZ1jERAAI3gmriw2oe8tAb8vNCJf0tfw7ayag9NXKpYhiJa8qJp80Rtrjk/AdmoPhwIGZveOLFnDTigYUqA2vMIay6mOndMH7luxLl7NgschntIKkJ8Wbr50PLEkcljpLFaky1XQN2G2avJEiLZy0a5nsARO8cVAhyK91SedNZ3f3FmnL5LSw/PiiHkfMdJewfdpqx3mgSfoxm6Z7l2UgMAZAgCGdjc21AkDWeYdU2kRolEQ//3qcRu3UqCVdCWV4uB67+k5a6wrAq2HGaknhPnrwPmqNywuRN897yg/PmmA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SN7PR12MB7881.namprd12.prod.outlook.com (2603:10b6:806:34a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.24; Thu, 25 Jan
 2024 23:57:34 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7228.022; Thu, 25 Jan 2024
 23:57:34 +0000
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
Subject: [PATCH v4 13/16] iommu/arm-smmu-v3: Add a global static BLOCKED domain
Date: Thu, 25 Jan 2024 19:57:23 -0400
Message-ID: <13-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>
In-Reply-To: <0-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN7PR04CA0024.namprd04.prod.outlook.com
 (2603:10b6:806:f2::29) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SN7PR12MB7881:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d35176e-8269-4956-62e2-08dc1e0163f3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	0mtJEoUh9n/622e0FNB5dcg147qJtbhLHN8vCK+yasOvH3eaKVdjLxmMQVTqZd49Dfn0lefCiNo0uFgeuaKGdkqHtx27e9w2O3fSw72I4WANMDmdFExDv7Qn/9DRB6eld2BwKJvcq87ywHiIczelwmPCwBRnBLsuv7zZy5zkqMPWEb44GzwwVgBGswfl92qOjbYrv/rXd/7d+QeFuEensRlLi/ge5Xm+B2lPkH6i/auzowO9+OLBciDYTCrmofQn67TGZ+rCYbfzyqa1kAlRgXNbcSUFcWlnIP7SSTHVxGn92CcldkcxuJo+sKtBw5nIHjlOQleJb0OrAbqqRDpgRphtDIGiNnQT6QQfzEWh2jMsXU2bcBxUWNlx1BKrPdsQiorrEBxFYrZbhBasIw/NKPjW1vcdmRYZYl7z9j17IBRxwNT3D+RVluYqbkzNcQGLI+woBLZgbIIgK+zrbNtiRrWi1Dy8xBRP/PFmxlvNPjOm0EBIAyPIho0HPmM2KV9St0uwRRxsOJvBmOWhtBDg7w3Nio49Vle3xNDtaGXcITdVEZD0HrpOetGZI55gp+8a
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(396003)(346002)(39860400002)(366004)(230922051799003)(451199024)(64100799003)(1800799012)(186009)(83380400001)(36756003)(66556008)(86362001)(54906003)(110136005)(66946007)(66476007)(15650500001)(26005)(38100700002)(6512007)(2906002)(2616005)(7416002)(478600001)(6666004)(41300700001)(6506007)(6486002)(5660300002)(316002)(8676002)(4326008)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RlQfh00jKmHlGWEpzxaBR9wsvXRptbP1fIb0Jb0Mj7GUNrqGpbvorIJXSfOh?=
 =?us-ascii?Q?C8rRRaVQDctXCoE42/5wRTV3e/HJRINh0j0fMyTYHlamxjj+KQ4pB0aBhhd+?=
 =?us-ascii?Q?jp8j3DLxGpoy6f6ngo+sUl70QxDz0jcSL392wuYfcDx8wMyUf9cy4EbWcv9R?=
 =?us-ascii?Q?ZkN+wMmBi9buhXXxfKPs+S6sUzQM8KzkyGErkPVl69hLtt+vdc6q5+lxDQeH?=
 =?us-ascii?Q?TVbNe/h4kVqL//e/T8Z5KqkK/NtdVjIatWfWSgUG/si0xLwptoeyFaRBZ3Zr?=
 =?us-ascii?Q?FEkPbEJdwOoqg1nDMJ10pHyEZUuormBuwDSMyYzHBU63Wl2NgtUQbdUHxgMo?=
 =?us-ascii?Q?+xpmKohv2nUKmDR8pfxzy+mK4yUp6jZsKtqO3TXLUt5Hdo5t+EjVxVoSaKBD?=
 =?us-ascii?Q?1poqwUwALn8XuTkZDuCBpR/XNfc3jNnw7vqK9LVIue0OJQVzwsUo9TxJq020?=
 =?us-ascii?Q?8LGagfTS/+sbQfwAdOfZxREJY3RZXxSEN2e31gD/pq5gIoc5DffBhrhlGRsn?=
 =?us-ascii?Q?ULLwogUv2oZ1/yLUIETLkUWKytj2HkxUtkPc31H6b7c/txUSsovZtbdW3j2f?=
 =?us-ascii?Q?5iycgQJpSc2N48+mFrEtKZT5Pg75kkd6Kf8XbBzlb2W7vumoErpYZFa2AHbH?=
 =?us-ascii?Q?f6dnBQXDFc/XRLoPL83RkEKQufOwqdObm25GQi8bJBIZxlS+BhGquBNTBxqY?=
 =?us-ascii?Q?m6PnuLzHPkKtzJ4wshhjtYj350GGNOEltuoIfHxf3qNi2W9YxuJwOTG/8UDb?=
 =?us-ascii?Q?84ER6+EvvJMUwzuGNDlkF12TUk6CZCT81B/PP5HEnjLjyomIenbSjX7aD51L?=
 =?us-ascii?Q?mugStc2sz6X+7bre4I7CC4CzOnUFsSEK1Wnda/6WDwxa/MEpQNfR2RV5YobL?=
 =?us-ascii?Q?HC1JFJdodzcUrUGyXSasX1rnVkoBffE5c/OOrBuoTkmHOUwCkkFM7Pfjs5K3?=
 =?us-ascii?Q?NuJo+kq12XIbAWSjGZIEIxnBM/wrqE3olF9i3YqmbO6MUz0A7F8HdYfmo+mZ?=
 =?us-ascii?Q?IeDcRecT/tUMw278y4hV/D04+UzqLnwtgEWxcdfnRG3plGavCHRGqb26Yeqt?=
 =?us-ascii?Q?SyazCq+k47nUrcxu7J8yWXJdogxMVfu1ty8FzkN6QUCrZiw0Vz3yo82A2MCc?=
 =?us-ascii?Q?7S9iqhHP/TVZftnHzbDPI+zZEYAPHNhE2fBqeUpIGJv33I4pB0cYyInykcFS?=
 =?us-ascii?Q?VscseeAb8wgrYo4ZJlXMWQ/j1ltv1CjhM322fpazEgFYwgGhj5TB5kdSBYAH?=
 =?us-ascii?Q?icRdqMnv47hE6EvCXb+DhZ2OM6Q08Q2JnGJ7c8qG8jfVjn+mDyrKl6+jD5IP?=
 =?us-ascii?Q?yneYj2RLdraw7UTJ1sDe2/jnHR7drCIf8nG1xoSJDZINWx7G+ENErFv9x/dl?=
 =?us-ascii?Q?OHuTHJB1/2k2r+PIghTuAryl97UjbH/VafbQh+A7CEQ2haKywbyC72hFJ/G9?=
 =?us-ascii?Q?lS+AeI90lHTJwvXwbmsXa3/v4FvNWXRVbiMpGYaejolvfbgebXWlrnUAu5tq?=
 =?us-ascii?Q?AiYqnZ8RkFvRfw4tuJZxQ/qyhoGuni1Yb4mUsCKDatk/Y8KLrl1nG2ZM/JK6?=
 =?us-ascii?Q?uLKkTA8oEbrwPbdYrP3Unsk3P4ZAygD4mPak54av?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d35176e-8269-4956-62e2-08dc1e0163f3
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2024 23:57:30.1639
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4mGbzT0+TH/94I4+VdPDbONWmGiLeXE/JZlrVtc0abmOaP9INA8O2HCJnJ9xNBBZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7881

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
index d35bf9655c9b1b..15e305253ddbb3 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2700,6 +2700,24 @@ static struct iommu_domain arm_smmu_identity_domain = {
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
@@ -3090,6 +3108,7 @@ static void arm_smmu_remove_dev_pasid(struct device *dev, ioasid_t pasid)
 
 static struct iommu_ops arm_smmu_ops = {
 	.identity_domain	= &arm_smmu_identity_domain,
+	.blocked_domain		= &arm_smmu_blocked_domain,
 	.capable		= arm_smmu_capable,
 	.domain_alloc		= arm_smmu_domain_alloc,
 	.probe_device		= arm_smmu_probe_device,
-- 
2.43.0

