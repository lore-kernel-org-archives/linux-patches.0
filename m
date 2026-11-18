Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060083;
	b=TqxHmxN/vzOfqRTfBJ2Inh1ifc5fht/Gq6/1iFIUbh9/ms5GlYScZ56zaAdxUCZtJC2B
	 yiUP744Vbhc4l1/OwEDHfXP+bcgd/AaC8ZveGyJctBeBAVLlvxrMvl8ta5Wbr3UZqYplT
	 HA2yk6QJBDPjUpha5newuHjKV8gb0k34wYM3L0leQpo5XR3Cwp0XMBYQCFnavaWMnSayx
	 52tSRYgAEJqEKKHEZcrNtueXdbgMZUl8NTD1ONT9TKbf0MhZqKGzNaLekk/UsOSyXk9Sp
	 hW2bI7iCGy+c90UYGopewOzLcrSeSdVP3t9t8Ct1QM8CWMhBQCyA95LjgsLgSe33K7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060083;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5NlbaeiR3kOuOHVcMvDRCxI+sTVrJPqcVHYaMdGBo+g=;
	b=nJJMpkz1ZzKea4nv1kIK7LD3p64VaDHlGrjSnT+ioo3fqEvill7+zWTYYmgt40zXB4r4
	 NFqEyuKJrp8oAlYXAA7yXl7Qp6ZEBvb5TyAhAp4BJdXCKlpjYaoEa2E0u62O566zHbtuq
	 3y4+ZQfGHbKkPPbdA2OGtAszBybw+SxWmZQpa8PIC325RPdCV5xRvRvmlnMV1DjMSuUZo
	 MV3RDmWxPTE9ByfOXLUTD+AKE/iTyyYPb4ZGM9PIVJ/j5k2EAXFHFdkoiSxcVahNevsos
	 BWEM5hD98k9PIsC1XB8tsD81PguxyeenyMFgDS76QrZ8Ui1RcsCHZEXli5J2ytrPTyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XCc5f7Gr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A39C606A320;
	Thu, 19 Nov 2026 03:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XCc5f7Gr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFDE41F000C4;
	Thu, 19 Nov 2026 03:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060083;
	bh=5NlbaeiR3kOuOHVcMvDRCxI+sTVrJPqcVHYaMdGBo+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XCc5f7GrmPSKqCDobWRfkPoAqzk2o+PBw5Cu9Ke6H2CYdrXYmy90VlWgXyYjwHQlF
	 TawUdd9PSAIn17bj8hdXAZXKkZgBxWP14piosEjLHWEifvt6N1icKwOFzpz2ix7+sZ
	 9C4d03j1AksO6hsFks3UuWd9yZ1+L7xGnylgZtBo=
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
Subject: [PATCH 5.10 1073/1848] ocfs2/heartbeat: serialize concurrent writes to a regions dev attribute
Date: Wed, 18 Nov 2026 15:51:51 +0100
Message-ID: <20261118150002.933992168@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: replaced the wrapper/helper split with direct mutex locking in dev_store() and unlocking at its common exit ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/cluster/heartbeat.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 938425dce6e9a..9182b9a0dbe8d 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -268,6 +268,8 @@ struct o2hb_region {
 	/* Message key for negotiate timeout message. */
 	unsigned int		hr_key;
 	struct list_head	hr_handler_list;
+	/* Serializes the dev, block_bytes, start_block and blocks attributes. */
+	struct mutex		hr_dev_mutex;
 
 	/* last hb status, 0 for success, other value for error. */
 	int			hr_last_hb_status;
@@ -1607,6 +1609,7 @@ static ssize_t o2hb_region_block_bytes_store(struct config_item *item,
 	unsigned long block_bytes;
 	unsigned int block_bits;
 
+	guard(mutex)(&reg->hr_dev_mutex);
 	if (reg->hr_bdev)
 		return -EINVAL;
 
@@ -1635,6 +1638,7 @@ static ssize_t o2hb_region_start_block_store(struct config_item *item,
 	unsigned long long tmp;
 	char *p = (char *)page;
 
+	guard(mutex)(&reg->hr_dev_mutex);
 	if (reg->hr_bdev)
 		return -EINVAL;
 
@@ -1660,6 +1664,7 @@ static ssize_t o2hb_region_blocks_store(struct config_item *item,
 	unsigned long tmp;
 	char *p = (char *)page;
 
+	guard(mutex)(&reg->hr_dev_mutex);
 	if (reg->hr_bdev)
 		return -EINVAL;
 
@@ -1677,10 +1682,12 @@ static ssize_t o2hb_region_blocks_store(struct config_item *item,
 
 static ssize_t o2hb_region_dev_show(struct config_item *item, char *page)
 {
+	struct o2hb_region *reg = to_o2hb_region(item);
 	unsigned int ret = 0;
 
-	if (to_o2hb_region(item)->hr_bdev)
-		ret = sprintf(page, "%s\n", to_o2hb_region(item)->hr_dev_name);
+	guard(mutex)(&reg->hr_dev_mutex);
+	if (reg->hr_bdev)
+		ret = sprintf(page, "%s\n", reg->hr_dev_name);
 
 	return ret;
 }
@@ -1803,6 +1810,7 @@ static ssize_t o2hb_region_dev_store(struct config_item *item,
 	ssize_t ret = -EINVAL;
 	int live_threshold;
 
+	mutex_lock(&reg->hr_dev_mutex);
 	if (reg->hr_bdev)
 		goto out;
 
@@ -1903,9 +1911,15 @@ static ssize_t o2hb_region_dev_store(struct config_item *item,
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
@@ -1945,6 +1959,7 @@ static ssize_t o2hb_region_dev_store(struct config_item *item,
 out2:
 	fdput(f);
 out:
+	mutex_unlock(&reg->hr_dev_mutex);
 	return ret;
 }
 
@@ -2048,6 +2063,7 @@ static struct config_item *o2hb_heartbeat_group_make_item(struct config_group *g
 	}
 
 	INIT_LIST_HEAD(&reg->hr_all_item);
+	mutex_init(&reg->hr_dev_mutex);
 	INIT_LIST_HEAD(&reg->hr_handler_list);
 	config_item_init_type_name(&reg->hr_item, name, &o2hb_region_type);
 	if (!config_item_name(&reg->hr_item)) {
-- 
2.53.0



