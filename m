Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054444;
	b=HpOFNWhIaSuaz1WRzk0/X3yv81xOvt/EsBU7P8ziD0sjcmxNFQsBVpFtnf8081nj27E6
	 /UqztadfrTYK1nVwlOLcrJ72O/jO1NmVjVAbW0+Jh2Of4wT5rkxKiPsR/+v7h2FfXOpM5
	 Hrkdc2VxIwqVIVjoa9xtHBsl9oMfFlMGQT6IKcxR4QrP01uPBlX+62AENnNc1RMPuaIC/
	 iOY1sOwWhvD5PRqPFi+mdCUve33jvUvoBdZWkCLZpcAN6GZkBdw9vbP+ho983Iod9EpMq
	 qt11T16RRBDu/H/AriZL2XCXVNydg8mwZYapQSQFkW5vr8E3FEP0tnZzlQ55XKbE0fQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054444;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6uSd1ZWXfJZZYPJPPWe7I3E8M21r2rrzsjEZx2zHZq0=;
	b=RuTA9Wjpoz+MlEaHQHWIolIbgzjhWXMQPRCaYh3P3bsOmWT1RuSOTqqyQsVAS69qyQk+
	 Hlb1b3M4vu5QkIpMWBZrINHB0Zl7ocKeD716COmYMIfBM2+TkO9zVDsr5fTOe0ebph0Wp
	 Xeq0iSaS2Ur2NtzUEdDBVoceGzWy3ZxxWDIofjVSw0+f33Yae9LCIV7YWsrFzy91pGcrn
	 wU8mKOtxsHSeaOZURcJwdVdu5KXnRI3mW7Yw7V/q/UfvpecoZ6jh1AdHjdyWUmfCOUZev
	 nJuQ6Mwx8qYqFcXEzAEUuEpi4QhIKb1DhZ+x1X2xYPHcGovfODuMZ399ZdPdn6Wfbmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tbQpE+7+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB379606A320;
	Thu, 19 Nov 2026 02:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tbQpE+7+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5109A1F000C4;
	Thu, 19 Nov 2026 02:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054443;
	bh=6uSd1ZWXfJZZYPJPPWe7I3E8M21r2rrzsjEZx2zHZq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tbQpE+7+FrpCVK49u9EfwQ/7FwXa0J+NYa7Jz4InMfpbyyJvN+pzNbl9vxvM0pkSw
	 FTRnVOUpS3AsUapTtGgnwwspZnoC+v59hy1tBUL0pl2yJ4UdX9T9AMlF/HqHOv414t
	 VrzlnvHvDmoy5rtJpfuyBvItE0bhqgLu5bpp45yQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eklavya Singh <eklavyasingh2106@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	syzbot+5d4e96acd0febccb5e87@syzkaller.appspotmail.com,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Heming Zhao <heming.zhao@suse.com>,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	Cen Zhang <zzzccc427@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1275/2214] ocfs2/heartbeat: serialize concurrent writes to a regions dev attribute
Date: Wed, 18 Nov 2026 15:49:11 +0100
Message-ID: <20261118150102.589742109@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eklavya Singh <eklavyasingh2106@gmail.com>

[ Upstream commit 0a8f258c0f012314c36b9e4818cdc0178c68f891 ]

o2hb_region_dev_store() checks reg->hr_bdev_file to see if the region
is already started, but nothing stops two writers from doing that at
the same time. configfs only serializes writes through the same open
file, so two processes that each open the dev attribute can both get
past the check:

  A: hr_bdev_file is NULL, opens file A, sets hr_bdev_file = A
  B: hr_bdev_file is NULL, opens file B, sets hr_bdev_file = B
  A: start fails, fput(hr_bdev_file) drops B, sets it to NULL
  B: start fails, fput(NULL)

Both calls also use the same hr_slots, hr_slot_data and hr_tmp_block,
so the error paths can free the slot data twice.

syzbot hit the fput(NULL) with an unbound loop device, where every
start fails with -EIO. With four threads doing the same thing on a
KASAN kernel I get both crashes within a second:

  BUG: KASAN: double-free in o2hb_unmap_slot_data+0x14d/0x2f0
  BUG: kernel NULL pointer dereference, address: 0000000000000158

Add a mutex to the region and hold it in dev_store(), in the
block_bytes, start_block and blocks stores, and in dev_show(), since
they all look at hr_bdev_file. dev_store() cleans up with goto, so it
takes the mutex in a small wrapper rather than with guard(). The mutex
is dropped while dev_store() waits for the heartbeat to become steady,
which takes seconds, so a read of dev doesn't stall behind a start.
hr_bdev_file is already set at that point, so other writers still get
-EINVAL, and the cleanup after the wait retakes the mutex.

With the patch the same test ran for 10 minutes with lockdep on and
nothing was reported. So did a second one, with a working loop device,
that interrupts starts during the wait while other threads read and
write the attributes.

Link: https://lore.kernel.org/20261020212339.46591-1-eklavyasingh2106@gmail.com
Fixes: a7f6a5fb4bde ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Signed-off-by: Eklavya Singh <eklavyasingh2106@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: <syzbot+5d4e96acd0febccb5e87@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=5d4e96acd0febccb5e87
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: Cen Zhang <zzzccc427@gmail.com>
Cc: <stable@vger.kernel.org>
[ sashal: replaced scoped mutex guards and the wrapper/helper split with explicit locking and shared unlock exits in the existing callbacks ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/cluster/heartbeat.c | 65 +++++++++++++++++++++++++-----------
 1 file changed, 45 insertions(+), 20 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 33e2728c28a4e..b2b7aa46932be 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -266,6 +266,8 @@ struct o2hb_region {
 	/* Message key for negotiate timeout message. */
 	unsigned int		hr_key;
 	struct list_head	hr_handler_list;
+	/* Serializes the dev, block_bytes, start_block and blocks attributes. */
+	struct mutex		hr_dev_mutex;
 
 	/* last hb status, 0 for success, other value for error. */
 	int			hr_last_hb_status;
@@ -1599,22 +1601,25 @@ static ssize_t o2hb_region_block_bytes_store(struct config_item *item,
 					     size_t count)
 {
 	struct o2hb_region *reg = to_o2hb_region(item);
-	int status;
+	ssize_t status = -EINVAL;
 	unsigned long block_bytes;
 	unsigned int block_bits;
 
+	mutex_lock(&reg->hr_dev_mutex);
 	if (reg->hr_bdev)
-		return -EINVAL;
+		goto out;
 
 	status = o2hb_read_block_input(reg, page, &block_bytes,
 				       &block_bits);
 	if (status)
-		return status;
+		goto out;
 
 	reg->hr_block_bytes = (unsigned int)block_bytes;
 	reg->hr_block_bits = block_bits;
-
-	return count;
+	status = count;
+out:
+	mutex_unlock(&reg->hr_dev_mutex);
+	return status;
 }
 
 static ssize_t o2hb_region_start_block_show(struct config_item *item,
@@ -1630,18 +1635,20 @@ static ssize_t o2hb_region_start_block_store(struct config_item *item,
 	struct o2hb_region *reg = to_o2hb_region(item);
 	unsigned long long tmp;
 	char *p = (char *)page;
-	ssize_t ret;
+	ssize_t ret = -EINVAL;
 
+	mutex_lock(&reg->hr_dev_mutex);
 	if (reg->hr_bdev)
-		return -EINVAL;
+		goto out;
 
-	ret = kstrtoull(p, 0, &tmp);
-	if (ret)
-		return -EINVAL;
+	if (kstrtoull(p, 0, &tmp))
+		goto out;
 
 	reg->hr_start_block = tmp;
-
-	return count;
+	ret = count;
+out:
+	mutex_unlock(&reg->hr_dev_mutex);
+	return ret;
 }
 
 static ssize_t o2hb_region_blocks_show(struct config_item *item, char *page)
@@ -1656,28 +1663,37 @@ static ssize_t o2hb_region_blocks_store(struct config_item *item,
 	struct o2hb_region *reg = to_o2hb_region(item);
 	unsigned long tmp;
 	char *p = (char *)page;
+	ssize_t ret = -EINVAL;
 
+	mutex_lock(&reg->hr_dev_mutex);
 	if (reg->hr_bdev)
-		return -EINVAL;
+		goto out;
 
 	tmp = simple_strtoul(p, &p, 0);
 	if (!p || (*p && (*p != '\n')))
-		return -EINVAL;
+		goto out;
 
-	if (tmp > O2NM_MAX_NODES || tmp == 0)
-		return -ERANGE;
+	if (tmp > O2NM_MAX_NODES || tmp == 0) {
+		ret = -ERANGE;
+		goto out;
+	}
 
 	reg->hr_blocks = (unsigned int)tmp;
-
-	return count;
+	ret = count;
+out:
+	mutex_unlock(&reg->hr_dev_mutex);
+	return ret;
 }
 
 static ssize_t o2hb_region_dev_show(struct config_item *item, char *page)
 {
+	struct o2hb_region *reg = to_o2hb_region(item);
 	unsigned int ret = 0;
 
-	if (to_o2hb_region(item)->hr_bdev)
-		ret = sprintf(page, "%s\n", to_o2hb_region(item)->hr_dev_name);
+	mutex_lock(&reg->hr_dev_mutex);
+	if (reg->hr_bdev)
+		ret = sprintf(page, "%s\n", reg->hr_dev_name);
+	mutex_unlock(&reg->hr_dev_mutex);
 
 	return ret;
 }
@@ -1800,6 +1816,7 @@ static ssize_t o2hb_region_dev_store(struct config_item *item,
 	ssize_t ret = -EINVAL;
 	int live_threshold;
 
+	mutex_lock(&reg->hr_dev_mutex);
 	if (reg->hr_bdev)
 		goto out;
 
@@ -1900,9 +1917,15 @@ static ssize_t o2hb_region_dev_store(struct config_item *item,
 	reg->hr_task = hb_task;
 	spin_unlock(&o2hb_live_lock);
 
+	/*
+	 * Don't hold hr_dev_mutex across the wait, which can take seconds.
+	 * hr_bdev is already set, so other writers still get -EINVAL.
+	 */
+	mutex_unlock(&reg->hr_dev_mutex);
 	ret = wait_event_interruptible(o2hb_steady_queue,
 				atomic_read(&reg->hr_steady_iterations) == 0 ||
 				reg->hr_node_deleted);
+	mutex_lock(&reg->hr_dev_mutex);
 	if (ret) {
 		atomic_set(&reg->hr_steady_iterations, 0);
 		reg->hr_aborted_start = 1;
@@ -1942,6 +1965,7 @@ static ssize_t o2hb_region_dev_store(struct config_item *item,
 out2:
 	fdput(f);
 out:
+	mutex_unlock(&reg->hr_dev_mutex);
 	return ret;
 }
 
@@ -2045,6 +2069,7 @@ static struct config_item *o2hb_heartbeat_group_make_item(struct config_group *g
 	}
 
 	INIT_LIST_HEAD(&reg->hr_all_item);
+	mutex_init(&reg->hr_dev_mutex);
 	INIT_LIST_HEAD(&reg->hr_handler_list);
 	config_item_init_type_name(&reg->hr_item, name, &o2hb_region_type);
 	if (!config_item_name(&reg->hr_item)) {
-- 
2.53.0



