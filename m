Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2064.outbound.protection.outlook.com [40.107.94.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A3B322FAC3;
	Mon,  9 Jun 2025 23:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749513493; cv=fail; b=u9VA3VSBJclctT3woiS4PhEX+0CnK3O4T2jm1WMbzAjBBh/YuwMQg2GCAbsqi3U5enQZmm2qNQ6rOS2vvd9o8ZkTR0qGwQY3rHyn7Np2W/ekbayF3PdqLFl9Muv+nJS0zyCChvOTImzkR3x/iPcZnQ7ICjsjeWMxFWy+W+pQ4D8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749513493; c=relaxed/simple;
	bh=mwaJVb2AXrAOwIl9RiXudysRpVfuBZ5WSS1l+NsIOpc=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=IAkTwfEnunZWROXQOJqgkqaAK2HQ5SdSEM9qjULpTgDYmk++sDPnkOPghuYdgd1yoybj5H8bm2msZGxVk2DwLA5gB2cSip40gInoEl7F980i5LSHLV833OGpHyvW2FaiS86zSFY/rZuJSJUJJObl+jJqyWmuSdvNSriq+NNe47c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=lDTIIxOH; arc=fail smtp.client-ip=40.107.94.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lDTIIxOH"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yGcCjsC/sR7B5D6MKGu0GsEnL6doXpCLTag0hKohIYxOgv7dLiufqerHblQe94TCdlPrXYtSVACEAlH/w18NAmtvH2p3SuaLx1y4YcJVVLDZ9sGvTASYFsNDBPbChbbhIF2q8NvM+mpstrgakNhj2JtI25kjVnbrZkJLKkaAhcGjCSsP7ErKm1fC9/V26fJ7CE46KJ1YvrvR+d7NxIGQ3IeJ97296WtxX7Nl0vMVYvRZmOFJz6RVLhvY1l5ucJF8Ac3jLPZfyabGofcoNfuEcnPHWT4ZbbzWSd+hDAP44TiQb+Lj/k05jX6Z7eyS41s9DxUs9NcjWY6lYJ3PbTrgDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uWxkWE3zIJUiSRpDMp8BHH3pHIoHnsO+76iMBocOK4M=;
 b=BxBdhOVvLvtQe9bAuEw2GfKaXF9Wwt2/Vrz/maMnXiBHOrOHOI7156AqZvm4oVt0l8GBh7wwkUSVNjOxdXRWvS8UjZWWd+1ZXG0acpEM+ByCOJnfY1AtX3CadqAGhr/C9juBoH9k5SYMkFl3h3Z4Oj7OiMxFuxuDULV+mOfrGU1BXbgEr9g0Q6LMx3Lwa0YpnfPbL55HCIOleFMCWmrwDbFFtDboQxxMM9OjE7Z0foHUB4Xex8Ioo964V808LwMb/q2UtGGTPt7hhUUmd5F9Gbkc2wNsCqeUZmvS/dddlZgP6wMqODFi6H9RkkcEuskBNth4EGpnF0uRNovvkAg4pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uWxkWE3zIJUiSRpDMp8BHH3pHIoHnsO+76iMBocOK4M=;
 b=lDTIIxOHQrnb40HfXHLEtM7lRC+tJhK/s+B7k9/tDzYb5ruBdY8F5PZko7weYMfOD/NvufM1lGrFkFp00t1Q2ixoQgbLBoj8nV/fLy7APHqyk8vgJEhGe9y7eVmTfW2ZrPT4hdJNx02kfrF6BpzhiXEbp0cJfpflBXrrJDTqw2717sr9ypY2WC8jHOz+OPHgBEE4vzhYYUU/Ix+rJdtcpr2fhduQsr1Kk4nprGlNZMU1c2tbSoYpLExBB60x3JWoNL0MMPOiHJ/viEe2jsro+43Tt9719eYMzSVc+G9+m2gxH0VQt5q6xz25PuT5oUYF1Rieg3vqEmQpSKdYnwqxkA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SA1PR12MB8948.namprd12.prod.outlook.com (2603:10b6:806:38e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.35; Mon, 9 Jun
 2025 23:58:07 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8792.038; Mon, 9 Jun 2025
 23:58:06 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Joerg Roedel <jroedel@suse.de>,
	Jerry Snitselaar <jsnitsel@redhat.com>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>
Subject: [PATCH v2] iommu/amd: Fix geometry.aperture_end for V2 tables
Date: Mon,  9 Jun 2025 20:58:05 -0300
Message-ID: <0-v2-0615cc99b88a+1ce-amdv2_geo_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4P288CA0016.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d4::29) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SA1PR12MB8948:EE_
X-MS-Office365-Filtering-Correlation-Id: e25635d5-5dab-426c-1523-08dda7b17ab5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?19oU1qASdm3RKd4oX20dhqwuWMpTi+kpM1tbfTKyi420BQygMQVgZwRfDMWk?=
 =?us-ascii?Q?GaCeg8dOwd4uBprbangJ5ZhMFOKbHk5gtKuiCf8sBwS4X4pGuHkcPJRweo9f?=
 =?us-ascii?Q?xKPi7zU0CR3LEOwUB2s/IN6BxJI6nAtf7J46irNa5qno25ml9SMDHE4wt2Ap?=
 =?us-ascii?Q?YMpU1nyndHgQ3/vlyr13sBUe7QlA6ge+p6C+lDz1P2CwcR2I79Slo9DMv5v4?=
 =?us-ascii?Q?hgPwcOgb4sOLpN11ps7Zh55y6xbgo4fgNQ4vO8g/489AiofAfHVmbhNj0Wju?=
 =?us-ascii?Q?yq/0ZJy9YFi/mx1izsf5y5o3w2KTzKHIJcvxA4n3jakZTrq39/s0UEpUv2IX?=
 =?us-ascii?Q?twTJBEW+avIfUtSd9HHZ9U5OrF9mN3igBMacarI1LsgQZaP75ArX86Gi4m1j?=
 =?us-ascii?Q?ANhzQc6CaTBbBJNAXu02bwbf56jOVMfrzX04pnY/f+UwTWk493FYMMRzbvXX?=
 =?us-ascii?Q?BgXCvXkqfi4vVa35PYsE0uDjMiNzEOwQLLydJ00bU0JrbM7RF3tZUFaxOeVy?=
 =?us-ascii?Q?uhTl+HjTqaPXe9GxjB42HzHnYh12OPUUPfWVqLiQq6Q/kzaPiLcFQByKGraJ?=
 =?us-ascii?Q?DgDRxFgp7xENvrdpsGaOC+Ri8+hmCPMYDHi0qBXiqkQcr4tzmlpVmnY0TCac?=
 =?us-ascii?Q?ZsJWwQKNRrS55KPAeBEAI4RDj1Or9ciuookugZVdzDcvZ95nZvFYplgXVYke?=
 =?us-ascii?Q?BPl6eHijSvJCDsMzOYsG8O7+EOtqXxoyRFVJQ965qxv+IJpnhJepL7Q/d6aa?=
 =?us-ascii?Q?5Y7wmKtiqMhESTYDORVou5obQQnrS6TD6j17utPo8UjxNys5WGsLBxk2PyZq?=
 =?us-ascii?Q?rjHjnkKb5sib8Jvu2KUXkul5nR4Z4Ze864YmsDxDeeoPDPcKXHLzFH9Mf/DN?=
 =?us-ascii?Q?7Dni8hmV1pVwo0UrW6N7k2znUyBVV+SDOs1NcJmlCEL6gtpSZG9Cgbi29ORr?=
 =?us-ascii?Q?OJ8nJ1D0VI1O3dz8gRDA2KsZAAlpj7Z+tf68rs6iVoLNAPR4HCtveC8gsAre?=
 =?us-ascii?Q?jd1scXcZLAHsxuIX4rZrM1unrqfwBSyHIwqJd17ZhP5hbw3uRzTZ60pYZ1iD?=
 =?us-ascii?Q?c4MX/3N/kGiDqNFB7oZKehl4+wPQDw8wB1UZoI4WgIwg2AxxE0LJ6qlqfTam?=
 =?us-ascii?Q?1Psg/GvxV8WOrVno2ItQZ1zdX8YvYDbJfLZ69UU6N89tPp+sL7TCxIKItPEZ?=
 =?us-ascii?Q?5sHm1s9hSEAgPhkpFTSPAJc7WqYexrFC1p0yhbakoismoV/pQ/Gco/KzZeH5?=
 =?us-ascii?Q?6vjcZK00JRXeSrT6iBPOax9GniCi+nUpevK4qZ3/CovvuGEo3vsAIO56YHZC?=
 =?us-ascii?Q?QgnKZlZ36xC476v/2drDm8BPQvk5ps+UcPPs8CtEKKHYL8YZbCEy2NbTLpe4?=
 =?us-ascii?Q?y+eQ9EYxG+XmFcprErPT9DnFpcgC3WTHuPBpq/1roQbFPRO3ZEafj9bvzHy7?=
 =?us-ascii?Q?ASyNq0EqHpQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CC73igLczm+mBrFXEizm2dA1Bnwl80LB2SUf4w4/ezmWVsontajuONtFT/sJ?=
 =?us-ascii?Q?ry+rv2hkNKedDhA+Se7AKM1rChHtHT6ks1iYvEwBX3EnEP6D2yEpcY2fNyXx?=
 =?us-ascii?Q?5h9Rm35et7NRa9RFyfVXCfnnKO+UzpqB4rpcRMBQPGUogD2VVaII2IxZYp1w?=
 =?us-ascii?Q?QPwdSB3TORdbcPOspygs6R98MjfXlogPPiq6SovxhiNNSkWhyKBLHGLxIbF3?=
 =?us-ascii?Q?PvRpG+gA9YxxyYA2pM/wWX3wKN9vSC+o9lNu8QsPBTpkLOqxUJV+ya0/Ctr7?=
 =?us-ascii?Q?IFF5QNw7HzYiEr0gZYEDBymK/Yk8us/bioxuKRTh5iLVjU1FuRfUPUNQvb5m?=
 =?us-ascii?Q?dvS3DBJNo5CHdKhZjCkKZ2DvPk4OAY6DTVsVnr/Zp3PWVGzB5WgR/KFF6s54?=
 =?us-ascii?Q?FaofD/Ar7OS9ie0fBM/0/dKet6VNNzO6S1LCZgphgg5sL029tfUFohpPGvil?=
 =?us-ascii?Q?TyZM1BucGsnPIx3DYfQ+bZ26CU0BQfFB9SA477jhm69GXHlBqe/y+uQBqulS?=
 =?us-ascii?Q?1szsKuFO/POe7hOzQzMxeoMg8PfC+EIvjE3tAmucxIThTZrOe0Ld8QzyY03M?=
 =?us-ascii?Q?CUJ+Fz/dXLFizKFlo64kBLubTbDRK8O0HDz54/4UzdCOF/u2K9oQYSrnIOty?=
 =?us-ascii?Q?k2PF2an8xMOEKcWVsLXjwD8FojCXAciZLhcfqi6uQQ0k+aj5+fWDB4d5rECS?=
 =?us-ascii?Q?do/LL0CkGvru7Ord9pK8F/HEMtDsQ1PKXQ+6/XzYwM2VxlIsR0vgEikUXrVu?=
 =?us-ascii?Q?h9WpTf5Om5AHlftWVtxhfkQqxypPjCNoOFZkAIMVrbHJ08O6fSIzxe+HsJh+?=
 =?us-ascii?Q?+Eg6OsdDdqb/izV5oRLF1eNP4SZFcy0VSNNiSQtGKZvtk8H3IqU8f9hRDEnt?=
 =?us-ascii?Q?oPq4QiMeIiTvQi+TdrdvFsPCiWAI/JJsqeMLZk4/YcgB/8ZLWpEWAWs6QjX+?=
 =?us-ascii?Q?ItO90QeiJQShghztB6JEu+aMq2I1Se52xd1iAIYt0PGUfXhoS9+NCzSZKvOE?=
 =?us-ascii?Q?m4+7uXaU+OCmSDyQdQWZrZrzrexrHNuccwmEbkHQwS9DCopgEfIRyeO9kpYo?=
 =?us-ascii?Q?cSH75NGm5NaSHqKxUJZJeV7heUoMfTiicNZzdboteSUTwCrDcObD8nnB6XFQ?=
 =?us-ascii?Q?5fjlbFY/dCDl9CtOrBzVI1EUkJ35bHdWnFIQTN8v6oGZs0kmqyRs45hjNDvo?=
 =?us-ascii?Q?4idr9nWw6bOfzHV26DwLolm9RS0AQMBgVEPE2eZCmfB32ug3P9O8ClgcD0kr?=
 =?us-ascii?Q?99K7+bG4MaAUx+zEWUpDGwckhnY8my0xhDUggMGMGyRDKLDhYJIXxEaRpteI?=
 =?us-ascii?Q?9TJChygAWc459Tbse6LI9OnBYcfH8KBAOKx3exd0vRnlXrWqC4jF5tKLFIy2?=
 =?us-ascii?Q?NKvbscx0c7A3s/fIUyWAScKV7JQ/hSEaDvJZvV23+1Ug9SJiQFB5ElgeSf4S?=
 =?us-ascii?Q?Fi4wfRhx8kNiNaVcwp58hoW1ivwEFh0t6VmYTvk3u1J4XGR/RPisSXP30O8B?=
 =?us-ascii?Q?2F3JdUAYvGC/PrZalusFxOKn4QraipbLB3vhlcxVIDrLOIFJPao8LDlrZaxY?=
 =?us-ascii?Q?gFejW1xcVRU/W5IzEcaWw8ker86naA5S7j+MgJXi?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e25635d5-5dab-426c-1523-08dda7b17ab5
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2025 23:58:06.8579
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VQWWcA3E2KarVkrJ/fL4DYDk6qYg/taYKA5JM6Xzna0aWU33JwXzFgb4QtxvAf9J
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8948

The AMD IOMMU documentation seems pretty clear that the V2 table follows
the normal CPU expectation of sign extension. This is shown in

  Figure 25: AMD64 Long Mode 4-Kbyte Page Address Translation

Where bits Sign-Extend [63:57] == [56]. This is typical for x86 which
would have three regions in the page table: lower, non-canonical, upper.

The manual describes that the V1 table does not sign extend in section
2.2.4 Sharing AMD64 Processor and IOMMU Page Tables GPA-to-SPA

Further, Vasant has checked this and indicates the HW has an addtional
behavior that the manual does not yet describe. The AMDv2 table does not
have the sign extended behavior when attached to PASID 0, which may
explain why this has gone unnoticed.

The iommu domain geometry does not directly support sign extended page
tables. The driver should report only one of the lower/upper spaces. Solve
this by removing the top VA bit from the geometry to use only the lower
space.

This will also make the iommu_domain work consistently on all PASID 0 and
PASID != 1.

Adjust dma_max_address() to remove the top VA bit. It now returns:

5 Level:
  Before 0x1ffffffffffffff
  After  0x0ffffffffffffff
4 Level:
  Before 0xffffffffffff
  After  0x7fffffffffff

Fixes: 11c439a19466 ("iommu/amd/pgtbl_v2: Fix domain max address")
Link: https://lore.kernel.org/all/8858d4d6-d360-4ef0-935c-bfd13ea54f42@amd.com/
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/iommu.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

v2:
 - Revise the commit message and comment with the new information
   from Vasant.
v1: https://patch.msgid.link/r/0-v1-6925ece6b623+296-amdv2_geo_jgg@nvidia.com

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 3117d99cf83d0d..1baa9d3583f369 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2526,8 +2526,21 @@ static inline u64 dma_max_address(enum protection_domain_mode pgtable)
 	if (pgtable == PD_MODE_V1)
 		return ~0ULL;
 
-	/* V2 with 4/5 level page table */
-	return ((1ULL << PM_LEVEL_SHIFT(amd_iommu_gpt_level)) - 1);
+	/*
+	 * V2 with 4/5 level page table. Note that "2.2.6.5 AMD64 4-Kbyte Page
+	 * Translation" shows that the V2 table sign extends the top of the
+	 * address space creating a reserved region in the middle of the
+	 * translation, just like the CPU does. Further Vasant says the docs are
+	 * incomplete and this only applies to non-zero PASIDs. If the AMDv2
+	 * page table is assigned to the 0 PASID then there is no sign extension
+	 * check.
+	 *
+	 * Since the IOMMU must have a fixed geometry, and the core code does
+	 * not understand sign extended addressing, we have to chop off the high
+	 * bit to get consistent behavior with attachments of the domain to any
+	 * PASID.
+	 */
+	return ((1ULL << (PM_LEVEL_SHIFT(amd_iommu_gpt_level) - 1)) - 1);
 }
 
 static bool amd_iommu_hd_support(struct amd_iommu *iommu)

base-commit: eb328711b15b17987021dbb674f446b7b008dca5
-- 
2.43.0

