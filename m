Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029085;
	b=n96eYXZWD3YMOROlhEujvYt1VfrZOLWfF3hJPZoo3c3WdDHCGEUFkuJfQ99LaByOZPv4
	 TqElPWfm9YRcTGK0IfoasWpGd5V9eJuDk+zJXQY81uQ24/Ey5WJAeTMMAgKaLEVSqTbTe
	 iEYZfs2PjfURLAqLHMfbgxT00aoKkYgSER7eXLesE2hWCug6yQORldHSW83YvCHDcdqXx
	 AXrsYUxPrlCwmCkfzA1jhDwY5wH2gSbzl0HTBOkpYul+5J9XP6u4wvBij+sOPXbhaexmd
	 JS+xOFS6wQtynCv9H55Us+Mwjt5PHP8RtpwvILR6lFkxtu//zAEbIwUIxZVCEAl83pA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029085;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VSWM8wZlzTzctllgZQV8bhgPqcy6JL3pfJoacm3kRrM=;
	b=kvGp8lKqmsiBHyWNZuM0Zd3hk2WAr/ZBrvKWJSPi73tJZCPiJwVA7EsHHWR+bpafOw8Z
	 e5kpSI09hLHKRdxLSVJprOEMksPC1pgm4kwcLabHniniDy8keelGScOeZPhk90Ls65PYJ
	 s0WLXAbrlsey7RX7kPGtnGcmAsbfr9l/MN3X+AH6CJ7VY1qcjlqL/0DLTVskvbLH3Z7La
	 /Y8Mf6CObsCnl0Zy+iRJ8Hq3BmkV2MzSlUdeTKjQ5yZv9hGTkoTWtBDI7FrFkPDg2DlSY
	 eb8m5DL3MCnVuLUohl+DGmD6w5VPc5v2uu8KWDJ4ZUARYhP3twQJ5ZDQTTgO5SlbspQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uXRlCMR5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C5AA606A320;
	Wed, 18 Nov 2026 19:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uXRlCMR5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 239F11F000C4;
	Wed, 18 Nov 2026 19:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029084;
	bh=VSWM8wZlzTzctllgZQV8bhgPqcy6JL3pfJoacm3kRrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uXRlCMR5RprHJtCV2kjKob+AzfBz5p724uPjhe4cO+80aDNKHZelHU+V1crAjQ1ch
	 L4n8iLyW3O3P7JtdzOVg7hLfJ6xYDZ1nUS7vKP1JTSEJsPWXLhc0Y9GMf18RdbS1vZ
	 k76wm3gKsGrFMMKVqkj+2M/G5yWfvkJFoJO3HUdU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0225/1756] wifi: mac80211: fix IEEE80211_TX_CTL_REQ_TX_STATUS mixup
Date: Wed, 18 Nov 2026 15:39:12 +0100
Message-ID: <20261118150017.243297791@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit e035900ffe9e8978f7c0d7b61811b6b578751697 ]

In ieee80211_build_hdr(), IEEE80211_TX_CTL_REQ_TX_STATUS is checked
in ctrl_flags, which is wrong - IEEE80211_TX_CTL_REQ_TX_STATUS is in
info->flags, so the check is for IEEE80211_TX_CTRL_PORT_CTRL_PROTO
instead. This works out OK because the only place setting _that_ at
a point before this gets called is in fact ieee80211_tx_control_port()
which was intended here. This is actually needed for correctness, if
jt were checking info->flags instead, TDLS would fill/leak the status
frames created here.

However, we can just fix it by using the cookie instead, that'll be
set for PREAUTH frames via ieee80211_tx_control_port() as well, and
no other frames.

Additionally, the code also erroneously set it, but that just caused
preauth frames to get it set, since storing the ACK SKB will also set
the correct flag. Drop this assignment entirely.

Fixes: a7528198add8 ("mac80211: support control port TX status reporting")
Link: https://patch.msgid.link/20260803141309.292711-10-johannes@sipsolutions.net
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tx.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 3b72b38d9e278..b8b8a2622cbfe 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2966,8 +2966,7 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 	}
 
 	if (unlikely(!multicast &&
-		     (sk_requests_wifi_status(skb->sk) ||
-		      ctrl_flags & IEEE80211_TX_CTL_REQ_TX_STATUS)))
+		     (sk_requests_wifi_status(skb->sk) || cookie)))
 		info_id = ieee80211_store_ack_skb(local, skb, &info_flags,
 						  cookie);
 
@@ -6351,9 +6350,6 @@ int ieee80211_tx_control_port(struct wiphy *wiphy, struct net_device *dev,
 	if (unencrypted)
 		flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
 
-	if (cookie)
-		ctrl_flags |= IEEE80211_TX_CTL_REQ_TX_STATUS;
-
 	flags |= IEEE80211_TX_INTFL_NL80211_FRAME_TX;
 
 	skb = dev_alloc_skb(local->hw.extra_tx_headroom +
-- 
2.53.0



