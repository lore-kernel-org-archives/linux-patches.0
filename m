Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 658A113EFEE
	for <patches@lists.linux.dev>; Fri, 19 Jul 2024 13:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721396571; cv=none; b=sKCmzciY24OIA8RaNGg9njNBovbPG8AOWFKpiUPpwVMzafN84Tlc/QMsdMx5T9UxiIaxYqLv5OKFA7JYlZVGdHQZ44zS6WsXBtwjjxIVBUs4PNXLt4mnBBB9U40p5I7FFYwUQa8D8KRxWl5dgYqppkfajynDJu/nTz8O45XHYM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721396571; c=relaxed/simple;
	bh=5Xyo9Z8HEBObc3GMtYbYha/tdVP6bcZMry1yh8vyRWs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ghkVEaZgYQUWxwAdgBuZ/gJJ6qTIlm02Dje+LXZ6v/KVYGmmsK/Yhm0nLkbsZDKxcEeZtntYxXXn+xVPzkN8n3s1qtYQRk2pdR3ZKTc7MQz7YT0PtU4nvFdC8Fweugau4WLxvlOJX7VFVM4dhOipAUpvs/D6NLGslro+TmMKdt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4WQW7r6vTLz4f3jY9
	for <patches@lists.linux.dev>; Fri, 19 Jul 2024 21:42:32 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 252211A0572
	for <patches@lists.linux.dev>; Fri, 19 Jul 2024 21:42:45 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgCnizlSbZpm4AxQAg--.12422S4;
	Fri, 19 Jul 2024 21:42:44 +0800 (CST)
From: libaokun@huaweicloud.com
To: stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	patches@lists.linux.dev,
	hsiangkao@linux.alibaba.com,
	yangerkun@huawei.com,
	libaokun1@huawei.com,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.6 1/3] netfs, fscache: export fscache_put_volume() and add fscache_try_get_volume()
Date: Fri, 19 Jul 2024 21:40:02 +0800
Message-Id: <20240719134004.1584648-1-libaokun@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCnizlSbZpm4AxQAg--.12422S4
X-Coremail-Antispam: 1UD129KBjvJXoWxCr4fXF1kAryxGF1rXrW5Jrb_yoW5Kr18p3
	9rCrn7trW8Xw1xG3y5Xw47Zr1fZ3yDKa1kG348Gw15Zw4xtry5XF12yw15ZF13Z348JrWI
	yF1Utryjgw1UAr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkGb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4kE6xkIj40Ew7xC0wCY1x0262kKe7AKxVWU
	AVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
	v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkG
	c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4U
	MIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07UX_-9UUU
	UU=
X-CM-SenderInfo: 5olet0hnxqqx5xdzvxpfor3voofrz/1tbiAgAJBWaaJBUUpAAAsz

From: Baokun Li <libaokun1@huawei.com>

[ Upstream commit 85b08b31a22b481ec6528130daf94eee4452e23f ]

Export fscache_put_volume() and add fscache_try_get_volume()
helper function to allow cachefiles to get/put fscache_volume
via linux/fscache-cache.h.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Link: https://lore.kernel.org/r/20240628062930.2467993-2-libaokun@huaweicloud.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 522018a0de6b ("cachefiles: fix slab-use-after-free in fscache_withdraw_volume()")
Stable-dep-of: 5d8f80578907 ("cachefiles: fix slab-use-after-free in cachefiles_withdraw_cookie()")
Signed-off-by: Baokun Li <libaokun1@huawei.com>
---
 fs/fscache/internal.h         |  2 --
 fs/fscache/volume.c           | 14 ++++++++++++++
 include/linux/fscache-cache.h |  6 ++++++
 3 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/fs/fscache/internal.h b/fs/fscache/internal.h
index 1336f517e9b1..4799a722bc28 100644
--- a/fs/fscache/internal.h
+++ b/fs/fscache/internal.h
@@ -145,8 +145,6 @@ extern const struct seq_operations fscache_volumes_seq_ops;
 
 struct fscache_volume *fscache_get_volume(struct fscache_volume *volume,
 					  enum fscache_volume_trace where);
-void fscache_put_volume(struct fscache_volume *volume,
-			enum fscache_volume_trace where);
 bool fscache_begin_volume_access(struct fscache_volume *volume,
 				 struct fscache_cookie *cookie,
 				 enum fscache_access_trace why);
diff --git a/fs/fscache/volume.c b/fs/fscache/volume.c
index cdf991bdd9de..cb75c07b5281 100644
--- a/fs/fscache/volume.c
+++ b/fs/fscache/volume.c
@@ -27,6 +27,19 @@ struct fscache_volume *fscache_get_volume(struct fscache_volume *volume,
 	return volume;
 }
 
+struct fscache_volume *fscache_try_get_volume(struct fscache_volume *volume,
+					      enum fscache_volume_trace where)
+{
+	int ref;
+
+	if (!__refcount_inc_not_zero(&volume->ref, &ref))
+		return NULL;
+
+	trace_fscache_volume(volume->debug_id, ref + 1, where);
+	return volume;
+}
+EXPORT_SYMBOL(fscache_try_get_volume);
+
 static void fscache_see_volume(struct fscache_volume *volume,
 			       enum fscache_volume_trace where)
 {
@@ -420,6 +433,7 @@ void fscache_put_volume(struct fscache_volume *volume,
 			fscache_free_volume(volume);
 	}
 }
+EXPORT_SYMBOL(fscache_put_volume);
 
 /*
  * Relinquish a volume representation cookie.
diff --git a/include/linux/fscache-cache.h b/include/linux/fscache-cache.h
index a174cedf4d90..35e86d2f2887 100644
--- a/include/linux/fscache-cache.h
+++ b/include/linux/fscache-cache.h
@@ -19,6 +19,7 @@
 enum fscache_cache_trace;
 enum fscache_cookie_trace;
 enum fscache_access_trace;
+enum fscache_volume_trace;
 
 enum fscache_cache_state {
 	FSCACHE_CACHE_IS_NOT_PRESENT,	/* No cache is present for this name */
@@ -97,6 +98,11 @@ extern void fscache_withdraw_cookie(struct fscache_cookie *cookie);
 
 extern void fscache_io_error(struct fscache_cache *cache);
 
+extern struct fscache_volume *
+fscache_try_get_volume(struct fscache_volume *volume,
+		       enum fscache_volume_trace where);
+extern void fscache_put_volume(struct fscache_volume *volume,
+			       enum fscache_volume_trace where);
 extern void fscache_end_volume_access(struct fscache_volume *volume,
 				      struct fscache_cookie *cookie,
 				      enum fscache_access_trace why);
-- 
2.39.2

