Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015707;
	b=o+WMgv8qfFLKwFWExTIa94K5WoAMeL4ByOBgkeJaFOWBaRXGDlLtO6NkqJHme9neDVdA
	 YswVmyc46EE/qwtubPvL+jtSHXaT/AltIzQN1PkH00fqe7dNpNqsKwTcLtRB317ko/fxF
	 h78O6veUKepL1/g4UCDeN/QO8MihNY9LYJFTY4qgB+nOs19unrUR3Q0G4dP2RDqtARCJA
	 dvLgwGQlmgEWAYxq/OTKz8byU7XhOUe91UZ+jwN6GCFLTo/FqJ77LeXYjcOKEO0oxxdek
	 NO8nvY7NbiQrqnEbouVH1aq8Ai+hTnIE7wegw3kogWI4gG/QyaBBvxjKx3Nun26keCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015707;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cJhloYUQos28C+93UiGdpHO3aisdABoWgYKoqMPK81Q=;
	b=mqXgxyO2YGpRbrsfAiJzFV/zM3zXAkraQR5QF5L3bkyDhRp1y4hrVY/skrZWjGqC/nll
	 WywL/T5MKAQi7oj2JWPeYFfws56uu69M+LDW1a2WZCIP13nYvW5RItDNt0hRBEOt7jhgb
	 xZyw/6iB9Z+SnPRV5gSofirL6STVKDOF345XAt2JAJsEMKNaW/w8e3ZCeqOlJwW/uCj1Y
	 Mr627m3o5bdfF9A3kmvKfJFsLnwrZzROoZgndjunDhagkaaeJlNbIEey6XkfbPItaF3qY
	 Gwymt/blUtfrH3kh8o+GFNBCAoSIJPQmi95GmJHQ5OBIE/FhCi98qT5XLOZFXNgngnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PicFKCO+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BA26606A332;
	Wed, 18 Nov 2026 15:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PicFKCO+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F9731F000C4;
	Wed, 18 Nov 2026 15:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015707;
	bh=cJhloYUQos28C+93UiGdpHO3aisdABoWgYKoqMPK81Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PicFKCO+Mp4N7uFiAIfCpKhKHxQCqUz4cUUGEnVUj7F90Jpdv1j1UsbJQ6GZl57c1
	 4IJpqkH1vvpDJx4eKqkvC+MUgeuwRDR8kwRYwPT6dmCFR93rFalA0X1RjFMLdidIOc
	 lXNsOatb0XEuaG4rD2AS7MC2gaXS0ME2WGjGmTvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bert Karwatzki <spasswolf@web.de>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0269/2651] mac80211: tx: Use info->flags in ieee80211_tx_h_select_key()
Date: Wed, 18 Nov 2026 15:25:09 +0100
Message-ID: <20261118150257.595897387@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 951e2c678fc5f..e989772ad92b8 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -618,7 +618,7 @@ ieee80211_tx_h_select_key(struct ieee80211_tx_data *tx)
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
 
-	if (info->control.flags & IEEE80211_TX_CTL_HW_80211_ENCAP)
+	if (info->flags & IEEE80211_TX_CTL_HW_80211_ENCAP)
 		return ieee80211_select_key_8023(tx);
 
 	if (unlikely(info->flags & IEEE80211_TX_INTFL_DONT_ENCRYPT)) {
-- 
2.53.0



