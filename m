Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2057.outbound.protection.outlook.com [40.107.92.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 074453612D;
	Tue,  6 Aug 2024 23:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722987102; cv=fail; b=EETa+JC9YrmgxtNhKqqpP9tScOiJCZF+jiMVQWo1ymrYOYSjAv+M0nJ0a5g2VIwir3zf4Px6B+8VCmTIAbICYbpVo/h4cJOKsTHTWxPjB+1eruByxmUyeElpQGCxt+9CZKLR196TqVNY0cGohxnWXegneC5fqPxLUyy/RQx4fGk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722987102; c=relaxed/simple;
	bh=zHa6CV4JXBFD023v8tj1T2gBFXBmhCqf+v5lwt8E0eA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EJVDx1CW3YobqNJq+Tp4ufHaRhzWy0UZnuPcd892D7MPioKAKsyVWxOwQvPUJ2nvbEoWAX5tWOqbiF52YB5yYyCd+v5n3jx8YOHxzG1l6yS9NuWYrjvKDie3dLhQXt1pOe8w+FhgRqyw6y9LltlNFPiHqwL2n5lO5AN+KB0JFOo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=EV9VqhzT; arc=fail smtp.client-ip=40.107.92.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="EV9VqhzT"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sAUwrS5fXCzOnVmBdVXDle5ZrBV6CPM5UCurRw6IFEP7J+u90WxRLXKVOqu4N7HAaZUlsGsEp3Z0Zfr25twFiExhb6HET1DKiPgkLJMiiQLYQYt+i/CeQ2d1njBjUa6HuRUzVY4jy5qdQwOCN/xdW6y6XGBVLDb1HUbWFGT/NkAXUA+cp1brGYDFv0rqPp+fZN7RVyViPZTwNhBy1SD5xFUhE8oQ4Qs1KshyTS8QTrOqTzce4KN5nBlXfpl5Ed20LFIIkB6PlbuYyOwQEcB5BAHSNxngzrgr4WGcBM+d5Hq6WcBi34/pR0bkvy/I8YNho/jexRpGYs3kvhAYk12UIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B++ncH0RJ+pDAVZWs0XZHrEN9RctEPrhMdjP7SgL2qY=;
 b=qGofdVtK46IThGmpiUo+xLbVn33htxObK8HSIWKf6iONHp6DpiE4u1b5AGsEZRlkUzcELS1l4qX3xA4FSmGkMLgI6jePfAQD/syXtFzyVBk/xrODKFLRpHy/TMcneRfKbtc4jI76l8PwvHzCOjP2Cvo+BkXr5Gde4UfRv6CJZFRsBQh9M4xQgf3eQBA6LFD+3vm8qpBadplohv+FkmEmWJqxxX+BImZUNrjtsmIX+9Mzl49KpBJTYiot/Zr17QnSunjqUWj+7xaLGBjtH5YfkgsDJBrveIrFyGkDgqMolc/C1lf9urthmO9pSKnAji6HgNEUq036S0f33ZkNjtTcRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B++ncH0RJ+pDAVZWs0XZHrEN9RctEPrhMdjP7SgL2qY=;
 b=EV9VqhzTuJTb+JWt7djkI4+CdsctD/fjYBSps+TdEOD5qfOxlBftovzZLNcV3bFY0X2aH1NgVDyHNgEeSFtw6jvCK2wl4p9f12PC4qDL9et8pSojfqUcH6NLCZ5kd2cIUapcqeoYobvx4+wb2caQrjRxy43hNS4LN06S0+IGQ2UldTeBaJZib1ZaaD9HW3L6DidGllWCx+4fRgRFWhl4g9bWeODdSX3ytmKJQtH+pkv2omNcepljOZf8cLC+Ck+LJrKIj2swmiQc/giEe0wx9rO1XNzQQON5Kmivw854vVIGPFpjg92PS7gTnfrrra4qMqFocQKkuCMUoUVNhsZIxA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by PH0PR12MB7839.namprd12.prod.outlook.com (2603:10b6:510:286::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.23; Tue, 6 Aug
 2024 23:31:31 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7849.008; Tue, 6 Aug 2024
 23:31:31 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v3 8/9] iommu/arm-smmu-v3: Add types for each level of the CD table
Date: Tue,  6 Aug 2024 20:31:22 -0300
Message-ID: <8-v3-9fef8cdc2ff6+150d1-smmuv3_tidy_jgg@nvidia.com>
In-Reply-To: <0-v3-9fef8cdc2ff6+150d1-smmuv3_tidy_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0108.namprd03.prod.outlook.com
 (2603:10b6:408:fd::23) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|PH0PR12MB7839:EE_
X-MS-Office365-Filtering-Correlation-Id: d584257e-83d0-4c39-8487-08dcb66fe467
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?NQh5NkbPzCqkzBB1YbrfnHMz7J8XJ08F/g4xnZnBCOqSLFm0TW2FoPh/619m?=
 =?us-ascii?Q?6d01+noyVg+FBlSw46hS4mMbocsapYcPnHZ0//Sm8LOok7XgWllwirELzgE2?=
 =?us-ascii?Q?+wf//zmmHqTAo3Ckj4Rm2AccBq3ygb+/4OPjnRauiSIN94BQyb5ox9WseatL?=
 =?us-ascii?Q?5DBujPPnWiFJXZ5tvhnNS3noRcHQYa1C3EpGC/iHApIyPyRWrU5kuSuO27mq?=
 =?us-ascii?Q?YmvzlBw0kCaI/by/lqps78tGD3j/5gKPFDTSgj/3MBeWQ8ZY+++xgvq1KyVL?=
 =?us-ascii?Q?AqKARSchDUqChvt6IINNjCRxlml1tTz46laoYG5exOMKgA0OnfbprqaQSyN5?=
 =?us-ascii?Q?xFr/B8XtnNQYUXLb0LXQRjO0BlIi7LN3AK0ERHSeY6Uy3ygWfk2mfHqeFMDN?=
 =?us-ascii?Q?m4He9+a7/ZAvqDxcJpU2QmNP2dBzF0um8P5yU2rW8xBE+/etFcDNezjOwuSp?=
 =?us-ascii?Q?a8KY9pJktLQFARavh93tLLxeaw4/1YHDdPT0ceop1ySWe5zpNjQOkbWQkB59?=
 =?us-ascii?Q?LYH4NLZZBkUfXPPC7wGS2FRuJozvmu1JE3BFYQpMLRrtoJl93A9ohufWI5Gt?=
 =?us-ascii?Q?YK9SdOiTWuEF0ERhWX3hd6gEQ0Xw964E9WnJ/jXLC2jRw9REmASiqMvsCMs9?=
 =?us-ascii?Q?YgzFIbc+Tt7Di8cwo148z4e4JtrDPHoqtcH9zXShIVzxDRHWXvdIaCUgn+TC?=
 =?us-ascii?Q?XZjP/I6c1qW78fScS6SWazyxKw7109rdPRfHMpyGrDXX/AW3hH7slAd0+Sy5?=
 =?us-ascii?Q?xwCsd2pEaOeGs9TA2TlZ9Nq9cmZ1G2Wbwg6JqtlAE8X2UcOWSVLluCw3sxSt?=
 =?us-ascii?Q?8Oc7bHMXTuv5cOMLyYnZ78HCz1bToG3gDPoM87bQBvC6sWIlwxYSfhbMhWOQ?=
 =?us-ascii?Q?OrjMkRHnTu1VsU/OVg2NIXx0p8RmWIqYWRLqVQIbi3s3SIvtIgrOl1BocRXf?=
 =?us-ascii?Q?CqZyR6fqF7wh+bEk6T6XLe0YRkxagHsfEsBnmvJ+ZWifGZKi0bf94ciz71Qi?=
 =?us-ascii?Q?egTkI++8nuwsES+9/mwcC2rZ/FEYuRfAHDyrEqvoumJWNMf7ziyEih6PfFAB?=
 =?us-ascii?Q?/jxBVCj9XDeOq/jwuaNN9lsIoWtJDiZFm71uSJ7wWQ+FIYNV9PZkFJm8KIvw?=
 =?us-ascii?Q?HQbvBUA8YZtqhyMT5ZcnbLPv/80vlYeWkUEvUDwWsUIzXHkxZnClW72NT8G9?=
 =?us-ascii?Q?e2iCjt8hLZca3jU7tHXd7hrOwtrLSO2Uf2nX+6iY5PrNHHUSli8sBQdhRkHb?=
 =?us-ascii?Q?924DV+UfOS4S55nIE9xDGkJqC/FalewXmM1skRpQM7a8ePMngiBgsyzGS+xk?=
 =?us-ascii?Q?LQawEJrcQuz7+9as8ZJimdYGEynrQy58cG4ZGJSsbCrgJA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HocpmVn0Y2i7koyrz6NeYSShnvXfg9jl2/C0Q0H4lJP6n0N+1cDk2d5NQIX+?=
 =?us-ascii?Q?l2vbEa36aSH4VNO7New3bTo3ESiaM0Gjvrqa08ZHnF1d33s4KJWCzhHjiAnu?=
 =?us-ascii?Q?5H2L/eJiPT5rUhefAtAVhIxpCckOkic/6MZfjuGhZWYZ5aylAKI6jxemTaFt?=
 =?us-ascii?Q?QM+PYew4qH6CbykFtT/pBD1cmT2uWdrKZkYaVDD8TICfdedDQx9m3FHc+NCD?=
 =?us-ascii?Q?CyZQvasnYPB6B8/+En6BmYYWm84prwkK+19u8CDO8XO6VlT7VERsdVykUUn5?=
 =?us-ascii?Q?7t04rzYQmPePL4hi4Bzp+f+fYTnVOo8SQV2mVzgpIfaL0JhUiZeyMXuStXY7?=
 =?us-ascii?Q?FO4AuKzzKPs6nOLAmJv+mR0RqVnCN2l/YNw1X//c/I5QQ3yF27CzBw/2qqT2?=
 =?us-ascii?Q?I1mOc2ppMdy1KYakFvRrBosQaqceiZbqclhFrek5yLzlvXu9GUHZjE1i5t8u?=
 =?us-ascii?Q?T6YMcsu+hahFHxxPUjZHnkMn2Zc33+AFhUiYTPu1lTd2p7QXCqvNteMAqmae?=
 =?us-ascii?Q?LMBHNqDLiStPqin5DtB5mSZNrd8ndrPOWmVp9/ceIM6YklttMKFbgG50tdbm?=
 =?us-ascii?Q?ZqLqxy9UUTcErE1nzcVdx30CatkSbPFO9y8iDfLS+RQcBkqe7AIPrFiHGty0?=
 =?us-ascii?Q?zJ8HwOKU3BFsXnmoJuKH3IIAl+Km8iFnaWMreDongwz9c7nCS/5wN5qEEs/0?=
 =?us-ascii?Q?T0uB7fnuXlZAiLlLkD+zXBi+5CLk0bI+qx+0O3jxujs+DPi+LheoeTnojVOO?=
 =?us-ascii?Q?ldEzuUKoapFLBH1Qd22cXWS9yTe+4jbqtwmt1/DcTRxQUj5+QWjDeQ0Jk8SF?=
 =?us-ascii?Q?SuAw+XhA7zDiErFYXU9qsxI0Zs/zhsiaM2Q69FHThBTNREcR2NESU4rGJ+rY?=
 =?us-ascii?Q?tIK+ZBu8Apd98OlHTQAz5wwXz6HlHMOD9KhronEY6ZzNb2bhxP/tEnN1fELR?=
 =?us-ascii?Q?HO5zI/LZsPXYJuY3NwCt23DZ32WBqGDpnT8DDT26i78UK2NADst4Q85XOcBz?=
 =?us-ascii?Q?SXyt9GwmGu4d/iSGEkpQp0q8HVkMevNYTXWQLXCSrR7svHa8hIw2Kd4n3Xxg?=
 =?us-ascii?Q?oqv5cx+eb8bGwe5b4IvBo9gaa/E0bWCYvzE3sOgp5R6p/hQZaVicOEquDeZ9?=
 =?us-ascii?Q?qprzKeUxGZfLT0M/HJKHvjM/jdpLkk8IfEh3Nso7jZhPe27Y+vXfmkugfuqr?=
 =?us-ascii?Q?UwKX6ih11g9jT6Y4uUIruC0izTBZCmUIf/GHtOjXBbDEFOZL1ddh+2tN4G7W?=
 =?us-ascii?Q?Dr5/SN6vGIWufYwTc3E2eptzJC8sED+u35MlVhzdiX38BB6yKcrpLpGTMSwd?=
 =?us-ascii?Q?7nVmRRoY8rikJJkakJdYIe9Z9x+e0SM9+kikYEYcHkaKNDt2YEBXZaB9n3kN?=
 =?us-ascii?Q?C8aWEyCVre/ttsmsIMY4g+byA/nW/z2O/c48fQdGCKXHykK8LHOIP+QpOCVl?=
 =?us-ascii?Q?LjReEaVU4NrOPkqIulpBZEd/d8nFk4Wep5TBKaNsXQY8qOmZTBCuU0tUluQU?=
 =?us-ascii?Q?bTGRO6W6H+1r9+Ay7cVmIKt3EOGeEX+7cTlnumJeP7ID+txaY0456VU9esa6?=
 =?us-ascii?Q?xNC163O+ina9jbO2bhc=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d584257e-83d0-4c39-8487-08dcb66fe467
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2024 23:31:27.0595
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wx38eVY+/ElkzUKcG2lHR/vyi6i2wC1IKtFBNJfPfinBbEkqPUQ4CBdzUIumLjTT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7839

As well as indexing helpers arm_smmu_cdtab_l1/2_idx().

Remove CTXDESC_L1_DESC_DWORDS and CTXDESC_CD_DWORDS replacing them all
with type specific calculations.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 46 +++++++++++----------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h | 27 +++++++++---
 2 files changed, 46 insertions(+), 27 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index d23a845ad82223..70b37d7f0e245d 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1179,17 +1179,18 @@ static void arm_smmu_sync_cd(struct arm_smmu_master *master,
 	arm_smmu_cmdq_batch_submit(smmu, &cmds);
 }
 
-static void arm_smmu_write_cd_l1_desc(__le64 *dst, dma_addr_t l2ptr_dma)
+static void arm_smmu_write_cd_l1_desc(struct arm_smmu_cdtab_l1 *dst,
+				      dma_addr_t l2ptr_dma)
 {
 	u64 val = (l2ptr_dma & CTXDESC_L1_DESC_L2PTR_MASK) | CTXDESC_L1_DESC_V;
 
 	/* The HW has 64 bit atomicity with stores to the L2 CD table */
-	WRITE_ONCE(*dst, cpu_to_le64(val));
+	WRITE_ONCE(dst->l2ptr, cpu_to_le64(val));
 }
 
-static dma_addr_t arm_smmu_cd_l1_get_desc(const __le64 *src)
+static dma_addr_t arm_smmu_cd_l1_get_desc(const struct arm_smmu_cdtab_l1 *src)
 {
-	return le64_to_cpu(*src) & CTXDESC_L1_DESC_L2PTR_MASK;
+	return le64_to_cpu(src->l2ptr) & CTXDESC_L1_DESC_L2PTR_MASK;
 }
 
 struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
@@ -1202,13 +1203,12 @@ struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
 		return NULL;
 
 	if (cd_table->s1fmt == STRTAB_STE_0_S1FMT_LINEAR)
-		return (struct arm_smmu_cd *)(cd_table->cdtab +
-					      ssid * CTXDESC_CD_DWORDS);
+		return &((struct arm_smmu_cd *)cd_table->cdtab)[ssid];
 
-	l1_desc = &cd_table->l1_desc[ssid / CTXDESC_L2_ENTRIES];
+	l1_desc = &cd_table->l1_desc[arm_smmu_cdtab_l1_idx(ssid)];
 	if (!l1_desc->l2ptr)
 		return NULL;
-	return &l1_desc->l2ptr[ssid % CTXDESC_L2_ENTRIES];
+	return &l1_desc->l2ptr->cds[arm_smmu_cdtab_l2_idx(ssid)];
 }
 
 static struct arm_smmu_cd *arm_smmu_alloc_cd_ptr(struct arm_smmu_master *master,
@@ -1226,7 +1226,7 @@ static struct arm_smmu_cd *arm_smmu_alloc_cd_ptr(struct arm_smmu_master *master,
 	}
 
 	if (cd_table->s1fmt == STRTAB_STE_0_S1FMT_64K_L2) {
-		unsigned int idx = ssid / CTXDESC_L2_ENTRIES;
+		unsigned int idx = arm_smmu_cdtab_l1_idx(ssid);
 		struct arm_smmu_l1_ctx_desc *l1_desc;
 
 		l1_desc = &cd_table->l1_desc[idx];
@@ -1240,8 +1240,10 @@ static struct arm_smmu_cd *arm_smmu_alloc_cd_ptr(struct arm_smmu_master *master,
 			if (!l1_desc->l2ptr)
 				return NULL;
 
-			arm_smmu_write_cd_l1_desc(&cd_table->cdtab[idx],
-						  l2ptr_dma);
+			arm_smmu_write_cd_l1_desc(
+				&((struct arm_smmu_cdtab_l1 *)
+					  cd_table->cdtab)[idx],
+				l2ptr_dma);
 			/* An invalid L1CD can be cached */
 			arm_smmu_sync_cd(master, ssid, false);
 		}
@@ -1385,7 +1387,7 @@ static int arm_smmu_alloc_cd_tables(struct arm_smmu_master *master)
 		cd_table->s1fmt = STRTAB_STE_0_S1FMT_LINEAR;
 		cd_table->num_l1_ents = max_contexts;
 
-		l1size = max_contexts * (CTXDESC_CD_DWORDS << 3);
+		l1size = max_contexts * sizeof(struct arm_smmu_cd);
 	} else {
 		cd_table->s1fmt = STRTAB_STE_0_S1FMT_64K_L2;
 		cd_table->num_l1_ents = DIV_ROUND_UP(max_contexts,
@@ -1397,7 +1399,8 @@ static int arm_smmu_alloc_cd_tables(struct arm_smmu_master *master)
 		if (!cd_table->l1_desc)
 			return -ENOMEM;
 
-		l1size = cd_table->num_l1_ents * (CTXDESC_L1_DESC_DWORDS << 3);
+		l1size = cd_table->num_l1_ents *
+			 sizeof(struct arm_smmu_cdtab_l1);
 	}
 
 	cd_table->cdtab = dma_alloc_coherent(smmu->dev, l1size,
@@ -1421,27 +1424,28 @@ static int arm_smmu_alloc_cd_tables(struct arm_smmu_master *master)
 static void arm_smmu_free_cd_tables(struct arm_smmu_master *master)
 {
 	int i;
-	size_t size, l1size;
+	size_t l1size;
 	struct arm_smmu_device *smmu = master->smmu;
 	struct arm_smmu_ctx_desc_cfg *cd_table = &master->cd_table;
 
 	if (cd_table->l1_desc) {
-		size = CTXDESC_L2_ENTRIES * (CTXDESC_CD_DWORDS << 3);
-
 		for (i = 0; i < cd_table->num_l1_ents; i++) {
 			if (!cd_table->l1_desc[i].l2ptr)
 				continue;
 
-			dma_free_coherent(smmu->dev, size,
+			dma_free_coherent(smmu->dev,
+					  sizeof(*cd_table->l1_desc[i].l2ptr),
 					  cd_table->l1_desc[i].l2ptr,
-					  arm_smmu_cd_l1_get_desc(
-						  &cd_table->cdtab[i]));
+					  arm_smmu_cd_l1_get_desc(&(
+						  (struct arm_smmu_cdtab_l1 *)
+							  cd_table->cdtab)[i]));
 		}
 		kfree(cd_table->l1_desc);
 
-		l1size = cd_table->num_l1_ents * (CTXDESC_L1_DESC_DWORDS << 3);
+		l1size = cd_table->num_l1_ents *
+			 sizeof(struct arm_smmu_cdtab_l1);
 	} else {
-		l1size = cd_table->num_l1_ents * (CTXDESC_CD_DWORDS << 3);
+		l1size = cd_table->num_l1_ents * sizeof(struct arm_smmu_cd);
 	}
 
 	dma_free_coherent(smmu->dev, l1size, cd_table->cdtab,
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 68841ba3c2e789..681804a3f86bec 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -296,16 +296,31 @@ static inline u32 arm_smmu_strtab_l2_idx(u32 sid)
  */
 #define CTXDESC_L2_ENTRIES		1024
 
-#define CTXDESC_L1_DESC_DWORDS		1
 #define CTXDESC_L1_DESC_V		(1UL << 0)
 #define CTXDESC_L1_DESC_L2PTR_MASK	GENMASK_ULL(51, 12)
 
-#define CTXDESC_CD_DWORDS		8
-
 struct arm_smmu_cd {
-	__le64 data[CTXDESC_CD_DWORDS];
+	__le64 data[8];
 };
 
+struct arm_smmu_cdtab_l2 {
+	struct arm_smmu_cd cds[CTXDESC_L2_ENTRIES];
+};
+
+struct arm_smmu_cdtab_l1 {
+	__le64 l2ptr;
+};
+
+static inline unsigned int arm_smmu_cdtab_l1_idx(unsigned int ssid)
+{
+	return ssid / CTXDESC_L2_ENTRIES;
+}
+
+static inline unsigned int arm_smmu_cdtab_l2_idx(unsigned int ssid)
+{
+	return ssid % CTXDESC_L2_ENTRIES;
+}
+
 #define CTXDESC_CD_0_TCR_T0SZ		GENMASK_ULL(5, 0)
 #define CTXDESC_CD_0_TCR_TG0		GENMASK_ULL(7, 6)
 #define CTXDESC_CD_0_TCR_IRGN0		GENMASK_ULL(9, 8)
@@ -336,7 +351,7 @@ struct arm_smmu_cd {
  * When the SMMU only supports linear context descriptor tables, pick a
  * reasonable size limit (64kB).
  */
-#define CTXDESC_LINEAR_CDMAX		ilog2(SZ_64K / (CTXDESC_CD_DWORDS << 3))
+#define CTXDESC_LINEAR_CDMAX ilog2(SZ_64K / sizeof(struct arm_smmu_cd))
 
 /* Command queue */
 #define CMDQ_ENT_SZ_SHIFT		4
@@ -605,7 +620,7 @@ struct arm_smmu_ctx_desc {
 };
 
 struct arm_smmu_l1_ctx_desc {
-	struct arm_smmu_cd		*l2ptr;
+	struct arm_smmu_cdtab_l2	*l2ptr;
 };
 
 struct arm_smmu_ctx_desc_cfg {
-- 
2.46.0

