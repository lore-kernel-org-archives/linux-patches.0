Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031694;
	b=F6XB4nS91RzN4LU8Z5vBvL2JTS8ufFQs//FlE2Arvs7sRBgYo86evghhs9QmNIUmuTvM
	 BiZUqEGgX46FMDsn/ugaF2/N+pbncGBULD5RVQki6+jEvq3Y08nYhz7QaYqxx+2gyYiuH
	 3MgHiO94k7X9dCpMgEQ2ELqbRE7wiYmqmfYOA50qxophRZdTArAgZrnqAJBLqmR1E7MAQ
	 GzekXAIdfxA7FN1YseEpJ+8FY7t3vP0juUDBrR6n8K2xd5EZCDeR9LbDcPONjjp9vpYuh
	 IYr8eRxyrf2iYX8qVp/ab1sJSe620aTwfRxX/80Payl/Q4FPYwjnT9s0i9pmPUmNUAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031694;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yuChmNluJiXdCVlYF3pT/VOC2cxlW1DQMsNuVNYwMgA=;
	b=zeuvsxA0vMB9fNweE8fNLl8UBA6NghefRF+ZZEavSCUp3G+q2TYe9kHuUEBYL82I3QWW
	 9D7OJCSn2KVGNBHgEGGdHOVzhFwFxyUb/LQwGwuIWtoPANyhYT/6u1OHKNI7KLUB8kFcL
	 vfcaaN2N+Tjczq3aBvLZP2tjw5arv8tSO71T8aAQIEwZIfYqMwOlKkPURYIvoFgFWnXyg
	 eDulmhTwHYbMhr7N6wlmKdxduMIWW4h4GlipSG/hfxEni9ajitrO/tEoMqDjN7Eq8LAS1
	 lxhWNMni8rY7rFY/xJ94T/20QYGTWw5B3i4f9obGOokXRnkx05wK+CGyg+tgM3apQZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Ji1YXt7/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6766B606A31C;
	Wed, 18 Nov 2026 19:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ji1YXt7/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3C471F000C4;
	Wed, 18 Nov 2026 19:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031694;
	bh=yuChmNluJiXdCVlYF3pT/VOC2cxlW1DQMsNuVNYwMgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ji1YXt7/NAyYFrF/8Jw98b6AWI5j7wb080O9WIMkZJrA0ZJtoCfCluO5E34vuOMhU
	 iXWdM1izJMNOI+/Zt/1K5Vuta20RoAxenqDfysRiigqkZnrwngXgRkAKC9XN73ej5q
	 JJqmNh6xAsNbR18SHACnVWOGBYGB5Pv6VYqNCkPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chien Wong <m@xv97.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1107/1756] wifi: mac80211: fix encryption tailroom
Date: Wed, 18 Nov 2026 15:53:54 +0100
Message-ID: <20261118150054.238850890@linuxfoundation.org>
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
index 388f728f3a03d..c4dc2553454d1 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -52,7 +52,7 @@ struct ieee80211_mesh_fast_tx;
 
 /* Required encryption head and tailroom */
 #define IEEE80211_ENCRYPT_HEADROOM 8
-#define IEEE80211_ENCRYPT_TAILROOM 18
+#define IEEE80211_ENCRYPT_TAILROOM 26 /* current max: GMAC/CMAC-256 MME */
 
 /* power level hasn't been configured (or set to automatic) */
 #define IEEE80211_UNSET_POWER_LEVEL	INT_MIN
-- 
2.53.0



