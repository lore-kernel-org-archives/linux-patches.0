Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052505;
	b=JabN7JZbftpVPlhERzftO+PexGA9+CmCeiYKI+NUTJFv0a0leAwYT3UJyXV4iBLjyQyo
	 ivXPyuo/+zhIYWIEQRtBQ2VUYx9d+2BD8+nzuljUJ9H8jVxuFHBMEGzbemy2oT8XmRmLU
	 UXJVl8XwsoIx0Z6GipnlmVPMvfLd8cvHZTv9BRThuavLSXEQKkY5WjdKVLaJR1QFTrnIB
	 uWUiDAPOOtxO86JxMLpMcspB7MsTPeK5d6HoRsgPwJYg4qXswY0NQpABZnlaQqVuirQQK
	 uGGxWUMgEndKSMXGs3iEAv/tY4MKo15CS1Z+bs04UpSF6FrawleNc39pb/znNe3BH1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052505;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bMeijNnPyUz+pmYU7KxhlPY34hWEu2tFXxzOd1Hcc+w=;
	b=4aLTZNT1ed6zznhxRGS+re8VHDi0PodyA5UQ9QkbgUHExqu7REwVWiiNGLFYklwfHTwx
	 r+wtQcIQ0S3sjF29yWXZnhsrZ54t+IgAFKjk5FPcEIHBGAD3ukUWZI3deow1H2AWLNEN7
	 Qr53nHPiupaNeMWv622KDJR3ZI6hZ15FLm+ZAqGI4R6T3nJtCpM57qMqDbbj4YHoAQzFH
	 Cp49mnbWmTO5Pij3gP0Z8mTPQ6ZEwqVTEQfM2P7RbIsSYlZW9TFAC1XxXv/R8Dza2jc+v
	 AvfoQVlMsAuQ1b3pD9n7+WRdiBVde+yMJxsWIRBQOtuySUaFmHBmneZJGUAqu6cxhSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ujcko2lp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50ADE606A333;
	Thu, 19 Nov 2026 01:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ujcko2lp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A78CF1F000C7;
	Thu, 19 Nov 2026 01:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052505;
	bh=bMeijNnPyUz+pmYU7KxhlPY34hWEu2tFXxzOd1Hcc+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ujcko2lpTXklOXAhNiZZne1/RC0fKlYgoz4wUSoPyXvF6cadDqT3Eu6wIOWDCnzw+
	 ETQdZGELgKj1YAiFm71sEbv5CyLtdPKat2jzav+FTN5ROLT3TxECZiuZTuUdWr90so
	 egHDfBdH7+zw4uSCd2PmfrvpfFHqbLZZaxzP10zU=
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
Subject: [PATCH 5.15 0589/2214] wifi: mt76: mt7615: do not tear down BSS/STA state for monitor vifs
Date: Wed, 18 Nov 2026 15:37:45 +0100
Message-ID: <20261118150034.467281743@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index e81314a23ac54..91bc876ae494d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/main.c
@@ -256,8 +256,10 @@ static void mt7615_remove_interface(struct ieee80211_hw *hw,
 
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



