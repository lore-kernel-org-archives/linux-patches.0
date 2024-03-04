Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE36C7D3EF;
	Mon,  4 Mar 2024 23:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709595881; cv=fail; b=cztaddn3U9juPAmkJ78IGf1uM17ldQNZPTEoqBv7jOSKMFHxq95BCbfdcXJf8KMHxuWJ5XNXHi3DH2Y/3MAHHmvamllqRfW1XgxzHDU9xQkdB1cDJnOgjMGcGnM+iiITOXFc+hUMIxX49uxDblJbjFRz3s43apCS0yGLdwEAhOA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709595881; c=relaxed/simple;
	bh=Hny2CXBR7g6VK0HgrJ5nTZMEHN5M0mqeQt8uETsKtMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=I0VsTJO4qESPASwcevbDhK9TL8GZNJ/hWf9scSDO6mrobxEZZAVGdhwOuhEWyyZ+XojvICXs9ItkKVXkn+zWN/UdDkpeZcwRR5rsFbwhYDf1oKbcIgIBV2ma+RpLLlEAhnYtYFcHn8PmN7Lpl/z3aWtsWJyi5b/HrOfdrklWdGw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=pa3dQZap; arc=fail smtp.client-ip=40.107.236.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="pa3dQZap"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j5B1oroU1+uLieJeinz2DlRnl2iCmfFHTzf9tiU019/lP+91f7WeTlD/74YCysh97tsqtg05VIdw8XqPDcn1Z5jpVqR2dwNjHMsxPTPGXK4JroFtN18eZCIeMlGWq27/PYsmqH/ypXHiOQDRG6M4OEkqF23ikCmk/ue+vPFNqnjlVfyZoZ3/deKJxHulAJh6hKj96fIiiHT0ftUDdCw7SIBs066FdFXAL/1NpilBtRDahV+M9tiuCWRvNSX3dwE9JIhneHbqc7NJJISDxuHi32taTw9Q+tPdvkCGv92dBKbzhLktFTDb9TqPU4k2i8kakLfp/JHzB3VdfAmEg+U0yQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GRhebuhH6sDysQYvUoH8P0ktIlUk8YaWvWcOJzaIgMo=;
 b=SrLA64vnpcVbQJRw9qL4gjlwk8T7ZbTZzZv4b2/CrZ4Tf0inHsoHuWBPyV9I0D3/EFt+Y6zavy4+XqmeWc3jmmPtpSkKsOIFdsg1KRpC7zHaruQyW6VPqJnU5YTlTYRFZagJZOVRAFrmwkQvH6/p/gvQS6cfGMBhhPCJmI7WVtYbFpKWxWkeS2ZMeRlDnJQTecvrgmtdpMuvsp9mMTX/hgwvNaTNorp1UKwQgOxCOkMakGlMWelxDDElfW9wcv5R7OypRZ3f5e4CXQcuLs0DsZCM6G7Ox1XF1ZqGQfM5lsh4FkJgcaUXpX7et+dsymgDQyS9dxunBTzreejB/cee7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GRhebuhH6sDysQYvUoH8P0ktIlUk8YaWvWcOJzaIgMo=;
 b=pa3dQZap38NA58cNUpYzbysY2pEDv4ycAm9bBA0kcL6bvv5UYUZh4t8trjrRSVc5BWIs8D3zOTndZ5aIb6QcJM0d5eMXZ2PDrLyQ0duWOBRF1vDc9xaIpVFgPAX0jDTtJ5INcTpQ3OQFN1hjDBnNcvPr3WzEwgTN8o+fY1PCfm7Luu3iS0msT5YkJ0+MeGQNbjQbo/brfDltU3mfcU3ZTsvsGO9xGs702wue4sffmQcvTZeCTMTazptsIkaEVw04fQswsCEOwDW2v7qpk/l6amWC4PKijeNhK2lt6f5seg4NEq63u6vdo+p4TpxjE+HUw4fGaHRHYa4TMR13b/+puQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by DS0PR12MB6584.namprd12.prod.outlook.com (2603:10b6:8:d0::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7339.39; Mon, 4 Mar 2024 23:44:26 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c33c:18db:c570:33b3]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c33c:18db:c570:33b3%5]) with mapi id 15.20.7339.035; Mon, 4 Mar 2024
 23:44:26 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH v5 06/27] iommu/arm-smmu-v3: Consolidate clearing a CD table entry
Date: Mon,  4 Mar 2024 19:43:54 -0400
Message-ID: <6-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR20CA0049.namprd20.prod.outlook.com
 (2603:10b6:208:235::18) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|DS0PR12MB6584:EE_
X-MS-Office365-Filtering-Correlation-Id: ab5a509b-964b-45dc-2d16-08dc3ca50229
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	T+f8sKsQWY16zoh8Nxn9yipgiTdLQuxz92TjgCwQWFX0H4YIh7HKTuxwd1dpQiyxhwP/EK1csqCw4W3KdxLsihVPnl55rOU4/m5KfN+hhnfCEP5BB0vv8xKOEB+DMokUhSEMOJKNn+SAZn4W4DzHNnEiXl4OfTvJHkMqO2c6KRuqCVizQb9eLxK5gG19F459gp6AACumwgc466i3QQ6hjTRWmSwkaASgKnC4Q2FA5IUrypiXRq1SP+i7+A3KjE2N9vyigy8zRKdYZODnIhGLfIlHyydXXJh/NhTmereX07sIflgvadqHIhjulJN1zMhAhQUT7ROjOmZdHLyrR8MBuiJOIVa274LiTEiRpsuozsKec4eGywucV4g0sRe6R4FH4mjkFZvpmXnZh/mk940CiYg5mErUP7DifKFFOXRyjckWTiEJanp40mMlXb8pvJxj+dIbV4szEUVIfPOeKqLnFXX1Xdjn4tobpQkJi0+rIlAcfhnUBmgkGy2iPetwpreRNeR7sdwqy2I9RuwSxRhp2S4zcS/ACypH7bJbS70lAix+Dhlm3um/dGuO7eEZNUCgsF31iKTHi+st1CP9P+352yEUjfcFzj//Z2ke5Gb+hvsGLrGaS185h1e+dgoEwh8gNbBbIos3a2iQBf3kqXOz0jdEjEreap255/bNEKwpY7E=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HejsH1UryROFkRziDHHDS9jp5DBGnNNLWfPyGjyQp5Uk51Kj+wGO6LogLGU0?=
 =?us-ascii?Q?J0wakr69Y8fGS0BtlY5FdhOUI/UhjJLttzRRzftQQVaV9iCGkdIOPp9Hr4Fg?=
 =?us-ascii?Q?2MNsexr2P+YahFztZMvDHtr/BbakMwPXk6bptJzKjRTLc2zQlVwZgMWpehtV?=
 =?us-ascii?Q?HWQjvF5kiOkpRW0fdShs9j4g8V3D9nTByHdCbgYc7XptvmPPJJgTKSwVchHy?=
 =?us-ascii?Q?MDo5u6Px9+cYeJbozfhfGBlTAG/32E5zN1BzpK3NO16cjl5A622Dj5uiFQT7?=
 =?us-ascii?Q?CqJdFsXC/lUR31JXyoJufCPczNWzqr4ZbNQtN1SrruLej5PEMVPY5ZSDiGhl?=
 =?us-ascii?Q?XRm9ycCjin7niTgDpk7fYgLZY+/+XPp3dHR06V2LydWfYfmmi96B91usS6th?=
 =?us-ascii?Q?vmOCC+dzm7gMovrDr3hKWzENhEglu69TbWdqSGtbZ+/ny8P+/rk4bvIM+OVW?=
 =?us-ascii?Q?JHX3NRrIxfUP1XYoPtk604eY1x2Shq8wMNtPtR3sl85L4+mweiJ9ulkEjn6o?=
 =?us-ascii?Q?myb74uLcQ8tMWAEdOCsQxj+sTXsDsL/30Kee8RyJkTMU5A0Ss8ticSggqQ3e?=
 =?us-ascii?Q?vMuwvt3vPlMjGsJiudRznH8JYFEF58PpH9xBR/dzlMNW6v8FOywUaXC0udiA?=
 =?us-ascii?Q?vRr1c6gakxjAgk69DC/mjxqXtf0TUh2PzV0Psyd9bUqXW61Yjza8sHzLhnuq?=
 =?us-ascii?Q?adxIvaZtlG4lA0MxzzsKfHZZc4e924fr4hHAcI81EZ7VaI0I5M6FXOkVSX92?=
 =?us-ascii?Q?HcZHZAJr4N/KrP7zgesknx9cGIb4CCbhZkL/GetZ0MItSnffUK0N4YK4g7L6?=
 =?us-ascii?Q?fWPdmWRucjkiINkhVYaaQzfqyy5+qT4gMIoT2fyt1ZnHSqTjSg6fSzsjSr4n?=
 =?us-ascii?Q?aeqzDVBPY3d5vHSvYlq216CuEsZvbTylXpFITmDEFeQVaSDRFhOh2ReXnZDr?=
 =?us-ascii?Q?e5yiNpweOM+w38oJZlTjsgb2liJk56p6yG6vDp8C2KUiRW/jCR27IsIoeX8h?=
 =?us-ascii?Q?8SqusFkkIxRDXGbUWX/RFGcNXovzjhIXty1Jllqpvmg3ETXSZIfpBJZ4Eou8?=
 =?us-ascii?Q?hJl4EgbYZQQuHN+D9Ula4k7pSqiZXEbolgWE3bmWhhLnlLyMAXvL24biH4qB?=
 =?us-ascii?Q?RqVC/b3tZXig4dWw7giBPhu8XCXPDz7OJQIGGoYXyaqHAEawOSycLfw89fsz?=
 =?us-ascii?Q?34E4A7RurdiXclfZBRexKKi6bTrZnUokv3Gn/eiFRTmfAItUdA/evt3yWEbW?=
 =?us-ascii?Q?UktuDJC5GD5voEYTIjA3IHtJTZRc6aYK8TC1ImZUWbMLDxHzZXg6T5AM9yJ6?=
 =?us-ascii?Q?pDmpFX8HIcMXD70fvgO+E7F8H6RWi22qBy6EHiwlRe/pvuYIoP3bpI12J+W/?=
 =?us-ascii?Q?SR0RbR0SNHFrdBCngmJfMzcBbl4Px48yl0oW+xRw51WQbfWaFAd5TfKn66SG?=
 =?us-ascii?Q?sjvBZxguYfVvYqi/J/oCRp+wBnJ8tOnynIfXZikAEHr0V6xOcmRZdIiisnVN?=
 =?us-ascii?Q?bQ2hcBSEqmsDG7WxfFA5lIWiU+PkxpNJQUVq4PjIv8/ZLyugo7BRPr1sYvIH?=
 =?us-ascii?Q?Wr+0KaJYFR+kv84+FlZoj1MlaRPXElrf9PfrBiwi?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab5a509b-964b-45dc-2d16-08dc3ca50229
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2024 23:44:18.4245
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7wYheIxT4skYp2YDRPp/6NNF9TEdWq92HpQvObVVop5AsvnZP8CUGB7ENMTQtGsq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6584

A cleared entry is all 0's. Make arm_smmu_clear_cd() do this sequence.

If we are clearing an entry and for some reason it is not already
allocated in the CD table then something has gone wrong.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |  2 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 20 ++++++++++++++-----
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  2 ++
 3 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 347c2fdd865c1a..bb9bb6fd7914ce 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -558,7 +558,7 @@ void arm_smmu_sva_remove_dev_pasid(struct iommu_domain *domain,
 
 	mutex_lock(&sva_lock);
 
-	arm_smmu_write_ctx_desc(master, id, NULL);
+	arm_smmu_clear_cd(master, id);
 
 	list_for_each_entry(t, &master->bonds, list) {
 		if (t->mm == mm) {
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 237fd6d92c880b..3fb4a1523d1d3f 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1303,6 +1303,19 @@ static void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
 	arm_smmu_write_entry(&cd_writer.writer, cdptr->data, target->data);
 }
 
+void arm_smmu_clear_cd(struct arm_smmu_master *master, ioasid_t ssid)
+{
+	struct arm_smmu_cd target = {};
+	struct arm_smmu_cd *cdptr;
+
+	if (!master->cd_table.cdtab)
+		return;
+	cdptr = arm_smmu_get_cd_ptr(master, ssid);
+	if (WARN_ON(!cdptr))
+		return;
+	arm_smmu_write_cd_entry(master, ssid, cdptr, &target);
+}
+
 int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
 			    struct arm_smmu_ctx_desc *cd)
 {
@@ -2702,9 +2715,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	case ARM_SMMU_DOMAIN_S2:
 		arm_smmu_make_s2_domain_ste(&target, master, smmu_domain);
 		arm_smmu_install_ste_for_dev(master, &target);
-		if (master->cd_table.cdtab)
-			arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID,
-						      NULL);
+		arm_smmu_clear_cd(master, IOMMU_NO_PASID);
 		break;
 	}
 
@@ -2752,8 +2763,7 @@ static int arm_smmu_attach_dev_ste(struct device *dev,
 	 * arm_smmu_domain->devices to avoid races updating the same context
 	 * descriptor from arm_smmu_share_asid().
 	 */
-	if (master->cd_table.cdtab)
-		arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID, NULL);
+	arm_smmu_clear_cd(master, IOMMU_NO_PASID);
 	return 0;
 }
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 7078ed569fd4d3..87a7b57f566fbc 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -749,6 +749,8 @@ extern struct xarray arm_smmu_asid_xa;
 extern struct mutex arm_smmu_asid_lock;
 extern struct arm_smmu_ctx_desc quiet_cd;
 
+void arm_smmu_clear_cd(struct arm_smmu_master *master, ioasid_t ssid);
+
 int arm_smmu_write_ctx_desc(struct arm_smmu_master *smmu_master, int ssid,
 			    struct arm_smmu_ctx_desc *cd);
 void arm_smmu_tlb_inv_asid(struct arm_smmu_device *smmu, u16 asid);
-- 
2.43.2

