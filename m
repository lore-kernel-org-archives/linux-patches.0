Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034037;
	b=bS8hJsx0Fq0zgaCSVGUXAksVXkHOhPmxjk9HJiO0Ylu6i2pCHvJ0jZ5bfVuS4QuR7MF8
	 /72YeNnUvLMnuWUl39ylvajQraLbjxqpAZYAPlc1J7quCUXKptMw2K6zDY9VzN4hkmYA4
	 cpHdLMZe3igZiXAh2W6mNU10wieEvj52PmRKfHe9C7RGAEyoBk7Hq8fa0uL840ls5lZaQ
	 bmvoEoejRH0ZR2uG8abR8oemKblTblZMjAJMpsYioLOaUK6xffa/Vpr3qaUP/+pklXfGn
	 MPk/h6rwTM4iqOyp7garvlP5s1hEGOhDXDWjst1JXkhVkz27SOaDypjkAhzQuY+SBhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034037;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3l5RdPmJP1/j0gvds0YkuMDwdIf9vo/QzH1GGldU8as=;
	b=feh9/mIc8DJUcwPL1nEUyvwfG9weKvvk4w0ocMdoFqdJ69gE7P5neovGTeYn1RCtFJlH
	 Pbnego/EDTFbE3RubyqqUdZfqfDzh11Hy2hhgDKxi/d3pBRGSwNCtDJJyJGzei7qgHVZ7
	 ZrzSoZ9ix1GpXepMh0rfmqz0CnaWp8lTL4Lh5c+s6fjFOgHxtnPU9EsFI+C3yXtEgO9ea
	 Av6R88pV0mUDR7qV5JBukOWwzOA9M7qS3FZj9+9cLhEbHiFg2wtJbuZfKoC306D6KxIDy
	 FaWLbOeEZ9dePXT/0zyZHO+VH95zh3RT1cuVKTjKlqQIqH51D9WYbgoGxIJcBLZvfjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OB82r4d3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 740F560A2607;
	Wed, 18 Nov 2026 20:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OB82r4d3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9CC81F000C5;
	Wed, 18 Nov 2026 20:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034037;
	bh=3l5RdPmJP1/j0gvds0YkuMDwdIf9vo/QzH1GGldU8as=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OB82r4d3sJ8gDLXlWFXVzn0W9svz4lfBhXLh5B62AurnfVL5S2VH+7r55M5Uk4um+
	 t2xv25QbdDrZFrHlJrvj57CEJXaneAqv+LoajyN/Bi+NG6GY+W7V0KT3TLqIuKyF3w
	 PC0L7L2J9fYcOl2eMB2qQxnohmetsI3uTaRYX4Ys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0227/3318] wifi: mt76: mt7603: file buffered frames under the TID reported to mac80211
Date: Wed, 18 Nov 2026 15:14:09 +0100
Message-ID: <20261118150321.858175306@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 525444953df68..19e78882aedd1 100644
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



