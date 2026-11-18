Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025815;
	b=K/f8H3K0gUbFJJKe05Yc41Yfxb+PccUPI2YLsS20iKS2PmQt2gyVEIUtCMhNX1JFwQsE
	 hiasnkvQiiP9asbPpKih/wQP3EbEKkEEHKxCVv4Laoxn1d4VQh+pcFtFtBat03cOlGxfy
	 YGCOaddIovnsmoDK+RqPt9diUNxzZ1tnaFXlUWZVCqrg7fieg5ccwKlNRxeVFpIy7yg/Y
	 0IV2nklAVRzBoqnJnxWuIr3fYiP27bBoUfJd2slNg8as1odEEGki5b679nzqK+4sGis4l
	 +YE1XlsPD9y5ErdQTYiQyMvYRSI+9C62gPLLif+XVaMmbg01N7wgOOhoaGLkONyc9gA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025815;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UQifX8yyhLNyxk15Y8fbsqTw95DZujcfBBMvEECusdc=;
	b=sGY0CAo1iccSoOxdGxeySAPQWH7BvETh5NvV+VHoTIlPYoUbz1sL4YEY4MG3USFbYJjt
	 PpubKrUwDBXQ0zH6ftxziK19jTnOVuyBPJYAk3LI/3RXQOjnq4uhQvvq+EvNCcVPZuEF0
	 t3IzRH2WmUs+TZMd8AleV9Usblc8hSzM2ndf2Q7W1sNr0rozzOw8OY9YyUIle/+XCnpNc
	 LSBcrRx8YBB7rk65LhSildz3ASx/Pt7X4H0DHsoaESpZsgjLMST1BL0TIlH1CmczGz3wS
	 OfCcGr4xlh9wJeQxoQhDuhBlSAtNCaBAG0DNOVZ7EbLLROy+PwDD8tQY0+GhIBfKoAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UBftnoXM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85E6D606A33B;
	Wed, 18 Nov 2026 18:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UBftnoXM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D75A11F000C4;
	Wed, 18 Nov 2026 18:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025815;
	bh=UQifX8yyhLNyxk15Y8fbsqTw95DZujcfBBMvEECusdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UBftnoXM/ttZOMi4aPtZP7TDew4iFy7NAv8I4cHhI/SQRY1t8YXXuKvmZbliwi1Q2
	 Z5Q7wke2EKy2VRTSqE6EkQFMsiWBdpi4ielz05/pTMaoBFWu3fbsdLW1dcnzQMu7O5
	 X03eSiLuKjjUm0ZsJZ/uaAoKIiAdqTvSMrLcCsyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Junker <fubar-coder@live.de>,
	Mark Anthony Agarro <markanthonyagarro@gmail.com>,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1214/2151] wifi: mt76: mt7925: keep the join ROC until the station is authorized
Date: Wed, 18 Nov 2026 15:49:09 +0100
Message-ID: <20261118150206.424355124@linuxfoundation.org>
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

[ Upstream commit ac22c8c723c62013dd45b74e32249fc877c86fe0 ]

When a non-MLO station associates, mgd_complete_tx() aborts the join ROC
as soon as the association succeeds, which is right before the supplicant
sends message 2 of the 4-way handshake. With the abort that close to
message 2, the adapter acknowledges nothing the AP sends for the next
several ms: the AP sends message 3 and its seven retries within about
5 ms, none is acknowledged, and the handshake ends with reason 15
(4WAY_HANDSHAKE_TIMEOUT).

Keep the ROC after a successful (re)association on a non-MLD station
interface and release it when the station is authorized, on
disassociation, or when the station is removed. The ROC timer still ends
it if none of that happens. MLD interfaces keep the old behaviour: there
the ROC that is active at this point is the MLO ROC set up by
mt7925_mac_set_links(), and holding it makes mt7925_set_mlo_roc() fail
with -EBUSY in the link activation work, which leaves one link instead of
two.

Tested by a reporter on an MT7925U (USB) against a FRITZ!Box 5690 Pro on
a 6 GHz-only, non-MLO SSID, kernel 7.2.3, from traces and monitor
captures taken in separate runs:

                       handshakes   first M3 acked   abort before M2
  unpatched               8 of 84         0 of 83           84 of 84
  this patch             30 of 30        31 of 31            0 of 30

With the patch the AP sends message 3 once and the adapter acknowledges
it straight away; the ROC is released right after the station is
authorized. A 20 ms delay after the abort instead of this change gave
15 of 15, which points at the abort timing and not at the delay.

Tested here on an MT7925 and an MT7927 (PCIe), kernel 7.3.0-rc4: on a
non-MLO SSID neither build showed the failure (1 stalled handshake in 110
unpatched, none patched), so no effect could be measured there. On an MLO
connection the change is inert: 16 of 16 link activations succeeded in
two rounds per build, with two active links and the same ROC order as
before.

Not tested: other APs, other USB parts, MT7927 over USB, MLO connections
beyond the check above.

Fixes: c948b5da6bbe ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for mt7925 chips")
Reported-by: Mark Junker <fubar-coder@live.de>
Closes: https://github.com/morrownr/mt76/issues/106
Tested-by: Mark Junker <fubar-coder@live.de>
Signed-off-by: Mark Anthony Agarro <markanthonyagarro@gmail.com>
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
Link: https://patch.msgid.link/20261006031425.20922-1-lucid_duck@justthetip.ca
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7925/main.c  | 21 +++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/main.c b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
index aab70b030c747..d84d7180fe608 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -1084,6 +1084,13 @@ int mt7925_mac_sta_event(struct mt76_dev *mdev, struct ieee80211_vif *vif,
 			 struct ieee80211_sta *sta, enum mt76_sta_event ev)
 {
 	struct ieee80211_link_sta *link_sta = &sta->deflink;
+	struct mt792x_vif *mvif = (struct mt792x_vif *)vif->drv_priv;
+
+	if (mvif->roc_join_held && !sta->tdls &&
+	    (ev == MT76_STA_EVENT_AUTHORIZE || ev == MT76_STA_EVENT_DISASSOC)) {
+		mvif->roc_join_held = false;
+		mt7925_abort_roc(mvif->phy, &mvif->bss_conf);
+	}
 
 	if (ev != MT76_STA_EVENT_ASSOC)
 		return 0;
@@ -1235,6 +1242,7 @@ void mt7925_mac_sta_remove(struct mt76_dev *mdev, struct ieee80211_vif *vif,
 
 	if (vif->type == NL80211_IFTYPE_STATION) {
 		mvif->wep_sta = NULL;
+		mvif->roc_join_held = false;
 		ewma_rssi_init(&mvif->bss_conf.rssi);
 	}
 
@@ -1890,6 +1898,19 @@ static void mt7925_mgd_complete_tx(struct ieee80211_hw *hw,
 {
 	struct mt792x_vif *mvif = (struct mt792x_vif *)vif->drv_priv;
 
+	/* Keep the join ROC until the station is authorized, so that it
+	 * covers the 4-way handshake. mt7925_mac_sta_event() releases it.
+	 * On MLD, the active ROC is the MLO ROC, which must be released
+	 * before the link activation work sets its own.
+	 */
+	if (vif->type == NL80211_IFTYPE_STATION && !ieee80211_vif_is_mld(vif) &&
+	    info->success &&
+	    (info->subtype == IEEE80211_STYPE_ASSOC_REQ ||
+	     info->subtype == IEEE80211_STYPE_REASSOC_REQ)) {
+		mvif->roc_join_held = true;
+		return;
+	}
+
 	mt7925_abort_roc(mvif->phy, &mvif->bss_conf);
 }
 
-- 
2.53.0



