Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2060.outbound.protection.outlook.com [40.107.220.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F5511353EF;
	Tue, 20 Feb 2024 18:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708454640; cv=fail; b=kJSbAsdlPBqCjU7/2ckXJcVPpPSKPiBzntJqJfPSzijHbUC7xWfaYY+2KiF1Tks2wVEF6qfnavBZk5W7LDOzM90rl0dsMF1RFTuZVTZyJzFHGWbPKFtJISqA8YKf1GeRASk4W60lw+/zmvom32GRYflp4aOY/gDqaxBnEWQDEYM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708454640; c=relaxed/simple;
	bh=p4YLg0csI1YuFjsZrsO9su91fOOV/bcpszO7kYBccec=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=NN74OcnF508ekLEYQgsosWxavW05tCeUzuRIAdVsxPBQWBddp5ykwHbQES/qr3JJzxK8BGFL6ywRhRRshWm4Fj9M53VehLZ+udNWdSJIudz70Jb8m9qp3BXY+bJb1wNzmhsxOQkvdrePtGQRBipYHrB3t5OacCBthxkn6qQeZDk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=eAZmP+i7; arc=fail smtp.client-ip=40.107.220.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="eAZmP+i7"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FNMSg8F9gFeJLwWHj1pM1MdMQi3KjCsovpCRPophqNIAtVpHt6cxAgLQR3q9NqhcvyQv5M8u6iIHEKyfPGklxIDbDGPnx2uqOfzpNkGLlfagVd3gkdKhmoJG/WI2m7ZbRsQXcqXbDapvfX4/wVmA/utuMEc1XGuam+84Gvg+vdiTuMVi0DZtWaQF+YuzV3hUo8VEXipf/XnoOc22fm3YQE483KD/Y41OR0t+HkH2boRHD6T3fYrxp6XXu08J4X8cf+zUqtk4+NS5FRvud1WQhbid30EOMi0g9PWuZbaDB7CtO/R6lqZWg2T5sF4naXXKKpmg98mKhvvn/ub6jbp7Xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SkMuNZjarKzlZ/+T+dXg/hjw1c2gqCjTtrIR5z72i+Y=;
 b=ee+ed3g6meLlSpHbVoJM84quDLzGVfvYMhZJQ/dAfsNPR1dF9oMsxOB7IKNevf5tovIIaT6oykR+9GlnLfKniUixB1BhjTh1aARV1gm6V3R9TqjjQgPhMarKGZUccQMBPb8DS/AXU0nEhGIbLQ6uSJoRREWmjMPwB2s3Du9HHL90JM1WNSMPClE6ws5OifRrEfkpqyM/qokQCxpr2xNl5QjvNAEm5+TZcFSytlnLveSLQ0fusreJEjDR8osqWjm9VTkPFz7HOTHYedCUTV52yRsPejut+U60EFg3BE9B9SkDcX9Jjg5BiFqh11kG9yFk6Ru9RuCjUKXQQmn1jDmGUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SkMuNZjarKzlZ/+T+dXg/hjw1c2gqCjTtrIR5z72i+Y=;
 b=eAZmP+i7DCX1eOptYRLF7B/Bw16Wg2tisoxsLQz2dtfkPq5TvdObJUDVVeLn9xVZNAttd/5Tr5Hj094iXA+oDtY8V/GhDljEa+WBX4UXzbYT+QNd91o2wFLT+Oy1ZDW2aRKjDwdPzCejRRzjRdWiEIi9gCQ1J6Zyt/7VmTTlAeiQcM8pOCB7WJNUznZl5pz75tuMuiG9/7i3441i/c8q6x521haL1GT0n1DJaJXYm9/ouLSL0lVfmgDcMr8d0tAfABqiYW01Qk8jankGf+LGVypWkVq2/spn8p2cqMc0bVun/fMuecbNKUBmfTw0suZjkEMgNzT+fJsJdhyPF2Efcg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB6980.namprd12.prod.outlook.com (2603:10b6:510:1ba::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.17; Tue, 20 Feb
 2024 18:43:55 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7316.018; Tue, 20 Feb 2024
 18:43:55 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev
Cc: Kevin Tian <kevin.tian@intel.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Yi Liu <yi.l.liu@intel.com>
Subject: [PATCH] iommufd: Reject non-zero data_type if no data_len is provided
Date: Tue, 20 Feb 2024 14:43:54 -0400
Message-ID: <0-v1-9b1ea6869554+110c60-iommufd_ck_data_type_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR08CA0021.namprd08.prod.outlook.com
 (2603:10b6:208:239::26) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB6980:EE_
X-MS-Office365-Filtering-Correlation-Id: 64b0ad59-41ee-4bc5-b289-08dc3243e43b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	IdqAuo0NzqFcsTWIbg22eReqmT1hE5EtikAXQNfNeA1VhqzC9Z309z1pHTPxMntDSvPtd8h1hbkrQx5nNMxVPaNMA5dlsW2vS2b4C7WOoz8oYuSS28GRWy2/dXE6pc7MsdOpWdqF57EbDEKv44Nq3asmJL+FnCdlLr3VckbH7Z1s4r025UeWilphVzstnNbdgGvbGbNwdIY+RyxaUebWqJTaD3W7PNbVaxkJeImJpPJ4kNkHZh2OuqH9h9PgkE7UQt27hX36sQE7nzbVLJf9FqfktP+wqURkFY0NgJCT07zJF6jkx/0VBZRswHawOPvX8XkLmS+ZxQAo+1N3++IgeTZJ07lcMfB1eIOebRh4gUET0AJ0o4LZqSpMN+o50h5ZHck69pCgIZl2asJAoH9pky8MW0GmZk7jbIK04fa6+B4g1i3+hxbc87id6XWjwEbLf0pekh0T//vq+U4zHY064DC3Z1FdubCrFsdtVJBFrUeWh1Te0DCJIy5ReJgs8VxxZHvRoay6i6PBw0ssm6Xrwt23l2OVC/cAx/cFr5WAcvU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/1nDcyCKMJg5coP3DRYWZWo/DaCI2W1bcytxJ4BBEMk0Sgte14oAMI3Ly/gj?=
 =?us-ascii?Q?PcNPTEH9DtExT84OLv4WJSTxma+dBBunyVXGEpHrUG9Z1gwjKF9A8+MANsvx?=
 =?us-ascii?Q?NP8XXy65ONHBpcQPvL+3384XXxMcQgnvlbHjbqexL89nTeucsI71RoCQlDnT?=
 =?us-ascii?Q?/am4PCYHNd+smBAazgY8xwHwsFkk13lT4P4/Dw/EdeE+Ls1USqD3TRwag3eu?=
 =?us-ascii?Q?s845m1yjRc6lPLMMZqPi0Q1LqzXiNtgZPEPcc/MaAW2IAywPb1fRvxqeShkS?=
 =?us-ascii?Q?+iiVxmoqZZEVJ+bam8uR8qT49AV4tAaEKlYRBzV3loZsX0fH3wB4S6KhA61m?=
 =?us-ascii?Q?Wfpd+prM3TV3PKLUB5tWD7wDKk4VgKA58C0Bn6cztL0YwBVCqRxUqvym/gAL?=
 =?us-ascii?Q?NzlqrvJ3FyMXIQ/ivxEKNx1E1gJ6VOjICaWWXuB4/ov70UuK9Q5XG2n98aQb?=
 =?us-ascii?Q?zI3IpxUWBCr52+z0e0pOlaQASaVh+6FqMdjuHfLjrOAmH/LfSkpNimBKgdRg?=
 =?us-ascii?Q?Gc8kiXvXWm3WWP0ufgihugWe5JJJ7nfv4+oYoAJgO6wTbhzBN2z9KG45P+u6?=
 =?us-ascii?Q?UBIUCCi0DOZSc06MUIl1SUFpY3G/dtLgFvSvQK/6AsmvM+scIbsX5539Qypo?=
 =?us-ascii?Q?frrzMKuL4KvySZQN+rZtGIHFHC4iMObzMtHHDQ4K4JnKe3Bkqa6P/IsN9AMZ?=
 =?us-ascii?Q?wXosEphgD8KfV9ZOaqWz9sbAlYpH/xFBfYrCamb/YaLQDkPzb1UR787Id0hx?=
 =?us-ascii?Q?b00QXCZ9nuNWozZMNWVXKd2vzyb0PUoh/QrDuuqsl5mgXN9mHGnq5eNeuY2U?=
 =?us-ascii?Q?mt2l1kQ4DzAXqKt4fdgIXSI6GeMlukIV6GTct+YtQWQR9xG08hxLNfDJAMh7?=
 =?us-ascii?Q?Ibz1lm+iWpk8W0HcNfqR/4eeDnWE6lG9YcH1PNb6OYl3wjVqA/lxVNRcugOg?=
 =?us-ascii?Q?URd2bEOJGyVzgeHH0MHnzdL9cKP3eA8Jl4TXeM1NVV3Y2GeWyrSnZYJOBvD3?=
 =?us-ascii?Q?mzAcFYZxJUV63afuDfFsPqvsYHxI6R02uuLcLKfFAqY2JOKUNhdt6SSJk9PA?=
 =?us-ascii?Q?t80YIHkJ23BcmTIm9s/NYW4H0XWCNci9fxa9NS1EAq7SuyaMNHEv9QtYgN4d?=
 =?us-ascii?Q?yfLBvtqXVkWTVnfo4/9f/W3qzrTylRpczNMHwypnH+GizQ1S2PkRamw+GMkJ?=
 =?us-ascii?Q?X3grmwXxfABsZBZ9CP0+yLVyuLr8z3FU1agEsZi5J9NR65IUwWA/JrWmNgcz?=
 =?us-ascii?Q?flj7ws4lruf9KmzfEN6206Vib+5ByPpqeV5pHVrb7KwIDfgQHnLHRRHX8dU5?=
 =?us-ascii?Q?0SpkO8elyvvftSHgGLJcBCAf6wroTNXFJ/WquslGLitDJAlxUKzeGYQT97+n?=
 =?us-ascii?Q?soNt5vmTNOMZIaYkUwkVAngllMgHqOoDw5mGxN7afCzM/U9KB/SBw9Rsja+1?=
 =?us-ascii?Q?EX2pVpDeHx6vbBgci4C2chJNBaCBxFVBHSDzM+p6fOTXmREYEV+8tRnfSV+3?=
 =?us-ascii?Q?IoJqcC5GhNXlnoB68+G7X6TnTEWCZwOIEs8HdO4If8kZMpgDxbV2C3tqmg7h?=
 =?us-ascii?Q?h0uuDzq16HsoAR9fDMhl2vEXF58ibDGPd0/fU9BK?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64b0ad59-41ee-4bc5-b289-08dc3243e43b
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2024 18:43:55.4197
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BbCwZUiMPgUCWtIZUqNmI0/mjX+eLEDBzRKz/NxNdRG58vMK98G6ZooJnC8KWLcb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6980

Since the current design doesn't forward the data_type to the driver to
check unless there is a data_len/uptr for a driver specific struct we
should check and ensure that data_type is 0 if data_len is 0. Otherwise
any value is permitted.

Fixes: bd529dbb661d ("iommufd: Add a nested HW pagetable object")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommufd/hw_pagetable.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/iommufd/hw_pagetable.c b/drivers/iommu/iommufd/hw_pagetable.c
index 3f3f1fa1a0a946..33d142f8057d70 100644
--- a/drivers/iommu/iommufd/hw_pagetable.c
+++ b/drivers/iommu/iommufd/hw_pagetable.c
@@ -263,7 +263,8 @@ int iommufd_hwpt_alloc(struct iommufd_ucmd *ucmd)
 
 	if (cmd->__reserved)
 		return -EOPNOTSUPP;
-	if (cmd->data_type == IOMMU_HWPT_DATA_NONE && cmd->data_len)
+	if ((cmd->data_type == IOMMU_HWPT_DATA_NONE && cmd->data_len) ||
+	    (cmd->data_type != IOMMU_HWPT_DATA_NONE && !cmd->data_len))
 		return -EINVAL;
 
 	idev = iommufd_get_device(ucmd, cmd->dev_id);

base-commit: 4bbcbc6ea2fa379632a24c14cfb47aa603816ac6
-- 
2.43.2

