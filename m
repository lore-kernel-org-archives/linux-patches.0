Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023051;
	b=nDIY9wrMxWwlYXrmnWYhL0nsufLmq1V3WH55NSwXqCVaERfoUNzWgMmwsR2nC5G4IcWg
	 2KIA7OlEZBMNPUky29onoD5qJDJqf1KPta9urMT/iZOgYrZWkgOZ2QqUEaq4BXkKWTnEl
	 RvALda005MXPhWjPruyuXdf194gz55WkPOPu63uHDLen5jzlx0M+NUOWc/A2/OvL/NwOp
	 Cc4V0vb/n+FnHaKNh9gnkNXN6DbvV0hMGB4EPkQV5Puw7gZ1eM0K/2Zsmqk0vPdKsxj5Z
	 aEK/RayrYr/OmIE2/ehOZpNXy+P22NesMLkQ7FsDfWs5aDBx5SuNTq/6jUd4CltjFmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023051;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lPykutgGYrZWcuMXZ6vPrgEQpwn/mS9uwdfBxSf1838=;
	b=FFpkQ+ZoRIyv7KpgV33sWDAo6utY4LrxKc7P4IaPYr4evGNvr+3m3rfJJxBggTSMdHTi
	 cYs2vRl4GMLt0HLHr4G2khTMBcjD5ufIsweWpkvMmzQYdSGF7f+JrgBPKlg7XipjGh/+h
	 oqIY6mkk2Xl6L3PjS9YspYdp1MgS05ti9IwyjwpwCCaak8Heekf8AQXDKwRsdFqQWDgKe
	 Qe+mN1fMzu6d10dektzASChhi+W6LTmmiwuxmLj8YjRfHZ3Ln1jVRcOhpuwOn8lqIWyoI
	 XIiNoBZ21enPi3S/wDGu87Gv6hg9XoYjFc8slzGRQOFBQYpK8kM+0vVY0z4IcOtzNBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y5giS16w;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04CB6606A320;
	Wed, 18 Nov 2026 17:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y5giS16w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A2E71F000C4;
	Wed, 18 Nov 2026 17:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023050;
	bh=lPykutgGYrZWcuMXZ6vPrgEQpwn/mS9uwdfBxSf1838=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y5giS16wj23tg2waSGjq13jYJUc4xscJyVVaw36o+jnb365BlPzuh4UCKjx8fdmbv
	 3vvABL/UcK3KMyWvzlObdvJIxOvGsKguA31Hbni76fHFJB0pxlkAqyMu5S4nmqCrDS
	 oCRxFtllG+Hw3M/gFbXlD3DvLX0dAYHkoi368eD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0229/2151] wifi: mac80211: fix IEEE80211_TX_CTL_REQ_TX_STATUS mixup
Date: Wed, 18 Nov 2026 15:32:44 +0100
Message-ID: <20261118150130.123057067@linuxfoundation.org>
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
index f7cf7dc46cbb5..79d0f0141d4ce 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2965,8 +2965,7 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 	}
 
 	if (unlikely(!multicast &&
-		     (sk_requests_wifi_status(skb->sk) ||
-		      ctrl_flags & IEEE80211_TX_CTL_REQ_TX_STATUS)))
+		     (sk_requests_wifi_status(skb->sk) || cookie)))
 		info_id = ieee80211_store_ack_skb(local, skb, &info_flags,
 						  cookie);
 
@@ -6554,9 +6553,6 @@ int ieee80211_tx_control_port(struct wiphy *wiphy, struct net_device *dev,
 	if (unencrypted)
 		flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
 
-	if (cookie)
-		ctrl_flags |= IEEE80211_TX_CTL_REQ_TX_STATUS;
-
 	flags |= IEEE80211_TX_INTFL_NL80211_FRAME_TX;
 
 	skb = dev_alloc_skb(local->hw.extra_tx_headroom +
-- 
2.53.0



