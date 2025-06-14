Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2064.outbound.protection.outlook.com [40.107.92.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2DE71F2BA4;
	Sat, 14 Jun 2025 06:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749882955; cv=fail; b=N6UfOjzM5XZ561DrN2x2P02aoeCWlwf8UBIfn+1kiBjzgszh1/Be9cTIUSVHoIXNZ3uFVPvFBaF4VZSEUIqfDSIUxKJg/+nWZbTD96qkMyrhZwjdSPaxZpwKz+xCpB05GHmnVY2baxJbe7V09zrqooEladBGpIhQByJKbP2gE7A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749882955; c=relaxed/simple;
	bh=d90UoW8a9DRBVs+qumdr6L+MZNoq+PrzRVCBZEfeddQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ju3YDKahb018bqORPAhVyuPA82VMiTXUusXKB2RZL4U6SYE9xmi9ttFGnOrh+9M8a+LOousV6I2PIaroH+DTAtqu0Btpb1d7qpksUnyMsf9Y7rQXRmX0RxTXt3wdjH+Tz5PwTqDjyl9DWGTor3N9pZ//+XlFf4qpNosd8u0B78A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=P9yX82Ly; arc=fail smtp.client-ip=40.107.92.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="P9yX82Ly"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qnf+ePMLLFI0oF+cBujqTR/EOxOWUNaUTfoB0+ZCCRsArtSBPmex7ntmi/Ea2CY+nXVX5XhQlVg1daFbZNADRjpi4S6zQZPmRNATJcweSsbjxQeC02WpT/XK3tNJ8Sp04VRi9LqWaji3JZLUwqiLRljui7tO9LwTHJ74ATJMN19eX3sfMKoiZD71muVaaugKy3gGlr5acPUOX0+RjMFe3ZB1+XoCC3qBAwdRY2tpUrp68KhHNZe4WIU/eT8qNnkaCVVSBwT38V2PB/6ySu7IGQDqd33S2ByBwvWUF9EJipj65acrXZdqbVbQzNU+QtRUlmk56RoBIYmCCkjBRyRfHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xBKuGqPon6RJyhFJT3vVIL70XMIoO2f0qkjcDH+zU3o=;
 b=iTwrfsDsXw5GNiUkKeNfmaE4bMgjNksWafEtP/zkUJ8Xm4j5BSVVMfuRpdlcJH5WhXKotfRZBUmCeAaWmcAfLGmoM+IjPjL0M+iouOJrn0wkYS33sXqBWvim7voGjx+4KfAhuSY8nQ07Dd8Fog4YketannyBGo7JEiSbAFCEWarprAbdgjRiTjwFJGg7fvflpwY12BRt0Vz0Ev6/gUdEizoFTY2noowHAgX6YJhTF5+lWxa5/96IEVVXZXIfXGLiqxhsz9QHhLNTfUXIS/7/Mf/0J4vjdSy4J1MM9ssxJPZT/HrfdXamJnYIArDh9UgwZd11LK/pFZ0G6Gcz2Vi0iA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xBKuGqPon6RJyhFJT3vVIL70XMIoO2f0qkjcDH+zU3o=;
 b=P9yX82Lys1f16wE8XV58K/l6q+eNGBG+wIUNj+3NfLM/tkOKjXXRxS1HmZWxYUw3K39MF3p1i8TNEYyqumw04Qc+FqsUlAZQsyjkloXbnxt9ra4tLQ0RjECqJDtVlW0ZWZjSJ9U/99qOzmr48562rD2Df869LmIJzYt7Fmxudu4kRc29dXzvRzHuAuy6XwaVojEDiaefwLKwRwFNsayepxl/SeQyvjFb9jHiGwwzydeubwduElqPZeaRKyioTNmA4+4z1tpG/pXwfu19IrFQSX2IDyoh7Ew6RSQVQMt1PmLcXXZa2/7Z8jDPHAnBLjJ9MUXwtPgCRjyb/6z89Bm1zw==
Received: from BL1PR13CA0145.namprd13.prod.outlook.com (2603:10b6:208:2bb::30)
 by BL1PR12MB5874.namprd12.prod.outlook.com (2603:10b6:208:396::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.36; Sat, 14 Jun
 2025 06:35:48 +0000
Received: from MN1PEPF0000F0E2.namprd04.prod.outlook.com
 (2603:10b6:208:2bb:cafe::51) by BL1PR13CA0145.outlook.office365.com
 (2603:10b6:208:2bb::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8835.23 via Frontend Transport; Sat,
 14 Jun 2025 06:35:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 MN1PEPF0000F0E2.mail.protection.outlook.com (10.167.242.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8835.15 via Frontend Transport; Sat, 14 Jun 2025 06:35:48 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 13 Jun
 2025 23:35:33 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Fri, 13 Jun
 2025 23:35:33 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.11) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Fri, 13 Jun 2025 23:35:32 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: <jgg@nvidia.com>, <kevin.tian@intel.com>
CC: <will@kernel.org>, <robin.murphy@arm.com>, <joro@8bytes.org>,
	<praan@google.com>, <yi.l.liu@intel.com>, <peterz@infradead.org>,
	<jsnitsel@redhat.com>, <linux-arm-kernel@lists.infradead.org>,
	<iommu@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>, <baolu.lu@linux.intel.com>
Subject: [PATCH v2 02/14] iommufd: Drop unused ictx in struct iommufd_vdevice
Date: Fri, 13 Jun 2025 23:35:14 -0700
Message-ID: <6cbb65e8df433de45b6c3a4bb2c5df09faca8a7c.1749882255.git.nicolinc@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1749882255.git.nicolinc@nvidia.com>
References: <cover.1749882255.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E2:EE_|BL1PR12MB5874:EE_
X-MS-Office365-Filtering-Correlation-Id: 10ede7e2-8425-4e9a-2fbd-08ddab0db32f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|82310400026|36860700013|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+M/+JCwNgYRE1YU+RSygJkToYoXy9n7a7oqTkVGxS6BCxKpXAT/hr2vC62yf?=
 =?us-ascii?Q?WeC2ZDV9F6xukgmlU2F2arhMccE/awA11e13gF+gaqHcH6UABWceTe5J8/cf?=
 =?us-ascii?Q?kA27PkxlyHB0VSHwOy1YEMDRiiFsBJXG/iwvM3V3h+Mh9H0AayfTeiIR+Gle?=
 =?us-ascii?Q?0Vbjs2CBy9hV+2trRphWkma5LHf//P6QFatek3521OtiSzpoBKsZ/t0x7qUl?=
 =?us-ascii?Q?cd4BwijId2GVmquaEkeKVr55IgvRF4D0LS4Xa/zmj+D5IHGsICcWintML3g3?=
 =?us-ascii?Q?kLNZA4AqvApQsccYZSqkqGl5YZblzUxQrG8HldbXRxQfimQ7+rkki/XJLTCS?=
 =?us-ascii?Q?1cColjhBXggy3xMwTV1P5iGPJ5ldQ2A59LmKlpjXQFuGz1qma5DpRD8prNT9?=
 =?us-ascii?Q?HHQBVApUqcaQEtDvM/0Q/kMAUjdFuLSc6QZ10noFGbNYWcozs08JiLB2Chf4?=
 =?us-ascii?Q?GXdO7c6w7T/ofuY8cM7jXiEWI+RiD7Dp4hKEZR2Vyk+g93ralc1jVXQRBI+L?=
 =?us-ascii?Q?soC8tMe9sWKwDAXrWRiyX97AuOahBKTixheq8qwhCv6Kospcg76qg5eEz7pl?=
 =?us-ascii?Q?qSibiulB2Bf18lEIFlKqot4hK9o65reTVKiaN9iHBmDQ/8DCVSwUoFV/zs/v?=
 =?us-ascii?Q?BiO/vpTHB9Yk/9R1zjVowdBp50l1ki7YMuAJW7iEzNRikJcOniKlAN17S41x?=
 =?us-ascii?Q?wvR0+8mOFZyxpiVohqUECqucL3qLP2WthZ+nBXnraJ115pstwHUjAMSjA0Zy?=
 =?us-ascii?Q?2MWQhGV2mSx40MCyzz97o+CaxDd0Cf5rKPU/6xlxtRkf2XXMflMg6HSscJ84?=
 =?us-ascii?Q?Zuoo8tx8SJuf2aUPW96k7lpXURsNx9mmg3y1Pdz+vMAqXU78YZRxQQa8PYi9?=
 =?us-ascii?Q?nOpKYnVwp4ZopuWOihLJWpXCj9mDuT3Hh93Zf/6TaJI/tZC8/Oz2f8oUw54E?=
 =?us-ascii?Q?SqLyZ2CDHdP/IlQWNTX98ZtU1czSgznBOZLpVxbxbqR5EtUcrXD9+UGfuvdQ?=
 =?us-ascii?Q?5gz9fu4NMP7fQsZIOhUSCvTTIfenarjvDxP7ROwMRDWUmrvxbEtcOMiqaW0e?=
 =?us-ascii?Q?rEZ7p+0ZsIu0sEdWpiR8pZGVrcdQXUDIH7hu8fKnxXi27AuHBuGdKO7ESK7x?=
 =?us-ascii?Q?VJ/6/SwTrPDZiKAFLpxzcg8XtcE23p7m12p+qCev4Pw28RBxJuYXrfsGjU6U?=
 =?us-ascii?Q?yeu/veChMVCsAewcf437OY4XMaYjSkhOiw0EJQKzh9oroLd+vH/JuWsF9rHo?=
 =?us-ascii?Q?9zPfdVghyc02ohmed67xVb+RY7PIMliNbqgnUTLg/fPBHhYAqkT6wz3/rePn?=
 =?us-ascii?Q?A5IdsjpIX+87GE2JYAgM6hTqgffK9ZTIbFYdk2q8O5EEAOYHfe4/918St5DH?=
 =?us-ascii?Q?vZK7AMcSuQK4oVzQfEDiLKysFTMZj2dvotkJ29ZEFL6Kk+iBfxSVZQ9rMlas?=
 =?us-ascii?Q?Npr2a7zbjh3zPbKm3wd6HS5hIw5voJLf5nu6FFzQGIxYEcaA0wSuI0cDWIZq?=
 =?us-ascii?Q?pqeteLyBRiwdniqhLwpfilguVFBiXEQ4p/Um?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(82310400026)(36860700013)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2025 06:35:48.3615
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 10ede7e2-8425-4e9a-2fbd-08ddab0db32f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E2.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5874

The core code can always get the ictx pointer via vdev->viommu->ictx, thus
drop this unused one.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/iommufd/iommufd_private.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
index 190ceb5dada3..4619285c09b7 100644
--- a/drivers/iommu/iommufd/iommufd_private.h
+++ b/drivers/iommu/iommufd/iommufd_private.h
@@ -601,7 +601,6 @@ void iommufd_vdevice_destroy(struct iommufd_object *obj);
 
 struct iommufd_vdevice {
 	struct iommufd_object obj;
-	struct iommufd_ctx *ictx;
 	struct iommufd_viommu *viommu;
 	struct device *dev;
 	u64 id; /* per-vIOMMU virtual ID */
-- 
2.43.0

