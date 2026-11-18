Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062080;
	b=XXRXKmC/28MYZUZeyEfkfrY1E0DKlyFbNbwPAMON1U5/MZAmLK8guZlNb0CbGvSeEf0F
	 NXrT1LOtLE7xAzWQcnhIBWUr2Uoo35sRhkYtFhQgwAGm05Str4+p24RACFsIMPZkI/HmV
	 YQDiCpIun4cSGvbNonhxyWi7mjguB2IMYvFoDGug5YgICUgYwd8eHb92XJ7p5VXoyDfCW
	 ndTew/ERAmd1Tv+s1mnG4C4/hj2ViqOQ5Okc1NJgLNynhKZrZwJjgUJdflgvGOxOkGnKh
	 4covcZ+AZD4QfVwYkTFMPrQXWveSIziNG6D/7qa2drzemEUa6+hs4s1QhM0LQdpDqSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062080;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=L5ZbaWbw/j815E+3pqPSPO4RYomTnZ9Ud6YzxJmREUU=;
	b=cTTrYjB8Uq68QyUns+IsnS+2OqlXhj3BWoY+HIemXQZoALJU9ToADsW3xVkqHdD61Ntx
	 fMdmwLKGAM9mRzOGlLuhbugg8EggFlg9qQEwIp1bPVGVckgYxvBtdlbi7aSUKPSD4fWY4
	 /F3YkvX0hv4kAk+ndhU3le/dedv8h9FbzKwR8Z97BR+bFc+pMQblDoBUUfgxbQBqSsVf4
	 KO+sYEDtON7CIpa6XZ7xq6S1uInSVZeNjK5c8JC56h2VFMuovMsdwZgW5Wx6yvxeKoumz
	 nQUzyN7h2NXQTC93YFXGxDNINjdM/VtUvR0D0HK887AD6zdE/fnQNsXzz6LqVLY8X6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=14aanWZ6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1344E606A326;
	Thu, 19 Nov 2026 04:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=14aanWZ6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 633E61F000C4;
	Thu, 19 Nov 2026 04:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062079;
	bh=L5ZbaWbw/j815E+3pqPSPO4RYomTnZ9Ud6YzxJmREUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=14aanWZ6bT6wJuXz5aUTsMfbvwv4ru0JkPs3KIIS/hmItWx4REjn7wUOzwf6QC5lG
	 +55DDcu814sgIstNf9HWC0gfXZD0dtCc1Y6pfDPTXb3M0F5iR9RptYVbRQnG2V81VK
	 7q8lSpt14voDvg/B0x+d5OhVVCwjZq7Yx836E1H0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikkel Eskildsen <mke@visotia.com>,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1783/1848] net: usb: cdc_ncm: dont enable BHs in tx_fixup under netpoll
Date: Wed, 18 Nov 2026 16:03:41 +0100
Message-ID: <20261118150033.979450889@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 57b1e6dc62f07..dc39ca3295edf 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -1517,14 +1517,17 @@ cdc_ncm_tx_fixup(struct usbnet *dev, struct sk_buff *skb, gfp_t flags)
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



