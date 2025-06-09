Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2065.outbound.protection.outlook.com [40.107.92.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D22D4220F48;
	Mon,  9 Jun 2025 17:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749489256; cv=fail; b=gNpj4Py/XFB53OepTfqkD29wiyeoN+iV3AFq/LEgqKeIuSZgnRo/rNFV6E+0FPQQjv8OyPp+vixbLSad7VvrDGa4oEG4+NpvWTITyWPDZSnd/P4tIrCNss0tqlu/y3NJliJZxhe0kc0myyZs5bcAS0s5XPqIAgSWiI+BI++aMSc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749489256; c=relaxed/simple;
	bh=eo1QgRuO2/YrlW1I5+XpnKRARQXInSc+b1bLhAUwUFo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VH8VgmuPT0ZKJnHSj2KY247FBHjO+nA3YC4YMrgtIqzoFlcig6BjF2zPgZ9lgPjaZ8x+oJjTlECNGZfRtKQ+nuWADBDlcHfQNVmn6tR89e3wm2IR1l8cc5HoSccMn9Mp/8162dRmcp226Qi8I59KLFAQgdpKo5Ze0m+mZz9vtaQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=tdkxWLPY; arc=fail smtp.client-ip=40.107.92.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="tdkxWLPY"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pbhPRpLGGdycJLgz06+YSIWSLbQ7M34ek+d4r1p3gab5WMxTsMuuLEWvqwIKMIrtVDf4AUfXbSvJcISYVr3/l/LMvlzlESJh5/TgECgCfRXyvsJn3hqaXUlDWNpJtnwQoij3AVeDbX+Hwh/27jfhko7+eHut6JE06E7c2zvxJWJx+VW2ExtZVbu4aJCv+Sm4b4gF6yGC6hLn7xfusIEaDQggnndgrLuURZ6T23xxOKq4pb+h0+QyGC5jZa2a9oRuyk/Zw0vzdek/6hhK5789hx1REPgGPmpi1qBDxb0cazuNqSU5ybiKoJ7pFzuUZ2B3RE9B2zzHJZMlh+YIQG3VGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jDmtOkoBuocf6pbXWlehMbj6TuN/a8lpW5jM+kbPEnc=;
 b=qXMXQluZrjJr6a8hKeeWkHhQoQrByKikmlbKDLrU/dIY6iqkeDa/l7xgUQ93nR6lA/ucgpELC3UtVNKUyGRiXPFyimtUe/w7iSKCcd1RC11gmUiEuYmRoEHRQqnL85SQoaZGdqkkChJKWG5o2rLmIUAfXxTX2/aFlphsl8sSxV+HdZCos0vXJs+1ncl2bOD1NmLLv9TKRG4/cuc+uZYexzVjvZa30bN9nP3km2VHUAZletMIEem3/k+6o84/XRyX5Xnr+rF8nywaiUJQnP9JSKPMmjYlJt79mGuHsa8erhek2w0Geb92mXGH9EN8268gwWapgi4D1iupUPhdqXGqEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jDmtOkoBuocf6pbXWlehMbj6TuN/a8lpW5jM+kbPEnc=;
 b=tdkxWLPYvy2KpnlPwJp2sk/LaC03XfWZpdbSHIVki/OaUHWzrzwQ1qWB2J7b1wNEa8a7J7qRGVeJhm4hvij1ESmjvgPyegDjNF88iIpgsI/slhRrGAh15z/upvsdwG//mebcJfZGMczwvwesNBUgXAF4pibArVD6KtEHABAacrM2rVhBIF4TQ642rDqyzmmnQdgCr9v3sxz3+u5k6Yzi5Y0okG15+jgl//9OyHYFZRRpJCo8g6BYAaPPjDogA8/J8jL842uEAbsyR0uGKOP6Mu+Zm+Ejvl27KbrXtmx4UvBFtg7KOmJja6KFju88aPigGysI9fY5lPZNX33skdvaUg==
Received: from MN0P223CA0016.NAMP223.PROD.OUTLOOK.COM (2603:10b6:208:52b::29)
 by CY8PR12MB7099.namprd12.prod.outlook.com (2603:10b6:930:61::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.37; Mon, 9 Jun
 2025 17:14:11 +0000
Received: from MN1PEPF0000F0E5.namprd04.prod.outlook.com
 (2603:10b6:208:52b:cafe::53) by MN0P223CA0016.outlook.office365.com
 (2603:10b6:208:52b::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8792.35 via Frontend Transport; Mon,
 9 Jun 2025 17:14:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 MN1PEPF0000F0E5.mail.protection.outlook.com (10.167.242.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8835.15 via Frontend Transport; Mon, 9 Jun 2025 17:14:10 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 9 Jun 2025
 10:13:52 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Mon, 9 Jun
 2025 10:13:51 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Mon, 9 Jun 2025 10:13:50 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: <jgg@nvidia.com>, <kevin.tian@intel.com>
CC: <will@kernel.org>, <robin.murphy@arm.com>, <joro@8bytes.org>,
	<ddutile@redhat.com>, <yi.l.liu@intel.com>, <peterz@infradead.org>,
	<jsnitsel@redhat.com>, <praan@google.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>,
	<baolu.lu@linux.intel.com>
Subject: [PATCH v1 08/12] iommufd/viommu: Replace ops->viommu_alloc with ops->viommu_init
Date: Mon, 9 Jun 2025 10:13:31 -0700
Message-ID: <5586990446e4c97827b5a195622ec0f8cf9d2d67.1749488870.git.nicolinc@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1749488870.git.nicolinc@nvidia.com>
References: <cover.1749488870.git.nicolinc@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E5:EE_|CY8PR12MB7099:EE_
X-MS-Office365-Filtering-Correlation-Id: d2d8b841-ab69-4a57-2cb7-08dda7790d23
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|7416014|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?F0bzzZWIz3UULH2Uz+HknO45nXb6/k/4s8w0sL4H+5QSWUwys6r//+FetD9l?=
 =?us-ascii?Q?ii588eo8GOA445xPeJQWhzu8JV3L6z5OrQ66oXom4gBX38+MqJYRoQ3PEcNB?=
 =?us-ascii?Q?MvrO7IA5WdkjRK0mujAqL9Fl7z9S7wnDQbma56SSXs+HRsiDU3R22R5L3/UG?=
 =?us-ascii?Q?JOf1UYQwdYh62+jRgemhYWlArrps2D1a/ABISqhkUAd8iGbqKJ6pfcFsezC5?=
 =?us-ascii?Q?yzDnHdwSJIn8Sp7uZW/i/wQnv1sQOk3cJV1sX6uqAil4Rtc1VnFhwYiaW+y3?=
 =?us-ascii?Q?WFfgallvW586hlnbgrW3hE+Ua8PdyKCKLkGravmR8BcYRKkl3wzBEfn0dEL5?=
 =?us-ascii?Q?ttfL/8NWTDB3R/s4YqovYNFedhubB2mBc++yVoeAmJH0cu2pss5DQEE2vtTt?=
 =?us-ascii?Q?t3ZX3zV2mvYp4qi4DmqNXoaI1s2V5qvkIFxTY23Je2fCdKYb1WZDLaaLAYC0?=
 =?us-ascii?Q?vAHvKh5225K1iEfxGyAdZANWow4KGhm06BM9tVKNcIVs8dNKr9b7EiU5WdhU?=
 =?us-ascii?Q?j1nbe6TzGI3HB+El9TAivS5+5unMdtteO1INnN9Xwwk9uf0BE8/Ji7WKJpF3?=
 =?us-ascii?Q?LQhZqTiHUicU2YV6jDRrUVhEB9kvyrO4pn1i5n0pjvt6tBrEx8Dpts4KIelm?=
 =?us-ascii?Q?l2HJOptcJm2zxBnDQlBakgcfnWDUzotkUDVqzSqQ2QK9rEtsnmh/l2t+INTU?=
 =?us-ascii?Q?5+BMcQXeGKpaDrWjni4GN0yzlH7dgCRIF2MsTFgk9GKLBVsH7+dYCsklSAI7?=
 =?us-ascii?Q?c9KY8jeLqIsh22lVKPDjW3lg/k8c8JuUZC4gErll6FHH0lN4IYcYjy9uiGVV?=
 =?us-ascii?Q?jKSM2BWpaZFBSuCADrHMfZMSzKkx+hyV6XI/RO5kGm8pSTWr67RA+PvIzEkF?=
 =?us-ascii?Q?hgDeqAluQeqVXMm13iEVZzoisizaDCVK3RDMks2LXfZDoo5iSqUcBHLczfTU?=
 =?us-ascii?Q?+YCJCv9glWf/epjNOEsGVPG57G4JbyDmyM7H8rr8cKvpxkdcAvpHXCEyUzNP?=
 =?us-ascii?Q?yFob69ZgistL6dOzkHw2u71s5mIWTnJOdsTlhXidnMBzNC1PjhedZoFiekhV?=
 =?us-ascii?Q?BfuaCCOpDm2UGQeGSXGUMPLjRv2DVr2+D8kfCPfZu6LnFPEZeC9oc4EoV0Qh?=
 =?us-ascii?Q?8f6FJ3zKQC7v7io7uejSKhPoFdm6nPhyy82LrhypBMtAAj5TZ8EsS1hCMBb3?=
 =?us-ascii?Q?bjFullMe4fN6yPbbmSTyqYNHoWDQWPydM5A/fvn81i7ejhwECy2/he2HCfdz?=
 =?us-ascii?Q?gnzVOXxfumGAy2XkT9Fd6gUKEOULSJlLzuY+EItAk12H6oMWTt3cYJxlTiGl?=
 =?us-ascii?Q?78GN6MyS9hdBJweE0DoVre+ygwdiuznxcaBZ9/2mHI2hTzDi1C+78E937Iwn?=
 =?us-ascii?Q?IoBnydauJkrDmhMuD5FBTuIRK+hJG5y4blCTafZrAHgsAZYm6CrqmTZ5yCOc?=
 =?us-ascii?Q?DqhM/CC3AGiu1X/ga4ehxa+rZ9jRb9LoV2QJMo68pYjRrjIi2T3YuxrFc9EV?=
 =?us-ascii?Q?YcDiwGtP8wD/bMxao3Nfh3SbO/xMilD4RDLc?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(7416014)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2025 17:14:10.7775
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d2d8b841-ab69-4a57-2cb7-08dda7790d23
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E5.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7099

To ease the for-driver iommufd APIs, get_viommu_size and viommu_init ops
are introduced. Now, those existing vIOMMU supported drivers implemented
these two ops too.

Relace the ops->viommu_alloc call with the two new ones.

Note that this will fail a !viommu->ops case from now on, since a vIOMMU
is expected to support alloc_domain_nested at least.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/iommufd/viommu.c | 30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/iommufd/viommu.c b/drivers/iommu/iommufd/viommu.c
index 01df2b985f02..63a92fb27ef4 100644
--- a/drivers/iommu/iommufd/viommu.c
+++ b/drivers/iommu/iommufd/viommu.c
@@ -21,6 +21,7 @@ int iommufd_viommu_alloc_ioctl(struct iommufd_ucmd *ucmd)
 	struct iommufd_viommu *viommu;
 	struct iommufd_device *idev;
 	const struct iommu_ops *ops;
+	size_t viommu_size;
 	int rc;
 
 	if (cmd->flags || cmd->type == IOMMU_VIOMMU_TYPE_DEFAULT)
@@ -31,11 +32,24 @@ int iommufd_viommu_alloc_ioctl(struct iommufd_ucmd *ucmd)
 		return PTR_ERR(idev);
 
 	ops = dev_iommu_ops(idev->dev);
-	if (!ops->viommu_alloc) {
+	if (!ops->get_viommu_size || !ops->viommu_init) {
 		rc = -EOPNOTSUPP;
 		goto out_put_idev;
 	}
 
+	rc = ops->get_viommu_size(cmd->type, idev->dev, &viommu_size);
+	if (rc)
+		goto out_put_idev;
+
+	/*
+	 * It is a driver bug for providing a viommu_size smaller than the core
+	 * vIOMMU structure size
+	 */
+	if (WARN_ON_ONCE(viommu_size < sizeof(*viommu))) {
+		rc = -EINVAL;
+		goto out_put_idev;
+	}
+
 	hwpt_paging = iommufd_get_hwpt_paging(ucmd, cmd->hwpt_id);
 	if (IS_ERR(hwpt_paging)) {
 		rc = PTR_ERR(hwpt_paging);
@@ -47,8 +61,8 @@ int iommufd_viommu_alloc_ioctl(struct iommufd_ucmd *ucmd)
 		goto out_put_hwpt;
 	}
 
-	viommu = ops->viommu_alloc(idev->dev, hwpt_paging->common.domain,
-				   ucmd->ictx, cmd->type);
+	viommu = (struct iommufd_viommu *)_iommufd_object_alloc(
+		ucmd->ictx, viommu_size, IOMMUFD_OBJ_VIOMMU);
 	if (IS_ERR(viommu)) {
 		rc = PTR_ERR(viommu);
 		goto out_put_hwpt;
@@ -68,6 +82,16 @@ int iommufd_viommu_alloc_ioctl(struct iommufd_ucmd *ucmd)
 	 */
 	viommu->iommu_dev = __iommu_get_iommu_dev(idev->dev);
 
+	rc = ops->viommu_init(viommu, hwpt_paging->common.domain);
+	if (rc)
+		goto out_abort;
+
+	/* It is a driver bug that viommu->ops isn't filled */
+	if (WARN_ON_ONCE(!viommu->ops)) {
+		rc = -EINVAL;
+		goto out_abort;
+	}
+
 	cmd->out_viommu_id = viommu->obj.id;
 	rc = iommufd_ucmd_respond(ucmd, sizeof(*cmd));
 	if (rc)
-- 
2.43.0

