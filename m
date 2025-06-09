Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2043.outbound.protection.outlook.com [40.107.223.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DED6122129F;
	Mon,  9 Jun 2025 17:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749489260; cv=fail; b=SpiCqzGzgwlPRbrgcJ3ZH8amEZDzu4AKMxGdwm7jXBC/uHSp7Np5q/ebNMlX/bBIdESbgqBMpv50oGtieZIIDS8o4iUnctNjpDAv1Z2zmBKV0W75mXrCD8I0DImpaslCtfNWkFO3xn1pX9+yE2AF9IqGwIXXdD4NYeLFefAnRZw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749489260; c=relaxed/simple;
	bh=0qTQi+H3LnrGJrHBO0Ge/InjGzDgTRHpYfn3Xt1I3N4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gA8LTn7peKOTZdto5di2UfP0VwM0AA8m5jm1TzQRwDsuBXaOcreyF8Jkdiv9YG6rr1B9j+ktygAOhxeHCwlLEvkpTh9bDTwT+9MvOYbW1KcrB9aEEcfxXsY/ZCEeau7mZgDxVQTYxHeHWfKLGgk2rCIgNhkm2qvPwh6unxgN29Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=oJst+j1a; arc=fail smtp.client-ip=40.107.223.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="oJst+j1a"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PxmQtlF0rzVsnzGg24RyZAD2i16P9qmWjXGzHiZWrUlqg+ncuqIAtVVRa0kEZbpSn+7itQNdE8F3bjNmriRP9fD0UlL3/zYmp0C8/hM/WTEafg6lM+w1BrFR1LmErAnzIKp9vH18TdaOD5Fe4MUK2geNYqGRQpyI6hVyeOw3XKTDAwXHBEOPql2psBup8oBkqLg3nVfMvHwlovfHvYrRl+NCsp5VH4pnJSkW8W6MOr1ztHsxSokZw1scoArZLLk2Rscn7P37RHFh7Pzr09nn87gAKwhvfFwnSEPZUCMAFTE4J64gKGaF1bkhfnVTI6h2pLDvm6VIJ+kms/DZp3+rkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LtWOAdzC2XfXZhbaW9ZHcILQDIedsIfd91BDF5xlkFI=;
 b=k1ObgIzRGGQQBrE6uTJFdWV+5TxIFPDXmKDsPwM0RdbfJQdmA87ZsnT6xFPByxQ02KM3Fgdapsnj6TYPAfPIUZsFIaWdsGDkBj3UBy7lpWBfkg442hitrptmpdHb1wgpGqOmQPQ6PwLAc/TmJzjKnbZXCuBQhg3R+zOalCl81ccEMY0HxyKH4HaJ9LKyEbMWsrkghyF6Ylq5ehQdg4ACsnf7s39e6Uoi4YYRP7V2MMfGyQ/NK8ylqw0XrnwnSKjlVJtJBa4IkklNWp6GIdNVwu6aSHZ7wQD6VmHAi0iOi+MJuznibBdhr/SxFUisTSFJYOjZVKJbqkEdzTcOTu4Wfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LtWOAdzC2XfXZhbaW9ZHcILQDIedsIfd91BDF5xlkFI=;
 b=oJst+j1acrEsoGNy2dJLKsvlKbmnyMwvEVTGlqwOA83Z4IZH7Zt8Alx4rJzd/ta/Y/7XNXTDHr/CDNNA+uxbZR/gMtgzLiUEqifRxFn/zxoqxWmy7/5ccY3MTuiMmMLMQ0eCt23EXJdwQ7EXzunU3daqJ4jBJDC+JdHJpTsR+gevsJJucp8AjAupl3YEhD18cRmDC90if6PG+BYd3wVuq19dARwjQ1Ndb9+n3tDqeWem+ndbG2JPJtwXn2RXVs+73tQ2LoCyg20/gMZE2xU38ybhFajvRSaUofm+t14Pay+6YNcW5NTU2wDV4ZawJgFvnJ4JeIcw8NxK39ytFM1kog==
Received: from MN0P223CA0016.NAMP223.PROD.OUTLOOK.COM (2603:10b6:208:52b::29)
 by DS7PR12MB9501.namprd12.prod.outlook.com (2603:10b6:8:250::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.40; Mon, 9 Jun
 2025 17:14:15 +0000
Received: from MN1PEPF0000F0E5.namprd04.prod.outlook.com
 (2603:10b6:208:52b:cafe::8e) by MN0P223CA0016.outlook.office365.com
 (2603:10b6:208:52b::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8792.35 via Frontend Transport; Mon,
 9 Jun 2025 17:14:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 MN1PEPF0000F0E5.mail.protection.outlook.com (10.167.242.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8835.15 via Frontend Transport; Mon, 9 Jun 2025 17:14:15 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 9 Jun 2025
 10:13:56 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Mon, 9 Jun
 2025 10:13:56 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Mon, 9 Jun 2025 10:13:55 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: <jgg@nvidia.com>, <kevin.tian@intel.com>
CC: <will@kernel.org>, <robin.murphy@arm.com>, <joro@8bytes.org>,
	<ddutile@redhat.com>, <yi.l.liu@intel.com>, <peterz@infradead.org>,
	<jsnitsel@redhat.com>, <praan@google.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>,
	<baolu.lu@linux.intel.com>
Subject: [PATCH v1 11/12] iommufd: Introduce iommufd_object_alloc_ucmd helper
Date: Mon, 9 Jun 2025 10:13:34 -0700
Message-ID: <52edfd3e74c264f0f7b1f706d29e9edcb705e2db.1749488870.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E5:EE_|DS7PR12MB9501:EE_
X-MS-Office365-Filtering-Correlation-Id: 4907953f-2e59-433a-621e-08dda7790fb7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Kd7L9krkFZXShZDhUE9DkIU7Fa9XMRz2rgKAzm5dwJezcmVC9FOo3XX0+eYc?=
 =?us-ascii?Q?TSp/pxsXlTsYvUtdSbXJSV4lVY5Cgh6/OlN3pQDxJfhyL5Qzci7QlhG4FKR3?=
 =?us-ascii?Q?ubHlooUfT+RAGcZpsFxCTzFDx+DZLGDbaTuJwMJaS9UgTTO3sYAhluOm6n2t?=
 =?us-ascii?Q?4VprdfZAWQ3Z/VRDkr8cTwV0WAqSot05/M7nMXHqmiF7WP05eC+/wBUnfEGN?=
 =?us-ascii?Q?BzgIWG8Ks+RhaDA+3XZj6D0md9+CLUHpZost70KHvrsnPMQFLeY9JsnQcWSD?=
 =?us-ascii?Q?x2giNFXGQloh5W4hrXtLF3wsp4jhGVwrJc5HHMRcoQUbJLHbV+5XVv198B3O?=
 =?us-ascii?Q?TPy32I9oltLZMuUWP76tdv1bDGqWcYSesP0L2NW3+4dY2t8LCZwPwvTWVMrQ?=
 =?us-ascii?Q?/xDYeQ4pb2iVBPIbYzUhQaBh+lmgwJ/h99sCB068eZCP9D7JN9aj+Kpo5l24?=
 =?us-ascii?Q?XmUsvIWxZLh+tYR+ibwmXSiD1vIXVf7OvJvsUvZC5tanTVD2GqN5kxqnB6cN?=
 =?us-ascii?Q?KYttrEitRGOqtKnTc0WGHZwOAsDOwKNuyXZPbCXlOVWpBJWw3TRw6pdxiSCr?=
 =?us-ascii?Q?A3Pt4csEwZjw09+giqf/yre1QFfHdvHRtC5nJSNLDwWtg+Id671VW8qtbG58?=
 =?us-ascii?Q?66AeT5Z5UOxxUWzyYsQic60eeNaKutaT04mXrch1FYlXfoqGIZPDNz2ZdD/Y?=
 =?us-ascii?Q?0TD7szQ3cahFp6v440HgCt+JlMwMl6vcdju/jPMZsx77O1DVN5V7UyGW9LTa?=
 =?us-ascii?Q?yy/T2rRxQrwC4aBjYMFac3DscT3P0aav+4cDaLQgFdizAQK8j/nAb0mM8WvR?=
 =?us-ascii?Q?8pDQ20i4jv1h3BMF3nk4vVjZrHrzknfECavvPL7wBjSh4i9Xkc82avlyiFu8?=
 =?us-ascii?Q?RDUsWdgMrzPpNTnf86eP7pmmB0m2GO2KAeYLrxkZQe9LwE98GH8KjLoXRhMM?=
 =?us-ascii?Q?+xsXNaODK5jTvY0za/LhKIGyiDM1l3ndh7T5RZRC/BeFu4fhHUKz6cHRgyBM?=
 =?us-ascii?Q?utY0g53IVt0Efs66tbg7Oeu+11+TfBGhxRfTZ/J0oNkp72nd/LgzP8wkveW4?=
 =?us-ascii?Q?mXKQ8pmJ7bYEQd4N4U3XeCO78InnyxNibMlrDfotsaD5Y/GtDvbHr0BvyBh1?=
 =?us-ascii?Q?UNniaYZCoqOQPIOiZ2rjYe+HN2B1rodRlPRyS4oQTfv3zJUvBnIOeLkZF93u?=
 =?us-ascii?Q?5e9Y3KO9I0YHauekgvqcTVBF9/36R55StQ/PyJJl6JCdt/OYZEkDZS6OOpcS?=
 =?us-ascii?Q?XOKi2QJTYiPAu2vYj6lFG2ZyXESC7weLmXfqUHSAFbrCtJrkIUTd2WaEnqK3?=
 =?us-ascii?Q?k2E+++CtqgRsJg1KyOa1VTXjExkU3n18paOxLmPEQ4DzWocniNm3r7KXBx9z?=
 =?us-ascii?Q?69efR3+ZBX+Lw7LHHPXjCcMZbiG+MY53tpnheyg8Xj5vIhcY10Xl0XjHRqlr?=
 =?us-ascii?Q?k7JQeZYQq5NB7JU1GSYJDfRLCHqIKQBgEaReLnyePw1QxMhUZBnqcMKNoDhO?=
 =?us-ascii?Q?0Ityckq31AqbnvtiJgfCB+osMkc/hGbvU01c?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2025 17:14:15.1057
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4907953f-2e59-433a-621e-08dda7790fb7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E5.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB9501

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
 drivers/iommu/iommufd/iommufd_private.h | 17 +++++++++++++++++
 drivers/iommu/iommufd/main.c            | 24 ++++++++++++++++++++++++
 2 files changed, 41 insertions(+)

diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
index ec5b499d139c..884dbd67afc8 100644
--- a/drivers/iommu/iommufd/iommufd_private.h
+++ b/drivers/iommu/iommufd/iommufd_private.h
@@ -135,6 +135,7 @@ struct iommufd_ucmd {
 	void __user *ubuffer;
 	u32 user_size;
 	void *cmd;
+	struct iommufd_object *new_obj;
 };
 
 int iommufd_vfio_ioctl(struct iommufd_ctx *ictx, unsigned int cmd,
@@ -246,6 +247,22 @@ struct iommufd_object *_iommufd_object_alloc(struct iommufd_ctx *ictx,
 #define iommufd_object_alloc(ictx, ptr, type) \
 	__iommufd_object_alloc(ictx, ptr, type, obj)
 
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
index 85ad2853da0b..4880c085b159 100644
--- a/drivers/iommu/iommufd/main.c
+++ b/drivers/iommu/iommufd/main.c
@@ -61,6 +61,23 @@ struct iommufd_object *_iommufd_object_alloc(struct iommufd_ctx *ictx,
 	return ERR_PTR(rc);
 }
 
+struct iommufd_object *_iommufd_object_alloc_ucmd(struct iommufd_ucmd *ucmd,
+						  size_t size,
+						  enum iommufd_object_type type)
+{
+	struct iommufd_object *new_obj;
+
+	if (ucmd->new_obj)
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
@@ -448,6 +465,13 @@ static long iommufd_fops_ioctl(struct file *filp, unsigned int cmd,
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

