Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2087.outbound.protection.outlook.com [40.107.220.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F2E021D3D1;
	Mon,  9 Jun 2025 17:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749489246; cv=fail; b=GZBDtS9CS39uh+2Dcxww0HRyITtpgK5rUbllCpCo7D+A+J7h7ZzF1r6ZDRgm+TGclB/sXkwSc+Rj+5ZUCWlIkPKE/Ku0alQiXgS9T+Ziviiz7zhoB8rgpZximtVLRUPdpO5xoCGUYcCl0KoCxzQ16IV9cQpGITZAU3M/LIMNTdI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749489246; c=relaxed/simple;
	bh=0EmqyJCX2ccvT8OoZXluB/MV1eN64WoHeFnceYZUN9M=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pHceYsSvC2i1LG0boUvhtZ7oSt9J6ty4MDD2kFLAi90iTYDS2PGMG/QqXf2Lob88KWjgjSUprlYLC9qfjely1dqL7s65usopQ/mqvdKgaqSEkB/OxKg2oR1nqaAtEvlClRxTD5Ctgc2Btb1aVpA/c1WCGSk/4zycjtpzoLUepV8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=dBmvmWlo; arc=fail smtp.client-ip=40.107.220.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="dBmvmWlo"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aMqpQ+flOrSbHzihDznQ6LIC7NjQGxTbZNEzQ/WHMj17iB9KAZKfmOojkaoClD6TqQZJ6p305EyIfqOnZmT8DOGDDs9S5f6fbwwkQuVdBerSgRq3xVp4fSjHEsFyAKGGzfaAy96zZfBWeZvhRpnNUqFg7qVPP/b/2jRaE8Mwn310YLOjA/5N1bH7dBGwmaDLTquF9MZdTDI03apXsGX/DBlcjI8SDPDZ3M3JT6nIMz7VZXBZKwhODm1Ao9PDcN1wzDLmSHwHXBQ18yZuxpUXV7Z5Bu43dO4YUPgf/o9U7EmS3Sqv8pI2S2hXQNh46QJ4SxLPatGJjk4xTubX8i6vnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QuB1wmz5OJylRT6NQ16sAukBPw3ly8YsidXxDbQNfyA=;
 b=y8SZrbBh5nXCBo/jokm8SEiIdDg6IDQca9hVD78NB2OszTIs9bBKpDJ4d49VjnOYIbK55gW8k2Bvq9IG57dC5CI+6Z97fpXRTR/lxp2UUms+kHkraQKPLOI2bQEaNkA1iKQj8llPLokJ93ldbx45/WqiL+YPimTwFHXdfMkMGReJHl8y2m/RVO7wGE0OQJam37AL6x6UJPHWJAN5E+0a7dHpSVExhrFuMksbBoG91NE60k8M9Yert4utfHg2HNM4uQRJ159t4vDKyN+ZmOdWnPlYNU8YM890EfZpzWsysfRhZN/QOKKKkT7C5q14PxP5xonf4JF3I/bZdXc57k+ltw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QuB1wmz5OJylRT6NQ16sAukBPw3ly8YsidXxDbQNfyA=;
 b=dBmvmWloHg5yIzcZvsmlYL8iafOaioS1wHTb3E3XW7xDoUT8ExNa8RHYRJgFRC61mEZf4crK/GtGV1hzhLt9l7oRSGaWzTkfgmkhn5Wq2qcCIAALw/mj8EuwDSknmgKq0A8mRNRyEjuMFdCzog3dxAhDnCm7M7rUnVeiHwcyVAU/Yb/+dyiOjVHDGD/67JFWsbFlE9/ZSq/iiGyuA0ZDxg8wqgAyjKnTSIMeao7gJi5hmkBvSdo8DL5//Tw5H5DUgEU7HKoLQqOGMMFbWMKOFwX+16yhdNfjuIymGj5H6qZRy/EZwb1+HIdfiLe9gSglxWbXg1qn7GM1lowd0PCLmQ==
Received: from BN0PR07CA0023.namprd07.prod.outlook.com (2603:10b6:408:141::6)
 by CYXPR12MB9386.namprd12.prod.outlook.com (2603:10b6:930:de::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Mon, 9 Jun
 2025 17:14:01 +0000
Received: from MN1PEPF0000F0E1.namprd04.prod.outlook.com
 (2603:10b6:408:141:cafe::55) by BN0PR07CA0023.outlook.office365.com
 (2603:10b6:408:141::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8769.25 via Frontend Transport; Mon,
 9 Jun 2025 17:14:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 MN1PEPF0000F0E1.mail.protection.outlook.com (10.167.242.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8835.15 via Frontend Transport; Mon, 9 Jun 2025 17:13:59 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 9 Jun 2025
 10:13:43 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Mon, 9 Jun
 2025 10:13:42 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Mon, 9 Jun 2025 10:13:41 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: <jgg@nvidia.com>, <kevin.tian@intel.com>
CC: <will@kernel.org>, <robin.murphy@arm.com>, <joro@8bytes.org>,
	<ddutile@redhat.com>, <yi.l.liu@intel.com>, <peterz@infradead.org>,
	<jsnitsel@redhat.com>, <praan@google.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>,
	<baolu.lu@linux.intel.com>
Subject: [PATCH v1 02/12] iommufd: Drop unused ictx in struct iommufd_vdevice
Date: Mon, 9 Jun 2025 10:13:25 -0700
Message-ID: <4c85d75d630d37df6e7140b7d396678046324975.1749488870.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E1:EE_|CYXPR12MB9386:EE_
X-MS-Office365-Filtering-Correlation-Id: d893201d-3038-492b-3a51-08dda77906ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?TSsSienZWkt3XQq/MaESfJq+Dz1FRMcydWs4b77SGfKx7dckNqcYt36wNeTT?=
 =?us-ascii?Q?Alph+nqY/DisgduZ90XgkTvxF8r31AEZcEWSNyFJWzbLsUkEoSqIOMOsj7Lq?=
 =?us-ascii?Q?q6kjyWjk7W+88dTd7kVjO/8mpEAg+8WE/3JVj7Sru4bcMStfe/TZ7z1qrtn2?=
 =?us-ascii?Q?7X9vxuZLIvqQUTwo5LlKssWRSzyy0lYX8hAw6tKeBUb3keBM8MoYwO0nlxVB?=
 =?us-ascii?Q?PydXfZXlw4tvxBUmvu1y1T6emZSUjgvXEptHjkie1dGONwUz7U4ocKhehQHz?=
 =?us-ascii?Q?UfM0+/Tz0QycjclRAVudoDuO8yXv32Fp2FETq7iDzel6Nwz2QmGR0PCArMmG?=
 =?us-ascii?Q?zOYfL1qsAJEMMBJ+FANb57VJa2cTQvQbQ1UZ9pq1Aywr9A3DuxgUXwxRahNR?=
 =?us-ascii?Q?MntAyrCTK1qR6JP8AbijofWsSc4ZzQRg8pp2aufWo42OXbfpBs3oGEMYLnIQ?=
 =?us-ascii?Q?SXiIhcs8OX8sGOoN5msfVuW9u9Q+vqxsRPbL74KAbzhtzZC89y3a+e7V8d0k?=
 =?us-ascii?Q?tZTGlQxaLUb7/6DKHhUrArIcfI3V6R/ZKkzTJdpQSzC6b1JMEe0bYYMH//LH?=
 =?us-ascii?Q?0PSHmRLNLqB25VrOHX2gCMMnbuZNf4rtgvol/1ShOxx7vw8RLt33DNWU3Pfj?=
 =?us-ascii?Q?Mvw9xOfJhIlJU6IPOSeq9MPt4V2X6VBKO3VrPyHDAS09C2EeCVGKSNZ6Nsg1?=
 =?us-ascii?Q?PsKWWy8Up/MpREmycTVzqqODIQSDL+pAOOKZoiB8kulzfMWcXoiddKAsBD6L?=
 =?us-ascii?Q?693bzoYDrhYimuwPZRPE9VDIf8CMcuOs0BxgRvSO665f3bi0Efpvlfcq4Q0B?=
 =?us-ascii?Q?0hQnBlE7ydUIAeNwqMGH8BmkqW804WC2aR4qc0fOi1EWq4sNLCVRM4lqSrKW?=
 =?us-ascii?Q?Iwzk9bs+DTSDR1aeOmZSEPpj5SLt64uiBTdC6DIYo0R0gieGpKqjvtkApuj5?=
 =?us-ascii?Q?QCmHewHISoesYjKk8zHiyEgPnsFeg//10ZwaBU3IebaUchlgxVsPRjzGB6GS?=
 =?us-ascii?Q?I6myVaJWvJZw+AhJfcDaYombk/QeZFocw0TSEjsXptlA1stFN9RaXqMw+QFk?=
 =?us-ascii?Q?dMH+RA90B6t3c0hGYWP9lN5H7hyg6R94Cm9LwwYqGnKP6M6W791XIxBOiEda?=
 =?us-ascii?Q?X/Z0gY+8VOGImNwf2gscnSnPn5GiAzMgSeIYel+pAqoL6+5o0o5Rb3NYsE+m?=
 =?us-ascii?Q?LU8Z509SnnhA+MkTqvSnbnVux3pe+quwZXJ+PQSWwpx92DE71qu95zKbh8VG?=
 =?us-ascii?Q?AcEsADSf22kaUDTEEbZbHkHE/SzdG5tR0LjGnxQNEojNIHWmkv4QdA9IFO6P?=
 =?us-ascii?Q?kk2oTkhFHHABid2RQ2oNHoj1tWWvbDfCO/TqMiPgUOgugRtBe4NZgR14zONG?=
 =?us-ascii?Q?IXbeT20wIQMM31OoHFMlD59+uCNsw9rarPr4uxP+y0oGYMhAXoIkdck/Ag5K?=
 =?us-ascii?Q?kC3ea7kMxZuPi4wfTUhEofW04JAmm925bGCGy4jMgOXHPL7rY93gvn0z00zz?=
 =?us-ascii?Q?xnt6eiE1ErxjXpjbTDsCZaoiFgoGmyrAVgSB?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2025 17:13:59.9416
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d893201d-3038-492b-3a51-08dda77906ae
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E1.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR12MB9386

The core code can always get the ictx pointer via vdev->viommu->ictx, thus
drop this unused one.

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

