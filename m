Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025768;
	b=vJX7U7JtMINuRJbwrE3AppC6mrM77612PzXknWNYCXt05b3wb7hHym0DbzwuOh/8NZaN
	 Gp1b5vxdj4u7JlbBjF+M4q80M1W30fSxvp0j8cM/YXXW3WQ4OPwQtJlIYCWhSerVD6UkW
	 +ejoaq5kP03/GSYI8RkUlXUOht+Jojsh24A/lv4HQVaFA2YRjqRNCesQF/Hyk6KAjzgap
	 Gewqisa9bm6MK28NAXHn3xYoFvkQ5X+dccRDhq2TOsu6RMvRpUysrRdaoudP+PhejMH7r
	 glUCGVtRCaUWk7E6in1bx0Qh3qznd41yvTCeIr6cvK/y7zJY7AW8ezNlynNy4gqhMFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025768;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=24hGuIIFSVartb29Lm/8IV/nf5AqOirbrpPYOQ2wnM4=;
	b=X/KJTn+ZPO1dzPhgaCTE+0SiLQh9JR42+WImoLtHqEt3W1b42ZaLnRgP3/5epG2Kj9sa
	 gGZL4IEN+I7Nl+OWXbnv2j1FSoIt4+K5Y0y/IBa9UplQ3hQT7IlJaO8fw0FbvzaB9YwzC
	 SQoZHh6sZER3v3qm7DQH49WyMqcep1WW4nIjRfN/rpxQT38dHnT2FWXAdNWb5ekvdVpuQ
	 detxo5Snuh5cnn6pOYlBDdC70KNFtA/3pwcXfBC7Twh8oe2T3G2EuP5gwoGcrT6hEXOFe
	 XAJ3Y/IMVeOvDSJg5xDgkYyeBtZ0hgdRFxf6eKLkaZiFqK0ik6DFcs+QLuJtzKlBM2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Z/dExBnQ";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26DD4606A33E;
	Wed, 18 Nov 2026 18:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z/dExBnQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79A911F000C5;
	Wed, 18 Nov 2026 18:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025768;
	bh=24hGuIIFSVartb29Lm/8IV/nf5AqOirbrpPYOQ2wnM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z/dExBnQ2lov+2xtn1fIKAin7o/GFpyV/bw2VsSQ2qFlLIo0dbJte+NWfyqCXra4e
	 U4Doz424B3Ovp4meuIl0E2FmI8GPS2T0jpny29gaJreklgbk3yc4CE7+Kc+NPIIwNm
	 CS3rEOYNwCVsUiiezS+k95HGb2bY2rMwXuLbUYik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1194/2151] wifi: mt76: clear offchannel state if a scan has no channel to restore
Date: Wed, 18 Nov 2026 15:48:49 +0100
Message-ID: <20261118150205.710918342@linuxfoundation.org>
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

[ Upstream commit 3aaa4871006d2abb3a597028c45042311acbc640 ]

mt76_scan_complete() restores the operating channel only if the phy has one.
__mt76_set_channel() is the only function that clears phy->offchannel.
A phy can run a scan while it has no operating channel. A 6 GHz radio with
no configured interface is one example. After such a scan, the flag stays
set.

mt76_txq_schedule_list() skips each TXQ whose wcid points to a phy in this
state. All traffic for the stations on that band stops. The frames stay in
the mac80211 queues. They do not reach the hardware, and no counter shows
them. Only an unrelated channel set clears the flag.

Fixes: 31083e38548f ("wifi: mt76: add code for emulating hardware scanning")
Fixes: a8f424c1287c ("wifi: mt76: add multi-radio remain_on_channel functions")
Link: https://patch.msgid.link/20260818125825.395538-4-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/channel.c | 2 ++
 drivers/net/wireless/mediatek/mt76/scan.c    | 7 +++++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/channel.c b/drivers/net/wireless/mediatek/mt76/channel.c
index 5d377ce501787..696b8ad3ea403 100644
--- a/drivers/net/wireless/mediatek/mt76/channel.c
+++ b/drivers/net/wireless/mediatek/mt76/channel.c
@@ -334,6 +334,8 @@ void mt76_roc_complete(struct mt76_phy *phy)
 	    !test_bit(MT76_MCU_RESET, &dev->phy.state)) {
 		__mt76_set_channel(phy, &phy->main_chandef, false);
 		mt76_offchannel_notify(phy, false);
+	} else {
+		phy->offchannel = false;
 	}
 	mt76_put_vif_phy_link(phy, phy->roc_vif, phy->roc_link);
 	phy->roc_vif = NULL;
diff --git a/drivers/net/wireless/mediatek/mt76/scan.c b/drivers/net/wireless/mediatek/mt76/scan.c
index 8b6dcbd3f1d5b..8585807612bef 100644
--- a/drivers/net/wireless/mediatek/mt76/scan.c
+++ b/drivers/net/wireless/mediatek/mt76/scan.c
@@ -27,6 +27,13 @@ static void mt76_scan_complete(struct mt76_dev *dev, bool abort)
 		mt76_set_channel(phy, &phy->main_chandef, false);
 		if (offchannel)
 			mt76_offchannel_notify(phy, false);
+	} else {
+		/* A phy that has no operating channel has nothing to restore,
+		 * but the flag also gates the TX queues of every station whose
+		 * wcid points at this band, so leaving it set stalls them until
+		 * something else happens to set a channel.
+		 */
+		phy->offchannel = false;
 	}
 	mt76_put_vif_phy_link(phy, dev->scan.vif, dev->scan.mlink);
 	memset(&dev->scan, 0, sizeof(dev->scan));
-- 
2.53.0



