Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062226;
	b=2UJoCjP4gLQIhjEoJL+4vD50+jg2IC/stA6z31c00vsf0XtvehdVCmm7F+V3/50I3HKU
	 fbeYODRFN8MKCVmA42TZ4vGZiYsP9/ChBLmO8LCHOB9p031QhmFLDtDcAFBU1644dKqDY
	 GTLfGAEfaXxnW9Qhzvqt/8tbt3NNzFpd3eaZv+IjzsDF7VS0VhD3YlBYJXwKwA/NzGdxk
	 ThiNfnWjY1xQxMI2wkkZL53576b+OFe4Ja4O2qriSLsbOQnfyFDlG3HvbS1r+hIldjjAG
	 q4WO8q4WV7s/pM5UHV2jZpvMB1w4I4MAJkUYh/o1v3wxHLHtd4mbTLz3appWtmbblRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062226;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+rtUEtzv9cYegzYImk78RulQp604YM1DgPH1fi2jFKM=;
	b=24GMUfZgGlWX5O/V+szsmiR2zJBKOqjID+/Wzjmpqqqzp9vJeZKOddvo1toaatA6sxHY
	 Y53udz7D7xhBxBcHSj3q1ieVE9x+LmzWKM5YU1+X24u8QetDJIDT56b5VLdd8hDpy2Y4y
	 Uf6i/Yug/DJLb8/bJaplvLzgiM2KhqbDyOLepMmAdyxL31EIdLpBPJdHEmKul4M1egbHT
	 UwfOfMHQn6BCknvS8Kn722lOCvT/AzmSCUmPQV7xQq0GIuUOuDSR6zJQsHLDAKWktQfhY
	 cXqbJe4q3XXStM53uvxeAt3R8/63wS3HbZmw3uNq+963eQ5z2zTFUKYZOSKVIahyATw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BNabiLvr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96A27606D83C;
	Sat,  7 Nov 2026 14:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BNabiLvr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40D991F008A5;
	Sat,  7 Nov 2026 14:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062226;
	bh=+rtUEtzv9cYegzYImk78RulQp604YM1DgPH1fi2jFKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BNabiLvrMJ7LHVB6fg8iPgMFlA0X4lNkme/n/Awnb2JYSI+uQ5alHlTaNt826Tdf1
	 +X4QNi/chqAYRJTDySrj8/iVXrGLbIybUWzytJprMqFwCvCEjjzo0gHVZKeAE+qgoP
	 8uHCP82mijbNsIjBJLrODuWwxQkdRgfUbxkUA/V8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Mark Anthony Agarro <markanthonyagarro@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1178/1536] wifi: mt76: mt76x02: validate TX-status rate index before mac80211 handoff
Date: Sat,  7 Nov 2026 08:53:14 -0500
Message-ID: <20261107135030.828023553@linuxfoundation.org>
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
index 14cfa597fb622..d5ee2bb6f679b 100644
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



