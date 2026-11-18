Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019255;
	b=LZxOFp+p1xSoUCdH+UTzGIpiGEqmgvmp+Vd/JY14QPxKuZr8soY4usiS++OIH/CFT5g8
	 D9xBmAgCTVp7VNZ2u3W96iItMgVLSu2dUa1I0IckSSu1zIIecFxbr0MsyPdiaB3HkhDm3
	 SauzyJcBJMK52U9VSx30hvCP/Z+fRU2qkQRitKoCltav5gNgK7A3Ajd5W+rmSzIuvnwFX
	 L8Yg6ilNb6p5v0Bcfxdd8UcRqya8PNiYemZJZU4xaGtBCm8S00Ax/VL8oX7oF1FmpPBnV
	 fLsoqxmbDjV2by25KXMFtp2W+fEJQTEVKQUkZ7Y8xcCe6f/H1truUF4UAjHtlfyYSVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019255;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SmaxoejLjiqEZk8zzSoLDqXRg+kx8en4IMWTqM9oZdQ=;
	b=LF+mopN6VmolUAxtwXTnp45mND9rRvp+ZUSYbDo8lnZIxhwW182OPbyz0Kig7fWhs+cq
	 DbgIgoDhpCj7begWM2k3dNy/AXS+9yfj8wjrznNpusT1RJ2FDt4fDQMajVmHzwYGLCA7R
	 SdbLo/EG6L0esv2gKgPZVhZqmTmgN+Lmd5kJW4tDFKp2SnKbb4/Q5OgjS2BP/VYAg/phE
	 rk0Ms15i0b7U/avrELXZJAlQkTjlt2b04XW/gMHmF6tu+TRlJZDF3lsJSPvTfZH7ZJ9Tz
	 6mmAMRGTzPVnbR/P+pUIN79el5i6zaxY7kY6bED+Wx/gJyS8ogKrU5MdmVM+2DtyZqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tsZj9mnO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0660A60A2619;
	Wed, 18 Nov 2026 16:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tsZj9mnO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A1C01F000C4;
	Wed, 18 Nov 2026 16:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019254;
	bh=SmaxoejLjiqEZk8zzSoLDqXRg+kx8en4IMWTqM9oZdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tsZj9mnOfPhcEKdljUCufS4IfvvezAwRRmdvesoLqR7l5zDZ0c6z9Qrb0gDx5nX+/
	 ybnmLe9Y9FSuMWDbb7Kgmmt6a6ZJLdW1+kYSjtP6aoh3LnVc+meX59U6jef5J7A4uW
	 kl/iUR2H7XiKmr17bEGOV65zQGJ9u/lJfrs1JiE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1490/2651] wifi: mt76: report an aborted scan or ROC to mac80211 during a reset
Date: Wed, 18 Nov 2026 15:45:30 +0100
Message-ID: <20261118150341.659039637@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit a45aea434cd7e0b4c3cea5a0ca4ebc54a6388a1c ]

mt7996_mac_full_reset() and the L1 SER branch of mt7996_mac_reset_work()
abort a running scan and remain on channel. mt76_scan_complete() and
mt76_roc_complete() then skip ieee80211_scan_completed() and
ieee80211_remain_on_channel_expired() while MT76_MCU_RESET is set.
mac80211 clears a hardware scan only from the completion. After an L1
SER recovery, which does not restart the hardware, every later scan on
the wiphy is then refused, and a remain on channel stays pending until
userspace cancels it. After a full reset, ieee80211_restart_work()
warns:

  WARN(test_bit(SCAN_HW_SCANNING, &local->scanning),
       "%s called with hardware scan in progress\n", __func__);

Report an aborted scan to mac80211 in a reset as well, and an aborted
remain on channel unless a hardware restart follows. On a restart,
ieee80211_reconfig_roc() restarts a remain on channel that had not
begun and ends one that had. Since the scan is reported as aborted,
mac80211 does not continue it on the next band during the reset.

Fixes: b36d55610215 ("wifi: mt76: abort scan/roc on hw restart")
Link: https://patch.msgid.link/20261007112419.1277594-2-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/channel.c | 2 +-
 drivers/net/wireless/mediatek/mt76/scan.c    | 3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/channel.c b/drivers/net/wireless/mediatek/mt76/channel.c
index ce1824da75631..243d252e76440 100644
--- a/drivers/net/wireless/mediatek/mt76/channel.c
+++ b/drivers/net/wireless/mediatek/mt76/channel.c
@@ -336,7 +336,7 @@ void mt76_roc_complete(struct mt76_phy *phy)
 	mt76_put_vif_phy_link(phy, phy->roc_vif, phy->roc_link);
 	phy->roc_vif = NULL;
 	phy->roc_link = NULL;
-	if (!test_bit(MT76_MCU_RESET, &dev->phy.state))
+	if (!test_bit(MT76_RESTART, &dev->phy.state))
 		ieee80211_remain_on_channel_expired(phy->hw);
 }
 
diff --git a/drivers/net/wireless/mediatek/mt76/scan.c b/drivers/net/wireless/mediatek/mt76/scan.c
index 7bf9b7d4a8d7b..4a5cdb4efc61e 100644
--- a/drivers/net/wireless/mediatek/mt76/scan.c
+++ b/drivers/net/wireless/mediatek/mt76/scan.c
@@ -39,8 +39,7 @@ static void mt76_scan_complete(struct mt76_dev *dev, bool abort)
 	}
 	mt76_put_vif_phy_link(phy, dev->scan.vif, dev->scan.mlink);
 	memset(&dev->scan, 0, sizeof(dev->scan));
-	if (!test_bit(MT76_MCU_RESET, &dev->phy.state))
-		ieee80211_scan_completed(phy->hw, &info);
+	ieee80211_scan_completed(phy->hw, &info);
 }
 
 void mt76_abort_scan(struct mt76_dev *dev)
-- 
2.53.0



