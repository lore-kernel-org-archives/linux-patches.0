Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215142;
	b=CuLQlS7KcmQtpYRXrtXdErdGi5NjFjRcye8HtaSETcq98mEABS8T+HTJHK12ckvjUyzf
	 ejxEEBkM9VyiAAvuYj2C5eUbJVfbrOYC9OwU6VPBhsFWyriNyNpVFFtziWwEckYj8IVJy
	 S/neB3cF/rxAWOFOc0W4z1vFq1yATgeng2BXVV12HLvqVkFspbvkipLB/jVmADmRJtn/p
	 /noz+Z5Wf2PPuQjWvrgfEicya+9Kumwq6kA6KwgcEbtIeyNGvLcJ7aqZseDTHtsxcIDd4
	 u/6xhM6EHHKCkljvC8kKpE/7Z0oq84kkE6mllTYTqIxh+2xV3pLlZGAiBS4hXtNYMNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215142;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UA4Y1iXdygKn085a4+ItUejfSlOIl2l0MB2IlXhwUOQ=;
	b=J4H3Q5+bPxVcTt8T30qrAOoz9dmkB41LzO8VDOSdQ6I8B7UjiKk405PRqFbW5gom93pm
	 jMDEBExFfyNb5LdGXHYdge9ZzW9BAMHraDtSemCy8QexmFQycIp8fpJxtoNhYcXre/uOW
	 bTZaposeOhMJFbs3uUZfdI8wQpAWLoi0r5yzanDSalhvatyvIcaKvIzPH8WlCwoJIbtlY
	 LqB08FEowI06v4o/OocDTla9IZ+lzFLbSV94eNYKysPNNU+C+n8ct40akRQgLCT254Xan
	 X4WRj2rGDNd3dmZMEkW2e+hNSlLzJRf/0K6XYM0RHfilVRwgMfXI1kqvcu6jULm0Cww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OebQc11i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ACFB606A32E;
	Wed, 28 Oct 2026 19:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OebQc11i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B8671F031E8;
	Wed, 28 Oct 2026 19:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215141;
	bh=UA4Y1iXdygKn085a4+ItUejfSlOIl2l0MB2IlXhwUOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OebQc11ivKD/xWiYtPqyuQXqgPwl/xsaAi8L88IwxG69XCKGg+hrNyyPiPeJo+2a3
	 eMQcoraUKWOi80vWer5eqlEJinhhw3bzX7QlwlCOZXUgusi72B07GYVeXDRnxJ5hWC
	 vJHEj9s6bOcYw5x9XIU53ZqkZgrHKo6R1uL3Agqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rory Little <rory@candelatech.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1107/1887] wifi: mt76: mt7921: Place upper limit on station AID
Date: Wed, 28 Oct 2026 17:53:23 +0100
Message-ID: <20261028170524.595601123@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rory Little <rory@candelatech.com>

[ Upstream commit 4d0bf21e3e20619d51d06c0c36207aabab8b712c ]

Any station configured with an AID over 20 causes a firmware crash.
This situation occurred in our testing using an AP interface on 7922
hardware, with a modified hostapd, sourced from Mediatek's OpenWRT
feeds.

In stock hostapd, station AIDs begin counting at 1, and this
configuration is prevented with an upper limit on associated stations.
However, the modified hostapd began allocation at 65, which caused the
firmware to crash. This fix does not allow these AIDs to work, but will
prevent the firmware crash.

This crash was only seen on IFTYPE_AP interfaces, and the fix does not
appear to have an effect on IFTYPE_STATION behavior.

Fixes: 5c14a5f944b9 ("mt76: mt7921: introduce mt7921e support")
Signed-off-by: Rory Little <rory@candelatech.com>
Link: https://patch.msgid.link/20250904000711.3033860-1-rory@candelatech.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/main.c   | 6 ++++++
 drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h | 2 ++
 2 files changed, 8 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/main.c b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
index 6c59ad33d3205..2283682aec65c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -716,6 +716,9 @@ int mt7921_mac_sta_add(struct mt76_dev *mdev, struct ieee80211_vif *vif,
 	struct mt7921_vif *mvif = (struct mt7921_vif *)vif->drv_priv;
 	int ret, idx;
 
+	if (sta->aid > MT7921_MAX_AID)
+		return -ENOENT;
+
 	idx = mt76_wcid_alloc(dev->mt76.wcid_mask, MT7921_WTBL_STA - 1);
 	if (idx < 0)
 		return -ENOSPC;
@@ -756,6 +759,9 @@ void mt7921_mac_sta_assoc(struct mt76_dev *mdev, struct ieee80211_vif *vif,
 	struct mt7921_sta *msta = (struct mt7921_sta *)sta->drv_priv;
 	struct mt7921_vif *mvif = (struct mt7921_vif *)vif->drv_priv;
 
+	if (sta->aid > MT7921_MAX_AID)
+		return;
+
 	mt7921_mutex_acquire(dev);
 
 	if (vif->type == NL80211_IFTYPE_STATION && !sta->tdls)
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h b/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
index d36b940c0a07a..1e2f914558a2e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
@@ -21,6 +21,8 @@
 #define MT7921_WATCHDOG_TIME		(HZ / 4)
 #define MT7921_RESET_TIMEOUT		(30 * HZ)
 
+#define MT7921_MAX_AID                  20
+
 #define MT7921_TX_RING_SIZE		2048
 #define MT7921_TX_MCU_RING_SIZE		256
 #define MT7921_TX_FWDL_RING_SIZE	128
-- 
2.53.0



