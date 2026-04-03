Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010033.outbound.protection.outlook.com [52.101.61.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 016CF3624CB;
	Fri,  3 Apr 2026 12:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775219217; cv=fail; b=evAI5wFAQjb5H2rtvp3M9BH6FAZA9FWOMrQZ2sKW3+E2rH7fFHKNOwp9O5aaBi6e8dBrv1N9mnzk5kznm19hrSbpTyXXBIKUXhJ73Fuv1CJ7WNx+16ik7UtFMZGg0lyH6Oz+ubfP7u5DvdkcQKPcFttUX/Ht9FQiSD7U36aqNSk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775219217; c=relaxed/simple;
	bh=OoUCPi+w2ZOXbpdpTjngimMV0/hbzUNtjzEWEmnjdZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JEDxXY+RsbRJzvX9gOESVdfS7n+WBi31sKetH2CYPqhyIv8jZk0ooTLiyOODMT747BshWf3sn0EkE/mr3GV+/9iEDS5voJcXkfsW7S2w51mb1mkqRU2M3CMGWmvHVmYcWeqHAcN3tDK8w2g/6IGG3fxjfxhMzoEbWNe/JO6uKUE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qW9spTte; arc=fail smtp.client-ip=52.101.61.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qW9spTte"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VXjAs74digoC3UlcphvdSFQjCcqnC3U88+ZS8wTqYwOsl8AzwX4cRGwdyqFrGdQOq+3N7rQKoCZR77DR7/3mDCTqGBWCV5q3TUX8CbkBGz7oj7zbfa7KSIW2z9cwiFv4+6VbfNm0DtlSjNnwX6xuGNDjtiNPBWPSrKbFdhGkNmSrZiusCBSeI/4qNAivaBPM5PagR17nyxBMRIbKO6qMUcq9TC5quapxzqElVraqTfVEd42ESwFydLXK4Pe5l+GKFMwCLeUIFUEGHRpdvYySzdw/+OH4L4eXHDKoDscIiEEekm/QTYVi4e08iKtwX0poqnLpvsl8Kn+1B5+eBPM+2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FM8DRjgHtJS42flv6zcfx4VFuFil6u/r4LfHbO9hDiQ=;
 b=tMKzs7u1+bf0mLuy6Wt5HL/u4Z4E/6qcg894eS2RbAp+kUw3lSqKciahMyeJRDpRGggPMTZ1ijkAew8MKUV4r9N1XLrUlJOguhUDQN8gADL+sSj60qpktEAKjRtYgj90fxC8uOv4bAy/WFYOmMIhIQnSAyjEqjnagPvMeF1t67ozqDWV8+PTzx4hjxBKP408IohSmzr/yIm0ACSiC32PXZ+a+tjyLCWlJg0H2wmbFnCUiZ46p7eK8T8O3xGqIXyP6W9gXbItioZY3wOByRlUUgm076hI506xyHWEy1LFyA5q4wTX0/Hd6ZlHU2rnvBqk/OlzMOOtQX0+9kJv4LjyeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FM8DRjgHtJS42flv6zcfx4VFuFil6u/r4LfHbO9hDiQ=;
 b=qW9spTteg0sm0vqZAhC9UJMBzIBeOPnHyXDaens4GuP1u4meP2BvYWAY8tpqMC7qvz/8u6VKxW5gA90+k5VWjvxHb/lnqGI8J6AxjB2MDhI3EGHkxaw83fUmWsDRN6wvxamSLP/IiV2he2j7t5u5WmGqxwPLNbfJdESLD2kZxiyDFXaOQFxKQFjELtZgpSpOW6Ho5XPxefwImSfKXpkYqceFKP7O0s95yX4E4gJEQxCRWX7Igcaqjfb8U2o6Lg0wW+XHSur2u1Z3Fla7866Alqv2fjT94cn3XVT+6x/S6ahf1532UXT4pjDq8QFgVSwm9suTlEhzi6dmWwPbd3KA2g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY1PR12MB9601.namprd12.prod.outlook.com (2603:10b6:930:107::16)
 by DS0PR12MB7608.namprd12.prod.outlook.com (2603:10b6:8:13b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.20; Fri, 3 Apr
 2026 12:26:49 +0000
Received: from CY1PR12MB9601.namprd12.prod.outlook.com
 ([fe80::cd76:b497:475f:4de3]) by CY1PR12MB9601.namprd12.prod.outlook.com
 ([fe80::cd76:b497:475f:4de3%5]) with mapi id 15.20.9769.017; Fri, 3 Apr 2026
 12:26:49 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>
Cc: patches@lists.linux.dev,
	Wei Wang <wei.w.wang@hotmail.com>
Subject: [PATCH v2 2/5] iommu/amd: Pass last in through to build_inv_address()
Date: Fri,  3 Apr 2026 09:26:41 -0300
Message-ID: <2-v2-90ddd19c0894+13561-iommupt_inv_amd_jgg@nvidia.com>
In-Reply-To: <0-v2-90ddd19c0894+13561-iommupt_inv_amd_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0110.namprd03.prod.outlook.com
 (2603:10b6:208:32a::25) To CY1PR12MB9601.namprd12.prod.outlook.com
 (2603:10b6:930:107::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY1PR12MB9601:EE_|DS0PR12MB7608:EE_
X-MS-Office365-Filtering-Correlation-Id: e4e6eabf-308c-4c4e-c162-08de917c4638
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|22082099003|18002099003|56012099003|3613699012;
X-Microsoft-Antispam-Message-Info:
	zu4KjGyWvaXDFq+4w26UsAY6g+1FsnFUxJxT1As0DDtQL4RfXQVVVYjtgCZZKNb63f/oDSsJTOak1jfpXGjhBs9CiUtPEb2/qHmtZ5JsjLRssaRJVevYrwpCd5tWNJC5rH+FgkLNVHrIrf5KkLDq8glO58nn1LnNtN51OWQPWdwSfEbW5CWYyTocdY/lKrgt458rqdMPSvUhSdqgzP0IqrSxMW4AeuvAY/ePcS9ejPpFMvOJ2MbaXcmCLRV1evYKIbdjG22Vd7d6Px5GwertvTfa+0EZvgtWTtntRKk9IKPzGSIS4KK4h8tZrbiPxugGGkF92vk+Yu5J99YyFps9v6xswWu9jhKibePkg96Q1L2yQRyfxQhXvLSW93yijrwDfWc2bOjTYjI/+P+bq7liz3vfUBspvdTbln9ojFHDABYjz7tdw6ZYmS5VjIz5fPbP61crmG2I2VAVpkc0avp5OeoK+24VKVwUMD4fznRyg+jOLOmBqCXURTEcX8eSZc2i69Ewg3ykamrle5uZKD+97aMqfrmqeWWYGrQzEbe+EnZbOUlWHEmcFtVrGcIvKSHge85D4YYZNIP+mkRcytXMKBmLlIeXAvEE3BiMA3f+wYSWw8ha3FdBH+x7n3F1YoahtmOLQzBgR62mvPPQuA1dng95O3jVqdutiQYEQ5TNkHvt/GGcvwCTDOrNht8ZKdONPjcgtATjGlD5BUaZSiDTaQScXp2c/d3HxBO9ogGWuvPycqFJvB2V2zd1NMtn54jhTVEE3xecMcOVFel0chN0W5X7n5Gdm/pWJ6h+dzgbmYs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY1PR12MB9601.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(22082099003)(18002099003)(56012099003)(3613699012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7TDiae1hB0xUSZdiyFxyd3F7xRuB+4nOu1h+z+cR/VWmkX63M8aPb1hjekaU?=
 =?us-ascii?Q?RwNqmXcm+hKqqNwPT0kp7PeoTzhZjfhGQi0+cTUyad17V5mVaC93ckSzPKtG?=
 =?us-ascii?Q?Si9PucXiqFOjkjczZn7atE+kKk+lf0raUuv4tHed+Mz8IyBu7vgLxV5s9ZaZ?=
 =?us-ascii?Q?6HvrO2XsbGAxtXxcAm1ZDc5A/SjJmn1Fk5i6ttZtEXb0/xlQByCvYB+9PCCJ?=
 =?us-ascii?Q?B2OM0ub1/jmWtlLrjDQqyHMn21C1H5VRCNPIhYkIuWzechPB+wGrWEXhHJ1W?=
 =?us-ascii?Q?nVz4q9/5Hu0tQRY5Jg8YIG9dcwSw5z6qb669iRupOPSavNRHZyjtQnAeNHyJ?=
 =?us-ascii?Q?ym8XScZl+nnnyMvq2MsPJXtxgT5dsSCmQ8uquSZIFW2wFLA5eppPc3ji9FiM?=
 =?us-ascii?Q?Guf8PZKqokoTtOIpO7eAZ2XudI8Snd5tE0ITAy6eIZBvhoqpJM5TJgVUq7Zg?=
 =?us-ascii?Q?HGnx0KlNwwvzi8q+MBhVCOkaWRexCuzA2gEjVr1l3r2ZncJJ/P+fNQwE511m?=
 =?us-ascii?Q?IwOJ0kwxmOXWba0SV7bgNUoTKkQg0dQ0dqEHiLSoc5TfpUaukt+MngEwc9CR?=
 =?us-ascii?Q?kn5pGfhRbxzqDyL0CvaIM8OV4k+fGQ1pBatdtA3CrwqJE3rJeDgoV8Th7gZq?=
 =?us-ascii?Q?GQNil2Xe+mB6Dq6FPH5m5qvniqcLQ/jG/GkUNSoowsNn9Ld1V3bb2z01vqLa?=
 =?us-ascii?Q?Sgzw750gPYd+4flNZYslR+hXJtOSPFkwcXTXrDoMCDtaS51HbkVCY/ivUaW/?=
 =?us-ascii?Q?z7Rd2mI4R+Lh+EppaBkYrvg6EgVzZq+0wLQNFeYz/QNmhKJ6tOXr34Q3hz5W?=
 =?us-ascii?Q?p7RNMWryoNT78RE/e6uveKtsbfA3QPTySlzjqVUsPrN8fl3Jfn+0OlTJ2et4?=
 =?us-ascii?Q?+4a6YBmKBE86d8ES+OHOCq1CIrK0Ghc7jJ5V68uiStrBMAkdOhBrDDKrOOI6?=
 =?us-ascii?Q?+GnTbX3wZ7U8CktQI7UX4BkULetC/voXlYtRiFug78QwVcApFm3CXGV39tDX?=
 =?us-ascii?Q?25POPzClP8Ac6FX5gROxBIuZrAqn7llNKde/+NqeoW9b8LAo1StahpOrM139?=
 =?us-ascii?Q?hyChsP4yEZy6RkB7tvOIZJplRdaW6iT5KDio3sIrz0wr6vrSAq9tJDM0OuUb?=
 =?us-ascii?Q?UUxsPbl6B0lfYiTChd6UdELJUFk1Z6z3pwpY7ejQmDj/18KNH5Khx+oF2Pvv?=
 =?us-ascii?Q?LGYvAVqjZXCz2aZNWh5mW8zz9lyqOjnc51/lfCt0qblCThMPGLaXtDdHWtHo?=
 =?us-ascii?Q?A7yQgd1HxRrJQflG5Q+dOOzlnU1wsZPD7tSLKUIuawJ14mQ9LJlVJrgKvAQ+?=
 =?us-ascii?Q?ZaC+g4ZCEkXjkQDwMPQsA2USEzTjqda+FXQjiIveGOaUS4VI5kXxkviEdKK6?=
 =?us-ascii?Q?ZJjw+saE4KXZvO8rauRiOykT+e1xmaU6If4830eKJwTE/p5DVm3vFRxxl+VJ?=
 =?us-ascii?Q?9AxQV4h4ThgJttZZ9AJVMXka6zQ3KOD/UQWwKJLwELP6Sb0tbFL85wH5+NSJ?=
 =?us-ascii?Q?nlJaaPEjmO7NbPH/jn6Srk7bo1weLalyWBh3A0BQL6ZXiHQI9dWn2pY+kYiY?=
 =?us-ascii?Q?ZBQLlslDqK1X8Vw8XeFM8Pg4EbRHoXaVZYSVhZ/gCGJA6usIFqqe6jJCAc3U?=
 =?us-ascii?Q?aQEZnTYMqYWil+iRIKZfxPUT1Y8VDt64Qt8ECfA5FO5Dh8HpelKdIWiLU71S?=
 =?us-ascii?Q?s62mO/gl1DAqWyDvVkirnw0KC0U3T0/5U/mXmyuF2B8QEo3o?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4e6eabf-308c-4c4e-c162-08de917c4638
X-MS-Exchange-CrossTenant-AuthSource: CY1PR12MB9601.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2026 12:26:47.7887
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WFU1hRS2ypn7gbenMdv03pp8dXUz/J3jRg4LTgAVMwusdaywHH3VMRqA9brR/gXy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7608

This is the trivial call chain below amd_iommu_domain_flush_pages().

Cases that are doing a full invalidate will pass a last of U64_MAX.

This avoids converting between size and last, and type confusion with
size_t, unsigned long and u64 all being used in different places along
the driver's invalidation path. Consistently use u64 in the internals.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/amd_iommu.h |  2 +-
 drivers/iommu/amd/iommu.c     | 71 +++++++++++++++++------------------
 drivers/iommu/amd/pasid.c     |  2 +-
 3 files changed, 36 insertions(+), 39 deletions(-)

diff --git a/drivers/iommu/amd/amd_iommu.h b/drivers/iommu/amd/amd_iommu.h
index 1342e764a5486d..831d457c8dad13 100644
--- a/drivers/iommu/amd/amd_iommu.h
+++ b/drivers/iommu/amd/amd_iommu.h
@@ -90,7 +90,7 @@ void amd_iommu_flush_all_caches(struct amd_iommu *iommu);
 void amd_iommu_domain_flush_pages(struct protection_domain *domain,
 				  u64 address, size_t size);
 void amd_iommu_dev_flush_pasid_pages(struct iommu_dev_data *dev_data,
-				     ioasid_t pasid, u64 address, size_t size);
+				     ioasid_t pasid, u64 start, u64 last);
 
 #ifdef CONFIG_IRQ_REMAP
 int amd_iommu_create_irq_domain(struct amd_iommu *iommu);
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index e4a88879ca35d2..9ea40ab8398048 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -1266,9 +1266,8 @@ static void build_inv_dte(struct iommu_cmd *cmd, u16 devid)
  * Builds an invalidation address which is suitable for one page or multiple
  * pages. Sets the size bit (S) as needed is more than one page is flushed.
  */
-static inline u64 build_inv_address(u64 address, size_t size)
+static inline u64 build_inv_address(u64 address, u64 last)
 {
-	u64 last = address + size - 1;
 	unsigned int sz_lg2;
 
 	address &= GENMASK_U64(63, 12);
@@ -1302,11 +1301,10 @@ static inline u64 build_inv_address(u64 address, size_t size)
 	return address | CMD_INV_IOMMU_PAGES_SIZE_MASK;
 }
 
-static void build_inv_iommu_pages(struct iommu_cmd *cmd, u64 address,
-				  size_t size, u16 domid,
-				  ioasid_t pasid, bool gn)
+static void build_inv_iommu_pages(struct iommu_cmd *cmd, u64 start, u64 last,
+				  u16 domid, ioasid_t pasid, bool gn)
 {
-	u64 inv_address = build_inv_address(address, size);
+	u64 inv_address = build_inv_address(start, last);
 
 	memset(cmd, 0, sizeof(*cmd));
 
@@ -1323,10 +1321,9 @@ static void build_inv_iommu_pages(struct iommu_cmd *cmd, u64 address,
 }
 
 static void build_inv_iotlb_pages(struct iommu_cmd *cmd, u16 devid, int qdep,
-				  u64 address, size_t size,
-				  ioasid_t pasid, bool gn)
+				  u64 start, u64 last, ioasid_t pasid, bool gn)
 {
-	u64 inv_address = build_inv_address(address, size);
+	u64 inv_address = build_inv_address(start, last);
 
 	memset(cmd, 0, sizeof(*cmd));
 
@@ -1524,7 +1521,7 @@ static void amd_iommu_flush_tlb_all(struct amd_iommu *iommu)
 
 	for (dom_id = 0; dom_id <= last_bdf; ++dom_id) {
 		struct iommu_cmd cmd;
-		build_inv_iommu_pages(&cmd, 0, CMD_INV_IOMMU_ALL_PAGES_ADDRESS,
+		build_inv_iommu_pages(&cmd, 0, U64_MAX,
 				      dom_id, IOMMU_NO_PASID, false);
 		iommu_queue_command(iommu, &cmd);
 	}
@@ -1536,14 +1533,15 @@ static void amd_iommu_flush_tlb_domid(struct amd_iommu *iommu, u32 dom_id)
 {
 	struct iommu_cmd cmd;
 
-	build_inv_iommu_pages(&cmd, 0, CMD_INV_IOMMU_ALL_PAGES_ADDRESS,
+	build_inv_iommu_pages(&cmd, 0, U64_MAX,
 			      dom_id, IOMMU_NO_PASID, false);
 	iommu_queue_command(iommu, &cmd);
 
 	iommu_completion_wait(iommu);
 }
 
-static int iommu_flush_pages_v1_hdom_ids(struct protection_domain *pdom, u64 address, size_t size)
+static int iommu_flush_pages_v1_hdom_ids(struct protection_domain *pdom,
+					 u64 start, u64 last)
 {
 	int ret = 0;
 	struct amd_iommu_viommu *aviommu;
@@ -1560,7 +1558,7 @@ static int iommu_flush_pages_v1_hdom_ids(struct protection_domain *pdom, u64 add
 
 			pr_debug("%s: iommu=%#x, hdom_id=%#x\n", __func__,
 				 iommu->devid, gdom_info->hdom_id);
-			build_inv_iommu_pages(&cmd, address, size, gdom_info->hdom_id,
+			build_inv_iommu_pages(&cmd, start, last, gdom_info->hdom_id,
 					      IOMMU_NO_PASID, false);
 			ret |= iommu_queue_command(iommu, &cmd);
 		}
@@ -1616,15 +1614,15 @@ void amd_iommu_flush_all_caches(struct amd_iommu *iommu)
 /*
  * Command send function for flushing on-device TLB
  */
-static int device_flush_iotlb(struct iommu_dev_data *dev_data, u64 address,
-			      size_t size, ioasid_t pasid, bool gn)
+static int device_flush_iotlb(struct iommu_dev_data *dev_data, u64 start,
+			      u64 last, ioasid_t pasid, bool gn)
 {
 	struct amd_iommu *iommu = get_amd_iommu_from_dev_data(dev_data);
 	struct iommu_cmd cmd;
 	int qdep = dev_data->ats_qdep;
 
-	build_inv_iotlb_pages(&cmd, dev_data->devid, qdep, address,
-			      size, pasid, gn);
+	build_inv_iotlb_pages(&cmd, dev_data->devid, qdep, start,
+			      last, pasid, gn);
 
 	return iommu_queue_command(iommu, &cmd);
 }
@@ -1668,15 +1666,15 @@ static int device_flush_dte(struct iommu_dev_data *dev_data)
 
 	if (dev_data->ats_enabled) {
 		/* Invalidate the entire contents of an IOTLB */
-		ret = device_flush_iotlb(dev_data, 0, ~0UL,
+		ret = device_flush_iotlb(dev_data, 0, U64_MAX,
 					 IOMMU_NO_PASID, false);
 	}
 
 	return ret;
 }
 
-static int domain_flush_pages_v2(struct protection_domain *pdom,
-				 u64 address, size_t size)
+static int domain_flush_pages_v2(struct protection_domain *pdom, u64 start,
+				 u64 last)
 {
 	struct iommu_dev_data *dev_data;
 	struct iommu_cmd cmd;
@@ -1687,7 +1685,7 @@ static int domain_flush_pages_v2(struct protection_domain *pdom,
 		struct amd_iommu *iommu = get_amd_iommu_from_dev(dev_data->dev);
 		u16 domid = dev_data->gcr3_info.domid;
 
-		build_inv_iommu_pages(&cmd, address, size,
+		build_inv_iommu_pages(&cmd, start, last,
 				      domid, IOMMU_NO_PASID, true);
 
 		ret |= iommu_queue_command(iommu, &cmd);
@@ -1696,8 +1694,8 @@ static int domain_flush_pages_v2(struct protection_domain *pdom,
 	return ret;
 }
 
-static int domain_flush_pages_v1(struct protection_domain *pdom,
-				 u64 address, size_t size)
+static int domain_flush_pages_v1(struct protection_domain *pdom, u64 start,
+				 u64 last)
 {
 	struct pdom_iommu_info *pdom_iommu_info;
 	struct iommu_cmd cmd;
@@ -1706,7 +1704,7 @@ static int domain_flush_pages_v1(struct protection_domain *pdom,
 
 	lockdep_assert_held(&pdom->lock);
 
-	build_inv_iommu_pages(&cmd, address, size,
+	build_inv_iommu_pages(&cmd, start, last,
 			      pdom->id, IOMMU_NO_PASID, false);
 
 	xa_for_each(&pdom->iommu_array, i, pdom_iommu_info) {
@@ -1726,7 +1724,7 @@ static int domain_flush_pages_v1(struct protection_domain *pdom,
 	 * See drivers/iommu/amd/nested.c: amd_iommu_alloc_domain_nested()
 	 */
 	if (!list_empty(&pdom->viommu_list))
-		ret |= iommu_flush_pages_v1_hdom_ids(pdom, address, size);
+		ret |= iommu_flush_pages_v1_hdom_ids(pdom, start, last);
 
 	return ret;
 }
@@ -1735,8 +1733,8 @@ static int domain_flush_pages_v1(struct protection_domain *pdom,
  * TLB invalidation function which is called from the mapping functions.
  * It flushes range of PTEs of the domain.
  */
-static void __domain_flush_pages(struct protection_domain *domain,
-				 u64 address, size_t size)
+static void __domain_flush_pages(struct protection_domain *domain, u64 start,
+				 u64 last)
 {
 	struct iommu_dev_data *dev_data;
 	int ret = 0;
@@ -1747,9 +1745,9 @@ static void __domain_flush_pages(struct protection_domain *domain,
 
 	if (pdom_is_v2_pgtbl_mode(domain)) {
 		gn = true;
-		ret = domain_flush_pages_v2(domain, address, size);
+		ret = domain_flush_pages_v2(domain, start, last);
 	} else {
-		ret = domain_flush_pages_v1(domain, address, size);
+		ret = domain_flush_pages_v1(domain, start, last);
 	}
 
 	list_for_each_entry(dev_data, &domain->dev_list, list) {
@@ -1757,7 +1755,7 @@ static void __domain_flush_pages(struct protection_domain *domain,
 		if (!dev_data->ats_enabled)
 			continue;
 
-		ret |= device_flush_iotlb(dev_data, address, size, pasid, gn);
+		ret |= device_flush_iotlb(dev_data, start, last, pasid, gn);
 	}
 
 	WARN_ON(ret);
@@ -1769,7 +1767,7 @@ void amd_iommu_domain_flush_pages(struct protection_domain *domain,
 	lockdep_assert_held(&domain->lock);
 
 	if (likely(!amd_iommu_np_cache)) {
-		__domain_flush_pages(domain, address, size);
+		__domain_flush_pages(domain, address, address + size - 1);
 
 		/* Wait until IOMMU TLB and all device IOTLB flushes are complete */
 		domain_flush_complete(domain);
@@ -1806,7 +1804,7 @@ void amd_iommu_domain_flush_pages(struct protection_domain *domain,
 
 		flush_size = 1ul << min_alignment;
 
-		__domain_flush_pages(domain, address, flush_size);
+		__domain_flush_pages(domain, address, address + flush_size - 1);
 		address += flush_size;
 		size -= flush_size;
 	}
@@ -1823,17 +1821,17 @@ static void amd_iommu_domain_flush_all(struct protection_domain *domain)
 }
 
 void amd_iommu_dev_flush_pasid_pages(struct iommu_dev_data *dev_data,
-				     ioasid_t pasid, u64 address, size_t size)
+				     ioasid_t pasid, u64 start, u64 last)
 {
 	struct iommu_cmd cmd;
 	struct amd_iommu *iommu = get_amd_iommu_from_dev(dev_data->dev);
 
-	build_inv_iommu_pages(&cmd, address, size,
+	build_inv_iommu_pages(&cmd, start, last,
 			      dev_data->gcr3_info.domid, pasid, true);
 	iommu_queue_command(iommu, &cmd);
 
 	if (dev_data->ats_enabled)
-		device_flush_iotlb(dev_data, address, size, pasid, true);
+		device_flush_iotlb(dev_data, start, last, pasid, true);
 
 	iommu_completion_wait(iommu);
 }
@@ -1841,8 +1839,7 @@ void amd_iommu_dev_flush_pasid_pages(struct iommu_dev_data *dev_data,
 static void dev_flush_pasid_all(struct iommu_dev_data *dev_data,
 				ioasid_t pasid)
 {
-	amd_iommu_dev_flush_pasid_pages(dev_data, pasid, 0,
-					CMD_INV_IOMMU_ALL_PAGES_ADDRESS);
+	amd_iommu_dev_flush_pasid_pages(dev_data, pasid, 0, U64_MAX);
 }
 
 int amd_iommu_complete_ppr(struct device *dev, u32 pasid, int status, int tag)
diff --git a/drivers/iommu/amd/pasid.c b/drivers/iommu/amd/pasid.c
index 67eace9809f16a..d708c6532480a4 100644
--- a/drivers/iommu/amd/pasid.c
+++ b/drivers/iommu/amd/pasid.c
@@ -71,7 +71,7 @@ static void sva_arch_invalidate_secondary_tlbs(struct mmu_notifier *mn,
 	for_each_pdom_dev_data(pdom_dev_data, sva_pdom) {
 		amd_iommu_dev_flush_pasid_pages(pdom_dev_data->dev_data,
 						pdom_dev_data->pasid,
-						start, end - start);
+						start, end - 1);
 	}
 
 	spin_unlock_irqrestore(&sva_pdom->lock, flags);
-- 
2.43.0

