Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057101;
	b=vQ1LKdgcNsWQ45NSI1DA3T++QUChTSCKBwvSUp6/iD7n9stdgcxJxYqjNrOroUPtWW6c
	 rjXJsJLB+pidCJTS6iOls/kiZUXObb4Ty7VnTNmy4+8+aTAcj7VfkoLMjBcJkWjLF/6fK
	 4at9sIGkV44HPzeObVrARFGBAV7z2nWhluuPuOFn7T70ZPBEprNbkFhGpVHKfV7CL9tbo
	 BhqoerELvL5G1gFu0UR4SMDYTCqVqj2fWFmRmwP38SUxYmcyoJuD7Qty4h/ZY8r8jeNxX
	 AH+iRKxLbraphIoVDFyVHoweRSlgYiBhAnZ+eydSX6xlFrS4DmfqntCTrpYauAPCc2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057101;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s5VcVSCI5Rr5xaEQqkMvFKHTzLmgbNLUvsGQx8QCMUk=;
	b=P9C7hJalffCEwKJMcyHHi/F9HnMSyKF1i9cm+821b5SWa6e9VKfyZshm3x6934uUAdQd
	 jmtIxtQxQiR+Kvr+Idqa82goqFnUGUiABb1SCK8oAwmccd3jOMRU2188BKYODzRNyx1po
	 hgTnSZMBX3+xW0gp8Y8z5Ct3njXPAWHBgVFdgvDF/Qeb4W+IyD1R7QuCp1zJvP6vsIx/O
	 aSunXqkzGBbdWfro5IqEbswvcgMOqKLYSgfxBFQBrkLT2XR882gsQabi4kJMKUPbbXqvD
	 SUlq9x4NZuMSBeVBO+pB6mnsR1pHjQbRz9Bd6dy0T3pV9Pwl5c24zCExhUEwmzrfLfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R8aWerL4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DAD8606A31C;
	Thu, 19 Nov 2026 02:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R8aWerL4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACDF51F000C4;
	Thu, 19 Nov 2026 02:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057101;
	bh=s5VcVSCI5Rr5xaEQqkMvFKHTzLmgbNLUvsGQx8QCMUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R8aWerL4kmZwlxgDQGN5/5kZIxHpmB40w/h/bKeqeEVCdquvwPI3uqvfJS06ujJaH
	 sh6g3M6hJVljZzZRfFzGRprys1lt9oRDtZmsixlEtJYbqlx0mpf8Wz/cFvDHCik3uL
	 +Q0oLzIraeN9q6xpeYP5lZc1iLhM8SIOb/b+sxI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0005/1848] wifi: mac80211: shut down RX BA session timer on teardown
Date: Wed, 18 Nov 2026 15:34:03 +0100
Message-ID: <20261118145911.458351798@linuxfoundation.org>
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

From: Zhao Li <enderaoelyther@gmail.com>

commit e588e83e5c7a0f6d7a77dbbb58927c8c8cfd598e upstream.

Tearing down an RX BA session while a BlockAckReq frame is being
processed can rearm the session timer after teardown deletes it. A later
expiry then accesses the freed tid_rx state.

___ieee80211_stop_rx_ba_session() uses del_timer_sync() before RCU
readers have finished with tid_rx. del_timer_sync() does not prevent a
concurrent ieee80211_rx_h_ctrl() reader from calling mod_timer()
afterward.

Mark tid_rx removed under reorder_lock before deleting the timers, and
serialize the BAR removed check and mod_timer() call with the same lock.

This differs from the upstream commit, which uses timer_shutdown_sync()
instead. Linux 5.10 does not provide that helper.

LLM assistance was used to find the bug and review.

Fixes: a87f736d942c ("mac80211: use RCU for RX aggregation")
Cc: stable@vger.kernel.org # 5.10.x
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/agg-rx.c | 5 ++---
 net/mac80211/rx.c     | 5 +++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index 6ef8ded4ec764..b23ff9793fac7 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -103,12 +103,11 @@ void ___ieee80211_stop_rx_ba_session(struct sta_info *sta, u16 tid,
 	if (!tid_rx)
 		return;
 
-	del_timer_sync(&tid_rx->session_timer);
-
-	/* make sure ieee80211_sta_reorder_release() doesn't re-arm the timer */
+	/* Prevent BAR and reorder release from rearming the timers. */
 	spin_lock_bh(&tid_rx->reorder_lock);
 	tid_rx->removed = true;
 	spin_unlock_bh(&tid_rx->reorder_lock);
+	del_timer_sync(&tid_rx->session_timer);
 	del_timer_sync(&tid_rx->reorder_timer);
 
 	call_rcu(&tid_rx->rcu_head, ieee80211_free_tid_rx);
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 8ec630a4d069e..c7504dff7b4b3 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -3101,12 +3101,13 @@ ieee80211_rx_h_ctrl(struct ieee80211_rx_data *rx, struct sk_buff_head *frames)
 		event.u.ba.ssn = start_seq_num;
 		event.u.ba.sta = &rx->sta->sta;
 
+		spin_lock(&tid_agg_rx->reorder_lock);
+
 		/* reset session timer */
-		if (tid_agg_rx->timeout)
+		if (tid_agg_rx->timeout && !tid_agg_rx->removed)
 			mod_timer(&tid_agg_rx->session_timer,
 				  TU_TO_EXP_TIME(tid_agg_rx->timeout));
 
-		spin_lock(&tid_agg_rx->reorder_lock);
 		/* release stored frames up to start of BAR */
 		ieee80211_release_reorder_frames(rx->sdata, tid_agg_rx,
 						 start_seq_num, frames);
-- 
2.53.0



