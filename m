Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056846;
	b=V1NGFQSCbt+9Jeb3RHReNIjOP/FkySE2ntYJbi+Ju8OfV0RXqqPnrSI01TM7/cuG8yXJ
	 /h8Zf11dGrjP5+LQI6bNgE2faxswPWH+BPXiOEJ7i1zZkYE3Rl3LW1xCRav5PodgjdK1K
	 qXfVBK1Ne4O1UddmjijRVvzHxgYrd/vocGVWVNhU9AwO4iXv4uBzTWTkJgbAQrPE/NzVp
	 kUZgAKQb08SycizJNIO9k7d+LehWSpmwnVfKuz8MN6wsY0UCIVbiNAf02cwoMRxRnIBGL
	 qlRtqv5uokWnVk1gI9Rw7AxTlhVmWb4KXCV8YFsJ4N8QO1MS0B4JzAdWXqTtNiaJl6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056846;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NwHjCoEq9mKR47qsPuiZaVldqgu6lYug/D4H3tvqgqI=;
	b=vTauCs03becyN/k1Wva6/FdWRxAJvwq1kG1JmHtuBCyd5m089hMYJhLhlbtI9UmzmGM0
	 b+s2Pu+xB+deADJLmuA6v45yxwVtQIfkMfZqWf1D1FuILFfnVe80TRucy9UaAiHBqPJLF
	 JFMYc0Xvwh4K6EzTJttOHKM+sRjLF9O0z9nJSN6HsCAXxhPdaIw2AG7P+PBkri3gIhS76
	 MX4SUMF0/pgS0tKdFSpL9uh3jG2R7oKDkpTX6mqBt5tKSNz/QZblbO5JzX3mRSC70NjBy
	 5iNBcXrzawZP7o/4r317fjRHZ/jbX72inhN4P0wPi9v0HhFwVUVv9v71g+63+chHJrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1ZHDOMho;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFD89606A330;
	Thu, 19 Nov 2026 02:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1ZHDOMho
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E8A71F000C4;
	Thu, 19 Nov 2026 02:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056846;
	bh=NwHjCoEq9mKR47qsPuiZaVldqgu6lYug/D4H3tvqgqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1ZHDOMhoVVGtK37ACBfqodx5SdoYFRq75yqfRwofUQXbRzRSe05wEtO7WDfhuGrt0
	 A7wk2IS+Lb7711NWZ+COd+flW25a/TmXaoJvu6gCGHN1NIl2ovxj7bGbAhHddqR26c
	 9ODqdh2ROSWvEUs5Eqdo6ZFtkCiM++QyI1/QDliI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikkel Eskildsen <mke@visotia.com>,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2134/2214] net: usb: cdc_ncm: dont enable BHs in tx_fixup under netpoll
Date: Wed, 18 Nov 2026 16:03:30 +0100
Message-ID: <20261118150135.901498044@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolai Buchwitz <nb@tipi-net.de>

[ Upstream commit 108ca34cf4b453f6375a70079e32b11866b02601 ]

netpoll holds the txq lock and calls ndo_start_xmit() with IRQs off but
BHs on. The spin_unlock_bh() in cdc_ncm_tx_fixup() then runs pending
softirqs. If one of them transmits, it spins on the txq lock that
netpoll holds. With netconsole on a cdc_ncm device this ends in a soft
or hard lockup.

Every caller of cdc_ncm_tx_fixup() holds the txq lock with BHs or IRQs
off, so the softirq user of ctx->mtx cannot interrupt it. Use plain
spin_lock().

Fixes: c84ff1d6dff3 ("cdc_ncm: reduce driver latency in the data path")
Reported-by: Mikkel Eskildsen <mke@visotia.com>
Closes: https://lore.kernel.org/netdev/PRAP189MB185019A5A8D411482BB6E0CDA9982@PRAP189MB1850.EURP189.PROD.OUTLOOK.COM/
Signed-off-by: Nicolai Buchwitz <nb@tipi-net.de>
Link: https://patch.msgid.link/20261024-cdc-ncm-netpoll-v3-1-6284ca03f967@tipi-net.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/cdc_ncm.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
index dd7469d310c34..7c9108205743a 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -1530,14 +1530,17 @@ cdc_ncm_tx_fixup(struct usbnet *dev, struct sk_buff *skb, gfp_t flags)
 	if (ctx == NULL)
 		goto error;
 
-	spin_lock_bh(&ctx->mtx);
+	/* BHs or IRQs are always off here. netpoll only disables IRQs, and
+	 * spin_unlock_bh() would then run softirqs with the txq lock held.
+	 */
+	spin_lock(&ctx->mtx);
 
 	if (ctx->is_ndp16)
 		skb_out = cdc_ncm_fill_tx_frame(dev, skb, cpu_to_le32(USB_CDC_NCM_NDP16_NOCRC_SIGN));
 	else
 		skb_out = cdc_ncm_fill_tx_frame(dev, skb, cpu_to_le32(USB_CDC_NCM_NDP32_NOCRC_SIGN));
 
-	spin_unlock_bh(&ctx->mtx);
+	spin_unlock(&ctx->mtx);
 	return skb_out;
 
 error:
-- 
2.53.0



