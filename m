Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2081.outbound.protection.outlook.com [40.107.94.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6D2A1CB121;
	Thu, 22 Aug 2024 14:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724338036; cv=fail; b=rateTHPXiN/GOBex3i5gEwBO0bRsOuOUh2aX6mu7F8t5aS/MOFZSAShDzu72QG+3YQMwzO56K7xl6wMkzhDx+Z3k1BCRPeN5GiY3mDdG/qHRJvYK8HbE9MbBHiIvFIdIjGPH8QTEM3PiAQxhy6g+WML0LhU0t9oxLD2C2YJrDZo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724338036; c=relaxed/simple;
	bh=BAA6b0e6ga0WxlEZVGOe0tzviJEzyBL4RCxPPJpV5CI=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=sKPUBn3yuUOpJJQ6HaBvKdftxTzFaYSaAnheE0qKmHUtzx0nMxKB9iMEsSeXcDWneJZ778BUz5UCm7mwcUMmllC9mDZDqnamhBXW4JW8PjPcRnZsOV6+BZdz/Dg7Bghrho3ZhjCELaY/CnQdNhb4SeG1KhWW6JurUGcXffV/CLc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=dgehhp1R; arc=fail smtp.client-ip=40.107.94.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="dgehhp1R"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ARn83fIIguCtzhpYIOf03v3hQZt0nbvN7BXVA/K+5sxv/XrpnMtQXX0QqJRYGHqlZAwhlLeDCy3S4GlvRGgOXdABuQgi/V5hnZJ8Os0g/cYP6arzyjzVHu0w61YbmgQ70ADs6sbpgITyl19q4f8ZARxMZOqukglEEjFd6nRJs3AsIJTaaUl1rW0uU/GBncJ7Ykr5/mh8dB75eH+6Rvqp7EomcmAvfiwqqoiM61eDVw3yO/NiOtq8lithaLT9SzkZ/q3DZIAMDr5v+TnUJqS8ORmvvWKOulc/aM/2fsdsvHec9IrFfbvRXx6NjdznGlVr+/YbaLDSiSuZ2Hg9CPfsqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LkXvKbSdQN9fB/uMNldScSyCWxELc5mk/SS7NjT9/C8=;
 b=WCoXYlZ6AysIfZxnZJ1XBXOeNudKG6i/OtVAvPJDmqp4lEz8lXjLlcO3EFV5NGtIJ8fcp9PRGFeP/UYUYHAyOu4mSLPLJUUlC6vuwUDRjxKE5sQi7snIWx15KolWlz4Mjd+Kc/+HjyNhLn9cElZgs3yLLED8RHJ5Fjo1Fz/3uJA41X5JzVVDz4nq8RwuzPFR4oakCe4sD/55TFigtmyUcONvF3j6cAU0Crxaaf88i09ju7pOV10Dbrmh6wNDhHWy0jdQIFjl1w/ccmJ2kLDGNSqIzbDPRf3w5pvYhavraS453NZuFOGniIpDYje8v8qL4qhB7XZ1nF3bkXxcy74cvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LkXvKbSdQN9fB/uMNldScSyCWxELc5mk/SS7NjT9/C8=;
 b=dgehhp1RmGsM6gEkA+D8C7sMDjQWh4gQPx6JQjxU0txFLv97uQVUHFEM+HmYybDOkXkd9KJepIJ98J2ptUglBXxqJTsS3DmHL2cwiqw1yUElWR+Zt18O7+WBPceP2IquvUEZthkN6XruGWw6GSUTeT47MqaJzyi4GX5wxcgpxeqBglENQ0PAe5pqXqaWjqshdBAyK2ZudY42eJ8mmDSK2wuq5YuIVP1Tw9jYZfbGdYt1ZHyYlt4GpYMDEZYYWcfxQzi00mnKmGSdo2hvNQSsN2mzP8tl97UiFp+m+p4rv5/X2pcuKgR+4GUSEXSx9bbHXAFNHka/U2uRruS1HzTuog==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by PH7PR12MB5734.namprd12.prod.outlook.com (2603:10b6:510:1e1::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.19; Thu, 22 Aug
 2024 14:47:10 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7875.023; Thu, 22 Aug 2024
 14:47:10 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>
Cc: Joao Martins <joao.m.martins@oracle.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Matt Ochs <mochs@nvidia.com>,
	patches@lists.linux.dev
Subject: [PATCH] iommufd/selftest: Fix buffer read overrrun in the dirty test
Date: Thu, 22 Aug 2024 11:47:09 -0300
Message-ID: <0-v1-113e8d9e7861+5ae-iommufd_kasan_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0792.namprd03.prod.outlook.com
 (2603:10b6:408:13f::17) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|PH7PR12MB5734:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ca0dc3e-a841-40ab-d312-08dcc2b94d8a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dNk8cGznlHJ9oC5TQI3ykkMgWSR6b0yB+UtT1FEk8JpuJpQleSHobPTvKIot?=
 =?us-ascii?Q?FXC20th2Ll8+pcJIyep9j+ekbV4pIfKYhlwzr3pCBO8cdgbes7hFFVG3KN/3?=
 =?us-ascii?Q?sTES2xKjXHIsW4weK4gffOYkru6x5SkxkHUGQnAwg9qqwzWWxqtR7qqcSoHZ?=
 =?us-ascii?Q?hPjj8E5r9TKbvL/H4HwJuYvpMotdckXKqh95AVdRWAwu0S6jFdtniR0NCE03?=
 =?us-ascii?Q?r7Usm1n9K35xhvZPQ+BvIkUbJyakNHlrdgLcOOwzuIX6O+F9oQFDKLNonmEV?=
 =?us-ascii?Q?P2Cdv6wDV/qlSt8Ep7x+sCrYE5IRtkAL7brmvNlLWCNap4tHt2uu00E6kheq?=
 =?us-ascii?Q?2ClpzP/fsaAOnPcrWp5cLz+S5arTMIju9Pn4Lt2x7OEHCeyHAZqAroKjQyT7?=
 =?us-ascii?Q?lbzu0KK5MOtIaKo80Q5Y1q7soVzfWDvFEjnIMV5t+t7nD87vY29wdP0AJs1a?=
 =?us-ascii?Q?r/NzZ4sWmoYLLBuVy839p253wnOdSU9ZYriwXzLaoXfCIRgLm3QFBAnsfY1M?=
 =?us-ascii?Q?s+weYsA5gNZ/aeMuI+Yly2WBXR4leVr/fxBxmp0RQC//iW9p2PSVRG60hXwL?=
 =?us-ascii?Q?T5M3d2e6NYHo+eSRh9f8TzZsKfxJ6kuj39iDKKwetxzxIRYWn51C/QBnHpPE?=
 =?us-ascii?Q?oWutzRlqds8Bw+92zouiNHoCiRgC70iScb5M+LuTgetX08xcdaRoVNinHvSW?=
 =?us-ascii?Q?6sUaS6Q1dgKy00FMz9gMRK5FVPYzyJG2kEf3LTOvXFiZcdM9EAy3ozx9BszA?=
 =?us-ascii?Q?uZ9Pdj6pHqZFBgyyg+UCsPNIzmmrHpb3u5wT6t43wWCsKgpUNIqi+n8pqmqy?=
 =?us-ascii?Q?MljkGrWGbmXx1oY2u2iOYk+50wB6tzKPTh90EseYZHQBHPZ0MbWed10jTqvu?=
 =?us-ascii?Q?9zJt9fkAo0RIu9FVbTLeEK1wDvVTbFB6W1yvlpmw2GB/X1Yo2qsj+ylzX9fe?=
 =?us-ascii?Q?3esodfNgTiArHOWowSGndPjqQfzEpeUsErYj8UyXI2g7zlCBiAWp8ph3x8vS?=
 =?us-ascii?Q?gU4YrYxfUvzJJXE45j2SzYLtPHilug/tf7sa47PwRiHpRPGDsAMV3plRoQJO?=
 =?us-ascii?Q?dssAjGfdtFfUx2GiNipEWzRrPe/i03x2KL1lGqUQ3StIJ/Pbj34Zlyl06sOn?=
 =?us-ascii?Q?2y9dmCT1TR5C4uNzkX6Zp8ZcoACLpD7LhNC2+tHv1lnx0h1qn6NtBFEcoyff?=
 =?us-ascii?Q?O8z7k8iXE78pVo9hLne+dVeySoEeSJ1qjTtj7/GzLefwvY/Yw6UbltExkYJx?=
 =?us-ascii?Q?EkYmFe1WQa7HHybHLG5ZvvI7jxglx3PYRncBEoOF8HFUraOb8hT74a+zvS5C?=
 =?us-ascii?Q?N+WQ1kJX/DPqd39v0JFw1stouQgnUfFXXodvR+43wrglww=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qlfJvnfWYsc3TRKEzI6PbGrNJBsnxjds511itvJcijugV/Y0XEGFSE30l+nb?=
 =?us-ascii?Q?kDbLFwu4FNqjBR+v6scccqYzWuB6EfR6iR0mmdTJYEKc81DqERhuKU4uzH4+?=
 =?us-ascii?Q?fUuPu61XoMD7mjNRVW3In+sX/mRDh45CcEWI0m9xQj1HEXwPChYXRXfi0SgZ?=
 =?us-ascii?Q?l06chZipUm5UUz3jahiCpn9QCwo814iDzH5i67E5LA9cz0B20uIDXC7ml64S?=
 =?us-ascii?Q?xH4AGAga/tyoZgbipDt0Gs7TClnWA0SJ8uPyvaebBtIOClgORMpNA/AjGaps?=
 =?us-ascii?Q?IN3ksZ4mosPIGrAG8f85m/eKw5LxaJf/c3EMHmD4BQDnLvP4fHaHOdzIoZIp?=
 =?us-ascii?Q?dJG0WWSBCw6dNTZQ9a+Z0+q/TAGeZM2ke1hubeE3kJ1LQ5KE8GX+u9urLAfg?=
 =?us-ascii?Q?uPAfKeuRS3Gzbfk6vSsLK8xx9MKd2K9UbcT+NrVfA707CXwamlnQFxzR0eJb?=
 =?us-ascii?Q?RO/6IzM/dDaRlOPlU5Jo5EQA0OcB5oHSUnmA6REy7zlc25ZZNtClkmkcYAge?=
 =?us-ascii?Q?RDpTUlz4ow1bG5NP8692T+fuRFsBwo8aeAVWCI9FHVCY69gc/uZHxyLo2bu6?=
 =?us-ascii?Q?XS656PfPyM4BYZ9m1Jv3fuIXmMPJEt1AxFbQG+Yd/xPKQqYKJLehoUi5CD2b?=
 =?us-ascii?Q?b6F848BwU9QFXAR+yexHCrcGixKXt/Zpql9iHUgMOCT2qHwSHOPwVvs2F+kd?=
 =?us-ascii?Q?GysWZWplKjNgcCbeBg/mb3JE7WNvvKd6gLj2OwLdlo3JAakuwf0Zuewg4Ywp?=
 =?us-ascii?Q?38eadUXLlXiqmi/GCJvkzCqGgojIDVnA19BV0520LOjBq29Avo9XlaAEl2uv?=
 =?us-ascii?Q?3etsj+M4gaR/jXQU1ZcOcHE4bErClR9fVSxRpwxCot7Bu43yb/qp9C4iy68I?=
 =?us-ascii?Q?K6jitfD2OTDupZQouzFd/DIictt7EscLb+AFspzuaEsiD5Kn+jpM77SkWoId?=
 =?us-ascii?Q?YrtMgRpeMR2AjrxIMkgUZMX12uMTkuVbaMWU40Y7hRV1HxRq08AhCa2jId8o?=
 =?us-ascii?Q?4piRYmbtdf6pVbHfWxwu6Rf+4LN3VbgKDkJ8tmSv7BscjvWIr2v8My/Vlkcd?=
 =?us-ascii?Q?xozB/RW7OHEO0zVkX0qu+L6YybUVVBZv02jM4IthV5AJ8Kv/Kszps+6XQ0Nf?=
 =?us-ascii?Q?XkqFeRBF9BUixHDmHBBx/ou/fUQ5nRuyHgyafjZjdZnYLtF8uDQrvQPE71ef?=
 =?us-ascii?Q?Y/SEolyDCgq+7Yl9CLMAaE7fqp3kSSTNLhhWp3sGFHsbPcnu1a3mKb7BNlWj?=
 =?us-ascii?Q?H5av1C+EkbxjdLkSeiSVZgqicYLFdUP/mFX/Edx4bBKBNmItL+hsdtYm3EsR?=
 =?us-ascii?Q?RaSwwDOAik2OC9ajSAPsSx+i6SqSVVpkq3MmATwlOKFFhIGkeyateSFI8mvN?=
 =?us-ascii?Q?e91V2pr5AVR6teY0gmyT/yZnzfLrddnRKfFBvRYueLwkrliv0d7e0pEdPajj?=
 =?us-ascii?Q?0ivTMm785nP2Mgoo46TbDvCFgUHcYFFALJ/5zsM1a9suVTV70RqhtWLoM6FP?=
 =?us-ascii?Q?oFG0ITuveRqB+MA1WhNCcvcOKdzgBgRvJZhbIZ9Og89p8LIcQnUFR8yug7yq?=
 =?us-ascii?Q?cMgG5ziE8U0IqPRU+yX6RpBLG0ENw9AuvFp1dV5d?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ca0dc3e-a841-40ab-d312-08dcc2b94d8a
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2024 14:47:10.6473
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f0stOCbH0IbAf6F16OMgfJsXoqhM26wGjXt9eosESpHMAsHrJ7TUSTJziydBSrc7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5734

test_bit() is used to read the memory storing the bitmap, however
test_bit() always uses a unsigned long 8 byte access.

If the bitmap is not an aligned size of 64 bits this will now trigger a
KASAN warning reading past the end of the buffer.

Properly round the buffer allocation to an unsigned long size. Continue to
copy_from_user() using a byte granularity.

Fixes: 9560393b830b ("iommufd/selftest: Fix iommufd_test_dirty() to handle <u8 bitmaps")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommufd/selftest.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/iommufd/selftest.c b/drivers/iommu/iommufd/selftest.c
index b60687f57bef3b..c360d5a7675921 100644
--- a/drivers/iommu/iommufd/selftest.c
+++ b/drivers/iommu/iommufd/selftest.c
@@ -1342,7 +1342,7 @@ static int iommufd_test_dirty(struct iommufd_ucmd *ucmd, unsigned int mockpt_id,
 			      unsigned long page_size, void __user *uptr,
 			      u32 flags)
 {
-	unsigned long bitmap_size, i, max;
+	unsigned long i, max;
 	struct iommu_test_cmd *cmd = ucmd->cmd;
 	struct iommufd_hw_pagetable *hwpt;
 	struct mock_iommu_domain *mock;
@@ -1363,15 +1363,14 @@ static int iommufd_test_dirty(struct iommufd_ucmd *ucmd, unsigned int mockpt_id,
 	}
 
 	max = length / page_size;
-	bitmap_size = DIV_ROUND_UP(max, BITS_PER_BYTE);
-
-	tmp = kvzalloc(bitmap_size, GFP_KERNEL_ACCOUNT);
+	tmp = kvzalloc(DIV_ROUND_UP(max, BITS_PER_LONG) * sizeof(unsigned long),
+		       GFP_KERNEL_ACCOUNT);
 	if (!tmp) {
 		rc = -ENOMEM;
 		goto out_put;
 	}
 
-	if (copy_from_user(tmp, uptr, bitmap_size)) {
+	if (copy_from_user(tmp, uptr,DIV_ROUND_UP(max, BITS_PER_BYTE))) {
 		rc = -EFAULT;
 		goto out_free;
 	}

base-commit: f97d3fdab5c314e6afcd6cc27a4af6a7f8735566
-- 
2.46.0

