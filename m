Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2072.outbound.protection.outlook.com [40.107.236.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AA32254867;
	Thu, 17 Apr 2025 16:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744906878; cv=fail; b=iyIVmSasnwWF+IksQMjhyRQNcjCHJazR92IzwUrofikwTlJWC6AqzWWmQ1ozAPQoBYobIPP0dlX0z3OWU80Viz9x++JvbKLFbRU2TIs8ixcXOYV3S2d69OAKqIK6gl4HXl9U4xOsx/jHNf7QnogDL6bHlxb3y3CjqNRp0WagaMI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744906878; c=relaxed/simple;
	bh=111rs7d6/1/QizZdVsCF67YCSEkshrsEvTq5N19uoPg=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=sZxurp8EQKi9fXBVE12AnBsM80to/k3oWCIqbGNgxTSQN4FdFGVKHBkOweq5tcKpshjaFf4bdKDM8IhEjRXkmArZhSTKCg+/yu0cRiEid1BcrTfNgb0CZqpETAhtopoiPKzBCgoqimttJsu1kj3iO0PbqerHNw91civkQ90DhgY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ENxkuFpL; arc=fail smtp.client-ip=40.107.236.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ENxkuFpL"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uMSs55kqhFzN/DePJwqarH3gs9eo/Y7XL3qjh9F3thiXeTEaOWzV5VtRnskG+T+8bC5shNk2HcC13jojcVgieSUgix8+m1VOh+DD1tRCL1IpwRcMkItj7VgImc/zgdtunBtzadfy5zSFjEpPe6Ksq5QWS4KfA0pKMYPW/l/u6IJ5oaN8br9CChWTvO+l+SHQRJvQxabTdlMfIe5q/Ouotn/r0YlC+hY0cakpz2NrVTFRdXr1GIbdgJpMFQY/rsI8xmVCTEwdyousWu7KYAuX8YtlZ3GA7sb4a9wZ+r4YsEwKqI8IKpy67NRHtfi+rhEIED0KPred0VztLvvvIABcAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b/VdjnxfOxZ815weDg1Rs2+LFIZcKCjnb3MvuBxgWv8=;
 b=uOLKE3QjZG6hzKxKGXJ77rFyoaDOAqJ1+NkcCpt+AYtFs+IVpj3RTA4Qjcah4QP05WmL5+DIx0ZPLmXhaML5tS9sZORdxrPTAkcO9tdSfpv2vb1lOIkP6DZctr0EQHhOgz5H5sfg1RSiM4DeCB0BUAbrTm66AJX8jmgLoUz2RS8ns5h3m4y8pJ4TE/OjJZjwxIC3s20nvPNPx2WW8uOKAa+FApp8eDRPof0498phuOk9Eq5sxsChEVkJJsJJrS10iccw7xBJ4WNt55NImmEQwS1igjtHavW7VYbO8++/LsOms0kWhFP/ZAjxfmpZiAJfccuaGbQ4Em7ZldVSMJ9Spw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b/VdjnxfOxZ815weDg1Rs2+LFIZcKCjnb3MvuBxgWv8=;
 b=ENxkuFpLV84F5xgoH2pxktPewj55WSm9xDeYGaomJtK3qBioRZWjk40mQZozll4ncrwnmxAyDOCmYdQ4HIzFM9Y6AJq8355AXUKU5VP9XoZkEsVtlBHAFDhALJz0vuPJvbsEtnwUkmTTwTTID/BId7BFD+Kv5LDOySFDE/yOtlT8cGJHbQDnu9zZepE7QrFrKcuck8Iv5jEg8pBiA0nD110KDtjNoto7dqqkFfcPqt1w0zS/O2ebvvLL3oeCiSZY/9/vFL9CIz75haX3mIPEhZDFEpG41QlEkra6YNdQBNeExXVDUVUvRbxnSBt08BI+jAin+3M7lOCL4qGOVH1eHA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by IA1PR12MB8262.namprd12.prod.outlook.com (2603:10b6:208:3f6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.36; Thu, 17 Apr
 2025 16:21:10 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8632.030; Thu, 17 Apr 2025
 16:21:09 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Will Deacon <will@kernel.org>
Cc: Joerg Roedel <jroedel@suse.de>,
	Jerry Snitselaar <jsnitsel@redhat.com>,
	patches@lists.linux.dev,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH rc] iommu/amd: Fix geometry.aperture_end for V2 tables
Date: Thu, 17 Apr 2025 13:21:08 -0300
Message-ID: <0-v1-6925ece6b623+296-amdv2_geo_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR20CA0062.namprd20.prod.outlook.com
 (2603:10b6:208:235::31) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|IA1PR12MB8262:EE_
X-MS-Office365-Filtering-Correlation-Id: e1569f92-0129-4fac-9ef9-08dd7dcbdd05
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FyoBY6SeXZsGSJERnnlYEtgEEjt4dt+Y8TmiCqKhkwci5RXY88SL68XA3oMG?=
 =?us-ascii?Q?z2EcBgp8G3DsDZBzcOUd4CYbD8jlGOUu4cVXKMfZ2TMRPB8zPUyRbgNFfw0a?=
 =?us-ascii?Q?nWtlIw3jCIGF9gXUioL6Nkt50CCDADkOoojpXKjgVuCe6/O3Hzur1k2iNyKT?=
 =?us-ascii?Q?mTc9y3Ce4KaaEoMU0DcXVvjSLPstAL0r8nCA8jQv7ap0q7hAJV1FU6AvW6Aw?=
 =?us-ascii?Q?r4yuVDKkWdKTd0DngdBm3xW4jdCrF7DdEMPRrlK63uidSeiBOSLsMj4YGlsf?=
 =?us-ascii?Q?IA8iV8Dbn7eIIFcnXxd5IqbNPU/regTWMV4ltOLWTAYagJj8ISgmzPigsEZp?=
 =?us-ascii?Q?U/2Mnv2OAyiVbrVFaY8dAsiyo1zRRs5HWVp1qrNT1h6jkshKMDd9FJn4RCGz?=
 =?us-ascii?Q?kOvEaaVH/PoKhhA7cOIw4Gc9SYLVha48tZxnwbDPId1PQqepOyE31zPz8RPW?=
 =?us-ascii?Q?BVjiDskGEybujMgsYXYdF25gsKG+XAFMdO9sy3NdhIG9Y1YevHgsbCcHBIdb?=
 =?us-ascii?Q?qLLg8lKzmTLUG4tnABFMqBRGqHxDGUFq+VFHXy8q4+EfobAJjzGcoXT42Jdl?=
 =?us-ascii?Q?uBFm4BBlYg9lFXUAo1J3O7UQnMfE4V2gxVtsC/1uOiHZmp2/hSjTBlGNIOMJ?=
 =?us-ascii?Q?Hn4vmjYIET7n1zVKe5gh+PYuQ0o1tl73GtTwCNxQCpt2HtnwHmrnPIaQEYA6?=
 =?us-ascii?Q?rNUw53/fEULdbJ8jZdRwyaFzk3kyS1Oa0VStnhw12WwE+mDtMTEmSe5PH7XH?=
 =?us-ascii?Q?rckHDL9d+aPNaLPK8MOBpcZAs++5IKvUVaDLC25SLN4kj8glu+EF4g6cx55g?=
 =?us-ascii?Q?X7OyGex7x0fCVlofUmDiq/+KEW9IxJcqs++5wUSOKcNdjZJTBbmY/o7va7m+?=
 =?us-ascii?Q?PQkG+PcMLFj53rwBRsVL2ymJzK9/BEeHMsBX1+TUO6YtumSh5cPzfjsFMJqS?=
 =?us-ascii?Q?XALoIlVDz6BRKSzfz0K/QrrGYcGG8th9Xx/gzRWAaRd05+E1347s7y3Z2BbB?=
 =?us-ascii?Q?axQIjP0XZOXaJKqkqGBAYijwh0ENxHRiEsksqc0E40EiyEMBJKt5GzC0aYoq?=
 =?us-ascii?Q?qQMLpuiuYP/0+tUrOyM6X79l8SH3h/e26enm2gq/XttZ+BG5AY7OsK0VPLbE?=
 =?us-ascii?Q?BhsnSSOH7MJ4TzgnsYzUg0qhGr8253Hu8BQHYngootcYNyf/zW2PpCYfjnMc?=
 =?us-ascii?Q?b5hHQEKlWrJZOJtJuMGWiL5TLfzRXgYRHUkm91snuj5Pl6s2juOny1RTZfpA?=
 =?us-ascii?Q?vMXS0dRgNVmOhHNxsqvrbcGPzoQejGF7xHbCjbNrr9caTBXPUSDph5CABZ3k?=
 =?us-ascii?Q?8ZqaNp+Jrc7G8uMcF0dWlYSiSOAYyRUdGEoKT0NnVuJ5H6ewNVtyloaXHmkJ?=
 =?us-ascii?Q?fTZ+j5MNg5IZGgkmth9bJz6wJ8/Sp/lTTSFyr5c75nIyUZWF5Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wYk6D7KBNLMkGh7YS4Al/2x2jscikOTiDAH+SoDELFsIdkY+kL1d/VJ+W1yR?=
 =?us-ascii?Q?keH68gqTnVoZewDzZn06/10surUHvILvLQz5AuarSeEX4Ix0/artHP3wonkg?=
 =?us-ascii?Q?S9P4t6NyRxChpxBpSlhtf9pEAqr0YypJVkhdKvBKzgCxP61zT6ubglv+POnj?=
 =?us-ascii?Q?5CCysHkhQFYkRQwgiL3PPTiahs931MvWc7a3x96vYPTyUOJCi/KqSpfAe2I7?=
 =?us-ascii?Q?IMEoELrKMOpFJdJUPwepAcDLmMPpzWyoIE2lwGnJ82ckHpUIGpi8LXGohz2t?=
 =?us-ascii?Q?vNEJUH7oPRdTtm+pjharclAnxXN+3PSknprIvITi2X61Tbmx0LeDcrFIqAjj?=
 =?us-ascii?Q?oRJMEIrvfoXOs+RzoK90knhZpmVHmaOffhB7m1/CizWDoiLz5tGlbBnb7xxP?=
 =?us-ascii?Q?5/kKweWHoAuY2P4x4qagawiKo3NcYnFQ7HVOvcFlAtLAJJdLk7I/MfV27ihJ?=
 =?us-ascii?Q?My3CtQa20p+N3rCMz1b4QPEIE45fE5dy5uGsVMayH8Htpbn03XkBi+nXA7IC?=
 =?us-ascii?Q?K+2ctW0pqetCpG1aHzAk8nbEd95fgzB5RiMFTZ7ePhR0IHJ3NhCU2EhO4G2Z?=
 =?us-ascii?Q?t1L6FD/I/i8foOeb5GeLHzYuW8QbK+P5UdCqvjlHi5/axlM91HM/RmX0c29n?=
 =?us-ascii?Q?fOvw2ni0OGXBz8AmDjQKa+cdRsoQlL6wUL1Q9AeuHGVuIWcuHljq2jmJH+Jq?=
 =?us-ascii?Q?z4W69aggoj464e429/UbePGwyeDKT3Ko5XeiI1xSu0Kf7caomNPe/nz+rtll?=
 =?us-ascii?Q?GEJIvMCJY+vd/SGXc1zOmmKjnX40Ee8SANBTDGop2GWhXSmKbi/489qtps2O?=
 =?us-ascii?Q?0PlVun2GgG3Qbp841KP6XNUYvsbOg2ZHiv+gk/nzEB/dv6iAj1bLIHcIuu6b?=
 =?us-ascii?Q?9fkavn3gKAFqDjnwh81QmbH1Nh6uPd7l2AWoOp8R8qQqFYRr50xTflMD2TRN?=
 =?us-ascii?Q?LU1VVWkN5B2v60jy+PLJRI0Be2GWwf5vb7wkzbApgepqaeTJWw9aKzTVWIqz?=
 =?us-ascii?Q?V4k/Xs1hldF5HCa4sXMy0kdWzpRJxjTNuUa/k3FjWM9PX49rX0VodUI7tu56?=
 =?us-ascii?Q?w/n7v7NiQl6WOX6efoYnOa5SXpKPsclhR0P9UIQw+CksVKl3Yo8Xd2hFH115?=
 =?us-ascii?Q?zDGUOit2MeuWPx5BpIWa0QQ4VzT9cu0Nw7AUF2ElXtX5h70ZmAibuDdP4o6Q?=
 =?us-ascii?Q?PfKvcI5P2dyrA79B6IiXeg4/O3S7zwMmXcwK05hreJbYdiBphcRaqQX024Ot?=
 =?us-ascii?Q?p6uw5lSsKgG74VSPBzrZy0vswUbUQFKyI39jHTLEJ9DzhKshlOsgJve/Zrf5?=
 =?us-ascii?Q?94FgvvWnYHC77sDz2du1h4g/Px5ZzNPKTUsodQ5hXaNV/S2X0zT8XXFTpKAO?=
 =?us-ascii?Q?BpHo/Pm2cB3O3j4tkTlv1/zNsdtsFYI8vhuro0YiPkaLbLogql5JLC6DBVIf?=
 =?us-ascii?Q?gdEAi4QLSGgD3e547OV8BuLXOOKLwg+iZN8uof5GWDa1QX0Nysyx85qsbfgy?=
 =?us-ascii?Q?GBSdLsFMVifdpU4DvHJ5bAGwZ+4sQ8Dgpxbi6thpt2Fy+i2myblhyetdquuf?=
 =?us-ascii?Q?PbRh+2CscfQ7xpgfQ15GBD56vYg/HRg4KIblnWLq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1569f92-0129-4fac-9ef9-08dd7dcbdd05
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2025 16:21:09.8530
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CotQ9pnvzqwutrx0HO7S625gVOtmcCcRhvJttpx5WhpLX/CBqSD6HH/izP7hZ5MY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8262

The AMD IOMMU documentation seems pretty clear that the V2 table follows
the normal CPU expectation of sign extension. This is shown in

  Figure 25: AMD64 Long Mode 4-Kbyte Page Address Translation

Where bits Sign-Extend [63:57] == [56]. This is typical for x86 which
would have three regions in the page table: lower, non-canonical, upper.

The manual describes that the V1 table does not sign extend in section
2.2.4 Sharing AMD64 Processor and IOMMU Page Tables GPA-to-SPA

The iommu domain geometry does not directly support sign extended page
tables. The driver should report only one of the lower/upper spaces. Solve
this by removing the top VA bit from the geometry to use only the lower
space.

Adjust dma_max_address() to do this. It now returns:

5 Level:
  Before 0x1ffffffffffffff
  After  0x0ffffffffffffff
4 Level:
  Before 0xffffffffffff
  After  0x7fffffffffff

Fixes: 11c439a19466 ("iommu/amd/pgtbl_v2: Fix domain max address")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/iommu.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

AMD folks: I'm just reading the documentation, it would be good to confirm
this understanding. I'm a bit surprised nobody hit this, but given the domain
aperture was wildly wrong up till 2023 maybe it never gets exercised
carefully.

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index dea0fed7abb044..10af3e9d9ea54e 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2495,8 +2495,14 @@ static inline u64 dma_max_address(enum protection_domain_mode pgtable)
 	if (pgtable == PD_MODE_V1)
 		return ~0ULL;
 
-	/* V2 with 4/5 level page table */
-	return ((1ULL << PM_LEVEL_SHIFT(amd_iommu_gpt_level)) - 1);
+	/*
+	 * V2 with 4/5 level page table. Note that "2.2.6.5 AMD64 4-Kbyte Page
+	 * Translation" shows that the V2 table sign extends the top of the
+	 * address space creating a reserved region in the middle of the
+	 * translation, just like the CPU does. Due to this we can only use half
+	 * of the IOVA.
+	 */
+	return ((1ULL << (PM_LEVEL_SHIFT(amd_iommu_gpt_level) - 1)) - 1);
 }
 
 static bool amd_iommu_hd_support(struct amd_iommu *iommu)

base-commit: 47aadfbd64cdf1f19c83e85ff4ffa9c024619ad6
-- 
2.43.0

