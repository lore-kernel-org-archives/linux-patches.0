Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011033.outbound.protection.outlook.com [40.93.194.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42F3D3CB2D4;
	Fri,  1 May 2026 14:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777645768; cv=fail; b=uBOxjInH8vTAEYhf6xkgU2ZOmkeon05zMV5R8lM8veDTSWGjoUAddi84cwQnU7Fz/9ir0RAIR3AkjTc180RpZe2MaK4G7Q4Nqe2urGA0qrMaPyYUBoiTOQ9Stbw9SYOinutDDgZfmMzqFyNt2gaJekK6vhRCjPvihfchcGT9mOg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777645768; c=relaxed/simple;
	bh=KCdUpPE/ZtREeeGONdzJQt5BB8/asqNwYB1WM0xsVs0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=N2cQ3xyqVqt/kCQaSEuhWGP09tksLN+iWWYbK+Uyx7i5eDW+BorWZwA+L7n+ZC42uPmiDzLGlZJLbMhjy++KLFLuQf93ulUx0o3MFn0CNky9g6D5fvIgELAXkiXSQP2bYN4EVUKK0QOaASk4S9Lkbl8Cf0y+T+5X8Wn34YaGxZ8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=IN5Q33JY; arc=fail smtp.client-ip=40.93.194.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="IN5Q33JY"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FsDJ5HpfZsx6sKgK/TTa3eNHm8KBSS47q1O/LJ80eawRms+E1s9hV+GluJLX4uCuiIpVOq1v7YGheRYTCKM1NCOEZseKaC5DoNp79GtifhUJgJM/J6dLpUVr4insekqI7OVc7xZHJLYv2tntbSb66msYuP80Lsmpo4OBZW/JLrR/Wh4orVpMvKalgDPxezkFY3b+xSi/CiJEVIq/NBQBo1DFVO0Q7/3bbeVuyYlqtbnUWBAg/touJXYKDh5rgSEhQ09ExkR0zdOGvtX1pSWtPuZ83lj8sAFZ1l8J+VXDwdM3dm0lV/fyeIhoHIebJK7qHgvJZkWTusS/t++5JgI4cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w1zx28Csp3vlMyE4358nF01isgI/AWfiuIC5FGzPL+k=;
 b=X4LwCaesy6CRKLB8GuNy+DuHsVbCHDKVMBXPmtqvVuS0DOqbr7iSW0bgJZNR1Zjxd+PsnFAb1Cf8ICR8k9dYjNHfozQdeK8akBq08gWQxLxHPjRzo2VNXl9lBUOmBEin98tdJ44cVjyjAD7keg3lUg2rQzA/lciUb0g7R3ZCtWUAcoBhAs0Ddc2j2wDbK/ir/5oAfQOFsQnjsnN+LNk8AW5F5jwQ2WyTxEUU4XNgvcGgLfzQSPUOLNr8t5KNuT/vUWHCptTY9YGS+IyWzvrt2Rlu/MJMzReAv2hrRasSIUHt2jYUq3O8tQ+8RA1SvZYU58y1jpU8WzmXiXi0mdWtrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w1zx28Csp3vlMyE4358nF01isgI/AWfiuIC5FGzPL+k=;
 b=IN5Q33JYFqON26hY9jUx1UhzAdwyKjpnfGabfuNICQaBCSCp34Gj4p5ALEWDSWxGjVrYLws2fKEvKrsXYbtSnoTGuXGm0xuI/HriQBxRjaSa4sYNgVRHezdV+eRKXTF5bG/xdirhN7ImQQVMhYatrRcl+lHBTLcQfqJ5mYfAz+kA6RuexGaPs9DBM0hqn8ySZq083+v+pGMNtO0HIzqbzWgKKu3vVWBjxESXHQpffD96rDIaLcHXy+7mjCCAeWGNnK5OvUwliziU32DaYpccLp8nxySt14fmO7CDjaL67gi0Jh1Vv2NRtouoVG+2o0g9GfUqZEMup0QpZKHfF0k9rw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by LV3PR12MB9216.namprd12.prod.outlook.com (2603:10b6:408:1a5::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.21; Fri, 1 May
 2026 14:29:20 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9870.022; Fri, 1 May 2026
 14:29:20 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-tegra@vger.kernel.org,
	Robin Murphy <robin.murphy@arm.com>,
	Thierry Reding <thierry.reding@kernel.org>,
	Krishna Reddy <vdumpa@nvidia.com>,
	Will Deacon <will@kernel.org>
Cc: David Matlack <dmatlack@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH 5/9] iommu/arm-smmu-v3: Remove CMDQ_OP_CFGI_CD_ALL from arm_smmu_cmdq_build_cmd()
Date: Fri,  1 May 2026 11:29:14 -0300
Message-ID: <5-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>
In-Reply-To: <0-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR05CA0019.namprd05.prod.outlook.com
 (2603:10b6:208:36e::24) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|LV3PR12MB9216:EE_
X-MS-Office365-Filtering-Correlation-Id: b900f1c1-4ec1-441a-7aca-08dea78e07b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	KYsAFSLqbFrZ0p0gxuKahXu3hOIoDHhigOPN1EHlMcWwIPDlsWKUwLQmGnBocOq4sOXq3s2rIGLbwBJGoCg2BFtoj4+cBvwSCWwiap+PWxErPaNN0tqgb0gnkZpxoHZBHVZ+fFHATjJo1RRlmPLXyXJ10Ntig25e6x+VeYHEcCDYP+IcV5M0j/LbZFct7iQrR7jpR9QN+7Jw0RZcDJb764Mu8eSI6GN4NznLrFV3aqTkPgySDcKsj7+LBgN3czk1euzcg3j78t3Y5Zo42UXHvzixNVaQI9VHUe+6im3mOmF8AR+2ybSe2ohbN28FOfUn++hYQ4srlRUtgKHeznxgvxPJzdhNAxk+pO5K7HCButq0Dw1GKzlgyF6/V5VUavWqhcvMVrUO0BV+3B3J7ivmbkkrfsNw6SamMaNO6TmAgrmHZXbYpg69AUYrgXP4fMmbojtoosv2OBJeytk7KjnvaBc4dh5xquyXQl58RFTV1WK+K65YKSUd5piqUbcirHtwYyoXvgVk17hMREs+A8YNgQtCemVjVis7pUuyDDA16q/odcVhXtvas5TinnsyKhmB6LYrgKdPvF+ChzXAjqkUnyO8iuPdWZMHj5ayFxzX+MUw00HKML5DowPcsppxkLf15cHww4W4B9To8JV7Tt6LQhoeKtGA2IUF49tMbG8tiPbG9O6YCqsNockE5B+Fuh+W
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Nyd5ydipVP09drOG02h5Vpf0ByDn4MdMekd3llNY1ZmrsRTGLwJF63LQANkt?=
 =?us-ascii?Q?oGY2HI/+kz7aFHNXy473QJxHYMOs0zyZTqAg+lhEOBqAf5KHWkD/OY2u7+Ae?=
 =?us-ascii?Q?0JOA+6DNrtdqEQ96qjB09IyTJTahKJzp1/bmaM6N1rXgGshlRbwEqYPsfq5H?=
 =?us-ascii?Q?XPd6hhCLn9SBCOst9TbqCxZ6VUmkQeL1wBEUgl1wDRm6Agfaj95EpUfvekqg?=
 =?us-ascii?Q?wygOHA2f5hgTszjSDLm7A5S2kYZECD4pxXyQKQsjwDgK9aUSFo+SlSwbLMvD?=
 =?us-ascii?Q?O+AUvxFheUzRslv+fasSra5LoEWXQEo7OBMjYVtwsxNy7gyTI+O6/NmJ6I1X?=
 =?us-ascii?Q?MgDoa+34DwsbVCjPMAVtCUpq623a6MO0Uqg+3UCnQ2sypTPpcgt4smRUb1fd?=
 =?us-ascii?Q?1D+IQvfDIqONcFAHGhUO0mwG0diCwDo9xU0ZYKKyuZZv/qNVOYiigZvv+qeL?=
 =?us-ascii?Q?FZwINWssvbkDF+KSORYZ9BW0v02QwIUg1w6yZz488bLgmZWKTbivw9eomkq4?=
 =?us-ascii?Q?O7dO0HINvwqW2+XCYFL9pUrtOLTr2mTBXr8QB1Pfx9/NYRblBxNAaGBn5RUQ?=
 =?us-ascii?Q?RIXbGEVmh6S1e9JHYZQKi5CbQOViFfPi7iYPHWn4Qrv77xyfsq3MB7LT569Q?=
 =?us-ascii?Q?0P0gKylU/jyDVLATapSmtgo64zPcinMT0JTx3/8vfCudcd57YyssUpEJjgNb?=
 =?us-ascii?Q?5zoFdX5srcMaxzONfURYmtC1Y4I7SROh3BeYv3uvL2ktr1NjxrkJ477sc4k8?=
 =?us-ascii?Q?KllovmotzySHLS5rkJpowGYa8o3e7MbBDcl+Yato+841X3m9/24YLT+brAr3?=
 =?us-ascii?Q?3RVXxCGikr0VTdhlAbnqqLq72HwTzkjZ/mU1ZcpYJUA7rk77mpQlvPfuB0OK?=
 =?us-ascii?Q?Onss1yI+4G7XZzJlxt35dm5otmQKufeXqcvhgwdNUX6zdjuU9a0kprXvdWpZ?=
 =?us-ascii?Q?KXpt7CzFW6psV9huy5G+/EXIrKMRCWmgn7iuFlfX266Ki3pH/omuoOvjnp8w?=
 =?us-ascii?Q?5gVx4vyYlCUSk5u+G0gjP+RFrcmTq9jN02UnCgfJRB1K2rUY5VuGgDJNvH0h?=
 =?us-ascii?Q?MCxFzNvOR76TBJDNktr0KQtbeqT0iGLagYTkvCu17Okq6wYfNeMW9Zt7oP4p?=
 =?us-ascii?Q?GuOuAd4JQjLJ6enoI4fMcVCR7ZL0FLEMF3OYkx66vA4AVyn0YFg67B4Zz79u?=
 =?us-ascii?Q?w2lL3u3+Kc/SJv8qkzYbKXNwH8lggI6VUhDUoLI2biN74Djtbm12hbcFX3p1?=
 =?us-ascii?Q?0KM8zThh2ma1P87nH32elZ2czcYmzHHA807Dd9IB3AnQn5O97+xahq3NLCCL?=
 =?us-ascii?Q?uSxIoym3mp0E/5oyJGBi/wrMTL9rTwQWYj4PpwWsKvhcoVyc+F1s2giTfpe9?=
 =?us-ascii?Q?jWGOBc7S9uyFlUP2aNFLC7xmlY8ERgVTzaVM7QFOetFyuFbpSzdFs/HOPl38?=
 =?us-ascii?Q?rO2zUMkMU79IoMvBHvEvZCxy/46ExIkoNYiv/jYQa7osFBnCUXefxhEp2prh?=
 =?us-ascii?Q?jnpIQ1ruFeOyVu1JCkfNd7EAnfndrjnSXf82Rz2Mg80pa/Vb7YJqqaSJEEmg?=
 =?us-ascii?Q?hbatR3vS9MyBO6VWb2KJ9dFwz0JyD552JKjYA+PZe3O3Ysx4g00X+rwiH8sL?=
 =?us-ascii?Q?7ADNmppv7DzfEzMTyW+48proJ1mpxhcT/uwdzyYxXNU6W1E88WO1ABeMPttU?=
 =?us-ascii?Q?RtR8pabNI4i2buLwZQ4Nh+1LZgCzEM/a8GQHiDgkZ1tJZvgw?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b900f1c1-4ec1-441a-7aca-08dea78e07b4
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2026 14:29:19.2565
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3UoIrM7mJWDPpNk6XjaHzvPrGSLEXni1AFty+8xXxRszX6MIqCoDyxfYkQGWfife
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9216

Nothing uses this, just dead code.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index b3ef001ce80d23..ef0907b1a2204f 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -290,9 +290,6 @@ static int arm_smmu_cmdq_build_cmd(struct arm_smmu_cmd *cmd_out,
 		cmd[0] |= FIELD_PREP(CMDQ_CFGI_0_SID, ent->cfgi.sid);
 		cmd[1] |= FIELD_PREP(CMDQ_CFGI_1_LEAF, ent->cfgi.leaf);
 		break;
-	case CMDQ_OP_CFGI_CD_ALL:
-		cmd[0] |= FIELD_PREP(CMDQ_CFGI_0_SID, ent->cfgi.sid);
-		break;
 	case CMDQ_OP_CFGI_ALL:
 		/* Cover the entire SID range */
 		cmd[1] |= FIELD_PREP(CMDQ_CFGI_1_RANGE, 31);
-- 
2.43.0

