Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029182;
	b=BaA3GvaKV26XnujdRICxda509H29P9GoJzAm+DmmauC13skZTmQL6o9rSFSkTFYAys3U
	 ktuao+TkPreyU0E59mJsmFi88oiWjGWfqIHF8OaPGB6wKIlSwftkisZQ6HcHj7sDjKsRp
	 nrgvOQh+3IZgJiUD64F8YtWz+0hNt2mZTirZN3Q+M6Ah+U6kC5DdNa9hbMdQ6puPayNfQ
	 oZxNliufBXZxAANWIXJabhdW8uca3YP8PX+I72afrWmOnX3j4tvcFpj+hY9gwp9iIl0uh
	 hBgEqdmv6N/H03rITjS+6mCQJy1h4Es6FZCiCxk+1fCn3Jgb211GpekTTExfgjA48VQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029182;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mPOUi1evQrNZDU5ogcpkQIf0/eBJSE4uuA5LuAJtunI=;
	b=ZifNAEubDKKA6p3PYTCckMUKkomA1b0ErYIUwA3DtSwe9RXm6P5ZzX0acOgYArxYkFtf
	 +okVjBH2ghxYXWXmeNV31sU4P5qDChsaGbFH1wQtis1cdDJpt228nCw2ooEIouR9zXLSb
	 Qgcyt6fLCNY7ObvHffsJlte6Yqfy4WOS+cOgVbjTH/H85oZS1RrsKQHHoJPY2COEEi6jY
	 NcNA9kSTGXhCNALoDu+MLeCEbUVieI48zWOkwiqobBpXjFNZDooKFZ0bZZYqwnb3AzAM+
	 VTsLPJQO0D51rTY4xKe1aSxwGJqR85S6pvzwuFAaE4F3aEoXMFIc4tmHMt0nkuxnldg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wy2Ntngo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3B5D606A31C;
	Wed, 18 Nov 2026 19:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wy2Ntngo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48BE81F000C5;
	Wed, 18 Nov 2026 19:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029181;
	bh=mPOUi1evQrNZDU5ogcpkQIf0/eBJSE4uuA5LuAJtunI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wy2NtngoXANZ3vQ2rqwf8sQUBxQlizRW2HvhrcpBWj+UK99Xq9waiavRzCJjbZnlN
	 h5KO7YjUt4/bFTCSIwweGyPWOXf1+C4CPEMKesF9er0HzrHthGA0JzR5MVfnqhDbfk
	 3R+DM25AaCvuA2vplkIn/Qog0zcAzMnSUBlboRBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bert Karwatzki <spasswolf@web.de>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0257/1756] mac80211: tx: Use info->flags in ieee80211_tx_h_select_key()
Date: Wed, 18 Nov 2026 15:39:44 +0100
Message-ID: <20261118150018.601847741@linuxfoundation.org>
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

From: Bert Karwatzki <spasswolf@web.de>

[ Upstream commit 5f2530a4df8e0573e54cc0f4175c06ecb810a4dd ]

Without this ieee80211_select_key_8023() is never called and wifi never
connects.

Fixes: 0e80db08668b ("wifi: mac80211: fix key selection for encap offload frames")
Signed-off-by: Bert Karwatzki <spasswolf@web.de>
Link: https://patch.msgid.link/20260908094341.12196-1-spasswolf@web.de
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index b8b8a2622cbfe..e64811ff8ccb4 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -626,7 +626,7 @@ ieee80211_tx_h_select_key(struct ieee80211_tx_data *tx)
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
 
-	if (info->control.flags & IEEE80211_TX_CTL_HW_80211_ENCAP)
+	if (info->flags & IEEE80211_TX_CTL_HW_80211_ENCAP)
 		return ieee80211_select_key_8023(tx);
 
 	if (unlikely(info->flags & IEEE80211_TX_INTFL_DONT_ENCRYPT)) {
-- 
2.53.0



