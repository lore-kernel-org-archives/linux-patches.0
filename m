Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2053.outbound.protection.outlook.com [40.107.94.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D8E217E0;
	Fri, 28 Feb 2025 00:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740702010; cv=fail; b=faso3gaP1eVunYG3SqkRUFtwSxwl7Yo2ZYyuXbXvZ0yi12QLXjaQcc47QjltxQmgeRVaLXCG9DXHNfNeNMmS/wWWua4aA4Ge/CAEAV/mcntCrRxs3u90JqK/SVmtVQ0zqI3a/DxaFmmhQovKfEzvE299JPb5OnfMoQxHAvzPQVA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740702010; c=relaxed/simple;
	bh=hClszFEJvLS1oGDDSt6B1tPs0V2G29wvNAzvDFGFT9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=lJPWGgNMX6T6e3T/1nReGlUsJ3r+En+9XcJjcQgp+KtXIZKInG7KvM1cfSAd2ZEgCTKSy0HuFqQZnv7kkr/fYPhjqp9iFPYE+owlOPEM1SKGo9T7JxwNEavvbUO829ZsEq7f7Mso0BMO5dMN9F7rcSg5sgEdQDSRqtzE5e15TdA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Sg0JjhBh; arc=fail smtp.client-ip=40.107.94.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Sg0JjhBh"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=io6ulRthdAS/padqvhRToo1QrqiyBjVDESQs36V2j0hb06Vuaub8I7rRclwhA8Wfo29bAI+yMYm3ceKw52aos9LUH4ssUorZnxOpfd7kucoXqJJAOrBG/ImHzIfKQj7WiSZRYA+Ab86x80weKW8mvUZaW70C2hDhUEZqHYPt8hvpoPlgyfNtIit/L9AiEOGAVePlB3VKkTaEfLlgPjUOdd4DWZfcmjbZFj63/0hNme1lrqSQdeuWV0yNWjkXmrxBKGQr9AamS/cTa2Xm8/f7x/fmHiy0xoDuUQmKCfOCZXWMWXYARyz0sKauO+h0L28TLz5znX6uGpLKYpXuW03GUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GhcTCZHjA//ObsUqUAnWLho4qYd8GiUvHBSlDcA7Vx0=;
 b=SFXzMNCHdKItyAMgrMlLNu3WjrhhD1+cAA+13qvLiMwnNJvlm9TPCR4gdVnvKpO1SblgXCTq6MuzYWc83yWUJQVvhl0PeCCb6Zd8+SM7jA35wAfZmynueScZqLfHMXubAge9upOLNITDvovix6j3iihtfzhLB4XbIOBHwndhUU+HG8VfU0IQqkaLGd7mLGQl9jGOgC3lq5ZkF3VotIIBXw2CAZcX7XETYXNU4pXlwSINJ88AJ/nI6ZdRVVlAwUOkiEC+wT5DDVH0iqymMMj/P2LA7////y35vE7cinILqMRCYC12HX2e0CZSAnUgSALGSfuhir+9uzeE5KMOzaK36A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GhcTCZHjA//ObsUqUAnWLho4qYd8GiUvHBSlDcA7Vx0=;
 b=Sg0JjhBhP9sz3VY3s3B/FJzpABgfNr7sJn2If5P/jKxWSK/qDnQpTiPLQa2Wn/f6QZtpBGuQhD5ZA2Dz376ZN1D7Ck6rxvDSj9Sp/DChBZQGK/WDLpbL8MvoUvTUrSyM2mr6XybyPoiYl6lIayHa3AkR7q2xd6ihoglRJWBKPEBLaRqQPZ5NMMPUp21wOQipPdDjGyIic6XfidXDyZuEJjvDXF7tnalxlqvwZ5hk9dt0kFaAcFGXHgjqfNkEaP1BKL1k+9IeyLTImHft/98HBNNftFKy9VofOExl3ekbHvv/YlIF0BbaK2CUgdkpZ2zOF0KvTUZ1VU+NIIANgGmMIA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CY8PR12MB7433.namprd12.prod.outlook.com (2603:10b6:930:53::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.18; Fri, 28 Feb
 2025 00:20:05 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8489.021; Fri, 28 Feb 2025
 00:20:05 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	virtualization@lists.linux.dev,
	Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>,
	patches@lists.linux.dev
Subject: [PATCH v2 2/5] iommu: Add domain_alloc_identity()
Date: Thu, 27 Feb 2025 20:20:00 -0400
Message-ID: <2-v2-a3b72fd4b99a+1b6-iommu_virtio_domains_jgg@nvidia.com>
In-Reply-To: <0-v2-a3b72fd4b99a+1b6-iommu_virtio_domains_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0150.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::35) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CY8PR12MB7433:EE_
X-MS-Office365-Filtering-Correlation-Id: 476d0d1d-783e-45de-c967-08dd578da635
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0dJPktVt4rUH1BCWDDLdTm4GOFMYMXUSvO+VdqOyBF/zqrP2bz6ik/9+Qzh0?=
 =?us-ascii?Q?7rchhcs5OWs9hnjGLDKNiIHZo39KxRMS4Ris0s1YS3X4sWC5NJ9DDBfHqIM3?=
 =?us-ascii?Q?VhJf8Ihp9pq1r/oPfYIPvXs+UV5Kgqh9V2FI2DEMuolkEwTwwtWE5CK9Ybu0?=
 =?us-ascii?Q?23Pc2LM8hFMHeHxHcsrK9oH9u1Eq5noaKCffRD18+9pYQGh/gJrC687Iztee?=
 =?us-ascii?Q?t9FQPCRXHgb+FKh7yECWLBlcIppSCY+OdkyMcwWFIwvBiq9T3+3+o1AdX+FJ?=
 =?us-ascii?Q?FJXplJazzKeTCXZRX5OM0wouFgSglw+3Na/G8ECvCWSqIDxcFf92Dn85PNXH?=
 =?us-ascii?Q?PcyjQASFHjtmpGST8NA6j9CezecRRNduDUOTDAgU+HUCQSa5IyKbYu44cGgZ?=
 =?us-ascii?Q?XUXekGExwZkwwRjFNEgZjkD9Cn2NcFzPNO2eXWpwm3GbbvfY4HsQz5X1mwpQ?=
 =?us-ascii?Q?KVevLqyG82+1jM5yNQoI+OCr5A875Mwhb/+SWiKxAua8MNplTlnqj8tKpie0?=
 =?us-ascii?Q?Ax5vJTK0E0/vMmBMH2Z3srcq7bOyyuNuHl1AiQQ8qPmlTRuY8MWSVVngMAfP?=
 =?us-ascii?Q?o6DMnrcIe4RhXDTC1iaHXvBevZzB6NPKrt7FBelPNQarrc7MR8xk+F9c6UeY?=
 =?us-ascii?Q?ygOefSpMupN3nSrsO2igykH6p1rdEeEamNZhKYrDDxjiuO4gbJcapDZSUl2V?=
 =?us-ascii?Q?tTDL4bwhIe6KGGsHKtRPEJm7KhZ9nq3lvO8lSzG+ogj19f3XpXP64EQ3ef9n?=
 =?us-ascii?Q?9RGwR9w805YZTrK+govtvTWeLJjrVBa9RwAqGVyX20a/i+fc1R+W8+kqqNkL?=
 =?us-ascii?Q?q7ePtcjymu6nc1TkSj8bp75XIeYmxOo7j4Tce07JaE7PdGRxrT51Wi3LN1o/?=
 =?us-ascii?Q?YKzVhgys4z6aGjbBDiKAg0Pp50QoeLtAt7OFXampHXZ9z2FDxnctDKf5KbVW?=
 =?us-ascii?Q?q+H/GFNe119kFilOFw05vAPztyf6B3bxTuAZ0U6hnVEUiNzk7PXd3Ubw+BLH?=
 =?us-ascii?Q?amUljZDdNIclkQ85Ybqki3IBhruVr6uYnphpu+YCfq3OTrSvK+c989EFjaJi?=
 =?us-ascii?Q?IZim+qQ18D4XKKt0o2SG8WNzZ2c2FJ1rR+VjOvBpDOiTt9A2lx2LGve86UvQ?=
 =?us-ascii?Q?ibxbuXX8iMnEDbHzxiDezCnVEmfxLDd8R2+UCI6ZpRTMSJ+IqyOGQ73982GF?=
 =?us-ascii?Q?PA34c0rE0HMSTJsYJf7mOEZv5c5ezxu2m8u9sd9PYdoMrPf9KU3XnoiBi86h?=
 =?us-ascii?Q?P+FXDhVImMsOp173sbVEw+h9JbG3/aaeP7O4Qtnq+KD8DZeq4bXTIX5GiPzG?=
 =?us-ascii?Q?UWPjfL0nAmRlZNtUKjpYpsEg1OKjfq6yFfbWEJnlPGreIWVTCSro/parnBjT?=
 =?us-ascii?Q?esuTAl7ysexO/TGhiiFlI/zbunnQ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HEDerPTi8G9V7fIPejZWYPpnqOIsleNBBDSbXRqRQpaJvgOIJa5tvfepSbcL?=
 =?us-ascii?Q?U0Z5MobOURoI37k1rsdvLf1SO/D1C8bRO9aCVryjmEW0w9vzhbG4BZP4Suzy?=
 =?us-ascii?Q?/iRhuxKf4xU9CfVYOFqS2exYsj9xsa56WfvKSCcpFLVCelvR9q9dqFegRsvI?=
 =?us-ascii?Q?o8ApxzFKNLGa+JBoLLyZ3oK73M7qISLJh9d6xM9wnI+6Ipkyq10sCB7QdJhL?=
 =?us-ascii?Q?JuvolI6IGRebGUNrJz/uxewHIKMHOuyyp946Gpu3POkxYPTIzUY5/nsOhWXM?=
 =?us-ascii?Q?LCfTSFrC8maHChfsUgBWnvNNQ+Ha1hehh67QbPYC0VzUuUnQfsXGXbSi+TyU?=
 =?us-ascii?Q?EnYiB+Zer4eATXvkDwr7tA4w2MYOStCGfHMSCLSA4bFya04Ez9904+F4OKuh?=
 =?us-ascii?Q?aNgQbCZHOArhHcUgPvZNTBi0lOyiSYl5oDKmudWGd7Hh/WZlTA/rUaR2oSIx?=
 =?us-ascii?Q?Tgoy1ZIJjWtE26mfVvubelyzEyD43NVZPQbW6mMe/RcSiRL6UQQaHi/qUerB?=
 =?us-ascii?Q?Cdb1ak7nN5UfQy3YuitlZTpVY/tlTiEtLZiSh0ScWCCrLgB9NpKghcBYfPBh?=
 =?us-ascii?Q?lK9Npud5CTWVRlwGUTU8abHxQGvs+Nz3kBYzOouxcEhkd7vl59XI55p1pOL2?=
 =?us-ascii?Q?oKP12Odmr1co1o/vuuUiwdrarR0T0r53LGjoYxUeVioomYR4kgJ43u0tW5vm?=
 =?us-ascii?Q?W50MerBgqXDTtYjWTiNY4BkWg1f4NvLYkCRko9DdMlayqMsoZaUKuEtpGQ+5?=
 =?us-ascii?Q?RSPHuVc8k4dgXn4tAPXw6rzh+sjFF9D07kEg1SQHQ/LeUi0p+aBZvnZd5S7w?=
 =?us-ascii?Q?Si7UFH+S4+J7pm0v5NcYMxhb758FYGR4GuoPr8ePe92VVKwAkywPgiaHNOLd?=
 =?us-ascii?Q?t0/tyuQPxQLt0YcRLQYontXfubJkQIojhXiOlaGdyeMOjL/kgjrK+/XlQ6gk?=
 =?us-ascii?Q?EpDrJORJ48or2q+llX1jZUTacRSmTa9fz8JpLhkM5CyDd3YCGKvj6FXje7Y7?=
 =?us-ascii?Q?RhfrY7Tt1Twty+7DHNdeENII+HbhXqw6HRiBBD3Ib0uBOmxpVaUHcBaSS8+V?=
 =?us-ascii?Q?sz5SE+p7G5le8SnL4bMHpoS9osj+4VXvVL4ha7L9v+chDO5HXH6L9xgch40K?=
 =?us-ascii?Q?FplOCKF5PH6IZAKd+anCBQcjUjVpBZqQb82r8hBJAxGfnhSD83suk7AYv7YW?=
 =?us-ascii?Q?9WZPEPbEc3zaTRhwJ0XjjbAhNcOGK+/a70uGFAvtrXbGHpZ/iAmkvOmjDgKe?=
 =?us-ascii?Q?0+eXKYMYspVNmlpiYuQo+a0ZGcdcEnHobfDatEJj1639nGzOJYI49BK8FFB+?=
 =?us-ascii?Q?3/dq8S2nmMEMTxWV2HoRec32YdV7xJANUxKEm5fUbFHcMLUgsVmsk+xU8bla?=
 =?us-ascii?Q?NKBSKlRhkUps5gw/2E/ewMGyN1O9YDuYtJJiW1+eS2G1nbp8O3h89fuAqhof?=
 =?us-ascii?Q?bBVYzukPQQYQXW450WrUkF32ahjL6jxYtAl4SmLySOGyR87B8W8ugteaOLB/?=
 =?us-ascii?Q?CaTEqBs2ZzE7lBzP7tC8WjJdn4MI4Zpd8WwhrKsQfR6lIelJEvVQkrNO+5lH?=
 =?us-ascii?Q?2ptsuATPX6x70BV1PNQ=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 476d0d1d-783e-45de-c967-08dd578da635
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2025 00:20:04.9538
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P2d7HP/2xRegpBDx06XFO2Q4rsE9oM88rgDbugaz7Ps79YfGeygdzPoymFGsZoex
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7433

virtio-iommu has a mode where the IDENTITY domain is actually a paging
domain with an identity mapping covering some of the system address
space manually created.

To support this add a new domain_alloc_identity() op that accepts
the struct device so that virtio can allocate and fully finalize a
paging domain to return.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommu.c        | 20 ++++++++++++--------
 drivers/iommu/virtio-iommu.c | 11 ++---------
 include/linux/iommu.h        |  4 ++++
 3 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 870c3cdbd0f622..ee33d26dfcd40d 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1595,15 +1595,19 @@ static struct iommu_domain *__iommu_alloc_identity_domain(struct device *dev)
 	if (ops->identity_domain)
 		return ops->identity_domain;
 
-	/* Older drivers create the identity domain via ops->domain_alloc() */
-	if (!ops->domain_alloc)
+	if (ops->domain_alloc_identity) {
+		domain = ops->domain_alloc_identity(dev);
+		if (IS_ERR(domain))
+			return domain;
+	} else if (ops->domain_alloc) {
+		domain = ops->domain_alloc(IOMMU_DOMAIN_IDENTITY);
+		if (!domain)
+			return ERR_PTR(-ENOMEM);
+		if (IS_ERR(domain))
+			return domain;
+	} else {
 		return ERR_PTR(-EOPNOTSUPP);
-
-	domain = ops->domain_alloc(IOMMU_DOMAIN_IDENTITY);
-	if (IS_ERR(domain))
-		return domain;
-	if (!domain)
-		return ERR_PTR(-ENOMEM);
+	}
 
 	iommu_domain_init(domain, IOMMU_DOMAIN_IDENTITY, ops);
 	return domain;
diff --git a/drivers/iommu/virtio-iommu.c b/drivers/iommu/virtio-iommu.c
index 55a2188197c621..2287b89967067d 100644
--- a/drivers/iommu/virtio-iommu.c
+++ b/drivers/iommu/virtio-iommu.c
@@ -1007,7 +1007,7 @@ static void viommu_get_resv_regions(struct device *dev, struct list_head *head)
 	iommu_dma_get_resv_regions(dev, head);
 }
 
-static struct iommu_ops viommu_ops;
+static const struct iommu_ops viommu_ops;
 static struct virtio_driver virtio_iommu_drv;
 
 static int viommu_match_node(struct device *dev, const void *data)
@@ -1095,8 +1095,7 @@ static bool viommu_capable(struct device *dev, enum iommu_cap cap)
 	}
 }
 
-static struct iommu_ops viommu_ops = {
-	.identity_domain	= &viommu_identity_domain.domain,
+static const struct iommu_ops viommu_ops = {
 	.capable		= viommu_capable,
 	.domain_alloc		= viommu_domain_alloc,
 	.probe_device		= viommu_probe_device,
@@ -1224,12 +1223,6 @@ static int viommu_probe(struct virtio_device *vdev)
 	if (virtio_has_feature(viommu->vdev, VIRTIO_IOMMU_F_BYPASS_CONFIG)) {
 		viommu->identity_domain_id = viommu->first_domain;
 		viommu->first_domain++;
-	} else {
-		/*
-		 * Assume the VMM is sensible and it either supports bypass on
-		 * all instances or no instances.
-		 */
-		viommu_ops.identity_domain = NULL;
 	}
 
 	viommu_ops.pgsize_bitmap = viommu->pgsize_bitmap;
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 38c65e92ecd091..6389d59178ba3f 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -557,6 +557,9 @@ iommu_copy_struct_from_full_user_array(void *kdst, size_t kdst_entry_size,
  * @domain_alloc: allocate and return an iommu domain if success. Otherwise
  *                NULL is returned. The domain is not fully initialized until
  *                the caller iommu_domain_alloc() returns.
+ * @domain_alloc_identity: allocate an IDENTITY domain. Drivers should prefer to
+ *                         use identity_domain instead. This should only be used
+ *                         if dynamic logic is necessary.
  * @domain_alloc_paging_flags: Allocate an iommu domain corresponding to the
  *                     input parameters as defined in
  *                     include/uapi/linux/iommufd.h. The @user_data can be
@@ -615,6 +618,7 @@ struct iommu_ops {
 
 	/* Domain allocation and freeing by the iommu driver */
 	struct iommu_domain *(*domain_alloc)(unsigned iommu_domain_type);
+	struct iommu_domain *(*domain_alloc_identity)(struct device *dev);
 	struct iommu_domain *(*domain_alloc_paging_flags)(
 		struct device *dev, u32 flags,
 		const struct iommu_user_data *user_data);
-- 
2.43.0

