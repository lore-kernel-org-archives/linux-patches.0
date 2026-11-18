Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026329;
	b=GG57LgMCVJXecdjqaw+Va8RGAQVs03CTDeg0ChBJ/EXD1qe3UA1XXpQqd8/YAaRkblTN
	 kWC/JwqEa4diLNRW5goZl0DUM4EZLYyZaXviJb/XlOkn6kqr2gT3qhm64LDaV8KdmDiL2
	 SeSFqbgql+MC/xF96YivXKDJF1R2fZvohHlZIWw0nFKmcL9aYz/4Dl/UJdge3q+QB7t9Y
	 P8naF6SBf5/40qoVWpS9of9mrn+8vDr1jypwmCsVfftBfjnK4xTUiwzdoWBP7ed6mYEQt
	 0acpbtrCAQCS56TsCc9b7qZe3bFECwhuMh10fAUiNghIIgcDCxlUc/8v+/w5uB0vHhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026329;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wQu3Z4sKBGdhsNCHBl+1wlVLocua7AoG0c6K5QjaF0c=;
	b=VeWB9p59zjkZJyj+LicOJvxuZ51hI5RZ3gXFpk/6p7aW5KA983oIVcLDB58FqwDT9Zcu
	 ybmrJmVlnKDHTpx9bdMeoj692+OnfXUDec90I6pGrjO+0z6SQmDayqE3Ly7zCfOzbCQgt
	 VISOGLuVSvH5Vh2lC1nduh6cOgfZeaXg4fxITNf0rCE0luzjHxlY9RopyWXI5YL3Zs9e/
	 XkCEXej1D7M3tUTy/R7hp/aMDj6fL/mbtOD+QjrcpX8e4BkVcAWZGGtyA1WjHIDpEK71o
	 EO+Em+B06rlyFfFJBg2cbEkWfrNU6XDftXpr8f7v9HGncBLuyXgzQvDnYjxzgAK2D9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=emtkWryh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E044606A325;
	Wed, 18 Nov 2026 18:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=emtkWryh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 959261F000C4;
	Wed, 18 Nov 2026 18:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026329;
	bh=wQu3Z4sKBGdhsNCHBl+1wlVLocua7AoG0c6K5QjaF0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=emtkWryh0D/sFlAMVyIHSSERGb2xQA/JkWW4oGyhUvZpfYTGEC5MQj0s6kkL8+RT8
	 i4RHRqjrajg1nmX47fV6th8Se2w49hLBda1UKHRKZQXUnRE9GkjlzAorgnur4/3VKN
	 1UFtnqBzpfVuSSaUXVKzpfq9UKfplyh+RC2C1Aeg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chien Wong <m@xv97.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1396/2151] wifi: mac80211: reserve MME tailroom for protected beacons
Date: Wed, 18 Nov 2026 15:52:11 +0100
Message-ID: <20261118150212.853287430@linuxfoundation.org>
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
index f078bc8049a83..6f511ebc51091 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -5673,7 +5673,8 @@ __ieee80211_beacon_get_ap(struct ieee80211_hw *hw,
 
 	skb = dev_alloc_skb(local->tx_headroom + beacon->head_len +
 			    beacon->tail_len + 256 +
-			    local->hw.extra_beacon_tailroom + mbssid_len);
+			    local->hw.extra_beacon_tailroom + mbssid_len +
+			    IEEE80211_ENCRYPT_TAILROOM);
 	if (!skb)
 		return NULL;
 
-- 
2.53.0



