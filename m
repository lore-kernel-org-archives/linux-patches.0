Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016250;
	b=3Rm4mF0G9uea73oyUa4FFpnpeDzbIUwnBuLMNgndcAy46IOcQ2FIyEJxrwYQ2QEAfpby
	 wmAl/ZZh1W2peGzfnMTiuX4HcKFn6BOpRB+xlzmB3YHS0osp/rsr06BfrHGK8KYgDk2AC
	 oJFq47+Nnb1t12vxMNK8kie+PwH3hyPMBUVWvNWjFrXs0V41qqZx6Qu5b1WH/0psfqABq
	 U8mBBrqaqxi7blTONFjG7e72T7dJ84d/VWMI6Gymbm0G9DWBjclB+Q6f1DpaewWa1PR0z
	 t+7mf8MWTN9jISqPrN2LkYoDHhtX4LxbihN1rB2rZ1fjQaBZT4uPEM2auDknCJO/XWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016250;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=PZN2uFIYDj1AipSdGkm7uakP279+cleV71rncOd2tsU=;
	b=4jO0lf7QIz45gpTWJ/qbTTONqldOsmKtbtxtKuwZyPaWoFhkNdOkxX6WFbk3WHq5hZJo
	 94s0WTqKD5euzQZKUL4O+RCLDgeBSoooRprJT2801crrT8oFctLeefUSsccyEZSmH4me7
	 5E2eUJihsNAwKxF4F8oMzxQRXgPpW5cvVRJGEmyo8GIKhWKkMHXVOtRzYPdj+dTYLaMBY
	 qiZlAsH+IhUx3eA3a8N7/PuF2A0v58JAOTQ3+Y7RB9QWR70gjoBEjBmTSx1QH5LvBqJY+
	 3CSD39GQ+cA9tevLts+5oJpBwJzLf7ATSiGBhGgPrukaDpwUsdo7nNc4QZdh+theE2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S48ONHpm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7439606A337;
	Wed, 18 Nov 2026 15:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S48ONHpm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D0431F000CA;
	Wed, 18 Nov 2026 15:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016250;
	bh=PZN2uFIYDj1AipSdGkm7uakP279+cleV71rncOd2tsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S48ONHpmeyvBiPwqJBRMBTP5M/Fyd4yLBjO5O/btcppMvTsL+1iR/VbXtiliWAE2Z
	 bYb7wnZrNtUaDkLOrqUpspwel2U5eamfkyQ3Mu8lXQnkhnRNghC4L7pDSOJNfHSt7O
	 TSUanmpLjGdj598oQGIzo1GpYR2C+7IPedkeqfVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julius Bairaktaris <julius@bairaktaris.de>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0461/2651] wifi: mac80211: dont reset the TXQ scheduling round number
Date: Wed, 18 Nov 2026 15:28:21 +0100
Message-ID: <20261118150304.399642360@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index e624e2b17415b..e53ee000c4e38 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1459,6 +1459,7 @@ struct ieee80211_local {
 	spinlock_t active_txq_lock[IEEE80211_NUM_ACS];
 	struct list_head active_txqs[IEEE80211_NUM_ACS];
 	u16 schedule_round[IEEE80211_NUM_ACS];
+	bool schedule_open[IEEE80211_NUM_ACS];
 
 	/* serializes ieee80211_handle_wake_tx_queue */
 	spinlock_t handle_wake_tx_queue_lock;
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index e989772ad92b8..dcc8e84ea1a93 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -4227,7 +4227,7 @@ struct ieee80211_txq *ieee80211_next_txq(struct ieee80211_hw *hw, u8 ac)
 
 	spin_lock_bh(&local->active_txq_lock[ac]);
 
-	if (!local->schedule_round[ac])
+	if (!local->schedule_open[ac])
 		goto out;
 
  begin:
@@ -4452,12 +4452,12 @@ void ieee80211_txq_schedule_start(struct ieee80211_hw *hw, u8 ac)
 
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



