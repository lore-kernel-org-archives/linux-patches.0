Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047647;
	b=tFOIHt2vEBj7t0TniDl7LAx/1a+sCfb+LvRDx8JDSqTbNgKB/SnD/G2gSVXvWtyICXvc
	 5prdh3WIBcnJoJfFSmO9tLh9HpJoH9d1VhcnvDQeplLkoIZ5hSmc6kan+3ThHqFsKVZtH
	 32CjnILJ/xJUWsS7TPc8W4SZqu7BMKoW3QZrv78MbDJh7eFjBj8oEyQyjSvE0EUIF9CY9
	 hN5djTNWKYt5RdovsOVRK1Y6HkK7sh0MHCcY9DlhMcujYQSHg1AmnvI0IpAZ9hSg5CEX+
	 YSYOLN3wqpuWPu4Bw1+ftod8y6yis3ZEqZWXWcXfl/m4g6z6Iam1Y9m5qDvwQSgthaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047647;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ryq2YJagZP65LrAnpjNz/ieullQbCGnSfPWIdGxH+YU=;
	b=YUAUxRL86FdxOTMxZ/wumlgftSZGrrbYv6lQRTG8eP3tKFCBRrHans2ouRAGqLlOoQXr
	 ZGBrG1r6HCtZZpugpbnXa5byGn+55yRr8+gwZLf1qFJi/qBjGzTrVwbFRnH30GVjER9EP
	 3/pxJ0Y8SAt9WtIvesINLaPq0Ujinah5WQgyZKgGDy/thomuaI8CgCLPhSMY6mFQrdBlF
	 bOfXkJ1OqzA2vecvlE84WfKaYpw9Z7+DYYhfMi7NqgVXZ5cmZDfafg2v/byA6Kub+gc1O
	 GYjgs4LRtZ6HfrkG9dKiVEeFNsRBRIzFWRKbannqavTtPSisnrEIzOqTbaANkNbX9aQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AwVQiizW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76915606A320;
	Thu, 19 Nov 2026 00:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AwVQiizW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBB071F000C4;
	Thu, 19 Nov 2026 00:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047647;
	bh=ryq2YJagZP65LrAnpjNz/ieullQbCGnSfPWIdGxH+YU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AwVQiizWEtYtf7J9Z4aqMNaU1jAUbVXnVfzOdmxcXjxF2zO5EDUplXg/UlyHtW5FE
	 kzFd6bQ9s2yLyDvBkfo0WGF7WhvPNA8wLoLi6rxciBHKudrqRtC2aCtaidSfo+G3v+
	 mXwe3nAT+oR8PWISv3JrB2LXdNU5mSZ2Rj1Qs77I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Muchun Song <songmuchun@bytedance.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1712/2857] mm: hugetlb: move hugeltb sysctls to its own file
Date: Wed, 18 Nov 2026 15:45:46 +0100
Message-ID: <20261118150302.970816368@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kefeng Wang <wangkefeng.wang@huawei.com>

[ Upstream commit 962de54828c5bb100eb8de881b79ed9c8b7468c0 ]

This moves all hugetlb sysctls to its own file, also kill an
useless hugetlb_treat_movable_handler() defination.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Stable-dep-of: dfb190302d2b ("mm/hugetlb: fix mremap move length truncation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/hugetlb.h |  8 -------
 kernel/sysctl.c         | 32 --------------------------
 mm/hugetlb.c            | 51 ++++++++++++++++++++++++++++++++++++++---
 3 files changed, 48 insertions(+), 43 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index aa089e58bc41f..a9f175cda955c 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -137,14 +137,6 @@ void hugepage_put_subpool(struct hugepage_subpool *spool);
 
 void hugetlb_dup_vma_private(struct vm_area_struct *vma);
 void clear_vma_resv_huge_pages(struct vm_area_struct *vma);
-int hugetlb_sysctl_handler(struct ctl_table *, int, void *, size_t *, loff_t *);
-int hugetlb_overcommit_handler(struct ctl_table *, int, void *, size_t *,
-		loff_t *);
-int hugetlb_treat_movable_handler(struct ctl_table *, int, void *, size_t *,
-		loff_t *);
-int hugetlb_mempolicy_sysctl_handler(struct ctl_table *, int, void *, size_t *,
-		loff_t *);
-
 int move_hugetlb_page_tables(struct vm_area_struct *vma,
 			     struct vm_area_struct *new_vma,
 			     unsigned long old_addr, unsigned long new_addr,
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 5dd6fd4b48c81..e1a964ef48617 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -2162,38 +2162,6 @@ static struct ctl_table vm_table[] = {
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= SYSCTL_ONE,
 	},
-#endif
-#ifdef CONFIG_HUGETLB_PAGE
-	{
-		.procname	= "nr_hugepages",
-		.data		= NULL,
-		.maxlen		= sizeof(unsigned long),
-		.mode		= 0644,
-		.proc_handler	= hugetlb_sysctl_handler,
-	},
-#ifdef CONFIG_NUMA
-	{
-		.procname       = "nr_hugepages_mempolicy",
-		.data           = NULL,
-		.maxlen         = sizeof(unsigned long),
-		.mode           = 0644,
-		.proc_handler   = &hugetlb_mempolicy_sysctl_handler,
-	},
-#endif
-	 {
-		.procname	= "hugetlb_shm_group",
-		.data		= &sysctl_hugetlb_shm_group,
-		.maxlen		= sizeof(gid_t),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-	 },
-	{
-		.procname	= "nr_overcommit_hugepages",
-		.data		= NULL,
-		.maxlen		= sizeof(unsigned long),
-		.mode		= 0644,
-		.proc_handler	= hugetlb_overcommit_handler,
-	},
 #endif
 	{
 		.procname	= "lowmem_reserve_ratio",
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index a4b5243281af0..f036b1d5babc7 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4274,6 +4274,12 @@ static void __init hugetlb_sysfs_init(void)
 	hugetlb_register_all_nodes();
 }
 
+#ifdef CONFIG_SYSCTL
+static void hugetlb_sysctl_init(void);
+#else
+static inline void hugetlb_sysctl_init(void) { }
+#endif
+
 static int __init hugetlb_init(void)
 {
 	int i;
@@ -4329,6 +4335,7 @@ static int __init hugetlb_init(void)
 
 	hugetlb_sysfs_init();
 	hugetlb_cgroup_file_init();
+	hugetlb_sysctl_init();
 
 #ifdef CONFIG_SMP
 	num_fault_mutexes = roundup_pow_of_two(8 * num_possible_cpus());
@@ -4660,7 +4667,7 @@ static int hugetlb_sysctl_handler_common(bool obey_mempolicy,
 	return ret;
 }
 
-int hugetlb_sysctl_handler(struct ctl_table *table, int write,
+static int hugetlb_sysctl_handler(struct ctl_table *table, int write,
 			  void *buffer, size_t *length, loff_t *ppos)
 {
 
@@ -4669,7 +4676,7 @@ int hugetlb_sysctl_handler(struct ctl_table *table, int write,
 }
 
 #ifdef CONFIG_NUMA
-int hugetlb_mempolicy_sysctl_handler(struct ctl_table *table, int write,
+static int hugetlb_mempolicy_sysctl_handler(struct ctl_table *table, int write,
 			  void *buffer, size_t *length, loff_t *ppos)
 {
 	return hugetlb_sysctl_handler_common(true, table, write,
@@ -4677,7 +4684,7 @@ int hugetlb_mempolicy_sysctl_handler(struct ctl_table *table, int write,
 }
 #endif /* CONFIG_NUMA */
 
-int hugetlb_overcommit_handler(struct ctl_table *table, int write,
+static int hugetlb_overcommit_handler(struct ctl_table *table, int write,
 		void *buffer, size_t *length, loff_t *ppos)
 {
 	struct hstate *h = &default_hstate;
@@ -4706,6 +4713,44 @@ int hugetlb_overcommit_handler(struct ctl_table *table, int write,
 	return ret;
 }
 
+static struct ctl_table hugetlb_table[] = {
+	{
+		.procname	= "nr_hugepages",
+		.data		= NULL,
+		.maxlen		= sizeof(unsigned long),
+		.mode		= 0644,
+		.proc_handler	= hugetlb_sysctl_handler,
+	},
+#ifdef CONFIG_NUMA
+	{
+		.procname       = "nr_hugepages_mempolicy",
+		.data           = NULL,
+		.maxlen         = sizeof(unsigned long),
+		.mode           = 0644,
+		.proc_handler   = &hugetlb_mempolicy_sysctl_handler,
+	},
+#endif
+	{
+		.procname	= "hugetlb_shm_group",
+		.data		= &sysctl_hugetlb_shm_group,
+		.maxlen		= sizeof(gid_t),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+	{
+		.procname	= "nr_overcommit_hugepages",
+		.data		= NULL,
+		.maxlen		= sizeof(unsigned long),
+		.mode		= 0644,
+		.proc_handler	= hugetlb_overcommit_handler,
+	},
+	{ }
+};
+
+static void hugetlb_sysctl_init(void)
+{
+	register_sysctl_init("vm", hugetlb_table);
+}
 #endif /* CONFIG_SYSCTL */
 
 void hugetlb_report_meminfo(struct seq_file *m)
-- 
2.53.0



