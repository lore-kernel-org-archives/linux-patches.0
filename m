Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011056.outbound.protection.outlook.com [52.101.57.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40A4529D26E;
	Fri,  1 May 2026 14:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777645779; cv=fail; b=i1GBFd+HnF4GgDQ931t3h2CwzZFqBGAfkRr97c7x7Sg9kiXBY4UHjO/CsuQBsKNZ39U3FghQzrZDiRg7bBG9H1eHM/8CAzm3k2Ezt913l7OFhJMUHkMj2gNsbQFtoljQebK7j4xsZfJpBNRLOVws3He59aiMPb3+Qn3+ltfIxOU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777645779; c=relaxed/simple;
	bh=1d6Zryjt2Xcho7AjLcsUPljGYEhRVQvzJsmqzpPmKig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=o5gm3Vs0iHgmymYcneEQY5/fDN+vfxyrYSqTQUdfTZQsauMyJJESMTt46JDpSx4jkA6C/4KazAotearbAsVYFgqmOMQsSCzxMPZJMfRQHaaveC91xy0BX7Ya1eTj597rkti0PwgdmZ6L8JTcReO08eC7oosmGULdaZhj75QrfJc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=my83klel; arc=fail smtp.client-ip=52.101.57.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="my83klel"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i8GELoM4I6usui9TacnJFK3KmAMXy9kdlwZCrYvFHa/f/e7jsN6LnwnkqEOBCnNdPN0gi6wcUIj2riBLUaJousVJIq3jG5YDmdv/7K3kCKMnDqfPDgIHbgoSdNRVF52wbmgXdBUh11296xTVnCrw6zlh1fUaS9Bzjn22y054dy+EtC2qK/XVPnI7BMQWL51Tu++XbnyunuHjUCvvIKcyLdQWrYewvhfxS6ooQyeUXSnopUCYf7FTE0e+jSGTU0xXpXUk2uCjDd2VbnL0FKnAB8bitDPhpp4L7B0jwPw6BhewSk+ibSDM4o+iFv4BMuwMzkoHtVz8KdJoiuY4n8L9RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NAglE0Pt9QVB5x/AWVz4ctW+Z/Bn6UzRU4oo4nf/ANg=;
 b=ddvLl5bCFajewVpTLTaYt3cNFtjnTfr5/ELOVcVhvw9juUjdUceiN3kNajapXbuQi8Po4A1o1d2kDXN+XJM6XWbhi3pdnqgN+Tf8YfG1j2k3jXLTeOns9jXiWJ8Piuz2FcRYgAR7TzQ2zhFXnzOFfm4nvdNU708b9XE87jEtJYI6cIKtlmfy6TqcD62B7dnJJI7LW8IpO5MJmwkqkz9letlpkX64ZxqT14HXXs+MZrL34pn9cHxqUbb4Qs8ijuIP5SCiJrqYUpYf9bJSBNsLTTnLtbpqtZ0BX/SiHoX1RyS0l8Ukdn6J5U3v0ekCVwwpaNGVz+NfscPyGBj4CD+t9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NAglE0Pt9QVB5x/AWVz4ctW+Z/Bn6UzRU4oo4nf/ANg=;
 b=my83klelovJKyOu5+r/IC2ZY+Hs/Qz1xBQw4kS+Uv77wOtWS4OPnS62oL57ixihTrXHEXPqAa0dXDNQawwni0MDG5noZgFuhnUzc9+k4U6rPTkIKFrpTQqNhI074c3HsTqcSuNwOUbKUJ9/rUDUhgPhrIXSfAMn19uemzK4zf+uW6cRIvzU4/MwuwaniIvjjLFRtIo6xNKJ14kDdimSXpMuSwez+4NlpQxOrv0rrjZGGItRjnCvsCpGNm2GTXdCA8Fo7thTfqMZ3oZGfEZdxPOWx9G2xTAjrwC61jSfl4Er0Gq6jzbsRnnfhNQ2cFntwvd0TbRGOM4vkWIpCHfO+Jg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SA1PR12MB8096.namprd12.prod.outlook.com (2603:10b6:806:326::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.23; Fri, 1 May
 2026 14:29:23 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9870.022; Fri, 1 May 2026
 14:29:23 +0000
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
Subject: [PATCH 6/9] iommu/arm-smmu-v3: Directly encode simple commands
Date: Fri,  1 May 2026 11:29:15 -0300
Message-ID: <6-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>
In-Reply-To: <0-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR05CA0001.namprd05.prod.outlook.com
 (2603:10b6:208:c0::14) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SA1PR12MB8096:EE_
X-MS-Office365-Filtering-Correlation-Id: 42864339-98b3-4f09-62c6-08dea78e087a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	DB71yn8g6WJqvylHyU22anbhNGuZbU+qKxUrZCfrFr1Q8Qdj089fDhxfVvixmXd+B2MT05tPEpvZZuQNfuKbm3R541NfFzsKKNdS4UZxCjGi/p9N2vptM5QfoE57wjL7371LfChZ76GnGB0TNPiHX76rWjKQdL7nBfsdMamTZBt+mbbn0qiGfjhTrHjV80Vc7Sdpm13wllcNX9SyOG2soGx91Laqy4mF3ebTZinmt6uUxacivtAcPZZ6QeOdo3TP0mmxFLo+nCoqhX9S5D9xPcsKQJiJYwW8U6RKyC6SHHX/aOipl6Q+Tnp4yY91QtsCDufQT63BWp8iWr2f0HoGOK44WuFjRrT5BusfvwhVeT6Ho9IsGj1JbkFcJpD6ceUXLFAdBvywjadScWPzFhEm4CFaT1vkHU5Lp08gdgiZbo74rNgS5lqTKjSCWJwMRI4khAYactSLL7c80XvGxf2/OliAsCUd+SRKQD/eMA1w/cVFZ18QjPgH5npGV1Hw6fiLA4DjF0dpiJ9RKBk7xK7EjLGHFVX39IG3jlEwXSOUd9hdmVE3AgijfW1TZxZgkpkwGKs7X+bDTE/TcOJmFo/0PhOyDLoYXD8RCL2PIhpJZmdeZH6P8ZKpRUBWmDacuODJxeDWumqc9UfrhvG4XydYoOvz2aOltVTcLxHoZChAgzJucqr1gH0ja7JRCELQniCd
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0RWoZ6Qdtb0vYFVLmCqJnYKJOrdqztV7XL6hJ5f+cCeZvcLAKXDkv5QIUU9A?=
 =?us-ascii?Q?6lY8wEbmWxrcLQFtF+TIa3SRI5DTisQGae2tayggtnwGZUe8OK3kVUHdfLVS?=
 =?us-ascii?Q?M+lGNIsU2vOi9+0WVxBn7OwSyGtl/UqwTGPSHMahr2SO4E4cYf3AOUo71T7q?=
 =?us-ascii?Q?P/oEZzEtomKZYV2ORajgLeXRfI2LaARFw126YGTktzXla7wEvmh2R8MAvJQz?=
 =?us-ascii?Q?02jsBlR1t3yLuvx9+hutbwatWGiVTJeNDni6C3rdbJUW7I2AvLFB8G9lKqXy?=
 =?us-ascii?Q?PuMxzXneYZQg7oqsUYjYcJGrZ65HPnONm9X0TtbB/4nggUYBvrrxOHOGsjRl?=
 =?us-ascii?Q?Mqck4wCk8J7/Acb45FPWvP+gmZVJMBzvU4BlulvDL4jMyDKmax05Q15EhUvV?=
 =?us-ascii?Q?MKLuJ8OkV7EAiiybP2m7pyEEsTkZO/nYPy5Rj9odRXqFewB7T9JlX6fNYPhV?=
 =?us-ascii?Q?P8npWRgw3PGkhlFtJEBLzvYbcfX4jgTATaMLHM6u1fU1CopQnh3XVvhOEMsV?=
 =?us-ascii?Q?8O0kRkyKk8jg0l64svqNNBpKBbpU1zqSIo43mYoipeuKV2UvMd0lrlP+pO5G?=
 =?us-ascii?Q?Gfm4e6G9AQ5KlkijNbGgwCWEcbAZOCjoCJ7qp7B6t1CvTtWl05EJBZDju1Aw?=
 =?us-ascii?Q?u/+Jes/SoSAmzMJ1KMoU9Xgsu9yE8qkYjuvgSFVwXXcKXK0gsT4CT3T7jxWQ?=
 =?us-ascii?Q?tfyFsbWaTbyZgKd63nu0tuqyKl4nSsBmTHh8ATCt/k4JPA1s19urN524xaIF?=
 =?us-ascii?Q?gNRjULAUU9Oz0bmr1dIAz0jW9jRS2AYw9hwtOufSBYoWdvGcD4LazoSSYXCn?=
 =?us-ascii?Q?OgpAJkvnYC0GVSB3mi6kke7sqfkMSvS1B0mCddA3RYUs7KwiIExh949L+dBs?=
 =?us-ascii?Q?B/LmauvxrK05hzI5wjXxGT8q3C5PuNLrT9OYgg3vqY2kap+z2bBzmSsyomO5?=
 =?us-ascii?Q?mvAtgUMMWZCTXpG+yaXN/3T6NzVNK48iBtXIxjPEolZyRWyosjimMrhNfBiv?=
 =?us-ascii?Q?NAdc0RI/WyLfLGVTfYGqCHg0zAgVwVzDm/kkWpl0rU6E2kltOq78pLS0rq8E?=
 =?us-ascii?Q?tS99Ru4/jc4lPRt7+VzHMhe97Chy1GC+hKh0opcd6E5CYg5UNaB44u9eb6FY?=
 =?us-ascii?Q?NKt7miPuHdfNTJWdEvX/IQHwD/TLg5Vpfi2MlPPCboPjreM7ZArDzdFIgIzF?=
 =?us-ascii?Q?5J1oyc28H3hMkVmwDTaMEjnzCPQIT0C1eLTKHFdZ7+i6tTZZEHakcBoLEGUx?=
 =?us-ascii?Q?OgzozkbYnHHTmKvM3Uyo3NCn3Y8iP4Pn0U0eqOaDevfWMmghnVxUthOP1XWq?=
 =?us-ascii?Q?HgujzY8FuTa+q7Tn9TnJRtc/FVVnSGB2SVw43IRCTbxAZlNax8okO8A6RzAy?=
 =?us-ascii?Q?0tt7ckQQIS194V8ZEcCFz2tHUqYRQdyZcyckx4s0EOumodwYZwrilebw4neC?=
 =?us-ascii?Q?BqCQ4hm7xZucn/MfgDXPo6HezRjiDe0FtK8hDfXUjpf3jWF1kRGJOABis9EE?=
 =?us-ascii?Q?lOiDo/YtNWRxX8L5X9IJ4Xz4WQ3xC5eiFuCm9brtYxEp8wBp6bLwsRR2uOSV?=
 =?us-ascii?Q?bFxy0SK17H21Lznm8SS8cgmTmwXbKeyM9EO2UPqtp/ZsgU/oXvtHmNePc+hH?=
 =?us-ascii?Q?LEo534Y9VhPUnrUJFDZeeVLwTBBf5MMX9lWPzpjP2xcJnF4PkCC0764ZuABC?=
 =?us-ascii?Q?YtHThCuuREFRLuUULdAWScB9PHeroDOcosLWCgd7UjkHehVK?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42864339-98b3-4f09-62c6-08dea78e087a
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2026 14:29:20.8024
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A3J64A+zmtxJtbO3Y8a/HmJfOJ3QfG8ASgmQzwbXJExkiqzfTlV47Mz6A5A+SQF1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8096

Add make functions to build commands for

 CMDQ_OP_TLBI_EL2_ALL
 CMDQ_OP_TLBI_NSNH_ALL
 CMDQ_OP_CFGI_ALL
 CMDQ_OP_PREFETCH_CFG
 CMDQ_OP_CFGI_STE
 CMDQ_OP_CFGI_CD
 CMDQ_OP_RESUME
 CMDQ_OP_PRI_RESP

Convert all of these call sites to use the make function instead of
going through arm_smmu_cmdq_build_cmd(). Use a #define so the general
pattern is always:

   arm_smmu_cmdq_issue_cmd(smmu, arm_smmu_make_cmd_XX(..));

Add arm_smmu_cmdq_batch_add_cmd() which takes struct arm_smmu_cmd
directly to match the new flow.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 213 +++++++-------------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h | 109 +++++++---
 2 files changed, 151 insertions(+), 171 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index ef0907b1a2204f..f9c25ca9a9e7b8 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -277,23 +277,6 @@ static int arm_smmu_cmdq_build_cmd(struct arm_smmu_cmd *cmd_out,
 	cmd[0] |= FIELD_PREP(CMDQ_0_OP, ent->opcode);
 
 	switch (ent->opcode) {
-	case CMDQ_OP_TLBI_EL2_ALL:
-	case CMDQ_OP_TLBI_NSNH_ALL:
-		break;
-	case CMDQ_OP_PREFETCH_CFG:
-		cmd[0] |= FIELD_PREP(CMDQ_PREFETCH_0_SID, ent->prefetch.sid);
-		break;
-	case CMDQ_OP_CFGI_CD:
-		cmd[0] |= FIELD_PREP(CMDQ_CFGI_0_SSID, ent->cfgi.ssid);
-		fallthrough;
-	case CMDQ_OP_CFGI_STE:
-		cmd[0] |= FIELD_PREP(CMDQ_CFGI_0_SID, ent->cfgi.sid);
-		cmd[1] |= FIELD_PREP(CMDQ_CFGI_1_LEAF, ent->cfgi.leaf);
-		break;
-	case CMDQ_OP_CFGI_ALL:
-		/* Cover the entire SID range */
-		cmd[1] |= FIELD_PREP(CMDQ_CFGI_1_RANGE, 31);
-		break;
 	case CMDQ_OP_TLBI_NH_VA:
 		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_VMID, ent->tlbi.vmid);
 		fallthrough;
@@ -333,26 +316,6 @@ static int arm_smmu_cmdq_build_cmd(struct arm_smmu_cmd *cmd_out,
 		cmd[1] |= FIELD_PREP(CMDQ_ATC_1_SIZE, ent->atc.size);
 		cmd[1] |= ent->atc.addr & CMDQ_ATC_1_ADDR_MASK;
 		break;
-	case CMDQ_OP_PRI_RESP:
-		cmd[0] |= FIELD_PREP(CMDQ_0_SSV, ent->substream_valid);
-		cmd[0] |= FIELD_PREP(CMDQ_PRI_0_SSID, ent->pri.ssid);
-		cmd[0] |= FIELD_PREP(CMDQ_PRI_0_SID, ent->pri.sid);
-		cmd[1] |= FIELD_PREP(CMDQ_PRI_1_GRPID, ent->pri.grpid);
-		switch (ent->pri.resp) {
-		case PRI_RESP_DENY:
-		case PRI_RESP_FAIL:
-		case PRI_RESP_SUCC:
-			break;
-		default:
-			return -EINVAL;
-		}
-		cmd[1] |= FIELD_PREP(CMDQ_PRI_1_RESP, ent->pri.resp);
-		break;
-	case CMDQ_OP_RESUME:
-		cmd[0] |= FIELD_PREP(CMDQ_RESUME_0_SID, ent->resume.sid);
-		cmd[0] |= FIELD_PREP(CMDQ_RESUME_0_RESP, ent->resume.resp);
-		cmd[1] |= FIELD_PREP(CMDQ_RESUME_1_STAG, ent->resume.stag);
-		break;
 	case CMDQ_OP_CMD_SYNC:
 		if (ent->sync.msiaddr) {
 			cmd[0] |= FIELD_PREP(CMDQ_SYNC_0_CS, CMDQ_SYNC_0_CS_IRQ);
@@ -924,25 +887,24 @@ int arm_smmu_cmdq_issue_cmdlist(struct arm_smmu_device *smmu,
 	return ret;
 }
 
-static int __arm_smmu_cmdq_issue_cmd(struct arm_smmu_device *smmu,
-				     struct arm_smmu_cmd *cmd,
-				     bool sync)
+static int arm_smmu_cmdq_issue_cmd_p(struct arm_smmu_device *smmu,
+				     struct arm_smmu_cmd *cmd, bool sync)
 {
 	return arm_smmu_cmdq_issue_cmdlist(
 		smmu, arm_smmu_get_cmdq(smmu, cmd), cmd, 1, sync);
 }
 
-static int arm_smmu_cmdq_issue_cmd(struct arm_smmu_device *smmu,
-				   struct arm_smmu_cmd *cmd)
-{
-	return __arm_smmu_cmdq_issue_cmd(smmu, cmd, false);
-}
+#define arm_smmu_cmdq_issue_cmd(smmu, cmd)                      \
+	({                                                      \
+		struct arm_smmu_cmd __cmd = cmd;                \
+		arm_smmu_cmdq_issue_cmd_p(smmu, &__cmd, false); \
+	})
 
-static int arm_smmu_cmdq_issue_cmd_with_sync(struct arm_smmu_device *smmu,
-					     struct arm_smmu_cmd *cmd)
-{
-	return __arm_smmu_cmdq_issue_cmd(smmu, cmd, true);
-}
+#define arm_smmu_cmdq_issue_cmd_with_sync(smmu, cmd)           \
+	({                                                     \
+		struct arm_smmu_cmd __cmd = cmd;               \
+		arm_smmu_cmdq_issue_cmd_p(smmu, &__cmd, true); \
+	})
 
 static void arm_smmu_cmdq_batch_init_cmd(struct arm_smmu_device *smmu,
 					 struct arm_smmu_cmdq_batch *cmds,
@@ -962,14 +924,41 @@ static void arm_smmu_cmdq_batch_init(struct arm_smmu_device *smmu,
 	arm_smmu_cmdq_batch_init_cmd(smmu, cmds, &cmd);
 }
 
+static void arm_smmu_cmdq_batch_add_cmd_p(struct arm_smmu_device *smmu,
+					  struct arm_smmu_cmdq_batch *cmds,
+					  struct arm_smmu_cmd *cmd)
+{
+	bool force_sync = (cmds->num == CMDQ_BATCH_ENTRIES - 1) &&
+			  (smmu->options & ARM_SMMU_OPT_CMDQ_FORCE_SYNC);
+	bool unsupported_cmd;
+
+	unsupported_cmd = !arm_smmu_cmdq_supports_cmd(cmds->cmdq, cmd);
+	if (force_sync || unsupported_cmd) {
+		arm_smmu_cmdq_issue_cmdlist(smmu, cmds->cmdq, cmds->cmds,
+					    cmds->num, true);
+		arm_smmu_cmdq_batch_init_cmd(smmu, cmds, cmd);
+	}
+
+	if (cmds->num == CMDQ_BATCH_ENTRIES) {
+		arm_smmu_cmdq_issue_cmdlist(smmu, cmds->cmdq, cmds->cmds,
+					    cmds->num, false);
+		arm_smmu_cmdq_batch_init_cmd(smmu, cmds, cmd);
+	}
+
+	cmds->cmds[cmds->num++] = *cmd;
+}
+
+#define arm_smmu_cmdq_batch_add_cmd(smmu, cmds, cmd)               \
+	({                                                         \
+		struct arm_smmu_cmd __cmd = cmd;                   \
+		arm_smmu_cmdq_batch_add_cmd_p(smmu, cmds, &__cmd); \
+	})
+
 static void arm_smmu_cmdq_batch_add(struct arm_smmu_device *smmu,
 				    struct arm_smmu_cmdq_batch *cmds,
 				    struct arm_smmu_cmdq_ent *ent)
 {
-	bool force_sync = (cmds->num == CMDQ_BATCH_ENTRIES - 1) &&
-			  (smmu->options & ARM_SMMU_OPT_CMDQ_FORCE_SYNC);
 	struct arm_smmu_cmd cmd;
-	bool unsupported_cmd;
 
 	if (unlikely(arm_smmu_cmdq_build_cmd(&cmd, ent))) {
 		dev_warn(smmu->dev, "ignoring unknown CMDQ opcode 0x%x\n",
@@ -977,20 +966,7 @@ static void arm_smmu_cmdq_batch_add(struct arm_smmu_device *smmu,
 		return;
 	}
 
-	unsupported_cmd = !arm_smmu_cmdq_supports_cmd(cmds->cmdq, &cmd);
-	if (force_sync || unsupported_cmd) {
-		arm_smmu_cmdq_issue_cmdlist(smmu, cmds->cmdq, cmds->cmds,
-					    cmds->num, true);
-		arm_smmu_cmdq_batch_init_cmd(smmu, cmds, &cmd);
-	}
-
-	if (cmds->num == CMDQ_BATCH_ENTRIES) {
-		arm_smmu_cmdq_issue_cmdlist(smmu, cmds->cmdq, cmds->cmds,
-					    cmds->num, false);
-		arm_smmu_cmdq_batch_init_cmd(smmu, cmds, &cmd);
-	}
-
-	cmds->cmds[cmds->num++] = cmd;
+	arm_smmu_cmdq_batch_add_cmd_p(smmu, cmds, &cmd);
 }
 
 static int arm_smmu_cmdq_batch_submit(struct arm_smmu_device *smmu,
@@ -1003,32 +979,29 @@ static int arm_smmu_cmdq_batch_submit(struct arm_smmu_device *smmu,
 static void arm_smmu_page_response(struct device *dev, struct iopf_fault *unused,
 				   struct iommu_page_response *resp)
 {
-	struct arm_smmu_cmdq_ent cmd = {0};
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
-	int sid = master->streams[0].id;
-	struct arm_smmu_cmd hw_cmd;
+	u8 resume_resp;
 
 	if (WARN_ON(!master->stall_enabled))
 		return;
 
-	cmd.opcode		= CMDQ_OP_RESUME;
-	cmd.resume.sid		= sid;
-	cmd.resume.stag		= resp->grpid;
 	switch (resp->code) {
 	case IOMMU_PAGE_RESP_INVALID:
 	case IOMMU_PAGE_RESP_FAILURE:
-		cmd.resume.resp = CMDQ_RESUME_0_RESP_ABORT;
+		resume_resp = CMDQ_RESUME_0_RESP_ABORT;
 		break;
 	case IOMMU_PAGE_RESP_SUCCESS:
-		cmd.resume.resp = CMDQ_RESUME_0_RESP_RETRY;
+		resume_resp = CMDQ_RESUME_0_RESP_RETRY;
 		break;
 	default:
+		resume_resp = CMDQ_RESUME_0_RESP_TERM;
 		break;
 	}
 
-	arm_smmu_cmdq_build_cmd(&hw_cmd, &cmd);
-	arm_smmu_cmdq_issue_cmd(master->smmu, &hw_cmd);
-
+	arm_smmu_cmdq_issue_cmd(master->smmu,
+				arm_smmu_make_cmd_resume(master->streams[0].id,
+							 resp->grpid,
+							 resume_resp));
 	/*
 	 * Don't send a SYNC, it doesn't do anything for RESUME or PRI_RESP.
 	 * RESUME consumption guarantees that the stalled transaction will be
@@ -1552,19 +1525,14 @@ static void arm_smmu_sync_cd(struct arm_smmu_master *master,
 	size_t i;
 	struct arm_smmu_cmdq_batch cmds;
 	struct arm_smmu_device *smmu = master->smmu;
-	struct arm_smmu_cmdq_ent cmd = {
-		.opcode	= CMDQ_OP_CFGI_CD,
-		.cfgi	= {
-			.ssid	= ssid,
-			.leaf	= leaf,
-		},
-	};
+	struct arm_smmu_cmd cmd = arm_smmu_make_cmd_cfgi_cd(0, ssid, leaf);
 
-	arm_smmu_cmdq_batch_init(smmu, &cmds, &cmd);
-	for (i = 0; i < master->num_streams; i++) {
-		cmd.cfgi.sid = master->streams[i].id;
-		arm_smmu_cmdq_batch_add(smmu, &cmds, &cmd);
-	}
+	arm_smmu_cmdq_batch_init_cmd(smmu, &cmds, &cmd);
+	for (i = 0; i < master->num_streams; i++)
+		arm_smmu_cmdq_batch_add_cmd(
+			smmu, &cmds,
+			arm_smmu_make_cmd_cfgi_cd(master->streams[i].id, ssid,
+						  leaf));
 
 	arm_smmu_cmdq_batch_submit(smmu, &cmds);
 }
@@ -1857,17 +1825,10 @@ static void arm_smmu_ste_writer_sync_entry(struct arm_smmu_entry_writer *writer)
 {
 	struct arm_smmu_ste_writer *ste_writer =
 		container_of(writer, struct arm_smmu_ste_writer, writer);
-	struct arm_smmu_cmdq_ent ent = {
-		.opcode	= CMDQ_OP_CFGI_STE,
-		.cfgi	= {
-			.sid	= ste_writer->sid,
-			.leaf	= true,
-		},
-	};
-	struct arm_smmu_cmd cmd;
 
-	arm_smmu_cmdq_build_cmd(&cmd, &ent);
-	arm_smmu_cmdq_issue_cmd_with_sync(writer->master->smmu, &cmd);
+	arm_smmu_cmdq_issue_cmd_with_sync(
+		writer->master->smmu,
+		arm_smmu_make_cmd_cfgi_ste(ste_writer->sid, true));
 }
 
 static const struct arm_smmu_entry_writer_ops arm_smmu_ste_writer_ops = {
@@ -1892,17 +1853,9 @@ static void arm_smmu_write_ste(struct arm_smmu_master *master, u32 sid,
 	arm_smmu_write_entry(&ste_writer.writer, ste->data, target->data);
 
 	/* It's likely that we'll want to use the new STE soon */
-	if (!(smmu->options & ARM_SMMU_OPT_SKIP_PREFETCH)) {
-		struct arm_smmu_cmdq_ent
-			prefetch_ent = { .opcode = CMDQ_OP_PREFETCH_CFG,
-					 .prefetch = {
-						 .sid = sid,
-					 } };
-		struct arm_smmu_cmd prefetch_cmd;
-
-		arm_smmu_cmdq_build_cmd(&prefetch_cmd, &prefetch_ent);
-		arm_smmu_cmdq_issue_cmd(smmu, &prefetch_cmd);
-	}
+	if (!(smmu->options & ARM_SMMU_OPT_SKIP_PREFETCH))
+		arm_smmu_cmdq_issue_cmd(smmu,
+					arm_smmu_make_cmd_prefetch_cfg(sid));
 }
 
 void arm_smmu_make_abort_ste(struct arm_smmu_ste *target)
@@ -2327,22 +2280,10 @@ static void arm_smmu_handle_ppr(struct arm_smmu_device *smmu, u64 *evt)
 		 evt[0] & PRIQ_0_PERM_EXEC ? "X" : "",
 		 evt[1] & PRIQ_1_ADDR_MASK);
 
-	if (last) {
-		struct arm_smmu_cmdq_ent ent = {
-			.opcode			= CMDQ_OP_PRI_RESP,
-			.substream_valid	= ssv,
-			.pri			= {
-				.sid	= sid,
-				.ssid	= ssid,
-				.grpid	= grpid,
-				.resp	= PRI_RESP_DENY,
-			},
-		};
-		struct arm_smmu_cmd cmd;
-
-		arm_smmu_cmdq_build_cmd(&cmd, &ent);
-		arm_smmu_cmdq_issue_cmd(smmu, &cmd);
-	}
+	if (last)
+		arm_smmu_cmdq_issue_cmd(
+			smmu, arm_smmu_make_cmd_pri_resp(sid, ssid, ssv, grpid,
+							 PRI_RESP_DENY));
 }
 
 static irqreturn_t arm_smmu_priq_thread(int irq, void *dev)
@@ -3464,7 +3405,7 @@ static void arm_smmu_inv_flush_iotlb_tag(struct arm_smmu_inv *inv)
 
 	cmd.opcode = inv->nsize_opcode;
 	arm_smmu_cmdq_build_cmd(&hw_cmd, &cmd);
-	arm_smmu_cmdq_issue_cmd_with_sync(inv->smmu, &hw_cmd);
+	arm_smmu_cmdq_issue_cmd_with_sync(inv->smmu, hw_cmd);
 }
 
 /* Should be installed after arm_smmu_install_ste_for_dev() */
@@ -4827,8 +4768,6 @@ static int arm_smmu_device_reset(struct arm_smmu_device *smmu)
 {
 	int ret;
 	u32 reg, enables;
-	struct arm_smmu_cmdq_ent ent;
-	struct arm_smmu_cmd cmd;
 
 	/* Clear CR0 and sync (disables SMMU and queue processing) */
 	reg = readl_relaxed(smmu->base + ARM_SMMU_CR0);
@@ -4875,20 +4814,16 @@ static int arm_smmu_device_reset(struct arm_smmu_device *smmu)
 	}
 
 	/* Invalidate any cached configuration */
-	ent.opcode = CMDQ_OP_CFGI_ALL;
-	arm_smmu_cmdq_build_cmd(&cmd, &ent);
-	arm_smmu_cmdq_issue_cmd_with_sync(smmu, &cmd);
+	arm_smmu_cmdq_issue_cmd_with_sync(smmu, arm_smmu_make_cmd_cfgi_all());
 
 	/* Invalidate any stale TLB entries */
 	if (smmu->features & ARM_SMMU_FEAT_HYP) {
-		ent.opcode = CMDQ_OP_TLBI_EL2_ALL;
-		arm_smmu_cmdq_build_cmd(&cmd, &ent);
-		arm_smmu_cmdq_issue_cmd_with_sync(smmu, &cmd);
+		arm_smmu_cmdq_issue_cmd_with_sync(
+			smmu, arm_smmu_make_cmd_op(CMDQ_OP_TLBI_EL2_ALL));
 	}
 
-	ent.opcode = CMDQ_OP_TLBI_NSNH_ALL;
-	arm_smmu_cmdq_build_cmd(&cmd, &ent);
-	arm_smmu_cmdq_issue_cmd_with_sync(smmu, &cmd);
+	arm_smmu_cmdq_issue_cmd_with_sync(
+		smmu, arm_smmu_make_cmd_op(CMDQ_OP_TLBI_NSNH_ALL));
 
 	/* Event queue */
 	writeq_relaxed(smmu->evtq.q.q_base, smmu->base + ARM_SMMU_EVTQ_BASE);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 1fe6917448b774..10b3d95d9ee660 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -437,6 +437,12 @@ struct arm_smmu_cmd {
 #define CMDQ_PRI_1_GRPID		GENMASK_ULL(8, 0)
 #define CMDQ_PRI_1_RESP			GENMASK_ULL(13, 12)
 
+enum pri_resp {
+	PRI_RESP_DENY = 0,
+	PRI_RESP_FAIL = 1,
+	PRI_RESP_SUCC = 2,
+};
+
 #define CMDQ_RESUME_0_RESP_TERM		0UL
 #define CMDQ_RESUME_0_RESP_RETRY	1UL
 #define CMDQ_RESUME_0_RESP_ABORT	2UL
@@ -475,6 +481,77 @@ enum arm_smmu_cmdq_opcode {
 	CMDQ_OP_CMD_SYNC = 0x46,
 };
 
+static inline struct arm_smmu_cmd
+arm_smmu_make_cmd_op(enum arm_smmu_cmdq_opcode op)
+{
+	struct arm_smmu_cmd cmd = {};
+
+	cmd.data[0] = FIELD_PREP(CMDQ_0_OP, op);
+	return cmd;
+}
+
+static inline struct arm_smmu_cmd arm_smmu_make_cmd_cfgi_all(void)
+{
+	struct arm_smmu_cmd cmd = arm_smmu_make_cmd_op(CMDQ_OP_CFGI_ALL);
+
+	cmd.data[1] |= FIELD_PREP(CMDQ_CFGI_1_RANGE, 31);
+	return cmd;
+}
+
+static inline struct arm_smmu_cmd arm_smmu_make_cmd_prefetch_cfg(u32 sid)
+{
+	struct arm_smmu_cmd cmd = arm_smmu_make_cmd_op(CMDQ_OP_PREFETCH_CFG);
+
+	cmd.data[0] |= FIELD_PREP(CMDQ_PREFETCH_0_SID, sid);
+	return cmd;
+}
+
+static inline struct arm_smmu_cmd arm_smmu_make_cmd_cfgi_ste(u32 sid, bool leaf)
+{
+	struct arm_smmu_cmd cmd = arm_smmu_make_cmd_op(CMDQ_OP_CFGI_STE);
+
+	cmd.data[0] |= FIELD_PREP(CMDQ_CFGI_0_SID, sid);
+	cmd.data[1] |= FIELD_PREP(CMDQ_CFGI_1_LEAF, leaf);
+	return cmd;
+}
+
+static inline struct arm_smmu_cmd arm_smmu_make_cmd_cfgi_cd(u32 sid, u32 ssid,
+							    bool leaf)
+{
+	struct arm_smmu_cmd cmd = arm_smmu_make_cmd_op(CMDQ_OP_CFGI_CD);
+
+	cmd.data[0] |= FIELD_PREP(CMDQ_CFGI_0_SID, sid) |
+		       FIELD_PREP(CMDQ_CFGI_0_SSID, ssid);
+	cmd.data[1] |= FIELD_PREP(CMDQ_CFGI_1_LEAF, leaf);
+	return cmd;
+}
+
+static inline struct arm_smmu_cmd arm_smmu_make_cmd_resume(u32 sid, u16 stag,
+							   u8 resp)
+{
+	struct arm_smmu_cmd cmd = arm_smmu_make_cmd_op(CMDQ_OP_RESUME);
+
+	cmd.data[0] |= FIELD_PREP(CMDQ_RESUME_0_SID, sid) |
+		       FIELD_PREP(CMDQ_RESUME_0_RESP, resp);
+	cmd.data[1] |= FIELD_PREP(CMDQ_RESUME_1_STAG, stag);
+	return cmd;
+}
+
+static inline struct arm_smmu_cmd arm_smmu_make_cmd_pri_resp(u32 sid, u32 ssid,
+							     bool ssv,
+							     u16 grpid,
+							     enum pri_resp resp)
+{
+	struct arm_smmu_cmd cmd = arm_smmu_make_cmd_op(CMDQ_OP_PRI_RESP);
+
+	cmd.data[0] |= FIELD_PREP(CMDQ_0_SSV, ssv) |
+		       FIELD_PREP(CMDQ_PRI_0_SID, sid) |
+		       FIELD_PREP(CMDQ_PRI_0_SSID, ssid);
+	cmd.data[1] |= FIELD_PREP(CMDQ_PRI_1_GRPID, grpid) |
+		       FIELD_PREP(CMDQ_PRI_1_RESP, resp);
+	return cmd;
+}
+
 /* Event queue */
 #define EVTQ_ENT_SZ_SHIFT		5
 #define EVTQ_ENT_DWORDS			((1 << EVTQ_ENT_SZ_SHIFT) >> 3)
@@ -535,12 +612,6 @@ enum arm_smmu_cmdq_opcode {
 #define MSI_IOVA_BASE			0x8000000
 #define MSI_IOVA_LENGTH			0x100000
 
-enum pri_resp {
-	PRI_RESP_DENY = 0,
-	PRI_RESP_FAIL = 1,
-	PRI_RESP_SUCC = 2,
-};
-
 struct arm_smmu_cmdq_ent {
 	/* Common fields */
 	u8				opcode;
@@ -548,19 +619,6 @@ struct arm_smmu_cmdq_ent {
 
 	/* Command-specific fields */
 	union {
-		struct {
-			u32			sid;
-		} prefetch;
-
-		struct {
-			u32			sid;
-			u32			ssid;
-			union {
-				bool		leaf;
-				u8		span;
-			};
-		} cfgi;
-
 		struct {
 			u8			num;
 			u8			scale;
@@ -580,19 +638,6 @@ struct arm_smmu_cmdq_ent {
 			bool			global;
 		} atc;
 
-		struct {
-			u32			sid;
-			u32			ssid;
-			u16			grpid;
-			enum pri_resp		resp;
-		} pri;
-
-		struct {
-			u32			sid;
-			u16			stag;
-			u8			resp;
-		} resume;
-
 		struct {
 			u64			msiaddr;
 		} sync;
-- 
2.43.0

