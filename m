Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063229;
	b=ZfdfWuie8USW2M1fgZ2CFC8jjZSzG9aE5FWufNDLOaRTTDz4fh7joYSSzswb+rAgJKav
	 8kxqgZcp0kRnPXetP4ANeH893leNpr2oGE41mlBjdP8T1mUGlSnvN/D7xpAChLTfFJot1
	 UwJqqjZV3OoGKpTHDaIfP3myoyZJl4EPqpppCrJj2DEU4liQJYJZwZ9Ko33j+LRsQSRvi
	 sFV0kS2ew9oCfS/CFLYL2ik2Dpo991FU0Xoo8X5dWtD5fgvwWBYC9xpCGj70u6XyihOQl
	 IkhrqKZfNzNsQhTdcYUawzY+3gtpAeDByswq0BCtCWHZ2q9tKXKEQSn2Yr9OonESNOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063229;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=13yIvythiW8cicRJQ0mSCBWAuCV6wckCJ0vxo9lJ8xM=;
	b=YEW5fG/Z5bVhc7jU8GcQKMzUCOhM2IFR8qGjh1dVok2kjXgZ8WSx8pHlZjoOac59dwbX
	 6AmuXx869H5MiGGnlhzGaGculoR6Ms9D2Ed0jxYW/pa/PKfy3oqfqcbVJA97fKJ6QmOH8
	 fpXbC+bo01zKrrhlPGrUqr+TmiZwHKX7zcL06KIc8ddFCeUrMRTrRKJLnnHAUi36xwr5X
	 6XWZ3fTep3XJ3HIs98d0B1GNoJVXNTeXmnHP7Qp/Ce4eZLRx88bTX7fSoMCjCzhk9+5sY
	 NoEWwpRAHjOh8VRMzeMm54Lk180j52qBZpSv9JsmJZXKhWPjD/0mLwlgtUweBpBmaGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vV25hUXN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC8A5606D818;
	Sat,  7 Nov 2026 14:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vV25hUXN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C9801F0089F;
	Sat,  7 Nov 2026 14:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063228;
	bh=13yIvythiW8cicRJQ0mSCBWAuCV6wckCJ0vxo9lJ8xM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vV25hUXNRnoaZaNXDhgjSO/gLwhjppT5epoqXJAKTOiMBTN1kPQ4RFq8QcVfDjkXZ
	 W7uGeS+z/552y+KDsYPK6wNKoYKs91a9MJZXWHGEXoDHQUuzM9LtlL8C9+hkaQnFSY
	 e9BFlg7j4VWQM4yqXdW1xeN0N5NUe7dapGwuxVSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Orly Orge <orlyorge2004@gmail.com>,
	Inanix <contact@inanix.fr>,
	Mark Anthony Agarro <markanthonyagarro@gmail.com>,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 398/869] wifi: mt76: mt7615: do not tear down BSS/STA state for monitor vifs
Date: Sat,  7 Nov 2026 08:51:20 -0500
Message-ID: <20261107134906.898154201@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

[ Upstream commit f7517b3d8b7f1008e07edcb8bb692c6ca53ef23b ]

Tearing down a monitor interface oopses:

  BUG: kernel NULL pointer dereference, address: 0000000000000000
  RIP: 0010:mt76_connac_mcu_uni_add_bss+0x144/0x370 [mt76_connac_lib]
  Call Trace:
   mt7615_remove_interface+0x6a/0x200 [mt7615_common]
   drv_remove_interface+0x60/0x140 [mac80211]
   ieee80211_del_virtual_monitor+0x8f/0xc0 [mac80211]
   ieee80211_do_open+0x550/0x7d0 [mac80211]
   ieee80211_open+0xaa/0xb0 [mac80211]
   __dev_open+0x11b/0x280

mt7615_remove_interface() tears down BSS and STA state for every vif type.
On MT7663 with offload firmware that reaches mt76_connac_mcu_uni_add_bss(),
which has no monitor case in its iftype switch. It takes WARN_ON(1), then
copies ETH_ALEN from vif->bss_conf.bssid, which is NULL for a monitor vif.

mt76_connac_mcu_bss_basic_tlv() in the same file handles this. It has an
NL80211_IFTYPE_MONITOR case and it copies phy->macaddr in place of the
bssid. The uni variant has neither.

There is nothing to tear down. mt7615_add_interface() only calls
mt7615_mcu_add_dev_info(). The BSS and STA state comes from beacon enable
in mt7615_bss_info_changed(), from mt7615_set_key() and from
mt7615_mac_sta_add(), so a monitor vif never has any.

Reported on mt7615e going from monitor back to managed, and on mt7663u on
an "ip link set down", both through ieee80211_del_virtual_monitor().

Fixes: d9852ab2f362 ("mt76: mt7615: keep mcu_add_bss_info enabled till interface removal")
Cc: stable@vger.kernel.org
Reported-by: Orly Orge <orlyorge2004@gmail.com>
Closes: https://lore.kernel.org/linux-wireless/CANj5C4mTOHs6riyWee=dFdkE5p=714J8xs-x3hq3ewQ+r6O_Nw@mail.gmail.com/
Reported-by: Inanix <contact@inanix.fr>
Closes: https://github.com/morrownr/mt76/issues/79
Tested-by: Inanix <contact@inanix.fr>
Signed-off-by: Mark Anthony Agarro <markanthonyagarro@gmail.com>
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
Link: https://patch.msgid.link/20260813152059.15747-1-lucid_duck@justthetip.ca
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/main.c b/drivers/net/wireless/mediatek/mt76/mt7615/main.c
index 25936fb309fbd..a6667e3a66d0b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/main.c
@@ -254,8 +254,10 @@ static void mt7615_remove_interface(struct ieee80211_hw *hw,
 
 	mt7615_mutex_acquire(dev);
 
-	mt7615_mcu_add_bss_info(phy, vif, NULL, false);
-	mt7615_mcu_sta_add(phy, vif, NULL, false);
+	if (vif->type != NL80211_IFTYPE_MONITOR) {
+		mt7615_mcu_add_bss_info(phy, vif, NULL, false);
+		mt7615_mcu_sta_add(phy, vif, NULL, false);
+	}
 
 	mt76_testmode_reset(phy->mt76, true);
 	if (vif == phy->monitor_vif)
-- 
2.53.0



