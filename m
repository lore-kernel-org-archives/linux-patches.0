Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2060.outbound.protection.outlook.com [40.107.102.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D20D84D585;
	Wed, 22 Nov 2023 13:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="rG6iUYVq"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Npqhl21sdTZiml1hZt/xVtCBRH/aagXGtRJA43T3EhDUqhwRKFtA0wH+d0I8S9GGoTIY7+jeZB8PV7VVnlJX7r79wVIVAvpT3UdJLUEYnFFShgJnXnjnPl/E/KYBx0X8e/phd9zVEutfuMG2WhPMEffZaq7/xtyj1o8k2j1JQKQjN/pcijB5VMhTrhexf/b5retfMMIg8OMBTKkc+JYorTCmiXE3aikeXf72yqXfMsdvHZoYai3hqwRjTnIsbDKXl+N3L38N9FVoR6SPjadWD1TM9h1uNfganimbraRdDvKNukX+hmNqNuMetDDQyUfs4r71VKu/I+U/C7OwS9JCKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uufiYVINBervCm6jEyL6BPFn6+g2Y2MVGubIfNjSmHg=;
 b=KUBxHBBA5iYhm/QCQG0/UsrXi0MbLKvkbojzV3KdbUKd66HkIt4lngt0PNFS+Vf+OhSQmGnf2cpf1S2YEj2iT6CbZx4RzH8ztc1LxKvM9EANrvaKnkTIccVSr+/q3oevQzg8phRlcCN/eGMpsFYwyu5NuQvCTuYG0IKEBBjfBlG1iAduEkjOcdWzHDYx/4BmtmcWACitK+GQxpB/v54e/U8Sd3+3gXDTzGPzL0HlSxIC60q+zE+wYfmATFf9dMW6OpJT8lojwyDWYA2nhZChXMSdPNVe1c3L4h/a+r5vaO/LwwP/68DRmnnEvtAXbUbihWiFyeHQHqm0R+uD9vu8OQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uufiYVINBervCm6jEyL6BPFn6+g2Y2MVGubIfNjSmHg=;
 b=rG6iUYVqnv+Xx01UCp2ky5k2Wh+L6fYa5oDTC8hi+BNBKY/SvFfGnwftD8jS+ymIwbV4+4ct1ieoeaNkQTL+jPAtgRPzxuOu+uxxM8IWG2TmBQylRGwGvebOatlXEa9xJ2z8MnZ1bbuercJ42oeGL3ekY/fqbJZkB+T1zBxOdbTVbz15a69WLOgHeQc9cbNOhSp8g2HRUJEHSqHvcIiFycfsOd48jtsVigjd0M5ta945SCEbi6kDsL2M6+R5rsK6jqOjRz+vJOj+MOQBnySTeDt/YIqyGxG2V9Fh3YBhdsS3sNJAdrJ7991gypE1F/xvbg6epAUcuH7Xlo4u6Y5gkA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MN6PR12MB8489.namprd12.prod.outlook.com (2603:10b6:208:474::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7002.28; Wed, 22 Nov
 2023 13:13:21 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7002.027; Wed, 22 Nov 2023
 13:13:21 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	Eric Auger <eric.auger@redhat.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Lixiao Yang <lixiao.yang@intel.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	syzbot+7574ebfe589049630608@syzkaller.appspotmail.com,
	syzbot+d31adfb277377ef8fcba@syzkaller.appspotmail.com,
	Yi Liu <yi.l.liu@intel.com>
Subject: [PATCH rc v2 2/2] iommufd: Do not UAF during iommufd_put_object()
Date: Wed, 22 Nov 2023 09:13:19 -0400
Message-ID: <2-v2-ca9e00171c5b+123-iommufd_syz4_jgg@nvidia.com>
In-Reply-To: <0-v2-ca9e00171c5b+123-iommufd_syz4_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR11CA0054.namprd11.prod.outlook.com
 (2603:10b6:5:14c::31) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MN6PR12MB8489:EE_
X-MS-Office365-Filtering-Correlation-Id: 3dfa55eb-e701-4a3f-f420-08dbeb5ccce8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	piS8h3W7VnWsm1OJcokOXdF7KdPC/yg1Hu8bjzMtcJRxf4pDbgCEVqD8peg49IN/SoNsy6BwoaYdBlD1HupBnVqBUEsJqDFJYC8Y5c3pJgDkv7WCGOxH00n02hXm/gYHyY2vIyeC0XLBf/ccQT4KoGoE4SGK5HPL0aEnBBUCFfaRqw2kABT/oMhYc+/L732NLaxsGSK0CZXRkxjIXV7A4kQVuRowWz0NNX8BdPrC6i5A8LbqmWgS3IiHtDU0bKqmxkZLkppbAcuFw8iW+gGZqvp0aJQ1z0NpwNgOHt9a7ZYYYP/SIVXAqsVnGRf6qvxn7HO8mCoe4sYiunGRGg7eRLyRyfvML5rOc2NBMiwKh5u9Q6e8dYNFmoEgGPqQbISPrS/fP4w3S2JcKQcu9be4QHpwh8AUP000mLBaUBx97LXABF7GdicoKetb98g+38OylJk6zod2KUStIr8Ec4fsUegEmu6KotV0pRv2is3ioOCErYYAcvUtjh9I8U4+IujsdynoPV1dqSWbzkjhIjlLGz8A3GaV5Glsr2bi8hGwjC2js8QJTcioQNN6iiEestVfb0jN5p3NNTfkIgURNSVGGt29Z1B8EFknOQ+KBBkqdi7VLVJ5cLnw1L+W8pyth3AXJf24TN1YGGIZw+o7LOPZuA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(396003)(136003)(39860400002)(376002)(366004)(230173577357003)(230273577357003)(230922051799003)(1800799012)(186009)(64100799003)(451199024)(4326008)(30864003)(2906002)(6486002)(8676002)(41300700001)(8936002)(2616005)(966005)(26005)(66946007)(316002)(6916009)(66476007)(54906003)(66556008)(7416002)(5660300002)(6512007)(6506007)(478600001)(83380400001)(38100700002)(86362001)(36756003)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HwFdAc1GPorJrS+I3+hiZyxKw9lvhobWgvYTddP8E4vOTkOQ2cmi28QpNVf6?=
 =?us-ascii?Q?aGQ4eNnF2Cxh6WhnTUoQnbZGCXb2Qq1MuzlyctP17cSYe36pxy/oabKMh02e?=
 =?us-ascii?Q?bGJR8biNlXJaFUal/gdDn+0EVYncnfB3xIDMFCmNYLwSp64xkjiZs+ykn4jo?=
 =?us-ascii?Q?CaS4D7f1qtKWilve63WZgbqFXUFF2SVgU2TVhilILpn724ZgJIBDDz+pipGK?=
 =?us-ascii?Q?UC4Kjd5QjdAuovVOnrbvDTlfTKtNFNbh+BNWf66dJpgRKm3sruwTC2Q1tbH2?=
 =?us-ascii?Q?WsWSzCGxEmlQm5eCYM+8vc+6lJxSOmPn2C7NrM2JkNjbrvgqhjc+rRKrKN1b?=
 =?us-ascii?Q?EXSHdnAVBqEP/sbxB9Fdzv4+ndK1eKWqd4m7nuG1zx+qUQjcC881nJ7NFDtY?=
 =?us-ascii?Q?JeFv/UEV3ywGQ0RnPRpnaAiKZCUzZvDeMbiFXBw7LAF9KvhJr8r0XvQ0w1ft?=
 =?us-ascii?Q?Rf/c35UsHpiqH+PMuOnmrLUUHxRsV6xRgy3yVVPEy464MgFTaSL2Kcah1vB3?=
 =?us-ascii?Q?KQRoelcirLMAeRReGWYe2SymMuw9dfVWbklR0UqLuoCYEMGWPXmru2mOzCUn?=
 =?us-ascii?Q?87pjAY9Vy72xZl5hVEF5rMst693DN/j2mn6fqXHMzO3PEWVtc8r3LuXuvEfY?=
 =?us-ascii?Q?Fy5by9NIDX3IfCMgQ7g2zPyvnpU7WeSk2aKFG+NJ55CaSI5qarhzXRlhJm6U?=
 =?us-ascii?Q?JlgbXvLHMjydFT+zvbREISykDRSx0wHyw5L39H8+krV60SdgCiYb/R9LiBih?=
 =?us-ascii?Q?1xq0HADBrlFkKn4fFXx+ZX/dtn27JeLjSnQKdfZmMihoYfN6uCPZuRlc6Epm?=
 =?us-ascii?Q?EfcKP1JOOjLniFw4qlLIEoANSAJ/ai2wF1s3JRkdCSkvSokX3cYbpUXv94GX?=
 =?us-ascii?Q?ef2pfFbmP2o1XsPEHd5VCDnLlbo+8HFjLe8lmluueOs1yw0a4Y1GaoIeb718?=
 =?us-ascii?Q?ActNpBoM9VZtSDFNCHMMADXnjyUAg1ld2J70Z7AVuGB9agSOylUZqUl233RE?=
 =?us-ascii?Q?sC43u+ME6K1fNl2lW9ewscquuw4FyxYVpc5PE7sOzCtPv2KPordGHYIU/9vy?=
 =?us-ascii?Q?nMnkqnZHZCYkF3UP6ka0qH2pzOu4gbIetDeklAQohmvSLz5vzfvmoMt6x5jp?=
 =?us-ascii?Q?ksUI8QLNZ+xxhxXGkhcBd1bt4c89JVZ7Ei6FRZOAt2B1IReffohHqjjYml4w?=
 =?us-ascii?Q?3uKo3UcUQUgfwQu7jidHEo+mvstmc4hj2PjY5FMujv+6lIBzoc9YhQWWfy5i?=
 =?us-ascii?Q?4TtHfxpdzb/hSFGY86goI4gqeRgiXndLwhQBxjbupX+f5AyGxEO0gd+mJfu5?=
 =?us-ascii?Q?nwmTqBuAgsPTUcyYhD2CDL9tw0sLXbqy1ojHy0SjKCI00Lkw15HZsbuO9oQy?=
 =?us-ascii?Q?K6dLtcTvDXPbZ7EZK6T4uIs8nm/5gATRGPWx5GEa+osm9ULFYVhiugo4+pTC?=
 =?us-ascii?Q?rLawjOdUA8O1fm/K2j1IAocrq0fbJmCBo7C6aGy87Kd00E44bGf4GIjad9Bp?=
 =?us-ascii?Q?ROxHZY/zz91sZl/JAzBwDngZBl/0EfJR7K3uW5CN6B1ytcEVBXai2J/rBaXO?=
 =?us-ascii?Q?Rv9e5LEDRyUAFwdzJ6MZ6JpBkQAl2zWOGpOKAI85?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3dfa55eb-e701-4a3f-f420-08dbeb5ccce8
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2023 13:13:21.2693
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j0LSP1KO58Qe+gwrOzokI/eFLp+SIkafUv3RegpZxrQcqMCApt0IU4LMbfvPNdEN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8489

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
 drivers/iommu/iommufd/iommufd_private.h |  53 +++++++--
 drivers/iommu/iommufd/main.c            | 146 +++++++++++++-----------
 2 files changed, 124 insertions(+), 75 deletions(-)

diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
index f918a22f0d4800..2df049bfc2d4e9 100644
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
@@ -143,10 +144,15 @@ struct iommufd_object {
 
 static inline bool iommufd_lock_obj(struct iommufd_object *obj)
 {
-	if (!down_read_trylock(&obj->destroy_rwsem))
+	if (!refcount_inc_not_zero(&obj->users))
 		return false;
-	if (!refcount_inc_not_zero(&obj->users)) {
-		up_read(&obj->destroy_rwsem);
+	if (!refcount_inc_not_zero(&obj->shortterm_users)) {
+		/*
+		 * If the caller doesn't already have a ref on obj this must be
+		 * called under the xa_lock. Otherwise the caller is holding a
+		 * ref on users so this cannot make it zero.
+		 */
+		refcount_dec(&obj->users);
 		return false;
 	}
 	return true;
@@ -157,8 +163,13 @@ struct iommufd_object *iommufd_get_object(struct iommufd_ctx *ictx, u32 id,
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
@@ -166,17 +177,41 @@ void iommufd_object_abort_and_destroy(struct iommufd_ctx *ictx,
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
+ * cases the caller no longer has a users reference on obj. At this point
+ * the xarray will be holding a shortterm_users reference.
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
index 45b9d40773b13a..179fb1c2156a9f 100644
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
@@ -129,92 +121,113 @@ struct iommufd_object *iommufd_get_object(struct iommufd_ctx *ictx, u32 id,
 	return obj;
 }
 
+static int iommufd_object_dec_wait_shortterm(struct iommufd_ctx *ictx,
+					     struct iommufd_object *to_destroy)
+{
+	if (refcount_dec_and_test(&to_destroy->shortterm_users))
+		return 0;
+
+	if (wait_event_timeout(ictx->destroy_wait,
+				refcount_read(&to_destroy->shortterm_users) ==
+					0,
+				msecs_to_jiffies(10000)))
+		return 0;
+
+	pr_crit("Time out waiting for iommufd object to become free\n");
+	refcount_inc(&to_destroy->shortterm_users);
+	return -EBUSY;
+}
+
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
+		ret = iommufd_object_dec_wait_shortterm(ictx, to_destroy);
+		if (ret) {
+			/*
+			 * We have a bug. Put back the callers reference and
+			 * defer cleaning this object until close.
+			 */
+			refcount_dec(&to_destroy->users);
+			return ret;
+		}
+		zerod_shortterm = true;
+	}
 
 	xa_lock(&ictx->objects);
 	obj = xas_load(&xas);
-	if (xa_is_zero(obj) || !obj) {
-		obj = ERR_PTR(-ENOENT);
-		goto out_xa;
-	}
-
-	/*
-	 * If the caller is holding a ref on obj we put it here under the
-	 * spinlock.
-	 */
-	if (extra_put)
+	if (to_destroy) {
+		/*
+		 * If the caller is holding a ref on obj we put it here under
+		 * the spinlock.
+		 */
 		refcount_dec(&obj->users);
 
+		if (WARN_ON(obj != to_destroy)) {
+			ret = -ENOENT;
+			goto err_xa;
+		}
+	} else if (xa_is_zero(obj) || !obj) {
+		ret = -ENOENT;
+		goto err_xa;
+	}
+
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
 	/*
-	 * The purpose of the destroy_rwsem is to ensure deterministic
-	 * destruction of objects used by external drivers and destroyed by this
-	 * function. Any temporary increment of the refcount must hold the read
-	 * side of this, such as during ioctl execution.
+	 * Since users is zero any positive users_shortterm must be racing
+	 * iommufd_put_object(), or we have a bug.
 	 */
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
+	if (!zerod_shortterm) {
+		ret = iommufd_object_dec_wait_shortterm(ictx, obj);
+		if (WARN_ON(ret))
+			return ret;
+	}
 
 	iommufd_object_ops[obj->type].destroy(obj);
 	kfree(obj);
+	return 0;
+
+err_xa:
+	if (zerod_shortterm) {
+		/* Put back the xarray owned reference */
+		refcount_set(&obj->shortterm_users, 1);
+	}
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
@@ -238,6 +251,7 @@ static int iommufd_fops_open(struct inode *inode, struct file *filp)
 	xa_init_flags(&ictx->objects, XA_FLAGS_ALLOC1 | XA_FLAGS_ACCOUNT);
 	xa_init(&ictx->groups);
 	ictx->file = filp;
+	init_waitqueue_head(&ictx->destroy_wait);
 	filp->private_data = ictx;
 	return 0;
 }
-- 
2.42.0

