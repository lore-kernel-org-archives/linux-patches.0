Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020770;
	b=26WPWkh8Yq+8jhxcRk5MnzmMijjKDcpLd0v3CEQndML7FNNuazBU3auiiHW3kqlftQLo
	 OeHwBHHt/sHa+gahOWaJf54vyGA7LpETHZe/J8RRmByciemIeWewe6lE2PbB3NEq1z04B
	 DT3r2eLSCmepkNYaFcFgrI9s63lT00t/0OgplhPSu9ZuXSNYR003EwBbbrAXfYrccCxUM
	 0aw3rQHWpPY/klDTkK0/rlrGvn2LVkrs0ILF66vc8IiYfzvMIlUfQen1blz7RGo/LvOWF
	 eewasheXBg2dyg1BbsKiWTrQb8wMLzpoy8bCW6i4jZcZlOROSVKjPrZomUOhniT1uNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020770;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=CFzLoV8fnW4mfQaVlTSqQAHlOJNnHxTN1pu9ZnzerOA=;
	b=PwV1ND4KkjiiEOzOIOLStqrtqkjb1tWPRZ9uNN/vp4OU8qdSQSODPzwHeWzrbrOJ0bLr
	 5UqqY3FGcxu2tzltzMQa16LdBg9B15KYJ5sOUs2yIjcg+l3dDwWwF4K38dWhEJDoXGowO
	 VaqUK87G+FBnCRDOSNAsRMWG9Qb6oPaJy7R5+tP5fbJLic+qCy6LUiX3yPIvjq8I3nTJE
	 kgfyFjHrbliUPkCLFBFTqL4L06tmJrytsck/dVTs1BtJCFUcMwTPQz5meXV/E/XcMgvpj
	 PvSu4+GECMX6burq2Lc3gLRReKkeipZA0vCGi7ynm0Osd72GO3ZVP9wcp6+eCn2+iNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JO7N9z9u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DB59606A337;
	Wed, 18 Nov 2026 16:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JO7N9z9u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87D201F000C4;
	Wed, 18 Nov 2026 16:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020770;
	bh=CFzLoV8fnW4mfQaVlTSqQAHlOJNnHxTN1pu9ZnzerOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JO7N9z9uS0TnG3jThE7/G2r+RMW9ulFqjrsm5lc1Oq+qGWSK2iMvrE2wOatv+RbcC
	 lwoY+msUZR7g/xPg1qN5pxe3QqeqlcIpVq24cMJ/orXk/BJNuv7OXRy82lVukYXKn6
	 DH4dDajtKeATNL37b9hpFqSQ5OoZekbB8kcMYAJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Laight <david.laight.linux@gmail.com>,
	syzbot+04cd90bb99c6ef81a65d@syzkaller.appspotmail.com,
	=?UTF-8?q?=C3=96mer=20Mete=20Kaya?= <omermetekaya0@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2053/2651] usbnet: fix smp_processor_id() use in preemptible context
Date: Wed, 18 Nov 2026 15:54:53 +0100
Message-ID: <20261118150359.975946320@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index a19ecf718f36a..84f97f448b2da 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -325,7 +325,7 @@ static void __usbnet_status_stop_force(struct usbnet *dev)
  */
 void usbnet_skb_return(struct usbnet *dev, struct sk_buff *skb)
 {
-	struct pcpu_sw_netstats *stats64 = this_cpu_ptr(dev->net->tstats);
+	struct pcpu_sw_netstats *stats64;
 	unsigned long flags;
 	int	status;
 
@@ -338,10 +338,12 @@ void usbnet_skb_return(struct usbnet *dev, struct sk_buff *skb)
 	if (skb->protocol == 0)
 		skb->protocol = eth_type_trans(skb, dev->net);
 
+	stats64 = get_cpu_ptr(dev->net->tstats);
 	flags = u64_stats_update_begin_irqsave(&stats64->syncp);
 	u64_stats_inc(&stats64->rx_packets);
 	u64_stats_add(&stats64->rx_bytes, skb->len);
 	u64_stats_update_end_irqrestore(&stats64->syncp, flags);
+	put_cpu_ptr(dev->net->tstats);
 
 	netif_dbg(dev, rx_status, dev->net, "< rx, len %zu, type 0x%x\n",
 		  skb->len + sizeof(struct ethhdr), skb->protocol);
@@ -1298,13 +1300,15 @@ static void tx_complete(struct urb *urb)
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



