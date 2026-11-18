Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041336;
	b=BkI5ZWCfaWQKcDyNf6j+xCru7/DQsnZ+jaXLRqkFZ52Z+flyILvIb3TVs4M8kD/N0I6Y
	 OHrlFFsp7+A69+JJTHpzqZlKOe9tle0+rIzBkppEgE0QCEr7jYRZk11DUB/QK1dd+FOMj
	 fFXvFIJt3a2uJLjcYqYXpKUcZj+bwoY6er0rYvJfhy9a8fgtRh5JA6E0eDCpsQBgJ4NPL
	 /yMvE7yZuy5bNIqlH2MLS9qEZ049Wtl1ouYEYWLZ4PlZqE6cF4jsZAEYPsrIWCVA60G0U
	 IiYrnYnSsPA00Z2DcFmzTQq9yCUFlOH3Dylxt1XIYIxMInt3I9ZfdUO1HCF3zSXkWzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041336;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1OxkzhGeBwMFJIwcqkBlWUC+330i0kkvLHo+/sS3+yU=;
	b=nfxzPQD5miBcZlxYnrDfykfcGT9AeXS/mFfWkdso+2KF7Yyx/+yUH9MYudfxUUc5RHnk
	 3Zt7LBWyZYQ3XB6m140ajNoWcUBzyHh1ymkNN47Qlw39EXBnoOGE783FFtt/IaVEmJ9qX
	 fmqnxZexGJd10rVHceAHT0yhXQCotoxHuLDaR+3MHjzRblgQpqlN9quKAKF+QVGp4bKG6
	 nbkICye3mSHAhOWVYJm66n8A5E2jh1OpB/1O7yAdA8Ma0D9WK+97av69gBvBGJzyjKsZs
	 5Sqai1BPKA5ShNh+wuRFc6JbP2HlJsEj5/U9+39Kp4Ckl1Y/qSzsqzoK8KN7muUcTeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="lmHFn/lp";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D509606A32A;
	Wed, 18 Nov 2026 22:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lmHFn/lp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B9EB1F000C4;
	Wed, 18 Nov 2026 22:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041336;
	bh=1OxkzhGeBwMFJIwcqkBlWUC+330i0kkvLHo+/sS3+yU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lmHFn/lpD/fz5k/4nJYjdijhqfpu+L6MlZOuskB8M2mJWr671NYTsmNWWlQpBGrFC
	 nPCWswKMzwflL+f9+Gs/mtkXeJpvQ+OHoFUxMTInXB1L6Qq2wisWiF6k9OwEqMqnxm
	 1t0/I+tR8kHBq6uDpN2GwaPTXK8du5I4+YvQSX38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chien Wong <m@xv97.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2777/3318] wifi: mac80211: reserve MME tailroom for protected beacons
Date: Wed, 18 Nov 2026 15:56:39 +0100
Message-ID: <20261118150444.014844678@linuxfoundation.org>
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

From: Chien Wong <m@xv97.com>

[ Upstream commit 48002331da85c7c962cfbc09c8bd84d219a6fe1c ]

Beacon protection appends an MME to beacons, but the skb
allocation does not reserve tailroom for it. If the available
tailroom is too small, the crypto path drops the beacon.

Two factors often mask this: the 256-byte TIM reservation is
rarely fully used, and dev_alloc_skb() may round up the
allocation, leaving extra tailroom. Neither guarantees enough
room for the MME.

Reserve enough room for the largest MME.

Fixes: 0a3a84360b37 ("mac80211: Beacon protection using the new BIGTK (AP)")
Signed-off-by: Chien Wong <m@xv97.com>
Link: https://patch.msgid.link/20261012140738.70178-3-m@xv97.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 0c348c7b3f639..f88613c811ac2 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -5468,7 +5468,8 @@ ieee80211_beacon_get_ap(struct ieee80211_hw *hw,
 
 	skb = dev_alloc_skb(local->tx_headroom + beacon->head_len +
 			    beacon->tail_len + 256 +
-			    local->hw.extra_beacon_tailroom + mbssid_len);
+			    local->hw.extra_beacon_tailroom + mbssid_len +
+			    IEEE80211_ENCRYPT_TAILROOM);
 	if (!skb)
 		return NULL;
 
-- 
2.53.0



