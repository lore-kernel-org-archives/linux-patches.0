Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A3163F788A;
	Sat, 12 Sep 2026 16:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230917; cv=none; b=Fbr0ERog8FWRKBqnOiVeLc4e/hYmcihI5HXIbHQ704iAC+u0XsMjiyXce30Uzxecbx7E0r5dGi2RTADZ+65b5bDzY1oAv36VKdpDut5TMybCmhTuTFNPRNqjQuVu8ZYZP7jIHzHNjCFkaUVl2GKRNBuOCkL/fKBXt1T8nBT/XHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230917; c=relaxed/simple;
	bh=rWyqCDi25PolPhDGERB1MXvpTvcDEMTHpSIVbmwHNuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ogwccIaPz97Y14IZLG/WxNg7om+yxte71X6K+waC9P5jQwyp9rwZ3IswJzEvBIcpnREM3vSg27YRJBgVxNUT4qJOv/7uy+8eBKDfpaUZyHVWXLTdwLu63s0UBrPwNwQvPblXmpoPE0bqCfLdFUn0kwsU1f5E4wNGWGC4txQlztw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H23+SwMu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H23+SwMu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C94B21F000FF;
	Sat, 12 Sep 2026 16:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230915;
	bh=XVBTFO0Ob+tnYunXfhrJRAc77mAw6KXLd8BHMQ03d8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H23+SwMuOtu6Ud1oL17GKxMQzowyDuiQiF/BVa+r0xpGDi1sfLplnU8Bda9zRaAQ6
	 1P3csp1/5mKWoUbucQceK6OFFp9knDBLZ4b1gUN8pOXxx1SIXb13/d3BJ2LCqOHfTB
	 vo1HRQxAZJKqo7S/5Sk28j/qRGoYDwbY6JIkWqfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Changwei Ge <gechangwei@live.cn>,
	Gang He <ghe@suse.com>,
	Joel Becker <jlbec@evilplan.org>,
	Jun Piao <piaojun@huawei.com>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Mark Fasheh <mark@fasheh.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0875/1191] ocfs2: use bitmap API in fill_node_map
Date: Sat, 12 Sep 2026 09:00:03 +0200
Message-ID: <20260912065607.903708598@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joseph Qi <joseph.qi@linux.alibaba.com>

[ Upstream commit 6d4a93b6809270e5c7d7216b20f4ef2e88213eb3 ]

Pass bits directly into fill_node_map helper and use bitmap API directly
to simplify code.

Link: https://lkml.kernel.org/r/20221007124846.186453-2-joseph.qi@linux.alibaba.com
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 3e326f3bf165 ("ocfs2: synchronize heartbeat callbacks with o2net teardown")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/cluster/heartbeat.c | 18 ++++++++----------
 fs/ocfs2/cluster/heartbeat.h |  2 +-
 fs/ocfs2/cluster/netdebug.c  |  2 +-
 fs/ocfs2/cluster/tcp.c       |  6 ++----
 fs/ocfs2/dlm/dlmdomain.c     |  2 +-
 fs/ocfs2/stack_o2cb.c        |  6 +++---
 6 files changed, 16 insertions(+), 20 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index a7e2195012cdd..ba6102ad748f1 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -383,7 +383,7 @@ static void o2hb_nego_timeout(struct work_struct *work)
 	if (reg->hr_last_hb_status)
 		return;
 
-	o2hb_fill_node_map(live_node_bitmap, sizeof(live_node_bitmap));
+	o2hb_fill_node_map(live_node_bitmap, O2NM_MAX_NODES);
 	/* lowest node as master node to make negotiate decision. */
 	master_node = find_first_bit(live_node_bitmap, O2NM_MAX_NODES);
 
@@ -1095,7 +1095,7 @@ static int o2hb_do_disk_heartbeat(struct o2hb_region *reg)
 	 * If a node is not configured but is in the livemap, we still need
 	 * to read the slot so as to be able to remove it from the livemap.
 	 */
-	o2hb_fill_node_map(live_node_bitmap, sizeof(live_node_bitmap));
+	o2hb_fill_node_map(live_node_bitmap, O2NM_MAX_NODES);
 	i = -1;
 	while ((i = find_next_bit(live_node_bitmap,
 				  O2NM_MAX_NODES, i + 1)) < O2NM_MAX_NODES) {
@@ -1458,23 +1458,21 @@ void o2hb_init(void)
 
 /* if we're already in a callback then we're already serialized by the sem */
 static void o2hb_fill_node_map_from_callback(unsigned long *map,
-					     unsigned bytes)
+					     unsigned int bits)
 {
-	BUG_ON(bytes < (BITS_TO_LONGS(O2NM_MAX_NODES) * sizeof(unsigned long)));
-
-	memcpy(map, &o2hb_live_node_bitmap, bytes);
+	bitmap_copy(map, o2hb_live_node_bitmap, bits);
 }
 
 /*
  * get a map of all nodes that are heartbeating in any regions
  */
-void o2hb_fill_node_map(unsigned long *map, unsigned bytes)
+void o2hb_fill_node_map(unsigned long *map, unsigned int bits)
 {
 	/* callers want to serialize this map and callbacks so that they
 	 * can trust that they don't miss nodes coming to the party */
 	down_read(&o2hb_callback_sem);
 	spin_lock(&o2hb_live_lock);
-	o2hb_fill_node_map_from_callback(map, bytes);
+	o2hb_fill_node_map_from_callback(map, bits);
 	spin_unlock(&o2hb_live_lock);
 	up_read(&o2hb_callback_sem);
 }
@@ -2544,7 +2542,7 @@ int o2hb_check_node_heartbeating_no_sem(u8 node_num)
 	unsigned long testing_map[BITS_TO_LONGS(O2NM_MAX_NODES)];
 
 	spin_lock(&o2hb_live_lock);
-	o2hb_fill_node_map_from_callback(testing_map, sizeof(testing_map));
+	o2hb_fill_node_map_from_callback(testing_map, O2NM_MAX_NODES);
 	spin_unlock(&o2hb_live_lock);
 	if (!test_bit(node_num, testing_map)) {
 		mlog(ML_HEARTBEAT,
@@ -2561,7 +2559,7 @@ int o2hb_check_node_heartbeating_from_callback(u8 node_num)
 {
 	unsigned long testing_map[BITS_TO_LONGS(O2NM_MAX_NODES)];
 
-	o2hb_fill_node_map_from_callback(testing_map, sizeof(testing_map));
+	o2hb_fill_node_map_from_callback(testing_map, O2NM_MAX_NODES);
 	if (!test_bit(node_num, testing_map)) {
 		mlog(ML_HEARTBEAT,
 		     "node (%u) does not have heartbeating enabled.\n",
diff --git a/fs/ocfs2/cluster/heartbeat.h b/fs/ocfs2/cluster/heartbeat.h
index 1d4100abf6f87..8ef8c1b9eeb76 100644
--- a/fs/ocfs2/cluster/heartbeat.h
+++ b/fs/ocfs2/cluster/heartbeat.h
@@ -59,7 +59,7 @@ int o2hb_register_callback(const char *region_uuid,
 void o2hb_unregister_callback(const char *region_uuid,
 			      struct o2hb_callback_func *hc);
 void o2hb_fill_node_map(unsigned long *map,
-			unsigned bytes);
+			unsigned int bits);
 void o2hb_exit(void);
 void o2hb_init(void);
 int o2hb_check_node_heartbeating_no_sem(u8 node_num);
diff --git a/fs/ocfs2/cluster/netdebug.c b/fs/ocfs2/cluster/netdebug.c
index 7524994e31995..35c05c18de599 100644
--- a/fs/ocfs2/cluster/netdebug.c
+++ b/fs/ocfs2/cluster/netdebug.c
@@ -438,7 +438,7 @@ static int o2net_fill_bitmap(char *buf, int len)
 	unsigned long map[BITS_TO_LONGS(O2NM_MAX_NODES)];
 	int i = -1, out = 0;
 
-	o2net_fill_node_map(map, sizeof(map));
+	o2net_fill_node_map(map, O2NM_MAX_NODES);
 
 	while ((i = find_next_bit(map, O2NM_MAX_NODES, i + 1)) < O2NM_MAX_NODES)
 		out += scnprintf(buf + out, PAGE_SIZE - out, "%d ", i);
diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index 4e083e25d0e7d..44e3a7a163fb5 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -990,14 +990,12 @@ static int o2net_tx_can_proceed(struct o2net_node *nn,
 }
 
 /* Get a map of all nodes to which this node is currently connected to */
-void o2net_fill_node_map(unsigned long *map, unsigned bytes)
+void o2net_fill_node_map(unsigned long *map, unsigned int bits)
 {
 	struct o2net_sock_container *sc;
 	int node, ret;
 
-	BUG_ON(bytes < (BITS_TO_LONGS(O2NM_MAX_NODES) * sizeof(unsigned long)));
-
-	memset(map, 0, bytes);
+	bitmap_zero(map, bits);
 	for (node = 0; node < O2NM_MAX_NODES; ++node) {
 		if (!o2net_tx_can_proceed(o2net_nn_from_num(node), &sc, &ret))
 			continue;
diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index 3cd86b5de10f3..8b7f9ce7486d5 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -1612,7 +1612,7 @@ static int dlm_try_to_join_domain(struct dlm_ctxt *dlm)
 	/* group sem locking should work for us here -- we're already
 	 * registered for heartbeat events so filling this should be
 	 * atomic wrt getting those handlers called. */
-	o2hb_fill_node_map(dlm->live_nodes_map, sizeof(dlm->live_nodes_map));
+	o2hb_fill_node_map(dlm->live_nodes_map, O2NM_MAX_NODES);
 
 	spin_lock(&dlm->spinlock);
 	memcpy(ctxt->live_map, dlm->live_nodes_map, sizeof(ctxt->live_map));
diff --git a/fs/ocfs2/stack_o2cb.c b/fs/ocfs2/stack_o2cb.c
index 88f75f7f02d7d..c973c03f6fd8b 100644
--- a/fs/ocfs2/stack_o2cb.c
+++ b/fs/ocfs2/stack_o2cb.c
@@ -273,17 +273,17 @@ static int o2cb_cluster_check(void)
 	 */
 #define	O2CB_MAP_STABILIZE_COUNT	60
 	for (i = 0; i < O2CB_MAP_STABILIZE_COUNT; ++i) {
-		o2hb_fill_node_map(hbmap, sizeof(hbmap));
+		o2hb_fill_node_map(hbmap, O2NM_MAX_NODES);
 		if (!test_bit(node_num, hbmap)) {
 			printk(KERN_ERR "o2cb: %s heartbeat has not been "
 			       "started.\n", (o2hb_global_heartbeat_active() ?
 					      "Global" : "Local"));
 			return -EINVAL;
 		}
-		o2net_fill_node_map(netmap, sizeof(netmap));
+		o2net_fill_node_map(netmap, O2NM_MAX_NODES);
 		/* Force set the current node to allow easy compare */
 		set_bit(node_num, netmap);
-		if (!memcmp(hbmap, netmap, sizeof(hbmap)))
+		if (bitmap_equal(hbmap, netmap, O2NM_MAX_NODES))
 			return 0;
 		if (i < O2CB_MAP_STABILIZE_COUNT - 1)
 			msleep(1000);
-- 
2.53.0



