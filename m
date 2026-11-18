Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031154;
	b=0S0hsyfEfTNjsR9TmzpPdwHBewm1Eng131Db8bPglwmAHLNruzBCXjelsZemQ/y146f1
	 qEDL8wMn2Pf2F+90LsEgKz1JGckCpTi05YbwarA3cdQuHGAEWba8Z10TCOIffOPFXDjbI
	 bjen2bl3RPUeVW52GifB0/v2LHf3XUx+dTsD8daKSIbAbMp+kMVxK2fczXo9Y9Cr+2trx
	 uqaJ5Is/dzDt9IO+fF2fCrdleKqBErkBopEDJtFYB3KgT36i3EDJ1fqfGJd4Dpgf6xOLi
	 fMFssxY1jnC+1HeFmdMv2N5N30n+fEFkfxNYLYSWh+kIEOAWG05HUH0IDDr7zqSkYgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031154;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UCOxxu3Zb7BLa96SpVksj9VREXdkGRR4YrswcgAdY2g=;
	b=04QQrdbHb1aN0revFZMO0xZL3a7yjc++EaGby6sFxhY3F/pT00Kpz+yGWtcd09xpsLZt
	 Oe/QsXwxwh6yrIcDni0pkkxBVXtzyjWjopme7kqejz5jGHW7fcmf7CyOy8nPXeWLjRNDn
	 9mueWqQ5KHe6qLKXqXlfvP2hZwdKgYoMTxgYMPCM+v5RWvKeUzwcY2ntvjF9/ZiIYeOyh
	 fDEuTMpTqFxpxUmUo2KHPzPrK/eWpttsIa9toLZ0ZtArdyndphHOWxsze9xQ/MjSGjaCq
	 zRrMW3goa2O2YorbzeQeHS6GR7/A/agSa3NMu2IhydcvYxSYnmP7WgZIioWIUYT8uGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="KSOIhT/3";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3996A606A33E;
	Wed, 18 Nov 2026 19:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KSOIhT/3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 924FF1F000C6;
	Wed, 18 Nov 2026 19:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031154;
	bh=UCOxxu3Zb7BLa96SpVksj9VREXdkGRR4YrswcgAdY2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KSOIhT/31SdVOtygqh0KUdo+8ZrsYi3OPMI425LwuqrkZyo70/IJlsZZFdIlLGUFn
	 7jDLx6L7UkrVlNDLjxTIc4pqzM5ttEVuFpIJtXAsfY9DJnS4PNGRYIMtYAR1EUE9yQ
	 b+J/2Es461zXWqlf1rjj0XUTLx4dfUk/0pXgLPMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0957/1756] wifi: mt76: mt7921: fix the lock inversion in suspend and resume
Date: Wed, 18 Nov 2026 15:51:24 +0100
Message-ID: <20261118150048.173747129@linuxfoundation.org>
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

From: Devin Wittmayer <lucid_duck@justthetip.ca>

[ Upstream commit 0e6472108d51a42272332f5b6a95871244b64301 ]

Same inversion as the config path, same one word fix, missed the
first time. Both are called with the wiphy mutex held, so the walk
can rely on that instead of taking the list mutex.

No new splat: same class pair as the accepted fix, and lockdep
reports a pair once per boot.

Fixes: ffa1bf97425b ("mt76: mt7921: introduce PM support")
Link: https://patch.msgid.link/20260810045338.118923-2-lucid_duck@justthetip.ca
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
Link: https://patch.msgid.link/20260830064201.92285-2-lucid_duck@justthetip.ca
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/main.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/main.c b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
index 0160268d02740..71abaeaeda3ec 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -1136,10 +1136,10 @@ static int mt7921_suspend(struct ieee80211_hw *hw,
 	mt792x_mutex_acquire(dev);
 
 	clear_bit(MT76_STATE_RUNNING, &phy->mt76->state);
-	ieee80211_iterate_active_interfaces(hw,
-					    IEEE80211_IFACE_ITER_RESUME_ALL,
-					    mt7921_mcu_set_suspend_iter,
-					    &dev->mphy);
+	ieee80211_iterate_active_interfaces_mtx(hw,
+						IEEE80211_IFACE_ITER_RESUME_ALL,
+						mt7921_mcu_set_suspend_iter,
+						&dev->mphy);
 
 	mt792x_mutex_release(dev);
 
@@ -1154,10 +1154,10 @@ static int mt7921_resume(struct ieee80211_hw *hw)
 	mt792x_mutex_acquire(dev);
 
 	set_bit(MT76_STATE_RUNNING, &phy->mt76->state);
-	ieee80211_iterate_active_interfaces(hw,
-					    IEEE80211_IFACE_ITER_RESUME_ALL,
-					    mt76_connac_mcu_set_suspend_iter,
-					    &dev->mphy);
+	ieee80211_iterate_active_interfaces_mtx(hw,
+						IEEE80211_IFACE_ITER_RESUME_ALL,
+						mt76_connac_mcu_set_suspend_iter,
+						&dev->mphy);
 
 	ieee80211_queue_delayed_work(hw, &phy->mt76->mac_work,
 				     MT792x_WATCHDOG_TIME);
-- 
2.53.0



