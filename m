Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031157;
	b=Kv6qTcePO3vdA1nyiPsmIbPHfVymI+pnTO94Crao/hZuPibZwHQLnrDauiMjUdxBi8am
	 2GQRD1cIj+7oJT0/IkiIFQ7ZpF98Lgk5mQ/nCoF2vmIRXmytLaUpJNVOFMDlNvwOF6QYE
	 aAlJ12hKbJWiD4QB5IHliBt/tJGv/f4FXuG9QX71PCcQXHsDKeQETmt5iXAMItYnU4TAS
	 CNWbXg8VRqkrjDkc0EamxHT1bsml4crCzSCrWVavnxkiQYHcwm59N7n3w/dWpm1cUcURp
	 WNret/ooBZwEEqzrX+3s5jQ7PDDREMf/kZosAkFWRiNJVmhY0gamZLo0zC2NxQX1V/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031157;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YlqQYmkCr7/Y9SwkV/HcAJsC7srtlzdCjhvmlkHpfIs=;
	b=Vu7l8L2klsqJMSQo8TzvpWGn5uuj0GXfY5lRJCDetlDrlZRri8o/WwVFUBHF4fVAgnlR
	 cui7cDkIp8BELm0wrdBb/qolf+Rfarb7pjPYI7wBAVLJl1TDuC4JSITb852vR7vG1eTFq
	 KxZhk/KzMD4y+XPK1Bc4kx6SFP3F7T2vrItc243jGKQ0TQZFPNAID9ZvWPZgUAnTGGXpt
	 GC6CoJJqcNBKvA/Boocoy0sEG6F6wDUpVouAi2SwMsCblbAQpRKv7zfML3J0mKdvAJqll
	 jQPh373DFJ/MbxR59Jh4k9IUx1AKA91pQxMlOFbbv50Sk78DixqpBnI5vmepoK9euQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RkmOPBlB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C783606A31C;
	Wed, 18 Nov 2026 19:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RkmOPBlB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51E331F000C4;
	Wed, 18 Nov 2026 19:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031156;
	bh=YlqQYmkCr7/Y9SwkV/HcAJsC7srtlzdCjhvmlkHpfIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RkmOPBlBpOQRUR/2JVicJaQBNXUsbBTdkDNuyxM4mibVGHLmv96bp4rW/ZOcGfvuO
	 rUSzU7u31VEzIvZ/IueWO0QgrQ0IWd9ds2mitgW5wYT16h129k/fIi641sNrRZn+Aa
	 ufBHkY5N5yhBXuC2OgStk20G1TiJXDTs6dX1fuyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0958/1756] wifi: mt76: mt7925: fix the lock inversion in suspend and resume
Date: Wed, 18 Nov 2026 15:51:25 +0100
Message-ID: <20261118150048.212001603@linuxfoundation.org>
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

[ Upstream commit a105a9fe9a07a56d1e0b5a6978a49cde2ac7e7be ]

Same as the previous patch, other driver.

Fixes: c948b5da6bbe ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for mt7925 chips")
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
Link: https://patch.msgid.link/20260830064201.92285-3-lucid_duck@justthetip.ca
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/main.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/main.c b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
index 7cf75e1422637..7751b42f91635 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -1543,10 +1543,10 @@ static int mt7925_suspend(struct ieee80211_hw *hw,
 	mt792x_mutex_acquire(dev);
 
 	clear_bit(MT76_STATE_RUNNING, &phy->mt76->state);
-	ieee80211_iterate_active_interfaces(hw,
-					    IEEE80211_IFACE_ITER_RESUME_ALL,
-					    mt7925_mcu_set_suspend_iter,
-					    &dev->mphy);
+	ieee80211_iterate_active_interfaces_mtx(hw,
+						IEEE80211_IFACE_ITER_RESUME_ALL,
+						mt7925_mcu_set_suspend_iter,
+						&dev->mphy);
 
 	mt792x_mutex_release(dev);
 
@@ -1561,10 +1561,10 @@ static int mt7925_resume(struct ieee80211_hw *hw)
 	mt792x_mutex_acquire(dev);
 
 	set_bit(MT76_STATE_RUNNING, &phy->mt76->state);
-	ieee80211_iterate_active_interfaces(hw,
-					    IEEE80211_IFACE_ITER_RESUME_ALL,
-					    mt7925_mcu_set_suspend_iter,
-					    &dev->mphy);
+	ieee80211_iterate_active_interfaces_mtx(hw,
+						IEEE80211_IFACE_ITER_RESUME_ALL,
+						mt7925_mcu_set_suspend_iter,
+						&dev->mphy);
 
 	ieee80211_queue_delayed_work(hw, &phy->mt76->mac_work,
 				     MT792x_WATCHDOG_TIME);
-- 
2.53.0



