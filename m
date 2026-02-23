Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010052.outbound.protection.outlook.com [52.101.85.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58DD9347FEE;
	Mon, 23 Feb 2026 20:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771878527; cv=fail; b=k2RRbfTY4msW/iWJATJZRQsyS6pCLzfN7jaZICcN2+3z9aeW0lxdea9NQOYDjEO4JooL58ycv7MrSj0cSbHvN0yWnYpDRIibCJLPJYOPB+/koGftgXSx/wXmgcDUNPoKYJNDCvPdRUAUy+Gdjl4P5Z7RRD7rormn+M8R1fS4FqE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771878527; c=relaxed/simple;
	bh=qZ6dKkYQKzuF0hR98z8vGVX1y6sBlU9fGvjYcTlRkKs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q3nBSQJlE4n+xIwrlOx4AixhtF4EdKAU5bxZZEk14I+HslVdSrZewV/MVJoYtzX9SjaFkeiTZMOZUiJ+YgVWsIlUpbNTRbEFpj9OE780GJBAkQD/PyD/pffnbdjklzX21tPIZH3H3Nfp6x05rERn0TNbka1SKugTUiIjYUoh9nc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=aiJJ/I+p; arc=fail smtp.client-ip=52.101.85.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="aiJJ/I+p"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Vv/b5ifFXDHNoKtBzgzhXItBU/F8sHZwZSdy5hBFRfeuSAzOPh99bkALFO/9GspEfUg/Yh9SKf26OTwYMm2zzLpQHCh6fsgfHrw0b834OxBLaUWaP3l9wxDLQLMkKlU1gIC1ZCAZ4HWWKFCODF/3noRMn2foJPWqcFggpzagOHNkm5NYO//ZI0ymxZDZCZwZbCIr+zhsn+1HHrzconJde6Wd42wXj+0F/HGeYzyj2L+f+YpXt/tKdKKgDji03X5itnvzgPdiZ4F6hyRDSoNOXpq6hvY7b1QQXs8UukdHcKTiOP3iMBuRVJvjpeSZ2n1HZAePanRchHRN39MSgrWdlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CLAzCXkhY+Q5ktImf79hRaOyShWufqhHPzUZs8jz9qM=;
 b=q8/7I1vIeyTcgyJR8ll16y2y0SuysWFm6+EGSjOdwwOaW1I/YYcNIwXg4B0aYR9lo++a3ZAGvyNH9ISrCYkzE4ePaKzVlCNvO8xvQU02ptEbL0WrhqkWkHjx/GwJYaZVRsyJOec6EtIfI/yMzzOAAfhay4i/tlOVRzF1q8HmhGYAa4tAJ5oKHf8CDVc6KRXS9tWxjI8zCh2g1tRREa/ByziYCg1DcOjVaUETMxKApzPra6ULJXMClsG6lliZaRqnzZi6WBERS8PLC0G04tQ6ohXHwLlzUS/83Zho7UOVuBf2TQZgSBa73ZBNI7N4AOCx7s/DLeaGBdKDwifPVbw5jA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CLAzCXkhY+Q5ktImf79hRaOyShWufqhHPzUZs8jz9qM=;
 b=aiJJ/I+pZ5AU3Ej1wjCzkldPONWb5O0AfTIWZN1uoSYRUWUtnc9MimVKbEbnNcgAwnAkLx/pz8rBWSn2SNVWIjMPM+hB5TKPvAlD6ZRTm7gCXzXADjGVEuA99CqIsmirld93rv2Vx9NRcGyq4m/5YP5cBZvjRjng/aVJhPaalI6zUTqgEWSfTPt1TUvzzAXYeVA9KCge4b34RUvDteX8wo33oDiqxuTEf6mbLSlIxfMJmR52asm5ICCdYFfx5natfyu85tYtMZgO7JIiw99h6wf3qm8AAkk81yoigg1/ylaTkfzN8Wa6J3dQz8Vn/Ym6qzeJgrUEgINNPstOHk24RQ==
Received: from MW4P220CA0013.NAMP220.PROD.OUTLOOK.COM (2603:10b6:303:115::18)
 by IA1PR12MB7664.namprd12.prod.outlook.com (2603:10b6:208:423::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Mon, 23 Feb
 2026 20:28:41 +0000
Received: from CO1PEPF00012E66.namprd05.prod.outlook.com
 (2603:10b6:303:115:cafe::2f) by MW4P220CA0013.outlook.office365.com
 (2603:10b6:303:115::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.21 via Frontend Transport; Mon,
 23 Feb 2026 20:28:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1PEPF00012E66.mail.protection.outlook.com (10.167.249.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Mon, 23 Feb 2026 20:28:41 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 23 Feb
 2026 12:28:23 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 23 Feb
 2026 12:28:22 -0800
Received: from Asurada-Nvidia.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Mon, 23 Feb 2026 12:28:21 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: <will@kernel.org>, <robin.murphy@arm.com>, <jgg@nvidia.com>
CC: <joro@8bytes.org>, <jpb@kernel.org>, <praan@google.com>,
	<miko.lenczewski@arm.com>, <smostafa@google.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: [PATCH v3 03/10] iommu/arm-smmu-v3: Store IOTLB cache tags in struct arm_smmu_attach_state
Date: Mon, 23 Feb 2026 12:27:39 -0800
Message-ID: <5e86736d015c29790cae2f31ae41b1f317dbb72d.1771877893.git.nicolinc@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1771877893.git.nicolinc@nvidia.com>
References: <cover.1771877893.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF00012E66:EE_|IA1PR12MB7664:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d7f4940-d05b-4a7d-a461-08de731a222c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|36860700013|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Uipt6kaBnHP1fWZE4sNINkYICCBtcld1vhvLkwY8h+Ag9eoKwU+UEgD/gBbG?=
 =?us-ascii?Q?FUz+JnS6KMog8vTgnco8rVDS3uxJOO3TheSCezdE/WLtrJfeRHKTpvqcfi1Q?=
 =?us-ascii?Q?fN95Ps7PYQTmZp7V0dyXmzHySm1onY+kRwz7jF6F0gjfMVCXAMbJrxs5saXE?=
 =?us-ascii?Q?8RCehzkdRo3S84UzkSGGaWyMS+/OW0h57+KRk27W29Jtt3cVjcWUgv1XEdZ9?=
 =?us-ascii?Q?ti6xmQSzbRlFsYWChebgzBTl3eUXUqEVZ3+Ot3sCONyLabFcJG/AaUye5fRp?=
 =?us-ascii?Q?O+sdJjxaiQ8J1I7gnbGNvWz+PwaiaqZ16E+U31CbredbMQuo8Tnou6vK1zus?=
 =?us-ascii?Q?Xaa6PsFRey7uaKtVInfGA1LLzjpLh/OY4zeyRXrPgxf5+Jy72F8FkG3uScUD?=
 =?us-ascii?Q?QFqxAdwYpVEQFqLFcReLH6woDVQD36Y0sCIK4xHdAWNWTlwXmZjy6TzILd8K?=
 =?us-ascii?Q?xBiVHwSKoKEeK9DzpYCvdEb8bWVltKPrkYbgMr0qnzg5pGnt5V6QjTTJXNTJ?=
 =?us-ascii?Q?E65Pv5u9jCt7EpcbZJ22RgY2bgtGdY1g1S2vys8JrwkDVG9hvO/3G01vxw+W?=
 =?us-ascii?Q?RqqO+5zRXQWAmNezSD7UDH3UNBjNlpIeJreozukUHqTBSab4aWDJIbSjH57t?=
 =?us-ascii?Q?+3jSn4mJIsE1ncOWWKcgCFOe5DYaF2RVzK0hyKJvc7Gr8gH7RRXfUHKHH+fJ?=
 =?us-ascii?Q?Wzmo1OQVL3lSQP4BbxG3VmHlVbvDkO4QrHxTIsn/1Nsi+uvzH7lYdnkQ0yRY?=
 =?us-ascii?Q?OjrOCx7z6UxnwBUsYVfQTCyi+uUVmy3dqonURqWUvDZ4ly/0yhpC2bpY/VWP?=
 =?us-ascii?Q?eGLAyA9vBOg4lg6i+qOtsNoOADKG3WlUPAcXhnj85m5qlQBK+ZQbzw0PH90F?=
 =?us-ascii?Q?ilXqLP+UiXzFPEfWsUFvF4jLguyWqbtV7sXh7PJLLRzSl8VPHirHEFsj+jKm?=
 =?us-ascii?Q?jqo9C12QmCWaUcROO3dE2MT1zXBqTgkCAUXybtY6HZblwWqeXHeCL4FsVCjY?=
 =?us-ascii?Q?OYP4izbcZMBGI1iFY0tYDWfjM8f8f9fzYvXoZ4c6UFaIUUTNqEYzajNaNEd+?=
 =?us-ascii?Q?QV7bT8dDGBaudVu6xrnrAnKaBUcjjCwNlN1PKL44T7/rzrcFd2XNMTf0Jp2n?=
 =?us-ascii?Q?lvZNTeYUHKGaZFqdi42eaXbpPM6W3lE4PH9bHTt4f5T1Zp5bMTTLtpq6Pa6p?=
 =?us-ascii?Q?f3wmh/lsJOj1UDpWAtCC0mqxBYqbdQhNCQwZdTQ3RF8kQemIdhCy5XXPzQil?=
 =?us-ascii?Q?oYj3RqY34ByVraX6WyTkiT+fFyVAM7kvW251tizLuEmdvzrEiSUxcu496V7v?=
 =?us-ascii?Q?a300N8wObBJHT/85EnTs1DpplxgaB4BIvUt3rvbUwAng+8lybMYgXMPUwvwu?=
 =?us-ascii?Q?TrQZiL+3o5+Yj4rT/kDuC6+4qQB15tDpxnK3oXEyKYRUaxVYY601fD+xDnne?=
 =?us-ascii?Q?VR0O4+fS0GgIeqWdSEtThZg22ibzTV3yVu0Mdt6VjirXEmtuEw0fmXNzmPlV?=
 =?us-ascii?Q?FiEOTsSL6oZonEyuC21Ip2O9NeVWn8ckgpIpoGWJFhkQrBfb3J7aUEIhsFA9?=
 =?us-ascii?Q?gE0jq4rceqz9wsDwYuFV//2r+zPmpMhyQq6Ybt4GHC/vv/JHOQ0VR6pxsUiW?=
 =?us-ascii?Q?b68ZY9O4VUsXGjEv1CWBcmNE9qvtzQn0GzNRuf66+LnEyjGXeZwcaSx9psBi?=
 =?us-ascii?Q?SOPrOA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(36860700013)(376014)(82310400026);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	trwsR8oBVr/iPOf6cXPbAhcw0IrpDA5/0u45pSynbO7kpPXPpPllTNPyVigTXhbtRrVpgKpN437gt/u7QUQMnhcm6GTqAKhfXxEOy4NMVW1Coz+7+P4gDyoHo+7AqePLsuVyX+qOS1+bEDsXFuY5bpkL2K4e+lPDUK2NcSW3spP6AV9QFFOfgj+blfzLktB97sjvsD4Vu82jQa+tdLfbJ1+ATgMxxGSGq0mp2KiZwAigjaD0hT/42mXDpmyExGdzfmLfKOOSnD9afs/8Hx0tEoe/nzoVeL0jsU6Cafg/bdPIcwTL22754C9v4b3dPt3y9HtNq6sJhzFuCw6vbk13DPG2tRqgPB2iwtrme1HffZkf5yERbvVKneDUOefAZQtS1POiGnNH27noYsaoNqq5lDNXdWd5Tmru19CeX5uaX7kamVyO+a9gY5VxsbWmYIMU
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2026 20:28:41.2387
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d7f4940-d05b-4a7d-a461-08de731a222c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF00012E66.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7664

So far, an IOTLB tag (ASID or VMID) has been stored in the arm_smmu_domain
structure. Its lifecycle is aligned with the smmu_domain.

However, an IOTLB tag (ASID or VMID) will not be used:
1) Before being installed to CD or STE during a device attachment
2) After being removed from CD or STE during a device detachment

Both (1) and (2) exactly align with the lifecycle of smmu_domain->invs.

The bigger problem is that storing the IOTLB tag in struct arm_smmu_domain
makes it difficult to share across SMMU instances, a common use case for a
nesting parent domain.

Introduce arm_smmu_find_iotlb_tag() helper to find an existing IOTLB cache
tag in the smmu_domain->invs array.

Introduce arm_smmu_alloc_iotlb_tag() helper provisionally copying an IOTLB
tag from the smmu_domain (cd->asid and s2_cfg), which will be replaced to
actually allocate a new IOTLB cache tag from the ASID or VMID bitmap.

(Note only the new_smmu_domain pathway is allowed to allocate a new tag.)

The returned tag will be stored in struct arm_smmu_attach_state, which will
be forwarded to arm_smmu_master_build_invs() and eventually set to a CD or
STE accordingly.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h | 11 +++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 84 +++++++++++++++++++++
 2 files changed, 95 insertions(+)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index e3a66e6bc303e..11b61a19e6e53 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -674,6 +674,11 @@ struct arm_smmu_inv {
 	int users; /* users=0 to mark as a trash to be purged */
 };
 
+static inline void arm_smmu_inv_assert_iotlb_tag(struct arm_smmu_inv *inv)
+{
+	WARN_ON(inv->type != INV_TYPE_S1_ASID && inv->type != INV_TYPE_S2_VMID);
+}
+
 static inline bool arm_smmu_inv_is_ats(const struct arm_smmu_inv *inv)
 {
 	return inv->type == INV_TYPE_ATS || inv->type == INV_TYPE_ATS_FULL;
@@ -1117,11 +1122,13 @@ static inline bool arm_smmu_master_canwbs(struct arm_smmu_master *master)
  * @new_invs: for new domain, this is the new invs array to update domain->invs;
  *            for old domain, this is the master->build_invs to pass in as the
  *            to_unref argument to an arm_smmu_invs_unref() call
+ * @tag: IOTLB cache tag (INV_TYPE_S1_ASID or INV_TYPE_S2_VMID)
  */
 struct arm_smmu_inv_state {
 	struct arm_smmu_invs __rcu **invs_ptr;
 	struct arm_smmu_invs *old_invs;
 	struct arm_smmu_invs *new_invs;
+	struct arm_smmu_inv tag;
 };
 
 struct arm_smmu_attach_state {
@@ -1138,6 +1145,10 @@ struct arm_smmu_attach_state {
 	bool ats_enabled;
 };
 
+int arm_smmu_find_iotlb_tag(struct iommu_domain *domain,
+			    struct arm_smmu_device *smmu,
+			    struct arm_smmu_inv *tag);
+
 int arm_smmu_attach_prepare(struct arm_smmu_attach_state *state,
 			    struct iommu_domain *new_domain);
 void arm_smmu_attach_commit(struct arm_smmu_attach_state *state);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 7c075e64f842e..2033468dbf1e8 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -3200,6 +3200,77 @@ static void arm_smmu_disable_iopf(struct arm_smmu_master *master,
 		iopf_queue_remove_device(master->smmu->evtq.iopf, master->dev);
 }
 
+static int __arm_smmu_domain_find_iotlb_tag(struct arm_smmu_domain *smmu_domain,
+					    struct arm_smmu_inv *tag)
+{
+	struct arm_smmu_invs *invs = rcu_dereference_protected(
+		smmu_domain->invs, lockdep_is_held(&arm_smmu_asid_lock));
+	size_t i;
+
+	arm_smmu_inv_assert_iotlb_tag(tag);
+
+	for (i = 0; i != invs->num_invs; i++) {
+		if (invs->inv[i].type == tag->type &&
+		    invs->inv[i].smmu == tag->smmu &&
+		    READ_ONCE(invs->inv[i].users)) {
+			*tag = invs->inv[i];
+			return 0;
+		}
+	}
+
+	return -ENOENT;
+}
+
+/* Find an existing IOTLB cache tag in smmu_domain->invs (users counter != 0) */
+int arm_smmu_find_iotlb_tag(struct iommu_domain *domain,
+			    struct arm_smmu_device *smmu,
+			    struct arm_smmu_inv *tag)
+{
+	struct arm_smmu_domain *smmu_domain = to_smmu_domain_devices(domain);
+
+	if (WARN_ON(!smmu_domain))
+		return -EINVAL;
+
+	/* Decide the type of the iotlb cache tag */
+	switch (smmu_domain->stage) {
+	case ARM_SMMU_DOMAIN_SVA:
+	case ARM_SMMU_DOMAIN_S1:
+		tag->type = INV_TYPE_S1_ASID;
+		break;
+	case ARM_SMMU_DOMAIN_S2:
+		tag->type = INV_TYPE_S2_VMID;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	tag->smmu = smmu;
+
+	return __arm_smmu_domain_find_iotlb_tag(smmu_domain, tag);
+}
+
+/* Allocate a new IOTLB cache tag (users counter == 0) */
+static int arm_smmu_alloc_iotlb_tag(struct iommu_domain *domain,
+				    struct arm_smmu_device *smmu,
+				    struct arm_smmu_inv *tag)
+{
+	struct arm_smmu_domain *smmu_domain = to_smmu_domain_devices(domain);
+	int ret;
+
+	/* Only allocate if there is no IOTLB cache tag to re-use */
+	ret = arm_smmu_find_iotlb_tag(domain, smmu, tag);
+	if (!ret || ret != -ENOENT)
+		return ret;
+
+	/* FIXME replace with an actual allocation from the bitmap */
+	if (tag->type == INV_TYPE_S1_ASID)
+		tag->id = smmu_domain->cd.asid;
+	else
+		tag->id = smmu_domain->s2_cfg.vmid;
+
+	return 0;
+}
+
 static struct arm_smmu_inv *
 arm_smmu_master_build_inv(struct arm_smmu_master *master,
 			  enum arm_smmu_inv_type type, u32 id, ioasid_t ssid,
@@ -3365,7 +3436,9 @@ static int arm_smmu_attach_prepare_invs(struct arm_smmu_attach_state *state,
 	struct arm_smmu_domain *new_smmu_domain =
 		to_smmu_domain_devices(new_domain);
 	struct arm_smmu_master *master = state->master;
+	struct arm_smmu_device *smmu = master->smmu;
 	ioasid_t ssid = state->ssid;
+	int ret;
 
 	/*
 	 * At this point a NULL domain indicates the domain doesn't use the
@@ -3379,6 +3452,11 @@ static int arm_smmu_attach_prepare_invs(struct arm_smmu_attach_state *state,
 		invst->old_invs = rcu_dereference_protected(
 			new_smmu_domain->invs,
 			lockdep_is_held(&arm_smmu_asid_lock));
+
+		ret = arm_smmu_alloc_iotlb_tag(new_domain, smmu, &invst->tag);
+		if (ret)
+			return ret;
+
 		build_invs = arm_smmu_master_build_invs(
 			master, state->ats_enabled, ssid, new_smmu_domain);
 		if (!build_invs)
@@ -3401,6 +3479,12 @@ static int arm_smmu_attach_prepare_invs(struct arm_smmu_attach_state *state,
 			invst->old_invs = rcu_dereference_protected(
 				old_smmu_domain->invs,
 				lockdep_is_held(&arm_smmu_asid_lock));
+
+		ret = arm_smmu_find_iotlb_tag(state->old_domain, smmu,
+					      &invst->tag);
+		if (WARN_ON(ret))
+			return ret;
+
 		/* For old_smmu_domain, new_invs points to master->build_invs */
 		invst->new_invs = arm_smmu_master_build_invs(
 			master, master->ats_enabled, ssid, old_smmu_domain);
-- 
2.43.0

