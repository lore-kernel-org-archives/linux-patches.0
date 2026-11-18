Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027992;
	b=P4FDCI8hiQzQ+qV0amYvZPWdaiESj4xqEnrn45CxVqHsoB/g2yjHX6viVN29M/G2iEnr
	 DzZk/8oxq56VmWbhyfeeionLWYdAHQAHVzdoNe3XHf4IamuRRFBMmE/00K4uNN5V3TX58
	 SLLcdJXsoM6PKU4bgpVn+yxYhiYD+I+5zxjfGP60UJYtNgWO/ptGev6qKOMmMYH1LMfCS
	 ztEjR1CEMx82IHot+j9pkbxGhZ2te42YDPPrC8fFgz17Jxc7XEB8wdGI/R3oNS1GWL8BY
	 qPTXP0ZTguOfhIPFVu6ZBUDktiBH3/A06mlwAsAacJevN0C/08aJPH2Qz45VZ+RwOUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027992;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/RTpzwTNnt1+XqlUV+Wi7aRUbpzX+fxxIhlJdQzuYnE=;
	b=s93k48ACS8MtwoOJUjANF2H/o1YjAp3Kx3+E0GWWWQxGkRRwTnyiHQ+jJAfUWfZZfuTf
	 vTBs3kWoqPfuKIN2J0VYu4EcjosLGt/TFeOXhXYP55iujwksZF8PK6Il/RF0/xHSfLNGP
	 E+2Vu2neiHXFC9x3mxeiCWG1wY7zmGvN9q7ZwLpA3aSrBhjFZIP0rqIZn5cT1JlC1arl5
	 Rem5ws/7V5cl3NRcy6OtHYkJR+es/g+McVERGDSIP7xYOzEwuHiEye0pzHQ5HoqP/fCma
	 8gyDxawqi2bjsmd3422ZfVse7qt4O2sxlxce1caWNU5gv4yYDsUss64MubshdH6ATGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vFLsNw6t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B89E606A31C;
	Wed, 18 Nov 2026 18:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vFLsNw6t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B18EB1F000C4;
	Wed, 18 Nov 2026 18:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027992;
	bh=/RTpzwTNnt1+XqlUV+Wi7aRUbpzX+fxxIhlJdQzuYnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vFLsNw6t7nTDpKIGm+uVSMbLPyjxr1qp99F872ih8eS2bVZQiQ7WGiS3/Pp+t22hC
	 olnVnp/qEQH340UbBZO5/9NjowVgxXcUYbJef/cFmS7du6e16VPk7ZICxVEXq4b9rW
	 pOPlvJfsX1u1wQG6wbrtwLN3X6WZkSk3RPDMEhw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikkel Eskildsen <mke@visotia.com>,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1985/2151] net: usb: cdc_ncm: dont enable BHs in tx_fixup under netpoll
Date: Wed, 18 Nov 2026 16:02:00 +0100
Message-ID: <20261118150234.039079004@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 81d7e99fc0f09..ca06525892ac3 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -1535,14 +1535,17 @@ cdc_ncm_tx_fixup(struct usbnet *dev, struct sk_buff *skb, gfp_t flags)
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



