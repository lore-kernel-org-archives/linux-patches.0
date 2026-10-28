Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213864;
	b=UtS9ZDHtp6GgEVIr/ECQZWwRMjBh9oU/OiXRCpZ5H8lhhHe9FLMI1m2t0dLhE1fJEsp4
	 N5rjeUEHyMWOF1MeSQ7pa0tHRtp96lDPVeJemU4SeFVvqq9n/D7CTXIs6vfLqw93i7RlT
	 1YLTfqrbJmVuqIo0SKyuvLUJeFXTxhdzgI+iNjQ6PIrlrve2M/AbsI8NPad9xPV6GbrOM
	 B7vULlURSNPReyZur62Y6GBMbB1PxVSszzmDpd4omnQf8KHIHKzGOgey7QdxpEBHo+lMg
	 WiSbdNER5UEyQCTA4G3YyBc19Vhbx5eqqwWABT34v/EyEhmPBQJapYhA2vCzynyjtwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213864;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kU6Odp6Md7bCEnijjzeL6BCM9K9PJ6eoqpfL2xqBepg=;
	b=5bUSVkcYbAQL21bpqp6eA9e2AVQ1O3p2OB0OACB35Ext9WZtqYu3ovYsGuKfo3O53Ah4
	 DhW4mVYNSHtCesk04IUCYLXGCzYy0qrX+OzxLRQu72g4scuDuilYIO23AGv1k1uaL4y6m
	 +qEInvuZI0l9Vq6lg0MYugYcIC2CaosnTmp4ulN7TJok2r2CTxmAxo5m6U0k1PhhaY/jC
	 53JIr+XjTtrtayDVazCJrl5/jsKyoImqhaNR7F3v0PcMerWt2ZkdG0Vy2cdk9ZvvqaI3s
	 viEBmz/RBwm7SjzdDr0S76J0Qs/8ySkjEr5KJVzBvP3O8Gx4bZT5O/5n7BG9mukyFxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dDr6FfC0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA689606A31A;
	Wed, 28 Oct 2026 18:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dDr6FfC0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 099091F01825;
	Wed, 28 Oct 2026 18:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213863;
	bh=kU6Odp6Md7bCEnijjzeL6BCM9K9PJ6eoqpfL2xqBepg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dDr6FfC0PemI/Jvw+4+4ng0Us8AAON/RRajfKXuIQeow/2X/Z7bQXW/7ZS3zUo3gq
	 wvFS1F0E1LrcuWd6Bs5IBPYyBuXSEHjjvHfkZ4hK487SZgdAuKLXgQNxrQDGfDtcR1
	 MkDmCZliuPKhfTWpT4OMhivuzsZdCJIUsN73U+Do=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bert Karwatzki <spasswolf@web.de>,
	Felix Fietkau <nbd@nbd.name>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0655/1887] wifi: mt76: mt7921: fix NULL pointer access in mt7921_ipv6_addr_change
Date: Wed, 28 Oct 2026 17:45:51 +0100
Message-ID: <20261028170514.317277880@linuxfoundation.org>
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

From: Bert Karwatzki <spasswolf@web.de>

[ Upstream commit 479ffee68d59c599f8aed8fa2dcc8e13e7bd13c3 ]

When disabling wifi mt7921_ipv6_addr_change() is called as a notifier.
At this point mvif->phy is already NULL so we cannot use it here.

Signed-off-by: Bert Karwatzki <spasswolf@web.de>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://patch.msgid.link/20240812104542.80760-1-spasswolf@web.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/main.c b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
index fd91d2c537603..6c59ad33d3205 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -1436,7 +1436,7 @@ static void mt7921_ipv6_addr_change(struct ieee80211_hw *hw,
 				    struct inet6_dev *idev)
 {
 	struct mt7921_vif *mvif = (struct mt7921_vif *)vif->drv_priv;
-	struct mt7921_dev *dev = mvif->phy->dev;
+	struct mt7921_dev *dev = mt7921_hw_dev(hw);
 	struct inet6_ifaddr *ifa;
 	struct in6_addr ns_addrs[IEEE80211_BSS_ARP_ADDR_LIST_LEN];
 	struct sk_buff *skb;
-- 
2.53.0



