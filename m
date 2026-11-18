Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039762;
	b=Cmu9EhEtvbD4Vll8O99OR+S1h5w6fZvr3ZjhiW8muhsDmX9K1YQrNhnIayORPVzVm18I
	 qOrZF6tdpZhZfMYKrbT1f/YPWg1Fbk4SCrjduW3PEiAQGoAB9xvZztUORXZlL6DzEBR8d
	 P751yYijsKbF4h06lckVELR+lDGV9Xg6ImcEAJiRoizWsjlLSqDVW5yEJvFQ28sDqFC/d
	 CFs5XsMCyHNlOoE+GUU+8RwxF0apUpizVw4LCv8vzxvm0N+BfA/bwKkFCE4nXVLAR8Phd
	 CezQUU+eHCMFJ4q45HNfxblpqJhnkpGO+DGxakOH4ZVndrUXN96NsxHG32JJ7fAJclg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039762;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=I+NfsdPsto2FGG/DBm3rsywrMkWkPq+Wh035c0ly4go=;
	b=CwcrBCacPVF/JOX+oAWBTTDXrddP1Nub3cdIDI5qsFtw7MmLfVqEeJai/J9N2vLdzDcq
	 pf1D4br7LiVvf0h72y3a0AujbeV7VcYUW3gZXMpQ606Ub6lb8YbRN9jWwq2WtxP1Cfh/l
	 dWhRX4z/emForWtnBfgTQ1zoTVQZGV3h2HnrdNLtefuPCCT1+ml5UVT+CWS2REFKVm9Xw
	 pHfthzEMbz41ctYk8rWtLKXpcSLflq8nxLLKzw0ZDH3KJ/WvZxBQFmDalsDHC1kphl+7h
	 wjKn6Z9BTA0VdkOR04BawJOr06y6xDUmKYSsjEYNTTBJjyUBEgP+taiCXdsYGH06x+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="BzSe/IqK";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02AE7606A31C;
	Wed, 18 Nov 2026 22:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BzSe/IqK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 586C51F000C4;
	Wed, 18 Nov 2026 22:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039761;
	bh=I+NfsdPsto2FGG/DBm3rsywrMkWkPq+Wh035c0ly4go=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BzSe/IqKIZBWnHiwZh5rTegfiWB1Ji0N9nQUGYwkoQcTtKjs6jUvdqnxCP3kKXpUI
	 uJ/ozwPY9HRjR9lXxlp//ulTFhGdk8i+fu0wv0PqfxkxVILOfa2rm896LylOldDbRC
	 PiRyIJOAmOmU0qu9qWIZXnZZJABrw0x5xAE5fG/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julius Bairaktaris <julius@bairaktaris.de>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2215/3318] wifi: mac80211: dont reset the TXQ scheduling round number
Date: Wed, 18 Nov 2026 15:47:17 +0100
Message-ID: <20261118150428.353787006@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b156e2e991d16..e2d07b00f5eda 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1335,6 +1335,7 @@ struct ieee80211_local {
 	spinlock_t active_txq_lock[IEEE80211_NUM_ACS];
 	struct list_head active_txqs[IEEE80211_NUM_ACS];
 	u16 schedule_round[IEEE80211_NUM_ACS];
+	bool schedule_open[IEEE80211_NUM_ACS];
 
 	/* serializes ieee80211_handle_wake_tx_queue */
 	spinlock_t handle_wake_tx_queue_lock;
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index ed0706e038829..0690c9004a4d1 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -4135,7 +4135,7 @@ struct ieee80211_txq *ieee80211_next_txq(struct ieee80211_hw *hw, u8 ac)
 
 	spin_lock_bh(&local->active_txq_lock[ac]);
 
-	if (!local->schedule_round[ac])
+	if (!local->schedule_open[ac])
 		goto out;
 
  begin:
@@ -4339,12 +4339,12 @@ void ieee80211_txq_schedule_start(struct ieee80211_hw *hw, u8 ac)
 
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



