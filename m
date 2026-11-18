Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032959;
	b=DXrQJJ+tQUtW5ya8LLFMW76kCzq5qXsXLDHeVXl/dD9bgUP7v+1NlXqH6QjQMBFJJcdv
	 20dLgB+bO9sDrOQMY/ETMseThNLF+yjIfe1WIblwIyf21efYCjnNGc7q5EzWyM8cdq1Gc
	 0i7p70i46engATbA1i7VnKjzKF9YCam6bzXASDosp8PO8oWxQry8D3/QeVkhoi4AtoTk+
	 oyAfsM3WLALUGwD/f2OrYLppU7LifgbZA0KpTpd9IYnpNrwnMi/dosKQBWodOkwtFMWDz
	 2bw2XD8bwFiXFlAEdW4kh21r6lrN/Fz8aJFjOGi+gKIIj8kTitRAAiY1NgKeUTF7YUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032959;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3+wM7BeLfbJQn2NuD8khfHQ+5mPzufJ8R4AD1Nbp9+k=;
	b=0mjQVHCLcEVchxjWsl+aTn8LXf6VTEzlPIQ8OH3biBlHsyWy1zE54GpNJ8O9MHNgR8UQ
	 YmeC3NSuRQU+DVluJLjMcYH2TQ5yEuSpeU/SMYduuJYE4oFW53qbTpBhvgdGTnmfTRyY7
	 ZLBxwKz5Y2MNcE6rY1n9Dz6GN/WeWkmbZalfPf3FElhKmYPT6JvKDxv4EUFP/1DbYjnu7
	 ONKJ1CRadSnYvZQHh5KP11LOm4gJZ5M7iXaxWwFSU3HipNrkQI7MfGvdelaFYUM6wqzMd
	 xN5/ls5pycqFIQ3ieJfDnBFlbJqWupBG0uTbvor+ojhxDh3bJRFcQFhExFY0r3USDHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w+lC+Llw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98E62606A31C;
	Wed, 18 Nov 2026 20:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w+lC+Llw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFE821F000C4;
	Wed, 18 Nov 2026 20:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032959;
	bh=3+wM7BeLfbJQn2NuD8khfHQ+5mPzufJ8R4AD1Nbp9+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w+lC+Llw2Z/C3mlyiR+TG05QpxgeMR3rolpV/qNwPKxp89vldTbIbbsndcdgoVChv
	 aqIWdHexRhmj7/HuH3FFImfMx2WMlm6w5sH01yGbBIrrhi8KVy9Y/2z2dAGDz9bsML
	 QRCB8XkIB296NI0hkJsl9BclY0TbN73R0lETrKIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikkel Eskildsen <mke@visotia.com>,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1595/1756] net: usb: cdc_ncm: dont enable BHs in tx_fixup under netpoll
Date: Wed, 18 Nov 2026 16:02:02 +0100
Message-ID: <20261118150113.416762342@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c00699cd3e350..65a156ffdde96 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -1536,14 +1536,17 @@ cdc_ncm_tx_fixup(struct usbnet *dev, struct sk_buff *skb, gfp_t flags)
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



