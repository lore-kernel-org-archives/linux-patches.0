Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010025.outbound.protection.outlook.com [52.101.193.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D3A315B0EC;
	Fri,  3 Apr 2026 12:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.25
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775219214; cv=fail; b=BhntKTYNlQaRmmOcAczXNEE6DCoY4ZmkcBw0Mu75aOLDxG04sjmSaI9u4kQI0FNinRQWG7nmO6E/gpGwCCElU2I8bfunncJqxJls3vwa4GfFfr4HNEb9f/ZVdZ73sJXOl+ELj5J+h/TFagCOlegVG0PGUmuOKKBWoq6eYzAcctI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775219214; c=relaxed/simple;
	bh=ld1as4LN4yPqmREjEgdVkNbwIKrJbzizKFP2Uqd8KuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=btwI19PVBc1o35m2lN6SdkWtYleAalS/ePH4r7VOa5WSNVsIdmvI8VgfA1pF65qUH7ZxG3cTTdQ99BGOY6nLqdqfunxi9MbMOKztgNXXNfiPhOaCBF+bf8gdOHkjPS6RrdavpcWeixMXTEwGVAIwlaF495Q3/7PQGs7Cgad3rCI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=TjlaautL; arc=fail smtp.client-ip=52.101.193.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="TjlaautL"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AnI5SsWPNeqXsRt8jcR0y2aNqMFKN9hCMJxAZXUpcTnv0EF3+8JVsjo0nEvF5DPODvm1yW0686CKa1qHAHiU2NEn5lDKRt2JVzXN+/KKMpEcVCkWVQuIdZpowAcsI62/4eexrH17XXr94CHS8Am8vURPrA8rMAMn1BPGZrrmPNP1IA7qS1r8fFAOKwkeOM4Khpoc8VnBGACgZ3AlSqYyYKjrVSBS6omDnkxUtPoWVUv415PYTXXYo1ikIoc2fDT5mhDkGeo+JMncrf54t1/7IROfxW1d+yG4wIYZqZbbkNKayF+SK7D19PFDgkomY3smBug3waiKIoITnzrAJDasWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/FHohmUwVp/9kvhMKpDi+I130MLU/BqS+pwZIIS/3Wo=;
 b=ZmfQHl7RWUcelv2DkSPTwVtaTCMi88tFSXI/ICO8qrI8nihIn7SVEPtcew9Fjud38i9BerobIUGODULGWaNEWstTv/pfaB6JJ9zwGhNXtUEQklbcWjCWQBb9p4W45JsF7n1Ul/fEYlNREJFrKUtw1j99XfYVjnI5DwDn3dWQIQA+/FNXUR+FABmRU696ZhZN1+KBB8rI6lJX0zd7kLDi9rrTqgwXa0cCH3adrW9a94X2PHEX2Sif2gErIpcGAMrWEnqA3BLyaiG6YmuUlyKIkbPnjEFYM7cV6rCdgOMNrmGaMLJv1g7QJr0ZWXahpP+1T+LcNsd7tJ6RCFhzLW7sXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/FHohmUwVp/9kvhMKpDi+I130MLU/BqS+pwZIIS/3Wo=;
 b=TjlaautLlW3iBoyWXQASyT/P+LdhRHniY/aMJJrRRywu3QrCiLlCthF33RfJsaN3iGhEPy4S0a3bSl8afyakqdYaYBbP9Iu2fjgf0SMUFmeRcZmrDqUAzNPvTqHtENSk3g8dhUw+Kc4ic5eiSQhx/JMUoxLgbnfZEAseRCjbw5K1coErL4A5MmOLIC3FmBrSQETtIzn27GN6T7pIRKbTforT4le0kAqKdo5TzenLyOQvttvQtdBdcadPHltSqBOepECktt8SMoU8u0hsAK9XygBrudy/ww2JWzjL/WGc39frdvZ30pjrif74hkrzTZri+CQ2F4JfcGP8wrTvOciI1w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY1PR12MB9601.namprd12.prod.outlook.com (2603:10b6:930:107::16)
 by PH8PR12MB7278.namprd12.prod.outlook.com (2603:10b6:510:222::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.19; Fri, 3 Apr
 2026 12:26:47 +0000
Received: from CY1PR12MB9601.namprd12.prod.outlook.com
 ([fe80::cd76:b497:475f:4de3]) by CY1PR12MB9601.namprd12.prod.outlook.com
 ([fe80::cd76:b497:475f:4de3%5]) with mapi id 15.20.9769.017; Fri, 3 Apr 2026
 12:26:47 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>
Cc: patches@lists.linux.dev,
	Wei Wang <wei.w.wang@hotmail.com>
Subject: [PATCH v2 4/5] iommu/amd: Make CMD_INV_IOMMU_ALL_PAGES_ADDRESS match the spec
Date: Fri,  3 Apr 2026 09:26:43 -0300
Message-ID: <4-v2-90ddd19c0894+13561-iommupt_inv_amd_jgg@nvidia.com>
In-Reply-To: <0-v2-90ddd19c0894+13561-iommupt_inv_amd_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR01CA0048.prod.exchangelabs.com (2603:10b6:208:23f::17)
 To CY1PR12MB9601.namprd12.prod.outlook.com (2603:10b6:930:107::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY1PR12MB9601:EE_|PH8PR12MB7278:EE_
X-MS-Office365-Filtering-Correlation-Id: 2cf0f871-4779-441e-786b-08de917c4516
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|18002099003|22082099003|56012099003|3613699012;
X-Microsoft-Antispam-Message-Info:
	i8aEg9OM6b8r8FL0xZe0UDcq9IHleEUf5oZszaXil1rSrY6zWLCkjosgcVM2731Jzk94dSt4rHn5rvQvdyn7KEBLMJh+f2NgqkRC6V+6hIfY1IhW5rvm5IfOml0B6qC7ZE+9SODVo0lihkYvSACGNHreGkqutxCcU58Kvouyrf0yO1CzLa1W3GMp78Qbfx1bA7eMOyqKEw1sBNYPTxIZXNfyHmzTUysyizK6k1Z9T+qcGtwoeeUQiBdQClxsvKLsLf+XgvCNLC6UA9+pVmKTkMXjJaE5H/9P2d7obfDWfVfazWtAJQYS2RzjRK0GHT/WIyupIUxyDTGyeFHUQ74yksYR7rkN/5p0VtvkhYrmAozxEmc/XpUAG45AHhjf9yneR9pGgP5fHlp64S83SUSn9b1tO00SLq2WguL3n0VzCcBhn3hsW1S5L2mCh+ngkWGR3Cuu+pWjpN1xcbl6NqU9OTv/+P+lIthtUUkiDap/KYXWwaiDyAL5oo/thwrqmKKlTjDypqVwrIB9yEExYc/i0HH33u8IZ08FCsUP+gOIxgKdjVtbtHPsRUQROqi3Xwy7tFiMXIZMWsf2ndmv1TIeH7RS+5Vjv9vYY2bEAPyTHuLiFBqFR5Fohm/CZe20vCT7FGRien4TjPdYFe+zkDE1IhCJlRjVjia/zS0pr5rTOqB3K8ntfOF6lsug0MeX4XYf8zdWMb2EwpavqfN9L3IRs1MovK37zdq4EvypNM5Fn04G5UhKO19XS2ge3wxwTt9PQ4s0rM5/3rxe5cbwUH3lotwCp0abuWOVYG4LMrCJjFY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY1PR12MB9601.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(18002099003)(22082099003)(56012099003)(3613699012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?u9v4mhz/FEMPFHJEvRcFEmHvK20zZ20zxh48cEMNvPcg48qPCkYdwuVVx1Ce?=
 =?us-ascii?Q?7fndovW1+d/WHlR89nj3/2jJ96ojf026bQ6lZRNMqBaQOLiEPHnUuJaLmZ9T?=
 =?us-ascii?Q?hehdgUpM0vI3Go8j4T5AC7Jih5w51aDDS6u1EDlLe0mJ4uclTJEdyZwUwXgO?=
 =?us-ascii?Q?8yn1HJWnQ1krECJisC3lgKOoujpMOiZv/ZXQqKiS4M8Rv07SHj5FqppQAcTX?=
 =?us-ascii?Q?e7AmJXqGS5JBxxwPLqG4iqBXtwZa6ishQeu4eaET+O2b1O6rcvuK5eNQkSBi?=
 =?us-ascii?Q?zzIJqXEA45Viml+v6BihAqPwCp+H6erORhRumBWwt0St16X9xsXZZHcsYiHN?=
 =?us-ascii?Q?Rbx20nWAXkUJgJHo/wlSxQZuNT4uQAsVhciZhFMZiPD6B7MhJMA4ORNlKf4m?=
 =?us-ascii?Q?UFdSb6fDQ+zeSITU0KvS+vifW7fF7ZOwzd1qhYuk3kPzltFGyMyFaH3mVoi9?=
 =?us-ascii?Q?GZ5JvVwqwy+F/lwMlKNBxDqVQsQ+wALD8z/WX/3+jn1jZjmhMXYCUM8KszFi?=
 =?us-ascii?Q?kOCN/uVPMQwLibpE/m6iI4pgdHFpZmLmdNFw0ubMINYqQRFpfVh/PCtQpCbP?=
 =?us-ascii?Q?oaS5vy7HSYFxRzyxZk0FEG1PtHXoZsCDRE3XMvQ8ml2sjLfEb1sTpNiYHgjK?=
 =?us-ascii?Q?Evwr4ZmAh6wEc8//Wx7lnr7I62rpHNLgipsD2hz8e1dR/4qG+ZN5rC+K615G?=
 =?us-ascii?Q?RRO51T5sY/1LFEnX+lj2NvVFufgGccd0LfaGDM4Oe3Ur9e237qmJ88NXO33+?=
 =?us-ascii?Q?zsx+fzY/P/QwW0lxwHDEHRuhErQwtkpHYXyxlk4A7tbQQCBz5kTS3vDhofOe?=
 =?us-ascii?Q?MgKQMsjJWc+4Mv8aN/RzYqKCXz1lyW084iuulkZ/Vp2QsAR5MgOoyD7NkwwH?=
 =?us-ascii?Q?E3JXw16w89nbyS+MZgGPl2REN7tqas4ItR44yTKdxE9k1rdwWcIkOjD2CXU8?=
 =?us-ascii?Q?82rL+D4q9mVJs1sdHwDFrvDYiZB4CaZrVTTNV2zpE9wdCKpdjcCM+LcxlkjK?=
 =?us-ascii?Q?qSHSClKoBsydwOtX9a4gZBB7xUWmfZu8B9uRGM1+ex1fyhi2IOZIz7UO0Apx?=
 =?us-ascii?Q?VZ8u3rRNd+qiYhhGHWftVKw15PLdbLJ+cuVZ9XIMejm7W7C0M5WXntlOmMq4?=
 =?us-ascii?Q?gjm2uY+bRmN0/nkPLYMnzYLsD8RY6Xz8fgXw/W0n/AQoO67zNNYk/WQ2R9DS?=
 =?us-ascii?Q?yjwcC6nw2F2SnTSvgKoBIkcBUiPMsVsf1o9nTdFbB9Mo4HnWBrU+XCIQmR0Y?=
 =?us-ascii?Q?gzmaqRJ+SkQn3kyu0wparJsbLm3ebs6TPcwOIZEm8+Sx+wsuPoDkFmWfT3n0?=
 =?us-ascii?Q?U0tF2XhM3ElEkk/vUfzbCjijP3rlUofaCTAW0k+jU7ZN+iCcSHLdAzihxmGy?=
 =?us-ascii?Q?fl7gTA1pxe/rDYaF3eSCi4K9BzsfwmmN/l9R5+EpUP0UM0RHkMnc+n3ORmgI?=
 =?us-ascii?Q?xtfyV1+yYPH8OnutL+WZwSiEdIqODuLM9zcwRsLuxVH8wkMOqVcgZffOKMCQ?=
 =?us-ascii?Q?lQOLJQF1f5eJkaC391Xiig4oofaKCzLpJQLZF1gJi5kwzbo9c6i6FEPP5OBo?=
 =?us-ascii?Q?a6qVNu0fNZBZFtEYOGFEq/QPIlWvgxbcKVTyqXNL4nGHFiLi8T4N63CHk0Ug?=
 =?us-ascii?Q?5iIwnwEOq07o0QjSFCX8PCt4xsIR8VPwzd/pFTW8aA23j6nP3kPlKA4R0c57?=
 =?us-ascii?Q?qT50nQ1ARhkY0cvCOjQEAunCIRKD4ed2sQUxE5Jpggqdzlg1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cf0f871-4779-441e-786b-08de917c4516
X-MS-Exchange-CrossTenant-AuthSource: CY1PR12MB9601.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2026 12:26:46.0583
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iiKx5/CG50tI/LLhs3sY3Wwjn/GWTuyWNZiYYao3gA3O8hayPwxCBSroA7xmGBd3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7278

The spec in Table 14 defines the "Entire Cache" case as having the low
12 bits as zero. Indeed the command format doesn't even have the low
12 bits. Since there is only one user now, fix the constant to have 0
in the low 12 bits instead of 1 and remove the masking.

Reviewed-by: Wei Wang <wei.w.wang@hotmail.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/amd_iommu_types.h | 2 +-
 drivers/iommu/amd/iommu.c           | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/amd/amd_iommu_types.h b/drivers/iommu/amd/amd_iommu_types.h
index c685d3771436a2..c239c5fbe47461 100644
--- a/drivers/iommu/amd/amd_iommu_types.h
+++ b/drivers/iommu/amd/amd_iommu_types.h
@@ -221,7 +221,7 @@
 #define PPR_STATUS_MASK			0xf
 #define PPR_STATUS_SHIFT		12
 
-#define CMD_INV_IOMMU_ALL_PAGES_ADDRESS	0x7fffffffffffffffULL
+#define CMD_INV_IOMMU_ALL_PAGES_ADDRESS	0x7ffffffffffff000ULL
 
 /* macros and definitions for device table entries */
 #define DEV_ENTRY_VALID         0x00
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index a058017eef2777..e3842b23481c99 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -1288,7 +1288,7 @@ static inline u64 build_inv_address(u64 address, u64 last)
 	 *
 	 */
 	if (unlikely(sz_lg2 > 52))
-		return (CMD_INV_IOMMU_ALL_PAGES_ADDRESS & PAGE_MASK) |
+		return CMD_INV_IOMMU_ALL_PAGES_ADDRESS |
 		       CMD_INV_IOMMU_PAGES_SIZE_MASK;
 
 	/*
-- 
2.43.0

