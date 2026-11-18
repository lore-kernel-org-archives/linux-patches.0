Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025801;
	b=HkafYrIN2b5OXOrx69QuiZH0O3ybKc63ofUkCJ5rDoZ0ZXHieduMM4F0ZlQHXWlYuV6T
	 irWGhGVUBsogz0kSXZsboqvR2U0IAnn8H39hPl566bsuWvpPgthunZ8Q1QeBy1IYO0Spw
	 jJvelsTrHWFK8q+UtBsQgscytBiujKSaaYHsF7PB9JizgjDmO6PiEwlovyon4BU7nu1/E
	 onhC+YKlbXn7+leLgAdqRaj9wW52DkHMcZUFAebzzKZ1zwbMKXL4GBwuOKYtovw7env05
	 S7Jd1IEqat5cSep3GFjN/bpn3dVsO7WVneVLNSUfpCTCbNTNuq3kpJgZHdQCnjZsCbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025801;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HFIWUWIMt5gfu2hFUzXdYGpybETZpOSUaTPx3F7VEs8=;
	b=Esosub0EKojRKUSfTnh5ctalWfoNJooMsX+toCqgFcMIagTNXe01fX7VhgfpuJGqvxY0
	 R2xnu1xDyoDeuKIuyCy7J7vpdXKIO8w3Nyrtz0QXR0uGHUTPnRkanNl+PNIJOQFNrwMD2
	 jLOMRuiMCW0IDUvvij/HHR1oNaL54MRa29WA/cbRoFRvOheUjnCAv4Gw5QKgI7gAwFkpc
	 Ako+ucqvYw8awgtnAmmPV9BkeCyE0pSxdAFM/+C1SgS60C38bt8QlxH7FYIrvvSzvIewb
	 X6uVq2lfH9NtpcZj82hLycxfr6xUTL8S2aDWqn7vr41evVpPafzVTyhNtjaGzjXwI1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A1smc2+X;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1CD0606A325;
	Wed, 18 Nov 2026 18:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A1smc2+X
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0767B1F000C4;
	Wed, 18 Nov 2026 18:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025801;
	bh=HFIWUWIMt5gfu2hFUzXdYGpybETZpOSUaTPx3F7VEs8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A1smc2+Xl4eTHUyEh6UOvHyDvd/b/sOVP8DiAcker5oaoD5kXFNe42h4It++ZYXA5
	 KCBhEdejLSVjqpDEoIF0daxMvkN4RlZssKy4zI5odkPCwqU035xKLYY+k+T7O08xh+
	 u1EygnWEjfdjzIk3nBhLlfunla9WqjsrJH8LkOYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Leung <untilscour@protonmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1209/2151] wifi: mt76: mt7915: publish wcid before MCU add commands
Date: Wed, 18 Nov 2026 15:49:04 +0100
Message-ID: <20261118150206.245577710@linuxfoundation.org>
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

From: Ryan Leung <untilscour@protonmail.com>

[ Upstream commit a2d1c02c59f84e982179751bced5fb2fd5bb4212 ]

mt7915_add_interface() enables the BSS/STA in firmware via
mt7915_mcu_add_bss_info() and mt7915_mcu_add_sta() before publishing
dev->mt76.wcid[idx] with rcu_assign_pointer(). Firmware can start
generating tx-status/tx-free events referencing that wcid as soon as it
processes those MCU commands, but mt76's rx/tx-free handlers (e.g.
mt7915_mac_tx_free()) look up dev->mt76.wcid[idx] to service them, and
won't find it published yet. This can lead to memory corruption and
kernel crashes shortly after an AP interface is brought up.

This ordering was introduced by commit 8e3e7567b8c1 ("mt76: mt7915: add
sta_rec with EXTRA_INFO_NEW for the first time only"):
mt7915_mcu_add_sta() derived its "newly added" flag from
!rcu_access_pointer(dev->mt76.wcid[idx]), so the publish had to happen
after that call. Commit 33eb14f10290 ("wifi: mt76: mt7915: use mac80211
.sta_state op") later replaced that flag with a caller-supplied `newly`
argument to mt7915_mcu_add_sta(), now simply hardcoded to true, so the
ordering is no longer required.

Move the rcu_assign_pointer() before the MCU add_bss_info/add_sta
calls, so that the wcid is visible to lookups before firmware is told
it's live. This makes the ordering symmetric with
mt7915_remove_interface(), which keeps the pointer published until
after the MCU disable commands have been issued.

Closes: https://github.com/openwrt/openwrt/issues/24594
Fixes: 8e3e7567b8c1 ("mt76: mt7915: add sta_rec with EXTRA_INFO_NEW for the first time only")
Signed-off-by: Ryan Leung <untilscour@protonmail.com>
Link: https://patch.msgid.link/20260821-mt7915-wcid-publish-order-v2-1-acf0b7f32cbd@protonmail.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/main.c b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
index ff14085dc331e..700d9902116b0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
@@ -273,9 +273,9 @@ static int mt7915_add_interface(struct ieee80211_hw *hw,
 	mt7915_init_bitrate_mask(vif);
 	memset(&mvif->cap, -1, sizeof(mvif->cap));
 
+	rcu_assign_pointer(dev->mt76.wcid[idx], &mvif->sta.wcid);
 	mt7915_mcu_add_bss_info(phy, vif, true);
 	mt7915_mcu_add_sta(dev, vif, NULL, CONN_STATE_PORT_SECURE, true);
-	rcu_assign_pointer(dev->mt76.wcid[idx], &mvif->sta.wcid);
 
 	mutex_unlock(&dev->mt76.mutex);
 
-- 
2.53.0



