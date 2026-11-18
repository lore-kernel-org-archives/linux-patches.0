Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034107;
	b=dzydvwQZSrzVkYp3KEKwBH103n6fwK9pEWX2draIVR9+KeN7Pb14lNWWzzzMaNgyqTfa
	 KB72do4za+4Zeq9HF01hpF66DtUJ6nhKe29/1IvGH9kz6zu1ScaMe5UAdz+goZBZZU+zx
	 K3vaZHgKNVZPXqAHoPRtYUvVMvYCYTMmUx0TIDpOrdByoXX3kYyoIgzJRHcnP+wpJ6FNh
	 L2KUkM9+ancekK6TdMnjMsixIXYtwCjHB9Qunsw3j//WRD8PNG1+whYSARsQldrVEC/Vh
	 r95uJvFU7wZjkHvnmDjCNh/NTvf9lPe4nFxcUus0Ia3yT8Stpqm4pKJttx9OpkXAjsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034107;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hdPbC5p4rVVV6epDUZWMOd3I0c+3U0DyhknkMEbbfW8=;
	b=uQvK4H8/CtbEKaUf/LAO2lIeSzeqwA/f/wpsazhrpnddFVPObpF1Qyyt/9V2QWyOdOo4
	 tOYq1kSPs9ptEmKqFuS26Xo7mxB9NpilG/7WhnD66Dor9n+bKq6chbRVPADbg8huu0LxZ
	 5MKLwW4VelSlnRzloRlCXYxcG46T0RZvBkM8BteiTzFazELufFH2z02rQM0ZIvaueOaxb
	 r+wRJ/ctlZptPdpP06GVRtzP6FZvFsm7lkVJ31jrDXFVGMwLUenmMPYCPX9Ai+ciC/N9Z
	 BAzhaw0Kdm1eesIjHaTTtYH6jNgepGMudKQn13o0BkV99BRmFHrIsZmHUz5ZeA4Oyhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LvVBH3Ew;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F5C9606A31C;
	Wed, 18 Nov 2026 20:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LvVBH3Ew
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 957A51F000C4;
	Wed, 18 Nov 2026 20:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034107;
	bh=hdPbC5p4rVVV6epDUZWMOd3I0c+3U0DyhknkMEbbfW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LvVBH3EwizM7ykwc/1hSbSjhy0nB5C27fZHuKyzJOAkg7RwYLWX6Bf8ukfg2Dixou
	 4R3CDUAmOsQJkoeukOeTZohTmqJr8AwTl92wyMrM7OJk5Q3s/uoEFyFZQsCRiHn2z2
	 hahfrnB43leXueaTp66KyzgCkNjbYYSHxdlNoGUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Bauer <mail@david-bauer.net>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0202/3318] wifi: mt76: mt7603: free beacon SKB on error
Date: Wed, 18 Nov 2026 15:13:44 +0100
Message-ID: <20261118150320.933715457@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Bauer <mail@david-bauer.net>

[ Upstream commit 965cbdbdfbd37a659a05ff88e49c216975bd9d2e ]

The SKB containing the generated beacon is not freed when the beacon
queue is deected stuck and scheduled for recovery.

Fixes potential memory leaks in case the beacon queue is detected stuck.

Signed-off-by: David Bauer <mail@david-bauer.net>
Link: https://patch.msgid.link/20260611215658.259324-1-mail@david-bauer.net
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7603/beacon.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/beacon.c b/drivers/net/wireless/mediatek/mt76/mt7603/beacon.c
index c223f7c19e6da..da535922dae75 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/beacon.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/beacon.c
@@ -56,6 +56,7 @@ mt7603_update_beacon_iter(void *priv, u8 *mac, struct ieee80211_vif *vif)
 		FIELD_PREP(MT_DMA_FQCR0_TARGET_QID, MT_TX_HW_QUEUE_BCN));
 	if (!mt76_poll(dev, MT_DMA_FQCR0, MT_DMA_FQCR0_BUSY, 0, 5000)) {
 		dev->beacon_check = MT7603_WATCHDOG_TIMEOUT;
+		dev_kfree_skb(skb);
 		goto out;
 	}
 
@@ -63,6 +64,7 @@ mt7603_update_beacon_iter(void *priv, u8 *mac, struct ieee80211_vif *vif)
 		FIELD_PREP(MT_DMA_FQCR0_TARGET_QID, MT_TX_HW_QUEUE_BMC));
 	if (!mt76_poll(dev, MT_DMA_FQCR0, MT_DMA_FQCR0_BUSY, 0, 5000)) {
 		dev->beacon_check = MT7603_WATCHDOG_TIMEOUT;
+		dev_kfree_skb(skb);
 		goto out;
 	}
 
-- 
2.53.0



