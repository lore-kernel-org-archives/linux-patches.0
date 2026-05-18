Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010025.outbound.protection.outlook.com [52.101.193.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05312313543;
	Mon, 18 May 2026 19:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.25
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779133433; cv=fail; b=NXD8zbLjZrhy7pJc49OtOHLQUOoGYO2l4UFtKg/2BSq5gD31ScFZYFoOubUcOY+c0BonyppMlq42roo24auLiXsgbmdxkCkjLdYZ+lAVAactNdBj+7GD6+ugR7BJYhTgzzxfpdocgSG6nMwM3OaYaRvq/eWzX/SH5d4cgx8db/0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779133433; c=relaxed/simple;
	bh=G0C4SBLgV45KSrzjuIiPTz4rC02u0t3jLhNuDK5qBIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=AKVVO9xvWSeJB2pv4gMQkvjKH7kc0A2BzndVrsY5HDaPDAIrtf/cHIKRYF39OEUiSO4OuxfIJgz18JZsmv2rOtUlCLWO5wvul3Yb+4StY8BXfAMsujM1GbleRnQFqRhBAjZIAU/IS4sVqXskQD9hQ7Zwlw52M6bLUKFh3j0de3c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=bYCYpgtE; arc=fail smtp.client-ip=52.101.193.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="bYCYpgtE"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WMWmkRMEl4BflFmw6igwDnzpon/ofH/wH8YfD3UPKd24hbog8lucVuHc3q082M1jVe1SrADulBXK4YbayYejybkEVHvKNTTs5uu2b0orN1j1khX7joXwTA88WW+j7spCr3bp6AvicW8D6tBmPE4xf19Dj2UKAli+i23HnxFAqOdZk2NqN7zx+sIH8L5PbDG3Z682K+T9p9JU3wgs7rAdcTSH5LFNClEqED7AWLzqJWBR7lhOGbUhIrzqTdjXxeQsk0lxY46NOuO5ipz4G7AjhQ/pSS3Wv4jqVE3356jWnWqp2IP25p9CvoKdhzK9dBly/r320MLDHTW5yhqJ0DG6lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9UEjEPPqVkPrE+m1E5MUbLrE/V3FIgvAW5vZVijFne8=;
 b=cfSR8p/hR2OMUPE+TylY1HzbQiovoj4zl3vE1b8ttnRH2DRorsROMZNBIqUot9fyMqsRsBiSe4sNl/VL+qENbcuMzSftRLlnKYFOB4LKS/v1r91QbbmK2cZ767LorbVTtyUe9kv8//fV79jH5xXz6SM3KBx/J0naiO4QYnt4KkGJBLVHUYbgIw57oEtoSh73f88S34H9cY/RoeKEAIan0f3WbBtDZNWzFhbN7GJu4miHDQ/UjXyyDx64JkCDXJQHdtMpKttCvlH7FlxQjdy9qkdvXIsMp5ZuCyvt4C4XPEACj1kACXOWgJ4DeFcQPuxZ8kfSoPUztS5M5GPyw+oVSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9UEjEPPqVkPrE+m1E5MUbLrE/V3FIgvAW5vZVijFne8=;
 b=bYCYpgtE5mizmYNyzBFCOmUayqHQakrLMutmS+ndxOnkNGytw0aTawCoe/fv6pP4l3eLd73QkJt5Eck3uz6QqPtn6pQXqZmKfFbKNgfFe9yFS/O3yI2M3Vuok6DO+wwvvW+yoUit3uL+pC/IHYYu945zoQ/UvSL73bGUS+DdmLp9IIuzYmYmXcuKy0Yf/iJT20dF3GlgBvngIY2EjC1FYVZdkZ5ZGHwPqqs/jAFtvb7DY8VhWaw/tqCisU5FWON7HK61n3YroIjhWoRFShL4qgpPQfIbVn1tvRCOHBB+RIzHP1ZPE1Lle9mun5LHdoMQVApW684m62DtKVgYZPZIig==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by DS3PR12MB999239.namprd12.prod.outlook.com (2603:10b6:8:38c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.23; Mon, 18 May
 2026 19:43:47 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.21.0025.022; Mon, 18 May 2026
 19:43:46 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: David Matlack <dmatlack@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH 4/8] iommu/arm-smmu-v3: Keep track in the arm_smmu_invs if RIL is used
Date: Mon, 18 May 2026 16:43:41 -0300
Message-ID: <4-v1-5b1ac97a5403+6588f-smmu_tlbi_jgg@nvidia.com>
In-Reply-To: <0-v1-5b1ac97a5403+6588f-smmu_tlbi_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0129.namprd03.prod.outlook.com
 (2603:10b6:208:32e::14) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DS3PR12MB999239:EE_
X-MS-Office365-Filtering-Correlation-Id: bf0e613d-0dca-44d9-806f-08deb515c68f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|11063799003|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	4sH5guOr4k1eGas5+bSCiBSxYNz+vdaknxkBB/Xw6cHs8p+/81IonmOY4VCX0EgkJY4oJQbZR7ZOTT3HvpHRdyTFx04Clz4yqfRSoqAkA45XP2C51WMA/aeacbQXAfroVUvEIe21DhZG/a+HDU5wtZMCsBUDquCkGK817QzFHEgAg+oBe1LIkp3vfAJum4LQfDkxgVc/VJEKFYVi6lvPO78OB+Emc72yN7tX2dLaNyVjKdWtfS6YZ74vHc0Eglt/nZ67fOrwinSvqbwDO33M7NxCvQBiGLPB1EwkQLKb3XiEGK7juWPHUlvfT5qdJsED7QHxn9vIROiS19CFS6i9c7T27F3Gl+Sanx8997pWcYYM4iV4OvCh6iuJwBlHioOd6lAEJoGrTBbufreXkzQ8T8rqVQjKiQbaeiy0mbNx3ndX8yjBdgS6h0KU1pxyO5ce5TEtIJ3cnOEdtYStRlXe0ASXUiiRy4vwDPfZqvc+6w2UZK6oCp7TFh47lplbk/10e95Bk+b8PPgnAlQn8tzPKmcEdCo4BkBP9679ShgdJSfBxw+bep7VFJ4fIM6YDnjxPk0VL5N1BSHhcUnjn0e0ETqWAzvsGKE+Tin9MxZs1SLHeNj8YDfgNbuzR5XgdZct94UBP14vdCIYo00XAlJtOzXcPALtykOaXhh9orCjGMRv2c+YCWgxrOIhmIiGssUT
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(11063799003)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hRWY5gpg0Q3GhAyqzwvOz5T4hbrRgVWaijttZ14D3VF4GrZMCLivNP/HjsIS?=
 =?us-ascii?Q?CZnVps/HPGcnFb8dOVD2QEFl86QFoLM8T4AeUvGDUTGHTXgMmUNUmKE/6BF3?=
 =?us-ascii?Q?1gFaCyGn6E5VnIDBHRr9NZpLq5yfDN0fqYOYxmNFpGzdrRRErDdU6Pc+N8yR?=
 =?us-ascii?Q?1uiQDOLu/mP+BuzrvDDY/TRRizGdvN3odyXpbiLIhmR28deZ6C4uyjaSBq+h?=
 =?us-ascii?Q?6desX2m0GC+EosZp9D+XZuJBnt4oPRDg5jHKVO/hCr12+nSQhStU6qZKDn7n?=
 =?us-ascii?Q?IyJudP1w5YP+wcjkslopckJhWD1yPfb0ctWcWrHEd9Z3zOaNRz+9AhFdDKjA?=
 =?us-ascii?Q?kWD4ugd4IWABmmfGjYKhGINoQuzzOUqmB+XIUR7ISgZDWzLJ2/dbnlLCqJKv?=
 =?us-ascii?Q?zWmY41Ixmd74tEMtz2fj2Xt/cI3KVw28vnbXQBcMdmKpcfZP8H2gHB5HC1S+?=
 =?us-ascii?Q?r8XATGjg4NPo+xvPk/wo9saN04wqtoG/3b4X/gyRkLQRYpLEEPKFqV95kIEe?=
 =?us-ascii?Q?6S7sEhxXcg0ZCDK3pEDAy9/8S7yyRNISKQYA9eVqcZNVV0sLARtTSfZAlXWb?=
 =?us-ascii?Q?EgqqGwnJXszPwjtA0szN5PfzjTongseQKPthksAjLPGCBk2I3An3hve3TG+N?=
 =?us-ascii?Q?ghP/JzGpaDoWc+iWoiUmNogpotyOAom/agotQbk/UQbCcC7g27wcRI0QN3Pn?=
 =?us-ascii?Q?V77AFvmEUt6pdMkISAYsixDO6Lj2niRRYO3vyI+7f9b2foujDnlNlZ2X33HZ?=
 =?us-ascii?Q?giYCB+VZTHZi69z9Zd0XL6ctePWofVbNGfm6otoDj7LamQEC49z01mXRUQ9v?=
 =?us-ascii?Q?EyoPO5Ogtahuq8wZhIBugCD7s2vDGjoPl+MfOc1SH3apKdmgwyFuhIA7t0Cy?=
 =?us-ascii?Q?tie6oJ4i/so0hBhcNP0t+d+sibEqcSyZ7wY3bmMiknNIVOeWx3+qNX/0S+Mf?=
 =?us-ascii?Q?mZBo9n/n5TYhkhm391PODpapyh/kWb58hkqxuOC8G1jXtgsT0BbukKdSuPDb?=
 =?us-ascii?Q?Fx4n+/TKWDWScqi7mPkKptlucK1hBT31RDwPJZfwKcYSZaDX7/9JBGG38oiH?=
 =?us-ascii?Q?R+PDCKhxanZmLN5c4aDwAKJ3K08DNcA9DtmZgq5KZqhqjbkGdSq+A77jCcSD?=
 =?us-ascii?Q?fNaA/ZAyTtt8uI1BFlb6vqc61Hq20/xrxDsJNhe9DF0KCXD2K8jnRol94piT?=
 =?us-ascii?Q?DFoPWIJDpTKLzWFqPKRkdGydHkhha9XOFluod3Qjh7EvL9HYsh9xa3XTBUpD?=
 =?us-ascii?Q?M6NL8Gu6z13ATkgjRp/1It7SZKzrjPimTzw+AJ3sJSPUNBnm2z8QDfPYWbR3?=
 =?us-ascii?Q?W5KRVGMLmfG2eAoivLH0a6fgnYBGU0K1X21FeOBWeA3Rp9jVlh4dqnKWnZpM?=
 =?us-ascii?Q?THmZ1L5AQmubqbDrswdAodSKPX3c0uqUF4nQ0QsFZXQs5CmZ9/FHvAWsn4dA?=
 =?us-ascii?Q?C7/aamjBv5zx6QWr4UoZ8XgxRiMoTVBil8GDaAZwYOUXW47RUZBGhblQjz6J?=
 =?us-ascii?Q?jtu81JXW9rD3Q556cZ4SUP26wWSwF1/fL+N9nf5fwT0y7BfbG/UdKfCUrNz6?=
 =?us-ascii?Q?btxQ/kl+EXvnMqgKUtUBsPDTsgDjJ3uK3UhZ1t9Ij7i8yfBfQCqlHZzAZy5j?=
 =?us-ascii?Q?wfLNLaJycWDSCG1nYwtEi6XVjPs+0klztJAMgns5hIRKKJaQ2zs65Jmqexm5?=
 =?us-ascii?Q?Sp9QwDuBISs2M5Ft+B3PclrMKZK4OGYKlgS8lKHc3cfQPJ7D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf0e613d-0dca-44d9-806f-08deb515c68f
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2026 19:43:46.4882
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /nOvj0tu5O/p7XC233Y8+X3TWoi9hp2suMZRe7vp2IH3BaiyZGPalEpmYfYteTwi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS3PR12MB999239

Summarize if any of the inv entries will use RIL. The next patch will use
this to avoid RIL pre-calculations unless RIL is being used by the
invalidation.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c  | 30 +++++++++----------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 18 ++++++++---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  2 ++
 3 files changed, 31 insertions(+), 19 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
index add671363c828c..785dd21bd68b7a 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
@@ -655,37 +655,37 @@ static void arm_smmu_v3_invs_test_verify(struct kunit *test,
 
 static struct arm_smmu_invs invs1 = {
 	.num_invs = 3,
-	.inv = { { .type = INV_TYPE_S2_VMID, .id = 1, },
-		 { .type = INV_TYPE_S2_VMID_S1_CLEAR, .id = 1, },
-		 { .type = INV_TYPE_ATS, .id = 3, }, },
+	.inv = { { .smmu = &smmu, .type = INV_TYPE_S2_VMID, .id = 1, },
+		 { .smmu = &smmu, .type = INV_TYPE_S2_VMID_S1_CLEAR, .id = 1, },
+		 { .smmu = &smmu, .type = INV_TYPE_ATS, .id = 3, }, },
 };
 
 static struct arm_smmu_invs invs2 = {
 	.num_invs = 3,
-	.inv = { { .type = INV_TYPE_S2_VMID, .id = 1, }, /* duplicated */
-		 { .type = INV_TYPE_ATS, .id = 4, },
-		 { .type = INV_TYPE_ATS, .id = 5, }, },
+	.inv = { { .smmu = &smmu, .type = INV_TYPE_S2_VMID, .id = 1, }, /* duplicated */
+		 { .smmu = &smmu, .type = INV_TYPE_ATS, .id = 4, },
+		 { .smmu = &smmu, .type = INV_TYPE_ATS, .id = 5, }, },
 };
 
 static struct arm_smmu_invs invs3 = {
 	.num_invs = 3,
-	.inv = { { .type = INV_TYPE_S2_VMID, .id = 1, }, /* duplicated */
-		 { .type = INV_TYPE_ATS, .id = 5, }, /* recover a trash */
-		 { .type = INV_TYPE_ATS, .id = 6, }, },
+	.inv = { { .smmu = &smmu, .type = INV_TYPE_S2_VMID, .id = 1, }, /* duplicated */
+		 { .smmu = &smmu, .type = INV_TYPE_ATS, .id = 5, }, /* recover a trash */
+		 { .smmu = &smmu, .type = INV_TYPE_ATS, .id = 6, }, },
 };
 
 static struct arm_smmu_invs invs4 = {
 	.num_invs = 3,
-	.inv = { { .type = INV_TYPE_ATS, .id = 10, .ssid = 1 },
-		 { .type = INV_TYPE_ATS, .id = 10, .ssid = 3 },
-		 { .type = INV_TYPE_ATS, .id = 12, .ssid = 1 }, },
+	.inv = { { .smmu = &smmu, .type = INV_TYPE_ATS, .id = 10, .ssid = 1 },
+		 { .smmu = &smmu, .type = INV_TYPE_ATS, .id = 10, .ssid = 3 },
+		 { .smmu = &smmu, .type = INV_TYPE_ATS, .id = 12, .ssid = 1 }, },
 };
 
 static struct arm_smmu_invs invs5 = {
 	.num_invs = 3,
-	.inv = { { .type = INV_TYPE_ATS, .id = 10, .ssid = 2 },
-		 { .type = INV_TYPE_ATS, .id = 10, .ssid = 3 }, /* duplicate */
-		 { .type = INV_TYPE_ATS, .id = 12, .ssid = 2 }, },
+	.inv = { { .smmu = &smmu, .type = INV_TYPE_ATS, .id = 10, .ssid = 2 },
+		 { .smmu = &smmu, .type = INV_TYPE_ATS, .id = 10, .ssid = 3 }, /* duplicate */
+		 { .smmu = &smmu, .type = INV_TYPE_ATS, .id = 12, .ssid = 2 }, },
 };
 
 static void arm_smmu_v3_invs_test(struct kunit *test)
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 59634a5a5c0640..3b0b273fcde829 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -988,6 +988,18 @@ static inline int arm_smmu_invs_iter_next_cmp(struct arm_smmu_invs *invs_l,
 	return arm_smmu_inv_cmp(cur_l, &invs_r->inv[next_r]);
 }
 
+static void arm_smmu_invs_update_caps(struct arm_smmu_invs *invs,
+				      const struct arm_smmu_inv *inv)
+{
+	if (arm_smmu_inv_is_ats(inv))
+		invs->has_ats = true;
+
+	if (!(inv->smmu->features & ARM_SMMU_FEAT_RANGE_INV))
+		return;
+
+	invs->has_range_inv = true;
+}
+
 /**
  * arm_smmu_invs_for_each_cmp - Iterate over two sorted arrays computing for
  *                              arm_smmu_invs_merge() or arm_smmu_invs_unref()
@@ -1058,8 +1070,7 @@ struct arm_smmu_invs *arm_smmu_invs_merge(struct arm_smmu_invs *invs,
 		 */
 		if (new != new_invs->inv)
 			WARN_ON_ONCE(arm_smmu_inv_cmp(new - 1, new) == 1);
-		if (arm_smmu_inv_is_ats(new))
-			new_invs->has_ats = true;
+		arm_smmu_invs_update_caps(new_invs, new);
 		new++;
 	}
 
@@ -1169,8 +1180,7 @@ struct arm_smmu_invs *arm_smmu_invs_purge(struct arm_smmu_invs *invs)
 
 	arm_smmu_invs_for_each_entry(invs, i, inv) {
 		new_invs->inv[num_invs] = *inv;
-		if (arm_smmu_inv_is_ats(inv))
-			new_invs->has_ats = true;
+		arm_smmu_invs_update_caps(new_invs, inv);
 		num_invs++;
 	}
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 0c63069400d22d..d58fe91a96325f 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -755,6 +755,7 @@ static inline bool arm_smmu_inv_is_ats(const struct arm_smmu_inv *inv)
  *               Must not be greater than @num_invs
  * @rwlock: optional rwlock to fence ATS operations
  * @has_ats: flag if the array contains an INV_TYPE_ATS or INV_TYPE_ATS_FULL
+ * @has_range_inv: flag if any entry's SMMU supports range invalidation
  * @rcu: rcu head for kfree_rcu()
  * @inv: flexible invalidation array
  *
@@ -784,6 +785,7 @@ struct arm_smmu_invs {
 	size_t num_trashes;
 	rwlock_t rwlock;
 	bool has_ats;
+	bool has_range_inv;
 	struct rcu_head rcu;
 	struct arm_smmu_inv inv[] __counted_by(max_invs);
 };
-- 
2.43.0

