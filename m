Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062228;
	b=G6ndgw2U9+XWmtR0zQ3i4J+6y3sx+XlX0MUbPr8s0b9XsEKZI65kX1Ywk9ZJ15cqBXmh
	 uV9R4KZhb6DDcsO8HCaGetUtGEdwsX0jaQLcWYv+NoSnu0w3+XbWA8P4HYJQcyb51knxx
	 eR5wTklKRkzQCZQ1ea99W52xraF4TXyiR9o/bHaUxjl4uWIhgSEgo9FKuMRrRmAA4E/Np
	 Qe+yikUAtkvhBnrOAHRXsb6zYsNpBatWkvfF+oXZaaBQIrhVgbEaO4qY27GnyAjNXZbX0
	 Bxlznl4GcxhmJZyqVT5uFW86/D0wfllvH4uxHalKfMgVwMBBHAqzq0LOw7vQU1ksBnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062228;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gWLVd4uaymVPlgqX5/IYO7FdB2ps1Vf6/is5idiWUVU=;
	b=W20PgPleO+j5wk/ED69pMfbpdTWTTecXLAoi8XNhFHWRrARrTlWgVNMc0fi4Tc30H424
	 YKy/r9/Hn7UVdRRE4imDeEyHkQnwJ88Ma6PO2BlNQ+H5+d2KJ+rw0o/gp8dpQJQXJCwtk
	 8Yhsm8JklMZNipz5yQTFJiusnBI/lIEEEeYIXy4qBjCXOpa4RMQC8yxWv4L4+POQN4c+o
	 L6Si4qN+r+DhVorn2irY/92nJ2qxsraRQtNQ7IqcFnfH+0RVeuPPPuaCH2FYzgbet5niC
	 TzZEvi0MNn0wVHIubIGTlSOYrBka4bW8Q0HvVnGtk9VD7M+HZSOqSa6H0LnDnUzm13g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="PZi/or/P";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3E7A606D83C;
	Sat,  7 Nov 2026 14:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PZi/or/P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72C591F008A3;
	Sat,  7 Nov 2026 14:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062227;
	bh=gWLVd4uaymVPlgqX5/IYO7FdB2ps1Vf6/is5idiWUVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PZi/or/Pk7erp1VmckmaP7/ku31X1ET39EwsNr45t3e88hcypZeV1Q241PMRRtoBf
	 m3z/H6kABaQYlA5ZKWhgNF3hY/B3+am3QbRDTMbDcPz9CbyCmMJB9jFYx4b8dT7KLT
	 kHbQjFvijAZoUQKn3LCn8wFpWJYXFXiOoYgMUAWo=
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
Subject: [PATCH 6.12 1179/1536] wifi: mt76: mt7615: do not tear down BSS/STA state for monitor vifs
Date: Sat,  7 Nov 2026 08:53:15 -0500
Message-ID: <20261107135030.855006497@linuxfoundation.org>
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
index 27897d2d14966..c652a2bbb1bd5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/main.c
@@ -255,8 +255,10 @@ static void mt7615_remove_interface(struct ieee80211_hw *hw,
 
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



