Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056501;
	b=3JCkIyQ7nqlqWIclWTDWTgOpbL4U5EBZrQpl8zxFmRzxSkqzNmt9gXvGYab69TJh2N3w
	 je24tbCpaOoV1JvSt72XQyfU68UEs/csgacjxiEMM8FtH4NGLb4cATO7g9q3nHwFwJ7lK
	 9QO+REjpv0vVot2emj3k1DteigP4/Srwa+Zp4+Q/3WbhZgDE0leRdbyMIVVGjYJGod4it
	 HLsvoWx/kybQTf7fPTYMRtbsiEYfUZKkNzau1Z4exk1P+ZtwYeCOnHO13GRIKwRjYmfox
	 qxXTC7kgMtj4NgdFNU3l1kZDJAG18cEhZgC68tP8+JRiyvo47n/Y0OxS0p82f+gZY+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056501;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=7gCoxVsE3qM/FTgn1KAaFSEeIja/TV2/1Shdht/GeYg=;
	b=w0y9i9qF5Rx4/KnL9EMANcGpjXB21gAR2ZECZ8hKqzFtmJ1GJKkCbsfKscpmouoQmht8
	 UpmuqzvStqs/jgeLvOxXyxCHdB4Go4PS8m+LS7LmVeL/mU4AYcXDIgIFZYmo5ISFyfa9l
	 BSdIEIxymED0EIXSGsOwCrYO8ngah+T68fkF3vHgsvdUQ9p1iwHWWlt4WMPM//EmdBC74
	 L2SZpAifi2lrRIErA1ahU6UIpi5NEQYH3oGESiXdFTgN7V46iO62HY660cNH0aOkacXFb
	 k2oWM2/SZ4EB7JjzFKCMoQN0iizgKfLva85v+5SeKKXlChb2CwbM3Pq6TfPDojs4ASg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d6vFC7q+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 990DA606A331;
	Thu, 19 Nov 2026 02:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d6vFC7q+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0C491F000C7;
	Thu, 19 Nov 2026 02:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056501;
	bh=7gCoxVsE3qM/FTgn1KAaFSEeIja/TV2/1Shdht/GeYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d6vFC7q+ilL2GZIuD8b2jBeGSeGQeg/odg16UHHnvrvNmLchioV+GHAl238Grmexm
	 DUH2wpkqYgXM1P5Mw8p2pbKBrRXzwoDiwMBMgGQBpvRj/IteskV0oz9zcOEQH+kCTa
	 amrj9HEbneUHZTYp+HD01Oyh1MLe2mW4R5H7cqc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Laight <david.laight.linux@gmail.com>,
	syzbot+04cd90bb99c6ef81a65d@syzkaller.appspotmail.com,
	=?UTF-8?q?=C3=96mer=20Mete=20Kaya?= <omermetekaya0@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2011/2214] usbnet: fix smp_processor_id() use in preemptible context
Date: Wed, 18 Nov 2026 16:01:27 +0100
Message-ID: <20261118150131.187447926@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 1b9c06d66054b..a3e07449e5e7a 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -331,7 +331,7 @@ static void __usbnet_status_stop_force(struct usbnet *dev)
  */
 void usbnet_skb_return (struct usbnet *dev, struct sk_buff *skb)
 {
-	struct pcpu_sw_netstats *stats64 = this_cpu_ptr(dev->net->tstats);
+	struct pcpu_sw_netstats *stats64;
 	unsigned long flags;
 	int	status;
 
@@ -344,10 +344,12 @@ void usbnet_skb_return (struct usbnet *dev, struct sk_buff *skb)
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
@@ -1282,13 +1284,15 @@ static void tx_complete (struct urb *urb)
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



