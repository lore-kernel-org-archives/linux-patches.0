Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061518;
	b=LqrR14YLOLGUSo/Z1dzSLh18pKrl1uzuJ7waJ/v69nBy3dLyhKrRDnY3Tg9fWmmUwh45
	 pigGUTF2dLDjLC0LULGf15qancIr4Il0ij1EofTjjUNEk/rTS4JOwkqyEhGEBR7/BGnl/
	 2f9j+0zl+tIJ5IPUJre2pm1p32+S5phv9H6i4e0tD4fMVYhzh0mwvWVilBqvURRa++ZC4
	 oNQ9eqJFFe+1YZtrHYaz2/QrxaPIhGzzRx3Wjm1WoXBEy/sSkyVHhW7+8RvW3rmRzo64s
	 m0eNh9ziAqDosDy2jl883zzF5AGYCwyWmyQB51qVUC6DbyFBr9HMJoTTjxrGu7oxf/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061518;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DdCGLEkmE0CZAuN/BHqj3AdlXO6F+bAIyQDBwJeM2Cs=;
	b=ZMXUMPDTzeoyudwisHNF/Z72OfblpQK6iJ1igg4JmJNIFpcqA+uPusycLVrOKYP+Qv9X
	 7rNVFx2xFuf87tdJ7wsLmtvBNRoCYWV+gt5fdM4iCk+xq5Sz7PQjgV0QZQ/HlaBchQYix
	 UM9iqu3oFSg+NojGgqFt/LaYuny9SZ497//QPalCiIURPUeLAvCxQNx1q3VnYpxyZ1FLG
	 usIIMM+BZ47tL5v2KTLiWk4F2yugsGAG8HznJtgdHOQ3XAuvcUdaY2QOtjs/suVhYMmX7
	 0Krr3A8aWr5zd87BGrzIemJSrk6xGebj4XQDIxDJIu2CZt+jpSWXCyaGTmBzeWkMtwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jWvSkaeZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E7DF60A260A;
	Thu, 19 Nov 2026 04:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jWvSkaeZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 278B31F000C4;
	Thu, 19 Nov 2026 04:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061517;
	bh=DdCGLEkmE0CZAuN/BHqj3AdlXO6F+bAIyQDBwJeM2Cs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jWvSkaeZUA86AAxwjh9LlPBHBwe569QH/VAYD2wJZOdgBEXg8LMVORDNlArmOGOMV
	 6Z4R9EcyqhicjZyYYdppXIBnbUyuGLS/aToXQ3nu9/tjLFzzvq2AZSQ6LkHVBnffGL
	 uYhkLjlNtBwgUdRlq5HvnJCKKaxT2r8DwCYz3V4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chien Wong <m@xv97.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1580/1848] wifi: mac80211: fix encryption tailroom
Date: Wed, 18 Nov 2026 16:00:18 +0100
Message-ID: <20261118150025.716954278@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chien Wong <m@xv97.com>

[ Upstream commit c49f54fd2abff08964677db8fdc1674c713ab42c ]

BIP-CMAC-256 and BIP-GMAC append a 26-byte MME but mac80211
currently reserves only 18 bytes of encryption tailroom.

Generating 26-byte MME may happen to work because the actual skb
tailroom can exceed the requested amount. For example, dev_alloc_skb()
rounds the allocation to kmalloc size buckets or alignment boundaries,
and the extra space may cover the 8-byte shortfall.

Reserve enough tailroom for the 26-byte MME.

Fixes: 56c52da2d554 ("mac80111: Add BIP-CMAC-256 cipher")
Signed-off-by: Chien Wong <m@xv97.com>
Link: https://patch.msgid.link/20261012140738.70178-2-m@xv97.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/ieee80211_i.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 2da452ec53288..04ccf036783b2 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -48,7 +48,7 @@ struct ieee80211_local;
 
 /* Required encryption head and tailroom */
 #define IEEE80211_ENCRYPT_HEADROOM 8
-#define IEEE80211_ENCRYPT_TAILROOM 18
+#define IEEE80211_ENCRYPT_TAILROOM 26 /* current max: GMAC/CMAC-256 MME */
 
 /* power level hasn't been configured (or set to automatic) */
 #define IEEE80211_UNSET_POWER_LEVEL	INT_MIN
-- 
2.53.0



