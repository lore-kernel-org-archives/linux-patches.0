Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2071.outbound.protection.outlook.com [40.107.236.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6125020F09C;
	Tue, 25 Feb 2025 19:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740512402; cv=fail; b=sSaHjpoeCdnyZ2Bk48t0xjc+SQ0X3SKq/+N2StzsGRBo6pScgS9B4zI/k314+Xgk4/WCfACsLIhlVtOVPZ6DNJxPBWJOHNJylBqnMPhs07RNpqxkQk/bmXFiTTwYFZQ+790DVxecG8OLg8kzcrhHO5wirwIkqCOz0v/ynsf3fHo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740512402; c=relaxed/simple;
	bh=heeqkt4rM5E8R00hhBHM8lMmf24Hlp4TnTjfBGlaSzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XCSfLC2Mu61tJnl4FcJk6+3tjzvtSpseLpEyuyvjGK4SQd2iLWpdRkT7yd0JUYHm3w+yf0hPLQxV+5mBYLxSP8kHhlNh1jMzDxpMt/Bwiz/NQPb5aSz90DZwTmEnHmJs+cWl6/DPLoUZHUeTJ+wqJkSlxBGe/FL9BjlNgz1IuRQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hlfys3Q7; arc=fail smtp.client-ip=40.107.236.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hlfys3Q7"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yxDXr6/TmGgY7HHgvy+CTOK/8GFDkKheq2zLdRh3BrlapvfCOTQ7GBViySTFgcnIFZtRg1sTExhREFQ65Gnt1j9PZ26jjxHOqM0Fjy+X5SRo0XK1auE5Nm9FOVgpOCKo7pBrSiMdd+a6SB/e+MCyazQA3C+g+3xUkqBwyD5GBEqg5rY+BOuqDzanB2OzuGMgtVgutexdBIpBkF54NrUodR7WOv1q8QgKLCc3fUaoQnnQ03ge4NBr4ILyHUAv5yxQnWV6s8O/6z2TsUMl9v9H7bFkpi+9wvVoEFVrbPVlY0kK2zdTlIpLCvkgXPbmOxQsuifMn3sVdPLy/krZlS1zxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nisvBXgjfcBDPPgoC4zvixk+wTAE4AYi/W8wVAvqWt0=;
 b=sUBCkS0y44g+OQm2/2YkvKNCW5CyVyNYbRLjcLD+niP6gLrF2648q3wehQeRF8E51laPow3vLpoyNfozBOgOKUCGz5LxaFtxW8r7aSJ0neOS/AvlBAjLbX1ZV/ZGGWtQlC2bKqX+MmmFPx7mL8kMQXzbGg8H8ruhw1HRXazVSigwNfSDPkkpOUYTfVyFRiEVC8ww9ykNSRzR2r/p0Vf29dHAjyJ9C7ms4NqL3V9pqbBNJw5tvEP6J4jnC6+bEeVy2qIYWTatFHhkH5HOTJCOdu3j51jYNn9N6SWlTBoxCnZDbLZL3OAIm2MhKEJ+V2/OzpM1OZNB4ltPDce+Bdxtdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nisvBXgjfcBDPPgoC4zvixk+wTAE4AYi/W8wVAvqWt0=;
 b=hlfys3Q7wrS4h1+gltLgueZMJNpYSubjrny5GFH4cQQTLe+7KcehK/XfKkk8R6O7oYSQNF5RurMAGDv8t1LJsFM9oYwGovrXUSfFN1UrRNgSxLQVOoWiYVLfoxUKnjd05D5VnpCUovuMFa/j6hIH29J4+h9GSkhQ7uVX73ZC5YSbxA065l/oP2Lmg3WaYaD4FUl88fOqW0UM6lM2c1MlJerN8vDNcclOy4qIhc9GemJ7vCXcDnapbMJ5fnKEzfFc3nOF7Bo+G9RwiEaB4mmaT/U1ZSOlHQhO2/PW98NXLnTe0/GTxYjH138wI2WH7SJYP+ERSAToVNIsypx+MztOsw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by BL3PR12MB6617.namprd12.prod.outlook.com (2603:10b6:208:38c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.20; Tue, 25 Feb
 2025 19:39:51 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8466.016; Tue, 25 Feb 2025
 19:39:51 +0000
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
Subject: [PATCH v3 22/23] iommu/pages: Remove iommu_alloc_page_node()
Date: Tue, 25 Feb 2025 15:39:39 -0400
Message-ID: <22-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
In-Reply-To: <0-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0060.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:88::27) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|BL3PR12MB6617:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d58e47e-6eb4-4ece-2c30-08dd55d4282b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?LDxxDP3oBBW6OmbR4KxSrbRQGt89dhIL9ygNKQLAEzT7F2SDiIDncbxOm0jA?=
 =?us-ascii?Q?gMCxfcX9c+IZsjPqcSPgpDz6RH5yvWfG55g6wpvEzYqMTxfyy8ojMq9wIC+t?=
 =?us-ascii?Q?hDKg1DQdTJrBtZEGZgnni4BuEMj06Aj4cJlprd1KpyfuysZLhISo3/lyn8ss?=
 =?us-ascii?Q?w4x+jQL+xbeP+qWoM0X40fgT9i4ot2hC4j77DMmbd6LrEAko1J0BOd6sgYXn?=
 =?us-ascii?Q?kcdUrcNgIrmw5S60pced6SiQk6WzaTaLijya/VlHLtcp76odz8X7rLO1E8hK?=
 =?us-ascii?Q?BpqIBoe9M7ReniBPWBe2Pbfr+D6ixf+48cI0O8V6V+RkzxVUMrO02YV8Ztqi?=
 =?us-ascii?Q?PIxVYmhihh8AHRNZjR9nyU1jovkqw0/ceYa1uQ+OqIj54VIF3WgRT38sC2m7?=
 =?us-ascii?Q?uPnVs0hJj7EDdEx9DNsV+D1ocRHsbFVjzapXSHYmKz69/ZIzRO5vs7iLv5yk?=
 =?us-ascii?Q?cSfwRn6pJI7A+wwetxQTg4O9slrVbxw47wJca4tLaw7NW+82sHXOmnyr71mX?=
 =?us-ascii?Q?iEZaUATxw7vFp0KqP38sHWMyFsnLxMFW8/kL1rSKaK++K8MtrQxXV/BNvfRN?=
 =?us-ascii?Q?434pbMlpq54DXr6J7PjTmSeIBfWlMrYms6f+l92ELlt/PuBt3ZBTWQK4Fpbf?=
 =?us-ascii?Q?W0zPEhA2/37H6ajiscsUa/00iVNug/s2bGb4D0hI1Ecvv5UnEDp5uvQeucqx?=
 =?us-ascii?Q?RuwZs2lKNmjRzRoQUHS1nF0dnaBupoCm2RGmMqvRvX79iHuYe5qfKYSG6Ps0?=
 =?us-ascii?Q?bDxRkvdhUXAvxeMub7feg4Ov9YFLoK4QcPW8lW6bn9L8j+hhktdKHytyubss?=
 =?us-ascii?Q?zlVrpg4e67L9wU+SyRVZN0YIYUh79oR0PfQBGYVvLVYNf1O+TcC2R3l7yAnF?=
 =?us-ascii?Q?aUv8WsR/yZ3soD2JZUt5u0zGawddshTvHFcfFe3XQ/SuyBPyscpbz69Juv3X?=
 =?us-ascii?Q?4A1g2hGZFJ03t9r/ZoElynuV/PypU/BZ0apH2YWzxKO2JrcfVVpjrLWYBJ9b?=
 =?us-ascii?Q?jDwPKkweECKgicDkamOkwj5xed9enroYRb/e0NEmwjoRv3ldMku/UN0pKMhS?=
 =?us-ascii?Q?at8gWb8TK9Fmd9ocYUtJOMM4dNaAXR5PmfeaRu2mL5ihUQQ+JVa8J4QXyp6q?=
 =?us-ascii?Q?q1i+3y9VOm0o0wXB/G5sDcLXitS7CcYUB2BaSoRoBacuDNTvMpWUyon9/juf?=
 =?us-ascii?Q?uCc4grXoWHRlozyna/5Yo31ZzZ56nPLrp+DEZo84j++pgA045Fc6NocZTlxi?=
 =?us-ascii?Q?T5pvOXrmJleQnzvpkPzaP2qmJaXZBcwatSRnLMbkhcfr8S3/XYdl7Mq6/U8a?=
 =?us-ascii?Q?X1GYFMVbBeHzAy9269VUyc1FY7o68PuaLtJvnTpVz+b7xBxIF+rcfcAtyLwt?=
 =?us-ascii?Q?TbeJduCsM3BlfjFjTtxDUaaOeGCvqRhUeq8uUZh/AMwQ5Dr1reB9QioE4xsz?=
 =?us-ascii?Q?T5uOmQQkLVs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?z0HEB49qmpPA1JvQMKV6KqbTYeqrV7g4qENy6z4Cs6vs5g5NMy3EttOBskKE?=
 =?us-ascii?Q?hwGY+YM6aTdwq9jleqE6JLUWZ/qeRZdzWwQJKW2BKCBHNYnpQgUFvj0teV3Y?=
 =?us-ascii?Q?VaE/gncOqqME7B3hdHhmTTl5ytWmm1LJNjaO1tu6MfstIr9FHKArytvvVlqU?=
 =?us-ascii?Q?6x9mUeEkroKbqhG0kOMDzTwPgu46tIznGqJduBZuj9S7/SM1h2orHPV6Yt/y?=
 =?us-ascii?Q?LmhfNg/IqtgHZXGDkusywAZxx3BAyCyZar3mThfOB9OpMA7TRUMbEIu19iuB?=
 =?us-ascii?Q?bqqPPg4+XK74Bk4S+E5GXXJWG8IsSwR5mwIyTYzsXHfSwCNo/eSYZn4tnSI2?=
 =?us-ascii?Q?7gPCeh4eEjkzdl8pkljP8JiXd/xIuf8EdEjUWEbv+LbO/z8Uuxr+/VIkKp9M?=
 =?us-ascii?Q?FCQCx9AHJmZGOQdjoyNb/25SllOjVcVVRYTthzDB45QxBTUv05bx8VcbYX2K?=
 =?us-ascii?Q?m/gVm4RmrjCTWM/mkw2rsz5FMQmK/KIz7B3hGq4ZANoiZaoFxFM293jcH1KG?=
 =?us-ascii?Q?/J+OvwuE/gv2lRaW9bjp5bu9OM5KXvux+fTHMMEJvl/Wwq+q2E613MN3vFo5?=
 =?us-ascii?Q?/Lqn+GxEG2M8hl+YUifc6R81n6iJvos1SmMRTQIGvqSOCxTD/dNXFyLhl/MK?=
 =?us-ascii?Q?C7dmhx3Y1rJbHon4PVGKK9XuFidmyeDSLOQpt8X5b9TflKOO5qZbkf/qGp81?=
 =?us-ascii?Q?pqHtaEbSycUVHSIm8/gWnnlOcDuGGQ/1uGH3x75Cf0bqBEAlpkjrlA/u22Y3?=
 =?us-ascii?Q?/+Q2oxxGq6xJ/MVtO4RJI1EI3Eig1Bz9V5xmjWGhKx4gaf2c0QVjY3mlemPA?=
 =?us-ascii?Q?sAYgR1mA/0B21d2c3+6Fy7aJ1TOYlywfNB6WcuaRppbkxiaXfgB81wYDOk+J?=
 =?us-ascii?Q?mYbyHPWO3dUgH6/1NKGqhfCRTLYBJECnRf2zNL8nVBs8ypMWrjV6NmzXOW2S?=
 =?us-ascii?Q?3GW686xh86N1fES01yIq3Fei1flkJGRacLGvDWRFXsnFYCNHavo8vgn3I6QR?=
 =?us-ascii?Q?rRzzOWLcRz0GzB2amioPDYVsJd1nF+AhOKSzbw0lfH/0AHNXd4GJxD8REllm?=
 =?us-ascii?Q?FdsuVexCBg/9mWBbgZ4dfDowBAPIgGI7rBYcdYcUcfaMcgqQMpr8ha9jAXhn?=
 =?us-ascii?Q?cO0FN4Q1uufWEdXq8UDZ2jH9FCkAI6DnBNu6qievGHZQNkTAb5Xwbi74kglG?=
 =?us-ascii?Q?4xafKZkVeyit/qWuPpnLQljoqE8wEM6fGzxIYJSX1lktAxFL4YKOdsuoRT2b?=
 =?us-ascii?Q?r2VlCdk4a3a0gM2qBCsg9WjAjtIBFpgGYFGqeMHxC0q6rNRJqBUHpcIyoy33?=
 =?us-ascii?Q?QfMlQ9CnowAmpG2FUKK0dMEu2OumwCVoOvh45WqDBETWBIC6qGpbYFF7F6Cr?=
 =?us-ascii?Q?SakAkwx7aqpcT7HcUR+ADrRplj68NhTAVt8zxcQ05KBCT5UXBaXV/LLocKMu?=
 =?us-ascii?Q?2kEKVoYG/wz1tDTd3R77c8fV32Yc+3AG3ke3FkRa4NYB5anPCqcBubuDKSLm?=
 =?us-ascii?Q?h45W5YNsiPetedoq5Egy4YwjTqQOXQGyWJACPJwd/0H0XlhsBsFYN19Yu025?=
 =?us-ascii?Q?ZqjnW5swNITKH+fNFi9j9WsfnRAAna7YyUqXKpo7?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d58e47e-6eb4-4ece-2c30-08dd55d4282b
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2025 19:39:45.4744
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nE08dkfvWCDuf68NrAqJX2M/APbX+dXBFQszOqrAPnjS7s08BS3QO2nQiylyTiXc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6617

Use iommu_alloc_pages_node_sz() instead.

AMD and Intel are both using 4K pages for these structures since those
drivers only work on 4K PAGE_SIZE.

riscv is also spec'd to use SZ_4K.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/io_pgtable.c    |  8 +++++---
 drivers/iommu/amd/io_pgtable_v2.c |  4 ++--
 drivers/iommu/amd/iommu.c         |  2 +-
 drivers/iommu/intel/iommu.c       | 13 ++++++++-----
 drivers/iommu/intel/pasid.c       |  3 ++-
 drivers/iommu/iommu-pages.h       | 13 -------------
 drivers/iommu/riscv/iommu.c       |  7 ++++---
 7 files changed, 22 insertions(+), 28 deletions(-)

diff --git a/drivers/iommu/amd/io_pgtable.c b/drivers/iommu/amd/io_pgtable.c
index 04d2b0883c3e32..2eb8a351ca91e4 100644
--- a/drivers/iommu/amd/io_pgtable.c
+++ b/drivers/iommu/amd/io_pgtable.c
@@ -121,7 +121,7 @@ static bool increase_address_space(struct amd_io_pgtable *pgtable,
 	bool ret = true;
 	u64 *pte;
 
-	pte = iommu_alloc_page_node(cfg->amd.nid, gfp);
+	pte = iommu_alloc_pages_node_sz(cfg->amd.nid, gfp, SZ_4K);
 	if (!pte)
 		return false;
 
@@ -213,7 +213,8 @@ static u64 *alloc_pte(struct amd_io_pgtable *pgtable,
 
 		if (!IOMMU_PTE_PRESENT(__pte) ||
 		    pte_level == PAGE_MODE_NONE) {
-			page = iommu_alloc_page_node(cfg->amd.nid, gfp);
+			page = iommu_alloc_pages_node_sz(cfg->amd.nid, gfp,
+							 SZ_4K);
 
 			if (!page)
 				return NULL;
@@ -542,7 +543,8 @@ static struct io_pgtable *v1_alloc_pgtable(struct io_pgtable_cfg *cfg, void *coo
 {
 	struct amd_io_pgtable *pgtable = io_pgtable_cfg_to_data(cfg);
 
-	pgtable->root = iommu_alloc_page_node(cfg->amd.nid, GFP_KERNEL);
+	pgtable->root =
+		iommu_alloc_pages_node_sz(cfg->amd.nid, GFP_KERNEL, SZ_4K);
 	if (!pgtable->root)
 		return NULL;
 	pgtable->mode = PAGE_MODE_3_LEVEL;
diff --git a/drivers/iommu/amd/io_pgtable_v2.c b/drivers/iommu/amd/io_pgtable_v2.c
index cce3fc9861ef77..a07c22707037eb 100644
--- a/drivers/iommu/amd/io_pgtable_v2.c
+++ b/drivers/iommu/amd/io_pgtable_v2.c
@@ -152,7 +152,7 @@ static u64 *v2_alloc_pte(int nid, u64 *pgd, unsigned long iova,
 		}
 
 		if (!IOMMU_PTE_PRESENT(__pte)) {
-			page = iommu_alloc_page_node(nid, gfp);
+			page = iommu_alloc_pages_node_sz(nid, gfp, SZ_4K);
 			if (!page)
 				return NULL;
 
@@ -346,7 +346,7 @@ static struct io_pgtable *v2_alloc_pgtable(struct io_pgtable_cfg *cfg, void *coo
 	struct amd_io_pgtable *pgtable = io_pgtable_cfg_to_data(cfg);
 	int ias = IOMMU_IN_ADDR_BIT_SIZE;
 
-	pgtable->pgd = iommu_alloc_page_node(cfg->amd.nid, GFP_KERNEL);
+	pgtable->pgd = iommu_alloc_pages_node_sz(cfg->amd.nid, GFP_KERNEL, SZ_4K);
 	if (!pgtable->pgd)
 		return NULL;
 
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index e23d104d177ad9..d465cf2e635413 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -1884,7 +1884,7 @@ static int setup_gcr3_table(struct gcr3_tbl_info *gcr3_info,
 		return -ENOSPC;
 	gcr3_info->domid = domid;
 
-	gcr3_info->gcr3_tbl = iommu_alloc_page_node(nid, GFP_ATOMIC);
+	gcr3_info->gcr3_tbl = iommu_alloc_pages_node_sz(nid, GFP_ATOMIC, SZ_4K);
 	if (gcr3_info->gcr3_tbl == NULL) {
 		pdom_id_free(domid);
 		return -ENOMEM;
diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 6df5c202fbeba6..f72de7519d840c 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -397,7 +397,8 @@ struct context_entry *iommu_context_addr(struct intel_iommu *iommu, u8 bus,
 		if (!alloc)
 			return NULL;
 
-		context = iommu_alloc_page_node(iommu->node, GFP_ATOMIC);
+		context = iommu_alloc_pages_node_sz(iommu->node, GFP_ATOMIC,
+						    SZ_4K);
 		if (!context)
 			return NULL;
 
@@ -731,7 +732,8 @@ static struct dma_pte *pfn_to_dma_pte(struct dmar_domain *domain,
 		if (!dma_pte_present(pte)) {
 			uint64_t pteval, tmp;
 
-			tmp_page = iommu_alloc_page_node(domain->nid, gfp);
+			tmp_page = iommu_alloc_pages_node_sz(domain->nid, gfp,
+							     SZ_4K);
 
 			if (!tmp_page)
 				return NULL;
@@ -982,7 +984,7 @@ static int iommu_alloc_root_entry(struct intel_iommu *iommu)
 {
 	struct root_entry *root;
 
-	root = iommu_alloc_page_node(iommu->node, GFP_ATOMIC);
+	root = iommu_alloc_pages_node_sz(iommu->node, GFP_ATOMIC, SZ_4K);
 	if (!root) {
 		pr_err("Allocating root entry for %s failed\n",
 			iommu->name);
@@ -1994,7 +1996,8 @@ static int copy_context_table(struct intel_iommu *iommu,
 			if (!old_ce)
 				goto out;
 
-			new_ce = iommu_alloc_page_node(iommu->node, GFP_KERNEL);
+			new_ce = iommu_alloc_pages_node_sz(iommu->node,
+							   GFP_KERNEL, SZ_4K);
 			if (!new_ce)
 				goto out_unmap;
 
@@ -3315,7 +3318,7 @@ static struct dmar_domain *paging_domain_alloc(struct device *dev, bool first_st
 		domain->domain.geometry.aperture_end = __DOMAIN_MAX_ADDR(domain->gaw);
 
 	/* always allocate the top pgd */
-	domain->pgd = iommu_alloc_page_node(domain->nid, GFP_KERNEL);
+	domain->pgd = iommu_alloc_pages_node_sz(domain->nid, GFP_KERNEL, SZ_4K);
 	if (!domain->pgd) {
 		kfree(domain);
 		return ERR_PTR(-ENOMEM);
diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
index 4249f12db7fc43..2b6e0706d76d62 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -147,7 +147,8 @@ static struct pasid_entry *intel_pasid_get_entry(struct device *dev, u32 pasid)
 	if (!entries) {
 		u64 tmp;
 
-		entries = iommu_alloc_page_node(info->iommu->node, GFP_ATOMIC);
+		entries = iommu_alloc_pages_node_sz(info->iommu->node,
+						    GFP_ATOMIC, SZ_4K);
 		if (!entries)
 			return NULL;
 
diff --git a/drivers/iommu/iommu-pages.h b/drivers/iommu/iommu-pages.h
index 4513fbc76260cd..7ece83bb0f54bb 100644
--- a/drivers/iommu/iommu-pages.h
+++ b/drivers/iommu/iommu-pages.h
@@ -114,17 +114,4 @@ static inline void *iommu_alloc_pages_sz(gfp_t gfp, size_t size)
 	return iommu_alloc_pages_node_sz(NUMA_NO_NODE, gfp, size);
 }
 
-/**
- * iommu_alloc_page_node - allocate a zeroed page at specific NUMA node.
- * @nid: memory NUMA node id
- * @gfp: buddy allocator flags
- *
- * returns the virtual address of the allocated page
- * Prefer to use iommu_alloc_pages_node_lg2()
- */
-static inline void *iommu_alloc_page_node(int nid, gfp_t gfp)
-{
-	return iommu_alloc_pages_node_sz(nid, gfp, PAGE_SIZE);
-}
-
 #endif	/* __IOMMU_PAGES_H */
diff --git a/drivers/iommu/riscv/iommu.c b/drivers/iommu/riscv/iommu.c
index 8835c82f118db4..bb57092ca90110 100644
--- a/drivers/iommu/riscv/iommu.c
+++ b/drivers/iommu/riscv/iommu.c
@@ -1144,7 +1144,8 @@ static unsigned long *riscv_iommu_pte_alloc(struct riscv_iommu_domain *domain,
 		 * page table. This might race with other mappings, retry.
 		 */
 		if (_io_pte_none(pte)) {
-			addr = iommu_alloc_page_node(domain->numa_node, gfp);
+			addr = iommu_alloc_pages_node_sz(domain->numa_node, gfp,
+							 SZ_4K);
 			if (!addr)
 				return NULL;
 			old = pte;
@@ -1385,8 +1386,8 @@ static struct iommu_domain *riscv_iommu_alloc_paging_domain(struct device *dev)
 	domain->numa_node = dev_to_node(iommu->dev);
 	domain->amo_enabled = !!(iommu->caps & RISCV_IOMMU_CAPABILITIES_AMO_HWAD);
 	domain->pgd_mode = pgd_mode;
-	domain->pgd_root = iommu_alloc_page_node(domain->numa_node,
-						 GFP_KERNEL_ACCOUNT);
+	domain->pgd_root = iommu_alloc_pages_node_sz(domain->numa_node,
+						     GFP_KERNEL_ACCOUNT, SZ_4K);
 	if (!domain->pgd_root) {
 		kfree(domain);
 		return ERR_PTR(-ENOMEM);
-- 
2.43.0

