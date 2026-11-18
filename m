Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025894;
	b=lgxF2vITc0GfH5308ecMYyrfbHMWgsKpxGG4frNKiwkQVD7k5VABaW9MydmKssxl87Sz
	 Tb7ODGU++2C5qAQe+YPP+1ZnZOUWMec5GaGzt0zI9+56EafFKoBENHLb0jiL96ul4/49S
	 hnf2AOQbMVMxO6BB7SrXc2pehuRPz5LqIsntBKQPwBK8W+0uTG9NDBjHbfgL0jFX5e8SJ
	 DoDqu8wQLxVSK4iVJT8Sjd+B4iQX2xTIRMRYsECjnmW9+p1nhuuLecI/6LWRajOooUVVL
	 b0TXNDUKGbV01o0BZZmB4HmpO9/2DnzEAYuiABqz78tcUbm4Q3FeMK++WS5vtaJAiYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025894;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6IBB58HFUn5u1EuVEX3pWLDKubO6ZqIpycJWIX9GK64=;
	b=JCKuaLtDfbucjUoQI3MbOkkGn2Fn09GdatE07ushPwV/k1Sckqt/T5iXQjWm0b85/JUk
	 AE3nrnpDXdIpkT46uDjVQh9gABC6//lwWo8zFf0NvUzR3lfTXLKccLqlckwoyNvfz8ehT
	 S+uxaNIdDWZg1FPadvULAlD9UV0fJtFPP7SDxrPYz+PPlnt9Q6jwIEaRLskcuNtyOL7E7
	 dSlTv9792BbbI8LoHgM3iEelm0Co7erM9rjDhZ+yaaR4Ap+fFzKnjr0YwCzLwajKBcGhb
	 jrD5tE4byzb9vGhcgavuS+W0YiKkqDBJsOwhYe2Tm1/v3yxdfHtAPeGWSgDe2jd7CcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wDgMv08D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CC00606A32C;
	Wed, 18 Nov 2026 18:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wDgMv08D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E8E11F000C4;
	Wed, 18 Nov 2026 18:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025893;
	bh=6IBB58HFUn5u1EuVEX3pWLDKubO6ZqIpycJWIX9GK64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wDgMv08DBBJYzBopvQJatYSfPPHQPXtnse9ugQJAH/4D90wUTsLNZkcqp7ThmBF2W
	 uKy4uFTcn2+n+uzrKgkMzYhHhindg+iilDz3gbAzokVC7PJGryuGOzPYrgYbFM8QXu
	 v4QIWCWQpCcFW7N47T0NR3SepXgjAPTyLqNq0Dtw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1239/2151] wifi: mt76: report an aborted scan or ROC to mac80211 during a reset
Date: Wed, 18 Nov 2026 15:49:34 +0100
Message-ID: <20261118150207.309029851@linuxfoundation.org>
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

[ Upstream commit a45aea434cd7e0b4c3cea5a0ca4ebc54a6388a1c ]

mt7996_mac_full_reset() and the L1 SER branch of mt7996_mac_reset_work()
abort a running scan and remain on channel. mt76_scan_complete() and
mt76_roc_complete() then skip ieee80211_scan_completed() and
ieee80211_remain_on_channel_expired() while MT76_MCU_RESET is set.
mac80211 clears a hardware scan only from the completion. After an L1
SER recovery, which does not restart the hardware, every later scan on
the wiphy is then refused, and a remain on channel stays pending until
userspace cancels it. After a full reset, ieee80211_restart_work()
warns:

  WARN(test_bit(SCAN_HW_SCANNING, &local->scanning),
       "%s called with hardware scan in progress\n", __func__);

Report an aborted scan to mac80211 in a reset as well, and an aborted
remain on channel unless a hardware restart follows. On a restart,
ieee80211_reconfig_roc() restarts a remain on channel that had not
begun and ends one that had. Since the scan is reported as aborted,
mac80211 does not continue it on the next band during the reset.

Fixes: b36d55610215 ("wifi: mt76: abort scan/roc on hw restart")
Link: https://patch.msgid.link/20261007112419.1277594-2-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/channel.c | 2 +-
 drivers/net/wireless/mediatek/mt76/scan.c    | 3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/channel.c b/drivers/net/wireless/mediatek/mt76/channel.c
index de1291d6c1d46..0ab676a9f3ca7 100644
--- a/drivers/net/wireless/mediatek/mt76/channel.c
+++ b/drivers/net/wireless/mediatek/mt76/channel.c
@@ -340,7 +340,7 @@ void mt76_roc_complete(struct mt76_phy *phy)
 	mt76_put_vif_phy_link(phy, phy->roc_vif, phy->roc_link);
 	phy->roc_vif = NULL;
 	phy->roc_link = NULL;
-	if (!test_bit(MT76_MCU_RESET, &dev->phy.state))
+	if (!test_bit(MT76_RESTART, &dev->phy.state))
 		ieee80211_remain_on_channel_expired(phy->hw);
 }
 
diff --git a/drivers/net/wireless/mediatek/mt76/scan.c b/drivers/net/wireless/mediatek/mt76/scan.c
index 67d73812dd1eb..673587a59cc2e 100644
--- a/drivers/net/wireless/mediatek/mt76/scan.c
+++ b/drivers/net/wireless/mediatek/mt76/scan.c
@@ -37,8 +37,7 @@ static void mt76_scan_complete(struct mt76_dev *dev, bool abort)
 	}
 	mt76_put_vif_phy_link(phy, dev->scan.vif, dev->scan.mlink);
 	memset(&dev->scan, 0, sizeof(dev->scan));
-	if (!test_bit(MT76_MCU_RESET, &dev->phy.state))
-		ieee80211_scan_completed(phy->hw, &info);
+	ieee80211_scan_completed(phy->hw, &info);
 }
 
 void mt76_abort_scan(struct mt76_dev *dev)
-- 
2.53.0



