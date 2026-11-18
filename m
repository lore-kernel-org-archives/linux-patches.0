Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031168;
	b=NVr0YwH7XOi4Ivz+zdCl3Pvy+m1Vz3p5wyADs1fyOlAnFd6GLT75IZncG7aH5pI0NFkP
	 a21biQmIjj07o28s9Xs/FFblFHk5W7WbSROI+Bk07GIWIMc1jXFnBTem3iKHoA2o2zE90
	 OXF3wGbFFQPZcyo8WpkTfMPnTn7Pks7D+h7fkkABk4Ng+oHETrnHirSMSHQk5doLjs6mH
	 NKdO9DqUAG9CnzF8MHQyo3DZH/+6Td46GsNDM0zZ6mQcALE9VEeP2zsynGvpgU4x1hhY8
	 ElrGzrPMFXhFouRz0/SwPExaBn5yq5gdqdSbCV+9JXx4BkT9Xs7zfJBJoFgQNe4B4dg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031168;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7HItYmpH/sHSYc8XJcXAJ0ldRRiRsuPS3G8remUYqjU=;
	b=U1q1hGP5HMA3CFAKxPdpHC0AO8LNgNkOh+BDxmunb1lOFFr6wEF3eF2L7xyNq3tGwaog
	 UZXBqshTwHoBvy/NFOdyEH98jyaoUColkH1gWKU56B2wGSxod1NQnW/AxSGoJvYEMQ6Z2
	 MZAWqN6DZtvo1bujQRasCggfSDGjjuZBPLWCw572LHOCYA3UvhDARMUhzOPTNAijFH2wP
	 0704CquaKS/dAPkWCl7vIRuN7k/GkZAHBDYemSacrhHMM9j6epEXFk2U7Mb+EE8mscsA1
	 etafWr4q2k+hKMiBkoEf0AlqugboNrA3w1LemZkIJ7NrhB9fiQdKl22J+u/BzlW1UAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wemsbt1J;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54B71606A31C;
	Wed, 18 Nov 2026 19:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wemsbt1J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B13E1F000C6;
	Wed, 18 Nov 2026 19:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031168;
	bh=7HItYmpH/sHSYc8XJcXAJ0ldRRiRsuPS3G8remUYqjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wemsbt1JKDZMcXU94sbzvSIbvfjT01fWDNjnMx7Ud1EHBe1DAWSP5PgdNINrLDylH
	 KW8HlIlQ4nThkV2b/8xpt467geVEfsAdeGg4lkXPJuxc2jFqwq6fOcLVjoUh6N6Zrb
	 gDUFrrfnsqdC6t6VE9Oeu/U+y/JRxgqXadazXZmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Leung <untilscour@protonmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0961/1756] wifi: mt76: mt7915: publish wcid before MCU add commands
Date: Wed, 18 Nov 2026 15:51:28 +0100
Message-ID: <20261118150048.343056462@linuxfoundation.org>
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
index 0e3ca0eb9f082..67b9f48100a20 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
@@ -275,9 +275,9 @@ static int mt7915_add_interface(struct ieee80211_hw *hw,
 	mt7915_init_bitrate_mask(vif);
 	memset(&mvif->cap, -1, sizeof(mvif->cap));
 
+	rcu_assign_pointer(dev->mt76.wcid[idx], &mvif->sta.wcid);
 	mt7915_mcu_add_bss_info(phy, vif, true);
 	mt7915_mcu_add_sta(dev, vif, NULL, CONN_STATE_PORT_SECURE, true);
-	rcu_assign_pointer(dev->mt76.wcid[idx], &mvif->sta.wcid);
 
 	mutex_unlock(&dev->mt76.mutex);
 
-- 
2.53.0



