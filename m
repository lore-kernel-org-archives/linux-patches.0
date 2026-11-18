Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027174;
	b=sgyyhIKBIcbKrK74A71c5AuwH94lYYZDV42XOsZ3TtpjLAaRdNGXZn89+ibsPvKly8F+
	 5cQAT+cPiMf7QOP58zX9inTyHNv+Z8Ozu+Ubu9zoRJwXdbOrPDvf4WlNGJ0nWAdO7y8fD
	 KkZYbF2zb7vfhfpZbHsJsfGegILboeos6MIR4lGpcBl9Fx5Of25gLx/SzbHRxGNY7uSBE
	 UNzo/J25yd4IVrzrT/tZQswApAatDwqIzjs/0QSSqMRmollcw989zCABjnk4nAF02oYV7
	 zlX3YlZXrtW1QcHWYTKHW5PVefgiXslVwD+sIWL7ZSJd2NnxrxXaymVJI8Z6DJTUuSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027174;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=aodqV3Hwmz4x8T1os6d/NJvr3/uvYry7qgt1eWdy1lg=;
	b=2LNigQpelXTuFKTZJ6vVqoPELKajHyRimIWV7K3FJJMZZ3eJXi6GDd8xwc/JiZ9hrrDp
	 ijkeIMrTNzInIhSTAOg71tLKeNFdGyHfJGEFhKTQakRTD/fFWR5cTwmcAWrTFXBczE2TX
	 I1BbpKVZulaplOgyvxdP9dqSWKMORfCf7XVG8vlrj8Xg0C9Hew+labxyrsoDFl8xULGLj
	 /++gBa1mzysqjqAHufMnd8jN51EGr3bRSJQwt+Mv+EwY/DEH3mYpgSHSBj0mqkgaBmGcL
	 cIPxviNtse/DcZrDmIzX9eOFsQZlFFmehsTzyOeuzpEPga6gfKOzun6BKpvV5PN1oLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=17FBxfqC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89A60606A325;
	Wed, 18 Nov 2026 18:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=17FBxfqC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 930DA1F000C8;
	Wed, 18 Nov 2026 18:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027174;
	bh=aodqV3Hwmz4x8T1os6d/NJvr3/uvYry7qgt1eWdy1lg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=17FBxfqCnrTKuB8cBMDQ1uVw5h/2ondxBfJS4TG/gZ+Las/ucPRaFDXnt06mYMPLn
	 RBzKaFHFfJEv72WDVT7Fseh4dBZ9qZZmaOqfaAyxu6Lqz3ZAK/UumfxfU7SJibDYhn
	 T1HOoEmg7q+zyOcGSoMCA4zbzf4QqDpQmBXDm6DM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Laight <david.laight.linux@gmail.com>,
	syzbot+04cd90bb99c6ef81a65d@syzkaller.appspotmail.com,
	=?UTF-8?q?=C3=96mer=20Mete=20Kaya?= <omermetekaya0@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1689/2151] usbnet: fix smp_processor_id() use in preemptible context
Date: Wed, 18 Nov 2026 15:57:04 +0100
Message-ID: <20261118150223.353653233@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 1a50775abbdac..5d1675005903a 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -328,7 +328,7 @@ static void __usbnet_status_stop_force(struct usbnet *dev)
  */
 void usbnet_skb_return (struct usbnet *dev, struct sk_buff *skb)
 {
-	struct pcpu_sw_netstats *stats64 = this_cpu_ptr(dev->net->tstats);
+	struct pcpu_sw_netstats *stats64;
 	unsigned long flags;
 	int	status;
 
@@ -341,10 +341,12 @@ void usbnet_skb_return (struct usbnet *dev, struct sk_buff *skb)
 	if (skb->protocol == 0)
 		skb->protocol = eth_type_trans (skb, dev->net);
 
+	stats64 = get_cpu_ptr(dev->net->tstats);
 	flags = u64_stats_update_begin_irqsave(&stats64->syncp);
 	u64_stats_inc(&stats64->rx_packets);
 	u64_stats_add(&stats64->rx_bytes, skb->len);
 	u64_stats_update_end_irqrestore(&stats64->syncp, flags);
+	put_cpu_ptr(dev->net->tstats);
 
 	netif_dbg(dev, rx_status, dev->net, "< rx, len %zu, type 0x%x\n",
 		  skb->len + sizeof (struct ethhdr), skb->protocol);
@@ -1284,13 +1286,15 @@ static void tx_complete (struct urb *urb)
 	struct usbnet		*dev = entry->dev;
 
 	if (urb->status == 0) {
-		struct pcpu_sw_netstats *stats64 = this_cpu_ptr(dev->net->tstats);
+		struct pcpu_sw_netstats *stats64;
 		unsigned long flags;
 
+		stats64 = get_cpu_ptr(dev->net->tstats);
 		flags = u64_stats_update_begin_irqsave(&stats64->syncp);
 		u64_stats_add(&stats64->tx_packets, entry->packets);
 		u64_stats_add(&stats64->tx_bytes, entry->length);
 		u64_stats_update_end_irqrestore(&stats64->syncp, flags);
+		put_cpu_ptr(dev->net->tstats);
 	} else {
 		dev->net->stats.tx_errors++;
 
-- 
2.53.0



