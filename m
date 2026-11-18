Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019082;
	b=2z7dUgnniXFqj2mZ83oqZmCdIIlvMxekh9FHIHeTW8HLokQFMc+Fr4FvAzwzM0NSFZCd
	 hHWOm7SxbAZjLR7bI7YnKune833N8JeUEyGG5AWkCnfDnXK/kQSzSr0xC6/XZPeH8Nryp
	 eE78i2H6LEph4W66JUmWa6COF+7kZqCAvK/KKWqZlkSqVYdq/qHz/QeyV932rr22CcozB
	 jH9qh0EGt+v7Ktk2WV8aeG0JvUP+5Xx0coDdj5B6IMS47zcssy9XIHi35wfssWmlJMiuc
	 GvXPMiGgWtvzi6NGy4TUJpG1PGsUSTLt/7zKjgmG4jxwX8oKDil0e5Xr8vSgW/P52PA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019082;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fB9P+z/yJovRysm5ZqZjqfCznXQ77xyLzgN6Btlb6j8=;
	b=dXyLUkNQ4IrgS65Y3E+/Bm/PtaPzDUMgZQB5TmKHmJH8v2as6bqBpD4wNvGqgsLISbFs
	 5SbDeEmojdTVECvTzcc2arMdoOPI0qEsdffg4DzQjc805LCvLSliNzI0mcT3U70QNaSyG
	 V8hoN4zoRUFDoNHFKq9VhHh4kanwo/nGs7XGwPgFYLdY3E6n2Sd9Y1MAVOKkQTKwPXrle
	 RR/LKdFqDNv0V4c/Q7QpfDmx+6kBVLOgX4u0Lc39jQD3fD8NjnLLH+fc8ABAIKbjJG5OF
	 X0aKfxbm/GDAxS3U/Joxa/VAXPR/8CENfzCvuW/dUzQ+5gcAxRVc2NMXgfszWp3/IYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oB+7cVfR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E353606A320;
	Wed, 18 Nov 2026 16:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oB+7cVfR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB9011F000C4;
	Wed, 18 Nov 2026 16:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019082;
	bh=fB9P+z/yJovRysm5ZqZjqfCznXQ77xyLzgN6Btlb6j8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oB+7cVfRdGoqog0nKm0Kj03kszuK+G1mS/NyaX84zMKsMmVKiyfquBIgSgbG3hMRy
	 lxts9IELBPox9HM3SA0O2SHw9PoxY7c8MusdttgMRNGXcN6KtEgY+QITmKcsF35fer
	 X0yyU9eJttx3t3vxJFi+BA3l+GUDIPuUVpS0mKWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1468/2651] wifi: mt76: mt7996: set sniffer mode on a radio that is already running
Date: Wed, 18 Nov 2026 15:45:08 +0100
Message-ID: <20261118150340.883703024@linuxfoundation.org>
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

[ Upstream commit 78072c1a661d643f341536219c19c28ba0a0fed3 ]

mt7996_add_interface() skips a radio that has MT76_STATE_RUNNING set,
and the skip covers both the start of the radio and the call to
mt7996_set_monitor(). mt7996_init_wiphy_band() sets
MT_WF_RFCR_DROP_OTHER_UC in phy->rxfilter on every band, and
mt7996_configure_filter() does not clear it, so only
mt7996_set_monitor() does. A monitor interface that is added while an
AP runs on the same radio thus receives no unicast frame addressed to
another device.

Start only an idle radio, but put every radio of a monitor interface
into sniffer mode. mt7996_remove_interface() already clears sniffer
mode whether the radio runs or not.

Fixes: 69d54ce7491d ("wifi: mt76: mt7996: switch to single multi-radio wiphy")
Link: https://patch.msgid.link/20261006205936.669125-3-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/main.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index 7289d2633a5d2..2343db54fb546 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -570,13 +570,14 @@ static int mt7996_add_interface(struct ieee80211_hw *hw,
 	for (i = 0; i < MT7996_MAX_RADIOS; i++) {
 		struct mt7996_phy *phy = dev->radio_phy[i];
 
-		if (!phy || !(wdev->radio_mask & BIT(i)) ||
-		    test_bit(MT76_STATE_RUNNING, &phy->mt76->state))
+		if (!phy || !(wdev->radio_mask & BIT(i)))
 			continue;
 
-		err = mt7996_run(phy);
-		if (err)
-			goto out;
+		if (!test_bit(MT76_STATE_RUNNING, &phy->mt76->state)) {
+			err = mt7996_run(phy);
+			if (err)
+				goto out;
+		}
 
 		if (vif->type == NL80211_IFTYPE_MONITOR)
 			mt7996_set_monitor(phy, true);
-- 
2.53.0



