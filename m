Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023690;
	b=WC19FBic31z49dUO9r9tZB1/qbSSigcx1wXuZ5Vsr3GWSn4lB08BJNVmPMcsDjQ6enel
	 mjJENpLRe+gadf7yz7FznyeJti0XeddZhjJFNq9NsS/3AdSYDP0lCKmsXCyFm6DjZSoaQ
	 nhgBQhlBy+gNW3OL6PeyBV/hBumOgze26YkOeoeBx8zomuY0I5iEPPUim3lu1Ee4hq4+C
	 EPIuF3vu+r8o2RTZhaOPPXXT2TeanVrORLwSifTlsGWD+VSCm2K4Q0DWMcY5/U2RHdxOg
	 o+Jg9wD4lc5pm/l9uX+mvA8J+M1ZKrFWjQXgw/cdyDzWnAk5eB8pAhBRMaEfpbTxCnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023690;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MLpo9L6yZ8XJ7peIPZK3ZWJ9xbf18Jb3MJYpX48eHGc=;
	b=hrBVyL0wS/PCbcYJeFup05WwjUGnYfcsffEbYuDrP+hfKlgCHY5C5Ltu1kArGwBMH0M2
	 hJN2l+xUTxvJNmorVaJjE4n8MxH85rwD0CQdXVSF2Ovi5Q2U30A5GpjS5HJV13rRU1oHa
	 O+Iu/KwzzoWNs9QH04GN68YKvK3A5ELbH5qrbXdiO+1978j6sEanOsh8TgHsgIP5ygByc
	 62kGIV9cdmoi7NwtjHl5DlOqg9V16pAMpsIj/EXLFVGBdUM5VL1yVTdf9bYbtUX6w3mgI
	 4p+giEhv1v6U4ipoVgIqkeqLugYx73D9a26Cm1YYOqu3oh6tQwoXy7MCxmqGTMsrVdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DRIdsPpU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F17A606A320;
	Wed, 18 Nov 2026 17:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DRIdsPpU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 705091F000C4;
	Wed, 18 Nov 2026 17:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023690;
	bh=MLpo9L6yZ8XJ7peIPZK3ZWJ9xbf18Jb3MJYpX48eHGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DRIdsPpUOcnLVvQMeAfAZmRXue7BSwKdXCoEtxWDQ7MzqAQao+4Aodfqkny/LP/NX
	 PYQqe4sZ397NO0o0JzSmHkUjwLfqouDcyjr2vpCsYxAIwDHtA2vMBS9urOMLNUv1Hu
	 JimJFbNXpwLB5R/vet2tyEDE/1cN9lBHfYGgLAwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luka Gejak <luka.gejak@linux.dev>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0458/2151] wifi: rtw88: sdio: zero the padding added to a TX transfer
Date: Wed, 18 Nov 2026 15:36:33 +0100
Message-ID: <20261118150138.707682608@linuxfoundation.org>
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

From: Luka Gejak <luka.gejak@linux.dev>

[ Upstream commit b81ead28aeb1fd9bc3b0de4e20342b6b538ac658 ]

rtw_sdio_write_port() rounds the transfer up with sdio_align_size() and
then hands that length to sdio_memcpy_toio() while the skb still only
holds skb->len bytes. The difference, between one and 511 bytes, is read
from beyond the end of the frame and transmitted. Whether it stays
inside the skb's allocation depends on how much tailroom the skb happens
to have, so this is at best sending uninitialised memory over the air.

Pad the skb up to the transfer size first. __skb_pad() zeroes the added
bytes, reallocates a cloned skb rather than writing into a buffer a
clone still shares, and leaves skb->len alone, so nothing else in the
transmit path has to change.

It must not free the skb on failure: rtw_sdio_write_data() frees the skb
itself and rtw_sdio_process_tx_queue() requeues it, so both callers
still own it and would double free.

Found while reworking this path for the RTL8723BS. Measured on RTL8723BS
hardware, padding the transfer costs about 2% observable over transfer:
uplink is 19.5 to 19.8 Mbit/s padded against 20.9 to 21.1 Mbit/s unpadded
in an interleaved A/B, with scans, reconnection and a UDP flood clean in
both. The other SDIO parts sharing this path are untested; I have only the
RTL8723BS.

Fixes: 65371a3f14e7 ("wifi: rtw88: sdio: Add HCI implementation for SDIO based chipsets")
Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260909074556.55709-5-luka.gejak@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/sdio.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/sdio.c b/drivers/net/wireless/realtek/rtw88/sdio.c
index e35de52d8eb43..2fa8563940fa8 100644
--- a/drivers/net/wireless/realtek/rtw88/sdio.c
+++ b/drivers/net/wireless/realtek/rtw88/sdio.c
@@ -636,6 +636,7 @@ static int rtw_sdio_write_port(struct rtw_dev *rtwdev, struct sk_buff *skb,
 			       enum rtw_tx_queue_type queue)
 {
 	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
+	size_t pad_size;
 	bool bus_claim;
 	size_t txsize;
 	u32 txaddr;
@@ -646,6 +647,17 @@ static int rtw_sdio_write_port(struct rtw_dev *rtwdev, struct sk_buff *skb,
 		return -EINVAL;
 
 	txsize = sdio_align_size(rtwsdio->sdio_func, skb->len);
+	pad_size = txsize - skb->len;
+
+	if (pad_size > 0) {
+		/*
+		 * __skb_pad() must not free the skb on failure: both callers
+		 * still own it, one requeues it and the other frees it.
+		 */
+		ret = __skb_pad(skb, pad_size, false);
+		if (ret)
+			return ret;
+	}
 
 	ret = rtw_sdio_check_free_txpg(rtwdev, queue, txsize);
 	if (ret)
-- 
2.53.0



