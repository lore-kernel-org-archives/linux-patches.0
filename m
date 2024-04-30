Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2068.outbound.protection.outlook.com [40.107.94.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3924C17F36D;
	Tue, 30 Apr 2024 17:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714497712; cv=fail; b=Dk4CRBEJrs3ZESQ6N+QL4sWXLePBWE051n7mNd+aOAlNlL8AeR8lam6uuP4SJFmyIQYg3uE8GHwM5Hp7eCjmbtnxvyP4GBpMxoXg+1ExBO/thcI1LHN1cY5TUSrL1aDascFTJ3jx3nxSrHa9HHv6YZxNivRt+KRzrSGnxCfdfRI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714497712; c=relaxed/simple;
	bh=QYPzpanq0kqjTYLyjgbKKDeam5xWzzAtGNZbJLliLy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QviCCpOh0FMR+lH0aAZ8x6KaZu+tztXYtusZReYGmWh1+CNTMS/eJhbNm6bK+7sI1zXCVBiHwlcoBBMTSKr5kAZbzqVf93H8q1KbQSN2GIAbD1dCpy36ZlKBQg7xpEZ4mj4omPVH+WakXI7TU43e1UpFRq3+l1QuZG3K1ZAOUws=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=RM+p3eKt; arc=fail smtp.client-ip=40.107.94.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="RM+p3eKt"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DQJ8koSpISrKyCRtXiUgPlYHVhKKk/Pgoi1ZjF19tvas/+mS185AFCl3foLDpEfrufatywSh2yKCPwqz07y8x/6tbhnimamcWKYwXbqun2Th0g5GjiVI2+eDcYLvOKmgu0XIaEF6fquAxezLjs/GxdL3PZ7if7SJLG2HjiQ7lIF0EFbnoPyMwct362h89UwfE3quL2Ouw4t4Pcb8YSy/nHbc2EUDdJgBbpXB4QKWnAnpUTwksVbpj1hhfaiW2M68HR33wm/6yDzhW1KVgaC845ZUYhCY6+ahsKjfwmnz3p1CPLHXtKWpIlA0zsBDZHoc2aAmaC3h1vBKDsaZsGqZ9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P/d8Ky9DmRDFyDlbnkO/237pszRuKBySk7B1YH+zJ4k=;
 b=b8aT6zU43Ssx75CmcS5HEBpuNCBRCJSLpZiLB7ivJLyvM782cFBxSZ3uv+Au7r88Djk5fRYgktOF/kYJsstNXwaxyF8LsBOffizNCZ8MD/GCcNF4L3Wh4uVAoqJisFxELcu1rh0TLfeeU5G/mQRjudZcIc0QjwS/mRE8MoDMWm7Rl4Y5LbTv5baSg/e1X5NMCrnZR5Q4BRZ2ImL0onGS8WkvSeIsJokj6wl91BLIpssGbp6l/To8hbXl+uma1yC7R4QAsz0TWw3B14lw/pYa4xjtlSIKZXLseL1+u8ePVQtPhW6B6tAmYJxINnVQqf54OLuBfe5k8yT+UO9DGEvVWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P/d8Ky9DmRDFyDlbnkO/237pszRuKBySk7B1YH+zJ4k=;
 b=RM+p3eKt6gUvLmV+iuMePH5gfEyIOMarhLjlzvQVkBzwLQBk18u/JAyyJqlYQ97doTBMGyUoQJRo17i32oUZuFOUuAtmAmrcB4gQuBKMb7ZGz8+SprCdgpmlufXaZulwwoL2s4QOGoRDeot09d4R9L5ykn97VkcrvF/ZB7ooH+iqXifKO+pxda1WGz5hBMgT2stc8N0fDJf+DyeE1XZ1hzoL39qH5YXVDYohgAM9GjC/pO1RYt6bm4EtHRIr/OdHPTpZhdRZ7TrwJf1Fz7f0uKWmOnTb2jA42wYoL7fmv8M6CFxdIM+OUy0GbxqTwpnbClC+be0wfcsYMoMUamchRg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by DM6PR12MB4172.namprd12.prod.outlook.com (2603:10b6:5:212::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.35; Tue, 30 Apr
 2024 17:21:44 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%3]) with mapi id 15.20.7519.031; Tue, 30 Apr 2024
 17:21:44 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>,
	Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v9 4/9] iommu/arm-smmu-v3: Consolidate clearing a CD table entry
Date: Tue, 30 Apr 2024 14:21:36 -0300
Message-ID: <4-v9-5040dc602008+177d7-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v9-5040dc602008+177d7-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0406.namprd13.prod.outlook.com
 (2603:10b6:208:2c2::21) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|DM6PR12MB4172:EE_
X-MS-Office365-Filtering-Correlation-Id: 779c15cd-762e-41d8-63d3-08dc693a0139
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|376005|7416005|366007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ZNSHxggfTw2zKB2AbEMoI2CVimDjDcf0h08XCzloDNsqav1iy5WwT4nE041E?=
 =?us-ascii?Q?kd4ifnEm7q/d+LmLjFD+uoYatsD4P5P7DvPpzt+aEZt3w94IYfCEc7kwUYbU?=
 =?us-ascii?Q?SaLh3MjH77IOV1bPLN2xRE3gXdhMFRy+tUCsgPuTicfVuajZHB503frj8lL4?=
 =?us-ascii?Q?yrhK+HJqvrVUSmibu5E1CYf9ayXOjnovRGq0kc0Nnp0vULNKraEI6keUlYEm?=
 =?us-ascii?Q?Z10H3jP5Hu14kjoSkPf3HewrJqha7Pb2ocz7bIqmcwHbm5QQ11EvDa8kTGlZ?=
 =?us-ascii?Q?vECGGjsD+ypKpTe3eR9uohc9jWVsxnU/Y0v3yqlj+b8wKkvFp82BtTYxqhn1?=
 =?us-ascii?Q?Pa4Wo07Oe81an1JyqlTtIEIO89DyUboQ0tira5QkBu9smzE3l5IWKLgCe2Sj?=
 =?us-ascii?Q?3D0jqCR5gpwrC5l7n3Yahnl858KXLpNUcs0lQ6A7e8xAQhIn54Xaqv+/6tuc?=
 =?us-ascii?Q?4QoFmERiWmpvUE7nEtmCB3ipgTbEDTzJH647PrGVVTkTYK6atFRQHnhHrzCs?=
 =?us-ascii?Q?TSlU7ZbGB78v7Txu5qTvxuU1E6Y/E+A7fSbpER4dUWz7BJLd309jCQiGDQxF?=
 =?us-ascii?Q?1vCJnkDP/sZVHctf/+iEAYLJA/hCd1nfYYYLZys1U1aiM/xNDjQ4+kswGszD?=
 =?us-ascii?Q?64hJAgk4E5yyF4S/3pb/8agmyo1FBRd1t6Rj6jzJYqI8jMorrwFTlFwsfP13?=
 =?us-ascii?Q?tMmpXd/YNSzomqfOip2LJzkZyUq1bcAwlXXu1o7ZDSTqKa602iAMv+M16sSN?=
 =?us-ascii?Q?V20ytP0EDBEmnqnlFU5+w2aCX0mCo6H7732gsHuQCH2SeP4JefjqBK4rIeBZ?=
 =?us-ascii?Q?4v7u4/q3RhwRj9EoiYx//mxb7WS1km8bD0g06CdickNH8cFbXV1+9oZVFYQx?=
 =?us-ascii?Q?1gSOJr5XOerO7wO+cTbQEz6pZFsHBMmv2uROzECvRSHj0BItx+BEtKJzkalx?=
 =?us-ascii?Q?ymTqIbUFnBhDkqiBjfjDAaOeCblhxOQtqtDJmhmRpla+DTZ0duwqAW21E1qU?=
 =?us-ascii?Q?+QcXnbwRSFhalrU8vvuG7MDgK+YRJdaxFg9+2d9hhs6t/nuTzf6V23Ha1sau?=
 =?us-ascii?Q?6frur4wZb9mdsmpZYZt5T07uEteUbUu3MelxOS32nOb/2+xpdBULco88XQrh?=
 =?us-ascii?Q?76uYbE5BTqadBdshEWyLcJLD9x9g+6lE7pJaFM5j6MxeCZqjYTq/tCXPBDCM?=
 =?us-ascii?Q?r2sOZSMTyl+OT/c2KejipRyJ9sOIXm7TZmS0QFUpiINlKWjyMa5cFQZ1FlDz?=
 =?us-ascii?Q?oQlZo9pPDMGgpeW379eCXcuOxnbYBl/3/1T7xIYJUw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(7416005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vL+SNgp+vmyEyZ4zrFMzf9HUEOyF8YTrIzFL274eU+IiqYVceBqHYnFgb6ZY?=
 =?us-ascii?Q?uJwioubXYBHftzCR+RSI2nOlQsKizznROrHEDyAjhpYwfRBQtIKJ8i9uqxSq?=
 =?us-ascii?Q?bunCNotSFIWsXUwz22MvIU7iznLKFAfy8hstzWZfYbyvG4MGQdmmr5WZelU6?=
 =?us-ascii?Q?94od6RGhJ9viLQ7pfi8j+gWYuAZEZmCw75DHQa5dQ+hH5f1LKxrCJ1KST8lm?=
 =?us-ascii?Q?pnpqwSITRS5gDDj9yqVKQ+aAGFUwMSVZbo7Hj+i8IkpqCNEg4pUSj4REvH/w?=
 =?us-ascii?Q?gLkdt4KQzfy+yJFWSJCaS7V+RaGMuJBvHVfhl1XCBqMzBiCeTD0yxXP4YURQ?=
 =?us-ascii?Q?MxuarPRVEJLzr4uKHky5x+lXLKWjY3R6BwW0OW3JKvLZaZQVrO7Gf+JuIo4L?=
 =?us-ascii?Q?Wz8oCne7TeY7CRiBMyFBFQgqMP+G1coyYTFMsow5i5d7kFa5Jb6RcQ/2vZxi?=
 =?us-ascii?Q?WVWVtraBYWPZk+paELnHas1K9bvwDBrkjKLKtuBldW310lR3aOXk+GVeARgf?=
 =?us-ascii?Q?vSVHEafJ6Skl/BQUXHm2FmRcae7szoxpADTyoFz5Oe/5dYxMCpIMhSxTWx/B?=
 =?us-ascii?Q?61qg7pMjHLsNKCLbnQy8hq327SB1E2aGJq4Xv7sPIdHUg847ESkQmc/7sowg?=
 =?us-ascii?Q?bsMhzMcZ5+2PL8X2f7jVbPCWvEssou6kyuOnsQMhmocXZVOUwpxgh3R8F9b1?=
 =?us-ascii?Q?y1zBthr1Xy1YDZLqb1a1zVrenQMWseuz5YJu+9NAiKdenGeW+H6jZ6wiJY7a?=
 =?us-ascii?Q?niIHuLAwv65JOAJbFVvVF8TbmWL2l7hezqlD8ERoxhPFAq+Nq2MNx7XbkbGp?=
 =?us-ascii?Q?bgGt4QY41801YXVxzr3FYoqw6I0SPD1J+uFoBeTZ3fFaHzNJxsU2JUPRWCHh?=
 =?us-ascii?Q?hGz1E1Fp3uiIfWPuWUVyTrOLjj5WKtbaHz3Qpgk6mKJ0Ux52V/+UD5ATKSKk?=
 =?us-ascii?Q?u4vKO4LVu916CGYpIT2MwMU6+VyfHpP9rNXogiJQfQHBGFwNFeYYB44H5qMQ?=
 =?us-ascii?Q?wd5/ZXYOChrFI/jqK+qBV9MaXtUg9VWXORX0eHTAXa1Dh+HsuCPbtkTYkZuM?=
 =?us-ascii?Q?KKZ+1as6gDZTlHkFNmKOj64Rv/8o+zVGrjE2QfJR2HPs9KWozxNMSNzlp9Go?=
 =?us-ascii?Q?TEZumbVNcVTET2ox+N2EAf+ZTyUMlMWPN8VTt4vtMtFYyy2Y5VoDv32fp4tu?=
 =?us-ascii?Q?St4uLasRWVEhZU2VrMqf9S78ekFyWsgymBtOBqr5wKNCzFs0L++o1agilHyY?=
 =?us-ascii?Q?M10EDB9VmMj/s+MBsm/3zCkm+YMIqGnb6pyN+Vp6SfAtAXzhaRH4W6D3nYpo?=
 =?us-ascii?Q?Ix4ecUNBKBRir7bfOEQVjq/Havik01Gaq6r4aeN6P6BwJs7acQyN4exi6/WW?=
 =?us-ascii?Q?MnxEpHB07pWMwWW/OQn+AkWOBQH5tgrFrQXN724TSSlm18ovpoNZ632buiqA?=
 =?us-ascii?Q?j7CYefvhJI7Hrge3YE2YIc236dhb+i03RVYkewjfFzr5P3TztkL5CSPavEyN?=
 =?us-ascii?Q?LVZjY6XONL1DH7+Ns/vUgYQEUq1R0m98QRA50fgMTBeUikjijKDolVGIIcA4?=
 =?us-ascii?Q?RlfSBPEBVwWAQ14qdv5LYMvEWLUI1zZP41EsY200?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 779c15cd-762e-41d8-63d3-08dc693a0139
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2024 17:21:43.1211
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i6Z3ItqZLtGz2v3OGehi+hfyvj9l8FCUPI/163JP8oD06JGoSBB3AzJRr0Te1Sbk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4172

A cleared entry is all 0's. Make arm_smmu_clear_cd() do this sequence.

If we are clearing an entry and for some reason it is not already
allocated in the CD table then something has gone wrong.

Remove case (5) from arm_smmu_write_ctx_desc().

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Reviewed-by: Michael Shavit <mshavit@google.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Moritz Fischer <moritzf@google.com>
Reviewed-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |  2 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 26 ++++++++++++-------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  1 +
 3 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index d159f60480935e..7cf286f7a009fb 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -569,7 +569,7 @@ void arm_smmu_sva_remove_dev_pasid(struct iommu_domain *domain,
 
 	mutex_lock(&sva_lock);
 
-	arm_smmu_write_ctx_desc(master, id, NULL);
+	arm_smmu_clear_cd(master, id);
 
 	list_for_each_entry(t, &master->bonds, list) {
 		if (t->mm == mm) {
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index a80758d72d6a7b..8a6c8aa247eb38 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1310,6 +1310,19 @@ void arm_smmu_make_s1_cd(struct arm_smmu_cd *target,
 	target->data[3] = cpu_to_le64(cd->mair);
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
 static void arm_smmu_clean_cd_entry(struct arm_smmu_cd *target)
 {
 	struct arm_smmu_cd used = {};
@@ -1330,7 +1343,6 @@ int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
 	 * (2) Install a secondary CD, for SID+SSID traffic.
 	 * (4) Quiesce the context without clearing the valid bit. Disable
 	 *     translation, and ignore any translation fault.
-	 * (5) Remove a secondary CD.
 	 */
 	u64 val;
 	struct arm_smmu_cd target;
@@ -1349,10 +1361,7 @@ int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
 	target = *cd_table_entry;
 	val = le64_to_cpu(cdptr->data[0]);
 
-	if (!cd) { /* (5) */
-		memset(cdptr, 0, sizeof(*cdptr));
-		val = 0;
-	} else if (cd == &quiet_cd) { /* (4) */
+	if (cd == &quiet_cd) { /* (4) */
 		val &= ~(CTXDESC_CD_0_TCR_T0SZ | CTXDESC_CD_0_TCR_TG0 |
 			 CTXDESC_CD_0_TCR_IRGN0 | CTXDESC_CD_0_TCR_ORGN0 |
 			 CTXDESC_CD_0_TCR_SH0);
@@ -2684,9 +2693,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	case ARM_SMMU_DOMAIN_S2:
 		arm_smmu_make_s2_domain_ste(&target, master, smmu_domain);
 		arm_smmu_install_ste_for_dev(master, &target);
-		if (master->cd_table.cdtab)
-			arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID,
-						      NULL);
+		arm_smmu_clear_cd(master, IOMMU_NO_PASID);
 		break;
 	}
 
@@ -2734,8 +2741,7 @@ static int arm_smmu_attach_dev_ste(struct device *dev,
 	 * arm_smmu_domain->devices to avoid races updating the same context
 	 * descriptor from arm_smmu_share_asid().
 	 */
-	if (master->cd_table.cdtab)
-		arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID, NULL);
+	arm_smmu_clear_cd(master, IOMMU_NO_PASID);
 	return 0;
 }
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index bb08f087ba39e4..99fd6f24caa818 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -751,6 +751,7 @@ extern struct xarray arm_smmu_asid_xa;
 extern struct mutex arm_smmu_asid_lock;
 extern struct arm_smmu_ctx_desc quiet_cd;
 
+void arm_smmu_clear_cd(struct arm_smmu_master *master, ioasid_t ssid);
 struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
 					u32 ssid);
 void arm_smmu_make_s1_cd(struct arm_smmu_cd *target,
-- 
2.43.2

