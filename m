Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011050.outbound.protection.outlook.com [40.107.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D92CC322527;
	Fri, 27 Mar 2026 15:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774624942; cv=fail; b=h2STk45SK/TkJR6DTY4mQXHRiG2OZmV/kbWxYxTpYL0reTSSSHtsS4YThAIdlDTVYzOCcj5iNHR0CHWfQiIpHHS3+eN1jRSlKwaqk9qS/tgf0J/T6GY/o6ekUYWxAkAwIdNDEjocl3ejr79FRGT6TdPptwi7C2X9CkYh0q+8m+k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774624942; c=relaxed/simple;
	bh=Tcdx7igcV8iuCNVopxe8PAFF8w/I3VJ1024i2Bz1xZY=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=mwicxs2ZWgBhXnbr+y0ypX4PxuT1QBIAsiNjDB8hCGQvlbfOYWXxCsP8Hz1zqCWV6uNAbUVYi/vIdjk6+xG7R0SkrcIy/hH8VFc0Ua/xVDGj1bxe0v44hE/csTRigp6T/K3pK3YNDQTXzHu3K4fsAM53pgQgAcBvR4Nu5GNUltk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WXFKs4DR; arc=fail smtp.client-ip=40.107.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WXFKs4DR"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rgS40XO4YJpYwGyTWThMTvli18bOiACq/lxwAwZ9Xnma0VOvGHnblB563ftJJ2hbob+1vnIszqujifjC3w/SvThKU8OvdsHwhCwDmov8EOTOKqUGNIbzk6Oh2/Vbs+pNMyqhk4uLwS/Li8Dj7S/YR6sOiXDN1GpJHlw7Z91GMs5vLafdEjdci8S2hL1rK8HOqzyK8U6W0r93kwvUDbfJxPUcUGMEq0R68vq1sYd6asePg+TvBbEX5+CK7ovP1QrprzjUynEuXYcumiL+fecDgQsxiGlvGRj8++ps9Oyadu1GzB3V5SPp4ZGp1eYYTqkpqhwMCYxQFDE+d/pXC9hQPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bugBieCFpxf9d71FemlXVLsvdnmyChW3ZG0vbB9Zpo8=;
 b=UVGRPxewXYLrsXoPa+ZEPNlltgXszmnzwrhkkpYYEAByLHcRWW/y+qCu62a5GEq2LPWuq/BYgFgSFATn0ZyuUTIgDbKXUaPEaOa0GdQxv8sBYcVlYsDjS/Y/NtpplbsxXYND+idu09YSJzHKKwr0oiw1+Fa+KChWzXeEk3vvjOhaNt2sZuqMMbg9XMnOUnF5IS/CmLkghMSNzAX7OSo/dxtmZvMnfnkGoPVvDUCW1VVgKhHZ4kFHIK7K/RIt5CPYGMm1KRYioa0ihh6e7uMZc3fdKnbli0H/IKtdfEpXGTrWF16xnjrQZBlNi0sO+ifjo6REDrrE60B/LcZxeWhQ+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bugBieCFpxf9d71FemlXVLsvdnmyChW3ZG0vbB9Zpo8=;
 b=WXFKs4DRP/EqiwcPXFyp6XSISg0eRBytbBePXatoLweijZKmwf6lHn7Oh45USWAtjesiFYnYPTIIbVnRfoxGEDlMfFeboS7kPCxbZn8JnpPjF7DKmErMEIG863QRvFu62OgSfRmCPlsfjeFRzHxK5E+Zz+ooh4yKSWSy86/iUkzmCk0X5TgJFlVx1jDgk8VwrJFLVHkTMFkI6iyFtOcII5d+UA4JhL1NGaft8q/BpUQ04b65G4UcqqFVINYchnKPagLVNOHDJ+FuJXy/T3/GVf3ZuTImZRC+JcGAug4BLn5H903xzmzRPmacVpxOfZsiEi8QDLYKuzr+q/ekY1UGZw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by PH7PR12MB7186.namprd12.prod.outlook.com (2603:10b6:510:202::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.8; Fri, 27 Mar
 2026 15:22:11 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9769.006; Fri, 27 Mar 2026
 15:22:11 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alexandre Ghiti <alex@ghiti.fr>,
	Albert Ou <aou@eecs.berkeley.edu>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-riscv@lists.infradead.org,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <jroedel@suse.de>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	patches@lists.linux.dev,
	Tomasz Jeznach <tjeznach@rivosinc.com>,
	Zong Li <zong.li@sifive.com>
Subject: [PATCH] iommu/riscv: Remove overflows on the invalidation path
Date: Fri, 27 Mar 2026 12:22:10 -0300
Message-ID: <0-v1-0f76ffba5af6+11540-iommupt_inv_riscv_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0982.namprd03.prod.outlook.com
 (2603:10b6:408:109::27) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|PH7PR12MB7186:EE_
X-MS-Office365-Filtering-Correlation-Id: 79ad601c-a26a-402a-519f-08de8c149dd8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	mxrQHR0FboM7t2XNd4I6htpaXpK333PJjGLv5qNhBcNFGU4alCEJSp5uDZuqoKdACsQP0Fq1GVuuNQpdbRJImPpQaXHX8EEAfA5bj/DlohVm3+A3AjaHmk4VGDZuQ8YJbEduUe7pupcYRxCyI+WMpKi9M2y4bZk4ERXPw5bdBxd8w8ZCERg8+07iKYj2Mqew86oDqRWFYNOHDz/4k/0FKT2FBrcQKV5e93X8DWTBeQk0sh26dYNS/DOfT2JER2f/npPCDiF1yxl3M4m3uI+tuoXUCxF2spcC2hhKGcf27fjtOxWT34uRI1o/GERBcxi2nWaTjbYe4xBq9aPn75I5olT4NvACn2yWdCs7QxAjsgRWqhYixTDyrBIk4+PpzZy5Q8XYsGv2CXMBlhp+wXdG3Pq5N/LScDSkyyzEnkJvFjtpoxunhB954w3VJF+/+8Uj9kzkyMF4DbpDW7t5afDX601SmikGADNiKGow8MXQxvtZJLC9oGQo11GrVBzqw7+rCQ/TxgQN0Ux8Lz5VOsiCk8MQnulkTwZvnncY9Ro1hmv8dMWD8/WxJ4XHBebfJoemKa9pwWOcTbfpsmdEtJUbr2DeZ0Cwn61Em/DEaLZhGiXr5Qp3NRMDhEWMH5Uc16mOwdHJcSlkC7dVkZUTC5icOz+8zH0n5Wo/MsnqT/vibJ7dFaxsRFFzs8MRzFREft4usEX8z/SUbkJ5E5D+h2DxBM5w423lMqRSSVtPyX3skw0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jh8d64rS2yu6gQCqDXmjo64pDlKJHvsCXA9fvBBRBVpgd/5/G53W4kZVFjCc?=
 =?us-ascii?Q?uWjDbly1S11SznciqQoFde8oEf9h9zgb6zuLKdcXOXWGoc0be2z8/tl/9UC8?=
 =?us-ascii?Q?XCqJsLW4J0WJQFyii18wD5QfiJvR+mD5RuwBBR557rCFhM8d0swH/vEIuXMs?=
 =?us-ascii?Q?xpQOZvIiWBL4GJ1FCx+UMUPPS671IbShB0977hJh1IzXRFMll1mcGb+xU3Ru?=
 =?us-ascii?Q?axEuzOHcjgAb7GywKCCjLCcZ0AjT/sKv5+mmaZWxsrDJi53m/iLBVfIVoNPW?=
 =?us-ascii?Q?EjQ9JKzJmWbhMGllQrACRg19E+jY5aEbMrE1wBa/w0o1PgBHmeS7SO5Puks9?=
 =?us-ascii?Q?gQYVo5v747SpyV9Lafx7MCM89xGecXd/JL4mphvMnm2P3cVfD/tncW8X0GJD?=
 =?us-ascii?Q?f5OPbxtACJOCTFfuM/tjyiueD7FeQC9AFRyGgZPMBuLXq8vkonM11rgoATs3?=
 =?us-ascii?Q?xB4kyNewzr+pzWMKquMsrxds6sAOWWJ6MKe3uC/RCgy2sNZuX1eD2BlOxP/5?=
 =?us-ascii?Q?bRfJAcK23xt/b3neSJ1i4sCLv74akG6bsSGpoucvfm6S/dTAw9IrVLYsObJm?=
 =?us-ascii?Q?+IPZXYr34TPmhL3qDxscC9HrxS8+EZS7zjzzJZnNfGHlGSSNFpcDNTUlYuOp?=
 =?us-ascii?Q?Q6KorsGWVs1/EuGlcdcLwy3007HL1WZI4efDqUzFS2HgOd3iJMaTpKhGoD41?=
 =?us-ascii?Q?jP895zavxQax7naNoEMEpVsFnjSg4IGShg3ctac5wUFpqcXXx4cLtR1ODdLr?=
 =?us-ascii?Q?e+RgcJHBJ+awEfB1Yme/CE07UCNqb1V9sfv3SlrVrReLF4QL2XRafOIwXJhH?=
 =?us-ascii?Q?1iu7Rd3aWAxniLds9v0yrqXBT+X7oeSHBmnfmRED4vdtWY/HlPV+Y5U4ppPx?=
 =?us-ascii?Q?hrh6C8B5WxXu9/3xUkc4qczLOM7kH4I/CZM8HvFz2mRt4mkpWgNDlBHF4noH?=
 =?us-ascii?Q?7ayCBq3vg2WoM+P9t67ocjBm7pgu4tWHnhC1CPDUOXb1tu8pyWcH/+LQ4e/V?=
 =?us-ascii?Q?LM1zxIQ7Hd5QOqrDH0aHO/cIXoRZN2T4QYAfqEmSAqatb0OWNNzyzI7izODL?=
 =?us-ascii?Q?zZS8xvqCTLteQr0EeDt+/CPa5uCGzgb4bdgZGfSuOGlTila1EC/6LMlvbYRN?=
 =?us-ascii?Q?x2M4YFXGpWmnGGJaOf7zdypDIEz2q5/eRcWfhYNdz3D0ZwLKEsHXVd3ktMIQ?=
 =?us-ascii?Q?FQj9hSANRtvTUhAbgD+h31+WGWHhkm+KdLehBYepWWvVj0EbzrcQrkrqVW34?=
 =?us-ascii?Q?DphZPkG2XII/goMn9KxkC2c4T+uhwKzrQ9yQxNWHdPDxNLVZD0HxQnRGJKAy?=
 =?us-ascii?Q?6y+MA0VKRqj1F0rM7KbMocP7w/A4ictz8k28AM9CFxzUEc+6udTQhAfX/Urr?=
 =?us-ascii?Q?HqEHN+F3KcYO1rJPkhiIAkR1B2SVrIfOjWnrFruUGGInFoIIwqY1GikdP8o4?=
 =?us-ascii?Q?cArFPX7ruBKAi9qd8VMdJZ/+ddGcaQYs3kF8pPrG7Ack8rzuKvg8mtn1z/sL?=
 =?us-ascii?Q?2uh6GpYYBH2YZFZni0tGAGI5K4xRyKdkPwhV1wGxGO8CeuvpgDn93i+b544X?=
 =?us-ascii?Q?NhklyKWlnc5ZSRZZQPbm7UZqyHIUF4RNLg7fEdUiJqA2Gs5BZHBGIclvX1ZN?=
 =?us-ascii?Q?lcttkWLr+wSVf4+/yYULj8hf7r5xjMMWVV5VKPS6bLn1zCMGyrRVDECNd9oC?=
 =?us-ascii?Q?5jpqTJ4vl3aknTl8FP4z9W8eb1NX2CPFISLjA7n5UQZxFwPQ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79ad601c-a26a-402a-519f-08de8c149dd8
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2026 15:22:11.0477
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MxMP1IEkDqOs0q6QBuERVAtJ4OQTloPpOSuHihHXsc04OqYeXThHFUb4LK6JEjAl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7186

Since RISC-V supports a sign extended page table it should support
a gather->end of ULONG_MAX, but if this happens it will infinite loop
because of the overflow.

Also avoid overflow computing the length by moving the +1 to the other
side of the <

Fixes: 488ffbf18171 ("iommu/riscv: Paging domain support")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/riscv/iommu.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/riscv/iommu.c b/drivers/iommu/riscv/iommu.c
index 368f3cbd2d0a96..a31f50bbad3535 100644
--- a/drivers/iommu/riscv/iommu.c
+++ b/drivers/iommu/riscv/iommu.c
@@ -934,8 +934,6 @@ static void riscv_iommu_iotlb_inval(struct riscv_iommu_domain *domain,
 	struct riscv_iommu_bond *bond;
 	struct riscv_iommu_device *iommu, *prev;
 	struct riscv_iommu_command cmd;
-	unsigned long len = end - start + 1;
-	unsigned long iova;
 
 	/*
 	 * For each IOMMU linked with this protection domain (via bonds->dev),
@@ -978,11 +976,14 @@ static void riscv_iommu_iotlb_inval(struct riscv_iommu_domain *domain,
 
 		riscv_iommu_cmd_inval_vma(&cmd);
 		riscv_iommu_cmd_inval_set_pscid(&cmd, domain->pscid);
-		if (len && len < RISCV_IOMMU_IOTLB_INVAL_LIMIT) {
-			for (iova = start; iova < end; iova += PAGE_SIZE) {
+		if (end - start < RISCV_IOMMU_IOTLB_INVAL_LIMIT - 1) {
+			unsigned long iova = start;
+
+			do {
 				riscv_iommu_cmd_inval_set_addr(&cmd, iova);
 				riscv_iommu_cmd_send(iommu, &cmd);
-			}
+			} while (!check_add_overflow(iova, PAGE_SIZE, &iova) &&
+				 iova < end);
 		} else {
 			riscv_iommu_cmd_send(iommu, &cmd);
 		}

base-commit: cbb4dc8cd574b387c7811af91006476c5fa98285
-- 
2.43.0

