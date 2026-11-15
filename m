Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.60
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794785453;
	b=08Y9y5STuMi5wvcg86joA3gAvQx4N2wskG7KrKLCgBCMZNbP8lU5pvMGjpxjXicKF+ml
	 iXPZqr07ebFpjKd2ZEH6cgls76oJxz4+dD//3arZksIT6Qoe8lUnnBYQctUeq1dJofHf+
	 qRRwb0TkEWyB+Xd7ODDLmTric8218xjaslTQS9pgmY9jfZo9rh9wY2IrtMgAf19pE9Q55
	 /14suVvL6vC4cL3qPqH32c1CtStMLIhc2HHG7376/Za5RqSSiooahYbepSZRyeHqyraQI
	 GM8CRgDvhaUwu7pWi575vRoW4zNp94ZIwMaj4IQ29aELvXyqcbNy8K3vOHYhsdCRSBg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794785453;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:In-Reply-To:References:Content-Transfer-Encoding:
	 Content-Type:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=GnPC70GeR5Bkljw62QVExfcqwt8aMpEGckuvh+Qpwb0=;
	b=v3/3vFNpUPgve+Ugj4ZUQAK0XkydOYg3vZSwPj4wZcOuFI2OTBJ1+ZLErpgK0BMRAcHU
	 xcg+MaFZFEOp+6ddIqnj1qvtYwuIag2FvTn0jEpzjP84nxFNKQxShOOoNw0waFPXrJct7
	 udHKxuNYmtcSa+v7baAqHUOAvdxFw5EdL7oNdtaa/J3Lt0r9DGddOWmpCt8AJvWgUXcmZ
	 L8t+PHjcxoK0eFL1durAcxxw+UN6wrZlg44lNLh+2CZ+qfnxw86h4MQ4gANtUmzsYDtv3
	 98FTgmHgkGLDkKdQXS5qr4g7uzwmD6w96wDlmmpWgb61GEsj2Pib+F2tzlzkyJH2+hg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Sofw7k5d;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.60
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012060.outbound.protection.outlook.com [40.93.195.60])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6F5A606A335;
	Sun, 15 Nov 2026 23:30:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E6F5A606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Sofw7k5d
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pg2Of2qGVbhkqups4HKJUhGHqdzoFmEtOH5Og24wUNyo5EOzefm1HgsAkOnL+SC7l5xcK9tlhb02ISQZQmFeqaGsT+5YffYw0xpQYAwAiXJGOMSHjZqFLQxOJXvkfdztwXG0xlZs6SAfBYlc6/3Z04F5XXjTlk1SpeuNLS2lucQJaSaox5KADZnFAQajW970D9ivGa47xHmy8vd09j9lC/X4Yeh0DXpaVqKAA7LP9D66LmLcAqhlfOxyMQp8rITQTEI/R/IJ9Vr2nF9sQdpmX54KXodyPpdHStY07R28lYQI9xw/1l+JgL+kdPMloFWDUmikq/+XoGOHvgC7PQEecQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GnPC70GeR5Bkljw62QVExfcqwt8aMpEGckuvh+Qpwb0=;
 b=CntbqoFbG4L6NmCVidYyGkxo1iAl/JJlVG7nEFUIkXVBYpFognsWMJnamH2X5EeLme+arLk3sAY216Pf6ItGyD+vMjf+30BdCD/yV1CTgGu7eKcVOrWFMalHAbK4HStDqkZsjrgNCqOekDwJuG1SQe4d3vVcvujjp1jXbUa6MriZDiKasBNgLSnvxthjcDCrHvvbVQYTl9KL/IOqhjAY/zhFWkF4K7sAIvzLhaA+pRcsyW7Uyy6O/h31r0oVmJCfic8PUnrm66cxsGB/NtjFmmtOxr7Rc31enXDXwZ7Bg6GspuONliLjZWYFJsb9PSS5EJxN5L4/Cv28wVcV3Hpz9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GnPC70GeR5Bkljw62QVExfcqwt8aMpEGckuvh+Qpwb0=;
 b=Sofw7k5d8Q5eFjewDsbq22ikQ8AfsV4GyMHPnBsDLZ1rMks9+wKs4IHQltA5QcM7K9ewzcK+NVrI5KTXW5YPfPlni/SVWAKaH54olwXgKZ2qeIK+KoHNYmeN6iYiLEB+spKwxEnhOo2mWoxQBqK93dEvyUOxXzxpZrAnulji3oxGZP8pHYbJSAyawf0h4Bd1GNPux8GGL7P7gLHN7xhtTeZ3/X3DgyoTcn6cxhg/uDa3sYMG81owM534LTw5Fgnl6+G+1Wu9A7QY0jjg/vS+9YvBpI9yVc+FWrN9fo2eN6yAK4umLQI1ih1x1OsLbH3Vc0iP59WBpR69CZk54oVj5Q==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by DS0PR12MB8815.namprd12.prod.outlook.com
 (2603:10b6:8:14f::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Sun, 15 Nov
 2026 23:30:46 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0615.013; Sun, 15 Nov 2026
 23:30:46 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: David Matlack <dmatlack@google.com>,
	John Garry <john.garry@arm.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v3 09/13] iommu/arm-smmu-v3: Remove io-pgtable-arm from sva.c
Date: Sun, 15 Nov 2026 19:30:39 -0400
Message-ID: <9-v3-97feb2edfbab+748d0a-iommupt_armv8_jgg@nvidia.com>
In-Reply-To: <0-v3-97feb2edfbab+748d0a-iommupt_armv8_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0012.namprd03.prod.outlook.com
 (2603:10b6:208:32b::17) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|DS0PR12MB8815:EE_
X-MS-Office365-Filtering-Correlation-Id: ae182b20-2262-43f1-6fdf-08df43707894
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|23010399003|10067099003|11063799006|56012099006|261026121527099003|261026140227099003|261028144727099003|261022105027099003|261021123027099003|261021121427099003|261102123227099003|261009223027099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	D2OVdQm/SdS8i3jWUTWvTe4hJ3gPT2NkarJHtjJkFTanonFt1HCh8RCMTOF493ZXxDUgWBoHO1pdmLHHAdmaa/Rn9EJ3M7NqQ8fsNvgjJeDEesYtHY5ZqF93oeb72dostFys9L0blTEA2HtdYerWX+rYkqRW+jBIsJjOm1XLxOl8f+w98lKtJZNXnvsru8WQVa/8/YGvcDeGF3U2fygqp+QomhqCzy4MTv+hgfR0hNw6lRB0o3ax+468FPEjORFlbZsZr7GyEs+LTshSETc7flx9wQoUZicWxiNSuXMVU8ly5DOq1lgVwgicJuvyP8yEVLcj8TkMW0NxYFnVy7/DgndXO9azUajHoDnz7JTRG8Y2sV/VgMo9G1Tbnj9R0/dYbOsNcYiY3P7gwN+kpMvIlYMCHVo9iOGC6SCkTk54NmHAv6Gk+NvHyCS640909PJd+Rf3Jgn8soH1cCK8DIZd20WCbwvKfFDzaG6BBVfuwTfX7Hzwrka9n9FCAFHX3rhg5OXocDIsW/VgsyvZp/FpytBNYmFPcaA4K2Ke4/vgmtxIuGojxLUxNT3dff4bpKsI5bg43Q2GA5M6DOIqsI2kxNn6bns8M7UWAp3nyKYJPagbFBfdLj8s0UhVOeE3hOwwr17Z03K8hoQY3a8UkhXNjlHtBaSsict8ADAwh156oAE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(23010399003)(10067099003)(11063799006)(56012099006)(261026121527099003)(261026140227099003)(261028144727099003)(261022105027099003)(261021123027099003)(261021121427099003)(261102123227099003)(261009223027099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yCZ2xOeKcUYT5w6hQOWhYGkSbfy2AAGDR4aS0Vz7d8N0crm0FMGbL44RV0c1?=
 =?us-ascii?Q?AyTIVbdFjkxdTwHQLyge3tUb5jeOrtYzq6zqf7VcCvbdcOUZluWp02DYQqIF?=
 =?us-ascii?Q?33Y2fXZ+plJqcHWY37SHlbthXHXB61+HDNyw06+Kn60TN+aFf52FP0buuNN3?=
 =?us-ascii?Q?o6F0MUuxmYURLkdiUVg7e2P6TmOiuUuBGwKrYn5IAuW5x2lXYOwnDJB1e8eL?=
 =?us-ascii?Q?mAUy1ZEDHnFxMJqrdh7DGxSXGw5D6loF7BRsKIJ/u407IocJsCjH4USfOYXD?=
 =?us-ascii?Q?ZjFBVveJ2ACUGTo1XDdJ9fJXp9UgOYnDpXSEUa90sY58TcQAgpTfJriEsX2A?=
 =?us-ascii?Q?2n3QFIXyfbWp85rLnAwbXe49Z7QteZkzGM+m4403VfmVQi+f3yJxUSzqxF97?=
 =?us-ascii?Q?nmI3aTBmTgxH0h/iyKZqow2n6tSae8vjxG2Fumdd7GIMb3fWPHUYU+seiOc0?=
 =?us-ascii?Q?w/pwbXmuw2ua/Hj9qEKvgptItvIQp6Ce0FFKfxg2taMXbnV+QwsmL56vxqVu?=
 =?us-ascii?Q?msXo03IpIGDN+vjg1qc/udF92tJNZy18CC/UnAxdpLKR9+VQ8wZeovjTC3XM?=
 =?us-ascii?Q?o2a7UtBObAx+mK8Sc7F8F+L2UdbvISl/05JYNgdUCAX/INxcKEAgtPMf7I/1?=
 =?us-ascii?Q?JJ0Q+VmMTiAl/rvLlhfaO2TXQjyudNEpcvHMAUh8OxXTU0zpsteb2/y8YTmv?=
 =?us-ascii?Q?Mr+OqrcxYYXxKmCacrnYGhakJRAoUIJ/pGPH5mmhSso4SKyFIGC+DNgwrI9I?=
 =?us-ascii?Q?q419BxUDi1VsHV4jJugXy1mQ8aA6V297/zhlrOmuuW5J5oE20PtiKT7BNAAi?=
 =?us-ascii?Q?EegowAHRJFTCY9MpRpSwuCm1k8QDGgJTepBznEGvGLOeEyN3cOvS+zFcI/Ym?=
 =?us-ascii?Q?4BXBmQw3ZRK0AtA4YQhQWmptHzkyXAYZKaKaKL8Xi2CGHHZy5cWbRhX3uY0g?=
 =?us-ascii?Q?IKOpeqgGC5/L2Sz2YFEEUzl4PdN/Ddp1Y3RdVJgv8l3cDJlRrk8CyoXwOYUB?=
 =?us-ascii?Q?mBLE/vd9lTA3RPeQpHlz5ZvuzaYA9hFbuYIQGpo3mLbJ3Td6fojYezfKaFOh?=
 =?us-ascii?Q?9uJo1xFW/fEu5x/epI3DME4LCsP9rsnTBrdKAzldyC0CotHV5k7nbmPgmo7x?=
 =?us-ascii?Q?PIMkNfYdaTrH4tQkfThoitNddOp91l9B9M9csgA9nZsknOjLEFMj2nfg0ZSc?=
 =?us-ascii?Q?1CzOscH4jcgQ1CCF0hATmrTGFcISt08RzfL1sJ7fm0adM0OVLZUst8wE+yUW?=
 =?us-ascii?Q?ihQSjTXBKc6CyuVZtUHvSTQ8ZXQotqKM6KR7Zb8dEeFJ9Ej5AiirfQHPQ9Mj?=
 =?us-ascii?Q?Rb9fLcCz2bjuIwJBGlkZAlhLITLK7jFIaqHsNkptz9d04llCJL4K8HH4r2ev?=
 =?us-ascii?Q?pd/eVgZnJavaE9fgCzou5TpSblRkJDJtq8MyANN7X8TLAdyzoAte9tp037d2?=
 =?us-ascii?Q?ZN3+pnJxHlt+v3/SmhlL1gwNp7pOHalJyU6APnzGKdOxdNyk82dAlOyVF6mv?=
 =?us-ascii?Q?adKTF6MgXRvfMU10H52nKw1OpQ5ooVlKIhBidwVUtmZgmtqegpMB/nhsdVQo?=
 =?us-ascii?Q?1SRuhhjZOgLSlvLNAngb1xJ6SiILEZKa7ocbEbsh/caml9OfmEexCoOrfDrd?=
 =?us-ascii?Q?TusWCs2rgBEV9LcS52THYAmw3xaloWg7w43YnUwlEBbcWOeY6f1pMOKc4Yb/?=
 =?us-ascii?Q?Hk6Nnp+pMgliOav8FmGcl5e9wYnSvMw21Y8mwUaXPY17zt/h?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae182b20-2262-43f1-6fdf-08df43707894
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2026 23:30:44.9039
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Slhynk2ikLZ3pvb+atGMKcfvQj9zdWc907tadxlI3vIgVfH4W/Ryd8nXNcBGVDKj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8815

This is only being used to get some STE constants. Use the same constants
from the arm architecture code in sysreg.h instead.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index fdc6cb7a128037..0ce720de6c92fa 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -10,8 +10,9 @@
 #include <linux/slab.h>
 #include <kunit/visibility.h>
 
+#include <asm/sysreg.h>
+
 #include "arm-smmu-v3.h"
-#include "../../io-pgtable-arm.h"
 
 static void __maybe_unused
 arm_smmu_update_s1_domain_cd_entry(struct arm_smmu_domain *smmu_domain)
@@ -41,10 +42,10 @@ static u64 page_size_to_cd(void)
 	static_assert(PAGE_SIZE == SZ_4K || PAGE_SIZE == SZ_16K ||
 		      PAGE_SIZE == SZ_64K);
 	if (PAGE_SIZE == SZ_64K)
-		return ARM_LPAE_TCR_TG0_64K;
+		return TCR_EL1_TG0_64K;
 	if (PAGE_SIZE == SZ_16K)
-		return ARM_LPAE_TCR_TG0_16K;
-	return ARM_LPAE_TCR_TG0_4K;
+		return TCR_EL1_TG0_16K;
+	return TCR_EL1_TG0_4K;
 }
 
 VISIBLE_IF_KUNIT
@@ -85,10 +86,10 @@ void arm_smmu_make_sva_cd(struct arm_smmu_cd *target,
 				   64ULL - vabits_actual) |
 			FIELD_PREP(CTXDESC_CD_0_TCR_TG0, page_size_to_cd()) |
 			FIELD_PREP(CTXDESC_CD_0_TCR_IRGN0,
-				   ARM_LPAE_TCR_RGN_WBWA) |
+				   TCR_EL1_IRGN0_WBWA) |
 			FIELD_PREP(CTXDESC_CD_0_TCR_ORGN0,
-				   ARM_LPAE_TCR_RGN_WBWA) |
-			FIELD_PREP(CTXDESC_CD_0_TCR_SH0, ARM_LPAE_TCR_SH_IS));
+				   TCR_EL1_ORGN0_WBWA) |
+			FIELD_PREP(CTXDESC_CD_0_TCR_SH0, TCR_EL1_SH0_INNER));
 
 		target->data[1] = cpu_to_le64(virt_to_phys(mm->pgd) &
 					      CTXDESC_CD_1_TTB0_MASK);
-- 
2.43.0

