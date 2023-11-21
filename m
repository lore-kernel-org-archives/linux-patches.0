Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2077.outbound.protection.outlook.com [40.107.94.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 604F06AA3;
	Tue, 21 Nov 2023 01:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="fogZstxh"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jYJ7bh8CEd21s0kY62Hs4YU2k9ZhB4R0m97fpLyJ42tzwEQInFD/gNJlpi/ISJbMywu9bX+Wu3Z6WPoxCPeqk00vH0tWdh1D3csunWZPIlhQxyLjJEhwUoZXhlkCu3i70u4N2gkvEpbhzM7C/SN5vk8nYg0yLfsxpNyljNB+w9ciyzJnF2JKp3TwD69b0Apb9aBRFwzx/t+IcRlnx7kZ6iBGNtcf+ecQeUPkPxWIF85P6w/uwwKBxd0O/uJqOhQfPo4WiUpVSenx3f0XqDGv10ZiDszW4ijCvsIok8rFD5OfwzVVt1/alQuWgiq4/2zQ6qW5o4AzYOXUYRzrMg/lOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=447Ht5XJkJ0HBaVjW3l3v+96R54qgDYEDEJHy9DG8o8=;
 b=dtpG5f9XBYmN+mz+TLKv3X2YGRje+v5whx+wO/LsjFP7eaSjocF33zZuHBi/Z/f6dd5zeYSb4kb7VJkdCiEL+BIeaeiQrOTrWLLtUN7M7ZgkCxlhNk7egCb2reWkluWea7Jg9hNLo9oOEBuF6qv0Gs9i0q/1fKtWZdmKwd8mN0fDGyPRNYwwWTPy7AfmTvGXM32cSaXaJ3p4WmIspGpdS4o/W5SCS+Pnc4YmaZtsJhXUHSCAyTwHFQ9Cm4OUGcLNFYxZu22CYPy81oSOPkDK+JcJ22qvhtRGC9FW8H712xZRUzbVlTkhw7kXqBf3HllfOY2qoTnfVT0Lsjqinmf9gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=447Ht5XJkJ0HBaVjW3l3v+96R54qgDYEDEJHy9DG8o8=;
 b=fogZstxhlz3smJ9IGxcMZXwyPJzkhulrlCb4wI4QsULBDqZZTQTX0SXe1esERD8n9ZiL6wgZS7LGg9v1JNt6EfYor4Oh8BnOuIlsIDpMDnDc4fE3mbw5jz6GvtQonPluVXus/mCmsTIdJBkZ3UeRgef1DkFcEjKZHnmCZbXTZG6vi/ILQzAkAo6w2w+j6n/GJ1ihWHWs2nITec4PwIXpGfc1K3lXqSY2gNV1aBNEcy9vpy1fXzxRXDE+w5MY+lI//0oQFZaEMFoo3buPn40BPCLlQ8ufx4O3r9FBMhRXNBCbTmqsIpLATiwzXjQAwOVEDIEHY+gmKm7z0dT1ZwPI9w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by LV2PR12MB5917.namprd12.prod.outlook.com (2603:10b6:408:175::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7002.26; Tue, 21 Nov
 2023 01:28:28 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7002.027; Tue, 21 Nov 2023
 01:28:28 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Kevin Tian <kevin.tian@intel.com>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	Eric Auger <eric.auger@redhat.com>,
	Lixiao Yang <lixiao.yang@intel.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	syzbot+7574ebfe589049630608@syzkaller.appspotmail.com,
	syzbot+d31adfb277377ef8fcba@syzkaller.appspotmail.com,
	Yi Liu <yi.l.liu@intel.com>
Subject: [PATCH rc 2/2] iommufd: Do not UAF during iommufd_put_object()
Date: Mon, 20 Nov 2023 21:28:26 -0400
Message-ID: <2-v1-4c9a7fbb5702+107a-iommufd_syz4_jgg@nvidia.com>
In-Reply-To: <0-v1-4c9a7fbb5702+107a-iommufd_syz4_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7P222CA0024.NAMP222.PROD.OUTLOOK.COM (2603:10b6:8:2e::13)
 To LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|LV2PR12MB5917:EE_
X-MS-Office365-Filtering-Correlation-Id: 535cb2cd-15a5-446e-a1a4-08dbea3129d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	5Lm+uRNOhnftcpL/Xo3+cZBk61KMkJLwvAwmOVKFPG4UECktncFhC0ck6hf7an2pRTIG8JKWW+2Anr1RKPfQhrJBBI4fE5ngWRv40HjrRa+gAu4gTKn7la7D4xEUpngpzwvIl7A0tiB+i4MxRs38UF7HD1aTZ09XgyBoisubxLRk4sNkwduSXv7+rFss1qOOkA1+T66IJQ/072DtWwY5k69jZLhL9Eqm9s2InfciLGvlThU0zvSqWmz8gxR0jLrTM1hq5BlNhsbyT6njnD7nNCT0OI90HUrdKSRpTuhh/JM7vp5KVRQHUA/KUzCPl59scxw6ewpDj+uNQtMI5LOWzafXeeNJi4G4HVnpWRRE/97okk49tMAAPwattzdJzPJ9BeQCyeksd39dR1mj0QxaECBphwoc3cj60nkWuE7KhfQaOPyySFp0LWko+6YwkeXqtG6Gc9CZWdzcH+0omp/KVEYuFJ8ie9/Gtve+B63JGwEsaISMipBinKNw6UE9ommYFg10vwdFT3c4gMMhRUAB/h+qZttjJa4WI0ClHIehK7oEkySqmp6dQpI68jJwmVLaSNd10Q8gmjryUufokPwmXl1SvJcFgjxBZJGIMS5OGK4Lbh6wvsvZqZqKeECL83++uOdN6oGvRyDmNIoMiAuysA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(376002)(366004)(136003)(39860400002)(346002)(230273577357003)(230173577357003)(230922051799003)(451199024)(186009)(64100799003)(1800799012)(4326008)(41300700001)(36756003)(5660300002)(86362001)(7416002)(30864003)(2906002)(6512007)(6506007)(2616005)(26005)(83380400001)(6486002)(966005)(478600001)(8676002)(8936002)(316002)(6916009)(38100700002)(66946007)(54906003)(66476007)(66556008)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?AHdOmhAbjZrRoRpGmYSn73y/tX6AbWXvX52kylJn+A9WZQQgtdpczqJehAaT?=
 =?us-ascii?Q?XvKK7t/MzShMN6gj5nq7LJhD1/0v3jhIVCxrma1Cg5mFuwzvXvYLnIg1PPw/?=
 =?us-ascii?Q?fIu2j2U2PJ6+falFlS0GAisjm2yyEn6cRxiBhUw/UCqU7DvyMZKBh9kxhDxN?=
 =?us-ascii?Q?vCuygAgUWLIC64SqEtelRmMSzamrHPUBo0mGk9k946ySz8crr8x3BgN9ngYh?=
 =?us-ascii?Q?pQ+7y7jnGF5BWnIxDpu75R9VM6YfbGD1rzCJxhBNVpiAgUQ2e2ddsrGdmawJ?=
 =?us-ascii?Q?QoARKmt0gPfzljuFa4wE+tFQefr0f8bDkzkstuVDiuy5RwwUpKkKA8Vmicv1?=
 =?us-ascii?Q?54nBZyyUt9nQ645elNpthqNdmQcO+X5Z3DHa59RkDuu6SvRjl4j4jI3VIQwe?=
 =?us-ascii?Q?xW5Tyo1tM5wBYZqUjv9yEq99NArdyJQCdNmSgSRVgeukaoU8iFH9wU+QnKyO?=
 =?us-ascii?Q?Dutf8vhpSFqYGXCjb/JXhbijtjK+TKCxyLvqrSeK846mIyoXqaWwKvEN/t74?=
 =?us-ascii?Q?nNzVls3RgcBFfFVdAAUnjw8tLRZEVytxhyeA+P+MoO01hNeXouBnS1r5rLuV?=
 =?us-ascii?Q?O/MWSz0JZ/blyquqc5/j4DilQQ/OSY153MvKRWobn1MLBNP+T1CXhZzzaYEK?=
 =?us-ascii?Q?vr9oLOMdRAXr/fqJhkqFRNEakjinZ4pkRciwGUT+fQ2F7xdi7lvc3ABjz+G+?=
 =?us-ascii?Q?lGFssWtTvyHlcnjoPfZ3nWK4GvGa4KJc0KN6XsGEWx4eb6pcDuu2SUwha4T0?=
 =?us-ascii?Q?2z5sz/4AYTZbBvohTXxcCL8c5DmKeAz6CsAd/0e0t6c3epnf4lK/LwCylEBc?=
 =?us-ascii?Q?rlmFO3v0uHTMrcn1l2lXA2Wb1EK+fU4BCr5+3NgCDKwK94PbouKU/rN6File?=
 =?us-ascii?Q?z9+UXLBNXGeaqHUInhnWLIBnFE/kLA+MRoijsL2NEwXeBUKUCra++IEeO53v?=
 =?us-ascii?Q?KshipPppR8E/WcOXyiN4gn3q2UC+E/wKqqUK1ZqkZbuz7+ELi/x/eu0UyoiN?=
 =?us-ascii?Q?1mr/nDj3PsiJyo2Y4KytZJprZqChs6ToCCqe51zABqfbdgCZYRzQAgCHkMi9?=
 =?us-ascii?Q?KQE77Hd/u+wXm2u4bpP2eSub/NSt4Gz/ZbTCzXN1w4LJhMBBrwi0yNwkjN4Q?=
 =?us-ascii?Q?DWhNxkQdx7f3bOk4XvjXwLRfSHGVJTF7Shh8PirbnXY4zJQv6mBLvMbzT8cA?=
 =?us-ascii?Q?G/qDWCaC2QwsjWuIu0lYqyqZJOGOeOus5D3ug///7rbOgfSQsm+1LSU5O3SH?=
 =?us-ascii?Q?C6gRTy5dOdIIJxaA5eVPGcCSgbADHEMnY9czEAls+4okiDReQPuTpYnsjrN9?=
 =?us-ascii?Q?hsYiH4V9NxGtuYVqDgADei36Y4/J0iNIobzG9xI8y1EJPclrREX9kvCew3Gf?=
 =?us-ascii?Q?1v3Zen1n8k+uQTidUlpy1vIbXTFASuKvkzOHxivuPojvnss/nG0fl6oozjt1?=
 =?us-ascii?Q?fdjAJ0ULr0M7NUW6nA5+PJJYZibAe9FWTD+Nx88jfnF3iP4YkNkt6YOcyzum?=
 =?us-ascii?Q?jGS77p3jcfgaXYD5pDgGdT8cZd0jdQpULYsuZG7pgq/qXQ/CgiScHMgfvjoU?=
 =?us-ascii?Q?sGjFEWAb2oT3J4f2HIfYvajfzQdMNeyUVfjvcGas?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 535cb2cd-15a5-446e-a1a4-08dbea3129d2
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2023 01:28:28.0834
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PrMlvW/DfEz26NXPhnasAMwFPRIKavTiIZ8RgzOsLSpWArG7IRdYw6e6ZBRw2vgU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5917

The mixture of kernel and user space lifecycle objects continues to be
complicated inside iommufd. The obj->destroy_rwsem is used to bring order
to the kernel driver destruction sequence but it cannot be sequenced right
with the other refcounts so we end up possibly UAF'ing:

  BUG: KASAN: slab-use-after-free in __up_read+0x627/0x750 kernel/locking/rwsem.c:1342
  Read of size 8 at addr ffff888073cde868 by task syz-executor934/6535

  CPU: 1 PID: 6535 Comm: syz-executor934 Not tainted 6.6.0-rc7-syzkaller-00195-g2af9b20dbb39 #0
  Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/09/2023
  Call Trace:
   <TASK>
   __dump_stack lib/dump_stack.c:88 [inline]
   dump_stack_lvl+0xd9/0x1b0 lib/dump_stack.c:106
   print_address_description mm/kasan/report.c:364 [inline]
   print_report+0xc4/0x620 mm/kasan/report.c:475
   kasan_report+0xda/0x110 mm/kasan/report.c:588
   __up_read+0x627/0x750 kernel/locking/rwsem.c:1342
   iommufd_put_object drivers/iommu/iommufd/iommufd_private.h:149 [inline]
   iommufd_vfio_ioas+0x46c/0x580 drivers/iommu/iommufd/vfio_compat.c:146
   iommufd_fops_ioctl+0x347/0x4d0 drivers/iommu/iommufd/main.c:398
   vfs_ioctl fs/ioctl.c:51 [inline]
   __do_sys_ioctl fs/ioctl.c:871 [inline]
   __se_sys_ioctl fs/ioctl.c:857 [inline]
   __x64_sys_ioctl+0x18f/0x210 fs/ioctl.c:857
   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
   do_syscall_64+0x38/0xb0 arch/x86/entry/common.c:80
   entry_SYSCALL_64_after_hwframe+0x63/0xcd

There are two races here, the more obvious one:

     CPU 0                                 CPU 1
 iommufd_put_object()
                                          iommufd_destroy()
  refcount_dec(&obj->users)

 	                                   iommufd_object_remove()
					   kfree()
  up_read(&obj->destroy_rwsem) // Boom

And there is also perhaps some possibility that the rwsem could hit an
issue:

     CPU 0                                 CPU 1
 iommufd_put_object()
                                         iommufd_object_destroy_user()
  refcount_dec(&obj->users);
 	                                  down_write(&obj->destroy_rwsem)
  up_read(&obj->destroy_rwsem);
                                             atomic_long_or(RWSEM_FLAG_WAITERS, &sem->count);
      tmp = atomic_long_add_return_release()
                                             rwsem_try_write_lock()
 	                                  iommufd_object_remove()
	                                  up_write(&obj->destroy_rwsem)
					  kfree()
      clear_nonspinnable() // Boom

Fix this by reorganizing this again so that two refcounts are used to keep
track of things with a rule that users == 0 && shortterm_users == 0 means
no other threads have that memory. Put a wait_queue in the iommufd_ctx
object that is triggered when any sub object reaches a 0
shortterm_users. This allows the same wait for userspace ioctls to finish
behavior that the rwsem was providing.

This is weaker still than the prior versions:

 - There is no bias on shortterm_users so if some thread is waiting to
   destroy other threads can continue to get new read sides

 - If destruction fails, eg because of an active in-kernel user, then
   shortterm_users will have cycled to zero momentarily blocking new users

 - If userspace races destroy with other userspace operations they
   continue to get an EBUSY since we still can't intermix looking up an ID
   and sleeping for its unref

In all cases these are things that userspace brings on itself, correct
programs will not hit them.

Fixes: 99f98a7c0d69 ("iommufd: IOMMUFD_DESTROY should not increase the refcount")
Reported-by: syzbot+d31adfb277377ef8fcba@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/r/00000000000055ef9a0609336580@google.com
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommufd/iommufd_private.h |  48 +++++++--
 drivers/iommu/iommufd/main.c            | 131 ++++++++++++------------
 2 files changed, 100 insertions(+), 79 deletions(-)

diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
index f918a22f0d4800..45ffc6d8a69955 100644
--- a/drivers/iommu/iommufd/iommufd_private.h
+++ b/drivers/iommu/iommufd/iommufd_private.h
@@ -21,6 +21,7 @@ struct iommufd_ctx {
 	struct file *file;
 	struct xarray objects;
 	struct xarray groups;
+	wait_queue_head_t destroy_wait;
 
 	u8 account_mode;
 	/* Compatibility with VFIO no iommu */
@@ -135,7 +136,7 @@ enum iommufd_object_type {
 
 /* Base struct for all objects with a userspace ID handle. */
 struct iommufd_object {
-	struct rw_semaphore destroy_rwsem;
+	refcount_t shortterm_users;
 	refcount_t users;
 	enum iommufd_object_type type;
 	unsigned int id;
@@ -143,12 +144,9 @@ struct iommufd_object {
 
 static inline bool iommufd_lock_obj(struct iommufd_object *obj)
 {
-	if (!down_read_trylock(&obj->destroy_rwsem))
+	if (!refcount_inc_not_zero(&obj->shortterm_users))
 		return false;
-	if (!refcount_inc_not_zero(&obj->users)) {
-		up_read(&obj->destroy_rwsem);
-		return false;
-	}
+	refcount_inc(&obj->users);
 	return true;
 }
 
@@ -157,8 +155,13 @@ struct iommufd_object *iommufd_get_object(struct iommufd_ctx *ictx, u32 id,
 static inline void iommufd_put_object(struct iommufd_ctx *ictx,
 				      struct iommufd_object *obj)
 {
+	/*
+	 * Users first, then shortterm so that REMOVE_WAIT_SHORTTERM never sees
+	 * a spurious !0 users with a 0 shortterm_users.
+	 */
 	refcount_dec(&obj->users);
-	up_read(&obj->destroy_rwsem);
+	if (refcount_dec_and_test(&obj->shortterm_users))
+		wake_up_interruptible_all(&ictx->destroy_wait);
 }
 
 void iommufd_object_abort(struct iommufd_ctx *ictx, struct iommufd_object *obj);
@@ -166,17 +169,40 @@ void iommufd_object_abort_and_destroy(struct iommufd_ctx *ictx,
 				      struct iommufd_object *obj);
 void iommufd_object_finalize(struct iommufd_ctx *ictx,
 			     struct iommufd_object *obj);
-void __iommufd_object_destroy_user(struct iommufd_ctx *ictx,
-				   struct iommufd_object *obj, bool allow_fail);
+
+enum {
+	REMOVE_WAIT_SHORTTERM = 1,
+};
+int iommufd_object_remove(struct iommufd_ctx *ictx,
+			  struct iommufd_object *to_destroy, u32 id,
+			  unsigned int flags);
+
+/*
+ * The caller holds a users refcount and wants to destroy the object. In all
+ * cases the caller no longer has a reference on obj.
+ */
 static inline void iommufd_object_destroy_user(struct iommufd_ctx *ictx,
 					       struct iommufd_object *obj)
 {
-	__iommufd_object_destroy_user(ictx, obj, false);
+	int ret;
+
+	ret = iommufd_object_remove(ictx, obj, obj->id, REMOVE_WAIT_SHORTTERM);
+
+	/*
+	 * If there is a bug and we couldn't destroy the object then we did put
+	 * back the caller's refcount and will eventually try to free it again
+	 * during close.
+	 */
+	WARN_ON(ret);
 }
+
+/*
+ * Used by autodomains to clean up the hwpt object if it was not used manually.
+ */
 static inline void iommufd_object_deref_user(struct iommufd_ctx *ictx,
 					     struct iommufd_object *obj)
 {
-	__iommufd_object_destroy_user(ictx, obj, true);
+	iommufd_object_remove(ictx, obj, obj->id, 0);
 }
 
 struct iommufd_object *_iommufd_object_alloc(struct iommufd_ctx *ictx,
diff --git a/drivers/iommu/iommufd/main.c b/drivers/iommu/iommufd/main.c
index 45b9d40773b13a..2d46324ec7f340 100644
--- a/drivers/iommu/iommufd/main.c
+++ b/drivers/iommu/iommufd/main.c
@@ -33,7 +33,6 @@ struct iommufd_object *_iommufd_object_alloc(struct iommufd_ctx *ictx,
 					     size_t size,
 					     enum iommufd_object_type type)
 {
-	static struct lock_class_key obj_keys[IOMMUFD_OBJ_MAX];
 	struct iommufd_object *obj;
 	int rc;
 
@@ -41,15 +40,8 @@ struct iommufd_object *_iommufd_object_alloc(struct iommufd_ctx *ictx,
 	if (!obj)
 		return ERR_PTR(-ENOMEM);
 	obj->type = type;
-	/*
-	 * In most cases the destroy_rwsem is obtained with try so it doesn't
-	 * interact with lockdep, however on destroy we have to sleep. This
-	 * means if we have to destroy an object while holding a get on another
-	 * object it triggers lockdep. Using one locking class per object type
-	 * is a simple and reasonable way to avoid this.
-	 */
-	__init_rwsem(&obj->destroy_rwsem, "iommufd_object::destroy_rwsem",
-		     &obj_keys[type]);
+	/* Starts out bias'd by 1 until it is removed from the xarray */
+	refcount_set(&obj->shortterm_users, 1);
 	refcount_set(&obj->users, 1);
 
 	/*
@@ -131,90 +123,92 @@ struct iommufd_object *iommufd_get_object(struct iommufd_ctx *ictx, u32 id,
 
 /*
  * Remove the given object id from the xarray if the only reference to the
- * object is held by the xarray. The caller must call ops destroy().
+ * object is held by the xarray.
  */
-static struct iommufd_object *iommufd_object_remove(struct iommufd_ctx *ictx,
-						    u32 id, bool extra_put)
+int iommufd_object_remove(struct iommufd_ctx *ictx,
+			  struct iommufd_object *to_destroy, u32 id,
+			  unsigned int flags)
 {
 	struct iommufd_object *obj;
 	XA_STATE(xas, &ictx->objects, id);
+	bool zerod_shortterm = false;
+	int ret;
+
+	/*
+	 * The purpose of the shortterm_users is to ensure deterministic
+	 * destruction of objects used by external drivers and destroyed by this
+	 * function. Any temporary increment of the refcount must increment
+	 * shortterm_users, such as during ioctl execution.
+	 */
+	if (flags & REMOVE_WAIT_SHORTTERM) {
+		if (!refcount_dec_and_test(&to_destroy->shortterm_users)) {
+			if (!wait_event_timeout(
+				    ictx->destroy_wait,
+				    refcount_read(
+					    &to_destroy->shortterm_users) == 0,
+				    msecs_to_jiffies(10000))) {
+				pr_crit("Time out waiting for iommufd object to become free\n");
+				refcount_inc(&to_destroy->shortterm_users);
+				return -EBUSY;
+			}
+		}
+		zerod_shortterm = true;
+	}
 
 	xa_lock(&ictx->objects);
 	obj = xas_load(&xas);
-	if (xa_is_zero(obj) || !obj) {
-		obj = ERR_PTR(-ENOENT);
-		goto out_xa;
+	if (to_destroy) {
+		if (WARN_ON(obj != to_destroy)) {
+			ret = -ENOENT;
+			goto err_xa;
+		}
+
+		/*
+		 * If the caller is holding a ref on obj we put it here under
+		 * the spinlock.
+		 */
+		refcount_dec(&obj->users);
+	} else if (xa_is_zero(obj) || !obj) {
+		ret = -ENOENT;
+		goto err_xa;
 	}
 
-	/*
-	 * If the caller is holding a ref on obj we put it here under the
-	 * spinlock.
-	 */
-	if (extra_put)
-		refcount_dec(&obj->users);
+	/* Both refcounts must reach zero before we can continue */
+	if (!zerod_shortterm && !refcount_dec_if_one(&obj->shortterm_users)) {
+		ret = -EBUSY;
+		goto err_xa;
+	} else {
+		zerod_shortterm = true;
+	}
 
 	if (!refcount_dec_if_one(&obj->users)) {
-		obj = ERR_PTR(-EBUSY);
-		goto out_xa;
+		ret = -EBUSY;
+		goto err_xa;
 	}
 
 	xas_store(&xas, NULL);
 	if (ictx->vfio_ioas == container_of(obj, struct iommufd_ioas, obj))
 		ictx->vfio_ioas = NULL;
-
-out_xa:
 	xa_unlock(&ictx->objects);
 
-	/* The returned object reference count is zero */
-	return obj;
-}
-
-/*
- * The caller holds a users refcount and wants to destroy the object. Returns
- * true if the object was destroyed. In all cases the caller no longer has a
- * reference on obj.
- */
-void __iommufd_object_destroy_user(struct iommufd_ctx *ictx,
-				   struct iommufd_object *obj, bool allow_fail)
-{
-	struct iommufd_object *ret;
-
-	/*
-	 * The purpose of the destroy_rwsem is to ensure deterministic
-	 * destruction of objects used by external drivers and destroyed by this
-	 * function. Any temporary increment of the refcount must hold the read
-	 * side of this, such as during ioctl execution.
-	 */
-	down_write(&obj->destroy_rwsem);
-	ret = iommufd_object_remove(ictx, obj->id, true);
-	up_write(&obj->destroy_rwsem);
-
-	if (allow_fail && IS_ERR(ret))
-		return;
-
-	/*
-	 * If there is a bug and we couldn't destroy the object then we did put
-	 * back the caller's refcount and will eventually try to free it again
-	 * during close.
-	 */
-	if (WARN_ON(IS_ERR(ret)))
-		return;
-
 	iommufd_object_ops[obj->type].destroy(obj);
 	kfree(obj);
+	return 0;
+
+err_xa:
+	if (zerod_shortterm)
+		refcount_set(&obj->shortterm_users, 1);
+	xa_unlock(&ictx->objects);
+
+	/* The returned object reference count is zero */
+	return ret;
 }
 
 static int iommufd_destroy(struct iommufd_ucmd *ucmd)
 {
 	struct iommu_destroy *cmd = ucmd->cmd;
-	struct iommufd_object *obj;
 
-	obj = iommufd_object_remove(ucmd->ictx, cmd->id, false);
-	if (IS_ERR(obj))
-		return PTR_ERR(obj);
-	iommufd_object_ops[obj->type].destroy(obj);
-	kfree(obj);
-	return 0;
+	return iommufd_object_remove(ucmd->ictx, NULL, cmd->id, 0);
 }
 
 static int iommufd_fops_open(struct inode *inode, struct file *filp)
@@ -238,6 +232,7 @@ static int iommufd_fops_open(struct inode *inode, struct file *filp)
 	xa_init_flags(&ictx->objects, XA_FLAGS_ALLOC1 | XA_FLAGS_ACCOUNT);
 	xa_init(&ictx->groups);
 	ictx->file = filp;
+	init_waitqueue_head(&ictx->destroy_wait);
 	filp->private_data = ictx;
 	return 0;
 }
-- 
2.42.0

