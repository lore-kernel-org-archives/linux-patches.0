Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037287;
	b=VrfP1zN8o+O0yXSolK/zOu/R6rYVXlSDoTLXfKBpeyJqCY1lrazsE6bMN4v1JYwnCTgT
	 OIu7ajbWvAAEySLHe1PSyE8NipZRQ3wwg9LQ6wkQFbediOzNzuY5q9erRCeOeiAGHdso1
	 eF19aZXd/zeGD4U7GCWN/92p+6cBCVXAsk4SW3tOf7LXglQlDnN69mEgj70yjyHEMPH2h
	 tTlyavvXNxse8x3rq3o4EDoEYh08vDVWLi4zshIQluoUYyp8tH+5fOGO+tvRpV9ZMQT72
	 sAYfvbdI7AzSGhBg85CyBwy+mFv2yMIZge+DuI2XaOEm+Trahf3HtAogvQzIlw1Tp/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037287;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BBoib4AKuJQGVLjyuFl/1lyUipjtZcI7AIDY8DNujo4=;
	b=p9MksrrUjyOFbDyNRfmEpD9MkHrY0khtphtSuxI/DH1rTn2MzIdfBEjDnWFWjV6aWAWd
	 2WSv5MQFxxRCrtNOvfeoeQIn9y6+nugZmRhUPRAlRU1qidQuqMWzrwfre9C9Q0FXTEFRj
	 vM58N0t+IIYILhngTcF6uAZv1IHzno3gVAH8jXlPkWkrnLA2BGOs0nYW13sWasRL+YsCJ
	 UPGfSyoMaQTg5OYgsqixIe922lBO0+AlnywOttwFcm59iECvElCCNeM5bm/U6OjEIuk1P
	 jUUNxElJ/aHrGXL/wzo5AXtvndJgoOhzXcCrJNXW6mYdrowyHl4QRDj1rwDJd38o/bQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TRbkJGPm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90D9F606A325;
	Wed, 18 Nov 2026 21:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TRbkJGPm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA8AF1F000C4;
	Wed, 18 Nov 2026 21:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037287;
	bh=BBoib4AKuJQGVLjyuFl/1lyUipjtZcI7AIDY8DNujo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TRbkJGPmIM9eKd7kl8LzCWZU92v+xVnS9DwWvgM5EQWQ80OwTRwj1IqmxFY8cKV6z
	 k4XB0rZ4mAFXNAqCq0I6pCpOLfzzkb+wo0SS9YgOI6nW4Fg+p0Z624iigYJ5gordoB
	 C/5QcznvKnrJS8q2FlMkcTZhuBfOKHr7Q7yaKEog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremy Kerr <jk@codeconstruct.com.au>,
	Simon Horman <horms@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Christian Schmidbauer <opensource@grische.xyz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1354/3318] net: core: Implement dstats-type stats collections
Date: Wed, 18 Nov 2026 15:32:56 +0100
Message-ID: <20261118150401.045964657@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeremy Kerr <jk@codeconstruct.com.au>

[ Upstream commit 94b601bc4f8528262b2b83194b7fd3fc2a6da75a ]

We currently have dev_get_tstats64() for collecting per-cpu stats of
type pcpu_sw_netstats ("tstats"). However, tstats doesn't allow for
accounting tx/rx drops. We do have a stats variant that does have stats
for dropped packets: struct pcpu_dstats, but there are no core helpers
for using those stats.

The VRF driver uses dstats, by providing its own collation/fetch
functions to do so.

This change adds a common implementation for dstats-type collection,
used when pcpu_stat_type == NETDEV_PCPU_STAT_DSTAT. This is based on the
VRF driver's existing stats collator (plus the unused tx_drops stat from
there). We will switch the VRF driver to use this in the next change.

Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20240607-dstats-v3-2-cc781fe116f7@codeconstruct.com.au
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Christian Schmidbauer <opensource@grische.xyz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index a5e9e63b67965..3c533479b45f7 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10719,6 +10719,54 @@ void netdev_run_todo(void)
 	}
 }
 
+/* Collate per-cpu network dstats statistics
+ *
+ * Read per-cpu network statistics from dev->dstats and populate the related
+ * fields in @s.
+ */
+static void dev_fetch_dstats(struct rtnl_link_stats64 *s,
+			     const struct pcpu_dstats __percpu *dstats)
+{
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		u64 rx_packets, rx_bytes, rx_drops;
+		u64 tx_packets, tx_bytes, tx_drops;
+		const struct pcpu_dstats *stats;
+		unsigned int start;
+
+		stats = per_cpu_ptr(dstats, cpu);
+		do {
+			start = u64_stats_fetch_begin(&stats->syncp);
+			rx_packets = u64_stats_read(&stats->rx_packets);
+			rx_bytes   = u64_stats_read(&stats->rx_bytes);
+			rx_drops   = u64_stats_read(&stats->rx_drops);
+			tx_packets = u64_stats_read(&stats->tx_packets);
+			tx_bytes   = u64_stats_read(&stats->tx_bytes);
+			tx_drops   = u64_stats_read(&stats->tx_drops);
+		} while (u64_stats_fetch_retry(&stats->syncp, start));
+
+		s->rx_packets += rx_packets;
+		s->rx_bytes   += rx_bytes;
+		s->rx_dropped += rx_drops;
+		s->tx_packets += tx_packets;
+		s->tx_bytes   += tx_bytes;
+		s->tx_dropped += tx_drops;
+	}
+}
+
+/* ndo_get_stats64 implementation for dtstats-based accounting.
+ *
+ * Populate @s from dev->stats and dev->dstats. This is used internally by the
+ * core for NETDEV_PCPU_STAT_DSTAT-type stats collection.
+ */
+static void dev_get_dstats64(const struct net_device *dev,
+			     struct rtnl_link_stats64 *s)
+{
+	netdev_stats_to_stats64(s, &dev->stats);
+	dev_fetch_dstats(s, dev->dstats);
+}
+
 /* Convert net_device_stats to rtnl_link_stats64. rtnl_link_stats64 has
  * all the same fields in the same order as net_device_stats, with only
  * the type differing, but rtnl_link_stats64 may have additional fields
@@ -10792,6 +10840,8 @@ struct rtnl_link_stats64 *dev_get_stats(struct net_device *dev,
 		netdev_stats_to_stats64(storage, ops->ndo_get_stats(dev));
 	} else if (dev->pcpu_stat_type == NETDEV_PCPU_STAT_TSTATS) {
 		dev_get_tstats64(dev, storage);
+	} else if (dev->pcpu_stat_type == NETDEV_PCPU_STAT_DSTATS) {
+		dev_get_dstats64(dev, storage);
 	} else {
 		netdev_stats_to_stats64(storage, &dev->stats);
 	}
-- 
2.53.0



