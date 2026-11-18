Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045395;
	b=nXxTVxUMOczD2Q3Ixbn+TmUCD29pmeLrd6YJHJVBJhsSYz0e3chuhx6RCxTxh7pRTjpM
	 /h9IrduMYlgzhrfjQObThEiNC6Yft91sfSd3Q/ViY0gWm/swzSShQp6Cp13FHy1Dre/5T
	 5WSCT/cNGIkp0b+9gUNbVhhgW9qqoOJ9jVQ6Sr32RTij/ZVmToHPDUNL1R/Gf2v/AISvW
	 pLwmYqvU9SOx0vUq9ivDowaMyjyz8Xs2t1M5aJDThWx5p8V2NwO03huKtsOnklS4vntKY
	 1O7HGHz7D+NWobgYUkk12gpdNzlmFdPljhQw1euBd9OIbbJ7l4T0rFEqqUKcg3p+l2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045395;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PHTr2gg/Uhih6vsmuSvVwQgoXWomqSnD62UsOvks26I=;
	b=hBHoKRA87kaAVNshRhXfQ1/RnYmpnaEHjk3hJYZNQtiWU6A6hsfngeEXpcUTiWsCHT/L
	 Q4k8RM2ByyM6vWW6ik9k9E5hHAFBgMgd7oEhjURzAnQKR7EM5KtMTaNAG22Wm8nb24mMu
	 cb0IFZyFvhwX4oaE68PUmkXHNpBUD3J5ipGIvpzvqsiU08pTEEA6vCUpZ23jjh9bp7nfF
	 ADNu4HjvkMMfUww12ojk9M2t3qkE0clRRHieZ7u3Qjq0CMdP/qYsVyuchrR6Om6SNqMv5
	 mJyi4gou/dKQOImcX4QXvBZOCqrNujphQ+8ayveKFBoKBJFfWy1i2qracpUK2UkOGcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PTYNNDoD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA34606A320;
	Wed, 18 Nov 2026 23:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PTYNNDoD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C59011F000C5;
	Wed, 18 Nov 2026 23:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045395;
	bh=PHTr2gg/Uhih6vsmuSvVwQgoXWomqSnD62UsOvks26I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PTYNNDoDvzPhB5+GLJ6pxzaZHa8XYiYLsh/tEDW9kGLXpR114h44VSjq5GY6tDYNf
	 lfZ7Dy+J7LCKG827pOE6CwN/IWTKqw1Vip1Yg9TFzt5GzacXFfQ9HsAXSAQvdu9Et3
	 kswn8Ucxy8F6+IRcYHDUOhosqpuAp3U1nbhYyEoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Mark Anthony Agarro <markanthonyagarro@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0891/2857] wifi: mt76: mt76x02: validate TX-status rate index before mac80211 handoff
Date: Wed, 18 Nov 2026 15:32:05 +0100
Message-ID: <20261118150233.638306271@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Anthony Agarro <markanthonyagarro@gmail.com>

[ Upstream commit fbd12e8dabc8a9d2e81f427906749b4cff85d641 ]

mt76x02_mac_process_tx_rate() extracts the rate index straight from
the hardware's raw TX-status word with no bounds check for the
HT/HT_GF/VHT cases, and mt76x02_mac_fill_tx_status() ignores its
return value. A stale or corrupt hardware index reaches mac80211's
minstrel_ht rate control, whose per-group rate array is a fixed 10
entries (MCS_GROUP_RATES), causing an out-of-bounds write.

Validate the index in mt76x02_mac_process_tx_rate() (HT: 0-31,
VHT: MCS nibble 0-9) and have mt76x02_mac_fill_tx_status() bail out
cleanly on failure instead of passing an invalid index through.

Fixes: 7c1f88812690 ("mt76: unify send_tx_status and related helpers")
Cc: stable@vger.kernel.org
Tested-by: Devin Wittmayer <lucid_duck@justthetip.ca>
Signed-off-by: Mark Anthony Agarro <markanthonyagarro@gmail.com>
Link: https://patch.msgid.link/20260826092755.480190-1-markanthonyagarro@gmail.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt76x02_mac.c  | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index 4c2092905314c..a845820024796 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -302,10 +302,14 @@ mt76x02_mac_process_tx_rate(struct ieee80211_tx_rate *txrate, u16 rate,
 		txrate->flags |= IEEE80211_TX_RC_GREEN_FIELD;
 		fallthrough;
 	case MT_PHY_TYPE_HT:
+		if (idx > 31)
+			return -EINVAL;
 		txrate->flags |= IEEE80211_TX_RC_MCS;
 		txrate->idx = idx;
 		break;
 	case MT_PHY_TYPE_VHT:
+		if ((idx & 0xf) > 9)
+			return -EINVAL;
 		txrate->flags |= IEEE80211_TX_RC_VHT_MCS;
 		txrate->idx = idx;
 		break;
@@ -493,18 +497,21 @@ mt76x02_mac_fill_tx_status(struct mt76x02_dev *dev, struct mt76x02_sta *msta,
 		first_rate = st->rate & ~MT_PKTID_RATE;
 		first_rate |= st->pktid & MT_PKTID_RATE;
 
-		mt76x02_mac_process_tx_rate(&rate[0], first_rate,
-					    dev->mphy.chandef.chan->band);
+		if (mt76x02_mac_process_tx_rate(&rate[0], first_rate,
+						dev->mphy.chandef.chan->band))
+			return;
 	} else if (rate[0].idx < 0) {
 		if (!msta)
 			return;
 
-		mt76x02_mac_process_tx_rate(&rate[0], msta->wcid.tx_info,
-					    dev->mphy.chandef.chan->band);
+		if (mt76x02_mac_process_tx_rate(&rate[0], msta->wcid.tx_info,
+						dev->mphy.chandef.chan->band))
+			return;
 	}
 
-	mt76x02_mac_process_tx_rate(&last_rate, st->rate,
-				    dev->mphy.chandef.chan->band);
+	if (mt76x02_mac_process_tx_rate(&last_rate, st->rate,
+					dev->mphy.chandef.chan->band))
+		return;
 
 	for (i = 0; i < ARRAY_SIZE(info->status.rates); i++) {
 		retry--;
-- 
2.53.0



