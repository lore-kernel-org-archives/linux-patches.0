Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010071.outbound.protection.outlook.com [52.101.201.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FCC12701CF;
	Thu, 22 Jan 2026 01:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769045107; cv=fail; b=HD9bCQFd0Rpr4DGgt2v/amExAwpaK/Whrc5vJbJT4q6xVUH5cwXeqIEbVnimVINmhyZKvce9nmDtdoQ4fklqDI2887FUnpzgtyHal2hW9+wy2I3n20tyDShBmJOr4RECAwGTce0hXc5UBA5J7FOtNkc6YoTCQ8zsJQILZroJaWw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769045107; c=relaxed/simple;
	bh=LODqB+zA51+HYiYdaamppYqQnj+JB70eR6eY/lJfWKI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QAxXyL9ZEeXArH1Iq7p/xEgvsQbrfa2F26OwgkonJ37MF7kBkXRLwx29TL9Wl46Wic/djlUagimsna21In+5ybaOArzTCOGcIjRvybjk7/fD5UG2jmRO+jchiaIvkCqKJUCaKGRsYS8i1kgvbb8k+D79qFdVmz32gFgZbhkCm1A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=CpTuDegd; arc=fail smtp.client-ip=52.101.201.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="CpTuDegd"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FZJNAIcwYWuhn9Y8j1p03qNByRMDNXJ1nRStR4rM5/oM3/Nkp4vnnCM50+AI5SrNj7qrHDkREQXittTaXMymnJqZvbQerqJfj99bc8kKieJBKScSbIlD87YIt50rtDkkPVcJtTNhnj37ISYi2CWrz8BxOCUXMfamLQMOrgT+k56suaKldgPTY1N64bgJDMqwJ9g4u8e22UbSV1Brx71lC26e8u812JWtkpTHSLrmDZctkkrLViKFAJ1Y22sZNZ5sEx71aNNPYBErrsh2hn+aRFb10+jo+RTCHO3R+AFwD19o3eKmmSOFCuAocaorGKUffo2+1UnmOLs0baeP2bn3Sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=76LcEk5hX/PeJBaPHMhf0duvD5kHUCWIC9w7709Dz4I=;
 b=amTIpeTypBoZL5WpbH6IMVTaWDmz2kiO+Ciru+6qKhyh3skawI59ycP20FSyzV1ZkYurspm1tL6eCLRUGeeSLP5fJ2JcUwSJYN9i0922WxWKnXKIcqFgL9ciKhxK/kgFveF37RlAomzzHkq+BKMkpbdtduJWQwDdtwMldWCyqidCFgvxlRMMbWxyiQIPgq0/ivlVaXqenb/RyZZryfT9hXeG9qgDHl+5xRSVJY0a+uFs9dQh7OCaySIYaX/hIOEJjlhGbMd4z/26qCF/NSy8he9OKVC7zi9QeMPMjsJ2kSPk2itFfUkm9/vhsrDYH6/JOCQAMTBOMlmKvQIRntoHkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=76LcEk5hX/PeJBaPHMhf0duvD5kHUCWIC9w7709Dz4I=;
 b=CpTuDegdhwUsKIXukcPnlUoKv55JLVYhKIp4Y+xDTJlUBalRvCZ/0bpQ++AK8OxWMqZ6ggbGl0fUOQnNx+xnPjLa195/4TEWvUDLCwbJt2r+Rcb9k/2gMAf8tcyq57R3SBdvR7NHQqeAUyRgBoTUVEjx/tH2EtaKobSyKXLkpZkQvAzUtpK8nHDOCqmEu9Jp9RRRWIRm54B///vQaHPwwTtCJ8oR+viRlaiU23p/G/SqmpehxQzG9fR1/U98Bc+BmgyjfqWpsJS+5uoB62XgEKHsBS2+YMCRpfTPBvJMLGKT8Rkm6gccSLk2OH5pGQA8TaDQBjgsFpCS/w/LiBzgsw==
Received: from CH0PR03CA0085.namprd03.prod.outlook.com (2603:10b6:610:cc::30)
 by MN2PR12MB4456.namprd12.prod.outlook.com (2603:10b6:208:266::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Thu, 22 Jan
 2026 01:24:51 +0000
Received: from CH2PEPF0000014A.namprd02.prod.outlook.com
 (2603:10b6:610:cc:cafe::51) by CH0PR03CA0085.outlook.office365.com
 (2603:10b6:610:cc::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.10 via Frontend Transport; Thu,
 22 Jan 2026 01:24:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CH2PEPF0000014A.mail.protection.outlook.com (10.167.244.107) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.1 via Frontend Transport; Thu, 22 Jan 2026 01:24:51 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 21 Jan
 2026 17:24:41 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Wed, 21 Jan 2026 17:24:40 -0800
Received: from Asurada-Nvidia.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Wed, 21 Jan 2026 17:24:40 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: <will@kernel.org>, <robin.murphy@arm.com>, <jgg@nvidia.com>
CC: <joro@8bytes.org>, <jpb@kernel.org>, <praan@google.com>,
	<miko.lenczewski@arm.com>, <linux-arm-kernel@lists.infradead.org>,
	<iommu@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: [PATCH v2 04/10] iommu/arm-smmu-v3: Allocate IOTLB cache tag if no id to reuse
Date: Wed, 21 Jan 2026 17:24:22 -0800
Message-ID: <85f3361fa07ca6884500ccc917da6f6b84e13a6c.1769044718.git.nicolinc@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1769044718.git.nicolinc@nvidia.com>
References: <cover.1769044718.git.nicolinc@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF0000014A:EE_|MN2PR12MB4456:EE_
X-MS-Office365-Filtering-Correlation-Id: 86293824-1614-4077-9851-08de59550a9d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+EiLBUr+HXSx0bGn0l55Mx7KFO8gpShSnDWvvSrVdBg0Dkgg5zhcWKvU8+vY?=
 =?us-ascii?Q?JMtcf1D80/GuBG8fsgM8pb+8GkdX8CObUMb0uAtnz6JolPHzi86HrnQxcmoL?=
 =?us-ascii?Q?I4L74U5eMkfRl9IapY8AQxH1QuTWT9E+ImCn5NXCNZmFaNPmWXiaBlcuffv2?=
 =?us-ascii?Q?4SY6XnIsnOQWJY9qN8eSvmH5O4ObZIktVcTrxkoUac/qr6kzoXU14GLYovrF?=
 =?us-ascii?Q?TxHd2CUrHjWv6ge7ndAcOEQI9PEwrAMKmCl2BdOvoUvFdPKSbrLwiy7WSsOV?=
 =?us-ascii?Q?PlGBuojF2RmInWaGs4nWa6+GyPWs3u0tpgfDM4ElDM8DW9COs5uVGSJXE9aM?=
 =?us-ascii?Q?HkOhjzQiQ0TeM95TD0GDlRprPkJPfGzgzzi6zY2M6AAi7qfuJoAXYpFDhwp2?=
 =?us-ascii?Q?c6DPnu18KL7QRCJssdyJp/3GCV72ce5QXmY1TYisdi1O6Fe5QjE2SxCLBIG5?=
 =?us-ascii?Q?xfSVNxW2lFGPTg37tELw5uTtI272Gcn4b+X8ONL6IFHQuw5GLE84O5VjYqT4?=
 =?us-ascii?Q?zZswBbZMV+D40uxxFCK5xsYqHVmUQ1OBrL9q/iydFzm8Fz8P65vcovjyp1To?=
 =?us-ascii?Q?D637oaNjnsGOGCGP++UP1ILkKcAt4sjaKnr/BNpi/8LZeCHpYrGGWdrWiQ5n?=
 =?us-ascii?Q?o3DCfna+bNn6urG50WwLskU0fMz0eG6oYJ+nBS46/JHF6pSgmMGC6+lafzfn?=
 =?us-ascii?Q?pA4qdtyFlN4JrU6iIsxf551WJFLrI+rkWPPwIVn2BBPkpztzMLB8HaCrgMtE?=
 =?us-ascii?Q?uaSfOyKcW4DGSn7ha1dEO9bZtEOt/BvOpgy1y5fP1hDknNiFDAlXdpceMJ72?=
 =?us-ascii?Q?Jku6g7OFGHjubp5oe4fiWZDqzR9IYfAbImnF8USABpEbnHMDlBE+tUXRXIuB?=
 =?us-ascii?Q?om6W0HNum+DTZpJ4AioY1GhGqAXq8vUkL5y2oxbCF1VVMyRk70GMdeIY1ys5?=
 =?us-ascii?Q?sqLLycr62CphV6e19KFr6rdEBsXQGr/Aqy+fg4ZPg+EpQ3D/OzNRrR0+1pjf?=
 =?us-ascii?Q?XxklPKUDzO11RmpmEdjBfClMaqJ6eVU55snkK3D0nPxrBNEGVTQQXqvnBEZ8?=
 =?us-ascii?Q?wkkqsOZiAhtNXgf38LO3Y2UnTa4Pc27sgB0UYGi3m2IXzual6t7pNApCYQTc?=
 =?us-ascii?Q?pJcKK7n/OV8AVY/zRdFxj4lao5o0pspCz4As68a6q1K1rMF/iuSIUG2iPaO2?=
 =?us-ascii?Q?X12V1YQb/DCXL3IBSAkwfRJ4MUdvQoGerInYuzEhrqruKiRjoNAsJ3gwHw6L?=
 =?us-ascii?Q?TcsW7/5uDUfOjydUGNCPMHuSFWZeqz5QGlSaWeAwAmqx9s7GVxg5bpBXnMtT?=
 =?us-ascii?Q?aHyhkbEuUSdXQ6Ci/CoQhUFD+2e19o0bKRxY1uFJwAkbgPJfSraepyVElGK9?=
 =?us-ascii?Q?sl79oA48RyxJ2NslkAnHmEQNQi9S3Et5RnJk8r4i48aF1Ow9CzOdFapEPMIi?=
 =?us-ascii?Q?Ke8AODQl7NJ+cD71cADD4bmdH48yr5TQke8pnZgJq6AfUwnLlSOu3RHFJ628?=
 =?us-ascii?Q?oDPjdz5pgvVeUMZLttp+9ZRhE6H+NOFq1jxaHB+x4xEZRPJ+xXzwdUE21YMH?=
 =?us-ascii?Q?kt6Z/aj1a2hE8pSguXx5TGFyU11dyrPufYpsSZno1rJHy+tUAPl8iJprUy6J?=
 =?us-ascii?Q?wCvLgT7n+0NcvEuuDsnKK4pE41SsC2s/WcXPSAEWxcFUf5nhQ/189aTcc6Ir?=
 =?us-ascii?Q?LTgRkQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2026 01:24:51.6931
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 86293824-1614-4077-9851-08de59550a9d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000014A.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4456

An IOTLB tag now is forwarded from arm_smmu_domain_get_iotlb_tag() to its
final destination (a CD or STE entry).

Thus, arm_smmu_domain_get_iotlb_tag() can safely delink its references to
the cd->asid and s2_cfg->vmid in the smmu_domain. Instead, allocate a new
IOTLB cache tag from the xarray/ida.

The old asid and vmid in the smmu_domain will be deprecated, once VMID is
decoupled from the vSMMU use case.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 38 ++++++++++++++++++---
 1 file changed, 33 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 1927eb794db9..d10593823353 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1210,6 +1210,8 @@ void arm_smmu_invs_unref(struct arm_smmu_invs *invs,
 			/* KUNIT test doesn't pass in a free_fn */
 			if (free_fn)
 				free_fn(&invs->inv[i]);
+			/* Notify the caller to free the iotlb tag */
+			refcount_set(&to_unref->inv[j].users, 0);
 			invs->num_trashes++;
 		} else {
 			/* item in to_unref is not in invs or already a trash */
@@ -3165,12 +3167,31 @@ int arm_smmu_domain_get_iotlb_tag(struct arm_smmu_domain *smmu_domain,
 	if (!ret || !alloc)
 		return ret;
 
-	if (tag->type == INV_TYPE_S1_ASID)
-		tag->id = smmu_domain->cd.asid;
-	else
-		tag->id = smmu_domain->s2_cfg.vmid;
+	/* Allocate a new IOTLB cache tag (users counter == 0) */
+	lockdep_assert_held(&arm_smmu_asid_lock);
 
-	return 0;
+	if (tag->type == INV_TYPE_S1_ASID) {
+		ret = xa_alloc(&arm_smmu_asid_xa, &tag->id, smmu_domain,
+			       XA_LIMIT(1, (1 << smmu->asid_bits) - 1),
+			       GFP_KERNEL);
+	} else {
+		ret = ida_alloc_range(&smmu->vmid_map, 1,
+				      (1 << smmu->vmid_bits) - 1, GFP_KERNEL);
+		if (ret > 0) {
+			tag->id = ret; /* int is good for 16-bit VMID */
+			ret = 0;
+		}
+	}
+
+	return ret;
+}
+
+static void arm_smmu_iotlb_tag_free(struct arm_smmu_inv *tag)
+{
+	if (tag->type == INV_TYPE_S1_ASID)
+		xa_erase(&arm_smmu_asid_xa, tag->id);
+	else if (tag->type == INV_TYPE_S2_VMID)
+		ida_free(&tag->smmu->vmid_map, tag->id);
 }
 
 static struct arm_smmu_inv *
@@ -3220,6 +3241,9 @@ arm_smmu_master_build_inv(struct arm_smmu_master *master,
 		break;
 	}
 
+	/* Set a default users counter */
+	refcount_set(&cur->users, 1);
+
 	return cur;
 }
 
@@ -3453,6 +3477,8 @@ arm_smmu_install_old_domain_invs(struct arm_smmu_attach_state *state)
 
 	arm_smmu_invs_unref(old_invs, invst->new_invs,
 			    arm_smmu_inv_flush_iotlb_tag);
+	if (!refcount_read(&invst->new_invs->inv[0].users))
+		arm_smmu_iotlb_tag_free(&invst->tag);
 
 	new_invs = arm_smmu_invs_purge(old_invs);
 	if (!new_invs)
@@ -3615,6 +3641,8 @@ int arm_smmu_attach_prepare(struct arm_smmu_attach_state *state,
 err_free_vmaster:
 	kfree(state->vmaster);
 err_unprepare_invs:
+	if (!refcount_read(&state->new_domain_invst.tag.users))
+		arm_smmu_iotlb_tag_free(&state->new_domain_invst.tag);
 	kfree(state->new_domain_invst.new_invs);
 	return ret;
 }
-- 
2.43.0

