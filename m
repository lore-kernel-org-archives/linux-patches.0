Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3DDC2EE985
	for <patches@lists.linux.dev>; Fri, 25 Jul 2025 15:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753458973; cv=none; b=U0S8R8mxRd5PS2Ke5gHhIwdONvVbeRwNbQj0aR1JUhx2NOPC65o1brszKj3JUQKMN1yzTHlnt740jVtaCjYLnN/OdEHcw/TgVYPnY/b3VNdQ21R7hpgUV+v+ciq7FR9vbEOP55ZSZztQ/loJNK0nh8yPyagihw2J68XrJCcbUvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753458973; c=relaxed/simple;
	bh=ApCzPWuqEIv8w5oR0HLgtv4+D/wwTnZTqBn4R3B/HRU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=lCjH5S+7tE0VHXHa+31ILlAFaHjOUdjC9fhrp3L6abKt/v8wMBdbG+mRAVlR7iSJ0yDp52h3fPNH57CS5YUSwH756dPCiFGHiH2qjzzaUmAgKMz8Fr4FldEnhPm3DKWlDoA1MgST8khdxS6l8kjO51UD7wjT8eKRkt++yUIhEhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=roxoh8AK; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="roxoh8AK"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20250725155609epoutp049696f363dc60139a44297eef37e29571~ViaSXPeXT2040320403epoutp045
	for <patches@lists.linux.dev>; Fri, 25 Jul 2025 15:56:09 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20250725155609epoutp049696f363dc60139a44297eef37e29571~ViaSXPeXT2040320403epoutp045
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1753458969;
	bh=gsFsMIu+qmP5Pk/U6/E+nZJ61/APVl3sjNSY2NmttmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=roxoh8AKSYXrvCGuFdf8XH8kQu51QfVQLUdOFyczUN7Vq/hh5zsQ2qS7573JuGVKF
	 4N/0SxsXAT09mXEL2wiuBBzb3AAVrthKQoXDru2BiTrD1VkuA082DJYDkQM3gIotgV
	 hfgsrd3jq6GdF+p0FP8e/qBK5H3l+21Y8g0FzHCw=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20250725155608epcas5p2c7efd9d50354672154572ea819fbf37d~ViaRK2uxM3273532735epcas5p26;
	Fri, 25 Jul 2025 15:56:08 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.90]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4bpXXl5FHWz2SSKX; Fri, 25 Jul
	2025 15:56:07 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20250725155505epcas5p3981ad791c6c044c7abc6d232c05d54f9~ViZWfgzL-2330123301epcas5p3P;
	Fri, 25 Jul 2025 15:55:05 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250725155504epsmtip2f5c8d60b1fa487031b91537de75e1e72~ViZV4T2xO0442304423epsmtip2R;
	Fri, 25 Jul 2025 15:55:04 +0000 (GMT)
From: Kundan Kumar <kundan.kumar@samsung.com>
To: mcgrof@kernel.org
Cc: patches@lists.linux.dev, Kundan Kumar <kundan.kumar@samsung.com>, Anuj
	Gupta <anuj20.g@samsung.com>
Subject: [PATCH v2 08/15] writeback: add support to collect stats for all
 writeback ctxs
Date: Fri, 25 Jul 2025 21:24:14 +0530
Message-Id: <20250725155421.3234-9-kundan.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250725155421.3234-1-kundan.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250725155505epcas5p3981ad791c6c044c7abc6d232c05d54f9
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250725155505epcas5p3981ad791c6c044c7abc6d232c05d54f9
References: <20250725155421.3234-1-kundan.kumar@samsung.com>
	<CGME20250725155505epcas5p3981ad791c6c044c7abc6d232c05d54f9@epcas5p3.samsung.com>

Modified stats collection to collect stats for all the writeback
contexts within a bdi.

Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 mm/backing-dev.c | 72 ++++++++++++++++++++++++++++--------------------
 1 file changed, 42 insertions(+), 30 deletions(-)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 754f2f6c6d7c..0a772d984ecf 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -50,6 +50,7 @@ struct wb_stats {
 	unsigned long nr_written;
 	unsigned long dirty_thresh;
 	unsigned long wb_thresh;
+	unsigned long state;
 };
 
 static struct dentry *bdi_debug_root;
@@ -81,6 +82,7 @@ static void collect_wb_stats(struct wb_stats *stats,
 	stats->nr_dirtied += wb_stat(wb, WB_DIRTIED);
 	stats->nr_written += wb_stat(wb, WB_WRITTEN);
 	stats->wb_thresh += wb_calc_thresh(wb, stats->dirty_thresh);
+	stats->state |= wb->state;
 }
 
 #ifdef CONFIG_CGROUP_WRITEBACK
@@ -89,22 +91,27 @@ static void bdi_collect_stats(struct backing_dev_info *bdi,
 			      struct wb_stats *stats)
 {
 	struct bdi_writeback *wb;
+	struct bdi_writeback_ctx *bdi_wb_ctx;
 
 	rcu_read_lock();
-	list_for_each_entry_rcu(wb, &bdi->wb_ctx[0]->wb_list, bdi_node) {
-		if (!wb_tryget(wb))
-			continue;
+	for_each_bdi_wb_ctx(bdi, bdi_wb_ctx)
+		list_for_each_entry_rcu(wb, &bdi_wb_ctx->wb_list, bdi_node) {
+			if (!wb_tryget(wb))
+				continue;
 
-		collect_wb_stats(stats, wb);
-		wb_put(wb);
-	}
+			collect_wb_stats(stats, wb);
+			wb_put(wb);
+		}
 	rcu_read_unlock();
 }
 #else
 static void bdi_collect_stats(struct backing_dev_info *bdi,
 			      struct wb_stats *stats)
 {
-	collect_wb_stats(stats, &bdi->wb_ctx[0]->wb);
+	struct bdi_writeback_ctx *bdi_wb_ctx;
+
+	for_each_bdi_wb_ctx(bdi, bdi_wb_ctx)
+		collect_wb_stats(stats, &bdi_wb_ctx->wb);
 }
 #endif
 
@@ -150,7 +157,7 @@ static int bdi_debug_stats_show(struct seq_file *m, void *v)
 		   stats.nr_io,
 		   stats.nr_more_io,
 		   stats.nr_dirty_time,
-		   !list_empty(&bdi->bdi_list), bdi->wb_ctx[0]->wb.state);
+		   !list_empty(&bdi->bdi_list), stats.state);
 
 	return 0;
 }
@@ -195,35 +202,40 @@ static int cgwb_debug_stats_show(struct seq_file *m, void *v)
 {
 	struct backing_dev_info *bdi = m->private;
 	struct bdi_writeback *wb;
+	struct bdi_writeback_ctx *bdi_wb_ctx;
 	unsigned long background_thresh;
 	unsigned long dirty_thresh;
+	struct wb_stats stats;
 
 	global_dirty_limits(&background_thresh, &dirty_thresh);
+	stats.dirty_thresh = dirty_thresh;
 
 	rcu_read_lock();
-	list_for_each_entry_rcu(wb, &bdi->wb_ctx[0]->wb_list, bdi_node) {
-		struct wb_stats stats = { .dirty_thresh = dirty_thresh };
-
-		if (!wb_tryget(wb))
-			continue;
-
-		collect_wb_stats(&stats, wb);
-
-		/*
-		 * Calculate thresh of wb in writeback cgroup which is min of
-		 * thresh in global domain and thresh in cgroup domain. Drop
-		 * rcu lock because cgwb_calc_thresh may sleep in
-		 * cgroup_rstat_flush. We can do so here because we have a ref.
-		 */
-		if (mem_cgroup_wb_domain(wb)) {
-			rcu_read_unlock();
-			stats.wb_thresh = min(stats.wb_thresh, cgwb_calc_thresh(wb));
-			rcu_read_lock();
+	for_each_bdi_wb_ctx(bdi, bdi_wb_ctx) {
+		list_for_each_entry_rcu(wb, &bdi_wb_ctx->wb_list, bdi_node) {
+			if (!wb_tryget(wb))
+				continue;
+
+			collect_wb_stats(&stats, wb);
+
+			/*
+			 * Calculate thresh of wb in writeback cgroup which is
+			 * min of thresh in global domain and thresh in cgroup
+			 * domain. Drop rcu lock because cgwb_calc_thresh may
+			 * sleep in cgroup_rstat_flush. We can do so here
+			 * because we have a ref.
+			 */
+			if (mem_cgroup_wb_domain(wb)) {
+				rcu_read_unlock();
+				stats.wb_thresh = min(stats.wb_thresh,
+						      cgwb_calc_thresh(wb));
+				rcu_read_lock();
+			}
+
+			wb_stats_show(m, wb, &stats);
+
+			wb_put(wb);
 		}
-
-		wb_stats_show(m, wb, &stats);
-
-		wb_put(wb);
 	}
 	rcu_read_unlock();
 
-- 
2.25.1

