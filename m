Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2042.outbound.protection.outlook.com [40.107.237.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F15DD20CCEA;
	Tue, 25 Feb 2025 19:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740512402; cv=fail; b=JMWI+1D6L2y3w8LprDnjG/XdZylublRg7U15mfA0OepUMz0/xAo80XPp91X64jDv05/Wj9fAIGqvQOTDY+d9iu+mThah12w/77HNi9zyquBLudqey22eZXfY2BEFM109ytgFoatPl5EzU9sUu99TUwEqeVirGCCJGFh/EEyBJxQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740512402; c=relaxed/simple;
	bh=jTw0TnZdImVdHssgmdd5JvJWlUNs7mitYYuV3E+c3kw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=R1GxnfOug0mkkSuZnR025zrEpzJ1eN91JEYddukxh8TLsi7KtnpRq0diPSGg9jOOD7+9twQ78tx64+v1oQpkUcijW0OrrKUugVAimyBEKoqA1Vyzh6VJyyBpL4z0273toyhfqKZwzCxA1nxekBZ+GS0dO/cpgMH04uSlsnU0jss=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=UoiYcWn9; arc=fail smtp.client-ip=40.107.237.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="UoiYcWn9"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FS8ioJD3etqaWoLtQh1oonoSjWN0ekbnW2f0cTH481z33hv9ZrPJjk9uszIemm0gbFrYFt1FwLNv5+n7JzBAyXIsLpVpSl6Je2BqjEKdaOZVo99uocgzJt0ORXnsUO5lWEtxoz1R4YsSyExKmjHnvwdmzAVVzpx6vj63j2UijOoEb+lPT6XxaweniezkTItIYUFSk37pscuwtuhPiaWEkivFSEr3AnwqlYVVIGomTo2emq9tgmBZTpb9SZoCkKWYzjxrwCLYY3fVFw1pIqkLkMSnVhGDvEl8VjeU6QGGHPFNyKAMR/RYV0THgAI3TwajLnZfyKgXM3zIMYOJaPuHJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+khpEJOPXtsV9nyj1OYsnGNYTGbZDVg/JxrXC/Gdxno=;
 b=vbNnIdOqZHpA5BzyJWrRJGYFvtcvKp9vctM81eE5y5o7T5D36eRqkFNyX8T7o0zLPcHVicucQeU9WLdWk5m/7B2CLkBUvaiUUeEM0f6BgOQ3Ry2I8IyZ9TNIxFeg7oGK8d9Bt4arORjuO98p74n1s7zpeU9O/fGL4aai1xFoZW7J5IZ7MFOO0Xbbtuv/ZmSDyx7KaZr0cRzwbBydRDwLMC7VWW7hSqVaiikN5HuClByypVdKwnF+EOex0OCIqsIMO6u4+7X7ZK1vxd0AmhQRTdfFfgUysh5fLM9sFyanVy8YJohDXcQBdJqcsE5c9oPZTjuSxsdDX8/1McBMvP7UcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+khpEJOPXtsV9nyj1OYsnGNYTGbZDVg/JxrXC/Gdxno=;
 b=UoiYcWn9EH3p0V1s7AD59MTbX1JSbmVyPnHmLfX1fnuCxqbBXfnttqoTwvG+4/G/zpyzOx/Ww7j1mjl9C2DQ5Ae2NkH7Illp9oacHAs26TTjGygNdFxC9quznJeoZPWSmBepWlzbXGyYIZxYKKe3vxnyC92sELBW8K2GzLrrypkqO0vQo6qg5Rq0mn88+zBIcYJcmqWEhXiG6wFRphJXgWH/Ci1LvzOI/DuS5p6xSxyRIcHDRa3JV2NWspk+GfSpjFkFzfu7SPt9d9hwz6mz8DLZpaahzOwU7qQz/7XDNDbw5LTGlwxkWDBe83NTygM/RCKI/+RfY8kAYVpxqTqv3Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SA1PR12MB5616.namprd12.prod.outlook.com (2603:10b6:806:22a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.18; Tue, 25 Feb
 2025 19:39:49 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8466.016; Tue, 25 Feb 2025
 19:39:48 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alim Akhtar <alim.akhtar@samsung.com>,
	Alyssa Rosenzweig <alyssa@rosenzweig.io>,
	Albert Ou <aou@eecs.berkeley.edu>,
	asahi@lists.linux.dev,
	Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Heiko Stuebner <heiko@sntech.de>,
	iommu@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Joerg Roedel <joro@8bytes.org>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-rockchip@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org,
	linux-sunxi@lists.linux.dev,
	linux-tegra@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Hector Martin <marcan@marcan.st>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Samuel Holland <samuel@sholland.org>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Sven Peter <sven@svenpeter.dev>,
	Thierry Reding <thierry.reding@gmail.com>,
	Tomasz Jeznach <tjeznach@rivosinc.com>,
	Krishna Reddy <vdumpa@nvidia.com>,
	Chen-Yu Tsai <wens@csie.org>,
	Will Deacon <will@kernel.org>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>,
	Joerg Roedel <jroedel@suse.de>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	David Rientjes <rientjes@google.com>,
	Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v3 19/23] iommu/riscv: Update to use iommu_alloc_pages_node_lg2()
Date: Tue, 25 Feb 2025 15:39:36 -0400
Message-ID: <19-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
In-Reply-To: <0-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0072.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:88::26) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SA1PR12MB5616:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b4d4469-bba6-4f8b-c470-08dd55d42748
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0zpM5kAuMJpKYgrcBEJusRjzuXmOVyo4s2rsHkyd55MSA0SiYw/BkbR8vk6S?=
 =?us-ascii?Q?PTRhig7OUAcAifSRkiUyR1GkPC3aQZvWQYx/w/mfNLYp15CZchkYAMbA1rsc?=
 =?us-ascii?Q?+QJnF+dNqV0iKMKiM3cHj/Ja5dU29C40a4gBB4Qp5VqYWa6D0jbYZBC1QebO?=
 =?us-ascii?Q?CR0MJF27tVk3DTMcPIG2WxdR3N+s1jXB8v6aKQGhBlcwci3VAfkWjmDQchRq?=
 =?us-ascii?Q?7htjAYmgz3msQW+ZyKeJ5E+1GcLQHWmNoJOKXnGcCmBCc0txd4Ge2aOzrnXj?=
 =?us-ascii?Q?ZMQG82PafSMl2vPBd1aUnfGh9cv5MKggAYciqOlLnYnY1dJBn732q4Ps58Ms?=
 =?us-ascii?Q?1POKqusnluQ87TCc4x6SnonyZIK5NYqkU9V5RlkD7WqwppOJx2U5CG3GkB70?=
 =?us-ascii?Q?QOxifGYfsGlds2DGGpa4bhRis3e65GkPnFslEmZgxxUCGYPkG4JrU+JsmgbX?=
 =?us-ascii?Q?KyWM2ooq4mAgDkkfTC49A4YtddNn1ikzkFn/DYSi38kMmWjOZOUv4tRl0iiP?=
 =?us-ascii?Q?8uQZJ6briD+oYLE2HA50p37g9j453WMfTMjY1ip7CgdV13cN7H2nOCE9Ix02?=
 =?us-ascii?Q?rWa1R/DGmlUuw+v+BHM/cFG+d2WeAUBP20LV9zTQHAYwl+1BYiKVhxzwJ5y9?=
 =?us-ascii?Q?9QfnkAYW1FBS3NwaN6znn5ECu0be8TEiq298P51CVR9N2dbtaKZ6LWvXHODT?=
 =?us-ascii?Q?ZJJ5zkSpQY84qi1Ag2FAXy4jovSP2AZDD1QKukO8OPtZ981bBMto3JXpDrGK?=
 =?us-ascii?Q?uMmJT7EnO3MsbcOu7o5SDAaOp6HWXUdx9ingZDgZ0LtGl0alYIVj00JGZ9XJ?=
 =?us-ascii?Q?WVDPjO43ZHvRM+qnRFN3aGobbqkTLoQhZEC7CzmmqmAwSmzBA+AwlZe355+E?=
 =?us-ascii?Q?gbBLkd4yPt8TktQJIFMxxojuvcnDP9YsnqYN4mU64aIKt5jB/SC3aQDxI+Ap?=
 =?us-ascii?Q?W89mqVUL0prsa1IaaCqYuZZ4Fw0YgDEz2FJopLB9xqZgy62l5eitcW42xOWR?=
 =?us-ascii?Q?0AFhoksmlKpretZzd9OrCZVMMtXfzVS/giiW+m2T6+bZOX5QNqz8YUfOo+/J?=
 =?us-ascii?Q?NXC2ASMuo7srC6s+eiZ4m64bIuVqoDdOUa1ab407fz4x1Vu+SBqyyM8uT8TP?=
 =?us-ascii?Q?BvMtaDKwQ5O6omTwH7DKcaMfBxUkKxaNlH2psiSwTm31359bzYTUSBqWcsGy?=
 =?us-ascii?Q?6aoADN/xrXFvJkZydTfqruH5JCb6nKttzJkh6qgZ8KOrAbxzu3yTPSw5e8Kb?=
 =?us-ascii?Q?j1zKBfJ9l61CZFnBSscrhtOKEE1k+X2OD5ppFrX17eERCT0mZXi/g2Xc/iPi?=
 =?us-ascii?Q?WnZ00eTLILRuvrQtq6yLDCrO7FdxOEsTVMIQEqRzPm1mkYP3cfMN5Py9NfZj?=
 =?us-ascii?Q?IbLwPeq8EHZSx/4eZ8mN+kwh/AfB5vWaL/k0kQjE9gV8pLdj6WMS2qaVaipk?=
 =?us-ascii?Q?ZXB9ReVqyoc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?F7Ra1iUtLS5eWJh6CMeHh/FxXjNiR/NxYQxFszJnWWVQIOByNRe1b0tMwWTW?=
 =?us-ascii?Q?QeynbG1KUryNKz7mto2j/a65WftVe4tUWeBRZGMwZGC0i661GGmBW/+bPFXq?=
 =?us-ascii?Q?VMCsGPI3E4bp8CUgC41F6nygPYnaYW0Mqz2rpXYEpd1JdF+46tIcDNuuqR4y?=
 =?us-ascii?Q?rYOcQMXmWKhbO34vOeGY47pENs3OrUVJarjCcFlGBOxi6LAHEycnNwjigHEc?=
 =?us-ascii?Q?NMtTiCSjKgDyeHVgAZwV7TZ4VlrWL10oWv9Om/X+75w3g4sP4XcQhxs819Z0?=
 =?us-ascii?Q?5eDuuCWXL1r87yQ8YXeJUJt9ccYv3COqFeBBgv6lAOMPgLFANHBtUyb0WHrO?=
 =?us-ascii?Q?7RPPihsnDJZksCiAOLZMoRq4SYF6xEM0/a1MfYAnFzjYFKwZhidkgER029wz?=
 =?us-ascii?Q?IMm39YVvofPor8s9XW4rcqJgMvPm+PuiZJJ4bd3ogp9JF8W1q7wGzD9SDBZB?=
 =?us-ascii?Q?obJNZZweQ8GVvlETloJFtK0AoT8Rk51s6wTWUtpjA7+mcY8zMKo02y1NDWfb?=
 =?us-ascii?Q?/7aCeFJYsURH/E/ZVUloW9oJvvC9dpllMMQqF8psaFg5vhULvksDp+suWRij?=
 =?us-ascii?Q?KE8Z9XRFUIVMTTQ0V6HYtRztqSION0Ucdync6ZxqTEEXk9vrMw67gdzjVbuj?=
 =?us-ascii?Q?yxiE9ZJ2jrSaUtXO+EN4X7eZ3ySHGV1VNLwYvkyER/c8HTtFmJQCA8Bq/h+q?=
 =?us-ascii?Q?3nowOAvudgUaPW7YI6eKR/nr4fZ1X9a/IMaNp/bhWmpDoRMvtQAaFdLifqtf?=
 =?us-ascii?Q?vcLr5TF9gAF57/xXLvg7qnahx05wET756SU4S1Zfq+AESBqAfo7dMUfUBp8v?=
 =?us-ascii?Q?6hlGxbiA3STzTfHHtNhjCwXvagt9rfGPAY/TJN/s8MJvmj0PPBEtyIQtClOu?=
 =?us-ascii?Q?9ESrnwjXLXkKgjVjnvlgjTw1v1vTNNRNwMOx1caqlon1767WeEi6yXQk090N?=
 =?us-ascii?Q?N1I8Joi0QNVb+xxXV8iCLzZ9ZXQFJsZN2acSysDwOS7cYVuacBrw3H9hlxSN?=
 =?us-ascii?Q?Fm1Fgr6H6YyibCbJdaFB1G7BcivhiBaleCTSTpmRrxSQwcn+rk+mQj+3y7Le?=
 =?us-ascii?Q?ywmfClXvO+IdEcRnpdN7mTP0gMor2VPnF6pdH4LFpiAjLr8Se3rBXoo1VJwU?=
 =?us-ascii?Q?jEOdty3tAoTfhTkWhEGZ0FG66vBH1Uj8oSlFWq+nZNZHVfhls0HhmAJgAh+K?=
 =?us-ascii?Q?vJ7fZ54CX4IiUgqfa0F6gw0ETHGHi3MAjjmZMTuy/Dju5YImnhtBtB8GTifh?=
 =?us-ascii?Q?l74zGwLx4KOpz/cOByfe/Db4Y9CaquvbadEsyY+cmSkQGtApIN4TWjU7MjOK?=
 =?us-ascii?Q?Ztq1wnRJUq8zAP/BLobLIVM8gq8JmK74LBv8Bp17nnqzbDbozFJfidLKqaN+?=
 =?us-ascii?Q?XihLmxMjvIkkzNklMRUZ/HD8isWTrqOSvr4w5OjGQQ1RC/E/wo3xE1Bsot5S?=
 =?us-ascii?Q?pIPspK/Tr4cs6BHXLMrdwFz0Uc2iXPdV4dyS6AihG4HIFN447XSf0Ki8vwkL?=
 =?us-ascii?Q?YKrRw4VOGpaasQ6jsbpCuV6zCN2Ey3LWG+doZ+4VVoi3pm77QAHn744rPJnB?=
 =?us-ascii?Q?omdfUKfUb0HQ/SV08oW5pWIEO3W2vb2rGSF6/kpO?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b4d4469-bba6-4f8b-c470-08dd55d42748
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2025 19:39:44.0780
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H+HPg+nJYG7ZPo8OZHZF/mD4fLKKHkSEGcGDSmkRUYYCPYayvvDWImcw0N7dOyMm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB5616

One part of RISCV already has a computed size, however the queue
allocation must be aligned to 4k. The other objects are 4k by spec.

Reviewed-by: Tomasz Jeznach <tjeznach@rivosinc.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/riscv/iommu.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/iommu/riscv/iommu.c b/drivers/iommu/riscv/iommu.c
index 2750f2e6e01a2b..8835c82f118db4 100644
--- a/drivers/iommu/riscv/iommu.c
+++ b/drivers/iommu/riscv/iommu.c
@@ -65,13 +65,14 @@ static int riscv_iommu_devres_pages_match(struct device *dev, void *res, void *p
 	return devres->addr == target->addr;
 }
 
-static void *riscv_iommu_get_pages(struct riscv_iommu_device *iommu, int order)
+static void *riscv_iommu_get_pages(struct riscv_iommu_device *iommu,
+				   unsigned int size)
 {
 	struct riscv_iommu_devres *devres;
 	void *addr;
 
-	addr = iommu_alloc_pages_node(dev_to_node(iommu->dev),
-				      GFP_KERNEL_ACCOUNT, order);
+	addr = iommu_alloc_pages_node_sz(dev_to_node(iommu->dev),
+					 GFP_KERNEL_ACCOUNT, size);
 	if (unlikely(!addr))
 		return NULL;
 
@@ -161,9 +162,9 @@ static int riscv_iommu_queue_alloc(struct riscv_iommu_device *iommu,
 	} else {
 		do {
 			const size_t queue_size = entry_size << (logsz + 1);
-			const int order = get_order(queue_size);
 
-			queue->base = riscv_iommu_get_pages(iommu, order);
+			queue->base = riscv_iommu_get_pages(
+				iommu, max(queue_size, SZ_4K));
 			queue->phys = __pa(queue->base);
 		} while (!queue->base && logsz-- > 0);
 	}
@@ -618,7 +619,7 @@ static struct riscv_iommu_dc *riscv_iommu_get_dc(struct riscv_iommu_device *iomm
 				break;
 			}
 
-			ptr = riscv_iommu_get_pages(iommu, 0);
+			ptr = riscv_iommu_get_pages(iommu, SZ_4K);
 			if (!ptr)
 				return NULL;
 
@@ -698,7 +699,7 @@ static int riscv_iommu_iodir_alloc(struct riscv_iommu_device *iommu)
 	}
 
 	if (!iommu->ddt_root) {
-		iommu->ddt_root = riscv_iommu_get_pages(iommu, 0);
+		iommu->ddt_root = riscv_iommu_get_pages(iommu, SZ_4K);
 		iommu->ddt_phys = __pa(iommu->ddt_root);
 	}
 
-- 
2.43.0

