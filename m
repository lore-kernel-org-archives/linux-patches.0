Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216552;
	b=gt3vZkvbYRh9n5aXn2TeQ0nclGVvNTQO86J2+k/jcBdqwbmRI9uxxQQdALq6HdG4wNpl
	 EEIRADK5m3rdvILLE2CKmU1SR45hd7P8QOp9E21toQ1nuSiNrpJEn1EicgfhRvd8xSAG3
	 u9cMAF7z/bzZFSutRKlF8byfOype8kN9VCHAHgRXELcCb81neC/7dsm48mKoZn0q/8Kl9
	 1Q/+wWmhqZhtZ8yPOvOQVMBW7zt1CBPYmD58bX4sMZ2Kf5lD0RADfAa8tg7wUW2ckAfnp
	 rilZrcxSPIHNqRAizlDCupCIUMOBiDP+gSRyu1hur/MSTIsns8ey/BKqB2GOg1NI/+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216552;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RAegHLHk3EXVUcH8RUX9Zp9EUdqgo1oeCTo6vkJ1Vt4=;
	b=1W6FzLcW5twm07l20Ti26rRFzrDm+97AqbkIxEPq6hW07VQH+Ci17fERuFrK3Lm0jDV4
	 lM19Ctg2uQZW934MLmN13aZGcrmmyiAyRe+IuIg8OLTPe64VAwzpRagxrOIjWnT1hWsrl
	 /GsQIDDig3GzNR2ObydlRCAC3E1DlH2Zimm9Yc53Y56nTK76K5tsqh3zqfOFM6e27jECM
	 VwhUgnsUlIdULoX7xUF3UUOTtSnqnA9Z2N2MjEJp5z/ci2DQSztw/sUp7QgI9RCfaMSgP
	 /2lySuWi/aIOG0pmwPcsnoWqY4VcXoNQ1UsOSYOVGiXg+yzdZJNS2KGez4gg9hTF39Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uRwhvSLg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB7CA606A31D;
	Wed, 28 Oct 2026 19:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uRwhvSLg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35F2E1F01825;
	Wed, 28 Oct 2026 19:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216551;
	bh=RAegHLHk3EXVUcH8RUX9Zp9EUdqgo1oeCTo6vkJ1Vt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uRwhvSLgFWGLJJ65WzQ9w6E+cNPdr0QA2grbV+obmVMOA7Rf1MtXSaPrtiam6qPZI
	 NRUazms0l1RAG0tZmWkreHRVR9VDAi5uxGdUJUfrWIEIjxw9VKf/77ZLZEjT+fAXBT
	 k/jBB5E6VRQMqfM7yVTNtmilkUHj9olODmHVOyBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1594/1887] wifi: mt76: mt7915: Fix an error handling path in mt7915_add_interface()
Date: Wed, 28 Oct 2026 18:01:30 +0100
Message-ID: <20261028170535.744426066@linuxfoundation.org>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 126a516fe30639708e759678bcb10178938cc718 ]

If mt76_wcid_alloc() fails, the "mt76.mutex" mutex needs to be released as
done in the other error handling paths of mt7915_add_interface().

Fixes: f3049b88b2b3 ("wifi: mt76: mt7915: allocate vif wcid in the same range as stations")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://patch.msgid.link/b9d8fbfc19360bfe60b9cea1cb0f735ab3b4bc26.1727639596.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Stable-dep-of: 2fb6480c52f6 ("wifi: mt76: mt7915: unwind state on add_interface failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/main.c b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
index cee7cd4ad26d7..0b79039e53178 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
@@ -237,8 +237,10 @@ static int mt7915_add_interface(struct ieee80211_hw *hw,
 	phy->omac_mask |= BIT_ULL(mvif->mt76.omac_idx);
 
 	idx = mt76_wcid_alloc(dev->mt76.wcid_mask, mt7915_wtbl_size(dev));
-	if (idx < 0)
-		return -ENOSPC;
+	if (idx < 0) {
+		ret = -ENOSPC;
+		goto out;
+	}
 
 	INIT_LIST_HEAD(&mvif->sta.rc_list);
 	INIT_LIST_HEAD(&mvif->sta.poll_list);
-- 
2.53.0



