Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025812;
	b=MsxDsf8fcQMg8r9jv8vFCS3GKMgnp6vW6F1zyiSI3EIhMHhRIT3oh3AYoLBclY5+TCB8
	 Ioso97ieRo+/OodjbdTo0itH9nEWu6Fb/rHZhvE/nqPzDUUr7xv2Z8KN2vBUlzEFrogBg
	 J/TYl09M2Bew60qSSKQrdZJUWvHj1419TMZ8hgLokn4nRQHa0oMv6Jh4aPJ/2BPlWPf+u
	 /h0Tv4bIwjTcCkUWaGi7e2fE/1AEfopdc9idhuVj89Rva4PR4Mp5aZsyDVFane/wtC1Dx
	 FejAEPEufGXSRVN+4pW9stPNpT582QKH7jLteXVPki3Rb3fRXP9vuC+8TIuQLFEix/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025812;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2cS15EhAEnfc6H/pEMcIN2N++oApQB8A9v5oYYuLExI=;
	b=RjQGZIIAfvNvxBfdadvvc+M0Yfc6o+eyvlwm7lHm2DCEDDho0PQi03s5CeyIBQzuzMkH
	 alHulI9Mr0dKX4CRBdNjp3ODPhJUBaRsXqdvxfJAvgCCr+nazwgxNz/+daqMP0a3SfUmk
	 1zt4a6QoUAAGV5aJQKbyC3Csqv8r+Er+/Ycga2/KQ4B5QP7PTM0mzkl2PE5o6Kk3Ki1IX
	 Yxo2OkRprOpjRcZ3Z5PPTkzb+U473AwvnFMgZ6fkv3htNOiRKrwMd8/vAsZb/XbXtZHu0
	 guqiWebYYP/L1KX+cPYrzdSXzBtJgyoQvb6ufJAgX1RTDZup5Iuu5sjOEQ3FvfN217w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zsp05a0Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B227E606A31C;
	Wed, 18 Nov 2026 18:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zsp05a0Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 121E41F000C4;
	Wed, 18 Nov 2026 18:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025812;
	bh=2cS15EhAEnfc6H/pEMcIN2N++oApQB8A9v5oYYuLExI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zsp05a0QEauzcZliB/cM3i27KARW2M+960rGG915UNx8DCDggSnM0m1XTCb3oKSjR
	 TBNCcyBmgUE+8ZurccohX65Uoa9BFpoIE0CsArD717TrkP0iYnGXm/Ie4fG7A6OoC+
	 Gk0djUmVHK3SIJRioKN5G53WgOZ/6Rfn1UJGSMrw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Anthony Agarro <markanthonyagarro@gmail.com>,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1213/2151] wifi: mt76: mt7921: keep the join ROC until the station is authorized
Date: Wed, 18 Nov 2026 15:49:08 +0100
Message-ID: <20261118150206.386551920@linuxfoundation.org>
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

From: Mark Anthony Agarro <markanthonyagarro@gmail.com>

[ Upstream commit 6f591a4bb5d9a6a4a28f3f2fd77f394ddbcc4e05 ]

When an association succeeds mac80211 calls mgd_complete_tx(), and
mt7921 aborts the join ROC there. The AP starts the 4-way handshake
right away, so the abort lands where message 3 arrives. On an MT7922
this loses message 3 often enough to matter: the supplicant sends
message 2 (acked), never receives message 3, and the connection ends
with reason 15 (4WAY_HANDSHAKE_TIMEOUT) after about 3.3 s. The mt7925
capture in the linked issue shows the same ordering: abort, message 2
out, then message 3 retried by the AP several times without an answer.

Keep the ROC after a successful (re)association on a station interface
and release it when the station is authorized, on disassociation, or
when the station is removed. The ROC timer still ends it if none of
that happens. The state lives in a flag in struct mt792x_vif so that an
unrelated ROC, for example a user remain-on-channel, is never aborted
by the authorize hook.

Tested on an MT7922 (PCIe), kernel 7.3.0-rc4, WPA3-SAE AP, two rounds
of 20 disconnect/reconnect cycles per build in the same boot, unpatched
and patched in ABAB order:

  unpatched   34 of 73 association attempts: M1 rx, M2 tx acked,
              no M3, reason 15
  patched      0 of 40

Delaying the abort by 20 ms before it made no difference (8 of 29),
and delaying 20 ms after it removed the failures (0 of 20), so what
matters is where the abort lands relative to the handshake. The
firmware behaviour after the abort is inferred from these outcomes, not
observed directly.

Not tested: MT7921 and other connac2 parts, USB and SDIO, APs other
than the one above, open or WPA2 networks, scheduled scan, suspend and
resume.

Fixes: 41ac53c899bd ("wifi: mt76: mt7921: introduce chanctx support")
Link: https://github.com/morrownr/mt76/issues/106
Signed-off-by: Mark Anthony Agarro <markanthonyagarro@gmail.com>
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
Link: https://patch.msgid.link/20261005203846.239445-1-lucid_duck@justthetip.ca
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7921/main.c    | 17 +++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt792x.h     |  1 +
 2 files changed, 18 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/main.c b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
index 1f3cc7447a85d..534037e9a5e42 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -859,6 +859,12 @@ int mt7921_mac_sta_event(struct mt76_dev *mdev, struct ieee80211_vif *vif,
 	if (sta->aid > MT7921_MAX_AID)
 		return -ENOENT;
 
+	if (mvif->roc_join_held && !sta->tdls &&
+	    (ev == MT76_STA_EVENT_AUTHORIZE || ev == MT76_STA_EVENT_DISASSOC)) {
+		mvif->roc_join_held = false;
+		mt7921_abort_roc(mvif->phy, mvif);
+	}
+
 	if (ev != MT76_STA_EVENT_ASSOC)
 	    return 0;
 
@@ -900,6 +906,7 @@ void mt7921_mac_sta_remove(struct mt76_dev *mdev, struct ieee80211_vif *vif,
 		struct mt792x_vif *mvif = (struct mt792x_vif *)vif->drv_priv;
 
 		mvif->wep_sta = NULL;
+		mvif->roc_join_held = false;
 		ewma_rssi_init(&mvif->bss_conf.rssi);
 		if (!sta->tdls)
 			mt76_connac_mcu_uni_add_bss(&dev->mphy, vif,
@@ -1434,6 +1441,16 @@ static void mt7921_mgd_complete_tx(struct ieee80211_hw *hw,
 {
 	struct mt792x_vif *mvif = (struct mt792x_vif *)vif->drv_priv;
 
+	/* Keep the join ROC until the station is authorized, so that it
+	 * covers the 4-way handshake. mt7921_mac_sta_event() releases it.
+	 */
+	if (vif->type == NL80211_IFTYPE_STATION && info->success &&
+	    (info->subtype == IEEE80211_STYPE_ASSOC_REQ ||
+	     info->subtype == IEEE80211_STYPE_REASSOC_REQ)) {
+		mvif->roc_join_held = true;
+		return;
+	}
+
 	mt7921_abort_roc(mvif->phy, mvif);
 }
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt792x.h b/drivers/net/wireless/mediatek/mt76/mt792x.h
index 082285be95926..a13f2fde48063 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x.h
+++ b/drivers/net/wireless/mediatek/mt76/mt792x.h
@@ -141,6 +141,7 @@ struct mt792x_vif {
 	struct mt792x_sta *wep_sta;
 
 	struct mt792x_phy *phy;
+	bool roc_join_held; /* join ROC kept until the STA is authorized */
 	u16 valid_links;
 	u8 deflink_id;
 	enum mt792x_mlo_pm_state mlo_pm_state;
-- 
2.53.0



