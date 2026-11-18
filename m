Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029590;
	b=Ba++Xm0oJOmejXtuu0UC9o0hmnHwmpa9f6rLtzt9gCD9pOtZxGNirhCtBWEoOGskTnPM
	 RiHQyyV0H2BCB3Lu/l9GEvfNqSh/C7YKShA/0LKvcTXtrPmcu5VGO1nFs2rbabx1OMjEM
	 Nk9ZeYG6FEMpIzqwcIrihkVDm5gRVlk5Tuc4TEdzqUiHePD3FYs6CZP+24WzcKAVMgK/r
	 eAAcS/JlcRlVyB5kEFfqchcULL232sTstV2KZXKEe/nLL1QohnPKjZOQrKFJ/jWEPMtmt
	 0bAGQ7Qw1vN7F+5u+5azSR0VR8/EvvgUWzOI6IVS8jVjMkS22q37LYY2IjGsmOI+lQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029590;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=kjkg4zGB57E95iSogGBxic1vWIR/q+gxO1VPjuVRS5I=;
	b=QCd0SI0FuhJoJYNi5fLWn0X6x43oshHt9IF7Lex84mh0YYljVzMKhllRuVsXk1lItJwJ
	 p83xi30OzE0fVmMokJ9oy5NWVDa4GjcqbDukLN/HDlL/VTttPDpXcwU1eZXjW0V6S9o3y
	 0kHFzkriLMAMo2DAA996MMw6VyK++RK+eM4Ww3dGsf7lJPsUpT5qPFT9KDPF30LoiiI90
	 28uT0ukHiRIN3kePCHCsgYG6aytyW3tS4S3jldT2tEwncnwClKQ44+UroKxjvdhO0LOEx
	 q5TL9dv4/s5FNDA6AihxC2qF06jTr8uEJ1+HBtX0JetMyS7f18gdKEBUJCkrtMvQxtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r6ZYtQFx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A73D606A325;
	Wed, 18 Nov 2026 19:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r6ZYtQFx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB60B1F000C4;
	Wed, 18 Nov 2026 19:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029590;
	bh=kjkg4zGB57E95iSogGBxic1vWIR/q+gxO1VPjuVRS5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r6ZYtQFxpc9XCcFWsv1JVNCuVT0Gb/YOib9wAgkU8QSGznq28N1l2uVgomHqOHlWJ
	 WHYXMJ5E9b/yQ08FOTNPbRYDAGU74H3eNv/+/llmyj1X7D3gmDpl0cPY/35WigRA9X
	 v042DgLS9HhHvWCd4t9oRP/IOVEpsaAa4Eh/DTuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julius Bairaktaris <julius@bairaktaris.de>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0403/1756] wifi: mac80211: dont reset the TXQ scheduling round number
Date: Wed, 18 Nov 2026 15:42:10 +0100
Message-ID: <20261118150024.807389372@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julius Bairaktaris <julius@bairaktaris.de>

[ Upstream commit 8ea81827d3537db7cfcc82c008f052bb1bbe7567 ]

A round is ended when ieee80211_next_txq() meets a txq whose remembered
round number is the current one, meaning it has gone full circle.

When the AC exceeds the airtime limit, ieee80211_txq_schedule_start()
sets the round number to 0 to close the round. The next open round is
1. A txq from an earlier round 1 still remembers the "1", so the next
round stops on it and serves nothing.

Fix: use a separate open/closed flag and let the round number keep
counting.

Testing: ~4200 skipped selections per 20s without the fix and 20
skipped selections per 20s with the fix on ath11k (with my AQL series
applied) at BE 500/1000.

Fixes: 8e4bac067105 ("wifi: mac80211: add a per-PHY AQL limit to improve fairness")
Assisted-by: Claude:claude-opus-5
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
Reviewed-by: Toke Høiland-Jørgensen <toke@toke.dk>
Link: https://patch.msgid.link/20260908144155.756569-1-julius@bairaktaris.de
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/ieee80211_i.h | 1 +
 net/mac80211/tx.c          | 8 ++++----
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index c0e7db6fbec38..388f728f3a03d 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1355,6 +1355,7 @@ struct ieee80211_local {
 	spinlock_t active_txq_lock[IEEE80211_NUM_ACS];
 	struct list_head active_txqs[IEEE80211_NUM_ACS];
 	u16 schedule_round[IEEE80211_NUM_ACS];
+	bool schedule_open[IEEE80211_NUM_ACS];
 
 	/* serializes ieee80211_handle_wake_tx_queue */
 	spinlock_t handle_wake_tx_queue_lock;
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index e64811ff8ccb4..24ed731091bbd 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -4166,7 +4166,7 @@ struct ieee80211_txq *ieee80211_next_txq(struct ieee80211_hw *hw, u8 ac)
 
 	spin_lock_bh(&local->active_txq_lock[ac]);
 
-	if (!local->schedule_round[ac])
+	if (!local->schedule_open[ac])
 		goto out;
 
  begin:
@@ -4370,12 +4370,12 @@ void ieee80211_txq_schedule_start(struct ieee80211_hw *hw, u8 ac)
 
 	spin_lock_bh(&local->active_txq_lock[ac]);
 
-	if (ieee80211_txq_schedule_airtime_check(local, ac)) {
+	local->schedule_open[ac] =
+		ieee80211_txq_schedule_airtime_check(local, ac);
+	if (local->schedule_open[ac]) {
 		local->schedule_round[ac]++;
 		if (!local->schedule_round[ac])
 			local->schedule_round[ac]++;
-	} else {
-		local->schedule_round[ac] = 0;
 	}
 
 	spin_unlock_bh(&local->active_txq_lock[ac]);
-- 
2.53.0



