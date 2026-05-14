Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011009.outbound.protection.outlook.com [40.107.208.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17B7B19046E;
	Thu, 14 May 2026 00:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778717498; cv=fail; b=Uim4yHOIJXogtSXjO/jhiNg/3S4k0P67TndOXZHfYOvNhD4nilfM0dmDKypK+qHERanQ7OmyyAagBiA/mKap9RL7cdLTaKYwItME9/YtR5mYypPukzk9ZTeCqVl605ylDjXEtfO6eIAsvjCvxpPqvsMuZGfRsIQ5hyS6Sf5cOok=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778717498; c=relaxed/simple;
	bh=gkZRiy4yRdk4MMA8dGcxsXxr2omQRRoiUi0EMJLxu5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RosYxjzDqMJfkpKJPkV+YRmvTsaqfAYIVyJqlb20i4LEf3vN8HjoSqYrFCnzggrcVhHaha3z4fUQQhcAIuMmClgXJhNFzQSxl3ZRFT4CwPMMNvVI2DDpS6niqaQ1tEaf4Hiu7Z6dcgdktXNy5z2loiCo1KDjklu4XvK+CYQNj6k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=E9BMyiny; arc=fail smtp.client-ip=40.107.208.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="E9BMyiny"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GvxQpvtmhZ/UtqBazxdezVVMHfHHWIblAPZbRXNOg3SnBukY8XCDZkmXIYSkEttD25XEyifMmD/C3ahXbueCZPrvGufUul0DHSEgaEVLUKgqqU9HQOoO6EWsHzOR2jtAp2APlDTND456gC1ud53Qq1cb2YH9GxRBbehvzXXLbVHW4LL4qY0sLJlVJU10xqpVJ+UXNLsRUzy7fbPnwEHBwqNPzylJm09J8tKYnEdPNYE+8ka0pxia2kVp5UwwnmpWfbtjeK3NdD7wSqYD01hvt67VMG6PpqsrVnJKsKr6fvMaZhmTOGZdLMfCYAaMA6aRrllt6KndDtw7a+YQLAiGfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X+Zuykun2KdCKkToETIvXMDWKGUcFEiJQXJf+KpuIZA=;
 b=FHF0v/ZtBVzLAWdJDLhw2rSWSu4dB8k59qhfgg5jvCXG+sNpsO3pw4HMRIqIe6m8rf+wxdOvZTpRA5svkD9Rpk9clcwSz7WbksMuT9Xx1Y/4PqAOp+APqdB1AcIKwN8ofsPLDAuIibevJRWG2Q7quhyh/07CBE/6dHru84T8yw2dRDKjY4uRRHu2fLvTCQudWYfYC1/uKVt6V10ZSIIN77v2GAs8hOXuHCObkpI1DwaNw7dkz+EqNgggItRdVXu+HfWeUaeoKm5fmQxu+5W60PIMTMc2FPW4U51WTvvOLduM5gLIp0fFo7aD2m9IJpNZokfNA/UTxGlW58neW37HYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X+Zuykun2KdCKkToETIvXMDWKGUcFEiJQXJf+KpuIZA=;
 b=E9BMyinyAmKBM3YrEmFUUfO1LNRBD/OALda5T69b2wYWBddex1e5bLu1b4wx17fVRNSEuyKRbV6gsKRWgGIOP1sdAk1pIXCVPNUAWgEK60DLADjFJkAzBDdFXTprJ/IGgOisXCxbxrhmXxTPIYSBbtmnIJyIBj7yYoH2FxBWxVyNpodzNBCedxITAJ7T3Rbr35AeR2X07MSLaaGzzcpkB6mxHwN1Bw3P5fog2X84F4X2mxd1qSNGKl3t0n3cjHkfPKQTjEZB+Qse5ECY5hn5NOZopct/l+Cqo+7EgZd+aZAyoaqAkyBTmOV/j7+H92DyROFccDjR1v/zsBOFnlMHPQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SA3PR12MB8764.namprd12.prod.outlook.com (2603:10b6:806:317::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.11; Thu, 14 May
 2026 00:11:27 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9913.009; Thu, 14 May 2026
 00:11:27 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>
Cc: patches@lists.linux.dev,
	Wei Wang <wei.w.wang@hotmail.com>
Subject: [PATCH v3 2/5] iommu/amd: Pass last in through to build_inv_address()
Date: Wed, 13 May 2026 21:11:17 -0300
Message-ID: <2-v3-233e3af938b7+f1-iommupt_inv_amd_jgg@nvidia.com>
In-Reply-To: <0-v3-233e3af938b7+f1-iommupt_inv_amd_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4P288CA0027.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d3::6) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SA3PR12MB8764:EE_
X-MS-Office365-Filtering-Correlation-Id: 397bd9ee-c586-44b9-c483-08deb14d5464
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|11063799003|22082099003|56012099003|3613699012|18002099003;
X-Microsoft-Antispam-Message-Info:
	I9AHfl6qRN/lQpDgu0RovImkU6bopK4OfECQKjFddYqXXPsgOq1YMO6dypst6TB8fNrXOO27xvKbPvz/zIRXnKklvJ3KROdqvM08KWRVWLPJ2ek/QwMgP5JToHy3PtmII0hp8OjA8YH62eE5pjrkQN7bPSr02EUrv2Kj38YiKSmYkK0tb5fStNWK41OGXskbjwLf1PJ4upEKF64VHBJFufmEznRWqc8pYiImoqeGbp1jL+RTEJ6SqYsa5RQoBLkuf+WK528/6LWSHsseP0LCd6ZBw5z5DElWOcRlMw4QPovUOSpzP5zDW5UmlSbnaujk8q4NIc8CQ/ZnI22PFkEf7j6p6Z29pEH2QJU0Il12gFqR45I8xnlxMQlDDjARb4QjW72TKoDndzBKoEz6cX4j+6VZGR9kaZWWI7gdMPKYBXqYjwMnYHisbHA3qup2+jEFSM9kU0BxG7MHmzFOpeCsyE3Ja66+sE2Ch6oFwOx5bsFGGfmjwQPaq50DE1qD4SyH9UsFzAn/nCrj9MZYSq/rugsdZ/kQhcNk3lNZNz+VMgTpfCqRlA79QSuSJ342cIkxETHPKmKhjugwlG3H20TE0Jh2vHZ7N6L6jpNs5v1psEi8iukbWpcZkANYi/BvAhQJaW2l9YZDHdMWt6NyauWgw4Jk8PsWUe/MGSrcMar9W4mBEzU/LbpAx9GV6YIXca89itKcgYGbolXCgwTsbRrsSzmWItH38OhN5dU3u6bra1h3pj1A58kAKlO3JmIMB8UT
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(11063799003)(22082099003)(56012099003)(3613699012)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ySxA+93PZ39TRrJaDbD1xUGpXhTf4p5F2TzlQcqzvARoFCnuAq7EBRLqM+j+?=
 =?us-ascii?Q?bzF7BEs69wDaGkivnXQQePB2YB3niogTAe3kaMzm0i4L7zNbYR8GCGlIBz3u?=
 =?us-ascii?Q?oU/Ilooc0wbf6ubxrUJbQoGh8ae/FUP+lo/tNqDuDu+1bgxskNDyJPbLpSgt?=
 =?us-ascii?Q?QK7lGT8OKREvrFliBlj/uXf+/IHp8Pyb0dziruoT/4Nl0W2G3NvUHFLEIuq7?=
 =?us-ascii?Q?LFvHM7z2JRMEe1oDsI0lhaDmgEXDTMufp7DoLDvY7zXaYqOfR8PWXiDdbQvh?=
 =?us-ascii?Q?wyeSaRN0bTrTvlHEBCoWK5veibQa/XxWn7vscacyxrRk08x3cDXcQojTcgSB?=
 =?us-ascii?Q?v1GRIa+ariZ1nNzC43YXwWy7fdM8iPfaCPDoIJgezm0Svs6OglXMz6w2dBxD?=
 =?us-ascii?Q?5m+XA6Q1m0KelP7n+4X+xPjB5gMaA9BtRgnzQW2kmmFr5su0yW+bkR3Ltb6J?=
 =?us-ascii?Q?pL24o8JFghfdwkdJGUoRe7BEi7yGQgESTfqS9TwVWOFIvfVMuUCFvrsEs/ZF?=
 =?us-ascii?Q?D0xwWFFG2kFwyH1U5j1nY+UN4kR/0iZfa5ohUgxdVaAM98kMVDSMpYeeHPUm?=
 =?us-ascii?Q?RepRa6+RPuomXn9uOACOQ8JjVgH/89GlKFX40SHINXAVuNMWJSUCrcHwLC4R?=
 =?us-ascii?Q?lytn4gTnbT46Tl8Vp9JTlMaocYFna5kxy3vAfhbm16S/gK+zsLbZIWsar12i?=
 =?us-ascii?Q?Dn9H+1DxkD0DaPvrzCQMZlOLnElf2aLlbPN+KkIk2W1+jnoPdSu9pqx2Nkvi?=
 =?us-ascii?Q?ELdH+cj8SeInHe/EASuQvqlUnOsn+48/n84YL+QwSCTZemML4t81KGS8/I+o?=
 =?us-ascii?Q?ZvetMWAZi51kMJ28GNvWOoae58ThMPGphLCkXtU7cwTq1A+7nbT6CXahawjk?=
 =?us-ascii?Q?NHFzrr8A8v5efMz3Iv6Lmocn+sgc32+PQ5BB1Dy/tttggS7/qY7a/AfRyVCG?=
 =?us-ascii?Q?3yUgeZHfjoBqqidLrlfLbJa31K1kOR3jKq9yph1RwOSYxOCSEa9x/DQf6ObQ?=
 =?us-ascii?Q?BdgQ2oNi2h9ODADc53YmTt5Qdh8ak1StwWXRW/2YXXbFNfxGOM4L2u0hYdJh?=
 =?us-ascii?Q?sFJSrcSCC5pCordcGmAX+jMG2VfnzFEr0v+39o8viH99TWYpOaCCayxTQXKL?=
 =?us-ascii?Q?fkkNrc2dK2HzGRVVpXakziszbHfuwjoRAgxZlitEPJGu1gDN6NaBXz28VwXp?=
 =?us-ascii?Q?K8lDD302l2Ih3cQl0w62vPDsM4mcnT6PqCwVC4Z2MUiWqGfD+xppGlZJbVLl?=
 =?us-ascii?Q?wqPz3jjXYrzLnGlqVi9SLE51bpcuRSJRm3uO7Ef9ppWHAJ+zLxYNnhn67N1t?=
 =?us-ascii?Q?F21k+4zrTLJz5SfBa0fkSvVRCl092zVMlZedKz++kBr3hj6iy9RDdd6J5R9b?=
 =?us-ascii?Q?Up63UKqQ3YaJKX9u31bPreGwp+5DnMTOX5Sv1f786QJ8Y7ImfGdsBn0YkekZ?=
 =?us-ascii?Q?nCCimLOKUtdHg/e+U5LXCwuzx5zSj2F5xiz2qIvYtamF3q9BNTwS/diJqeEr?=
 =?us-ascii?Q?g0eUJ12pZvMptR8DiBN8BsW1tUClcdnwbKslAZcExN8RxAUZJ9iu2CJ+mOGE?=
 =?us-ascii?Q?Otk6O1EdoJ1w4BWtRAaOhy5wup6/TziAXDbvxrkS4oPycjpvUdU6eRozkSug?=
 =?us-ascii?Q?EeSfO2thFMRqyRW7DY3STdBbmCv6EG6iWO0lR8wTU0oo5yqg0XJt3T7N+Pd/?=
 =?us-ascii?Q?g/5wtd/T04oAa4tScDPOu4VsWycS432WlivZmqTYZ/vH8niN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 397bd9ee-c586-44b9-c483-08deb14d5464
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2026 00:11:22.1171
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k00mPs6RwmH6NywEY0QqOchI6iclExieuNp/LumhZMsCxBKhLG9059jmRwS4U3gX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8764

This is the trivial call chain below amd_iommu_domain_flush_pages().

Cases that are doing a full invalidate will pass a last of U64_MAX.

This avoids converting between size and last, and type confusion with
size_t, unsigned long and u64 all being used in different places along
the driver's invalidation path. Consistently use u64 in the internals.

Reviewed-by: Wei Wang <wei.w.wang@hotmail.com>
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
index 24374c8aa853af..52b91831c73e67 100644
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
@@ -1301,11 +1300,10 @@ static inline u64 build_inv_address(u64 address, size_t size)
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
 
@@ -1322,10 +1320,9 @@ static void build_inv_iommu_pages(struct iommu_cmd *cmd, u64 address,
 }
 
 static void build_inv_iotlb_pages(struct iommu_cmd *cmd, u16 devid, int qdep,
-				  u64 address, size_t size,
-				  ioasid_t pasid, bool gn)
+				  u64 start, u64 last, ioasid_t pasid, bool gn)
 {
-	u64 inv_address = build_inv_address(address, size);
+	u64 inv_address = build_inv_address(start, last);
 
 	memset(cmd, 0, sizeof(*cmd));
 
@@ -1523,7 +1520,7 @@ static void amd_iommu_flush_tlb_all(struct amd_iommu *iommu)
 
 	for (dom_id = 0; dom_id <= last_bdf; ++dom_id) {
 		struct iommu_cmd cmd;
-		build_inv_iommu_pages(&cmd, 0, CMD_INV_IOMMU_ALL_PAGES_ADDRESS,
+		build_inv_iommu_pages(&cmd, 0, U64_MAX,
 				      dom_id, IOMMU_NO_PASID, false);
 		iommu_queue_command(iommu, &cmd);
 	}
@@ -1535,14 +1532,15 @@ static void amd_iommu_flush_tlb_domid(struct amd_iommu *iommu, u32 dom_id)
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
@@ -1559,7 +1557,7 @@ static int iommu_flush_pages_v1_hdom_ids(struct protection_domain *pdom, u64 add
 
 			pr_debug("%s: iommu=%#x, hdom_id=%#x\n", __func__,
 				 iommu->devid, gdom_info->hdom_id);
-			build_inv_iommu_pages(&cmd, address, size, gdom_info->hdom_id,
+			build_inv_iommu_pages(&cmd, start, last, gdom_info->hdom_id,
 					      IOMMU_NO_PASID, false);
 			ret |= iommu_queue_command(iommu, &cmd);
 		}
@@ -1615,15 +1613,15 @@ void amd_iommu_flush_all_caches(struct amd_iommu *iommu)
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
@@ -1667,15 +1665,15 @@ static int device_flush_dte(struct iommu_dev_data *dev_data)
 
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
@@ -1686,7 +1684,7 @@ static int domain_flush_pages_v2(struct protection_domain *pdom,
 		struct amd_iommu *iommu = get_amd_iommu_from_dev(dev_data->dev);
 		u16 domid = dev_data->gcr3_info.domid;
 
-		build_inv_iommu_pages(&cmd, address, size,
+		build_inv_iommu_pages(&cmd, start, last,
 				      domid, IOMMU_NO_PASID, true);
 
 		ret |= iommu_queue_command(iommu, &cmd);
@@ -1695,8 +1693,8 @@ static int domain_flush_pages_v2(struct protection_domain *pdom,
 	return ret;
 }
 
-static int domain_flush_pages_v1(struct protection_domain *pdom,
-				 u64 address, size_t size)
+static int domain_flush_pages_v1(struct protection_domain *pdom, u64 start,
+				 u64 last)
 {
 	struct pdom_iommu_info *pdom_iommu_info;
 	struct iommu_cmd cmd;
@@ -1705,7 +1703,7 @@ static int domain_flush_pages_v1(struct protection_domain *pdom,
 
 	lockdep_assert_held(&pdom->lock);
 
-	build_inv_iommu_pages(&cmd, address, size,
+	build_inv_iommu_pages(&cmd, start, last,
 			      pdom->id, IOMMU_NO_PASID, false);
 
 	xa_for_each(&pdom->iommu_array, i, pdom_iommu_info) {
@@ -1725,7 +1723,7 @@ static int domain_flush_pages_v1(struct protection_domain *pdom,
 	 * See drivers/iommu/amd/nested.c: amd_iommu_alloc_domain_nested()
 	 */
 	if (!list_empty(&pdom->viommu_list))
-		ret |= iommu_flush_pages_v1_hdom_ids(pdom, address, size);
+		ret |= iommu_flush_pages_v1_hdom_ids(pdom, start, last);
 
 	return ret;
 }
@@ -1734,8 +1732,8 @@ static int domain_flush_pages_v1(struct protection_domain *pdom,
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
@@ -1746,9 +1744,9 @@ static void __domain_flush_pages(struct protection_domain *domain,
 
 	if (pdom_is_v2_pgtbl_mode(domain)) {
 		gn = true;
-		ret = domain_flush_pages_v2(domain, address, size);
+		ret = domain_flush_pages_v2(domain, start, last);
 	} else {
-		ret = domain_flush_pages_v1(domain, address, size);
+		ret = domain_flush_pages_v1(domain, start, last);
 	}
 
 	list_for_each_entry(dev_data, &domain->dev_list, list) {
@@ -1756,7 +1754,7 @@ static void __domain_flush_pages(struct protection_domain *domain,
 		if (!dev_data->ats_enabled)
 			continue;
 
-		ret |= device_flush_iotlb(dev_data, address, size, pasid, gn);
+		ret |= device_flush_iotlb(dev_data, start, last, pasid, gn);
 	}
 
 	WARN_ON(ret);
@@ -1768,7 +1766,7 @@ void amd_iommu_domain_flush_pages(struct protection_domain *domain,
 	lockdep_assert_held(&domain->lock);
 
 	if (likely(!amd_iommu_np_cache)) {
-		__domain_flush_pages(domain, address, size);
+		__domain_flush_pages(domain, address, address + size - 1);
 
 		/* Wait until IOMMU TLB and all device IOTLB flushes are complete */
 		domain_flush_complete(domain);
@@ -1805,7 +1803,7 @@ void amd_iommu_domain_flush_pages(struct protection_domain *domain,
 
 		flush_size = 1ul << min_alignment;
 
-		__domain_flush_pages(domain, address, flush_size);
+		__domain_flush_pages(domain, address, address + flush_size - 1);
 		address += flush_size;
 		size -= flush_size;
 	}
@@ -1822,17 +1820,17 @@ static void amd_iommu_domain_flush_all(struct protection_domain *domain)
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
@@ -1840,8 +1838,7 @@ void amd_iommu_dev_flush_pasid_pages(struct iommu_dev_data *dev_data,
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

