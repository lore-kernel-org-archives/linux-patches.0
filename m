Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031697;
	b=OLg1mgNz01UUuMtfMwjqRJhRkbUIfEjUAp4d8cjJ+ip5eTXFfERANunhoD8dfk94cKEu
	 kgz5dfLtIkzg7rXCNmy8+gy2Xpb5ScoFYIcistLQ6sm7cuIkpgay8xaDj9KZnmAsTjUSK
	 oWx02bzTaFeKI/6X5lw0304AFZt7GGgV3gjJeNqet9GWpa9a39q8eG3j+uVbY2ZPODmfA
	 LQ73T57gGVAzjnf/F7qHywPNC6q+Imr6JVbXX+sTu3AmAzqy6NEjx/Ivqa+Nr5HtE6bIa
	 GKGfLv3kxsJsmt6768pnpG9zN6MF1A6a6imJRx2WJ+An1DckAbxDWoO+zSOuFGyVzzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031697;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=c1SSEVaekZBJNzOx+AEbsZLZwDjRKkxD0YXBm8D1HhQ=;
	b=G2Hjh4pu+LH5Vr8J+OlHlegYtaCrhuE8yz77Fd4anq3FsbD6uk6mBgsSFiKb/+DBNFWB
	 mq9O0tQijmFexAi2nJvHBmQL9nGzy1J8Fx/FM43pHm5245ArrZ0pne8zSOYnn6dTQaro4
	 adJ2TODLcORMuLAyOdFm19LZjGEW0uk/tYrE9ztKQN1aKkS6F6p7cMOxqGzVRXVn6i/CV
	 7TxevlOy8uvA9Bi/KcZ1eAkWMW2qRYpWtta9Gn8IgQm5W7csZJ7WhUdoK/SFiRRoesT6f
	 8HlBLNM7y2A00v77klb4437Pblrq4ki/sZuBDUUVeKt87GRUaidcyvsE4r/UFkct+Hw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2HW7ItZ9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 516EC606A325;
	Wed, 18 Nov 2026 19:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2HW7ItZ9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F28E1F000C4;
	Wed, 18 Nov 2026 19:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031697;
	bh=c1SSEVaekZBJNzOx+AEbsZLZwDjRKkxD0YXBm8D1HhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2HW7ItZ9B1les+bgVJsGXTXLaJPmeulcMAu943SJ+XVCpYcn/PtpZ2K9kL9OapBRK
	 yirnv1HxB8whnxZ3dnBrMybIv0RqXgaVwVtEuH98SNdrHMHI33pnVX805DeLCxgtqp
	 tMJHHfRVOeqzuqW2Y8qrgpHx5yRn7mN3bCeoSek4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chien Wong <m@xv97.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1108/1756] wifi: mac80211: reserve MME tailroom for protected beacons
Date: Wed, 18 Nov 2026 15:53:55 +0100
Message-ID: <20261118150054.274404083@linuxfoundation.org>
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
index 88312d0a5372e..d6927b679eb11 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -5545,7 +5545,8 @@ ieee80211_beacon_get_ap(struct ieee80211_hw *hw,
 
 	skb = dev_alloc_skb(local->tx_headroom + beacon->head_len +
 			    beacon->tail_len + 256 +
-			    local->hw.extra_beacon_tailroom + mbssid_len);
+			    local->hw.extra_beacon_tailroom + mbssid_len +
+			    IEEE80211_ENCRYPT_TAILROOM);
 	if (!skb)
 		return NULL;
 
-- 
2.53.0



