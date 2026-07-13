Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012019.outbound.protection.outlook.com [52.101.43.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 726D329B228;
	Mon, 13 Jul 2026 17:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783963518; cv=fail; b=eNgR89wTPV1vH9wwHDDjo6JFS35cO3F4RmtoKc1BvOZswxRi498xsFp8EToYnezxYTvf8R5mN2+7Mkr8bxVM+wl68h2jJyyzh0R58E5CaSa8wnj0OY+yTp9K7EO5UlNnSKNGCpfY1GFI5ItretPoyfmK72rXu3A4q9Gq1+81ESI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783963518; c=relaxed/simple;
	bh=soE+Pa13zPBgnSbctbpLjCv9my4UIzuSlpEYtZxqz7E=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=GEZrDuTtgH0gAbIqkLokcrgLzFUbJCdV7HNUDWzHZyzuUvPEpSMc4olU6cFwJeoYgfUx4dRsdflXllg0lvzeoNeR8p2qCeXmIpZW4Bt8IGQF0oDXh31iWXqpYquoTQ/xqh9pMmDXicrI/Il6zfF20RlozhdVr6fDCcIgmGvRqWA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Rw/oGnYU; arc=fail smtp.client-ip=52.101.43.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Rw/oGnYU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fMhdtccCHp3bopKdR9kp1qmDeXFBJzeKb8nQH89ho6vUfsiz0H9AEFkcoAW9wclmC8DZus+m/2hJlRCvR1ofLV4OPWDEcB4OA5eDvJTMNd+hYE+ctuhIYLXIa2JUCDzAr3jlHzgtPZLZ1kO0qRScdB9TFDDMjO8qubQ633S6mRpHvo/BVR2ZymNjIsQ/CTVtFqUdN/ZXXnCoAxCL6dGxy9r7rq/lXSsFdKnAkdu3EAq92/3cdeSx62c9I7+R18TANom9mVnZqDcuKEc8eQc6IBZmGxUTCGR6sjFPxN8YdzItitQIra1iplCogVRTRB4rFZgA1Yw4qa9jbOueKje8XQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DGJxx2bRcJUDxVEkp3hfa5ii8g69qsLpPdt49nPoAGE=;
 b=JkiwMLkUikbHvFO/mtADcRwzpUHrbr6Z9jkajnBv2DxX4Tv6ImB0rn4U4QvVPXkj0mmnc8yLKRTeGTaLtR5SxHjc77Cr5Wf9hRBDkK04mR/8p+euJlOMG1hj+kCk6VL0RFkVdZpaTo8odj0DA2ZOpRylE6LGKjqA4TKiaufeZc/vrRMuOYlRn93ZU3c5i0V+kcixS2v5fA8Cd6FbwlbtmVgaa6s6Akld9IDw+scYNbEa3gdc9vfh3rL9paBpqld6q5tejXu3M0EITlFbZM1L8iEA/2sVxGEHUqeW2M4x/28UkigjrkOjpEGCfRtVi+T0QiDmAyIYr6Z5uleyaWY6Bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DGJxx2bRcJUDxVEkp3hfa5ii8g69qsLpPdt49nPoAGE=;
 b=Rw/oGnYUNGNb1i9eW742s65jb8HzOSlm1G15aw826f0XA+EOqIuvZ9s8Nkk1FE3LvId7/DM2dRaNJTFJFmyOUhBhwQdOe6zhmVub/3Q8SPcjeZHydbXYsSl7EqG2WOo3K32A7RmqiOL4sWGACuqWIAJAaQ1PTi60GnIJEM5xNN9O00WWwvb5WJWrCmVvrUFxIii+h1a9BUCmgD/faWZ0FS6WQKD9OIbZk56HrWAn1P4wQgm7Q1xVwK7nVfZ8JLbsPL5NTvcQUkW+OBIIh0arp/9PnI0hDkPob+U+oVzN4cVEY/3fghl++Myf3c++M5/6kjVRyJf6dFumHyT58YRGvQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by IA1PR12MB8494.namprd12.prod.outlook.com (2603:10b6:208:44c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.202.19; Mon, 13 Jul
 2026 17:25:12 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0202.014; Mon, 13 Jul 2026
 17:25:12 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Kevin Tian <kevin.tian@intel.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Peiyang He <peiyang_he@smail.nju.edu.cn>,
	Xu Yilun <yilun.xu@linux.intel.com>
Subject: [PATCH] iommufd/selftest: Simplify iommufd_device_remove_vdev()
Date: Mon, 13 Jul 2026 14:25:11 -0300
Message-ID: <0-v1-719003d53a5b+38b-iommufd_fault_inj_vdev_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN0PR03CA0054.namprd03.prod.outlook.com
 (2603:10b6:408:e7::29) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|IA1PR12MB8494:EE_
X-MS-Office365-Filtering-Correlation-Id: 99365875-24ac-4d82-181f-08dee103b1fb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|1800799024|18002099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	PEWosUujXE2c0dkfLViLa61folkOChOqbNki5h+dvHPOjM3WpVdfsS5pOwnvKfsRz4nD2iTaliqO5h2uVL2fEQjb3sEPE4xsaeXI0LPpJ5EowQy9L8Uqm3BxHl58w5cDfdgN/Xh6VZDOV5Eerb3gImHYFeBK93d0PCesgtMprDQeEAuE568XCKDCcNIz6rGgqQh7W2uRno9Jbm0pRoYOg0SWPYVrJ9ey8D/27XexrZcsT7ydeW9Gj6ECKvO2XJM/UJNMXahfmrD/TEOEa1li2QqQy+D08cx/qgdGy57vjX7l3E27pUXgtPnWfyZsC6yvt07w9xeZ/lQ98xhL5TQWl4MN2oNjMXukhQq1rbtCSLB6cTQ5LXeU3rdpuwz+wgbolfQ133VkpkJUL4RGWiPEw9CYT4BXj+BVexiOJmu3OL/Ttfj8jjz7BkAr1ZKqSPi3SmWv6YTJhjLF1b3JdQuNnnNc+8DZxI3iINH5IbOqh8GW9J74C5BR3MIbgS54JVv7j8vdB6Bc+DCaR1wSYQ3SkpbscnPEwQuMP7Lqu7mIIO5s1knTCSaC+b9SAeneMg430hbhNCN5X5HH4rA9zbH8b7XbsFVOEcOb6tN3QBZSyxj4D7u803vGnScyesKJ9FVrvVk5b2iUU74N+Neg1EQN8gNIrWHMfMGMFqeo/YlUzzs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(1800799024)(18002099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QLkH1sxhdAc9cWJwDlyEfltHYJsn3hMEr4cnKov39wBGGJJYhwyALLFA+4BZ?=
 =?us-ascii?Q?+Ae67V4JHzf+LKO7t2OpsTsqcvZA1MzaTACtLBSbqnhNgJc7RupB6FqwhNjM?=
 =?us-ascii?Q?09LGsUleFpwCMUmP5MhTkZsnlf/pGeV6EUaLizpgicCBy2Ubf9oJR2qzledK?=
 =?us-ascii?Q?qbwPtnBIRetTOkqSI5+T7jjWn4sE101etI/Lxi2XqtBcY0JQnd8omVlHzHaN?=
 =?us-ascii?Q?lz4GHtBH0Ts6o9LOPYdMWvYlA3Xy34NGofgZpwngANDhX1q7ybeIqyaKjUEG?=
 =?us-ascii?Q?KOVuM70wqFVD6forpnwCHBePvVRuty3zpWGyfvu7nctnMd316KuKa7mn8HIJ?=
 =?us-ascii?Q?7S1WLUgGNCoLyK2YwX+ysmGgp0VIKVcE3FhD0LTapTHsXiEYlWZo56PNBr7E?=
 =?us-ascii?Q?KRhviP8w4hm3AVsT1lv1EoXkMiZEFSnAzfggFhdk80N7sdOak5wjwX08wHNz?=
 =?us-ascii?Q?PAjJtoG0Ku3jvHfgnScp13HvEbNwOkY0Dlw2xZQyDYC88lWiIVLDzPyMB2Tp?=
 =?us-ascii?Q?2Qh3x7t5JTNL0yaFFT5VZ4pzDmdS4lSV2bEqIy5RlcvbV9G6CxI1wzCdxegl?=
 =?us-ascii?Q?uST3Z+7Jbj4CorFiwQ/f9qx03p9Yb2iRyr60tRJFqtqQctEqiCBnZde5SwwD?=
 =?us-ascii?Q?HuZzb+QwxEnLfyLWPfF+OkIEZcM48T/2e+IGd84nyeb4tiyiqoxbpUFe0BUe?=
 =?us-ascii?Q?Wa8FrBlZ+lgdXc2tOvjmnGOk/WlrKQTLgdhSySY3psjMh6mb9n/Bi0alZe51?=
 =?us-ascii?Q?ZLYB0Md6f6ncmO5cC/D3PeCwIo7A5d89a5KfyDUPxDEZqFLxW78pRE6i8Lus?=
 =?us-ascii?Q?hCodZD1qwymdDbem64K8PadSb3emxEyfiAvULouj6R6GJOafTEqevaILBiop?=
 =?us-ascii?Q?IcVAxFx95RqsdznH4hJTR/IUwM3BsRzAIaI05BZOGMRRP2dPvLKzIaWXZlAz?=
 =?us-ascii?Q?hMDC/O+3z4tg2u4RH4OUb4eP/OY2kdOdDdzYsqmbwTKQbhJdhImO806eQ3IF?=
 =?us-ascii?Q?I5I0kjNk+0OpfJNY5tsro1bPT7D6wqSz7KBx4txPW9VYlZt5NEOXWostC/ml?=
 =?us-ascii?Q?+kQ4Af5re1PQwoLHrND4VBKrQnhcy9JuZhoZsm36WjgQyUWSnlpOipCl08af?=
 =?us-ascii?Q?WbwR98QVqIMMtmm6+pfLuhNV0fjNWa47NcSGCr9+cS7shwceTTKBKmQUI68J?=
 =?us-ascii?Q?NisVf1ifH/2X7iGpT1w7LEVRI0c31xc1uwhaVL1IzQL/xy5PXdqaCBpAD6k1?=
 =?us-ascii?Q?iAObebXphqSBRKis8gLmctIEa1MY6sByyk8+tfKulnbyhqvOMCGfVnD5aPsv?=
 =?us-ascii?Q?rcFH4Adawzxz4VPJO5tYnOQiuM3nnYEA5BnSDSNJbOjJg5FcqiXtLd4qa+2N?=
 =?us-ascii?Q?zYSw3ufWKDnUsqKt0nu9Uititv9YpeywPqlg9Fe9Ojj0dys2Zpnx0qWUHBxv?=
 =?us-ascii?Q?ns3BFJLWKv8OdpDAHwYAzernhQIAh8ui1Wyr1qhAdqyjvPU+wHTU+elVQjcT?=
 =?us-ascii?Q?/KH2FJtiwz8OHDRr5XMOfizbYpFeJW7I0y2DH3btyrmUJKEGReaQtQJXeuqx?=
 =?us-ascii?Q?cNjth4+WhDG8ZnN0P/o3cHhvEAw9I4WNFqNW1fb35WgcJjKpkq9a/r35AfjG?=
 =?us-ascii?Q?83XoRDzJPHxGSLFt5+qR4jdETHO3/NyDq/Y0lAQTyLruf7xWbEO7T2weI1as?=
 =?us-ascii?Q?dh27uqTfFuHcT3VxgRLos28IEYw+Jkpj+6zeBdfarBNMKc0s?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99365875-24ac-4d82-181f-08dee103b1fb
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2026 17:25:12.2799
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z725m+3hH4/WLJgLxr5MRejlMiM/yGfEE5JpC3mwidTj22wu9Pxn5A+1drZ2vDyX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8494

Peiyang reports that this function indirectly includes a fault injection
point through iommufd_get_object() that was intended to cover the uAPI use
of object IDs, not in places like this that cannot fail.

On deeper inspection this can be written using a dedicated helper to
obtain a users refcount relying entirely on the xa locking instead of
going through the whole get/put scheme. The new helper doesn't need the
fault injection point.

Fixes: 850f14f5b919 ("iommufd: Destroy vdevice on idevice destroy")
Reported-by: Peiyang He <peiyang_he@smail.nju.edu.cn>
Closes: https://lore.kernel.org/r/870BB9ADBBEDDD1A+37c5bfab-ad32-4fc5-a302-57c81a8432b5@smail.nju.edu.cn
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommufd/device.c          | 13 +++----------
 drivers/iommu/iommufd/iommufd_private.h |  9 +--------
 drivers/iommu/iommufd/main.c            | 20 ++++++++++++++++++++
 3 files changed, 24 insertions(+), 18 deletions(-)

diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
index 170a7005f0bc84..03a4cc07c0e5b7 100644
--- a/drivers/iommu/iommufd/device.c
+++ b/drivers/iommu/iommufd/device.c
@@ -148,29 +148,22 @@ static void iommufd_device_remove_vdev(struct iommufd_device *idev)
 	if (!idev->vdev)
 		goto out_unlock;
 
-	vdev = iommufd_get_vdevice(idev->ictx, idev->vdev->obj.id);
+	vdev = idev->vdev;
+
 	/*
 	 * An ongoing vdev destroy ioctl has removed the vdev from the object
 	 * xarray, but has not finished iommufd_vdevice_destroy() yet as it
 	 * needs the same mutex. We exit the locking then wait on wait_cnt
 	 * reference for the vdev destruction.
 	 */
-	if (IS_ERR(vdev))
+	if (iommufd_inc_users(idev->ictx, &vdev->obj))
 		goto out_unlock;
 
-	/* Should never happen */
-	if (WARN_ON(vdev != idev->vdev)) {
-		iommufd_put_object(idev->ictx, &vdev->obj);
-		goto out_unlock;
-	}
-
 	/*
 	 * vdev is still alive. Hold a users refcount to prevent racing with
 	 * userspace destruction, then use iommufd_object_tombstone_user() to
 	 * destroy it and leave a tombstone.
 	 */
-	refcount_inc(&vdev->obj.users);
-	iommufd_put_object(idev->ictx, &vdev->obj);
 	mutex_unlock(&idev->igroup->lock);
 	iommufd_object_tombstone_user(idev->ictx, &vdev->obj);
 	return;
diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
index 43fbc5bed8de3f..29a850053ea84d 100644
--- a/drivers/iommu/iommufd/iommufd_private.h
+++ b/drivers/iommu/iommufd/iommufd_private.h
@@ -182,6 +182,7 @@ static inline bool iommufd_lock_obj(struct iommufd_object *obj)
 	return true;
 }
 
+int iommufd_inc_users(struct iommufd_ctx *ictx, struct iommufd_object *obj);
 struct iommufd_object *iommufd_get_object(struct iommufd_ctx *ictx, u32 id,
 					  enum iommufd_object_type type);
 static inline void iommufd_put_object(struct iommufd_ctx *ictx,
@@ -698,14 +699,6 @@ void iommufd_vdevice_abort(struct iommufd_object *obj);
 int iommufd_hw_queue_alloc_ioctl(struct iommufd_ucmd *ucmd);
 void iommufd_hw_queue_destroy(struct iommufd_object *obj);
 
-static inline struct iommufd_vdevice *
-iommufd_get_vdevice(struct iommufd_ctx *ictx, u32 id)
-{
-	return container_of(iommufd_get_object(ictx, id,
-					       IOMMUFD_OBJ_VDEVICE),
-			    struct iommufd_vdevice, obj);
-}
-
 #ifdef CONFIG_IOMMUFD_TEST
 int iommufd_test(struct iommufd_ucmd *ucmd);
 void iommufd_selftest_destroy(struct iommufd_object *obj);
diff --git a/drivers/iommu/iommufd/main.c b/drivers/iommu/iommufd/main.c
index 8c6d43601afbed..1b2867fb502c65 100644
--- a/drivers/iommu/iommufd/main.c
+++ b/drivers/iommu/iommufd/main.c
@@ -180,6 +180,26 @@ struct iommufd_object *iommufd_get_object(struct iommufd_ctx *ictx, u32 id,
 	return obj;
 }
 
+/*
+ * Increment the users count of an object outside the context of an ioctl
+ * that has already locked it. The users refcount cannot be increased unless
+ * the object is installed in the xarray, otherwise things are racing with
+ * a parallel destruction.
+ */
+int iommufd_inc_users(struct iommufd_ctx *ictx, struct iommufd_object *obj)
+{
+	struct iommufd_object *cur;
+
+	xa_lock(&ictx->objects);
+	cur = xa_load(&ictx->objects, obj->id);
+	if (cur == obj)
+		refcount_inc(&obj->users);
+	xa_unlock(&ictx->objects);
+	if (cur != obj)
+		return -EBUSY;
+	return 0;
+}
+
 static int iommufd_object_dec_wait(struct iommufd_ctx *ictx,
 				   struct iommufd_object *to_destroy)
 {

base-commit: dba4254e216d7482d91d93e45faa3ccbefe79337
-- 
2.43.0

