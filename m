Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017457;
	b=l/AL2ZDaHIK2iOUkiYfbovQsrRj6rzRTL1T2y1SzNuwHqzzaMZc4aH0TjC7TVX1IVZY3
	 H3pRZyEZ8ZKKOYadxU8NPYtY6Y3V0VaDj0SEEk/KqXgGTNmYlOdlWdTf+2tVOxNrq30mF
	 umxjBDclscTFoeeHLOcd7rXzoX+ADCxtQQc+E7B1Nx/o7G0wtenAHtwiy3WIWXq09hpcv
	 04W2Fw4BXOVXt2Abe6JZoPxQ/vxck1BAk9lcFYz2ab8oViY5rJly+GwXIxAgWVfvwHzMb
	 dM85bU4FJtjhd0FDSsbqFeZrEWlVbv74sX2PL1/GhWjsGgm+sxjjL91PTZ9Ff7fvW1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017457;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JPjZ2VulJBvG23LwRtGl+1Eu69zw0D4KOj2tICKkHfk=;
	b=MoWbYAp2CmeWhEwy+DBBPA8gbLYSiYbz8JeL+4YDbDRFo2LxFD2uVPpIRn5cEPiFq/HH
	 tJfXgmuy8NNPPXyzxqxTls+uR/wSy7GkU+m1znryBc9R/w1Pyrv5rX1hrgXURiXiB044d
	 lNr86lXcrEK3Pi31hywGjNa4NNzzRvyfZEgwAmhy6IRKYW88n5+hd4H9/PwJKiGPv5NOv
	 TkABkMgT4k+/7Obehn76Pso7rqr0U54hst/Aki4SN+8PoMBexi2OtcTm0msl9RSiwQ8OO
	 f4NAmsgWyVvfu97pVv9I5bnBa1E1DZ1KIx1DFt771KufPRCduIgLoc1b5TQ1ul6B6Kg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vt4z+7nh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6EFF606A320;
	Wed, 18 Nov 2026 15:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vt4z+7nh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 199281F000C5;
	Wed, 18 Nov 2026 15:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017457;
	bh=JPjZ2VulJBvG23LwRtGl+1Eu69zw0D4KOj2tICKkHfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vt4z+7nhInwRf82MUEhxpK/hmQV6OkFSnH5JBIw4gZbDb9Fkp9ZN8qawdtWFk/gZp
	 t6i8UTaoHjl1x3PCu/K5bpdZgn6YcGMW59v1hiJJwvDr3dGSGLpM9+VTxhU98PO2NB
	 XgYvPKyZnJ+2tUKuzvx7W5nnqtVGBTPgnoMvCrrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0891/2651] net: synchronize proc_do_rss_key() with netdev_rss_key_fill()
Date: Wed, 18 Nov 2026 15:35:31 +0100
Message-ID: <20261118150319.941651360@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 9396e37c4860822fbc354fa438bb18e1437e0c9c ]

proc_do_rss_key() reads netdev_rss_key[] without synchronization, so a
concurrent reader of /proc/sys/net/core/netdev_rss_key can observe a
partially populated key while netdev_rss_key_fill() is initializing it.

Publish a boolean flag after an smp_wmb() once netdev_rss_key_fill() has
populated netdev_rss_key[], and pair it with an smp_rmb() in
proc_do_rss_key(), printing zero bytes until the flag is set.

Fixes: 960fb622f851 ("net: provide a per host RSS key generic infrastructure")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260922163458.3900996-2-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.h             | 1 +
 net/core/sysctl_net_core.c | 7 ++++++-
 net/ethtool/ioctl.c        | 7 +++++++
 3 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/net/core/dev.h b/net/core/dev.h
index 04fb0e9a571e0..f159a7c7beaa5 100644
--- a/net/core/dev.h
+++ b/net/core/dev.h
@@ -95,6 +95,7 @@ extern int		netdev_unregister_timeout_secs;
 extern int		weight_p;
 extern int		dev_weight_rx_bias;
 extern int		dev_weight_tx_bias;
+extern bool		netdev_rss_key_initialized;
 
 extern struct rw_semaphore dev_addr_sem;
 
diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index eb35da3556f4a..aa3dcc289e29f 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -336,10 +336,15 @@ static int proc_do_rss_key(const struct ctl_table *table, int write,
 {
 	char buf[NETDEV_RSS_KEY_LEN * 3];
 	struct ctl_table fake_table;
+	bool initialized;
 	char *pos = buf;
 
+	initialized = READ_ONCE(netdev_rss_key_initialized);
+	/* Pair with smp_wmb() in netdev_rss_key_fill(). */
+	smp_rmb();
+
 	for (int i = 0; i < NETDEV_RSS_KEY_LEN; i++) {
-		pos = hex_byte_pack(pos, netdev_rss_key[i]);
+		pos = hex_byte_pack(pos, initialized ? netdev_rss_key[i] : 0);
 		*pos++ = ':';
 	}
 	*(--pos) = 0;
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 4b0bc503f9307..b2820f02ca279 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -34,6 +34,7 @@
 #include <net/netdev_lock.h>
 #include <net/netdev_queues.h>
 
+#include "../core/dev.h"
 #include "common.h"
 
 /* State held across locks and calls for commands which have devlink fallback */
@@ -1302,11 +1303,17 @@ static int ethtool_copy_validate_indir(u32 *indir, void __user *useraddr,
 }
 
 u8 netdev_rss_key[NETDEV_RSS_KEY_LEN] __read_mostly;
+bool netdev_rss_key_initialized __read_mostly;
 
 void netdev_rss_key_fill(void *buffer, size_t len)
 {
 	BUG_ON(len > sizeof(netdev_rss_key));
 	net_get_random_once(netdev_rss_key, sizeof(netdev_rss_key));
+	if (unlikely(!READ_ONCE(netdev_rss_key_initialized))) {
+		/* Pair with smp_rmb() in proc_do_rss_key(). */
+		smp_wmb();
+		WRITE_ONCE(netdev_rss_key_initialized, true);
+	}
 	memcpy(buffer, netdev_rss_key, len);
 }
 EXPORT_SYMBOL(netdev_rss_key_fill);
-- 
2.53.0



