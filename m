Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061858;
	b=JpcVj0FD3nYPNNddku4kw274uhl5hNFJBd7YwbnBaKshfiiL6gUNrGIjuFNZpvBUn5ut
	 qenLAC6BSnefYbl3m/SPjn6F+Ri7WU0EPvPI5SGp6ctrCgStOsRHO11h+G8BgVh5dUCo+
	 GCNvbhr/cjusTWBvecf4+Oq29/rp+8TR01B+4MAWq8a0AKxstrn0Y7RrdisMbs+YbLM7T
	 vFXiJ0jbdMybtvYl2qUsdQrJyTLwExT4jcnTYI6bSKpD5Uxe8b2EwjoYOph9LPiC5+9Q5
	 7nRIkfFbktaj7Om2Z9sI1W7El21lg5q3guYxaYQtTNjr389bHFlM8hkmiPe5JNEYhiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061858;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=CDnwqVsQR5zO/yCl9Xx5r1jEV53yU0IDSyK/spPeMek=;
	b=Zw0paZACIaZ0Z0olpFsewGCmhCIBrD6AD1GZjWcLslJDkqBpaQmjSHJm9aGWNtIuf08b
	 5TSV4yDBHUbtbVUNmSZLARn4wHsnLEFGl6DwFq18tXkjD8+prn4jtnWc5pgKg0onYTyHt
	 3EL7mPmAkGaKOs6Cf5Au8GgPd36tSnfKnTBvCxsNnLg5y5+wfQfRDd5TMFbdALhl0ZfSr
	 gjWPNxCBWnJV5syJ2w+xeqyzt8MXmKCuMkbk9DQePgAMZkJzqZJcsgGiIKHYhgngiZyOG
	 jZgRbmu7edgpBBgrAPZ8jH7s64eNCv8EulVmGgubzXcoTEixWpIJn3VHdefPbszT00w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d3oLw1NV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53CAA606A320;
	Thu, 19 Nov 2026 04:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d3oLw1NV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A10811F000C5;
	Thu, 19 Nov 2026 04:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061858;
	bh=CDnwqVsQR5zO/yCl9Xx5r1jEV53yU0IDSyK/spPeMek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d3oLw1NVmE55FtIOjyAo7dE90DnOq10I2ntUqQbM78NQ+hQf8zvPGuEi+PdJaPFbC
	 8JA7F0S1TpLrU9+kZ3w4xM/Uo9imMcizFf/Dz4N6xb/lD+fU+uHo/GuzE0wUo5gg83
	 xJQwZxkzhtiL+/vmEjbmPHIjODYgKNindHeuEEqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Laight <david.laight.linux@gmail.com>,
	syzbot+04cd90bb99c6ef81a65d@syzkaller.appspotmail.com,
	=?UTF-8?q?=C3=96mer=20Mete=20Kaya?= <omermetekaya0@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1686/1848] usbnet: fix smp_processor_id() use in preemptible context
Date: Wed, 18 Nov 2026 16:02:04 +0100
Message-ID: <20261118150030.336094687@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ömer Mete Kaya <omermetekaya0@gmail.com>

[ Upstream commit 95a5c641fc7becab441bf244baa73b0b0f8b7dea ]

tx_complete() calls this_cpu_ptr() before disabling preemption, which
triggers a BUG when running with CONFIG_DEBUG_PREEMPT:

  BUG: using smp_processor_id() in preemptible code in tx_complete

Fix by using get_cpu_ptr()/put_cpu_ptr() which disable preemption and
return the per-CPU pointer atomically. The usbnet_skb_return() hunk
is a hardening change: that path runs in softirq context so no warning
fires there, but the same fix is applied for consistency.

Fixes: ed194d136769 ("usb: core: remove local_irq_save() around ->complete() handler")
Suggested-by: David Laight <david.laight.linux@gmail.com>
Reported-by: syzbot+04cd90bb99c6ef81a65d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=04cd90bb99c6ef81a65d
Signed-off-by: Ömer Mete Kaya <omermetekaya0@gmail.com>
Link: https://patch.msgid.link/20261004215937.302247-1-omermetekaya0@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/usbnet.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 20713b67ea2b2..6a7caf3dd337a 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -314,7 +314,7 @@ static void __usbnet_status_stop_force(struct usbnet *dev)
  */
 void usbnet_skb_return (struct usbnet *dev, struct sk_buff *skb)
 {
-	struct pcpu_sw_netstats *stats64 = this_cpu_ptr(dev->net->tstats);
+	struct pcpu_sw_netstats *stats64;
 	unsigned long flags;
 	int	status;
 
@@ -327,10 +327,12 @@ void usbnet_skb_return (struct usbnet *dev, struct sk_buff *skb)
 	if (skb->protocol == 0)
 		skb->protocol = eth_type_trans (skb, dev->net);
 
+	stats64 = get_cpu_ptr(dev->net->tstats);
 	flags = u64_stats_update_begin_irqsave(&stats64->syncp);
 	stats64->rx_packets++;
 	stats64->rx_bytes += skb->len;
 	u64_stats_update_end_irqrestore(&stats64->syncp, flags);
+	put_cpu_ptr(dev->net->tstats);
 
 	netif_dbg(dev, rx_status, dev->net, "< rx, len %zu, type 0x%x\n",
 		  skb->len + sizeof (struct ethhdr), skb->protocol);
@@ -1224,13 +1226,15 @@ static void tx_complete (struct urb *urb)
 	struct usbnet		*dev = entry->dev;
 
 	if (urb->status == 0) {
-		struct pcpu_sw_netstats *stats64 = this_cpu_ptr(dev->net->tstats);
+		struct pcpu_sw_netstats *stats64;
 		unsigned long flags;
 
+		stats64 = get_cpu_ptr(dev->net->tstats);
 		flags = u64_stats_update_begin_irqsave(&stats64->syncp);
 		stats64->tx_packets += entry->packets;
 		stats64->tx_bytes += entry->length;
 		u64_stats_update_end_irqrestore(&stats64->syncp, flags);
+		put_cpu_ptr(dev->net->tstats);
 	} else {
 		dev->net->stats.tx_errors++;
 
-- 
2.53.0



