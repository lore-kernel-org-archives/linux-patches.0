Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2063.outbound.protection.outlook.com [40.107.94.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B792B205AB8;
	Sat, 14 Jun 2025 06:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749882969; cv=fail; b=BdhBsLR89fmUTTFrU8S755ZX60gZZNrZ3XPq0LBF5gd5aG9qW5yLkV/UvZSkLPnXUttMLb3aAcLzdyhxyrI4GgdIvye4towflz5a6qG11JlPvHsSnxt6S8mTtEgDDVs+rQPeS6Zlbdl6TIlkJ5ZZMPbp7uBPnCTB/62RTNQ6iU0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749882969; c=relaxed/simple;
	bh=8tJrR1BVEl8c9MMlqmlLrDSIfrMfPQFhz46q+y0jA/0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T0iPQvP5QyukVxWlpdA1TFHvoxK/hXIxvyVt+MX2+S2GjBdCNFmUY7yN0yDi1k6J9OIv+hWQnbcwi0/GBpkmENGW5SSYMc5azluQ+d4H6N9XfEn8WbyvTubYH4njsKyQRIIP7ed1U3w9hWDFXQEdXLRlMstNzxjXW20fT2bGpoM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=CC9dKloI; arc=fail smtp.client-ip=40.107.94.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="CC9dKloI"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mAyQYSbrp1yZnrMkPtjOQUZPcpGQ9ZBLLBWquWYgriZTSBAeLHU0p7BfL4hZhqepK8z51HAS/rrPBOcjnoqryIFVA+ZWboeCG1whlc32vQGN5KtzXwaVnpZZpMSoRDwI/TTc63irKlTsKpUvpZMd0jXLk30yqn77uHqxxjjtGrSQeknu8yNfJGwPAoYAaR9LMLlKLT2BDr4pDq+dRFylxLg+4WHk463otvygCmtFRBE586uA0431SUCnOCLOhpiCuJCCOJL0GUTNd5dvkZbI3Jmj4wH/vgL35op07+0F93t14moencXRX6bbYgEI8RoQ0vApbXakNQhPThHsml6upQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JzxGmQR4LlSgVoLr3rB5XYInbdZl7hJLYirtouR3h5o=;
 b=t0MoF9TUhAOMAOlJSC15ndIFBkWKucrKaVw8ox7ICLqAovMeu6OZ2A9gMprDTc/kwJkdDMNKx9yvarH6ghZED8sr+ghgkekprLmG+tgBv52vmKU6aJ1+CLfUnjS1iSKikz0rv9u2vW7ZJHMYOt5LV6kkX4kg6LK+x0R+UBxD3JCxXT/PVK74eoUE9tjuePgXp3hmtkOxVfhj25kpCw9QMMzNs+kmvM7CnEvyjjTW2xAKZhb6yAxdiVe10pYZksOkgoNRQlJB5ZzUzY+u+NOhWvzU84WAGKTvdyqJ47vHs2gOQjI5KMYIneP9MqjDNyksGbd7tKzn2L1g4Rw+GiZUCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JzxGmQR4LlSgVoLr3rB5XYInbdZl7hJLYirtouR3h5o=;
 b=CC9dKloIJL+Zz2T1mmpwyvmUWycz/Tg9ztnbozjwhO479jf2U18h7Pqj3MjKRIOAqasV66EPYZCnkl4vokVdHHE4anAQVKtm7QUijlWwi+F7lSO6QeZD1fB0Cd0XZ8ZEpe8w41SqGP67+yNI0rdrFv7RfNEVmJ6jSsTe9jgvkcnupi0Z0rwh3wf6XfwhOLnc9dqeIXYacwW2+pxfx0R9rZ+E1B5pY6gQcxq6uObYsuiwPG+sUmIA3R/aTNVPAIDhhpjqI/9u59ih67hi2JXWsMQPndn0efGorKT9+7TDkRBDF6aCe92q2YcI5HEHiWj7kTDh+KBFtdasaoa2LaWUlw==
Received: from BL0PR02CA0121.namprd02.prod.outlook.com (2603:10b6:208:35::26)
 by CH2PR12MB4069.namprd12.prod.outlook.com (2603:10b6:610:ac::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.27; Sat, 14 Jun
 2025 06:35:59 +0000
Received: from MN1PEPF0000F0E4.namprd04.prod.outlook.com
 (2603:10b6:208:35:cafe::b0) by BL0PR02CA0121.outlook.office365.com
 (2603:10b6:208:35::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8835.23 via Frontend Transport; Sat,
 14 Jun 2025 06:35:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 MN1PEPF0000F0E4.mail.protection.outlook.com (10.167.242.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8835.15 via Frontend Transport; Sat, 14 Jun 2025 06:35:59 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 13 Jun
 2025 23:35:44 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Fri, 13 Jun
 2025 23:35:44 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.11) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Fri, 13 Jun 2025 23:35:43 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: <jgg@nvidia.com>, <kevin.tian@intel.com>
CC: <will@kernel.org>, <robin.murphy@arm.com>, <joro@8bytes.org>,
	<praan@google.com>, <yi.l.liu@intel.com>, <peterz@infradead.org>,
	<jsnitsel@redhat.com>, <linux-arm-kernel@lists.infradead.org>,
	<iommu@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>, <baolu.lu@linux.intel.com>
Subject: [PATCH v2 13/14] iommufd: Introduce iommufd_object_alloc_ucmd helper
Date: Fri, 13 Jun 2025 23:35:25 -0700
Message-ID: <e7206d4227844887cc8dbf0cc7b0242580fafd9d.1749882255.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E4:EE_|CH2PR12MB4069:EE_
X-MS-Office365-Filtering-Correlation-Id: 82b9f7d7-25d4-4b89-27b1-08ddab0db9ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Mt+cPkMRC8ecobuydKVUb1xoheFBAJdiQV4+vHl3yK5hmFHCY50HLKXVTgK7?=
 =?us-ascii?Q?PepHPoysBSxFRWriP0DwYjsxkuAXJLqarRVKVPBI2aDhPc/iePUwBTA9E573?=
 =?us-ascii?Q?seLFvrF0dYfw+pyhMtB7JIZIDkEwpBA9B5n0kvuhIavdDZU5VHz2WLwPSWpa?=
 =?us-ascii?Q?f1oA8qq3mNZt2DS6+WhDzR5m/n+a3vsds3xf9aJwNHkstQLruvNevTd4iA+l?=
 =?us-ascii?Q?wFfvP3hlXR/u3mYek2Qq6FZUVKMXvTygUS3TNkb34hJuu3nXiDSYTp3sr0pX?=
 =?us-ascii?Q?lKeaETxm5fm0rHr1+ERjLQ6kHo1/z3FgeZUIIRm2D/DryyvHNWuJR9br+o8W?=
 =?us-ascii?Q?ofIex4vYjg28aqsmpWDG4RtLEXwD3cIezCbsVlaY0ojtbHcSw68DAcqeBam4?=
 =?us-ascii?Q?vAXQQZgCCpt828O4SPASV9CRh8c8cycxJ6qi1gZbFzSZx0v55/6naaT4FBW9?=
 =?us-ascii?Q?qCctrN0FSVLh7FDOrtVPk2nD+aeqknQ4kIqb5BeV61JIm0rtWK1QHMNFH87J?=
 =?us-ascii?Q?ON/bXNye4U36dPs433LMLJLHXnEu0RQR5aik13PgO3bw+JVwGvtnhF8GczXp?=
 =?us-ascii?Q?ukhM+lUzkhcs4lGk89Me7Fb8Ui8g26BJ8lQb0MxsjyBpHy3iEN62A+ixoC0u?=
 =?us-ascii?Q?oC7Z06HQTyKAmkExpHvCPP9z16krldbLejeW3TV2qvX6NzrtPacPgfqtlIVa?=
 =?us-ascii?Q?6gWE7pL1tvg9bPqv5FFHmubUHl2jcp/blGQylknrAlJ85YnV5NVfv/v9W+Jq?=
 =?us-ascii?Q?iS6hVaGWkZJmyHqHCy93zBibfnqpBCQDv5dO4rXgf+cx3B9WTDPdkl0eSfTe?=
 =?us-ascii?Q?+SYIyNDzcZJ9kwWN6mKedqsLaNyi0Aky6mrsOGnyjb/XGjxDIfxSnQ8vSj1J?=
 =?us-ascii?Q?pVbkzCoXKFZ4Pp4aUEPSqZ6ihyP8jEW6r6Ex6SApEd1ZO0EvfU3HaonZKIpA?=
 =?us-ascii?Q?5Bf9sXH/0BBtfTqo3tEbysBH9etJB5EsGfiYEsyU0G0xHb9h6MoYrnIGjISV?=
 =?us-ascii?Q?BLatVxI0QPTMeO7Fxdsbc5vtes/FGb8ipyCtriDQSm9Y4QW3mMMrNTMr0EEI?=
 =?us-ascii?Q?TREnwiUJxFt1Tr/EEI0MfnMDAEAOY7LBRinp0DPGDkaPOglRZh8aXLKsaMv2?=
 =?us-ascii?Q?O+lfOkVioR95tgWDoZNlqM0hKl4BRxp20IdxQF/FL3amlW3x9XafQC7cZmVk?=
 =?us-ascii?Q?OHeTirvpDFqd7mo9XaZyXzJGv2F4P1iosO4j5urlZr344oRJHZ7wCSmKMq/A?=
 =?us-ascii?Q?JwyYmExxXiGlHGmzXOf7GcVBMpuv9VBKKO9B3Boevt5ptLFbEQtJ7+UUt8hB?=
 =?us-ascii?Q?JHNRIqMdRfEBd51X984BFJibUdAY4LPUhce9WJY+GF8ru1vb08MgFrKJjq46?=
 =?us-ascii?Q?GbpSVtGWPEPd7PWmNLayyeNys6f4aNDCyzmNE2EArQz4bdMpf/ZY5uRxq7jV?=
 =?us-ascii?Q?my/kp6ynal15Ix7n1MIobZwOomdhKq2CTPx37+Q5dtbXxcLWaLHbzDMVwniW?=
 =?us-ascii?Q?N1pF3X5uOm3srq/QLxQRfTsEiG0RI+U37S3L?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2025 06:35:59.4484
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 82b9f7d7-25d4-4b89-27b1-08ddab0db9ca
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E4.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4069

An object allocator needs to call either iommufd_object_finalize() upon a
success or iommufd_object_abort_and_destroy() upon an error code.

To reduce duplication, store a new_obj in the struct iommufd_ucmd and call
iommufd_object_finalize/iommufd_object_abort_and_destroy() accordingly in
the main function.

Similar to iommufd_object_alloc() and __iommufd_object_alloc(), add a pair
of helpers: __iommufd_object_alloc_ucmd() and iommufd_object_alloc_ucmd().

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/iommufd/iommufd_private.h | 26 +++++++++++++++++++++++++
 drivers/iommu/iommufd/main.c            | 25 ++++++++++++++++++++++++
 2 files changed, 51 insertions(+)

diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
index ec5b499d139c..4f5e8cd99c96 100644
--- a/drivers/iommu/iommufd/iommufd_private.h
+++ b/drivers/iommu/iommufd/iommufd_private.h
@@ -135,6 +135,7 @@ struct iommufd_ucmd {
 	void __user *ubuffer;
 	u32 user_size;
 	void *cmd;
+	struct iommufd_object *new_obj;
 };
 
 int iommufd_vfio_ioctl(struct iommufd_ctx *ictx, unsigned int cmd,
@@ -230,6 +231,11 @@ iommufd_object_put_and_try_destroy(struct iommufd_ctx *ictx,
 	iommufd_object_remove(ictx, obj, obj->id, 0);
 }
 
+/*
+ * Callers of these normal object allocators must call iommufd_object_finalize()
+ * to finalize the object, or call iommufd_object_abort_and_destroy() to revert
+ * the allocation.
+ */
 struct iommufd_object *_iommufd_object_alloc(struct iommufd_ctx *ictx,
 					     size_t size,
 					     enum iommufd_object_type type);
@@ -246,6 +252,26 @@ struct iommufd_object *_iommufd_object_alloc(struct iommufd_ctx *ictx,
 #define iommufd_object_alloc(ictx, ptr, type) \
 	__iommufd_object_alloc(ictx, ptr, type, obj)
 
+/*
+ * Callers of these _ucmd allocators should not call iommufd_object_finalize()
+ * or iommufd_object_abort_and_destroy(), as the core automatically does that.
+ */
+struct iommufd_object *
+_iommufd_object_alloc_ucmd(struct iommufd_ucmd *ucmd, size_t size,
+			   enum iommufd_object_type type);
+
+#define __iommufd_object_alloc_ucmd(ucmd, ptr, type, obj)                      \
+	container_of(_iommufd_object_alloc_ucmd(                               \
+			     ucmd,                                             \
+			     sizeof(*(ptr)) + BUILD_BUG_ON_ZERO(               \
+						      offsetof(typeof(*(ptr)), \
+							       obj) != 0),     \
+			     type),                                            \
+		     typeof(*(ptr)), obj)
+
+#define iommufd_object_alloc_ucmd(ucmd, ptr, type) \
+	__iommufd_object_alloc_ucmd(ucmd, ptr, type, obj)
+
 /*
  * The IO Address Space (IOAS) pagetable is a virtual page table backed by the
  * io_pagetable object. It is a user controlled mapping of IOVA -> PFNs. The
diff --git a/drivers/iommu/iommufd/main.c b/drivers/iommu/iommufd/main.c
index 85ad2853da0b..778694d7c207 100644
--- a/drivers/iommu/iommufd/main.c
+++ b/drivers/iommu/iommufd/main.c
@@ -61,6 +61,24 @@ struct iommufd_object *_iommufd_object_alloc(struct iommufd_ctx *ictx,
 	return ERR_PTR(rc);
 }
 
+struct iommufd_object *_iommufd_object_alloc_ucmd(struct iommufd_ucmd *ucmd,
+						  size_t size,
+						  enum iommufd_object_type type)
+{
+	struct iommufd_object *new_obj;
+
+	/* Something is coded wrong if this is hit */
+	if (WARN_ON(ucmd->new_obj))
+		return ERR_PTR(-EBUSY);
+
+	new_obj = _iommufd_object_alloc(ucmd->ictx, size, type);
+	if (IS_ERR(new_obj))
+		return new_obj;
+
+	ucmd->new_obj = new_obj;
+	return new_obj;
+}
+
 /*
  * Allow concurrent access to the object.
  *
@@ -448,6 +466,13 @@ static long iommufd_fops_ioctl(struct file *filp, unsigned int cmd,
 	if (ret)
 		return ret;
 	ret = op->execute(&ucmd);
+
+	if (ucmd.new_obj) {
+		if (ret)
+			iommufd_object_abort_and_destroy(ictx, ucmd.new_obj);
+		else
+			iommufd_object_finalize(ictx, ucmd.new_obj);
+	}
 	return ret;
 }
 
-- 
2.43.0

