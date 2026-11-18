Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025857;
	b=MLINJ0Z/zYAyhUi1jm76JmqCv7uuLJcKje6ZSFVkjZXQim4kBZhRfdth8zzhQX3+9fLk
	 U4R9CjCaX6AbDjJ64G+lFrHmkiLwU1zxn7nQXpZEBsG+GJ3N/4/+922Nv0rIfOrZ9Aa1o
	 iYanPXr4GaFbvAvUjRlNdZGYEESf4sqZcwfT05/0VkTh/bAPNiroytIil+zRvb8hGysFD
	 S96Y26BgHq028kI2j2RXGA2Fdfm2Lu0erfdb+1jlBwLt/s5Gw+yh+BtAgGmOcKwdUz67r
	 V8KjmSKgO88DkRtkFd7sAzEt9ptvtgAWWPIwb1NjVLBwmAa0x/75t3v7SorXVDm4kZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025857;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ghNe0QLqMc3mvfouSTKYXrqNJQKGU39DN3yuZiPSZwg=;
	b=Q8+W4khM3mW/yZfGLWAQ1aCm7EraFq+TrKD2DmRvNEiOnvDAR+7j+4PazMlo1QswhHn3
	 +hZg2Ol4uq9HGNmGh/8SFb6SxKkXYXnvsh3obL5tWg2kSEGQ1AVmz/Xa6YuC0HhkObpu/
	 /e5uGUyHcma9gaP+WNKaMqaTJxluOjcADAHUgvbtYbrpwDK8w0LqrTUebN0Nn+g5lZZqG
	 mq49yoKkevnKCChV31D3FIbIsPVpdY6eqJGlUpp+k3Lve/i0oXfOlu9ao3QX+86+60PKG
	 8rEY/ugNu4OdfKkvVYjk6Ja1oe4pCgueNFzvKW4v4R+L81Qk30q4SXUnsQyyNF7GTbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="VHF+3fW/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6CE4606A31C;
	Wed, 18 Nov 2026 18:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VHF+3fW/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E506F1F000C5;
	Wed, 18 Nov 2026 18:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025857;
	bh=ghNe0QLqMc3mvfouSTKYXrqNJQKGU39DN3yuZiPSZwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VHF+3fW/+2jXftC76P3MtQu6N0BX7vIL2rcdJMini2XFh9C5MbFUb4ebYbE0k/nN4
	 Cuv1m9RI499SP6B81QBcX1ZYyPDLFPZGwulsvIN3JAVMUUp3xONCn3qfAQRyJaFkHB
	 YEjBZongfEyZqMD0r8oct8k/hnIK4F5m0JBFtKeE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1227/2151] wifi: mt76: mt7996: set sniffer mode on a radio that is already running
Date: Wed, 18 Nov 2026 15:49:22 +0100
Message-ID: <20261118150206.883806352@linuxfoundation.org>
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
index 48f22df0cd714..f4ef047a60611 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -504,13 +504,14 @@ static int mt7996_add_interface(struct ieee80211_hw *hw,
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



