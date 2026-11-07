Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060895;
	b=TEj0mXm6AiCNcMEaXmhZauW4I0uwMdcFXEaS4ROnt9P/VOk21wIlMy/cTlKqSw3m33LA
	 +N15cXEkTfuLBGzYBfNLJCjm2MjlmZ/y0i2kgv50FdseMZM4BYD3t4hlV5lFE32P5psaO
	 XxScaqGM04xHEs6c7DL/haUBL/b44GZ22ZxZ6b14sozu9+hiGk5QM1RgtjYXTl4r3n7ca
	 +towifo+mvQnGOEjY36F50hYpRF6/5dbA9gWHn94kZm9851R6DL081/Gu+4LpWp9hjNA8
	 Gscw/0fUJ1cCn7wBCXwPgYBZfGimj09hS5IBJ2Rck5OBE2LnWXRpGr7Jdb+1K2H5E+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060895;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zwml+JGpK9YY17pV5e+ylCDlwxGwyu38dnAXjKcSAh4=;
	b=4SScVM08cwpHCr5P9kXT6Wi1TewvbOxm57+yaO+A4wvz2VuaVH+tZFIyVJN0L1Fx6Ltc
	 mhTaBn62nKhUtq3o3/cDlFFqFj1yGDFcz9UBTPdX2RzZ5/cvtIjt+K4yza0OQ2lFKrWqj
	 TWCQyZE1cHTwze3d3zVErz0MmPyWjIllHiCWYg5p0WSdwLSxdzb1E+9Rh/cVmSV0K/Mwl
	 YtlJazsxZZelMA1I6oIvIBRdL3MvnjF5y2EYAKca16SsOPIqI32uRBEz0NcQsN8kiFD+c
	 MezdY+Zp+yO8QimgUUKPA3bI42zWD6fcLZWDgSQ/rZ/2dZAUW3OzXjNrJg0qYvaRq3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OoQMndmP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69104606D810;
	Sat,  7 Nov 2026 14:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OoQMndmP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 107461F0089F;
	Sat,  7 Nov 2026 14:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060895;
	bh=zwml+JGpK9YY17pV5e+ylCDlwxGwyu38dnAXjKcSAh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OoQMndmPiC0M6QMT6dAbw40l6Lv8c0I6LLr5pGQfr1ogI8qHXuqDl7QiI/c/05Tus
	 Kp8iJuqCSVfvsh+LTV94mFS7cESyTA3tNGOID1XW1+sRVP0piHfqE6m/XnQjSGpiag
	 Xjrw1YHpPoi9qfTomQO17ZRN8Y4egSwuOxGaFTLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0270/1536] wifi: mt76: mt7603: file buffered frames under the TID reported to mac80211
Date: Sat,  7 Nov 2026 08:38:06 -0500
Message-ID: <20261107135005.264066731@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 0bbd6c52dfff62b319963f54cd9370f9486e59d2 ]

The PS queue filed redirected frames under the TID taken from the TXD,
while mac80211 was told about the TID taken from the QoS header, or TID 0
for anything that is not a QoS data frame. When the two disagree,
mt7603_release_buffered_frames() skips the frame because it does not
match the requested TIDs, so it stays in the PS queue until the station
wakes up. Buffered MMPDUs hit this whenever they were sent on a
non-zero TID.

Use one TID for both.

Link: https://patch.msgid.link/20260801145334.1166751-8-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7603/dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/dma.c b/drivers/net/wireless/mediatek/mt76/mt7603/dma.c
index 863e5770df51d..1e34cb6beab69 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/dma.c
@@ -39,7 +39,6 @@ mt7603_rx_loopback_skb(struct mt7603_dev *dev, struct sk_buff *skb)
 
 	val = le32_to_cpu(txd[1]);
 	idx = FIELD_GET(MT_TXD1_WLAN_IDX, val);
-	skb->priority = FIELD_GET(MT_TXD1_TID, val);
 
 	if (idx >= MT7603_WTBL_STA - 1)
 		goto free;
@@ -72,6 +71,7 @@ mt7603_rx_loopback_skb(struct mt7603_dev *dev, struct sk_buff *skb)
 		hwq = MT_TX_HW_QUEUE_MGMT;
 	}
 
+	skb->priority = tid;
 	ieee80211_sta_set_buffered(sta, tid, true);
 
 	val = le32_to_cpu(txd[0]);
-- 
2.53.0



