Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031179;
	b=tYeqOpWqzhAp+YElEGkcEZ69zZaZGx1d+2fuANJ0T+VXca/cQnlKAx71RwIZ282Q2XIQ
	 1ny6GGKN8N+hBox1e2vn/VAh4kH4+iySwc45Y4ef5ZNttkeP+JbYaS/7t3/UDkMoNAr37
	 3wpTEJsbUlMO6otfdSq+DzF0ffz7Y88w8bzdZBNpxbgsp4J/2BhjK3npeXhTHG8GP/UKm
	 Kwc/BY/aKZKCNof03x2I2NzDDHpHAU8Mm1Tzr57H7EzJdnG7fL332ie5iDLDpFd4eLH60
	 H0QoFbXCoe1QCZBaSvQydYy3JBlRFJoN/nGKeZTjOvjZT7uEccDdNa86+tCpFcdTY9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031179;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XWlxNDmaQtO6BhRFeiUhB4qeq0OVjNerSDW0cv3rLVs=;
	b=33aAFWNxciz379wL2Acw2uhad1GjedBYBm5uqrGk/9Ja+RAU9JSaakV8IwxN2kEL0mca
	 geIvfdxHfuA6Uuo7bRa+PkAM7fyBR+WZidCrh51R7C8EPrdtUsqIEgLqCQWxlT0qcER1Z
	 1nX9aMfZJYQLd1w2hd7RexQYbXqpg5Wrx+54XxxLbjMHnidiGDBzLxlPowXWusv5McJpL
	 CTgSywxl6YEsZEeBIo0PJXUA9EkDZ8aFIICkvQe8OCjl01oGUGzn8aI6BRY7vV4uvrQ5O
	 pHQj7Oq2d+yQUrjkkWdPHNHzA83j8W8+MULB3VwHVludDZFHxVoX8lsJ08NP8U/GMBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1lrCYGo1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9880D606A31C;
	Wed, 18 Nov 2026 19:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1lrCYGo1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC4081F000C4;
	Wed, 18 Nov 2026 19:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031179;
	bh=XWlxNDmaQtO6BhRFeiUhB4qeq0OVjNerSDW0cv3rLVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1lrCYGo1IrMOszq0Ir8rXqqMIHmsrmr9Rgain1S+SNlFG0pW3Ee3/0/XTlqUn/AC3
	 dPIA0XqF6EWfF9n60qp48q++bGCCJ8Sf+ttcbwdyWpu8ZgFx+Aly5fT6y8eYw3EdQh
	 J3ik820/ERUfuTQ/eNOLzb0bH9k1GrVU5MnpQICo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Anthony Agarro <markanthonyagarro@gmail.com>,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0965/1756] wifi: mt76: mt7921: keep the join ROC until the station is authorized
Date: Wed, 18 Nov 2026 15:51:32 +0100
Message-ID: <20261118150048.568347126@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index 5fda1d848d549..b631df3f6ad52 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -853,6 +853,12 @@ int mt7921_mac_sta_event(struct mt76_dev *mdev, struct ieee80211_vif *vif,
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
 
@@ -894,6 +900,7 @@ void mt7921_mac_sta_remove(struct mt76_dev *mdev, struct ieee80211_vif *vif,
 		struct mt792x_vif *mvif = (struct mt792x_vif *)vif->drv_priv;
 
 		mvif->wep_sta = NULL;
+		mvif->roc_join_held = false;
 		ewma_rssi_init(&mvif->bss_conf.rssi);
 		if (!sta->tdls)
 			mt76_connac_mcu_uni_add_bss(&dev->mphy, vif,
@@ -1417,6 +1424,16 @@ static void mt7921_mgd_complete_tx(struct ieee80211_hw *hw,
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
index 52d2338c16c43..a476ec0f59aac 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x.h
+++ b/drivers/net/wireless/mediatek/mt76/mt792x.h
@@ -131,6 +131,7 @@ struct mt792x_vif {
 	struct mt792x_sta *wep_sta;
 
 	struct mt792x_phy *phy;
+	bool roc_join_held; /* join ROC kept until the STA is authorized */
 	u16 valid_links;
 	u8 deflink_id;
 };
-- 
2.53.0



