Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019124;
	b=rxZ46Zlmkc2uwLOk3Y1F/pIVP79rzQLrdpdebFfCjlRRUbzzb0BdIFXc0Jqeik7DoQmO
	 3O86hWga9ZJ3DjOdky8LtV9TG1G04KtDMhdx0JY+ir9m4RswhA7Fyb/ljqhZ/vqpWThFe
	 o7flPcSkEil9QxWArsBUnsLwS3x/F0DNTTKsoGE6b0kX+TEbOvL/LmQUZkCA1v1MVnfiV
	 exHsB5Kz6DME3t8nLf43ojb/LBhVfM0pLrR5sHi5SF1WQq8WQ43suzZ1GyVASr1YqlbM0
	 UxXEIPyQxb2qKr5b9Vul+ZdL+NTF5naJp4frMTT627w+ovCG0fwBIvvnE3u3ZFjXrsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019124;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ch+hJYj2jodUNByybdNREMaDmsFvPyhTa1rIMULjNU4=;
	b=21Jq9Fz1DHnTBTxW5mJqrs+qkzTDM0vtu1ecNgPNizOBP7J7Lr9JpkFGF+QNaU9uf7KJ
	 btwS8hnNYUHhnPTuc8UrTAn248IU8FtLDUHqeCLETRcs0htK3bCxjZCUYhfLyikZUum5/
	 kUhbfkA2LUMb8X9av5QF+WACesPZX+fXjkqxEorz6dgGWsw/Gy4o6akXxg21Rrzr+kQO5
	 gsB6QPDjxBgdypvn2vVCj2Mh9z5liehjROaKCwrNl8ZkKMsqmUgJG615xcqGW+q9RIOFg
	 2tGckAcav4/nUSvd4/4xEOcur9ywgni6b7YX2R/FfFH+DGgZzKEW6djU1uZec/vF2OQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vibs6LXc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7F36606A31C;
	Wed, 18 Nov 2026 16:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vibs6LXc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB6701F000C4;
	Wed, 18 Nov 2026 16:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019124;
	bh=Ch+hJYj2jodUNByybdNREMaDmsFvPyhTa1rIMULjNU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vibs6LXcHMS+qZtvAkGKvQQr/uywJ7PK6eh6oNh46j/rH8XyOGConhteiKBNKdcC1
	 s7r7OiilLnJ5H7uXigZ1+SRape8hq+F3LthWSzJNURlvpWRfUWGhQBUxkguo7ujqHD
	 B+8kSQrY9+uNl4BXdIgu4vdMpbTdMkJvzU6F2gcU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Leung <untilscour@protonmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1442/2651] wifi: mt76: mt7915: publish wcid before MCU add commands
Date: Wed, 18 Nov 2026 15:44:42 +0100
Message-ID: <20261118150339.958515451@linuxfoundation.org>
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
index a03d89aabe809..556f8948abac2 100644
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



