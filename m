Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2084.outbound.protection.outlook.com [40.107.220.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECB6C21E08A;
	Mon,  9 Jun 2025 19:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749499119; cv=fail; b=nP8uSkHARkJ+lmDLpLAjdh2jOeog/gFBQrSCQDajIEAOcW7oQJNZWc8ro6sbyvAaH0NdHgHD2ABBZaiDVjJsp1K7tixscSS4jcO2iJ0DpH4t2SQtX/7tfBurOft6LkSkxIbPjLRMAGd8LjHR1EQUGmuHKhvzPnfZwkYHNXrKNGc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749499119; c=relaxed/simple;
	bh=1teefCBTROVkZlrxMnKtTpVtCjj7TwgF09ugE87RhIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gEjn5sS7ltWRyCVhuPL+yEcOzV2i8seC1qj0W7hwYC+VdLpuAhuFbX1CxMm8s5igmcOd4YdVYmD+1YosFpf2+mODr350cCEv5Q3l0UxxOtpMmZVH2jH4Uix35sTn1V7DEb5pTutz5hZ4ZI13PHYGnBKdTeFNHKuEENMrhcGFXr0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=jKnVrGR/; arc=fail smtp.client-ip=40.107.220.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="jKnVrGR/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j7TIN1FurpSwKeXfcdobLuw+6SD6O9FTUH9e2VoDm3DnM7ZJdtWaPJZwBt0uT0kLoSQ4cw9mYm0/II9BhFppzatxmSBZZIS0kV0utRf416SQ0tHU/H3LvPsY/1pHAvCEyESKCSqqMskgMjtS21XwIuP4lYu567v7rOA9MtAnbImrJNBG38mRHNpPLgAQk+WmKHpfA7cSfphirqPg8hi9fcRY68ejEp5c4a9t1hBDDzolLmu0/ssmDI8DeCmXKaDXXfVi9s4bA8h690ING3AxCnTPOk/wD+k+XmTyEnYChI4fUEo5n8pFs+awvKQvlzJyWJYVIf8QVo1TIBtyv0mCag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kRfREMkmZmhiWPp9fYYZl+25Z34KxigsSImi74AllEQ=;
 b=DT8rR44JCtNOPxK0k6W2fq4nDm9qxOouivhKQFri8wKX+nKjynbVVpSPYatyQ8lCxAbAOgJIN3qHbI48Y1daq9VfS4Cel6l6HlfbB10pr2qPkAcG6qSG3b5gGzApa5dQr8EKfCr1DBqWG7gBPdxjMo+FqFjt7L6LZ1wGWkrNfrHcndiGkwKkZSD9b2vJOtRiMXQ7hvweHnWRFEnX/ksrkbZCx6jC2lD2gmZ1pv0bNOQe/2NwDLJrSQVMBI8oMWNcKswZVFeRPDCmS/LIKas1F0B9psUHzTuG6G9yp4+qhHeqOgjy23uq9AJs+O9IoCBYwe3hMVk/NDH37M2Ug0ZUog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kRfREMkmZmhiWPp9fYYZl+25Z34KxigsSImi74AllEQ=;
 b=jKnVrGR/oEr2RdzngIqTDw0Qacp+qZ2gEsg5bMy4WnMWy3hoztvFB3BOBifQHm2AOVe/6UM7laXBsbELgVwM5G9qdsY9doRORi4QRNdmASDJIX1w+1NZADencX7nBM9UPYnjvqJJLqDBSgDMgFfIUXTNq+0O+m6fWZ6OANXUu8Aa5FtvPIo8jDsPmTCtZQj7OMLFaUHKGBvWAF1e55ClfiKsBKffNGSo3v/Cw7Uhf4zYqHCQe74p6tzijfMYlUV34f2Pg7pgsjPbeZf0o8A+Z1qW67Kj5kAMrfY/rEkAY5YkSFfkEmx4ApgVczLeYkTe4TQKsewyHsPLFDZndaDxVg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DS0PR12MB6414.namprd12.prod.outlook.com (2603:10b6:8:cd::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Mon, 9 Jun
 2025 19:58:32 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8792.038; Mon, 9 Jun 2025
 19:58:32 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: patches@lists.linux.dev,
	Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH 3/7] iommu/vtd: Do not wipe out the page table NID when devices detach
Date: Mon,  9 Jun 2025 16:58:22 -0300
Message-ID: <3-v1-20c73f153f4c+1895-vtd_prep_jgg@nvidia.com>
In-Reply-To: <0-v1-20c73f153f4c+1895-vtd_prep_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0323.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10a::29) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DS0PR12MB6414:EE_
X-MS-Office365-Filtering-Correlation-Id: d79b5d4d-1e4b-4a2a-ded9-08dda79000b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8hmhtPuR2xcoRcZZTV70ydPJ58NvdMFycmwnzE9XRwFi9pai3aDUO5zjxvSo?=
 =?us-ascii?Q?n04g3ex8y1sAFCXVqmKfZMGm8FohwdHmCXutVmnN9tL197YrATdc2u12jsRX?=
 =?us-ascii?Q?n+m7reKkRPh4q1tAoZzJMRFiDwS/v/xUE8yKeMw2a+kcHvdVO+MHdlKoQrg7?=
 =?us-ascii?Q?36Ubj3MbxE0lez+lE+iN8HrOiph1cZZMrv2o9wm6RHOEP5DHfc+5MNMSHA3e?=
 =?us-ascii?Q?1HGFbG7+s7fkCHsdvNQ8pz/IzEPdmWBCRoqiAfur0dIYBaev1NHdG3qo8pVw?=
 =?us-ascii?Q?qvjbxPq5Nm0KmtX9KuMUhE3FbsN7MDTv1Qxxo5INQUNByBxZecW6pkZpS3lc?=
 =?us-ascii?Q?ODeA7WjnvlBfG0/efsH29zDXuOBbNatfhsuGo66V3Fn121jWeijFHARKFKps?=
 =?us-ascii?Q?UVX/LSjrKz0oYGgoM2YGdm9X/eI7UDoO3Fq51T1xI9uoFqed4LchvxwlTTuf?=
 =?us-ascii?Q?cmRGrJ/OM5V38OMOhBhLPKKE3MfVE3nSu5T5NCGc31C1mixNBsZG/lF051UF?=
 =?us-ascii?Q?RXA5gDvl45A5p99DjDTb/jWOHKIlR7V/v83FffA4PddL7BY2FQP1EqinO10u?=
 =?us-ascii?Q?lQnlj6YlqvZZykMzTYMuVIVxudzkYtGuPJwEEyspwYwsc2S5iZirK9aVyE6o?=
 =?us-ascii?Q?KYPxPsHh+xZ0V9VQl07ncZ12mh28HKiosgomOm4vzElXnHlRNA6E5/YJiJbm?=
 =?us-ascii?Q?Oo81wwGm8YF0UxyDD9nOJrjxcm4nwuXcKlg14FOx3lZqrrHNdscHTHttH4nL?=
 =?us-ascii?Q?TZqxUP6dWevR+vjJt9AI9yIBG/IymI0rVyVHEPppqksDcN9TQf8/V/EFimll?=
 =?us-ascii?Q?OlK7VNVT51i9D7WZg0PVVvu8yAGbqOHalsavjc+FhaJAC9S/G6POzQU3kI6q?=
 =?us-ascii?Q?1ddk+n3JsrNXZBIueMsQ/XKBnIENzhIaTM984H/tGW4tGH7YmznVD56dBaWj?=
 =?us-ascii?Q?PfuJ04/oZTBWmfv4GCxvVqTLeTngMEXaXjk7YdFfwK+3vki+nQDRd313E9sJ?=
 =?us-ascii?Q?qov/dWZXvQ5+CsI77jdtypcVPwd/PvGjaj3n+Z3GhIdbfWLx0u5dt9eHm+3K?=
 =?us-ascii?Q?EiqzJi2iyoNNV2RQFKQZUcyEILLvOdCMjDbCF3xC63RKRY0fwWPTbNxucQsP?=
 =?us-ascii?Q?nYgrh7if88bSXkIvDOAeT9nXAD77Qk85DT6ZsanEVnAcMB6ukdZzdiiLhUCF?=
 =?us-ascii?Q?KU+lb7ijvMSN5RCdqNkFa/If6VMp1W+MnztFKOZUE7kFt3eRoY1yDp4QwXvu?=
 =?us-ascii?Q?6ECLGWqK7TkPg5YGWqqloTzaZpKHs/r3X45QMd4KTqJzXtu7wPtUt7u/63R1?=
 =?us-ascii?Q?vi1RXAux0hWyUZ0DE/LTjsEKOxclVbgqeNJaI4Li+guagZI03UUuO9qHPnW4?=
 =?us-ascii?Q?+TXklL70Z9frcNxkLbP5YEaxuLswRb0IFh88r3tZw3F8qwkO/7ZcLSybFvv9?=
 =?us-ascii?Q?IylT8DcWtuc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3decBUuojYvcGgNFJ+22GpcWa5+jJLqF7VLYN5PmCByNkb1guRlCLccu/NY2?=
 =?us-ascii?Q?T08ZZERxtmNQld9pZXILiJ8Nvzg6T0x3DL9lUKZ5z/Hdxj6pfkvOblOqDb2w?=
 =?us-ascii?Q?zWhPd/zxdqLuEVkdmre4Y8foRSY27G8dYdAn4YZsfLjCo1IsT7ZM00RdGjBS?=
 =?us-ascii?Q?1K1/Srh6/rr2S2IMbo1lKpG7M0SD0e1KcR5skwVsXVPf1l15DGi3kTH1/nRZ?=
 =?us-ascii?Q?mu3m6R7Ti4BJuxN0ZwXj0OhUtPwTMroxBw3uxVM7QmB5GkeOeLT7Xpe8Nzq1?=
 =?us-ascii?Q?9EwUKHT3qxct+YqkP/GKYisUJd/4L68aCshEIncfRkmlU3tecf/ZKDLqCbBO?=
 =?us-ascii?Q?CYouGu2ey15lTb61MRBaN7VEnsmtfLPKu1le7Ul5VVHWy7DtZht29E0lPxsf?=
 =?us-ascii?Q?zL3hiuqwVenpsEM5Imo6kYe2Yk3fmRt4+JJaP9NB9viD86xD0Vn5LBDQT/4d?=
 =?us-ascii?Q?2St1Er0SduX73LBaezeODU0eMCmSQ89xXlMtXWN9tjffzu4qJ6A4m5r1X5+e?=
 =?us-ascii?Q?gL+gaH+X0zlIlh/oJFnjHKEyJlRfW0/dW2hcLgEuIgTlokmX/4WaJYK/5HOh?=
 =?us-ascii?Q?Yi2PRNiNoSR6feHqlCjKiUA025QlDzlI18IlAerlUUSATmr/yWsbGIY3JN9i?=
 =?us-ascii?Q?hTr/bzKCEbw70VN5Dn9FNEy9QPgKf5tCDv1hfTEH0abd1UxifvEeAD04lLOl?=
 =?us-ascii?Q?d/hRpwFctqwpUbg0y77BjXcMwJ6PoQjXMxKECk6EZkysRd9+bTAJeVmi6z3I?=
 =?us-ascii?Q?H0NlEOExH5Hw6gg1NlC9NyDpka5GUCZodIMxzO7Ms6yRWhKuMiF/HxujawnF?=
 =?us-ascii?Q?yP1ZrsItOHJR44IioXURw6sLMeDEGdVkmdOXtnpLKqD2dW47htR/T+DUs4W/?=
 =?us-ascii?Q?qiNacWYcIPYm25nCd3/jK3yRplteCcOT89WrvpjfKHK4TJ+/dgykgieLCxDO?=
 =?us-ascii?Q?JhHFJAoN6/rlFfqXd0N6yjg7F4Hoc20jL+1q2cMIwZ3UsWlLxP4qmssfN8Lt?=
 =?us-ascii?Q?mzbQbbH6osx6ZV1+lgwZQUWuBLqzpFhgIk3nzsxAT9dDHOcBzS18b6ve2Syb?=
 =?us-ascii?Q?ey2Q5XatdvTVv39Cyhs9DvN4nG4ZAf+kdRegz2gCuWhNe3zSQYfZ+rtstU5n?=
 =?us-ascii?Q?cBXhN45VNeQPSIUrTcpYQErN0zipBhfo6Lh2mypDD0rSEGrIT8Ees2U+ad4b?=
 =?us-ascii?Q?W8xIMQdNsUuGtveb9/ld8fzFzFCnjRYWaKdcXKdwWDynySC9JQi5LpdWejLN?=
 =?us-ascii?Q?cheruMoL8x1x+uw8v5fLRP7JIBLnOH4szPykt5qgWhOPPzDrkaVqGkWmElVh?=
 =?us-ascii?Q?CBfPj4BWaAP+eV52BbnIzxmP0k2CDCgFLUbwbSuaV3Mr0gY+ORqC5Lf/sbsE?=
 =?us-ascii?Q?o1i9PYGbreOHhH6uEX09BKccdoVUsCAI7Q7qIvqvnCrqjlpYTc6qmv1jtLvP?=
 =?us-ascii?Q?qKfYuCje+LjUDj9S9iYteyOkqm0bDbk2Xq4eucdBX52dGtiwB+dCfXlmU4J4?=
 =?us-ascii?Q?9FgEUYXthynNbGUr6P8dK82PDXmLwoPEIqCwsRQx1UKgqoAhnbFvN2f8r3wc?=
 =?us-ascii?Q?nLgppfUGVGNJlbtBIKNIpDfZlYYbQK5jz8KmATE5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d79b5d4d-1e4b-4a2a-ded9-08dda79000b4
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2025 19:58:28.6646
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4Lc3EbfrjjMsV03kS7U6cGEpvwDU78y85UeyXughdBbazByYs68y2rk0HpwR8w57
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6414

The NID is used to control which NUMA node memory for the page table is
allocated it from. It should be a permanent property of the page table
when it was allocated and not change during attach/detach of devices.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/intel/iommu.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index ceb960a796e2ba..72b0769c391008 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -1391,7 +1391,6 @@ void domain_detach_iommu(struct dmar_domain *domain, struct intel_iommu *iommu)
 	if (--info->refcnt == 0) {
 		ida_free(&iommu->domain_ida, info->did);
 		xa_erase(&domain->iommu_array, iommu->seq_id);
-		domain->nid = NUMA_NO_NODE;
 		kfree(info);
 	}
 }
-- 
2.43.0

