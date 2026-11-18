Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049571;
	b=rk9KNcmx2qO6icPidD02zfS6nOIijUgEwoH44z0cpO9jrlN96qxTiT7dHNEcfWnQeBXf
	 Rp1d4YoTMO665X/3NNnYi41oo6dVbInPXA7B6+afIsnC8IpLVHNZqRvVVVT/V1N+i+8Zm
	 JAII+ExTNfbN+KQ2BER6B+jePZmQHNKU+OhMay3qRl3+mviXfdN16KKpYfxDrwAA6gf9Z
	 EWU7NANgWxjojSXNYs/436CFMHXlHtNgfhggWqBQGW1ihGmVbBf1Lm3Z6g/eWwnJNKUNA
	 EOtDaJOJ3eRppI39tVZmretMsr9U85BpP0UQmFzeOOOaGPdHutdU8UKvTZKbyjEs92Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049571;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5vcl52uo7VA4EhIrQM2rG8uJaY99tDGe7CWgkNBoJ1E=;
	b=anX+EwHU3dv0FQsbxCKjg6RM0jbQqUNayCJKJ895LzqCfoYFXq3pZTgUrVEFRWWJNlEb
	 MmvGC07TL5iBc/1VLhqOfqa0EPy3xPASLisK9spfMBlQVv2B5utLSCGqX+hG8blgE77rf
	 TInPN7oj+tYIqMPVwnh8pB4hUl5CAmPNVmZQk0ngxYm0wLRQsrQwXfDomLPcnb8AaQlz4
	 naARlZ2Zu6CWCmqgnSJTdZ6aIIX+7CKssnCeIJNqJlZyhUfk33usCasGQVoNEs0TFkk2n
	 HmVPqG1xS2AN6X8qwXBOyDWOZUnNsSkjlTEzz19mjBz8J0E8XVoNF39Qgshj4g8rZDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fIiNy7AP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91894606A325;
	Thu, 19 Nov 2026 00:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fIiNy7AP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC7A61F000CB;
	Thu, 19 Nov 2026 00:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049571;
	bh=5vcl52uo7VA4EhIrQM2rG8uJaY99tDGe7CWgkNBoJ1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fIiNy7APcEeU3g2xD5U1OeULbiSA1DW1pziSXJ4BChoDIo2pwfYBF+XwKqYkpdDsv
	 QfNuT6aGdyQvMkCMKHiyG+K7/swH6gD2Rxa4qKWZ5+upb6dSMmGsJWRNZFlWLqfAQM
	 dh+HDKIeIL2uoRzHynH8pP3ETRuHQzzihhDRdwh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chien Wong <m@xv97.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2398/2857] wifi: mac80211: reserve MME tailroom for protected beacons
Date: Wed, 18 Nov 2026 15:57:12 +0100
Message-ID: <20261118150327.864573149@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
index 402a57a627eca..c3256eb8adae5 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -5259,7 +5259,8 @@ ieee80211_beacon_get_ap(struct ieee80211_hw *hw,
 
 	skb = dev_alloc_skb(local->tx_headroom + beacon->head_len +
 			    beacon->tail_len + 256 +
-			    local->hw.extra_beacon_tailroom + mbssid_len);
+			    local->hw.extra_beacon_tailroom + mbssid_len +
+			    IEEE80211_ENCRYPT_TAILROOM);
 	if (!skb)
 		return NULL;
 
-- 
2.53.0



