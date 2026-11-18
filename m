Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025846;
	b=JSl9t6xF/TxsnFLnOXspaM5QYKXL66jLYYiJnVfcFeQMfTS16Og5DGHnKP2RVBtFVQni
	 aCq5mTwQaK9VGMOQlppQ37XY/5NtujU/jLVp6D5WeVt3AQhPpZnN+2VMkwFSHxUY87TU2
	 gL6slb485XXTLfW6dlyaO8ZeFNhOVgfB9QCZ2FHAWWKN0Hn7ruNpXDjAlfi7uPAQN7W98
	 M3CUhcZVkv4n4061WK5Il5A82wwkBHQuqEIUwsWxRTJNAm6pkWLRKhMF7iOWzHmLpqRjo
	 YN/f8HWOf2p7Xq8zTDXrVzMChkJ/T/0eM/FEgI/rkOiQQQSSPgI8DO6jJBft20aK43Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025846;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Iwf9vMG0u6woEpvsxAZu6kn6RQDP1eIT5V6LBQDsr8U=;
	b=y2lrPTY27cAiwXe7hxqjAqqzsvc1vYuHlfXGojl28OQTGAjlnCfwkhjNTb1ELV70RIIM
	 jlylPfXJ5UbPm3IozHnQBzznRIhtQ3sZFN16OIjC0+YTGjtd7WgAGXpWE1mEcSz/5sJvV
	 +2ly5ZlSmDBvcuWnibhaz42BpWX3FNsE66NSgqVhIRe02DTVFzCRrF7XnoQhqR+StRG3F
	 1BTeSlRvb/xMGHRO1lZyGY1m9C9fIOyRnvsxksnlWUt2B2i9TtaDRA/e/w2cPQ1zs2FRu
	 NGYB43psHxizOR/uCpd7N/DG8dHsp1NF06fFf0/dpAAPHaySzjfD8jGPP7yUTQXxvkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2T3Epwtx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F3BD60A3821;
	Wed, 18 Nov 2026 18:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2T3Epwtx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A24A51F0181A;
	Wed, 18 Nov 2026 18:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025846;
	bh=Iwf9vMG0u6woEpvsxAZu6kn6RQDP1eIT5V6LBQDsr8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2T3EpwtxGdTNmf0McvEoOktOvlmbkHC5ehe9cDgA1qdTlRjGB5JqQfpEK4mTOpS5O
	 oC3kM7YdRaNHvPGtZt1snGXVjMCZ63YddflQalNc1AGX2gHd5Uiscerve54wFcm+0J
	 0/xnMoOebaFT06UuHc+sFY0/gpgZ5cVESCzJXYiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Papa <pcristian292@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1224/2151] wifi: mt76: feed the station RSSI average from the chain signals
Date: Wed, 18 Nov 2026 15:49:19 +0100
Message-ID: <20261118150206.781877722@linuxfoundation.org>
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

From: Cristian Papa <pcristian292@gmail.com>

[ Upstream commit e1534fef1ae4df6e16401117394c26dbef84f361 ]

mt76_check_sta() adds status->signal of every received frame to the
station's RSSI average, wcid->rssi, which mt76_get_min_avg_rssi() reads
for the dynamic sensitivity of mt7603 and mt7615 and for the gain
control of mt76x0 and mt76x2.

Since commit 4550fb9e9810 ("mt76: improve signal strength reporting"),
drivers no longer set status->signal: mt76_rx_convert() computes it from
the chain values when the frame is handed to mac80211, after
mt76_check_sta() has run. Except on mt7921, which still sets it, the
average is fed zeros. mt76_get_min_avg_rssi() then returns 0, so mt7603
and mt7615 leave the sensitivity at its default, and mt76x0 and mt76x2
fall back to -75 dBm for their gain settings.

Compute the signal from the chain values in mt76_check_sta() as well,
as mt76_rx_convert() does. On mt7921, the average now follows the same
combined value that mac80211 gets instead of the strongest chain.

Tested on a TP-Link Archer XR500v with one client, switching between
the old and the new input every 30 seconds. On the MT7662E (mt76x2),
the average the AGC works with was -75 dBm, its fallback, with the old
input and -54 dBm with the new one, while iw reported -54 and -52 dBm
for the station, and the AGC mostly used its low_gain 2 setting instead
of 1. On the MT7603E, the station average was 0 with the old input and
-41 dBm with the new one, while iw reported -42 and -41 dBm. The mt7603
sensitivity still stayed at its default: a separate bug keeps it from
leaving 0.

Fixes: 4550fb9e9810 ("mt76: improve signal strength reporting")
Assisted-by: LLM
Signed-off-by: Cristian Papa <pcristian292@gmail.com>
Link: https://patch.msgid.link/20260924032639.28158-1-pcristian292@gmail.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index 668767029599b..0ba5179ba7fa3 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -1470,6 +1470,7 @@ mt76_check_sta(struct mt76_dev *dev, struct sk_buff *skb)
 	struct ieee80211_hw *hw;
 	struct mt76_wcid *wcid = status->wcid;
 	u8 tidno = status->qos_ctl & IEEE80211_QOS_CTL_TID_MASK;
+	int signal;
 	bool ps;
 
 	hw = mt76_phy_hw(dev, status->phy_idx);
@@ -1487,8 +1488,9 @@ mt76_check_sta(struct mt76_dev *dev, struct sk_buff *skb)
 
 	sta = container_of((void *)wcid, struct ieee80211_sta, drv_priv);
 
-	if (status->signal <= 0)
-		ewma_signal_add(&wcid->rssi, -status->signal);
+	signal = mt76_rx_signal(status->chains, status->chain_signal);
+	if (signal <= 0 && signal > -128)
+		ewma_signal_add(&wcid->rssi, -signal);
 
 	wcid->inactive_count = 0;
 
-- 
2.53.0



