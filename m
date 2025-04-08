Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2058.outbound.protection.outlook.com [40.107.92.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 201E7234966;
	Tue,  8 Apr 2025 16:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744131271; cv=fail; b=Qf8AcTUG64sIjfNOVj2So8w5hrteSGgryOvXbVsyEdTpluhyM16YyLAwrEiQGoku+JFVzDRVt7t1Krz8pQ5mKLH4d1HENS5OUOpd+AZbUiRj+DH7NcE+JZ5blhV6GKq/HDEAmCeH5zcVLz5jf2ZvPGh8+BD+soPjFWlBrB4deW0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744131271; c=relaxed/simple;
	bh=HKLGXVesfzIG57bT0c8RAvS1CL0WZkaDuTnjKcABHvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=nsWWi+sFz87GK3WUu1a/U6QNw9imbGmTDwXpv6DaR1xzFG4A0egDQNq6X3evzbqf6TK3I4ivy51BWCl6WxCljvrMXkHkWB2f1rXU5ruUilG4NhDio3V+grL0/9Ut03Z6mDjnS6E2WM8ZjQW660S3u3o/wQRYaILiSYuHyyEZMr8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=lboDYWmH; arc=fail smtp.client-ip=40.107.92.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lboDYWmH"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HK7tRGGMtyWnYATn4jBIw8Sws6PCNDoG7qoJpgHEsdR4aItnZcp77VwltHfk7htTLGFZX6Npv5dUc6xCXJI07JgHnkCY/2rP/AxFJx712wL9tuOXuL/0A5niGgwMH3+Y7+4ahDWU+WreG8LxDWaLam+rh1rUt9ozsY50au4Z+IJBr0N49JNosC4ifsMPaz90tX10Mvx9MkNzUuLxtjSCxxi59lr5h5e0DeYDZ+vN32rgp3ryVlxfQFPxEU1BLEbv/vZlMAL1GAiLqsUnq/6lUMTQLWanJAoPRncX46vAPX4bG0oWiV4pu/KOUWzHqXlt2XwNriMws8LGO+QqWr6I2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5uzGb1bUyZX6DlT0H/GcVldOtITA3li2V67HNj6pM6k=;
 b=QVuq/K05qbGYRJghnoG2zzum6xDnE6uyMQartpHCwxhaQVYmNBg9ZW4iu9yOdyo0CRpPEjc2SQOsRKOVtIVX/83x50vGJKlgWkqmHJ+v2unp1txCN56dcTaIBe/ZWl4mcdJCbGwie8lnoeQGiKXE4Iej6CeqM5/MSbq/upoFSDXcrJIeATJOe/7iR5eoHDLVS9dfkhzuNvlfoqWJnf1ryweKzZuriqaI4pD8DBRLPuxEIKd9oxwDa6bbm76vUHcVMf/0T0Rau8x7BUleaKt5KOK72mz5zfPJfYWfehkjxQic+xrBDkM8sAdo5/q/UoIQYbURKocypo5c6330XLzleQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5uzGb1bUyZX6DlT0H/GcVldOtITA3li2V67HNj6pM6k=;
 b=lboDYWmHVOOrifDCQLbRqGuyGkS9VCZ/nbeNw64LXLu4QOrQEhPXthu1aPULaaiXl0vJeOFIs7DuZpQF3G38kt+DlChifViI5v9wNm+bH5ILsw/4k2CmInphUQ9xa+4zFnfV7Vo4oECFZTq0OewJfp2WO58CKL1+ij42E5e8ZEdVEma3XWJEtAejVepqkYynnmBDCYETpLzUfJjy1PlYTGsdkQKDkycSpH8LlqlRaRUHKsWwyuRRW+fY2f3A5aq3sHd60pp9jJLOqwo8meIN8cPs8zOVxX6EgNmbwnMiA4XBi7ajq95KQ9bl5ozhXP2kL7oM7SXRmbBWFWlhYumkJA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by BL1PR12MB5971.namprd12.prod.outlook.com (2603:10b6:208:39a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.34; Tue, 8 Apr
 2025 16:54:20 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8606.028; Tue, 8 Apr 2025
 16:54:20 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alexandre Ghiti <alex@ghiti.fr>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Alyssa Rosenzweig <alyssa@rosenzweig.io>,
	Albert Ou <aou@eecs.berkeley.edu>,
	asahi@lists.linux.dev,
	David Woodhouse <dwmw2@infradead.org>,
	Heiko Stuebner <heiko@sntech.de>,
	iommu@lists.linux.dev,
	Janne Grunau <j@jannau.net>,
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
	Neal Gompa <neal@gompa.dev>,
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
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <jroedel@suse.de>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	David Rientjes <rientjes@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v4 17/23] iommu/amd: Use roundup_pow_two() instead of get_order()
Date: Tue,  8 Apr 2025 13:54:05 -0300
Message-ID: <17-v4-c8663abbb606+3f7-iommu_pages_jgg@nvidia.com>
In-Reply-To: <0-v4-c8663abbb606+3f7-iommu_pages_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR15CA0062.namprd15.prod.outlook.com
 (2603:10b6:208:237::31) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|BL1PR12MB5971:EE_
X-MS-Office365-Filtering-Correlation-Id: 391abbf1-1fe6-41be-2300-08dd76bdfef0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VOA/fC4Z6CXUqN+nwI1z14MvJwrp68DBysaOvoCF7WXioe+3q/s2c4+FPj6q?=
 =?us-ascii?Q?ot8HIhPKSxoAvpHB7Ac4cJfcLMSZOwdjAgeuVG3+h7KEcXAP5g1BFLnwXB4S?=
 =?us-ascii?Q?irD3I01ak4jU4m8V66SrWjMoyX2X3NWJh17MOpfw15PjVsFn57VjDX7BQkGI?=
 =?us-ascii?Q?AmXb8/AEFehLNWog2b2tWsP4/mQyUgdNItm269swrzmYdB7ZlS4f9jaeDnCB?=
 =?us-ascii?Q?wn0eABpAVYt337kc/nJEUaCSh6toBP7xiQA9Bcg6C8S35TAFayRZWO0hmxYR?=
 =?us-ascii?Q?pB6RUOc5RIIvpTxzPucnXgZXmL1XwsUvtuCIV4/hBJjn+FwrHfZCEChELmEr?=
 =?us-ascii?Q?6aJViBn5CXu84WV/nuMkKszq/Wo2j5Lk6xPn76UP+okwGVlv+/s8S1ig96sk?=
 =?us-ascii?Q?hlGX2DsIGT0CZT8ghZMVv+yNH6VLVUuMrXhBRWbRkui9yo+CkmvDCGEVTilD?=
 =?us-ascii?Q?5whuv7iJBro/bVjOoRL0LmOlnHOy5/t3jIHuMOgcGeZc44iGyBveoIisPnwF?=
 =?us-ascii?Q?g+aJQLxLsuYTRj8uEtBUvgfsDZ6h/HscRdQTnmhIGIDghvGC/0hJkfw5ITRB?=
 =?us-ascii?Q?2aa93bQgW5lIMRNDwEMmKlVe8F7cmsLq9FIWicXay4ipVGkp5/0zmXpL149W?=
 =?us-ascii?Q?0Tq4GjOyYMSPNc/MbK8zafq+yZAGHCvSqbcDHb/lTgRTpcZJrOUQwOwrcVNb?=
 =?us-ascii?Q?J+XS8On1tzwUZ0XAp8rDve+GY4hDew+6e3XkLbITwNCnTNcailF439TZEw69?=
 =?us-ascii?Q?kQdLxSXxH65bRFR2RCS5MW3myvk5/fonAiFdhSm07LX27gQmIc/nlb4/01P5?=
 =?us-ascii?Q?pTQgmMxpPbxMPlnML9HlXb44YVQp9ZqXpw/wQSW2q2s6OjMkhcBzyfuhk25s?=
 =?us-ascii?Q?3BMsoLCiIKwWrAr9F5FwZfAu9c7JOVjf3m7DYs4nBV2AWO7Nt1NZjy5J19jC?=
 =?us-ascii?Q?i6khcl1feBe7LMjOpqQblI3YlLREyG6LhIU8nkzBq5bB5FtVLAZgtNE9G1UT?=
 =?us-ascii?Q?knYMecF7QyMNx4fYFuJ2a8OGOmjl9xLrjVL3RsMyyAb5urDWMuuvlMXPx+hU?=
 =?us-ascii?Q?s3asQpuFJcuCEtpK5OMUEFHD7Qs1mUVd/KqKGbLyi9QkIEKvVzO2XeVHErL1?=
 =?us-ascii?Q?7qDLBN1n9+4Hv5M0M0MHs+W4tw9Sje36phb5UL4f4VXf9HXeMe4D7Y2Adr6e?=
 =?us-ascii?Q?YooMk6H/SfkHtQeh6217F3Nlkw0wpjRG6EnW++xrgXhEBhoya921iOL5Uhp4?=
 =?us-ascii?Q?SNYke5D/L0wbZ0GlMNFY0B0hilIsRPsaoDcWmxCGCL9gjEXRqS2n5MVb73lI?=
 =?us-ascii?Q?mqtRjPBBUSyxUbs0+eGadRdSIBHny7/GRwh7PBeKep/gsPTupgxAS5X/9yN0?=
 =?us-ascii?Q?7/kyF17xsti30eESstQbxCiOrXbzYetxHkCGwiCnj7eopwnpPGk3RQ0SYvLf?=
 =?us-ascii?Q?PNkIXwyt8RQAppYsSN49HrohKMupryfRm4PhlApEzX5JURn/Us+GvQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?C+9cnYgbAspgwGVsGo3AsgZoXBXYOUFoeM0GclPbA0udPGwuo+NwPejGut4P?=
 =?us-ascii?Q?4leaBj/uAW3ofnliUB5WkId8MoYN8EYBd1cxh9FxqmIe+00kiaGY1DNP+ykH?=
 =?us-ascii?Q?L48MiADn0UbZQ2J3pLDIkQHCh9eO+sb/gbkKJbH7bODU4RL1Kvr9wR5GtY9v?=
 =?us-ascii?Q?0Z0OqPrjr+AgWjjGZjmHP9ltgQqWKQkU6JeLEmBh/qGpF1g8KyRVKx2CC/lx?=
 =?us-ascii?Q?U8TXgDqjqWY+FXzeCjCgl0Zl7gN1PHWgamQYFzKE+Snh7/ks6Z+H82AE7+IH?=
 =?us-ascii?Q?zKJMfFw1FlmCooncXZAEV53aZU+0jHL2QaQV6516AGjFYmnveGU1hzXBU3Ou?=
 =?us-ascii?Q?RG4vLmKhjzxOsbAccHvlyE/ZhealpTBYBjkyefCuig+0PZ3hP2z/b9jKoq5F?=
 =?us-ascii?Q?GIDlOkdJSal8EUvRoR9m9Pjhmps122a074GSikwVSonzhMEfMLuF6uF9XRis?=
 =?us-ascii?Q?1UtE+eYBExPKjBGcqe/5xrzNMvBK6kIW6hqdRFjKfU8SjJslmkqOtpuNAWCJ?=
 =?us-ascii?Q?yOpserAfiUJ5ZacTCqWJBKuhY9hlSPSvyl4p/u7JcjcnljyOiKYN1PsDCuMS?=
 =?us-ascii?Q?QkFGDY0c//K1/Fg2YnOZMJWKgNhE6eG4T+dvPgaVYVJ76KxiomXUdkkmRzFW?=
 =?us-ascii?Q?TF1q6kSQpWuaK2rroAVgSUwh3rx6rGdaLLQ4LXSqBsYIQpvIOKxJm3aohpUh?=
 =?us-ascii?Q?eA5G10XzehO8mV9/we3vh+PrpMDUsWZ8zpevF23YXw4Y4xhY1shUEuxPzI89?=
 =?us-ascii?Q?jvK8PKkBfq8y+cyz+4A+PHq9Zd9nODyxhhZ6KzvzCcVhnLNjNbG13QWNG+5w?=
 =?us-ascii?Q?WlCdhBJdaMDzHENqJ51uui+z3DlKKDxwYsL4BI7fOm/bTWO8d0idDn1/0LrK?=
 =?us-ascii?Q?tvu0BaQvc6okKkVk1ZlGIK2ziI/sqSBzt4vcrDIjgw/AY8Eb+QLv/PCGvPy8?=
 =?us-ascii?Q?XgzY7tQeAyq+l2GzE5pMi4UAjBFo0U8KBSwh6AoODKFOudUli/LJfb3xzDhD?=
 =?us-ascii?Q?tpVNijDBhkY+M0kl0mKSNLXCSdXJmwheaIKXCBO6lKOIHYv4ovMtHTRv85mN?=
 =?us-ascii?Q?8ZniV9yx0G9p2q8r22XM3VXAaCTgQSEMPrJ7tdXqlaUsZk13D3hnTFvxpkeX?=
 =?us-ascii?Q?FBmdnU6jD5AwTCfw2Nw8q97PfmWliUn0y/Un9eWsFxRUs+U9R/0mFsD3CQ3w?=
 =?us-ascii?Q?mrVFkHikY/k6SuUl44GhQ07ZmLv5wyN4ScypU94o3uxTwT9KA94cYh2Ud1OY?=
 =?us-ascii?Q?fKjEfx0zA0ZJc9FkP2GUS9eLkkrJxAVbIEIRfqj4qKfhh5+9k8i84uXZT8kW?=
 =?us-ascii?Q?8y/q1B4kB7h8grT/qWSOjxtoooE/Ol6U6ihUFa2yjOQP1EIHC1SqDT/wS9gM?=
 =?us-ascii?Q?0Dw7VUkXC0NxHsBVF3K9e4mnHSIl1uJrCRXG7z+Q/AhAaBdgRqP5XA6qSeaK?=
 =?us-ascii?Q?XlsqDdQrkUf0rx3nYt3h9GTH1reKAzfcxdKPvmsOO/U3WnLVsNpPimr0JxWE?=
 =?us-ascii?Q?wuTLaC2SY9nDu9Gs9wvBrOigf1CoIKSb+/FLZTRoUEEcpnYOnOspaM6pzE7m?=
 =?us-ascii?Q?2VAy62/nHMZ4sp1QLeL1BA9XEfd00F3uoA44+Ko+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 391abbf1-1fe6-41be-2300-08dd76bdfef0
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2025 16:54:15.7929
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8rz5i0Ab9iAvTzjn36xVLHuZBuwLIA3WDJkr3jr2jE+q1l0QMiIy26SkA3ExsSZN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5971

If x >= PAGE_SIZE then:

  1 << (get_order(x) + PAGE_SHIFT) == roundup_pow_two()

Inline this into the only caller, compute the size of the HW device table
in terms of 4K pages which matches the HW definition.

Tested-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/init.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index 3acdbef8fbbff2..13b5f83e642369 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -243,14 +243,6 @@ static void init_translation_status(struct amd_iommu *iommu)
 		iommu->flags |= AMD_IOMMU_FLAG_TRANS_PRE_ENABLED;
 }
 
-static inline unsigned long tbl_size(int entry_size, int last_bdf)
-{
-	unsigned shift = PAGE_SHIFT +
-			 get_order((last_bdf + 1) * entry_size);
-
-	return 1UL << shift;
-}
-
 int amd_iommu_get_num_iommus(void)
 {
 	return amd_iommus_present;
@@ -1595,7 +1587,9 @@ static struct amd_iommu_pci_seg *__init alloc_pci_segment(u16 id,
 
 	pci_seg->last_bdf = last_bdf;
 	DUMP_printk("PCI segment : 0x%0x, last bdf : 0x%04x\n", id, last_bdf);
-	pci_seg->dev_table_size     = tbl_size(DEV_TABLE_ENTRY_SIZE, last_bdf);
+	pci_seg->dev_table_size =
+		max(roundup_pow_of_two((last_bdf + 1) * DEV_TABLE_ENTRY_SIZE),
+		    SZ_4K);
 
 	pci_seg->id = id;
 	init_llist_head(&pci_seg->dev_data_list);
-- 
2.43.0

