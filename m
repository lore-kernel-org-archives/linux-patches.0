Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B81BA1CAA8F;
	Tue, 11 Mar 2025 15:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707245; cv=none; b=GKBdl8nFSGaOfXk9Ym/AtSaz6/wuVAYkD5vTn0WcfbsvFKAX2mFYfUKC3jIpMGLiO8KxJiOOYqBdOfpUgYmt4tuWnBfrX4QtGfQz1l8BFQoRExt/sRcVFcZaVieBZ/8kPiC1oQzTksYwuv3pd09S24hZx49I5et2PwHSzbbGFZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707245; c=relaxed/simple;
	bh=YEPZGDe3YKMRatzRaRG140U/NNMMJ916sf3u311V8OY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ePjoJodirlgagJRdilPf92wkOMVd1tJC4dRyf4Bwf/StyKaZxhlbhBZy9iOrudt4ebZJJVeaam7ZI0YXJydzFAqKtMkAFxgNE5pS0zgsUJq+937qGI0TRqVA7DfddUCfuoeFZcjZ0wNJQGlDcyeFLRKwS1PcYV/xLpkw/ruPsxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0T/4KO82; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0T/4KO82"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1091DC4CEE9;
	Tue, 11 Mar 2025 15:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707245;
	bh=YEPZGDe3YKMRatzRaRG140U/NNMMJ916sf3u311V8OY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0T/4KO82wzX3V9H2k9qAb8KhL8Ul8AgbhgNWR2PxDmNpzEce1gtrHwF3a6NCnj7aX
	 U8POSK77wovxT/iczGe4pVivTVO0rh86QNvh5LUjn+/V6HeH33e8t8fXH/ogDkS03v
	 YTOnMUWF3PTNzvI1bvq0mJZcr+5MnnhXNVAA3jdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>,
	Simon Wunderlich <sw@simonwunderlich.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 324/462] batman-adv: Add new include for min/max helpers
Date: Tue, 11 Mar 2025 15:59:50 +0100
Message-ID: <20250311145811.164632636@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

[ Upstream commit fcd193e1dfa6842e2783b04d98345767fe99cf31 ]

The commit b296a6d53339 ("kernel.h: split out min()/max() et al. helpers")
moved the min/max helper functionality from kernel.h to minmax.h. Adjust
the kernel code accordingly to avoid fragile indirect includes.

Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Stable-dep-of: 8c8ecc98f5c6 ("batman-adv: Drop unmanaged ELP metric worker")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/bat_v.c          | 1 +
 net/batman-adv/bat_v_elp.c      | 1 +
 net/batman-adv/bat_v_ogm.c      | 1 +
 net/batman-adv/fragmentation.c  | 2 +-
 net/batman-adv/hard-interface.c | 1 +
 net/batman-adv/icmp_socket.c    | 1 +
 net/batman-adv/main.c           | 1 +
 net/batman-adv/netlink.c        | 1 +
 net/batman-adv/tp_meter.c       | 1 +
 9 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/batman-adv/bat_v.c b/net/batman-adv/bat_v.c
index 0ecaf1bb0068d..e91d2c0720c4c 100644
--- a/net/batman-adv/bat_v.c
+++ b/net/batman-adv/bat_v.c
@@ -16,6 +16,7 @@
 #include <linux/kernel.h>
 #include <linux/kref.h>
 #include <linux/list.h>
+#include <linux/minmax.h>
 #include <linux/netdevice.h>
 #include <linux/netlink.h>
 #include <linux/rculist.h>
diff --git a/net/batman-adv/bat_v_elp.c b/net/batman-adv/bat_v_elp.c
index 980badecf2514..fb76b8861f098 100644
--- a/net/batman-adv/bat_v_elp.c
+++ b/net/batman-adv/bat_v_elp.c
@@ -18,6 +18,7 @@
 #include <linux/jiffies.h>
 #include <linux/kernel.h>
 #include <linux/kref.h>
+#include <linux/minmax.h>
 #include <linux/netdevice.h>
 #include <linux/nl80211.h>
 #include <linux/prandom.h>
diff --git a/net/batman-adv/bat_v_ogm.c b/net/batman-adv/bat_v_ogm.c
index c451694fdb42f..aff877203cd23 100644
--- a/net/batman-adv/bat_v_ogm.c
+++ b/net/batman-adv/bat_v_ogm.c
@@ -18,6 +18,7 @@
 #include <linux/kref.h>
 #include <linux/list.h>
 #include <linux/lockdep.h>
+#include <linux/minmax.h>
 #include <linux/mutex.h>
 #include <linux/netdevice.h>
 #include <linux/prandom.h>
diff --git a/net/batman-adv/fragmentation.c b/net/batman-adv/fragmentation.c
index 895d834d479d1..0eb94024addb6 100644
--- a/net/batman-adv/fragmentation.c
+++ b/net/batman-adv/fragmentation.c
@@ -14,8 +14,8 @@
 #include <linux/gfp.h>
 #include <linux/if_ether.h>
 #include <linux/jiffies.h>
-#include <linux/kernel.h>
 #include <linux/lockdep.h>
+#include <linux/minmax.h>
 #include <linux/netdevice.h>
 #include <linux/skbuff.h>
 #include <linux/slab.h>
diff --git a/net/batman-adv/hard-interface.c b/net/batman-adv/hard-interface.c
index fe79bfc6d2dd1..bc2c19a43d15b 100644
--- a/net/batman-adv/hard-interface.c
+++ b/net/batman-adv/hard-interface.c
@@ -18,6 +18,7 @@
 #include <linux/kref.h>
 #include <linux/limits.h>
 #include <linux/list.h>
+#include <linux/minmax.h>
 #include <linux/mutex.h>
 #include <linux/netdevice.h>
 #include <linux/printk.h>
diff --git a/net/batman-adv/icmp_socket.c b/net/batman-adv/icmp_socket.c
index 8bdabc03b0b23..56de4bf21aa5e 100644
--- a/net/batman-adv/icmp_socket.c
+++ b/net/batman-adv/icmp_socket.c
@@ -20,6 +20,7 @@
 #include <linux/if_ether.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
+#include <linux/minmax.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
 #include <linux/pkt_sched.h>
diff --git a/net/batman-adv/main.c b/net/batman-adv/main.c
index 9f267b190779f..d9719d807d6a2 100644
--- a/net/batman-adv/main.c
+++ b/net/batman-adv/main.c
@@ -23,6 +23,7 @@
 #include <linux/kobject.h>
 #include <linux/kref.h>
 #include <linux/list.h>
+#include <linux/minmax.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
 #include <linux/printk.h>
diff --git a/net/batman-adv/netlink.c b/net/batman-adv/netlink.c
index 931bc3b5c6df0..0b5cb03859b25 100644
--- a/net/batman-adv/netlink.c
+++ b/net/batman-adv/netlink.c
@@ -23,6 +23,7 @@
 #include <linux/kernel.h>
 #include <linux/limits.h>
 #include <linux/list.h>
+#include <linux/minmax.h>
 #include <linux/netdevice.h>
 #include <linux/netlink.h>
 #include <linux/printk.h>
diff --git a/net/batman-adv/tp_meter.c b/net/batman-adv/tp_meter.c
index 00d62a6c5e0ef..3bbfa8ee6deac 100644
--- a/net/batman-adv/tp_meter.c
+++ b/net/batman-adv/tp_meter.c
@@ -23,6 +23,7 @@
 #include <linux/kthread.h>
 #include <linux/limits.h>
 #include <linux/list.h>
+#include <linux/minmax.h>
 #include <linux/netdevice.h>
 #include <linux/param.h>
 #include <linux/printk.h>
-- 
2.39.5



